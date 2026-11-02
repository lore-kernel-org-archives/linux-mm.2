Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C354D607E0F8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Y9Qn7PJs
Received: by kanga.kvack.org (Postfix)
	id C887C6B05EB; Mon,  2 Nov 2026 10:20:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39736B05ED; Mon,  2 Nov 2026 10:20:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29276B0616; Mon,  2 Nov 2026 10:20:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 876BB6B05EB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:20:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F872A6DFF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:23 +0000 (UTC)
X-FDA: 85390540326.17.F2FAC22
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 332E9C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Y9Qn7PJs;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSGTZ1xgzqrwbhvUAaYmxuAHPwq3oOxMzrzwAdYGKgg=;
	b=7hH1w2j5dvpKt8rZfgsp/oEoETmBcZHDkhywfQo152iFJWmcXrSkG10nwBVpgyhUx08OJo
	7FSlLMvDqN7iTJHlvhy0Nb0LwQLzwa0Hw8ET8TBR8RiOPlpVQme+4N/bRQr4rtw6mUwglb
	HJDTOj/hlIuy+4Cxvxj095ZND2kGAxM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632821;
	b=JFPtqqq8hO0wCN4OU3/ApZjOdH/MNmHGJj6/MXBxIVz8PhuvOgoKRbc4tccsYIM25xmxzM
	9m1tqkpxb7vhCHUuD5w2TYLwqGLcbAtNkbQ5yCxLwsZTVsrnI2rrqjAQSEAHn3v6shLljV
	Z9cWa8X6L/d6zpGajh1TnnitdBa4Omc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Y9Qn7PJs;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8b0e21048f8so25411017b3.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632820; x=1794237620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sSGTZ1xgzqrwbhvUAaYmxuAHPwq3oOxMzrzwAdYGKgg=;
        b=Y9Qn7PJsZs5XsIn21TdT85ZMpK0JkHcnAEOkR7X7bTs9EjptH5uCTTu7yvUFu0GTqT
         Db5I1omh1PXVROJkQL9redbDVtiuR5js+E3K7gEnfIBxC+/L2fNALx1HRA/glnmVk/7H
         GaCjMXzwBZx31MX6t1/AZPtviIKrKEIY+UKqui9KU087k971daMWNzvtpEDtB1mVVTvU
         CWotjfkLkJzqfcdDDIbp+IC9SMrR3GakJiXEcaUZ28YalMP91NoaYoI4obGQXcg9MsiL
         hbdCJ3FgE+MTzyBFn5iTWj7GxOvn5pRpx/9MWL9sMvl/lMWKLrknCfmpVWSEiTjdL255
         wpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632820; x=1794237620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sSGTZ1xgzqrwbhvUAaYmxuAHPwq3oOxMzrzwAdYGKgg=;
        b=iwh/gtTB6d73w3w2lmEPwF3d3Fdn8Z4ffM/CPtlD32G0eReKxE8Gvl1yi4iknPyTTw
         nHEl1qlrYYtGeKeymmVD69cnlk1Nie/zWGxA0CqtpO9RImN50g2Hsj5trj4ZODI8s8Nd
         x0ax2Fy3adVpdY1LU8qUJkPp9pWl/tXvcn6uwfEoGEGCwqXDUz3KIjbds5p6e9F+v7ba
         3fPacGSkNCKreXavn/YuwFU1YusEm1zBKQFSP6dusMISgbCBIxvgjlK2rjE42Ge4mER6
         gXvLzr9wSJh2ADmHu5dIlU7anvY0VMW61u6Cx0DY4CZnJawf7uPkdlJA0yaItpf0gJ33
         d+HA==
X-Forwarded-Encrypted: i=1; AKwUvBxARsD+jqSR/vZHNFWcjR6BOf9wkQYyUjOzrf7lI2BPH8Qx0M0fewf9fI1zRLjNGpblk4Xk+kNRqg==@kvack.org
X-Gm-Message-State: APuU4Z+00ejKl7WJZWaN/y+ShG1SFcddnGqynzEtPHZT3ivpuXPyel4j
	zjwEkiFrVMxTpf9oblR/+KTgNDKZBKCcJmXpcfMqwW1zE4wulR9XSiKM
