Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED0360A2607
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bgp39Pjj
Received: by kanga.kvack.org (Postfix)
	id 273436B0625; Wed, 18 Nov 2026 18:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C626B062B; Wed, 18 Nov 2026 18:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13ACB6B062C; Wed, 18 Nov 2026 18:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C41676B0625
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:05:45 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EABC81A08FA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:05:43 +0000 (UTC)
X-FDA: 85449773766.24.A8F3E01
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 26C31180011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:05:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bgp39Pjj;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795043142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CClaM17d8fZmvymfnrpm1hCIobp2fJDyOViMllLO/qU=;
	b=Sjrz00292kVXSxWsOup8spQP0TkoaSzMglJLys3xPgBx04kNE7XmHjxt0543mCsrkIxXE4
	2npvBCUBS98kOcu2XUg/nq1YVPWT29zjT/LDGGp34B0FF/kmaGbM+nfDEToe8I9KJGJvqZ
	MHhdhPjhf94/RYJ8gXbw7UZoQi01bpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795043142;
	b=rUXWMWrqvHXHIQWdN42MZikCzzNVf4AcUjLIUhdOMVavstu5owW3tocoi9UZ8t2BAkLdgX
	ekCZMhq/zfDHnK9G++XFSeEsd+PnjP6VjONTU/Xd5GiOsS/tHUbHh7gkLojsbfelj0Hfju
	K631T/ZMu4fjX8C0tp4zL/Sl+hh6psc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bgp39Pjj;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-71af0656bedso1052411eaf.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795043141; x=1795647941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CClaM17d8fZmvymfnrpm1hCIobp2fJDyOViMllLO/qU=;
        b=bgp39PjjWGOOxAqtuRPimKaap5PkMLyGi5iyjtAk8Rx9feZBRlL7s7Ft6OtApupjM5
         X/IlrwREVKNH7pL1QCmKekWIBIHJhI+BO3pE4vLWUZ5cNDEzDxTgkril0DXXJJjXCWGj
         fr8/2OmYSkA4sMd0GUzSp812AwibrUpJMafWMndlJ1WYfoiYW7KMSvcGvKQbVdhIkSKy
         KDNrx37X3qmrPwYpIBaNYjfeN5WqVRiTia9EbDEHPDHEWNvH/gy033FVbHDiZ6jcMqU0
         59v4z2CQPJu0aJtw1HAh87gjhOf2lgYh7owqg83blUZMtjMb6m7gZt885bvtqs4+mo/Z
         y68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795043141; x=1795647941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CClaM17d8fZmvymfnrpm1hCIobp2fJDyOViMllLO/qU=;
        b=IFXR324gdZDmTNV18XWxBwV7naxOwcgY6Kico2uOKeR2N5fhijLzE3cVgkL+d7VwFv
         rRzLR19gmgdLQtaue5cexq+138XEgXcTHJFhpx6WCNe4vh9lR06k4jh2zkrmYcM+qO0B
         vNYiF4YNl6XIjf51sRuaFgTfzFlU8oJRYiBf0B1m5mISAmZbDAIpFKR6qGS2QKXdkk3q
         O7EG1FEyGgOSYDZu/DxuVwgcB7W2voMeumXIqPlJwN9dQUZ7cTD5sYTzkkV62hyAlPy/
         oh4glAi5BO/P/X6YOJ0/LkoAojamkrNLIy9LkAIebZzmz8x51SiNa+KtOZsGIiYtRP3x
         vfiw==
X-Forwarded-Encrypted: i=1; AL+hErHL2Y+aW5zJ1h5IhbeE9Y1j57GiAe2b7rcc6Wls9SjV4Xmx8JG6VUAM9FQqqtUPmQ7Zuw9dfKv8Lw==@kvack.org
X-Gm-Message-State: APuU4Z+AH8uXta+IEdETdZHSf9ncoL77pGv/LdeQqprtgE5/I1tb4nbu
	pr6/+O19YvMlunwvWVhZ/2qM2EpufzyEZkqmHR086OplWPP/ynV9eyuAr5X3Ww==
