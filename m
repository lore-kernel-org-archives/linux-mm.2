Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F434FC618A
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 19:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFA16B008A; Sat,  3 Jan 2026 14:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D546B008C; Sat,  3 Jan 2026 14:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA696B0092; Sat,  3 Jan 2026 14:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F088E6B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 14:23:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6E4F1A0754
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 19:23:35 +0000 (UTC)
X-FDA: 84291626790.24.1BDCAC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0FA9A20008
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 19:23:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngReHhb0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767468214; a=rsa-sha256;
	cv=none;
	b=Oviyw8eUMazZu8cZdIDHIfhmPRW8pyUoyI/dkHKG+88hJky2GkM/60eIaEN8nSp+GXD7me
	qqgW3TAfCFnFKdLdsHRZK42l2KPN+JjUxc3i8XMYGxJG9fRNIBPApRacSi+HYWKEc4pdyo
	YTsXMUoIhfPgIygP6/02wha1O4TRikg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ngReHhb0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767468214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2n1sRQgq5PofB8SvJ7IWjTYippNHGIcuVtOJgLyqyw=;
	b=6fZgKpP9Cr7wLW3gtgUoshW8Jo3olngirSAwJS1CRnhc8UOtgSQoISzAtbfoETAxyMkS5q
	AIfy55q2/Nxo3f+q++i0e2pR9M3EqlJw/PQc2tbdfw2yn1iPliUQXoBnYIhDm7XDRCNBKS
	Vbjdv09z1IQ/T32CGkFvIr5iss7j9Vw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E26B34039E;
	Sat,  3 Jan 2026 19:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DA3C113D0;
	Sat,  3 Jan 2026 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767468212;
	bh=kFPBzT8l+WwHu+3My5hbLBVwoqHKka5P/1LTiFfRdf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ngReHhb0xBx1x5fvYtOfgcpLEILzqu49lQW1bMb2wRc3+BW1vWJdoV/liivSukWbi
	 Wr1u0+WC02baG/7qzxuTHFHic6PVnSamdiPxhEqTgA1S2pA1eqYyInnK8Yq7O5/pa1
	 cl2RU6O4se6+wNz0wv5fa0sTosXv7JI6nHpQxOqCzUdzlR3V5lzLornbt5v4CC52Wv
	 K6NU1UCrStxzBWELoCL6XaOEUwgpoF1/dezzddv3CKdw8etbedWu0aGGeJ5bgKxD0h
	 Hx+Y7xYCdQlhaa0yCF5YVhge9J70WfDqFLK3pVNIX1+38Kw2MCSO0IgV/T3FqAtpNA
	 9fVyAIlQ2ZFFg==
Date: Sat, 3 Jan 2026 21:23:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net,
	david@redhat.com, mhocko@suse.com, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 18/26] mm/memblock: Add MEMBLOCK_INSPECT flag
Message-ID: <aVlsqdgXSBLIE9Xi@kernel.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-19-eugen.hristev@linaro.org>
 <aVImIneFgOngYdSn@kernel.org>
 <4b8953ac-567b-4d68-9c25-72a69afdf1b3@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b8953ac-567b-4d68-9c25-72a69afdf1b3@linaro.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FA9A20008
