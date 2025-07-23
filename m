Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E19BC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163028E0036; Wed, 23 Jul 2025 13:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B018E0002; Wed, 23 Jul 2025 13:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041AE8E0036; Wed, 23 Jul 2025 13:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E46358E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:07:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76EC3C015A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:07:56 +0000 (UTC)
X-FDA: 83696161752.19.0459F62
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5FD9D40003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:07:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CuHXoR84;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753290474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJwGeL5vbr0CAZa06ENE24uApyyaPDnFcL5zBWsz7hw=;
	b=eYOkfyrUj/cykaXK81mbqHEVACe2QiMMa431YXHxmIgmcjfdIZqKWaxQa2H1SrCNEgk4C1
	zOVlBBqMHlvZUL4vlAfCSSiPsIg5jhakoPkW8osn45IVP9pKf/Zi03TAHFig5/KtfKGmEi
	IjFT6/d15FtslfDLlBHQYjKjTveV71U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753290474; a=rsa-sha256;
	cv=none;
	b=AV6inpIK5Vf+AYNpF3FRKCthNVjTrvvU4+fpRGd55iFOOhdQOBzVIAdx2uoR5v4W2P9f69
	ns3ZK68pBJo79z1cs4kVpVx/y8TLOEvZ5517O2q8YKivjkAUQsG0Ud1RvqBSagbJZFnAns
	TBebO1hREqn4renNLC0BUIZKUrtFqXQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CuHXoR84;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-605b9488c28so222230a12.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753290473; x=1753895273; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cJwGeL5vbr0CAZa06ENE24uApyyaPDnFcL5zBWsz7hw=;
        b=CuHXoR8446/KZd5ZMS6EZ9rRw0q0qV32HmDeI48FRjRP9GASCo0/0ZuD2fkBfmQ6cG
         zPezdALqvPU+nNRAc4PYgqYRSQyM4Bg/OyvYXt3yd41Sk2xwaJgJzTcMxGX62EltP/fJ
         xqXLpQs99JblKdSEuL+obMWYSF1u7SUuF8rxlvfD6qHrmKRAa45CjR+rDxpovLsivSZN
         XEnwDT14J8ESvkk++ZImaoFmVgE5EV5MZqO02fKMXd3ZJaaQON+7uJtvj+nvQ6o7KN0h
         uclWzp5LxgXQpX58yk9/Hk13zuE0IIDhsF84/zE/RitoZnkDGT4wCFbHfA6ua3tLyjMV
         OoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753290473; x=1753895273;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cJwGeL5vbr0CAZa06ENE24uApyyaPDnFcL5zBWsz7hw=;
        b=LiFGDTJKNouRRsGrGgaFrW45ow0yUCTNJOTOBa4oEZokuyxoVeVcTki2L00m+U1PrA
         bM8bzxtcpMADD5UeXv7aCEntN4lTm743xXmsEjowAYt8a4R6jgo37wmCz44+oi42Fh+y
         vpSXV3WyYjBSXkDMjnXn73WgUXOtkTnlE/nVR/NfGSvdyh+7IgRuCYOP4V+APii6gn6F
         qKwkZ6+YesPamA2dc204V2gW0k+HaYkoOmFgvfJfPRwIIwB3K8AeZA1zNVGZD9HzaVik
         a/w3cPimWLNCDpWobX192v+U1DsIqIY/xbWwYe4C6wFUg2jzlxRORzkNK6Vw2RANCPaV
         qCTw==
X-Gm-Message-State: AOJu0Yw9969HpJcZMIWmn12yZ7LYzDZQf0VWXOme2m8gMZfHvQ5Gw4mZ
	Z17tPtxLf3UjPMRAPUbfdnavp45VLQyJ262lFs8rOOoiMNH3CL4EiFJx
