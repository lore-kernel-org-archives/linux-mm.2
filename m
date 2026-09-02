Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514D5C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C700E6B008A; Wed,  2 Sep 2026 14:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C212E6B008C; Wed,  2 Sep 2026 14:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F9F6B0092; Wed,  2 Sep 2026 14:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3B16B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:38:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02605A034C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:38:00 +0000 (UTC)
X-FDA: 85169681562.11.6A6EEE3
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCCFB40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:37:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=q8xKpcHC;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788374279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVn0LX9ImSUgjtR/GVkbTBYzReYbgIL/PfeqeDfhMoE=;
	b=Mx+onxzESsZauFgMHzwikP7xbote8Z5EOOrT2GB8rbUiWCOzkUUpJmhZUFfVXV/DuIViDj
	lQayiDz4AzhpiIy5k7WgRIbbG1JCCvRNpw7PPtlYgTAFo9W6v4N5TDDRLa3cQnjplFWG+u
	fIVzo1AIcfBXiMGcZCadcdjYO7Ex7t0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788374279;
	b=n4DEpW3AdXYzjbAbKHHtgMJJswMUdfgVBO7qZMS0L24H9qxoO+wCAmCLR14EvMdG8lqGO3
	GDR31dFJtx2wgSkUooqIAUIVI6wj3spFwS3drI+nVlAioxorz2jMnmz1xVaFo1Zv6OZyN5
	j/8+2vXT9DhWSNgLBeriSiCzeielDYw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=q8xKpcHC;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66f78cba2e1so1634624d50.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 11:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788374278; x=1788979078; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GVn0LX9ImSUgjtR/GVkbTBYzReYbgIL/PfeqeDfhMoE=;
        b=q8xKpcHCrSdPd2OPLq+WIExo6v8VwJc9QHOGPMIrqSC6HQSxGs8XEOW8edQ0b2oHqR
         jKXdJuK+f6YBMcORwiOM7FLXLEFJNuZItyZ36XsUd/AAA9Ia5KBhdObSvTaS/Hd53+gQ
         q/lJW4F6HxnC77UmXSYvbMEYH9FaM4geXWpINCv3RKM870dKwwmJgJ4qR9jnZZ33uRSI
         HEhK9J8m63BcQnQ2iR+VkLEksRTvfKCjM/TbLDm6oIBsjnSzKHXzLNOO/JL6drVhdBzx
         7AKgNB4Usk4weYkhGCgtqhdr0p4L2jIykY4qK9ppG8tUEKOwLv6Osb+OoGyxLHNPTNQT
         b32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788374278; x=1788979078;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GVn0LX9ImSUgjtR/GVkbTBYzReYbgIL/PfeqeDfhMoE=;
        b=D3rvw4uoo5MKKrc1n8g+Dp+OFdt3apeLASHUaIOrJRmoy5P62AdTkHkl8KYJoRFwVo
         VZeT9402qUZnHPi8fxpWuBTAtv5MFUBTecjdj2yTnpewhZ11zAC97JLT3TinNv0sZJbP
         OkmZTOrfy6fC+KLz7xqxFMrRwp/SQxNb2KnWEF9S9N7XWTLCBdYBDpYq77uvvvftuzyR
         89pn0NjDOX6B72CKS3jBbv0xX5+V8ETF5IfdkNTxDKvBSOg3BeOWe0EjCbS4oTZ4goYH
         nhhhrBh7sNBQgTLPSteduoXCvWMdLI49UkWway867Gmvp2dZyRrHpQF2fYbkhy68DKzA
         xrvw==
X-Forwarded-Encrypted: i=1; AKwUvBwUoztLikR+jW4UY51LU0V63YBQGAfX+ihdGKgSpORWOC5nNW0/HiC6yLEcshJcvQLwxqrejt9Ang==@kvack.org
X-Gm-Message-State: AFuF++k7+4H9RWY0v6ZKxboWhBwqjO3ypMV6P4EMBtboyaY+sPQcc0Uu
	Fi9cBvzPb8/ZdocqglS/ujrWCnbxWI6Zw4/6B9TGuOD1frzFMYoG6DRM63+oiyUvP9w=
