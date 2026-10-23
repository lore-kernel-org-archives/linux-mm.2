Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32499606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cD8tTkRR
Received: by kanga.kvack.org (Postfix)
	id 6C4486B0C04; Fri, 23 Oct 2026 19:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675816B0C05; Fri, 23 Oct 2026 19:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563E96B0C06; Fri, 23 Oct 2026 19:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 282936B0C04
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:01:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1B261A018C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:32 +0000 (UTC)
X-FDA: 85355414424.23.D1B005B
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9DA271C0018
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:01:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cD8tTkRR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792796490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOIeq450FayerOlfuNbHHpUE27uCvBap02klUGOjglM=;
	b=XzHVtpxx2RCiqsI/YKhJ0eeJjti4J+UOMJmqrp/jTGs8tyBxuWSHk77U/aFh23l/B6/40G
	CTWpp8+XMNlSNWcrNb+T0s9bOjZmw68BbyGTI48VgN7GrAnSzWDFHmuyTUEjJoBbIyiJ0j
	JagcX3nFPTlR+tO/RIHPSO56jy6Deo0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cD8tTkRR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792796490;
	b=8b2L3YNZUfqF9acFmGr8fJFfH1EqQBN6r39wSllHeI2LIQ2DGARG0gVEchIk7I3SuGsY6T
	WSOH+KLPkl1Km5sFCz5pZOblwMXVRZVF40nhYajazOfidHyxNcKtwJBEJFa3z+vTkL/DF+
	SqAATyR82U8K4f513/nO5kC1P3bAkjY=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8aea7b7ca0cso12011097b3.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796490; x=1793401290; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AOIeq450FayerOlfuNbHHpUE27uCvBap02klUGOjglM=;
        b=cD8tTkRR9EXLsQRibGxsa1Dzt5nw+O8DKGxApEYiLXyLExeCeZLLHT3wu84vnBMEDr
         SZ237D1CfRFq+j+K9TIGcPjimDXHWS0M4n2xCuQfB6KDlvgCzqh2Ouq0K57PcyHflclZ
         wevhBZ2VmrUM+tcMCokiIwq3i3sM7urJW/QrXn38GHWmxt5Kty2rUKdQVg+BwjWsK3Oa
         ZlgjeHJR4ttSB8Dmluy87TIc8zP67Zv9ngQW+7s1fmhwOpSguziGRL88AW6BnR4iWv0H
         qf137n6sUyYw1d+F/z4EJ5aakAxArMwtM6m20cEl9DSlDImCPavWmf72XWSjE0zcrKNd
         s6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796490; x=1793401290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AOIeq450FayerOlfuNbHHpUE27uCvBap02klUGOjglM=;
        b=zZy1HJkTn1o+V/OOqq1tUZoCmVLOXKGIs9FniOOnJvAIE1WzjF28XRa8t9vOiVaTBQ
         hvXsXepe5zOq8M1bL7p6QgTo0MHPs8+2s3eEbjTPQQ9Q9/yta1rDU9ASQCivjr8exWev
         d0aP4rPrMi5rT24vUaqfCkvJmkjS3Jeaxnt0QQGDTrUUnHnSPqMhOyOTEY4aJB4K+89s
         v2GAXZD4fdDoPT88lBAvqjXFfOAXkPeDg6y23c2emQS1AfmtuP46dsL2EWk1u0W9n3H/
         Nh0F12iiTqhSTvPUYsXb4FtO4w2yQOAwPOTSda5vjAFWUnSTDZltESz3C0SDFhWE/6aW
         6gcA==
X-Forwarded-Encrypted: i=1; AKwUvBw6MQrxSQozfhuBO8U7bhm1h3iISU99gBxpozA7dhCxFp8uhoW98Dn7XHKtUTJRG/RPazUgMQZUeg==@kvack.org
X-Gm-Message-State: AFq9FYIhL7VLD+HXgsXufgQfXdFB3SqoGq/9zxlLRUOgGH0VZYfqU3vd
	AGlrhKvFqxPfl5gt6xRGYn+jAz8fQy8lbEXequBON7z00PikKK2nG4cU
X-Gm-Gg: AYBFou2AYL4cdpe/mL4wLnZSdHm2SkGTIT0fzoGs3xbH+fPS/lg6PbDE9P5jz0nnJyg
	dpIQZaVzMkvQZOMUuuSuXwOPngIl+DmZsNZnbHSypgUU4+a4/sFLxvtcv+JSEXp5xhxl7erS5Wk
	KzGKsRNLk0641gbZ2wMXofwH60tpDZJgDEjDhibVrD87N1JUyB4auv0gCb2zL5YYlF/HI3Y2gDU
	VCHv7/n4Z6kysz+WUuhsDJ0fqUgpbyZODO7fu08vB5QF9PrcFZWpJMfBTCc1Ftq2JTX+24c84SC
	kJvXEvkwDTZ3adhj0PysiSyi11EvUcxwaeDeZ3JTaPwrtTA4XqAvPxio2gEZhEGkLnrOPwrgHQo
	bc1wEp8gl+hniB8a9gVZ2hKfo3bPXP+SO17nw/eKjFhDEhPzKOglcMIAMC0T4+0QmvJE4Ckxkpe
	SrcHmdU6c85g1RbNKxp+pRk0mtI0y27fCRGCz1h/gmiRz+xWDh+ApdLoMVsXE8YoCMdnl3qrgFI
	kyIF5uvvGFkFdUKK51+iV2QX33jSZOnMn6aqJ12C0wLN3Iz3PavvTW0AFF/9c3bbwJ5Mf8I1dKK
	4iGpNx3TU1XVn5vib0WXrq8gTw3mRLTBuYcwbVdaIME3fIVmAhXMxA==
X-Received: by 2002:a05:690c:6e84:b0:8ab:37d8:9cb2 with SMTP id 00721157ae682-8b1667ca41emr4469087b3.0.1792796489658;
        Fri, 23 Oct 2026 16:01:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166e53e34sm2972847b3.29.2026.10.23.16.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 16:01:28 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] mm: add anonymous mTHP folios to the deferred split list
Date: Fri, 23 Oct 2026 16:00:06 -0700
Message-ID: <20261023230006.3759543-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261023230006.3759543-1-joannelkoong@gmail.com>
References: <20261023230006.3759543-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DA271C0018
X-Stat-Signature: wh36mky5fe94jg96htunad754jf38796
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792796490-475161
X-HE-Meta: U2FsdGVkX1+9wg9kuL9WA5+d7Ane5YFuoqlDG34DZWymTRtdPQUTOSAxO2I4I3maQlkI8lMj7SzPomv6EEHQR0S4vMNyfWrUrVCy5jIJQfksEDJzzd8S/JqFhF5B8svBG9hTqzYde5tYkEbAOFJI6OfMSCkDcExmzn92cDSjrOOz0WGXCeqF6MN4ZodmM3ZrdpcCUiWPS9eYv3kb9AAzdVc0skbf24A8xqosyKv0siYv/1e3V179KRdAqt7rB8VWzfNriJ+4PSP0oGs8dj0UucdlHYTOywM33oOGydrAVzSncKlnfsLQ90Y9XKCzRn5U9V5T/am3DbRCZD+uq0+yzeqb/G/JBMZjFsaJl8RXaZ1D6BF41OqKS92N4sFj4btMj9T8HcxAm+0rWiAW5UDUIo5aA0+op5HoH+7ihtfrG4bDwNTG2vrXoX2E5/BmjKfwB6l7OeQ3GH2EmXJFKylf31aU3ptwXVWnUKbhYXCJ+uQw+1mi06ouC9iHyXFAXRRPnH1mJASXUIXQA+EIK4xW1RcainL/Cr2XNLfaLUob0pDYtqE7oJXQjQ9B7RwA5Hlx63/ASzw4jCEFt8yTXjY97szKf8Fva2p6pzFTXQjj+a719F+BK84RNNjroh/yOhuN3hg4LY77UG3cYhHRrEO5U9lHy/rpJeJ91Er47OzidWXhCroae33f+1jazajYCT6tSmVR17sVAurMkqZlZoW+WZY1Mjf3kndAQtqexFmwwk35Yq9HR/Bg4ljgF3/8A2CgrdkvGADl/GT+S54b/9RoMzROfVQE4aoE9b5lYs/+RL56DD4Pi58KIDUAFO63oGtLM+BVAtzXzdHcDWkImbSgtXAtxMfwF2jnEjG9z0icbEGrzYjTudokQ4O0pXSMBLqj7qQ9HDL6ga4oHffFVSdbLPcE+k7K4LfLkQHWAspabi8kVfLdP9E4HhjjlYMZiSTQYuFhPPUGM2IR2LON7dd
 dgOkTbFk
 aHnXSbyZxwW67m4mhTAsTCGF9jnT6ILT2Sa6I2cIHrYvvFXvRFbFM0Z3mz6uD6vBaQv1IYVyjhkD4dgn6RugnjaevHPRnFEfBYaRzepHgwwv3yYp8jxcI/iTexJE3JfxJC3x16xgGQ67GQAfPnOjs1d88Y8FFGmKqUH8IXmoB1AYGs2+7cWXDk4DfZbbBZsptTyKLXaGUAvdNOdAMu2/L2XMgm2u/KPIlXaB1Crih+8FOQONlaMHbDGwQI2Dur+Yl8hrAga8l48nSB+QtUw3zQ6oOIYQOjLC3SrASxWvcq/N07WAd4KA02LHGfVlFP20xwhSRp2jCoeeGxmXLlNTaHgCcwi5otsDTEtVt9ba5mM+Wl3T6SrKIEZAmH9G4FaPTqKenJbkr6gDmnA4dnAawFLNTEFYV+jD4sUHEUQyzf94aGdGj84JUuNKJgXfNDAqmAil2EZ8U/Kpk6D3S0/IECxcDkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
