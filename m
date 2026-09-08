Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F617C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE816B0098; Tue,  8 Sep 2026 02:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F376B00B1; Tue,  8 Sep 2026 02:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6E96B00C0; Tue,  8 Sep 2026 02:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65A6C6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:52:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDDD81A03B4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:52:28 +0000 (UTC)
X-FDA: 85189676376.19.39B911B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E68E14000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:52:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MxGHPr/o";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788850347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQCExSqn1W0rL2KHHjcgog6hZgpy3PJqmFXUPMAfp8c=;
	b=4RjyKZ8hYLNKWRW/80f3sXBwil3mqVj//CKkjOARt1BbSKkN7MeygDMYB4mzkpUodbcesy
	XCzp40hTgVhX6/YCtGDJfZwqgPQB6hjipnm6blh2YiE+JOdAx8i7NEB1XjqeKSblKBjKKJ
	nStWEz1zSxecfvZWx15W4qqgmHdXpDI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788850347;
	b=aPeLd9sEdESRoKHkvEA3dqbzT9lKiokvdhPdIPbfS7bWzoTr8Qij1APR3SvgFDlNTzmUAJ
	0QiWXdvlpER/0y3muAQJRZck8MlJ81FU26Xte7ASxQghSuTbR2eSrZ/9bdVFVQQjxoi4F9
	J9QrtonxzI1thjx/YVsahPKwk7Ah4PU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MxGHPr/o";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FDA742EA1;
	Tue,  8 Sep 2026 06:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9921F00A3A;
	Tue,  8 Sep 2026 06:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788850346;
	bh=tQCExSqn1W0rL2KHHjcgog6hZgpy3PJqmFXUPMAfp8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MxGHPr/o7Egzf7/M8R8Ao6xgWW828L9KjV5g84sSn7wi9vQ7ZcW0u0yYAkaDvectd
	 mR4UMWwASyruj3B4tXUeARgiJB6uF8PJhd7Vk5pHsWytx6JL63jN1/RAI90iaZDj5v
	 BSMATV5Tjnay2NldoJaKCaxkJf+B14z9AyDmY+MVafeEWhRzFRldWfi0CqcNr52USK
	 953kOdfoLHavZRSp42M83cfpJ14CsK0C7vG3yQyKNcguUsP8lAJpH7cavlJCQtN9Gc
	 1lsmIJCiWgIzHl6QoyQVlGhaNA5yh2Rs7v8dUZbABjex8SUJroXjJK4pnfLnMSZmk4
	 hpWo7/SVN/Y7Q==
Date: Tue, 8 Sep 2026 09:52:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 01/25] mm: Introduce kpkeys
Message-ID: <ap-wnHAwfdX_b39o@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
 <178877845406.3691569.6930315020588094755.b4-review@b4>
 <3f6e7678-0784-4ac1-acb4-b128887803c5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f6e7678-0784-4ac1-acb4-b128887803c5@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E68E14000B
X-Stat-Signature: 8u9zkk1zsqz9img1w7f5m785iqkfoyxf
X-Rspam-User: 
X-HE-Tag: 1788850347-329627
X-HE-Meta: U2FsdGVkX188IZJTk35xLnrbX6jmi9zSyQ5Oa5N62VV8qUyUiPY+CQB/z2WI13xh1ZlRBLpb5J51swWDuiwYiSVm7yNcAyIAcBJr+YA7vaJMkFZWg1WT6jLLzDQG2XS+EK8cPSmkZL1luz40rHXn4tTmC4A+zd27qVDPUQuEchaZVGdYhdJU87KYPqgXnbdUasBbydzGrLlqVb8d4ZeusyWD+g8Zq2vpmaDodsPSlblrLr/gHvpeUDxWYtl1S1VTmVjspCpxSc4/KFeKLe8bdIRgDZHK8nullpBoBbJyjAkix2FN0P0WTH2VgPz6hy8TMTJ0gHlp2/4r7zZrguguJcDEqd6fUeSl1toMDDsxN/lp6JU7WznGPk9CvotX6pELjjH3wGEUxXwtoKZ7Gp9XlYOW+zRufKobwoIq5oUKFO5+uGy0vAuM/0380dcl2N3XekYmlVaG4byVW8Y1L+iKIon0WAKk04IMTyBlGQkhpJhWbqRVgFPTg6M45D2oPcSJjUqLgHxsVoxRTEqnR93SAEL/fbcy2YgbX6WUWizRpCAvOSZW1VGhzAn2d1udix9DWk7O+ywsmDJgWj+2wY9evbqdPelUtsoW/V1g6+1qiMh2td8Oaz9vLmvSe0ZUufAZay46kZsHLDMQ/paCiyA6h43TeGnnDuMpB5RT5OS17i2Xk/hhnOZZ2xPzb1disGd4RNMuoihwd6UU46n/aTAGKow7ykp09v/fNhrAzFifgG8ow6pRvY2cFN9SVTKNHJZA4TzTHTucpALY+kxD4ivBEakFBqDIDmQ/0DK5UI/GrXL+H36OBfpqsF4h+hloXO6ukigemGHanGNdVUKTjqcd1ghcqaBgYEIzcPhcZIvpDPFAzovbU9vvIksfYon+xU0xgzmuOFQiTtcpUwfPg76EF+kCF5tZ4sxVAVbbpCQ8arEtyhipurNjp19PAMhaf+WKEdHfgcEd4cMFS/ThjLB
 89g51Ab6
 HPhhXRCQwmzLBTq2vZ8wO/U8niav1VQLFIASaDDTlqthrDs8ScTAII7kGlH/loEJN4QyqiMJwRnJIa8bQw3Dpnl3axsyiX9xsTeseXL10guD9kIxawoYR65mzG7oIxkz0jhXJOKLa1/avzYYVoedgywRwc0z8zaqLzc7EF00oOn27DYTeu+iZgjj+/5Ebv4O04FdBB30/ROHfkbZVDufa3pAPOlrT8ulwCzdGCKmhl+errWxN9Z3cXVQRCrE2EYml7q5E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 05:49:42PM +0200, Kevin Brodsky wrote:
> On 07/09/2026 12:54, Mike Rapoport wrote:
> >> +
> >> +#include <linux/bug.h>
> >> +#include <linux/cleanup.h>
> >> +#include <linux/kpkeys_types.h>
> >> +
> >> +/**
> >> + * KPKEYS_GUARD_NOOP() - define a guard type that does nothing
> > Nit: I'd suggest to drop "define" from all the descriptions, they would
> > read better without it IMHO.
> 
> Fair enough, but if we say just "a guard type that does nothing" is it
> clear that this is a macro defining a type, and not a type itself?

Then maybe "helper to define", like cleanup.h does?
 
> - Kevin

-- 
Sincerely yours,
Mike.

