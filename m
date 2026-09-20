Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78A4C982D7
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 01:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FC46B0088; Sat, 19 Sep 2026 21:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1076B008A; Sat, 19 Sep 2026 21:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF6E6B008C; Sat, 19 Sep 2026 21:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34F686B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:53:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7FFE4035B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:53:15 +0000 (UTC)
X-FDA: 85232467950.11.9D04603
Received: from mail-qv2-f27.google.com (mail-qv2-f27.google.com [74.125.230.155])
	by imf08.hostedemail.com (Postfix) with ESMTP id F2ADD160004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:53:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P59YBj4y;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.155 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789869194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IyWi76YFd5k6sT6Wel/JshxFvWpuBbjBUhku/DcG8Y=;
	b=N67k0QvTilUzWZ0T+6IIFfKV+wUUDXbnln7U8Ed/LDP3POPFiZwCpAXn/9TJwTzprCmjxm
	Roz6xjKIZWzMJNmdA/oaabDZ8yoXAzzYFwl5pf5Ab6TdHi8feZVHCwHYnHkX+fPydESMml
	buu6VRL8byQJImiST/t5tLnsekTYwlo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P59YBj4y;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.155 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789869194;
	b=OOzbKiOylWO9luNG3aEL1+yVIOwPO1ZH8JnZ4hw7VtPaxS/On1tPogO2YvkbyafCY6Q1sR
	8aCpk5SQlRBRcvVv2PnB85EwHb0Y/fefREzQgzF2A+pWfXLS9MoO04N0nK3Hd88R3eBaJq
	Iwn07v8bXLo7xooR2d1BZtBr8mYTMRU=
Received: by mail-qv2-f27.google.com with SMTP id 6a1803df08f44-9104649a5dcso17653466d6.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 18:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789869193; x=1790473993; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3IyWi76YFd5k6sT6Wel/JshxFvWpuBbjBUhku/DcG8Y=;
        b=P59YBj4yZpBaQ24vhoHUm3XKOfCDoQsOGIfSKLxM6eta26vLDLiz0ZJumzMfkvhXtp
         //0/xRpy++vJyBGVKJGPX6TQoZKq/p4QKTgtnkwtylrzu2lM/6cLT8N2f1z07pvEC2Jt
         ZeJz6hv+lfGKM9YXFrLdGGq509Wd/dzcQZNxJTde9LgHnr4146ZLu/MVQS7TRWNdayc1
         WRF+lnvv9P9+Ee9vWdHaV8atxy1wV9UQ2B7sEQ1BTOiyRrOFNcv8hKt7gK/yQ2WltjRC
         n46nb1wZnP0B5PmVXCDX1r/fCUKUI88DY+2vpdhtSc0eYANEHxyoOVKgAzoEV4/UqRhW
         6IHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789869193; x=1790473993;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3IyWi76YFd5k6sT6Wel/JshxFvWpuBbjBUhku/DcG8Y=;
        b=H+E9/NBEP9RwT5uUreLhS4d+Mz+3U4Ezc4i04+KNWFDRb2qh+01zWhtMoSRmL+h6o5
         LoiP2zTNi9EbuP4nlHAaHm15DuLuoe1yYZqlZCqTdG5s+q/bUTj2/2WQCL3c8RhTnkUS
         etxtqUvAT6OtYDOOOHU8d1gZtUiPLBuL7uMVJwbBT0ksUbWMJovkYyToRm6Ot0QgJxhv
         4eQVYtMEY+Ewo0rQXZ10ta/i2392UlkvLPIAfkUrmwfefbKI1afzAQiYOpVkZX9fP4UX
         Dwiz+U2J77zTV2FE0uzNRDWhLIjGDPbp7j5qIBsOtqYywivUbuePo0WJ/doWhyQYAjsq
         dlaQ==
X-Forwarded-Encrypted: i=1; AKwUvByJ0mRLNYak/zYmcya1Ck3YkdvPXIG0qWixkck3hPvdHUsTrWAUHYaY5Iu08noTTBhlJ1bkxJcxyA==@kvack.org
X-Gm-Message-State: AFuF++nGM+6EBol9XiVXXIIvfCXb7znmj/6gNxpK2gIEfo9n0GjqdbDm
	YZdnnx7Z/egmboN/VDXzal6RjXntwNLZtpxCOPqMkdCp536hkS7/gWu2vk6H6N5SoyY=
X-Gm-Gg: AYBFou2wzZNDglEw57BjE5YqCq09dCeUN+2lbWh/tXQ5QCf+nlstxdbE2y6xXeMAZVc
	MHpCgzu1oslv1O+LiHlGLzpD37hieQXEYUCr5MlrXMQARk3VXoAGE169uau9VBTtN5ViT6N/iFP
	fAMJuxO9C+a+UgX0tO/nggLjaB4h21flhoAvTOX7y04z7bMFJ9pj9YSIwDvBovyCebg00j5XyWH
	NNsG/bzUdPfUUwNhn1xtHoe3UQ8tkJbTS6+XgQQz4kwXIutMAEcFpiOI+y2AOFPhzvggWjAdUe/
	M6L7QmMV35bX6WWiO6xPQk+2yBGcMmxVXIkCCCQxrmRGKd7ICioLdDORXqTWU1JlbysUbDW9LgS
	abBOdc42Nn7dH1qB/pEUzCvVowM8CNQAm2PW6j7RMw1PaqXMv/QiLxrXA2BqaHVbHkURyDvSt7o
	Y/rc6t7z8tn5zq1vEPOsLjWee3M4mQ9u8mb6X8G8tt6O5i1W1QFvMOsaCUZwAEbVV5x/Jmc5/SU
	xB6vot5GTqhm2zWhyd/3qkfx4WWOku4qV13XVrirCxf7InD5q/duq8=
