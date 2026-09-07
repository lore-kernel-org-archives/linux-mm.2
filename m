Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F428C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 05:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDF66B009E; Mon,  7 Sep 2026 01:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E956B009F; Mon,  7 Sep 2026 01:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE616B00A0; Mon,  7 Sep 2026 01:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3BD6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:53:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1A5C40462
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:53:21 +0000 (UTC)
X-FDA: 85185898602.02.51122F1
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC28DC0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:53:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ck6qA5Fb;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788760400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ep44r7OC97WvRCgfJ4aDAB+5nIEpOJgFq+MgFPa8afI=;
	b=QkH9h7Hi8ECnlKZZyCUG4aEj3FtZwkaIj4gHZRQWfCqTm4XBTJUTTLk0yd6E1iVUeBpUQX
	tRR6JUrTMWUdo7BrkHOso/z9M/f0wxdbIb0HRS/wsiHdGpWLmlD3A+neosw0ibVpFcUOJx
	5o3JyEGzwEgOT9LTHpsbsCY+MM5Df7Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ck6qA5Fb;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788760400;
	b=Ao5r22MKpQESd0/WyczFjFw606s1nh+1k37eEgpeGWYE417wNAsyfqHjjaadtBwwYrW3WV
	dWh3LNHmujjLrMhkRPdHCQ/bW+JxHLKj0Gvjc7dYYQIZvvNZRu0MhxRdOcMameHpxvmxeC
	qkQ5vJJ4DDONiArOYdsdEjQi5dx4/q0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788760394; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ep44r7OC97WvRCgfJ4aDAB+5nIEpOJgFq+MgFPa8afI=;
	b=ck6qA5FbuRkp8qA3AGQhT3wHr8PwkUUgjVE/YbkduHaiQqLWtnOTtM/7NfysLFmN2j9sh27WfdV7Y2w8y/TvGkgbkE0+Euj9CAYyRZwJVuMzsRpzRISttHqS2ydAN1QiA+RPX38YcsXmKH40Jgpdbm6LOOnVKrae3o/fYXfDWfM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAPo5rX_1788760392;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAPo5rX_1788760392 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 13:53:13 +0800
Message-ID: <b4c84ef4-0c2f-48d3-9eeb-6f39ed297be5@linux.alibaba.com>
Date: Mon, 7 Sep 2026 13:53:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4xxZWomhtUmdz9f1x5wdeoTSTRfEudzufdBs_ykKM1HBA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4xxZWomhtUmdz9f1x5wdeoTSTRfEudzufdBs_ykKM1HBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7rjs4bh9j7hb3wiphq71kx6e1jj6t7dt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC28DC0002
X-Rspam-User: 
X-HE-Tag: 1788760397-99708
X-HE-Meta: U2FsdGVkX1+h9ateGpmPVG/s8aT7TnqtW7g8ELwi4N/TaSROIRySaLFN3VE8Lt5bfjrgguIDLDwY7GJQUu0/FpHRccrPz7uwM58Cj4l0dE1k7mIrpyhsO8SmZ1fVFjlY+xSGwjwKlzrAbgmp94UNVuyEUUkF2GiNQYvQxQ+HJIvq09dW0bYVDF4R2EswcMEiu0O/n0xE6G9HkyvdMrTDS3Vc4h6kEhllAUvpcxGhwmhUCnXNfP7E42ihwgwbJjvv4Y2/zqjljcdpGbuQu1oxEPmHgmcbYvKF9ppO4TM+bwKBxusMEml08LRzfulQYhDY0B6DpY+3G3iYW0Hl/aYzvuFAVsvJ9UQKvoy4jPeZgjvhoq17Pp8+IrTCqU2orOKc/lGiJjJOQfQG+BNfatpfCcUFtGzg+ISSaAODmu/vDHA2a6prh23TsepJRRZx41icgD6vyk5S3PSHeGH9JTr3NEHIIZBg7LNtKOFQSrWLcuqjld6897b4+FWfEUjzG3gkRyF04DUVM8fQApSY4Vcdd5hQw2GwkFLjjgTaX5IZU8tUVUwIY5z/aHgyZG37e1paCQxlp/DaSR+QNn4pe2IL03x16fq73kz3HKgJX2Fjd8uq6vlqf+jMzIMW/M7RqUCdfSJGK8XWCFbVe5K+tnyS48CgvDhvMi1Et0/2oK1B0/D+y7v/XySBzJnWoDTo55fnIsRvQIgBOZfCi+Yl8oPCA0zCB2S7MP5wE7GqSPlJ0qEtgr8NGAxHpGbE7yESc7OxFyB2eznEQNskkYSaV5Af0dBO4AEnB2yRpSvvrXAkE2+yvE+rKdDwQ9i0rvkDlC95r/cMCWYgptcMOy80e+dIKGhVEzMtXcbBcP6+6+wyGETzv7bk25sNBTFeiQOWL+aZVxcx4L7AWS+cASixeKGa4yV/uMYUcj1dfPKYthSAd4QYZv8D1zJ24t2bl0IuTTE11pD6xrZf1MToGn1FhuC
 xuVC8mKk
 jc4nYaZjUvcYj+MRg3Gd3nNuQrVhpItTgdCVuOsthYjsryOSk9hr9i2ZMD2vA/phYV7sRMt0nCMSRUfuSUc1r+nhamQXBIJxFKp/JPrSHthiaXO8kz6XqV56Qqna122c0wgHLJe0jAXr6ot3PUZ93lsSIkIJ8d3KLn/cUNGCbIvp1FJApdRZm6WCH2CWzi+M6RbtuIuM6oK3jvHosAUkT9UvlhlWWfDUcbEvCRMGWHfWswrz/Nldm19kI3pRLC9QyUMjo9RQgEb61CStk+tq6Gy3MkKR4RJxdT6BNzatJrYqezfxTWYY+/LDpic9pYyAj4Mgc0KNTPCjJoZdkEmbugUtJLdDN99If2K7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/7/26 12:28 PM, Barry Song wrote:
