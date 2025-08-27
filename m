Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BE1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F928E0148; Wed, 27 Aug 2025 07:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2698E0147; Wed, 27 Aug 2025 07:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5060C8E0148; Wed, 27 Aug 2025 07:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBC68E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:59:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA13D59DAB
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:59:34 +0000 (UTC)
X-FDA: 83822392668.24.B39D58E
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id C004CC0013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:59:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=LvNxyW66;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756295972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQaihs8KVNFjFPci/gMTVwx/UBSLhwQ4KKodk3oOIf0=;
	b=stXaLAUFQ4vbaujJL3pIEc0m3m9xTS/lu6rulmHbxTbnzpC84B8+HDsr+HHYYFKvu1ejmK
	LnpaXVxPWyNH4iR1MoP/b53183oGMrpG1LUxTE5+gj3aWNK726XxPxrUsNPsmFhHgI6ZZB
	soj/rgz2N5iXf2Z4Lqh3S5Lvsmex+Hw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=LvNxyW66;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756295972; a=rsa-sha256;
	cv=none;
	b=6gIlR1eIu3jKIO7j4VpDBqtOVTdvTA6eSbvCyfy6qxJe0dEz4hX8X+k04rJDUxx7Qe2V5I
	6cE8ymaRzJFx4/bTxFguwxr99zUoKItOOxLmxB6yQupCC86ZZP3ENEpNMNMGnHYCILHkLo
	x50Iv+ccrvhwBKfYCDtoxB6FjNW/5Ts=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7ace3baso1198139866b.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756295971; x=1756900771; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BQaihs8KVNFjFPci/gMTVwx/UBSLhwQ4KKodk3oOIf0=;
        b=LvNxyW66MC2LBbndkJhjJIbK4U98TETJQHbMS4Zp47DzXu86RvdqOoBhM7xot1urwT
         FjgrgQWSIhW+OZyTO8EM2h98GnrUESf2vmT2MKTEeE6frAvoZXUIdHy8y6ZRqVKRzsn5
         EjdeQhb8dS5oS/Z+FjxFw/HH5G+T+X+Xwep7huw3RpYoyECnwPisWN9+yyczee9twIrq
         qPlHfMZUcnXPtqjowWJNM+2ftDiJnl2hM3tTAx1TMogorf3bAu0+2FTr5zHKawXMk9ps
         F2nJSOv/jibDpn8IiBHlJmcJ0x7URl+EiCzUQA30wOTx/gBZYGxhx7bY4vQlJrBd3nna
         7nuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756295971; x=1756900771;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQaihs8KVNFjFPci/gMTVwx/UBSLhwQ4KKodk3oOIf0=;
        b=aIZD0K3F6p3XxG+u+aEoYBbWbDDjhgnJSFz28okzpB7iPXfFM7d8ckeLm07151tLbo
         x8jbyWnTa/TRNdyA7XI/ux7rVvtl2rJ188B0pN8CD9YX5EW18UfCSSeJ7HSjtE9CP+aW
         Zwaa24eNVCrjKp/oiw3e1lnlOcrmH0EV+/3YNstMzv0ieihnZgroz/bqDNS+ZymV7iBY
         rDU62ZzBLQnVgDU5d0SItLVwt8/yK2wa1ume7gMHY1Ws8ub3Fxd0XlkjU9qcP0cfEQKD
         7Id7BsMLmeeMhJMKvlBtG5VXRDq9h4NxBhDXPcUk2QK1tsGcpDKeHiYK1Wk2EqsPnwXc
         9fDg==
X-Forwarded-Encrypted: i=1; AJvYcCXy6YnhNuxjc07SkysnRAvINDeku8EJu2nkUMYIX73ZXlLrvHnflLmk96wJqTYC2Hcgl3xY8H4R7Q==@kvack.org
X-Gm-Message-State: AOJu0YzfMQ8jeATlCyIm1qP4UIZ0LLdHCllWPNsAEjA47FxUbrptQoWO
	TqEuKvZ6ehB08t7z77z9jkMtBJ4e0FDIhFNtlgkQm2W/eE1Vjni8GIdUp6KcjTi0vJ0=
