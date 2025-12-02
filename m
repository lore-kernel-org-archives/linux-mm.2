Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE62CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FCA36B0098; Tue,  2 Dec 2025 05:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885FF6B00A0; Tue,  2 Dec 2025 05:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774936B00A1; Tue,  2 Dec 2025 05:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 615F56B0098
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:57:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12427132683
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:57:12 +0000 (UTC)
X-FDA: 84174229104.28.33ABD7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7142CC0010
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:57:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jLYtwR9p;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764673029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVvaF4tud88Go43Oxm56V+MqzJQbkM9OqxsNw72ERWM=;
	b=UNaSPcRFOkO/Zi/Hw+ZLcV3DrzaDooeW4rqvM/RfDkc6wwK8P5Q8QeY3h7y3VOxwZbl5sg
	mT2WQg0vE7lSGLObk8SZTnuLEY4BKoXnyVKEvd9J4XDmM54XbfpoSyffgF5LuDOd1jy1T1
	toO7ztJMz/9zTcG4NfuVarAUGhA5hzk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jLYtwR9p;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764673029; a=rsa-sha256;
	cv=none;
	b=QWGAaP8G4uZq5FxsUD9l8YZW1DbbcR3yGyF77elYZch97+6tDeEKdgkVuBvvKotQQ3cDxT
	dw7SJq+Az+92QNuOzvq3hpWoDMGHMAT3R/W8lvHaWZOcEBa3GZRbKn8L8eSCbacgY4KrCA
	JD/72jJ+pgZ4JRa04BH3eWkDswZSoDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70DBA60139;
	Tue,  2 Dec 2025 10:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09421C4CEF1;
	Tue,  2 Dec 2025 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764673028;
	bh=PYrUdY1NU4nISxSv29OFIk58y1zwHcGNkFsZHi3SAdk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jLYtwR9pvYhlPyqJ45JOeG/uOScsGPl42Udz10SQbgkMMZxiO7JBA0cFpkkTMpW+2
	 yv/PSZw/yfPYyLnNbR/yEjIqBWzqwMB/wuQsvGoT84yfSWFu7koDlaxMVkZpm3RCGB
	 ULMih6gYRNHkqClQ48qgkIe1UWZGc+vswMy6GOP+XOc63wl/bZpaDpmgF+n7yfjlh/
	 HZx7fn1oVDB0o1gF/eNPOANkmYIPfktqtNhOTvo9QSNAaAha5KyrGfiGycJdvwY7fC
	 cEKP51K0ldlMSTUz8WcRmxIkBgYfGESDwBIjH5J7I7zNZKE+dtGBfXkknr+LKUrjfQ
	 q1nmR8jhtI6wg==
Date: Tue, 2 Dec 2025 12:57:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
Message-ID: <aS7F_ORMLBcAqQTz@kernel.org>
References: <20251201132216.1636924-1-tianyou.li@intel.com>
 <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
