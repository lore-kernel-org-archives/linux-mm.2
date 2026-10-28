Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01871606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=wkN1Gghj;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=gLG33pWn
Received: by kanga.kvack.org (Postfix)
	id 03ACA6B05B4; Wed, 28 Oct 2026 09:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2E5C6B05B5; Wed, 28 Oct 2026 09:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DED6B05B6; Wed, 28 Oct 2026 09:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B54D26B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:26:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8970380C83
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:26:49 +0000 (UTC)
X-FDA: 85372110138.29.0E9E28A
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73BEB80004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:26:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=wkN1Gghj;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=gLG33pWn;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+BFs+a/yE1nGxZn4Kjy6BKUgF7WYUxZLCCRtW2ZfPxQ=;
	b=joIuR/EoJsySNtWwXrAvLMXPce7YYsczpIur0LrAunBR+gIUKVJ945PnIOhFROOwL6AmcX
	Qfx/Qy9T9uuGnsUdGxth95ryOUuD1IKxBeK0bVbXNyxBGG6VDNcrM1KwX/SJZIrfUB36bZ
	sgBzBng2Mu1zKg2PWi29VhI97EXnyLc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=wkN1Gghj;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=gLG33pWn;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194007;
	b=5a0cn3B6dLRiCqBRCcpw75ZZn3REmy7TMmkMnRxoaLttelfqygYvl3y/wWS5llkWF6DG8g
	vyXODFQZe1XhgfxDRaC2/C+QH7RhFd0tun2rslQj6eLUGdPg3lccomJ+yW5HWDIJpyMdsM
	Hb8K1V6Vfu+LCjWy20x86p8546XuiwM=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id C276C1301F21
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:26:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 28 Oct 2026 09:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1793194002; x=1793201202; bh=+BFs+a/yE1
	nGxZn4Kjy6BKUgF7WYUxZLCCRtW2ZfPxQ=; b=wkN1GghjUOU4F4acB0AlmTxl9y
	0yTt40b5LpRv1IyQGrVBq74PpASjIFdep+ZW7S3LJLWeFMUKLbEGhi4tbHrIhan6
	8m2B5+pPfBHbGy/wLHj4N72PD3/jmpFAwwNGj+KnzrH47v//J+jU7ZxbjoNCFjmf
	W78IuDxHnF8oamkmDgwzPjIM1aG0JXSAswPCIXlrKaVz9QfWBZmRDnt9sa+QXs7G
	XlZCD3qHDOQewi+uhmVZ3EEyGarE0GuQrHWQLuTbF9aNVa4hE4szZbNX1/1QvVZz
	R8fyNUl18KNiynR31x0WF05dO2NUVOYfUSmU/PIukqCE++4AvxyxfOpYutMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793194002; x=1793201202; bh=+BFs+a/yE1nGxZn4Kjy6BKUgF7WYUxZLCCR
	tW2ZfPxQ=; b=gLG33pWn6C0LwRfwWzVPftPrqGRWt8oTxgRUePOlvzQjP3EBTd+
	yaYsql3MmCYDEw6Ldth6Cb9tvvfBbKpnLBMRuYyw2cY4Cm+ooXXlPrkRBpTougBE
	7CfEA9JEvvJFumr4M+ND64wlDL6nqNF0khpFIQIjLsF5vGbhwWojy4scPi6qnY0G
	Ary069WMvbNWIaEsgebfBWkp2jWnX6YiKPrrXOult7iWuOVMzjWZKU+RiJ4/eK/0
	Vqac9yzvOmDQVQpc3GUyhXRXSXegMkI02NWTs65VcEE83B3FoapqvjpsqtbSdx5h
	HjAvuuMqU9C1uP8Hqkm6oifyPqzt7FH817w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793194002; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:XnSLn73nhVp10eaOFH0PQ2D6i4DIL4VBaiMWW7wm87egMmI
	YhTfSs21z582neICkLZKANS8qBO+tTEhjPxY+r2IEJT/SxkP+T61Kec15OC1on9K
	+mVubA/TaMS4Ht2EDTkFoNtX64xlsghGICq/kdsSP9mpufUEcB6UrGzztvZy2SYd
	MMRjPvQn7gWJ2A1PzebKw/2IwDmWVz7u8uk2rjQxz8MDIujpDsMhxkLRIQy/RYlt
	3MAymlSpxZtnyo4bpeZsaIOaQ5MIL7Wlujh9sOg22bN45VFr6+JVsuifEjDdN5JP
	NIUbX9mkuZdj8MC9tWP7jltSZlGCNWhvOtYZJNA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:CH1tYYxykiIv1RLbCWw0YN5CssjwRZjejHr3tQ/GpnI=:VtQAXVOylUEgwRm//tK+opODqw4nrYRdQrF2wdKvBdw=;
