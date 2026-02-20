Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72323C54FCC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175C86B0088; Fri, 20 Feb 2026 04:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8C26B0089; Fri, 20 Feb 2026 04:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004866B008A; Fri, 20 Feb 2026 04:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD41F6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:00:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10C9313C122
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:00:23 +0000 (UTC)
X-FDA: 84464238726.27.9589A97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39F8B4000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:00:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJJ6MXPq;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771578021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKc+SvTfAui4OI1VedgmPOdZNW6OIq+gVJx99Iag7Sg=;
	b=M6PzEeAx7ifdXV5YR2REZw3guHKm3ExTEZY94hMGecBZuW7EVeql6q2LTQXs58gZ4DK1mZ
	ttUKVtgVlyRD3XsGZ+bhsNmkWocoBNZNpvX5Ny4QbBz0DPE610hV0bUX/tBhXPDx+dx1km
	uibBjPahlhBxfYjmPr0HTYMVQ99FFQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771578021; a=rsa-sha256;
	cv=none;
	b=nA0jr4+fJZV/PjaU1pa7nNp3iymflN3AQdQbdcHwMQblDDdmL3Yg5hzk3iSb+YEboiXTkX
	Yi9E/01l8JuCQZ3pZoGLnFjwD//5ZDHJRgwjHBnii4BCdFvSB6zNod/N9AFE/OL4XY7HZd
	Xh21xPChoMTAnfDt3w6rY6/n66imoew=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJJ6MXPq;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC24A40701;
	Fri, 20 Feb 2026 09:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF8EC116C6;
	Fri, 20 Feb 2026 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771578019;
	bh=826RCgeux0J7V9rnDoaH+iz0F8Wz6TGCLq8GklruRx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJJ6MXPqpDrRBXIJe67I6vn9CBc+wAOHhvMqkAXUWTpLokJqrHfd916FFBxbI4DyC
	 5qkVVOypiJCLBOSItGdvZ8T6KoqTXZVXtXH4/XS16D/1dt5nzcyqMJkCTW7L5tfBxS
	 3kit0fGzXR6Lvun4+HwmbcYLsC7j6SUBjxBqcj4YepaErhBvYf7ckw2vMFnUB6l5vn
	 SulqGKrgw0oHQoZaZQbKnaGcMoOxyIGp62Di4UwIYVpjwQm1USTHVmv8A50XK+mi1w
	 oGE6piBuDyrjrlu9f5ET8DTN6WTB+MJ4RkzT/aFBwIhmkvNPPLCJL2T/rf97BZHf6M
	 EUjGIkyUkXz8Q==
Date: Fri, 20 Feb 2026 11:00:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
Message-ID: <aZgin4snWf0RD98X@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
 <aZVyxKVS8y-rqwrK@kernel.org>
 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
 <aZbjCFqlqdFwKSHR@kernel.org>
 <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: tx6omtsbwghrnfsfo71tzbn5zfqddm84
X-Rspamd-Queue-Id: 39F8B4000A
X-Rspam-User: 
X-HE-Tag: 1771578021-545407
X-HE-Meta: U2FsdGVkX1/6xY3wXMQhRVLZMSJkb4JlMbg/MD5Ghdr8tOn0y+yIkA1f9B+sM5gW3276X0GszHI7IFvATHk4VxOSyiRxZUN9AhsFeXctliN+W4b62ErRNN4ytbDqxAhj391IJAhas15K5oxJOHFgQB70hXwlwn/yoET/dccWuPYgoPWwssv6ljBOqLM7MVqNqAyXoH6LjMXtrNM/MsjKVsA3WXFQnAaQ//nPE1evxAAyEdJLKDdB/CKzB93JuPAoMwuLhBhchiD0+7xzVmbQZfBJQBwZvqI6p+AUfhskTIf8xuko1NY51QiTRHtozxvBXsIEqhEpeYQ3+Pil5/0q81unXlEsGC7JlixYX3chxQ7f989ZOs4Y1NR5YCYNq/8l8rTJ7PQnewek22I8CQmrlFswTbEvfFQbzmAnDwVS/AFv6bYMLIXoKCi299CReyTAghdSbib0EVC4QnYuFYGO+j3rxybeUIv+eME3fe0LOIOTj/F/WxBiCHmCy+VmLSYWatfL0W+Q0JG/ch32Jp56v4SXQjZWO0op0GzyD1100IMfWF9ay3FyxQ0ie8hVCpAYoV6bAc/bINnGD38ZFpvbxXAO7EFZoh4GVoV1luScsQ3LjMsAl6gr5U6ODj3IDRELDJzoLA5rQJIY5VP5HMxB1UCMbN2ZRib5KhztMgiyAyRyJ4P2hsED+lItdjFYURVS41gg37C4Tl3efqOo5cewlZDo+diisdGT3PvtJG51kR1q5eDvikKe9OENZUlIUPEVl0qfoM4lSedXNTcLkP4yyjwaNI5oEcKJNxiKrFyZBct/ymBuRbtERCXsH37PzCC4ST3UvptwVo5aJAE7uZMwncCyLwDlffRCA+eGbI7oz8nofsHrJ66eZVDOikmB9zVp1K2n46/rRH3IilwdGM7/0/YOPOhQM9pmhk5s4tzrm7m7lGIc+7cukK5gfEKVSTFHw4BKkSiN+vtV4LwZOyb
 8XRvS7CW
 5H/oKONBWGJCEWzZ+gZCa6GIBK9HE03mPH7LvoYCl1/N2Iuc4t74dmAB+cT7jnqgieA9QLuxzOrhbUblRcUcP78QbcZE6gvxQPxgelOkh6B3CoWKlLXrRjmAyYqTSqo5dhPBQt3kY1wWy6coECia6+3/UUxNIgN+tlSkphkOylIJK+NbnB58nZi6rY9cZtQm5vW0M5DdzB3OrQn3oCsze7bUbP8TxTFUQhmbYiW+eMph9QlTXWjVOCsOZFUkdrcgKPHwSW3xuuoSRqh6Cn5uwyfbYyMg5kwCbCJXFEDxd5Yfnul7S2OEseQwp6fVQDJX65Dh5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 09:46:50AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2026-02-19 at 12:16 +0200, Mike Rapoport wrote:
> > 
> > Let's split it. EFI does weird things with memory already, like mremapping
> > normal memory for example.
> 
> Yup.
> 
> > Here's my take on the split. Lightly tested on qemu and recovered ~45M of
> > ram with the OVMF version I have :)
> 
> Nice :-) I'll test this here.
> 
> > > 
> > +struct efi_freeable_range {
> > +	u64 start;
> > +	u64 end;
> > +};
> > 
> 
> Haha, you went the blunt way :-) I was trying to avoid creating yet-
> another structure with "start/end" :-) 

Well, seems to me the easiest and the most efficient :)
I could have used "struct range", but I don't like it's semantics with
excluding the end. It would mean adding/subtracting 1 everywhere, seems
error prone to me.
 
> > +
> > +static struct efi_freeable_range *ranges_to_free;
> > +
> >  void __init efi_free_boot_services(void)
> >  {
> 
> I was going to call it efi_unmap_boot_services() to avoid having two
> things with almost the same name.

I wanted to minimize churn, but in the end it's not that much to change and
efi_unmap_boot_services() is a better name.
 
> >  	struct efi_memory_map_data data = { 0 };
> >  	efi_memory_desc_t *md;
> >  	int num_entries = 0;
> > +	int idx = 0;
> >  	void *new, *new_md;
> >  
> >  	/* Keep all regions for /sys/kernel/debug/efi */
> >  	if (efi_enabled(EFI_DBG))
> >  		return;
> >  
> > +	ranges_to_free = kzalloc(sizeof(*ranges_to_free) * efi.memmap.nr_map,
> > +				 GFP_KERNEL);
> > +	if (!ranges_to_free) {
> > +		pr_err("Failed to allocate storage for freeable EFI regions\n");
> > +		return;
> > +	}
> 
> Do we still want to do the whole unmap dance in that case ? I mean, OOM
> here means the system is pretty much a goner at that stage but ...

There is another potential OOM in that function. If it happens, we just
skip remapping and return. So return here is consistent :) 
 
> >  	for_each_efi_memory_desc(md) {
> >  		unsigned long long start = md->phys_addr;
> >  		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> > @@ -471,7 +486,15 @@ void __init efi_free_boot_services(void)
> >  			start = SZ_1M;
> >  		}
> >  
> > -		memblock_free_late(start, size);
> > +		/*
> > +		 * With CONFIG_DEFERRED_STRUCT_PAGE_INIT parts of the memory
> > +		 * map are still not initialized and we can't reliably free
> > +		 * memory here.
> > +		 * Queue the ranges to free at a later point.
> > +		 */
> > +		ranges_to_free[idx].start = start;
> > +		ranges_to_free[idx].end = start + size;
> > +		idx++;
> 
> Do we want to make this conditional to CONFIG_DEFERRED_STRUCT_PAGE_INIT
> or we don't care ?

I think it'll add ugliness for no good reason. If we want to keep systems
with CONFIG_DEFERRED_STRUCT_PAGE_INIT=n behave the same way as now, we need
several more if (CONFIG_DEFERRED_STRUCT_PAGE_INIT) and it becomes hairy.

And the change is quite small IMHO to just make it for everything.

> >  	}
> >  
> >  	if (!num_entries)
> > @@ -512,6 +535,23 @@ void __init efi_free_boot_services(void)
> >  	}
> >  }
> >  
> > +static int __init efi_free_boot_services_memory(void)
> > +{
> > +	struct efi_freeable_range *range = ranges_to_free;
> > +
> > +	while (range->start) {
> > +		void *start = phys_to_virt(range->start);
> > +		void *end = phys_to_virt(range->end);
> > +
> > +		free_reserved_area(start, end, -1, NULL);
> 
> I assume here too the total_ram_page_inc stuff is taken care of ? I
> haven't really looked. This feels like a fragile counter.

This is a fragile counter :)
free_reserved_area() -> free_reserved_page() take care of it.
 
> > +		range++;
> > +	}
> > +	kfree(ranges_to_free);
> > +
> > +	return 0;
> > +}
> > +late_initcall(efi_free_boot_services_memory);
> > +
> >  /*
> >   * A number of config table entries get remapped to virtual addresses
> >   * after entering EFI virtual mode. However, the kexec kernel requires
> > 
> > base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> > -- 
> > 2.51.0
> > 
> >  
> > > Cheers,
> > > Ben.
> > > 
> > 
> 

-- 
Sincerely yours,
Mike.

