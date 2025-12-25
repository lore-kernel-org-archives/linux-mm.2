Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A1EE7AD71
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 22:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA26A6B0088; Thu, 25 Dec 2025 17:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F646B0089; Thu, 25 Dec 2025 17:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9520E6B008A; Thu, 25 Dec 2025 17:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 858666B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 17:31:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 316D260E97
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:31:17 +0000 (UTC)
X-FDA: 84259440594.20.ED13649
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id E1334A001A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:31:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ojlxd+jF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766701875; a=rsa-sha256;
	cv=none;
	b=HBxKm5iGnDDAQpBn9xk5/pUvOnbRvqBXFuk1aVvKlc0VJJSSlOvlCOqRAzs/PPhkao0JQK
	GmgRvM+1dpa3UWwKDWrgJeX82SaYQoJAoLS6wv1QnLICyiFlJn305iU4e4dteLGKJFibNP
	uYm62tlxF6FGc/JNxfEytAMbFRs0gMo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ojlxd+jF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766701875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ab+MnheIVRKoBcmzrgSbvk3S4ufWNXWYr9CVeGGgh3o=;
	b=fU9apeqSdDiQ/Dt+7om1ZJR5OdFeMkn6G/zuuJcQfSN41xAKTmfKsJhbFeaKEV/cFXYvVi
	KctHh2BXxTKRjzDbLFI0hgEC41V1ULTT0I4UZ6ORrMEREzX6/hlDQFG2i4jjab1LOsymki
	Nn9Xafx6bw/C1ORzX2VlOG/6F6sZCys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766701874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ab+MnheIVRKoBcmzrgSbvk3S4ufWNXWYr9CVeGGgh3o=;
	b=Ojlxd+jFFaIjokcdd4JYtF4wDCUBNpXyskWv9AkAqtvKWn3624vyBem09eVcVZz3FZaLut
	J4LY7uBWR7Vnx0UwiBV2RzOE3J3zIfZePfHFly6s3xw4Du9T8/l0YzhYn6+oo78qHKpqdY
	gDwuDBikncMLOmGOPR3L6J6wxGCoif4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-3K7QZC_HMUG6bcVmXs2a7Q-1; Thu, 25 Dec 2025 17:31:08 -0500
X-MC-Unique: 3K7QZC_HMUG6bcVmXs2a7Q-1
X-Mimecast-MFC-AGG-ID: 3K7QZC_HMUG6bcVmXs2a7Q_1766701868
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-88a344b86f7so247904706d6.0
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 14:31:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766701868; x=1767306668;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ab+MnheIVRKoBcmzrgSbvk3S4ufWNXWYr9CVeGGgh3o=;
        b=ftk2b112zw37ti1I7CVjZ5KtWAbnEupTWh3vY7MGzEdC1UdL27ezEt9b/7y8q7StKD
         8dtbdE/jczQ+ZJBx2H72te9mYygpzybDCssoT6JxPUcAcakEdyxAUXGQrpa8SDasE+Yx
         BMjOhSMqgcfJUcWxrvdh336+tk0it3mLNMfcS5u50vGRIp7dyA/oDiHyZI/nutv8Utc+
         Y6YsAEcEGuqqqdKHdoDl9kdgFicQUeG8NEZaBiEXa9/9aDjTToDVUAvAA0nKQLKb8s8E
         FkkbX8vQ0YIAbNJkjqJ+VAGFEGg/FXf+SNCulKlBJgm7YaCBlMHpCKTdkapyiIrrEwP2
         shLA==
X-Forwarded-Encrypted: i=1; AJvYcCVtWfxK0Yu/LTA4Kyj8rnJrj2SahWqrwiIY+CtIpmMg7xojuWRpzXEmTqq3V65qAa+gdH+iM30w7Q==@kvack.org
X-Gm-Message-State: AOJu0Yy1cadsCjH6DyIPW/W5FykClmyT982Cbc4+7WAG+aGWDA20DTqS
	HPRSrM682Byd3FQCsSPF4QPSy5rF+NFAcTXYq5g+CYsrEEBCnZhBA0UrBFbPG1wI12hpHgeh7hu
	NO/7WZR08R1u/lYl6u2XmgU7mLRyTh2PtTSG+TrKeXGKXslisaZXR
X-Gm-Gg: AY/fxX4mJhINuS6TzQs9fbIAvydCUiYkFa/IQcKEya/5yrdb0mnCd6gYDJYrk6owtmR
	N/JeS9NFWf9xk1etlV9ej5sPDqzPA0JPrF4z6h5DlgUX4te9yF5zZOkQNQzI4RfuevEy9VLRWrG
	NdajhoVn2ZEjM42KU9aYOcDD7uveZw65u02a7vwVuyvbzRnG7/dUOdpP0kxcxin4pcDHweyrlTP
	RB21JKiYnKELKoGAOnjz1MOX1RNSol2hxdQ0pjsOucL+LUyv/xuWFK3PIXbG1Q713STJo5V4WJg
	r4VT7GbrIDRPlys4OmKK1liyispLzWSC6MJdLtkATqaMolKCfp+eG9JmGHbJi1nfZKbAPmOxWA/
	+M+9lV/gCcVjCeiqkjvg77rSeBQM/fg9AVhPccc371r5v/W+zM/QJaA3M
X-Received: by 2002:a05:622a:341:b0:4ee:24fc:be81 with SMTP id d75a77b69052e-4f4abd400d4mr330935961cf.36.1766701867900;
        Thu, 25 Dec 2025 14:31:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHthnytoNkit4+7wP+txqxK1npOqoQN/ulutuPL/gqwE7YXGTzVApXUK7yM3kp5hfoASbcRLg==
