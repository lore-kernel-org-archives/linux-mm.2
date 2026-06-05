Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3BACD6E6E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 00:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E435D6B0005; Thu,  4 Jun 2026 20:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF49C6B0088; Thu,  4 Jun 2026 20:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A1C6B008A; Thu,  4 Jun 2026 20:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC5C56B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:50:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21A511C1D5B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 00:50:30 +0000 (UTC)
X-FDA: 84844028220.13.E24636E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 80877140005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 00:50:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBZmZlfF;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780620628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDnCUPpoLZgUbgYz+bZGmLvJQT8tB7FcJjGeZKgm4hQ=;
	b=MPSQ8GPm9/yyVlXiptVylNM9qENqlVV39Qz3rwo8Pel654t6QiubWr1QXeYtZ+OapbhwAy
	JiXlDFO5rwYHUBA9vANO19VFFtu6rPs07IahrS4x8Kt3pm0vLyNxjhX421IXNeePy0cFhZ
	5hXp2UtmPLU3qb8GlGJGu1c06uJ3KdI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBZmZlfF;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780620628;
	b=SdnlDvP5XbSApSygT5slc1dA39DgM46ihXUOVSDvxCG5IFILEgzLpaQ/we0qR5+23VkZQT
	bPYz3LmRu8j5WLpcv8ARJ5F7NrXbtrloFB6ux+fw7p1V1RNeJSS+OeMnp6ASl6x52uhUXy
	opXrMzhyJQXX+0gLnlKSLQDLvoy7SKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5243407F7;
	Fri,  5 Jun 2026 00:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C300D1F00893;
	Fri,  5 Jun 2026 00:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780620627;
	bh=aDnCUPpoLZgUbgYz+bZGmLvJQT8tB7FcJjGeZKgm4hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBZmZlfFcoV0LGn8j1wV45Gn3eVLJ6bvQwvt+IS9VG7rciMqpnAoC7Kg2SZ0G2rCC
	 UCroVgi362p3I90GsFhaDMVYpimXF3S4M6LHiMR3Qtsxbfmd8ygLLJUDSh/gYLaL4u
	 qAB7TztmvRQLKRlcZfRkqX51ZwqDUahwK37FDMEG5APhffiWOXxpskdSgzi/OlIUWY
	 yvmqP7MRnyh0Fs3yDFc5SyCRnJ2WOzbD/MlDCZJ3emMFJtkyc+qzd7mwMJa1ZunB13
	 B0NOgBlhXzAjWEU28qhJnCCXeF7PG5CrzUjdhSLksQETqFNnHjI8FpATPkMpqLtDNr
	 O/hphuY/b4yLQ==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Thu,  4 Jun 2026 17:50:21 -0700
Message-ID: <20260605005023.82747-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604150338.501128-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80877140005
X-Stat-Signature: zmtjycw6hgx8f6d7bugcy1k8g7zxhhou
X-Rspam-User: 
X-HE-Tag: 1780620628-203115
X-HE-Meta: U2FsdGVkX19+NSE9p+FkQAILTFsBmaWgZNP9UsSgt9twpXioHkIza+aKuTmitDfNCh7YEau53weUS84tOn1r9Ujspy0OSifF4nf5YfffhSOzARQWWFxdM8ktSuFXILXKlEK2PcrUmi61V5ZFsDxzD2MVHBDfinSHGZ4aNCeCtc9UF9apT25YlXmKDlwWwqvMhQqoDHpUz1b+fy+PDO/mbT49KyiAxTbS+micJdMP/4hJkHGOSZPiRBMxaAiYd8EGMdHl6+d0btn3+q2FSJe61O0D5Hin/f4IG8jdQEbffZ998XMYJuDkR2poeyNN5AKAZZXAERWztKPYJhcgiEw2WzONCGRP6si/GUbXMdqHjJfAIJSNzcDtnouCAqrzUagRurJEWAjcjSgHvVO+4TW97W5IZsRtshP8q0Uyi23KV3c4+rBkHrYxr+Ky3OQY1R0GgRefE4oyxE2v/BEfX5mkr3d+rP451lB2ipqICKtXmI1UXU7CPSdPY7bazl8oAjAv5mTPQlNUE4HFMZrl2lwZM7z55aQ1RYYtVEwk6gpA/8laJtYuPD/9sQSciEEuL/Zv9jwKcC5d4nl079Wk5OZtPRf2mJTVIzSiw9SEzuEGf13rVJ7xIsCz8Lsgj2KrEg5/aa/wlRY1Yq1zXJ44L4ivsPtK400ceQ7J2UZpXeWdZtdXm2yAc5riM9UW9OuMAMoEbKktCBO4LMFaATd19T7qbfGsWHSwKlTPWR7ChGJSWnB5ErIr67gTkkcYyYuCjoTtSySfAHnrrwIwC6eIkO/DcEO2u63zEsZXYnlicAC6RhWtPiAKCPcpZB3be6mNkEfsrTQIijstF8COO2MbXl72MRkEXnADA24+uLEEZkaeCP/W7wizr/On1fU+vvTXwaxGozpxROWoLhiOHkCqtIGazU+LOOkUVPBRO+loDKskilwr2qDtnlFL4eRfa3W0itvo2AajAae0LDynOtnlf6u
 gY/o9I5X
 CkvY6rKDykf+i3E7PNC2EvD7YKHp4Bd+BdSHOrTEb/m7UfKoG1D3bFoGDHTPqPLt/7wHTwkObfBP+0jj6XTXRfVAQHkPaHlv2XM+Y+KKLK6D8onZWv6peaGfHudu1IwAeYFfOkxAYw36EvNtVvjluzSUzzcqDbUwGm9liwqu0Sbo84CeEECOU5lmOrvb0JLH7G9c/5KSk1xq/BT/CqYHnzaXFxU8JOaXx1qxcRdTCOAk3arhV2IfSh+6M1mZpW/AKOW0LYR3TRuWc7C5xUlxNS+mXKrWCNZMOvg3YmhEb+awO9LcAsh7bXcJg6UQ2h2SEVBmEf2QWk3mneqWeo78gpy36Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 15:03:35 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch adds a new function damon_modules_new_vaddr_ctx_target.
> Since ctx_target creation for vaddr and paddr is almost
> identical, the logic is extracted to a new function,
> damon_modules_new_ctx_target, and vaddr and paddr functions
> are left just as interfaces.
> 
> This change was suggested earlier1 and it is needed to allow
> developers to create DAMON modules that use DAMON_OPS_VADDR targets.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Suggested-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/modules-common.c | 31 +++++++++++++++++++++++++++----
>  mm/damon/modules-common.h |  3 +++
>  2 files changed, 30 insertions(+), 4 deletions(-)

This change is for the sample module that will be introduced by the third patch
of this series, right?

I'd like sample modules to be simple and completely isolated under sample/
directory.  Is this change really required for the sammple directory?  If not,
could we please drop this patch?


Thanks,
SJ

[...]

