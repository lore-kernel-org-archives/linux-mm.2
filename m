Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFB9CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CCE6B0006; Wed, 27 Aug 2025 10:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90DFA6B0096; Wed, 27 Aug 2025 10:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823E86B009B; Wed, 27 Aug 2025 10:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70EC26B0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:08:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07530598B7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:08:58 +0000 (UTC)
X-FDA: 83822718756.28.17DA805
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id D299740003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:08:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=E05YjGFR;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756303736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvE4LTDafzST+ebfuxrN2rVGDKvjsNA49QvlFFlyWIM=;
	b=ddiBgs0CcWmwCEsgphhH0w4xd9VJ7h+fbHOrVOBZwON6FZtFPTGXbCNqSSkiRvOFqJDNv4
	TQ4jjoioqv3wWE7lLYVFKZWAkPpwRtJxl1PsDNlN3r5gIuAX5P7GFS8zOffW/Ri/mSQuLn
	AfJtxAk11JsIudEzDukShE6Nmo3edRk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=E05YjGFR;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756303736; a=rsa-sha256;
	cv=none;
	b=6AlHupKrOHlCl+EXMo3vV36NFiBS1P1iqnmEwMFTQ5hwAKR5JPs/94mBNl0+nhlRptippg
	TEZWJCITM6OlG8oCYLP2f2BUrMmQwfwk3QaNuf4UX5K7sSMLVxmdTxrAhCDX1dBiF6wgfq
	YEvk65l3vgOr09g8qMp/eOV71n5BChM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3cd59c5a953so244480f8f.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756303734; x=1756908534; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xvE4LTDafzST+ebfuxrN2rVGDKvjsNA49QvlFFlyWIM=;
        b=E05YjGFRj7JXgQ4+nRxPeUnZMfgjAfWZ4/1Nc0SAouBJUaXIC+8p8WEsnSMRgb2qom
         gNL/pw8nvm+NsvZGYZlyrVc8cfE0cSFTpyoZvWRRM/gfBOLbLWzB+uM/oT2Zmlbhaicf
         3fV8cTQGYdf4ufpHX9e53LE/7EHAkFX4/PyNPXe00QgNghzTfD4gMFn6TSRfqOE0HYD9
         Y3XC3cF/3YaXFdm5E8y3wPf53EJiVJ4LI++bTeTrFyv00i7Y4MO7AZxsRgfPQYoWCaTB
         eNOfKYlLxqXeZ08VZrWlk/+ZjY/74y1z0/Yu21FOx5SkIO68qWPE0icdiFp830WZ+HmD
         lfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756303734; x=1756908534;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xvE4LTDafzST+ebfuxrN2rVGDKvjsNA49QvlFFlyWIM=;
        b=ZMBDQbz+hFy9nB9aTVNT3XnLNavq7PbfAn3SUJyuV9VMc9fNSRMqzSP2ew53Sj5zLN
         rajwraHGEl/0NMfgogsydfQUht/lD0D6ivwOVkl15kQLwj3t5irNKRNwPrG67aP7Lsmy
         hIjoBUlg4sVdQmj5MEYLFIWsTrfVqCFESOZ9jN/4togTDBZVbS0mrktpURG2HnLtryrt
         jSyQSPt5/AHHRIWRfLEUkGWvJ+VkhKOojGAFeDwVhHS9/Po2Ia3a4pTlfRqf4T2v8YVI
         S4JnNoSBNlIe8ZDv9+AgDG7crRICf+QqX9cice+RWqwfkrot0jKaCtLnF5g0qUgt5o7o
         nLWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuJ/fox6t+cJIJjeZS2yIMdNavpPuLHq5SThAau63pppUA6CqQEsMprLNxhaoqhIGAdmrAQqaUaQ==@kvack.org
X-Gm-Message-State: AOJu0YxMpSBlLKlWjEKJ3HK9P2nGp8oxnsmyFKRjkSm+mu2IhIM0nf0e
	OTJGUl5WtPsqTxLgzd6RQAJVeAezfkO9t2FsPiLcFiGI/bxF3Yst0wRfdhnhxmmCR0k=
X-Gm-Gg: ASbGncul1KT5t+8Izr+qGSFfYjBjySJuu7WLOnTN7E5T8NRL7MioRKDahHmnucfJtHX
	jrALkXeCzlqVFXjRVtXzKUNFXqKHk25orVIcqez1Kg0WJ9wPCgRcBg05f/CzhWwt+AsEKeYdsMb
	3uNbpxRoTBiDXoBu0CdE/z89YN+0OQwcMPJy0wtqytLAvMglIOtxg6K5tp4mXkvzu+rj4EWVSTJ
	mw9LgXowFFOclcqwcFwx0pS/sqZWASOCoKZpuO6+cIZ7VXcCDNuWryoTe1AiZIXDLNmYMuXVgtX
	hfhWo1OE/ctUaotJ3FDV4vG9O06u5IIA7D+/ImPIO8ijpeCmlXaMBmg1shTXVN0Xt7fLxLKNq7E
	GfQRrJmL3xzKP/5xbdZSzLOhOoRd41w==
