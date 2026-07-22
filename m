Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71C2C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8176E6B0095; Wed, 22 Jul 2026 08:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7846B0096; Wed, 22 Jul 2026 08:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8806B0098; Wed, 22 Jul 2026 08:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 390456B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:28:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C93994016B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:28:57 +0000 (UTC)
X-FDA: 85016341914.21.3F1A542
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 026A740004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:28:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CzEwjjd2;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784723336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIVz1DID8CeKWsK6GdOZ3gM4R5/BpOF1rbBDSWQ/gXQ=;
	b=AL9hgl8XH0/SLBo3/ooZ6pyeVyWNDGuXf8LHhKqHLwyo7ZyCTeu2POhOXulyz3IFBLxWYj
	3NnM2jnuhnmAtm+gC7iaGoAckaCWt6A56ssE/1H0FZskFjO0XRyhhPAP75/Nx+0cvmLK9X
	Nfl/Ksmycw1T3zWK+Jp9QiZINLgw61E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CzEwjjd2;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784723336;
	b=BUi9lgbaJeSUfH8fd0JcoSy8OmODOfZ4SbxXMmOx1shFo4ijJPcaQ5BZ3IqsFC4nALOS3j
	kYh5haKVFXDeiD0JRzF/1nM3JGObLdAi3onJN4+/07IsGvNsDZBvHYWd3faWNw2J5ayn9q
	RB/Bgz13W3DsNq3ysLsWLSCm6Mk60t8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51e4ba1cfb4so74364601cf.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784723335; x=1785328135; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xIVz1DID8CeKWsK6GdOZ3gM4R5/BpOF1rbBDSWQ/gXQ=;
        b=CzEwjjd2pehasQxGVqQmjiNusBAwqNcR9hkhOwMmGyWFXfC1nGPsMdTaf2V6zJUreS
         0cRJ3yvEWZi7ANMcMwIAXSs84uj8D/XFcJkFKsXn9YV2zBpXRgxihbAdCeJEfKrLIKco
         iR+N6BFxBVToouRbijI3Atgy9qzpBhnpRXGXkx6TwgHNLN88q9zY8mkD+kV8FVvcxydi
         LeIXLArxi8pZofP0xnUNPg4tiu4cI1PjjnLEjfjX+pOAjxEMnNmUQ+4m5o0im2Gzigz3
         AazOfo2aFZz+6nd9oZ62GGBQLmyY/jQJeu3mBy6+Np+HCS6w+gKkR1VNg79asmdEgKNu
         vLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784723335; x=1785328135;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xIVz1DID8CeKWsK6GdOZ3gM4R5/BpOF1rbBDSWQ/gXQ=;
        b=ohE7ykhqtRfWbYsJgSK7vyYkA2XHpZTBA73zkpKECNoNXiIAlwjqYVPJ9UCuL0nkbU
         c5xYZvFuRtfIE4lZX110rBsUM6aFm9UDKtr1lNUsosa7gl28B+P5P+DZVLe5zI97EVyU
         GymGPYwmRkJy9j5/qm0zMKd2rLzE9+daNKkQqBwYf1z5DurqCoLPrhlO/virf5tC5ld3
         Lmy3uhES0zdxFgIauHH4oySHtWF3wBo/sgRP4hXCuuf0PMsWJzmhyMzFP782beqCNTKX
         SbwjNCjwc0FhA23RHTi5ovWgxSv1C5KTjh7xeDurspUEO3OdDEMbgGccXSiLFsCBg8if
         AwHA==
X-Gm-Message-State: AOJu0Yy2EEZT0z0AVEPQJHATycvN4uM3tHhzwFF8Pq7lAn/TMA2sZ7Qi
	tdDQnuBpQ+WL9FvzvY8Y2z66ysrKHyU0ISNDyDiO5rioS5Et3ZcrHL1ApZ8ja3WeL+s=
