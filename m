Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110EDF54ABA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797BD6B0088; Tue, 24 Mar 2026 10:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EBC6B0089; Tue, 24 Mar 2026 10:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685026B008C; Tue, 24 Mar 2026 10:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55A2F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:13:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF2B7161BE0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:13:04 +0000 (UTC)
X-FDA: 84581148288.05.248F567
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 327E2C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:13:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hp6Wdyut;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774361583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieDpOKVhAe4pkUbjK8jU2NwRAkEXujQ2SrjVR5izplQ=;
	b=GF1/J0KX3i199311nwHV8gxBas6I1d2/2EQqxUmWa74RhnccKb5hOSb+WDha1D4fQY2bA9
	WWj1FREpoyjBVigt+Ywv3eI3aXHKnD/e/qWETrfaezuWOCoo+oqww1gTUNzgTx36qaR0rB
	mztSZsKNH1IVWP6WXMCTc3/OTbJREQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774361583; a=rsa-sha256;
	cv=none;
	b=ZjJkPkes4yQj+ohbedTqPw+Q2P3CjzpxzKWZg3lKbjTxmxvM0hTkbz2QTCR4CJ/m19h8YD
	aqw7feKcq+ImCc4Rm0bZ3x0tlXtj0WvZdUWrHb4EI82VlPSZpYRsXZlP2VGFSvzKyU2U4z
	wl5bXbWEoqvMGMrfHTWo6WT4WDDwtHQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hp6Wdyut;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E74D600AC;
	Tue, 24 Mar 2026 14:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B455CC19424;
	Tue, 24 Mar 2026 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774361582;
	bh=R67EKc7NRuD/wiIvZo05R08AzOlBa2CEd878B2zKNJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp6WdyutUOSgeEyipB4ayrX4y+JtZtuf1cYBQ5b0ClfwmzI86AbGagTkwWRMEsrWE
	 /6vxU9HL20Hseu/i8XL4QDSwzAAxoayBk2+1Qfu7c98uT+UdDro+AgVlRLNg1d5bF4
	 1gnU5Oa2yyQxPnXXOgMt7qQcTp75OxPhiaMlPPf1F7tavd7gw2G7x/spb+xjnJsqBH
	 mKokgkgFuqN3tVwRwWrcJGlVO7+OU4v27VoIS11WaxhnH6/bTnyPMq3GL85Sdt9jPm
	 1W8+Bd655SEQM/i9UhhHes1p+kAPh8c8B9hu7h4p9yjR/wCHVr5NRRQCuKTDspzPIv
	 eUSlRU2KkDLNQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] This patch set introces a new action: DAMOS_COLLAPSE.
