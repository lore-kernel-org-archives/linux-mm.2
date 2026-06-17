Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60318CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D736B008A; Wed, 17 Jun 2026 02:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE1D6B008C; Wed, 17 Jun 2026 02:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD126B0092; Wed, 17 Jun 2026 02:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD7CB6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:02:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61A388D262
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:02:23 +0000 (UTC)
X-FDA: 84888359766.23.43EA692
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B52CD4000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:02:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1qEgAUA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781676141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tdg+qxsERN6xrjUnxPGS2XNaJdEod0AKmfxv6p5DAjE=;
	b=MmXF4g5FoK1VIGuZuHQRf8Yi4P4+YKwKO+tjXd5opRQ+nM/CI7/bokUdYG8Aj6tuN0rGIA
	0qkORwGQUM6W3/b4fr791l/B9Erhjw7Lo+ptUBCPCpH7tgfoVNuWJeBaS5ghdsrmL7qz0Z
	Kpv1qY/Ntw2HH1i04cqnQJwSLib4WDs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1qEgAUA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781676141;
	b=P/XU8EPIQuI1HHmrmyDr1MS3XxuO538CbjyjuQBmZ93Tbx1sBemXa+FBQF9hgKrF9Oy+OG
	eAcTM6KA6XLSc1f5CBqLw4YbECOn9Cu9HDqr4sX1LTt7qeCuY65mUGJCD8N36Np7hegvEw
	frp3ktuDh39LynVmaZy4/+jZfP7ReEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 450A8600AA;
	Wed, 17 Jun 2026 06:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B2B1F000E9;
	Wed, 17 Jun 2026 06:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781676141;
	bh=Tdg+qxsERN6xrjUnxPGS2XNaJdEod0AKmfxv6p5DAjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1qEgAUAo6blDAhN91UNiZow7zQ464yVflIh9uH8SnlNEterfQJsfiUwxOWvNfU1S
	 WtERR+Hb2aOl+EQ+3PLnHJGjOOeev5luXk98tx/A1znZ2jguGLacUX37MBFlDK6zDp
	 FTLNL4zrANsVYKUmoQxNZijPnHjV9oPA4TOCEDTaV53FLw7iDHFP3yWKWCOTLedpkc
	 VWwPuSJPp4BlXilsYd1YU2kUB+5y+UAKVNx7swEj1qimxwoKP+csf6le0/wIYrF6/m
	 /O/ejAsblbG6z2mHY4Y9SQbL+qTQFcVtEbVb2j/mDZtplx4AlaqwpDX0/YGmcFkDOP
	 aihEFDXrBYoYg==
Date: Tue, 16 Jun 2026 23:02:19 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm/vmalloc: honor GFP constraints in
 pcpu_get_vm_areas()
Message-ID: <ajI4a0BvAlFHihJx@palisades.local>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
 <20260612022648.13008-2-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612022648.13008-2-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B52CD4000D
