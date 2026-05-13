Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 582F6CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BFBE6B0005; Wed, 13 May 2026 03:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996796B008A; Wed, 13 May 2026 03:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3426B008C; Wed, 13 May 2026 03:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3C46B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:24:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17E15C27C1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:24:58 +0000 (UTC)
X-FDA: 84761559876.12.2A47DC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07249A0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:24:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppxkSl2N;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778657096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7C17tAv18qHYmnWfX6IXctivkYSR9OfS3FMCSASvyo=;
	b=YgJQNMKQqwtSPIbF7AyRWZYJWOCX9s0SfrdQjN48D/FrfXronTzPhdzHLBb8qe1oGruIio
	N2slphzY7o+hjhCR5ephjkgkab/wScJ3vbAXED89mVIoVk6G+Bk1XnBLqjUb8qhIStNDoi
	q4CJZTAERYZpEEsaDGAs3WEsDRTDZqY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppxkSl2N;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778657096; a=rsa-sha256;
	cv=none;
	b=vxV4ow88+V7jkirZqYTTtgA/l6c2qslKGCFJouDImtTx8C3JpVf7qyBorICElTLUK/FzNa
	RdvaGRmPOt7mcot2TzFRVnSyLyyGuJXdN5DLJPs0KMRpYxjFkaUsffklEmmc1UEfWTjv+b
	4fnGFH6ZXsf27bjGvP0h72EdwmsIkRU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A310643F32;
	Wed, 13 May 2026 07:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F04C2BCC6;
	Wed, 13 May 2026 07:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778657094;
	bh=dpHgGWbl4XrEZM7XmV0lYceMvJqpvt/MbCc9MMZHWMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ppxkSl2N1TcSTxMaEht8arj5fuxglVI3CVBypZ0HviR9Q0DE0YMUk453T2bV16/cF
	 mGaSMjpdT6WEvsvV8YeCxAiUDXn68edwaYKmBDzXdAmejvMcxd2BbrnzQMFgV5SKMm
	 w9Ua/lMgzfZxEFS/wxfGws98jOVsxG8Go6hU3Hk3IrOfqZrKYKFZVB5l3v2kfZyaHT
	 4Uw0lticu1EpjxqMHA/S3RQAIbp+hE91oHIJcJ7qTv31QoAgAXNW913Bjx5+Ksfv13
	 26e+lefiHNIEoSoXNxXncDHQvvg+O7ZWmcOPNLEJTHTmB9/sO+6OI+TD6yihZx9Zwn
	 x458dlZS7FvTQ==
Message-ID: <3fbd1959-8619-4c10-b191-fb7b4ba029ff@kernel.org>
Date: Wed, 13 May 2026 09:24:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/khugepaged: avoid underflow in madvise_collapse for
 sub-PMD MADV_COLLAPSE
To: Wandun Chen <chenwandun1@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
References: <20260513055428.1664898-1-chenwandun@lixiang.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513055428.1664898-1-chenwandun@lixiang.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07249A0002
X-Rspam-User: 
X-Stat-Signature: 9uwg3upyopqir9wmwbisrs47y9yq5kup
X-HE-Tag: 1778657095-721607
X-HE-Meta: U2FsdGVkX1+M24ieydKtb7vWRa/Hq6SreKyi5ez8rSL4a8XTA/dMD0JuYoP6rStd5ypTK8nXuXm1AfYhNOJbw/onhH6hUnU/dgN8crN4X/G2ywyIPyGIw4Z+SmeXeQ1Yqus/3sVWkHbBxqvnNgEYyiTWQ7j18yNy4yxlG2LB261yAzfnfIhq5gB7HDHuL1tlT5YiFj8+7+ftcTqckA/mwpO6Qyz2YeHcV/jWFxGKZeIeSmQybEK1888GGCEKoP8nxFsIM0FAEYmFta5Q026Tec4t2t3CM2MyIKZFKM5ID11ivW7x2lSVF365V8oJIu3OF0ae0eXeg9tsDses8jJm5nTf90iRBDZz1K2ZEA8qtVtb/7h8jkmjazV1NQ61f6Ky5QyAulttLzDnLxCmyBPNazeq6tw4I35RqreDy0W41OhQxsyDWWuHq6OZUTA5G236AaYQrCT61f/1DNceNjKLteln32e/MsvhR2RHXiC7JtOiI7onlsK+tyxYDLhDuXcWQZKwMD1YM13QYXWZe+fJ76KFvMWaKz6hkNTd1msC3hpjuLnHXSEEnsJiQTMEn/xdvdu4IxhXCHgnkkMqvQ1FznqhQgbZOzw7nXf0P/sY1GCTDUI3nFb30OsKlU/8gAtJ8iQS//d6U0OZWo9fKCWxFcSfijUObWgqo/kUDOWrjMicRCJE1EnQOs1W8wvWK+Wm3ecJ0xZpR6DFTVBED4sdJsG5cDH2L3a8eK+agGus+1lCO7B9zx7AJaXQu/PWiZOFsr1slfSADJ/+82gEpJP4aF0hATMSyrQQwwBf5ORfcH8HtddA8JfSWzd9+HAvwOwZnNYpatNxvxfqBZO0B90btMuJ+BthUFF1msLsgwp2H9oyFoKzTkePGsu4GCTuk3jA7irlenOXxm4jjqenOkzzewhSY5imD9vedsKYsVv4hiJwfmjZwgwQePQbFFc7qanN32dgw/20FKJi1zNxGjC
 YSxd1iGK
 SE6y+EGx1WU6pyz69+O6F8uFnbPNK4VzCzn6XsttBLJ6HI81oI8c9dDbkFznGZXcF1GP/6I1j2ymdLWA3lQjfQw4v4sJFR5Cd7LXZMrYQ2sXQoBdlxqrbN6gdZDv76Vt9ud5b6jdVJAl8ZeY3EpLmgNIUPBm88ckVCqkFNeV1vpYX+JTAzg2nlfOYS0IQh6NSRSHBx4lIVNZGCAP+NwyGxm0ycmbmQPI+jqQYNGes3sJ5J4G2admTeXDVgJ3BeFrj3KhSGDpwLXrKjSJYJdZRTTHffDy4qrbbejdjx+X78lbWvVkfUO1+9+O0OIc68IKY7r0eeWn/Ir125H6iWxyuAgjDmyHbPp+bl5CS01Bo7gKQK6dTED+u8rwGpexRTBBUVzXw2lp80tEX0Jb9PsAMzYEt6DuqPu0wdO6N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 07:54, Wandun Chen wrote:
> From: Chen Wandun <chenwandun@lixiang.com>
> 
> madvise_collapse() computes the THP-aligned window:
> 
>     hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
>     hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */
> 
> The following case will cause hstart > hend, and result in underflow
> in the return statement, avoid it by returning zero early when
> hstart > hend. The return value is due to input is valid to madvise(),
> and there is nothing to collapse.
> 
>     madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
> 
> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
> unnecessary when hstart == hend, so skip these operations by
> returning early too.
> 
> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

