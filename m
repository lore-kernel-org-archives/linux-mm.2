Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A12C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 10:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4E16B0096; Mon, 28 Jul 2025 06:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B727C6B0098; Mon, 28 Jul 2025 06:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A364E6B0099; Mon, 28 Jul 2025 06:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D94E6B0096
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:14:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2C63130434
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:14:00 +0000 (UTC)
X-FDA: 83713262640.11.54F3267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A6D3100005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:13:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HergTxt5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753697639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBtfoerUKCeamiR0sSB68YkwUbqqS0n8pu72f0PSJk0=;
	b=FTkTgqrdvLn3YttLbHSOkNxTfBe9NYG30ABaWphvS1MvZIDmW3KkqE7LzsdjQg7REy+5YX
	QoaoHqqZMwg0z8z2U/7Wh5ClmIK4KXTRtnfnhrC2JAfu9jhDv5V2X4eCsZkL9yJ4YTR9qE
	S0+DRuUYUaAe1Fo9O7NBhIPX67EU4l4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HergTxt5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753697639; a=rsa-sha256;
	cv=none;
	b=wM7kC9mMt0FGgry0nlqI5YIKEpubwZrVHBWfk6hvTlCLCiUbEissT0r3+rQ2xurRioBUWV
	wUMoA5FEoN2NV13BiHTCbZZFf0X8z6llAl5y5/5QyzTFsZxqdRBFzS3fi+enQvmrDdLJwv
	Qx1+WhOXEkA6e6G25Cm7irNWMTBvTpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC9E9433CD;
	Mon, 28 Jul 2025 10:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE1BC4CEE7;
	Mon, 28 Jul 2025 10:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753697637;
	bh=daNJNlAwuAlAmQ7p/YMaL/6tdKQoOCGv84U1fRIrrag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HergTxt5kk4TR3TSd1NLJ1RsWKClShrSfD+8qw6wWjTmWoGROlYKuFOej/vLB4FQ4
	 kBRBH9motJGn7ADDkbzqwuXEzssSs4HSm0g6QrRwxL5ESr7Gq0sgeXo1ZWEkcFxA5c
	 38uGB+I6b3eutvofz1hgrZKjHL3yln6PLYAfi1YdtEdmUZQsbY2TYBPgSDAhDWOQe0
	 E3olCvXGndz1IVvIh5zg193asbIOrIhcnErpIdIC0UnddIgd5y8jEbLizZ3A7VUBRx
	 f5Aq4u9AoD8s/z97FIlq8gE1GGghk4A8DXRN+mj7vokix4E+z67ExqlxbdFqPuKVtZ
	 kq57cj7+KekTw==
Date: Mon, 28 Jul 2025 13:13:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v2 01/32] kho: init new_physxa->phys_bits to fix lockdep
Message-ID: <aIdNTN1qd0dTvsQm@kernel.org>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-2-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A6D3100005
X-Rspamd-Server: rspam06
X-Stat-Signature: s5c7orqg9hxqyqarxwp8moixw6xf6fjz
X-HE-Tag: 1753697639-298794
X-HE-Meta: U2FsdGVkX19AIeWayXgWHAcqJGzAKtk5CC3xqZ0JVv/xHP38iiS/GDT50j5v4KRHu4NyST//yl8U+aN1LAZtpRJqxudexX75dIsCFtx3zlCD4R1/qrWGgLfFnfdGF6KRzIN6wa+QvtvESz5zuebt7OLckZkst6hiOVb6EaccfgzLK78mYbkqnNhdqbSE+RQhYA9czPaOKUZXO8NhARTDGmyqTS01NqTD3BY1Ldzh8RAJ+BauPkN1s9Z4ygQwhIVeQ3gkvFhWIYPE3v34KvK5JUzPxRpReyzfrxj8zvhY3glTOqCVtk/L/aMrSnzKqNlV0N0shX8R5AuE31BfDF4o/+zRSPJ7fOVsfBcTqDdFTd+4Jysxc4L4/NJW9PU1yVJy4X70duPpmupxCPzPD+6fkNuM7qcGCPhzIW+jKFhksmNE4ItpKIGav6D8nb2kbxO9vUWCSQ2Zfwrf1jmeO/X8s5z1nQq3SqCkxfZI+qugsJ00uuTVB51sUqV80RRF0qPYxNPcZofBVWw7PjQrE0JIn0hCsNOgiwTGGfG2KqGStql4xqd6oT0knQgubFHDeQQWeCaVfcgT0UdEJP0YsT5e0kCmTV+gIr79lIwGS4713XZyepmcGtUKmMjDzzCwYCF2VPPTQLRzCh4yHZZvk3KrvMmrPukQjRBKGCD2bCLqS3OHiepcvAB1Zi16UI4iFRqLfoyQXPzG6rKhk7d4MjHJU1jIJYPkhvgAVAO58mnnK3jrYOrUWQlYEsUZF8XNgpFD61/nulD+N3kIDasoOcUnywq2fxN2wpTHiUPGe3btGKfPlscP1+lI5kFo9RgLmva5DM+DVvWcaTXmaNAX4Q5lDC5q7ByuWwnxAxJKVO+Pn4owwms7FatCKDSrubDdLWJSv3agJ6rX6fj4MpNOotbwJLfDHurjO0oqJ9HuL1pxH4GFx0VtDBJyat4KEmvCmGEN9D481sDuDuPcWN114Sm
 po/Jyhl4
 jt1OJTbCMJKvU3YFCh5iLbsh3LR+paT36wu2t0ejNKsNMZtjhI/6oxXJ8y3DlGwhcAku6BBODmKayatyyPGBKe7SU5c7RleFZiGW6TeTARSnfS9nZtZdgiFj2NyQQXaGnT0Hmnhy/1wlcGu7SPwyYp2Calpwg5lhN44GMpIPvIiKXX9355OD5HForgnFiVzAp8LFE490u2GnMjDs7Bmn1ahPOWtFlT3Of+NbHF+xrk2KOOayKLCFAjPx1t9HY3UaEL1I0+91jdRbuI5KE67vGGghYRgM8r86yP8/QjBAYSqQncP7KaijOVXKZUEmNBI30XHK7R50xEuT2iypvD9Ll/itO3gkCGaKFWA2rUs2ZqXOVTYSWOg/ILnjnC5j+tuUmrigPcanuHJZKoVoqLblI+RNIRhczPHW0TnK9HPqN9zwHvtkz/wdZ8U9BMdCqrR1Ir+JQNi+2tSX+HAqexjbjJmEgxTz+JzCRroK0fx5w3Rs0t5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:14PM +0000, Pasha Tatashin wrote:
