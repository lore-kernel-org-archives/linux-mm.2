Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B586C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1916B0005; Tue, 14 Jul 2026 08:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8E36B009B; Tue, 14 Jul 2026 08:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF1A6B009E; Tue, 14 Jul 2026 08:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 331016B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:23:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B11FFA03E3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:51 +0000 (UTC)
X-FDA: 84987298662.29.4F0FBA3
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf12.hostedemail.com (Postfix) with ESMTP id D2CF740006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=UMSM7bM0;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WvTFl++y;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GcEUonScCMIbln7kBYbF9LX8Kk9u5y/6TLeXvuvHnZo=;
	b=GKxuL6vb3WE3e1lWWjoYV8W3yoVHDglB/27BJpWFxsFUQtF6SWGsXIMvREJsKhLMvHllDb
	gngVsuVy05/Lol8F7O3rxB82xACt0Og7MGfloASaxor8i5WamPjF+4ThlB8gS6qr++DHIJ
	pRe0EVv0Qe69J6uy+WWa2a68cUcnWgI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=UMSM7bM0;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WvTFl++y;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031829;
	b=Ea/jJt4EFWzZX1nH6Daj8SjqwB1nMH+nesuHsceNspaZbQOjQubwNh2ZGB9zdQAYk3eunB
	7miydkK3lNOzTcKw2j7nI7M+bFtDumJgP2HuglBhjotjvQoWYZDZvwL+WCvgvYhOzKIBLm
	8e3Jov8/3NQEzzrfM6zkZ/x4M2YRK40=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C081F7A00CE;
	Tue, 14 Jul 2026 08:23:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 14 Jul 2026 08:23:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm3; t=1784031828; x=1784118228; bh=GcEUonScCM
	Ibln7kBYbF9LX8Kk9u5y/6TLeXvuvHnZo=; b=UMSM7bM0a6qHriFn9FFJcolTvS
	+qR9pq+5XieWgQ/CgV6snSLM3/OtT0cgI+xV6yiVmVHj/tboBO8FlYa9BcAtB31p
	6aEC7JwyPhIAFdbdMSZ1cyGIdGb7zX25vC6wdMXKVJ55rGQdQ38IM0y6nkel7POc
	Y5kg5I+3GX9YASggJ6+Jpl7aBs5CpqoV6yHKLuYvljQDm2NP0ep3YED/mV8y8IEm
	HnCZTjso7KWv1324/1OZg+QMJk4yIu7o6gWwFJS6mpDF92coSe6Ijf83vF6y+lQJ
	2Bpzeoi+wYAfTlwDKLHBKzgZApw80WPIhZ4UOj26RktvtQYwVzc38NWdJUng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784031828; x=1784118228; bh=GcEUonScCMIbln7kBYbF9LX8Kk9u5y/6TLe
	XvuvHnZo=; b=WvTFl++yhAsI8QwR9XKY71PQ60EMItI1JTf3gESWVjSJTqlzewG
	IVaoYuwumOB3TF2kyoRLl+i8hK0SU2q5osa0OUAfM6Br6FYlGYTdXZ+szgE+CQ3w
	P+KAg0ESlwt3GGGo+Kvp6+dgDK8+yHdUplDVia66LD65mf0eyxC6eJ79loZ2pnna
	fgI0ZzYQuA+7Koc5AHrn/Fx9fX/+vS6saYDP4d3z+vqfy8m8Ka10NKMjLeHTDcKr
	+2igLe6Ht9loZC+tegb/wnTXRxCmzHvHKMIt15nzCpyFC/7Y6psTFJI82k2T10uh
	5ttXKwyDOqV0O8F5GhWVVWbPfRbJoZCSpPQ==
X-ME-Sender: <xms:UypWal1nfvMTemnF5Nw2vB6sAgv4Fp5MP9Qe8VgfAaiTYu1yFZkIaQ>
    <xme:UypWatcnho__ff3514z4q3QCms3Qu1FY6fX3QnyaHK_LxKMe88_rQ0J-7DjBrXbp_
    hUc0xWizhTrdHIed66-1bCOafcW4cXyLuZ3jF1LLYknTFjfC01eDQ>
