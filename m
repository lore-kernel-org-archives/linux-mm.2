Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02BDA606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IaCWaKaw
Received: by kanga.kvack.org (Postfix)
	id 1B79D6B05BF; Sat, 31 Oct 2026 05:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160796B05C0; Sat, 31 Oct 2026 05:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028716B05DD; Sat, 31 Oct 2026 05:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D41D16B05BF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:47:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E7791408CC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:47:19 +0000 (UTC)
X-FDA: 85382443398.25.106D8CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8367040003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:47:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaCWaKaw;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440037;
	b=TVKOWkv1vucfm5IxBOinLSXJKv4pfKq8mvlfV0wKrojUtzqeAQ9wx+vMFCMd7N7WOtw9lh
	3mrqowXPWRqxRqpqNEe49HSSinjtQwpIvfns4d5lsu4+iwFEd2Z3q6Igj0XdGR1/6RTDX5
	02tJfSfX16oguDtRnBWS2K+dBrfy25I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaCWaKaw;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVrdbHh4TefzyeW1e6RlSzEhzIhMK50yL/X3kkZm6/4=;
	b=HCveir7mesp/XnnnmdmFPH6smE+Ww0XQeSudgyEAAMloRDPlUp+Jy6T0/VcjcbKJbecWnR
	RaeJqBlVxWBFnwHsbR8fGfyvM7470hiHd13epht8O4hKpRUovrvs6iDL7YTGPHqioQ/s74
	Il600fszUvmIvjrjVSFsQpkLAH7TmO4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECB7B605CF;
	Sat, 31 Oct 2026 09:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FC01F00919;
	Sat, 31 Oct 2026 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440036;
	bh=KVrdbHh4TefzyeW1e6RlSzEhzIhMK50yL/X3kkZm6/4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IaCWaKawXOqDcZ22xFCnwg7umYwYJDgAbJNOOK5GTEKGHR4Bx9Acayri7plzIv2dF
	 0xsaLS7xr4ETWZusdZHXrFhdvJbU1AhSTCPEA0QR3Dj1ccFkxelrbwXMWTOnrQQWG3
	 58kyNmdrL4h4kMvLnIkpzCrckrID/LCj0Cf5LWhtYMlVhaHMgI1lgO/M9mXJT3I+oS
	 Z2xhPUc1AK103gnGCePYltjzgbzdLKcT6Hk2CY7ZOOT3q1CY+nRSeutkrRUi7hRWeR
	 F8JX7Cij2PkVFNeFOQbrbxnEdvAY1cKNFIxVfTTwYaHRhB/a7xn+bEQBXPQJM9W6rl
	 g/T9m03kc4kGQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:56 +0100
Subject: [PATCH v3 27/47] mm/mmu_gather: fix flushing ranges with 4 GiB or
 larger
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-27-d6437171ecc3@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 SJ Park <sj@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2186; i=david@kernel.org;
 h=from:subject:message-id; bh=XMqAbJynrW+dSeh468tky7AqZSEZvUJFOrLi82qkd/w=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+Q9csy471kdl/JWJJ57iLLuN+/Dm83vFRrH99oc
 7pyn8zijlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbifp2R4daLlSYBH/m0hd89
 6zgm/f7UvRPHexf3Ppv+3PCr3TX9iQqMDGs2JfTrdpm2nXv/RPP2W62itX1MireabfWCQlf+3vo
 olh8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ao5tzoitc7zs6z5xc3nha3i1ufq8o9eh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8367040003
