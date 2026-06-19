Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968A9CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 06:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653466B0088; Fri, 19 Jun 2026 02:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604866B008A; Fri, 19 Jun 2026 02:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519EA6B008C; Fri, 19 Jun 2026 02:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2294E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:02:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9199B1C122D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:02:36 +0000 (UTC)
X-FDA: 84895617912.24.848E1CA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 72A3820011
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:02:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WT9lZBM9;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781848954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fn5DPboWJkI9U1kVq9yhwYF9FI1OrZduwolmjIav4rk=;
	b=gSZt8DAnHTcWGiflTwfm9OFaslOGSKBoFmqlyTgH7HvaJDqsfDyZkKujAzZ4WvMSXaFAy3
	LFoZSnhWx3d3KNHxUsBeDV5iJ4tbOrnAjrL1csjaif15h/H6PZv5pbuu6uZ8S8YKHcKIhC
	OYYcqRMR4k/4vwhS+6fuPyrXIJEhrW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781848954;
	b=MJB1kJc2AZb2HHQ13y4S64UbyyiqNrqgGAhRnVKWrvkjuL5h/SvYo3fVqvvz4i/0YLknSQ
	KkiFQzCCKzbr+LVfLf9M3NbxE8rPh47kIdf1r9Sf96nQTI9NKYGNYU2X4E3G72x81bkrjK
	ggmf6ek2Y53woXJ1m74wj/QpzdMsebs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WT9lZBM9;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921e4dd62dso12642465e9.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781848953; x=1782453753; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fn5DPboWJkI9U1kVq9yhwYF9FI1OrZduwolmjIav4rk=;
        b=WT9lZBM9M5nqLQmIvgD9Z4CvnCZH8NfVn/kAPWoWcy9tzWIYlPG7XFOry6iiw5pMBP
         QEHrtN+IuKiG17DTuMlOswxx/kYuqWXuYdbi3HbFjyHpUVoXm/ht41UUJZL0ZR4Unkin
         idtV/Ycfxhn0OalVCqbNSZDJpB0Y2I6LLgJHOuLRBCzNeufx348CXJ3L04gY+bK2ZFVg
         Okwy4kfqO/VPGHPPn7/0piRwpAh1SJsge0lZqZVIsR834FeqX0Nj6JJbVeVrhXhLSR5i
         noFG/3S9K1NxUhGjVHEjBJy/wp4ntbkEkhcxuJ6XYDFtmDRvUdCJMhtKE4FXSWawRiGY
         oVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781848953; x=1782453753;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fn5DPboWJkI9U1kVq9yhwYF9FI1OrZduwolmjIav4rk=;
        b=ITZVAl2c6mQ5B2xUkuwLIf0Vn4qU28GM2/k93UO0sQgxh04ncYsQgfpJILXL3BP/I2
         kkXRo7tqg3lWznpVPCEoCEaoS8431QfcMcGRI+nBi97Mts33d7IIHQKWF80g4jDoZVIc
         gulDA0XkhN855DGcMgqRU7jawOWGUe8AGCb/mbIilMePEt/GKqfL9TAopW5HJUhY7dxP
         eHDzCfmmXV9zTsQMHLXv+NXE1x3hIGQkakEpQUi85ZroVz1ukxwav4jzU4FwsNHWz0+z
         Mkziy6yxMHWBTcEdPna6tKTvUCxAF8ieMreQLu1kk8lxVhWkDwx2p4dOg82DUDHtfFEf
         aJnA==
X-Forwarded-Encrypted: i=1; AFNElJ+NX7XVvlBHl6oHQdsbQ1vjYhTf9bpIqWdmuknxcFKHRQygq/xpU24/xwejZI5dZ6+od7T1HPnzxw==@kvack.org
X-Gm-Message-State: AOJu0Yxfwz0YdrMC15tMpDq5pNwhGQ/pPRfz/1/mYTNJbEB8hH2XS7wu
	UwDcuxFfJNCvipDmwW0wD956V/CQspYv2A1Wbt13uFVnBXpErLaZTYv3GnbQ0w19i8M=
