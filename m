Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 177FACD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3915F6B0096; Thu, 28 May 2026 05:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368BF6B0098; Thu, 28 May 2026 05:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6016B0099; Thu, 28 May 2026 05:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1979D6B0096
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:38:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D848A1C0144
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:38:11 +0000 (UTC)
X-FDA: 84816327582.02.A6D0401
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1379340009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:38:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=I3knpawH;
	spf=pass (imf17.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EE3byi/Q1Rh3LOAAyq9zuGFPAs2Rcv0sTysWTqQNIO8=;
	b=Fu9vtMEaGWTp/Wlyk2AQWBXn+9rSKpRig2cDZTy5Aefup4T+WA9Tmds/LsJguMphfmwDFV
	gKqHWt/ZKXuuAZzAsSK6fPcR9eJ9Ihvj8J4e8UeQ9qkLOu3v3TDvWM0iM8UfUxS9ZT+iNV
	+/14kccRsnRXbPAnwYILRIQWTlX2d7Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=I3knpawH;
	spf=pass (imf17.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779961090; a=rsa-sha256;
	cv=none;
	b=6zm7BlSDQM687Nww2m2dK2TGXU44GfBSnV0pQHZsN5nxajrPsJZFlnKiqsCbUfpbYGd8Do
	5xEKCA8/HfdmgL1bUQgPzUglAVBgmW5JDJHevgWpNhC3SJHXkvDV7Z54fqu4pZPQS6aCXB
	Yan81oqwQGjnQd3h2NgcnNTmV2Xrpyg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1779961087;
	bh=rHYM65akxqHNcNE/5zxAiTvlScgfy4gjVLQtW79x9U8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I3knpawH9gZxI8zqXXm/7U0RBVJjohN7vqY+H6qXH9VW6J/fjJfdsftRJx54AoVJ6
	 lWSHJDa32SmF/BB9JK3syMtRpGGb54mRX3zUSYziyrtDDaOaS3MSfszTFWt62AcTDb
	 fCgiqPKwoEVlthfY9Tq8M/92M4L7xHuRKbXnTo429wAkv705n8P2w46q/m5pGavSuC
	 9wcu/E9Y4Av1soxW6Qif+RwZmYb92Z8vi8ueiKIJYUUwmUJmVF5wHZzMTxC4YdUjsr
	 uEGjOTfbmSK8tqhXZEn7qc/yzpSgRTxljZjaXL2/D9j6PKjm6+FomHpcQeVGaWBpuI
	 A1B9HABDMiu9w==
Received: from fedora (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4762917E0191;
	Thu, 28 May 2026 11:38:07 +0200 (CEST)
Date: Thu, 28 May 2026 11:38:02 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Igor Torrente <igor.torrente@collabora.com>,
 loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260528113802.0e0a7a18@fedora>
In-Reply-To: <5d34e0b8-1b3d-4a7e-bd5a-f0eceee4a83b@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-6-tzimmermann@suse.de>
	<d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
	<850e8355-7884-405c-a70a-986ce032c019@suse.de>
	<831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
	<67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
	<20260527121832.7264f0db@fedora>
	<4a00d72c-9b87-4511-9da0-bcb40fae4d74@suse.de>
	<20260528111140.2d9535b7@fedora>
	<5d34e0b8-1b3d-4a7e-bd5a-f0eceee4a83b@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cuoc5c6kd7kb9mrpswd7ippqmqk73wf5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1379340009
X-HE-Tag: 1779961089-974482
X-HE-Meta: U2FsdGVkX18LSLf5XSGMtZJGv8+dAMYmkT5xMaKMU5U5um2JHvGwBy8zwCN2EWcMgWleBjUr46+iyCUO7N5YOhDYkkuGNaYjkCkfYBUZPoFRxJ/aUvD1WCKhi7vIq8tIxFDE7PrPjSbB30EiWdqJC7mxTwH4Dcl4uo0Ve2AyuR1lpe0e/HAOAdxeklCOx2vaPwmcUOBfABiFqXPyyyq5wAszZGc+JHIzuPVuU2DwlKB+H3W4dhxmFA2JG/dZnuXk/+C4iBEN+Dvebdom88yNuj03cA0hDpmgJBzea5kGHyFtvYoxXT+pIcI+XJsgmH0dlJDu7DPf2NM5HmkTzjozIa3QyXecaEnBRGYLSMdjiM+cMVLRmdpp2fhNZq7u39d+DfYS9oX/PN3dEZjGpMRdc0rlLPCH9pC0I5YsRhE6a57HSqriLuJ5gMWivH7YVDLDT7GFIOYlsiLEbOz0KotbXSioKhW+BRlNgRt7HcLX5gDvyNFjQbyWferI/WiediwW3srPyRBbFjRrptTY2wIlGX/aRCXFn9v3fLMmiweyDy5+lnKsWZsLJaAbnvAAlukXluRPJAbEo6dSjz7tIXCqC0ZBJYTwKpezBQmRJHaKciG+Yzd+nU9RkZmj+BYEMDI9+UARuQWvCsIkRf0mGW68Edk9uerEXa+1rIvjLEPEIIRh8RIZfmoUMY2TTjgsmGi+hegg4ncujehCSnJejXiLFzqD3bwhNI/vk0NOMV+zfLHPrombASnvNloSmCZczu0kRsufIEEK3meGVLCNS7gzOAbDh5GW4U5bygNsrOQ9fQV0DBm968cJyavQdOxVkIT9EZQBsWGWt4su0R8/juSnIJEYdALUeZFevR/ruaXQIVdUzJucINLplU0v66LFgPLsFs0yV6F7uMmSvnLiUSRKG0E0CBB4zhNCsUiUGYftDkahBwnPTf13b6jUMEN4bjMSVMH9OMGjoPzuVJWHDQj
 +MndKXIp
 oRDyr/iD+JdTEPjBh9gz7+Hc1du0l9kU6IIYNpXCbaRMmbBtXl6z5EL5HL03mylLELJEm0TOlm++jPtUYj/tSe98reA2PDhdEzXRf06QFUR6Bvhd8t5kLGo34BVS+T4t9wAWv4IAhbwLxPvt6Qei7GsDN3wDpMhygCW/UCG9Xi8M7eFZzqvVwyWZuLsdsRAuljjXPsLtS3ZrrVFaHALZExx1LiR4ZSb3aCrfauZGlI4hof5NWs8rNRMWgFM/2W+a3JGV8NXbs6n99SeiGpyUM8vKPQzJDt3vDLy4QdITzBSW532SrsTK3AoB+K/6h2xxsFjuWaWTsbVMxvTVzA3jGFCNe+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 11:22:46 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
> 
> Am 28.05.26 um 11:11 schrieb Boris Brezillon:
> > On Thu, 28 May 2026 09:20:16 +0200
> > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >  
> >> Hi
> >>
> >> Am 27.05.26 um 12:18 schrieb Boris Brezillon:
> >> [...]  
> >>>> -			return ret;
> >>>> +			return vmf_insert_pfn_pmd(vmf, pfn,
> >>>> +						  vmf->flags & FAULT_FLAG_WRITE);  
> >>> I believe we can go back to
> >>>
> >>> 			return vmf_insert_pfn_pmd(vmf, pfn, false);
> >>>
> >>> if the mappings are no longer adjusted to catch write accesses.  
> >> If we don't install it as writable now, won't the kernel not split it up
> >> into 4KiB pages when the actual write happens?  
> > It will be installed as writeable right away, regardless of the write
> > parameter, because if pfn_mkwrite is not implemented, vma->vm_page_prot
> > won't be lowered to read-only in the first place, or at least that's
> > what I remember from the previous debugging session I've done.  
> 
> In insert_pmd(), the write parameter controls whether we run 
> maybe_pmd_mkwrite(), which sets the __PAGE_RW flag.
> 
> https://elixir.bootlin.com/linux/v7.1-rc5/source/mm/huge_memory.c#L1632
> https://elixir.bootlin.com/linux/v7.1-rc5/source/mm/huge_memory.c#L1655


This is not where the RW|SHARED -> READ_ONLY lowering happens though. If
the write argument was the only way to get writeable hugepage mappings,
it wouldn't have worked before your pfn_mkwrite addition.

> 
> That's at least how I understand the logic here. Performance-wise it 
> might be beneficial if we track the write flags as before.

It was working fine before pfn_mkwrite was added: huge pages were
mapped as PMDs even when they were writable.

