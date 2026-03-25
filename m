Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB4A1093163
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79C76B0088; Tue, 24 Mar 2026 21:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A966B0089; Tue, 24 Mar 2026 21:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940856B008A; Tue, 24 Mar 2026 21:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 874316B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:30:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20B13C22E4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:30:04 +0000 (UTC)
X-FDA: 84582854328.27.C3B75EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 93CA3A0007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:30:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a757H79L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774402202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvR4kmjBJCkzWid6bu6sc0JptSCoeAWKFX8ZKe34A2w=;
	b=0mc7ZZUb52OL9XZtvi+ke0kJdt8yybDvWK5deEMP+TqbsPrWdzdN559Kp8wLp7QBRjAsP1
	bgtuJcgdNrYBz+3rnOX+5Gb9Ancl+hV73jVUZudlC3fRGOi9FpGmCfuQ2gazBlg65B6Y89
	WINBfin+jLM6enex3u/Gop14fWZjKOM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774402202; a=rsa-sha256;
	cv=none;
	b=jBkYyUHDmG7x4+9g64ONkuizXqW7jxXedlVIncd/Ncvkt5JD/t70+pAZ036FmbhPMznP69
	4Xdk8nllzWhQ4b/G5/QPiutvhy6CeMq2Zfe7jil8lH50Fej2vTwE5qTh3bAnI/j4qLSyDy
	n3176EWmgle74oLIMEyEREyNVZInfgI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a757H79L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A2ED42DAD;
	Wed, 25 Mar 2026 01:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F3EC19424;
	Wed, 25 Mar 2026 01:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774402201;
	bh=5SbBFDgIR67bL1d5NEGk//PNELzmL89PM+jsBTcyznw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a757H79Li4IBGL1ALHzdgXLsUTHiTqglD9EdIalBAY+hP+BAUeddSjXsAlrkiFi13
	 EIggSReE8akulpv/CyWmPxpcf7tpSOkE+B1FP6fXiX9qUXTPSEzpb6GG/zIYhBdUq6
	 vNEFD2neVHf+Xl5mrjiJ+LZc5IlVzWIjNeKOxGGOJY9K8JvxYfPEBL/CqoIrgt3JT/
	 TwnAorebRYKCIOguye8khPH5fWqF7aD689ZtIJrnMjOy4Q4GYpSs9u/4Nam8dxtXMx
	 1JL7bErJSHbzRP1/zaNtgG1YFEL1qIxpAjf4GPM+BedeMPhk+L+oPO9Fpa+sIbinrD
	 ZXjDhTc7H5feQ==
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
Date: Tue, 24 Mar 2026 18:29:53 -0700
Message-ID: <20260325012954.85785-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6a07479d-0ddb-442e-bc1b-027f4c6d3b77@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 93CA3A0007
X-Stat-Signature: 7qejd43tfbifnoraghp1tgnwimj3awkm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774402202-520491
X-HE-Meta: U2FsdGVkX18jdz4snKJ6n3Fst0Fndi2cOgMJZAhDXO4X6nrbAICGo1Ckh29P8/NGRdkTFtGimhxEABEJNDNf88tRCdKL/lbhhhKK6tjRPafIrs40mbbVpCo8ibSZ3zDXwXw/Oap47SaLP6VYrQ7MArnaV3VZrrq5T8Cei0ocx9GdfcioQQeumgW00IsE5wdbb5x/THtLvU3XTtdwsZftERzMe/mJwDcubCVRedvWjS29AhgpW6DHNkTAB8FYkBJbCLPtU5a7gTPJdb0qNxfb8YJX/XnYZtnT3JeRcUAR+zRbX7t8TWrxPqtNTctlDBXXAdTtz/RZ7qiBo0oN1V0g+qdOzqE7646ypUOOn5PpCZ5qKqISVP8kfMNA4M0lmPeiRGBsioPgMXAQMYwXHJLI7c5N9Vtijs1Gax7YiwaiEuV48A11WUADyoKWIlDxTdqnSdHVcHc172WgLvlkI2yhghZGx7ULdsiBodLFuuC988w0Q5HTuOj5ivxyTr7fEBq6ew4afY6ACdiDLaZI9XN9xf/Sr+3gnTKQcxZrm+9lnafhNaFHBXms0+1RQKLTHMT32+boRaf9txtZkSG5HYVgv3yhYvKJ1I3+bPE2SqAfz/2//UNkI8gW91LkyHnbYfgR2J1bosZzU8jbgR/34o0BuW0liP1czanrqdo4zv4wWU3lHemiVTX2iXG/ABfUPaTvi9m56d9q0j7HAjssDtW3gI1tLkxShYLAnAXZY3giRaXleOrsMGg1qOk9V9k3UHyp+jjwzu6aMZtZTrf7EUQoQwKPyMIMKJVPUPYx0gjJ0wXss6iQtevk32nHVincVCiogLrfC+Jcx1pnW+X+w/Qs937xeIuqexm1Jp1ps3WCuKbxf5nR7wWfh6wiV5ECbJNJSAqhDtqNYy1jO4bJJdFBaNrr34nlh9bVD5SVSHcKo7o55E8ZBYau8d3o2KKq4ZxuYqISs6+FJfDyNpYIFjh
 Sm7q2p6t
 IB1nfsoOPQxTtMQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 18:01:23 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/24/2026 5:12 PM, SeongJae Park wrote:
> > On Tue, 24 Mar 2026 16:57:22 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >>
> >>
> >> On 3/24/2026 3:39 AM, SeongJae Park wrote:
> >>> Hello Asier,
> >>>
> >>> On Mon, 23 Mar 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>>
> >>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>>
> >>>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
> >>>> working, since it relies on hugepage_madvise to add a new slot. This
> >>>> slot should be picked up by khugepaged and eventually collapse (or
> >>>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
> >>>> enabled, khugepaged will not be working, and therefore no collapse
> >>>> will happen.
> >>>>
> >>>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
> >>>> the address range synchronously.
> >>>>
> >>>> This new action may be required to support autotuning with hugepage as
> >>>> a goal[1].
> >>>>
> >>>> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
> >>>>
> >>>> ---------
> >>>> Benchmarks:
> >>>>
> >>>> T n: THP never
> >>>> T m: THP madvise
> >>>> D h: DAMON action hugepage
> >>>> D c: DAMON action collapse
> >>>>
> >>>> +------------------+----------+----------+----------+
> >>>> |                  | T n, D h | T m, D h | T n, D c |
> >>>> +------------------+----------+----------+----------+
> >>>> | Total memory use | 2.07     | 2.09     | 2.07     |
> >>>> | Huge pages       | 0        | 1.3      | 1.25     |
> >>>> +------------------+----------+----------+----------+
> >>>
> >>> Thank you for sharing the benchmark results!  But, I'm having a hard time to
> >>> understand what this really means.  Could you please further clarify the setup
> >>> of the benchmarks and interpretation of the results?
> >> I will fix the cover in the next version, which I will submit soon.
> >>
> >> I tested the patch in a physical server with MariaDB 10.5. I run
> >> sysbench to load the server.
> >>
> >> I check 3 scenarios:
> >> - DAMON action hugepage for the database task, THP as never
> >> - DAMON action hugepage, THP madvise
> >> - DAMON action collapse, THP never
> >>
> >> I compared the memory consumption, both in overall in the server and
> >> anonymous huge page consumption. The results are in the table
> >>
> >> T n: THP never
> >> T m: THP madvise
> >> D h: DAMON action hugepage
> >> D c: DAMON action collapse
> > 
> > Thank you for sharing the details of the setup, Asier.
> > 
> >>
> >> +------------------+----------+----------+----------+
> >> |                  | T n, D h | T m, D h | T n, D c |
> >> +------------------+----------+----------+----------+
> >> | Total memory use | 2.07     | 2.09     | 2.07     |
> >> | Huge pages       | 0        | 1.3      | 1.25     |
> >> +------------------+----------+----------+----------+
> > 
> > Could you please further share interpretation of the results?  What these
> > results mean?  Does it show some benefit of DAMOS_COLLAPSE?
> 
> In the first row is the total memory consumption in GB by the server
> and in the second row the huge page consumption.
> 
> What this table shows is that DAMON action "hugepage" doesn't lead
> to any hugepage collapse unless THP is set to madvise. If DAMON
> action is set to "collapse", hugepage collapses happen, even when
> THP is disabled. The memory consumption for DAMON "collapse" is
> slightly lower than with "hugepage", since madvise applies to the
> entire server and other application may request to collapse pages
> through madvise.
> 
> Regarding the performance, I saw improvement from no hugepage at all
> to use of hugepages. No significant difference between "hugepage" and 
> "collapse" actions. I will have a look to the logs and publish it a bit
> later.

Makes sense, thank you for clarification Asier!

So this result shows the functionality well.  Meanwhile, it doesn't clearly
show performance gain.  Given the small size of the change and rationale of
MADV_COLLAPSE that I believe explored when it was introduced, I think this test
result is also good.  I wouldn't strongly require more tests for this patch.

That said, if you find some more interesting thing from logs, please share, by
or after the next version of this patch.


Thanks,
SJ

[...]

