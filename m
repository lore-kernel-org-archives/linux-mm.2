Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C104DD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5D26B00AC; Sun, 21 Dec 2025 04:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2709B6B00AD; Sun, 21 Dec 2025 04:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA336B00AE; Sun, 21 Dec 2025 04:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A42A6B00AC
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:26:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA78A8B7E4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:26:53 +0000 (UTC)
X-FDA: 84242948706.20.1278AE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 049D520002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:26:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nb+bP8zK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766309212; a=rsa-sha256;
	cv=none;
	b=J5bHbkLhC8aPZ8zEoK4aWd7VTYyecS6pkMF6J2H9dWnI8jD9QS7KU9MEqhVOB/jOuK7pTO
	rGxPT7+m/LML7Dbmko6M2Pfq3ZTsyDY1YXvjziqdiyvfmCZgfWiTurSqSk6qSCjggWJWbm
	taQ4udd2DNVZDNPvi4BPiT7iO2GrtJ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nb+bP8zK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766309212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DToSSkcTtui14uU0FGAHMQ5atcuUt3CMQP6j7IV4mOM=;
	b=195lWQu40F2fdraHE32a/5Dlx7NGZe2b/Fqy1CP4Saot00Jo2f5uofCP04ILI3F8RZYu9G
	FFruzRgeumXf+9qrOjzR/Npb2hKsr2ovupD6fZiMRz1r50I/Jk9OTDZFXyG8lzr8mkNowt
	CS6S3rk7t1u1o9uMPSSsrKwY92D+Lpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F375A42D77;
	Sun, 21 Dec 2025 09:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2618C4CEFB;
	Sun, 21 Dec 2025 09:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766309210;
	bh=r/HnyZxm1R6JN5eoXSIU5zr+Fo96rUTb1s7oPXl32Hg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nb+bP8zKsVe13MWjC6VhGiVGWuX60q75WG3ymxPHxQaQNoEZt9X07AZMW8bQYGoBo
	 832booaCYWwk80iWMWOGT8IZWy7QQo9K0ejIQ0DGqlYu2UNbDi1hcLCNklnidfZoYy
	 zj7y96b5+kig2ITg8FMHuXwFAxDC9QfAy3QjqOIuFQKFEugl4FMh0SkMzlCRvkFbPU
	 YsjizVCeShvDzjdpMJXhtIViD6WdPOL2tnDOyOa0fXAO3qKPo8QmR5wRj1CLn7ExRd
	 lgx7qQezmlLjeaZopnMLDrw2AGK8qUb2AHKBbIMGKzpcKWSZeZ5kcwekoiRAnADcZ4
	 eaJJnZ546eleA==
Message-ID: <b4898184-ee7b-4e37-860e-5790339059a3@kernel.org>
Date: Sun, 21 Dec 2025 10:26:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/hugetlb: fix two comments related to
 huge_pmd_unshare()
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 linux-arch@vger.kernel.org, "open list:MEMORY MANAGEMENT"
 <linux-mm@kvack.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Liu Shixin <liushixin2@huawei.com>
References: <20251212071019.471146-1-david@kernel.org>
 <20251212071019.471146-3-david@kernel.org> <aUTYE9fHf5Fq3eHa@hyeyoo>
 <506fef86-5c3b-490e-94f9-2eb6c9c47834@kernel.org> <aUU1DY4206FibsLf@hyeyoo>
 <2bbe1e49-95ba-42ea-b6af-5eeb61d68c4c@kernel.org>
 <3D7F0E85-2509-4925-BDD5-149E9E8D5C1F@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <3D7F0E85-2509-4925-BDD5-149E9E8D5C1F@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 049D520002
