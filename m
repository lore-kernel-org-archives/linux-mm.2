Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E9CFF60CF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25866B008C; Tue, 31 Mar 2026 03:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6A36B0095; Tue, 31 Mar 2026 03:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13966B0096; Tue, 31 Mar 2026 03:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FDA96B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:22:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05381160B15
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:22:39 +0000 (UTC)
X-FDA: 84605515680.02.376E3AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5543F80004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:22:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhcsdCfz;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774941758; a=rsa-sha256;
	cv=none;
	b=T+r7heyXkRWiWGM+q4l3ZIIlY3yWCAPd8GYsk8u1j95i8Xsp197uLNwvzdO6Jsg+yepKHt
	R8imOST6NyNMJ9sIfv9HdXFVXRt/oRVfJvexnzqVyFrXEv0fpka5Uuusstva/eDvstjiC6
	7WcEgsmF8i2x0XfDLW6GPgr/bHbG+Uw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774941758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRV2xROb0sd0cF4HGiyUlVKdordV/QtRMwVYAaxUhsc=;
	b=2BaNCYE33OJxg8E81/2XEeNYKHNMTM4U7JCCiLIAAbBmtlA8CWAMOayxQb+t48Yukvc1nc
	y+1gmMLv/9h7lS3OhrmXoTUhyBFM79CJibAJo+u0Nf/rI7yUKAgqDlGcKkbAu4SkVZV9LH
	rH886jvu1UcS+WQzyxNxjR/08rhwg4g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhcsdCfz;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29F7C43370;
	Tue, 31 Mar 2026 07:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732C2C19423;
	Tue, 31 Mar 2026 07:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774941757;
	bh=bqylBMF4ydyqvnzpcNQ3Ni+8LzSOq8suf1/N4xZ1WJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UhcsdCfzAiUk5aoX979n1D4zSHSJW0QYqSSInE0Gl6RFEhSZ6JRHX8+50No2p7/uT
	 25rWnD2QsUffkqSOlGyLUbY6FB+UujhzLMneR9XnNvUWKnSsNs2wEv0htN0wg/Rtjn
	 d19faf+AAMoe6RUb2cODk6BPyqk7+czt3uFsMLdgdKGyr5V1vq4cZDZRpmbedqjPHY
	 8Hq7xWIAnU9QVf6Yu3wl3xS0seUnH31MkTnkEuDXDvw/dr07FA4mqeSRC0h9HH/BJj
	 3DgeLyKItDd+Hlm9ZLP170oI/e7PuKvzzoIUK5QFBO/7dqVVqCVvDD6LCg8OeYz7cX
	 h65MlmRKYz1vg==
