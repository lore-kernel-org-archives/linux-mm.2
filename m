Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F672C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675AF6B009E; Mon,  6 Jul 2026 08:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFFC6B00A0; Mon,  6 Jul 2026 08:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7F76B00A1; Mon,  6 Jul 2026 08:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24ECB6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:50:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9650B12040C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:50:21 +0000 (UTC)
X-FDA: 84958335042.05.0A94055
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A15E40007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:50:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9iHldaB;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342219;
	b=gmQWwLixFW3cNvlbpTsNh9LbLPDtDcc3otE6aJg1/MYhDgfmPGeSdCeu00Dd2qmmRRGe5e
	s+TS3X5YHNchEHdeATkB0zrzmtPmy6drWxKKAPOk80HG4HgHuuziEGxRMhULNzgcb6/ZAB
	SogJeHwOxYLSHJZc/elwV53B2YVmuZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9iHldaB;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/DflsyFZMMMayN88xFKrPbO4xIeLNs4y3Zz8/BKzSU=;
	b=077o7DDnva6pxwy9U0wOENi4uWWEabtrRasihyPl6qfKAW+NhTLg5H4cfgmnIziydvnV0B
	S70DA3qw5dPdNWljWbhX0pgrLLbiRTXR/StukKdsqZu+pGrviMfVa+zCzoF07jZxUXUULC
	14omlbb6npjggH/0YkgRJHmnztSdJ+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48EAF4050A;
	Mon,  6 Jul 2026 12:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB3F1F00A3A;
	Mon,  6 Jul 2026 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783342218;
	bh=x/DflsyFZMMMayN88xFKrPbO4xIeLNs4y3Zz8/BKzSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q9iHldaBZZwuLrQUeNXYgasOU2CPJWjyKJQUSk3YvITH4PYsI74DgvixGO0lHw9w4
	 Ld9xF6TsHb/VZZqOkmpgL/fwpuUkBvgPVGIk9rpG/7B2KIRCWoq0UZbhWixAeR/T5w
	 oAvVGoymC+QqnF8/A5W9jVzeO1xB+k6Et+fSz8g/nDZQywn73t8di44o+mH+rxLer6
	 NGIPWGelihVNAbyow6cNKnmgVXmHwL0BaBwhn99gLKeG4Fku0o4H/8wc3ANkI7mMxz
	 1YC5RHw385RqNOK85Wn6kH/4fzrhsvYcoUpMBNDHkzhFYhHLeKhGFnZCBxJj/n21tr
	 Mav+lDo9u7UDw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id CF10DF40069;
	Mon,  6 Jul 2026 08:50:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 06 Jul 2026 08:50:16 -0400
X-ME-Sender: <xms:iKRLau3SIV1ga2IXEcxmtkspgJYfGXmVuL3kw5AgHScj7JgSkLnQwA>
    <xme:iKRLaopElpCL64HvkrfO71huXOhFjVSIutlxPAW7I-fJjmbShCGbfd-Ei3qG9REUo
    nsTi4haN97ukkKclY3Dal_3ySqhMyNyOIhMdU2WgXzRK7AqfgC6lL4>
