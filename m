Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB09A606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=goKA296C
Received: by kanga.kvack.org (Postfix)
	id 060186B05B9; Sat, 31 Oct 2026 06:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036FD6B05BA; Sat, 31 Oct 2026 06:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8ECD6B05BB; Sat, 31 Oct 2026 06:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD7DA6B05B9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:35:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E303A8290
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:59 +0000 (UTC)
X-FDA: 85382566038.29.031AF45
Received: from outbound.st.icloud.com (st-2004h-snip4-5.eps.apple.com [57.103.78.246])
	by imf31.hostedemail.com (Postfix) with ESMTP id 523E620002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=goKA296C;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf31.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.78.246 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793442957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KiLbCqh3KbXG4ivr0NTs62tHMSh1wth3efulb21WI4=;
	b=DrhxGLQKz4SZ06mVSpX6ZryaBp9WmbxSh2kx01ohh/kB3S8/k87s/CTT5oDu8haThQBLka
	XQ0GrdXHQfriqYiNMSwpMN97KNq8S7aoqKWSCfn+5UNvSpewxQzS/iJNuVO2NoP0f+nRBw
	xgwIcmomODVMQVqsKL26z39GhCxHAhY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=goKA296C;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf31.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.78.246 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793442957;
	b=F1md3lat0yx/EFvYm0Ha/1FShB99dUvpeUZEU6lg+iDa88ImpNx5yfqqHFQvzcUcpigVNt
	7ziYHaA5zewNlyTDJeaRi+3YtagS+jcqbzBCaQGavapHwtwofjyahyy8CIeRxCk7tKQs8s
	ImBIyAvAdsWdXuytj5WNW4f/AFdO9N0=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id D1E4D18002AD;
	Sat, 31 Oct 2026 10:35:51 +0000 (UTC)
X-ICL-RepId: 01a19187-b226-72d1-834e-d22ae37e9ad0
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZcEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwBAC04CXQRaHxJYDFAFGh9eEhQeXxhEAx8GD1UGQAZSAkUKQQteDg5XE3kMVgNUDlwEFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793442956; x=1824978956; bh=3KiLbCqh3KbXG4ivr0NTs62tHMSh1wth3efulb21WI4=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=goKA296CZN4xa9ZT6VYN887j+QL5AyD2TZjC5YGhTRvB7DuWcP3F1dbk3kVbAP3nMPZJ/qDR1AegPIFcvg686uyvPynKoJyX8aikMmQNOvvmt5xVpGa5Q1TIqQKWShRxygJ+F5BC/EsrfYtRJ8W50LyvBzsCMRvhcGTr3vLARwSnLMOUZJ+cWjvUFKHPr0Pu14L2pxA9PAmcyLqezog4MwD4GlzInWEuRBehoIfy8Vsk96zPxi00PnorHKEYGntyfYoI5ZqBC0picUjdZbnv4VMFwUtrPqnxG6xqdIOAKMEtsgWVQ4QWvkuxLwFu3S/aaI7mwArc6zrPfMG0gXp3LA==
Received: from [192.168.5.15] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 62E7F18002BD;
	Sat, 31 Oct 2026 10:35:46 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Sat, 31 Oct 2026 18:35:12 +0800
Subject: [PATCH v6 5/5] mm/vmscan: batch dirty TLB flushes before pageout
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-batch-tlb-flush-v6-5-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
In-Reply-To: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA0MiBTYWx0ZWRfX7sKGwIC7XZPd
 PlZTtk40uF8LvLnqACQ8aufD5hXMFxFHfWdWKTbDRKlSrMQ1eBHE4hbnZuFnAaMaydk4pV6vNnw
 Hap7fwxHgWrD8y/xo1OdKTQL6W2RPGuNxCCZaRetMz7sm4vCxAL6iFNaR37L85G4mxBPpITTCAy
 XLyIzX2H/KllL+lSojsFvyCu6hIqQh+89vK3uiCsoQIlYnEoKCesOJMZjLwxOOLcjFmQfvLjz2V
 XTkSLVxfsyBzueG9hRWoSGCSww1u20BGEe4Y/XARuOzeTjCDV8Am7kSAm4KxgS5Cgb11YC/PdKA
 wD6+LCDy5Soi2J7wniaFucu8GkDiim5i91fkNJ6BGh11jxeZOx+hTwn5Ekwn5k=
