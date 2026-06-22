Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931A4CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AEB36B008C; Mon, 22 Jun 2026 19:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E7B6B0092; Mon, 22 Jun 2026 19:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428936B0093; Mon, 22 Jun 2026 19:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB306B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:54:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66186140304
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:54:22 +0000 (UTC)
X-FDA: 84909205164.13.9782806
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5437F140003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:54:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DduL7Py9;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782172460;
	b=l5JSniJ2xCe3MjuUwmt9mpSEMlG1jrUINIRgDwDBXL43Yhtn3Nl0+Bx35q1uA2bmrvDBlu
	oUCbGW+EGWaodGUnkTUu/vuyBzeNrBQfcEF5+NOXvGb8qaG/A0fmQchInxtgdju1+pPaLM
	pOVU1/Gm3BbKpE0ZQnTS+ItX3B+eRD4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782172460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnhxRL5NSWx2qm5cF+jOJULziDkVFS523GcKtm3BW0s=;
	b=EV0a0keHcQTX2a4TXn9GU0PFHcSgJ682j5qgk7cZ1y7xEjl9mxDflGqPEBnCDW/FyLd+Eb
	d6N/LLRheJGH+Qu3idDyGYZD2s4w1OCsVDTRSPOR86onjioFWiIB+C8AZJJqPMei2BEJIM
	KCx9KwqA3x0TN6vlt2gPZHBOs2dMAz0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DduL7Py9;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-691c5776f95so8046349a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:54:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782172459; cv=none;
        d=google.com; s=arc-20240605;
        b=evLgXzJ3SRL7b1R+HAK+TNdl1skqy05bQT9uHD+BqbPS9lgk1Uu/Y6Vf26E66KSIYU
         a3fo+A5C75NdIGnk5+U94uyHLgaSgl1JxlqV0nZI8BjcEaufbkhGCainNcRlwlU0kg1F
         rPf30gNdjqcdhKSz8D87zX5SOaqigjbNJ9+obKgc61GhRGYv5Zq4vcGKfGiBgksSGlVE
         nMgoNyqmR6tHlGudAdpl+IqEoy7R1UwU1bALplGasan8vZrXT9ChbS7K6aPZKCVD/YYg
         V+sLB+JhYbC3k/ETvZ2QCSjjFpRWV9L/EzvviQ+mayxc0SgPajNxb8v6SBV6ePD6a+Wv
         2v0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=mnhxRL5NSWx2qm5cF+jOJULziDkVFS523GcKtm3BW0s=;
        fh=PiM+oxHNTlKHwKFkY8xkg0h9oFnWTznYKXH8/lob3nM=;
        b=kIHLsoZ1rOIq9rLwfiZQ3I2VRN/42joS1nZgdZJUUl84ysP+Mp/MbSvSVJO2O40anM
         rvUFMjDv9byYeq3vbqe/W0lYsQPiFMqlohxwDgdbl9e/n6ksL2EuVI7XisjoIuW0NAEO
         eBBcUCEJCoJ0Q5Xlzac3tUNN6j2vc+rh4FX9gPsIL3KuFhJoJAW/QjX9LeZmVNOl0+1K
         jRm60e2S5s53RQQSeKsOtPD5d75Lp36PPGhHGjPk3YayFUTS06mQQrV1/8pgwDPs4QFG
         40Io2+panGJjvAvqNaTBz9Bz2ESnJgyPBtN0VzXILmaN+conLPP8LXt4+gwy9Nbqczb5
         UHOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782172459; x=1782777259; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mnhxRL5NSWx2qm5cF+jOJULziDkVFS523GcKtm3BW0s=;
        b=DduL7Py9w392rUWj0Tz3A65eAiGZI73x3UjWxLutXVq8mQLylK1H4v/9q3Q9hRu21Z
         cMpZcBevS5kO+9WZP9vGyRBbOgBrNiHVZL4iKoP2QTXw0VTfzXrYYxQ3OfejBF5YCZKF
         lh39R3Rs/WcB8f/EyVYURmmd2XRcPb3T54XXYMXjNiUAejE46wyzS2LMYELPNuKnsQRk
         ArhSjQAVLAeEHllVWbSPwNYp5d5h6/fcnQL3LL32z4xZeOgaDg+XwTueGvPZWLJmgIsV
         2TnyPMoeVRYEfZ+IidcgYgfTyWQs+Zud5cHj/L/wELOUCsNn/OLNNviFzGmm5Hcoke+s
         bOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782172459; x=1782777259;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mnhxRL5NSWx2qm5cF+jOJULziDkVFS523GcKtm3BW0s=;
        b=sbMRKTKhB2LV0ltsw463LPOlvna3ARQDulCKlR288/ILJ1TKuVxTXvn5NOgFFdnd9K
         1tC7YQsbFTKQTnyC1CSTm8EefOkwRTw+8hBy4VpCHzAT1rwBWa6Or7ofAqga/sC54ic4
         iLdS6qGsDnTi2qx7zEc9EsIUhww++j8piblIixOm5vjEis76Wis7IjLWGPW7bsrntiI7
         MOqux/YLESLnq0OwpFwIwyBjTXHW5Xefo0z9vRvvqmqzwCLp6uIA5LqooUhJLxg8c4sM
         jQTk0GKLVCQ7i/Xf4RdOvWhXjCBQy9y3r+1Ad+ifzIzkov8YfuqGvosqZkTGHlV8B7f3
         dXLg==
