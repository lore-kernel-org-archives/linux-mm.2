Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69921109C027
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5046B008A; Wed, 25 Mar 2026 10:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55936B0092; Wed, 25 Mar 2026 10:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44BB6B0093; Wed, 25 Mar 2026 10:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 930586B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:45:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B69D1608ED
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:45:22 +0000 (UTC)
X-FDA: 84584858484.15.B24B71D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FEDD80004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:45:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Up5EPsQ4;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMjmrtSfCxR8OQ5E0jmTr14+PyrQJBe0FyWbT08zrYQ=;
	b=cB7Xh+EmTKQ6ydJ2Z3I0l3usTEpEUssVc6Ja8IzRpIRbSr1fAe16jZ2P1P81npqB0K9U8f
	XHxzqfRVqdAXTlj9TjIRMhdSLhLodIY3NQ3LrFDJL20VNnC6Fz8KjHY3rnjCb1s5BIVu6v
	/objdzfYCAbt8t9fVtcXBrYDhbn7IgU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Up5EPsQ4;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449920; a=rsa-sha256;
	cv=none;
	b=wssnD7PHtvDH1CtcdA4vBx6kZUBetCX/cfXK3dr2GRmqfnwCiE4Q/0MQByad6d1f8m5ZuG
	DjAN+u7p50R5Ii7Ju91uXNmH11++hU39ZONxRfr+9ruASOcZeQe1gdWH36+UyAiwVy98uj
	P4Ogzdx6jeEGv6ECMdutv1EjN/Zxhuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA45A406AD;
	Wed, 25 Mar 2026 14:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF3CC116C6;
	Wed, 25 Mar 2026 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774449918;
	bh=/an/KwCQntWa3hhEkzoIDbyA6XLJ2HTuCSgYPgpYTOU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Up5EPsQ4bUzLHKopp1zrTWgXDcejLPlvkFcAarVOI++LnRDNqPd4bqQH/BGWtIy/7
	 gnxCvXCn9eMIICSDI3yNhJhvULzoOqKeHPBv+30UgoBXaE9Qq098KhaxDekbHh9Ke2
	 Ub5E7IgxumcSs8ViB7lHbM8pe81IkKBGAlY+RJGM=
Date: Wed, 25 Mar 2026 07:45:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, anshuman.khandual@arm.com,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 2/5] mm: introduce is_pmd_order helper
Message-Id: <20260325074516.46bfcf772d5eb4482d7df36d@linux-foundation.org>
In-Reply-To: <eed250c8-7a31-4ace-b5e2-9f2898599ec8@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
	<20260325114022.444081-3-npache@redhat.com>
	<eed250c8-7a31-4ace-b5e2-9f2898599ec8@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0FEDD80004
X-Stat-Signature: xdafuyoq5ermynh8xsi16tu544o1dqmb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774449919-788250
X-HE-Meta: U2FsdGVkX1+ZkZDhPoZvD6WEwHsjRmyq9V1/+XpHknkNDJhdE6dRuXZPvHgnXWCg4aHhAC4j3r7+z7Yw+Uy5m7zu7gb/5bbOZfuzlH7xLYC6f/RMO00VrpH57HGYxS3epTa2QKzeR7YzRc5lPyc/sknk0qaRCiKneNxVy/fK/CEFjt5HHd9eAyMU9BrP7H6EylpWfpamkkU+R7TEj98xeMRKrEymdmQhC0cru5G5WE7Xpy0PK/iMB/+DKEvwvbHSTV6I0zxE9fUTD1Jt88ZnVh2EZ50pSAhJ34kyyDnS6rHBLOTlr5Yg7hMxrUZCJIcsCt8Xs9IAaeny9+KB4M3f+ld83VMp+mgrSeVPL8wPpS0Ty5IL0NxwIX3veprujtVv6oxVaci2tJNdsd9ZlwKk5RUoWUSki2+35cYDdbf4zd7rElx8Y6IdJ6noo8Ayd4okEl8XsHD/ZVVpyE3tOI2JFianFGDU8nY7A31xcXre18MPYF6YVC8OwQEjpwbuddFAUq6djLOq8wm8Rr9ahc8FLWRcM7SYwQPq8rD+un6ZZZxKoICkC6oHRICXKOS62gztOE9pCaFpXhXEOgizE5DZnM6YniN4d0bZsg1sD2/aQwzfqdDzaLjBCo5BSczQhmDMtV1LyT/HEvwq5RPoh0TtmypwspCZrd+twzsRxU7QQsGS8U1luCajnrPJ6QBPZ6X+4RwcGrtFqXIKEnC5bvJo80TJ6dFf088jvmVLvL404Tk2D1DGzVygHi/xI0ZTwWWKEE69yiS+A27U8viCtBq2OmJBvIC8N2h4oSRVQnGnfu8T3bN44E4Au+23EMbkhslQ3J3CudsbyHy2D/hs6cGAFK7O8BtJSNRdE0QdWJ1NDjzxjLr9xG3LwoyG01ydb+Rle2TXVLiaRPnVmoXO3LHiABgWfiVfXbFylElJ/b9sjDWz+KzYV8j+PJgWnOUfOkweZP++GGfMcsNaWgd0htQ
 4dX73/HB
 bJRb/m9JIx8yh/OjLmSrZxfnFAKhwHIroT4it7zmCNz+gie/pT+KTDiy4U9roG7Ohx96/Hm5Qi2uDHXXikGv/pNSIUC8vng8Vd9uP+Lj4OW4VsoKj747HyGZr77tivs/Nm0ZLAswDi2rM4PHTlbBsA5OYpTbQgvn6NgatYvyZf5txqe0PU+R08OwbcNpmZ7E7eQ00s4qCPivZ63+gpZp893Kg3Jgn7DkbtWeo6+FkZvnl4/U43a4pwKPvrqCDJirWL0CLuz+rOgOdGJn3iu4emzGl050Go1d9WWSbLzYgLDK8Zbcae6S2bTkPwhiq8P59FAZ88ZA82tj83fS9tWCtS7Q1y/U5Bwu0R9Uv9AlBcyvmR22NNPmq+wIJcMFM4FK82nazEzIVSzvVtqP88MloA10LO3IkCRMaIKNUEeX4Qma8+/3ZIakcM63VhCo+XBPG5C5N2YVzE/4dnrWvN7bo+6RR1GMk4TGl1avKA6h5TcpHCsq5epq+dMWPZ3C9NJ0kGpXfYTLJ6Mf6hXzpkgJIq2nobz+D2roZ4kBq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 12:11:43 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 05:40:19AM -0600, Nico Pache wrote:
> > In order to add mTHP support to khugepaged, we will often be checking if a
> > given order is (or is not) a PMD order. Some places in the kernel already
> > use this check, so lets create a simple helper function to keep the code
> > clean and readable.
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> Nit, but could we please update both to:
> 
> Lorenzo Stoakes (Oracle) <ljs@kernel.org>

hp2:/usr/src/25> grep lorenzo.stoakes@oracle.com patches/*.patch|wc -l
105

Please lmk if you'd prefer that I go through these and update the email
address.

