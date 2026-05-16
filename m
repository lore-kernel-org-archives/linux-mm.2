Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BDBCD343F
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 00:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09EB26B0088; Fri, 15 May 2026 20:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050336B008A; Fri, 15 May 2026 20:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEBA6B008C; Fri, 15 May 2026 20:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC0916B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:10:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58EC81C0A0F
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:10:26 +0000 (UTC)
X-FDA: 84771351252.06.82D80E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8F21C20007
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:10:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j07PlK/G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778890224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/id8BxXUEcvfyq1xQnZq9NnK+oWW1Di0aJbC21R2BD4=;
	b=h5fNwUiwNQNT3wsqLhy877GrqWZ+v9JKymhwvFRBVWvTv46SOQug3ArWThXMBm33mkfHcj
	2IhaDwtoK/tWYOV9Ljk1JKtEe7sQhRaX2mQHtLwGM3nzcyBpNDTUNhuqFJCyEIaL1SYB6Y
	iFakykIvPKqpVufYhdntvCCL8W/pShE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778890224; a=rsa-sha256;
	cv=none;
	b=MOLsj4CyZD5jmSgHdj1DTN6Z8bmmaTqVRJm6gL1rMRJ4uPSDew0EgVB9nXvm46NrU3Zycj
	mymsB8fhsfWfmTgQacDamhMGnxb7jFb3Rd5XJ9v4VsFh5ClaPdWezH7aW+sctRQDNQa8bW
	/IzEEKSpe1/bVfLBGTcukHOTogLJySw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j07PlK/G";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92C5A4425A;
	Sat, 16 May 2026 00:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6040C2BCB0;
	Sat, 16 May 2026 00:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778890223;
	bh=GMWkD5pnToqx68zRdTd13MEgZFXmQRNUerX1E4pixu4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j07PlK/Gwnz5jRRFij0Mh9bSgrJzLvRkFA59HW/IqPpWm6TP2XGXhmwu4TIHauyUM
	 XH8iHEDLC0+ot6wY06xjMyyY62LEblKkUgf3Jx4nWGHZF15snoTdwQ1v/2yVphsNmx
	 jcCFrw8k1l1Y2FgQD7EZMi3lF1t4z9ZDvmYkp6qedGVhip1Nl99k11ZAtP+OjRSsBi
	 7z5o8TdNxS55tuCTLBSVFrY7fgksPWbMT0K/NF19tA5bLep8u82YSr7VVF3yWOgJWP
	 n1hksKniR23VATykx8wKgBdrLtB++EESBlvRCbk7fJaULp0X1d2OBwyle/2+gtj+au
	 E7DBUw26b/kZQ==
Date: Fri, 15 May 2026 17:10:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: akpm@linux-foundation.org, kernel_team@skhynix.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, kas@kernel.org, willy@infradead.org,
 baolin.wang@linux.alibaba.com, asml.silence@gmail.com, toke@redhat.com,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
Message-ID: <20260515171021.24a741d0@kernel.org>
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
References: <20260515034701.17027-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F21C20007
X-Rspamd-Server: rspam04
X-Stat-Signature: 3mj1dg6gxycf7r56zuhmnjmw4ypnkagb
X-HE-Tag: 1778890224-295234
X-HE-Meta: U2FsdGVkX185YWAPpZUtbecODabydwJrS4AcKtyXI+NolPxkXFlJFKkqsuNmFyHOnvggZqe2UbHApn13zCltNaul2KrqghPaZTyURJtCFqPAYCFVKmS21+b5I+UMt+OjABQiEJ1witz50K9EoUki530fWJmHLf+XJG7OPEnys8QeFiZ9t7jVY+KoD3AyCy+c0TDNVb+u61qoxU4LtUc+d2t73/gfOfp43e9ui1Pf1NEbUpGkDdwsJsiBZwdGq1ctySmRscBCWmjNn/FedWKflGMK0TIKajELWNWjEzC8i5WUKagXhb3FVwTW9o3XqgPb2HpkLLmXBFNS1hWvMzRowhfIQW/eS7/2VhRzPQ6PHR2jpKv0FiLavUpykUZoMYMDX0Bw0bgUL6O9UEuZnLZ7lks+CasvRy3g/fr0oNHqmqXyXZT4NjJzKtql8S5q2Os70mJ2G7xZ3igQkiaiDL0OtY32FppWpauq5WkDksbehkMytj1Sx7wEwO+szDB1S+o4OeOKIE218ThBAfzyABeQ7lqTgS13xXVH9BZKZpvxMM+iOoaJzJ2TXvPcSUd/Apc/pqCeXo9lOVWOvDaAPYuFEfKlR1LcKP6HmC8R0V8/YyLfo7UPctXhTcE3+LANTSX26cG3HC1pZ+0b7i+HMmIcHrDhCfsQvtg4rx2ydFxQniws9sXgW2Bk7gw3QjYSC2AFqQV8Bny+WD7c9mwCHXicDz/ifo2/s0P+suqMkmW5GGLZ1OanvVi/+w3C5EjIK6IUcsiaNzrqQD2SI5PwUMH50tL67CzRb3i29HA7t1lQy0NEesAQVOHMjwAEU1U4MkWvzCs27+NQducFOe5wlNoqF1zwBHftHTsBw+an7d3AdztkVz9dnDpd+qlav7MwIv4m+2s8O721Y+bnIM4u/kkIHYLySsfKD4iCSSWnbVH2sKYyy5xGGiW8YMjCkJeaOFV1IyJL9Cg/eC/Y1tBw+bY
 lq7dKmKG
 JwR1dsmVwbFFSScA2vX3xrEGXoU3ixx406jenNjVYVApHl2o7H5JPgLSSE/Bx0Jf+itmEGmfmrDq2PFK/9k+DoKP3O9uW2tXyFpPbAFLMnSIT1FxdtGLlGolA75B4R6/k+PUIjOfAr4Qi5SLxPmhGAcyfSJ5PRV33oeHjIPXsLszRBxo4e9JaO0SSmK+8C/Y57C4mltrROsyxbVPABBJ5FGVKYsHtcSSCnUR6A+Rz0zYj9J5Hl9wQHH3QXnM11Pwv0m2PuhiIl1ZVP5ehZ3jp3q9aYvX8TE+BpNMaBofgd0HtbGWw7GExc7J6VkgoB8ybHpnUWDSCj5+Ci+bGbrwE3JSVer91KHxiqUGumiZdIaxfGOlCf8BKDLK5JNV+zXBBWEWt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 12:47:01 +0900 Byungchul Park wrote:
> This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Netpp page_type'ed pages might be used in mapping so as to use
> @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> struct page, these two can't be used at the same time.  Revert the
> commit introducing page_type for Netpp for now.
> 
> The patch will be retried once @page_type and @_mapcount get allowed to
> be used at the same time.
> 
> The revert also includes removal of @page_type initialization part
> introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> to initialize ->page_type"), which will be restored on the retry.

Acked-by: Jakub Kicinski <kuba@kernel.org>

