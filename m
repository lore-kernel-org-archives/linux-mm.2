Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A60EF46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BA66B0092; Mon, 23 Mar 2026 10:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753096B0093; Mon, 23 Mar 2026 10:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690576B0095; Mon, 23 Mar 2026 10:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 593276B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:03:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10FC6160C0F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:03:16 +0000 (UTC)
X-FDA: 84577494792.30.FFC44C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5AA4C1C0007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:03:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta6xGW8e;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9odyPj4HNDYHKXouWYUz4BLC1KpWt/jFtV/ueWdJS0=;
	b=2xL2QmpqcibLcB8rA+ObrhvaU2/ts5kytRb8dBcEq3oF5bxEHT72tkufWYKMbkkdv8ul8q
	+jaRiCVIEP9T0kWgUW1ET81B5F9j2LT5/cNF63m+KAVJXudKnhbnRIvXtwGPgCwUVmuNsl
	2DnYuaacc/IYF1ixmEINeYQlYexxLhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274594; a=rsa-sha256;
	cv=none;
	b=owMXl9A5rQ81+/5PE6vlCDbF0PKNQ/3fR/xFHiimSiuD1Uj2x1aQxawuouA42VnirVLTo3
	xU0XeoqUPdsECbTnE7TZGyeGyMvvbwoFnJs2QjzblrQ3tRMN8ZnhvvSltVMCbtrpgIRrvB
	4m+28GpByynxf72AaU0ak5iArkHoZ+Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta6xGW8e;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD34960103;
	Mon, 23 Mar 2026 14:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635E7C2BCB1;
	Mon, 23 Mar 2026 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274593;
	bh=VicXl/5ReiXQvUG1Yw25HF2u6ax5qMc6rQTZEFWevww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta6xGW8ei6a8ZWcXE1QDlA7tnZ+WR4SyBBXbJwCt1nlOr0T7AZ630GzhgfEKKuVyH
	 r5Akukrlq6qXekEeFkiNEFb/iV03ukK/PH78T9jFpBswnnEyTMhHONtimKTmNpBU2S
	 Iacii8WxXRbVmPPyyEPuRRH6uB7kZqhAgQ5w/fRH4l8iPtPXmUlNh3mUUZObWg1fRG
	 0v2KpyIOwTdOzYpm5RYDEV5NP3OEteiToOXff+S+nmhZP9x6VZlV/iFX1kjSRohlBU
	 qN09KysnsWfIZrx8UJnQEClSVwPO5ZOTWDtREAXR8Yy9TUSAt/9xfJ2ugDvoV1NhjI
	 YNaNIJkIGoyXg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon/core: Performance optimizations for the kdamond hot path
Date: Mon, 23 Mar 2026 07:03:05 -0700
Message-ID: <20260323140306.79853-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322213631.259212-1-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AA4C1C0007
X-Stat-Signature: ajqj95f5u1c5tkximgmoyn7nksgr3wx4
X-HE-Tag: 1774274594-343457
X-HE-Meta: U2FsdGVkX19fD0mehhCW5cmlNAVd1WGcNvUZKn33l5K7PkJRKB4LUGXp477dHW9UZzbHTcWJJN4r6CvOdDqa8k3judp3bMyXuprHq61WnnuGF3z/qFxWL1a64QCYm5+S50XFvhywJjcw49rZcucv0BOQqJSw+KDS7svnHlVFtSkUHZAM0kIRLDyApXGMUgWIuoc/lEtgyHDFn6Oieefl7IRu6tRmMQoLm70ogJqFEkllORosarFO11A4wn/tuX6d+1kcd8GI4ik88S1rYjsHSX5RkGPyQ3pwDCOF3p1zuncMaASWQZZ5lwLq11ZuJN3+X6ZN7V00C+q+3hIZo8wQRA8d1h3sdhOW4nfsT+5IQRvvPTdctXetSHmyw37D/qcshrngEteQVsIkTz8Tsl4pLSdKPoWb5CDNzuiR2xqJRoP/JyTaO772DHd3TsyQifV6JeBVqE3S2Ixj4LHciv3o4Blwz/nW5YUqwC/68ixqzn3IPvVR51y1+g9xRjdgrtdIkSe8NqONn71zWLbU4DFwmM+/kFbZH1FTLbrABNqV0ZeA3tqyBL/4/rQoey9DxFQ+Lex/TqWzf3tnqmNZfRWd33hQoiTZE0Zx4qylHoE/6RmnlLiwQr0kBN1ZQkF5knvJca1dTALahwl4roGhQSk/JUE2NqiXnT4WWsDEKhPyCa69azqOZbkarbmAx5nE2NyA4mqp7auMxtTaUnz7+yZHFvhRjwTw0eXmh1capOItJtgAmPwGzQaR6SEEjFwKcclv1iMG1B8d/CfgLf1WbFyTvQANSm0o7cTKcdagwzo4QVBV74lthDWxfyNQ5skziAzwwQFqgzFRQhgXOB+lry+qqVLYhHDp9OhhdiCbKN27dZAWx83QZB7sz1Cbqe4s+CylCjiVSnOkTIxVhVpjDzmPo9TN3rvoxejXXhmh9LZZV8BJuIkQaJnrlCFDjn7kyVfnmMgcxVi5DW47GPul1OV
 6YhuyDwN
 Cb5uDosuM71A3Xm555TLxAY2fWDdwls+jPPhmyjkvXjSchAc0sHlMVNu/rBO+FBSHGI5NXEjkyJUqPrlmyjtxio7t1G+s5qHfmL69seIvyraHP7mpTV0hmNRHNRIejalkoOWcBXaodAWyhFKzip1qwhSgKj+uDMppCCrl8A+K3g2GG7hbUaHcj2/jpwE1Dtpd6Y9hnW+m1Qz6qByJzpqyxgkkd1ImhbJwPoaaNz7662IR8fO3n64SBI/ZpCXZRo0xAYncm/bUVPX0kdqUs0s+TJb7ypbqSeyf08MHBCs2dA+d9AwnFHAcArYhyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I show you already posted v3 [1] of this series.  So I'm skipping this version.

[1] https://lore.kernel.org/20260322214325.260007-1-objecting@objecting.org


Thanks,
SJ

On Sun, 22 Mar 2026 21:36:29 +0000 Josh Law <objecting@objecting.org> wrote:

> Hello,
> 
> This patch series provides two performance optimizations for the DAMON
> core, specifically targeting the hot paths in kdamond.
> 
> The first patch optimizes kdamond_apply_schemes() by inverting the loop
> order. By iterating over schemes first and regions second, we can
> evaluate scheme-level invariants (like activation status and quotas)
> once per scheme rather than for every single region. This significantly
> reduces CPU overhead when multiple schemes are present or when quotas
> are reached.
> 
> The second patch eliminates a hardware integer division in
> damon_max_nr_accesses() by using the pre-cached aggr_samples value.
> Since this function is called once per region per sampling interval,
> removing the division provides a measurable reduction in CPU cycles
> spent in the access rate update path.
> 
> Changes from v1:
> - Use min_t(unsigned long, ...) in damon_max_nr_accesses() to satisfy
>   checkpatch warnings and improve readability.
> 
> Josh Law (2):
>   mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme
>     and region loops
>   mm/damon/core: eliminate hot-path integer division in
>     damon_max_nr_accesses()
> 
>  include/linux/damon.h |  3 +-
>  mm/damon/core.c       | 68 ++++++++++++++++++-------------------------
>  2 files changed, 29 insertions(+), 42 deletions(-)
> 
> -- 
> 2.43.0

Sent using hkml (https://github.com/sjp38/hackermail)

