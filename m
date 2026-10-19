Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA014606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=vRCjSre6
Received: by kanga.kvack.org (Postfix)
	id CDC3A6B030E; Mon, 19 Oct 2026 13:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CC86B030F; Mon, 19 Oct 2026 13:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D8D6B0310; Mon, 19 Oct 2026 13:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880706B030E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:19:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C363A081C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:19:49 +0000 (UTC)
X-FDA: 85340038098.19.E8EF3A2
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F207A0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:19:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vRCjSre6;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.210.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHAyG17ULwqYW3XMyT+/P6CxC7w9alZQfDxEUV7e7EU=;
	b=RoYgNcNCAcUXZpxwArwx9h1LLOvfjL/Pb7TAuZN9ynL1PrxUMN678jpUp82wcoB417lWf1
	PTEvb2Q6BGkQBWH1yovO+gM7OPftV6+iulLpIirfXXHkw9E13V8x2TsGsb1rcK+BCswjQx
	JO9b9Pt96CNNC9s84SIPG+R8ueXV+vY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430387;
	b=UdBCDDV6BxBJ66vRlNasZp9LmaYAQMNNQqD3v+FRfyKh4xusXqMU84HjvEynxRN/2Ex5+b
	LaQV6/TbDnaw8ygCBHAuhhf0jeXrJ5sO77PsjHj1eIdZClbO0Z2lABkm4lGcCetDBfCdVf
	wBVWkxSHKPc0uybpaTVvWtLF6JrDuuc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=vRCjSre6;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.210.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-8446af403b5so1162390a34.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430386; x=1793035186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHAyG17ULwqYW3XMyT+/P6CxC7w9alZQfDxEUV7e7EU=;
        b=vRCjSre6EOwYBi+hJWLqVJol+1Cm5nYJ4oLy4Y28e/mhAr8i9WBmkxht6ID/3B/bwi
         uzIvliIjw4vp/5fiytUjWuQWwg4dvHfxlVBcyzViNGnCfv6Ez5Uv8JMLTYnTfUeddh7+
         npokuNNRZ4c4zXYHAW0/vEXDU6P8bI7yOIJLP9PSenGOP1eMc17MwrZ8YTXM/eZruyh4
         1USc+Gi0tzSNyiNsyDNfc5+XTyrENH0X0wT2D+sVtwPWYW5iYCce1RpzuCY4SxW07Jon
         I2WlMExS61MhKmIp/pbkHBjwmZXFDb3sbMFrffy2ytcHRMv3ASAurKGlrRgkYtnkhxAG
         n0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430386; x=1793035186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHAyG17ULwqYW3XMyT+/P6CxC7w9alZQfDxEUV7e7EU=;
        b=MhqWwvnnH+yTJdPbKmSuQQytxy/+ZUeI2p4tBP91vwVoQrycR2RWQke9OS+K5O6JAr
         IZO4mBwnLQDvQTWrh8VlFWZoFLKWbm5cdpvVXQ5X7UKkLQlk2R2Ml5hcByuGWJo0sDW7
         vdcQOyJImX3URAGglSE/aDSCGmAqudbz6jKpP3ZlWNOH40AoyevT7uXQ98DPqBCuUJe1
         l2gR9r4HXwObWEUWA7e7Q6fa8yw6p4K300lrZj9dEAOoFw+rp/843iIftHpXy+nMSSc6
         Ks9g87xeh6nZ0dryj2fqTwhbUOJ+6kjAugoIxNv16zVeACU19RSHNexQqVsOsT796AFW
         oOsg==
X-Gm-Message-State: AFq9FYJUS1WZv7bLw4w56lx7vnATnoW69oTijnBdx++oZQR0FMHzUC6u
	LrGOY9oKKOmGsV0HuaLLDVcPwv6Gu/0R1sOxiZ6AeNDlk/5+umSryEO/ewrmS+56Mti2cUoL93R
	g+DbTJ24=
X-Gm-Gg: AYBFou1EjcTkdw8Dt6ufrUIyhhwqNG2tIJoTkQkFpQl+5lWdeBrqcIi4KcyhlvSTczl
	2xF92MZIiZoqFMvZ8s67TOCnBKEyyMFE/Sa307syiJzKUT85Y6Z672h5R99Dxjo3WekRAS/JmaB
	qkJVwmm5HQzBAzHl5SUHBQsqzbr3jupVpvvr4qdfsFk1zW3Fi4eqcOAd4GLL0GJY5MPj43ISlIj
	B8OvjgcZE09ZZQ2dX131abIBIbPibnJqb1p1vqjPgCo52lWo3ILFJR9hdT0/4/meLhEL/BfQqP/
	kDmYCjo0C2KK4pG6dnFpPNcLEqugReErnRP1k7ftQ8m0Q+8Cnd6Vv5cYiRNYcqN4zdCcKwk46O2
	xgP8j/vYsln2I4Qc0O+GAcy4ICObpymbdd0v21ejLc1GantFNK/eiat2A4Er/kH9qZEQoAuHhOm
	1waOm/WrSbU5aGwmAOURBajFDucppMBrQrYEVQh1GplMArzQ7kSuc4UIVZ53ogfYiIOBOdDEi0J
	txHYAPAajiWH+F26TRXiHDhxOD7oyF3vkBo2otrY5sFIb2an9B96HFw/3rR
