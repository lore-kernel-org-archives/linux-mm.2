Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47485606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j2bVp2qs
Received: by kanga.kvack.org (Postfix)
	id 3A9F06B05B1; Thu,  5 Nov 2026 04:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358B36B05B6; Thu,  5 Nov 2026 04:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270D36B05BD; Thu,  5 Nov 2026 04:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFE5B6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:32:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AA26C08EC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:32:55 +0000 (UTC)
X-FDA: 85400551110.01.4BC8352
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1466220006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:32:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j2bVp2qs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysAWuQsmXi0UpVaJ15Q1RIi/6yFzToRukQ4uvO9n3gw=;
	b=p31ssUIgIzCJLZlH/OM5Wd+AkMQdf/6wYhb8EKwEf1USIPrtMu684sevGjhZ19FajRv7Ac
	CZLNDe0aBbJ286askUY58KRHOQOyVc5MGTqaXEhRWBTmAfoQOeLI6iMxLXhCEb5G+5qW+z
	8f0wrUxUgJhfg9pyzB0PNasI4xM/lDs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j2bVp2qs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871173;
	b=mkEDpco/K/asKYKvacXahTNzlhvhu5S8eqE+6BK+tqejpDmj7ICaShmvxmMGZDw2T/qKqQ
	yn+1mCnTDxVFP0wwx3Xhys2kSt9p6WyZ/lUmStDtmNF/yeE2ZUFaxuCdyLpt/DNhP0qUJY
	yjcaFKjxIjtYdQ8tYqgHyN4arVBaHu4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793871168; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ysAWuQsmXi0UpVaJ15Q1RIi/6yFzToRukQ4uvO9n3gw=;
	b=j2bVp2qsj9TEsbj1+QFuz6AeYmoDeEkEthqxaWc0kO5cxSD9gOzMvpKnGIeu7y7Xzj9pcG0VS4UmA8rN2kq0ldgL4W9m406xvOm6iGK/YazzkKwQ8w64mmQ/i2ogzWu4qo4KqkbGtIFp7pGqmTEWkVMpar20V8ppxSjB+ETtC6Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XE8D.3c_1793871166;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XE8D.3c_1793871166 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:32:47 +0800
Message-ID: <d07c04cb-3ee2-48fc-b289-7167a8589f38@linux.alibaba.com>
Date: Thu, 5 Nov 2026 17:32:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] shmem: skip empty unmap ranges when punching holes
To: Hungyu Lin <dennylin0707@gmail.com>, hughd@google.com
Cc: david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261105055619.58289-1-dennylin0707@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261105055619.58289-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1466220006
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: k9pp1ig3odemwks9n5jo136xjc43t3cx
X-HE-Tag: 1793871172-66395
X-HE-Meta: U2FsdGVkX1/8Vv6KS1touVTE31PVMnMXiOTd//OMga1V/VF0vAWfJwxZI0nG81QzMrLq0gw4FUUoIECyZuSqhkn//pwIkaD9C8X42BI8k8AizT2hknmhzN09mr9Cx5QabR5sF8JnMXLwRAQkaS97hgnVM9yB/fEyf6oBZ4lqmNgscB0PbjtjJPtjTF041H+q1aXh5jhyFYGfaSCtppKGzLV3TSZBPrA1erjZsNW7OUmx9+g4ABpef+2s6HoJPYB0ZFGwbAcKVv6n8rvF2soxTFU21X9SO5HijExrAMulUt0yWWL2jwPIW1UHY1v7kkh//aWmkhzDNfwq9rNOg6HBo2qI5QFfJFYXhvkcEHxINK0LWug5rZuhNN9OEqG1EFMFVlLrphktLQ5Qti4L3c59YKPdR9i9zJR28Dle28oNy1mPaT4fdcC7iEwUBlCzuzJzZb+4hydLRXXoqb72pA+o2KQVsLrkXZIPPSk9k731uM1z11sz5nhoFuIAHPPHfRL8rK3TnW3pANWj8EUhAyEQDnWQAhrzshbqmK6M8btusLuRdqabEn4fHWXubqsyd/SWlxo1o3R3M1rTbjRZ3vTzRWkDZgqYn8ls6n4Vez5Jbfe+bYx69fAPejpECYrS6k1Z4riATU5LlcXYKey/+m/sKyuKpX/8no1Hg98xZPPWXhYi+XN+WK7rY1+0ceUGRJP1PiCHB3Bas1vQvVlsfH0VcSK78W9NZEB47z5eEG8Lp6ayjJrJQQyE6A47lwpWUqXDZkxaIiqahmK8aMmsbCYjuudcHJzsn9/3LRFrOjVqoNtxRvXt3/Gzy1DKYM4fwAxKnbr9W6Wi1NzWNEuuQ/HwXfV2k/s0my3odv4k+UKTyOU48/HNT4adSY6QHUMGbtUioeVT5cxnGZf00HeBBfcGeWGYaI0sGZvvPBVDNL2ihiCg6pGJnUMxcJUbhslDFDhzXs4nPJcZYM1Y7a6/TFT
 NQWl223G
 TFr2VVnVjJLxFEY+1ZsvM9EwLF9GuxG4hCda7KstkSrks6l5GTjtPO3dA1vYySxy4r/8PDRocw5653bHhKLxhRT/NeZ5AREdAQ+T5iyZvImjgMLb/u6tYCFPmBCkvAEj/pqBxxX+BLr195mgQPFAjfDqHZJA9SrWEt2KgajD7+ebm6wap/bRT95PmY15u/EcBqtZ5l9CjpkjN0Z2RKiMGLKhLi6QhffHfaHXwv0MSeRsJQhcfOQ+fBR65xxN8kWmjVR7ItenL3zYIAbq6C2JZr/aGv/Yy2qUQf9MXm4QUv5pXQwlGJge97jQafhJD9jFhjO0K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 1:56 PM, Hungyu Lin wrote:
> When a hole ends before the first page boundary, shmem_fallocate()
> calculates unmap_end as -1. Casting it to u64 makes the range check
> succeed even though the hole contains no complete pages.
> 
> For example, punching one byte at offset zero calls unmap_mapping_range()
> with a zero length, which means unmap to the end of the file. The file
> contents are preserved outside the hole, but unrelated mappings are
> removed and must fault back in. This can be reproduced with fallocate -p
> -o 0 -l 1 on a mapped tmpfs file.
> 
> Keep unmap_end as the exclusive rounded end instead of subtracting one,
> and adjust shmem_falloc.next and the unmap length accordingly. A hole
> ending before the first page boundary then has an end of zero, so the
> unsigned range check skips the empty range. Retain the unsigned
> comparison so rounding the start near the maximum file offset continues
> to be handled correctly.
> 
> Fixes: 83e4fa9c16e4 ("tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE")
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
> Changes in v2:
> - Use an exclusive unmap_end throughout, following David's suggestion.
> - Add Baolin's Reviewed-by.

Thanks. This still looks good to me.

