Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10766C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00C76B0088; Tue, 22 Jul 2025 14:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7766B008A; Tue, 22 Jul 2025 14:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6686B0098; Tue, 22 Jul 2025 14:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8F06B0088
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:41:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BB521A04C6
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:41:45 +0000 (UTC)
X-FDA: 83692769370.08.551ABF1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 257E94000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:41:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XXaqL0Z5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753209703; a=rsa-sha256;
	cv=none;
	b=qPLrPG622yozAEj6J4/gwlQUA554g6Qttl6QcNf7mq+Nd02oRwASj+PiwITXVWnny+VzNu
	NaBHhRSlHYdDpMjbQbKWiXJuVoBLHVxnZx9RTq0vWwei8PVQ/IAdCufOgOPZ9sRYwb1cfd
	GXbrbe7CUqMgk2t+2NEBu1RfMnRDEHI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XXaqL0Z5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753209703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yE2tHddyKrIJYsdGOME7S0MXHkPfwwNA1+RUdibZkzI=;
	b=sCl1p4oL1YHMuoNk4GHG9PFR83ZuK4aSgy2wvT0J+qDMFaVlxhL8nUVrG9dVBMmFFQR2br
	4rasfS1HBT77bJIhC6KJbkAepH35tr9wcDsMGYz9uWaZkDvl3fjXf/DTOPJHHwon+fF3KS
	PmDUcgrDsCkYx4edel6Y4T8BlEIgaKo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753209702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yE2tHddyKrIJYsdGOME7S0MXHkPfwwNA1+RUdibZkzI=;
	b=XXaqL0Z5XsWhH3xGzQTolJJ67PF75fsbfJFNOPCIINHQ3BA5aPzah3meMQ9q7OQ6OPJkR+
	yuX/CeXHjiVYXXtlO6Dz1xpDgTOg/pYAVU2psVpXi3u3xT35t80yhEosnYYJW+nLFmWQi5
	CltGpbRykXq+ZLo6SdLhY9mGE5/svfs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-Ts4vKBMdO96jW9AIU-DOAQ-1; Tue, 22 Jul 2025 14:41:41 -0400
X-MC-Unique: Ts4vKBMdO96jW9AIU-DOAQ-1
X-Mimecast-MFC-AGG-ID: Ts4vKBMdO96jW9AIU-DOAQ_1753209701
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-702b5e87d98so105591016d6.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753209701; x=1753814501;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yE2tHddyKrIJYsdGOME7S0MXHkPfwwNA1+RUdibZkzI=;
        b=GXW/tL0OD6HM04IURMrKJc8KCaYL4UvY8/OmARdSyXlRyHQJXrY98rgNEp+yVaRUJ3
         o6dkif2rp8DfVRenGUq/kFZYL6ifVvbkZkRIDB2kiBJJZ54qdmnGskmR4CbCHucOQXlA
         8FbDctEjNDw4Eu3RK5sgJwVawgYt2a1IhlOgaBuGePTRabq6IMntgYiSbotO1UkOKOEX
         mcbq6kppHkAjH2cgh5FJYkUBjgP+/MYfvZyXRmSItTZ2e0UjDn7Wj45cAa76l945gN9L
         uqCytRlehiVTrmw7gMgZW6S7qQhCwEfA124ZeU8xHsMng03jInBMlIdifuVbzefLQVpb
         kFlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPo/C1Bfu+o5tM1OAOvrSIlfMmPUCMFup0CRxG1etwIRo7aFgjiDxNic89roz6HkO+BDNKfZEn9w==@kvack.org
X-Gm-Message-State: AOJu0YzV1hSFxGB3hqYfobK3xKdo2TaSHzKaUH+E5rrD3ro8Uvla6dzw
	2nCH6qpZ7YVoLDaPc1MeODcYsrIqbw9f3seQVl0KE+TkklZRUczupvr0+PhddlaTL+ynq1TI5xF
	7wBI7xnqek5nWu001if1/r2andKnUi/xzWd9wNRNzxZJmBblGsRSC
