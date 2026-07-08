Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0399EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F3B6B00A5; Wed,  8 Jul 2026 09:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7716B00A6; Wed,  8 Jul 2026 09:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D005D6B00A7; Wed,  8 Jul 2026 09:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABE226B00A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:55:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E31A4016A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:55:28 +0000 (UTC)
X-FDA: 84965756736.04.5869541
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 67CC440007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:55:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ApkfZAPe;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DumeYOm4RAsOVh0uQBPFbd4lfQ35Js58LdeDgME4iC8=;
	b=MEYtt+/zAByDf0Ncxb3lzuY5NOUyA35Ti5NvgGpZh8C0Fc5VnM/IqSPFofm+DfIZ9CSoFg
	L8l1WWR3TE1tz4UNMsmIfknVhkgi0r8asus9Uw9IUC+XP99/sPmJ/2cSahrK3gWmoxOPWu
	JAma7/qTiieezlx+AK5C+b00CFsfkY0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ApkfZAPe;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518926;
	b=BTgwjpDxVuz7s4Mnm1Ww7ey+WPV6UF3nOzQAB0oCuByYeHQ44Yzz+ZuNl70UtNuin/lKcj
	H60TSu0E/jduxUERIWcNPwS6KtdA6YT8e+kXHNpeR7k1XTwctIO46JEP5xtVxWLyxRDmZ5
	ja+cmw3xeehwl6LLFOwuc9ClezRQKCw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783518924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DumeYOm4RAsOVh0uQBPFbd4lfQ35Js58LdeDgME4iC8=;
	b=ApkfZAPexPaSLNtsfl42DBx1qyChc5EO2KpX8eeuck2SebANu8tOXOMCQ1T+/zOIgmk5bY
	4ee5xmFvzYgajiV3YeMtkSbdFKoo1DTlJed8IyOX2toProdSQ1KS5WwncTjvJLWvf3O0wz
	lP4gXygReDf/aARZ4m/KTneai1EYZ3A=
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
Subject: Re: [PATCH v3 2/3] selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
Date: Wed,  8 Jul 2026 06:55:02 -0700
Message-ID: <20260708135503.180169-1-usama.arif@linux.dev>
In-Reply-To: <78a3b0e3fb94004c0710872c5bab6f7381b7d63c.1783446924.git.sayalip@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bj3dcqp7mjbwer4hznijtskotbuf6pum
X-Rspamd-Queue-Id: 67CC440007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783518926-483927
X-HE-Meta: U2FsdGVkX190FBizK2JIh6tB2sO8T6ZGXvhlnjgOe1Onq+t/mFZNlkWIyAG0O2odpXauP7TOxCOARo2/db8E2U/sYHC0v/r2pBmevqgHAfCg6jRg8zY5agvzDfqoHOeZJ7yFr++3FM/O6vcdy+bxUCO+vI3TzwLtrfAWSc9snrzq34MndAs8w87r7wvR5CxyqV7WLYetpx2PBUxTFSkEv5kW3ozNXdnJN3gOPZsZifSnt0kn2Gj3mKdET9TZu+wYr5IqLdE5ace43pTOsgRjDLH/ERvG9F+6f/L37E2fmAW0uJ9e/erV5pc+tMfwMKugH79tIs9Z+IMi3hYHkybGUb+lPTbqSPWO6xzCMogTbzLHCqe3mvx7JfSzYS1xmQwvP0gRU0+RyGRjvx3atn1g7cS1xBSP+ypxqv6MmTJE2kxo4ATI8vW7SVkUOm9ekzsZfpGkJ/WsCxuHIrS7V3/NzReotyeY3c2IocDXTl96zuwpxuVDgfRYWFbgR4+UFJvePc+b0O561PkEAA0Ow9UbBaY4ov3HzeBZrNGQe8W25EEUHt3PPPk+TYcynMZOPN/VTNqVpGPEy/AL5oCCmT+Y/defDBN5T94Vg8GjZz8TR6DBz+7+9K8La7xHMJBEqJQu0+k3X48Jef/LvwdcpbjFawcjzxlmgD+L9wN0azyGbpNBHCt/qVfzI9u6DVj3tdqpaeohVA8MvgMsSu3fzXXgfhNtGPJkUWJXLW1KFtuHP5BcCWG1+FSgdwtSycZv3iQhhujf+xT0cQsxehj85nscST8L4cLmeYvbEbs7mtexj2jfCa+DhjfM06QtstxD1QG2/sKVs4CEoKLEJXHSbtkEy/IUJX5+MAdkIccGGvVNJGyfwV5ACI0E4bkAli0hbhyzPMBNMHpQBoJBNBdbvzOw/tyVmJRvK4GC6B1jG8Rgklrl1d+ne3msIwXMM9zjKRJXBSeXAml1BymycyXtYMB
 bhFKk2cI
 m1zmiTYJaZwRkQFc3Gf5+jjHjqRkJmoALMELIbtg3by4gBDmVTytJzc8uWe4QTTQdGjRAgQhbHas7eIolibPq+dMApMpjzazEw/E2HApzTmwg4i2c7RF1gWfy0FYgb4L6kt2OkEudOfy6aN8HbdEPYamCa3DxcMEDR5SBZM42KqIHUauk99oMAQzbGb86ARn4T3WjdY2nBHnWDfq92derpD3JQFFP0HbcHT3LGfTt+i8yg6r1lypsUJqnIbi8/rNFqZVcMC6nuXS/x70PVlAaWbYu1finnOKYw3nsPwYE1kALSCufCdwN7OKBEkHcKBf/Iv1B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 12:29:06 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> The KSM NUMA merge test allocates identical pages on different NUMA
