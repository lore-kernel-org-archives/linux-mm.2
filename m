Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA106CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 00:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E1A6B0005; Thu, 28 May 2026 20:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0150D6B0088; Thu, 28 May 2026 20:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94766B008A; Thu, 28 May 2026 20:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE4A06B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:00:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 542ED140A9F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:00:05 +0000 (UTC)
X-FDA: 84818499570.30.ADD1346
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EFE9120010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:00:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FBDdlP1H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780012803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lWA22sBER7v5Bm8fMESQHwBbc2tnWs5QQVcuwUnnoQ0=;
	b=xiIfLLwCIg5oCqXUwlTLTmXn8FGY9Ms4ldERXYKnjehtQVGxOM4jaiXkr6B5MZVue37mGL
	FPhQSGGr+7hebrIb9uFfyrrpQP9OY73Z0xcOyS0YqmL07D9oEqEqcqgIVGuIxXPkWUNWQU
	Ed7PA50CS6Ou+mK8d97Vq+csjTMtBYo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FBDdlP1H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780012803; a=rsa-sha256;
	cv=none;
	b=myHYuAthQR/H0eAqFzKdZp7r1cmRNk6iV0Z5SkMbeYk6cECVzI9mWC5puV90u4HpII2IHB
	GiXcP4Ve9dEQlNuSlQzYk20/L92QfneP/ISaMppsqyvxVBR2Q6mBUHKMEvYCfoVfB4PfQJ
	VRZ08XR3t0qmLK21SsfxBXcvZ8l41rc=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e4de538f83so7570507a34.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 17:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780012802; x=1780617602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWA22sBER7v5Bm8fMESQHwBbc2tnWs5QQVcuwUnnoQ0=;
        b=FBDdlP1HDiIbbn3SFSpqMbY0TEf8u1Kfgaiy1aIJ9XS+Jwlid2UJk8/O+Hzt32JjBS
         RD+wiGQLOPs/nciF48tgCIFpJCoXR/YUz1O4FABYF5LROZGLZ49dBI9xoZYlPDW/IlHe
         JQ3Zr8TMUGT9rryfjMSlAWAJ7pUPe4bKT/eNzFrd8QvLzWJHbMy12XoODS6F8j2lZH3k
         ZHV3DKHXD2WdjbHvcyIrjnmwoDfxuUriPnBol0Sdw55ObHCN1D1n/HvRg+EgHrDOUeM3
         h3MeAFZ4o0WuGtNBwN6MPBJmw4pC5YJctuPQsX8jyIiDEzYlCDs++VdKZH03PwrbukH1
         L4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780012802; x=1780617602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lWA22sBER7v5Bm8fMESQHwBbc2tnWs5QQVcuwUnnoQ0=;
        b=msoLYWsxrYTnNCfyKmxYTBs1jNhPzAVq6Q1BYhpseR87gcvy8yXXh4FdgqjCriiPVP
         T2vA2zrdhQzfGXsuKTzmcbYIDe/VPQCtN8tI2h1B+Db7hj15RhniX5tmhRTQZrmDqlCi
         iiunZSkwwb+tQH859uIPmXQ4UZquVy7bLJFaPgWlOVA9HjoDjCWEyiYitTkv+Z8aCxUp
         zfiikZddZT7bdjQpFelc4tTcYJTNU9f3Da+ShSD8Ha1+3+c+sB7bRw/hNgOD4q5FOZL8
         FGD77dXapHsVttckepr9ItoBS+vhzZbsrB/u2lrHMIV5nBsDNOwIy0i9xOQ3O7p7FC23
         I0Qw==
X-Forwarded-Encrypted: i=1; AFNElJ9vf7KaAV6ypOT5m/30zYx4BzwCx+OkVIIrS00Do66qlWlNRsiNblOuv1Zf+u5r+jRpiHZRIML/yA==@kvack.org
X-Gm-Message-State: AOJu0YxmKkxWC19RhQ6lN3b3ybhnkv+BN5sgkSbZfqEkLcIwKdquTOqq
	iF1GeqRVTKDBP/r0u6ZoKVmSBpm0NbiTG+ei48doa0eqPqkmiXoSULs/