X-Gm-Gg: ASbGncuOcu62h7no+Ku9Qxsssz0MrCXbGbj9n6T7pxWrKSaZAJwD3IgTl5jLv/3iLC0
	mzTAJAgNZ/Q638IDxE1EWgRkauNEp9zaSotEWdyG9wqRch5Bo2r763ELL/Tjo13LqZ4zzxfe+eL
	+/ZcNLZaWdQF1Uh3OP9ycCzikzpJcpi8ny8fccEhhUAm8RBRLE537Co7UACyrdTvD4fWNJp0N+Z
	GQWGWzpfsm4gyHVtnDLMagUG6I1K8Xid3K4tVJpI7TVc1lgSwxQXlPA6wXBo20Vtmx5TOVin5vS
	MXOzC6l05hou0Mrdw76w0DdZ8nhitNDebN0GnZt/eGDdWZv4/etBOXsl0cj1N7qeTU1d1xXY1At
	LLOKrQ/gGTOMyILNstCksxgKo1+c4Jq9yqcy63yUn
X-Google-Smtp-Source: AGHT+IEwO9j0QYQ4ePdmBR/viBrOcw84xdsurEVIrUknJvIdTDPUSFSZhPjsQi8BtJA/2U4A7NMt3A==
X-Received: by 2002:a17:906:6a0e:b0:afa:1453:6635 with SMTP id a640c23a62f3a-afe294dce99mr1797221866b.41.1756295970665;
        Wed, 27 Aug 2025 04:59:30 -0700 (PDT)
Received: from [192.168.0.24] ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe9c908414sm413654466b.97.2025.08.27.04.59.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 04:59:30 -0700 (PDT)
Message-ID: <1b52419c-101b-487e-a961-97bd405c5c33@linaro.org>
Date: Wed, 27 Aug 2025 14:59:28 +0300
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
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <aab5e2af-04d6-485f-bf81-557583f2ae4b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kcuxstxyrywmtqa66fk3i5w945qotdx5
X-Rspam-User: 
X-Rspamd-Queue-Id: C004CC0013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756295972-915013
X-HE-Meta: U2FsdGVkX19dOvF/VGs3MxU4DFGxnHgS5lpXscGo4KPYOjSY/TNunM/i+i+zbkBsQS+83/o2XQF5TL3Ztvd9NANntFo36ZEJkfwjtvwHxucnigPsD9ZT1oQWHus2Lsml8j2iW4oCk3V9BRFhL1zuGBmikZWvTVP8qzhtzOF/GToBSQKK503gGRR5keTOYKs0dnMeu8lgpKvREh8ZBsZl+fRi8DJScrDh5iJ72xrMC9uZ7k+r1z1Fv4fpF2RWJu+rNihZsANE68R9VMU1XFsNCzKgbfU5aogdKQpw5Tz4p6r+QqI1mh//PxleDg9sU/2XieLFgwq+hSGaohJXoYGtY7mQQ1WpOhbsJYsXrY5OcTxhhXSS10kbCzCVRbrnGkcyFyO4tFXzR1jv34QbInJ37wcWPfyPtJxL5yYnsrlohlpkkT7DvYoir7XSL6gHNeLZi0oBuHLjU5jcFzmuAfSFba8bC/qvi3wf3LRijEDTnG1RT5n1Dqxn854xjKzpP8BdHDe3Zrg83TpbtTRp0AbQH4zRCT52RH0Tpb1acTZmHkBUueoe61o9nQstIkxajXUhv1bstA+NodMKCFpwfXDTEoyWl2MKQL30f9MTcb6g+BbMlnUTV2MK3eoHvt+u5Q5YctgqmWu6fMkZUTcbVDsP/opa5cC8Mea1dOzAQ427T7dHmifoCbFRtw569r2hH0CjILITCAvx3DRGU78YakGJ648gEGN0otNcdeKXMOCS3sN4ROUTOrmFfg+cTm8/X1IBIeKDpznsw1rdDU2bV0lZxH+7f+8QyuLMY9vluWK+XRKMFLVNVP6B3ApxJIMyOn7TruRAqMq9j2bPQczT9m5B557qH/MBXTOu23djZL31e1FX9QXc0E6cIVx0Lbn3mFzjLh2a+j64pntBhxVTvcPINOUokC+dQLBmvlwUYsU95Qn4vpScQ07ENnMC3ID4mysFo0kXRv2wTzmYy4UUEex
 DFaos2SM
 6Mp+31wx2M0MdYw0B9j5mYIRtCQ+iBwCrNcXcDe+CNlozLgBDki11zarkTNnVg2NP7E33Szfi2m1sQ5FtSROObg95nzq0WHN3uFGgG/EYlb4JXg6GFivM6gRj48i/Ynh0TX9Q9qXjE/pLrUVCoj0IvL3xBpXrTcXosTR1AQEnoBW+vTUrn0tncQVtLg9DAbIxMOw4ZjHhW/NwhCjHf6eXr2fq/eHdSy6NJzmanpcJnWJCnkkBkdg2YKXdqLr3L9CzfL4y/p5zZNQ9ZkjHVwarGIdKv5tIydow6Wt9o7cwW+Z1p85E7gJJlwzkPoIvEgzohFYpGFdNKBb7EpnUjpfvVwmJ2bHORFkFH0BI5JFvnOGQFaS9nwoL5t4DPq6X7TNT9e4jmLQLvUsHrFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/25 16:58, David Hildenbrand wrote:
> On 25.08.25 15:36, Eugen Hristev wrote:
>>
>>
>> On 8/25/25 16:20, David Hildenbrand wrote:
>>>
>>>>>
>>>>> IIRC, kernel/vmcore_info.c is never built as a module, as it also
>>>>> accesses non-exported symbols.
>>>>
>>>> Hello David,
>>>>
>>>> I am looking again into this, and there are some things which in my
>>>> opinion would be difficult to achieve.
>>>> For example I looked into my patch #11 , which adds the `runqueues` into
>>>> kmemdump.
>>>>
>>>> The runqueues is a variable of `struct rq` which is defined in
>>>> kernel/sched/sched.h , which is not supposed to be included outside of
>>>> sched.
>>>> Now moving all the struct definition outside of sched.h into another
>>>> public header would be rather painful and I don't think it's a really
>>>> good option (The struct would be needed to compute the sizeof inside
>>>> vmcoreinfo). Secondly, it would also imply moving all the nested struct
>>>> definitions outside as well. I doubt this is something that we want for
>>>> the sched subsys. How the subsys is designed, out of my understanding,
>>>> is to keep these internal structs opaque outside of it.
>>>
>>> All the kmemdump module needs is a start and a length, correct? So the
>>> only tricky part is getting the length.
>>
>> I also have in mind the kernel user case. How would a kernel programmer
>> want to add some kernel structs/info/buffers into kmemdump such that the
>> dump would contain their data ? Having "KMEMDUMP_VAR(...)" looks simple
>> enough.
> 
> The other way around, why should anybody have a saying in adding their 
> data to kmemdump? Why do we have that all over the kernel?
> 
> Is your mechanism really so special?
> 
> A single composer should take care of that, and it's really just start + 
> len of physical memory areas.
> 
>> Otherwise maybe the programmer has to write helpers to compute lengths
>> etc, and stitch them into kmemdump core.
>> I am not saying it's impossible, but just tiresome perhaps.
> 
> In your patch set, how many of these instances did you encounter where 
> that was a problem?
> 
>>>
>>> One could just add a const variable that holds this information, or even
>>> better, a simple helper function to calculate that.
>>>
>>> Maybe someone else reading along has a better idea.
>>
>> This could work, but it requires again adding some code into the
>> specific subsystem. E.g. struct_rq_get_size()
>> I am open to ideas , and thank you very much for your thoughts.
>>
>>>
>>> Interestingly, runqueues is a percpu variable, which makes me wonder if
>>> what you had would work as intended (maybe it does, not sure).
>>
>> I would not really need to dump the runqueues. But the crash tool which
>> I am using for testing, requires it. Without the runqueues it will not
>> progress further to load the kernel dump.
>> So I am not really sure what it does with the runqueues, but it works.
>> Perhaps using crash/gdb more, to actually do something with this data,
>> would give more insight about its utility.
>> For me, it is a prerequisite to run crash, and then to be able to
>> extract the log buffer from the dump.
> 
> I have the faint recollection that percpu vars might not be stored in a 
> single contiguous physical memory area, but maybe my memory is just 
> wrong, that's why I was raising it.
> 
>>
>>>
>>>>
>>>>   From my perspective it's much simpler and cleaner to just add the
>>>> kmemdump annotation macro inside the sched/core.c as it's done in my
>>>> patch. This macro translates to a noop if kmemdump is not selected.
>>>
>>> I really don't like how we are spreading kmemdump all over the kernel,
>>> and adding complexity with __section when really, all we need is a place
>>> to obtain a start and a length.
>>>
>>
>> I understand. The section idea was suggested by Thomas. Initially I was
>> skeptic, but I like how it turned out.
> 
> Yeah, I don't like it. Taste differs ;)
> 
> I am in particular unhappy about custom memblock wrappers.
> 
> [...]
> 
>>>>
>>>> To have this working outside of printk, it would be required to walk
>>>> through all the printk structs/allocations and select the required info.
>>>> Is this something that we want to do outside of printk ?
>>>
>>> I don't follow, please elaborate.
>>>
>>> How is e.g., log_buf_len_get() + log_buf_addr_get() not sufficient,
>>> given that you run your initialization after setup_log_buf() ?
>>>
>>>
>>
>> My initial thought was the same. However I got some feedback from Petr
>> Mladek here :
>>
>> https://lore.kernel.org/lkml/aBm5QH2p6p9Wxe_M@localhost.localdomain/
>>
>> Where he explained how to register the structs correctly.
>> It can be that setup_log_buf is called again at a later time perhaps.
>>
> 
> setup_log_buf() is a __init function, so there is only a certain time 
> frame where it can be called.
> 
> In particular, once the buddy is up, memblock allocations are impossible 
> and it would be deeply flawed to call this function again.
> 
> Let's not over-engineer this.
> 
> Peter is on CC, so hopefully he can share his thoughts.
> 

