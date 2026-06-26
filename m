Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BE9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D636B00A8; Fri, 26 Jun 2026 14:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F52F6B00AA; Fri, 26 Jun 2026 14:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A976B00AB; Fri, 26 Jun 2026 14:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 564E06B00A8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:43:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B65D71A054C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:43:34 +0000 (UTC)
X-FDA: 84922937148.16.5EA10B1
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A050C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:43:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JcXe40sE;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782499412;
	b=JkwmewUU44LQNvgHMZ0AI3lcnjk4BSwbSaQmGXVJxw5olKS6S/MXeMG769Wg5xEodQe84n
	abQyKUb63JUTzowlGwLAJAaM8d6iwFa7Z4R9krNth6Lxw1ZnMKLBmAoOEbKyG1aS0noh0g
	qi9iMHaU5Sfc6gsfxQh2qekx6K5VDRo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782499412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIb2IG4OsYtmUwXVg/x7Qwra2DOFpR91A8rDyQolB1I=;
	b=XiNlz63w/3BKrU5/mD2d/szPLNDzhhsjN3405vWSSoUG+jROskQ+G7Ye2IWlYTGpeqsOCf
	KNeNl19FBGD0yyGvVxjwH/kbWG5XrlT3uCgCbhtbHT0VFjIrGLM5bKroPK3bh8hZsyCOT8
	bM4R9UndF4H9f17pYFnWvYd/hkACG9Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=JcXe40sE;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-519f6a10d9bso6862711cf.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782499411; x=1783104211; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FIb2IG4OsYtmUwXVg/x7Qwra2DOFpR91A8rDyQolB1I=;
        b=JcXe40sECyuUMjqdm6NbZy5Xya4H9FW1vtHUKwbLAHUc04qkNF+PPaGJymbf9aM8na
         ErP9zfwHlsFBCn9f8X0zRgDadOY9ogO+trNB9IlWmpfHhfLi/W5jBMlcM7f3S/CYxZoC
         iKH2dVyWTK/kmE1ipSzJiYNLhKn5+0m0TSJr5D822KlNb48Ia68nh2HGkHZ3Spfi4Jyw
         ECWxCAgrnyT4uJJJQeWMv6lmaiZCoKD8INNIoM+tRHDl09cDv9/tC2erQkva8chEji4I
         um6A8Y9czoCwbeZUQTaDe+xU9qhSuihXbTC4iZYztDwqMJYBJApMxIMrVdSz4BrGoq57
         KOAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782499411; x=1783104211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIb2IG4OsYtmUwXVg/x7Qwra2DOFpR91A8rDyQolB1I=;
        b=ZQPrwTe1e14zDWOEwFWVLFW9AJiLY6iN/rLp0PkaICiwo821Gg9SlztzG+jbQcCO11
         IKmZxF6ZfFkqgjFL3Bs3AtIyTagUGwmI2S0nLMwwvVRkLBL5AscotQgjxQfPZjSTHhMT
         Hq2i7BZZRnkr7JOS9nMyf3l5d11pQwcdISVwIg4EvKvAmp0ZTzoeGtI9fOCGzR04lnKH
         Q0EWHmGvevbl1fiM7OuRVZcpJGmUbxGMr3UcATKInF1FmdVrWehvSGPJvMN9Xel7gYe7
         BpciPehUgsvAkIrjcrj/q7C1QtK5X2sKs5EH/smfSXU+hgGDz3GXc4rkt9WySKPvKhie
         XHcA==
X-Forwarded-Encrypted: i=1; AFNElJ8ALfE67zixRvuoFid6aAWHZvN8qQvEUnQoh5GDnniKlbIhdkACNu146Xvld1XzYUlJCWIAuY+CvA==@kvack.org
X-Gm-Message-State: AOJu0YwdHrpsIX6jb36rz+9Iob7MX8UKJLajda+47T1ofh/FdyYLRCxF
	RsYvblCInpb49JVNH7Ba9pguo4rI+cB0up+GPU5KNY9G0I3VHx+EzWIjRGWzysGJwaQ=
X-Gm-Gg: AfdE7clL6XOZsF3y8WO7UyV3wR8ABbLJWjuUzbOB1Uv8bFSOUTd53LwG5RvfXVplTvD
	w+nCZX9ITF8dt4ODA4AWQHePFiNVsqeFyuk/zAwftwrPtUx97whtBkWnBo8JrYrZxl4IINdPYvF
	IRCXs9RpuY2oza2HX1hEmFmVRePAQn4000ZiyCvDZ3eCf+1a8R6A+aKxggOlOy+36Z7o44ampmG
	9+cac76m1bhIp0HhbjZhX9/mJsLcbFiWGE5cmPm665kpoM0l2uIkUkPcwVcfv1skg3K9wpROWvC
	AZ27VBg5jxlJ6uwYMaCA6ZH6wFJ69jEZ8BzmaZ1PpPBg1ztbMXlyEEaKSYskLUVfsDeBTh80wiA
	VT2iDSGnzRhscFZkQRWo3QV2Ffh29lnMAWy20kvfhOiLG6J26zswKHqPj8AZXufTcSEqg1HsuYk
	5KD3HPdab0AWc=
X-Received: by 2002:a05:622a:4291:b0:517:6435:c4ce with SMTP id d75a77b69052e-51a72822e58mr113839771cf.49.1782499411509;
        Fri, 26 Jun 2026 11:43:31 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f6fc013sm219113666d6.18.2026.06.26.11.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:43:30 -0700 (PDT)