to the deferred split list at fault or collapse time. As a result, a
fully mapped mTHP folio that is mostly zero-filled doesn't get split by
the deferred split shrinker when the system is under memory pressure.

At Meta we would like to deploy 2M THP=always on arm64 with 64k base
pages, as 2M gives the contpte benefits while the PMD size (512M) is too
big to use. Without underused splitting this causes memory regressions,
as the unused parts of those folios can never be broken down and
reclaimed.

Add anonymous mTHP folios to the deferred split list from
map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
already does for PMD-sized folios. This covers both the fault path and
the khugepaged mTHP collapse path. If there is memory pressure, a
zero-filled mTHP can then be split with its zero pages remapped to the
shared zero page and reclaimed.

Only queue mTHP folios of at least 2M for underused splitting. With
thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
folio of order 2 or above could in principle be underused, but for small
folios it is unlikely to be worth it. An order-2 folio on 4k base pages
can free at most four pages and on systems that only enable small mTHP
sizes (eg Android's order-2-only configuration) zero-filled subpages
tend to be few and short-lived.

The minimum is hard-coded rather than a knob, since admins have no good
way of choosing it, and is a size rather than an order since what a
split recovers depend on the folio's size in bytes, and the same order
means very different sizes across different base page sizes. It can be
lowered later if data shows smaller sizes are worth it. PMD-sized folios
are exempt from the minimum in order to maintain backwards compatibility
since on some architectures (s390, with a 1M PMD) the PMD size can be
below 2M.

To minimize overhead on the common order-0 fault path, the
deferred_split_folio() call is guarded by an inline folio_test_large()
check.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 14 ++++++++++++++
 mm/memory.c      |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f758cc1e34fb..cf69020e5a6c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4561,6 +4561,13 @@ static bool thp_underused_never(unsigned long max_ptes_none)
 	return max_ptes_none == HPAGE_PMD_NR - 1;
 }
 
+/*
+ * Smallest mTHP folio that is queued for underused splitting. Kept
+ * conservative, as small folios are unlikely to free enough memory to be
+ * worth queueing and scanning.
+ */
+#define THP_UNDERUSED_MIN_SIZE	SZ_2M
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4586,6 +4593,13 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		 */
 		if (thp_underused_never(khugepaged_max_ptes_none))
 			return;
+		/*
+		 * Keep queueing PMD-sized folios as before, even where the PMD
+		 * size is below the minimum (eg 1M on s390).
+		 */
+		if (folio_size(folio) < THP_UNDERUSED_MIN_SIZE &&
+		    !is_pmd_order(folio_order(folio)))
+			return;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 976cd03954e3..0622425649c6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5501,6 +5501,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
 	folio_add_lru_vma(folio, vma);
 	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
 	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
+	if (folio_test_large(folio))
+		deferred_split_folio(folio, false);
 }
 
 static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
-- 
2.52.0


