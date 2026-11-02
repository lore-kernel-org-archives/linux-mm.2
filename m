Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD79C607BDFE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Nln1Wx70
Received: by kanga.kvack.org (Postfix)
	id CD28B6B00EF; Mon,  2 Nov 2026 12:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB296B05B1; Mon,  2 Nov 2026 12:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2066B05B4; Mon,  2 Nov 2026 12:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 962FF6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:03:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C4321401CF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:03:52 +0000 (UTC)
X-FDA: 85390801104.16.2B48ECD
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E05B180002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:03:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Nln1Wx70;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793639030;
	b=XJvZ1qY60prkOjsovqwdlHMf385c+IKBUu8cisxMtHuyKt0nVnDTgkVR537lOWqLAfNAW6
	B1YKQ0nPVY+JmSa2M2SEkp+uKYzHrRSfxkaEaBW0KNZeJAQsFfva784SyfLKzLgtjFZ3X0
	N143fZRKWgr6KqT5S/FxnubFb/falgg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Nln1Wx70;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793639030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKVeSOmmrsl8lwum3t0s5Z+f2k9HnKnqrEKpVB5PY4I=;
	b=aR9Z/EwnvRomSSLAKTKQDcBKGmrhd0g/zUxOr0xeLSBayhGsHbjCAbnol9FbFgzyzmQ7qi
	TZcn7+G4ayw+THg0Fhl498rXm+zwvyiunIOeAnCDKX6zOTyj1/Po2FM4kLP15s40ZbkTlR
	O0/MME0FNxizeYjpfEBm22knZHCPnrs=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1645502f8f.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 09:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793639028; x=1794243828; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zKVeSOmmrsl8lwum3t0s5Z+f2k9HnKnqrEKpVB5PY4I=;
        b=Nln1Wx70Xz9HId/F4pvFXqLTkPtL8nujXCdALjdaDCQ0p5P0oeBA8nXeoE5+xl9fD9
         mb+SWu+QiorvRHvx3ZbhoBccvSCr1dzWAZA18gUiMFUgwDkCvPce2QWWwOWdmsnw3k2z
         lqoKIz1MJj3WqY+eeC4R2m6ph6qVA6rq2EI+uYmNiVxTANF3x5c52AdC+2NxihT3MRbT
         DqFWwHZlcVm7Pm7BCJmqMUhkj2pGA59YRaEuW7PasHu/Tfjnbrg3zPeygDA3OO2zsCY6
         XZt7hUuDUqisIZMkgpRyKqTrq8BydgBnfCy8q9gFxMO6W6oUjQEusod3vkZ8fDI+oCov
         Mi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793639028; x=1794243828;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zKVeSOmmrsl8lwum3t0s5Z+f2k9HnKnqrEKpVB5PY4I=;
        b=oosqVSq3y8KTDpM9WOayjb1CQn4cbAonKropke3k/xLog75Ww6OAvBExd/sHHP4D2W
         lJJwCWFseD4shyVXWt7qxliHHqEXfSofFGZhC6tg03VyXovkd/hVoLt8atstJKeuWGMD
         6pmbfPUdxvSDFs2YSRtAqUL+9IrZg9r8ck9yfYJLVZczA1rxQIhvi2J8fKODdJaBJm5V
         W9ddYELXpPHoS1Ti6XrSI79uvtxBvOWmh3MUuknXdAEm+sYOXXV0rsBLOY84rQhsd0kN
         KIgvPBcIqtcOmVcKwc8Qael6inF7qrFouudkGiQn++NjQMq3U+wY2PzoFEjy25KRoIoi
         Dekw==
X-Forwarded-Encrypted: i=1; AKwUvBzuSch6O8CfDO9lL3CyLj/Ea0dc/UzYzuoFDrYSmKxGPPTLb5c2uzOkobGuckvqV2Oa+U+jAeZ4jg==@kvack.org
X-Gm-Message-State: APuU4Z+tqOfBLqQgW0gID8xUGulthTlFguDgOhcgHp9LlSld4IIKfMhC
	v9iA6HCFHkfX8SYG3/JvKVI6+pqX7LdVKxpHzl6wQz8yQMTzwfnKw7B97KUZz/bd15U=
