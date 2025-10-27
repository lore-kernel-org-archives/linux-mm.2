Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DBD3CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7EE3800CF; Mon, 27 Oct 2025 19:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F23800C9; Mon, 27 Oct 2025 19:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45C6800CF; Mon, 27 Oct 2025 19:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD98B800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:57:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7881C13A662
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:57:25 +0000 (UTC)
X-FDA: 84045558450.08.784BB48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1DBE40009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:57:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lJ/KUmyJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SBcTEbh6LBWBMX/1jLebgchnOPrKDD8CYHCrLKdcQow=;
	b=VXljvwnHvnlrRpWd5NUoAbOaNGumkCJtW3+BCFhv9K3GCHGcAcieSshSv2iS6dzULFfw79
	apclJmPhyCPUtiboDvQx8oBHXKpppHXciTC17P0BA25SdDbRGIWpDgcjWHv3O7Wf7o1a6S
	vloBuAcE2TdTscNsIHjp1N8tkgTQk8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761609444; a=rsa-sha256;
	cv=none;
	b=v0ney8RInD3E8T10v5VwFbop8w4w/2L1Jlll7pktYqV84RKqDUiXGscE0RiU9W9YJWk7D5
	HjnZDgbBaxyeW0Dz1FVIasKPdYcYyr3m81YgGkpkyPPZ8gIePQFQiHsbfCMlQOihIcOAel
	/vPZuUSR5EvDGAxleLFA1ySakHOwF+I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lJ/KUmyJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 036CC451C8;
	Mon, 27 Oct 2025 23:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1076EC4CEFB;
	Mon, 27 Oct 2025 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761609442;
	bh=jXLAtIGL3t3Eeivlb10T/oIzaKMtHVUOwyi8U5Ge+jA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=lJ/KUmyJsclpDQQ2M+QMnXvOZZC6krQiFKX8sOxfOpoaqG4LjkXXRw347U0yA/XVL
	 Rey0uasO7GpRSs56MfV8SO/NJ2mhK21qIXIQDLmbdzJ2+MjYXzmAD2ySoASlOgr5WZ
	 qI6vVen1gQRkaKqCiQHBrMuinOcBpybHtrxPdFPBA5k84RpmR84/2G2c3NfktLDXQj
	 fL5lj8pzXbT6Q5LPKIkdl4K4tCUYoR3e3CDY/Sukgi/Pg7WcUvXpgtx3WwcOAY7S9H
	 Gl8/cAJIBIOuHsiYgiz1WYIYG0ofPZnG52T6c3hXqIEUHthM1bXhSA6SkrY2an/ZhX
	 IoAhcgPK/opuw==
Content-Type: multipart/mixed; boundary="===============5693088593246735983=="
MIME-Version: 1.0
Message-Id: <2b04ce21d82f2118c291c49ace22d685bcbbd45d203b2f676556d3e5a90eebd1@mail.kernel.org>
In-Reply-To: <20251027232206.473085-3-roman.gushchin@linux.dev>
References: <20251027232206.473085-3-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 13/23] mm: introduce bpf_out_of_memory() BPF kfunc
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:57:21 +0000 (UTC)
X-Rspamd-Server: rspam01
X-Stat-Signature: rdeihgxgqmp9ddpyix8carafjs6bp6r8
X-Rspam-User: 
X-Rspamd-Queue-Id: D1DBE40009
X-HE-Tag: 1761609443-473607
X-HE-Meta: U2FsdGVkX19AzryFHXJjqsMgPtQvZQCZ65esoWIMu0Aa2oIx7yhD26cNwg4L8ocPeLgLm5GKVMZyOtyXKWNqKmBWU1sMI50hEemk/oz/t7twMr8EzFAaW18o115yx7HSgZh2zi2DXuuxKBSkip/3r5bHxjltG8gfhBySJWEx48ve890ESTPQxIIJCe0PUTDKpGAk3GeVwrIDtJRiIbuTl2pOdxbxxrtN8GUSRc3UcfRoTeUzRcscdKXQiNtDUKzRkHK01niEAtU6LyaXQ+ozpibbAKhiveOPL0y9vKo7+Mz78L8mar7vD/R/zOl4HxZNgDFxwAU93v6RJqe6IMZZGJY5wKLrKt5el8mvf3pNHFCiP0FusKZsoE4qA7GEfBVNN3FGO4u97PaqeJZhD9VSVXaGTJlBywUuPidfb3sQPoSpz/mvh+OJXnefkZ7OdKEi+lKbEUty+ESXfT8LvC1MQcMjMyapBQucbNxdSMApWyvXxlBo2Si6ffVaZAgtII72WW2g61E8zLE9QC06t1Z19exjP5xubX79bkZoGnboSldRV+JehEEY7rI+fS++Pbfy9xhQbebGaN8DrVl9Q8QSNJmkqmzR06nfzjZ+SUBMfIjbptJ7R9yMb6d/jfpiWRfKrpv1JmE+TitCWtYx+hVeprmLbPjcF3Zdh9ZFVvIz+uMNv2ptKfN34B/nJIo+I3oSSwGP70JYMUmder+kSllLRccjotuveLP0FmF1Bouyihbbfv7WIuNBEspGHO0CqrwF3BG3PoWngKrx2uN5rH7tBIH42XJDzgecywWSwR1/xIqzUvtXns+Ig8WOEmTh08GUnHyOSevC1yd3Jxnwds/mdeFKYmm1dbA10GIz+nq3Dmx38ko8bnTvVrSAe8dzd+/EUPwbS6PiMLEGXixk07hFWet7CzODg6yzz/5vlb6lEriQoKLumhJCfdZ7yF/cVgrMSrwKU6XSaDYjqcI80wf
 YEDJXeN0
 hzflZ/YNmmmI6MidJgYYHh5w5cIB/GSrN/X0HQugT+1mKwv+K0DQObtYE2OzW/8QaIHKHHg2FXgEIY/AlkvkDGs5DdtLPxU69sumnHlXzr/ZXOGTYC5jgh2+P6bzsjBl91EyUe1IYusJDI0FU1kFD37bvuKfpUEyYmKQXk64RI9y27rMUy+Vh22Y6LVZO0e02vL2sRVkuGA0ai+x/Uab8SyySaYH+pF4TXzKdzCkvnKuvPhqN+OkBxx2v6BnEQg3d1eEhssU6NBnOPIzEtx6TqJqGTTTE7Hw40Yqhr6Ko6w9xlUGFUy48P7IaN/pDTV7zPiWJ7fJJerxuSoFlSQA6ilY8fMVbX5PUMW5eoG4bfj5W/XxC5fR0eer0jNrtNMJlV+Ylc2mlM2GqF3z8ypI5PXeZPDOPTwE2shz4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5693088593246735983==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit bce57b9b96e05731a14c7e10a364fdd9b733cda2
