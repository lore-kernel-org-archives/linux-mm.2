Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F1CCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2233E6B008C; Wed,  3 Jun 2026 03:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4636B0092; Wed,  3 Jun 2026 03:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111756B0093; Wed,  3 Jun 2026 03:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01D386B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:24:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C446C1338
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:24:00 +0000 (UTC)
X-FDA: 84837762240.25.F07A5FA
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12365A0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:23:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YDU3AyP6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780471439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3E2ed+XTGVkEd6ShRY49ghkqvXsVF9PM70tqHDvZywg=;
	b=ooTKdA9OrUSQK33mPcRROjj+qt46FeDetaaSrno8r0AlnHhAcVv6Ait9CcRrS6S6EgPG6E
	pctU9QxjkLhn3w5Y8N7/dxq3gav+kbU/PEB/uDvJucpetI+RGGwUpvO2g4weZin1epL/Fu
	nIq1xG1wHycva+LrovJHi/MLfm+Ogek=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YDU3AyP6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780471439;
	b=UF6T4ZKBulf0Ra63+albSkDlr5J/Y9+s5oQy10RYEIoY/YKknUkLBG9CtH95x7HmC7/QAm
	ce2P/oJC8ASFhXmMYAR867KfLx3s73BBUBIxw5b0GCnFljVC0v7N63wmZoRJHHQVTxOyAD
	7+YlXieIj0Si8j0IDZZOVXtYjliBMRw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780471433; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3E2ed+XTGVkEd6ShRY49ghkqvXsVF9PM70tqHDvZywg=;
	b=YDU3AyP62BZKzs2S5cyvwgyRIsII8pIQhcG9VsrAuBv4Y7+yHIxM5jCEbPqLjKQJSsKuc9zE88C8FU9hPY5vhs+xq0G3Ugn1UQRTUlosGlSOogSVWcHpwTqHRX8ci4PxvEJKi1w4kNHPH6I4sSzl2IRVwr9OQvMln/+Bvkmkbsw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X46kSRU_1780471430;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X46kSRU_1780471430 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Jun 2026 15:23:52 +0800
Message-ID: <2132b0a3-1085-47cb-95ca-3aaa7f8ed44b@linux.alibaba.com>
Date: Wed, 3 Jun 2026 15:23:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
To: Lance Yang <lance.yang@linux.dev>, luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 ziy@nvidia.com, corbet@lwn.net, tsbogend@alpha.franken.de,
 maddy@linux.ibm.com, mpe@ellerman.id.au, agordeev@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
 x86@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 ira.weiny@intel.com, hughd@google.com, dave.hansen@linux.intel.com,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, yintirui@huawei.com, ljs@kernel.org
References: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
 <20260603064718.81699-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260603064718.81699-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gxs45whz8rd15oqrjuer86go3qfqjspw
