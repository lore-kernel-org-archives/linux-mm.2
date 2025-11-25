Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E02CFD37E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C766D6B0005; Tue, 25 Nov 2025 05:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E7F6B0099; Tue, 25 Nov 2025 05:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8B5F6B009B; Tue, 25 Nov 2025 05:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6C936B0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:14:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DDDE1407D1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:14:41 +0000 (UTC)
X-FDA: 84148720362.22.E0211F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B86144000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:14:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JzEn4Pff;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764065679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ja5sDK0gvC2tEy61j2jG7J9Nt5wNjuAE9//sMJfYicI=;
	b=7xP/T+sROp1DrhPbr9jLBaKDuAjxEt1C/uia3BTdPwRPVU7eYB2QLPDlOEKi3rPnJfvDjh
	OAHdZ4+NI+UQ9/D8MjdgV3gRlZFljGrUoljTRYhjP32dTirFUVN5eM9ucG4bkpV2ALDE8S
	vdRA09l8cFgZg3QVy+5R6J1tZTP1GkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764065679; a=rsa-sha256;
	cv=none;
	b=TWgMZsCvxucluhkwTR8PGfT8QWy2xvvBWxyLcOFssxFuLqCf/Y7quBipP5gtiSTinP5J5v
	toZDSHEmCFVZBb4XMqmbzgiN2mYnLvopQvXvlzUiUiZyEekZTFyQmEGgLKBFJ8TA4mMpkF
	NeQzEsf6fGK9k8426R6ZasRxcgCCnoY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JzEn4Pff;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B96EC60007;
	Tue, 25 Nov 2025 10:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626E1C4CEF1;
	Tue, 25 Nov 2025 10:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764065678;
	bh=5QbE0oH8BLaan3LG4ZGNa9k8bzVZMm5H4MXL8QzMP0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JzEn4PffFEbnXhdUHKYjgWZYulXLFYqSP63GSerEvMb49yNeqqLq2P0abUp6VubzV
	 yHq7Y4Haa2xhvkYdep72Iml55Aqz6NNcGzmOSq3kVRdp3VT2/Z9+/XOGK4rxptjQeG
	 UrhXVs4Pusls3pPDJ/b4usp6DxPHyASdDPumbJ08Q7i6wzcuA5mYF7iIx3tEQPu91z
	 OO9OPA7/tBhFZQmm0t2lQgG94UK5aaQLD27uiykoF7Lhw/towHHkGh5QwRjajWqB3g
	 cLKTc7Cz2nWfGXhDmJcdlEXNNwQNivaI/8tor3eZ89YXPZCsKvKHUj1oCMT3hCOeYD
	 ai+7IHEIuswsg==
Date: Tue, 25 Nov 2025 12:14:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Jinbum Park <jinb.park7@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Fix DEBUG_RODATA_TEST indentation in Kconfig
Message-ID: <aSWBhstlhLCduDXc@kernel.org>
References: <74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B86144000D
X-Stat-Signature: t3r88zay4umwr5s9tzqhnmxditobqp4k
X-Rspam-User: 
X-HE-Tag: 1764065679-300951
X-HE-Meta: U2FsdGVkX1+3t0LOPkToI08sNnHEZMGM4Z8KZAuzrU2Oim8KTYf84GirrDw+JO5IcD4AfuuPtvTPh3t117LQRzQaC/fTtbRL0O9HoWZgGiwALhvhW8yXa960Hv3R/XZ0JgDv/jbe6TwfPMyhgcy4HC90+y5vbK8HQfHvgHkjCvYPTFPeoLdSF0cCcY2Ei8nPVWkn+6MwkVIDEFEBfnAF4ICva4FejuIHggBICY/qWbpE/cNbqcUIQ5JysOzNYGH9sPEgIso+wR4MPUnYIBdTojuHCPJmGUbw97ZyNWKMj1YTsZl9lTky4nPbAdRLG8cHTkwYsRQs0rSE4N/OwwMmM3CvfMN2uXLQ+jbd4Z5tgHvqCpr7mvQUxsCJUUzrxDb1lNKOy9yB1kQg5Q/62fUB6yTmesCtf2z0Mp1MwH25qqWW3uCWfvqKI0U9p6gdbHxYDeJpDSOUDU/YrUMCicJsP5IVWUynOqsXnznsne+HT9Otiql1ICx5fz+/Fjr3yqmy+aklf07+d0aOvx4UWwgt0DrXXMnr106qgWfNR2/u+pqmZuJ/uwMst9nqTbYy+uIZnh5MxIfzH87t0uqnutbv+JS6NE6+FOYcJwMs4IsEmarUum7l5b7oZx8UDJFmeo/g0IR8wcVdZXW6KsL5Z2Ry/H3RkOp2uLQdZwYb1ehlvexojXdD3FeFsIgy6XmNcDpsztjLqbIyZe3MqG7BD/QVb1nMzpeU6i3FR4sPqvtiGAyiZI2DgHpZ0Ryy2kF4Y5Utoux7UO8OJqT5JZQcl2PSSkrndfTZKQVuGoowTE7afArzlg81IuwKR4wyh1RbhFin1PJ2vMVUhOM7eojuS6ecoRF2BTJA15XVTwHmy2meF01mtQrnZhXELlB1uaI+nOUAUOzBrH1gL0bmvjQAA94o1oG6v6X1Ytvw6GG2hhWzqNcVNyQNrwYEXFPwEG1fRf8YfTsjpORQSSyH3ta4KVX
 VuHxQRKD
 FD0TEi+F8IWsiUFraR+4E7fCkb8XfbsHHGAQaN8cp99i2fITHgl8wXw7nabYqApuiJ9FQFFILxGK+ThP/VJBvOFP7RWWiMgi9NESVsK4T59IBqLZBg8r+BQJX/qUY8K2GPtZbnhynk35F3FSz/q007bU/sK8pTbHvoLlnFT0dJa4CaChdn9Y7e47plahFK/kcj6yxO7urL4c41wfVxyGfNiNONoxN2CiEBpk4JJMrFLJS+oF0dDpRc4BR/e9mJFnlJkqtnbEXIwpqEHOfi4mg9WCLDBEjmufM5wtbbLlrhsAwWjHBIZ0WNQ9NkW5CMDKjdj6xeYXMC+d9BGsRZ7fUmrm/EfZqo4c99zXGNv+D9moEGErCgRdEHWReHVRqSMiWXmhiEu0C1C2hEI1PXZquWlBKb3qHyXaScLTVbBW6yyoR7Jhol1As1qW3A9m1eEV1CmCc1/VrxHyVwFE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 09:19:30AM +0100, Geert Uytterhoeven wrote:
> Most of the DEBUG_RODATA_TEST section is indented by four spaces instead
> of the customary single TAB.
> 
> Fixes: 2959a5f726f6510d ("mm: add arch-independent testcases for RODATA")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/Kconfig.debug | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 32b65073d0cccaf5..7638d75b27db8cf1 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -175,10 +175,10 @@ config DEBUG_PAGE_REF
>  	  nil until the tracepoints are actually enabled.
>  
>  config DEBUG_RODATA_TEST
> -    bool "Testcase for the marking rodata read-only"
> -    depends on STRICT_KERNEL_RWX
> +	bool "Testcase for the marking rodata read-only"
> +	depends on STRICT_KERNEL_RWX
>  	help
> -      This option enables a testcase for the setting rodata read-only.
> +	  This option enables a testcase for the setting rodata read-only.
>  
>  config ARCH_HAS_DEBUG_WX
>  	bool
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

