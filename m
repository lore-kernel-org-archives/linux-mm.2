Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1219C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9646B0118; Fri,  3 Jul 2026 00:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A006B0119; Fri,  3 Jul 2026 00:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FB26B011C; Fri,  3 Jul 2026 00:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD1C6B0118
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56F93168501
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:46 +0000 (UTC)
X-FDA: 84946149372.04.9260C74
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9CF87120005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LzcaU5qn;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052084;
	b=E5y9WMfuFAixFtnt3HD9h7JuU0GI98g3EdEn320qK5vvOeeNkyqvxaZIYZfYP4bxoYmXSX
	UaE4enjoH8AvLadAq03gLxFr2ePcuYq5Okx3OI3G/7rne9EiA55bxJ4i+tcwL1/DxtVgs1
	b3zQ8U4wQVQHZYUraK3FhglrfTQJM0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZbyJk6bEPc0czXml/6SkOrGn1z/Rl6aZYvCGmdzHvGk=;
	b=edBALalLmOOqRDnzWidgsd/QynjiFBma5V3TqY1TUpe6x5ecjoypOYKq5Jhv8dogDNN9NA
	3G+Fe47eQdD508aZRh/9nO83ArynBSyCN2NE8tOi3479DvMvSgcuEXTvTWFPE9t//ZZ0u9
	v4rZPNcedLNLvqOSoERuLnhc0u3ZEIM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LzcaU5qn;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-847a5528b33so63351b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052084; x=1783656884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZbyJk6bEPc0czXml/6SkOrGn1z/Rl6aZYvCGmdzHvGk=;
        b=LzcaU5qnAb1LecOpgNzAOF1l3roOCJKBzxLIjzesxxjBQSx0NPQ/A6ld7uUhHmPwr1
         X3+NKj6TZSxnVwgHr9OkVQaCY1jKRQvdr9+v5r9qPebhws9kA9LpvJcpiSkjCILiH/U6
         VNaaOap+Pe7gxGReS2NvOB3BEbgWm8whOZ/ez8Nvi5jPw6Ni6GEIEFjPaEkU7vKx/x46
         9yc6ig9xrF4KHecWd9+5fzJYc0t0j5wQ1TcPyTyfTjLI3m44PMX6qzBonx5b2/NLKZgE
         /r+WKdZq46dg4k6HO6+ipkoEvaidHmHGsCErl7ZHh9jool7LLTiQS6ELuM6TPQfEiglA
         wh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052084; x=1783656884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZbyJk6bEPc0czXml/6SkOrGn1z/Rl6aZYvCGmdzHvGk=;
        b=JlLwo6R3Lqbag9N12S7+zdKPnOvzPiq4IYqTfQ/F4l173nZ/6Ob62FfZQR8SeapIDc
         8n0UPlEsb1ftKB3zZ0gYIulL5g9jEvX+nOkOPYua+j9+npi5GBn1/1ep0txgQ174Mx/a
         h1C/MkK3ff9pZjeN6Kq4XrU4RF7uV9ZIUtVdUCw2IED5qGhlqiZxFnpnKIrXgr+/v6jd
         RQ2CKMcp/X95tuaV3MFS0iN0dVBse2jh30qWMsOzj5e974in8kcOPLBMliLWOzh60bfC
         oQG35iQ0MnAvGlW4iDhW5u5LL2YTj/ur7coKhv6D7403kRaIeWySQ90mPVX2COYRkQKx
         4lyA==
X-Gm-Message-State: AOJu0YwGSEsD4NV/mOx/gXvSwqtkALDc5y/N77WjkYS1ujGIZzDX0KO+
	l3oUNh8rgaxr6jPKimS6vvAbc4GK811qI7uTs+jBmHzYbn7hDqbjbbgk
X-Gm-Gg: AfdE7ckynMBJCZ0M70Oq/S0OVBpvN1lZrEHTaU7d1YArJfMuTHxo+P1gTxMGe8D+WYW
	b0zCnF/HMgFhnfcv3bIlSq89x980Tc8AU7z8jGXbLteJcNoMHll+vFLdIasK3imofUcPE+Dapj5
	viF5wpb3mDb7NeAyzoQMN4VJK/NHW3Kfs8Bvlj4eV2MlSiqjY7xUZ733QRFPyuyDdn4lM05lavj
	A4Q7P41UeI5NolpIfZJ7MVRPFlCqK60Mpyhdxja1z4DP/AjzeiKUsnKYsyVO+xcbePzdZeRch+g
	DOACUwl6kY10PN5XdWxUAUo+oMz2C9j+/Dw69wh3ndPoxh2Dogkqzx66oopY/dONHqj/GeHTjm/
	Zc11riEVk/E4vrrtssswkzYO/277k0oH/EMdzOJbrLH43F+Rn6zfJOpBC7Jp6J2LPlzpclgDH6P
	nfTTGKlS8=
