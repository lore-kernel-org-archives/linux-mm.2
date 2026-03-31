Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89EA9FF60C5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0B86B008C; Tue, 31 Mar 2026 00:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61686B0095; Tue, 31 Mar 2026 00:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77656B0096; Tue, 31 Mar 2026 00:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6ED66B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:14:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46AD11B9030
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:14:28 +0000 (UTC)
X-FDA: 84605041416.25.F19D042
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 71E0920007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:14:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FcX3e4P7;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774930466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuvZGNCpc5ageytlY+oW5uy/i3LviqcbXfIayS0ZEo4=;
	b=iSJOoZAr6+ZiiO42Ac/Jrkv/TbY8zK9YE3lB7bB9AAkm1/LOw7jdSPLEYUQuA+5G76sxWe
	rjhACAnG2ywb0WSIFf9sKPI/F3BJAWs3fQ82uRqFlvgzPoaX2dATVhuvoACGNVCTlRXMAc
	AjW+m6TYdLJQMOiYHRXWDQ9PeWQVFGw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FcX3e4P7;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774930466; a=rsa-sha256;
	cv=none;
	b=RiPoc7wzw9EwSnpXwr53vDaZIDUThhUXTCjbZLdy6uqKnEKpoiTIiS6r/SUhdrtnH116JI
	c8XtYmSU/4IjIH6qsOoBeHFmAbnJJZLvxv6JRVGXU3QW4FBN/nqn2ijvCB9sx27UqumUq9
	hmaF8rIjJAjiQmMjTujL0jdgOMWyGGU=
Date: Tue, 31 Mar 2026 12:14:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774930462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OuvZGNCpc5ageytlY+oW5uy/i3LviqcbXfIayS0ZEo4=;
	b=FcX3e4P7G90Em1TGT4P7k+9itASOOUWQnxeESkUIj+27i1UH3ormvlgY7HCvuoiRRMBA6l
	lXYcZ3Gf/YkfxFK32SiHdYGDgERj3aVEiKC/C6XwGceTs5kHHDse2G3Z0KgbFVkCXrbgLZ
	DEyKHQH0PKcqCB/B5OkMnpJiJvCgveI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: osalvador@suse.de, akpm@linux-foundation.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, joshua.hahnjy@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <lj2h4mig2za32bi5gnxmeh7gjshd2gwa45zl3xhot4cjsvtwsv@5jjtp2el3yn5>
References: <20260330035941.518186-1-hao.li@linux.dev>
 <5de08585-fd2b-4395-b421-99c7b887aa8f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de08585-fd2b-4395-b421-99c7b887aa8f@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 9cd4oyh7ppgopyoibgum43m5zir3o6bb
X-Rspamd-Queue-Id: 71E0920007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774930466-49517
X-HE-Meta: U2FsdGVkX1/14Rrk9llvdQ+fJ/CpE7daZvtDke86z7SbQcCxy2IAXBNWuHT3c3GBDUmBYUy4/cPtvmRZTGjklmNhiAtrGiyIX6bPq4lRogmLBEfH+db0/yRrmEf7BPB8PYY2h5I5uNuxD2/u7biardsAZT/6jYCHKCqZCgbLQjZMXDlTWACoL5FSYKEhyNpFHjcOrBJfhQ0/A1A2TPNSZcIbMURpXkioCSyzmuYh/4qxd5F0WfnxR2moa0Yj0tU4lyY69tDrJeaGsN8cvM1chiUlox4HpJvuVixCEaqrQrhM3f9lW4FKU0AYgFvDFD26XKbg5hi0LsSIkLuQ+DihWVQFOeDcihG0FWv5UAqvJ2RjZYWBHGr7TTddkeu13wa+LHEUcAJNMZRgG/hRlY21G9GcVcKbyJRFjrWaR1dV+tBZNyZ7LP24RlHBEpjPi9Uxqg+hDbQqsMIEqy5rxzLLtKI+q2H/OU2gBfd6fq95sovOqzlsaB2gAKuthEIWPXN5cONly+OlkW10AdITDJSJ3UiSABIJul+ev2RF6+p1Fr+0abcetjtRII5fZOqLC4Z4+zX48M7ElPG/XlOEz26I13RQLe6ufc/2L9gg/Uo8ri6uGx2LQFQVqIQn211GMUrAXc72J7aTZLpXcsPUaU2kxzHiQa45Q9dBdQL8xuRDxzaeDekAkJI3xijiHJ2/NjQTwXaHZVajFgPjneKzPDol0+fvm5pRetCD9rCnXXU8/mcziowtqeI3q61e0yfQE7OMN6beCoc8QhBu+dMc63qlzI+eDrx5quICssmWa4JOPJJY9cdkkeR39IkxitSwdMZAdzKfRjNoOzfUqaRCmzzcv9YguhL29tsUaNgcGrcPYxzpyfZt/y7z6L5b+eI36iGfS8aA8D69Is+TCutXC0iPEhCRA3AExn16KX3ws0JEfKIaE7uKSoJRCTidkO5BR1RBMlBi8x9SthpyVyVJ7dB
 V5gwKZ+h
 xu6hkLXh45gN8MPE6tKzK2PHOi6ETqv6tw+sTtLuc5aPf2etiVNSJRt2verMBTEvjJWuln1mFvRclIW3JqZf6q8AACKAEtV6y3IqTMBI+7fBv3m6pLSfbGMHkIy8bjz1P1NYM2yGkAPYvX+rZlDsLYtVYPFE7W6sx259tTnuSgImBotLRfLoa2M07zRzWkJKScQ8+6j32JwqpSqH+2ku+28/qlbFy52KN27O1k2ulpYHACged0l/oH+arE84JsAEn6WoBjW5P96VH7DRIXsB4b4FdHPyK9Ai1/O921Kl1SnEHo2WErbHwxkrdSQ/3lVc59KSJpFFxgBnjrME9mkAs0VxU7JA3Zpu2hKCmqIQAverJ74Hly1hR8NH7Rx/NfCefWvw7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 04:20:23PM +0200, David Hildenbrand (Arm) wrote:
> On 3/30/26 05:57, Hao Li wrote:
> > N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> > hotplug currently only updates N_MEMORY. As a result, a node that gains
> > normal memory via hotplug can remain invisible to users iterating over
> > N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> > incorrectly marked as such.
> > 
> > Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> > offline_pages(). Set the bit when a node that currently lacks normal
> > memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> > offlining removes the last present pages from zones <= ZONE_NORMAL.
> > 
> > This restores the intended semantics without bringing back the old
> > status_change_nid_normal notifier plumbing which was removed in
> > 8d2882a8edb8.
> > 
> > Current users that benefit include list_lru, zswap, nfsd filecache,
> > hugetlb_cgroup, and has_normal_memory sysfs reporting.
> > 
> > Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
> 
> Agreed on CCing stable.
> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> > Changes: simplify the code. (Thanks Joshua and David)
> > ---
> >  mm/memory_hotplug.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index bc805029da51..05a47953ef21 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1209,6 +1209,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
> >  
> >  	if (node_arg.nid >= 0)
> >  		node_set_state(nid, N_MEMORY);
> > +	/*
> > +	 * Check whether we are adding normal memory to the node for the first
> > +	 * time.
> > +	 */
> > +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> > +		node_set_state(nid, N_NORMAL_MEMORY);
> > +
> >  	if (need_zonelists_rebuild)
> >  		build_all_zonelists(NULL);
> >  
> > @@ -1908,6 +1915,8 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >  	unsigned long flags;
> >  	char *reason;
> >  	int ret;
> > +	unsigned long normal_pages = 0;
> > +	enum zone_type zt;
> >  
> >  	/*
> >  	 * {on,off}lining is constrained to full memory sections (or more
> > @@ -2055,6 +2064,17 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
> >  	/* reinitialise watermarks and update pcp limits */
> >  	init_per_zone_wmark_min();
> >  
> > +	/*
> > +	 * Check whether this operation removes the last normal memory from
> > +	 * the node. We do this before clearing N_MEMORY to avoid the possible
> > +	 * transient "!N_MEMORY && N_NORMAL_MEMORY" state.
> > +	 */
> > +	if (zone_idx(zone) <= ZONE_NORMAL) {
> > +		for (zt = 0; zt <= ZONE_NORMAL; zt++)
> > +			normal_pages += pgdat->node_zones[zt].present_pages;
> > +		if (!normal_pages)
> > +			node_clear_state(node, N_NORMAL_MEMORY);
> > +	}
> 
> Was wondering whether we could just do an early exit, like:
> 
> 
> for (zt = 0; zt <= ZONE_NORMAL; zt++) {
> 	if (pgdat->node_zones[zt].present_pages)
> 		break;
> }
> if (zt > ZONE_NORMAL)
> 	node_clear_state(node, N_NORMAL_MEMORY);
> 
> But ends up being harder to digest (incl. all variants I tried :) ), so

Thanks for exploring this.
Yeah, this looks like one of those cases where we have to make a bit of a
tradeoff for readability :)

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for the Ack!

-- 
Thanks,
Hao