X-Received: by 2002:ad4:5948:0:b0:910:4da6:8354 with SMTP id 6a1803df08f44-9129c780d08mr44342896d6.17.1789869193050;
        Sat, 19 Sep 2026 18:53:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260a9a305sm32833856d6.37.2026.09.19.18.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 18:53:12 -0700 (PDT)
Date: Sat, 19 Sep 2026 21:53:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Rik van Riel <riel@surriel.com>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2ADD160004
X-Stat-Signature: tap5d7hbida53kmrgqysizshq87311rj
X-Rspam-User: 
X-HE-Tag: 1789869193-295815
X-HE-Meta: U2FsdGVkX1+89m7Dzw6RuMzLpqxVjEc6odMnghkwhhDAo8Lu5QU84oliNPo9ohhrTHn/scGtamS6y81/Z/kEStGk/dIdmT57I8tDigv7+54tTAlZZ8jI9LVvx/gdrCDSGqyfX8p3yPBEjrL6hmHbHm1gNt1nkmXhRulTfnRN0zzzJsMpxqbadMlXQP5JtC8pxBa/rUAU4EYA2tmVzhz4IutVi4rTHNJFUGXSs51zigfw9eeHeeXrcUDE9BqMfD5zQPCQ3wY8cLp5bkq134FHo5zJB4hLHX3e9d1r65wcwIOu3clNv5ld+1oYEyv7u6sjFIXKh4gthuWQZJAvXP8bXz/94ufzRYPBBznpY7dsJUgR2pMPiRReG1rC5Us7OuWijwrg3ytnh/lg2N2TSnEZIo532wxcYFuDF16hS4NZ+8iJ8yctbVFAwyMDFQX8PeEqIuzMzVNp2nTxj5tpBG8ASWhdaz1jV2Ud12tjI1ITBHeQTnMfs19Jr5vg48b3uHraNzvx+vFSaInKwXPbQAaiU2+36FUYfswgXj4WaemLIPoRkwt2u8q9XEuLAYXBA6ofFpfncz40LwsifFo7rRdF7MrRD+eNbX1ttX+9+PopomycUxpNJ0Vlc+++QjOBloKrOHJcS2CXdMJBibJv0UkBpO3nxg6LRfaOpTFc5L69RjGctG4zZv6BpLTU0AZp4s6knG+e1kh/gupQ+QZRb6jJ7jrij3o+BixXqxw730GbssZ7IQsN+N+Q9Hb0HBOLiVkC4m/JqlaOWQhH2TyERbI9RCE0bBXnQU4fhOFADzFAuQG6cQgdqjz0/TyQ+XghnvOSduXdo6AuoknmHlPz7XTiMDzBIXcOoaRWG5Kr287SNsne2++kZJ7rjxUnxFUW/WOUODdldR4o1T93WDap9ohOO80E8wVOgek9xQs/M6rRvt96mndfFXizW4dcy+f0xigmF8F8CuODSXzlz5cW0sn
 xkC/wXpo
 4bVCM1gqzLPfT484MycWThdvNFmZhQZdW1CznRNUaHyayIrYDzajbZbdiK7ecV3tWws6ptqsaVvElqUygz9RCKJKapZ8b7hCeqCX8oI3S10vBKcaCvHxq+6jo0M6xYRKqU6UJI0tO3UoZ40JbjC/s/q7lTg1ZAyLV91odlhoBOipYiXRtPBKLpd3DThRAkASTbCjFa+IkRqWMIqAeiZTFZ2kOBox1ijbDDgbUUv5HvhGc8Y1fbdi2kOdJCvHALSQQAaT1HMc4mlN3HHHCFFmXQlEwYu8wdOY2VI0YgQazR730GRGeRf7GGmfBAnvDwywj47PtYq6LVG4zwOFpebTdCE8dPR0pc5p1niF6gkJ8gSSx2xjLm9BNwZTtVhsoy7O+qx8vYBA2YH/55++R9W9owqitSOuAOwmgcXZZrBNDQL3EeIiPIx01e1G7meUn9bMjepR+FgT8hbNwOqvIjLiPDWVdOjKUJLgWeoqm5axryLg9nQLLEPbthWAQ5GS8/PnMRoK6tEL4RFFDPDJQ6BCEjGULVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 09:02:28AM -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 6:08 AM Gregory Price <gourry@gourry.net> wrote:
> >
> >                         Memory Post-Compression
> >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> >    ^----------------------------^
> >          Compression Space
> 
> Thanks for the explanation. So the compression space is just the
> actual data store backing the zswap/xswap/zram.

No.  That is not what I said.

I said 

   It's the *amount* of memory consumed by compressed data,
         including the metadata associated with it.

I do not know how to be clearer than this. It is an amount of memory.

It is not the memory itself or an abstraction to describe how much
memory, it is literally the active amount of consumption - a number.

> Maybe we need a separate counter to track actual memory usage,
> regardless of compression status.

the separate counter is... the existing memory and zswap counters.

> I want to add support for your usage case as well. Please clearly
> specify what user usage you want, what the expected outcome
> is, and why you want that.
> 

I want:

  1) zswap on machines with no swapfile

  2) without being asked "how big?" - there is no number I can give
     that stays correct, and

  3) the bound should be the memory limit that already exists,
     not a number guessed at boot that hotplug invalidates or
     guessed at swapon time that different workloads invalidate.

This requires decoupling swap *file* accounting from zswap accounting.

~Gregory

