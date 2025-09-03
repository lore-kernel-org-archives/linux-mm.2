Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42CE2CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B738E0007; Wed,  3 Sep 2025 14:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C538E0001; Wed,  3 Sep 2025 14:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641DF8E0007; Wed,  3 Sep 2025 14:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5048E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:48:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6CCA13BA01
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:48:38 +0000 (UTC)
X-FDA: 83848825116.30.ECAC7EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2185C80003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:48:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqCnwi7N;
	spf=pass (imf30.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w13NCpoyIz+MVs9GCJONudVeBM2fy+jIQB2hgsksJYY=;
	b=QSAQMdcw9ynVuS5xtNxMk6YGXQVpDwShzJdVkTNMYBxxAe5tCDYm85SFPAsKuU1R2R8z9r
	UjIh6d6ENxjIwif4k4o5BN1iOYOe2KHCVRhbjO7E0EcvWgRO7D9WngOCW/wZuXiH4Ut8l6
	SrU/UIQYUvPCn+Fbi+vkz1nJ1mUBMlo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lqCnwi7N;
	spf=pass (imf30.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925317; a=rsa-sha256;
	cv=none;
	b=4s5fxiGysXGCcepYZUrsvzaGyMFMGDKbXLrN+6IFCBxeDPC0rfFew2hDAtDQoTKaraP25s
	VlEpQ4fXX3WovcP8OIPXNxBTWppCusoTygCt0gS9+JZcuU9Sz4LG81d9O8fpGlMOIuBcAA
	w96AJ9wCUBab2JRqZLr8C+frPaWud9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE05D43962;
	Wed,  3 Sep 2025 18:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118F6C4CEE7;
	Wed,  3 Sep 2025 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756925315;
	bh=w13NCpoyIz+MVs9GCJONudVeBM2fy+jIQB2hgsksJYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lqCnwi7NIvfcmC2zVu1A2TIXpIBlJ8B6qVPzD1+fLnRI1XnvcHoBnMnhtrS9nUnnm
	 s8ZjGQX1kgjzh96HEwvBirTrnY4jeFenYLOlUW9DXVMoCs6X12BNZY1ajQZ+T2CmJd
	 wwvvSfDHUuO7nvvCVgl6/2ZGEdEa3NzFh23qd2a3qXGAZCKAwh/M7HH//277MVFxM+
	 TDXQ1It6h35413b4i/qUw4ZpI7ueYCN2HM56Qykx6h53GqJKsHEs9Mhq362tvDBR/s
	 t5iomFhAZA4TTbHqtIR4wfHcCCL39QkMXXmAcEbc0QjQM5v78Ki9ELP03VmgrSwK/u
	 W7OdW+U1LGBdA==
Date: Wed, 3 Sep 2025 11:48:31 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: clang-22 -Walloc-size in mm/kfence/kfence_test.c in 6.6 and 6.1
Message-ID: <20250903184831.GA3004824@ax162>
References: <20250903000752.GA2403288@ax162>
 <CANpmjNNV=ZmjcGWvPwHz+To6qVE4s=SY0CrcXFbizMeBrBaX4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNV=ZmjcGWvPwHz+To6qVE4s=SY0CrcXFbizMeBrBaX4g@mail.gmail.com>
X-Rspamd-Queue-Id: 2185C80003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: w4csh6ew8d637ddb6kin3c7dd3g9rs69
X-HE-Tag: 1756925316-186628
X-HE-Meta: U2FsdGVkX1/aQx0pfahTKYop6j4cIf34tqMWUhYACti60WsTvga4Y05d+akNxSd9zhSH6gW2htQDMSuz7CSrVycG/5QmyqlKs1A3ont1SqdvIx+Vn8d3FyZU2VZHZgfpxsZ4fOD5dlyPClai9+ojyszmbM6uI6y/saSd3vuAeP6RocnsxGr2J6YZtKH7M2u4uROB+nDcF6gDBVs/IX9/MDSKYgbOLiwJLIR09kr/XMygdE5uHK7jYjdXfuPfmYSByrvEEC79ECk5ViqMemSDA9ALs74gxuURcCbLgrWEVvFdCcMTfVA2WpBiE/OdBlNiT7eDHConOZECLDhXBuvJZomuDFMpP0xm7WaC0oeHuatdabEfNUeUVgtMmpDrOWmiEcHQv0RBgTF4J9qlT8Huoou3PVEQ7fbcl65kNcFR6Lp42TZZG5D/GRS8m3kKA2wKrqtaiXKpaqttrLsgQcqNgAVA6+BozMcs2tocfszdAm0XgR5Gd6MuvEe3vR6Inpv6BnriP04osKpctLVooJiL+lFkChamSCkEkkO4vRAQZ8PPluUzljKmbpaRqJjce1jDGMd5JByDvDyir3Oa3HpyNoo/FlK1n0cgj0i/TWtNy2IIwb5ChHJzZQn86tW9Hf9O76gd3SYJFuiyuJTtcjQ9yTCiUGv3a7xSjN1GafsZy58m30SHMxPBjJ2qH1I4k+G8563j3hpmPUvxRvn0MT3fOmM5yDfdw7QaPdf5Qdru79lCuiH1tXZ9O6JoOlvHDLj2AZ/qqj0Ybw1qy7klDT5SreyQ6tv1VxH2UzCquCLLQfbkQO9AJ00mAfF8FSG4GsOAX+Gq1EgrXc01F+NTjmfVyrRWv6aiE9QWK22z1BJmotfrOMM2sI+YK/Hfiaf/ffSAgxYlxyJnQEJR4pwY95ew7E7ICU7sa3mas+XdvcaQKRW/nUTRvXX+tXEdD1OidMBeIVmAV0++L4MoBzaYy2L
 598v8ibS
 VSgAsHrdLWvMK0LwzLETTbV3X9meJlYwNnYReiCdEaF1EH9fnLYji/6IY0kL5vdARoP/XV10deITxVrMM0tzdBtKA69YwbAFsTKJqyv/sxKgyLIyFwsA9OT5uHKHg7winYLOlySRCBDR29KKnHP/ORx2FnGdLDVG0j3dzgCWA3f/KBM7q31pfWKFMb2hkOo1xRSaUpDmXYWV8vpS2BplsHztvBtJpJoDOfPIthvVerqNKcbdbG2+2KO1SaF4e+fXy/1wUZfhfCJ47st5zRDwM8f7qtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 08:00:00AM +0200, Marco Elver wrote:
> It should be silenced. I'm surprised that they'd e.g. warn about
> malloc(0), which is well defined, and in the kernel, we also have
> 0-sized kmalloc (incl krealloc) allocations being well-defined. As
> long as the returned pointer isn't used, there's no UB. I guess doing
> an explicit 0-sized alloc is not something anyone should do normally I
> guess, so the warning ought to prevent that, but in the test case we
> explicitly want that.

Heh, just as I was looking at silencing this, I noticed a change to the
warning yesterday that explicitly silences it for 0-sized allocations
based on other feedback from the original thread, which I should have
noticed.

https://github.com/llvm/llvm-project/commit/5f38548c86c3e7bbfce3a739245d8f999e9946b5

So there is nothing to do here now, thanks for the input regardless!

Cheers,
Nathan

