Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E4DCDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EBB6B0088; Thu, 25 Jun 2026 04:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEFAC6B008A; Thu, 25 Jun 2026 04:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9286B00A1; Thu, 25 Jun 2026 04:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4B86B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:37:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB27E8FD53
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:31 +0000 (UTC)
X-FDA: 84917781102.11.6A7B63B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5805C8000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:37:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGlFrAQy;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782376650;
	b=mighwBCZGF59gDQeIEpIlV0uWwCzzG5bpAjZ7wG3VEP6vglilFaOUUsx/1fe338RWAgWsw
	u8WvMtnPKNQwjC1lDQZpYADqyU9NJYt+i6nq1dXjIIY6vxB7cRYiKEQ7zW2mxXLHPTlITo
	q86LblbUJipmVK6jwk4zpxJKRm9pHTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782376650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTHenELavdixkpehBZtgo0+fqBfXPK/qvE1tJsk4MnM=;
	b=RzcF0I1S+M2bcHyYZ7/YHIKZ3e7bWXLJCTfyZP+Q3SRkEvk0ynxpZOfz1xdoE5v61RCeL2
	DIduNzAgw97Mj3Zju7HmgEjdOEN+EuFubqNjb08NYTSOYyTKJUKSzYJNNnGzwOjyBch5M4
	G2oaRR6PAtBV0QLpNPf1iucw1w/oC38=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGlFrAQy;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1EC560217;
	Thu, 25 Jun 2026 08:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930531F000E9;
	Thu, 25 Jun 2026 08:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782376649;
	bh=DTHenELavdixkpehBZtgo0+fqBfXPK/qvE1tJsk4MnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FGlFrAQy6E1uz0C3XgqICgDtpY4DNdRjgthseoT8MOaduXl+SL2fHnjmBcTYDYVoi
	 aahon87kV8Efqxe2wgajqSOfG+M8UjxNNxFsy+F5zI+k++5To0Lok2H3O3Rv1rReCc
	 4GdaD1AQG03Ev/h+Ut1+huKOcnbWktK3QkMVU8PbwQ/NT4ysLrtbHE2zVbir4hs4P/
	 NrVHnpV8HVagJwIgz0sIcJXup1HvAIrniYojkT3EXswnjYmA8WlxJbIWl1GTzV1Wo9
	 uiKQORFPHRADJs5La5tVBgIZquUTMYRVkk8GBfS+6AZVOCWadOU7XYgpssTnjgx/Gv
	 Xi0QONQ3Fwmug==
Date: Thu, 25 Jun 2026 11:37:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Shyam Saini <shyamsaini@linux.microsoft.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	tgopinath@linux.microsoft.com, bboscaccy@linux.microsoft.com,
	kees@kernel.org, tony.luck@intel.com, gpiccoli@igalia.com,
	bp@alien8.de, rdunlap@infradead.org, peterz@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, enelsonmoore@gmail.com, kuba@kernel.org,
	lirongqing@baidu.com, ebiggers@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <ajzovhWHcFQZ9d3l@kernel.org>
References: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
 <aje-nY6QbwZP9XLG@kernel.org>
 <ajyC2eX9MKSU84Z8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajyC2eX9MKSU84Z8@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Rspam-User: 
