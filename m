Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C414310F286A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102396B008C; Fri, 27 Mar 2026 15:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA186B0095; Fri, 27 Mar 2026 15:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F322B6B0096; Fri, 27 Mar 2026 15:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E38526B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:53:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85771BE964
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:53:11 +0000 (UTC)
X-FDA: 84592891782.18.7305314
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5EFFBA0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:53:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=V5GwXcRN;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774641189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sprVlPGXU/l7BB3P7Z9OXglgjV345FzoAVG09a2hhrs=;
	b=ScC8nANd/bIRFeQR5X6gZ/g+Hf0hTH7hy9+STWvP2Koq27xD2/SeYPD5+QcPBgM9wLlvQh
	/3FkhbhtTpgvD5y/kgvTZ+i9sZj8P1C9Iuy8g7ClluhUvvOkqIErcCaBOEYbfxNYyuiXrR
	tloCGdRZZuTFD5rsPGkGLUoXlQNd6ZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774641189; a=rsa-sha256;
	cv=none;
	b=w9qi3p9YhBe/OnX3ZcrtVUD0c3z4dcII4POefv2Sx5DkI0SqQIMRC8wHUJOUYJR9EXUQBw
	6JUEYFtE2LydBqlLzEqCTz8NSo2cnV9goz2jlUKe63suD36hRkcbydZXoHeyG61tXhnSwD
	tTt3mhDlwnC61ePKuEOaZlKQjSGioF4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=V5GwXcRN;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89cdd75e424so23135246d6.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774641188; x=1775245988; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sprVlPGXU/l7BB3P7Z9OXglgjV345FzoAVG09a2hhrs=;
        b=V5GwXcRNGZLf+d08Mu8ppFE2Ul//a9ZSMxCAJCn5dtLLStlfB4Jb6h7P+hrcAtLSaO
         yOF2CLj6jXSf7deAF277xuGXRoCjQmSMVvM4FnYN0gdWk+Zha3atdO7z0BNaxTYNb45Y
         nVyDE1tFQW+9slqtTDF3V/Skq/GyFlmsTnd+NPvMP65JD7AcjVS7UaXDHe7vJrnP0AMF
         tzhcb+tb0Sk8ICXdh4yDcqOMfJMPBubJr1iiMGQGLqD2x1A76I20WPLdNkmrPJDJ5QID
         Qe0K4MzEiI9syOjgD3iHMWGrAiw/Lvj6KQzN+B1ccXbKOJmrfq3Lxp4BdZuY1ugN/PpY
         fe8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774641188; x=1775245988;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sprVlPGXU/l7BB3P7Z9OXglgjV345FzoAVG09a2hhrs=;
        b=FHWJ8Y2xzS3dG5UuEj2AsOvoHe65coLEgJ5gO+calHGABplVNmJ/WVEKIeo6nNps1u
         +II4piWktr7b5uksYF8reBYI1hCWNaOefpJOERb1EhiwD0igzWCNMIr5k7CWFLmeN+7n
         DGQ8U3f+NkkFt1fK4tUgDIDusRFcKbEzN6LaC19pIcDTxvwTsyq7ECoT5vGrBGa4cJVl
         nCEvrLCnfqm07meXsq4S3ufEsFoEb9MGGhoI8q5KtBhoFH13IGqHWEFfJxdgpe6AdB27
         R7O3MIVq3XBl4P2mrsyOydE7Y8MAw8kVnoRLwDkb+Fam8zE3dxBqeeDrJDy/aWYNZtyy
         6wZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBN/ZmJjXcHda4tO3lipETC40VPkhpJEJlVkuNHXYLIQYmxruPcQdEDJneo7g+l0AxjIkgcSvrBw==@kvack.org
X-Gm-Message-State: AOJu0YwgkfYuQOAtwIBrwjTJDlWuDxAqXi+mGyqS9Qn2fCz9fzHf0xvb
	QR3UZq4wepAdQ6/z2r6fdzEnS4KszSl/GKnVoprZAz2Su6lm2S8Rsrsc0vt5lL7F2DQ=
