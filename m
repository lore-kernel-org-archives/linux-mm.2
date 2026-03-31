Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A170FF60E7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3E76B0098; Tue, 31 Mar 2026 04:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA916B0099; Tue, 31 Mar 2026 04:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E79A6B009B; Tue, 31 Mar 2026 04:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D13C6B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:16:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2F3C5C76A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:16:51 +0000 (UTC)
X-FDA: 84605652222.18.D5308F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3812C0006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:16:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A3HizW0j;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774945010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYktqcia7skSaw+Y4rqC1zXmoG86ov4lQ/qW3VUFT6Y=;
	b=3QLJy2wMwCpJC+HrfwMBdMxZWnrjxECg1KVEgU7Wn8vmzDhxpWtE2Z7QCmYS9gPjNGM8RW
	J28Mb3747jpUQ9WNXDlwuxadfC/6Ufm2ZrzI6Y8b6qgR81XXqEJ/REBpLz/KF6hw5fn6ej
	a01o1YpCPJPKoWLDPMWQnl+3KHllqa4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A3HizW0j;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774945010; a=rsa-sha256;
	cv=none;
	b=g+fZqTej0zqrondDmJ6ujjMGXPn5hx7oiRoJG3GNU18rdX1BisDJBepD1QAZH/6NzgLarP
	NyrtqJstTFAlsrqvpihhVnMAWK4BuAHPtuUtNL22EF5lItIuOhyRdsJ5pUQ3Lx6r8FKNdM
	sdhKUGo5TeLr0isdsw8r3RNj5cPI0Rg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0FF142CED;
	Tue, 31 Mar 2026 08:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5BDC19423;
	Tue, 31 Mar 2026 08:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774945008;
	bh=1/b91mgi/U3fwN0ggRiOwK1YDEmQTiNMQAZyJI8BbOg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A3HizW0jQdmUOC+s+7wKXIR69YrouWazRCDICG1ShMemTG6O4228pnr3GD/ExeZ0H
	 YiuTIuS8c5bhc3h429eM5O4XjVloyaxn8D7G7WNwDk4LtfrjwcFLCOzPgxbtdOZlaO
	 hHD0byUs6L0pwQ3/yf5DynWJsovHJUw9rKr/I/+U=
Date: Tue, 31 Mar 2026 01:16:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 teawater <zhuhui@kylinos.cn>
Subject: Re: [PATCH mm-unstable v2] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
Message-Id: <20260331011647.79bdd9b9b6efb99bcbac8d77@linux-foundation.org>
In-Reply-To: <20260320020745.833792-1-hui.zhu@linux.dev>
References: <20260320020745.833792-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ozkthghszuu1ezop47md8yagzkoogxyn
X-Rspamd-Queue-Id: E3812C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1774945009-914260
X-HE-Meta: U2FsdGVkX1/3ZpPZjsJKavJPIXZ95EHo7CpCLF9JMI8JsPBjsa8ZXcJSJ3OmcJRnVZvxCefs0h/BmQImm2ArrODl3jxbgyZhx6h/tBtMQXm4tusDN6L/Kb5L74xJ4xNVSmnG0JSeP9DeQEPPvHzCQMWfyRiCnQx3VvvFYz9C3ZLm7tSQ+g5ayqh0nuBUOfUNYZo3uq/EwyrtfHI1Syly1eggfbtK/oD4JiHmXHAzaZHTfO7Ev4ST4qIlaOTfyINWjRtiO7/wgFTmuxpH1Vo3+XQWUVKM3FM3XLnjb10QPYQdDZ7VV/dH5evs6lKW+bHOjNriPweHmxFBekFKrL3G7XEJk+6NxeuT6ndJTvhmskSJpT+vXpQ8LR4CbEqTVhHhrWY3dodwLftEmDLJZcXrB3XgH5IYy1GkUBC7SSPY+8ow+F7EaOrW7nTsFshM4Yvp/cAl6jUFDrkS0HRDQuXU0Ssk0jufU2iB+iBv+a1YZISJHzQNq/jIA6fIHxwkz6Psw3h/As2P2z3wDYDRZZ/1LuzJ3NcsUM9zocnfMw0Q7sRbUHzxbM/xeZssw5PYLPvsWWYSogmckY/bcSZ8Ldc/T21CQxp4tRlwgXGwhUUapL2z983n9136R6oVUYxLhQ98OC249HT3jPFXhCUVdb7Qg4BiGZgBo7UL+88Tfxaj69rBWvjNgu0hKI9GbxnAEdM4ZR/BOm45jBHskOYDDClBoifAQvMrKYPeKlspZWjEDdRjEr2Z0npW1zjc1WQHaCbOSh+Quj64QF1WbI9Ryxc7mq6rQMYK7VJZZiITmbtsuCkpS8elydSzWSRcFMP1YN1PUVPi953jf+m7T2urBi0ncSElTjN3mjLxbLqTNukaDOt0ry0pcpuyElC5Qy4nqzOkdXxAhDBn/QZuAdGqeL0srrm98cZ9POEjf9HsPE0zaIxNcbszZie97x6LkJuYH7IXWbc7eGyqK63RscSh0Rh
 cVeOskZ4
 hXM66F6+6BMLYp3pV9kbEPFKzl/8I5FEopyQasNGVtBvVeFQAaFDN3qykgv/p+TnyNCT0dy9tnf5bHdSfnaVtB1stnDnEiJ0XgJBcnDnLCNvDvq8wg1DSm7M8z3HDaV/a/1DfMSm93kNkWuF6xBHmeXlux8weQrHlA2EFAHb6pngQ0CLFhtec6tLHQkAIbrEO6IF1utE660nZrjIxwwbw6WfhWgcr+9Ao9aiCA6vlXAJCQgafHi1CeU6REZpXAmHr2UFmlAFU3j0QZZhS/s8lQO5BUbDwLdE4UaBaQpTEtsgNjdUSqX8/KlFsbGwjNzWznFE2v2E3tEmyy6EAxs7kBIZBvmwdnXtL1uSJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 10:07:45 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
> hook __memcg_slab_post_alloc_hook() previously charged memcg one object
> at a time, even though consecutive objects may reside on slabs backed by
> the same pgdat node.
> 
> Batch the memcg charging by scanning ahead from the current position to
> find a contiguous run of objects whose slabs share the same pgdat, then
> issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
> the entire run. The per-object obj_ext assignment loop is preserved as-is
> since it cannot be further collapsed.
> 
> This implements the TODO comment left in commit bc730030f956 ("memcg:
> combine slab obj stock charging and accounting").
> 
> The existing error-recovery contract is unchanged: if size == 1 then
> memcg_alloc_abort_single() will free the sole object, and for larger
> bulk allocations kmem_cache_free_bulk() will uncharge any objects that
> were already charged before the failure.
> 
> Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> (iters=100000):
> 
>   bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
>   bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)
> 
> No measurable regression for bulk=1, as expected.

I noticed that the AI review of your v1 patch reported a few potential
issues:
	https://sashiko.dev/#/patchset/20260316084839.1342163-1-hui.zhu@linux.dev

Can you please take a look, see if any of this is valid for v2?

Unfortunately the bot wasn't able to check v2 because it couldn't get
the patch to apply.  I've checked that this patch does apply cleanly to
current mm-stable, which is on the bot's try-to-apply list.  So if you
wish to get checking of the latest patch, please send us a v3 and that
will trigger a retry.



