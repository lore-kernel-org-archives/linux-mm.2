Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3216CE8FDB8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 22:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728476B0005; Fri, 26 Dec 2025 17:11:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D62C6B0089; Fri, 26 Dec 2025 17:11:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7A06B008A; Fri, 26 Dec 2025 17:11:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4417C6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 17:11:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6A448B974
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 22:11:36 +0000 (UTC)
X-FDA: 84263019792.12.B018BC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 430C940006
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 22:11:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M69jO5sI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766787094; a=rsa-sha256;
	cv=none;
	b=YCnZ8rsT082ejeZLZu9emsAz/3SuPQkIU1WSSSCWP8Rh/9ROyjfGoaMT2H2aK1lBZawG5I
	mcL5dCfzutKEz+UrVGZps3Lp8xNkwfIPVsz86oJDoJ675+b1KU8rCs/0mlh5ZRiqjFHNVe
	MBqKanyMElXfubaLniXpUEogCj9JW00=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M69jO5sI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766787094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkFBnQY3LS/CUDnrkcxR3YOk4jUDJ9IE93cEOOeBXqU=;
	b=DMs2BsHh/6daKyMaBbOr5llkJRr1x1I5476xrL0IPXb04KKr4eM9imoBpRB5XiZ+wckwg8
	y3PHG3sd//t5nrUuwskp97ozg+L/0fCiiHrCW3ZgzDymbJTnMWa6pGGGlbz6kiw9tzQwI9
	3mFRg1Y7ePv/oMvAhM+yTiBknkeAklY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766787093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TkFBnQY3LS/CUDnrkcxR3YOk4jUDJ9IE93cEOOeBXqU=;
	b=M69jO5sIpMvwCK3xyZD3QIj27VoCE+s+fTz2CdUiSR9ojA0QRidnKn0E4w32UliDlUJcg2
	yUtBNRnJLaNSLkPva9lCpMgqUxYDdEn0Cvd/AJLSMsV+k0/M69xuhJyHnKch4/iH93rtn0
	SCVw54PexpDtwwkgDxa5wU9gzqKje74=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-_8t-paCSO3u1lOYW9qJtcQ-1; Fri, 26 Dec 2025 17:11:32 -0500
X-MC-Unique: _8t-paCSO3u1lOYW9qJtcQ-1
X-Mimecast-MFC-AGG-ID: _8t-paCSO3u1lOYW9qJtcQ_1766787092
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4f4ab58098eso177252951cf.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 14:11:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766787092; x=1767391892;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkFBnQY3LS/CUDnrkcxR3YOk4jUDJ9IE93cEOOeBXqU=;
        b=hSTguWXL5haHcWPPzoKvB7eV9PkBU4dYUkQkYljLaU8ODIx6wurwB8//YJQXmaIUj6
         5WZDVipPiWEBXDzrRZB4Tv0av4WsWJGvtdLXMcT7bC0bH0T/rULkogja6vv7D+wcp4v+
         XqmAAaCHZbaUWILX3El6Dbi8MA3Ic/Z9LYpcK0d9MU8OMr4CZyb/1vZbh6SNgYd6atvF
         aepccteZbzFIvfVbA9niIe2VlGDVqBhdJjPtfdFCTw9IC3+7ZH22tCWyDkakLmjli00g
         Uq+nErGy3en+TunGzHDCZA7ycAYIryTDuIHefr9Xq8DxNnV7HBTISfnl84Gqi6+Bz+NG
         N99g==
X-Forwarded-Encrypted: i=1; AJvYcCVy36KWQK5TIqdTJbijmeNWamP8GxRaz1cyF7Dl5dItlJa1Jh1nankrv8cccKn690OpB/uu/u3ifQ==@kvack.org
X-Gm-Message-State: AOJu0YxQWM+xT1+vORkHisa78nlqZnwwZSQgAviUAVgGuMIinUPZ1QyK
	b02d8oTTXmIbHdg+OEHsueTp3o2IkefbLh5ghOcgucdIsAw+kUwPpAwyJvc10ciPdvM+M730DDf
	Fx6mVXx6bP8usDZgNNS3TurnCKc4+b3Sr5gcUUyBan5JF8YRYBCR4
X-Gm-Gg: AY/fxX6xah2AC/1gJEs160/N/mxoPybgjUy31RfoS5cpNwlKhbT3gDBqGaNMK4c08HY
	DB+Kc75pQ1FnwlVftl//E3315BgBsqBP13G8xJDejIenrma4q3Qp/tXAl89RLZRe8JGsMRqlOJB
	KArV/uWPTLIs7qefgaZOadyI5YAOhu8PEouqAQau3XB84cSIA39tzWIXRR2jyrW8TYMCs56TAPG
	mX5r2lP0mFijP9D7Qxm9wFPp6rrt6ZFyNgh8X7YQBJGqPzJK5T7EuJ1i/K/IenQuyfm8qnLKwBq
	Se7qzNRIMtT5ernBljOq6q01DaE6/Vt39+hBGrOahR9X4hJyiLTMIR6z57pL6fEoQEyO8F5JXnk
	oPiAm36G+PQEv0Dmgai95GqQMudwM5xSG8pDFHNE1brkeaA4EVgns8gZQ
X-Received: by 2002:a05:622a:4a09:b0:4ee:2510:198a with SMTP id d75a77b69052e-4f4abd75629mr345582211cf.39.1766787091850;
        Fri, 26 Dec 2025 14:11:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfAC0mMAvBMTtIg0HnYR5V/3qz64S5XCvmCWe5yr1a0y1ZiMQUT11GI7YF+lRu7HFhzwx/CQ==
