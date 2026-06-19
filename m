Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFF0CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 06:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AC06B0088; Fri, 19 Jun 2026 02:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DDA6B008A; Fri, 19 Jun 2026 02:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFDD06B008C; Fri, 19 Jun 2026 02:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B10206B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:23:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2068040356
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:23:43 +0000 (UTC)
X-FDA: 84895671126.11.DF16451
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A0E0A0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:23:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=i32GYOuS;
	spf=pass (imf15.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781850221;
	b=q1w0RT+hh0X5GqaLDNq2/Lj2soSbWiri87MIQOTmo+ivY5DCWfYO+Hjxni8Zn+37vnU1nL
	X4A/mbyLxkICSBgjsyc969Ksnfrq3dTan/FGb4o/mj0uUv9zTOdPJZBE283g5+sLz1xpxn
	Fv+5ZPMOCXiPP2+dbVbn1TyCdy5mRxU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=i32GYOuS;
	spf=pass (imf15.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781850221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3DCZNlUVaLaJPu2CPNN2vPukycGXAc4wziVR3oMZX+k=;
	b=hQNRoD2jdRf+kXHTZDmwdEEPH0pMhngDDWSimZBMPlYBB1i6BlbUDJHHDen7lzHGySwx1Q
	47BNYngO4WxjTrwTsWHQh7CxR4gcnofT7FLFZQQPHsFwB6sthKaTBqpI8NsuxZqYpV/ppT
	A0AzMNp8Ac0NcQ0X6KpGho8xNSzW+d4=
Received: from thinkpad-p16sg1.corp.microsoft.com (unknown [52.148.138.235])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3501C20B7168;
	Thu, 18 Jun 2026 23:23:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3501C20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1781850218;
	bh=3DCZNlUVaLaJPu2CPNN2vPukycGXAc4wziVR3oMZX+k=;
	h=From:To:Cc:Subject:Date:From;
	b=i32GYOuSvBY9mRFjqPUH4A5fcBMRW5qrAWSA6w9D0uZDYlD92j3MzgXj8KcA+82FM
	 cWPTx2zyUOLA9ZlEHoGpj5WIU7k3GAk4J/jkcSqcm8OSdSHaZGN4cJdryBj/7jVS00
	 XDOdlLYKVqsLLk8YR0dG3LEb+7HbrxuCnOTuuJm8=
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: rppt@kernel.org,
	akpm@linux-foundation.org,
	tgopinath@linux.microsoft.com,
	bboscaccy@linux.microsoft.com,
	kees@kernel.org,
	tony.luck@intel.com,
	gpiccoli@igalia.com,
	bp@alien8.de,
	rdunlap@infradead.org,
	peterz@infradead.org,
	feng.tang@linux.alibaba.com,
	dapeng1.mi@linux.intel.com,
	elver@google.com,
	enelsonmoore@gmail.com,
	kuba@kernel.org,
	lirongqing@baidu.com,
	ebiggers@kernel.org
Subject: [RFC v2 PATCH] reserve_mem: add support for static memory
Date: Thu, 18 Jun 2026 23:23:31 -0700
Message-ID: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A0E0A0005
X-Stat-Signature: q5m3hbypfz9snqbfszpp7gdq593x3mju
X-HE-Tag: 1781850221-274650
X-HE-Meta: U2FsdGVkX18R+Ym6sfa8V0kkwKCQzgZBzxZMWlURBgKUWAm1g2ujLTW4SkpofaV6AzPeEpO8VfJ3vUf6SJJxE5ljFB1jl5pngaAl3ZI8LYvoLU0PuWzuiZuO1hX9bcFTLPlAhP5Z3uGgHlH6XbuJu1slktwJf0AUoZz2bBnvg3nvp7+PFj/34U4aUXf9L27r/jxyLy559ZLZep1cnpgZhObqffPurU5JpFSkE5f7p2sKLQdtYWqNKU22EqDiL+I/AqEXwQA+YOvphzQqFa0eT0kAJDFi/w4EGGa0Q/kyeJJsNg7I2y+8LQRCw2//rjLhQcRVwVjZEeiQeS9P+J6SF5ZH2g/uFY9FwXmjA5OWjjPXnfG+RQp1Rp4kgtpwdsYhvom1v3dS3Kl2WLx8/KIt0vOcV4Rs6UvDWXAinlsber/pGy0rgq/CJXGdo9eb9IhchbYUdOfZKFYWouxm8yUmMkRt+Vty4QF0GbEeLpirUApKhAY2hPih7L5hBGWK8UPQeWGBp4nDIQvCxyBVfmfsxT7KVwgogBHKglIUk1gS5kN2HC5WZdLeCfGYn1ljOUde1MHDl7A5tF3dTXf3wfG3+o6FWRhfEjP8HaZitPtQxh3AIzNPMW4kN3cjHookjndYwOP1B2RlZicEayC+wfT4dlsd8k3Bhp1d86EA9k1HUZqSg2ckKfd0Si67lEfOnN0HV02wy/EtGkWMmR28Vqhth3q+UsM9NrSz63T6igJk0qawrtiWBYLwmKrJQYB8MlmxrxoR7RyThmHdDZddSK+lhT0uA/3caU/EHKY63JrM4GUWZeHBp3Y/X2wVj4MXdnVnpFGaHG27/w8YADhJdyiK6de4Z9edw4md0rCsPKlqCZIIj9m/ihKYxhBvN73c7326LtMTv4cZT3rwz10ujg8FmUn7webM9p5O5UzomzFqLa1RC4aMct6BErk/BpHTuxG6boaj2gFxiS38OI+GLHU
 jNfdvYbi
 DMb39rZJP8jy+QEKiY9ZQhwq0nwSTsf1m5NUSEz8k+OLz0S75AEERx46n5pICRjI33LAqYdYaFnTQMZpmW4SrXwCtV9fi4T6dQDU2xCffQjIeUfVcBJ+Z8sZwS2obC3FPpk+ppcHCMALis3fIWMmpBDOydv0NtbGsn9sGDt51tgkUqWTnjZyRTAXExJuHiy0HGDXElkuRdqHTAwnqS4IP1cN2WgCozjJ6EacnabyjBSWE1fT+yvJtMiB6K0d6DY5evwYQzSXXupzOUHbc+O4EadO5zwZp/9K2FUtyO8N52v2aUcoccuo8j5ver2s20G9hi2fr7itzd2T6y0CGdGPgHQJfq8QqTcbqae87H3Ivbo8360pcTpki+qMXrNTZOp21FE3RHMrwRqvqn9hQYZ7V/fDjxNzhQM04thEUx3c1hRGLncs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

reserve_mem relies on dynamic memory allocation, this limits the
usecase where memory is required to be preserved across the boots.
Eg: ramoops memory reservation on ACPI platforms

So add support to pass a pre-determined static address and reserve
memory at a specified location. This enables use case like ramoops
on ACPI platforms to reliably access ramoops region with previous
boot logs.

Also skip the parsing of <align> when static address is passed.

Example syntax for static address
 reserve_mem=4M@0x1E0000000:oops

Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
---
v1: https://lore.kernel.org/lkml/0eaf3be2-5121-48b7-aeed-196405c0a480@infradead.org/
v2: Fix code logic and incorporate Randy's suggestion
---
 .../admin-guide/kernel-parameters.txt         | 15 ++++++
 mm/memblock.c                                 | 47 +++++++++++++------
 2 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f228..7e0baca564b97 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6563,6 +6563,21 @@ Kernel parameters
 
 			reserve_mem=12M:4096:oops ramoops.mem_name=oops
 
+	reserve_mem=	[RAM]
+			Format: nn[KMG]:<@offset>:<label>
+			Reserve physical memory at predetermined location and label it with
+			a name that other subsystems can use to access it. This is typically
+			used for systems that do not wipe the RAM, and this command
+			line will try to reserve the same physical memory on
+			soft reboots. Note, it is guaranteed to be the same
+			location unless some other early allocation, e.g.: crashkernel=256M
+                        (without static address) is reserved or overlaps this region.
+
+			The format is size:offset:label for example, to request
+			4 megabytes for ramoops at 0x1E0000000:
+
+			reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
+
 	reservetop=	[X86-32,EARLY]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
diff --git a/mm/memblock.c b/mm/memblock.c
index 6349c48154f4b..c76cefa0a8a83 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2721,6 +2721,7 @@ static int __init reserve_mem(char *p)
 	char *name;
 	char *oldp;
 	int len;
+	bool addr_is_static = false;
 
 	if (!p)
 		goto err_param;
@@ -2736,19 +2737,27 @@ static int __init reserve_mem(char *p)
 	if (!size || p == oldp)
 		goto err_param;
 
-	if (*p != ':')
-		goto err_param;
+	/* parse the static memory address */
+	if (*p == '@') {
+		start = memparse(p+1, &p);
+		addr_is_static = true;
+	}
 
-	align = memparse(p+1, &p);
 	if (*p != ':')
 		goto err_param;
 
-	/*
-	 * memblock_phys_alloc() doesn't like a zero size align,
-	 * but it is OK for this command to have it.
-	 */
-	if (align < SMP_CACHE_BYTES)
-		align = SMP_CACHE_BYTES;
+	if (!addr_is_static) {
+		align = memparse(p+1, &p);
+		if (*p != ':')
+			goto err_param;
+
+		/*
+		 * memblock_phys_alloc() doesn't like a zero size align,
+		 * but it is OK for this command to have it.
+		 */
+		if (align < SMP_CACHE_BYTES)
+			align = SMP_CACHE_BYTES;
+	}
 
 	name = p + 1;
 	len = strlen(name);
@@ -2772,14 +2781,22 @@ static int __init reserve_mem(char *p)
 	}
 
 	/* Pick previous allocations up from KHO if available */
-	if (reserve_mem_kho_revive(name, size, align))
+	if (!addr_is_static && reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of scratch region */
-	start = memblock_phys_alloc(size, align);
-	if (!start) {
-		pr_err("reserve_mem: memblock allocation failed\n");
-		return -ENOMEM;
+	if (addr_is_static) {
+		if (memblock_reserve(start, size)) {
+			pr_err("reserve_mem: memblock reservation failed\n");
+			return -ENOMEM;
+		}
+
+	} else {
+		/* TODO: Allocation must be outside of scratch region */
+		start = memblock_phys_alloc(size, align);
+		if (!start) {
+			pr_err("reserve_mem: memblock allocation failed\n");
+			return -ENOMEM;
+		}
 	}
 
 	reserved_mem_add(start, size, name);
-- 
2.43.0