X-Gm-Gg: AYBFou0qa4erN39KeiHktj1aDcbC3QpXZsxMi6duf/9i3beioIK17XOnDOrOaDuC7LT
	laSSZJgLRGzoWKNV/ARqHGZHqluFcMr1yqxxHp2GudYsAFEdPNDPI1tz5GKG5GfjTzMVM31PeLg
	DECDZf9AF87m04byWnDfQlpjoWlgIc4JTfibSCm/bU+AGGXhWsYn/fScJT0jKWBDphV8K625Izp
	A1v7v3AwZNO3AA5sioTZ6W8ee1fL31rzJ+08YnhJ+3RHMBivb0Fq25oRGQsrurKONw+CQhHV7QS
	MKeeH8yZhzJQUEYPWLAyXUyc1dm/tu7qf4cORaABKUrX0zZnuoUR31Q4S71y4QdREmaxlEv6KQb
	XIn8imX4EId5IV5DvBtPE0aKVydx4MdwWDzlKRxCNCqoM7G7VLvXgixV/2z+WM6Ld528viws2vO
	+rB4XV3YPLGW91KzX6JBQCnB2bo9eniau9kI096AYraOccsyvwia7gLrgdFhYG
X-Received: by 2002:a05:690e:4388:b0:66c:effb:3706 with SMTP id 956f58d0204a3-66fa14e8167mr1271604d50.38.1788374277367;
        Wed, 02 Sep 2026 11:37:57 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c10c94648sm24094157b3.10.2026.09.02.11.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:37:56 -0700 (PDT)
Date: Wed, 2 Sep 2026 14:37:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
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
Message-ID: <20260902183752.GP3004@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
 <aphS2TancJAZLND7@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aphS2TancJAZLND7@gremlin>
X-Stat-Signature: 84pyu6azhosezy7izhbh6eg8w58yay1q
X-Rspamd-Queue-Id: DCCFB40003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788374278-161048
X-HE-Meta: U2FsdGVkX1/tZEg1SVEmj7HbNotNQYI9NW6m/9gaiDFDv7MZK5gNbFjbQPidndNLB/f2S4ao1VTzCKECPETRoPgGsZAFJcayBsYrRrqpFzAm+a7bSG0yEHa5iAGeLLsCnrHbIv7aPr9EZ9dIOfh9Nd7AZ+p+9A9zMHx55EBVh5YztxZdbTGXNZamMT+7OGZYVUVIfZFMLfTlb+dMUftCZY/saNOtvcRDdu+E8M9m0atiEJFfPTlmFUa9BxdGNpT/iGV1qpvo1ABKcg943xjtLTW+5yvAgN8PDbmyxKSU+yLy8Na3kQ9QX+GuZDrJTdMFK9ptNXfOcsQDvesRsmNIekj4Fp16VhlathHrbgp6e5J9HFiFX4eTXDaLf0Pggg2YjiPC9j0a6Pz9jlSguNOhDOV6bX631mA41hF3KQCIITt61gRcYUfL8iul6B6diydzJ6tdftkglWkWjoZ3kVcBmoqCrgqSdEUUTWIoEjaHmtFOHlNsgsf2C2hM5ma+tPwUbuhchUtAXis6L3pz3D6463744X16USXAkhqUKSIrmMrLnMSURL0lq/6Gj6Bg56OQomhnN/weaX9N/ZnRn1Fgr3xwhf6pmDZDOafU6lCdBhRWy7+K56QBXI5KSdqi4LBND5nIsdC220Y7u0Kxow5k0tWisgoY/Z6XBmAHo9BRjgHWIKwD6YyxiflA83Wn0emTle3rv1w8NdVrEpBB6Bl1kI4MNlTofRY6z+C1Y4NBKDEXlFTUIAPZ4xyr8pAIz0fQFTT24rzyi4zrRhfvSWU912jy5L3uRofuH0PKwaUcrFB+fbJ6v2qfqdS0uGH+m2BDQZhWCMZNGRGsMNaurjCR5H1cupcztGCO9S+zRM7BhZN6Xpd9PkxQzTPZs0iBsdJG1pQjEEPKMcfuP0Kk9xXowlZ4h9qeFJZNtyBFgRYJagGmPgNW+78DsXiZmuGIcwRdnARo479f/lBtXl37wOY
 G8DM5t+4
 vqCkRnS/qpYdLrxWEdaDFJ4ldtp3FjWlG2sUSBI1znPWH9MsYtg5b/FMGWG7QFB6M6XLnbimW+f+wcOanJA7oY6r1Ud8b32g9HVY9Fw8RLsme7icwb7HNiZWyuVU+eMUNhuBDUpry5IRH2kR5HjHhwDZr32ybgKPEk/7+xpasyLaN5FywXeeIsJ6Jd1AHIfBY9bBshoMifyJ4+8puPk42jPI/JrMkoksiXOaoB7yVlrbPpihzSaPLqVyvVQTH9/pcVu1dkCJwr+fM4WRfStyKXnHIkX8FwmePfc0MF7NYIcoQCfFDpwEtN/BEsPqPj2YO61oPmh7i3J+GcvuoPWQmAdTj/W+CAQh1STZd2qBZdyAhPA+d48+WYZPPm7LXr0JIABPzMFdJhqCV2SQ4dNo5CZPffc8ufXvEVXKTYoHwy/sUkEwt9wJUhsH/eJFpfazVoOpE99C5MBEwQAOB/GgMuWXIDGm9kiUYVVDh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 06:00:55PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