X-ME-Sender: <xms:Efjhanh5htqG8JCU2f6tlaAll2oSa5FQV43VKyS3wwu5906H23CzuA>
    <xme:EfjhalE_tM76h_E6ctMoTrbM7yWwIevZXFIlB3juK4oczo3kYcSrTViNG6U6vmO_l
    PrMJWCdeNxDCJXRskufFlJ25zO8h3Y_4SIxZXkonu807FGNwVFrdzWy>
X-ME-Received: <xmr:EfjhaqCQ1cZIO6mEoFmJXasBaAttfK1ApobCMb2e_9Lc5iZP-xNBxOa1fbI>
X-ME-Proxy-Cause: dmFkZTFyZBkhzb8SJ3YurTz98jXoxrAYOSV6yvJXRkVCXWaX1UL6gXkfeoPA0eMvF1lpuQ
    YBehhHfXX0goLqnZWpor4J+CA9nfDYcgen9bxZLNA4gZVNkJzFVOOYyecKuMf0KPmk/WLy
    JABIbxkhX9UHWkNp64tDUxgce9NDeYLNxymsnr8Hh/OzuhGF2+slL7brGNrL9pr1t2ELvK
    XsBOqImIT0qtCqdOBMOFTTZ61MmNHlUFJ/kzF0URLFhZauZ2pkQvlIuvuOnUxfrNMU7a+N
    UcHWrfGWxTSLefU7DxGYs3ZV3tYCoVKxGG9z3HTf9uDp77sbcc4ixgm/1kZT21IhPjp+Fp
    8KnC6XRNhS4bo7kA/muidgelZi4875pDDSYiPyQ/Zn+/DOTX0BqdD/43iWaz+jAyqlPn8w
    k1UJ66hPG69/KHz7e8K4GQJ2bOP+g8rV2N8WDJ4RaA4sJpWliaD3mQeYqlfjmLZ9HStiyZ
    XZyln2pmhbhaWSrEa00xpS/NJV69LYKv97pV/bsYUqlWf8mx5qaKLgOtldY/pSb1rMO9JE
    xheZTQ+DJiOFlKvo8SuDpV52pauwIBMufdYOYB/RzDOYWaSla8oYBYoyU75bLXG0KUxZeY
    iroLB1cSjbkH0PCOx7ZNOKrqKZBXQpk1d8aQ1M9XsaZVdy7ggqVxdKtOqr2g
X-ME-Proxy: <xmx:Efjhah-aOO9V4alyJtpFxuAMfr2KObqtG90118qB0jwL4ttCRd6Ltg>
    <xmx:Efjhatg0dspY4E5rJ8jB8YMbvhqRgAiMn6tmC0Vcgd6Amcg8IhKPGA>
    <xmx:EfjhaqYoM9m0ohZrCVp0Zn1AjGAP2AW2GUo935TLng69la39mpqKtw>
    <xmx:EfjhavTKGQkS-Eb9aKaipRWkzgrOYsM8tNCx1t_HmgPb_CaBNajTog>
    <xmx:Evjhai3mtA0pM0HaRzlpwvsJbhZTC7pjdW4PIa6myL1YwZeWqStRDh-0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 09:26:40 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/3] mm: make watermark checks honour ALLOC_NOFRAGMENT
