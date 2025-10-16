Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F99CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128678E0031; Thu, 16 Oct 2025 16:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105F78E0002; Thu, 16 Oct 2025 16:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0158A8E0031; Thu, 16 Oct 2025 16:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E469B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:28:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92ED81A03C7
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:28:21 +0000 (UTC)
X-FDA: 84005114802.26.6F5A9E6
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id C22831A000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:28:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fTMpBj3C;
	spf=pass (imf19.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760646499; a=rsa-sha256;
	cv=none;
	b=2Is2p7B5QLYpSd46r3ZqZuWCGNkyKGJgQXAXAJ8d3Vmj3XX0k18jsMWx2PHgylfHUjouJ6
	eSDmIWnJkAn6Nep4Oz24P/xNYWQrB9fRZ1hHOBDSbIZzdPC6d+xQb+y5gnwbNco/A8bP52
	5E0Bt4zzn43G2VaC6IxxvoCNMsiCsj0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fTMpBj3C;
	spf=pass (imf19.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760646499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jY39mXgVcMN9xXBrEeHr/JB2nDeThDXcp+1mm32IdM=;
	b=I9yQk0BQEukY/S7SiuYCk1/TuFru3tRG+QhmPfGIdahWecDgRLwX/d6H94OhE8VhwHHb7k
	n2ANTq98oJHlzrTp5axnnLOC37c70ItyYUI1C9k+yhHJGfIkTQIniu97xV6QEl9ea5xw94
	LmYLPtaKekReGJouktXjKhAUz++i9vA=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-33ba37b3ff7so1131187a91.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760646499; x=1761251299; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3jY39mXgVcMN9xXBrEeHr/JB2nDeThDXcp+1mm32IdM=;
        b=fTMpBj3CMxWnrGqvIlpLLVyWwuunOXdUJ/hlDkdG3FZY9jXdZd2LuNlxf4CnTmSmtk
         j3/YN8pjTQURwuYEJJyFnqYqbd3//FC6mhth5gXcxDUuYwhGzEWdbFsFZtN9K1nXeTtw
         4bXbaJWYZgjzI+aIpi0++T1ACNC+pAlZKXZ1XCkQm5I4fWWnGHCCDwHyzoQJ2goCLcS0
         75YjwuGW1kFnA69Nl4yZTA7R1ev8DHIREiFjzuHTpqoMAgeTJ5TP7SMea/1L+IVjzYj+
         Mv8OXRF5BjyTtNlgX6pAqb9Zn9gbmVXklQvMdcckSIaL1txwKAUCW6KSTKzQRD12LqKd
         qoKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760646499; x=1761251299;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jY39mXgVcMN9xXBrEeHr/JB2nDeThDXcp+1mm32IdM=;
        b=hO9dAWOBDC1bkiZ4ZPjcE43cSrvh8t9lS8YySfOOD9t1xe2VH1G4o64dHm7408+4jq
         FBZi5tbDMHW+pBYbigIwqzc8YbaIE3j9dfTu6wCCqNOejxRw5b5B4MoSrxdFxuX+BPEu
         bUrSJXYj6eU5uetXnGLvI5Xr0QjHaad9bzC4avrg1q9r0x9Y6DK4tAMPEXOAfL+mv7d6
         hIYYUoCOivQXn2bxCTGXL5scaF2ilVVQRKcXm7EtlKk1Hf7QDtFa+xgAKtNs/GkUdhI5
         e64jM0e/K9UhFy4H9lzCulMw6XvBCdF6I6NGcAIAbkKXPxjvplIHipaM8N315n2zPwDr
         ajOw==
X-Forwarded-Encrypted: i=1; AJvYcCV2sqVYBJCWzt9RfnW3hwLrfyNBu+gbhnsjHJcjFqtmYO4X4RMb70wr7si8UvMty5wJYPPD4i9JrQ==@kvack.org
X-Gm-Message-State: AOJu0YwrO9D293IFvdeKXAJXODbtIPbNmC6uuL8BySZ+xMPwEowHakLx
	o+mSutrTdeK0TGXfVcNxOO5CdJli7MlYzqz/T67KnCs5Q4c6pgXWvpke
X-Gm-Gg: ASbGncv4e5I5PyW6X+leBLFadtLLe9UeKH80uN3T1H9/NrVZRuxZUETf/NjGfc5+JLG
	4zBfoL1vLq18OPBoRGbbGj6KGyKJkjWpBnShfqi6OBVbGAoV/pUQCSN4qLukKnhR+qSupm9j2dS
	Biklbt8Lzbv76V2WX9Y0DCukcSGD2JhP+lHDuDed0TcZ2FFjflcBm55xWIwoUTjIQ/b4GVvi6zn
	TKiEejIZAg24i8G4h+2RvUZ/tHsrfu2tVASsmAH/1hwATPQD3g6PRQO4qb/mBBDmRkq6crCqCyk
	WiSyzslvdpM99HDYji7dOVMSHX+daOxRdJw7g7th3LHLfoaxwRRw7146XDNo9WuMM+OLC7QQDdW
	Pao96wSw/AYX0ul+MHp3i9rHPHFAzobJGNwTHoYgNnep8uKt/bG7/tSf9XyrSPHGXLm51B95PJI
	RY0C5YJDpFS9UfA25rHaLZQpUkGZ3NbFdJdMVusSCwtqqq
X-Google-Smtp-Source: AGHT+IGWLWyH0AABkRz6alBvUVzPFctljtKTWRYOwESGtF7UJb7utW5OdfjqyV+JPgqFQydchn8xQQ==
X-Received: by 2002:a17:90b:3f0e:b0:327:c583:add with SMTP id 98e67ed59e1d1-33b9e0a4c2dmr5398538a91.6.1760646498534;
        Thu, 16 Oct 2025 13:28:18 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1151:15:6028:a61a:a132:9634? ([2620:10d:c090:500::5:e774])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bd79dda6fsm337108a91.10.2025.10.16.13.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:28:17 -0700 (PDT)
Message-ID: <b4418948-61ce-4cf1-a3d2-a4208e73d5b3@gmail.com>
Date: Thu, 16 Oct 2025 13:28:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
To: Song Liu <song@kernel.org>
Cc: shakeel.butt@linux.dev, andrii@kernel.org, ast@kernel.org,
 mkoutny@suse.com, yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 kernel-team@meta.com
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <20251015190813.80163-2-inwardvessel@gmail.com>
 <CAHzjS_s3L7f=Rgux_Y3NQ7tz+Jmec5T8hLyQCxseLJ9-T-9xuQ@mail.gmail.com>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <CAHzjS_s3L7f=Rgux_Y3NQ7tz+Jmec5T8hLyQCxseLJ9-T-9xuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kpbf34otpyeu368der5s1c5nkuinq59o
X-Rspamd-Queue-Id: C22831A000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1760646499-441278
X-HE-Meta: U2FsdGVkX1/d1dYf+2ZAxEITPbv0EQpudGUNpxSCaNhxkXT6qrPxb2dReL5IDrhF/B5dGdFq7E9Yh64RerQKK3Q/WuvVDoTMop8QHnPmE+zMs+Gt/ygyd8JOPXxYNblNhfgqg+83tVboIi4D/aU9aLZL96j69PEiUFssYZJTiw0BPoeF582GjGYhdmsT1/h7Kg4Sn/Be/LSe+favCAjafDqoIn1fg4BClBzJTPmYv375SGn1IX1lgS6sGPb9FOXu2yd+kM+gPA5Fqs/But5MFsMlXalbzYn9KKlmiUuae/5LxrADrsBFkGdXJos5MwJOBNphOzUz2qRF3lUto+JGKyI6nBymXM28RmXITiewxUGs5+Wz/lVYIIQBM4YXi/e25SWF50WhMmn09etV32C1cMbgimnCjAPsfBq8p/MKtkN7QKAtV3UTc6ldTT5iB8S0caSMhXPfw79SJ2rgZQSAkKV2woIPlNxCfRdowTmSK16XsaT78TJ29armHz+nimHRZkwBt9TUL+ZlkAwA2ncBGO6gq5JmNgLpjfUDkiZZMdTJ0/zkVoPuFuq0tPOkXnltkYfswo8YxKxl1oHDGIYmE7YBtxxwOpQVQVtaDYofi4NIbltKh4qBDT3A5NHvgHyfLQN61YagC950Ph8sVJcVIJouLHbFXvKq5IPoFM8YT6OJdOw5A7ZS2kZmQ3VQibtk+vwQcW6jNWPw8gfyBlnGYDQVwTPdLBkzbsCJWUp3nK3Y6K/bYapv0ke4mGcFK4kz9POEGYz7cHwrlo3j0v+9Ljz7M8ZqpFZwieWoh5UpLE5drEg0A5xdsj+lzSjyc0e6h9l41PH/HwScEljNJ/a/4fKcGmnu9d5KokQ0ex3rB8hjYyGEWwrKdNPiJuL1lYh6uTSGp9z0hQTA6+6jicb/Kfg3lNxqDnMvztnes2Elbel/aKpR4Qq9kgrXyShmZsRkw8XRjKMY8JXTB4qTfm6
 D/tW9A+J
 aEj79NIYgtLs9hrzqxyE4TRiDDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 4:12 PM, Song Liu wrote:
> On Wed, Oct 15, 2025 at 12:08 PM JP Kobryn <inwardvessel@gmail.com> wrote:
>>
> [...]
>> ---
>>   mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 67 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 4deda33625f4..6547c27d4430 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -871,6 +871,73 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
>>   }
>>   #endif
>>
>> +static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
>> +{
>> +       return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
>> +}
>> +
> 
> We should add __bpf_kfunc_start_defs() here, and __bpf_kfunc_end_defs()
> after all the kfuncs.

Good call.

> 
>> +__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
> 
> We mostly do not make kfunc static, but it seems to also work.
> 
>> +{
>> +       struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
>> +
>> +       if (!memcg)
>> +               return;
> 
> Maybe we can let memcg_flush_stats return int, and return -EINVAL
> on memcg == NULL cases?

Sure, I'll do that in v3.

> 
>> +
>> +       mem_cgroup_flush_stats(memcg);
>> +}
>> +
> [...]


