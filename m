Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C031C44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 01:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F316B008C; Mon, 20 Jul 2026 21:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210F86B0092; Mon, 20 Jul 2026 21:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8896B0093; Mon, 20 Jul 2026 21:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC69E6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:08:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31203A037F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:08:20 +0000 (UTC)
X-FDA: 85010997960.02.5A95154
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8098AA000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:08:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1NNnxX3;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784596098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPEDa4y7YnsA2DDrvJuGMFg2pO2MLhdYW/8sh9nMWJQ=;
	b=Va8bND/ygYcCVNsh2SIBcRN20v0p3T1t1UUY6c7jFQUQukwK9BGTv8yBYCclx0RsTmk9IE
	pq3ww8DGAQK75UQwctn61N2d8u/uVZCkZouYHpK7LP/8wLX1n2+8RU9uisGfbLT/szYf9z
	Xp4miASpU/90ZfsoPLfmz4qwO2b24Vw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784596098;
	b=Ja+jI0AgPyOVOrAf0AfQUPImSW0ELCM/StMuniQKXNCH+EIJPfqZ1x3Oo9b9HPbTtEcJ0g
	e2teV+YiB98RYpETd16uNVM3tsixr3f+mrMaFJgqR5yHR+NlxneQVenJW+dUaxj6Y+O99G
	qtjnyvRCeUaHiSHe+9q5WrfO7QrB/VU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1NNnxX3;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D5B943EF5;
	Tue, 21 Jul 2026 01:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1A51F000E9;
	Tue, 21 Jul 2026 01:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784596097;
	bh=iPEDa4y7YnsA2DDrvJuGMFg2pO2MLhdYW/8sh9nMWJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1NNnxX3MNIsRMp9h2f/ABJG909Ow/nvUnsD0tLSYs3Ys3DsVuIEyb2CfvEQ8/Qf9
	 RdKg+Yr1domo41jagvZyZv+mQJgE2yoGx5M/z2j+py6spDZa0PTp7GOvyGcrAJsyry
	 tgxurD/LqwM6fdWZ9LFbFEE2mlDeKHo6fg4IWzLnqPWp3jSldd4L+N2xPAHDSpHAaM
	 MJCOYun6XBmj1zcoIPsCtj2sYrh5mCjZkGlyc/Xw24f7QeQ0gK0zEmlC1WHDH4bTpT
	 xjzxgEoRQDm9kzqX6hcIXizxuK//2wV4MHAdleIa51Nm46CFqU4kcKqx2glJfQpk+q
	 CeqmG4UbOIm9w==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 18:08:12 -0700
