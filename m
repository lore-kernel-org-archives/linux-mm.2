Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FEA7CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45EB48E0017; Tue, 21 Oct 2025 09:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F198E0009; Tue, 21 Oct 2025 09:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7578E0017; Tue, 21 Oct 2025 09:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 179F78E0009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:39:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8D4E13B149
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:39:20 +0000 (UTC)
X-FDA: 84022228080.22.CBACFE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4F1991C0007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:39:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SG2zq2MF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761053958; a=rsa-sha256;
	cv=none;
	b=YANZATVQdywxioluZDJlDGKWEMLmsM7+rn/FiaVpkmEOdm+0yXckfKc5kyn/+dn43Wxjei
	+SttfCVlmT9tzzuc39dtw6L8ZJlV0uu06dWZ4TH1tmxTrSfyyM6ii73+/n3DeXfBIuCjg8
	DqJHyYH9S/N/BuUMKResvK8b5C0PtA0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SG2zq2MF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761053958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3KJELQ+1zBaV6zsfBpuZG8t84lL3xkiKid35BQ9x2E=;
	b=k5NxieLzlqpv11jz0KO4x3io1fmxyTirJsq2h35dA9wiopdXb04SHJPuMEeJamL5DX5x+q
	ZajxRmpiopQwT+6iCtgoaHAqL1b51MYMUNL1FkE5qshC+sT3hi7Os33f3Je3v4xaxLiqK0
	u+2ye7kk2kpNpi9hjNaNHRU5Hy/fFdE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761053957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3KJELQ+1zBaV6zsfBpuZG8t84lL3xkiKid35BQ9x2E=;
	b=SG2zq2MFO/c/UsWw/U6WiCzx7HXsmA0d4S7xKDNHiQmg2V9yXIcOfAUVs2GaS96v/vBN6B
	sWr2CPJiLCfBWFASyiQDpYEPYmia9xSvo/BnqISmqeFzk6AJANazx0qpYOCQ8ZBYqGgIxv
	u2jLRCvjvbYJs0lN6iBjr2ppYNmfY78=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-dCJDK9vaMX-kQzSMB-WZXw-1; Tue, 21 Oct 2025 09:39:16 -0400
X-MC-Unique: dCJDK9vaMX-kQzSMB-WZXw-1
X-Mimecast-MFC-AGG-ID: dCJDK9vaMX-kQzSMB-WZXw_1761053956
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-87c0e0d12ddso204425086d6.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761053956; x=1761658756;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3KJELQ+1zBaV6zsfBpuZG8t84lL3xkiKid35BQ9x2E=;
        b=xIlWcOvJcdXoftfNunplOw8D298lCdHFWYOcxhBIjQ63sbjnZlHIba3Lz6dsiOlsEf
         fs9SqOiTM9DzdhTTGIE0jcIYS+K5VDQ+DCsifUEQepuZD9xnc4JdxGI5K2e+bAIULjao
         ALbhFQ19eZJ6liHg5KspZ7trSAIEcm4QX4tCnmlJtzr5TajlHQgKMumpQ0k5pavSlf38
         22EJVp7flF8RpxxOO+uiY/ynzxXj9DpUCJ8RMbvdF9swtSuC+nqbMuTJwTGna4r462jB
         tbVP4tvnZ5cQkV74mG90DjeY3WGvQiYWLgj2z2gEcclbmOeDHAAZMQQSecaSk4CAu2QT
         PXsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIEaUXbXTm0VRpAgKM3P5st/QWRiKa/EiqPQ3gE4Fh7C28SauesAN8XIGX5fkAsbwIhnuFQUKeMw==@kvack.org
X-Gm-Message-State: AOJu0YwAx8ciPvI8yRKQcqeKPq6HOiQ//RSbz/RdNXTvmMrnJd77WQM1
	JxCltw8KPV33YploR64zI5JWapwNM/wV5y41T2qEcx0zSzD0fQAFU2FHwpafUgjWlVkTnorR4Dg
	7fk4aTxbUjzG5HXwtM8rf1RhK4wM2PvuqeOghy+eR/6Q4PTYaqAmN
X-Gm-Gg: ASbGncvu65daKapbElZywP9gjfQ09jfcVbOOR6aB03/JE0ZsE53vr0O1/LhJmETUjH+
	U4x0lZPbeZ+HaGUII0WLenRbyVxyiRfEPukt8qKHU4UIBWV2ViPQ/hxysnwp1yrX3ORgVtujA+F
	JiPANowL1qs3pEK+neA6n91VWYlkHAc4J63yS51AqxrUsQAveFQkDHl7Fht+xYIfC4woi31Czg3
	YGysSwwGHKZjOD5ns0cI83vt6zm0+O4pYi1zLjA45HPWbXpxrOEnccXmtSkb2GodljGJOroZjH0
	bqLS7RaSKn8Zh3N9X5daJnjixgU7j7Nv1LBIdwLpPSxAdth3mKsXHg3YMdTd+G2MwxFsNQm6LOq
	OhG/kCrqOkh9VsdSwx19xKF3YWmjaByV619gdFSmCPtBwzg==
X-Received: by 2002:ac8:7d8a:0:b0:4e8:a6c3:4322 with SMTP id d75a77b69052e-4e8a6c343dbmr147838261cf.68.1761053955803;
        Tue, 21 Oct 2025 06:39:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFz7AKLLzN2UNU/guKrJvkpbFnggCrMTTSh4yWUy38aXqbwBFVcdBvCw2i1DLngSoeAJ3ah8Q==
