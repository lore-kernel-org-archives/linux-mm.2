Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3620CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435E26B00BD; Thu, 21 May 2026 10:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E176B00BE; Thu, 21 May 2026 10:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324736B00BF; Thu, 21 May 2026 10:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3466B00BD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:32:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD583C2321
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:32:11 +0000 (UTC)
X-FDA: 84791666862.27.A9C429E
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id A619D180014
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:32:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GZo8YbXX;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373929; a=rsa-sha256;
	cv=none;
	b=ui2xrSIsbGllZn4tNlD/+Be8o1i1SuBmF9HWoUPn6KbT3k2knK3CAOEEhNU/lTgvvTydpe
	bfW4oP/CBd1QZ4Ag++08nkh8EuZc6O7c+WaDUArtNflBHOaz+rjQ2PhftXVMNTacRkG/Rn
	4eMZF+AUI8juKpmcTNYeUJSHg7n3opg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GZo8YbXX;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373929;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0vl66cywBbtX7Nq9bJ38nsMuWAs11zIu+JbOH0/xPI=;
	b=dGtech75T3YQl6KFd7nUM/HStWVZLZ7Uvmqm9np+vCWr2FranXPyngB1VR8sk6P6hiME+/
	qUXt1ammxhDi4q4GZScxZ5RTZK2L/vViQ7CT28GChpmesZix+NwHq/TflcZb4mqNKEsiTa
	4ynhvF8ARS9VFPmEUhuhTtrsZQQTJRo=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bdbcc6c4500so173838066b.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 07:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779373928; x=1779978728; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0vl66cywBbtX7Nq9bJ38nsMuWAs11zIu+JbOH0/xPI=;
        b=GZo8YbXXIlN9guJ2R6lRSSsnEZF3MhUyePqdGV/Z4W7gZJJxTCl1wIoZ1YnH/pT57z
         uf4rkmrsQ6iQoj17AYzTK8Dh6mr76InNyjqdLXrh8/t0tjas5J8ym8e9HeL0PRpOB0yc
         zGLSmnNkuZIzhCmSC/6qH4N4Il3aoGEjhSabiim2STp9K7S+Qgw25y8WBdhpISFYOAXw
         ybrN4wxEBtkBltkcfHnCTHBuugoHBHI/WajsiA2ZRF0aidmreHVweHy8iM9QjpxojbMm
         GmVc2RpkphbwtlWOerY+qiz8Fn7KS57yc16I4bJ7XIKrtaO1FMdTsfFjElrfyGnvUPkY
         cJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373928; x=1779978728;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L0vl66cywBbtX7Nq9bJ38nsMuWAs11zIu+JbOH0/xPI=;
        b=c7V7gs1FUcN9XY8D6WPVX6mK8xAWlw+rk5odbElCZWeN6aHsUzIUQS7kvb2RS4e3A9
         mdNsBxPXBt3kqFtIrrgzpqY80mzIjD9sl8BKdiXuJAEN+FOvCnoc/cUIijxHtCJqVz+O
         JzIHSZbkfXXqM/dq4dFDgkux69+bI7CEzoQcmjqtgb15qceF1k0Gdn22HsdAF25QLG2n
         DBH2H+VEzhHD2ULrSMk4Tcm82hGvxfnWmjc5QWzKaH1ndTuy+bugf6E0VVrH6dqecgoM
         2182XtD755P+hAeHKiuBF6p1o6Uz4xZ4ntiwN1KaO5mepu3K3rYu4wh0AamkdGi9Nos2
         93yA==
X-Forwarded-Encrypted: i=1; AFNElJ+qBSHDktGi1ORt4yA5a+ULuWJmwno0H28WnI89wH2Fww0rw0MMqbrabzy4Nr3Hbc74O6y2/SK+gA==@kvack.org
X-Gm-Message-State: AOJu0YxKRuVRPv7NZJLBe3abBAHDB+ClChFo9HvLAwgC0KtmF/kIqpdw
	89jBsInMGahnJ3ZJHQapBop8OWO3piPnWuSqkj6jEe7s3g0KVEmUV/2q
