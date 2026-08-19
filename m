Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ECD6C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44406B0093; Wed, 19 Aug 2026 06:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BCF6B009B; Wed, 19 Aug 2026 06:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A313B6B009D; Wed, 19 Aug 2026 06:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F67B6B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:11:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 103E9140444
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:11:18 +0000 (UTC)
X-FDA: 85117601436.17.AACC29C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 146F0A000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:11:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sFJe1ZuJ;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+PPr4LH5JCo56T4OEcpqKtA6FqaZJJQTU/xNmje3fk=;
	b=dmZpi4AszV+O9x5llGUoDPx40q3u2nzbI82xFk0D+jZ9TzlETR4ne782t0SpR925xv4r57
	uthmAbj4WuLVWsI9Vje0rXt97h1VnBZW0b371nAxLLAJ2Y0DLOC6GQjk4s6of7v/7fGJ/a
	UlLb/cMLPcGVMesNHc1owtPn8BTb2VM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sFJe1ZuJ;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787134276;
	b=XD0FNBMj+C7BNIKtU9EKioiBoHK3GFJYQ3VV8U1eKaKDIDHEZnEd+tNpP5WSp38iYX4Spd
	l+CzaMMzsLAEr+DIoeiyKfFTYL5C7aKxZxMXt0AOLBRlKvaq076GyZrvlXU8RyqWcE+E9G
	AFLP+MS7RgXXdgMvzsFDB0svf16omYg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB328153B;
	Wed, 19 Aug 2026 03:11:10 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B44BC3F66F;
	Wed, 19 Aug 2026 03:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787134274; bh=jm2HpTC8cEcs53XkB4cm7S5Wv9tNGZLKt6fDNOQqogY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sFJe1ZuJ+f8GRxdAgY8srN1RiSC4v2YvCNlLlmUtqGq0JnBUN5kBgYHgAdtl1+WBE
	 86jkDS1YRlLddNDdfgMKb3RVjJvd/DDlHtSCIqjgjuwU2N63jNz2qDHOX98sxoLboM
	 FHd7s/Mzcrg9P/Q3NGrRDdX07qr9iwtrz3o25+oI=
Date: Wed, 19 Aug 2026 11:11:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Houghton <jthoughton@google.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Linu Cherian <linu.cherian@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>,
	Frank van der Linden <fvdl@google.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 17/18] arm64: Permit onlining of HVO-incompatible late
 CPUs if HVO is not in use
Message-ID: <aoWBPU9XKmKjfLnb@arm.com>
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-18-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708031129.3503195-18-jthoughton@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 146F0A000C
X-Stat-Signature: w8pgfz1oz9gtcyos55o7icrwfz54wfom
X-Rspam-User: 
X-HE-Tag: 1787134275-451221
X-HE-Meta: U2FsdGVkX1+50o959dWEu8D4Nvs9y11F/enB0hZp40N467NOhf2Qte9K7HMbukmI5R+r0vuyCwXh+fu3nfQqOw4PpbvP8JbWEsUO2nYtncfYjhGoRmXJa4gWT77tk9vBfPcirLJ+oaDCSW+/ub0UqPaPE9eyKHkSA5z8Qg6oVS7Uq8OJWCnNurT5K4FJeR2EPFYl4zIHdGi6YGiASQmnSgP/5kAANHCrUKiSRxU439qi6pV5b8cbWle5+WWJ2HFoLzAtjeXVhgBhlSnB7d1IKW2IVBwmW4ulWxj0esnXO8VS7PPEZ0utfwDP2TSTd+lpKHIkhPucdWLdrBH4cXu4PhwZ2kqeO5HzFgA3+b0+/4frHuvLFerygcS1VAedFvGR1w+OOntpD5gBZtasPnamsHaoYMo5fzKSUbN1nMwE9owgqAaBfoBghg4h6doCZng5ZP8hxy8hd9mkKPdAYuMg52fzPLaLdWhCxV5oJvBZDulfE5oD1AOUzxqjAcLLaKpKBuPdOZedmb7MLJp+MDbP6tsVqPsqiDbzGx6LaOWiEenhGGsKm9kElXB31nSL9FaRQudLMhLsfhsnk/TSa4L55gYu7UFCT2NA2I1eJkSB3UwySKrX8jrxq3OG3A2cRiLBY1kAXyi5j4h7KYWvRiMePkuOpAO9qRbgeY21XugL6m4TxHqh0746pb1pooHEb/bRXofBSUvBGCtN6nHFd/ehzqLU6yfdBHLY3FDsdH/48hj9DrwLBodlfatEvSNAwgI/d3CSJkANOvig9WI/iWioOazznOUnmQtc1Bs8yzsjIMP5TqWi6q8/qjdI6LGMFmbEICHydvmlPfPSpZ7Twqx7HHg3t4n2Q5SaJHMntKqX2Yr6DhyvgX3kMYaha2/A2ODfvxQao2Hbpea5j+14FH8HmF6QgsXvpjDAy+TixhbwnNUSpizPBm1emj1etZwbumVIYpgAyRCdCYE099VodCd
 boNhDQqf
 BD3UpVZ+kK7PpnMArr6JmLVnYe5xbzFYwO4FX1cTirbzqK/Mq/u8771lRujfAPA0avT4jT7lXeQFiGVWrOBhTMUAdbnLOeZTuhUfTMwIgSA/bjKz+9YuoYD6/0uyBTLALjXdocO8h+a0dontGmEsnAzrPBLhoD93TpdCjsoJUueZ/i1FU5LsIq7KIKMpORvjNcqIt/XMsXvEyeJz1Ui1LbX2D3BkFTxytFTFDdTOJQB0N7bs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 03:11:27AM +0000, James Houghton wrote:
> First, HVO must have ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU so that
> incompatible CPUs can be onlined if HVO is not in use. The
> late_cpu_enable() callback is used to check if HVO is truly in use.
> 
> If the late CPU is incompatible with HVO and HVO is *not* in use, HVO
> becomes permanently disabled.
> 
> If the late CPU is incompatible with HVO and HVO *is* in use, the CPU
> is not onlined.

I haven't looked in detail at the logic here but do we actually care
about this? We still need to solve the BBML2 requirement around patches
12 and 13. BBML2 won't be an optionally late feature for other reasons,
so such CPUs won't be allowed. This leaves us with HW AF. In mainline,
the check is done on the sanitised regs but IIRC these can still be
overridden on late CPU onlining with a warning. We only use this check
as an optimisation, so not an issue in mainline but can be come
problematic with HVO.

If we don't have a strong use-case for mismatched HAFDBS support, I'd
drop these last patches for now.

-- 
Catalin

