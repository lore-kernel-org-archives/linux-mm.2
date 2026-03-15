Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AB5F30282
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 19:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8376B00B0; Sun, 15 Mar 2026 15:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C656B00B1; Sun, 15 Mar 2026 15:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538686B00B2; Sun, 15 Mar 2026 15:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B796B00B0
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:55:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17189BCE94
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:55:18 +0000 (UTC)
X-FDA: 84549351516.15.4BBC776
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6BC1440007
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:55:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ezw5Oler;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773604516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3ujUetGhW5k81rDMpgD7T50V0XJaSxwNc4txTpAoWw=;
	b=17WGeZPOgjLHW/QcCRSOGfhwf60PDfsFKWYq5RHEFnpdK217jwv+HOCkZjlR5VqbQReTDK
	Ps9gdZXufRKhLZwQnQe36MLA7PY7J92SIsCjxU8LaYIBP5lSjgnByXM/NL2XRwavSwj5Dd
	TURIO/X+p7EduT8hhah8xdsc473gaYg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ezw5Oler;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773604516; a=rsa-sha256;
	cv=none;
	b=slydJvl3wDelIENnQGN0FC+p/UGdYvPy+ljdVU48gmTvrXZmBqMTeNPligG5cRYOYVivks
	oieqp7y7fcRt8SNZ8Qfwh/TG1el3iaatm4ypDUESY5MIFc994EqCBb50Nlk1ogqAV3h54P
	0fbEwk0+f2OUv/qzXGgMIA5XnhxHYwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A69A260008;
	Sun, 15 Mar 2026 19:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BC4C4CEF7;
	Sun, 15 Mar 2026 19:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773604515;
	bh=R5ThDXaXwhDS7us7pszLF0qdYL83ZR2z6K9kBlc0xLo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Ezw5OlerE1XXx4LiBfznbun+8ECgquEmXFy3oPq5MRyV/rS1cgP4GvWp567QHecWh
	 xTUc5d1gqM1fj/blqAN+NSTFp7/uYsCEKy879a5oik9R0e6IGu7akMx7iDCekvs++0
	 54rzsfOtsYFZSHtvvhjrdCoXclRsGoXlVDSnrWorBqO74BFXdD3Zlh8K/NazCUpxvu
	 qNck6hpPLjRojREfJdpwdACax2MDMyXOtKyVyGj4Eak947vV9XPkOGn1Thh6yRSxhZ
	 GB+AUkaGEebAWz/TJqS7nCy0segLMN+M+GX9U49whEMubxCtSaELFExj4R3w837roj
	 jHIqkZemS44Sg==
Message-ID: <f6c2ec4f-95d6-43e2-8b82-698b9ad4d8bc@kernel.org>
Date: Sun, 15 Mar 2026 20:55:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
From: "David Hildenbrand (arm)" <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Kit Dallege <xaum.io@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>
References: <20260314152538.100593-1-xaum.io@gmail.com>
 <87ms0ajtvy.fsf@trenco.lwn.net>
 <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
 <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
 <09920346-0caf-466f-9c12-5f086d99411b@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <09920346-0caf-466f-9c12-5f086d99411b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6BC1440007
