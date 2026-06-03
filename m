Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5C2CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135B16B0088; Wed,  3 Jun 2026 03:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E71A6B008A; Wed,  3 Jun 2026 03:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E4C6B008C; Wed,  3 Jun 2026 03:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3BD96B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:21:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85852A027F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:21:23 +0000 (UTC)
X-FDA: 84837755646.23.B982193
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C952540011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:21:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLZ2uGLz;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780471281;
	b=UBgSiaqgiFd2XvMB7u2FrbHeM9GmNBWtizTNuhG/wA6J0Kfi8pf0ge3Wp6BszK1woN08hD
	27K5usljiDWxl7VpRcA5VnkMj5Vp6UyGWlwrWz5CvlHIoF/ZyUWKVdzfDP3Y6eAHcw4NED
	iZa/wRV/k9N6j1VZzCLUKdexEWGQ/Kc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLZ2uGLz;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780471281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4AYz0zS4+9vbcv+nkCEYWMc7Xzt+3F+peUgdUdjo6o=;
	b=34Bq8FwKnhuKeRWs+Ky3BNCJUzKTtSGk70cbvOKXmuEqQcUfot04po34FiyI/CfUYUxMpP
	v3eUu1CsovF0Js6gLfkuTOOfPB1VTR57oG7IQdt1ilsbD+GlJKOs4wMl8Ph9WTRd27l2lm
	r3OOgwhwiQbvPT6pfZ04Vqdh/COpZ3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 357796022F;
	Wed,  3 Jun 2026 07:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38091F00893;
	Wed,  3 Jun 2026 07:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780471280;
	bh=V4AYz0zS4+9vbcv+nkCEYWMc7Xzt+3F+peUgdUdjo6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aLZ2uGLzGHQC63X/6WypopcHQdNDrrt/wR3CtR+OBMN1h5kgSZMO3goJpHnCwmrQF
	 w4q/0rYoY/1afWRNNmNAo/+y1i+LwtYM4qRJHNhG6XblvC1yCouQ1/XmjPl5E9Mnaj
	 Z8Ly1Cn53OplSN2r9zB9PU47NlTW6V3sni2lVf7C6Pm5Ws4Nq74BRIYbD50DOwogMz
	 ciVN35AmcMP0jJukADumEDOaesIz7zwETj58gdI6Ub4ROHfHb+NM5RjjLdbOsxf234
	 HVQYuuJDZfEqbj3Pmgkl+gHKKkFovXgeLN0B2DhpvLQnpsMDwt/eeRlm+zMDTGMZnV
	 LeWUp+nwW890w==
Date: Wed, 3 Jun 2026 09:21:17 +0200
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] simple xattr improvements
Message-ID: <20260603-fehlschlag-teamleistung-korpulent-5e0b7fa7f12c@brauner>
References: <20260601162454.2116375-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260601162454.2116375-1-mszeredi@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C952540011
X-Rspam-User: 
X-Stat-Signature: 63tbwiqewfbm9wstmnuuyyqrzbkdupou
X-HE-Tag: 1780471281-70620
X-HE-Meta: U2FsdGVkX1+dy1VM49MztN5Toj/qG84e9NY6P8cIfb1wlT/uxsnFZalPOMTm8USxNMsRi/zat50zUAAgHwTkY4i7z5Aje8u8o+HCeD/SY0aX3bmkPGFNTznrp9TvXQ+8+VQqzqCvrAE4Q947FGiybBnU1iDjg5ITxwtI+QQMuCfX/QIY22zotv7Vr1fYG0T//C6XB1COIzPEOWQ7cYO+dPiu+FhEBJ2LfnnO/k0jkHQVwPKpDx6BMpYaG1dY949KJ6rQvXHacOmZ4ifn6ZNco+N5orrEGkWwa2wNCMbG6qIBIrsQHszFVQGAbO/LV8ISDS7Et8TEc8D0Z6edhQB3YIrkxI2Ho9dXmyUm9A51v/evUV6UvgJtMObHvbJysmgsmAXOeXPaPagXcqiZJFaDqf3H5onYQ32zNPPrCE5JLN5ujAxEVVxULTGfm3Z617rDhLCWTkvxXekk40L/x/2Ssi8paOkFR0GAy/E9j8Kxu4YTX25CFDEFKT3TajlOR5NsgeagZwRG6ZFZ61sMuRr+bzEI214uAhmtKcPiLRhzuM8lFDflVLc0/LuUecRAgF4pCBs6IGzX79yrfTqktBK/5RjA8ylGorZsS+KCHgjJko51rwsaG1fRYxsdhB25KXjEj1a9LZnFBVrFEAf/oNsYfh8jhZ3U/+daODuGnzPfubyxkxOfJWPeMpr+AjWoNYiutVzuYEvQM9utECxRNN1uoncuhT8fzdSmjrelG+TCXclOEzGgRWJita4YKJdk8r2CIlvaGaOpZaW4AEfzRwdgT5YEFTYjiS60ELdINHr2vO3cgK3EWiBlrSM8X5brWJTjCJ+/jCC4yH51evFmAkts+eGFAsrKw9d1MkB1+Ygu/TOtWSGyZiCIuBxRBrSFpb34ZuhpzlgL0N27X+e3c57cUhUqE/ucnE9NJ9SPZ/PzBttwKlIjOKXLtxB3YYotyDbbN79KkdNYhRRbIt63Ib/
 LlwtaW2T
 SODEcQX2W0P7JxfOJaEsJrawH1zf6Na7h7JZIBVQKDCejJ7+tbYysC6XrOLNN0gqznU5Xfvg2/E+BbppbowGA5/Vl449dSfT7vXCYe89w7P9d+ETumLuszGrdSSU3VGMw8KzqSsBce+sAz+zC5Z2+TT0JJ5ccPLRHI0EDjpHL+fkLnEQ1EhfZzmFJollIcHFfdcJisbXJuE28oqUYnyuMZa0445anCCA23LyxnTAeHGy0qg8+z2rhkxjXzuieBA6CZrdKHBXky96Fq2IIac4qwKTDJZhGaPcDl+4UGdlD7vhUsR/MlD7TKk8qFLoVqOuOhhnq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 06:24:47PM +0200, Miklos Szeredi wrote:
> v2:
>  - don't use xxhash
>  - fix lazy alloc concurrency
>  - fix rcu freeing on evict
>  - fix rcu walk of per-inode list
>  - don't double account freed space

I've fixed a bunch of that before already but thanks for sending it
again. Fwiw, we now also carry support for bpf xattr in the
vfs-7.2.xattr branch. I'm still applying my kernfs fix on top.

