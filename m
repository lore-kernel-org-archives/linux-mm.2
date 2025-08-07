Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536BCC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20176B00B7; Thu,  7 Aug 2025 14:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7CA6B00BB; Thu,  7 Aug 2025 14:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6366B00BC; Thu,  7 Aug 2025 14:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAAC6B00B7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:02:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C9A5137744
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:02:01 +0000 (UTC)
X-FDA: 83750730042.30.D45584C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id B554C140002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:01:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VF2yECpk;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754589718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhUS2sM+ExcCQ6yCHHvb67H8y6ZDFz4/8Rje0oa/xWU=;
	b=IOKvnaUZx7RAnKIoSCLfrcrwEIwsmBhnSW2fS/nDYdM68io97Qc7DMOCfo5AEDrRKWK+a4
	jVbZv9PaJ3kk3iZlsEjt1TOwNLnRi6SyMh5fAKZGHJ3dASUYTnCZgMzTpn5urCvpEcefLb
	OijK1hW07CAld2MJNvAIG4Kd8jtwBEU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VF2yECpk;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754589718; a=rsa-sha256;
	cv=none;
	b=6K2zJ9xhw49rNVlj/WJqb3qtjulxOA2ay3EML7vBYcu4sslcA1g42c9QixMy8OSdpKdGYp
	IGJwJepuIh1HTncEgpZ6J2/zpbaDIr0NTm9/FNE9IFCO0EHyxKkI8rTS3RV5/7mSS2+1A7
	EOu414Myta35wqtpKxEhI0mRr0HmfgM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754589718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mhUS2sM+ExcCQ6yCHHvb67H8y6ZDFz4/8Rje0oa/xWU=;
	b=VF2yECpkuGVWLsUU2Bc67zfqIfJKakWnJqXdpQZMCSRD7+sc9dstxzladTRxDjoLTE5Jmz
	1S4XJjcbZqMEw7DHNBSL4SOmD9aZBENKC9NrjzBxmLSp2xNRvte7IKbQ0CYD8y50DORaKq
	AC3LCR1GfryxLssm+ghKTGDdtF6DFPI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-vGkuJ2u7NTSTvt_9pw7-QQ-1; Thu, 07 Aug 2025 14:01:55 -0400
X-MC-Unique: vGkuJ2u7NTSTvt_9pw7-QQ-1
X-Mimecast-MFC-AGG-ID: vGkuJ2u7NTSTvt_9pw7-QQ_1754589715
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459e30eeea3so7727735e9.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754589714; x=1755194514;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mhUS2sM+ExcCQ6yCHHvb67H8y6ZDFz4/8Rje0oa/xWU=;
        b=dNTrCTdACdxcpglxxXud9Z+NosZHW/FlQE5OFOF7wogqDzVsLJmxMFNsSVcS40ZtgC
         q140uLCGB4ski8rOpFCTW2tvG66hfzz7Z6Vi0bfGn7szXJVBqs9zH/MIGZPs2kTzPVQo
         duLAqctDwqQhJvb3+PnjJ5j0dmqh2o1SEQzpg1+5+KN/E2OfoVfAgBLcrO+w3F6LalJQ
         /hrhD4QvY8jNxK1PDiSQaqFYUCcn/P0fzoFW7ZstPUlAlDCEJ6TVUBqa+BhV7w13lqa8
         VENd6jDev7x/MvibUfLamGJOK43ezAZGgQPpUKfPqyKH2JwUgOzHWtvwB2rEuIpYY1eo
         7Eqw==
X-Forwarded-Encrypted: i=1; AJvYcCXMzFIcCg+Vb49wcm1/IiOnLckXzhKBMZriyaCHH+NFHeLP+FVKPIuiPR8yAj14CvIchgMIjuSj1g==@kvack.org
X-Gm-Message-State: AOJu0Yy0sVs3Ybd3m1DL7oM+AwcF7rmpRkt4IdscCutw1XVR1bz9zQ9p
	a6aDFXrZSQepfenBHdhqufI50X7/+4B9Jr2ZxsMxF7VgF+N3pWus1v7c0RnR3H+D8MdfvosIN3V
	iHSbUu/IumEFZVEQTL58g0WQlHRxuyZN3zcqmmpNxLedqoTHHnVD4
X-Gm-Gg: ASbGncuG3y6p44EGm4DPySGBgtDsSueCs8PpfPFjBOlzN3zZBCZlypCj2/KyUXfQHvw
	eT82UKjskl+K+T8BYUJm6BZR1SioGAnMbrJfgYWteO0w9UesIjpoM/Fw1M/4k/zHVV6Aw/hYw3A
	V6DIHwtAzrjHq7s0vBTdaONSd/vlcy8x13ZMhGQZQ9oN6MXg+djqhhIHW0dI/L1IHuYILE5DVFf
	qcsveCQ0EDjnkXyFmsJSX804g5CAx3fmmcFreYWacx/iG72b1BD/nUqgMgps70PpiIfXEK4nK62
	RhK+0h70lRKAKg95IZhSdacRWtBVpc9zdGcs3r5Z3oD4UUDWJFtFOAHloLRBbhOyPAbvY89RIxN
	X+cAlRxlswjSNzFB/ekQjW9w6xPi9POqyu56CfvkL+F6ZCLDBmoE1WD9lpUvH1/kegT8=
X-Received: by 2002:a05:600c:46c8:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-459e74a4ad6mr64013475e9.25.1754589714414;
        Thu, 07 Aug 2025 11:01:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxcVatWP7rFIfVWx9CqdmH8FLM3Nm306vOiRTmVXgWVKdqiIY4890kJtBR5KGb3c604MXHrw==
X-Received: by 2002:a05:600c:46c8:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-459e74a4ad6mr64012855e9.25.1754589713826;
        Thu, 07 Aug 2025 11:01:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c33fesm27989570f8f.29.2025.08.07.11.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 11:01:53 -0700 (PDT)
Message-ID: <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
Date: Thu, 7 Aug 2025 20:01:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>
Cc: kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>,
 oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Lance Yang <ioworker0@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WCLtpr9Zy-7kI1g4QVTM29jCdcqCzNvLfY140xkMUNE_1754589715
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B554C140002
X-Rspamd-Server: rspam06
X-Stat-Signature: ftjapexboxq4y4yrba8tczwf96mpossf
X-HE-Tag: 1754589718-583056
X-HE-Meta: U2FsdGVkX1/K7EllckHZjLjGlFQx53PgndaXa6E/iQ3rnUexaUEYMrejalt8rLKhYh1ed9bzK+pS85ghb9EEeDT4N7LrYNol3yurTBbCYD5hEzaqZeVRqW8cQEGnmER7o14CgcTENu6TZG0fM2JzPu3rEYP2XibrnAlB9IUF+8H7uCxO0DfgTRsSoQnFxIkJRMXDriQlsjYKUfOozz6gXFKsiOyFqceGR/AZ5U4Mb+jmaiStla0AwCXw8kO5a5QPCMeVDIo4kC/UuJBT9wXPBubNpfGwBqvblccUxXrrnVmKVbqarIYMy5V+r9hI4LZsCsAQijYalerssAUiT6WwTHg81GAj1WuaPAHQ20sNYugIjl5w5hQflYIQOJDMcMIvl3PQvWiqkn38UhQGTOVKqdmrJjWOaUOH5kWJWn7Ikj1Wb/FRokzkbR8QVvkxL2fXe8DKZ2llUt9E6/yuSvYdBZnocW0t3toKqkXlr8I7me3H1byxrh/aQKvdvrdfPF8mJdU0ntc9an72dm79xxs6DyUDfvT1sFrZjMG8/gsyrQYkz7+WiHzaKH8uv9OLyBPqcyKinOhvkKdat+NNCnmc/X5ucS4mAAr5i8SE6w7JtS9qQQM2UkXkaQme73Hrn3rbEBcHKRarlx2+ZR/i9QyogxnKAbhj+6XSBJHooTblE+KM37mujMwcE5A90J9FHbZSW9hleSWAw6VWYwCe251O9aMH0O82OYcQsT1cdh9zTUFYKbd1OdHl/UXF+boiV9zBPrv+0eoh5YhlsE56PsaY72VvgKVj/OVRCe50gpDUF+6xu+vPZnFTbecw2dCC2AnOLbYqBfwarUEdB/9fKyZj1xXi/Hvbnk+Jhokkzh5aNkpQHvrG4/wPqRLfL7hxNIgUbSWZxaxOOCs+qWdjrtnn3FvkdwYidRQAUriafyRhLVdHTJb1sbNSM1YbCn6asfe9A8oNKC8TVoukPXdLlNj
 z78jF9v9
 F1sFSWTXzeUOEuLWeJJkfFK1J+x+HuCnxP/xbTJUuzaoq17UOADVU1zCcA1rK1SsHIrJiuEc1wRhd9x1KEgAXdNovjpEi2ufpYWs2t+FSoAeL9aSVh65yhATKnfOlDSQ7n+NNY8yT+5ke8rjuhKfmglRw1RXCg5qOroj7cfAzCltaxsc3rGAvjuXwburyVeUAA13a3AR/4SrImrjrHPCeWStGVAWexeQeU3lsPg0Vzd4kMeckL6bMuwEqt6vGqxrWGmJBAbsMPWqOfgIGiCc3Zy4o1GA/EbmmNVurqbpY/2Av/3uQCpoc7LVCAw+P8eEbWgLMhb4tlTJt7vajSFEzDQelQJjuiIoVo0UFvuuiAlO01hozuIzKyRNr/cKTajMKX2l2A+Gq84MHRfzf5UI03M4HQTTe0uhy/58h36aSg9MsbOMJtkcH9jAtfOXLmbRgmT3p5hHKLhATwoa/mLrwAf1BRftmUAgJfcw1t5bc/2RkEH24HcrpcFZKdV7qs9hDGrd95J9Wwmb4E1w3lKAs/IkhsNiuk7zPBBUTOYVc+UomjKunQE59pKN27MM7FQyDJtYAg1PfqeYYt4WWyE0NtiVyqMeeaGnMYe0xi5RtKHdyaQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 19:51, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 07:46:39PM +0200, Jann Horn wrote:
>> On Thu, Aug 7, 2025 at 7:41 PM Lorenzo Stoakes
>> <lorenzo.stoakes@oracle.com> wrote:
>>> On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
>>>> On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
>>>> <lorenzo.stoakes@oracle.com> wrote:
>>>>> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>>>>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>>>>>> ---------------- ---------------------------
>>>>>>           %stddev     %change         %stddev
>>>>>>               \          |                \
>>>>>>       13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
>>>>>>      367205            +2.3%     375703        vmstat.system.in
>>>>>>       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
>>>>>>       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
>>>>>>      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>>>>>>       11468            +1.2%      11603        stress-ng.time.system_time
>>>>>>      296.25            +4.5%     309.70        stress-ng.time.user_time
>>>>>>        0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>        9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>        0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>        9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>>        5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
>>>>>>      388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
>>>>>>        1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
>>>>>>      135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
>>>>>>        1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
>>>>>
>>>>> Yeah this also looks pretty consistent too...
>>>>
>>>> FWIW, HITM hat different meanings depending on exactly which
>>>> microarchitecture that test happened on; the message says it is from
>>>> Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
>>>> meaningful than if it came from a pre-IceLake system (see
>>>> https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
>>>>
>>>> To me those numbers mainly look like you're accessing a lot more
>>>> cache-cold data. (On pre-IceLake they would indicate cacheline
>>>> bouncing, but I guess here they probably don't.) And that makes sense,
>>>> since before the patch, this path was just moving PTEs around without
>>>> looking at the associated pages/folios; basically more or less like a
>>>> memcpy() on x86-64. But after the patch, for every 8 bytes that you
>>>> copy, you have to load a cacheline from the vmemmap to get the page.
>>>
>>> Yup this is representative of what my investigation is showing.
>>>
>>> I've narrowed it down but want to wait to report until I'm sure...
>>>
>>> But yeah we're doing a _lot_ more work.
>>>
>>> I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
>>> especially sensitive to this (I found issues with this with my abortive mremap
>>> anon merging stuff too, but really expected it there...)
>>
>> Another approach would be to always read and write PTEs in
>> contpte-sized chunks here, without caring whether they're actually
>> contiguous or whatever, or something along those lines.
> 
> Not sure I love that, you'd have to figure out offset without cont pte batch and
> can it vary? And we're doing this on non-arm64 arches for what reason?
> 
> And would it solve anything really? We'd still be looking at folio, yes less
> than now, but uselessly for arches that don't benefit?
> 
> The basis of this series was (and I did explicitly ask) that it wouldn't harm
> other arches.

We'd need some hint to detect "this is either small" or "this is 
unbatchable".

Sure, we could use pte_batch_hint(), but I'm curious if x86 would also 
benefit with larger folios (e.g., 64K, 128K) with this patch.

-- 
Cheers,

David / dhildenb


