Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8896CCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F648E0007; Mon,  8 Sep 2025 07:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0878E0005; Mon,  8 Sep 2025 07:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCEC8E0007; Mon,  8 Sep 2025 07:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF22D8E0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:59:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B924C011C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:59:25 +0000 (UTC)
X-FDA: 83865937890.15.7CCA41D
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5BF64140008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:59:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fFpSsva6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757332763; a=rsa-sha256;
	cv=none;
	b=OiLT85XA5LLeb2oaW4W907FnPTIwh20CNkc8tqj2Kdw7lB2p2yNGVhkamle2IANUxlQK0+
	Q2qeeIgsfs8k7YSB2lPGYkB8rBVJwZRRxcNQtMTYt98rwUYncIb5OUgv1aFJeLZy5WHYUZ
	3j2maTODGgNVMAa9CW9s+D/GHFH9hxw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fFpSsva6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757332763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vd0Gp91t0AdkDLXSNmOHCDstZWivpuuewHLUyrk+zgI=;
	b=Hgosy7iEy/+/fP/OqPTUYHaAhvXmTRQDZq35frqbzejGfyz90+Ri1NJ7fF23MTJtaJxrB3
	Ma/96b0sGKQxsPVmB2ope+Cd9VJJ/CF9xCM4D+dkvvHqPgoIdAuqgg4CRXRSVCD+f6rvb2
	8hkcKVvjXjRpfdbayEAIWAbhc0ZVAfg=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5608d792558so4847495e87.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 04:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757332761; x=1757937561; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vd0Gp91t0AdkDLXSNmOHCDstZWivpuuewHLUyrk+zgI=;
        b=fFpSsva6T4m9Om0QJu9/yN7HI/hHGFZeg6zwx+KN2geF+zhZG2NDAZosKCxNtU5eTR
         ffmKtBJo64RUTUkC1sAXNn/kMwDoyvxebjJw62Okc67FwadxkglnDKSVPFL0Q8KXr8X+
         VfYUpowqdp9VDN+N2UITQTh/P3hLCgpBSJXV4reF4gL29Xh4no68L/gNT1ZEWgyijg4a
         UHTaR3S3NT/no7fLp6QZ6BEE/nWqAEv+rZJYIln+VkLzQikth7FlgikYFzQshFT7uiLc
         x2LruhADNweRoBywZ68cfOy3l90QWN8iepV6AcTaY8uzOHlBv5y+zav2nvlHsg7NyhsK
         w2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757332761; x=1757937561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vd0Gp91t0AdkDLXSNmOHCDstZWivpuuewHLUyrk+zgI=;
        b=SEo6AEdoul9oH/MqB7CX2nJUjEU02Gwj5cr+fCC3wPhxM4P2NBZ4EABFW7pIv82MLa
         jr0EKS2z245+93XCPhqjRvdlRYkCUO3FnmQRhuNvBcgQfmN9nfcWCc+8h+Z8ualnYqcd
         vWSJButC3Q/bm0BFJiZy8ld2oSzFZwlS3h0ZG53XaImQVwIj7PHyd6jzNtDsMpMnwiJc
         DF9wNeuTajkABmzqBiQ16Ayk+HrJStXte3ev563dCUIofcrG0Vf6Hys9Od7P6piYLOAE
         k/1nd9vyQFUcXVFbNNuIsI56X13gmKd8pT1i9v3OYfEIi28kmz09qVmd8HczPz83zLj3
         o+6g==
X-Forwarded-Encrypted: i=1; AJvYcCW3oZXiJb+qm/UXqxkxoUIR1pPVCkVUQCJ5PpnuBltRLCMhnCZeAnGOu44Km3wxkbnhuMZJiPCWug==@kvack.org
X-Gm-Message-State: AOJu0Yyu6C5J1erTU7zsKg0V3u2TwtU/30tiL5y7OBR4XDYSNhn6/E/A
	Olxh5D3QLu3AGCBbbEDC4H4Xg2BSS7StkiaVieAPWa4ibz+WNL2ySZUi
