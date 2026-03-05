Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C0CF3092A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAAB16B0088; Thu,  5 Mar 2026 05:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81D56B0089; Thu,  5 Mar 2026 05:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFB36B008A; Thu,  5 Mar 2026 05:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D04576B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:40:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6338F1B8B4A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:40:52 +0000 (UTC)
X-FDA: 84511666344.17.37E2F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AFC3E180005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:40:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bS8F24UG;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjx+hSi0oSfiKDKaV5fmi3DU1UFc94Xlk/mxzouIAqo=;
	b=8LW96HwwezxeypCR/qWBJrg8o2Of3xkN6+FraVeyyfgpk+Nq0w0TRMvGLWpPk6YlrOxvFa
	Z5ndyT/jUN91JrDQ203r9AYcQcvE7peem7kb0zAGE4mms+WXGODE+QNCe/Bj7vMX4MCHJ8
	+bfA/7glRlPts7N2XpCkPOkdL4+A1tg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bS8F24UG;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707250; a=rsa-sha256;
	cv=none;
	b=6RIH2DiFofmTf09qTB/k4c9iXNuEZomwAD5YIygacpgJmKx0nLGcx7a3LmtvmnIqMhK2jq
	Dzdz/iX+B1C71mZoe5w4eL3+EZFKr5Qi7A1++VfwafX1l8Z4jqAOjB6ryuaTY0XgaE01OO
	gxpSa1UiG3/hE44sSfZ36b9bfBEoVnQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B51F443548;
	Thu,  5 Mar 2026 10:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512DCC116C6;
	Thu,  5 Mar 2026 10:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707249;
	bh=hzsXfB7P4G4WYEx5Pd6UFeqyQ4kF1hTUa0Oig7JuPJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bS8F24UGoMYUpzPfK1fUha1+8KSwCsJbE/giONrlagbGSkGnxK9uKeTPe88Eo53y2
	 ow4KoAS9aQh/Su1iSrZt7SWqb5d8lnmbbEfFnuDFslh2qpW71wBmO8EHeQEQET96g3
	 TcB1VEhbQ+EZgJ1Ce5QKqRo1Ooa8kQzWPk7HL9DG6GVNBZ5lJjemln6xdYK9m+Cy9p
	 Gvj+PC+KKmV7FJD7l43xImictWudPeRr3kXAzNScaK8nuKWcmMu9eR3ieXy/O8bHku
	 7wH06EXBPDa5fQzbYmllVLPeFSdW+2oRnPBQ1pyGQNPt26PgAaBErN+HKdbZB7cwOF
	 JtiRDhXsdbnWQ==
Date: Thu, 5 Mar 2026 12:40:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: always dirty all folios
Message-ID: <aaldqxw90rdwCt6p@kernel.org>
References: <20260223173931.2221759-1-pratyush@kernel.org>
 <20260223173931.2221759-3-pratyush@kernel.org>
 <aZ65uvOrTDndpic6@kernel.org>
 <2vxzv7fabr84.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzv7fabr84.fsf@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AFC3E180005
