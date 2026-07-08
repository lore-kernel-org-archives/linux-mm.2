Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F92C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8E06B0005; Wed,  8 Jul 2026 09:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A0D6B0088; Wed,  8 Jul 2026 09:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FE26B008A; Wed,  8 Jul 2026 09:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A68176B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:49:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CE1B1A016B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:49:04 +0000 (UTC)
X-FDA: 84965740608.29.7A94064
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id BCF3310000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:49:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mXbZxdXN;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEGzzoFWcnNWGGmasKpR7vNO3wPHNttV6bHdoJJUeuk=;
	b=YkhFONr32YLzEzwTjgKx7EQBEy6QGZYdAUZysUHvyMcJzD+SRdQ4czX9tx8R6p1668gc+n
	hVmIk0UD0xuLiRwmZ9SD2gZDW58LH6tRqLUWhoYT5LPYZRzV1wsEGAFGTtLvLc7H0Z5Em7
	Ay8+9wafCuIiSS9rX1d5ictSo0aRzKI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mXbZxdXN;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518542;
	b=Ykf6jMsA3OzcQ466baqEUMZpzAo5VZTzQ6Sk+cjVXWgwLuqMakMRQtbYwGEdX819uB6o8G
	JTPGyz6U9k7tpalP15Z499pD74WzSo44DeSdN5/y6LHsc43I6IAIc0ZymGh2FZKKa+kbUI
	DlEC1Af0bo0ecpsdhugRUSkfMIL3Cho=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783518539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TEGzzoFWcnNWGGmasKpR7vNO3wPHNttV6bHdoJJUeuk=;
	b=mXbZxdXNK8zwfiH+BaVAX/a14LKht5ZVC+Wv7EwJmNmgfH7LWboOjRCpvZuv44yqZ92n+L
	HTpOJmwORQJdus2K/nxg2k5sHDV24WBE1jpcCO3Xmgfz/8evz+Zw4qadzjqXk+l1Ie5Dkb
	HqYuO1oM26W/bUjStsW0rqIMNmJO8nA=
From: Usama Arif <usama.arif@linux.dev>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam.Howlett@oracle.com,
	linuxppc-dev@lists.ozlabs.org,
	Miaohe Lin <linmiaohe@huawei.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] selftests/mm: handle EINVAL when configuring gigantic hugepages
Date: Wed,  8 Jul 2026 06:48:50 -0700
Message-ID: <20260708134851.4153021-1-usama.arif@linux.dev>
In-Reply-To: <2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BCF3310000D
X-Stat-Signature: swswox1o4bh8xq6hpz6e954z8rg7enby
X-HE-Tag: 1783518541-172865
X-HE-Meta: U2FsdGVkX18EONQCRPk9Ji/5LQAOVA1IDQms0E3mrq4J5lWV/TYryRVdn3GbjCH0Z14P4gRzYeUS1tDoAofJoVvU+0OjDiw6NsyZLDpeN114UjOdTmJJaBK8Q2EaWmGOZwAvHD9qhbpkQkUratR1QkBiPuUDmxTtouXc6qMru5HvjJ4EhQscwEWeCAwfq5pI9KLAfsGU7pTHQIjPW3r0LJla0qcolOAbUk9R9cWbzTS9tuckWjFbw/F7U+xIegYpD1UmOA3qDpA9t+O1Ddo7Q17Rold4INBnlBVLwFWRMM2lPGMXaMzlDG8/csHmkXABlY4W7bNIisaXsDY6Rv6PK+iLyF3Xqi4pF6QUIxhz8yVnv8PQLR1XiFnAY/Su6+ySLgfn3nB3tqfbKABoaY5pjxyaf+7kjZckYbNotmS9UdAzgQyyg592fwyXsIYfyIC61dUHIeH7ok6jkmSGG53UvTKWIe4dSyFyejntzOVux/s4NbiDxqv7KTylEv6GWSkZtG4L7HXQBhmczWQlYPDrmsFWm1aH+trfFJTNK6WtAqo5N+zOJ9Q9e7HuZPyZvihn9LlklksDSADfF6W8OJ2p2E1VzzIyEGo2b7i7HIL/iU+An3V5s/5g8tEPz74oMaMJ2I/gukdqJtf7RhtifVYWUJ+0EpH51m6lvBrhAa89OlnQpJkKrTYqoVAuVKHUL94l3XI4VJ7TfaIOEzVcZxLILor40Z422x1trXWFvbGJELsRdtRisJnobdFfA2WMpXIpakeM9YkIBNr9r/m42vhNpVm7OncQMpal1A/jEBdFcySUH5/5jzyv1ZYvzGqA1NOjLgraQeEUbBWP1CoBMtZTI+6w3HC4UWySUDU91BfUy2tiIcpDbD4hMgsKWBcpSjSPLR7+mRCNDeO6MwBtwfhneTn86jc2PBoWlBg3yifKmDl3mcaJurfkfM+OjgUIqdt6d62RjEjj463ev2/2Uvv
 HB/rCY5Q
 cc5Vu133IayOhnl+fnrz/PP1oPRYAxPzttOqZ/525/hZTYvSqhdjYtiYLF8bz5r1WscOyFk2ZRCS7VbsP4+6Ra4lBwKXHc3V2jRK1mVliKOSrROrT8RxSWNiuMq6UcQdVe4KP6Zmty188fKkM8/EN71YpFx5uZI6IV59xa8pM3LPFqTSqTrriVid1taOBdyDOd9QieihzwXflC2sH8Ygsnbrb8c5fVvc7QNSij8tRwy1C8cKM9CIfX99otySjry2u+AYzQ5cLfPx2TFl1DN8x+xUXaHycfqlUcwVM65iqrr5i66l1c6POImQTnYxXo2jtsZhk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 12:29:05 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Some MM selftests attempt to configure the amount of
> HugeTLB pages of different sizes by writing to nr_hugepages.
> 
> PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes
> but do not support runtime allocation of such pages, writes
> to the corresponding nr_hugepages file fail with -EINVAL.
> This causes the test to bail out even though the failure is due
> to a platform limitation rather than the
> functionality being tested.
> 
> Ignore -EINVAL when configuring nr_hugepages so that tests continue to
> run on systems where gigantic hugepage allocation is unsupported.
> 
> Before patch:
>    -------------------------
>    running ./hugetlb-madvise
>    -------------------------
>    TAP version 13
>    1..1
>      [INFO] detected hugetlb page size: 16777216 KiB
>      [INFO] detected hugetlb page size: 16384 KiB
>     ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>     Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>     Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>     write(0) failed: Invalid argument
>     Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>     [FAIL]
> 
> After patch:
>    -------------------------
>    running ./hugetlb-madvise
>    -------------------------
>    TAP version 13
>    1..1
>     [INFO] detected hugetlb page size: 16777216 KiB
>     [INFO] detected hugetlb page size: 16384 KiB
>    ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>    Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>    [PASS]
> 
> Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  .../testing/selftests/mm/hugepage_settings.c  |  2 +-
>  tools/testing/selftests/mm/vm_util.c          | 26 ++++++++++++++++---
>  tools/testing/selftests/mm/vm_util.h          |  1 +
>  3 files changed, 24 insertions(+), 5 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>
 

