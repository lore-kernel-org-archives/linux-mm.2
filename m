Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00655CA0EED
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 14:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63816B00AA; Sat, 23 Aug 2025 10:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B246B00AB; Sat, 23 Aug 2025 10:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78796B00AC; Sat, 23 Aug 2025 10:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B84FB6B00AA
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 10:09:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 187B614064A
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:09:03 +0000 (UTC)
X-FDA: 83808203766.01.CB1C4BC
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13BEB14000C
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 14:09:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eiJAAQte;
	spf=pass (imf09.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755958141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6N4AN/Y/D7dp0HndfnRPdy0zt4T/cxocCywAgoacTDU=;
	b=FU8RF8WiAylYMckvYSuzKBpbCfQWXDtSMGafoI5Pv7D2omOlOUXxbOCp7jexamGvQEyRfa
	IzySI6Jui6AheIU7KVLi5sfrmHRMw+Rhk5s93t5YyTAz9dYPZNN1EycJTwl5wd6y23J9x3
	LMae42PG8h1V5MxRNwNSICfSV0GoPek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755958141; a=rsa-sha256;
	cv=none;
	b=zso9dcvucwGWtqYE8EtDW+Z4dHIQd/BSxIMMzAJfxYanJ5+VaSZaP2nsGXPz1Zk5U89Jau
	ODAiToooSrh33aNyzyZXdJ65i2gVcyknojsxj/5I7hdpyx7D6kyS69rUcGPoul9YFtDDlG
	NgeEMUnZa5vjHq1ngHMJCuEtwrzdi+k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eiJAAQte;
	spf=pass (imf09.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45a1b0b4d13so3842055e9.2
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 07:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755958139; x=1756562939; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6N4AN/Y/D7dp0HndfnRPdy0zt4T/cxocCywAgoacTDU=;
        b=eiJAAQteJsPnG3EyrQm1UXsywlgKMtS/YXqpwRVW6v93CP4S7i0ZEcd0IC2KywcuZx
         6Ssr4GJyWoZN9TqfU6G+dq185lEBzW1J5jBiTAaEtD2FPL7Ck9Wi8YDOERMmVBqAGv+g
         PGXMcWuCePtB0vMX7LZ3cZgLUK9F4Oo2vDLV5HKsW9wDk5L7h7FbHbKRpGiVWaz7VJC4
         iA+JPIdCVpa8SvqQ0Z1YV2NiHgI7tn7v7krpESldFujJrsSs1mLHzZO5q20SrZ4GqBLN
         ydyNKZuMVbg0K0sROz5Lexf5FZsatkzZI/TbFN7VgewfHzHDyZabXtXXyDUAs1WopZ50
         Sx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755958139; x=1756562939;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6N4AN/Y/D7dp0HndfnRPdy0zt4T/cxocCywAgoacTDU=;
        b=m2xwhyRNcGLzBofNtL37XaHXrCFvcEWIKjjYwO4UrvP3G5As3/+oyBQocouivaVY7u
         QubE3vxMwmY5BGfSZOwUwkipH3L0LYkIyb2545ItBrdb4NmsGtyUQgCZKK2xwunFTE9u
         DEVmcabUcUqPoruwoW1UQ2r/oAVdqJnoCQt5lhkzVymsq2KBTe5xPpyzYbyZ6GE5Z8YT
         fgFoQ9EPjD63PGpwlkzgXwB7yRYl+2ZMUlzMVzZISNIpUPVRbl8TQULrcTHtPwerz18C
         idM9T41BkN/2YCXnJReueinE5bgPCT7Qk1ZmLMpSHMJ4itrHQvk/HTPjt9Yk9gnNfuT3
         EeFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXekMQT0rO6PRmve9lEPNy2wZDnM78t8/Pg7couH6GjhUfQTgiUZPgohFWGXO4J5okHOWlHC75GPw==@kvack.org
X-Gm-Message-State: AOJu0Yzl4uNC7HIc1c+x72QQQBv6Cpys6bvWLYEwqPE20NjQB+nir+t9
	+nN+YECuKvF5/yPDO0fg8U+bRF0kxYDfiX8aWZgKUBYFyBSiIQbgdqPk
X-Gm-Gg: ASbGncsbihhdwOGhxW15J7u1g8sHm7FlTgcvQnK0n2XMLQ/rwwaRFGUcVGr4PLb3jC3
	R198ZOx/5lkvkaXVByLoYiQ62vDRdQPMoy3svZNk0ojD5g7N+pkll3IL7nZCEbiuVqebRECeocg
	+wE6Qx6oWOLi4gSfb3GqD47Q6Qkui+GXEDHroUTTHvSSekPjzcWeu1FPy9wGoQYqiCw6MYQzNSc
	VqoELdFUctVnwEpnbflA5yY/HkhCQgv2P42dr2TYroyu4FExOCnScaRkX1qUdektRgLIct/ONxq
	KryqKzibJxic6ytrBMXhHRyGk0Wrs8Jh9bBIcEL5yuXDREzo7tls+AHq8fWQ5dIko2DpGVkoDvW
	WVOSHv7JOmHplq6qE8Vkh4Z4Tn+6plPXaPjkma1QvETBIpGAiyyi3
X-Google-Smtp-Source: AGHT+IGWtS/Lb299m9NjusG8Fgziqg/tOUQirr+93j1uqVHL7+y5z/IekZWvnr7oe5w+c2JneXBqFw==
X-Received: by 2002:a05:600c:1ca4:b0:458:b6b9:6df5 with SMTP id 5b1f17b1804b1-45b552ead7emr22894025e9.1.1755958139123;
        Sat, 23 Aug 2025 07:08:59 -0700 (PDT)
Received: from [192.168.100.6] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5753503esm36496645e9.1.2025.08.23.07.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Aug 2025 07:08:58 -0700 (PDT)
Message-ID: <a3f9e0fd-28fd-41ea-9c78-e3c971e7445c@gmail.com>
Date: Sat, 23 Aug 2025 18:08:56 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: sunjunchao@bytedance.com
Cc: axboe@kernel.dk, brauner@kernel.org, cgroups@vger.kernel.org,
 giorgitchankvetadze1997@gmail.com, hannes@cmpxchg.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 tj@kernel.org, viro@zeniv.linux.org.uk
References: <CAHSKhtd_oM8yXBwgm1-6FGhDEaDGCWunohMnb4AtV8Y-__z-zg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <CAHSKhtd_oM8yXBwgm1-6FGhDEaDGCWunohMnb4AtV8Y-__z-zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13BEB14000C
X-Stat-Signature: fn6xq43ygjdzrnproxtsixhoct15ndnc
X-HE-Tag: 1755958140-453175
X-HE-Meta: U2FsdGVkX199xqhbG/xL1e7c3jZF/aIUhE3p7hup5rEMyb+ybASbFxIL+2ftmYqcgfx6LD9QDq/6yI4u9NaW+ZdgJ9QJC4lryEqQNgJMzE0PWirLPh5DCRtgnSlz6U8Ka9Dqr/zdDiWFqrTbw7lgFUtbqv8eiopnHc5IIcjclmu5xdgBkr2UhnH00YPZyMFWw+17gY/H/kegLyX+tsdfgaa/Bh9HVHhHPsig5lvHlswBeLKbgcmTmSMnBqz6WL4d3vdCMGhEdXhl6/myH5cnmbTd6jKf5ksdzvzh2XpbKmjKteRqGiASNC4iwa3mC5qqdE1AOXlwBnlhHGH+KMQTRITgQQD/422uGtg/yMtMTZza4Ek4Zyw3DZJqClQSAMJy3Nzi9OYVsCaEGA6u2DjT8tSr05CfCEkSpgK4ITA3/klh4rSqaP2ZRRR6mVCNmSLNRbECcjTpN9B5UkmhoLcEBYMihNd2rEEghpEOgpFmMJiMbFb/NWsaxsQK/5r4wiqd4bPTloekwAltQckaavFO8FX7UT0s9KIOQ4gSUeP9HvHR3RJrNijfvOPiu/zNQRtNaNMw7Y23FvvukNdQtiP2qF6qLncsaJYFqLDG92Vho4ClMZfP1eXkn/dGHUbX31NvfnabGXu3FG1yKmrVp8DLVdYneiKPrZXZQhFCveryTPbaYEwTVKhPJZmmFS2Af6WyzqZOeY5VHjU4yPL8aFmWIaSOXOfWbo2SBaE9P1p5IELac1yv+wJxRCVtrUvDrgRE7Bqr/ku9TZQIgb4/hDIBmvwL22vkAlWs/6f2wiRhjQ+7E8QHVK9OnokZa2kPIXdfN2ahFkovc5CLcJNLoc90lH8Tpm/i3VRDYHJPHVOuAzX6jXakLXh5s27qTeQWKApsJTZ+VFaRW5Jt9GcuUiQCeLFo9WpDzb/R3hb1KQcvPs6iJjMz+8cRo59qGCNzNR2HOf7HIDp574gQUxgKaGU
 XF03VB5E
 cI2jmVGJucd10HfvasoOkHpqyu79tssMxO78E7z5nViKa7apXFltzD84m4tJOwWwk7EjPgJkB0eJ+oKSbPOhvW+JoMTfUDPvR5x0wqQjVsmmh9pwiv5jbfm2lsI5Ipy5uiptShGccN+IMMld5OS/iwMOqOyfAOQ7++VleuF7OhLQ50DsFk5BPDnsCFT+0MwL0CdVzZeM+u5+mmnyTwyLje9hwJ9h28ZHBeY1ljAHNl4pF+4txmnRSUpj/IIUPoShzzHQPuuPT7WPrhd9j77JnABX2/oZgVYauoFyx8bHLVnHrPqNxwElGFAgzLbd4Kz3Oj2TCgw/87QAVH5G+j6IlOHyAD27wt5B4Bj/D1qnjbM/us2UnABz6RdbLmD+6EnbwNtVNNQxhLkWyXRyhi0ucXAvH7YomzmZU/rPHxpqoBPiXYcMV2OfBB3ZvTjFykmN+NP5JKoRjZDjRWQGP5o0frdz8GYvXb7/hQXuMibDsHj8MZMULjeUs+zVO2f/RosS9sTpdHFQDtaEb7B1/fpfrJPtiUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Makes sense, yeah. What about using a shared, long-lived completion 
object (done_acc) inside cgwb_frn. All writeback jobs point to this same 
object via work->done = &frn->done_acc.

On 8/23/2025 12:23 PM, Julian Sun wrote:
> Hi,
> 
> On Sat, Aug 23, 2025 at 4:08 PM Giorgi Tchankvetadze
> <giorgitchankvetadze1997@gmail.com> wrote:
>> > Hi there. Can we fix this by allowing callers to set work->done = 
> NULL > when no completion is desired?
> No, we can't do that. Because cgwb_frn needs to track the state of wb
> work by work->done.cnt, if we set work->done = Null, then we can not
> know whether the wb work finished or not. See
> mem_cgroup_track_foreign_dirty_slowpath() and
> mem_cgroup_flush_foreign() for details.
> 
>> The already-existing "if (done)" check in finish_writeback_work() > already provides the necessary protection, so the change is purely > 
> mechanical. > > > > On 8/23/2025 10:18 AM, Julian Sun wrote: > > Hi, > > 
>  > > On Sat, Aug 23, 2025 at 1:56 AM Tejun Heo <tj@kernel.org> wrote: > 
>  >> > Hello, > > On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun > 
>  > wrote: > > +struct wb_wait_queue_head { > > + wait_queue_head_t 
> waitq; > > > > + wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > 
> wait_queue_head_t > > itself already allows overriding the wakeup 
> function. > Please look for > > init_wait_func() usages in the tree. 
> Hopefully, that should > contain > > the changes within memcg. > > 
> Well... Yes, I checked this function before, but it can't do the same > 
>  > thing as in the previous email. There are some differences—please > > 
> check the code in the last email. > > > > First, let's clarify: the key 
> point here is that if we want to remove > > wb_wait_for_completion() and 
> avoid self-freeing, we must not access > > "done" in 
> finish_writeback_work(), otherwise it will cause a UAF. > > However, 
> init_wait_func() can't achieve this. Of course, I also admit > > that 
> the method in the previous email seems a bit odd. > > > > To summarize 
> again, the root causes of the problem here are: > > 1. When memcg is 
> released, it calls wb_wait_for_completion() to > > prevent UAF, which is 
> completely unnecessary—cgwb_frn only needs to > > issue wb work and no 
> need to wait writeback finished. > > 2. The current 
> finish_writeback_work() will definitely dereference > > "done", which 
> may lead to UAF. > > > > Essentially, cgwb_frn introduces a new scenario 
> where no wake-up is > > needed. Therefore, we just need to make 
> finish_writeback_work() not > > dereference "done" and not wake up the 
> waiting thread. However, this > > cannot keep the modifications within 
> memcg... > > > > Please correct me if my understanding is incorrect. > 
>  >> > Thanks. > > -- > tejun > > > > Thanks, > > -- > > Julian Sun 
> <sunjunchao@bytedance.com> > > > > > > Hi, > > > > On Sat, Aug 23, 2025 
> at 1:56 AM Tejun Heo <tj@kernel.org> wrote: > >> > Hello, > > On Fri, 
> Aug 22, 2025 at 04:22:09PM +0800, Julian Sun > > wrote: > > +struct 
> wb_wait_queue_head { > > + wait_queue_head_t waitq; > > > > + 
> wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > wait_queue_head_t > > 
> itself already allows overriding the wakeup function. > Please look for 
>  > > init_wait_func() usages in the tree. Hopefully, that should > 
> contain > > the changes within memcg. > > Well... Yes, I checked this 
> function before, but it can't do the same > > thing as in the previous 
> email. There are some differences—please > > check the code in the last 
> email. > > > > First, let's clarify: the key point here is that if we 
> want to remove > > wb_wait_for_completion() and avoid self-freeing, we 
> must not access > > "done" in finish_writeback_work(), otherwise it will 
> cause a UAF. > > However, init_wait_func() can't achieve this. Of 
> course, I also admit > > that the method in the previous email seems a 
> bit odd. > > > > To summarize again, the root causes of the problem here 
> are: > > 1. When memcg is released, it calls wb_wait_for_completion() to 
>  > > prevent UAF, which is completely unnecessary—cgwb_frn only needs to 
>  > > issue wb work and no need to wait writeback finished. > > 2. The 
> current finish_writeback_work() will definitely dereference > > "done", 
> which may lead to UAF. > > > > Essentially, cgwb_frn introduces a new 
> scenario where no wake-up is > > needed. Therefore, we just need to make 
> finish_writeback_work() not > > dereference "done" and not wake up the 
> waiting thread. However, this > > cannot keep the modifications within 
> memcg... > > > > Please correct me if my understanding is incorrect. > 
>  >> > Thanks. > > -- > tejun > > > > Thanks, > > -- > > Julian Sun 
> <sunjunchao@bytedance.com> > > > >
> Thanks,
> -- 
> Julian Sun <sunjunchao@bytedance.com>
> 


