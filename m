Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A426C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323976B014D; Thu, 23 Jul 2026 04:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4F26B014F; Thu, 23 Jul 2026 04:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4E66B0150; Thu, 23 Jul 2026 04:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC8F06B014D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:45:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62DEF403ED
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:10 +0000 (UTC)
X-FDA: 85019406780.10.821E25C
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74EAC160004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=W5gXIxoD;
	spf=pass (imf08.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784796308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQjXIg3wAcrT3mkYCsdbl0LWsoOlUsvvM9TLKCcGrBo=;
	b=x8nUpHv9fMjtX7TVHTd2Elp5kNTt9aMEv6gUN1chjo+EBJpIY/61KmnB8yVLA3hBlxyDBW
	Kt1u6hJwsaP9cyBdCpO3Mwz6pZSZSbSFS84EhqWSD7OiLixMUQZaDfY+M8Y6H1GowstP8l
	B9TLdTLjF3kkq0qsngBrufRhaioQg2I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=W5gXIxoD;
	spf=pass (imf08.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784796308;
	b=MURLrVWHx5KEoT68SqhE1adiRnhFbxvC+kRw+Cl1qt2lK/Qf1Sl3VECeoAQzzC0YXYcY4d
	1gdBPrrnLAi0kD6f3KEDuS9f5F+Gg2QAvcUzDlPsnx+4OfK/oR4ljeDfQ6wPQZjCoLiEhx
	kvCWSmYPFgWqvUPUz+KUsubpaiJA7aE=
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260723084503epoutp04a324084313ef02b272e897115231c5b2~E3sg4KZO-3034630346epoutp04L;
	Thu, 23 Jul 2026 08:45:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260723084503epoutp04a324084313ef02b272e897115231c5b2~E3sg4KZO-3034630346epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784796303;
	bh=sQjXIg3wAcrT3mkYCsdbl0LWsoOlUsvvM9TLKCcGrBo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=W5gXIxoDyG4Nfrz0+i0pklqM2q3/qpEunf4JU/SLOUtj2VknFkftcVuCb6c5nB9rv
	 0PfvO1yP0f71Cs1IOmIxhbGH98MahM0XyvQigBVdJ9zrXWw6I7OJvWLRpHZNA++6Az
	 8E6N/DHVyIA5A/LbAByxODYxcLsaYG1fyL2e0bnc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260723084503epcas5p43df5d820cf5e5603cbe8d66b060992f0~E3sgfyfxj0540505405epcas5p4A;
	Thu, 23 Jul 2026 08:45:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h5Pnq2p8Nz6B9mQ; Thu, 23 Jul
	2026 08:45:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260723083847epcas5p21a735796de0bdb6459cd2c3b7b9b18de~E3nCLElTK0474604746epcas5p2T;
	Thu, 23 Jul 2026 08:38:47 +0000 (GMT)
Received: from [107.122.10.65] (unknown [107.122.10.65]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260723083835epsmtip11766a99123bc01993811bc8746be0d2d~E3m3Il4WE1438914389epsmtip1e;
	Thu, 23 Jul 2026 08:38:35 +0000 (GMT)
Message-ID: <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
Date: Thu, 23 Jul 2026 14:08:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, balbirs@nvidia.com, brendan.jackman@linux.dev,
	yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com,
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com,
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev,
	tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca,
	jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org,
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, cpgs@samsung.com
Content-Language: en-US
From: Arun George/Arun George <arun.george@samsung.com>
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260723083847epcas5p21a735796de0bdb6459cd2c3b7b9b18de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
	<20260720193431.3841992-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 74EAC160004
X-Stat-Signature: yrd5kix53ak6a179yng8ge35a7egdjme
X-HE-Tag: 1784796307-348347
X-HE-Meta: U2FsdGVkX1/JTRVnYCujnAEwxKBIUA2pObaBDP6tAra5lqPksGwwyi7lQtWPn5UH+xv/uooWVKtCwia351EfJ4qur8lsefEOFSKugJU0mOcJ0frbmC1ys33gvs1Ybh4shlPM9LACVlKxbxEatR0crMcQcAundNIKp5Wu6tFeImXxSza1yJSUA2VE80lUGw1HfFo1FjCjj6t+gI4rToe4hUyYDHhueyuGowE779HAG2z2+L/wfHOdxYsehxpog7Bx4UnIeLESilvVnZbfTda9vxWwHT3VAyeDwPklrQIQjuatflMCSKMJeMwQujfuVEZtxOj4NDcb+ZlDfxYcYi4pJXhNt5Cm9iUwQGQmHtra66wQ622ctadnuwEaqAQKngniii18twuNw9iXfvraHJpskXAiPLJ26CKi8WQ5JUEylCwn/5u9CVPmZSW2evuNcqIi+D2sdzkXzjhdc5rnQ8qq/czH2BQtgtORjvhDfjUyrV6CwppPovffhw7QLA89nVpl4xq4h5JKY6GqMx/A40hlgMgSBhR9p0Q0Vr0aIZTpb/onWKZzCX+ouFFSTYT+RxQvOLwlXK000lWKH+WeeTkw2BQhfSGbC5VbEXL/cpOiDfhrbFEP7dRiWvp0bYe9lFd+HQAMhn8/2zdlK8B7JWy3WijIICmXhyu3Xd5H0I8/etQgQjd+ueyprv4jLRa9TjPdbWVXOTtXafPT+zbLKN/tdgEDySpZc0QlUZbb44xItjuCQLhgjEeDyJF2SAM0KtLWnLXEjOmBpR/VMQr+BoGzglojEV/h2zF8dbjhzA9DS/Z+bdVQCYQrxcUSZV+NjQ/jDl+cVOdY0f+rpcmf0xUKRzNP7LKmCRVoVmxHDW4OhJgf4x4Yv3I6qnYEJsO7wqJE9/A27urlXkRYz5t0viHVT4gkHLTql3sXKnWXhcCvJYVEXS+82EjoSWJ0x9LTb3xSHoRe7dxR+JW6j56vjE3
 CvMJsDnR
 9ZuFvbFrWtefmXXq7Nb24jVVNbLhjH0QIY4ty09/153IW5quWZFDfzBawRp1K9JUqEsGJg59+J5zJ4+o+IYEbx/brOVwHtJ0lTprZsl+WPl2NkTShxZZEm67rHGHfyeL9lzjyMqUx2sepPchDyLDgbcVsJI91OkHGQSBI7nZWfyrTMAur53GWqWpm6GM4QGI/4dsjDwNFY+/LY6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21-07-2026 01:03 am, Gregory Price wrote:
> Changes Since V4
> ================
>   - dropped compressed ram example from series
>       - will submit separately if this moves forward

We intend to test this series on a compression capable CXL expander 
hardware. Since compressed ram example (cram) is not part of this 
series, how do you suggest to do that? Do you have a version of cram 
module compatible with this series?

~Arun


