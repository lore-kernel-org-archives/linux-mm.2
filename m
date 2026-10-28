Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BE3606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F326B05B8; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFC36B05B9; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9613F6B05BB; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D776B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:17:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2481BA7069
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:31 +0000 (UTC)
X-FDA: 85372691502.18.2708F09
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 07CFD1C0013
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IadhxWfp;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zJ+CABCBU45JUBR07bzfuVV9dkmnMA2f9ZOSTtAqbg=;
	b=bdXVfnpLoyan3TRbgmcCV5osCzgRxv/Ng04z7ZSYNpJoIh+e6YL4m/An78EFsIQwyLjcw4
	qgaivx7WzoBH7W0mY5Uegt4EFVX/tRLcBCTVZicpFWO0nEims5C56Jy8N1ufD784239bGF
	o5vf2fJh9ITE5cYIjV2eqoMR+KKa4Zw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=IadhxWfp;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207849;
	b=QyuQejpvFH69ZHdTgEN+VDvmt7jZsHtN6aw/7oIyyayIODG0LZnogq3oMqPlcNkDTZ8i2q
	kIsGnZnrSTyv4XUw7Wzktj2syRmL3QTEfI0TwJiZ1T1Q1t99kcr9j+9DPfZbaKA2lRJqd3
	JVTtG+ez7D7FAaQz7QN0aOFsFrS5ndw=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-8ae8607e8afso9975867b3.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793207848; x=1793812648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8zJ+CABCBU45JUBR07bzfuVV9dkmnMA2f9ZOSTtAqbg=;
        b=IadhxWfpshovdNcIJ6T01SKSVTQw8TQ5KRbOPGpcO3+Sc2lYUfh48hGtD9ga6cqZOp
         EMZH9XqZZJ+1V7oJKG8c56X2HeZFAQHGCYu9DXB7CgynLKMPTw21EvJGxb23TLpqlcF/
         eBkbZ6p6eYKtwqQJESwQnrCqYUrW5opGagc6wkjlS1wakC6T04y1paStK0qYLT3hxT77
         xPaIdzfKnsHyz1AvsuhqXjmeEWHsX7ee5F8kOaXon6tBqmt753k7oc8bnrkl07fHgWG9
         To828YbDO5Y79pvqO3TvjemLZQ7Rjyve6/28jGirFCEn38LLnX4vGRpGZJNaLU0MCI9j
         CpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793207848; x=1793812648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8zJ+CABCBU45JUBR07bzfuVV9dkmnMA2f9ZOSTtAqbg=;
        b=gsXPvTVF0avJYrT7AF6DISMivUaDjY2p7SB7rKo7KzgixtK629owehF7EL110smP3v
         Eyvim1VRWLPdpcgX5CHbm5rlWMBw7B+ClAfBi0vn03WdGf8iUecAOpq0o2BOX1cZnNPm
         U1r/FRDiJ/xfkkOYMKRlh/jVyhneIgNYbv8H/x8GVXPNi5CjUlqiakUrTSkL3fKor52Q
         aNWIOQb/Ag3YLhBSzlBXrVBVbR09VsSMmIzdxQYA0J5tS49IyqH8BFA1K5bJyX/BYGk0
         aeGMT/cXtrLEFRcQcFs90z9+V0GDxfqad7iJk6qQN8PSObZowNWZeZsDQRSDOgpLbClt
         UbMA==
X-Forwarded-Encrypted: i=1; AKwUvByqwQaKEJ5/arR3Qf9QgrK60m/Ug6Q9uVyBi988zjXA4cjrSqX6nJxhq00BEsp6XGjeAfRbFbGswA==@kvack.org
X-Gm-Message-State: AFq9FYLuixpSo0If3B4l5BYRMo49+OvmudON1tisWxufanObXibUOIZn
	T59vxcTVl/ef0BW6/Mj2RSgFzlvnIoGt0uPIbjvTD8WFUF8gFPVBY1ChxEiNKbJX/Oo=
X-Gm-Gg: AYBFou31AIs9fG5Go1Yz5LSNksO0jAeg+7EWSQ8A69a0UeDAsaj1+1m408X1ExU2g3n
	qRbrpFp8GSbayMnOifJ0dHn7j2V2OlHD2cmDtc2Jy4IcYHqTgxqXGN8F+hst25m8GOA3Ens6SMb
	+ch3lnJ1yCxGVjrDkOBkJ6SWZ/shcQ4XbxX/mDvAI/+7rsovCYURNc5s97r8hEZTm/BSszki9FA
	7BdWsMh+tiL4L5KEYXQtkafF0zC7BOpC7jxKn9YqHqrKN3Wrf/ZEU1vlqy2L30+VvDHhJzbymrP
	76c6qQKup5sINERUZ11qlcap52fUXNswKiviCWTSOIcvLiHHFH07wvqP8aqtifZd54uYyQE+jG1
	PvotE67iV4K3z3mwXcdUrkaC4spQzl3AzXUqLPtsFGsTTWvsyKRWe9PhVjzJLiZdnBY8CVyzV8N
	lOtbczTFqxgk3FpIeminQhuaUWsgYxLYUlzJCsGCmh1qWR0nXCC5vl9wQzOnHd0fF62HA6QufNn
	1xgoDu0Ltf9tLbqZkaHIiqMZt8oLnTGv4JS78NCk/YVEjhJ80KZWlfTiNaZURceUXfQW8X9rHdV
	kIHYZGt6QgSNqE8n/MKmOpUuzNJa
