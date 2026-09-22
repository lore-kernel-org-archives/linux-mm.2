Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F56C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5586B009E; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D536B00A2; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9BF6B00A4; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65A0E6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF07614049A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:48:10 +0000 (UTC)
X-FDA: 85241375940.25.2E4B069
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E870C0005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:48:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxRcrfCK;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4eH9hr+yvfFnvbbCrIYejYZnIdTOc3jXJLWRBe+BYc=;
	b=NAgGtLqBnJq0nFRc9LhJo20wIVjpobbISqsFZlK33M6YTla9nHeBHLFjH0ykvmJeJJ9gmu
	cicQnUta8oXwvIeX2SkPQqv19ujmbEPb/b2ecQxIG/u+D4kNDdkCH3d9bsRnuGsuEX1lMM
	2wub0LXxlrYx7b+xcod7qaYdmwUefSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081289;
	b=g0MFsi6GCNdd/RZzzAzkfxx0dz1dmAdGOJSAm64dcB+6Ki1I2R0xPXVjj838aACeHJ+PoE
	XdQX1XShdTssWHsHj18MiczwUzFKQVT9Z2pRf9YzEdQG67uMSEVjJomemu6RcC3s2Jrxgi
	u+OfHBCMhmceiyH+tuSWZsJj9GYV29E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxRcrfCK;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DC23411B5;
	Tue, 22 Sep 2026 12:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CC61F000FF;
	Tue, 22 Sep 2026 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790081288;
	bh=r4eH9hr+yvfFnvbbCrIYejYZnIdTOc3jXJLWRBe+BYc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AxRcrfCKj4TeX6ZLNGmys0EohkLSWdZA4WpCoVu2s2m54mvKPCy6liQKcGrQ8XbgI
	 SQupz29e6y7f+7JP+FdhlC3s1z2X8i7JkPdbM3Y976b8njRgJrKLRElYxFR9JEM0BM
	 8TCcoyrcCXV565sfkLcc6LcmZjQmjecePjY6QHJrrJkVK8K8VbGFL91PeILG+FoFl9
	 1THEXtqQfFgXse9S65S+IyHqHuKjKQQgT8FUJXtwclVIR9dTtE3pMYo8uBe0eAvsYc
	 VeRU/FuqXgJPqY0qchNGgBdyeHHurNFz2kQGrv3nsl9hWhSY6PVrVOyB3nSxSAKtfk
	 9k3gXyOmIuBAg==
From: Pratyush Yadav <pratyush@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org,  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  chenhuacai@kernel.org,  ardb@kernel.org,  shuah@kernel.org,
  ilias.apalodimas@linaro.org,  akpm@linux-foundation.org,
  baoquan.he@linux.dev,  ruirui.yang@linux.dev,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  liukexin@kylinos.cn,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kselftest@vger.kernel.org,  linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at
 execution
In-Reply-To: <20260904100852.26006-3-dongtai.guo@linux.dev> (George Guo's
	message of "Fri, 4 Sep 2026 18:08:49 +0800")
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
	<20260904100852.26006-3-dongtai.guo@linux.dev>
Date: Tue, 22 Sep 2026 14:48:03 +0200
Message-ID: <2vxz1pal5u64.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E870C0005
X-Stat-Signature: gqacan57e3ztw3q67rm1fcmc67tioh3t
X-HE-Tag: 1790081289-13571
X-HE-Meta: U2FsdGVkX1/rZdnHShwgtygnNvRLsGgz4OJiATw0D1hHD9LCR+/UzIGC4CNdqSFTO46IgcznKN9VZVtBS/J0TNdUidXj5rOoqhpEL+UWprc/moWvYJxRalfyyzXFoyCRrfdTyak4p9zl0SqWeQTgby2oXJE1wvVZ+0wsf1NLNB6mppyVjXkFmZdb6tvKBJBQpPiCCrripv1XBLJDCXJCQ19t1gRD9BUZDevHlgFTjaImP0I18B5HUUOlG3payxrujyi/UR4uVniStcahHBOWgrQRA1SaKsULaCq5AK2YjNSExyqy+RpFWLzYDRASi/nne93lAYnLduPRCzi7ZK4CprAOTxGHG5N7A3Hn9VR6brJ8mg/i7Iyo/F+8VbDczxF2Yks/y+8+cP4gjVWyEwj5gaE/69SUWMVJxsPo8eLLRJeEfEoWQBILlswWdart2zahSoNE+nsGodSfG3p9nu5y8g6xN0MR8gVYAJjbSXznESGZU/T7xqaNOu8zO7qB8XV+qlr4SYWocNKuxfLyIA6iWhkcubk4q3+Z11ArQHEa5XdRlduyLtSkZ+Vuq4inBTUY9EGS5Lea63+sa8iRn8mw8hXaEMx+WlZzOAw/YrECo4N2reb1n7B0olFbJB/WfEInZnjXQ9J5xHZIU38r4QWhqLIQqgGsRRPEdldhA/Wkz9RQz2t0gfBzVcF7x1hBp8v9k+PuH6fxg9SdzAmQ97eoheb9+AEWf+l69OhiyM8t89mEqpbfTVilisloatdwXoFiAoKbnNdzw/8KJprkqwMwb8PuAGGARmzx7FLDxGmgnvRScSX1fZzq9CJQ+t4SBZ00M0wOMetagyT2Bn2GJE0scOew4eLmhkacJUetb2GwQqacJuaEwOh8Kccqf/i8HtkrN9evPZABhakjlQX0jJJrCNLMC5z01SaPF5Gw5+FN7hYXEi58z5uT09nuHjRSC1ggJGQZOtyAuaCP+pwQq/q
 ipaaWfdr
 8jn6IlsaCrwjJqcNVs+zb1v97GLzih6hgW6gBzK7Pu/OjekujkjmFToEbq3cFGRb3PsIVVRNdIxWHzw4Z9ExvX16BFU7VCsQ6AqUkXl4BIXCyzL1rgCKtPnuNewDQGEdUXMJ563hsfamZMk4EzDLtMIxzTtLwhZ7VJkB1+QxsrqihV8WnJTxVU+tmbHkwE4M/11hAKTuDjQD1En2yeVPaLJCWXqfRP7G/2AjN3oAt/VR0rr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04 2026, George Guo wrote:

