Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC55F3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 19:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582966B00AC; Sun, 15 Mar 2026 15:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5064F6B00AD; Sun, 15 Mar 2026 15:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4082C6B00AE; Sun, 15 Mar 2026 15:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4F96B00AC
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:17:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC4AB160A76
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:17:51 +0000 (UTC)
X-FDA: 84549257142.21.F2E7E0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1624A40007
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:17:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZL/9PmUt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773602270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zEUl73+17GWUGQTskHOyT1n5Ecs+XHGE4gbng/Eh+I=;
	b=zsHw/Kaopan2s+wfRzTKk7sblc0da/3Ym3T436VDNMspWWzJCMkF6va9bhn86CTF+rP5uT
	0+XmUTLjSSBZttalK5WRJRjYfN0gMzMUDvK7/iSiOGBzFMjThVO8zQXvLTmuZGi8GDqL1b
	rlTCVcZEywKz3vzxIB6Q7RRsx3CknTM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZL/9PmUt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773602270; a=rsa-sha256;
	cv=none;
	b=MZ2zlSYGZDThikRG7j7y2knFUorhBjus7cBnRhDro8c22ZP+dWWm3Ztp4p3+nJa3MTGvMp
	rpXIVxnW/1O+FNwrmBK8p6vylLsbgGR51oOW9jllirusM+Y8KbUWsnXXcvOzD52hZRo6uD
	LxS9gecEBT8mIICW4+/Lj724kss49dw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C05924172F;
	Sun, 15 Mar 2026 19:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85299C4CEF7;
	Sun, 15 Mar 2026 19:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773602268;
	bh=lnmezolbS9hPqh6D5aE6eJP3t19p6P+GRKf1MW+dOjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZL/9PmUtoKntf0zCvjFDx8vgOM00T8LuhM3lw7fxsGtBty+RhVV6BFVhTn5CbwLW6
	 GNEkIFHzn8YIVi/EM8H5c+YTbMT6n81G/7v+Q8glLjiEDd2mPBYPrMXzDUUXTtk1EL
	 VlGaPoF3xHbrKkYQxsQjTobxdeQYmvVZXCsugB6HrJA4cSLA4O3KT/X6L85mBgDF9m
	 UG7UU8oqHu3HcYAxNLsLB2J6PMXEiTDoJHzXMnmmW8rcisnMlfWwoM/HDOxYN2wyxI
	 yTrh2nn3Iopxrokme22Re8eTwOPlRiHRhx4wVCSIXrm8BDftTskZM61yJVgxGdAOSq
	 rhkDx5DiQ12yA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon/stat: monitor all System RAM resources
