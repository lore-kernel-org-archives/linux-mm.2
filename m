Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0244CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49F28E000D; Thu,  4 Sep 2025 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22CD8E0002; Thu,  4 Sep 2025 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37B88E000D; Thu,  4 Sep 2025 05:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF418E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:56:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A2AC1A0A9A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:56:51 +0000 (UTC)
X-FDA: 83851113822.04.2C15C5C
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12F48A0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:56:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="R G9qP27";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TfdnPvfb;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756979809; a=rsa-sha256;
	cv=none;
	b=2wlu5oxZdT1UIQEjyR/dOV26v5Z70Pne89WiGTVruVww/GFqt7BgtlQN6PdOyQU2BcSF4R
	VF78qM+66F2CcHBFDI46vkpbi2UfEyvxBv7A7r6f37zGm7CbT7xBr/btTAmxbt0z6ii35R
	4LRHfDIIdS2F7sIGWhA/6VEfJdLOSck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="R G9qP27";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TfdnPvfb;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756979809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRgjtoyz8BA3D8r3zYcx6ZaoyRe2lnSpKHe7TcKNhUU=;
	b=psjGxM6Pf2NcJjUzZ59drPuOPSb6Ae2uKGo1lobg5tFUiYQMao4BBkwVH+wGRqFddkGgMr
	4J0XbkF0C4ptk5g2zEvMmnX/jX5trOEzD/NzqPFxKJ08/ZEv7VqRM7rt5hRYoWbm6i0e9x
	Sips0zQ4rxp4hupHsjkQ2437WBCw6ME=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CF2A514001FF;
	Thu,  4 Sep 2025 05:56:47 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 04 Sep 2025 05:56:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1756979807; x=
	1757066207; bh=qRgjtoyz8BA3D8r3zYcx6ZaoyRe2lnSpKHe7TcKNhUU=; b=R
	G9qP27mwqyiII+hfHECX9yliQqY3nn2cA5PST7USHOvv/F/BCKBOMCMi02VcG/+E
	ts9N66Ve476jEMYSvdDSvXqCm/uKIM+pY+am5dR6mQer5Erwzrw5mZRUFwTaOrdN
	CUZItPP5V19e/zHeDDsNIyq8smsuwPrL6bmhc5C78BkHJYe8jzIiajiTu6rzQHgY
	O9X58DyaFDgctwytnn1A8L44T8JPipZIPb02DxhG7f4oc/J2LIkigql3BUh91E6z
	b1fcA9PtDrBrPaRRSF7sOkmMoI4gW7gqVDis0P52cdPDRLtBMR0a0BNXvx/tL4pI
	okjJ2+lFWpsFh3fX5QNpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1756979807; x=1757066207; bh=qRgjtoyz8BA3D8r3zYcx6ZaoyRe2lnSpKHe
	7TcKNhUU=; b=TfdnPvfbp3X+wQSPON5F3tAxixDIGim32a6IcqbXO4YDFkhz9uS
	NvUa8jGG7SZQ5LiypGUjc3wYPumTtzOxR/3tY4P8b0/WiNMVUrI5H4xLQ8HAlgKn
	uM7cErR3z9OJ53mkygogwFWWMmNuaWV+gCPgs3XjplBgKSooQXjIYjWAkIhbPzeI
	VBjbS8jUwh62PxapT65zGiHTNcN2Epfkfzgtg0SJ22qSPu6uwAKcPRrp1Tn+Cpzw
	E74qyQqL14B4Hn8YrLBtAsViLRxK8efvKY80kVaE86nm8E0bDvsVdbwMB55hMvYU
	SbhCZRaly+jWdYEpyfAP40uj/VvElRIYfwg==
X-ME-Sender: <xms:X2K5aNXggyFnuM8Gf7ca_BQe2fVJFRuALkjRUZBeiK96mH_TxlNWGA>
    <xme:X2K5aCynwOO4qZrow49r5ZU8gouZ2lBrHQ5dKNA-MUwoglk4C2Z3aDiDu1gH-pCC5
    GjnY3fSInBEuDPnahE>
