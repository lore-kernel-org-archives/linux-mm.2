Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7117606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=fYyfMsAM
Received: by kanga.kvack.org (Postfix)
	id 8AFC96B05B5; Tue, 27 Oct 2026 00:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8873B6B05B7; Tue, 27 Oct 2026 00:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2F06B05B5; Tue, 27 Oct 2026 00:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2306B05B5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B64D1408DD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:26 +0000 (UTC)
X-FDA: 85367109492.02.4DC7E0E
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id D13AC40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fYyfMsAM;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/I0LmBFR7uBLBrLDEFm/yc+s/I6APM2Icy/EDbK9iQ=;
	b=aGuaBZT9xeks4m6qa0sRQn0/hIsN/UzcBzmsDpxlHc80vHLo72URV3bohlngWjRjeo4an6
	eSyu4o7roi4c43ex/h+/GbB9AhOXuFI8PUu06X9tKpO0khSaQdI4gutcDQmZBLkFliBcgP
	AYWqoyDHf/B3z6Wiy0B5GQGZHDQgEd0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074944;
	b=cnyrZ05GxW16ofRQXEcgY8JGELumBXOde/OTTt6sHs/qQXnmbx19LQA5XAP+WGaGPK60Qn
	UHxsdp6PAoIFEAAEDWl7LY4OOCfzmV4JqGumIDLxGysgw1YZEOLGACK1sglE4rmEblT4UY
	zhld+VwIoxfmOi76e+WuIj3FO3EPVyo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fYyfMsAM;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91791ec1b83so29567066d6.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074944; x=1793679744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O/I0LmBFR7uBLBrLDEFm/yc+s/I6APM2Icy/EDbK9iQ=;
        b=fYyfMsAMoejm+htL7vmq76Xa8YH+L3X6qqr+zmNoNOUhe6FuytOL6xCUhbIQ94KMnT
         sh/xyQ2OV4pWpJlHEJfJRtpvfHucVwWlLE1jOChPUN15JnMQ//0fp8QeLh1rkZ2j27TV
         mlCVanK/fRu5dZ6JsutDbP/SIg6nDlRNaFYnDwMBVVg6VWBGw7YpcKDIrUpUeOLuLzka
         eFvoDauHfPK0B6HLcqK47sDSCBI8fH9t90akpOqVNzs0YuIHyfRVEBsiXXK9yaitHXEi
         HYdbC/Lh//ibk/g05CgbgD+E/RZYNeGKkImrWVsJGv/E11iRB/RwOmjrQHG3ZRI3vfFc
         5Yng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074944; x=1793679744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O/I0LmBFR7uBLBrLDEFm/yc+s/I6APM2Icy/EDbK9iQ=;
        b=CE8d/Pzr+Hbrqhd5Ay8k1fgVbSKAXzPnODw5DD3dgcqkeLeFgS14YOl2ljc/CpEHwk
         bd3ciejx8VN83lVXU+6VUBGcfNC85mbfCBLjD1MPIasgqR/XNV6JwiBR4O/NEB6zC/ya
         PMVf7uPiYE0dHK8D4q+PYfCE2YnI6GnDg3HLhrN+5wDxnykHbktI6kEB1sz/SLAadMfL
         M2mGvEtklwm5EH6WVq5eVUEGJcae0KkF1UTNxx3aQB5hRvGgVP/WckcqeLQEbO5XdkQR
         hwYHKIOV4IWVEhCOJo4ML7u0B0LUVpFroe0ZDGgOXfiW+TH2luTeaIYKDATLB4ViD3Do
         /F4Q==
X-Gm-Message-State: AFq9FYKl0DsomA4L0zdiP8ePZPvTsOTAaAdJIUpCL1hS/5jH6RQVVomb
	58h41dnmseGvatO7CmG5vnFOsv9KVSs+uZFluos9+4c8HMKKA8wmEHqhpGDCvSN45rsA4xXCLqs
	EUIuB8bQ=
X-Gm-Gg: AYBFou26tUASX1Dh19YmFwiV8sKGsyGAXQCkytUKuhVvD9kqzpDhGKRF9HOu5fjn6+5
	fX0MVH+Ktf6H4losmWYtFco7EcWTcp1RjmlQsgSfBdCl0UcBwIokDd+YObwrOINJs3YC5cAHWah
	yiqj0X+pwVL+edFvf29ol4rhEcR+L9KhKxaNd0OJh71ytypawJRvflcSbrioNu5ZgjCnZeSxBJN
	f+8lrfSM87LDNB5IhpCtNBm6MOLI+KNWXbbSCc4ciXXgAMBx2PC9/vq+hqf31/vv22/PxPNig2t
	TaoP3/ORaU/d1WEZF3IYm5WrsMzgB5S1BKFjpkdybzBWdTq6lxdJ+p5UHx5gIHCaD7umg9f0deL
	ehKkLXcnsXRE/jOaoMer9B+U6/o0PrW1K7vdYw6QcBEQ/bs2Y+3Yon5K+wCAA9KeZgQ7XULVRzS
	VXlNpEELdxFvQiN4CxZ5NlfeM8KBwmV5jG21o61efOnC6dlht1BsX1SZmC9FjC9uFCjVD/f6C3/
	u+iSsEtOX+Df6iO4Q9jSVQsTUVxMGCqgGkM5wDCQVkazTT6981fyBenpeIxfh81bL+vKRUs9MiR
	ZqikS0KmkqQIp9b5iwwCrgYryXte1wvNedSkka68zA==
