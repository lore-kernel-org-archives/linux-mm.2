Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2C94CD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173E16B0096; Sun, 24 May 2026 22:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B356B0098; Sun, 24 May 2026 22:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0610C6B0099; Sun, 24 May 2026 22:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9E296B0096
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:19:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EC0C140DBF
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:19:20 +0000 (UTC)
X-FDA: 84804335280.19.1F6036F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id BFB1480003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:19:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qkuWcEpo;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779675558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukB3uISQ810v40qB5GIvSZXVjcssnMcVF1JeENXejIQ=;
	b=oWLr1TgsO5N9mXdPxDTpIsL4fdjii00wg9xO9KykC7iLZ6O9O4lwouin69uviiZxRFuGdg
	S141tTI33iFYMFgpiYJmn2wN1WiWRAXQUJ79+iDudRBIGfb1sUemfCubkL0ahzuIHGQqtn
	wpi3Ludh67gKorAVp+hTqrscaxUFXOs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qkuWcEpo;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779675558; a=rsa-sha256;
	cv=none;
	b=unlEwfdAJMkYffg4RxebvMiiP1U/9VMt0JDKaz93S8gmKfv9FDANnlnMAFfBUsx3rBQ9Im
	voO/dqZszfI5P6+ESJgzfUaTo4wXOyeuxZaMXAkjVQl/vFyMgtOidFH4GmXJQculmPBvBW
	8E2xmAPPci41MdZ+38e2LuG77oNLZ+A=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so185ad.0
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779675557; x=1780280357; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ukB3uISQ810v40qB5GIvSZXVjcssnMcVF1JeENXejIQ=;
        b=qkuWcEpoiUE6wCc/vZUmjzFN4iRUkji9ECp3U9tvT+u+Z9pKKUMhyfU231YvsmFR92
         Cp96x8u/ghLVTbBj3XiKQt9uYhdCiEiw8zjOKo8oFvmcKSrK+PNqyqB/pjjCTYnl+lDc
         tQzAF1SS5PsNRK91c5gW4opPdvJdd4du35HLp//dKQIl3TTftfsEt40Sd02yD/Trzf5s
         OKhQBC42S5QlzC723DwjnJD8NA+w8E/eO8pEnhZjOXODnG6Bw7UjDerzfJOygRQnNEkZ
         EfNBbFf5GsEzI66ZKCD2PITPvu0z5pTtmm4Q3w9KdGq7g2V+Bohx357OnDl2ir/HITEL
         NiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779675557; x=1780280357;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ukB3uISQ810v40qB5GIvSZXVjcssnMcVF1JeENXejIQ=;
        b=qpdid+jOG82wZDD6Yn2USoH5OP3CH1Sy+JXl/rHM8ttQ13GyMwBsmutywlIGHN2Kt6
         E21TDIqHCva0nVSdovhDGowqa/xurzYwgc8fWO6SrQkfctnOCMAaKt+t3aGxm7O1cWzw
         iufW+mljD7n4JgDNtWhkMMhPL9oixboiDuUa92NC2mEjpknoMs/iB1jLaWCv3dGpPc6P
         JumlwkcmPqE2M41M4PWuOVzqKPdabn719aIX3hGSCbOroJZZhM5mJZDys6Zm+N2lBmdD
         vFdLbT7niYCG/tRIQMeCUoR+zNneE1UXMwqbNOIXuHI236AwNOCqzF9q4vVn9LX4+o5R
         LZmw==
X-Forwarded-Encrypted: i=1; AFNElJ8+SxFSDSKbe9Lna3uuJqd8MK5nafCP4xPDHBLmaO5hV+D+RZgC9u9ZKZ8oN1439hZEGF1zjGvjjw==@kvack.org
X-Gm-Message-State: AOJu0Ywxbd55/qbmzIvdJwOQksR4YbwfE3Kt3bDVnIqP8kk8XogME3P9
	kxCHhOOs6c7UL7Tv9PO8BCzy36tLRmQPcXtHv5aMz7yZA/DhdnvIbfNSoxBo8oMl8g==
