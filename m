Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664AB606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2Tslwjr
Received: by kanga.kvack.org (Postfix)
	id 1C40E6B05D8; Wed, 28 Oct 2026 06:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174A76B05D9; Wed, 28 Oct 2026 06:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03C406B05DA; Wed, 28 Oct 2026 06:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2756B05D8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:02:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 652CB80BE5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:02:27 +0000 (UTC)
X-FDA: 85371595134.15.4793FCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C99240004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:02:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G2Tslwjr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3n953/bJQ0btHDOtJumY5KvKx/uqtjyCpTyQ6fObN6w=;
	b=Cj5DQKMWfF7XLvVyhWUlZXconAnLIOyQ52ecFWXy0QVRSS5G4OXe7VFY7+zxZJXAUZpbfL
	DVLJOzkpGQ2BsyG91QEY3yGBkkVJXBP1JnSNOm9+E75a0Q36Q2lGb+HOxZllZE/bBTHvur
	Y4v50DepOYImFoVaZijahlwezi2Lyxg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G2Tslwjr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181745;
	b=0dp5CEM0ayzOhHh2uGjZrL8vXGNfZ0FpoKaBx3ixL/6gfbtZL2Lf5rflIUdxl0edZ3mw4L
	QMY9kRAAsyOiUSPaAog0iS7iuQ2mh2aixBNQVFryqsUyApn//F2xJXzVcvuz99ajpx+4SD
	oZu0RmG/mvAwUVhXb2JE5mXKiqmpSO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C554C43C8A;
	Wed, 28 Oct 2026 10:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35F41F01828;
	Wed, 28 Oct 2026 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181744;
	bh=3n953/bJQ0btHDOtJumY5KvKx/uqtjyCpTyQ6fObN6w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G2Tslwjroiey1nXwhnz/Bg/e189Wku2yPdsY3XhKVv5NbMWwZhpYcK1j/YvlCIhNw
	 6li/12Jj/YclcnvqAbLihLUYVJldYiJ5N20/WXIbocbtr8NrYyzXP627oCUbDyt3Id
	 q3+5sEaKE3PdwOX/e9BQ9kjJr/IB75kCTy6ql7LacdoEFf2puIIVDbdRpDm8tJUY70
	 wzSqI2ZCq0rvyqIzpxo+D4gZauu1UWI5Z+cRscTufPxIGFTv0eN0kcTVQ0h22ZA2Pt
	 GShIgPxlq33tac2KoGfYAazGLaSiDHGBUFsq13dTBKBmMQ/FGrO2fhq3uY2LHq41Ox
	 nhUMk1fPA/Hgw==
Message-ID: <5dac5fd3-c2a6-4e1a-98fa-0fe1936b269d@kernel.org>
Date: Wed, 28 Oct 2026 11:02:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Magnus Lindholm <linmag7@gmail.com>
References: <cover.1792609488.git.kaloz@kernel.org>
 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
 <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
 <20261027212610.6798-1-kaloz@kernel.org>
 <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
 <20261028091631.8072-1-kaloz@kernel.org>
 <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
 <8d4993cb2f2e5c3300514f1e2616e4a101488883.camel@physik.fu-berlin.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8d4993cb2f2e5c3300514f1e2616e4a101488883.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9C99240004
