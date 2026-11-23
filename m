Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25EDB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sBQpjXnl
Received: by kanga.kvack.org (Postfix)
	id 32B2B6B05B1; Sun, 22 Nov 2026 20:41:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB766B05B2; Sun, 22 Nov 2026 20:41:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9F96B05B3; Sun, 22 Nov 2026 20:41:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F1AC76B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:41:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81723A07EB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:41:47 +0000 (UTC)
X-FDA: 85464682254.14.AAEF041
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E03640002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:41:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sBQpjXnl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795398106;
	b=MUH+ELosEODfHHkhqmcFNTaGwjwU3+Ar4RrcDR4CoML6/zVjaK45BP7EvDFYrCFxXDdGkw
	QGfwrMLNIEY2J1R3zlvxkWjbcRKtrilsaFfJx1nJ/fiA7Ommo8d5qJkE8VUIem3hdjLCGe
	SqbChDH1RbDNPk5cVlGpchVFumgFPJY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795398106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9jlXwi4tHZJCnx1nQHaaW2a8Tr/fjKN52qDHg9VT74=;
	b=ysY5pDFm+cUhXMUQjlgQqXu5TxBUgR7TUB5bv6tTghnaWZq6Zzcr4NN9knQSVNP0pStqaE
	G9dLL511CSpeFy4yyQRl+MeTmvDLJpDbiayILmLRJY5L4GuonhiJ8TfhxTd7XId4KNIjE+
	F7Fa9yasnUm8eiZED7N46PJ0X7vqZRI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sBQpjXnl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795398101; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z9jlXwi4tHZJCnx1nQHaaW2a8Tr/fjKN52qDHg9VT74=;
	b=sBQpjXnlh4t0gcuKgQoP/Lia8cQVdOpG29UX8omVbik/pF/j0tYuiR0ivh6eq1tFOpuQD+eFNaiBEwg8pc7iE7aaulHrFOT9Ml3FAtWgUhXk3Bq6hgPN5YssmMGneI7luM21KXkI9wtMoVSfU0fq8E5+ZUaXydZEUXEVY23tHTE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XFC3KBS_1795398099;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFC3KBS_1795398099 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 09:41:39 +0800
Message-ID: <1a5563d1-6f72-4530-935b-975bd3674ea1@linux.alibaba.com>
Date: Mon, 23 Nov 2026 09:41:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 stable@vger.kernel.org
References: <20261119134236.3745231-1-kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E03640002
X-Rspam-User:
X-Stat-Signature: bwcpqzinja1eu1jun6nyrkaehc3samui
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795398103-642127
X-HE-Meta: U2FsdGVkX1/HyXdOioG4w+9YfwpXt4Nv4KHcwzeiOe2pbEbIClC6M0jxwtjAFc9io72KWh0v5PpXIfrMiGvjkGtxVf8TibIcmzopI9+bw9Y6R/L47F9pBy9Gktg2k5aLmezgrrOa3U1xv3vJWTwMsKxsufPdpwUQj3/t5hgvMJ7Rx4MAtH5/aukN+DK1qAuzKBKwrByCPb4kYhR0HHXG324DWtOkr6Wkr41m+Qa5fbPmMx9ZHNIeFi010NvhISY5J0LnPvSu5L2CjKPOedrvZg/UGr9tMlecNsMzCDUhSc5PEMyQ59kT7OFrAPL2CnWg+28NLWb3woZ2rNQxfJWlPxhXPRDgkc2p/BAjls7GrvD6So8d6vFJSEbxhA8mk8RI00Pfb27x0d1i0XvguGc3yKezf/xxhX9LKsMhDKVmuBsL88twG+Us5+Wbqvx8CQ2j4bvPU9DVf1hZ4zasb0qAIdyj1Jom0w0KrfQPh4sPRAZH0+KUhSJzJg5KiXnRS5IOOz1unMkZn16CSGmjMPDNqBVjePMNy/8JFb2eiLH7m/kGT/KKyK7FxxJZ8GNijyWp5WBH88kjWhVYt0HzV/dsvAZkgL/TmsWY7ofNc2QIEhfGvL7dh/GzJ8KPR5vZpT+skqE4fUWbXCXsRWDh/F27nVBhzofWGLkf/oO/njV7KDlJe3IoZ1hAT32F6n08TcIEwdwKUhekBHq5KnxwoCRVNiHZN22TGaPcxJOSKDEtrIONIEDZSv9S3G3ykkHAKus9jW6UhkFOZh6N/zw0xOJzu+DkWIom6MuJyfb3wNBNekHdgtNfpW6cJAJXH2x0AJ2UajaRfZb71KHLrn5TOMGVGJx2YxYrlwkXBvhWKmMPjiTM0qEzgYO/r8jS+8Th+Mflbn6oVx5zJFJk83KaVpr5hRn2iSljyxR/+evLcZXZBBezrJaYQgF6wH4lB8U6dIH5zP0qn1nbq5LaX76Y74y
 2F39YyR4
 hf5RwaSDU2o8jA/lEFxjBp/IOMev6JtoEMmNdvKS2MLE6EDH4gBFMOltL/a0umafRWiWTXccM2a/K152XUMSjsArntKskcWBux6te/ut4c9fIntDkkoRqzMAo2fMS3JHtClaZYB2SF/dZz4/csacpQdPwcH23bTVmJcGLcofeCn+/iPaVpI2v90JVa3koBZgHOnSICR+LwO73fC8Csy0OEDN7upYIq2/qyQFHTIpMRlz10EUZanLd0URSTVA9GnkTnvY0ZwZr+3RpaZ1bA+MnqtijGJK0pkPozyCqnAN65dDtg4MuOSRHFHst6NxWvfJCSbuVwt9MM/pQR4mB8hJmg6MvY4Q43z3lbloHY/8msSuTFNo04vh0ayl3nwsvxWZipqYm2WihLYwCWbk1Kwvk9rEwnWvwl41s/DNLNRAPDJ95IH7vwOZP1XumGR+pRirinXFBGDwYGzk2NdvmKSkuLq6XQ64VrKBtRZjCpbdPMIB9GLIy8dPV7PrQ2m3cdlXptAE3iAjNHhxFhIw4O/OstRyiEVZovY9gYGmHegj49GVSER0K9tamzPc7VuewAAxwsDxDMKtptGFXSdXvoT4cMJc5PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/19/26 9:42 PM, Kiryl Shutsemau (Meta) wrote:
> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
> 
>      do_shared_fault()
>        __do_fault()
>          PageHWPoison(vmf->page)
>            // the faulting page only
>        finish_fault()
>          do_set_pmd()
>            // backs off on has_hwpoisoned
>          set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>            // maps the poisoned page as well
> 
> A process that touches the poisoned page takes a machine check instead
> of SIGBUS from the fault.
> 
> Map a folio with a poisoned page one page at a time. The poisoned page
> then takes its own fault, which __do_fault() turns into SIGBUS.
> 
> Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