X-Gm-Gg: ASbGncteyPieKB1GgxYzc6UisWxbbEeRLsWBhdAPXjFegdORL/40dbanXESaG3ts5Cw
	uCnXo9c6K476WlOE6Kt+8wCsXcc3B7jC1Ql6n43yFVUjQtJXHNp+TmahgyCHlDVKb34rK0GVfz4
	4L3HhUpPlkcmDQfjh+q+vMwRXTws7GLIdpaUiyvElP8j+CtccTTFNtlcULDlc6He5dXHTGBPR50
	bbZA9QIR+Oe06vm8+xgnwHH8QPxD407lQK47hqkyQm+8X0/s4kauZOLQFMwFvlWd93tcfIcSPtr
	xL95ixspeosrMd6T4IGx5a5tqTdbygxMGnzBSclfOJHMUwfEBc7jzFAwQi67ueXhu42KW2/e5t4
	wNjjiIbnsmW87R+Mr4udMo1E5WSZr
X-Google-Smtp-Source: AGHT+IFbG7GoBt4KHwMsY4mmFph5x9B/J+LW0gLY0cDeVIB+7WdkZBbrf+Q5LzBnwB9+VTjigDATyQ==
X-Received: by 2002:a05:6512:b89:b0:55f:4e62:f0ca with SMTP id 2adb3069b0e04-56260e427bfmr2110773e87.29.1757332761024;
        Mon, 08 Sep 2025 04:59:21 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5608ace9c71sm3518718e87.73.2025.09.08.04.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 04:59:20 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date: Mon, 8 Sep 2025 13:59:18 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v7 04/21] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aL7FFpIMmXtzzSL1@pc638.lan>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-4-71c114cdefef@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903-slub-percpu-caches-v7-4-71c114cdefef@suse.cz>
X-Rspamd-Queue-Id: 5BF64140008
X-Stat-Signature: ge9ibmj9amhafjq8qk7sdpdr5mz1c6ja
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757332763-175920
X-HE-Meta: U2FsdGVkX19EJkoI5fkkwpCepcYrQpgYmuriak0/YRo6GOGAISmg3tioxZZOFtMDl9zaWU3bRp76O//6ACyOENsQN3eG/PHVGe31C0sVkVG/G1kFuc21g5ONlT4EeyWN/wtncXZmCIIliEyG12MciPepK9e+Op4EcNiQwKHUmsdcTcrKUs+rWFKvfyj7w4AS3tol+E08q77c33FF5AGCQhuCCRsxDyjUtLizsY81bfwT9nQbqu/3MwLgKJhWNVwyYx+NzfG/CzbVESJYBrHHeeAipnJxWZ3SNy0EjAkGAXpGfocvc7y5w0lolww7HvRD9pXvECpWhAA5c1NNGrf7WITlFgUo968P0/uiWQGrZDHZP8rYl9Ke4NFtIzbQi4ft8bVxWK6fuhmhbVWms2wHvWHmvXvOb/aWtKZsWjnvRemTzO5z9UdWmATiaaNruBvXBW8fBCW65/tZ8LTXwp2Qmngx9K9Y6sBAhyHNosv76aZQy0u4j8g2Wf4ltRIHbMWmAZ4hW3xmwiy9F7Qoj8e/3JNyFiU23PRuxxKnK5emUVJBO8r2slxQhVDQCOzAtJgBNi0ZGgyZ7evPYYpihs5m1bJFPp2TlIVxC36dx/xtMaCbp6LsfK6s8vzxbTEFN38y+VKxbYitFHthFj5gQs20B9DRZ8fTNnjYV+Znm+273zm4VvxFrCHPTfih4MbgG9ry3IShQCmoObz4diLg0O+VrmqIhSejn6CFv0JSg7vPV6rtahulSMFzJuWQM5nrKtwH1/8/lE8XDu0m0RgR6KYcOf1Jakw6yo/ywwPUQrBVM7xldvavsCX+RcL5Zc6elgevdFPW8t9Z5U6AYdOCKgAb6mPWIsrG16jqcnOrZlLWl5Cx5SqOoYnDIXKnEQD0+R6CgLNoHHpn+MYvRKxsu4aMZ99slR/ZB5/Y60Bg1A4c0bYf+9Wk6j81+LT6zuWLdgxBvrphMbiZbtRRgEh3XQM
 psMulxch
 wfs3Gj9up5dG9s2FYcttPNUF1SiGKwnzL92Dqmh4LcNHjpo1B8viGOXexizDS7ekgB3uYiQ+gWlo9m1qo2RSSiYn0vtcYJodfPWlpf+m25bIYp9WgbdCK4QEKX1s3yyyhtJGRMdmeLPIqpJl4EUZOZbF0di5N9N16577o5pomXRVTohQPkQIVonbI+rE2axBLX7eKeqKwC03RIJVorfLYdKQLzwk1bVCHnt53tVxrTwR356KCksXw6rmhxy6ImweilrtTgYaS019u4rgGxavbVU/3DxfgHGBM482C3mo0Bz5StWHrm58DjAW+qKEzj9ATIskrG/PU0s185cUHmiPmSW7xESLmfiNstKtMOqBP4bYciwRgCVcRy4w/YnK/ovuukFFhKqh8VxpUdL4SDzBtadhwu9AZjHLOD8qxuhPlqX8U0JRrvz/v0AGPn8gkZxEPMz9alZTDOYD/X54GGICB4vxSrU7QBLK0J5Z2E2pUOGA26x+i9aD3eEIiNYq1SPsZPhxO70UAiOXDPNLxhqicfusqNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:59:46PM +0200, Vlastimil Babka wrote:
> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> addition to main and spare sheaves.
> 
> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> the sheaf is detached and submitted to call_rcu() with a handler that
> will try to put it in the barn, or flush to slab pages using bulk free,
> when the barn is full. Then a new empty sheaf must be obtained to put
> more objects there.
> 
> It's possible that no free sheaves are available to use for a new
> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> kfree_rcu() implementation.
> 
> Expected advantages:
> - batching the kfree_rcu() operations, that could eventually replace the
>   existing batching
> - sheaves can be reused for allocations via barn instead of being
>   flushed to slabs, which is more efficient
>   - this includes cases where only some cpus are allowed to process rcu
>     callbacks (Android)
> 
> Possible disadvantage:
> - objects might be waiting for more than their grace period (it is
>   determined by the last object freed into the sheaf), increasing memory
>   usage - but the existing batching does that too.
> 
> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> implementation favors smaller memory footprint over performance.
> 
> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> many had to fall back to the existing implementation.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h        |   2 +
>  mm/slab_common.c |  24 +++++++
>  mm/slub.c        | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 216 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 206987ce44a4d053ebe3b5e50784d2dd23822cd1..f1866f2d9b211bb0d7f24644b80ef4b50a7c3d24 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -435,6 +435,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
>  }
>  
> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> +
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
>  			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
>  			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e2b197e47866c30acdbd1fee4159f262a751c5a7..2d806e02568532a1000fd3912db6978e945dcfa8 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1608,6 +1608,27 @@ static void kfree_rcu_work(struct work_struct *work)
>  		kvfree_rcu_list(head);
>  }
>  
> +static bool kfree_rcu_sheaf(void *obj)
> +{
> +	struct kmem_cache *s;
> +	struct folio *folio;
> +	struct slab *slab;
> +
> +	if (is_vmalloc_addr(obj))
> +		return false;
> +
> +	folio = virt_to_folio(obj);
> +	if (unlikely(!folio_test_slab(folio)))
> +		return false;
> +
> +	slab = folio_slab(folio);
> +	s = slab->slab_cache;
> +	if (s->cpu_sheaves)
> +		return __kfree_rcu_sheaf(s, obj);
> +
> +	return false;
> +}
> +
>  static bool
>  need_offload_krc(struct kfree_rcu_cpu *krcp)
>  {
> @@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
>  	if (!head)
>  		might_sleep();
>  
> +	if (kfree_rcu_sheaf(ptr))
> +		return;
> +
Uh.. I have some concerns about this.

This patch introduces a new path which is a collision to the
existing kvfree_rcu() logic. It implements some batching which
we already have.

- kvfree_rcu_barrier() does not know about "sheaf" path. Am i missing
  something? How do you guarantee that kvfree_rcu_barrier() flushes
  sheafs? If it is part of kvfree_rcu() it has to care about this.

- we do not allocate in kvfree_rcu() path because of PREEMMPT_RT, i.e.
  kvfree_rcu() is supposed it can be called from the non-sleeping contexts.
- call_rcu() can be slow, therefore we do not use it in the kvfree_rcu().

IMO, it is worth to reuse existing logic in the kvfree_rcu(). I can help
with it when i have more cycles as part of my RCU work.

--
Uladzislau Rezki