X-Gm-Gg: ASbGncuJp+Ki+LKD1gmsPiutF7w+raI9Dq1dTW1TJvm/AVkY2vUwuMELqKmSpNAyYQC
	j7bi7R9QEtrrBV7PKq2uaTeKAabTDZ5QPGr1CjBiBQTx9cZL2BCIF+VVrBVL0BTUBlMjx6uiw8G
	0oeGX1jkke3IbJHng7OmPyiuhVTkaUqxCrEOszg6vjY/Tsz25WdHbGvJ/T6z4p4Kqf8AtsKKn7D
	vA/326rcZapLSmodg9TEK+AzJCKFHBNjyTWPQveHpfpz1WjlqgbRsBNqs4/CILfxY/atIhKLiGE
	PbAR/z7QVlAl5Rkp9utOdLfxYDnPrY/hvz/82PkLaqiC91rEaXLCqvsvkhN/6mU+UOO0qXwZyCr
	ZZ1BMr1r7WA==
X-Received: by 2002:a05:6214:528e:b0:6fa:8c15:75c1 with SMTP id 6a1803df08f44-7070058d077mr2886916d6.2.1753209700796;
        Tue, 22 Jul 2025 11:41:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyxyagFJsSlRVWyR3oQBKxo8hm4VSSyBCBCDh68tTOQPIpBZKEnj0FI7ZeFaiDUe2jYRvO1g==
X-Received: by 2002:a05:6214:528e:b0:6fa:8c15:75c1 with SMTP id 6a1803df08f44-7070058d077mr2886596d6.2.1753209700301;
        Tue, 22 Jul 2025 11:41:40 -0700 (PDT)
