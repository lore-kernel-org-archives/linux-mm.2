Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6396EC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB046B00A0; Mon,  3 Aug 2026 09:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582C96B00A2; Mon,  3 Aug 2026 09:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1216B00A6; Mon,  3 Aug 2026 09:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24C066B00A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:27:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8E05A0655
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:48:23 +0000 (UTC)
X-FDA: 85059482886.10.863A598
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf04.hostedemail.com (Postfix) with ESMTP id 200BB4000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:48:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YXUbK2bW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 35GNwagkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=35GNwagkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgBz2SZWInGYkxeV698PRx7vfdGy6WMbWCS7qMcdi/k=;
	b=quRuXAdSTgkQD+s206zzhGcGZruA/N/mgjtEHSyRCHNOR20kyuWuTtwTVpxiouQXgSCbWK
	4DiGf+y6HwG483VdD64Nt0Zn8A/UQ9Wq/ySmgV7Fz4bH6Acsia91L2LMVIoVWl2SxpWrpu
	+7q/A2slFrIyBUYlbEnrHJqwWeFHs7Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YXUbK2bW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 35GNwagkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=35GNwagkKCMcnyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750502;
	b=8VBzZwb1XpEVpQoIGz3nzFkw5Rtsi/wMZhkaOOwWTjw+kF2sMYypzNL5YrEcOMDS5jbO8j
	x7Sb1qOs8ZCXZZXR2/JJEwcsPvjaKyZHr3lffH/xRHeR0Rge4+rwTMBBnQjifyF1dOaIjC
	uXUHwpIOnpx7T52OUI7e96bTZfOVem0=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-495569acf8dso12689975e9.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 02:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785750501; x=1786355301; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wgBz2SZWInGYkxeV698PRx7vfdGy6WMbWCS7qMcdi/k=;
        b=YXUbK2bWdHc04vGTVKcgqkHWCtQoLjGl8ksIjQwPDG5F5cvMWIRMx9l+r6XBE96Rqx
         ZGw5BnjtYLjIoCIBCvQ+Mo3X4ID86DrklUiJUHp8EIlG63zwKmBf3KEs+SIjenYhZZ9l
         F9HQAQrg09ewnKga7+iUy7XlCjRiRFxPi237NFmaU+za3fZykJmhPRKFDuQAEisEGa5y
         UShPxuDTmag6X5wCH981Q+mEtsrCSymRm2N2ecwDZ1g8w1QzFjcteu9iJ3IDx3ErxKYz
         XCU5nu1lnqxC7Wz/AOv/1QqI469waArDgxkwnJ7eqUOtJeIVH9U4KHaMI1ekKUk3dxV5
         dwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785750501; x=1786355301;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wgBz2SZWInGYkxeV698PRx7vfdGy6WMbWCS7qMcdi/k=;
        b=j0I+8IPug1/aZojuURwknc1kYN2fjZnOafVaxt5IQPjBlxmCZw37EqDARA7wrNz9RH
         QZGzILvFIbl1NeK2WhRo+qzugkNzfpA9fgS1StM1bpnOKAy90qM+TcWpcCEA6kocy4yR
         SKRWWu0+SrkZYWSzLz7yfaGq6wBR41RyIcDPpoGxPJDVtWHLkgfGangObNtkcGAqMYii
         AHRbqiWOi6ZGqOmNFqOtGwfwy1Pau4UaESuokRjF9QUDbXkRTXdSGbdw1FM3w62q9GQl
         TkDIIcPoc14Pc3wqxPXP/miYXpfd15R9OK6nmKG08bg4SuvyyjCGcup8Fbf5Iw7tQUCA
         mPdg==
X-Forwarded-Encrypted: i=1; AHgh+RpkVmsoTftug1GkGJL7SWP2HWc4YhVcyxXa7RSmj8t7N96zO2cdHJZGhRGZod1sd++36CjSaUCByA==@kvack.org
X-Gm-Message-State: AOJu0YweLGE58+JlySbKd4wxOO91JLLtn5GMdFltKZNBS6xrhiaHpM59
	8ZMPyoCB7HIwk/oPzqVa9YVoJJKYyZjGJO0gtMFrbnj117GuXu8lDNAd+QmVp26/8rLHIafiY9g
	rZ4j6cIGOwG0Dx8788w==
X-Received: from wmsu12-n2.prod.google.com ([2002:a05:600c:c3cc:20b0:495:6d4c:6fea])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f89:b0:493:cfe8:5b36 with SMTP id 5b1f17b1804b1-4980c66d7c6mr159543425e9.8.1785750500288;
 Mon, 03 Aug 2026 02:48:20 -0700 (PDT)
