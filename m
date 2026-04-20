Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96E4F557EE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514FC6B00D9; Mon, 20 Apr 2026 05:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5746B00DA; Mon, 20 Apr 2026 05:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5766B00DB; Mon, 20 Apr 2026 05:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28F9D6B00D9
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:13:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0E341B8D7D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:13:12 +0000 (UTC)
X-FDA: 84678370224.28.F8ACF9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B1DEC0013
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:13:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=feyZ5DIA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776676391; a=rsa-sha256;
	cv=none;
	b=PAqa4LUhBfyaVojdDCNFJ6fKEju2gPGtWC3tzmkxMvOn3PQBSxZufGNCwULFTSkO528h51
	kYyvWbCqIa/zofjeAAdMzBqD6s2IFSdmKV0srXMMtK1ozT8an+lTchHvUAVUJNxmr9TefF
	FXw8QmFT1YMJxhqaHH6ZjfhPlz1oFIE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=feyZ5DIA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776676391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYOAQNNDu6HBeYV9iM2SPDUV9qINiJNfSyUOqwWaQfI=;
	b=vXB/eeRypcmcSP0tXSxooqByjAfkL1A26R6rWJALhYv51K3ZYm2qYjLnNOSolEklV0UHX/
	oFS0T2dLo9HTp9xJc7uXb+smbKyQupLJkK39Nsf/xgFU1iovFkHR396FMi3KrJ1xdOvrnO
	h3sK7kVIk+Qc2pSb59ErhxDIgFfxsFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4009260055;
	Mon, 20 Apr 2026 09:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B851C19425;
	Mon, 20 Apr 2026 09:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776676390;
	bh=C8qoKlks85F0abyRY4UVHu8S3bje1A5OiFTsLNFCHJ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=feyZ5DIABOXUJTgBnuaMHlVlwg5r8J+Ztvj+k2Sb06ZsTl/QJw8gOB6hCm5yrRX0Z
	 a9sMHw0RVWUIUNjFq9nMZIBURX1O2E1pWmlZoEprS4fXUGldtBcWNRzRnsEsyLvqS4
	 QIutR9xDfiuIGKNS+1jZUAlnXeUSuCRTOqNU5x3l8TT4G4rqoAHScXZUM1mb0E+O99
	 xBcbSZHbHt3yAmgsLrOSL9/a0JIg3r5wsK6AbLtYN2HvhOFeccHEegiFnstHWZckD4
	 Ocs8yYOp1Ab4AvqyXPbOSPJ1d2ZfVA5uIWYdZQ6xWnHK2qhRw5u0AzUT2iJ9ZBmL+C
	 HsvsINsxHuBnA==
Message-ID: <b63f38c6-b073-4baf-9e61-d56b85fcb4c3@kernel.org>
Date: Mon, 20 Apr 2026 11:13:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Content-Language: en-US
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>,
 kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <6ca33173-145b-43aa-8a8a-34985d375246@kernel.org>
 <ad9SVxWIP4FN1c9D@matt-Precision-5490>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ad9SVxWIP4FN1c9D@matt-Precision-5490>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 5c8h96uk9zayro7qpj1aobfia7sz83mr
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B1DEC0013
X-HE-Tag: 1776676390-494484
X-HE-Meta: U2FsdGVkX1+/7egl38URx43NaEn0Pu16M4+yHxJ4RiZEhH/Kd9rbILqjXaP/8s5mS0q4p2cx0wTyLn/qxondqXKe+pXhMhYL71QB8cZXYbuj3sUrIzASd9zeiIvuiRTsIFInvxhasbZXPDnnX7TRoxVjXGJIoqXfomQTS6/ONq2Ht0/NX4y4X1mkB6oP1h0DjyhBrYOK31bRnoAze9Nh8Jkb4esItMJygXmAEagXP26soKA6OAyCH3AmLyh6nOy67Xb43rMLi4WOxYgH7Mw1N/aqpu0tV26vQSzfhCM+1X7zVCqC/DwRTW8l5+HP+axJphG0yQ/P2zaGzt4vbzpsMO2l8Lkh40l7zCJj629DDngGRyxbA/NmXTyh2Vusqutdb0vdvLn0hdToBN2t6B1NVCJliwGfX4TpKJlCJaULm5s6tJki5GERV0YJ3dfdcotOYIgX98+mY4KZkAurglL3V4yxNTbtA2z4DDyG3bgfRgTgonJD2RQEpiVabq9BE1edKtKL0OFYP7P8n3bZFcSVLhM5zjKkKqHIhHXC0K1xHcNraSb7L/kJShxsaUC3VTNWleqdnIJV3BuUV6NWUjMKSL4EKkVTChkPbDNgk+iD+CoWS6MXasnPd5I3HpyxPd+vOuYBKJlEuEVGgil9AELya4nC9m8vtSqheJMsANaAOFDMtK22i+BByocSLX3H0PAcotnhRm4U0VYZg91A0SUneVS3V4KZZiITuQ11xXhfMKV2fzJUMSoDhd2Kr5IIsny8tFCRYBlsxtuWYP4Ggm5S1S9aeZlGBUp5noJfDzuQ01QrES9wS5EKvjXJMGRfBKjUayDmWiRz9SHGglx0yTtD72VOPfu4Pb6bqY5tQquQBtT/gR2iGPV5/X53zojSvFxIJmLUqIS7Ts3dU+UoWw/4l46VZqcBmda/H2QZ1g76Xngc2N7j4QnGKHoG/ZdLEAWuFEuF304egxOIz/gN+2X
 DV3F2N27
 LoGlKY+hEk3mG+Jy/TH2x6VCQ/P4OGPyXt0ciSpxMIQMSADHv90w8Hk0BcFnk7aN+AE0xS8lLkFYaI98JE9S3pHrHAH1peOWaHp5ssN+pitgfNJs9rSo5a9FVYH3kx1Ah/EF3Yh935X2djD/1GNdMsEZCWdgxLQFGLE4YXZaH/gIt97HWQAD+VkE54joML3Z3zgb6ezjVdpVhVJC4Z1aC/5eXEhYZNa3jtAhu7mcyFoy6lx/Qt2RrrOEBNL7tltXZeh26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 11:11, Matt Fleming wrote:
> On Mon, Apr 13, 2026 at 05:38:19PM +0200, Vlastimil Babka (SUSE) wrote:
>> 
>> Hi Matt,
>> 
>> so have you tested it for your usecase with zram and have any observations
>> how it helped, what values did you set etc?
> 
> Hey Vlastimil,
> 
> Yeah I've tested this out. So far, results have been positive -- I see
> system-wide OOM kills when memory is low and direct reclaim occurs, but
> not so many OOM kills that the SRE folks have started screaming at me.

Hmm...

> I've only run with the proposed 1% value so far. I also ran a bunch of
> benchmarks alongside a memory hogging app that peridoically touches
> anoymous memory.
> 
> Workload                     rpp=0              rpp=1               Notes
> ----------------------------------------------------------------------------------------------
> Kernel compile + anon hog    Completed, no OOM  Completed,          Global OOM confirmed from
>                                                 Global OOM fired    __alloc_pages_slowpath

Completed in both cases... but was it faster? Also what got OOM killed, the hog?

> 
> Memcached + anon hog         282k / 2.30M ops/s 562k / 3.53M ops/s  Global OOM killed hog,
>                              No OOM             Global OOM fired    then benchmark ran faster

The improvement is nice. However even in the rpp=0 case there didn't seem to
have been a thrashing so bad the system wouldn't recover.

I think this is minimally an argument against having it enabled by default,
as by default we don't want to cause premature OOMs if the system is still
working (And yes, we do have problems to recognize when it's not working,
and actually doing OOM). But these tradeoffs for killing something to get
better throughput on something else are good for certain kind of
servers/workloads but not as a default.

And once you go that way then you might be better of looking at the PSI
metrics that would be more holistic than this heuristic?

> Pure fio (5 reruns each)     median 3710 MiB/s  median 3702 MiB/s   No reproducible regression
> Mixed fio + anon hog         2747 MiB/s         2915 MiB/s          Global OOM killed
>                                                                     unrelated services
> 
> reclaim_progress_pct=1 seems to help in these memory exhausted
> situations, and doesn't appear to cause a regression for the pure file
> workload case.
> 
> If you have any suggestions for other tests or benchmarks to run I'd be
> happy to do that.
> 
> Thanks,
> Matt


