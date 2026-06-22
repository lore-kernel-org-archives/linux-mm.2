Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277C3CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19A36B008C; Mon, 22 Jun 2026 00:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3E76B0092; Mon, 22 Jun 2026 00:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CC56B0093; Mon, 22 Jun 2026 00:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 540026B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:21:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE490C2525
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:21:57 +0000 (UTC)
X-FDA: 84906250674.07.8C8E4A6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 726A0140002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:21:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IbRtbVJC;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782102116;
	b=3zl5aIbb6rORHVetTEsMRxx9YYs2HTkkM2IfiRl74Soe0y7rSwg0bHnf8CAFW8xIPWXnVW
	5wd/jefXnf3pAPylATD3Gf0Oy3y3R7o7l1WBpUrlfLYNVtJumZL0IMjHLuSHoxQy7TEHur
	IEhqot0hK8wUS4Vdh3s1eTX7x0gB008=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IbRtbVJC;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782102116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVE/CETE6XJ69E1d+hXZBaTooyvpB4+dChpZFA7ZoMk=;
	b=bkY55BDSLXhqHxZHKcWbYd5uItBohADD/chRENX2MWlzy3n2t0iy/uHWwQDX48rGpTXQUg
	L/g/kcnL4PVVRv10OSPl4mREXKsb52EEQu7OL5XgE3VeVROarjVAiwOntGQYlF30edt79b
	bf+xujx9hL88fGZ1uuWt/PU39YlpBvo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A93661BF3;
	Sun, 21 Jun 2026 21:21:49 -0700 (PDT)
Received: from [10.164.148.39] (unknown [10.164.148.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E65393F632;
	Sun, 21 Jun 2026 21:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782102114; bh=MeoUdRHU+a8GHZTXWy3AhV6g6+tAIm18618t9DJUnCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IbRtbVJCoc0dwm5V7cKHFiVgZ9iYADrT13EoROHmpvgAovU/LJpHhIzFFEEl6wvdM
	 sqhoZFbiyg75byqaF55UYJsFFAzQzT3bHs4+SK65T1LwpyBS8gpIjggXYF5AnxBoTM
	 TidnUlP4peozlYOQ8q/TqZUfm8jNfOWpCBAjjo5M=
Message-ID: <69b316bf-7163-4040-8682-e3d200b7d7c6@arm.com>
Date: Mon, 22 Jun 2026 09:51:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Isaac Manjarres <isaacmanjarres@google.com>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
 <aiyhb2XwMMJE3st7@google.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aiyhb2XwMMJE3st7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 726A0140002
X-Stat-Signature: 3baa95a4jbwjjnh8b498ccgex9bzowj1
X-HE-Tag: 1782102115-946003
X-HE-Meta: U2FsdGVkX19rfgLKOIYvRlTVttW/5C68tDKlLw02z1MQcLyUxzmJhZnAF+aytU7VhuQRNPRZHLzcS5ZEKiA+KEZXN1qsbYU5/sSmvJrdmiVz9a/g0HwkCwyEixJBScXu/Cnvs8IUI6TGYxayQanIcwcV1/Asehv7Q9A1DmyLSp7D2ivEhr757k+kevVlYVHhT3Y3WlmeI9Zx2UnHCug1F30EhDb6WBlSBoLZppEDUJVcK09MniazuZyUqVOwh+TV1MCOwJy/kjt4kx/yUsJEBkf80osieZ2Kx8CI0JGGD4gcYo700CLzGV8rrX8GE/SoynDyrnu2/k0rDqwd8jpR+orQx46XecSv1Iz1Gvs8a401bATdY3zJBX0bsHN2XE4Gkgqq8UGOhap/SM7DRkjK27W77THtrtyWYe2+SLlBb0nyQOFZZK6x9VNEICJ6HDvHVmTaMJARh1TPXmvbTE0bX393yVGjlz1DkIOTiZjoPjbKPeQnmf55eR6lkoNBAMLgVzxcDgUSAGN52vB15E3q8LHxFiepqCvv0QJdyiv58pm1bNTDJFBtq7Q6YjZQJeXK8Dza9U5ZgbG3YJ+Jm8aAIfgIvloko8A8OMv0W0PbGN+4CBuDrmGZIHDh6SHrzJbQ/DUpVHisgxwKV5WWnQHSgws2a9iBhDltY0HoewgmOS+IRyF9BA/ARqRiXRuhH+791Ik7cuvwBuMYgQltq4vTK3UeLOYeu/mJn3SjO9XyW9x9s5KT5YISaLa9ChvXZe8k9w+Jp+70t7hhiVtpWEP8zmRi/teEfjFfnaw4WZXZFyiyXBgUogExVGOlks60n0hbTchx6vTsybddqUhhsO5M7BDivSxfsHlm0QI9KSH+7idCuTLy7XlLa1kpAy5ZQmM8Z11x86k8X2kbNIoVnfYhR5bjV+JLSgFKjMcgmqVP8Uvy/OnS16p7A0ZScWpFfnn4Gc7V8/Whvx7LNT0zI3Q
 ULo9r+qp
 ZWPcMD9Qu1vJ6cls8EvYyXSSLZEsLEZNkB+6DX0fg1Lntdtm94cSQGZ87NeQoAggBapYHuxV74Ruj0MWTjduqDDcKmhXL+r+tPKMuaLIyT+WBxO4epB2mjIov1DtmSJ1No8APq3BeKCtPGyke06y45YBAU2VC+pWjrmcsh5eCOMJdZ+rZXtc+NrwE4RQic+GRgFYbo8FTKrRhAApqdarx1nFLg8FPRfj/E8bLlfD/+v4xO1BOgOhlMZFJM8PV/SHs7rXeeo8JNV9XjYKD/mhPzVx+aqse5l5SKhZkyFVFopUSs7w9QAvOxKDTBNpc2RcX5H7uqCa47hGKRrl5DdAQTBdulPYaj/kdD85uvcUWKzEGDg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/06/26 5:46 am, Isaac Manjarres wrote:
> On Fri, Jun 12, 2026 at 04:44:22AM +0000, Dev Jain wrote:
>> Introduce a boot option to tag only at allocation time of the objects. This
>> reduces KASAN MTE overhead, the tradeoff being reduced ability of
>> catching bugs.
>>
>> Now, when a memory object will be freed, it will retain the random tag it
>> had at allocation time. This compromises on catching UAF bugs, till the
>> time the object is not reallocated, at which point it will have a new
>> random tag.
>>
>> Hence, not catching "use-after-free-before-reallocation" and not catching
>> "double-free" will be the compromise for reduced KASAN overhead.
>>
>> This is an RFC because we are not clear about the performance benefit.
>>
>> Android folks, please help with testing!
>>
>> ---
>> Applies on Linus master (9716c086c8e8).
>>
>> Dev Jain (2):
>>   kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
>>   kasan: hw_tags: Add boot option to elide free time poisoning
>>
>>  Documentation/dev-tools/kasan.rst |  4 +++
>>  mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++--
>>  mm/kasan/kasan.h                  | 23 +++++++++++++++-
>>  3 files changed, 69 insertions(+), 3 deletions(-)
>>
>> -- 
>> 2.43.0
> 
> I tested out this series on one of our devices that has MTE support,
> and didn't see any functional issues.

Thanks for testing Isaac! Do you have the bandwidth to carry out some
performance tests? We want to see whether this patchset gets perf boost
on some HW.

> 
> One thing I did notice though, and it's independent of this patch, is
> that the vmalloc_oob is failing, but that happens even if these patches
> aren't present.
> 
> Thanks,
> Isaac