X-Gm-Gg: AfdE7cmcyZG8nhfwNVkzKdOWctNJfZmlG5v/bJpR3oZUTDFORn6KJxxevjeNhMlDhyG
	NtN5T1zl6RaHe+ZABuPcA0TDiq3Ak8LSR34ynoeu9bPHsom80M0jbkT2/NURwzDAyns/YGzwede
	t+AksbHBjPu1F+FbwvBYPqG6AffPmUDttxo0hSHzqzgFxKZVbkQxVqzb02FCM1q+ue7G1+GyU2n
	WWRWncXQoTVdr9WPoseUv3+zvWrn4aXoEEuFf2tP7SlJnFGvHUOhModFEdw4JszKOifZbbEQjak
	a/2ixV9k561ZZeCFPg7OShpK+5pyEnMbJdZ5SSrnegpQmUB0ImaQe/6+bPqzmb4VX2bGLUmSG2S
	5ucFPnorpFMSH/3nvMxTJKRESNpMuALgJ7npqQE099g1AQ8QA2zXVGMkNeVAafbsTCoCB0NhoEe
	8wO5wcYSCbtPenHc8TCCHy8yb57Q==
X-Received: by 2002:a05:600c:8218:b0:492:1e36:9a90 with SMTP id 5b1f17b1804b1-49240a598e5mr20386885e9.18.1781848952752;
        Thu, 18 Jun 2026 23:02:32 -0700 (PDT)