X-ME-Received: <xmr:iKRLaj2Dz9O6VscEvBi_NAhvto_QaPXXyX_LFtBxwxibm37O7w9X2gI0WyknAQ>
X-ME-Proxy-Cause: dmFkZTF5xoQbiJ989r5bQ3iWyvjnYkkpnn8LZ7V/DF21MHB1XhwEDrMV3RpigyPZf9Kjbd
    afP+mbhtkFcxAR0V96R7snet1ndSR1y+kbEFZqDtXLcgbSQ0fqMhvpzLpvMrWPvM5KjYDK
    GEc293eRnQOyLMVp814avRhM/uJcgPZF5ND3c5YgaKA2HC866/u0RFdGAaEQfuRV9ZZNj+
    fW6FFAX1knGAG1vcgwAvBk1xRYiQYoB2JtvDNTjC/WAezs+bDmPlNgu7fVPslaFpU1mgUZ
    a3St44qB9vtXtxWWPrw5w90yvN7I9P81VgZ1jhxatN6PE3VdoBWD9+OzK83OWGkY3GCdo5
    KPnKPFF/IECcZSnvNci1MgpUcjxcEAP7zgwvmQYNmJSSsxJCP63svv855l/1yEpypATk3E
    onW8pX/4CnX+4VAr7yQpXm1vQm60XLuen732kMrkEwSW16gqg3qhwaI0Yi4COVhPoDwB37
    IKEY2EuVna9bSVlxZuwLoRxQyg4ilz3KygVsTcogPuefre6ttKXkQy1G1kfOxe+jL/M2mt
    L3FQ+pwqbUfIlpGLH6u3KtB3gW1t/jFSWQRI49xUSLk9N9zn4EEUI33CrYRy5I4t9XxxXF
    t5er9dSmANX5Pz9QmuvacnuL0XCbbBlTrB2wEqBHk5j+EDGg4kD3gS4R8A+w
X-ME-Proxy: <xmx:iKRLatyFzByqhCwGEjDurhUeAk-sai-nDxz9mInfCYQvK0TJgVhYxg>
    <xmx:iKRLaqyemv7b5-LDKueFysi6v2D4mI5Rj9VxJGI7ymQBUxm4715yWQ>
    <xmx:iKRLatrX4A5hWNyvLzjUwfhPt4c2h5qY9sS6NrruEwojOQ-PKGaI6A>
    <xmx:iKRLamrrkYeGFkNlN1mzUUOEy1bMdyOO9kLAgV3Rf9OpyEZt4B_JwQ>
    <xmx:iKRLami1xuE25QEGh4G1OocOqECH4oB2eQiTKH3TuV_6z9PIs0VHWXs7>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 08:50:16 -0400 (EDT)
Date: Mon, 6 Jul 2026 13:50:15 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] mm: extract mm_prepare_for_swap_entries() helper
Message-ID: <akukfKtNVEmdzXPR@thinkstation>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
 <20260706114320.1643046-3-usama.arif@linux.dev>
 <akuXgognmAW0QhOX@thinkstation>
 <642efd6d-7366-4641-a999-2d419fd38f8d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642efd6d-7366-4641-a999-2d419fd38f8d@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A15E40007