X-Google-Smtp-Source: AGHT+IHkXcu1NEQam2q8j8cNwacl8Imtu6GXIMZzfeXxsacEy+DVaG4nf82ZkbK5vX8UXnyEqjuJwg==
X-Received: by 2002:a05:6000:188e:b0:3cd:9794:cbcf with SMTP id ffacd0b85a97d-3cd9794cc94mr128751f8f.60.1756303733978;
        Wed, 27 Aug 2025 07:08:53 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc56bde919sm4094896f8f.59.2025.08.27.07.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 07:08:53 -0700 (PDT)
Message-ID: <98afe1bd-99d2-4b5d-866a-e9541390fab4@linaro.org>
Date: Wed, 27 Aug 2025 17:08:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
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
 <99d2cc96-03ea-4026-883e-1ee083a96c39@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <99d2cc96-03ea-4026-883e-1ee083a96c39@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D299740003
X-Rspam-User: 
X-Stat-Signature: wsbhtf1d163n8wxninxtamgqybjtyuut
X-Rspamd-Server: rspam09
X-HE-Tag: 1756303735-705085
X-HE-Meta: U2FsdGVkX1/1NzsnMf1thqAWsPTTNbgPokqMs7W+7NycqmkHpuiSQZMyFAohxifkjcTAWhnjuen8Cx86FUgoIPS4RtkKeukqQWyoO/RAE7h0gbwo+zV8ysPqcEaSQ6FMbdw4wqasC717uwhrmEdonHEb1rIiVfYF/40AG7vvQxjPsC06YN7TAAxK+cjpkn4l9HVfHBvVvYwxl03PIn0yyKNy1sN5RYyiqBITLuRvFllXdLmstOK2fAsEg1zoYsQP8O2djGnef+rY3bhGH3IwhK+JNtFOBQsrA3qWTE5MSPjU0Mu8j8Ceaxmnes/BbI8fnt/NlMJ/Y9uEw4se3DQSKF+BSHtlmO3hZwXZ5KSNgA4xb0SqLHZ7Vj2J7j3VnvXH1dVrLtLaNZRUZBE3VzC+RJLK+Iw0ECSTJGWRvi67xDjTr3OHy/9BQ3bEvs8OoZRk7wfuknPVr9MZXnNVYEX73XZc0wUmQc06pMW6S6Mc0NJYxCZhaPD5y90Yjk/PJMunbQ46MiC5bE7er5PPlITTaSvkgcGJ9v062EEKMzqSeQDTzKodhrco1KYFN5vGjowAgB58sI2mo8lAyeGjw/cZv99YCTkSO6oJlzFQttgUOIyHsBJylsWSgJf0Vjq5FI53I1yT9yt+PzG30brXYDSXHMxqtDo34rDhtIMKe9L+gc3mU2c//5wXgNaQ9/H7RyqLl9sUpO5E4eG5ZQtVkSzxNcRaSUqKokH1XeAPOBab4oV6r2ZRtK2TQc/csK2urOE7lKi40GqjqpX50DM2GVx1HT1iI4NRRQd03Pd+1H2N1GA0HADqS7hTnrg4xWILkhaSQsB9jVkCqIRZCKn4DJxnQI1d+7IBk3pKXOf+m1w0YY9XaN2K1Uv7edBlix2DWPw2XJmdG2ZbAMKVR462CR2z7X6hot1gwvyDNIzaWLBj2qYcSfDxr6aRWtkrEEl/eF4tRt61B9ygyx2WTbrjpSz
 PUoUugT0
 fl04dQ35AIOVzC8JH9+D6H0KOF07ZIjdDH6nbjiDINMt58+pDX9Mgn4nbOeJDDrXCRtgQH5XQ4FXJhXMPROIuSizEidTWdERzkKH/DP2jqOlpKggt7XU3KLH12DzJ/nIBwrniyCTpkQI7UOLG7zcpvVycTWv9gnKYsRxAj5ONpplpRxXxL+vJtzRBbvTj/v8D4DuXYHjPGuS29ze1ibO7drrs2iVZNuEvh4U29qZiGjkCstfp7EwLt+TmwJTDJIe/8R4HGa3FLc/NWFD4CjaxdjGsWDP86mURXFkdQoFYyFzU/CtBKWscAYdF0NJ1pwg2i71NAJUczdTRYjBuTDj0t66X348Wcca1pCGZn45Kxjh4Ux8opv/lSUL69i86fwFd9bHpMy/9oU3cOd+hM/fqsc9Agna3LwaRNQI1qLZDSacjhHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/25 15:18, David Hildenbrand wrote:
> On 27.08.25 13:59, Eugen Hristev wrote:
>>
>>
>> On 8/25/25 16:58, David Hildenbrand wrote:
>>> On 25.08.25 15:36, Eugen Hristev wrote:
>>>>
>>>>
>>>> On 8/25/25 16:20, David Hildenbrand wrote:
>>>>>
>>>>>>>
>>>>>>> IIRC, kernel/vmcore_info.c is never built as a module, as it also
>>>>>>> accesses non-exported symbols.
>>>>>>
>>>>>> Hello David,
>>>>>>
>>>>>> I am looking again into this, and there are some things which in my
>>>>>> opinion would be difficult to achieve.
>>>>>> For example I looked into my patch #11 , which adds the `runqueues` into
>>>>>> kmemdump.
>>>>>>
>>>>>> The runqueues is a variable of `struct rq` which is defined in
>>>>>> kernel/sched/sched.h , which is not supposed to be included outside of
>>>>>> sched.
>>>>>> Now moving all the struct definition outside of sched.h into another
>>>>>> public header would be rather painful and I don't think it's a really
>>>>>> good option (The struct would be needed to compute the sizeof inside
>>>>>> vmcoreinfo). Secondly, it would also imply moving all the nested struct
>>>>>> definitions outside as well. I doubt this is something that we want for
>>>>>> the sched subsys. How the subsys is designed, out of my understanding,
>>>>>> is to keep these internal structs opaque outside of it.
>>>>>
>>>>> All the kmemdump module needs is a start and a length, correct? So the
>>>>> only tricky part is getting the length.
>>>>
>>>> I also have in mind the kernel user case. How would a kernel programmer
>>>> want to add some kernel structs/info/buffers into kmemdump such that the
>>>> dump would contain their data ? Having "KMEMDUMP_VAR(...)" looks simple
>>>> enough.
>>>
>>> The other way around, why should anybody have a saying in adding their
>>> data to kmemdump? Why do we have that all over the kernel?
>>>
>>> Is your mechanism really so special?
>>>
>>> A single composer should take care of that, and it's really just start +
>>> len of physical memory areas.
>>>
>>>> Otherwise maybe the programmer has to write helpers to compute lengths
>>>> etc, and stitch them into kmemdump core.
>>>> I am not saying it's impossible, but just tiresome perhaps.
>>>
>>> In your patch set, how many of these instances did you encounter where
>>> that was a problem?
>>>
>>>>>
>>>>> One could just add a const variable that holds this information, or even
>>>>> better, a simple helper function to calculate that.
>>>>>
>>>>> Maybe someone else reading along has a better idea.
>>>>
>>>> This could work, but it requires again adding some code into the
>>>> specific subsystem. E.g. struct_rq_get_size()
>>>> I am open to ideas , and thank you very much for your thoughts.
>>>>
>>>>>
>>>>> Interestingly, runqueues is a percpu variable, which makes me wonder if
>>>>> what you had would work as intended (maybe it does, not sure).
>>>>
>>>> I would not really need to dump the runqueues. But the crash tool which
>>>> I am using for testing, requires it. Without the runqueues it will not
>>>> progress further to load the kernel dump.
>>>> So I am not really sure what it does with the runqueues, but it works.
>>>> Perhaps using crash/gdb more, to actually do something with this data,
>>>> would give more insight about its utility.
>>>> For me, it is a prerequisite to run crash, and then to be able to
>>>> extract the log buffer from the dump.
>>>
>>> I have the faint recollection that percpu vars might not be stored in a
>>> single contiguous physical memory area, but maybe my memory is just
>>> wrong, that's why I was raising it.
>>>
>>>>
>>>>>
>>>>>>
>>>>>>    From my perspective it's much simpler and cleaner to just add the
>>>>>> kmemdump annotation macro inside the sched/core.c as it's done in my
>>>>>> patch. This macro translates to a noop if kmemdump is not selected.
>>>>>
>>>>> I really don't like how we are spreading kmemdump all over the kernel,
>>>>> and adding complexity with __section when really, all we need is a place
>>>>> to obtain a start and a length.
>>>>>
>>>>
>>>> I understand. The section idea was suggested by Thomas. Initially I was
>>>> skeptic, but I like how it turned out.
>>>
>>> Yeah, I don't like it. Taste differs ;)
>>>
>>> I am in particular unhappy about custom memblock wrappers.
>>>
>>> [...]
>>>
>>>>>>
>>>>>> To have this working outside of printk, it would be required to walk
>>>>>> through all the printk structs/allocations and select the required info.
>>>>>> Is this something that we want to do outside of printk ?
>>>>>
>>>>> I don't follow, please elaborate.
>>>>>
>>>>> How is e.g., log_buf_len_get() + log_buf_addr_get() not sufficient,
>>>>> given that you run your initialization after setup_log_buf() ?
>>>>>
>>>>>
>>>>
>>>> My initial thought was the same. However I got some feedback from Petr
>>>> Mladek here :
>>>>
>>>> https://lore.kernel.org/lkml/aBm5QH2p6p9Wxe_M@localhost.localdomain/
>>>>
>>>> Where he explained how to register the structs correctly.
>>>> It can be that setup_log_buf is called again at a later time perhaps.
>>>>
>>>
>>> setup_log_buf() is a __init function, so there is only a certain time
>>> frame where it can be called.
>>>
>>> In particular, once the buddy is up, memblock allocations are impossible
>>> and it would be deeply flawed to call this function again.
>>>
>>> Let's not over-engineer this.
>>>
>>> Peter is on CC, so hopefully he can share his thoughts.
>>>
>>
>> Hello David,
>>
>> I tested out this snippet (on top of my series, so you can see what I
>> changed):
>>
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 18ba6c1e174f..7ac4248a00e5 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -67,7 +67,6 @@
>>   #include <linux/wait_api.h>
>>   #include <linux/workqueue_api.h>
>>   #include <linux/livepatch_sched.h>
>> -#include <linux/kmemdump.h>
>>
>>   #ifdef CONFIG_PREEMPT_DYNAMIC
>>   # ifdef CONFIG_GENERIC_IRQ_ENTRY
>> @@ -120,7 +119,12 @@
>> EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
>>   EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);
>>
>>   DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
>> -KMEMDUMP_VAR_CORE(runqueues, sizeof(runqueues));
>> +
>> +size_t runqueues_get_size(void);
>> +size_t runqueues_get_size(void)
>> +{
>> +       return sizeof(runqueues);
>> +}
>>
>>   #ifdef CONFIG_SCHED_PROXY_EXEC
>>   DEFINE_STATIC_KEY_TRUE(__sched_proxy_exec);
>> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
>> index d808c5e67f35..c6dd2d6e96dd 100644
>> --- a/kernel/vmcore_info.c
>> +++ b/kernel/vmcore_info.c
>> @@ -24,6 +24,12 @@
>>   #include "kallsyms_internal.h"
>>   #include "kexec_internal.h"
>>
>> +typedef void* kmemdump_opaque_t;
>> +
>> +size_t runqueues_get_size(void);
>> +
>> +extern kmemdump_opaque_t runqueues;
> 
> I would have tried that through:
> 
> struct rq;
> extern struct rq runqueues;
> 
> But the whole PER_CPU_SHARED_ALIGNED makes this all weird, and likely
> not the way we would want to handle that.
> 
>>   /* vmcoreinfo stuff */
>>   unsigned char *vmcoreinfo_data;
>>   size_t vmcoreinfo_size;
>> @@ -230,6 +236,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>>
>>          kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
>>                               (void *)vmcoreinfo_data, vmcoreinfo_size);
>> +       kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_runqueues,
>> +                            (void *)&runqueues, runqueues_get_size());
>> +
>>          return 0;
>>   }
>>
>> With this, no more .section, no kmemdump code into sched, however, there
>> are few things :
> 
> I would really just do here something like the following:
> 
> /**
>   * sched_get_runqueues_area - obtain the runqueues area for dumping
>   * @start: ...
>   * @size: ...
>   *
>   * The obtained area is only to be used for dumping purposes.
>   */
> void sched_get_runqueues_area(void *start, size_t size)
> {
> 	start = &runqueues;
> 	size = sizeof(runqueues);
> }
> 
> might be cleaner.
> 

How about this in the header:

#define DECLARE_DUMP_AREA_FUNC(subsys, symbol) \

void subsys ## _get_ ## symbol ##_area(void **start, size_t *size);



#define DEFINE_DUMP_AREA_FUNC(subsys, symbol) \

void subsys ## _get_ ## symbol ##_area(void **start, size_t *size)\

{\

        *start = &symbol;\

        *size = sizeof(symbol);\

}


then, in sched just

DECLARE_DUMP_AREA_FUNC(sched, runqueues);

DEFINE_DUMP_AREA_FUNC(sched, runqueues);

or a single macro that wraps both.

would make it shorter and neater.

What do you think ?

> 
> Having said that, if you realize that there is a fundamental issue with 
> what I propose, please speak up.
> 
> So far, I feel like there are only limited number of "suboptimal" cases 
> of this kind, but I might be wrong of course.
> 


