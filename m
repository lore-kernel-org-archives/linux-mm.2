Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4295DF5A8DA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 03:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F8A6B0088; Mon, 20 Apr 2026 23:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4303B6B0089; Mon, 20 Apr 2026 23:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3490B6B008A; Mon, 20 Apr 2026 23:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 230C46B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:07:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6378C1A0BC6
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:07:12 +0000 (UTC)
X-FDA: 84681076704.06.3DF3893
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf12.hostedemail.com (Postfix) with ESMTP id 24BD540006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:07:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf12.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776740830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7jeNgSeoZ3zAmAlPOOJhAQr0427z7CbVWcmTLavvbLg=;
	b=7rb2nPBKR0a8V8PgY3DY8iIrqyR4EFrZosviD30tGJBHI1j8l6JtTRy0Qs45YMW1qsHtFR
	j1M/MibnFINgevhBYE5L4PDDxqMTcn5RpT/aUBkaeOP7Y9YiCdRaGTWJe+C8X/dOb+waIM
	h/Ib9YbM5kYa9ky0T+ScjQYakiGoPU0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf12.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776740830; a=rsa-sha256;
	cv=none;
	b=y98e4z8xW9DnRrUAahsJlxSCBAW+X+0a/UdzSRmtQpuebJ/mghZZEWNYsXxO+GjeZE8Qai
	gvK7fmV+LI5nx9/PrSgrKbkTp8uUSw+DIoFlcMIM30dI6es5CF/4fDCJzDmU+SGTwX4W4F
	NbLF1tHMxPNag6/Tu3eVayR6gBQyvwE=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g06hl3478z1YQpmD;
	Tue, 21 Apr 2026 11:07:03 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g06hj31Ffz1YQpmD;
	Tue, 21 Apr 2026 11:07:01 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id A77E933D4F40;
	Tue, 21 Apr 2026 11:07:00 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 21 Apr
 2026 11:06:53 +0800
Date: Tue, 21 Apr 2026 11:06:59 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Pedro Falcato <pfalcato@suse.de>
CC: Mateusz Guzik <mjguzik@gmail.com>, <akpm@linux-foundation.org>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <linux-trace-kernel@vger.kernel.org>,
	<linux-perf-users@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>,
	<yingzhiwei@hygon.cn>
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <aebp06qEMBx3yjHg@hsj-2U-Workstation>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <aeWLCxru6cLWsxvQ@SH-HV00110.Hygon.cn>
 <hshxzebq5y4gavo7mbrgn7qitz5j5wyun73wy7ooiiehzzpcui@hlknbp34sgja>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <hshxzebq5y4gavo7mbrgn7qitz5j5wyun73wy7ooiiehzzpcui@hlknbp34sgja>
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24BD540006
X-Stat-Signature: oyq4es4e44cd6ikfg9i79rqrub18tkfu
X-Rspam-User: 
X-HE-Tag: 1776740827-415074
X-HE-Meta: U2FsdGVkX18cEbOrcxtwBINW9F5Q+OSnwqT00ZTTHOJqagttsvPKmBZKuzpuNcoGSv1zkUUHRn89hN+m3OgB32f6b0bb9vBNA4griWcduDFc0N9BmG/JaW4AF17mCoNCEUdifDKyVCSW2OC8aVLtp/nuufiODmSR7LQ0+pc3ldFEYJE4EByKfvDlaHSDhdViHHji3klkjmkcDM8kldPVp72V+INadjmQ5SX6VlVgs/2oRPF1mN9JfMpUCHHGVU2mbd63HoiI/LJnJDdzviMuFv/qcGPHQrINspJXA7vMU54VOlo0BkyP2mXbwrQ6qLBVwOK1Yv9uwcHUe6arC/eA9CwSlbpXmihEwiMAWfTxe6OfYOHyQeNTQHJvcpPe7TGFiSGArAo91WpZRyFX3o8wzGnpvpG0tMLmU8Ag9nhKbDRqKb9WQKaiD/woYOoY1rMZJ36DKxVAae41aM9psOjuaP+Sv37OtHODwCS7kmaQfYeKjbfr2wRHiX7Wwvo2ZXnKPupdOAkqhu9+nL9htER02J7HAGkWuX+OxaQ6GOGAgM2Xc+TwvErG6TB5QfGaaZum1n9cDa7VKRYgiRTzvSiHIiuFEQp8tWjRRvXVWYKd0/nB38kstrFlvITH/xv0w/DWeYC2BZaLe3M+roVIIyJOIcPjR4oswn9/64LFOjqFl7JKC9mjoA0qvX7HPvJMAtR0vEf6co+yHnD+x963LBMFOnXe1uhKAfW94AoicFfzQbh/6rb5ZdbZXIwN5EQgc9JeQDgde+E1nD0r12Tl+Ij30XuEyDTeYvyDLxTo0YvbUVuwrmpw0CnfHm7txEtnQMJUa3rjhhb63oOdse91YMKYzit6vcEGZt5xsUWHFB5ti374Nx5LBCX6jOxOFsdQdRm6vw33/7Pe1mvOj/l3VcAwV0hJEUh8njadiSRPROfMFaG1Z88PqnccgtvT353A/kAIHQbGvImv8vIwdLm7oDx
 YcPbKQrD
 8FgWQXIktb+Tbte947oF9rvsQTLBHclXvPgQxxnYQ6PMQYsZOJagnc4ReIf9GLKzItZWgTjEjznyIbBZgQ3E0d9S+D13barGkmOggmwV05u9/kMOyhTVUMbwSRNukI9vEw4jRTzSv/OY+dMPKkB4xf9jiTaxH6/gUMZq8ef2X6hy+l9Pwk6LQ+I2rxeEcYdZXkv5ZMIWWR87ETARN3mPXkCDaVFq9E4R988nGqa66rIlH/zV5nt+75IadNg/n2pdQZerOhseYJenfCwpJ0GGdudoZ/krEzu4koI5eC/yK9eeFXGDOdCy3Vx2bwK2qDUmUDWKWHgxXGeuBICGGbPYNWXc43JtLfulyFvvGv4Uj/EhTbQEMehj85sZLTdgEi5H2e/jrRlaAnkHl8szEr5mQW5LTEoP5SSPQuZMP5voMyNKshTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 02:48:49PM +0100, Pedro Falcato wrote:
> BTW you're missing _a lot_ of CC's here, including the whole of mm/rmap.c
> maintainership.

Thanks, my fault.

> 
> On Mon, Apr 20, 2026 at 10:10:19AM +0800, Huang Shijie wrote:
> > On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> > > On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> > > >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > > > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > > > In the UnixBench tests, there is a test "execl" which tests
> > > > the execve system call.
> > > > 
> > > >   When we test our server with "./Run -c 384 execl",
> > > > the test result is not good enough. The i_mmap locks contended heavily on
> > > > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> > > > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > > > The insert/remove operations do not run quickly enough.
> > > > 
> > > > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > > > patch 3 splits the i_mmap into sibling trees, and we can get better 
> > > > performance with this patch set:
> > > >     we can get 77% performance improvement(10 times average)
> > > > 
> > > 
> > > To my reading you kept the lock as-is and only distributed the protected
> > > state.
> > > 
> > > While I don't doubt the improvement, I'm confident should you take a
> > > look at the profile you are going to find this still does not scale with
> > > rwsem being one of the problems (there are other global locks, some of
> > > which have experimental patches for).
> > > 
> > > Apart from that this does nothing to help high core systems which are
> > > all one node, which imo puts another question mark on this specific
> > > proposal.
> > > 
> > > Of course one may question whether a RB tree is the right choice here,
> > > it may be the lock-protected cost can go way down with merely a better
> > > data structure.
> > > 
> > > Regardless of that, for actual scalability, there will be no way around
> > > decentralazing locking around this and partitioning per some core count
> > > (not just by numa awareness).
> > > 
> > > Decentralizing locking is definitely possible, but I have not looked
> > > into specifics of how problematic it is. Best case scenario it will
> > > merely with separate locks. Worst case scenario something needs a fully
> > > stabilized state for traversal, in that case another rw lock can be
> > > slapped around this, creating locking order read lock -> per-subset
> > > write lock -- this will suffer scalability due to the read locking, but
> > > it will still scale drastically better as apart from that there will be
> > > no serialization. In this setting the problematic consumer will write
> > > lock the new thing to stabilize the state.
> > > 
> > I thought over again.
> > I can change this patch set to support the non-NUMA case by:
> >   1.) Still use one rw lock.
> 
> No. This doesn't help anything.
> 
> >   2.) For NUMA, keep the patch set as it is.
> 
> Please no. No NUMA vs non-NUMA case.
> 
> >   3.) For non-NUMA case, split the i_mmap tree to several subtrees.
> >       For example, if a machine has 192 CPUs, split the 32 CPUs as a tree.
> 
> If lock contention is the problem, I don't see how splitting the tree helps,
> unless it helps reduce lock hold time in a way that randomly helps your workload.
> But that's entirely random.
We actually face two issues:
   1.) the lock contention
   2.) the lock hold time.

IMHO, if we can reduce the lock hold time, we can ease the lock contention too.
So this patch set is to reduce the lock hold time, which is much helpful in our
NUMA server in UnixBench test.

If we split the lock into small locks, we can also benefit from it. 
If you or Mateusz create the patch in future, I can test it on our server.
I wonder if it can give us better performance then current patch set.

Thanks
Huang Shijie