X-Stat-Signature: e5wmywrp1ncjc5sko9qfftwmtfmqsw4y
X-HE-Tag: 1783342219-46653
X-HE-Meta: U2FsdGVkX1+U+XwrQyWRPb/9/U7ZGyi9rSvFFiCQ5XWmkhseml1QBMOML6wQXJVQvF8/iKMcZtbvZn5IQdXyjEq/B9QQ5y2vN47gnqCR53dnTT248k5bDcSnTCnym91PLeHyfvB+JpaWA1wGdNASxR4CkkOnGUygNM95rRHjwGdWwN9jVEnLJOvtiQ2nhNuM8A566EcfC5Uq5mw9/Wp7WmCV0ta/eLlfx4xYD25pV0YkdnE6WwmsqHvazMV84ktjsNvF8qGrRwel6kCA7cScFgRSu0fgxIZNn3666ikIt7PMRzoOUtzYUcwnCCY2Q4D15QGIninPtkXvVOjj+piKPylhbmB2+kFVxY6AARnpTaNIr5sYQQsv06BEe7jKVjDwhusEclc0co4IcFsLIK93doCPtMJndvPJgiTXKjafN43x0/XyLht7f/lYVqCC5CG5J0UEWVpZ6fLhAfqsTYs0jo57xJhkoBDOwoHaUjw0dIjPcHSsasuBK/t/SP0/GUp52Vt5zgpCUbeNTbcBbvkTWWfSp31oxupL2D2ubWaakSRA3TBN+JBX0FjUjARiITpisnlPYE/BXz9SuCqkV+jlYpqATRkBt8zuW2a6CQnI1Y2WzDFywe54LPZ56JVaXNJMOkgbfvOiAWy5m/VzhQ4K8EvWlUoq+FuVFoi6wLr7KxrkESq5C3yKayrkPpT1KpYfRVz8dlqngLZ30bHBoy2YYnb3sPfdv/MxusHRXcCESelufInJSZIdUszCgkfSLidm5taEMlG6iSmTGbg0fVUL0p16vb3ZuzIj6AQIngYfOe9cmYg0rdroohGkAfBWC4nijbLoYTEcvzZrzEUYgJ9Bx4wZ6C6P3JbEyaKd1JGWhNxzClXloK/8inVbWO5V7gk5aVKy9ryuHP9A/Wst2l/MZyV0+PBIEY91I4z4Pk48DAXbo/7z4X22fGChUglEE0Bvpx5+pseQIASIr+7XK39
 q4Qd5/hh
 IPrIPcKva/idalzSH45418HyprZI4dnpFcZxbjfyThhH4gghSUk14hFV20p7/opbk0davTAe5W7nc2l4iowzS7+Gi+XrjmNRMeSSj1nrpDuxSxdnNrrFL4xvJqXGjBliBv8yZ5umnuxYtKZjyGwSdHV+kIcZ5oX2nQQ0tHo9YhOLbsebUcuXpUfgHQ2jE3ZGHejjkG8YMk6RvWmDyprvZX1Hwv3T6BnZS7S2wx8C+honM9iwTb97988n1XIEaJc/cuT3JzVJADivfRTNnQPPgOwfa9YPAKoB3Z28J3D23Wkgy2ljTBophOvAy6mVZHiY1aPPJn5s9X7VwmHr/gzzFavgkGYoCAHBgfiHjPP6kl1YgezDLbu/5iCjkkfTaTshx1A2PwPzbu3TkmNjgcFZsEDbIZxwX/IBtERYFQN/RFhe/OTv4MFz6ZPWXGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 01:23:29PM +0100, Usama Arif wrote:
> 
> 
> On 06/07/2026 13:01, Kiryl Shutsemau wrote:
> > On Mon, Jul 06, 2026 at 04:42:04AM -0700, Usama Arif wrote:
> >> When a swap entry is installed in a page table, the mm must be added
> >> to init_mm.mmlist so that swapoff can find and unuse its swap entries.
> >> This double-checked locking pattern is currently open-coded in
> >> try_to_unmap_one() and copy_nonpresent_pte().
> >>
> >> Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
> >> both callers so it can be reused by upcoming PMD-level swap entry code
> >> paths that also need to register the mm with swapoff.
> >>
> >> copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather
> >> than &init_mm.mmlist, but the insertion point is irrelevant, mmlist
> >> is a circular list and swapoff walks it entirely from init_mm.mmlist,
> >> so only membership matters, not position.
> >>
> >> Reviewed-by: Dev Jain <dev.jain@arm.com>
> >> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >> ---
> >>  mm/internal.h | 10 ++++++++++
> >>  mm/memory.c   |  9 +--------
> >>  mm/rmap.c     |  7 +------
> >>  3 files changed, 12 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/mm/internal.h b/mm/internal.h
> >> index 430aa72a4575..0360648e5726 100644
> >> --- a/mm/internal.h
> >> +++ b/mm/internal.h
> >> @@ -1955,4 +1955,14 @@ static inline int get_sysctl_max_map_count(void)
> >>  bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
> >>  		   unsigned long npages);
> >>  
> >> +static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
> >> +{
> >> +	if (list_empty(&mm->mmlist)) {
> >> +		spin_lock(&mmlist_lock);
> >> +		if (list_empty(&mm->mmlist))
> >> +			list_add(&mm->mmlist, &init_mm.mmlist);
> > 
> > The patch is fine, but the name of the field is awful. Seeing mmlist I
> > assumed it listed all mm_structs. It has to have "swap" somewhere in the
> > field name.
> > 
> 
> I can send a separate patch once this is replaced to replace mmlist with
> swap_mmlist if that sounds better?

Yep, better.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