Date: Mon, 3 Aug 2026 09:48:19 +0000
In-Reply-To: <20260802215459.2769283-3-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-3-surenb@google.com>
Message-ID: <anBj40CVAhcGMnQ4@google.com>
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
From: Alice Ryhl <aliceryhl@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, arve@android.com, cmllamas@google.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 200BB4000C
X-Rspam-User: 
X-Stat-Signature: 8nwxe3fsmybij7n6fskknrng8cagf5ax
X-HE-Tag: 1785750501-421325
X-HE-Meta: U2FsdGVkX19g4eD6/hcHrppeUzHq8Q0vne0HlpRKZC1WnozFGY5dY9ZAy41lW8+fENQgBOWHOYRvqfBIRpGx6juY8T8slsCSjqsAsRjTPKZwAeii6lWRNfqffe7kljPI/TidFmPQipDDLSAK96wBamu3aYV25rlwy9SlblQJBTjHjS3QUoJ7uOksLh4eAVP32O8RSMWvrAUca8/JAZI/XPJCliN55qEt1/cNE+JOHxu49C86Hr+y+6AditSXz2S9b4ZfibAaNMR6ojTpL5u/buXF0oqQa49Tb8fBE6uI3JIx7t7WWsSlXdNx9lACZ0G3sof9XbP0oHtpwG59tDp51AVKlXFFQU9uAPMvATqdlZjtrrftil+BKRHjTVDOuA4wTj+pVI3NshpS5bQwPQfFaO1bCWIoy8ykgPXXnQPAhq2LK0Fqurymdz1fpU6oT9a/xi7OHOiQbKlipvqZ8nD7mxYX5k1aHCi7md7FMBt+1cvQp+qfAEUay/mXZdwhnXRD8o0UIejm0e2FpVVtQayjamCKsj9Rvpygy/+0jO072JHarMmfLGfxHDLvojnVNKV4yrqWQPKXh7FtGwJg9C9jH3INY4z2PQw2sI7b1DoFj0vwlk6CkQ7Cc1Dwu/BcF1ZpsyG/mrqguZgI3IpnzaWf4XonqlKGrIIG8QUXM8ljAibGwYCZLDxcc/a/EMdZWGmpsMHrd24QIP0Svwiz07iE0YjLF3xF9OXdLQBsdrRqOcY06fqsOhXl7hhpb+ft59dyCQhup0RUU+XHxfpRQdt2YGvjnxACKF1cq51TwmfswP1N6LjWj8ENhns/NH2UyaFnSzQSLPhLv3o3D3+Nl9ONh/kUOBgy4SkxuzqvGjrjUlq89bmxi5lKsEN9pPFDAbawCJ0VQyMqP6WGhO3vYG9ohoi3RzPmVMSHCw5mgD6krl7hwKvzKCbno7OUvnRXC4oORBMzVEhgpeSY44LJNBg
 5p69OOj7
 ywX6P5pqLOzWXIIL7XOs82QnhraVDtjMdIOH4xyV4+iOHJtjAtLW3TOkQBQiQ968E/KzehBQdRM1lAt/l1Oby4tGhmFz0ZCnCvmUQEpqbD9l/j9oY9a7bcrl19EIXSU16+nZPcSiGP+TBYbeD8wG0Y8VQNahhooGgxnauU8fF+DmjHfQ5uppVmIoX92E816x9MXYa9TdnY6KszNyHyQ34J5mVxkSR8NsvBk75bfZ01PvfcJ9eFlLK5uK0kO2kEujr9t+O3NPd9ojY32gciVX588LZTNky17BN6u2jq7aW8MB6VksYrTzWPOcTPzXeSet4tG/eWXrFuFDCmBZGEyXOqyMipG/D5PzgWEHUlhRR2eZf8OKCpDU2VcVnMGRc1ftYiv4wmJb/xuFOA/Kish9V8qE9yYg4u/2kfcwvipXFxCm39Lr5rPjIhIyYlPW0tQeK4U/wRAswXD7NV+rjdLZouoOMmbVWWxGcvMdwJKDrgiUlXQyGCZoFACKAPUxwzuNSO/qHTnLSL4Luvemfb+m1P9x+5k/8JvBTOxyJjoHysbp2ZUE/mjkT/DN/OQuNE7jAzOib669WFIzlfqlZgDDn9+OtLzip+XJAokpXo7VC8EbKg3IN0+I9UrNG0nMAmSZ5vAcs52nJPJq7diQGzj35E6LQk6VMR8U0r6VpCUmpEr/1JIX8b5eP9dSt1ErojrTU2Ycr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> it and mmap_read_trylock().
> 
> Long Version:
> 
> == Background ==
> 
> Historically, binder used an mmap_read_trylock() in its shrinker code.
> This ensures that reclaim is not blocked on an mmap_lock. Commit
> 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> support for the per-VMA lock, but left mmap_read_trylock() as a
> fallback.
> 
> This was presumably because the per-VMA locking can fail for several
> reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> to mmap_read_trylock().
> 
> == Problem ==
> 
> The fallback is not worth the complexity here. lock_vma_under_rcu() is
> essentially already a non-blocking trylock. The main reason it fails
> is also the reason mmap_read_trylock() fails: something is holding
> mmap_write_lock().
> 
> The only remedy for a collision with mmap_write_lock() is to wait,
> which this code can not do. So the "fallback" after
> lock_vma_under_rcu() failure is not really a fallback: it is really
> likely to just be retrying in vain. That retry in an of itself isn't
> horrible. But it adds complexity.
> 
> == Solution ==
> 
> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.
> 
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