X-Stat-Signature: pdh16ettru4q5g4fmxdzdh8f5nk5gwa4
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181745-592997
X-HE-Meta: U2FsdGVkX18W9Ucf+eEE41allbY2+QFxamSbzdNMV6a8ofXb3wNkplUsQZt2qKwXa8g8EQqteWW3Ia5nBX4rUtc29a+4Zz1VwWkLwqKpBb4NEQf0gTeQEimbNxJuECG5nJLvdIyAmyAKfTnh3WcKiQukNyTq85CaA6SU5VS7IsZqIDL4ZrWDVfs108DkPIfnvbse6VPqVBhSysKV2MJHbrL58JAXLUBpV8HnGbtelKJrW98yr/ZvQSbPf2d2SfGCnsuufKW3tEvtW8BzHaXolTsYXonnVGP0jjXFYx83rAmHlRCyljAycBQAq96m9LdCM/H9SQD6eJlOEAb9t99+eoJ2pIl5/L2L3tp+FS+1jzbRw9lqtiJNHtTuKF2nNu2YFhFtPpIgaFyjExcv5sVL9DfoA11faqZaEhTzCjJXl+4wdyw9DDXdDYAVWwa6kRtu/HGKY+000OvSlGpjWwMwsB+4ujadKG87IBqVSigSxupWKUjssXWST7STpuwFg0LpRJmPf9iYYYTYrm5tCHwZ0g4l4szgtEHCSn54jh4q1yWRWb1gSxMLXLEzf9Ty/NFnlT8pOgnfnwwL31wNfnqoTVRJU9pCpeTUYRJ6RBhtBp4HloCxb+Q5K+bjLWw43rPRTkz+ouunSWGH0R549Nq87ybZ8K9+9S/DEhumtqlOGIIdNkrfcH+K5q0uKo3TR2UH8yuUIEuaZB5f4mN+5z3vCSIQWPiauc706hA+2rrgSCq8lpkQ522rPy91l6sp/QCTfVqGOorGWLO9DhWNfT2WuU10BkoxasugNgemU5pFnUd0/ZihNRgZfNMnxs66vAJo0n605ql2vlA20JV1O8JLJ1xD9jo1/ZHKtQLYCzlw/8ec5OxhTSmWx4tthGs6GBd/m5Dme4NAsjv0NPhMBMjcxsXA+eMLYBWtKUAi2EtXCT3/plXdm3DD9yuwgmIaOx0r7xTxmUDO+PDzMtbaCvT
 CQ2el9RH
 uJ5zLrfTaN1joLBH7YMGLvjYdiRWSZsC9RNM+SvjyxL7vTdCl2KHLmhhG5xDShOdXkQmEhMzIBW71iH7qmT98WjaLiCEOMyfXbah74WFHNJC8HCLHwSjQvSnhw6GlVp2BvaaTEWkLdWy+F3I2HRvveLiZVTPGvPfIKr1ePz3IIpmApXSQDqG1ExZRrGWrW0pyoLSWYDQ9jUAwiRyYqvH7rBeH1rqsPkjIKn+cvitASXbjU/LRqXEmP7alrXBX5PGV/CdNfd5jLyApSu5ItIcG/4kGUzxx6YgrzutzRMWEIzOgdrf19ZXcRvOfMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 10:58, John Paul Adrian Glaubitz wrote:
> Hi David,
> 
> On Wed, 2026-10-28 at 10:22 +0100, David Hildenbrand (Arm) wrote:
>> On 10/28/26 10:16, Imre Kaloz wrote:
>>> Hi David,
>>>
>>>
>>> I'm one of the museum folks myself, though more the kind who loves
>>> running a modern kernel on old hardware than the kind who complains
>>> about it :) A lot of these machines are still doing real work, and
>>> these days not everyone can, or wants to, just buy a new computer.
>>>
>>> Some of us spend our time keeping these platforms working, and I'm
>>> not asking anyone else to carry that, which is why I tried to keep
>>> all of it in sparc.
>>
>> Okay, so mremap() and reclaim memory performance concerns make you sleep bad at
>> night? :)
>>
>> Don't get me wrong, I know that running new kernels on old HW is fun.
>>
>> Last week a got upstream Linux running on a 32bit x86 notebook from 2007 with
>> the snap of a finger. Everything just works (using Alpine).
> 
> That's cool!
> 
>> I couldn't care less about performance. Nobody should.
> 
> Well, try to put it into some perspective: For some people, old hardware
> is all what they have and given the current high prices, I assume many
> people will be stuck with old hardware for a while now. Think of developing
> countries as well.

sparc64 machines?! cmon

> 
>> The biggest problem all of us with supporting old hardware is the maintanance
>> cost. Not just core-mm, but also things like ad-hoc page table walkers you are
>> adding we (from core-mm) might have to touch at some point.
> 
> Well, but if people are using it in the end, I think it's justified to support it.

No. Run stable kernels.

> 
>> If there is no good reason for the complexity, out it goes.
> 
> The patch doesn't really look that complex though. It adds an additional parameter
> to move_pte() which adds a few more lines of code. Not really overly complex, I think.

Follow the discussion.

> 
>> Because otherwise people will push more and more for removing legacy support
>> completely, and that's not what you want, right?
> 
> I don't think it's fair to make the kernel exclusive to very recent hardware only.

"Very recent" find the mistake.

(sorry, I'm unusually grumpy today)

-- 
Cheers,

David