Date: Tue, 24 Mar 2026 07:12:57 -0700
Message-ID: <20260324141257.91322-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <48580762-eec3-49b6-b17a-59fa486bebec@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 327E2C000C
X-Stat-Signature: np7rx6med1fuft5o4zsew3xsjxq5u67y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774361583-869122
X-HE-Meta: U2FsdGVkX1+zDb48HLrMiSbxvVLGj+TBOf26kQOAy4Cp4NmxHO5/N9U0usKc//P8a/+KhCz1pGRmbVWKpEdzpFkPdUR5c3VTFoXiTPF7UPxAR5qSHTCrI5FLRtdB4WmfPuv0Eu/dFLjgNf/l5uRCPxyqcbskZ7YBapmx0tMyyvClKNeX/K+5FxF8pXpE0ejvMsf2KrDTejqDR9YMfBF/170jdygxW62te7SvEtsPzHnv4X2Ud2sidlTpxDmzrJO0W2raDEuR0+cj+ZAkQZ9R37d4uamdOd4aQylAOQ5EU3VX6pjza8aSnEDKQjpgQQNChhNBfCwJKE8pRQLcHcMEDNA9BL5Wi5QMIrzuhiUPkrLY/WCBPJ/4y6rC35gQ/ABBWvFFI0EXkxGCZ0m+owcq2wb+keFi+LxWm9N7nA1ne8fzbLDYgXgrvYBvlP7xOH/hpOIG4gq3RATzCPo5aYbniCxubsUlNhyGj1F1PAg4c/PKi1/wQsaO+3U5pYpjnIKjhBAv96gaHEzjbst0Mi8pgXRf4Adw6r02f0RopkBVBDt4kdxYOI05BrK9dPFjHY5L5m7XhvxLfJTV86lrPJgDTPm19NHOFAOhQhEh1y7EQAX7ad1OfftplfW9UVeb8UY8hKxKKC/nMZ1kVpY40p6OJTQGLvR2rLhdDkpOkO1OBHSMEZI1ddnJ6AQDQ0Y8fWZD4nTu6oWwiISr7AL5tfth6OrcavbCN7KxHd33/26Ak7GQlkiEVNdITBmpPWb/dxG86tfmsYTfTxdka1dJbsRW/LJea1bcbJnVEuq3KtWkXA4Tw3HEIGO1Uq/KZB70FMrQldqlBmN3A9F9EgBwwKulkRvc5SYTLbWNeQU5Wf7AyNJ5tFYwcrF72jQN3auHnDdkKfzT0iVlrjP3K81c0qpFnJp+UjQYj6SrqzYtTPDTsUwfhcwt4mTYh5MzUxwFPRZ+CiA6stkzI03o7XspPMu
 BbAftEoK
 koXndKLa5xWUfLsc362Nc5DBuk1Dn5JDbeCwAw5ykWul/fyIq+1N3632taQek8ortB7bG2FHgq9U/wa6yoobyWi8lY/0yd/ZdpFrwEVeP18nGpdDWv4qXfsPnx4qbKaYFQqT3UR/ngzVcRNeq7kfE9xEOO3I8aPiwnFcTt3Nb/BQcV8bH67Xk14ED0tvBkwKWq2QO8uiQN3/0FI3EPQkHGB5fXoS0kB5FyEVryyO5xHzlUDZH/LPL55++SlYE39J6n4QifTjO3A7pjRpK52NG8Izpfc7XMaYXrrDhSzDvXGzwMJ5EN6zcFvQLbQzorbq7uhjOHCtHMtsoT9hNSICMoRLk/BgkMJuSL5sFJmmBO0JOcDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 16:57:22 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/24/2026 3:39 AM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > On Mon, 23 Mar 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
