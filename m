Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1230CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CEA96B0005; Wed, 27 May 2026 04:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A64F6B008A; Wed, 27 May 2026 04:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBD56B008C; Wed, 27 May 2026 04:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1995C6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:41:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 915A78F36C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:41:16 +0000 (UTC)
X-FDA: 84812555352.24.39172DC
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD680100009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:41:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ExX7RzWV;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779871274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DS0Qvfn3wnYHQZFbMC98i7Jr1S1IM77hBEnuir22yHQ=;
	b=KXL522GQLyfP4iKOSJV8u1S+q5b+zweNefCqhubiyMg1v6d8wplgnvPZiS0k8K3a0evLE6
	cN6Q/8q/aT46O0okGe2TVy/aytknAU+FghQv09Og8ULPK1MxmD5NajQefdGt9fcm+lOTQR
	UxmYNzhjutmGZt1h2TJt12U0V+za1Xo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ExX7RzWV;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779871274; a=rsa-sha256;
	cv=none;
	b=ZHID2cul57yEekn2gyx6M3qBmXC4gHsM+T9DnZ5LdrlcmBsJycl3LcxKZczbnyPNgbl/ZA
	jKOn8ptePdpN6yM+sf9xG3IpnHMqXW23RSlrymLAMJVeNGgwF1+iWsNJwF5dsj0d1/W87X
	9ZwmdlngwDdBni7gD0OMGKI1UYqgVaA=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso97759675e9.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 01:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779871273; x=1780476073; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DS0Qvfn3wnYHQZFbMC98i7Jr1S1IM77hBEnuir22yHQ=;
        b=ExX7RzWVxJCvHUAY1HOYVSyn+HLZO9Dps5wepBbdSun4qEqmo3otPgLZchEVEX5crf
         hQCm8QE1EegUpRdGvuVUvfaS8DhAh9VxkXLAD4XmfR2o4UovLHzKNYnX5GgFUy3yx/5e
         5jpw4+jWHsKC+JXo4sSi7lzot1dQCy+E8BJPKd6CdHQJqJ2LTivlpkB7YWjFsv+BWJZl
         bbQ7OwJxWNMlHpE7ng7ryePoJ1Q64u5fzW8h4fncbJajTeBC0U6IO6S237+Qx2wsVT0g
         cGP5ihfXybTW+nn5OcsKzRhCkZ0qKqnTlhVK+5dlCr0Vb8lgHlcXkRQOEPm6a51MXTQ/
         LYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779871273; x=1780476073;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DS0Qvfn3wnYHQZFbMC98i7Jr1S1IM77hBEnuir22yHQ=;
        b=O458oLxf8uPzDdhsz9eIlQgwjL8773P86Bc0BNImKZQkf4RCpMbda67bnQIHXIbzeB
         sWDudYzOMhQNSri2vBCaKY1NcN3RihBQv4J84p+a+KgJCZqldiQ1jbCSe4AK+dJNcEYy
         J4iNn0WI3AKtV8AydZQq2eNQJuCeMV8y/sNT7+DhhRIgqRewAeGlmUO07nX29o97x2QA
         hvsLL9DbWOph/8ObfjpRO8FYARwVdVzTKcwgoqzWqdf1fDMlLKVPnVUrCxwGlrKi450R
         q6PqkX0aS6/Io5RZL4unCym28DAsXO3r3uoU9fybpdLDdw3Xthk8MARaUS4GV52YFO2g
         fR8g==
X-Forwarded-Encrypted: i=1; AFNElJ8BYIQJk1KBEy7MzO749PQsyW9dIr9AojiV4lmCw9HBgkI+AsnVkdXcLjC7Em90wZmtNNuINdhniw==@kvack.org
X-Gm-Message-State: AOJu0Yw3xuk/OyfzazpPHIPAVA+cpmyvIOOPGu1StIX7GgWZQkEuq5db
	b/kURB14xMPEF5euz3rfs7SArrvFujlGSTwgPFa0qSlqZU11m/ZbgPDZN9h95kMHqI8=