X-Proofpoint-ORIG-GUID: 2mMLgDoyhFjcu4KCPlvbE47ROxDQhDnr
X-Proofpoint-GUID: 2mMLgDoyhFjcu4KCPlvbE47ROxDQhDnr
X-Authority-Info-Out: v=2.4 cv=TZqbdBQh c=1 sm=1 tr=0 ts=6ae5c48a
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=bSmHYz4YPk1EoIDwg3UA:9 a=QEXdDO2ut3YA:10
X-JNJ: AAAAAAABkHeuJtQ6+/Yz0kcGtFchbRSQCpFyLuLDBdfBx6VKDWxqbOwMQEmXLmjTvwZLHC
 CjYk9wluuR7x032VqgXQBFkaqUL6E1KqRgawRTh84mFlnEUdUVpctk4idnb2qdUSEn6RY4
 UZekgnDWlB1dieovTC9WTvWSR5u5Z7JlLbhnllwscDKuOJeXaEZcsYALJ8qoND+uJgJUtR
 nRJ5r6SWHVzWW9CG/8hOlt1yagfcMJ3bI5xv8KhLzsWQpxc5qWT1T4fj4sqfTLBYul7uVd
 fIaKoTVUr3C62OpZ2XASYURr32t+PSBlJ/cg+z5vOomyKLKXRA85vsqZW+DSl3O+pQzt1q
 tFvyPqM8HIouPuUt64Acnfn4kwW0U0ckZewLhf1ilILAAKYXdzfR2rKB0MrmoGB7ly/uxn
 mITyoVgcblLaWUC+WfqRj9riTY++EadCsbGDMf/b+8E+vXPEqinbLAxzSyufLdbvsI+W3M
 +5UkX6PapxJnWon8ZjHFwTBVaRSrc3XaocTV8irVtdhJ1gaFb8zOQEYCxYuvSNoaV+pwZz
 8Ge04pMKi7W1dppdUar5mUqK4wzUkunD547xM7+vEz5mbbWtP+1RXg0Acyvn3+fmMBCW5l
 TFpT3EcANYIhK/CUKq08HsBRrlVetuRb6U5cdHXgXUlMLwEnOgLmDRrNiBuWkXTmS/LGcJ
 pCcvlggyV32lGTA5/kNyt45vyblCD5mnEidSA2TaIGrgcGyXJbN0wIHv49Rqg5K04//YfY
 nUkH6nmXUTgt+wPKnDijtsfp2I/4fTgdxyAPSQ+oJQv8iGAwGDYyzvMAZADHCsvntqqhRR
 X5veXEIQ3Zcqfjl4R+zfaQuFprTFP3NvbZ4idyDZI6k3xZPy3UgjwBYvWsvOPSNwd5sY4B
 crgRlNslOt7i0t+qsKw6EOsXuXD1sJb4Ob
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 523E620002
X-Stat-Signature: gx5cs8uonodh39m4sjtmahzk5dke1fua
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793442958-680970
X-HE-Meta: U2FsdGVkX1/lSKybtGPUWqqbIF5oeqxn7zaf3Oc4rnAAOX+Ukqx/oS60Myf//vSD2d5tWMSI4zhi24x+qFRTsN2lb7isQgN/vDtTopfzO1mtAICUDElxz2AxHrzT22N4/m8sRtjl7IlMOqQeknE7N69IAatjRbvjka8pN30R43p8u+kHG4fsotMwz9lYQnJqriXYlnPHIugOVhiNxLuxmzKC+AIUej/BRGBKGkLofGUvsMLtwn3ccTesgfB8Ar9FKcRff6ZnV7V2BYrGj+mbaq+cyUFlNzlmDcF8OZnpZyLWV4l8V9rCPR4fhWjbO/gv6uPyJwlOonLiw2FqrR9qtt4l41E0H4ppvWrQ+txRGX3Yr0JQG0D9iIxsZI5VC/7R964FaVy7h4f78iqMthc5jDNTjNwgJk0O3XxrmzBvTDiSlKYt8iIhm6W7qPCCB53i8+DBhxVovJCWuccwFqjfZOCiBnasj1l08iPUIARXkGka6GNTqr7I1Yy64/q2ao2zZpQrdjajih4WPyb6Jfu8eYqO9kvdhLAaiG/Rga6UJ56OJ8a8VkITmao8itZ2YJFtnpYhUw1KiO5T2qqJXGDWFawf7nJCZiBPaPYwZygl2+aQqxuKB6+2bIZL4hX0QbtX7lqNXjkAoPY58hgm00m6Bdt8QzqVDZDH4tKpi0CrJkFbKgZpfbvRcop4dxLDBWNafFP6q2qU0ji3nEmICwIccpkaZDSQtXn7gZ0CsY7QKX4vauAO8qlzjBP/y5slnLnxsAwjbHUlnZzbE6lt3ng8wB+/4MPHEEKfc774IhD1o+OzuEydz4rwqlsQNpNdTgTeIi4OZFya3D6bUC27FtiVEgII8Zh8xjS9AXCY921WmtnkNufdTcNgiOOFPMs4iEZmVeDuwHo5hSe773FDhJqzr2lKWOIwlIK9VRoM/9I5afDQHSuEwB6KVd5WyscEt6UO3Dgn3M2eHwuVYaJaOZ8
 wqgacjDE
 B9HljHjcxAAec4uU4SDaBrnEZVtewajOZDG2oDgmYgsS31ZC2XLMRnS6+oG0u4+rtWyiSjHSpWSPAKsBztdyhdxP0Njqzfj+Ds9466Sc8UOHGywbIv1ZcM4vQ4Ec4ICPUj15Zy62GhOqAx8WdhewjUZcu02RepzEvJa/MMHSCZJXscLo1bmgu7nFK3dHpbaJJaP3QZLOs8McwsxKjWmSIrUqOBsSFTA6M8b5y3IbeTNiLgC1y2FspN0SrJVp1TY4aT9X1x/dVzEE1GC9bH0TZt/3thakzpZLcnQgfwtgJ8Iao4tPENqyGZ8iQz+UXAefrgi6fhQsGLuUTIPWZ2OAa+3PxIZ6meXf2p3k6Wxq9jFjglj37v+nMj55ofnXDJFd1tP0evf7TzOsIPKJywU9Db1vq2GwkDri0IM5L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently reclaim flushes the TLB for every dirty folio before pageout.
