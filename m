Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05FAEE498E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 17:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C8B6B0088; Tue, 30 Dec 2025 12:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0AA96B0089; Tue, 30 Dec 2025 12:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C164C6B008A; Tue, 30 Dec 2025 12:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B32AE6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 12:18:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A8E01602A6
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:18:18 +0000 (UTC)
X-FDA: 84276795876.24.B9F930F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C97C6180002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:18:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SYM3oo3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767115096; a=rsa-sha256;
	cv=none;
	b=mKh2jAsz3/C4fyvmPkU4+TXyOgbxQ67MD86I29hCxTGPQgkCbc2UNsCjnNsTjrKRqmS/q9
	xHklXpP8mfUjoDS3LzomTcglOYcOqYU3/kwU1VG17UQQF3yzi+3XRVu8eb1Qdcyl2oAbFb
	f79ncHxTxLpq0mWp2S25+oRj760H0bo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SYM3oo3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767115096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/by8ms9ik3qDquUn4NMwAfjs3tVG1+YCThyUOlc3f0=;
	b=xs7CrVWMRi2s7k+353T4mgARiSNaGDGpMb4/7vjOI6CeEOT4ebP8YRDNS6M6xbHJW921dU
	RTnAcQDNQPTVWGGD4aQevH281TfeSEz1WhbLNkHDlCBWhLg0QnXguZf56AATP/1Oo52L/u
	U+n87F6LLqcxlIRtM5NwNiSHZUlPyHY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB95B6000A;
	Tue, 30 Dec 2025 17:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8ABC4CEFB;
	Tue, 30 Dec 2025 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767115095;
	bh=L0yfA8iQeAPZwmgn/JwVdXX5YqxPFm2orAje+7+04ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SYM3oo3UppMQ0vCZ2e+dnJ9iWV/Fm/7le8GBKEsJYssAPtlRd3gl6TSDH0kOHsuuE
	 2CK/6r3yvigVKD8DqO17s1dpTjoa45N0j+MoZi52GF6iRNyxhBCbhU/4E6UVLi5u/I
	 Cvrlc9erJL8EflwAmBYCX0WQ9F9j5xzUYvyeFrtu8kKozKh5agFWOGCdd763muMTV2
	 3KR3v/cweWyWwdc2n1IOj15lQzg/bjmdeRVsqwbJ4Y6/NqVvLS/BX22wy0FiBxjMWG
	 9VSE4JR3Zdbke7u2irGUc6nFZPxXCUbv2Xl7dLVca4/9SsPvSKDJ4S/5CIcz3HkhoN
	 es6ZQlUcsmseA==
Date: Tue, 30 Dec 2025 19:18:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aVQJUPOn85WlJaM9@kernel.org>
References: <861pkpkffh.fsf@kernel.org>
 <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org>
 <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org>
 <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org>
 <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
 <aVP6wBYoHJQsplIl@kernel.org>
 <CA+CK2bDZPwYpUhksDLSbfVdVm5TYbh0XrOKRV=q4YjGpqH+Fwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bDZPwYpUhksDLSbfVdVm5TYbh0XrOKRV=q4YjGpqH+Fwg@mail.gmail.com>
