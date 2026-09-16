Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14F0C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BE86B0088; Tue, 15 Sep 2026 20:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74366B008C; Tue, 15 Sep 2026 20:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7F46B0092; Tue, 15 Sep 2026 20:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4256B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:58:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 277BB8059B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:58:25 +0000 (UTC)
X-FDA: 85217814570.27.310609A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 70BE1140002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:58:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvauvRPr;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789520303;
	b=YeBIA0EWeY5qP960/zInguVdz87lHfdglfckxZsmkHL+EUArNoUfHLJF+4BxwjwQjgNlQv
	xnBXnhx4aAwsLYcJo0bype1BcE+NsQJCe9Ql8poP8t57HWb4Pq351/+3Cisr3aDgwbmPUY
	lGJg24UrWd6ABV3PEIlUH9kKkU5LOP4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvauvRPr;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789520303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwdyHdv4MnQJM3h6YHH803Ox/K0l+mlSFgFkCNPYbYY=;
	b=PGsOBiDWwO8VcLi1zkskThBfNgD3wVCamTxcPBJ2hldFMxrGEBFVwATpQiT9m+rvGWYcbL
	FsjdWSMcvWWKBJznwyK5u0WwE5J+MxZYdMwcB3HOziM+Skg5Y/Ozbbdy7kO4U5srGgCn1w
	adLc+uPDNmG+meMVXDVHWword5LB7VQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0CE742DB8;
	Wed, 16 Sep 2026 00:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6871F000FF;
	Wed, 16 Sep 2026 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789520302;
	bh=KwdyHdv4MnQJM3h6YHH803Ox/K0l+mlSFgFkCNPYbYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvauvRPrJvajpFZpLH57aY0fnKI0MrpEwDocwhlvNxlhitzUAEG1AjRQF0oH+wQP3
	 MWU2ycopmmE5EBaM4XTUqnGWsFjLOqf+TsnyvgN5qRbDYOFIjm7YZEy5auL/3ITcd7
	 Cu38tdUCRb2G7X4lhYdowX2GKEUyB9YQCltLSkoWHfX2fQlUdvuoMz+7FLJkF8TCuT
	 gXFljaNWwWacPpijchGAOBJWwo0Q0CIZOn2hjPgAQoD55QTWOU8Ef1CUAy+gUp/YeF
	 WoVLeKCl1I9WTmtZMO9ac0uuFVwyUiRjbBn9MMpbA67DsdNCOxmnEQiTF3HiMeR5YN
	 zUFWdJBywhiyA==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports
Date: Tue, 15 Sep 2026 17:58:09 -0700
Message-ID: <20260916005810.101606-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915025514.2434-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70BE1140002
X-Stat-Signature: x4dyjsdqyjagaw9hrz7tzboe8qaokp48
X-Rspam-User: 
X-HE-Tag: 1789520303-296740
X-HE-Meta: U2FsdGVkX1/++j6cUk+BlhcrfBoSvyaskuSvPROzRsXwu3sfom2O25GvkL8zCQP5xvsTD7y2o2CRU4KK4rcbcWH9IfA/Yq8X855/3gHxXAbdo653r2BJ0I6eqACX82Er8LKEJncCrqzhVLTA448MXZMN1MlbyODZZI8gpetKgEOjtJM6WyH+2S7p9Xp7AfyIFC5/IdAABZ5sCmt8MbrFaX2GTq5e3qET8CAAGPJPzf7C8fgpRD/FbTp8VAS4sIBBaDrSqygLMM+7eOOaWxM1PhGg/faocIeRsoT/a18Qb8tbOR3M4z1eSJJ24DCLvNTZUBIhqLIhVWYHszc/e+mpZ2Err5q9waH09EAsxLVEDOXUYcfIH9fwb0e2aKI9hPqeCmYlBB2nOPIqCl9ynxQyN5sdn0jKwCJeebn+g0sEQKI9Gx5j+IQYcz3NCoapH2Svloh1x7bekXXTux8wnSF9yHYOxvdrUD4dvvPUXbKUmpyrrEBkdisFJnATmDiJ2qopQeb9awlbgc6SZPsD3cMRR1YfH73/ZNzAKF3Fd0zBKxZM1PFGKS+2zaI+laOnU59G/qEWQHakm4BJ0XcnTuZiNR+nWdC5aYde/9YoHAl3LDon8b4sB7n9fnFyvUWKnrB/4PGREoesMcmfzY51XoPhYstHUF+xbUJpIHOPZj3GL2f98vPa9+0gZOs0r/DAhfQTNvTOfDA18pFavX9cbtls1e6Dh5n2YQVdCvTJq34LiXltPcssDsfv6kx1GfuqgGYl2G6aNmhYPyDnO/EOKtrUjxhO5LoP7jeUeozBCS47ddGLw5rPkR9pa4tHv73fN1TclUaRf+ZgE9JhPo/annX8wlLrHFa1N5djdlka3gxB6gIi9ggbAvhAd8r8hgaxIi1LcP6d0yOUbsmOjYftnG5N0yLTnNx1/sNBnXTY5FDCEiIJLaB6HnIU9JFeXXFpyz9W3R8Z4Pmv/thnoWxaUOt
 fwstHQrk
 RxycYUJhqaP2uQ0FcR5qHZ9lEZT/ienBrPS5ZeqO1vswwHDrF/RGTSEDK6OZoBk/fXkZNtHiNKgip29GH0Xy1aPUwGU+KbMJs/lX64nXS3Vgvnl6n49eRXA/zOImmE8HkqF6+JrMbRf3LIwjQk5K7L7ZtTGLgeOFCTuDlZJIXB5xEQOjpZPvWNEbrwBCTBDcdDIAyWPq/uUtDS1rw//u4C86lRFYEpbxWD1McK0L2VwdRWwj2XOZr2WzIpB9HaxalEp5Z3B+bi9khYXb7Q/t55hwKNqKQg/dcIL448hwlnDmDBNe8RL3Ab1u6wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lian,

