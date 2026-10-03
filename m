Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DCDCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 23:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199E16B0093; Sat,  3 Oct 2026 19:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14ACC6B0095; Sat,  3 Oct 2026 19:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91C26B0096; Sat,  3 Oct 2026 19:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C07216B0093
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:13:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B939120ABE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:26 +0000 (UTC)
X-FDA: 85282868412.11.6D58EB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B18C180004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h06qkKwp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791069204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGdC2lf8b/ZOvjCNTArSuVDjf7dxJqfVxE783PPAfaM=;
	b=Ks3Up63uNuGxjc4A3Se/mX3B2ArnmusJfHiNKB4zIt6DcY+QzArmu1lZZmkWag8tHyZsQM
	FTI/TtM7ogKBwKtbfoW4kYOZfBXX+7ikUtC46DteLc6IS+14Ef1Fu9s8SIlyX6as4BoKJo
	Ec21CV7fB+3DlZi6Cl1r3zHhWi/NS+w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h06qkKwp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791069204;
	b=wJXrRw6GlCfmZMUw4hpD3PbndTnnLh9q5aN07JInou0YGSj7Lf9f28wGVFM5It+eutgEmB
	yeSbzLw8/CGOBQR3TrrMRvknGPnfKnhaac9vapM6i9WEzbmKAeAbUrKNQyPTddLj/UytoE
	BTR33z5ggeXGXMxe4yAjORLES5p4QpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19B0660214;
	Sat,  3 Oct 2026 23:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445E21F0089C;
	Sat,  3 Oct 2026 23:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069203;
	bh=eGdC2lf8b/ZOvjCNTArSuVDjf7dxJqfVxE783PPAfaM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h06qkKwpPs/8cPDBnXeUIyOF63McYZaAPtjHzscLIuPtdiDDJY5g3tGOKKarSP1QV
	 DBCAk9RaqbcNKueKTR8559a9EI8ja7x3kLUHrHU/nVBmI+j6QnYFVFp0Stk1OSlHO5
	 jnn/Ul3JQ8c9hBeTodVMgLext99iVLgcfHDyTlp/4iLY0VkbRLoXiNNFMqwecWC028
	 yfBI7wq0UKa9SUn7M6mTK7RzofyKnhDsOqnrCR5lxo1NB7YJf1xQSTCb3wIHwQYdBF
	 ycnUmkJGmjISEfsXT+jXdzywid8Ukai0Mp/TbGDqvvecT6f5wwGJBaeybzfpVVGrlu
	 kwk1BctuyWmsA==
Subject: Re: [PATCH net-next v5 5/7] mm/slab: Provide kmalloc type fallback
 for bucket allocations
From: netdev-bot+sashiko@kernel.org
To: kees@kernel.org
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, pfalcato@suse.de,
 kuniyu@google.com, linux-hardening@vger.kernel.org, davem@davemloft.net,
 hannes@cmpxchg.org, mhocko@kernel.org, shakeel.butt@linux.dev,
 muchun.song@linux.dev, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kerneljasonxing@gmail.com,
 willemb@google.com, almasrymina@google.com, bjorn@kernel.org,
 jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sat, 03 Oct 2026 23:13:21 +0000
Message-ID: <179106920182.434549.1755707422798774394@kernel.org>
In-Reply-To: <20261002231132.1646573-5-kees@kernel.org>
References: <20261002231132.1646573-5-kees@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: iciihijwp15eii6m4k6do9peda4you5u
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B18C180004
X-HE-Tag: 1791069204-807170
X-HE-Meta: U2FsdGVkX18X0hFBSDZuQj4QzAXeOnSgQ1gQk4pBTGoxz0/OOD2zI/1V85N/x8j1Sg99XQBkr3jajckI5xmrI4JmKMW+JVjAmwvEYJr7twQopWC8ahMpN8DOmi9wCraCetSbN4BThSWb8K20SMjVwbXh7FtFcUMnJdymkINM6IQC0Hl7dOI8mH1zkLFW1iE/EQ0/0LW5J81Ss4pTl3u+nu9ATK4AdQd/Aop8cMN9bV/LUtSawG9aGICPXk0Jb8MwvApWMOV5ChPbg6VV5Gh4G35ifkPGEBTvvEpeTe6IGQK+JCGZQoWd0tb/5xjtzyM/YcvyDseEvIy9boX6raBS39GSE+m8gpn3NL6vTaNmNG37qrnmL3qHIpQenNbCf20MinjLWkk1BKpqLKSaT8G4db+XTW02UJ4de91iwLlBKNFuqdp2XjtTTDqfG1Dl++GZEc+ETOx1W140UB6RNiUXbK4pozgNLiwkeFe8GepgiIFUVXTyLvThtyN6Dr4onat2I240AQYSC/vCcWO8I65YvTy1ZSHru78OTLIrS9No+LTaInKkF0ykb0+bYONOoa51ixtpSl8/kV3x+Qc0i3H4kXeEePPDNX2v1UtVCiTZjr+SnV+8Ulhl4jmHlXZPk8GzG99KDqtkheRwO6Q8mpG3CiXHqx+4kk3hGRYOJ3sj/BJJ9s//1QPzu5FdD64xXW6a22P9cWyZ4L1fqlnYVMJt2F1eghBncuoDOx3EPNv04zTu5Ovx1mGm5wICL9FVXSv8qQiJjvHJP6ex0q0UbEv/be+oLKGaGyeLp9m2jBm3JSHnp4iHuDYzP14vhwrxTtNXwwHPq1RjHF1v8fqVTmwX63eUw2mzUsmD91nVj44D1YhKcxL4PJo5ISppGuRvf8VSVGDFLrvd/IEwhNF/5xuY5zpNy5E9NjZDhH4B6lYc6BkGvXu0iqUiKnNQP3uVDUxrGO8URvcllLEhEZxE2Bl
 lJCOfq9J
 aBYwK+NGKslQMDhuVXXLdPZ810obWaLkAbAwEjN1D6voe9mAMk8etOYBXoUrqJectKyYxZGii+nXvgH1WSekjd+runH9HccnJGoTdJoUoT1qWd2kt8vaQSfb4fUF/qkxD3mkKZYIarbARn7D7J1MvJ1LqZtjtKI+LWx70lGeW94xz47zO/Bhd+Qj/8TyKVKy9Ad4tSvWlilqbh2EZTcKKp9T/HSY5sozeQngM6OoyncBmcKjMOPhNt9nLJUQV3luYvGVw71mLmm0FNJLlnIJ7njAW0WcvGH5tE0+UAW6l1PtWQnUNNUkn5mtKfU+CfUQpOB2pA7B9sf2xAlu4wqWVqJW2PUVnEzMQKiGWGwB2h6/ArM3VoCT28PHKaVo08fno+1EeZTp5HPE6UvoyIV1rW+zgoormhdQzBi7qamNxUy0iXAYxMcT8riKwRw2sBJnesJ8aj/NVWBx/6hA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] kmem_buckets_create() takes @ctor, @align,
  @useroffset/@usersize and @flags (e.g. SLAB_ACCOUNT), and applies them…

