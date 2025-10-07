Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C064ECCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 19:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2736B8E0008; Tue,  7 Oct 2025 15:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224238E0002; Tue,  7 Oct 2025 15:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1618C8E0008; Tue,  7 Oct 2025 15:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02BFF8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 15:53:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CDE51A0256
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:53:20 +0000 (UTC)
X-FDA: 83972367360.13.1A8D312
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99D3DC000A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:53:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cEhjVh0Y;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759866798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1TxYCGmuroKJkQdKW/LdvluLzUXIU32HYV2hUcSpcE=;
	b=EUYkdY6fyBFx+gAGDFZIv3X436Ahs3d0HyuhsiTn7CsQtAZoN444r70uEpC8PEmACuPDI6
	EQqBn+Sgh0Olrdgn8c+ZgFztEuqxxWFeT1gHeGC1MfjSLaQ9MsoZ09kHDWo9+37q+OaZmD
	MR4m+YhQr7D+J9dxsaZVXP9V+991BAQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cEhjVh0Y;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759866798; a=rsa-sha256;
	cv=none;
	b=CdYD6ORe0ZuZMWnB/xMM9AJ+eWqP3HmD4P0oRnPMF257J+5rVGJNQ+7U1qPMqEaWM+bUbI
	+x0qdXd9OGsCj1CyNvcJzCq/FZECn5aGVhB+mlfHeUCuLDnDtc9st4C4AVlurHN3DGN/sg
	ItOlhukpxKFRzf2AYKsYLglLlWoQMdw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B62EF60446;
	Tue,  7 Oct 2025 19:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4331DC4CEF1;
	Tue,  7 Oct 2025 19:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759866797;
	bh=TlsTiDVO/Guhxne2Ydgp1Bn723sJW0361/Ifv3FYjss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEhjVh0YsbpLOi8WHiyuxtBPjRZMoSs7xhsLwEzgcVJOxtgto2NDAtauq7manHzU4
	 8/QMXrRPlg5vkVy43RD4dhqHRiSRMzCSLCEDhz4S3u32kb73sT7nd4Eb/T+ASgQJ0a
	 WhvXokVvXBiGfC82rsKidkxXK9L34WxcoJ43o0wWCHtUKss9va2mNR3JKlv+sidtzQ
	 05sb8QH8oRUxCgOffc5Tzh4E5Udszp8VUOgftw5ccrwz3nRFKNHbL8YoipiFCnhSCs
	 HDeIyHXjB1eoYEM+ZG+lVdp/k58Iadhz70nmj7ubBO9qGTMEmcfnvY3Hp0asehlAsg
	 ub6XD9tx/C3PQ==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Date: Tue,  7 Oct 2025 12:53:13 -0700
Message-Id: <20251007195313.7336-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99D3DC000A
X-Stat-Signature: 3u7uyj63syjsaw1edpzx6jde4muossj4
X-Rspam-User: 
X-HE-Tag: 1759866798-78506
X-HE-Meta: U2FsdGVkX18EWbrBbMrySM1Q5xqwshKC9+hAPm7YECkvX7GihJ/xcRo62SGS3Y03i+TT1WwHW3z/LlRssY1bWvQDD062Y7HEmdu3+BlCWMv1tq0WZq/jYEle8JuepIKgJE5HYdHGrxYPQqjkFMkATV3KiA6vaFQNmV989wlopoIi2ciCNUqtVg2oxVARpHWnJbCFn027UyeHwkq+6qrnGp6Tg2peNMgOpzTNPq10tP7FtM8zpULpCkCUuRh9IOPELuuIw0tL0BvWhwFl252Vjd4wG1ohhUGC19XuzYa1c4oAR5QVoKtc4l3LblEVSPqJXFE6N6v9SxTr//Lge7XOKZnNuM4yoikrlJDXT95IjT+sNkGxRvw+o175+JGjA9yLcdm347xqIgr37qb8wJhbSWH6csAW3fuRcEEFFNdoSQAOTTcponpfnyJNoH1aTdBkj0X8P8uJg0othjiwNjuwukhH1fQZLD0vQ5ieeOEc5hsRd04G52Y1EyGMCWYxXuNjI2qedfzq4VeiXXBb017PWhts2Rem3oZ83bFuHwCn6cyzhaAKLkK1EcABiAYg6/zSE3XHl5V5GdfrlHeH2jSo6yQrVqELM6tFSbcUD+Wu3u3cuFPElsifGv36pWCHgr83B+aaSBNMg7jnWz2eU7hnajjI2mGzmP7ME13r8BoAloo6V7KrmLqsMqLZpDskyXMhUBYqZrFAE1qmFEXbVpjxGwrizxlGawqS/MRKaDga0SMaiD2mHNdVrGm2eX70PZk5XIWt98o117vsntZODDjb3Iuy5hQXRdwLHRg58bindZMNFJ+3//eXGs2DY/SUuEKKsbS2rszDc21HVQr9Ee7c9Ma4NG4dMHNy78Bz6XYdO61s3UtZOugbqJtqtwwQr3EbUKQ+welH3eeB444XZNhl+YUr0CEzO6+bhPCoGBciXBA4YbIGPzClvqzG5jvrQ2T46WwvD8Hz9O12xu/xWk5
 OsO9KKsI
 0giDZVtgcv3z3KsDxdfyzYAy2/RQ/M2P+mL2MtpRJ30XE8emRjjbONv3AN0LxOYVzgPkcDaF8poJxFdRwKH86zL+YKQpZ7X0QSRR8lsONOMPkLLfpG/WIO+sWhTnk/XBlQvjYRRK19Fgn/KN1PtwTnQ4fbOECr6rP0ef8JFn94mvOGdHwEhn0qu3NybM8ZBwNFht+rQL2pQq+hZ/mlrHWplbttwTnBgP8Sx6MEYbdxvuNzAb0R5hsbx+rzSTK/Vd38yyljlu1urFlTdASg4naahQmG6vCWZWxsAje3JOYNKd61TYa0lSGP1cUAUOkOMXASTOWRvpl/e4ZGnI9krmXsVq95/XMiN+yvBzyd9D2w5+ZGeYLJFxb1dnETZ3sX38ba8Qk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Oct 2025 13:25:26 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> __mlock_folio() does not move folio to unevicable LRU, when
> folio_activate() removes folio from LRU.

A trivial opinion.  So the user-visible issue is the incorrect meminfo, right?

I read your changelog below saying you changed this message from v1 to frame on
unevictable LRU rather than stat accounting, and I think that's nice to
understand the detail.  But I think further describing the resulting
user-visible issue can be helpful at better understanding the motivation of
this nice patch.

> 
> To prevent this case also check for folio_test_mlocked() in
> folio_mark_accessed(). If folio is not yet marked as unevictable, but
> already marked as mlocked, then skip folio_activate() call to allow
> __mlock_folio() to make all necessary updates. It should be safe to skip
> folio_activate() here, because mlocked folio should end up in
> unevictable LRU eventually anyway.
> 
> To observe the problem mmap() and mlock() big file and check Unevictable
> and Mlocked values from /proc/meminfo. On freshly booted system without
> any other mlocked memory we expect them to match or be quite close.
> 
> See below for more detailed reproduction steps. Source code of stat.c is
> available at [1].
> 
>   $ head -c 8G < /dev/urandom > /tmp/random.bin
> 
>   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
>   $ /tmp/stat
>   Unevictable:     8389668 kB
>   Mlocked:         8389700 kB
> 
>   Need to run binary twice. Problem does not reproduce on the first run,
>   but always reproduces on the second run.
> 
>   $ /tmp/stat
>   Unevictable:     5374676 kB
>   Mlocked:         8389332 kB
> 
> [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> 
> Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>

Because this is a fix of a user-visible issue, I'm wondering if this deserves
Fixes: and Cc: stable@.

Anyway my comments are only trivial ones, and I think the change is good.

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> Changes in v2:
>   - Rephrase commit message: frame it in terms of unevicable LRU, not stat
>     accounting.

Yet another trivial and personal opinion.  Adding a link to the previous
version could be helpful for reviewers like me.

Thanks,
SJ

[...]

