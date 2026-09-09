Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 824A7C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FF0A6B0093; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680FC6B0096; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5229C6B0098; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFCCD6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:49:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25E081C2022
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:41 +0000 (UTC)
X-FDA: 85195566162.20.53A7EFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E61320009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WAxtSjUX;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niSYalp/OzFowRa1XzYKAXzPBKrpCkIvvO6JxEmnQz4=;
	b=Gkf8xXVBCC4l/0OD+u6Nj6O5EWIU6/2HJn/ueFhyoYxTQ92gbgYfMo/6gUMjyWxrRo2xYa
	iJ9Vd8pVJp+/n+GW2jtDK3dJow7KiVL0ZT2+w58t/Gg60dfVgpxST9YwAp8SohpL82vHH9
	y5khYoc94mHE9x0C+FiJTW7lBm3ZYpw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788990579;
	b=4OnKecCbSCEOMU7TwNHITte4YL87v1gHlfBVg61jo0SMCKVoc0OP0UsYKXfDHMh6RnakiO
	iK0OAUijUU/xk79BcB6YwY9oBCVNM6DkbIug1uEthSOZMy3rBQqytXIoUwMjgK+EJolZdh
	RZ2k3dHGXi6xTAKqPJSpjXNTYbiHLCw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WAxtSjUX;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1498443BD8;
	Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF104C2BCF4;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788990578;
	bh=95oqh24GgfcuS7voUTlH+bgV8KCd93u3lATunNdh7lc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WAxtSjUXMBGV4ctuJag3LGh+Vpl+1bPhqBR6L3h2Rn6KUP3s0/hK6iek6h0Oeu7ql
	 FsTt3GgxPMbp2I/sjNCLovy+Umal2gqut6WseSq+kMASHJ6qVIPZI0sGg4Ca38RCph
	 7vWeLObZyDMDexhloBG+P1O1oAirnbs3BQaaaAhxSGQIAKUwGMtYMOclC+LOVbcKZw
	 5BjBVlMWIP3f8dUqqjeUdy8fybatLgsI2d5nye/xCG5td1BFOy5PWYNJk+2Wj3i4bw
	 m+YD5O1WZaUgnsxlp7c1pFx4ixm4q7LzK3aj5bOKh+YHQX+UP5Gab3/TWAcmHGRUQj
	 LAs6cJe+vBP0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC182C79FB7;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 09 Sep 2026 14:49:27 -0700
Subject: [PATCH v2 2/4] mm: hugetlb: Fix out_put_pages subpool reserve
 calculation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hugetlb-subpool-always-track-used-v2-2-30c5d83b572a@google.com>
References: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
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
 Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
 rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788990577; l=5067;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=4Uw5lcnuyxNZEYs1i4bs32YYkWYGwj+suwGu5wWpSr0=;
 b=AG1QU4HeP/mW1//FjtrLg1NUFFPPsKl+Vw49MmQk1MolvuvY4jhtcxZpJTM6OV/lcwiexL1Lu
 pV7YB87lkkXDTk8QtwhmGVwJn5ojAoN+EKTpOnaMeJoOxaWgD3NrtYu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1yhcutfaocrbwc1xfj1ugdmbma5bt3ni
X-Rspamd-Queue-Id: 0E61320009
X-HE-Tag: 1788990578-848554
X-HE-Meta: U2FsdGVkX18RR/qoUfBlvndLqEiulMmW9nifHXjWEZ6YFZyMkyG23FBKBofheAWhVRQHtb3BmvgcZ50VFnh6XkHwKQNNd2jZT/Cdk81FoQ3UnxKHvbJ05wPIlsrOpuZITWyb4RHZD8A17sFm31rtfAo2Ek259VKbFMFnvQiHiauEYM93pju0LBL+ACoYZIJlQzcXenAY1QKnVltkoCDRaaOW2IfpzOHnXuLsQcYE7Vbl7Kcv58CmadcZCPKzPrZX4K/URLfF4/e4XlKJKcVrxMNm2TlTY87SkWB7BQtGwXE6HzaZJK++hGe0UdZgXSdBm96DZJK3/wE/0Wi+y6wuIy0CVfpetWwZ4WtkntASesvZsLIrPXRJncxr38heWuO8PjxJIuLNOII6dH4Lq91cNC/F2ZzrXCjiBB9VbshWvVHIi/8pMLXT0KWuJfkS599ZxQR4zYJJPOHUduonAtfFGndzRaEDI6SP5XtZ9zcHb0vski8uHxkhg6TKQ5EYfXahMRzJv8ZCqo3sApHSvQiyMJt1PD9m/2AEXLcp2Oi6QiPrTbCvtkMtHTg8hQuQ1hYylXXp7TZejXTAdRyd1u13Fs9KeBrfEmXoNYaettLtQ2EbqASq+XNTN200eNvvm0Vk7nwAhUW4sVMhm4mpp6YeQrW8tc+WgUAZmsrqwFmwUI86J4QrvCHyGW2H6Wmvisj+Z3sePIPRcyDI8Oo96QU2G2UiUbE8JI+m0cx2Lkn0HeEQn6bkkxRbwPeog/JpHPVmBrTw6L11mSA5j/jkWKV1DxXd5jTx8mZmDE8Su4ID+0uubBIujXQflNGG1saCcwkO0ZrCfwbMCfYXMOFVA6LgGylnzQhWOIGsAkdxR5Kda8BUnYKRRsCk8+TZZ9RrWmyJmitHTQHZsOUlfTcf+IzZJSb5ixJ1BgTPWlTMueAJSiCUjGeyOmrw2SKQSityy6p090aacMbtzpcS59Qp5bl
 KE5hLOF/
 Td0KEjER0+nGM6xfYh6lDLkn8pGzC/hJWMkrQ0g4faW81RLwiycbiIH0Kzd5Rgt72w6A90hKrGkmNFm6VNUosQqlBeTVE4Vi2Gh0xG9SBZ+QMFe82ly0OiOGihm/YChqeOZ6pOCiZ8QEUbCPSllJ5+pFMMCFn+5rPp6MvRq/dcCTbNyhDC9BMUtC0M4RB3ilUyykpvxF5MWZNi9+LPQp1g69ETxvypsz/VOe+uT5Zo/faY341DSSsdg3CGlGhUoQlIhjx85/g8Vr/K3tB61yuH1u95NZ5JYvASj0e80xPPpxoB/S6/8Z4YvcM73NW9PES1vEhpU9lvR+uyXS8gh6RgQDAllSjGnwu9p3+gP3XYO+gwXxct1k9FRcSs7C5Om/P/YOyIlSIJ2FHYVNRECQ8URJsIwuq+GiNlmXdj+tiQOittba14BLPIBUwvLnsa/QpGT4rk9Kw/myxkBbp731t+McQCrr5PM8WZWoW+VMms4ofsVaelQEVv0CLLBmx7o+FbhET+uWgOPPJ/ZPmRfaNgYxtog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When reserving pages for a mapping fails during global accounting, the