> On Mon, Sep 7, 2026 at 11:25 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
>> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
>> counter can start over.
>>
>> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
>> set the PG_active flag if the rejected folio is planned to be put back to
>> the oldest generation. That's fine.
> 
> I find the description a bit confusing. Yes, according to
> `lru_gen_folio_seq()`, the folio would be put back into the oldest
> generation. That's why we set the active bit to prevent this from
> happening. So there is no case where the folio is intentionally put
> back into the oldest generation.

How about?

"
For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
set the PG_active flag when lru_gen_folio_seq() would place them in the 
oldest generation.
"

>> But for those that are not put back to the oldest generation (which can
>> be treated as a promotion), we do not clear LRU_REFS_FLAGS, which can
>> violate the promotion mechanism. This means the rejected folio enters the
>> new generation with stale, inflated tier bits, which can inflate reference
>> counts and distort eviction statistics for these rejected folios.
> 
> Maybe simply say that folios for which lru_gen_folio_seq()
> returns something other than min_seq?

OK.

>> Fix this by clearing LRU_REFS_FLAGS for rejected folios, and also do some
>> measurement. On my 32-core Arm machine, with the memcg limit set to 3G,
>> running 'make -j32' to build the kernel showed a small improvement in sys
>> time when using either a zram or NVMe swap device (averaged over 2 runs with
>> no significant variance).
>>
>> zram swap:
>>                  w/o patch       w/ patch
>> sys time:       1666.5s         1589.5s
>>
>> NVMe swap:
>>                  w/o patch       w/patch
>> sys time:       760s            741.5s
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/vmscan.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 40d3f1b48a74..42c0a09938ab 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>                  }
>>
>>                  /* don't add rejected folios to the oldest generation */
>> -               if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
>> -                       folio_set_lru_refs(folio, 0);
>> +               if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>>                          folio_set_active(folio);
>> -               }
>> +
>> +               /* See the comments on LRU_REFS_FLAGS */
>> +               folio_set_lru_refs(folio, 0);
>>          }
> 
> The code change makes sense to me if we keep aging and always reclaim
> only the oldest generation. However, if we go further in
> `scan_folios()`—for example, continuing to scan after we have fewer
> than two generations left—we might not be in that case anymore.

I may not fully understand your concern. If there is only one generation 
(fewer than two generations), we should aging instead of reclaim.

But my point is that regardless, if promotion happens, we should clear 
the reference counter. Otherwise, as I mentioned, it will distort 
eviction statistics.

> So far, the code looks correct to me.
> 
> BTW, Baolin, I wonder if you could find some time to test this
> change on your arm64 system:
> https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/
> 
> It might have addressed one of your previous, similar concerns here.
> On my x86 machine, I find that the change further reduces the
> sys time from 3 minutes 40 seconds to 3 minutes 30 seconds.
> 
> Meanwhile, I will also run your patch on my x86 machine.

Sigh. I missed this thread. Yes, I also raised a similar issue before 
[1] and this is still my next step. I'll find some time to check this 
thread. Thanks for reminding me.

[1] 
https://lore.kernel.org/all/eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com/

