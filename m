Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DE0F8D76E
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 19:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0F76B0005; Thu, 16 Apr 2026 15:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A3B6B0089; Thu, 16 Apr 2026 15:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159CE6B008A; Thu, 16 Apr 2026 15:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04C8D6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:29:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8393F13BDF4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:29:53 +0000 (UTC)
X-FDA: 84665409066.13.C4989A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 085081C0006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:29:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjiRJ3JY;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776367792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUHI/uE+8wXb1NPS5/0fe9BrIRorqRCB+r5YbC8Vm6c=;
	b=WYldYGMFw+KFp/nIljJ0GwqUN4zNXHICyeiajdPQMuL4INw0wmIsBqfvQFzw6PJhaMs1Vb
	v9bGoHb9BVDtRlKey48t2EXTUSJTkPja6jkRMA+v1feQpVT1uhgRooKMrr7SwEdI3AiUIu
	bALANGsLcrpAc60z7mdiBZN1G5Ke+pY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776367792; a=rsa-sha256;
	cv=none;
	b=vKdwqGAAs/Mg2XdYewaLtcpxzvPq4OUMEAlZKzohL7MTUHmbgXQUck1hmWvsjmwLiNS9Li
	nioecRlfDCfDh7KE3zoDJ2599XmfSoSaZ7wwjKhhyjGQeDU5ay71ibJJxNymUZWsx2ZMto
	CX3wnQ/oA5NI+uqPlZhPuTpKWAstY1A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjiRJ3JY;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA94660127;
	Thu, 16 Apr 2026 19:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F0EC2BCAF;
	Thu, 16 Apr 2026 19:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776367790;
	bh=IYYhpzvOPkjnKmWSOWOV2gjFmCyUK20pzUwsrPCl5+c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TjiRJ3JYC6H6QODlRe73weMWqu2ToVyxgZaKwDYZeUuXvTFyEukiq8tmP1ejDxYzD
	 rmrx12vxM0g7ZC9obrRxDAfB+VnhJNvbWfFDZNFPe0bmQhLp4LsxxAr5syn+ysbEnb
	 CJFNwSq3IzVphxzvT3UyUKOg1K7FQt/yAeF/6TILljylkaralKACrM4Mn6BgOOeIKv
	 wGHlIow7JIanfsrwpPNBBsFvw34FcmmRQCfrRZvueDO/yyXUoANoGReW/3j6l4sYGi
	 SDFU6WZgysyVavWZIkFYQOfBKcrZOljXUSUoxloeAjzhJrasftfXxGpcy4vC+O3xsf
	 ay/dWzrcNvMPQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org, Arnd
 Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, Bernie Thompson
 <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso
 <tytso@mit.edu>, linux-ext4@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco
 Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Richard Henderson
 <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, Russell King
 <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Catalin
 Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, Jonas
 Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul Walmsley
 <pjw@kernel.org>, linux-riscv@lists.infradead.org, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 35/38] s390: Select ARCH_HAS_RANDOM_ENTROPY
In-Reply-To: <20260416134238.9230Ba6-hca@linux.ibm.com>
References: <20260410120044.031381086@kernel.org>
 <20260410120319.924028412@kernel.org>
 <20260416134238.9230Ba6-hca@linux.ibm.com>