X-Rspamd-Server: rspam10
X-Stat-Signature: dgaxigw533zrzypnxj1zakmnbupwqyki
X-HE-Tag: 1767468213-343084
X-HE-Meta: U2FsdGVkX183MRGoYv7mkYpXlXbtTgNZNR4eaED+I/0WuEjfNbsC9A2XNhcFNcMyQ4NvmTwlc3LfI08NIYZYYANlRdxXbhydS5mghpJqBrItPF5NYpPyZB6FKCmhIaeQ/sdwEds6vHp3n//szmpcYC9z4DfaRnDFQQ9rEXtlGC6fx/fThn0e/h62Blr1KboVw3gG6uWkvBjIfyk9OklNN+tNEtf7i8A1nQRim2L3odA65515Somqyc38XrQGmCnBDacgx8Qfd3+Q2cXk555TK0ASmyDJVIyYazQ9cL2cYrXYK4IUoCh9SFmKx85qRcCFiEFveJygwY7RXNA/S2sAeEShS3hZlZWYRFZRUoUOW7nwnIQV63kvw2/ndrpvtEXzU4dWYXTXshrls7vZgXGXK5jgnymumHD8lgJNHxvP4sOAGNVPKOsRcSYpdo6mk+lilZuYCTsm6oyrH390kfp1a+3lpT/9a4PMtSA1y0e3r9h4ClYfLza6KTcKwMs0vHUWKxTaURdqo13HaTvTvJ63Mxg2CfYZVbfPE0ktpc0uJbO+S63xcyojepMaGsx8ffT0EKXnU9u84Bi1vx4NY/c7yOKDJuQuCF24Ag6HPvGqgCs7wRllmPaz4Mccctf3DhexJkFBloqnUSlR1ZgY0/VfMB1u4hyeCUUL20yFTcVenE2H1isqz12CVS5T9RwMMkR3xdc3fiNQBRy8QWwc3sDnEbh/1OwqIuVMTBdc5U9Hqcr9LU5eAB5mbTtnF+2VCgWYfLBXWj9FD5JqY1K6Kyk5t7vLESJJEeknpoPLwQowzfB7zkWBMS5pVr3prEyIq1yRxV5gteToUT/bCRueCfcYQC/tGPaP1QEipvkSs2IYC5nKDk6uwNtVDU6fPIT0BZ6Ai0ogv4yQPAdNZC0pcCnF9i5mlp9Endcgb7g+NounlzwN7/ESC37lHGAdkYqEZTj0U7Sl347l44bCUvEuKxP
 PZQi+B5a
 0L09VPqu0Lm9IqU9PLRlWlmpMvTnMbt/Rsn1BJAj0sEtarltJJK3BzQ7BgdJEt3NW4yxEOubwc30zVL27ZHlov5EmeaPx1bBmKCOD4SfzoQ7bNfygD9j398FN1Fdy41qZKUHdWTtQ3LYlhmi9Urb4s5eGbwqjE+93k8iq93TMhbvr3rCsSW8bGvZ/sV1jA9us8BVauKZdINKi8c31tRPxdHLJVBOP9nX4UEkBCQcixCOubbbZAE+7R5RRQuPa4tb2xUNUu+dd8JfG1ouNfPwwqpuSlYRzSNkxdoxwCVix2vbUsQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 03, 2026 at 08:36:40AM +0200, Eugen Hristev wrote:
> 
> 
> On 12/29/25 08:56, Mike Rapoport wrote:
> > Hi Eugen,
> > 
> > On Wed, Nov 19, 2025 at 05:44:19PM +0200, Eugen Hristev wrote:
> >> This memblock flag indicates that a specific block is registered
> >> into an inspection table.
> >> The block can be marked for inspection using memblock_mark_inspect()
> >> and cleared with memblock_clear_inspect()
> > 
> > Can you explain why memblock should treat memory registered for inspection
> > differently?
> 
> It should not, at a first glance.
> 
> The purpose of the flag is to let memblock be aware of it.
> The flag is there to have a "memblock way" of registering the memory,
> which inside memblock , it can translate to a meminspect way of
> registering the memory. It's just an extra layer on top of meminspect.
> With this, it would be avoided to call meminspect all over the places it
> would be required, but rather use the memblock API.

memblock APIs are not available after boot on many architectures, most
notable being x86.

But regardless, I can't say I understand why using memblock APIs for
meminspect is better than using meminspect directly.
I'd imagine that using meminspect register APIs would actually make it more
consistent and it would be easier to identify what memory is registered
with meminspect.

In the end, memblock_alloc*() returns dynamically allocated memory, just
like kmalloc(), the difference is that memblock is active very early at
boot and disappears after core MM initialization.

> And further, inside memblock, it would be a single point where
> meminspect can be disabled (while preserving a no-op memblock flag), or
> easily changed to another API if needed.
> Ofcourse, one can call here directly the meminspect API if this is desired.
> Do you think it would be better to have it this way ?
> 
> Thanks for looking into it,
> Eugen

-- 
Sincerely yours,
Mike.

