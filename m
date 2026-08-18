Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85EF2C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1E16B018E; Tue, 18 Aug 2026 12:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9922A6B018F; Tue, 18 Aug 2026 12:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8842B6B029F; Tue, 18 Aug 2026 12:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 618B36B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2A741201D8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:49:24 +0000 (UTC)
X-FDA: 85114975848.13.1FE1E74
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C7561A0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:49:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rtLB+Vkr;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787071763;
	b=0hCLZf0IEX1UQMUKS9af0xEweDsKw1KE679qBSmG6KBNjeOLdZ37AcJhLr4RpKrEfRSu2i
	w5i2ZocEoG19uXy1/wghxShZ0XdGNVsmXZY5vGptJt42fuJNiMVMpxxcv0lLHPlh6rM3vB
	5uR6LZQvvMty3RNOKNu4T4BqjhpkHgY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rtLB+Vkr;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787071763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q+RD0GTkqhdPFAyj8KffdPyvk1PlttTlFTDZzurKKiA=;
	b=WWNoGyRTFEAIxxmiXanqvpl05XB8gGjfdvxPXrBCPvlxx+z5qvXvby113qphuE2i4HISf/
	O5707dnVAqfIr9kCyRqaMol14dH1imOGMWSDulR9bGcrYa7n+RcdwPIdfM47E9w1oC8OP5
	9mMRucIwfEYHCbz+0PIA6xvQcsKLx00=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ceb096e675so672955ad.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787071762; x=1787676562; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q+RD0GTkqhdPFAyj8KffdPyvk1PlttTlFTDZzurKKiA=;
        b=rtLB+VkrCzRfGeUkgOCznin5vLqfIm0d0zicprfU4NgGLnaNBIENIqgjtSkZ3EiT2D
         Z794Knp9UdnELnM3nffLGxQ1V2p+PggZMPPg0peUPuLoAJnF3duDY8orTOVm/68J6KkK
         aPYX8rPx6okvDNho1dPVfvfVjAtDHcYu7JxsbczDGNWbbtxEs79+rUlxzt5FK6XNmXei
         eIPNnmOc/+oYZkxr2kgUVxJZV7QeNZ53ayRdFawbiDrD/thfdhkV7Bd5eNcwyHHe1eQo
         pxRt+c0MiRVWqJScnHFYekoH9rN5flQ2jbveqOtFQHMbdPmQeFqIcuRgEVhHiyRfyEfm
         hr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787071762; x=1787676562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q+RD0GTkqhdPFAyj8KffdPyvk1PlttTlFTDZzurKKiA=;
        b=M/nbx1dlcEHiZ3VgW3meNMPFaYups77AErCoWNl/CbGu0hDMRPzVyfJCV8rly/vfg+
         lqtW65gYdU9jxXwVupSxrfgWMf6L0afIOQUVAz499O5ps9BFXQklhOu8qhJbr8BJp/4G
         g0HV7K2Ge7aMSMkpOtTrZJCuVRvP+X1VxWwo+bn9UclahrfGlO3iCXgMNTtRAUl00SMf
         V0MlWDXMdK1s6dJD4h2/500oVRmvzaeEbgmjmeUulWP+wn0EwDyW/3XOSv733GNRzfYy
         oDqhek0ryAMmltZ1vcn0EZ321JWP4Q+FL/ucl2GHh5T64PQsxcurmp7JOH2fH9LD3ypc
         YHzw==
X-Gm-Message-State: AOJu0Yyq09sfh7hpHCeqNivkyMMW61C0GNZeSaFe6rc+1t6302gUIuRr
	pjaY0YzVCcj6i9DOSYSNe3J56UmOV3eef/p78/Oo6Z7XSAIoSGtZ5aGJKelA6A==
X-Gm-Gg: AR+sD10lTgHX4smFCQjXOma++vaMKIV5ByFdKZlIV35jkv4iN6C5gWqzcpHfwMrr2oR
	a+5oelPlkfDUl3j1TtPsj3worEiWA+4pp4gruXDcKIDoS3/udNsKvLI9pfG+L8U25OCQiajyZFz
	P350ZEMNQK2BwYB/UH92iHwCkjRFUHe+i+QGn84Bz0OZecPWT7HwbOvSlLTPBuOs8lbmLlUsiQk
	KYiIk3CSqyGguS9V6/snD2Rmi8JHTTymxfRvXk57bDRIhPtM/DdFfMuyezZpXo1svGzjQkbVFqr
	9OjlC/YObWipnU2cLqfQiQTn251DoFXiTeYPyGCnOBJfVVP7JCe1cdWAYECLRnbC++okpzcHRcF
	fr9O9JgSr75xpJYwJP/dElbrDh+RIc1ehBwybd3xVW5sI6CljzkjWsdyv+5SU9zLqePIFrVSNCr
	HXGH5OgcaPNxG+7eZL3to7xijVA5Z71F3EiFr8OnRUdkunrp1zf/1n2Eo=
