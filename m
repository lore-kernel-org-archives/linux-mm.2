Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA28CE8FDB8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 23:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38DA6B0005; Fri, 26 Dec 2025 18:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6A66B0089; Fri, 26 Dec 2025 18:08:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F4E6B008A; Fri, 26 Dec 2025 18:08:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79CB06B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:08:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EAA11A076A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:08:57 +0000 (UTC)
X-FDA: 84263164314.21.17BEBF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D32316000C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:08:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N5ULQChj;
	spf=pass (imf08.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766790534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPVYyOhmWYyUzd26KqEqEx9SiJ2wqcstK13CbukMaus=;
	b=aMq5RC2kgSDkEMLpzS2iuETbTGkV9dHJVcWtHWIfJlhTk7erpf0zCR6I0Y4TZ0gs8JelYc
	7D3uD6IT92lJS9oSYYAS1DU3OBTItFlETHjPYLSTA2qDw/zSikv01hVOBHN5jtOVeuxeaE
	4RUK+mfOPSxY4xK/BpA1SiZscepOd9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766790534; a=rsa-sha256;
	cv=none;
	b=fw+1OEllXtT+SnghWk7z/MZ2lafK/8p7wgTrH4Bv3PG+lZuHi3c9/eH0w/K1YXXNkHuXs/
	c+gKk2h0/QA5wuhuwOJJsgWLOdQXATlPu5+yjQH48lZPVrQGTZ+JCSESK9c5HcPTfi0FkB
	sQQxrnZ23h7Ac2wfZ+KnJaCa3EkTHL4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N5ULQChj;
	spf=pass (imf08.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766790533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPVYyOhmWYyUzd26KqEqEx9SiJ2wqcstK13CbukMaus=;
	b=N5ULQChj3waHbp5JqOilPGouwqSvFnriOeVsIcIceHVuRNFf+tQ3+oRsuiOqgBXlJ//H94
	vAKxXsupdXBy363SM/u6u7X9NWKbGjvZozmeJjg3GksuMzqVFkFx130Oz0j/ViDgIlTSdx
	PNe3kVV9U2QuHVm3T1ndtjdTyNW8Dqw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-mFEjFD1nN423GWYgXB_ztw-1; Fri, 26 Dec 2025 18:08:52 -0500
X-MC-Unique: mFEjFD1nN423GWYgXB_ztw-1
X-Mimecast-MFC-AGG-ID: mFEjFD1nN423GWYgXB_ztw_1766790532
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-888825e6423so172575976d6.3
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766790532; x=1767395332;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hPVYyOhmWYyUzd26KqEqEx9SiJ2wqcstK13CbukMaus=;
        b=wjRyp1qegcjc7zdsNOV8NZe58JAdq8paPTY74ZFSaZjNz7d2GFBV21I4bYVaYXTCmt
         pG5FR8C1lcf8fSUtkSVTEZBu1VEg3QYY9n1zye56apSGaAR0wTCYEFbdzDXYh9Sv+tQy
         p2AH0F6164PCcUuJfsOX9lx8Gp93VMR3sCcBVevNXj8kTzHZkmE71D+Vm9uGXivSK3+v
         FysXGKJ6z0sZqEXPAzx8I4oXJF4luIlwIxQbWDcAkJyz+u+DS11y1UUcQHmH9ork6hlF
         q09ZElXHFzg2cbDUJ7tkrRfUww4HzODQwMkJ/FVi4WhtUNv2VLxFH7eNRL6WLfylBwES
         IFfA==
X-Forwarded-Encrypted: i=1; AJvYcCUJkmnxzLiHzlZgUSISnEoRDxwb7KpTvCoxwadkHU6gZolHJ55Gtdu4quISzeA0zJnvjLLUsM4cew==@kvack.org
X-Gm-Message-State: AOJu0YxKq/IQOJ1lZBDDApJyE5beXWRwVuqMy/f+PNkD9HuVkcs9miAf
	W2073vOmLcRcz1K7JmiG35p3/MME3EeM5rYJyayZd8ZTRz3eNTFpxpCxLVFSmjtNqqcgqK12SDI
	+hecIYcRpzUWWcKMoJ+N/bKZueFWdPM6pZkx8KCFHC0gUiD2F9asM
X-Gm-Gg: AY/fxX7/qaHmSwE5RRJKbVw1B3/KHySAxfUYlWICRLvx+PjFTxHMRNIPXcRN5nFpHvR
	MI8HkPO1E1HuO9VUfL+hmOMQ6Gb8yuUJAFmra/GfkVXLXIgraHYE2QT2JyednIivB9MLzN1E6zo
	HQxbxx/MHljTO0ALPa6YWHtTZbIHIizIwi3Vr4v3JIFsr0wCCiIcgKpC8l83zgFGKYjvLsjJzl1
	iYFNdbOSp1DMdXNPoWPCywTnkG7r1jqcxvYHMQJVxHj9SOCN9I9XwkUUKORgoXX863j0ri61DeT
	li3T/05aGXBvTlyMRTGoEKTRZVedc3ECUTzgg61tKxXGy62mDjgseMic59kj8pKD1mYOv4FyTtx
	I7FPBJGMrfvHRiqy4CVPPZ2KjVBjVzz2q3LDa9hpmPaRNz6kOSuDKwTop
X-Received: by 2002:a05:6214:48b:b0:890:e31:9685 with SMTP id 6a1803df08f44-8900e319a28mr37823646d6.69.1766790532041;
        Fri, 26 Dec 2025 15:08:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpv55vF+vDJeT6imxDEvVCM6zgRYx4B3T4/k2S1vjNooJ5kJOtFWemCi2nC+rcnjO9pXNW8Q==
X-Received: by 2002:a05:6214:48b:b0:890:e31:9685 with SMTP id 6a1803df08f44-8900e319a28mr37823076d6.69.1766790531561;
        Fri, 26 Dec 2025 15:08:51 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d99d7dc1esm173664886d6.39.2025.12.26.15.08.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 15:08:50 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <2f892ef9-1965-486d-beab-eacf0b6b0386@redhat.com>
Date: Fri, 26 Dec 2025 18:08:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 28/33] sched: Switch the fallback task allowed cpumask to
 HK_TYPE_DOMAIN
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
 <20251224134520.33231-29-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-29-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: O-NQt2QVK9LAmfIh1f-WkWUQlXgJ1W0Lx-vHtBcNXeU_1766790532
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fqz67ayphtdesu7pnf6xawdwcg8fgtas
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D32316000C
X-Rspam-User: 
X-HE-Tag: 1766790534-409914
X-HE-Meta: U2FsdGVkX197qCCk9n26Wk2byGEMQXZJ+bIWGGtUYe/LxOuw72DYI7fZUW74SJk7nO3D2P2Gdqx7CsHGARc1BWZnNjZgrnzZt7iy2+hUNBl0obeqc+SJGlFL0FFGLAe+JLcEESqNkkuwMDQ31RgU36Q/HpHCsM4mpLKgPzO3QBNh5+ekAd8mMDZldZzKAWkbbdeEb5o58yw2FGmrfXhJ1xQiVcWpgc4EVU4Z0f6SvhPvBVWWeuH8jJmvleqTMVnysqV4T0uzIY6R2Edi0HiBvVWmHCyUQNI3J0aSFa1wo3femJdarQw09K2ad6n+Zu6peL1j5WNK6TFdJzh1ZdmDzxiV+/zcnUC7NAE6ZV1zPp8M3qdYagz3VeQs50FlI8Yu/AMR7bI/uGVTOH4NVw5SC7e3mFkohSaqdxJnHFsFGRXOr9675EXkZbgbiCQ4c2pffrjgGG708qA9B1+qa0eKuYzICWpdyFYRaafF4UtWo29mUDc3XUuuWca8oRaPj0Sbq7mrj5ptpoDXePWB+mWAvkB94qCzSSIk6XQ3PTlAnB+hB0xeX+r0PcoQH73KCNFfHFNuZiOb/IyVK6yKIhTSyaNESy7Lw8LvkOSk6ow85e+gk9h/VFTRq3jSf/3EDsI74DvKT/VVerhIxG9DF1jtLPPE+e0udMbYFEqLZ7u7EZHaFLmFXluRwKkG/GyTZb2aV9OuOozS9Qy27NSoBtmzPHj82F68RXLTStfK0PlJTZFnH7xOhzSU6uXMVRXro2aXe6THVMEF5v4O/xejCpTDtdtBO7vAaDD3ZJekKmu0dbqz6NFTsHbgqAm6oHwy8c9fggRwwAaGxmAhlifxGd/gkBL3LQitB7J2696AYyS4XbXo0R0E2MWG+4R+10wITrRBqm4tFsLhGW4mV0MTPDELByHNkvZG0wzZDpNwelLEYCqfrgTD68gE90QgJfiQx9vdIawnp1/TXr449Gujgkb
 LHgMVihe
 6Up4jxN+OlC2f39QW226ekraXQQ1Jus5OJMyJ1ILAdtnJOfIgcRmbXvt6w1BFSMBXNd0AzUmPfqqHgu02qaeYUrXkIQH5A5ACW7EM5/nDCZvnfK1zdNs3chbt61iVNWnbpaBFjLg9sI+QpaZPNgUsDtyhWUeudzlFf+IeHuO4VGAX1+cRVtGar3Rmpm2OAJf05vPg6jGI1wmOM1Ez3Y4RFpIXFTzXNaRGrr+gvQ4o7DTSwSgoiGWhrBA30CDcF4z9u6Cb+HJW1ymwzZ/rtMiLxL9QF3h5Ep+9WuEhBDdy+gfmAfpOIL+eVV6AoiCUJn5ipuKRGLeoGOPcDn9mkRSFdYHPA6KARedn++FDmc5XWate0BH+oJuL80UHPcjNG+BnaPC6gVzeaIe/53D/K8KNH6gdy9PJZXEakFUBMQUsO+HBrNgcAsL0RMFyo80uo64kiz4GXjmhXQtdDGj0G4u1Agp8g0FiQgJz7oqfG6DNZ8+kZKmKaX7Adh3FSHVn+pBZziSveVoaD4lEKaksWKNBnE7HDoyF+vJfG6EYRx9AXP3ZWLO4FgyULdrAsqoN084bpb2GazJgWCoVC5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Tasks that have all their allowed CPUs offline don't want their affinity
> to fallback on either nohz_full CPUs or on domain isolated CPUs. And
> since nohz_full implies domain isolation, checking the latter is enough
> to verify both.
>
> Therefore exclude domain isolation from fallback task affinity.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/mmu_context.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
> index ac01dc4eb2ce..ed3dd0f3fe19 100644
> --- a/include/linux/mmu_context.h
> +++ b/include/linux/mmu_context.h
> @@ -24,7 +24,7 @@ static inline void leave_mm(void) { }
>   #ifndef task_cpu_possible_mask
>   # define task_cpu_possible_mask(p)	cpu_possible_mask
>   # define task_cpu_possible(cpu, p)	true
> -# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_TICK)
> +# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_DOMAIN)
>   #else
>   # define task_cpu_possible(cpu, p)	cpumask_test_cpu((cpu), task_cpu_possible_mask(p))
>   #endif
Acked-by: Waiman Long <longman@redhat.com>