Date: Wed, 28 Oct 2026 13:26:34 +0000
Message-ID: <20261028132638.2560361-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73BEB80004
X-Stat-Signature: hoqz3skirt3btwwb6ikxo17takg5wxpx
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793194007-593780
X-HE-Meta: U2FsdGVkX1/HPUHJ2YkEBNrFt+JRCCto6AzhTqIXg+Y5mxVqQFOqwk6p8IRF47+/9qDD1FivQw3XACUrrP7KNliuq7uPkxVXyQ+8K6ipeEQooHBpE7RWO0gNy+FgxsXQrsKu3sReF6iDdLPsT/++PjZeNYORQWrQ0m+C0VfEQwih8uOaJ3LdcNbPLvxF5OxYalK2C4dB5lv41+ZxOse0KEjTV9tvFuvXcAvbBm8LtYoey4ncfmJikGiij5vJCFIsWFlHFpfHI60Mhm/F8FT+EPA+4VCSLirsmyVRhCuwqqo/PbQCiA1BdVwBl0EFeGd2jTzPKgeAuTuKKBQIZ77jgZC1cqu5gfvh2AAWmA/NroQvhyKtrA6feCDqSw/WLMmVRT8sLZucgP9xqe6GkPmf8Fqvaqk1kOUx/de0L/3p1COX2mTuMcWed+ABKFq/BGuycxE6KsjWWVCPvRWUOpngjDFP4V6Xs51b74CUNaRuNYJ6PPDYa3XcAraMNO0CXPDFSTHsjJSZ+DBtOeRbKW2WckdNl4u4Bj/HTVUkKKZm6+4AVdaacbZfQ6toAnKneQnIyaVleXoALuMMlEv8pRf6pNNrNrJOKEZ8phKIonaFrlMLRutgLG1KmVi+T9g8UVGWnIvnf4r4H40pm9bv/bJqkM97TcseF2h0xRSzjdi4PAPs+Wr11as6F/cJJJ3A4xlPmdz2g676NDVu5sPYhtp5cexdQBWMI51bTLhCpJGgXx8/pL93pHIhvYgZ03gCVLN3q6e5uomdLUR76vJmDJWZnigUfqBYpqXPpsvgVXB7PgNu2uiaaBFbFIKmmaeVKY2Hnqh/kc1+9wYZA+secKa3HLhG+RUX3oAcFPur4j5rT/4K9pvRXwnqBOIBa9fU2Zbp4Z2/FFxi4o0VqJqQxmhVDWMOJFYxscy4fyKgYh+YruYGjjXFPLZlPe/WNMfZTQRiK5E+ppCY8Kvk9UalQY4
 as44fp4W
 Zcllmv/+pdDWhaCJLKcAgT2w0go/71GoYwkr9hvgzOkXxSanRY+Rf5Q2MR4GcPshrHZ8EJwmy1bcMb+1AgnZ6MHmpQiw6aHdn8lHpZq+tM1/FgtDlFK4iVZqKxov/lJF+UIGS+VPgoh0ORh0D55o2Mpqy7bWh4K0A83FLK6HORWbzCk6bKInoNJnqDshvDmYrFjOOX6HvjjGwyN/I5uyCR043kiKTDoRPMNSmQwrHx9EJH2vSzav97CBUzAhZVaP5+8jZ8GAGORtT1saltr1NVrTVNfV8q3MOIxuYDo6QSFR6WZOPH894Gh3oukNrFhDeq1BEcWkOovSftdlbW1kKELPeEHzhpZNd9AP+E41U8YOoTTIKFiMmTmmEx8vbPJeHEtKSO71AMXhGFaPyxdXTmBtQP/nC2F2LGnpiWEs7KCTOPLxKjzDYp88XZdvqLzeIf63MNAgQxp9DCX/NyHFhZ2Q8VSLIBKACDFUuB576nE4RwsIB4OQFMy5Q/a8+0OUnjpaHg9r1013fRd6UApvQd1mTIGxKV7NiV3NXFDpAwXIhqSHCVMVWfwUFjr61kgpNGYr5PFIov4a/2mAbuMYL4valHl1/Q26YQtm0dzjuo+y4ipLYlSzjAm7HEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

With defrag_mode, 64K mTHP faults under memory pressure stall in
compaction 18 times as often as without it, and get about a third of the
folios.  Dev Jain reported it [1].

The high-order watermark check counts free pages of every migratetype.
With defrag_mode, every slowpath allocation is ALLOC_NOFRAGMENT, and a
request below pageblock_order cannot take free pages from another
migratetype's pageblock.  Under pressure, that is where the large free
pages end up.  Two callers act on the wrong answer:

  - direct compaction's up-front check returns COMPACT_SUCCESS without
    compacting, so compaction is never deferred;
  - direct reclaim for a costly order stops early, having freed little.

Patches 1-2 give the check the request's migratetype and make it skip
the free lists the request cannot take.  Patch 3 tells direct reclaim
that the allocation is ALLOC_NOFRAGMENT.

Dev's benchmark in a 7G VM with only 64K mTHP enabled, medians of 15
runs:

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + series
    compact_stall                      1690          30669          7366
    64K faults allocated              20750           7391         20129
    64K faults falling back to 4K       725          13832          1339

defrag_mode=1 still compacts more than defrag_mode=0: by design, it
keeps 64K faults out of unmovable and reclaimable pageblocks [2].
defrag_mode=0 is unchanged: 20698 64K faults allocated with the series.

[1] https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
[2] https://lore.kernel.org/all/auCDnqJc7fsBpUW2@thinkstation/

Kiryl Shutsemau (Meta) (3):
  mm: page_alloc: add a watermark check that knows the migratetype
  mm: page_alloc: make the high-order watermark check honour
    ALLOC_NOFRAGMENT
  mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT

 include/linux/mmzone.h |  3 --
 mm/compaction.c        | 16 +++++++----
 mm/internal.h          | 10 ++++++-
 mm/page_alloc.c        | 64 +++++++++++++++++++++++++++++++++---------
 mm/vmscan.c            | 24 ++++++++++++----
 5 files changed, 89 insertions(+), 28 deletions(-)


base-commit: d865f2677c44cb2171b833d6775cf692756fa8be
-- 
2.54.0


