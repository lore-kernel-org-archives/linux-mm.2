Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CD5606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mm/XhP7H
Received: by kanga.kvack.org (Postfix)
	id 27CD76B05B3; Sat, 31 Oct 2026 05:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254316B05B4; Sat, 31 Oct 2026 05:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149D86B05CD; Sat, 31 Oct 2026 05:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4F506B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:52:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7287FC0952
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:52:30 +0000 (UTC)
X-FDA: 85382456460.13.262D4BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90DBA140002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:52:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mm/XhP7H";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+XDhasxBREAHMJWaTnaRrbmO35vpS7TJxAQhlwiqYY=;
	b=U3vEXYoWKqTs0QEDUxE86qMsdXWQYrdzd+g71VVzFjdkowKZSPYSf22kkAnNxUQsU4Vz/K
	9S1DAvGcFU7NvKgsArcSkwdHVHX4tT/yh+7Vf5UINcDVdMloGivaW01BIjU49cV8oFM0Sz
	58/C4n0IgvSQOPcVFE/uyOfNdnztVFM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mm/XhP7H";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440348;
	b=FGw55VhIx5HMp/unJ/BHzwFETmfaOjMPRHwR44eSB/GINP60KJjbJxNfrCQ3G9Bxq3USoy
	4XRmsKlbLyIrpKuu3I6ToBgyUkf8VzEB+CAPekgD6lYtFMj3YTUKf2KnF6Zubj+yJpMEV4
	QQsK+uncYlotuCeqtqxFFUpZvs4pmSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C17EE4064C;
	Sat, 31 Oct 2026 09:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB401F000C1;
	Sat, 31 Oct 2026 09:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440347;
	bh=P+XDhasxBREAHMJWaTnaRrbmO35vpS7TJxAQhlwiqYY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mm/XhP7HPzo+iFoVllgXYlAnByRSGdmEmQ/9WKMRbKjP9gf3uokjKC5NnR5B3Ub/0
	 df3PiunpjyE567NZ1zBV+tZM/rAOyYte79fMgzRX8xb1Jw5+RRsKg9cba6L4fDpu4J
	 dbeRuNMuFh8XWCB3F2fTvLcoauM/ZmvDce60MDqxjOp4hjk75ZMWebupjRfd1ssHP3
	 RF1SriyTNMONJLj1srRxbt9Lj/xl7DWYcaVNvpp2N+phftZoU8/tH9J9wXRfuk02EY
	 OjKf5XK7hX1//dPKa46gIrs8/UpIGMlYMN5XKpuUgrJihaeRboayI8kWy1HZdnQrGU
	 oJnIAqua6PDFg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:16 +0100
Subject: [PATCH v3 47/47] fs/proc/task_mmu: refuse addresses beyond 32 bits
 on 32bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-47-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1750; i=david@kernel.org;
 h=from:subject:message-id; bh=d8AVCy95kfas+cJ7pSeAW9fI96TKmix6WWb4ARgBYj0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+uWlm2vM6eedFfrsPlmn5VRldO9lvIXFeflLt4m
 UjDL9sJHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykXYWR4eH/x/2/vSJVbgRt
 27d0zhqZ4nL5itJpMbbKUsv1G6dMymb4X93EcfrTp/qNqTE90isL4+W72IwZ/7uandbptO5xmr2
 PAQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90DBA140002
