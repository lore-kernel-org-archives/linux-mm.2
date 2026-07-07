Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C81C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51626B00AD; Tue,  7 Jul 2026 10:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29366B00B4; Tue,  7 Jul 2026 10:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9666B6B00B6; Tue,  7 Jul 2026 10:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA976B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:02:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF1591A0482
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:02:12 +0000 (UTC)
X-FDA: 84962144904.24.E74057C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1B4C120016
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:02:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFz4ruk4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDE86xd7OeBvi8ecp4Qortake90i1hEVi4Wnjvs+Q8I=;
	b=GRep7HkpNu4YvNbOixLgreHHNosm1q3UihBLniXPJMHaHpj26hjaKPJsAhjgaYgcOXDbmQ
	3gnkGypezI0rdaJN+kPlVGvgCtwCMZE5rBAyc0CDZc9HhX7Hj/F8Bsc44ETBhbj4kE3Olk
	e+BESxKvfvNklPtSfpi/l+HVsOW0AVA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFz4ruk4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432931;
	b=x1ji9rK8kfo55oWg6/ArL8R9J0UVddcTdp3NYb4LXm7NTcvlQ2ayGeDOU1xYMAK96Tu3EJ
	qBzfVHso6eakTr/2EzrAB/H5xPYYliqyCtss6qke3jH41cj4a+GtB+g5uM9WA2hnkLeqf/
	2gPquWMNG0e5ITBGJKCE45FWOnLPIis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0717943F94;
	Tue,  7 Jul 2026 14:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9B51F00A3D;
	Tue,  7 Jul 2026 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432929;
	bh=hDE86xd7OeBvi8ecp4Qortake90i1hEVi4Wnjvs+Q8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WFz4ruk4piV93ZQ4huC8JBMurPzadbXIBA3gZMf2h/UfrQ4PUYGgpDnNOitfoHnKy
	 0IZaX2o0UZyAEAxtFfUhnvFIi4FsKUROzE1lupgV3Xj7A47Am/9RghcUHL2LugTY9V
	 WR7LvrHSyxKxnf/hstrjZDunmuOMpChsRYmgCsgF4VtbvdfF5elrqe84hVLUK1o0ms
	 tGlKWLJB29JeE1NBWoexrOV8H+9Pzla6PHoExwJuDV0gorXz8Nhj28PewUDMX2aWVJ
	 ANs0Yih2cYD24DRXIpDLbNbd2kDtAvdXs40dbU3RiYtHdrmMrxzVT7hXZXEWgeOApQ
	 XOv7H6rcmxNdg==
Date: Tue, 7 Jul 2026 15:01:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, npache@redhat.com, 
	rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Message-ID: <ak0FtLIlTyCo_8lB@lucifer>
