Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58508E748EE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 21:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC3C6B0005; Tue, 23 Dec 2025 16:37:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F5D6B0089; Tue, 23 Dec 2025 16:37:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C046B008A; Tue, 23 Dec 2025 16:37:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 824166B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:37:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AA221386A3
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:37:53 +0000 (UTC)
X-FDA: 84252048426.12.13CFA13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C3C3120014
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 21:37:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LR748CgI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766525871; a=rsa-sha256;
	cv=none;
	b=5xjEMplM6s7Rgv+b+yLLjkxebsj9eZ/asMupcVWlpdHIijIdRKJkJk+ENCbpAjKj2xhnsF
	jQ9Yga/SmUthIcM/LKvuHQUh6cUammXXUurRD2ENGdhzJ/RHUhq9F3qJ0gfIM03H+9EoFG
	RV0IhstxxZ9SL7wSBE+7EDDR5LuvxsE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LR748CgI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766525871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyXDQud2+QRFzgc1/tApOzJW0S9TlYzCMkFHqZsKgrw=;
	b=4tsFBFH2xuycgciJ3++nqGaEzvnxA4Kmjt/cQrmmOkh+PLLqu4gbF1DYUiHzdGTVrfoqS2
	p+c7lqVdvlAMlcsJ73QM5CpOs4m5oD4iDIVS2axGhM2osKXxkcBLgzhgyuUwfwOetoYC+B
	+3FedzEe1CaIwWZHLzXkWJO/O+QAxW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1E7F60142;
	Tue, 23 Dec 2025 21:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78289C113D0;
	Tue, 23 Dec 2025 21:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766525870;
	bh=q6AI67NwJvG0d5MePX9VplhpPUwUqzhtBZgditDmiMI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LR748CgIoq5JJA9NDUF8u+wYPMpWF8Xelj4aJGLy/CdNNl0F01oIzd2UG1llNB46/
	 kORk78WwJaiX40Snzt4msG2bqX4uEOACjsFuoSCDrVKiKnQSARWJ7iLhXc7utOp3ao
	 jExEP8YChhF8bFnki75VkNu1r4Lj061SWPGnj7yoJeki1oXGRhXyo0bFp1rRl7r96e
	 5lB3anxVm8rDiUe8Rg/AqhHYYMp8mOtikOeyLRapzzhXR3tqOeYJR+AY3whfcgEdi8
	 Ha3nm4ceD/vi8fd3y7ntxStCt+tb/3lZg1D+eDFyOHiiRvdGQQjqMNzwyTfWQDFd2i
	 RaYg5F2sNd4Ww==
Message-ID: <4e680315-5530-4900-a59e-d61cd8209c6a@kernel.org>
Date: Tue, 23 Dec 2025 22:37:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm/hugetlb: fixes for PMD table sharing (incl.
 using mmu_gather)
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>,
 Nadav Amit <nadav.amit@gmail.com>
References: <20251223205046.565162-1-david@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251223205046.565162-1-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C3C3120014
X-Stat-Signature: zodruxy5c1au1nd5fanefwhw4y1651be
X-Rspam-User: 
X-HE-Tag: 1766525871-752826
X-HE-Meta: U2FsdGVkX1/G4G+O1/HsxM4I1cjnY5EFYwNCJtX3IL6TFMTsStRvA/C/f+LHTK2H4z4ZjpuBVAle+xhxLCLRsgTpA4CWLBttpCj/niEbxSSY4UEThu8mzZVggwwMNYtPjfTmjYgM3V0rUVpEmWCv6iELyEgyZNe8UoDLYHq6yS5KVTunvIzPhliIWQD+qa+B4ZrK84Jn/TeB4fKrYb97x1WWOflO7xO8WxXseDPr5rQZIQKxJrKeY159nEipBCVJMjv3NLj6hAHsT95jtov3vqTd156BiiBVMy0YNQG++q2sOrbPMOyxMpmtCHL2tk5C5mKK/b34Qvnm0usTmHNYi6rw6LBkkgSgUQIr5jp2J88pJ/Em3NEEkLe/MkEBUBBdnBKI2p2hPylPmycNZJm2gIuAr6As/k2y9mD8EXCupWfRgmGMi9/GrwLzjhHWsiBN2VMj1GsIb7cjiv5Kmi7873xynQyhn+s1JM6oARWll1U3ZDhtBI1HBZr2Qr2EQ9eCotC0nRIUeeM43EO9As9VnunFmV4l8OG+aqGRfN4zdEUas+wp/2zvHxWsTQ8Hwbcu6Y4rjOJSj2yUWkBwgWUyejpweMbucJzkT5k+GaCRvRfknLVQFLUvKLedKyAOHWNRi2EIu8hWNnGb60Ug7URO6HsgyJI1QyDInAGm3EC1M9gQnKQ+9v0Rv+jR7iy/OIcFKb7UZAT/l1M1+CmIHWXfHQCq6EdHUp852c7KnUjDDZWFJWw56p0k0PAR2B97SMrvGmokpLCLJNfQaYOG0yrLeACWKONsds7Dhb1fD4S+XuSpy5zy/DQ5X72i6Gcbb1mRcU8K82b//AuiPoKpO6s9zBRf+pMMhkdilISEcPISGmOVJ+Om1SOK2WX3azSLnhUluou0Ezq1p/JXKKJZULuV4hBKWbBxGeRrsTVoTYs7TBnzf/94DTDaLpkjLfLZrj8AzcDCNt9mX2PDwuWPinL
 cat5rHiO
 0OuQAxj9CZJhrjqDVbcwHtX2Z0kqbPwDx2yO70f7XmzYb4lxBD3Facs93ITyNV+43pefZSoeJhpPz6WNG8Drzsabx/Ufht1psODbR+ZzV7Uv/wlTx+qOXasrHlVhXyrOpUelLYZRuTiFLtO7lAWt9l0Hld6KX3vA89gqsHvZmZYwCVVc3moDJewP3RHZQfu0QZbI1O5IHMApD8E1TcFJsPv8QMKyFIhuafYfJtjk0pMg59ynlzcs6yGfU/PggQR8DXPBITw7SZruxgoatB45kDlFHwUS2qlxmc2JLVeJZbBh64x31RiXUY/7T4UIQv9ALkaxwQAvIAfotZO4LYIy0mBlQI7JhJ4KCl8uAltn18e6/hDmCWaM0WN/f7Mz6fpsPkGkH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 21:50, David Hildenbrand (Red Hat) wrote:
> One functional fix, one performance regression fix, and two related
> comment fixes.

Ignore this one, I forgot to include the first patch. Will resend in a sec.

-- 
Cheers

David

