Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8284C606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oD3TX5d4
Received: by kanga.kvack.org (Postfix)
	id 8947B6B031B; Thu, 22 Oct 2026 22:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B7A6B031C; Thu, 22 Oct 2026 22:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782566B031D; Thu, 22 Oct 2026 22:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0C06B031B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:32:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA5EEA01F6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:32:42 +0000 (UTC)
X-FDA: 85352317764.17.53D665A
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9DF5020008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:32:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oD3TX5d4;
	spf=pass (imf31.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792722761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OiktTo8xSBry4ZhOvp6SkAXw484O9QanmGqTKsmqRQU=;
	b=VAWoGf3lZeD4iy7NZBxCrJZ+5pDtCn8mK2hUcqPiHjdy6e59aKnP9noNJoREqE8XeYbYij
	U2udXNNn3eT/Z/LDwTbv34/xgjcHiPfAWcSAnsDMZScRAB62fKTLzgWAxw5qC4Gs2jYl8g
	4Wm86HJW2bdMi7QlKou3L+m3nCN6yR0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792722761;
	b=oPC8mxywIFlLxwgQJYAgIMZb7HKs9ssUOJt29B8W2fCWdjd95H0ds9mIAP/ofGlSkB8kNW
	Thksis8FyqHaBzrbegjGU9jOPXZhin6gEpNdBHCWZrot9oJV9kLZWA0Jn0WssjzMf2nuT0
	yBbXSMIkMQ6brF4Fkg3q7ML2NY9aa3Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oD3TX5d4;
	spf=pass (imf31.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a06b27bf9bso257959b3a.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792722760; x=1793327560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OiktTo8xSBry4ZhOvp6SkAXw484O9QanmGqTKsmqRQU=;
        b=oD3TX5d4Bh/Ck4rouhNOYsGSOga3PaN04L22gk8wbRdnDPoeipa67LYjvsr+wAl0Os
         LYnHUD8eNjvvI5ZVgdCSupuhR9hGhcrxpOP3FQtdGzWVlhzUqHO4oDL4lOf+xgttAPnu
         /qVw0P5ttVjjsMj3WkR2njutpR06ViOk56lDgBP6218RCypQ9D6VVrdgWai1AF18ceMB
         BmfMAmdtzE4FFNshfh+qJt0ev02bgC1NZKTHrcGMkbzKOBJQMsFlqH+lG14HNH2KXzQA
         GgMez/rXlBCTxr9Cq9QxB17qRxoeXuI4M3zHBU8QgbD7QR6gPILZOrblAOIUojlP8OWZ
         v5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792722760; x=1793327560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OiktTo8xSBry4ZhOvp6SkAXw484O9QanmGqTKsmqRQU=;
        b=vkSZZIGS08N1TL6fDUu4uuPwKAmB+gVe7eNQgLaPGMzvktYO/wDL0t3uiDYhlqkZKM
         MKW/UGI0A28Z5BLms4qmnclYR8r9jrk4NVtdHhAU3/ewyicNECKDB2ySqxDw0AqsyTks
         FVQEzDKyaJsPIOARajY18x4XUHStjdxMPxfdWPOLjSwuBKgSkL9NyQQJkKg0cy2YGMe2
         oL0ozW6DTYY041fGIABUP+9/JXdMxdC1EIoVF77EibtxthlcY1K2LkqMzqvpIKsll37v
         KVrKbxXbdduBrHr3/xX61CsBXnms3hKEAPKg2U9lJvE4ANFvyh+vPEbGMl8Qj7GRX8/x
         8PtQ==
X-Gm-Message-State: AFq9FYIdKeUv+h07Dzyp8ravm3uX7LEAZjOpbCf2M7aI0lLCOC38LaGZ
	DOigATAMfbF2MMwDFaWhNavoH6rtVTwZBtcN8WrmDn0qZzkaDL6N2mU4
X-Gm-Gg: AYBFou1fjCgVrcQyjo9HV+OyxAYkcXcNIaV01bUo0mr+TndOcKilHAzhpPQG9GHeVnU
	FwtQJYm2v8wXKzGYvP4ohIUjS6KnyqhJypQkYGjvF8OIaViMR8dxtcngDig7+bFeoPwSDtLY8Ck
	DaUtLdkAEPbigJYm4T7FlyL/BnYnaFdImlu3qGugxCdkFem/DDsRkY40k+jsiFRGLI+PoC4yi93
	RZ5nI7NgYbPmPX0ztdBmGhkB6UO0v78aaz/ePe71vwQEi8M0a0z4B1C1bXz5Jw5bJBqnjpHUGH8
	P9sWgWPgR5gmGTNAIzZ9woR3FqzfccKTMkYpNsljZpCkNjgEIg5Bw3h3szybxJDVlReqvJrN/qr
	+5H7sgy289amXI7evzE4OKWFjDYxYIjATFxoSwXSXz9IShREFZWu0EUzBupTyClMMLtAYGdk08v
	rEqDIG5MdzgKlT5IE1VqXpwmNW6phI1ETckd7pL0rx0msTfNnjpFXN3qo5o5wx6ZYzmyYP6BlrT
	/Dmuc/iGwaN5m+hvdyfSX2IrDx36gGiOEmWcLBFif02jyy9C3l8O7MOxqo8xUIwp1baSrA0dbpS
	5eP7zCWJL5r2vK8YBQasu2QnwKL+SavRcPKy+n2b
X-Received: by 2002:a05:6a21:4cc1:b0:3e1:558d:e37a with SMTP id adf61e73a8af0-3e369203bdemr680101637.26.1792722760003;
        Thu, 22 Oct 2026 19:32:40 -0700 (PDT)
Received: from localhost.localdomain ([101.82.104.98])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba7d5f96sm299609a12.4.2026.10.22.19.32.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 19:32:39 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Cc: linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>,
	"Huang, Ying" <ying.huang@intel.com>
Subject: [PATCH] mm/migrate: snapshot the source nid before the misplaced migration
Date: Fri, 23 Oct 2026 10:32:26 +0800
Message-ID: <20261023023226.29783-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DF5020008
X-Stat-Signature: pcsf5k4feja51a64r549ih9h9kh36815
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792722761-898561
X-HE-Meta: U2FsdGVkX181XAhlQwY9QJPV0LtGNz8HDO/O6dHHgVglN3vqiPEXsaxZy2QRTJyV5vNg23Odcs8jQHMN2a+ec7MJVgLV5+VJpZwYvP4ybs9jejSYmfRGcvS+5kvNyEQFndKDxmMy6vaR1MchvENFxaa24JoxgOorjSm5hgdlPgskrtzGiHE2N19+sD5he84C3CXhOe3cR5PHKppOS0kg8EpptMwpyJFY8TZFQ+1e3zYXZgLPsOEfwJZLhyvTqg+NkBhDAKMwGv87tOgNk+QX3jzfYtfhzhZTibKPLONOFaAMMaLD/6RFCCKQTIEu/XazL7fzUbgrE6+qY7jIIJDRgQNskazNVx4Zex0mqryNxQ7rAvDqyBPGsnMG6EbueC3zz6mkmfm7lqKQspOnzUuHc0B376+tVg0q4z2zyd/b3HfnWYt2JbxUMbK2Aeyt74aCd+jQP/w16SMl/Syy5sP8md1RkwbfhXRCRBujzI4/UF9SUL0n3/YxvxCpRqW3oy4R3VwzsYZ9tU8RWsg1OZN0koqdyo5As7MpN9KKPQudwCuepL3+MuBX2/AMOClzjRlbJm0QZhKA20SOh3hy8Ko5KRnX617VCpGTs5WeswJcOzrlFIA72u7GQXlGX7jVkV+LpmmC17s8arlFPRoVOjNSXxw/O1g1866Os/Ct6gPGdo41Blg5bxnarFlcsYsrAwAC2oTW/RjjnsTMOcwREmouH6vXU7ZkC7VNOr2EWd7UBxstXGdfuMXWGoSf5y6U/4QAeffl2VBqHBErEQxxM8wjlt/V8sjkvWIGNe76hXI6bZoeKqF36GgiyNJ6RUYjySXJIckinES8q/IoOn/+Fc7sQyMo0ZTYd77FRg8Lci9FgqHilbKLanMmjzPZlZv6D2Sdz7xQyPdvIPUuj9a5H6gRCOURTi7jHKmu31kQTddfNIP9d+CmePlj2D1TIwDuDlpnAfL6eb01AmMGgjofIT6
 Jd1lgaYs
 xI1FApQd3EvghzIcmUrX2DSc1durXqJtxHgd+FSrNHtcy9GcmplJXKAfM6sZzVNvKdmKSeg3wMKW4QbGgwkQUkIHBbZFhFekiOSjptl0m/aNRPHZqw4M0R1kSbLLml4VPrKp5fatbr6b8UpWjVv1SlL6QzkgYJrrQeEYLN6yRyv1CYuJ34pbfh0cElJPuoP0BIVWYGlQDEfL4sXKCPJFGuioGcHVPF3EtqmsMfWgCdXYtLExwoE53gUIAMKTqsdLXuYzURHwlHW1SaJJmp0rlB75A+cKQaiPWhM7zcjzW1a2AXCjt43u4pCuIxbhw2aLDY+di2FC5Nm+jh49sNrMVTdVxklvnkixFvJQcGjECMoxEztjuTsaz3/3fOAzzrn1TYUJrae+AlUKy6x0D6pGThAdN04M2hb4qbo/f3IWw34ExwDTCrF+zhXtLOeHiycG8y5pM968ZqfFUD8ZBL0gU/z6rd/z1D1e/yS6gzOSaj2k+eSDwex5jvVh90ZBXULPyYWBERGRC8dfia1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A successful migration frees the source folio, so the folio_nid() read
in the promotion counter update can pick up a reallocated page's nid.
Snapshot the nid before the migration, next to the memcg snapshot the
function already takes.

Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
---
 mm/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

This was found while implementing the BPF-NUMAB series. No real issues occurred.

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..91ba064e1bf4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2757,6 +2757,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
 	unsigned int nr_succeeded;
+	int src_node = folio_nid(folio);
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -2771,7 +2772,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		    && !node_is_toptier(folio_nid(folio))
+		    && !node_is_toptier(src_node)
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
 	}
-- 
2.52.0


