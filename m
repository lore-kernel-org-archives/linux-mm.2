Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DC0B606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMoaa9mo
Received: by kanga.kvack.org (Postfix)
	id 3A72D6B05C4; Fri, 13 Nov 2026 16:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F046B05C5; Fri, 13 Nov 2026 16:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E0B6B05C6; Fri, 13 Nov 2026 16:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00C526B05C4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:46:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8171AA00EC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:32 +0000 (UTC)
X-FDA: 85431430224.16.EA5CCF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD3DB100008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMoaa9mo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWkPwjlZlK7x//RkTE3pY9k5+imno9JdLAaVgFYu5TA=;
	b=xngOfv5ZNPl0D6o1Kj1Hbqpu3HyeX+zzsVK+mnIkga/x+YcA2IT4ku4Hutf2y12SVPm80m
	bLjMR3ixU7KsRW21yIg35g4Ez0hYH4IeWDj1Wv8HNKx35+0LblDh2ahpTvnISx9Hk9ps7r
	NUyyPrOg/KYv3YqT+uJlUTUxLLpv/N8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606390;
	b=XG9FeRZ8e1Sguw030YzO9RRXKqTxQqB1WdoCiTgPotXAD9a3033FdM0DdIeaV0UlK9Oe0O
	l/agUJ4NZG9yGtqAHSTH1FuhW57ZPxuSmVyCLZSnONILUJ+hbEVJZhh7y+F+2EPLT4bcI/
	iuS6H4KGAT+weYrApYOCqvr09xqe/Is=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMoaa9mo;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2526C431E0;
	Fri, 13 Nov 2026 21:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79671F000C4;
	Fri, 13 Nov 2026 21:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606390;
	bh=XWkPwjlZlK7x//RkTE3pY9k5+imno9JdLAaVgFYu5TA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BMoaa9moDEQDEOfY/UeYTlxNutbvDD1ui+qvqyLzW99U7SkkmMYfzNEGLPAXLHqrA
	 cq4MauGAeWbBFSj/AsUIlgwXZtw0LQRWaL/zTm2FrQR5/m6WTi8bTEZ5pRoo9s6x8z
	 TjK9Dj/WatGpdH6zHNjTeA3ZF0XOAeY4bigstcF8nhDFdKVp1vaACaZgqNOCfag+Po
	 SRnzFIr9qD6nRuHvFPf19RMqwy5414rxAqS17dWPGlZRfTQtp2CdH4YgdTremKD7B1
	 0uprRUqjPW3rJTwEvKJFMxWzvXmnUslnqYa6P4WCPOZ5eHQNNQTTyWqbLX1NlDjl/Z
	 tgqeaA3kkghjQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:23 +0000
Subject: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2111; i=ljs@kernel.org;
 h=from:subject:message-id; bh=hNj08MXuSQv65gPbpH6iZuCoCEHUbgtpoDb4ETsvU7g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/yYKOHs4vPqXJ0mr8rdf40RM4UYPAu+uR01nLig5
 qL65Hy7jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExE2Zbhf9SPzOdfHv6prm1Q
 2jDxQIjhZHUll4ovJY8d3xdM3rByYgMjw4qVyaKeEaIzeX0f3Qli273zw6lHsivTI4J9J0eeim5
 y4gUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: h18xpztn4ujr8uq5w1bewynjtobuycs9