X-Gm-Gg: AYBFou2fZhwGg6FCE5CP57DkdZAGSnKKM+kvhNl+fpNK8RZf44NIdtLoIlfPooTwXT/
	BjIQH8dRk9pe6Dh61ElPXc6sG555OqTKzGVrwNdDbmvm2GEtjs1UXajJExAxXR/OMb3KWKSmk72
	PeIZtAm/vDs5dD+rdF7k9UYihVvfXhQmLibpsXEf0wzNgbLAZuyjhKbZXnYgOTOKV0lJ6deB2Y6
	8GZ1MHClGcJh3jvoAGk7HvwR+OXCIjUBT89jsT1sDlK9HPVG6OeIQt5axpAyl/pz1vkuqPdtnti
	a2sdP83yMMMaik6OXPTQ22OiaFumXQjZZ9xRuFiW/nZ99MhgTJTIQHiqYHHL6WnRHKai4GvGJcJ
	PbEd/QM9aTUV2AYvF8wIAXj4WYNxPGgqAjBB164bDWKxZKAvZ3ZIXDiDUXEP2EvDxzPtBdQ2OcQ
	cedp9dKLwTbmcEKQaD8Pp2b2e1tqC5PBrWPkbmDyeBH6uQCI4dOmX5C2IT8kEGanhHUZd/EKTLf
	fNRlns1EGn7uAEhKqXGq7V9qORtz0PlkUqim9Ed5+9PI1dhDbAZIQSFzc5RJgtxhNNefwECOj+O
	cbCoMlDsHG8q+UEdCquzLn0+BsACfQi/xlG+bYCmQz2xLxZrp4HEd++xVW8e7g==
X-Received: by 2002:a05:6820:a510:20b0:71a:eb23:a7d1 with SMTP id 006d021491bc7-71b1864ee8dmr2434637eaf.53.1795043141166;
        Wed, 18 Nov 2026 15:05:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b744126dfdsm3565223fac.10.2026.11.18.15.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 15:05:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3 1/2] mm/page_alloc: move the kswapd node skip check into a helper
Date: Wed, 18 Nov 2026 15:05:34 -0800
Message-ID: <20261118230539.3789231-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
References: <20261118230539.3789231-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jxab7m37hebfp5fthaj67mfgk5ewda31
X-Rspam-User: 
X-Rspamd-Queue-Id: 26C31180011
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795043141-701986
X-HE-Meta: U2FsdGVkX18dfUCpNh4syMd1ka4ZXCm9lV/GbJx73LBxEVT0uVjurrDtR8r9oQuFJHcu5xmVo2l1GIiJPE8JtaPdaJM+rBupBH/k5YxuuT09hua5VXOl1WQBHA7sVzDPlgs/uwqI7zDqe93EaMFiEv12hUrdAiJ7LZ9BfVr4mYP12p+eMhigf7NVsjIIfDC8YK2zObC0l15DVIGqO6Ux4ASrh35k1YfiEfxXnt9bQ9udz731auuu0wjnChEexWlnuFYn2tWIDpbnLOsFxNcQk5UeQTHUncqJqvbtcN0fUvlRoGkN57CAxldfYfBfQRUAPuLxNQQD88BLbmzO4FiKDY8tL+xfpXv68rLODEzRGGhunjMoN/fwLFbGqxMkI6KyMQCrXWrGfp4aAI6ED1gvFUr7rfHVZ9YQwPw68Jm+Z8+qePqD4Ggtxcv3AKQ7+K/9G9amGTH0wTr1wMRjKYBtXivjE2R1GviokZDH/pz5j5luJoW5Gv7Szt7FyXlbfdAZEkE/R5G/7fyvkwAQaReqdL68M/bthc1zaFD/NdZ3t4sdvPwNTKFauoqQBx2GYWEf/jOwKa+9pVpmm7BVsmZDltcSnoEQ1q/STkguO0bH5/KtHOnwkOsQ6sQ63burzzCmfGGEikJVWWpMf24xLvStzkF1unyjTWLWhB7S0bIHlYeP+F7GdDzEMbcQ30La6ANQX/tacE5U1B/9BjCmciAqV2Xl3ouHknhpfPLLE+d0oWG83Pu1CZQWN/1NIcM4vVouGuoSLeySDFloiVXlFnhPP80j7CH/9tclNwDfWtL8MTY6t3zSh0wV14GhuKeD/e0gfKjSgIcCabYPKultrxfrOsjetxS2XhI8PZS4FC5mI7E7ZzPjW9z9wUf4Jyb2UYPeU+QkMwJjPu6JqTF16l7PftWJNWw1H+W4CPTt+7e9HlUWuSe/B+0V+9i7P5WLupuVEgnqQV2xHBGqFlGxoK/
 KlEONtlU
 C70DJc+2C2u+lpC56HnQhlOSHfdu1Dy4Jfm1tGWkpLJQmObzjhlyiaaqQvSR/+QN58GKaGVsGOb9Ao5eOBalw9OhyzNxndsC6U6puFowjiGSlm/dTQ3VdgEfJC1SL6U3BT+41zgX3C5oMsWux2Rm+PE4HaZrqx+7gFRSjGOZ07u+MFKcXFgWS8DFqgtc8h0YMmyxvzXgO65HrSXlJ4fxkLqiFAALCOYWc9buxTNcI/ye+8xsMKXPWZokh8/BnFMRd6DYByr0Km2jc6jfcl5tLPWOrr4vsXazQCL283QZhOks0TX5KodlXxcMtHNP0qc0k2EcDzSRvVJuN5/icy5e/C9MrWo8pfzVHkg3Bc8Cq1aKbyLI6WBAk8Dx6Ipvl3fp3E7tyRhqz9Cx6i0Lb5yttXmbSMeReRumV6rVBAXTAAIZFlrxE/3z+La11hpyYNoaL7WEZ7USR6jcKpv7A7hj9D86VKufQsnEA8fX8sTjEbQXTFzPWQ3VJBD0xp6Bofgj4VPu98roMoh3xeF7SXsNrQDCvSg8HzDVLG72Tp1qdMgMy67BdPQ0YsHAWXUGTsTjv5UMdiGoFaUgitzhOxsih4gJlgNnfKV/Z8D3HIr8Vb23pzETrqFzARKwreJ/2P0UiqTywvtDeZ6wgs442WudX55WHGk5dWlanB/1ecLCTn1vn7bIor/Y8OiNRbP6gTnr4fabNltgWnSh+a+42DcQggbqh1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_page_from_freelist() checks many conditions for each zone, often
