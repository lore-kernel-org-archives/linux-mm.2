Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E47CC4453D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B26C6B0092; Wed, 22 Jul 2026 05:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688E56B0093; Wed, 22 Jul 2026 05:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1166B0095; Wed, 22 Jul 2026 05:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25C7E6B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:58:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93F251A03DE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:58:19 +0000 (UTC)
X-FDA: 85015962318.16.BDB882A
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf06.hostedemail.com (Postfix) with ESMTP id B72D7180007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:58:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kPcNh0nm;
	spf=pass (imf06.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ijy/gLpb1NwFXbgR00G1evfvLl/4vAA++YOqxk207ZE=;
	b=p1SLknP2I6uKth5/WSTzVClx97yay3hsC9p9knHI/gSHFN1w3LrBl/E9XboddNvNkGhIfk
	hYxzL5YLYcg5hjlm4HhJ4peyA9Xz0aHJjMOh7mMnyaWFwi5uO8UpJ60dvu+kiJVpzALijL
	LI0is6mYYlYnYdyELfg7lDGtHoY/USo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kPcNh0nm;
	spf=pass (imf06.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714297;
	b=c3v7SftC+oqERnlmea/cpwxw192RnHJ7CV+M5dEqMnvdk8mez+ft9ia/TPJEW+8Vc2he13
	E0nv05GA/LX7mfaMFDycIV8mPTMAez2lbAKC29qg8AzLL6neUz5y3mnERVDLAKq9sBj20a
	NYHZjIvx9fNU3RjgOxQceiRvOwzr0II=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c96739a46acso6750117a12.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784714296; x=1785319096; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ijy/gLpb1NwFXbgR00G1evfvLl/4vAA++YOqxk207ZE=;
        b=kPcNh0nmQsSyt1Wc4tQZ5jgOQ4aVbMwcrfF2QwwhBn77EV1gcjTg9McYlwVblRWHJP
         6TAwyJu8czLZU032XlIXv8LqCMQ/xz+BlmTQpPiR0QhbD82FZXXVPePUxkxDBP0Y2PSq
         PsE5V6Ki8q4ZdWgismbDH6zakwWXTiOF0x1X3mKfy6Dig8NHBXb+RgZEA2uTTyJpg7Ju
         UGXEo/puD3jIRzB+Lxuha+HG3+DmsHni4ofkkD/+ZgpC/GtIPam91DZa/tHEOJKJIBHl
         gTuvDmZ9WIASH0x12LhuTpVqrpQxhkGNvAzkwm3ZcerMWe9bkStvbPfHp63XC91+JrEk
         cWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784714296; x=1785319096;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ijy/gLpb1NwFXbgR00G1evfvLl/4vAA++YOqxk207ZE=;
        b=fWHd7KvQNhwanYYPD35Q+jn70dC0muStwvWam+ehHgq6B52myd9gGnUJ3YRdtace1q
         UwVWmm3yzOW4q0pX+JuZ+cHGyWUg5ClDY7Kyl7A8+qWXCj/1SWHu1Hz9KIvANH8qPDAF
         //iFc1YX9n4GCqXtG3lOo9l5DFW5sV13wOaEyb4fMb3cpb33b867saZbffGrgZ085tmz
         DcaJKRaNEmirLH0nYUFHOHwlemgyLY4TeLr2WONbV7mFNQsu0gS/5mxbFM+03z8aBkTc
         S3lC84PlT8kbnCngdmvnIuCUOQbm3eD9yQkUYxBxadYkCMusI0rSf0Pb2ZjXDysMSv6N
         6xkA==
X-Forwarded-Encrypted: i=1; AHgh+Ro7AGy0yQq7ytrLEuDOZtG+i2k/tITCEYOdCMIbG/ShBCXMiKrP3654pRB26bRCuBPQKeURjPqvfQ==@kvack.org
X-Gm-Message-State: AOJu0YwivGbLx5DeyB34hU0fKrIyUPHpOhZYohV0JceHtjQeYx7Xc9xF
	q68mB8YTAmsUOtjcucMToZVx6pAJ+j+2X/LpuZSBgnj6OoWHnH8iBbI1
X-Gm-Gg: AR+sD115+VTf0Ske4plQTSkmTIndu+3Dufs80Ir1oLF7b+/K9Tur/c+0TDVh7OXkE+F
	+PKrWad2cL80LNucYimdNpivSvdP8AjLSMaUdwgGxka1YNABnQzC/1uvvCJ0n+mNuUgk6Y5l2co
	fEjrgcKcQIY2XfCuUjeQ1LcJXF2Zw0577lif4jAQSlI0XAJuVT1V1mX+NbzyOAiipnViON6H972
	NeikkAgmyL575FHE/yrW11mTXiMU52a2JwWCnZJ+GmIUFfNexWuCK6afE9/iRYP6qFoHrKT46J3
	R1SvyKGexK8HiJ2ny3gG15E57f4V49YL8EDn1Uh1UTVk5CJq+ASb10RmfcAzFbr1hpLBQ7ml2KX
	sRHPdqTTKWKUZ92nbdk/nOlK30HgGuKtT6r7ulDvfrzPaY1vmqH4hzRu+G5ANR9dVZCftcTbQYT
	JCeNagV7dg2g==
X-Received: by 2002:a05:6a00:23d5:b0:848:4754:28e5 with SMTP id d2e1a72fcca58-84c292393e8mr21888359b3a.16.1784714296477;
        Wed, 22 Jul 2026 02:58:16 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e172862d3sm1045545b3a.22.2026.07.22.02.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 02:58:15 -0700 (PDT)
Message-ID: <2e9902e7-3f40-49d5-afb0-e710fb01ab39@gmail.com>
Date: Wed, 22 Jul 2026 17:58:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: vbabka@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
 Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com>
 <9b227263-56d9-41d5-ba8e-c969d8d68785@kernel.org>
 <20260709131509.iIPP2VBh@linutronix.de>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <20260709131509.iIPP2VBh@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B72D7180007
X-Stat-Signature: uhmi3m3d36kqtd7ifagmcy7rori4ip5j
X-HE-Tag: 1784714297-370973
X-HE-Meta: U2FsdGVkX1+25+czaJQl/NYz1nyCP6QisHDM7S4lRMSbUmDepPywaS+NAIpK18zqQ/oOBSzR+GtAlZNRB2Nsqs7khOI00BkjUusywj7DkeVV+cV2v1y3HsIl4jFP5Zlq53SgW0e9Ooz/F8ttMGxMTHq1XhX8TigielL4d05Y1n8cGHATXElqoVGlA8A4kxUyhazM+tPseGpBcdbd91G71ay4iaz6nyF3PUgPpUoxZKET4olPuDRN4UUXqG5xAU695RhQZuvmF3rEZCWF9CEbeXCTOUr1EY00aKnCakgfRTIeWD7ZZ1n9uAHwsaNQswliGUOx2RGCW9LaDztfBrFyu3xXog+h1juCR3do37KSsE5ZQu5SloOQvIWVn6EhAyDq9T5HeVaI6mEpLlqA8/UIcjlsVGAfRdzrvoPI53dFXIhj4LJK3QTczAyEpjHu4TFp2IRk3AqPGm8M2iyqeZc6xSYdxsqjVX3s+M9dNuBBoNd+5UBr6KLiZDA+qsifgeM1y3tFBZHG1sJAku3FG025r6u5dsEF4x3ApYELwlOprrdY+rq1pR+R8AGS1on0fEWp98+ygDACsyJlQseOX7aKjxxoV+KIGwRQ8Yr29f3I75ZMbrXQd1F9jqsdl3sbapDL69Wl4gKfcSZSed7fmSmwjmTevAyR9kyMecEgGD0xfRY0yiYd+m24Icbn75ww8y99PIH+IWOMFPYNSjkYg978VPAi1J0b4KbfSq/hxGt5gntNacgFJe6ZLSHYyXkXWawGaC1kVc3XFwM8qUa1yzO4tMfkjJnTgyto5MMo0JyJU74Aeoww9epVmg4pEIg1nFxFrFJwfuhaGnnPSASIAWmg074FbBtT9hDhhcAtfk/E2dflMLttV3AyQtFSFw1blPjNoJ72U/yKCKX8FfxR+3sd2FqQCrIrWDEUsrlrEUfbCZaLMlgUmvhZZKaW4bLydcmiK1loWcr5QeMgGLex4fQ
 94fNUM87
 G53xZLL2aldTZ+E7M1jrd1TIcvrHiSlCnATKNDDQTPFUhfYTs4hwbs7v2VJrDLMrnOHawZS69YDzY/EMybFzF8AeEMHktTjETd49DqIgh2G1AHNQ6vOoIZe85kSB+YHPhwY646PO5B9fYcCCwN/PUS8nX7nUP5T0kKFrmsPO1tcbHTP1q14msE/BxXs3YtuhQDUPiDk6x2/Qq/PBtHr+E0l7JRKloOiKs07PuqcTqBNI/zwm4sFc6Da7E1gXBNeNysljT1M85o8HZLwoyLE5ZOh4xbLePinpWQ60V1X3geDL9/73wHR7QXSGL1SFWx+rEOsqf7bzK2w8Z5UB9MLNNtdCjECd9UyyFHNACDQv7oh1tvZeJaOAhRGJszPH2iGAfN0nXrxXU66nPJUGQZHpN4MPcrliDvk+hTIchlRfgAueK6MyHW4ZVf01aWWgC2dwko0m9NNttv9U6icOFqobU8i+TUiVpKmygBq8ltQFICeDX3EX5+wYBRkJ4h/4jJ8ltlyzr76sAPU0yy7JnE+RswyVLllVSbWE59Op2H6MA7Kxz5o79nzKiIlT3FhHpF7+5URYb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sebastian, David,

Sorry for the long delay in getting back to this, and thanks a lot for
the review.


On 7/9/26 21:15, Sebastian Andrzej Siewior wrote:
> On 2026-07-09 12:04:33 [+0200], David Hildenbrand (Arm) wrote:
>> On 7/7/26 14:59, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> The region covered by mlock[all] may contain CMA pages. cma_alloc installs
>>
>> What about ZONE_MOVABLE where memory is supposed to be migratable?
> 
> Would it be bad if the pages would not be movable anymore? Does this
> effect just memory-hotplug or something else, too?

ZONE_MOVABLE does not need the same treatment as CMA.
1. On RT compact_unevictable_allowed is 0 by default, pages in ZONE_MOVABLE are
   never migrated by compaction, so no latency spike, no problem.

2. For the scenario of memory offlining within ZONE_MOVABLE, because of offline
   is an explicit administrator action. Any jitter/latency is expected and
   acceptable, the operator chose to offline memory and would not do so
   during an RT-critical phase.

3. cma_alloc() runs at runtime, triggered by drivers as part of normal operation,
   and isolation path hardcodes ISOLATE_UNEVICTABLE, so it migrates the mlocked
   pages and installs migration entries. The fault-and-wait latency hits the RT
   task unpredictably during normal operation, which is not expected, and is
   exactly the spike this patch targets.

> 
>> Also, what about drivers that mmap() CMA memory to user space, and
>> __mm_populate()->populate_vma_page_range() would actually try mlocking them, and
>> they actually must remain on CMA areas?
> 
> It should be safe to skip those. They belong to device and they
> shouldn't be affected by anything including getting swapped out.

Agreed. Only LRU folios are ever isolated for migration here
(isolate_folio_to_list() -> folio_isolate_lru()), and device-owned CMA
buffers are not on the LRU, so they are left in place. I'll double-check
the mmap paths and make sure this holds, and state it explicitly in v3.


Best regards,
Wandun

> 
> Sebastian


