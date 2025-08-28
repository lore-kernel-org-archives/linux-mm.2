Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AAFFCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 11:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A340E6B000D; Thu, 28 Aug 2025 07:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E44E6B0022; Thu, 28 Aug 2025 07:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3C36B0023; Thu, 28 Aug 2025 07:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 790AA6B000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:59:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE342140136
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:59:11 +0000 (UTC)
X-FDA: 83826020502.21.23E00F5
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28D92C000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:59:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="g2L6q+D/";
	spf=pass (imf28.hostedemail.com: domain of 3jESwaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3jESwaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756382350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+rtF09vsyR3z1vquzLvFEkrCt2s4j2fQ8fnMbWB46M=;
	b=gAkIg12le1YXJQlzfBjVOJ9CbPKPuhBfUEcRmbLpTTv+slcLAvWAzcOVYWwPkiDArsRzk7
	EYIe3vqeEtGxGa6HSFJLE1b8aMrQW++QEeSisI3Jsu5E4P1VTi5Hukwji4rszm5YwEBD2r
	RKKKqso+P65yb8pByjUoSIrjAhEfNVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756382350; a=rsa-sha256;
	cv=none;
	b=LmZg4jHa/bQ6KPFeCPh7GZ32XBw1CKAhhSyyHJOkDs0IlzZHsUwCWU0MOIpXIYUmye63LR
	Rr+U4XEO4BbbrOd3/xCbO5nTGy95TdiHpGpQ7+22rqUgsExT6fxfdHFHbaWhD44goepvs5
	aOjybKenXRJa3sR3Dznq6sJpZcmD36g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="g2L6q+D/";
	spf=pass (imf28.hostedemail.com: domain of 3jESwaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3jESwaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ccfd90630aso397636f8f.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756382348; x=1756987148; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+rtF09vsyR3z1vquzLvFEkrCt2s4j2fQ8fnMbWB46M=;
        b=g2L6q+D/liGS7r42OyFFYROGGfDycDwWtY9ATI7Xef8NpJtCbiVTGhAyUGURDOMxhJ
         ZScycSuGpUXiW/uSQ+NOmoGzdvKyGqo1NMcqON/u7NJM7q6MyYzA6lrUHgSE45KM3kIv
         Hh4QXwSZA+1eZFjvGM0jy+WlScfver019ru/no96DMNSEkLjwqs23aEtlqlfdhRYya0i
         aMpcu57iRBaXwioDZovH9FC7fVVRdj394XuyyIrYmZF0PXRGKE8pROiaYjKC6BjTe6Qs
         BY8PWtvji94VcFK+pNHgFT9KGukPpnnQBEJhhgofZDbqgcSZJWjvN7+JiyOdwBMntk+/
         aPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756382348; x=1756987148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+rtF09vsyR3z1vquzLvFEkrCt2s4j2fQ8fnMbWB46M=;
        b=RZwBHflc4h1wcuBgCYPxC+YpsoDfNtyDcuWhlVtPmXD2ALndfxIBVrLM2PRmZb1P9o
         MeQDTuBFVF5Zcerpx1l3EZrjDmd0cAgYxS4gjUewgPjCj+NTgrUPpYKGCWmkMrY3a+K4
         d2kQTLRPvBgiaZJYDu51HD1Vw9FoNLHj9czkV/KMzXvPxP0/ujGlSBZQppPwmqGSujDV
         k1HdxrKoEQ/j2LP/NqYgxkmnW9Zy9K0fkYDSNvaKcdj2lIer4aq/hThQ1yh2OTPcX0f+
         +GBtFbxCQIB/92BHJSI9n9jQ3tZIHOFctjCH+c92QUYUZCn2QBCS3ZJ9XT+jJ1uQe++I
         dsAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhQnl2D0gd3Rp+QvDBEIUnIUHVn1apzAWtGTiptkqIPkIeOZzbgKxuDHvuZ3fdakdj4VTf7nMiWQ==@kvack.org
X-Gm-Message-State: AOJu0YxBUtMJWbs56uzBYPnnjOcfoVwEwREBNPWa+AXISxeG9bdSHONL
	ISdSKCt1SYytr06PlMlETZUH1QDvUpB2hjxBiDWaMIK2lsnI5bQWVukkFbMpaj8tYBfPD1w9W7q
	3Q+evrocJCw018Q==
X-Google-Smtp-Source: AGHT+IHM+z4NVdXcW6ETQKsm+fLI9Qi/C+PiO0rUWizOJbkT9ESYF03mbeOYGhjfDtE5UUjwF4japFOv99SrKg==
X-Received: from wmbji4.prod.google.com ([2002:a05:600c:a344:b0:45b:7262:8426])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d87:0:b0:3c9:469d:c054 with SMTP id ffacd0b85a97d-3c9469dc236mr11331425f8f.63.1756382348227;
 Thu, 28 Aug 2025 04:59:08 -0700 (PDT)
Date: Thu, 28 Aug 2025 11:59:07 +0000
In-Reply-To: <f9713ea8-4e3a-4039-8cee-bf64edf2aa99@lucifer.local>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com> <f9713ea8-4e3a-4039-8cee-bf64edf2aa99@lucifer.local>
X-Mailer: aerc 0.20.1
Message-ID: <DCE1KVGTF2DV.3PRW2Q6PZ6KCA@google.com>
Subject: Re: [PATCH 1/3] tools: testing: Allow importing arch headers in shared.mk
From: Brendan Jackman <jackmanb@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	<linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>, 
	<linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28D92C000B
X-Stat-Signature: hidb196m9wsxuoh8sb49kcdodb3tby1n
X-Rspam-User: 
X-HE-Tag: 1756382349-620949
X-HE-Meta: U2FsdGVkX18i9Kg7BMDCiPd42fsuNk7vouHC20m/FUUCRecBuQJikgr3HJ4w0rJiItg1nZC1QAqwqdjSqJozKNO+QcgqiYhXSsM0RgUEyRRg5miKz+XdUKVswDuCd/DbX3Tp5njRNWvi2kYktGtzKXjnovgMaZAVYqSWV26bURHOWqbmXR9l6lAqqg6xN8kkC4b3uRGMK6JOlvyTg6LHSAF7Sj1sB6zU/ctrkfLgtfUcfu3Wqav8KAL4wB4aFMbyt4wsrWao0+M4i+pIpwgBEj+Vh95L4XmN2LTVFT7mOG/ym9POf1lOGSaqVfr/O4+e/mp8Z2DzxIpzU2Leg/Weu1puvKJonE7RPJ/BlB6ArlHvZ4gQvJwgOgA3pVMDt+eI63+pCSJCllrCb6sxZ1QnA3ILok2VPQTVr1ukPZL+3wQsvXuwdv1YgQgn5KEcxoeWYTFg9ez8IucVNwmCiKOCC2u10B3vsTBmODrzKGeLUkWcV8/M39/ku02M+JYMfL0ntUtIPhrjZ4ct88qgvuOjn9ADBo6PJ4expOTSv4a/JBQ/z1Hb8hAMjwcdlgA2Jx6DvogO65b/2O4pFVqMZUBLNoluzoG0cIFZeRF3q/Q3Wclb4kWPDVfzcyS1bCdJyZCKbVp2gWM4OfXpYINUt00b9lUonEoEn2lEKZW7Vn9/4uR6h3KQMpRgNBIQlK9wv24QZHq2XgcRVagb28KDgeUBn6PoSYEfBLd8JiFywCbMMDAN432wPpiRuY5ZI2SiXOIUfkM4NdQITBEXGrPBUmzzhhxoe08XbRs4x0vqnpJFPMueigPiQc6g/VYZxLNfF0ZVfedcSN/r8ie9qhZLz4vbB5Jf56RPv8u4EMjuSfSElCN/vk/1HXC5two0YXi11N0ei1WMHjHCONCe2baUrua4iGoHv3xSpeXJxX9dk5qX9p1kBBoZv+n4Vg2BNp3HaFemcrklTmugslqj9WQLFKa
 tMiW1B20
 7ZTv1oVrEQ/84211pJ6bfi2yF3qfuUGxqisFJPvXDCgV8yGl3J7sxkUs2rd0f6w9nbW5dliWkde+ayzQC74VKY1mKKc5l7JyMkRo8aQh4XZXFK7C1m0MjUSjGtpYOSrm3pp0XDw6yqzQPOqltQOm9KxsMO347dyPQSDpJelXgXo96gQmmLcl3ry/jIvNyRtssctuvi+UQSyP404bQk2isprf6sbUkQCmkbv5F4v1he4mtpxVrQMDrKqD3omDkatpeLOff9R3LFtAEay9uWgxLVOIgGz0ip83kJPMIak/IF5rYLvzbMgKLgZQjmaIGxddmEJiuZGOp+ivd0fnReAkT46Ifg7XV8n8XOhttBbVMKkmkucuhuX35LZqJbKpJTiAS2JWUQYdiE6dUCX/dOXRtSMP9E2TlvFzsgBy7qdHq8VxB2q2Cm8tgjgo8HEs5/nHlDPCjw1u7oyW1RO+gzYCNUOZbqahXP0r/JyPmACmI5Ku+EUgSy2QvOyuOP8xoXsmTB5uiZbD8QtmWSU1xrlacI/EMsUdx0/aGO5uTLlJPGt7lAicyxTZgAxizTRDNSo7LWkxTFat6ISqQCs4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 28, 2025 at 10:23 AM UTC, Lorenzo Stoakes wrote:
> On Wed, Aug 27, 2025 at 11:04:41AM +0000, Brendan Jackman wrote:
>> There is an arch/ tree under tools. This contains some useful stuff, to
>> make that available, import the necessary Make helper file and then add
>> it to the -I flags.
>>
>> There still aren't that many headers so also just smush all of them into
>> SHARED_DEPS instead of starting to do any header dependency hocus pocus.
>>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> LGTM, + works locally so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
>> ---
>>  tools/testing/shared/shared.mk | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
>> index 923ee2492256b693c5cf16cc014d9d2410be5457..937aaa7623320da1085a8e0f43f6a728ddd3ab1c 100644
>> --- a/tools/testing/shared/shared.mk
>> +++ b/tools/testing/shared/shared.mk
>> @@ -1,6 +1,8 @@
>>  # SPDX-License-Identifier: GPL-2.0
>> +include ../../scripts/Makefile.arch
>>
>> -CFLAGS += -I../shared -I. -I../../include -I../../../lib -g -Og -Wall \
>> +CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
>> +	  -I../../../lib -g -Og -Wall \
>
> We're also adding lib! Very very nitty but maybe mention in commit msg. But not
> a big deal obviously!

No that's already there, it just looks new coz I split up the line!

>>  	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
>>  LDFLAGS += -fsanitize=address -fsanitize=undefined
>>  LDLIBS += -lpthread -lurcu
>> @@ -11,6 +13,7 @@ SHARED_DEPS = Makefile ../shared/shared.mk ../shared/*.h generated/map-shift.h \
>>  	generated/bit-length.h generated/autoconf.h \
>>  	../../include/linux/*.h \
>>  	../../include/asm/*.h \
>> +	../../arch/$(SRCARCH)/include/asm/*.h \
>
> I'm no Makefile master, but I'm guessing this will always be defined _somehow_ :)?

Ah yeah this is what the Makefile.arch include is for - I'll update the
commit message to be explicit about that. v2 incoming shortly...

>>  	../../../include/linux/xarray.h \
>>  	../../../include/linux/maple_tree.h \
>>  	../../../include/linux/radix-tree.h \
>>
>> --
>> 2.50.1
>>


