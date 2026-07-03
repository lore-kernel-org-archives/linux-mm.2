Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F81CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255076B00B4; Fri,  3 Jul 2026 04:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205D86B00B5; Fri,  3 Jul 2026 04:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE236B00B6; Fri,  3 Jul 2026 04:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C39E76B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:51:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF86120488
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:51:22 +0000 (UTC)
X-FDA: 84946846404.26.B4DAD45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 82851100007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:51:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QcYMbdgF;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783068680;
	b=D2N1l1iCG3MU2VqQa/cYsjKsoUYSfglg7Chvt3AmfTFqFdzR6b7RKWRXVdKescyPdo9Jj9
	SGelJRCKQT+kn8YkNrrhPP3SjoSfuJ5OVxn7/2L51DLO9aHaVctsL2nFK6qKVcqVHMazsH
	8+ymneFrscqiAO48O9jPaLuRcr32pLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783068680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJAwgSZ9N+lWhcSTPqdOjsrWX1mZ+mtkHDlETjGI0qw=;
	b=ZPcRjDAMo0foXZJ738da4enVeeg+6mEshJ1D4xvZWf81C7z0V541x90Lumv9gr2Df1Djo5
	p9BU74UrhezJfhS7yNBjwKQw3eYP1U51TWaWmB1fxKsmxxLHatCr02DSYXWES7g3eJrmvo
	kTFsSM/UAItTwz3SL8MmoTESmwUkmow=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QcYMbdgF;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBCA56001A;
	Fri,  3 Jul 2026 08:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69061F000E9;
	Fri,  3 Jul 2026 08:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783068679;
	bh=bJAwgSZ9N+lWhcSTPqdOjsrWX1mZ+mtkHDlETjGI0qw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QcYMbdgF6Mz5fC/5+OIcISEIML/hLi20/XfclgLIvxREhH1W52SIRO0kfNwWvcVcu
	 9b07HTep+Jt9Jzxft+/qdGiBxxRwaH7fxeIKfBIprufCOqtU2v7hIA4OtdQcJ7hL8p
	 rqoijW2f+Nm8yBUlaWetRvwJ1/AQd3k88NnoNn+Z9GfzXoClvA9z8+yK1Gn0QRRq1Z
	 dH/HyhrErjcCagjCJaTUvvKwRzbGZFSNMqIytlsF/ldBdF26D2oeObDcLObicnhmrS
	 MuQF4jh3x4gjHFdx13S42I0loT5s0U95oHmEPnAr4uTHhiJbEVwuu/7pGmlNL9cNAm
	 IJsI5HNzZuDug==
Message-ID: <16e9bcf6-3e7d-44e9-8b07-00a694c8e493@kernel.org>
Date: Fri, 3 Jul 2026 10:51:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
Content-Language: en-US
To: "zhen.ni" <zhen.ni@easystack.cn>, Ye Liu <ye.liu@linux.dev>,
 akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
 <d86d309d-9f5a-4d63-afb0-dc4016fe1ded@linux.dev>
 <49526116-ce35-4447-bd98-f5f0ca12d92a@kernel.org>
 <f7bd2660-374c-4b2f-a274-8fd46368abea@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <f7bd2660-374c-4b2f-a274-8fd46368abea@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82851100007
X-Stat-Signature: hermaskc64ygrjte16my7yp7bzh16mco
X-HE-Tag: 1783068680-84994
X-HE-Meta: U2FsdGVkX181f46Xz529ta6Xzgsv26AJr6UVryrWH4QlTwPXGLDTN18GZTRM6MIsRpe0I2C7HmNDj3MleQq1YtxWhgtK1IZi/afNT1nKzXGmpuEbImEnvmxzd53JqMNi/cZByN/Lv/tejfwoJniP8xAvZIJ7acOPJZ911UIZAKPI+jCvh/cHHM7y/OmfSi80huitTFt1lJtmGUAwD+4vvSdlib02kJrbBifPWzLQmqYS7wOupiqX2lZtWTIRrHb2aYRpfWvJTHuLZNoXgi9jDugnvvK265Z8j/J3XMXZ+SDH6bw7B6XsZKPCHUoC7MYXuQWvS4SKTBY16xZg4x64kfClaL0dWgTHXTbx5Cgp3UtqT3xlNNgHNZ4uGk3GhrascFbaC1kZWSBfuCcqDyVP9CflWSzkGXsxLgwYIJdlU59dKC637qiegxKvMC6YVSeG98p0I8yw/9SUsJOFha7ZNkodEbRZbJY7R5B8LQd+N8UqM3xe8D4R4md/Ti4YDRitWKt44nvaMOFtcR9q/BUxzYjk+NIzgbuyYcMyjgn8h7U5Xm6aCvGh7e06vJRBZ70NwWnbfG/4ZtXsvT2h/DuTIsUMR0nz6ULQU1U9NPISS+7j92lFSqUrdpO4U8Vl9jGn5ZUrcIFf1dpQuGKF38DxVln794ujpz0nt0coXbDINxLdcU/LlgTCwrgzFMdcQU/KB0+f8UkulEroF/y1KhVS54ODcNr+UyvzTh+OQJJVU/YkLtG4AKaCIom2MVZ8kp3OltfgusVf9VvPJzG1FCpFgkmO2i+z4ULsqsJ/7L0fuY2XicJA1xc0BVbYYauKKB7qcew9ElLPICTp+zwFDS5VbhXFvRkGpGkDShejwl9ne1ge1u1WJkCMo3jerwMKkkb3PcHyXvyJ+SDV3pw3zWE0ArigBoWBWLNGFgxoGbj9iAxn7NzdAudpiXFaMAXt9lJUytC9tL1jO8uvPopgTSw
 LtFTYMO1
 PGqEFXqAbeHRmPgzBPKnMc/rhUepzGeY6sy0kLkf285MjqtWvdfKNpApnlXzmIEShw6lppHzDSYs5i3GTQELJTCa2fzMqLHzatAf5RNHQhj5qg+hwsUpVEMFLaKJTI3VMyGgKfo5zlgOVyIx5mraiLh6PI9CiD/5eUHtc8FjyDHvzBWC/tb+xjkGCW59Bjp69O9fn7DPAm5A+UUcvE0Tlhf9kKvEe7kgg8RUv6Y0XhzCdGLshDlsW4xIdxD0w842ex96w3ds2FwBrGnJneNOThl6jhgRQSEqOd73spsstKSYev9QmkSF0uwcAA65cNeudUxdH1nmftzlYS/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 10:14, zhen.ni wrote:
> 
> 
> 在 2026/6/29 17:30, Vlastimil Babka (SUSE) 写道:
>> On 6/29/26 04:59, Ye Liu wrote:
>>>
>>> 在 2026/6/25 12:30, Zhen Ni 写道:
>>> Hi , Zhen
>>> The spinlock in struct page_owner_filter_state is unnecessary and adds significant overhead in the read path.
>>>                                                                                                      
>>> 1. Per-fd isolation: the state is allocated per open() and stored in file->private_data.
>>> There is no cross-fd contention possible.
>>> 2. Hot path cost: the lock is taken for every single page in read_page_owner() and
>>> print_page_owner(). A single read can traverse millions of pages, each paying
>>> spin_lock_irqsave/irqrestore — including interrupt disable — just to read a mode
>>> enum or check a nodemask. This is measurable overhead for no real benefit.
>>> 3. No practical race: nobody writes filter config to an fd while simultaneously reading from it.
>>>                                                                                                      
>>> Suggest dropping the lock entirely.
>>>                                                                                                      
>>> Just my take though — happy to follow whatever the other reviewers prefer here.
>> 
>> I agree. If someone is writing (updating filter) and reading (getting
>> page_owner output) at the same time from multiple threads, they might get
>> inconsistent results but that's getting what you ask for. Importantly it
>> can't cause any crash, AFAICS.
>> 
>> 
> 
> Hi Vlastimil, Ye,
> 
> Thanks for the review. I understand your concerns about the spinlock
> overhead in the read path.
> 
> The spinlock does have its use case: it prevents race conditions when
> multiple threads share the same file descriptor and call read() and
> write() concurrently. While we recommend users use the page_owner_filter
> tool, we cannot exclude the possibility that some users might directly
> share the fd across threads.

Yeah and they will then get inconsistent results even with the spinlock, we
don't have to prevent that.

> That said, I'm open to discussion on whether we need the spinlock. As
> Vlastimil noted, the issue isn't severe enough to cause crashes. My v8
> version didn't have the spinlock - I added it in response to review
> feedback.

It was in response to sashiko. Those suggestions are sometimes useful,
sometimes not. It's good to consider them, but critically, and not implement
blindly.

> So the question is really whether we want to protect multi-threaded fd 

We don't.

> sharing or not. Because, the overhead is small in non-contended cases 
> (single-threaded usage) since there are no competing lock holders.

The atomic operations are still expensive and unnecessary.

Thanks.

> Thanks,
> Zhen