X-Forwarded-Encrypted: i=1; AFNElJ9EXjyaxXi+GUkCklMjL5oRqMC8bWS0w2RZF9VY5zbOWuL2XuB9uCWnz6DsMSXs9eGaN84dqsvDtA==@kvack.org
X-Gm-Message-State: AOJu0Yz/A6vuhda9HhSgaGKKBhocdoc033yAjk3IP+7GtcGhQbdoEYxL
	pbTK/Ur9Ygno0v7xP69fu2ZI0DdF7QL4boRvNLcQo3DKnWMKi8/QNwxGsE92Iuyhk4dgzg9ss2Y
	G67WYUAyKoGXfOXjZAwN03QY6hxMjiBJh1JpFM4Kq
X-Gm-Gg: AfdE7ckEEV26noo9i38t2Rt6yPOyPenTYPt4X6v7Y3ySmCeOYuIJfdIG+kvCCYFh+Sh
	GfXTQfC5zqgGMyjLoy5zkA70kKRlQik/G/zJM+ey/NscH0IRitBeH+0S+zCO55/3/AgoPlKQsVo
	QLIRAfM2ugUmxqFr+VM7uwodKHZURkn6nYXEuJLnPPU09PWjGDezcjw/EyWnYpLCN1M0506TUt5
	kHwWFI9XCTmwP4UfjL/0n7MJjVpz69C/8b+WuaXd/FzZlQXxL1NmAt0BqYgio8snU0HUpReusud
	gzFJjKSD9kjh30Opm8dzYijwJvmVVZJyipoodeLu7vshHouQIn/9OY2p0q0=
X-Received: by 2002:a17:907:a394:b0:c10:1041:65a4 with SMTP id
 a640c23a62f3a-c1080b8e977mr13124066b.42.1782172458193; Mon, 22 Jun 2026
 16:54:18 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 16:54:15 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 16:54:15 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
