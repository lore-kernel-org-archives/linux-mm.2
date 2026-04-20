Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08247EA71B3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 02:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E276B0357; Sun, 19 Apr 2026 22:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE7C6B0358; Sun, 19 Apr 2026 22:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114536B0359; Sun, 19 Apr 2026 22:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0C4D6B0357
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 22:10:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D75F5B36A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:10:54 +0000 (UTC)
X-FDA: 84677306028.10.5FE5264
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF88940012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:10:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776651052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWzOt1t72cPeu02JKI3xjgO/D8VJid3Ud2U2B7wCbhw=;
	b=OwCwJLkRqB1EArL/fwNyhzW92hYfG6+XNFGQCAGGSmluANGumoahhoU4LD1DaNTRunexPw
	o+bkoyepXaq2yahj8fQya1KRCD8rUdVOiQMeLTwwxlFb3YwHpxMQlyrWo+ppvoZ+niydRf
	MNC21Kk8VUaydxVVSPLz3JSpYUSLoO0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776651052; a=rsa-sha256;
	cv=none;
	b=fFE4P89oNg4eqZ2zcEeNjkRxhQqxvtAZ5/HzeAH/Rp7AdAv5MAB028q8nV38ziHyjeY3pY
	zejIgI9PdQAXZQn2MTX+xlqpN0+IK6mF6WUrUrVFVA6ahrkZYfr+974Bs9jQc4t5aGNuVa
	7ePOIMeo2Nuy5z7yLKvx56hc7Yj1hqw=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fzTTx2xMWz1YQpmD;
	Mon, 20 Apr 2026 10:10:29 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4fzTTw3BqFz1YQpmD;
	Mon, 20 Apr 2026 10:10:28 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 29C42B53C;
	Mon, 20 Apr 2026 10:10:25 +0800 (CST)
Received: from SH-HV00110.Hygon.cn (172.19.26.208) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 20 Apr
 2026 10:10:17 +0800
Date: Mon, 20 Apr 2026 10:10:19 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Mateusz Guzik <mjguzik@gmail.com>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<muchun.song@linux.dev>, <osalvador@suse.de>,
	<linux-trace-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <aeWLCxru6cLWsxvQ@SH-HV00110.Hygon.cn>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
