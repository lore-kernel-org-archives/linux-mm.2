Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C97C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76E66B008C; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE946B0099; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966C26B008C; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 414556B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73B96C032D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:41 +0000 (UTC)
X-FDA: 85195566162.14.5C8FAA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5B62218000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bgXRonsL;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYqkC2y5T4cTDk8Qavv2dcqyN/LRKfEF5rqCYAJ6bwU=;
	b=QVwBzlgd02boNVbn4HQBiE/oqwQMFah5VH13rz8hikFrRuiflzbZw1+i4xNaGc1yQ2aBDm
	ghNjcAa4KeTKdfnF7zmMhW8QXLjnseXoxtEOkDcIAD7mvhX9LXeek2b6mFkJtNpZvr3XsP
	R7jT+KorDuMKNMOBpkIX9ob1Eio3wDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788990579;
	b=qz1I0EoRcCNuk75M+v+o+FrC2S26Lp54j9ZIVApj5u4SHnqxBwFESvY1y6LWrG4xynkLtP
	mU9iHAF2/FZ49bOgiqhegD96z09tGbM9O4AKGk3cBxzMfV4Za1cS2BsXoYBxsXsVsb8d7Y
	VXhZuHSyNg/bgf4HaoX7/gMp4R+Pj8M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bgXRonsL;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35A474479A;
	Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 030B1C4AF10;
	Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788990578;
	bh=6HuWvLoHb9MNO+PA9l9yt6M3/Q2rdK1d/7u7hiJun5I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bgXRonsLBmo+3r3edVzKWawVGmlc46sX9f5rRe6VaUxuAApHtQq4YARMQUu59fslm
	 OUUg7lMUmYZKZ8+LrcvRzlUtezkOB3flJDaqyepF5PJCyx25ZGUqRZ1gFMG13trCcp
	 EmeMLwYyfq7zFNDo2TvvYIsvpO2RGRpoA4LUWHD/nBSl27rkwZ+h9WXuj3M8CZ63Gf
	 SXT0ipvQ01PE3nGf2i/ivU5ks0elO1UNYzDXEl8051LggWIyNqLyzC/3/bqidlONGF
	 dggYVCh131PTayhFHaxPefN3P8KMBLSObm7S+T9XirCdBDZyhl1uIwK4W7sceWrVtS
	 snAbk43WZoEKA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F01C88E40;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 09 Sep 2026 14:49:29 -0700
