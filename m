Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F91103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E736B016E; Wed, 18 Mar 2026 06:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230036B0170; Wed, 18 Mar 2026 06:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C8B6B0171; Wed, 18 Mar 2026 06:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06C0A6B016E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:57:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3D921D5FF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:57:45 +0000 (UTC)
X-FDA: 84558883290.23.EEA412F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id C171C40009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:57:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SH99kRsY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgLjZjiZAQDujWNQO4KkWHp+1oa/NVCBWzOVCA3bnuk=;
	b=ha+dRlyoBhJ+5CSk0OF2QzvC8xiDIKcBcRC7Z8IwJBWxEz4kB0MDmz9lbNSESajmBm0HRA
	c/Vi8Ym4mVEMBmF+93vsW0rF1CudnVrc2LCKsSKI05PFzXt4i5GqUbQJbVtfsurcBgGJqx
	uLrIa5/Ibljz+9aSpAn5FEbW+zsXmkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831464; a=rsa-sha256;
	cv=none;
	b=IHJfFLvDN3JgNUrTWY5/vybGbV86Lr0cYutaB5oDvnEQmpB0F/2X+3iAS7yC+VTXZeshLH
	yP/hIgd8mbCy4Dl5mrVN52EHyIC4RX7sI8Z0a9Fjb77ndYTWpTxq+a1A8DtiGNnv5DH/WZ
	rByHmXKyNbDuOhYG/kQ+Yb8RDX1a/+4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SH99kRsY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
Message-ID: <d0c0ac64-be15-4683-89ec-e32bf4867109@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773831461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IgLjZjiZAQDujWNQO4KkWHp+1oa/NVCBWzOVCA3bnuk=;
	b=SH99kRsYhm85fHzLq0PeXe+Bmssa3uLHL41zHKFW5m1uq3oVO68YMdQA5P0yhRRb3VjGCC
	zwlkGEaEamADlJ7708FKSc+i+m9W/j3VIF8nSyB2yhNspkesHeRK3OvWgc/BXvo6Qra6Zf
	/L9tRcXOOfqx8oI1ud0jioievUKdyT8=
Date: Wed, 18 Mar 2026 13:57:31 +0300
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K
 pages
Content-Language: en-GB
To: WANG Rui <r@hev.cc>, Ryan Roberts <ryan.roberts@arm.com>,
 David Hildenbrand <david@kernel.org>
Cc: Liam.Howlett@oracle.com, ajd@linux.ibm.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, jack@suse.cz,
 kas@kernel.org, kees@kernel.org, kernel-team@meta.com,
 kevin.brodsky@arm.com, lance.yang@linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 ryan.roberts@arm.com, shakeel.butt@linux.dev, viro@zeniv.linux.org.uk,
 will@kernel.org, willy@infradead.org, ziy@nvidia.com
References: <20260310145406.3073394-1-usama.arif@linux.dev>
 <20260314095022.217231-1-r@hev.cc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260314095022.217231-1-r@hev.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C171C40009
