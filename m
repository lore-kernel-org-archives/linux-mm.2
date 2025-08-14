Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34ED3CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E6B900159; Thu, 14 Aug 2025 08:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F17900023; Thu, 14 Aug 2025 08:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FE01900159; Thu, 14 Aug 2025 08:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59063900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:53:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07EFC1DD3DD
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:53:08 +0000 (UTC)
X-FDA: 83775353256.05.3BB6390
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B49E81C000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:53:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PluK6MYO;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755175985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkqp06LVuvnkdhq6f0nGSY6KoGjayeRy+bW/wP7Ou6M=;
	b=RDRzHCWPXOjCMnfQkW/EuzBADRONY00hE9GkKTMDBlHFc20MOcL7TzGgTt9KQmRIkxKkxZ
	zln5VlVn+ZdUwbYaPkRRKWLELnBvhlo5vrB2qLan+x45GhQNlt3LwSVpODXfRYvumQ87FT
	JrzHKvVWxmse1sIcNeFlzUwnvZSv+H4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PluK6MYO;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755175985; a=rsa-sha256;
	cv=none;
	b=omdbSBtRSIA1hQII+9ZO1ErMOIE4EJjyT/Q5EagU/UAvTbDznt11wWtT9n9iSBE7bOhzII
	169wRMAWHKWSYFoN7w6xoSs8xGST7IunlnVLiIRG31mYuBFMdtzveWn2PGjisM3hjVTALo
	MhrCia7royhQjOV1d4YyndgVeXRRnT8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755175985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gkqp06LVuvnkdhq6f0nGSY6KoGjayeRy+bW/wP7Ou6M=;
	b=PluK6MYOx1Li59mkmGlC1ZJU69yhJJpJKUbifCmGBA2ktfKmkFQ/3Hfy4ncULvR657kiN+
	QxngmkMdHtUPVeaaH601hSt2tpd+rY3NovI9JvBqf3XSlRftHBIZ93Gd5VZX+ya8euaMcC
	kWy6aAvvBwCd9431lvHS6InzBzBpw5s=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-hGN8GBXdMv2-aRCmkVoo6Q-1; Thu, 14 Aug 2025 08:53:03 -0400
X-MC-Unique: hGN8GBXdMv2-aRCmkVoo6Q-1
X-Mimecast-MFC-AGG-ID: hGN8GBXdMv2-aRCmkVoo6Q_1755175982
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55ce50a223fso782826e87.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755175982; x=1755780782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gkqp06LVuvnkdhq6f0nGSY6KoGjayeRy+bW/wP7Ou6M=;
        b=sy3+mZRtVsFVVYPXmicza9s5Yfcdh0taR2fI452mBC6NljgHylufZxbyESOmhh7BnU
         HSJ0Nt75PP4SCji52NMNeymnREOh1mQlm4YoHnXTtbuOnBUjU6M1HE/HFtjoOB1bJOM7
         uQciPmwdD5gDfTci85oQWC3fPVSLTmcJzI6VETwnAZbAZS/gbb0KNS3aQDPemPTekNZa
         QK3yotFnpGTS6c5bpR972NA0EM+7qVyvK+fq5pgxrDtpSVSPw3aANTzDcFNVo3tzsT1/
         pcEROKgQlVZDjRyb0e/sASuutoo4nojN7QTocG0JSS+hEHZHBaIj4mR+e7pAeBAwsa7f
         iQdQ==
X-Gm-Message-State: AOJu0YxiwU3KQXmzhoZYMvjJueLPIo/mBzPS2w8DjbbgJeIhkbK23fWL
	DPyu2I9I+/s40lyyYdgP1s2uJ1Y90rOimXQ0VPnE4dri7KAMfMXrgJD4JC+tLHbUuxBjkkkss0V
	xWg1KokGNjEsl0Ph59znSQmstmHz+Cxn4lnEaSsH5St52S9xOlMM=