X-ME-Received: <xmr:UypWavLf1GuDwl_ag6TLQBiioUB_3kyycrzJIw9M7JZvf0J-TkPWeKzq-_ZAiw>
X-ME-Proxy-Cause: dmFkZTEVgqz1oTO3zvUDX+PI3jtyBo3j51If/6iGAsRKaE+6O3X4TwjgcPlpLg6tPsDcOc
    fDrr8I8bXudZYHdFeCltTx9/N6biT525OE4MPAXcijUesuqj8OXGIaCUJHwfNDUk4vgUMz
    gzYz7Lu+2QCSywzOLLCPwq5XAAcgs9YOOIzlSzaiM6QdeDkRGV6UL7An8oLrrp1S4Lu7x0
    0L9aG5wQCzQZJWQjd+QT/psnlWbpuLBJxExJc/n9d91ImXVTcufe+cUGEPx3OlI/sTuIom
    UdADrS6MRSU0ZwcJK8ZTXWm0wyOjhBRwJRqPdmqhQx/9Mob/a5QezG7rad+0F83/Z+YNoz
    dDY9pumzS8Q8PB3Ok97b1ldJ9OZ9oLes4wtdJZt2DBXicdzH/ALoZo+j6kV/puCateD2aI
    fT97QbYD3pfDY06PS7KTHshmoAuzS6nDckcwqUu25nIL72QV/f0KqS39vimvtCbKoqtnGQ
    n3Sfz8VMwW3pD+KbzJfgKFu8bS5693IjQ611HDCDezrQZX1iok2yZaeU58P837fbz/RP4x
    1621nsF9J6I2Ww10M2/RrHKth6fIiQ7NJlwGdhqjOIbUtDM0xfveSGz6z12Ek+XIj1GKY/
    xcAwtOvm04oaninLKmi5FDkKXTWboyUvofaPwukM24DTxW3dwU25B87J1gsA
X-ME-Proxy: <xmx:UypWarF85X1uOSe23Zs7W4ZTsAnXv3aUM44kwNsIN12hy3iCYD5-vQ>
    <xmx:UypWau4mj09SEiHQgkIS2qVhNmHfHB4pGfzGLAHRbGrWAo8AlXkPkQ>
    <xmx:UypWau3EONmUxUlJiqos_xKHZCEn6BdU6be-zVGGj5Jf3mKdopOwYA>
    <xmx:UypWaigZhEAIqkmP7x7RPHhm0oMuvoteQ9myDuUVJ9wrjH2nzhPvXg>
    <xmx:VCpWasPkF9eqwFWBcs4W3ORrWNFnD4XHavKptX5_9YrafGGIyrIPX_NF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:23:46 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2 0/5] mm: fix inode UAF when splitting a file folio past EOF
Date: Tue, 14 Jul 2026 13:23:39 +0100
Message-ID: <20260714122344.351895-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2CF740006
X-Stat-Signature: sbxdps5mefn6m5rnn4piuc1iy359mw55
X-HE-Tag: 1784031829-944071
X-HE-Meta: U2FsdGVkX18OBXLHHWprU68pN4AKojNXK0sMAlGXL3lc77jNTytYawo+wKvY+K0wrUQTtoa/WwUxD1y3Bl+Cg1wFsu+yyd/8hwwxTZYqUa0g4GyeCwBJ7i4dCL+EfZsN241h4PNkles1+SqCI4UJSl9/oXoiPXVFKYQwO0VHCkwsoJSXtGbse66QCvsgG1FMpLK602qGkQLXMWYJkXdPeNo+/6e7Z5dl6UCpwrdzdWKPYetp54ZLUS7ZiVuAPmp1pwckdYDlxW5Q6xO7KjzZ4UTFeGRnDQppSuUfPZnE7/Ac84iMMewxlyTl6ubYSzSR1c/B8O5nJCPWqJ+jlcbxzlqiO+ILlcYsSPNZhD+lhuOZ38NPl/TgiCQ1iZWI5ve23w8OF304CaIiJS4HjhLV/61DlT4Y2T4DqEPs04YV6Iznwmm5dhia/9I76EoiY+fnJ4UqIEOHA/MuKxXYU2nLlPB3Wf4F8+3DE1OHTDGfLNwMF5w4WLTUAiBfOIhimv04HJrqF/W+7cpvjEBMaIhqGXH9srbtLp4eNtG4Qtil2G6bk4R7M1jDBemtflQwSutq3f6UjfjtNwN4DRdX+VacHC+TWrQMdfrxoIrN7wLKprhxVbHQktIxtdeke5Pymkn+QaqhHTdrmTEphneyK/Wik3ACiwZjikNzpTFiYMZVww+o7ZvlEzaNUxNpUwl5dyojDW9QE/IR8pyE0o2k2jTVblY5OdWeAUgWACmnU7M37BBdFwzfSNdQdqOfkjMl/D1m5Bum0rtKyXOgiZ1C5uWi+Vd6YQ3tjluAInnh7Zzu/D2vsxPLw/bdmwEMa84WKBPegzIg3rY7g7KAwyAfUEk5SAfzrwT5x0qLnTyovUmG3OanE+iCM56IMvWILrwJHwO1EfhnO8dKeYu3/xyvO7u03Qn/Lucyy1pyLQQL1T+CezHyXSYTAsLTcH63F6pZlv2oyzGdEBFAXX/QUAdmYCX
 uAU6X/jk
 vGYwPnlJ+9/wsvV3znPtweKR3/EeLQK8vWRl4Ht8aQDtY42Dyq9BrrdTjoouNmDYQS1M+3AFDk4DCd6+DYIPj1nGQj6iByl/oBU3ezVLZigRYkOi3UhDXe1L52qEj5jGtl5ivrs1TOoeXP/u6b51eKAsuTc3MYbtWdjuH3RpCsfBS4putn4/Up61UhG0si2dd/qXO7xygPc4d3xgLe9gQOfl4XHCAPJo7xaGKNnA28mKoHnTRxTOoBK7VZejf/ehDwp5+P4PBlEJPefQPyWqdfkkPoILtPzd4RGK+MV8ZrzUuMCybPj4+Km5x+KQknmCgJDjrk9NBGVlZwecOyPB5hJkHN+Xs9o/5uUjreFYOutvTE7jMeraL0GNeCwWmVqgSdBFrOA+CeRhwOZVMXl6vG5ZiglQNwKbSvYPQxEMP2mUB7T9Q/YnZS92XTyLaZ9+Oa4LJZncv1veuHKAYeYsFJlZjol1brk99vKHKRJYDgjVPYR8eoUCcKsh271QbtGHWpaFCBYjeaatQaPoGeMHMKtYReQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

