Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51428CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4958E014A; Wed, 27 Aug 2025 08:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A818E0147; Wed, 27 Aug 2025 08:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779248E014A; Wed, 27 Aug 2025 08:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60BE28E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:18:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1251BA72B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:18:18 +0000 (UTC)
X-FDA: 83822439876.19.A02B77D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 55C6220015
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:18:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=akX5hxrL;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756297096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8l0wgpCnVzJ3ae7raIbUJYfNE+a8xTvmO0EAk2QD0X8=;
	b=A6iTwKMAGF9zzU7mUK51hwTvgEcnK5SgOTV8hu1ONKXnS0RSHC25WHSY4OfUGRuP4YsRYw
	sR8JwbQMX8coWdnUbiMTa8LPCMSV++DxaNizjfIgtFsmprC+MaLQjjIKJxGdJON2on85gp
	HQt5ir9HtvFEOv3joI59T2MWB8uHPiA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=akX5hxrL;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756297096; a=rsa-sha256;
	cv=none;
	b=ikAmq1kcTaetkCxeLCyOwWVSJeE62ocwR7+8/0dQY9ywrrXgKdtMK88GfvAwWGxNElMpWn
	5pAa2FOfkaKFPlcUKqL6EwoWOti7AXOaH+IXd81B6lIt7pILHUPL7ZZDIDR9yNP4YpH7EG
	M2ZOOQqk44ezJMmaKovWlyIb6tGSWHU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756297095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8l0wgpCnVzJ3ae7raIbUJYfNE+a8xTvmO0EAk2QD0X8=;
	b=akX5hxrLmbKCsHLAIN+mKv3z3f7k/t2aAXC/Kdm3JAqaFYcX7gjYwUJdsIsVgC0PosrY3x
	z2OkLkzMa9sz9WiNhg9Yb6P5dPcv4SwZZ29pO8VRc/AQqM8Ohwn+aQqhcayIHageRIIhwn
	gFZemcj6/cIu2TijlzhVPLFlEOe0OPM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-mr0DJgaAP-is5i-gGP5q6w-1; Wed, 27 Aug 2025 08:18:14 -0400
X-MC-Unique: mr0DJgaAP-is5i-gGP5q6w-1
X-Mimecast-MFC-AGG-ID: mr0DJgaAP-is5i-gGP5q6w_1756297094
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e870324a51so1659750385a.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756297094; x=1756901894;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8l0wgpCnVzJ3ae7raIbUJYfNE+a8xTvmO0EAk2QD0X8=;
        b=ZgjAZmdWy/4rR124fRwhIfCHeI5u5TZfjd7QpapUPtONjBt6ZMyPppjgU75+9qqMxR
         Ku8VGq9+IybnYwoW5QuKdkaki0AYV9JOAFoPvMmowYnid20mOWAMv27nNX5+e+/6j+C+
         wQa6SRv+AnqIxek1YCBBmdlxr9F7mPG24pNwLzqxEOd1Sf1Zc9ld5VLOsC1rTP2y1hCe
         gMWdy+pKv42zBZohP4hbm5tLeJCMQZQMUi8oYGrSgND6KjlG+ooWFKbpBt7MRgJxE5bt
         g2dQUf9IXvCsZ2oiihLdyqQ6kI+vbz7GeSRMBP61A55pPZFZgf+cb3xWshb36n+wRSIh
         PYdA==
X-Forwarded-Encrypted: i=1; AJvYcCX25xi/6/P+97TqILXGTAMQ8Lqa234ctRiVUV8ZDZ0bomP7FPBXxukMesJshXCm1YnS0p3+aMjU4A==@kvack.org
X-Gm-Message-State: AOJu0Yxkh0ws0scY+pCsksVn++S93SrPCW8gUScP3soEG4bAyzjR4ZxV
	AJWoPuJsoNsussUsGyKxrqGHf4Buh3aq0AajxhVzOXqCB4leVQ5jcwHYkNFSJsQ6pKNM09cZCmJ
	V6mxJjWMjQDnPaVAw+eNBgYJBY37xnztm4qSuwmPDkjK0iWmx1qxn
X-Gm-Gg: ASbGncsc9zKLzICsMC4eprzNYz1yQ3vPc95R5Hiwmr7TExO5IrhpjkfDMiYV9awPkgB
	0hzsyRpHAwjwUnwdEaCE2NhCbz0zEOjhJLpffDRuCc/a8vXgfEcxJUH8auzQ/SQEO443IOPhGaB
	ysCdHDi41oD6l5mBsYPtGM9sk+wJKdlx84imyJdhiP6aPVOiidEbcW0KpXlAGpYJZWa40L1KSvu
	gbT//VwVt5TslmeTXlNPcrO3zHJfFKIKEKq/ndG7CSJ89PQrWdn0bslkSISrvkaxmD+zGQJa2lJ
	7QB9J3koND0iK90NbMY3c2CnIwp+1MtimRMDOf/YEajemuoXPH+4Hv8ynaUdrg==