On systems with many CPUs, the resulting IPIs can be a significant
bottleneck.

Collect dirty folios in a folio_batch instead. When the batch is full,
lock and revalidate each folio, flush pending writable TLB entries once,
and page out the folios that remain eligible. Flush a final partial batch
at the end of the scan.

Folios are unlocked while waiting in the batch so swap faults can make
progress. After reacquiring the folio lock, recheck writeback, mappings,
and DMA pins; a concurrent swapin may have installed a PTE and allowed a
parallel GUP pin while the folio was unlocked. Keep each unmapped folio
locked across the TLB flush and pageout to prevent swap faults from
remapping it before I/O starts. The folio lock alone does not exclude GUP.

Save the original batch count and reinitialize the batch, then add back
folios that pass validation. Reinitialization leaves the array intact,
and each add writes at or before the current read index. This reuses
the batch without overwriting unread entries or needing a second array.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 101 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 061414ff45bb..1150361e7d52 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1334,6 +1334,92 @@ static enum folio_pageout_result folio_try_pageout(struct folio *folio,
 	unreachable();
 }
 
+static void folio_batch_pageout(struct folio_batch *batch,
+		struct reclaim_folio_state *state, struct scan_control *sc,
+		struct reclaim_stat *stat, struct swap_io_ctx *ctx,
+		struct list_head *folio_list)
+{
+	unsigned int nr = folio_batch_count(batch);
+	unsigned int i;
+
+	/*
+	 * Reuse this private batch to collect the locked folios. Reinit
+	 * leaves the array intact; nr preserves the original input count.
+	 * Adding each accepted folio writes at or before the current read
+	 * index, so entries we have not read yet cannot be overwritten.
+	 */
+	folio_batch_reinit(batch);
+
+	/*
+	 * Revalidate after taking the lock: writeback may have started, or
+	 * a swap fault may have remapped the folio and allowed GUP to pin it.
+	 * Keeping an unmapped folio locked prevents swap faults from mapping
+	 * it again before the TLB flush and pageout. The lock alone does not
+	 * exclude GUP, so existing mappings and pins must both be checked.
+	 */
+	for (i = 0; i < nr; i++) {
+		struct folio *folio = batch->folios[i];
+
+		if (!folio_trylock(folio)) {
+			list_add(&folio->lru, &state->ret_folios);
+			continue;
+		}
+
+		VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);
+
+		/* The folio may have changed while it was unlocked. */
+		if (folio_test_writeback(folio) || folio_mapped(folio) ||
+		    folio_maybe_dma_pinned(folio)) {
+			folio_unlock(folio);
+			list_add(&folio->lru, &state->ret_folios);
+			continue;
+		}
+
+		folio_batch_add(batch, folio);
+	}
+	nr = folio_batch_count(batch);
+
+	if (!nr)
+		return;
+
+	/*
+	 * Flush writable TLB entries before any folio in the batch is
+	 * submitted for I/O.
+	 */
+	try_to_unmap_flush_dirty();
+
+	for (i = 0; i < nr; i++) {
+		struct folio *folio = batch->folios[i];
+
+		switch (folio_try_pageout(folio, sc, ctx, folio_list)) {
+		case FOLIO_PAGEOUT_ACTIVATE:
+			goto activate_locked;
+		case FOLIO_PAGEOUT_KEEP_LOCKED:
+			goto keep_locked;
+		case FOLIO_PAGEOUT_KEEP_UNLOCKED:
+			goto keep;
+		case FOLIO_PAGEOUT_RECLAIM:
+			break;	/* folio is locked; try to free it below */
+		}
+
+		switch (folio_try_reclaim_free(folio, state, sc)) {
+		case FOLIO_RECLAIM_ACTIVATE:
+			goto activate_locked;
+		case FOLIO_RECLAIM_KEEP:
+			goto keep_locked;
+		case FOLIO_RECLAIM_DONE:
+			continue;
+		}
+activate_locked:
+		folio_activate_locked(folio, stat);
+keep_locked:
+		folio_unlock(folio);
+keep:
+		list_add(&folio->lru, &state->ret_folios);
+	}
+	folio_batch_reinit(batch);
+}
+
 static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
 		unsigned int nr_pages)
 {
@@ -1375,6 +1461,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		struct mem_cgroup *memcg)
 {
 	struct reclaim_folio_state state = {};
+	struct folio_batch pageout_folios;
 	LIST_HEAD(demote_folios);
 	unsigned int nr_demoted = 0;
 	unsigned int pgactivate = 0;
@@ -1383,6 +1470,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 	INIT_LIST_HEAD(&state.ret_folios);
 	folio_batch_init(&state.free_folios);
+	folio_batch_init(&pageout_folios);
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
@@ -1679,21 +1767,16 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			if (!sc->may_writepage)
 				goto keep_locked;
 			/*
-			 * Folio is dirty. Flush the TLB if a writable entry
-			 * potentially exists to avoid CPU writes after I/O
-			 * starts and then write it out here.
+			 * Drop the lock so swap faults finding this folio
+			 * via swap cache lookup can make progress; the
+			 * recheck that this necessitates is documented in
+			 * folio_batch_pageout().
 			 */
-			try_to_unmap_flush_dirty();
-			switch (folio_try_pageout(folio, sc, &ctx, folio_list)) {
-			case FOLIO_PAGEOUT_ACTIVATE:
-				goto activate_locked;
-			case FOLIO_PAGEOUT_KEEP_LOCKED:
-				goto keep_locked;
-			case FOLIO_PAGEOUT_KEEP_UNLOCKED:
-				goto keep;
-			case FOLIO_PAGEOUT_RECLAIM:
-				break;	/* folio is locked; try to free it below */
-			}
+			folio_unlock(folio);
+			if (!folio_batch_add(&pageout_folios, folio))
+				folio_batch_pageout(&pageout_folios, &state,
+						    sc, stat, &ctx, folio_list);
+			continue;
 		}
 
 		switch (folio_try_reclaim_free(folio, &state, sc)) {
@@ -1721,6 +1804,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
 	}
+	if (folio_batch_count(&pageout_folios)) {
+		folio_batch_pageout(&pageout_folios, &state, sc, stat,
+				    &ctx, folio_list);
+	}
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */

-- 
2.56.0


