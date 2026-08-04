Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1782CC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4546B00DA; Tue,  4 Aug 2026 10:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BC86B00DB; Tue,  4 Aug 2026 10:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8E66B00DC; Tue,  4 Aug 2026 10:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2F796B00DA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:02:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B7B7120160
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:43:17 +0000 (UTC)
X-FDA: 85063552434.04.ABC5156
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8DE73180005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:43:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWOdWAkR;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785847395;
	b=a3ObSefYGO8T6eJb1YUQLSC2Pd+QedDEK8ME19soTAYtKch5btd8erG8CR0kSFgybBNkcz
	JGnFKQ5Tg+XnS+zwjEV6WNf7HFheEkaLo8g2UCtXJtJJ9NkDLocIyTQZScX9diYmAtOzjo
	8dB27cPXVYZfXADhgo8TGK19VdqJezQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWOdWAkR;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785847395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84QprRHwhrz+Nkiqha49/PA9CxYa6FBg6w6noEz86g8=;
	b=Rd/R4KqYYzBc8Vw79heTuC5lABs8RTmyI9F8XAn9qWDxe0IGuHGVRLbDGrqJGxCL9VouxL
	do6RfTEmODoHVspfDO/ebHSlXvWzHjucm/9pUSvHsH44Q9hCMrel1kam0nJGa8C/Dp1Vtv
	oxXDG16XbhxJZjfKyeWb4cfgO5nZ4tY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2F5441B35;
	Tue,  4 Aug 2026 12:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F3F1F000E9;
	Tue,  4 Aug 2026 12:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785847393;
	bh=84QprRHwhrz+Nkiqha49/PA9CxYa6FBg6w6noEz86g8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UWOdWAkRkJHZkJxmRSHFZYlpGkORiS1kGH2fYisI2uada2AxRE+GeYyHciAVPQr30
	 MNZd6q6kuVhstTX1GSsaMMzewptHToT1kUH0WuveZ7i5IRR9AZFh985L1e0HOxs32H
	 wXbHaoX6vi/rrkSLGy0movwuGO/cWJNMbN6vwTmSwcxFllPwoOqPNM4CgVKNryMIWa
	 OEW9DeHljNMC9Hvnie84zgLGzjIjuFDoip29CmY7iUbIDxnCzqtPygXPJBrUyyRV78
	 YpoweashigOAa2jiQFa9l0ujqRtV9rDaln9png6xRNUr3jCjFaCfpjuh2tbsAOeuHv
	 zbwT/VJNUydlA==
Date: Tue, 4 Aug 2026 13:42:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH v2 2/6] parisc: Drop own implementations for ptep_get()
 and ptep_test_and_clear_young()
Message-ID: <anHd7ho3daZFZ-4r@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-3-pfalcato@suse.de>
 <anHHyiHqYf3yLf2K@lucifer>
 <anHcJZYyz9Zrshdm@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHcJZYyz9Zrshdm@pedro-suse>
