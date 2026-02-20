Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A5C6C55AB9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 12:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51FE16B0088; Fri, 20 Feb 2026 07:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD656B0089; Fri, 20 Feb 2026 07:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF326B008A; Fri, 20 Feb 2026 07:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27DE86B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:07:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1705140153
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:07:44 +0000 (UTC)
X-FDA: 84464710848.09.9DE8153
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9B3634000F
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:07:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eVxXSFKQ;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771589262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jj1VxsoKh/HLpPU4m/YPCevJ2qQdPEp5xTV4NrJooAY=;
	b=D+vnzbm8Zumhl8eZSPHIAFz+ebBSMJcGaxc8NPmv9P+ApHoxSSIfUeMAJXPdei60AAaknt
	+JP+gh7Pn2nwgGzOyv3HQ50lSh9IdOgjeiE/36+CMoE/jmG2NWhgUKkuPg6WpbGRIoPUwQ
	F27fmZSBmYRRccKMhAWlWBXi2JKivxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771589262; a=rsa-sha256;
	cv=none;
	b=WK/EvJaS9HObPKYLA+CLc4SSDR3R2kMs0xmE/0uqefgZu1L1t3nxsF3Qx+DiDYClXczHvT
	6e+6DIosM1L8xTandgU6OeyORdrQGdH7rBbH8kJSgij042BSVy6H9dzrJcy2WPKBJSwMr1
	7G2GoAmRy6t7L9JvF5DTYt9Gs2GoVxQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eVxXSFKQ;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B9264056D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1536DC116D0
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771589261;
	bh=/CPahougHkSBh/z622YkITmIeyFUeeEQQj35cCE/BuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eVxXSFKQFhpPbqwJTv17D/64FEp6M0gDXd7Z+BXbBHVgncVC85YvTD+URKGDoxZlF
	 nE9DGRfLLuonVhg92nip7SCDbZWqvpm35drooAgIIXtfn5CMUaJeHC75bule994Hsq
	 OaEw5VcMLt7eM6BpNdxgeBTiatyVBDv+O7knHXF3hNAPPKCuYJ81iKXLrWjTlZ4i8N
	 4338qvfvl9WuzWwTameA1mZt0446Ya62c7eGh0qbpWSBl0DaFio9eKmHu38dWDUChd
	 8uSjYvKmebLbGOxPpburXteY45KVmkFc3ksmSLUaUtcmiGbvKsUZl1/4n1s3WpojO5
	 AfZNpdhgHnCKA==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.phl.internal (Postfix) with ESMTP id CDDC5F40069;
	Fri, 20 Feb 2026 07:07:39 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 20 Feb 2026 07:07:39 -0500
X-ME-Sender: <xms:i06YaeJCyakHHKwndht5YOe3MIDWetwc7ZJBm3Lo3RxWyoBFo9HB7w>
    <xme:i06YaYcqGl5iWtjoUFDerrosOHCWODBo9L71HHyaUVeoqNfu0dqc9q3KSSas9QGqw
    cU36rkpwPpFQtugmMWBDNVKLGVLU-JuOxpSctrTqievunBj_1WM8Co>
X-ME-Received: <xmr:i06YadbCoPZ6ILf7rjGA2U03z6BxbOHNybN6Z1v3c0qhsfDwjs9Snnj2dJayRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdekgedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlshhfqdhptgeslh
    hishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthho
    pehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnhekrd
    guvg
X-ME-Proxy: <xmx:i06YaQVP9BtzHL1sUHRVDBFpUDdryurKO2ANwWGuIryLxnFNZn4O8A>
    <xmx:i06YaTBAMTLjL75c0_06_89vrWeaLrQVnbjkMW2hd7mG_ALECmNyzA>
    <xmx:i06YaXAks5pLlsZFm9DczvH1YWsJUb_01qqg-HIXyQJGsU_i2ON9rw>
    <xmx:i06Yaao5uJK4_itjqHgUmVmfEac8yo5D-sHQN13HKZwZEDaCqQG28Q>
    <xmx:i06YaTAxaC87igDWq9V-wS9gka6QYVTZ8DCxYN07a1o2oHYWC6_TKxC8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Feb 2026 07:07:37 -0500 (EST)
