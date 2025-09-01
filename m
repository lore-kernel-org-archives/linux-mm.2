Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6732BCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CDF8E0012; Mon,  1 Sep 2025 04:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14548E0010; Mon,  1 Sep 2025 04:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A038E0012; Mon,  1 Sep 2025 04:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DACF8E0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:57:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49BE6160728
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:57:15 +0000 (UTC)
X-FDA: 83840077230.11.8ECFBDC
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3FA6C80003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:57:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HOYRNmpy;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756717033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgvQHB1ThISY9uVHxKPAb9k4TCRL2UiR6ffxI/PWq3M=;
	b=fOrw93nwS6iKnIRSjZ1Hz4S5Thjp+WOv8WitaYYD4+mpBNxcGJwUInbWi2BwUTBj2F7Dak
	i3XdlokMB5eJYyopXbR22zDDugHM1WbissWkyPQmmX97xR1/WT8FeRahapDE2YZWI6d3PA
	MLBUTtH5uzV7Y5T63VmEiZUiyFBBJeU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=HOYRNmpy;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756717033; a=rsa-sha256;
	cv=none;
	b=GcmTHF4Y7q0meLAD6aVxtbRSX1EnfH0ezAFMTv1bv+Vu1L7KL/ekl0ovX3Av4qXy0/D0HN
	v0wusJF3iVQ1FjfgXiEiwJc1lj9jRxy+05AxnK/DOcigAfGbwUPYa3m8g5mBnnAwG4yhSY
	VAl7ISzW9sN1YerGL1/R8CC+jrbbbtc=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d71bcab69so32939957b3.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756717032; x=1757321832; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qgvQHB1ThISY9uVHxKPAb9k4TCRL2UiR6ffxI/PWq3M=;
        b=HOYRNmpynOAjFwQF8pHkTSO/TmPShdfT7z2I/fHIks+8tb9hqkz4pfpbQbplEKvgfn
         iH1mNaI1vuGyrgg/36tkGf+M4QUk4LUqRwKw+mFdJkl/zJO+2lRvZn3MgOYVRA7XzcPf
         yTHIrKLVXpspyF/4mYMDpduVjaPa5JIn/0ZK35c+subqCjxW/dQ0wwQ52s94mB9js02I
         oia5YSsPtXp10sUoEOSKwA3bZtdrDfhn9/ZcMolyq2i127ceh/jX2+ZJiK4Ar64HvKw4
         5T9y5vMg/m03uFIut5aFUqi625GVAuS/svuUtCGnCCab36Kt5n26l7T9p/atO85MtkWU
         I6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756717032; x=1757321832;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qgvQHB1ThISY9uVHxKPAb9k4TCRL2UiR6ffxI/PWq3M=;
        b=Uprd06eS8VWebO7nuCsOSZxFNQ9QaX9aC+80oNHvwKwcCWqfeMrMgMu+R5V6V9mu2l
         Z6EQYX/FYpaNcx0IvouicUWKN2opb27Wm/+m4kGeDW0eIg9SdRBMGTO2vDdFKFIHQ5Mg
         pEaerAnIXVufjrSOddh01C0JtsWljyCT3/5i9MbCGmRIZ2jHYGlPBj0NVBflH/N0vE71
         jqx1Y0ZoUK0VEc52SJZXnpbGq5t3UaPQRzq64VGxQx25fJmXHUstOYwzHkafd/uO/nEI
         dtvNc8i1C/q7WmA6eoTujPDRhpsesay7ieCz4Z5KX0bplM9KBUoQYXlHwB9j5psYSGpW
         hZeg==
X-Forwarded-Encrypted: i=1; AJvYcCUnIlQrI3jw4lXnyo7IYPnyFvL3rkZmN1wD0L9lY1D5ZXQl0zfP6eJxHImMEjD7XsCn5620dNce8w==@kvack.org
X-Gm-Message-State: AOJu0Ywy0G87Oe1Lwj369LnrP/GD0brr9uxEK5+8a8uBn+CMoe75y4Wt
	Esyu5n88dY5IaSAmBsjCntUH9fD16AjrYICMQOxwC54XBU4pvzjY9H1f1bx7ywYln+g=
