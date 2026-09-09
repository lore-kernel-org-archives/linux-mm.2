Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D9BC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84216B009D; Wed,  9 Sep 2026 09:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AF86B009E; Wed,  9 Sep 2026 09:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998A96B009F; Wed,  9 Sep 2026 09:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 749396B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA73F160211
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:24 +0000 (UTC)
X-FDA: 85194318048.17.1928AF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0841110000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwklD36q;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfXJR6x8v03fXUe0TqSKHDJiGieSJgGhDryfxeyRA9M=;
	b=ZibvyvRKLzpBspL+1aEsi15ttJ0YUZ3YtJ3Ti5M3pcIDNh9WLqhmSvXL69appmKYo8mqWP
	k1USnuN9EFWy1nonpmq2yUDUU7GQ2UzLWegmNMLqMhK5dp5iTTQTLBwhLEDjPbJGKt3GJt
	2J7dXFr/Dl1CJ9j+SZsjpyEIUyjK4LM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960863;
	b=FjR+4lNkd/sXr9jwBHE/x8eYEry2Rx4VJfvWs8KCwmzVqzOqE5QwlbNHkpZ4QG7oKa+Yl5
	rOB8+GYJTUhPS1EdyzfkML8Svc0F/4yoSgPsLnMY5esCeF2nwMeDmkWuvxDJ3F0soFUVdr
	+Sr8+aVUIgdI/N0TN9EhoMkG4MQcORg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwklD36q;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59230413CC;
	Wed,  9 Sep 2026 13:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A141F00A3D;
	Wed,  9 Sep 2026 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960862;
	bh=wfXJR6x8v03fXUe0TqSKHDJiGieSJgGhDryfxeyRA9M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PwklD36qGjyYvFWApNCpE42qV3e3BOR2Kgo+jF5pn5Hgu//Dcgoq7Wm0kns9g21k8
	 ysL1SVlmIVtAuPqPttzOcHyVslyAAR/JaCZy6cXEpREMiKofKDuzHdP65D77cMfZcT
	 YixC8alIt/gUhMNsV8Kf563LegysoB1pqb1TEirBAYYW2igJPFScR4u61DqjA0zaVk
	 1ZutKHppQr1pIfljD22DLrSam3J9cYQ7Cu7mGLjZe6J4ByirBjg4gf1QOvSbzeUXXe
	 ydABST5FK+9hcfE1KgrhbZUqVmqaZQadLoEakZY8OCFoJBQZhq2FJUv+MH16EUVCEF
	 tYK2C8MitVVfA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:32:56 +0200
Subject: [PATCH 03/12] mm/sparse: move initialization of section metadata
 to sparse_metadata_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-3-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2420; i=david@kernel.org;
 h=from:subject:message-id; bh=f5vfO3saF7PVVCMfIchqE3Iy0rnVBSpES3AbK2/MfAc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJmjH7Uza+6Et22NRz/V4J2bhbw/eh/3xsNlWveUgt
 0nCVqaHHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExEwYThN9ssvqU62d2f3le9
 nfYr/OaM3bfvWay+ternsu2mjSrVCWUM/6wvHXtrcutno3dRlaqEZ5u6U0riDf6AOd+iFh+Okpi
 3iwsA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: pu1udwfqjaqcsmg9isoukqfu5gact7dd
