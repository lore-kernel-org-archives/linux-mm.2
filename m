Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD25EF9002
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1C56B0088; Wed,  4 Mar 2026 11:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6346B0089; Wed,  4 Mar 2026 11:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98AE6B008C; Wed,  4 Mar 2026 11:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 997026B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:26:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 657D21C8AB
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:26:57 +0000 (UTC)
X-FDA: 84508909674.14.D23BC6D
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E5EFC0010
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:26:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DsmctgQm;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772641615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Hg+2cx4ctUEYaUblGwODgDafYhXfvGplcz0+hFdRQQ=;
	b=zZBzDV0MujjR6a9sPg9hS1dFyulf5uiwadBcjmA6fat/JNEGHVEDTHogxGaWhnSN5/OImG
	ESHEdwS/siBzv24mFVlYMqOZhXHR6FLQ812nfqcyCmfyAIaI77otMgInMmLgSLx72rHk7U
	Uj8tJehCb65b/NfFNJDggp4rYN7bU9g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DsmctgQm;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772641615; a=rsa-sha256;
	cv=none;
	b=50fRUI6UbeAIO8HnkfKpLSslhQ5Y/FD6SbU6FZzAWsTzPy3R7Bj6Yh5xWdJwl8Ka1iXpXH
	5lYPP1OyoEM36JoKG5XeZ8Q93suSRJJ7aRUvnxnRZoS5WZ/yAUQeIueZEmwsDWaw/6QeUv
	7wDh+251U1W2K0mu1WdFx6lKx792378=
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45f015a3259so2884626b6e.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 08:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772641614; x=1773246414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Hg+2cx4ctUEYaUblGwODgDafYhXfvGplcz0+hFdRQQ=;
        b=DsmctgQmjBI2uSDJIErvRQ/wVfRyYtOIrdtkLyXRksHKWtKpqM8zs+lh7hAQdQ4U1G
         tTPCJXGsyZ7VGEZUMYWJeZPi+2gF8sH9xxcmDGjd4lGVdLlpJGYaPXIYqI0YiL3oae4T
         IsSIgfARghHb8NOZ0DiYsO7xY+ARyiTfBL8nc3rFfgcBhDp5mP9wk2H/SZ+UCKog/jP6
         V4327kXMMi1s4lHduJlVuqT5nZ1lCL6qUNJORujBcgz2MZGHWdhed6+aQ/qMqsv2rroj
         XNojCpj6kX17QJS1AK5ITE4isBeGmRDawEFH98NIuN46gW3L7rx0lu1K9X9LzLfb2DkT
         HBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772641614; x=1773246414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Hg+2cx4ctUEYaUblGwODgDafYhXfvGplcz0+hFdRQQ=;
        b=jSPDU6S6//kI5O0r71VdWTXCxkp/ZqNkScGTlCL2OmyblO/Vc9JJrtU9tF/mkhBXmI
         0lpvsEn2usZvKIkfcfZ2kIgcgBZuFkPfHTdbQ3ac8eWD4cbgZ3RinfyJ/mNX0K9SbHwu
         xElUCTILs6K01nYxg4Q2d/6pRd3M+jyux0sYmfk4wWCr+j56D6j1HqZ0oHUiKREW5Lro
         HZRyTnfyinyyJL6vJyHAxbKCywNJjrVgIPrn+WLFhspFs9Ayw7mY8GxLnF431N23DIrJ
         cswmAMXDWRlkgB5KhVZ3gWyn+1/hnJTbeTCtlAm2WM5aPak6ISk/PIFXcM8RK/7NbA0t
         u0eQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0oKbBIKpnoiqjmGnCquyorkyrxrCpik26URHb/KXFUfuuWb4A1D1T93zDOcIh7ZMsIoe2MmhZOw==@kvack.org
X-Gm-Message-State: AOJu0Yyrpg/T8+nW7+BvO67sdUj02Esz+VtBvOFvT+D3Py20xiewuwC0
	yMwWprBaLIlGaacc+HgppGYRqupvnucGGIb/0mcQ0QEvHGjnglRjPUC9
X-Gm-Gg: ATEYQzzT8zhUcK0NAW3QCyrZCjp+e9UWt39R2xj1OULf6RKpvZwgiGKC4RZUIfATF4T
	D9L7n+sSg8BTQwIrLpen3cBwFry3uMtq1u4mF5YvNgq10LVVqFw+Q7RIsInrJoeg+6s3MThY73Q
	NYWKTQXuM2O7/YiLYQclDp7dzadZUegzQUgE1tv87mEzq0/8JlMUbG3kmeiukBb+nloWfKeE5hO
	DoO1QAm7BjqAySROsbl6wPVGnWcGANUIo5QMt1h6r6NB5rvBLX5OW7Zt85zDIxS3zP+nrZKI15M
	xzYKrz2RqnnfOKXcUCQ+paIul79w5H8nb+2ajcPK7uRm7PnoQs/B5S2xpvDD+3KbCXGseYRBBgO
	r/0hTYKDHJklFAUeaO/g58qz79FUubS4ANRyACaeSP0k4LzavCA6VXoY3Ulv9VLivBah1MWolC7
	tcyEeOR9wrhPEWU/Y2Q9Cm