Date: Tue, 31 Mar 2026 08:22:32 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Julian Braha <julianbraha@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, hannes@cmpxchg.org, 
	mhocko@suse.com, surenb@google.com, rppt@kernel.org, Liam.Howlett@oracle.com, 
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
Message-ID: <bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
References: <20260331070730.33915-1-julianbraha@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331070730.33915-1-julianbraha@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5543F80004
X-Stat-Signature: 4f7g6e3isda38ag133kxmhsdm9utqu3f
X-HE-Tag: 1774941758-451468
X-HE-Meta: U2FsdGVkX18yCOgxag6onf+9U78Bhl7bKBaGdBOFcMDFHQW/Uk0JpmcHczrSQ/8fh3T80T20vEE44BRYwKQkZTLhOpZtfVAPbsAVghGwng8s2zogcw95YrcLv5PARys6405QqYVMY2FOnQTD49wQl3aVlnmjoHrxa4JDSVWsvYWAKCop60zxwaDU41ZPqp6R+UzkMcJqyzNyR4g+Teu+VdATVV5bWzcle5Ulumq02bg8XFGj28NP4SGBQkNULc7NZfU3c6rRcp+fQ5Q1AUufItNrF7CxS2QRPRfhXa4KTHr1CHz8eQQsxcZjI/7eGSjqOeOzoHXIzs0D3DtPymIds62i3fq/KUlgfOXH1zTiQsGS4M+5+tXd6nonxR6/2R39yZrXiqV8oeA+mbtiWhJ9uk6lk199cbaqXk6NGsV7ectOT6t2cl1XsYIWQ7pp0TUmFeI+L+Cq/ndefUiCewarcGbinlKlzyTwoo7ScJd0HHRkzJjZHQNhlsoNf4Fkw6uEJhJ2b0xG5ZcziX3TFa/Qlsl2PmE7ANBDqRNk9dO+rrO9Ucx2ZL4R+rciGMsIJOB2XTPC25vxj647ANZMm0JA/4RNB7NqJ2sdA/58mzmNcLjbGtXH/gFl/MO9AD+3YL7PcZeZHNkSksKL034LvbyxUF88cKXgCINKJC4Sq+B+lCg4WcQwgMazt1R6mpsAZpPBXte6mSFqXx4ayZFukWQSeb1eRmfGPiXBLR5iXk0tG9rpo3dzQBSA8XErKCB7jyU57zcvE5adZ2T9dQOTSJyOzqviIafr/woaiganCYDqga/+qzVaVKtMvfqajH3YnE/euvnPv5qf9U4Z1I0SPjpqcWL61Wx65WLUBRjdg8XJdTQUSkJCvqF09nVk9nrREsyxRRxdXcHr2c9xUWCR6PpXna1Dcn1MkYrdyP9wmn6VaHILwCZv/qmLDttKcWbfRQYq2HMiCpuP1FVFzJ1ZIB6
 Vcy3VJ2C
 BeHrD5pWyVV8NV2odYpGd7dLAxOYOC23eI+KgbZK6SJgCfxODp+tCgDoPayMU2FSKLiWhw2bJrITQudREWyd3DJfGDycP2abD2PIL/nyknd+JwXrNWqAWj3tQsU6ypHi4lel4qEQ7meUnaTDqABLKezy/Dw09MoM++V52aFbRlxqklW2hR2hI5VhhEOizzrTP241luHCp2hWG7Df20dZXcHiHGUOf3KlZyroVT6iwKA89QfA+AntWfg+m5jiBFeII7UAY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 08:07:30AM +0100, Julian Braha wrote:
> There is already an 'if TRANSPARENT_HUGEPAGE' condition wrapping several
> config options e.g. 'READ_ONLY_THP_FOR_FS', making
> the 'depends on' statement for each of these a duplicate dependency
> (dead code).
>
> I propose leaving the outer 'if TRANSPARENT_HUGEPAGE...endif' and removing
> the individual 'depends on TRANSPARENT_HUGEPAGE' statement from each
> option.
>
> This dead code was found by kconfirm, a static analysis tool for Kconfig.

Thanks for acking tooling used :) much appreciated.

>
> Signed-off-by: Julian Braha <julianbraha@gmail.com>

Unless there's some weird semantics I'm not aware of, this LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/Kconfig | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e8bf1e9e6ad9..29d2de0d5c06 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -810,7 +810,6 @@ if TRANSPARENT_HUGEPAGE
>
>  choice
>  	prompt "Transparent Hugepage Support sysfs defaults"
> -	depends on TRANSPARENT_HUGEPAGE
>  	default TRANSPARENT_HUGEPAGE_ALWAYS
>  	help
>  	  Selects the sysfs defaults for Transparent Hugepage Support.
> @@ -840,7 +839,6 @@ endchoice
>
>  choice
>  	prompt "Shmem hugepage allocation defaults"
> -	depends on TRANSPARENT_HUGEPAGE
>  	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
>  	help
>  	  Selects the hugepage allocation policy defaults for
> @@ -886,7 +884,6 @@ endchoice
>
>  choice
>  	prompt "Tmpfs hugepage allocation defaults"
> -	depends on TRANSPARENT_HUGEPAGE
>  	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
>  	help
>  	  Selects the hugepage allocation policy defaults for
> @@ -931,7 +928,7 @@ endchoice
>
>  config THP_SWAP
>  	def_bool y
> -	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
> +	depends on ARCH_WANTS_THP_SWAP && SWAP && 64BIT
>  	help
>  	  Swap transparent huge pages in one piece, without splitting.
>  	  XXX: For now, swap cluster backing transparent huge page
> @@ -941,7 +938,6 @@ config THP_SWAP
>
>  config READ_ONLY_THP_FOR_FS
>  	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
>
>  	help
>  	  Allow khugepaged to put read-only file-backed pages in THP.
> --
> 2.51.2
>