Message-ID: <20260721010813.94016-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720030327.80153-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7hmwz5xxjzckps8b4dhsuoybg7g5c4xm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8098AA000C
X-HE-Tag: 1784596098-809586
X-HE-Meta: U2FsdGVkX1/+vHvWwrx2A+Lro1ltaHZ4jcGMBQIvabFp+i5F/doP3E70PqC8S/hkhL6QcpRmADj32C7Z9Ou+IcaO8t5yWQ3d1th3vObJFkqh5/lMuRb6OZcc8tEZVm1k7rMx16g7wFhz/ePXG5kjvLtOe/UPpO8Vc1VtgMxADkCkA6IFj5K6LsPrHS7el2Ybop8UY+PaCp2YsKRlGMpfSgbhOwSf+/pjCMW2jjmM5QHCQR9R43d/gIBXS9P+vXiNEzpa+SZ0L/iCjviBSXWGJSvQcE4xE/1pRMwegHO/ULXaG8mMluYNOMCU/AGyLylHwLLMW4fWFi8Ehvc9w1BhQf0ybmOI3uiC9A2wj2mt9xdRV120agllM8CNrrUQcrdh01Lkrff1jns+/nWfrtDxw012OoBOE47QFTXfGW0gf04f6L3IvKPTvFP6d5Q0ddJlBLWrWy/RFcOahNDaV/6dfL4hbSgV2zd0W1ackZx5VRXfo7Xj2LBnIh0MUIc0IMGeiGAhmWcB6yNlYB4xsUgx4tLIXvuRDhTJofE0rg8XpHXFIoa7Y/S6XlhjzqrHLD6r8UXYBdN0mVZn2fiJMgO5//jRG5nKrjMkcH02heO2BMXMQDN6sk1frh5iLtqncNCFk1/h68+eLNpo/Ioae7afJCOXNFYvI/UJPEG5WYgE7JO/1U8/Om7xhPMINAfgtzMxwm2mniIi+NH5Atpgak8bDdlvc6HfZwCXdclM20hxPv0xEn5Bbo8fOP2pP0ZDx92EM++mdmVOSTdxtkLY1rVkRbxkS+yVEZzUaEXNLbbfSsaEMSaCpCPlkIBhV29nRqKGf6gZ2Ori0SB2uLefcGlpkJrSGoSrk2iAh5+hTfh27/t4dC5E02h5IoJXydSSLiVnubujaQJbAx1ZIn5zo29R+58hW3Wz3daRyrzRAPKShgdQNoExPq6os1qoVs/RL06Bb7rCHtmdEKbvPmYe//k
 JEWfcUAj
 u7iIpizdXFWONw2yOT8duIu6SblphKkyuBtfSWL17QO4pkIdOiXPvcY+x5FqsUxFfQZL+elgsSaGHjyiLjwmp3uB+mPd9/BdwAbL+zDvBD4scNgSmvLbcMOE9caR8nXQjNDMr6sFCoGrrxdOJidHth8e6mgHrccdxJnf24R4NP62Z72Y9JRopkn8+VkiHOGvKkBef/D3D1QvLVGawjXT5w1b79lwON5ghHkxw2O/yM6Fk3f7J7k9iRWRcifCHE5AiBDp1f6YshHb95prwuTtQp/P4aCQVSSswdYB3smJzxI2Rhzg6pvvTzLGzh4d7fpJE32FAfOXOCEyT7jjsCWSjLHcdZl8Bs073Y1j63+Qu6tHX7GAWJlDlr/d7Apg0bN3RRbzDpkyW78r8+TEmv4FyQP+sjgES4g04ihK0rb+RoTW/o5c7i5+csSu9ymAUhYEIxV/m+BNkXSw+uHlYXyhstWyvnM5uxFQG+hNorzIex3p97D0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You were warned at not Cc-ing THP developers in the previous revision, since it
was modifying THP source code.  Since this version is modifying only DAMON
source code, you don't really need to Cc more than DAMON developers.  Asking
wider inputs is good practice.  And it worked very well.  We got great inputs
from Asier, David and Zi.  But some people don't really like having too much
mails in their inbox.  My personal rule of thumb is just running
get_maintainer.pl via 'hkml patch format' [1].  You must have your own rule,
though :)

On Mon, 20 Jul 2026 11:03:24 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> DAMOS_SPLIT splits large folios in a target region down to a
> configured target order, using the existing split_folio_to_order().
> No new core-mm code or exported symbols are introduced.

The last sentence may better to go to changelog.  If you want to highlight, you
can put changelog at the top of the cover letter.