X-Received: by 2002:a05:622a:341:b0:4ee:24fc:be81 with SMTP id d75a77b69052e-4f4abd400d4mr330935421cf.36.1766701867385;
        Thu, 25 Dec 2025 14:31:07 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac65344bsm146923311cf.28.2025.12.25.14.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Dec 2025 14:31:06 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <006b00ab-c8b4-4a2d-aa38-94a41eadd238@redhat.com>
Date: Thu, 25 Dec 2025 17:31:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/33] cpuset: Convert boot_hk_cpus to use
 HK_TYPE_DOMAIN_BOOT
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
 <20251224134520.33231-7-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-7-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k9aOLNXwCZXlT7JGCu8vtzjAaxruGBcrTUtRLjcuVmw_1766701868
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1334A001A
X-Stat-Signature: 9fwy8je5gwnh1r6d586zew3w71hescpt
X-Rspam-User: 
X-HE-Tag: 1766701874-898422
X-HE-Meta: U2FsdGVkX1+uyft33Br+xc6nubhzVtgryVed4q55Ey+prfKVT5BA/sWYPLHEVMB/VJKGlWpJDkftdVwD+iKbyuEPtOZ5MGLnGtC39VagQNV7EvCcHsnv2j2h4DoW/W2Howly2w6UjmEUMCI4tpLBVIpVxG6XahHq3y9vwJ1k/7iA0jJtChW/TfKYTVhuc/6jknWeTilysHWxXh78tPVr4YfMGU1gV7V0ZcPYk8IBV/UZnJOKkwOq/2zx+Aar04i3mHzKRqWYE1eMi2/aHVdifQxe+3MNDUszYvV7pONGF+6jn4oe1LXXV+7UbCkoAPZ6fTqxI8uWRM5TO7WMoNLfigwGfmXasQ7D9+lto+0pdbhbXugUP8JBqVdA6XNGL4bB1mGxKhvhyt1OptKkXvyjEkaltZG3UYLAasnGc8uPS+JT4V0Y66YO1YUBiQ5qJlkhevkskKw3zcxdoa1BQqQZHGGHqPmp/P/N554cn1rNN+zqGQkk2CD1sT7ZnQhh4jzDDWrpdFbVJ+GusW1RAT9Q+NQ8JukEd41RVG3fWD7aLhZOImYDo5QUqOXAibbSrH2wYcWeoC+seLoKWTa6ntrXcQ1Md7RQT1YguMQUDijbL/FbdZV9vZvmMW+dAUmgaWbP1Byou6P3kXYC/SL3RYxJsqoIqVaqGXG20HD2mqYsVDMfcV1K5NmVn7YcvXH13zsoYWXOshJzvbTk8O4qgD7bGzUBJFFFKI/NgQsXQ+3CVAWDjOZCanEBRX4OUq3ySS0jjN6711N80vjFyi9z6Dvchg6cdGx6MphykdNAMjcEPPtqiCRzrsHb6EJ9GuIBsfMgOwdnEt4cXK3ADnzdM/XTnYF4d6BcXoZCa4vRw2OJk7fW2Ac6M4SSV5ZHw/s0ebFLLpMZrd4/QRZL4DWIALyMSuVUkhO/NzwpWefT5MW2Q4Afq3AvstGO+QMH85QsEgc23CyYaOfjQjq+2Xz6LM+
 ZxaIg6s3
 szFtCs4ibXfM+ECp2/8s8UBUJPkt3YdFX8HuFvh5kZbS7JfwoCH8hT0ixYLE7VIBqQI5h0bVS3NReTCFNr2KOHpXVpDV+DEvXd020+Ii2XmxeiwQWtJc+JaYkhaR0+JzrFe9CIOmtpWiq9yE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:44 AM, Frederic Weisbecker wrote:
> boot_hk_cpus is an ad-hoc copy of HK_TYPE_DOMAIN_BOOT. Remove it and use
> the official version.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Phil Auld <pauld@redhat.com>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>
> ---
>   kernel/cgroup/cpuset.c | 22 +++++++---------------
>   1 file changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 6e6eb09b8db6..3afa72f8d579 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -88,12 +88,6 @@ static cpumask_var_t	isolated_cpus;
>    */
>   static bool isolated_cpus_updating;
>   
> -/*
> - * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
> - */
> -static cpumask_var_t	boot_hk_cpus;
> -static bool		have_boot_isolcpus;
> -
>   /*
>    * A flag to force sched domain rebuild at the end of an operation.
>    * It can be set in
> @@ -1453,15 +1447,16 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
>    * @new_cpus: cpu mask
>    * Return: true if there is conflict, false otherwise
>    *
> - * CPUs outside of boot_hk_cpus, if defined, can only be used in an
> + * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
>    * isolated partition.
>    */
>   static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
>   {
> -	if (!have_boot_isolcpus)
> +	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
>   		return false;
>   
> -	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
> +	if ((prstate != PRS_ISOLATED) &&
> +	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
>   		return true;
>   
>   	return false;
> @@ -3892,12 +3887,9 @@ int __init cpuset_init(void)
>   
>   	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
>   
> -	have_boot_isolcpus = housekeeping_enabled(HK_TYPE_DOMAIN);
> -	if (have_boot_isolcpus) {
> -		BUG_ON(!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL));
> -		cpumask_copy(boot_hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
> -		cpumask_andnot(isolated_cpus, cpu_possible_mask, boot_hk_cpus);
> -	}
> +	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
> +		cpumask_andnot(isolated_cpus, cpu_possible_mask,
> +			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
>   
>   	return 0;
>   }
Reviewed-by: Waiman Long <longman@redhat.com>