X-Stat-Signature: bxqipwiw7ukqpuqjzjdnjwbbgoucoxhf
X-Rspam-User: 
X-HE-Tag: 1772707250-332089
X-HE-Meta: U2FsdGVkX19/4/QCr6dGfxqG/EBWoOxAT8a7jZWNuFDNGwnO1T/OETy+zVDAUbUB2+gjc1LtubRgEb157+zQSV/HYfMbC5eIm46jOZNDV8xTNHLvM0OUpNx59jdcOfOG+4c5JfIuLGhIsJj3lmUu2kLBdrZ6M/+7kC3TJDE+OoSJhzTnr+6G4XGBfeZtj3rxoFgcOMMXbTffmjrvitVMyKcTF9zwt/7nz+wOvXTf3+1dCXGGWXlx8bYVgrVhTyY8ZY3m8PCUMt6Sjae2avbc/nZeb5I701REKZvldUFA6ZRG8rghUdhPzhUU5ZBGUDF7/KuMS4N41tyFxRKGjAZGsjcL4ZdXYUXSivuWvKZ9GNt2gGmZGmF0j1aPCQcBHgbhs9e1oyrM2/BfVXgiH+mnuyz/kJ4wOCIPlvrhAUvIaa04aqAlPgaRERY1eJzeXQE140Kqtdmhz2PUg7o2G7oEx7QVI2kxYvkN40w0WWpt7UnP+H3GhheR630QBU7Fl/V31+gZUITKXBiatgRlzy58E9fCgk5keaBZ0qJDm6bkBzrX5g0/+alSQhSvUWNH6uMsX1Je2fIyJp0uljNKVcZnpGC1d5IR/EyTyY1xdPBNP7MD3cO4qJvHB6NvnGSXCqubhU7hVF/+FbUoY7IUPiVEGE3BaQ0G5ktSYERmQdthJ+UYCugnBDiZ+EuLBpKGD/uqmVuJQCYZL/Jm8NgESiZrRTIYx7Vg4/uJ5DuHGR4+hcKIphp7wH7E3uv51yjUhG+Cebi88U64J1IO/HJUv+2+wgUseBg1z6suDMzUvlzVhnLV81yNuq4bqAOQDghj0mmfMfib7DewiymJJZ/LzFWv4j+pB9P63zCkwa6ATuP9ZmVGKWhJVXQO1I2O77BaI24icOFaf4T7ARLi/gl7JWnTHl/L8rDhiY3JR2f/hek5XRa6J2+PtrLNNjmkreW//lZkQPhh51/PDAPJGveuSpU
 HqyXHb01
 pI70MBwrcYUSfD+w/q+zhxd4xPw5oqvNGlJcT66rLoEJxfkGskwFLJlEJSkZvrbFQLKVcKSMnIJ9zeBAlWL8wC3BQ6WthU3pqopu0CKaUyLq4rCzawMzbKwKYV67q9JuZ9KQhrIa9BBRIKa0o4VsvWOJ9LUS+g8wYKesOgWZCiUe0JvpZDajDEdLcd5M4rhUfxtJrFk+Gbdj8xVsyl6kByIJDXaPm5opwwChrThuvqNtOkDvHKjMy1fF4E+GSy44dK/vFkh/c/2O0Tf/J5M97BXIH6nGu3GV3qqRF0y2+dr543x8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 09:44:27AM +0100, Pratyush Yadav wrote:
> Hi Mike,
> 
> On Wed, Feb 25 2026, Mike Rapoport wrote:
> 
> > On Mon, Feb 23, 2026 at 06:39:29PM +0100, Pratyush Yadav wrote:
> [...]
> >> -		if (folio_test_dirty(folio))
> >> -			flags |= MEMFD_LUO_FOLIO_DIRTY;
> >> +		/*
> >> +		 * A dirty folio is one which has been written to. A clean folio
> >> +		 * is its opposite. Since a clean folio does not carry user
> >> +		 * data, it can be freed by page reclaim under memory pressure.
> >> +		 *
> >> +		 * Saving the dirty flag at prepare() time doesn't work since it
> >> +		 * can change later. Saving it at freeze() also won't work
> >> +		 * because the dirty bit is normally synced at unmap and there
> >> +		 * might still be a mapping of the file at freeze().
> >> +		 *
> >> +		 * To see why this is a problem, say a folio is clean at
> >> +		 * preserve, but gets dirtied later. The pfolio flags will mark
> >> +		 * it as clean. After retrieve, the next kernel might try to
> >> +		 * reclaim this folio under memory pressure, losing user data.
> >> +		 *
> >> +		 * Unconditionally mark it dirty to avoid this problem. This
> >> +		 * comes at the cost of making clean folios un-reclaimable after
> >> +		 * live update.
> >> +		 */
> >
> > Can we make the comment here shorter to only contain the gist of the issue?
> 
> Is this any better? Or should I try to make it shorter still?

Yep, thanks! :)

I don't think it can be made shorter without loosing information. What we
might do is to add a larger comment in what state we preserve folios on top
of memfd_luo_preserve_folios() and leave the code inside the function
alone. Can't say I have strong feelings about it.
 
> 	/*
> 	 * Tracking the dirty flag of the folio is difficult since it is
> 	 * normally synced at unmap and there might still be mappings of
> 	 * the file alive.
> 	 *
> 	 * Not tracking it correctly can cause a dirty folio to be
> 	 * restored as clean after KHO. The next kernel might then try
> 	 * to reclaim it, losing user data.
> 	 *
> 	 * Unconditionally mark the folio dirty to avoid this. This
> 	 * comes at the cost of making clean folios un-reclaimable.
> 	 */
> 
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