X-Received: by 2002:ac8:7d8a:0:b0:4e8:a6c3:4322 with SMTP id d75a77b69052e-4e8a6c343dbmr147838031cf.68.1761053955419;
        Tue, 21 Oct 2025 06:39:15 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3370fsm74330521cf.3.2025.10.21.06.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 06:39:14 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <ea2d3e0e-b1ee-4b58-a93a-b9d127258e75@redhat.com>
Date: Tue, 21 Oct 2025 09:39:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
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
 <20251013203146.10162-14-frederic@kernel.org>
In-Reply-To: <20251013203146.10162-14-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zz4A1ZqKu15bvcmrTLsKYeLZF28gvST8MdaBXK90O1E_1761053956
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F1991C0007
X-Stat-Signature: obkoo1fj71rusxaf4kmesgn1uembkppt
X-HE-Tag: 1761053958-916653
X-HE-Meta: U2FsdGVkX1/B/Xg2TUJ9VR9lyiw9+S44e9d5QVJvd0XDVeHqs9YuG2XVQqxeFgNSGQBUOy1UtSn1EvY5B5mYL4Y1gVaYY3fKsPlZlP7NfXfaSYRS8FuqivolXtw04gwSoLfRkkzH7qK6femRY+2ZOPOsJBPKn7X9Ds+l5TA2rpoeo6tXIZFuwwN3X2Tdlmjg+nOEi4kC1+rxp497B7dC62fetxgtTIFpbLlb+R4/in+72Odm+gGOdrZ2+tfZEvPThpf56Npcg7hdBctJrkv0NEUmBQejBMXxWU0C1tH0hr6zoHUQOvR5SK2UNWuIbEmlYjfsdl9jtorJP3Eqxg0BO4TjuLk6BaxcI3dxZ3SWzgwqfIye931w6u04phIvw6Uw857XooH0BB5f5UoZfIlPdAh7+SzXZc8OCGS1wd3qapTXwXx3hD1hWhv7x49GW79OroANxhr+9alNVYzgz5wOl+kCeRl3XN5xz6wC+Zg0xWMbz522OJ/wKzLDAOdDct3DI33IgoicIX6bQBaXH/q07u3h6uE3VdlpzW1Vl8er0DGDQNNrRBh5KfE1WjeoyJX6lDfMj5j50yXOsMRMSHx5ygtT1dxNv+XbxI6MNooLGw1SeyGH9p01NrcRuR01no+AUif2hvaofuUnSLZAs2cwDtBgKPxDZPQ1bHRM6W9IE0ffpvKL0A24Z0T8xJoPFq48E3ohBJcYyrOYxgDNk10HeeGbOG/qSBVtRb0HVBXjL2tTOjbg8i8tSYVUD0vvSgqxuPNeShVCNYL5bflzNbpIUTl7Gj5gvmRVfgd3Zg4cVgsGgrKLDCusKk+HyLAMk5qhYBidaTv2zeWWkIzthPGmR12ZeLWkzININgWSzNZeqUh+NH0vDk2571ihHFbl/JC8P0cT8bCiy3xRfpnbIxXALNs0N/kpZz23A16DKO0JcMD5v5CeRpQqZFkdQWz1ZMxBE6JZgaqxwSOiCrV5XIj
 Hlt/zz/9
 B4qpNeB/wMiPXtUodNmbAe8rUKmrq6q1N8PLJ0G4ojNMFoyzeAYSug3PIEaaCAmBgo9wqsF1ivd3txprZq+x2O/SZZmLUNCOdUslo+tLFDmHoR7Y954+s3PAxsyYmhnVDt6zhDLKWj2+5v/9lyxiQM1LzVx0QtT45XIOPG1T055UWMVxoDBFh6wsfnJSmYQeQ7yYmgD4AGo0mi3DSZLBFduRdKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> @@ -80,12 +110,45 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
>   
>   bool housekeeping_test_cpu(int cpu, enum hk_type type)
>   {
> -	if (housekeeping.flags & BIT(type))
> +	if (READ_ONCE(housekeeping.flags) & BIT(type))
>   		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
>   	return true;
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>   
> +int housekeeping_update(struct cpumask *mask, enum hk_type type)
> +{
> +	struct cpumask *trial, *old = NULL;
> +
> +	if (type != HK_TYPE_DOMAIN)
> +		return -ENOTSUPP;
> +
> +	trial = kmalloc(sizeof(*trial), GFP_KERNEL);
Should you use cpumask_size() instead of sizeof(*trial) as the latter 
can be much bigger?
> +	if (!trial)
> +		return -ENOMEM;
> +
> +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
> +	if (!cpumask_intersects(trial, cpu_online_mask)) {
> +		kfree(trial);
> +		return -EINVAL;
> +	}
> +
> +	if (!housekeeping.flags)
> +		static_branch_enable(&housekeeping_overridden);
> +
> +	if (!(housekeeping.flags & BIT(type)))
> +		old = housekeeping_cpumask_dereference(type);
> +	else
> +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
> +	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
> +
> +	synchronize_rcu();
> +
> +	kfree(old);

If "isolcpus" boot command line option is set, old can be a pointer to 
the boot time memblock area which isn't a pointer that can be handled by 
the slab allocator AFAIU. I don't know the exact consequence, but it may 
not be good. One possible solution I can think of is to make 
HK_TYPE_DOMAIN and HK_TYPE_DOMAIN_ROOT point to the same memblock 
pointer and don't pass the old HK_TYPE_DOMAIN pointer to kfree() if it 
matches HK_TYPE_DOMAIN_BOOT one. Alternatively, we can just set the 
HK_TYPE_DOMAIN_BOOT pointer at boot and make HK_TYPE_DOMAIN falls back 
to HK_TYPE_DOMAIN_BOOT if not set.

Cheers,
Longman


