Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4F5CD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3B56B00EA; Sun, 31 May 2026 00:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B4C6B00EC; Sun, 31 May 2026 00:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0C96B00ED; Sun, 31 May 2026 00:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17C9D6B00EA
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:28:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB6AE1C06A3
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:28:00 +0000 (UTC)
X-FDA: 84826432320.24.99FAC0B
Received: from outbound.mr.icloud.com (mr-2001l-snip4-11.eps.apple.com [57.103.68.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2700180005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:27:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RIb6NQoC;
	spf=pass (imf16.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.68.43 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9h/Ynv08eT/7kBNC5M5hKRxLaGxANkcJA7nimD4RAY=;
	b=EnnNu8J3X8ONqpAYs1pYg6SfYLs4ccFv2x9r8eOionE550qyg61Wik0SOAFQRUfxOFI+Gx
	SkvB3pCDSXDluwnIIHIFXyFrufHO1/2G9vpeDV42ksPBBUj97fIdM10bMjclg42UHCavNY
	FGrHe/2MduoZFlpGJl7fxt1eOfN3uWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201678; a=rsa-sha256;
	cv=none;
	b=8fTKOz7jlagnmmPr7FI9KQszPRH6Dvy1iapg8oEX+hmGrZR/ayZ1riggti/SfPNIEe3fdF
	7X7S6+MEnDFv7xnuushykW1mInctTADabidFCcrDa6niEjyiuMop4XgrdN0ZkBV4rgYISd
	GVnNH5SLDWztMJxxtD7fDxTWEvgx83g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=RIb6NQoC;
	spf=pass (imf16.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.68.43 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPS id 60997180013D;
	Sun, 31 May 2026 04:27:55 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9CFEAFWwRYCxNdTFBfVitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201678; x=1782793678; bh=t9h/Ynv08eT/7kBNC5M5hKRxLaGxANkcJA7nimD4RAY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=RIb6NQoCWqkSi9d8/57Seu80aFsgI8o7zbmXDvewzfEnKpyd4abxPqmg7JUvcEdPeF767vTiPvjSCZeC0jLxbYlklqg1bxTVQbyqKYETw/2poKWKh2iygi9MUxcuDdGVxms9DL8EN1ugB8CFZOxRk72ep4WXzlvPmTCIP6taHUKVWgmXKwHbhLEfy7Fibr220vL8ZE7LGcwJrrc3yXqw+EgrnSloUvBKfdgXLQSXvMICfXS+cytRgClkr66gQtfqWnwgl91KHwUr8NB9alxHX/rZr7xC+DRvoZgHdccCionoq3Ohsx0BHMnmIGOitW3batTBjAKjd7gSxlQNaoS6+Q==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-4 (Postfix) with ESMTPSA id 472341800114;
	Sun, 31 May 2026 04:27:44 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:27:18 +0800
Subject: [PATCH 2/5] mm/khugepaged: use slab cache instead of normal
 kmalloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-2-866339cd4c2a@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-866339cd4c2a@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201643; l=2998;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=IK4miDrmdbabkQyFGW59A5b6GPx3fnGu+q5Q4xvrQwg=;
 b=25BP/QidmIIMdY6i6uWSXAANFJ6EHVM+SNF76MvPHXem3VllQIhb9Nvnq+lwJnpu0kI7vaE5S
 3jx0hHZdCprDk+Lb0G+7XRUQnZJiFQTPMntsOsR0LRastmpEfON1GBL
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: Lk8E2F88_Z5a2ahnBfM5agzJL3mWuPqD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NiBTYWx0ZWRfX/80evBJfXAM+
 q1w3c3bdQEPP8SHCaqi28rjymeG/kLhpf+OaZxD6rrTOd2gtH49AwAaK9fXPb0/gR0Ua8lIzYOQ
 hLKm23YnwH4rawxd/vQfCxDyqd6AE/AeoV2PCvHo7fyiORbalzRRKsfXxzTXIzVRLGYk7pNCIDY
 emMAS+Cn8bqJn9ieuAvaZGftx84yGga7r22ii9weVkjhnFfPb0g/TYTi9ZVQm4fHtffI3Ghs3/1
 Zwlq5S2gjQ8w4C4XdRNQj49drENXSBeEJgCgOiyAOWuRgGHsU3KFJIayYKX4dBcLLIdCGuF4TQZ
 CwiWsEtOOCNcCLyh7DuUnR1xNiHJgqD/MXlZTPExUHcHtBJA1A+gN9PDm0WjYI=
X-Proofpoint-ORIG-GUID: Lk8E2F88_Z5a2ahnBfM5agzJL3mWuPqD
X-Authority-Info-Out: v=2.4 cv=H57WAuYi c=1 sm=1 tr=0 ts=6a1bb8cd
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=gYzHG_maUEIFqAho4fMA:9 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: C2700180005
X-Stat-Signature: ojj4w4zjwpjihdz6z9cr75mqaazixqec
X-Rspamd-Server: rspam06
X-HE-Tag: 1780201678-419373
X-HE-Meta: U2FsdGVkX18HmvdRGeINoe0Ss0sU83PJ+SIto6JlgLhijMzNnBttRBAZFgnhrsqeXwzlB0adto+/PBbz9r+PB4RYXA4auXEyM8lKJcB4wF1N4I1rPFlXF+VrZxX7Cz8LmNd4HzJzPt+dmavG1ZCQHEJ2y8VYSaT74WwVRQmhUuOHSkt4ETrYGfLTP/NNiFVFOYJ25x/oSNWNfvRJQAMB1GgYhNu6SCkio2eDH8RfnSMV0N/6GXzlecYnQgdzhgKVx5KuHSmHsMcy82t6Gk7qKwyAC2xLbeIvIw6LXK6mbP/FZZDBH5r/aF031/VWKOnGvLiV/pm4WLbJq7pZpK0/JRf+VK9q+hMlxxg/lih8SyiN5lane0UEtF56qdmYFRXvmXpPeTPl9PD8lYdpEeBHp6xdZo2fjwI+AT/5ZxO+hbOcwf5hI/7ZXMB0mqUndToankp8NBFMhCmSA+CnYf9CGx2zqAYhlGryhLOFmeWkUJRfSYMTseJxBCZjTAnOFBe4uzf7XXuyotg+a+MySk36M8HbheBXiDRGDCmHvRWfzAM41VYEkio0JXRNfb1BLvz62jJiwhGTtZGR31wS6yHkn5Um/ionjdT+EZq2wi2QpVxcd4Zwv24EkpvrAUKz32ZoRbSqx6s+oCkH4LKSfjjkYe8QaFeFDnVnNFG6J3sKOYTfmuEFXJ54RY2apSfIfLW59SXPvEkS8AIOkq5b6YPZyUuhGcd8WUNyXmHiAlH3RuD/oV1AI41DGuVD60TLSPY6knsQyf1OSNROVQWjovOOQkMmnFqkn8XfXEjThLTyrP0oISC37+pcw9bvTOiSbLFcnFH/w7n/To1slXZOPHRtArw6uZobvuUJABZgCSrsxZKo6OCQl2MjS3hxNWyOI4KkCZPc22bUFJSfkCI1BYEQq3NPr5G24c0FLHk/PfWBVRtpt6r5ptpLB6QxcXWqr5VhRaCMpjijQHzKknXCYwW
 BC9u08bE
 DuILTHxAh2oHcZ3loQiVHHBDmZizD6HtnCqejBOUNy+sFFr+ZDzhfFcHbvFeerFckLvoEAEOwiajY+EJeeMX4RVTYPZfsfO5woGt7Rqn4zN8ELqs6ntme9r1k2zjw+N95kuD/9PXr1WdhVRWEY4Bxprm1DpgvBavSbuAmxJs/JF+Yx4B7Bk4K4JrOYVRTBUTWeygENV3mReV3tBoUuILm5JAgNODvHaCn934hefn2E7fpL98ddPIF9Xx1jq+1iPVasxe5b51eMAfjT34ok+iW2xGn8huyvVQslj2JCJsuL2MeILuk1uvF/tPlFPUhkKM/9zzZR8EnwvVDVoxev8ziq6n0bmKI7e/WE81s6lsjrLc7OAt7fatyhXtntV0McKwa4InzVuTc/9w4WrhOcubA/t2IRK9z66MbshhZMXG1lJ5nJum0EOl0ow0uDg==
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