X-Gm-Gg: Acq92OFWClmXrPflWi7AIYO8ghMBMsFxrQM/Ut4E4bkO9w62JLME/peP+qB+bLQibav
	WYuZISaJzzlP9q5StG/hrswfUAVcygi8OHnZ2YXU1de/mhVqATjmVgyVDQKV0LOJ24qhtnuGHi3
	AqEIVI2M7a6U/skBFY8knbPkRBbflA2DPnejHie9wjr+Jsz1119WOmMvm87dcvabmOttsXBJvpo
	EOl9oytYrgLNKnHFwslC8/CzQKHtuNAAbrXIqOoJZ6CV/Txpbnh67Md/u6PvqkmVlrD/Qy+z3+c
	Lgvm2JpduuwW8mkyJUMDZxdqMQNrts0oi40rolVCMsUcZ7Z6xQ2hr8zLV9nRtj6XvJCyCH1Azn2
	DBsGYsjgT58vGoAw0TYLO7xZ/S7RbCilJkTZ0WBx5m0RemD6kFguREFHYJWG3zn0Kqddnvjdt/z
	c1Vf1UGNw60+wqklEZWpWUV6zd4TsApUBpgqaG8pwSVk0i
X-Received: by 2002:a05:600d:644d:20b0:490:3cb4:f1b3 with SMTP id 5b1f17b1804b1-490426c5a3dmr265077595e9.16.1779871273108;
        Wed, 27 May 2026 01:41:13 -0700 (PDT)