X-Stat-Signature: ra9ua1inskkbbe3twrjs6dki1b49rq51
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DE73180005
X-HE-Tag: 1785847395-149985
X-HE-Meta: U2FsdGVkX1+ohJZ6qew3pBaC0mmCrBKnfkxCk9DCUUPMg5It5YHxpmh1wgIIUXHdktUCj4PRameWEH+EBcrh7uQT1rCvVkjVHpjK2815wMFmjzgmNf9e8neM8vLwXIQdDUZqOGbBcCgocnAw4zxPN8aP+F5R42J/2vRaIKxlLidPQG0cZ7c1gpA8YfZMxLw7eCn7Hc1ovicBoKzY2D4pZM13FOrFW3iI2xNsUeXQRyeHeeQZXOJU8nz9yfHsFdajuKlP80Mbyr5tcbqNSDIhwMq/OmyAgaikbheut6u5IAOh+nI7HCAjWl/OAEhJ+LfypVTxSk2Sraf5o7OlX1m6gUJqyEVcLdsnx+R+9mTrPKgBPEPeEE8owmjM7UTcsenjxNucjvLB3HjqSUO5LUfFabtIggOpk+GCo1/d87Wt1tE8JHt0A0ueS8PN0hp5RSaxuFkahmO8iwGyQDqe96mDWaunuRr/SAW5MsVyEJwtHJ+3NR3OBO+ozrftCQ/NfNdb5hcJw0hIfTloli/K2xexmnHGJCNrbLPeDknoQ1794xunoxISK1NFaXi0gTmwlwlDEX/jRzhcv7gHqHc+YLBsLTervvqB/yaacU6Azsv/gfylw7chk/mVADbtMUAtuSut3/KST5hfM5hRXYcMFWKH3AZe3SXoUQAh30Vo0sAjoddeRbhnw7naLJW+2v4/CUUYTKeVu7Ap9sxqVohtDqBFTU+Mz5KA/2bAhVHqxFIviJnV2a/Qq4eIrhPzAt8xoWTnePk8KxTkWMpYUQEwmAmdqf+HDIqueQubXvl22gjubYfy0fE8nQ04V9B1s29+ceGTg0B2VDor6w89ndCcD24GUQt24NR5YVPro/GZ3+6fzDer7nKGAnrzZYSNTLwSQ79TtV1j5SA6ozvUgoodGeVZ45o+UTdVq9wdpcHS9bvJtViECELJhNL1it2OpbcvZRLMxnP2rgoCkrUMbELXrW+
 RPowR1Wr
 UtnsKmyJy1NKS1COtibX23aAs74MKTSFktUELOdUdJmJq5dMOPY2Q1HjrbAKTJNL8jsqN0c/RCN1JID9+6gQAbeOW6Pjgt7GHFL8EcRE0uTpnY89V4rPcoGv4jd/Yf02zMKqgv+aSPNbL+bv1PsQtK/Vf2LL1wHZ+Su8fcgIeYjeu6G14286dQaBKZLtn2iE5JAJNLo+DV7FAyUk9F8V4wECIWP1D7mW6FRs70Q7dp/bJGeniCGdEtksYjLl5HVL8MHPUFzxe6XVuDpZ5LNOODyG4XuLaOpj34w8U1Z2wFXNObTmWoKpqA+b7lv9ZOAsZSy7QG/TWnnZgoIAcq+LzyNnQxOzTmfRDe5gJCr/iJS4PeFJM8A0p+SLSkaN7b71pC7Oaw2AvjbtL77fMOYMepq6ZUBpTFZ+OjW4dqOI9hCQT4rCkXJRGMN8iSY6kgwfOGx0JTAf10BAssuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 01:34:41PM +0100, Pedro Falcato wrote:
> On Tue, Aug 04, 2026 at 12:11:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 05:43:56PM +0100, Pedro Falcato wrote:
> > > From: Helge Deller <deller@gmx.de>
> > >
> > > Switch to the generic implementations, which are identical.
> >
> > You sure do like succinct commit messages :)
>
> I didn't even write this one! See the From: :))

Lol well then feedback addressed to Helge ;)

>
> >
> > Maybe worth saying by dropping the __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG and
> > ptep_get defines you get the generic versions from include/pgtable.h which are
> > functionally identical.
> >
>
> I can touch it up though, if you insist.

Yeah, I'm being pedantic here it's not vital to have this change :) but be nice
if you could, I'm sure Helge probably wouldn't mind too much? :)

>
> > (Being pedantic, they're not quite strictly identical as the
> > ptep_test_and_clear_young() generic function does some weird unnecessary
> > indirection with a local variable and the single {} is dropped etc.)
> >
> > >
> > > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > > Suggested-by: John David Anglin <dave.anglin@bell.net>
> > > Signed-off-by: Helge Deller <deller@gmx.de>
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >
> > Nits above notwithstanding, LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Thanks!
>
> --
> Pedro

--
Cheers, Lorenzo

