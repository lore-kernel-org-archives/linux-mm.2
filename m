Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5867DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B59E6B00A7; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380476B00AD; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B8C6B00A7; Tue,  7 Jul 2026 16:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7C86B00AA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 623B11A057C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:20 +0000 (UTC)
X-FDA: 84963163320.10.9795432
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6BB9440008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBNMRtRM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457178;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1TS7iUwVlQ3ys8+sM4I17N9v7PKkuyu3987p/ity4Y=;
	b=e37+9jSZcqj7xenUtw7Odz2jnCfv2XjKdcWUYb5gl+NF0iA0OnaNqKaLC76V+X2k8dclst
	WgnUa/WOhqmvIBIKPufSCcsQUTjWhNHDwJWsYTJ+3gSsZdRUudyNuQ/5OgVvHcd3t5/OQ3
	yQHEqNbEglBQpcaRIZm8KUw81E1ZKQM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBNMRtRM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783457178;
	b=uzRTxGyBJfFIk4HopafMX3YDSRO5ZbK1iRcPWsRK7O0Cl8UoOk0khclQZPArzEvCyXu82b
	vqEo9RqufM1841dF8N56nUDAjl/XYDza7CelR6Ay675qk8OzvzDIW8jgbuHwBhB7vvfzPV
	8fFBEokSmVBAY/3vkx2jfVRXrYamOgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94B0D6136C;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 466C6C2BCFF;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783457177;
	bh=+0kuj1bG/SlCGtU90RU3Z+4wHYzXatUwjgJpAiL34Ng=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dBNMRtRM3esgz9pnFgibSTCLZmEmjDGAK9WRa7MJb36G+jj7Xf21lXdQM6yfTwD+f
	 k66oCSCQCh7C9aBtU7zcGojC3Q8uES6Ot8MBUwvqyYTc381vT2K3uBXW8BrW7b4JCm
	 d1LbrWFeCRDxmQymq/XxU7MDKJ0HY59CJBcv7L8536SUE19KZ/796qFrsMh8l6H/FK
	 d/gmGJ+tOeMg/EwVhika3ZVpBd/mIdoUXPhjFPYGruLxddJC5VblKcQWT2yve6Bwhw
	 MtIrFUCbR4cc6YiPSC0hYhrVv1BtxhAv+vXNOfQNXq8mm2CT4vn9bv3tubLcgTE6qB
	 OSXWJ+7i+Dj0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FFDC44506;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 07 Jul 2026 13:46:11 -0700
Subject: [PATCH 4/4] mm: hugetlb: Move memcg charge earlier to prevent
 reservation leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-hugetlb-alloc-failure-fixes-v1-4-5bbd3a4b836d@google.com>
References: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
In-Reply-To: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783457176; l=2702;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=byYmVafBqzJqhYJN9f0HauTLLeaXGUi0G31EyYblf3o=;
 b=LCCWWXJth+OA0REwYwzLBuY8O/lKZjNXSmDWNmT81I+NFmGnhEJ5SQsbNpo6kQIBhWeYFuVMV
 DdkSTRX873dB9r/qxv8pO0g7vNYeRSDdlMN2+qe4e1MoF21xRLxS0Oq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BB9440008