X-Gm-Gg: ATEYQzwA6SmSreyBZDRudoM5ujFecd7M4NN77z6XPrvduJIVsxweOQ15iPzL8DDanP6
	Fb2a4Klcl65IHN4mBe1EarIAorIo8K7c8DQHBhPY3uCV91TMIN92DRImUT3zKlVcWvJVKXigTjN
	RQgPCGLp69NV3Mb7ZhLy3SvfIObAsWv9TfTpDmsPo65eh8KjoFGhXHc6vYWfPvLAfJViz1msIUN
	rypOQNt6KY2Wp9KBu/YCgjSqfVcFopVAWexOBps7lRoIPb+AhLF7rSGhTnwxKcwPE3FUbiKRMwG
	e+Qm29TABfmSJIwSlRkqvBDgPraU3WwoCLjE6wQX60p/9LSpUs1kgeuCZhVvarg/K8LibkWlpoe
	3vcmyaFH1F5kMcGhANcqV33ASIVmXpKd1gevrSeweIdI7Xg+hJe+UVk9+qvPFhN39eLU7u3tJar
	zGOj+Qwjv7WTDPoonDMLOF01/copmTSpFx
X-Received: by 2002:ad4:5deb:0:b0:899:ea9e:31c2 with SMTP id 6a1803df08f44-89ce8fab7d7mr48646526d6.58.1774641188243;
        Fri, 27 Mar 2026 12:53:08 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf866653sm553286d6.35.2026.03.27.12.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 12:53:07 -0700 (PDT)
Date: Fri, 27 Mar 2026 15:53:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acbgIKuwDsPvPjdF@cmpxchg.org>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
X-Rspamd-Queue-Id: 5EFFBA0005
X-Stat-Signature: k1z7ksz11ibyhsgrwxsq5eid9gjjrxut
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774641189-677309
X-HE-Meta: U2FsdGVkX1+UiFFAcTwHe5EfocfsWNZ/u1tQFf1KJ1nl03RNWJrhrLUOPJL+Hh4vt2sMwGCmSDlhXBhXwtKjQrhrLqfTB48EgG4OHf5TxamlftzEwW4a/zuflVLIAcgNTHf1yQQodjSPEAaOyjiKJhsnHuQDrcPCyPAVgENG34FgArzZ6oL+dt549kYrLMG91EpYaWUkHPBKS0oAIRbgtP9o5JGm4P0KvOowdrAUfWwBVi1dN2QvoWOgfpC3abyiHONLWV4Uu5hPueHq9uF/+vhzjjWzfbKb1EABX8qdFjCTuEM1jVy5s6NYH2fxkDCzkTDK1MAocpO6yNytIyXXmARRY+oCz13o7FZEEdC5LxfVQTov7r6R/iRr6R60md1QcrSQVGcNhTWzfiRiI5y2zFhchgeaBLkkPTWIRFKO93JfHB2ojhkYZParysc/Z+W8kR0rLnrW4WVnLwWi1/doWNQqLDb7hXSAQ1uYjYRTf9Ytf1NzNkIoiUSSH0msELuWoDBTPDHiSTi2aqx3g187df3o6y1qljntveC6mQGOaLg345l+Pp72Obhp+D8GjqMC6Hu70ogL+uk/iac2XA0b0q+nT4WSR4XVbppW+5YXUHjw/O3eh1Gw+pMUH5SdO+2es2z113Ql4MJZlmOTrn8BLcEwMfwx4KU2zTt2RAeQa0tK8ipqewOCTG4oT2YIlO4LMfmHiI9SNnYELrdXaf66eTV6SBkmckhRb6KE0VY/oUl5igG/oSX+XGcu+zfvQ+zEwAFgq/6RonuMXbUKkE068TvKV3z7bak+JeGmyXZknvcel6wjO6bqYq8Ldw1n8Jzj+aF8Rt5aRHnAy7DeAeP5d2iTeI6a9TC6/EJWHbMsT5prDbyF6PbSEXDEzUfKx7BjRz0iSnRrLBadJt4UIMBwg2VoEuhdIDr7ZQL43pQhQfa2pe+lnQjcYjvxFMPkKtHzjyJI8pcAc3NOcbICwZk
 5HJwLLL0
 NPBlfRszhRsN240l/6bACrjaOmp3fHdchn13cSKMeerojZ9SzZec8Rfz9n3knCB6JIzRhTm4yUuyQ3D1Id0L83K48JU1qp5A+YWOrR+t2naSQ2xQPdc61YiUP1vgoxotLT20tBw1jzb21ppF3DG14lwekesnXJNyO+SJfnpU6zxT2xFLN0N6FtpywniVGzVSIBGzNpcJI8ar5Wlm1AjeWIPfJqCjJDPQsXWWOjuuYCGAg/2bVDsy7MUSMZc8AvvYiCxWnGYr0duwG7QIqvP8UnaQ3LoZ/q3XUdAFWuYBXHBnlNzTXuuAOiB3wOoLz/HoNg5EQyisdV81vtKRcrf0Q5goN1LlILdrDddYeYpbQ7iTOhjaa81Wo2aDWIY3hYM1Z7wAAtf3myqMRkKC7WejYjuFPYt8IKir0vQxF0DOtqmUKbM00f8ewOWDSIpF/Z6aTaURslH3AWq22Y92i4naQjRNutlODJovnwLEI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:35:28PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 10:24:28AM -0500, Gregory Price wrote:
> > ... snip snip snip ...
> >
> > > >
> > > > How Do We Get There
> > > > -------------------
> > > >
> > > > Do we merge the two mechanisms feature by feature, or do we prioritize
> > > > moving MGLRU to the pluggable model then follow with LRU once we are
> > > > happy with the result?
> > >
> > > Absolutely by a distance the first is preferable. The pluggability is
> > > controversial here and needs careful consideration.
> > >
> >
> > Pluggability asside - I do not think merging these two things "feature
> > by feature" is actually feasible (I would be delighted to be wrong).
> >
> > Many MGLRU "features" solve problems that MGLRU invents for itself.
> >
> > Take MGLRU's PID controller - its entire purpose is to try to smooth out
> > refault rates and "learn" from prior mistakes - but it's fundamentally
> > tied to MGLRU's aging system, and the aging systems differ greatly.
> >
> >   - LRU:   actual lists - active/inactive - that maintain ordering
> >   - MGLRU: "generations", "inter-generation tiers", aging-in-place
> >
> > "Merging" this is essentially inventing something completely new - or
> > more reasonably just migrating everyone to MGLRU.
> >
> > In terms of managing risk, it seems far more reasonable to either split
> > MGLRU off into its own file and formalize the interface (ops), or simply
> > rip it out and let each individual feature fight its way back in.
> 
> But _surely_ (and Shakeel can come back on this I guess) there are things that
> are commonalities.

There are some commonalities, but MGLRU was almost maximalist in its
approach to finding parallel solutions and reinventing various wheels
with little commentary, explanations or isolated testing.

For example, MGLRU took a totally different, ad-hoc approach to
dealing with dirty and writeback pages. It's been converging on the
LRU mechanism. This process has been stretching out for years, with
users eventually running into all the same problems that shaped the
LRU implementation to begin with. Yes, you need to wake flushers from
reclaim. Yes, you will OOM if you don't throttle on writeback.

There are many other divergences like this that complicate the picture:
- Cgroup tree iteration, per-zone lists to implement node reclaim.
- Divergent anon/file balancing policies.
- A notably different approach to scan resistance.

Many of these were not part of the main pitch at the time, but they’ve
created sizable technical debt that we’re now forced to reconcile.

I think MGLRU's NIH-attitude towards the problem space set it up for
running into past lessons again and learning the hard way, just like
with writeback.

The good thing is that there are some integration efforts now, even if
they don't come from the people that promised them. And some of them
do exactly the targeted, rigorous tests on a per-component basis that
is needed to sort it out (and was asked for back then).

But there are many workloads, many hardware configurations, and many
cornercases to cover, so this will take time. The end result doesn't
just need to be fast for some workloads, it also needs to be
universal, robust, easy to reason about and predictable.

Based on the current differences and how unification has been going so
far, I think it's premature to claim that we're close to deleting one.

And the current code structure makes it difficult to whittle down the
differences methodically.

IMO modularization is the best path forward. Giving people the ability
to experiment with a la carte combinations of features would make it
much easier to actually production test and prove individual ideas.

A nice side effect of this is that entirely new ideas would also be
easier to try out.

I think a good start would be to keep the common bits - "library" code
like shrink_folio_list() list and shared facilities like kswapd - in
vmscan.c. Move LRU and MGLRU specifics to their own files.

Then as much as possible extract and generalize functionality into the
common code so it can plug into both. For example, collecting accessed
bits from page tables instead of rmap chains should really not have to
be specific to one. Nor how the cgroup tree is iterated.

It might be possible to make N lists a natural extension of 2 lists,
so that the tracking datastructures themselves can be shared. With
minimal parameterization from the policy engines.

If we can get to a place where the only difference is how reference
data is interpreted and causes the lists to be sorted - you know, the
actual replacement policy - that is a much more manageable gap to
evaluate and argue about. Or swap out to try entirely new ones.