On Tue, 15 Sep 2026 10:54:51 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
> 
> Hi Ravi and SJ,
> 
> Thank you for sharing this work.  The report path looks potentially useful
> for a DAMON observation-granularity problem that we are investigating.
> 
> The scenario originated from an issue reported by SXF, and we are planning to
> share and discuss it at LPC.  We have now reproduced the underlying observation
> difference on both a local PC and an x86 server.  The server run below is our
> larger, controlled reproduction.
> 
> Our test monitors a QEMU process whose guest memory is backed by a shared
> tmpfs file.  The guest repeatedly writes one 4 KiB page in every 2 MiB range
> of a resident 48 GiB data set.  The unique 4 KiB spatial coverage of one sweep
> is about 96 MiB, or 0.195% of that data set.
> 
> Using vaddr DAMON with a 500 ms sampling interval, 20 second aggregation
> interval, and 500--2000 regions, two opposite-order runs reported a mean hot
> ratio of 1.751% without shmem PMD mappings and 75.836% with them.  A control
> that writes the full 2 MiB ranges reported 75.366% with PMD mappings.  Hence,
> in this workload the current observation does not distinguish spatially sparse
> 4 KiB activity from dense activity once the large mappings are present.

The observation makes sense.  However, does the sparse access pattern
realistic?  If so, what is the purpose or expected benefit of using huge page
for workloads having such access pattern?

> 
> We are testing existing DAMON strategy mitigations first.  As a next step, we
> plan to replay recorded access addresses through the report/probe decision
> path, independently of a live PMU, and check whether DAMOS can distinguish the
> sparse and dense cases.  In that experiment, raw report frequency and unique
> 4 KiB spatial coverage will remain separate quantities; lack of reports will
> remain unknown when source coverage or loss is insufficient.
> 
> If the report evidence makes the decision reliable, the response we want to
> evaluate is an internal, bounded PMD mapping demotion (splitting the mapping
> while retaining the underlying THP folio), rather than exposing physical folio
> split as a DAMOS action.  We will first keep the response stat-only and archive
> the would-act ranges.  After the replay result is repeatable, we can replace
> the replay producer with an appropriate hardware source and share the results.

I'm not very sure if this is the right direction.  PMD mapping demotion sounds
like you just don't want to use huge pages.  If so, you could disable huge
pages.  Answers to my above questions would be helpful for me.

> 
> This seems like a useful consumer experiment for the report interface, even if
> the vaddr and optimized transport parts belong to the later phase.  Please let
> us know if this direction conflicts with the intended report semantics.

I believe this doesn't conflict with the project, though.  Nevertheless,
technically speaking, it is not the report semantics.  Reporting allows any
information to be reported.  Page faults like information could be coarse
grained, same to the current page table accessed-bit based one.  Only finer
grained access primitive reports, like those from perf events, would increase
the accuracy for the sparse access pattern monitoring.

Whether sparse access pattern is realistic and using huge pages on systems
having such access pattern makes sense are different questions, though.

> 
> We will share the strategy, replay, and mapping-decision results once they are
> repeatable.  We are also reviewing and testing this series, and will follow up
> with the appropriate tag(s) for the exact revision if that work justifies them.

Looking forward to!  Nonetheless, it would better to make sure we are on the
same page for the above questions before digging deeper, in my humble opinion.


Thanks,
SJ

[...]