error path rolls back the adjustments made to the subpool.

Currently, this rollback was performed in two separate steps:

1. Returning only the portion of reservations originally satisfied from the
   subpool
2. Separately adjusting the subpool used pages counter for the portion that
   was requested from the global pool.

In (1.), because the used pages counter had not yet been decremented for
the global portion, the subpool observed an inflated used pages count. If
the mount was configured with both a minimum size and a maximum size, this
inflated count prevented the subpool from recognizing that usage fell below
the minimum size guarantee.

As a result, the subpool failed to restore its reserved pages counter and
instead returned that a global reservation should be dropped. The
mount-time reservation is permanently destroyed, leaving global reservation
counts depleted and causing an underflow when the filesystem is eventually
unmounted.

Additionally, if concurrent threads modified subpool usage during the
reservation attempt, calculating the rollback amount using stale local
variables could cause global reservation counts to diverge.

Now that used pages are always tracked within the subpool, return the
entire requested page count to the subpool in a single call. Global
reservations are then adjusted using the difference between the
reservations originally requested and those returned, fixing the issues
described above.

Fixes: 1d3f9bb4c8af ("mm/hugetlb: restore failed global reservations to subpool")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e72e22f887478..9eb9f3442574c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6676,12 +6676,14 @@ long hugetlb_reserve_pages(struct inode *inode,
 		struct vm_area_struct *vma,
 		vma_flags_t vma_flags)
 {
-	long chg = -1, add = -1, spool_resv, gbl_resv;
+	long chg = -1, add = -1;
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
-	long gbl_reserve, regions_needed = 0;
+	long regions_needed = 0;
+	long gbl_resv_get;
+	long gbl_resv_put;
 	int err;
 
 	/* This should never happen */
@@ -6756,9 +6758,9 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * the subpool has a minimum size, there may be some global
 	 * reservations already in place (gbl_reserve).
 	 */
-	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_reserve < 0) {
-		err = gbl_reserve;
+	gbl_resv_get = hugepage_subpool_get_pages(spool, chg);
+	if (gbl_resv_get < 0) {
+		err = gbl_resv_get;
 		goto out_uncharge_cgroup;
 	}
 
@@ -6766,7 +6768,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	err = hugetlb_acct_memory(h, gbl_reserve);
+	err = hugetlb_acct_memory(h, gbl_resv_get);
 	if (err < 0)
 		goto out_put_pages;
 
@@ -6785,7 +6787,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
-			hugetlb_acct_memory(h, -gbl_reserve);
+			hugetlb_acct_memory(h, -gbl_resv_get);
 			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
@@ -6821,26 +6823,21 @@ long hugetlb_reserve_pages(struct inode *inode,
 	}
 	return chg;
 
-out_put_pages:
-	spool_resv = chg - gbl_reserve;
-	if (spool_resv) {
-		/* put sub pool's reservation back, chg - gbl_reserve */
-		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
-		/*
-		 * subpool's reserved pages can not be put back due to race,
-		 * return to hstate.
-		 */
-		hugetlb_acct_memory(h, -gbl_resv);
-	}
-	/* Restore used_hpages for pages that failed global reservation */
-	if (gbl_reserve && spool) {
-		unsigned long flags;
+ out_put_pages:
+	/*
+	 * Return all that was requested from the subpool, let subpool
+	 * tell us the new number of reservations that need to be
+	 * returned to the global pool.
+	 */
+	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
+	/*
+	 * There may be a difference between the number of
+	 * reservations to consume and the number to restore now if
+	 * there are multiple threads interacting with the subpool -
+	 * restore the difference.
+	 */
+	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
 
-		spin_lock_irqsave(&spool->lock, flags);
-		if (spool->max_hpages != -1)
-			spool->used_hpages -= gbl_reserve;
-		unlock_or_release_subpool(spool, flags);
-	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);

-- 
2.55.0.1007.g17ff1f9808-goog



