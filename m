Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792CECCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 16:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1037E8E0151; Sat, 25 Oct 2025 12:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBE58E0150; Sat, 25 Oct 2025 12:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B808E0151; Sat, 25 Oct 2025 12:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8B068E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 12:33:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25AD1160110
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 16:33:34 +0000 (UTC)
X-FDA: 84037182348.27.422E32B
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 74880140005
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 16:33:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eKl8izoV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761410012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GldqH8fEtUrzkHne1rF5BgiofNp7hGD1Vw1w37mqgw=;
	b=PcZgzxYHxW9yEC//fmNb6FF0M3eoTVVpgjaWCMsapHXI0X+jkXaPfnw9rhvBtpDKQzh/vi
	9XzZKPC6bTfMSmD0CX0WZbkAAzSvWB53/QnuELhpq9QdSbqdk2iDJvKpWT7MLr3OMIshCx
	ToLwzQpBMheEe4OPCObAWx2VGCzEUs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761410012; a=rsa-sha256;
	cv=none;
	b=zkRcG3J2nYhceSGE8dXMYJopYwq7b6kYdC61+usE3uwFZYbs/rKqQ+yqXP0Gg3RSjxqAdy
	2nSQNsJ6UFzbe4lTdP0acaKPmppGyQFthSOZdVaGULqrZCnCCnjNURdDVIuA7hWIyPpz27
	aap2lapnQVx99xaIQlBBMo+P8tnYw7I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eKl8izoV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-87c1f607e72so36389776d6.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761410011; x=1762014811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GldqH8fEtUrzkHne1rF5BgiofNp7hGD1Vw1w37mqgw=;
        b=eKl8izoV4fIBdqXtGpKdSRcsH0F2PkM7Mpc7QomG0Zb1H/nMwsdC+zptFV619NiZDY
         yAVgL0L5FjNhD7gj4027mh3ehw2dxMwbd8VPDnZaEcAr60+HMytwhc+JoGJHFpykwbXX
         owXfxYioF7B80c97KeB8VALmZyGNYWyXdJlkvGOqAmqwo45QjRh3eq+fLSpGJl5epBQB
         Y/t30hDOXN2kNy8OYc9kkD+hLhMYn48p/cfXexzLLBoy2ctvF92R5VVQ2GzysJSuClbd
         is0R9SjjVNOKkZjzbv7bOHiRC0ESFew6qWdbCMn1hIwBvmthdx6+apy0gbts9tQcKTbR
         KYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761410011; x=1762014811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GldqH8fEtUrzkHne1rF5BgiofNp7hGD1Vw1w37mqgw=;
        b=t44bqYuwfcyhuzgV0+mheLH4f22uMoOevczZv/qunUEcjcS1d/V0khhIpw2daUJc19
         pLtgLx56c/GLeNmBt56agLSmYNUYeTs20f9r73EelxGpVeEs53iEEJWy1Nb+XQWOGbc5
         68guGwL7vgs4RtlFHjOI1wAdkm+rX5auoOCJd09pO2+Xp22WAMlV8+VDAWJqLS4A2/Qz
         j6XQSN2fMD36+dHqYIU8a0QnI1l3SlZ1CJ6huFDWhUOKRvM5xJ4vw+LDmhjJHEEPHN4j
         yzEbeLGKlA33t4Rqtyv/B9C58Nlu6xwJnxBarUpk/1CS4CP4+mzj/AHazE4juTkn8UWl
         NzAA==
X-Forwarded-Encrypted: i=1; AJvYcCU/FrqX0pjMPL6O0NyVvk2GfH6XF7xTSF6y6XUgKCYWdpyCVGmXj1UfLQ51VVX+uh2a7y+1RhFKWQ==@kvack.org
X-Gm-Message-State: AOJu0Yz04R1TpioowVgPESyu9eohGzB8MD3l2vqKA/1sZfqjbK317gpR
	sqLink9W+jzQ5Xjmz4eBuNb8cbfYFFHRAxZeBF5vzZE07OAJsieLBNkT
X-Gm-Gg: ASbGnctYsQe0GG+OHtaLHCWsI2+27yXEegv4t5jh8tS0mje8KB6S1xrqSbLQkG2LN/N
	QX2k+N72WzDxD2um1Xs+KtuXBHaUUaL9mI8ObxnJRlGrlo3QxY6eiV/BXXqns/097622Elk7h5N
	592ixtRQbX5ag/gPuQtvKWhEMV5jbpS+3amoe1T20AGox3UUtNPqSJ9WG5KYXyQnBFzfCeeRCG7
	dSIvHyo5sy7gqw8JG9JXDRygB/8jzSHwXCqEWuh0QPs4jhV/KxakMmQhstYI+Jpv9Z6vdAyGm1O
	XIYvJdinq0k3gUsX9ibCAcJOMM4UUPEDVMFkmJnuOWMCprHTAfOc2Ntf0swcjgKTnvnuMPWFtb3
	LtsF7u5SwOYCpL71sHkqBBZOn37xSZiQyJBNSjoxEW2D80EgR9jBOel0A42BHnLWmIUByW8FV3e
	Y+ElUkzJE=
