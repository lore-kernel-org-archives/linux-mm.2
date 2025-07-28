Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00FFC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E836B0088; Mon, 28 Jul 2025 04:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF826B0095; Mon, 28 Jul 2025 04:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4D16B009A; Mon, 28 Jul 2025 04:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4516B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:15:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F024A10FE9B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:15:57 +0000 (UTC)
X-FDA: 83712965154.16.2BCC7D4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id DFA76120007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:15:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YOHmIu6c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pQ+UXydN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YOHmIu6c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pQ+UXydN;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753690556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HXhzMaFuh7vb5Rrfd9w/8LMRu0pb0blUMzRiad8fKbo=;
	b=LnaWpg4vO+8NQbprx887tp1hpSpHgnYbw/CZUM/MAEvGuSB3EXUajQGUrPOTd2fdbXdBPR
	XCmmZ5hTsYcfSBog2yAwkYpcrEi6NcZvd3CEDiC5GVRJs0BOWYUe+pYP7rMyi01gC6Y8kJ
	+IgGsfL3FgvnxO6QKYA93o/5z6MqI9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753690556; a=rsa-sha256;
	cv=none;
	b=wsXxr9qRwwxM7WYd/GRbSCkc6uNfhnnPlXmFz7Bn03IVupZw9IHFa0ba7ywpKb8Pch/W6G
	XDWFOpqsDFRSqN+mae/fQe3eIUctb6aEgpyjXM+vaewHWvzg7TtShf5pj2w/yY+DYdhYuk
	t/M82CdUbevvxn57uNI1FcOMAF3YAIE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YOHmIu6c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pQ+UXydN;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YOHmIu6c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pQ+UXydN;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 35130216EE;
	Mon, 28 Jul 2025 08:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753690554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=HXhzMaFuh7vb5Rrfd9w/8LMRu0pb0blUMzRiad8fKbo=;
	b=YOHmIu6cvuvYkmWFnd1acUhY1cMMwLMAoPiyU8zd6MVLu2mR/qKBHWvArwtJz2jYPOxGzM
	rK+om4zwmjJt9NAMFlGRM0hC0fOmo+7JKOyu+yujxzdUCMLzJ9iRildyRljuqZpouVVCUN
	4UXbK2eS1Xc385L9LHRJtNs5TSy/X7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753690554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=HXhzMaFuh7vb5Rrfd9w/8LMRu0pb0blUMzRiad8fKbo=;
	b=pQ+UXydNBn8vugRHXLpfN/zC9+2Y2K6NVoKYrKFd8fB67MbEnix0itIqkID7uar3NyA9lg
	bX/HAeoUvc+tYnCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753690554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=HXhzMaFuh7vb5Rrfd9w/8LMRu0pb0blUMzRiad8fKbo=;
	b=YOHmIu6cvuvYkmWFnd1acUhY1cMMwLMAoPiyU8zd6MVLu2mR/qKBHWvArwtJz2jYPOxGzM
	rK+om4zwmjJt9NAMFlGRM0hC0fOmo+7JKOyu+yujxzdUCMLzJ9iRildyRljuqZpouVVCUN
	4UXbK2eS1Xc385L9LHRJtNs5TSy/X7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753690554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=HXhzMaFuh7vb5Rrfd9w/8LMRu0pb0blUMzRiad8fKbo=;
	b=pQ+UXydNBn8vugRHXLpfN/zC9+2Y2K6NVoKYrKFd8fB67MbEnix0itIqkID7uar3NyA9lg
	bX/HAeoUvc+tYnCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7CB3138A5;
	Mon, 28 Jul 2025 08:15:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +3bxMbkxh2haFwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 28 Jul 2025 08:15:53 +0000
