Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C46ACA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB416B0088; Tue,  6 Oct 2026 02:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C566B009D; Tue,  6 Oct 2026 02:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B29C6B009E; Tue,  6 Oct 2026 02:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F16BF6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:58:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82E86A055B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:58:40 +0000 (UTC)
X-FDA: 85291298400.18.F706D7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DFB1A40005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:58:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmxYwBNv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jMDWwuGt+jQZDR9Iyz1q8YOljzx/yRv9CuAM3sIWNo=;
	b=r/OVna7ZqeiVPlc4WjNkEZ8+r9npUCLFMRVALDuhFmy6oGbLO1a1ih2eJvE6zAJGTSGqnG
	c7+FoTzY//0QYUsvWH/mswORlMGKlZJJAOxXYFwYoM3IPM+Otu7b5sFpuaep6wGP+vCvCV
	i67xPssHnj4DwGDmBetkPQaSqNmEdTI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmxYwBNv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269918;
	b=zVd8i6ht25ifW93aI3pxuELTNnqZEuDh+PZzpmhP/NkpcHYHBBM0HkhMRxYTSA25jIjVTe
	hkM56dld9RG5lU5E1NKEfHC4210oXwyCsydaQHRwPJIhgfFCWnsx1iOdvCV924nhpgpzD4
	YV8ZFOyOLzZD+vEpNVTQIFJPDkMMo9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 633DD40477;
	Tue,  6 Oct 2026 06:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8201F000FF;
	Tue,  6 Oct 2026 06:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269917;
	bh=5jMDWwuGt+jQZDR9Iyz1q8YOljzx/yRv9CuAM3sIWNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LmxYwBNv2vdo+Lt22Fbi+OrKJWuJvO6cgiMRz8f/tWa+V7XLK/jIVQav4JUG7YUKg
	 1/kaSZ54kuOZ7iYK8aputcV43g8ExD9olA2aJq5eNsBAUyEBwmrAxErGxul5aFI7MZ
	 0cqNFRDwYH6FYbtmO3BKjUakcGje0X7px7KxzbMQ4HzpQm7kcp/U4+nXX9h7oxatFy
	 bUY6NkMKv6vz7mGipiVcui0XV1Kj2cmsfimrn2GZTfoOoziPQ31Jh9faTMyHARnM0u
	 rVdOpw8qEYgV4BguzsU9zrImi9paa120ffgs4jXIPd09F2LqVreyQlDAvaI7Qd06YB
	 Zr6wFEcOvcrMA==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com
Subject: Re: [PATCH 3/3] Docs/admin-guide/mm/damon/usage: Fix incorrect option syntax in perf example
Date: Mon,  5 Oct 2026 23:58:30 -0700
Message-ID: <20261006065831.42201-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006061549.627-4-adrianhuang0701@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFB1A40005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: c6yee99gofqbdh8geeu8x9prrc57b3fw
X-HE-Tag: 1791269918-347996
X-HE-Meta: U2FsdGVkX1/qKXbkGXg6tQqpFyCCI24n3gmKC40PctTp0MHD6aqaJVAajq2W0c6PgixFEDVNUnfwLoBez7dKtN6mllPCWYzh5NfFZgMG7yuT7FQ19z8rk2LPuiWYS2NH4cjBR+5gpunrIMMBGFM5NuhJtDOvT+17vMWftlNsFk6zqO3rRdmRYmkxBuEg8UiQd1yD24DaDE+c1Ms+R9DWZaeElllxT3WkyrBirLx7pSg2eZJWpQu/yUilTUhNoo1PjplebsoGU1MSyh/9N2IPAOxq1/2csjFfxHzrm3pL5egWIFOzeBs6wNM9KoqbtsyHcjcBUfoardUfRum5Cj7aO3FU5bRGT9o7CKuEFLJlCGgpB2dZC8GSRIZ2TKL6/MTKZDjPhsNZH/eP0EFoOWqTEhR2dFlX7+M+xvYHC57azHSMeyCX2GGODRxHYgv73nCYsC0zj7vz+s9kwRHifFkGv2/G+J1kweBcXA2Qdsz8IxvIJkLHwwbnq+TIpAbNs+XQWN+06dLRKx8r7VB859nZTYxkEhnZCxNDp09kTjPzW0guaviwFZ/3W6VQak4YH5T5KdciJymPKIo79gX7UkyTyEyt08ueM09NUZCxv0o2/DM+5KmW+IziU72E+F7TUsiYSjZDn4w6Q+obLoUxVt/U3KMU7WttnlH9G18SXMizCi/IEW3Hcdp+LYpMy6wOYScb2+wrg1op+eHX8D/Su9WIGpYoWKrekTzBfvKPIksFH19McXZF/IRf3Axa7A3Y6iGQRPrUV2fFRRuQNoqCy4VWWT+Z66IAre+TY4uqDySfDceD+NC5IO8Ba/rT3K4llgXPUmhmveXFIBBg7u5lR8dsuknH/1PPvWiVuqmNMxOUIdKqGJCf43q/YpmfPuS+XXr2UhcN0tHPV3UiiV1bOWJWJAva0isQT6wBTlnhgJ4McjsWAxCVrdF1Vryuf5uAB9N0ehKeQU8rZXfl8vDvXQ8
 ttXws4VI
 wr6+5pmN6Ha1QSS7Y17YDtTaFf0ZLKKu9o40Jc9J80LdmNQxh7cMIVE+d2TpjxfotzIXAQ61nSEOjnnpa5mZh6nG8zm64L7C+4Al5147uPP+WyOoQWZS06wKcogNO9gQS3YerPDBUQBFjYNUudsnpV8t1mXgsaM5Zi5j2hd6orxmbS4MhEQ2UBWzo0Q3WsF8Bbk9RNG7cvXX6tKIkX8wMOIrgksHXdAQgKhaYcSi3b4TJUM8/yWohBMBiwqtk/AcEBOQ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Oct 2026 14:15:49 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> The kill command in the DAMON documentation uses an incorrect
> option syntax in the perf example.
> 
> Use kill -9 instead of kill 9 to correctly send SIGKILL to
> the perf process.

Nice catch, thank you Adrian.

> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