X-Gm-Gg: Acq92OEOMPOzJGy9cH9H983QHdBIOQOPf8loDJB/RvtxS5xIthTmoyWIvDJjStsDXfp
	wXQPRNECM7n5SyZTGpkTXKV9RflxJgFogsASBdtI/TEQojyBglvhfBBUubNaYxTaTowijGBjT7j
	wNJtsh96dl8C0ruEwvbZaBJCnN+SjXu3rtfIMZEqHDMz1b9n3dn1TCPF15eZ4OkyYqgPRKk55rE
	QeqnPpO5C3ZBLiKwZIfJ9vdy05yr8Wka0/oBOtFhuA6xD1lX5hie/v1kQ7hj0WiPP7kl3lRDpb2
	Jgy5PwTR9+ziqjskw18e41oMYwNU81jC4URq2AMJ/72VwwV3xzTvTr0HY1MgNzH4J4u+rKW7d6s
	Guc8ke0rcC8L+JhbLf5WLsyggl5mbZamSVWmcDiSJuar54Fnse4gYv4bZwHvpvOWWo8s5USG1Ot
	QoZdaCopZCx93/fx3SU3vVlIozqrUy22b6
X-Received: by 2002:a17:907:1df1:b0:bd5:17f9:e987 with SMTP id a640c23a62f3a-bdc16131c08mr140799866b.46.1779373927445;
        Thu, 21 May 2026 07:32:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bdc87e781a7sm57136666b.18.2026.05.21.07.32.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 May 2026 07:32:06 -0700 (PDT)
Date: Thu, 21 May 2026 14:32:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Nico Pache <npache@redhat.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com, akpm@linux-foundation.org,
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, jackmanb@google.com, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com,
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org,
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
	sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <20260521143206.evmha5goh6smhmha@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-12-npache@redhat.com>
 <8f9834db-8981-4eb1-ae46-94908943da3d@gmail.com>
 <20260521024654.2a7teoe665porz76@master>
 <91015820-f39a-4b06-89de-b49e5ca465fd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91015820-f39a-4b06-89de-b49e5ca465fd@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: A619D180014
X-Rspamd-Server: rspam03
X-Stat-Signature: dsekich31cnz5tqx4ux18t9765kgr678
X-HE-Tag: 1779373929-99217
X-HE-Meta: U2FsdGVkX19l4k0wtD9pt+b7lsKrmcam6k9gTNrM48YVq4As9PaoLuaFMvwpTEmVzL7KubtB7vcjAH0lzqnE8Y7TOLhg/QR1oF0+56ibjlxSBv0Kjy4ZPF29OZaPl4H+ngHEqq2YKogIJyDe5+zdOlbMcyMtg0+F4z2LSJMAGip1lNpSySvyX/UvqBLj1aWfvgPk5+Vw/CJVs8ROz37CVs3fCtZV3KMM8LlCRNH8Pdnn25iTMujHem9osgqWvglgQOvZG3UOO7WssewKt/Rc+uITSIjrCtX95/HjP/csAVkIsmw9mL1NCtNbXiavvRk3CtkfDFohk01D3FtlXY81SZ9KfEUFGbbYTyyRiq6XxIRB5MGhbxeiRlvLS9Maw6z1xM2hbbV2G5BePFsReotXdORHZR9Rp228zCto/MzZJmQUaeIHY6Bz5oC7ita5UtclVmp9UMpeObAQYXY7HnUgARu279yG400/Y+CiynUoFrgmwP7+7excmxx2NI0Wae7pe1Kh4mj1mIzTfo7G699tfh8Dbeasu59+2fjA3UVxIlDpyiCtFrF6FazS80Sjtr6OaN+sh0GFFpvkd3FYei+R9HusGSh9yfV5PMw593PKEYeAi3bxbn35DBc7icm4IOvnFZRDrlA1VCUPi6b2/YJ/kZsRIEjzJcYtyvAsU086tIT1V0xXQXp0/aoPDGdA0tmm5FUNI82D+NMSKioNLnh+VsqWQ+9ctyE3xyIDO1sV9JrD8S/r2Y4chK7jNrrSNeZmuP+VpHSOPYREhjfQK5sc7xUVF03+avfEWL2xDH0s4TrOYt5uNowz2sLa7EK8l2Npc06P722l6DH3Qy9vjVYXjoH6cy7l811wKcX9P6+8Q7E8ARsa/Lwvmfobvkd4Iu0QX1nB/ECfmlT/ge7Yy5BWYrUFDwVermBtXg9MHFkfdZVKqE+NcdZhBYiXsmipw7upLQu7xVVm/2GwsjqRWh9
 2li0M8XW
 DOgrahfD377UXPmdbKhfjMR2l6NY7K8y/xY6SvtK1C1ov599ibn7UHVrEiehbmO/6ifuHB9rnmfnf7UXrSPhQeEgqUietWZD9cc8czNEB/79rE8uC7e9uD1iSxIVBayKb49+YMWrUI2sgmMi4OKxaFAcN1L7dAEwAcIfxLmAEMxmDw0TMCYZrL7MUw8eSSWSa8h+9t8U1DiBMiDCqjnuiEWuSPIo5S3cxtK/250YU3s7uhPLxi2ge8yXvbB2YafI5m0+br+5em2UUkW9/gYQy0cmFVHE68eyQogd5UUzzkB6ljmoBwVLq4h8fZvXfqGwDBI9LEiqMwhajTv6zg4rxjn3/WXHTY5jfj3OxvJ52S5KgjjmbcEVB6KDF38OERbC9Uw1sxO4aFFpvv/YGO6MZFFAzoM9cFC+p2yRRW4aqE2UXScjHV9LoRacBG3POUQyK2Zo5QXFk1fU/dv5X5i+GoOAkfAyCyu4ZzJrusoaV7xpCInuE3Ay1swAe9ev4QyLBVIwDc5EH0aVemnY7sRi2JcETRTSGM43pK4YvhW8ODG/B9JZYm6pzlHV3F3KjjvppHknrbzfLEUX/HHXPDA28rC7kjxr6Mc4BW+dKqWwP+ERQENU7t7lOksvAvvYlvtmNcEp7siuhOPzWdIwdtffDZqN6VgMgTOlXX0LmgYb/GoGSgG7A2upwJOPerXNJXFNjocM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 01:11:18PM +0800, Vernon Yang wrote:
>On Thu, May 21, 2026 at 02:46:54AM +0000, Wei Yang wrote:
>> On Thu, May 21, 2026 at 10:36:15AM +0800, Vernon Yang wrote:
>> >On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
>> >> Enable khugepaged to collapse to mTHP orders. This patch implements the
>> >> main scanning logic using a bitmap to track occupied pages and a stack
>> >> structure that allows us to find optimal collapse sizes.
>> >>
>> >> Previous to this patch, PMD collapse had 3 main phases, a light weight
>> >> scanning phase (mmap_read_lock) that determines a potential PMD
>> >> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
>> >> phase (mmap_write_lock).
>> >>
>> >> To enabled mTHP collapse we make the following changes:
>> >>
>> >> During PMD scan phase, track occupied pages in a bitmap. When mTHP
>> >> orders are enabled, we remove the restriction of max_ptes_none during the
>> >> scan phase to avoid missing potential mTHP collapse candidates. Once we
>> >> have scanned the full PMD range and updated the bitmap to track occupied
>> >> pages, we use the bitmap to find the optimal mTHP size.
>> >>
>> >> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
>> >> and determine the best eligible order for the collapse. A stack structure
>> >> is used instead of traditional recursion to manage the search. This also
>> >> prevents a traditional recursive approach when the kernel stack struct is
>> >> limited. The algorithm recursively splits the bitmap into smaller chunks to
>> >> find the highest order mTHPs that satisfy the collapse criteria. We start
>> >> by attempting the PMD order, then moved on the consecutively lower orders
>> >> (mTHP collapse). The stack maintains a pair of variables (offset, order),
>> >> indicating the number of PTEs from the start of the PMD, and the order of
>> >> the potential collapse candidate.
>> >>
>> >> The algorithm for consuming the bitmap works as such:
>> >>     1) push (0, HPAGE_PMD_ORDER) onto the stack
>> >>     2) pop the stack
>> >>     3) check if the number of set bits in that (offset,order) pair
>> >>        statisfy the max_ptes_none threshold for that order
>> >>     4) if yes, attempt collapse
>> >>     5) if no (or collapse fails), push two new stack items representing
>> >>        the left and right halves of the current bitmap range, at the
>> >>        next lower order
>> >>     6) repeat at step (2) until stack is empty.
>> >>
>> >> Below is a diagram representing the algorithm and stack items:
>> >>
>> >>                             offset   mid_offset
>> >>                             |        |
>> >>                             |        |
>> >>                             v        v
>> >>           ____________________________________
>> >>          |          PTE Page Table            |
>> >>          --------------------------------------
>> >> 			    <-------><------->
>> >>                              order-1  order-1
>> >>
>> >> mTHP collapses reject regions containing swapped out or shared pages.
>> >> This is because adding new entries can lead to new none pages, and these
>> >> may lead to constant promotion into a higher order mTHP. A similar
>> >> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>> >> introducing at least 2x the number of pages, and on a future scan will
>> >> satisfy the promotion condition once again. This issue is prevented via
>> >> the collapse_max_ptes_none() function which imposes the max_ptes_none
>> >> restrictions above.
>> >>
>> >> We currently only support mTHP collapse for max_ptes_none values of 0
>> >> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>> >>
>> >>     - max_ptes_none=0: Never introduce new empty pages during collapse
>> >>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>> >>       available mTHP order
>> >>
>> >> Any other max_ptes_none value will emit a warning and skip mTHP collapse
>> >> attempts. There should be no behavior change for PMD collapse.
>> >>
>> >> Once we determine what mTHP sizes fits best in that PMD range a collapse
>> >> is attempted. A minimum collapse order of 2 is used as this is the lowest
>> >> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>> >>
>> >> Currently madv_collapse is not supported and will only attempt PMD
>> >> collapse.
>> >>
>> >> We can also remove the check for is_khugepaged inside the PMD scan as
>> >> the collapse_max_ptes_none() function handles this logic now.
>> >>
>> >> Signed-off-by: Nico Pache <npache@redhat.com>
>> >> ---
>> >>  mm/khugepaged.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---
>> >>  1 file changed, 174 insertions(+), 8 deletions(-)
>> >>
>> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> >> index 3492b135d667..39bf7ea8a6e8 100644
>> >> --- a/mm/khugepaged.c
>> >> +++ b/mm/khugepaged.c
>> >> @@ -100,6 +100,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>> >>
>> >>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>> >>
>> >> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
>> >> +/*
>> >> + * mthp_collapse() does an iterative DFS over a binary tree, from
>> >> + * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
>> >> + * size needed for a DFS on a binary tree is height + 1, where
>> >> + * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
>> >> + *
>> >> + * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
>> >> + * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
>> >> + */
>> >> +#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
>> >> +
>> >> +/*
>> >> + * Defines a range of PTE entries in a PTE page table which are being
>> >> + * considered for mTHP collapse.
>> >> + *
>> >> + * @offset: the offset of the first PTE entry in a PMD range.
>> >> + * @order: the order of the PTE entries being considered for collapse.
>> >> + */
>> >> +struct mthp_range {
>> >> +	u16 offset;
>> >> +	u8 order;
>> >> +};
>> >> +
>> >>  struct collapse_control {
>> >>  	bool is_khugepaged;
>> >>
>> >> @@ -111,6 +135,12 @@ struct collapse_control {
>> >>
>> >>  	/* nodemask for allocation fallback */
>> >>  	nodemask_t alloc_nmask;
>> >> +
>> >> +	/* Each bit represents a single occupied (!none/zero) page. */
>> >> +	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
>> >> +	/* A mask of the current range being considered for mTHP collapse. */
>> >> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
>> >> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
>> >>  };
>> >>
>> >>  /**
>> >> @@ -1404,20 +1434,140 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>> >>  	return result;
>> >>  }
>> >>
>> >> +static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
>> >> +				     u16 offset, u8 order)
>> >> +{
>> >> +	const int size = *stack_size;
>> >> +	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
>> >> +
>> >> +	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
>> >> +	stack->order = order;
>> >> +	stack->offset = offset;
>> >> +	(*stack_size)++;
>> >> +}
>> >> +
>> >> +static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
>> >> +						 int *stack_size)
>> >> +{
>> >> +	const int size = *stack_size;
>> >> +
>> >> +	VM_WARN_ON_ONCE(size <= 0);
>> >> +	(*stack_size)--;
>> >> +	return cc->mthp_bitmap_stack[size - 1];
>> >> +}
>> >> +
>> >> +static unsigned int collapse_mthp_count_present(struct collapse_control *cc,
>> >> +						u16 offset, unsigned int nr_ptes)
>> >> +{
>> >> +	bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
>> >> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
>> >> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
>> >> +}
>> >> +
>> >> +/*
>> >> + * mthp_collapse() consumes the bitmap that is generated during
>> >> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>> >> + *
>> >> + * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
>> >> + * A stack structure cc->mthp_bitmap_stack is used to check different regions
>> >> + * of the bitmap for collapse eligibility. The stack maintains a pair of
>> >> + * variables (offset, order), indicating the number of PTEs from the start of
>> >> + * the PMD, and the order of the potential collapse candidate respectively. We
>> >> + * start at the PMD order and check if it is eligible for collapse; if not, we
>> >> + * add two entries to the stack at a lower order to represent the left and right
>> >> + * halves of the PTE page table we are examining.
>> >> + *
>> >> + *                         offset       mid_offset
>> >> + *                         |         |
>> >> + *                         |         |
>> >> + *                         v         v
>> >> + *      --------------------------------------
>> >> + *      |          cc->mthp_bitmap            |
>> >> + *      --------------------------------------
>> >> + *                         <-------><------->
>> >> + *                          order-1  order-1
>> >> + *
>> >> + * For each of these, we determine how many PTE entries are occupied in the
>> >> + * range of PTE entries we propose to collapse, then we compare this to a
>> >> + * threshold number of PTE entries which would need to be occupied for a
>> >> + * collapse to be permitted at that order (accounting for max_ptes_none).
>> >> + *
>> >> + * If a collapse is permitted, we attempt to collapse the PTE range into a
>> >> + * mTHP.
>> >> + */
>> >> +static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>> >> +		int referenced, int unmapped, struct collapse_control *cc,
>> >> +		unsigned long enabled_orders)
>> >> +{
>> >> +	unsigned int nr_occupied_ptes, nr_ptes;
>> >> +	int max_ptes_none, collapsed = 0, stack_size = 0;
>> >> +	unsigned long collapse_address;
>> >> +	struct mthp_range range;
>> >> +	u16 offset;
>> >> +	u8 order;
>> >> +
>> >> +	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
>> >> +
>> >> +	while (stack_size) {
>> >> +		range = collapse_mthp_stack_pop(cc, &stack_size);
>> >> +		order = range.order;
>> >> +		offset = range.offset;
>> >> +		nr_ptes = 1UL << order;
>> >> +
>> >> +		if (!test_bit(order, &enabled_orders))
>> >> +			goto next_order;
>> >> +
>> >> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>> >> +
>> >> +		if (max_ptes_none < 0)
>> >> +			return collapsed;
>> >> +
>> >> +		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
>> >> +							       nr_ptes);
>> >> +
>> >> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>> >> +			int ret;
>> >> +
>> >> +			collapse_address = address + offset * PAGE_SIZE;
>> >> +			ret = collapse_huge_page(mm, collapse_address, referenced,
>> >> +						 unmapped, cc, order);
>> >> +			if (ret == SCAN_SUCCEED) {
>> >> +				collapsed += nr_ptes;
>> >> +				continue;
>> >> +			}
>> >> +		}
>> >> +
>> >> +next_order:
>> >> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
>> >
>> >Hi Nico, thank you very much for your contributions to this series.
>> >
>> >I found a minor issue, for MADV_COLLAPSE, if collapse_huge_page() fails
>> >for some reason (e.g. allocate folio), it goes to next_order and
>> >continues splitting to the next small order. However, enabled_orders
>> >only supports HPAGE_PMD_ORDER, so it keeps runing the split operations
>> >without any effective work until KHUGEPAGED_MIN_MTHP_ORDER is reached
>> >before exiting. For khugepaged, e.g. setting only 2MB to always, also
>> >same phenomenon.
>>
>> Yes, but it does no actual work since it is checked after pop up.
>>
>> >
>> >This does not affect the overall functionality of mthp collapse, just
>> >redundant.
>> >
>> >The redundant operations can be easily skipped with the following
>> >modification. If I miss some thing, please let me know. Thanks!
>> >
>> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> >index 1a25af3d6d0f..fa407cce525c 100644
>> >--- a/mm/khugepaged.c
>> >+++ b/mm/khugepaged.c
>> >@@ -1574,7 +1574,7 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>> > 		}
>> >
>> > next_order:
>> >-		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
>> >+		if ((BIT(order) - 1) & enabled_orders) {
>> > 			const u8 next_order = order - 1;
>> > 			const u16 mid_offset = offset + (nr_ptes / 2);
>> >
>>
>> This would stop the iteration if there are other lower enabled order, right?
>             ^^^^                                  ^^^^^^^^^^^^^^^^^^^
>
>NO :)

Got it. You are right.

The logic here is all lower bits are not set, skip the rest.

>
>For more details, please refer to the following information.
>
>|              Scenario               | Old Behavior (order > 2) | New Behavior ((BIT(order)-1) & enabled_orders) |
>|-------------------------------------|--------------------------|------------------------------------------------|
>| MADV_COLLAPSE                       | Splits 9,8,7,...,3       | No split                                       |
>| khugepaged, only 2MB enabled        | Splits 9,8,7,...,3       | No split                                       |
>| khugepaged, only 2MB + 64KB enabled | Splits 9,8,7,...,3       | Splits 9,8,7,...,5                             |
>| khugepaged, only 32KB enabled       | Splits 9,8,7,...,3       | Splits 9,8,7,...,4                             |
>| khugepaged, only 16KB enabled       | Splits 9,8,7,...,3       | Splits 9,8,7,...,3                             |
>| khugepaged, all mTHP enabled        | Splits 9,8,7,...,3       | Splits 9,8,7,...,3                             |
>
>--
>Cheers,
>Vernon

-- 
Wei Yang
Help you, Help me

