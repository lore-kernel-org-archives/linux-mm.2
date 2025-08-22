Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFA7CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5762E8E00BC; Fri, 22 Aug 2025 13:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E0E8E009D; Fri, 22 Aug 2025 13:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B1A8E00BC; Fri, 22 Aug 2025 13:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 344DC8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:21:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3BD5138372
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:21:12 +0000 (UTC)
X-FDA: 83805059184.25.D684BB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 54E6D20006
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:21:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U88LAdsT;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Is22SgmMKUS2ZE23qEhAt0e4AbTdCr+63QUIFCZFyI=;
	b=6/qNcTqYVXsHorsU5CKIPO6lWXq56ufHurEaHAKMSaRAfg3PtdexGLF9adaGu8BuUypu2n
	6ingLT+eQXxMN1nC+XemHx2wuHdiiTEUhhfIGGCkdC2zWIsdxhij1F7wA2W1/Ya776UxfC
	kV9XF8wCCf+GAP61VUZ6goIEmbOHAyg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U88LAdsT;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755883271; a=rsa-sha256;
	cv=none;
	b=N4NSuiN6qdDOa9wEXxkXsSzfmSVvK34Bygnw8kc3/b1u5wL76XaDfWdNqP53UD/xr9K92N
	wZUqBxxJ0D8/0LxaO0HYRkDFE4xZAmOjIsgYXxp/6EegjdP0Kq0XiNbyGxasY+RNFSCt1Q
	5JTJG1+e3m9x5IjrzOF4CnXTJdC1T8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6AC143DC6;
	Fri, 22 Aug 2025 17:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BA7C4CEED;
	Fri, 22 Aug 2025 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755883269;
	bh=ZImj3pjcYuC2ihJZo92yeY0fuEGYuXc7qZ1H0GE4D34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U88LAdsTJUm1l/MTizSKP6oUQ3Htzz0sjYBWkSHEKk3dYvNK+5a4X++WJUqfFLOpR
	 a/0qT8uuJcJYFZmDuwKoU+HngpPEm4rABiiWLp0NwjnycF3JTrjHjl8wzAQ4GENfPt
	 T8DRqTpfCso4pA0qrwiEllba4qK+ZTFF/MsHHyQO6ifMrLmAdQdxJ01G88VnowxySo
	 kdgXDuDbxry+dk14E9/kOQ6Eb8lcNCQv/Z+GAccUdv6kYSndGlyRpSRaQWlKrN+Nxu
	 iz6E+4qTobnX4H5Gx/KD0kTJ244st+C2gWSSGk0Vr6lZQ4NeirIM8iPjsHqTw7swyI
	 s47KU38XvZKjQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 00/11] mm/damon: support ARM32 with LPAE
Date: Fri, 22 Aug 2025 10:21:07 -0700
Message-Id: <20250822172107.53905-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 54E6D20006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7rt8pi8kuua7g1erfapde51bdtm66d8r
X-HE-Tag: 1755883271-968596
X-HE-Meta: U2FsdGVkX1+dlAN9XjJ2XkC8iPFfudCdLiwUx48Nl5GeA8tnlgEKvwj+q7hTxB2HHAS5ky+MkIOrJkOrQb4nMkI8XdFoxNPMX44wBbB5c1gNLEAS9grsCSdEc8fen0zf27v3uh2Kaqp9ASCtXrpx6qZQScf/2DvqIY4BC+aTA833ndPaMd99EGyb+UO+mssXSJuc4Snyp5E5EwYvEUWOfXdbNRVvhcsJUMOE2Qoq3ZF4KGf3OQlaL/GnfZA9Xn6KZ/lyQ/oZDfEB1mExfX2iWm+THBRDmAVcLWexc2fiP4OFVhexyeN/aH6zVSJ4JJdiv35XnVma8cl628FOr7B5b5/JPgrUA5Kjzzqw0V0ODYGGndgaL92w2UQGfIxS1WZOF4WTCk1Zt+zbgixLoLn4DepurO2wEqu2sj9DxPEWprAkqWWvGFLzTFvUa2uHEQtIjMqkrWx5ci1LAyD+GBJ8NYjxjbrZg7WVCD9OmhiKqhIkhpDKW6vb3zA9naL1YErtZXH8BKr7k2R8V8g0vexFAxb2d3y8bZj+O90mFJ3AooM3JhnzhC+15yL5gd7Fq2xe31d2o2CQNHs5t2UnBVjN+8Yyfm85PrEi7iIF2bSxGN7l7rHcXmcJhRmlhYjWLvB/ZsveLVrMjNjUAC+1JA7xWylTtmtPz38WpvB3k90tThkZ4SjmpV4cV8r5jJO77EB4KHx6C9tM8Bt2RmAWJWLGHfbyclmFzD9YPWORpPQgAHkZxvBP8ECnC8hJfG/nh3jXKLftXD6d3ZS0+1hy7qP89xcmXAHacZJuOWBuMIhlAU6Pfprx1VyLXgM9HtcqboWQiG+ZSr0xz2Q6xm+yFPS9LRhjqfm10jobeXiNrYJKpT1KRoOVvnIpTSczpnASNnuKOZwxjuTMhaQ8/GcHDDZc8zBWaWTr6LTRd0J1iosAwHOfj+RBf0Eb1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 17:34:08 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Previously, DAMON's physical address space monitoring only supported
> memory ranges below 4GB on LPAE-enabled systems. This was due to
> the use of 'unsigned long' in 'struct damon_addr_range', which is
> 32-bit on ARM32 even with LPAE enabled[1].
> 
> To add DAMON support for ARM32 with LPAE enabled, a new core layer
> parameter called 'addr_unit' was introduced[2]. Operations set layer
> can translate a core layer address to the real address by multiplying
> the parameter value to the core layer address. Support of the parameter
> is up to each operations layer implementation, though. For example,
> operations set implementations for virtual address space can simply
> ignore the parameter. Add the support on paddr, which is the DAMON
> operations set implementation for the physical address space, as we have
> a clear use case for that.
> 
> [1]https://lore.kernel.org/all/20250408075553.959388-1-zuoze1@huawei.com/
> [2]https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/
> 
> Changes from v1
> (https://lore.kernel.org/all/20250821105159.2503894-1-yanquanmin1@huawei.com/)
> - Set dst->min_sz_region as src->min_sz_region in damon_commit_ctx().
> - Fixed the incorrect 'min_region' in the commit message.

Thank you for continuing this work, Quanmin!  Now the entire series looks good
to me :)


Thanks,
SJ

[...]

