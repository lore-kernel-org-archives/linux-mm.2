Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E85F8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 07:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9D46B009E; Fri, 17 Apr 2026 03:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2436B009F; Fri, 17 Apr 2026 03:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E196B00A0; Fri, 17 Apr 2026 03:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB086B009E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:00:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0BB113C035
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:59:59 +0000 (UTC)
X-FDA: 84667148118.12.2E099E2
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37E84160009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:59:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776409197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UDQ3e422iz75+H385lB4Ltg4ZCuj0AWc/XEDoyVgtKA=;
	b=v9cKHTd1Mk42b2M3kJ4/zGnVJ6xlVLw770vy4+tFytZ5oK9KX8nCr1BpruXAGN8fuaz+u1
	/s3xDMhys/JoNSttFgiaQrv6uO37i5PBJthc1TAQ/KOrvNjggM9SMJmBTTKX4BwxYgysjy
	ZVuDsrmU4tJ0gI+pNZK39IJtYcumR6Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776409197; a=rsa-sha256;
	cv=none;
	b=fL0Udx6zsdo+wlM+rg1rad8hZ75GMRQYKuMUDfzZM3IOP0fxYA5hXWt+nI99C6RTarZ3Ru
	urz1ffF7oT2ah0CdjR6Rtmc/HPZsGnt/Ze9eUVhOXIxY0KdIO7Q7iNMG3TBd0Jx/QNnRxn
	ycO6kTXz2y7qVQ6xsStVwiqyNOd6nsI=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fxm355c3TzwvXZ;
	Fri, 17 Apr 2026 14:59:45 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4fxm342Yk4zvkdy;
	Fri, 17 Apr 2026 14:59:44 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1F23A16E2;
	Fri, 17 Apr 2026 14:59:44 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 17 Apr
 2026 14:59:42 +0800
Date: Fri, 17 Apr 2026 14:59:41 +0800
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
Message-ID: <aeHaXXB2+mla7u2F@hsj-2U-Workstation>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37E84160009
X-Stat-Signature: 6z1j3wmi74tb5qgkc9zgwugncqd6o4u9
X-Rspam-User: 
X-HE-Tag: 1776409192-175970
X-HE-Meta: U2FsdGVkX19l/G2WqGUu4EzMzxCKKhIqxEcw/ugsomiAvRoGT/GPwiENg8Io1QUZqQKBhFwzsvR/aEXwSaJRgwJq0fjptxhCuDZlIZkVvOue0ZOduJslafeYkpmvbwsIU+BYWhbsix1BN3M4PuNZeNRpASM6eLJ6j84/YIrRqJY8xg1lY1yIsi53BCZRCkkuBdN31UxuaBkcv9gwAmvunqWy5keM9O4i2+JHbDdzK0yADjgJao3INaf8mD7sy865ofSykD9CTrNIlTriyz0Xwr5W9M7KApfJd7GGWnwCq42YKINywHq9gRi3v8I9iUI5TjgBBT6ruK6peDMAaqrCC8ez/9gZIrvDBobokzfSf9BMByw+Q9VOWUK5e1RQ3HyicnsBQfLd/GtQW2vMAaevQuMOg0h6fNzb+PU+BILKo59EvNRUpiS7gHhWuNh32MAI/8UhcC2qjBzxikKSFvF4Z6xAj/vMNfk051y9wl1dmAoB10cZp1704h9DBmYO35PxzlLkfdwNfbWnT55jaNPmJgfgbBhaKRhkj2P605OfqDkKM+/Yw/yNSF0HoKYKp3ud7rO8TlmvVcK74F35Xd+XoOocuXEYv2ptNVtGRyFL3fPV55Vk+PTAbiDzJqMgiEpiu0ky31NKVeuZjYNYvwKJUR50zRYvGTdYVYgbd6vL0YqWxYzNNku8IlWPxsaBa3gMjBg0VgGuoP0+6+Eo/xuX9hbeWB8RsFPsJ7T3PZRFYCo6JqVm61jsBnrLZUFb4ASCQ2jLUv3TNQ+QeMy+NkCR/qMsNvr7mdG8MTJv4HEK2e22TmI91qTgkoMzYMf7+RPufbxxQDlLumc6aajy+jHValJH9B0pkvD97dtCMhNUzQ+UBemr59VDv5sDQ3CLy4aslQJXjN6sbhixWk2qxfIlQfTH1IqKflIY6czdYKZMBguLPzVcn4TU7qiX+v49yplwUjBhL78dhIGaKE31Hgi
 SjUv8nZt
 gVMVbe+KT4Zjk19VKxWhYOiYyXkyLDkMXzPMsxTWGkaEDzqokxmmWohfuk09fW9RZgaIRNq0IGZpq3FwWg59qCGUhFTGEGDI1iGcSi72R9Oycz1OZNNatDWYuKd6YgUVYjwG0q16fColkcRmSmavCFtHFki3qxx7fQ5tkxmWpvKMgL1pNQW30JnDWFrIeZPzhlO/T54iy8yRUc+xkoBmlUF88YMYtY6BIjlJXbMENgdZb5Iu0VePq5cjP9aldfUpmL44YM8qG84zGxPX7D5u3EgziyqV2ipSprFuISgmZQbPirvS3IqAY0g6AlF7nxb9BoT0YzPLs8+rNOC3z2LzoK/Py6ZPs5eV//gsJTJpZOcjuOdE4IngQXF6MV0Xm56mNe8VNtPordDIZ0IFcLyOr6YtS8x6LWggLHDJ2BnCm0WijS/Q=
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
For your proposal in no-numa, I hope you can create a patch set for it.
I can test it in our machine.

Thanks
Huang Shijie


