Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C68FCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE58D6B008A; Thu, 28 May 2026 07:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D973A6B008C; Thu, 28 May 2026 07:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACF66B0092; Thu, 28 May 2026 07:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5BB56B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:15:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83504A07F7
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:15:38 +0000 (UTC)
X-FDA: 84816573156.21.A1F2BFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFA4F140003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:15:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9gTPEnp;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779966936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zV4gfGEwj44JvYr4gAp+WyM/CgxIcYNiSsNnztrTu8=;
	b=gUzUVMWOSokl25SXmdUI2X6shJsUBYsWcYW1yjw6JEqhzdbey/tc/yUPajvElDDETD3GW/
	dy4ggIp0zD4/AZGICqJ+IfyCiMgBM/GfhWd6ZhNJRapdNQ/9Sy2obruhX09okGBbPo4vlo
	6nbc9XIFkZZabenz8MTtAhiiTq6Wo14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779966936; a=rsa-sha256;
	cv=none;
	b=pRANh6678+epR1FekelaV9+y8NLqoKv/kuSOCdOB4D3Zml5rImn63nk3rBjb0Z1wmmhScW
	CT3oPrLTUAytsii2Ey2XN1Hw8LqHLphcAAubxx+5VuBSirjSfJgQkCE1g5+rb9r6M251xA
	TJADE8R6iLe1baTmFHbS2JU5aaTSiBg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i9gTPEnp;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04BDC435BA;
	Thu, 28 May 2026 11:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE3E1F00A3A;
	Thu, 28 May 2026 11:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966935;
	bh=7zV4gfGEwj44JvYr4gAp+WyM/CgxIcYNiSsNnztrTu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i9gTPEnpoUAWn6UX5ax1swc7U+APE72wFtIEm6NRyMHpk4xeFbOCEtuQUI/R6DFsU
	 ejMmPqHdGDM7VjucNzaCepG3gpJYw9ovSQ2s/FgQk1a9gST6jpn+LXLEJr62fiH0fz
	 JO3ve7HHkjKZCre/8Tfj44lIjflYgBR41EdkJ+C6Y1wF3XKEMkgq4sC5XezSoO5+iL
	 K0SNDqd+K4hvwblJg9+InNqGNP+aFLepDdRo7l7Hw/yWXKV5x1uGWHZsZ1I2MrIZZF
	 fdYrNwww/POpPDzbh8XEWxmI5jyqnoUIEVfvs89VlYytGvxxRD4y0yllf85CAhlEfr
	 aVwp5CD5GmT8g==
Date: Thu, 28 May 2026 14:15:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com,
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org
Subject: Re: [PATCH v3 2/2] selftests/mm: add missing mmap() return checks in
 pkey tests
Message-ID: <ahgj0GlE32AzNq3H@kernel.org>
References: <ahbXTqLLLcYmeTp2@kernel.org>
 <20260528085746.2076957-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528085746.2076957-1-lihongfu@kylinos.cn>
X-Rspamd-Server: rspam11
X-Stat-Signature: 1yh96sxny4kceq9eauktdw6mznmpdn3p
X-Rspamd-Queue-Id: DFA4F140003
X-Rspam-User: 
X-HE-Tag: 1779966936-39430
X-HE-Meta: U2FsdGVkX1+J5WZDnvyODVlfjknk4bFUHuHhtsTk7kGTVDS4OKXdjlkiUhnoqx5ikxtlRCMsx8H1z8X10D9YWMqxzZeyOSAfz3LJqKgHDfNgA04V++tCHdB5Eus7hs5TMqQvCOXBvz09SCrSqCS3j0qJMG21J2ATc/MeiNaVNJmYeS2CLpN4qNhp+XbtGMWy2J7qfKiaZgD76z5K0mGeWpEiBZQZV28zlFzrJ/bwB/JYeBZTnu2nVgTyB2uh+kz1agEDois+4FLWrIrN08VbnLd85zfg6CtJRxACpc5ux4Yfs7Do4sbglATuhl42mjzP6ay+Hf6GN5TgMeIfeKWW61wtdv+mxlpsBsy446sAqiujP81qim7zUjQe7jrCW02mFbnQCJRllTP3H67b8RJGogobHQUdeFnUzlPAZEwKixapWoq9Vq0XPBgDfPyS0zc6Lh32pN5AHekx5Z4YRpLq/GF7wP70WnQ7auKd4owQoq80aHhEeuJs5lySCPY52FuUvRYYVqQ+SnQB20FK0wlpc0hUoaMHCQs8zX9m+/C/W8qJIpt1u2YVQ4zqm36FowbHxu1EH+SDEM/PowsTE+PIt6nwO8HYi70wiIN7tAkJxRtya4dLAAuO2RXsQZwERUrB66hchm4DI/aPtPTW+aZw76rqXr3GrS2Ic9nT3ckqn42Mvs3Cuf4KZHFXQM3AsKFYyIv3JHUKeGvORrCjIz5o4KlydhbS1RCKfyVj9P9ah54HqrlW6r0tFhWnDizzLmvxaKSK0xZNT55mHbTgFaGGDwbUVBRpGDFvm0gN8cfLIPwdWkEd4u0Vl1ArkC0l0RcpaYhrtjMGTZoVwyRYXCfYP5sWsVkQDk69u468tssRgpVcU+aboIof4hzg0OCn6wJherhsfEBb1vItxjCdy+vDlD2eyV1o3aiBsapTNSMXqOG5gph9RzHTFvVPXV5N6vFgwKyDeEHWCgXowTjx1wl
 CVFvIH1K
 Xu2/6dCO1YoJjPSXOsbS49H1ev7RnpsURSO5YBfNWc0tuDcnORxmLMMCkDTEMQFu/5DaGosRabSe0BTPSBdS7EZIMJW2rEtpCYyXvSKj3Y1u8BDIFi7xUkgXpN+sOmvsPMJokRu1mcSqWhaDc9CGR7pF6Cqm6RQazQxRyVf+AamtoGvToIE7iQ0ZbO0yvEaqQ02+SHy545bTYs/x0ViDXbJ9EZVtC7PHiWnal9LEZi2hxZxYBJO6yOZCdFmNEcNNFBlvj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 04:57:46PM +0800, Hongfu Li wrote:
> > > @@ -1693,7 +1694,10 @@ int main(void)
> > >  		printf("running PKEY tests for unsupported CPU/OS\n");
> > >  
> > >  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > > -		assert(ptr != (void *)-1);
> > > +		if (ptr == MAP_FAILED) {
> > > +			perror("mmap");
> > > +			return EXIT_FAILURE;
> > > +		}
> > 
> > Just stick to pkey_assert() everywhere, it already prints errno and exits.
> 
> This is a pre-test initialization path that runs before the test loop,
> so test_nr and iteration_nr are not yet set up for pkey_assert().
> 
> Should we just use their initial values here directly?

I think it's fine if pkey_assert() would print the initial values.
Or you can use ksft_exit_fail_perror() here.
  
> > >  		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
> > >  		exit(0);
> > >  	}
> > > @@ -1706,5 +1710,5 @@ int main(void)
> > >  		run_tests_once();
> > >  
> > >  	printf("done (all tests OK)\n");
> > > -	return 0;
> > > +	return EXIT_SUCCESS;
> > 
> > Completely unrelated and not needed.
> > 
> > And you may want to base your work on mm-unstable to get up to date version
> > of protection_keys tests.
> 
> Sure, I will base my changes on top of the latest mm-unstable branch.
> 
> Best regards,
> Hongfu

-- 
Sincerely yours,
Mike.

