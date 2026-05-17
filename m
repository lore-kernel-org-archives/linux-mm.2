Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FD0CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E096B0095; Sun, 17 May 2026 14:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E776B0096; Sun, 17 May 2026 14:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124196B0098; Sun, 17 May 2026 14:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0093D6B0095
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:55:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D6F3160E50
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:55:43 +0000 (UTC)
X-FDA: 84777815766.21.FAE681B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DCF38160009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:55:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TCNPpBuy;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779044142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sszIVsiMv4FqxFPoz8h/L9SMJ44IPOTtnTlnW5Rptk=;
	b=Aqa21GispiP2l7hdBl+v+9H8KDca5rav9G1HH+F8h8x3AnugOtdpgfuqMtRwQxlX4zlG0r
	gjDfG8zjP32k1VYFlaHvs4F8GTeN7txJ/eYDX+vBxjJGHfMg8wzY+bDHf6/5TnwWhF6FT5
	wo34J/M8gA4NukIzlAQNdg76vqxWNJM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TCNPpBuy;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779044142; a=rsa-sha256;
	cv=none;
	b=2D/Q5sCeRsXwUFIcYFkPbWdkZuOfrrBac166tdu2g8kZG1RCDFEpm+5/NyzRybpA8BxaFn
	PmLClQ3khFgZEgw8Cbw0irXA/lUx50kwwWWSaGba54JZlohjr1xtQSy+uGDl8cvwFfjNEA
	M/E4A9pyDEXdFqC9nYha/r1QW1ditn0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A10E405A0;
	Sun, 17 May 2026 18:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777E3C2BCB0;
	Sun, 17 May 2026 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779044140;
	bh=G6OIO9cPM8SjJ4bxslpzxm5oo/ItIFewnJHdpEEGRZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TCNPpBuyYQXOa6M2oIyvIG/U+QiLuHhiAH7Y6ptzL/2QwJwzsRPCQlZVsKBKx85BY
	 K6ZVy8TsCZJQIjF6YNrIA1gQ+kXwiJF6RHVUac5M/8qFfXg3orMXo301RmzyX2aUTb
	 fKT5/XDX7ElN6QQ3bSjJ3q1U+WEDcHdHwaYZkHCYNqrz2n6KuT90to42M5R62rBzIb
	 CaN0gOLPVzFf7uulvnbyLZ8pYVTjVL2M5ov9UJn8F91uyMbnImaS9e+KNFAMcC28v/
	 CHlROTRXBfGsGCnRDy4xDr1ZJgw5xItx5lz1TPoi/ttMJhOXlUKSMn7AxhayIJtuvM
	 t9MfSJfnhWsLw==
Date: Sun, 17 May 2026 21:55:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add pkey_sighandler_tests to .gitignore
Message-ID: <agoPJHwC_3PnH1BQ@kernel.org>
References: <20260515125949.315964-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515125949.315964-1-sarthak.sharma@arm.com>
X-Stat-Signature: yj3xgj9u1t6gm381nj4f5by1g8ieupdx
X-Rspamd-Queue-Id: DCF38160009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779044141-751461
X-HE-Meta: U2FsdGVkX1/V7gePUYG82/unCpKlf279PFagRPLrl2AhlqSHuVWjBoGmlQAmfKMJaLxVHlPHtIc8ZkfB+HwXpq2C8/pGJnGwNFQxa29q07p6psIhRoabi+CkRafnK0Hd5BROgvKk49gohizB+XHMGvZy7UG/saDFs23XV21FKok4Ao6rG479EMTDhm6MiAG+wKnpbjVcaF/HjZ6BkykPDJQbKV9wMnQTm4zrl/RiFgpMo3GsDRR4ngmD2GbXE1dVP9+NLsOwS98LJ0wEIWjIKAcmNl23e4na+AI/aSDGAcjSsCThJ3Wre9MNN1xKZNdfSu+Fn+z+IDL/eTie/WoWSNNLX7RFdwRCdSJd4kPZk+bYpJq2sk8F65MmerxOFU2TKsaGOABkRUSLJlX21hU9Z+4VLI0u11HpRgZtSv6IAerSxNvw9npiMxQv2eqdd6pYPlTiuw2ck8a8BVVIu1KxgnoTSWZJ1AvifeuH5APnsY/z09qhSTP5d73I+M9v8H/DMkq9notx3HCReKk4LMFJSr2Ba9W5Ng5xW9L6zDPgnrjy1GMGb+ouIzj7xZ8rdw9gfNeEvzesiYRgwsk/dy9B7kjBK/Oqz8Ycn4ByIdGc2x+jPoIkCrpsJqcfwj7LMZNoh5nq+f8z6OFKUfExo2p7iU2pTsnhatyOFStmUD9kHcK4QEKJ4yzNfTT6z4b+fYLBLeLVc9pW1bk8dU60hJxpRowL1rv8MeVUwVwSym2Ys2VVS/fcJvdBFY5IqYm3G0l+DV7bO6Or9IbdUv+NPKKz4kIWRjmzCnjKUGR7MuDFqqElsy+mf1ReoYz2wTf3Kfi5O8S1BPlFsxfF6bSzePKcoDOdniWrd2pwpLrXS7LBu+4EmokI9EWztVWszcrJrhllFoXtCsmZqyBfSSZ34I9Nssgk+IGieTVlmJ22SNrowuv5XoYRuV6PDpICpuc/m/MCW7wE/XNZf8g9xrxqZfQ
 P3tQxR41
 TO2S7CggVtvd7oAGq++XpuQOjc4zZ8dPh/Qm542j5/f5d+JZtb6MAKj+bXbiumXDmEvnJiN7Jekfdrkp7TPrXXFl0hOPzLWihR7aYvegy/1bseRHKi4BLSru3CgCdgR30fiRfLr0XwoiK4aRsp61XuV7DSK4DkT+Its+FeTLdgETdCYwCkTA0DtIJP5cId11jZyCWauDVf5KvTNGKX9IK7gEibv9A+BnCUHTKMODhLO/2sDENcaGXAgothQXEwccn6hJP3J2KbhFzDWTtI46+OeNpHuSfC3A9Q/uQAnyaNnhw6HTs+CMMS1HI/hZsS4du3e4g0U2tUDvmqoPg4H/V/liOtndyodWLqTD6F1yQttKc3g7/55H2j0A6QUSJ1MiF3nYvgEcH8rdRV3ILEOqUlVtWaQrFAyULvZ9p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

On Fri, May 15, 2026 at 06:29:49PM +0530, Sarthak Sharma wrote:
> .gitignore currently does not include the binary
> pkey_sighandler_tests. Add it to .gitignore.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  tools/testing/selftests/mm/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index b0c30c5ee9e3..1b1d9ed87039 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -62,3 +62,4 @@ merge
>  prctl_thp_disable
>  rmap
>  folio_split_race_test
> +pkey_sighandler_tests

There are patches that switch .gitignore to a pattern-matching approach:

https://lore.kernel.org/all/20260511173411.267628-1-pratmal@google.com/

With those there'd be no need to list every executable in .gitignore
explicitly.

> -- 
> 2.39.5
> 

-- 
Sincerely yours,
Mike.

