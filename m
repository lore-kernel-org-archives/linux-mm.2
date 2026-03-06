Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A45F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9F16B0005; Fri,  6 Mar 2026 08:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77446B0089; Fri,  6 Mar 2026 08:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B838C6B008A; Fri,  6 Mar 2026 08:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6CD06B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:13:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54186B986A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:13:03 +0000 (UTC)
X-FDA: 84515678646.18.4D7C0E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8FA8E4001B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:13:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nWpDUj1P;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772802781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWR4rhexMM4dZTHGgKsgheaMANnYbsrVr9EOC5as+xY=;
	b=ZgUJkrWDGq94JYxmgNADAjbtQ/GBPNYe+R4B1e+Wumyd/ibJUyyxJKIAyEJz0ylG/lUQ+m
	cu9El4sXe0leqNaf+fdrS25csVycaRHdYliIt3wh68mEaMwXb7AEbXzVzlZTf/DUN0vkJ0
	PNpaFJ4E0WWiprRccMJTcjQ4yEYl2OE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772802781; a=rsa-sha256;
	cv=none;
	b=PWQtIfG7hzeJ0+0+Ufy/QL9Jrc9wszK9+Xe5XPRt8vdvGcdFEb9gqa5+CUXWJ/sJQGldJm
	G5LIUgNYAe5b8rofLS+pqCKcV6pa6BgJ2afrjWxxjCtvQjWiImPusP/ksy7nBEXTK6Agvi
	pnNstheo83SiOsN1IAoyOa1ZEWhs1c4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nWpDUj1P;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E8E496012A;
	Fri,  6 Mar 2026 13:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEDFC4CEF7;
	Fri,  6 Mar 2026 13:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772802780;
	bh=izAH7dOf8eqdf91LErrTFaY5YvIH5GE/JtUI+1Y7mtA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nWpDUj1PH6Agz8kEDINJ/DTPJoUdefAnjHjlMfer1lZXMWDScb8iVkE9sC/l83qoR
	 blwBJ/DMmmvEkHljMsbppZB9hnCdVdNm86pHe/hzz8Y/IiHed6dKlqWLJ3ggGz2K7f
	 m6uYXBclsRpE2FgeB9AasWCp5WRKoQjVDhLo8y9oHsO+fI08bBLMpCbw0bEbk0KW61
	 DvmdltJJHBSSmGuzS9QLD2zMYhkLC6kS5ZXtj0Dy/8W8O1RvO9STgGlTDxT1ka2oWy
	 qy0DO4zM+bTNZzwL4zxZOJMiFqoERgA8VtbUho+fzCXlrS4+RsWEARvuPaM92yFS0x
	 WQ81jcztD1kcg==
Message-ID: <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
Date: Fri, 6 Mar 2026 14:12:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
 <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ww8fa9bzooqwe7s3r3ykr5s4fjrf8trn
