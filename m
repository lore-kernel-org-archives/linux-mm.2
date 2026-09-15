Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D02FC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786726B0088; Mon, 14 Sep 2026 23:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F4E6B008C; Mon, 14 Sep 2026 23:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B366B0099; Mon, 14 Sep 2026 23:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC0A6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:35:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E360F1A02F1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:35:06 +0000 (UTC)
X-FDA: 85214580612.24.2C435EF
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	by imf29.hostedemail.com (Postfix) with ESMTP id C28BA120008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:35:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tkQqBG+X;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789443305;
	b=wiHEwiv0zlDKoqCCouSG2Fq9AxOe0Mpsxr33J2o5NG9H1hMCqip1sbgNljUPzxlHoyeCcA
	toe5Y76lF5i2OBH1G0epy0YP51/npFT/mSIhUesKmDYEOxldF3U4O2vwg3AxB0AS/T8MBs
	vxCbcqWJVRM/fJ5XzCR/lMRE0YbJq5o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tkQqBG+X;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789443305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqhXrLalkFeURT6QcLn7LYgtcba5Oa1WvoNTASzWUOM=;
	b=OZ0Oeb/1O2jC4K/MheFGdtRu0k9oEc9hhkOVZWPiww1dxSH33hgm9eC10pyrLxcvySmCJC
	IBPkFX85+hU+wzio13I/M0F0+nAGz1vxsChwkHUNlCl01AiQqQkpkeegPrqqpzor8I2EJS
	7KoS+xppVRgm74s2utHbIoi/x+SMEY0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jr2y5YBeZ5xMRQ3tq+2uCrOfY3ZtO2MmYbhMK/cmHIc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789443303; v=1; x=1790048103;
 b=tkQqBG+XN+91IDr4zn62B7OKQmiRbz1ierTK6vSb63kSKrYhXpIxHdbYktbkH262Gvj1pjWj
 0I/1eleJtmDjXPSBvnA598dJ+PjbeBBDQRqEpTPflQasIqC3JKBV6Hecbs6o8ytV27aH5gmE27+
 sFpreNeryH6izWLSG4omYbLg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 25793230337e1572;
	Tue, 15 Sep 2026 03:34:53 +0000
X-Mizu-Trace-ID: 25793230337e1572
X-Migadu-Flow: FLOW_OUT
Message-ID: <184d0913-7984-4d28-aaab-59642a1d344e@linux.dev>
Date: Tue, 15 Sep 2026 11:34:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 01/29] mm: rename pmd_to_softleaf_folio() to
 pmd_softleaf_to_folio()
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, luizcap@redhat.com,
 kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-2-usama.arif@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260914122950.3283997-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C28BA120008
X-Stat-Signature: 4djs5jka3ddas6jukjjeuu9u9fcbjzop
X-HE-Tag: 1789443304-982973
X-HE-Meta: U2FsdGVkX1/QTF3EHqh6tKzeeFCdpvo55W4sVKdZi2F6vUr86pWk9a7m17W2c1HbUkIMWD+Fy3g1171e1uckOE/MVpqJewLrzWh9arMb/lr4uWSeNEcvKh81zlFgtDI0a2wDqrYhr/m4fekgD7Xh9ve8ZJ7kfkFds5xxnu+V1CqWUhCbToe2N6h058Jjq4XtBs7h3po5k4400E/aXH5ZfG4ZsILQSCTr41pueLY70/ByyNr7Chn+h5vglrKeWniDNaJZ1tJUGbZQcP66+GSjuvx6fAZOxsJlg21OoJlqI2+Jg3B3rbJXWn9AUt+5Jg8PuX2w8g9g8WZR3juLGaJxiD6D2e3otOCDUE9NFi6j7qSNisSnnjFOhVs96HPXqgMYWZ3p8Hf4UFAxrYX93Uy2cL3pjBKbGRWCtQYgzNBCUZOFtdZWSdQyZEN3TckkTc8yxWfZYVztarhRC8CQuIWuzhCtJLTNi5wb3iDgvyk7DkSI0qUKM5Ur2DR4Npo1s5QHHC92YJOjMo0L3kiT5IwZTa6e3XOUSkiJcZ2iRlzXudEEjLi/soB5IE7hnX6PTMlroqU7a+KwSmBdwa3F73GbC9DkEBvd9buX7HNjCjPtfPFt9WuLkMvAbfJEyLHc97KhLp3RI3K8eFYfMJD9rWDWWBT5+0esdNScSmxKeI+2d+JN+fH7iyxlT3TAsIFrFVfyJbWTPqVMLogMuM1k7Fo4lFNCgKECVyVb8UdLFun/IzYYuWwMqHALfXVWy7ufdzrtqcY85pawvr6oiES1l5IfNzM3BFXCeZYBZuB6CkJDQ43nW7BUt621D1RySFKv3BQJeoJISSjCwBLDinBgcgoJgyd/Zx1rRLe8y9U0uUDjeViG8EYpsNjP47KCZi4FGpQgjItjZe+bA88cKavolftWjTfd8xvYU3tkfvE0lqyLE4UoO+Pspc6FTNsY23KpCSTW/Fu5xSpEec1n9rmzCg8
 goUbB1iU
 CgDZrtL9WAVdFIn+hCJDmoWRZJ7LF/9emwSaCfTLGP23vXW7UJk+B5tddsIctLMz/L+aqJJXYA4hVpHe2VxtQ3Fc0ZhuBVO2aJlAGDg+v28Y+EeNJ8oo48sTc70SE0DFluHrJGtM2hDUVzoIOtpH5DYV2G/db2ofyvTie1fqxwyDX4DZCl2ZamxZUqUWYrDOawBK5fZbJN+H/Nyf4b3uXgNrr3SNP0Y6L+DK+FBogrqlChlCZu2b/O9rkhe0Le+l5gmJ4poU8ZGgnrLcRaESbw4wwtkPCr4wDNc2eEy/uAxqg4AiFvcgcHN4eaUQlVn5okE3tuJR1/I5l4FSGtLACj2eZV5//FFyuqTfZG+6JcMTcQ39AanS4TUlp9Mx838puDLXA18aydkrB1/15ZGwhvEoTGyNVhyWzS5mo2MmUq2GF9eztu3QjU+KnaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/26 8:27 PM, Usama Arif wrote:
> pmd_to_softleaf_folio() reads as if it converted a PMD into a folio. What
> it does is decode the softleaf entry stored in the PMD and return the
> folio that entry references - the direction softleaf_to_folio() already
> spells out.
> 
> No functional change intended.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   include/linux/leafops.h | 4 ++--
>   mm/huge_memory.c        | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 4c1476ae32343..7c13c58a5e218 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -657,7 +657,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>   }
>   
>   /**
> - * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
> + * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
>    * @pmd: PMD entry.
>    *
>    * The PMD entry is expected to be a valid PMD softleaf entry.
> @@ -665,7 +665,7 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>    * Returns: the folio the softleaf entry references if this is a valid softleaf
>    * entry, otherwise NULL.
>    */
> -static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
> +static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>   {
>   	const softleaf_t entry = softleaf_from_pmd(pmd);
>   
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7140a1031fb2e..ee8d46827ffdc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2518,7 +2518,7 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
>   
>   	if (!thp_migration_supported())
>   		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> -	return pmd_to_softleaf_folio(pmdval);
> +	return pmd_softleaf_to_folio(pmdval);
>   }
>   
>   static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,


