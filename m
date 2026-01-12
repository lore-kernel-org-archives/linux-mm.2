Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9275AD25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 02:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5B16B0088; Sun, 11 Jan 2026 21:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93DE6B0089; Sun, 11 Jan 2026 21:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974CF6B008A; Sun, 11 Jan 2026 21:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80F406B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:45:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C09139170D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:45:57 +0000 (UTC)
X-FDA: 84321771954.29.62ABCC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31BA6180005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:45:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RIHtvEL6;
	spf=pass (imf06.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768185955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcS5shRmDCmvz+IoTKqWTzUo+o6AAuc9PAErT+qJLAs=;
	b=MuYlYakOIl/vWshgZD8XnrsDgIa2dcfy/gN2ZWHsdO0mW8gf0HxmxcU9zDQuVDZklGDG9S
	MYR0oQy+wZm+3hR7debIGbxIGK6Xc93tFEEPJmbxAMBV0RCtrYqiIcyJp/LVMM6nLFhR0m
	GTtryMZl5QbXBhuSFLHidg36P+GAvQM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RIHtvEL6;
	spf=pass (imf06.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768185955; a=rsa-sha256;
	cv=none;
	b=X+Bdma9XIs37iE8zwM65XMXRmHNwl3EDnHiU6ioeVid43lSo2wWTE7r/7ivNQcprBtZd/F
	UxHhCOutM3fdXlplEn0aq2Tdk7I8tVKtNC0RcahTR1LRjEwqnJNtTnc0GXjQeUD9a3Sv/w
	Q0fRR5/odcStxtpI9coRkzAnIdUf+dM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768185954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcS5shRmDCmvz+IoTKqWTzUo+o6AAuc9PAErT+qJLAs=;
	b=RIHtvEL6WNI17SXaRSRMorIVqYMrxh0ySwzskBkEaln1u8krV+tG1S/A7Lr5TCnZ/xmPyZ
	KtKNrpQmrQ45jIQpgu6HJ7A1kYnPaFHjPmwVj/b5VXojhbjSh2ImKwg3YSG+yXekkmAAns
	oUF53XL9SgyNuCR2Z2VN4mMm5KjFmL8=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-2YTmM435MPK7ulULh4zOQg-1; Sun, 11 Jan 2026 21:45:53 -0500
X-MC-Unique: 2YTmM435MPK7ulULh4zOQg-1
X-Mimecast-MFC-AGG-ID: 2YTmM435MPK7ulULh4zOQg_1768185953
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5635063cc48so3698937e0c.0
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:45:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768185953; x=1768790753;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcS5shRmDCmvz+IoTKqWTzUo+o6AAuc9PAErT+qJLAs=;
        b=afkbBdPsShSJFG/oWEl4VEe6lQeaoM0UQR1pgoxrM/hE5+npLep3eggpptUg90uL+8
         x87IQxka4TkUzoYHi6e+Q8TEM3msAukgUijaPyS+0mpY6EkgS6ZGrizsy+Yinx8aNofj
         eRI3cT+7IbQsqIQeowzgc9FGT6peq0/MwCnQt4bR/buJNsZEctpJwHKivI66N1UOoCZk
         PEha8weT2CB7wUxLQyL7iCiED+ngkQQ8LbRag7ij7Yg9CgtidsdCI3VD15V71kCSErxS
         PRb+ZA30wBjWYSKKnPE2ZE/iFG6kvOiwtnXZL4kQLUTSsfqCYDhJm6B31OE/Pcmq2PoL
         CQ/g==
X-Forwarded-Encrypted: i=1; AJvYcCXyKkO9EPu1CrWdgFvP3kLhkYINhXNUwl9g/Re05YmCdYZWESWD3AaDmJO4cIDOYRic8BPpBxpehA==@kvack.org
X-Gm-Message-State: AOJu0Yz/IuFlVKymIa1Iix8Mox4366iiK3Jkjyi6+Ok/PpCxuSAkNVGp
	CcnRccHlqhg8aJM49KPTPYjXVbAvYnbs7NYxo5KHGNuEN0/wAiUIJ7isbswYh5+fkTPwcyMMdlv
	QfDvWE7ygueQkjpXbJdQaATU82UV9prQP/3Vqeog4eudDB3G9sAAt
X-Gm-Gg: AY/fxX7ra49pqCK/HhjhpS6AlWX7ChLPFmtLnEWKvlWB37bBiAFo3hnzLgQA/ETsU6m
	FTJYu6eCP+x9MhX+EGvACe+Mf8RDLOI+/yH1yHBmL6s2Z2CYkWGQoSC/tE7y+C6cuYTq8Lsh/47
	oirNDbJ4LZ+Zp1MERrYpt1vEca3iyu01yVIZZ1mcl9fJDCgTLCJZTdKb0P299JzQnvZzdk2hxf0
	SXinbJFxNmkXv1wXpjKJAJkF4VqOE7UZ9y7nEGX9wyxgAYnplxOMFKyENIWdiUq5yUrLHeKKPCp
	mwJdjfGKJNayDBZD9MyhYfFXu14cKnpqVxaeXocBDB4gpn0iathdS35F9Og6cv/+uVhD5MeBSnB
	w/M+1N1ZKzvlIhabmRbu3Hmz8XNIFSp/9mhgpY5eaxsXnlJaa/9CG5jkw
X-Received: by 2002:a05:6122:1d4d:b0:55b:1a1b:3273 with SMTP id 71dfb90a1353d-56347d4a0bemr5054207e0c.6.1768185952713;
        Sun, 11 Jan 2026 18:45:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwOFp6cPvfkUcSbRWdkrghqM2mUWR9n3I0P3Nk8PJy6T841SLsur+1hpT47PiYyZ5sXMn8AA==
X-Received: by 2002:a05:6122:1d4d:b0:55b:1a1b:3273 with SMTP id 71dfb90a1353d-56347d4a0bemr5054194e0c.6.1768185952291;
        Sun, 11 Jan 2026 18:45:52 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-563667cf148sm8166160e0c.2.2026.01.11.18.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 18:45:51 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <18ee9089-8a08-44ed-8761-7c9db765cd4e@redhat.com>
Date: Sun, 11 Jan 2026 21:45:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
To: Simon Horman <horms@kernel.org>, Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
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
 Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-14-frederic@kernel.org>
 <20260107115653.GA196631@kernel.org>
In-Reply-To: <20260107115653.GA196631@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JM56KB65Oh3Ys7RSTdTQlU5vt8_7iQAgojwAFP7JMQo_1768185953
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yf5x69razxikqizurpydooqyy7jb79qy
X-Rspamd-Queue-Id: 31BA6180005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768185955-96566
X-HE-Meta: U2FsdGVkX1/efRIUGMn8KfVzAUUxW13ZYGPwLf5crqzcSS5PlZSIAIR3FCbmHC8tIKnaSj8bLVZaU5uAteGIuAW/2pHXg7T6zR/VjzhJBmjc3YDjuk2ygTxAwshPY4xRS/tGwyDYpjoG/i5KAVu8ahahGopzFvHQglYsxvBRZqU4F5Yr0BHklUulnVUvrh9p/JITsGMba+VO8c3vbvSIEW37DXctIZelS0DY1BiMhXqhvUxH79Q5iQmGAk0x6h+n2WPA0R1gtZ5qBX/1y+bvmdDwML0jGeikIr1n4QaSbNZ3W5IIW1W+5NmH1MoUGPxVJSkelBCYSBSBcmPWWMQlDgpkGRVjpyKN2EAp8mbFKlCtIOL59N/5WXhDq6wjcRjbuYO7wtUEvvwNC0WXIRQf/DlQihiX2Z1e2Qtqg9qIxtmBsful4VSD35asQonRkdGs0zMFYGQqQ7tiBT0bzLvGcADNUj1chcaydBidmDyHGXLTZmPAw4YVo/F3fH2cOx7t+nD92ZfaBzQSTh1Ld0zJql5IavDaeGUgPUXq79j79ni53VCRkWNKHVQ37kHZ+/ZpNN98F83ZsorWbMP7u9JdR6PM4FHutwaYjnndLzFDOFQA2HdNrnZ9vvRz/WhOEFv8ba0Fr5ZaRA4hUULClE19FZhLCiHiQTwKmFycQpYU9afVXks+7bD90mpjPx1q/MyPxByFEjYXpfxhJkFh15A2TQZAVLTEL7nLZyU76uti7+8qNrXcjliPY5jH3PyTWd1Kx1WTnRQ/K/axHpW00VeM3i8XZq4tv2la41UOZXpERJs692YgjoecgGCtyPZd4K/ZSv67SBgJFb+NkVcgJByDNlIcDT9G2bCIVci+gbGDKWxWmcUDgTdxFEE6vVeqAio8XdV7tt48F3gp1hhWXDB5qsS9TgpyNFh68kVJKuXUCIZpGNGkJKBXFsm3tUiBewyM6QZpq3da3ySR8awAblH
 ZSUnh3GR
 s4oacgyHyZfNSgjq83+zJSETot3e9nmuGEaFrJvivE6JT3OY9DssazA97g7bePCEMzDudiuFVAEIlKqObuBuAPq17VeghrU+aDAB1VzQBXTVrTmb/9dPLI9neVRbEFr0qJoTqBdvuFYSByP8zXAyKV/qjWymhf2KCYSMGjSLjEAvqlDp1AmCHfLX8dSCfyntAJv4vCc1Xl7r7rIYJfT3/l8t6ZehsTzC/GgriOQHyIj6BiUwTfiJqDdZ3+KxUbJwRnQ6DalstwRea+0JHxBQqRfrv1AsJm2uEgCw8hdFi0wh5kPNGIy7zMsltQP7YeKEDRBgDfryNm6CHY1btmEHj6e8bK8M9s26zmSrN55Cqd7y05I1fkHqKEEmNxOh16hWc/WdHIviSQ+SzEsr5aEoCC37Td5TOeH62Xh0+pDjJ5KvE1tZbfBwFM7wFkpimpvhR2defz7LkWhYrrdeVhslGAVkJvGYFzF4FErT6MmbwPyZ2ovCggV6+uduSxVoH6Xc5Xr2BLaQuN9CWynO0W8jbnv4Byg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 6:56 AM, Simon Horman wrote:
> On Thu, Jan 01, 2026 at 11:13:38PM +0100, Frederic Weisbecker wrote:
>> HK_TYPE_DOMAIN's cpumask will soon be made modifiable by cpuset.
>> A synchronization mechanism is then needed to synchronize the updates
>> with the housekeeping cpumask readers.
>>
>> Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
>> cpumask will be modified, the update side will wait for an RCU grace
>> period and propagate the change to interested subsystem when deemed
>> necessary.
>>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>   kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
>>   kernel/sched/sched.h     |  1 +
>>   2 files changed, 37 insertions(+), 22 deletions(-)
>>
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 11a623fa6320..83be49ec2b06 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>>   
>>   struct housekeeping {
>> -	cpumask_var_t cpumasks[HK_TYPE_MAX];
>> +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
>>   	unsigned long flags;
>>   };
>>   
>> @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>>   
>> +const struct cpumask *housekeeping_cpumask(enum hk_type type)
>> +{
>> +	if (static_branch_unlikely(&housekeeping_overridden)) {
>> +		if (housekeeping.flags & BIT(type)) {
>> +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
>> +		}
>> +	}
>> +	return cpu_possible_mask;
>> +}
>> +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
>> +
> Hi Frederic,
>
> I think this patch should also update the access to housekeeping.cpumasks
> in housekeeping_setup(), on line 200, to use housekeeping_cpumask().
>
> As is, sparse flags __rcu a annotation miss match there.
>
>    kernel/sched/isolation.c:200:80: warning: incorrect type in argument 3 (different address spaces)
>    kernel/sched/isolation.c:200:80:    expected struct cpumask const *srcp3
>    kernel/sched/isolation.c:200:80:    got struct cpumask [noderef] __rcu *
>
> ...
>
The direct housekeeping.cpumasks[type] reference is in the newly merged 
check after Federic's initial patch series.

                 iter_flags = housekeeping.flags & (HK_FLAG_KERNEL_NOISE 
| HK_FLAG_DOMAIN);
                 type = find_first_bit(&iter_flags, HK_TYPE_MAX);
                 /*
                  * Pass the check if none of these flags were 
previously set or
                  * are not in the current selection.
                  */
                 iter_flags = flags & (HK_FLAG_KERNEL_NOISE | 
HK_FLAG_DOMAIN);
                 first_cpu = (type == HK_TYPE_MAX || !iter_flags) ? 0 :
cpumask_first_and_and(cpu_present_mask,
                                     housekeeping_staging, 
housekeeping.cpumasks[type]);

Maybe that is why it is missed.

Cheers,
Longman


