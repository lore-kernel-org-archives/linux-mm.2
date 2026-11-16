Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F637606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TPVmuSnq
Received: by kanga.kvack.org (Postfix)
	id A60886B05B3; Mon, 16 Nov 2026 04:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11226B05B4; Mon, 16 Nov 2026 04:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928856B05B5; Mon, 16 Nov 2026 04:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5016B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:05:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9E7DA8653
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:05:14 +0000 (UTC)
X-FDA: 85440398148.11.D34F5D8
Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3F731140003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:05:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TPVmuSnq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794819913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLOOvo9HqJFBKWuVFOAMt7QamPs3Ec3ERw2/y0kWeTM=;
	b=nZJJm0MHd6a8ugC+SR4VuJ5sSvJLFWX4fM35/7BHtuEChwdGgB32hyTQ7KIQoeEirxJoqv
	R1Ujr9BrUZDr7mkmlI5D1A3NQcWQAE9WUCSz34ptSpko/Paa0lQ+2Ok4JU6aD/009HYEjn
	kUHKiHEeTWSKZUlOqEQxcxY3/r0SXjo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TPVmuSnq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794819913;
	b=t4PEPx+2KX1kh4DS1A4qLDCAABZfBgq3kkKgm1IBir8BVovWKy0MXfSFGtZlJ9yyUzDXDP
	m7lDeMLwDk5faOljee7xm5J2/UsqIbSnH54CRPbTXO+eCkH/UMjOUTbqDZBE63GHgZ/jQj
	t7a7KL8GNgnhNNMIe5fVbj145x9wMDg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QJBgTWrTnvInnZrf7o7guiV0SN7Rty/Dlh67CgBtKnQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794819909; v=1; x=1795424709;
 b=TPVmuSnqx3Gol+Aa/rqc0BVnaU00Ak+fAkaKzeebKIorrFBvfYhctKgH7ypr6IrT6rOViBYD
 q7uGGaiOzZVNcEZH+INrVqbAW53gSdvaNpeDuIiw2XHryZyPDPJH8hpx42edhad6NyeaLF6G/1H
 fWaM/ZHykb8o4jKCuVQEnI7k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d4bf1921e088497c;
	Mon, 16 Nov 2026 09:05:09 +0000
X-Mizu-Trace-ID: d4bf1921e088497c
X-Migadu-Flow: FLOW_OUT
Date: Mon, 16 Nov 2026 17:04:56 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: chengming.zhou@linux.dev, david@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org
Subject: Re: [PATCH v2 2/2] mm/ksm: add initialization helpers for
 scan_get_next_rmap_item()
Message-ID: <avrHOAm9pHXss3dT@dgvxl46587.localhost.localdomain>
References: <20261115075832.132109-1-xu.xin@linux.dev>
 <20261115080049.132515-1-xu.xin@linux.dev>
 <sashiko-outbox-216493@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-216493@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F731140003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b3rgu1bazp17ea75poy7hizzeeyoa57u
