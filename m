Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D17D3EE75
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5F36B024E; Thu, 22 Jan 2026 10:46:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6805F6B0250; Thu, 22 Jan 2026 10:46:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582F86B0251; Thu, 22 Jan 2026 10:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45DA76B024E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:46:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8DEA1A03EE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:46:20 +0000 (UTC)
X-FDA: 84360026520.17.AC74047
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AF2114000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:46:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ugUX5Abp;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769096779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTgRqFF839zfox5fc4mnA8djOnx6DrQfhZumyGgi+L8=;
	b=E1B0FlDUW6HCPJCca/Zj5FnchUyg5ZnRelXaGh+PzzSv/PiZx1REcn4IdZ0YHbs7Zndspe
	5Y1HkKJ2mQTD4ug0wEyOEXfuWOAfFZBOSp6MX1slVA0lz7q4o7d8zzMsGMQRzf7SS+V1E/
	rY7OHXcLDuvv/JAc30gFHgisXD34hIA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ugUX5Abp;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769096779; a=rsa-sha256;
	cv=none;
	b=vf+S3ME+6cMbEZyhPWTSt+hEHnuob/et+S1bsf+BgMUdQFkV/BP2oDo4q5RbweLxF4bj2D
	JEcSLRHaLFvqwuKY+GBGxA8vDyUmm34N/0o7OJsYlgIhwnyUWkskz6qpD93qYgi9gwr6w7
	DwQzKN6dvVXNoLIAQI1BpGbdGzPVTF8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4B5160053;
	Thu, 22 Jan 2026 15:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0C5C116D0;
	Thu, 22 Jan 2026 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769096778;
	bh=L8NOTaXSRtoqLR3l1/8hRCXMpbiAPAlm6dpvHREsPIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ugUX5Abp5ejNCI8YQBzU3r58mmyqS/YEqIzWBpI8oLDkOIy5wvc6ISSkaAFDEiLep
	 QsjtjjPrSp5TfdLp/tZmn/MCQiUipvOPUFN/Wfxp0/uF+wxwrbEY20rmI7kFJf5YIt
	 BS160LbhEaFg8bCVtpw/oCSIYvul9UDaTUYvv+N9r+GH23IzNT95hV/4u7BschXles
	 tT6t3GVpc+0LfKTv4JuuCJWMJUcKH9W8Qf08dd+V6flp1ZnE8rQyUzkdTulKGak1Pm
	 mC2L4mCwk/kp++vDhYeQWpR8Hdnd3qTSjBoYG0GnELtfCCmgPImon/oSBjbLMKcvB1
	 X0O32MQaqR8tw==
Date: Thu, 22 Jan 2026 17:46:12 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: memfd_luo: restore and free memfd_luo_ser on
 failure
Message-ID: <aXJGRHyXw-KOi8wf@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
 <20260122151842.4069702-4-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122151842.4069702-4-pratyush@kernel.org>
X-Stat-Signature: tp5pn8ahkgo1t68n38xedsdgixi8gb16
X-Rspamd-Queue-Id: 4AF2114000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769096779-490425
X-HE-Meta: U2FsdGVkX18V7OK5+4eTW56pU9UxpLatiylUkshdKRFax3cBAECbAe7VQ4/F74SmuTJUquSlnN583Z5q8TZUNzlrmO1b08VDCja8xBVxRrRhZZDfoqPCFAUNRzjmMMpGoHiB9SB3Y9WKFnCPyaipastFEdzpJuy6Pi9+mp2/YRvQekxSGZ2xbP3C8rP8hxRzWIoi6RWoli3Xkwfwgsb/soopEqqjeKWt/+iIoZveguCWVmro93o/hY6HpWljeza6xjB8JYZpBBrgFPsEoq3JHTFgyseuIVnVnDUTEhhd5UPxkTEhruH2EzRi+jZ4/IGPqSfGNSBHrdaOpD5uyjdygSodUACov7U3vtJJsbC+LA+Z6j8kRarqHnMj7+Kc/huV22fKSPUi2bOMeEnGUXsHxs30ZPeL0B6ztRyvk2KITQsKbrwwnF+aZ51fYIq55nJkY5AEbJ+mL2YPTS58EnhSXxorgGbPLY997t3BJTzL762bJezeq2aImtzWmZbEXbA3LVpQavskcMLkc8BfhBO6stSnOAjJcs8rpWfwFptvK720ZItM8LVctd68K1C7PJsYnT712/uKTG1KRzGtt4pGJDNPAEBvHBNigwHhz2KT+wq0lxgV6hWt0nLgZ4APwS5TK7/C0YFGazCzKWhAl8AdW3qTvZDrf9sUz9RwO1rXDQpbfMw9fpqPy0OOdGGbUYPrvKf+vZhmexq44tiAil9j9KSU/YQ9gdoF2YIgcGVAYT4Mb7btTfl61GCBakbih1Uxvx3mz9B57g1ZYsDs5lw6tzjj0BfmZeGLtdV9DgPJg/EbzAkmxmeTn3mH5yzcAy1x1J2dMycnosKv+82Bre+B/M+u5e78JhEi7vE9j53JPq9qgLXeY/cVAIEDfTC7I5eNT4dqQbWdhsY561clTOM26T+Ei9rWxnMW0YHEVv/VDsHODfsXEPymSlD2q8TUW8k+Vnb7OZ9E/YaMGPtzKi8
 0MYy16tE
 PpcFvUthsO18xR0Q2S4ZAkXieXWpvFh2JSQ9ztpxCAqAmJMvWR9OUjPNipr7g3rQ9CUpIhWTYZputvWdbjDUlTafxZTNlj+c1Vbr5GOhCW++KUYyFMKScO4r+2ljckdpkE5Kz9neCvJ6ZXs4HQwmKaGvofkNrf1Nnxj8mUj2klwzMpjn/hw+YBQCxtk7BLxAdLreddNYkcfAq1JAATTOaLMF7EpQIUF3oRhSCH9GL88WN1JPMiyTn3m+7B/xTndIWrA8iK8NNX8jjE2JZc/1al0zp1479vrWO+TEvwt0BV5EeIpCNsHovocrSsE8V8zSzKavf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:18:41PM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> memfd_luo_ser has the serialization metadata. It is of no use once
> restoration fails. Free it on failure.
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

