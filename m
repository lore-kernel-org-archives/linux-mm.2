Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C145BCD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E046B0005; Thu, 11 Jun 2026 21:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C651E6B0088; Thu, 11 Jun 2026 21:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2486B008C; Thu, 11 Jun 2026 21:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A95916B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:35:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60FE0A02D2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:35:20 +0000 (UTC)
X-FDA: 84869542800.10.DA316D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6B99920002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:35:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMPTXrt3;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781228118;
	b=uulfyz4UCzkz8lhM/wKqEftHOCOaUSFC9j7YjwmcVKui1SLNuF+V8juXmcCKV9riBmAktd
	vYLpc5GKrfGCfYBj6KSrj+37B8dmRvA/sNGwv1RiQTbJFKPHhLyTaUTus0RlDI5frWvZOW
	9ifmg+6p28NMHS0ezTSW4pmmbuLi0eQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMPTXrt3;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781228118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ajp+XQQf+oTx8UEvEyFI7f4v5iEtZ4B/TtXbdryHCY=;
	b=ps7AV4zsvvhzn4j+HnajeIpKaOXGOy19S1za03ChDVV7d6mp0NY3oC8GQpmRZy6yFCgSHO
	/UKSz6F31OjltJ1G2UfEW6mo9JL/R1m8nQpicBGB9xzBV8RbfcP+8XUsV1CsjUchYftTTY
	PRFcDfvRSRNwwi1CreNkM3nTmD57XQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 518F7441D9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DBC1F000E9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781228117;
	bh=2Ajp+XQQf+oTx8UEvEyFI7f4v5iEtZ4B/TtXbdryHCY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NMPTXrt3OBa6MIunrNYoSON9J9XKfZbp2EwHKe6KmQ9LQyCmIWfa2CEwpjSJkYaRS
	 VsDHyasqaNVqosJ1eh0Oqx0uC25whJuuVOGHdY5Pf1i25P1Kc7lNotz2lZUfjU6nTf
	 EBhB30+PVtLR4TH2O6fJACEqM/GxZOzC5ILghrU/Gf3P/Kw0jurMW6+0Xag2XTPgdr
	 eOUpt+owxo2XGLgAbnrgkCBXoJl/9KqYzw0aNAbizY4WVwT+sXVGuYTshKrinags1q
	 EHmJogPvQAybAq5fOBYVvXcq5RE+Dyhz3fIiZCMb8VVEBOi+dVNUOZwIosE09JNoao
	 C2fK/bwc1G2YA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9157b949fc7so43811385a.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:35:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+mbU1JS4pmGgy7zIxE840RFh/oDJF5+d3y9HVefJepmeZUqJ9finvjyNzZ1pMb8eJf3OHJwm5fkQ==@kvack.org
X-Gm-Message-State: AOJu0YxRNEBInuzT5QuvO/wzhon94AHggN5Kb2KOyCJOp2hD1XOsZDmR
	ymGeIeEw+9L5N/0usrAyrJoQJ3632q4J4WsXR82LFGOJ1zyb2O9/YTq+Y0X4/gB7KQpYLxnsU/1
	lB6NklR81Rygj7MonrQNIMbjlJ44yUts=
X-Received: by 2002:a05:620a:2718:b0:915:a217:a96a with SMTP id
 af79cd13be357-9161bd37f9cmr82348085a.53.1781228116584; Thu, 11 Jun 2026
 18:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev> <air7FCRQneIPiJ5l@linux.dev>
