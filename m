Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0967CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 07:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1476B0088; Fri, 26 Jun 2026 03:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763546B008A; Fri, 26 Jun 2026 03:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A396B0092; Fri, 26 Jun 2026 03:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37EA46B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:40:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 999B7403DE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:40:40 +0000 (UTC)
X-FDA: 84921266640.15.E60F4CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 11C5540007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:40:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1ZMsLYo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782459639;
	b=la//uyJneQc13+D/bBp0NCofR4aaVWKBtWaxWNukTFCS59T6y7SHKrpLkcUtnRUW4NVbdL
	jdkrtZuU7rUfzRtC2fH3msDPf4MfrcTo18/sGi9cz6sESef1V3XJzXBybJqxCXGwSLqqZP
	/3byyIInI1bLgOTg/VGVKzf7TFimhoQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782459639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vh5mum4CE2iVLYNUmthPz0ghYxYQ9IfsJDxe2k3e6D4=;
	b=GNrbU64ycZbBq8CSv7bKm7AA2R66nAYEvV+qde6hTh8TbxeL2jMAT1FmOn0dWM/2MKY8iM
	0G4iX76+wkSf00yzGQs5QGWOoTAQztF1inFgy5uAlIh+vqC7iqQdEoUMI+WEkzhLdMJ5bo
	8QwwhC6b5iuSRSPenOLzi1zDdFoCp1c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1ZMsLYo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EECD60122;
	Fri, 26 Jun 2026 07:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C5B1F000E9;
	Fri, 26 Jun 2026 07:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782459638;
	bh=Vh5mum4CE2iVLYNUmthPz0ghYxYQ9IfsJDxe2k3e6D4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T1ZMsLYoxOYdOSMC1j6XLXQrF7Koh+Ep+37Dhnig/mQNK73ByqK9b+hjxl0U0hFyA
	 lK0DFjUZ63+L/1G9QE2v+z6Sa0Bl3pRpERY02mPEup5nczZV56aGjINoIr7opsMcRp
	 gay4lEBm1gI9fHdTLsDWxaaAdxwLFnpdsz1RimoI6rt7ECUvlQMGNQfIlvg5dvL0NO
	 feN7WpQC/WZTez6noyl6oFhkz1zivUJcfdQyZLKnE53PX8dQj+mKTOmL/LEDUGOHDh
	 q9lNGJNkO840NMXj/8D2ZcinyRX1gcDx13ZbCjEuUtBTlNisJbNq0UFXNTO3Tf+5k4
	 xNX/hin5yVzNg==
Date: Fri, 26 Jun 2026 10:40:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Yuan Liu <yuan1.liu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mm_init: drop overlap_memmap_init()
Message-ID: <aj4s8DvCQ0jE2H_y@kernel.org>
References: <20260625073941.145014-1-rppt@kernel.org>
 <20260625073941.145014-3-rppt@kernel.org>
 <20260625095846.4e2tl3fbduc24erg@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625095846.4e2tl3fbduc24erg@master>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11C5540007
X-Stat-Signature: 1m5rw3ig6maanyku6bgaoqaaqeg49awp
X-HE-Tag: 1782459638-306605
X-HE-Meta: U2FsdGVkX1/WxE7tBNJ7CdWyOy8K4Krk+zqj4PrwtIXjMVC5WiVjxspDiipaSX0aQSSLN1G6DYGuha4mG4dPUvxw53VkA8UHgK9JzxRRj41fr4jwFYSJD7FIyM1OcZgwfEKqi2WoqZ6h7zH7OAZnED3O+AbZyHPyuxPF+jnmQPGOdj1RZ7gSzuSF+YrP5htGxm9CLEY1uzikPu7Bm/N7GBIQX5yQ3z7ItmWJixyVu74RgBdumS9TOe8uYAlnnH03nvB4xRoEZq1UctJczIwxVxRkEEN+Qh0CrP2jVirWui5+ZYPq2eunKXuwjTtdvLZ35boHFlReoEOsy9oy8XKzW0F3FZoO9m0gXoVI2Y+dDJoCo958Iff1AQXsylMrvInu3VqCkGzFXGKipYhS8f3YLZ6uAKaPWgRhHl7d3lfjLS6Y8Pn8d91o9UrxVZwT6sD3P2Ay0pAv5acB/LSWC9IipHfK99v5IFTSoTug7EvyuO0AjQ0XhlAHfi3EoVU8K0QMeTUKXPcIah6/IuozErAs54/7jll7QWZa7ZsJUsW7bFvgw/w7pcuSeXn+z8mHmPlx0k/6TTWgwHK8E+UawlruL3hc6D4IJJ0cgw/UcMr7cUg0+vhDjdKQKH94s4bTwuJGOfzRu0MWFeg6R7dfge3qXoRlH8+rbII4A0ycr/fKGZAVViSblsF3sr4s+G7H3QEPKBsIc3S0TNX2SC5+AkX3eEYiA3oXMNggJ1+xLVMEaJWxKDQHJ+Gd8bF+37O6obJIx5fH4ce91p/xfWyPYd3o6b29SJzcZ/vllMMzU0RRZi2R1vnoGgQJ8DnQLKrmHzs2DTGcV9LZO9PIuPwzo5iZTD72tZBL4SRwtaBm6kMngrPoNOPkZDuuidHJOEOq5JgplJlXkbDOdqr18SvdNVqfdZz3UOBxDdUWd/jSUanuL+UzeAgAtGk4IB4kDgAH/lJsMk8OOizYXAXcLB5z3Yf
 R/oi+h84
 PihB/sO6E52mmuLBid74juHGjdsJ6t8wreiexDf0zyVEO9SUtqPnTeQoLpqWPESghSXF+iF4x/NIg4oRRB6Fila8VPRjsy2+V0ypI/DxyzuN1gbUACFyqZhFxYH3BqKnUae1mo+PdyfGmrpBcQ4LX2ji4kVd0iTGU70CCVl6UxU6ZqfzGvL8XRHWKJSkZm2oM6xloyb/xFPWZhJIFXvQS3BakvR/lJGSylu758ic45stKJHGKEe+j3V88UsTle1cOARL3YXwGyI5fO2zTLDIA7AuQjBQTHDigZuHPd82kHZBJ75pHjWsWO01920A7wJzkDQPWqHcCEg+uVWCQlBxDhBM/whmlk7eujjCh5xJ9bEbmB+6msSgQ6NE2ZADflbcNd6Yumy98I197i7eZ18U7mf7+Vs5fe007z/e8ZRlnwGWFURY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

On Thu, Jun 25, 2026 at 09:58:47AM +0000, Wei Yang wrote:
> On Thu, Jun 25, 2026 at 10:39:40AM +0300, Mike Rapoport wrote:
> >From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> >When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
> >didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
> >to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
> >double initialization of the same struct pages.
> >
> >Since kernelcore=mirror works now the same way as other variants of
> >kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
> >be an overlap between ZONE_NORMAL and ZONE_MOVABLE.
> >
> >Remove overlap_memmap_init().
> >
> 
> Do you think this is valuable to mention the double init for the overlapped
> range?

Not sure I follow.
We had this weird overlap_memmap_init() exactly to avoid double init.
 
> >Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
> >Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >---
> > mm/mm_init.c | 24 ------------------------
> > 1 file changed, 24 deletions(-)
> >
> >diff --git a/mm/mm_init.c b/mm/mm_init.c
> >index dce9dc9f2302..6f0a71ccca30 100644
> >--- a/mm/mm_init.c
> >+++ b/mm/mm_init.c
> >@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
> > 	__init_deferred_page(pfn, nid);
> > }
> > 
> >-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
> >-static bool __meminit
> >-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >-{
> >-	static struct memblock_region *r __meminitdata;
> >-
> >-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
> >-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
> >-			for_each_mem_region(r) {
> >-				if (*pfn < memblock_region_memory_end_pfn(r))
> >-					break;
> >-			}
> >-		}
> >-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
> >-		    memblock_is_mirror(r)) {
> >-			*pfn = memblock_region_memory_end_pfn(r);
> >-			return true;
> >-		}
> >-	}
> >-	return false;
> >-}
> >-
> > /*
> >  * Only struct pages that correspond to ranges defined by memblock.memory
> >  * are zeroed and initialized by going through __init_single_page() during
> >@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
> > 		 * function.  They do not exist on hotplugged memory.
> > 		 */
> > 		if (context == MEMINIT_EARLY) {
> >-			if (overlap_memmap_init(zone, &pfn))
> >-				continue;
> > 			if (defer_init(nid, pfn, zone_end_pfn)) {
> > 				deferred_struct_pages = true;
> > 				break;
> >-- 
> >2.53.0
> 
> -- 
> Wei Yang
> Help you, Help me

-- 
Sincerely yours,
Mike.

