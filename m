Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6586DD262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 08:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF136B0088; Wed, 21 Jan 2026 03:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CB36B0089; Wed, 21 Jan 2026 03:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89766B008A; Wed, 21 Jan 2026 03:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB0E06B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 03:20:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46A1F1AF8AB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:20:22 +0000 (UTC)
X-FDA: 84355273884.06.6751733
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5D36118000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:20:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DMquiX5p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768983620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/C7RlKb6kG1iTpXvW7JQqVlIIZuudSPPRI9mtHGK9MM=;
	b=g9cVoUJ7bNVEskaQYaPLoX5VRZHgAGiHRCJNDv2cfLlNvYOCDBSi6SBmLeRLOJe2iXcgjM
	Eu+L+NfXrqCB6+3zXcT22EUmnCjaliA2CFvlUlRcWi8GmWLo18Zj1/RSr8aCyTCnLHw3us
	c+wTRO1TG0RJuZzTX9gp3OKkZT2zFQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768983620; a=rsa-sha256;
	cv=none;
	b=8AAhNWk2PuXOJssFXRQF7CpL8nvWu9Q9y7GwwJDka6Qrsw8rx0DqaIY62dZZOYQc4ZSTK4
	ILFylWTpcKnlLbwtPAb+9yMXhemkmiL2kRI7Ck/Z7T6Lv9nQ6Ec2wMaDQIj710fx/sofdR
	RJxaynHq2si6jLEAA6Ggm3X/C/MRCM8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DMquiX5p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 21 Jan 2026 00:20:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768983618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/C7RlKb6kG1iTpXvW7JQqVlIIZuudSPPRI9mtHGK9MM=;
	b=DMquiX5pLi5Jxf8xMEaJv17fESPSsBAXhtfXYVWupL0N0c37DPf2khFhe7aWvvq8A7U67E
	lcUMcLLxBIPuCJAtrwMkrIMlObW1IVdm/NdIDjjr4QGSLdgJ/37hkcB4EDyWZPnbDvZKH8
	0z/DybNcVBxCL0pPtHcCSynGH3HW9G0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, hannes@cmpxchg.org, 
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
Message-ID: <aXCIsLQMSdQ2GNc4@linux.dev>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
 <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
 <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
 <moupi2ch2cpuyrurthk66igh275ks62pltjk2zfngxozj52oxs@64lxvcgh3ays>
 <37734a82-1544-4015-b4dc-30583441a7ba@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37734a82-1544-4015-b4dc-30583441a7ba@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ugx776w359jm663e1i4iirw3n3p4k5t3
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D36118000D
X-Rspam-User: 
X-HE-Tag: 1768983620-877747
X-HE-Meta: U2FsdGVkX1/hIEMYbXvScaj24c3djG7ZCRVa94WQ+gRzN3eBFQuijsR7xWwte6WbDkEvpzr+JvP3kgkTrYfPWhnBmhWfsofDOsQU0tv4kZfe/1gYWM4Q7VYeKIaT7Yc9uBnnRCMWs2IiYFN5mKUBB3jpyZGOfXd98194BCbx+xDfuP1g9wtWXt1hT1+HgiejkHXWiKBNxXgqf7V5d4LIV2GakApe2vYmGlnSug8NmB0c4ULTh8sJ+H7Q0t4nR9WcuWvoLD3TpimO00nDrVjESoXuDc8a2kAfASyoj76Bzgc2XtS5KtFKFK49Bi30nXZM1yJe2a5AAbwq34/WW78pZnLvMk7YwNIpVWukzA/1Q9waZU82D24RT/dNR/xijPj5r4AxD+rBFzTgF57u5TrDNr75X0OFxN2idVG5emXXIA6CtJcsN/lABLP0rd2i0Zwzfah9AuDuSPlH2AGndmja0xQjo9Io1xlQ+JCLII2+rBqIoNu2ZWad78ijPdffSnK4ErxamiwIMxIyE+F10BYSIYVFqxTrar3BNKzng/Edf6EUqFWnU/oA7QkiQzNMqPvJsGNB68fCUi/i9RKitsjnw2EgbnezGZLbxTCAVueItnSUStqYvDrLaUbaBindoq4AOwsOOXjYOSJ18T7NioyMk46Ky8Dyy/gk3dHHSSSx9crbcu++TQL2cwgovJ3FfK6iVhZHt+ARB8l5mhNGBMxqlMMdpNpV5aqywjA/NyI/NDEd2M5UikkuDYF/hJK0hAr8nEBk69zBBzwbFsTY0aTeCqmtNEES6CoOOHv2puqCtyZW6hfQe5RDjo2XmviUBSaPLPjML+CmTXqrs3OiORHJ61Uzw+cygmDzdCU62AE2cM6Is7HjLj04gEYX6e09CIYwny73EHUI+Qhxv/hWS7Kzs9au/8evOpjhSAQFxJDr4l7by1e+yIRfZXFp6/PbOOzgxEOcP9RbLmX5Se/SEyK
 lCzI0KUL
 l8/s5jZy3FIt4mUPUsn+Vqjq2Pfgj1yFx92e3CC6AcJgRHVhdqGzVAYgqXc1crmqp2B/Kn9BKC254ailCUs5I4XolHQEX1i6qdqZHmtGt664QRfmPA/XndYn2g/nhJCM6tWg5dl0DnJh5PGwunJ0STobgUnzlFQma3Zn1+DZslQPEV2cfbe/7eulD7QhUrQrs6Y8XdLTN4Zy8hQqLW5qLe8qiT5RAqhO8mlxqvP7I+jr8nkEhTOkRu5dfgvsDP4H5rMrR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 11:43:50AM +0800, Qi Zheng wrote:
> 
> 
> On 1/21/26 2:47 AM, Shakeel Butt wrote:
> > On Tue, Jan 20, 2026 at 03:19:00PM +0800, Muchun Song wrote:
> > > 
> > > 
> > > > > No reparenting local stats for v2.
> > > > 
> > > > It seems that lruvec_stats->state_local (non-hierarchical) needs to be
> > > > relocated in both v1 and v2.
> > > 
> > > Here we might need to elaborate a bit. Specifically, in the function
> > > `count_shadow_nodes`, the use of `lruvec_page_state_local` to obtain
> > > LRU and SLAB pages seems to also require these logics to work correctly.
> > > For SLAB, it appears that the statistics here have already been
> > > problematic for a while since SLAB pages have been reparented, right?
> > > 
> > 
> > Thanks a lot, now it is clear and yes it seems like SLAB is problematic
> > but now I am wondering if it is really worth fixing. For LRU pages, how
> > about using lruvec_lru_size() defined in vmscan.c. That would at least
> > keep count_shadow_nodes() working irrespective of LRU reparenting.
> 
> Do you mean calling lruvec_lru_size() in count_shadow_nodes()?

Yes but I am mainly brainstorming. We can keep the reparenting local
stats for both v1 and v2 for now as it is not a performance critical
path. I am more worried about the stats update path where upward
traversal of memcg for CSS_DYING can be costly and I don't want that in
v2.

> But
> numa_stat interface also reads lruvec_stats->state and make it visible
> to the user.
> 

Not sure how this is relevant.

