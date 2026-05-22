Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EE1CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95AE16B0095; Fri, 22 May 2026 07:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B9C6B0096; Fri, 22 May 2026 07:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA106B0098; Fri, 22 May 2026 07:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6950B6B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:38:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1557040A5B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:38:09 +0000 (UTC)
X-FDA: 84794857098.14.44DF358
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05FBAA0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:38:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=JERPYZtT;
	spf=pass (imf25.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779449886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9XR94YHNMocWUFw9punBQGDBFYxc1lt25ZEVZWgtac=;
	b=UlUAnbtk3hWWGvkIYYGkgOfcUHtIu75nPucE2A9bC5arhkkqeWP5PTVIIG3kdbjuK52OMV
	UFoYw0uf8ZZhcz/PlXMTJFIcRsMyJDkcz8th17hQgwvs7e2y3wmv69dLAGAhBnCfNtHziA
	XOpfsjAwViGueIdc0oeDRYSbnZO+Nns=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=JERPYZtT;
	spf=pass (imf25.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779449886; a=rsa-sha256;
	cv=none;
	b=ywGnYgxADMLYGJovJYfuApHuSiMzHVbKwBYrSeIwp+Ni72aWIXciWAnthmytty3ELXmRV2
	6sn7W+1GO4dIWtDBb1yZF0bUTf/OeWk7JUe74yt0r76mAEBrq0n6ep+JahIZvMHX0s63zJ
	EYPBkvqFfBqgah12CgGqxQdf2JyWld0=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260522113802epoutp047d45dc3660ab4d2cdce57be27d46d659~x4D12kzVZ0577105771epoutp04e;
	Fri, 22 May 2026 11:38:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260522113802epoutp047d45dc3660ab4d2cdce57be27d46d659~x4D12kzVZ0577105771epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779449882;
	bh=X9XR94YHNMocWUFw9punBQGDBFYxc1lt25ZEVZWgtac=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=JERPYZtTU2TlEprNnCJlv0WM7hhtolUmAJHHUSjqwurELxRa/onqsWy1YDtIN+8xj
	 +MRV/ZDvXNq0x1UISaIT5DzyMNQLc2ARA7V98cZIDNSHBwP9Pl28ac/y9dgft9Nee1
	 aqj+yfQb92T4awPevYqHuFEft5mQPyEqwKj12DkU=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260522113801epcas5p3905b503bc0cfbc37e68be912f3324730~x4D1cklL90648906489epcas5p32;
	Fri, 22 May 2026 11:38:01 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4gMNZ16HSyz6B9m7; Fri, 22 May
	2026 11:38:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260522084048epcas5p4778c8dc9ced70300473adfc67f24098c~x1pGJAfr53182831828epcas5p4i;
	Fri, 22 May 2026 08:40:48 +0000 (GMT)
Received: from [107.122.10.65] (unknown [107.122.10.65]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260522084036epsmtip25fbb927d3a064212cc2ad4bc1ee9e926~x1o6sdf2f2396423964epsmtip2V;
	Fri, 22 May 2026 08:40:35 +0000 (GMT)
Message-ID: <1891546521.01779449881859.JavaMail.epsvc@epcpadp2new>
Date: Fri, 22 May 2026 14:10:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	longman@redhat.com, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
	riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
	roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	zhengqi.arch@bytedance.com, terry.bowman@amd.com, gost.dev@samsung.com,
	arungeorge05@gmail.com, cpgs@samsung.com
Content-Language: en-US
From: Arun George/Arun George <arun.george@samsung.com>
In-Reply-To: <afmgJcFUjQLYxkb5@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260522084048epcas5p4778c8dc9ced70300473adfc67f24098c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0
References: <20260222084842.1824063-1-gourry@gourry.net>
	<CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
	<1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
	<ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
	<1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
	<afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F>
	<1891546521.01777901881625.JavaMail.epsvc@epcpadp2new>
	<afmgJcFUjQLYxkb5@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 05FBAA0004
X-Stat-Signature: 8ruf3bsbaj1n8bmosfnxerukccsxtfag
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779449885-842596
X-HE-Meta: U2FsdGVkX18DDLaTJkNmwcT+RS8X3p1v/lbEdxOA2J9eHF45dPHdCjre1ajRWtuR8FeKLunm3Zeb33SJaNhf7C+Q3h79U1/7e+bpx+9wkQuYNFAzXAsZH0jid7NVMapvTYm9aWGsHl+NUwXkHaLd46dYDW1JxZezIGCVz5HRA8DmiHq/86b1KxLDmKsC26h3/KTpFcGQFVZxOsp643JTH600HfPJBwvNO9+IB9N+fZfVC+Jv7c/HANaXenpm3Zy/74Q0rN8r2UsD0Zdm3yTE2rzhUGWHM4GCjKrWEldjAV0bbnlDs38gH59zeW0v2Tgp2/bkWPmsPnLKQblxwZQDGONLg0wBfhCOZQQ75AWbailRXkTNPeFyh5YNJ/osdq5uq42cDONU1CiqPt7Xdy3+0Q0QHFNf/7vLwdShLw4aTz2qUj1y76aSwUCRTtgJZ/SH5hzwo21fpD1rShrLWMk2t5uSWs3ywIPndecufM46IkU3/wcrHmMZrh0eOdw+OMtcRZ/m9oXczWMkMoITTos1OGnVBFcnrYF+DsHa6xbGhAkwcmnqZaIZAhRv+phHGtPxvG5R9ENHqscxJ+eA6ke3+7s4jP9KC48V2rbXASYhL5k8/dzujqezOt2UhZPr+Iy9U68LsntdaLgr4N90TLupEVY5pHKJ6Gm6qw/1wjCHZetg2wECB2+y8aYynwrslV9Hg4JFkUl0MhXJvGka4SMboGTxYB4H/vQDB4tUAlSqcjwRR8HbRT+i093/XPJz1PuYBcxKZkm15qYrBS5IigzMpSfGEz4zBoih1wos79Qu/e+uQcpHaYxMR/Pl9FkoinJtpnUH6HlEIh0xIXdWqOs8An+XyeMkUXT2X8/iqipl1RaKib+iColFs6COa3lDBKiyTL2FPmwpVwNjIz+mCnqO1FWa/y6zEtt29edEyHLTTGXaRfxYQ3LGAb41/wYWP8Me5VONdIjTuE3sYEjHLL9
 9jXv+oKA
 v/ZlSLP6bnYmIQkS0Bag1lUl+NzB4TobON76M6BCpTMQN6ZwSFuCR27CHewIYqG0NbORBIyC4l9I3qkqHl/4vmSnVX5fbNscgxcbxeOqnAmO6bB+CiC0LWy6t4+DWo2oJQDC26nqZVZXkJP7JVdofITIPjJyvGIMfkh6SYfkUmtOYhWMiMjeGgVXMQlprkJkn5cez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks.

On 05-05-2026 01:15 pm, Gregory Price wrote:
> In the scenario i'm talking about, a "write budget" is defined as a
> number of pages that are allows to be mapped writable in the page
> tables at any given time.
> Agree. I was also in the same context.

I am trying to bring the device perspective here, and would like to 
discuss a few corner cases and possible solutions.

As I see, solving the compressed memory problem statement has these 
aspects mainly:

1) Allocation control: private/managed memory concept.
2) Write control: write-protected PTEs, write-controlled use cases like 
ZSWAP
3) Proactive reclaims: optional methods to ease back-pressure using 
memory shrinkers, ballooning, kswapd, promotion etc. These methods will 
be triggered based on notifications/interrupts from the device.

