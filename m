Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14216CEB2CA
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297858E0008; Sat, 15 Nov 2025 04:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246BB8E0005; Sat, 15 Nov 2025 04:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183F68E0008; Sat, 15 Nov 2025 04:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEFE58E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:13:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D41BB4DA18
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:07:56 +0000 (UTC)
X-FDA: 84112264152.04.394BA6C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D5FB100003
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:07:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kNysVfHs;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763197675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuGUgkNBhxAyHgvlC2Rtd4xfIzwmCu+LetoLyFbR46Y=;
	b=tR0UZyOZlTCrqHOKQBWE0acLQEK3hfGQzKhB0qI4YEnKS9RT6EBg7/Zh6k9yQVAYIWasaQ
	MkPqIJ+Y0xD/j2LSTzDmFZoLpPJCcarHv7Eyox/NbWYwzKKwgzk+grqLCOC4/EqDtYfG0a
	YradYyKnn0k1K5ESr9Z+GkTAhE1pEbw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kNysVfHs;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763197675; a=rsa-sha256;
	cv=none;
	b=Zl5kRQI3W5nOjpiGTFXIyrdNTxHcpBXUh7tcZGllhjH0nmzk9nEWVsfMUziBJOJrqWtaAq
	5TyqgzWdRGlEIrDFcgy+JLkULe1y7uQsCSaMr7uifM1axoo5VELrhS4PGoq/oJIM5/7/nY
	Syj1Xv3zkqM+CSAgyZ0iTNj34skhyBk=
Message-ID: <d58a6475-15f2-4e7c-b384-146623ce55fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763197672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuGUgkNBhxAyHgvlC2Rtd4xfIzwmCu+LetoLyFbR46Y=;
	b=kNysVfHsdj+0Qseu6HcgTet+NVlC+EYvKu/FOU10GOWi/nxL8FolfSVt4/dADuwt4v6eGO
	ihunYFsAestSz7zz/fhdf7/MlU9A15UpPrX0hNXtoFRGbUs2QnpKQ2keo3fNajZYWhiuZW
	+qGkodE+uZWV2JrmnmGzM7YxCyKUZy4=
Date: Sat, 15 Nov 2025 17:06:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/7] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Magnus Lindholm <linmag7@gmail.com>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 david@redhat.com, ioworker0@gmail.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <66cd5b21aecc3281318b66a3a4aae078c4b9d37b.1763117269.git.zhengqi.arch@bytedance.com>
 <CA+=Fv5SGu_Y-zwryrQiTQDy32SipMk_dfjZezth1=aZmnDKNeA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CA+=Fv5SGu_Y-zwryrQiTQDy32SipMk_dfjZezth1=aZmnDKNeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2D5FB100003
X-Stat-Signature: 8z7dgrp3cuqtad8q8qt5ubzqjnzfoceu
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763197674-114420
X-HE-Meta: U2FsdGVkX1+Z0MLps3/yoXESM8pC2ao2G1qbDESlAjeXARdTrgFt7OfK8wj+aw0kS3MCyWaG8UqsZUfVH0XQqDriWwM++NZ+Vs75Iak4hyHhh53AYdKVsRVkBDhULKp+sUeWbrL0QIGZkKGW6BjdP9iPGWzJ1PhjOoOfLVJo+bXDLBMtXhmayV1HF3ErlWWwK2YImJbfG/B10qyfneyRzqWpX6w8RNmurkcyzLEGAk6G/8IWPvDTz/q0b9GCU9b2Xg6jWUeN1XrdfmseW8anHhMntgCdua944yfKnADj+V1RSyvOOKlkuZmgRyTOWv6MOvsCzTDtELJMlfKVnyx2NexjESM6v5D7hChWVyxLyyCxVNDbTJnA8jozgxncQd/cHLNHMayGsmCUpw2t6+QslD4OHo6L1oWn5TXUxUaIwSf00o2xEws/nquxU+KxVQZa2oBi9hzsQ7VIQFuV/hdQ3PpRNnH3ELycY2cgEYE/xarj2SEQC/lhv7PxwPKpQwlBInoJSEp23bMxB/KOklkhS2yO/llEPS9PM9FxmIcC8UGPs6ilI1nrYZr8KiUhyXv/I93R7wvsM/3v3FSkgUBwzE0/Lhs2WyCz/CYV2WO+VhmScNG6Gxt/HnYZm9M5NSBKZMHff0Uf9FvsuVcxxEbOSlVUsyNRJA++amvdMsF3vfRYhsI+coQaT7lDVb3n9TPTxYJRfwb20Ql8NUKFD+uzhM/DgFWSkiDJZHxwHR+dNVZ4iRyuos7NqsIJvKMtisGwIqJzngW1RZNtp3YgRtNwxXclorDxUnjhpDnAMnx6+BsKw3R9N/0ImGDTRvBHWsIW+N8fMZVFviqrG5Eh0GagD6Mpkubylo4LRS1FJInEXdKfjT9yKXteRMEkkbSHCUX1x0h0jKaVkM5a7qNee3kBaCGj50I3XjPtT1RKZvRrdzidFe5EXFBiCnmlNvyvJ06V/N2nRXcXXlc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Magnus,

On 11/15/25 3:13 AM, Magnus Lindholm wrote:
> Hi,
> 
> I applied your patches to a fresh pull of torvalds/linux.git repo but was unable
> to build the kernel (on Alpha) with this patch applied.
> 
> I made the following changes in order to get it to build on Alpha:

Thanks! Will fix it in the next version.

> 
> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> index 7e9455a18aae..6761b0c282bf 100644
> --- a/mm/pt_reclaim.c
> +++ b/mm/pt_reclaim.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <linux/hugetlb.h>
> -#include <asm-generic/tlb.h>
>   #include <asm/pgalloc.h>
> +#include <asm/tlb.h>
> 
>   #include "internal.h"
> 
> 
> /Magnus