X-Gm-Gg: ASbGnctotsgKB4k9o9cd5QdfpWeYwtEx45w01PKT8kHu7coCEBHkVWogPHGoJ6UFmLW
	PdEdeRzRoRIce2AidO7Md/hlpwaekoHULFbkXX+DsB7Fwy/TOH+IXOMfpPQbM7p5bq20VZj/BoX
	NuPBWzI+NAqTcykqzmssfRI0q9zp7+lrD4yWm1aSytLHr9o+8XmVJxGDE2nODQUkqVbGezpiPS/
	9LHHXQJLofvJX3mUinjMkN0IZ2C7cmxKfOgA7Lxy98JCEPUNUYLeHX6LVER3mVP32axsBfqNlD4
	8IEKfLWIdtD4jxE4ad8jB8TYpAxP4iRp0ITQoPOckJo1vB2vkucHmYZq3F78uzGsVz0EZf0fkRZ
	yX4uQtoDXV5OY98ne0U45vB3UiDNyHnVjDbCwYfvbHR3taDqWsH5V/67CdlJx1+XJ0ASWOGg=
X-Google-Smtp-Source: AGHT+IEhIAINLFGBCVIL5RbbqN7hXbRXTMoAEW2u3tmGCS6C7nD30TNkiWqZ+FZwuJUNa1U4NY7GhQ==
X-Received: by 2002:a17:907:7e84:b0:af2:844e:a72f with SMTP id a640c23a62f3a-af2f8d4ece7mr344718766b.47.1753290472394;
        Wed, 23 Jul 2025 10:07:52 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::4:45e4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6caef924sm1075303366b.156.2025.07.23.10.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 10:07:51 -0700 (PDT)
Message-ID: <003c12a7-cb3b-4bbd-86ac-4caaddcabf26@gmail.com>
Date: Wed, 23 Jul 2025 18:07:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
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
 Matthew Wilcox <willy@infradead.org>
References: <20250721090942.274650-1-david@redhat.com>
 <4a8b70b1-7ba0-4d60-a3a0-04ac896a672d@gmail.com>
 <5968efc3-50ac-465a-a51b-df91fc1a930a@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <5968efc3-50ac-465a-a51b-df91fc1a930a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qz866ix711t6o6jcubhitmc5xzpnfcat
