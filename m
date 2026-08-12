Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3F8C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C4A6B0174; Wed, 12 Aug 2026 07:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D676B0175; Wed, 12 Aug 2026 07:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA67D6B0176; Wed, 12 Aug 2026 07:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8E366B0174
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:45:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 643D5A2189
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:45:05 +0000 (UTC)
X-FDA: 85092436170.27.F90685F
Received: from mta1.migadu.com (out-96.mta1.migadu.com [95.215.58.96])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1C7404000D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:45:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Whc9hjyv;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.96 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786535103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awLAirVT4o54D5QHWR7PPvKWFAWXMSXCaLME1biIOnI=;
	b=oH4x3RMf48iq7rXtZVS4Lt/EHPxxiRh/P2Dul4MZR60IammHyzX/CPV57M5tVA498d87vD
	wEOgPors7BxHr3tu91IaBb3zNu7D9azkjcDZVuZcvUQhGUWPQ2jPAUSLoY2WPs1Z1KxFEz
	oQXInwDnD4/QRSe/YmaC0LVdTO3ZZ80=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Whc9hjyv;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.96 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786535103;
	b=OE5WETGdazhDQvW5oVQSEqMlhk8zV+eNOl+CmDupElfkTKrZIo1XftLisnPC3oY4lFnNuE
	i+doAZOfuEXPNGgOBcR0PFbiuIqyRKP4PhoKUEOSeC6P0dptaemY4iZTncll3+Bx2jYIqE
	0FTalnSIc0hNtL4JYfXDHOR6oX/b7AI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OeJXuVy3ZiqMCZp1FFMcdF8rNLBZd0geSn/rRWorVVs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786535101; v=1; x=1787139901;
 b=Whc9hjyvjWXoDATryBpBZNIVPy098CX5Qkf6kIq24ywjwXBIAz6lEYsEC/FztPgW/18OtxaK
 cIa6Fgdr56BRwgS2OSlAoxbBvTyIX+gi57v+IOL24+yw6bx7YfkjCK1yx13m4SLjcThSLRVWFN6
 vpwr1Z4iToHvckgALPF9dbCs=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id c332a69d1f0206ed;
	Wed, 12 Aug 2026 11:45:00 +0000
Message-ID: <f83cbc30-ddc0-4c2b-a01e-4ba890df44ae@linux.dev>
Date: Wed, 12 Aug 2026 19:44:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cui.tao@linux.dev,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
 <a318c942-0776-4678-a9cd-504e713d25f5@linux.dev>
In-Reply-To: <a318c942-0776-4678-a9cd-504e713d25f5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C7404000D
X-Stat-Signature: 7no1pkyctcf1r66efkucp7b43s6ich58
X-Rspam-User: 
X-HE-Tag: 1786535102-293375
X-HE-Meta: U2FsdGVkX18nsF/8aVnzywslpklVwfNv1LxlfXPOkRNEfBa7Ho7DBw0kIADt+VLzAIYbBDcO47e8czuN3am41Do9iGgUv2PLK6xD7RudwydKSFO0QECNG9FWX9nVjk4ViTSNOdiapCuoiliTgeJjKHmt90n5X25e352eqa5ABSfZm7zNL1sEGc69gRB5arUsxeCoqUlfCBg2eZ9c/KXS4Ccth63KmMQkNjbeYylpZutprsFzIv0lDql8XynLt8YgQcHDPKxFJ2vxRZvIorJfRE/kNnx9P7LeqYm34qdiIDVNGV7EKcjlSz5snzNZJHczFZs7bCK91xQmh+QDYm0dyI/E09xcCzbCBAZJeSFFBcKtsWtpBOXN/0vO4WUfxJq+1XSZ5EQWSgMt9CMkt2danv/4/Q3u41I4QvLRm02S8YYO3fElwGl4oyvNjOjANllo4mO6Mpm1d1MGWiyPsTPQTCCVOEfhNU4I3GsQWnSjxu2ivI12E7znFMPQD3rULrEw/PN/P1Eg5t0b46xRQjeepwnPmwmMni/MfPwuhQc2numw860FSkHidqeJQZeAK1hx4wV7sK1Z3fHMdnXGG2Qed2vWqZomrIMaNOA2llWpA1+Y/TjNe7PFBDxF+2BL1ekpct33O1HIycm7D2WUnXpqf9pKJnYMzrhcOGwXz4JYDdJ5GsU20BCcK9ewpY5GoSd+tW+QFwlg5iYsC9lDrrqGTUuks2LICDNn1tymGSUQrBde3OPSTgc07adHKpm+SeA1ALA9JCJ8WGgSsjGJpsClr36h6tbhIxOLF8ww0kLr6chvwIAfDF1cWAslilL/9R+V8aJh90/ZQucIzVH8b7kqmrwlWthIzOd7AbuIyKPCm8VG/xJChsCy4rcj8riBXb6XKxLQWynmTrv9dDIlZioNb0PqKc2cSDSG24KRSxAMoMIuLOOGSGXvc0B9L0nkIdUdIF0IejKEtorw7Rgb1DB
 WU+CoSAT
 kqpHOvq8l+/Rf3nrklIK9jp3hYRSEqYIXdkYwh+XPchkwsi87Sx007/JOBvlFOWtSAf2mkuajLAJ35/GttL/8ocz3rktytUwDkcyGuGmAi8JCNAP4O8FXa+tWTuomPcsyJhb9EA5YeHY7w9pqr8cUvmWVFLkuWMP8WaainQBkl4qzBh5v5G/jsFdnzvo2JfOflxoyBE1pgkkA30lS6tmbQHQ8n2hjr9dsEe3R7vezNKAzf/YfGM7i9ub2TildCYkB2Mu4oR1VzW6qGf7SWreRZbHdJe6NRO9PD1qnlH3bipQgr7RcI9QBtcrokchHA7PF9DONlsLHbWZw2CSykF26rx2aDl5NLRmZpRn6YnEPJ8YN0EE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/10/2026 10:58 AM, Ridong Chen wrote:
> 
> 
> On 8/8/2026 4:22 AM, Andrew Morton wrote:
>> On Fri,  7 Aug 2026 16:59:58 +0800 Ridong <ridong.chen@linux.dev> wrote:
>>
>>> Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
>>> c6f53ed8f213. Each open fd reads back max(its own value, the shared
>>> local_watermark), and both bugs live in that scheme.
>>
>> Thanks.
>>
>> We're missing the preferred description of the worst-case
>> userspace-visible effects of the bug.  It appears they're quite minor
>> so I'll assume this series is a post-7.2 thing.
>>
> 
> Agreed, post-7.2 is fine and neither is stable material.
> 
> Worst case for both: a reader of memory.peak (or memory.swap.peak)
> gets a value lower than the true peak, so a tool that sizes or bills a
> cgroup by peak usage under-reports it.
> 
> - Patch 1 (reader side, take peaks_lock in peak_show): a reader that
>    races an unrelated reset briefly gets the low value. Transient.
> 
> - Patch 2 (writer side, peak_write reset): a reset on one fd stores
>    the current usage into the other watchers instead of the old
>    watermark, dragging every other fd's peak down.
> 
> I'll spell this out in both changelogs in v2.
> 
>> Sashiko might have found a similar race on the writer side:
>>     https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
> 
> Yes, that's the writer side that patch 2 fixes;
> 

Hello everyone,

I would appreciate a review of this series. Should any feedback come up, I will 
update both the patch and the cover letter accordingly.

-- 
Best regards
Ridong


