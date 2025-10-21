Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54845CCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 22:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03C78E000F; Tue, 21 Oct 2025 18:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB5C8E0002; Tue, 21 Oct 2025 18:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F18A8E000F; Tue, 21 Oct 2025 18:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1208E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:43:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 365E3C0552
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:43:10 +0000 (UTC)
X-FDA: 84023598540.21.A06CED2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A2E09180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:43:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DKEiOlVc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761086587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1ufi8hzAWdR5ZvtubHPkIBiveTzx8KWYjOx6TAX45A=;
	b=GK7PYOm//agNfEgrMt4aDSUxmLxRoPw2p6MRiAUNBPeGL1PRqnHl1sC+8kf77/e0UJ9XU0
	+u43uhf2FMg7M+IMDMipCHPdMklnx/PKvCZT5LkXe6r1rHt25mH7v7MyGVEMQvUAKp4NK8
	BrYN5gVyGgk7G1kYgqgcQuhyUe+5fNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761086587; a=rsa-sha256;
	cv=none;
	b=cXSXJQt7BQC2ZOSDQWYY8vvcqrDd6Sqz49GlPFHL+6d3Cro5ML8h+iY4zJsn3xptBkh7GQ
	QmZqe/6Ro3QmoqlQLLumgzWXKJ5wlSmr51uDZK4yVdhYiTrwc3G+In37AOAB8txEFnjCtJ
	CmexjeDWfhS/8c0jPgPTpUQCBrk9xoc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DKEiOlVc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761086587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J1ufi8hzAWdR5ZvtubHPkIBiveTzx8KWYjOx6TAX45A=;
	b=DKEiOlVc1L9iYUu4dx6LNuIQjc3KlCr1jeKhOO1wyccVH9QXieVfwD51HScDdb7SrV4LLx
	IxdgDJZ4jy4WgN+IZ9+hDOqlP+xgFhMyM6pXahotAy/v6jyMcIdqAnvz5Nbuw1ma90ksqD
	G1w5+y0NEde18zrzsOg0YjOhahdLcCU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-AmE_y9P1N_GNtwgSeJIa1A-1; Tue, 21 Oct 2025 18:43:05 -0400
X-MC-Unique: AmE_y9P1N_GNtwgSeJIa1A-1
X-Mimecast-MFC-AGG-ID: AmE_y9P1N_GNtwgSeJIa1A_1761086585
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-88f81cf8244so3566611585a.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761086585; x=1761691385;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J1ufi8hzAWdR5ZvtubHPkIBiveTzx8KWYjOx6TAX45A=;
        b=sFjpT52Zmy0FISaJ/B+n7fV4iwgApjFMuhPb2gUWMvYN4D9Lccwrcqb3QsPi2x5xBm
         r0eJybQ79XAtUYzNcIIjU1D/EFcXgkVSaT23+mx+Qjm1R4O/O3NgYLGlsKN0Ub/g5e2t
         p8W+NQrRkW1783fT35o2vXLIJMkJTrcLeoLVVOxRarXgFWFxaZ17JcgeC3ajKhQ5zP6A
         Na1PJnL1YjHu33otHvadrU1XsfFzA7o4B9CjxahRVjD+0JhBwBW4q3dKBDydijazqz7X
         N2e9nvEarB820vXdsl00XqftwfrayRbN9tAo2YqOZdwfQSmVn1pMcISqZuRoP5cZCBfw
         0w3A==
X-Forwarded-Encrypted: i=1; AJvYcCVuEs08YBUno3+HHYooGfR/8sNZs81D2BA63s7vae1T9a4NpAxnYyM1q9JanR/IMLm1r5yXNWGhuQ==@kvack.org
X-Gm-Message-State: AOJu0Ywh7k7nmX35YDPCFU3pPcrhccG8qSoSaaT60bDf9UDsus1Xk/Xw
	dt7K7s07p3ww4yQZHBY3zbBioXX7UozFtqNJb9+aq+gWhoxDmrztrcwt6ZBOtQWqbepS2KEPEad
	mkmEX9RCQWmwtalmJlrmU8erd/K2ii3z2f9aNrEuweoVSR2fwOfif
X-Gm-Gg: ASbGnctBb5tL+BX8GRd3jBkfLlcYDg9Tm847PtDeV1brVpcTucmQz8vhe1qNEYjXnrX
	eY70DFXTMXbyCNEtAAJngYtw03hCpkbiva4tpYX+dmBH0NZJ8vD/gX9z4fblRtfYIrEFucXFfw7
	a1OW1zqKL3E5bZ8EHngPFxt+g2XobLgucxQiT7/Pqg9LN8odCKNoZ+LTBRYfMn3XFTHerGMS5v/
	LjA0btUhFfAcZwZe8MXQeKePkWXja1YfynDG8mThao6c7P9g83hswPPRMsUIYkMgCW1FDru2qER
	nhiraLVi/wNuhdPM2rJU6xzwED+GVThpgZj0ajEEFyINSb0VbV4ADYCpaEuQeQO1ca1ETgiu4PD
	YZ4el342Gjtrn3rdDvaGcXsKCHTmxlH7lZj89IZx3qNZOtQ==
X-Received: by 2002:a05:620a:2892:b0:886:ea5d:9273 with SMTP id af79cd13be357-8906e6ba4b1mr2387618385a.28.1761086585036;
        Tue, 21 Oct 2025 15:43:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKKo/21Swm4z17XlE0/ydMbQxCAbbChu7Z8fNIxB6CZQJ6hcePBsIiw2WUviotKsZ3CeiiMA==
X-Received: by 2002:a05:620a:2892:b0:886:ea5d:9273 with SMTP id af79cd13be357-8906e6ba4b1mr2387614585a.28.1761086584536;
        Tue, 21 Oct 2025 15:43:04 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cefba728sm848019085a.38.2025.10.21.15.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 15:43:03 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <ba437129-062a-4a2f-a753-64945e9a13ff@redhat.com>
Date: Tue, 21 Oct 2025 18:42:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/33] kthread: Include unbound kthreads in the managed
 affinity list
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-23-frederic@kernel.org>
In-Reply-To: <20251013203146.10162-23-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YuVY5Ca8M6zqbBy6FHGNajaz-tcXKxt75hEtR1v91KE_1761086585
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 1z1soe38bzwxfecsfjtujm5gms9ankua
X-Rspam-User: 
X-Rspamd-Queue-Id: A2E09180006
X-HE-Tag: 1761086587-736393
X-HE-Meta: U2FsdGVkX1/8dD9jsuanUoEpB0D13ylXssFcOnYbBSi4g7SmdTJsuOKrPLi3QJshJHgJZO4V6eAlise/4YGjTOEeHZgMjMFveQsBcF64C26RSqo3dPFF8nYQ9qCalqS1XDfZLjtkUd7WHMT39eloIpsb6k9SfnSvGm0M4BHD6HVzL9cVABLJ0QHzvF0r2750zxiVZApMgg958BogGK4HKLUPO6B6lghym2tPHRgzBXmVea/cciRAtycrJ3iDJ5dIq/nEwoF+6tmL5v/aQUrrNUsX2iy/mTee7YlUY8BLEKgadlIbjgU4v2MDd7aQAkNsdwEgrlE24tSgFwse9/4TqpSlTzx7YCiXncWpRXS9iqZSmrwH6pVwkyQo6KWOCJJ9am2U2wSUdwkVqL2/CbJcEIPRaa9ujp7C5CW1NNYgaX4dAz9gEjHdwos0HguP55bS6hTUFNOtE/BmIxQax1yDI32ZblAr0xl2o9jiBflERPhip0W3LNEjnDXlwRx+YDGwOt7lAwchWvg4Xa76lV+b7KqhFebLUoISC1AjJM/3nOmGqy+FXcGoAXTqyen/Y1TQAF+Il6wxkhaxgKiV2FyI3JvI+Wd21XAvtgWopNwt9PNW/TKXHWaZ9kxoLtOxk8FT5hIa/kPY5DAtA5f0/Q3IvcE1AH8vQMian2/c0z3CmTcsWa/S79R8tUgG48weB2Sc9nem/TTr1CWVrN1e0hlceMvgUygs46kVKYfpdwcSKRSXjDD/7bvt7FTH/BkEIyFDBnOSyXzC72eGDDOcOUvOlS+hpPMlFwLp6y4qoeFVc6Nis4cdYCl7aEqWsMsaYg1Lgy4jBE6wvysRcFLOYjp78jj/95tXWrraQmReXL4FcEqJwu8qTp4PkQX6JxLnvq7ds6Z0TH2plLvmm9fscToY5Z1n2kqGhdPpmiYBGTKdWbsoHb9kjHESagfXdjB/4WMI0c+o7SgwgkWuS9szfkF
 906RFair
 YKz8EVzU3WnR8zIBPEn2N0Scce9x9l9TfrAvJ7AYpLzdUCmFo0LsGPxbeBUWBK5QYcUWlHaZUqt1M/I+CWBwWCkdUkMBbGtBGJ9DJh5Ti4KHoyh2v+zdeOumoih2kfx0oaUNoRiHojJutRIDcLvFzVFxaIvUc/Hc/1UEVR5Yb2/Dyhi6WlMtUiKYlAETw/xMk5+UdgRyEWFYM+sTtw35NZxL9x8w/4Zik26FDJGfqKVWmMuN9sXnezRhy8FWlN59rxahxAiM89K+fc76VpLDpcOGUXUflTB2p8AbSNbSNN6aSDwmmPmKH9rX0Ny5j9IRVUE3BvjeG1IU/tApswYdJ76LctiewTTUaLibnPxganVw7U64D3KlQbPGi3IKRSyJwjTu/OUEguC9ReLCqAP8w+sHIIgALZ1VSaF350XPYfrcyi3rLTl0qPOQEwUmlZtVfkPw2bNeQvKKY5GVoDw8rQ6uizJ0J8nqC4mvGmM3W1SI6okZKFzy08XBqVSvDw1w7nIG4VrSJwBjyyTsAN7r+Uto8hwA1ZcTlUe21YaNk0dwCJFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> The managed affinity list currently contains only unbound kthreads that