Received: from localhost (109-81-80-71.rct.o2.cz. [109.81.80.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454a0cd5sm472671585e9.10.2026.05.27.01.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 01:41:12 -0700 (PDT)
Date: Wed, 27 May 2026 10:41:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
Message-ID: <ahauJ9DAqBPnRi1h@tiehlicka>
References: <20260520204628.933654-1-longman@redhat.com>
 <ahQLVgj8zV4xQRh9@tiehlicka>
 <16b36b01-7da2-4ec4-aefa-f06216ec218a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16b36b01-7da2-4ec4-aefa-f06216ec218a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD680100009
X-Stat-Signature: rsii5rtnwed16dbhp8wqqcc77161dmga
X-HE-Tag: 1779871274-155566
X-HE-Meta: U2FsdGVkX19HF7LBQrBMoyJB8spt19KnXkcTz2s7Di/5jFQX5aiAtQrXLU03KBY5yz4iyOXfRYpdbT28KEZKRyXFTtTgvF7guvOGLQ4JUO9fOIR1VSn8H519jCng8Fw32RmVgovfH1vFyvokriT9mp94gE+meM7TJOkEqg0vgDFGq+zEAZW8TUhYfgzde09c4Kw95eBF2Hp4ciw9rENAeEc9nmBCGxKZ9rdA/jk8TF5ffVDrFh+Yux1CyxL1uHQzkQWI6XQsxMcfYz9vxq7YkgEoNau94bWr1pfc3b58eefRcZd2DRVf1ciQ9A0h+8bAlI0AuDbqqI5R1nL05dPXK77VUQUJSTGG3tX0uu5Uqi0ZltNb+7CjY5ZGBFNCtajsQyVtI45B2rrLf0FEkVxIVqln3YTfZzbCuItNwo2qyQpTiO1ypnk/A/RujJfTj4u+jsIlS8ZYlhuf08heOY6PCsTiE2C+wMcru+XQ8mRjxK1SHQFdoIUVKttZnCIRr8pe6j2gZO9IUSuMlLrqJbDrtVsZz54YrlilJBkUCJw3fz1aN8b3ClNsFUz8l4rtDyZ9/xG5M0JiMu0FK7YepJlLLqTLjocW2XXyL87F6Vlhyb5vbXiftvBLxQd+6Ms54ZAJYRPeTEjflw0+1kVdssL9+rRhWIGqSOfppx5rnRYct5gElmui7pvsjQEiWl7nD8zN2YGnjqgb+l4ZNs/PIi7ROVuL28Hq+9vk2VpfXthLtBGbBUiUO7aZ05V5rO//gPWWNGs5PIYRl0cC/sWkO+5ta8uxENgOFYnSDY7Ov0SG73YmD9G3vQ1UOiDikNHmYs/HsGr++dTBRjRO7cbULhVjS+Ckc4/jqdS3P93KywGZt9r/2KIjFs7y6BeHyQn/8nEqSTtJo+7Xunm0M2pbS5pN6hxWgZzk4arldvsMgfjXWWxdOEEg6Wy0ycZO0C7FlQFZk2GMp2QvRnM68w9sPst
 nNRQWzNM
 HeCu2EURGwxdPEiQ22MeKnxwdcgLtEY64+WyVlL+Oy7aS/n9IaKmKEixPQ0HQ4HwVqctVnatgNaOMt/dBrS8dmY2GkbcosmRd3GeCIWV6ZcikF7qKMBII5omR5MKYswg8Ozh/7nBY5kqI+tPLpc/XEQ/Co91SZQA2bw+gQTpFY0IX3yi3+GrR05KiMu6deocUWKf+d8iG2x4GDnusqTq+T2QkvAU9F1XfGzBODosXdupxjlLjSOtYQRy52GznLu7oXkmwySIhH4u8UA3QfoB0pudRX+mN8SnuQrmKxEmNMoO/bI1v5GlDsVDZBxfcPmy3mRaxMWy8nxDHmtRGGHYkNgll1KaX73eliSi/56kAbrTw7byAZGZwI4Z4S3vFfH++H1adFc75cqxoe2JuXz+fEEEFuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 26-05-26 15:55:09, Vlastimil Babka (SUSE) wrote:
> On 5/25/26 10:41 AM, Michal Hocko wrote:
> > On Wed 20-05-26 16:46:27, Waiman Long wrote:
> >> The GFP_ATOMIC flag is to be used in atomic context where user cannot
> >> sleep and need the allocation to succeed. However, it does not support
> >> contexts where preemption or interrupt is disabled under PREEMPT_RT
> >> like raw_spin_lock_irqsave() or plain preempt_disable().
> >>
> >> With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
> >> kernel, it is possible to allocate memory under such contexts by using
> >> spin_trylock to acquire the spinlock in the memory allocation path. This
> >> does increase the chance that the allocation can fail due to the presence
> >> of concurrent memory allocation requests. So its users must be able to
> >> handle such memory allocation failure gracefully.
> >>
> >> The ALLOC_TRYLOCK flag will only be enabled if none of the
> >> ___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.
> >>
> >> Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
> >> atomic contexts.  This new flag will fall back to GFP_ATOMIC in
> >> non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
> >> where preemption and interrupt are not disabled in PREEMPT_RT kernel
> >> like spin_lock_irqsave().
> > 
> > Before we go this way we need to really be clear we do want to support
> > raw_spinlock (aka RT) contexts. This is a big commitment because it
> > dictates internal allocator locking that would have potentially a much
> > bigger impact long term. I would go this way only after/when we conclude
> > there is absolutely no other way and we need to have allocator in those
> > critical sections. Now you have a single place which complains ATM
> 
> We already have alloc_pages_nolock() which uses ALLOC_TRYLOCK internally
> for these limited contexts. So the support and commitment exist. This
> just exposes it via a new gfp flag alias. But if there's a single user
> and it's already disputed, we don't have to expose it that way indeed.

alloc_pages_nolock is a very constrained allocation context with a very
limited use. That is quite different from something as generically named
as GFP_ATOMIC_RT that one could assume is a good fit for RT sensitive
allocations in general.

-- 
Michal Hocko
SUSE Labs