X-Gm-Gg: Acq92OESPIi//vExnJXdFjIm0H50VZY7lMZ382Jx0JECx6hEQmy65IdXU/Z+3PBDz8s
	eB8EGrfwdb3mIhVfAmiYWnc7mlRhQABMCPRQx6NZl1XVgHiooNOmmODts6zRDtzU3S/vrBxbRln
	1aa2+JHPucOEbQoluMVw6s4/EXGPYGvAnAJb/OB7K83oR+tQgSuTRdpdddncYM3B8sQcuVn1iCR
	q7BCGlOt3YJvdBqxkbYJ7ZDPbkuMa1rrZVfuaJ2SmekqBmgjzYqrKLRlXLFORnyAyvfHh6/WAhn
	bFcnvVaDBcwfwOnPBGZSVy0HxAvISzCJqmOAd0w9Wkm4EAEb4H1+PTnL1FGXXpBZRrKxj/fzck5
	dNd97iKDoFyaDjjkIiMp1hdUrY+ngT7Y9CUXeWonhMKRoVho09hZnPSi1/x4DthcSiOU7aIUk+0
	5cuG1sxQMSp2h3WOSeV8VCH8xGNw0iHXmF74nxNzLteCyW5k4jVDeXJvGPWP4wzB2AUGFYb2LXL
	GB668ObNrpMFfn8jjD3iHrXeNrEv/PMJ5MO/o/7RAs5kQyfpNTJNLRrQ1X3htsV3A2mZXmY5SM=
