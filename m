Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A27C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E1B6B008A; Tue,  1 Sep 2026 18:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8126B008C; Tue,  1 Sep 2026 18:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E960C6B0092; Tue,  1 Sep 2026 18:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA2FA6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:09:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AC35A0573
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:09:25 +0000 (UTC)
X-FDA: 85166585490.18.1FF1FDD
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 160E81C000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:09:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Pl541Ad4;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788300563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4+niubgl505BkFKhEwPKEaItzjdUcc0IlA8qi6slv4=;
	b=z28VuADDAuJXoRXnjHXOcJjO+aK8L4UWCSmPmBI/JbJsCDOSs02HndYz/YuF8USLE9TBuq
	8SwGSuVQ7Uf8xFwQDJrUJPoSnuNVns1nSqKPs2/40DcxJ4joHcLAaZIBOpq3TZcc8XnpoV
	1mZp4ci6zM0Zc6kKzlw80VWXCLQSRs8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788300563;
	b=ts/myTQE+PN6OllrxIHwpLDIahm2D0Mgh6sgZNw+qtZENdA5s+hb2NAsVAki35NqaZh00C
	SKQcgFEID9RL7nJ42tdYm8kixM+R6je3tWZ5pQCRFCfxw8/FNxdvon7wM/uPLwDj+J7yU7
	jCGXoosulp30ah/AvVSEj7LqGacZBA0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Pl541Ad4;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-836ce6cbe1eso5709217b3.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788300562; x=1788905362; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M4+niubgl505BkFKhEwPKEaItzjdUcc0IlA8qi6slv4=;
        b=Pl541Ad45D2OZFkbvHXTwWyBqBjrwmEMJKmErU3UlvNAlZUcXd8Sj+eI244QsWPj2j
         nMvLJaTQxAKQsAUcXt6gv+d/pepaHz0VBGNdD8dutmzipVzRL5mCi19g1GZmkETOyQ1j
         z0LqU+MjnWr9ZvDt8vLHtkl0CrUPfFYRc6rr3Vo6dhtFftss1TAKYnygBcwQtFckebJp
         4zjbOIvsTl7eJSlstZSQTxYprx0UBCLtE6bKPpBhBnJk2qTEjWYduOJXCazg/pX58Rhc
         HWmB4eagfcOee2tfvfu5E2uDUOZyI9+S4ExrQ2Yjy6xedj+bfq4KPGumfmvLUsFQgR0a
         dxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788300562; x=1788905362;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M4+niubgl505BkFKhEwPKEaItzjdUcc0IlA8qi6slv4=;
        b=JdYD3TOYY2CLIriXWDxC0ZLX8SKyKypaLmx0xb553WmOAobVwVvDUZKJjHdLzUjefm
         YNrB6c9h76uZ1AHowjy/mQz0C91N483QOCoK3+9qcaK51++re0J2vkI+vDFLdiqA9J6O
         f1zR+iP6mG7GaE/fJeB3CSnGPfS0cxfbohYuutJmNg7MWTUCe3H9fErMX2KyJsvmejyu
         HtO7fHHTCB9lwk8i2uL2nglOrFtwvEW+1UOPtXvW7cidsp0FVnoh8XJYafUiwsrCi7bx
         p6UiuwNIMOBYEysDDQZsI+3kGakmIg6U8LvFa8YWUKvFo7jXoBm8dlLFxIl3FCs039o8
         aEdg==
X-Forwarded-Encrypted: i=1; AKwUvBxHseefmgUOtlQDAcH7AGo4uHQzd3VyTt+7sG4UGG8liHWzom+ugl3/pkvHBVEM/h+aWmyC4LBWCA==@kvack.org
X-Gm-Message-State: AFuF++nYBL8UFEj1+ND9oinJnKdnXCFdxW4+IbutHJHr7QttCw4HzE2c
	FcFrUaSdyEoMhRMJ6+1CWrmpxaqb6uDGuCnOy/yndYwBZ0oC9VxbknByi0ObQ6ALy4k=