X-Rspam-User: 
X-Rspamd-Queue-Id: 0841110000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1788960862-694126
X-HE-Meta: U2FsdGVkX18krMyp9XKXyXGwK3ltkCfPDiWlSngejHRgWDw+Ia+z+sr2bT5s7jqQcQjI9SW8MRgQAgg7KjRZYUFYzN8geTyxd5INhsLnuJ2JdR8v3uurmxQXJTZSSzZB6uQz0svV4s3jlyfZaYR9oUls0SIAzV6aJxW+I5CK9fwkPvXLUqpoPZnHOWXDVMPI8TADB4xfcleok5HrvSuCaeiNpZDGwzKdnZd4HFJq9CwjzDV4lyKcH8xC4xdXWfVPxh7kwlJ5xb7uexLFohAgSQBllQfuToBPikJlydb+FUIlCXgqcCiXhRq4lbY6Ig+q4IcoOMPYS/x8U/Uy8DPQbxcbF6ukX2SPyVRLzyRvERxoYRAnTMbNZ/HAGMmx/gWGqpq+/cpJsG/KMJzajp01XzQ1MqK7A/08arYsdkRk4JUpTGDAwcTHkpsR0+kcyak+C5q0qZBO9SeKd/7Xx/MVJkj5ph28k6aVVVYOUWI1b9avMTprhTgN5suw8vp3tk3jcDy5RMOPBCf3fLDqGMidAgsrVhveUCAOV7DPQ034+gzgqQa0unNGVLFDHsqpr4W/+qsBMy25vh9cXXY92LI0vkjoaQ3amFZskk/yws/ZxPwFK/z6yp3gnVzZxGv4Yqe5Hncj/an5HxR5nX7i/cQB1otnDI1lPDjYF4dCXAbvGOMON36zp/jbt5khRK9hDUWwOjh+teKZjDHjKIF9qMdNDQKLI7dQVxWSqa5KtGeTPnCIViVEaKm51dnt2RUJwaQG9BApWcImjmCFXuotuwSEu7lsbWrtjFNTaj/bK7+ruHbEGLz/BsH3tKaKSO+Yn2gxIjckGIgP5ltyKhHazTuz/poZuk5y21CaLe9EPFJW1b8jcXJj/g/zKG5bVMqdv753S7TMbVpuC+rBP8KKjEsyILXgN46k0qTQTUDfi23zrs7lYzggh1YyUT/IrI4WjbGIFuh26Z96emCuCNaQdBL
 pMVCb34c
 gJzqi91GTIdI7VWnS2mtCx3uLGAB1wWN0QPt4LiXr+yOWBBJHRz0xhyfjG6lDkYM5DOHbKxMOvVGm8sxUn0QAJAnCrf55eoNutkaDSEF8L4K5GDshCcz6rC5sRIZVP8LwGdQiByYxryiLAq37NIs+rjWfSYU2bLPDSq7zOV71HVAMq3egssECdrhiQJp/ebSvXrObE1wfY9w6LYkUwEKSXmBX4QcYFg95ViiSpnGWdMwbfQ+qvLjb2HY42BSdQoh6TzQi86PRRZMwy8UOdQNQN75pmF3K16nIZf/I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move the code responsible for initializing sparse metadata (usemap,
memmap) into a helper. Cleanup the variable while at it (e.g.,
"map_count").

Drop the rather obvious code comments.

No functional change intended.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 36e3d854febc5..a85a9c3840f6c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -257,38 +257,39 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	}
 }
 
+static void __init sparse_metadata_init(void)
+{
+	unsigned long start_section_nr = first_present_section_nr();
+	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
+	unsigned long section_nr, nr_sections = 1;
+
+	for_each_present_section_nr(start_section_nr + 1, section_nr) {
+		const int nid = sparse_early_nid(__nr_to_section(section_nr));
+
+		if (nid == nid_begin) {
+			nr_sections++;
+			continue;
+		}
+		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		nid_begin = nid;
+		start_section_nr = section_nr;
+		nr_sections = 1;
+	}
+	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
  */
 void __init sparse_init(void)
 {
-	unsigned long pnum_end, pnum_begin, map_count = 1;
-	int nid_begin;
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
 	}
 
-	pnum_begin = first_present_section_nr();
-	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
-
-	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
-		int nid = sparse_early_nid(__nr_to_section(pnum_end));
-
-		if (nid == nid_begin) {
-			map_count++;
-			continue;
-		}
-		/* Init node with sections in range [pnum_begin, pnum_end) */
-		sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
-		nid_begin = nid;
-		pnum_begin = pnum_end;
-		map_count = 1;
-	}
-	/* cover the last node */
-	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_metadata_init();
 	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }

-- 
2.43.0


