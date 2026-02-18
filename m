Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA512E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 16:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DBE6B0089; Wed, 18 Feb 2026 11:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5176B008A; Wed, 18 Feb 2026 11:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26DB6B008C; Wed, 18 Feb 2026 11:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1E956B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:22:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 977CA1C0E2
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:22:29 +0000 (UTC)
X-FDA: 84458095218.13.5DC09C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9F401C000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:22:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jiWTdVvc;
	spf=pass (imf20.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771431748; a=rsa-sha256;
	cv=none;
	b=XqkGXduVb9t/7VKda5VtshwQLlD7UcnlatoBfQ3cZNKgPNbUYAYeImx42xaRO5l35jmkvr
	zbj2YwhvrXVHfmqiwCF9VMJuIUgXdapMyfggnqfozazBMB/lp66f/o1K6OOJGf96oNgbK6
	DWNkrTeeRp1Z3dMrNz2plYPrvWORmx4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jiWTdVvc;
	spf=pass (imf20.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771431748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUy9Q+ZkbHZPX4y73sCH2RHHSLVM+hRTJ0fflfxOU7U=;
	b=pyBYWtp7pB/bLP6Ne5w0/zXmwGHUgYkx9y/VSe+v+7M6voXqhgcUpx/C5T5qtBoidHGhlS
	uWKq+iX0qY0X79JsJ5K8wqbGTSnNCMefRTwuGLDZr3zp0VoAQv4b+mmmLOTmdU4vHvphMx
	Rz56mQgl8vnsEEdaF2usEWLUZfLVZzo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0417443D2;
	Wed, 18 Feb 2026 16:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9626FC19424;
	Wed, 18 Feb 2026 16:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771431746;
	bh=BUy9Q+ZkbHZPX4y73sCH2RHHSLVM+hRTJ0fflfxOU7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jiWTdVvcyh2SDh+a+SjHb9jjwk/USZJt7easPv0Yf7aTfALsaxGLfUoB2oesF2FWM
	 4onohZFG68avHdtAzXXE2Yt2zD4+1B5hqb5EyunlUnRkRznuY/b0n5MrDytLcgr5/8
	 EMNZU+40hlQrHmapzoYv6P1+h8NalekGBiT5M6SKRW4QYLOSgvin/eeZ32UIjWMaIp
	 /dF1jCfhS4FQb61nLEyZikrkhp1jb0SQb8x4ACW5IAFGkFPR+n/d2qUAT+tqAEKyii
	 DEGQr69lWmWmFrPAigH5TEDlzyLU6/6O37u8+/E6M4dXcxW9k8J1FqOoBqzZ5SBrcE
	 KGCNBlMkOBQAw==
Date: Wed, 18 Feb 2026 16:22:20 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aZXnPLt-Pkfj6eZl@willie-the-truck>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
 <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
 <aYSp0--x_QgyiUWL@arm.com>
 <aYTVAeMm5cFnuAL7@willie-the-truck>
 <aYTgoFQjEs_5WyC-@arm.com>
 <aYXZsRpmQIb7q83D@arm.com>
 <aYnM1A-9VZaOZoC_@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYnM1A-9VZaOZoC_@willie-the-truck>
X-Rspamd-Queue-Id: E9F401C000A
X-Stat-Signature: q1q9dwfn4ab9jw8n8bagc1hg6w1tubpr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771431747-299030
X-HE-Meta: U2FsdGVkX19VTTj/co+nrQ/KbYfqdOa9vYfqDDL7vtti8KanqpzUbQwCEXaiiycrJANxVA9Yg6QlO45RzSRkU587gRlyMLym6AQ5uP0yajcvcGgE19RwbGzcEtAUcMHtLR/4LP/Xdx+v2sGfjmU27Xq393UOok+ah+0yBszQHeqlIDytcQ9KK3muJMC2lrtcvI5SRMNTUc4/lnutmRMpJxE4tyF7NowO05FtdSZA6q5DSfZMeTmCp7mat6P3jldkE162YF1rx7bLmIKpu9QC/a06KrAnymUtfLRVggvjZvWRPVmkDaiDiP+dqxrsW+QA/MbHeuEKsypypuwsVmWENCCJpGKQypQpWpNMEp03Qpt5WpTgo9JKYT1Nfb0uNfYIBnp5x4ya8SS0CONdjw7YUHJTqdtXrWG+K1lXgtLCNbEhdTxvTWBUFKjQbsftwp9T/zJjayytRLvytzfdqypdBdFSe+It8box910z8YiiPG005ryFbCOvumJrAslk9SqSnMZEE8yuD6XXN26XDDM0amtTYApvf4D4s1EO8/lkBxQM+IDTdx1/UWJ1xTDsCXwaATR5kQZQPhCXaoK1KkICxm0izX1Iqk3ZGcD4dcI+aEo5NBuCMCQprIFlo1H08nBe/byDlB8psa/xY8bju8bNuFqyCW5olnqQ83NwQiIneet2f57mW2pnxqaq0Xa8dYy/12qmQkJxOOAdJbGLO26yb3NCy2kzVNDH/IYMYb8jZgqpmsYuV2zc8n+0U/m0ekIwk4gdsuRoaoIEown9mJL/RqNoYGHJ9c5RSy/rD55ycpay+PaLVs2638JfuaC09uSFXs3kXHKVzJXRbpWgocr9b76gYqsf2lK4CfP6YBkYiyaQep1xQyF4cZ55fUbnBMgscJR2n5Vz1STjYS6XYs1h8AiwYBjGqVjP7DJ0UXISHxCyxUUUpxn1sSbgDpyeph5lYKjYkEjrlAsAzC4Q4P8
 i0gf9/Bd
 TeMfcJEMW/GRZ+xVR2rEhkOq8OtnI/ePrw2FfrEmz+KIGgELVjhMnZA1vcuJBNdGCVs0VBLIsBOJsZbyXgOZubhyeKKkhjnegpoTFtVTJnkVH6n1urv8QadRf+c5qPo7xFELF73eD9MueDTR17yL6titFj5QIfYqn/m18V/XGkLRnJ2ThdCMswAVhNh217PyF7UiGDlSkifLXQPiXufrjIvjAs6z5ovCnYqtkTHqz3aZy6AheBYzK4tvsTYUeGkxzAIShRFBBxE1eXUIV19JXxPWwDuCx58EAlHoe24n5APhUyzJXwrELdH2B9ymT4iW4JF5x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 12:02:28PM +0000, Will Deacon wrote:
> I still think this is unnecessary churn. You then end up with
> ioremap_prot() having no callers outside of arch/ and if core code just
> defines ioremap_user_prot() to ioremap_prot() for everybody apart from
> arm64 then the intent isn't clear at all.

FWIW, I've had a crack at implementing this here:

https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=ioremap-prot

I can post the patches at -rc1.

Will

