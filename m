Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C314E8FDB9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 21:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75ADE6B0005; Fri, 26 Dec 2025 16:27:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708796B0089; Fri, 26 Dec 2025 16:27:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0B26B008A; Fri, 26 Dec 2025 16:27:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47EC36B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:27:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85C3F59358
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:27:05 +0000 (UTC)
X-FDA: 84262907610.27.330B73D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B89040005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:27:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dK9qEbZ1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766784423; a=rsa-sha256;
	cv=none;
	b=45hwGhTOiRYFKht9ARVCg9wdL2OsSLXL7a46fR2v8iagaOXkH3eSRBUEd9QHHKe+qHrnvv
	eivydWCQwknQTUMiS3lVyzCHjlSunD+LCitHJaVXr/AOqAskMVWWbMtGsYfEsrGEZTYRyZ
	KOdKdIJ0bvEogfELNgtIfD7R0hTRd34=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dK9qEbZ1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766784423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hl0E323tW0AxgEnWj1OLKxpboSYa7xNjNvCKjrDAdIc=;
	b=ZKQh50rszs1GRpR+daqjA1DscQ/YkfZ2EoVCWLeGYN/9one54up2b6WG6E5u+LxKQ5H11p
	Q9wIjfDET5o6qSkF47T+J49Q1guadmTb/Dw+6OVAScmiahu1ew3xTXc4Hi2laoOo2fTPxU
	2StQqu1rZFXZWtGYi+W14X865e/jrCs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766784422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hl0E323tW0AxgEnWj1OLKxpboSYa7xNjNvCKjrDAdIc=;
	b=dK9qEbZ1EOkXSDnsFlpLv/nhmy10vJX+UZmjZO8Ndo83KfSQj8qEUINl2F8hMX5V/5EWeE
	VtdBHHLBS/04hkXtRvML6XpjPyl3aWg8GEDFGB0nneS3pPEt+sqrqW9o2kTp6jflYP1orR
	dRXnzWbhzhgp79Nrgim124m6Rt/7cQo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-4u9Jt7azNdeD2L5uPhJz2w-1; Fri, 26 Dec 2025 16:27:01 -0500
X-MC-Unique: 4u9Jt7azNdeD2L5uPhJz2w-1
X-Mimecast-MFC-AGG-ID: 4u9Jt7azNdeD2L5uPhJz2w_1766784421
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-88888397482so229350356d6.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766784421; x=1767389221;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hl0E323tW0AxgEnWj1OLKxpboSYa7xNjNvCKjrDAdIc=;
        b=EH3qXV4aJ9ZB3fIYtATSAQ+sWVvt1a49fHZJDolw+UGCjWTPzmSuion5T6ktO9GeKX
         F+3Tfrn8viSoaKYyXMwKkjVZK60cisbdfvvlcxGm2+o6xQcnOIb6ZTT6pMIFDYWe9woX
         X2zb7a+MYjlvh+2R6pFo4Bj0v30YLHLnedV5kynQ9d2ir21xbWha92lLT9eQM9eny3Lx
         j0YdkxCqbQTg2KwnRMBHi/lZ3igJKOiK57SkuIWLNIls3NL2FSP4y6h5QcOJQ/JzvxLh
         Al60XbJotVA8JG+2jC97hxC69OH0fQLEJbATka3zwczlaG4aCJOjwpLhKGZFFF4eD/gV
         9ESw==
X-Forwarded-Encrypted: i=1; AJvYcCUaGZ+3GpAbUkr8leMu8/O3ATf99nUqgotrWYM7LJ7ojoAlUGEJsVDr/2eQLLcozchDKeZ18QnJeA==@kvack.org
X-Gm-Message-State: AOJu0Yx9+U4jTj0RLa03QHU9iO+w1XFhn9vNH8JMBHoiLX8H+uCX/1KS
	qLEAjMJ+Vuyrsgwfi7fvfn/lx0KxM47aEeDiWQLHDafxjyk/uou0J505SsVq/e6BQYMtnOYi3GI
	2PR5QwGl3L+kfQCs/qlAFOkumvDjnjLKfGwckNHzT1Y4NDmEEcczN
X-Gm-Gg: AY/fxX5qftAUsDU5UkrR4Nj4y1iOG7BNRnAJKwZuHzqmDtSf3WMFOL8848Lpb30yCUD
	fbAcsV2R/qDK/eVYZmCN0WwSq60yih6O07o7vT3EjDKQwzh5mkQ0/QFCrBEIIOW8pC0jFUk0eQm
	U+S0XnlAVbDDcJ9iBeAak5Af6QpIShyj3Hck8M3AeQ6ugtdgyxXscx5Pai0g6qAr1XzhB1wTn4Y
	/kI4DVrbBB7yFp846KaYwM9tA5+9/v5EwMuOKRzfFYWunAj9kS9/0XVDlQ1lgbRO1rvSJ+Tz2A8
	2V8ViefqWyv/WChVU0cwSq/cI1X3Otj6DhkMIjPEbaliSdIE1T2NR+m5Mn6+Dw5Czn3vgiHAiPw
	O50FoZo77NcYMJIRt52DiS2+Q/8+hRjsaAfnMCVtWU/COOZaaZV0E+h6I
X-Received: by 2002:a0c:fb45:0:b0:88a:529a:a530 with SMTP id 6a1803df08f44-88d82041773mr328948006d6.23.1766784420887;
        Fri, 26 Dec 2025 13:27:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfZAYYIQ2fUbZyPMB45iQArY9ihsQ/fJKmBvKtaCb5+ZXeC6tWw3vCNx5szpnr8D6LkXzAiQ==
