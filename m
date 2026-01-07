Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70330CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACEA6B0095; Wed,  7 Jan 2026 00:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84716B0096; Wed,  7 Jan 2026 00:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB616B0098; Wed,  7 Jan 2026 00:48:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B6C6C6B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:48:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 653C31A0172
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:48:26 +0000 (UTC)
X-FDA: 84304087812.07.EFB9E31
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf04.hostedemail.com (Postfix) with ESMTP id E1FAD40003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:48:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZPu7NGZp;
	spf=pass (imf04.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767764904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ju+I0/IUyuVT+H2udacEfg///bkBZHn6ZGWaqIppm1Q=;
	b=A+Sy1Zk8uBywxbfPYnKhCwE8iQWUShcF1zDBxA1WoMP/5WrXcaTaLMshI3vMfCueckJfcS
	whvqbOkvrkUXLwBzobqfqQE2krR059KjL9L+DyL//FcHNQECqfgdRneJVkeE5cysKpvJLH
	YE+l3sNP7bJmCY9cP+LH4XzQmru23Dc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZPu7NGZp;
	spf=pass (imf04.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767764904; a=rsa-sha256;
	cv=none;
	b=bwdKVhZeNjsJaymOfRbGhFQMpizM+eVXUbTadd90zAt9JKLGK4omEIDPDy+NFnvlIoUXlR
	W3cCe8aZeB3hh5jm0453FmQln3jAzjxHfd2Okg+OHGtfzZIo6Mr+VVK69MnFQdlOFRoDxY
	rZyhlCDeNqCfSWKKui+IW0OzEafgifU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767764904; x=1799300904;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0+FZ1WtgSm/nAQySSzMyq7NKTbNcf9U1vfmunxR5udI=;
  b=ZPu7NGZpxRx4Qvvb8rPvWXGZyiGWVfAtXVXNHoHusIOjp4Si8/e8l1ba
   GbSudx6pyFndubHojVlj39GBftN9G4X/K6DPR/nTANl/pwzm7B7LxtI2C
   jY/qGeBgB0K6ncapfsUmvgAi3iWtrZbyZZfyFxBDxx7Oxx25VEK1LJGvw
   o0yFk6JpiAVjTMVPu3xkOXO1e16LZcvxjRifLB3zJgUeYxr177bXLIhw2
   tlfD/Ojv3my/xw6MIcGBCQZktbiltEsSQpshgYjpvXNCa4ubZX7R7AMMQ
   +yrY+49MelCDimDhc1adREYIQTCZprN+oDRQuUmcmg5H5X8JN/Cph6oDF
   Q==;
X-CSE-ConnectionGUID: 1MD/tBEYSYmsVZ6El4ZlIw==
X-CSE-MsgGUID: TlKKXEevSs22RFymckt8vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="91787706"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="91787706"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 21:48:23 -0800
X-CSE-ConnectionGUID: FcRaYlxlSW+Fp91un03Hpw==
X-CSE-MsgGUID: JDHktlI+Rq+auVfXD+19TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="233978337"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 21:48:18 -0800
Message-ID: <390a15a8-e530-46ee-a42c-cbb3170692df@linux.intel.com>
Date: Wed, 7 Jan 2026 13:48:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-3-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20260106162200.2223655-3-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1FAD40003
X-Stat-Signature: jxdm8yxs5og1f3bxsb7nd1knz5ceoi97
X-HE-Tag: 1767764903-231989
X-HE-Meta: U2FsdGVkX1+6KtN4MMtKM7BLzdWCdwVkpea994LEhU0m5H/9zTs13f6yTkk1H3nTpBCHORYLc/oEAobPzfGIQHvvn/W94WPb9zSajjGrWai97rtFIr51ToockVAqFrGwx/R1iy8xzwUKpiY4KrZxePi+km5VX4oC8LxJWJHhplEu0iMBO5Lm6EFva5GgWDwn4s1VscKLYOlpZ44PCF9VFV/nRrzBTJAQXfo9fL3hm1Z09pB5CHgulNIsxFHfnB30b9xIuQXALLMBzXwRglAlfzF67ulYTONbItN9gf77M2qT+Nz6ffzvJ67Mj1JkVmASJcYa/T9Zp30KZpACUhMG3KOjWxKu97FiU50JDVfFFt2mhgeziy4mEVpTx9SHPcI0MWhSDc11JgI91wSTEw3NUvxqweOEl9YciPYpPQ5dk0bWKrGzKaoDHsrEGRagDycAKdaMGYRhOW7mPiJKNVPA8Y8YM7vjc42e6DeqdYcK4A05GY0q8Dri4lcxdbyGV4i0vVFj/s497VfkKs0xo+7AuGMHAJRxPFZTRAEpVhgkIk+qaTBR3jVDb9T2Ierey7vMqNqVppFrw1AOMwyPexmaWaaShon2JSqfeCUo1ZiRN0Vh6mk9wpGOw/iK1/oMAIhGnaNde2hxPVBgPoimk+S+2aKXVdlZrOxuVabq7MrWn6nNxbQTmCaWVMzgY/idxLkgqE1dxIpyUxgZyjkOtBmuejxpO+GAFN4DmHr0o9sa707M4nEz/antF80gkP16qNZSFivzKi2sihHDtDVKyb/2zeQQlw9qDDophs2gb0Nd5utZPZ2ZI3X8TufRdI11aYlQcf4c7a+yWHJsMqHCH+QGYJ1B0c28zHz4V7tOgY54z6UsNejfJIv3IhP9DCt39QPmZomlUGnz00h6B+uD6em1cJoM2wRslgj1VIImsXELJNdPxW//oS6Hp9u2A58f6pl72mnWgiXKkkJ6C+eacfB
 ZwUJdbeW
 3Sj2u9zYjc6feSOmyIztHigyWuBl1AbNqblTnkRuxQS+xc9oH0uooDrwjADpTEWjcMMrhNzDctwJxz6CDv82qlyiRdR8b3QI4DDgqEUVE9o5CocfFlYp7SIzZFkGaKOm+zRTq+ykWR3xy37vZclkOe21aDAtuxalEyFoHus3bERZSiMUi+Q7WcSbcrfhT9D4xycWmPiQx0DBllrJ6ITOuwwMEKUFbKlzwHWeKSnqMsyvdgWyLqno83HRoaI4nkDyZi9bFU3WBGIwCweaoduIZl7Jpo6JIQG0YJJPJ1yfASd7NudA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 00:21, Mostafa Saleh wrote:
> Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> - iommu_debug_init: Enable the debug mode if configured by the user.
> - iommu_debug_map: Track iommu pages mapped, using physical address.
> - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
>    IOVA and size.
> - iommu_debug_unmap_end: Track the end of unmap operation, passing the
>    actual unmapped size versus the tracked one at unmap_begin.
> 
> We have to do the unmap_begin/end as once pages are unmapped we lose
> the information of the physical address.
> This is racy, but the API is racy by construction as it uses refcounts
> and doesn't attempt to lock/synchronize with the IOMMU API as that will
> be costly, meaning that possibility of false negative exists.
> 
> Signed-off-by: Mostafa Saleh<smostafa@google.com>
> ---
>   drivers/iommu/iommu-debug-pagealloc.c | 28 +++++++++++++
>   drivers/iommu/iommu-priv.h            | 58 +++++++++++++++++++++++++++
>   drivers/iommu/iommu.c                 | 11 ++++-
>   include/linux/iommu-debug-pagealloc.h |  1 +
>   4 files changed, 96 insertions(+), 2 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