X-Received: by 2002:a17:903:37c5:b0:2bd:6dad:3dfd with SMTP id d9443c01a7336-2bec11df2e2mr2126205ad.27.1779675556850;
        Sun, 24 May 2026 19:19:16 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:6235:ad35:aed6:8a48] ([2a00:79e0:2eb0:8:6235:ad35:aed6:8a48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56bc46esm83987925ad.25.2026.05.24.19.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:19:16 -0700 (PDT)
Date: Sun, 24 May 2026 19:19:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Garg, Shivank" <shivankg@amd.com>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, kinseyho@google.com, 
    weixugc@google.com, ljs@kernel.org, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, vbabka@kernel.org, 
    Matthew Wilcox <willy@infradead.org>, rppt@kernel.org, surenb@google.com, 
    mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
    joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
    gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
    Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>, 
    rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org, 
    xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com, 
    hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com, 
    riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com, 
    tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org, 
    aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com, 
    djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <f35bc7f9-c75f-e6d1-df3a-d536047e9461@google.com>
Message-ID: <468db563-73b0-3f77-cf42-bb24f744c7d1@google.com>
References: <20260428155043.39251-2-shivankg@amd.com> <20260428155043.39251-12-shivankg@amd.com> <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org> <70ee3800-0469-4c3d-8a1c-bb6594c64f42@amd.com> <f35bc7f9-c75f-e6d1-df3a-d536047e9461@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 65e5sfc16a3crj6rz9kezy3mfi8zwzwq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFB1480003
X-HE-Tag: 1779675558-294711
X-HE-Meta: U2FsdGVkX19wGc5ttGn6cghDkX3kJTOHRHzCJcF5o9cYOJ+PaKMj92muY24U2c1L1xSogMY4kjK6jpQqQRhCrKwVDcG5LBT82BvjwCGYu3FsDULXjMspk55ZTGIyC82lkaXgazmYyaXEpHo57LACn1xhvsDJro8/dz7Kh9/+fZegTl+k6jgRQrt1CPOiEbaeMrXBDoncqMl6ULbLAwT/24vdQmIa0XMsTEW1BpN7PFDWhJLxzS/Gw7it3eQGaSd7+q3bHXHER4IfsfSPbn99rx72XSkT2Ung9OjLhla2spFz4s2se+odAjuYsLuWoPsK61GqiejSit7yjyLwMAQZKNe5yihX+BBg+mG8WUxjGsVyJedh1N6wiaq7k2rVNyY9uFi5lGDJER0kLaq7otgYvbYRE5q1APvvf7yTnkmktEWW0OEehCBRc/uq5/7CknSYNzLvqoRmlG4KbEyVHKeIz3aZwf1C/EznsT1MehBb3reIjuy7iR+p/1+ymjapA6y+8mL9Glw2wxf47TxKkN5lyvTr62WlmCMRujg8qNTIcXEzJ4j3Bg9X40oJWsSSNRJmggg7PGsk5zN8yurjzpDfW1MYmpTjTwWyjE9FpP0KQ1o6SAvwr/zpFi9WPXGlsGiELJM9Tk7U+5otQ9SUzFbMqvQF0gZKPXFIWLWM/FTMNtYeYtgVVqPegwTe8TtUN1CJOWc+I4YUM4OpzdllZnkD2xImgBwSNv/nCbbzNvub5oLtE5ADQFFOfK7wprBv18LpdVvQnGHe/Gw+OAdpQ/4Ragv7xU3O8dCl3sFaTfQaVT+7Gvc9JOkYqDzzyrgNhIWySdaurcdHk4SLW4NVlDJ7+28u7KJBKBDUtkMHWJ7URyEpjcZnOpW1MeCXEK3ur6Za5crJENcHCfNHfWMHcOk02kL6oyaNF6UVaQvp813ebWZMwMVHSJOy59MmS0DeI8Cncikya7l7PWpEgFYcgtg
 yxU18uCW
 Wq/o7g1YMy8F8ZobzfUNsOKWa8aWUFZWpM305ahZfqiaD0UhX0TN56az3/Xj216r+ns0OPUpl+66K8bNAijsNUJW7prERV+3RQ+pIN4EhPsGmfkPJU22FdfMKAe42aIR9zG8GOEgIkRSMs1WJCu7fy7gwJ9vXEVd2r6OqrfNXoJU7CL/1O5y+o5M+P0gk2psPbWKYAsXndaj1MGeanadZs3IZNwipz0eOzQIORu4dRoY676juS5sr3LC+O4N7xZHnAM+o4/4zc5jH/dn7Hb/f2ne04/RDrJvXk0iDWh2y5yhVN3jBQvYLnLNd2csmZqXiDW0MqBy4GdqcvHsmWlacYYpTPGNfIruqkF6aZR5Oy+fh0s4bFLtZv8XzdnHET5USyZ3zYGN0xuxi8b4YvoJLS5yDTYrqSVjAfjklwyx/MhZfodN3VBR3W0GcwZZUtAt25EAi65rnrBsnOfWr3X3PCN5wqhteSpvQv2SPJtRUk9sRcJ9Q60JPSlxsi9JyB6viLL7zGvTMTGhVf7KNW1czWrKhpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Received a bounce for Jonathan, so adding in his other email address.


On Sun, 24 May 2026, David Rientjes wrote:

> On Wed, 20 May 2026, Garg, Shivank wrote:
> 
> > >> +static bool migrate_offload_do_batch(int reason)
> > >> +{
> > >> +	if (!static_branch_unlikely(&migrate_offload_enabled))
> > >> +		return false;
> > >> +
> > >> +	switch (reason) {
> > >> +	case MR_COMPACTION:
> > >> +	case MR_SYSCALL:
> > >> +	case MR_DEMOTION:
> > >> +	case MR_NUMA_MISPLACED:
> > >> +		return true;
> > >> +	default:
> > >> +		return false;
> > > 
> > > 
> > > What's the exact reason we don't do this for hotunplug etc? IOW, why do we make
> > > this depend on a reason?
> > 
> > Reason-based filtering could be a requirement for some users who want only specific
> > use cases to go through DMA offload.
> > 
> 
> +1, I think this makes a lot of sense; not all DMA offloads are created 
> equally and we may prefer to unburden them from being contended by 
> migrations that they are not intending to accelerate.
> 
> > For the RFC, I introduced a placeholder to enable further discussion on which use cases
> > should allow migration offload and whether offload users actually need this control?
> > 
> > Your other point also makes sense: "If someone migrates a handful of folios, latency is
> > likely more important (and batching less beneficial)."
> > Based on this, we could either fully rely on batch size. I'll think more about this.
> > 
> 
> There are, or will be, some offloads that must be used for certain types 
> of page migrations, like Confidential Computing.  That's for functional 
> reasons, not a heuristic.
> 
> We want to use certain hardware assists solely for promotion and demotion 
> of memory for tiering.  We certainly wouldn't want those hardware assists 
> to be inundated by users doing tons of move_pages(2) on their own or by 
> best effort memory compaction in the kernel.
> 
> I think the use cases should be configurable by the user if at all 
> possible so we can control what has access to being offloaded.  These are 
> often shared system resources and can be contended like any other 
> resource, so configuring which migrations can use them vs not use them 
> seems important.
> 

