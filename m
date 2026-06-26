Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04808CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26F16B013A; Fri, 26 Jun 2026 07:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7B16B013C; Fri, 26 Jun 2026 07:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0D36B013D; Fri, 26 Jun 2026 07:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 868C96B013A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:57:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E097A120422
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:57:16 +0000 (UTC)
X-FDA: 84921913272.22.550661C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3CBD9180002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:57:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bx1YAzWS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782475035;
	b=7tzotq/5lrSLlaPGORdLXVXkQqzzKK9DD5l9I0mFwoWE3D2osIImkk+9hSMpQHvAt45i6w
	GEnql4/05d2R7K38hiO21zf7Hpd4qEb22+rSfvgXXFAO6Oc3/DDqReXXCQfmMcbIDSZd5h
	SAZkRFrvlDMfuwqtDSPwabogwGsZORA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782475035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YpMyR+qlvlqRuVjps8vxBolsZnShA75KeyYR5QZWZI=;
	b=xMpzKkHPvEZyeM7U0u82IbYjIx1HmQqrU6+BrbX3Pjb938IXNj7hTsO4LHgIBTpfFzo1DE
	u8nR0xn/vB+p9fmQOM/PO63InZsxK6Z6F2vi7/gqJcedkvqAscWTsJH4pTKT4nlYzbCXtd
	RmGXN2jks3TBllk3LFBqoYFWQrBYuCU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bx1YAzWS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59DFC40ABE;
	Fri, 26 Jun 2026 11:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F51F1F000E9;
	Fri, 26 Jun 2026 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475034;
	bh=9YpMyR+qlvlqRuVjps8vxBolsZnShA75KeyYR5QZWZI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Bx1YAzWSid7owFWxMCfA0186eDDpPS6Bk1iUsg+5y5Ugl2P9liT+7/arQf95DTE4S
	 HW+dq6UYThVhQ9NIFmWe8tFD2BlNMJWJaVVk+JZX4xuPvF8cmg5B3rOmTwW7ZTRg58
	 T7RbELABusb6j+rLGCeH8mpsvLl5yXS00wxwbkJHNLbmweXgbRfVy8v7Owq6GAzcY7
	 3kHxztfz8U+TqCWxUt9uQydBK4QYk3UwDBX+mf4JwlBYIElybqH1uEgseynnD70u92
	 +7njhKUWT8E49vgLRmSWdFkjWBnLtyosTqxRf/6QkwYBJJTCqHZR9Pw/4v0hWtMQep
	 lpa9skKfM/ccA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  David Matlack <dmatlack@google.com>,
  tarunsahu@google.com,  open list <linux-kernel@vger.kernel.org>,  "open
 list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,  "open list:KEXEC
 HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