X-Gm-Gg: AYBFou1q9+tnanQqrsTkO/KmRNb2d6u3QVqM3ITQ63SDy+A/qzCP1x/K8fF/6Lu4d49
	6KkIIH5+XB1MADgHlMxY1nXjLm3ttsGOSpcjLwKG2xAUe3/O8s24gOaFmZ+W1fNBKqYZwlTfqmh
	cCXCa877jq45TFY918xFzjDZHIhxc8mkau0isNtDLAFBl7sGacDZyRXC9dp1DLNOKDRncGNMWtF
	YQolMa2kppEWcAD1iMl6wcjtMupd7B0wCYP/HIXUdQOWf+lY+FjrWuC0AcnPao/2B63Aa9WvZXr
	++RaPMFIMePoEi2OHSjrU59iV5MKuaGAjUp6ZMPLfQp6j2EGztMpdAdlY1bKSDQvGC75j7vAlSA
	x4fFUMAg1T0nr0kwOOggF+cLNmxy47zVI2b3N2JHmADlfEuZKn3oB5V/KhRXZd5Sr4xhglc5Mzv
	B5BsjRJPytHH+tb6jQlZrl2zgz+8mIpLlv8rCrzBsgP7LYIJb4AHSts/7kkBw0ceX/dm3m+KUwk
	oPlEx6NpUAh1PEH8TuDDWnUJuyOcGjMUvY6ObMRZ/j7K9iRlVNx9jMGP1uFmMotonPX+gyhORgC
	V95cD3sC5Bsaf3+ba9pcbqyp7/V7Vg5yGjr/xoeg03LW2dFZ2EV8x3PWpnN7
X-Received: by 2002:a05:690c:6d81:b0:8ae:ed29:c4c0 with SMTP id 00721157ae682-8b2b682de50mr71858797b3.66.1793632820195;
        Mon, 02 Nov 2026 07:20:20 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7123dfasm55131787b3.10.2026.11.02.07.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:20:19 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
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
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Mon,  2 Nov 2026 07:20:17 -0800
Message-ID: <20261102152018.2773572-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <auiBOBfRIiup8Aob@tiehlicka>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 332E9C0005
X-Stat-Signature: aj8c8nxmdc5h3xwzphsp7rk3ncxba1qx
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793632821-343784
X-HE-Meta: U2FsdGVkX19Yv8HumekWH6BwucPhxin7Aju1/Bj5z9S+alTLzW74KlmVrTcKn7bybxpI/8s4v3Hhx6Mh1Z3J+dWPK09dHS7DyxpnlAe9ojAyQKKw5UcHZBQGGNAk0HLWmLLO9Ge10aoS8K0eq+t0xAqyQG+oq6KnaouDUirhaY3YqGsvbbhKPa9IijU2T0gUXn5DPkysVLdg0xA6VG2CcvdUqQVVyolj2bTY0ESIWnyQkwZY5xPyORRN2cQ1aQvrH3wCEf/GQIgEZ5jlV4OTMDhuB8l8nWLUhfx5vMYEYiUY7+ZdF7bwF4D2hJQ79K7jpocM1jbHnwE2xSW2zHIriZz9GJIDuLg02yoIv/zPMZfobr4Q5TpceKTxGGRGEzg22JU7tM3EVkXQ4rsqa3PEXpkk6HZZ8BM0fCZ27+pZUvprdmpOo9CaDKPhvpJ0bLFxVNIRWMRRhT9ostHS8/gI0m4wJcoBQFZ3mSWaBvqZGJaCyxzo6qx6b+IjF3ImRueKertbj70FFUSy6znCg0IpuiJDTxBkKHbikc5sF5iwTSdM2PCdiYtJEucF3itKV+fewRsg8PlAMRH/nm7p05Dc6YA5uAjjVnu84ZfN7eI4+V66rBpM4yCx/EEBUVZhgC2TKa3TMF6l8lxOUs99+1SmLlSNSEAwRoXP2h9/fFew23YxV5BEs94sk6yMSFzGi3X+9SBYby5/ldE1aK572J30TFs15lC8mddsatjawlJ4uJkGg10xiVJBX0WNnhMoFa6wLS1dcYabs0/74ikeRP6ggub+f591Odg8oITRqHZHW224QNiVpdsyL6aCo90A/4rSJ9TAZwWisOOrxdXVmMMnmLAyn8/CtYk8Ev0MibliDc1qWe6CxUxQYb354R4xDun/J9UjkMfrN9zZhgfPWGbKxEQ2OpG5GpVFUwA++wqs+fpkf5KNyOBOc4IICV2pfenlTtZfhTQFxIUqcwSCD+C
 vIS2fb7n
 vpIgmdcMFsM7EIvBmeRGlhql6EvQMF6256AqubjlT4gkS1dmyW1R35fCaXYIxqz8044euoeew6PAByvreQAMgkni6MBu5BhBZx9yVhhbHWGKdxJmLBjBA4cnXWNq3BZghxr1mMS4FTYTaehN7D3CyvbVUSFCE36Ii6f/vLPgQQdhymcx0+jAF4N31a02UEuPbLxl2w0HfYBXfX9UQ5eYdUt8RrMd7tbNd/dFHdi8dJKIG0TrgfjPU0UUTTi8lMJO/H80J0dddQPuJTm1G11jNP49MHmmw/UHjPHqrUvAZHQOsRCH+T0MZOclmgow1gymsKcI6AQYG1EgrfIcQCvRSaJvBsW1MTCMbJs7XANIgAo4zz1q7mSruLMSMYzMLS4UHLa5xSHoWE2vl0fEkxDhuPtFLe6wTNCwN+i/90nSKeX0sQco3dyrEeqVk0OyhxpzsjC3/v0bySlVKZfWPH2ssXvTwTPZyTfNQpQ7PhsWQFS8scG3qrB/AordmebWDtuApxKzRWFhILvyzyhnkfxMYT3ThcgdtdIc7nEvNR/W4bQE6AwSL0B5/A16l0E8mV3uuVL0wLnj5WRLbB8Zq6alYFmGDi1KR0GQ5m1/EqCI1K+JL8yEo7GKFT558LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 13:25:28 +0100 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 26-10-26 08:59:37, Joshua Hahn wrote:
> > > > To make future page_counters scalable and performant, move stock from
> > > > mem_cgroup to page_counter so that each page_counter can opt into its
> > > > own per-CPU cache of pre-charged pages.
> > > 
> > > What does it mean that each counter can opt into its own per-cpu
> > > caching?
> > 
> > So right now for cgroupv2, there's kind of a 1-1 mapping between
> > page_counter and memcg. I say "kind of" because there still is a
> > page_counter for swap, but it takes a completely different charging
> > path (i.e. not try_charge_memcg).
> > 
> > This means that currently stocking charge for memcg is equivalent to
> > stocking charge for the memcg->memory page_counter.
> 
> correct
> 
> > However, one of the series that I'm currently working on [1] adds new
> > page_counters to struct memcg to track the usage of memory
> > per-memcg, per-tier. The goal is to (1) track how much memory of a
> > cgroup lives on which tier, and (2) to limit the usage so that a single
> > cgroup doesn't use up all the fast tier memory alone, and shares it
> > fairly with all the other cgroups on the host.
> 
> Right. I guess you have layed down your motivation quite well in your
> original cover letter.

Thanks, Michal!

> > When adding a new per-tier page_counter to struct mem_cgroup that gets
> > charged for every memcg_charge, I cannot use the stock fastpath since
> > the stock does not distinguish where the memory resides. It would
> > essentialy boil down to this pattern:
> > 
> > try_charge_memcg
> >    \__ page_couner_try_charge(memcg->tier[0])
> >    \__ consume_stock()
> > 
> > Where every path still has to do a hierarchy charge to the tier it's
> > charging to, whereas this patch gets us:
> > 
> > try_charge_memcg
> >    \__ page_counter_try_charge(memcg->tier[0])
> >           \__ consume_stock(memcg->tier[0])
> >    \__ page_countertry_charge(memcg->memory)
> >           \__ consume_stock(memcg->memory)
> > 
> > So that we can avoid the hierarchy walk for most charges.
> > 
> > I'd be happy to submit a new cover letter which better explains this
> > idea!
> 
> I guess I still do not understand what you mean by opting-in to the
> caching.