X-Stat-Signature: otbwarft9uapwqdcc8z45xqw9mecqfrx
X-Rspam-User: 
X-HE-Tag: 1773604516-115605
X-HE-Meta: U2FsdGVkX19cU7PoDovUtWAzoTpLVlzcdA+SHd8GFvNte0V+BG3Eiq61E1KqqObsyxlRgfedvMsSb9Dwbf7bn4MELuw/lJ1OGySyikmDzt6YNt9C5ioV4oLlKKGm4c6RgTO7FdIIwVgLm0yUPvbqsFF0E36o5muuPXcwkjPVIicTvAEErSJ0zitNSyc5ggGrGvfH/e5G7Xb6NpwSnEbyFtpqQA6Ay3GnZcqoE+rVuDuqe/NMwdOQy46FXnKDahjTAPHWBIk7uyFL1q2ETwbfU9UL3FWX/iVGvX5M/p3Krqui3MGWbu63/8kg+RJUYFBMah5PsaubFNhhcUZmH8TeQ95ZsT2AoR5rIgHvt7SSMNEdlnpHrKQqM0fVjtu36RIabyTBCz6NM0U7Bo1xROSaEB0MrAcqiD8W09zvg62PfoDV0kaIRpRZwXVoJqLL5gibHRjAF0a9+b3LBNCtSCkSvmeMTZqcNHZXU9pZJnRBsSX9aYWhHRAegp4gux4SfY7VO0ILAzxwLHoB0OMwMnm12qrdQW398tM7dmIrZ9i3rEVb/QMFRk/Sq7yyz6HAxO1+nYfTjAJpaIItqq7zjl173OCgz3OdCSwhUry8mwwzE2wFYnb66LZJePaPZZtxv5wx+U702a55EruB3CXJUKQtGe9UwtFSPkwTmwJzSTpliI4llfkGX0RlfUfLe3ujqYz6ke9rdvR2DHfzShax9XG6e2pZjuxvM2BVfnktDq1xZhuD1sHzpHzL+S3VMFyU/5g9SgDWc6wVCTMsaCXCdgldkQbxBbGjduxXmKeOZiij0ObJasAVzGsB/86fIeQ7Uyjzq1pLkD85iYUxs+mzhBO5o+RMC2eYHl2Jc0Mf9S7i255yWSmYNRufMa+hWpT9bye8rvlu4WTSCCahM/+QIB55VpizabnwxMfGcUjKmPgUStTGZBYGiykpGZzuDs/2xIYDTMk2FZTyG/zuany/Nri
 42801PM/
 3XB94p7UlW/+2m+5F4bN2UKlOZzTxnUDu7dgPhX1RsCY4prIwU4JyGSc0hK8igkcPlngQ3EZAZZAfEhtFYGtkKBAm2SlqqAoB8QnmLdGpcnT9IuFPYVe42nMTrFATqbnpWrEvHIqjnTqiWIYCJDOXeLD6pqF7SwP4Z3GZ9YJp1b9iUPdWAdx4M7rnpQZ0aUtnTMLriAptU4+yS5gkv3LehuibDWoIh/Oq9BEBwUYecV36ysIGwoU13cHAnxhgbHoP6p/3xTogynp7c/We16Sg7D1l1t1UYftxsZUuhcRUjLJVeKC2XH8Ve8PXZK8MpFDi9MIvElflCRw7+0xZovCTp850JzQ9ipQHfeoI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 20:50, David Hildenbrand (arm) wrote:
> On 3/14/26 19:17, Andrew Morton wrote:
>> On Sat, 14 Mar 2026 17:02:47 +0100 Kit Dallege <xaum.io@gmail.com> wrote:
>>
>>> Hi Jon,
>>>
>>> The material was written with AI assistance (Claude) and then verified
>>> against the source code in mm/shmem.c. I read through the implementation,
>>> the existing comments, and Mel Gorman's book outline to identify what
>>> should be covered, then used AI to help draft the prose, which I reviewed
>>> and edited.
>>
>> OK, so you're saying that you created the content and used an LLM to
>> assist in finishing it off?
>>
>>> I'm happy to rework anything that's inaccurate or doesn't meet the bar.
>>> Should I add an Assisted-by tag to the commit?
>>
>> Yes, Assisted-by: is appropriate and useful here.
>>
>>   From a quick scan, this material appears to be helpful and I think it
>> would be good for us to get this into the tree in some fashion.  Which
>> will involve asking the relevant MM developers to review each change.
> 
> So, someone with an LLM but no proven experience with the code produced
> some doc, and maintainers/developers should dedicate their precious time
> to do the hard work of checking everything?
> 
> I'm all for documenting stuff, especially if newcomers start exploring
> that space by contributing small, carefully crafted documentation updates.
> 
> It's then a good learning experience for someone that wants to work on
> the code to really have to understand the code in detail, and what is
> actually worth documenting (and what's an implementation detail).
> 
> I see 7 doc updates for 7 different MM subsystems in my inbox, including

... "the buddy, and for example, no mentioning of the pcp, but for some 
reason page isolation instead."


-- 
Cheers,

David

