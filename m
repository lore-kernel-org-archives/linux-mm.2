Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD5EC5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C33F6B007B; Mon, 10 Aug 2026 14:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374B66B008A; Mon, 10 Aug 2026 14:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B046B008C; Mon, 10 Aug 2026 14:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 046C76B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:47:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87D07140260
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:47:53 +0000 (UTC)
X-FDA: 85086244026.29.9D8B3F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 15AFA4000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:47:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FDk/wa2h";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786387671;
	b=2P+n+RDt5eV3eNYKFocxsDKkxBYReys6tdjS7h4IiPfNCMy/93MlUSsPNZZ7cOmPqRlZOR
	w2CqKeIIbDkcMw7mKL+nWwNzkplDLQFxa4+GfHvKCtimgpVskOsh7sDS9rFtGX0zs6Emga
	XcDXiJKgH90OXn0ic9QjPBm+7HH2BZ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FDk/wa2h";
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786387671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0w728h8icPOZezsigPZsZBoOdqBJYx/Mg08jfuV+mUI=;
	b=KYQah6xTIOfPl4z5umhk7HtsJWeC8Fi5466QRWOTCjOa6ztrnrZFTrwkoWNg8OTAJwL0Mf
	/Jwf2Q0Oj55GQQy8NxM4xvGO7HcNtCBfyh/P6tRGEJ+tOZHNasznEUQYBZnmJYziLaxovR
	O+XEnKevEBLEbTaOPkfgMR3a2t0T9K4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BC99600AD;
	Mon, 10 Aug 2026 18:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB311F000E9;
	Mon, 10 Aug 2026 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786387670;
	bh=0w728h8icPOZezsigPZsZBoOdqBJYx/Mg08jfuV+mUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FDk/wa2hVQ/aXEiG+6BYcDeC2PkXBp/oq1Hl3vZgWrWjAynskGBSByAmCfYlitZpA
	 k0iI11PAv+AHVT9ktIXKr7OaS1cGfEO8M/YDq6W4CEUMCPAYr6ftCNr3Uf0Tzoy7Xy
	 7A6st2itWvV6nwfwlseYaZ80VwbdgFy5GYhZLeo0=
Date: Mon, 10 Aug 2026 11:47:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Guopeng Zhang
 <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Message-Id: <20260810114749.368140ad5be4fa10085bbee0@linux-foundation.org>
In-Reply-To: <20260810074247.52747-1-guopeng.zhang@linux.dev>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 15AFA4000A
X-Stat-Signature: nznxjw4dehpaoog1inezu8ifkfdhujpy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786387670-186674
X-HE-Meta: U2FsdGVkX1/WnsYUjCTak2UZ+hm44/E7Tactrs4G/ufLPOjVU3pgz+sn5fr/uvbeaYBe/FHaBfhi1RLf6pUh9qtyzIY98bShoMlqnZZkSgjwny4QJ5sU8mzRzur+mIgCdkV2XC8DAvp8nHV4i+mqJzMB/cVwEQhDOqejb2yItvptSHQnwgZ3N2XYShRLGK9iJFmikEQAlo8f2AOLzTKs8C5umBPTHZWBmA49u6qKy5tl2Lc8wZp3vcrzPtdDzl9NSEXYNUp/WrlB0Xp/8kd4Uqkb1aTs84uhx12PeG0uMcSp/7p2XUvHOd8M/IyRq2+oN2BXq42CvY3Fm8ZTuDOTG/f57/3mTiALlbkRqRoU5sTJrXqCYJ15YDQ/3tFfI/zdtOidchUfTNV7zirt6ONxoSNfwTnRpdd42PFsSAN9QAqYkaWFqEAhuQFX4F2n3DFVCv7SMcnJ0lWMzjDFXKP1pT8jYYP67xvIFQxnkYynUymDRELfkR6N4VOLzKf7coljLSMeg9yikbRVlJOvHicLa7GsuuXcjxeprWa3Cmzi5o1J9JyK/tj+7+6PxgHeffAdppbPvTcRmtgm8uaxw5or2Tm0nOLf+AW4rZhRksoCWFWzmqdCuODDXL2iNVI0VcGy3oEcPVZBol0BJSWKvq+OrK7R/WcZf52jV2PhsT9bcnelLU6wfFmbvtLeIZxIItSEXeDyiTf55IVOyClWNWPb+QlSe5NPEgaBEwTz677RAdGO2jLpa8LsIUKvj+OhtZffR1xjJL8S4iUoaXV/71hVEOwpyFc0oQifElfehBgvNEFxdVPgok0XWZw2UwM51yG82Qpr3k2XzQhV7STZJdy4P/PQmLxCBDrWTD5OFspylgDwndnZmXjK2wJiZVtmmEOyQ/ZQz1W64wSQqXUaoY9iIHWQlsWzsKCO0g620iymRzJNvmT676d7zOLdebl0a7aeUNGe8WpYaXHqrcir5BA
 ONN69HGK
 uszarspLxighDdtXAMl9rKNsj4NUwAl/6ASnubgNjdW4k7tcstqFd+lFEhIExt1Qg7MejQTAON9nmOa5Ep97s0qukoBKLyQ2cBcijigiCL0AVQg9xuzSDE3F4BQMSBukEjBFkwFLaQnBtHajnQlipvbBubTlCrTbsg8mjO7wFu75FOBuNt3jUD00cDRrYbjxnyEAeMRi7pXwlr3YViItZSLg9vO1DqKZHfevAkLnmTBuYPWF600qiDdOANsy+MgySciizG4DbNBvz9008HqOZk21f2e0V/xusfCkpVy1I9JSpiggMiogICR98ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 15:42:47 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:

> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. Enable failcnt accounting for the v1 memsw counter.
> 
> Reproducer:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.

Thanks.  Nice changelog.

> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")

I'll add cc:stable to this.

AI review thinks that memcg->tcpmem.track_failcnt should receive the
same treatment:

	https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev

