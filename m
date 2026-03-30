Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9491061B29
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 23:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6DD6B0092; Mon, 30 Mar 2026 19:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE716B0095; Mon, 30 Mar 2026 19:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B826B0096; Mon, 30 Mar 2026 19:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 225956B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:33:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3E8A1B72E8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:33:47 +0000 (UTC)
X-FDA: 84604334094.03.7D839BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 151FA40009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:33:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aORs0BTj;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aORs0BTj;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774913626; a=rsa-sha256;
	cv=none;
	b=oLgB64SKS/1n8hVgn2gEyay/rMrUOALcY8VB3gWsrtNZ5LKxMr/HYbZYtOO2qnE/vi71G2
	4OQMw0KrquHV/GdHy2vlqlvEQ9L8SqWj91rbfqyNl8nqR4BZF0sol0XddW/9lYuQVpNvQl
	IzariOw6l/pbvIm4KJtgJZeDbjKlUCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774913626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xgq7iVR3xfsLLH4dgf+sbPXhflrvZ+r0EzQbB21/njg=;
	b=icqvBLVFqKf7Up7fnpeR4J/BWmSMZZk8+hL1rkG62s/hKa9rk34lONU4egxRCgTlhCctrj
	GaMpE7aABC6WS3pqB85tPsVh6xaaDMs03LTWLjUJ21eF8/Uv+hIOZVK7m214zmKLm7lu0k
	+OSQwg7JTd+iK+iL0g0bc9y3aWpEgnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F18A941823;
	Mon, 30 Mar 2026 23:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C153C4CEF7;
	Mon, 30 Mar 2026 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774913624;
	bh=bS9/1OgZnrRu/Zb4l9Ojffim3IR9pNqgJXD8ZZMekog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aORs0BTjmGynyzTyfZbg2Kktbj85u35tkqCgEbmiNjLwgYN6bE+fCEgU/829jrkMd
	 TAaKt9hENkyYMZzfpGzzWK4/b8xAdGCpBYAT9KC3D6Dkv8njGdDgJlIht5uRsiheUy
	 iQ2crtNCzeeUexf83KYkNlns46upGRczC/icgzkYP6nCfTpxP7pB25roXb6Tcb78QH
	 H0tyjCQV67fHeq0GR5+gvw09q5Nc7f0UHrnWKD9DIpUhtqvw3AS89JqbBGck4W3Gqg
	 A6rhIXhFjCEdWyrbFkZerh4tvHk0kkRKA3K8fM1vG2woVUH8yecgBrvULyZdEdRPKE
	 KvhZozAVxpKUQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Mon, 30 Mar 2026 16:33:42 -0700