References: <cover.1780676742.git.tarunsahu@google.com> <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
MIME-Version: 1.0
Date: Mon, 22 Jun 2026 16:54:15 -0700
X-Gm-Features: AVVi8Cc74PEpV2YXCZJIskraOwZy9-czhUt_HBd1DYeN4YnAJwWFzkRCg6GbGig
Message-ID: <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
To: Tarun Sahu <tarunsahu@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5437F140003
X-Rspam-User: 
X-Stat-Signature: bt141shgoo541aiayi5qgd9na1948bre
X-HE-Tag: 1782172460-989030
X-HE-Meta: U2FsdGVkX19FjJ7/eKVIvmedz6lNETu49pKHKyAclwxdqb7t7bSqjWcxQAf4GRkoeJGMdJfHNasvwryMGAtuRIIdPyfoYVT2cm3Yifp1CMVuPrPNbdX7HVPtaFUrBPgLm0soDC3PCVwHpHiWBMgycp+NEeAiQ+sM6qn3++1YFYNFRfTdc6xnzPEgA1KTjUwBTgrSsAK8RPVQkwX6UX/4+JY0BToh8DTorH+UMdfQ7CuDNLzsNQtUiteg0m/G2SXIPDJj7R/T9yo+HmrTcYxF+xXXdQV3hfoAweOLCCecFkqnrJip25VU8PZfLlGY89WNv/5zSlpoILtZd9f34EsNhjCWHx6bGWkINpuXMzFOiBxaVWhuXrZMAVgxtiCZREbD0hna8X+OGQ+gWip2UdSUGlUCWobNdhkFQVz5m5VW37TS+GFgg0ujW5cXlfxVpAtHd3mesdCVogXHeRZHCyM/lQTgfq+kVZriqARcdLBdYtR3xL89DhrowXNtDmo7myczzI1eh159LdSnanxHI20qGnHUwt29VNAuLopZdvnlQJnRvDP3tCaYCQCp5bPrtgWWkEtiPlCw+/PoqvumxyYNMXuOwOWOHNgjoRgvklAj/DikIIPuoRvFAeyhV0Ah7Rh+5eBZczxvvgnY2prvZp5Igz2XiVqfkGytQzRJgOFTMVd8xz9sWSORHz3qdESOViV+YffJZ9ycIgPYD8KU2rGJxI3BYME11JbaIRQaoJmitXf6ChMHec4dvN9XHPKo9CZXoQMJDnCy1SzobPYuVoSMRu514ZWZeY/gxUPeHonL4fEQVY3Sv0pV/8to2tbqquy4zZF+T3WKCbRwRRjl2mXw0y7GJFBUwY/gr7kReF7onkNNx6SGrJdXUz8c2r5lj340AHswMEjHaakELV8FqIjh8ipgC7cjSwuF5p6gG/GJJe1hHXjC33XOMikRMgxi+a0fpKeAI17NboockRg20ZC
 hjx0lG0I
 B9vvHhliAv0GBz7gU8azcnZLL6YmePQg9Zn9z7BKBpa/mk7iQsc9kW8KLfNmO1E8ihqq8O9gKvvVRtwL3fTsjWt9sWax8ocvy/9ufUz7BLAuSVMh05ThmDHaL3iJ7IRO27/iRd0p+sDMvt/ol63jzmxMKw2AnyVlygFBPqSQtZFvu8rcQQ5cNG0qT8sWewWL+XuIv1ewHlZd5ZCLcORM/kSTxkKkPNmYKk9+gxJLbBWQSJAUjX6f9kP4lS+YlhVsXAe8p3MZIwbqdCEj8/BAo6Q6JyrnZlO+iJizjLfmeq0fQ0xxu3IBA33U/2MrflE1enT47OQWHLF/yL4HNvETgF/vl46iuW3mSLg0jBf1dpHhjLXLoS+kOd0Z+ujBHQAAUqr3ARXqj0L1XFYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> This patch introduces the freeze on gmem_inode which prevents

Can't find the reference now, but commit messages should take the
imperative mood and avoid "this patch" [*]

[*] https://lore.kernel.org/all/YKRWNaqzo4GVDxHP@google.com/