X-ME-Received: <xmr:X2K5aKSzgDTO9IM3g8rpOvVBPtYziisnKK0-G79NYfO3ZmXRmIBHPkK35cIJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeekpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehjohgvhihprggsrghlihhnrghssehgmh
    grihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpd
    hrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:X2K5aGglJVLMEXr02yQaO1VZynVKYNzRPGjT5Vx3zkuzqjuzykj2UA>
    <xmx:X2K5aJk9ADht_BuLSzm-Ubm2k0mLjLQ4SLqJTvRGFQFKEkZ4vedmBA>
    <xmx:X2K5aBuFmw2OWHahmHBNklYIENKbQ6yWAJNgM0KYvUokHkpIgZIlVw>
    <xmx:X2K5aPajPrGLcRfLKIh2N8NJGNjncrMNDNB5SxCpax78m2gfd0icZg>
    <xmx:X2K5aKJ-LpaIFXhjkM4eMEDCsng7GTizFjY_jUod3_uREqhTxMMTVo8e>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Sep 2025 05:56:47 -0400 (EDT)
Date: Thu, 4 Sep 2025 10:56:44 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] fork: simplify overcomplicated if conditions
Message-ID: <tzjq757k4tt7k2mkcapttjuax6zgzr3nl7ivusuvxfmok5kvb4@vub2gw7vp7vu>
References: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 12F48A0009
X-Stat-Signature: 8hp9k6qgezcrxi37rccc9jrgm1tjwxgm
X-HE-Tag: 1756979808-618029
X-HE-Meta: U2FsdGVkX1/potU7MeNzFMY1NW9og89EH7YSVPt+6Mub6rxAt5OZrdReyCv66s9RufA8GGzg+tDxuQcgIET9gD6SizYi3QqrJldn0wsx28R0Vxko01LRyr7rw6tbVCvnL85di8cyoigSehKno5TGCtQV2ddW9nG0pjse6S8SyETzdT2tUaZoEcgpYGD3evwxioblhKNL0E3u13tOPaBJ7RVU7Rglw2kRmjxyM+WVAw3Z/kDMtZ/UQNZG0vLdpCbTveXK+YgXsbupvnwDuA5Q3YRveXD2n0Mru6BOX4Hv50q2LJgBOeayR33NaoNWSjs/a+cNvNN6kEH644zj8NSD4cBD5UWIuc5Wp1OmrkiwinPJIYL/xS/AWO9kL7+xOvXQpsN/R/g0cE+XIWeF8QFrF9zxFkbyjQgQ8VFnWR6Vg8+KlT4v6sQnAQdzVHJ7q1L998QDFD86BQMH3IYKB69VhpgSPFTaqBBThleV0AZYMFMuP/JwEmMx2luVu0YPGh5xEtBOGTxBVel6v6u+AbgB6CCQrHsa+WHGLBLabewkuWTkLsqV121O4FQI7tKGDHfWuzH16AxOeo2Xu62EDipNPVdygsfYBFUVar7JUOO9Bgt3mwtrqxiuBaPURo9xsULdU9shlAUEiH1d8dQDregoHHzUkZJXdgO70rLZll7mPbDvHEIFtYbPUF0l5GvKbrtISQwJSMP3Ioj6qlJkZ3QQCgqj/2ZYxferBmhJSdI6nrce6ds+wIVOj1XNdIbRg9Q/4IDL2bxsoQA3+OZblXAN1L1B4nO166DBj/RIkyR6UZiVI4rvJyTlqye+RK7RV5g/VtLUCWumt78sP7K1/vgswvhpVoFDKV7MC5yRHu3wSJEbw43MiOz5g6YjxkL2PqPC4nPKKZfKT4rifvG/jZR1wcwL0PPwJaPVkhAGsGgM4EustahhrKWseZbm3K53mPE0ih7+o1qM3mLzT1Zl1RA
 SKH/HXQU
 9kOlR03sAT2phbWqNBap3k7eAHlcy17YbmlLHzsOQs++dtVIiUn4CzaftHjTSAr2qqIv43RCWYeEbhgDDzASOwlyTenbNHklJ+9Ug3/2yebVv9BvHTHSh7U/OrXd3D9RYoMCy3zK6ZDPgTr/JtD4uRoHG9+YeCugMpCJ/1H22jhparugpBXHelQr3ugJgD1r6XyFbZdfHLX5+ifxZgHVNJRXO7XpbqXQGZmdAzJTpVWpdvi4r7a8YmfAz4FucBU2FieR9r1l6PCUH8PtZc/TmFexWKr4pm0QEGM5/hNSpbNNJtHAIqeKywS4Hy93YpbKKxrFb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 08:46:29PM -1000, Joey Pabalinas wrote:
> Since `((a & (b|c)) == (b|c))` is the same thing as `(a & (b|c))`, use
> the second version which is simpler.

Huh? No it is not the same thing.

a = 1;
b = 1;
c = 2;

(a & (b|c)) is 1 which is true.
((a & (b|c)) == (b|c)) is false.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

