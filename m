Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6F0CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 08:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E1F6B008C; Tue, 13 Oct 2026 04:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5326B0092; Tue, 13 Oct 2026 04:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32236B0095; Tue, 13 Oct 2026 04:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8884C6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:52:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03FA11609B3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:52:44 +0000 (UTC)
X-FDA: 85316987490.12.F998B74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67D7220009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:52:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU+MNADL;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791881563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkY85AEaM1dcKivKhNaNHUeuabYCcoXX8xBxsWbUhJM=;
	b=YALcPVVYTzABNktVWvvdvJvHLnzj3aeLUcnlTcrlUfydN9QPvkVbK3ZliKU2+i1f6lzBFN
	ZpfEZEbPYEqHL8AUzAJqegkovBLRltcAxXYIUr8Zyb3SzFGz+jzmZbjj6E45maTo/ZSdcj
	P8qGI/Qdffb0MmXDQzQ+M38oijzbXbI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791881563;
	b=P48iDCqmVVVj4Lm937VvhcXgF55v3KDy+cDHJvp9o0gzn2Sh3YdzTd8PF8Emm42oirCYAc
	t90lj7zwV1dwWLJ0IIzT1pVkIu5tc2X6V8uKv/3/hP67xdqwLpE+h2WhdzlMayaRFDINWb
	ruVq9sz4dyOTtwcqlYfbT8e6yuedNZs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU+MNADL;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A93AF60A66;
	Tue, 13 Oct 2026 08:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF791F000FF;
	Tue, 13 Oct 2026 08:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791881562;
	bh=fkY85AEaM1dcKivKhNaNHUeuabYCcoXX8xBxsWbUhJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bU+MNADLypUQVfbqs4yErGMSqSx8UTEensTSDlB3hILthlX7jXiysW5XCK8w3Wgne
	 +qsKvAVV67misGTcQFezprIijSe//cDAi61D+HiH+PrXDz66M+RQgAsyepQqatnOkw
	 C83dhwA6jl7P3WJ+2YNow3ButEoWQcQrQ381Wo2YqHbIp2FI1DvqBlI7RrrfpxPP3D
	 3WDNSNVnKR/z/zbtd8j1RgF5SPVBsqTN0aiF/CDe/xhAdL4+Nw2L8Xax6doYzIf9OB
	 svfE9gigE0RcgQBxJbDc8PiWLnzTi5f1OeCjkCKQRjfUTk1SJmatj/E3sZV6pc5eMF
	 mAVD56KO7uG+Q==
Date: Tue, 13 Oct 2026 01:52:42 -0700
From: Kees Cook <kees@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610130141.E186B6E@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <ask5kpMS4mpI8Api@thinkpad>
 <202610092014.AAB20B81@keescook>
 <01c89e02-28e0-4424-b32b-50363e4d2b95@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01c89e02-28e0-4424-b32b-50363e4d2b95@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 67D7220009
X-Stat-Signature: 9135g9pf9qsh4bj8y8xbxrpxtt5w7byu
X-HE-Tag: 1791881563-277926
X-HE-Meta: U2FsdGVkX19nk+WmNwDAaPgjzfYMQGGr33wSWPsKHThKbAc7DuIRSIHA/KWGqUSd8hsDcL01pyK25UYLMuPypiXwAp2XonERUdKKx5YHUQUmw6D4tDh+nRZkGDNTJNH1W1sjVgcZo6meGpsGtGYzeeXgZm71Uma9x2r4nMvZHyNiMQth8f3EkjzYrie7kjn0tGhnc3xLtPFGAsG1e39kWOMk/N6trD/l9aMZ2ZcR7e2DG1sjZQMQyk0npfju38CnwEiJBlSAWW/oxnJ4/aVoYOjQxHpGW5enK6Mst1jM+cyzj1BFwnCnrZJcekqAV7g76+0x/ZA4tBQIElK/f0Ej9SjnRgQilzHiyVCv+qfzmFTt8WQEy7boTOGXN7T9oQ550tfdmTQ0delUQ7Ps26cxodSE2PA0+DZvnsYDB0oRbxvIvREkREjvxhhiqnb1k9UH2ZDVOF87AvxRnkhrZKDGlg2g/YW1/FfwYYj3JCur/BxITq05q46xcY1eYZotpmFZ5uMM1KpDVeHwujCMO0xF2cFP3Wz06NgTOuaEq300QCh39obYk3vQi1AIexjYmgd0Fs+Vy0xJFrxXmm1hkdH4TM7uVoJ5ujRBhDPQKPbMVtUWiOxSDaBMruoaiRuVWr6Iqw9vJ1lRVpaVCO+xzc2tvz/yF2pzX+UkvnSPoNUFv6YAeRpn3lYuAWEbnq8UTFKbMVFB6DnIgqWTrd7G8Y/iuPYtObq1jR881pnlzRcHkYYCVftgkvug3IkD0qTt3okexD2Vt4atjAKbfILozb7AjdNREUsvSOZSds22LjDn9PHlcS7rz2sGgTunZbIRFhvcYr+hSnYKngRVLHhCKFU7aaLdjSvqeb+8LNrCLizgOxzBHOHFV52MfSfClvmWWc8Ah/bhHTEwd2PybIM+dra0m5ELDWhTNzhR4SauMIyS7vOUC6Ms1ZX71825QjgpG5+X3G0dJiAHZmQcuoFa6vd
 AaIYpL5X
 lttVkjvEP8XjsIuYZfovtw1LNx9x3PW961zEkI3mr4KIQ17tK3j8Ew6oL3A/rW61vaSa/jys2ThzpKp/986Lg9D2Cc3FQEb3oqg5+429Q/sOFAz8jA6BbwbiI6zk1MfIdaSv43UH6jlfsBfNN1NQDKC6XSK/qsInDx2aKq2widFi5sxf397MSUMC4hLsYGjkmBQQknBfKqOV5DKga41nrsWMMGzcJjxVTmgeXI15hi7a9v3o7LjoDIF08mhs41hlhpJ1rKN88CE1WgrSx/S/RWchoZsA+kZIm/1rh0U7OGlzTYuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 11:19:01PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/10/26 05:18, Kees Cook wrote:
