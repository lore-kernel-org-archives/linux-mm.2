Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1F2606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+9XM0dI
Received: by kanga.kvack.org (Postfix)
	id 51C366B05E7; Mon, 26 Oct 2026 19:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCBC6B05E8; Mon, 26 Oct 2026 19:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2A76B05E9; Mon, 26 Oct 2026 19:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9076B05E7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:27:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B761BA857F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:00 +0000 (UTC)
X-FDA: 85366365000.05.24AF5B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9C51120009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+9XM0dI;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyBvhh+qxm8IviEeyZzcz2JUI2QeD2dbSMePHEZqV6g=;
	b=r7RKx1GEav06C24YoBa8W7N7J5UDcpz+jLaXaS84ue7xtuEVR7dCOxlYPdNTzvufGiW0ep
	M38HJQt4jHL6Az+Zk2dijUCP1/huLMo6h4SQZ3kyLMRwC7H+qXMWVcH/0qDn2faUG7owAM
	fx8nNOUP3h3NPKyN7wrnFQZxIsTi910=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057219;
	b=Vli9YIm/rB1e4OKciFvak9AUBJtNO7pA5yWx83uRSODW8w3A9nqwl9lsuQHLaaydY8SKEt
	8UVyEq4H1NKNLJgbcKsdpjpmGPAHS0LflZyNsBwHtNrtxwAB70EcAyCZDRRMc+xeq09qLJ
	waeOaPWeDznYR/rV2Y3UALLr+lpjr74=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I+9XM0dI;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F3C5400F8;
	Mon, 26 Oct 2026 23:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BEB1F01828;
	Mon, 26 Oct 2026 23:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057218;
	bh=YyBvhh+qxm8IviEeyZzcz2JUI2QeD2dbSMePHEZqV6g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I+9XM0dIDhfLQ2IrtZ5HzQkq2PPp0DrM/8mAfIcMw64Ptq/qajsTS2DA7ZdMXfeBV
	 KzWRZNQLeE1HtCF7Z8+s0hifNhI+1Vb/Kt6BUn3Vzgl6a/5dx3x0sQc+O5SblrAtSz
	 +609RXnj1OExUGqYPa4rMeLnQrLnCkVpRmEgfst771GTthyyEI3P6b50QzcHCt5Inn
	 8aD6kz6gF+uAMC3YoWmHKMAIojnOGVgj0WTqcxRfcUio0DEXIBjwW9P6PVQau07EcY
	 ylPS2tKtf/f2VVVAyPiXJ/UuIahnYmRJjSvJza9HqLkBdFlMGdC78NMSHtXKSQfz7S
	 D5Vhc4PJLlP1Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:49 +0100
Subject: [PATCH 29/46] mm/mremap: use pudp_huge_get_and_clear() when moving
 huge PUDs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-29-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1206; i=david@kernel.org;
 h=from:subject:message-id; bh=cg7qBpNaGh8akN6A4ocFJLR+o1S7mJxz4pw8YGNdmxg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+2dMmjj5wJt/b/2rBVb8VCfdHGdoG7atodUvpiU
 579O/O/p6OUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJdL1i+MOvLx18KeX/IZmV
 AomWG35PMl3v83hldAmj3k4h2cZL35sZGZ59ZNuk6JnsFWOZJBjTdbvBWGBOhrf6ZQ1T04xI01P
 nWAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C51120009
X-Stat-Signature: s3qs46eq3zpr1a33oeowhqnc3ohkd6ac
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057219-718898
X-HE-Meta: U2FsdGVkX1+uuyEd0uzDNo07uXqeqDzSS0eNqnZBdHvzVbMCajm/0ECP4+P0JVTfvik89oG41boPedjNsv6iOHZ+E7M885ubFHcsEmX85CwXJIUCxesrT0GRcuvkNGT5Gl74bDsCxKuPia+LpXurPsguKR3ogyf6NADb7cvV9pwlY41Uo9oKSys0N5kWsNJenrYxAsxgzkY5ryC7o72SsrkiDcYJ1aR8fVBFsPwklEBjJfBOhRR+dKMhJwDJMpdn2/A0KIAHI3DXmkg8BU7u32B5NsNLVXztveNpEeSayBsB6Ook9tel5mlmLGJ4rClaNwSkgNjeeU98YYNPzFXIj3kgO61dvYx8fP2C8y2wd8yjYsqZCgUjEX7QI0OPVgw0eJUtfwM+hhoMOQpIP0QFtET+0kpWntbcYSc5saWT/yyXzUbON7idF0aBPmsF62b0F5wlARwVU/hcp89vRSr5Q2B2LXT/SbU4f0DsjkI88cVs89WWhMeZv5nVlu9ZkhtE2Jau+5bADQ8/WBRDwDhZQZrz0LgB9oQ56QhMDqOkFmoJ4of0co+hY0TY1EZP16an9Fo0SYSck7OFqZj0mII+q0vfzXH03Pc9hkrLcVBpSryfJldpwzCTqXBkDIvtjjN4ypPHMDP9WDu29ft9WEt4iF2AS6DsVgS94VAX2KTAMfXFCBQBIXG104S6JRr0AbKlA34sz12e8SvazB1v+3fNLNBZQmkZ8EPdBjlkSo087ulBPUBU84GKr9IB+AVEQU8qs1BLi2vXT7sZzO6QZGjXC/3vMz4kTdPIqVaMUwKor/+KvXUpzAB39YvMRtToc4ss7gSdT5u0bqJGpxnJw6upaCAaGEZOTtG70sVRelTwBJxQSuAZdeGKPKuuA9gXedqFf8C1OVxRcrgyRVWDNG5VJBYOUJ0rMug3Lu5uZlbUMIqG55yFc7qFdSGHcuoGPf9jSzwzz9PfDjhKA3fPm39
 XX7anIUb
 pZkW9NhaadCpLUC/T3sQXBMb2yM9YUXQu8BYT+8b0KmHmfYx7iDGn2syYxvo9KMstL3kkOY9crz8QWf06f1P0goDvabMB3KBf0DKTmX6MZn8gr9OPgKUw8+AVG0MJVqchCFTZHAcnz0bTHaPu8AWgEmwZ+syqV9gGvdPm0+5Jok/jQgTj49+lDwl8OixyV00Xdxd8O3tuZ53yXVdh14Ag1QhcTi2hNnMy6+HP6V8p8n/Nbqz1GWE7U5sN8rUdBqL2PkjjoRRT6pb8zUw+2FqmQi76tIhc5DMsD/fei2Qczb/I9+Xduo0aLq3fMMGNip0oHi0UqAwcqVSn5l5oGkbsnR6o0u0S3f3PtSYpYDaYA1bN1Tg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_huge_pud() reads the old PUD and clears it in separate operations.
Hardware accessed or dirty updates between those operations can be lost
when the saved entry is installed at the new address.

The raw pud_clear() also bypasses page_table_check_pud_clear(), while
set_pud_at() accounts for the destination mapping. This leaves the
checker counts unbalanced for mappings tracked by page table checking.

To fix it, simply use pudp_huge_get_and_clear().

Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19a..16e736c72d9cb 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -509,8 +509,7 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, pmc->old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 

-- 
2.43.0


