Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875B5D1D480
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B246B0005; Thu,  8 Jan 2026 11:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF786B0089; Thu,  8 Jan 2026 11:10:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C022F6B0092; Thu,  8 Jan 2026 11:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B40046B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:10:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EB80139D7D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:10:05 +0000 (UTC)
X-FDA: 84309283170.11.E69B090
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 726C51A001A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:10:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uqXZJF63;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767888603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zh003Qxj5wJS3BakzrNzCYmkED5W//3WqwJGNZ5SHUY=;
	b=QwOMwZHUs6gTPFFRaUihy0eqszOV7xw+F7GUNGDcmObUHzizG3zCrqrk5DXUbEEVBpaW69
	4lhpR56Kgw8e3+C4zbb4HNO96GtKuNkuqPhqjdeHAyoFbvROqrwD12+mBTgVuz4BfpaCH7
	kqgK+ZEfyj/nnM+eiqE4lO/091XvjSU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uqXZJF63;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767888603; a=rsa-sha256;
	cv=none;
	b=6s7PjvLJPUm/q5nzdJCNxl6FyBHU9t/6sfTvMM8CZEdPaXt3QO+uZLI4ET9Gf0corMzRAk
	w2w1j0wJoMbtApvpl3RbGwFMFf8TCyyUdk5EE8K+OazhquR2FVxWk3qePsl8+Ph5jXaWd5
	EvmNkHl4AYzBv0nJYH1Q3G307vK66Ww=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46C57432F6;
	Thu,  8 Jan 2026 16:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB0AC116C6;
	Thu,  8 Jan 2026 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767888602;
	bh=KqKzdFoLZFct6ZLIwpLIWMBiFuKLvoaOI3xqdCwiEmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uqXZJF63sweS9rbp4xNKKiVg6CPHseMPnaKDYO7JRf+hWWLkRcZLC3YNj692EulQy
	 JCMsfOkFmyb3VbWv/eztxY30WQKamopYAS9ENw41MX6rhf79onZJeqhESKv8qhDrYT
	 K3ongKIWUSpOS0fbSOAiFXgCDIxb0Ct0NRw8s4iBDAC9zLCQmCubgR8FDEA1Wki5B9
	 6VKIx2xQsRsEOFFEcEXTxp1iwYm1yWP1OQZUF8pNU9rgTq7m+df0TZ/pywau9QWp9g
	 LWvLJQxkqT/wy1VwyV1CcxhAHZQRoymaD09kZfIruhwYSgIq6rfpMW5qpRdmP0dcIZ
	 B6IXqXneBfmew==
Message-ID: <ae9e3d36-4186-44e4-ba1e-30f9f73acc18@kernel.org>
Date: Thu, 8 Jan 2026 17:09:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: txfzn4qb3zk5wxbjuygoiyr3iydihg3m
X-Rspamd-Queue-Id: 726C51A001A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767888603-909392
X-HE-Meta: U2FsdGVkX1+hf6SMIFtxzAB9t1TkFG05tbN8NfTwKmI2oHpp9EoFd8N0pPDbqYlyM33PurzZUoRFMZjFJhBDnFGhe7ep8wR3771Tu/QPwaYF8evMe4yuQx0tc5rho+uFGZW/N+IoQ6efu3mUcWvbALWJ3UzsEOWMk+sK7avL8OnVfWdPefQnRU3vjwduHix3bzOP3srrEDSXadYAS/Y4rM3/XYMr9Q490DYc5Ib4edz+roAfWoDYBepdHWC1k6QlQtUp/ZaNaqzltG0Gz5B4NhFEUY4dbNaVhfjS89c0MKWG4eNNdwlh7WN5w02t3EeNFXfbasJl/sMLB3l7uoEdKKmze+j2CiDgYWa/uem16o2K4xImMz3CD+fOyR+LnfVO2pfFZUngLT3FKV1X6ORF26ZB06oeSLwdqNuRXfENi5B/AR+W2iE+V3kDE73vfpSPRBB3l5zPnOZ8KQdJC9GZKeN60Nh+iS0soU9TDqU5y48xGBweij2XHyHPZxKGov0Fba8oHARZ7Tnc0szHGfxC6ZFDFcr3YKJSsSzMbDXgz4G5cB3G3JnHWAnYfCFyh4JlRk3qjgZj0QsOH1KV5GCIgR7L06nOw90ov65JoKkK/8a1tBQwxs4iWswp+hu4uBln4QHyU6hYfQtCm5d32tEfjSSE8oGONcGZPNDwZJWNQ4giZ54W4lUDAlenhCsh6GXeqVoXZUM0scV3zvsmqMOV/ckwHM49iq8TOJN8/5VfuLglyCBcidF7IHgRd6RTjQbI26TFPSM5iAeE3GJ4R/OEanSWBeZB+ERaeoUKYcG8ywqJJoYowh3S3IiDEw+Cjeeb5Bc2gMTNxgSl6z6umf8gqo7L27JEohwGc/wyqapDA7RRACyC9skK5IeFVisT1GL+99LRJL6r7dTBDgXb8D1GA+INpXVTYGtuqyXKI/nF+DSsfH82V5AEwE168vXR+Q1MB9XdM41CaVKKVX3GlES
 rpwIfJ2L
 /jjYuEml4W2qU6MQfTntNaHRQXPZjHd+iS59a0eUfX71nyGDdjnyttD9b2Q1S+c7h/wKcpk9ceu4261N64u9XwhW78cmGg5xDyq/GSfSKSOLx9PZTNle8S7vGB0pgCu6mw0wphEoNiSDJ+mBN66OuIyX/Xa8oIYC64jNHTcHggclwn/Bzj8rm7os16BP918exE507jniV+dd+rRK0ks6sgmbFGeXOtah/IPyKPFbHYUNFDCcEotUzEvNuWc436xBDVUfzFnL1xy8IXS0LLpNDGNUJNXWEQqe/p5ZYW51dmAUx4vqUIEWlEImg69WPl3xhEu7SpUYpARS4nCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 18:46, Nico Pache wrote:
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
> 
> To achieve this we generalize the khugepaged functions to no longer depend
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> pages that are occupied (!none/zero). After the PMD scan is done, we use
> the bitmap to find the optimal mTHP sizes for the PMD range. The
> restriction on max_ptes_none is removed during the scan, to make sure we
> account for the whole PMD range in the bitmap. When no mTHP size is
> enabled, the legacy behavior of khugepaged is maintained.
> 
> We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> (ie 511). If any other value is specified, the kernel will emit a warning
> and no mTHP collapse will be attempted. If a mTHP collapse is attempted,
> but contains swapped out, or shared pages, we don't perform the collapse.
> It is now also possible to collapse to mTHPs without requiring the PMD THP
> size to be enabled. These limitiations are to prevent collapse "creep"
> behavior. This prevents constantly promoting mTHPs to the next available
> size, which would occur because a collapse introduces more non-zero pages
> that would satisfy the promotion condition on subsequent scans.
> 
> Patch 1:     Refactor/rename hpage_collapse
> Patch 2:     Refactoring to combine madvise_collapse and khugepaged

These two patches could get queued already separately, right?

-- 
Cheers

David

