Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE29C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8536C6B0098; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E19A6B0099; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5FE6B009B; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E04C6B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:39:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9E6012017C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:39:09 +0000 (UTC)
X-FDA: 85221243618.20.C05580F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF44CC0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:39:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXBnIcOa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789601948;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7If5cFHcovWz+Mld04yBgyqgg8FuuIT7qz8Zk7Jiy5M=;
	b=QuBTkcUSeMq03ehaIuF/2s7c2SR1UU5nTjOZUTt4PwvLE8wUEaRSrxyN4TNbp5uSUKL/2L
	sUpiLmOQyXWKqKtv1cpa7hShjDcn9KisWStmPjlbGR+WiwLJUxyUPTN0LNW7GSs88mrXcu
	Mv2zUvxfJRFFl8Vam6QQQhNG9GIHdCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789601948;
	b=V1YZFUz5d2l3d6dTnXABXc3EzZwXJ53+vfPHdgZ5KfrpggdxD0qCxb1oFza46ZoHU4+nVy
	lrYnP0XCzjlHzBiTFqVJEzBi3olQ4b8euClImLsSDtv2cPTHKI3OqDXG7AZ7Lmt13NZmAx
	jpcEsTPKm17PdXNvy2klFFMWbKAbTFc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VXBnIcOa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 876CF43AB0;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E688C2BCFA;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789601946;
	bh=RGoRX1RDyrSAPSAqGKaUAGbiwsMYJA9HpHkYiWFLIp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VXBnIcOa9tsXw8aHWRjOcbObRrWnEoV+7dOdai+IBlx73005Ws5kQ/ZcfB16tQbBc
	 r3drVeslTSqakRX2N4AN478pEz31lC0MDvaWQMav/oG70t/k80gd8ZKto/gDbX4KyM
	 nVVryMu/4tX3kUheTgsfAPFbnfXdcHpdimnX27+JDDdpnt5rVxQ6MmcbZCEBewqD+H
	 oX6IbBtNlQOYm6Ye7gReFpSrXOZ6KD1JhfNOFxvbTBhGz9xxLE0+DFdFVM+xxxk3Qa
	 OAsM3dHKXlOPoakqq71njd9+4zAAUBR5IgLjXFBkQBuLlC+d+M36UvCypgO0Qe/ooF
	 p80FGDaLrPSeg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2370FC982D2;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 16 Sep 2026 16:39:03 -0700
