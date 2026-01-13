Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AF4D2D108
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AEAF6B008A; Tue, 13 Jan 2026 09:16:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186396B008C; Tue, 13 Jan 2026 09:16:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0134C6B0092; Tue, 13 Jan 2026 09:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E54AC6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:16:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DA24160193
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:16:29 +0000 (UTC)
X-FDA: 84327140898.12.86E4B56
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF2EDC001A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:16:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vj3E8liR;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768313787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EA4FEA3d8sqza+07mct2btPiz1RY5DfLWXNlCi+Rawg=;
	b=bDLYvGy8b39zChO8CNw1YhQD8gPbBnZ2rQ3Ze1dAkKJZOJ1fzkmru2FncIHcY5ehpopOye
	501PtDUT6fFyNe4bi/mk4C35kD/2piCn95CnvJDb3vNiYwO6AIef8urRUP3cAYcMdlIzRI
	ausO3KtQxwYP4iah0XVuM0WLeSfa670=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vj3E8liR;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768313787; a=rsa-sha256;
	cv=none;
	b=wHeYh0KOTzY80VLWlSCphBbsCxvKXYYj3t9CUSDgBeo8zHqHE09PnE/WVZTxjvWnL1VBBF
	xgBnQCVLVyMNDGWzEogF5MbRrRHLzox2UHGxNrFiES7ttuAy6OMLr8GXOxOL0nrKRbz0OI
	UZwNhIcyT7iQAlt2C9SU2DC2Lu8XuNE=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee1939e70bso85636691cf.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768313787; x=1768918587; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EA4FEA3d8sqza+07mct2btPiz1RY5DfLWXNlCi+Rawg=;
        b=Vj3E8liRJwJ+WLiGS6r8AKOJeBaq0gIEIRneGDz3IV2CMXwSOygFE9SNKt7QgBaSEu
         vLOqXxBvqxVjlp9kISNzIbq/bFEmelXXixoF+RM/O9d/uvEG5PylgmLadopjiOQCBMVE
         O36v/GBpZzfHqj7XOEw5/NVNpkcB6mz4pHYelWkvIOObUmSW0iMWRIe7ItENXgXvC+Cf
         98srjuBbeBHJjlxRWAip5S5tEtdx/s9d2ZvnpRBwYkwjohfKZ8sgZgm0L0w6zJb9E0Jc
         OkOkHmPg1cvriUwAx8Y26nIIoMMfdDsRzCIxNqNuzDJ5jaj+/jMeY9UO33IafN4+E4pf
         IoNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768313787; x=1768918587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EA4FEA3d8sqza+07mct2btPiz1RY5DfLWXNlCi+Rawg=;
        b=m2invZDMgsvx5sP2BGJbqvofSvZEUnKVHNC24j0yKeFy8IHYB44c7+0wrHa3oWF5f1
         9M4Bxfilg3ReY70SvYL0n53EvXhvpPtVSkI2aUClIxjCeQRa57+CZlNTWqLrwTjNjDoA
         dYgdmNyXAd9ng9wZ2mf9JRxEvjWFRtSnd3LWM1o7XSwEX21yYzkNb8HJ2gMDd5t3eg3F
         /Gms1YAgyEHGr1mjdrx+/kep/mrcrestubTaVSOHg8Z83rV1K1sXiymorIL0t0lc1MzZ
         RTOXBIjc/2ZjRW5KVV8rbCbIyPDXfsESUwwvtRUP2WlWeXJNHjie4b92eE+r4wfyQ01l
         nGGg==
X-Forwarded-Encrypted: i=1; AJvYcCVSgPVnuizexw/GrLQWTFYaFYIIigpjQH+uDUFZxj6watc2wgMgcGZw+bfBL+DjY2xxqZrpgAiBYw==@kvack.org
X-Gm-Message-State: AOJu0YyCAed5586o0Yvj6JE8N6Fe0loqGQqHdqyHQntwf8SqZBVzS07d
	lliFHHmYzTsUIfLsiR/55MtVY/ySJgcztpdrArQfz8wlRxQ335yKcEjK99V39RXuIBc=
