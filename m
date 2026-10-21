Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E419606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n0f3/BuX
Received: by kanga.kvack.org (Postfix)
	id 8E78C6B066E; Wed, 21 Oct 2026 04:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EA76B0670; Wed, 21 Oct 2026 04:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712B06B0671; Wed, 21 Oct 2026 04:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 492056B066E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:31:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FED7404D7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:30 +0000 (UTC)
X-FDA: 85345964340.15.7B7D541
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B76E40007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="n0f3/BuX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
	b=beNrzgdTgiLBwL1cmzdK9s069D5TByKA4QSvKIiDZEl9f2280HJZ8gJJ2BR6Hg2IbXVq6e
	ttvVwMoukn5+GMOuQsGxgTF8AQJUiTvq4ytMCi1H6CnGsYM2p3JNdvM2nQMGxkjZE6saXq
	b/+5cS5xb/V/CaDbVwEqu7skIwnR5Cg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="n0f3/BuX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571488;
	b=K7dmwfxTDXACEsqovfVJ8QN3TsJps2Qq9GuZ6nAyIYJXzd/Ev7sYpiltETHLgSrCLRhn7B
	HGGXNKYbK0y+0dDRlmFxpL1n+QgkRslP+/Hovat0hW04VTE6gilAUGY3jw+36oemjQp2bk
	3pyeaox5cokbO1slXAGbagg8buP9xA8=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-89d6bd67045so227738b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571487; x=1793176287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=n0f3/BuXLsPTfpSI3+/l8C4u9iN1tCXi6JDEVyburVaAnCKyEUuokFqhCe+Xz8ZZsV
         1zUgLMOnwFrEuPXYjwCoDCCmRoW1wgXXb9gvNFj+VxbbQfkZl9WHpkEKkYyd3CHc8Jo5
         i3w4PTgIBqYSQ10I3m4mUwSrUAUcIKq3UO+sAD7LGWwPECe/QAIQ4gxiqTkvX08kZc1A
         Y66YuIi6TRkffSKVttiA1pekn8WKAJs0ton1xVjNxBS38o0VO/MTp3jh8WqQF1oGMsU1
         MXA9ywqChRccwCEW5TzH46/eY/yGzTSJe/QJ4hC7HcfqVoIsuyKqTSqdWUHG4nilb3gh
         VF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571487; x=1793176287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=lPPc9P7X5aX3r+rHRUElRWo2vzeFMotHQ8LYabXLoSgueXVj05XMD1rXf7DlMPBwiP
         p5PrtZOQogD/CyRzoKPgEuCqxmvvC0X/ddWv3zk9JpBv10HMe9f35BkqgjZKMDZRZ/Ud
         sYjOlSop8CbnKPg1dWL6vyx2VwU9IYLkejEOfyRg8LODE7ryXStwu5wwm3oGX1c1Xwe8
         HH8aMo5FDnZxe9y7Z/ABhyMEGN4iCN1f3Wx/HPaWmMOnMPd6hp9/lakPuXqre+cFPGN3
         S/wRKRLCCmrsyX6bf4Sg6Y+3w9hbV+Vz2VfGdtjp/RCzuYzWdBxzaMiEeItn9jBpI/vZ
         +TKw==
X-Forwarded-Encrypted: i=1; AKwUvBx510Q2lhE3GJZlhV4pEnObIDhxyTb+y7ZYx4RXhQkzTs6hd0Is3qjhAlhTgIjjNbAe6gB5cODnmw==@kvack.org
X-Gm-Message-State: AFq9FYI+jTHKhBeoXHPlmlQX4Pdhy7+YD9Z4grKpcCCgcn6VKtytub4G
	RAjjBQsUzViU80qHN680z3SSsL72PLyY5N0bxpfkZBkKfSzRHHYS7j7Q
X-Gm-Gg: AYBFou24exBeVX3oBvZhUDZrHZrSAlF1NdynCKZnQty7rQ2JhWj8mk7HYs6GtHM36u0
	s4r5+lV1KC2kHezo6bZqR5ZZnLJfGv+Zfjj5fQXGqSZvnS3W8n5y3PuWHAwZRddFzC8p3dhEPWk
	mI3Vjh6btFSzsFVc78lsGvFCS1r6uUnNMUQD/36EKZqXusebWLtBLU8irjxnFpg50zH/AEMg7Nk
	hfulpeUBpT+mRh5HxlxZ+xhXtoNwQLRpk+5mnrGN7dxg/+8WzqAS7sfQy0hwiskhy9iqH4Evqje
	wUPNDQFsaYTUPSsFHRmgzaU5a6cDMze0WxhinYZiyFMhWoojiwnKipnZAOJlgM4NryU7Mr2qjSn
	CAvg7puQh1RmFW+6k77hiAWx5iVD45rKOI8d+iTZEmhgkSVavAbLUMbm99N3jOoStU9qGB6D80z
	Pmypin73jeKq7brGmRnesRdNnqrWO5xckDuwhA+YJLlGO6ArrMvFSXU4VX64eLRZdnR9u4XxZqY
	1jEL89HBrsQhXqG1Td5P0yBhFp9mDdTZ8jo+789L5DDVBw1vZWHQ8dab5vrIhoafOPW7zPB4Xuv
	ErTc6vzN2nBmXA==
