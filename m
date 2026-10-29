Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FAFF606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWF/Ngxn
Received: by kanga.kvack.org (Postfix)
	id 7AEA56B05B2; Thu, 29 Oct 2026 18:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7852D6B05B3; Thu, 29 Oct 2026 18:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C6F6B05B4; Thu, 29 Oct 2026 18:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6E36B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:31:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFF4C140539
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:31:15 +0000 (UTC)
X-FDA: 85377110910.06.61DA089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EA462120005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:31:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NWF/Ngxn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793313074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kf6LpxrUPl6mdfAmH/zCqlYs6hvSsVYZyBZpkHm4pBA=;
	b=A8WokIeOLcQbqpfo6lnU3LVfTvW6fYqXscsZ1WtDTM2ddYcEJrA8tMaqf8pVJaSHhvDDS3
	vUC5pmKPR6liw1zgokHk/3cwfsqGgDguvCBHSPRN/z0VELzT00ADpxMaQlPPm4spWBANFJ
	rVfop1Hpiv9QyijMKfh5UltNTGp3Yk4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NWF/Ngxn";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793313074;
	b=qnn+f//hhXEbF+daWuZPAKC4rnZCM29L4rusiItqFdRFfsO5G61id42abrRAFT5gBkLOIc
	fBc0fVUsyw5ZLq7KiO8JtvZJHiLB81SaH5XXOq8LybyYIS1fg7ITNIXD0/R+iN9Mljl1kD
	mmdARgYweL5X2aUULmK8zePnB3RoVf8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2419F437EC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3301F031E0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793313073;
	bh=kf6LpxrUPl6mdfAmH/zCqlYs6hvSsVYZyBZpkHm4pBA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NWF/NgxndhhWgfgsP0U/oEp9QD10ogeqKJmKCCc5bEnRQ4BuA2ciqvET5cGeGUKTM
	 8x1JnNppcLWVGRN9Wzn3Ydq+gjBNIBUfb3jx+nxejwPLLhxKgr2X1UlF3X+Nq0JN6M
	 3Hphuq4TmioFwEW3UcZktZnL2+txazpoFpv8S55ZP/UXBt0Ima93n2lVIkIqI3ORxU
	 exL3w/hyYkxMcu50mgIGi64UyExj+I/ztIt1nuz34TpDyaJltHiUNprZlGGFJ3rDSa
	 Qd5vDxMxnF5RpjkfLFXNvi7MVz6rN+GVTKGict+aUy6R2DzdBHUWhmDExvhSx7djgO
	 H4J9cvjGgSiIA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c45551fa84eso4841366b.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:31:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycX0/q+mwDn7w06ZXVTWr10kwwKUJjSxE2yLJSSYUqNSpczNKtPfjw1v9Vl8nmAZ7PJ3wltH8vXA==@kvack.org
X-Gm-Message-State: AFq9FYLcn5Z+cL7mdl8YslZxVdXzA0uHQlnzFGffGDQX5eY40amWbrHb
	ckFy+z3GkyMxlvJxNPt8ikoS3LX/XaAFRYvudfbIy328vOFilLhEJe8bVN3e1o3AOxdqeXAPbai
	nbXckQnoqM0Lg7ha3RxH60JJJSs1spm8=
X-Received: by 2002:a17:907:3f95:b0:c26:1648:a06b with SMTP id
 a640c23a62f3a-c4ca7a96a37mr36969166b.38.1793313071904; Thu, 29 Oct 2026
 15:31:11 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <auOZBtRqQGzFcbAT@google.com> <CACpmpocqHHa4z9hkZ6YEm-wmzMqSX5WpPLfku7Om=NenRq_05Q@mail.gmail.com>
