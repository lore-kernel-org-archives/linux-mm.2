Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78A2D637A1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DA36B0088; Tue, 16 Dec 2025 15:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4F56B0089; Tue, 16 Dec 2025 15:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE876B008A; Tue, 16 Dec 2025 15:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF286B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:11:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B06751A07FD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:11:31 +0000 (UTC)
X-FDA: 84226429182.19.4C172B1
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B66C4000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:11:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OytLCjFb;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765915889; a=rsa-sha256;
	cv=none;
	b=ivo40cIJ8qrxaPDwhAFViuYMk3W75PxkP535pndOdNDm5l7bBqHLiUmVOEi8NN2k89a7cp
	RxlN02ilkoWbG/pJJ+4yQ3KJa3/6nzDKPWdKO45PIpwteZ8qiIbBQsMs3Oxeuaa2U6FONP
	pAqSm+kYqEbwNwhfWkvmBroNwqKLzJQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OytLCjFb;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765915889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2TEZOHQjdAzpbHmekbmLcKEsQRt3befpNWglQK9S6E=;
	b=Z03ARQO+it30bzYMM702HaSEgbdmdRwlEUzpQsFia0/crKbem7TBHfg6LqQ52Eo4qBDO1H
	izSUtHiZMA7ub/Uincp0OMgJ/04LFuj3FxL8v14tIvnqFtU7uopHufDHcJ0Neh8JREcngc
	8HT96alLHqX5O4bsPQhvM8tET9WgTWY=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8bb6a27d3edso354797085a.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765915888; x=1766520688; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u2TEZOHQjdAzpbHmekbmLcKEsQRt3befpNWglQK9S6E=;
        b=OytLCjFbL5MzLrc7qkdg1eTUiRQKxvJwJnR1Ilg4Xn3LD4SZcMZpvj5cdWS2tCCopF
         Pnhk45e+LceKJDRX38Mrxw9KVilfHkMZWMsqM7goelSsvVAFTS7jMPEy0fs+Qcr3VRNm
         YabuTObAhjUdGYfiGQOW8BH+z3uVFiFIK9mlqO481sIFD6NiVfp+gSE8ewYroaVV7X9N
         5v9TAdXA5V64azMSdzk7RKmbdgO8uUxJN5ouuRtX7XoS4qLHh0Y4bwiH02e4LWls8UpO
         sA5iHHXOxJmrj7ssr+edXDq4xzKKAaEWBJvfwZNWJK4waBrEcf6t6mxFE7ksEsjrKlkx
         srdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915888; x=1766520688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u2TEZOHQjdAzpbHmekbmLcKEsQRt3befpNWglQK9S6E=;
        b=f/UqdYxKkbrGSOi+OadLwRnQtuPknptJTL2tS69+/jB7PJIrrG3J4cRlf8lHwm1vK/
         GIG4C+ri9t3x3NF/ODof16hFf+FZE7kxWSugdXywcb4aAE6/Z5TszJpSsRmjcXxREyxt
         GBnZkw3Gn1XCHTGOIbIwzlnMgCKmdeO0CWg/RJ/3Niqfrr+NkeQ5U+4l8us1+8+u/f+w
         0qglwxDq0EY7sjLQvB+ZhCt40NYSmv3GSVOVIiIGz4LDeuDJibtQ3PglS0y5ri8EKH48
         f3f8ivXBy3dcwiyRpqmIpeq/cicGUI9t+uVaxX4xVPp0UtSjzzIpp7IPh8uJwqXu0H+X
         kWUw==
X-Forwarded-Encrypted: i=1; AJvYcCWXN0GA0IFDBJqJR48aeD/ITVx3IgSGNcXxH1msQNK2GHvZoSpkB807rd19UJs4/xxYrI6oALIvYA==@kvack.org
X-Gm-Message-State: AOJu0Yzk3XjJAECOo8+exR4BggiUpjrMeHklX9kJoeu2kgcsOqZX0M1c
	3KAdFqcvo/mOr1xK6RICT1bwHP3plXB6M0XPkbnU9mOX4eQXkTbwEwjlIrVXvTECKjQ=
X-Gm-Gg: AY/fxX4PuCBc2u/ELAf2+zoch+R2hK/hjj64sDR7k/70JalJmzCP9NoQ6785zONwSV8
	bIsOL3PPIFOind25V4BH8CjYWtSU9VKNi2mtvki+30ql6LO/O6Lijhh1ANsp8OvLlcpOh5+H9ST
	GoAMqk4Iwl3Ja/TPBOFuvJEDaDYYwTSMV+qNlT/oW+HWDvn3wWgMJQ3MOY1BpVVX1iKSKoVio+F
	2gyZZUm+1QsLUDr9ZfhthC3Ysl0s1nvbQ389iSAah8d+io/1FpXCnW5ywLvnzd55nEeumBn9tnS
	H0rgKsom4NIG0GwZn/LBHTfPF5h04tPPhvg/9bhTVEayLxgjpAEBHLJB1UH4rDuTKVkCIu4F13k
	SYriRmlVgrdByGlmHhEbK74ST7Qb7VphSpbNdUOpewOOjBS1XRWSN8SlQyFb0g9lXEOB3umNwHk
	PTe2Sc63kEIA==
X-Google-Smtp-Source: AGHT+IHtx8JdCdZWFi/hKtoiZ9YSBqltx9FoeXoqraRfIaoEydTQM97rKBnnZognyMwARXSP5rZp4w==
X-Received: by 2002:a05:620a:2953:b0:8b1:b2ed:2735 with SMTP id af79cd13be357-8bb3a27620bmr2299783185a.46.1765915888359;
        Tue, 16 Dec 2025 12:11:28 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be31b669d1sm249499685a.46.2025.12.16.12.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 12:11:27 -0800 (PST)
