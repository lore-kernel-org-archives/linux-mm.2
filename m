Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C9EAF46C76
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EA06B0005; Mon,  6 Apr 2026 15:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F7B6B0088; Mon,  6 Apr 2026 15:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E5B6B0089; Mon,  6 Apr 2026 15:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70A8F6B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:32:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DD7E140596
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:32:25 +0000 (UTC)
X-FDA: 84629127450.12.F0DA90C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63054180004
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:32:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TZgXA6u/";
	spf=pass (imf06.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775503943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1lxqA5xtdggPK71cUpidpioON5ZmOnGn1W4+sdll+fA=;
	b=jCnM3w1gkxRwiG94kMO3hPInJ7pXAzMd/VqqPf+ri2TkzfE/D3JY3HvXww6Bu0/Whvx5DZ
	4aJ3MdORlOkEqEwMNTdQkvQ58XlKJZUZSFNNgKHQZ6khEftjru7h1Q4/GVc/j7UpEb43QY
	Aa8BpQDnJq1N+xWHsyoX7/mF3FaKAQE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TZgXA6u/";
	spf=pass (imf06.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775503943; a=rsa-sha256;
	cv=none;
	b=hFK+zrmPQ4ZUkjEYm71GhLUHN0ptVetg/mfb6AA3Gs9tzzp+v98aB+PkCZxIVBLw36fnTn
	hNCsHHwGeJ/Gk55DKpHMVAR/NLccQa87cpij58OvyioLXhZU3VtVJ9ERDhoEH2fA6W1K4D
	4J3RsPSJ/tAWGKY/HfuQ/pBVsfixPMc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AAC04049F;
	Mon,  6 Apr 2026 19:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE19C4CEF7;
	Mon,  6 Apr 2026 19:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775503942;
	bh=S1NtRgmwq+0XbhEiNinw7Ck9uZDk1ciSXDTvz8fK038=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TZgXA6u/Rbx6lf/95MWpUXpuI2+lS6JsMpaLTOjqAAppxZXy9cxUfM3m4nZHoXgci
	 MmRiIXUjP3/joOORsIt3iCmgJpoeOScCPNDPpXaaHRg/YA8YY5T/ZNDKPqY/mniQ9Y
	 rJ3xnZ+Xwa45BAPEaZopp8jUaKPZLi30umCLkATvD3qs4G6rp1axN2uhx12d0TamBP
	 7nLo0JLUYntAcFMSktSd9rhbyaJY1a18urvKHjqMJWPAqIr2fupe5TyEZDk3xovGul
	 LKv3HhIajyijJO90T3efA6twfKyV0Si/65B5nkygmZsoVbdECwN5g5e+mmLQ4Lubiw
	 5vdyu0tuILU0g==
Date: Mon, 6 Apr 2026 12:32:16 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Li Wang <liwang@redhat.com>
Cc: nsc@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: clean up build output and verbosity
Message-ID: <20260406193216.GA1319599@ax162>
References: <20260331094402.144131-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331094402.144131-1-liwang@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 63054180004
X-Stat-Signature: 3f8gwuf41nkom3ifwr3mb1yi7fyncruh
X-Rspamd-Server: rspam06
X-HE-Tag: 1775503943-921375
X-HE-Meta: U2FsdGVkX1/fjffTLasKzMtL6/D3MzymZeiIRi5UsbwNw6rp4jctUg5ikvARoLBPwz+MFi8uU33LpCFjKRFLUqTgIDKqgsWHd8Zd6xwq+rxNZL059lHNEVw5GLkTZfFC2AwhkhPjar3ry/fcf1PLrlP9eVnOvED2jzut8HhJyyhQ5JFkp9gCbGsSU9y2cctoNM5oyCasAO9JUM9d17CLDbR95qH1UkV1B/ETV1TItoDwv+lryo0DkI1ACZVYqMUgoss8iY0o1iZkAPaDi0eLfDgH8wEsmclia2zAJMQbC3kD2LUzbHCUlr4hw6/o6GHLz41ysCMq6BctifQ8cVMNq8zir7x0w+dGxVYTzfCslXzfNJ06q+VMfIH8CR703hk82eGiUQqg42NS/bv2tz3igCOfLmFx3cICHp3thf0sAjxkFMduVrAQ4EQO8iNpWKTeQi1MN76Q745P2APDbLVP3LpH/8K1sgLr7x85nEuKCLYN6YwgVLtRLBcVFC6/cddJPBrR/HTANkUIN2d7pBrE9eXUYhiAbrZPcf+kxUm5KduWbwy3JDkq+CsJ0zDuj+jCLBztinDsdvdQE+MPubebnUl4VCkxGuBuhxDbNVRlQS1FX9j1jANbR86RlIttPxLJCNdFOZwPtltuPGgrc/EmulLvAsv8LFD7XS7KiPph/MI+3or4rS3trHY2okalgMP5ePk2KTLNwyQqZ52bBWDWILNmX+HvFJgp+RT1iFpYc/epztdWJzzDHODrcDkFDSPVddd6BYAgMtwnuBYaG9GoItDLE781P8zriCUVjG3NxPzerXelfZL5xsWbZQ24KMfxa7IUkiC8vMsxFo1mdX/QUGgrQI0eRGrJrgRr/clotqJoPokRChOQvDaBuQEnd+BPmNHoJEWF04mk5WiYWxPwU3/LRRNpn0N/9pdJbBTf7LYlAxhz86oDJeE1GR3GNCP30ifhaJkhS9xWpwc7HT8
 Pm5GeWnl
 9i0NYJHZM8nDJc/eoXXBC1g8bAOZsdeLfFurDxtXQgWrm07n87/UOfuanGDjOyfVroan1DU4Geq5omcpSIbqQ3PGTsuQcIfXanqO+5G0TTjV6DamF9aJFj0Lz3KP0q6R++CroNOtXan4+5gtTZ3I+WKz287lx4x5niZUo22tHNkqZYv5OW4DM5f7QQYhuFRWm1C2a18XYR2/8kv+9F6vB3V+1JEsTAB55zF8pVHNe0b3MgODksOk2njVs1LI7o68g507MT+Gq15cTB8/vwT51XRU2Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:44:00PM +0800, Li Wang wrote:
> Currently, the mm selftests build process can be quite noisy.
> 
> First, it leaks raw compiler errors during the liburing feature probe if
> the headers are missing, which is confusing since the build system already
> handles this gracefully with a clear warning.
> 
> Second, the specific 32-bit and 64-bit compilation targets ignore the
> standard kbuild verbosity settings, always printing their full compiler
> commands even during a default quiet build.
> 
> Notes:
>   Andrew mentioned he hopes this patch merge into kbuild tree, so I resend
>   to linux-kbuild@vger.kernel.org.

Kbuild does not maintain anything in tools/, so this should go through
either the mm tree or the kselftests tree.

> V2:
> 
>  - Drop 2/4, 3/4 from v1 to v2, since Andrew wasn't able to confirm the
>    patch works for the rarely happening issue now, so I decided to just
>    hand on the process of the parallel issue.
> 
>  - Refine the 4/4 patch only to hide compiler errors when missing liburing.
> 
> Li Wang (2):
>   selftests/mm: respect build verbosity settings for 32/64-bit targets
>   selftests/mm: suppress compiler error in liburing check
> 
>  tools/testing/selftests/mm/Makefile        | 9 ++++++---
>  tools/testing/selftests/mm/check_config.sh | 2 +-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> -- 
> 2.53.0
> 