> > On Fri, Oct 09, 2026 at 09:39:48PM +0200, Harry Yoo wrote:
> >> On Fri, Oct 09, 2026 at 04:22:03PM +0200, Harry Yoo wrote:
> >> > When it falls back to kmalloc, kmem_buckets itself should provide a
> >> > compatibility layer when falling back to kmalloc.
> >> 
> >> For example, calculate_sizes() converts certain SLAB_* flags into
> >> GFP flags (s->allocflags) for allocation. We can have a similar
> >> logic when falling back to kmalloc.
> >> 
> >> Though current implementation does not allow this and requires
> >> some rework.
> > 
> > I think the current series does everything correctly in the sense that
> > nothing is allowing for mismatched fallbacks/passthrus. We could iterate
> > from there once we have a need for this where a non-kmalloc-alignment is
> > wanted, etc?
> 
> I think we can indeed simply make sure buckets have the same alignment as
> kmalloc. It comes naturally and should (more than) satisfy everyone. I doubt
> anyone would be needing a more specific alignment than that for a class of
> allocations with a variable size?

Right, the whole point of kmem_buckets was to replace general kmalloc
uses, where no callers cared about alignment.

> ctor removal is clear I think

Completely. I was blinded by the API of kmem_cache_create(). :)

> for __GFP_ACCOUNT and __GFP_RECLAIMABLE I think what we could do is not to
> drop the flags argument kmem_buckets_create and instead require that it
> matches the usage:
> 
> __GFP_RECLAIMABLE requires SLAB_RECLAIM_ACCOUNT and vice versa and I can't
> imagine there would be a buckets instance that would allocate both kinds
> (either with or without __GFP_RECLAIMABLE)

Okay. (We have no users of this yet, FWIW.)

> SLAB_ACCOUNT requires __GFP_ACCOUNT, memcg objexts are always created and used

Right.

> SLAB_MAY_ACCOUNT allows __GFP_ACCOUNT, memcg objexts are always created, and
> used when __GFP_ACCOUNT given
> - perhaps not as optimal as the separate kmalloc types, but good enough?

I think it's fine from studying what happens with the skb data. Though
right now, SLAB_ACCOUNT and SLAB_MAY_ACCOUNT are functionally identical,
yes?

> __GFP_ACCOUNT without either SLAB_ACCOUNT or SLAB_MAY_ACCOUNT is wrong,
> __GFP_ACCOUNT would be ignored

*ignored* is, I think, wrong here. It would create differing behavior
between SLAB_BUCKETS=y/n. If we passed __GFP_ACCOUNT through to general
kmalloc when the buckets lacked SLAB_ACCOUNT and SLAB_MAY_ACCOUNT, you'd
lose the isolation, but not the accounting. (And could WARN_ONCE about
it.) But if it was ignored, you'd lose accounting under
SLAB_BUCKETS=y.

> with SLAB_BUCKETS=y these rules could be checked e.g. with a VM_WARN_ON_ONCE()
> 
> with SLAB_BUCKETS=n these rules won't be checked but also not matter in practice

Agreed. That's what I was going for on this version. But like above,
"SLAB_ACCOUNT requires __GFP_ACCOUNT" means what? Under SLAB_BUCKETS=y
the allocation returns NULL? Or it passes through with WARN_ONCE? I'd
rather not break something completely; better to fallback on a mismatch
so the requested type happens (be it DMA, ACCOUNTing, etc).

-- 
Kees Cook