X-Gm-Gg: ASbGnctd1RZ2GnQA/R00qNwitCbmYUG5kSE0vF5jvOqy/tpehv2vk2qO6fsJyOR+dCU
	XEtddBQE3iAJkGl9DDX+BCekhKs5PRKVtFRbSNPqnq+5AgWbI3oXbbDADqeJLm95SJF9Xoyyjm3
	sQr+rdY0U896E623p7L1lFvgTzEfPcs6JAAWVRmIvbSYpC+UDTykKWKXihLpR4V3SUHgJm/SPZo
	MGsp1FJftLNydb5VFCoKaQkGXp4V11U7OsF2wogNofz1EL2KqnTsprnZuqCLCaoDD7dh51L6M3R
	6PsH6zZP4JUCF2xjhMYWd4UTDstthHphobk+pQ60sVdchIw3wgsJz5lGGraNNZ/o96zD/vJfjj1
	E+ajxXtyC6kVbOtQ6Z/U7YGmKs2lofUe5LOdfVXZZiAyBBmaHnOX5Gh/trL0eH8OOPRfVKOpD1F
	UWj8bvt3hK2YHO4g==
X-Google-Smtp-Source: AGHT+IG38bjjyQjzt0c80VXnwoUSoXxUbipjOE1UiZhaYOXnFBnq4b3rik9mxtcs1scAlzx7pRovJg==
X-Received: by 2002:a05:690c:a4c1:20b0:722:92c5:8e80 with SMTP id 00721157ae682-72292c59299mr23345777b3.40.1756717032133;
        Mon, 01 Sep 2025 01:57:12 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:335e:2208:211c:f884:abe7:c955? ([2a0d:3344:335e:2208:211c:f884:abe7:c955])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7227d8cc1fbsm13391337b3.37.2025.09.01.01.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:57:11 -0700 (PDT)