X-Received: by 2002:a05:6214:800a:b0:91c:60e8:a8aa with SMTP id 6a1803df08f44-91c60e8a8c1mr69350086d6.49.1793074944062;
        Mon, 26 Oct 2026 21:22:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:22 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 4/6] mm/page_alloc: don't undo another isolation in alloc_contig_range
Date: Tue, 27 Oct 2026 00:22:02 -0400
Message-ID: <20261027042204.3741307-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D13AC40003
X-Stat-Signature: yha5i43dtn8schqrxd3ckwt96jxyru9c
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793074944-976855
X-HE-Meta: U2FsdGVkX1+XHUxm2Hb2+yUydTDjjXVnkZrEnsmdXzqZtbLkeB03B2q/UL7TntB4ll05xhKLhakaA9JRRNoFxMPtZFivpwuz1DsYO06Q57GC96D7yd784R7QEcEJYex5ok44ZYxVEXnaUH4JCxvhHHApDT39VeBdPc0o1s4LI5tJlUvzbuSWCjUX9sx6FNfBY1i7Y8aSW/Rq/pswz4JJ9xl2AegU+b3Vha1SY6MKknmgXR4iVV0ENcK1nmSPmt2QLgayIm8dHWntFyh73SU/Yk/+r17cDMzRyeyOWysU9dyuMvGM9j1oU5y7gjPQtquF56gbLauK96sT1ptVTcU/vsWOYPObHCIAvwWSg8sKqqE+0y7L5BHDC6ExL85vPLRVX5teRLbpBBx+q2diSxh6t9ea78J61V7Is3oH44aK5whuqySIvxXC4NTZjZ5UkXGSqNKqp2ZcL41i6aom/dlll0JqEOFxf4wmQFJLJKzIoRHIa0ca74SHSsfdeLwunC9XbKIGo22261FTJgzXTEGUvEWixghkQaEPGsFfqanJoubvqtnjlFnFMdlAuM5dVZAG31lIemOGVAQKrnf8m7OV7NxMSv81pVGTt8NZc39A4nOhhVrSFl2lM7u7yiRxO7bvd/C38BI5fVXBtBq5DaFSTaAXV6t9RTu6nDJ4ENOilQ5ee6YJ8Wl0WHiLTbnhfhUF00Z9tuFT+vD1VcLRDqOQOZ0FmFIGP/R5SkQeAEnXATm12orUfU/U0r+Ri9fIpHoX3sDJ0mT64cwpMAdXsSSHINfFZBOLNwJiYNrvEb3XsVQ0g35ZJ/2ZSEVK3Fj+0+NWAceX9ug1QPNmLrR9VF8KvwM8rmQ4mfJY8eHRHN8lPso93lEuHLFUQOahzMq20Q73lDb/p15WZ6IEgCY2PcrNSwASohsNI3HtDQnGgdQPsjqqPWiCPjmhGiyvZWX+Agmx9guUme25SPcjER9kJQl
 qaNTDe9d
 Ii2B5xKhEPh7OX3EqDSjdxMqZ0kRTS/t4Wp3xOw2V88iPyTnMRUhXNIQfaGFAtbrRVqTLssIKFoLOPVSX4Pt5P3q5VBnvUiKk2Plq1LAX7AqZXQhEJpd3bcz0ph6nLPDjLVa91Op0t0m0kxbub1x1wsZUly9vD9kZXsHEcEW7C+ZGgtGBuxhOxi3h5liktGSsnAwfiTxUftz18G9VDKmdd54uL0Hdj9UiegZAelUqTHWljO2xi7eQcLSyx0+ie53V2eoZD0IDxpx52QkuLbz8LvkmnaA1dzr6MYLSs1iLJT6ECJntw+8K67jzJ+TdpkbCJfXn2vERySb6Q89EtONXuLbGG573upwQGrl+yhrkEJkGicTivjJCXckYr3Qi3pkyHOfSHC7/foVN+shgzEfcpJL+fV8BMc7itbBFpuJxPg90gQVgTzPF+X4bBe7g77gZcAe4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An alloc_contig_range() that overlaps a block going offline can leave
the offline spinning until it gets a signal, holding the device hotplug
lock.  When isolation fails, alloc_contig_frozen_range() undoes it over
the whole range, clearing the offline's MIGRATE_ISOLATE too:

  CPU 1 (offline_pages)               CPU 2 (alloc_contig_range)
  start_isolate_page_range()
    blocks are MIGRATE_ISOLATE
                                      start_isolate_page_range()
                                        -EBUSY on CPU 1's blocks
                                      undo_isolate_page_range()
                                        blocks are MIGRATE_MOVABLE
  test_pages_isolated()
    never succeeds again

start_isolate_page_range() fails only on a block someone else isolated,
after undoing its own, so this undo only ever clears another caller's.
Return directly, as before alloc_contig_range() went pageblock granular.

With offline_pages() parked after isolating a DIMM block and a 1G
hugetlb allocation made over it, the offline on base still loops 30s
later in 4 of 4 runs:

  offline_pages+0x5b2/0x1570
  memory_subsys_offline+0x17e/0x470
  device_offline+0x250/0x340
  state_store+0x88/0x110

With this patch the allocation still fails, and the offline completes in
3 of 3 runs.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 55d3fc4b307f5..bb3c7e95f2ed4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7396,9 +7396,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	 * put back to page allocator so that buddy can use them.
 	 */
 
+	/*
+	 * On failure this has undone its own isolation, and any other
+	 * isolated blocks in the range belong to someone else, e.g. offline.
+	 */
 	ret = start_isolate_page_range(start, end, mode);
 	if (ret)
-		goto done;
+		return ret;
 
 	drain_all_pages(cc.zone);
 
-- 
2.53.0-Meta


