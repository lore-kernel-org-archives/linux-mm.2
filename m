Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4DFCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BA3900254; Fri, 15 Aug 2025 11:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1968F90024B; Fri, 15 Aug 2025 11:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05EAD900254; Fri, 15 Aug 2025 11:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1BE090024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:21:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C707571A7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:21:20 +0000 (UTC)
X-FDA: 83779355520.23.6BEA5FE
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 818E71C0005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:21:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QcfXlo+v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755271278; a=rsa-sha256;
	cv=none;
	b=3y2LEl+k9Uh+b/a/B26V0jgvegGhhtaNGsmydO2LdcgYYkJusGzoFIc3SEo6boXjpmE4bu
	bcerHZffp/Pd7nnhA1D/KePZZBhmNFDBF7tvjwZ0Xg1dYa0jjAwYMEbo/AKtnMm2jnjgjU
	JDMEIQPHsuxFo/+2C4dAp77T0E2mMW4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QcfXlo+v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755271278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PneJNxQnmLIWm+5oNFTyeol/SNmSmTg8BXa2eLZkhW4=;
	b=RTXkcybTMx5e0X8F5PmbUL5AwrCK84P7esKh9tDc2lEI2UFG2+ES0tNe7Jm2FhOZOWVvek
	6KzmP3vIcw04KZCFvF0yot7MYtO3rzvr46S9aH6dMu//u3oBRIhmP3ynGjjyLonYaRBB5v
	OEyoXvG05ksh7217KNFf2VgYJri4HtQ=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4716fbc443so1505169a12.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755271277; x=1755876077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PneJNxQnmLIWm+5oNFTyeol/SNmSmTg8BXa2eLZkhW4=;
        b=QcfXlo+vCbDY/J8MZ1knKvD2rcQ7vIOXfGtShV67lgTtluodcGy1ZUmxhKSENqkG2r
         zc45StAWl7WBANYxLZ5f7cRQtieJX87uRp1+yDxWngUjGR4iNiSq2Y1Zw1GGv+Mrb8MR
         1wR2wqQMkUI8kR+FIGbgWJtgRCgRg2baUvr7yaj92wRnxgJKYZRFjMTrbfkgRQhjIN61
         PoPua4Tq/sgPk9uSo8vS8m1hCigFF2Bk1G6Neh4Kxu1Hu/6J3G44CPB7PGgLOIbZGRqp
         /4L7ldnxcoGD9lHWzndf9h/wdGfrIXYtwEdpjaDK0dE3zsrNqA7MnDSLKmun/Z90C/IB
         Ji4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271277; x=1755876077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PneJNxQnmLIWm+5oNFTyeol/SNmSmTg8BXa2eLZkhW4=;
        b=J9QU17RJKoACCk5mAUWSXGSRO+3K4pYcMG4nDYxSMh1+5Q8e6LFHKToo9OvolKnhFS
         cQjbH+LegLNZ7ZK4yZjTQiAzd7pXs6PAlnjxwuelrfiibinSDcJao4mg1i8mKf13ipP7
         n1lANlnqPjlyje5SRzZ+Ixvmstj/UgNAtvX7PTz5abdJ6d+uygrb5Jkjavz9ZDI5x5Lo
         xPjFsZjfjM7sZNiaL/maKJQhQVHJJxRYxJ5cbFYkJyOaEVcrFVchHo33SKDGosD/vLm8
         7406c8VFjf21FAS3dsm5IzNuM36QPGpnHI3IVMYB4YkoyO9dL0w4J9ZjegYslUysD2pM
         XCaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh9GG5zRooUHbvNW7jqBnzNIJFtRwzCD9xpXA4frUqsvlVEWs6pJ4m93huvH7cfPEUGGTRq4PP3w==@kvack.org
X-Gm-Message-State: AOJu0Yw5vBV63BrmF4idgBfwLNSwVAIujzfweDtz2lbJT+9zUaqWwW25
	dOwXSfxxs7iIMZ0taXS5gOOwOwY7WKHztB2kR5ZBj96Pw79yLHlK13MA
