Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B07E7AD71
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 22:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7EEF6B0088; Thu, 25 Dec 2025 17:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C572B6B0089; Thu, 25 Dec 2025 17:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59556B008A; Thu, 25 Dec 2025 17:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A65BC6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 17:28:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01D7013479
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:28:06 +0000 (UTC)
X-FDA: 84259432614.15.84C938C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6BD0540006
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:28:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PCdCFSAt;
	spf=pass (imf01.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766701684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeNHvsN1ZBvb8Hdsv//kNjFTWoycJwfijVViJF41qv8=;
	b=gXiJ5ERP2TwiuEBLlk0geLDJCbbpYo7mYhyG6sUa0PwrXZ5o71QPG89XCeYrPyKLkOenqd
	WJXMUiOMjN12fo5VgKjB+A8zB6qKr+2ovFNdlA4utriXbncwsV1qoli6NELIJPOH88Knx3
	PpMZ7LIxQEwHNa69ckvAx5gf0eo6mYI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PCdCFSAt;
	spf=pass (imf01.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766701684; a=rsa-sha256;
	cv=none;
	b=hnF5CoHmSqp6R832BnK9tFsWld04u1SMuUxnR94z4CYa+kN6vXW1dVkK8nMqZWMffxMRKO
	4kjUnzuufuY3V3CQYO363CaHz4QsKGWwmGArGxDYw8XVa3+Q5PQW8T8mTN6+svLPdh4VKX
	I+Cm+OeqBlRLUckz8SjMrUj0MvYCNB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766701683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PeNHvsN1ZBvb8Hdsv//kNjFTWoycJwfijVViJF41qv8=;
	b=PCdCFSAtG4TG9HasgqE1DxfE7R4yZvzB+i46bS2DHCchhr/U3P4Rv8F/z/AwRZcHZ68Fa8
	VC9k1ufis1a40u7opA4JYy7KOs+95bDvRzxgbnGDGRfedrbiand90vtSbfpXA+TxyoHWo/
	hl3uAjQkyNosEey6GFUr7Q+5vm7cnbU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-nMRSGD7TNsSTkp0fulb79w-1; Thu, 25 Dec 2025 17:28:00 -0500
X-MC-Unique: nMRSGD7TNsSTkp0fulb79w-1
X-Mimecast-MFC-AGG-ID: nMRSGD7TNsSTkp0fulb79w_1766701680
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b2217a9c60so2521841485a.3
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 14:28:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766701680; x=1767306480;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PeNHvsN1ZBvb8Hdsv//kNjFTWoycJwfijVViJF41qv8=;
        b=Qy1dCYAh1xk1IQScQiZsku/aC5krz73MuP6JtB5ZR2hXYZHz36keohyxQN/k3na6ax
         LicSw9urh51s8ziam1SIymKZaV0g105xJ7H939VsfpM6Iw7uHxfxrsTZlWuTSWn85b/h
         w7dyhrP60z1zGq2urUq8WuGRx8jvSuPynOBZHQNFB+IDV2aqkBp5wuE1fcGCEh0+WN7j
         hvHdpaBno/H3Cya76taVX/ks17dPoGZNHGrqNt1A07h4Y8ZnGKrTWmPX6G6qzUzFB8vm
         xUTbFr1cKrfOAeivbUS5Oe4qZ4OeQiadXcyFQoi3si62RZm/XHMm68Sb3hMSE+8LUjAD
         fIOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCd0ucVNePEGxP5s+FGbXrtIDWsvcuDyL4TjdHLRqldwXsoRFiGk3Qi3DUmIIcjs2NxBbnTtv1gA==@kvack.org
X-Gm-Message-State: AOJu0Yypx+fF5lnfFXXqyMCeArVVC6HLj6qzdTleWhM5KFbZZht/WmLK
	ktvAR3uiKVAS7rFutXRKBxeA/xuw7Y325IbUjZIAY3P1ZfUOG6FtXCUyXWQuZCFx+PUY7GiQv7v
	u+OA5BB1Xgp5h71Tfl63ua2YdOAQ5P1vHGWCoRznDWuRNX4rnkNPH
X-Gm-Gg: AY/fxX54tkwr0bVrdQhD9ExbKaitQln/lL3c3/uS1jd9BxXol/7QdKQPzwEk0Mvahyi
	4UWqjGvYfih5eCLskmRuQkfuTzjMyRDEl4vmkzLx2/apVn7qXZyRErIVvRdpu8V66yNh65dHJtw
	SfsrcN5Hhwb/nJ++2XtW+FS5r/TajHrZBzbqCWbmWalH8D88/Rkqd8ntW5AFtSnkrg8KCmZ31v8
	lgqgkeX9OiZZfs+KrfhPqChvvGLnizIHnYD4ikHiWK0gwKWI3MaE6ai6yZ2jNudCZAYrNE/9t4Y
	KN7KxJrzrxIczvayljTsQpkBCyY0W5gN0LY6y/eGoBt9LOtsNiM6iwWnhhYiKaSiFwq+1UZTuJn
	xfTat4HMoeJYxUSMxgf1OGn+Fq0U3aBHC7EhIs0Zb7/g8fZbxegBrVaJN
X-Received: by 2002:a05:620a:414c:b0:8bb:26db:e22f with SMTP id af79cd13be357-8c08fbb5432mr3197585985a.30.1766701679921;
        Thu, 25 Dec 2025 14:27:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkk34PfoZDZVXHOsdvaSoOtEJlSomrI6NhnO1ciZ/uaqISBnHAQBKZ+i37TxyEDRNXrTUZhA==
X-Received: by 2002:a05:620a:414c:b0:8bb:26db:e22f with SMTP id af79cd13be357-8c08fbb5432mr3197585085a.30.1766701679541;
        Thu, 25 Dec 2025 14:27:59 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0970f5fdasm1605628285a.35.2025.12.25.14.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Dec 2025 14:27:58 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <04708b57-7ffe-4a97-925f-926d577061a6@redhat.com>
Date: Thu, 25 Dec 2025 17:27:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/33] sched/isolation: Save boot defined domain flags
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
 <20251224134520.33231-6-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-6-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: inI3atcbSAQSU0AU1DHO6MrP9_0J80d6EN3lT1L1gnM_1766701680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6BD0540006
X-Stat-Signature: n648h85tuhwpcmrkfehuhmdhkywmcwga
X-Rspam-User: 
X-HE-Tag: 1766701684-713868
X-HE-Meta: U2FsdGVkX1+SZJcU1sosoOzgmElpluCQlyJv//bElp6lF+Q7jyuareIlwEaeb8QV8TbTE9Lbw5iPQaOoKao/Ng52Q+wE9jfmHc04dOW7GI+oe2ANIIjfgAsFwrcnOXejjQBG03LZ5giyIxziaLQWOwnD+vvQH3PA5Pqg8hIF1VAyHQW3IRB/7KWLaRGQErApCjbi3mBcnBiKcVbtN48OnsrTlWr2qROQ0tjGiAqKy68rj3ayhj4P/HQTBmZlnczDdym7+fb3Ywn5+9fn/TGnyBOwqlzV4a5ZiB46imUAvZi7KATDO0YrhispCPtFJV73b79sfM4L1OkEbZSkCRdRiNxlMyrVeXeKtLT1CBC4mObjCNck+WMmdMxHxUeb69xaRlCPy2ThL1jwCrkX7daUzeoZYXBzzrRVfeS/cynPlcrgcaEXTc2D3RdchwJHvHq0/XvrThO99vmNl+CPt2GCqxyhzVyAKkf68YwIbCbOCrjaUrJw+tHtab6VyDoxpuJTS7DDVdn2mD+QkHHVUK6wX8/SIhrTIXtaazfbWMnclp6exAa9sPjixxrhsLJ2kU0AtfKLfCxFIImt7XVInTCNcTnKHgOp5CXcG9BO2349vMqsw4MkV4wesPjiUn2wLyeCbynsBrqKCC4LtsoibmLv1/yTQSzRo9TtEl8KJwCbGAyhQbxGyAaOglk6Sk322fvspWt6vxBL/5JjS/VekDDviut0QmG4zbpXYLNHV8DZFV+uc6R5GzI0oZ/HOUm4CmYBIuLcXyMfKkhLqZfrbHA/RQTflp5mn79wvJKfkNskCTFBktPz6RnAYMO/2YPogkKVmxmjutHeJ+cZN0lNnG5cBpwItWVoMCGV81XjWlJSWJf/PV9irLjno0UpbjlXxm5H15F/aM3OvGoEZSIB/PzpSUK5OwNq5Tdh2hUvVaQPfg2myfonmQhk/2jOLSfbnDZXM/OjWFW9H8CkdafoaiN
 8jeKULZh
 FnxUd09PZFGzCGPRmfcYWxZZvLApK74j0n0aHGv65GD0/raLA43v8X7P0qGWzuQc1SjIKfL8azRfvrltVhoBJ8O9HSuGmRy3Bj+ucXR/3oSFnEV0yyK+z88vfxn4f/ZZ4gwKUX3D5nvQ4jLLBSQ0hx+WTYQImuwOyfnMpHHHHR+6NhBbJ4leX4KB877sgli4uSWlLDFX3Abled2uugbDwP6/RlTufwX+2KsMZJpsB5dkLqqlVEJFCs8UnjmgCWHZAg8m33wtjtrpXwLKKjlk0+Ix/SDhXMv78Ehsa3ebT0IY6Vz6BMqFOQ0mw/v7H/pRvRVUEjcgbHHwmdeCY8c6wyq6pbJEovIa2woZUgOHpyuU6nd1bh4M+7BpHHmUOEVUMtMnjdKRQKlnF0qSqKsO2Sxc34CpopVpWdLp1EGPwEwJYt13219TUsZq1po9bgm5WEQ+CwmsUSjR1ME32/TOlqXRGHeoNa0roUyoXJLL8o1OdAqI5sXj86sDMuN89QdtvodHuc0/9uDG0bO1GoiuXpKJ5iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:44 AM, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
> but also cpuset isolated partitions.
>
> Housekeeping still needs a way to record what was initially passed
> to isolcpus= in order to keep these CPUs isolated after a cpuset
> isolated partition is modified or destroyed while containing some of
> them.
>
> Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Phil Auld <pauld@redhat.com>
> ---
>   include/linux/sched/isolation.h | 4 ++++
>   kernel/sched/isolation.c        | 5 +++--
>   2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index d8501f4709b5..109a2149e21a 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -7,8 +7,12 @@
>   #include <linux/tick.h>
>   
>   enum hk_type {
> +	/* Revert of boot-time isolcpus= argument */
> +	HK_TYPE_DOMAIN_BOOT,
>   	HK_TYPE_DOMAIN,
> +	/* Revert of boot-time isolcpus=managed_irq argument */
>   	HK_TYPE_MANAGED_IRQ,
> +	/* Revert of boot-time nohz_full= or isolcpus=nohz arguments */
>   	HK_TYPE_KERNEL_NOISE,
>   	HK_TYPE_MAX,
>   

"Revert" is a verb. The term "Revert of" sound strange to me. I think 
using "Inverse of" will sound better.

Cheers,
Longman


