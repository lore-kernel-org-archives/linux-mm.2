Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CDBEFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1AB6B008A; Sat, 25 Apr 2026 01:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99536B008C; Sat, 25 Apr 2026 01:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5B26B0092; Sat, 25 Apr 2026 01:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BABFA6B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:34:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45E601A0279
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:34:47 +0000 (UTC)
X-FDA: 84695963814.17.B227D67
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5493B20003
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:34:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LPLgtwEH;
	spf=pass (imf03.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777095285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O2wKaLfeccrLPK9TR/V0xj0n49MCRpo9cMDPX1EG854=;
	b=SrQ5e6ZGuNmKPSuEkrDSvMk6p41SIkXM/d6Zr3xFNzH4LnTTQH4zJi+ypoQGPF2GP6Y3H0
	xC2Zx6vx+3vIbNmGOlcqI2eTpFs5Mk4LwZx4HTupC+BG8DDV1mu57RldQCLI5O6tY/Q5CB
	tvZwPxnyOewnpTLD2gOtgGi54J9C7Us=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LPLgtwEH;
	spf=pass (imf03.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777095285; a=rsa-sha256;
	cv=none;
	b=qbBhHuvPBjG7q/B4QyxIx+if0kJ1O+vxXTfKWEO4Xd1Foj08zvrTCt8uZwduEMyppavxQy
	gIEIEgLCa0aBPokvbzHxuy/K4mhUqQUsfUqWTvd+57ZXwhk9J8QvDC2RZXbqoFVlFcSPCp
	jhNOC/yYmEdI7I52cIluRO/NbjRYGQo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777095282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O2wKaLfeccrLPK9TR/V0xj0n49MCRpo9cMDPX1EG854=;
	b=LPLgtwEHTOentynaddiLXYxSON7SMFqntHAFikcN7Vqdqn2HG7t5Ts2ILIacZ7fO/o3oz9
	YyTiiUBTacaacPL6Xd5u8Ss8euxJvWRxA13+UJ++Fwu/SoalBEiTvf1SieXmXmdK3aIZhy
	pscxUbgSzsopGUj+tLs2KtG6AB+Vf88=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	willy@infradead.org,
	baohua@kernel.org,
	mhocko@suse.com,
	vbabka@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/lruvec: preemptively free dead folios during lru_add drain
Date: Fri, 24 Apr 2026 22:34:17 -0700
Message-ID: <20260425053417.351146-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7gw1aofnmcmijtbko9nanqu11p5c1ysw
X-Rspamd-Queue-Id: 5493B20003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777095285-432458
X-HE-Meta: U2FsdGVkX19xeqH+j+MP5RZM+8kQwT854m/+nNHqMk2HOFE1dUJOT59JYESBESUKndz9WkYAoBhHAYKN8pTtFQE7by7Q6Q6356YMxucLyCFoBmDmHCvESatH42XmpjBpGsKN1x4w6bEKfp0JSaEU/Zmqvf+3mQZ5A/WJANiDUGIsM4TjX8iaKi8+Trcy36UZkRKllJUV4fsJtLU5RMqtebY4cZXcIdMJ4rMmL8rPo0S6Dp0Zyq0NTUO0+I6UxqbB6b9WHsQpkcd2P/RkELBj82h+xZHgpSOoM3O+1fsdslWifmZQNcpws5JCjAFhG/PzWV+RoUcPQAt6ko+X4prVk3bCVifGIrSTBMxVO1/oQlVp7yg+tQWqsCq/EiBAvNkqbTCDAMJW4omo7iVmmBvv1imjxny4vplDQbRCaR4J5eIN1cjwXeG6PBn9XC9/+g6KCkdf6wfpNaaJLYmRb7kwo+JkmgR99VRpcyCA0ieeh0gL+a2qZANUl0m3TCqC86S0hGEYvEAYARymePl06ob03OJm9VFlkQI+cDBSAS+/GYqZ/3dwDSeAQvCrfneCTev5FjlwJ0JUTskn6KG3neW10EzO4UrXeCKww7gzhHamsiGVKG0XrWZqS4nbeUopeDqnRavMrIq4nPxXh1apR9KvnY1zbN2laVtpVs+OTuCyG1sMb71ghlQ19T2B/7i1BLB6rnUNAJ/+8Wrs/pfVx7mYFniXXpu/EEz0n9tq3ngTCRIzfRucbq+B2HWeIugdPs43h5LSKF9AXKVO9uGr7qtbGIyhVCiUy9/2vj0jfBobJODA65UqrIB5RrDLAl2PKWilokH++wYSGnBXJGfj+E4haTHIRkxwfRpwX/Oh5w3fQnvDqD3R928rE4xrIdP7EMvwaAsKemSoXSTaCrsJhpoWz29VpyYwmknpx8BRunBcVX72ia4HyvOLJmmtFMiKgJQIrCwkJm2W1WL1KqYicQK
 rsogaDQo
 dhVqjDReFsylvTOUjPTrUvXG5BWrD3UynyIaL6M6XDQBS6KpuDNlb+sf08URVdpu7fUO5ULcyfKp0o+SQ718YgPDwY7kqZmPqjOAnuXw0qPxADyKUwqyJmEaIluvtB43MazjT/Wwb56bKs3ktN7fGWgFsL7VetClytJg3GSlPNsYU19+/iBwrlyBGA9yE89NqoR3AURISem6mJ/dEWeNr9WA6fzZrhO0inKsL5WTWyFcc4WOsRTQWhPmSn0d7hUnbZpUADYvIgHXaCNz/WIwH2ixNjcGTu+8LbWK2gpruUHVjdaK5CQ9rL+/VuPhMG6PwUmNUAI/pjWOWPVgZFj4LA+54Uy1pXMjzIo0C6YLWxk8VR5xLAjwQ9IawPUO/8r4lj3+uQkpH41od4FE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Of all observable lruvec lock contention in our fleet, we find that ~24%
occurs when dead folios are present in lru_add batches at drain time. This
is wasteful in the sense that the folio is added to the LRU just to be
immediately removed via folios_put_refs(), incurring two unnecessary lock
acquisitions.

Eliminate this overhead by preemptively cleaning up dead folios before they
make it into the LRU. Use folio_ref_freeze() to filter folios whose only
remaining refcount is the batch ref. When dead folios are found, move them
off the add batch and onto a temporary batch to be freed.

PG_active may be set on a batched folio as well as PG_unevictable (via
migration path). Since filtered folios bypass the normal lru_add() cleanup,
both flags must be cleared before freeing.

During A/B testing on one of our prod instagram workloads (high-frequency
short-lived requests), the patch intercepted almost all dead folios before
they entered the LRU. Data collected using the mm_lru_insertion tracepoint
shows the effectiveness of the patch:

Per-host LRU add averages at 95% CPU load
(60 hosts each side, 3 x 60s intervals)

            dead folios/min  total folios/min   dead %
unpatched:        1,297,785        19,341,986  6.7097%
patched:                 14        19,039,996  0.0001%

Within this workload, we save ~2.6M lock acquisitions per minute per host
as a result.

System-wide memory stats improved on the patched side also at 95% CPU load:
 - direct reclaim scanning reduced 7%
 - allocation stalls reduced 5.2%
 - compaction stalls reduced 12.3%
 - page frees reduced 4.9%

No regressions were observed in requests served per second or request tail
latency (p99). Both metrics showed directional improvement at higher CPU
utilization (comparing 85% to 95%).

Note that tests were performed using classic LRU.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
v2
 - clear PG_active and PG_unevictable flags before adding to free batch

v1: https://lore.kernel.org/linux-mm/20260423164307.29805-1-jp.kobryn@linux.dev/

 mm/swap.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de9877..2dd84813f4dde 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -160,14 +160,42 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	int i;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
+	struct folio_batch free_fbatch;
+	bool is_lru_add = (move_fn == lru_add);
+
+	/*
+	 * If we're adding to the LRU, preemptively filter dead folios. Use
+	 * this dedicated folio batch for temp storage and deferred cleanup.
+	 */
+	if (is_lru_add)
+		folio_batch_init(&free_fbatch);
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
 		/* block memcg migration while the folio moves between lru */
-		if (move_fn != lru_add && !folio_test_clear_lru(folio))
+		if (!is_lru_add && !folio_test_clear_lru(folio))
 			continue;
 
+		/*
+		 * Filter dead folios by moving them from the add batch to the temp
+		 * batch for freeing after this loop.
+		 *
+		 * We're bypassing normal cleanup. Clear flags that are not
+		 * applicable to dead folios.
+		 *
+		 * Since the folio may be part of a huge page, unqueue from
+		 * deferred split list to avoid a dangling list entry.
+		 */
+		if (is_lru_add && folio_ref_freeze(folio, 1)) {
+			__folio_clear_active(folio);
+			__folio_clear_unevictable(folio);
+			folio_unqueue_deferred_split(folio);
+			fbatch->folios[i] = NULL;
+			folio_batch_add(&free_fbatch, folio);
+			continue;
+		}
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -176,6 +204,13 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
+
+	/* Cleanup filtered dead folios. */
+	if (is_lru_add) {
+		mem_cgroup_uncharge_folios(&free_fbatch);
+		free_unref_folios(&free_fbatch);
+	}
+
 	folios_put(fbatch);
 }
 
@@ -964,6 +999,10 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
 
+		/* Folio batch entry may have been preemptively removed during drain. */
+		if (!folio)
+			continue;
+
 		if (is_huge_zero_folio(folio))
 			continue;
 
-- 
2.52.0