Date: Mon, 28 Jul 2025 10:15:47 +0200
From: Oscar Salvador <osalvador@suse.de>
To: david@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>, Hannes Reinecke <hare@kernel.org>
Subject: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIcxs2nk3RNWWbD6@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: DFA76120007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 3md14g7pn39xurrhkpyhfgy1ry4xg8pc
X-HE-Tag: 1753690555-774093
X-HE-Meta: U2FsdGVkX1/5tjbtRpqq5rF9IGhkszEjdFv3o0EL6kFeef98XoXJvELDRva9uuOSegpsrkEnsZ0gufnP7n3WlXdmOZPApsTsDkKfNon+1DPKeVq7Tfmr+hA5pbP0w1vS1xdw+55lwS1JvoZ+rZerdEiskK87rP8wi4Kk8GRax9mhVHQBedO6Gvxe1BQ5xqzakcPAWtVf3O1UGBVYwRs/tWG2JxPYKPVqdRnG6d9ZTFQ45JJcyKscVPeu9VufJdKJc1tm2FKYro2pG2exuHnUy+czpt0VEVNoOt6Rr/zW2OOsWlc7Ct4wLuhWyAt1umUvUyS+CZWo7Ba9iGl0hdqeAMtXVXQj0EWuei4PhoNKZruETMHeKVuOnHTTkFrTLYYjKMErIAvgy0GbYBFzRFDcAbuUFjSh9sAD9+RTEHYsauIoL+Cs6WjRMwknjdK2F87M2QAovIgSbp0g/mvTei7hJo+QiJNtanHq6Frz0xNfN4RXrzw4UAUUFCK1MiL4XjeWk3xm7MTvmrVuYGAwrW3Xfxh//SiHjyRBzOSkZs3n6VkrfAQNUAw/DDAGJt8HAGseMMbkBjlYNkqbAkgI2dcweGCjcqrEbpnc8fHR1UxoRoukvg1DCK/ay+UhP9rHaqQtNFRwTnSXyt8+96QxvvZplxPt8YHHVY19B/8/aIjnfsHN0ZgVdmZCf6hA2JKcBmnjzyZbdT/3xYWYhJ0nE5x8tnw8QqNgSfqgEjETTUzCU+orrfhoFLmajiFsdlSx4WrF3SiroaAZkNB4Zrq6EYXWjKJKBXUwjsvuO59A2MyiJG+o9BSfbhwqCSRu5Qf7xHq2CzQFRGnT09ej5SLZMOX4RAX0V48krRj2Q1tHijoiOw7lXWlqUrZBTP9hMEqrJYAmRdrHU6PMxGSbhTOhKohGKv5lN/zLDRl+0qb8IB89dWdc8rkgcgkN5MFnyHD7/C/CSIivcYsvd/QDlgQY9uJ
 rFPvab7Z
 zjnjKJnrpT2FBNEjBt54LUk0pfJHtKERW2fe9jMMzzcL9YMh7KQpdyz1bhj199LaeKNoK+couT7ZVCW1ppuDpwr3hg3ezgzaBSB22ml6jfD60bfj8gptg6oZkL0BpJdHp6i44ZXF3eNVtyezhHdWAtEpKCOtTldJGeCcY/B6IyyVLlzvk+zgNKq3zvpSHe69pTbQQnBY7coKbfNhenkYxx/Ob9b2J7WtwYIIGaLj+gMWzc65Lon5aSQfSO/9YoHqCNtdsy8tgVqAJxrZ/2RtAGFGbT+cVi5HdRbzgrD3hQsevKMXH7NaU8hXILVTPFwIMHxxUgcTz+cUJlgfoxmY182AtDyQhQa1ePQW4sLmG+MKCxKWETQf+VTJQDQGLtyglMGh4mRjAqKZdUKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Currently, we have several mechanisms to pick a zone for the new memory we are
onlining.
Eventually, we will land on zone_for_pfn_range() which will pick the zone.

Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
The former will put every single hotpluggled memory in ZONE_MOVABLE
(unless we can keep zones contiguous by not doing so), while the latter
will put it in ZONA_MOVABLE IFF we are within the established ratio
MOVABLE:KERNEL.

It seems, the later doesn't play well with CXL memory where CXL cards hold really
large amounts of memory, making the ratio fail, and since CXL cards must be removed
as a unit, it can't be done if any memory block fell within
!ZONE_MOVABLE zone.

