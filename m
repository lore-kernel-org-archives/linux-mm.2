Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7A3CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D526D6B008C; Thu, 30 Apr 2026 21:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03796B0092; Thu, 30 Apr 2026 21:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19076B0093; Thu, 30 Apr 2026 21:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEB136B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:21:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE05614042D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:17:52 +0000 (UTC)
X-FDA: 84717089184.17.0D32478
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 186B2A000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:17:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nAB/R2m+";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GN4RfoNPeYa6h0Im9vOXjc/OVabSsqtWgaeDXUT1NCc=;
	b=QRuyLjBqC35XwSZ3VH9AOY31HSvHHVtWJ6Zimpr+7udiniBkaBTnBvMPYQMqdFVMw9KQhP
	S6r1avmVxW9b7jKmj5tx7stCjqxmM9MiGps2Ix71Jt7Z2/Tzj4Xs/6PHIZSkP8tLtlLniR
	aARC9argx11JfMjKA+O+boG3xeYfUjM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nAB/R2m+";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598271; a=rsa-sha256;
	cv=none;
	b=XOieKg0MB/WGcRopef9QlptrhUlFVwyAcqp7XqWk0Gw8wPmJ87IgIH4J6fWXAX5SkO6Sjf
	s5+t6bepdJJoSvQfCHTQpdIL16riwFQZhKxHsllyEf3lWhAk+lqj0yo9/yU2N8wZIY+DOY
	L9nYwD5zFVsTWJZjs9J5kmQYB2QgnOg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05278434B3;
	Fri,  1 May 2026 01:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448D9C2BCB8;
	Fri,  1 May 2026 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777598269;
	bh=tYUxA/J6ODEDki9sQswRmgCKXcppBQ9ffFdDu47dDsk=;
	h=From:To:Cc:Subject:Date:From;
	b=nAB/R2m+GcpomPGZxgZ0qGbow3/0nAACzWkLFUpzxNem0w5w0g7k8d6uTwzAzH31U
	 TUTxRSDTeMCLpEXWm9NteYKgEuzlJCm7qvPNCIZElptyDieDF0xsbpuHC5KOrqnplo
	 JtXb/ncvb+LFDTI5/PxnIuVLKSzck4ShQ+awAy2fT5PYcWIBTgTPzxxozo00m2a5ss
	 j/vzuOYHkvaVo4QnoMi5bkNpIKxezRacASGDQj5KTFf4BYNuts3ZiJtmckGrMxhph1
	 Rp+TXsp8PWgpDQcw+6G2oDJE2UcVenA+dxg7VyTYICtyZb1uQj9nrrylvC1v6UG3J8
	 lZDYom71HMGjw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/reclaim: support monitoring intervals auto-tuning
Date: Thu, 30 Apr 2026 18:17:37 -0700
Message-ID: <20260501011740.81988-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 186B2A000B
X-Stat-Signature: 61ofeqww73yjzbckwebp6i6ixysz5x93
X-HE-Tag: 1777598270-680047
X-HE-Meta: U2FsdGVkX18HFNuH9fVegkx2s8ETBmBiG72BPMY8SABF9biQ6/9nGsoadQnVzpX8LMAcKPl07a8gr/kSIzuu2fOj+vBT7AXiBidBatlmFjuHP1wgvKSwgLSQseJi13hDVpyXCyRXl2WWEbdQ7EOGHwtaqfqzaUL7TFBMoXlgGaZAcYVPYW2IVQH/jWIRT9dBvb8Eyruuaxj0kcbOP79r1BLpL2QgbNLzxe+DxjOqD2kW3Y6P05CfV2xUePLyD98tRcRC+o96Km/kw7XFmeQUCELI/bTi6wY91h/UqnLDeuAkxTkC/NaYHwuz5NZ5LE0WtrKwqfx+DcnxCv7Frq2t6NUo4LNyMU8RC0QbGeIYXjv3Zae+pcBkHkKSkK+3ixRQKyRKPWuX9Squo1sNesPzfF5OkcsFu8t5PTVkOtmgcxiaHpKFRDnKyIhuRuyWlFfo6PWOqz5UL9UXtIpEfJckRotuN/QjjukQimoDEQwewuSiezX+r8iqCboMgZ5zn3Yqnz/jVWG+G7XB5SP3LFe7MdyMwf7nVKPIuTuOnWD20uYh6vYQ0CFLW4Xha033V9vOTe3h+yyZbXtybiYqpFKUP9V7kL5/a166SML0yjdX4gMXEperizngqdoow5t9+41M0P5MZlAxiAa/kMe+MjBEskj6FaWxeNWou8/g16D8iawwcRH52ZZX6dmWMqPjOIMoIWXDAtLCXiEcvu0PpvuxIz1laIXQkFYl+dQ5kdnm56JGHLyx7kqfrJinhuswZ3nPGprbsv7+9TTZUXC9Ozo1k1Cm5zkrn8H+aDRQqr0/tZfN69qXcBcqtAxsJNoPuOYfgA4XcbvNTpa6dg7a6lx2jYkWpjgBzAIGKvQ3EuCsiwriAgsXaKxJ9zuzIe/7Ez3dj5UWMOuYewQmCklmHLH3an5FonPj+EUQ2LDnBmzdoysESIjwt9OXvznNDiEvGoa+y7EvR0eRgghNKXPXA59
 TwXHondu
 Xxs/9qlaVUlt7Xl4kIYTIO8wmUNtaVro2JiYPhz2rvVU40q1RT5zzDuwhEmKmZM+ibkF1ptI7LY7AWt2Jmf1DFuGR4kAoFNM7pBH8fvQBFmBA2tgBG4IJpWfsCTKN+WsaAaEWlABUi1NWpGWtXiYoIaQumEVaIPthNETyRuZmXCTr6D6/rbwbBLjZLjobnAIbBWV7nqDVT+BFDaunuYbdhJ6dO6s+SRWwFASMfQYe+2w+3QU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The monitoring intervals auto-tuning feature of DAMON has proven to be
useful in multiple environments.  Add a new DAMON_RECLAIM parameter for
supporting the feature, and update the document for the new parameter.

Changes from RFC
- rfc link: https://lore.kernel.org/20260414052855.90123-1-sj@kernel.org
- Add notes about behavioral changes that introduced by the auto-tuning.

SeongJae Park (2):
  mm/damon/reclaim: add autotune_monitoring_intervals parameter
  Docs/admin-guide/mm/damon/reclaim: update for
    autotune_monitoring_intervals

 .../admin-guide/mm/damon/reclaim.rst          | 11 +++++++
 mm/damon/reclaim.c                            | 33 ++++++++++++++++---
 2 files changed, 39 insertions(+), 5 deletions(-)


base-commit: 061bdca57aa1fc22d0f74a7c7bd35c7576194484
-- 
2.47.3