Received: from localhost (109-81-26-193.rct.o2.cz. [109.81.26.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49240f054e3sm32544205e9.2.2026.06.18.23.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 23:02:32 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:02:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v4 4/4] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
Message-ID: <ajTbdjH4pTQ4t5Zr@tiehlicka>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
 <20260618130414.96383-5-kaitao.cheng@linux.dev>
 <ajQy9EtOgJQntHOd@tiehlicka>
 <b1a8a69d-ab12-4050-8468-1a05a82f290c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1a8a69d-ab12-4050-8468-1a05a82f290c@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72A3820011
X-Rspam-User: 
X-Stat-Signature: hgctq615yxfnyuyh7odfs5w47qwqtk5u
X-HE-Tag: 1781848954-493785
X-HE-Meta: U2FsdGVkX1/sfaSmrRtU7z1cOiWh5l/4y5lVcN9M0rLtXsSUKJ1vv4kXGYfkDKy3+3e/SDkUh2IjIAiLEi/H/kwyIO0C+MtZTyNwfQYbesBTBwgCGbCzujUh0y8jwduHrI/LO8wExJB6ey4mMIIuuCqy/7Mliwk16he1NAndV9xuUDzX6AgybhEIZKbG2pNKgn+r6BealIrfEoExxFlb10hTDTSg5yhyb0pUGiFPTybu8mCjqAztiFF3Flxc8J70Wfas3GYaSWZD5D4PlGhFK7S8FvaXoiM3P28AzQF+z0/TfMG2npAfvQ8YPQmoebHg/UwPmuq2rhN7Q/5AysYonq+nQzUpF3imcIrTVsGYKpsuKX60UQf4O3ihr/XryhOkZuCSW6m7JNVGoXhqYbyFJe0g1z9mJoCz3HBPPAtSt8JW4eAtjnrXZl4pee7u5jZ9hEBmcSk7eNutC4hcck4AHcVxMHAH1w+sFcepjwcxJQpS3jS/pAE67lvkPmMIKSXpCIKUh8EotJwDtKO98OKHv/tyHIyzrXo+KMUUn66cUYG/NnRJ2FIX0mfQ33C+ROyx0FiMbboyktHjDXeySlTF+zGsZIm+/yQAofw309uKGdHmqqzN6jnr7mSZMXSmyDqZKBSqo1yhXecOzbAoKH1uTpN62P4SDXMAxUatiqf4RMCymZC3fgNeUZx/PQWeKGFso8U9Of1rmM7RfOyxCKnyRyooNI+l+l6Y6wSYa0JjdsBena8DT5APx6fvhMt0XmK78gWEE43C4TWQEOXzklLcMSa44sRJENWTWXFOnWqPsVRnD/n/Ngg0uL7rr8PUQkcs8b2KHeR5l5XLlYYKzEeELUoUNZaO9lZ2qeoOVK8/SY4kMAU1wLJZCTd07KzdF+fjBV/BMaRwXoje7gQHpxWSrrOC/7rttBqz1wvYDhvgvYHaDlJMB42kqZv8Me4/SkBj0d58VoEDiVhyOMEdzaJ
 4C4JYJpD
 GwBuA45uKof4nolPS0V/95jl4P48uP7m2bh3XzNhRU0dlZc6T9N8rGb40tYH4p4ad0TIdVlBW27nG8pL2z01+OUNSHE4O6jC/qI1/P092F2x98TCRCawa3piuqCqH0Os35G+4IqDOYXUdG98XESZeij1KlZ0ADZ5uGpmXDeH+cz48za6p1WomSXwo4zjksCrb8BiB88qgcVXa2NXxIfpjDHFLlry+/9RKhJxmAZFtSsYO2Q5XtlCTbwzNSff43M5HvslG/alBrB6QbWn5TI/BWd1IQ+U/VfSidzr//1hwN3aR6VM9DoRlIHoi5HL6AMdCA2sIZVdbPSpZuutSqI1HmLtT+8pKxhauy/69FI91pdJwlmY1hNMUH8a52ilRYvRhCiUgaEkQCFTUCovz3ZTwLaUnMuKG88mjmh0u3k+QEvtbg2A3w1TeqNGIMjGagXdwMxyW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 19-06-26 08:21:51, Kaitao Cheng wrote:
> 在 2026/6/19 02:03, Michal Hocko 写道:
> > On Thu 18-06-26 21:04:14, Kaitao Cheng wrote:
> >> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>
> >> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
> >> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
> >> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
> >> failures, but it also makes the mutex visible to callers from constrained
> >> IO/FS contexts.
> >>
> >> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
> >> pcpu_alloc_mutex. Since the internal allocation is not constrained by
> >> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
> >> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
> >>
> >> At the same time, Thread B may already hold an FS lock and then call
> >> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
> >> pcpu_alloc_mutex and block, creating the reverse dependency:
> >> FS lock -> pcpu_alloc_mutex
> >>
> >> This can still form a potential deadlock cycle.
> >>
> >> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
> >> The public allocation still uses the caller's GFP context to decide whether
> >> it may block, but the internal memory allocations performed while
> >> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
> >>
> >> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> >> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> > 
> > This seems like the only viable short term fix but long term it would be
> > really better to make allocations outside of the lock.
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > 
> > Minor nit
> >> @@ -1749,8 +1748,17 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
> >>  	size_t bits, bit_align;
> >>  
> >>  	gfp = current_gfp_context(gfp);
> >> -	/* whitelisted flags that can be passed to the backing allocators */
> >> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
> >> +	/*
> >> +	 * Allowlisted flags that can be passed to the backing allocators.
> >> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
> >> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
> >> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
> >> +	 * waits for the same mutex.
> >> +	 *
> >> +	 * Do not pass __GFP_NOFAIL.  A small percpu allocation may need many
> >> +	 * backing pages, making nofail reclaim too costly under NOIO/NOFS.
> >> +	 */
> >> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
> > 
> > GFP_NOIO, NOFS are negative masks in the sense that that are lacking
> > flags so the overal intention would be more readable IMHO in the
> > following form
> > 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN)
> > 	pcpu_gfp &= ~(__GFP_IO | __GFP_FS)
> 
> This looks a bit redundant. The newly added comment already makes the
> intent clear, and the extra code seems to serve only as another hint to
> readers, which is essentially the same role as the comment.
> 
> GFP_NOIO already excludes __GFP_IO and __GFP_FS, so its semantics are
> clear enough. It should not be misleading, and it is also more concise.

I will certainly not insist, but this is a generally used pattern to
drop IO and FS flags. So if you want to grep for the pattern you will
not miss this place. Comment _is_ useful but harder to grep for.

> 
> >>  	is_atomic = !gfpflags_allow_blocking(gfp);
> >>  	do_warn = !(gfp & __GFP_NOWARN);
> >>  
> >> -- 
> >> 2.50.1 (Apple Git-155)
> > 
> 
> -- 
> Thanks
> Kaitao Cheng

-- 
Michal Hocko
SUSE Labs

