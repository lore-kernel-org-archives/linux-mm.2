Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9D73606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atekYO+Z
Received: by kanga.kvack.org (Postfix)
	id 2CCF66B05BA; Tue, 10 Nov 2026 15:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DD86B05BB; Tue, 10 Nov 2026 15:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB386B05BC; Tue, 10 Nov 2026 15:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87C66B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:56:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FC70140109
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:42 +0000 (UTC)
X-FDA: 85420418244.28.732F1D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3382A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:56:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atekYO+Z;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=us/QUix5NS1vMxZ95eCg/3xrin+gjpoie7qQGaNW81o=;
	b=qQJ70DlhHQlz26d5F+e/cLeFgHlaMbB8B0gPsWVBB01CgJAR1dFS9RKQ6/tXS6JQNNKWB7
	xo7hKvaweETFydOtRZ3jhqg73THMM0wtqBz2bwn1pGYRMyA8jK53jazd0nG3oTDn9bSN86
	Iu69JtV91ojzrbWFGFOTjougyJfmdfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344201;
	b=RupWFD3CIrza3FgZPaNL9oqlxkercHsrPr7gcK5sB0D0207uV0U3v0muM5Ri4tup7bqtZ7
	0UC6tRXt5JQ6nnm/KZk/ynonnKGOp9IYMH9ge9vzacc0cv1K/gbxXX73VS1qaNElg69l3/
	uD8O1mwJkYacpehf0bVCfBMc2R8YreA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atekYO+Z;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A63E43C31;
	Tue, 10 Nov 2026 20:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A201F008A1;
	Tue, 10 Nov 2026 20:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344200;
	bh=us/QUix5NS1vMxZ95eCg/3xrin+gjpoie7qQGaNW81o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=atekYO+Zzto6OFwqsPBfWMn3kn5QaG4Z1k8V//4R4Odoz5R5yHsbyPLGbgdfu1rRF
	 86Dr0RmZMY95NzlxKdusVb71RogaLTXxusxen6iuQEmeAOg2fG54VCzy5uZuK9dItw
	 yJgXxlQPPXNQ54Gvk2EkmTjvf5LsFKgJrgo5zZRM8QULA5k88HD9rV1IOwA8/sIzOJ
	 cxPlrooUTHtPD6xX/lr17Uf5YDqZPN1YZ/akjFsJSt7Gg+rNWJsHXHvcqizPO9rLh4
	 druWXqhD8fQIQsgkekTDuC996ycwQFvBS/Zh8YTUe0CmF81RDccpjRzm2GgzFmaxcx
	 EjXymvB6TD7Eg==
