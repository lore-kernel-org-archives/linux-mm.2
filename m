Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4153BCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835178E0008; Wed, 10 Sep 2025 05:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C0B8E0003; Wed, 10 Sep 2025 05:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748F08E0008; Wed, 10 Sep 2025 05:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65AD08E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:54:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0DA11A07E9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:54:48 +0000 (UTC)
X-FDA: 83872881456.26.979EED0
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id 24BFD20008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:54:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFj1hh5t;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757498087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjDGSSxl1bgO/LE+E1oRlyEFsW9DteTvLANxRnkvDNs=;
	b=g0eRDBH06SLKsGjP2mfJIdHwfNquDb5DkJoKJMbnz6DXaQQEoEoqYM6DyniEc34oY0p3aw
	hP/VU8sY0F00tyF1AFcDP2yq9Qw0yCTRQA/9zgU6VXoHxya0Eh5Dyi8v5MooYW3ptJUCCC
	drCHanyuNUm6X1ScyDk3tspZZodCzs8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFj1hh5t;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757498087; a=rsa-sha256;
	cv=none;
	b=i8Kmfe+L1IQLZLiiLgnQqBjY9nKa8O7q6c5RoGiRWnDyTJ6UfMJ4Xz86sPMuBHR6ubF3j5
	T6xibIS5LtuibMzcgnV3E0MUp2rI/9D8nSX+tv7Eqm8vPR5wjlQeymv68BsV6uzvicowAp
	Hm86U7S6RX+GXoNMZ2k0DbuSckezSjM=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b5488c409d1so758383a12.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757498086; x=1758102886; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fjDGSSxl1bgO/LE+E1oRlyEFsW9DteTvLANxRnkvDNs=;
        b=QFj1hh5tsk/jVV1qV6CBXzfoqpT11bQRumA3dSgI3Na00b7PbpdDOHGSlOA4Tu3LYn
         fGTG++IDOVtCx27cjKYB6/ujuSSBEIQQWDv6UquBLzbhH5lnpLlPkGCzg2h8eFKwpyLV
         xL1lxTh4o5L2tOJ8eh8nBmmmbC/jNoT6oTul+NJALl+P4YMly0FDGe75onK964BM7Eux
         jfFvFnWVWHlnIP2+IKgFXy/PsymvuPreI2uJybS7Qcxc0ApiV3fmhybiGFcBSQs0yMj6
         9p7kL+2bP/daIBvJxiZhsqQVHgfkn2asfh3bWdXSoBQV8jgo/k2qh/glFsX583NsVkIr
         eUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757498086; x=1758102886;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjDGSSxl1bgO/LE+E1oRlyEFsW9DteTvLANxRnkvDNs=;
        b=cFHB4zW0A4gcqlAOeFppPpCqEKGgpLRaJmAVuGCQM6qAyjObgISBGTjVV6FlFlCC2I
         w8hMcWnKbwA6RNv+FQVl9SFPdPtmZ3VJznzqWO4SVpsXI6P3u9jtG0rZRmOCjLjqBS9P
         WMHHmMcMOuWCGLSsquubX6xc0lH7/yJvjvzEt+f5LRxTKCK8BtfhmP07QVnYrAq1eeIT
         MPlx/QNwWs9Q/hB/PQAcLGTtfMLxjpJgt3IzT++Ivh+F+EzqErxW1jlnJzNLpNls8xEK
         829aOw2CXbfFvaJdOgGahmoeddO+Brr1K+wx7WcLfS5ssC7QCrb7cfwd3Kv8SUU1OxSJ
         /xFA==
X-Forwarded-Encrypted: i=1; AJvYcCUj8bi4PqR2i79G5Tspdv5fUYev7mkuhykPOo5UJe4azfDkqHkpiIcb8wCq6tRY7ED3+Mle/ZPkVA==@kvack.org
X-Gm-Message-State: AOJu0YxY1H8ImGToHntzMYHOYApniTXix5OLz/GzgJuWY5bVNeJiLGlJ
	KXkGLXg+t6s6O+Op47eSbc8mhsii2HYnflSKHdw5wixOHlD0wDb1Hm/n
X-Gm-Gg: ASbGncuO/bJ42IlQI3A4ILDGEayJkYku1quix+FIqqvgG2f0LelV9b0zzlFWIi+3msA
	pKinErAoIG8ODxggZsfhHlKzsv/0IzVidD0mAXZyBtjwVsMIfvGwXh/GeBMqiSXdTTGsBuKdg9L
	Z/KwjnSbLUGi7tvWAZi3VI7PM5iljYrVrcNQYyEbzCEVlTRpOywEKzNmdy0SXV+5uj4GNLRPqVb
	4BZ5Lnr+89XV68mFKQGNIyk8HFctmYVcVziEEt84OYlWpMziL8OR7KGwXpKCGo5EDf4f6KeciMT
	fxPfUCNyYUtO1INrakkSqyZ7UIyyem7kpqr1gg/Gh+tifo3tyIpxZViPHacxl4rbp4HEnHj7rQk
	0ugwHWtysh2zYcDcKrmYcyFa/LQ4Gj7JHaK8=
X-Google-Smtp-Source: AGHT+IEehJ5C2SQUPQ7Bd8LiQM6dU3/TuGbQPJS5Qg6w1+VDRG8A11HZd7aW9ORjaQ+YrxZYqL3kzg==
X-Received: by 2002:a17:903:3d06:b0:258:2476:77db with SMTP id d9443c01a7336-25824767953mr100948585ad.42.1757498085855;
        Wed, 10 Sep 2025 02:54:45 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:17::10:4006])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a2a344af8sm21714385ad.78.2025.09.10.02.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 02:54:45 -0700 (PDT)
