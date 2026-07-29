Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4812C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63176B0088; Wed, 29 Jul 2026 02:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12C06B008A; Wed, 29 Jul 2026 02:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01C46B0099; Wed, 29 Jul 2026 02:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5A96B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:49:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BB50A1A61
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:49:54 +0000 (UTC)
X-FDA: 85040889108.03.EBF2D7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 552C0160003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:49:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTMcg6S2;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785307792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYGlCN19ALETyMe32ZAVF+Jp3rkvcN1+KQ/ovIRty4U=;
	b=uLkVtjn8lO9ResS7v8Wp8Y1izGTdlaKlYb/nBR2+NxVt5D+drHzchPfiSuyJK6343EEOCF
	NQ5hu6946dSd0wIlWnXiP1SMZe8/+qrPduguPhPRYVUetvi62jXBRRqPG8bU8CpasdLdzD
	itlTR7wYSvYdWG0fb15M5GSJJYtQfoM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTMcg6S2;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785307792;
	b=r6I6zG+2v76HRjrnxaYBWzoBh05YTfkWpS1rlFELU7V38g/36P+rBAq6xDPxv3BylfDbOK
	eBQKk9eCDBUNFgn5L9dJE72BD48uqj6fb3JthVYKyWaLISTBXuF7ai8nCMswlBa4m0LUHL
	felbC1HAySigtR+MT1islbcM7pfYuHo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E793660A5E;
	Wed, 29 Jul 2026 06:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7522F1F00A3A;
	Wed, 29 Jul 2026 06:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785307791;
	bh=mYGlCN19ALETyMe32ZAVF+Jp3rkvcN1+KQ/ovIRty4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fTMcg6S2k+xFY0IPGdBpRUUWy6lGlnsxTSCt5Hhs3YrSswNuLC/wC6qkDO8tc8TVu
	 jkQDzHKSstUrx+3lTq008Drqv9Lr+Bm91W/ypYbMtvKty4BDDadHGsDK3qC13yuORr
	 fCsBXi13WuAhR1I8agdqt/+WU5A4dD3sleTt5579WWtLrRXau8Bec0KwrHs9fcq19E
	 57Ahl6xG6GCLropAk9E/SuChuCNHdTN0d2reUJ/V0RXHh3VNzCwT2sLkWQblGU7jd2
	 jkc1DcU06yY6jAahs/k5Q9rIt58sFNbuIWiWOny5Ntf/iG0l9A07ah7myfDuSwvsux
	 oyNDBcv8o1USQ==
Message-ID: <8b1cefc4-93b5-4138-9ab5-2dd1cdc7ec78@kernel.org>
Date: Wed, 29 Jul 2026 08:49:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: gup: cleanup gup_fast call chain
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260219050250.061598056@ruivo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260219050250.061598056@ruivo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 552C0160003
X-Stat-Signature: m8z9x6y9afbwg7fjc9pto8m96t5amf9h
X-HE-Tag: 1785307792-31135
X-HE-Meta: U2FsdGVkX1/VgCIfeSAys4ViY965cyGnrU7EF/zpsBZqDqBs+wB1AIgX0EG5W1u+gMCsDE2opwJHXdXXNyc77TY3AEmxTULkaL9Yq5RbGpWk2CxCAd27A1AR9cSV7xVBHKLXIxFBn4EoYxBf0vfMDygFh5UyGaAYKxflypN6rab+034I1KbbIV32zK3OVTxiIQ8PT5p4pxQHT5VSqS9LZkT8DbjuwOBNulQwfD+cztUBvoNGQqHJSqrglLJmMtQxXlfToDjHu68E1tPtttDPP/THu5FRtMVLQ0QZKK5fkW51tNftl7Yg6uNp2MyYWBTyWkfU9ioQi17pe0gE1E+2X9nsOXSQQ2TZgUayEmE6siqnDh0anQeARxHfaqOOrbZEk8jKqN/KlE6xJ1TgmqAG7KAYVSs9x523UV+stjfVaYpg5tfwo84oYRIf1r+yMwAUtjR4jI23RinYccFspl7OYxBZnff72TGfJt+je655C/n0HHubk7fd7xMt2nb+bhqHCRlQKmerN1EvG88l5am1znMmFTBi2daNU1Q5iwGX7MgpNMc0NVl/h7Qq7Vf5nxTOuvmVNE4/YyK4nIFs9yW33qcLffJOQbIiS4I9GKqHipyzZJGg981iUxCCr18jP13kLlDA4OLq3m4dJf0Mf90JlKJQV9EnLM9m5jqNs09zI7BHh8V9RV1LOAD2aRhqXmr47SKq0RmFTuyUxVOS4ZA7RtgbVHh9cRvdHEu3qRG2tUOz222GiOXK0rLF8Ikccg0zSb6DsZ7J7exwBTMqSDgR9zrt9lt8Z7sRUQteeU9YNSriCzX6LR/ZhiWx7/5ZK7g+cvIEjkkp21zGYinrj93ojskUHsOV+JjZRlPROR9ca1U0RdEIiyzXiJ1A0wtDs+mMRaTABfBwCYjYHGJDQKsWnQYoVJW5ZRVi3GAvtES9C28jdDv+VourAZR5dJEfv38t0Hn9LUoVIuNg/A4gKQC
 sQsJ2kqL
 mQD066UOiEcF2iHufKagA12BjjS9Peyk97TfiSc8CSMV14VTEBZfuiwq8UAcmw5eP2Pj89EG2MszYbFm4vhZQbxDBmnwVqtyv1p3tclU6fOuEdSyrmCM9y3askl8cdn25fDohxRWxufz3uGQX+Esy/hnZZV8AGZfQBKgcxlxKkljm4dgRVwgmodNIcyejQpf99B3hnma+d3c2fFTAz+oOCZe08rgIimcU2jtf32S2YzlVB7qXEFD62Ezw9UxWEKXQdPw04voTtbmtDNbDl6KOfUSbWI9YqvmwThxDdSHt4/BBXsU174L21oTGpw5Dt9+QbY43femb8q5tv+ldLoUy9miS/Q0/PK2MmzturhGJlJg7fUDh/EhsUGGgWNB8SwtMjJtX6Ghvhec7waYrWMJdVrNkc0QfVOS5/pOy+JnxcEyllMA0t4M4NT7c5JjeLgw0RLREc0mg5A0qCikQoo8KMMIsoRHwNF0tcAhxGVk0DxeaeWg/tKD+oP/jo/3I6xXiOZZZbkhQO2tqtno5bO91p6PkaQJpMXnAgSowverPtdnUL70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 06:02, Aristeu Rozanski wrote:
> These two patches implement the refactor in gup_fast call chain David
> Hildenbrand mentioned in
> 
> 	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
> 

Aristeu, I think there were only minor things on the second patch. Can you fix
these up and respin?

We might only queue this after the next merge window, but I don't expect a lot
of conflicts.

-- 
Cheers,

David