X-Rspamd-Queue-Id: 7142CC0010
X-Rspamd-Server: rspam02
X-Stat-Signature: f6s77memmcgxeftrnt5fizd1ifnsqxjq
X-Rspam-User: 
X-HE-Tag: 1764673029-800306
X-HE-Meta: U2FsdGVkX19PbgrTr7lOTPPkZRPHJ9Ebes1An0aum+/xePlufI52d5RiseBS38saazVBjjmi7jZ0Hy8jDRMncMILm4rIZWK9oAUistAPkerob4hDMUsKHLzOvSxwTvjvQsUpTpbnCaFmB6PSUXObV5FqOlG6MMHiWGJlH17WN2xCEKiTEYsD7PBgeeDtFIbpzvB2XT6KVKbrQZYe6w7Aq/T0bz+TTG8UG8nw0ss1Q0NosG8RMVj/FGMINi0X5rZ53bu3ejkAR8dwByW/D40uQ1wsmFOfpp6cNMr2M4qXiUXyMekICckuv8VXRq33NrrMQqsHf2IRBt91DZZcW8ZrM6KIG/nGJx54/4PX1WYVpgvSMDpbi0jZBPYU0sdpi+BjQDy44D5jZtUfRLKjQlsrvsjFjx+/kBzebNa94JeROFH4RA+FWBddZbslag2QRmNCfkuskO3IFleBrzAn4GEZlNbx47P+qLIzBs3i+l9UxZSIu1BANaBxmM65mbJT5DAIcfFRYvyuD2rflvzfBcTgUUTmjY97jyycCNiz7HtLQ3OzVRS8uFX6q55Kgmluk+yy3xHHqPY5Y+1gtE7miMjhO9jq/islYxtmke14DCCWoWRjPV96d5NoYLBNg49OB0ku5DmXBBMCqMuFKDr05mnk1Yz7Jvhduf3lRgclCBHm7Y0tovqNRSvVZ6t2mQxo9YVglCW1OpigIzIv3Oc/ai2OF7TKjpxgkqGMvrN2mAoY2wpBGZFq+imEMFR9yY+8emptwBLKYhjU3QFaAlVuuTwbhvvSEA7UWdcgGMYBdL5uSUuIAv8+mmk5Kf9TZS9ouOaDmI3MuehtXsAlDqpQetsLgiTm3lDswY61q7eLhXrxWLrwu/99HdtISdCErmm98wjwas0kfZ7kEf61vEMLunEIaAxhsowuvlsPiureTr5qg+ytkmDKha40cDtE70GWxi8Vxx/jaSxkJpAqckgYJ38
 jiaeHetP
 qt82gFcUaq7t2SMf0zPdksbvV/8Q7ngR4tYR+4Mby43ZAnAyV1NzkXeBvuaYhCVOboWQokUAY44XSHDiu3cXq6a9tUo2c5y5w5bOnFb5HcrhuzQUo21Kv0IytKrO0ym1bBqWrnqqZhGZ80sF1feRnIIbSrgfO5Bx/H1fe1+yHEr1RarAwUn3w+JzzUnEf1R0IwtGr8tDCrM7fcZl9jPc/GI6Bq25qf1ZW0n0wxEIMvK4akTDsKe0vr1XNmtRzewiTmci+KSBO20ZNmGOUZnr2xkW9SRdp9BGctdMdFUpiTqWF1xNX2ekVi0J84O0rKyIx2sEMWE/B0k55sTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 07:54:34PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/1/25 14:22, Tianyou Li wrote:

...

> >   void remove_pfn_range_from_zone(struct zone *zone,
> >   				      unsigned long start_pfn,
> >   				      unsigned long nr_pages)
> > @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
> >   	const unsigned long end_pfn = start_pfn + nr_pages;
> >   	struct pglist_data *pgdat = zone->zone_pgdat;
> >   	unsigned long pfn, cur_nr_pages;
> > +	enum zone_contiguous_state contiguous_state = CONTIGUOUS_UNDETERMINED;
> >   	/* Poison struct pages because they are now uninitialized again. */
> >   	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
> > @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
> >   	if (zone_is_zone_device(zone))
> >   		return;
> > -	clear_zone_contiguous(zone);
> > +	contiguous_state = clear_zone_contiguous_for_shrinking(
> > +				zone, start_pfn, nr_pages);
> 
> Reading this again, I wonder whether it would be nicer to have something
> like:
> 
> new_contig_state = zone_contig_state_after_shrinking();
> clear_zone_contiguous(zone);

+1