May be they are not enough to cover some corner cases for cram!

  I believe that this thin-provisioned memory infra is susceptible to 
'writes-above-media-capacity corner cases' (because of not handling 
device back-pressure notifications in time) whichever methods we use in 
the kernel. Even if we use write-controlled methods like ZSWAP and 
pro-active reclaims, there could be corner cases where the communication 
with the device could be broken and the write path is not aware of it 
immediately. Note that OCP spec [1] says the device should mark the 
memory location as 'poisoned' in 'over-capacity' writes.

So I have the following proposals / options for this scenario.

    Option 1: Poisoned data management - This is about accepting that 
poisoning of memory locations can happen in much more regular frequency 
here than regular memories and we need to figure out potential recovery 
mechanisms in host (not recovery of data; but recovery from the poison 
situation). But I guess folks will not be okay with it in general, and I 
am not aware of any workloads where data poisoning is tolerated (may be 
caching workloads?).

    Option 2 (preferred): Device assisted write budgeting - This is 
about a device aware / assisted mechanism for the write-controlled 
use-cases (Ex: ZSWAP) to know the 'safe number of  writes' that can be 
performed to the device (Or allows to be mapped writable in the page 
tables). This could be like a 'token bucket' algorithm, where the device 
provides a 'budget / set of tokens' to the host. And it need to be 
replenished periodically in the device communication code path; and if 
the host does not find the token, writes cannot go ahead.

In short, the communication with the device has to be maintained to make 
pages mapped writable. For MVP, this could be a simple constraint of 
checking actual device capacity periodically to replenish write-budget 
for CRAM. For other users of private nodes (GPU memory?), this 
constraint may not be needed at all.

We are planning to send an RFC code which will fit into your CRAM infra 
to discuss this poison management approach further.

[1]: 
https://www.opencompute.org/documents/hyperscale-tiered-memory-expander-specification-for-compute-express-link-cxl-1-pdf

~Arun George


