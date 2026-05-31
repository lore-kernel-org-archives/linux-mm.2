Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C468ECD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200F96B00E0; Sun, 31 May 2026 00:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B12B6B00E2; Sun, 31 May 2026 00:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0797F6B00E3; Sun, 31 May 2026 00:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6FDC6B00E0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:24:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A55E5140455
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:27 +0000 (UTC)
X-FDA: 84826423374.08.D68CF69
Received: from outbound.mr.icloud.com (mr-2006c-snip4-2.eps.apple.com [57.103.70.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id B513240007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=GnpxXBYw;
	spf=pass (imf04.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.70.5 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9h/Ynv08eT/7kBNC5M5hKRxLaGxANkcJA7nimD4RAY=;
	b=VFLZ/mKXJQbKfByJUpsf16uYEfxh0FsZGmufIoC5fN5Is1sHN3Ukua0ECP+fQFakzWJkZ8
	hREekGKE4cnfUX5RLlK7faZPOeBAxQEgQUd3gfYZDYd1d1KBDBcj+7w2kU9zX3dU1k+JEo
	IMIBA0wq+XGun4+ng9AbtMh1HnjGGy4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=GnpxXBYw;
	spf=pass (imf04.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.70.5 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201465; a=rsa-sha256;
	cv=none;
	b=P69vuzvXH2qnqkwh+T+GglLthHAwtfHssOf0IK0yT/3xyfAcwaJR7f73YKAAbhw4kvfVqg
	Fo8aNwrM9eyjBzz4IUJDaMaUzApxSzOd8m+fS75yBOC3Mv+rTWcVLnlEOl9JeKKEr1mBvY
	q+jm+n3mGKH7PPeHt6aVKDWIFjA8V9I=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPS id 600701800152;
	Sun, 31 May 2026 04:24:22 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9CFB0ECw8IAEAKTQVfBitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201464; x=1782793464; bh=t9h/Ynv08eT/7kBNC5M5hKRxLaGxANkcJA7nimD4RAY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=GnpxXBYwN4yqsrLNGVjVjc5BgfZVIVQP3ncDcxui9Kxz8GRsmF3D6OWe151oq+cV4k7tueJJiDy1gSz240wAAst2DUdXElpuPcJMuRnTSLf0Z5zZ+W/APuxzYd2Tx7ftj7y43OrG/rH2cyubtVh7x4CGWrtqEWvpGPl+C7C/whO4uNWJYotXN9CghsWfGPOWz/s9K9uXdeMnzho1wbSxK2YcLnPgwJH1hWGNWcorlg19vMONWznByCiPXUDvBba6U2iFR2HuGte89iNTkJn8p78NqOu7kQZ/g05MM6Qz6BIjFYdaPvw/89h6shjQH7Pr8z/EWwScNXDbllPvV4SVYQ==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPSA id 1F7B01800135;
	Sun, 31 May 2026 04:24:12 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:23:50 +0800
Subject: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-2-e7f8c2035621@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201432; l=2998;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=IK4miDrmdbabkQyFGW59A5b6GPx3fnGu+q5Q4xvrQwg=;
 b=qK5zrbTJtisyR+NW+EpEaQwvDavZnmZa7UsxawqaJ9Gzz12GKaYF9g3TSlb3B6/TtJzOpv92D
 8CanBl0VBhODOoEefC41u8Q8hPB70UYd5y2UeWlSzFOeMAHSkRpZQPF
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=AcS83nXG c=1 sm=1 tr=0 ts=6a1bb7f8
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=gYzHG_maUEIFqAho4fMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: B_25PpsYthx_2GB5CPRjr7NKC0y3rCcS
X-Proofpoint-GUID: B_25PpsYthx_2GB5CPRjr7NKC0y3rCcS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NSBTYWx0ZWRfXyiXca6Dkd1a7
 QOXxv9TE21ZnGWEUqm6vvV5dCUyPVy56XBSdu6nMYUQRIngFA5wOE8VK3hJEvuuXXiVbJeKLYdK
 dwk6GCWg9gE5JK10s7JghJI/YkIU4sfsbUuUYFwv2YdK2FhdY2LYu74h+Z5Kga2U6yKZrBKQes/
 /Rjsep2gxppbN9PF/q2m3wHVMMRpwQiT/OKXU2C4IT1bJIcg8eaYzfkjE52I3MhdVztoenVbufN
 naqzcFjBzM9icQVGB6QPfAISZEqt3phVcDXCQB9KrG1jZTAjJBcW6H6ubZF4ld2ddDkt5T1DIri
 62kekgwUd8PIi3ZKORzuB3Hdlb3+O43wV/LQ7tbVqnDjIZ4o6qyzxdXBd5m1LE=
X-Stat-Signature: nyhcojebrbtswuq4o9yqui1mkq3n55o3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B513240007
X-HE-Tag: 1780201465-924030
X-HE-Meta: U2FsdGVkX19yNbqJqPpHfa3hFvetl7MzjdbzSnhYtnXWba04xCU2HHr9L4JeFB10mP26BEeURBaGxptQEnBanZSWJF/48yZkWoyAq30nOPBs89WQXjw6c7VnNyAsMmGm9HpZsYuCCQ1ksxPGlNfpGXoGb5966d/Fx49SyXCEHyiKzrAnVdye2/kGc57nTKvm9I5hiKsz7NQFOCdhz4Z7rWGAROGKIqCol0mdeH2KDWJB2ieIPwnrc2AOunKw8hf1nRSgMN0xBJEcJVQpESPUmEG16njL19CN8QjMp4jbNc70Z14weqZW3igs6owQ2kLJkua6gxKifPfLau8xOMGHEF6rKqK5mD8a/JIBSHXtbheSfpP7IastZpDyioSz4YMSC+U0nlQ3Y7f9+MLA6caOVPAe4dvHdJhZ0MADQX+wuJMCqsxxSUKYRRKc+Iy7DauAq5EZQDQvub3v2YY+K58n40mXK2ZZkSoQkbNGWIzdj8QW7x2b/ad29/iYU8PV1HB2VdJs+K+Du+REXz+5lI1IGti1/wyYC2KK0iBMjhD1CVP1VnDf64ZNuOKH9eIKPmwOhElvIp61GLe08QvRDhZtyNhB10Ec29PYlgXn+TBf4wk+z2jE2v90rHLW+SUG0Mg2AD9ujW1CnaxOywOjx0xTv+LJ/5pt0nF01xI4AYXc0U7PRdT/nfFp4ppv2Vhe6Gy91Fk2yl6KW8pgAfA1t52ER5+TH2nqPXeV0ZoksP/qxtgD7LCGZlP8VAdbve8onIoXjhrPlBtQ2Pjw4tEgnt61/xBIYUf/bb67vDRjC3IONRNuYtvb3aATJiiKnN7z9EHnE2LWUe4F1EoHHzOupWEcleqAUW5JQR906IIM/P5BvzbKiUYoJNRmp4umSKg4Is69Vi3Or+tYM8tshAWz4C5u79DICu/CVrwPLwy/oBHZ+hcnuwzlfwHi6OhwY19ZMfdMqoFXzVIRjXgeXLSBReR
 3i5AsPMg
 GETeWha3wVQvqFltxlipISiNkKFK2G1RUIfISaWQpkgvGWLexnc3mebwnCXGM2x6JLhX/ChB2WrsdPmz4Dh2iMv7VFs28uWGXR33nhPnp3AQuSFYowr8rTUrLwTxK7z42kbrFqtrbplKHIvnzBGvPm7T/pLvqlJCgMXTV6v/tUIHTBpScwNWNhQH0eQ3q+GdsFUvxOVI32XgwHnzRyRtl6yxTFDG/slRlll6LUf19WJKOLQfMmolhyIL6aeh8yKMHJqcj9Q58wQe8wqqIQpJmL+Z7xqJ8oftM+tIyvr1UWCkpphnuwRCslD+xAPn2aqT9uRM1qLqHrfwtSsabiPZrGF9xHciAZmi0T1KWdlhstbjPNBohVQ+LHUXqzW8YryMkCC+yTfmTNK3gdqwQkMpkwxM9YpYLZWvHubTktjrtmhMOroc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

We added a kmem slab cached called collapse_hint_cache for
khugepaged collapse hint, to improve the performance in allocation
and freeing for the hint structs.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 mm/khugepaged.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5090ffae73f3..04cf85ea5557 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -98,6 +98,7 @@ static unsigned int khugepaged_max_ptes_shared __read_mostly;
 static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
+static struct kmem_cache *collapse_hint_cache __ro_after_init;
 
 #define KHUGEPAGED_PRIORITY_QUEUE_MAX_FAIL 10
 
@@ -555,6 +556,13 @@ int __init khugepaged_init(void)
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
+	collapse_hint_cache = KMEM_CACHE(khugepaged_collapse_hint, 0);
+	if (!collapse_hint_cache) {
+		kmem_cache_destroy(mm_slot_cache);
+		mm_slot_cache = NULL;
+		return -ENOMEM;
+	}
+
 	for (i = 0; i < NR_KHUGEPAGED_PRIORITY_LEVEL; i++)
 		INIT_LIST_HEAD(&khugepaged_priority_queue[i]);
 
@@ -569,6 +577,7 @@ int __init khugepaged_init(void)
 void __init khugepaged_destroy(void)
 {
 	kmem_cache_destroy(mm_slot_cache);
+	kmem_cache_destroy(collapse_hint_cache);
 }
 
 static inline int collapse_test_exit(struct mm_struct *mm)
@@ -686,7 +695,7 @@ static void khugepaged_release_collapse_hints(
 
 	list_for_each_entry_safe(hint, tmp, &req->hints, node) {
 		list_del(&hint->node);
-		kfree(hint);
+		kmem_cache_free(collapse_hint_cache, hint);
 	}
 }
 
@@ -3013,7 +3022,7 @@ void khugepaged_add_collapse_hint(struct mm_struct *mm,
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, mm))
 		return;
 
-	hint = kmalloc_obj(struct khugepaged_collapse_hint);
+	hint = kmem_cache_alloc(collapse_hint_cache, GFP_KERNEL);
 	if (!hint)
 		return;
 
@@ -3025,14 +3034,14 @@ void khugepaged_add_collapse_hint(struct mm_struct *mm,
 	 * just "best-effort" optimization.
 	 */
 	if (!spin_trylock(&khugepaged_mm_lock)) {
-		kfree(hint);
+		kmem_cache_free(collapse_hint_cache, hint);
 		return;
 	}
 
 	slot = mm_slot_lookup(mm_slots_hash, mm);
 	if (!slot) {
 		spin_unlock(&khugepaged_mm_lock);
-		kfree(hint);
+		kmem_cache_free(collapse_hint_cache, hint);
 		return;
 	}
 	khp_mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
@@ -3125,7 +3134,7 @@ static int collapse_scan_one_priority_entry(unsigned int progress_max,
 		addr = hint->address;
 
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
-			kfree(hint);
+			kmem_cache_free(collapse_hint_cache, hint);
 			break;
 		}
 
@@ -3149,7 +3158,7 @@ static int collapse_scan_one_priority_entry(unsigned int progress_max,
 		if (*result != SCAN_SUCCEED)
 			(*fail_count)++;
 skip_hint:
-		kfree(hint);
+		kmem_cache_free(collapse_hint_cache, hint);
 	}
 
 	if (!lock_dropped)

-- 
2.52.0


