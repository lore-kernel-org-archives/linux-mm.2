Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFCB606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pBVMgVLD
Received: by kanga.kvack.org (Postfix)
	id 8DAA16B05B7; Wed, 11 Nov 2026 14:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B166B05B8; Wed, 11 Nov 2026 14:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779DD6B05B9; Wed, 11 Nov 2026 14:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 517086B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:43:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6D1280126
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:43:52 +0000 (UTC)
X-FDA: 85423863504.30.457220B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0090240006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:43:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pBVMgVLD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPQBpyJHjmsj5LG3VBmEeZ6gqORHq46wFNwC+BMZwmc=;
	b=0o1+X2tuJ+rJn82zIA2hUtCbRDiEHBbE3LoXLSdQ7zadm0EW3X7hMTqSxHB3Fl9JJ+HYrr
	uERNpyGNyt6n+apuzCt5CgUiEeIiJVj5iLcN++8tWtcoCg/t/Ehig7Xc9imqJTrGo5k6Oo
	NL6cbG6RN/USfDn3Y/ALh/I9UPgXKPY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pBVMgVLD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426231;
	b=YLoNg2yCcHoFuSfZhRhhR+gAcXJwDh/Ff6YPS9LrTG9dgPx4OdjbuifnRjgOdH36VzW8yD
	0zAGINEg3lWdMttWhX/K+PyENcZR6D/QaHXMRKBQ8htxM+SQIEM1WcWyPdMNp0Jn+IaEo0
	GhYTs3UiWBZYYDqMwS6vNh48UUA2+s0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so22496145e9.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794426229; x=1795031029; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPQBpyJHjmsj5LG3VBmEeZ6gqORHq46wFNwC+BMZwmc=;
        b=pBVMgVLDn2Yop/a2OQO1c5KFolDlhk2DG1aQt6MhquTlAGGSrvthOPufr/KSwDmFa0
         Z3mL8213fA93P7IT/zFlDJaV4135zCtYFmPiNrEXN8Gyc9xLVVXnORYsKHPWzCg5hbmt
         O+Oz7eenTvMwEuJlkprHe/l/VH2k7y4ereH8LTLA067AbPSQc6G7DHlkmRckewvXrDmf
         0wfusi7J2SQpXK253AR/rr39Qjg/i1pBf8Mn7Ex/Xs8nvCMXRR67e4Etk5OBvqsieE5g
         dA37p1tS/Lt0Vn+sXFX9vGh+5X0L6XpZINERpdjkuG739HdjyJKezeolTzUdspLV+C4C
         xh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794426229; x=1795031029;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPQBpyJHjmsj5LG3VBmEeZ6gqORHq46wFNwC+BMZwmc=;
        b=cSM2WJBSlKfwyOmHwsHm0fLjUZQJ9guTlJqzXnBwoklQjdVoRNW19NL//OAYojQYeq
         x9dzA6fXEvOdfn0w9DcNAYs5gVcCrMKg4e9LAE+d6I2XUGtW81al8vXXqzyB0aKU0IGV
         G+UU7FE+kyKMWi49s66f1cthf45x3qeYbmZf3i9I+kFWJSyo1pjguYMFDn7tZR0E/AwZ
         wl5Fu8aHf4H6my/W4lWA7V1NMDqxn5f47C6qTCqqyvI/tJawSq3XU6eU5RrzSKuCAScX
         zQLvF/IcB3zH/6K4LM7E3jLz2fktGd7CoqfJDmF8V3eEWbkx1yInT1ExXxSWgh49Eu2o
         B40g==
X-Forwarded-Encrypted: i=1; AL+hErHz0ghvwKG6vbgTq2IEEaiWufp0lNJx8eavPhDAY18oCPsBhzh6VaOimuXO+YiskAxwQG4sBtghFg==@kvack.org
X-Gm-Message-State: APuU4Z9Rw0KbZtG5SYwOR5kq56b8dpJrhNQrUYlCzAAT63u+6d6DXmfi
	lDJjTjtYHi02mhJNfFYf9GMGNovfnyRpI+ii7CFnO1TS1EVTgGYx8p2EuRZSfrX/
X-Gm-Gg: AYBFou01c1qqAlx0CY4VyIpx62IVvR9ys4kEd363w3s3gUQOHqGbf0oekMqCPgPushq
	siCqAczJHEjfU5no3OVIjIGCPZP+jv7TENDtcVJB8Fvxt/Ct5MGMTaRrCpuiX414z59a6hBAA+e
	iGSjLo10LbuWHMdxceme0sozoB1uN27oq7jJLQO5D5IN3sXvh6SGapUl/D74GquR/Zzep2U8lNc
	WiWPKYHWC684zSZHqO6/mhG31Zd+CgQrL/NdCShbg60rrMioKwgC3a9Q1VXzAW+ZoQFCeKR4Fxr
	gWONpp/7mbdL3d6DA2IvhwuFjdsB+gZcyiPpWa6OaOg4nmcIGxTx2U5p9KJp+FLUrsBlrJD0m6y
	oYYwHl8P0iRAHXd8XinTRj5E1WYM7KrcYA29aBFi7isf8kSQYu67zi2olhk89wlJ6JhuUz8aK2R
	IF+hmmlr1PrlVxsZyHzI6bT+kdoBGf5XSluM73o9bpXSsUvZeIrd8vgtbpVEsqLmjXwL+EN0qCS
	9xFt3PLkEU82SSnp3LV1dkkmEn+THcQ2Khz7H98jgEUv0aYdcuXYOiiDiD6kh8qgoA/sMSzqICl
	BKKLiccUKauAVxd7Jexf9fHCcj1izSzWzu9OgAHy0Jk9HYySSUPd2DqYdJJdjS4Nk1JU
X-Received: by 2002:a05:600c:1e04:b0:4a7:9025:5c3b with SMTP id 5b1f17b1804b1-4ba093b9702mr62316215e9.19.1794426229399;
        Wed, 11 Nov 2026 11:43:49 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e252f7fsm12088665e9.2.2026.11.11.11.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 11:43:48 -0800 (PST)
