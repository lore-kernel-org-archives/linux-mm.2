Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89962E9381D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 05:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B53726B0092; Mon, 13 Apr 2026 01:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDA06B0093; Mon, 13 Apr 2026 01:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4756B0095; Mon, 13 Apr 2026 01:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 852EC6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:47:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30871160B9E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:47:50 +0000 (UTC)
X-FDA: 84652451100.19.DECD6F4
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2388A20008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:47:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=none (imf13.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776059268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sl2okSSer0UQJVmm+gu+avWeu7+IMVxq4F8/vWo19rI=;
	b=DweR9+FDdbQx3yadjhsF7tUEY0jI5E5Scy8er4p4uHDOgT998kl+Vfz+lytq+N5gh30tIe
	azlbUiH7kh2dWhkdrzrAEeoD52XKd9jPLi1PiDil918zOO+k2NIfK/3+lVLoRjGXBrT9vD
	nOb803PBIYK7yMpyUPv8LkYxcgtBrGo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=none (imf13.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776059268; a=rsa-sha256;
	cv=none;
	b=7pKfNLPrYhSA8l2m6IfMFAc1/QsCEvDSg+/7t4CaiUY0fSDqDtqKdrSwaPzpJwdwhkpzox
	paH6EYNFSbJKz3Mo6EJpHqN2HxSXwKW+wLBpaTOl3wonyr9Wo3UYVv/MqXMvasLrBPt0x+
	tFXSRQfHFyLcYxr0KahW435dRBt422Y=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 2FA4892009C; Mon, 13 Apr 2026 07:47:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 283D292009B;
	Mon, 13 Apr 2026 06:47:45 +0100 (BST)
Date: Mon, 13 Apr 2026 06:47:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Thomas Gleixner <tglx@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
    Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
    linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
    linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
    linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, 
    Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
    Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>, 
    Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
    Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
    Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org, 
    "Jason A. Donenfeld" <Jason@zx2c4.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>, 
    linux-arm-kernel@lists.infradead.org, 
    Catalin Marinas <catalin.marinas@arm.com>, 
    Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
    Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org, 
    Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, 
    linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>, 
    linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, 
    linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, 
    linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
    linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
    sparclinux@vger.kernel.org
Subject: Re: [patch 28/38] mips: Select ARCH_HAS_RANDOM_ENTROPY
In-Reply-To: <20260410120319.462206386@kernel.org>
Message-ID: <alpine.DEB.2.21.2604130638270.29980@angie.orcam.me.uk>
References: <20260410120044.031381086@kernel.org> <20260410120319.462206386@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 2388A20008
X-Stat-Signature: 8rjjzu7wybdix55u33d76wi1z9jwgfom
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776059267-182186
X-HE-Meta: U2FsdGVkX1/PNbAjGAGyhP9RggubwrPrBk2ROXv6tVeUIGMr6HPEgs88C0XFRviOiod5TaNu2HwiZq3sYHsuTRGma8Q5shY7qaSwibQ3+uwmNG6IR8J6V1N7WOcOGNFXgPhUpedvEQevGEOwD+fPsv5nlnAfWwGuHeM8aaz0Oi9cFYdvlbwoSsRCNcHhagmogLu5eaZEiSxhsOeSjKcPKhv9XxLrY2jG0U2a4Z4LX+LEGEbylmdx18+yoFi4kXK0wut+b8dnxw+lxLWswLmC8h/gkABFLRMwAG5AClz6W6Wp1m0EZTs5Qg7IRE7d4sSYZwRSjSTZxz6JUEoz/ZuHRyo3oGON9lobjNRt4O1DPNIqK55LsMy/i5ZSXGPTWJ+qJT9FTNEsgctOD+0K/eFp5iaElPVMu49vPmY2IgTFDB0TrUeu+zDMtT1Ii2S/fUZCJ7c6WiUW9QX9dp9LcTjMWWERwNsLbKWkF4EOo+Y5uVMgwFHR5utING+RmKXuXPNo6oykNIrhgYq5OodaL7fV1yKR2bqw70F+/TKqGmk4nDbxoN9U4wQW5etVFV57Oo4ymfRfEW1vMSh8hYegEsTFgzeuV5TkCzdP6wZxo2c4UMBpfUkDXNJYjwFTai0v30PveJQmnMbHjcjnxMcYojHUezEm9o2nvmkIK3Ay4jqoOQq8jy+uEIodmRd4aQZ3cveT+1j/fOWX4a0kOm5cbMVQkNgrYHA+Tsy2P7brcblL16yBGDz6F4fBpEsicAFWRqAg6XNeNJt0zDlXCP0Xw2JHJCmDgXIIqYeD6ARGblfI8mTWHKi2ZrYGRymPIA6Jsg6Xx+b9T8jUSizKrL9HwNlO30NwJPYkHqyWZQjvf9eyMRZ7jnzrj1/UcwzhzKmv3c8RvdENB6sDl2O5Pc0PGoKSJ4ktJqZl6jcYNxApHqZej+g35INqBylS6ZgCUMQj+VP9GhZyRFxjvq4n0qUJCj5
 ZI0a4D25
 w90u430cZdM4vBL17SLfTrUuUouqI7v5s3rr4pNmO9hDZKzpEBYtMPhEQk1efxMxcU4jhkYB36hyoP+YQApV6HCOt0OWNYBcsZY//FBWh199QNttyWkFOIBnbUbXAh4bcxfvoCFwBehV9iSwaTt8dAcG8cIiEklmxD6ZuvQzn2hEzjC3Sa1hXyICmzyHCUy7dpDQ0aPWWplPTFHpHWF8YmjWkLxZy3LnUk6fZItXWEq37ST5sf8TXUBUjGBZj0OkpwA412IvFyXITAvjOa5EiP+74ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026, Thomas Gleixner wrote:

> The only solution for now is to uninline random_get_entropy().  Fix up all
> other dependencies on the content of asm/timex.h in those files which
> really depend on it.

 Oh dear!  I'd yet have to fully evaluate the consequences, but offhand 
this has clearly turned what compiles to a single CPU instruction on the 
vast majority of MIPS platforms into an expensive function call, possibly 
also changing the caller from a leaf to a nested function with all the 
associated execution penalty.  Is there no other way?

 Cf. commit 06947aaaf9bf ("MIPS: Implement random_get_entropy with CP0 
Random").

  Maciej