Date: Thu, 16 Apr 2026 21:29:46 +0200
Message-ID: <87y0imemad.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6q4j9egkj59baend9dfwcffzgxig7w91
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 085081C0006
X-Rspam-User: 
X-HE-Tag: 1776367791-698788
X-HE-Meta: U2FsdGVkX18xsyP/yjeY1KIf2P5N3HwnmggyEjhaYFMVvvqxSi2/01JFqOunXchv//X7RmD/S8zF8Hm7BxYoLytcv4Yov3Wm/H/im2QuuHJKI16SpkaKsURM8wBS2X2+FprXVvT7NhE8rswcRir44+HC6pYcaOxW2+ELfA94SYLkb1gdBsfh8gj/GYqKN0+9VZtj/odBHEYaAsJtM59q8ID2DiPLbwTVHJGm93Q6heXI6kYaBMyfJbPUhtfk/q2G3ejySUk8QHcXWTWvIjAfZqSrh2NycfqzHiVUvLMr9DuUyFGrztb+bW6Inz04jMbhtiBXMkUk+1Pb9qemy2A8sebmdyNJTgWAu7hohiyww9P7QRr7x4G6GgblTqmwe8UEk0DwHTZDQj8+dsoDvHmof45jI1zlxWlFvu39A1xAtDcHpU2b2HEj8jKPFhKi1cholANi67Sy+N61CRiRMFItXIOZzl3cs9YVOhg5roQEFD80p7aOz9/fnnX85Ojw59EbRMIkb/8d1XrP5li/fOB8tGL5iUqCkyif3XHpi+Ddj3xr9gAbXKQz78Y8Oiph/hEe8XfmWcr6zW30wWSQZWqO4xIkMzvNc9bAeS75hCAjNUNHCQCkENGOD8cSv+MTv333TQTSYOtaibLp9n87T2CcuwoJQvH3wKkQSAnl41ewr/8YYsIeYxcxVkLJGBD8jCLlIYDbsERyetfHcGpJNk6R/M4Fk/xJtG4EYkEK4b/otDodFC+7RMM8CnK+418cLnMz0LQywuJRmcHibTixv17TydEewPyKArHscSNvM4VP3/PInkWBDMqH66jPvhSmTHronCrnzIkp1amtz2avPFya1FAAZSbsPc+yIPBiGDoHG4Lo022kodE5s/eHq9Vqfp7T3k5V/IvF4DfT8k+OgUFb1KcGP+Jte/rUqSzaCL81ULbmKNBjTm9hJBEWk61FJF3u5AJFI5snFT2XqKu64eG
 MUP8Qiit
 OZTMxx326Wd1XW7BJ6+jYVHR7TOZ1DX2M8ni/gKS8VzVqenXfJyAt9gjFsTDFua+WOh6L3LJC7bfhYdq3H+hVWlIQS+T5Gi4EOajc52Cg/0cAvHxkAIPSeuIbtmHHJ/ndFinSC89FD5bnWjFmkkr6kIQdhC+bICpXOFwuGpmTVZKJaIrewb3eT/lhEiWwO167hDSD0R2NKXjg/tviAuqW7V6Co0cPdXy/5F2UiYBXrgc9l1/Nsi23zThZkwOrXtAp9rxbZJUfVFyuijMtIoI5RdnaVys7CDHOLMsfHUJaHcNHI17ZRxaM1krfh2koIRz0VLNRCTY7mzBFThIjbiNanpw0eT/hIcUghyeWPwE0GppRCZHRNePYz+wGt9IFmfDM5oAvrWK+OxPs1GgtQgno/KsAbiH7D/5/MfPP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16 2026 at 15:42, Heiko Carstens wrote:
> On Fri, Apr 10, 2026 at 02:21:19PM +0200, Thomas Gleixner wrote:
>> The only remaining non-architecture usage of get_cycles() is to provide
>> random_get_entropy().
>> 
>> Switch s390 over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
>> providing random_get_entropy() in asm/random.h.
>> 
>> Add 'asm/timex.h' includes to the relevant files, so the global include can
>> be removed once all architectures are converted over.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
>> Cc: Heiko Carstens <hca@linux.ibm.com>
>> Cc: linux-s390@vger.kernel.org
>> ---
>>  arch/s390/Kconfig              |    1 +
>>  arch/s390/include/asm/random.h |   12 ++++++++++++
>>  arch/s390/include/asm/timex.h  |    6 ------
>>  arch/s390/kernel/time.c        |    1 +
>>  arch/s390/kernel/vtime.c       |    1 +
>>  5 files changed, 15 insertions(+), 6 deletions(-)
>
> Acked-by: Heiko Carstens <hca@linux.ibm.com>
>
> Thomas, would you mind adding the below as minor improvement to this
> series?

Sure. I'll respin it next week.

