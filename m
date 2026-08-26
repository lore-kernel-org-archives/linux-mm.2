Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE872C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 17:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E4A6B0088; Wed, 26 Aug 2026 13:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10456B008A; Wed, 26 Aug 2026 13:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFB66B008C; Wed, 26 Aug 2026 13:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCB56B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:54:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5108A1C0869
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:54:58 +0000 (UTC)
X-FDA: 85144171476.04.52408F4
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5211920006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:54:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a 6QD1hq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=j8c5MrpY;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787766896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bQByG0NGolsz8+a6PRUigbbsxEl5vWItJfVtq1Eax8=;
	b=1HaWM2QV2dMmF3bCdZ0MGo1zLK1LHnws+h4PTixOEv8N7f160/FmsGiK9Tfl72L7K8Fcdi
	b7GStgczEJtLKytPwmO8lwu8CWIKD9e9EuMsoby8xokzZUIVYO24Lro2M2t0uyL7ucf6z5
	zr7F9ktgm77QP2mmE09gEHO4K2j66pI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787766896;
	b=TzN+DTN/Ei6C0zyp97VKFI+Dei1aWJc+MUXa8h4kqsVuc6qx0sKOukCGNvlLrMnXX4SuM3
	LoKlDcnt3UuXp+lTOl15XFq/3JxXG4+6b0kWPll0AnIqMaGoBiWlhx8/10eNZ6e5h/VbHe
	cbZVCmHKHMWv0MirAhdEnzj1bLu7ckk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a 6QD1hq";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=j8c5MrpY;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id BB4CC13801D2;
	Wed, 26 Aug 2026 13:54:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 26 Aug 2026 13:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787766895; x=
	1787774095; bh=2bQByG0NGolsz8+a6PRUigbbsxEl5vWItJfVtq1Eax8=; b=a
	6QD1hq/hDLGcIi5UhcC8fZVJV/gg+lWo8Em4IgTDR0QqN0IFXBZHnw62SBzTRGxV
	+BCXpEVn54j4vZgW5s7oIDF/qun739IiHKx4mmfBJ7gjHzTA5sriBSbA7QavTHow
	lbcG7uQI9Cf2yN5vJjccrhVCfAtCPKHexiQili8X8eqhJY/owteJfkS2Mgn9CkS7
	PbjxDtnXu5SwWQhfOaFJxizWrGCXgoIuA+3o5aCZlcMiKq5cQHR8S5D2jJHt4TAb
	Uir06Hh8cTG73q9hTyWrS+cEX+dOA7ZAP9mobgm0e0ygOuSloW9CGt86gIGx/8zx
	SFbuNTPprs4o7y98T6UMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787766895; x=1787774095; bh=2bQByG0NGolsz8+a6PRUigbbsxEl5vWItJf
	Vtq1Eax8=; b=j8c5MrpYkaqkl0y05FNftCCFN2zIidZN/4k7tL3rELlkn0UeNv+
	eU4synikzCN9gL6KHsMGmdJ0X2dP0L0Khyalpxw8bLLPhHRs7CzMYxiPzXJdbwxY
	7LQ5LHCp6IamFhd1yYIz0nKrcMnGPSgCxbN41bqmWvNuFvwCdJtdUtK3mijnZQvU
	SqpfmK7mlY2b4i4MIzPLsi/wmhpMir8sAkhn9qs4TOn1lrQOwx2/jfRgEUmRVnV7
	GlXr3SZj6ejLjzCY31s2fgt0xdEcE38sBh0ybtc4iABad0Ss/u3WDSTzBHpx8j6H
	T3Fyu2AoyqgsGRhfKoUmwCtLG8wBkOFHYVg==
X-ME-Sender: <xms:biiPahpqMiPoDTkSxn218jcRh5GhsiXyaxrk3k2eVZxyp6g4JEGdMQ>
    <xme:biiPakEB1cI24gXsaAJ_ZTvF-iR4MgqqPruof3AH0tMG6mjMFTF9efu54mSMqrTuG
    Tox9m1P8Zz67ab5u2UoaGwT_78CHgDZ3Do6O2WGe0632DyC9oCJz5w>