Message-ID: <sashiko-outbox-207745@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/15] mm/mglru: lift youngest gen protection for
 higher priority
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261110202025.25736-9-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
 <20261110202025.25736-9-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:56:36 +0000
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4cnmemp7gxu6igpbmwk9we4r6czz5a8g
X-Rspamd-Queue-Id: E3382A0005
X-Rspam-User: 
X-HE-Tag: 1794344200-63294
X-HE-Meta: U2FsdGVkX1805u2PNRxpb29co9Ln4fMXJ5AQXT0JbAizHOeWR+Z80ONHL62TK68NtiHLnSQKOs4uPHhaoqHsSAeuT3OC3FQlCXg9R2FV0tBQnMtjSQTu6xB6TFqM7rfYSYrNuE6hP9ynNvhEjcTvxVvpHb8cUtxThE4dEYbyX9/IpZ4d9empA6QFNv0vKDX4MAKrljzzZiSYxtz4sxIknl2m+5cfFH1PzCwbAk16Izjd8CgJOb3/W2h6KrPIIPBDkpIBMAU1ltCBav+jCUBOJpHYt8rNz5FzFE5YvcpS0VUTIBI+QtP3LgwCyZgA5O7ri/Ex3VISlVJLh452wQwtipD+yYXDDMsY4740WRb8jGlmNpwm/NDNumF7miHCM2vfiarCNzWwu3SHHmXQE1gjnnT+XyXItSLs5XcRQ42wxnfWiHzVXDjfUuCi2MAfPYu5lgyWikufw3IraHmUyhXnsKhzfy5eYZVp2h+rS5Fxp+1zwQaXq0udYl9DBRUjO0+4XKXN9zt3bPQ8nyBQqXtLYtC14T5Sz4RVLOC547l56Qy7AdX3qiR2qlZefjw8+p1ssejr/6CODPbPtFNPH792lVEXJq+vgOXXSj8dNGWII81RPWVhLPOLOtQALQ7Z/di3HsSX3OmOGzqIkscVuBWA24nQY6/fkjhSHNOlg1/Vwk8mcISJSfHDVDlk+cAS3tJ92h3vvxWrHd+JliejY/CkS9tkm+drXaIVGQW4nySAyzdPfjjqLkYVgw+VUnmNGyoDe0RzrYAM4uh+FCowLnXfKnF3VZpDXzXNJZ1aSlYjOWCqrDVb6UaZt/hdtlKqqCmZsvySSxQDxVOSp2Ng4eGDoZngec1ooGnDaQQAnRY7fwFmAC/QrDNgyZJv5dH8Q1PgUHoJySB++zPL+ZQjJOO71PFgAZkLo2086QCtMgzHwloZb+HOF8tqRiMuBCc5GYuqc0YmFZQA+G7w/McAymR
 H1TtvXl0
 THhK2sjrJgwiEJ38OYYzo+Gf9dUYpn6e8Jn5dtAzlvyP2FJtAJe/l0Lu6WNDalb712ivPHm5N/V6lGBN27Z6ccub+rSTIk1JtW2ilipejmlnzhGJdNuIox5ZpmzoV9GpoIC2hrrVlKVXcSCFUNgJu75Cs9O/eygafCJNpY0n1FM1LJaOQZ0/vfwASIllIR/0egkADMt+8sOdGHAHutw+aTc2kJIZlFPXtcojT6gTv2iS337eQM/YF9WSjSiMNwhSWkN24rG7R/aH+iAJ+POiatXEwJV8hiJDvq+QtHqlVjygcv6vIzEvUdwAgw2o7mNCC754HV3WY9stEzcxsYJ7z4YET+iG3Nd91lnMWpxoq8crFkEZQgI5EvveIVhsVp5tzg0Q+AJ36E0kJdstAtgeHnA46DkyO852SySJ7lrgiN3mER0TIh9mlbT+oSKV8Go0MKYCC08qJTM8cG4yeq1vIXVOlieufAGZYgroaaIaIeb4fzofLvsbSVP6URzZUCNSWr6GbFsXQrrxc+jzULmdf2c8p9z6x55h6HuO5azlLCpPzCGAX96pt/hCCv6vWevVTI6ge4sTo8idMjo/8jZZVN52FbOpZgLHuMc7uqROV8PrwzoJEjkEO+5zNKs0bX41x3jzx33kCnsIZeDAiZRzMZA+cMAkbobmWLL6Vc1UMtL82Qe6P3ZY9kXBIgw5ZD5pOmFmkRp8woaflUUF13+PVksLdsjowtJG5QS4s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/mglru: unfilled commit placeholder and stale description in
  changelog
--

commit 357b36306d9c0f7d5cb9a3bda097730f4118d2a4
Author: Kairui Song <kasong@tencent.com>

mm/mglru: lift youngest gen protection for higher priority

This commit adjusts the upper generation bound in scan_folios() based on
reclaim priority so that the youngest generation is only scanned when
sc->priority drops to or below DEF_PRIORITY / 2.

> The problem is when aging can't catch up with reclaimer, reclaimers will
> all abort early seeing there is only empty gens, or only two gens left.
> Proactive aging won't help eigher because there will be limited threads
> doing aging, but there could be unlimited threads doing reclaim, which
> is a fundommental limitation of MGLRU. One way to avoid this is to use a
> aging lock, like in commit .... However, aging lock caused several
> jitter when under huge pressure, and was reported to be causing
> obserable lags already on Android.
>
> What's more, the gen model somehow contradicts with the goal of
> swappiness, which aim to reduce IO cost instead of following hotness
> blindly.
>
> So instead, let's lift the protection based on priority. With default
> priority, we still fully respect the MIN_NR_GEN protection. But as the
> priority raised, allow it to reclaim younger gens step by step.

[Severity: Low]
Does the commit message match what this patch changes relative to earlier
commit "mm/mglru: lift the forced protection of reclaimer" in the series?

That earlier patch already removed the MIN_NR_GENS early return and allowed
non-default priorities to scan up to lrugen->max_seq, whereas this patch
restricts sc->priority > DEF_PRIORITY / 2 to lrugen->max_seq - 1 (and sets
DEF_PRIORITY to lrugen->max_seq - MIN_NR_GENS) to keep protecting the
youngest generation until severe pressure.  Also, the second paragraph has =
an
unfilled "like in commit ...." placeholder and a few typos ("eigher",
"fundommental", "obserable").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.2573=
6-1-baohua@kernel.org?part=3D8

