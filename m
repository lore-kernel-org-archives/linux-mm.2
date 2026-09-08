Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DFAC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4546B008A; Mon,  7 Sep 2026 21:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC0D6B008C; Mon,  7 Sep 2026 21:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1826B0095; Mon,  7 Sep 2026 21:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38DAA6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:48:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A880C1C0860
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:48:26 +0000 (UTC)
X-FDA: 85188910212.09.55138DB
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA10A140007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:48:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RFeKGN8q;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788832105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sj+gujuvTHFxhZN0Qt7S2VOpoMJsQgUY9QhEhfjAcs0=;
	b=CU6ygU2Yy6aQIbOKpJonnrlC278S9N/2eMQBscBSO8C8cEKtCZKR9YFqyrhmvFfkjTcpwf
	KA+CnE79uqcROHjML16VggKCRkUHlTFWRnF3ih+NMYfryPGu5g3O26rbRbCr6uf5XR6oeg
	sRRdlMH9eoYSHHq1A+oP/hCNI6+yUOU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RFeKGN8q;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788832105;
	b=x9jqjpp1RYWlwXVZ+ChicPXmDa+0IToCLBaowJEmNddWSMGndaew2CWFMFKoDxpxL1OWJv
	uhOBkKTYBD8LS4ILND0lcnzJ7LVuzk+UIxgFCnC+Wcf42lj9gnL943v3tJfhVSm3rwE5I6
	hAUcVaB+fNNKK8N+hox7JDdRFoRRRqw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788832100; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sj+gujuvTHFxhZN0Qt7S2VOpoMJsQgUY9QhEhfjAcs0=;
	b=RFeKGN8qjoMCBRlXoEf/Dr6/9GcBgoxJQgpzCcg6BGrnc7F120de9CS5nXny3LttvT4Sl32pak6JjOHyyXxvBYNcPiUpWeqHbKYWHlbfBUCSck+tbDcI4pR+LfQtwWbqYUwwmIRHntj4u7/TV83Gmy6Y6OvItRJL/W2KBCHli44=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XAZmSo9_1788832097;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAZmSo9_1788832097 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 09:48:18 +0800
Message-ID: <04df803b-b168-41b7-b394-1071e002e3bc@linux.alibaba.com>
Date: Tue, 8 Sep 2026 09:48:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] mm/collapse: state what a collapse may do in the
 policy
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>
References: <cover.1788533997.git.kas@kernel.org>
 <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
 <c070e67a-4c1e-478f-aa28-09fb88f8a786@linux.alibaba.com>
 <ap6XERs2j7e1lZCU@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ap6XERs2j7e1lZCU@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3q1g3um6pmyiukq4i6nubex7snaz1u7g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA10A140007
X-Rspam-User: 
X-HE-Tag: 1788832103-376465
X-HE-Meta: U2FsdGVkX1/uNVtUx421fPWFzQ4zTZ88oWRrvEd9xy8JoM9XCC/3/OS/Ee0pAFmk3ZHtodL3hnQsW+TO4qChGxoVBMMbV2YHY1NPwik4URCsYMSVzOcQLVh/rXcC/s7JGj40Gz9G3tMD7plUM6kPMdtHEk6F7LvhqPcJxbi6NGCpOms+6vY/zJsUzYllleBE9ttXmZYms37DWaXcmFCEC8awZcW4MkjW6tg+zVGS/prKJA1/KFcaWbtoIeiAZomLuw31+xzqUxfxJxioCN8kWGmZEV3VO07I3CYoJS0Z3GXxUL9SFlxaJyHbC6hq952SsSoSNZX6Ee6ORKwcrNAXtUWNlHsBC4urHFaelGo6qYqAb9tGZRLfyfB/b0fVXC2TNTODHUZYPXT3Je3E8bTdlA3NUqj/9HNetT8hBHWvogrLbfjpvOjWvGtnovzGJMHiwBzbbV5spnLidaeJSWmjhqbpi2Lg8Fh3Yze0GK9lO6PbCL76J3p2kflIHdHjJn6kdmXNdViYfihT2r7mEz6svSoa0NbeCSrqLm8TbluN4PURrCWWsgefWzNLpMtR0L8CqSgDsEzZyxU0qvkgmkrcONqEl13cA8nO4OQ9YqfGHUKtGr8pQ88ocV0T0wPCjzEgeEQldmPkCtLlUrB31kBtd0e/OHiLfy+SSJaTPTv/Yf8BXnniDJFOo9cvndpxDb7+R050PAEBjxqX141Pvf9th/kHCtKvMWCaZb/cBteKXaviNsYpf/wCBq2MUtUNjF0JcVOVQLpz8NTdtrniGNL27/Stp9duKQNEpWlziCe88E4GtIiw1qnG45zI7um4mz8iVauJziMNAsu8LJ4uj7V58DhlZN2gcRr4sZfATP90mvpc/C52it9ROus+WbwA9kvQ6/lGmGVNGgaIdVCpma28nZkgDDmWFnMU2dEj64UEFpBZmmPoUJFHkkzjOm4ODmHx+QNcQx7RcPPccbBMRll
 1Ha3p3NQ
 LcG06HJKdgbw9NgsNURUjic7TcQHe/D55bZboluIky8S4dVFdHZpgiKYBKden93c3jaQNh08F926UKNw4dD36ViYLdVrpxz9J6f4W+BCPr8EEWdJczHa7qvTmVq8MmxZTcfJm8bNqUmMy0yWPutqgb+0AxgwCTuERstAvY2Nym4bnkw08qPHHc3QNz6o5X17DFfnNyzU6zZBXbkoWOEP2ZqHwEpK7TQwf8Uy8g3JFHE6eOc9c3uiP4rH3PaXP4zGqI06wOIl46lbNPVk9tkgNQ7qmAU+SjT7o32KniPAZQDi8H8XqDC1cJJfKd7HR51SoMyHi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/7/26 6:56 PM, Kiryl Shutsemau wrote:
> On Mon, Sep 07, 2026 at 05:05:19PM +0800, Baolin Wang wrote:
>>> +/* What a collapse is allowed to do, decided by the caller that asks for it */
>>> +struct collapse_policy {
>>> +	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
>>> +	unsigned int max_ptes_none;
>>> +	unsigned int max_ptes_swap;
>>> +	unsigned int max_ptes_shared;
>>> +
>>> +	/*
>>> +	 * Hold a sub-PMD window to a stricter rule than a PMD: no swapped-out
>>> +	 * and no shared PTEs at all, and max_ptes_none as
>>> +	 * collapse_max_ptes_none() scales it.
>>> +	 */
>>> +	bool strict_sub_pmd;
>>
>> This is a bit confusing to me. Actually, the check for mTHP collapse is
>> stricter.
>>
>> How about naming it 'allow_mthp_collapse'? That way we can keep the most
>> original comments for the collapse_max_ptes_xxx() functions, which is
>> clearer to me.
>>
>> If others have a better name, please ignore my comment.
> 
> I would rather keep strict_sub_pmd.
> 
> Which orders a caller asks for is already decided elsewhere:
> collapse_possible_orders() hands khugepaged every anonymous order and
> MADV_COLLAPSE the PMD order only, from tva_type.
> 
> A flag called allow_mthp_collapse next to that would read as
> a second place deciding the same thing, and flipping it would not change
> which orders get collapsed.  What it does change is how a sub-PMD window
> is judged once one is asked for, and it is read at exactly the three
> places that judge one.
> 
> I will do:
> 
>        /* Take no swapped-out or shared PTE into a sub-PMD collapse */
>        bool strict_sub_pmd;

OK. Fair enough. Thanks.