X-Gm-Gg: ASbGncv6PKojxIYeANaEpt6O+g6TcOaChaZmadPnRQpom3Kw7SeLbedMm6RUgfKYQih
	ZVmPiFSRgPmDK9uzLBSuM151spC1XJXsbf8i1hJhLmvHIR3ktSai0tbx4sX/S0Ia1aqky10PwjA
	lxjipz4Iq2si0fq3jotL23I2H9i9bqgsWMY7R6afaKnKoWNPZ1zhQiQpl5XlkTBP1vze331pjuT
	fUQCOpx6vtEogD/OM6tEulJbWL5R9pLUn3f0EYqbHLlOQU+Skrp8vDsL8JqcYyFHI/ewo4UCXlm
	5ibSBcSpUY2RkZU26OBU23Z1pawXX1YUEyPKb/lzr8mABGOqAP203cO6t3lYln65yVm1c25q1EE
	h9DByYsKuS7Y4vb30JHtX
X-Google-Smtp-Source: AGHT+IFRP0TgRI1LJWt+ukv4TCLrzZ9WJOGSF67Bq2/JNdqHeLeqxJH/Dh0Ama38et71dawyAoAiSA==
X-Received: by 2002:a17:902:d54b:b0:240:5c75:4d47 with SMTP id d9443c01a7336-2446cbc4db5mr35856215ad.0.1755271277025;
        Fri, 15 Aug 2025 08:21:17 -0700 (PDT)
Received: from vernon-pc ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d50f581sm16359275ad.83.2025.08.15.08.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:21:16 -0700 (PDT)
Date: Fri, 15 Aug 2025 23:20:55 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, glider@google.com, elver@google.com,
	dvyukov@google.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, shuah@kernel.org, richardcochran@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/7] mm: memory: add mTHP support for wp
Message-ID: <aJ9QJ2V0WQ5XneJx@vernon-pc>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
 <20250814113813.4533-7-vernon2gm@gmail.com>
 <226e21a5-8a8e-43a0-bf5f-12a761f49a27@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <226e21a5-8a8e-43a0-bf5f-12a761f49a27@redhat.com>
X-Rspamd-Queue-Id: 818E71C0005
X-Stat-Signature: zn7ge3go5rcbubc7pmnkx1m5kmke1jdq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755271278-684955
X-HE-Meta: U2FsdGVkX1+pbItOwQ8rWImhvViSOGRiepez1IjR3XIiIO/PlxjE3H6TVFn97H358H6a3dC7k1XVYh9LM1Q+G0cQBtHlJt5KlmgOvJ2pZ7O3j4X8f2Wz3bdJXSOKwdYg5BGvcjyJLgTbq2DVGeMTX/ab2+grE/DrKOme1BTegz9DlKHx80bemAvC4NZop2RNpXPMxoqLiYoNnDkLcANlra43AYlVpiQQqUxgIi6UsnU/a5fmtlz6OHonZoPyWGEhl39Kp1bkYqiVjmlBlCXJz8K+v8Md2y6YgaD5m3crqJXWPXOkBQGoB64ToQ24i0XEUutsvzJ2RTGuU2+gjbCHloWwrN1eFsxhxqBH1hdeVS3SO5Y3MpcLXGIK5hbYddu3W/5vzz9XaK2QRVLbEFEnV9SXVFfVAI5p0WehejNBLh8LdmGNo8AE9YM+6Xz/LTyU13wGC3aLhdDjQtHPmYMgD1o8/uIU+F1+9Uc/ynSpFuFGVX4ntYcctn/e+myBuKVth5t/MXdCDBTE02RAdOgKWxPsI+ReLXfTrTerOh3Cv0Hy9xjTkKgMmHUrh57YgWUlhvAbj7hG6XWzzC3kV1kV2gvFh8DZbF/ClQ8CbgI7ks6Yi24jqDDN2NQNHPllmEmNXwu+j8CYHi82d2fVHEKCuHdriNbTyuwtsV1MZTJaByJ7uLTWs1V5ga8rYM+Vn9L5K0SPJjSsuUK1TQziA3epgMtI29U7KZvzle7RaT6IY1bgh9fuCf6rqkOfUx7givF59V5+eY6EZnODOyWWfZOBlTfShXcmBgHtRb6/C4qPFEsmfSflFfYHOyVkizZSoiNQPTFzw5HCfYEcfeCaYKMMFSd5MVpey27bFiSFVzUgaKd05FuliqZR4hPzwqRcYzGfZexzIhsz5MJ5dMWkw8MnPmQTFCxEy6cVIzzDMpEcskbOd3THsIGplQpiDhbh8XetAOii3gntGdYP3Kp2lsv
 aKayiGlr
 X+EC5HPNI68/6VC8X7SsuXyaXgcDYMHAQzy+jQdszXrTg8/TLqEIWM/Z0gZpis30wqop5plJetXS627pCS759QWT4bqFZ0nlreagV/KkUwTkKAIoJhetHql8h3erDAyR47g412XC5aKPjSQHScizvx9e68kJ9VEShxDN8l+7+k2fvKnk+NiqDnwmoNfgig0FpuvilaNIQahmKyCXsrV3zHiE3damFWAz4BWr85BXhhYE+7XzzXCkms7g004PBfikKl2B5gwab8t0san4fdLj6+H96hFas/uVU3TLa+lTBi8QbWG8DkmHcN8tWfJ9bwFVYp9IavIS8drAzLd7mswb/X4LZYidfYXc8QZD8BSQzEo9xYRhznDQpVWqy0L8Z6u/VIL6YnsbnbwGpO2hptOWUJ/U90zmTdW9FUcfpTEwNTEej0iX1PL4kM2WZcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 01:58:34PM +0200, David Hildenbrand wrote:
> On 14.08.25 13:38, Vernon Yang wrote:
> > Currently pagefaults on anonymous pages support mthp, and hardware
> > features (such as arm64 contpte) can be used to store multiple ptes in
> > one TLB entry, reducing the probability of TLB misses. However, when the
> > process is forked and the cow is triggered again, the above optimization
> > effect is lost, and only 4KB is requested once at a time.
> >
> > Therefore, make pagefault write-protect copy support mthp to maintain the
> > optimization effect of TLB and improve the efficiency of cow pagefault.
> >
> > vm-scalability usemem shows a great improvement,
> > test using: usemem -n 32 --prealloc --prefault 249062617
> > (result unit is KB/s, bigger is better)
> >
> > |    size     | w/o patch | w/ patch  |  delta  |
> > |-------------|-----------|-----------|---------|
> > | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
> > | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
> > | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
> > | mthp 64K    | 747333.18 | 855570.43 | +14.48% |
>
> You're missing two of the most important metrics: COW latency and memory
> waste.

OK, I will add the above two test later.

>
> Just imagine what happens if you have PMD-sized THP.
>
> I would suggest you explore why Redis used to recommend to disable THPs
> (hint: tail latency due to COW of way-too-large chunks before we do what we
> do today).

Thanks for the suggestion, I'm not very familiar with Redis indeed. Currently,
this series supports small granularity sizes, such as 16KB, and I will also
test redis-benchmark later to see the severity of tail latency.

>
> So staring at usemem micro-benchmark results is a bit misleading.
>
> As discussed in the past, I would actually suggest to
>
> a) Let khugepaged deal with fixing this up later, keeping CoW path
>    simpler and faster.
> b) If we really really have to do this during fault time, limit it to
>    some order (might even be have to be configurable).

This is a good way to add a similar shmem_enabled knob after if need.

>
> I really think we should keep CoW latency low and instead let khugepaged fix
> that up later. (Nico is working on mTHP collapse support)
>
> [are you handling having a mixture of PageAnonExclusive within a folio
> properly? Only staring at R/O PTEs is usually insufficient to determine
> whether you can COW or whether you must reuse].

There is no extra processing on PageAnonExclusive here, only judging by R/O PTEs,
thank you for pointing it out, and I will look into how to properly handle
this situation later.

>
> --
> Cheers
>
> David / dhildenb
>

