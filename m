Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D408CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703D86B008C; Thu, 11 Jun 2026 07:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB016B0095; Thu, 11 Jun 2026 07:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617ED6B0099; Thu, 11 Jun 2026 07:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5496B6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:58:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF13F1A05D4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:58:39 +0000 (UTC)
X-FDA: 84867484758.14.EC1BF08
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 176071C0007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:58:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iIHiRXWY;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781179118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRjngGChT72OdyfI+6mmhcUVkfKxErUrhBdzRmYMjJY=;
	b=nNt3kWElIfbHlKi6kBvYHpKXMtZ94qDziDGkkFwq9vZDUtEJiBJ/EJCCCVfu5LHLZ8FB+G
	VCiOemG95TJd8K6v58M+FG3g/rB5aXx7yJdIR48s7Si+qchzTKYs6dnu9SOyjbUShUWGoB
	TayCy4vxQ6MYj5kNThBNoZ3z62nBpRs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781179118;
	b=Dk5/e2l8KomlP3toki9l2Z5LqpXK2Fnk7vREHiW5ulkDwhqZvkTUlV6e71Z3L+Tp/83hXc
	JXNnKJ8uKBuq4SRSJBFRPyQWVNgOt5qrq5rgA0A9NzTr8AOpbXjE6lEabz+H4a/LL6a+RN
	8eux/VBKz9Lo60flAxHdXBjaFAvImLY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iIHiRXWY;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781179115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cRjngGChT72OdyfI+6mmhcUVkfKxErUrhBdzRmYMjJY=;
	b=iIHiRXWYOhkM76qqJ9NisfEY53PmcKcHbWDyAMpH5wWbBTNYdSqIzaeRLlrN4krVp50OP2
	755dQym1KT2Pw5aIBAYR1d/urcLO1QWd316sODKCu21CC2S6CM6GD4YRL+g7+XaZ1/bl1X
	7ykplj8gDBkU3rW5EXse1dcgY0A8G1E=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	xueyuan.chen21@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	yang@os.amperecomputing.com,
	jannh@google.com,
	dave.hansen@intel.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Thu, 11 Jun 2026 19:58:17 +0800
Message-Id: <20260611115817.59353-1-lance.yang@linux.dev>
In-Reply-To: <8c36a91d-288f-4ffb-b2ec-41e3ef789d72@kernel.org>
References: <8c36a91d-288f-4ffb-b2ec-41e3ef789d72@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 176071C0007
X-Rspam-User: 
X-Stat-Signature: hpgp5dseyn83ghzss7jaxcdmjexfzanw
X-Rspamd-Server: rspam08
X-HE-Tag: 1781179117-188673
X-HE-Meta: U2FsdGVkX19OkkKKRisH+48cnlnAYNhdWuzvrbSQ7Nq09aV1nGU0cKCsein6DB7qFxwTdL9gZT3Ap/GsV6d6JaVo+QJu6WHp0/VbNztA03Dxy2PMhYZMl30tCwtrXKYvP6fi20zPPOJKBRa/WBbrEavGmnlcsMEb4Biza0F1316/sLOyOtW7BDwI75Kx4/hRSOLJWLNs8EEvqVf8NeLm99GnH1bwt4oHoxdzaDNwgp0hzTb2WFR30GbDnC+TnRs2Dqt3b39flrWjq4O1eth6govXIapc12fm1YURLbvl0SWA3nUH1lZSPcqoNDse89RyV9io860xYyzJp//Da3XovzW+7cP+KalaVnxN3WmTugFBITLLUlGypjp2FL6xxmM0M1/8GAuykz84mpHJNkRTVFscTHQt1alO+xZR0E5u0W+FZ/4olTn6m6ZXyfG/I5v7UVz7C2TBmeFk5VO3wC6gdhiwYsM5npV1XlNuqR+y3kdgLpQFPY0ZkBEg9FwLKNFnvZvDWxrC/oUcTdQe2lT6eYdP2qRTYJ4sOFjixgGkkIrN3n6opxw5EtgG0kEsJNWVY3FEd13rPMvS1/jZnwMCpZME8AvfyxZohhXsyfZPl11Kvu8Uj58NBzzoBind4bQF3ZCpxCLsjzIQfaRau5NRzULwG+rE2vVJRq4ZUfBNbQyS1bEAs2ErUfNhev2/MSOVopEfrEdPHmEYxwWN1OQeSSOPEPxIIe7gEP19ayj9qLsEdP//mYoqJdVaJbth5oih8yxZdaWFmFluttbzxnO+8g+a8F5X5CbvxWfBhLWYVvBZERuwgWWJOF9OFxYbzp3ZvupXJ09svNs2jQ3PZ+BFwlH5HO9IMVD+ip9iGJP7hWHS+79Ou8ldEOvHkSJmJsvKr34mu9gQUw5FRM83pWu7mTAmrsD3iJRNeQswPNSDJu9NUYNUqaYZNiYTGh8a96iDL7yyKwLn+F6NzMMMs/a
 yJmY9yWZ
 BAoSxd848s6PRRgG9uQU43rAC/ENCp9myAIxFjoUh1rT7oqyxaIfDAwolsYboE2V6fXetWFw1hOdnWjSId4rkMltYcQst9CvgrpW4kXY7Krr06cXQIBPog4MknY0jwZQdDyF2/FZkQWp3qM2arxQG8Hv5NXKHogspjxlEZ5Fwc8Zg2c8hetBx9M+nFVPmE0IqUKmhT3BUi7xcFYZpSprsDjci7KVMBb42tFh3xQxxlSOABWbyru/6/A5mHidK7d3+A5bH2JoLqmuOZxKKkY1IupvRbOCLpPzQRotMai1YSQ7TDXHwui9GgJMqens1OdMkUIs6XWRjUGRtkk5FbThYO+9g+ZHBHBPEJ/trZwsUGoI+wPUA5n3z3087jd9yJ/8JbQVUlD8VBU7cN+kg+tP6+SzGqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 11, 2026 at 01:28:58PM +0200, David Hildenbrand (Arm) wrote:
>On 6/10/26 04:15, Lance Yang wrote:
>> 
>> On Tue, Jun 09, 2026 at 12:45:49PM -0700, Andrew Morton wrote:
>>> On Tue,  9 Jun 2026 22:37:59 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
>>>
>>>> The huge zero folio is shared globally, and its contents should never
>>>> change after initialization. As Jann Horn pointed out[1], the kernel has
>>>> had bugs, including security bugs, where read-only pages were later written
>>>> to. If the persistent huge zero folio is read-only in the direct map, such
>>>> writes fault instead of silently corrupting the shared zero contents.
>>>>
>>>> Add arch_make_pages_readonly() so mm code can request read-only direct-map
>>>> protection for a page range. Direct-map protection is
>>>> architecture-specific, so the generic weak implementation does nothing.
>>>>
>>>> This was inspired by Jann Horn's read-only zero page work[1] and follow-up
>>>> discussion[2] with Yang Shi.
>>>>
>>>> [1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
>>>> [2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/
>>>>
>>>> ...
>>>>
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -308,6 +308,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
>>>> +{
>>>> +	return false;
>>>> +}
>>>> +
>>>>  static struct shrinker *huge_zero_folio_shrinker;
>>>>  
>>>>  #ifdef CONFIG_SYSFS
>>>> @@ -982,8 +987,14 @@ static int __init thp_shrinker_init(void)
>>>>  		 * that get_huge_zero_folio() will most likely not fail as
>>>>  		 * thp_shrinker_init() is invoked early on during boot.
>>>>  		 */
>>>> -		if (!get_huge_zero_folio())
>>>> +		if (!get_huge_zero_folio()) {
>>>>  			pr_warn("Allocating persistent huge zero folio failed\n");
>>>> +			return 0;
>>>> +		}
>>>> +
>>>> +		arch_make_pages_readonly(folio_page(huge_zero_folio, 0),
>>>> +					HPAGE_PMD_NR);
>>>
>>> Can it simply pass the folio?
>> 
>> Right, this came from the RFC v1 discussion[1]. David preferred a page-
>> range helper for possible future non-folio callers, not something folio-
>> only.
>> 
>> Of course, we could also add a folio wrapper on top of that if needed :)
>
>Best to document that as part of the patch description: we don't really expect
>to have a lot of read-only folios in the near future (zero page is rather
>special; maybe it won't even be a folio in the future).

Ah, good to know, thanks. Will spell that out in RFC v3.

Maybe something like this?

The huge zero page is pretty special case, and maybe it won't even be a
folio in the future. Since read-only folios are unlikely to become a
common thing, a page-range helper is the cleaner fit.