Date: Sun, 15 Mar 2026 12:17:40 -0700
Message-ID: <20260315191741.88931-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315162717.80870-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1624A40007
X-Stat-Signature: eup53w997ajwnoe7ry7z7z6yzob5ctcn
X-Rspam-User: 
X-HE-Tag: 1773602269-977023
X-HE-Meta: U2FsdGVkX1/4m/Cq1YrGl7VyyiYnEv+96Q0JvuU9ACeB0RB1C2u/qENYoudpbYkWSmqvzxDkSFCHvv2eR6WPdymw14w7rx7kfWAHgY5OStSDjWiRo249+i8W8VjUOzwngRkr5PoILsqFiVxbtH9NrwiBJY4jQLkAyDm6mcnD5mdOChxjO0mVt7wiW2AP9chtwEVTfwwjYCN5wnb0k0Ik4IHZ0pNqnkn7FIn3nqtNPP6JJkObnGU2s6I4ZB+Z2RA62ncym3F6QDncXgFjIkqGZb/dx38ibID9o9hy19Yl/939gl7CA2hplhu0gTVdhATVPuwXtLIwu7/f1lXt8QLo2gVhfVL5eUnfCa+SDbycZ+7NcmqdszfMKeavUJ/IxIjHO/Xw/LZuCxlA4fwDUPFYHSdBGJtQLC1pPWriVciNA5yJBdPmkiCttMn2WoTmOGtToa0G6W2Spt04ZdIL8NlVScM3Cr307YLOvYsyzQ8e8QdgctHovcY96SZRrmtKlqQjApgV3Pe7oX93tAUBUO0YQHCsWw1Xc7aeFpquk5S0hwzEdamOOPr9zcRLdRy6q6tLe/ytZaN+IWUuK63HFj0X6cPUVE+GIefpTNbGVa/ru0PGa+0OZ8CwgJT+MGLLB7N5GgeCrLx08QXCVNMtZCDsOQaoTEvgQNokCJxDCPoaRDQ70y42QZdfVGnwr+IL6+kcL6lyyaT5h49oQ2s+FyN30ItyRAOomWF+zqgvmPWEGNe7OgHdVdjuwti/d9j+gHPKY0nB/mSvuGBCJ5d9AG717njVbCX4q+2qvHTs7APHNm6sC5uXQGZHwQExNm1v8MSdkqqyTmBki/3/3rcPBawUvcor3/ASDYHv1Wq3/Iqr4zqwrBiEh61dOGtkhKKH0zjrltWztOOhvLZLtZKPd/k8jV4EnxaK25KXrq7fQaOtSyQflDP2ToPHtyyejEmijGP1frmvk1VQsuAgduvdSdQ
 jnaLXHt5
 59pRU2cBj1WF8ZBpuQ+1C5WTNORk9jzW7DetZ2hSSaSG02Bcd8iHN8SqbzzArFZA2+xyFjK6Fl6qp+E5/EJd+XsPnh4JwcF13bJCNQfki1U/40gN4em907ERoWJWYaDrBE4X8R/y9MFipT6ZBYaghwgr2naRvsWU0Ya+ZnZmgRr46PDgxiBWAX9LwdeFzoX/oAlkDEhJ0E9za9QXh3+STYXmHcTcbdAP+U61XTzzsl18tlNbC3PyO91MItLJDbjP6pSfvNdKCbvs6ctrPg9/DvvsrXtkFbcMZZxGh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 09:27:15 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
> says it monitors the system's entire physical memory.  But, it is
> monitoring only the biggest System RAM resource of the system.  When
> there are multiple System RAM resources, this results in monitoring only
> an unexpectedly small fraction of the physical memory.  For example,
> suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
> 500 GiB System RAM resources in order on the physical address space.
> DAMON_STAT will monitor only the first 500 GiB System RAM.  This
> situation is particularly common on NUMA systems.
> 
> Select a physical address range that covers all System RAM areas of the
> system, to fix this issue and make it work as documented.

sashiko.dev adds [1] below comment:

'''
Does this single bounding box incorrectly include unpopulated address gaps
between discrete System RAM resources?

On systems with non-contiguous physical memory, such as NUMA architectures,
there can be massive physical address gaps between memory nodes. By coalescing
all resources into a single addr_range and passing nr_ranges = 1 to
damon_set_regions(), DAMON treats these unpopulated gaps as part of the
monitored memory.

This appears to artificially inflate total_sz in
damon_stat_set_idletime_percentiles(), where the gap could completely
dominate the distribution and skew the percentiles to report that nearly
100% of memory is permanently idle.

Could this also wildly inflate estimated_memory_bandwidth in
damon_stat_set_estimated_memory_bandwidth() if an adaptive DAMON region
bridges valid RAM and a physical gap? The size (r->ar.end - r->ar.start)
would be massively inflated and multiplied by nr_accesses.

Would it be better to collect all discrete System RAM resources into an
array of struct damon_addr_range and pass them to damon_set_regions() using
the actual number of ranges?
'''

My answer is no.  It is an intended behavior and no negative impact is
expected.  I think the reason is in the patch description.  If any human needs
more clarifications about this, please let me know.

[1] https://sashiko.dev/#/patchset/20260315162717.80870-1-sj@kernel.org


Thanks,
SJ

[...]

