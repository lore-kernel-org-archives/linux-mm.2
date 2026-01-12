Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99243CF45BD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA036B0005; Mon, 12 Jan 2026 12:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57966B0088; Mon, 12 Jan 2026 12:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D396B6B0089; Mon, 12 Jan 2026 12:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD7116B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:54:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B8C85BA6F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:54:10 +0000 (UTC)
X-FDA: 84324060660.02.D433A45
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2EF4180004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:54:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UT+GrsaV;
	spf=pass (imf16.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768240448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TjQuHk6AbSuF3wU6pHO95OUHC0x3l8Lsr+qaj6DcQU=;
	b=pU+blw913g2bdQAGoTo4fyJZqzhNq4L3V+JjP5VxT/8yEyXfmYI/T9lCWnOAfBTTF64rQH
	vXmRIMI1DjxzB9Qfb0ba3Y3tseSUM3S6jcfe303Nmn8RG5/MtCdLPrB5xFUfO523Ssc70y
	cfBmrTa1SYV+OJalYXS7nZex2m9gYW8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UT+GrsaV;
	spf=pass (imf16.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768240448; a=rsa-sha256;
	cv=none;
	b=X6I4klT4HH/Nphrt8qEH+oYYo9RAyguRPev011gzJSBeUJs2Kp3WNAPKDO1C8IZ/xcQLSC
	X5QmNQ+NWmjqsnA521TlXzJT2OhIbCZe14UQ7P+WeP2V3CUyuSH95ZH479j2C0Jr+OMw88
	kQzjVc/EMNkFK5yFADKGxjFQA2Cn5EI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768240447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9TjQuHk6AbSuF3wU6pHO95OUHC0x3l8Lsr+qaj6DcQU=;
	b=UT+GrsaVKKGYw2mDPmf6/Q1PFpQKUeE+e+g+3JU8Yi1VbR1tg53QrXHaVoFN4x2jVr2Xy6
	08ITeB4JdRSzOd6af2E1EZBrQNq6jhNQQOpBdBko5jT0GJLPijWPfwbZY5lo3lIBnGMU9K
	/8ClP6bdNLEU6TEa+C9//Qk7wTsbrNI=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-f3DiJHg8PruLhxwgzLOUkA-1; Mon, 12 Jan 2026 12:54:06 -0500
X-MC-Unique: f3DiJHg8PruLhxwgzLOUkA-1
X-Mimecast-MFC-AGG-ID: f3DiJHg8PruLhxwgzLOUkA_1768240444
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5637ace7ed8so5169408e0c.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:54:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768240444; x=1768845244;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TjQuHk6AbSuF3wU6pHO95OUHC0x3l8Lsr+qaj6DcQU=;
        b=v2+Q7cKhtFPXveLIjrDW0w0jOj/GxUANoQbNbCdM5YF1pWKeDbb2YWAjyOYwwDqiu6
         XoDIGnuOI0q3QX3yB2PFnB7d+PfIuq6NNRFrbFT8Lh7jU9vADwrntItSG3TXWmTMD1PV
         oZgbPs5UdjzV1OpwbrbDN7QiqDOl6R0N7E8NyLndGCxB/abGq+amKIqcGlpGlaGd+txU
         zVZJdmiMyL3UGbUJXFFC9CYW2GifhXMTDO2+a0O5VDvNGXWamTEldnQEiEKxzLptpEv6
         mvpcfVKwgIGBiAS96lmjtaddFd77ydozHF4s5YXuoWOUZE+9jMiFVND6vtD1x7ilxbR5
         rDAg==
X-Forwarded-Encrypted: i=1; AJvYcCX9WcVrRweP6//xemHvPR0G7ql3jE8Cm1M+f8slIwI5yrhZxbifo9Ghx1jD8s/67WFX+u3kDUeZoA==@kvack.org
X-Gm-Message-State: AOJu0YzUj8/Qb5w9wUAqaRH++h9/fiMPegAUHsfnChsZwLHWiIbwPqkU
	f6D4LirHXtq04KC49qqldSGlyYwds4IMSCZ4GqFRH7Al/XskLfVXgMHF0EJNazGJaj3G5aInzi6
	hzihTQYU2teZ/kUlV1x9izme14ln/yfiFgRtmx4k3+NVza7gnhDAc
X-Gm-Gg: AY/fxX5HVivTOSGelOmv5PiYW/QgUhmPEG+yXVvGE0N3CJ3xMls0J2dLASgy7Ot3EdY
	qAq8I8h5K8j7UcJdFJ+Kfl3IzUbvYSyGKir7CLAUULo/6ieIKZpcYUpw6QPVZTEeo2tbQbT/mVz
	OKYon4AjMW0qxsemLtmGMc/yjkfdqWQzTaBcgE3g+FtFFYdw/ac66odkeAjb+3c2zka8kkb/V7E
	3MOnICLeVXKwfPWqomM+WypmDoogLd7ueqpUkD801G2ZPJqnPgc4wFy6WFyO+VBv0mQfF3asR8n
	5aBTumahKjqj3w8p6q83pYbd41gLgEob13MR41Br6Sg+OjNBZZs3wivjA7P12FM2JtLrabw8RIF
	doBVEZZFInBVDsMWEx59/kG0/OVcqKgoiWz3uTwfu1kYWWhY5dIfha0J1
X-Received: by 2002:a05:6122:4f88:b0:563:8335:9ab7 with SMTP id 71dfb90a1353d-5638335b3d9mr1837535e0c.19.1768240444537;
        Mon, 12 Jan 2026 09:54:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxwLoMJ4ylgMx4yokJUFTrQvglGoUK2cQ8cuwE9wOBcOJlyALmmG0hMGzOjgHwYtiz9Ob2mA==
X-Received: by 2002:a05:6122:4f88:b0:563:8335:9ab7 with SMTP id 71dfb90a1353d-5638335b3d9mr1837491e0c.19.1768240444039;
        Mon, 12 Jan 2026 09:54:04 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5634ca16da7sm15469803e0c.17.2026.01.12.09.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 09:54:03 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <f8ca375e-9051-4c7c-880d-e56e07206788@redhat.com>
Date: Mon, 12 Jan 2026 12:53:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/33] cpuset: Provide lockdep check for cpuset lock held
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
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-13-frederic@kernel.org>
 <e97d96fc-cbdf-4c03-aa1a-b0cde5419681@redhat.com>
In-Reply-To: <e97d96fc-cbdf-4c03-aa1a-b0cde5419681@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: suNdEeehnHo5BjeFgbvlaaN5hk9-l1kZv4otirOIxLA_1768240444
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2EF4180004
X-Stat-Signature: gqif4rudrmo3zzbiybscwrfruawuu3fp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768240447-855644
X-HE-Meta: U2FsdGVkX19tvPym7PB8WFDsTiI0bnyJczPIeFSpuDCzw2nXIXHS+DNYhmnWdMYxixipEUBPftXPkCzcR+HeDsWVaSHbYRIrX+jwXMvTGURedXM3G8M3ni5OWJJpNF3OnWhh6opsMAzPn9I3LO3PmF2VPkroCF6BBU/M/xZPYQMtzuDVvfN1PLH7PFxRMfDPxOLMg1dQL/bRxVxDCdu33Iy852lFThTRy+1D41xmhwToViNGfQ8y8PWVWv2m3sIei4GEx6tvTnTS83UnX1Vq4SmdGAROKLcElDQtX+sxqDrQq6xuMxQKi0iYuu2SFY15K6KgKGbEoiRVQ+F5mbnR0MxrqL4SvBHGoct0zSDaLT2ZBDD2Aob1HwdF5PrMu4zUT1G3Qwbj1CdjMfJ2e2cXONlmFyjs7puMZbKkYvHLLfU6wLtg9BjIS70YCn/pLd6E3zi5u8HR/hfws0z6Bae7+GyNxCVv54WVuA/oMG0lxcRS2OVYec7Do7sCpf9xuSHuYPlF61xgYAdpigW+xWsGyZfBSmhilIgtpQ2AEgYf/h+rpxHvr9gtQKEYBIjLZ7aE2tLAcMsjHbuPqgPeKfrWwyOOtgqa3XSHIZg8k3aYef5u4nkB7GCAhiRwO2ca4j+ZHz4DvbzPq269jjEKqwKx2FlZebUUXnMRisivLST7dgDF8GpmG4nWbYfmcxjgg5mdI8ZpsvfjO1bdyisX3fZLhjV2FpBNj7GKOXQHZaxpSEXbqSMzjJ1iV+AiRwta8uxU005k7xsNqDicEdHYfW0M04zj1FcH90KsBopc9j9Ly5AiQce6nOHIfI2GoOgLS4sbMRuI3CHrzjQ6wIT7gMS2zAp46EaOmZMqANkActtRvuj5Z58hUFsga3ar/RYgRS4gI2tUaCYlOc7Xr0zCN7dN28xKUmekSJ3uIX32xu0VAQFXaM7V2UVHeIglQjW5DeOz8TpHnTV4RWAWcV6HPeg
 rm1jPodi
 +Wdndi+USLVJTkm80IaCvOn8Wmu0DLmDIuzLjVur5fVCCjV09L459amXFC7RUchb+Ga56pCqP/YRt6wIOHZNV85QT4qbHGFFzUSc4KDqW/f57kNYYbtJsDyPYjGiTM8MNnrGRrwLTGImiegKCYKkgSdULAFmXOEGODPdUEo3AQNzOSco0AiWpb4VVVRTzCuxIM/ZjK7gsjv1D9MCKcTIubKRM/WVRtuS4gyBV6FB2iveEY599lDXrAAjO5CwZb3Mma1Kafdrh/gnROii5NCOvcZB6UmuLvWJWhrLeC/j4NjmA/g7MKOmkcFQVLss2CvIMMT5cQF6+DQmhzyfHV6N4wlopvP8wYBIO1rHQ11iftD2NXEiKt5x6pnifidM0CvqApdE9y5TKs47zr8179VpLrjyfLX17OqT92qBhQBIkyllwb/NEQVZ/ZiOYT1/oSqegmmrcd8K/1fPJrmc/7jaxXvIZod1VWhf1QT5iSENgBaYdRWGbdjg7cmltGKjN1TurbM/K+r0sLzlWtm26n9XY76qXkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 8:43 PM, Waiman Long wrote:
> On 1/1/26 5:13 PM, Frederic Weisbecker wrote:
>> cpuset modifies partitions, including isolated, while holding the cpuset
>> mutex.
>>
>> This means that holding the cpuset mutex is safe to synchronize against
>> housekeeping cpumask changes.
>>
>> Provide a lockdep check to validate that.
>>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>   include/linux/cpuset.h | 2 ++
>>   kernel/cgroup/cpuset.c | 7 +++++++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index a98d3330385c..1c49ffd2ca9b 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -18,6 +18,8 @@
>>   #include <linux/mmu_context.h>
>>   #include <linux/jump_label.h>
>>   +extern bool lockdep_is_cpuset_held(void);
>> +
>>   #ifdef CONFIG_CPUSETS
>>     /*
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 3afa72f8d579..5e2e3514c22e 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -283,6 +283,13 @@ void cpuset_full_unlock(void)
>>       cpus_read_unlock();
>>   }
>>   +#ifdef CONFIG_LOCKDEP
>> +bool lockdep_is_cpuset_held(void)
>> +{
>> +    return lockdep_is_held(&cpuset_mutex);
>> +}
>> +#endif
>> +
>>   static DEFINE_SPINLOCK(callback_lock);
>>     void cpuset_callback_lock_irq(void)
>
> The cgroup/for-next tree already have a similar 
> lockdep_assert_cpuset_lock_held() defined. So you can drop this patch 
> if this series won't land in the next merge window. 

Sorry, the other new lockdep API isn't exactly the same as what you 
propose here. So it is not a replacement for your use case. Sorry for 
the noise.

Cheers,
Longman


