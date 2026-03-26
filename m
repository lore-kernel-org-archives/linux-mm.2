Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B81E10A3D8E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1CE6B00B3; Thu, 26 Mar 2026 08:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799CE6B00B4; Thu, 26 Mar 2026 08:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF096B00B5; Thu, 26 Mar 2026 08:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 570936B00B3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:40:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11E8C8D083
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:40:27 +0000 (UTC)
X-FDA: 84588172494.30.8B4AD2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BC051A0012
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:40:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pd0+PArU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCc63mxQmI0Rm16EARrIjVdycmC3M2EQFudF/sxVLVA=;
	b=Xa5Vb8vYAnMDKXV2tdQ5HR9wJMJMwXKsRbCg8YOTQp8tlG585kSlsR3vZlhRnI0aEjrPua
	FvdeXwpI72UyHriS356H8omJOsre9T68IBddKiQZmKJdKRrEW7aM8uxj74TH1R4QXm2ZvH
	nBUxlhRHwfJPHkDbGQqKRuNc+Um+DUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528825; a=rsa-sha256;
	cv=none;
	b=WzoEFguJcSJHrmszJoRarrkIhMKlvWJ/KB51+Bx81+jVFVCA1i542GStYq8hemFu7JKAbt
	M+JGmro1cusOGk2dfcZje4ovAyhK+1FXZQnHK8LE6PaObp7+Dk3zCoPZxLchM2sarHu/6k
	BXc/CQasW1HQYEHR2Nfac3gA6tgNbkM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pd0+PArU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16B29408F2;
	Thu, 26 Mar 2026 12:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5C4C116C6;
	Thu, 26 Mar 2026 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774528824;
	bh=IsCOArS6TBUM08mP9FQmgrtzYi+rluUj35r3K32pZ50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pd0+PArUz1bZF6C/Begb7vz4NRe3Kx3dnzydkC9yW/fNgJJn1GP3um0k+MW5s459N
	 /tH8D7VD/KfauwfqyJdUMUWMB68fOuSt7riPjg23hM1GyokMSuMlsFL1YktbmOR3sD
	 CACyqePGJ8a4SeOM3gEuFlDYCqCjCOL2j14cjaQf2MBra/YTx/Qe3v2SI2AxxkUcHv
	 uqB5tSvsne1tbgRBwQvllNxb8z3FDHYxjbkrtag76hyIXRPSFSoNFJ7ZTHXTrpgYOA
	 eLwDwXpFvG/f6mhMSTZBS+uti5b6xcRlWaFjUw9xsnIgUlxEgJ6qTjMnw2EBu7PhPW
	 Dlwv8rbRIAswA==