In-Reply-To: <CACpmpocqHHa4z9hkZ6YEm-wmzMqSX5WpPLfku7Om=NenRq_05Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 29 Oct 2026 15:31:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMukKcs8u81O6ibOXd_BzdYKM124=rVyuyp2x9+00EDvA@mail.gmail.com>
X-Gm-Features: AclHuK9Kyop58VqX76nVFd46J_fFsMna3NEZi8sYQdg_eXsf3y1c_wvVLUO30DM
Message-ID: <CAO9r8zMukKcs8u81O6ibOXd_BzdYKM124=rVyuyp2x9+00EDvA@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Batched zswap_store() framework with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EA462120005
X-Stat-Signature: g54ejhqfqjffcinhi9rxnbbozuq49jnx
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793313073-256716
X-HE-Meta: U2FsdGVkX1+ActP2pnymGYdCzk47mfb38Ohh81YnyhVik/PPbSDXb3LfhG8ZX1L3yudEXmAZkCaFGl1eLyQgNebLPw8GaZw7R6TL/+xTy3o0VakvLRQVVDHv7LUCl8VTvM18luMImiE50JGzDnuOfA27FDRmbwPehb+1QmLqhsPG76XsjeXWumuqx3oSei0thz0JzhDMGRv03/UU4J5dZhbUO66y/mbb1EB6MXzOVyFeGRJ1l+MLGdIgyiTDgHFkxIzhbWr8XB6PU8JHyJCPbuBsImLQ0W2X6iIyLNKq5zEeBo38LiVYbJwjj7C4P1Wt0OIKcNjPeBPdaKault6eme4StTlPMD2hcQg89M7e/TshYFTddQPEHhVeBKNI6Ikb/KHxG8BTNkEJYKYLORBBFP+Z8Wta1YzZWJ1riPaFLq+q/CQ+JDBBJwYg08NpddB+7cmeKF68ZJNRNvfEs9BruAspIFwehzG6VwNYyXxuFHq6kqrcUpJ31FFnyC5ReDYqg6chPLUDGEmRHh2tddd5quZ+d9cOtuM9f507Iiy0qkMQMop/FDQ8IXHr50dwz9z7GbqEbLzvBLdYS4S9WAflCP8D/SSa0uhwuAlEf97xTdHYtnpCWJgpzQ7w3fS7lFD8IztR3+WI5OHZIrCTP0h4znSY8o86FZOY5dU345z76IT/K4+4BQXJ30uyxAcew4b8Wz0sbhE8gWNxXIgPk9XQ0RvcihSNCuNr+LrCRnaoyFq2q9xFXOFviYbVLwNmLppRRtlfIAPZPHSBQW+Jq7Wk0TmsHXLu1oC6iaiL7EIVIzUxdvSVVeA1YLd3z9ly5J5WqXBX86GVQ3vaA48lNVkX6Qun46S2+GDZEjsfSdsJS0IreUiEPzdg+6QI2aFUrFvYUy5qSS4RsDlBlzUoogkPzharTlfXyDG3ikZNPwEOf/kr+mjet1e1zCBRERI78bxXDwQW8uj+BjD83LlgMEC
 Zn0kPhiG
 rWjl0kyCoaA0Vcm4Ho75TBiHSt8cyf0uaslNXPUNbVzXxuejXGo1TY7wKexCROCoVgmW8JUgav9FYuKq0R83mtPj0hju3qHPIQujeJ3mwqIo+Z4HbDUwq+Km+nMLom7x+GaysFkzKpgSxcZzmnBCfdgG/QNlGaDerboQLB/gQb/ImPOSbQte0Zir0LRH4/tzysDAVSK996XmOzDyq4DhFtxoltalI/ramJvVleENTdmLytrZ6sHNdoUSTIxC8Ddmry5vqfE7O2lqo8yVk7jDINkJthh6qAEzoEJdCH6y2T4q54psFpQFy2j4zZtW4UI47mqPW4vlqyQdCpq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> > As mentioned in the previous version, I cannot reproduce these results,
> > mainly because the noise is too high. Digging a bit deeper, it's because
> > the throttling from memory.high varies. Hacking in a change to make
> > calculate_high_delay() always return 0 (no memory.high stalls) paints a
> > clearer picture about throughput improvements from the series up to
> > patch 6 and patch 8. With that, I see 1-2% improvement in throughput
> > with patch 6, and almost no improvement with patch 8 on top. Similarly,
> > for zswap store latency for high-order folios, I see a slight (~1-2%)
> > improvement with patch 6, but almost none with patch 8 on top.
>
> Thanks Yosry, for sharing this. Let me also see if I can replicate
> this hack on my end, and its impact on latency.
>
> >
> > In order to make meaningful progress, can you send patches 5-6
> > separately? I assume that 1-4 are prep for 7-8, so 5-6 are standalone. I
> > also think patch 6 will be simplified if we drop the prep work for
> > patches 7-8?
>
> It shouldn't be a problem to send patches 5-6 separately, but I would
> like to measure the latency impact with the hack and confirm the
> latency results in my environment, so we can figure out a plan on how
> to proceed. Patches 5-6 alone only achieve bulk allocation of
> zswap_entries. It could be possible to bundle in patch 8, which
> generalizes the store batching framework, but let's revisit on how
> best to make meaningful progress.

I am questioning the benefit of the compression batching based on the
results I am seeing.

>
> Patches 5-6 have a dependency on the batch_size for allocating
> acomp_ctx resources, which is for the compress batching improvements
> in patch 7-8.

I assume that this code can be dropped from patch 6 if it will be sent
with patch 5 as a standalone series.