X-Stat-Signature: zyejwgkf4mn71mjie9j3a8bs6q6fiq8z
X-HE-Tag: 1781676141-980104
X-HE-Meta: U2FsdGVkX19CJhLyRNPtgyl1EHrXWt3Bfmuor6/F2bSJ8t81JMNkheQRSy4ghetTiSR8f8a5B9vs3PVsuowNn/i5C6fI283kiyLYtRB0N3A9oEyynysu9O9JBeTdDQS5MAaKSQoHRGK9wA0IHIZvJwua2ITYbM1GfsjXHCVEKoeRKhXLWJ57rhR/NiX7SGgRxELDVOpElls+VDpaRVcngGXb/Tyg+qrDchVxiBk8oYlEQQFEORT7RNj+bK0c51xM77QbOgMMpYQyoosf+cTg0BQ44BkZj5j1ReV3waq7ePef1DJIZSHULRVSh9qoKE/E46bvMDhV3EBtod7HyjtIB3IEWFrUBfC5WI/FpGV3Mn28BXgTxqI/ezyhJMPkJtOPoxUSh2IBzV3aMTyFdaVAT6d0r98ye+fGkbgvWzjOZhS/EHNeZR0neVV2kK+JL9SLsCJZlYeLYH6OI/zMmWFTTW6qm95A1qbNmWv74+rae4L53+xquFWO+yMNRNWLiJSfTY44nVvmJuu+kTLGTQap+5Xsewx+TIIMEXfi8bpxjIlRlNsa7RLeEBowLGKgTSkN5NwQc7mYpmeopZpRP3wH3uHJxYpY8Pa9NnkutT+njNgwcamltbh4U5E5wKzJ2+2sIIKewleTietvbSD7KfwXl3Tw2YQS1oG182MGAbmvrBYiWNOqUBCKLmXx1+7qa2ptQUU9SwkE+0B6wh69mpxW5CJbY7ejHuC7mAkY5O0l5Cd4QxNHWpXYubbFJNLuK5VnRmhLOy+x+8gQwipYV3XSUPSZmLn0qutO+xCi3/zmr2xDUTv+MFWYtikEbEmZ+D+JD9H2B480rlIv9/LPmi//+vD7aOdinUassmdosu/Df7ertGNJqBmgO1Q4NCYMWFzRIIBZ3r6J2Lld4bK12z8VA88I4hg+t0iA27nyDY0Wi2iEw3hpjp66SGUcrcddnbT4GrVnwLWIdjNulp5UjYF
 Y9jPgHNK
 lMPY9ZMA1VxCMuWFTTwNBDmeMsZAG4qPaGRCH1N1dosd/2TuPv1Th2T+cTQVuPKNTMt6oBWu/ObGyORoQv4X50HT1esjzbO4dwvnSd2M/RjSkkZGlpuVXJiYDbaC5ExWcNc2MK+08VeE3HwwsdgdnOigU5ABNR9XgH8jVSuwuQG9kIAbXR353ZAxNrE+iponDgL7nRuu3+7u9iLTywMVruw1rmgxTK16GC8CIv+7Q1See60Wu92hUpSRriWqKvxqaJmeJXUXtAGdco2Ee1OlI3RzIgDQHRiPFYsAIfNtRizf3AUvankNFcUxaKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Jun 12, 2026 at 10:26:46AM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask
> and passes it down to the backing percpu allocator. However, when the
> percpu vmalloc allocator has to create a new chunk, pcpu_create_chunk()
> calls pcpu_get_vm_areas() to allocate the corresponding vmalloc areas.
> 
> pcpu_get_vm_areas() currently performs its internal allocations with
> GFP_KERNEL, including vmap area metadata, vm_struct metadata and KASAN
> vmalloc shadow population. This means that a caller which deliberately
> uses GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while creating
> the vmalloc areas for a new percpu chunk.
> 
> One possible case is blk-cgroup after commit 5d726c4dbeed
> ("blk-cgroup: fix possible deadlock while configuring policy").
> blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
> q->blkcg_mutex, and blkg_alloc() was changed to GFP_NOIO for that reason:
> 
>   CPU0: blkg_conf_prep()
>     mutex_lock(q->blkcg_mutex)
>     blkg_alloc(..., GFP_NOIO)
>       alloc_percpu_gfp(..., GFP_NOIO)
>         pcpu_alloc_noprof(..., GFP_NOIO)
> 	  pcpu_create_chunk(GFP_NOIO)
> 	    pcpu_get_vm_areas()
>               -> if percpu chunks are exhausted, chunk create may do
>                  internal GFP_KERNEL allocations
>               -> direct reclaim / writeback can issue IO to this queue
>               -> IO waits because the queue is frozen
> 
>   CPU1: blkcg_deactivate_policy()
>     blk_mq_freeze_queue(q)
>     mutex_lock(q->blkcg_mutex)
>       -> waits for CPU0
>     ... unfreeze only happens after q->blkcg_mutex is acquired/released
> 
> So the concern is that the caller deliberately uses GFP_NOIO because it
> may hold a lock which can be acquired after queue freeze, but the percpu
> slow path can temporarily lose that allocation context.
> 
> Pass the caller supplied GFP mask from pcpu_create_chunk() to
> pcpu_get_vm_areas(), and use it for the internal vmalloc metadata and
> KASAN shadow allocations.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
 
Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis

