Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7C6D6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C896B036C; Thu, 22 Jan 2026 17:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7CA6B036E; Thu, 22 Jan 2026 17:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D113C6B036F; Thu, 22 Jan 2026 17:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2CC76B036C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:19:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A1469D192
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:19:04 +0000 (UTC)
X-FDA: 84361016208.18.3C7E3B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9CD92180002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:19:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ho5uRbv4;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769120342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cJoa/bDPp8jVCZKjQzqnKKuPgFTVDX0LmbQXMJ3oOI=;
	b=o6dXnaqxp4U3b1jmWhjKAO5hLIliv76SAY5sdrDRk3tH36KyeVQ2HKvVTMWhTKIXAg9Imb
	tQ5Gy3/VP2dQX4nCend4jmJDmGoByRK2N5nXX6seWF28ZCzLy9IDzd7hVFEmeRzviARbwz
	OjIaxvFOFHrkNz07XOyTCoZUxq6WVCY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ho5uRbv4;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769120342; a=rsa-sha256;
	cv=none;
	b=13RgiXeyvzv6C8gaa2cZanSiGiAaRhGLGYhmRtkj7XBlM94pRet9gmBIJ9IoXftju0RF1W
	UhNzBfsrXJMEtL4vyXfwnIQBBqenLeImAb+NmbJ0aVjKMp1ZymsRLTk3j7ihlnph7DfhKP
	rED3/Ym9gKWPPB6yoAADoAUknlPrV/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5FA3442E7;
	Thu, 22 Jan 2026 22:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF61C116C6;
	Thu, 22 Jan 2026 22:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769120341;
	bh=6vyvXBeHPv3ZtA1GlptzUeZjv17+qL0cCQKu4626N/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ho5uRbv4ImD9QPIm5FOT6ZoQk1/H+SjS3UhTiJQscMMkOW8sNpkQKXjpmRT7Ni9bB
	 KNTjQNEUw65R0jO0JsTKJDV0UyTwzodp9Z/9bDhSO+n5MsSL9rGdyq8LRYE5e5WzIz
	 Csq2IM4bVbUY9TaVJYH7Lxgj7wG62pgAlqFukGpo=
Date: Thu, 22 Jan 2026 14:19:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hugetlb: increase hugepage reservations when using
 node-specific "hugepages=" cmdline
Message-Id: <20260122141900.3eb028abe20f6c31808f9b5d@linux-foundation.org>
In-Reply-To: <20260122035002.79958-1-lizhe.67@bytedance.com>
References: <20260122035002.79958-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CD92180002
X-Stat-Signature: 89ihxo1e7cpju75wc4zipp1cydj84bxn
X-Rspam-User: 
X-HE-Tag: 1769120342-303399
X-HE-Meta: U2FsdGVkX1/U1F22CMeuYdJSwqr9mV4uVMuvMcoJ8PR4cJ2O2ADgsn+RJbaBGcujFPryK6kr6+idWXmCpEkgEDPpil8I6Sl/3bMcRb/CqT1XNf+TT3SS8rX0ZAzZ7x0sxDq/3uJOAeVClZ4yQhB37RwdUH07dgoqWb2Ul6qaQft6dwzmHTgJXU5S48SpmP7nOp30T+ArTtinO/GfKahCMLOm3Sc+di4Lxtq3LavoPtfZtnfbpWdZSplFaQ340g5XyO3klS47kr/peC2W38pmpdQikjHYECy0GJxR8Y79eNJPwJ0ty+GehvxZvzKMmiXuWEsFuBd7rUj4TtsA6VnCHL/DMQpAMYjIzQc7regKJr6v+VRz0HEVttKkioZAO5rQbnOUWioNAkM/7OrMAzhLaNZyjsFvA3/qA4fAu7fwSnxbz9UNFOx3iNPd3aEhD2B+875HYNxDRxVumMfWAU/p1ETHP4XDoAnksxibQPQidle+1k6oWCmf0WB6nsM6tEqEevyI4VlkxqXGeriC2/mMKHXFta6TAeZE1ak1KIer7Aoa0ZwdAsyp63G6ESg1IX79zA/pU9LxKFSsTkj/8flYStYOquKTAGa0V6QpnU/pUJsPaDd5GlIunTA2iXF3Lfw7oPVdKvP+vThOZDl8Tjwi33mV60p37N59zQvsbQWCbacAOypQDyRPgezGTsDbZMA9pkh5bx/+/bE+EbfkwIUgtZKquO/EF6bXSUyg8ehYHP0O2LfPF0YnQzBLcuf1T1b7y/0b8nSdDcu1LhJhrJr1+4NhJcSltHOhZAhkk8jaG48yV0bBhkMaCpcVoZaNo4eFXVd7qL0efMw8I7+iyuZL1VNpgVXq+RbWP30+jwXB+z2MLBfXfsUOiELLox3oH3z32PyfHPyKduEBuWubIZ6av0zRHUnNY9R4oCBpMFhWnRhADeDN53Bv4c/ZTPnjjiEfV/vpa1MDoLQZ7tybuBg
 uUacqvzT
 zuY1zASYSjM2VuB6bqXdx11kUoVyqyT6rC6EjT2JXgGzc5VVm/u1LVURksjGu+4j/BpveuqxdRGvr7tWQicM+EOT7HDtEck4JvqfKc7Mpb9oiYKb8aj9TRE5vO72pUphjRfzddoKIk9YFwmbebiikNcniJlDeJzXpcSiwmo9QYcJchd2CtKerjtvsEinLToDIOH/ov8Ma0/L8vjexBaHDznfCwyytEZSTIUzzgP1Jl500g1ICSiLKVgoORZ/s2FR/1qFXymQPkVLxn2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 11:50:02 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> Commit 3dfd02c90037 ("hugetlb: increase number of reserving hugepages
> via cmdline") raised the number of hugepages that can be reserved
> through the boot-time "hugepages=" parameter for the non-node-specific
> case, but left the node-specific form of the same parameter unchanged.
> 
> This patch extends the same optimization to node-specific reservations.
> When HugeTLB vmemmap optimization (HVO) is enabled and a node cannot
> satisfy the requested hugepages, the code first releases ordinary
> struct-page memory of hugepages obtained from the buddy allocator,
> allowing their struct-page memory to be reclaimed and reused for
> additional hugepage reservations on that node.
> 
> This is particularly beneficial for configurations that require
> identical, large per-node hugepage reservations. On a four-node, 384 GB
> x86 VM, the patch raises the attainable 2 MiB hugepage reservation from
> under 374 GB to more than 379 GB.
> 

Thanks.

I *think* the hugepages= documentation in
Documentation/admin-guide/mm/hugetlbpage.rst is still up to date and
complete, but can you please check it, see if there's somethig we should
do?