> >> working, since it relies on hugepage_madvise to add a new slot. This
> >> slot should be picked up by khugepaged and eventually collapse (or
> >> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
> >> enabled, khugepaged will not be working, and therefore no collapse
> >> will happen.
> >>
> >> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
> >> the address range synchronously.
> >>
> >> This new action may be required to support autotuning with hugepage as
> >> a goal[1].
> >>
> >> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
> >>
> >> ---------
> >> Benchmarks:
> >>
> >> T n: THP never
> >> T m: THP madvise
> >> D h: DAMON action hugepage
> >> D c: DAMON action collapse
> >>
> >> +------------------+----------+----------+----------+
> >> |                  | T n, D h | T m, D h | T n, D c |
> >> +------------------+----------+----------+----------+
> >> | Total memory use | 2.07     | 2.09     | 2.07     |
> >> | Huge pages       | 0        | 1.3      | 1.25     |
> >> +------------------+----------+----------+----------+
> > 
> > Thank you for sharing the benchmark results!  But, I'm having a hard time to
> > understand what this really means.  Could you please further clarify the setup
> > of the benchmarks and interpretation of the results?
> I will fix the cover in the next version, which I will submit soon.
> 
> I tested the patch in a physical server with MariaDB 10.5. I run
> sysbench to load the server.
> 
> I check 3 scenarios:
> - DAMON action hugepage for the database task, THP as never
> - DAMON action hugepage, THP madvise
> - DAMON action collapse, THP never
> 
> I compared the memory consumption, both in overall in the server and
> anonymous huge page consumption. The results are in the table
> 
> T n: THP never
> T m: THP madvise
> D h: DAMON action hugepage
> D c: DAMON action collapse

Thank you for sharing the details of the setup, Asier.

> 
> +------------------+----------+----------+----------+
> |                  | T n, D h | T m, D h | T n, D c |
> +------------------+----------+----------+----------+
> | Total memory use | 2.07     | 2.09     | 2.07     |
> | Huge pages       | 0        | 1.3      | 1.25     |
> +------------------+----------+----------+----------+

Could you please further share interpretation of the results?  What these
results mean?  Does it show some benefit of DAMOS_COLLAPSE?

Also, how is the performance?  Does it show some difference?

> > 
> >>
> >> Changes
> >> ---------
> >> v1-v2:
> >> Added benchmarks
> >> Added damos_filter_type documentation for new action to fix kernel-doc
> > 
> > Please add Changelog on the commentary section [1].  Also, please consider
> > adding links to previous versions.
> > 
> >>
> >> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >> ---
> >>  Documentation/mm/damon/design.rst      |  4 ++++
> >>  include/linux/damon.h                  |  2 ++
> >>  mm/damon/sysfs-schemes.c               |  4 ++++
> >>  mm/damon/vaddr.c                       |  3 +++
> >>  tools/testing/selftests/damon/sysfs.py | 11 ++++++-----
> >>  5 files changed, 19 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> >> index 838b14d22519..405142641e55 100644
> >> --- a/Documentation/mm/damon/design.rst
> >> +++ b/Documentation/mm/damon/design.rst
> >> @@ -467,6 +467,10 @@ that supports each action are as below.
> >>     Supported by ``vaddr`` and ``fvaddr`` operations set. When
> >>     TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
> >>     fail.
> >> + - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
> >> +   Supported by ``vaddr`` and ``fvaddr`` operations set. When
> >> +   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
> >> +   fail.
> >>   - ``lru_prio``: Prioritize the region on its LRU lists.
> >>     Supported by ``paddr`` operations set.
> >>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
> >> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >> index d9a3babbafc1..6941113968ec 100644
> >> --- a/include/linux/damon.h
> >> +++ b/include/linux/damon.h
> >> @@ -121,6 +121,7 @@ struct damon_target {
> >>   * @DAMOS_PAGEOUT:	Reclaim the region.
> >>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
> >>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
> >> + * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
> >>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
> >>   * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
> >>   * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
> >> @@ -140,6 +141,7 @@ enum damos_action {
> >>  	DAMOS_PAGEOUT,
> >>  	DAMOS_HUGEPAGE,
> >>  	DAMOS_NOHUGEPAGE,
> >> +	DAMOS_COLLAPSE,
> >>  	DAMOS_LRU_PRIO,
> >>  	DAMOS_LRU_DEPRIO,
> >>  	DAMOS_MIGRATE_HOT,
> >> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> >> index 5186966dafb3..aa08a8f885fb 100644
> >> --- a/mm/damon/sysfs-schemes.c
> >> +++ b/mm/damon/sysfs-schemes.c
> >> @@ -2041,6 +2041,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
> >>  		.action = DAMOS_NOHUGEPAGE,
> >>  		.name = "nohugepage",
> >>  	},
> >> +	{
> >> +		.action = DAMOS_COLLAPSE,
> >> +		.name = "collapse",
> >> +	},
> >>  	{
> >>  		.action = DAMOS_LRU_PRIO,
> >>  		.name = "lru_prio",
> >> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> >> index b069dbc7e3d2..dd5f2d7027ac 100644
> >> --- a/mm/damon/vaddr.c
> >> +++ b/mm/damon/vaddr.c
> >> @@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
> >>  	case DAMOS_NOHUGEPAGE:
> >>  		madv_action = MADV_NOHUGEPAGE;
> >>  		break;
> >> +	case DAMOS_COLLAPSE:
> >> +		madv_action = MADV_COLLAPSE;
> >> +		break;
> >>  	case DAMOS_MIGRATE_HOT:
> >>  	case DAMOS_MIGRATE_COLD:
> >>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
> >> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> >> index 3aa5c91548a5..c6476e63f4fb 100755
> >> --- a/tools/testing/selftests/damon/sysfs.py
> >> +++ b/tools/testing/selftests/damon/sysfs.py
> >> @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
> >>              'pageout': 2,
> >>              'hugepage': 3,
> >>              'nohugeapge': 4,
> >> -            'lru_prio': 5,
> >> -            'lru_deprio': 6,
> >> -            'migrate_hot': 7,
> >> -            'migrate_cold': 8,
> >> -            'stat': 9,
> >> +            'collapse': 5
> > 
> > Comman is missed?
> > 
> >> +            'lru_prio': 6,
> >> +            'lru_deprio': 7,
> >> +            'migrate_hot': 8,
> >> +            'migrate_cold': 9,
> >> +            'stat': 10,
> >>              }
> >>      assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
> >>      assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
> >> -- 
> >> 2.43.0
> > 
> > Other than the selftest part, code looks good.  Please consider dropping RFC
> > tag from the next spin.  Clarifying more details about the test would be
> > helpful, though.
> > 
> > [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> > 
> > 
> > Thanks,
> > SJ
> > 
> 
> SJ, should I remove the RFC tag for the next version?

If you feel comfortable with it, please do so.


Thanks,
SJ

[...]

