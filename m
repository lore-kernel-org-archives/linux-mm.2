Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C78F94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AACE6B0088; Tue, 21 Apr 2026 22:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3820B6B0089; Tue, 21 Apr 2026 22:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEA16B008A; Tue, 21 Apr 2026 22:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4F86B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:49:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A13AFE5374
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:49:20 +0000 (UTC)
X-FDA: 84684660480.13.66B1A18
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D438140002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:49:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Xz2ZZ71U;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776826158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzDqbIKbIFSBf7sqhcVwocNSInW3q3vKEWkmrJICE7w=;
	b=KwbgMEP9PWL8FpLIZB8fQX4jdxVL+YEesrYI5qk5I8ZsjZtwovDqDIBOBZ+wtTmst4iatR
	AlY+a2Y6m2H8Tw1mY8cSD6/j73oIyjnTObGhIJazmmtNNXEMxAj0jO5aCP6TqdhAmB2syx
	35Z0QBpWg/RLiWHzwKnFKJIQJ2Mwcf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776826158; a=rsa-sha256;
	cv=none;
	b=R6F1MwL/v361he+k79LpSBPgW/dNm/Tfgnj9QqrHt1tQ21jNZ0zasnMj8BinYUDroowUO8
	RLI3Trn/eXyu23tVFqKvbFANBiAmAdDHWd+agM9AInb9O+Hkw4B0honYDZIkIG/dxRyHfR
	ZMpWHsiaj2zg/wdZ3uGYdcMiswskOGo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Xz2ZZ71U;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JzDqbIKbIFSBf7sqhcVwocNSInW3q3vKEWkmrJICE7w=;
	b=Xz2ZZ71UomY77wBHhzvPxFmV8ZCOpnBnRoyr71FEAt5K+U2wQIngcGVNvpJOP9BwQyVYSYBTw
	hY9WMDAE2jgjvJRwdaNOvqvR5+bVlJYFK46LtfBbd5zwNeeyu/a9CwWJZqpiGX5d6bgqppOa8Cr
	4YRlZpqmV/9SMPnVB3qYkTw=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4g0k6G6kc3zpSwY;
	Wed, 22 Apr 2026 10:42:46 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 231CC40569;
	Wed, 22 Apr 2026 10:49:11 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 10:49:10 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Apr 2026 10:49:09 +0800
