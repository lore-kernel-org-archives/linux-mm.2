Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11CDBE8FDBE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 21:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DEE46B0005; Fri, 26 Dec 2025 16:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC6A6B0089; Fri, 26 Dec 2025 16:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF106B008A; Fri, 26 Dec 2025 16:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7016B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:37:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6E3C138CC6
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:37:41 +0000 (UTC)
X-FDA: 84262934322.07.828DB03
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 491871A000A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:37:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=My1Mx4Xt;
	spf=pass (imf19.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766785059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asBMqPMMlBYgauRrbMzCES/5E7Ini+6B8CJ6RNaEzp0=;
	b=OVZLlLB3FHGXdd0YxmGWB7mP9AeQmT9uj1tpMnNHu2vmGvv7PIZz9izHeVeuS9TjYEuLUb
	11F5QfXo6UnREgrUdCP+8Hb9HrVii2Dj9wudYsKojr+4RbfgT1sCLKBRjSGF4znQA9y3CW
	82r1E6xhRphoCj2KQBh0RsG1A12PchA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=My1Mx4Xt;
	spf=pass (imf19.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766785059; a=rsa-sha256;
	cv=none;
	b=X4bsIPYMi470uoKpdpv4+AvikdZBatkr+CYyLafitOuTd5B5Us6yu/rG5x/rTHYgibc8JC
	PktSRPXtlKT+CSsdn6CLMHYb3sdJHG6zxJ+z14zvFSLd31j4UUUvCCGdjWaK9qai3ZecwY
	oUMtUDUjugq/rhDRHK544ZsLkRoiuOw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766785058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=asBMqPMMlBYgauRrbMzCES/5E7Ini+6B8CJ6RNaEzp0=;
	b=My1Mx4Xtk+XD1ZIYtOKdpgUl82RTW3LP7ChK3Cq973arZcbQw5zJKP3lT7dbZYIINAXhgl
	N3AHiu8PGVIkn9hp0F/mDE2qcz/csh5B7pmdWdCqo4/7xxzsBp0ABHSZBcroj2BI3TfdDS
	h/fwHu5Eo3WxcR8bnKZkMnlO7xg4Ke4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-L8AKJlDAMvOb8Hy79b1Mrw-1; Fri, 26 Dec 2025 16:37:37 -0500
X-MC-Unique: L8AKJlDAMvOb8Hy79b1Mrw-1
X-Mimecast-MFC-AGG-ID: L8AKJlDAMvOb8Hy79b1Mrw_1766785057
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88a3929171bso155732696d6.3
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766785057; x=1767389857;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=asBMqPMMlBYgauRrbMzCES/5E7Ini+6B8CJ6RNaEzp0=;
        b=tJSf/1RAdSfOfGAQwXiEXJ5jnQtGapnytbU7R5C3aN+0Ws8kxaW4w4ZaLy8VKEl+/c
         ABUNexLEFQWea4tCr1zj2IzXN50tbHVOVxerJ8r9lUxgqj8gUnyXYM6B5dJvN7l0o1F+
         ZMvic0fOajOcNUIxjjLJ4GkTP5UFCXl8ibF8Kn+lCUsjLoNiDFzKgRYMN54KdOo5HRHJ
         xCws0yBg3rt3iEqjr/iX7DLoPLqNkE+w6fJM8RIOmTxxP3Tg+NkKz3RZ79UT8oByTurV
         /Lr4kZ28O8RhKTDnTbK8JKgQ0ILX8YHI0+YNFAw6no5rr8d+lGVLIBGdaTBwpf1KwQER
         Z6BQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3ju3b+rzvkiLl5R504Ilf6fe8Rh8BCh0I+vqcGPp01ay+4dt4YO6uszaENLAkK0UUbgmRJJIn9g==@kvack.org
X-Gm-Message-State: AOJu0YzOLvS6BkIKvRL8uYSzw1dZ0xdH7EoozUHWKeSiD09PG+PRVdWu
	gsfIg+2lhidMfq4EqnIkGelZu4w7J44BxkyeFZkh5WuuecWJt+YpAkrGdydZehrAipQ4zjy6PhJ
	4jCG3cvSypJZoQV324ofcKW3jbcDxRL9sKyVPG3n7ikZq+F7zWfSF
X-Gm-Gg: AY/fxX7CJ3dzBDvn2wxkJ6ZBZVIlVSLiNbW+lxVTlp5EzcG/munxaTvAYVu2O117Ojk
	y1uY42RyxXNlBExOC/JaHUwjjyIdCMg30xT8IbjDybvPdFbLrh41OM5+CoQvPuJS9szHi5HLndj
	joCwhJ6jg2jYyd8M9sovNhCUD2shp5vzJACslexGIyATFfZwtLy93QZl1dDZfeTQr3XnlyXiStA
	NtoQhluTobNe/khKVcu/amSM05JazYbQXKh96F2M9nze6nvN5/z7miCvm2LzNZhVl/UWq3ENjnY
	LxKBdluVG2VVdvVst1w5iyE5RXhclHIO53Zfk5aJ6dUkxf+DUfJVBUpaCpvoT2qmRC13OK4Qbce
	N6RaI8tlrWnGDzXta2DHkfPcPUaNevl41kaCi9mncqpi41bDqZlFT+WnW
X-Received: by 2002:a05:6214:1ccf:b0:786:8f81:42f with SMTP id 6a1803df08f44-88d8369eac6mr381482106d6.39.1766785056804;
        Fri, 26 Dec 2025 13:37:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/UszSTKNZq6JUtpfA708/ibPfYyEh5wUQDx/+llWKoJlmPrhzPZqD/XUz+CjETOu+z3XbwQ==
X-Received: by 2002:a05:6214:1ccf:b0:786:8f81:42f with SMTP id 6a1803df08f44-88d8369eac6mr381481746d6.39.1766785056354;
        Fri, 26 Dec 2025 13:37:36 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9680c323sm170712766d6.13.2025.12.26.13.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 13:37:35 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <af440ae9-e6ee-4cc8-a2d6-2178d9c80a50@redhat.com>
Date: Fri, 26 Dec 2025 16:37:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/33] kthread: Refine naming of affinity related fields
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
 <20251224134520.33231-25-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-25-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GWa8-jVrU7w8FZoHmT41092YWJm0mt06IBW6gwZpJQ4_1766785057
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 491871A000A
X-Stat-Signature: cm7wso3fhyamriqambmsetsgi9wq57at
X-HE-Tag: 1766785059-512964
X-HE-Meta: U2FsdGVkX18TArfBRYqC+QPdZJa1HwKam8eJ7PgvU15KOebeGAMA5Vd7csyxv7JG0muACJdsqRcd36vPcK58kvqza/x4INe7IKvogue5v7HqQm82TOXYBBvpzTYQx5WP2yAZ61v6dwkSiqTuwwlMP/R8ZDGLM26FHAZqIhNuvSD1/L0OMuP7qgCSevbnYAi9edPNm7Mvoas2idKaony6i0RRHTKG0ga/QaLv9vAqcVnfln5rBtxFyi4C3xuFO7h8FlNaTkiV8GbnIXHYNW5JFp4dyVwrCEMosKXcU3VWoGdJMvnXdPY8cAQB97qP/FTmz8XUb0Oj2xsGnETI0oA85V5ULsfjfzhHV17w4DRsMqttrV5ZbXFve02o+zVA29sVsETrxl1gGArmWH5huENZeKB349BILYMJVTe32xY700QrJdC9iH029LhSANxIWRAkMuFiRB8+MeXDwQ6JW9KaqVgg7Ss+Wn8uL3+3MVgVval3OqMBF/XPQ6ZZO3H7wv9+BizO02q5XjNVeH0nqDND8u2g1U/7vuCILpos9D7Es/B9FNqIF6PvzaoaZHWGu4Y/Stj1G3DUHu8GhIeyvB+codssVimjhfcniqb+Et4Ql1Mlo93YEFPnp4Qq3+9nwuZ6BNgA3Q9J1I2NZ4uDC0CsYFI3BuaG3wxtoNYrFms+fhCS/JUCX0r4ExSYuCCcfqk8DjDl3/m1whEWcpG4eUk1pwW9oc9D5QZMSA4P3kyGOgnMIs2CaiuZ0qZiBQiSfeopA4CMhEnW/8vCOYy6Yt/rsEcd7/SQCoRNKOVuG/0pqRvDhpF5pA6UWFaCkPM3VDnrTWcH54plXUm9EH4THyMVQOwonjnXyOmx3xvVeaz0nz9EXSWNvWFXMQoZ60q9y6ydXpGGw4WP0DDNXN9S+mlLFpKnHHgxGSwxWOBYDme4gCUGgz/NdiqJlfjlAQPRBacVK5Bh7l4gg/qlnkVgASx
 7Bb4U6hG
 kL+bjiwDOpdQ33r0dDeMHSD9jHSLSDQe8MK7B1Xj4dMUZ4bPaiTIb25y1NUYI3I2nC4R60pNrAoAGpVQcc0DM7jtCaGuseVioPKvQTinMu5i28C57sE4elzyW3aFNDP087ylgRKkEmrwSNBzv4jE+rRtFfDZmYSNqAwYhVnVmHEYs0HJESrXZmxDfPxref1TvsIzUhX+X7nV5Kd4NnW5RpO4oUh60ORECbHryLFGaQrdDJdwuhOi4Qgatr/69KCTqYYoHdMD+OjEzAqrlY/2N/Ywgv4pjxiP5cvh6KASauss+Dv36VIIRISFsc3kpQIuF1INDnYHmGal75vV5MBak8XsB2WIukvoMg07k2gRCKTde7sDnZEH8LSufZXq3E60o9bJdecw626oYK96pKbrNsk450l8ujfLNB3QmceTp04Zcc3VTj07PtivN6PI4OcAc0I4SEDba8aJtRXnjFqBJPhXrw8dBpyuRJQIHWeviZ0c4lTFl9Ww9UV+QznIAf4rXG9Wfm9mcn146WP2JvFzQjuQf2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> The kthreads preferred affinity related fields use "hotplug" as the base
> of their naming because the affinity management was initially deemed to
> deal with CPU hotplug.
>
> The scope of this role is going to broaden now and also deal with
> cpuset isolated partition updates.
>
> Switch the naming accordingly.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   kernel/kthread.c | 38 +++++++++++++++++++-------------------
>   1 file changed, 19 insertions(+), 19 deletions(-)
>
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 99a3808d086f..f1e4f1f35cae 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -35,8 +35,8 @@ static DEFINE_SPINLOCK(kthread_create_lock);
>   static LIST_HEAD(kthread_create_list);
>   struct task_struct *kthreadd_task;
>   
> -static LIST_HEAD(kthreads_hotplug);
> -static DEFINE_MUTEX(kthreads_hotplug_lock);
> +static LIST_HEAD(kthread_affinity_list);
> +static DEFINE_MUTEX(kthread_affinity_lock);
>   
>   struct kthread_create_info
>   {
> @@ -69,7 +69,7 @@ struct kthread {
>   	/* To store the full name if task comm is truncated. */
>   	char *full_name;
>   	struct task_struct *task;
> -	struct list_head hotplug_node;
> +	struct list_head affinity_node;
>   	struct cpumask *preferred_affinity;
>   };
>   
> @@ -128,7 +128,7 @@ bool set_kthread_struct(struct task_struct *p)
>   
>   	init_completion(&kthread->exited);
>   	init_completion(&kthread->parked);
> -	INIT_LIST_HEAD(&kthread->hotplug_node);
> +	INIT_LIST_HEAD(&kthread->affinity_node);
>   	p->vfork_done = &kthread->exited;
>   
>   	kthread->task = p;
> @@ -323,10 +323,10 @@ void __noreturn kthread_exit(long result)
>   {
>   	struct kthread *kthread = to_kthread(current);
>   	kthread->result = result;
> -	if (!list_empty(&kthread->hotplug_node)) {
> -		mutex_lock(&kthreads_hotplug_lock);
> -		list_del(&kthread->hotplug_node);
> -		mutex_unlock(&kthreads_hotplug_lock);
> +	if (!list_empty(&kthread->affinity_node)) {
> +		mutex_lock(&kthread_affinity_lock);
> +		list_del(&kthread->affinity_node);
> +		mutex_unlock(&kthread_affinity_lock);
>   
>   		if (kthread->preferred_affinity) {
>   			kfree(kthread->preferred_affinity);
> @@ -390,9 +390,9 @@ static void kthread_affine_node(void)
>   			return;
>   		}
>   
> -		mutex_lock(&kthreads_hotplug_lock);
> -		WARN_ON_ONCE(!list_empty(&kthread->hotplug_node));
> -		list_add_tail(&kthread->hotplug_node, &kthreads_hotplug);
> +		mutex_lock(&kthread_affinity_lock);
> +		WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
> +		list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
>   		/*
>   		 * The node cpumask is racy when read from kthread() but:
>   		 * - a racing CPU going down will either fail on the subsequent
> @@ -402,7 +402,7 @@ static void kthread_affine_node(void)
>   		 */
>   		kthread_fetch_affinity(kthread, affinity);
>   		set_cpus_allowed_ptr(current, affinity);
> -		mutex_unlock(&kthreads_hotplug_lock);
> +		mutex_unlock(&kthread_affinity_lock);
>   
>   		free_cpumask_var(affinity);
>   	}
> @@ -873,16 +873,16 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
>   		goto out;
>   	}
>   
> -	mutex_lock(&kthreads_hotplug_lock);
> +	mutex_lock(&kthread_affinity_lock);
>   	cpumask_copy(kthread->preferred_affinity, mask);
> -	WARN_ON_ONCE(!list_empty(&kthread->hotplug_node));
> -	list_add_tail(&kthread->hotplug_node, &kthreads_hotplug);
> +	WARN_ON_ONCE(!list_empty(&kthread->affinity_node));
> +	list_add_tail(&kthread->affinity_node, &kthread_affinity_list);
>   	kthread_fetch_affinity(kthread, affinity);
>   
>   	scoped_guard (raw_spinlock_irqsave, &p->pi_lock)
>   		set_cpus_allowed_force(p, affinity);
>   
> -	mutex_unlock(&kthreads_hotplug_lock);
> +	mutex_unlock(&kthread_affinity_lock);
>   out:
>   	free_cpumask_var(affinity);
>   
> @@ -903,9 +903,9 @@ static int kthreads_online_cpu(unsigned int cpu)
>   	struct kthread *k;
>   	int ret;
>   
> -	guard(mutex)(&kthreads_hotplug_lock);
> +	guard(mutex)(&kthread_affinity_lock);
>   
> -	if (list_empty(&kthreads_hotplug))
> +	if (list_empty(&kthread_affinity_list))
>   		return 0;
>   
>   	if (!zalloc_cpumask_var(&affinity, GFP_KERNEL))
> @@ -913,7 +913,7 @@ static int kthreads_online_cpu(unsigned int cpu)
>   
>   	ret = 0;
>   
> -	list_for_each_entry(k, &kthreads_hotplug, hotplug_node) {
> +	list_for_each_entry(k, &kthread_affinity_list, affinity_node) {
>   		if (WARN_ON_ONCE((k->task->flags & PF_NO_SETAFFINITY) ||
>   				 kthread_is_per_cpu(k->task))) {
>   			ret = -EINVAL;
Acked-by: Waiman Long <longman@redhat.com>