X-Gm-Gg: AY/fxX7rDAV+2eqwUy3B2gbq3MB1mAFD38rONcsWtk4b+aJgqiRiQdqAsDhxJOFLqa/
	fq83+CYlGwsVUVonl4zUmrKUYNlMj3FbGdC9s/xTQpgYkdewqlisaRqkLHbcNVfuoxkblRSndYO
	rJB+imWI6V2UmRLOX2MtVqMbuDjDa++XumWtJmzcFnW7SdIG1Ua/MsP3a2qJov7tq6+XYpxTpDR
	ZK4JgTt72t2TercCfA/1IA2l9KXvtOOt28kWiwJVSdZjXg1fO9W2s+tQ/6IbuAnKmPI3l+JbpYq
	h4noYD3g75s4Sx/5yfJgTBBF9G/cpERiIoMTOwk1sewJDnpiDQYD9QE76jmkTd3NaeVzsgsicLm
	9v3xBdzexCRq/rmrMFRtUvi25NazN9ssslik0uaKa4haRPf/pfPrSGzsN1MD51lTfXRBmG0eLP+
	hRAPBtZjktW3GFzB4iEqoe5kQqLaZu6Nh6WkXPS8R8Bq9AFvSdbkl3h+WEoSL8FMfm3zL8vg==
X-Google-Smtp-Source: AGHT+IENvQu0lA+w8r7eNtBm9WUJ3/lNNLy7qp1W9GClRyOkBrOA+5+QqmRhEmTzN0zeeABQ2fhjWQ==
X-Received: by 2002:a05:622a:1823:b0:4e8:9704:7c83 with SMTP id d75a77b69052e-4ffb47d759bmr323881271cf.14.1768313786490;
        Tue, 13 Jan 2026 06:16:26 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8d39230sm147458241cf.6.2026.01.13.06.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:16:21 -0800 (PST)
Date: Tue, 13 Jan 2026 09:15:43 -0500
From: Gregory Price <gourry@gourry.net>
To: dan.j.williams@intel.com
Cc: Balbir Singh <balbirs@nvidia.com>, Yury Norov <ynorov@nvidia.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Message-ID: <aWZTjzW54LMedKMH@gourry-fedora-PF4VCD3F>
References: <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
 <aWUs8Fx2CG07F81e@yury>
 <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
 <e635e534-5aa6-485a-bd5c-7a0bc69f14f2@nvidia.com>
 <696571507b075_20718100d4@dwillia2-mobl4.notmuch>
 <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
 <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
 <69659d418650a_207181009a@dwillia2-mobl4.notmuch>
 <aWWuU8xphCP_g6KI@gourry-fedora-PF4VCD3F>
 <6965b80a887d5_875d100b5@dwillia2-mobl4.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6965b80a887d5_875d100b5@dwillia2-mobl4.notmuch>
