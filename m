Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97F260A3838
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Fvw1XJyz
Received: by kanga.kvack.org (Postfix)
	id BF6BA6B05B2; Wed, 11 Nov 2026 06:08:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD43E6B05B3; Wed, 11 Nov 2026 06:08:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09DB6B05B4; Wed, 11 Nov 2026 06:08:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81E956B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C96D31C0226
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:26 +0000 (UTC)
X-FDA: 85422564612.16.3C72341
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10A2E180006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Fvw1XJyz;
	spf=pass (imf06.hostedemail.com: domain of 3p0z0agoKCHAjRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3p0z0agoKCHAjRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wg+r/G4UynsyjzcD9VFm7KNuI6HhIxNTVl9eF5+p1ZQ=;
	b=Q/eQw3inLt5nTVHDlBCXai7VRqOlcALWdZnnKfo5KAljSYu6ip4SMKKAwWqa0dvjmhtxXM
	QAO+UFcSkQAGlyZo71iaViSoHIGAP9re6r3DYk2Tb81LBDBBu72kUquBPeNjlqJ0BDZQqX
	monwm1t+2UaDTxHpg69KXFxyNOQmTFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395305;
	b=xo8BUSVTZoerP0dVb2R+Wp6xtZqe7dpDIas9ccg4y6aDlZB+I9qyWD+rydmGwuxDeVT65+
	DD7A620VpQhG27p6i8gDi04NpPIMPqrYLF4lh1LxsUnZksicuIlp3tp6liZ0M2amnt55x1
	Gu7Y6ITZ2JsfNN/FujppVuimM/VtqyQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Fvw1XJyz;
	spf=pass (imf06.hostedemail.com: domain of 3p0z0agoKCHAjRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3p0z0agoKCHAjRcbbSTcfhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4ba078abd78so6911895e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395304; x=1795000104; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wg+r/G4UynsyjzcD9VFm7KNuI6HhIxNTVl9eF5+p1ZQ=;
        b=Fvw1XJyzG/KtVfywoQe6CW+4rZDFWqfAkBThMQYrfW4HdoFJX7jgtXiwR4JIslhyMa
         MxLUFs4KExFysy2MoLv8DSCkoqMp7ytQCJrBpuNJ5b1LxynT9Ifn/qsf+j8QSw1QKYOO
         LlGfHrTc/+RAsg/l14HS/IeQXosKpSrFdsTxCB+GqJZQcgpHkEI0MSAry4JLWv5NAPVZ
         My+qClcbXZZ7XtCF6dZ9amGbkpPg+HcvtzQlzS8/rvcHFy5zHb4CTnepae/1DS235fxP
         XGCV8biE4BQBOOXdrlWffMtfEC2kc9jK/UITl+5qrsYsaiA/0CrzYTrdTvQuzsXtwRRp
         tBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395304; x=1795000104;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wg+r/G4UynsyjzcD9VFm7KNuI6HhIxNTVl9eF5+p1ZQ=;
        b=NTCN/jifR3DjSLUDWDB7pZ93+U2AknPLv+P700pAWZLUJuBCEYexYNHAKoOUkL+C08
         8ExDePZC0+dwGydnvl25wIcVqGRRlUEYi48E/pkArZGppqu34I/vsi7Cjir2SXCvDV3u
         zpf2mN5hZ76Gyr4xCeetvjZUFdR++FgLKGnRR7+vFOjwrQQWAZ87xJyDNCEcHL3H4P6A
         Qtc3UMb3DvwGcz+92vgOkCQ5ThJIWlsmVzL9GpUTDWMO2T6KUFWwEIs8wl+tsDOP41FP
         3wGzl7S6NE4MY5PreRd0SjHzWabvHxgBZaAnun/R8xGQ+J9dXfnFc29XerOm5LYFhuUx
         b9Ew==
X-Forwarded-Encrypted: i=1; AL+hErGrGPenhjI/t73DazhzBRIL/O7xjqFYW9gFL34Z6UfvY1itlDANfHYdDawx5zEdcvTvxbjVxbclsg==@kvack.org
X-Gm-Message-State: APuU4Z8WSx2DAS4OULMiY0QxlM2ym2YX+anuQ5sogjwe8vd8Z/oKgD2m
	+t9j6suNvrUACbVotvMROGPolb6XqCCREinjBFb2LDzByPjNvexhm5Z+E7VcPRq4VlnxmcJo+4b
	SRgoBnFA9/yRsGO1P+n9FXQ==
X-Received: from wmo18.prod.google.com ([2002:a05:600c:2312:b0:4a5:34a9:6903])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:82f1:b0:4a2:cbe:beac with SMTP id 5b1f17b1804b1-4ba093c85ebmr40371365e9.23.1794395303273;
 Wed, 11 Nov 2026 03:08:23 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:31 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-2-vdonnefort@google.com>
Subject: [PATCH v3 1/8] memblock: Introduce MEMBLOCK_PTEMAP
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xp6oja3ebaoj4gtd183hz65qmxfgc57c
X-Rspamd-Queue-Id: 10A2E180006
X-Rspam-User: 
X-HE-Tag: 1794395304-848985
X-HE-Meta: U2FsdGVkX1+BBvDTjPdKwlGRaHS53u4UP/AVzd2tK0WvKXtL+uI6k3XjHfm/2m1GS1AuezN/67CsqHYAKN/OzkrjrdR4f6f67qVmnzqUHkD/RXYcVNymfrYXPFyUcYxBcHBdJA0xmlax2QylsmbPhucWLjsMX8YPyOi4r7e3Fj4OX2r6XrU4jjwX3iGEfxvtGEJvD1WdaAy0TB+VJhVFMofLt+b7IjlhFwD1pHjLp/2rrbYHO1lvd6cdWaVM9GgFWxRNp14uCZN1/vL1VbTjm1ct6t0cDAZfClAKTEmgAqpH6kXZD2ng0s/Y3zGT2ceJD6Yfe1SdN4NKjAm7mVRtWC9vqC4vZmRz4RsxOWYSKnrxNgbl4icRGgZk/bozYXbACvNYmttVriNdDeq7ZHuaZc+NGjNSeMk2UZsGcprs5qKavtT49TF2wIpe5Uh5GQMQ+FeNoNCbivS65Wlaxu5l+7Vw3Sc2gu2zogoL1E7YZZfH8wHmtLyb6mtIxWlFD1/toHIneVouyAZ8PXiocqrhW4a+/LpPf9ga/2N/58V1aZrS/2bb9PQR3hTRsYhjg4zlb4CR6PtBNH7LPwNIOou8uKWxFYDxp7qh0rLJVKJbgH5tnviRU33wjORJiGCPoV+KN6kANknh5HbvJfVXsozivfWS/5J6HVF+tvUrP1kqRY0VVeU2ZiEPig/bVgUGCcwUNYRHdEruJ8drqkyQ0SYqHRBTS9jSbDV6hEv/Tg0EOuzQAZnKYJK7pFJ1zazTRI7xwudIqxMLuvdCTpDaevRf99G2EBYbClVRyG0prZULxQC88gOHGKW9phMYVmIQtrVeSrjjwuB/OZFoutC3Bumrbxjy03sjUJ7e+M7bnR+zIp+2CoQ2KPfIHe8lLdEBr4VKjq+abLewEhrvpLY2/pNEbFQvVKDQWyt1X9SeHjyrxzlWfn7xWgsfzPLBlsVVlbpiydaSBE9eJd5M7/7kU1T
 ouibVNfY
 M/hu2vK4bIsui3DP1cNQx3wWMCEiFJVzc37RTrJnp/59ALqiOQ/gVKb6DNiz3JnkL4gWl8xv8jrpVJERWDJEzXt5JupFCWssjazVdhsOT+4fBEw29lznDkRpF9VfXcBKBFygnRhQAfyy5YsW2+vrCRdMFZ1OJXDOM28lfF1498ZBzg/XaFkw3i06C9Sy4A1vkPAQZjHOGHmaThrU84tm8kyRwzu0AVDtrTsD94CE8bBvARF3zAACUrqLPzL3OUD31QrH997nw90TOz0ly8/JbEQZm/bclzEP6JC9l62On7070sGonGQRPbVae01e0SLD8T7g0GEJeOznlLVUflnhgnXRCLMoCmCHrJm2xnz8JwGRzpTB758/wwU1j3Nlp2TgxFLLEZsAlFpWwNGoLQwvhyr0V8q2bfPSXK7QBGCunPD7XbekAIaS/lQFa59WSgylT7b6E6AWGL/ze2oNR5UpVUxdxT2Dk/9JE+SkboP/hssPkN6JJ3DXUiZveHaup3L5BVogWPvvgmGXQqyrjK34bmWoBp0L3mNm9p2Zb2CidTnyz0i6aFmGSldL4Isj9TSaCO5bUsq1as+p8/3+15lmTc7pikam8kTYIXz4lT1/q6+DmM66We8kJbukBH2Fxng+y2iMAXEDAtQWxyAsqMaRSADy05WzPWdVl/RYtleszDoekebjQKm6d36O7bbnhxgnMsY65PhvDrnOEel/5GGctbNkWsCX4TAAGhe1drZRXAcNajJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Keeping PTE-level mappings is interesting for arm64 as it allows
mapping/unmapping pages from the kernel direct map without the risk of
splitting blocks which, under the break-before-make rule, may trigger
page-faults the kernel can't handle.

However, mapping the entire direct map at PTE-level is costly. So
instead, create a new memblock flag MEMBLOCK_PTEMAP to selectively apply
a PTE-level mapping.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 40e6e0aa2f8d..67ef20a1c5e2 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ extern unsigned long long max_possible_pfn;
  * know is good to use. It is the only memory that allocations may happen from
  * in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_PTEMAP: memory region to be mapped using PTE-level mapping
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +64,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_NOPRSRV	= 0x40,	/* memory with no KHO preservations */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_PTEMAP		= 0x100,/* PTE-level mapping */
 };
 
 /**
@@ -160,6 +162,8 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_noprsrv(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size);
+int memblock_mark_ptemap(phys_addr_t base, phys_addr_t size);
+int memblock_clear_ptemap(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 
@@ -305,6 +309,11 @@ static inline bool memblock_is_kho_noprsrv(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_NOPRSRV;
 }
 
+static inline bool memblock_is_ptemap(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_PTEMAP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index a450092a80fb..b8b6e762917a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1068,10 +1068,15 @@ static int __init_memblock memblock_setclr_flag(struct memblock_type *type,
 	for (i = start_rgn; i < end_rgn; i++) {
 		struct memblock_region *r = &type->regions[i];
 
-		if (set)
+		if (set) {
+			enum memblock_flags map_flags =
+				MEMBLOCK_NOMAP | MEMBLOCK_PTEMAP;
+
 			r->flags |= flag;
-		else
+			WARN_ON_ONCE((r->flags & map_flags) == map_flags);
+		} else {
 			r->flags &= ~flag;
+		}
 	}
 
 	memblock_merge_regions(type, start_rgn, end_rgn);
@@ -1221,6 +1226,35 @@ __init int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_NOPRSRV);
 }
 
+/**
+ * memblock_mark_ptemap - Mark a memory region with flag MEMBLOCK_PTEMAP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * If supported by the architecture, such region is mapped using PTE-level
+ * mappings in the kernel direct map.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_ptemap(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_PTEMAP);
+}
+
+/**
+ * memblock_clear_ptemap - Clear flag MEMBLOCK_PTEMAP for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_clear_ptemap(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 0,
+				    MEMBLOCK_PTEMAP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2854,6 +2888,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_PTEMAP)] = "PTEMAP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.56.0.542.g3ef89b7020-goog