Message-ID: <40e802eb-3764-47af-8b4f-9f7c8b5b60c1@linaro.org>
Date: Mon, 1 Sep 2025 11:57:06 +0300
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
 <98afe1bd-99d2-4b5d-866a-e9541390fab4@linaro.org>
 <c59f2528-31b0-4b9d-8d20-f204a0600ff6@redhat.com>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <c59f2528-31b0-4b9d-8d20-f204a0600ff6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5jbgzhbw5gnqkssfjizp65mbu34njprx
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FA6C80003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756717033-661008
X-HE-Meta: U2FsdGVkX18d5JblDqAWtGFIGACCN4SYjygZi0lI6SusM/NGFeb6IF5SJYT5Jke9w3M0c7l0QBsEMGJHKEACuLA3M5v8rc/Lf+LY9JVJyqlMXjuvmGcTefpLQuq8LlrOMnElVyz1JKLu3ho10MBHwGVzkCoPhEPCHjdFuIaJ0tuSGsQnWpbNmjOKA1umQdoQl/VEJIQDfSBH3JLpHNd1W7Y9YOIhyY2K+D1wie7bKw6mEeCQAI6TBnJQP+u6dSM/NwAdu62Pze/+Otj4L8pVsJAWi+KmbeXl0d8Ms38cmt3S8rGNIiHXbw/tPpLuxquYsci8iyWErP9o/yMb307WAmaHC5FE+M7SmCujuPe/Rj7GgfPO2pNPF5ih0J/8nwlf/ShqciP9cUqRf6BWlq0MhmmU3xzAZLCwqFtn5FzZlxQCvTO8KeAco6oe11OfJsaTCzak3D9PK7IVw20fWUwa4TgKR/VFpq2oYXOzyBXUzt1iUlN3qP7d0pZpuzwRmzUthUiKYeiAK4tElQGtJxKFGRpaHXoIg4zsN5LA//iCA0AMa0d8w1YkK5k/QJC3+zJbJxNyRJB8jVVcwDbQwlro/Enq+sZEv1wdQ2xtUn4oh0Csfj2FfmqR4SsfiK5TYXcGoCs7xSfZyoZhp0c02MlM+pKUKheHOPD0BMBcyWobPlFYMgiB1IPGnRuBM45N0QACEeo441rXhQIcmzGd7KIorUfLjSraliUCTjhSXRkQlTlMRdxpmcDoh9I/12frfjbexXRDFb+PGIfhWnXZpII8qGIgn6aMENdX1dzdHjL3EEHQEVpxazFNPE6Y0wh5g+BCf7vJwNJTMCBngAoW7HuUphhTlel88Qn4/Tq6Srs3HWvXj59kJ/DmustrzdDsY4/E6Skl/qVTQ0fUe8ZngHYWZ+xWoym9LG/9U5w05TTrgLfcdao/X5oRsHq0pI18PDF1h1PMdFzXy5mEGxfRr5a
 kqbMTvt1
 +2J6hBnjnhEnXG8+cvyst4lmpcomrzcOyLnX2g0iLsa5NoI5RnQYv2MuY+/l75Agn7JD0dvuGlH9zSoZSFfpNrWJC27QLx30h4cEajXG93nOwVeV5vS3wY1zLOYK0x2v9YMvA/Od/3h6D0urFhlIPYJ5dtrGe65+94xHoDwyRy3ucYmrMPEgsp8P4pW15052IOGYd04eE8IW8yIKMoXUoTBEKov2ki4ZHX7/U4I3hewjVUuinRp6GbAb9PWjaNGlgm4q92JDo8eqEXncOadMk4nKoM9ojNf59SPGy3bzyM4WojZdLgyJIwUPNoTAxbENrWrYt3DkYvdyJgtcdDVGAKoVBhGvReevvKmjRHQ8nXfb0AKYqa5YQIbhGG9JTY/odYAor
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/25 23:06, David Hildenbrand wrote:
> On 27.08.25 16:08, Eugen Hristev wrote:
>>
>>
>> On 8/27/25 15:18, David Hildenbrand wrote:
>>> On 27.08.25 13:59, Eugen Hristev wrote:
>>>>
>>>>
>>>> On 8/25/25 16:58, David Hildenbrand wrote:
>>>>> On 25.08.25 15:36, Eugen Hristev wrote:
>>>>>>
>>>>>>
>>>>>> On 8/25/25 16:20, David Hildenbrand wrote:
>>>>>>>
>>>>>>>>>
>>>>>>>>> IIRC, kernel/vmcore_info.c is never built as a module, as it also
>>>>>>>>> accesses non-exported symbols.
>>>>>>>>
>>>>>>>> Hello David,
>>>>>>>>
>>>>>>>> I am looking again into this, and there are some things which in my
>>>>>>>> opinion would be difficult to achieve.
>>>>>>>> For example I looked into my patch #11 , which adds the `runqueues` into
>>>>>>>> kmemdump.
>>>>>>>>
>>>>>>>> The runqueues is a variable of `struct rq` which is defined in
>>>>>>>> kernel/sched/sched.h , which is not supposed to be included outside of
>>>>>>>> sched.
>>>>>>>> Now moving all the struct definition outside of sched.h into another
>>>>>>>> public header would be rather painful and I don't think it's a really
>>>>>>>> good option (The struct would be needed to compute the sizeof inside
>>>>>>>> vmcoreinfo). Secondly, it would also imply moving all the nested struct
>>>>>>>> definitions outside as well. I doubt this is something that we want for
>>>>>>>> the sched subsys. How the subsys is designed, out of my understanding,
>>>>>>>> is to keep these internal structs opaque outside of it.
>>>>>>>
>>>>>>> All the kmemdump module needs is a start and a length, correct? So the
>>>>>>> only tricky part is getting the length.
>>>>>>
>>>>>> I also have in mind the kernel user case. How would a kernel programmer
>>>>>> want to add some kernel structs/info/buffers into kmemdump such that the
>>>>>> dump would contain their data ? Having "KMEMDUMP_VAR(...)" looks simple
>>>>>> enough.
>>>>>
>>>>> The other way around, why should anybody have a saying in adding their
>>>>> data to kmemdump? Why do we have that all over the kernel?
>>>>>
>>>>> Is your mechanism really so special?
>>>>>
>>>>> A single composer should take care of that, and it's really just start +
>>>>> len of physical memory areas.
>>>>>
>>>>>> Otherwise maybe the programmer has to write helpers to compute lengths
>>>>>> etc, and stitch them into kmemdump core.
>>>>>> I am not saying it's impossible, but just tiresome perhaps.
>>>>>
>>>>> In your patch set, how many of these instances did you encounter where
>>>>> that was a problem?
>>>>>
>>>>>>>
>>>>>>> One could just add a const variable that holds this information, or even
>>>>>>> better, a simple helper function to calculate that.
>>>>>>>
>>>>>>> Maybe someone else reading along has a better idea.
>>>>>>
>>>>>> This could work, but it requires again adding some code into the
>>>>>> specific subsystem. E.g. struct_rq_get_size()
>>>>>> I am open to ideas , and thank you very much for your thoughts.
>>>>>>
>>>>>>>
>>>>>>> Interestingly, runqueues is a percpu variable, which makes me wonder if
>>>>>>> what you had would work as intended (maybe it does, not sure).
>>>>>>
>>>>>> I would not really need to dump the runqueues. But the crash tool which
>>>>>> I am using for testing, requires it. Without the runqueues it will not
>>>>>> progress further to load the kernel dump.
>>>>>> So I am not really sure what it does with the runqueues, but it works.
>>>>>> Perhaps using crash/gdb more, to actually do something with this data,
>>>>>> would give more insight about its utility.
>>>>>> For me, it is a prerequisite to run crash, and then to be able to
>>>>>> extract the log buffer from the dump.
>>>>>
>>>>> I have the faint recollection that percpu vars might not be stored in a
>>>>> single contiguous physical memory area, but maybe my memory is just
>>>>> wrong, that's why I was raising it.
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>>     From my perspective it's much simpler and cleaner to just add the
>>>>>>>> kmemdump annotation macro inside the sched/core.c as it's done in my
>>>>>>>> patch. This macro translates to a noop if kmemdump is not selected.
>>>>>>>
>>>>>>> I really don't like how we are spreading kmemdump all over the kernel,
>>>>>>> and adding complexity with __section when really, all we need is a place
>>>>>>> to obtain a start and a length.
>>>>>>>
>>>>>>
>>>>>> I understand. The section idea was suggested by Thomas. Initially I was
>>>>>> skeptic, but I like how it turned out.
>>>>>
>>>>> Yeah, I don't like it. Taste differs ;)
>>>>>
>>>>> I am in particular unhappy about custom memblock wrappers.
>>>>>
>>>>> [...]
>>>>>
>>>>>>>>
>>>>>>>> To have this working outside of printk, it would be required to walk
>>>>>>>> through all the printk structs/allocations and select the required info.
>>>>>>>> Is this something that we want to do outside of printk ?
>>>>>>>
>>>>>>> I don't follow, please elaborate.
>>>>>>>
>>>>>>> How is e.g., log_buf_len_get() + log_buf_addr_get() not sufficient,
>>>>>>> given that you run your initialization after setup_log_buf() ?
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> My initial thought was the same. However I got some feedback from Petr
>>>>>> Mladek here :
>>>>>>
>>>>>> https://lore.kernel.org/lkml/aBm5QH2p6p9Wxe_M@localhost.localdomain/
>>>>>>
>>>>>> Where he explained how to register the structs correctly.
>>>>>> It can be that setup_log_buf is called again at a later time perhaps.
>>>>>>
>>>>>
>>>>> setup_log_buf() is a __init function, so there is only a certain time
>>>>> frame where it can be called.
>>>>>
>>>>> In particular, once the buddy is up, memblock allocations are impossible
>>>>> and it would be deeply flawed to call this function again.
>>>>>
>>>>> Let's not over-engineer this.
>>>>>
>>>>> Peter is on CC, so hopefully he can share his thoughts.
>>>>>
>>>>
>>>> Hello David,
>>>>
>>>> I tested out this snippet (on top of my series, so you can see what I
>>>> changed):
>>>>
>>>>
>>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>>> index 18ba6c1e174f..7ac4248a00e5 100644
>>>> --- a/kernel/sched/core.c
>>>> +++ b/kernel/sched/core.c
>>>> @@ -67,7 +67,6 @@
>>>>    #include <linux/wait_api.h>
>>>>    #include <linux/workqueue_api.h>
>>>>    #include <linux/livepatch_sched.h>
>>>> -#include <linux/kmemdump.h>
>>>>
>>>>    #ifdef CONFIG_PREEMPT_DYNAMIC
>>>>    # ifdef CONFIG_GENERIC_IRQ_ENTRY
>>>> @@ -120,7 +119,12 @@
>>>> EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
>>>>    EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);
>>>>
>>>>    DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
>>>> -KMEMDUMP_VAR_CORE(runqueues, sizeof(runqueues));
>>>> +
>>>> +size_t runqueues_get_size(void);
>>>> +size_t runqueues_get_size(void)
>>>> +{
>>>> +       return sizeof(runqueues);
>>>> +}
>>>>
>>>>    #ifdef CONFIG_SCHED_PROXY_EXEC
>>>>    DEFINE_STATIC_KEY_TRUE(__sched_proxy_exec);
>>>> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
>>>> index d808c5e67f35..c6dd2d6e96dd 100644
>>>> --- a/kernel/vmcore_info.c
>>>> +++ b/kernel/vmcore_info.c
>>>> @@ -24,6 +24,12 @@
>>>>    #include "kallsyms_internal.h"
>>>>    #include "kexec_internal.h"
>>>>
>>>> +typedef void* kmemdump_opaque_t;
>>>> +
>>>> +size_t runqueues_get_size(void);
>>>> +
>>>> +extern kmemdump_opaque_t runqueues;
>>>
>>> I would have tried that through:
>>>
>>> struct rq;
>>> extern struct rq runqueues;
>>>
>>> But the whole PER_CPU_SHARED_ALIGNED makes this all weird, and likely
>>> not the way we would want to handle that.
>>>
>>>>    /* vmcoreinfo stuff */
>>>>    unsigned char *vmcoreinfo_data;
>>>>    size_t vmcoreinfo_size;
>>>> @@ -230,6 +236,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>>>>
>>>>           kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
>>>>                                (void *)vmcoreinfo_data, vmcoreinfo_size);
>>>> +       kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_runqueues,
>>>> +                            (void *)&runqueues, runqueues_get_size());
>>>> +
>>>>           return 0;
>>>>    }
>>>>
>>>> With this, no more .section, no kmemdump code into sched, however, there
>>>> are few things :
>>>
>>> I would really just do here something like the following:
>>>
>>> /**
>>>    * sched_get_runqueues_area - obtain the runqueues area for dumping
>>>    * @start: ...
>>>    * @size: ...
>>>    *
>>>    * The obtained area is only to be used for dumping purposes.
>>>    */
>>> void sched_get_runqueues_area(void *start, size_t size)
>>> {
>>> 	start = &runqueues;
>>> 	size = sizeof(runqueues);
>>> }
>>>
>>> might be cleaner.
>>>
>>
>> How about this in the header:
>>
>> #define DECLARE_DUMP_AREA_FUNC(subsys, symbol) \
>>
>> void subsys ## _get_ ## symbol ##_area(void **start, size_t *size);
>>
>>
>>
>> #define DEFINE_DUMP_AREA_FUNC(subsys, symbol) \
>>
>> void subsys ## _get_ ## symbol ##_area(void **start, size_t *size)\
>>
>> {\
>>
>>          *start = &symbol;\
>>
>>          *size = sizeof(symbol);\
>>
>> }
>>
>>
>> then, in sched just
>>
>> DECLARE_DUMP_AREA_FUNC(sched, runqueues);
>>
>> DEFINE_DUMP_AREA_FUNC(sched, runqueues);
>>
>> or a single macro that wraps both.
>>
>> would make it shorter and neater.
>>
>> What do you think ?
> 
> Looks a bit over-engineered, and will require us to import a header 
> (likely kmemdump.h) in these files, which I don't really enjoy.
> 
> I would start simple, without any such macro-magic. It's a very simple 
> function after all, and likely you won't end up having many of these?
> 

Thanks David, I will do it as you suggested and see what comes out of it.

I have one side question you might know much better to answer:
As we have a start and a size for each region, this start is a virtual
address. The firmware/coprocessor that reads the memory and dumps it,
requires physical addresses. What do you suggest to use to retrieve that
address ? virt_to_phys might be problematic, __pa or __pa_symbol? or
better lm_alias ?
As kmemdump is agnostic of the region of the memory the `start` comes
from, and it should be portable and platform independent.

Thanks again,
Eugen