X-Rspamd-Queue-Id: BF2EDC001A
X-Stat-Signature: te1hb1t6uau4iqoaadd1zhjdizkkgc7y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768313787-619799
X-HE-Meta: U2FsdGVkX1/Vg8b4NWq4taddI58D3gjp6Nv8kB6jInCSssU2o95HSsUrTNErzZS73fIwIpD916cCWMxNNvV7WH6TtR9YnRP5Hhk62f6wW6kOmvQvRXkHwFBgnbLKnoE1OTBR1y7L4/iM6SZ7BbdR/Q/X29tvBYiWQkCwUG4h7X/N8KS310S0KC3euq2cnCaz/JusCW2eBSR9xbcAtGkExw3q+RHuZoo5G60Z8gj8/SEU4tFDa3LfwhafQHfwNonh/dnM8yhyccXnW36MS3KZRnuPiGLojfeHwrq9A+Q4uoAkcVTn9m9dWMva1/lWdswsaGWkiRB+L4KF2mpVGYgmCzV0/YcBwX6FLBDgi6eJLhPM1KlId9FvofKOHkdnjJe7CAr8QRxF3SD8GhDR3UadxhKq45YXvVnWXAglW4t18LfA+hh1VrVegVwiXz1xN+6fwW2x/ewglyVS6WmHQGbPsAc9aG44r6vmlX02Evu/HkRLHRlvlQMMfGPghA66BZIxzeo5tsT7gUUBSR8CNVgY1Ahkpin16NgOLW4OcNvg8Z2Aww81Xs5wBvrIacgBqTU2hjdnlYjCE7W4xez5yso+r6oGxVDRaKfWR7JVQRpnE9zij1czmPRFxKq84qQEPem5iz016ZfQLCMNSFfE67pCwg86gAOvD6MAffE86VrmBbN394RPQNwvmTWo1LymQI4Aon+b3lpLtVaiuebJWwHAD3Uq/iFKcqfnj2BUJTWuX+OTElQmOW03klloJmXbdhhdKZRiIEhtenGxvAjYMQtOQlTZpBgsSZEZ/9/Tz5Ir7CwxaBE43OwMOxgUkEI53MrDaDumi1eNLUaAtCFsp/A9RJf8cS8IGsPWJmW/ZzgwXudv/XWM91XqKc7Ar5BX02Zk8tr9kTuAgsUNPMD3xR6WOI0zcmwwmle+eru0FJDq6tSQEOxToXu1U5CmLUyNBaXIhcnmF457GHUd5zoARLK
 96Ye8Tz/
 NzoXbDgJcJgdrD0vad0JmKyOfFiq+m5bgdoQfR8XFE9IyHA/fdLZE7Co20VNY/WJ/Ew65H4qjAWi+orNLobcZnjMy/yBZ9KGUGPIiXM0nG3phM4kSkl7jZzgDhICNWwX4uiq5x5pmux5InD7CFknXCNegYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 07:12:10PM -0800, dan.j.williams@intel.com wrote:
> Gregory Price wrote:
> > On Mon, Jan 12, 2026 at 05:17:53PM -0800, dan.j.williams@intel.com wrote:
> > > 
> > > I think what Balbir is saying is that the _PUBLIC is implied and can be
> > > omitted. It is true that N_MEMORY[_PUBLIC] already indicates multi-zone
> > > support. So N_MEMORY_PRIVATE makes sense to me as something that it is
> > > distinct from N_{HIGH,NORMAL}_MEMORY which are subsets of N_MEMORY.
> > > Distinct to prompt "go read the documentation to figure out why this
> > > thing looks not like the others".
> > 
> > Ah, ack.  Will update for v4 once i give some thought to the compression
> > stuff and the cgroups notes.
> > 
> > I would love if the ZONE_DEVICE folks could also chime in on whether the
> > callback structures for pgmap and hmm might be re-usable here, but might
> > take a few more versions to get the attention of everyone.
> 
> page->pgmap clobbers page->lru, i.e. they share the same union, so you
> could not directly use the current ZONE_DEVICE scheme. That is because
> current ZONE_DEVICE scheme needs to support ZONE_DEVICE mixed with
> ZONE_NORMAL + ZONE_MOVABLE in the same node.
> 
> However, with N_MEMORY_PRIVATE effectively enabling a "node per device"
> construct, you could move 'struct dev_pagemap' to node scope. I.e.
> rather than annotate each page with which device it belongs teach
> pgmap->ops callers to consider that the dev_pagemap instance may come
> from the node instead.

Hmmmmmmm... this is interesting.

should be able to do that cleanly with page_pgmap() and/or folio_pgmap()
and update direct accessors.

probably we'd want mildly different patterns for N_PRIVATE that does
something like

if (is_private_page(page)) {
	... send to private router ...
}

bool is_private_page(page) {
	pgdat = NODE_DATA(page_to_nid(page));
	return pgdat && pgdat->pgmap;

	/* or this, but seems less efficient */
	return node_state(page_to_nid, N_PRIVATE);
}

Then we can add all the callbacks to pgmap instead of dumping them in
node.c.  Shouldn't affect any existing users, since this doesn't
intersect with ZONE_DEVICE.

Technically you COULD have ZONE_DEVICE in N_PRIVATE, but that would be
per-page pgmap, and probably you'd have to have the private router
handle the is_device_page() pattern like everyone else does.

(Seems pointless though, feels like N_PRIVATE replaces ZONE_DEVICE for
 some use cases)

~Gregory

