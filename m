Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA64F606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=PF4iTM6k
Received: by kanga.kvack.org (Postfix)
	id B3B296B05B2; Thu, 19 Nov 2026 02:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12FE6B05B3; Thu, 19 Nov 2026 02:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29486B05B4; Thu, 19 Nov 2026 02:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8204B6B05B2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:30:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A507A09B9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:30:44 +0000 (UTC)
X-FDA: 85451046408.02.3B25F78
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf30.hostedemail.com (Postfix) with ESMTP id B0A1D80003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:30:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PF4iTM6k;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795073442;
	b=bw5/vVSijk8uRCadYsKP8jyvtkRpjnwpPlWf70XlZXy1JBCHmAdXPEpG2p3m4LeBSeFM4b
	LS/5wont/OnM7ahYslWdZf8tmlK0joSNnGdhuGAzoSp0U/9HwGMsG/K+ety7HABlOmudwx
	OEIKG2QUO6zMTYwl2H3KmZTBh1oRRmU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795073442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRIZGSNX1SJo4wwhmW/nPOy71Xv/LXzRQReFt3dC9Lw=;
	b=veiuAoKkltY7yxZp3W3ZCs8KSxPil4SDyF5Mib0x2rJTDmRfnnhk1KWGa+svcBYrBJMYRL
	Wyfkk0vTYZFek2VmkQ5Vnb1CDalrjjAATGmPluZsX0izkao9pSyD9xarGKB5w/5oZFCr2U
	qlrFjuOAiWk0Z4pG/bXS1JTxM3VCQfo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PF4iTM6k;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WRIZGSNX1SJo4wwhmW/nPOy71Xv/LXzRQReFt3dC9Lw=;
	b=PF4iTM6ktsux6ow5pg7V5xCa2osrwLKrEphmhfonI7KPivX0vm5gzTgB9o1uza6b9/r6DBAWN
	hoog2L7+F3ULC9c3KYAbyfj9itXvV55mS9uMdQrkN5eoSyQq+/NEyd2aTRy/PSjZmEK8+qSeDt8
	Dt58kOcgMPpS4MRwtuq34VY=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jVVVf0lvwzKm4h;
	Thu, 19 Nov 2026 15:30:18 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 0B85C40561;
	Thu, 19 Nov 2026 15:30:33 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 15:30:31 +0800
Subject: Re: [PATCH v2 1/2] mm/memory-failure: don't unpoison a leaked
 raw_hwp_unreliable folio
To: Andrew Morton <akpm@linux-foundation.org>
CC: <mt4022@columbia.edu>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew
 Wilcox <willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Yu Zhao
	<yuzhao@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>
References: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
 <20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
 <11f434ce-58c4-ff16-9c93-946a1e83eb10@huawei.com>
 <20261118231118.ca2d773881cd953d1efee4ca@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <fa02b7d2-fa2c-aacc-ab16-c475885a7dfa@huawei.com>
