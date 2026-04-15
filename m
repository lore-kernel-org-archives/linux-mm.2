Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D786F43844
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A683A6B0092; Wed, 15 Apr 2026 11:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19776B0099; Wed, 15 Apr 2026 11:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956AD6B009B; Wed, 15 Apr 2026 11:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8278D6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:30:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21BBB1404E9
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:30:19 +0000 (UTC)
X-FDA: 84661176558.13.0AFEA77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6BEB0C0003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:30:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0DH5yRU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776267017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKZIlu+WNapM+0zWA0Ck2GzPwqC5DwYR6I8Mklg+slM=;
	b=yPxIUOI0uwk72TaUTemTDoqm/0MCuG97PvKOmtotKl/H6q0wlQauh57CkadlS0il9S1a96
	LjAiD1i28PlfUNQZrusbd4IBMBoTZPHJ1H9GWUzzsVf61yokJPSXlHLkeEiIDDpGretddp
	xZq6GJQAOwzIt6NfTUQvYD7zpRRovp4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0DH5yRU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776267017; a=rsa-sha256;
	cv=none;
	b=bGpAiQwKTBcp2WM+gYHkstBspzNVsSHq23CU80Oqg1esIzOCbteuXiCFozuCtPAT1UIMuU
	q4alpnBkL4WqpVJFSFuejIYODE9igSkhMIGAv8U3d5yG1DegxS8SlfPz9Z/XH059/FkHun
	I9cX2CZmi9m0DWIOmKZMv3C0yCOzA04=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A7964600AD;
	Wed, 15 Apr 2026 15:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89079C19424;
	Wed, 15 Apr 2026 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776267016;
	bh=61GJtuhGF2ApcQH3dcfOxAooOZkKNJHUOcToNmosODw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P0DH5yRUuzX0vMq1N8iGKcI2U1Wt5DWDYu5FsEFX9pAiPeN1dDJmvMrWtFYS0eXoo
	 snTFb/TMP0LOF0+1PgEPdRTHPpJ8OfbmiG8Uu908ZbDYh/qec414fLtD4ns8PxsCh4
	 SacNYWXWSnk8Vk+FLqw4lZ5tb6jNp4jtNfSRIUvvIkGD1Fg5ZgkRb5IATLRK2Kxje0
	 1bBXWQzoFzAAo4DriaCNVUtIuKQNuOUoo80+Uj9Omtsx+W44QujW/RGCP1WaQGayjS
	 Qmenj5ex7Vc/BH/GMvIHhHaTMf3CGI3PgJzLuZh5kC7e298RS6KTQShPoH2fLf6sgu
	 PL2MGqEq0It0w==
Date: Wed, 15 Apr 2026 18:30:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 06/11] liveupdate: Remove luo_session_quiesce()
Message-ID: <ad-vA46Mcn6Q2Awt@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-7-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-7-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6BEB0C0003
X-Stat-Signature: jbapza4zi9hnqdfa568ffsj86o4i3ykk
X-HE-Tag: 1776267017-385602
X-HE-Meta: U2FsdGVkX18slwpi4gvB9UH12xF7IVuBNTqU+KzREJPYqpNGFkSahEpIWTBiQBaTP9knXTXQqkds8RrcxLFxNBFEuD0BXUXOaUoQF5GGzLCCulcpj2oegYiuotrmmFIeLqqMpzSe7j/dj+9O/FYl8YARFedp2JhqYwTadeK/W9K7CwCVSX2q+hj0UHo6tN0+fUX0TIPvNfS8YLUvCOCbkEbFAV+6kwxVzQ8wzTU25oMfbBhVcNu7EcepM3lnsiHIvlhVBz/8eFSqvudfGFQZPxa0xhdBJ30l/rX9nbBvIKB4Jj8Sm+oBrqYFOnmlRc0E6oErSXjnv8nsGkS1+mRI6HidFpb6py9M4pQvbbve2s5wzPvGtw/2VwLaxkhqXU6HNuuRZJHWnf11KXwkDy34SsmvW0SWCWHTvjvMsXmXrSgHj/Y51VGrvsvIVYwSmCH2IVCt8oKRxkyhj0CborpFV8RNUxKVakrc/+aGy3bV7D8HtDrc3nUuXARFqubVaEqCQPSp8u/mMnR32VwdyLjpszPrgloUUm0ED1mRH8+gAruNaYZYO7P8VDmerskiR+vs57BVQwbO0HYIPvjAapSeZoq5r4DGd9hQ876DIPNAnLLK5IQWrWHaEAuWaAixdTjUrsSVMQ08GBQ5CT38kK7gyR5EVInBiCPjzma92a47mL7UR4EIZw4G77Cjmm9c/1U+iJxkIeaS47GztY1GjDLUnCj+pqO4JkLIHzMBlkiV949PhFotE4WunZ7Uge787EaYrJ7+6VRTrMchXTLfCTogA3FF3jIfO2aSOAsNt3fQVLYId/f4qw4h5fMDtHr9vy5q3W8+BtPvFohAaHtCwKx+ckemurY9X5xvi4KH6YUCt2+8NL9zkx91wiMM6YL5JR3CBMjNZB30zD1RV+ZQcHq7tCwBZD2pW7JDJX+U8CldxnZaa6bjmQwCEIEbLEJHy4n67bZyMbZouWUUGCLMztI
 WVHYM4b4
 JCczBNjmo6gGT1SQ9Mw0sZuysQNDaVCLeRhJkqGq80QdV9fftxlmQXWnNYqYuc4lYKE2KmzLfSJUgWfHiAm5HTt+JB4TiWJDn46jD4eLIdzhN5s6/6MojR/1YYp8gOgPL7ej7pwo9uNPAqnFucHJtoXDT0DMQBq15D6mRcJok6mD4I6usAPi/LjvHMfdv2oVmYirPZe+830+ndUYMlUxKpXJzRZuZ9baQknNISicy9hCDppb0uhXh5OD4zY/mdNys05UZYmhVswYaB2vAZWt7cdLwmPKw8yyWpyO7umhgw2I9MMZLPIQhNPzEfPqjSXpfKSjMJXpnizojXGc+dPlJWHXniMMeL8QBvQDPTy68ICsA8RvK11p0TMxdh7dJ/BziTqR7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:22PM +0000, Pasha Tatashin wrote:
> Now that FLB module references are handled dynamically during active
> sessions, we can safely remove the luo_session_quiesce() and
> luo_session_resume() mechanism.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/luo_file.c     | 21 +-----------
>  kernel/liveupdate/luo_flb.c      | 59 ++++++--------------------------
>  kernel/liveupdate/luo_internal.h |  2 --
>  kernel/liveupdate/luo_session.c  | 43 -----------------------
>  4 files changed, 11 insertions(+), 114 deletions(-)

I like it :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

