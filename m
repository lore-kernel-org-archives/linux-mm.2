Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A340FCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 05:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982B68E0008; Tue, 23 Sep 2025 01:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A7E8E0001; Tue, 23 Sep 2025 01:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8976C8E0008; Tue, 23 Sep 2025 01:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E8E8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:05:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA58EB8333
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:05:15 +0000 (UTC)
X-FDA: 83919326190.28.C574CD3
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id C49874000D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:05:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wfMr0eHe;
	spf=pass (imf01.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758603914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Onfd9zYeL+OEf7fiK3TSj5PyIeGLL4m+H+3TpOEWGw=;
	b=f6OPeWXmfCrr6opSC+BbBkomO7SxEwW43YbRt/ywhRfUhPMytjw61iYfgclIMz5LzL6Shy
	pZcCBHrgvQRTWpxB7cTcsKh0V0z3PdUGg/1gNuYllWyAdpujJw0hy75oPP4kmDJS6sSbTc
	Ol9llo7BYa5QeAm97CCk0LiGi9NliWM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wfMr0eHe;
	spf=pass (imf01.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758603914; a=rsa-sha256;
	cv=none;
	b=w32f5M+kITq0y76w/9RTorJjXk5iMSBm315dRLB3kiXqlJ9TTLwWCLxbM0ODLSljEyCNqL
	3Erc28eKEaK8Gaat3LXP/vf61fM25tFDUiuELBY+2vDeRr9qoCmWoiD9ALrPYZ6SxM/HqI
	dossdjZ3KXncPwl7A6j8PWXV6u+vAFU=
Message-ID: <188710e0-6683-4bc3-af64-9ce1e8ae4b32@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758603911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Onfd9zYeL+OEf7fiK3TSj5PyIeGLL4m+H+3TpOEWGw=;
	b=wfMr0eHeLbrLQ3sqtgI2OVXU+fV60p1sUB/DRs87DoUK/bMRNC4UeVwc39oy5L5HYtrIPB
	UuGFzBIT8H/WQDm1hHKQaQgxnfYPN588eHXLx3TqjzoVP1ycc6nan7+cJ3fYu108XfXhnz
	576/7u+y7X6gLaAvm4NFwihKHjXOiNo=
Date: Mon, 22 Sep 2025 22:04:52 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc
 allocations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
 Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
 Chris Li <chrisl@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250921054458.4043761-1-rppt@kernel.org>
 <20250921054458.4043761-4-rppt@kernel.org>
 <8f893019-bd87-4f54-8238-acd8fdeed051@linux.dev>
 <20250922160836.8d0dc984ff0986b3809c9ab0@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20250922160836.8d0dc984ff0986b3809c9ab0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C49874000D
X-Stat-Signature: 3gzw8uj79k8f5gu331kirpsn4inj6k46
X-HE-Tag: 1758603913-756046
X-HE-Meta: U2FsdGVkX18knimlhhsKo/r1p0IvkggflzZHUWFjHQKsvmQ7q7rtN/foSHC324GNlHFO2UUsfNUrR7wvzdGZ5ECWsujXDyYek9PaQuHzKGYZXH4kJdfAgacf8fUIoKb/sWzMXajriG+u6p/kM9ZPIEkort0HVwVkk5nDPyWLShbV6760REQejnnm8SQgVQCSuehx2XbA7gOq06cQD2ZZsxzAhgyzNNBbozGNPUqQHk9tsDIWmcD/xy+2u1zywuErfWw/kZ3xP5PLLPdxxMbKUvUril4g5Y6rCQvB6KV6dJ42nTYLcy1egtHJkoi5o4ailllk4yVuF1P787Ql6+Kca+9owo2OJhXZIcw+Vrf8D33wFdlx99zrj6H2J9Qc+HdV4O/zBakyugH0JJ2D3BryN9Fr0lUjacnzWazO77ohDkpNfDN3sPqMnm8ELKTkA7583HgP2gYq2uEv+ms423SezbPwkjhQb4jhrr8UGyb/Mdycwb9a+7dzPRgflyh2qcxdPeC6Ei4wzlT7gdxDZzqknfK+PQVNnfz6hiTDCh01HeYIbYWSapJwGPfRcWTW3ZypzqYotGqJPH4Ef5G0S8bBLoTH8d3xovk5YaTRXrei1FDuSobgeA28rrSW13zE/aHwB2XQ08VDYfp2rpYmXRDuthhFTJ21xZi34sz4jAJDRhR2Ywl2kE7gyG1Vhk/1hMSiyJqaOSdKGhsuq+rP6PSW2QV/jhqd8MQimAUVFaqY1tKcXM4C4N9W8eyGEZQ5LzO1tN1BuQgh4u9ojUDLg4Ba9dq9HND7LH5r2KrzJecYYoRIuvsMv7O1m9gEE69NvMl500KU5ydPhjWhcSOLLNgqxND7gdcwJlBCEfpyfFrLUNkxf+eEe+mEMKae/lUyaUr2+McYy9mb07WTCP42pO+vgzb4jbZlYfyHbdLH5bcHRW+jYkp0tm1OKJNkJCbaevXm2kOfDtnZb9DTJxO/vlI
 RZj6BywG
 r5n3ogtePn+G6ewfAYGzVbATj5l6MZ9yqk0oKTemOYerP9+99pIhosrINqRlG1lBjSO8UaVIkGPOL7X8+JqXRL+t9Q+mt86Ft3r13KfIoJJpJz7cMBR0FjDfpwzUX4gakw7iQ6+bLZqe3tej1eRDG5JWi5obp55RAVgoChoNpvvr0DIFrzWx4oDx+BpLDasOsU2zHkgiFwxk2Hsxv+ZTAdc2cWqPxCkzQvtSnPRp03CB83GU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/9/22 16:08, Andrew Morton 写道:
> On Mon, 22 Sep 2025 15:31:42 -0700 "yanjun.zhu" <yanjun.zhu@linux.dev> wrote:
>
>>> +int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
>>> +{
>>> +	struct kho_vmalloc_chunk *chunk;
>>> +	struct vm_struct *vm = find_vm_area(ptr);
>>> +	unsigned int order, flags, nr_contig_pages;
>>> +	unsigned int idx = 0;
>>> +	int err;
>> This is a trivial issue. I’m not sure whether RCT (Reverse Christmas
>> Trees) is used in the Linux MM mailing list.
> Not as far as I know.  Some like it.
>
> If I was to have a preference I'd suggest that things be laid out in a
> logical order rather than by column count.  Group like things together,
> avoid use of unintialized storage in initializers(!).

Thanks for your input. I consider this a trivial issue. RCT will help 
make the local variables more organized. Since the Linux MM code does 
not currently use RCT and prefers to group similar logical variables and 
initialize these local variables, I am fine with the current approach.

Yanjun.Zhu

>
-- 
Best Regards,
Yanjun.Zhu


