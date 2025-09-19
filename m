Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18ECDCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 18:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B798E0008; Fri, 19 Sep 2025 14:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773268E0001; Fri, 19 Sep 2025 14:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0808E0008; Fri, 19 Sep 2025 14:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A13E8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:44:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 070D7591EB
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:44:28 +0000 (UTC)
X-FDA: 83906875416.30.BE2883A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E24AC0004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:44:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3cUVJEJ;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758307466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxT6TPuVr6VNfT0qVSTFqMoTa3oTyrVPwrAlb7CQBJA=;
	b=d42ytvmCZIyOCan+cAhpkglMfdu3GQDQchPATWH0RmclgtcBHRkafCiujXCPmTtLQSyIAy
	iBRqEWBDZ506+XtA3fVuXjBbxwIlEJIuL6wse5lJ6QVeNGZfRmSF5V0wQxA9/IvOgzAqh9
	9n2Q5Bb4OxBG4D1rK/cf3cdH/eFiifE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P3cUVJEJ;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758307466; a=rsa-sha256;
	cv=none;
	b=e9VGWWDaaunhEKH3MajRRRtrnCci08cbWQEy/4A9EY8YAsY0B5CnlBvbS28c7wJkSqG76S
	cr0IGSraCOk4TeafnwS8z2VoTJiygdaJ3R0IjTEDsZiJTCUiQqFHwylSGQNdSkfzXwK6IC
	tMIrI2zJuTqKUR50bDc5Uhn6xBxtxX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0B3944175;
	Fri, 19 Sep 2025 18:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44870C4CEF9;
	Fri, 19 Sep 2025 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758307464;
	bh=TvNct0puZkUduc5sUbES816mFOXImptqyANagH2X/rg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P3cUVJEJqWFBU7ww0WmUJbD83nfjVDNdDRJtPJeu4fS51UMblHAO+y1IiOgLm2w/t
	 TUbpudm+KVhuUZBN44nNp+D8YU57QIok0SMUNjlWzyovX6d8n7Fv4r5utvbTcFzm80
	 wsREd6wbVor91Lf68a/PZROm7ttTQdnfeGEjXJ3POhix1+nAinVdjzdkxQC+oRli2s
	 VhBqmPEGC1qZJkDMLyBb2Z8h32wupJupI0gO+bMuua+R2hebikzvZwbHAWb/jmc24+
	 3yf3+/nPuXtNraKM+5mpi0YKhXJ3duaJ7nikdVjjcFh09+FOmsu5zGh8YRQrhL79kt
	 5Dw3rKMVLZaBA==
Date: Fri, 19 Sep 2025 19:44:19 +0100
From: Will Deacon <will@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
	scott@os.amperecomputing.com, cl@gentwo.org,
	Yang Shi <yang@os.amperecomputing.com>, kernel-team@android.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Message-ID: <aM2kg49jBia4VKYr@willie-the-truck>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
 <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
 <aM0-FQlepoxxGkRd@willie-the-truck>
 <ceaf604f-8ad7-4e19-812e-7eeace10d835@arm.com>
 <aM1E34lRjKg7nlRu@willie-the-truck>
 <38fa4717-9105-4bca-a2cd-914afc109570@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38fa4717-9105-4bca-a2cd-914afc109570@arm.com>
X-Rspamd-Queue-Id: 5E24AC0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dubhtyaj6xjjoca8nja56pokyxuh1knz
X-HE-Tag: 1758307466-281910
X-HE-Meta: U2FsdGVkX1+bTbUx02YeGf/SPxAB25ouq6Wec4SaM71szBCgehc8Vb/1IR/ok6vGbrJcrNz9YmI56xi2eUtKN9pBwEA5/u53e2Iw3CEOmyubhRnImN7ROjiIWeNsatfZfaHBJkPlNQ0Mh9VanhnZVkVthjJyjSwnF5S4c8uBqE2rvLZFYlCQzc0OuSZDgUjHxCWPmjH+1LYbXvCX95UGYVraJSOJdOju6UhNRr2p6UEtlUjBiwj3fEYtt0TIqkc1MgPQ8bwcybcNVX4SuVocWkmpO8tNdmPxfkEDNHIeASXtyUeGSyc1co/b0r+OJHw/O7C+YyxGMmjWW4oPsEdAAF+03O8t0oMULtqQ1fQDBFFkUJwTu8FTGkVc4sTfJ3W0UnYXw9RbSA1s8Nb/g0QIAHqn7Agoyc+IthZFADDI7Fag1+99xhOlytza999tjajlGN1ze9A0qtLfM48imLHPWffwc00DfzYBJVll9Cm0Z3nGt3paFeCArUMqwpsmT7PERzs429GNhHk0BiAY8sqceYBlEaY0Hn2FzZrAi5K14b+Nfu79Zje3ftrevMqcw/Ag/wnHdDWicTVO1ym8Ba52M7YK4hQfLnbbvHF7oBfYp+5zgwgZX/J+KGisPN6W9CvuG5uqVo4tI8cCNeZA6VGAOxlIB6pOnM+K2UrZILiwtqobbM52jo7pO6AXMZgtyAw8hIvu+zL5sSEMHvMtTVTqDuWNIoYTluZ0BrRxmd0SD/+KbMwG2XMIa2VNp04TDnNxWJEs0jcu2lW8x0CdDheYUdBX1S+drLTVWK9CF+g5nZQCFYm13J5PwTw3rNoDSr3cXBRNcblqXpcS4din0AqxAlMPjLWJcIhD21BZgqt6WQXvorFMV/lSoJyzvLUEEiNR0J12AJFgPyS0LZTO7IGBAH9NDQfFqTUKFpv7ygicm313/g0b+bMq+tG8c5fX3kERRkFd0wJI3fRKc3iJjp3
 UoXwgIIE
 juHpjrgqISDr7D+/+efDQj4uh48b/8+V5sQRGZFnhIsQEiZaRIvSNdfjx9bgjTnFMyEOPmmDy9UwpSCBbycFwCCsXwMnc2O9GM5DM7uY3pQmy6kpgi1gsfYdL0hvpSs1xMVBflz+ROkfheagzpe/zW4CsNMsXdwJ94YZSFyQa43wEm2jwQVl/zxMKP3d30+XvL7TXMICh2xBizwxiXzo9hCS0g+g32WKXX4N8p+gaCOG9lrFu0XbFI+F5LlYh5DNuDOcpA4EEzPhLsnelE2xJ+0/k7QxaW++b0xMhwULlOggvx08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:00:49PM +0100, Ryan Roberts wrote:
> On 19/09/2025 12:56, Will Deacon wrote:
> > So how about we:
> > 
> >   - Remove X4 from the list
> >   - I try harder to apply your patch for secondary CPUs...
> >   - ... if I fail, we can apply it next time around
> > 
> > Sound reasonable?
> 
> Yeah that works for me. Cheers!

So after all that, the conflict was straightforward once I sat down and
looked at it properly.

Please can you check for-next/core? I forcefully triggered the
repainting path in qemu and it booted without any problems.

Will

