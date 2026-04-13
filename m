Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D0AEBFD1C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50D86B0089; Mon, 13 Apr 2026 05:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA5C6B008A; Mon, 13 Apr 2026 05:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1EB6B0092; Mon, 13 Apr 2026 05:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74E766B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:01:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E5B58D0AB
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:01:12 +0000 (UTC)
X-FDA: 84652938384.02.7872E15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 563F2180017
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:01:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfyW73rE;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776070870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tn1tr/EOCjX/U3xON55GSnIaEvRsYLTCTnfd5yyfW4=;
	b=UF6hoDEldwYk3BWdglFnrP/kpZSEexGNZ/jBTA7o5VHQitUh8wjn96lILRkyPGr2A0ge6o
	T442t+BUs7fwFv3Nxvzvp8uog6kVrRkfP+AiXxpqrFO0PrfDX82kx5lRJbqivsSBWjh+v6
	mLp9NZVeQxLQ7Hp4I08iVYM0+Gp+Oj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776070870; a=rsa-sha256;
	cv=none;
	b=nyiEFZMZOic5umj3BJZQzM2BLlriruuv6j7ftIWpQ4GqhnKu/wxCNeeB9v7UW1w6PTTrnS
	TXyNtsevA6kEWjiII7YmehHlSQ4gAyV7zQmxbLo8tO8fKWMgEkooesu6OZdfpeB61nkk3Y
	HYyuBZhCmDpl6/r4pUR9BYjrgtAP4bg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfyW73rE;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3123160172;
	Mon, 13 Apr 2026 09:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57513C116C6;
	Mon, 13 Apr 2026 09:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776070868;
	bh=NmWTXdFZa2PXaXxihxiBwP6/fcqhMPMR8Odd5UUj3qI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bfyW73rEx6WunGZVvr1kdbuQhIZW0auQdr185ZFOdqezYfVI8EqIl4RV+jZMHErnf
	 HHqywW91vp7CVLzZ8tl9LuEsJL2nKmijW0OQ98WRnNBsFsW1LYo4ZFpZLLA1RAeRqi
	 fLF9xsDW37jcs+y2EAiBEgZnfjWYwDz/hvRsB2Ow2oVioAmoaeXLVkxbmWKx3ILDyy
	 OFKArZB3La00uc7rhVgunFkOn3bZFgPE1fuUov3rdMuNp+wqIMsO2YWxMIl1vusQFL
	 bBAU79v+8ddAl2Ytb2JX6K5ckn/0H32ur+wYUjKyGCCdFu1O+cEC54vJcUyB4ZJ+rF
	 y0fFboG7dTA8g==
Message-ID: <67c579d4-4e7e-4b3a-a2b9-7ba669664bdf@kernel.org>
Date: Mon, 13 Apr 2026 11:00:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 14/38] slub: Use prandom instead of get_cycles()
Content-Language: en-US
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
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
 sparclinux@vger.kernel.org, "Harry Yoo (Oracle)" <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.525653921@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260410120318.525653921@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 563F2180017
X-Stat-Signature: pyuywo4e3fhima1ods435aoa1sk18iuj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776070870-836202
X-HE-Meta: U2FsdGVkX18XMbBVvZTHuiDBBG1u/xzkWEOsYgu5vuzmUG/7/11GPHm+OD+kx1voaoIiCVR4NnAZdgDtm10w5OcpJ7GrBoh1sNgQbtOMAN4xeFexd3wEI03yQkfTYBclgh1rVGOkx3VFwk2tqz5yGPfF7F0pkNkBx2+sKGudoi7M91cM6lRAbXrJLFQXizrrcryeTl6Or2dU0xqZmT2/G4uT1T8duS58XftDe5C8OjFABmZxMPsY4hwywqEho7se2gDIXq2kaChd7FqZqML3+cjf/q+Y5WpBqYDa9SnxPR1Lm/89Uo1jRoqrW+T2VPIQqNUukfcjjliZpZSoQZxRiEL5gYqRed5Y2J400LIrw0uNzg1v+X204id5/bKu6oVSpBv8+wSndqwrcP42+LUaD42FLmpf/lGXpBJ+um5ewzhu9HAm2dA6JcTV8dty80NyVlBclgmgSqxODA6JqkfMvhp8ssmaAaCzoyxn9PMOxCdi7JZjJ+gY5hx/fObltxJxF6Yh24/47Rpf8z5an2467ntZ/g31uAOOOENRk88M/UXgGFjGv5277MnXVxjU4sZklGDf5Neti8i6lEvpSmqd75K7ALmgl5WRymlWUBDFEKjRrk6vQlnO/BxCtdWneRXnUgz0458TpvReLXXmAsoOxfgVblq6xwHkO0BlsBE377KvQv0bl/zIJOY6wMoI7rDaHhxJYAlsS1G33uo7dwBYllc7U/Y63MabHJKq8728JyQXT4zrbUUPPe2qa/dDtScqCuOEABPaRRvnkFM3C1KON2Zz4tJQMxDYRxWTuRMCfWMIjnsDsVONUH/IZrY0t4u+ziXOCwCzBClxccywDO6ENib2jbDmTuDD921SCpLsIIyrrbSAPPF8UkmGxdF2rLPH5gIsZ8HBs5oTHu8C4IW0T/v4pc/HSxZc9ccOHjovq6eD4dMZIOr3H7tNOR05l4aB6SefQbC1Ji30n9176GJ
 sVlMnTU9
 hQBzAeqItYZPAes5h3SDcV5G3g/mlHPQoaxIN+cflybYoaNPc0JSm1VHkPSRZczVFF0XJakVmYaufxO3yFc2EdeUAppUmHYafkpXK7o0H4yb2AupwEa8rGeefABePraZ18eAE2jKPOxpHBlfm/ypTNMDX6ljznW9Lq1OEyTP6gOHhE5l/rsFvkOUJrBimmizAHsldUJsRSEebwxzTACJCOkk9BXI9VAQ2Z4RWvgxWZJSS3V6mogB5z63QpPCmgT7q9s7hIJzAA44QC4XtVq/Uc6i1khJYYWMBs8ehj4U8tcnEkXzlvBmvUpOM+I29y2j/4KZD4nqoUPhIOWrubPhFNizaBiUTTF0X4GWI48WI+0+qcAET82EKqKKGJdFwKcZftNZx9IXJCwfSQ785jczFNXxP/LHF/OMZ5HHKt1V+JbG2aAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 14:19, Thomas Gleixner wrote:
> The decision whether to scan remote nodes is based on a 'random' number
> retrieved via get_cycles(). get_cycles() is about to be removed.
> 
> There is already prandom state in the code, so use that instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: linux-mm@kvack.org

LGTM.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


