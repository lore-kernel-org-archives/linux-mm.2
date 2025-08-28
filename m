Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAFDCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C38D6B00B6; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773286B00B7; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C81C6B00B8; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 417276B00B7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A79B1A0284
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:29 +0000 (UTC)
X-FDA: 83826628578.09.EE69652
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id BCBFAC0016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:00:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JdGORKLy;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756396827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLksD5zZ3hW75VnfuYQpyfVSTaZvPE3GcGq9RUHPAyw=;
	b=E2owlUrRn7IjpPMpkXATABPihiN//B0db4DN8b6h6jdLgC6uxqrvHGnCwW9BjCf1fuE9No
	viDco2E9nRLlLWetECz7SNWsYBF8G0wENhcD0JK6/cPjqe3TVAGbJZtqK6hcYlPthk9wno
	i83ccHkJGMw658/yeGLgdb7TSNA18Ik=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JdGORKLy;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756396827; a=rsa-sha256;
	cv=none;
	b=BRd+j24fvw6dB9E4iUksyp/A2azwCTnhNWzYeWEGArjzfe1YUOBTeZMEGYNqkJCW5dkY9m
	+lgSU3vYkIFxdV0fHPuO5aEeXqK28wJTERls1geUMD+NZLevwR7CN98G+yDlG/F0sEgDWs
	M7tzUGuULiqlF0ENgZ6rrKd900Sydk4=
Date: Thu, 28 Aug 2025 09:00:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756396822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rLksD5zZ3hW75VnfuYQpyfVSTaZvPE3GcGq9RUHPAyw=;
	b=JdGORKLy7Tpo1qPBHWrczqxUNsnGKvO8QPJKvENrXn5vHkSEGQoO2eDo+G+wzngs7gliDP
	87V7h9XTOMgO4wtDXf938KTj0xhiuydIss4DTLB4apLum7byaGH9i/qOfsgEuGkwIVdoBb
	rSBUCCoo7RJzaj1vtKzeewTYYj22dbU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	hannes@cmpxchg.org, usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc
 bpf_mm_get_mem_cgroup()
Message-ID: <gkhxoowgcfvoj5wwbaji6v7wpizj4imwyxzrxnmw3bbd3u6eg3@ekfuuadgpeer>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
 <20250826071948.2618-3-laoar.shao@gmail.com>
 <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local>
 <3m6jhfndkoshnoj76wyjjgmqa55p4ij4desc45yz6g7gbpxnrd@xumacckayj4t>
 <46cecd34-9102-48fe-8a98-091aff6cc88a@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46cecd34-9102-48fe-8a98-091aff6cc88a@lucifer.local>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCBFAC0016