X-ME-Received: <xmr:biiPavqEIIZA3npLSdQJk2IUboUKAaoLN4_vlPIF-MBQxF5VcrfseZA_UEQ>
X-ME-Proxy-Cause: dmFkZTE6xZzK4A32bGUNNPYnXM0UvfGGyn54u86/PwxKoHJcBoHd78FUBKy/v2DPmHJkl9
    z6yymj3dgIgVeStR7UbyVaUs+utRXUnAqYgVFAhnt52kgJZEi5ZQgcbmim5s3+aY6iT7hg
    RAzAXVXWBht8ryRB6o+Lm8WKU9830vEgS4QrvXQDSZi6bLXBuRR0KKNBpTFcUXCXrjZf+a
    SYib5WegN0Asn3j7LrTnbRG94rtanX/000SZQL7VLgr9r2NQkvxXVuBgkwL92yEkOLWxvc
    cWIu/MmaWbAfrHScydQFgzQcAAnuRtF1hgbqCpkqHznEpAuInIfxdkRyZO2Ae1fd3UQ/Jr
    Cv1D/cLBTQpEj9o/s0GrlLzWhnIWSM58LvFdoPhPalweAxhzVh8BJ22krLoJCfutihSKJF
    GtMyiEPEUikdd0udZaidPol5a9WPHZSgEABZEoxgnZX9ABVuBM1xrQsDc+Udjd/eM96Dx1
    xDPv9RvuGgpBfytZrjPZsaDWtNM4mJWYM7yAM5ukQJTadCGdAjjhiniqu9hxesSC+5Jkrq
    pa1niqNodDK4GOP566sFWLhT+/FKYr/w7WLX18J2IkmO9s0LzXZwUnm3+0tDws689cMwpu
    X/HVN05EaQY31jI8yA/Yvt2PRIfY4cGz7MZ8GP+0Tbzp/R6d7/3oFRyWMjnA
X-ME-Proxy: <xmx:biiPas5hdOI-hAWkJUBnpREq4LcAl_d0ZAJoDDQiBj_yPYtQTc5_IA>
    <xmx:biiPagQl5NLN6RnDvd52CuARJrrjrPd2VvT5dWIZo2gqhL2pTkmJsw>
    <xmx:biiPas6VoCR-shXK5WEbAb6YKiT_rfDZLbVwe_gPYXJbR0Q4ZTzpbA>
    <xmx:biiPai3vXJc0NvPk6-ISHeblxTysiG54VfQheJefcZY4zfRdtcJkaA>
    <xmx:byiPaoiTxPpmjY5QptMidWSgn1kC-CQECCM_aoaGoy_kZjwTPTydQRu0>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 13:54:53 -0400 (EDT)
Date: Wed, 26 Aug 2026 18:54:52 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: hughd@google.com, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 19/57] mm/collapse: install a PMD leaf as the
 terminal layer
Message-ID: <ao8jHveJqHegERGF@thinkstation>
References: <20260816224609.308019-20-kirill@shutemov.name>
 <20260825122354.98021-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825122354.98021-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5211920006
X-Stat-Signature: k8wg9m5u93te4dgh9sjiaab6u68rc6fi
X-HE-Tag: 1787766896-489664
X-HE-Meta: U2FsdGVkX1+YBWuVpTtyx7Gi6lBkSwpL2KfXL9suaFljfficNvMQXpoobG6PmwcGTd8yE/YPnAk+l/U0HaQdqnliHvv43a2Th87L8lnb69kH6/41ixLE9la5sQWpgasgwz3KXvzqBukZ1KMSEBy3uiC0UtwuSdXqA2OKnOLA0hIyR1fb+Rp3ZhQ7+erccUfvedwqgLQlVnggtOgQFzdrEtnMhnYtTqOOBKAro3e8J25zdJbFd2k1pU1TYYmIInM29uUeCzcYOr9sT8Ljr79eqNpz+rBl7arDMeWQYPrrqtATTxbceCjj60rgTNdDpvUd9HU4sClVP2+B5vRykygajtTbAKxaxo4jd6KS/z393UaNqFuW7DSqNlAknUiznxWF4z6tLE7FW2LYfF2LUEt45qDEgDIcnqbd4hGSkHSc/UgjPGkxiNbWEIgIaXuVMukjfMGmP5yeLnhxeY+5NDSLSCbFruUnzZ7eederGfnMFh7wABop0pq9ZDjJRhwgec5pLJjD7l4yz+oeArctj56Dqp/LeC6Xvs5RykGyUo+PW2PleW82SxHnmRx6v1hrd9X2zM1iHPzUKbSxrj9zKZZ/9n0tti6ykWCVcnVzHtYH02Pu0DEQHU+0PIbmbJPEnL6Ux3aJfa3CMd83Gd4u+K0kAXFMR5Z3BLkVf6hgd7rxJX1aZwQxNjAz4Mb890ijX3GPii3V4Idi1E9iBwg8+Hyl5r3UscprypFqT5iwPDbt2k5V1rA539lABMqAwyi1EH4cE/nnG9X8Yc1UQAjeRVLw+oVszbryt90Yk1uNDVAQBkt845pjgb5R8/ffIWFhZ6R8+rzPNg8k5E25kwflchZg+2OFTzRAUkkFyV51ATE5A/k9uks0DFTCK+4PzF7EyELz6y9ph8osGfP1RSgcPcm0RIU0U1mkgcciPZij9FsEzS5ZxqVhgAwkC6bv6baI3UM8/2boPQ0jKrSMHbwEnRR
 37MtNaeB
 xUV9ssb3N/pMFwXtkw5AYQtxEBsdJFBYKhsNodBqhLJs47rW6eJTtSEl+3dRxuHRsihUzgBZHeJpvaGoYClw5Siw2gOwmu/k0UCminFl2CnyfzaA857uL5PVoYd4T2TpIr2x5PVTL4YIQxTAZygC8Di41AL4o5r8fcofyEgr73iTC7pQnfnSahCO0zb8hniCR20BoxRgCJTOoy6cT2ICyQP8a3YTbfeP5aqAQ4OPvz0W6OX2daaD36lPOjhbkmRnZbm3z3JouVBwqtVBNDjpE+hw5UzjI3do4vdrp7/fzzVyadFtqWgT5YuK0tbsmwcMAzVPnWRcuFKvaBYsQ0EVAscbXJxDML1UX0xpqC+e/7aEfznwc+TY+AVAQqc70rsww11BWayiXeQRL/CiuPR058btmeg+h7GMBVOVmQDL7Hn2ug4V+kVRvGAyjYH3DAwbZH2AE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:23:54PM +0800, Lance Yang wrote:
> >The detached one is not: GUP-fast and RCU pte walks that read the old PMD
> >may still be inside it, and on broadcast-TLBI architectures the flush
> >expels nobody.  Quiescing it would need an IPI, which has nowhere to go
> >here -- outside the pmd lock it opens the pmd_none() window this design
> >does not have, inside it is a broadcast under a spinlock.  So the
> >detached table goes to pte_free_defer(), which holds the free until those
> >walkers finish.  One transient table page per PMD collapse is the cost.
> 
> Well, git history spells out why pmdp_get_lockless_sync() is needed here.

One more good catch, thanks!

> Could we keep pmdp_get_lockless_sync() right after pmdp_collapse_flush(),
> before map_anon_folio_pmd_nopf() (and while the locks are still held)?

Yes, I will put pmdp_get_lockless_sync() there.

Here's what I got to my tree:

      /*
       * Nothing fallible sits past here.  No anon_vma_lock_write either: rmap
       * walks on the sources are unreachable -- refcounts frozen, folio locks
       * held from freeze to putback -- non-rmap pte walkers see migration
       * entries, pmd-level observers see the old table or the leaf and never an
       * intermediate, and fork, mremap and munmap take a write lock where the
       * round holds a read lock.
       *
       * The flush inside pmdp_collapse_flush() is the round's second over this
       * range: the freeze displaced every leaf here and flushed before dropping
       * the ptl, and the verify above proved nothing has been mapped since.
       * What it covers is the paging-structure caches -- a CPU may still hold
       * the pmd-to-table link, for a table that is about to be freed -- which
       * is why the helper shoots down a pte range rather than a pmd.
       *
       * If pmd_t is too wide to load in one access, a lockless walker reads
       * it half at a time.  Such a walker holds interrupts off, so an
       * interrupt between two present values is what keeps it from assembling
       * halves of both; the flush above does not always send one.
       * pmdp_get_lockless_sync() does, and is an empty inline wherever the
       * entry loads atomically.
       */
      old_pmd = pmdp_collapse_flush(vma, cand->addr, pmd);
      pmdp_get_lockless_sync();
      old_table = pmd_pgtable(old_pmd);

      /*
       * The smp_wmb() in __folio_mark_uptodate() orders the copied data before
       * the install below publishes it.
       */
      __folio_mark_uptodate(cand->new_folio);

      /*
       * Deposit a freshly allocated table, not the one just detached: a
       * deposited table has to be quiescent, because whoever withdraws it frees
       * it immediately (zap_huge_pmd()) with nothing to hold a lockless walker
       * off first.  A table that has never been reachable is quiescent by
       * construction, which is why collapse_alloc() secured one.
       *
       * The detached table is not quiescent.  GUP-fast and RCU pte walks that
       * read the old PMD before pmdp_collapse_flush() may still be inside it,
       * and on broadcast-TLBI arches that flush expels nobody.  Quiescing it
       * would take an IPI in a pmd_none window, which this design does not
       * have.  So the table goes to pte_free_defer(), which holds the free
       * until those walkers finish, as retract_page_tables() does.  One
       * transient table page per PMD collapse is what that costs.
       */
      pgtable_trans_huge_deposit(mm, pmd, cand->deposit);
      map_anon_folio_pmd_nopf(cand->new_folio, pmd, vma, cand->addr);

Any objections?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

