Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6450D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 20:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A296B0088; Thu, 27 Nov 2025 15:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4366C6B008A; Thu, 27 Nov 2025 15:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289AB6B008C; Thu, 27 Nov 2025 15:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7306B0088
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:37:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B920E58334
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:37:43 +0000 (UTC)
X-FDA: 84157548006.30.AF41388
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 003CB1C0009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:37:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UeRlpJZh;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764275862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IaLsUxu38y5G+gFtilovMk2bO7Fvh/YwG02/3lmZCaM=;
	b=mQGasXjhhDYTqO3/4rIeEMn4/5xPRicXel1mmfHrCDqQsiVCfGxZ1dMrNAlOAjFUjhLPJQ
	2hzJutQ1+Z6UEUdZWhR+IpCKqkp116lrVtvdTJf5nR4WoYxfqD9dCxYejhGtXlqAFfdMhH
	rfAVnIVh4NFUH7vJxqXwKBm4u8In1Sc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UeRlpJZh;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764275862; a=rsa-sha256;
	cv=none;
	b=xm+bHUUNyqQVu0LZXVU26hxEhqJsZDFDRYJZl3NftOcbUZMUY5zRgwnMum/vOalXnXg0MN
	OyawuolznnSVlN0WOqRTTCc6T/bh4FJhF1Xt3bo9Px4PqoNN/5BZ4k5DmVjRLuxJ8HkOD/
	sIDW+BCL0/rB71gHg6ieoXDjVBCYWY8=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c730af8d69so698870a34.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764275861; x=1764880661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaLsUxu38y5G+gFtilovMk2bO7Fvh/YwG02/3lmZCaM=;
        b=UeRlpJZhWv3AUzyxENbIkuSdFR8VmdROl0aNc/v3yP8U6TS6wgjwu0QQloPhaJx8az
         KT10ArhqXNm6FDg4AfdgXN9FrQ39ULljNkiYLcZfL3zLkrOvLgJgz67/OfnZp1kE5dig
         60cl054uH/mia34lbYB9zxaQHz27u4cleWARnzBsLi09DvZoq3WkMoNpKhf3TX/WR+6m
         mPwwjs0gr+3sCHBiDaRxGlaF4zHBhXwV4Q6WNZhHUf0zh2B3mNSgXi8lu7hG0o2zPHw0
         PNPoNGkMHNuRivM0FWqLzPUsfJGg37oCGzmt/PR37qECLSOwP54FQjhqssKKA0FHlrP5
         wpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764275861; x=1764880661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IaLsUxu38y5G+gFtilovMk2bO7Fvh/YwG02/3lmZCaM=;
        b=TZsK5NvXeXRHcdc6Fbah58VjkQTJPNMpwMM+gNIAZcWoXirNr0rE1vNwSpGZWzznYG
         A12yTNPWIYIsyJiecvt00JQV4y+Tr2YHGSGvGXTBrA91KwYjoKhHxNTDyiFcW71RgENy
         Yz/u/te5ssLoOVENbJJQAHPgBzzpe4zkqjUn73OUqEu64BXyNH8ich23fWRc4pG//XL5
         kJ76Kn5J7/UFBTOCc1rBQML6zp3yuYvj7/0Gzh/+EyUqdeIKh6SFfnTN6vnRh2ZkYRzy
         25vYQlbRPNjiFpl7j06SQkvKxz9SABvjZ5cBXupRH+EGrDyZYgGOWzClLFlA6XOhWqXa
         MHdg==
X-Forwarded-Encrypted: i=1; AJvYcCVoqwkomDmV39onCfAcq/h3+/n93LMNiXgvwHnUMUi8FMBQhhakT9+/Pw5QKlRmSxvmf313GCSxNw==@kvack.org
X-Gm-Message-State: AOJu0Yw3uwTP3Tndi8lKagR39rTgDCx3M139GOVtLWmBf/5jAvn8wbC5
	4XXm5iRCl99Mx2xyxn8dkOl39EeRO0wTSADYLii4WSvhEXIvn3CM/Mqu
X-Gm-Gg: ASbGnctdoaZ2D2iVfy2xu/O1p1Uyv3DFKUWKTMAK9ya67m6MlamHtmq3vmfEuAkD+4Y
	60quGTZ8gGw9w87xgo3i9G/KHffDhgdAdMaSs0hjLlbpLNjpXh2PZ67iNJrxUID+qstyDa+G7hU
	oQORkQUVN2qzwUUuWSDVzKadeoGSHqBEb6Rh+sNWxxxN8RV8N1NKhn3n0q7CDMugWliUP3Jwldy
	ZKIdp7RZ/urtVZOZUUbCp1sEOVbTX9PsERiYNTtmowgdSIKggLOEWZKit7uKxtO7Ft+jN/9uaVu
	ZFWO2MhgNDmwJGaYhgXZ1LUJ23klslpVzVLwvmFzbjx+xJRO/exAImQNVK2uaQgJYhcmIEGw0Vx
	flLzr6Cnc/vo368Ds14QIX/barTNeeo/2ek2O89IuxMFmy+EiXNl6/SzGtDOF6k5TopvcLwFu4p
	lUXHdMm7bsrC2iDzU6H3tuc2UqSw8T27w=
