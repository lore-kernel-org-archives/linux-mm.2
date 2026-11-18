Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E9E606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=C3xuFqWJ
Received: by kanga.kvack.org (Postfix)
	id 0B7946B05B5; Wed, 18 Nov 2026 11:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F466B05B6; Wed, 18 Nov 2026 11:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE76A6B05B7; Wed, 18 Nov 2026 11:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C59536B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:10:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65402A8423
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:10:24 +0000 (UTC)
X-FDA: 85448727168.22.39D7E27
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A3B8C40005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:10:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C3xuFqWJ;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018222;
	b=cxLWRd+QEoCppHKDLMwafpXvj57eCz5Pq/PB6MNLiXue5bXIXXVwReC1ckvDnbkPlDdkuD
	kHVTVGadG3LwVH8KG+7PI5cq3KRccyzdMs3UyCAksXUjERWFxT2uoI0iklgjItBI2UYkKj
	qiG5fBgl60UjY5cgpTxb/PIllCdp/7A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C3xuFqWJ;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNwKoLmqeSwPydDAhEghKLHqTvIumd5TXBU/hrH7FpA=;
	b=Xju79dcKvZOBRnIJ4sBhpxMNwDYXOd8k4MEZtDf5v2kwMZX0HQ50J7lM1K+SDLie9Z4uHn
	yltCuNUiIBnbJJIauQETk9c3SIOSdN3e42ZNUKa4kRDqyAfadic2/Q+G2HvQ2vKjpojHU/
	5Ja6lJlrho1L/JdSCAGb8rAWePgza08=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EFDD339;
	Wed, 18 Nov 2026 08:10:18 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A57E93F673;
	Wed, 18 Nov 2026 08:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795018221; bh=/+padZQ2w+TGhQW06d2Ojc/kEfJW108rtB1jBbALpjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C3xuFqWJDbpH6XEiCkUlBwXIN543SWfJMKcxccXPy9d2AfNHicO5Hj5c/DuD5pNr1
	 KL4sq1hvast3EohM39v1bobaW+vQojqjNZn06FNSorkFZZme6DRTBtRQZSNYzWihaW
	 9wAFlw5V69dS7yYPdmIqhzWvUOcJuuKEdBg21ZEI=
Date: Wed, 18 Nov 2026 16:10:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/slub: don't let kmemleak report rcu sheaves
Message-ID: <av3N6DGiOFK3e3Yw@arm.com>
References: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A3B8C40005
X-Stat-Signature: o5chb436trgr4dxr37iwjb871stgw9xt
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795018222-656898
X-HE-Meta: U2FsdGVkX19ltomw1i2jEKj09HmM580zdT+wFll6ej+b34li4p0WM4eKSt8XFij9WYXzOoU6CJkW4gzlRuJWcOLG9D3r9vPsGztXIf3nV5JPS3QF2nSmFf4DNTGA4+9sEjfaZJd34EJts6TWCwgAy6DiBLl6uwSl4vV5KUBExfomXFXytJmkSAf4jVjDAFk61yw3FQy1G0V4MX66E38Iqta24AhtClA4/dw6JmYzx8OutZcbWfYiOO88moOt5YNbVusj3BChZrq4c+vIl1WwLNC4/vqjmWKSsmf/sg7W6UuIBSwgnCQJyFsvROua2g2eILUQkBjL3E1jvCTVkY27AqRCTbxxzZGQz9314RPDVURoXYcB9YjnM8/+UNshRHzqZJSm7j/Ssx5FK4SZ920aMmrkKKwDZvN5JKyFIzMwFT1AQGiIb+Kp+T90D3TzlvPyPVK22KzAVW0Db4Jj59c78sADQUcYBsHB3LWNCl7RjT0XFZlFSxAflbRFDQrq0159j3IRhlLoW7xJhQuniKlFwn2kBM/ahsAl3ZmAx0vZjpFf1y3S5DYNpJwwE2An/M0ktYuvpRh3nkD8wwXo4zp4PKdJcqVQm90dYjiAbC5B9tXUh0SAttwkF7rL+cln3AMy6tX6nqNVmWnlcOHEj0O6BCXqr9rf8njOW0AG4tCTSwUBvm6pUH3s+kXOUln9kSX/lmjMWeu3mQyBafo7+4YWIyhFeI7r6+l3nsFCwHZ3PXRvTGMcWkVxb3JrmtTPYmUwlgX/4LzE7AaJNZ1XaxLifPeq0JHiy/Qg+LOcsqKJgSA3Y3BMTaU9n93ycB+SRt9zYh0lFDw2dpFDz+4PPm6QB40W51qn/dYfOTIVVpCaM94q1yLoWPRLzsg80mTV9rjGORScpCIInIS0D0upatUELJkkWq4+h3zbHvFSKD7/jIpejyZ7b/x5QlV+PihAZodO0kPD37cXxzKjz+jznf7
 RIR7RCjP
 OHROi/ng8bP1YoP3nfjzug3jVMLVwVjh+EEGsUEuT4b4kKxhg2VVaxHTAZ7LIc4MXNKEuqSR93mFNbRqaogNM8HRF0GD2qDCrAYmaVmiJ+Y0aCdmz59GVH9yL2DMnkXuHtE1mfHm13vEeV5Vinzf6+Q8F/bg7orOmDGmuulqJ0yOOduNLtTOuI9cuPDmibiYUjFOauWq9peofQE+SMGgy0cLZxtMTwWw0KeMp83lklb6k16aLIJAg/LNdjM4pf6UHYtCaftQkQn7ak64F5wT4Xhb4hi/1WhFYwAnliJkHtVX1Wl820WOWEvXuQW0OS9kWF8SfnuvdXGK1EKhlSQxmFpBZl9cg30en7bCkbc2Yek+aKtedCGvah2gW9wBZwvKUqh+ccRupdAo2zC7fHoPBmWyv1pfz5NbESK9xUH1WfI04C/roTRJY/rnJrBuZSA0oBsr5JtenkXusu4V5A+wkzCtEgw9fLsofI1btseI/04jAVhByjoUKe2djgZZVI3J+9rLdGEqaabf3MLWzmCNsAZSiQbi0gUo2vb6u4ds7u6J6MTWsy7uqDW4ihA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 10:18:37PM +0700, Nguyen Ngoc Thang wrote:
> kmemleak reports full rcu sheaves as leaked:
> 
>   unreferenced object 0xffff88810005f600 (size 512):
>     hex dump (first 32 bytes):
>       e0 79 f0 2b 81 88 ff ff 20 00 b4 81 ff ff ff ff
>       00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00
>     backtrace:
>       __alloc_empty_sheaf mm/slub.c:2854 [inline]
>       alloc_empty_sheaf mm/slub.c:2874 [inline]
>       __pcs_replace_empty_main+0x260/0x2e0 mm/slub.c:4806
> 
> The second word is rcu_free_sheaf and the size equals the capacity: the
> sheaf was handed to call_rcu() by __kfree_rcu_sheaf() and is waiting for
> a grace period. At that point the only reference to it is the ->next
> pointer of the previous callback in the rcu callback list.
> 
> That previous callback may live in memory kmemleak never scans, e.g. the
> rcu_head of a struct slab queued by rcu_free_slab() for a
> SLAB_TYPESAFE_BY_RCU cache. Slab pages are frozen (page_count() == 0),
> so kmemleak skips their struct page. The chain from rcu_data is cut and
> the sheaf, typically allocated long ago and recycled, looks unreferenced.
> Since the sheaf is then not scanned either, the objects it is about to
> free can be reported as well.
> 
> Sheaves are allocator metadata and are always owned by a pcs, a barn or
> an rcu callback. Mark them with kmemleak_not_leak(): they are never
> reported but still scanned, so objects queued in them stay referenced.
> Allocations that can't spin are not tracked by kmemleak, so skip them,
> as alloc_slab_obj_exts() does.
> 
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Reported-by: syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=527fed49e5b988882c9a
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
> ---
> Reproduced in QEMU (syzbot config, 2 vCPUs, numa=fake=2) by stalling a
> grace period with a preempted reader on CPU0 while CPU1 interleaves
> rcu_free_slab() (filp slabs) and rcu_free_sheaf() (maple nodes freed by
> kfree_rcu()) callbacks, then running two kmemleak scans:
> 
>   before: 16-18 sheaves reported per run, rcu_head.func == rcu_free_sheaf,
>           plus maple nodes held by them
>   after:  no sheaf or maple node reports, no new warnings
> 
>  mm/slub.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index cd671b934719..e01416ae0b4a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2856,6 +2856,14 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
>  	if (unlikely(!sheaf))
>  		return NULL;
>  
> +	/*
> +	 * A queued rcu sheaf may only be referenced by an earlier rcu callback
> +	 * in memory kmemleak doesn't scan (e.g. struct slab). Never report
> +	 * sheaves, but keep scanning the objects they hold.
> +	 */
> +	if (alloc_flags_allow_spinning(alloc_flags))
> +		kmemleak_not_leak(sheaf);
> +
>  	sheaf->cache = s;
>  
>  	stat(s, SHEAF_ALLOC);

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