Message-ID: <20260330233343.4083-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330060851.4659-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 151FA40009
X-Stat-Signature: mdhwqbijnz1fxqfi5dz6iwj6jyo93ohg
X-Rspam-User: 
X-HE-Tag: 1774913625-544604
X-HE-Meta: U2FsdGVkX18OVSSqula7QwmdF3f3IGnPPAlqjAVUE6mjAxnpLhm16Lk57V+1ZMdc6Wc8u1BtkjlRP9RMKyi2a9aHt0sM0WIXLsmKO1kEheRY3+VcSDsMgrhDNpD3o/IQhuTgr6wQ2J5r0wP/hwNCvGZe077Z/iBVadIX2n5VhidCFje18iu8n6ozsqEkEqQk1ubmHN3Vh8k4raJedQEGbSVEc6FdA4elvlXzkG8OAp3CYhe/KEYvM7XGNUOHGXmy1QXmWnR7Znc2xPplRousyGNI+zEc1Cr3qq2MXi56g3owFn90rLYnsHvsLX26d+NIA2/W59rHxa4TRSZ+1bCAFo7qoUcsvSdw7UWzTY7FrZ9Kw3KNFfQBQUFnJFf4HkdSQelCKmprdvJPbVPLEZKXMMF0NcJ8WbdsbEvHs4fWlXUv5XO0Vf3kZn8Zh36vW+yq/7n1+RYPWhPB/mZmnX3lDC7dtXXJ5Vu+dRY4NIJk8Y5cogrDTKkXk+1bBFvWxwl20xPI78PJr9fsGPDBMdy5vHSpGHysuBwiI1Ybbn/zcjrmfPajajgQZ/rR138LhXRn5u9HjJEQQpcNXqfyW5mieCyHm5dUeAGdMLKs8/K5ZXhWj3wC//KOA4kYEUOtf7+yl5MwVCl4lbousXtC9IMVwgIwAAsd/H8FRALp6lPTmOaTZ+PU84nVLcw4M8dQhlD/QVMtxnFa3fBmirC2VIVJromO2LgXCmrnW8WD1F+ZRwewiqlobnkycUVe8sm4MK80MVetAl6CrJgbi2RKIL8ny1CxpxGofUolsX/Cxxrfqri6RnYjcB+ZGNsUvQ/nK6W5b7hSCrjAky87DJmbA7DSv8wqqYd4odEMlai0CdZYxNCOy0QPDCSHSfbDOfieZScB6/+pRObJmlBtNRxmLoUkGFU4BHdFbrZb4ijsV3V1Dyvl6IDOGl+utopNDnhZeTDxUd8cGltc5khaq7kBNGw
 oL7it2HO
 zxjlzQFuU0xcJsHltlc2k6NKGoPy+W+zLe39xPDe2zYAhKsaenR1EAoYPQYGKc/FysM28Y7gr5aO0KGvLWltmGBHJXxlFgt3yY0QTNoCTHgkbcfaiBQLotQEAY1eOLzfekBIRXWLqqxtES44GZcj8tSgJjd+qskL3Od6ZPPEd3vzcXaAO/6+MQ76hWqrI1XUHl5C+a0ZDE9E1gf+0zq9iWfZxdvFOEuTWXL75BK7BjVS0Y2p1NaWnx54ogJsXocSCneefj5cJk0pCW6YPAwZYhc0S6bo1WicxGzMQo/SCcCAnjw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 14:08:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Sun, 29 Mar 2026 08:15:07 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Sun, 29 Mar 2026 15:51:07 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > [...]
> > > To confirm, are you suggesting something like the first approach [1]?
> > > 
> > >     if (input_addr_unit < PAGE_SIZE && !is_power_of_2(input_addr_unit))
> > >         return -EINVAL;
> > 
> > Yes.  But the real constraint is min_region_sz, so testing it would be more
> > simple and effective.  E.g.,
> > 
> > 	if (!is_power_of_2(param_ctx->min_region_sz))
> > 		return -EINVAL;
> > > 
> > > [1] https://lore.kernel.org/20260325071709.9699-1-aethernet65535@gmail.com
> 
> Thank you for the example.
> 
> The 'param_ctx' you mentioned confused me for a moment, as it doesn't
> exist in the current addr_unit_store().

I'd suggest to do the validation in commit_inputs handling path
(damon_{lru_sort,reclaim}_apply_parameters()), rather than addr_unit_store().
And param_ctx is in the path.

> But I assume you are suggesting
> that we should validate the result of 'min_region_sz' rather than the
> 'addr_unit' itself, and this check should happen within the
> addr_unit_store() callback.

That's correct.

> 
> So, would something like this in addr_uint_store() be what you expect?
> 
>     if (!input_addr_unit)
>         return -EINVAL;
> 
>     min_region_sz = max(PAGE_SIZE / input_addr_unit, 1);

damon_{lru_sort,reclaim}_apply_parameters() does this already.  And that's why
I suggest to put the validation there.

>     if (!is_power_of_2(min_region_sz))
>         return -EINVAL;

Yes, this kind of validation, but in
damon_{lru_sort,reclaim}_apply_parameters(), please.

Someone might argue it is better to return the error as early as possible (when
writing addr_unit).  But in my humble opinion, the benefit from the user
experience is not that big, while it could make code unnecessarily complicated.

Then someone could ask if we should also move the zero addr_unit input check in
addr_unit_store() into apply_parameters().  Yes, I think we should have done
that in the way, and I made a wrong decision at the time.  But, I think that's
not a big problem, so I would prefer keeping the code and behavior as is,
unless it turns out to be a real problem.

> 
> This keeps the fix local to the modules, and directly enforces the
> power-of-2 constraint on the actual monitoring granularity.

Yes.  But again, I'd prefer doing that in apply_parameters().


Thanks,
SJ

[...]

