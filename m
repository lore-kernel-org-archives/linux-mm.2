Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F21C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39A16B0093; Wed, 16 Sep 2026 19:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C041D6B0099; Wed, 16 Sep 2026 19:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4A56B0093; Wed, 16 Sep 2026 19:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F10D6B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:39:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A127C1601C5
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:39:09 +0000 (UTC)
X-FDA: 85221243618.05.C1885FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BE602A0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:39:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t+vbu/xV";
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789601947;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCYfZXqmpGsVfBnkZEnUUI322/Z4Nf2o/U7z9DNBbLc=;
	b=JN5Z7ZwIcIX0yq3ZXrALnm9UkACqFkfxJcloToDAuKJmE9Xd7e41AGNPaIWkq4CqI0dFTi
	9i/555G2j82+rn0kF+3xCekJ9yAkF6xNLWcCtNz81G/EGA0Y5ydaJz+CTIznzsa3XqNmdY
	cw+gZw6/kkF+PCcutseJMQAMEZPDWw8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t+vbu/xV";
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789601947;
	b=dhQ4T46n5esEkbWi7J+qPpaTVy0NvBbcEGn4zlRgjpsOUWZhTYBCb4YQy1dAkuXqLSL9on
	TOurZAu+Cd4fxW09F53jsWGZlF//mwWIzI2+OtI82XCsPfAGvGQ6r8tVV+jeaSh+BHpGvd
	yW6L/lxn7YLLxE3U9Ld6wMrLLdP7olg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D55A86053D;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52018C4AF0B;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789601946;
	bh=IhwjyvHVYrWOfbhr0n4oozYGOJcvz2hx+di9cgmtNYg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t+vbu/xV4Az10BSHzR73caqmy/wBkXx3tIkkVUjEhANYrWxpMA/fCZ07XyRG+QHAK
	 nOOpXPVJkK2KsyVy0jNiYCvMjd1FwitMD3zDq8RmBZwGV9psX1lJ14jutLj+3KPSBx
	 TH1fj2bcXKJtCGNL+TT+nh17rDG6+9HkCyDBgiPAs6J0A0Fk2FxBz9leRgks0WeDv9
	 6T2xjIzwoC8FsNJCweaoIpUPl6RlFR1uvvPySh8H/72rhH+PlKoUGRy0wPzFCjgOnQ
	 E05tQse1Whw7GaLjef2mvHsTUARlP469a64PlelsaXq3BdtFPU2MtNdgTPudk/9I4Q
	 rZZ678mabB5pw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B3FC982CC;
	Wed, 16 Sep 2026 23:39:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 16 Sep 2026 16:39:04 -0700
Subject: [PATCH v3 4/4] mm: hugetlb: Avoid re-allocating global
 reservations on region add failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-hugetlb-subpool-always-track-used-v3-4-38aae9b5ccdd@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789601945; l=3236;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9bkEGkyOV+QSeVMa/iDk/E1YpKwvqaT90NhqaQIG64M=;
 b=1XGNWUGnRvXVj0bMgtwgkbvJCSRj9qFIRHBreCl+e2AgqRTZkDsOM2OSA2gB1BLKbsz15xSmP
 MfrGwkkqi1VAaqqDTOsiY3A1fVam18S8s0W1iW3z5Y1JgHhB6P7b5hR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE602A0006
