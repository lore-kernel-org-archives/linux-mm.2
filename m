Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BB3C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909B76B008C; Wed, 22 Jul 2026 16:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9ED6B0092; Wed, 22 Jul 2026 16:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2456B0093; Wed, 22 Jul 2026 16:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 528296B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:50:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA32A12025E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:50:09 +0000 (UTC)
X-FDA: 85017604938.03.22175F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6F0DD140004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:50:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ng3LcE3f;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784753407;
	b=JKDYBmj46i558GQQL071mEWo1DaubAExIl6EET9diYcmpiF0MH6MyiZAPELjbLp+imPFL5
	xv/rs4XJN73lnwuoSm2lCP8zr9uAgbCNDw7yxSjwBxRehJbbkYly9y+4D7nVy0aEPpSofi
	/nX/hkGE++rSlhjEL+JJjQpkVVQCxfA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ng3LcE3f;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784753407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svd8qKUPLqu9cVL1hzcljvgHEiqm3JmbDQZFevcGTtc=;
	b=Faf9o6782LgijPhMql6jqqCbmZXOF0/eM4J/S5dSSrAcXo0bIFHoeCdPU5us31/fwii0cr
	EbNHj6Fue2nUX9ZoB2s0ek6yFQi7hYgwKz25ZFs9zUA7zNFSW3klxje9BldtM3m2BL6RUE
	mKJmpNFtWMMcVFKLPwtGHccqq2PofOU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00B2B600B0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA2F1F00AC4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784753405;
	bh=svd8qKUPLqu9cVL1hzcljvgHEiqm3JmbDQZFevcGTtc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ng3LcE3fUCRtaPGEEhzMWGp2AHtmaDyhsZO4bSQsijwFWt0LaNAP8FNabG14dRLLp
	 81v3mBFcD2VTO7+hH+PIgiIC1sw1MVkI7gcEXEzrw28mWnOfrjsIBkHBjWGGFMpxDV
	 JzokVuPhf84fNue2bwloULdaWVEvvF0BXAzwPKifA9DYN3D4P1R/V3YgTIBwiVCEmy
	 EFjIYtj9ljXE/NXkhN9XT4zk9/VOgumFyUFy8qAuzOvTm5qQpsD+Uq4VzKCJbBzQV7
	 BMswzPDoe7dysPo5rY3E5FPFN8wbz5YwDA3eoymLDuMgsCAFdcuOowHV5nbfz6Lv63
	 jAfK4U5+Sa+fA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1c24ec9525so81882766b.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:50:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqnRlj1MAglWsA31ByxRADhFeDmCuKqYXtMA7TCZ6EYicaMgFqwq/yDTUVyfz5KIjny/FlezpnRLA==@kvack.org
X-Gm-Message-State: AOJu0YycX6YzmCq/tzmkebZayi8tAMv+MZKX8V1lEj5DMo9sLm8NE83/
	ee7oer+eUqeGQWp8rT4w6HP/j2sOGaTH57n78ZzBag3/ZHfyNZdcD2r0T4vuaTakvw16iPpXqRw
	W9qUc5yIVjbgx/J/FbKIjS2qExcqykEM=
X-Received: by 2002:a17:907:d16:b0:c16:1901:6ba1 with SMTP id
 a640c23a62f3a-c1c5088d931mr18037966b.34.1784753404547; Wed, 22 Jul 2026
 13:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
