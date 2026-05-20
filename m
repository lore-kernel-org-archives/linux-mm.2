Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48303CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC4E6B0005; Wed, 20 May 2026 04:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD656B009F; Wed, 20 May 2026 04:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C6A6B00A1; Wed, 20 May 2026 04:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87BB66B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:19:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33D811201D7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:43 +0000 (UTC)
X-FDA: 84787099446.19.1D952F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7022B180007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0LcOem7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265181; a=rsa-sha256;
	cv=none;
	b=Y8mmJ7QgAc6BlLJjdkAN3OJK5g0ShlSnre205coVDNIZlOIw4OHLqB7nR6FtIfu2Em/7dq
	Sd3hIXPEKJU0IMbtJmaPMQIA0Z+N0pBH+C55NHaACaOl3loT+IyF+SrGMbG3oSBafWOoiI
	5ntCN5xk3h0u0KyE9V1+djDjzl6fCcs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0LcOem7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xt7NdPGSKY6kkU775v+b8eu3ytjDkVjAd/pHlIbUHDs=;
	b=VIGfvUMECoGACz5SkNX3mCsFDWvpAk+e3ueHp7dI0md//2LqFnO5VhJjgGhAPPCYA+Ufuo
	al2rS99KyBwRsDeTcu6NiisGfKNKz+0R/qq6VSUg3d+zAcGydophKgNyRgVHE/xhp93qKq
	3WSm9a6mBNw7rTQNJNYDekxEAx6xrdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EBDE600CB;
	Wed, 20 May 2026 08:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EF01F000E9;
	Wed, 20 May 2026 08:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265180;
	bh=xt7NdPGSKY6kkU775v+b8eu3ytjDkVjAd/pHlIbUHDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J0LcOem7efWqG1g4tT0cANXGG1UZIjWUf1bD+2ORwRNHysCAmNEsPJzPl3dlyfvVj
	 ST8OUnal7UjU8b3pWaWPAR4eM7NZsoPHDOGK7Q9+LUtphjECniEqdsfYoFCfWoL004
	 8UJQd7bmDGioUkLECcXqEm8Qbp6zY7pEKWLlvtUWygd3sPaOtzOwDB+QcfsDacidrz
	 P7jkFbpmYf+PakzAOk4f6+SdpbiI6Ejfgdota9UkZKTr2D+uI3DBtCvcB/KOA964dy
	 EPQ3OVrhoYPrT5356cixl/8EY/O0yVxJ+r8+u/wepG0G8dE5w552omcMxOEcYGTZOs
	 +exV+0EL8GmIg==
Message-ID: <55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org>
Date: Wed, 20 May 2026 10:19:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma_debug: fix invalid accesses for inactive CMA areas
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>,
 Stefan Strogin <stefan.strogin@gmail.com>,
 Dmitry Safonov <0x7f454c46@gmail.com>, Michal Nazarewicz
 <mina86@mina86.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 muchun.song@linux.dev
References: <20260520061025.3971821-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260520061025.3971821-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mj4m8ad9yxzrhhnbom3gae6mmkez64hi
X-Rspam-User: 
X-Rspamd-Queue-Id: 7022B180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779265181-96204
X-HE-Meta: U2FsdGVkX1/i6f7WyBFtoSJmZkgGndr0vzEz5W/S9yWtaNLQnxp7Xds5k6DwmHMkoMdeplnRORzbBW6CrRxgxI+6QYyoPF5LOPDa423ImsSr1TmBBHiY2HT9YqtO9044OTATB3AKE0pF50Ar5EzFfTrCbHXRC4i2A7lqHLOm0H/J6lwzdLOScfTc5sz9REr7CPw1X/LCfGVqtwpfjaL+2i4xrc6QOUQQFILRsc8EKosGUncKhe7IH0KMwR+ycP+0HPkKHwym576GWfwmSqJNUNFsjBsRuiz+HZuaDlvJxTTspDH19I/tRdWp0Yp+6qZKyqki+xsoHLgIkkMNiu2CwXxxjimZpSzw7ULj0CSz/Be7T9eJ28r/rkfZ/IJmtvGmATAzS3QR8YKwi+GQ+9Nvk6RffWAVNIYiC9kiuj1mzc5eHzyxdaVO9xyAtYIEWQ+AbQ9RytYKWiR9H63pJ9EwQhOkUXFBUq0gfLEfeR3CAqntay4998dmClkUegZKMoz10cQWrqD0XHDfx81QWEODNtIkYFnhIB8IYA4xEFfeJTbDF0nWtGIuUTuLhJgEtRuAS8jWtXqQjHFmgiYZ7znQFjyyo97ETCE6yR8ezwrfYxrPdvVLQIhMseCnZAcjsaRpHwof6NerL6usXqLnkBsQ83RpeJ9NReFDaguuMADSOFUaDax96O5baUY/jJIouOo2kv6S9uMiJfc3qwvWkkWRH0a4TvZwnBCWK6s8RnMV3pxPJ5x/+zAKmhvf/pxRLAVD8ITVMX5DkOJ7Ffbi9iz3YIcXxRnEE4N4AIckGIBIiaW1O36PavR7xbaTwF6MXA661vXeZ7RUj6cLFlrGC01U2labR+aTIQl/BSkIhCOLal3ip/1hfFe3iBAg1ZVPn95bQsdmH5Vv9MQo4QN5hcxksPC5sXwrDKt/54AMOBmsUUZKUCVOhzjdk2PRjKCr0nS82rHdnTQEDUTPjY1mXdA
 mSwvMPOZ
 1Mc5vt93WD0/Y5S8HQzFzZvHlfLa7/YWb9+qCk9kSznkDWYLh23CuQZ1cTL/m1PP3QfikqAfihr3nMIVN0Yk4Yq8zrWl0pg94Wqu2NuLQooVUkaqJeKJCFbRNHYMuk+y4LjGlcem2lRPzOKSfno0WYSObw/rfIhY1RmLst6gUyQOW+ynT5DMz9IHS695zaFoeyY4JGn7FjHPD/LAKTIyfwOvWSiO3yLrMg3R4NKQc7nUSQPw3sOtxmESeecCzD/6E4Ogmnd2b6HVk57GPV6Xo8cMhGtpzX/+OV8smqiIckCyfIfuUc4jqCZZuRcNAjE/TT9yYJCOcbpRROr9SyQznhOcQ6Yt16h013OjlvjVMwbQdW/9Be7g2PXBbMLSOyS/JoKUzJYkGWOEfdS1LZdh4nOKbSio6a3QVrHVci1PxxDmX3p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 08:10, Muchun Song wrote:
> cma_activate_area() can fail after allocating range bitmaps. Its cleanup
> path frees those bitmaps, but only clears cma->count and
> cma->available_count. It leaves cma->nranges and each range's count in
> place, so cma_debugfs_init() can still register debugfs files for an area
> that never activated successfully.
> 
> That exposes two problems. Reading the bitmap file can make debugfs walk a
> freed range bitmap and trigger an invalid memory access. Reading maxchunk
> can also take cma->lock even though that lock is initialized only on the
> successful activation path.
> 
> Fix this by creating debugfs entries only for CMA areas that reached
> CMA_ACTIVATED.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Fixes: 2e32b947606d ("mm: cma: add functions to get region pages counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

cma_sysfs_init() also traverses all cma_area_count. Does it make sense to expose
them there?

-- 
Cheers,

David

