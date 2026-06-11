Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7DF1CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBECB6B008C; Thu, 11 Jun 2026 11:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F8B6B0092; Thu, 11 Jun 2026 11:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85256B0093; Thu, 11 Jun 2026 11:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB0E86B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:48:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73FBB1C174E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:48:34 +0000 (UTC)
X-FDA: 84868064148.14.C18EDFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A87FB160007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:48:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6EF6FgH;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781192912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBvAqwwTuPGJHrKKc5GFDgJPlZ5f0pQvznn9wCUyMaU=;
	b=U1MrfP4EJZFa6bwPuTWFVQihr9z5kCKoooNVUIwgpElLDQWK5D6c0ExxRQJOCmRSUYEK43
	u5U/nNk+8QCAJcBEQfZeidc6g8Wp1CmHcXthyIIRmWv3qzxgKfnyQI1WsaXt800TCtrlRZ
	33qTFPF4/v9o06mFqmsYHyZSTT9qfz4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6EF6FgH;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781192912;
	b=Ierryl7U6HW+skhN5tDv8iPIm4xotpWi32VrzM0/gxdLq02Hg6TOPzuFDXk09aYZoY1fdk
	bzbMxZc8jzXjadjTuw1z2DhgIWJumjdsk2i1wBsrUheDA9QxGzAsno4SExMjjD80n5t89h
	hjyeDUO66Y/OGc+8yXdvajkzfMR9AHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5595743D41;
	Thu, 11 Jun 2026 15:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17AF1F00893;
	Thu, 11 Jun 2026 15:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781192911;
	bh=HBvAqwwTuPGJHrKKc5GFDgJPlZ5f0pQvznn9wCUyMaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6EF6FgHYrs/31xuVF51ER+noevDG4Op75I4vqpITfj3S2EEx77ei3Z89Wuqrs8nr
	 QjDS6ioCpl5RGVDAgKPOU6K+H4M+ZifNQRlRdnKKvX8aKqx4A9W5C/FSUA+vfmdWxo
	 hH9lBYYZDgif0UlMMeqvq+nh8XUOA6nUrABTeRH06wfDtG+DAy8l5DFTKkL21AVqv2
	 6f98I0HO/mmOd4zqei8T8mkUF31udInZf/k0URqi3hkCwVW7y9NYOPQcOTqZ2OVf4m
	 r6dR+8WZjlbfUW57TJs65TavBKzMMzL57us7e0Y87G/VmSlJivMqyxBKlEkGN3OEGd
	 RnI7QWJNtyPgw==
Date: Thu, 11 Jun 2026 16:48:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Huang Shijie <huangsj@hygon.cn>
Cc: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, muchun.song@linux.dev, 
	osalvador@suse.de, david@kernel.org, surenb@google.com, mjguzik@gmail.com, 
	liam@infradead.org, vbabka@kernel.org, shakeel.butt@linux.dev, rppt@kernel.org, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, linux@armlinux.org.uk, 
	dinguyen@kernel.org, schuster.simon@siemens-energy.com, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, djbw@kernel.org, willy@infradead.org, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, james.clark@linaro.org, 
	mhiramat@kernel.org, oleg@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linmiaohe@huawei.com, nao.horiguchi@gmail.com, jannh@google.com, 
	riel@surriel.com, harry@kernel.org, will@kernel.org, brian.ruley@gehealthcare.com, 
	rmk+kernel@armlinux.org.uk, dave.anglin@bell.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH v2 3/4] mm/fs: split the file's i_mmap tree
Message-ID: <airVLmVdVRDOlZm4@lucifer>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-4-huangsj@hygon.cn>
 <aiqFgGbIo1Psy3pI@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiqFgGbIo1Psy3pI@pedro-suse.lan>