X-Stat-Signature: hb7rkqude8owo7kuox8fyup83o3obti1
X-HE-Tag: 1783457178-709326
X-HE-Meta: U2FsdGVkX18qeNSCMlbsuo6y7Sn5AGZABWRgURMnPv/Q/hcinCp5Y2hWbXhrbgqJ1UnYgOAmNXI7MkBd2DlKGPSS3mvUUky5t9DvTNRuUfdy+DJgQ9Ae/9Xg35biF3MaahZGdU3JQdlHpkFfWDaHJLTgyK7JvFnEBZKlDCuivzmUL7MKgnuB7CFKufo/W9uS5YEGLYpYWVBSobxWeAvOu/unMe1eViOixUUt7B0VOAtkO/9lzpqsmaUxZd87/vh9V9fp/iNnWcH7nCRFrGXbUBgl3WiK+4dtyzAPl3cSrMh1YnFRTaKILUO53N+KPupLwIZcdOSytV5cEOtjNi0SVshPLQdCS23tKduK1/1Ei1F5JbwOPsP6Spb0G/RVakhR30ZUIvQeNI6yaZPMYWDNNpVcy+ksYVGTuYxEDWjwNu0QYQ6hdDjzK9v/yY/0lCihZFglLuY3ZN4V7Tta8P8dA+ZwMNzmNrwo/K7aaGq0uYxvDcQWOaDVPN6Zlsg1hRVE5KoNd5/fnGD4DHRc5F8JKOfTfFPl0Qt9++dIVfTsp+mqhSnIgMQu5zKic5LTY8RMhAUJjxxd5GfM6N79VJ+0Xo6u3CgF/lGsDkciNwsUnR2EOzTmfRhCqWHzIl07Gm+yx1o5cGvN2mmFRUPQQLp2smNVHxOfbJRGgpd9PrCvbF8unwkJxDf68y8HG1aW1GAJIaquluLY2b1dsYBd93VtMeNjS4m+LRIsO7pdxumw3cdJ3JAsL6flNCpkXFrf9QUmyKWYL2gp6SKSjt75LPJKA20Sf+Fk7qrvFqlYEdsbLUrnphngjqc9IivhBBoPAciG8q1qI15GY03HDMiJTDBtfMRg5b5gR6qEf8OO77H8W0wDOvGV6Zu0IDVcjL8uYIWIuXOP30B1kSE5lNPkKkohp8HgiDNJtJvXTwANiNaZa3qew/Nj4aS9AZz0BfmBhqNCT0dj0Xd3Ba4GSE9QIo/
 qsHU1IyA
 VdXHwP9bPMgHZ1OyyesaPFGXhilOF2yulmz6G7v7J+fZyxGpoIgNoDoWMJ2sz1CiuPzeRBe5Vkk1KJusDgdWvo35h39KrPLyanF42MoXvYGk1qiFkesbODCTm/3nIiD4+R2TvIOtHZeHGRxFc9F9xuIK6sxUqkkFUWkv8KcZmm0wyUneA02/zSVMIf2TMO6DowM3qUzuBmDXGQTUHIoz/HWkRCmzG/O+1JRUv3lyKxYqxLnHBkEObjAz5iO5Uh1oSsoIL+VEfkhw7IDDKpHvIZlDrz0LoL/j+e2RMkWe5zFtsIaqNXAOq3PwV+BMnAgLb44s+JL7tLNvu5a8CPJRPj39TW0q1qluXRu38ksAxbSSHJixCDmCeuM7oDLpgWDinU7f1UUOJoQ08Mjg30X+lOCVtNw305bZvQd8WAp/Vor7aW3BeQA7yoLtLHqG8orpQxFyrKkkXLPjwx5xmyMuJ9GqJwjxiq+D8WHQmVY4NqZbin8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb() fails, alloc_hugetlb_folio() clears the
charges and frees the folio. The reservation committed via
vma_commit_reservation() was not undone, leaving the reservation map in an
inconsistent state, causing resv_huge_pages to leak when the process
exited.

Fix this by moving the mem_cgroup_charge_hugetlb() call earlier in
alloc_hugetlb_folio(), before vma_commit_reservation() is called.

If the charge fails now, the reservation is not yet committed. Jump to
out_subpool_put, which will then call vma_end_reservation() to abort the
reservation and keep the reservation map and resv_huge_pages counter
consistent.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e42049e2c038b..6e4acb1f021a5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2960,6 +2960,25 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	/*
+	 * Unconditionally increment NR_HUGETLB here. If it turns out that
+	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
+	 * decrement NR_HUGETLB.
+	 */
+	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+
+	if (ret == -ENOMEM) {
+		folio_put(folio);
+		/*
+		 * Charges to hugetlb_cgroup for usage and
+		 * reservations were already committed, so folio_put()
+		 * would have uncharged those. Go straight to undoing
+		 * subpool charges.
+		 */
+		goto out_subpool_put;
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -2987,19 +3006,6 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		}
 	}
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp);
-	/*
-	 * Unconditionally increment NR_HUGETLB here. If it turns out that
-	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-
-	if (ret == -ENOMEM) {
-		folio_put(folio);
-		goto err;
-	}
-
 	return folio;
 
 out_uncharge_cgroup:
@@ -3020,7 +3026,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_end_reservation:
 	if (map_chg != MAP_CHG_ENFORCED)
 		vma_end_reservation(h, vma, addr);
-err:
+
 	/*
 	 * Return -ENOSPC when this function fails to allocate or
 	 * charge a huge page. If a standard (PAGE_SIZE) page

-- 
2.55.0.795.g602f6c329a-goog