X-Gm-Gg: Acq92OHgAKB1Qn788KO+1vReORDuLSBwaYgUaGdbEEuIOgME3DaLxGbMxrMgJe7Awkw
	P+cBRHt+mCBxiFhoKIe7n6mYV8BbeGdOyzSooYlFTCcQbQy/MNmeOGCSOoUQzX0+ZJ477D8aw0O
	/PGRqrsyB/C9TdeeoPFxQxC8qFo0zDZyvPx2i46Uv254BXgKLHdySFCb/VpexL6hfdpJ9EeRQ9l
	WyA+wxJ92BHsThTzNRd5iG5XGAZecp2lx12m4BW7SAQ0rL80PQAtII3qHTT6DVhjGHJ606gGtKD
	++LDqncJA7/VF6w+EPRgksoq9BjzXlJwNvquL4IfY1NmJw6WHKAf4WBmYdIMWF2vG0TIA9WzEr5
	DUfGrb4i723vv4oA9EHiSLgkdJK/xqRa6YGVSyxxwT6FXcVUce75kS2LZiaFxXjjaqfEWW6VSod
	ZaSk5f5tcUkgtImd5O5p16U0E3efJLaVBx+cAntHJHji43NjAhjw/b5ChJWHl9jl9j
X-Received: by 2002:a05:6830:8285:b0:7d9:f50f:96ad with SMTP id 46e09a7af769-7e694dab86fmr588038a34.24.1780012802437;
        Thu, 28 May 2026 17:00:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695a1d33dsm349116a34.0.2026.05.28.17.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 17:00:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [RFC PATCH v2 3/3] mm/zsmalloc: drop class lock before freeing zspage
Date: Thu, 28 May 2026 16:59:57 -0700
Message-ID: <20260529000000.652785-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260527115930.3138213-4-haowenchao@xiaomi.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: arsp96knbcbwqwrquq9dj318keddkw99
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EFE9120010
X-Rspam-User: 
X-HE-Tag: 1780012803-972869
X-HE-Meta: U2FsdGVkX18Jt82I65U1qKQ9KA+bFeuVII3XLj04eUywxbiJW5IkfEyZXe585QBFXIvz1NIOPHiVMiuM5sfhLnygc8iSJtuecbxSg33DzuVdZBBWxQJ+2i/20CPXuOWO12IfbnbRkX38tCGj/0nUtDIUer6wYvyZA/8wiuQoeD3c1f/quZlf7DylESazS1NZEmbq5uiB0eBA1EkaNDZi0gQwe2Fol/jINd7yi/83rpYd1MQBv2KhrZthv+x1+Jeoxr05pofp0sd9aTOvZXOp5+hPx5bvRsOrreAyLgpLG/rs/kZJvgGQfJXZtnal+4+Tjwlsq/mVC5irrJCjm+dbbe0pjs/H81Uz+omTfvPE2UGBZ7ipaTTKjDOmTjQP9Mhn12znhDTzNHFJ4QAfj90t4dptofO/hGqvEQDKSpkPTAxvvE5v7xt+pORCyppXo9hq8rMrIZlSZA4EkQeYHskaUQemZyTpmN0ZINegFPxTdD0mpicmI49GTMIdu8B/BOZrRn0YfE/BBBx8zO+spC0AX29joNlZzN4nNwHbkeVDgOkk1K1IhuhahQ0q5S+JXC53XXOLRku8UOjkFWr7dinYCZxTTpBcPha1a3eOSeTvoGiZqeBRNkAtQUlODDQpeznrE/KdUA7gzVWVncPN7bZADT7fd6ioemfGjdxmwu493mSQUtxJIS46157GSJtRwaw8bX4+NWe5/aQlq6kYOqVsA+xId8XbixzgNePT12rza5aBeVSRNP9Yw0TtJRbSanhV5cjqqrqBEJvFLMvIVPXMyT4tDL7BSTlNhHxRFKdva/8KeXF55yHvmehVT4Hj2xpD6qcl7kUKQihoIV9FpKCxHlpDo345CS8lfN+M9A4DazNf2AXknEHeOZMPVixIUb6A8Xu8YOUX9AL/5+1QJ3/rH0yhUzKmB8RA5MP67hdwFazrv71ThWMi6CB/T1vXwQOSlqd1fBtLrbtDc0CUauN
 ImVQPwNH
 Ci+tpVzBoYhGlBXEtqJrDpQpaene3zqOAEGzCC35DvlMeTcmlfiSSgcsIzMHiyTikG4IivuckkZUFI+ay+g8UqwVMQTccoLjxXp8sly4XmD2pED/lAcHpupqnmjpQDqeB+3lHXQerDrGy9ffA5Ha6WLMPSu+cCjahgwNprRTZhLhjuoUdu7GbbYv7urFueSPsKg8+xKlkk+VIzQorHEZWqZ1i1f+eDuACHDax179ASHZB/w83EH3qqBNTUM/+loGRixdiM635ibS1MEHVrQnc0RlJaDlGYCa4DGoTgWLVc1MzFWZoeguWr6IgpwS6EwadMNETI7aaHnNKVSYYqMufQta2ZaMFMeYV6lF1c+YqMTEx5O8+2QwcouzX4aDdKq9qqFuNQTF+OO4KF3WMPKv28S7RPqfWBFiaDzj4GA8yNnBS6Mfdp0IICbiGV66aafyYs9gBesflaBRTaFxk10oM6u3VENKQqEM231A23t0JkIbLFHcDQpdEIUgwFcjRg3wTSamqE4U4xHuhHOPHfSrcM4m+PBT1uWtQ+oOjcl+p9FzWUKBB1OCZZ/zPTS75jPknwC77FTh5WCfcfqIrYK8w/uSUpVfSXtZm4K+IH7KJK7QvG8wH9c1TEQ1KXXG/lrovWSVjtGI1vLFlpjmKb49VEgjbIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 19:59:30 +0800 Wenchao Hao <haowenchao22@gmail.com> wrote:

> From: Xueyuan Chen <xueyuan.chen21@gmail.com>
> 
> Currently in zs_free(), the class->lock is held until the zspage is
> completely freed and the counters are updated. However, freeing pages
> back to the buddy allocator requires acquiring the zone lock.
> 
> Under heavy memory pressure, zone lock contention can be severe. When
> this happens, the CPU holding the class->lock will stall waiting for
> the zone lock, thereby blocking all other CPUs attempting to acquire
> the same class->lock.
> 
> This patch shrinks the critical section of the class->lock to reduce
> lock contention. By moving the actual page freeing process outside the
> class->lock, we can improve the concurrency performance of zs_free().

Hello Wenchao and Xueyuan,

Thank you for the patch. This is a really cool idea and I think it makes
a lot of sense. 

LGTM aside from a few nits, with those resolved please feel free to add
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

>  	fullness = fix_fullness_group(class, zspage);
> -	if (fullness == ZS_INUSE_RATIO_0)
> -		free_zspage(pool, class, zspage);
> +	if (fullness == ZS_INUSE_RATIO_0) {
> +		if (trylock_zspage(zspage)) {
> +			remove_zspage(class, zspage);
> +			class_stat_sub(class, ZS_OBJS_ALLOCATED,
> +				class->objs_per_zspage);
> +			zspage_to_free = zspage;
> +		} else
> +			kick_deferred_free(pool);

NIT: We should probably add opening and closing braces here as well since the
if() case is more than one line. 

> +	}
>  
>  	spin_unlock(&class->lock);

Sashiko caught this in [1] and I was confused why the likely() doesn't make
sense here, but I finally realized that zspage_to_free is likely to be set
when comparing trylock_zspage() success vs. failure, but it's unlikely to
enter the ZS_INUSE_RATIO_0 case to begin with, so an unlikely() seems
correct here. 

Thanks again. I hope you have a great day!
Joshua

> +	if (likely(zspage_to_free)) {
> +		__free_zspage_lockless(pool, zspage_to_free);
> +		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
> +	}
>  	cache_free_handle(handle);
>  }
>  EXPORT_SYMBOL_GPL(zs_free);

[1] https://sashiko.dev/#/patchset/20260527115930.3138213-1-haowenchao%40xiaomi.com