X-Stat-Signature: bid9hjp4o3bx8b8pqnykn7sz9x63qfb4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5805C8000A
X-HE-Tag: 1782376650-253795
X-HE-Meta: U2FsdGVkX1/YIOC7QvqNIYHcwROl9DHLCe/wy4GQvQUw/rIB7Sr4Jau7OV2oPiqg93esrq+pK2F1tY48oLZ9k6r3Odqwd4GWKENcMttQvUBz/2/O+Xl1zQrOyj2UDSTtp85yr19+yjh5SVGBlKaGsO3Grlc1qjOTND9HyE0RmYbYismMcZVYst8lAY2idaK5g/rAE4m3h1jIwnpCno1KB1DI5qF6DrcRGagTX8ysHXTdsofJ+VsnFKKFOR5wdjbwUFgXVwLNrzUx0WolNTCz6Yyu0cp1jBcdZYMyi4/o++rjEkCFO0hq4EB7k/hIqEjvHThrE98ncoI9a6iIhlZZbKCR1j6xUhWComx8SQ5GSuOYfyQDob4eNIkRRTVoUMf2u7WMS1289w7WDZm/qtaM+K9WTL4tk+I785vwzSIZkE6prfUsVZOsOzu4MNhpf1ihmc1bIC7z+QJdFvR+xpX5D9KmxHsb1j+Fy/QJu96Hg38h3jTmmD3VvB8jp5Hjtn9Dx4JS5BzoXmtkLqGRgKumVTnEe+jqUjSme23yhp6XbFwWBOmIr4y9w1DNFPU8ZAxRU3W8eHzcb9b2XoxTkFhYxx8sf8AfgVBIDEKfLxC7jL5VDAIVXge2ZIE1uLAOmFLNh3OD0FrQZGu2CG6XVb2gU9XUz4bF6spU+kO+2PMt3fayD0ptSB+TlhPp6HPxsRTIMVDWRxJtgGDOMKa4KDwUEnUttxe0kWHd1Kb1DM+lbniSyiv8P/TtUGHQO8eREBXOoTixRrWzmC8AUJxfashEgHpuPbCjlIS3mVJdm265PJ8xI14gycBrSzOUPy+GAOlrwzz2+6e1Tnacu/K59m2hO7CwPIEKCVFnx3vb22XBNJUx76R+9vQUl3avU9uy4/ppKM97+/xInUwUqrlZK5v+7csU3PjXiajDlAh4AUe0LhXj0ZnuXrc+acZZ4IqCRH3hwMvYNRz0pfN5zcyA/2s
 8TqbqM9Z
 S7h+N9dhHrYTSoLd+108HfjqbvqbTSL01aaOCuYQ2Vqp0KMf7kZRndeCpxYR/3sg3M2CRFLkPbJKjapPUdVNXyvlTsjwbRjJiy9KJsNKvct5JK9DZc9BgeYlB5EAEp7O7ASFGMlO6ghtLKK39hWk0Fd1f8s2dO/iCOs4iC28BYp1xARCJ3qwZ9oVEu+hqPlkMrbUEsN7UKDqT/ZRP1o0gbXoKe0Ijz5Zkw4QHRE8jUj+gq1jJvFeg3ClNo99/pdBNTdExBUga1X170p5e+u9DfspVFLt3Qk72VvUSFkxtzETUZTo4qteDkwlAeqs3oZrebNRmWCDoAJ+n5zqomm5en9nSLCuk6pI8qcEVNQXqLLL/rXTNP3V/ndjZfmsyBhoaVzdu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shyam,

On Wed, Jun 24, 2026 at 06:22:33PM -0700, Shyam Saini wrote:
> On 21 Jun 2026 13:36, Mike Rapoport wrote:
> > On Thu, Jun 18, 2026 at 11:23:31PM -0700, Shyam Saini wrote:
> > > reserve_mem relies on dynamic memory allocation, this limits the
> > > usecase where memory is required to be preserved across the boots.
> > > Eg: ramoops memory reservation on ACPI platforms
> > >
> > > So add support to pass a pre-determined static address and reserve
> > > memory at a specified location. This enables use case like ramoops
> > > on ACPI platforms to reliably access ramoops region with previous
> > > boot logs.
> > > 
> > > Also skip the parsing of <align> when static address is passed.
> > > 
> > > Example syntax for static address
> > >  reserve_mem=4M@0x1E0000000:oops
> > 
> > reserve_mem is best effort by design because such hacks as well as memmap=
> > cannot guarantee this memory is actually free.
> > 
> > If you want to preserve ramoops reliably, use KHO with reserve_mem.
> > The first kernel will allocate memory, this memory will be preserved by KHO
> > and could be picked up by the second kernel.
> 
> ok, On ARM64 DTS systems, we can reserve ramoops memory in the device tree during
> the warm reboot.

The cc list actually implied x86 ;-)
Added arm64 folks now.

> For an equivalent ARM64 ACPI platform, what is the recommended way to reserve
> and preserve that memory across the boots? 

I don't think it exists, but a command line option (be it memmap= or
reserve_mem=) does not seem the right way to me.

Most of the arguments that were made against adding memmap= to arm64 [1]
apply here.

If kexec is an option, KHO provides a reliable way to preserve memory
across boots.

If kexec is not an option, we should look for a generic way to specify
something like DT's reserved_mem for ACPI/EFI systems.

[1] https://lkml.kernel.org/lkml/20201118063314.22940-1-song.bao.hua@hisilicon.com/T/

> Thanks,
> Shyam

-- 
Sincerely yours,
Mike.