In-Reply-To: <20260613012521.835490-2-skhawaja@google.com> (Samiullah
	Khawaja's message of "Sat, 13 Jun 2026 01:25:20 +0000")
References: <20260613012521.835490-1-skhawaja@google.com>
	<20260613012521.835490-2-skhawaja@google.com>
Date: Fri, 26 Jun 2026 13:57:11 +0200
Message-ID: <2vxzwlvljyzs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3CBD9180002
X-Stat-Signature: ho35eksrto5ny5npfet7yhzn9xp6dae1
X-HE-Tag: 1782475035-618030
X-HE-Meta: U2FsdGVkX1+PGMMT0qCwMTEbfVZpwtbCxL7ETbHFyVDnwhhhBAeJ3wj853CN52BaI9pE3+puLO0i3FBGfcRQFAKHSrw2vJx/PH/kvqZQbNL3rbKO46ZBjYDrOSNJwb2PYquaUArioSV62Aw59cenw3LIKukOkLnigr4Lmbde251D3dnmUKcpR+A12gH0qM5EYSL3Z+l7W5FGwFCvp2VDfcmZk20YPlwAeRpn5TvR0HThJd3N++hqyD5u4qlgXyZ6pXjh7+S4DwK/oPGqFzE7qBKjh7xF/c0+lhZ8U4DMh40cCmUZrhN/XdJGtm+WmEuB94o5013pKLehpb0ZarMmU3zzfAJwojFSOjshn2axGtttoWwIW+Bo/sbUkvAoZjUGlbBYULe4hWDwBwmV9SzCUtEAMWOjIV/P+DtVnRtkuQgpOsYZgnQcWA0l2yP8EaxaDi7/QtMdmX+B638DWizUB/mioOaPcUpsK9QvWp1GJf94W0nSGjs6z3yM6hipB0yhrKay0fMMg5mm8RbxUX3d1VomKLPeT4UinPTSeLlMRb/rsq6HJ83pFG+8WV7v4nmuIlUJgmqEyCqt1a8lnf9x2SmBMF2clqsfsQMCNRVPTINT22tmgHgU/8ehw8ByiAnFrQ38+7yfHvkJBs6p5SDcjSTeVqKWfX+x8jJdp+gblHQdtXHKVAEe/l5T0gqhQlzZV7eh0n7hc9Z6IEeIZfwlWyEVQw6Uohk3qf75nFYh58JWqyjGilaVJNnbY7ksxEOmOtHWvp6dOEzjUVXfdrrAZYDSwbbnRlcq3mokCWGPfpELnSeUMzJ4nLkmw8kXVjAEX+2sLKd6Fasxfj7td8JI2l8Hz66XaBeyYMxqFoVs8p2agYLRieV3ORU1ANtNxywLkNvUUmQu00/6R6qojA9MeXY/DGNKS3lJVUj5JYiVxXLHc5j2DROLNZ/INCqcWlOcd4JoMYGROoWx0UZxe2N
 qf3Lz44X
 UITgqzyiho1SVVHJk227Zon6W2V2D0wFmhn2cdj09rNdzaEvFbozqAGa7Efis1XZfjGcguV8CmEa0mB0wGGUxeZc4MkT6Vf0p61geLWI9M96BtVtumxmRCB3PpZGqQ/oESgbpbI24u7h4rLbq8NbRcrkEHsMwKxU7fycJdbNdKw7NyU0QoP9t57ncANA/wqmvVMSrxS4fZ1BH5Cz8Nws6w8pccx6b24WgglI7oKgS6YId/6q+3hSOJI4FWgI4po8ZMnSNPZfnt+MHtMtz3fGF43H5dC1bOBxeLT6i1ETFaZH9ifjSeatTf9FDHm0ERG3PkxBpSDGmSHc+wCS59RsGpAKKpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sami,

On Sat, Jun 13 2026, Samiullah Khawaja wrote:

> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Live update orchestrator file handlers depend on the preservation of
> other files. To make sure that the dependency is preserved, the file
> handlers needs to fetch the preservation token of the preserved
> dependency. Similarly during restore, a file handler wants to fetch the
> restored file of the dependency.
>
> Add APIs that allows fetching token of dependency during preservation,
> and fetching the restored file dependency during restore.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>

We discussed this once already on a call, but I'll write my argument out
here for everyone else to get a say as well.

While it isn't obvious, this patch implicitly defines a part of the uAPI
for live update. This patch says to VMMs (or other live update users)
that "you can restore dependent files in any order". That is, VMMs
don't have to restore the files in a topological sort order or
dependencies, they can do so in any order and the kernel will manage the
dependencies on its own.

But on the preservation side, VMMs still do need to follow the
topological order of dependencies. Because if they don't, the
liveupdate_get_token_outgoing() call will fail and preservation can't
proceed.

In simple words, if file type A depends on file type B, VMMs always need
to preserve B before A, because A's preservation will try to find B's
token, and if B is not preserved that will fail. On the _restore_ side
though, liveupdate_get_file_incoming() implicitly retrieves the file so
the VMM can restore then in any order.

I don't like this for a couple reasons. First, this makes the API
asymmetric. If the VMM needs to manage dependency order during
preservation anyway, why not do it on retrieve as well?

Second, the API is easier to misuse. The VMM can restore A but not B,
and then close the session. It will go on its merry way never knowing it
did something wrong. For example, guest_memfd depends on its VM FD. With
this patch, LUO will allow restoring guest_memfd without restoring the
VM FD. This makes the guest_memfd practically useless. Yes, it is a bug
in the VMM anyway, but if guest_memfd restore was denied, then it would
be easier to catch.

The kernel will keep itself safe in either case, but it will make the
API harder to misuse. And you can always _relax_ the ordering
requirement if there is a need in the future, but you can't go the other
way round.

So that's my question: do we enforce restore ordering? The code change
should be relatively simple. You just need to fail if the file is not
already restored in liveupdate_get_file_incoming().

In either case, please at least add a piece in the documentation about
this ordering. We should not leave it implicit.

[...]

-- 
Regards,
Pratyush Yadav