Subject: [PATCH v3 3/4] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-hugetlb-subpool-always-track-used-v3-3-38aae9b5ccdd@google.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
 Yanteng Si <si.yanteng@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
 jthoughton@google.com, rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789601945; l=3621;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1huVTinJruMQqQrtxBHElgZ+G6QNS+uaPq2+mFiRl/Q=;
 b=3mwwcE8a0BxYqRtSkWGRir/QHbTfDAED/i3HhrT7HUL1zYfOt5B89NB41OlUu2HPPCHanEBUD
 yffVJCwwRoMC69yYDdiL0ZgGJdhEae4goGRkqNDknm0g/R51C1ZMoxI
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF44CC0004
X-Stat-Signature: g4hob11okexeixhd35jgcuugt4jsixho
X-HE-Tag: 1789601947-458238
X-HE-Meta: U2FsdGVkX1/GawvgfhoGE3yihEm73y/8t/sJz6SC9COLLmRQuBWiwU6Q/ZWKQnJ/Het6hr++YbDNZdCXob1dviY9cboswXVW499Rb8YoTLMoYQjv5ySHbY+v2LVJUYjD1CDqBTtabGn+PoKITDgn3SKjZvUsiuhSO9+kuSrf9zj3i0UrXdQFByyAcSRpPcKS2BrAJY8epzNFdSRLqyVNGPMi3scQrlqeiXTGuDt1LggEDfACRsyf4J6x4FuqyAnNipPWbrpu1/+A6AANolH7WQz8IYDaxDvVRPS8Y13l25TXWoDgEUm3CztpBx4TBHeYlhxY1ZsVFAXSjD1pJeHI6JSrKVOIxG7XLtuz3COHkbEhi3VMwA1/Mx+EtBjv3egYYahIPU7mg1UwUQMsmrZx7z4ZCzs2NHveQ66tlrXBGgnq4IaqAXZK+LCE02Wbf7OJFHNtftGXa06MzJwrgP0BR50bqPDjKNSyV9NS7AyHh3FKoXgwLuEf/I6Zm4KRN7YPsiD0FuekU7eCJTGKWq0sYtkNLfVdVA37YiSj8NgfDEFnw1HQXrQeuUKqkAlMYgNEPpFhLzaujOtTCYbBzS6o+pk4Ua3xvws8REZJNYV4fYoNrYEc+BAKrVJx1+K0gCVLM7n8BWygdSst4lvHN0kygY2yeHEA7X76T0BE9GdpI9OY6M1NdIAqgAmEClTEXcfCrbGZ7kWHaH+1f0f8mX7irA4aa0kGJNgn/cr0aRDImUXF8R2fXXa+ikf6STj8ZUIPvrSTFlPNTP7mORidTlsFgnhF/ZevM5fSqCZ2+FTS/gMB8Sfm8ZvUWXHzxvnqnadNLPBOeGfE8OS7MU18CDdfD7CAtsphsohUZvtFbxLNetXbNIkMra6gBA/U9ru2WNpCZASn9rCUOJ25AtmIAULiuOYLxN2n+874+77XrKywgHNFOddDMhvV3Mo4MGvEMDJIN3zmrqYvnb0vp/O5FEN
 8iQDtEno
 IPZTMX70gCb9FJGHaOX+OtKFyykSEq06FzUwHPP9l5Owwol14Swt0Vq4uDrJdzaZNK77z4VYaYZW1mqeJwHaYiOuk3TkVF+uq3JP7BNED67pUFM8wKbYpKA5dgP4KYRHMgriYZrAR3Rvjg3wifobkh+z4XbmzUJbBb23vkSrPkFzUO/+v8Ho1Cnh5yHKzmSEiBJngg8jGR/hmgw9L9SiKTDhcLieZptNvtVLq7qAb3z1HuQ9RwnmouEyKoGnAbxk6Zh6JLxs+n16YaHaur5SMODS0M3tyJNcgMk84IRezNNXfoFT5pXlUcseW6x2hm6yPqu75OV0Q4W/qf/BmnBjD5p+Qs0AitTL260ikIiXe122zFGIvuj0h0WNvhmbiQ1ikKXvA5006a5Lg3qdjRz9UI64EHkNBnQZgGlfaudY6ERIRUkJo3xQcGBWgk0gcUL4CBYtiz2ZuPA+c2STfeNaATzazxVPai/J5V+ZfK/vOgW/qG090Y9Hss4sFzS9ffbX7UMiM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When folio allocation fails early (e.g. buddy allocation failure or
cgroup charging failure) and a reservation was not used (meaning an
unreserved global page was needed), the subpool page acquired during the
allocation attempt must still be returned.

Currently, the subpool cleanup error path only returns the page to the
subpool if a reservation was used. If no reservation was used, it skips
releasing the page back to the subpool, permanently leaking the subpool's
used pages counter.

With subpools now always tracking used pages, always release the page
back to the subpool whenever a subpool page was acquired.

Opportunistically rename the local variables tracking global reservations
needed and global reservations returned. This clarifies the accounting:
a value of zero for needed global reservations indicates an existing
reservation satisfies the allocation, while a non-zero value indicates
new global pages are required.

Adjust global reservations using the difference between reservations
needed and reservations returned to properly handle races where concurrent
threads interact with the same subpool.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index faa799634822e..6589b188cf657 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2957,7 +2957,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_resv_get;
 	map_chg_state map_chg;
 	struct mempolicy_interpreted mpoli;
 	gfp_t gfp = htlb_alloc_mask(h);
@@ -2996,8 +2996,8 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * Or if it can get one from the pool reservation directly.
 	 */
 	if (map_chg) {
-		gbl_chg = hugepage_subpool_get_pages(spool, 1);
-		if (gbl_chg < 0) {
+		gbl_resv_get = hugepage_subpool_get_pages(spool, 1);
+		if (gbl_resv_get < 0) {
 			ret = -ENOSPC;
 			goto out_end_reservation;
 		}
@@ -3006,7 +3006,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		 * If we have the vma reservation ready, no need for extra
 		 * global reservation.
 		 */
-		gbl_chg = 0;
+		gbl_resv_get = 0;
 	}
 
 	/*
@@ -3017,10 +3017,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		alloc_flags |= HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
 
 	/*
-	 * gbl_chg == 0 indicates a reservation exists for this
+	 * gbl_resv_get == 0 indicates a reservation exists for this
 	 * allocation, so try to use it.
 	 */
-	if (gbl_chg == 0)
+	if (gbl_resv_get == 0)
 		alloc_flags |= HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
 
 	/* Takes reference on mpol. */
@@ -3074,13 +3074,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	return folio;
 
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
+
+		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
 	}
 
 out_end_reservation:

-- 
2.55.0.1082.g2b9226bbc0-goog