X-Google-Smtp-Source: AGHT+IGJhhlLeqRc0DJAlF0MmZoecI9eojRTaaX5K8ZxiyKE2JKVMaUIDPe51FRm+vBCj0A9r0XEDQ==
X-Received: by 2002:a05:6808:13c4:b0:450:ac7e:cb7a with SMTP id 5614622812f47-4514e7eed87mr5135527b6e.34.1764275861043;
        Thu, 27 Nov 2025 12:37:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:74::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453169f9f54sm731093b6e.7.2025.11.27.12.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:37:40 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kas@kernel.org,
	changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v2 2/2] mm/memblock: only mark/clear KHO scratch memory when needed
Date: Thu, 27 Nov 2025 20:33:20 +0000
Message-ID: <20251127203724.3177621-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251127203724.3177621-1-usamaarif642@gmail.com>
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 003CB1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ba1jmmjiossauydn9zkpie7gu4hjw8xm
X-HE-Tag: 1764275861-822350
X-HE-Meta: U2FsdGVkX19LCPIePJp2ZG1zwFlFGhY6xm5ycS78jNVaAJSN2B6PxkxHQIxkGQVyOP3TGVzOEKErl3uzqxf8VC8Ah+jcRDEANHU5DYJT8xOIh5oZLkVC5wMc0Uok45oZFsV3qHwy4vAKm2EbaSB3duEiyCM7KKhPOzJtz3n6ERTpC51sg5PUNKEs76/lObM5HILSfhTBqbh8Brww453wMCwag+JjZczmB92NbBPX8IaovNNyomNxmC+Ztl9mr+C0OEFxXKC3Vzgd+8LtxkM5eCpVm6gQZl9MNjtPLR08MTB9ZHsn5ToHSqyYMnqIZbLWMnGeFORtqu4B8rzIBt6V+4sXc8Zl7oEZJxneUFXzknjOrRMOC6L2bNvZXTNNB5E842FpA28spGiL76nFzLEU96eRh4xn0fTF97TMFJvgcRzIErwj2UvBs4vG4QMj23krRniFzd5d1ROUPtRrQNkyIlIk5+forK8095AOISXHnAA/QmX2Hk8oQr8AT5NrTDj9SfN89Dpny2H4sDVmXuwIbGwTf4Igl2TD8pH8jKRJ1MkkyU2uLkc71gBtWlVcsX+KZpVdzixnDDuEiSTWzAAmPadv5D4dkK8cb69XF/cQ30Aw2pkKiTlCu7jkFqGp4KNh9E+P48qvKCMWIPrLMtpvSix9+1CfVJVGJQRfz56hmmMPSD8q6JgG026clRxK+eetnIQmu2sIFuuFQWO3wgDvMJ3v0CJc5G2YfzmOIHssjwS30XszN5rmHt0dE9UvmvD3s4YzPAmLHCGA386J0ZLZdX+nzhHLFL15NJ+6MyRJpZunvqSRW5WFL+YEeWeH6+jsyTM9sbj+ic8KwjbOIe+PKVMAxZB0CTPsJmzJ9UdPZah5oM/nk4E060qxxrvfASsCcBAT+Uph4na863H6uQjZmN21FArG7R5cDOSLyqH77CHaIbG8E+QUz7YEnvxjj3zU0FIEng93Ny0ma+BjQ7J
 YgFkZliX
 aJMERU0NTFDYLqfeCxT61kVyDsoqky7cgANp0Scg194dEX6bXhnmo5jv88CLuFx4VaTlGE+/x9hFl0F3NqGwGq2/UP13jzU82i6EqHhssQ47J/b0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scratch memory for kexec handover is used to bootstrap the
kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
is enabled and only if it is a KHO boot. Add checks to prevent
marking a KHO scratch region unless needed.

Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
Reported-by: Vlad Poenaru <thevlad@meta.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 mm/memblock.c | 74 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 8b13d5c28922a..8a2cebcfe0a18 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1114,36 +1114,6 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
 				    MEMBLOCK_RSRV_NOINIT);
 }
 
-/**
- * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
- * @base: the base phys addr of the region
- * @size: the size of the region
- *
- * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
- * for allocations during early boot with kexec handover.
- *
- * Return: 0 on success, -errno on failure.
- */
-__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
-{
-	return memblock_setclr_flag(&memblock.memory, base, size, 1,
-				    MEMBLOCK_KHO_SCRATCH);
-}
-
-/**
- * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
- * specified region.
- * @base: the base phys addr of the region
- * @size: the size of the region
- *
- * Return: 0 on success, -errno on failure.
- */
-__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
-{
-	return memblock_setclr_flag(&memblock.memory, base, size, 0,
-				    MEMBLOCK_KHO_SCRATCH);
-}
-
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2617,12 +2587,56 @@ static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
 
 	return true;
 }
+
+/**
+ * memblock_mark_kho_scratch - Mark a memory region as MEMBLOCK_KHO_SCRATCH.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
+ * for allocations during early boot with kexec handover.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
+{
+	if (is_kho_boot())
+		return memblock_setclr_flag(&memblock.memory, base, size, 1,
+					    MEMBLOCK_KHO_SCRATCH);
+	return 0;
+}
+
+/**
+ * memblock_clear_kho_scratch - Clear MEMBLOCK_KHO_SCRATCH flag for a
+ * specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
+{
+	if (is_kho_boot())
+		return memblock_setclr_flag(&memblock.memory, base, size, 0,
+					    MEMBLOCK_KHO_SCRATCH);
+	return 0;
+}
 #else
 static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
 					  phys_addr_t align)
 {
 	return false;
 }
+
+__init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
+{
+	return 0;
+}
+
+__init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
+{
+	return 0;
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 /*
-- 
2.47.3


