Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87440CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7842F6B0088; Tue, 29 Sep 2026 05:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F2B6B008A; Tue, 29 Sep 2026 05:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1026B008C; Tue, 29 Sep 2026 05:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27D836B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:05:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B47DC1A0432
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:05:17 +0000 (UTC)
X-FDA: 85266215874.03.DD40DB9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B5AC140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:05:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AEVzYGRL;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790672716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puBoSkem55NRrg57AHsTm87RSJr9X0KrnQHt5dcEHjQ=;
	b=ceOQE80D40plDh4adm0c79djA6aMCVu1wfswHmyLFY/VVMBkv3UL/K7PvzDRFa4Nvud20z
	0kvx013OVkUFyqEPBlM6imOEPiV4tB/ILUf0eASwI2kaG5ZozBsj2uYaS59yuxPhxp3275
	pxHA13zmGOcJ0cZLl17FoqBWhZYIpHU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AEVzYGRL;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790672716;
	b=0p2yj5RJrmixpKRvqNRymNGXd/8/NOR9uF0ighbja3Do5ZNQ52EdIL3sbFlS2dRiqAZsQN
	GgxFL3sTGzXUT9nNQn+Gahuw38MHD/RwBrVKrJaeFquYRQ5pS4t12smxu+esPFHZIWyudy
	uVZpaEcl6EBmIrxaWX2el3rLMbGx5j8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED58A1516;
	Tue, 29 Sep 2026 02:05:10 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D9993F85F;
	Tue, 29 Sep 2026 02:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790672714; bh=wxmwOLxAhQpBe7UtMnjFcrSEnz/kEIYY9IPLyMGptV4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AEVzYGRLbEG6f0HWOgDUWAZxT88uI/fydL6u0G2bJG0cxIal7ePkx+TDFllEwLf/Y
	 TaT96+nTqZn119qDOq0Pr91rb+pZLZdEHWZqX4Krvm/iEgMIqAn51gHZDd+ZK+srBW
	 5UrQuhsQfxmLVqGLkg6OaCm2Ypzhxxo1rp6jQsgk=
Message-ID: <7edcf2a8-0dc4-456d-98c8-730ade633df5@arm.com>
Date: Tue, 29 Sep 2026 14:35:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/9] selftests/mm: improve mremap_test
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Kalesh Singh <kaleshsingh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <b8da4a73-296b-47f9-95dd-b8a74f3a0984@arm.com>
 <CAC_TJvexEaehZno0P=xsoCbLw7wgfz+22iV4fwzcuGCiu3vAAw@mail.gmail.com>
 <92ec3966-e68c-4dda-9d8b-9462f22c9e93@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <92ec3966-e68c-4dda-9d8b-9462f22c9e93@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B5AC140004
X-Rspam-User: 
X-Stat-Signature: dnshypo6na6ucnxq5755475eiht6kc6r
X-HE-Tag: 1790672715-222333
X-HE-Meta: U2FsdGVkX19DkACCwFmeQzFkjh3sgLWIWU7OihbwLJ+n7/9JVZfYYZZqeg6tuSHtOgC8o6cHynR5cy0T28faOZ3hpibcLW/9gVOJx9xZWEKVWHKI24ytoGRGndHzL/rRQy/bL+BMJi41Hq/y8NIPux4mbDUF4OkykmwZGusDLLodE2fpDEauTByhPgStFW5FxqrA0axdc0uZqk0ChZXvXy/0lYnAYTSjJDp/7MzRuYqVEhq22dP/GNt+6QH/CF+ccgbiXjizepmPFyJDpn2FcxMTr6ZqMPZ1KxT6jeF0VKaTBpp5xCzJwvI7FWKYd63XTl0MwmaziGtbwNirOUxmWwQalNwHZeFEuaDpCQxKlCBBAcItX25cT1D//VypDB+K64DRIXvbAx9pKAa1RyUBa0d5SRIX94mc41QoRWU7fsJsBuRHGSKl51n2xom2i2gt+0tqiAr4HpijnWItXVONFBCNxeXUSv3gZ0wqub3sUQBm/MFCGWKq/zucr1mXpRp5TckPfg5N1QRm2gX8sVdE6w5fd5/VlSp2iCmoRG+OeCWqgxr/qvBQ/js8DGYJDq5icVrXepMr2l56uvFTA/rUyGoW0oETYWowgF7CEwcKEt/TOAhMNd2sLwGU1wP7ygo3CmTSgiGsUZQ4AqXF6J0AMY17A68K4PvvItOodvP/BtePwYkvTjSqf3EBUdalJOThD491nNKZ18gck5Vl78bJyeaZNAP4MyJp9qgcrpAu0cDTzYejAU1PuvvqzlCobonvXsy827jfblM2SyKsat1jSO+bwohvufZubQ8+yagJ27cBU1yJjcCvCfk7uH1jew9OmPHXWDHTQu9XzPAqPJGAbEuozTByo6lsS9J4PyY0mUDe88En3gJLT+nE0i56FoQmUpjDqm8JM96qxJsHUy+XOjpLOPUWP3TIQXodQTreAQ2BLH8gpDzGChiqAQ1qD0jog02ZBAqQ5cmNSxNhLe9
 Ts8ZYNjG
 9lxd5k16iYfeSd/Ajw/uZNb+NmPYT99/TWNDY1rNGSWrFjNfLgLc61ZYkoIMb6PNij71uWoYlt6gsKkMKUEVy2wH7EIyqjy7I5GDa++L84OsNM+STfxtx/c2Jg2zpMON2a4fL/dl7pIU0HDN9CGB4f2+ydq32kVDtUbEGo8vQeatBiBFxAMipm3Bnwg+hY7CWGUHcEBXPJhfVHXljFdKZJhNF0R7m4WTFdc22pNLc5V1WaFwMV96LsMk3zKmZ//s0j2GA9tzIzVdq8XBTGXM/2slXPszAFWwAicD4GWsUqQGoVZ9yW3mkRUhWgBDVugT4bYg2Gk9NX8U0CbAJkPBTMtiPyqu4aPFGcKhfsCvwc+/iZfx3lF0ZZ6/34Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kalesh and David!