> > +static enum zone_contiguous_state __meminit clear_zone_contiguous_for_growing(
> > +		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
> > +{
> > +	const unsigned long end_pfn = start_pfn + nr_pages;
> > +	enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
> > +
> > +	/*
> > +	 * Given the moved pfn range's contiguous property is always true,
> > +	 * under the conditional of empty zone, the contiguous property should
> > +	 * be true.
> > +	 */
> 
> I don't think that comment is required.
> 
> > +	if (zone_is_empty(zone))
> > +		result = CONTIGUOUS_DEFINITELY;
> > +
> > +	/*
> > +	 * If the moved pfn range does not intersect with the original zone span,
> > +	 * the contiguous property is surely false.
> > +	 */
> > +	else if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
> > +		result = CONTIGUOUS_DEFINITELY_NOT;
> > +
> > +	/*
> > +	 * If the moved pfn range is adjacent to the original zone span, given
> > +	 * the moved pfn range's contiguous property is always true, the zone's
> > +	 * contiguous property inherited from the original value.
> > +	 */
> > +	else if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
> > +		result = zone->contiguous ?
> > +			CONTIGUOUS_DEFINITELY : CONTIGUOUS_DEFINITELY_NOT;
> > +
> > +	/*
> > +	 * If the original zone's hole larger than the moved pages in the range,
> > +	 * the contiguous property is surely false.
> > +	 */
> > +	else if (nr_pages < (zone->spanned_pages - zone->present_pages))
> > +		result = CONTIGUOUS_DEFINITELY_NOT;
> > +
> 
> This is a bit unreadable :)
> 
> if (zone_is_empty(zone)) {
> 	result = CONTIGUOUS_DEFINITELY;
> } else if (...) {
> 	/* ... */
> 	...
> } else if (...) {
> 	...
> }

If we update zone state outside this function it can be even simpler:

	if (zone_is_empty(zone))
		return CONTIGUOUS_DEFINITELY;

	if (nr_pages < (zone->spanned_pages - zone->present_pages))
		return CONTIGUOUS_DEFINITELY_NOT;

etc.
 
> > +	clear_zone_contiguous(zone);
> > +	return result;
> > +}
> > +
> >   /*
> >    * Associate the pfn range with the given zone, initializing the memmaps
> >    * and resizing the pgdat/zone data to span the added pages. After this
> > @@ -752,8 +821,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> >   {
> >   	struct pglist_data *pgdat = zone->zone_pgdat;
> >   	int nid = pgdat->node_id;
> > -
> > -	clear_zone_contiguous(zone);
> > +	const enum zone_contiguous_state contiguous_state =
> > +		clear_zone_contiguous_for_growing(zone, start_pfn, nr_pages);
> >   	if (zone_is_empty(zone))
> >   		init_currently_empty_zone(zone, start_pfn, nr_pages);
> > @@ -783,7 +852,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> >   			 MEMINIT_HOTPLUG, altmap, migratetype,
> >   			 isolate_pageblock);
> > -	set_zone_contiguous(zone);
> > +	set_zone_contiguous(zone, contiguous_state);
> >   }
> >   struct auto_movable_stats {
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 7712d887b696..06db3fcf7f95 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -2263,26 +2263,34 @@ void __init init_cma_pageblock(struct page *page)
> >   }
> >   #endif
> > -void set_zone_contiguous(struct zone *zone)
> > +void set_zone_contiguous(struct zone *zone, enum zone_contiguous_state state)
> >   {
> >   	unsigned long block_start_pfn = zone->zone_start_pfn;
> >   	unsigned long block_end_pfn;
> > -	block_end_pfn = pageblock_end_pfn(block_start_pfn);
> > -	for (; block_start_pfn < zone_end_pfn(zone);
> > -			block_start_pfn = block_end_pfn,
> > -			 block_end_pfn += pageblock_nr_pages) {
> > +	if (state == CONTIGUOUS_DEFINITELY) {
> > +		zone->contiguous = true;
> > +		return;
> > +	} else if (state == CONTIGUOUS_DEFINITELY_NOT) {
> > +		// zone contiguous has already cleared as false, just return.

Please no C++ style comments.

> > +		return;
> > +	} else if (state == CONTIGUOUS_UNDETERMINED) {
> > +		block_end_pfn = pageblock_end_pfn(block_start_pfn);
> > +		for (; block_start_pfn < zone_end_pfn(zone);
> > +				block_start_pfn = block_end_pfn,
> > +				block_end_pfn += pageblock_nr_pages) {
> > -		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
> > +			block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
> > -		if (!__pageblock_pfn_to_page(block_start_pfn,
> > -					     block_end_pfn, zone))
> > -			return;
> > -		cond_resched();
> > -	}
> > +			if (!__pageblock_pfn_to_page(block_start_pfn,
> > +						block_end_pfn, zone))
> > +				return;
> > +			cond_resched();
> > +		}
> > -	/* We confirm that there is no hole */
> > -	zone->contiguous = true;
> > +		/* We confirm that there is no hole */
> > +		zone->contiguous = true;
> > +	}
> >   }
> 
> 
> switch (state) {
> case CONTIGUOUS_DEFINITELY:
> 	zone->contiguous = true;
> 	return;
> case CONTIGUOUS_DEFINITELY_NOT:
> 	return;
> default:
> 	break;
> }
> ... unchanged logic.

I was going to suggest rather to drop 'else' 

	if (state == CONTIGUOUS_DEFINITELY) {
		zone->contiguous = true;
		return;
	}

	if (state == CONTIGUOUS_DEFINITELY_NOT) 
		return;

	... unchanged logic.

but I don't feel strongly about it.
 
-- 
Sincerely yours,
Mike.

