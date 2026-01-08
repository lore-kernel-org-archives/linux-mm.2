Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B446D14892
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 02:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4BE6B0005; Wed,  7 Jan 2026 21:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6156B0093; Wed,  7 Jan 2026 21:56:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6096B0095; Wed,  7 Jan 2026 21:56:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE01C6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:56:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D37E1AB206
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:56:36 +0000 (UTC)
X-FDA: 84307283592.06.13E6D2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AA9A9180003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 02:56:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VO9+Hp/X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vgupta@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vgupta@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767840994; a=rsa-sha256;
	cv=none;
	b=mGeyX2Wkcupss5e0WQYxyMV51Y8141shO8Yv8EZ+x6QlHi9FcUlCR4yhzjW/qcDp+2PPhp
	kJqYnVss0kRMGmbpuNYYGc9iyNnXy2mXPPSbExG4dbFXZ4xg+gIY/hG91qL+AEJYuUooU6
	DVF5vchIUYWfjr7dE5dVOSadx+ZYzQs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VO9+Hp/X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vgupta@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vgupta@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767840994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bb09VXEHSGVuDvACYJHsjuF/qKdFpVlUXhZlI58yIwU=;
	b=GVo5O0BIPwPsUIavl4ezF4mYdlB5G/vkAuTdz7u+xh41fdyr7CEP8iXrovA8d5BQKk2C37
	/Gee5/co8FAJjx3Vx+NECLfsYtvE2FUlbMTjqumvQQKcuIHwhnf3ZrKmP4tLRqRu0wZZ/d
	4CDmpxHYwRIVIHz7d4I2CzmdbGjskFU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8034D6000A;
	Thu,  8 Jan 2026 02:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97908C4CEF1;
	Thu,  8 Jan 2026 02:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767840993;
	bh=bb09VXEHSGVuDvACYJHsjuF/qKdFpVlUXhZlI58yIwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VO9+Hp/XVRs8XQB3IDBstup2R+DaU4I6K4mDp34Wm113uMcakMBKaj2eTx55ExHtE
	 nBWUzkdaWvlhDxELVvEA3C6puD6nUZG5J+gpcQ61WkLHnhj+M05LSE5AZcHJamwhvc
	 j/BMfPrbYmdBOqJI5BeEugABP3Mc/vfHCk9GLrpJscoyfLAOJwB+2t8XFPTPsEybag
	 xGnWNL183qpjfSIH8SOBIaB8sVnhazL4Rw/1WNvWFQdpTNcIdnvnpj/0Brkneg1BPR
	 7qMuhdE1AoXtCk2F775jaiAkT9nh2gM4h7JiM3GPN+qLCo8vxQs/u1WGbxiPYaxbeg
	 hV7kgr+lj43kw==
Message-ID: <dc57f648-524c-4fdc-9fce-73f1bab2fee4@kernel.org>
Date: Wed, 7 Jan 2026 18:56:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/28] arc: introduce arch_zone_limits_init()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>,
 Stafford Horne <shorne@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-3-rppt@kernel.org>
Content-Language: en-US
From: Vineet Gupta <vgupta@kernel.org>
In-Reply-To: <20260102070005.65328-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA9A9180003
X-Rspamd-Server: rspam03
X-Stat-Signature: qeobwnfk7drnjazohkgbgiqb69wpre4q
X-Rspam-User: 
X-HE-Tag: 1767840994-454810
X-HE-Meta: U2FsdGVkX1+A7WlvgJBO6ng/NEHh13APnSFbOB0KxFyhBgntGHW1+58kHoichLjBsBqxZDIfKqEIyTdP70J4hgZ2yP2tUollYu8gfnsKX1Bp6MZ3eqIGvZvhhvEiXeuxJlTE1BIaKT899EjS1vzg+jBFjrehAMx/kVfn5iDjcvK31GfQvGBCLgA1yW5QMkH9G7yXy7eTcmzHJ1sDeEt+Nb/MQS6kQGc+MK3/7+mgAAKn9GcSKzMufsZLjyLcqhvSC7eDP97Goy34eqcUitYvpOqbTmAi2f56hXUplC5QHt8FGbxHDaqKzPdGGEgGk3NrU2jnAzjB7CCPrAvZDmXW4XCDhJGdn5bnJsj6OU84YoZtEFIxApLaqMiJgA7whxteKfzsAElJOC1e6F5G2cG7JTLiVwzpRWIu9A03tbXBoUrI3ZW4fQMOeVreCBAJgOaKVkwcSTz7r9qNw1dejyr5k8Gp8yuNxeHPV3daGTrBBe6XpcL9jZ+1sTYQfuulXkHXtrTUuBD9otLw+B8T4v/nBZA2BwbZHcLAo1vjFlH8UiOyFO+tK+tA1cGOJlVrKKI3F9nVeflF3pFfAjKOB+FDbsmJKONqHjrie9cq9cc9REupBtO2AdoUHoInjdydgxqaF3GXhuYvpTF+N5/lnDi7OFbCzH4icZrfXGMr/MR8yVNvTk7A/rw+NWBt48PEtEaxusHZ5g0eh12+lXwCU6q/hRXaSTU36ah5erzVZMlfktpcUGXyYwY74OL0ZSl1ORDLSJ1Kbwc7wtmqDBxXVRL2vn3LvFOO0viEx9YOge6pjAjRFvULoiMCwP+sq5rcVCOWKmJcV8UAXqwqrZMgouZxLrqXycPFX/p3q/zxm563IOobyeTb45E5UpveMfVVKUdXq5K39dNMEv9c2g2sOdFIJr3BihRBMIg++vd2tcyI3Lcp+Vfp9aQMEUC2j12KGNg8F/hX5tgS/rozCzOZ5yk
 KrCQ0HQn
 7f4S6DIEehEveiUQIb/iUstfLIHx9wwN3ymn7IAvX5EdSrpqVuV9FpCAOmwUpoPDFFFMx24pgbDuAMt+gzkgozdNDczpsG3HRFPu9JgTUvCDJsae64ZRPUgVrtlqcN68vQp+7AoE5ciCzyges7nKU3gsatskino0E/pOcFJ+9bJZNjdZ1ujCVHw56TrwMCU7qujGXVONlqU0mk/0pW8zc3mz1k1Lht7SDYR3ZLo2UYLPoFQGzMR2bXVFgN5jhgr8z4w80e8vVs46krFkUkiigk1EDY7qNH2uPUqmx92rEQ30NbmzKgvSYRyTOrZ9i5xIR8CnuPimmPPoSpSY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/1/26 22:59, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
>
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thx !

Acked-by: Vineet Gupta <vgupta@kernel.org>