> 
> Based on mm-unstable at 61cccb8363fc ("mm/swap, PM: hibernate:
> atomically replace hibernation pin").

This is also not feasible to be the cover letter main content.

> 
> Different addresses within a PMD-mapped folio resolve to the same
> PMD Accessed bit.  Accesses to a small part of the folio can
> therefore coarsen DAMON's observed hot set relative to the actual
> working set.
> 
> DAMOS already provides promotion actions (HUGEPAGE, COLLAPSE) but
> has no corresponding demotion action.  DAMOS_SPLIT fills this gap.
> It is a mechanism, not a policy -- it does not decide which folios
> to split.  Selection is left to DAMON's existing access patterns,
> filters, and future probe/PMU signals.

As I commented to the previous version [2], this sounds like you are saying two
very different things.  Monitoring quality degradation issue and better THP
handling of DAMOS.  This makes understanding the motivation of this series
difficult, as other people also pointed out.

Based on your replies to others, now I understand you are proposing DAMOS_SPLIT
as a way for improving the monitoring results.  I'm waiting for your more
clarification of the issue, to better assess if this makes sense or not, as I
commented on the reply to Zi's reply.

> 
> target_order selects the split target: 0 for order-0 base pages,
> or a supported smaller mTHP order.  Both anonymous and file-backed
> folios are supported.  The locking follows split_huge_pages_in_pid()
> in mm/huge_memory.c.
> 
> Tests
> =====
> 
> damos_split.py (VM + Kunpeng 920):
>   anon THP -> order-0 split: PASS
> 
> sangfor_exp.py (Kunpeng 920, tmpfs, 4096 MiB):
> 
>   - Created a 4 GiB PMD-mapped tmpfs workload.
>   - Applied DAMOS_SPLIT with target_order=0.
>   - ShmemPmdMapped dropped from 4194304 KiB to 0 in every round.
>   - Repeated for five rounds without functional failures.
> 
> The functional selftest (damos_split.py) is included in this series.
> Additional experiment scripts and raw results are available on
> request.  Performance characterization using masim [1] and KMB [2]
> is in progress.

It is completely fine to keep having tests in progress.  But, please make the
story complete.  What damos_split.py and sangfor_exp.py do?  What the results
mean?  What the performance tests will do with what expectation?

> 
> [1] https://github.com/sjp38/masim
> [2] https://gitee.com/OpenCloudOS/kernel-multi-bench
> 
> Open questions
> ==============
> 
> - Selection policy: this series keeps folio selection outside the
>   action and relies on DAMOS access patterns, filters, and quotas.
>   Is this the appropriate layering for future probe-based signals?

You mentioned this series is for monitoring quality improvement.  If so,
shouldn't you just apply it to all THPs, regardless of the access pattern?  I'm
again being confused.  More clarification of the motivation would be useful.

> 
> - Hysteresis: khugepaged may re-collapse a just-split folio.
>   Should cooldown live in DAMON policy or khugepaged?

Ditto.

> 
> - File-backed folios: adjust target_order upward to filesystem
>   minimum, or keep current "fail and skip"?

I don't fully understand the question.  Could you please elaborate more?

> 
> Beyond the action API itself, feedback on real workloads that need
> proactive large-folio demotion is particularly welcome.  Follow-up
> work will evaluate candidate selection signals, including DAMON
> probes and hardware-assisted sampling, as well as target-order
> selection and split/collapse hysteresis.  Those policies are
> intentionally kept outside this series.

You mentioned this work is for monitoring quality improvement.  Now you are
saying somewhat followup.  I'm again being confused.

> 
> Changes since v2 [3]
> ====================
> 
> - Split-only series (collapse deferred).
> - Dropped SPE feedback (mechanism/policy separation).
> - DAMOS_MTHP_SPLIT -> DAMOS_SPLIT.
> - order field in existing union (no struct size increase).
> - Added functional selftest (damos_split.py).
> - checkpatch: 0 errors, 0 warnings.
> 
> [3] https://lore.kernel.org/20260701123000.00000-1-lianux.mm@gmail.com/
> 
> Lian Wang (Processmission) (3):
>   mm/damon: introduce DAMOS_SPLIT action
>   mm/damon/vaddr: implement DAMOS_SPLIT handler
>   selftests/damon: add functional test for DAMOS_SPLIT
> 
>  .../ABI/testing/sysfs-kernel-mm-damon         |  7 ++
>  Documentation/mm/damon/design.rst             |  5 +
>  include/linux/damon.h                         | 15 ++-
>  mm/damon/core.c                               |  2 +
>  mm/damon/sysfs-schemes.c                      | 48 +++++++
>  mm/damon/vaddr.c                              | 90 +++++++++++++
>  tools/testing/selftests/damon/Makefile        |  1 +
>  tools/testing/selftests/damon/_damon_sysfs.py |  9 +-
>  tools/testing/selftests/damon/damos_split.py  | 99 +++++++++++++++
>  tools/testing/selftests/damon/sysfs.py        | 11 +-
>  10 files changed, 279 insertions(+), 8 deletions(-)

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches
[2] https://lore.kernel.org/20260702183551.91007-1-sj@kernel.org


Thanks,
SJ

