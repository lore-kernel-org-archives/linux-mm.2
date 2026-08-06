Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6925FC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74AED6B008A; Thu,  6 Aug 2026 05:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722296B0092; Thu,  6 Aug 2026 05:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638096B0096; Thu,  6 Aug 2026 05:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3274C6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:35:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0EB01406BE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:35:50 +0000 (UTC)
X-FDA: 85070337660.07.A58E892
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf12.hostedemail.com (Postfix) with ESMTP id 02AEB40008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:35:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HXobJ1yT;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gF4E42dXY09sWBsDK5gTPPv7oygQNLJ0717q+HvJkA=;
	b=EUiMszO/fbdn1O4c6uoZgmUFvxKtpEU6aB6Yo75bKMFMRQ0ChaCwoXMh2mUlOGr0uKy8/c
	ZHiRjDNXZ+8LD3Wj9hD3Eo+nKp/TWZZIDeKih1NABKhqHM0xqZD3XCgRcpIcZw+ls3uuAU
	b91znydUUrAPGig0bKJ7TI6t+GIM77U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HXobJ1yT;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008949;
	b=GRUQZvBoyTfsXUX6hPEZrN9kY1pORt4/wTE9N+LPIq+Z1LAaVUZOcOHlw84yplw/w45tcx
	aAMrt0jvPUAgK9TkPuNwwDUwBJSWaNQITRHlN3Nb5eGBcclTZvOpjjj16jUTpVKmwUorid
	/NAYBPLbwD8XYKujMjOMtueWKMvyido=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-ca7fcfe1669so1142916a12.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786008948; x=1786613748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3gF4E42dXY09sWBsDK5gTPPv7oygQNLJ0717q+HvJkA=;
        b=HXobJ1yTlV/tPT40XaUg52EeYLP0B+osZO9hNpBtD35ji82Xmfml7MIlmHpn9l2QlZ
         ayAK9EXthPRQspZc7uqcfMjAZHL+pQ9ye0LdEReeo5H7nJa7+oaHxM4jVtO2Bd1U8ixS
         zT80xJZDRx0W+JPQI/cqxy74byVhG79eFwvKQohMgA8yHORm59MXKujqIuiKq7zbvbPQ
         UX0fl2eaI3ld60CRVqI0aKksb/sdy5GxzKsj6isfj2LVqIAKV9rDOjR7/AK18u4BucIn
         J74tnsroPe68fVO9y0A0wAvawrqW9q4LDPv9rIm2fVRXZCfSnbUHh9+j3SF7wYTEd+KW
         Z6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008948; x=1786613748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3gF4E42dXY09sWBsDK5gTPPv7oygQNLJ0717q+HvJkA=;
        b=d9dn9Inld36K/NxD6kaX+3WS0P71F34kfcafZ4iNCEXntsGwNd8Kmn0zk4W7jQVIbu
         LZjkSqKv/lGC9rknugAwGntSKTAPB1PiuKpWU8DzDfPjbggy+HGQQhPYAL8j6hzYZM4g
         R0xB8pLgU+DNWcN+s5QO1FlKlHK+/04dRt+gr/7D1WKVd2CHbbYId5cEMMiacxCnEFYA
         1dPabPVlkJV1T29sF4xt421JmTZ4//t208K7xHZfeCHCwbEo0dPFrFDF/hrhv/96iCbM
         lpgUubhPHuvm0MpIA+U7YFUwBt7ywsXPQJ0Y1EnsapP21Uf67N/09uDN4pXi+9SVcriB
         twXA==
X-Forwarded-Encrypted: i=1; AHgh+RqXgPVl5rQQUT44yWVSS47Y4ceKzIVLVaDR9vTVXI2Nu7bimDzaruDTltf1njwmwrLrfcq3JrjTSw==@kvack.org
X-Gm-Message-State: AOJu0YyOhqkVJ4RjLf9etSWXDOsDzZDR+7TErV9FToKUa64mrRPri+Nj
	x43RMIm41A/EFURQmFD+vhBQyiezQ4Y4orKEy6QZUEh3oXD4XGmQ9dyj
X-Gm-Gg: AR+sD13a1NVqZHk+kbA1WD7b2WhYGfJwCDHa4opX1qOGHOC4jese/WOuwriL/uYka8p
	AbcY+LbuP99H2qY4gPLMIoYnOYabE6QyweZemNwy9oJZgW9s9oeN5Bzs6eNl/tOW8Yx1OM3k3+F
	Oqlr8ouoxQONZoaw7bbvoTQNbkxuZJDoT9+NgOIIVVxpTYeqgcNLNA6Z+MjlcJWfah8cnrn0h6f
	rg/geLnpGc0m9TigLm9SrdQhHtFBsxI8ViPdAyznU1+agPIWouma960HF8vMTBcDjszrzCThZcr
	pXcS+2ZexAgnsFxXw7W9ge2fCHadHAT2WWhjOX5sLItnIYbUi95PjL0DwnzrliMqKad/tRaDMkD
	ISkglxyKJxdyDbdPM9qd8HFGekNx6+B7Yh/2pPKWHY+mxHNdBKXns7k5PTli3fDIq2v8pUawase
	yHHRDxFDWBDc1I1igdXdrQ2vFRqnfl1g6qQ1Nv3WG9SnPyytgR/vs2GKUW4nL2lYduOeCJh47UX
	A==
