Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F29EEF311
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 07:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070126B008A; Thu,  5 Mar 2026 02:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D706B008C; Thu,  5 Mar 2026 02:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33F96B0092; Thu,  5 Mar 2026 02:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D30526B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:31:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 688781407F8
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:31:15 +0000 (UTC)
X-FDA: 84511188510.08.0A99EBC
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E13EC0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:31:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TCZ0oV6L;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772695873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifmFR1GOTxpHBh+4VdUvlVcXoIBiFw8BOia5QYersWM=;
	b=ixivmnLL6XxGOUgIlXheQRxEM0Cbk8gpE+dn9uogkLn4SXp5ibqG1onXcgV2CgG70e4dzQ
	zmaFrglB7ohmMNA+1yJafUWc1W+Y0zdpqhpCd1d7S9bzyZaj+AnR/PsppOtSHBCCo+Kpmh
	nEWRq9ptMRUfBneDdFhzUKUs8XPhyY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772695873; a=rsa-sha256;
	cv=none;
	b=JkICK6fo1Mz6LuIp2cA5G12mulzz6ZSMgOoqfMPSgzMJ1h7/P6xSon5jqllm22y+RuPR24
	uQZHGA9+J2HBXCVGdIbmdoCgu+I0VUR+h8bP8PY/nzr1gANkwplQfCN1t6orH709LNr+84
	vEdhmqFdCc6jXnk2fln4c3KYJctViQA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TCZ0oV6L;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cbc593a67aso724953585a.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 23:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772695872; x=1773300672; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ifmFR1GOTxpHBh+4VdUvlVcXoIBiFw8BOia5QYersWM=;
        b=TCZ0oV6LLKpJoBjTXl1liE6rJ2LjiGVe+c4BbzIC32P8+ZKQsWdzdtNB9KaD7NDu2w
         nXnPZlq1Z8bPr4Vqbdn2j2VO1GLrSecQJJPy4/hAwx7zXDqGIkmQTdRB59TdPAtussDq
         MrSUUpvHllFKZPd9ehaGR9/5/b5YVlVhipMdHu0qCGkqqIlO1hHDUPE5UMKua+EIcAt7
         YH/Yb9P+y7mEm0oS50afEAM5N2FSe8k+gShAoDlMW+rPydwO+QYRTf1GCDPIQmLDty5l
         oc1/QRKFdaFOnSvZZeOF9xlXZoagX57rGapYrZ4gKIX8h2Ue56XquboX96Wu0mDffGPz
         o7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772695872; x=1773300672;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifmFR1GOTxpHBh+4VdUvlVcXoIBiFw8BOia5QYersWM=;
        b=HlyMH5GOqVjLqVDcP9xVjn46N6M2tfO+zG4LkcOS1KELsWFYLuD6GSFEnG0UcRoHhe
         KViHzAYHXdp3+DnmMcJ7ZlI9D5t+MUiN1TQRS81upV6OYYlF3NM8yJk3E+sXS5CRKgu+
         cIvJhlkNrDmvJ+QxWBhUfSNCXTj9jXR5hdxVj8gt1aAgqJ0Z3vMWyjGIY63b7ziWYu9C
         IS0w9VzdwaPx/ZA2CRqeRszhZDS3V5ANmTHvDhM6GJ5u/poBRaOtiI+ShFm2J2DPnu/O
         pTQX5uOCig76GByY0uNrtTyqYwAPRxXykwkMQBQdhmDwaXOUhvsMi//cALmfsWCNlzTR
         F4Gg==
X-Forwarded-Encrypted: i=1; AJvYcCVOsIHWMZkSoPkcdHoh8IKImjwmb/eMMyIIzGOgRKCinmtDJfAEZnikqMiOsiAa5eigoYqknJsSGg==@kvack.org
X-Gm-Message-State: AOJu0YxCjJ4cSHlZaoVvXBAFhCN1DAbJfWZSqL5DAOut5HkIUjp1wW+d
	V7HEnnNzZQxql21Lfoy+hR3PYNBiM0wtvM4SVgnFyDN57IamulrAVN3suP9skI9VtDc=
X-Gm-Gg: ATEYQzzrLdpq8tbJg5HvRfME1XPVik3f3Gya4r0bci0KCRRKgNjSA1aP1J7zqmBwiLu
	lADZLQ1P1utVAVOiYgUB6PuN2oFgu8wlNMGjcxeh55HokunT7Ui/Q+htSgHd2BycdjtFHV0tlcC
	nOQXXYT2CPphuBng/nJd0UJWgJ1eG/nVM3EVi8MiQOApmsEkpiWSurXQWSmYnlBt2hJYm8QRHQY
	5kuI8hnHv1CeXzV7q77W2A/THDn65K7i2AFoHbicu6s+XVME+GkIXM9p8v5aWENcdlFlibu8vBr
	hv85e0T9HmtqnD0VxI6YE0FOWqA8LRRpbELcsClFuWqirE9swyXIGueTb3Sa21dvbPhLY9l5yRC
	oKOM2iMpXTSc+FVdpgiOP4S/IjagIPuwH713vWUHaf4143PgeukJXnTm4Ys6gm7G7OGXqJTg5Gn
	ZTm528OU/nXixCcOm5IUVIQemmU2KIZKqvi2kA8KkOYKe/J1VhHSQpsGay+VgB6Km9oSS8X2Ktg
	FJKntgZuvPIptAb7/r0