> nodes and verifies KSM behavior with merge_across_nodes enabled and
> disabled.
> 
> On systems with memoryless NUMA nodes, for example:
>  #numactl  -H
>       available: 2 nodes (0,4)
>       .....
>       node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
>       node 0 size: 14825 MB
>       node 0 free: 1382 MB
>       node 4 cpus:
>       node 4 size: 0 MB
>       node 4 free: 0 MB
> 
> the test may attempt to allocate memory on a node without memory,
> causing numa_alloc_onnode() to fail and resulting in a spurious test
> failure.
> 
> The test currently checks numa_num_configured_nodes() to determine
> whether sufficient NUMA nodes are available. However, configured nodes
> do not necessarily have memory.
> 
> Reuse the existing get_first_mem_node() and get_next_mem_node()
> helpers to locate NUMA nodes that actually contain memory, and skip
> the test when fewer than two such nodes are available.
> 
> Before patch:
>        ---------------------------
> 	running ./ksm_tests -N -m 1
>        ---------------------------
>         mbind: Invalid argument
>         ok 1 KSM NUMA merging
> 	Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>         [PASS]
>        ok 1 ksm_tests -N -m 1
>        ---------------------------
>         running ./ksm_tests -N -m 0
>        ---------------------------
>         mbind: Invalid argument
>         not ok 1 KSM NUMA merging
> 	Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
>         [FAIL]
>        not ok 2 ksm_tests -N -m 0 # exit=1
> 
> After patch:
>        ---------------------------
>         running ./ksm_tests -N -m 1
>        ---------------------------
>         At least 2 NUMA nodes with memory must be available
> 	ok 1
> 	SKIP KSM NUMA merging
> 	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
>         [PASS]
>         ok 1 ksm_tests -N -m 1
>        ---------------------------
>         running ./ksm_tests -N -m 0
>        ---------------------------
>         At least 2 NUMA nodes with memory must be available
> 	ok 1
> 	SKIP KSM NUMA merging
> 	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
>         [PASS]
>         ok 2 ksm_tests -N -m 0
> 
> Fixes: e3820ab252dd ("selftest/vm: fix ksm selftest to run with different NUMA topologies")
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/ksm_tests.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev> 

