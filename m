Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B912BEED628
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 17:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DB76B0005; Thu,  1 Jan 2026 12:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C457D6B0089; Thu,  1 Jan 2026 12:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C2B6B008A; Thu,  1 Jan 2026 12:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5DB56B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 12:06:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65D865E4A3
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:06:32 +0000 (UTC)
X-FDA: 84284023824.28.C12B7DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 977A4140004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:06:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qX+LPAe+;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767287190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvTBEDpzCIe7sVvy0tuZmNzpqhzzq6gJRDJsrG6KpbE=;
	b=GbT1FVAPwfmyCiblxQzpHNV0xf5n5pHa5tBUaTffQfqvsstya/dumnjnf/pzxbcdiKCeol
	4K6dBGr3QGUfAc67WYfyJSh/ULSCuAe/bONXZasRamZKqHDEMbS91FusrneB/M5nLqSzj9
	moT/nHK0i3DbNtjWwnk/CeVOYNtbO70=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qX+LPAe+;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767287190; a=rsa-sha256;
	cv=none;
	b=a66B1wG68G4XLkr+rK8XDCfA1mVlJughS3g0NziOsixZWXXG+/ofy7WNBRMDVWw88MW7Bv
	mZda10e1tsIG18SmJleLcooC9Cu4DpLz8Yz9JV4jBxWIhfDFherg1BrPIPEKz041WE5LRi
	rtSLCNyq+Wc3JN9wlzwgodaCgBq/uTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EC5B40774;
	Thu,  1 Jan 2026 17:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794BAC4CEF7;
	Thu,  1 Jan 2026 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767287189;
	bh=7VHb7gFbCaM/hW85Z3HtqU3Jb9hcgEWJXjsR78x3bpQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qX+LPAe+FZg99nJcTvX6Zs/zpVzkkdM/I6MZvCitoMZUmIAwdsFrU+3fL78cUPkeN
	 ZSpyKFTnbNbxZeVp9BMcStFWr5V3otjSpxy3f1SzH8lo4nR5nYS7G/zbKpqq4zKgKz
	 tidPVU5Y4tmy3RYeoJyiAMkTpMl6VUW1EqI0SK8Z7D7AgE1Xcts1DLpFY3rL/hW6nq
	 mFAVBYXW4OyBgOYIdOCZSGtP48aJa87NBfdeazMz5UqpGAUU1Zbaoq8qHe9/pdCvea
	 rWxIrpT8Svvb38EDIJKdYGhb2J5zA/9/zxY6EQqZtuNEBtDe/0C8sSLII9XWnwlIRa
	 UbKXOItsyA+MQ==
Message-ID: <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
Date: Thu, 1 Jan 2026 18:06:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jeongjun Park <aha310510@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, riel@surriel.com,
 syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com> <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 977A4140004
X-Stat-Signature: sxoywyfwjuhti5to6dx1xg55gh8yubfp
X-HE-Tag: 1767287190-333116
X-HE-Meta: U2FsdGVkX1+XczG2AHseptJPLwov7HSRF19s6Y130R8jgJThrYJ6tSSozuVbukKaMwLXUNcGtU0xXhHzFM5O4BsgOIgbN7nPir3jhaS7j9pNvdq7z11KexoTnTghJCVret/aBOuce+Hc69flU1ocCKUtxmsj680G1CRHaevrVO8TeqdvgyvxidIJkXpUtpTYEr3nHwvcj8fdRlZYrrqhdH7+LiMjfEc33Vuj8oIJVm82cRvxFM6L2FbIfWCw3QArCOExVDtyhQNGGAf3sd5yQqLS0W5jKA+ieQyNbp2R//YJAYzDi9w/rCvCTlWR2HRd+JERh5nbfqPZJkUNcKobfqJk7rTp346ehMXuMNhXG2adjqIuymcR+bcnqOFEgx02nVQpCr+mgDbhwFoZOODTC2T+UNgIOw7/C00VyPBjsIfDjaexjB5xxHkaMgUpVh73VwHFolQPKdiM0ns35KEOcOh+kvdm3gvBbcqsMjoDsT4/uRvzEJGzdxYgYOo5zJi2hS3uxvYHuQXkmaRwYQLPiuJDsrWxVpZ1fGlkNpUm+LA6YFDAMv2u3MFzbf6BuRe+O3FdmlSCJQ1WYKVsh4WF0rxc0wFQWvy9FO0335InQ3dkCG2lYyJl9CmHC/dGyPGm0jbpnFLgUpUI76ri4YP9Y6QurrHGmXAMLmvxu9cPEqQEpKtoH9KgSp+ohkkhpez4dQCpOWnNJ4hLZfOMReMRR/zZOSQbCPaU2tx6tV4XMN0UJ6UOHCA4w5brLabbAbtrwjcP9EsdzYu5quj9LgvKGAe1DdK81x6zgHdbFXcNWNce0UcbvVFqK+PklpoAVuUCLXz+aQ7IJSc+Z3pDsD0iE1S4Vm8P61OsG/pPcnVojcAN+iRVvxJnEwzEtqINoUtnRso/BcsUTVged9VwMwRUDQSeVE3S8v2lHQk6AqmjMWOqgoe20ZOje3GwGmZaHM9muH6geT0t5Awm4kuoK1b
 8KyZfFui
 UHfGsijFgYa7srYwu3MhJYlO/F6g8VsIYXfaPV535AHmCyeyhJMjmfMlG0m6iH9p4Uau3P6KPq5KVaV9BtbEArhHK1leVLrEXIcFkRdoy7iIgDPPPGIIR4ek/AJx+7yEYxB4uBF7Ep/X51HymBi+AK8UMhjs3/TdaH5D7EOcRP+lgNeSapWarxR/liqolILmW2d7oOjKJpkK1NYcn5Yyy5fgUy4tu+yqcabRw23lSv80dIBayRo82ue3j5P5dJcZHx2ZGGu3CuhWJbh7x9TFRA4ikwITKmp5tUG909Q53KCPo0yPxzMw4RWbRtQSI/TVsq8GVAiNrqxGDO+JAtD0h/jkdf42vaRSh41mfloH8paCDu1kTICVvsIVdCEIoFCRAmxrNOxi/8bd8kUefIDPgq4wc1D0BguFydar3A2SCThPItvbWIZBF/YqHt+z2ZLeR2Jr5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/1/26 17:32, Lorenzo Stoakes wrote:
> On Thu, Jan 01, 2026 at 11:30:52PM +0900, Jeongjun Park wrote:
>>
>> Based on my testing, I found that the WARNING starts from commit
>> d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs"),
>> which is right after commit 2cf442d74216 ("mm/mremap: clean up mlock
>> populate behavior") in Lorenzo's mremap-related patch series.
> 
> OK let me take a look.

Trying to make sense of the reproducer and how bpf comes into play ... I 
assume BPF is only used to install a uprobe.

We seem to create a file0 and register a uprobe on it.

We then mmap() that file with PROT_NONE. We should end up in 
uprobe_mmap() and trigger a COW fault -> allocate an anon_vma.

So likely the bpf magic is only there to allocate an anon_vma for a 
PROT_NONE region.

But it's all a bit confusing ... :)

-- 
Cheers

David

