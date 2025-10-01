Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E83CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562D98E000B; Wed,  1 Oct 2025 10:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A848E0002; Wed,  1 Oct 2025 10:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429158E000B; Wed,  1 Oct 2025 10:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31FC18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:40:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9053136EDC
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:40:05 +0000 (UTC)
X-FDA: 83949805170.29.8676A8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5318918001D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:40:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LjXD6g5j;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759329603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owbaiW1xpzS8vT38zdTBLv0coUdQJNTI68ZZIQGXnXc=;
	b=hIipEopXVQ9GCuGyVXy9QEBR4h8qEfZyycNCZ9NwARRwEso0Gi11+4AhAPyZIOzIb6b+nd
	hRNzWMZsc+C/D0kvhmLkta1HS3WbCGnJ4YdcmDlblKbD0sOvxqhb0wCkc9ZFQoj5R/HFfX
	aE15NOOsU3dN0IaDRpj9O+HwTId10AA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LjXD6g5j;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759329603; a=rsa-sha256;
	cv=none;
	b=hn7FBF/WOdp587Ke38xbjBzI9Ke5mRcqAE3uP+ND2JG+28r6U4D1RgM70YzsYXs2WeGj4z
	verQJE7nOkFLFEzMLY1x2ABvRrs5W/jVIqFdeoYg04ObfDOPUk6aW/R0OARBkNvzq7J+is
	2e9IqQR4x0rkfL42fuC5fnZaaBnB3vs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759329602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=owbaiW1xpzS8vT38zdTBLv0coUdQJNTI68ZZIQGXnXc=;
	b=LjXD6g5jCdjBrGDJvvCGr99Mt9END08KeA92+Un7I0ycR94jfhdSiCYf3jCjzpmTRLEVIi
	odoCn/W+rcfYISpe+tTIK5xFdsPCoswaEUp3kL8j5UGqhSw3BNoQIYAq+DFC2MpRDNeo+F
	DGKdCtZRmvBz67nf8uT6/xNaYQRGGAE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-7tV5tKyTNCOWvJGVU9nxkQ-1; Wed, 01 Oct 2025 10:40:01 -0400
X-MC-Unique: 7tV5tKyTNCOWvJGVU9nxkQ-1
X-Mimecast-MFC-AGG-ID: 7tV5tKyTNCOWvJGVU9nxkQ_1759329600
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee888281c3so7758215f8f.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 07:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759329600; x=1759934400;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=owbaiW1xpzS8vT38zdTBLv0coUdQJNTI68ZZIQGXnXc=;
        b=Pwkc5oBp0nznj3VPld0kv3rJT3uT+nyfp8vvXorJt6a9zfzww8bUmCD3157Quz6v4H
         OW4HWgbFSTDrHGjU5gAIYaqA8ETzeMZ6PrkAiQRZX6LcxOZQkoTDwdIcLjmaebIQWcMZ
         yjgr22qfuaHdmJJt74CWNfiJDjDuM3zJzSB2TOPKKqy2gcIrMFbsOFaNZQ1czHH77WvU
         JqHQ1MCMD3oV5AcfCzDf9wAaEtuTwFdUn1cExL+m5KZDe6TsGfdMXSIYixUUHIVw4b2N
         vevK0s68/cisBSa2hPStgdyGUnR5ALRajNzvlMRhe4tl/1h2uRZC1FUlB97zq1GCtMUf
         p/Ag==
X-Gm-Message-State: AOJu0Yy5qQKySlqDq3N9Y14gUQL6WvsOfpDQ8/94O3yn2PUAyEuxAMPJ
	ZlLWligFISRobWumLJFhLlQlpGSRz85fvMoV6XUe9rk9WJJy1i/P4HnP4yObnYMFWLl2NkmEXL7
	RMTMda+prPF/1/JIqFJ78bXHai2g1Yh/8rQVAsro5gewjpZhsFIIO
X-Gm-Gg: ASbGncvZwKf7EzwKCpgOpgS01SFRgYDjqRrgCbiblXPQuc+FlU+y000Lv9JoJMcWjP6
	H4qdFBdRr/zx+Yjzr304yIKgWvEKIDuPZiV7TaCGdaIJARWa+GN6l6wIJP5aQlXWOen7OOOj+Tv
	7b0ElD9jkV1xnxufe1MfXiUYQpwOOAG3WOJgsucF1ekSybD76b8Q3M84oyNnrH28MAAH5jDcuWT
	+f6K/6QDyIyvJyVsO2BvSP4DgM5wgh51uq4KWhQ9HW9Nu2dF1EExAa/rrbAhP314OTg+hMcOF1+
	n/gej9nmMcWSy5pN3cbSzESfiwgTQDk9uwixfT+k27J5hrhU8aR/r6f2rh7plsS3Dbx5Z0iHvbe
	HJO6B0vuB
X-Received: by 2002:a05:6000:2dc3:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-4255780b74fmr3016782f8f.39.1759329599720;
        Wed, 01 Oct 2025 07:39:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKzYO9Sp6gBteVbRgZVz3DKARgkzRERx8bAp4TFc5XZ33edLooF2xD5yzFEFwFicRJr26EPw==
X-Received: by 2002:a05:6000:2dc3:b0:3d0:b3cc:c1ff with SMTP id ffacd0b85a97d-4255780b74fmr3016767f8f.39.1759329599278;
        Wed, 01 Oct 2025 07:39:59 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb729sm26620363f8f.6.2025.10.01.07.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 07:39:58 -0700 (PDT)
Message-ID: <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
Date: Wed, 1 Oct 2025 16:39:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 James Houghton <jthoughton@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com> <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com> <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com> <aN08NxRLz7Wx0Qh4@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aN08NxRLz7Wx0Qh4@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S8cwt4sntyB7DN9zdO6Ar4iqfxCnbwSrSORDLpkQWsQ_1759329600
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5318918001D
X-Rspamd-Server: rspam05
X-Stat-Signature: wa47n9by7mmbqd9xygpyz18bt6qz7ha8
X-Rspam-User: 
X-HE-Tag: 1759329603-850394
X-HE-Meta: U2FsdGVkX18ZWv4AUabOMCCHvIl7UglvtbieDwipsvia2Jc/3oEqbH8Udk29do+TvFjgKgNLNiWL3IZ8PuRXoujZLepyd7h8sT8iKD24gjrevDoHRltKYzgBc2K/NaqPcvaLK6cpzwvqAdVxkkGeA+XbUZBqskQjRBwHQIk6oZaacmrDx6JPVMO45yyIeV1/ukSLkimO2tSihyZ8LCPH284d8j+zxE2dZF9ibly5t+aZ1NjuGaL9JZWoAVzCqLpTTcKRYdZSaj/0b6FOwLkPfJVatpk67oBhHWFg5w4u2g+mEN5Cz5BpIFLM1JeZDwFxEIlLdc/2c1uiQnmnBlQ/koSgaOzLkyyo+uw6b1ylOQLrbalEhCM8xnZQa/ZWujQmUDZtUOJ5mgOj18xUfhxvcVnevCgIlrP3nJfxNMVU8eDvYBVB6hxdltkPUPGIEObkjKI3OfYaM33hzc9j6Q8NGCJU36/MPbCI6Fe+IVgSj5kXpVL9dAfW1eINbAXrTwhHk86tHn+dVRjX+HzQfO6AoR3f8X1qjaZIg19C0MvhdNUu7DbzzsW1POiUd5dem6V6r8kvgF9I9JOf1CsK/SlSqBL7YvhH+bVPXca0Ohf8tEQouI3W7QMoV5+CvN/qqBh6viZhuI1H/P7AmKs7dgPVTJ6cwYaMDz2/91RXgR52KuY6riE4Rg9aeRDwuQuBa0gjVbb5SyK8FbiAp6fyqmaBmABs28noV/YWB2IEMF0wjNXdJpjAxf5FSrCYhpCUPfYFs62lOovTXSi+GTcFQrAtH+qJ1Q63QZ+WJa8rbKpX5JX+RyzrN5gUyJso2cDpklrQjqHZ9lFT12CADa2NB9weBHdYjWVwU3oyUqkLQj1Sn6xTpMcvgqQW7ARM5tOQFRsSEzVF47wqOJArbBjl50TCNNgB/k1DUjqnqEdXyL/SFm1aBFQM8bVs/6StX/7OHM337Ru+FfO248UGwSYdvHZ
 0WbNBFj/
 zJRgv/4A6MH4fg/loup214kdr/iZ0NRHgJK7j9E6f+Wg2vPh9XTSngUKJWHNSABKlEpyxkChwilCfd+94i/oyU9j4+W1GB1MEg0GuxNY7SHdF6XQThvX38ksHIsNEWS+UHPnaOs4OoDf6c4IVSfupMVs7rkFf+cPhxUB38hteW46ERr1nadyKmFXUymV7FlIhO5cmcMXsLTa0C4762yo8bExDGhLG2bWub4fD1xuC/nMJqurx7aMcg8KjCKtPkDhLgFwlLr5zsW1l/Qj07Lqz7FDCxeS5JMnA8iqMnIEhSimvhfznIPFVq4dWSdpVltnBVouAxfluko9kdY2bm/x6amWftWgRJRK8SZFM4XGWQgQLQx8ffgvX/5XVFu9cK1z0vQy7W1bIrQa955I3hbaMfAoaBfbog5i/UtYvv/vwJBm33/3QyKS+gK6N9CoOpJjYvAVktdfvf8tWFnwpQMH11GppWX5ZPvuA8fwBLVkg4mLVs+8SWSHm+yBWFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 16:35, Peter Xu wrote:
> On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
>>>>>> I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
>>>>>> are rather unsuited for this case here (e.g., different feature flags for
>>>>>> hugetlb support/shmem support etc).
>>>>>>
>>>>>> But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
>>>>>> the supported ioctls?
>>>>>>
>>>>>> _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
>>>>>> _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
>>>>>> _UFFDIO_CONTINUE -> VM_UFFD_MINOR
>>>>>
>>>>> Yes we can deduce that, but it'll be unclear then when one stares at a
>>>>> bunch of ioctls and cannot easily digest the modes the memory type
>>>>> supports.  Here, the modes should be the most straightforward way to
>>>>> describe the capability of a memory type.
>>>>
>>>> I rather dislike the current split approach between vm-flags and ioctls.
>>>>
>>>> I briefly thought about abstracting it for internal purposes further and
>>>> just have some internal backend ("memory type") flags.
>>>>
>>>> UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
>>>> UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
>>>> UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
>>>> UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
>>>> UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
>>>
>>> This layer of mapping can be helpful to some, but maybe confusing to
>>> others.. who is familiar with existing userfaultfd definitions.
>>>
>>
>> Just wondering, is this confusing to you, and if so, which part?
>>
>> To me it makes perfect sense and cleans up this API and not have to sets of
>> flags that are somehow interlinked.
> 
> It adds the extra layer of mapping that will only be used in vm_uffd_ops
> and the helper that will consume it.

Agreed, while making the API cleaner. I don't easily see what's 
confusing about that, though.

I think it can be done with a handful of LOC and avoid having to use VM_ 
flags in this API.

-- 
Cheers

David / dhildenb


