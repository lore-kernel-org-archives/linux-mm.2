Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B851D4415D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5426B0005; Fri, 12 Dec 2025 04:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6665B6B0006; Fri, 12 Dec 2025 04:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C256B0007; Fri, 12 Dec 2025 04:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 440F06B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:41:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9827591EC
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:41:15 +0000 (UTC)
X-FDA: 84210325710.12.57D5B4F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id D4FE81A000D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:41:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="jKl/sZPT";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765532474; a=rsa-sha256;
	cv=none;
	b=fDB/0fmT68FykCJdXi9EzvjOJOeyWrurVUJsV0hLSHEGLTxsEBJM433jZ4f+OqD53OpWOc
	+QVWraqvAixc3CH16uj/iXnGvmCWyRrZBRhemZQoh7BAYul9QbKF+U0UOi7V8HNAf9HgJ+
	sWtHm7hJIs3Kj2d1xwGhWylcT68nGos=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="jKl/sZPT";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765532474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1jh8eqqkY6vh/nK6zUDuHmQpjxacUEwYYM6l1Ih77Q=;
	b=Y2Q0uhGN0LzVwXsvHEiaYT7mWScyACxjzh0vBQgy7v1rpw0hRHgvsreTVa5SjPTFTvCfC+
	BgCEK8wH2qPGa9EnLRp+H4Fwa1mexiDARmPJ9hlBAeuA66k/u9TkAyDvCtDSXYjiAlP79g
	zC0fW7Nftw03eg7rf+i/8kBZd16c1Ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1765532471;
	bh=/DwHOk5c2eD0Vxh7f5OQ4V+UKKui+51GMERXKOPoGK0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jKl/sZPT5Fq8we2J4h12wq9dhaferqqG7WYrh7c5Y1k5yBsJRMxSPvRCYDSthsFe8
	 pRqw/bWdb5arjO4jzO0ebG7e3egbR/5HaJg3gCz1rMcvTGYH23kRmB7RO/abMhPeXv
	 pP44WpV+iM3lP2u6jLE3rcBHt99HTvhioEdkk9vV/zsqJzhBc+WelZKtTdeIp6hRZI
	 kmpNosTBznVu+OWO723zn0UqOjgkh4gRNzv8gubsK5YawM0ijxqLCMQ3L+hxcgdI1g
	 HvFUydetaOLNCQ1Pm2xQnAIFIdzuv4f22nuxZ8yOhxrtVyypGcGEw32L5sKR8OKSyU
	 Ko6IEHLDYFUQQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4DBE917E0451;
	Fri, 12 Dec 2025 10:41:10 +0100 (CET)
Date: Fri, 12 Dec 2025 10:41:05 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Will
 Deacon <will@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Joerg Roedel
 <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <20251212104105.6af97d05@fedora>
In-Reply-To: <aTveh8c3RngvnIMp@nvidia.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
	<20251128180255.GA836877@nvidia.com>
	<20251212094427.2ec0b31e@fedora>
	<aTveh8c3RngvnIMp@nvidia.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4FE81A000D
X-Stat-Signature: 1stt3jkataizsskkyxid4kegf3izfcxy
X-Rspam-User: 
X-HE-Tag: 1765532473-766440
X-HE-Meta: U2FsdGVkX1+lnMkt+IT+3eY2C/SFCGRG9gvO9qJxMIIEombj+voSJLvl3cDIdCaR3a+gr2D9rmu3RO7vxiWHmPZL+nLn34rjRHlYONta8ilbCSMQg14ptX+3lzG33aiyfOh8zQwawzFWIV0NzUX9vHDfq+1nBx5+b7UdU3rScHliXzmQXlW02kkGPn0yjbacSpLMv+Z96EXKD/nMzxW8G75vyUF0cTTJBJt3e60rKbJLAoIioMMPN6ht8eLtkxb3nA+KB9v6LtQAOs421XKPIXLXWEP3HAOJSQqojKaUXMB54hmuagXNNSx2UXekIYlp5Z4gszBxwe6KMojBwYB/eoRFqIbD0zt2DmyAiuN94RtA5U9b9xX51/m42kMBAOgQmS0cE0QiaGFRH5QHjxr4ZX+BCSMbtpB9TrbXNX0Di+X7EgBO4k3DQgcMv+Z/su//9HKvgmJYhyFrEXeplSi1WMVbQGTZHQvxfdXGX8qfB7anfXgyJ2SwpuG6m4HZRAQCwOoKI3L65F7z6n+IyP5gJiC+ZUv46dcVe2Y0AIty4LwiEwer0e7pxOSm8WOwTyV5PU6yehKXhv0SmccA/fdZvI0bWClSKVtiV32MEj1Q07VFn3X4oAi9dQHKP50extA+LBa29riL/7Z8E04s9M/ni5m1pOsYCh70WmAX8CNLRoGjohMj67ie8yVoQW+NC1+lXmz8xriuOdr9zxsUWpu+ZsTdoiT6FHgS9tv/DN11xYAabeqGVGjFmvJsGlJDu8N48Ud6UDFaSkX64sYNWF+LKTQpA9JDTEe5buAkEKnz5TykxaCs/yESUnLR23AmO+a61OlzEaOx9fL4WjmOc+zeTL8FS7Ibge0lyQDivLtGlHsjrNq0S2+4CsiuPu9i845icMhhhMWkJq8KKa2ftebu8aBCwPP5VU895quA8Uk61nz8M0GadumdkUHKS51byicumCaD0jbKSgUexfVgJxU
 wvIsl6PD
 VHBV56fjc7EKFJySCQ2FDxL+CKqiKesWYs/aTXSa/qA7sv0+A75AkMDNA0vMKcKfYAxzVN/3qYlExnayJOe4AV9O2fp1SjEDppsvO1xgOcoFFSXfYFBZqaK8LJ9oaGCGA4PeLgGOQdVfNk1HFtm1noJpx6XPD49yL9lj7IrvETzaY4p1CjdR0jPKNPjiY7dh+1wxw7k3895S2Hqzu16Au1pZrW23wBrl6ZGuXc+XmbQOKACW6X3OC8uUpdcYdcetr+IZbwhC+1hHFqAAfo0OHGqmiPdF+BxSkXOXeE4vXHVw+8gSk0068nmTopemrHeHEitXKT2R9SeMWJ0lwGNQMasPkS6vSYhU285VhOR3+A/HJ5YYQ/FvsiQGG3SuQTrzrUqMo1zKVn92z+lDNkEIPOYIeNLvJy0ufphzfMa2p0IFHkraj0AMGX3vCmqQCIHCWbIoKek4c+/MZ3S4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 05:21:11 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Dec 12, 2025 at 09:44:27AM +0100, Boris Brezillon wrote:
> 
> > > > +// These bindings are currently designed for use by GPU drivers, which use this page table together
> > > > +// with GPUVM. When using GPUVM, a single mapping operation may be translated into many operations    
> > > 
> > > Now that we have the generic pt stuff I wonder if GPUVM should be
> > > providing its own version of the page table implementation that
> > > matches its semantics better.  
> > 
> > Not too sure what you mean here. Are you saying that we should fork
> > io-pgtable-arm.c (or rather a subset of it), and have it all
> > implemented in panthor?  
> 
> Not quite, probably next yearish some of iommu is going to stop using
> io-pgtable-arm.c, and switch to the new stuff.
> 
> The new stuff has alot less duplication if you want to make your own
> special stuff like this:
> 
> > against it. Now, I see good reasons to do that, like the fact we
> > would be able to add features like batched repeat mapping updates
> > (mapping the same page over a wide virtual range without having to
> > duplicate the intermediate page table levels that are exactly the
> > same),   
> 
> That's certainly a unique requirement and it could be implemented with
> a gpusvm specific set of operations.
> 
> > or the ability to extend the mapping arguments with
> > shareability/coherency info (that we can do by adding IOMMU_xx flags
> > too). But there's also downsides to it, like the fact we wouldn't
> > benefit from bugfixes materializing in io-pgtable-arm.c, if any.  
> 
> The new stuff is significantly modular already so this risk is a lot
> lower, and we could further modularize things that are actually
> duplicated.
> 
> But doing something like repeating page table levels will require some
> fairly different unmaping logic already...
> 
> You also had the special allocator asks (and presumably optimizations
> are possible there too) and probably optimizations like taking page
> lists directly out of GPU structures instead of multiple calls and so
> on.
> 
> When 6.19 comes out go look in drivers/iommo/generic_pt and read the
> documentation pages that will generate under the kernel docs site.

Ah, nice! I will certainly have a look when it's out. Thanks for the
heads-up.

> 
> Then you can think about what is ideal for GPU and consider what the
> work would be like. My uneducated feeling is with gpuvm trying to be
> common code it could also have gpuvm provide shared common code that
> directly builds page tables in CPU memory using the above framework.

So, gpuvm is one level up (it doesn't deal at all with any HW
representation), but I guess we could provide helpers for UMA-GPUs,
where preparing the page table on the CPU is a thing, and it could be
that MSM would be interested in using those helpers too.

> 
> > > IOW it doesn't seem right that common code would be making decisions
> > > like this, the nature and requirements of the flushing are entirely up
> > > to the driver binding to HW.  
> > 
> > We're not saying this will work for everyone, but rather, this is a
> > default implementation that does nothing, and if you need to do
> > something, override it with your own. I guess if that's really
> > problematic, we can force the user to provide one and keep the NOP
> > implementation on Tyr's side.  
> 
> In my view there is no possible correct way to use this page table
> code with HW unless you also provide flushing ops. I can't remark what
> is more rusty to do but having a default full of NOPS should at least
> come with a comment explaining that the driver still need to provide
> something.

I'll let Alice decide, but I'm perfectly fine with both options
(NOP default with a disclaimer, or no default at all).

Thanks,

Boris

