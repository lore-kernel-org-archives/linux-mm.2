Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19A9CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 07:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2D36B000E; Wed, 10 Sep 2025 03:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A8D6B0010; Wed, 10 Sep 2025 03:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7636B0011; Wed, 10 Sep 2025 03:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 874276B000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:21:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D9021DF289
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:21:46 +0000 (UTC)
X-FDA: 83872495812.06.FA50347
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 040CB160007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:21:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1JsHXZK;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757488904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAv5/wmgEhBxyGGZDq9dVoGWNpR4NISRNE5iBQbxwr0=;
	b=f9SDCgErIhhul+5mVwXEGuX9doa8VGj87e6/1yYHNaJmBzUOVy4QhvJrINoP06I+gGeaeV
	0N4pZ6Mj/BIEXdyLb2/eUgyMcjSISpz7xpCurLiVKovNt5HGfGM2FLNFF2kLKPn9gg62iA
	wYpd/gTGpWgvD6CQlrtXHtTFZ23mz+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757488904; a=rsa-sha256;
	cv=none;
	b=RvGZDxfnbl492DHVfVM+o0l9GpDHO/7nIOfa0uxXjP+9JAlE2Zh4pPnlHTE0Wee2SBN5K2
	cYGtlHnz4PjfKz/Y8N+yMgJTE20NKWLSc+WLmpk1UouQhWeTEUPoAEF6n0SKJBt5tZDXeR
	F5/zuIdpI5Z97JtDq4qB+lr9JZXslsk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R1JsHXZK;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f3c790ce-c324-41c2-8c24-0785076ed642@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757488901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAv5/wmgEhBxyGGZDq9dVoGWNpR4NISRNE5iBQbxwr0=;
	b=R1JsHXZKAHoopuh+8xShMw+SCrTjEhON3EEyKfiPutR/YewjydNo7iet+AGgETh5L8cOdV
	CTPIgJj9fQOUYNO3NJF33I0UgFNMGet3CwULZHpxHeAwq1kNqNk3CFfpPOKoptodNjwyad
	2dN15XdyCZggvLJMdKDfVpniXg2NprI=
Date: Wed, 10 Sep 2025 15:21:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 Lance Yang <ioworker0@gmail.com>, shakeel.butt@linux.dev,
 rientjes@google.com, ast@kernel.org, gutierrez.asier@huawei-partners.com,
 21cnbao@gmail.com, daniel@iogearbox.net, ameryhung@gmail.com,
 corbet@lwn.net, andrii@kernel.org, willy@infradead.org,
 usamaarif642@gmail.com, hannes@cmpxchg.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 david@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 npache@redhat.com, akpm@linux-foundation.org
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-2-laoar.shao@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250910024447.64788-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: umuimwsu474nxbo1wrsaxmqhiwg6ktcn
X-Rspam-User: 
X-Rspamd-Queue-Id: 040CB160007
X-Rspamd-Server: rspam10
X-HE-Tag: 1757488903-772698
X-HE-Meta: U2FsdGVkX1/WgZH2B9SvE4S56XYHR2pUeYu3CwjUzyheLE6GTtLIxLucT5Vxjttfgj06bnjV0k9odOm/BpjfQWaUEpLkDuvgNThiXr0kS+g0mDjkML0I4/9X//CBthQuvQYi6hJlJmfh0Yjh4nEXOThXyjaUoMfWK7rhMcYbQOCgGKcsBCfSwb34t1BYStxLO9+7vTAoq0dKPSzeGVoJcGerFy4OQB3DLbzwJz4Gyg1wY0n3FSaJ5PCA2vjpfK2nHxM5nvySFEsOgvZyQXTxyx6nvzWuBVQIbRzIGjxNZwjuhJEuHRO1jkn8zNOygWy2N0mlPFCj2EDgcHVtmcNgRLQkDvLFnbw6+RpbTBAty7diP86T24okXMSlwGra60/Fr/mAzZ3v48EfigEtdNoFPkDVNi+1WFl4Qkuy1U9YGYnkHexwU8NWCYSM1fl/CczgVIw5dXRdJ+wQpgT4itPIJYWWVNsRYt1AdFcDbCTXOAaOdRJQAJj9WiM2NMyG4GFu1KXNPd0wH1hgP7o2KqECl7hRfegeY5LZibrFrcS+6kpvD1kZ3++KUmFLTlPqvAkaa3SeD6y0KmqEI+Mrb/ovSd7jRNxPJDeXauxHMZyf4EhLAYRkzgTXeTxEVt/DzMIJtTHkJYBetg2nc5Ty/hJXbspAh7CNc/kC0sSM0jK8HBk3R4v9p/aXENf0VgfS78UIeEPUWpY7/6nmsGGPSQ4yCyiwUki1YKUre5auKTu2zPHaZt6EBn/H8fcYbssaqmxs1n1teCDwuAtcKNtC5QTSsFDSQLZLzd2qDmqD+nHSTVX/DQCwNLxQTOLx942mFG42P9hyTNvpnbzo35PhPv+TiipETfkL2hzWzkeXDUTp4Roydl1li8BugXQAwoK/c1iUsv+RqpufpFX3QIUbhCRe3cptCGwKGitU6dM7QZlK9AnWj7De1AC6nIHZVg9Vv94xs4pn2dPl3tomG0qyuY7
 NC1lXAUj
 P2fTn2sbiBmqgffRHoka+z8z5WsR36PCwQO0rWWGoXD9KufBI+MajuzUIvebTTcgKh56PMvupIbB4amfFPDNcpo86mOrmXa7Ed9uht3jOPHDFbM/qwMC50wchAIWa3UVPzX8ZdaYP1dJFTPv22VR/LZK8G/uIwNYUsjanc10/RdfLz4tNjbLp0pTCyFca4aVIr9DznB8TBDfqFkPpvjuufRwboDwpVzPbmYR7evlafeUttFizbMA2qsOLpT0YXH+LcMf9dPiw5/Pp+mINcO3VLhz/7tgEfiKOoBbmuwhaZ+VW7W4BTY8PEmobuCk2/kMn7ZKx8Qm5SL3P5rnsmrOVFrM5ROWNljY+Wof6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/10 10:44, Yafang Shao wrote:
> Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it from
> the khugepaged_mm_slot to stop khugepaged from processing it.
> 
> After this change, the following semantic relationship always holds:
> 
>    MMF_VM_HUGEPAGE is set     == task is in khugepaged mm_slot
>    MMF_VM_HUGEPAGE is not set == task is not in khugepaged mm_slot
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Acked-by: Lance Yang <lance.yang@linux.dev>

Cheers,
Lance