In-Reply-To: <air7FCRQneIPiJ5l@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 12 Jun 2026 09:35:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zU=UYOA6MaM6Wsx=yB9r4rta810SUDChO3OcF_EKeW2g@mail.gmail.com>
X-Gm-Features: AVVi8CeUWluT1JIEy-UvHfyHjCL2C-cM5WlZPsTQXONUplECePle5aUy77eEa-U
Message-ID: <CAGsJ_4zU=UYOA6MaM6Wsx=yB9r4rta810SUDChO3OcF_EKeW2g@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B99920002
X-Rspam-User: 
X-Stat-Signature: e3frckudn6ska8a94iday684p76how7u
X-HE-Tag: 1781228118-816266
X-HE-Meta: U2FsdGVkX1/xUT60MPQGM98xFau1GG7DVoQphOEtURETLukQyaSucNFKeizXxIHLycopUvcZ/g5SzAhmNjp4ESrieKtKBfAZlWRAX6lB5TL3dLNgqR5AN5x+L/yObk9z88A3K1j2QZeG05nz7nzwPATVZEPRkX6+gDX+nU/+/tCZA2nJIVo6ySSP9M7DM8HKneX2LbvRlkdLcx3rBRxjqe+KzaI2O3qcPMZjp2WicQY+NJaxo4J/hyoeLZ3g8SVHyuoEH8KwfHSFzf8+s4RT0Q5yzFXEWBxDJ7/gqqlTxpYLG9z8vZH3KafkKWVBh5uYbAgl3j2QZtcDoL44Bp74BOz7/6aQpZmirYUM+/Q9p07H5i/VQOIslO6k3FCUtjVleNCBqZ3KqW60niZmnZ1UbiFanY1wBnu94vP3f6U75y9QgCQ1kwP4riDnkD35m/3jxxIEpzt05giPcOmlYQIn7bNi1NUlmcRmro2lKeZK60BvaQ5PFB2ApXIz7mZQ3xIHIbRTApGIhGpDwzmvNbuD1A5mTLW1n147f/z/ZCb60iY1D7OyeWEnFmC6hnk9CWZdfSXVn6vA4VfpMxQvXZ4jzXLwLTP/8YZ7W7abrBo3UxRIkFUgOgLC/Scq8TV07uEwzKRKSAaGlBsjBsD1HtKN80qX4r+pqsFleoFCbo0I6IyHLBj7L1EbfmNL9KnGjBSj891i5FOF3roSOKvaDubMXoFtMuBh411keZwdz855ZlZ3V6cLw8rJ+GjNmW9EO8Tic4kOrm2e5EsYQb32WJxKLcpyqly7YSQVWOdL5YA6YmEzJBN8h6Mm0g6zhxC/Eyka/sToURAVYv9sTqnfD6Nk2tGKOmM8aOl6ujm5j/gCnbTJ38ACNSKA4JMsD2v85M1ztmtBeV20ETRHxucLYap/bV1iZyj4yYmqCvdcElUUo8hdMxlQJnN1QBrDfF2jBkoYTsLn/+RZQ4iAapcIEDx
 OGu2tnYq
 hWWziKOksEhsoIIgpbsWgzFMwoxqvXBFYh/WrdrKQ/PNUIwPLQXkldbsNDvSueqQBW3qcvlH6/o/uzvkBEAIthcsBPcmtAq+xptAchuP03lW0mMVyyl9g0I2lmFhlOPD/lQ7x+OrtHo9iCtvSDyLxfaDPCwpILWoyWA7O8Z1NuF43ps5hhYX/10idCtmk2dtIPRMkcxDMW+SFFw11qW0c9nFXqqzbrwGtPpI1RL0T9xI49cVuYHwk+TAxD/fqZdq26ADXWdwf2dCSGTegCNGeC7tP4qt7zeEg11y+SCy7onnt2iD8hcw/AJTsEDXcPcMrJhEj3+qoFCMHTO6+3yhaPolee2EzKBWeaztm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 2:18=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Jun 11, 2026 at 11:09:43AM -0700, Shakeel Butt wrote:
> > On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > > We always unconditionally drain the LRU before retrying anon folio
> > > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > > drains.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/memory.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 56be920c56d7..487a34377a7b 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct fo=
lio *folio,
> > >      */
> > >     if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > >             return false;
> > > -   if (!folio_test_lru(folio))
> > > +   if (!folio_test_lru(folio)) {
> > > +           /*
> > > +            * Assume folio is on lru_cache and holds a cache referen=
ce.
> > > +            */
> > > +           if (folio_ref_count(folio) > 2 + folio_test_swapcache(fol=
io))
> > > +                   return false;
> >
> > In your experiments, how much amount of drains were reduced due to this=
 specific
> > check?
> >
> > I wonder if that data can motivate to introduce lru_add_drain_folio(fol=
io) which
> > only drains if the given folio is in the local lru_add cache.
>
> Actually if we can peek into lru_add cache and folio_ref_count(folio) is =
exactly
> equal to (2 + folio_test_swapcache(folio)) and folio is not on LRU then w=
e can
> just reuse folio if it is in lru_add cache without draining, right?
>

The real problem is that !folio_test_lru(folio) does not tell us
whether the folio is still sitting in lru_cache, and determining that
is unlikely to be cheap. We could either scan the lru_cache or add a
separate flag to indicate lru_cache membership, but neither option
sounds particularly appealing.

Thanks
Barry

