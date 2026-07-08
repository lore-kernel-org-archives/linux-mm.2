Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CABC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163976B0088; Wed,  8 Jul 2026 12:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114106B008A; Wed,  8 Jul 2026 12:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BF96B008C; Wed,  8 Jul 2026 12:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D400A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:48:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48B64140235
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:48:07 +0000 (UTC)
X-FDA: 84966191814.11.BF4E054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 74AFE1C000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:48:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WS8hkoF+;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783529285;
	b=YH4Mcblma3YgoEkPDbD9OXf+th7HZmkuPX/8tUOxXQPH88J7GbjLoMhBIOzXtdkmzM84Sk
	LeYi0pp8T0MgOxtsIR+lMN5z6DdSu2hiCBVeioo03jOda02u1TJH+aII8phI6okIbIf7ze
	NnbFzk9+nRkUJmQ3IajN4bpq00ALgSY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WS8hkoF+;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLOlOo9U2JyqXVHzHsOC0fR47gawe6tnhfJUIDf4Krc=;
	b=mtPfLsXi2NfwdefGWcsBTlWKQtoGCX07dFeCEqgBCVuYNANpUoxByZ4sIIWE7ADLEqiiFR
	3C174R7gcIq89OyHSgP3AmTsMEeG3d4e3gQYw+ZEbdjgNYows22+vvZFJuRN4Uz4rzAuGs
	SorocqG68z2emmMW3vFqOUtA792eDSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69723414C6;
	Wed,  8 Jul 2026 16:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E2D1F000E9;
	Wed,  8 Jul 2026 16:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783529284;
	bh=oLOlOo9U2JyqXVHzHsOC0fR47gawe6tnhfJUIDf4Krc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=WS8hkoF+jWFjItBjVm8PU6EB+hB7Uyw+tLXaueXy3NNaD9qM3FKyfYhClKqMe/2ZM
	 nSaRsO2HVyBZnDRKpDGZwiTo2dHKJLR70Oqt8vp97BSEOcgnMXpwV18xpYdcfXghKy
	 vN16vY+MrXfNiZ+2Fa12amxazjJRsJ6hdt2/PCZezYzxvuX/BFSogRh6aA8UWvt7tf
	 auTgCSyZ2M6fOgGcg5IhuDBAldpmy4vsKtRLWCh7brOYkBa9NMJeShb3lMjjDYlC34
	 GrhiANtyOOVy/1IAsaSrS7rPE3vdkLM7fF1WC+C4d4m0PLiokRbMhAtq0P0J64+NdZ
	 l/hd468SygJ1Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, david.laight.linux@gmail.com, 
 jack@suse.cz, jannh@google.com, kees@kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <20260708-welken-dystopie-ertrugen-56a3b5f7ab66@brauner>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260707-wortreich-kanal-zensor-9386ef4f38f7@brauner>
 <DJSPBVXTF02G.3SKLB9EO89GPT@gmail.com>
 <20260708-welken-dystopie-ertrugen-56a3b5f7ab66@brauner>
Date: Wed, 08 Jul 2026 18:47:59 +0200
Message-Id: <20260708-kordel-laben-kopfhaar-1c0dd234aae5@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2698; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YVFc7rBcDlwHKlUCwVkxog+6bJNAmkg4ZND22quLdcs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT51TvOyDgpsaRyy4rE1SbJIR7Kt7OaV/baLolc77ioa
 sGPhdcfdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk7G6Gf5YRcy4tEGQ31Yt0
 93KTyTBrPeu14c/OstKoT/NEv3HmyjEyPLwm/1Ei7PHfmydzLq5+sJ6rpoL5YYTrFK+uJRdtde+
 L8wMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74AFE1C000E
