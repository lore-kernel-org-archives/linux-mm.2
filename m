Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971D5EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E326B0005; Wed,  4 Feb 2026 14:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBDB6B0089; Wed,  4 Feb 2026 14:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76686B0092; Wed,  4 Feb 2026 14:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3BCD6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:55:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41DF1160136
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:55:43 +0000 (UTC)
X-FDA: 84407829366.18.B3AF7EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F9E1100009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:55:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCY+qiQ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770234941; a=rsa-sha256;
	cv=none;
	b=LVctF7VHYJ10RdcD8VDKeCtFh+mqOVgy5GdzX9cSskQEfSXAiZugT3LDSNK1KaNbXreLkJ
	aCnoDrININMZUszOZAe5J66yHWn/DsySuLrRB7Z6VSf9fOIwsPLK/KC0h2zhxjnBfNNEEj
	ZI9+J8x9/eG7C6nmmFQ9HOOtqgAPNNY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCY+qiQ4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770234941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jWcA/XbbO+nkeLoviAPOeZo3SWOiuXAuNDbD7xv21I=;
	b=z5mrWyb3mqmh8SxrcZigFfykWurBvbiKCY65J8r/Key4RoC5otzi1QOouTe8S9XN6hbGIp
	NLmiuYon67jFHjJg4lPB+0Dbhm9RFwLAqEjQVhGo7wyh0H9A8uN9SBOAqkNqFokplu0Vts
	9gQbesQg9AMkNTwiz9/j/WluRbR+46w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5DA360127;
	Wed,  4 Feb 2026 19:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB4DC19424;
	Wed,  4 Feb 2026 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770234940;
	bh=E7SiYONFnBjZyoLuPb3bNROQr7xtT5319lNuGhJMu8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FCY+qiQ4jz8dDXY72EcyNZPUNF02EHNKLhG2vxQVyys5/9sxJ1IWZQeFgKoLYTvrs
	 zdbqN+Z/E8RRnZxAbIeReMV0Z5ALIBbAVTch0Sbz8tf6mfxCPuNZddiuTJbsivZ+G+
	 2bFQce5bI811bwFJeqSsSDrlC54QF0cj40ncm8eb6gH531NKOK3gj97S8COgBDy0m9
	 mtuhegW+6ENj5FKKYkC29/wii9otBm89zTiOL7wc6gWVQmaobDcW+jAw6Eko6H7M8m
	 hHpCMoNzMQJJAbsByeR4F2kY0ur+E6rtjimP9GsankPiOrOwMRHq6BOolx1C0Z9C41
	 Nxf4L+b7/5cdA==
Message-ID: <11399c99-f966-47be-bbb4-a7d4e79c8c38@kernel.org>
Date: Wed, 4 Feb 2026 20:55:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F9E1100009
X-Stat-Signature: 3sf9ptma4ht8xfyghiy97thkq9gude1f
X-HE-Tag: 1770234941-950196
X-HE-Meta: U2FsdGVkX1++2Kl59aH6M+gKGwdkI7qCP3QmT22pvyAXWpbGFAB3mc6/9rQPHanhqo3R7pUiwqqoPoFb1veoMzjkfq/god9y53AbPBlZE9jvzLZ1FUnEswslGddRfAyOrzdS6doDc4CSsknCJIljyc3HxmxhRPSwwC8b7xOEJpm5xXh3/0bgKg3SrAGWhiTSXEogMNvF+gSlpmtiFVIAL2bP83svlcdbYzGtMGazK0Qse242ZLOHYAqMdGteGRO0WghROFsjALU+OR9AJVaOJU53kIz3mZF8HPpD0h4+JXUJM2ySe33fYD80vqoQGEher0DsdDKBnAImuzpZRIw6bVNv8GjVMIpHCUYry3OC6CFh6skdt+BTDOuibzm8LpDl71B48dZcZO2VYFHoRWp63liFFrnYEZYUGPh3HXOI80D+NLmIF3FaNtcMBWQnL0fB2zl48XZYunsEyjSkO8RJdBSJcJVhrhqhyzeNH6PRNrc7WWPGlTHip9VITHu2l1AVzTOMCazWSCLhpCFEfUbDszPU3mmJ78qTK6sr6RcApS9oQo0wvrzCp1Sc5XK7UOgzlH0dPCcGgDtT+WCiRmr42mR/WIqGIQh3KdIXD0EWjP1UqxP0sl8QxlYGOTj8nLW5eqjRCWFg96r7ggROwBM2yY3HIKhqG0krNZQtvY3wxwNBfG4kz851MUr5cXKbgWUblG64gPRL9fBz2orF97dHhqFKdFLSYfhRjnpUABMYOfFdBK0HRxBF08YabFHnl5yH0ceHMOJB9RnvRHmXPoac4xeE227bBBKI+694kakrLc6V68wyh9nPnlkpWJPIIspBLir36dXgmQeQEV18aX39XSZNzg6qntXGFsH1Kps+TKhLhETRI1rqUvdpUBlXE09Ir8fvOhYtVakH5YDM7bvPrU6tSbfoZVS9vkSWmyoCoABMJkyh3wxxC8uNAan4o0CD4wyw17JugVXaTUlQA+M
 9DbWMrzq
 hse5WKmMou7npIkvH55raidakZJLJwlWyjAn7EGZsaQmNjtVh4EdUMxyIEBquSWGDy03+4oewV5Re+iLJeOgmAvJYQnrmyKYgr3AMqPtEkzXfum7ODYwJo7OQcc5mKMMch3pridf4udLWb7apRjg5x8ySB/O1Rb96b5ceOwxJAYb/oECMDzJpIdghuR2UtysoQlGvXYh2wzkkDYO3jPVSelGjhdk2JMcpn5j3J+yHXpGRisATz3i/sZohva3lUwr9pC5RnhiUe6XlqYNIlpQO4Bd6481DaI1BMDfbLTJyGldrvc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 20:48, Zi Yan wrote:
> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
> 
>> On 2/4/26 18:41, Zi Yan wrote:
>>>
>>>
>>> More details:
>>> later at sg_vma_fault(), the driver just handles a page fault by supplying
>>> a subpage from a pre-allocated compound page[3]. We then get a large folio
>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>
>> We can identify such non-folio (but compound) things by looking at PG_large_rmappable IIRC.
> 
> What do you mean? Changing memory failure code to only handle large_rmappable?
> large_rmappable is a folio flag, memory failure code should see such

Did you mean "should not" ? :)

> non-folio but compound things to begin with, IMHO.

I would say that we could right now reject in memory failure code any 
compound pages that do not have PG_large_rmappable set.

I have the faint recollection that we don't set PG_large_rmappable on 
hugetlb folios yet, so they have to identified as well.

> 
> I think we need to be able to tell between raw page (compound or not),
> mappable page (compound or not, especially for those used with vm_insert_*),
> and folio.

We can't identify (small) folios just yet. We'd need another page flag 
for that (just like PG_large_rmappable), and we all know how that ends ;)

With Willy's work we'll be able to identify folios reliably.

How to deal with that vm_insert_* crap, especially for non-folio pages, 
is also future work based on that.

-- 
Cheers,

David

