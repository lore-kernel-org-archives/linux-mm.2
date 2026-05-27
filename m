Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D741CD5BD1
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6176B0005; Tue, 26 May 2026 23:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6276B008A; Tue, 26 May 2026 23:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695726B008C; Tue, 26 May 2026 23:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53A866B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:35:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 244F81C0277
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:35:59 +0000 (UTC)
X-FDA: 84811786038.07.4379512
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id EA1174000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:35:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ABWrFTgX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779852957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/dvUtKgd/9QJ8D28aOAJEXGFBb6PbtKyMzWlL26Lhw=;
	b=qz8j1KC0dZM7BTYLBK2FA9ehXTIlL+u47aVCdjTF5G4flCqr1hhARSs0FS6jrbd3s53RKW
	LbfWQl05wGeTaavPWwKou0CECZUWqp5vr2MXZHAKqX/OLGKaI9O7rriD70jzAI0lG4TYWQ
	dVl653eA/leExWOXAdGlDpZ2W06uRE8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ABWrFTgX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779852957; a=rsa-sha256;
	cv=none;
	b=SFMWA9e5VhRhAynp4bo2CglrKsiqwzTNfrvZO1+91wlnXmCsdJQX49ulXvQwKmljhaoawM
	6Wg4qOXixZQn3xxDy8u9KwKTvnBK/VTGda1iBOOvceqGMRlmD64WkiHs+lQrZ2W6YC7UVM
	bqk+lZZeNmIx7VMwroX1ezBsWbof40k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Q/dvUtKgd/9QJ8D28aOAJEXGFBb6PbtKyMzWlL26Lhw=;
	b=ABWrFTgXCg+vtvUGJPbUrbQW8jHQMNLeqhTy3Fuhept1IXlZr8cHqTp3UJZ8CyCD0Suk73hww
	Aj4Raoylx5GctYIkH9XYgQGix2ZwNvKcYxykQAe54RPbgr4MHpcUsHnSqOiqQm4HJx8EALANZ9X
	VJcvLkHHk4O4FsCJp6BEjmc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gQFS84z2Qz12Ljl;
	Wed, 27 May 2026 11:27:52 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F9F040571;
	Wed, 27 May 2026 11:35:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 11:35:44 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 11:35:43 +0800
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock in
 get_huge_page_for_hwpoison
To: Andrew Morton <akpm@linux-foundation.org>, Wupeng Ma
	<mawupeng1@huawei.com>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
 <20260522205041.a85237b104d74533c13745e4@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b62f860c-f7a9-be66-1066-baa1825ef37d@huawei.com>