X-Gm-Gg: ASbGncsR04pTc55rqH9zq8FgM0cuaEusszG3hEw9MzrkP0TKGz8lglpKwz4eGsSKu7c
	vRriNR3YeHRiaCjwSqUxyVLBUsk2x3yTFgU/mkizy1Xb2dLkmdQSE+DLOmBGklDqPiGJGF9mDSZ
	EaM2//io9C4ipNktF3/k9+gXvRArP2KwuD8P2+/MW8Uf4pO9BjpkrImqoSlQbl4pdD9F45Us0T+
	nTssX+dLMI77SwB/yqLIqMCugwpdtDBlIrVK/DCVgnlUswV6zRTWeH/twRrWS3WPiheDzbOc5bO
	iWagWZS8Dd61hzC+q70uajM+nQKo2sb+q2gW4TcIuMwwiLiARkgiaWs9TAGzCAGomw==
X-Received: by 2002:a05:6512:400d:b0:553:2868:635e with SMTP id 2adb3069b0e04-55ce50007a3mr883143e87.23.1755175981828;
        Thu, 14 Aug 2025 05:53:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEG375rEOoKk7hMuMXUSDUYkUvzFBpA7PIhf/LyWe5qb95ux5we6DJ4lF3xD0lmIWTi01DiGA==
X-Received: by 2002:a05:6512:400d:b0:553:2868:635e with SMTP id 2adb3069b0e04-55ce50007a3mr883116e87.23.1755175981298;
        Thu, 14 Aug 2025 05:53:01 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b9fd163dbsm4752367e87.156.2025.08.14.05.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 05:53:00 -0700 (PDT)
Message-ID: <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
Date: Thu, 14 Aug 2025 15:53:00 +0300
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
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250814124041.GD699432@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0-GKym9_rxJigGWCTVaBqfoqVr4t5BiVhvtpW9WI7TA_1755175982
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B49E81C000F
X-Stat-Signature: pejm36txiii6bj47wukcnpoi87q73ck8
X-Rspam-User: 
X-HE-Tag: 1755175985-784791
X-HE-Meta: U2FsdGVkX18ACsdzoj9I4h2tvYyUabxvyhnNHQk7rN457aso0mgjRahisnWOX51Nh7Qcc9eSY/3RHjrd/hiVcit1noucGWzipC52SvTY9Tw1Lnov1SjzE2BVl39KEEYMr37LYbNs5So3TUYxgBL5fo5x7bHDmOwkwWQJGSE2SF/M5dWNxlmFgXLsm+AlIEeHIMUcRmvXEsoIhzMVEQcWd5/N7C7X10M+BZbymftKGrFCS9+GaCPtoBH/1g6KAwdxGYcT5X/dpG8rWTBVzZYEtwF+ZQroXts6dCG8RuR4RBGO8cQxWLyQIQNcZihuKJD8nSrY92uixlIwOTHrs4eg8hTVy1MJyoPPudGGpTQnJ/H8V/6TlcuvJb2GsMmZh7reZAbwS6wytQ53+HJ19eTwJjamg0MW0z47TEl07xHlefg6q5vGgNrJNICseacWFPoRhUn4AaO7WOIhJxebz/3veULmOcMHBMpO13KMIkPD4izCyX4EsorvtcnQ2RTAUJ4F+n2dJt2nURWXpQ4kLf4b2c3JePbD3Ma3zECAYhtDvGRIHPjcwWqRcBr8hZbMitrFf4bsQRaoAQn3RrogjGRLuO2G3lR+kNVjwO7YiMGcyFRDh5O74/mexOBOW4gX+INFA1A5qYwzCSzdFATswipvjsQg+ligSFx3rt3DpAV0K2rFc9mA9SkvnNguVUX/Zjjby0VGGh3m41pO9st+GdfloSA3gPvwUBgbZNUuejy0XNUVxvZ9Ime3xb0vgkgUhvVNp5r6RUcJLYImJCM/FAE8vGaGGAQTIJBS35bQC3wubnOyyafHpd5wTZXmQFeQbZzrhnXeW9SLiKHsCF3nKIGK0qJOAXI9G4L4a7i0U6JbHajv1Hba7jctaKyGFUdd6yB/1MFYH86eYp8j/cqp9WjQI7+gF27NZZ0t0D3nOyeIj7HMrMGd3+jtE/sZaqPkjxXJf39laEyX0012d/NR5jT
 IRoa/sJa
 mRZa+yGbDoLtEqcszwk60wjD+9CuRFkZMsUWE2Ys+BwJKDGwbGq6nyavz8kJMUKdcqH8rnXb+5NsqUQzgmUyjORmsLjf5edJnYFZN7bAxb1if9SXhW3o+4gZCW8gTcCofTA/ZhNrHBAZnShOmOSy18w8itMXlUYXLoiolK+HgXkuB2fmNeEMzFVENl8B7eUH+MY7yoVkXfWxM6HLkT3CuvAEQztGKLfwrZSARogK1rckI3comGDW4odJZxADMrakoQXyr1lBEzEzAsxesyQQgtkEHyHEBBgBp0KCOlG5LGOXSvi+oeyohpUUT03AMecWychlbvE8Ay5CiMfE7+iDtk/Q1HZdW48eQ0pRsZC4sQtujfDR7yY+5K1elgMqAf8Z1TppJGAjlv8k6KwBQ3PsgxGmF7T68QK1wwoKh7OASbrhn7zJtg7T78+MMw6eRq5XQYz7G6cxOS9BW0E5lGLpeuTilH/GI7+yMoJEx6x5eyXqigCYhW27yOjQK4tm6LDFkUnRDfzmiGymo/IIrnt/qLoD9FUPPhanXyW1F6g2UkxwN38au9dHZUx3bMqiNfUz7XK1K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/14/25 15:40, Jason Gunthorpe wrote:
> On Thu, Aug 14, 2025 at 10:19:26AM +0300, Mika Penttilä wrote:
>> When doing migration in combination with device fault handling,
>> detect the case in the interval notifier.
>>
>> Without that, we would livelock with our own invalidations
>> while migrating and splitting pages during fault handling.
>>
>> Note, pgmap_owner, used in some other code paths as owner for filtering,
>> is not readily available for split path, so use current for this use case.
>> Also, current and pgmap_owner, both being pointers to memory, can not be
>> mis-interpreted to each other.
>>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> ---
>>  lib/test_hmm.c   | 5 +++++
>>  mm/huge_memory.c | 6 +++---
>>  mm/rmap.c        | 4 ++--
>>  3 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>> index 761725bc713c..cd5c139213be 100644
>> --- a/lib/test_hmm.c
>> +++ b/lib/test_hmm.c
>> @@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
>>  	    range->owner == dmirror->mdevice)
>>  		return true;
>>  
>> +	if (range->event == MMU_NOTIFY_CLEAR &&
>> +	    range->owner == current) {
>> +		return true;
>> +	}
> I don't understand this, there is nothing in hmm that says only
> current can call hmm_range_fault, and indeed most applications won't
> even gurantee that.

No it's the opposite, if we are ourselves the invalidator, don't care.

> So if this plan relies on something like the above in drivers I don't
> see how it can work.
>
> If this is just some hack for tests, try instead to find a solution
> that more accurately matches what a real driver should do.
>
> But this also seems overall troublesome to your goal, if you do a
> migrate inside hmm_range_fault() it will generate an invalidation call
> back and that will increment the seqlock and we will loop
> hmm_range_fault() again which rewalks.

That's the problem this solves.
The semantics is "if we are the invalidator don't wait for invalidate end",
aka don't mmu_interval_set_seq() that would make hang in the next mmu_interval_read_begin(),
waiting the invalidate to end

>
> Jason
>
--Mika