X-Received: by 2002:a05:620a:40cf:b0:8ca:33d7:8be2 with SMTP id af79cd13be357-8cd5af96737mr641134885a.54.1772695872254;
        Wed, 04 Mar 2026 23:31:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f926csm1819232485a.32.2026.03.04.23.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 23:31:11 -0800 (PST)
Date: Thu, 5 Mar 2026 02:31:09 -0500
From: Gregory Price <gourry@gourry.net>
To: Barry Song <21cnbao@gmail.com>
Cc: willy@infradead.org, axelrasmussen@google.com, linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org, ryncsn@gmail.com,
	weixugc@google.com, yuanchu@google.com
Subject: Re: [LSF/MM/BPF] Improving MGLRU
Message-ID: <aakxPYGgXMHFQf1K@gourry-fedora-PF4VCD3F>
References: <aaBsrrmV25FTIkVX@casper.infradead.org>
 <20260227043139.95115-1-21cnbao@gmail.com>
 <aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F>
 <CAGsJ_4xsN2Kfa_f_WaZ-h9Ex7dHk6okyZxnW6oEcXW=kLXwLXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xsN2Kfa_f_WaZ-h9Ex7dHk6okyZxnW6oEcXW=kLXwLXw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E13EC0011
X-Stat-Signature: ganymj5a5ees4h6nqa5zbbs77iuunsxc
X-HE-Tag: 1772695873-365317
X-HE-Meta: U2FsdGVkX189ONnUFjncol2gZz96ngoazFjqg33vXE9sJSrSegkCl7+a8DqeVoa89fiSM2EngzLRZZ/5//KpfP6rh1JlO4p2V+MDz9mUDPI1QSJoFJnOH/6J5FkoEeLGD1wsy/LCuNv4cS8iUk4fUxdzDtz87hpJqq7MC3Ofh722LdN+wCMvnSI4ZHKKrlaVDiIEmOZyyCTcEJk28063V56+CyJWdUhHho9QrW5Yf2CUGhJR2B3kTvR8xX/SAL5a6qRhMQJMUNJMcxlPVFXWf+2GTwpmFJiTWLNQvWZv6b2asRy/iGRdnbRGHLl+bBYlp2G5OW1fWoDWeKh3p5SnYBp80Hud1ow7/8chSbtUclrRZOBlg6bGsTNsKqtBlDAlRin7dnBv2A3NWVRH9vUU2wJauODxMIeXuOML6aCESCKu6xGIwvK9C16lqabuoyr2+f8FwHXs6S6u2YpRHLTCAA4aHLyyJ2LKiHTgoq+TEEPyZ1vwN7Sai3KDxqVNg1P+pPAeEcYYbMZ02l0c1Zuqc94vqsLHNITmHDQkbDl7yAcxKBaos3xB8I3gzSqeRsvOnBusrRkPpd8n1+JW4X2wA0F+ijogQwz+lSCSlHVQ8hNeUakH1nDbPIa31e4iFCk3xGJzLB7J3kDsQUKudJzk3wFJzbYgdY/XRPj3PlGcsSJpdYtiRjl5ePXA3th4hz90fGG/RpCAJjVUyuAISXJUoTBsNP9gdL1do8uiKefa620pYjncfkmjE2+3MwPklxr9a8FYvVvOIKGe6JghxLspH33e+raRGHd1v4/GyQkFq4Z+yErZMw9u3DCTWA/FX8EL5wE8yrI7QnyFa0PjCUknzTON1Ekh+SEoarrQpVWj96cguoKDB572W9NMCbY2dGrvWpM8f06rdrlIJjskGqZai9lVkCeClfQpX3tpu+aLlWnZxm4LTtxwHCSpEsKeRiAKidlpRYxf1PiUqU2dgFY
 RsUdsFo4
 0hlO0svjLYVPGKO93VKAIMm313DGXPof8SlU8JpS5k+WOoJ9ARhdqu4tHZ7jaKclQChi44wyT0mEVTSYQ4h52wtMfIPBgx33A96c/yCH9Mp3lmVb1BwCPJCF2oKbHeqLwwWpWbnlD2kBIVMVE2pskF+Cgs1xuVZgQDa6YL+NxoX4DAfWU4O9uFEWBaekeUUfT2cdYYe9Wp6BHDkVuX6SWSQLfn2cMuHPY0VFRwl1SVipGe19RNNyC1VVKGIB/bq/PQDjwwIWl3W2hxJWq1eUfTN0PnnwYZN5+4spVFNZDEv6NxP5aOfZyTG+vAybd1l0gkWrZKu+e+ykNI2wgD/dzmuGv1VccAk8SzJ7yddBMc6T99IVlfSqBWn1kg65hzt3cue2ZHCFs+LY83JMioNsUf3Ou+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 02:27:27PM +0800, Barry Song wrote:

... Just trimming before, promise i read everything ...

> 1. lru_gen_look_around — exploits spatial locality by scanning
> adjacent PTEs of a young PTE.
> 
> 2. page table walks for aging — further exploit spatial locality.
> The aging path prefers walking page tables to look for young PTEs
> and promote hot pages.
> 
> 3. fallback to the other type when one type has only two generations.
> 
> 4. very aggressively promote mapped folios.
> 
> 5. min_ttl_ms - thrashing prevention
> 
> 6. gen, tier, bloom filter
> 
> 7. Missing shrink_active_list() — the function to demote folios from
> active to inactive.
> 
> 8. swappiness concept difference.
> 
> Considering all of the above, I feel MGLRU is quite different from
> active/inactive. Trying to unify them seems like merging two
> completely different approaches. Still, active/inactive might have
> some useful lessons to learn from MGLRU, particularly on how to
> reduce reclamation cost.
> 

I will preface this with: I'm not arguing to rip out MGLRU, but I do
want to take account of what I spent the last week digging through.
(and no, none of this is AI-written)

=======

You list here is more or less the same I came up with - and I poked
at bolting some of these onto the original LRU in the trivial sense.

I tried re-using the code on LRU with minimal modifications just to
see how it affected some really degenerate high-pressure scenarios.

I mostly found these features did nothing, too much, or straight up
caused LRU to fall over dead where it didn't before.


PTE scans
=======
PTE scans and look around are powerful, but really possibly TOO
powerful, that's why there's the bloom filter and the PID to prevent
MGLRU from over-correcting and saving more folios than it should.

As you point out, you also burn many more CPU cycles this way, just
not in the critical path.  So if you have a core to burn it can be
fine, if you don't, then scanning might hurt more than help.

I do think there's merit to this approach and could be adopted into
LRU as an option.  It does however *greatly* bias towards saving Anon
over Page Cache - and so that can be undesirable.



The PID controller
=======
The existence of the PID really suggests the whole mechanism is a bit
too over-engineered.  You put PIDs in things to dampen corrective
actions to keep towards a steady goal.

Requiring a PID doesn't inspire confidence that we can reason about
how tweaking a particular behavior of MGLRU will affect the rest of
the system.  In fact, it makes it difficult to know exactly what
effect you are having since there's built-in dynamicism.

e.g.:
a) LRU  : folio_mark_accessed() -> promote if already referenced
b) MGLRU: folio_mark_accessed() -> increment a counter

What behavior do we change if increment +2 instead of +1?
Hard to know.


thrashing protection, bloom, intra-generation tiers, etc
=======
Many of these features appear to solve problems MGLRU invents.

Simpler is *generally* (but not always) better for reliability.
The PID is another example, but I put that in its own class.



Aging direction
=======
The fundamental difference in aging direction makes LRU/MGLRU
infeasible to collapse.  At best you could pull SOME features into
LRU, but some features ONLY work because the aging differs so much.

example: Bolting generations onto LRU makes it unstable because you
can starve the oldest generation trivially during bursts.

So we've started by making LRU worse, and then setting off to solve
the problem we've created.

You can sort of see how MGLRU got developed naturally:

a) we want multiple generations
b) what do we do when the oldest generation is empty?
c) we can either cascade to the next generation and reclaim there, or
   we can get fancy and start to treat aging as a sliding window

The engineering decisions all become pretty straight forward from there,
but you've started by creating a problem to solve.


=======

In my gut, MGLRU is trying to bolt hotness monitoring onto a coldness
tracking mechanism.  It's ok if these problems require different systems
to solve efficiently/elegantly - they may in fact demand it.

But reiterating - I'm not of the snap opinion that it should be ripped
out, but I do think MGLRU's feature list raises more eyebrows that it
solves problems (for users, it certain solves some of its own problems).

> >
> > In a random test over the weekend where I turned everything but
> > multiple generations off (no page table scan, no bloom filter, etc -
> > MGLRU just defaults to a multi-gen FIFO) I found that streaming
> > workloads did better this way.
> 
...
> Perhaps an eBPF-programmable LRU could also be a direction
> worth exploring. We could set different eBPF programs for
> different workloads? There is a project in this area:
> 
> https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
> https://github.com/cache-ext/cache_ext
> 

I'm certain the eBPF folks would love this :P.

Though there's always the question of where your hook points are, and I
would question whether this scales, but certainly it's a cool idea.

~Gregory