X-Rspamd-Queue-Id: C97C6180002
X-Rspamd-Server: rspam03
X-Stat-Signature: 3mn69te78dnwey6mf7ofugxomge48tud
X-Rspam-User: 
X-HE-Tag: 1767115096-201518
X-HE-Meta: U2FsdGVkX1/HD8a/Xyt8IAZ5xcdooJga2K1W7kdjMDABZjB7seH4EIDkS8EO/OG5u7CtYZUeZmMADWXIX537Z1flPFhuL7IzB1NJj5uDrCy3Kz5t+fsv8LJlayzl/yy2rVz+hivZUy23rGnDrKp3LEaOSlW+2+IzpPQCqlMh59ub0AzhYW50krRay5J8esx/xV4cVJC8+7yDlAkywQ0y08hVYk2fGfkZqXHzOAgTLgwYj2rmb5NgUJU55I0nduigdDsMU7bIDQKvDgCWrZVHmGzkIeU1CcdqD9poWAnPNYKOTl/7O7lk0VGys+TYuwApfz7A/FpGpEXckKd+rNult4189bgBSpmppVYMJauUGUb+EixIl8P2KoMIapfa7oXz8KLsVBvg/aKZIVInHVeMIT6CJam5lfZP7fgH14yGlQ2PRdSWKaHxsDKanOPjDbA6BBRsRRq9ecyA+J1+h+h9kAaP1Yb6VHeuR0MMGPpIBYr3ce8sievjEDjscxoelfu275YbBDYWrPd7UGFGcl9MBDwjJI0ylpZBP7Z9oEC8NODibpMd1JbLt9XoBQetoRUMhsRgx7C+hO74brBPRfChsugmW6cat95zWEh1fTJtD9j025XpYxQCCF5T7ku3uz9cXfkOAQuVZQ73oFs6OQJyvKld0b5xdQGBt3yJoem0Ypc5TMz3Q3DASwGHIovKXcJx8olwNWHBCcJlUcPQsDfhIcZ+2vBBLRInEMp9XGk9WKyJR5rKU4/amrGWfNXuNm4i7br5egGfGFxynTjRZi+0WJzP4ryKRV3z6mtxE3Fg5yp/ToOJ9fov8sFMVB0elbw/e+iMIDvi+xm+89AdqW+8VnCpCbK4orunyth6V4EPY1ORzulg9g8og0LrpQUJ/7Awlv5SUTf1AFawRQ9+ZGUMEA+GC4zVxLeZoPhvvv0ByrA/ckITuC8giwLXpfMhfwgy2I2SlbnUC9nnm0Y2+eF
 2tx7WTia
 MYna59yVUrN9vMAN4Fp/zT9Ci4qGr4Gqg/2kkiXXyZ/qb9Hh+NUyCqP4ymhxcadjykMTe51coGWnGVVZ5izSd6ndtZrR7M1j2PS+orpnELudvzWRjSTv0S07BflISLAmB5Ea6xcF7JAFPUfNC4W9geaIVbU3hVrUfM9J7T2mD4YKa6gw1qRuJwJawIEWssdniuVuKfq/wjuUAUbNORMQNjl9WZagy01CZDy/+zVkD1VJuS3/pBuUkXPAyvRPb/FpeBuYQ+Q5+QGcH7PnEZeIKNTqsz9nPdxeCrR6RasnppmUzXOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:18:12AM -0500, Pasha Tatashin wrote:
> On Tue, Dec 30, 2025 at 11:16 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Dec 30, 2025 at 11:05:05AM -0500, Pasha Tatashin wrote:
> > > On Mon, Dec 29, 2025 at 4:03 PM Pratyush Yadav <pratyush@kernel.org> wrote:
> > > >
> > > > The magic is purely sanity checking. It is not used to decide anything
> > > > other than to make sure this is actually a KHO page. I don't intend to
> > > > change that. My point is, if we make sure the KHO pages are properly
> > > > initialized during MM init, then restoring can actually be a very cheap
> > > > operation, where you only do the sanity checking. You can even put the
> > > > magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
> > > > it is useful enough to keep in production systems too.
> > >
> > > It is part of a critical hotpath during blackout, should really be
> > > behind CONFIG_KEXEC_HANDOVER_DEBUG
> >
> > Do you have the numbers? ;-)
> 
> The fastest reboot we can achieve is ~0.4s on ARM

I meant the difference between assigning info.magic and skipping it.

> (shutdown+purgatory+boot), let's not add anything to regress, as every
> microsecond counts during blackout.

Any added functionality adds cycles, this is inevitable. And neither KHO
nor LUO are near the completion, so we'll have to add functionality to both
of them. And the added functionality should be correct first and foremost.
And magic sanity check seems pretty useful and presumably cheap enough to
always keep it unless you see a real slowdown because of it.
 
> Pasha

-- 
Sincerely yours,
Mike.