X-Received: by 2002:a05:620a:294a:b0:7f1:650:2241 with SMTP id af79cd13be357-7f1066ebf38mr1006461985a.79.1756297093693;
        Wed, 27 Aug 2025 05:18:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHxYiFqJY3iuFSza3TUFjyiCig33JVHK+pO7P7M/s44Kch6adTIPvS5zTIUoMSPILP7krh2w==
X-Received: by 2002:a05:620a:294a:b0:7f1:650:2241 with SMTP id af79cd13be357-7f1066ebf38mr1006457685a.79.1756297093122;
        Wed, 27 Aug 2025 05:18:13 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebed79a712sm854386485a.17.2025.08.27.05.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 05:18:12 -0700 (PDT)
Message-ID: <99d2cc96-03ea-4026-883e-1ee083a96c39@redhat.com>
Date: Wed, 27 Aug 2025 14:18:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org,
 Christoph Hellwig <hch@infradead.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
 <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
 <f43a61b4-d302-4009-96ff-88eea6651e16@linaro.org>
 <77d17dbf-1609-41b1-9244-488d2ce75b33@redhat.com>
 <ecd33fa3-8362-48f0-b3c2-d1a11d8b02e3@linaro.org>
 <9f13df6f-3b76-4d02-aa74-40b913f37a8a@redhat.com>
 <64a93c4a-5619-4208-9e9f-83848206d42b@linaro.org>
 <f1f290fc-b2f0-483b-96d5-5995362e5a8b@redhat.com>
 <01c67173-818c-48cf-8515-060751074c37@linaro.org>
 <aab5e2af-04d6-485f-bf81-557583f2ae4b@redhat.com>
 <1b52419c-101b-487e-a961-97bd405c5c33@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1b52419c-101b-487e-a961-97bd405c5c33@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wvPCFNBMfmPEtHEuR0Xrhhr64GRYfbw4j2GuNdUXpj0_1756297094
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 331cdyhahiqqh1oku7qxj7w9ndgu76hs
X-Rspam-User: 
X-Rspamd-Queue-Id: 55C6220015
X-Rspamd-Server: rspam05
X-HE-Tag: 1756297096-568578
X-HE-Meta: U2FsdGVkX1/daheSGH2fAJVzX80+GDMGTKt1uo4bzCa56YXeAMD54OS5VchupnxYcYB+1tIseaAmhUtvxEaSdgIG9wTumUidizFCHRqlnnDP/IYPPQE7tPLw4ANVSDpFWNyjrSAjgF0GCs7gpf7whkEoCGWqyNTbcD6H9P8w+2+LXNej85YcMby2N1OcSWy4TlwkduV6hvWr+k2z+wrKE08SfBTxULvPuvW4APEPFlF/GHMoLO9Vu7HibK+I7sPjxow/qZlJqiLpAbfN76iaoJZGDJNe7pb1EAvpVjNBOX8wl0pGK9pTOH2mKDTls07b6pA0XSTU99bHvXv0fp/OVyQXNEiFEg3JZUvH6fyI310FlGvxBnlEU4jjWwvKh0tw8Ia9V51e8rfDcdZGua3fhpk2w+Ctz/KRT9EqE/E0WseFwANgGFHzYI7jkHZsYctOzbSsyf+RFFi3ZcqlW0oepclIfTl+m8aQhfxbNqTs/WDcq2L+jkUHI11hQJFs8RsMEPfosi9cgMQiIdnsB76HtFfaoZ/7+M9JYBERuHo4mz7klMGcn3/9B76gSRP4SBHbzAOa2uI5EB8DadedoDTPHRAhc9kUzUarJQ4YD/Xk5UKBqrCaqB6pOcMvPPkvDEiLvwdfUD314wgmT7Y1Ax3aZuF4v02bMARoKMBpQY7Xj3Wq4icYOs4OepTGh+wCwbNZRir5bytSFuGQM9vK3ptfTBAY2qSkJIdbIxeMWYvOiI/ckGJc3AEx6nrfs0SwihC+IkApE2yHKdn7cL2y7z1iyoG2jS0ezjmByUC8WqeqLY2gXycGGyUw7lv5y7BAqpLfn7n+BFjCjLjRROZttESM7OVBHsEwoOs5tcaBbweuoBDiUoZ46DMWIDJCTV7iOlnCXQrCaZ4oubZhwPq0us3v+S8GLWITIE6pdkbf8ouxyI1TjiNRHqfy1W9ueCftQjIY/pHLKMC5X5yiVCSmT4U
 t/yX4OIC
 WiUdGO/b6qM0JC4Bc8Gm12Hn1sE0w1iXB9Ik0Dve5jYafoUatwZuUcfIz6eJMmC1Vn/L6s8N45+b9BMGITosRFt8UD62iXPi/m1VsmI81AFpTNMPIHqpixI0v45GRHVxlbdW/xGUkSDzW7m/o/27J1Euvg8Y9R6QWsgnw5EK7+s+pQ1/xWSo89CyqMTjxno1hXKnL2AIaXvtTiE6hCOEQ9VwB4ykmZTJ0hv3TUlzVbfuNnsupGfd4ptSVny2b8w3xEcY4j+all54B4wmiscmnzj0YXs3fNYtvt/8+TlonNBUzJPNMJkAxtSTtf0PA1k/wfB6kCgIahu9SRMDkUkRbEOmuMPUhwNt8hoDOrfefEnbD3ia5WiZ0Acp+Zi3PgWxq3Vm0Z7eReZqqNZB8aMKa3YaJLJiBma8s+LxS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 13:59, Eugen Hristev wrote:
> 
> 
> On 8/25/25 16:58, David Hildenbrand wrote:
>> On 25.08.25 15:36, Eugen Hristev wrote:
>>>
>>>
>>> On 8/25/25 16:20, David Hildenbrand wrote:
>>>>
>>>>>>
>>>>>> IIRC, kernel/vmcore_info.c is never built as a module, as it also
>>>>>> accesses non-exported symbols.
>>>>>
>>>>> Hello David,
>>>>>
>>>>> I am looking again into this, and there are some things which in my
>>>>> opinion would be difficult to achieve.
>>>>> For example I looked into my patch #11 , which adds the `runqueues` into
>>>>> kmemdump.
>>>>>
>>>>> The runqueues is a variable of `struct rq` which is defined in
>>>>> kernel/sched/sched.h , which is not supposed to be included outside of
>>>>> sched.
>>>>> Now moving all the struct definition outside of sched.h into another
>>>>> public header would be rather painful and I don't think it's a really
>>>>> good option (The struct would be needed to compute the sizeof inside
>>>>> vmcoreinfo). Secondly, it would also imply moving all the nested struct
>>>>> definitions outside as well. I doubt this is something that we want for
>>>>> the sched subsys. How the subsys is designed, out of my understanding,
>>>>> is to keep these internal structs opaque outside of it.
>>>>
>>>> All the kmemdump module needs is a start and a length, correct? So the
>>>> only tricky part is getting the length.
>>>
>>> I also have in mind the kernel user case. How would a kernel programmer
>>> want to add some kernel structs/info/buffers into kmemdump such that the
>>> dump would contain their data ? Having "KMEMDUMP_VAR(...)" looks simple
>>> enough.
>>
>> The other way around, why should anybody have a saying in adding their
>> data to kmemdump? Why do we have that all over the kernel?
>>
>> Is your mechanism really so special?
>>
>> A single composer should take care of that, and it's really just start +
>> len of physical memory areas.
>>
>>> Otherwise maybe the programmer has to write helpers to compute lengths
>>> etc, and stitch them into kmemdump core.
>>> I am not saying it's impossible, but just tiresome perhaps.
>>
>> In your patch set, how many of these instances did you encounter where
>> that was a problem?
>>
>>>>
>>>> One could just add a const variable that holds this information, or even
>>>> better, a simple helper function to calculate that.
>>>>
>>>> Maybe someone else reading along has a better idea.
>>>
>>> This could work, but it requires again adding some code into the
>>> specific subsystem. E.g. struct_rq_get_size()
>>> I am open to ideas , and thank you very much for your thoughts.
>>>
>>>>
>>>> Interestingly, runqueues is a percpu variable, which makes me wonder if
>>>> what you had would work as intended (maybe it does, not sure).
>>>
>>> I would not really need to dump the runqueues. But the crash tool which
>>> I am using for testing, requires it. Without the runqueues it will not
>>> progress further to load the kernel dump.
>>> So I am not really sure what it does with the runqueues, but it works.
>>> Perhaps using crash/gdb more, to actually do something with this data,
>>> would give more insight about its utility.
>>> For me, it is a prerequisite to run crash, and then to be able to
>>> extract the log buffer from the dump.
>>
>> I have the faint recollection that percpu vars might not be stored in a
>> single contiguous physical memory area, but maybe my memory is just
>> wrong, that's why I was raising it.
>>
>>>
>>>>
>>>>>
>>>>>    From my perspective it's much simpler and cleaner to just add the
>>>>> kmemdump annotation macro inside the sched/core.c as it's done in my
>>>>> patch. This macro translates to a noop if kmemdump is not selected.
>>>>
>>>> I really don't like how we are spreading kmemdump all over the kernel,
>>>> and adding complexity with __section when really, all we need is a place
>>>> to obtain a start and a length.
>>>>
>>>
>>> I understand. The section idea was suggested by Thomas. Initially I was
>>> skeptic, but I like how it turned out.
>>
>> Yeah, I don't like it. Taste differs ;)
>>
>> I am in particular unhappy about custom memblock wrappers.
>>
>> [...]
>>
>>>>>
>>>>> To have this working outside of printk, it would be required to walk
>>>>> through all the printk structs/allocations and select the required info.
>>>>> Is this something that we want to do outside of printk ?
>>>>
>>>> I don't follow, please elaborate.
>>>>
>>>> How is e.g., log_buf_len_get() + log_buf_addr_get() not sufficient,
>>>> given that you run your initialization after setup_log_buf() ?
>>>>
>>>>
>>>
>>> My initial thought was the same. However I got some feedback from Petr
>>> Mladek here :
>>>
>>> https://lore.kernel.org/lkml/aBm5QH2p6p9Wxe_M@localhost.localdomain/
>>>
>>> Where he explained how to register the structs correctly.
>>> It can be that setup_log_buf is called again at a later time perhaps.
>>>
>>
>> setup_log_buf() is a __init function, so there is only a certain time
>> frame where it can be called.
>>
>> In particular, once the buddy is up, memblock allocations are impossible
>> and it would be deeply flawed to call this function again.
>>
>> Let's not over-engineer this.
>>
>> Peter is on CC, so hopefully he can share his thoughts.
>>
> 
> Hello David,
> 
> I tested out this snippet (on top of my series, so you can see what I
> changed):
> 
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 18ba6c1e174f..7ac4248a00e5 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -67,7 +67,6 @@
>   #include <linux/wait_api.h>
>   #include <linux/workqueue_api.h>
>   #include <linux/livepatch_sched.h>
> -#include <linux/kmemdump.h>
> 
>   #ifdef CONFIG_PREEMPT_DYNAMIC
>   # ifdef CONFIG_GENERIC_IRQ_ENTRY
> @@ -120,7 +119,12 @@
> EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
>   EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);
> 
>   DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
> -KMEMDUMP_VAR_CORE(runqueues, sizeof(runqueues));
> +
> +size_t runqueues_get_size(void);
> +size_t runqueues_get_size(void)
> +{
> +       return sizeof(runqueues);
> +}
> 
>   #ifdef CONFIG_SCHED_PROXY_EXEC
>   DEFINE_STATIC_KEY_TRUE(__sched_proxy_exec);
> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> index d808c5e67f35..c6dd2d6e96dd 100644
> --- a/kernel/vmcore_info.c
> +++ b/kernel/vmcore_info.c
> @@ -24,6 +24,12 @@
>   #include "kallsyms_internal.h"
>   #include "kexec_internal.h"
> 
> +typedef void* kmemdump_opaque_t;
> +
> +size_t runqueues_get_size(void);
> +
> +extern kmemdump_opaque_t runqueues;