> have affinity preferences. Unbound kthreads globally affine by default
> are outside of the list because their affinity is automatically managed
> by the scheduler (through the fallback housekeeping mask) and by cpuset.
>
> However in order to preserve the preferred affinity of kthreads, cpuset
> will delegate the isolated partition update propagation to the
> housekeeping and kthread code.
>
> Prepare for that with including all unbound kthreads in the managed
> affinity list.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   kernel/kthread.c | 59 ++++++++++++++++++++++++------------------------
>   1 file changed, 30 insertions(+), 29 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index c4dd967e9e9c..cba3d297f267 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -365,9 +365,10 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
>   	if (kthread->preferred_affinity) {
>   		pref = kthread->preferred_affinity;
>   	} else {
> -		if (WARN_ON_ONCE(kthread->node == NUMA_NO_NODE))
> -			return;
> -		pref = cpumask_of_node(kthread->node);
> +		if (kthread->node == NUMA_NO_NODE)
> +			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
> +		else
> +			pref = cpumask_of_node(kthread->node);
>   	}
>   
>   	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
> @@ -380,32 +381,29 @@ static void kthread_affine_node(void)
>   	struct kthread *kthread = to_kthread(current);
>   	cpumask_var_t affinity;
>   
> -	WARN_ON_ONCE(kthread_is_per_cpu(current));
> +	if (WARN_ON_ONCE(kthread_is_per_cpu(current)))
> +		return;
>   
> -	if (kthread->node == NUMA_NO_NODE) {
> -		housekeeping_affine(current, HK_TYPE_KTHREAD);
> -	} else {
> -		if (!zalloc_cpumask_var(&affinity, GFP_KERNEL)) {
> -			WARN_ON_ONCE(1);
> -			return;
> -		}
> -
> -		mutex_lock(&kthread_affinity_lock);
> -		WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
> -		list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
> -		/*
> -		 * The node cpumask is racy when read from kthread() but:
> -		 * - a racing CPU going down will either fail on the subsequent
> -		 *   call to set_cpus_allowed_ptr() or be migrated to housekeepers
> -		 *   afterwards by the scheduler.
> -		 * - a racing CPU going up will be handled by kthreads_online_cpu()
> -		 */
> -		kthread_fetch_affinity(kthread, affinity);
> -		set_cpus_allowed_ptr(current, affinity);
> -		mutex_unlock(&kthread_affinity_lock);
> -
> -		free_cpumask_var(affinity);
> +	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL)) {
> +		WARN_ON_ONCE(1);
> +		return;
>   	}
> +
> +	mutex_lock(&kthread_affinity_lock);
> +	WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
> +	list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
> +	/*
> +	 * The node cpumask is racy when read from kthread() but:
> +	 * - a racing CPU going down will either fail on the subsequent
> +	 *   call to set_cpus_allowed_ptr() or be migrated to housekeepers
> +	 *   afterwards by the scheduler.
> +	 * - a racing CPU going up will be handled by kthreads_online_cpu()
> +	 */
> +	kthread_fetch_affinity(kthread, affinity);
> +	set_cpus_allowed_ptr(current, affinity);
> +	mutex_unlock(&kthread_affinity_lock);
> +
> +	free_cpumask_var(affinity);
>   }
>   
>   static int kthread(void *_create)
> @@ -924,8 +922,11 @@ static int kthreads_online_cpu(unsigned int cpu)
>   			ret = -EINVAL;
>   			continue;
>   		}
> -		kthread_fetch_affinity(k, affinity);
> -		set_cpus_allowed_ptr(k->task, affinity);
> +
> +		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
> +			kthread_fetch_affinity(k, affinity);
> +			set_cpus_allowed_ptr(k->task, affinity);
> +		}
>   	}

My understanding of kthreads_online_cpu() is that hotplug won't affect 
the affinity returned from kthread_fetch_affinity(). However, 
set_cpus_allowed_ptr() will mask out all the offline CPUs. So if the 
given "cpu" to be brought online is in the returned affinity, we should 
call set_cpus_allowed_ptr() to add this cpu into its affinity mask 
though the current code will call it even it is not strictly necessary. 
This change will not do this update to NUMA_NO_NODE kthread with no 
preferred_affinity, is this a problem?

Cheers,
Longman


