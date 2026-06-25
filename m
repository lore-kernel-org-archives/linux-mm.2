Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D77FCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602F66B00EE; Thu, 25 Jun 2026 03:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA6E6B00F0; Thu, 25 Jun 2026 03:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2AE6B00F1; Thu, 25 Jun 2026 03:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24F3E6B00EE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:40:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3E761A04FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:40:13 +0000 (UTC)
X-FDA: 84917636706.19.B690A9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C2EFD8000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:40:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNY0gmJI;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373211;
	b=inMiqsPUTzX0/CLkNX+D4XunOAp4yvslrUycTQvtXlKQFI82KxqlGJXsphphMu+OXou1sm
	V3uFtVkjnOkPvsb5r8e8GJr1NS36YycwEquuMGHy9wtIziRgd6c07TTXZlyLD6O8ymdoAY
	yPuXbxAuF1wMZA3bWb4CEgAAIaXCKjs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0yxXYlC+6ZzOInCXh8esiMObDCmFa28JgIqXqu60pE=;
	b=5iBzgd5e939lpcAiDRWTTvBDUKRz0cOTO7A9rMxUwJMfYVTszyRWhcehstuS00ism3r5wx
	lSLjiXBZbbdAuFzc9nhSZR9FWUtYq1PZ7AUZmbygvlHtCQgucPys6KYsOB+qyJyUCJIzdR
	4sA10G/N/pPRPSfLUE2Y+/tn2AWRAYg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNY0gmJI;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15C8F419BC;
	Thu, 25 Jun 2026 07:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E00A1F00A3A;
	Thu, 25 Jun 2026 07:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373211;
	bh=D0yxXYlC+6ZzOInCXh8esiMObDCmFa28JgIqXqu60pE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNY0gmJIRd8aAsNgBLSo9uATdut1LoqElrTqsbgNwRX34c4pz0dA2LXltTCm5J2jd
	 GCKHbC/0HGMiLrrlgZ7sJgoYk/hvOlx2FQsSzSGbHdvEvi2Y6fHGEOv+6errkLxuyN
	 FEG4hWpDHHl+2/TbXpxcGR+W7rPBRxmUm7UluzvbnL7Pv9Fc+0i8btgnVJEZnCPSTT
	 oXx/29zepKkQnx7lLBxYJuk4hVstAm3j549aahwWIoI7j+zXF7pE6/py3rP9S4IaX/
	 hYNwq2jhob3kh6PbUWCnnIc6d0oNUzlfu7kXxyZ4x5BAf9EGrZ6nJLQ+SU/c15xN9o
	 IVgh763KB88WQ==
Message-ID: <1d8f74a7-502b-43cb-a0f0-1923049aa213@kernel.org>
Date: Thu, 25 Jun 2026 09:40:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260624145744.3532049-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3c6i8drpn1k8g7xhw377hrxn95php8kf
X-Rspamd-Queue-Id: C2EFD8000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782373211-643280
X-HE-Meta: U2FsdGVkX191tnz0PsDqeOIfLeVbx27SdRxGEy6YvQboB0YkAAPD/BGSI5fXlROecYJqOgPM/y/KFU0+Uoc1uJizlDuz9qpSe3N8N8G/lb33+DV3c9G8hI54mXGyn9IwuU70uxhGTeM99h04KYDtkWuF/TpI0cYCZPNSeLy77RE/OlPFQpXcsdwk8FItB5JpLGWSVT0TRkgtNQhTKOkHLPIGyIpP9I8DNAlFEpPBG3BYJpJYjgYYJMGm+OlSAF6F9cq4PWMBuiWy/ydD74fv8rLA0cv/h4yvNMLe5A4j7F30DRsvseWtpjsrh9tLQbaFCPrYgl45ip9jzcJcdtEzDMADur2WAFB3qH65IyLXRgw19jVYqWYP6CUGGjiHveJKVyNTfPdh25xqsxZJp2eRyuONt0UdDhvmdP91kRid0oK5qkr5+SSw+/PjuO+8NdrqlTQsUN2cCRTxxzl+K4anILClQ2WqZBhDUyPzmgENlUzTKptC6jrdXuldJ0e0jCfKcHQCGOsz4rXmrOo6ctCJaBS31ZbtnGEn7CvfSpkBMSk0W8s2PtVWBqlgMmJl3ObMc0NWliEE+yim9nGEzGuH1aTqW1RSXFqCGl3Rgi8W2QVWU9eV1gO6E2HKgMQcD9XEkk/yQCxiv3yrRe1y7QvVTwLqNrNl53r0QbTAQ5hwT1COrwNV+XDoHsteUY/qSduIv2XJl231GNZIXM5/t2KcjFjYEcDnbnMitl4KlUBUxYdjCRYeGu41CLfUadp5+wEyFeckNlVKHLPLzSHymq2Ne8TbVYGMbtfTLF9E8NkxLXvD+HrYh8Uq0cv9fi95KvM7iZ/PLnTqz5epLZWvbAjt6KCj9POOep1LjWmBrL2F1Xzd9RBO/0k6vTg7JcQpFEdLT1hP0YIKyNGWhBiHc2Bvv8JdHKKzBzukYgEKoByT0jf4OADtc3/n1CLIgEhN8tgKUNwDpXgcLwN6bj1MRKR
 51h3cCFU
 +ATjI8Zvkj5tMkQrVoEIWA2mQzcfVqAfEfmkBrODL+9NPZR8Zrp3jhLLTfHbE3sNNLZxx4f4YLMNVZZhPg23iXTI+FfLWTaLsbcQkaFI1cNQvK1ON9dYLQR/Wd+wHQ5ao6wFNozy9i6PypALrmoU0/AaKozUBqC9hgxn/KuQnfps32u5WC9eM5nXrnp5Nx5HjpbuS8/zqKmshq84hxxnowDTiN0PZDgiI/3p5yfGeI/Icx0yS170ogRYtGUzrIc2B3PrZyVhlwODtFhPzVzk67L18ZoW7+yD4M9Na0S54aQylRk9/VqQp8Gc17RXdDn4EgSO65OQjuK1m0Sz1inq9o979Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 16:57, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:
>     1. offline all
>     2. remove all).
> 
> This creates a race condition where another entity operates directly
> on the memory blocks and can cause hot-unplug to fail / unbind to
> deadlock.
> 
> Add a new 'state' sysfs attribute that enables an atomic whole-device
> hotplug operation across its entire memory region.
> 
> daxX.Y/state mirrors the per-block memoryX/state ABI:
>   - [offline, online, online_kernel, online_movable]
>   - "unplugged" - is added specifically for dax0.0/state
> 
> The valid writable states include:
>   - "unplugged":      memory blocks are not present
>   - "online":         memory is online, zone chosen by the kernel
>   - "online_kernel":  memory is online in ZONE_NORMAL
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>   - unplugged                -> online[_kernel|_movable]
>   - online[_kernel|_movable] -> unplugged
>   - offline                  -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe - existing tools expect them to be present after kmem binds.
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy.  Onlining
> such a device through this attribute requires unplugging it first in
> an effort to get drivers creating DAX devices to set a default.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation.
> Either the operation succeeds or is entirely rolled back.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.
> 
>   An offline dax device memory is removed on unbind as before.
> 
>   If online at unbind, the resources are leaked (as before), but now
>   we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  Documentation/ABI/testing/sysfs-bus-dax |  26 +++
>  drivers/base/memory.c                   |   9 +

Can we have this ...

>  drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
>  include/linux/memory_hotplug.h          |   1 +
> 

... and this as a separate patch, please?

Nothing else jumped at me.

-- 
Cheers,

David

