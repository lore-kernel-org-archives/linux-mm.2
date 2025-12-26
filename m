Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75672E7AD79
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4AEF6B0088; Thu, 25 Dec 2025 21:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01CE6B0089; Thu, 25 Dec 2025 21:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0DD66B008A; Thu, 25 Dec 2025 21:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDF66B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:25:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 498328BC23
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:25:02 +0000 (UTC)
X-FDA: 84260029644.04.6F73D9C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A1CC12000B
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:24:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hOwfFZ71;
	spf=pass (imf03.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766715899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Qsz5WPFD/uExCJQBnyZrl3TgkdgAhutxKnz59++5sE=;
	b=kZ3DMiScZDfYTg2c8fJjvHn6GTz0Ys6eS59XwRV1SinYSzeJ563lTRYmTfKyml4gQ4LFF9
	Zk4Usx/RT9os1MCGxfktMCqctSiwWdCmlkCL0xP4ftPzwLfW9P70sWi8Kji9fzGgtq7REg
	V0xxcno2MYmpTiZ3YT7Btr/Q2rocZVg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hOwfFZ71;
	spf=pass (imf03.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766715899; a=rsa-sha256;
	cv=none;
	b=FypL/+wlMveeFAGw5aZ9o0SEkOPRtaVD3jaDxoT9E5BWqatTClPAKEtaq5W70ckcb+Ei+G
	u+qmdSpQ8lIFVv3R7PCm7zC1Mv4UWxTPz8zMCclijqpEJmgQsYjSHN6Y6WtibsGFhhhgjY
	F40H1uZMtoBouviL+R1AkbJF2Bw8xj0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766715899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Qsz5WPFD/uExCJQBnyZrl3TgkdgAhutxKnz59++5sE=;
	b=hOwfFZ710VPjketZu6BcT4FTzJihP8HWqg/bEK12ffUbnuOtlDn7F61S+drIcBvfayJQiO
	uPy0yhHcM91k1GV2F+M763QrXGRwYmf+LWEV70nvqdRGZ8sqHgZDdM9/DyyMUzRO0B+5+j
	Ulw5E/AE8OgX604RaBBQKKgGs5fV6ec=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-KazZ5KJPP9OvHnNoQlgE4Q-1; Thu, 25 Dec 2025 21:24:57 -0500
X-MC-Unique: KazZ5KJPP9OvHnNoQlgE4Q-1
X-Mimecast-MFC-AGG-ID: KazZ5KJPP9OvHnNoQlgE4Q_1766715897
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b62da7602a0so7128704a12.2
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766715897; x=1767320697;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Qsz5WPFD/uExCJQBnyZrl3TgkdgAhutxKnz59++5sE=;
        b=epgOThHtv6Q0sFE+Iq4AbD3uJ7dsVeQhzaVZ/9NpKwUt36kDnc+xfJNB47Uk/lija7
         ksVFCklX3/FF0rDJjeDRN1RJiuewT2199AmhUKVrtbJNzG5XWzme05+ERQxai2A1Cy+7
         Oq6/2ZLNjVoDKyZOe7AaFoK9P3P6e4xiIEmtS98pce9V0PPFgm8HeJZm8DgipykhEuKF
         jMXB5UFvcSTr7TLgfT/y71a2K7r3TC/TutHHC8RWUPFzBP2kOgmCb32IK1lwxPhxpWx7
         sm8nqo9OlwicL9nL10jRQBWnS0exakQzDQ4bji4ytO63jnQ1W7rQMz1N5GG7w0CWHzVW
         Th2A==
X-Forwarded-Encrypted: i=1; AJvYcCWiOOqy/NiKHCVC66JmKkdYRevh71O5uCOdKp0ZuN4JrMJxf7L/kryyixKItQ0uvOwJ2y3NDOityQ==@kvack.org
X-Gm-Message-State: AOJu0YwwF8kxhm9CdB1qjRtX+V/BLqGcEonA8w8ux3Ak1dGImuZhxIkF
	AeQkvoEd67Xbv+iRWraj0LDHEuk2iqFOwgtZtt6MvgZnAtEJb21h97Mek3nJn0yw5v9KbNZHy2/
	Ljq6LadfSYoA8wuEeXTTXm065YjJADO2cF13z1Ww87RlnOscbiFFl
X-Gm-Gg: AY/fxX70JiYDn6zIxHVnZLb7gkZLyYFIkEkX1R7GFwzKP05CutzDEC3gPp95IF7fIaV
	idzauFWcozsp+YCcDxFa2yu0Lg3X5U0RZgbnkug/iphjL4odBOlIv4hq3KrtIpo6qLvZyhegiPQ
	5wDxYeG7nQqLjDVuQP0c2lLwvQ8nDLRHCOummhjT7+BdNxDa9FFYwIWKakHbX7wsV/dpGMMsbL+
	J+R2l00+W4bD8JnDQKB5l9aSyatjjLo/LCR4H9kmvdiarbHxAgIeV7uUDzSXHSi/6rojyFFvHu5
	0azCnoQC20mzQwVFDW6YuwqrbvZReKOIbJTio32SnUcKhkDSEX6Vmm3W2nqqCntrhZVINgeONBc
	gUPiZfANCO0678rXtHRSqxFTjiLEQdZ3nYOo3zWGYV+ntRq+9T97CfHvJ
X-Received: by 2002:a05:7301:7d16:b0:2ae:526a:961d with SMTP id 5a478bee46e88-2b05ec8642fmr15215246eec.40.1766715896420;
        Thu, 25 Dec 2025 18:24:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGXdA8ClkjU6K261gUhCEsY/UDJEEfrrLSdJplFZD7gmyleR6jxqLs3c/WeMtHejh420lmUqA==
X-Received: by 2002:a05:7301:7d16:b0:2ae:526a:961d with SMTP id 5a478bee46e88-2b05ec8642fmr15215216eec.40.1766715895871;
        Thu, 25 Dec 2025 18:24:55 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05ffad66fsm49761798eec.4.2025.12.25.18.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Dec 2025 18:24:55 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <17aadc7e-7dd6-4335-a748-e66f0239df85@redhat.com>
Date: Thu, 25 Dec 2025 21:24:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
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
 <20251224134520.33231-15-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-15-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kbBwhzMBSv7Dbpab8FsC9NE60cRLavEWmT5ijKVm9uU_1766715897
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1CC12000B
X-Stat-Signature: g3wqr76nqff9s1f1mjmitq8h7riikz6u
X-HE-Tag: 1766715899-476276
X-HE-Meta: U2FsdGVkX1/zX697NisrKceIGfsc/uEODXPR4rolGtjkE1Whjl0xLr9HkDBlNjI9TuZSp2ooaI1a45KHEP6FeOi3wrOKlcsLFKwcNij7os0P7WUQPhePfRQdfdbpwry7DfhnEFocOt1FKGd6/TR9u0/H0g2yDwQSBIwVTNVtnQ3CFe0LJ6tG1WKMAFsmeNp7ZZ42tdB2VXSC9B3iv24Ea26I2GTGD56DPv4yEoZIiCwnNJpviuvWuAwzSbOtp5aGJqM9zekYAR9Qayrjt7lwblfjSKbt5Ha46oiEYIV6HEPrxmk71xuBqDQ7+pjvm0nQSHBgd7mshY16Ssya/IsZgHHhmRkWLNmNv33YTiNMwYsxZR/kKHC6OersJ1fEO1apYWKvuLPZEb50fexsk7Dr7gh9NR3/iPR0a2JT6kvQwRPu/5b3xPw/0LmBoNxqKkQV5FkrtyzUL1AJDm9WvketWYvXczWlxuPIqnqvl75r93GT4Y66HOwAOlOXxdU/BlfkDCsB6n9Ld0Aggw0gobWcjHHP5Hbp9d311QOmhJs2CDnUyMIRqfpWAwjn5hAuoSaC0grfDFYexvathfh9aDfA70mIRumuPhLKjaVBEFK3YYeksaqhMxUzfwnYJ+pJhWYqpcBJ0yKnxxDsGZno08Ekzh9PNa41nnXYew/jMzUUWeDsaVIHP/pUqlthGb7MlOUbRPwt0A6+YjRB4dk2UB4zBnOOPHX6McsqZ3OXyzVPAB7ZzLSiglOp3MeiKXJmyt0hBsANH/jqwDEoDagGtnBQDZrmfgGzz18RX6u136ecPM1ZqifAgbWs7hRu0qGb5QeOml0bgDQwQww9hft5h6RMBcp/E7JDYBwQmNP5simpsDrEGGSL132w5m2FFV560vYPYym1veGNbRzoz29hh9Oh0/I0y2YZccSd645Od8drZKPUWWt9mSo4TnWOh6AFvfkJsifQTaroDHE/f4PlXe+
 0hg39Q1b
 l+sckr8tSJtFrfdTfwLxzpDZKT3GrWirpYl0eN1PneuQQajwvPGbmJkv8j2wCVit+ehkkOlmUae1CO0SKmWuF1e7g9v9olH7YQUyXkQ32Bm53UqofRIvIpmg8I+1xH65czAgU2nI98B3czu95kSnR7NPsSTU7sVQ+rCPxLbn61AT6YVjyqz7AWXM8IaVPK5oUXLkQNMvbxoPXNtrR4Xeheny3VxyLWf3zzgxY+BGrrEvpLEu65clXm3KgYn1ytPCaKC9jPcbWL/uoFMEucUPj3vmeKgJlW8NWVVxsGqL4rwuRC2rQEWcNMh+6/kcWAwVetAeK4gxdvzD7SZdb4R27pTfprp7EkVikIMF6qka8ydtCdZSO/nkwUt2hf+3gxxmGKb9TAZ3bXvkzMbxUthopls4FX0f32Grx2p8GySG/F6HEf7PrE+9c+tMq8AgGKfwegFwu542wUpoWa97ZyNWRC6WvFDYE5/GTcyaDTqqTihukjY8uo3kk2gYmwThBHohYySejGhDFMtl1X31CPZMmm4epRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
> CPUs passed through isolcpus= boot option. Users interested in also
> knowing the runtime defined isolated CPUs through cpuset must use
> different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...
>
> There are many drawbacks to that approach:
>
> 1) Most interested subsystems want to know about all isolated CPUs, not
>    just those defined on boot time.
>
> 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
>    concurrent cpuset changes.
>
> 3) Further cpuset modifications are not propagated to subsystems
>
> Solve 1) and 2) and centralize all isolated CPUs within the
> HK_TYPE_DOMAIN housekeeping cpumask.
>
> Subsystems can rely on RCU to synchronize against concurrent changes.
>
> The propagation mentioned in 3) will be handled in further patches.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/sched/isolation.h |  7 +++
>   kernel/cgroup/cpuset.c          |  3 ++
>   kernel/sched/isolation.c        | 76 ++++++++++++++++++++++++++++++---
>   kernel/sched/sched.h            |  1 +
>   4 files changed, 81 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 109a2149e21a..6842a1ba4d13 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -9,6 +9,11 @@
>   enum hk_type {
>   	/* Revert of boot-time isolcpus= argument */
>   	HK_TYPE_DOMAIN_BOOT,
> +	/*
> +	 * Same as HK_TYPE_DOMAIN_BOOT but also includes the
> +	 * revert of cpuset isolated partitions. As such it
> +	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
> +	 */
>   	HK_TYPE_DOMAIN,
>   	/* Revert of boot-time isolcpus=managed_irq argument */
>   	HK_TYPE_MANAGED_IRQ,
> @@ -35,6 +40,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>   extern bool housekeeping_enabled(enum hk_type type);
>   extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
> +extern int housekeeping_update(struct cpumask *isol_mask, enum hk_type type);
>   extern void __init housekeeping_init(void);
>   
>   #else
> @@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>   	return true;
>   }
>   
> +static inline int housekeeping_update(struct cpumask *isol_mask, enum hk_type type) { return 0; }
>   static inline void housekeeping_init(void) { }
>   #endif /* CONFIG_CPU_ISOLATION */
>   
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5e2e3514c22e..e13e32491ebf 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1490,6 +1490,9 @@ static void update_isolation_cpumasks(void)
>   	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
>   	WARN_ON_ONCE(ret < 0);
>   
> +	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
> +	WARN_ON_ONCE(ret < 0);
> +
>   	isolated_cpus_updating = false;
>   }
>   
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 83be49ec2b06..a124f1119f2e 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
>   
>   bool housekeeping_enabled(enum hk_type type)
>   {
> -	return !!(housekeeping.flags & BIT(type));
> +	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>   
> +static bool housekeeping_dereference_check(enum hk_type type)
> +{
> +	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {

To be more correct, we should use IS_ENABLED(CONFIG_PROVE_LOCKING) as 
this is the real kconfig that enables most of the lockdep checking. 
PROVE_LOCKING selects LOCKDEP but not vice versa. So for some weird 
configs that set LOCKDEP but not PROVE_LOCKING, it can cause compilation 
problem.

Other than that, the rest looks good to me.

Cheers,
Longman