X-Received: by 2002:a05:6214:1d2a:b0:91b:7f54:8dc1 with SMTP id 6a1803df08f44-91bdf3e5077mr140461206d6.50.1792429940088;
        Mon, 19 Oct 2026 10:12:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:19 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 7/7] selftests/mm: check that unauthorized MADV_PAGEOUT skips large file folios
Date: Mon, 19 Oct 2026 13:12:06 -0400
Message-ID: <20261019171206.3331374-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F207A0003
X-Stat-Signature: e75wmxep4grzpmimfipy83s7b3fkpktf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792430387-998734
X-HE-Meta: U2FsdGVkX1/sBk7KYQtnJxB976AtVuSKyYEzr61VWwJCCWDm9XdyKazua8zeSYh9Rwwvted13G0NONS/dWqB4wy7NAQs2sRjX56ONKfwMA8pnR2SCI9z52n9cMFfwAz+PcD1cIrshsbifk1yX8kaN+tVrtFPLow0JWw+OjLI6uwJGIUxJOVV24YFQnFn3PUIH9AU2Wct8GXqCYGzsyi8wdc2r1s9ISz2nvH/zaK/EglVIlfx4Iut2Md/UkXuBt7ORXAmqh32SWEgEU1bA32ufk3/XGpJ00FFIw34uKiBw4v8R3CzitufBQxz42V+B29HaorGgOIyTsy/ON5a5ULFE2dJGBe23d+AWOFg6x3WMB+PgG9xsvyWGORVRe7bX0pQCGNQJwEiYBUvikonQ9dOEwfKGMp51lgMc1YQrYr8hg2eFdF7+usPMXalLoOgXHb+Q+30QU8YwbL4GR4qrlo4k5g36mEP6toxKzet3cFslI/L6N++K8NOmyTohC2xrxkA6R3OO5LdpvyECHYQ6e8/tSP3lrn0jDQRJwYBCsQsy6jBgM+B8eMTI9J6SORaGotTu/GOWBNDtCvha5eUM08atC0Aw0xZF46Mo3eTlxiu9u8V7nhTYZlPP32JCKH9zXw2a/tlfx+UTdI0ffuSJxt4ttgEzOErVEtfOFqxsy9HG3yEJR7VTq0Q8Pj91nwAczNkG4qvdwvesDP4HfC2UP9YKIKVfNsum5l0TCESoAE8YYpuQcagxgCPTIkuSyqASzIXJd0p9y9F1fclcGKI6Nam3DsKXaamP2LdnYKJSvHXlU0BWB2rV0gvNqQ+nzuUw4A+sHvltP8UWS0HWSmol8M7Bih5uACx8G7bZr9dfHOFhaYe3rHCRT7qdZG6HPABZ7XGvjbR1YLoIpCFG31oikt4y0Wm6UTb3KEISK58X1+5E0LJeOz/+5a5Co+nv6c+SSuslmtvw5+Na114spRZjng
 tbJAvm+Y
 wZvuvRPhf/CBYLa67nYtZv5foFnGZE5brJmOR7ogNcRfQqiMaacvm3dcXMo6OszDXhvfANTlp5MEjoJu8mG0X0ebNoQyJWYgd7o01PJSLLpVo9mP1R5TIKZcmlodnd16ZSD6fWaijf0IqYkH4849TjBxJQEFtFRp38jsBONJ91oeGx97jHc0+NXYkJ4QdentFC9dp3DCdCmNvII6ZGB8yXqu3oTqYJtlcOuk2Nfj5jCJVFVRwkT4DhrjkhZGcmvxx3279hFkGhyvkpa8zYPaNiDgjXfO8TcS3Q2suHotAwt5Uqtmig+9wZQRtjie/kwY8NYPQCCvzIdP3UdxPZeY/wVM3E246LcOEfBgGLg7fo0LcSqgadmrxFCLeHTvlOvkeA+t7pX3fKmDbMj546jOljYvzGiciY/cPkOgw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A caller that neither owns nor may write a file may page out the COW
pages of a private mapping of it, but not its file pages. When the
advised range only partly covers a large file folio, the folio must be
filtered out before it is split, on separate paths for PMD- and
PTE-mapped folios.

Splitting a file folio unmaps all of it, and a partly covered folio can
only be reclaimed after a split, so a split is the failure to look for.

