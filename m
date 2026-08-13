Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C1CC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA4E6B0252; Thu, 13 Aug 2026 05:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5ADE6B043A; Thu, 13 Aug 2026 05:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C229C6B043B; Thu, 13 Aug 2026 05:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0D06B0252
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:18:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0333980537
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:18:44 +0000 (UTC)
X-FDA: 85095696210.12.93851DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49D62C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:18:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bWIcRYVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786612723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GetBiy0Zn1Zt+WVhmIztIBXSgbwgf2K+rHp84uzlz2E=;
	b=PbsPC1TAdJozN8l0dhGN7Q2Dtazu0uCoCOUwJ3lIeRTVmWdHq8iSFjjK81TIEImvcTfrkS
	6l25LggJW6W1Y+hcyV6494nGifnyAtlmmxh5zKHKtzalzBX+npU643N88ekPm45c2Vxc4m
	3pnUYCkDN7uQlisCgbcfp/gSW6072Kw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bWIcRYVo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786612723;
	b=KEvVg5xRXxNjoLZ30REjr8AGQp67upz/hl+Rd6AnhJiHOhEIGm8S5DQuPior4ZVkF8dPgC
	FYruSKjCiz9D0YNY5RFiaAEZt9RzbomubVwsYwoPRTHvminzKxWMnn4166Aazao9hs6p66
	ze1WhMSr9GJxLd7qZ1fQZ22z9pxAjR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1C64600AD;
	Thu, 13 Aug 2026 09:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F781F000E9;
	Thu, 13 Aug 2026 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786612722;
	bh=GetBiy0Zn1Zt+WVhmIztIBXSgbwgf2K+rHp84uzlz2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bWIcRYVoSsY+NP8RDYGqeCKfdNSxxjBsO0HFtspwgEIcp4mxv6MIb+2TtjGjCRLw9
	 hIFNHL3xy64xAuU96ONyJA6lJgCdNyALdgyI+DydU5l+v+zFz/J5b/Y1Kd30ZurMF5
	 LX4SUYoWQFIjEvpb0hBaybB0GmnOwdsg4e3tYQF94wvU9f1NxWbA9ptSNnR6vuNgF9
	 /pBx8beROUiTVDlXLjY9uCUrg/A3FYGguRxxKdoiDYMZa0ZmOsA30p8M+qmovrM09i
	 ++Q2dp3raik6cTHMydkCPT3cK/35vli7LyQG8Ow9StXI6zByuJcR/6Mea1EDO0Ksop
	 xQtWNqBuv2IBQ==
Message-ID: <ea3c2889-343b-4eba-9758-cf56c75da4fc@kernel.org>
Date: Thu, 13 Aug 2026 11:18:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/20] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alex Deucher
 <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-17-ab318a350404@kernel.org>
 <c7930f14-5978-4709-bac2-54950c988883@kernel.org> <ant1xwiG3djtoXoe@lucifer>
 <14a06774-4157-4629-8327-b1a6bae24ab7@kernel.org> <anyst_4LGm6bpWdq@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anyst_4LGm6bpWdq@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 19m43nr79r3q7rbw1txkjc8uwr918e6c