> Lockdep shows the following warning:
> 
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> 
> [<ffffffff810133a6>] dump_stack_lvl+0x66/0xa0
> [<ffffffff8136012c>] assign_lock_key+0x10c/0x120
> [<ffffffff81358bb4>] register_lock_class+0xf4/0x2f0
> [<ffffffff813597ff>] __lock_acquire+0x7f/0x2c40
> [<ffffffff81360cb0>] ? __pfx_hlock_conflict+0x10/0x10
> [<ffffffff811707be>] ? native_flush_tlb_global+0x8e/0xa0
> [<ffffffff8117096e>] ? __flush_tlb_all+0x4e/0xa0
> [<ffffffff81172fc2>] ? __kernel_map_pages+0x112/0x140
> [<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
> [<ffffffff81359556>] lock_acquire+0xe6/0x280
> [<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
> [<ffffffff8100b9e0>] _raw_spin_lock+0x30/0x40
> [<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
> [<ffffffff813ec327>] xa_load_or_alloc+0x67/0xe0
> [<ffffffff813eb4c0>] kho_preserve_folio+0x90/0x100
> [<ffffffff813ebb7f>] __kho_finalize+0xcf/0x400
> [<ffffffff813ebef4>] kho_finalize+0x34/0x70
> 
> This is becase xa has its own lock, that is not initialized in
> xa_load_or_alloc.
> 
> Modifiy __kho_preserve_order(), to properly call
> xa_init(&new_physxa->phys_bits);
> 
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/kexec_handover.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 5a21dbe17950..1ff6b242f98c 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -144,14 +144,35 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  				unsigned int order)
>  {
>  	struct kho_mem_phys_bits *bits;
> -	struct kho_mem_phys *physxa;
> +	struct kho_mem_phys *physxa, *new_physxa;
>  	const unsigned long pfn_high = pfn >> order;
>  
>  	might_sleep();
>  
> -	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
> -	if (IS_ERR(physxa))
> -		return PTR_ERR(physxa);
> +	physxa = xa_load(&track->orders, order);
> +	if (!physxa) {
> +		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
> +		if (!new_physxa)
> +			return -ENOMEM;
> +
> +		xa_init(&new_physxa->phys_bits);
> +		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
> +				    GFP_KERNEL);
> +		if (xa_is_err(physxa)) {
> +			int err_ret = xa_err(physxa);

Just int err should be fine here, otherwise

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +
> +			xa_destroy(&new_physxa->phys_bits);
> +			kfree(new_physxa);
> +
> +			return err_ret;
> +		}
> +		if (physxa) {
> +			xa_destroy(&new_physxa->phys_bits);
> +			kfree(new_physxa);
> +		} else {
> +			physxa = new_physxa;
> +		}
> +	}
>  
>  	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
>  				sizeof(*bits));
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

-- 
Sincerely yours,
Mike.