> > Just to summarize my take from the subthread with Zi: the premise of
> > this patch is to roll the regression dice on every THP setup out there
> > because certain ARM configurations result in a questionable pageblock size.
> >
> > I'm not against carefully evaluating and testing out today's need for
> > set_recommended_min_free_kbytes() in real world examples. But this is
> > not that.
> >
> > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Well you don't have to listen to me any more as ex-THP M ;) but my 2
> pence...

I'll always listen to you, Lorenzo. <3

> Isn't every possible change to address this kind of issue subject to
> exactly the same kind of constraint?
> 
> I'd like to know what not rolling that dice looks like :) or what
> constitutes 'careful evaluation'.

Usama gave some great examples in his other email. I'm not really
arguing to keep things out of tradition. But I think it's fair to say
let's at least test the common 4k/2M THP setups under memory pressure
before and after the change. Or be more specific about which changes
obviated the additional pageblock reserves, and how.

> It feels like in certain areas we paint ourselves into a corner where
> everybody's too scared to change anything until we're sure nobody in the
> world is broken*.

I'm fine with calculated risks, actually. A bit more surprised that
Michal was so readily on board with this :)

> And so we continue to ride the merry-go-round of proposals/rejections
> indefinitely.
> 
> All the while regressions in tip kernel are a regular occurrence (yes we
> don't want that, but they happen), and they are resolved as they arise.
> 
> I wonder if we aren't limiting ourselves by thinking this way.
> 
> Michal's proposal was that the original code was written _long_ before
> improvements in the compaction algorithm and fails to account for those.
> 
> It seems odd to retain the same constraints given the rest of the kernel
> has changed.

That's a great motivation to take a closer look at whether we still
need it. I'm not attached to anything that's plausibly shown to be
unnecessary.

But I think there are levels of argument quality:

1. This code is old as in time
2. This code is old as in the surroundings have changed
3. This code is not needed due to sha1, sha2, sha3 supplanting it thusly: ...
4. This code is not making a difference in represenative tests

The patch is at 2 and I would really prefer we get to 3 or 4. That's
not the same as saying we should stop making changes.

And honestly, while we tend to claim we want 4 for everything, we're
happy many times to roll the dice at 3 - iff the story is specific and
plausible. And I believe that touches on your footnote ;)

But let's talk about plausible. Because I'm reading what
set_recommended_min_free_kbytes() does, along with its comments, and
can't help but think that this still applies in the current world.

The compaction aid is/was always incidental. Yeah it would suck if
that is/was (still) an implicit dependency, but ridding us of that
could be a more deeper-reaching change than you would want to make to
fix that pressing reserves issue with 64k pages.

The fallback avoidance reasoning OTOH still seems cogent to me. The
mechanism it references is about passive fragmentation avoidance by
giving the allocator placement options, before compaction gets
involved. That makes sense in how I understand page_alloc.c today.

> Perhaps a compromise would be to put the ability to disable this behind a
> config option or maybe a kernel arg? Of course that becomes something of a
> uAPI... but at least it gives the option to constrian this for those who
> want it.

I can't force you to engage with the idea of capping the pageblock
instead. But I'm still kind of dying to know what the reluctance is ;)
And I apologize if I missed any prior arguments on this specifically.