X-Stat-Signature: d8anfo8ezen8hamiuaz1u51dxncqzbss
X-Rspam-User: 
X-HE-Tag: 1789601947-964251
X-HE-Meta: U2FsdGVkX1+UkoUImXZG3Epc78L2VAtInyDTwYc8DjUGWDMAoJgnNPcbCJFe720U9XCZ0vZLGQ/EPRLqwaO3MsoV24Auvj+Fo8O2TS++0+7IT4Ch5JAPtwlg54LD2kjm5/baBcwhplogwkbefFDbT1TNXbizwPmu7NT8IQ1BzZVnJkKNCFKsN2iaNMcXqBXUKzW6eYrVawMx6+X3uhEuO90r22R0gYlKzZjjqBm8IhuVwBBZfMqixCQM66ztetGxGwY9zWrzs/PlydpVikQcQ5PaCF04RojiH6f4gnfNK27TEv6lL30BqgtkTb41XP4UU1vekwBNFgAv0nVsl6wE7U39QBO+Fa0l88M083u9WTkWZCOnxjHKx9nO98hbpaKVgrpfCdGy7RtVoAI+z1ee9g8A6u16XpurWbV8TfJuwpub9BqvUbbwFKtWoga/NmyLhZzqJQiniYcgVH3YlCethNhmlhnN7AoYkGgXfd85+dpH8n3k2j7fe7UB3efJDA7tRpYMTiSx2QNby+ub2OTS5iKGJT3xhGMCOgx5eya8/MFNPz2EbmkZXEw9EBPNXdOvketreGmQmaq5IrPpSAgd+aZ897iZhLAUvgmCKjEScHZgPAO5pVbAzlHqdTr6DnvhpsN/XfH0lxMbM3n1h3V6ZZcmrrTugPnVl5vwKMUFb5cgwMuqCjoUcywPDEflocsDRIYWpMX5HdtflxXwFPfywJIcAR1E/tW09OxvJo0W/EWpffJP6RLouekSf+i5rd/HuZ+mhGPgxWGsg0O5nIZWQkfpUqKO1EOI1qO/45u+m7LXKQ/HatQGupzxx7Mkn12tzoPJ1o/fzvsUKMzlkz/f4aDQMcec8buprxH9/J8sZXXtae4Xi3QTu1yExKA3yLyMRnTuKpqCTE/qqInIuG5wnfkgYU2TjXUkEE0iy++AyLRL4mlnAaUz75NpgVKxxlD99APMgmDkInnAHPVnp4q
 /c7t3fBI
 LVlr+DCGU2E3cATgRwNVlRRIzYT7FBzH6I6Du8MDkxPv+ORQmTJbiRExiMAbwZQsm3kBGapClD4wAyHTvaYTBjdZBOtFyAeoVxMrUKyYZIlvs6B6H9hj4noqHu5WNp2lF1uatujSH8ulFk920e03YxN74s4CbR+9nu36AXQVtBgwhcYMmzjOnhWfVSO6w0j6rkVLviGassWbkqbNMsCMHZwPd0md1S4Kyw5UV00+YJRQi/HBkjcrB/a4utGOjMK5fhVNJm79/rsA12wKUdugHRGcI2dEWEAU1XBIiFEt1Lw4gXBnVKa34W9gymQ8afQrbRG6Dgf1xdqVJldGJXyo/gysAlxBaaI1toLIgsJjDBuUzOu/xSFmeVlUgCmWH3QLibXAdCICuyNPyZddLq/lfvJpSnQoxbpkrBKfZwNZYlubJOOLSzSl+U7kfqZF79KTTDlX5m9SDACwNtWeLginU4rFevPFVcRL7DsbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When reserving huge pages for a shared mapping, reservations are first
requested from the subpool, and any remainder is accounted in global
reservations. When adding the file region entries fails later in the
process, the reservation attempt must be rolled back.

Previously, this error path explicitly dropped the global reservations
that were just acquired before jumping to the cleanup label. The cleanup
label then returned the pages to the subpool. If concurrent activity in
the subpool allowed the subpool to absorb more reservations upon return
than it supplied initially, the cleanup label calculated a positive
difference and attempted to allocate new global reservations from scratch.

This premature release was completely unnecessary because all requested
pages were already backed globally: partly by the mount guarantee and
partly by the global reservations just acquired. Prematurely dissolving
those reservations forced the cleanup path to attempt fresh buddy
allocations that could fail under memory pressure.

Instead, track the number of global reservations actually accounted so
far. In the cleanup label, subtract the already-accounted amount from the
difference between requested and returned reservations. This ensures
that when global reservations were already acquired, the adjustment is
purely non-positive, dropping excess reservations without ever attempting
fresh allocations.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6589b188cf657..ee1ba9ded0ec7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6678,6 +6678,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
+	long gbl_resv_accounted = 0;
 	long regions_needed = 0;
 	long gbl_resv_get;
 	long gbl_resv_put;
@@ -6768,6 +6769,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	err = hugetlb_acct_memory(h, gbl_resv_get);
 	if (err < 0)
 		goto out_put_pages;
+	gbl_resv_accounted = gbl_resv_get;
 
 	/*
 	 * Account for the reservations made. Shared mappings record regions
@@ -6784,7 +6786,6 @@ long hugetlb_reserve_pages(struct inode *inode,
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
-			hugetlb_acct_memory(h, -gbl_resv_get);
 			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
@@ -6826,9 +6827,10 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * There may be a difference between the number of
 	 * reservations to consume and the number to restore now if
 	 * there are multiple threads interacting with the subpool -
-	 * restore the difference.
+	 * restore the difference, taking into account any global
+	 * reservations already acquired.
 	 */
-	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
+	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - gbl_resv_accounted);
 
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),

-- 
2.55.0.1082.g2b9226bbc0-goog