Message-ID: <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
Date: Thu, 26 Mar 2026 13:40:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Josh Law <objecting@objecting.org>, Josh Law <hlcj1234567@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Christian Brauner <brauner@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1BC051A0012
X-Stat-Signature: txyffjq7r41s6gyu4zaagbn4rrxxe5xq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774528824-980351
X-HE-Meta: U2FsdGVkX1/xlrCQw1G0okAiZQYF367U785Az7QGMnqh3OESFBD6GeoxfkY9QXRbRRl2OaOCXVyH/1RAx9OkBISiWQMA8sDM5UrUzdv8WMRICmB8qvX/6+IWC1C1u9aKxl1a0B2oZa40fNWRgQxNE9/8gX9G61kzFhF40LcAdZ72MSz5MYoLqvCGt6c5mw/6deLR8yN3rbbT/b/gmiaZLObVcMR7D624Zvfs8M9I0VJpAZHaJvZKuUbO3SAxYPFy6HetIILSnRjBXWa0mO43bJSS2+LguSF12pUssiYUQ37+WdJNjUQ8Sr34lSMPnPXYq3008Mun+E/X68Q4tKU0kV/7PZkFLFHA8oNH81/PVD1Chyz26A0Og63Skbsz2SF7Omy/5yKgEwe3ahoMVV4KjUGHhzHYwSKXz/xyR2ZkI0CFJvWcpivJsCls3qOZyI6SlWT82sk7ua/NfNi1Y3hNOt/ZtowggLN3TNQhCwcZaXPIaeU2B9GUIoFUedQ7/OgK5CUdQH3lvYrTIZKhDjXD33SAcLy8o5cxVXKYiKhpYfCepgLBnfZq0o9M7MWzonFMsn2jV4PoyTN1ygfbYspRE8ZUqaimkbuKpZdzIhsCzOLZpAVNs5kdv1EDt4JjG1SWIFcK94cC+bUwes0G+IhOqD66Gfr+ioUs84otk5ze2eqTZOrX/fgSXpCyqxpBeu+NOfWFnZEtdOPzpkReA8Lvmluk3aNqK9ehmMYSvJmW8wqiJ5k1vLEptEBjgLJXVkC71hafWSGFZpOseqVlYIZyHCzkTORTGfd7SQJ4Jlhg+2lnasqI6MwHhUW5fbHPEnhIA8pq9Al8Nlu75jTcgGzBIDgf+7OvMclncs8uGZNfCWkBk3L4LN/hxLlM42pZv6+/XAm1LXB/xCMpHMIWtw/3abD06DogTsGai1LQnNzNsFnthdtXjXb3uSMyOM9IiwfSuyM76llOUrSBfCugkbR
 4aNqLLB0
 qUoXd1TqQ5Fvt0nAbQZ4VuB8JUn+lMrpdy9IZksHqD4ypJFv156TGxRuoBcdyBZUYo7yylUOANsCC2diLVCJhC2OuHWpu0fBhybVGZSj1mx4GhaualMhEDf8b9qzMC0tL7K8dWrmhuD6McKsvrb6bbi69ST7hyPTi7smU3wtX97UDvZPh+C7J6E4VJRWbM1SDCoVUyB7l/sxDNwA+/rbyIn7oqTujE1BCzp9+gsxJI8e+icAj4/TkaumVNQlJa5ivtDPASQGNPtzXzpxtTq0KpH7zre32gZciRtZ28NCcOg/ocR78Zk7mG5rhlu0gwvdi1nqy42+X82CjN3A8STp3agb58zapoiKVikQRt2zXrpmyxxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/03/2026 13:29, Lorenzo Stoakes (Oracle) wrote:
>>
>> Answering to reviewers with whatever confirmation they look for is also
>> a warning sign of non-trustworthy behavior. Or rather behavior trying to
>> get trust.
>>
>> [1]
>> https://lore.kernel.org/all/D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org/
>>
>> [2]
>> https://lore.kernel.org/all/2F84DD09-2880-45E0-AA98-204F10848F85@objecting.org/
>>
>> Best regards,
>> Krzysztof
> 
> Yeah this is really adding up to somebody abusing the kernel process. I think
> 'Josh Law' or any other pseudonym that can be traced back to whoever's behind
> this should be banned from the mailing list altogether.
> 
> Also, as per Christian ([3]), it seems this guy was using the pseudonym
> "techyguyperplexable".

Yes, repos on that Github carry commits like:

commit c04af501bacbef54cf97cdfb904ddf295f8327c1
Author:     techyguyperplexable <objecting@objecting.org>
AuthorDate: Sun Jan 11 04:21:53 2026 +0530
Commit:     techyguyperplexable <objecting@objecting.org>
CommitDate: Sun Jan 11 04:21:53 2026 +0530

    ANDROID: sched/rt: reduce lock hold time in update_curr_rt

    Move resched_curr and do_start_rt_bandwidth outside the spinlock
    critical section to reduce lock contention

    Change-Id: I8dfb4e33460ae4eeb0bb854cc2cb084ab5edf7e4
    Signed-off-by: techyguyperplexable <objecting@objecting.org>

> 
> There's a github with the same name ([4]), and that same user made a comment on an
> openclaw issue relating to linking it to gemini ([5]).
> 
> So it seems likely he/she is likely using openclaw to fully automate this 'Josh
> Law' user and we're speaking to a bot here.
> 
> (Screenshots have been taken for the (possibly inevitable) deleting that will
> happen later.)
> 
> [3]:https://lore.kernel.org/all/20260313-halskette-annahme-94e782eb4ae4@brauner/
> [4]:https://github.com/techyguyperplexable
> [5]:https://github.com/openclaw/openclaw/issues/44134#issuecomment-4106247302



Best regards,
Krzysztof