Subject: Re: [PATCH v4 0/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <299a6968-1813-39f3-de28-3fcec6f3d182@huawei.com>
Date: Wed, 22 Apr 2026 10:49:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 7D438140002
X-Rspamd-Server: rspam07
X-Stat-Signature: eyy35x5dxcxzetb46bcmj73o58py396w
X-Rspam-User: 
X-HE-Tag: 1776826157-882076
X-HE-Meta: U2FsdGVkX18qbSALBs+iuG84lIBMesHVjt70eT3e12Gxo6+w1BMRJ5MlY+Uk3h5YuS0ceJKdLcRmlcN8h74mTgi68RcwQDIa2UdAnth3yoaXu+fQ1z/CzpkPMG+wh63QbcTPILgBwN8fVTF6N84RTx0KcFdffY33OvI1WjjfNzGG6yitp8XxhvlG1PubORS9V/dOkrpW25+Ad6jCFGvJqRbfTHm2jRgGYDjts1t7nP3F6eUg1ikeaOldXpHhmRJwk+6RAZ5qVa0U6boNweiRNcarg8h4KStZrKfzrHcvgIUQ8nH3QtWEa7mcdEcerFYR8GRMWhF3pML4SrW379xXBXJ5kYxKphULb2yrt+dnnShv/hNxHdyJxL9N91kwF7iqvieSDiynTgoh+KrXX/3eVMkVT7b+3FGf2tpKdzECE3TATd/ctwjHax8S/l4Wb3WQK77J23DimlJM/fCc4RGL/TOpaqM7/ItkwLRhrYrnnEZD2/zwOxD9SqQkuRCNZLxVZqDqNVOHhMkJhs2/uLaPZt1MXTyYCb0NrNAlzjFY+SwpaHxnRDAlxLkGq3Fw1BqzabOPD3FCWMjGz+QHkgPiKD1tq5bFnM7nSlRpOcxFKjn6PqhLZEhlmDN2dy4mKA4cPccBlog+F/kG8cUI7J0vbeMmFgdCSHRnADplD7HWhfGoxds+fQtzcoKutQzlR5g2RBqd4FkA5TlCm3mCxQqw4x7LFFCzqMb8beBK7ZTJynmvpEoi6Aex6L6uYKRgWfZmt1tIL2wpYXcwGeeJdOVSLmx/nxwdBZPESTteFDTivrK98n4hMlgouBfAci7yRsJbO1yX67IPbgX7AaonmrDvMuBG+R3R5k7FFF1NIv1x+JlnTSDLRj/UbkMVMymzWgtHiMpEquv9X5vPuMocP9J3xmBsC9LqUBE7uqMfZcDh5YWGOcT6EdmvxN6EVroeYwIlURxOsQC0oIOfIojTJoA
 SMp4nY8E
 iW5PsHZ+YmIf6pLt5dLUUvygjqmNGWXJySJAhHYu6S05oAQN+hxz0mMDqp52kYwrfAnanpp78j2uTZao5jQeVXlR9qTyqVe1dlCJEozmqAVsLnRlCbSHUF98s1dSOSr8nJ3TKwmW8lcmK1lpmryBdi+IQ+WNFVPLqDoY6sLxqIHqXCqnfjKv1w4vaEsAZg+KzBJ2ikDlE1u0LIHZ3XZRLgnS4+W0YHHvxKEsCCIGTLxFr2Sl4FpuowD7GDsxMXQDex3I1gKBHTViW+81qHbac3hGsJFP75kYfp2lQfxwv3UUXFFyvzXFM+h1F4xH+shBwdZjHimJ5Evsc95M+oFPm/dDaO1s9QguvXGkhlbLYLPIf9O5M8b8C0WPC6cqrHhB/Gchd2aAgnGDeOvCcUzh1TU3SeXN4hKel4rMmq+6aeq1noaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/15 20:54, Breno Leitao wrote:
> When the memory failure handler encounters an in-use kernel page that it
> cannot recover (slab, page tables, kernel stacks, vmalloc, etc.), it
> currently logs the error as "Ignored" and continues operation.
> 
> This leaves corrupted data accessible to the kernel, which will inevitably
> cause either silent data corruption or a delayed crash when the poisoned memory
> is next accessed.
> 
> This is a common problem on large fleets. We frequently observe multi-bit ECC
> errors hitting kernel slab pages, where memory_failure() fails to recover them
> and the system crashes later at an unrelated code path, making root cause
> analysis unnecessarily difficult.
> 
> Here is one specific example from production on an arm64 server: a multi-bit
> ECC error hit a dentry cache slab page, memory_failure() failed to recover it
> (slab pages are not supported by the hwpoison recovery mechanism), and 67
> seconds later d_lookup() accessed the poisoned cache line causing
> a synchronous external abort:
> 
>     [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
>     [88690.498473] Memory failure: 0x40272d: unhandlable page.
>     [88690.498619] Memory failure: 0x40272d: recovery action for
>                    get hwpoison page: Ignored
>     ...
>     [88757.847126] Internal error: synchronous external abort:
>                    0000000096000410 [#1] SMP
>     [88758.061075] pc : d_lookup+0x5c/0x220
> 
> This series adds a new sysctl vm.panic_on_unrecoverable_memory_failure
> (default 0) that, when enabled, panics immediately on unrecoverable
> memory failures. This provides a clean crash dump at the time of the
> error, which is far more useful for diagnosis than a random crash later
> at an unrelated code path.
> 
> This also categorizes reserved pages as MF_MSG_KERNEL, and panics on
> unknown page types (MF_MSG_UNKNOWN).
> 
> Note that dynamically allocated kernel memory (SLAB/SLUB, vmalloc,
> kernel stacks, page tables) shares the MF_MSG_GET_HWPOISON return path
> with transient refcount races, so it is intentionally excluded from the
> panic conditions to avoid false positives.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

It might be helpful to add some information from [1].

Thanks for your work.

[1] https://lore.kernel.org/all/aeHy3-vQTQYJlGw5@gmail.com/

