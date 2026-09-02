Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF473C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6AED6B0099; Wed,  2 Sep 2026 03:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42046B009B; Wed,  2 Sep 2026 03:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58516B009D; Wed,  2 Sep 2026 03:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDF36B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:32:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A67FA0789
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:41 +0000 (UTC)
X-FDA: 85168004922.01.97B8C81
Received: from mail-pz2-f11.google.com (mail-pz2-f11.google.com [74.125.228.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33DE11C0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:32:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nDLpEVnQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.11 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDn9kL+O/DcgCowWQhzjL1E+vRjYGvPyhLWTC672vfE=;
	b=V/HzePN/n0DnrqRvxxmgULEH1ggA+CRbA00UdpDGayU2PVONBM0HVjwSTPdM7UWFkOPwBF
	xQys+lDIUTAdBIAlWto9p5047kuRJQo5yTLhNRu3FJtg11nE8O7nHPkuK5vaPdciKKevpC
	jtZfQA6hZ7tn30Lg81uXdq9cIerMTRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334359;
	b=KNLs37T1LvbXhire504PoAbix9hW5gdFB2ZTrkaRKn70Qg8gdaJBIcf9+tC9KeU6s9GD36
	8bCTHctdwm9Rvp/J7wW4M80n5V0QjmQm4pfBlEIuXFknAapGHGYpKOsl/NV5BbVU/HxT5K
	4pimO8nozuub7WsnW5NWw+2Ku2NQo14=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nDLpEVnQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.11 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pz2-f11.google.com with SMTP id 41be03b00d2f7-cc1c2963c92so224838a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334358; x=1788939158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QDn9kL+O/DcgCowWQhzjL1E+vRjYGvPyhLWTC672vfE=;
        b=nDLpEVnQYZYQbiMaAKgW0IfQq4KyyPMDpZvvagCJtb/FZHEAQAoprtj0Ts4Gdnl4i3
         vp9h2rt3NsZm0NhZdqIUrGs8gP0TbbKx0L8RWoXvMAZpehpQdZXvj8B0I36ahBAHr5pf
         OM4i2/MKD8/bkFYS0FuP1r6HZ7RXb2pQaoR+hkb1gp5T2LTr7ff0UFZYjTktVYKYQFB9
         kUndZA1efpNgrAzex9jxjK68M2TUgqm+R+d62OcBju7RSpqTz6gwWLwnRlKWx6/s0jp4
         HkE3De6Dt0wCjfOvvnPCJMULFYxTallZR+PSzVqsi57PiectESHeo+n0MJdhOW2oGgC8
         YlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334358; x=1788939158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QDn9kL+O/DcgCowWQhzjL1E+vRjYGvPyhLWTC672vfE=;
        b=LFdTTaZqsVf/johODur0TPuKfGKPDDoyTbcax5i9z/+84UEYYMBr4h/KgP2Le0Ry1J
         pZ+XCLLmCKsmeXNV+IE6GvDsdZ+6it1q/8FAjYOqnl8mIAtlBsEKD+QKJqSeyAyMAqXv
         6RWpdZfhXF2ZM80XO6OdHUBdeN3BqizUQ0M9iFULmBARbi0TaMWzu+u6k1JgPTzuSeXW
         HqyRZ0XgqkN8ljDRJqlmSpD7NgK77sFStub1w1YMiTvS+jJiQw3KQApP6UOgNIJtEm+p
         kA8XhKIPcdkS3mtkKKx3teFrJ+KKGp0gM7B90t4rcgFtbuap+Mi89eD+anxl6NHqiu5/
         DM8A==
X-Forwarded-Encrypted: i=1; AKwUvBwwqUndWDJJCY7pGozynHrxq/B73GbkactaeDUpwRIJddpmkPzug8msvCNYzJScOR58zR5iSV5Uzw==@kvack.org
X-Gm-Message-State: AFuF++lI+lzizK8/3FW9U/UkDs0dhCeklvg5Jn/32hnNtMxbJNj8i/TW
	0D/TSiATakPXkYaeVPxes6SkRYv+rch+OpsUlhmMa2VDFPOdzSJlALV8
X-Gm-Gg: AYBFou0W7waCi2uSQhNGkMSlk4XnHqn0KJVaM5AaKnjk0a8bGfHrz2x9kT6VI1ZydVp
	fvRT2QNjIcOBxPzeMH1qe4yQc2DRLoR+5c03SEGMc7oox4ZAe2yz6znBtNc9CgF79VzyP/s+CPr
	Vlsi//hpIRqC5F9kYoaKFf7bJO7n3Eyz3EiyQi/xZTMvN30xW7s3ygxnfO7jLNxFQ2bQcnBWRmC
	lElUW5TNsLnrRaMst0OJ8t0OiDIEOLPNb/JlF7uKST8CIGGtocPnyzcnFE9E5wkA3HYglRroi7D
	y5uBB1fCoY6CMM1LjXOi+g4BW2aFrAnVeMrcS5l3bQe3heEqNKxlLYmvcfRWUcBSJkVa+/njuAh
	Xo1uTbw1d6D7haC/kTa8x2i436snS4CZOj7E3VYwItYupVC4DSXCx9ySYXonChnxbiteGVMGjIn
	drrYLiyWAyOA3RdOovIqqhFBlFpQ/pC1GeLvbevd4Hy+Q2KPcfOkzAjgJoZ+CxmOnYSnRCcej7
X-Received: by 2002:a05:6a00:391c:b0:842:5b66:3c7f with SMTP id d2e1a72fcca58-85ed444854fmr4147616b3a.0.1788334358011;
        Wed, 02 Sep 2026 00:32:38 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:32:36 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v6 05/10] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Wed,  2 Sep 2026 15:31:11 +0800
Message-ID: <20260902073116.802752-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33DE11C0007
X-Stat-Signature: b8ggpgbmxdhj64rniedxqfgegx6fhb6i
X-Rspam-User: 
X-HE-Tag: 1788334359-319269
X-HE-Meta: U2FsdGVkX19Oy1sGJ+iY+PHv9f1rLZuJb6R/rCErvKJeTaUb/dTHDM+roKbS7uD1ITZ7ip4Jb+wiTfnPh4dojgfUqyUysHFcDDUEDRCjorX1aQ1akayAkdGxg65Vpby/jho30EiV9+dG8nZY8aufe3DFQ6GR5au5yK1eFGERCyrgR+kbadl5X8m5GLZxYB7Jn2ItoXhsNdRkNqncf4vbzAZ2SylBBeu/ECn6MUlXqjKyIb4QQ1c174n+3QDucAkL+2/ypsC/e0uKJ6SYXkG2Hqv3+dW4rYE06DP75kdW5hHLsEnDAiq8N4cqh70QAQeSXFn57NURP/CC9FqOQUEYyPuIWMg5zfnHO3u/UijGAIpD/dp3eDSP9993tbhtJnejclwNGoqsjUrJnCEaYSDQ5+pqWd6chTTtrnQB/sw8lprShFDXlcSR/GN0zHlQ8HEKNK1987GePHMGfQknN7STGr6Eh9JnPlEDiIRvF9OCWPbAcLGGqZZq6MVRufLWntgpw/s5NufMA2zgIMa6uh1cRHqa8tRwejd/QA4ne/ggwrdaZMRBrbDW9QmZLPnmGYueu21+OA0iYCmsHgUki0oRi2DK42+PCyfDsGEoCTRdvgYuf32ap/sOPYeqq4bvEpgh8bziwIEhMYv/GudCRHDL8K1RAeo87snnJk4GmJ8wXQrxr0LTUYy16jzsZlIGMiOZGXtZAFZ0mKoxPs6dGdf0O13xclAcwib18486r1mo1IrHWZzuzf7N5kyVa9wDsLwdpsqq7gfFUkBefWGll5stnwuCNZxmqsAretErPUjFilp+C3Ixurrm7A7AN9lInuXZ1by5B55Kb2IzoJX+ZNVS6DOSy8v6d9D/gH3iXoQgSTUO/gNJQ2dF0pfTmsmqr2cYWTmrc1AZqHs3CuG32KtiKhLvS4KMoJ/eexBpxHmXse2q4gY6SJG13STkUA8J7JMaCu1zKZAiia6iXKPSxAS
 p0KhZ/re
 bDZI9P26WPmLDfzwXvTh4lISBmY7f6Zk6aysHEGld6QRDW6yQDbeMTs6fvBScfY666mmLA+NQfCAtqQgE1IsdOVBWhHrgwYPY0MTbyXushBp3r1nNG91O7tsWarUIdiKGs2BdFzNiXBYF+CXsSSxLn3/qmOsfFf+CVu746yZQUBmCLF5Zl2o5MTDW++Fa5umyUh+1FvpqlURmZ/nAAHGNdmokK8yDmgXU/LmZ7iaExcsHB2tXvIsHN4CRGYp/JN56eJa/ltxsM2tveCK4sC1p0EFNObo5mawwHzJv6iucoP1Qlei72OJ47bFLwcDGokiIhn7qZAZ2bZCaBShCU+cINrYJPDrLSo5S9Z9xyYM8vI7nt9b4R6WWbF7/Wdj60ymn3FC0Kb4xA2vnNzuMRa+m52MOTVhTgxv700ODxS8gKzgZTACu3dO5zwEfpuye3t4Z7SYJ0MQzi56KDzhsqjIkS7j+64Y339xMP7Xhb+uv2HDyU9npiDX8Bn+ruNnGctdOoIjQsLOZGJo5ikEw6qtRWIfJBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 3adee1ae120c..bd64cf585795 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -270,6 +270,12 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	return 0;
 }
 
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
 static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 {
 	struct crash_mem *cmem;
@@ -285,22 +291,25 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 unsigned int __weak arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end)
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
 		nr_ranges++;
+	}
 	return nr_ranges;
 }
 
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
+		cmem->ranges[cmem->nr_ranges].start = reg->base;
+		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
 		cmem->nr_ranges++;
 	}
 	return 0;
-- 
2.43.0