X-Received: by 2002:a0c:fb45:0:b0:88a:529a:a530 with SMTP id 6a1803df08f44-88d82041773mr328947536d6.23.1766784420468;
        Fri, 26 Dec 2025 13:27:00 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d9aa3ac8fsm175993226d6.56.2025.12.26.13.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 13:26:59 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <bc573163-c5a8-4bb9-a280-45ca48431999@redhat.com>
Date: Fri, 26 Dec 2025 16:26:55 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/33] sched/isolation: Remove HK_TYPE_TICK test from
 cpu_is_isolated()
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
 <20251224134520.33231-23-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-23-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4Y2RNHU6P_wXSs7uyrzLdCOh8sDNytUjMYo9A_iXulI_1766784421
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B89040005
X-Stat-Signature: z8s9anrc4dboyh5brejmraqqoc594icw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766784422-103440
X-HE-Meta: U2FsdGVkX19t5/kPfFJO2W4psNL6lhKrv2O/SqO8IowLq0REEAOWu4IgdGfnbqRjQGw6A+4G3ccf2b9Y+p6CGhkhbJVWmRSnDvaNT0hA8/tVlwTF2AWIY4dGMhNXcVOpqEZOr1fT41WPEEltiLAfQN6U+da/xaZTjO9AE14DWIuPLbj934DtIXUaGwe1iZ46CnnH4M8P8+E05uEiPF2slsAVpESSwi0isxHNKmr5pxqFHZYFj3TMZptOVMHCZc3yAYluzNIlAkLEpSZKiROGuv0LI7QIdZs5E4VcvfYcJRAD20vfgbDD3a6m6i/F0GETNxYG3hcWzJs3CMHBlfB2nUWSwklMP0EqGdXeT9E0dJrG+JkXxn0BfXhX3SFFzm5rVMbl1WW70VJ14LPgNV0qwC8zVFWhgYX+ierYHVgLmrdfE2CELrP3VbCyFx+72JoBiHxC5hBOVLPIKXFv/JcVzxT+qQMVVQK/0qiLtAQgwo/HraQhzIOtnuiQQX5voUBpew0v1O0+eo/eAb1QuK2qGc6eLomw1JbPwh4R4gBq2tw1SOzCkM94on5QEkySdlnxt1povBVld63yOn5dwQfTmF2fi0dXj7YMlPMZecvlq0UGRzxcOrCwaXOu9xOQHQll92esn08uogwfGCbNo2Xn9qTQfpxLUIgnMhz+tnatW0WOofCr2tJE0TkH2AhLzYTtcBSEyjM0pLZKSntB1Xijc+7MQ1P+RXfw8Ykm3EivwUJEqPy8J3aC2soI4E4WGX44pXqdwmxB+HwUt8b59bkIcl2Z9ppYVhPnnxrVSTdq9wfNi4HydFFhY6V41NvoOnIW3mrvpwfGGb6t6Yygb1yBENFhsE5sZVqSfK+H2cZLX/1VK8Ko8az+bA0mrxgKvPmPYXyTFjN0jn3nbJfh1QWO9BgJW6XrLt8gS5IBJbDFQHyMs7bz2wBydIW10s23Q5S+b3vNiV1lAm6JhcHqa1m
 sbYh33g4
 QRW8qPD5zZ04Wjk9q5cC5zJO3/mpYcmj0yUVoHiW8lRHUVWxCa5/E/LDikfas/sl6NHhtxNcCYQE4epikv0+VZe1axpgtqWn9LCVny/vPrOo7D/KBBK/ZziwB0XqpN+jaYOIyWVecU4Xfvj9g/AxzfA6OEFdq1JlODU//DHLr7+foobIVeMKqGrbeAQa3nidM01gzF4lhuawvPvegqKdQfja2MzRGlNTDw1xQzgsTf4nT1KU+/pIzhPUaWn0hyjiMKUOiVhRyJX2qHDjG2YwkTT/rkCcuuns9IJ5NIUTxJFunOSkgWn7RfzZLxAVfhMWBPhaHYRakAQSgYR+vY6uMqc9LqrwLX0Min1W+gcVrETjfuNaAUbQgJSRuJa4kPpJfA74Qa2O+CUh3QB5eBfHGgrQ3dIJkeZDDAfxscno8G4bF2fC7JJaEPgnysQUs78tBjh3V9+eM8I4GkwfPkdsbjl9+4DnZbPQbwWEoyBSgC3MrBoY3XZlN3nNCgqyGBs9O7LSb6SniZt1UyJVX3Z+rPw5fZoRUVlR4U2yR4XrDFjAjHGUOVJp8jdTvj3YX86HCa06asjEHZPEM1ok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> It doesn't make sense to use nohz_full without also isolating the
> related CPUs from the domain topology, either through the use of
> isolcpus= or cpuset isolated partitions.
>
> And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.
>
> This means that HK_TYPE_KERNEL_NOISE (of which HK_TYPE_TICK is only an
> alias) should always be a subset of HK_TYPE_DOMAIN.
>
> Therefore if a CPU is not HK_TYPE_DOMAIN, it shouldn't be
> HK_TYPE_KERNEL_NOISE either. Testing the former is then enough.
>
> Simplify cpu_is_isolated() accordingly.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/sched/isolation.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 19905adbb705..cbb1d30f699a 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -82,8 +82,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
>   
>   static inline bool cpu_is_isolated(int cpu)
>   {
> -	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> -	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
> +	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
>   }
>   
>   #endif /* _LINUX_SCHED_ISOLATION_H */
Acked-by: Waiman Long <longman@redhat.com>