> the fallocate call and any new page fault allocation. This will avoid
> gmem file modification when it is being preserved
>
> Used srcu lock to synchronise the freeze call, where write blocks
> until all the reads are free. And reads are re-entrant.
>
> Incase fault fails, It return -EPERM and VM_EXIT to userspace. userspace
> must handle this properly as every new fault will fail.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>
> [...snip...]
>
> @@ -105,12 +108,20 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  	if (!IS_ERR(folio))
>  		return folio;
>
> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
> +	if (kvm_gmem_is_frozen(inode)) {
> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
> +		return ERR_PTR(-EPERM);
> +	}
> +
>  	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
>  	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
>  					 FGP_LOCK | FGP_CREAT,
>  					 mapping_gfp_mask(inode->i_mapping), policy);
>  	mpol_cond_put(policy);
>
> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
> +
>  	/*
>  	 * External interfaces like kvm_gmem_get_pfn() support dealing
>  	 * with hugepages to a degree, but internally, guest_memfd currently
> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>  			       loff_t len)
>  {
> +	struct inode *inode = file_inode(file);
>  	int ret;
> +	int idx;
>
> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
> -		return -EOPNOTSUPP;
> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
> +	if (kvm_gmem_is_frozen(inode)) {
> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
> +		return -EPERM;
> +	}

fallocate may eventually go to kvm_gmem_get_folio(), so that would check
kvm_gmem_is_frozen() twice. Is this meant to catch the punch hole case?

>
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> -		return -EOPNOTSUPP;
> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
>
> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
> -		return -EINVAL;
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}

There's some reordering here. Why not let the validation happen like
before, then check kvm_gmem_is_frozen()?

>
>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
>
> [...snip...]
>
> +
> +/**
> + * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
> + * @inode: The guest_memfd inode.
> + * @freeze: True to freeze, false to unfreeze.
> + *
> + * This API is used strictly during the live update / preservation transition
> + * window to prevent host userspace and guest-side faults from making any
> + * mapping modifications (such as fallocate or page fault allocation)
> + * to the guest_memfd page cache.
> + *
> + * Synchronization Strategy (Sleepable RCU):
> + * To avoid high-contention VFS locks (like inode_lock or
> + * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
> + * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
> + * (`kvm_gmem_freeze_srcu`):
> + *
> + * Global vs. Per-Inode SRCU
> + * ======================
> + * A single system-wide global static `srcu_struct` is used instead of a
> + * per-inode SRCU structure to completely prevent unprivileged users from
> + * exhausting the host's per-CPU memory allocator. Because
> + * `init_srcu_struct()` allocates per-CPU memory via `alloc_percpu()`, which
> + * is not accounted by memory cgroups (memcg),
> + * a per-inode SRCU structure would allow a tenant to bypass cgroup limits and
> + * trigger a system-wide Out-of-Memory (OOM) crash simply by spawning a large
> + * number of guest_memfd file descriptors (bounded only by RLIMIT_NOFILE).
> + *
> + * Flag Modification Note:
> + * Since `GUEST_MEMFD_F_MAPPING_FROZEN` is the ONLY flag in
> + * `GMEM_I(inode)->flags` that is mutated dynamically at runtime (all other
> + * flags are creation-time flags which remain strictly read-only), there is
> + * no possibility of concurrent bit-modification races. Therefore, a standard
> + * `WRITE_ONCE` is fully safe and does not require complex `cmpxchg`
> + * synchronization loops.
> + */
> +void kvm_gmem_freeze(struct inode *inode, bool freeze)
> +{
> +	u64 flags = READ_ONCE(GMEM_I(inode)->flags);
> +
> +	if (freeze)
> +		flags |= GUEST_MEMFD_F_MAPPING_FROZEN;
> +	else
> +		flags &= ~GUEST_MEMFD_F_MAPPING_FROZEN;
> +
> +	WRITE_ONCE(GMEM_I(inode)->flags, flags);
> +
> +	if (freeze)
> +		synchronize_srcu(&kvm_gmem_freeze_srcu);

Why only synchronize on freeze but not unfreeze?

> +}
> +
>
> [...snip...]
>