X-Stat-Signature: mkkhpexmkcofzsjf4j4q9dz5kpt4esbt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440348-714096
X-HE-Meta: U2FsdGVkX1//7rULx0cJXouRv/xMMlNcM1yt2VYfaC1EMVAqOJD8OC+gndvTydn+ei9MM50WWi4vd9K0dTihQM4BURCsBdDwL6rYwXCjcJ3aoSwkOrgqiLAHIGfPBsrJJhO1zS37JfXxgr7DA08E/EreO2/DsnElVp/OI49dTIkQvhxFb6Gh92/I/gjpNMkYAhdRb64XCZz4vC4bkHLtqXqb81rpXSLlLRSg3muXOSfTRoY9B5IyinX7cMQwA6YnLnebCbLf4SRrQw/l6HIjOzlur066XHXZ8ViZ8Cfj0QycUPB+n+ZUe8WFVUxFFjwGM0lCKW9xTo9YXnUhr+C04ummJHY92eyQT18e53zYIoslKypjrkUcMuTcmy8VEnvRaktBcwd0Gjem0ncyTeqG7I4V+L3qZX358AKKVXr5hbW5mFSkz81oRTEZvXqzim9CTqeGcUD5rG9TSXz9GZX7j5eTg7ojJ6tB5TpIZAnRgHNTvHrVzqf73rD2Amrd+pKAUffxxx+3AySnqpe0oJtdp4XmVSAbi5A4nhXG6eINTBGBCyevHQq/OqoL/1aYR/tLrZKGQNT8/O8xOUGHl+XV8luf0OnmS22sZbpnPN2HXj5hMoQQqw88xyfJzzraxg8wyA18JGxFGj7VwYD85uS0tHrgvVaiOExMVi+TV+me7vpG4kWJ8UMnEp+VQ2xhwggUYM7XU17lGFWnFNv3260c1uXXfHFPAXRtGBzo51P2JGiTRKCXWXZ36kZVMrpmA8LNZIoIDmiUIcuV6sSaJuw+SBzV4bWkyCv/z6jzlhvxxSGpr7TE2fOLZ5QaSp1brQj0P3lMYPBRBhqHRwsuwIBSkLRPTz8tZfZkXsyrzb0thqEI1nkce6zB1QJH9xjYECFbOc9xWqkYWLTTg/GYGCdDNTR931a46DXENKkzt2M8Fy3KRpp17d+7nSBgaYG0NZqOdy1b0TwWMoQrfKBPT3o
 9Ohu/u9J
 m0sh1PeSQotMGwmii02hSIMrI40RK7lKNXkg2+Dtx58yU+b9IfEa3w1IFjerqfb9MHh3Ips4Zu4uaRTcRDSC9TIgb8VhgON7bK4rnknjtJODSlIXnlFlRxVjlp01mqwLq5tlWeXyhtvIRx0jTRIavutFIGrlNF/MmE8deP37I1/R6bi3DyY+nQnS2TjUbYyTjBdTtIaEK4yK91/3orTVbElnN4umsvFm/7xxK1C+vwN2bEI2djaqqTHwiFuaWgCtehqx8vfw+fsa/L9od9qbLFjBIEfkx6X1mCNAicoZdvNzI8wdsG2ZbhPfcLo+EM+J3RufibYWQO4gFR2jrKGZ2CKDoYph/6YZwCGl8gv/83EHa8sKjNbIxg1mnJYEap34j3fEHch8U/f58zKZFGK5USUMr2zUY5BEUZZm4XGQwl9pAj51cRqBTma+DChD9gB2SxG8O/Gdi/4X+GNZCA8ALk03VtiRn1GW15hQKiXJ4h7BvTI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

The addresses in struct pm_scan_arg are 64 bits wide.  The first thing
pagemap_scan_get_args() does with them is to cast them to unsigned
long.  On a 32-bit kernel the upper half is dropped without a word:
PAGEMAP_SCAN of 0x100001000-0x100002000 scans, and with
PM_SCAN_WP_MATCHING write-protects, 0x1000-0x2000, stores the result
at the lower half of vec, and reports success.

Return -EFAULT, as for other addresses outside of the address space.

This is probably not worth CCing stable.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 7452b695fdaec..762b6dbb81e4a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3032,6 +3032,12 @@ static int pagemap_scan_get_args(struct pm_scan_arg *arg,
 	     arg->category_anyof_mask | arg->return_mask) & ~PM_SCAN_CATEGORIES)
 		return -EINVAL;
 
+	/* Don't cut 64-bit numbers down to addresses that happen to work. */
+	if (arg->start != (unsigned long)arg->start ||
+	    arg->end != (unsigned long)arg->end ||
+	    arg->vec != (unsigned long)arg->vec)
+		return -EFAULT;
+
 	arg->start = untagged_addr((unsigned long)arg->start);
 	arg->end = untagged_addr((unsigned long)arg->end);
 	arg->vec = untagged_addr((unsigned long)arg->vec);

-- 
2.43.0