X-Google-Smtp-Source: AGHT+IF5C8Vr5mRwg1oABB1oICMMdDXxfhjBtJc4JAfiQSgZg7djSzMhTj3NDF8UyFf8e6ttXMnqDg==
X-Received: by 2002:ad4:5d67:0:b0:78f:48ef:d8c with SMTP id 6a1803df08f44-87fb40f481emr83956716d6.22.1761410011494;
        Sat, 25 Oct 2025 09:33:31 -0700 (PDT)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48a7467sm16284746d6.5.2025.10.25.09.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 09:33:30 -0700 (PDT)
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: [PATCH 17/21] mm: don't use GENMASK()
Date: Sat, 25 Oct 2025 12:32:59 -0400
Message-ID: <20251025163305.306787-10-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251025162858.305236-1-yury.norov@gmail.com>
References: <20251025162858.305236-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 74880140005
X-Rspamd-Server: rspam02
X-Stat-Signature: cr3gczj6msmz686mwrnkhnz39rkadir4
X-HE-Tag: 1761410012-680040
X-HE-Meta: U2FsdGVkX183N9OZqB/N2qkzXTs/gI4yaIzl2EpS1PdCNwXsxcs1FiIOrXXcnVQtWwsMagnBwxwAdtd5ILGEwgitBEV6WzONebQUg94WnFxuhhYmYTIGh08rKBE7mhMOzWusAT1tcbKRXhPMRHQIntr0R4YAQPHhNfGzxEjt/+YKPhSqK1vuNjYm5vOYVqQnQDW6rrWPN/BscLlE5WsEWx+8ZEkUnWXxnAE2DwRfamo2OILRofHcuyU+hzKKDBYc4eLFC1qy4f/Ag9uZ2hEMt5GiGWhrEr8otKTUzYevrZK5ZzHh3Zsyxofw13p1oW/xX041aYhrzOico92y+e5vB/NBh7vJGN9X6H+uwo39YPEDarLFJWdj6XGJH52mTlfX1cS4K8KGv9xgL9oGy6J5Ra7/vVcmo/Hfs9KeBqZ5BzmuKO4H/Z/n1ARbTbsdfD9t2fsqmKpTAWHslsIInZWsH6pY+9KYJ226Oq4xrpLQJKK2PhangPor89u9CZ80HSv35FSWv5xsqXHq+vgo71JXOZ/Fwcit3/AoiV71O8m5sYJQ2ZjxXJKHt04ZBlsR5gs4mXFbxwLS3F5OpvnYhc0Ux9Zsje2IU6wUdMIJG+Gmx+domx+t4Lh9neihPtaDOculfAM9aQI7fv0M816DWESbMzsm35FbVZN2OH4cg2p8GXm+oPmB3pY2oFE69IjmnjKQ1qUb7Wgp0FmwGyG1GahFdAjO57d2X1Ur1uCI+SrmYBaq3dggfI2Wl7vUUcIXqKDGv7+7M2sfpHBMshRAvVDplZQB39dW5THfD3JGP3SwOCcX3DK47pxol4jqEQNb6ffrDHwwIfqAnrXrp2GJDbB+f6CmcVl63TOrK+DaK8UiVOW+KzHlNFBQDZzqAkyQ0ujZhWOslzg9B2vCA3/PH1QesnytZAjH/o5qBZvu7fiyFMOcbaPN0aVe4oaeVllt1lHZy7m53ZkpKyJrSdsP9YN
 SbGcqHQn
 dxCFu0Si/7ns6LK7EfamOk6k21aNSymOpwnpBoYTRKhpZ1Yi60bCyd2wrDQsxmsIoR3qWoWNKsW0TwaUBpPAS/I8LUTl61rtHmR85wURi+3SNrdWc16M9JL18te+rxE2fZgPITIJrVV0wJIGpcDx9QAuM2ZAX2NJLGZRcfNT9wdmnGyJodaKL+evkWuE9CTPmOpNB2lS8dGGi4J1YaSDRi2P0n7tYOb37boflkGZiWRccVOsWCM1Gkfkjlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GENMASK(high, low) notation is confusing. FIRST_BITS() is more
appropriate.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 mm/debug_vm_pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..b722dc3c091b 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -40,7 +40,7 @@
  * expectations that are being validated here. All future changes in here
  * or the documentation need to be in sync.
  */
-#define RANDOM_NZVALUE	GENMASK(7, 0)
+#define RANDOM_NZVALUE	FIRST_BITS(8)
 
 struct pgtable_debug_args {
 	struct mm_struct	*mm;
-- 
2.43.0