X-Rspamd-Queue-Id: 12365A0005
X-HE-Tag: 1780471436-186011
X-HE-Meta: U2FsdGVkX1+DaOgTXvgbjgTaJxuv307JZVbEaxQF9XviW6zQrkcRYUH31l2Z7jLtDexz1cNqwF8i+2bDqfl1GEI9BFXsSL1mHN4qOMGKgZSM3D2Jb1CkxJtdl85TsF0bTDzvZl8ogd7Ba9gVynxA/tg2eh+htQvGpktAWManTcK5TRRtLJ9tZo4WVWckwKisydGflp24kg6KF8kWDQQf84HFjsHYruMJDwkLI1tTZgaOZKuQpum3CCno0AjK1m1ESyLDCJqaKVivTjgXJaOmk2JPbWoIQ4jZ9o0cfhD2f6Lg5HD9UwBPJVbHv7k2THzLDFx9z3Zw+YTH/iapQk0CBsJYjgZqBwORNdoc59td6w4fBNwPOc0C2X4/vO/CpCu3VSGHZURQlQtYBXNBy3nlD7D1hPwv1/TUHvBEL4Pq0tGFm/0/E2Cr/aciwaSpHheehURniF1kxwlj8VKEVCEbibzcWuSCrE2u12FEmlNLqAtrUng/zuUgGIxbczjxoNqSrIOq6k03zD3L8aQ7f49GF68v/1WSpzgzHRoguEyrmG/YwwvF25xcl/mAhoOzCfNxNIa57PuSav5AEwvo2ZP3gVj/9AxP/BCgE6TBUk7x0V8lUxVBz4B+BmnxyK7I7H3RE3V66eIk2vWD6RniYFvIk610LGel4RWFKzEEW2kCaM9ykGBcYfU6lo627h65xqBM0vByg84sZrU2uuHdBktFNlm7Qx9iVYgZjJT3kyD+DJOkILGarx6RD47EbtpM4bjXTzwdDtQPH3Y7zRRFb2PH20hC5MKk9t7NEQrRhYN09RXEdNnssvX3HO7uHYpQ0SVECrYV5bFruaAe0YvmNnB1nEMybZsxFHVe4rkyqEVZHBHAWlOqGl3mXekX/uVrko+mvPdfYIsrpNmoVl/MAfIx5m33gSh2fJnIVOL/5oXrpxsFzkzvx3PmIBuOn0VvbM76LM8SGOEo82O8w9vHWP/
 MeR0Mpxh
 1TnuTOobJI/ysLkmOD028UoEHVBSDEO3AjaftHKMta4ZJKSUtrZZh4QTrqyLaS6O07b9oGp59Djw5JPaV/go2mudargcsEFD8BhbTdtm6DvxmYfRWqwN5gRbwgz2S6qHIm/U4PjACBvRf9UjUFtl+/I/DKTe9NxzXU43g02UNQjS5DV50hVhIAbFwc0N9vSuJqEnFn0UcXq+qzpUjJvfXbXWzJKXTPHVEezFUfykuGUWZNU9/VybnwqgQBz2DqaqZyIJsEU/DO3ny6RmLLE6WyqMXVLJLbtMDDn53G/9OIEDIOmfbwb5JBX+lLDMDvlFTHS6b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/3/26 2:47 PM, Lance Yang wrote:
> Hi Luiz,
> 
> SHMEM_HUGE_FORCE still assumes PMD order in a few places.
> 
> Is that expected?
> 
> shmem_init() only sets the default inherit mask when PMD leaves are
> available.
> 
> 	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> 
> But shmem_parse_huge() rejects "force" unless the mask is exactly PMD
> order.
> 
> 	if (huge == SHMEM_HUGE_FORCE &&
> 	    huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))
> 		return -EINVAL;
> 
> Even if "force" is selected, shmem_huge_global_enabled() still return
> only PMD order.
> 
> 	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
> 		return maybe_pmd_order;
> 
> and shmem_allowable_huge_orders() mask it out.
> 
> 	if (!pgtable_has_pmd_leaves())
> 		disabled_orders = BIT(PMD_ORDER);
> 
> 	if (!vma || !vma_is_anon_shmem(vma))
> 		return global_orders & ~disabled_orders;
> 
> For anon shmem, it can also return 0 for same reason.
> 
> 	if (shmem_huge == SHMEM_HUGE_FORCE)
> 		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
> 
> Should SHMEM_HUGE_FORCE use the available mTHP orders below PMD when
> pgtable_has_pmd_leaves() is false?

No. That's exactly the strategy we agreed on after lots of discussion:
1. The options 'force' and 'deny' are dropped for mTHP interfaces, which 
are rather testing artifacts from the old ages.

2. If top level value is 'force', then only PMD-sized hugepages have 
enabled="inherit", otherwise configuration will be failed and vice versa.

You can check commit 4b98995530b7 ("mm: shmem: add multi-size THP sysfs 
interface for anonymous shmem") for more information.

