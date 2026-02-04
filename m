Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F33E8B383
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78C96B008A; Tue,  3 Feb 2026 20:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BE76B0092; Tue,  3 Feb 2026 20:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4446B0093; Tue,  3 Feb 2026 20:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B446B008A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:38:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D68A1A05FD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:38:05 +0000 (UTC)
X-FDA: 84405063330.08.5CF1E8A
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC60814000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:38:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oHUcJhAl;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.12 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770169083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2a1QLi7lGtUwAEBkHLYxXoFJSHkjdL6qXIoliAPoQLM=;
	b=xT+79ETHRE3e/HrIN4+oLVWe+7IBZTcdXgCxIFNBiyhzFeMn5HtkKTeXp7r4RTyDeJ4N+c
	NuN8h3z3qo+BJaC/CyeR29MeiMQjzWobPB3c8Gq6wxIlnhxttLgJevvTPR4lMI41kHz1gY
	e3jBYNctSuhyKBFMu7ECx5W+y3y3bCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770169083; a=rsa-sha256;
	cv=none;
	b=ou6/TiqeiPbWY4hHMGu89GHl/eQNsXeWGd5lo/GHcxNfmCAl3NGUaTx5XfSOkWO6lTKJMk
	Z4C3fG2vm0E3a4FbUtxulnQDf8cuVabSfeGXfi41YYegX4zajHCyYRagSof9yLwqSIJQbP
	sSpqTjAoS2H5TY9KGiYtnqlGSAhe7Z8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oHUcJhAl;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 47.90.199.12 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770168477; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2a1QLi7lGtUwAEBkHLYxXoFJSHkjdL6qXIoliAPoQLM=;
	b=oHUcJhAlCt6P3eAuYG6nEdkLpDkLKsUuPtwsyYBVg4Mniwy+1VE+b3O5aC5YlUpz4G6U7lB+d2GW048wRzL1zrETcH1gvMKvkuEYYNWV/lY06TXOhwpccLz/ZtB2UM3a7eC93K/Hd0VdH2tk31EyL4fI8QoenULmNFDch2l+Vf8=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyUcHFa_1770168472 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 09:27:53 +0800
Message-ID: <07f6ea98-0bcd-41cd-aa91-3ddba0539dcc@linux.alibaba.com>
Date: Wed, 4 Feb 2026 09:27:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_idle.c: remove redundant mmu notifier in aging
 code
To: qinyu <qin.yuA@h3c.com>, akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org
References: <20260203102649.2486836-1-qin.yuA@h3c.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260203102649.2486836-1-qin.yuA@h3c.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BC60814000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xcwaiuo8pe8nrdd759hoena6dyz3w4y9
X-HE-Tag: 1770169081-254598
X-HE-Meta: U2FsdGVkX18TF4QOe5fi3gwg7q7MXzb/goAnM10lEmdkt4FozyOktSmlK1cywrwRs7HAOe0QSnwOK9G1y8fOu8UcXrTV9NyC4j+EoZGm0gn3M93H3guAvcc1wSrnf91Sp63SPFwCtQLjwrxi5BjKS3BBx3CcjMCuDimhDJ2Ts67H2p/dbPaqCZErwwaU3T2DKQsFgfOaZTfL4I0rvePGKaV+hLC/vgoPWJiMgoNitg+qXHa00ZH/PPJASvnNM6mUYBw7i0JOKSqt/ptlbvcZ83jcoQ1I8pLqG8VnISklgqv5TIEbpxmKLBhVQgN1MMmzoZTrRoSpxE4KVIo00jbh6Q8up4feGO9ioJZ31XgpXAvjjt0oU1YbNLQ9VL5HRA7a7NleQIo7dTd0sWUn0Y+bNXEsHfhAE8kKqXUtQ+elnOZk+/fthUHehKSmHDfDoY7Ao06KVyZ6+pCsJK4+AyLVzl9Dzx9a3uchT1y7NUSlWw8P775r+d5k9nUMoQzBmyt5FyLAoceOx3+SNAUtPEH84zhFjcl0TCBXUBK2ktN4HRrrS8JNvlyQRPG5E+Xw8XHvC4SarjjX/72yFQdnlPOu07qjH8e6Zam1sxDptxkhx9vxrA+qLKQqRrhs8/UaNfM7/HRqLndBc9R4ZEtZ9YTC/75yh3uGLTTp8sumSIV/6+xw7IjiErKp18MKDSW1XFzJmKYXFINAfws6GGiUH+d+SV1xpdRSmkk8WwyKdKKX63Aw5izmxGgn3Zfqxy1qtk3SSrRKIGuL/V16HSuZEUtWd66bav4vS3gsrMF/EirWYjk01N/MsfwmM/vtwiDIDJNyem34LS5elf5n49G5Vf8jlyv/7sl/1v+mXEU9F3x8RVK2YFxSA24l8NiFNx/DKDRu8w2CL2kQfv6QysfBkf96YHGuWxiESCYef6doqsW0ka1K9Vxh2JJ3mwLWXl/zydVgsiexDc23aDXuNuxH0LG
 W6LvkmiC
 bqE7KQy5PkmJeM73j9Irs3wMAmW/dZVNbKwMMMqUKFg+oCt1Sqg+QPX4aN5T0WG6vDsZjjMV0iYsPBSp8GBaFn+4fBrYFqa13bz/tIubwvwRQ4kl019djxvFa6I7cZWKdrndJhbVksDz2MbZm61Fq80nPVDTvAik9N52OurCaT8QFCZP00L4tyeMdXetbwu4ixoO9807Vll2wU88bi61Q/jKh4EWwG4ag6x3upuv3iSuBlkvtsHgMy3uGhaVwidk805WwqpWE/Ru3kMFaU3w6qWDLsjqUOESzvqKiFyHYhj9eAvVtKUdjBWczbfYoqWSnzk2TWORjFJ3O+8WSINSWUMrq0aD/Cq93t/nztan6HntnT8XrY/+9chiWYrmvlpsUxe7catkAc676MvUPA2reRlNGEZvLh6+RAVLISjlRHEYOLXJKcV6L8TNRS44M82d3fUrt64e0MdMsDaQCtN42J3zf5Nb/ToH22sbXahLOpDSQuwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/3/26 6:26 PM, qinyu wrote:
> now we have mmu_notifier_clear_young immediately follows
> pmdp_clear_young_notify which internally call mmu_notifier_clear_young,
> this is redundant. change it with non-notify variant and keep consistent
> with ptep aging code.
> 
> Signed-off-by: qinyu <qin.yuA@h3c.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/page_idle.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index 96bb94c7b..9c67cbac2 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -74,7 +74,7 @@ static bool page_idle_clear_pte_refs_one(struct folio *folio,
>   			pmd_t pmdval = pmdp_get(pvmw.pmd);
>   
>   			if (likely(pmd_present(pmdval)))
> -				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
> +				referenced |= pmdp_test_and_clear_young(vma, addr, pvmw.pmd);
>   			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
>   		} else {
>   			/* unexpected pmd-mapped page? */