X-Gm-Gg: AYBFou0WZAFJ8UcIE7DQ9qJ3t9DQc+sAIdo2PZ8m/o/vDW5xWoGpufUe81DXhB/v1wc
	kapJPFNfoAL7zshzbajIIb1G65skaadRofsDI86MMzlGNpJEYtDBC3+jc9lmEmyh8a9nnElKsOW
	CZ4nwxSTVI6T7bfuvJdwacLusyB6zYBv69IwNVgEW1fEUJE6/Z5c/S5oMBNNYC8zXj2Tt1oDAii
	Pn7cipMRI+BZioLNO4oZ6wAbpU05FPh4vydB1CD2Ah1y3ZRvtjicqfnd/U5DumOaR+CWvas4UfN
	mr0dFifeoPmKGL1bx42yy2TphpGYaDyepRGU6a52PDgsWyCyihKQBje80ghDMxjOZbpwXM+gOhs
	y+u18SmD7RDEm0btu5i60fc1FmBm0sovy6Rbr3GtzvYXjy7/rH7T56TZTFhmFVQgR7lt7nr+t06
	i1dizwWEYofLwZwqN33nloVM/wfP5Szz8k01uTEybcUQR64CAigv+TaqNuDVb1FdwBtvXdj7Kqd
	8wgKSiP7c7XjoyXzEtz/6145i97RJYli0SnOZRGXoB2m7gbF3IioOMWnBzEwfJba8HwjVivj8K/
	rLLOD4/ousJcpi/UxZdrGCJ/T8E08ElwgYA62/Y=
X-Received: by 2002:a05:6000:71b:b0:48e:68d5:81b1 with SMTP id ffacd0b85a97d-48e6e4fcfbbmr22771632f8f.48.1793639028313;
        Mon, 02 Nov 2026 09:03:48 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b7270asm21084674f8f.11.2026.11.02.09.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 09:03:48 -0800 (PST)
Date: Mon, 2 Nov 2026 18:03:46 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <aujCcqKKyio7oZ0x@tiehlicka>
References: <aui3TJqadHUv-4RW@tiehlicka>
 <20261102163014.237806-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102163014.237806-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: 54eswm683ydm717qoobgcdcjr6zun57b
X-Rspamd-Queue-Id: 0E05B180002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793639029-127384
X-HE-Meta: U2FsdGVkX18UN+8BUDaQNNgBJrX0YWIbm66GQsowX7nAr9UrywZ9kNBfemb0UET5uyv41KBH/GWvfPYqHljHJEy1JFrO6ZCvuoV7iWy1FfN3+GRnO+6e80F9NFdvy8cOcjlDGo2eTn0aenK3v4tOkWTf+gy5LvUW1UJF0dUBZsQ8Y8POdtowIy0oBuyczognJiG946DH0lWXGQ0cJ4TxGCOYvzfmhUgHlU9PDgmfltTamEG24IUEn52F9PNeGj1xC2AkYLTQIugMFOWoFX8Wr8i3n2UnRpUsczN3mK1gAcirPunhWj/sCkVGlutcwCcCEwWLJkbIzJ2qL9GMq2N04rITSyrfujd54nuUnSRdtcAuMaYCZYIwd6RIMUaGJAGmxj7Prfom2JLMChlfHE/M6LlCxIf7prshACyJOgZy89Wg4mPAKmNgZhi3j4iIhQTWgGqRloYAdA6b7cd34LZwEm7AdaCfz0piTMsE//QdDW4GlCEJUyvNxXTFm7wO6tVDxzsgq2fwfJML0+Lv/rU+7CPnGdozpFwC3P4ZV2cMPxyCIqvsVogVHWxM7PZV71dN5zevNRimGZUSo2tTKpwQ1DETQfdKuPy2MUoC1X54BG56VW0GnwPGXdxsiZeez3qxHrfVGuGMpXHbszJHh9xOB72wNc48IPkOWWicNoM1wmeJQBcCtF42QnXg9zagl4KRyuXJD44sL1twvpZqZfGXkxzt6uvltYm73EMbB6TQJ3Hu0l63DJLIIEjW5oaAtiRHVB+Fyyi1M7Gwcw2V3UEu7aeFLSkP5A6ZhH7F92JV6P0W+W2wMgLx7cD1u3XeB3KONaYsz0my0P3MwefwxuZJiAWQt569sCeX19umHHPyvLWlXxhQOpCWEYh1KXtfCm4zDNHIcmJRiQLb8lAd4ey8g7otpyh+44Pn4vfhfZPm0DhVCUbR595tGnS89/ErvKu8LH6yLHIt604RALbQOgp
 kuszwZ+b
 a29vOwOF2G43szXSaXU0T1xPnp4qqVtlKucEJGz6qNC0w7pbd8jDPi3z6QHpvHljhC9ZVL3tfHD2jM1a7AMSCq/lgMmFUO5YFFkFga7smAK9UubI68PMckCBXSRfkvQYKFd9VRoBdIyPhqn4GhjYLZbjVJu1HPI/LWgve1cKNbpKBVZmrIqJwY2Wxw3XKJ98geJ6hMWJXXVHOYLaa/EoiVGnMCjewiXc/LYi55ZBGFFdxlgUKlI99B4BTwXrV3usTzRwvPfZ2hpU7gDjVomDAPiVfVjZkE0YeHvEbFv6NZjjjSZxyB1XhjuK2iIC7TEtCa3C50tfL3jphXiBWyao9ThCithKSn2AWK8eSL877T5pNx3FqzS2mLPxW02DFfjU2xPx0R6hdxETQBg/JtWHPcPbM8IIM+Pqv9MWVjYwvFKkTZJl3RWMUISGvJeRD3Y/Y8T9kOC6q1k9QK2LcyQn5PGcb9zIdAx8HzQAKC83E04pPwyxPpy9uRay+dxQLSTDUeXP7/3ObeqZkr4j3sspv5AKVhLDvateIap8BkW/+7Rvq5Yal4D76eZo1NFi+UTiylVp9yJLlGNVpi/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 08:30:14, Joshua Hahn wrote:
> On Mon, 2 Nov 2026 17:16:12 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > > > > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > > > > > has all the stock management handled transparently within the
> > > > > > > page_counter layer.
> > > > > > 
> > > > > > This is quite a large change and I believe it will be really benefitial
> > > > > > to have some high level design overview in the cover rather than trying to
> > > > > > chase it in respective patches.
> > > > > 
> > > > > Sounds good with me. I can add the call traces above which should
> > > > > explain my thought process a bit more. Hopefully the problem I am
> > > > > trying to solve is evident there.
> > > > 
> > > > I believe I follow where you are heading. I am not sure this is the
> > > > right path but that is a separate discussion. I would focus on whether
> > > > moving cache to the counter makes sense on its own (without that future
> > > > work) at this stage.
> > > 
> > > If I'm being honest, most of the generic benefits that exist beyond that
> > > work were in the other part of this series that I got rid of to scale
> > > down the scope of this version. But to explicitly name the generic
> > > benefits, it would be unbounded memcg stock caching per-cpu, eliminating
> > > random evictions, (like you mentioned above as well) limiting stocks
> > > to leaf memcgs only, etc.
> > 
> > limiting cache to leaf memcgs makes a lot of sense and addresses a big
> > concern I had. How exactly does this work?
> 
> It's not a big change, actually. This was the implementation from the
> origianl RFC of the series:
> 
> https://lore.kernel.org/all/20260410210742.550489-8-joshua.hahnjy@gmail.com/
> 
> The idea is that you treat a cgroup as a leaf until it becomes a parent,
> at which point you drain the stock. Stock can land on the parent due
> to hierarchy walks, but I can also write another part to this that
> prevents stock from getting cached when a cgroup has children.

OK, makes sense.

> > > I think there was a proposal to make the number of memcg stocks per cpu
> > > even lower than it already is, because the author wanted to include
> > > additional fields into the stock that would make 7 no longer fit into
> > > a single cacheline. I feel like we are reaching some limits with that
> > > side as well, so the "unbounded" portion seems to be quite opportune.
> > > 
> > > But I believe those benefits that we would like to see are made better
> > > by this series, which makes the stocking transparent such that the new
> > > optimizations don't make the existing memcg charging code any more
> > > complex than it is. By abstracting away this mechanism, we can make sure
> > > that memcg just handles the logical charging semantics, and page_counter
> > > handles the implementation-level details of stock management.
> > 
> > Yes, these are all good arguments. Especially when clarified that this
> > leaf only feature. I have to say I was struggling to see how caching on
> > all levels of the hierarchy would work in practice.
> 
> Sounds good. If it makes sense to you then, I can fold in the
> leaf-only caching into this series to maintain more parity with the
> existing code. How does that sound? 

good

> > > Personally I am a big fan of how try_charge_memcg looks after this
> > > series, what do you think? 
> > > 
> > > > Quite honestly I am still not convinced this move
> > > > is the right thing but I would like to fully understand the mechanics
> > > > first. Having discrepancies among different counters just sounds like a
> > > > potential source of future problems.
> > > 
> > > I hope that I can present a good argument for why this is not as
> > > concern as it may seem initially.
> > > 
> > > My first point is that the memory usage counters were always fuzzy, as
> > > specified in the memcg v1 documentation too: 
> > > 
> > > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > > usage, it's a fuzz value for efficient access.
> > > 
> > > Secondly, the raw value of the usage is actually always accurate. It is
> > > just the stock portion that overcharge the memory at times, making it
> > > seem like there is a discrepancy. Flushing the memcg stock immediately
> > > bring the counters to their real values (like what happens right now).
> > > 
> > > Finally, this is a change that is only limited to cgroup v1 users.
> > 
> > Right but is there any actual point in adding caching for memsw charges
> > now? If you have a way to opt-in to caching then you can simply disabled
> > that for memsw counter altogether. Fewer problems to deal with, explain
> > etc...
> 
> I think the problem actually still exists, unfortunately. In fact I
> think the issue becomes bigger if you remove stocking for memsw.

Yes, you are right. We do actually cache memsw through the charging path
which charges both mem and memsw with the batch. 
-- 
Michal Hocko
SUSE Labs