with a big comment block explaining the conditions.

Move the kswapd check and its comment into should_skip_kswapd_zone() to
make the zone iteration cleaner to read.

While moving this, also resolve a checkpatch warning which complains of
a waitqueue_active() call with no corresponding comment explaining why
the lockless use is OK in this case.

No functional change intended.

Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e1261521b6a3..e7a7863e381ab 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3785,6 +3785,34 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 	return ALLOC_DEFAULT;
 }
 
+/*
+ * If kswapd is already active on a node and the zone is below its kswapd
+ * watermark for this request, keep looking for other nodes that might be idle.
+ * This can happen if another process has NUMA bindings and is causing kswapd
+ * wakeups on only some nodes. Avoid accidental "node_reclaim_mode"-like
+ * behavior in this case.
+ */
+static inline bool
+should_skip_kswapd_zone(struct zone *zone, unsigned int order,
+			const struct alloc_context *ac, gfp_t gfp_mask)
+{
+	unsigned long mark;
+
+	/*
+	 * This means kswapd is asleep, so don't skip the zone. This is a
+	 * lockless check, since a stale result only affects zone selection.
+	 */
+	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
+		return false;
+
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		mark = promo_wmark_pages(zone);
+	else
+		mark = high_wmark_pages(zone);
+	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx,
+				    0, gfp_mask);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3796,9 +3824,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
-	enum zone_watermarks kswapd_watermark =
-		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-		WMARK_PROMO : WMARK_HIGH;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
@@ -3865,22 +3890,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			}
 		}
 
-		/*
-		 * If kswapd is already active on a node and the zone is below
-		 * its kswapd watermark for this request, keep looking for
-		 * other nodes that might be idle. This can happen if another
-		 * process has NUMA bindings and is causing kswapd wakeups on
-		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
-		 * behavior in this case.
-		 */
 		if (skip_kswapd_nodes &&
-		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
-			mark = wmark_pages(zone, kswapd_watermark);
-			if (!zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, 0, gfp_mask)) {
-				skipped_kswapd_nodes = true;
-				continue;
-			}
+		    should_skip_kswapd_zone(zone, order, ac, gfp_mask)) {
+			skipped_kswapd_nodes = true;
+			continue;
 		}
 
 		cond_accept_memory(zone, order, alloc_flags);
-- 
2.53.1-Meta