X-Stat-Signature: 7kouttg1pot7h1c86tgrxp3usy4eg477
X-HE-Tag: 1783529285-792520
X-HE-Meta: U2FsdGVkX1+WOTw8HoH0y3dh6zNyjw9/gnygqJZkvMNTJ/qFR96zhNDynDCMZVy13qwclBxSPdCiJ1FgEZXI0DJBb4rfaSTv8Etf9mtCiJDMuEdaWQsRMFgk2gb7wpZ0QtATNcxpnWorOoD+H+EyCeKF+O8A4iSWVCWACOCpHunDP62+Se+a1dsvD0cDWgsKjew+xcmL6dXkKZhYeN+EcJ8ckZ1VkCYSPgTQU97+OFrOuV+nhVeRDMli4oGgOE8f3nTc0G2ElxD/GVlFzMcRHkBOgkfkK9vUc68xY3QwICDaAQ03WHMZW9jE8ghr1ejuIdx148PUm8OyZzbYqZC/piBCw7vWW32eM67r9wx5ANDIBaE9MUuZc7wq5iS+HBTeogYWnb+/ZL51cxZGBf3Iz0yck3RqmiuNmBnBinQc+Pf2altFx3Kv0lPV4CbscFJpOeeyk2Otiy7nLSTVSl1WHjcdBXIDiVKEXcdFhaJuciwjnxb9Vq4E9cSg71y0x8t8wDvBblxq/BFM9sHinXr+aiscPCdsgO3UyPLlPbljShpB9E9ivRhbEGC2xhh2q1iGl15vJjJi7FLVIpC1W9snJ5d89UHPvvlax2yq59j0w8/fWt+fNVQkckxFpKTTcrwTvKa4blQEEyzJX1t+Hw3w1r9u0LargXJTxXEHkr0svgTqrQAJWsE0qHU4oPfxKS9Twgi+ygMqu576oaR2jpb99gaH3dnz7bKf3cuXZ3kD5hdp5ubxMHwA+/Lcxfv9NexrKxVfbDffMrEiDWNM3TbKiCwMMeHtdn1CjcEeV6HZmaCIQSEcOwxtAXRbRy7BBn3yzO3/Pdcdj1qmytEWM9zG5eoGxh4AhEKnqJ9wOz7JSTeHExHQ8MlvsZH+uA6/FGDCNfpyf8BU5IsPYcg3qYXBThfdVUOQG7pIeVTpeHYjPPN4bRwvm2U7INhr4WGZNO6UVl0xh9zLp6XeCFJ/2gP
 lunNai6/
 I56QOT/hQxbexlCGY1NpwGcI8RpUm2xkh6SJNPA8xwtusOWJyzVwvv3pE5nQaG3s3QuuZqvFH5W4rxJMDDB/eupAlPyMXflo6l4MXLm29L5Ftnd1R0WX5VfaFu8V58jZSKzhuFEs2qzJ0lFI8VdLGI3Fr9kVe3WxCfkUPsVyh3DL6wD1vWpt7gwz9npES6X1AtVDDIB2QaEb4F7N8LeTikEi2CCU87nKrYZl5Yjl2IWN/qPXNxg+piZxeiPfhgrX8IEglr9JKBJWBZxyKqAEdS/tvS6ZOrgS3QCceEkwyXpgHLhqeS73DtVB9gz5jsLoZcR+S5ElK2nu/pO7baOoOlB0eYGp4cLt/9eTNMyR5HSmkpRiQ+x0Wc2H2LvUtgRIj/YNXmXN1S+QRJ8sVLWs7+0eHjQZfEkSGL1YhUty1JOoaDqWcfyX15pNY2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-08 11:14 +0200, Christian Brauner wrote:
> On 2026-07-07 15:44 -0700, Farid Zakaria wrote:
> > On Tue Jul 7, 2026 at 12:45 PM PDT, Christian Brauner wrote:
> > > On 2026-07-07 13:34 +0200, Christian Brauner wrote:
> > >> On 2026-07-06 09:47:53-07:00, Farid Zakaria wrote:
> > >> > On Mon, Jul 6, 2026 at 9:01 AM Christian Brauner <brauner@kernel.org> wrote:
> > >> > 
> > >> > > Ignoring the blatant bpf abuse here I think this is quite workable. So
> > >> > > this can be turned into an actual design and patch imho...
> > >> > 
> > >> > Glad to see you think this proposal is in the right direction.
> > >> > Just for my edification, when you say "balatant bpf abuse", you mean
> > >> > how it abuses the socket bpf type?
> > >> > If so, do you have any guidance on a new type or should I just take a
> > >> > stab at it.
> > >
> > > I drafted a POC for you that should be closer to how this should look
> > > like with the bpf people in Cc. I'll let you lead from now on. I just
> > > wanted to help you out and illustrate a more viable direction. Might be
> > > that the bpf people want it done differentely. Let's see.
> > 
> > Cool. I just saw the POC.
> > (I'm trying out aerc to view the patch series. I will also try b4, I've
> > never set it up before)
> > I will rework my qemu demo to use the struct_ops and go through my own
> > testing to see it work.
> > 
> > That looks very similar to what I was researching with an LLM. I was
> > just going over the idea of struct_ops bpf (a new concept to me) and
> > using traditional bpftool load, a new bpf program type and kfuncs.
> > 
> > You put out a surprising amount of polished code -- thank you.
> 
> I would not call this polished and it also lacks any tests... I've not
> given the locking much thought and maybe there's easy wins on the table
> I haven't been considering.
> 
> > I would have had to lean on an LLM (heavily) and from the patches I've
> > put up so far they still have quite the gap to cover in terms of polish.
> 
> This isn't my first bpf ride in both kernel and userspace.
> 
> > What does "take it from here" mean in practicality?
> 
> Bring it over the finish line so I can merge it into my tree. :)
> If the bpf people have no comments or worries than we're done. If they
> want changes I'd appreciate if you could make them and slap you
> Co-developed-by onto the whole thing as necessary.
> 
> Also, please ensure that this works for all the cases you're
> considering.

I have another cleanup series for binfmt_misc btw. That code is quite
old. There might be a few additional series coming out of this work that
we base the bpf bits on.


