Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4313D109C024
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975436B0089; Wed, 25 Mar 2026 10:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926806B008A; Wed, 25 Mar 2026 10:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C026B0095; Wed, 25 Mar 2026 10:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 765CB6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:36:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F403C2E15
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:36:49 +0000 (UTC)
X-FDA: 84584836938.27.C6540EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77C73140013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:36:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ehl7K/4r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1s/oLbJCdbJG+H5bcsLc7QVlHnEEasfd6M2und9S9aM=;
	b=uQUEOdXynZYo64Fq4edBPzG5hsJ99esFFDXERmE1553y4+j+VraJCZF9ZixG+Tpj+E/hnr
	dR0fbFYCExN0V166Eayo0ZrD72TtB25H+5xdpH8O0bXspifWress1jIxJvy+xCF1vmL0ZH
	W0EF0iDnljh/ClvT2/SBEfeUoBlJHQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449407; a=rsa-sha256;
	cv=none;
	b=nQQlu3+c8LOzOJJKBFvjtHNjxDNNs/wzu4iBlmrxrusk2ufOxF6MoaI9SDFJXSsgb7cR2i
	sliewLMR22r2Tz7O98+r+LZn7D4UdTCPirlkLJZ+C+WPgMApi+JF37/VnWzc/aaQ0ys60B
	S7r+oFEqlY9Z5at8/dDqbiYBgXT+Rfc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ehl7K/4r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04532600C4;
	Wed, 25 Mar 2026 14:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29837C4CEF7;
	Wed, 25 Mar 2026 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774449406;
	bh=1s/oLbJCdbJG+H5bcsLc7QVlHnEEasfd6M2und9S9aM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ehl7K/4rE1asXxBnk+ljYExLi38p1QY5H3JQPyU3Dw1aVS7AlxcjALQupCiBIbhK7
	 1XwxolSPpD2kzFv8Ve62pYgU2ezvRA70PlVSHqhsrj57EqZf26UdWCt+ylLwstzzcj
	 mLAxBQf0BwgyX85q+y4HrWi0HolMOoyrhmhIDebh3oULdo5uid4NYYcdGGJIbXYYq+
	 b8Mdq17b/vt86HPndC0RdwQ26TSEnaW36fYjUJZj6xPEotLJD7x0DHO6L1MHOpTSqB
	 MaBWZPAmmlrmDBl1Wp3uz/Ww7A2eHC5s38FLk4pgAgHm3UsU6SvNS2cGdxjWInlyPr
	 Ir+GgF58W4yQQ==
Date: Wed, 25 Mar 2026 14:36:43 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
X-Rspamd-Queue-Id: 77C73140013
X-Stat-Signature: d7mdax4q74xso5bnnw9pqog8q1ebg7re
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774449407-339272
X-HE-Meta: U2FsdGVkX1939T7P+9aB/KWFaNbCrGCUDpd/fQEtsAgac4ROVjE3nx9c21ZRGrKq2iBzMBvxJhawO8pRlVnvhfNJKcCnR8TPL8jSv34N9rr08m7s36T0xPTOmhG+YMwHcsFG9OxbCJIggUjW9A3Eb86XqFpZh3R7quMkH8ot+i/uuwPSpyAbr8Iue113ka447wtMuxDTA00LikluocAk3NRPWA8V+yijylaS/rrjuD5L+rZb9qlZ1XHNJ0g2+w19sQiRk4nXZSiY+OPG4UpBmV5LpWPNty3qoh0qMvsac1xzn3EGTeUXE+0kMqTuxricqPdia/1VxqfC5UYB1pRvkSir0bIQ/cCv9co50fzVS2hkFUegYCUaJ58pqiEnX7EVR/0bETyd57soRhe3kAy+QsYbf7Utspk0GKsLzs7I4b9/lzUTMrzoQFc/geDXpwOGys7iI+52guULXthl9mF+qLXE6tA87GiOgRS+S3tK4dztUmnOqPYAcOYYcs1k7ng5PuaGxb0AyWxy71qBkyFc1V65rVhA7RIRxz5ZXLxvJgH1YAoa5bjUjF1zTu+tFkNAtp8TEzf36IF2Eja21+pCEJs25RJm9LvsOGeo6/FP6neY4jotvPS4d6oAcTcKV+Xr2zgFFvzYP6kiSLPaTSrPKavm9YKatY4jWcE2JwJ6yL73AahS0dsJ+6Z0XFBaruWuwSOebueodMHDDLvtQEO1yD0KH9LYYm6TVfAPaDvuxhH30DUgC7c+R8VYRcgv7v973bEEAkHFtqNW5kSgWSXh1L/SB4gy2zfOjKfGYe/OPinfWZTgS6m7ABfpJESijIh6GSvq9Wr5CoBfOFqAmZsp6vg3gEz5WnYxCd1hscH3SgqaDdA4Mcq38IyATR+MrH8PVVXZKqTwNMI5HKIWBFs0O5cKmRQcKEeodBFuCyB4arq3lIcJE4FjKhe3cSZMNuKEzPSjzPH7O60cXqQUGhT
 4+x7bBD0
 Zk50g8/tvgaR+Iw6et4Lel4TUhiwBwTraFq1X1axGHsEhUT/Tr+7/xKxLZX4JKO6P3pkv6v76DBw07rKmmeJqa7rKw+Z/8cbl32l3k77+1iGSTzgFnBpKZ5K28u5JqO7b90WtDfUOSpPQ5mwXm9a8MLzByl6S7LcVbzdpmTv9pMMhB7MbWat7oX+K6GV8zneTtQBe4kuO7Zs1prIFqHpbt1upc61L4sCcDgkv85g1QGvGUYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
> On 3/16/26 07:25, Baolin Wang wrote:
> >
> >
> > On 3/10/26 4:17 PM, David Hildenbrand (Arm) wrote:
> >> On 3/10/26 02:37, Baolin Wang wrote:
> >>>
> >>>
> >>>
> >>> I understand your point. I’m concerned that I can’t test this patch on
> >>> every architecture to validate the benefits. Anyway, let me try this on
> >>> my X86 machine first.
> >>
> >> In any case, please make that a follow-up patch :)
> >
> > Sure. However, after investigating RISC‑V and x86, I found that
> > ptep_clear_flush_young() does not flush the TLB on these architectures:
> >
> > int ptep_clear_flush_young(struct vm_area_struct *vma,
> >                unsigned long address, pte_t *ptep)
> > {
> >     /*
> >      * On x86 CPUs, clearing the accessed bit without a TLB flush
> >      * doesn't cause data corruption. [ It could cause incorrect
> >      * page aging and the (mistaken) reclaim of hot pages, but the
> >      * chance of that should be relatively low. ]
> >      *
> >      * So as a performance optimization don't flush the TLB when
> >      * clearing the accessed bit, it will eventually be flushed by
> >      * a context switch or a VM operation anyway. [ In the rare
> >      * event of it not getting flushed for a long time the delay
> >      * shouldn't really matter because there's no real memory
> >      * pressure for swapout to react to. ]
> >      */
> >     return ptep_test_and_clear_young(vma, address, ptep);
> > }
>
> You'd probably want an arch helper then, that tells you whether
> a flush_tlb_range() after ptep_test_and_clear_young() is required.
>
> Or some special flush_tlb_range() helper.
>
> I agree that it requires more work.

Sorry unclear here - does the series need more work or does a follow up patch
need more work?

As this is in mm-stable afaict.

Thanks, Lorenzo

>
> --
> Cheers,
>
> David

