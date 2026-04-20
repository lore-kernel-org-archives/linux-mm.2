Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23643F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A526B0005; Mon, 20 Apr 2026 08:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C0C6B0089; Mon, 20 Apr 2026 08:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A506B0098; Mon, 20 Apr 2026 08:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 629336B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:59:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10726BB874
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:59:59 +0000 (UTC)
X-FDA: 84678941718.24.DA9F918
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 012B840010
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:59:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MQoIeY4X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689997; a=rsa-sha256;
	cv=none;
	b=O3XHp180ZQQLFfcColz46XxGl1Rg8mKuyR102Vc/K2EHLUXNYmnCY/3nusGfq96LbhDFtA
	DOkZgzOoQkZPZYH5n7KHZwPEmIye6uW8Ntf9Q2T657948/XLXzlsqxenRux0gjfvMkllzu
	eeRWGfZ0trJAu4TSNmF2NX15emHLh1E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MQoIeY4X;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOUWkybK3eiKfeEN3c1AmWJrSYfchS2TwUw3TqjAFDY=;
	b=QzfmnE4esStQunkVwZsrLMPACWCIV/dv+oXQ8a9Q86E4tcHKWhIbVtUsLGqKkjkis3UPDS
	J9nUrWEPzHEBhfU+7+oL544KS5J/r6QoznkXmPxhKaDW8BuuDNv8meA15ypiMQUP83IiP3
	AduC20btLTdphwhQSzz20ZLUtw4JqYo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776689994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mOUWkybK3eiKfeEN3c1AmWJrSYfchS2TwUw3TqjAFDY=;
	b=MQoIeY4X5Tdero87dcxHKdE+OYa7VsCpsSJjLcOM1TCiKHbDh2FyVtVy84CraYpnnMGluW
	ZfgNtlHxHkCKuP9jHjbWOg4ofUkXfWnsh0dP28SEBEzGOYxol1VVySbGKw1K914r6bLOAU
	OF1M4yVsHuKD6orXWNTNGxPdZWj6LnE=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 01/13] mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Mon, 20 Apr 2026 05:59:42 -0700
Message-ID: <20260420125943.3443828-1-usama.arif@linux.dev>
In-Reply-To: <20260419185750.260784-2-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 012B840010
X-Rspamd-Server: rspam12
X-Stat-Signature: p4r8jdtpeuq6jiguyz3ucsa7narctrqz
X-Rspam-User: 
X-HE-Tag: 1776689996-121107
X-HE-Meta: U2FsdGVkX192HqZgKGH1dCo6InebCb7QFyRAD1XToc+s1ilSFO+FprcpeK1WHfMNd6euSvtOpwP3N7N/FE9NTaQD7e7pW2nAg33eI2oj60/uzYTuZBp9dLBlQPvHb4/GRSVXzD1Zu/3DlOZpBwa5iOnwQxlH6taa7HNjHHJx3kX9FXvJfoFd1mAXWUBBEVui2oohf2lt+HfNTvZNTE5JaHugHVd52ybMIKO8yGqfi6fpPMMDYuPhhyD1v88Z9jMephKmKSxVzzN5hR/D0kIYQJCDY33Kiug7J99tL/X5yQ85nhFR7voEhyNETlcwJfGASuFVsIK4VH9Texqfju8law8RH4ef8zoCDr8ZJlGT5qyOeoeueSIMqBMe4/4YaajKAkui9PjkuhkVsK+5nZkcO0go3x4CgZL2+N2DK3R/bwKFcLz9nzm+5KA9vDx4xtpeKp97PjliHNgAC5nKeE1SO5hFgdNYocMJrsbfwQdanjNwxvggW6B4Rml3FHt0IWD/y4ylRU1E11XcMDq1exwiAXGxkWih+CkidRmhYhNNpT0kjK6ggwEOyPBgXrL8dLc3/NIUS3McVzjn0AKzvsUBjolVcvRlUseZYRD83Y/j3ZYviXfTC/+Xl7+xy0RqvpfghZ4BB15Zku0M9HSqLjp3HJHVPQ9EjkYrr2OSsfcFtolZE93+5qxKnsWnz6b8LKe5B+BS1WSTcsts85X04sDaRK5ZxM709qSeKRhThNe8XdUakB8ixP6n7VSqrMW5uPYTWDrY4s7i5jM4u5gh/yuUV0rsrzFVipfHVXi+1OvR0bqeIlyX0zrPvUzUPahpvwhnyJKQq1ahKOidSbMEmljFYOe0XZy1q05nbXVe580NBw9Em+9a0gWh4z2y25Su3WsitwU4k86dvQwMxBG2A9X7oee/1YkUZR38kIk3SyydX6yftey9sZd+vaHB+/Qx87lV/aiCTcBC+dSi1mgc6Oa
 6okIJEKd
 GKYJC4/zrhW+aCjEFRU1u/xr3OtVZ40o7fCBZm2KSBFUlxtu1z1txsh8hn6Vu2YST3C4aUX3+xGc1NJMxAjHVD55Ho4BRWDMONXI8qhl1PQRpJ6Te+sttLC006CmirTo7ukssTHpOJWxYoqgmEAm1C6FoxjByQn/H+mPWjViqxyBeEt4nQO8PIugvOUvLx8DFKU1SGMq3pZGDjmWJN1zUUXlNTjWOtTe5bB+mWWu79wGWLVfjt3VeXG9BPwIsfCbQqJoFxt4OxreiAnfb9vzyAVCjo9GhHYBA84T66YfZE0uSvmYsbgYCh3mOn9G6LNFxvhRISpuCiPv9jAjbcMIvEbHPylCnuf2sw93bK8l9i2MoXKq3RF68J2t76kcP/QAGbKxz94yaNKC15x4sXDFmcRY+fmcUTvcoYw3rtEUYe2Zo89sTbZ5+mUUS4mTMU3r6Kq1CSg24Z4kdqxbVi+eKZo1Eksw+9OqGTEDsYvIgP55YR6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:38 -0600 Nico Pache <npache@redhat.com> wrote:

> For khugepaged to support different mTHP orders, we must generalize this
> to check if the PMD is not shared by another VMA and that the order is
> enabled.
> 
> No functional change in this patch. Also correct a comment about the
> functionality of the revalidation and fix a double space issues.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>

