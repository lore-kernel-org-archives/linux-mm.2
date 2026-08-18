Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBADEC5DF87
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB086B0190; Tue, 18 Aug 2026 13:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AFD6B073B; Tue, 18 Aug 2026 13:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36246B073E; Tue, 18 Aug 2026 13:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A71626B0190
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:27:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48A561601DE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:27:10 +0000 (UTC)
X-FDA: 85115071020.25.4F5892A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7776B40008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:27:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IX3g7lrc;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787074028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnOXB31TFV10yD9eNFs0pSKT5jxzeJrBcCejudXWSng=;
	b=YLuCdMg2o26znr8mXoKRRCBncbNvUf9k3XViyhN7yPvwndbgodvWLT8hYDKOPkt050yUQP
	97zZlVEr/9uc1TLiT/IWILWJEyljDLLlMKy6RJr2T5nJT97wgwOPiRxQmfw1z0GPRrYrWS
	wXw08sKf3WYEzGwupua+TaVJVW8lGxM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IX3g7lrc;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787074028;
	b=aaSCLK5WYDWKhU1JZBNzsYFutsNNRSw6i3oTEu5YU76iujjyDp4X7URRTEG/qS4uUbyNK/
	+0VUCsDs32dbjBF/1DZC2V/b9LkRmq/kxAOf3o8DvnvE5fwzVmazE7H638mm59EeW2DNVp
	vjIsPScTM3QKp05NDsn7J2GOsvG2nD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC87060A59;
	Tue, 18 Aug 2026 17:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560D11F000E9;
	Tue, 18 Aug 2026 17:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787074027;
	bh=VnOXB31TFV10yD9eNFs0pSKT5jxzeJrBcCejudXWSng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IX3g7lrcY8W40oZx6xy7VceZESyT61w2bcCyl5mnyM4dcit3F79B4nqlvS3XopeYe
	 wwjpkiXjgv/2grbz+ismIemK/11JHNrhpreVuh3HFooB9fz07R5Dv6NoceUR3W0Jd1
	 JnFgHrMSpLXBArEe4FsgM1Bp9kQW031ZiVuuAdPSVapdwjpC19+mWTIkyY2QgnUUmN
	 MOIE+mRqqLYTMpNo+dH2+aOet0tP5ooHQZ3uJAVOm3Pv5j1WH7xoLaQIHKvy9wH+yu
	 1UHbwwY7+hQT6hA18ZENP54Kj8N3ScPe3FgKQu68lYN1RuKJnHkEXbu+6dIEd+7gm6
	 ULsBlzyIcm3tA==
Message-ID: <276c385a-371f-4971-b50d-520d3faf5364@kernel.org>
Date: Tue, 18 Aug 2026 19:26:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 8/8] mm: Drop pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-9-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818040041.1891769-9-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9nqtu6nso4p49jrumn37xnz5jg5deab7
X-Rspamd-Queue-Id: 7776B40008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787074028-870512
X-HE-Meta: U2FsdGVkX19sW+bWi9wvmu9UIu/hchp+Kp0jrc311sMrLsYcB3z1oMBHQ03OA6hljkxLEP/n0RMPVro1gzjRThHWiFLYXJugiQHQSYEqUN/0CwXpk0r0cCnRcUe2nq/YbcWvFenbjx6Oq3XqapwtX14+oH7uOfAbptOAaa6FveAGbbgJJI3y6WlB6wkMaHwDBjSv85MS1lipOl1gIJy971L6Hvd+UvwilV62vpf09O6rgK6MOGbtK1g/UZbFSQJQ3hzIr2d1wg8aLF3ScelWwCKeXy8wyo+7/3Q/k3Oqe9SIDhZKZYrNt6wWdP5ftnKAQiTj196/inBc2Yza+ZoTiA4soUoUzsjxrTYM3OX+j/6lI8s56w+Fdxqrs3BzK9lPTqphpKguTNjjekfdT93ksrmR8C4wFYzonfnamkYzXa2Vok7pXCAUluZcdAkXTK8zlWAvb89ntrOFA/P9epBSdHv4vy/vStBMq1r2ITDDenyBbcyz/ek+cEDrlvE5sI5VIiVrcJWVmJDAe45zs9RNbnNKmf8fFj+four1qkuGyjq/AgDXUqJL2l2i7m/SjIDsjOVhFGGvNYW4TmfvxjvEYIqvQ+vs/tMUxagXuPe+XfWndrdaF9dvvNfxpQM6AdfYmWDrMDBiq4LEGpS7oFh+2ma+24R7fGpm18NhwsO0FctqDAJAdrL6O+uPexWxUlqJshiIh/iYjuYlyMDvOPtVz9nxPGFWXkT4+1mdKhfPX9+J87H08tNj3bTkhdDN9k6roauENsfqcUvGY1oNXvkhFSjG9zt89GpU36Lz8hxLEAY+qm3/nnZQrJUTXNclGNvle6IRf2ZtXfsAEAZsKzWJ5f4B5FlQG2H3Qz8NGmaYSi/rKz7MIr5otuj+AejBZqr5UKa4pW3G2X4DEpfaOaHK6apNaqVJKDw91aXECmyXftRgTABT1Z8o0mti7fFzz4eU6HIDjiI/IQ0MqsbgRfL
 JHkRkMLJ
 tma6q+V5D2QNiMTQs2trEmSlOmQRhMcmnXRgngGHPJkdbyDuVNja/lEJ8hsEtyKAQsAuN57KsHnhw1OxL0jjLCNbqohyYmVnk3+aICHl9XH4+q2zuF6Je2srjfgkCBJWYn9Zbh6QBTjVkJBOuR2c83xQ+NbvFD0ZOd52eEbt0b+pF2v2oP2qB3yP1l8ng/b9UNyHZYJSN3plJ2IH8sQQW/sxXVwfXwgVkGF8JOWue6xL3UvG4Wehmdhnjv5BR8+Lp9WoO5igHjQypnLCEYU05pGrmWV7p0Vj27QD0ZVxqnyKgZEOl6NeIxRgoSOhv3PLUCQnt3ITLVEJ+bI0m/uXHkFIf0qb2ZJzVhqpjd4vAwyUBYHnwDXTcevv/RMyW9sGFfkxb4kA+RE+JoJEBmzNG7GV8Y5HEJzCRaLPONDybpTnBKExY9rUicwoE8IzxXtt0y1meUWO2ZwUM6r8Q6+HqJi+qGyevxvHGXOTbgHdB6m2QamDEK5V1LHUZYWBpivryGAzr4h1vzTCY6InkBaM78mYVRCtLSu1J/l7lXD/AgSzhCwzmZfGdKX+Eup7CAyUIL4CQol0/9kethFutVe+JHeDwoMXXEPraSBdLcahF0amCzor9plom3CKIjGhhzMGxzuCqWtHLV92wKBUYUw3uMOBB+oIyxEB8VWbUPGWWRvg4tnzPrYa36Oy0rESVSC1bf8RRYQffQU12s3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 06:00, Anshuman Khandual wrote:
