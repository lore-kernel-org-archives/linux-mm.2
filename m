Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A52C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416F06B0099; Thu,  6 Aug 2026 13:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAAD6B009B; Thu,  6 Aug 2026 13:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3041A6B009D; Thu,  6 Aug 2026 13:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 116086B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:43:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E9BB140167
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:43:08 +0000 (UTC)
X-FDA: 85071565656.25.CC877DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 97D9B40008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:43:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIkNnqoi;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786038186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyzC+5zQ3QHE12KeVW/t9CJutmrw2wTg2NMo5Du4Y/Q=;
	b=oSHzeD5Qt+GoxwgwcaByWzVCvV7P1C2+UR0DQqOwHmOBV7BNxChvAloe602QSqKVGVOcrB
	qLITOOu5UlXSE6uihVnmQId5fnAl6h8hW/ysk6277gLauuvLhpJpZXIslX1gPA2s2bC8dd
	TJh938gTLKeKPAtpkMePLOoJR+kXdjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786038186;
	b=nV7SOO287BFD+mW186CTUcV5Vv61/hrRyNFu2ZEKtXo7nfBWKXc5WeiILaRugWxpksBBiT
	Cm+r0s25AH8IBiclgWvlyenDdJN8R5BdguGSNFjhFhWxBW1ZbZR3g88nEr8WJX74dA2Coc
	nYi3SGj8WVXIl6c0Q8zbFeuh6gJI5Pg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIkNnqoi;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC5954150F;
	Thu,  6 Aug 2026 17:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1851F00A3A;
	Thu,  6 Aug 2026 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786038185;
	bh=KyzC+5zQ3QHE12KeVW/t9CJutmrw2wTg2NMo5Du4Y/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AIkNnqoiIYcp6+Pc9PsHjso6YL0gdXJ/2VGuqozURz68eHASdeFG9c0XTwM5RQs0n
	 lLazwK4WalOm9uJTNsO4jiKwC3RG3xNI0veXwJmwAAL6nbo3A8gKtDsmvKRUrQl59J
	 6NAeOqFTNzi5g+eyAu4Wh2ju2wvfprGKw74cltla8TEtQJtkAz2T2bJthDFG99i0b0
	 uNps7U2JW0qb499tn2EF1mWkntR9lNSiUCIuK57uMb+wDdW9xIYyZniPn9yqXUS5vg
	 Q4MU/VTiXnV8J8qyrMqVq4tHRtQDQ2qoUrQbcGsXvlWaExGOUC+MKYZjJiChN6Iw+b
	 LjMC1Y5xbh39Q==
Date: Thu, 6 Aug 2026 18:42:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: AI slop (was Re: [PATCH] mm/huge_memory: let special huge VMAs
 bypass the THP) policy check
Message-ID: <anTHSfP9Eq-2-Cng@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org>
 <anSZpAjt84Pn7O_b@lucifer>
 <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
 <cf533fc1-db58-4c6b-a206-a8dac3fff391@kernel.org>
 <20260806164517.GA140051@nvidia.com>
 <anS6hcgMkEJocbDJ@lucifer>
 <10b07d00-57e5-499b-a136-f2148e870d9b@nvidia.com>
 <A403B054-108E-49E8-BFF6-BE5EF8E61C02@nvidia.com>
 <anTHABoAYVUn2XiH@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anTHABoAYVUn2XiH@fedora>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: yttjoaa1r41c1ckae1p4kooutuh6rgh6
X-Rspamd-Queue-Id: 97D9B40008
X-HE-Tag: 1786038186-582806
X-HE-Meta: U2FsdGVkX1/ywbn6IQzi4PqeK/ewdj0qvqnOUicGTkCeTbJMOVv30mMdpFrbNvy9f8X1sZ2CQREJSfxpk/7oecoVHbVgw9hUki1RD0nMfjG03+0iMBa7Vp/pRvXrGofIR8fshqp1dHEXmlbS03LbMvNMPwjP6rpNAp8XuK7FX4jDJdl1A69SdK9RRuTepnWAVayKWq1TLoab8X6vyErxDw6X1b94vJUsN9e4nWW90pjPWKJp3fuoVgxeN9mh1RaBd11g0MUe67ya22R+TA52Sc4o+FNUWm00V29fC/iJHEKRifVN6Y81LxWFed6hu4mZxrlxddFBd/WwOEkgiWTwfdWlTvE4x74s7ikUp0epMkJ6UasNVAZZMeSVzOgefrTZgi6U55hZVKn8RbJCaWhcv4aSdUDfjfX5Ma43++pMZJiMVSYQCtm5RlCoiiiMyngVVk3OOG20tI1SNhUnBZRwyPH9dhCoO2hIVEJnr1RVc61uOM3cyT7fbeiIO7JrbyEHFI6ye5SKUV1udU2J1hxvJRHZeuMz8CE/LEV1Uu3Qa7iTWv1GbmvqwLkRMT1B2/8c3R5vhBPOK28QWbSw3hX6qej0dREWn1PQdqlC6crB6FgDNNfcLR24aWXtvfZYDyTGLv6rEvcUxeN7G+MAMNOrJPlIkYloPpvl/6a/p4FuUehW3BPluKyQ88SXR7VYv71K6FpnQXE0ct3WqO+aTIhwladOJfM6YAXULphmIKaVytXdkTA3K4MHGsM+51KtKKZ3q9ViRheaw3SSPptiLM2r7nyVc+ss3UJMkpnUCoFo5Eqh0ZBSsS/ALW3lt/h3Qox7oJuDOxA+OKeyrMNnI/t/dXisG5u519ZsZzhuCiE8B4WVTgblzhIOtmVPhqRN6Az3KUo1fUbz1njRY1SsVcMxuNycnh1zQMblXBejInB9C9/6JWgu6flUxzKqOhcWT5X6i+av4BZC4hvkxmfgqNv
 vmZ5TT17
 fIrpQv7syX3F5vuCPK78PgrW2gOnIhmFoTCtik4kAUjYq96seyMiY119BErINHU5YqvRP1yQd8ki6/tJSN7ktl+Z4MQXp2Yo6bjaT5G9A2xCxZiRGKzFMPwfApWNwMnoQOWWXVYJ32d09hUZwBQwnGReLt31L/cklBXRndqFRs5tCsHHo43B/nOiW4jcNA62/CD3R/srb+/3EcmRgcKAdoS/D6olgGmbNMtltlR1sPiKeCPReUWkyETvGYyL5WfJZBl8+wFM0SHekZ96jtGGT0PBcFnN0oTB1L2rVKfpUV4eAmk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 12:40:16PM -0500, Gregory Price wrote:
> On Thu, Aug 06, 2026 at 01:08:15PM -0400, Zi Yan wrote:
> > On 6 Aug 2026, at 13:05, John Hubbard wrote:
> >
> > > And furthermore, that's not even a change in policy! Because traditionally,
> > > that's how people started anyway: with small patches and patience. It's
> >
> > Patience is the key. Seeing patches refreshed within a day is killing me.
> >
>
> some kind of 2-stage filtering mechanism maybe?
>
> mm gets everything
> mm-review is curated from mm to reduce noise
>
> Maybe would have to leverage a model though to surface critical things.
>
> Just an idea.

No I don't want slop going anywhere, at all. Nothing.

If you slop the reward should be silence ideally. And certainly not anything you
slopped going to any kind of branch... :)

The slopularity is upon is Gregory. Behold the desert of the real etc.

>
> ~Gregory

--
Cheers, Lorenzo