X-Rspamd-Queue-Id: A87FB160007
X-Stat-Signature: owp65uyads5bzggmx8aj9br1kekxn8qa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781192912-28921
X-HE-Meta: U2FsdGVkX18dG/FuZDLq5ry4+Nif5Otoc//245pqmGTIrbRJCIIU4CoOTzGYUDKFPK0961Eq/tbe2Lw7rfIJ+sL1y1SRe7Z0D+/vTgknGlH+QygG85BPpXvuVqN+G4Wz0LbrvNjqO3SLmm4FWyn/zbzRT09PhdVAcovp87KNCOguYeGIai2R+yPiVhpZPMiL3j2eWtG3Q6Z2T5+LyZfQVPBL4pq+qk0QyhNSHP+ZyPHP5l6b7IbCh1P0I9IlXOSMXVkk0atkd/3GnFCZYYRZtoTMx6AjnBxE0o3iTqKD+T0qdlh2Hk4sR2EVC/HaeLj+Jz8zAsph+Ek89sO5BOZIJbM8azVisqKBVj9Mz+a76vPvbgprEh6uY+mZGzFqbfUCeq3xgzz33Lf5vNPO+rwX8OUuvx+6rjTVYiTa7yFSpVsOioHuJd9SsRIBc7lFQrCAWi7sWjhFpKZGTtC74zN/thnOvDcxttBuC14/4Wb7xy++1vDYxakMcDtoSLGQmO1sz4Dl0tnQvfL6GyZ76xb0o8LXrezhhGJFFy7BfKJhAeHTrv4GYjGsMST9aTcBLjAyIUefbV/7rduqU+bp2JTz1eS3mQ1cstQrtSA0CnzWPe38zzFDl1hotMOGqVOhBV8ZVeiVjyE7Spc9tAevGDZ+yats2LgAb7FCagqqUfKayQSG/XyPc4yGiSvhO4NWncl3E41TJPkQxnZ8JeSd9pDbi7JfXKz+Pio9oFEv0IPoSnf2LRb8moJ0zVZpZSH4X+UAYl/4U6a1aOixeFpWdxgNLQJbnPX2hshTXAuNvdSb0GjdSR8A6WGqz2Ql3Hf3y1Z0KUyBzG8hr+AyFYJyZq9nMtUmjnVQktwjVbyUzjp0ASE4DPH6D069q2SpP/XGVDOTnFjfC0oDMBA3wpSwvVR7zr7KAU27/jeQHNs4Do5Is4S/OllQg5LOnx3nGMoOoWedslilk1uus7kU+ZJCOOC
 jGOlImxS
 zxM4byNcyWjtjukanwVTq11voKVh/KCiWuzShKeNUsGR67JiTChZRF+9XFyeFqTDUcbc6h33+4QnHg2vgGSqBaSHvQsA3QeIl8DV4MbUag+c1r2w1G00Io6CNBugTaJBXTe0ZNp5Dcq4iwB4mfoEN/pw06MaiV0+gQcQ+eHuTh1t2q6GOvOa778OkPz7Rr1U0o7rcR3W4VNtd3aLOBtI1n0ccleZBk6209/Ea2AXA1cMovDySBwoUxD1nlPjWLy1df7zBtR/VG0GZHzh96dussE7u94yTgBxL9fIclgiRNCW/aeNy+elObuhlV6F/4W/Eo4UNYA6SzoZYHEBi4VwVQmi4If/ZfzFiPq/E8Gx+jtBpCkdjtHMfOm6TXpifdedl7I8jOYdf5Tm9W6CPvLkb3b4tCRl9NKy3fvjf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 12:11:27PM +0100, Pedro Falcato wrote:
> Hi,
>
> On Thu, Jun 11, 2026 at 02:18:59PM +0800, Huang Shijie wrote:
> > In the UnixBench tests, there is a test "execl" which tests
> > the execve system call.
> >   For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > When we test our server with "./Run -c 384 execl",
> > the test result is not good enough. The i_mmap locks contended heavily on
> > "libc.so" and "ld.so". The i_mmap tree for "libc.so" can be
> > over 6000 VMAs, all the VMAs can be in different NUMA mode. The insert/remove
> > operations do not run quickly enough.
>
> I _really_ would have appreciated some coordination here, because I said I was
> going to take a look at it. I have something that I think is much simpler

Agreed, this is the second (or in fact third?) time in recent weeks that
I'm aware of where publicly discussed work has been duplicated with a
series that came in later.

It's really important, when doing work that impact core stuff to have a
look around and see if others are looking at it, as there's nothing more
frustrating than to work on something, discuss it publicly, only to find
somebody sends a competing series.

It can be tricky, as sometimes it's not obvious, or it might not be so
easily found, but I would strongly suggest always making an effort on that
front.

But you didn't even try to send this as an RFC either :)

> in practice. These patches are also way too complex to be dropped just before
> the merge window.

This late in the cycle means -> next cycle. So you'd have needed to resend
it at rc1 in a couple weeks anyway.

>
> Some comments:
>
> >
> >  In order to reduce the competition of the i_mmap lock, this patch does
> > following:
> >    1.) Split the single i_mmap tree into several sibling trees:
> >        Each tree has a lock. The CONFIG_SPLIT_I_MMAP is used to
> >        turn on/off this feature.
>
> There is no need for a config option. This needs to Just Work.

Yeah, this is just a no-go. We don't add config options for changes to core
rmap code.

>
> >    2.) Introduce a new field "tree_idx" for vm_area_struct to save the
> >        sibling tree index for this VMA.
>
> This is possibly contentious, but there are holes in vm_area_struct.
> So I think this is fine.

Yeah no thanks for the extra field, I already have plans for those gaps in
vm_area_struct.

I am in fact writing code right now that uses them...

>
> >    3.) Introduce a new field "vma_count" for address_space.
> >        The new mapping_mapped() will use it.
> >    4.) Rewrite the vma_interval_tree_foreach()

I also intend to send a series that does a bunch of changes in the rmap
code that this would conflict with.

So let's all coordinate please.

> >    5.) Rewrite the lock functions.

Yeah looping on file rmap lock/unlock is gross.

> >
> >  After this patch, the VMA insert/remove operations will work faster,
> > and we can get over 400% performance improvement with the above test.
> >
> > Signed-off-by: Huang Shijie <huangsj@hygon.cn>

I had a look through and this code is really overwrought and you're putting
a bunch of confusing open-coded all over the codebase without comments.

This isn't upstreamable quality and you really should have sent this as an
RFC first so we could discuss the approach.

Thanks, Lorenzo