X-Received: by 2002:a05:6a00:2e1e:b0:8a0:4d37:660d with SMTP id d2e1a72fcca58-8a07bf67824mr2764848b3a.2.1792571486193;
        Wed, 21 Oct 2026 01:31:26 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:31:25 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
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
Subject: [PATCH v9 4/8] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Wed, 21 Oct 2026 16:30:07 +0800
Message-ID: <20261021083011.2170525-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B76E40007
X-Rspam-User: 
X-Stat-Signature: h3q6r54pt1ct5k59hembm7hau57y5e33
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792571488-911453
X-HE-Meta: U2FsdGVkX19AQ/AUlRDs4Oy1yy8iN3SWOrC9e2aRdmLIVKfEe3f09MhmBRu2dZaCqvXBmSy97u3JyQaHD+ZOO9rSlglvkFWeee24cZMBkI/hvrauRGVnCb1yuU9/xllT3HccqQlei/j2unvjSVlPRfmEydbSC3G1K0u/rD/sp1g3O5mkmaNnRS6UiE8k7wi3XZI1CiX6+LDGEuhtMbniEZhmaoFuYAY81s5WNTBeyh5dIhwP9oDyW7kOVwF6evTegCvwH8UlLpGZhpfngIV6ZcpZfLrt8mzUtItAKFPKEjeEkK82IvHFk2Gq358R6rfv3kt+LSb79g/z++1nj12DasPOze8Jot3/RjADv584zD9X8rDegDXE5LaFQUY0XzqUwIFf0uhxMxuTpVe633+5RrhRzWajUJNvNWB3NorCg8ihHismZT2noFEsRi2Qd6wh4vZ52aVzsdkO6fHFtAmS2W+t0d+NgYabb0GglYdJMZBMVLBWCT5ol99KeZjPF4v+lcyUTjIct5tj+ehBpCBd7j78HujFrjHsLkLKBts19wpCLj5gzbI1xE0QtoPe1d3vkGFQOnyxC7vkcwbTqIk9Tb7oQvXWVcz4FJ2TCpqwlI9qPkWhYhSgBQytZTjar+KBJCfCTzpMKBdoXMz1wdrxj5tN6C2WGEtC2jZNEI6cQd+wi+MGz/GgJ/S+NDevwEY4j2vvE1DW3AUstKc4iA/t4WY67iOBBIwLoAuvd7NVn1zCZTyuvK6N8RYFd7e8JQs6nzocvC4UJKgDxjdwi5UHZf7ylalJ7ef7Oxc4s2fNtviVziE4gYQ27ar4mnt0/9haAMPu1W3iwkHoaSWs3/A2Qai8bIvNtndCiVNWkhr1hZFrT3BXpwPTjC+sE3hFKHYN83UR5ywZ5ECyRbkoAUeBKv5h3TjfnmiIFpyVMW7/vqS3zwkXEQTUYJg0Xql/AUu5xHwp0burpwzjxdB92xs
 EVp34qPZ
 InhIuOdsyr4I5AMfRTWVMdc5NhP1urmJf6vyjpo9EXrDWMcC0D3P0v/sDi1QJo9n0B6+VBX82YxQo66VfWHDtj6GGAULXdLZIweAMgOk3kZQQlpckduLsqxTZOlEw/CBYEpKtT+mkw4HnQvbmx3Cz2/48bhS3/4oyYf+PGKyD4t42gfRE8TIYq614CVz5Pxheneq1MlY7BRhqkN0N8yONwtVXnlSF+rgGWGD28ATNIPd7gxBQvBNJj9hnXgr1GqQPn1PipqFeQ+ZDDkdkqXBkWA4MY6wjghcMs4cvoeMrUF9SI80SB6xINyDVk0ykKAUrCvQbt9DnvZCux5cEZnF+2l0DPDYL+pNM3ux4BbYIPVkmmcxa/J9Ynh4oKo+mPL6PWNEnSPkI1Los3HV55iJVjY8vnozZj1ODm09Zjac1aoYfzhPL2hGhUe+BeewdKPe4Dlb1JSVjoXxSN4RV4Q9pSrq+jPI4SlqwRoi5YfO3b51TN7Qt5o25KvtakALRYnEwZ4fGWQ1Lw6An3sqZXLrbV3Blpf2HaaJqlYigMtlxS/KzVkoO3JwvTURlI2pQ8WPnq5+UzC5xBpyANQykOTDCiqnCOpUHfiOJvkJLYog221WVNWNHMcNbJqq7Wb69c1I8YzOxnv4o9H+OGD4mDmy5wJP/kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 8a861a946e26..e161c8b65e00 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,25 +283,34 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
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