X-Received: by 2002:a17:902:ebc5:b0:2ce:93a3:c16c with SMTP id d9443c01a7336-2d3b0c67d8fmr454700705ad.12.1787071761812;
        Tue, 18 Aug 2026 09:49:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1ecb22fsm17721015ad.70.2026.08.18.09.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 09:49:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] percpu: fix the comment about which sizes share a slot
Date: Wed, 19 Aug 2026 01:48:30 +0900
Message-ID: <20260818164831.3138490-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C7561A0006
X-Stat-Signature: iz6fzz9dist7ypyqjq8om6ffq5agnhbb
X-HE-Tag: 1787071763-757995
X-HE-Meta: U2FsdGVkX1//JMmne3UY/hx1bc8aiE8fLjmAclHCuv1eCClSWqweJS9jOgSNT2X19xjtYuMi2VtpzDjaaX6SXRdOlp4GDq4hUS9eIidTpI5h6pHggITurG99K7Gj++N0dIkcLTuxDkz1U6BAtofJu+DQeIx8HpS3N/igSk/Ak5+UccD4ZSpUOf+6ElWXDT99EFqzFFWfGTPKxlWZe+uN6XXWexwG9WApEShaQIiGAcQgCqG+4HZRomK3zzzyCxSI1NPPur1snHuZfd6jwdUFB9Sy3B9xYsN1QLgC49Ksb5CD1X8VKmHMcNVv/TmP94QwvotOBE/zqeQw3eHgeHRzzLYOImoSvH0KeIxNW6yAxl1FwYW3oBnPSBmibxQ61C6XHGVSH2BmdAP1FPS4ueChoHWHsRk+u76CNUfh3uLQcX/41SlH4QOxmy3jyXdYaRPXJ3mYLckVPdUyhWBdHzkacYdLe0L+6A71vSEMdLrPgKMqosCBnbJX6Dq4uczwOVTJYmjoLVpaV89Dilj3vThImZ3Meqw0l54tpHDXXDJzeR1ObHLcW1KJsR1G5CYsG/f73zVm2g/Cao8JbTbXQxY0FtSSDXra7oNw30mWzg+dY/m8gJbw92d3O1o+lnq7Xg2yCeRQvIQQkj3yEdziicjvu21AdEYC4wIT4UdDU+LvCwWLg9bjxMtyWAXZHI1X5FuD9/6NOdgJXwoSK11yniCPLdDWGMMhTb69u7qMlfzX7wBFqUdUKgo8gj14nfEMR/bKywonSxvRHJEBQix1a17Rb1F1TlpJBs+Jf85zftMTyc9wb1HT3CQsAz63UzRcqqai/gy0CU+qoROgmp6ekIKkHrwGnk9uS14BcfpU8UP7Tdx65cF53lOd+ScLOLpAf9vh/uLD/ytwzA5fJTIB4m+NS53eKqViaBm5P71Bc/cybz6bcKQjXXNckmiMWq7ATH/PlS7dPZe/k+R0vnQlNus
 WsbmDFdo
 txcRxjWrOrQwCmUzErzot6e/Wmr7V5RZocO6OSEiFhsZ+V20m6NySfx2yO5p/CI7iW/OxSiF6q3cKXmLjfryHHP3DdC+mX/TtmLWd+Ua2dZS9k8Fos5COU5RDdlK8aDidlwlWc6RuncIYQCITKGUtD4IGcu/hoZL+zJWOxNd5n43oMzZpi38jUFcn5HcVQS4Do77S8VeyxwfwzwwSov254lJ07tHVkFjH+eFJhcmzyKgzqvfEn4MSi9ol/DM7AuJWZ69TpID/DWxx5T/PeJ7dKVBPqnjxkTELV9uz+lQaR0KXIUjQ2U2CiCAw4O5ncV6AzZnH/o71P3rv8LJhTeowlSHWOZi+rJH5w2VhRHe5f+6O7aWfZGs25FSmQqHzzK5mfPYmeVxoFUWniEElSnqtCWSuFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A percpu allocation is at least PCPU_MIN_ALLOC_SIZE bytes, and
__pcpu_size_to_slot() returns 1 for sizes below 16 bytes and 2 for sizes
from 16 to 31 bytes.

So fix the wrong comment.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..96aa70145095 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -100,7 +100,7 @@
 
 /*
  * The slots are sorted by the size of the biggest continuous free area.
- * 1-31 bytes share the same slot.
+ * [PCPU_MIN_ALLOC_SIZE..15] bytes share the same slot.
  */
 #define PCPU_SLOT_BASE_SHIFT		5
 /* chunks in slots below this are subject to being sidelined on failed alloc */
-- 
2.43.0