On 9/29/26 1:17 PM, David Hildenbrand (Arm) wrote:
> On 9/29/26 09:32, Kalesh Singh wrote:
>> On Mon, Sep 28, 2026 at 10:54 PM Sarthak Sharma <sarthak.sharma@arm.com> wrote:
>>>
>>>
>>>
>>> On 9/24/26 10:30 AM, Sarthak Sharma wrote:
>>>> This series fixes several correctness issues in mremap_test and
>>>> simplifies and strengthens its data validation.
>>>>
>>>> Patch 1 converts the mremap_test to use kselftest helpers, removes
>>>> manual tracking of failed tests and corrects some spelling errors.
>>>>
>>>> Patches 2 to 5 fix userfaultfd skipping, unexpected mremap success
>>>> handling, multi-VMA data validation and failure reporting when data
>>>> corruption is detected.
>>>>
>>>> Patch 6 removes the randomization and uses a simple pattern based approach.
>>>>
>>>> Patch 7 removes perf tests and timing infrastructure.
>>>>
>>>> Patch 8 removes validation threshold and always validates complete mappings.
>>>>
>>>> Patch 9 strengthens the multi VMA validation by also checking the
>>>> mapping state of holes after remapping.
>>>
>>> Hello everyone! Just wanted to check if someone has had a chance to look
>>> at the series.
>>>
>>> Also, Sashiko has a concern [1], and I had the same while posting the
>>> series. I hope I can get some opinion from the community.
>>>
>>> Currently, for PUD remap tests, we allocate a source mapping of 2GB. We
>>> only fault in the first threshold_mb amount of memory, remap the whole
>>> region, and validate the already faulted threshold_mb amount of memory,
>>> which is, by default, equal to 4MB and can be changed by the user by
>>> supplying a command line option.
>>>
>>> Since we plan to remove all command line options from teh selftests, I
>>> removed threshold_mb altogether, following some discussion on the list
>>> [2]. This would now cause a 2GB source mapping, and its contents copied
>>> from another 2GB buffer. This causes the process to have a 4GB RSS.
> 
> Yeah, that's a lot for small CI systems indeed.
> 
>>> Sashiko says that this can cause OOM killing in small CI machines.
>>>
>>> Would it be okay to keep a 4GB RSS in this case, or should we find some
>>> other way of validating a part of the whole range instead?
>>
>> Hi Sarthak,
>>
>> IIRC when I initially introduced the test, John was concerned that
>> validating the whole range would significantly increase the duration
>> of the mm selftests; this is why the threshold was introduced. Please
>> check how much it increases if we validate the full range (with
>> David's suggestions) and if it's no longer a concern from other folks.
>> I am fine with removing the threshold.

I tested on an Orion O6. Here's the difference before and after removing
the threshold right now.

Before:
0.02user 0.07system 0:00.10elapsed 98%CPU (0avgtext+0avgdata
87332maxresident)k
0inputs+0outputs (0major+21133minor)pagefaults 0swaps

After:
1.67user 4.91system 0:06.63elapsed 99%CPU (0avgtext+0avgdata
4195564maxresident)k
0inputs+0outputs (0major+2225058minor)pagefaults 0swaps

I think instead of the time taken, the more concerning thing here is RSS
(85MB vs 4GB).

> 
> As discussed off-list, I guess it makes more sense to validate a couple of pages
> at the beginning, the middle and the end?

Yup, makes sense. I will implement this then.


