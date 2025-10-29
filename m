Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358E8CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDEB8E0023; Tue, 28 Oct 2025 21:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E618E0015; Tue, 28 Oct 2025 21:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D2B8E0023; Tue, 28 Oct 2025 21:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50EE68E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:34:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA023C063A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:34:01 +0000 (UTC)
X-FDA: 84049430682.23.ADE3355
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46FD540006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:34:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i2CacSQj;
	spf=pass (imf04.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761701640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3Yc/tloRcuK+HMyEVQv+U3jCVDjfWF9XOBpQagP+cI=;
	b=ssR7R8+B+BXhxSMmY0cJ+HfAhoGEX/DP5loq0cp+ajYuEih2HYvJPqDzxj/KFTbeBiDs0Q
	fxWmt4RjuloL7dtZGihOcNxNnPz6hkkhwrwaTNdkclyVVK909tig182vT+05GdqgXcxpPR
	J4AbTfFKudZOKtwvyZnZ8VK2qUD+c/s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i2CacSQj;
	spf=pass (imf04.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761701640; a=rsa-sha256;
	cv=none;
	b=NmRo2DERSNErB/ZQn40Bk1bTsj6EfzlNjXmv0iPr7I2Pj65xvESdFnIfJmKbGWhS8kv5hv
	NPzB8D13itRCGevzhOmcJ9fLL3Q5kCz9CN3AFgRqRl7Z89n+yuYXJL3aV6mw24XLRWWBab
	/XujdQ1POXkk3FApCPaWbrbLHzhQFPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AE0B44A15;
	Wed, 29 Oct 2025 01:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA927C4CEE7;
	Wed, 29 Oct 2025 01:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761701639;
	bh=z3Yc/tloRcuK+HMyEVQv+U3jCVDjfWF9XOBpQagP+cI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i2CacSQjHmj9Ut0QvjXn1yYD5TGTQrCJ7pqAe6TCS1ETgHaXGlSxkPdPXJENowIKr
	 0dcWqbsoOMUnEU/I/CruVsiu1FngyDTvYg1X16idYC/1Zs+zy+SVhrgEe3k78xr5pA
	 n7QZZPCDOwjpz9h+DjS1S8uEFVcNmIbOSYJRD/BA2OloR2NxGyUW01F57/MCKEW5a9
	 bpQNcHPzyY7lIbPHuF2Ra5gUjlMSH29F+lI24DtTJLkpiWgvBjqg21XETQYbfePRvw
	 N/q2GamWYah9nYQeCmC+MHDHZb9qHEGFecyQ9MMnrAcDfUTGTfZye0kTc6deTq4r76
	 MiSZKe7WozKrw==
Date: Tue, 28 Oct 2025 18:33:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com
Subject: Re: [RFC mm v4 1/2] page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
Message-ID: <20251028183356.29601348@kernel.org>
In-Reply-To: <20251023074410.78650-2-byungchul@sk.com>
References: <20251023074410.78650-1-byungchul@sk.com>
	<20251023074410.78650-2-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pe359okgihbfrxig6de7eedb7yg6bbz5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46FD540006
X-HE-Tag: 1761701640-487519
X-HE-Meta: U2FsdGVkX195j/GJWydlHDT2UQkTAu2vOqDaNb5CkgSMJmm/atYZ0DGVCkbKsOorbnwJbn/qPRX6zYycyhQZgEREcD6fWjBAK8uRSuCYM80q1lEYMJ6E/kolWHEXTa8BIsPsMvIkkUcBh6QEPZwEL7Tk8DWbyw1kvlRRKUlTmk6AyOXstjgnJIGb2Dwo+8TSaR96GZrjfEdvyZ8g+iXSciCATiK0Di/yGf3sSkq9dsBnHWWvrhLIAztyuzrUnwhuY3RmtOJQQMrYJ92Dm2Q46F35H4AHM8M0yPoiMDpgezaygblOyTD/M4X4Bmp6UHZ3fgSRA/S8rkT/I4lwEZrgBXxt60wx7TquMMAoeSn5dTlLY4hC00Iz/BMoyoU12n4jJRR+oJeZhcMzc+DhQD9+NODdnrzz0NUSBHx/ttEOrwI7desf/V8xsc/2wLPNulidY1RWRuqBiL2W6tFv5NsgfoX3Bek0ZB7ePtxp9XAnnvxiaQA00j0/yN5dAMVemejCzQuLU0aegyMSLFjFnEQ2hKuwNALxgzJ8vWWNyeHGtwNzQhIMiWRnE2c0rEkD4pQAIPQKSk/wiRa1OwsojaBNDlhqWs7iBNmvusPTFsGpZiT4QxTCvywEAGQ2NnoAepYEKJ+MoKR8X7Cm3CoER8daY/ehUfINCJGR4N7Jgo60ymPw5whHQLZ35EJM0f7WPdP2gXDrrYJo/ag26Qc7yFB0eKz8lcW73LBfW6s/5HDi+6t2VK1bQXWD4qwPaghHZyl3p+KBIuR8bKdtTuiCKJF+TGhUCC9ODUb80gk1TWgbc5A5xS637xs+BGQDjJ0NIEliibFHSJasEMawKxJzXfXx1873nkYsuRFJJwnm6w1Olr4L22kRa5s9lvvadHE4x5MvWFMZvPKre1YuXu9WvviCLxZTxC7JaVxIcQ+oFZXqttVjP8NdbCsVAHe7edUyVfTiho6IsBa4cZCCj65ojio
 Tem/NRko
 8IYPpr6XE/gfs+/1BzALGbmhADj3HhxhHG6WruImF/XFqCVv440UfNL+QGjOfBGVA0raXJKWromz+SWw6jsL4sCfI6yLJ23a5Z8tkMPmVHNt2wgpUQ2yNhrj2A61rnFtbQrEHGI9z/2ml9AokE12jcAJKSpvQ6Ob150MtvwvaQSlWTYRKENHgMGuLs0wRD5VzlxTE0M5xErEpY6EZUODvzqt8d/cfA+yVyEGSXIUhINfNeehsyk+3T9fissNrlB6SZMZEX+c4e/0cVo5hARsBSQzXC5pFTQfJ77qbsAMNHIk4VcBP6CXFDI8/E9jgGBYuyxECKJf2TsPsb7/k8mdb/X/bbYLjIVrFeV6TPK1356XHrHFiCOxeecpkWVwyRKdUuPA1ORq6UDwog0bm5abj4SPRtdLLo35V67w2Y3ITYiCkbrqfRtvUzjOoSk/Lk6pL1yri2D0sZn0QVtNQo9j+eCxiHXb0OYlGhUI1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 16:44:09 +0900 Byungchul Park wrote:
> As a preparation, the check for net_iov, that is not page-backed, should
> avoid using ->pp_magic since net_iov doens't have to do with page type.

doesn't

> Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
> page pool, by making sure nmdesc->pp is NULL otherwise.

Please explain in the commit message why the new branch in
netmem_is_pp() is necessary. We used to identify the pages based
on PP_SIGNATURE, now we identify them based on page_type.

