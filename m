Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F228D20688
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B42E6B0027; Thu,  4 Dec 2025 08:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C036B002A; Thu,  4 Dec 2025 08:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8336B0031; Thu,  4 Dec 2025 08:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FAE46B0027
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:36:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D65E131305
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:36:11 +0000 (UTC)
X-FDA: 84181887342.16.F42B75E
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7C7E14000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:36:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rh+EXQz5;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764855369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvSG6kYMPnVqioq2FxZSj93YJSFBOQAlFZy4eN5bxag=;
	b=AMmkh5YxZOBLiypo1IOHCkisRNqAocJwCStxago8hG4CIOGb9XEfRKJ5KAnkeMPo8UNoFk
	uRUjcUJbGTm+N0DlEpKHIxIxzWIXwugs0xq/9U8TYuSGXhKhNaGtDLg/BG07dF8NQKxrzd
	P8Z70mrxWzQASfTmpCnfYvYCZZnZV2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764855369; a=rsa-sha256;
	cv=none;
	b=noNeGCDekbJ6vfqqO27Odx9IKpjInnWmaE0+YGhM6U5cId8oj9Pi2Bq5j2OKYMHqpWU9PG
	eJPaJpxvCoI0WvkrHVSkhn44r7+jkrPaKIYOPOeIohqjWsh87bmm3D+eztl2wtZ/starcU
	3B7hjEm97d2esY4rZoEO8pCZXE/4nRs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rh+EXQz5;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6320fb67-4ed7-43c4-a4b6-48ebed2b473f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764855364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cvSG6kYMPnVqioq2FxZSj93YJSFBOQAlFZy4eN5bxag=;
	b=Rh+EXQz5eAoN88EoHzwiYORvMwIKZLeHA+SlotL4leDn5GF9FaJHFSld2QwqRo9v2S/S6+
	J2K2XPtVtSPGA0r92eQU2Zr3ZeY1Q70mLeevh8daRmvyjDkbwariZFv4wUvzHCk952WTXY
	ocjPEG/GwvhyxvQekIEngSjWiJM67BU=
Date: Thu, 4 Dec 2025 21:35:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH -next v2] mm: vmscan: correct nr_requested tracing in
 scan_folios
Content-Language: en-US
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, david@kernel.org, shakeel.butt@linux.dev,
 zhengqi.arch@bytedance.com, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com, chenridong@huawei.com, hannes@cmpxchg.org,
 yuanchu@google.com, weixugc@google.com, axelrasmussen@google.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, yuzhao@google.com,
 jaewon31.kim@samsung.com, mhocko@kernel.org, ioworker0@gmail.com
References: <20251204122355.1822919-1-chenridong@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251204122355.1822919-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7C7E14000E
X-Stat-Signature: kqymymw8nh5iuooc35nrzrjmadxokiqc
X-HE-Tag: 1764855368-193958
X-HE-Meta: U2FsdGVkX1/mN46HCzzYjQfQ3nTVotio48FcGT4IjxSakZNTjfRJEC29jE2+eUTfR3YDJHXP9QTre6t0eo6f40FKefIW+RFeA2xwBZkNrzUpnzGB48yKnGql/QgtGwGbe6qzTbTwpgxhw16L3sVrSIjZiwMe+Xo1L0QAwAGltwIjum0ebLKl7tZ5v/VIZQGCOlRY5XVfEGkeLTY/3tEyZD2wVXcYDOgi7r5/5bWuV5XyTfzeiGSkgn6CTGxgekjMz9lEmEMxVCj0xOYGP6ittmpfjv/b61R9rwF7FSFrBYlbRtys8kZY37CENT6N++WzWLEJblbivWqIn0M4KBL13UnW4ksgZzGvgKxqDotfDafRazA2Q7e7H+6aitIIeq/UrmDtBS4ya6qp0286f1JJKc/H3xQNZDYvcBd7a+UCa4v2ZoQpOSgLawbHNwp3qQKlVNq+q52ErNItfxuabjljZgQaq+4aoiZlwHBRA+yPQ6pHwye/vhP4UyZ7JIzKJCVjv0VhvPseIEVnyRtVMHMMozb1MA/UMP19F3iH8TIN1iiBuXbI8Kjrr+blXHwHo4gPamuK+K6jPkYZcRq9v++XwMt1xLTDscJD/B/WD0QXBrvPI3+o3OHcJgMYVvtrGkRQXzF67GBlXcVRPD85KH6eZ/im/vCCZok2aTzd1EN+9wy/J4qMnn1OB+KsyJPkIyFnegIK7Z04KupU6k3NZYAqvDz23V8ibIpSYzsmigMY1u2WgJuAODGPlxgV9kKo7UYudsWDzu3z7PUIgEW2vG1T7MD68JX2o+LkhnJuNKqBdxslwlR6jlMLVVSoa+odYr9Eyvxq/kBRT+D3e2RJ02t2FtjvOTrKJ8F5wQhK5qzgjj68U7fFQ9uVcNflU+OXzKGLbCMAKcYSbB3WXLoMplTx4cbOCRRZQnPuoN/xQ1uO0CxYxIwy0ZPEJleBEqCR1jg2nki+Gp9HrHJk/3W0CHS
 WAtSHQAt
 Lfd6KAUbZgrtBrWCUjnvEXX+GiT4sdv6LymDodKFtQH9Yq8hwsGQ3Xsed5XEqWNZHCDzPoo0DUZbzOCHnqNlqMDtiBruRCakIJtq8DyGg5TRacXQTTt4QHgG/lVxXUIEcu7rOuUPDYWrmLTbu6Ulpf1XnN5ZnN3Vagts8xPi2RYzaf42oC8/Ds8OOjximp3vxMH+CB7QlMOLaLOPGwkPtC+yoXL/rCRKz5z2KO2aCOwZZ/k0k/BBK6vSynQ0Mmf4OMwQH2AtanIskr8a0/YLeFxFcNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/4 20:23, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> When enabling vmscan tracing, it is observed that nr_requested is always
> 4096, which is confusing.
> 
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> 
> This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
> constant. To fix this, modify it to print capped valued.
> 
> Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---

LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

