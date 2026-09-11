Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DF0C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0086B00A2; Fri, 11 Sep 2026 11:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571836B00A3; Fri, 11 Sep 2026 11:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487B66B00A4; Fri, 11 Sep 2026 11:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25D266B00A2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:05:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2A5FC0292
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:05:05 +0000 (UTC)
X-FDA: 85201804170.13.1590E7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id AF9E4160012
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:05:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HW3tYq8t;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789139103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kxl1OEb1nifXofMFDFqUafcDOTr3tEpBTdUf0C42Lnk=;
	b=DfbT1FzaclJMTywyXrOSGigDL9ItoohmTC1t15CP9o7EGv7sR04bFQ95RdMcHZYg85B5AF
	y9iYjSreHRe3ioKmBwQZSqv12zqgIR8CRCQta45MH7IdkZ4euv6Y4dDrqP/bTBjSnfY2yy
	TBdzyFgbJQAP0prF2E3SvatugITDa8Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HW3tYq8t;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789139103;
	b=I4pXP9Dw0AiRMq4WXWhOAPF3GNfCClNY7ZtJuYkxYGgFuiVkdFlEkHL+evjBkbOZ8fCubs
	1sGglVl2Rfg93Z6CLHr+dwbY7U9sL6V97VHfBECsNrhRq2tjjLghSGf6Xx3ytoOvtP7BYc
	LOvi1ZeoWRx9pVRpnHfLex7R3HZ9Kak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 419206020C;
	Fri, 11 Sep 2026 15:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187921F000FF;
	Fri, 11 Sep 2026 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789139103;
	bh=Kxl1OEb1nifXofMFDFqUafcDOTr3tEpBTdUf0C42Lnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HW3tYq8t/BTil2TOS4otxSG0Nd2i2Fd6q3xh4dyxQp8vF8J7eUWgVnBg7yKk8wcsE
	 rWrWFQpBDGqrVdCthv1otmBWSD4a7zWV5XTVyqSAynwCduL2VZM7dTCqdPIgKmFUx3
	 D5jTYwRkXvZTDuEI+gsErZksmgEy+BYjhJ+4Z6z0K1JKK0oJ8MKROAkJMS/WNBhRkL
	 lN3FgyCObYhhG6cXKAmHLUpiRONWfPGUa33j34cT97d1HiltQnaiFEv2LiExjAeW/J
	 DolK4WBGHaYkZnX27lgrlty5O76xVqov+Jb1bIsPQv2Rz4CqKcNEdk9H+vVl4xrn+v
	 3GP1Y2cM8ANiA==
Date: Fri, 11 Sep 2026 16:04:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove exclusion of building soft-dirty
 test in arm64
Message-ID: <aqQYjtKt4z0QFh2d@gremlin>
References: <20260911125028.1268274-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260911125028.1268274-1-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF9E4160012
X-Stat-Signature: gqo9wiyxp6f9nf5p3y5o3bkj7os9cxhr
X-Rspam-User: 
X-HE-Tag: 1789139103-685185
X-HE-Meta: U2FsdGVkX1980c7oMe5Rn7lu8BqI2qY03GO5eMTufAGIgRh3yafQ/V/RgHi43x7tYXPj7hDNGiOrb/bbHI3+YW6BUISEcnr8n0du2hq/JGImZ44/6kLXdwb05YXajNEexGcIw6JTiY1bRMo6Jrgw/vyikYsf2h8jS3g43iNZK4eyxtnr/P3B2xntWW8lxvja5KrEhXXTdoEtfaDzgguZ+cZNQ1Chc6/yTMepS+tmladc/m9pMsH96BqjPmvlLgv9w81atFaYJxLPyJneoll+cPomtVxuNQVeyet5OpszT4xnsln4EabALOgOQlKCFwmO0U0z4G9FCxniWe1VmmP7kyYlL3vzm7ToTdBukTTREpIySk3tECxBBscq4Le7EKdGv/kkC0xdX9Sg0NTkFJn7fAsbFtsVTUit/RWfhvg+oH85MEQ9LqAXpv27DHJkH087xjt4uJzp0ZJuvWTjLlZsNHCIMaz9HXU1AQKbKZ528LFETCv9qsU9eVkIj+QV/NptAetMfLpvW+g+CdrTIsNMcXH0Xqqr0kwpA/oswwFO/lT/eDp3Q4xuTyGwZzkK7xDOmxl9M2X43BeprCijjzG0NEBA4LdPU8Dh+YY2zZnhoLlq3kBNYtlSxVGbOY258EPKTpQbmoPjv/cvghn4fPAHHArfGz6AI/5mZSV4Co1K/hDbaDjlYISO/IbEE345x/gkgSYeAonjECl4HY9kVAZLYiOHU3w9/65G9pH4DWmBXDuy2RbeD4v20kE6CDHODvSIIPX0xgN9/gZKlwITOnuSZSmVAEIAiSxwqZMp0SJElB0dum8ISORt76vOdcwGr8BZ8VFTd3eoO0W4qhwFJdFaa0IXL5FGGzlI5p5GpjPKBQGwiwVV0eoJydnVXhTHlKrUeeKuu6gz4a8hdl3jh0rXIqVOwhi74dgL4iH3auN+5+N2A/jyjo2/yFclXgvUedDsVlAv06LYUBKWV2BJSS3
 QqTNvssO
 KTxIbjmp4lmuQaK7JEhtAvVBWwy+Kg7OYF/vOkXO7R4FVO4iQ2cJsybeGPb8SvXI7ecOi3nEPtH5S7/q2y4DJpsJ5ESgbseVKZxmvtvKTDjhzUMxYN9mPXnNkodfRegfIMCmzCRWZEhY41wL/DxUiz6WIsMg6csPo5cQ8cbvHTFgQOa4MmgbMwJSX4yTwGs3YmKklsJPCiO9I+W42uR2w3VqPxBp5ru8YNSDxDgvtpnnJwlTVEiVYT/48oupal3a9ai5tnxM5pFfKrATHpEwtb4umzq3zkKtKsEdjSmmVgR7HNmAbc5pCmaMAnZv+ddjRcyEJ4LWyBPr208NwU2btstQRRTymVV2x9fbXME+QkvceDjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 01:50:28PM +0100, Yeoreum Yun wrote:
> Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled”),
> the soft-dirty test is skipped when soft-dirty is not supported.
>
> There is therefore no reason to exclude the test from being built on
> arm64. Remove the arm64-specific exclusion.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Seems reasonable with David's suggested change applied.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/Makefile | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 2d5366196e30..d3e9bd67904a 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -104,10 +104,7 @@ TEST_GEN_FILES += guard-regions
>  TEST_GEN_FILES += merge
>  TEST_GEN_FILES += rmap
>  TEST_GEN_FILES += folio_split_race_test
> -
> -ifneq ($(ARCH),arm64)
>  TEST_GEN_FILES += soft-dirty
> -endif
>
>  ifeq ($(ARCH),x86_64)
>  CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Cheers, Lorenzo

