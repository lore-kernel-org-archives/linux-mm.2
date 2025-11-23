Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C59CFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 23:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E876B0010; Sun, 23 Nov 2025 18:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545D46B0011; Sun, 23 Nov 2025 18:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A976B0012; Sun, 23 Nov 2025 18:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 383486B0010
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:04:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9A0EB6B47
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:04:18 +0000 (UTC)
X-FDA: 84143402196.20.D615342
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1574410000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:04:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aoueOxgS;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763939057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4To7b+FdJCfm7x6NN8dJ7gobBokX+TP0wT9HA/9D15M=;
	b=Ru/iEm7rqIJwWB06bplPne9uCrDe2+gBHaUuOSy0msicy8SThfZsd3wG4e3Nk9IcCTuJGo
	dNvY3YppeODqjM7IhDAoQxrEB0VjPuofWg/LiAtN2sK/u4aEtu7uIsHla6f+sBUbPmRQcd
	oPgjpKKGEUsQ2oENuuMP6709AmFA5uQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aoueOxgS;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763939057; a=rsa-sha256;
	cv=none;
	b=fmx1sZJxqq7lN3V7ZElJxZ07j8dYw1i9l14sPl+qjY7qwx89vGGwvCn79pBadrB5K7TTjc
	KJHHzHqFKKmDrjoqgOYTEBSvVFIX80wXStS+DMQ0MTtWeB9+AnXWUl539D2qg+HFvuSGZk
	cU+o7rtZcxwUNeI3v+CP/SPt+jWmjR4=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78a6c7ac38fso39298487b3.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763939056; x=1764543856; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4To7b+FdJCfm7x6NN8dJ7gobBokX+TP0wT9HA/9D15M=;
        b=aoueOxgSbTi61h7Zmsfl8OFVKTlKHZv7esTabRyWcx5Pxgukp/MM3KzMY8TU7AuJmY
         S3B6IvQXYeqrDGLbtqvEqJeToFslKe92113hKe4LE9gaaxR+P9ZocfAVnnoHmYZ9uVgS
         jVmO+PSQq78HKs+FDK4hw1Sp1e6dTCRrkDqhuWnRXyyL29jOZTa8cKW5/OvEUteXXF0n
         JUuska8qKO9Cjj7pbweVXlOv6/8EkJhwdQgcwGoSOsz/rxCa4hQJgRIJ7WBgsrVfDSGQ
         wDgKhqDp+zeVc7Va5PirbG0ar43BLUgIvPsa3Db2SmurLxi21EZaMX2pI6SA6PwQsrNz
         Gfjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763939056; x=1764543856;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4To7b+FdJCfm7x6NN8dJ7gobBokX+TP0wT9HA/9D15M=;
        b=uA8Dsb/zpAeAkJqkprCkaILBXDq3wzKdo49ywXXe/rTis9II71Y+g28pfedKIw0pmr
         2A2qdlE9+WZH14m2tIT30a/CgN/76HLWxP9YZXe28mX3IE0cfXhQzoxLmHrWOrkdNdLR
         I4pmBqYa0XqTXjjoRO3pauZVFpWT5PuifhS6TiMJfGtTd02jhr0Qx6XAt55UwpTs9WDc
         1x8qE2+JVeFHmlK7hjWZQdhr+TZIWFFp1KIdTxPr+C1oBJohzEc7+9d8vMSKBDGFO0EW
         +Xp7xD4MjEkMuIM7hL4AYszne4eUycOXik7upyXFX0ZqQF+GRCQEn6kbAakddBfTYHgG
         r8xA==
X-Forwarded-Encrypted: i=1; AJvYcCXDBteVA+lJUnTeiZv2ZocdgE4mrJOxKACsm+yJR77Q+/jn6xkjd8MEj1onIsajs9XWB8c9Tec0mg==@kvack.org
X-Gm-Message-State: AOJu0YygAhXnCO3CLzg/cHuwwUalGQSBC2x5khl2hiAnJn9JIaWXrDZB
	1lNkub4+f6M96G4G6h6goANYgAUb58i80Ao/j2O3steUEWJb9Kkz06XEBmz8gjclfw==
X-Gm-Gg: ASbGncuoAUOmuPCZseU1CDqFPyj6V9cDuudivMwlOsUcRzTtV/CUGOOsHszARJZKYwX
	Pd/FgYbnBDDGzkTlthwX8RaVLsZqCrIUgiaLhAyRmEOkMmcvDEq96gUJCjReFZAIlvT/PRqVzs9
	pSODZpS7PntuzFIeTJ2NjF61sbQc4ts0w1S2CkImkXeEdf5Fswhd1acgWgE92IA1UcU3z+/F3br
	63I+VWxtdEQGu3V9QpqlrE11ixfsY6nDA/SGRPeaJiiivcmfcScWEaP75gekUTg6qg/7cKE0hgW
	OoZKe8kKOJLhFAmIslyTVFJ+h0D4diZTz0ZkjfiQSavsJZlMDjJ6jelxVfVM7LkaEjLFmo8jfDY
	Rwao+x635tlaohQh93uWQN8en79x90E7ZCeNnI0wWYiTiuJIo2Zm1y1Rs8SvGWZKwUMcrNUErSz
	BlUkbgfV0ogMvXOxspLa5kTSx2D3y+QUBrDCMelOTt9Djv/W6jW7SzZMLbKenH1W8UxJvkjSHji
	La/ObzzCw==
X-Google-Smtp-Source: AGHT+IF756jrV2oLibW5tf5NDM6N2r7s/mEMmh86sg0+8QTIPkOqCx8s0LJAvVrt7NhG09kGSX/0rg==
X-Received: by 2002:a53:d048:0:10b0:63f:add1:e6da with SMTP id 956f58d0204a3-64302ac84a7mr6154857d50.57.1763939055759;
        Sun, 23 Nov 2025 15:04:15 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a7987f5efsm38723527b3.9.2025.11.23.15.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 15:04:14 -0800 (PST)
Date: Sun, 23 Nov 2025 15:04:03 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@lst.de>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
    Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
    Zi Yan <ziy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
In-Reply-To: <23fac529-7b4d-4095-8c64-0d4a9d08c9b1@suse.cz>
Message-ID: <8d043756-b59c-f604-f859-3f4803bbcd23@google.com>
References: <20251113084022.1255121-1-hch@lst.de> <20251113084022.1255121-7-hch@lst.de> <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com> <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz> <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
 <23fac529-7b4d-4095-8c64-0d4a9d08c9b1@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1574410000C
X-Stat-Signature: bw6dzoshx3mt5pjuqm3h65ji7x6njefn
X-Rspam-User: 
X-HE-Tag: 1763939056-121217
X-HE-Meta: U2FsdGVkX1+OLa8EpZVNjrcjXTpNYWjColhDSGJ6mKp6kgtGF1m+HS4/lgajk9DGbTedgwJlBtNPtlV9iT7aOL6D2PWpJh16ZKqni/HuW/oL5xr4FSdxoZ7y1l46nkCaBssD+PsrV5Z+w6ZKUhoOCE5/pO0Y5K4XhaKkceTvZFBEnRml08Kv4wLeEbGRpYKBYu3FrmVM+Psd6Uzs0VR/4UrWDmP1rMFEGWczdgKAy6dJEvJXEFeJgwx6BGWyipw0lwRc6E2YT5oiYvg/W9V7F1cSUMKZ7WubUqMwz+gcL8OhtLzVI7P0K53/HJDBmecFCgjHqfJWgiFimfWBmMIxLs7Q4zMpHwZ1gtptyxfC5scu9P811jM+kKTZ0IkFkf8OxlmiIoTqkQWRH9ugJcz/0L6I2RRaAG1+rNZc9P7+nV5XxdigDdUdJm650cUJ6ed4MjYPalqAPY+MdPBXMTFkk+S/Rhj6JS4at9Mzc/WHBnBfLREE5Cxkeg4L/9I3MJMqbA1Qo40+2mCsoKolyMQNNjU9yAIa/ooTltmx8PqkwBnfafQMIpgYF4nKndhrBOnVrPbQDRyFsyH3V8jm06Vl6TzoDiJ2uRHsY8NUXEDW+ek8V2tV7+2qZlfPEW66y8lIXXYITNTSGCnSIeMHa9k25oOb2/D9CUg+X5GuHR9X0ASkbgdl4vGXXz0FtRUTXBY2gYwXaG5Y5AvGAlLE8qJH6MGkKsZHXIfpLHjMgP65vruzm0QANkxlXHYEdpbV3hmdEGGE4UViqBzoAUKYLuJB+wQpcc3DpIIaRDaQTisXENtWkrEgxlzz6Ky8fK0rOqGqGtPdaZzNueAgSZF2EiGcloIQN/noS0lZmK7bFkD4RqQEY29rmFsVZeIYNQHd2WHl7KHmbIWlVl75wXKIJnkxMsjbHfEHub0ZfnxtIcVPw7gJEP6hruaeJ/sP55MQFb/HpKcl8oCPwP2PMTOu3zA
 +29crafL
 1GLGIIUIgfK3xwjgEW9vc0S3xLSRH1aI/QWWU6UWv7UGRBlHlKceIZZDVzStIZoua/degS47JVYQNgIfrwVxcnBgkrdpWp1vT00rsbiHUp5BaeV++ScSZ0sWs8TBQqb7p8moAFaDsfc9eioITech0DsJtqnXcX+T3gKQckgTBEYwh1UXpNwTPG/NXf+VF5Ob9sb2rqucDyhSWapp2USMADs0TI+u0F5e7n70GtDfn2zjG2pOOYtFEs0FdGEUPSFL7Cf68l1+uaag7H6iaV+vnx3zzuQWzlx0yGIWlhx8k7i3x53VpLl9WhvKXn8VSSOTTJlVogl3Z+BZzaoJN9I9BAP8IqVyqhuoK4zRNU+e00EuRCiC8h2PG/n3LZ/7Oi+Utp43TxEg8EUQMp2Slgq3LO8Yf7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 23 Nov 2025, Vlastimil Babka wrote:
> On 11/23/25 18:49, Hugh Dickins wrote:
> > On Sun, 23 Nov 2025, Vlastimil Babka wrote:
> >> On 11/23/25 04:42, Hugh Dickins wrote:
> >> > On Thu, 13 Nov 2025, Christoph Hellwig wrote:
> >> > 
> >> > 
> >> > No, that is wrong, it breaks the mempool promise: linux-next oopses
> >> > in swap_writepage_bdev_async(), which relies on bio_alloc(,,,GFP_NOIO)
> >> > to return a good bio.
> >> > 
> >> > The refactoring makes it hard to see, but the old version always used
> >> > to go back to repeat_alloc at the end, if __GFP_DIRECT_RECLAIM,
> >> > whereas here it only does so the first time, when gfp_temp != gfp_mask.
> >> > 
> >> > After bisecting to here, I changed that "gfp_temp != gfp_mask" to
> >> > "(gfp & __GFP_DIRECT_RECLAIM)", and it worked again.  But other patches
> >> > have come in on top, so below is a patch to the final mm/mempool.c...
> >> 
> >> Thanks a lot Hugh and sorry for the trouble.
> >> 
> >> Looking closer I noticed we're also not doing as the comment says about
> >> passing the limited flags to mempool_alloc_from_pool() on the first attempt.
> >> 
> >> I would also rather keep distinguishing the "retry with full flags" and
> >> "retry because we can sleep" for now, in case there are callers that can't
> >> sleep, but can benefit from memalloc context. It's hypothetical and I haven't
> >> made an audit, but we can clean that up deliberately later and not as part
> >> of a refactor patch.
> >> 
> >> So I'd amend this patch with:
> >> 
> >> diff --git a/mm/mempool.c b/mm/mempool.c
> >> index c28087a3b8a9..224a4dead239 100644
> >> --- a/mm/mempool.c
> >> +++ b/mm/mempool.c
> >> @@ -478,10 +478,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
> >>                  * sleep in mempool_alloc_from_pool.  Retry the allocation
> >>                  * with all flags set in that case.
> >>                  */
> >> -               element = mempool_alloc_from_pool(pool, gfp_mask);
> >> -               if (!element && gfp_temp != gfp_mask) {
> >> -                       gfp_temp = gfp_mask;
> >> -                       goto repeat_alloc;
> >> +               element = mempool_alloc_from_pool(pool, gfp_temp);
> > 
> > Haha, no.
> > 
> > I had got excited when I too thought that should be gfp_temp not gfp_mask,
> > but (a) it didn't fix the bug and (b) I then came to see that gfp_mask
> > there is correct.
> > 
> > It's looking ahead to what will be tried next: mempool_alloc_from_pool()
> > is trying to alloc from mempool, and then, if it will be allowed to wait,
> > waiting a suitable length of time, before letting the caller try again.
> > If you substitute gfp_temp there, then it just does the same pool->alloc,
> > alloc from mempool sequence twice in a row with no delay between (because
> > gfp_temp does not at first allow waiting).
> 
> But it's not exactly the same sequence, because in the second pass the
> pool->alloc() has the original gfp flags restored (by gfp_temp = gfp_mask)
> so it can now e.g. reclaim there. It's preferred to try that first before
> waiting on a mempool refill. AFAIU the idea is to try succeeding quickly if
> objects to allocate are either cheaply available to alloc() or in the pool,
> and if that fails, go for the more expensive allocations or waiting for refill.
> 
> AFAICS both the code before Christoph's changes, and after the changes with
> my fixup do this:
> 
> 1. pool->alloc(limited gfp)
> 2. allocate from pool, but don't wait if there's nothing
> 3. pool->alloc(full gfp)
> 4. allocate from pool, wait if there's nothing
> 5. goto 3
> 
> Am I missing something?

You are completely right: it was me who was missing that the second
pool->alloc is with the full gfp, so not an identical repeat of the
the first; and so it is correct not to wait after the first attempt,
so you are right to call with gfp_temp instead of gfp_mask there.

(And this also addresses my slight concern, of whether it was
appropriate to be doing a pool->alloc after waiting for a mempool
free: your way, there is no such wait, at least not that most
important first->second time: the wait would instead be inside
the pool->alloc probably, reclaiming.)

Yes, your fixup is better in all ways than mine, please go ahead.

Thanks,
Hugh

> 
> > I agree it's confusing, and calls into question whether that was a good
> > refactoring.  Maybe there's a form of words for the comment above which
> 
> I'd say it was intended to be good, apart from the bugs.
> 
> > will make it clearer.  Perhaps mempool_alloc_from_pool() is better split
> > into two functions.  Maybe gfp_temp could be named better.  Etc etc: I
> > preferred not to mess around further with how Christoph did it, not now.
> > 
> > (I also wondered if it's right to pool->alloc before alloc from mempool
> > after the wait was for a mempool element to be freed: but that's how it
> > was before, and I expect it's been proved in the past that a strict
> > pool->alloc before alloc from mempool is the best strategy.)
> 
> I'd think we better do it that way, otherwise se might be recovering more
> slowly from a temporary memory shortage that cause a number of tasks to wait
> in the mempool, which would then have to wait for mempool refills even
> though new objects might be available to allocate thanks to the shortage
> resolved.
> 
> >> +               if (!element) {
> >> +                       if (gfp_temp != gfp_mask) {
> >> +                               gfp_temp = gfp_mask;
> >> +                               goto repeat_alloc;
> >> +                       }
> >> +                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
> >> +                               goto repeat_alloc;
> >> +                       }
> > 
> > I still prefer what I posted.
> > 
> > Hugh
> > 
> >>                 }
> >>         }
> >> 
> >> 
> >> With the followup commit fixed up during rebase, the diff of the whole
> >> branch before/after is:
> >> 
> >> diff --git a/mm/mempool.c b/mm/mempool.c
> >> index 5953fe801395..bb596cac57ff 100644
> >> --- a/mm/mempool.c
> >> +++ b/mm/mempool.c
> >> @@ -555,10 +555,14 @@ void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask)
> >>                  * sleep in mempool_alloc_from_pool.  Retry the allocation
> >>                  * with all flags set in that case.
> >>                  */
> >> -               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_mask) &&
> >> -                   gfp_temp != gfp_mask) {
> >> -                       gfp_temp = gfp_mask;
> >> -                       goto repeat_alloc;
> >> +               if (!mempool_alloc_from_pool(pool, &element, 1, 0, gfp_temp)) {
> >> +                       if (gfp_temp != gfp_mask) {
> >> +                               gfp_temp = gfp_mask;
> >> +                               goto repeat_alloc;
> >> +                       }
> >> +                       if (gfp_mask & __GFP_DIRECT_RECLAIM) {
> >> +                               goto repeat_alloc;
> >> +                       }
> >>                 }
> >>         }
> >> 
> 
> 

