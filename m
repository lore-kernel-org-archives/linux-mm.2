Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3258C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687E86B009D; Tue,  7 Jul 2026 02:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638A86B009E; Tue,  7 Jul 2026 02:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528606B009F; Tue,  7 Jul 2026 02:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4246B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:17:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 889258D1DB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:17:22 +0000 (UTC)
X-FDA: 84960973524.30.1E52E15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3F44A000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:17:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9LZ68VX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783405041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=836SAMNcgYGznpPv4pDFhhl2VYFtwB3MUE7NXhRTR44=;
	b=NAQx5BnWPfrbQGkOnlyrhOdLBATOgRAOTH8HLA7m5PMECWImIu2fWbvm3fDY3sjkwmt0hK
	xeEfsXxoPqUvzlDRWbel8ixjjoVxyRKbl1pccHEyXyqlx5EMPYtIRZ21PRC40KYGyu2hzM
	JKdvECSzNlfS7/NPdDdOEVuN1tcpTig=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9LZ68VX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783405041;
	b=01CoybdHaXEQbWRr5yf7eMQhswETN5snq0Vjad5cN5S4gzqhp8NZwf6pin6m0q34bK9pCO
	toGcNDA1K89Qavnf9H+k7S0HND3PQYyBwh0x7+LyoM8VWsRWPsC6jEMRCtSbBKuG0pDyy7
	4+URdvokJZ30ZS45dxm51I+QpaxW0uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E027D43C2F;
	Tue,  7 Jul 2026 06:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0651F000E9;
	Tue,  7 Jul 2026 06:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405039;
	bh=836SAMNcgYGznpPv4pDFhhl2VYFtwB3MUE7NXhRTR44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l9LZ68VXwiy2wzLo7a6kET2rVY4gxtpjyT5oNRV80EH+ueCCspXQGjjIAlDlLzyeO
	 YFYx6l0N+wz+Yy6oMl2JKy3lr/dXU/sJGiE/Mk3RNnxpzjGu+j5vbStTn4Sbhjgc14
	 aZe8rHO3zg0yr1Yfzs6dPtpo6gK9Hw+qdCT0DXbO8vE8KJ8xBpvmIl7MIxNsP9+Ok4
	 tlnMXmxQ9La5/V8b47TJbYkAWoQQODk2Hx1nTtTghnvdeQPJLOaNeS7bpTJcdHx+vX
	 lejiXTi4/7NIktdzxwyfeeL4MkfFWX0K2bNuHqFaSu9rbXvb1YZT2M+vVWfQe5DPsX
	 vROavjbjpHKiA==
Date: Tue, 7 Jul 2026 09:17:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>, Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>, linux-mm@kvack.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Subject: Re: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve()
 return value checks in early boot
Message-ID: <akyZ5DhIV_Grn1Kc@kernel.org>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
X-Rspamd-Queue-Id: E3F44A000D
X-Stat-Signature: 56fcyky8pouq9pnnc5so39jzarzudsho
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783405040-882674
X-HE-Meta: U2FsdGVkX19RIE6j8ePq6OBoqufV2msY4kCRm3sZYWl4jyk207dr+5HHenbC10uBCcuBviEkZQ8kRnZ5TmzKQ30WhKnuTIiLVbalamsxwZEZGGx94xPUrldur56l6A56XuCg6p7yivWCVQqHoJwakgB1SBc7v0G8elWps/gm1aIWEG73qkyPTbTWC4ArBhrmvKHfuAodNcV876Htb0Re3YcUbZssDDW6nrLNZ1+TPf/fR+spsBapar3NWYl+1TRCmz2564IbtuOjIO0ZZvZg2o3ZMjjwYERbxx1RZ2cszjj0qjkNRtUd/CxvFLf/k1AH9MIpiU8VL/mS/60hioWFhwuFZ5FniSFnC64V9vs4var1U46dbpZunnv6aniHeNF1GukSwgN/N+4OTV6piAZPazk1glGVxj2SGoQ/7L6kWPZ9oH84/bYIlUWdjA3XKEzcTLQM7ulxA9tPQz9MeK7yCcKPCJ/m27JUrmj4cnt7pzNw7LjSDHAY+7UooyaULZlTSyPsU49jeO3q3dlR2ktbRhAS0OMS79RMRDg3dbnjlBbW1eJKnXNCT8upWNhcmTiXQXLmp5fY1i1+G7WegChdOU1UPaMk7htDE+zn2hijoaoSAG33eHe0yZxLWOguRGUi6sIwsC1pvEonG3Qvx0+9v9304+Ny/si4uRl3fuwsZkPATwCdNTmTxbT0ejcre7z5nHc5+38UbBcokw5XT7nXMXjzPeEWV4LomR3Cge4meJ3qMi3afOkdKURgeB7SERrmUHiSZg5FhJonCIOTp2rus54U3EFlixoE8IZTcKyaN5CmR1P2dK6ulUla2NcC6r4CemsVnQK4havCY2EeshrC0Ij/L3p3BRo/i7ZRUyLP8+4r+mnzHw4B47x9KFpW8+ZcpzKaQWLGyhbtETS7qLPsAVbTvRKkMPAsBbK+Mpxc22y1NpCSCmI46v/sjaE1mFPnCNgTDmX++0fwrP61KDJ
 rDcfoM8R
 dgoNKhB6AfNiTRQyYyrwJ53GYk9D2XOYPaGX5BKeschd9vCOpgituipMdk+B4/8cnoRPd+yqWi0H1NVGP1SudE9/N3tUA6ZuNBPiiZQ2oOBWGPqmA2D2tEb60FfFGcc346KPojXVfjXaJuvYvUdjbcLS4S+mDA0clngbGYm7ffpn9lELFixltWIzfC30T6I60nQM6vOUB0vg4fKOfh0Eoild92PlOMdUBr+qULec3sVqyaxMIfa5Td0eYSmwYjfOU2Wk2X06iFas97gYXyMgE68Xf2oThe6FJU+cUg1tr/zQfOQEfc89rjP+R1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sang-Heon,

On Tue, Jul 07, 2026 at 01:37:48AM +0900, Sang-Heon Jeon wrote:
> memblock_reserve() can only return an error after memblock_allow_resize()
> has been called. Before that it either succeeds or panics, never returning
> an error.
> 
> Before memblock_allow_resize() is called, the return value checks of
> memblock_reserve() are unreachable and can be removed.

I'd rather keep these checks.

Removing them relies on internal details of memblock_reserve() implementation
and the existing event sequence. If the code would move around relying on
panic in memblock_reserve() may not be correct.

And the few bytes and cycles the change saves do not worth the churn.

-- 
Sincerely yours,
Mike.