Message-ID: <60029f5a-091a-4022-ae48-8fb9a00d922c@gmail.com>
Date: Wed, 11 Nov 2026 20:43:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "ljs@kernel.org" <ljs@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 "peterx@redhat.com" <peterx@redhat.com>,
 "security@kernel.org" <security@kernel.org>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
 <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0090240006
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: 6it5o9tyib5hbqeho847xrfaz1qkr77h
X-HE-Tag: 1794426230-905247
X-HE-Meta: U2FsdGVkX18mo/reNsCfHn/qKl1WScrk3qPYSub0V9/3OuD4fYMbo3Ajht7piHcAibMNuWXQEITS2VrG960B4B9LRScnrHH8JsCqGz5h2tnMvx4t7cU5vyXi2QEl7jGKYei3RyxQ0LAk8LP1G/++E2i5tUEXsGoQ2qrcEqdQ/qCFvc/8jur071aKNHiYtJxfeKciQqb1aGCiwL9uzbpJwnchw6b5zgixHR6zYmP6SNdFIztcL9xZCF9Qo2lKYZGZFCwuSMX55nPIELvi3n7JiQmyKGHtgt2i/PUiUsi51ch1kWyK/vewt9lIixVpmnpSIRvEb8yx1ckK0FFN6QXBfccdBAk1m2zsUBzvpIyxMnijakGKPFwzSLJNB+XQSr2iCwO9S7XHPYL3XfSTvnM6nh8iEeB8itA6UGFdHrYhdxXLWhvzHX53obVTYfr4Pnu031dBZliBjyfUd19kv6Tok9OKmMnLQioYgLGXYxPd8/NXmFr6ZCDHebpt5XBI1Jl9Vh3JgVihdEwYGJBvOMncOjr0tQxjbqTgNaQicEprMRIzIPC5S4Fy8wS/fM1dJdj+Vm1wCu13HwhtkZpY29JL20Us0xYln91YPyLZtqJYNi43rWeF5QCPb8KAu5O81aLLsHe576KKh3OI9y7PLEEch6om3zvQwR2EFQzva5NJPH5kHB7YNCvOP2XnqZbQHEpfw7l3QNaqUG8i59uiWVwGpQMSULxbqS5mmgGcpu9+razvXlzNiFKIjqwMIhHvQ3j4tc6haB/IVXEJia8t1OLfbBjWzsl+DVyHkgI+wATxT8KqfUaMi4uumIEUZwuWtA3PqH74lRYu9K2gq3Vqry0+2gCCDxeGLOW33JjHIaL6efn3QQOLPUxGGwFV8aUeUR3BbrONJ25hyeBDeq66hDeG07+yl+z5GZSVF1vvP66PsvGWnZfwFGQ9NzhCS3lQYbAWlu3dAxAP0GiL9bN4evN
 AAhtX2YI
 1noHYyhP05oGsgZFvlkFvw9Qe2iLgmbUJIlfus11caj3Rd3GjAx7QH3LEuv9jgOVdkqHCLjMt2U1yrXtex6aPcaUI+DUUqQ2ui7WpL3CtSbowRARthYJ9ovhhDg+I8e6xqe2FfPjAu9BWYHUIosCy/K7o/peNa1XCmNzR5iAjaf6/lATBuP07Ypvr/7OtMnq4wH6m49WNGuvcTBMJCj3C8ZxfUrTHat3IyNn0xPOofSKgw8YMj+JZHdakDNuozuUelFz4SufGljsKJHHhGKEnKm0z7THpthYg4zi+fK/rKpF7Dv6YxoutjrHLlXaLHYP7Vl6rXyA02dmpNkgv6TNYO/D94wBSG1efhDH+9FqmAd6PY/VO4jvhBKjnsEPY8EBqavKZyrpse1dRLp8zWpDno/bI/4LZhFk1tZt4KBUyWK+6yN+Y913Zwao+JXyA6LRTZl5X+0sb/Da+t/LvRT3FCQsdc8qSR7WA/SBNkPzjSP2K53nql12NsJ5P0cU6tYnFoQqe+R6nqrwjnNoAuEG7c2We0Z712/wlAmz+EdvC4QwNBXWCjD7pBnRSsnVMc5s93ZEIM+iH85JOnWiP4YdhCIow4z6v8joDSkiuF0IAI/ryLNBd6fCSQN+HIrhj3M2+S3H6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 8:29 AM, David Hildenbrand (Arm) wrote:
> On 11/11/26 04:19, Tal Zussman wrote:
>> On 11/10/26 6:55 AM, David Hildenbrand (Arm) wrote:
>>> On 11/10/26 12:54, n3rd wrote:
>>>>
>>>> Hello,
>>>>
>>>> I am reporting a security bug in the Linux kernel.
>>>
>>> Stop sending uffd problems as security bugs. STOP IT NOW.
>>>
>>> Tal has a long list of uffd-related fixes he is about to send out. CCing him.
>>>
>> So this issue was originally on my list and I had a fix for it... but it was
>> REALLY ugly and a band-aid, so I dropped it.
> 
> Yeah, RWP is a mess.
> 
>>
>> I think the real solution is to just add actual markers for RWP and solve
>> all of these issues at once... but that should be a separate series from my
>> batch of fixes (which I'll be sending shortly). Is there a reason RWP
>> markers weren't done in the first place that I'm missing?
> 
> Let's ask kiryl: why is it ok to drop RWP PTE bits during swapout, zap, collapse
> etc?
> 
> https://kernel.org/doc/html/latest/admin-guide/mm/userfaultfd.html?utm_source=chatgpt.com
> 
> states "Unlike WP (which persists via PTE_MARKER_UFFD_WP), there is no
> persistent RWP marker today. The user needs to re-arm the range with
> UFFDIO_RWPROTECT after any operation that explicitly frees PTEs."
> 
> But requiring the user to re-arm is rather questionable design if the kernel can
> just zap these page table entries.
> 
> @Jose, maybe you want to look into marker support for RWP to make RWP a bit less
> horrible?

oops. I overlooked the thread because of the AI report...

IMHO (and after reading Kiryl's email), I'd fix the doc instead. "Scope 
of protection" doesn't mention collapse or shmem reclaim, and it still 
tells the user to re-arm.

I could work on that patch :)

-- 
cheers,
jose a. p-a