X-Originating-IP: [172.19.26.208]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF88940012
X-Stat-Signature: oiw5gooxhsardbx14t317harqyw4rmx4
X-Rspam-User: 
X-HE-Tag: 1776651049-19322
X-HE-Meta: U2FsdGVkX1/u6+ap9uMiwq0z194xdgNOWitdsTDbEHp5fa8dgTSdvu87scq288A2IqiF3LZJM9xFvupBSpWhM7mU54icauLqpLzu4fmTGRaZ9EC8m4vgg8WPw5lASMHuUw1fzrR1kWU1FYzCedjUwrNmN1Mo4ZQFJUwWZjIIJFJZ1swZvWaeIZGFvz9bQbTk3tKa9iLDeghWB2+qEV7rCVI4n9fIKGK8nuMX7tbuT6LERS2k9gE7qrSzc1mfMwznkZHm72oO/P/dIz+wxAwrree7it54E8PcZtWeTGySB3y33b8YP+XJg8b3NL11TGDG0y2JKWnflQEpTq/LmZ7P10a9QHnWBtSAaC9UfKDHYwxzz0CDk3bKEJ1xBzaHOzBOr5yn/Tzz/Bd6jmGJi1b17WApPzDiRP3w5nu3yYxHiBxyc4MYcG1ircSq7+wX7AMelcVtMuOUdxwFTx2r/YyE/hpACCzxOLayJvDTy1yEcqnN1yI/H/0f4olGViWBP1J0zIspslv0V17O3q4cwzT434Y1NQWBFgZSwipjyAakC+NlKQx3kP6XIeEhMUAfhFzGfH1R1KjuSwLmhsIMrzxC+WRwnbf8PSgJT/KDLsaMjv13UCLQHarkPWj/tCRzcijxn/zhhOYLVCvLRBI2k7QQuzgYTzvVKa4EqQScy+ThQbzMi2T92ermwyF8mI/UgKT+CyToUOwtvHoAMZ6nPNCgq3U91FpPUWuW+v9ZlmdLUzW+LDZK5sedrKMCIw1hO8aWD0fix0TjHtFUIIyU5yxbUqjE2ZwCNV+ZhiCaO4DLf+vcxLt6NXmjDqx2MjGiJbEas66BtWQ4xHEQYIQYHWR2WdQxH+s0UXVwSLnPRatDgP9aHkWqBLHV/jLnZ9Rq+ovogF6De13UYmn/xXw1IEQ2kDqViCmqcHTnK1+AbgCuUWJXIQmzL1pXm7etRIL3VGSR2j+hVzTNlRStZAgN3OY
 eewEpDt5
 cz/2PEQ+h2+HaPJ9Qgo5BBWckjEWosXHEuZDPvZkIA/+P282sxDSrW5EcccglCLKBpjyWC5ORpbyy7LsiLgQVPqLB2/Nq2zBJJL2gZTjKzoCmQyOp1FPt7l1ZNluh3n8QEuKoMJmHej5+6UXIG62tEWnnWge7wZNTMBCGoxX+9iIBH2ds+KklJmvp1oac0m0d5X2bECcDfbAji6zxn8otbwagbMEKxNpI7MdwaRWIzsMWBmfYVZkOXHuML+SvssrbWquDR9WT3q8y7IqrCV9aDI460Ekee40hdcYFZjshrvpHTtKI15uAsa1+7H5qAfcFnr8BwUGgTUPXtUn/djjhPKj95Bd3p+uPUNMJLZ02vOu6BAv+34RTAml249DhUwfP+PrRM+0IfuOCppz1nph7JjAdimXXixYUCgCDFW6TLd7+Ssk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > In the UnixBench tests, there is a test "execl" which tests
> > the execve system call.
> > 
> >   When we test our server with "./Run -c 384 execl",
> > the test result is not good enough. The i_mmap locks contended heavily on
> > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > The insert/remove operations do not run quickly enough.
> > 
> > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > patch 3 splits the i_mmap into sibling trees, and we can get better 
> > performance with this patch set:
> >     we can get 77% performance improvement(10 times average)
> > 
> 
> To my reading you kept the lock as-is and only distributed the protected
> state.
> 
> While I don't doubt the improvement, I'm confident should you take a
> look at the profile you are going to find this still does not scale with
> rwsem being one of the problems (there are other global locks, some of
> which have experimental patches for).
> 
> Apart from that this does nothing to help high core systems which are
> all one node, which imo puts another question mark on this specific
> proposal.
> 
> Of course one may question whether a RB tree is the right choice here,
> it may be the lock-protected cost can go way down with merely a better
> data structure.
> 
> Regardless of that, for actual scalability, there will be no way around
> decentralazing locking around this and partitioning per some core count
> (not just by numa awareness).
> 
> Decentralizing locking is definitely possible, but I have not looked
> into specifics of how problematic it is. Best case scenario it will
> merely with separate locks. Worst case scenario something needs a fully
> stabilized state for traversal, in that case another rw lock can be
> slapped around this, creating locking order read lock -> per-subset
> write lock -- this will suffer scalability due to the read locking, but
> it will still scale drastically better as apart from that there will be
> no serialization. In this setting the problematic consumer will write
> lock the new thing to stabilize the state.
> 
I thought over again.
I can change this patch set to support the non-NUMA case by:
  1.) Still use one rw lock.
  2.) For NUMA, keep the patch set as it is.
  3.) For non-NUMA case, split the i_mmap tree to several subtrees.
      For example, if a machine has 192 CPUs, split the 32 CPUs as a tree.

So extend the patch set to support both the NUMA and non-NUMA machines.

Thanks
Huang Shijie