X-Gm-Gg: AYBFou3SIPrNGYEuyJ0XcJSQ5rfdQbzskFo9q5nDvvGR1SwZj1zTuvraAMiT2m71W5N
	m8DpRBQX0IMrpblsJFEkno0hfoUk00tdB6ER/heOAWbOSfo9NfdNN61IV8BH7T01bLSDoX8XNKv
	2Pf9MsOEDKEz6/aNaF7+tWfAHbeggu1QSuMBQ/ha76mg1IUu6by1E/MUYtS02DGzrhzB5lzHPmK
	NLIlj3M+UlMTZHej/cJkEUSHCGIheoko5ZIYRvpQRswS6TvswLXaY62gNQe7CcXFbyCcdNYBCZi
	IEv67goPNzyFR765vj420noKNQ4ecOi4ME0w7yrpIw3ReGuKIZsJVneuZaQj1CLbULmJY8MjkK9
	jgGne5ntQoOfp8sme0Op0TvpebaSKc3cYTVcTl7NGss8eSOuWT/vunRxSeNdMKnFY1u40cmcKPW
	ickdhzpdKdxLHpLAvdcGiq620KgMey9Pt5ZYE+L6CDK4IT/krQxvsDbZFE8zdCHRGa62+iWEA=
X-Received: by 2002:a05:690c:d8a:b0:81d:6af3:b9b5 with SMTP id 00721157ae682-86c4e7d322dmr2445717b3.9.1788300561871;
        Tue, 01 Sep 2026 15:09:21 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c10c93fa5sm4188977b3.3.2026.09.01.15.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 15:09:21 -0700 (PDT)
Date: Tue, 1 Sep 2026 18:09:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260901220917.GM3004@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 160E81C000B
X-Stat-Signature: b19kyinc5yxeygfo7xcfrfta11tp5ytc
X-HE-Tag: 1788300562-338399
X-HE-Meta: U2FsdGVkX1+11IZuwgpR8OpTGR/KfHpv/iJvE12dq2HOMRaudwANq9hZRhe24cEivr4vHQdyb6MilmqVaGAONkk0XC3YNMcIEKDDjgpZJe91IcmPfI/cijFnebLg5i1QBfsTZPG7rdT7sPkPO04HZ+WraE8uxRT87rxxJZ8v8viMneJjWXGhP6/JeU77JiML+Xkg5wiJDHFS4r33armUwq8CujH5ZxUXHqdF5tDV13ce/ZPE5GQ6YvH34nJoLnDTw0BWEA+U1MXY+UdQwhmv/nWwCV7dRBuo4NJDVFSPxlqtFhx2OLuO9b1iRznzAIu1LZiZv9CBgfpduTFOs9UnYHfbgnwDYnsCRfrUcV90z/Yq3OugXHnjBMet0rgg4XA3YtSSuM7Mfk+lY1HyaU/sLGtJbEfjbcXu31YxVqaBIiA8zTWvPhqHKpv1wPFwYisH8xptMoUgjk5sr3JtLPVGKDvD3WGfc2l+53KH2VsS9ZZ7ksYRKifHgHbLzsX35x7PfknxUbBL2UeiOru7TEObI7gIgjQerA7ta4/7xNoNe/Zxbb20lGHncCzzpzUjJxLPvg9ST3uuHH4Ckh/IUkma6KnqaqzHcVvUWZZ0SqvKCZR/86vyxzfcH6LvwIYOUS+c7jGvP5znesIPh4ua8AHGvdU6erDWuWaNUDqhcHiMwQg+jHH/eGZfyjAoqlE5u52k8kd7zA2fIni7P0BCOf7XE+MD7v8tig07p6CzW0WtxbWOSz+rLHxCI7AvbLMdNuIOKlHkW5A/pr8mMjKnI11ZhbWvIBTADWbNkU8OgtzayzcYVaiCI5K+eIiA99TKUS1vuGUINWi7EvPUAYO5Xfz62Fw8Th2i5CXVSFNNRyZYj5fXP0tk5/ECRVbFwnCF80OTynyf7mSoGMjoAdgFsph5CkmawqhUmKbCXgRXUPEl2sdaFQQJR1DL5DDfVg50JbVbetasPqtxlO/mvKXzANV
 b5SyY8XQ
 FJqHo75nc8+3bnwMOEV/U5DA8nOHaUQIPZfeo2YIaSpNhu06RiQ5cHElKH/oVvWC1lxT0xTu+bvAw33o5+5BlHOcQJXcBrUBMP3hp4vSD4xEzhcMfqTjCwYNpM1hLowNpdA7Gt8/SVl7Aq+nDu/ilDGWkf+G8aYnFu8Gd/h3RD8Ly7BU9xKteUxFe9bqYXkX/4D3VcKiifiUlPa1oraBoyKiLyb+EntoDnUVuevIT3hLGt3nmFOYS4bSJXZFjT1oC3hrjbPr/AfN3rleTTugT+N/EKzJHyO0sq6imRFK7gwBd4q4xD2vKC/4yC3kH1JLWkbjDwzRLAPbzkZJJuXysK6WY/2wFKFVrbAjxZi3G5LkciDR4PzHCo8IUGLunLFu35g7uCt7STcvEE75rLzYgvniztdJdtfPlPozftqfLlT/ad1BoXBNPNmhqWdiH0H0Ohx4lNQfV+g3sG1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 05:09:52PM -0400, Zi Yan wrote:
> On 1 Sep 2026, at 16:44, Johannes Weiner wrote:
> 
> > On Tue, Sep 01, 2026 at 10:01:23PM +0300, Nimrod Oren wrote:
> >> When THP is enabled, set_recommended_min_free_kbytes() may raise
> >> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> >> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> >> heuristic to help keep pageblocks free and reduce fragmentation for THP
> >> allocations.
> >
> > We've had problems with compaction before when min_free_kbytes was too
> > small on large machines. Competing free space scanners do a lot of
> > work only to fight over a very small set of possible target pages.
> >
> > So I'm a bit uneasy that you didn't include any benchmark numbers with
> > this that prove basic functionality on larger hosts isn't regressed.
> >
> >> The recommendation scales poorly with larger base page sizes. With the
> >> default arm64 pageblock sizes, the contribution per eligible zone
> >> before applying the existing cap of 5% of low memory is:
> >>
> >>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
> >>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
> >>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> >
> > I question whether pageblocks need to be 512M on those machines to
> > begin with. After this patch, you're still asking the page allocator
> > to optimize grouping such that 512M pages can be allocated at
> > runtime. Only now you took away part of the mechanism to do so.
> >
> > If you're using 512M THPs, I would kind of assume it's on machines
> > with a memory size where 5.5G for defrag purposes isn't devastating.
> >
> > And if you're not, it would make more sense to lower the pageblock
> > size to the mTHP size you're actually using. And that would fix the
> > "excessive" min_free_kbytes issue as well.
> 
> But lowering pageblock size requires a kernel compilation. That means
> maintaining two sets of kernels for different needs.

That depends on whether anyone actually wants 512M pageblocks...

> The ultimate solution is to enable better compaction to generate
> THPs bigger than a pageblock size, like Rik's super-pageblock
> proposal.

...or whether we can say, at that point, use gigablocks/cma+hugetlb.

And then the static pageblock size for the fallback logic etc. can be
a smaller, saner default for everybody.

Because the point you didn't address: it doesn't make really sense to
have 512M pageblocks on smaller machines, beyond the min_free_kbytes
issue: Fragmentation events will poison half a gig at once,
should_try_claim_block() becomes harder which results in less
conversions and more allocations falling through to stealing, page
isolation is more likely to fail, compaction locks and operates on
oversized chunks which is bad for latency and concurrency...

Seems to me the excessive min_free_kbytes is just a symptom of a
deeper problem.

> After removing automatic min_free_kbytes boosting, user can still
> increase it via sysctl to restore the old free memory head room.
> It is much easier, right?
> 
> >
> >> The automatic min_free_kbytes increase predates proactive compaction
> >> and many subsequent changes to compaction. Given those changes,
> >> increasing min_free_kbytes for THP by default is no longer clearly
> >> justified.
> >
> > That's pretty handwavy. How would these changes specifically eliminate
> > the need for compaction scratch space and allocator fallback options
> > to stave off fragmentation during placement?
> 
> Extra free memory is still necessary. min_free_kbytes can be adjusted
> at machine boot time to achieve it, right?

That argument cuts both ways, no? ;)