In-Reply-To: <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 22 Jul 2026 13:49:51 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPr8GrkjxEgkCnyzvbMwtjv4pz=-fPF5pU_0=d-04HznA@mail.gmail.com>
X-Gm-Features: AUfX_mzucBMYgrYM1RZx9TGyW_IkG7yTOSjC0nyVH_uaw3OJsy5URxVn2ngbmUo
Message-ID: <CAO9r8zPr8GrkjxEgkCnyzvbMwtjv4pz=-fPF5pU_0=d-04HznA@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yunzhao Li <yunzhao@cloudflare.com>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7gw1nd1u1ty1ef6s6e3cwfn77e8smfob
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F0DD140004
X-Rspam-User: 
X-HE-Tag: 1784753406-235284
X-HE-Meta: U2FsdGVkX1/NawMH2xjk/jaGzDM1X+RKstMiYRZjo4xw4PRBtn9xTm16NQWW4vvavaImHBIkd7iSEdFsckmLZxwvG2Dm5FOBJ623EN4wRDO6gQ7W7DDcnyqk/hWCGr27LXrAfQ3gBagpfV7UTF1cJEABVTx2i7Dktmcw1Vvx3eE2aSoTJ/XxCz9gFpl1FLh6wSC3bMIC+nPkLKC+IwbJ00y4snOegPZwk0Ov6AQ24EosdDM9ntgQSOq714XobehuINxOVOHBZDi/lKMlARKBXfH4QttPKppf0N7lCHJgM4CbKUMStiKRrQGJySaBdbK8i7wURAlZaNwQB1Y4LCupST1CIRNFQ0j7SwSLOH7FpPJo7g5pfE7P2jIWi0bj4YJ/v4lzr2CWQB6YfiG3I6rsC5eE8EfcN2HIJwQIiYlU6UKv4L0oYPITFiOPOxY5qhqx3fvPJZZQcF5bUcoPXfJ+nSqGHCnMuuulu64LaOHhA0hamsDBrfQlT1zK3Z3SudXvH9H8gjE3o+dEfbWNHn/owGSdvQoOUFg+EFpJbzYv90zqUp2fQXtQg5uZaUvnqUCT+9xmFjiqKHxln5I2tunTzNZx+lOF7rNZjkQClmNfmZ4bcctjXbIDASH+QmKzqVFfofM8RS30HxBINRqZoFsIMCHdyi5tkWcuRgmEfgE9r4JLpmNyRH0ALYxS8jn/vjxrjQazZ92KzK/SUWMEC3/meg287uM7o/i+ojN4v0SbVk2JMILfbPwltnyt7bBUYJLQ8rlBWPEmWMQuwTaxzk4s8I6op2JXT57UvKFHO4dntXv7RqlxMc7rwRpX9q/h1AF8dZBazWKQp2hPxTm843f+5TCDJOc9QriTrftg1oUOk4uww6T4GIcxtLwZscgQ3amOv/s0z9XsnMakQZblhyiroRK8UGgMMnS6nPPIT/blV5+kV4ZwgJ5yKZuKoany2qdLVHaocU65pbAHbJxWOet
 s+0/1nJs
 q+Pu0z1JNQpwWLZnfyGEEFJNPPiDstu1XbpMwgWH4SIIWynzlqprkFve927ZDWb2txLoiiy5lU3MJ1mqDLSlm0wNIMEDqJ3k7HmuyOnieFidXyNrb7XNrBSfc09zL/3DUi6gvvwT1we8W2rTtfr8xFYx+qsJ4A3hIW8V4ldeByBcfCGF1vLOosdJJSFwqKEZ/nYCs09d3CBww2zQoNH2KbLvmTOi9D6be/5FwUp6FaNGUU7x8f+FLdSpv62pBXS2BUXJYARNJJsbVcM/b+LaBYbMb9EhDIR9ufPSG3P+7xcVnK9Cu5h7+aVtrgCS/dMZjSORnDe9JFudkSN4c3Iq4fcXlpcng34HGoKDS2IJtxRzLy2BdXFoesFiXlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I think we should at least try a proper solution before falling back
> to the whack-a-mole approach here. I don't like the ratelimited flush
> because we use stale stats and the formulas start making less sense.
> If it causes any problems, it's hard to reason about them. I agree
> it's probably not gonna cause significant problems with the zswap
> shrinker, but we should at least make an attempt at a proper fix
> before resorting to this.
>
> I *think* we should stop using rstat for MEMCG_ZSWAPPED and
> MEMCG_ZSWAP_B. We can probably use per-memcg atomics for those, and
> just iterate the parents and update the counters. It will also get rid
> of the flush in obj_cgroup_may_zswap(), which is also problematic if
> memory.zswap.max is used. Yes, it's more expensive, but I suspect it
> may be just fine. The reclaim path is a slow path anyway. The fault
> path is probably more concerning but we won't know unless we try.
> rstat has a heavily optimized update path and a really expensive read
> path, and I think that tradeoff just doesn't make much sense in the
> zswap case.
>
> Can we try doing that instead? If there aren't significant performance
> regressions it would put us in a much better place imo.

If anyone is following this thread, I did play around with the
per-cgroup atomics and that didn't work out. I think we need a more
general solution for in-kernel flushers. See:
https://lore.kernel.org/linux-mm/CAO9r8zMwp-wxJz6AjBSEuW+vn-7ff2VwAdHpVHFAqy0skgD2OA@mail.gmail.com/.

