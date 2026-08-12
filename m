Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BF2C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 22:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378126B017C; Wed, 12 Aug 2026 18:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F7E6B017F; Wed, 12 Aug 2026 18:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CB26B0182; Wed, 12 Aug 2026 18:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09A496B017C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:50:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DF0680465
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:50:14 +0000 (UTC)
X-FDA: 85094112348.20.5C70765
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 375E720004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:50:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="qZP2/two";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786575012;
	b=GXJpVbLGAZW7BljByuprWQczCvp7F1nyAcpE6GQKxXCHaF2KBHzOD8oRol8onKFtzpcmPU
	ZT5UFWPpQKnJpMFfP1J54o8nF6pC20aik2JLmiqDbRHtbjTKTV95nqqgM4r3zQZ3u9zDVa
	hKlucVKQf+hrQzuDy6E4jPickHMG+pI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="qZP2/two";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786575012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX1mtHvsVWE4pAYEkaJGnNdeV9GfqdK01h7t4lsHXwE=;
	b=A+q5aPBl/4zFF2ptGJp1psJy3HgCbZI5W+ehBW4vAv/1+NGM4ELaq3rw5bDU/uSODMyA0B
	bW6XiQVtW8ZSCPhcD0shx1oeOxsF6tkBDE1zOcO09Wp27IhAnx8sRw8Hf2m3n+S4f2uj97
	dao/V6BZJqIbKDFX3KuZ0nyYpiC0o+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73C99600AD;
	Wed, 12 Aug 2026 22:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34681F000E9;
	Wed, 12 Aug 2026 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786575011;
	bh=jX1mtHvsVWE4pAYEkaJGnNdeV9GfqdK01h7t4lsHXwE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qZP2/twoQ3M6TVc5K/4I1BejDEiVV/5s1xxUZWr+68fh1f4NGuze+uNFmhKGphuwS
	 IDWzhDdhQucWY5qGffH0ue8tsfYipYzw11nEWRJfDAk1JemHr5cN6Ug+Ox+bZbNgOt
	 GBZUmjLQXGzvtRqw8eYb/ANowk9aWXMTDNKByUmM=
Date: Wed, 12 Aug 2026 15:50:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-Id: <20260812155010.8710b4a9191c9ee4ad6da255@linux-foundation.org>
In-Reply-To: <20260811203203.3456029-2-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
	<20260811203203.3456029-2-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 375E720004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: n6hifj5534dyncqy44hwhpag8iuf69cx
X-HE-Tag: 1786575012-687480
X-HE-Meta: U2FsdGVkX19CuI9WWZmgcZOGA5R2d7F8HNkU2gc7ELna8TDSqzg6b5Tj3qHzcyTNdDXENFuRY6H9tlWOG2EbhLgZ9veHbEZ97Wo9IakNZUKA4TWvdzcOCbaIucL+rPpPyH2f7c/9blLT93GhSd2Oxy2/qLHXPtDIMaQQxUNpBzBPZw5nszCM9G5w1R4OdGm6FSamqtXy9qTP3atyFrWlV88JKQ1ctzz3RYJsJc0ESac5KTw5bCrya27B6yfYNQ8wIhJ/CsjkqP3Wk+4YeC2h3sSEhj7WbDmreXudGlbrPU+oc+ninW6TKvqQ/AaszVQZzt8Jvl373k94fvnkot6ff/VHcuSRlp5OlT8NTT6Vrtgk3yZs+tYX24mfYG1QMf84oj1I9buWCHjzMwVmB1ha/StY34pPzrJNUk9+70zBacptoaHLsUJiwEKc4dJ7vTBmOyjfmyROI5GaqBHMLkwiSoVlnNelgef8FofcjRemLI16t5YLcKfsq/j8wFtMSZu5TuJ9RON6arZyyaKO35z6ygNEo0xrpl9EiKXE2BppflQK7qXN2TjaG4KcmNwbLvFQi5ZCbGYPCYRghcZ1KVzDuRzuhU6zYP+020gw2NxQ+XwIWGLoDR17zDbf3R8ZBVHvSjgun4gms0/uebRYZiHAuVH1rDAi6sohicdytyb08oUv+YhyXROXcDzVD6CgJA5B+Zeml8eV9mmL47+0IpQN8Dptv71ktxe+EmBUISZy+4sN8vcJs6Y/mUpGshlhTT2Jp1Uo5OcUVQpxaO02vr79J4DApwzu19GP3K39ZzlWhdxexurHdEmGC5iMe6ube4GOy4qdlmPADEbb41JwbdnfDEP5/7za7kP7wknbF1IIJjF7Ac8iNZfUJ3wvvSQMJfSbOu2xp630AUZxwFKT0dZSaEaStqrLdVqx9H1eXsrX0JYpXoHrIAQ2Yo3fZ29GRv5QdteJWBLO7XKO3I2l2ae
 MWwTHSL1
 0MmZQnnN9kitchDPF3i6kNCJfp73o8E7cj8S9bAdH66NgofH1zbCPG/XtO3nFL0gLTuzbJgIMm/Fk5D+aWOHOVrW5TenGUTHyJVrovXw8hJurHTpQbRGtenN0IjahvUiAiPSu6Sw9hTn1Q123GG1eaC9lEHKWPsR9PZfUdxfcu8xw8/4IP5L2K9O77+iqGmpIGCpL8FBXrHYSkL6sSRqoGv1NwtukStS/Jjw233oIVdCFNa98J9Y+N8SeVOuepjIlrizfx9qMKi962Yl4emPd4zCMZp5X7+9QuVLYldE5jXVIHzN69qaCu0DM2tCydFFMyHWRHgHJUm3hL1TIUy6uTh4Yn4qNizvJmcOyOB4AffmMegneBN3bMNOUY3zMsmaFJVt6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 13:31:55 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The v1 soft limit has been deprecated since v6.12 and nobody has
> reported depending on it. Start the removal by decoupling the interface
> from the implementation: keep memory.soft_limit_in_bytes, but ignore
> writes to it and always report the maximum value on read similar to
> what memory.kmem.limit_in_bytes already does.
> 
> Writes are still parsed, so malformed input keeps returning -EINVAL.
> The knob now also behaves the same everywhere: it used to return
> -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> disabled.
> 
> This also fixes the syzbot report linked below. Soft limit reclaim is
> the only caller that runs shrink_lruvec() from kswapd against a
> specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> and in turn set_mm_walk(), which warns when called from kswapd.

Thanks, I'll pluck this one as a hotfix.

It's old code, yes?  Are there any theories about why the sysbot issue
has just popped up?  Should we backport the fix?


