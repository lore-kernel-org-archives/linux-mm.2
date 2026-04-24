Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8BBFED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6866B00AC; Fri, 24 Apr 2026 09:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDF76B00AE; Fri, 24 Apr 2026 09:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAF56B00AF; Fri, 24 Apr 2026 09:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF336B00AC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:31:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0029A0193
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:31:12 +0000 (UTC)
X-FDA: 84693535584.11.240C701
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24FE21C0012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:31:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WLbnbmRI;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvdUHaUu2fwsOldP6wJUV0ECuXzjmQHw1nQG4ZdMXT0=;
	b=fG2YqCUvdk8xyVb3/hwTsRbOAWOXtq6hz3zvq2RYjq8y+t+PfIHBcbPkGB/OY5BtG0V1fG
	LeLnJrxKBHVgTL8QI/ZtAC2yaCvqwU64ihRIlJaNFhhviNTbhDdSTiwNK7Ca9qByO92ACQ
	yFcvTyMSsFVe6CnLc8lxh6lfxinIXJo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WLbnbmRI;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037471; a=rsa-sha256;
	cv=none;
	b=62LCmrbWvz8BMDT3WpcBtXOC8ftimOecqUKbUJ5uk+v/dOxnYCkTp0mxY4uFHCtW1f62Kh
	Pw222sS97S6G35LEctEeafEHslaYOBvDWzRpyzvH3D7niQmQ/zAf+vh9p6mbwY++4DlyC3
	QLTDl2nsVwCLuhewrcTFnXlhfiQDInY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C6BE44445;
	Fri, 24 Apr 2026 13:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE7FC2BCB5;
	Fri, 24 Apr 2026 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777037470;
	bh=bp+ACcwezPuzPs1ltjFyz9x481JAiCF8UZHITo7dJiI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WLbnbmRIznNTjt5hg14jP0khfMtV0UhdvBTF3BjQLCjPyw1V2RKy7rNJx1LzsxhCo
	 PbV8vvqOPEUqo490ke59HqAgYalxRjTecEehhxaAMt02IoPnqubgiVQQ4n9z+TTO3F
	 plM3p077xPSYrmlvjag4jSowTE3I7OY6c7C2qYxM=
Date: Fri, 24 Apr 2026 06:31:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <li.wang@linux.dev>
Cc: tj@kernel.org, longman@redhat.com, roman.gushchin@linux.dev,
 hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev,
 nphamcs@gmail.com, chengming.zhou@linux.dev, mkoutny@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-Id: <20260424063109.6fab94d833e82f87e4309006@linux-foundation.org>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t8m8fbyo6gpm1egs7yt8wsx74d5ggs18
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24FE21C0012
X-HE-Tag: 1777037470-303786
X-HE-Meta: U2FsdGVkX18SljZnlNKbJkxhvO8ndE36Ml4hWNagW4finbYq33BZUWcHAKwAqOi3WfAp9TOpBuKctvZz5yGI3sVTP3jQic4qv+rjaWptlAw5zp7wj+W9npWEnHGCLSht/pThB05pfu+6CTTHxB9ZcjFXZrN8rKpoD/LIxy33ehyQLKxWIpNDrs3/I6/Vpwd3lh1MTfXYllztlHMTxvUfdQtxhsfh2bgBHsIoyCtRoVm5RbFfNE5QrXspobAksTx+HyrDzoaRKA14OnJJvpPWZDkYk9I81UVK5Z7Lc3nwTQUWjvMpYvKh3tijOgz9vwt3K32OQXucLMFDA3hsmFJbI2Z9NXhVaCaeqLK4V+Ypcmsf9M5uww1Zs/KJ+zQGTNd84eak1XosuwvW06GhQSMXzTwp0se+rP4Ee51pixVazVu2vE9reTxIdHm+nwOKsDT1ypGxdSrlmKWoCuJG+LqeMT1f9fumGzk6NTUXz/PljR2cUCeCuK4AExE5FA90YTk/I6m1KXN8unAyWUt/c+UQ7zOub0kQrlBd4WMUCydrrpCsda6Vnxaywjf9kLaO54ckvKqbhleU+6f6pb6M0YubHROvB04dGVTDhZlQNDHJtD2qScA8hWzfrnxtCeOHSjiSqbYZLvbSrzSKc/YIRaJBVD4CRd2OAM+JRmls7pC5aiSSFXq4e5GAz22W5bugH90ZEehdlNH34EUUPBwAao4tna8AAm+8zO+tGj3SIN/XD4Bn1qzdkgoCRY6f+5NY7fpX5YvScjtjXv8glKxStmPBzJkJUDrtseL0g9/F/ONWc4LROoq1MHDQLuw54/rK6c0AT/6uVo34BFbPUbBUfFsW7O8FX3GpC6R0AUWRJNB5OI9MmWZSEPscl9rFrtKhywFGmD5TgWvF6dMb1SsBOgWdgwAdY6KlVo7O6d0AHVn1NU1LJtQyonLTFeCa1j8anJYRiLolT4yBfe4xJK3HnJL
 tIdVfDB0
 d25yEinJJCd1T9yf1f8hIDg0X95CYBxhI3yYpSjDMoDt6zA44byZDMQHJ7j/zim3BUFnXuRvqnLtpWxeqEF0cAI5bZWkp64ArJN3koEyyAF6gRSlVWFZRAjCwOp49zw+JKob0jYSzk8NwLVodkkAQ3RbzWJmDbUxz7QPgP7hq82l9ITKAznMPDELQP4ZFJryMCrk9qwv7oFUT5XbxSGSjL/JkknJiC36Vhiym2pDKot5yRKx19sNW/FfLtF9MNEvYP8rzACgbMtroJG23+51zzxBxL9dMVuikCeEmoXMRcqhTPD+J9ImX5TNQ90jboDC/rVHrChASimqB0VRmmSVyFIUbyPFEl8vH/EVQsoPna9n4TrvDEaruJY01tYy1SoXFtIESPH+dVVf59b4XEA7JlRREyEQFxaYQApBxsmPLuM9uYMyY0rrIo15XKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 12:00:51 +0800 Li Wang <li.wang@linux.dev> wrote:

> This patchset aims to fix various spurious failures and improve the overall
> robustness of the cgroup zswap selftests.

AI review:
	https://sashiko.dev/#/patchset/20260424040059.12940-1-li.wang@linux.dev