X-Rspamd-Queue-Id: 5FD9D40003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753290474-32902
X-HE-Meta: U2FsdGVkX1+48zzBsEWMdLJLijUNlxKjEQgNlCctbtCsNtLfWTyt6cIDD+Dk1I7kc+0dswSBarPnFp805eq5DqBT8OwvLbyKHQfYOR7B7H+ZbXu/qUwCjlmbwmjUBg9Blqz3shO0QPWz1S+t51g0ivOoMycDH/oaDvCyLH5KQbHV+YT3J5emaOp2h+esS8PJWcHzg9VTYZIb3zpYRfeOPdvWxxpm1kJvOvlxExpnRZTTaRx+OlfPcH7Gr7fwe5FitRQlebAd/5pbANRGrVa+xUyC3xgN1EnBV1guaoRR/eng1kdi5w0OQN91c3yqrY35IeHTvg01umlM49ouRn5pC8cd0ZPRHaVCUhg+A0PUJ2rsWeLmn3DUELtYx8qnjdFLGP1k/QAkiEcFq3glYq1b0yjM3ZMnVbO9ElytI8v0OOhg6FHXqgBVZ2oiRRzJ3iRbM/pA02v6ki40rXvOh5E4Lz4e+FQJcnm19QIyGxjP5HlTnxlJqnYtDukGomTu8T4VhNybLU1anPV26e89Pz8tyRR459F7HoxQelXJ8l6sNSyr5lQSV75AL5dVAcohoqmjxUZEElb5OiXt5YYHiCWLrNGd1k5oWmKka5mzNkLei1ZrF+r08n8whge7t8kdkOXeDlZAZZD4s8+tmIHnu1TIC6u3vqEqmaA73dvpPAZf0u1a2uNnUM8F/l3iJYzr8CK+MRYDo/alQCbZJi4pu1s0nQ8xXRzFcwen3EpDvlTn36Idt4BC1w2gNIgvBmotC/KdC+AopUFN+mgvMF3J1C+2YxY97fRvLapIOZilRscv/IfSCYf6YbPu+JZk4DcoR+UDUAOLwXhl80ZU1Mzjpz0ZaJfCzSR9SVeJv7byEU5xzydHHFF6i6aewaIUWIc9fmLT4tSwE8MyI2h333481vl0tyWT91Ans8oR/UeCSL6xI+ostE90eDtu+gwkhS0gjIMHgGs9Wz0B8Fiw0JQiGXv
 za5327TM
 Fm7bEnD3IR9kK/g6j4yTP9YVAagqCxhpJCOYN6Q1xBk5WOb/iYr2bSaTIA2xNOgkinuOJgj6fqB6nvIJjRcKkLASHnuid6jRdiKMjAgOJO7sXWHBSFFyUQUZdS9UVn6vOI/8u7Xfz7DEWNkRh6g1IWVwzdjBe1ejpji/2bUU6j13J13kFPTXUACqZCjEt6lDT+CiIxD/HvnytExlTMyBz07bNHfKWDCa0/9uVz2WIP1p87U2zd9wLYdfigeI7pTcJAK8bjBFCWLnAg/WuNB+sB2NAC2036XTVpdxmjToR0dA9QnBx03SaDWb6FtUvvTT7wblioACfQK0G/39SSGP6y/K+Aj+Y12y9Duu7RLWodVdJk8X4DaUPDt2DFfSJUDJZCAuSVxML77xqKfdk0ejftQPPvIMVf7ZLYqHHxrQousWUnXb1T5FkVDWfCcIoZCSnLaYNCzC7UhdFJAOX48Bt+5brVsb+k2HRbpP5k4Q1TkpvxqXunbPYjX8dcXXGsSHpgcxIFGpIAaOVh5RjDooDzr4pDNlcNYJiUtIo9N7zaZvOYt+HBqy0NEvfSmgWibDetfDxu/kaeCr4KY3Zl4w/mnLYIsnLgTpu900qRwH0BN3rzyEqi56b1/SC0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Thanks for the patch David!
>>
>> As discussed in the other thread, with the below diff
>>
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 2a34b2f70890..3912f5b6a02d 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -2447,7 +2447,7 @@ static int prctl_set_thp_disable(unsigned long thp_disable, unsigned long flags,
>>                  return -EINVAL;
>>            /* Flags are only allowed when disabling. */
>> -       if (!thp_disable || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>> +       if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>>                  return -EINVAL;
>>          if (mmap_write_lock_killable(current->mm))
>>                  return -EINTR;
>>
>>
>> I tested with the below selftest, and it works. It hopefully covers
>> majority of the cases including fork and re-enabling THPs.
>> Let me know if it looks ok and please feel free to add this in the
>> next revision you send.
>>
>>
>> Once the above diff is included, please feel free to add
>>
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>> Tested-by: Usama Arif <usamaarif642@gmail.com>
> 
> Thanks!
> 
> The latest version lives at
> 
>   https://github.com/davidhildenbrand/linux/tree/PR_SET_THP_DISABLE
> 
> With all current review feedback addressed (primarily around description+comments) + that one fix.
> 
> 

Hi David,

Just wanted to check if the above branch is up to date?

I didn't check the description/comments, but it still has [1]:

if (!thp_disable || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))

and not 

if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))

in prctl_set_thp_disable, which is causing the reset to system policy case in my selftest to fail.

[1] https://github.com/davidhildenbrand/linux/commit/5711cdf5dfe65ca28dac2a57d62e18f1475dac57#diff-dc9985831020a20a54baf023fec641593d0d4e75a78988c3b35a176aff1c0321R2450


Thanks,
Usama