Received: from ?IPV6:2601:188:c180:4250:ecbe:130d:668d:951d? ([2601:188:c180:4250:ecbe:130d:668d:951d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7051b90616asm54508526d6.35.2025.07.22.11.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 11:41:39 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <3db01bc9-f6ea-41f7-8cbf-fb33e522694a@redhat.com>
Date: Tue, 22 Jul 2025 14:41:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Kuniyuki Iwashima <kuniyu@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Daniel Sedlak <daniel.sedlak@cdn77.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
In-Reply-To: <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x1hqwGQIPLiUZHAh8iF6SaOxDS8dRN7J6D2IQ3ENihQ_1753209701
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 257E94000B
X-Stat-Signature: f3woxo6aka4uh1bb86pu8xscrox1bpth
X-HE-Tag: 1753209703-225020
X-HE-Meta: U2FsdGVkX1+UiqmIkNorox7PDDI1dcyPisfQsZ/iBsSnNWP0Ngs7Yn9eeBipuo4/+fsdGuqKFAqkJP5xMwaaGvvF4JPAzvMgYdKmvyq8lNR1/9qBmMXo1nE4Y1wmzqwBCmuPb79FKhJbYmopTvw6q4Ec45J+whFWG/kYiAKEddS4Nyaj8yNJWGs1KPygCbNMcDIrA6fsHKJjcBPUT/s3GHfqqHeEs6eg05Lbo75bPl7fWATndcf9bygXixQzzrwQ3inxpE2JFNx6dNsUNe9CYRo8gMg4JyrUmfAY/n9OMkzMjm3QNHZcrk5YOHsv5HVsoCwIookW+/djNtIYwQCaMQ7OIZYsq/0ni09988bCA6l8SWsfzbX3hzhILuzGlDt8ZWVjW91knxJie0xsdENEIR9g0irFFeAeBAqqt2hzF+hcHfHk8smkMBAz6tC53Z766YYd1bR9F1HWq4squGAalx4PHcilcL9AajigViRpuzAn+2xiHZMDL5F82PMTttlTk0QCY4mTjEIjOosqzDSXCUtsDkwRi5YebgpGGig2DXjFgxi3gP2U80+XRBaP7FnVLF7IYWQ4xnS5HGyHC+H6VL6BOSPKKYKY1A2SANeH9uWxVgaVEpL2l0RmXlwyvq5R8FeAGVNWOp5+fw6e2RuC35PCw0mTAsj/rH4qnraV3+uM2YHw4Ae2EuW4xaZ3jW0V4g+GiV11KE9q7CNATI7A6KCbzg4Nd9Rk40ScN1IZP4u4A4GSskd8vHAoIygw5kLKKCifiATX2ZeBQP7psLMc7hV7rABMEmL/3it+l1PgZXv+YH+8TiAPRnz/1CROym1KMq9wSrQ9yAFuEAu7i6X2Que94m0OxFDGpf98uZAinMmbjKoMmsbn2FbouxEf+bFq6LnC2XlASfmugsWdB6Bel8Az66xdROrhZgHkh7jVa3SrNT8VvWDzAZbz3ND4itGf9ATtKsjx2+cciy/+xd+
 Hs0424tT
 A7pfrsvdIaBpHmvbfZ+ccgw6gXvSGIGTvSA8gpFiTDWuNyygcLcqTUSxPzbo36hMXzl24IQkIuNN4aDZesg4ZTXrD5USvZArJMRY2yGnRzGIUH4JPLyGHwz8QVjwnElf2xQti7PGoeqnaYSXwr1wm1wozXfhM6LyPNP6cv72XRJESGc7HTM6VP2mUMDL31+4zHJNcY78qP/352JGuFDfFY1M9NKIFJ4C5n3mlPHPGQQ6YliawHogBONBX6spwmbK9enNSJWREbZgsiwjuAg2U2LBcnWvx/qRVOkDbr3U2DMql90TVW0mr55c4CAUw4QWMRzWXA78TPDoHHIr6LS8IxPB9FihbodGd5i8qtdw/A7gVTPHdEeFs8JsgSa5s5DskikfUl7tO+oeYg16fyhUcExcPaTLdpKC2C1InMh8oU2kyQstmD9SPVARSQctWSe8c4+TEghknA3SrzrqxPM2ksQzfO7xOn+AOG6NlCPPzfgScDJLiJGW9q6niLTSOFuX0WWvO8tfCww8NRikkeK/+WRAB2CSkWDiYU8nQzWgBVOk1GwtxRR/8iFQQ3nWe7a/CFcAyDnFjqi/Sch6ymTWj8CkQBuRaLN7YWFwqWlPKSlRwJ8PfDEx42gXtUFsOB/B3G8N4NmH4XKjU7YB/ybB495U3VsaCg5R1Fur9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/22/25 2:27 PM, Kuniyuki Iwashima wrote:
> On Tue, Jul 22, 2025 at 10:50 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>> On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutný wrote:
>>> Hello Daniel.
>>>
>>> On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@cdn77.com> wrote:
>>>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
>>>>
>>>> The output value is an integer matching the internal semantics of the
>>>> struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
>>>> representing the end of the said socket memory pressure, and once the
>>>> clock is re-armed it is set to jiffies + HZ.
>>> I don't find it ideal to expose this value in its raw form that is
>>> rather an implementation detail.
>>>
>>> IIUC, the information is possibly valid only during one jiffy interval.
>>> How would be the userspace consuming this?
>>>
>>> I'd consider exposing this as a cummulative counter in memory.stat for
>>> simplicity (or possibly cummulative time spent in the pressure
>>> condition).
>>>
>>> Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
>>> thought it's kind of legacy.
>>
>> Yes vmpressure is legacy and we should not expose raw underlying number
>> to the userspace. How about just 0 or 1 and use
>> mem_cgroup_under_socket_pressure() underlying? In future if we change
>> the underlying implementation, the output of this interface should be
>> consistent.
> But this is available only for 1 second, and it will not be useful
> except for live debugging ?

If the new interface is used mainly for debugging purpose, I will 
suggest adding the CFTYPE_DEBUG flag so that it will only show up when 
"cgroup_debug" is specified in the kernel command line.

Cheers,
Longman