Date: Fri, 26 Jun 2026 14:43:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-ID: <aj7IUVdXgqDG6w34@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-5-hannes@cmpxchg.org>
 <DJJ707PKYUZS.3VQ58AKYG0XNP@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJJ707PKYUZS.3VQ58AKYG0XNP@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: 8mgrrsmxp39oaqwh4s6de8hp6g79h7ab
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A050C0009
X-HE-Tag: 1782499412-659519
X-HE-Meta: U2FsdGVkX19Pf162uBvVPsq15vLzc6GhCMYdb81haS8fL8Jx3TWCuljzgSVowZkLCFGQEi9Vi1LEkcP/CjI4YxJsEmyLm4RnCW1ifUmnX8A4fXq0tIpu9ohukWb7UhzzeG2IvgXfsKjKbvqYKXe9r6Qc8NOqq+JTmm/xrHj4ML/2seUPDEXAFmLdOEXfU20PXJg4Y8W2MLSnFXXabiU7EcO7PElMCgODZYijbEciphKciatNWDX8mbo1MfDTSAUTkOgw8vMlfsHJRL0xnatCXvLmxb+ON4KknSUAr0I85Uxdp3MtkJ/4MCrqLS/7Gm0UDBLa7GI3bK+u9crLsdNtUii/XBYEQhQ2cl2CzDbY6hGUDAHvjLKC+P5tmWc4IlGxIHS99ovIkQUPe2ABPpLVH6FHhRm4DF/bAx5+DZMDxAM7jVPIixa4dMidmhXIGU/gnzhzoDZKJCthiVxtvTn9yMZJY/eLkDDqXHLb0e571VXZSBaF1Fe1mR5QDIdeaKNh37tkiY6Lmr1p6aG3VU5koI4a7pGGjjL7JLgrKRDE40RvsqsjZ/5CT5pF6Z8ulRsUa3B/Iu5v1IXCzQxYgSYSKnkOijfHU6WcrEcv1ITZC8DQFW+MMB6cpKDd1vV/tV6SX3+ixRV9VN2XHSB0jvyb1uiwhMJnYVPCGGNZqq3eBLg8b08W+dWpuzf/UBLOoLN6JEZrbR9Zboc9lkdAQgUfmfrDbcxrkaJxmoxujj1lKnaljaL+O4egKY8ibgmfpkJUK1EUKdqgLbw3bw07oyfeV1sSDkHrtteQGhiu1J6rBWztuwdUF/lR8dk7vOzEL3I8/rAUeB9BrsZmfLxlUZbPtRXHVHb8Kx0Zy2TMkop3zqKPXeE/JaTQRq39/9qrf9D9U6mUax2LSO56COvhVSJ0iE21Cbso41UaO2AviyH63VTvpZqb5xAHoDb0PWLkQlxOdQq9VOI+YUl5nrS8DTx
 ZLEELkyv
 x3oML1pbmmiJNJfQyPpH9YdNVgFsKCCQ6d7PSRfQ199VexR02sdRMvJXNzRVLkTpvFNEbC6CW2aWIlqg0z0ypbnE2shn8TSuA6R2yTBos5cHh9t3VLrOIsBM3iaHxWy4VR8MjCx7e/0MnM9l1+Jb1o8D6Z8wupJ8yAJkpJhVlnn9CpIWa68hGpullWMZxDRr/TUcs0rcjgcogojeFjMGSDbJKAoCwR2QMmO/bSbEKaOefl7TebWY1pF6QUhk/jUSjudnsXfefcQzam1BYlvVNf2G8gQl9J9neELmMCCRqQTbMmUc34k+94sSnLXVc42psuvr49ZNhZAd7sLYrRMLy1w3jxEcMyhHqN2wwYnJLG3OKlt/a3B5+uPib6CDFVcg3xcapYHqSFATtM9oUY3+v3bgDxu/ao+Jvpdfoc4eFzTc03BnPqyw5IVhH+frONZTJrmj1JX35Caoj/cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 02:29:24PM -0400, Zi Yan wrote:
> On Fri Jun 26, 2026 at 2:21 PM EDT, Johannes Weiner wrote:
> > As we deployed defrag_mode into Meta production, pressure spikes and
> > excessive swapping were observed on some workloads. Tracing confirmed
> > that this is unmovable/reclaimable requests spinning in the allocator
> > and direct reclaim, causing excessive amounts of swap.
> >
> > The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> > produce blocks, and if those are overwhelmed under high pressure, let
> > the allocator fall back (__rmqueue_steal()) after its retry loops.
> > However, that retrying results in more reclaim on some of these
> > workloads than we'd hoped, sometimes excessively so, spurred on by the
> > !costly order conditions in should_reclaim_retry().
> >
> > The storms are dependent on the request type. Reclaim will inevitably
> > make room in existing movable blocks, since that's where the LRU pages
> > live. So if movable requests retry on reclaim, they make progress.
> >
> > When non-movable requests spin in reclaim that isn't productive. They
> > cannot use the individually freed pages, and the process is unlikely
> > to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> > They spin and overreclaim excessively, which tanks performance and
> > triggers userspace guards like swap exhaustion or pressure based OOM.
> >
> > To fix this, send non-movable requests, regardless of order, into
> > pageblock reclaim/compaction. This way, they help move things along to
> > meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> > and excess OOM rates are no longer observed in production.
> >
> > The longer-term plan is still to have all requests, including the
> > movable ones, help make blocks to spread the cost of defragmenting
> > more evenly and fairly; combined with proper watermarking to reduce
> > allocation latencies in the common case. However, doing this naively
> > unearths scaling and concurrency limitations in compaction that need
> > to be addressed first. Promoting just non-movables for now is the
> > minimally viable bug fix for the above issue.
> >
> > Fixes: f38356df6474 ("mm: page_alloc: introduce defrag_mode")
> 
> Should be
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode").
> Since I cannot find f38356df6474 in the tree.

Oops, indeed. I managed to pull that commit from the old development
branch I still had locally.

