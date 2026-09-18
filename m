Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4EBC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84DDA6B0092; Thu, 17 Sep 2026 23:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825866B0096; Thu, 17 Sep 2026 23:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763126B0099; Thu, 17 Sep 2026 23:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 548E06B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:14:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFC04120560
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:14:15 +0000 (UTC)
X-FDA: 85225414470.17.45B84CF
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf08.hostedemail.com (Postfix) with ESMTP id C98F1160006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:14:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qfn8QFMN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789701254;
	b=QmZ1mI3EQjhYbYjRYt3gicngeTispA4qMoohl9vfFG00+whK9Dr2JVMyPP1662tqripwl8
	fmvS+p5droljHQncQwXdzpNW8nDjKBHys9BvwOO9Z8BVgBS2giYYbBfkpK8jlC3etvH0Rk
	x2udzbB0z4KIygpVpGmokCoH1nPjE7I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qfn8QFMN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789701254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqxIYHEwC1oQiq/8yKTfLfJZ5pAHtKGNIYsltrvQ3mM=;
	b=zIk0PcZVrP4ZfYH3M75dTtlYO/iWZMvTh80Guo27+rXZ27J7m0vjpWpBbR39He/XnjOH+T
	MbStaQVbO56a+QU3GpHWgBq/UfQ7Tjz9NptZfoyaSvJa1nojk4zaNtdq+l0VEQfuzsOV9b
	MdgFoAVNE1Pq+Lq8ERubnGXKsw82lo4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lbhGi4o2SC0IANPATUSt6s9fXNLBC+atgB/IchScY9c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789701252; v=1; x=1790306052;
 b=Qfn8QFMNW6NkCtAk4yoEKcVWALgKpPrWGz4Ttx/ojhq+jBDz3f3mw7hPIJp8qCq6qSmlTeQO
 kOoln+tHJOi2TcJboRPJsqtPBSIFsxkF08QzVQyX4RfoK7Y0M7sKWiQ7u02W7C7lc526MzBILtZ
 kOtosbBRcJVj60uq68+rFZN0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e6758c9efe7eb6d1;
	Fri, 18 Sep 2026 03:14:12 +0000
X-Mizu-Trace-ID: e6758c9efe7eb6d1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 1/2] mm/hugetlb_cgroup: move per-node usage on cross
 node migration
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-for-hugetlb-charge-v2-1-2b6d8c2bdc36@kylinos.cn>
Date: Fri, 18 Sep 2026 11:13:57 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kees Cook <kees@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mina Almasry <almasrymina@google.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <6BC6926A-38D3-47B3-A676-D89DFF8E212A@linux.dev>
References: <20260918-for-hugetlb-charge-v2-0-2b6d8c2bdc36@kylinos.cn>
 <20260918-for-hugetlb-charge-v2-1-2b6d8c2bdc36@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C98F1160006
X-Stat-Signature: 7osu6rcuy8anxbu8b93m3qf7pkks16c8
X-HE-Tag: 1789701253-281990
X-HE-Meta: U2FsdGVkX1/vBieWfb+CULk2WLmkcnYxgKOzaPYpYy/xdRMU00ntvsr245WBb7h36VP86/e7tdl4NAwpA5AmUusQBZyT9eVLV/gtblM0h7LwSCa3iznSO9LFFRxYj930ruuQ559BqhMEJgSnwXQPcBejPICpDniFIxD/64oLmhrEJEQ2EIYWI2AQnc6QShAGRRZdaheOqfPBciOnHfvsEwQs4TiuuiQvw5ZVfiTnGURhKF2WBYrYUN88Rbu/umv8lid3b0Lk3OPPf35IiZIsGvgqCql/NH49Mb+f9ylT6L1MGQNRrKCndo8hpW4OlRFhR5lLIBfdbwCEL5OADDGOfHRJsCkcI7iZr4Dkm+hpQVsUIMP3t57noM3TehkKqKIM1CRUTELlgIEgXvAnzIv87Rscmel5xn1JyJ0SzZHFyRhCsrXO8oxzbsm6yC+lw1hZ4JdNOsrCkrKiBb6uw69E9UHoaBDG2gh8Ud49gOlTKpvIt1RO7aVjr/GF4MvZqJ3eiF3iCsy+PZUEqiTLaiJa+OK9W3UKVeNm/IInBoHoxND42xh8fLkjLF8p4P8Xo1bUOLOeNgXLoD8OuCFztRzdnUFskjno4DwFUQf50PXCNuFVcgGeGqqiCbpKNWcmJWXGO/QjC8zfyNaIFu0zd8iJfEbt5gxaLPhox/SaPz8bxkPi/D6cSm+9oVrvhS5BZxUDWdpEJfwrERXiqn75v5eyRAK1ncBzOH8KiKvb/nEbrj5DPzXBGWz104JRp2zZXdeh+tfBOa2Zt/0PMJuBDUKW3ECjbm7zQ2KapYqNh00poRg8Jmkz53i/0aFOnp+dbyOfFIcb+SaSm+dVWUR6MZT6CiTpTZilB+Rq4EHyqPpAvf2cwPcYsOUmJz530p1/ffkMvDfS+78Ur3lXVvDLPVKUTFXt5jJBXxd6DcBGle6ZnpEhUA+GsX0xjn3OQEXMRe4Ey2qQLjVcdBuZzqyEv3V
 kn4AOIxE
 TwteyJFeUN/kIb+HAfpRSwrZw0/qlqxeZBZp1OFF2PAwzNbleQoX+VJ7HuPPNbSdXTyP0LzyVJDq7P5DHw5NajORSDWgznh4GfXoPaZ6/ZzJvvBSz/7d505f+SQk1gJ0cneyXaguWbjPUyYGCH0A3eynFPdHFn9sQoEJs1f+r8V8HpLRceG4a0abdsssDGsCoxqS4ZVOqEfg7LUKt/lgVvJhfB3DlvtEf2APa5002URxDqA5G/TKT2J9bdvxxQ63zGP8sYuOuaEtM8ihlXlsoGWfbsSXkfIQvsTD9J4s3ibtQpKeMObZiB8RzNL9zS5wSg4GffIv/F9mIGVY/yKN86JoJtQGd7hrGU0qyXVAaclHW+st6vjWUdlVKrl5SlXTu0nM3rOgik4GtZLNOzTqZnMBZfVt/V1ju+pNL5ue30DFSUQYDMHzhbtTSTlbfwJmYnlfc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 18, 2026, at 10:56, Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> hugetlb.<size>.numa_stat uses folio_nid() to account usage in
> __hugetlb_cgroup_commit_charge() and __hugetlb_cgroup_uncharge_folio().
> hugetlb_cgroup_migrate() only moves hugetlb_cgroup pointers, leaving
> per-node usage behind on the source node during cross-node migration.
> 
> When the migrated folio gets uncharged, we subtract usage from the
> destination node counter. This creates stale usage on the source node
> and unsigned long counter underflow on the destination node.
> The hugetlb.<size>.numa_stat interface exposes these incorrect per-node
> usage values to userspace.
> 
> Add a hugetlb_cgroup_move_usage() helper which moves the usage from the
> old node to the new node, and call it from hugetlb_cgroup_migrate().
> 
> Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


