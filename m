Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F95FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C49F900162; Thu, 14 Aug 2025 09:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C0F900023; Thu, 14 Aug 2025 09:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78BB9900162; Thu, 14 Aug 2025 09:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66A88900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:20:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 149D1140544
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:20:50 +0000 (UTC)
X-FDA: 83775423060.12.B55A553
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01C94140019
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:20:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSqZI3uy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755177648; a=rsa-sha256;
	cv=none;
	b=Gt6N26HwvOSWCNTrwjfa/ziqiX/jo3PbgE2NOrjYRC2I+dFOP5+6H/+BM6XpRT/jLERnhN
	G0Ke/XexpyTbNzCGOd8BywoBd5ZzCkOqZo7x1NKzE7ww1Xi8SS/E+oTIlH9UigNXzpbyI+
	1wJYolJjGfDHXpLhIYAuaQL8IOtQKLY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSqZI3uy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755177648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7jDafqYB98HwVmHR1rUWCQQF4cRrv10NE/cqOShDxE=;
	b=COctHqLnjIQin/0r5E75PT6xhHR9yr9tPThKNi+NPIgPI+YW1U81ffDgEmqvCtBcuv1S90
	G6WgE7YIB07gqA7HaN3enx0bV3tOtCIAgZTrTH4CRfiLu59HIuJUX4w9krzcFpgODeYS3J
	gITFNwhQZAR0KnmhGgsQF5hDLh38HHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755177647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7jDafqYB98HwVmHR1rUWCQQF4cRrv10NE/cqOShDxE=;
	b=eSqZI3uy+7L+5641hivOzqg5MQzjriuL6pRmh3hrBUJDGN7hQBdxEsiArpbaLg/4KdNiPy
	iUtLZlshX97LOKijlZ9t4lU7Ys96oWsJrNtv0PanhfNDfDeHbbDi2zFO6CT+D0kxs5Rhuc
	tPkPTHGauOR6JPTKT4ulmgBN7/V4w9A=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-0Iexnzj1MRqailsIT3ClwQ-1; Thu, 14 Aug 2025 09:20:46 -0400
X-MC-Unique: 0Iexnzj1MRqailsIT3ClwQ-1
X-Mimecast-MFC-AGG-ID: 0Iexnzj1MRqailsIT3ClwQ_1755177645
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55ce52874fcso395963e87.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755177644; x=1755782444;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7jDafqYB98HwVmHR1rUWCQQF4cRrv10NE/cqOShDxE=;
        b=fM0Gh6RX+bm4H5IGY7vzFVukyguDx6lcXTjAKSVcmrWOJJFTax3eguCk1HdcqK2Er3
         I8ZXbqNIg9PvmtlK3yHq2qO2qWscJfnf1qQPd63QPf6CNzzYiBoed4qwTbK5yWwdJvlR
         jUlH7vLLnc0RutD4EbF20cBGq9/M2insGl6EfuVJ096caR6EJuAgDnBoCu3+qPCvnYDg
         CurgEue9UtIZwlT5X0JBKKCJF62qQZVnNYe/PBfIF4wVHXnqNOZMYPg2i4u/RK3EG4zG
         39u3yLxaHI2HWbGbxcVU8wzhPDnvvwxcF1HS0Os//SR2YnRYg2E7dcYu+aRr6e7/qelG
         0lgQ==
X-Gm-Message-State: AOJu0Yx3agDZbWAQ+dLsuley6HaliwcH3TShYi1YC9o+10zh6nkmgcfK
	MrfYXBDErnrO01nKNokFaGzrFfeCyjwqJ82XQNwtmnEtJabs75q9ymwb7gaqm+IGatp5sR9L3qJ
	7giz6u0J2hdBTmmnOW+2LGaJCwsycvIROI+xzrdseRxB2JfsEcX8=