Date: Thu, 19 Nov 2026 15:30:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261118231118.ca2d773881cd953d1efee4ca@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: ks7oqwp9fzc68pu1w39so73k5cfnabub
X-Rspamd-Queue-Id: B0A1D80003
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795073439-209641
X-HE-Meta: U2FsdGVkX1/V1ppBazIo5A7UbD8j6ZzS0k6FaxOEPgSXwbf32Y6OFLgMUhXtTIGWc6vthF3giBRfjGHz9wmlK6ee1SPXV6FnQtbEiMUOyiJZbT3y3jFnzIflhyqNB98vskDZgtT8eSQZRjnxgD/d2n8Xoo4m+NNBM/VewvTx7Ug3cxSxR9qcWehUhfpuYnhoJFgiTVRGKWajUL+9NQJmM+K2C1P7FgtrVIOsN02ND2NNL6+CajfCIzNtHGmHEwuFKXRwCBuOyIp7WUvBpqZqgUHbaDipsPMdK/rur0lp7NZx/PN6Debge+7dAe0g80Mex9GaUnuHhhgqz/rGSAjxi+rSljoW/k8or+2MwrTcwjkBM5ZBM8nG8DvBALNJti+xgc0CSSadHF9bqQukuWmM5NNbfoLtf42b3zBiRlavl7UQ9xoYt5iFLyNRwOt50J0FhPw+Kbw4MwEQg8IrX2XJfPCqYLXt1ZjZpalV9SQW9czyBQpWeP1aSNv5C1ovcmj3pdgVoef6mId1WYxLsYfWKxnY9hG0aAG4LsfFDdUWSIISlcaz0GPP1Y0748ftUe/hDsC0YuavYWNjf9hI7grWyFtfp4HtvoLv8dQYYFx8T4nRX080Vb1YpQHORn2AuYXF3voOLtnGDoxv+H7rCktGx0/u+1uoS4LEYaF11E2dA+O87ps5cLmv7EuJbToZvpKmcp5OWnuuYOBUxCv38Uxs1ZvfpUQt2pleXbaYLgMbisDy+oqyvyE03oWyG8TWL+sOq6lq2wnAsP7TY2NHIY7CUsqiUm32S6ryIVCEGqZvjZCVmj8aele1/9iGYj/BCEV4aWI90AfGHaRWsdHQAs0KIxfg0s6h0iwTnVuKGmNvpcmD2bb9Zxc1/N8rsX8ynl4HiATX2OIY0w9sqBxvJSvMl+tv6hQBFiOOKIBojsfUhusVerzjNhgtYQi1T4BgBctAlxWsLncP1S/H1EbaAy2
 wOSpfp82
 JdHZiJkqKiuMXREh+N47jbUi6dOyBuSfWybJ1o9BoyPjt4kf/H5f/6EHKtGiXEjRlUYl1ckFa1O2SXChd9Ppz5J0MJ7Y/wSZHHMa68hQ2FB0We0LMSFT6su1zGeCBs+X5LT8+66puR/0qVr3NH1g+PMO3Rn4gWmNdLFDEMNp13Ly3/5Bdc1DYOUDGcFO0PL6qf9ZXsAJkOJeZG9mHF6o5b5JZX61InjVaSRIImWwuBpcgPwIT2SrsCV/nv3XscSNz0O+BKnUEeUSDLdLEjh87JGlspqNipx8l1WmjnDfouvKozRWrrJ7Sr7DGOeVp5pcPctm79QvaV0TRiMo9AZzwOFq/OqiPtAEAeq7dATWE2yQXNzq65dsuwYHNalKUfxWyDfeZPXluyfqoEgppMD3fVjeHuddzgH/D0Reo57823Esifi05bdVh2Mutgbra+o5/5pIPhSNrIl3HuT40dQRzj1cXaxMuCs749dAdcvIxIyxjayGWBiK5ddbTHld+TTDABjcyz9eycxyQS9QGGd1Q4vFC7wmm38yu4dkyORmSE3psAgi/ODjAHYTAt+P3MD2VvuYN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/19 15:11, Andrew Morton wrote:
> On Thu, 19 Nov 2026 14:39:24 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>>> +	/*
>>> +	 * A hugetlb folio without reliable raw error info is leaked once it
>>> +	 * is freed, and its hugetlb flag may be cleared by then.  Check the
>>> +	 * flag in folio->private, which stays set on the leaked folio.
>>> +	 */
>>> +	if (folio_test_large(folio) &&
>>> +	    folio_test_hugetlb_raw_hwp_unreliable(folio))
>>
>> It might be better to add a unpoison_pr_info here?
> 
> How does this look?
> 
> --- a/mm/memory-failure.c~mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix
> +++ a/mm/memory-failure.c
> @@ -2818,8 +2818,12 @@ int unpoison_memory(unsigned long pfn)
>  	 * flag in folio->private, which stays set on the leaked folio.
>  	 */
>  	if (folio_test_large(folio) &&
> -	    folio_test_hugetlb_raw_hwp_unreliable(folio))
> +	    folio_test_hugetlb_raw_hwp_unreliable(folio)) {
> +		unpoison_pr_info("%#lx: cannot unpoison, poisoned subpages are unknown\n",
> +				 pfn, &unpoison_rs);
> +					
>  		goto unlock_mutex;
> +	}
>  

Looks good to me. Thanks Andrew.

>  	ghp = get_hwpoison_page(p, MF_UNPOISON);
>  	if (!ghp) {
> _
> 
> 
> .
> 


