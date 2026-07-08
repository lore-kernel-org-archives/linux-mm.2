Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93BA6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792576B0005; Wed,  8 Jul 2026 08:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A176B0088; Wed,  8 Jul 2026 08:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6F76B0093; Wed,  8 Jul 2026 08:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E27B6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:23:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A742B1C0226
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:23:03 +0000 (UTC)
X-FDA: 84965523846.22.4CDCED1
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD3BE4000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:23:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RufyJkYe;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783513381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fo8Mr9X9mLiZ/hlXDMi/W+rPm93qY7pvM9Gs5YiAlnI=;
	b=6b6m1Y7o82yaBR6UwWnZWT9k6Ki5S+YnpvXmSDvNYeekgf7v2AFkgAw4+KjhXnMwKqUi3X
	S1ORrH9+EkQmtbto1Pfbowd6gOKkZgekECvsPreU5Q2/t19m6n5t40W9lUB4Eu2pLgqiK3
	s+brmVQ3yXYURCn3nyUkbOmucobEqAU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RufyJkYe;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783513381;
	b=ht8maxVx0F/x7ylS2ex/NoC9pkhzb1j9se6zphUFTUmn25GuULvAezhf5KLkrwzvKf62Rh
	4x0J0cYhMTKgqvc9/lTJR/dBRPpW2fiMpdJdbmnbS58mUoFZ+pYhdIbwM9dv/Nv5Sli21w
	hKKx6RxtU9enuaPgb+CBHyCs+Zsg7/s=
Message-ID: <2b316dd0-c6dc-4b9c-9de3-deeb1f481132@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783513378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fo8Mr9X9mLiZ/hlXDMi/W+rPm93qY7pvM9Gs5YiAlnI=;
	b=RufyJkYe4CzbD961SMRPDTI6aFLDcFT+PjBoKCSUG+7xSx7Mzqq4DK+9pLCmifeqypf/GB
	k09VK5XeZSJfMlADTfIk0tsbeHU+QZlBJcT+V9ZAbLGFHCPATaCjU6eVybWh/w1SENo0hp
	9oSxDylAAIZ5Ewtcokzwz6zHqHbCMAs=
Date: Wed, 8 Jul 2026 13:22:49 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com,
 npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com,
 vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 shakeel.butt@linux.dev, hannes@cmpxchg.org
References: <20260707191917.3213033-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260707191917.3213033-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7dng37hucwdq966mjgdomoqm5nqos4n3
X-Rspamd-Queue-Id: CD3BE4000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783513381-563379
X-HE-Meta: U2FsdGVkX19nSfRWG8zTpYfj9hG6jqZFJHEwbd9C499ujQU5yYFJzUqzF2tEEqR9tyCjoV3nLfYqaKIrxoC2etRh7mhVUqsGwHFspkPm0eJVqpL/H/+92FvyHhDvthIczQ7DtvWziFwuovAPuaCy5RvLhfvHpfgw5tPPzR4IVqOsYOGrl3JmuVOAAvuHoJu1IHQzlozWaB6qUWHz/R7jB7xFkCAiEmUHFMSk033KmgmCbXSF5AJySsk3w1AXjjNiim1AA9xUlMBr5zLgwStsedq2DEESfg55/5oGiW7PZc2Zh2GKPfEbhktpIIB0rJOBSwHycCD3omPWw4br24eCJGeZbEjOew7PbeGW5uFWI5aEH8zd8wVaz8IYZ6RxgPyjxW4XweP1KQ4YkUpuRPrT+fUkW+1RmhT4IZNkAw6vYU4B7aKlRmoFYahLcaVaiZXij7mEajFe03xYNH/q8pDbkWtfYGheoOQq+/9GQJV96MTx1q11C/cPEwwKH8OKn+3rihpPO0lw6JAgtP3O9vC/oaNPUJq6S3C4s6PIsUeGfh56pADCf0QqNlHc+vdz1SaM4mlfUxajxIitu1Rvb4izYfHttXAX1fUfYV1cd+CvBsv9KuUjcPe1/cRFI25DM4S2aDbPVu3aH2xDncOd5Ro/XfTcD1jjyDuvN/Yn6nNHdfInJhEy5TKWxhwlpzWI+fC5RpaJoOR5LjnNXVtjiPRaDB5YEb4uBzDmdrkipfnnPH2KTHFmE+56aEJdcMaDiO/fmyQuf+CcnpMA3Glfb5QzMu25TpC78y6AUp+t5UpxO0rC/7OS2XEPXNLlZ/OVJQFrJvYcHPNeFaOSQO56F/1S9D0Tn/Qypr/UzJrUoYsUpJXC7G4pcI808tFvhynR9yholF5RuvsvVSFQaA+1gg/k53NGnaPMaR2DwonY1I6IVdA85GNnnI6cceoE7252vSLfGiPbf+QRbaZOThY/+yD
 mwhbExAG
 gRnWBL14xnjuwV3IjONbYSzhS1iMwmoZjipKQNI2Rx8brt1EVBeqPtMVZ1MZ5usPbwaRrbOHiJJRXHins/upZOE/Fab6Htq8wKHqAUkZUa0878jd7HvFjbliLbqoxutLC7IXLNLA4eTcz7CUCbvhT0/29qs1KepueEtNe8B4vypOD5g5V9JpQ4HiADRR0U5VUJqcnCzK4L4alM71ACvl625GuZfFcpd6mQklCiZgV0h0Qaq+PpT1V7y34a5//nZi2qwPvxQ+wsm1QTr+0yPHzeoveP0Sq2i4MSQS9jZPqWuz+GBu1glHH1NX2xdSuHtEWKgFw7QeSKiqzUqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/2026 20:19, Joshua Hahn wrote:
> On Tue,  7 Jul 2026 06:45:06 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
>> to PMD operations") a PMD may hold a device-private swap entry whenever
>> an HMM-based GPU driver migrates an anonymous THP folio to device memory
>> via migrate_vma_pages().
>>
>> pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
>> for any non-present, non-none huge PMD), so several MM walk callbacks
>> that used to assume present THP or migration entry are now reachable with
>> a device-private PMD. The results range from a VM_BUG_ON() firing on debug
>> kernels, to an oops on a bogus vmemmap dereference, to silently isolating
>> an unrelated live folio from LRU in the aliasing case.
>>
>> The first 2 fixes were reported as pre-existing issues by sashiko in my
>> PMD swap entry series [1]. Hopefully sashiko won't point these out
>> in the next PMD swap entry series :)
> 
> Hello Usama,
> 
> Thank you for the fixes! I think all of them look good and they are fixes
> so please feel free to add my
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> One thing I wanted to maybe consider is for 1/3, whether it could be
> good to gate by !pmd_present() like the sites in 2/3 and 3/3, maybe
> that will be more robust in the future if there are other cases we
> should protect against (and the same as queue_folios_pte_range, which
> uses the !pte_present() check too).
> 
> For 2/3 and 3/3 we already have the !pmd_present() check, would it be
> worth considering just changing the VM_BUG_ON condition to include
> !pmd_is_device_private_entry()?
> 
> Just wanted to toss my 2c. Thanks again for the fixes Usama!
> Joshua
> 
Thanks for the reviews Joshua, I think they all made sense.
I have sent v2 [1] following your suggestions.

[1] https://lore.kernel.org/all/20260708122040.861335-1-usama.arif@linux.dev/


