Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7609FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0216B0088; Mon, 27 Apr 2026 09:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81006B008A; Mon, 27 Apr 2026 09:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6FAD6B008C; Mon, 27 Apr 2026 09:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFA456B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:43:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55B6A1401AA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:43:10 +0000 (UTC)
X-FDA: 84704452140.22.ABE204F
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EE67C000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:43:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oTje4ElN;
	spf=pass (imf28.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777297388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYpZWzyqAIY0fKVdx1G8AWuk4ggGTSoGNuwwIO5d2iQ=;
	b=sPA9pJnz8i2n45VAS936fMLMOD8W1O9ozlj0DJdznhTqfkDnvAWjx4ua+IU1iAhI/fA2Y3
	AOht8WxNZqkvwHJ09oOw6Ws+XkX5rBzXTlMRIdGfH7/yDaR/JvHZJKISzmsTUihDdmAnZ/
	rmgLhvF2Vej4el+VMgFHSK3uoryzThg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777297388; a=rsa-sha256;
	cv=none;
	b=TQZNA5fNdLF3q69E9x7O/3rw6eGXOd96Ik1rX7Wm8yDEOoAe5c+FzY6dr2h9l0liwqQi9+
	kTPB9jB7WorIHLfGaEnzWNWocI0LRVg/2uib1NEfMPMPjJKyxyxLjHDB+b3iyrLPrAEWLg
	80Kax5Idmv3+W12CbKDu99cuTdRSpcA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oTje4ElN;
	spf=pass (imf28.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260427134302epoutp0196401e6a027f43e9f7a2a8e4ec37def5~qOo2fjOBb1175011750epoutp01L;
	Mon, 27 Apr 2026 13:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260427134302epoutp0196401e6a027f43e9f7a2a8e4ec37def5~qOo2fjOBb1175011750epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1777297383;
	bh=HYpZWzyqAIY0fKVdx1G8AWuk4ggGTSoGNuwwIO5d2iQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oTje4ElNm4xecU1VG1Jrx86EY3Gpl1Vu+7Eg8igCfRDmuEWp0LdNN4Ssf0cEWBOKp
	 03qrQy7Mwh4wQ/opBqnoORCUo1z8aoZlbY7D0/ViobxGIRXTFLcHW7dWyX9aTsl2N3
	 Eh24v5hHa9Vb0gAdrDBssQHqG7CW+ElPnJnUatLc=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260427134302epcas5p214d5e003586bc14fd5c926391fd2af9c~qOo16jVbi1491214912epcas5p24;
	Mon, 27 Apr 2026 13:43:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4g44Wp1ZR3z3hhT3; Mon, 27 Apr
	2026 13:43:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0~qNwDrt8ay0098400984epcas5p1l;
	Mon, 27 Apr 2026 12:38:00 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260427123748epsmtip257b0d1b83f2086e0e46dbf256b9f1ff0~qNv5BJqIr2057720577epsmtip23;
	Mon, 27 Apr 2026 12:37:48 +0000 (GMT)
Date: Mon, 27 Apr 2026 18:02:57 +0530
From: Arun George <arun.george@samsung.com>
To: Gregory Price <gourry@gourry.net>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
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
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
MIME-Version: 1.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
X-CMS-MailID: 20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----lGFk.c4Zo19QZrlL9e6EpsCdvlY3lrbI5T.6445u7ei3FFQQ=_4f40_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0
References: <20260222084842.1824063-1-gourry@gourry.net>
	<CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0EE67C000F
X-Stat-Signature: ndq3g7wp1fyzaja9ctmshbqd8kcekisz
X-Rspam-User: 
X-HE-Tag: 1777297386-109176
X-HE-Meta: U2FsdGVkX1/MTVtW+QQT4LJHtIq62/9KrHLi3Xm4/fN+fzkiziwzzYskQ2wTgUF9m7+MsThhWETv2ymRYiSJHf1bRCKKbTF3UXm1XruKJ9jBvmb/AzT0hq2ofKrqp6QemgTtok97tUuyp6uxv1L4DAT2rLXY09lPBQPgPXouCOjlGcN3Sg9fwEzm4L3YtCOsCQLTdfFaOQkT7DnrlwkESMvyNzFsvTRhXq+n6r6kADQOVdLzzMkavDe4k/eXf6Z+H+CsAZPH6KF/66wA280AdvKxC8XlRCijMVUT+JnOTCLR4VIr+6QhU0mBO1NQdWLh/DlItptS/mj3di3mOvb9TfQI3pfWaM12WSolyFhdDXC9zbDxHhjniDB6ZjBXHYVDBpbozUFv1iHCughcZpz6r5qewV0aVfpKHBLHlflrayPegZQe5Z+Q8RsCTwpZvKcvB2k2Cs/rgKvN64bYeg+Y0T5AUcIc30KY1dEEU31NRj6mq/kJ2KP3oXIuN5b7p/yI69HMjK/FsNHqoWyzC6xFZGvLlIaeKWwokDs/qoEo6ebLf3bDtWcyM32JqoK/06qYevGwR9MWHOSJOqIAUwwTzYG7ggDYB1hqDJoAtoxDS8nqrYjMBDaNXAnLqEsjJZizr4Jf0N3uc+5YvetlPyfuQ4WAQ/DTOaKKoM2CAlIytoyPnrt0LgPM9aQUeNMceIOr1GR6Mw1YSpGkj+LztiDYz4H1Ws6LiowrIs+FAMRUhShE4TKNB1mTdoiRpdESiYvoXQNRyWnADQfsMbTsbpev7DYZvXLXNQeq7V0RqWv8J6xABgSmONaBtlfOH+avDP8Zq7mhWzwVK28XG+sQ4DjiKwATa2rNM+4lYI3UEQgtAbdUcs7ya53vJHAQ9D/M0lvKAemER5oK/atyLRS31uV1kcjUMcc7+Kc5pyxouI02nPO1AbfqY5uxRWlDHXR18QOrC2Za06ofocFy1vWHNMi
 8PHkpdMS
 i7v2Ptb60hc7t4vG9Fk+VSQJcuqWm6fxXDhJ1URPwy8EVb+o2DAflY7gMYaH812kr6kNj4PAxEmharNck8vzcfPio/O5dpx9J+/s/m/k7ufNoB9jWVslKtAs0TZDDLqbcFkUACfMzICSYEsErvMNmRwESitxPXmcUyjCxzScJTi67dTllfuW0XBonSMur7Qd3G4v6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------lGFk.c4Zo19QZrlL9e6EpsCdvlY3lrbI5T.6445u7ei3FFQQ=_4f40_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 22/02/26 03:48AM, Gregory Price wrote:
>Topic type: MM
>
>Presenter: Gregory Price <gourry@gourry.net>
>
>This series introduces N_MEMORY_PRIVATE, a NUMA node state for memory
>managed by the buddy allocator but excluded from normal allocations.
>
>I present it with an end-to-end Compressed RAM service (mm/cram.c)
>that would otherwise not be possible (or would be considerably more
>difficult, be device-specific, and add to the ZONE_DEVICE boondoggle).
>
>
>TL;DR
>===
>
Appreciate the work as we also chase the same problem statement.
A few queries please.

I see the current support relies on read-only mappings which might
limit the performance. Any particular workload you are targeting with
this (which can tolerate this latency)?

Any deployments you think of where the goal is a capacity expansion
with a compromise in performance?

On the device side, are you targeting beyond compressed RAM like
devices such as memory with NAND etc.?

The TL;DR talked about mmap/mbind way of user space allocation from
the private node. But the allocation is controlled by GFP flag
N_MEMORY_PRIVATE. Does the user space path of allocation set this
flag along the way?

And I believe the bear-proof cage might work in the normal scenarios,
but may not work for all. We might not be able to rely on the control
path (backpressure) fully. The control path could go slow, slower and
even die as well. Should the device respond with something like
'bus error' if the host tries to write when it is not capable of
taking any more writes?

Are there any workloads (VM?) where this 'bus error'or similar error
could be an OK / recoverable scenario?

This is assuming that checking with the device on every operation
(whether it is safe to write or not) could be slow.

--- Arun George

------lGFk.c4Zo19QZrlL9e6EpsCdvlY3lrbI5T.6445u7ei3FFQQ=_4f40_
Content-Type: text/plain; charset="utf-8"


------lGFk.c4Zo19QZrlL9e6EpsCdvlY3lrbI5T.6445u7ei3FFQQ=_4f40_--


