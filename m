Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0678ACCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6358E00D6; Fri, 31 Oct 2025 11:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4869F8E006C; Fri, 31 Oct 2025 11:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3AD8E00D6; Fri, 31 Oct 2025 11:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7108E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:36:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6ED78838D
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:36:29 +0000 (UTC)
X-FDA: 84058811298.30.E0FE794
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB00D180002
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:36:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="l8ORUx/7";
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761924988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bCk+2TmNZusllnMtS41IqvcnVBVBQ9/CiQF7zZf5Vc=;
	b=PvwIRldjQIUEibitiZzD8DdPWLJiKDyz2fEPQZqLdjY4uOAIAZk0vu1M94WldrA1BMyYde
	B/l8jA6nIBazGia1LF2rKNgRXvlAm7MjVJNB3LeFQrfpWZR9VEG8FxPrVT2AQc6UFycvuj
	yiIbCEv9wWzscdQHPdwwh7KqUL+gM8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761924988; a=rsa-sha256;
	cv=none;
	b=mtoGqSEnCa4KbFlBbJTS+bYQVOA8OuaHBaSkbm7h20HboOKXN7TXDponw25rbQRNaeMuZi
	+2FUny67exWUI1IKZ1jrq5n2d94Nm+gxuog7Rol1Yv6iTBBtLY++rbNDO2k2zRWEbpWH/z
	mFXRUTu/0q3bt2hznduCYmOFvuvcv/4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="l8ORUx/7";
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 31 Oct 2025 08:35:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761924981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7bCk+2TmNZusllnMtS41IqvcnVBVBQ9/CiQF7zZf5Vc=;
	b=l8ORUx/7Mi0smhRm+xHaR3mx/ktAWkoTlJ16+OPu6VoBiSSnK5QHFBzLN+bIc0j0e0E7ot
	eKil38tggLwOnNfnIICY2dhStqWjdFJXZ2SULXCdkNq9cbQdxgqERp2XjVU8Yi2OoNYKZg
	Ri918dNNGCyDdyI0hUKajLlkx4Dg43Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	libaokun@huaweicloud.com, linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz, 
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka>
 <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQTHMI3t5mNXp0M1@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 1557hd1sjgbjsd8ziw1ieegjd8gfdew6
X-Rspam-User: 
X-Rspamd-Queue-Id: BB00D180002
X-HE-Tag: 1761924985-976748
X-HE-Meta: U2FsdGVkX18gB/oFN9bmXFlea/GSYsy4oqdHCDLnP70gI0oQNXoIRt9CXwJkdtuX6znezCU6gOCJURqPQpB3x10dUaDgThyUJbcPbRftm4VMAmvV++QkiWW+8VBIipcAGMrefO74QXeHN8SG9fkWrlVEX/PaPTEuZ5+0nAiTfxeuP/hCizXsQZZUrb0b3GsdMQEYx26R6KcCUm7vsTkI/V9WpAOJ8z7OJQsrnm9DFi8X3/q1bHq6JrlCEhBfzH4/uvkEHjhetYH7Ese4CbBAHup3R8utBh4DJAf79t4oci+uA+DqBYrwIe3Do6DgggGeKqLuC1n/Q/cPhXB7X+XSb/3n+qvUsLVfiSNnzfdjxtZBBUEvPgsrjlCbLQ+5HxxOr9oNMWe+QWFtlOPLmnC9fLEoLLYZIpAtMHGwUHhTruXOIUFq3iBbi2EYUGbYSODrK6WXV2REaI+KHuI5nB8nAxHL2ngqlZKmz/yWB9BhAcSqUapshx4gV5drwHQoI+U/ZBxd0D8ZKMCwbRLjkYfptYEskPP/XR8JqJ1ptcSwpiOoJzhq55XHK9NUDmdgLE3E9dWRf36o9vzbxeNDX6NKJa+41fnrMbo+ydAuzYXBoqYGg2E+ALaQEfSDYKMTq6WdvoKckX3ZMot9S4UE8azEKHPX+qjqMszTUgxFuzx6/McK8yizNo6D2uk0Exmax3aZXGi6APvMC4GixmLJgyIx//1dwIH/Wp5tb37MVz1w7dgidtWY5Uc44P6UBZSxNRaVSfJpdh/bKOkxaEkn1OJJAIrS3ZcSWVuyWodAkvsyqg5h8H+ywxfRgHliof+E1MsPdXs86tZYEBohGMxJg7q0r3x4sQy0FvO6gbWa/OAcWogSsovw+HD9pz7a5lGx27VzaV+YCiExmHX+8N52SLo3ybE8QF3V3WW0UOyBnX9wyrlz7bjWXjdYk9uQrMG9eLRixlT+U1c7bquVZOyN2Em
 gBBRC8AD
 M98aYRWnUnjvKAG1PU/6TTfOo87hv3OpX0ZVa7AsN6P00eB/BUl4nmWxDfg6b3uZ49iyV9JWJId+tXjcrmuSIj3PnjMRvRbElsCiG7gW/ON2vrC+r/0ZZyyk1WpynGIKsq+zpZD16LBMk77RkulgfEvE4ANp8ajdSEra6K1GSpe5b9OGzyI7N8AsdSBpN7/DS9T22ZO9qEK+WFfTr/Kj1DhLAjKrWI6SAmG+LN9JcW3FpXgYSi5Nns7e//ORrssLr8EBuLLBHONAXL9wG0wFfhW4T0nMHSko6M/IrbQcNvxrlpUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 31, 2025 at 02:26:56PM +0000, Matthew Wilcox wrote:
> On Fri, Oct 31, 2025 at 11:12:16AM +0100, Vlastimil Babka wrote:
> > On 10/31/25 08:25, Michal Hocko wrote:
> > > On Fri 31-10-25 14:13:50, libaokun@huaweicloud.com wrote:
> > >> From: Baokun Li <libaokun1@huawei.com>
> > >> 
> > >> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
> > >> reads at critical points, since they cannot afford to go read-only,
> > >> shut down, or enter an inconsistent state due to memory pressure.
> > >> 
> > >> Currently, attempting to allocate page units greater than order-1 with
> > >> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
> > >> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
> > >> can easily require allocations larger than order-1.
> > >> 
> > >> As Matthew noted, if we have a filesystem with 64KiB sectors, there will
> > >> be many clean folios in the page cache that are 64KiB or larger.
> > >> 
> > >> Therefore, to avoid the warning when LBS is enabled, we relax this
> > >> restriction to allow allocations up to BLK_MAX_BLOCK_SIZE. The current
> > >> maximum supported logical block size is 64KiB, meaning the maximum order
> > >> handled here is 4.
> > > 
> > > Would be using kvmalloc an option instead of this?
> > 
> > The thread under Link: suggests xfs has its own vmalloc callback. But it's
> > not one of the 5 options listed, so it's good question how difficult would
> > be to implement that for ext4 or in general.
> 
> It's implicit in options 1-4.  Today, the buffer cache is an alias into
> the page cache.  The page cache can only store folios.  So to use
> vmalloc, we either have to make folios discontiguous, stop the buffer
> cache being an alias into the page cache, or stop ext4 from using the
> buffer cache.
> 
> > > This change doesn't really make much sense to me TBH. While the order=1
> > > is rather arbitrary it is an internal allocator constrain - i.e. order which
> > > the allocator can sustain for NOFAIL requests is directly related to
> > > memory reclaim and internal allocator operation rather than something as
> > > external as block size. If the allocator needs to support 64kB NOFAIL
> > > requests because there is a strong demand for that then fine and we can
> > > see whether this is feasible.
> 
> Maybe Baokun's explanation for why this is unlikel to be a problem in
> practice didn't make sense to you.  Let me try again, perhaps being more
> explicit about things which an fs developer would know but an MM person
> might not realise.
> 
> Hard drive manufacturers are absolutely gagging to ship drives with a
> 64KiB sector size.  Once they do, the minimum transfer size to/from a
> device becomes 64KiB.  That means the page cache will cache all files
> (and fs metadata) from that drive in contiguous 64KiB chunks.  That means
> that when reclaim shakes the page cache, it's going to find a lot of
> order-4 folios to free ... which means that the occasional GFP_NOFAIL
> order-4 allocation is going to have no trouble finding order-4 pages to
> satisfy the allocation.
> 
> Now, the problem is the non-filesystems which may now take advantage of
> this to write lazy code.  It'd be nice if we had some token that said
> "hey, I'm the page cache, I know what I'm doing, trust me if I'm doing a
> NOFAIL high-order allocation, you can reclaim one I've already allocated
> and everything will be fine".  But I can't see a way to put that kind
> of token into our interfaces.

A new gfp flag should be easy enough. However "you can reclaim one I've
already allocated" is not something current allocation & reclaim can
take any action on. Maybe that is something we can add. In addition the
behavior change of costly order needs more thought.