References: <20260707135255.292870-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707135255.292870-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F1B4C120016
X-Stat-Signature: gigo8q697cckn7xn14r3aeurr3tnom6a
X-Rspam-User: 
X-HE-Tag: 1783432930-209227
X-HE-Meta: U2FsdGVkX19it4d1z1SbBfSVzwHdA3cFUXIQXhL2t644SOyhtYkjGZm+hFIrNc2q8BqHtsd1R1iexp6YxkrDyVCw6cc6QpmjoXp1FPeUZWBo4fOv0oXNINsLOtQMsYQtvqQVxZvmpOBR3S1KHdPVZ614KEw54EV3G+U5vHEmJoEGvV5Qg+iG18m82iJovghdqZAxwHgRYkFhOTh4zY7eXPDaD8SJmx8yit9f7IktZvzpYdlvm2tH7fvPJmrFoDt+CuOfRpQnUzUeZjT1M59k/MW89PJV49xv/2LaUmKozK1VBxBvoloaO0wRPwo/bRdaNvhvYW7L0hutleofFL19Zz3l2hSp5jrnhuOtPAzZdIahtzXsoDoCLs+t6xBURD1q+1q2hckjhcCZGTFQmo/gj2dyP+EsLCJkT2D4kuCmkt14RuIyu6hpK6TGK/9mHIwYfilZBvzvfQ/9WXnzwbCpXRQTMxdz8jf6wx/BD6Z2ngSgaSSZlyTdogGNcIpdn0ZDiWXQNrtm3NyRAJUnb4btKZRmBbp9YCkB9TpSrVSTjRzXQV6GvK+N4mtk0WkHHoeoecYKEhJtON+tCMLTly8izkmD9uMoscdSSBs0MAt1ruyruaMxzE7v0w+GFPM0KxIVvu4eTupinvjVrWctElvTlWKgjIBsuiL0L+iUQctV4jEL/inpacjAIJ9ZPzXigklkn096uC7OpqscrI1ysNBvhwK0gdUEffBSNkCe8nvZKDHk5/+iY3KS9DnYHHD35fVLGwPM7rE8rUBlz/XVtEEZlBxw9QSVStfvyWihstv3gpYVZt6Uk8DXgGQhfBt81BE8hr84ZekWCPRNLK6jXnyDfXowqlGOkA6DU7WsB1cJQCFbCud6XCZd/6i/5dWBlw//m9fnXGsKVSnEes+uEsCitBShggVcA+F1t6Vqqvxcali7aw6d/XCCs8pps1LfmWlRc/OUajJzXDkW82pYT3f
 Mn7j4Kej
 o0Gp2z5FI3IV5gnHsSTdDGtzEYSBT2q9IPua1GPJtDJ9YMOJ9k09mr8+8CU/j0Pb6WUvCxnZTImThY/UOIk2x7FaDS4CyC42z7tsaKADA0X8iWbwQbDALK1RPvIBoGvNCYQd9xLWLARJ5jRnQKY2XhEKWnBwLbfbHWrfWKqJ1L1tVieEJvOH4+tfzFuontyUisR+fRTO5zvDSR3a6g3XNTn5FZi/J0V96HPnC3sJo5XPgMyNN6O5YsWvNL8drrgOR7dIaLkF9omKLhSpo0SqBuBriAq5/tDo4zEJVpWXEXT2dJNqL/U/oILqvq3j1upRTN3xn+/Tvh8EhDNYQMC9FvheB+3XuMvPUrxrFQCfqYHB3ee+M/aB9UrZ8yntnoF6L+4JI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Balbir

Thanks for the series!

I think Balbir should be cc'd no?

On Tue, Jul 07, 2026 at 06:45:06AM -0700, Usama Arif wrote:
> Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
> to PMD operations") a PMD may hold a device-private swap entry whenever
> an HMM-based GPU driver migrates an anonymous THP folio to device memory
> via migrate_vma_pages().
>
> pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
> for any non-present, non-none huge PMD), so several MM walk callbacks
> that used to assume present THP or migration entry are now reachable with
> a device-private PMD. The results range from a VM_BUG_ON() firing on debug
> kernels, to an oops on a bogus vmemmap dereference, to silently isolating
> an unrelated live folio from LRU in the aliasing case.
>
> The first 2 fixes were reported as pre-existing issues by sashiko in my
> PMD swap entry series [1]. Hopefully sashiko won't point these out
> in the next PMD swap entry series :)

Yeah I don't love these 'existing problem' reports (distracting from other work,
add workload, really it feels like that should be a passive reporting mode for
sashiko not arbitrarily added to other series), but sending it as a separate
series is indeed the right way :)

These of course should never block an unrelated series.

>
> [1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6

Hmm we've had a whole host of issues with device-private PMDs recently.

Balbir - would it be possible to audit all of the code paths and proactively see
if there's anything else that could hit problems here?

>
> Usama Arif (3):
>   mm/mempolicy: skip device-private PMDs when queueing folios
>   mm/madvise: skip device-private PMDs in cold and pageout walks
>   mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
>
>  mm/huge_memory.c | 3 +++
>  mm/madvise.c     | 3 +++
>  mm/mempolicy.c   | 2 ++
>  3 files changed, 8 insertions(+)
>
> --
> 2.53.0-Meta
>

Cheers, Lorenzo

