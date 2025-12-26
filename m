Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A94E8FDBE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 22:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61BB6B0005; Fri, 26 Dec 2025 17:17:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C616B0089; Fri, 26 Dec 2025 17:17:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EB66B008A; Fri, 26 Dec 2025 17:17:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B52D56B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 17:17:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CAF5C1AA2
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 22:17:04 +0000 (UTC)
X-FDA: 84263033568.30.0B4985B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D18E74000A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 22:17:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d0pJk+UB;
	spf=pass (imf04.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766787422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gb98MWMdlEGo36TvwfyminxMDlqaYbAnnXftxbdSDi0=;
	b=aQmU6tUt47UuNm/btjFlW+IhSiXa0tEK7tk5FDZ8iYPDEG2LXqtCkX/aimnbkAJubFgNNg
	Gxjxt6ocKd6rt9I4TKxE+2DTKkA41W2vn0muawUsMppEU+9EIk2HRbCf5t7DhAlMnoae91
	EW9foRDtOZhF+WpEotwG2K2t3DyX42k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d0pJk+UB;
	spf=pass (imf04.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766787422; a=rsa-sha256;
	cv=none;
	b=FVm5Hwu4/3lNu5hmvT4aBXd5kUDnyDTxUYPJGizwKG61rffHOjLT1hOgt0pmYDZI9cz/7R
	OWnxVxEqRw0LYUrXH+Q4scDB9BC4uWlnGt7BHIu1ws9YAxYUqrvS2ECJW8O2YG0lt4geFf
	Njs80/CU/QKodoQ9cGBg74rX6BUKk8s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766787421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gb98MWMdlEGo36TvwfyminxMDlqaYbAnnXftxbdSDi0=;
	b=d0pJk+UBil7d0TNuXgVSAFqSsz1UkHMD+fhnWvxd2VU79CI/VKTpCKYpMJH7xiQIxokCt4
	Xq5M636MDoPCsC6InRJb/TvcbKzvuZgdCgyBjddreTDCZ9A/Q8SA3mcw3xbn0lKhC1vf8X
	wr7P3l0c7OCIGk2JfW3LtoyTLBDpJAY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-f39FrH0DMtq9cZnT8TzTRQ-1; Fri, 26 Dec 2025 17:16:59 -0500
X-MC-Unique: f39FrH0DMtq9cZnT8TzTRQ-1
X-Mimecast-MFC-AGG-ID: f39FrH0DMtq9cZnT8TzTRQ_1766787419
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ee1b7293e7so269875361cf.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 14:16:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766787419; x=1767392219;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gb98MWMdlEGo36TvwfyminxMDlqaYbAnnXftxbdSDi0=;
        b=BzRPqnz8zEcybfhiTSworJ/PuO+Nas6SI+DGfYTMqolxKFY2bQkS9sqDlKzQpyt/jU
         9E9gs7MnvwG7HQe7eGS5SVgdYO/qpxmyE5nZba6WL9kYBty4k/1Svs0z8owmluQVUsCD
         DV//2BfaRabG/TnxRCRoawHCdvdTARcUBmCFKux0XTtRYtuio1/C4oRD8ZK2CKDHZ5Gc
         LqYndi4+fhk4/XAYj90FbYM/8qxLs5QVwE50O5WgaZ8X9kAEQ07iYqTHAJvGinp3o0K9
         z3Xln5X0hYHQaAnG4/hdHo0PkrSeeXYDAeytIQW0ok0n4OW0pHNVy772XaFs/pxLx6Z3
         wpyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZjl6Ht64c227twoHTPkSbLPX06VfHUB4zF09DIciFSQ+zQG2ckTd3ltfAlDElWpljSCo7FKitSQ==@kvack.org
X-Gm-Message-State: AOJu0YxoDkeLcyk09kONiC4myzsQ6jEhGtE97Q/4cpRWm0Ax2GHC2VwE
	GmMzQLu8AxXq5PLfzEee3RRc5QaFUqg/el6Z8ni+E3HHcLn2gLLBHXpFhFDrFtaiMUOafzfqOgT
	mIHMViCdxfbYSAIvxNurUJaAHLJYFhxz7p8wepxIZuuRSS7fdf0cr
X-Gm-Gg: AY/fxX5cQ2a8MXjAk54Wi7C4sRqx7kqNMFbEAUfweAVc/N492xXe5R9nwbTHATQhfTv
	OQVQ2xOvYDcSJVCJUfgoxB5+kfDMzVnd/1TpufHZSmfpWYv5njUmtNOTXMcnylOsAYqGN5SUxAZ
	Y27Qucttv3l7aw43UNYzgEkLsqVkxx0sdfTPki1WhcMf6pXtvqu7c+6VI51dMwZe5DsIQZaPSl8
	TVhFg6B3ChQqMWlVFrrwEgzZ1aMw2+s0MrqKYpbkRCELJpsCCp3oZsVnxFaCZHfmKwWT0Bv3cQW
	HYWwRwYiJr6E2kR5VhbDquHU4Wg23F8tNN45RcTzx3R09MReNEj+mhcblshNPRzt9xDDBJKjP28
	deccC7lqrYhohNGwx5VyBedDabVy7ckljCDQfPdzshv2zTJsIT6HxITyS
X-Received: by 2002:a05:622a:cc:b0:4f0:22df:9afe with SMTP id d75a77b69052e-4f4abd801f1mr367336621cf.51.1766787419335;
        Fri, 26 Dec 2025 14:16:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRvuLHSyqUpCT4r+1J8I9GjzOXah9qpvn8vbYEiTnx2y0sMdtY9oMwdnxWWZ/KZalKRQ1OSQ==
X-Received: by 2002:a05:622a:cc:b0:4f0:22df:9afe with SMTP id d75a77b69052e-4f4abd801f1mr367336221cf.51.1766787418961;
        Fri, 26 Dec 2025 14:16:58 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac54adb9sm164334711cf.10.2025.12.26.14.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 14:16:58 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <46a613e8-cf5b-4fbc-9299-48ab1a6f347b@redhat.com>
Date: Fri, 26 Dec 2025 17:16:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 27/33] kthread: Rely on HK_TYPE_DOMAIN for preferred
 affinity management
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
 <20251224134520.33231-28-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-28-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b46rn9T6wubCkId8vRJvj3hfc4eCnYBPUxVf4J8JdDQ_1766787419
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D18E74000A
X-Stat-Signature: oqbjbcaqfab5cwifmuwn33w7qstwwey9
X-Rspam-User: 
X-HE-Tag: 1766787421-135537
X-HE-Meta: U2FsdGVkX1/6gFwOziNH+xdCIEr9cJeG8febizrLVB2J10SesHj4CcFI5QI/TQVQ3gn06tGyrF/xMa7KFRCyZdqKg4N0MlWcD2ZX3hZnd+ErBctk770umomoqlT7Dvxa/JjOcCvsS+pGojb82dZMhkGi1TNhD4ZVr/bLLJF4cryybsjGrcs10HeB6cDmEQYenhp+D/s9cIx92QpdtKjr6iwUnNaIO7ZveywhtHbdeBM5r2B+Iei9IIXl1/OpsbpcVHFJHoVcuNLUM3j3z2jD2k4DMNppe1dRJySlNJL78fvy4tySwe6mP2DDJiXz7ElyPywvsVOiQR0fPT8DwE4qotd6PvmA2pKoNwBv2kWAf5XNHpKCYsCbG5TqMTUw9jid3vd3EiQ3mnrSov717ckl5NHnsR6LOe13wI8wPNRLdkAM46zfaodIezwn4K2r+UPAe0eBR9/R8UCWZzp4gamvapeeT38fd1oTXuEoxP07QZhvbaOZq+gLhgy2iQNhvtX96StrX9cIE5fRLUz1VmJW7n74/RdHi4S6lpZkUSxUL9vIhT3AJqmR19t+nnx8ORUOLJtFHFT64RGQfSaxJl/W/NMwvXE8AnmJjMHGK+53fNmO1j+SBjkALnPI47PBir+uvyVlHHId55kERJjS/0VjrwOOIaIINNT6wKdSkiRzZqvv0ayDLIRugqePDRhaUsic5JatLHHQyksLfCU/8gljkL3t/P/s2pn42TzfCt5QSm14a9yQtF6MJFMqXsLHV2+1oB7t6VeYvFJqHIcidnhReGvrS/cESmbmgYQEGZk4HBtOnTAOzTrRrfFr7gYLqOwhm7BK2QfBku65/i7BgVuLM6bzhy6bDFmGbrdiEmA40ZwnfNH0321h83BrwKL3j64+814sCHU8IUKrV8xlWj+Ol22Ls0QHWbLh9FczlZk+kQjvxUqiZ67F0tTkr4v9fn64rmwYUTSjI4N2DZ4zR1Y
 6GI4p6iU
 vHKSxhzV3gb7aRa3z4Hq+HBJrt4lzKDylo/J1Sbhc6DB00WP6YnuWZf5Myd03QZ5RVR7EkEv5rdZ/8LIFdYQNMyfPi7cBNMu4Z+IkpjtajK45Cn7HwNnjsTr7zOnZVsYfYsA4PxfCFcaGCWAiavVNhWJhhGnvuWx2zs/g7Ytx9gM4ztP0VvKcwXy5/nMttdnFZnTMkqkrqnxLSIU/KtRMqnGTP6t7yjKpfmgj+pBdiD+MhY/YNwA/fjlF43x4X3py1PhD5Q62PyBuRkxWfZcHdCDh4TVIux1C0NyvEN8DOZwRWuIDFc6H2NjntcY/JxNc2WPCqW/+vl+w4IsYTNujn/7CLpeT62Ig3UicOf00z0F3NFCcve9/onrDiJuXSG4WkIhr8hBg3ZLXcR+PtEN1cZNuUqLjI519ZfZq0SzKD8HYN5fX+Q8cPlHF2AySD+cijHqgXM2UVWtZ2UgF1ceNWnYRiIOajWgxp/SE+GTp8hbkB+V9KczWsMdzzRwE9nOU8busvRpzzbVJtCei9ryi8t6n5kscYW2/2RM7TgOR3JxWl7SaCkAmAq4Uzpt9rjCQWJkVH2JDW7Y+ZUQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Unbound kthreads want to run neither on nohz_full CPUs nor on domain
> isolated CPUs. And since nohz_full implies domain isolation, checking
> the latter is enough to verify both.
>
> Therefore exclude kthreads from domain isolation.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   kernel/kthread.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 85ccf5bb17c9..968fa5868d21 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -362,18 +362,20 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
>   {
>   	const struct cpumask *pref;
>   
> +	guard(rcu)();
> +
>   	if (kthread->preferred_affinity) {
>   		pref = kthread->preferred_affinity;
>   	} else {
>   		if (kthread->node == NUMA_NO_NODE)
> -			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
> +			pref = housekeeping_cpumask(HK_TYPE_DOMAIN);
>   		else
>   			pref = cpumask_of_node(kthread->node);
>   	}
>   
> -	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
> +	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
>   	if (cpumask_empty(cpumask))
> -		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_KTHREAD));
> +		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
>   }
>   
>   static void kthread_affine_node(void)
Reviewed-by: Waiman Long <longman@redhat.com>


