Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 283B2CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CBE8E00E7; Fri, 31 Oct 2025 11:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E42D8E006C; Fri, 31 Oct 2025 11:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7210C8E00E7; Fri, 31 Oct 2025 11:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 604F28E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:53:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17FBAB994E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:53:04 +0000 (UTC)
X-FDA: 84058853088.01.C078239
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0304D180011
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:53:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sbu1tBHq;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761925982; a=rsa-sha256;
	cv=none;
	b=kg+M853DzcdSafziBo7odjWLXBhga+Lt7+lht16BTr3kEBY7YxPc7jc1cz2j1eqJUFtA6R
	Do2wb9Wty4rJQWwyKZUQn26mquTStSg8qRV8zCMMkrZ9Xp95FXmK8B4xUhaxM0l4idpHKC
	FUaDhRTYkmdc7LGFw3FyICgEi3I8Iqo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sbu1tBHq;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761925982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRVQDydXMBWv3SS7Tiyfrwlxc2hTSlslJ2mKztP9QO4=;
	b=Rm+Hv5TfPz/YbsQFQMsuJz66flOB8yRutIKexXgPL8UL97/gMFuk9xHffBeqHYGYuefwhc
	K3PanOyJZEQTff2bZkPnl6uQn5Aqu2fS631HLxPq+lf02fqG5p2e1J/jURswMvOhppUFCn
	GtLgqUPwmA/3ISwwhBbIOwG5YXMosKQ=
Date: Fri, 31 Oct 2025 08:52:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761925979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eRVQDydXMBWv3SS7Tiyfrwlxc2hTSlslJ2mKztP9QO4=;
	b=Sbu1tBHqXjG8v1/aPG6IEYJnefPNlNv72znzVOWLoiply48Ut+rlQGdgrSX+cQKjUi7AYM
	t8Kesv6YnH7ZE5w63scLS+OsSCeIe04nFk9ykZPdMF4kp9u+46B2PQI0ZeG59KMXAarNYe
	Wp8UUFokInUfPSve8E7oPiBs7SJtRvo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	libaokun@huaweicloud.com, linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz, 
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 4d471spomskp5qm3mn7zpojygf8xae33
X-Rspamd-Queue-Id: 0304D180011
X-Rspamd-Server: rspam09
X-HE-Tag: 1761925981-978204
X-HE-Meta: U2FsdGVkX1//9BxmBUuZHesccl1I9DoDbPYxHG7dA6AS48l21PgKeq/hyWSX74zapr56mzSeOrqJ8Omn/1KZrECYZV5ifgZzTh27jZytheHnr1THvZQqlYLXYxQOswMLRfuKfwd49cRq5WoEo/953aqKB0Y8n/hHW4rDWYxUF2kwcs+dSrBvW8x41GrwB9pXh5kmsjrqufnUXX2e7E+YdepJ/Ykm+Dpe1rRKcaFNSXF4E163BTGCBnpt+Qt0fk+H/pRAnZgqGzUXLPclqU0zxClQyRT9CFbs1upPFTM8aG6co9xPBnRiQv/NZi2/yywxZ9lFON4EJgz1z8jkgoNyaERWJkF+cprhXZn9mh2Chd54QLmL/5fFEz9YlcskLQQzrnuWQJ+dhyrEui3gERW1upwpLO3Z/ufdNsjycG1VEzWBiizn9rCJw5qEsF/iwEmapx0zUNSlANjBXJo59SdVrdFnZVWmPBgRfr5RpRziIUROSQg8pE9pGlo1E2gqhV590Q23s+loh8bGZM4Mqb9tuqxBraFU7yaXwTFkuWFYQX+jNOokZKBUKZ7o2crGONvifHPjBbzi1hmaH3E0Y71k/vxTApfssvXEhjt/xNlG9BK5Xeec9YBtUDIRzJbWwCjok//PAj9qSfvJX2MQterfWkVjlsDjdslYdVkI8utA0VVvCSjcDPEJiB+wrJt+OTMmeC1dvQ6Mf1TcqByEC/mXEaCyCNPG63D+PcEkwhWL9KfrY6TqVjvIRLCVavPNDKZ+sk5se7fDyevpwZlAWvVJfannwZgQ4KM/8u9HBNKbS/5IjOmHhlpOvIVa3oiG7TxkX7mj9b8mMHsHKlHOtX0zKFI9WmsoYU+rJNoBXj8zYYKIG3ggDXIU3lo2Xu9e1RrdLJIPMoS1dzTfulybj3zFKbZhcNFIfrcvVD9k9SSncqqUeVjKZ2/7mn49nsi4tOCAaOWZq8bx0lH5eknlLCt
 bzxjRWeP
 9tfiVmw1L8sidl0+iY3uRnC1BUY7Xx3RO4u+eMkt8i3wiBKfj/YJGd8xAW2/EhBx+QVFS0Tk+i43lnQRyX0oJl+8Upr1XjLGa2VYfwfRCwEXcYht7LA5e8ntNYZ3uF08RzFK30pccEPNWn7usHUsoI8Cg5jtYiIgFCEnra4Brt/oF6c1lUWR8VeQ5PNFqlfQMxU8CUPBvlGLGZTnBqh+dKlsVD/w+fWiR2LXzLrW+Io0PS84756c3IzOVOnXFkLPehRaVQMwyvYT5QdaK/46oS5eMvT8gIvz/PYmNIL5MN9NgeIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 08:35:50AM -0700, Shakeel Butt wrote:
> On Fri, Oct 31, 2025 at 02:26:56PM +0000, Matthew Wilcox wrote:
> > On Fri, Oct 31, 2025 at 11:12:16AM +0100, Vlastimil Babka wrote:
> > > On 10/31/25 08:25, Michal Hocko wrote:
> > > > On Fri 31-10-25 14:13:50, libaokun@huaweicloud.com wrote:
> > > >> From: Baokun Li <libaokun1@huawei.com>
> > > >> 
> > > >> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
> > > >> reads at critical points, since they cannot afford to go read-only,
> > > >> shut down, or enter an inconsistent state due to memory pressure.
> > > >> 
> > > >> Currently, attempting to allocate page units greater than order-1 with
> > > >> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
> > > >> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
> > > >> can easily require allocations larger than order-1.
> > > >> 
> > > >> As Matthew noted, if we have a filesystem with 64KiB sectors, there will
> > > >> be many clean folios in the page cache that are 64KiB or larger.
> > > >> 
> > > >> Therefore, to avoid the warning when LBS is enabled, we relax this
> > > >> restriction to allow allocations up to BLK_MAX_BLOCK_SIZE. The current
> > > >> maximum supported logical block size is 64KiB, meaning the maximum order
> > > >> handled here is 4.
> > > > 
> > > > Would be using kvmalloc an option instead of this?
> > > 
> > > The thread under Link: suggests xfs has its own vmalloc callback. But it's
> > > not one of the 5 options listed, so it's good question how difficult would
> > > be to implement that for ext4 or in general.
> > 
> > It's implicit in options 1-4.  Today, the buffer cache is an alias into
> > the page cache.  The page cache can only store folios.  So to use
> > vmalloc, we either have to make folios discontiguous, stop the buffer
> > cache being an alias into the page cache, or stop ext4 from using the
> > buffer cache.
> > 
> > > > This change doesn't really make much sense to me TBH. While the order=1
> > > > is rather arbitrary it is an internal allocator constrain - i.e. order which
> > > > the allocator can sustain for NOFAIL requests is directly related to
> > > > memory reclaim and internal allocator operation rather than something as
> > > > external as block size. If the allocator needs to support 64kB NOFAIL
> > > > requests because there is a strong demand for that then fine and we can
> > > > see whether this is feasible.
> > 
> > Maybe Baokun's explanation for why this is unlikel to be a problem in
> > practice didn't make sense to you.  Let me try again, perhaps being more
> > explicit about things which an fs developer would know but an MM person
> > might not realise.
> > 
> > Hard drive manufacturers are absolutely gagging to ship drives with a
> > 64KiB sector size.  Once they do, the minimum transfer size to/from a
> > device becomes 64KiB.  That means the page cache will cache all files
> > (and fs metadata) from that drive in contiguous 64KiB chunks.  That means
> > that when reclaim shakes the page cache, it's going to find a lot of
> > order-4 folios to free ... which means that the occasional GFP_NOFAIL
> > order-4 allocation is going to have no trouble finding order-4 pages to
> > satisfy the allocation.
> > 
> > Now, the problem is the non-filesystems which may now take advantage of
> > this to write lazy code.  It'd be nice if we had some token that said
> > "hey, I'm the page cache, I know what I'm doing, trust me if I'm doing a
> > NOFAIL high-order allocation, you can reclaim one I've already allocated
> > and everything will be fine".  But I can't see a way to put that kind
> > of token into our interfaces.
> 
> A new gfp flag should be easy enough. However "you can reclaim one I've
> already allocated" is not something current allocation & reclaim can
> take any action on. Maybe that is something we can add. In addition the
> behavior change of costly order needs more thought.
> 

After reading the background link, it seems like the actual allocation
will be NOFS + NOFAIL + higher_order. With NOFS, current reclaim can not
really reclaim any file memory (page cache). However I wonder with the
writeback gone from reclaim path, should we allow reclaiming clean file
pages even for NOFS context (need some digging).

