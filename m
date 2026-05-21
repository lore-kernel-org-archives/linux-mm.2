Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46189CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 05:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703416B008C; Thu, 21 May 2026 01:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3F46B0092; Thu, 21 May 2026 01:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B836B0093; Thu, 21 May 2026 01:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4014A6B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:11:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E645EC1D9B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:11:48 +0000 (UTC)
X-FDA: 84790254696.18.0E8CD7C
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0E07016000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:11:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZDgjr3v4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779340307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QavOmsmCk8wHSsJYb+7V6gDDdoRFfxnn/DpXYtvAfIs=;
	b=3tnB6wn7eaC/eB+ltLmBEgV3NeHHQAt6KT7/Kipb3fX0n4K+krwgYPcqSMBfMA+HcAyOpc
	FKwMp1fnRNqIsLK+dolXsx6z1b2rmpNuUtxuW77Jn70oaB/2nTck4cdt+MIv2NNMFMMr+6
	sP4EiTF24+u5PPezHDQbsQHWhYgMqac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779340307; a=rsa-sha256;
	cv=none;
	b=5sS9g+3gAcanV6N1Szxouz2yQVTbSt5uvKrR0AHdTlLeeeWVQWhDGyrVbZnpUWaX4KflT6
	F2akJl09pGpMnq9COFYjCvV88RFncVGQDA43zIL7MVERDgQc6by6W41zppvN6DEhLjIOyz
	9V6nlchm0M8qN8ath2e4a4Aiyr5+NFs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZDgjr3v4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3697c35eab7so3218798a91.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 22:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779340306; x=1779945106; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QavOmsmCk8wHSsJYb+7V6gDDdoRFfxnn/DpXYtvAfIs=;
        b=ZDgjr3v4uItXQDVqiryZK49oMjJbI2eES5FlAqoFtrFdotQqRrY19PtsKYFSgTXcPD
         Cqi4d/AKpeRze4ADV/9Draxi1WGra9AUvMOiO1Be5TtU9AK9+SURRje9mc3x826eUe5Z
         KLBumZRSHl+sKe8elaI4ZH4qGENB9tDk5FFlwVRjugcvCx0Kpz2qLgCd44zuWXY8EFZR
         u8Np5SC1XCUXFufvzcnYHRS6jVpE8lfCB5J74rh4Qi3WBLBNsb1MeS/0mKeItSJeeHXQ
         M/8E8kAirrr+qLvT/EcIsQUn2GGbFv7VwbOdb6yN81JYKF0nEAGcr+uub5+Fb3MoEx+N
         jqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779340306; x=1779945106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QavOmsmCk8wHSsJYb+7V6gDDdoRFfxnn/DpXYtvAfIs=;
        b=GE9uOijlNI4oKmaV4TrlTnvJv+DKOUX7Gdute3H3B6LNJfgRDtEWK15xG+vaCHVYzd
         VhG8CRXGaqSvyTbuJoanHCt+MVmgg6JjjDNzhjn9dCU6xPRoRdXYCpgI1KwmRs9DMnkp
         oDMZox3yxxpy/dYptRmS/96ge6WxQtkXluy/PFO+vTmkUgdpPtjQgAfWfFNyk6kUBv0p
         XjLcK4Hp0WiZRBMJfZSYOL03YFXgc6wgH/ETw3Uhe2e6aRepx4zZ7DqYyx6eoBo0+OLe
         9SUnBjommKMYg5VvnYR5u35p4/0JbvoBxytTOhMcT4kSKP9m+prkNAeiSTtXR0SOxL/9
         imSw==
X-Forwarded-Encrypted: i=1; AFNElJ8zyoo6kBeVJeadMHUnjt9cBVZHt34HZ9g3fhYrH8y57a4dUkRrLSNyofOD6rI0cVna2JQFFE1v1A==@kvack.org
X-Gm-Message-State: AOJu0YxyBAw+lFcIfEEcs3UBaaxyLhXFOXbAh8XTQc7CfRG/jM6KS+0G
	DC3eYMUUIZEhNNuuWxXRz2vovrmclVmX881BE+wJfaWhxeKBcG0n/zNn