Date: Tue, 16 Dec 2025 15:11:23 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] mm, page_alloc, thp: prevent reclaim for
 __GFP_THISNODE THP allocations
Message-ID: <20251216201123.GI905277@cmpxchg.org>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B66C4000A
X-Rspamd-Server: rspam10
X-Stat-Signature: ogdfknho5kkia6kbwzfwfrqxpzpd99fz
X-HE-Tag: 1765915889-534455
X-HE-Meta: U2FsdGVkX19QddopTjwMlHPEruma6M6zPBfztjaiQ1FER6Yv6jP8zdb6ttLVFEfSDsXAxJGdTnNZqHP+y/dkf2JSBiJ4oHj4ALa4khifDKT1ueeSfgytJesvMmRXEqYvnfYkxJNWyeFz9hJyZjz07TrwOFImTLyDRwr/KuTTVbqNkgnpngncJGyGvjrtvBTuGYE6uyZ15p5EkK3REd+X2O57BHW6Jtv4fzAdrNztuzdjQ/HJbuvX0xZRyzMEiF9i2CJttrLhVMienaebY//WlHn2Sv/ZbOMOOQtlBDx1vmqU+g604QnyVy7Mjv/sy6aRNtdCxoxIaRGekX6I8jvIz1QR5ObKk7EXmNdUexvfOEm5ks906rAe0KC2eCP7VJ1ESpP6xF/r4BlDUARwgPH8TOXd1xdLMrV9OQc+ySGNihkKmfeZ681iWYPk3yVysL+eiMm5vDJz8AkkyEy0gICRnoBncBIBLugvV7ZMNX4uTnZhMtZRFzcwsY6YIb2qjc2bsIpFpi33bapL75+64LyjAJvNCDnfe2Yviy8zCSPdLko1XnaeBPUOqQh8rgdvW4p3i30sPWWvfYc0+DLeZlC4uPMfOS0IFOHlWke/vM7UaOuHFmKgGySO31l+t7DF/bazBiopbI8nOgdheqK9cVkyz2wBUiNvs0LVlKlRzwo2/0+A+1OhWhcbbugq/nDJcshHcvjAF+mGZrRJa73SMZpBHGj8AEo8HIcR8c0rQ6vA/XUiw/t6srr6Bs4pbhmeEHHoysqe28QkD1bTBbJVYhMbqfUCidn97v1GVcbLspAfIrG673fBwWJL42ebkstIN6egtPSEEf+h/C0y3Qoi3hlmJlR6pnsvkhQHrfoA02J+venHvFTRA/YV0rka9v4REwCSOwS3EuND+PaysYnOHq3+ruOQ2+jEuyZwD2WkR9Oj0e/Peg7GOepqnnbxQH7gd9zVm/kz5jHw+lPNCNw8PSi
 J1SEJXf0
 bK34/jLL+zXdsbIT16amUWZOH8CaOAgwy5SLDB/xv5l7DA26IygK+OfWQJ8wH4n3yIvvxHSUz8de7ErNYpV1GA//o8ayASPRx9KbWSl888qDzVXmI2ZbaNsRfhwd5bU25PSAZCCO4WJmxrnCQp1XyuFzcCuxZk2FePi7/p5nOtmscCQ6vNEgvriLDrgINc0/V4yKtnpH3Y4gn7RZT7krTMeyG90Ksuy0J6elTJN8nECV60xf9Z8SKmYvaY6IJQ1Y61PEP8ZDp5y0mBBDP5awVk1Hix2ZiyM/GLE4a6U+nhzPsNOvhxpzu7vbIZX+SeRuoEjKRLXwwotXjcP2bLIzgfQAK+DOpeqTpv7aXuabSQp/OZSi6NDNCwFXM4JnRmGcWJ+YQvwlBLcA86vHTe4hBNFwFOpsffbbJn9pF0xOywYku+YeTnQRehrHVbg3COzJo8IdKStZLP0Eo6ao3e7Hzcfgi6zm7GM926JGSo9OBTR6c3VuooYIDIIQeW2QV2CBXe/TYhEY/OynsYx6U7N1q180PmfChiLZxsXrs5+bBY72Bbf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 04:54:21PM +0100, Vlastimil Babka wrote:
> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
> local-only and all-node allocations"), THP page fault allocations have
> settled on the following scheme (from the commit log):
> 
> 1. local node only THP allocation with no reclaim, just compaction.
> 2. for madvised VMA's or when synchronous compaction is enabled always - THP
>    allocation from any node with effort determined by global defrag setting
>    and VMA madvise
> 3. fallback to base pages on any node
> 
> Recent customer reports however revealed we have a gap in step 1 above.
> What we have seen is excessive reclaim due to THP page faults on a NUMA
> node that's close to its high watermark, while other nodes have plenty
> of free memory.
> 
> The problem with step 1 is that it promises no reclaim after the
> compaction attempt, however reclaim is only avoided for certain
> compaction outcomes (deferred, or skipped due to insufficient free base
> pages), and not e.g. when compaction is actually performed but fails (we
> did see compact_fail vmstat counter increasing).
> 
> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
> which is not the intention.
> 
> Thus add a check for __GFP_THISNODE that corresponds to this exact
> situation and prevents continuing with reclaim/compaction once the
> initial compaction attempt isn't successful in allocating the page.
> 
> Note that commit cc638f329ef6 has not introduced this over-reclaim
> possibility; it appears to exist in some form since commit 2f0799a0ffc0
> ("mm, thp: restore node-local hugepage allocations"). Followup commits
> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
> may not succeed") and cc638f329ef6 have moved in the right direction,
> but left the abovementioned gap.
> 
> Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