X-Rspamd-Queue-Id: 49D62C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786612723-977623
X-HE-Meta: U2FsdGVkX1/XqKnNCDu2L+XdziuOubbe+0LK7olbhIHD44dB6IhxG4H54z1CNdKYDLX5pRa6Gdi8Rm0ock/EJQTy1xnl51uv+4p11GVX0HAdSAZjjQ7hhoh3jSCg50qqQFWRSUAgvXadnPXZesGMzCD1ZFarvgeFnv4KQj41BwM7u2GSmkK+R8s/1VAov7RokA2wM3cAsZ12nrvRmVscNKp9uId+FPcaUB8WBvFIKRhkr+KkvoSNiVi+1t+N8bTxYz64snmydN66sY+iRLBdSxusUki6dRO2I0ajvtsQ6Oeg+wnhKeciPTEwayMbfkl1NiWl6ZyKrmWL8AnTnsPuv/SX7h6famMRVnsGALZE8dxeE4Fx9Qs7KwMdiAHFWJaeWT7JnbpMs28P7Zd08WaEV2fENOj3F/X2RwCMqf7tVBsOL0U4wnfSska28yKmyHDJT8G06XnOBwd/XXsrI/BjECDZCLy18ytlNHkj5mu53mvtSAuahi06HlXDsRPvaVeu4InBG31sJb5SHo9HqeTnKbZEcFmFV3hbu+/F7DxC1N7sg5sCYEmoWYt/9RK0I84ludxaEzQT4jSI8GBRwKylxXwQAeJUWhU8Avo7OEF/23O4BVDCKQJ1FBBVAz5C1jmjTxq1TzP65R1Fn2A4Lof9E9+QFWWvifQ1dTk2rXFm+TVKhkziNOL2h1YIP8LjquvIdhF+ybYEhU5IPcwM/+gSlV1qpVsfBmjzq1LtCaPZV4yMn+KJu9AfxWDX+SEAGbcy7sLRn1fIGFcCmLQkX9LCg7Y+EhiJUSSzB2Iwq66WZTdRE1OiGy7EESqZJIilfWFVLhrw16fsqTMIp57/VqeoLsMVouED/1de1aJIIjG2KoYs6e7MbKTc/AP87ob+tqCTRsaloxcYS1DUZrtL7U80zl4bn9SAhWajoMPv1buPC8QgOJTP+MtmJ7aRi25bJkUjZq3EPVC48DYu6OEDhgU
 PwK0W8BN
 SbNbkX4xs/k+hg550rWpFsoFIzVBlxylh9YJg9aSXp3Z9Beb3++KCygmqsLpb92Kf7A3XclsdPe9Q+PKfHsFnvZE01yHw8sENJfux8OiU/qYjNJjV8pwEgQmCAyrq7fiA06jOIhgFUrrqo/JNMT1XgnYWX/FEZUMLf96jOVrH7H9Av/ttFHBJfhJ1i0vadLtteftDtr4HO1OV56zX2cVCm8hGA6AIik7T5T+DriZVw6U0QMsPkUzNT594Svu5GRuVwIVh6htQmtPbMbxlFlaz59HXjsEBct47OxX5L0E0ptA2QyNdGjUqV72LqdB3abvSvi+dwKFtNuhypaD87aWbjzzyb4wmUzrA3Rl4hHIQERsvjsWdY2hilY32AolTz5qV7w0D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 20:05, Lorenzo Stoakes (ARM) wrote:
> TL;DR - either we need to find a way to uniquely identify it (keep my approach
> or move it to core mm) or we should drop this patch.
> 
> Given we're late in the cycle + you stringly objective to my approach I think
> maybe best to drop it and respin?

Yes, let's handle that separately.

> 
> Can do a follow up to add unique identification later, somehow.
> 
> The key change of 'make anon-assigned file-backed MAP_PRIVATE mappings not
> special snowflakes' will still be achieved in the other patches (but have to
> rework them a little obviously).
> 
> On Wed, Aug 12, 2026 at 07:15:05PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> We don't assign vm_ops for a MAP_PRIVATE-/dev/zero mapping. So that won't work.
>>>
>>> We could expose zero->f_ops but then it's literally in drivers/char/ and that's
>>> just weird to expose in mm.h or whatever.
>>
>> Thinking out loud: could we use a dummy (empty) vm_ops?
>>
>> We'd place it in mm.h (zero_vm_ops) and just use it in drivers/char/.
> 
> The entire purpose of this patch is to _uniquely identify_ MAP_PRIVATE-mapped
> /dev/zero and only permit this to make a mapping anonymous.
> 
> As per the commit message: 'mm/vma: only permit MAP_PRIVATE /dev/zero to be
> mapped anonymous'
> 
> MAP_PRIVATE-/dev/zero to anon is a historical abberation. This is why it is a
> unique case where semantics don't make sense.
> 
> Doing things by semantics makes sense if the semantics are a _class_ of
> thing. This is not a class of thing it is a one of one.
> 
> Yes the method used is ugly, but the alternatives (I can think of) are:
> 
> 1. (your proposal) allow any in-tree non-module mmap_prepare() driver to map
>    anonymous pages, creating an entirely new semantic for memory mapping.
> 
>    (this is currently something that is possible, unfortunately).
> 
>    To be safe we would have to implement then a series of checks to prevent true
>    insanities, because doing that would permit broken madness like a PFN map
>    being treated as anon.
> 
>    Once this stuff is out there as an API, even in-tree, even non-module, people
>    will abuse it because it'll go through some random tree and we'll have to
>    support it.
> 
>    I mean we may as well just not make a change in this case other than maybe
>    preventing .mmap from being able to do this.

As discussed off-list, we could have in in mm/ and special-case
drivers/char/mem.c to include a mm header like fs/exec.c similarly does.

drivers/char/mem.c really belongs to core-mm.

> 
> 2. My solution - ugly but uniquely identifies the single permitted situation
>    where this behaviour is desired.
> 
> 3. Export something from drivers/char/mem.c to mm - horrific for multiple
>    reasons, violates separation of concerns etc. etc.

Jup.

> 
> 4. Move the driver code just for /dev/zero to mm - I thought a pretty horrible
>    idea, but maybe we could have some mm/ bit and some driver/char bit like
>    hugetlbfs or uffd? But I'm not sure there is a not-ugly way of doing this.
>    MAP_SHARED /dev/zero does shmem stuff so maybe could live there.

Given that I think drivers/char/mem.c really is core-mm material, something
along these lines also make sense.

-- 
Cheers,

David