One way to tackle this would be update the ratio every time a new CXL
card gets inserted, but this seems suboptimal.
Another way is that since CXL memory works with selfhosted memmap, we could relax
the check when 'auto-movable' and only look at the ratio if we aren't
working with selfhosted memmap.

Something like the following (acthung: it's just a PoC)
Comments? Ideas? 

 diff --git a/drivers/base/memory.c b/drivers/base/memory.c
 index 5c6c1d6bb59f..ff87cfb3881a 100644
 --- a/drivers/base/memory.c
 +++ b/drivers/base/memory.c
 @@ -234,7 +234,7 @@ static int memory_block_online(struct memory_block *mem)
  		return -EHWPOISON;
 
  	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
 -				  start_pfn, nr_pages);
 +				  start_pfn, nr_pages, mem->altmap);
 
  	/*
  	 * Although vmemmap pages have a different lifecycle than the pages
 @@ -473,11 +473,11 @@ static ssize_t phys_device_show(struct device *dev,
  static int print_allowed_zone(char *buf, int len, int nid,
  			      struct memory_group *group,
  			      unsigned long start_pfn, unsigned long nr_pages,
 -			      int online_type, struct zone *default_zone)
 +			      int online_type, struct zone *default_zone, struct vmem_altmap *altmap)
  {
  	struct zone *zone;
 
 -	zone = zone_for_pfn_range(online_type, nid, group, start_pfn, nr_pages);
 +	zone = zone_for_pfn_range(online_type, nid, group, start_pfn, nr_pages, altmap);
  	if (zone == default_zone)
  		return 0;
 
 @@ -509,13 +509,13 @@ static ssize_t valid_zones_show(struct device *dev,
  	}
 
  	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, group,
 -					  start_pfn, nr_pages);
 +					  start_pfn, nr_pages, mem->altmap);
 
  	len = sysfs_emit(buf, "%s", default_zone->name);
  	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 -				  MMOP_ONLINE_KERNEL, default_zone);
 +				  MMOP_ONLINE_KERNEL, default_zone, mem->altmap);
  	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 -				  MMOP_ONLINE_MOVABLE, default_zone);
 +				  MMOP_ONLINE_MOVABLE, default_zone, mem->altmap);
  	len += sysfs_emit_at(buf, len, "\n");
  	return len;
  }
 diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
 index 23f038a16231..89f7b9c5d995 100644
 --- a/include/linux/memory_hotplug.h
 +++ b/include/linux/memory_hotplug.h
 @@ -328,7 +328,7 @@ extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
  					  unsigned long pnum);
  extern struct zone *zone_for_pfn_range(int online_type, int nid,
  		struct memory_group *group, unsigned long start_pfn,
 -		unsigned long nr_pages);
 +		unsigned long nr_pages, struct vmem_altmap *altmap);
  extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
  				      struct mhp_params *params);
  void arch_remove_linear_mapping(u64 start, u64 size);
 diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
 index 69a636e20f7b..6c6600a9c839 100644
 --- a/mm/memory_hotplug.c
 +++ b/mm/memory_hotplug.c
 @@ -1048,7 +1048,7 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 
  struct zone *zone_for_pfn_range(int online_type, int nid,
  		struct memory_group *group, unsigned long start_pfn,
 -		unsigned long nr_pages)
 +		unsigned long nr_pages, struct vmem_altmap *altmap)
  {
  	if (online_type == MMOP_ONLINE_KERNEL)
  		return default_kernel_zone_for_pfn(nid, start_pfn, nr_pages);
 @@ -1056,6 +1056,10 @@ struct zone *zone_for_pfn_range(int online_type, int nid,
  	if (online_type == MMOP_ONLINE_MOVABLE)
  		return &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
 
 +	/* Selfhosted memmap, skip ratio check */
 +	if (online_policy == ONLINE_POLICY_AUTO_MOVABLE && altmap)
 +		return &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
 +
  	if (online_policy == ONLINE_POLICY_AUTO_MOVABLE)
  		return auto_movable_zone_for_pfn(nid, group, start_pfn, nr_pages);

-- 
Oscar Salvador
SUSE Labs