This fixes a use-after-free of the inode in __folio_split(), reported by
Hao Zhang, and cleans up the split helpers the fix leaves unused.

The bug: __folio_split() keeps dereferencing folio->mapping after the
split (shmem_uncharge(), i_mmap_unlock_read()), relying on the locked
@lock_at folio staying in the page cache to hold off inode eviction.
memory_failure() splits at a poisoned *tail*, and when that tail is
beyond EOF the split drops it from the page cache yet still returns it
locked -- the inode pin is gone, and a racing final iput() can evict and
free the inode mid-split.

v1 [1] pinned the inode with igrab()/iput() inside __folio_split().
Sashiko pointed out that the iput() under the folio lock can
self-deadlock: if it drops the last reference, eviction blocks on the
very folio the caller still holds locked. Thanks!

v2 drops that approach for two smaller changes:

 - memory_failure() is the only caller that passed a tail as the split
   anchor. Patch 1 makes it lock and split at the head instead. The head
   is piece 0, which the beyond-EOF drop loop never removes, so it always
   stays in the page cache and keeps the inode pinned. This alone fixes
   the UAF.

 - Patch 2 makes the requirement explicit in __folio_split(): refuse the
   split with -EBUSY when the anchor is beyond EOF, so no future caller
   can reintroduce it. No refcounting, no lock reordering.

Both are tagged for stable; patch 1 comes first so patch 2's guard never
changes memory_failure() behaviour.

Patches 3-5 are cleanups (not for stable). Patch 1 leaves
split_huge_page_to_order() with no callers, and the audit found
can_split_folio() (dead) and split_folio_to_list_to_order() (only ever
called with a NULL list) alongside it. Remove/fold them.

Only compile- and boot-tested: I could confirm memory_failure() enters
__folio_split() with a tail anchor (the pattern patch 1 removes) and that
the fixed kernel is stable, but not land the exact UAF -- the race window
is narrow enough that my instrumentation could not open it reliably.

[1] https://lore.kernel.org/all/20260713170915.239819-1-kirill@shutemov.name

Kiryl Shutsemau (Meta) (5):
  mm/memory-failure: keep the folio, not the poisoned subpage, locked
    across split
  mm/huge_memory: refuse to split a file folio when the anchor is beyond
    EOF
  mm/huge_memory: remove unused split_huge_page_to_order()
  mm/huge_memory: remove unused can_split_folio()
  mm/huge_memory: fold split_folio_to_list_to_order() into
    split_folio_to_order()

 include/linux/huge_mm.h | 22 +---------------------
 mm/huge_memory.c        | 14 ++++++++++++++
 mm/memory-failure.c     | 13 ++++++++++---
 3 files changed, 25 insertions(+), 24 deletions(-)


base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.54.0