Author: Roman Gushchin <roman.gushchin@linux.dev>

mm: introduce bpf_out_of_memory() BPF kfunc

This patch introduces bpf_out_of_memory() BPF kfunc to allow BPF programs
to declare OOM events and trigger the kernel OOM handling mechanism. The
function accepts a nullable memcg pointer for system-wide or memcg-scoped
OOMs.

> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 721087952..3cbdcd013 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -21,6 +21,11 @@ enum oom_constraint {
>  	CONSTRAINT_MEMCG,
>  };
>
> +enum bpf_oom_flags {
> +	BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK = 1 << 0,
> +	BPF_OOM_FLAGS_LAST = 1 << 1,
> +};
> +
>  /*
>   * Details of the page allocation that triggered the oom killer that are used to
>   * determine what should be killed.
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 3c86cd755..d7fca4bf5 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c

[ ... ]

> +/**
> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
> + * @memcg__nullable: memcg or NULL for system-wide OOMs
> + * @order: order of page which wasn't allocated
> + * @flags: flags
> + * @constraint_text__nullable: custom constraint description for the OOM report
> + *
> + * Declares the Out Of Memory state and invokes the OOM killer.
> + *
> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oom_lock
> + * is true, the function will wait on it. Otherwise it bails out with -EBUSY
> + * if oom_lock is contended.
> + *
> + * Generally it's advised to pass wait_on_oom_lock=false for global OOMs
> + * and wait_on_oom_lock=true for memcg-scoped OOMs.
> + *
> + * Returns 1 if the forward progress was achieved and some memory was freed.
> + * Returns a negative value if an error occurred.
> + */
> +__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> +				  int order, u64 flags)
> +{
> +	struct oom_control oc = {
> +		.memcg = memcg__nullable,
> +		.order = order,
> +	};

Can bpf_out_of_memory() work correctly for system-wide OOMs with
uninitialized gfp_mask?

Looking at out_of_memory():

    if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
        return true;

With gfp_mask=0 and memcg=NULL (system-wide OOM), this evaluates to:
!(0 & __GFP_FS) && !false = true, causing an early return without
invoking the OOM killer. The comment in out_of_memory() explains this
check is about allocation context: "The OOM killer does not compensate
for IO-less reclaim."

All other callers of out_of_memory() initialize gfp_mask:
- mm/page_alloc.c: .gfp_mask = gfp_mask
- mm/memcontrol.c: .gfp_mask = gfp_mask

For memcg OOMs, the code works because is_memcg_oom(oc) is true,
bypassing the check. But for system-wide OOMs (NULL memcg), won't this
cause the function to return immediately without killing any process?

> +	int ret;
> +
> +	if (flags & ~(BPF_OOM_FLAGS_LAST - 1))
> +		return -EINVAL;
> +
> +	if (oc.order < 0 || oc.order > MAX_PAGE_ORDER)
> +		return -EINVAL;
> +
> +	if (flags & BPF_OOM_FLAGS_WAIT_ON_OOM_LOCK) {
> +		ret = mutex_lock_killable(&oom_lock);
> +		if (ret)
> +			return ret;
> +	} else if (!mutex_trylock(&oom_lock))
> +		return -EBUSY;
> +
> +	ret = out_of_memory(&oc);
> +
> +	mutex_unlock(&oom_lock);
> +	return ret;
> +}

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `mm: introduce bpf_out_of_memory() BPF kfunc`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============5693088593246735983==--

