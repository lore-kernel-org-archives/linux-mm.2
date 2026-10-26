Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FE4606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mM1Mmixo
Received: by kanga.kvack.org (Postfix)
	id E36076B05B4; Mon, 26 Oct 2026 10:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D7D6B05B5; Mon, 26 Oct 2026 10:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E216B05B6; Mon, 26 Oct 2026 10:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA14B6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:54:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB5571207C6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:54:26 +0000 (UTC)
X-FDA: 85365073332.06.D2A9A3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C17F520009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:54:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mM1Mmixo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793026465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsSM5NtB7qFzzfdTKjGygUEvP/PLSZ0yfQxJlbFW6Yw=;
	b=nxoKHLZpnxis0FWUTJ1IgJxrT6fyK2BN5C3A8JLn54Brdy4KWT8VGDlvkZp9AN5pq7qvCE
	CuHg3FvwdKkZq1Opp5WL2KHamtwV+cq1Cc6SOH6Rxj651OEBXBFFXE8pLGAfgVXinitAvZ
	xnMh4Iz+ejVOk8uoIJYrs0FxUtuR/6k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mM1Mmixo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793026465;
	b=h9uSmLYeeQz8ymPNTssCVOEQ3SZ66bK2QufPD9YTlfvn9umRF386fKHGQfvrWQ5QawWuD6
	aVjfJ59OuzqyVjhIK0VTOycO7bc+39wTRppUxapcILE5kGLSL+aPJWR2V+l+Q+VB7F5sGu
	F1RQQk0KYd274kar7RuRmZb0Cr/OR5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96A8F601F7;
	Mon, 26 Oct 2026 14:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27A71F01825;
	Mon, 26 Oct 2026 14:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793026464;
	bh=AsSM5NtB7qFzzfdTKjGygUEvP/PLSZ0yfQxJlbFW6Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mM1MmixoH68pbNiAXJycnQtTEeaPFCUPUoB+GZpt9547zsYusm/yMT9IgTdypw2Un
	 ZBu6oW11WvFBctxkQ9r9U0nE+i0JoF/FsCCYdNFPKqgQWoCVw+3nvSyowzRtIxdIVC
	 4ZwTJA4xAp4n5FSsoqU9jP9AqvlVFqXzkDp3W63INSFFotBWKAVJNSFOUy7zmlTvXO
	 nuTdgLOVGKUZN7d3e6lRziBkF9A2kcVBjcrNxLS16k3BLPYURoe1xP+xoj9oT1rz41
	 AdfUZOINoJtz9giy7YSM1s84r+HHDY5IQCkxrEItZFa763FeuKk95RO8niShmBt5n7
	 PG6c/k1JR9eQg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] Docs/mm/damon/design: fix grammar and typos
Date: Mon, 26 Oct 2026 07:54:16 -0700
Message-ID: <20261026145417.150739-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.12612582132957329203.damon-docs-grammar-5@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C17F520009
X-Stat-Signature: e84ijpeupahjfdhi74k4wm8ghxhnymjq
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793026465-751692
X-HE-Meta: U2FsdGVkX19hH78aOhwkDU1rTAOvru76t0OCc1nZ6ZE1AbZjtuVytV+ZSkDfirPNT5yrtqC0quNCnBuNQJEjZShl70zv3oyYuZZ1t5TeD4lWP5aksnGptiDqo4XJ6XKIZXyzzMuBC8y1dGSKOs5hBPf7kkaUMGRQ85erSQoJVZvnr+CwBfhZlkPEYryYHlRDjNmzdLYc6zQcDBN1xpmk90PE/qeGSBXl6JbCv9cF5+ghNTfSic61Pk3RuyHSqgcDBw2SID0hvLqAeM1vXm1g89/Knh2HtgTNmvAO5AokKAXk2lI+MUVi8Q+mR3z5EcS/gzu7VrvYsHUURJqpiLuidZdFNVY4/sQCOfuLFwoJyhjeBVsSs+10PRih0a4Ww5CPdkq4GYd+zSX8149omihts10NKNr1kFRlk1RA72bh4tsy3tWc9jshEXbHUccUdqggPVMoyg+5c0UIEcw6p85Dwgn3//qiF7m9oIrKBa8H1Y74UkJceBypaxkafT2sUN7/4FPdINmP8wc3fzfwGr+BLt9vZHZQ65zroshG0UzBi0TXOEl31JeMcFL9Qg0tejANM3CeMTxDhPB7XjFDBBrO+UhTK1oF9q+VEQO4pr9Bo50y5NaSGZtv45AUJXTOCMe19Fi0v6kMs605ZW5fILR17iBXsuzYFIN4SoCT5+0vDwRQQ4WCTUUSV6+bYD5KK3i+oPZ8AHISNfQtzgxklggOSFV1arSK1QeX9oR1VOe4us3sma+Zl4uxhyJkcQdViJauBZkysnl+BZlbzdBkznL68oIQGp0QnYHJG96lEjP3NZkzJjRxnQ8TTvWlOtXR6kLMET7SKIarOHT10it3AUNHF9J4Y7sR0VY6p99hI9A8/SXp2fmGfeTlsOq3Hn6F9K9QBYtMg9a15YkWHDobemTtFDwjCPqS0VLHeDzzvk+sh/ImlruBUGWJLJxxK3b4uZnvpa8EtJAtD3BTXD8uhwK
 /kcRppHR
 1U/gHPWf3NOFZLFHjIbdPNxhSVT0uYlMR17K4baxr2u/c9OmHFRJWy/BpJ9WToyK4Ahgj10aQeKtZN6jHPSYzbswUkG2+HgMuYZ4qT2EtQxh94ScCvKa9Gvl/IyWU56hdLynRCJirejlRLczoRR8L+7VQRxmaUoOKqMppYTverLZaWax6gEtVDkx5Pklv447mMMSEusuNWmqOM3h1X3GFMgawOZ7t26fxg6PXUcl3Wkgyn614f7tPQOA4uQAbjRvRv66K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:37 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> The design doc has quite a few relative clauses that seem to have lost
> their verb, like "pages that assumed to have" or "filters that handled
> by the core layer".  Fix those, along with some agreement issues and a
> couple of typos: "Parreto", and "Use space", which I think should be
> "User space".  Rewrap where the lines got too long.
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

