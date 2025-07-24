Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD6AC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 19:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31ABC8E00B7; Thu, 24 Jul 2025 15:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2808E007C; Thu, 24 Jul 2025 15:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0E28E00B7; Thu, 24 Jul 2025 15:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8A48E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:16:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEE62111B3E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:16:07 +0000 (UTC)
X-FDA: 83700113574.10.69B6379
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B74C20008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:16:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MyPx7zk2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753384565; a=rsa-sha256;
	cv=none;
	b=XqL/vxIebffojqvMxJ67uZEBV1DqUsjFcQXGH7/L0ojVyZM8tKBqPoxcVMQDqmimYbInVV
	NH8GN5ycuzp/j20LYxxkvN344pPzzNwUuMryt/9H2oaaF4LJRm+n8WQWFQsl8bCg5aTet2
	egB0TnkZVEmLFJ7NgN7KwVFnrXeZ3Ts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MyPx7zk2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753384565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JroCquJ2N/9P4PgYxL/uw2uhd9P40fm8biIZJBC9nOc=;
	b=6dNqPqaX17XpdpOwyXQ7QuklFJwMJDbWFvAwUxZjBrsLpdnaQkNJ+eTE8AZ9aGs+HdPYO2
	NWNMT4xbzQvHCnP5xvclTxK3IvpIYAOH2kAG+gHbPRXwr2Fz1Bxxt8PKZ91AxXh5EYVCs4
	or8XtOUA4NbjayZj1lxTwXwPKeY06g0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753384564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JroCquJ2N/9P4PgYxL/uw2uhd9P40fm8biIZJBC9nOc=;
	b=MyPx7zk2v1iDZF96Jhi/II25x7heUNxGH15HD7Nk9YSrDL4cdQvURMOkIUCLZQgOylUKLt
	Z5BmfED4zMKwvw5YNgnyt+bz1bkq0xeGi+S2pUFeN526knk/zs+BAhix08lJMXmJP8u4qM
	0wqu75rriVkE1hCeKviZfQ2vrEYcz8U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-r8TYiDxiMhGq7hqyc2cbIw-1; Thu, 24 Jul 2025 15:16:03 -0400
X-MC-Unique: r8TYiDxiMhGq7hqyc2cbIw-1
X-Mimecast-MFC-AGG-ID: r8TYiDxiMhGq7hqyc2cbIw_1753384562
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-adb32dbf60bso169404866b.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384562; x=1753989362;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JroCquJ2N/9P4PgYxL/uw2uhd9P40fm8biIZJBC9nOc=;
        b=kYokv6qOpW8gZEulKR0L5I82FMYiQ+c9dC1mS+q0iR2LcugeJj7ii9OoCIUjscv/+j
         UO5pPqu5p6lcb5cIFjk2wsgqPX/OEU/4SYsLWxd0ij9uGBfx114+9BjUECiInuwoNzuC
         ngYalMWOzSYSWu02pHfF00EVRBJqj5g5phe9tZ72NdeHSmgejjck9XkLP5Z4TIg3TdUt
         /8SUpolfj1TqBFcjPx8Sl3o14V2ciIpqJYlxGS2ZtTfT5EuRf7wft2xlc59/4NfCDB1B
         zmguRWu6Txl8ZodenVc8c80fl8zaWDW9a8jvXZ34lAK+fa8kyPFj3pOgxeT6NCJW+SgK
         nRyw==
X-Gm-Message-State: AOJu0YxaFAXnPTW4AvAQBCwb7Eq7Er84Y3Cbu5udrKZDa9VindgAEuzS
	/TjdiDQlR37XDk++Cs+Ak2GygQlZslEKVOHHJTx4eskY/zs3CswzwSoZ8XxekIGDhL7XfNXBGFi
	PPFEK1Rp5dete2O+0ykclJTXzh2ulGslCnGcyAbXsVp61YrAwQJF8
X-Gm-Gg: ASbGncvExMdEUE4AgIjgLIjMcaApMKyNygxgmaidWlK4MLX/TXH7z8o0iF3X+4PzVK5
	RGKJWgwc+Ga/f+tXu2r0AU0LpmASbBnjZXGRn9QG42t9p6/PL6rRI0Ysz8LQ1i02IHkoasvhH9r
	4cGolbSpZph70cP3S+NEi0VFin7aXZR5TAEVWY/bS+eHW+KZNJ7F4nggcQ3JRXSXV3ZY9kxlipq
	f/0UkR+EKy03oN5LTJvmUvXr1a3oX13hj0JBxR4rZQh0i10VaViSyKnWexGYu3DcJc/PyZVWPes
	YV0OwENzmOh8v12z7Q1ihHfHViPGPBoSbRe4gBZCYe1lUhYhlqEY8HSb3OeIQ5AVSTZyC4rp1gg
	0u8NOPDZ1M0sqPjPG4//35zLlvrN70WUUzFP4GVGaTAIh7Bu0i6HKrhfD69bwH7DTQIU=
X-Received: by 2002:a17:907:e916:b0:ae0:d38e:5852 with SMTP id a640c23a62f3a-af2f885a6bdmr920605866b.39.1753384562009;
        Thu, 24 Jul 2025 12:16:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEu0koRqgoAG3Cni1RYCd4sAXADnOmfGnRrtCgM7GWwt7Ol/1KPVQcp4wXhSJm6qyxTuGAPAA==
X-Received: by 2002:a05:6000:208a:b0:3a5:25e0:1851 with SMTP id ffacd0b85a97d-3b768eb077emr7272886f8f.7.1753384071638;
        Thu, 24 Jul 2025 12:07:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc605cfsm2899678f8f.13.2025.07.24.12.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 12:07:51 -0700 (PDT)
Message-ID: <601e015b-1f61-45e8-9db8-4e0d2bc1505e@redhat.com>
Date: Thu, 24 Jul 2025 21:07:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: Usama Arif <usamaarif642@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, SeongJae Park <sj@kernel.org>,
 Jann Horn <jannh@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20250721090942.274650-1-david@redhat.com>
 <3ec01250-0ff3-4d04-9009-7b85b6058e41@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <3ec01250-0ff3-4d04-9009-7b85b6058e41@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Lc8TtvTsCbBeHqonITZ4Je99xnX2YCf8OqV_DTk68Wo_1753384562
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B74C20008
X-Stat-Signature: xybmihshnuck84nxs3rmpd7qg18pkuxa
X-HE-Tag: 1753384565-39673
X-HE-Meta: U2FsdGVkX19+Uy8iOjQFUPHGRJgr1O/BR7eYYFg/HNXq70RNOzoK6+tk2ORhQ/LQUOzQIdh8FM4M/+PJoQKhPuNYzZONmZcZFAZG1zzBZYaqZPqG5h7PX5Fe+HYPRWUdFuWk1AoNPflSsyhDusgkC+WyOouzCMaEHAVoZwmvfCCYsq9+D/tLJoAlCJPPvoNzJOGY6EIzpyPYsKzNvv9iI4rkHnWrBBSfZ7KyirPK6DgtHZP2IjNx40pu4tdUqwbmAf21L28O7Uo/bpE5TY8mdv/8VqAMTBFJjIOV4zHBh8vYfqnClOQktCyqZRL3e9XGhvN+EmZ1omaP8XXp+FNv1nBCiKTryjyiyMdXg9SYqxP+APaPViNKjDp8vEP2damOCO6XAX8T8P9Qu1kQfCiLz/1sojDGAuTKUKr1+3Oh3JY06Gni9xAUExzUZBXFeppAZZWm0jXGKMbOWjg5gdwEP6XWjouk65vOCA0roIcff+It+Awn2SMqrdK81a/8RBYLuDwc6NVugopTOMkGxMEmp90bWk1NlwEefzURSqMm2B4lyPZVGtEI8ldEWVsKeoF3J5S6xYgZkmnKWt9p51YQ8zoEq8VcT2nddflBFQLKwbJL7CBlUHax1fA9BpUBuR+ggE3tW40djYjhJlTXD6a4urFQaRGpxL1BT88RHH8AN/TuJjGJuZVEgGvHs61y8v1w2g8eNNbHPZVugcY/ouwERLDhowOpCnGjz3GmsKaAE+p0+R9reBnpK6auk3j8IMl/8h3D2KpfwilgwlfuPV7SlQmrBNs7s3HZkyM5COpPatLglvqPGtsZuwKZAVmeQNXgNa/eoStx6Tt076PgUVClc3vzKQdS+2ReR/1CAPtmgi0nkv3IqBp2NWMf5pC1BuNl5fmHmP2WHFu1O8wOdziemq4X9JclgsJGNIo+lQmP1iTkVTaRbvTANmxULuv28LZ6Tr+zHpFvjVXe0W6tGcU
 ginPUa8e
 wFM57Qnu/Hg6uQ9erQf17IlHKAORIcX3k0j7VimFn0B41ZUJe9rIXVnqBNLWU/RdYotoPC6sbgZDUuWSc5WOVGLcVD1c8V8dm4BxBTLyctiZZi7ltAvIm0l0dD1CkwS37g9emIrWy2mRO1MFXdn1Owku9qVLat2/WKyyQIyocWPzWxxblE8z8+S8006x/cdJu3zds1COuMW7+7jBB2MKdH1obW/WmkDEGI2DyyWQS2PboBxN7RaZU9CmLKq3Rvz5wtZ3k1n4kb/k5jaskC3N02sTMaP14q9t2tLh68goPXh2xyqz6OkUHDBv825ZhW4Bwju82RlvQXHxoTyW7qZRZ0ZE3uxXdWCYeW6rXQ61oWqiqQIODjsnzdz3j92dk+I+Uf3LpNu96E3ZgBmvuU9UJbvVhKvdVPk6EEOIpfQu+KfyoCiNxQhmF1sN6huTTmwvofl4zZZPXATncGpdssM/5w3dgOfgMqHT/cmu4k2wMIUiI/Y3f9t6MaXMvjqTsqeFS6sHNJ2rAC3PvE9CF93RFp8tM0iHmIGCJw14QUMmeDoJLhfcwJCpCefk2TzG3uDMnPWpl7BxYsDBrP9ID1UzhF5jM/TC9Pcrifxpl1ajrk8QOxruNDeGz5kajNY24reVUhINUP96yeE2ZQuou/lu96yxxvFRgcgAPw7wIAMpQ5oIIaVa1alcMC7IYMAiUfpqb4pI2Lu2wrzyRdvaFiPuWNI3Tb40XGV+kfXa8m0LQKcMl9DD2S72qPD2dUaTROqw/fYLAERKqgJHK+zPoWB3GL/POAJTrkQ9OyA0efLObYW3JxDfL8rWK1seFRskMnNPXDhKYc2Lr4NLuIw3Pz2e+95fhtUsK4MRKGUXX2By/J4aYAWljfIUht0pk+xRSDiFbZFSqFpp/i8rj2hA6qDWWk3mJrbp1kal+otGSYmKMiSRQq/86Zf82F+ddYX1LkmuysA2sdsTnVuad3EUhYLBFECPTO8TU
 nh+ZVJVE
 d01tINTy/ldSX3rjVOGyul+zSYNdmhZ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 20:57, Usama Arif wrote:
> 
> 
> On 21/07/2025 10:09, David Hildenbrand wrote:
>> People want to make use of more THPs, for example, moving from
>> THP=never to THP=madvise, or from THP=madvise to THP=never.
>>
>> While this is great news for every THP desperately waiting to get
>> allocated out there, apparently there are some workloads that require a
>> bit of care during that transition: once problems are detected, these
>> workloads should be started with the old behavior, without making all
>> other workloads on the system go back to the old behavior as well.
>>
>> In essence, the following scenarios are imaginable:
>>
>> (1) Switch from THP=none to THP=madvise or THP=always, but keep the old
>>      behavior (no THP) for selected workloads.
>>
>> (2) Stay at THP=none, but have "madvise" or "always" behavior for
>>      selected workloads.
>>
>> (3) Switch from THP=madvise to THP=always, but keep the old behavior
>>      (THP only when advised) for selected workloads.
>>
>> (4) Stay at THP=madvise, but have "always" behavior for selected
>>      workloads.
>>
>> In essence, (2) can be emulated through (1), by setting THP!=none while
>> disabling THPs for all processes that don't want THPs. It requires
>> configuring all workloads, but that is a user-space problem to sort out.
>>
>> (4) can be emulated through (3) in a similar way.
>>
>> Back when (1) was relevant in the past, as people started enabling THPs,
>> we added PR_SET_THP_DISABLE, so relevant workloads that were not ready
>> yet (i.e., used by Redis) were able to just disable THPs completely. Redis
>> still implements the option to use this interface to disable THPs
>> completely.
>>
>> With PR_SET_THP_DISABLE, we added a way to force-disable THPs for a
>> workload -- a process, including fork+exec'ed process hierarchy.
>> That essentially made us support (1): simply disable THPs for all workloads
>> that are not ready for THPs yet, while still enabling THPs system-wide.
>>
>> The quest for handling (3) and (4) started, but current approaches
>> (completely new prctl, options to set other policies per processm,
>>   alternatives to prctl -- mctrl, cgroup handling) don't look particularly
>> promising. Likely, the future will use bpf or something similar to
>> implement better policies, in particular to also make better decisions
>> about THP sizes to use, but this will certainly take a while as that work
>> just started.
>>
>> Long story short: a simple enable/disable is not really suitable for the
>> future, so we're not willing to add completely new toggles.
>>
>> While we could emulate (3)+(4) through (1)+(2) by simply disabling THPs
>> completely for these processes, this scares many THPs in our system
>> because they could no longer get allocated where they used to be allocated
>> for: regions flagged as VM_HUGEPAGE. Apparently, that imposes a
>> problem for relevant workloads, because "not THPs" is certainly worse
>> than "THPs only when advised".
>>
>> Could we simply relax PR_SET_THP_DISABLE, to "disable THPs unless not
>> explicitly advised by the app through MAD_HUGEPAGE"? *maybe*, but this
>> would change the documented semantics quite a bit, and the versatility
>> to use it for debugging purposes, so I am not 100% sure that is what we
>> want -- although it would certainly be much easier.
>>
>> So instead, as an easy way forward for (3) and (4), an option to
>> make PR_SET_THP_DISABLE disable *less* THPs for a process.
>>
>> In essence, this patch:
>>
>> (A) Adds PR_THP_DISABLE_EXCEPT_ADVISED, to be used as a flag in arg3
>>      of prctl(PR_SET_THP_DISABLE) when disabling THPs (arg2 != 0).
>>
>>      For now, arg3 was not allowed to be set (-EINVAL). Now it holds
>>      flags.
>>
>> (B) Makes prctl(PR_GET_THP_DISABLE) return 3 if
>>      PR_THP_DISABLE_EXCEPT_ADVISED was set while disabling.
>>
>>      For now, it would return 1 if THPs were disabled completely. Now
>>      it essentially returns the set flags as well.
>>
>> (C) Renames MMF_DISABLE_THP to MMF_DISABLE_THP_COMPLETELY, to express
>>      the semantics clearly.
>>
>>      Fortunately, there are only two instances outside of prctl() code.
>>
>> (D) Adds MMF_DISABLE_THP_EXCEPT_ADVISED to express "no THP except for VMAs
>>      with VM_HUGEPAGE" -- essentially "thp=madvise" behavior
>>
>>      Fortunately, we only have to extend vma_thp_disabled().
>>
>> (E) Indicates "THP_enabled: 0" in /proc/pid/status only if THPs are not
>>      disabled completely
>>
>>      Only indicating that THPs are disabled when they are really disabled
>>      completely, not only partially.
>>
>> The documented semantics in the man page for PR_SET_THP_DISABLE
>> "is inherited by a child created via fork(2) and is preserved across
>> execve(2)" is maintained. This behavior, for example, allows for
>> disabling THPs for a workload through the launching process (e.g.,
>> systemd where we fork() a helper process to then exec()).
>>
>> There is currently not way to prevent that a process will not issue
>> PR_SET_THP_DISABLE itself to re-enable THP. We could add a "seal" option
>> to PR_SET_THP_DISABLE through another flag if ever required. The known
>> users (such as redis) really use PR_SET_THP_DISABLE to disable THPs, so
>> that is not added for now.
>>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Yafang Shao <laoar.shao@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> ---
>>
>> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
>> think there might be real use cases where we want to disable any THPs --
>> in particular also around debugging THP-related problems, and
>> "THP=never" not meaning ... "never" anymore. PR_SET_THP_DISABLE will
>> also block MADV_COLLAPSE, which can be very helpful. Of course, I thought
>> of having a system-wide config to change PR_SET_THP_DISABLE behavior, but
>> I just don't like the semantics.
>>
>> "prctl: allow overriding system THP policy to always"[1] proposed
>> "overriding policies to always", which is just the wrong way around: we
>> should not add mechanisms to "enable more" when we already have an
>> interface/mechanism to "disable" them (PR_SET_THP_DISABLE). It all gets
>> weird otherwise.
>>
>> "[PATCH 0/6] prctl: introduce PR_SET/GET_THP_POLICY"[2] proposed
>> setting the default of the VM_HUGEPAGE, which is similarly the wrong way
>> around I think now.
>>
>> The proposals by Lorenzo to extend process_madvise()[3] and mctrl()[4]
>> similarly were around the "default for VM_HUGEPAGE" idea, but after the
>> discussion, I think we should better leave VM_HUGEPAGE untouched.
>>
>> Happy to hear naming suggestions for "PR_THP_DISABLE_EXCEPT_ADVISED" where
>> we essentially want to say "leave advised regions alone" -- "keep THP
>> enabled for advised regions",
>>
>> The only thing I really dislike about this is using another MMF_* flag,
>> but well, no way around it -- and seems like we could easily support
>> more than 32 if we want to, or storing this thp information elsewhere.
>>
>> I think this here (modifying an existing toggle) is the only prctl()
>> extension that we might be willing to accept. In general, I agree like
>> most others, that prctl() is a very bad interface for that -- but
>> PR_SET_THP_DISABLE is already there and is getting used.
>>
>> Long-term, I think the answer will be something based on bpf[5]. Maybe
>> in that context, I there could still be value in easily disabling THPs for
>> selected workloads (esp. debugging purposes).
>>
>> Jann raised valid concerns[6] about new flags that are persistent across
>> exec[6]. As this here is a relaxation to existing PR_SET_THP_DISABLE I
>> consider it having a similar security risk as our existing
>> PR_SET_THP_DISABLE, but devil is in the detail.
>>
>> This is *completely* untested and might be utterly broken. It merely
>> serves as a PoC of what I think could be done. If this ever goes upstream,
>> we need some kselftests for it, and extensive tests.
>>
>> [1] https://lore.kernel.org/r/20250507141132.2773275-1-usamaarif642@gmail.com
>> [2] https://lkml.kernel.org/r/20250515133519.2779639-2-usamaarif642@gmail.com
>> [3] https://lore.kernel.org/r/cover.1747686021.git.lorenzo.stoakes@oracle.com
>> [4] https://lkml.kernel.org/r/85778a76-7dc8-4ea8-8827-acb45f74ee05@lucifer.local
>> [5] https://lkml.kernel.org/r/20250608073516.22415-1-laoar.shao@gmail.com
>> [6] https://lore.kernel.org/r/CAG48ez3-7EnBVEjpdoW7z5K0hX41nLQN5Wb65Vg-1p8DdXRnjg@mail.gmail.com
>>
>> ---
>>   Documentation/filesystems/proc.rst |  5 +--
>>   fs/proc/array.c                    |  2 +-
>>   include/linux/huge_mm.h            | 20 ++++++++---
>>   include/linux/mm_types.h           | 13 +++----
>>   include/uapi/linux/prctl.h         |  7 ++++
>>   kernel/sys.c                       | 58 +++++++++++++++++++++++-------
>>   mm/khugepaged.c                    |  2 +-
>>   7 files changed, 78 insertions(+), 29 deletions(-)
>>
>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>> index 2971551b72353..915a3e44bc120 100644
>> --- a/Documentation/filesystems/proc.rst
>> +++ b/Documentation/filesystems/proc.rst
>> @@ -291,8 +291,9 @@ It's slow but very precise.
>>    HugetlbPages                size of hugetlb memory portions
>>    CoreDumping                 process's memory is currently being dumped
>>                                (killing the process may lead to a corrupted core)
>> - THP_enabled		     process is allowed to use THP (returns 0 when
>> -			     PR_SET_THP_DISABLE is set on the process
>> + THP_enabled                 process is allowed to use THP (returns 0 when
>> +                             PR_SET_THP_DISABLE is set on the process to disable
>> +                             THP completely, not just partially)
>>    Threads                     number of threads
>>    SigQ                        number of signals queued/max. number for queue
>>    SigPnd                      bitmap of pending signals for the thread
>> diff --git a/fs/proc/array.c b/fs/proc/array.c
>> index d6a0369caa931..c4f91a784104f 100644
>> --- a/fs/proc/array.c
>> +++ b/fs/proc/array.c
>> @@ -422,7 +422,7 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>>   	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
>>   
>>   	if (thp_enabled)
>> -		thp_enabled = !test_bit(MMF_DISABLE_THP, &mm->flags);
>> +		thp_enabled = !test_bit(MMF_DISABLE_THP_COMPLETELY, &mm->flags);
>>   	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>>   }
>>   
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index e0a27f80f390d..c4127104d9bc3 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -323,16 +323,26 @@ struct thpsize {
>>   	(transparent_hugepage_flags &					\
>>   	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
>>   
>> +/*
>> + * Check whether THPs are explicitly disabled through madvise or prctl, or some
>> + * architectures may disable THP for some mappings, for example, s390 kvm.
>> + */
>>   static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>>   		vm_flags_t vm_flags)
>>   {
>> +	/* Are THPs disabled for this VMA? */
>> +	if (vm_flags & VM_NOHUGEPAGE)
>> +		return true;
>> +	/* Are THPs disabled for all VMAs in the whole process? */
>> +	if (test_bit(MMF_DISABLE_THP_COMPLETELY, &vma->vm_mm->flags))
>> +		return true;
>>   	/*
>> -	 * Explicitly disabled through madvise or prctl, or some
>> -	 * architectures may disable THP for some mappings, for
>> -	 * example, s390 kvm.
>> +	 * Are THPs disabled only for VMAs where we didn't get an explicit
>> +	 * advise to use them?
>>   	 */
>> -	return (vm_flags & VM_NOHUGEPAGE) ||
>> -	       test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags);
>> +	if (vm_flags & VM_HUGEPAGE)
>> +		return false;
>> +	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
>>   }
> 
> 
> Hi David,

Hi!

> 
> Over here, with MMF_DISABLE_THP_EXCEPT_ADVISED, MADV_HUGEPAGE will succeed as vm_flags has
> VM_HUGEPAGE set, but MADV_COLLAPSE will fail to give a hugepage (as VM_HUGEPAGE is not set
> and MMF_DISABLE_THP_EXCEPT_ADVISED is set) which I feel might not be the right behaviour
> as MADV_COLLAPSE is "advise" and the prctl flag is PR_THP_DISABLE_EXCEPT_ADVISED?

THPs are disabled for these regions, so it's at least consistent with 
the "disable all", but ...

> 
> This will be checked in multiple places in madvise_collapse: thp_vma_allowable_order,
> hugepage_vma_revalidate which calls thp_vma_allowable_order and hpage_collapse_scan_pmd
> which also ends up calling hugepage_vma_revalidate.
 > > A hacky way would be to save and overwrite vma->vm_flags with 
VM_HUGEPAGE at the start of madvise_collapse
> if VM_NOHUGEPAGE is not set, and reset vma->vm_flags to its original value at the end of madvise_collapse
> (Not something I am recommending, just throwing it out there).

Gah.

> 
> Another possibility is to pass the fact that you are in madvise_collapse to these functions
> as an argument, this might look ugly, although maybe not as ugly as hugepage_vma_revalidate
> already has collapse control arg, so just need to take care of thp_vma_allowable_orders.

Likely this.

> 
> Any preference or better suggestions?

What you are asking for is not MMF_DISABLE_THP_EXCEPT_ADVISED as I 
planned it, but MMF_DISABLE_THP_EXCEPT_ADVISED_OR_MADV_COLLAPSE.

Now, one could consider MADV_COLLAPSE an "advise". (I am not opposed to 
that change)

Indeed, the right way might be telling vma_thp_disabled() whether we are 
in collapse.

Can you try implementing that on top of my patch to see how it looks?

-- 
Cheers,

David / dhildenb