Subject: [PATCH v2 4/4] mm: hugetlb: Avoid re-allocating global
 reservations on region add failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hugetlb-subpool-always-track-used-v2-4-30c5d83b572a@google.com>
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
 linux-mm@kvack.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788990577; l=3199;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EoLqecRMxYnQilsAlZ6TRmi6EOz6fqVlkxDRkYXZEGk=;
 b=pn54b1X1S+6OXfUVQLwJl5j4qFJzOlrJTC968pEjDav5b3JyIY5oXTBnAPkDoWOqMP4ghK560
 lOxRYC1UM8FCni/NJJLHPTOLuS739e0OBT7fH7w+J2lRsFmvY3WNYZC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: kj36n69ciog9oays48g3ix9oqrpxx5gm
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B62218000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1788990579-827999
X-HE-Meta: U2FsdGVkX1+KbwaSbjUMfTUR9/B9ngEvXg0JOjVkm9huiTZrDhOOy7S2rGn544JZXHVmTw760SAO9WT7U5AjBGOGsySlI4piCx/bHjauDEVtG5smbKxzXlYOo+uQZehvqknqDMFZuHs2B/m/mtpbDM01Tl5w/961Js6Iuse9zOf86CHtRKnxZlD31SAL/I64gpRsDi+BJlBYFi7CQ7F4azdbl8ts3LkIrISE6tgSJ6jNA/kfr69iK3X87v9mKJE5RyTjmkyMxB0gLESuSX8UOGzHwpAGZZvGRoXVRcrf3nx2qssQuhrPvhLGIaRu3ijXcrnuooTbwBPj2tm8XB+qMrI9QcA2H+65KqEGeKO9i1G92Q66sfIHUqN7aOgBPiuV7u6v816aZ8XVH9ExXMnUhKpWzmOlPIC5/v0HncC+hPXia6SAPhf7y+O26ovmW92FqqPAlHCKcekhYyZ8B2moEigG97VWRhfwl+JJuMIEwdZxDiubhQQQLtBK12L1Frc3n5rOOuRhMr4T3Yivo+plQRmPxAH1osBV9uZnzIxmGDZWpDbR+PYbpynNMvCeA/EdJ2BNmhw66spwdOdR5WGDB0QA0+Vq+4h4ZeVWchKkQtk93zP8p5CUHucfSx92yM/J6mAk9k+xELP5nEDCjngXYeVEEg2RzN7/nqezs/XCajrAYFsPgmRsv98f4GV/ZAFPUdXBtBHQQ+iz5wg3N16IuEHlbzBXKgJr43w5LbVfzd2wnzGt75oj8Vn6Y1dxad+NVGvQxXsmCeuhopwhA6kLDWMkKNPS5AosvpohSK2e9RiKeYCGMER5tp/O8AVR3+hJL8y+T6kQXAmnSwKgjDdoo/y7hVJsUe6r6d9sB3ASet4xUcRwKlMxA6i+dRWNkV4GlXAqKfuhjTmhcC2PY0YU65V934ZrZdnpwbUDq61GCjwZO8v6beaJx1+Rob/ZOqNbvdUcXrJiYADlUKfiWT9
 ovtx5Fz4
 oG1eQ+sZsmD4HOV6TtwOZC1qtaW80ppz1BAtPA5HnQqG4bSd8GSa2SjGynB3JoR0SWQfmsIjUcj/7NVm3yBFx+RRV5CjE17aTOSR8WX6rSbcTdL3PW3dSDgaRUL29TQnBJg7iyiB0jgJPPORjVbJgGnVLLZz6hVZ8gaKPIPmHrEphjJ0CJ0kVTewn5SuEX4BVnFnr4FQGPq9HDSB2jDnN2FqSd0ZZ/P33MAXselKfi8x/jZ+SgcUkmJrYEQNJ1tormZfn74OQnn3JnM5SWogm4Clf3GchtbE/gX5LGriOeSiXHMmALYqIDKSK+I8KIRDKQQhl4369dxW61BqDBZB/512vNznSUrCAgqRWFtwRRkiiqnC7f+lKJt+tY0zjlcfHr1KHCMVE2xsf73EaNrOKIdx/jY5wT4Wo5u/J9pZdqXcpN1ALFD4QiLaQpO7Ww5UyIX+P5EXUkk51c8hE8XsN7PjgXZ+xHf8CiKae/UbVYM8wba0=
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
---
 mm/hugetlb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 652cfb55c6e6e..1151ad959ffd5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6678,6 +6678,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
+	long gbl_resv_accted = 0;
 	long regions_needed = 0;
 	long gbl_resv_get;
 	long gbl_resv_put;
@@ -6768,6 +6769,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	err = hugetlb_acct_memory(h, gbl_resv_get);
 	if (err < 0)
 		goto out_put_pages;
+	gbl_resv_accted = gbl_resv_get;
 
 	/*
 	 * Account for the reservations made. Shared mappings record regions
@@ -6784,7 +6786,6 @@ long hugetlb_reserve_pages(struct inode *inode,
 		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
 
 		if (unlikely(add < 0)) {
-			hugetlb_acct_memory(h, -gbl_resv_get);
 			err = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
@@ -6831,9 +6832,10 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * There may be a difference between the number of
 	 * reservations to consume and the number to restore now if
 	 * there are multiple threads interacting with the subpool -
-	 * restore the difference.
+	 * restore the difference, taking into account any global
+	 * reservations already acquired.
 	 */
-	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
+	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - gbl_resv_accted);
 
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),

-- 
2.55.0.1007.g17ff1f9808-goog