--

mm/slab: Provide kmalloc type fallback for bucket allocations

This patch changes kmalloc_slab() so that a bucketed allocation whose
kmalloc type the bucket set doesn't hold (DMA, reclaimable, accounted,
and so on) goes to the general kmalloc caches. Before, it was always
served from the bucket's normal caches. It also adds a KUnit test for
the fallback and exports mem_cgroup_kmem_disabled() for KUnit.

Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]

> diff --git a/mm/slab.h b/mm/slab.h
> index 8fd6835e42352..7f1bfee83b92e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -421,6 +421,26 @@ static inline unsigned int size_index_elem(unsigned int bytes)
>  	return (bytes - 1) / 8;
>  }
>  
> +/*
> + * Which set of buckets to use for the given kmalloc_cache_type. If not
> + * handled by the kmem_buckets, fall back to general caches.
> + */
> +static inline kmem_buckets *
> +kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
> +{
> +	enum kmem_bucket_type btype;
> +
> +	if (!bucket)
> +		return &kmalloc_caches[type];
> +
> +	if (type <= KMALLOC_PARTITION_END)
> +		btype = KMEM_BUCKET_NORMAL;
> +	else
> +		return &kmalloc_caches[type];	/* No set holds a row for it. */

[Severity: Medium]

If a bucket set is in use and the type is above KMALLOC_PARTITION_END,
this returns the general kmalloc caches. That happens for GFP_DMA with
CONFIG_ZONE_DMA, __GFP_RECLAIMABLE, and __GFP_ACCOUNT with CONFIG_MEMCG.
Do the parameters passed to kmem_buckets_create() still apply in that
case?

kmem_buckets_create() applies align, flags, useroffset/usersize and ctor
only to the bucket's own caches:

mm/slab_common.c:kmem_buckets_create() {
    ...
			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
					align ?: kmalloc_caches[KMALLOC_NORMAL][idx]->align,
					flags, cache_useroffset,
					cache_usersize, ctor);
    ...
}

The general caches have no ctor, and their usercopy window covers the
whole object:

mm/slab_common.c:create_kmalloc_cache() {
    ...
	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, 0, size);
    ...
}

With the fallback, it looks like four things are lost:

  - the ctor never runs
  - the requested alignment is not honoured
  - the hardened usercopy window widens to the whole object
  - creator flags such as SLAB_ACCOUNT are dropped

For the SLAB_ACCOUNT case, ipc/msgutil.c creates msg_msg this way:

	msg_buckets = kmem_buckets_create("msg_msg", 0, SLAB_ACCOUNT,
					  sizeof(struct msg_msg),
					  DATALEN_MSG, NULL);

Suppose a bucket like this gets GFP_DMA or __GFP_RECLAIMABLE without
__GFP_ACCOUNT. The allocation would land in dma-kmalloc-N or
kmalloc-rcl-N, and neither has SLAB_ACCOUNT. memcg_slab_post_alloc_hook()
then returns early:

	if (likely(!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT)))
		return true;

Wouldn't the memcg charge be skipped here?

Before this patch, every bucketed allocation got these parameters.
kmem_buckets_create() doesn't reject or warn about combinations that the
fallback can't honour.

No in-tree caller hits this today. memdup_user uses GFP_USER and msg_msg
uses GFP_KERNEL. skb data uses ctor=NULL, align=0 and a full usercopy
window, so it loses only isolation on its rare GFP_DMA path. The API is
exported, though.

A later patch in the series doesn't change this either. After "mm/slab:
Let a bucket set handle __GFP_ACCOUNT", the kmem_buckets_create()
kernel-doc in include/linux/slab.h says:

 * Covers KMEM_BUCKET_NORMAL only. Allocations needing another kmalloc type
 * are served by the general caches, keeping the type they asked for and
 * losing only the isolation.

Is "losing only the isolation" accurate, given that the ctor, alignment,
usercopy restriction and creator flags are lost as well? The existing
kernel-doc in mm/slab_common.c also says the ctor is "run when new
allocations are made", with no exception for fallback types.
kmem_buckets_create_types() has the same fallback for any type it doesn't
cover.

Should kmem_buckets_create() reject or warn about the parameter
combinations the fallback can't satisfy? Or should the documentation
describe what is lost?

> +
> +	return &bucket[btype];
> +}
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org

