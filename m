Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D90C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4626B0005; Mon, 13 Jul 2026 05:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BD36B0088; Mon, 13 Jul 2026 05:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9766B008A; Mon, 13 Jul 2026 05:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 619D06B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:30:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2CE912033C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:30:30 +0000 (UTC)
X-FDA: 84983233020.30.E8CB4DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F340E80003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:30:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fA9fJoo7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783935029;
	b=WT373KkMZbPmVh+hIED5tgti+++Et8nrIZDpTe5oMOz6BxN4+mwGKAe6Hl9j080czb2tqQ
	zOJB9uZIsTS95XoJnv9qaZInVfcOdo+t2eCP2Cg+8/ZVpgu4nMdeyTm/SIu/2N1C2eOyrZ
	roBzKal7keTGq68e8hVW9wh6fSYuq/A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fA9fJoo7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783935029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+HnwQIMWga6Fivte5SRYooq86xfzTJgE0AFjo4ZSuw=;
	b=sQW+VYLoPbFKp5RLYTaOb7z1ECMpytgFv14lMpVzXXfQ8AeUs4J5C28Hvo/38kHSqjTR2y
	6cfbUw/Bc7UttLI/BPA+qAG0VrX26rDEM9oqSE+BsCpInmMHgJ7uQ3M2M1Ufifv284AIEU
	MnGNuy3xRw4OVOGEsin8gwUTG4quZuU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9DF941247;
	Mon, 13 Jul 2026 09:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B971F00A3A;
	Mon, 13 Jul 2026 09:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783935027;
	bh=P+HnwQIMWga6Fivte5SRYooq86xfzTJgE0AFjo4ZSuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fA9fJoo7JuzO35KXbjPsYfvmtv5gRBXdH3Z9Tf3oo0BvntiWFSiZp/ea8kZgGQkGG
	 RzjSUbF3c5ISlhHXDkr/SY4Cq70jmkUITRwkm/r9C+UAtLi+0IWWKrjMHEA4WYOyfw
	 DEYLaroOLDwtqE1vzwKT1XXXVaaAIVOv17q+kawIlOd3JIAe4QZMcX39aofVTpp3nx
	 5QmuoMzBxRcSl6XhBsiFVafLxSeJUwrjQVpwEbiIvmSIdbbItCSU2vabaoj+22YTAy
	 VCqRxXU82jfjyhGn10tGHVZExZMosu5VMnjE7EZysnAKbkP7puGp6R/gN4H+lDbyI4
	 6RdxZ8yaW8YBA==
Message-ID: <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
Date: Mon, 13 Jul 2026 11:30:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F340E80003
X-Rspam-User: 
X-Stat-Signature: zrmnyosj5jfknnahi1xdnycakh646m8u
X-Rspamd-Server: rspam03
X-HE-Tag: 1783935028-952494
X-HE-Meta: U2FsdGVkX19NFuh47palR5eAYLxrcvkCOg78RjUkiTXJpWsaLDqQIRdzX6+4apsBLUo6afHgFaGYMJ/9CEAswJQrFGuVJL4KF6ZK4ph3vuQ+AVBbN8c6SXnAsid3JVMrYM03ib21QVB8MXAv5oYaMnlaEFCTseiFCf/lZlepAFAmAaNiimHQIUg10KMl9GW3PDzGrPTbiTbSlfqExSwhTac0ziRQXA5BZl0kHKX4BjiguVdkp4TwEUWIynl8BqPynxZtnXxIisBQ2thHwj8adFrY1w+4+fbzf/VTvLyV4Tn1LtvSNUsYa2lEOtV2qY7KQ3O7sWTTjQz5zrgU+2J3jyyahjwlOPm9svALb+qBhxcIIwjgKOXngJOrGYQF13OdlGO3cm4zJkT1lfdbzJBGqAn3rmJ+IFiJzXFjTSQT6DmMkpdtjFqtjCNkfNMe/UPwwnsDTxRsIyjMKejth1Qa59RCIBl8kfEaRAbNmJfge8j+Xe2NrYKvh4JbkeQ7cfJ5aysFxcoMz1KCrS92X+Zep5WnIwzIVvKWlQAavcyp6x7DcTtkMZVCc3Pfs0nmgQ/rHfSw2ppQZjWaDrgY54bxRLogZ/cwbGw7Gz2ggWUFdyiKvAdC/QcvrPIhnw0dID935Cpx87Ur0k27C7EoCqA9CPYGuVvvz9XZkXWHXMItN8nP/153WVO+sOGYdRiBE7OwmD8DeReSGqNRy0KfLRWPii5Meav2FbbOtcivpo7+C6WHjTpqbwJC4f6KG/DZaXBgBoBY3F16Ew3wqI+e4NW9hl+G4AjKfV/MY/LEfgZZzGwueYTRrnXpfv1jhKaS8U5RTrID4EAWsF51ERK7oy65COYND0dWK4dB32BeffTFP+8rA/dqs7O/LaH5er4NoYsMl0FXNTreKDoTvc1xqjY3GmFjkQx4kSwbHuDd6Fqxd39/p+HPuGFADMQ8MRQBUqSzzbrm8VA72SAICm1fylW
 X5Sw/3wS
 J0SgRPwjX93pWbk5ZQ43xb2AJA6HRBEwGxFmMOrHuPqkqdHefT6SOv8ofIhrysJFk98zw8KwJf6qjM8e/E7fcu8Dul01FM08p/rfAvS6g5ZuAd4JnYBdJ2k1IKPuKnUqjo4wEl2ungz1XkFVU0Cg6bUxTS+AypYW3s9fse969C2M7fsFOAEJdGt96TVRT4IWFNcSX/jAIVOLceI0qLwcUdYGbWJVgq0Er1MF+XtpjPYWB5/ZOYrrnv0a2iXsybk+PTjyy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 04:37, Anshuman Khandual wrote:
> 
> 
> On 11/07/26 10:28 AM, Matthew Wilcox wrote:
>> On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:
>>> @@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>>  	 * see locking requirements for print_bad_page_map().
>>>  	 */
>>>  	pgdp = pgd_offset(mm, addr);
>>> -	pgdv = pgd_val(*pgdp);
>>> +	ptval_to_str(pgd_str, pgd_val(*pgdp));
>>>  
>>>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
>>> -		pr_alert("pgd:%08llx\n", pgdv);
>>> +		pr_alert("pgd:%s\n", pgd_str);
>>
>> Why can't we do this as:
>>
>> 		pr_alert("pgd:%*phN\n", sizeof(pgdv), &pgdv);
> 
> %*phN dumps raw memory bytes and will have different formats on little
> vs big endian platforms which is not desired here. Debug print here is
> expected to report pgtable entry canonical value where various platform
> specific fields can be inspected.

If we'd want to go that route I guess we'd have to add a new specifier that will
print the pointed number in the size specified by the second argument. We could
start by supporting 8/16/32/64/128 bit only, no weird stuff in between.

-- 
Cheers,

David