X-Rspamd-Queue-Id: 8FA8E4001B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772802781-669749
X-HE-Meta: U2FsdGVkX19A6ZHId7P03vcavh6Ll5cefORHdDQIsp/AJ94PTF5Pu933TqB/FKpUIobblD7YQalIZQY0JcHFPKB1+j7f/Z5nv1pFFjKuRzZt1cnR9utNoT8MDDbLhD7Gq83xdGWVo1PgIb8cIfuzEfsQR4rcOFWngUqePADJc1p158FN97T8hyC/Rmd7VZE5IBmVYxi1PLgA5eHJUYPsdXZCmVyFumgnFBbz2JAqQIJ4f2bQF//stSXn7PTrzTMR6xxDiiMiaaYxpmz9oOqKJ8wF+CPGt8Ftcr/JXfEPF3bJe/B7Xn5bSEtL7l7tH6Rt3GNbKXwDpb2GBimVj3QxKLWjAwcrvSJjwg8cObn9PaNVT9jPjyigzPFmOaSNP9LCbOvZ5f7pjeLE9HdG4tCSd6ef3xFYk+5no47UN7UyW/zg0uH+uoLF2/l+CtyLXXMPC8Di6hCi2bwvfjmqvOwBMx05M6pi46hpMgHsnDBJq+3F4q8y6/ha25v/MDlL4wEEcEjFjyrvA9F5QXbw1uAAAuet+XkdZ5zggdb7yMnE5liuO/YKzgLUC05uD4QGKhUi2GzNX/JrahFf4va6gDuha+dU5vNyowN4/fDgQflOysecPm6cl3q6BjquGOHXEon0A4kzbEHHIo0Nw2GUD1GNnYoJJdpWr6is5laLFepvowNaYvAtB9wjHoP4TduMxVJBCXwJro6PCHyHvIZPOLZJusNZsn2V+xTuu9K7mH1d/YyU6A1Rz8pWGwhQteQ93i2kJpBNFCClbEXy7VDnzHsDP1lRmqU55Cnf/dK4hvsF+l15Oxp37nbYaipvAJNAuOOcuTdaRN8mbH2l+rxbVcCTO8heSgjemP7PjhQFNzY+5gT3jNX2pHSO0d/N8b/fkrfQIOSwq2UnbCHcgQXceRC57vzw+pfgaBlQfwHI8roVecL4gmge5Y7h4rhiBiymBR7FgqX0PxfYask6Bnhy1v/
 BsvL0vxE
 xVvPw9zEnd4u+ueoi81mAniXu4GeG43StGe8VKd3Xn0XOI/sxaBgKz3yBioOYZEKtJzNJiUomw3da9xN/+B5RNYCZEZV0PC5t3SxZd2bkzsr3KQvpxO0BL4mtmc730JCJhGh2MipR7jyZT7KW12vLc3SIiFO6+gqqpliiEffZ2C9QqdaESCX/80inzsWTfKx8JGL7U4xjV7h1A1Qtd3mUDjjBLwlUxu31kVbemKf7R12gcIlQh1HtjEXiOQ7pJHGIOZIhhLLCtggJcXgsHlyGg81zJUoEpi0b0jQONi8nqTvGQ+K2Pb7Gy3p/A5iM9P0+DWkvG66QNcRnkGxxxjRwBxkZcdjKrTFAn0rhWsRw2TFCwE3l1fxDgjyvxNzyhh8CvjiIcdhwI+x5NoQ0bexuk9H9v1xRSD97mWuBeF0YgS3sAbVVuaHQZNVQZgXqBipb5uTJqYZbnMk407eOcpMIXXH/sNuBKksNFmOFUrIvuvdCTghoH33jilYdU8KBoF7VDMS9yoxLmtlgIKsjz4xZuTdoIeOACte1ONANL3GrxUKFFltIsgMOQ1KsaAzJ/YolZLF73j1powwLyMbZH4PQksbO2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 12:19, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 06, 2026 at 11:13:41AM +0000, Pedro Falcato wrote:
>> On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
>>> Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
>>> scenario where DAX would not do the right thing when the kernel is
>>> not compiled with hugetlb support.
>>>
>>> Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
>>> PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
>>> code.
>>>
>>> Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
>>> I don't think this is stable material, but am not 100% sure.
>>>
>>> Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
>>> inclusion from KVM code.
>>>
>>> Cross-compiled heavily.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
>>> Cc: Nicholas Piggin <npiggin@gmail.com>
>>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>>> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
>>> Cc: Muchun Song <muchun.song@linux.dev>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Vlastimil Babka <vbabka@kernel.org>
>>> Cc: Mike Rapoport <rppt@kernel.org>
>>> Cc: Suren Baghdasaryan <surenb@google.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Jann Horn <jannh@google.com>
>>> Cc: Pedro Falcato <pfalcato@suse.de>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>
>> Although we all love less mail, FYI it seems like this didn't work properly
>> for the patches (no CC's on there).
>>
>> Did you try git-email --cc-cover?
> 
> Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
> :P

"--cc-cover" is apparently not the git default on my new machine.

"See, I CCed you, I totally did not try to sneak something in. Oh, I
messed up my tooling, stupid me ...". :)

-- 
Cheers,

David

