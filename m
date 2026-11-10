Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E438660A260D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F1BIbj2f
Received: by kanga.kvack.org (Postfix)
	id 1D88A6B05B0; Tue, 10 Nov 2026 00:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1893F6B05CA; Tue, 10 Nov 2026 00:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07ACF6B05CB; Tue, 10 Nov 2026 00:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD2E76B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:50:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82982408E5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:50:57 +0000 (UTC)
X-FDA: 85418135754.13.F1C90FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5C7B40002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:50:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F1BIbj2f;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZEWtGySM5+QQdruouC1viwqoN2MmrPWa2xX8Qe0HyY=;
	b=kuQkqkFV78PiX2tOd3QTx8VuPcxKf2XIC6r0Gd90srBNDw8N9rcG61/JvyHsPuMOVLBTUc
	rYPqaXDIXfzJxR95mFr5i9phWmmjVAgd7AzZK8jfSd7rS2hHw1JYSOFjyk0gUQodQs9JAU
	koPBItuTuGhUIPWyDXCzv+sQPVCvKks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289856;
	b=xVgppGshAgtUAdtccBDzdGVauG/RI4ifhj9uTKqqqM84pAz7sEFIrO9HNSmVWRXf18URxK
	1AjEaYqIv2/W8LBVnvJ7B++3NuLIj2qmNBKhfSMtOvd1milP44zVXFlmGGOiRuXO8HoQ8w
	U7X8xFx8CIs/eHydL+++Ww6li2exueo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F1BIbj2f;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BBE843DE9;
	Tue, 10 Nov 2026 05:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54C71F0089F;
	Tue, 10 Nov 2026 05:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794289854;
	bh=6ZEWtGySM5+QQdruouC1viwqoN2MmrPWa2xX8Qe0HyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F1BIbj2fUIITKtbEId63TpSMq4PqBsEJ6k7T00RQXzEtLuknjZHkZ70W0/3Gaab3i
	 i+HafO1XRfpoNvd6AFGVuIdzHI0jxAGHLKgIF5nRyAGZzPUpdLSsrv1lxXrIHqDEjj
	 kXyrWLMn0/9fWfaRvi6HT+APEqk1sf29Un2oYSuA=
Date: Mon, 9 Nov 2026 21:50:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: zxgnuh4i74rzxwagqfyohippsmdaarpf
X-Rspamd-Queue-Id: B5C7B40002
X-Rspam-User: 
X-HE-Tag: 1794289855-325361
X-HE-Meta: U2FsdGVkX1+xrnKwvX3hjts99bDmFYZ7I6PjvmYOrN9OSAG2L6T+6N4w2YU6woHJ0+G0PWvVUDW6uqriCm+xlA8bNnPrrnxZVTMpNmMmg4cCQ7zxH10sUjiAPT1fNQpauMoxseshiGaPSqT7Ifh8hZIYpJC7Evi87YfRMjau6C6bZ4nqZrWPZ7RlkBfbpkvi1QgqvE28N+ntSHXBhipvBvbHKLhGo5VGoQ7fBzBmmf+724Ic8BszIbYY50Qch5r8ug3ZPDZgk+A5DPJvndEnRmCTkNkYFjtczQ63xMwoqF+NDHaFgq74RqPXzwXyyYrONCixJHHzzypZyHv2qFvFSL5aAEa0yJMBpvKZtOSKgUCxmqnE2dLfzWjrYZY2c99hNyYJWqNytp27BbAPrYozzhyKjM4Y5u6xUkgEIgMGYJX2wUmS5ubSSBXMNujYGSh5ljEmqpKbrRGVQK61guIjJqfyBMBtRi7WUQW1CmbjPfQWhbzmB3IRLd6C4kEDo40SV/b24Y/NAyBXYI/MXeDxFK/QsfbDv22QYrhuRT3v6pEhaR71kdOh8SJ6jZlCuAg0fvqnM+4H1JY+fhfAYN5DCrnrHasvJtuFYrRIOy3DMJd2+9RdeoQ7HyCHIhTt/t17eFK4raMbk4pgB3PBtfxDhQqKJ8G9KGIGnqqOPka/QJi7OugmMTQ/MMmk7rbnJtJHEW1hWMqQ3fpDs9M5PhedfBMazijd/k9zYr93bpjX3G9g5YY7fnJFuP73Gcw+dnHULfCEJVzGzNYRxxdSyYKBdVxj6eYGlGHud2pxRSe65XDh+zl0rwJnaLLl/onWu7rLi9NRY2uDhk2zjm9Ogvw3daJOBD77T/TaRVa8Wm7o/WxtIa3Z8ngLO6c+eDE4aQZHifvcp6ju3oLj4fNRGagXGjM6lmCtgsTKwjZIuuwU60ALP9I2YRn5o3/rY2wIPR55NpGxCgYLi+QCaM2Dq4z
 kgiInMHB
 dFUX4brp7Awuyi0aS1eMX3qjYTBrX14eyrw9Y/zAIkmi7pTi1/6oPw9Bavxeo8bPdI4qe11Ihn4hrJbHobPBvAJGRJWb/RUEPj/Ur0Z9NtfHV+nNzSaSnmK4giYFUWJ4/kt8AbNFPt267IAlo8CYywxPpWT3QJ6Q/eIbdzMHWwfZDDnLhraV1CCEBlcFWdvS3bajj7BQFuXZYPmgobY+MAeD29xWYESO/w6Wkc34QdhI5Xh8NSdTt3lOlsZ97CXyWL/Uvl2mYoMoYZHD+gP4uVwvjxgJpr3HjvXHYnfI6Q1zi8laIx7hoinYVxbK4TIpErY7o130j0d45FO+tD8UWxSDKQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu,  5 Nov 2026 17:22:28 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.
> 
> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
> limit-induced reclaim of a cgroup neither splits its partially
> unmapped THPs nor writes back its zswapped pages.  v1 of this series
> [1] restored the flag to fix that.
> 
> However, as Sashiko's review of v1 pointed out [2], the flag alone
> is not enough.  __list_lru_init() also collapses every list_lru into
> per-node lists under nokmem, so even with the flag restored, the
> objects of all cgroups share one list per node: the per-memcg
> shrinker bit is only set for whichever memcg happens to repopulate
> the empty list, so pressure in other cgroups may not even trigger
> the scan, and when it does, the scan walks everyone's objects.

Thanks.  Sashiko still has significant-sounding things to say:

	https://sashiko.dev/#/patchset/20261105092233.3558950-1-qinyuntan@linux.alibaba.com

It also says "failed" for reasons I don't understand and it doesn't
seem to have emailed anyone.  Please check it out?