X-Stat-Signature: aqj61ygaoyw35pp7toxe1khwritwsk7i
X-Rspam-User: 
X-HE-Tag: 1756396826-700909
X-HE-Meta: U2FsdGVkX1/QgAtj0ZG5vADHHmHyGUneqTFe7CW2qvpXSnE64XFfHMeISU6pBiTAtl/zXh/qXDFyC6Tb+pMaW9DwQ5YbrCVTO1M8LIKAp5v5BwbxvJzBPu/Fju4/KH98G8cFsBig1OeOmOUm9Trl6BxbDTgCLYMQF9KsPRyeFA2GpXTb6y+dM3Fo+ob+y8IIEsn0ymBFupr+PLzkMQe4py4DyUB5Wbe7O4jFulXtmvtSbu6fvO0RcqkMx0EX2jYgZQCK4gHZ2mL4UoU7KsMHIOQKc2Qt60Y07hPba2T+j6AxA6zGI7r7XcF5MaZj2jW69fc/1Bw/BMKlLV4p2c7+EoMpPF30RHIa3daXhtMyukoJi0YHWuRbHbqZjF22KheddqJE8OsRbkGtmGf1mH5E4gFc34pcd/OIglsdsDPPOQsuX9xPTWdV9Gandq3V7dY+pC4Tm6iyusPCP2QIdvrDpyrUVYPeOIkayasQzJDaBL0up4maK9+W7/oh0Y/zRvNH6SdYo/QEVmZ4so5wROqgfBusXBIYfnWiUTxMqgq9uTP5pSU7aOGV9VmSu7vTcUCe4j1sYF2fxHPp64iRUYuGcvyLo/LksxwqM7te37sNidR7GSMVNI7t65mMwpEAG6OdJFxr1xunzrOsPKJAAMQhHxYO0Sy/GSoWeUsJTH/SQCw6OIk3eIJM1D5HQAV3a+GA2xjj9cwGiOnWptBwtedgnoPfkAaJKGrlLurNAxNwS5ugTRrUkBZkKvnsHnyok19lnz/AQR84hmM/GCw7qPmu8wmCcwcVYu1BhrQvjyGsB5FsfRCvg0mPLObPcpclLRbxNzS6uCK6Rxr+BR4tDuMI1FlM+I7AwSjyowGmTng4Sild8GSkDgPoOdIOHplpFHnZljjILGjdzkrZoR0mR298R7eU+9egyKBBggEIgncYisZHEdwcTULE+SiDb0wQfCG/22+Tkd5Svvy12TvWfeh
 kKKTIkP4
 jgxt3euqRyz0Lo66WXhZ4V7Ifo8jXOYfgopPSWMOIzGJpAlGuCsflEjNVf6+fFoxLFlrJihtrdlyeYHcvIEn8Hm9KxAngOhTiXzObwbl5rUiZ1Pcj9ToNJy35UB7T5BNkhY7ztDihGEAvha4sK7XrTdwbMZik0sG02iTNOvpbK1hVFieMQTtqaGNtKJy4VvpJeUmEoWFZYGnfvnW3RlOQSAF3iXa8apJ55ufhkBJ9fkF5+7Ezlm2WQ8QzOIuQMlADuO4JunYc0zOqus0CbBprPn/j/UkIgwyrBkTKNO3xLg0xAiLwWYm8wYcwZnEEjUN1QEvSiQfZ82vAEU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:40:16AM +0100, Lorenzo Stoakes wrote:
> On Wed, Aug 27, 2025 at 01:50:18PM -0700, Shakeel Butt wrote:
> > On Wed, Aug 27, 2025 at 04:34:48PM +0100, Lorenzo Stoakes wrote:
> > > > +__bpf_kfunc_start_defs();
> > > > +
> > > > +/**
> > > > + * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_struct.
> > > > + * @mm: The mm_struct to query
> > > > + *
> > > > + * The obtained mem_cgroup must be released by calling bpf_put_mem_cgroup().
> > > > + *
> > > > + * Return: The associated mem_cgroup on success, or NULL on failure. Note that
> > > > + * this function depends on CONFIG_MEMCG being enabled - it will always return
> > > > + * NULL if CONFIG_MEMCG is not configured.
> > >
> > > What kind of locking is assumed here?
> > >
> > > Are we protected against mmdrop() clearing out the mm?
> >
> > No locking is needed. Just the valid mm object or NULL. Usually the
> > underlying function (get_mem_cgroup_from_mm) is called in page fault
> > context where the current is holding mm. Here the only requirement is
> > that mm is valid either through explicit reference or the context.
> 
> I mean this may be down to me being not so familiar with BPF, but my concern is
> that we're handing _any_ mm here.

It's not really any mm but rather the mm whose validity is ensured by
the caller. I don't know the BPF internals but if I understand Andrii's
response on other email, the BPF verifier will make sure the BPF program
is holding a valid mm on which it is calling this function. In non-BPF
world, get_mem_cgroup_from_mm() assumes the caller is providing a valid
mm.

> 
> So presumably this could also be a remote mm?

Which is fine as we already do this today i.e. page fault on accessing
memory of a remote process.

> 
> If not then why are we accepting an mm parameter at all, when we could just grab
> current->mm?

Because current->mm might not be equal to the faulting mm as in the case
of remote page fault.

> 
> If it's a remote mm, then we need to be absolutely sure that we won't UAF.
> 
> I also feel we should talk about this in the kdoc, unless BPF always somehow
> asserts these things to be the case + verifies them smoehow.
> 

Yeah some text on how BPF verifier is making sure that the BPF program
is handling a valid mm.