> From: George Guo <guodongtai@kylinos.cn>
>
> The EFI KHO configuration table is a global channel. Updating it while
> a candidate kexec image is still being loaded can leave the channel
> pointing at the failed candidate even though the previous image remains
> installed. Synchronize it instead from the image selected for execution.

Huh? Sorry, I don't understand this is supposed to mean at all. What
failed candidate?

>
> Use the actual scratch payload size rather than its page-aligned segment
> size, and propagate update failures before live-update serialization.
> Keep clearing the channel for cold and crash images best-effort.

Huh? This is word soup and I don't understand what any of this is
supposed to mean.

If you are using a LLM to generate this, please _read_ what the output
is and see if it even is readable to someone else.

And if you are writing this by hand, then take a step back, and consider
if patch reviews can even understand what you are saying.

>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/crash_core.c                |  7 +++++++
>  kernel/kexec_core.c                |  5 +++++
>  kernel/kexec_internal.h            |  3 +++
>  kernel/liveupdate/kexec_handover.c | 33 ++++++++++++++++++++++++++++++
>  4 files changed, 48 insertions(+)
>
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 2b36aa9fade0..6166ce4203d3 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -138,6 +138,13 @@ void __noclone __crash_kexec(struct pt_regs *regs)
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
>  
> +			/*
> +			 * A crash image carries no KHO state: clear the
> +			 * transport so the crash kernel boots cold instead
> +			 * of reviving from stale state.
> +			 */
> +			(void)kho_sync_channel(kexec_crash_image);
> +
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d05..147f5b5b23d4 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1146,6 +1146,11 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> +	/* Synchronize the handover transport with the image being executed. */
> +	error = kho_sync_channel(kexec_image);
> +	if (error)
> +		goto Unlock;
> +

Why are you setting this at kexec time? Why not set it at load time like
every other architecture?

Also what's this "sync channel"? Use simpler words that _actually
describe_ what they do.

>  	if (!kexec_image->preserve_context) {
>  		error = liveupdate_reboot();
>  		if (error)
> diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
> index 228bb88c018b..4d4c2290e85c 100644
> --- a/kernel/kexec_internal.h
> +++ b/kernel/kexec_internal.h
> @@ -46,6 +46,7 @@ struct kexec_buf;
>  int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  			int (*func)(struct resource *, void *));
>  int kho_fill_kimage(struct kimage *image);
> +int kho_sync_channel(struct kimage *image);
>  #else
>  static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  				      int (*func)(struct resource *, void *))
> @@ -54,5 +55,7 @@ static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
>  }
>  
>  static inline int kho_fill_kimage(struct kimage *image) { return 0; }
> +
> +static inline int kho_sync_channel(struct kimage *image) { return 0; }
>  #endif /* CONFIG_KEXEC_HANDOVER */
>  #endif /* LINUX_KEXEC_INTERNAL_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 39f489a258d9..3aa5c66dfc6d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -14,6 +14,7 @@
>  #include <linux/cma.h>
>  #include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
> +#include <linux/efi.h>
>  #include <linux/kasan.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -2074,6 +2075,38 @@ int kho_fill_kimage(struct kimage *image)
>  	return 0;
>  }
>  
> +/*
> + * Synchronize the handover transport with the image that is about to be
> + * executed.  The EFI config table channel is global, while kexec keeps
> + * separate images for a normal reboot and for crash.  Write the state of the
> + * selected image immediately before it is executed, rather than while a
> + * candidate image is being loaded, so a failed replacement cannot leave the
> + * channel pointing at that failed image.
> + *
> + * An image loaded through the legacy kexec_load() syscall, a crash image, or
> + * an image loaded while KHO is disabled carries no handover state.  Clear the
> + * channel for those images so the next kernel boots cold instead of reviving
> + * from stale state.  Clearing is best-effort because an absent channel cannot
> + * affect a cold boot.
> + */
> +int kho_sync_channel(struct kimage *image)
> +{
> +	int err;
> +
> +	if (!image->kho.fdt || !image->kho.scratch) {
> +		efi_kho_update(0, 0, 0, 0);
> +		return 0;
> +	}
> +
> +	err = efi_kho_update(image->kho.fdt, PAGE_SIZE,
> +			     image->kho.scratch->mem,
> +			     image->kho.scratch->bufsz);
> +	if (err)
> +		pr_warn("failed to update EFI config table: %d\n", err);
> +
> +	return err;
> +}
> +
>  static int kho_walk_scratch(struct kexec_buf *kbuf,
>  			    int (*func)(struct resource *, void *))
>  {

-- 
Regards,
Pratyush Yadav