X-Rspam-User: 
X-HE-Tag: 1793440037-79174
X-HE-Meta: U2FsdGVkX1/a8ju6ggoYX6qxsgZ4D+U6ivN9HWE+NuD9IDXauYWYIRASjKxZNuE13mJwiH0AJMHLf8rPv5rLLaOQBOz2bgCodIpejKpRBunBjwNXCL1Sv+vp5KPrbOIPnwck2tsuWhEyvy0IJHT58nGLLGCG2l1UpF7EWsvZ5omMTGS4zO01lVRfr/0qY0q/ceAHbaOxMsbidMGnKIqnCYkp7hlUBO+HH52PjbzuIGCfgA8MZNy9zQ9wiRPSu1uPK0x8geeaZoIPW0+q4YTSXW9445kLDRi5l1wq5D1BZ8N4pGoapHueHdJznDKKI+PCLB2u2vEAoDwMrMUpRE/XNflv3RpsXWkXLiEAiojihnNCAHRqQqIXYrMwsefD6Ke87GxqWY71wd2tR7ZdtsbnvoodK9XKbQ2C2mEKOJxQml+HoaVoFGjYoGRs1FyF0aK0/XOuQ0wF+dwFux36nWx/+0tRyPTtrtA9HGOWL3tdm4uTIhkEIw4GeKhwL4m3hBKbnW5zi9s6mje6n0ayiB85+zqxIyrVyVtIWLpfSyv5RFZoNwJEzhlpHDXJXlYq0bqX1tpjyBPmlBflmuiMjlClAH5jDAvc7vuBw+Bbd+X1ZWnqfxljIlX/jcmNbEB8o2sVwmp+T2MQHJ9zY8odJyFr/8wgiWtEa9McIM+0bgSApNArv1xXlHOCbirORY9ob0zTYpNlVb/xRUjKiIM/75YOU5tvryJtkVkdKjmn50kvD1C9vOXj8ffY3Q2VUIUUDm2zSwGkuvRn430LPvqUAro8LsRga0or1lpopC/lFlfWdqDoy8GwL0YKRl9DPbrsVfn8zCK5A6HXaguMOgfy6p78N7PLAovzawDyxpqre0r1ztdbu/LELuS82Z5siO0ei7E+EQzXXiOrNJoWOfwcDgiEzKtUZY6Ap1ywV7fjg/sIivRKtcsJTAyLNQQ55HIa3RkurVob6v3SPbqL+N4oex3
 AwszRv5C
 hkC04moYcQXCIwYdsJ/+W6e+GNeht8OVHm8TjxklgN+0/ngyqY+ywiMDlM+XZnjkouIPwvzApSoS9zzCRVRXbgGMUot5obTjGzNDoxazp5/AEyjPNLwUP6FH+0RUL8g/pUlzsvd+UxMHiRTWl8M5ZKIp9nIUUVyA8k+HyzQsRuvEKvsIpMkZYbFYTzS/0bK8rPKHvQI6ZoX8zhtYC/SwEKNWftbcXOecTUhK5ccZWeR6D11XkvUBpjacXPM60gfKhdVnijqEZGCowN+712MRJ5CQCZBAWYAeJ0wg37SgKfKGkwSsIimKFT0leWm91fZNmq4NLVCyesH44G61HlbshMkKbLQEOJmFQFgSIInaG2hz+CyP0auyoudtywffBw/pZAEPLwrmGG34J+4B/SxzXwJUGFcvseZPLuOwdfsePu2vHZguSjfTe2dsjkIil46JWOTw6d6mqsCd14qJo/QaGOrlrVSfluoy5tuaMvVvdyLY5MEhIQVZYtiPD1noHyZGi1d9167H1wIAEOwBMxGr03UhGlR3i6aqbimxi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

__tlb_adjust_range() takes the size of the range which has to be flushed
as an unsigned int. Its callers, tlb_flush_{pte,pmd,pud,p4d}_range(), get
and pass an unsigned long. Consequently, a range that is 4 GiB or larger
gets truncated, possibly to 0.

On arm64 with hugetlb, a 64k kernel can have 16 GiB hugetlb folios
mapped contiguously at the PMD level and flush them when unmapping, and a
16k kernel can flush 64 GiB PUDs through tlb_unshare_pmd_ptdesc(). So
at least these two scenarios are affected.

Fix it by flushing the proper range instead of the truncated one by
properly using "unsigned long" for range_size.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: b528e4b6405b ("mm/hugetlb: add tlb_remove_hugetlb_entry for handling hugetlb pages")
Fixes: 8ce720d5bd91 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: use two-tab indent, simplify description ]
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: SJ Park <sj@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index fbe1114e9a443..3f4a180b48f3c 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -350,8 +350,7 @@ struct mmu_gather {
 void tlb_flush_mmu(struct mmu_gather *tlb);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
-				      unsigned long address,
-				      unsigned int range_size)
+		unsigned long address, unsigned long range_size)
 {
 	tlb->start = min(tlb->start, address);
 	tlb->end = max(tlb->end, address + range_size);

-- 
2.43.0