X-Received: by 2002:a53:c30f:0:b0:677:ad01:32b0 with SMTP id 956f58d0204a3-67a7bce93abmr1470801d50.36.1793207847839;
        Wed, 28 Oct 2026 10:17:27 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a0c31f1sm2058926d50.11.2026.10.28.10.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:17:27 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dgc@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests reserve access
Date: Wed, 28 Oct 2026 13:15:53 -0400
Message-ID: <20261028171719.2043421-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028171719.2043421-1-hannes@cmpxchg.org>
References: <20261028171719.2043421-1-hannes@cmpxchg.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07CFD1C0013
X-Stat-Signature: yumkp8txbxfydzhzh498q4tz1rnftxnf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793207848-19024
X-HE-Meta: U2FsdGVkX1/mKj38Qb3hqP0EEIHI+O/vWTHHtAVTmv9OLYu0FHzqFcXG/aWIsJxuqFXV8SmP+9+Wkr/P2GPK1IiaMNKPk2zOrx5Cu/Qju04llu89vJdzpoTP0IA7WMsNn7CqEOwpXFiB5Y9CApGymFi+hfWOGO6TCpNH/tOU8ggcn8XJzMx9oUijZYEglzBVA4LPhGndudSHfYQgOj8Iii4sApzvF+EI1xOeJgqSLWMTOEMAoBbvYQxrmjkKcfTBOAulpcjTHX7y9b0/IV+FUnTGgfJ6V960wtDYqVSK84PKUIR6has9RIXz6XpJeavWnnCnPEVuVoTEAT0mZc8QcjppZ8TMC9kNtk05U7nrdbxycn3Mrpsru0NwUCTimvDPH0BqKzrbgEX9vLCY2cN56/E01DqvAy7Vs7UE3Ln/DkNoPS47jpyaPsxRUFcBX1NYjHzAXJZMxK1T8fMIMYLhvDO2lteYlFKMxhsr4/f2DkLWMvDsjWrVCeSgOre30UhWOwTqirm8OANv0pr6HO46agEpfVfa90ZmVQ5+bv+9uv3CRnq+mnXHOIfrM9rLW1orr8lxc+5YDjzsXLZOkNAB3rGx3covivbSdNsB1DOdY6hWW7ZG5tNGFY7cdF+R62i10IMe6kKJIMuvu/rbaLGqz45BR5iDjeBIvOf7xQ718jFWarL819B9bmYW0ugKzgR31VNTxKDvvRkzvaz3EZUe5MZ1CPZ9krbeBgzWiWVT7Ia+hwU1xg3O5CUExn5PLqST18xfQuslkoazYyJll9MA+mHQ1h9KxOYVlIg2Z8z5KI4qZrnevcbZmiyw1K1/Yy+r9lDGHDUug7sVdcQ/LFHi7sKyALq7+Zc/S2LwkGhnr9HRVQ2iiAl/YR7/Mtff3njfCIiejFs0HxkNP0grLM2bP7FW+1WfnGT1lrAN9IFJxD+WjxL+rK5Tez7lEfoIPU0hU7WOSL61VrDdPPAE2Yc
 t6LQ/ajw
 EmMi7TomEw3NeXo2h15Hi0yF0xUEQZffv2FbfFDaJnXu7cnNvjGSL211/t6PnxlB6z9SV/Y7DRtthk9cYH515KkNKgU+rH35yVNAZT7GugsujPt4/fv5c6C14/LFgp6sl99t4APLzn427w7bAXfKsjEar3ZwOctHChdG4X6YCyyXpgF8ni/1er9ybuO+j4JrOFOU4pV78XoXSNDxDt3v6w2WVoS2AntV/SyOlNREP3Ewzven294TMEVSlmmLJ69kHx20j8iuRq8qM/HoN4+oZZwG9rWdbQoR7cSCEKTTQFzxP6DkaV9y5+wwFe3/hXkgvTqrp2h2S9S5pkwP1eoH9pqXJvwsKsSLGhpKcGtHwemA3IbzvSaaoxphISdECYnjpbkZOs+8Vi6gvYmvnwpeZg6dhqAhd2nv1w+a4kzPExZj6w6onCI8PZItlOWKbP3u4oHBPSrVALnYWBpcfDA6qzuWivNT3We890CIwKSdBEIWFpLAlHR6xBivQjKoqoL+gGwQYJ1BR4NcXBD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access
highatomic reserves") accidentally gave all non-blocking allocation
requests access to highatomic reserves, which includes GFP_NOWAIT and
other sites clearing __GFP_DIRECT_RECLAIM.

While this improved atomic request success rate, it's unintentionally
broad and can actually worsen highatomic requests by squandering the
reserves on requests that don't need it.

There are concurrent efforts to clear __GFP_DIRECT_RECLAIM altogether
for costly order __GFP_NORETRY requests, which would then also fall
into this exemption and deplete reserves even faster.

What GFP_ATOMIC has over the others is __GFP_HIGH, which
alloc_flags_slowpath() translates to ALLOC_MIN_RESERVE.

Narrow the exemption to contexts that have both ALLOC_NON_BLOCK |
ALLOC_MIN_RESERVE.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
Fixes: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 4 +++-
 mm/page_alloc.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8cac5e01066..8ac2e2bf14fc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3238,7 +3238,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page &&
+			    ((alloc_flags & ALLOC_OOM) ||
+			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index e238ee91ed24..9c3c2830acb0 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -60,6 +60,9 @@
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flags that mean GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*
-- 
2.56.0