X-Stat-Signature: dtes33a1jhcomo1ufeodxh1q81gtm9iu
X-Rspam-User: 
X-HE-Tag: 1773831463-683071
X-HE-Meta: U2FsdGVkX18mhbGtzmf+4Psa8nB7llvt/vt1WImOmm4hTG05LrFgWdGBTNvqSdwEJi5pf5iINHJK8kfb8lyXOiNB8Sk8tbgfBXL+A4YfybLIQUgx30/7LMcM4wE+FnZg1bHpwsYb8+20fusWsxVB+Yjq0UDxhoxISmdcpk8q6c4tM+ADalmJhU+fZ92xH173qOYZUyWWZIYivYZlpJgfnoSwZXP3RMEiuaD8o5UfXOeC5jLRg92aSmwfFb5eSAffuPi/glxy5wjma6jo+Wk2LrwZXgC6/hp3j7WWFP0BRxST3xCx1uig2g6lBP/w2fCbShUIDE6PmJbQQHiZYgDc8e2SpgACJZTHW+9kWQP04qFkpZBE7TJ5acg/8Wv0K4WMZq8gVfFCp0F0+HjA+iFUWrbwvsVpXZB4p5/4PkeiyTr4s+wSvJRo2HQQfBDPBmMW8rRohzdwppYkcky7o2hiKcuXutDVYKaUy3wXybrhluzkMISTQItJ7K0ymjEPT40W/lcT8GKX8a84DDRRHBGBd2Hh2PUAoeZeONg/XSMvZm8e0rOcLPsbdaLE11uyE7HLbGoY5A7sjXoQAdt9u9q/SUw/ivNuyEA6bcJv7O8naw0tJGvBWtWD4hpTe8NMhvll09y2n2n6ldY/y4/xxcmPeIgqVP+CR+gyxViyPLcYvZDFeozWMQUFdR/sAh687I9zEdfcTuRJzMeivsmMMSb+GaN3s/iXnuoG9GhawW5d5v8eRjYvmr36VkCyYztnWBmKZxjr3QixqZQlG7rVvTNfb+0slzqxXQ/GLEbXzCfSlP6DREk9Bh5urkc/kJWsrSOYmD94wrhOt6rCJ3KD/Kgnn+tz/xzcVwfzOJH9KMXkseux84yi+JBIOs1siNSzoFxAOFXeTu6u/8oLfJ7Db3hDa9mwwy7Vi0J2r78ghQmjZItJgsT4fBymyaB83xWj0ucbKD5PUN8qIN57gF5TY7B
 mYV68mpp
 T/GSMa1RfNdBDjYUslTOaGyLnFX61BDbseYzo+5qQEuLraHhZ5VC0oGC3+XXVrChr4v7LLiZAz5WNIf5+vGKk5R4rvenGqLUDfazY9681JxOL2ByMH6sCIRfkmGIql3g+V5V0k/1l+uev/RUMozb6TAdBagZmkasJ1Q3o3H36F5UBweEsE7OQxvI4cyyD2R08m/7rAu2XWXDfsS4ZvyjUc1JGeo4CdKMzdY/1whUO9g9lkk72tW4oD0rtVw3Y9xH+SLqdP/ayq1De5ClMskZudQL44WFOhGArZC+pQA9ceICSUZuDJT+gJt+VsfuVFJvSk5mi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/03/2026 12:50, WANG Rui wrote:
> I only just realized your focus was on 64K normal pages, what I was
> referring to here is AArch64 with 4K normal pages.
> 
> Sorry about the earlier numbers. They were a bit low precision.
> RK3399 has pretty limited PMU events, and it looks like it can’t
> collect events from the A53 and A72 clusters at the same time, so
> I reran the measurements on the A53.
> 
> Even though the A53 backend isn’t very wide, we can still see the
> impact from iTLB pressure. With 4K pages, aligning the code to PMD
> size (2M) performs slightly better than 64K.
> 
> Binutils: 2.46
> GCC: 15.2.1 (--enable-host-pie)
> 
> Workload: building vmlinux from Linux v7.0-rc1 with allnoconfig.
> Loop: 5
> 
>                 Base                 Patchset [1]         Patchset [2]
> instructions    1,994,512,163,037    1,994,528,896,322    1,994,536,148,574
> cpu-cycles      6,890,054,789,351    6,870,685,379,047    6,720,442,248,967
>                                               ~ -0.28%             ~ -2.46%
> itlb-misses           579,692,117          455,848,211           43,814,795
>                                              ~ -21.36%            ~ -92.44%
> time elapsed            1331.15 s            1325.50 s            1296.35 s
>                                               ~ -0.42%             ~ -2.61%
> 


Thanks for running these! Just wanted to check what is the base page size
of this experiment?

Ofcourse PMD is going to perform better than TLB coalescing (pagefault
itself will be one less page table level). But its a tradeoff between
memory pressure + reduced ASLR vs performance. As Ryan pointed out in
[1], even 2M for 16K base page size might introduce too much of memory
pressure for android phones, and the PMD size for 16K is 32M! 

[1] https://lore.kernel.org/all/cfdfca9c-4752-4037-a289-03e6e7a00d47@arm.com/

> Maybe we could make exec_folio_order() choose differently folio size
> depending on the configuration and conditional in some way, for example
> based on the size of the code segment?

Yeah I think introducing Kconfig might be an option.

> 
> [1] https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev
> [2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc
> 
> Thanks,
> Rui


