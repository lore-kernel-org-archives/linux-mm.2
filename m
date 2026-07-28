Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 842A4C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7E46B009B; Tue, 28 Jul 2026 15:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580446B009D; Tue, 28 Jul 2026 15:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422766B009F; Tue, 28 Jul 2026 15:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DADB6B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:47:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87543404D3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:28 +0000 (UTC)
X-FDA: 85039219776.02.6259751
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB333180008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XIYSx6ZM;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqMrLj14znUg+sEtuaSkWx5HGI/GWtvDstY3+0sa+Dw=;
	b=lcqt+5avVvcaaMusy9JH/wZQko+PoIHEZypO3lo7zujTrWaiZlljKJWCXHRmE5mT3JB0s8
	Wnsn/hnv6c9p4YRhn1w4yEB1SsFZBzCLUjEVF59YXFLehH9UfaIj7xgmG7Es73RqqKeHrx
	ieQEJV/rborqKF1huvmx2Jci6d2l5wQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XIYSx6ZM;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268046;
	b=qjpowKJEw1MlhvhG1zw06W2rLaN9pLsLq+KlUcv3cdY6qL+DbyIqrhB178FvGo2Hr/xeUM
	vZEnFgDidCIUufPXa9PGvQ58tBtOE/U5KI5LReEI6xH5KGSgJX/iAKsl9blnqyTsmGEh/c
	BsCJB90GcoIOQVrJ2DWvSoQw4MurHQ4=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e6a434cabso16671785a.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785268046; x=1785872846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jqMrLj14znUg+sEtuaSkWx5HGI/GWtvDstY3+0sa+Dw=;
        b=XIYSx6ZMbAZf2biD6x9qsGhp9Q1HqkDm/rpJrZ8T7hFhfQXsAs9nfDfSlCOXuWiT6X
         XhAfLd1U4qNFPj8oE1MZ/dqglWmWm6kFmWHqQCKAnTN1zqmvhoRPDn7ShqJ5+HlvAQ77
         FEv5eET/ehSE2/SQKcX4qIfQVgwRCyNVvDIttqeJke48dUXnQPXk9087gGCM2YJ88LYp
         ddLso2Xjvf7ECO0CZpydiNBzQaS+FJLzw0vbf4DCLGd/0kx7gApwwqXdGwvOlA+F8+Bs
         1Xk7mdtpJsa4PiSnJ4HNC8RvbfWG98TVpDgafxhumBt+UQfLjNqw1eFvtjyWusL76QUZ
         Gcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785268046; x=1785872846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jqMrLj14znUg+sEtuaSkWx5HGI/GWtvDstY3+0sa+Dw=;
        b=P/4HALpk66AMo9qs80T+MYlBFBoKHF1LQ75ocOnkAnJIRY89zQ/h9srXK9CUjuHJss
         tLQQa6v335BinWMM5cXSdMdPkp3F2DRPWMTlSQx2NVZzGl/pekwLS6eAOlG8biLoc0BK
         Us30GCkQu2duQs1wvtr0h3Z1A0y/DhqXVfC/QaZj7VoN1+zoL03AiPBJ/W4gbFN8YKFn
         boTd9bE9xU+YY1MFrlPcO1ojWzdE1zQ2kmsFzF8AQCVnCe7mNMcSw4Uelh8hOl90c/ED
         Gv97Et9k0KDvi9MXdJSBCPyhBxAQJy8s/31YybS35vJiLH/U8AdXoAsH40coBY0WVNiZ
         fayg==
X-Gm-Message-State: AOJu0YzqXsGUtAwJBKmmTRuDDlLjF7lxhAQpmhm2EgUQb6QMVqNptQO2
	WnZHMF62rUGJeRePpKefdq3Uo1H3FeL8j0+l9a8w9xrfDP1LdODFjMRMwzYzwDjBVYAQcGTJ7l9
	WW8zV
X-Gm-Gg: AR+sD12WPm7Luw6PXCsn29WIa0AH9sv6D89b0StpWiPuDVb/+UluevGp8x1Z+Oi/WhG
	f4sCk9+4ndlOqbnwBegBZsPEYvzfM3EUnQ9U6XoyNY74chvD2YLkPbSEkJ1JK+r0fW9BGB9IPRj
	5yPdTR9rOM+GbyKE5kspyq4K5JcZ9HLdtdJzMzTgy4Y2BgnF28ZWi6O0UF2XhYGekuaM/6/dBmW
	aFB+HpXgXM45wkLpy1B8Lr1rvmDA53p2uR8Zv5seR9f3SfUVP7nlAQ0T/n3hkl0rwPOU8UxoMMq
	bKmxBAOLL57455762uJ+t+2AeH+yszsuNdQN4dMrK91AqmTfbNDL5i9ZpuUnS+oSHZ1qzURvSma
	gsrgGSJZn1+YyfPfN7qsiiny2JIqGkI+9SmHRBKA7f/K1MKcn+IX1lCfdPOD+r7Q3MzKYu2YfNe
	pIkvYqgcL3oeV6OEp3YzIVyl1PoOxsPsBvx519FUhpNoJAfEWhKQtl09qrHGH/64OzPcLe33R1C
	RPsp12ZqK93zsKf58exBf6zpmAENEuCoMLln1p3Y0y5LYXIUg==