Reading my original cover letter again, yeah. It does feel a bit strange
to call it "opt-in"... I guess I just meant that not all page_coutners
will be getting it, it would only really be the memory page_counter
(and memsw page_counter for cgroup v2). I'll change the wording in the
next version.

> I believe you should focus less about what you plan to do and
> rather explain what _this_ patchset achieves and how it works.
> Also focus on describing why do we need to keep caches on all layers of
> the hierarchy.

Yes, I'll do that. Actually, this patchset is really quite limited in
what it does. I actually explicitly tried to do no optimizations or
behavioral changes at all, this is mostly just a clean-cut code
move from memcg code to page_counter code. 

You may recall earlier versions of this series did a bunch more stuff
(making the stock scale past 7 memcgs, dynamically allocating the stock,
at some point I even had a version that only cached leaf cgroups, etc.)

I got some feedback that these optimizations were orthogonal to the
movement of stock from memcg to page_counter, which is why this version
explicitly does none of the fancy optimizations on top. It mostly is
just moving code from memcg to page_counter.

> > > > We get an added benefit of simplifying try_charge_memcg(), which now
> > > > has all the stock management handled transparently within the
> > > > page_counter layer.
> > > 
> > > This is quite a large change and I believe it will be really benefitial
> > > to have some high level design overview in the cover rather than trying to
> > > chase it in respective patches.
> > 
> > Sounds good with me. I can add the call traces above which should
> > explain my thought process a bit more. Hopefully the problem I am
> > trying to solve is evident there.
> 
> I believe I follow where you are heading. I am not sure this is the
> right path but that is a separate discussion. I would focus on whether
> moving cache to the counter makes sense on its own (without that future
> work) at this stage.

If I'm being honest, most of the generic benefits that exist beyond that
work were in the other part of this series that I got rid of to scale
down the scope of this version. But to explicitly name the generic
benefits, it would be unbounded memcg stock caching per-cpu, eliminating
random evictions, (like you mentioned above as well) limiting stocks
to leaf memcgs only, etc.

I think there was a proposal to make the number of memcg stocks per cpu
even lower than it already is, because the author wanted to include
additional fields into the stock that would make 7 no longer fit into
a single cacheline. I feel like we are reaching some limits with that
side as well, so the "unbounded" portion seems to be quite opportune.

But I believe those benefits that we would like to see are made better
by this series, which makes the stocking transparent such that the new
optimizations don't make the existing memcg charging code any more
complex than it is. By abstracting away this mechanism, we can make sure
that memcg just handles the logical charging semantics, and page_counter
handles the implementation-level details of stock management.

Personally I am a big fan of how try_charge_memcg looks after this
series, what do you think? 

> Quite honestly I am still not convinced this move
> is the right thing but I would like to fully understand the mechanics
> first. Having discrepancies among different counters just sounds like a
> potential source of future problems.

I hope that I can present a good argument for why this is not as
concern as it may seem initially.

My first point is that the memory usage counters were always fuzzy, as
specified in the memcg v1 documentation too: 

usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
usage, it's a fuzz value for efficient access.

Secondly, the raw value of the usage is actually always accurate. It is
just the stock portion that overcharge the memory at times, making it
seem like there is a discrepancy. Flushing the memcg stock immediately
brings the counters to their real values (like what happens right now).

Finally, this is a change that is only limited to cgroup v1 users.
This entire series actually has no effect at all on cgroup v2 users,
which I think is a nice perk. Obviously I'm not out here trying to
make cgroup v1 unusable, but I wonder if anyone is still using the
legacy feature.

I hope this wasn't too much of a brain dump on you. Thanks for your
feedback Michal. Please let me know if there is anything I can do to
clarify my intent.

Would you prefer if we continud the discussion here, or if I sent out
a new series with just the cover letter changed? (I don't anticipate
any code changes, based on sashiko review or anything else that I see).

Thanks again. I hope you have a great day!
Joshua