X-Received: by 2002:a05:6808:22ac:b0:450:3e21:f567 with SMTP id 5614622812f47-4651ad0d5aamr1135266b6e.56.1772641614328;
        Wed, 04 Mar 2026 08:26:54 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb4028cdsm11886351b6e.9.2026.03.04.08.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 08:26:53 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
Date: Wed,  4 Mar 2026 08:26:50 -0800
Message-ID: <20260304162652.335793-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 161x3z3xbuibkg9fqa6rat1zfkz1pqih
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E5EFC0010
X-HE-Tag: 1772641615-299364
X-HE-Meta: U2FsdGVkX18+7Bvd6OY4qBECizfKW18tDaPsx5JaxNu1vA/yxIy0Efa+FA164ZcBDwW/S9/ZVitNZ2n2d+/zRwWcSMzf+EszrrWlcLogHHafQnYSXyIVynDB6TwZakfae+AYAnrIKEg26IWOnnHPrg5hz5RxFLdn3EFvn4xFokMgGT5J3zElH+MDP96qMaJ3WJ7CdSJI5opOS16AMf49nLSpA2NIjC10FMQZugWdLiD8tmek6vQeRNclB9ZqeCCYvXfwyB1q22A0fueAkCBP6HlnKcSL9l3Ky/ZNGZd5PJppbUG8VMx3c+wh+x73J23DwTexb/+8yfbNBqU1G0RHkLz9Qb1ZlrcSlrWibLhUVnmc0EwOND2m3cQVfbiAGxi5ui0k4kFUhVKM/bne4wr36grCGvbBVXJbG2yvqe3I61uERLm5ikzbPI1jS5rPhKv3IEj1qa7X6Wvit7/I52tyKIHxyZjlBGjV52w7PwM0JJrtOZ29LYehIETmMX00r2TaaD716Xb8DGN3gnOFRBL9azH7zomwSUv8OBRnyxrRyhLECpAV5nAZftDr9t1BiMDKBuzHMcSzBBd4B/m+oCjJ6TiB+dA2UWyNhY47py9PiZ/lRT2e1d8pCKwkwtunzEpdf/nYOn4SrYzKSijOuLflWu+hua2ibFttcV4pGTBzpv8F8eFXcOJdcgvGqIm6fplEguECAFWjGapYYH3Fc4I27zAky0gyAZ0kTCo8hAKG5Z8ygD0vV77NTE8qcR21XI6KciT7RkSUkhHuKtrXKywdWUBPhuCU46KHQ9tDQjX6J79FXwKEmoxfrYt++3lRYKDy1FPvwPQP/eFFL1QWAsvOGO/QdAHsXw8h2TUDOv8Vvu4fTTqQHhm6sC79ukVxEU+A4Gf7zJYOWDGlJTNLQeKEN4NLxDpO3K1kCedu7G2mKsWUkzmtZBVqF6J2ZaePtR0V7OGKRJtCXrCm6Zg0tJZ
 W6jGI23w
 8lHB/Xgh+Snox0uVo1Ol9k/d6tDVuJByk8ZC+PagxeE0+6sDyur0lFGyJdrweBABp+nLFcFNvWkZ+aWLl19TO9c4z/DGANct9TOtnQh6ztlHU5UD+3Tjj0/sIwudUmIYFin/aI2f4WGM657mVrtWCYZd0/l1n4OQq0EwOUG1rJCnZ0DNq/5wEixZp+SMeSajiXOiPfFzH1oBZMCbu2fvbpYhcHdIe3BYTUV+iAH1pOxpqfqH8f7l20eK2LQgUbDzZCCy3TPG6W7S/C12ZErtro6ZJpvVLXNE5uVo/mGfgr3exfTyZZhRELKUibwX7eyTsu82YOuNtR8yKRgtvq8YphxvYvs0z33zXS1y5cH6lnc8VMen2Eyy7glR2yYUq/UqgspCCFQ77ocTuiQYy0Q/Mnz8WhoFSwkRMwy2TNIdE+l4hNjVBd/1cH8PhAtc3Y2TW0AGK+fSdSfFF1y/LM4Ywb291fZGcK2yLOErDgB+GI8UywCDyQvgrgPOUghf715kmtuTDdTL8C5ZV7Gi5BQaFnNFUbZtU5ZXJASpbj9WSqLcYUQXiF+shPrjOSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 07:46:48 -0800 Yosry Ahmed <yosry@kernel.org> wrote:

> On Wed, Mar 4, 2026 at 7:11 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > On Tue, 3 Mar 2026 15:53:31 -0800 Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > > > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > > > index 067215a6ddcc..88c7cd399261 100644
> > > > --- a/mm/zsmalloc.c
> > > > +++ b/mm/zsmalloc.c
> > > > @@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_class *class, gfp_t gfp,
> > > >         return true;
> > > >  }
> > > >
> > > > +static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
> > > > +                           int size, unsigned long offset)
> > > > +{
> > > > +       struct mem_cgroup *memcg;
> > > > +
> > > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > > +               return;
> > > > +
> > > > +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > > > +
> > > > +       /* PF_MEMALLOC context, charging must succeed */
> > > > +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > > > +               VM_WARN_ON_ONCE(1);
> > > > +
> > > > +       rcu_read_lock();
> > > > +       memcg = obj_cgroup_memcg(objcg);
> > > > +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > > > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> >
> > Hello Yosry, I hope you are doing well!
> > Thank you for your feedback : -)
> >
> > > Zsmalloc should not be updating zswap stats (e.g. in case zram starts
> > > supporting memcg charging).  How about moving the stat updates to
> > > zswap?
> >
> > Yeah... I think this was also a big point of concern for me. While reading
> > the code, I was really amazed by how clean the logical divide between
> > zsmalloc and zswap / zram were, and I wanted to preserve it as much as
> > possible.
> >
> > There are a few problems, though. Probably the biggest is that migration
> > of zpdescs and compressed objects within them are invisible to zswap.
> > Of course, this is by design, but this leads to two problems.
> >
> > zswap's ignorance of compressed objects' movements across physical nodes
> > makes it impossible to accurately charge and uncharge from the correct
> > memcg-lruvec.
> >
> > Conversely, zsmalloc's ignorance of memcg association makes it impossible
> > to correctly restrict cpusets.mems during migration.
> >
> > So the clean logical divide makes a lot of sense for separating the
> > high-level cgroup association, compression, etc. from the physical
> > location of the memory and migration / zpdesc compaction, but it would
> > appear that this comes at a cost of oversimplifying the logic and missing
> > out on accurate memory charging and a unified source of truth for the
> > counters.
> >
> > The last thing I wanted to note was that I agree that zsmalloc doing
> > explicit zswap stat updates feels a bit awkward. The reason I chose to do
> > this right now is because when enlightening zsmalloc about the compressed
> > objs' objcgs, zswap is the only one that does this memory accounting.
> > So having an objcg is a bit of a proxy to understand that the consumer
> > is zswap (as opposed to zram). Of course, if zram starts to do memcg
> > accounting as well, we'll have to start doing some other checks to
> > see if the compresed object should be accounted as zram or zswap.
> >
> > OK. That's all the defense I have for my design : -) Now for thinking
> > about other designs:
> >
> > I also explored whether it makes sense to make zsmalloc call a hook into
> > zswap code during and after migrations. The problem is that there isn't
> > a good way to do the compressed object --> zswap entry lookup, and this
> > still doesn't solve the issue of zsmalloc migrating compressed objects
> > without checking whether that object can live on another node.
> >
> > Maybe one possible approach is to turn the array of objcgs into an array
> > of backpointers from compressed objects to their corresponding zswap_entries?
> > One concern is that this does add 8 bytes of additional overhead per
> > zswap entry, and I'm not sure that this is acceptable. I'll keep thinking
> > on whether there's a creative way to save some memory here, though...
> >
> > Of course the other concern is what this will look like for zram users.
> > I guess it can be done similarly to what is done here, and only allocate
> > the array of pointers when called in from zswap.
> >
> > Anyways, thank you for bringing this up. What do you think about the
> > options we have here? I hope that I've motivated why we want
> > per-memcg-lruvec accounting as well. Please let me know if there is anything
> > I can provide additional context for : -)
> 
> Thanks for the detailed elaboration.
> 
> AFAICT the only zswap-specific part is the actual stat indexes, what
> if these are parameterized at the zsmalloc pool level? AFAICT zswap
> and zram will never share a pool.

That's a great idea, we can abstract the ZSWAP and ZSWAPPED idxs as
"compressed" and "uncompressed" and leave the flexibility for zram
to do similar accounting in the future if they wish to.

Thanks for the suggestion, Yosry. I'll include this in the v2 and
send it out! I hope you have a great day!!
Joshua