X-HE-Tag: 1794819911-630148
X-HE-Meta: U2FsdGVkX1/LSjXDrL/I26r8mY7ed+wfAYci1fVJDc01A79GGIxdmSTuo3MvFojYWc+WA5rfo9X0fh3QpyaQrUM6bG2sEsoKdg8GgFvBlQGCQWCHK5QeCE7/Tiy7oNQKTRd3DH5m5IrfMJ4pCSXjX6orTxBlEzY1fF16cthxc7OVE9KAgfokURrQHpGyEsCw4C5l7sWUO5N0sdhAW9IS2ceU+Rr5WEzjZOpjT86+gU+5dP5lWqGQ2PlJuKr4rHIY3HIVpDLLvapITNCh4Tul57f78vA7SG7Vp3gjN9Rdl50X1aVHCzO42UpsEoUTWLge4xMPRwz4cjpXWYXkcnSSaR2YzDnMuaP62kFc7OSU4YwIjN/WcxXnF9aenYQmBKLMaY82ZbATNLNcyvKONCtHpApV9QxR9OnU9icWtgXQSrSY7SrcFpOdC88ipAGdtBCceFhxRktHM64sfok00h/GvsItccJJ7Hvx7dv2/lPUW4SpCZebN2Miek5B5Eo0CD+6qyeIbuwsvFG9XUuGxxj1zFaWQudqn646tU/PZdZOmYCRRPzd4+6tAMnCbi1OAe1xwPpGmaJSrOaHMmc7yh3gU/4feTYVqayFXbDiF37SxMaecPp6FDRAQmcdAffQk5c7B5yC7j8kLSwiI33uJY6MIGOEzKZ10uBXCpQrMq/tudyKyz9e6oYJbINQm+JLe/gI6WokKudBYKcKNUhYzsKSbFEMSXTYPh1UWcOXWcGNjRSVfWZ03LcBuPY79h/Dcosfo0OluZEOVh3mRVqhwRhulSzlrYXVYYzfntfyy9B9ZYlLFwD95568lbpU2F3jMPXsDPbFclcm4NRZrufwrlohWEjOqUoGxyCe/jTSAbu6P0WoEMWAOoQzZId4cC2jUE8Zs1fJY6dHAN3MTfvbrqm3DaWhELiVsUQsoUoBMCY+rPgVkENaAhO7METhEHqGISv1/LsSWa+GkcnzT+fOW7C
 wO2ESf+Q
 tXcg2QdVYS9eqkDo+jPVLnkW5Xf7+khM3fnkKvrdExHOrxJz+g2o/yLqAx+OGvOilW+II/DLCCxNr4aS8p76kfNhq3dKkNH9JlVGYHPY934fJSVmUeQpaxYBHYDg9bHGJpXJVF10a+P3TqB7VWD1yDjnTx3sLdm2DNwc8sUwdqK9MdlI3aTWqp0Qm0IPY5N/FvdwthNiwjNAN4XLQTilPrKm266we3eXglJFLp2F7dKinF/gYuqTW7BJTEUYQUAr4nqxpYiqOAjEf6JvpGWrajWfnlcnYi+69yeCt7EG48H1rOYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 08:01:01AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/ksm: uninitialized mm_slot dereference in
>   scan_get_next_rmap_item()
> --
> 
> commit c379de4f41203759cd851dbc9790adb7f3dde0fd
> Author: Xu Xin (vivo) <xu.xin@linux.dev>
> 
> mm/ksm: add initialization helpers for scan_get_next_rmap_item()
> 
> This commit extracts the new scan cycle check into
> scan_should_start_new_cycle() and adds scan_get_first_mm() to advance the
> scan cursor to the first mm_slot in scan_get_next_rmap_item().
> 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index b81a49c65030b..7d0f4bad53b28 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> 
> [ ... ]
> 
> > @@ -2662,8 +2690,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
> >  	if (list_empty(&ksm_mm_head.slot.mm_node))
> >  		return NULL;
> >  
> > -	mm_slot = ksm_scan.mm_slot;
> > -	if (mm_slot == &ksm_mm_head) {
> > +	if (scan_should_start_new_cycle()) {
> >  		advisor_start_scan();
> >  		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
> >  
> > @@ -2682,17 +2709,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
> >  		ksm_prune_migrate_nodes();
> >  		ksm_reset_unstable_trees();
> >  
> > -		spin_lock(&ksm_mmlist_lock);
> > -		slot = list_entry(mm_slot->slot.mm_node.next,
> > -				  struct mm_slot, mm_node);
> > -		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > -		ksm_scan.mm_slot = mm_slot;
> > -		spin_unlock(&ksm_mmlist_lock);
> > -		/*
> > -		 * Although we tested list_empty() above, a racing __ksm_exit
> > -		 * of the last mm on the list may have removed it since then.
> > -		 */
> > -		if (mm_slot == &ksm_mm_head)
> > +		mm_slot = scan_get_first_mm();
> > +		if (!mm_slot)
> >  			return NULL;
> >  next_mm:
> >  		ksm_scan.address = 0;
> 
> [Severity: High]
> Does removing mm_slot = ksm_scan.mm_slot leave mm_slot uninitialized when
> a scan cycle is already in progress?
> 
> mm_slot is now only assigned inside the scan_should_start_new_cycle()
> block:
>

That was missed yes, V3 already fix it:
https://lore.kernel.org/all/20261116014655.310486-1-xu.xin@linux.dev/ 

