Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B91606A330
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DwrNqaSW
Received: by kanga.kvack.org (Postfix)
	id A1C2F6B05B7; Mon, 26 Oct 2026 10:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3116B05B8; Mon, 26 Oct 2026 10:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908806B05B9; Mon, 26 Oct 2026 10:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 748B36B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:56:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DA3C14076F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:56:19 +0000 (UTC)
X-FDA: 85365078078.10.F9E96C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 711A210000E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:56:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DwrNqaSW;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793026577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+ewwf0fRAznTV0KhsKm4y9B++fPaaKir0FyeSsvlOQ=;
	b=ZkERrg/P5wFlmltXFLoe6LHod0r8zFtl+1d51v7DyqDLuZplFjwg5oCOVz/g7SRRRB/P/2
	gZB1w1w6KcoUQMXJitxyQ/iQgIkisGWAkAZ1IS6uF1Yqbam8DAldvJRNHkKqzeeisNq0dg
	zkfqVScmGVFrBGQ8qMjKZKqCTNVm5HA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DwrNqaSW;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793026577;
	b=epj8H/Qt3tl/LN4wU7fAU2KaYlbWf/2JR6iSsJFcoeg89CHXYqXek6vxbGs/bN1xYEh7WW
	UismcAzJcGJFm06N85wLksisxO4VuwEClO474ld3L2ZISSFAOGobqxu5c4Y8sLGrzem5sX
	pf1aOvYmvbrhdET4r9Z99fQUVb2BK+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9BE344014;
	Mon, 26 Oct 2026 14:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5059E1F01828;
	Mon, 26 Oct 2026 14:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793026576;
	bh=g+ewwf0fRAznTV0KhsKm4y9B++fPaaKir0FyeSsvlOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwrNqaSWq8Tg6MoN8nZMgsOOLvoTK1JmbYmIfZGg0mIe04rMdVWmPY+Mzek5RH5hB
	 3/1jO2omDuIEizsqzHBqzgkDWwKzNtvLn3JZ4YClVmBsbHbf37/cAdk4vcwPLgaiNG
	 PHd7uZ6RWiPx7O3AsB8ToQnn7BhKrL1P9q5sMEHPBP1h1VVaH1swnJnuaciS0TOEOV
	 2rFnYpLBLTtY00Sbs892Sw3h6PeXpiv0wAl+KgN6gL8G9TJ160y18AZNKrFdLljd/v
	 F5djteKE6F7ZCq9FNYCtc61G+JIOHeaKk1aEDk3Iv21fzp2nK+6QGPWTfNjiOLNC2f
	 fKyCVTnWovgZw==
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
Subject: Re: [PATCH 7/8] Docs/mm/damon/maintainer-profile: fix subject-verb agreement
Date: Mon, 26 Oct 2026 07:56:08 -0700
Message-ID: <20261026145609.151036-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.2109326531018240569.damon-docs-grammar-7@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 711A210000E
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3yq3d94j9mrbquw4xdroo1b9kshawtby
X-HE-Tag: 1793026577-922632
X-HE-Meta: U2FsdGVkX1+Etdcl/tXAz3WIxTsasnOAXm5ikscqRtqmLB0jR3+Gb1JTw8+80upahLWCIJidB6zqQfhepC2Ar2CJUbVAbOQZmikT7O0DsarFAugPRcA4KwPnXijUejfD3xED+PuzSW3mRV3sHKFvYeuMMfgaxpzESPOE4zOoP/vlPkWEjXplDqukYGYTFjMTucFtsmj2ooJnP63O4Yl2L7HcwlHUjTDz/XfGjSFMOEAVyBPoa/EY6Tihdlg1NM6GXsSej5oUycpYzFIeMCQguaXR7PQ/2Ce67W9iC3ZbBlzQzdSh5zS15sE8D4tKB7PYRgr0u3urObrOFfLHHygPDpGaHcKue6NjHjbO6t0SQ82DsphjM1iBTQ66TYjUy8dd52yEFZyWgKrp0dfNYG3xF3QGkAQEFE/P5+L2+xapbPEZ/9065r2/8rhJnlldhDwukNzG/3Z6rb99TlPFLm3Hv+0aNRruEunYvxbZTGKA+AoRmOXd8HP0qGqBgiDXhDywJEo37w5eduR455LnQayT8S2rI5XVQAqbzIFEZoWptH2UgWQuLr7ibYwkiaw1grc8ldXWkNVFPdpGiDI/vYP9nXUIszDHg0U1skto0D0zTM1OYvlbKYmfd/geFpUWcrj319RDkQrytxzrUAmsi6chwb2lG4aUW9d0/fxFZNyotl0Buk+hgEoqNQ7Bp0UKtiKdrYupwYiHNJM0i1iU1hb5psOHVdqUKcyVxM3qgA+Nh2VkN4cBWgIGvxEhWONEJBC+ACZiroWwkifKN64oV307vRU3/jQm2dcgzVXf4rpiP9ALqb53fpYEG7nkMHQPMfkPT3B+JneUHZ7rb+uk5AJPTn0saaEnm60An4OJcKn2eWPIawvYWKvjW1frOxSAkIT2oaE5whbLuhl8oRqznPWE4+WEV640kpmtYnTG4ZXu1ZCvrRSXWp669E8nkve6yWwQZohJBNlDkQ/Q8IX2Ns5
 G8s7uYjU
 hddh7eLaCuWaWgDTNkqVkxXc3FL0H1n7nFluxEySB8i577gqWENm49gLSs4WGEnOMckv2Nqq8rzl4hxDYB3pMW9D4CDMDXt9s50JewVDBlt9f8YjBt/l8bH9abKlamEJ9ZwPDmAnvi9AeoLYHZ00x6yoITpeewHeeRyCFEEhlhqu/iEk8QRwhHwaAIBCGbR4eekxwq3eE326PayzOEpz8s8YEqgf68FUtwu6NjQgAmfdPKTbgg2+GYIfdsMF0mrbMOBSnSWs46WHP7elVAx/n9LFRzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:39 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> "The DAMON maintainer usually work" should be "works".
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