Date: Wed, 27 May 2026 11:35:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260522205041.a85237b104d74533c13745e4@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: ria97acy4mjhzak3sejq9qaxijpzdch1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA1174000D
X-Rspam-User: 
X-HE-Tag: 1779852955-393323
X-HE-Meta: U2FsdGVkX18Ahi16ybFev1ow4rYGKIQ2DAknNdtX+fdmIO3aykZDXsS6PQuKJnlBaZ2C1bopRBpZnmOljaMIjTKHHFwbjEakrUaWCiJ83ckLJTzq1bhnsHAn/GKsW7BvgidfT6/NB1XW+fDY39T88pBDjR+JO7h/fPPg4zQqwpGnVh60Xv/guegowLkUfVVYaDHhuimhkxBhJA792HpuGdQ2xCCNTdDRg7hLlhHvvTF5S4hw34RdsN6lByOvC9oAoaBnzUYu2gO2Don83wKlOSZ79W3KUmjbDSiVrq1xgVTHsQ63HSXoBKIRlHWLBZV3rrX3thnkkdb1dgTC7ZY1kLug9HyNhIclinN9+QFrJXLNnfCff8LpsTrE/pdqK+sQ4+iulzLMTY+qIv9g3DYjf3fhPtbthlRLr2E1gG8RFB336kzty1YIrrJ3JdLRFI2uMCTcNtKfaRKvfNe2LQqcRJ3QBlTGmwrGy+xGdfG4Ex/8qQ+iqddbhQUx8Qup92M4qSNxM79DBWX49XC00fTV4gTihygzFGFKuKe7wDeJmiT2f2DBm3G2ikNrRvPSKFaPUL58cU9xgA+Hh0a+NYCdI+KDYNFEHGz34WAuCUqsekwzyRf/H4srIrAYlVPqv8r357KjKrcUD1AtYcfZDvfpG1j75ntIYJiEojQNOLE+iNQ/svpHULPt8L6Eu5oA8vIHLXB0iMadU1utDZCkTeeGU1zU0qIN7yvaZ3eg/76ijEkmsPEV2cslsIZwhtEpX5176D1ibPH2c1IpMFJ/FX1zL7ytQW/fUCXLpx0mq5LuuY6u02VgeIGNCBw1bxISLhkkXFFNi6F0dy/ynze4CnllvpRJLvNdNFsxewaF1k1WEJrvP72OT2RUExOzd71Y0AkSb50SoQdNzH4sSY4Aid0wJxj7y+yYxSqBUGNgRWxm+DTnHvKVSw4lbzF5xqkTtfZjRIjQDsdtuoNH7Yw4naM
 19UVrKHG
 4wqWSvjyFfe23GAIuV9tqPnCyDFUK4EG7NkddDYmfGyBcAf2GYmSNuBTKz5fFsTgSEmTQqjeWEedsqceuNesE3uqOcICQxQJ8PirvSFXKGJi6eGqHmx6qoAvjpFV9wFjvVKQ/E2+gxlZ2oOYVkstuKATlVIc6FdnM840AZ+IVmIZIDnk1kAiL7GGRJVFYCCYLqNu2q5aw3VO4u8wBio0C/UdhIl/Smz92bVki5ZCRiPPDB51MgB0rr8hKmadULXqTkGwxcMcRJMba0dLyr7FpWuHWpak4HEpiGURDsyVfJ+66UhnpsmeSsiFt2EqeCWsXRyvy56XfqZrIOK1cKnIrsiudoM7mthDsuj+XBC6teUVogYVzuqZTLdqQJydV61sIOTy4NVJEamj+87UbC0043AEQYZ4Mx9hEDnfMtUwVLBiXgtugl2jg6F2GNbR1iDi61vqqfaPgbtuuOiJW2N46QBmFrnkqicCZKcRQ6sJmDYa5nPk712+DkTOaScAS9XfSCJIP2tN+H5pYpSN9BVoxP33g1GuP+wRbb7Yr/mGFUzrU0Q2AH/VqL7Pi1IaZMnQRj5TjF2fxQXNIMP8suneRPlqhN/1bIxk6+S84S2hoxHwwnxuFbnDR1vfIAybjDCbg7Yf6afqrQyOk6I0wRjas0mnxeJQouGf8o+3YtD+JAwvTRVZB4RA+KIqnNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/23 11:50, Andrew Morton wrote:
> On Fri, 22 May 2026 09:03:05 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:
> 
>> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
>> can trigger a recursive spinlock self-deadlock (AA deadlock) on
>> hugetlb_lock when racing with a concurrent unmap:
> 
> Well we don't want that.
> 
>> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
> 
> So I'll add cc:stable here.
> 
> AI review didn't like the unlocked page_folio():
> 
> 	https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
> 
> So I'll add a followup patch which addresses that (and which addresses
> Miaohe's naming nit).
> 
> Please let's check this - perhaps the locking alteration isn't needed.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
> Date: Fri May 22 08:44:25 PM PDT 2026
> 
> - address possible race identified by Sashiko
> 
> - s/out/out_unlock/, per Miaohe
> 
> Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
> Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Wupeng Ma <mawupeng1@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/memory-failure.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> --- a/mm/memory-failure.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
> +++ a/mm/memory-failure.c
> @@ -1970,14 +1970,15 @@ static int get_huge_page_for_hwpoison(un
>  				 bool *migratable_cleared)
>  {
>  	struct page *page = pfn_to_page(pfn);
> -	struct folio *folio = page_folio(page);
> +	struct folio *folio;
>  	bool count_increased = false;
>  	int ret, rc;
>  
>  	spin_lock_irq(&hugetlb_lock);
> +	folio = page_folio(page);

This fix works to me. The folio could become stale without holding hugetlb_lock
due to race, e.g. hugetlb demotion, dissolve and ...

Thanks Andrew.
.