> There are no more users left for any pxd_ERROR() either in generic MM or in
> the platform MM. Hence all these platform macros along with their generic
> fallback could be dropped across the tree.
> 
> Cc: linux-alpha@vger.kernel.org
> Cc: linux-snps-arc@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-csky@vger.kernel.org
> Cc: linux-hexagon@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-openrisc@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in RFC V3
> 
> - Moved ptrval_to_str() as header in a [PATCH 1/8]
> - Stopped using pxd_ERROR() in generic MM in [PATCH 2/8]
> - Dropped pxd_ERRO() macros from all platforms in this patch
> 
>  arch/alpha/include/asm/pgtable.h               |  7 -------
>  arch/arc/include/asm/pgtable-levels.h          | 11 -----------
>  arch/arm/include/asm/pgtable.h                 |  7 -------
>  arch/arm/kernel/traps.c                        | 17 -----------------
>  arch/arm64/include/asm/pgtable.h               | 15 ---------------
>  arch/csky/include/asm/pgtable.h                |  4 ----
>  arch/hexagon/include/asm/pgtable.h             |  3 ---
>  arch/loongarch/include/asm/pgtable.h           | 11 -----------
>  arch/m68k/include/asm/mcf_pgtable.h            |  6 ------
>  arch/m68k/include/asm/motorola_pgtable.h       |  8 --------
>  arch/m68k/include/asm/sun3_pgtable.h           |  7 -------
>  arch/microblaze/include/asm/pgtable.h          |  7 -------
>  arch/mips/include/asm/pgtable-32.h             | 10 ----------
>  arch/mips/include/asm/pgtable-64.h             | 13 -------------
>  arch/nios2/include/asm/pgtable.h               |  7 -------
>  arch/openrisc/include/asm/pgtable.h            |  7 -------
>  arch/parisc/include/asm/pgtable.h              |  9 ---------
>  arch/powerpc/include/asm/book3s/32/pgtable.h   |  2 --
>  arch/powerpc/include/asm/book3s/64/pgtable.h   |  7 -------
>  arch/powerpc/include/asm/nohash/32/pgtable.h   |  2 --
>  .../powerpc/include/asm/nohash/64/pgtable-4k.h |  3 ---
>  arch/powerpc/include/asm/nohash/64/pgtable.h   |  5 -----
>  arch/riscv/include/asm/pgtable-64.h            |  9 ---------
>  arch/riscv/include/asm/pgtable.h               |  4 ----
>  arch/s390/include/asm/pgtable.h                | 11 -----------
>  arch/sh/include/asm/pgtable-3level.h           |  3 ---
>  arch/sh/include/asm/pgtable_32.h               |  8 --------
>  arch/sparc/include/asm/pgtable_32.h            |  3 ---
>  arch/sparc/include/asm/pgtable_64.h            | 10 ----------
>  arch/um/include/asm/pgtable-2level.h           |  7 -------
>  arch/um/include/asm/pgtable-4level.h           | 13 -------------
>  arch/x86/include/asm/pgtable-2level.h          |  5 -----
>  arch/x86/include/asm/pgtable-3level.h          | 11 -----------
>  arch/x86/include/asm/pgtable_64.h              | 18 ------------------
>  arch/xtensa/include/asm/pgtable.h              |  4 ----
>  include/asm-generic/pgtable-nop4d.h            |  1 -
>  include/asm-generic/pgtable-nopmd.h            |  1 -
>  include/asm-generic/pgtable-nopud.h            |  1 -
>  38 files changed, 277 deletions(-)

Nice

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

