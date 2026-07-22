Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9162FC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5530F6B009B; Wed, 22 Jul 2026 10:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5299A6B009D; Wed, 22 Jul 2026 10:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46ADF6B009E; Wed, 22 Jul 2026 10:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2493D6B009B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABE3B140186
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:09:12 +0000 (UTC)
X-FDA: 85016594544.13.55A2CC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 158C24000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:09:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cz3kRrJ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MwsIFMPOJLP1rXOSs1f475mi2DZhSqUvSoRoP3+rwqc=;
	b=PSZxmUAFmJCOn+Ua9aisM5IsWErS4/k9au+FeKhPQPhBU+OwmELJi5zgrjuE4140sAYPKf
	WPCOtW/V0387k1w/4Usvv04kpD12rUmclxGNH6eZSenQiWQOGV83uRNpczGCHFbrPeFAq8
	Ru257yaFfzQX4n3zXIluQQB19Os3CgM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cz3kRrJ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729351;
	b=x46RiJ9wE95Zc5byL+KS1K0ddA/pkDNTN5xOXPquxGoo8MF0mtEDXqqW8s1JE7ChoTE8d/
	39x6yBFu/FlmOTTZTFSfLz3ddtjJtc1H/Tg6/FuBlKrPY1PjsieY5VTUv7qEjYzIJV/5Tx
	KtcR59tJexL+iau+EWpP5n6ZugtfPz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B08143A2D;
	Wed, 22 Jul 2026 14:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA9D1F000E9;
	Wed, 22 Jul 2026 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784729350;
	bh=MwsIFMPOJLP1rXOSs1f475mi2DZhSqUvSoRoP3+rwqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cz3kRrJ5L4WG+dsZ+kik0DlXJpH65xVvgsOF+JCN8tD7d33O1FbXzElMu/VMvV7V5
	 lqdD2NpqJb1hOzQupLGwkEOR7SfVQCqHO0ciaj06RB43MXjeJ7QcjsaZCfpVtU/Wam
	 /Kob4qnZLcz3AfKgyzKozC/nK0peFQH8O2F3n97cKz4fgxJNoYQ9ySz4IJ8zRullM3
	 zQDx69g0ss6vLPehobv/FOQnloBwFsXn20qoN/Hp3V7WBH4tqGjSsPD0AVy3SfTW7/
	 idqTQTzSQ4s4w8Wjlp3sa37hXxEYMB9th0MnCd84vVT8ssaTURvsel0+ZggC45iYK/
	 /WksPR1d/8IeA==
From: SJ Park <sj@kernel.org>
To: Cheng-Han Wu <hank20010209@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH 0/2] mm/damon/core: remove unused helper functions
Date: Wed, 22 Jul 2026 07:09:01 -0700
Message-ID: <20260722140901.91476-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722113338.302603-1-hank20010209@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 158C24000B
X-Rspam-User: 
X-Stat-Signature: 7j14rwjh57prdg1hrrf3u9d9x77ggwss
X-HE-Tag: 1784729350-560326
X-HE-Meta: U2FsdGVkX1+zPRBONIhs8ZPTL21auNH8Jst6NYyoEBiVlxepnT6LJYk0tX5kATQ/4y/6cLZGo7Eh70Kgkpel/QpIiCWNLUb3KCxBOjRKvH7X/vdlSb/DKunAnvHko/FhRXRsOsLTj6xCwr1Mf032odX+gUCv97mPuNFkvP+h/hFmHztxNA7VeLJPqy1diKplvIaVqr7EgcWc2QbtAiyx7KS3n4t69rnD+cCdh3yjyPnan/2P0/+DFr0wOQrZvLSRICiE70Pm8ZT75BzKOjaNIAhBAP1JibkAmc3jtB5NOY9+s4jiILFStu6kAywWdu7h/A3lCth+s051WDnRzKWh+LQHZzLCykJmwVus96JHhv1IGejDfnaWpU8ljKnni6jX+3EDlKOXvgiqGZ9WdM90m+Fk5gnYV2PsKHs4GBGsYVhOwCMZzh9RYwY5iYPcWiajDAmaTho8p6TRuFGgymZAJcZxuXOytHDhnPwBWIH5bsH77s91MpKU8NxIp0sfPDGoOyDNW0OncU6FmDK3gRi3a49vDC90lo2d/YJ6u67XVKf8r0BKGZfi66oTQFgc9H7FMKIUeL3S0hz8mdNwMkVT1AW8ni/41+b7/+Ky3R9GRqGbiv481Oax3ZpBKDI+AuPC3ye8xGNLP8O7uCKoSi9FOs9T4lFVFvhSYM2oEE6JagZ8koGJei1bfcx5CxZ8nn+Ooa9m042Tcv8HAhE6PYv3SlL1J3HRY4ilz6RRqsBTOHjujyZfWtZYkWwk30+eKlrDbAwQLyk5JWNcDR5xhkVA32AFehKAW0kgE5p22swqbaLpR8b1GgRk9GDBQZmPPFFUAAowQrtyUCZLrRELPaYYkaWFgVkwXh2KVXcPfmpnoEJCnM5+kS/QEuf/NBEjpk5mFAxmizQ22+ktDkHdMlCGVFRi+lui9dtnfYYSTDCcVfxcdWEzCMyDS5GJRA7HCxO+35o0px9zyI6v5caBWoE
 1uiL167c
 5poFpsCUjZaut+CWWgUD+a+XBZ8N9pAgkLGBtwfWiTFdNVCB/jGBl89WiM3/t9PKAub8Nirl2q9AXgtX45OD/xJegOOAQ1r+dL/ZG6gMahfi87+rrFm4J+i+EKe9Wc2RwK5QfAT3DE9S+v3oK1uClPoUqmB2r4uh5nCaohfKQMXn048tHZ11hfKqUfzUfpS8efnwMitThiiWvDo0FgiR0zWFFWJi4ISUPSfAFDD7Dy8QPFgjOjFCaY13Znd9b4FYB0cvG0iL2XwFKenQBbdayUTqXzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 19:33:36 +0800 Cheng-Han Wu <hank20010209@gmail.com> wrote:

> Both damon_targets_empty() and damon_nr_running_ctxs() have had no
> in-tree users since commit 5ec4333b1967 ("mm/damon: remove DAMON
> debugfs interface") removed their remaining callers.
> 
> Remove the unused declarations and definitions.
> 
> Tested with:
>   make O=../linux-build-mm W=1 mm/damon

Nice catch and cleanup, thnk you!


I applied  this patch to damon/next [1] tree.  We are now quite close to next
merge window.  We (mm community) want to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this series is not really urgent.
Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
will request adding this to mm.git after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