X-Received: by 2002:a05:620a:40c2:b0:92e:caf1:7705 with SMTP id af79cd13be357-933027a9447mr385229585a.49.1785268045825;
        Tue, 28 Jul 2026 12:47:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd6b539sm6700176d6.41.2026.07.28.12.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:47:25 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 3/4] mm/madvise: skip zone device folios in cold/pageout PMD range
Date: Tue, 28 Jul 2026 15:47:13 -0400
Message-ID: <20260728194714.3713735-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728194714.3713735-1-gourry@gourry.net>
References: <20260728194714.3713735-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB333180008
X-Stat-Signature: snw73a85ngq9do4bfder9opti9qqgghg
X-HE-Tag: 1785268046-21561
X-HE-Meta: U2FsdGVkX1/Q2e1yZZi8g/CkNA3quSSp/8LssSosjeZ2KR4IcM2ur+9VpFqz9zT19LSkgbVU8f/FhIoZRliiGQmpSAV56OP5F9sF2EZUlCaVYcZ3nIyYp9Kf251+yAVkVp9j2snfw3DK0YzJJFI/0xNZAl26g+BWlJ0v9VR+ITkwKh+GsCuv360+YaCfIt/3Hw2ObndpQaDwQr/6hkQCYS83SRvcD27Tjow9paEcYZARa29vi0vNJ7y3F8ScG5wioFnG5Coqdb7VRnQ7wgTSuXx0fJug5TQa8LwQBtMQtNSfWmvNS1Byte4ootXPmFnbY9Qkjb40GChD0rL1oUVO+5vuIP/jGNGQsMOrZ3hn4pgWEbWdMbLYYMIKy1xtT+vqJKeNrLSxxf5bFVUIkuyRS3PdlzjLpjGob+c9uL8/aw1X2shOJVV2Lv5H4xNlqybhj8mob4CUTnWKujdNbvaRECDOuqYP1QUJC+dRvGTjoO/yC0acgLAzBmwtbIinPoW9Ax+4wn6/5OD/JUsXajr1+6BQadIEtwFv8/WydQW2GBrfu8C42uxBtBoAqZ4gbKTMcXfQ7/8wxOdE/I8x3xSv4QgJEZsM15kg8O+AUb1fXZMFE7ks0hteGB3tVPAQrISopoR6uCgdlcSTTiY05jnJje6I/rywir8zeGkMV9CrI8H44Z6arZulNMSPgYYCE7rlYX6MV6dpkX+MgKuCnxg0DWmP3A3DEhtvp/m1Oa/2F3UM8cqkdi2XbPiXF0ypNl15QCrAps2UmVR6CiKeu0z/9yiuuBM50pCuu4AEwIeQ3DpE/ZwxFfqkIj2oVeniQx7vNVNwv1jC28WAz3k5ZTILA+NVgHogtBAI1A6WOjBme0n4GR7KQ4q7MpNNjtosIftmo2UFzx+WHTA7wQPbg/R9t7sjoOohZ9tqSR7ZFWGIY6+YfnQCCqry4l1sMoL4a6kWj0gbDcpgx2q092dzJuK
 ZXbcW6C7
 LVAAY5SEnFPyJqXf7WXS5k9wQBUjREgoggOStNZgihkCyBMCfkX11IfliTYOpaABPzWWeVao/1Q2RFwtMq02UnyKgf5BMXBZ0tLg7jiAvVHMMTon72KtqKGV8CRVKTjYMJOloAjn6xKXwwK9ZDYUyoo7SvKtpNDqh8ZpqdXIY2i4uDJ5G3dpeX0yr5oZWmYYCOZG55dw9FZQ0gtxcYjTkE4lkDm3a93/SxTC/9YOZdLu43F95+0pD+aPqUByoGK30FeRa5UwpydiRheo5F03jf+m0cOmarXONtq47g/dH/3j6vQZ62dV87eLb6MY5pVreeCK11UzDtjqgzuhFA/rC5gCUlmm/0/LIxthyEx90OcZFWgax61Z9sxN7S8/WGG5daJMH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD
via pmd_folio() and ages or reclaims it without checking for zone
device memory.

The surrounding guards do not cover every zone device case:

  - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
    (so device DAX is filtered)

  - !pmd_present() branch above rejects device-private and
    migration entries, which are non-present.

  - A present zone device PMD - e.g. a device-coherent THP - is
    not filtered by any of these, nor by pmd_folio() (unlike
    vm_normal_page_pmd(), it performs no special/pfnmap check),
    and would be aged or paged out here.

Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad..ffd6a68320a8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -395,6 +395,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		folio = pmd_folio(orig_pmd);
 
+		if (folio_is_zone_device(folio))
+			goto huge_unlock;
+
 		/* Do not interfere with other mappings of this folio */
 		if (folio_maybe_mapped_shared(folio))
 			goto huge_unlock;
-- 
2.55.0


