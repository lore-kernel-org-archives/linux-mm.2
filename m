Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A6F109448F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1736B0131; Sat, 21 Mar 2026 16:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8F06B0135; Sat, 21 Mar 2026 16:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5936B0136; Sat, 21 Mar 2026 16:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDE46B0131
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:28:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 125EB140648
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:28:58 +0000 (UTC)
X-FDA: 84571209156.20.71ABCAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 69B9180005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:28:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NdX5w9gQ;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774124936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNrKriLhJrR7cdJDb8qFMRaj/p3ZIr7FZnpYIT1tQSA=;
	b=L4JmEz3Yq5AefHSMw8R72yJSwRPa373JeobMqjgpdcInGJp8HLX+kF3FbTtd0zAMNpr9k+
	F9ZFfQtXOvvxs8/N3RFTlfuTtmUrFsSg4aNz/MoQDX5oAVIE+Qts4hUOgCGAu0GF5z62Im
	rSVLxqIvcZZw+HHah9+2MkL3l0oCtD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774124936; a=rsa-sha256;
	cv=none;
	b=ssI+6rKDpwjaRNxWJJooILGkLACtXzfCIJIed+Y+5kibldfubRe8utYT538eMnRlRh3w/h
	6C1RBoRMMo+qlAv/9ICB/iPE+EhHsy5uPsYXjz1hTLXwVzsEnamYSsfUBwLz5gEytn2s63
	ba+2PJMMvE3dVcMsh35Scb4Z75CvykI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NdX5w9gQ;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BB3040556;
	Sat, 21 Mar 2026 20:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4FBC19421;
	Sat, 21 Mar 2026 20:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774124935;
	bh=kNrKriLhJrR7cdJDb8qFMRaj/p3ZIr7FZnpYIT1tQSA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=NdX5w9gQbeegNmb97/2uyJM3QF79WtJUlXSI75FYwCDmLMyjE7zDO7WHA3xWXw7xi
	 BXDbWfMlc2rJmB0Yhjyad7KYXTtBaCBVPCg7tSpN/NH/QkJxtXH9VKZp5Y3U0sK9QU
	 xYBXTFRuMFoDzKXDmdswXoJO2eGx4wB/aku6ddSNyu5p3wEtSHbF2ZCrM9IM2051IQ
	 7dvv+YdHR9QXWFnkviQQPod+R51n8FRtk+orAbjzQQAxl5LvxD13RNmI2+lCMwxXoG
	 lul1CJO7YTjhL/8RoPmGBfttz/wkOh+ZTRVwuFaU8DMWtBu8PEzQc+jaOG/iUv6dlQ
	 NlvOq28TFyRqg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 21 Mar 2026 21:28:51 +0100
Message-Id: <DH8QSU23BAEM.38UDAI6TMFXUS@kernel.org>
Subject: Re: Sashiko.dev for Rust for Linux
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "Miguel Ojeda"
 <ojeda@kernel.org>, "rust-for-linux@vger.kernel.org"
 <rust-for-linux@vger.kernel.org>, "Alexandre Courbot"
 <acourbot@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
To: "John Hubbard" <jhubbard@nvidia.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com>
In-Reply-To: <1f94cf47-9898-405d-bdf2-29e21cd87528@nvidia.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69B9180005
X-Stat-Signature: uc7xmwp4feeo1i6py9yrsocac84gjmkr
X-Rspam-User: 
X-HE-Tag: 1774124936-696229
X-HE-Meta: U2FsdGVkX1+z6rhYAqNM40/At6vdx41OJf9fUUgAst1qXFYFQgtb/DToiwPSC/uKFQPOScLaDb3rjKjQvgvT2ukX65SWPmpOjn+DUmOdQSZ9+IQTgsCBrt2pVc6h8byKOdcIsvcDFrCcD4u6lmlbsqAB5JZdt11FapPJEZF/TWPBwnkpACzehC9TlUzwpTe/KFc9nUb9Ih43f2CfUWq3+EBbEnRU2dD4MZBjfaA9uD09fJz5aWLpVYj+Mf1cI0a0QJaDgfUE/YzLwUYqpfHCG4jAL2QCDiWCesR14rAHOVEPWqE5ByUjv2KmoH95VIzb+uAyHu6rDNFVa5hIE6HjvvfhvAT/69UuT/JH8kMio/YHGLg0nlLueIhGvwnlof3nxHgeKPqy4WpPyEybIqD+F8hzf/Pe3y+pWDSFe/uJF7gH9Czqovu4fqo5d/QRGYvZ9AyEPIBajfcMUGB9RBhcwYb7KIiJhts+iCwNp0dyYm6jfluzKnFSm3N6wOCSAurN9sdfhZi0zReU7cQgBGI9WDgICAQ9yuImKWWtSmLakPb5EuRWibbBAu9y63gnyI4crP6gRWWvnunhs90hsIeCZ1Vij+JoqFo6rTijparb4Bnbo4sgNNtaAezIrtjFJXtx7zTUEQh+brJ7hO4qIXDe1sWmW3qGpO1jDaH8i/D65T7aFzdqvqfWrYyzEX2d3y0iQevjpk33OVokDHDbutrGOCsFFPkVOQAWf5I5bemSa8iuAkfN9TitdYd6EpjjgFbfqnCx8WjK1TsOkg0nFSdjSp4lk3zJpBIpOLhnDwqn0ALkiiFSnI/0gL2g57go3ERs6UhMm1/JtwU0NwguUXkKW4hapeKeCKw4WRg8C/r9Sf7XFzz8sMSdMHtliOjxn3agDwaVhvQhqoJxRLp6eViRzAObCzlvgsE7OIP7t7mgAPG/G/a2DOnFrvg6mpIjPeNfgd26q//VCug/0KXqNoZ
 n1K+J1z+
 MdGifv6I7d9NqNcy+WZGJ3G/3RhAFyjTnovR006ndVmcFWvJPiEmKmWO1YCEH8gfNV/R17xkoJO0uZHw1qvfupsf0lL0sOKG3j1vSsZG+vv2Fwd0BrP+ZQ990T+kYdpeeh1xHiKy32uZW1TA15Xs9HMtV0Z7+8QLMLw2VUSjJOuNl+NK4l5CDXHGRiE1s3zoC7/YWpE4uXaGZDDHY6pnDkaD0BiDBi2OY75AGZXrQsOZNxLbcwHaVEgPwbv70hKaHAIEaLBgPW8q8pXBFX9xBzFRL+aWPqmrPuaHJSvHNrmm6oB0c/jh4ziTC/PvJuUZJvCuG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Mar 20, 2026 at 8:40 PM CET, John Hubbard wrote:
> So what would it take to get similar results for Rust for Linux?
> (A bunch of us are working on drivers/gpu/nova-core and=20
> drivers/gpu/drm/nova, which are written in Rust.)

Eventually, it would be great to have the nova list added as well, but let'=
s
wait with this until we figured out the mailing list situation.