X-Received: by 2002:a05:6a00:2e9f:b0:845:e04b:565f with SMTP id d2e1a72fcca58-847c503457cmr7663569b3a.14.1783052083626;
        Thu, 02 Jul 2026 21:14:43 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:43 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 9/9] mm: numa_memblks: use numa_add_reserved_memblk() in numa_cleanup_meminfo()
Date: Fri,  3 Jul 2026 13:13:29 +0900
Message-ID: <20260703041329.2797584-10-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CF87120005
X-Stat-Signature: twtrpn5scnjgu3ktuuppp73948jo7cez
X-Rspam-User: 
X-HE-Tag: 1783052084-773862
X-HE-Meta: U2FsdGVkX1/M8BX1lJAoPOCynWFv7y3UreNOEgCC9ielZj9YpPkg77uff85sgEgv2wA4R2ZQpbF9dxlJue12JZoNm1Ys1+NnVco9lukSlcn7dtJGLWCiXb3CfHmWW1x3u7FkyQ06VEbhBQ0DO40f2MHWkYEwIPNH/UoaWtmfA8P7/n9jWqFEqvis+hutWA4jNmIid6/Af8HSLAxoZ/A5oRnxgHjWlY0sbVaFWHlh9RAAR8SGt1AVkd1y+1S68nO2DnXE5s0yEzoGMGI14Fak85E+Lf9xSJlyS1sxoPVAUiVi2njk8IF9ovrJPR1ULQvORYFC10L7zwT8rRjCAtLwk+fMo8pq6pFAEIpj1DFOXkGtlvS3u9k2t4Tt4musE7gmJiiCtYMOorn/XQ3kTUEeDN8vAFwXAXiJr7ZlN9lSMW4Dy1Yc7GycJqSVRpk1fd3VqFMjddflouinvhScfUSPfOFPc/Z1JCPuhkwAYmbAHmTs3IETDpJIvrSzaDUSnn5vy6BVdevZESaOdfMhyqxzwV9w0zMXYxyUlGlZ6GSFoXGOF3VBNmNjkAlZq1qM2G+6jxv1xfcbXcD2Wnuaos78ycbI1FfOz5LR5mAc38TAL3yYBNHY3eKpKKtEvEWNswDFbAb3xoMGwTpRcq2cSypi0Dri7Uodgxrp79OoM8azEV2qD0ED7OB2bkmuBSfZncji5KBPWZsdMahwJ3LAnwFOvQppovewQ3CmKCdEMeD4IGOg70xEEUl8eiKgjQy9Up6s0UIlymtyPNzWJiVRq4qDWSO4mTh7XFZYwne4smm/zHrpmitGs08UtJOB1Oqq/GiMnVpFe6wNeR6EfUjZlyz+gcnQfy13YDfk7llVPnWR9abeOEJd40TWT8WsoPZEZqnGihs5IpO7YXMA5+3a+oSKnj5fFKeWGrMLosmMrSqrfYAyBKi4qenyWfUAiGiyE9xMH23PXKDDAuXhQU5WK/i
 O5lzycFg
 Hsb0esmw0SUzh85LG7sNLEckJcBZl/CEasJshpjf+mGgZnHSLgXssUN2aypE1FLDykrPcv0Q5hw3qvnFdwjM83jS3485KuU+yECdYw1zuqf7pUDiKxYfpf/gVQu5LL7iSGsNzZTGvrFcG8i8pE4ajcwT3Z3SL0wVyD7J9+SbOQRNHLjTJ+G4kgell75SnUAZ/8ZNKvAab+9bwUIU9jhsgPeeA5NiK9w7uMn070iPldriY/he451ounWZU86QpM+YHbwip5gV6C4yNE3wbXTp8JvaKOTZw+DkxsZJ+qjnwfVZS0gkfDn2BeEYVdRXc3h7fQSanXQldy+IDnBQm1seQaUZX9v4C+ypJHcj6TVfK2U8tkUggKl0ajbCKkC08QFmOF70HFjTnKNTk++Jz7uEawqUOq0fed237SMeTF4SPCbVRZQ4duU2KWoGgoJNVf5a6S78qH67i5eCdcpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_cleanup_meminfo() calls the internal numa_add_memblk_to() to add a
block to numa_reserved_meminfo, even though numa_add_reserved_memblk() wraps
exactly that.

Use the wrapper instead, so numa_add_memblk_to() is reached only through its
two wrappers.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 48428060e93f..426d17ff6859 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -255,8 +255,7 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 
 		/* preserve info for non-RAM areas above 'max_pfn': */
 		if (bi->end > high) {
-			numa_add_memblk_to(bi->nid, high, bi->end,
-					   &numa_reserved_meminfo);
+			numa_add_reserved_memblk(bi->nid, high, bi->end);
 			bi->end = high;
 		}
 
-- 
2.43.0