X-Stat-Signature: eq3nxk5xicnebejqkk6mypoxzueactor
X-Rspam-User: 
X-HE-Tag: 1766309211-450853
X-HE-Meta: U2FsdGVkX18+i+NI5Rh+pajN9pWxLAxLz8UeBZh8F0IBw5v8umP6lyIVb5iiF9Uc/DIIHIgybiD2AvKjuPpeBt2LgU/iffdgv6M38KhovpCHVwFFY+XUkr0q0V/DjemSRZqJU80km0y59U9WN3C5CfNpsVAUPf0eGK1d4rJ65xFHuVO3mXjCLJjzZ+pRLNFuaNRNszqL9+PS1ztJYyjhXUtSGsZUXB7LAWgiL1Z1wBMlJYdir1DtIr611fQQoVNzHuF4GmVcpa3sIEcy0aJdIedvx7ADXQwwmNDztKdkoFlzxBmsyaixO0BFGRj8lSVUGho6mBSJYnC17QfYaA4WyK9JeNuEHEzLxBLwSmfgrzDe0R1hZFgGLQc1vkvuh51RDaJYgOSwZVP+TYWSTrl/2r/RGc8fi+hbFkjV6JQ6ePBvHkuCRRJQ9OI228CJwAT2hmrSvExWy3heWLKzA25NSC0xKZa/qxH5jXHXWteIjoMxnXOt6D2vtllmNODsGJc4PYP2XQ1fqQnO3YLRDrT7ewLwZhQVXfeatcdJQWpU8+sp3EgITdpGxev/LqXmtaeeBbUBvZODVflFPZxhnPkwbFqk+msuHcPLEZYA9WNF/C3559fY7kU/DsXdGATTOaDjjf0c85oPV7xPw1wJ4FpG+1viDpNqf+1FRbxitsJbgR2UWUDG6ApFpHciAEQ0G4X0W98h/tHDO19DEHUpknECbk2H6JmlrLXWHwGuYcxHK6NZWZ8MnWF2agVc4BxnmsJkvalttKV2OI12RenTiTc1DMMs+u1J5vb7PLGoe0/M4SRYVUxIbEER1X3lCabZA1l/A+351uuDD/MkzHYA2AetV4K4peSTYZ3JVeXBlR6E7+L4vQq6FbyXNt095iX5s0OYfxLP1MQMQXG0VZvG35k3G+WG4sw9+a3Is3v5HZ0igF0o+8oqorxnc94i4lQwiW5lly9BEjL7uX4az83fhQc
 8Tvz13dG
 vIp90Z9uufqryPtZZIR3jsxQQ1wNiBw66uT+1pVuMILlXH1I/g9RzpHjYuJLcLnbVHoNzErUtBo9WAWPDvcQq/wiyNhmNEqE+UUh9SzF3ABFK+lnNLTwiVb92Y/B8eJPRrhk+juDEHsOujOP+FfhR3jF/WqCV2ltxWhFj1wQ6TB81UTHduwQ920J7BoIX/sdmqy/JvfeyTKKPQ8VrrGPVO2F7+Jiz4plh0gv0X1CQRlqAT/uMrUucgsalBbop7jGPjwOAZyO8pEm5o6Y6/2L0I0R0gIuh1we9FqJzmdS/Togh7hsbZsYW0UBq1+Ad1UQ7HXtnnZBUr8crhZr1vDf+QJh5/iWC2QhZuVdRiEO+ixw1+LK2Oi9DQF/KN6mbFaf1eUjk1X+Y8I1zqRwfYngFTWYrfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>>
>>>> Whoever is the last owner of a (previously) shared page table must unmap any
>>>> contained pages (adjust mapcount/ref, sync a/d bit, ...).
>>> Right.
>>>> So it's not just a matter of deferring the freeing, because these page tables
>>>> will still contain content.
>>> I was (and maybe still) bit confused while reading the old comment as
>>> it implied (or maybe I just misread) that by deferring freeing of page tables
>>> we don't have to flush TLB in __unmap_hugepage_range() and can flush later
>>> instead.
>>
>> Yeah, I am also confused by the old comment. I think the idea there was to drop the reference only later and thereby deferred-free the page.
> 
> My bad. I looked again, and the comment indeed doesn’t make much sense. Thanks for fixing it.

No worries, thanks for taking a look!

-- 
Cheers

David

