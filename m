Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2059C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7A96B008A; Wed,  9 Sep 2026 03:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77C26B0098; Wed,  9 Sep 2026 03:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D346B0099; Wed,  9 Sep 2026 03:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928D06B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:51:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5818A26E4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:51:27 +0000 (UTC)
X-FDA: 85193453814.21.473ADFE
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96A4A20006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:51:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uTxKO25Q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uTxKO25Q;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788940286;
	b=cv0CFGHXnf3L2hP4srQPBbOxxmyQvYidswfa5T/T6M8A3hYJah20TRLHM5Oi0I4XltlkpV
	Nwgb3u9JwWGMwDOmz9WkyqL1/3CG7bPkrDKakbz+lf23mKElRNoHjLqUQ/LizhNUPOMqRW
	8XHM/5WA/Lb1pEE2wGyUKZXRALqRAKQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788940286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgcVAsu0rPX72TNTb7TtYB2tqY78GbkTnwUYgQz1Gq8=;
	b=WUKVVgX7l+vcURrjS+/7pniDBdziJRTVuftUk+sm8x3w5R77lqtxcJ4Pl06dwO/tJ9rmgJ
	vgopFGNrf/G7rJDzNfJ1Yq3dJVeyB4YgcCJ3EO9Yig19vONExN5Qf37O0stSDqV2ETNbxt
	/olvoIKK9AkKCAQp4KYy9Nfx4FW9Oxo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788940279; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HgcVAsu0rPX72TNTb7TtYB2tqY78GbkTnwUYgQz1Gq8=;
	b=uTxKO25Q3lp4k/cz11UHz7xs3eo5AZMNGXlVh3BPRLQoDE7vDuj1Mh25s61gOSTw9/NEk3AaTRZylx/vjSbiBwo5lwDBSe5EulAUWAcVJ7e3LJAebE1KFmaSnye7BVb8aGndPVifiLV43c81TQaGeOrMFJvRA5tZzu9GpfHQW18=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAeEI2m_1788940276;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAeEI2m_1788940276 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 15:51:18 +0800
Message-ID: <238965b3-c512-48f8-8dbb-08a76cdbcc48@linux.alibaba.com>
Date: Wed, 9 Sep 2026 15:51:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/19] selftests/mm: skip collapse_compound_extreme()
 where the PMD is too large
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-3-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 96A4A20006
X-Stat-Signature: 9wy5o6rm64kcbaots9mqibugcydswyp9
X-Rspamd-Server: rspam01
X-HE-Tag: 1788940283-564168
X-HE-Meta: U2FsdGVkX18Il9WQgyDG9F8uGHxc8VW36XZarpYliQywqtFRAvflFj75YE5+OAEnpdgdhzHZiIxG11Ht4Ea6LHLU+5833J6c2me2a38gPkU7vqdoT49ruraemzix26XZ+bF+h84SDDuyFtEhXzbjGLNTHiJNUddsdExQtGmzxSrSBYfk9GbXFuEwVvxUu4r+64InjAxaaoftptrKgZ/yaNnYsu+/1LISO5wA8Tai4r0ojkYi7BKaI1OeoNerZi3Av5lYeym5ces/iuVWR6HM9I2OxsCRJrkaWq5qlptOaSOVKJ49OHnQiwmHwJPloZHs+5ksp2Ru7MM/8btKTm1uus53akgNlLELOcpZcDwsIlxIMQY8reOT72ZkkYju4BfNXB/DUZ4o1exeanw2avu4yHgZCbhqufaPCR1iL3mZwYZZtbzmKCFrTzNN0LRk4tSjpskanhN60PmePTneZ1UFSYrBM6PKhFrZlx0iryhkW3nfjGf3im5NE3gi8o+MPZQPRxE9Plw76ZJ2l+SM5x4Q10eU6rkgDkhtyJkz1xUcRgo4BB6S55qaT1h+FLl6xqF5WFVsC2tsql4aj//5rrSGjYXaeT+aRtXoJ4CSlLCLWO4GRMJrMQsdRsv9FOQqVi+et0zVqWUuywFWWB0ZELX953Y/tJ9KL7VcQCt7yc/CS2+TPZ7HXB4591ANc1wCCMfnxWRZcT4KOHEEDBX+p4sITwl9FaqqLjxuIL+MuD6GQHN2Q0OQiGZwGasrVUuTvOnJNkjsbPahQrjcwhSP1mvTjZ4216GY0Ii7gnM6Cr7Wm8LnX+UGv0GlDts56I5V22FmNhnHDRkR2IERlBP/HlojqU10v3IcBqYLuQWsgREyyUYycbmEl072Ysx8jXMew3L4r2FsXYnAiV80F/vh9SqmqFCeiwy+YOHXBUZ3ey431BbXPPzFJyMYulkby6noUE82wANZ1PSRF7DMBTjIs3w
 y6aJIBpc
 MVd7KAa4vyCs6VHf2XkL0piBfVV8k/VBMZVhSAeSGX2kle5WwfnQHX0t0VtcsorHJP4KFjrfGr6u8QJvgip+f3rCDpHNnb3Gd8vYQ6K43poc+qBiQDEqWbm+Rl5DnOXhVwBit+Xv3pcpzWF/TUBohz4CdexGUl9D5aLNf/4dSHvj9PYkpHgOp5XBUjLON9rLawxVHY1kI04754KMsCRrDIC4f7V2ftRWVsr5ZlIGR4Tk0etWdGmgcT2shCOZulZ+CmaQw/T1smgrz843LpZbVEBfeZkDDrf2nx3lUnqI8obAgOJaEvHcGqfOYBoLkGcjTTuKQEWlbVvK2NEjTzD45brQBf+uwoNgJ2bySYspYj74lFp7K+kQ1jsBp/0iA16ogtPwXZR9a75s/OapPO8Wx/zUSiz5snTRKfsMWEsyW1NB9tb/jt+X+klzH6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
> compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
> therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
> at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
> 64K base pages -- makes each of those an order-13 allocation, which the
> allocator cannot reliably hand out even once, let alone 8192 times.
> 
> The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
> whole binary stops and every case after it is lost.
> 
> Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
> still cover PMD-order collapse on those configurations, and 4K and 16K
> PMDs are unaffected.
> 
> Assisted-by: LLM
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