Message-ID: <e82bc49b-a1fe-419a-8a5e-fda70603d2e3@gmail.com>
Date: Wed, 10 Sep 2025 17:54:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/18] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
From: Jinchao Wang <wangjinchao600@gmail.com>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, "Naveen N . Rao"
 <naveen@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-perf-users@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-6-wangjinchao600@gmail.com>
 <20250904063832.GT4067720@noisy.programming.kicks-ass.net>
 <aL5ns7h1NaoD9LPg@mdev> <20250909170017.dae27d8be77f9ec634e0d56c@kernel.org>
 <f73e6e8c-282e-4d3d-9dc9-49f13b20a255@gmail.com>
Content-Language: en-US
In-Reply-To: <f73e6e8c-282e-4d3d-9dc9-49f13b20a255@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 24BFD20008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: be7eeoj5oteb6k8x9ayb4tt6s4w533q9
X-HE-Tag: 1757498086-763478
X-HE-Meta: U2FsdGVkX1+TWzFbuxUUwrDqQ1cJ1xR1cODp0t2wDAV+uKl4FXTlHyy+GFW/V0+hXlFRJ6QoTSlHh8dWR0/QC+NZayX+vvok9lkD7knohLRTBQrXh8Spf6U/YMCsqwq430RCS/vfuxr/acLrpzHDtK/7IH+7wzbmqEgB4YdSJOLqnWnubuVeqLZXhtB2n57iehVAhXaBnIBp2qU0EJxoMO7WHmFD8fnr8p4ZKkPl0P+hHvuhYmo/9GJwtO27M2UdXVetCOvYMAttqhtVLhqhW+zzktSx+mZHZDtShyy95WP9JkcupMwfEIEq4rEp04ZlRjqYI/eMhzqwrIUeO+zALv53I7tAbzi/g7pKqNf9BCkeDiTdYMVy+f49Op3wlTmB+5qV80SKbN96xjvZsnKF/0QBPsDOSrBtSbOSNSysSxS0bNuPUbAb4fgzNf+RhWe205x3W1t0x93uCWhLqp/ZhEQR9k6a0H1qt/DPtyOtLL8hQehPjPltas8F9vWtWPKELepO+EnbyAbiJxfdh0fEm0p9YA2RstfpqZFgQpdlGHGDyztr2NXWmtyWjXv3lrOBU6KSEAKwQh/0Di/pBrZ2DVRUrElCWpPT6T2jv1+BzEHAJGT1pR0egaP7G+mWYjz9SrE2hJJQv76Ob1itpmOTzjhTv3mFi9DduJQJHE6+mabieHpbjcfiEes6wqeL9O2tUB3abeNFv9pb5HpxqynI//Ew2NemBs/KvhWwoq1boteO2Lc6cjZsiPik3uDA9Adg79Z7+gUeEw1HOaIYRuFeU3cqjGIJmLVGsL3fREhpwqFOIW88ZIUf9y9O9y2jQ8q191+XdFvOyTfdsESIGMX0tF5YzLtHbnvxXWZTRd9wFx4ka97bThSHgAf+q6zWnj582wg4jhk+nUCXA1eG5FpW6O6MbLXSiG8zqRXkLkGpwVZUUltpVHyB2fVr5x7lW+aQMBTPjs4qTwZFo2wjXwn
 yq/Vlbg7
 gB1Zjfzv8jx+7usuAuCFugF+P7i4ZtHWQsMXGtkVtNL5ZPlxmG2E64fx6GoMoatCxd7WXpY/plAtT2Azx9193lsGunV0W3VKXRT+CNITi6+uPOerTXN+m++loYsq+ACN3KZsZw568nWIguiwocGUTw+W38g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/9/25 16:39, Jinchao Wang wrote:
>
> On 9/9/25 16:00, Masami Hiramatsu (Google) wrote:
>> On Mon, 8 Sep 2025 13:20:51 +0800
>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>>> ...
>>>>
>>>> Yeah, I think not. For one this is an almost verbatim copy of
>>>> arch_install_hw_breakpoint() with zero re-use. Surely you've been 
>>>> taught
>>>> better?
>>> I introduced this to modify bp_addr in atomic context in my RFC series.
>>> I thought it was clearer to split the introduction and refactor.
>>> And then It was used in the wprobe series, so I left it as introduced
>>> in the RFC series.
>>>
>>> I agree your suggestion is right. I am willing to refactor after 
>>> wprobe.
>> I'm OK to refactor it to reuse arch_install_hw_breakpoint().
>> My point is to have CONFIG_HAVE_REINSTALL_HW_BREAKPOINT so that
>> we can easily implement the dependency for other features which
>> requires this feature in Kconfig level.
>>
>>>> And why would we want to export guts like this?
>>> I wanted to introduce a real-time stack corruption debugging tool,
>>> which needs a helper to change bp_addr in atomic context (kprobe 
>>> handler).
>>> And wprobe needs it also.
>> I agree with Peter, it should not expose the architecture
>> dependent code directly. Instead, we need a wrapper.
>>
>> Thank you,
> Understood, I will use the wrapper instead.
>
>
Hi Masami,
I would like to ask for your advice regarding a development workflow issue.

I have a patch series that refactors |arch_reinstall_hw_breakpoint|, which
I know you are using in your |wprobe| series. My new feature, 
|kstackwatch|, is
dependent on my patches and also on your wrapper patch for 
|modify_wide_hw_breakpoint_local|.

Since we are working on different subsystems with different maintainers,
I am concerned about how to handle the dependencies between our patches 
to avoid
introducing trouble.

What is the best practice for this type of cross-subsystem dependency?
Should one of us carry all the patches until they are merged, or is there a
standard procedure for this situation?

Thank you for your guidance.

-- 
Thanks,
Jinchao


