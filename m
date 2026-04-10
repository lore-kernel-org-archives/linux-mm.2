Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA8FF459EE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D94F6B0089; Fri, 10 Apr 2026 11:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589C36B008A; Fri, 10 Apr 2026 11:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478896B0092; Fri, 10 Apr 2026 11:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36F2A6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:14:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1CD6140336
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:14:06 +0000 (UTC)
X-FDA: 84642991692.20.EFB1CEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E6241A0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:14:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQRfv3hP;
	spf=pass (imf19.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQRfv3hP;
	spf=pass (imf19.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834045; a=rsa-sha256;
	cv=none;
	b=a0x7SWS8FM4ETntVhfy0aUt2jXnSIChx9PtlnVWoymdGEGvNhRIW/4tO0IdkpgJb6Y3sqI
	p9PGAhUaR7dTl8Du5tZbNFqYR16zFlRNTRgZIlTENMgU5JuyFkrTfdeZ8TGtZb0HHOdb+f
	MGiHE8vBNuvefe0fhiufD+xB8wKhUX0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6eHisBYg7qyonBevv/veresEfTDm6GmxPzgogzf6FU=;
	b=7dGIieatKeqI8rCgbjLnsCio2vPO/k53t2lmCH12oB38zSmPncRAehyidtTP6Lt/OG6+3I
	kOyD0OViJbu+RXlPb4jcwgwFHY3/nTkwJKarvdSb6ELl5fQe7HWlSal3bRTu+3pTIMji7a
	BWJBOOYpgk4VCfDqBYtbRisAU3J4xFk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B0CF43DD6;
	Fri, 10 Apr 2026 15:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA7DC19421;
	Fri, 10 Apr 2026 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775834044;
	bh=ZX44VkA/oGGdYrqGVtHG3BQ09eU0s5TAD8UsmKEvOJ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DQRfv3hPFw/TKa/ZakF0C/CvhlLPEsVqQv+2r4uwxdObvOGMMWr2s346gixb/wzYP
	 kH3jI1VGrMbPCg8bbeliLsWsv0WorMVV9pr65pzZbqt3ANfLMAZ3WpCzHo7EbPC0aw
	 sFqvG5W5Zh5Zl9hqpd/S10vk3SPDt4AvvXdP7MWFAVnJ1yy95RtrFN5r3P/n0YzraC
	 K1ddeqgVvP6yW3cqrHOPD+5bbhJuKzxhUEtkBkREvZCz2D1PF358eBsZtX1OaLotF8
	 mIrAdKqmlNIgawRmNAF5mT5jG8tytmCXBJPCuscrYjON8tMw7soKn19X1CoLhvhPBR
	 sIA/Sxe0F1CKA==
From: Thomas Gleixner <tglx@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: baolu.lu@linux.intel.com, x86@kernel.org, iommu@lists.linux.dev, Arnd
 Bergmann <arnd@arndb.de>, Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, Vlastimil
 Babka <vbabka@kernel.org>, linux-mm@kvack.org, David Woodhouse
 <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, Andrey
 Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer
 <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org, "Jason A.
 Donenfeld" <Jason@zx2c4.com>, Richard Henderson
 <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, Russell King
 <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Catalin
 Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, Jonas
 Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul Walmsley
 <pjw@kernel.org>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 09/38] iommu/vt-d: Use sched_clock() instead of
 get_cycles()
In-Reply-To: <9db9515b-08e8-47bd-aced-206ac183195a@linux.intel.com>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.187521447@kernel.org>
 <9db9515b-08e8-47bd-aced-206ac183195a@linux.intel.com>
Date: Fri, 10 Apr 2026 17:14:00 +0200
Message-ID: <87y0iuzw3r.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E6241A0005
X-Stat-Signature: minjz7rdb435f3w5tdg8c9uugzcbh13s
X-Rspam-User: 
X-HE-Tag: 1775834045-396660
X-HE-Meta: U2FsdGVkX18xLOhgvnGTmvngnv4UYQhxlja0aHUM7ey86y9vBuuWNThXXEMPRmAkxrBZTyBaQoF/Br4Zil9VbnEsNdRS8E4ck3jbuhY9sh9Hq6vrrw05vknYe31OUm7UJ/t4ZOPWiAX9mmFlEY+ZBFxUGUHL1Kna/l66i5O+ZEj0iHgEtEsWxz+/fMovxUgzbOXlKBxW5QqzGcjNRnNuFi1P33OvGMBBNEQ9DtMHlMqMt4bLycU6/ZNKW/E9EKSLoZDH5M4DkfCdnDMg+qzNLri8Pzmq7zuJvAqZBo2unC0lI2911iIXJxBb1eRB+LMLyCKmHqI+JH8hsjSShudRIvDZlUEUBWNhIasJbHHZKD9AF2w/0FMFVD4WFjeeWFQ6jUs5osGvUCmYqOJBzXtvR9VRiyJ0mXrORJAHyc1jI3nxvyv2A+I7eT4WCq6F4M7jupHYVCqIgRKO0RQ+goQb4yx6DIzSh+p0fu6gpJXmtoaHg4O3y7nUJqHqlA/32pRbaMmppwZG9IDjZsajBTd8RJ06xxops4MBN2YguTM+IMfIGuTojK+i8uw7+5wCelTbAfpU3LH6OAW/MFRY8UZbEo8StAvLt16ZuX1Y5QfuQc7vKdoTOFwNkZTGqIp+/JF2i8hlRitkq3YRaiTiqlXVVo6OCDgIlHKt6cPYowCx4CAV7x7/g2QMpH7ZloQ3KajoEc60PmWNEScZIRJ0RNFOn6UubdWPxs+soFTZNjhy9tUjORaG64Ik6W7PwuHuJpkGw24ViCzOBaMpyejLSDngOKUVlewLbKZPpunkDeQXlXv9pNRHeRQWBKCTytZL0lYBBsy9xZEG3OrenI7ey8Iez5zFrg5bUf9nHzAtHeLTmbglpGk3cCqGhuF14m9VQc1eLWRIaRSaARa0NW+roaW1YRytn3v7VFhh5HvhrFYKgJAaZWE0UQb4+F+E3Z7qqkM83A0gylIVn2l+ExvSxf0
 XbHk0Xin
 2aS6mxPw6cItDT2gfazSyispIRY84Sdewv8PvxCbt1oTdehuA1WDW4dgahOVYmrENDRpesrIzDjejDukme1dzxDTjtdEjN9ahqqGQOV3/uFctgvuT0cpeHXVFBkdeCTYU7lKpSe/tHJSs7ArqUi8RZGpf/YLAVYaUx5XpM7617EPNMEeMEXlnLvikEfEVGOPuGY0ZbEb700G5BvkkIUjqtgMhym8QqzWIT3sr5Q+v/DDrQsMrWLF7UJ8kHbHdSMpTreg9rEW4Dp8mFlmdoFYci7NISFaoloaJ1dlvwxHJoZ3Lk+/Qey46fuTSGweaMGoByNH9tPH2FECVVoFPDE1+oaGN5IW6UEDgUEKhO7sdRacrCvCErfvptcUrmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10 2026 at 21:45, Baolu Lu wrote:
> On 4/10/2026 8:19 PM, Thomas Gleixner wrote:
>> Calculating the timeout from get_cycles() is a historical leftover without
>> any functional requirement.
>> 
>> Use ktime_get() instead.
>
> The subject line says "Use sched_clock() ...", but the implementation
> actually uses ktime_get(). Is it a typo or anything I misunderstood?

Indeed. Leftover from an earlier version.

Thanks,

        tglx