Check that partial MADV_PAGEOUT by such a caller leaves every mapped page
of a PMD-sized shmem folio mapped, both when a PMD maps it and when a
mapping of half of it maps it with PTEs. Since this checks for a split
rather than for reclaim, it needs no swap.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 .../testing/selftests/mm/madv_cold_pageout.c  | 114 ++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
index f5a81d7bd08b..5a226ccbacb2 100644
--- a/tools/testing/selftests/mm/madv_cold_pageout.c
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -195,6 +195,33 @@ static void pte_map_thp(struct __test_metadata *_metadata, char *mapping,
 	ASSERT_TRUE(flags & KPF_COMPOUND_HEAD);
 }
 
+static char *map_aligned_file(struct __test_metadata *_metadata, int fd,
+			      size_t size, int flags)
+{
+	char *mapping = reserve_aligned(_metadata, size);
+
+	ASSERT_EQ(mmap(mapping, size, PROT_READ | PROT_WRITE, flags | MAP_FIXED,
+		       fd, 0), mapping);
+
+	return mapping;
+}
+
+/* Create a PMD-sized shmem file filled with 1s. */
+static int create_shmem_file(struct __test_metadata *_metadata)
+{
+	char *shared;
+	int fd;
+
+	fd = memfd_create("madv_cold_pageout", 0);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, pmd_size), 0);
+	shared = map_aligned_file(_metadata, fd, pmd_size, MAP_SHARED);
+	memset(shared, 1, pmd_size);
+	ASSERT_EQ(munmap(shared, pmd_size), 0);
+
+	return fd;
+}
+
 static void assert_filled(struct __test_metadata *_metadata,
 			  const char *mapping, size_t size)
 {
@@ -792,6 +819,93 @@ TEST_F(madv_cold_pageout, pageout_private_file_reclaims_only_cow)
 	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
 }
 
+/*
+ * An unauthorized caller must leave a large file folio of a private mapping
+ * alone, even when the advised range only partly covers it. Splitting the
+ * folio would unmap all of it, so every page must stay mapped, which needs
+ * no swap to check. See pageout_stays_within_range about other unmapping.
+ */
+TEST_F(madv_cold_pageout, pageout_private_file_skips_large_file_folio)
+{
+	char *mapping;
+	size_t offset;
+	int fd;
+
+	if (!pmd_size)
+		SKIP(return, "PMD-sized THPs are not supported");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	fd = create_shmem_file(_metadata);
+	mapping = map_aligned_file(_metadata, fd, pmd_size, MAP_PRIVATE);
+	if (!collapse(mapping, pmd_size, check_huge_file))
+		SKIP(return, "could not allocate a PMD-sized shmem THP");
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_PAGEOUT), 0);
+	for (offset = 0; offset < pmd_size; offset += page_size) {
+		ASSERT_TRUE(page_is_present(self->pagemap_fd,
+					    mapping + offset))
+			TH_LOG("page at offset %zu was unmapped", offset);
+	}
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+	close(fd);
+}
+
+/*
+ * The same holds for a large file folio that a private mapping maps with
+ * PTEs: every page the mapping maps must stay mapped. See
+ * pageout_stays_within_range about other unmapping.
+ */
+TEST_F(madv_cold_pageout, pageout_private_file_skips_pte_mapped_file_folio)
+{
+	const size_t size = pmd_size / 2;
+	char *mapping, *shared;
+	unsigned long pfn;
+	uint64_t flags;
+	size_t offset;
+	int fd;
+
+	if (!pmd_size)
+		SKIP(return, "PMD-sized THPs are not supported");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	if (self->kpageflags_fd < 0)
+		SKIP(return, "cannot read page flags");
+	fd = create_shmem_file(_metadata);
+	shared = map_aligned_file(_metadata, fd, pmd_size, MAP_SHARED);
+	if (!collapse(shared, pmd_size, check_huge_file))
+		SKIP(return, "could not allocate a PMD-sized shmem THP");
+	ASSERT_EQ(munmap(shared, pmd_size), 0);
+
+	/* Mapping half of the folio leaves it mapped by PTEs. */
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	assert_filled(_metadata, mapping, size);
+	pfn = pagemap_get_pfn(self->pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, self->kpageflags_fd, &flags), 0);
+	if (!(flags & KPF_COMPOUND_HEAD))
+		SKIP(return, "the shmem THP was split");
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(madvise(mapping, size / 2, MADV_PAGEOUT), 0);
+	for (offset = 0; offset < size; offset += page_size) {
+		ASSERT_TRUE(page_is_present(self->pagemap_fd,
+					    mapping + offset))
+			TH_LOG("page at offset %zu was unmapped", offset);
+	}
+	assert_filled(_metadata, mapping, size);
+
+	ASSERT_EQ(munmap(mapping, size), 0);
+	close(fd);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
-- 
2.56.0