Hello David,

I tested out this snippet (on top of my series, so you can see what I
changed):


diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 18ba6c1e174f..7ac4248a00e5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -67,7 +67,6 @@
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
 #include <linux/livepatch_sched.h>
-#include <linux/kmemdump.h>

 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_IRQ_ENTRY
@@ -120,7 +119,12 @@
EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
 EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);

 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-KMEMDUMP_VAR_CORE(runqueues, sizeof(runqueues));
+
+size_t runqueues_get_size(void);
+size_t runqueues_get_size(void)
+{
+       return sizeof(runqueues);
+}

 #ifdef CONFIG_SCHED_PROXY_EXEC
 DEFINE_STATIC_KEY_TRUE(__sched_proxy_exec);
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index d808c5e67f35..c6dd2d6e96dd 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -24,6 +24,12 @@
 #include "kallsyms_internal.h"
 #include "kexec_internal.h"

+typedef void* kmemdump_opaque_t;
+
+size_t runqueues_get_size(void);
+
+extern kmemdump_opaque_t runqueues;
+
 /* vmcoreinfo stuff */
 unsigned char *vmcoreinfo_data;
 size_t vmcoreinfo_size;
@@ -230,6 +236,9 @@ static int __init crash_save_vmcoreinfo_init(void)

        kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
                             (void *)vmcoreinfo_data, vmcoreinfo_size);
+       kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_runqueues,
+                            (void *)&runqueues, runqueues_get_size());
+
        return 0;
 }

With this, no more .section, no kmemdump code into sched, however, there
are few things :
First the size function, which is quite dull and doesn't fit into the
sched very much.
Second, having the extern with a different "opaque" type to avoid
exposing the struct rq definition, which is quite hackish.

What do you think ?
My opinion is that it's ugly, but maybe you have some better idea how to
write this nicer ?
( I am also not 100 % sure if I did this the way you wanted).

Thanks for helping out,
Eugen

