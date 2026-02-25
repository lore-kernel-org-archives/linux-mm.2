Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F844FD375D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AAF6B0096; Wed, 25 Feb 2026 08:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE876B0098; Wed, 25 Feb 2026 08:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB366B0099; Wed, 25 Feb 2026 08:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C84C6B0096
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:33:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33E2F5948C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:33:23 +0000 (UTC)
X-FDA: 84483070686.03.49BED7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70F0EC0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:33:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJCkpZ0c;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/BIt0AkrHzZfy8VWEHWcN0h4Kur1kjxpemvkiH5QGE=;
	b=C6hOI0N3Q5q6m16SvfZkMTsChMUzzq5rK2cOIuIPwkRt8aqsH3bQBhdoOUP8JW/LZ+CcZ2
	CJEMyvVXl3gD1UY5qTTknZk3L22vC1DWAr2SkgeobYxtUMHHI5CrPSUIOaLZ+tpK6Ody5F
	EEmevO/tYSheNgPlwjpkiA7KdDP39Oo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJCkpZ0c;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026401; a=rsa-sha256;
	cv=none;
	b=V9/e6ttzNVM+arUBHMI+OaSTz+GR2xqVnBWtu79rZkWddkAxW697zyQkP50H8H33X5omNw
	5hSn2PZwO+LdYSJL/MaZntWPXatQ0daRQ8Sv7TeMBdzE5qff8mvuaf9TtmC7yyoWWmhiFm
	Fc4e8QRsGXzVl5svzqxeRil0wTsh8OI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D67CD60054;
	Wed, 25 Feb 2026 13:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58BEC19421;
	Wed, 25 Feb 2026 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772026400;
	bh=ZKEw1M2s7XFotvUcCDiETx2C3JnnIOtIpjsC1zCO9VI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qJCkpZ0cc47LpObHi0ME+D+ssjzGR+srEweXb4I3/4hNUqYO3ivvqSYoLaTgWlu4Q
	 SOOTLCCloxOVhAf3rKNOpaEZSDPQMp15xzjtNYjyA86ykO7vouTKUw04YJ80+rz7V/
	 l0HYvmOpo1MCbQ9OpjnJ72iDP9+bvb6gcEQffzWvf2yLTEddhtC9VYnvvamRSAbbZR
	 qcMFiI2SVb116plOcQo8ASLYucYpI6HsAabTgocn/PGVKVMmLuhxnrOavEEXvgkrs5
	 l0zss6Li/KWG610eDCmUBAhLUe23uhKcKHt9pXIvA/54i0h0oAbFkB45RCMM8YUxqe
	 mtBBUPx8BQeYQ==
Message-ID: <5200f32b-6212-4ba0-ad6d-f8b30ae455e6@kernel.org>
Date: Wed, 25 Feb 2026 14:33:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] riscv: shstk: Use the new common
 vm_mmap_shadow_stack() helper
To: Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-mm@kvack.org
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-4-catalin.marinas@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224175800.2500729-4-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qbcwagwngmmir6sje5dr7he59z6bhuqh
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 70F0EC0007
X-HE-Tag: 1772026401-100294
X-HE-Meta: U2FsdGVkX18C0XCtvtWWZvARMlJA+AuCgC4xqoQx0fv/D602jsAwLSV+EPHBIJF6PimLB4S4kzugQFdbTQgDdUDPSmVpQQD7Dah/1Kc8R2sWTnH8K/sFlJw7PDoG5xLdmnWdgNBpHkwRqB8RClCu1zzMasZSkLmQvVMuAqUzjtpd+M8wdrzbtwxPc1EJNzetXfSRLiZpu05GmKtnqy1LpSl/iGbTz2QaR74NylFQxkTwQCLoWsXbmoeB78b1qkYvEqQqKn9QPNfGQVXF0VI11GINM4rrdHTIeIRJy0bF2ar3r8CaP6bwGmzXfOU+ZZxYs9ckUo3Grc+TF0xaMRFRsXQLlIVpC3xFZNbvtRCrtoW+vY8226oXM45kVtcZVjEoUNLWW+QrN8o0B8hPgnfOiO8tsmDHtd6/8ocGSRqRMFUniYjDgaT58yV6Ugqde+K2u0w0X36EPuw2okku+9DxbAKj8uadWCPNChzKrj7XVpSrmh4ujOMhFTvToEI2wnWPfhBSQQyYE+XK9f6NUVAu0q0LHNPWZ2PlN9duTVW10eJRdeP1DihkhwaajzGP1LuRTLGDz0m4f+6v/DrS6hmacCkoRmQOSHUcLAXHdVYJYqkA96X17zJ077JH9Qmf1QNpxotFshuuZbstuMO8rE5M7C+rlhkXEUWsBpT5ObqevbLL874xAGqHiMTDngjXtbpOL2W3Pxu90eRW4EOmGV40nSI+OfixtlQOcaQD4llaLwl/Q+mX6Mum8UEfxuSH790YqO08FI8RYfQf80XgvJjRpi/dbZDs2JfNhgEbanFP4Wvro0DBEIe8sA0Wr8yCEzp1axLmByWLizoIwTmpdTUZYZ+QqDc5CLOIpA//p8jhDaxkzplS1nP6t0chK1RoqkqG7tQXFU8JxYtsQ6jUT8r7rhLoDTlmYQur7pLtnqMGlkcV46M5Qj/W+Hdtp0I8yPh2MbX0uUHqMux9t4Bjy/Z
 /xSPv6mZ
 2/Qy1IINbcWg1cRBdRagfMcMLk8v9C2mOB4VeA5j6MIay4BpYjiicHPWV54SNyLP2GMMl2eaWlAXgQiY1fMQZb1QZ0Dj3EoX0bWOSw0p2T0l/2GwSNNSbuJPq/AWH/+EMYdB/prIRN5Kz8SGFDEcq+D7mWTcUj2XnrcHJ9qMBYBjN00UbLeA9s865YeQFunOQZOGU71yxXl70kY6GxiIM/lEYALbGx8wvl1BtHsFiVvZuX89+kLUmpTEm37Vd2fbOQZxcyOsc3yty1rqryIZGHeLhCzKnxlrK6EodECzMEBdBpBQ18ni2LTiyDkR95X1a/l1PIyyANSDVGoqlngANEfKP5qorO2O0KpcSSyCC2j09H4yBknfqX1DBKbQyvp8rJ9OWQr5TWlsdz5bfej8Z/pkvk+uw8ALCKZS3uBq6WOnZDHhZeCSkeR7yY73jxqQW+xZ5M7kgHSJ5VwONnGnwl8MsueJ8s1DhEL1Qa5UwlFUDjLCh5ARj8Jvjvc38WnUS0viL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 18:57, Catalin Marinas wrote:
> Replace part of the allocate_shadow_stack() content with a call to
> vm_mmap_shadow_stack().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Paul Walmsley <pjw@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: Deepak Gupta <debug@rivosinc.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