I would have tried that through:

struct rq;
extern struct rq runqueues;

But the whole PER_CPU_SHARED_ALIGNED makes this all weird, and likely
not the way we would want to handle that.

>   /* vmcoreinfo stuff */
>   unsigned char *vmcoreinfo_data;
>   size_t vmcoreinfo_size;
> @@ -230,6 +236,9 @@ static int __init crash_save_vmcoreinfo_init(void)
> 
>          kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
>                               (void *)vmcoreinfo_data, vmcoreinfo_size);
> +       kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_runqueues,
> +                            (void *)&runqueues, runqueues_get_size());
> +
>          return 0;
>   }
> 
> With this, no more .section, no kmemdump code into sched, however, there
> are few things :

I would really just do here something like the following:

/**
  * sched_get_runqueues_area - obtain the runqueues area for dumping
  * @start: ...
  * @size: ...
  *
  * The obtained area is only to be used for dumping purposes.
  */
void sched_get_runqueues_area(void *start, size_t size)
{
	start = &runqueues;
	size = sizeof(runqueues);
}

might be cleaner.


Having said that, if you realize that there is a fundamental issue with 
what I propose, please speak up.

So far, I feel like there are only limited number of "suboptimal" cases 
of this kind, but I might be wrong of course.

-- 
Cheers

David / dhildenb


