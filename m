Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90B010A88E3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A046B0089; Thu, 26 Mar 2026 12:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B7A6B008C; Thu, 26 Mar 2026 12:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0097E6B0092; Thu, 26 Mar 2026 12:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E716C6B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:21:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 604641A0C30
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:21:47 +0000 (UTC)
X-FDA: 84588730254.21.5BE29BE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 02A3F40015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:21:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MZslg0LL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SB9KOpgW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IfUaDP01;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pqXukDQ9;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774542105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3lDg9Qo7P0Jt4agnX1ynDtZ4eMvLfAya4JWT6zRJSo=;
	b=ico19pc0mdQvwLiANdkweix1TpynI2KXE7TiRX5XfJXhkMS+zDZvkLlxmZVGGKgt5djMRS
	rKlXg0Y4aZ7w+peEg0iELKoJAyjUB0WRN257ia39mZcY8Zyv9qQpNf+3fTzTSRaRFPa1AC
	SpmZp2PDuQ7+hwRH3l/DDks+gjHSpi0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MZslg0LL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SB9KOpgW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IfUaDP01;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pqXukDQ9;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774542105; a=rsa-sha256;
	cv=none;
	b=wh7UYolLBBV0G/YsFwzX1nv2tKV1+LDI10IGCOOV+3jQDmCkYYQAbmlBIEpch5XBfFSHNf
	BLiNDSwu0j1kzSRsXtAq+K0U1lCGRn2hXNj7aFwEE+McecAwJiYh+n4PRRCVN8dFJRRleQ
	iX0F5i8cI4cjO7t8yoKQQycejGm8m/I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 77BF74D2D7;
	Thu, 26 Mar 2026 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774542103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3lDg9Qo7P0Jt4agnX1ynDtZ4eMvLfAya4JWT6zRJSo=;
	b=MZslg0LLFo7myS2a/8LFdcUOwp+jbWjCjwYxjb9zD7CAq/CsJCSckh5Xhd8X0ONQovrXj6
	vdAlf71ItuZNco3Wp+mTWGYSDIM00xcSc26QSkqIW7Q8Z/N9jkEqZcUhxkD804IZv4b6kP
	vhz79YOxhk+Pd/nM4DAjZyOGb5aXR8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774542103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3lDg9Qo7P0Jt4agnX1ynDtZ4eMvLfAya4JWT6zRJSo=;
	b=SB9KOpgWgaY0QDbUOTSzS7AxJahXkQzMutR7lF7qmFvKiJO+qwek8ZZAroKdOzArdpMNXN
	oT66Uf9hx7hz+8Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774542102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3lDg9Qo7P0Jt4agnX1ynDtZ4eMvLfAya4JWT6zRJSo=;
	b=IfUaDP01F3JH4tgDH5+jfnxK3m3G1zoqejuqCQE6yhtmA6oAwFrdi/+v7rMBKhS6zwD2hb
	azZepBy5BjCsoZCiHZzXYnGoTaf20a+vIweRmXe7jwrEIZbhWhS//HOniOm7orEtE8IWzH
	+C5hfYo6AI0q8FTz0XlPtVsQhoqtvDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774542102;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N3lDg9Qo7P0Jt4agnX1ynDtZ4eMvLfAya4JWT6zRJSo=;
	b=pqXukDQ9LEbKGqBXtMm7qdmWQVl24WRKq0mylAqbUWZzDjLBCa6wMLBXUUaeb9tpKtyeJx
	LpIY+ySA7rp5lfCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A3864A0A3;
	Thu, 26 Mar 2026 16:21:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eyLhGRZdxWlFIQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 16:21:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1091BA0976; Thu, 26 Mar 2026 17:21:34 +0100 (CET)
Date: Thu, 26 Mar 2026 17:21:34 +0100
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Jan Kara <jack@suse.cz>, david@kernel.org, ryan.roberts@arm.com,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	linux-mm@kvack.org, r@hev.cc, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@quack3.kvack.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm: replace exec_folio_order() with generic
 preferred_exec_order()
Message-ID: <4pzoddjdplps6wzf7hluwjg7jty7tmrwkq5jk7qzer4kur5o4q@7ge6uatpmkex>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-3-usama.arif@linux.dev>
 <k45xs6btmt62uerbglqe665jozrtkeoklu4rek6odgxjdj63ni@ftw6ef3ug33x>
 <0ce07bc5-6365-4c54-90e2-4e56ad2b7465@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ce07bc5-6365-4c54-90e2-4e56ad2b7465@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 37b8pj546paqjzh6hnw454uyfym71uub
X-Rspamd-Queue-Id: 02A3F40015
X-Rspamd-Server: rspam09
X-HE-Tag: 1774542104-144140
X-HE-Meta: U2FsdGVkX19MhQJf0ODdIRhvGLCg6mF4nNIqKUXBaBJ1/l5ebjLG36clXxhcutdJVYnFxRIIhZShs3fitVflnyr9ISdyLZyKO1RdYE8Rb4EMv0eiAnATthX8rU6Y0xFI5LwqJJGPSaQYaVT37HIJQbSylgKet0cGKJ9/EiuYDkUjIkJHx5Eir9XlPqurQEE/79uCd+k6wha5HJKN+WRZk74kHTJhqZP6pmBUnnnalHV+xXkCNhxAv9WvhStFXXNARh3kDOsAH4eSAOfo2IRqqusf2nDFnBTLcnE7bv1zHfXCEGhrOAZtMkcPKueRDirP7ajANeUfk1ohyCX+N2LyPLaS68IuyIERQi2kyK9BtPIrxucsBFbdspRJvgoopuIU9ZoHOQLvx0F5uXLSE6RsZGrTRod0HDlPx2tDBoXehkYX8JHKF6aurFDcGpctKXUjqFFBolR+mHqqWNV11jHZVbcjG7IK/ZeSWHWVw//t5+5gy/Z2xei2sSGOeOtTR7LiXDi/QBGqh6VLwNU6gxJIv5YTQ28XTL5GOeOhxzzQQpAOxKDSquxicAUPdBqT6XjoOouhiU9XkBvK3d//hegkvGsKmaCBi9WO8/arQTgeX+N85RqUfptrS55dx+PSZ5ASB/JfIN7we3vtWrbUWCexVZ17/MAjptb14kD3AIe5oSvnVmWwh+Xt3NWe9vnwPUC2VJFTHD/v7EmOPlSa6SBrfH/iRAc8K4ioHDSIIqJZxPp9NyLBk7cTiFu5jD8MKOxHHeVJs4QYR/nTpp09sbgCohdhjIYrrsMnMif3YorkLOfEnASbujfjFEUw3XLexa6aNr/o/EvFLM2XCarJ5MdjeGJA8JM7q8Jzizi6UUoYSZSGDDgqkeAicg5XaGr95SXsTfXXEZ+ia0bawfkQpsFffdH8UQ3iAaXTRUAfFkxBTomfToDZxODgqwHZygYiFFBNanjwXqIcuMo/+9nWOGb
 6+LZZrVP
 cHwl7p/gSrCfoTLZcvyDAux9ziGFXOkFSMXo0oKgfBNx8LISOj0Z2zz4S2HsjqiYpC0QXDG6UxWa/Psy6ajDYjp0A8199ZaVMMRWLX3XqJjmC94TyT46dKUa0jClbpM6BkGa7QMerNb0KIbspOh6ZjzjY8n4mlF8nekbO6Wt3biL9LlNDieXZpdpWIjmEylcXT+lhd9jp+Sj32bW/g4lG8zQbEKVwYvwCiLp1p4rHp6JmER3iXMceghPkXQ0s9ZzNr1aUUPFq/RweCkY7FNuAhfT2LeAvw37I1IGpa9+e/Ccj7QW7GwKOHFsqrj3aCNaPchdkSD3ub6buoGo7s+/kLjNWk8yhywiTKNWZSFAKybpoCKH2xgpwvvSnoLqzUfEuZBJg9cGASdyjdBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-03-26 08:40:21, Usama Arif wrote:
> On 20/03/2026 17:42, Jan Kara wrote:
> >> +	/* Step down under memory pressure */
> >> +	gfp = mapping_gfp_mask(vma->vm_file->f_mapping);
> >> +	zone = first_zones_zonelist(node_zonelist(numa_node_id(), gfp),
> >> +				    gfp_zone(gfp), NULL)->zone;
> >> +	if (zone) {
> >> +		while (order > 0 &&
> >> +		       !zone_watermark_ok(zone, order,
> >> +					  high_wmark_pages(zone), 0, 0))
> >> +			order--;
> >> +	}
> > 
> > It looks wrong for this logic to be here. Trimming order based on memory
> > pressure makes sense (and we've already got reports that on memory limited
> > devices large order folios in the page cache have too big memory overhead
> > so we'll likely need to handle that for page cache allocations in general)
> > but IMHO it belongs to page_cache_ra_order() or some other common place
> > like that.
> > 
> > 								Honza
> 
> So I have been thinking about this. readahead_gfp_mask() already sets
> __GFP_NORETRY, so we wont try aggressive reclaim/compaction to satisfy
> the allocation. page_cache_ra_order() falls through to the fallback path
> faulting in order 0 page when allocation is not satsified.
> 
> So the allocator already naturally steps down under memory pressure,
> the explicit zone_watermark_ok() loop might be redundant?

Probably yes. I still think we'll have to somehow better tweak the used
order based on expected size of the page cache (2M folios seem unreasonably
large for a machine that has e.g. 1G of memory in total, even if it has
enough free memory at this point in time - we'll benefit from smaller
folios and thus finer grained folio activity tracking for such cases). But
that's not for this patch set.

> What are your thoughts on just setting
> ra->order = min(HPAGE_PMD_ORDER, ilog2(SZ_2M >> PAGE_SHIFT))?
> We can do the higher orlder allocation with gfp &= ~__GFP_RECLAIM
> for the VM_EXEC case.

Yes, it's simple and it makes sense to me so if others are fine with it...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