X-Gm-Gg: AR+sD11d3hnZHxULUwhXuE0DHSlw5aHd1foH6R1zwb6qVtEnr/WMe4Im0v+0zUW0FgF
	hMho/GlzEzxbZvkd7Q2UWquL9eVIk2khw76mCBnj55vf+aLxUefTX2BGclQ9lAgs0esuBP8jS24
	U6Ks95hStkv8Zonr5R3Nw6SuHOaPcCXxkETEVGoCT6xYbmhDkbCOzgqghGSRKm5NtZGFoBF2COI
	ArNHjmQMGIvFjzUM3tiui+oW9xSQnK5xIc7uYKwq18p0e2RfD5ne1ZqgXv7rmw59gYGYMV8mpTH
	QJ/HWJrjVO52T0KYdEwNkVMuCp4EnyzvLLOqUpugSscAKEYXjKILUDJWRicpW3pPk2prDOn+15s
	hz8cwQ8OhNS7DYW34xpWVX9HtnSOwdAAdmyiSRPGWuu1YaX3Il3XIS8F//JRPyhavrlZMquSZHP
	ouV7OelxpM0V14WqE6hk0JBNb6OX0Mf/kqvQIB5LM/nSJR/qckHIbVb29McQ==
X-Received: by 2002:ac8:5ad6:0:b0:51b:efbb:fbf with SMTP id d75a77b69052e-5213aa6e321mr250430031cf.18.1784723334838;
        Wed, 22 Jul 2026 05:28:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d3b3f66dsm13968621cf.27.2026.07.22.05.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 05:28:54 -0700 (PDT)
Date: Wed, 22 Jul 2026 08:28:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amC0vzXEEnZaWim0@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <6a7aaac3-e70d-4063-9c84-e643db1488e0@nvidia.com>
 <al-2D_7NcwMxqmsM@gourry-fedora-PF4VCD3F>
 <1d8b6857-de1e-4807-8201-4f6a49a3b8f7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d8b6857-de1e-4807-8201-4f6a49a3b8f7@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 026A740004
X-Stat-Signature: xc66utuad5h5k3uwqsqj8yzepzbnn4yu
X-HE-Tag: 1784723335-387322
X-HE-Meta: U2FsdGVkX1+/D/C6kp8oyrSVWo5DadQde+d3C5vZCIT2dHoq8gBihJiYQSkjbr5xYViYWP+NXTdOlkNeEQGm3GnMakSWx10U3rHDJpWcU36sruhFDukRpcIN0pxWJFu3ggY2NywbZbAncuO8haqrIku9o+tq4OhCXnHdcgOUt4rrAdS8PgGDzFmgfRwAVmgQp80aX0ugNSdHKYEAf7Esxo9ttF3/kEYE3UBtXf8UGLydrASLQk2rbi6E+RFuwmm4tx92tKm7RZe8NdyGhbWgW08U5iBLgavZHJ9Ud5GWKHt2myWTlypYDWJ56yEWYYL0TLntH+9PHjupqqIbUgji1CAzMUpTrTQQqGHk29NEJ329Fow6/bL3uHtDUOrb4WrkdyEj+r36uFn7wEWlKoOeYt3A57MHz1FJLVNdPRkOcCsrBnPETmnIIghak9mLfSvvqPDtThfh9LNHdz45x3YHPQhhFi1DXNeYN/ADHY3fNsy3iPk8m7OLWSSKWJUlasnl90ESaax3aufj6DY+q/evvsRz8ANTx60/s6jWbgysnFaZn4/TFZjzy8HAkM2bZj9tUCoM3uk56xuu2cyOXJwpW7qE+ikcCFOf+H49/PddiKEik0TTHwJ2W8qYfDQ8tdnRtyp5EH/ZQDF/i72XpwbbMDdIi3w+To0tox2wMS26wnfsPlMwzmG9p6UyglxVyqn8WoEriAgdhsR7xanLyochkqIjZ/8Q/MHfWGlVj0dJlIYyQga1QBCjmR+GKUXDSYnk29SX3Vl+IKjFczsOLJ5fHhwlxpfgUC78mGwZwMk5TR6pkYKH4lSvXXmX5yjQsp4a0EDFzOzORaJjQumFrIxRqIvbwVLCpWcDPtz10pniOayGgn1VbPKpYHSbXE1x8/NpJ40xHCNOQUuC1vgOV9/FfqvbtdmnmOMNh/59Ey1w6slGaPeJ5E1TWrBvx0HxSX+/RtIWWcBrsXspkOTLmFE
 OHoxvCyA
 3IXMrGo45cI15KDkO+LFG3NrearvYjwbbm+30+YC0oxPh2h2SzWe5ybqTTE/8zom7qIuFdS3h5/8eIfQpaM1e8mP/Xpsj8/lmQherSAI2dVyt5mUtauC5PrD7gdFQv1wlbHu+nQr996fEZzSKMrmQUHlyeVTHAlN3GcNZiZyIQ1EImZ8YNbH5Wr4PYK5euqPaFZ06AgTFjDVCrn1nfv3G4g1Fkr+3dhByNUanZ063lM6ltu0k55m8qZ8Y0JTqXQqS5bcZvuyrQ4mApiLofsunZ6MujVdcPUa/eaOkA4KiyLRQ42bYZd+2ZVddErCGpTDLHcQh3yMDkACYD+INfpg78yfeeRkV42O5BvatUtXYVamC5jDOheJShgJxfTMyiWLzMMGiLl4P8FQLwQttE6pzPYUNY+5rBM/u3bV8/spqNPd8068=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 06:29:53PM +1000, Balbir Singh wrote:
> On 7/22/26 4:16 AM, Gregory Price wrote:
> > 
> > User-numa
> > 
> >    Some devices don't want the user to have control over placement.
> >    I have been working on compressed memory, for example, which only
> >    ever wants to be used as a reclaim-demotion target.
> >    
> >    (The reasoning for this is another thread, i plan on publishing
> >     my research on this this year)
> > 
> 
> I don't fully understand, how do we allocate memory on these devices then? Is
> the driver expected to allocate and map via vm_insert_page()?
>

It depends on your use case, but yes that's one possibility.

In another use case, you could enable (CAP_RECLAIM | CAP_DEMOTION) and
pages are allocated via alloc_demotion_target() in the reclaim path.

For general "device hosted memory", you can do a variety of things:

Direct alloc 
    ioctl(...) ->  explicit alloc call
    mmap(/dev/my_device) + mm_fault handler

Or a kernel-internal mempolicy
    ioctl(...) ->  set kernel-internal mempolicy on a vma
    mmap(/dev/my_device) + kernel-internal only mempolicy on the vma

The KVM guest_memfd patch included at the end of the series uses the
kernel-internal mempolicy mechanism:
https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#me04a7e3556677babd82bfe3947b1a83b7f0017e1

This pattern is needed because the memory is never mapped into userland,
so userland actually *can't* set a mempolicy on this memory itself.

and then of course: CAP_USER_NUMA + mbind/set_mempolicy directly

This is kind of the point - the source of the memory has some control
over how it can be used.

> > Hot-unplug:
> > 
> >    Some devices can't necessarily handle unexpected migration, and
> >    hot-unplug is fundamentally a migration.  So the HOTUNPLUG cap
> >    actually means "hot-unplug can execute migrations".
> > 
> >    If the entire device has pre-drained the memory (all memory is free)
> >    then unplug works - it's just not very hot (no migrations) :]
> > 
> >    Maybe a naming issue?
> > 
> 
> Yes, I would prefer MIGRATION in the name, HOTUNPLUG made me wonder how these
> devices come online and because it is a device, it can go offline while the
> system is still online
> 

There's a difference between device hotplug and memory hotplug.  The
kernel's memory hotunplug system can at best be described as "best
effort", and if hotplugged as ZONE_NORMAL (on a non-private node) you're
unlikely to ever be able to hotunplug.

It's possible that this CAP bit should just go away and if the device
doesn't want its memory to be run migratable then it needs to hold extra
references on the folios.  That's probably reasonable and looks a lot
like a long term pin.

(note: I have to respin for Sashiko fixes, i'm likely going to drop most
of the CAP bits except USER_NUMA in v6 and have them come in with
specific use cases).

~Gregory