X-Received: by 2002:a05:6a00:302a:b0:848:7443:f2de with SMTP id d2e1a72fcca58-84f2dff77cbmr16112920b3a.13.1786008947826;
        Thu, 06 Aug 2026 02:35:47 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:35:47 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 1/8] memblock: introduce MEMBLOCK_NODUMP flag
Date: Thu,  6 Aug 2026 17:35:12 +0800
Message-ID: <20260806093519.2907771-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g86eangjr87impji9fx4r1x6tqfj3kzx
X-Rspamd-Queue-Id: 02AEB40008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786008948-165065
X-HE-Meta: U2FsdGVkX1+PFYsDDbZYINuDSfB3Si08l3u5EArZ4jpxMkElS97D0cEngIVY+XfegXmFEfumuGH8oYv1sr2ojC0CXjIhwo80F5lqiVUbAA/4RoD9RK8EvIfy45yF8CD3jw4YKNIg7IMvg2CotvN5UnssXO8YG180eR3Z6fmHB/avp3lbZji+EmXtBey0YroSWLFcWazSydHvhZ3Xx9TuNcai2PiLhX1/rJmiH5ancjT78YOP7X/5eEaCBvifBQBGRKUobLL/ZdIs7L28j8ZRTlPRYFXNtC/tVdvBFuMgcj6rK4gpSgPU0y5XK+xyJz0DDzGpXS+a4ip8LUgTMQ+oM/XVBGhOD0eQbRDDFh5Hc2nfVD0QDT+oW7bP7xBRro/exezaGKJGemFkugg+QTfyklTvmtdk8LjXuNmGhH5BjVrIGkElF5PTO+acmlT1oKSWnRqV3RQQgR7g1Vy8MoyzX20AioPMg79TDcC18nXUDdpsY5/bmRUEsxGsODUmP+AytTyS8L6uz/IDhZfda3K1y3bL1f3NMjvfi6gCEg2X0zhtqT7wvfN6blcFMY3MpMGppH8+mqYTeOPpwnkDDVhdj6CF+3sa4qWghOcvNq4FnROa6zvzio+YskePKQcGYQR4z12I7YP0u+zxS8v30YHUmk1Pkz3dxttLssUCsNC9flQhVlrcosoLusx5A5j/GaIyBX6GJDVppUHMJYpnEJV89mCrKL2QxkY9XCPHGs9lYX8387Z0GJ5B86jD3oI35WZW9CyPiIgB5XFS9P3UvjReWq2ZTX3m3v8+as7SCjLmJt+6Zg/bZpJVX3oHAF4jV4PbMZQc1nPd5J4u0Yjv6jZZWU99yA6+4xlXkoDF3AxyYlhV8HGNs7sazzBeypMiQdl7tiW5akgLhW2MTkQoz6OhZrzU58ks9n4y6zXoZ36tOPVB0TRPT/iJAOT40jk+upuDB/dhI3njM1Ksw+Qqei/
 axSaiaEB
 x6HukBxTIYoox/aoxjXnPMGQ1ZndplvYoKPEYgvy8YgnEZyEz58SM8P+4VVzFMLVay8RWq+VFq2j2GxZMbIuVR/QcNyerSO4LBBXd2gbyOqVXzpnco/FowTMalJQxYhyYFPyXtguDWDP7GyEMTUGqjm2oACPyxIyywRPo3OMuFm+UtaJw4aDgZp1A1nbxbwX892tHCSr0mjhK/Tqq9fMWAeixQ+omB1QByscfOpj8gf9qcvaxwDW96G4XRZxOEvGvdKeGSh1hZna94+yUMavORi6ABAAMXtn4u1dASZ/oEATZc72EBsiatxqNtjc+FXK2Hxjr8nVbWlrCU1BgW0lm2m/lDtXBKexuFhDEdr3PE+By6dBo3it0gDY9jdBh2ZdLJPlYvoEBsGGNYogWl0gE7ayuK27oWdLK/MLruzvb2cDQktNcaLkR9DC/7B8zsG0eiqVnk5p1FbHGogMNLMdWqTEU/SSgJoFVSPJ2xqbEmBxU5Q8XugbblH44u3snLj2B8XIrH3UUFhHWSlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add MEMBLOCK_NODUMP to mark regions that should be excluded from
kdump vmcores.

The flag is meant for reserved memory that carries no data useful for
crash analysis. Reusable reserved regions such as CMA may hold useful
data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
patches wire this up for /reserved-memory and /memreserve/ entries.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d62db9e776cf..b2fcf11fba2b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
+ * for crash analysis (e.g. firmware carveouts).
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
 };
 
 /**
@@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 void reset_all_zones_managed_pages(void);
@@ -306,6 +310,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_SCRATCH;
 }
 
+static inline bool memblock_is_nodump(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_NODUMP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..79231634c25b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1204,6 +1204,21 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Mark the region as not to be included in crash dumps.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_NODUMP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2886,6 +2901,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