X-Gm-Gg: Acq92OHjXX4nNO34V/JLyHz6C7R/osLLiSEp05hEyWp9+E7/NleshkJjwGUxBbAVVrG
	mETXkdD6AM/zGoMNDgLiz/yJUG2wj93kMQUx69AxTD8BQrWZQLymB3T+4wiPEfTI6e5dxGv69A8
	DVttonxJa6DiWTtmqGu3YMlmJkefDlSQmf2xOkvAuKJv2V0xulbLFAhVw9OVNldu/Drr0S4s56A
	eFFDqqw+MNqQbizIhKx3lA92xTnfYqP4/55DR0Zca8FA13YzAqFML9rPwKfNDwcnlLeW+mpUJQ1
	xE3XP9lrRNrr27kvAKE9ToZPM/05gFEMJq82AKuXEGovRYsOSwYEbTFfKDSDD0730MbfD1p1obX
	wGWl2Vhq1kGyTE830FSZyT9hDf0n4yB1GX7jB806MUHIJgoEDtC4rmlSTuJx6ypIaUcMiHCV/2g
	gs+dGnsU7LSjyloPy64jn996tpjYRVaxfS8Kx+5g==
X-Received: by 2002:a17:90b:5241:b0:366:479e:63a5 with SMTP id 98e67ed59e1d1-36a44f11de4mr1461841a91.2.1779340305728;
        Wed, 20 May 2026 22:11:45 -0700 (PDT)
Received: from localhost.localdomain ([155.254.122.134])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a3d206162sm1296571a91.14.2026.05.20.22.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 22:11:45 -0700 (PDT)
Date: Thu, 21 May 2026 13:11:18 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <91015820-f39a-4b06-89de-b49e5ca465fd@gmail.com>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-12-npache@redhat.com>
 <8f9834db-8981-4eb1-ae46-94908943da3d@gmail.com>
 <20260521024654.2a7teoe665porz76@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521024654.2a7teoe665porz76@master>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E07016000C
X-Stat-Signature: qrgkfhiz9na9378m1qtrmktpaqjuypp5
X-Rspam-User: 
X-HE-Tag: 1779340306-147907
X-HE-Meta: U2FsdGVkX188m5HzU1MnIx/JQKR9+4amz3Ka4ToqLUcCOk8cZ2tizQJsjiCPau62cyeHOXqoDZHVNwiPrjzSSMCAnKLmzXxnCPPYpc00HgwZP6eG43HJ/tFjAzRdgrCJliHOYYP7MRmcQ6JcUW4OZ2DiVMdHRPiujVwdttUh++dn/ii+eFQOrb9s5Gj2xiXuYDPsraMbNrRyCwgMhHV4MTKa3uXjuhi1juJO43rkp7qKlZ4tRULZx2gYIFOHAqkiJ8NC++MRQFs0Vbp9oPBTLvQIGVXIzjGv4xFYGMi9LnR35APo4Ik+fZmfUkEPgy2BxwpQUKCHUrHj2OnP0l301qOFooLhtR+1WH22Defz+67hF9zmTfwWbhjeLt+8ZF+c0h2HJ5sIyAT915pI2XCJXJPPS4CLm/NlPtEMeq5o0zstbnss3vL3tp76CU8g/QICleMdxaFZplHgUIZIBGmiwoJthoCLuZTvfNISQ9lZjIKcU8pGh7B1eZsuIzf1tIJbsbnD3t/rUiPUPGggR3rG0szncDAq4/Uy3oCz1EWsr+/vfvhTOdRNUdbcxp8TkbUHvGlRPTDu4LnmMnDp0xONyMA6ruM5Y4dWLvG8uX8AkSnbcmRZI6rKE4pamsI828d9BldUzZb4SUYBa4XaYk5zIbDvTaFH2Pzfj+aFrfHhoWyI9PfZOP3jeoUsmmClRb4lU7RtD4/L6oQwa1i+b/W2aUizlt90lFbdXpdgvWSwtps/m510W/U2wGJRAQx0YMWdcbYfZhQT/73rt3DItHeLykj5hhEIaZdDvopLpb6x9T/+w2qzElhyarVzWTUjvaNiiUaq/L+KCb1R7DN6ohx5s6G1NXfKB7JIRWOTZyxQgzp+63rnQAyr+WGy8umMxSdt+zk3Hib1S2j/GUU9z1/wxMHNvKuLP7UKxRxpXxlhFccXFQ5LZwLOi8HnxG0wvjN1Y/qnhpePFMMMf07UVt1
 uGu56xeq
 MfnO9sRAK9gjUWNuFQhIg51ztclQ1SlqlVmV8FGZtvI6sFUBK5VljEZkiQACmTlsaZxlK8poAtJ9EqIBbiv9eBgh6RR/mAGPey5breCYGHHXpDSGW27zNyvM6XOOdUWHniBue7eEMU2xq84oT5c5E5f8yuL3O/UK+TQ5neJzvdK2CAVfEXWInb9hG9p6IhLyHvZN0SAGdSb5qupcA3f5lUtic6a5IvK3llDlUIGlYQCPsqtVvLSvPKFpGmX/3lRNS+GslocPPjchN5dCMNCoftKc+HHPX2NK88Is51htLVLh6ZXV/HvoryYUlhtKk8IDGa+6Y2vDc9H7O0JdhzQWdfZB5szy3G1LgDlaUBosF2gEPwyFLLhCHWAfA5v/t31on6djPF+Vxq+W97ESROE+RgpEtsSbBIbKOkwpjmzxjk73lh5N1dDLmikjgd4pjyX28PTu540atf1H6pJiDNqqhAjIX456l0xISHgoTHgLo640h5Ls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 02:46:54AM +0000, Wei Yang wrote:
> On Thu, May 21, 2026 at 10:36:15AM +0800, Vernon Yang wrote:
> >On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
> >> Enable khugepaged to collapse to mTHP orders. This patch implements the
> >> main scanning logic using a bitmap to track occupied pages and a stack
> >> structure that allows us to find optimal collapse sizes.
> >>
> >> Previous to this patch, PMD collapse had 3 main phases, a light weight
> >> scanning phase (mmap_read_lock) that determines a potential PMD
> >> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> >> phase (mmap_write_lock).
> >>
> >> To enabled mTHP collapse we make the following changes:
> >>
> >> During PMD scan phase, track occupied pages in a bitmap. When mTHP
> >> orders are enabled, we remove the restriction of max_ptes_none during the
> >> scan phase to avoid missing potential mTHP collapse candidates. Once we
> >> have scanned the full PMD range and updated the bitmap to track occupied
> >> pages, we use the bitmap to find the optimal mTHP size.
> >>
> >> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> >> and determine the best eligible order for the collapse. A stack structure
> >> is used instead of traditional recursion to manage the search. This also
> >> prevents a traditional recursive approach when the kernel stack struct is
> >> limited. The algorithm recursively splits the bitmap into smaller chunks to
> >> find the highest order mTHPs that satisfy the collapse criteria. We start
> >> by attempting the PMD order, then moved on the consecutively lower orders
> >> (mTHP collapse). The stack maintains a pair of variables (offset, order),
> >> indicating the number of PTEs from the start of the PMD, and the order of
> >> the potential collapse candidate.
> >>
> >> The algorithm for consuming the bitmap works as such:
> >>     1) push (0, HPAGE_PMD_ORDER) onto the stack
> >>     2) pop the stack
> >>     3) check if the number of set bits in that (offset,order) pair
> >>        statisfy the max_ptes_none threshold for that order
> >>     4) if yes, attempt collapse
> >>     5) if no (or collapse fails), push two new stack items representing
> >>        the left and right halves of the current bitmap range, at the
> >>        next lower order
> >>     6) repeat at step (2) until stack is empty.
> >>
> >> Below is a diagram representing the algorithm and stack items:
> >>
> >>                             offset   mid_offset
> >>                             |        |
> >>                             |        |
> >>                             v        v
> >>           ____________________________________
> >>          |          PTE Page Table            |
> >>          --------------------------------------
> >> 			    <-------><------->
> >>                              order-1  order-1
> >>
> >> mTHP collapses reject regions containing swapped out or shared pages.
> >> This is because adding new entries can lead to new none pages, and these
> >> may lead to constant promotion into a higher order mTHP. A similar
> >> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> >> introducing at least 2x the number of pages, and on a future scan will
> >> satisfy the promotion condition once again. This issue is prevented via
> >> the collapse_max_ptes_none() function which imposes the max_ptes_none
> >> restrictions above.
> >>
> >> We currently only support mTHP collapse for max_ptes_none values of 0
> >> and HPAGE_PMD_NR - 1. resulting in the following behavior:
> >>
> >>     - max_ptes_none=0: Never introduce new empty pages during collapse
> >>     - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
> >>       available mTHP order
> >>
> >> Any other max_ptes_none value will emit a warning and skip mTHP collapse
> >> attempts. There should be no behavior change for PMD collapse.
> >>
> >> Once we determine what mTHP sizes fits best in that PMD range a collapse
> >> is attempted. A minimum collapse order of 2 is used as this is the lowest
> >> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
> >>
> >> Currently madv_collapse is not supported and will only attempt PMD
> >> collapse.
> >>
> >> We can also remove the check for is_khugepaged inside the PMD scan as
> >> the collapse_max_ptes_none() function handles this logic now.
> >>
> >> Signed-off-by: Nico Pache <npache@redhat.com>
> >> ---
> >>  mm/khugepaged.c | 182 +++++++++++++++++++++++++++++++++++++++++++++---
> >>  1 file changed, 174 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index 3492b135d667..39bf7ea8a6e8 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -100,6 +100,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> >>
> >>  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >>
> >> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> >> +/*
> >> + * mthp_collapse() does an iterative DFS over a binary tree, from
> >> + * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
> >> + * size needed for a DFS on a binary tree is height + 1, where
> >> + * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
> >> + *
> >> + * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
> >> + * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
> >> + */
> >> +#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
> >> +
> >> +/*
> >> + * Defines a range of PTE entries in a PTE page table which are being
> >> + * considered for mTHP collapse.
> >> + *
> >> + * @offset: the offset of the first PTE entry in a PMD range.
> >> + * @order: the order of the PTE entries being considered for collapse.
> >> + */
> >> +struct mthp_range {
> >> +	u16 offset;
> >> +	u8 order;
> >> +};
> >> +
> >>  struct collapse_control {
> >>  	bool is_khugepaged;
> >>
> >> @@ -111,6 +135,12 @@ struct collapse_control {
> >>
> >>  	/* nodemask for allocation fallback */
> >>  	nodemask_t alloc_nmask;
> >> +
> >> +	/* Each bit represents a single occupied (!none/zero) page. */
> >> +	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
> >> +	/* A mask of the current range being considered for mTHP collapse. */
> >> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> >> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
> >>  };
> >>
> >>  /**
> >> @@ -1404,20 +1434,140 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
> >>  	return result;
> >>  }
> >>
> >> +static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
> >> +				     u16 offset, u8 order)
> >> +{
> >> +	const int size = *stack_size;
> >> +	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
> >> +
> >> +	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
> >> +	stack->order = order;
> >> +	stack->offset = offset;
> >> +	(*stack_size)++;
> >> +}
> >> +
> >> +static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
> >> +						 int *stack_size)
> >> +{
> >> +	const int size = *stack_size;
> >> +
> >> +	VM_WARN_ON_ONCE(size <= 0);
> >> +	(*stack_size)--;
> >> +	return cc->mthp_bitmap_stack[size - 1];
> >> +}
> >> +
> >> +static unsigned int collapse_mthp_count_present(struct collapse_control *cc,
> >> +						u16 offset, unsigned int nr_ptes)
> >> +{
> >> +	bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> >> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
> >> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> >> +}
> >> +
> >> +/*
> >> + * mthp_collapse() consumes the bitmap that is generated during
> >> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> >> + *
> >> + * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
> >> + * A stack structure cc->mthp_bitmap_stack is used to check different regions
> >> + * of the bitmap for collapse eligibility. The stack maintains a pair of
> >> + * variables (offset, order), indicating the number of PTEs from the start of
> >> + * the PMD, and the order of the potential collapse candidate respectively. We
> >> + * start at the PMD order and check if it is eligible for collapse; if not, we
> >> + * add two entries to the stack at a lower order to represent the left and right
> >> + * halves of the PTE page table we are examining.
> >> + *
> >> + *                         offset       mid_offset
> >> + *                         |         |
> >> + *                         |         |
> >> + *                         v         v
> >> + *      --------------------------------------
> >> + *      |          cc->mthp_bitmap            |
> >> + *      --------------------------------------
> >> + *                         <-------><------->
> >> + *                          order-1  order-1
> >> + *
> >> + * For each of these, we determine how many PTE entries are occupied in the
> >> + * range of PTE entries we propose to collapse, then we compare this to a
> >> + * threshold number of PTE entries which would need to be occupied for a
> >> + * collapse to be permitted at that order (accounting for max_ptes_none).
> >> + *
> >> + * If a collapse is permitted, we attempt to collapse the PTE range into a
> >> + * mTHP.
> >> + */
> >> +static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> >> +		int referenced, int unmapped, struct collapse_control *cc,
> >> +		unsigned long enabled_orders)
> >> +{
> >> +	unsigned int nr_occupied_ptes, nr_ptes;
> >> +	int max_ptes_none, collapsed = 0, stack_size = 0;
> >> +	unsigned long collapse_address;
> >> +	struct mthp_range range;
> >> +	u16 offset;
> >> +	u8 order;
> >> +
> >> +	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> >> +
> >> +	while (stack_size) {
> >> +		range = collapse_mthp_stack_pop(cc, &stack_size);
> >> +		order = range.order;
> >> +		offset = range.offset;
> >> +		nr_ptes = 1UL << order;
> >> +
> >> +		if (!test_bit(order, &enabled_orders))
> >> +			goto next_order;
> >> +
> >> +		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
> >> +
> >> +		if (max_ptes_none < 0)
> >> +			return collapsed;
> >> +
> >> +		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
> >> +							       nr_ptes);
> >> +
> >> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> >> +			int ret;
> >> +
> >> +			collapse_address = address + offset * PAGE_SIZE;
> >> +			ret = collapse_huge_page(mm, collapse_address, referenced,
> >> +						 unmapped, cc, order);
> >> +			if (ret == SCAN_SUCCEED) {
> >> +				collapsed += nr_ptes;
> >> +				continue;
> >> +			}
> >> +		}
> >> +
> >> +next_order:
> >> +		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
> >
> >Hi Nico, thank you very much for your contributions to this series.
> >
> >I found a minor issue, for MADV_COLLAPSE, if collapse_huge_page() fails
> >for some reason (e.g. allocate folio), it goes to next_order and
> >continues splitting to the next small order. However, enabled_orders
> >only supports HPAGE_PMD_ORDER, so it keeps runing the split operations
> >without any effective work until KHUGEPAGED_MIN_MTHP_ORDER is reached
> >before exiting. For khugepaged, e.g. setting only 2MB to always, also
> >same phenomenon.
>
> Yes, but it does no actual work since it is checked after pop up.
>
> >
> >This does not affect the overall functionality of mthp collapse, just
> >redundant.
> >
> >The redundant operations can be easily skipped with the following
> >modification. If I miss some thing, please let me know. Thanks!
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index 1a25af3d6d0f..fa407cce525c 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -1574,7 +1574,7 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
> > 		}
> >
> > next_order:
> >-		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
> >+		if ((BIT(order) - 1) & enabled_orders) {
> > 			const u8 next_order = order - 1;
> > 			const u16 mid_offset = offset + (nr_ptes / 2);
> >
>
> This would stop the iteration if there are other lower enabled order, right?
             ^^^^                                  ^^^^^^^^^^^^^^^^^^^

NO :)

For more details, please refer to the following information.

|              Scenario               | Old Behavior (order > 2) | New Behavior ((BIT(order)-1) & enabled_orders) |
|-------------------------------------|--------------------------|------------------------------------------------|
| MADV_COLLAPSE                       | Splits 9,8,7,...,3       | No split                                       |
| khugepaged, only 2MB enabled        | Splits 9,8,7,...,3       | No split                                       |
| khugepaged, only 2MB + 64KB enabled | Splits 9,8,7,...,3       | Splits 9,8,7,...,5                             |
| khugepaged, only 32KB enabled       | Splits 9,8,7,...,3       | Splits 9,8,7,...,4                             |
| khugepaged, only 16KB enabled       | Splits 9,8,7,...,3       | Splits 9,8,7,...,3                             |
| khugepaged, all mTHP enabled        | Splits 9,8,7,...,3       | Splits 9,8,7,...,3                             |

--
Cheers,
Vernon