Date: Fri, 20 Feb 2026 12:07:32 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZhErt9DZcWI24_v@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: jdbf3fwdbkuayaa8bh985itpyubue96q
X-Rspamd-Queue-Id: 9B3634000F
X-Rspam-User: 
X-HE-Tag: 1771589262-860546
X-HE-Meta: U2FsdGVkX1+CKiMkJOX7cq8bP1OxQpmc+iUCad3eJx7xGYxvW2ts6OhKJJr+OGoDDue354/d2Ux2n2svbR1AjXaQNNOdwWvy+y/ThUN/mYCa3Ph8+53NG+ndVyYbhGpIVava0y2ASxDQTWMjaLVxIip8mUD3TO0lLmPVwQgE4igr/7JYg2Yee26GGIXhaCMdb4o0nmZUk/2gUV9kXtlKGf2lNEfBwErRJW3YE20qRPcMAh/Zzkkt5SXAXPMqwXJ6DosihxIXHlAMtyipy7HilOvuxVcRr2+WNl6unXhtY2VOIbVRxo4Ol+PJ0QCsTduG2EIyOIcSCiONIPFcp+2K+dPhspshfSacGDRrJvfilzM22R6m6R3Efe/ueYauCBnmjn13dCGAG/9FknLg14+3m/XhtGPuObXOTAaZq+bFJfOowvmb+mEAJTcSYfyP7DbRxUUrj/BvXnkBgHhg/Ds4sHl/ngoolHLMLf29aDhIlueh0mTOiquwD5Plkkj1tW02lujedxhBGamTiwL9A9KkDS3UvJFrNQRX6YygyrtQELlAzfR8TyiNG5QzDYRMqwHlJSxlqC1qapDu2Pn0PQmb0/GEjtKdYegLXmav7xyzScDx9xK4y0MQ7pke7m/v+fXtjwiyNgEvFp4t2UtLYqiFA39LHqJW3s+QuYRclYq3RbP04LOEoV/rI9pFpV9/ecDyJTE31CIRQ2ix6SjVrEWYn6t9O4If+zBe5Xd0edmIORfQUrJebFEzupI+0Ec7QN51FuMHwwBEh5EOhYaFne6vvIlu1wkTIL+On3Us4NfS1kUnRF/P3DeD4hzUHNRp7/GHiqy46IePlJUBgUF7IAS7cNkl1rC/k5KII91LIWfYP26+mNpV7iQjqyv/vL7W2EhGIwAFXNvd/W2NydfhXcNfFeoSgihvgjDWWxBxXGPXTjpnjgB0h7aJEqNhbQV/9lm6ZKheqtIMLSD+fRDIX4b
 zPYDsD1N
 bYKZFsxCj1b/Ir8zrM04SXO7x7n1ugc10nwm3gSnp88+8dVmu+3Y37TfR4BhdzNbkZF4SCg2YTkY0MibDc/KFVFigEm2RUcs6m6n+zfDBkdYesL3agA4ISyYthZ2RcH9LVeUxW706Fxo6rGQit6xknXKHsrTU2qxzCiBat69OH0lMoBCUCibTDUzvgtoUGlvY8X+VNhAvRHe7bwIXyS0yfFqXICW69GdocgUlzLsr+PDKbPkw5M1AFwOWEvqM4XvPlzGmxNcuAFHB0Gp6PrHAlpA9OGs86szbb2zxU9ygMDSI/VMk05YJv7tKUCxmHGxwzyxQsMQTXmP3IVL0Iq9uc9rClhUUJqWnwwq+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 11:24:37AM +0100, David Hildenbrand (Arm) wrote:
> > > When discussing per-process page sizes with Ryan and Dev, I mentioned that
> > > having a larger emulated page size could be interesting for other
> > > architectures as well.
> > > 
> > > That is, we would emulate a 64K page size on Intel for user space as well,
> > > but let the OS work with 4K pages.
> > 
> > Just to clarify, do you want it to be enforced on userspace ABI.
> > Like, all mappings are 64k aligned?
> 
> Right, see the proposal from Dev on the list.
> 
> From user-space POV, the pagesize would be 64K for these emulated processes.
> That is, VMAs must be suitable aligned etc.

Well, it will drastically limit the adoption. We have too much legacy
stuff on x86.

> > > We'd only allocate+map large folios into user space + pagecache, but still
> > > allow for page tables etc. to not waste memory.
> > 
> > Waste of memory for page table is solvable and pretty straight forward.
> > Most of such cases can be solve mechanically by switching to slab.
> 
> Well, yes, like Willy says, there are already similar custom solutions for
> s390x and ppc.
> 
> Pasha talked recently about the memory waste of 16k kernel stacks and how we
> would want to reduce that to 4k. In your proposal, it would be 64k, unless
> you somehow manage to allocate multiple kernel stacks from the same 64k
> page. My head hurts thinking about whether that could work, maybe it could
> (no idea about guard pages in there, though).

Kernel stack is allocated from vmalloc. I think mapping them with
sub-page granularity should be doable.

BTW, do you see any reason why slab-allocated stack wouldn't work for
large base page sizes? There's no requirement for it be aligned to page
or PTE, right?

> Let's take a look at the history of page size usage on Arm (people can feel
> free to correct me):
> 
> (1) Most distros were using 64k on Arm.
> 
> (2) People realized that 64k was suboptimal many use cases (memory
>     waste for stacks, pagecache, etc) and started to switch to 4k. I
>     remember that mostly HPC-centric users sticked to 64k, but there was
>     also demand from others to be able to stay on 64k.
> 
> (3) Arm improved performance on a 4k kernel by adding cont-pte support,
>     trying to get closer to 64k native performance.
> 
> (4) Achieving 64k native performance is hard, which is why per-process
>     page sizes are being explored to get the best out of both worlds
>     (use 64k page size only where it really matters for performance).
> 
> Arm clearly has the added benefit of actually benefiting from hardware
> support for 64k.
> 
> IIUC, what you are proposing feels a bit like traveling back in time when it
> comes to the memory waste problem that Arm users encountered.
> 
> Where do you see the big difference to 64k on Arm in your proposal? Would
> you currently also be running 64k Arm in production and the memory waste etc
> is acceptable?

That's the point. I don't see a big difference to 64k Arm. I want to
bring this option to x86: at some machine size it makes sense trade
memory consumption for scalability. I am targeting it to machines with
over 2TiB of RAM.

BTW, we do run 64k Arm in our fleet. There's some growing pains, but it
looks good in general We have no plans to switch to 4k (or 16k) at the
moment. 512M THPs also look good on some workloads.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