X-Rspamd-Queue-Id: AD3DB100008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606390-749620
X-HE-Meta: U2FsdGVkX191uirkPJqERxVSQKmZpuMP3/IxecK4oxfzLCHFR32Y+DpYivp4m5SGPUBFgvLKwNQ2CNq4bJWyInL50eAzczmpxn2+TEQpTUEKbXY4ReBkNctBa9iDkc/d9YkO5BcWJ+XM4ObCvOCj/wajGl5OXTPPpnW00nkfR0KCVYvL71D52EyM1I8h9JqDhnQkhEA1xGv7TplcgVT3NzxgLQ+7ZGqHEzXv8bScW4CA+wGQDMrLTyoT0Apxb7CbROnFrusw7QuaEQ56FGjxPdYFC5bDOoOKsCIaB/NYB02spPeAcj5ZMlPJZQvCObGQEMbOQOIgbbqFGppKMpVpLxBFTZuth1pC06v05UlcNf8P812KCXimk1GX32KmCS+Slx8Yv+5XeUfpuPh9a8xXAC4SvwVQzT7y8Y1OHWoYGHh85T7U3b0vtbKvrVZUrjH42ONccHKTImpE3aiIRo7MFqEDI/hu9wPM9LN8WmjUn1AYl2Mh8hhtSY3cCz4DDSdQhrqkH5tRdkSL2jX4Gzp/uiL6MTrmQgAobPdXs93PXzuvmwW9dGiQ1gOF0Un1LC6qzSPH3zMUH9NxXmKhJL2G6C4H4EkoHhpG+5aD1VGSMMTnkMRpUaf5uFH6lpGFTxTOcccosC+LIeDXd8N7RaajQSIagu1bZbcspRqSk3U88xaVXCOfz1aXEewd7FJZjvKCWFEc7nxWgpYYh34H1T/xxPm3S9at+WidCZJgXTWJKgorCjil2jVzCEO1vb6Ta5+dQLKFtU6rXQZFvONCFQb0fpGH7Pj+rkFgNYdc4emtTxkPIjfPvPOVoXznQcNCw26MamVhvg12nclqKxOhH0edvYTYb5LQ4GoE+w1+ND1tzEV5rfrCqAd8tgRHbd3vzJ/S27+lfCl49h9/GnsFoZYqXnARZAxQ8J+FO5NA5HQxZcjvZx3qYxakeEeFuhKsM6yFXFqHw6CJN5TCRaA2TuN
 yjQUdITO
 BNbzl++HT1cztxvP+0Gzt+rgVX40fIYStplWtab08ztogQkQBk38Q09KX2p+CrmlXugmQlqDpMuRqvznDTpb13OkmfXvIO47BUhEDKZJySzrAkmvhKYimw2Ux6IqB8+cvlKNxVwmCVL0HfAP7nugO1ugNDl+nh9UlxWKpIVmN7TCJ+w2VqVZrhKkkzkLA1GjxshZgIrnvb/mgklBvg8AxAegws9hp3tphdZRIW0GCv+b6hDB0lW4xfuJyzR5O80G+1OzPhRffo08uXScnUMWsgp2Osed3hpxtjSjP9vCKxncS04pK71jQI3HQym2u6e0+nOR5nWo2vOokYn5PE35AGVaKRs00Mty3Jb5KT1BeAmdRYxUfUvP2Afy56UJ8whZlSUDcoPcE+TDR1u8CtPLAEB+swH2M5SdcQfkNgtcFXxYEOShBz+DtUrhbJzpN3gB+L6EgxXNpwSyFnk0SCsyJoLKW4qR9aU8XN8O4XiZAoGup60s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

migrate_vma_collect_pmd() drops the page table lock to split a large folio
which it finds in the middle of a page table, and then starts over at the
"again" label. The entries for [start, addr) are in migrate->src[] and
migrate->dst[] by then.

While the page table lock is dropped the page table can go away, in which
case the restarted walk invokes migrate_vma_collect_huge_pmd(). However
this is passed start rather than addr, so [start, addr) is collected a
second time.

This can result in migrate->npages exceeding the number of pages the
caller asked for, and therefore in writes past the end of the
migrate->src[] and migrate->dst[] arrays.

Fix this by only handing over what has not yet been collected,
page-by-page, and flush the TLB for those entries which have been
previously replaced, similar to the other returns in the function.

Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ ljs: cleanup commit message ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/migrate_device.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e5dab8e1b77..28ed706109da 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	pte_t *ptep;
 
 again:
+	/* [start, addr) is collected if we get here after splitting a folio */
 	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
-		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
+		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
 
 		if (ret == -EAGAIN)
 			goto again;
-		if (ret == 0)
+		if (ret == 0) {
+			if (unmapped)
+				flush_tlb_range(walk->vma, start, end);
 			return 0;
+		}
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);

-- 
2.56.0