X-Received: by 2002:a05:622a:4a09:b0:4ee:2510:198a with SMTP id d75a77b69052e-4f4abd75629mr345581701cf.39.1766787091473;
        Fri, 26 Dec 2025 14:11:31 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9623fd37sm176347436d6.3.2025.12.26.14.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 14:11:30 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <1e530c72-75d7-4c7e-96e7-329056d6baf5@redhat.com>
Date: Fri, 26 Dec 2025 17:11:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/33] kthread: Include unbound kthreads in the managed
 affinity list
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
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
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-26-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-26-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bOgRXmB0SXTxDBcgfqyrpJ5voITaqZH00rNpWwwYpRw_1766787092
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 430C940006
X-Rspamd-Server: rspam10
X-Stat-Signature: h4gs6ai3t6d9rzzxx58mqq5dperp1e18
X-HE-Tag: 1766787094-532088
X-HE-Meta: U2FsdGVkX1+O+6qbR1VJ7Sg7X44z1RCZ77N6hK/6lPNye0LbHonmGbe9OtqGV7mWhZhP2n1uNnJBiP3SbpI28Gw5QQW1AvgvD7Iq5emJgyaB6iS9jQaxcq/qdtQL9OJHcdzC9w7jC8aQOoMEErTAWQI15VQDP8+Ts3DPFzdZWX8abkM8eb0PQZilUu01TP13EQrol8zckGrMQBBX7UzkC8d61oK7nkWIiVqWcl0TueNgVms4zYeQsCxj5NiePBiqQKXWz7ZGrE0uoKMBcfuCBUmCAmvc6VnoH4OsG6VBI/v/IPySkLl2+2He4EnrTHwjeY7Vt2lmlUgz5/kDEmIyxajbGlcSsOafHbt49Zbo24fqwSo7v86TP5MQi8w2eC27nucpPI7XZpkyPTwmaW5vMklVDMgWv/ZbIlSdkwCkV2GzeWWWrV//9HIsqCzLvwDaw/NSMAYgOZd5fILnfIbOkB0KxvZW0cELu/P2+XtbEcKCxN1Sjtf+S6pb0c5EspNjdDL68KOWFdngZuR7XlnNpqU2Hn/aXpU4z8FBzB2QnvmZHp2/5ydcxG2941ohdxl8yTJEQM2/amrR8Zizh8xSfOE/dFT4Ed/v9lV/l14noTURsy45pIQGq4QRAAraRthqoa2LJCK8kJ20hyTvJqrAGtweLyid83lU1sfNGL7S1ldpBEW73ZfTLLlYTM/nQ5x0jLhHfLMCwWFowpSTTIl3BqFv6fsx/nLorH3BTSgs9zL/1cVRayUgBj+vT+P1z0dZFN65/qObL0IvBkYfMNDP/11j3QGbmu+bU7scaTKa9k+mkTVhw1NWrSVQeBbjs7wus4TMHTB6sIOYZQiUdBx3VCPLFGJEahakztId15b74oYgMyBykkbd8ctxrvbR3/fV4iRn7qovAEmQhgDRfsHJfAXCMbcscSjbzAxKM3sC3i2XOoM6rhIHrospt21tvRZ0AfKLVgSsl6syNJwBOz/
 8aJkQmjB
 5dr3s71Tw5F6BP6qi6R5ad9JbFLfYa8sZtxHmFpq228FvSX4SJ7Y5bo6/sTvBE+xt4rMgYq9JDtdRCSZKInj53KEYZyHXpYuCOc4HmaSquOdZ2I22MrMYgFjUI58NKnbk1AVM3739XW9wbfyybUOMEdmLWYPy3iNLIKuY0nOKL9C7aiIpZr86hcvx4voYMEBteRSl2inSeNrFxlToAwv7Len+QxZv4Y5Y41J/XCmUz5+ATF628+31qGNmqiypDLXdI46zRDx5JFgJgXRdm3NRlUAzX75GGR4MsIGvAkAkqTcOpOOcG/oU9I1+CB8pgTj6gYkIQj5w2C6koZm4CT/0x6rjqMPdjjd2PP+ulXZnh7CqDGiK3LsyqH0YriBRxWsYqOEBjsHGi9K8tpHkBdnWfcUWXd/I7tnvl3NBDT54thwY1YxndCEW2/szYMvi49IUHqhhE2vI9q2tp7HQSdNId4tXWi9/QXOUqe9II7QbRR8DS8R7dXDC4LLHS1gy/RSYIPQva9I8vUAMITysD71pcONEwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
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
>   kernel/kthread.c | 70 ++++++++++++++++++++++++++++--------------------
>   1 file changed, 41 insertions(+), 29 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index f1e4f1f35cae..51c0908d3d02 100644
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
> @@ -919,8 +917,22 @@ static int kthreads_online_cpu(unsigned int cpu)
>   			ret = -EINVAL;
>   			continue;
>   		}
> -		kthread_fetch_affinity(k, affinity);
> -		set_cpus_allowed_ptr(k->task, affinity);
> +
> +		/*
> +		 * Unbound kthreads without preferred affinity are already affine
> +		 * to housekeeping, whether those CPUs are online or not. So no need
> +		 * to handle newly online CPUs for them.
> +		 *
> +		 * But kthreads with a preferred affinity or node are different:
> +		 * if none of their preferred CPUs are online and part of
> +		 * housekeeping at the same time, they must be affine to housekeeping.
> +		 * But as soon as one of their preferred CPU becomes online, they must
> +		 * be affine to them.
> +		 */
> +		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
> +			kthread_fetch_affinity(k, affinity);
> +			set_cpus_allowed_ptr(k->task, affinity);
> +		}
>   	}
>   
>   	free_cpumask_var(affinity);
Reviewed-by: Waiman Long <longman@redhat.com>