X-Gm-Gg: ASbGnctUFyXzNaBC+jQ1AUhq6Ipdf+G9DTRfpfxMraE4BJ2fSXNW00mmd+++jS2U93s
	sxNflGlkbBC/HM9Ifk/uLpgjQxWoFbK836GQCYiJTCxCj6wbnyUyuJmzxWoR6ZB9hNAsL1l9Fad
	wdDfxbN0ezo00AdCI3uypekl6Xl9h3ff97rDI9q6AyELxZaFuoJi6YO9kC3zieaNxix7mRaPsqI
	f5vJ/ep3J0DtQVs7sPBKUJCb1RNo9pStCZMfb4Ac11oN+4otdznzMNfYxszCNvdYfQzw+F+vtPz
	36C5gqYpeDVGCOpZx8v7XJYKXffmSptGeKVq62i80nMQnkGr1dMjCkUmXumrzfv/hg==
X-Received: by 2002:a05:6512:ea7:b0:55b:9796:5d6e with SMTP id 2adb3069b0e04-55ce4fda8b4mr814852e87.6.1755177644443;
        Thu, 14 Aug 2025 06:20:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWihT0k4QKDaAkdeReoErFsWLC1uspW0xCEZNbMy9GEmljSgmnx/hsb8xuhqqpYddj4a50qA==
X-Received: by 2002:a05:6512:ea7:b0:55b:9796:5d6e with SMTP id 2adb3069b0e04-55ce4fda8b4mr814835e87.6.1755177643940;
        Thu, 14 Aug 2025 06:20:43 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88ca3327sm5640778e87.127.2025.08.14.06.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 06:20:43 -0700 (PDT)
Message-ID: <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
Date: Thu, 14 Aug 2025 16:20:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250814130403.GF699432@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WBOaQuhZfS2wKRGtVATYcpAdoSvjjvYVseUz451SP_0_1755177645
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01C94140019
X-Stat-Signature: k1pwjmcip6nhptez7nkh9msfru5nxf4o
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755177647-63979
X-HE-Meta: U2FsdGVkX198ULhOyYIVnkk4jnCeSBwNs5gN1V8QYihZmghGH+3UP9kcuZ8HiMaji9KRcFsnaRsqpVcMGMhXc7W6JV/bV33Tc1mxomeu45r1rcGrwsv972K+Sevcpjl2Gq5QzAmYL6C20h8FUfc5JrartW6LZthOSbigtd4jCO033rmkvFZLIHtZocgrOiX46UsKwmdvxIjWlDaQVw+zq9dfFf0OO7o68q71TFnXRXC6MT4DHWbDZ2MqTXs9s9luDnjgdQAWUL5xp5xW/j1YTghrLfJhA9f6s0xgk7rJvmUjm8Qwq+ny8AruK+g6Jb6ku2MLRabTB+aeXZ9NjSgH+OBI2RXUvoH76pI9rT1wdwFLlA7OJYGf/WmHUO9aJk314uI4PBc9Ct4RudT50clkKUoXJ9JClqqjF/zVqiDMyYyGNBOixLJaBZgy3WzUqJp1o6B1GTWGNMSKvBhmT2H0KhZEhMxg7rQaHdqgECvq2S/lgb3ZbOBQy6hD8SPLIPOvB3ofr3WP6lC49I80NQIzvTwxbHPurq5FoBcDa6e3xAd7GYEJuJmgAZUX85It3rHMlMh7RuCK9q9eqTEnlRpd4mV/Qbu6V+5CYBYWAdn8c0buyci13TUXlkU+yftDbiuhlqUEltFyh7O8Eqyb0SB5sut+0+1aMGk/TgeWX4idtXIXKlUbzr0vPvAyE9TxiLKX2NTJZK/PcHVkpQmolbYjf2wAiTl9hqG9wSu0MezAwxmojuOOdZsl2Az/A/MNZLAPHe0RxcnKKg6evueJrNZjw0cGMWcI61zaaKuwzkfazDmDrUb2hcptWYBjDV4QfRG+3cl50BpsVfooIL7NUfh2R0D1izbWSBQhpEdXnlYRuEEtOBp5qFbfgFroUeelPZfKXIZc94k0h5hcT7JwK3cDUob119+18oIQibh9HjLQom7t+TeLwJQfNZDe36eR8QbmjSSOKJKYFTMcnKbAWIU
 /SZvG0T/
 qBKHF7O2VtqMwUFDOBiow5p9NJ0GFESUh48VsyJApJ6ohD95eFgRzRa0bu3pfZt9f+DuPtqgNCW1z0dGG39UeJXwO5wMw1BVQFkf+Un4zAeSIt06DIYuLtu+E+grjiUKPgLJP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/14/25 16:04, Jason Gunthorpe wrote:

> On Thu, Aug 14, 2025 at 03:53:00PM +0300, Mika Penttilä wrote:
>> On 8/14/25 15:40, Jason Gunthorpe wrote:
>>> On Thu, Aug 14, 2025 at 10:19:26AM +0300, Mika Penttilä wrote:
>>>> When doing migration in combination with device fault handling,
>>>> detect the case in the interval notifier.
>>>>
>>>> Without that, we would livelock with our own invalidations
>>>> while migrating and splitting pages during fault handling.
>>>>
>>>> Note, pgmap_owner, used in some other code paths as owner for filtering,
>>>> is not readily available for split path, so use current for this use case.
>>>> Also, current and pgmap_owner, both being pointers to memory, can not be
>>>> mis-interpreted to each other.
>>>>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>>>> Cc: Leon Romanovsky <leonro@nvidia.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>>>
>>>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>>>> ---
>>>>  lib/test_hmm.c   | 5 +++++
>>>>  mm/huge_memory.c | 6 +++---
>>>>  mm/rmap.c        | 4 ++--
>>>>  3 files changed, 10 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>> index 761725bc713c..cd5c139213be 100644
>>>> --- a/lib/test_hmm.c
>>>> +++ b/lib/test_hmm.c
>>>> @@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
>>>>  	    range->owner == dmirror->mdevice)
>>>>  		return true;
>>>>  
>>>> +	if (range->event == MMU_NOTIFY_CLEAR &&
>>>> +	    range->owner == current) {
>>>> +		return true;
>>>> +	}
>>> I don't understand this, there is nothing in hmm that says only
>>> current can call hmm_range_fault, and indeed most applications won't
>>> even gurantee that.
>> No it's the opposite, if we are ourselves the invalidator, don't care.
> I think you've missed the point, you cannot use range->owner in any
> way to tell "we are ourselves the invalidator". It is simply not the
> meaning of range->owner.

Usually it is the device but used similarly, look for instance nouveau:


static bool nouveau_svm_range_invalidate(struct mmu_interval_notifier *mni,
                                         const struct mmu_notifier_range *range,
                                         unsigned long cur_seq)
{
        struct svm_notifier *sn =
                container_of(mni, struct svm_notifier, notifier);

        if (range->event == MMU_NOTIFY_EXCLUSIVE &&
            range->owner == sn->svmm->vmm->cli->drm->dev)
                return true;

Where we return in case are the initiator of the make_device_exclusive. Otherwise,
it would also hang in next mmu_interval_read_begin().

owner is void * and admit used in a creative way here, but it can't be wrongly interpreted
as dev if current.

>
>>> So if this plan relies on something like the above in drivers I don't
>>> see how it can work.
>>>
>>> If this is just some hack for tests, try instead to find a solution
>>> that more accurately matches what a real driver should do.
>>>
>>> But this also seems overall troublesome to your goal, if you do a
>>> migrate inside hmm_range_fault() it will generate an invalidation call
>>> back and that will increment the seqlock and we will loop
>>> hmm_range_fault() again which rewalks.
>> That's the problem this solves.
>> The semantics is "if we are the invalidator don't wait for invalidate end",
>> aka don't mmu_interval_set_seq() that would make hang in the next mmu_interval_read_begin(),
>> waiting the invalidate to end
> I doubt we can skip mmu_interval_set_seq(), doing so can corrupt concurrent
> hmm_range_fault in some other thread.
>
> Nor, as I said, can we actually skip the invalidation toward HW
> anyhow.
>
> At the very least this commit message fails to explain the new locking
> proposal, or justify why it can work.

Yes the commit message could be better. 
But this is essentially the same as nouveau is doing with 
MMU_NOTIFY_EXCLUSIVE handling, just not using the dev as the qualifier,
because that is not easily available in the context.

--Mika

> Jason
>


