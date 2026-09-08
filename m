Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 817ECC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDC46B0096; Tue,  8 Sep 2026 03:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5EC6B0098; Tue,  8 Sep 2026 03:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F63C6B0099; Tue,  8 Sep 2026 03:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7AC6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:40:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3E23C0443
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:40:28 +0000 (UTC)
X-FDA: 85189797336.14.E6F757B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 441F040004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:40:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVpMzVBV;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853227;
	b=QwiVkvsA6hDd88PHfnx9SOrMcfvLVOB0vvUJiOjOS9/aJ/gQfy51K2N7hNPgHVU3tq7Fem
	swKH2gxAaY7XaIRm3GgE3sNU/9bNxy2XnBB8zzo3b4KuAB54QRCehjUbrIPOclr7W4E9Da
	oe2k1c/fEkVi5S+hl04MgpLFwlmf1w4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVpMzVBV;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dW0Bt6wVwx6uYNJdG4bnYanuxC0mWdhwlxmUwvkpPtI=;
	b=lQgHVkP5Sn1aPIAp7sTl1orVnK/qjbM58jNTI+DoTBNafC4/ATeT/OoL7QUXh4bwYseDPe
	Q8CTMRDQ2gH8YY3wdUWSXtXoUTlrJWmH5/FzUAUOLsHE+fLfpvs5bdP5/WmPKe/pXu4/7F
	U3U+dT5YNvzZ9ng3xxc/eRBuW1i4oyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8D3B60A97;
	Tue,  8 Sep 2026 07:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FCE1F00A3A;
	Tue,  8 Sep 2026 07:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788853225;
	bh=dW0Bt6wVwx6uYNJdG4bnYanuxC0mWdhwlxmUwvkpPtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iVpMzVBVDpbbjmSmLjf9/u1y3Rr+zfuCTrDmGqoJwDmagIYgicropXMGIej4xSaxg
	 6cLeStx2+JupYI5v46SFH93vN1pLOaqi+71OxT+0bOJXF46WT8TIADUbfXr6wM0X6y
	 j1wQEMfYEqkJp0+VVHTg+hRXEBocWl2PZ2Gxdqa96QFMigsr2ZMs+aOiSh09Bl9Nce
	 OQjSjvU/RbtJveqJElRlq/Pv63+Uov2SfEkKZ+0O2mOCeEHPy0le7Mc8q36JU8dfL3
	 taQ9sUCphHLYu4/BTPtAXLlD5cjXs4iaTH5w84MhhGeyR7IHE6ys0J1mEfDUQfC1JJ
	 3Xxl0cUO8U+Uw==
Date: Tue, 8 Sep 2026 10:40:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
Message-ID: <ap-74AkHSGXbFCF_@kernel.org>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-2-vdonnefort@google.com>
 <ap2_926WXr7uAYVX@kernel.org>
 <ap6I1FN_2ylRzFXH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap6I1FN_2ylRzFXH@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 441F040004
X-Stat-Signature: cogd8jfr14uyam9sg3bdm8gxchufmwyz
X-Rspam-User: 
X-HE-Tag: 1788853227-831596
X-HE-Meta: U2FsdGVkX1+66yn4JwcaKt34cqYj+8IawGe99iG3+XWu2JBS6+cP47To74WSwU8UvMPKwPfvoivKRfqqPvxqU8kqsKuEQqJ/5/9L7hnt+ZiIOYRVrqP5uojUbydTioK02jcYfpUYQjjA5vRijZ2DcCTeKvOmsmTHpn8AE3OuKr/ceuUzv2SnWB7Ft/N9mhcJqrwDAkeYab9JeDn8pKFbvuFHOf8smcQiK8/ZGlRbMVSRIEyC3CQjO/j8WEkMWun0DfFU+KgHgDJQJKHnyrxSlxwevhvtSb0hJsWktSOazG7/ZSaSPh/GVdkX/EuO/lOPVLt3eqmaNinc/tWTHJ64uvA21G9AYIkgK8ty7eR0rBCDcBGevZ3zsqnM6rOjhUQ44JDDOnuqO5xnE30YRmjXjI1O/gaQ3QvkyYnvBf/X9b6Zby3LXeTfanRbyB5OovKf290ioJtkbx4KhPL2XgTuDoqmeM8cdelZOVjmT98JFntLohSrsEUHr77jE75z3emZbPf3Ov7Fc7Ua0xUbk3wepcwX8toA8w+1y0ZTlvWKA5Vc1IhwAJRFDaWszSwjfChJfJQA/kG/O2pl/s4321/1M3xQ56DxfrG2kOKG/bXu9XOQXTBzuACIZHsGp5EziqwtE9+fLoxqAS3oCNHdtdgs2DHwJtTZT63zstTPv5jnJTFeQpNZTKtLYcNePUfQi8v/Lxst7A2qoc72xN+mbQMVNIil5gbJWGbykpUWAfC+Y0lTu/5iwu+ouEacamwALuxthMyGXf1l/EsunplXwk1R+7fKZh/cxPZxMMQJpvDH8BQ1QlWg/sKtO8RI1ljqH2vat+4YuhwGiRaP2JsXdFiprBMqfYOPEcJ/SCvR5FK6jHqP/nQw9lhtcdxv97FybaHn2g/ZVJacbO6tEG872rRJ4tlPV8pwoLo31K687D5I7qrfkdnkYnkP2sUIxndidWplBLualcA7YnxA+47i89+
 jcVaVQm+
 /LeNxXvJkiIgYylX+X76PMa3OtJjHwKUARYRziZZLXBnj6TmmalCQKiyzejJaFL+9moQbn7woolCv62NOx2IV/Mhkdktfm0FbkqawkwDf6iJpBTHiJbq6OAPnDf0kC3D/ur80XzqpnfLR/yxxm4bFfkNWoU7+Ocb+wmga4ZwOrdzeI5kuUecvJxR02K6khY4drJWf2aimdpe/yJtcJzpYPLdcR3uAlSKQ8FOEiisabYHHTKtZP+Kqk5dFRzPsvtaKeZALZfZ/oseNuAj70Avfd4Lz+gWO7/fkpgMWWRnz+z9lcmNKFGEocjEOt6FT9wCqv/DIWlcXM1FLOHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 10:50:12AM +0100, Vincent Donnefort wrote:
> On Sun, Sep 06, 2026 at 10:33:11PM +0300, Mike Rapoport wrote:
> > On Wed, Sep 02, 2026 at 11:47:03AM +0100, Vincent Donnefort wrote:
> > > Keeping last-level mappings is interesting on some architectures as it
> > > allows mapping/unmapping pages from the kernel direct map without the
> > > risk of splitting blocks which, under the break-before-make rule, may
> > > trigger page-faults the kernel can't handle.
> > > 
> > > However, mapping the entire direct map at PTE-level is costly. So
> > > instead, create a new memblock flag MEMBLOCK_LLMAP to enable the system
> > 
> > I believe MEMBLOCK_PTE_MAP sounds more descriptive.
> 
> The idea was to have something close from NOMAP, to emphasis it is one or the
> other. But PTE_MAP sounds good too.

Could be PTEMAP if you prefer.
My point was that unlike PTE, "LL" is not perceived as last-level, it
should be looked up.
 
> > > to decide which region must be covered by mappings up to the last-level.
> > > 
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> -- 
> Vincent

-- 
Sincerely yours,
Mike.

