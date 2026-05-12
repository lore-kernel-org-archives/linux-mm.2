Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0992CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FAD6B0099; Tue, 12 May 2026 03:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7726B009B; Tue, 12 May 2026 03:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD566B009D; Tue, 12 May 2026 03:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1146B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:48:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D65911603CA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:48:58 +0000 (UTC)
X-FDA: 84757991556.09.9048555
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0DE9C4000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:48:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCa1nNIK;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVl3bUdeJ15anFyx5QHjuqbnYaSNeBHCDnvW1zOH62Y=;
	b=D7oGla2FubPbU6u9owPr0w3BkSeiUDdAZkAD/ALfIaSDozLIw640o3U/og0iATwwhkSTtA
	DKTyJvwL1KXGkmWtLVh+mmL1N+OJUkooQ9fTrX9Vmy0ZHYSYCd3I2X+7ywb5TB1TG8FoZP
	E2Iptf2hwdhsEi6OH0MVxTLGvg+Qchs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uCa1nNIK;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572137; a=rsa-sha256;
	cv=none;
	b=7aGB2O4pCMr2kBxrGrfaMgYaUt3XHC3SRikHHNdOlWgjt/YKBV7+DOJNonjnmFW35N/1BE
	xstV9gKiK9ycLO/AsGBAHMhfpsBbqAQe+rlOHjAXZDwh8RPCZL7QT32ievsDFfnyKj0oOz
	upFZ3J9UuqttMtQ5TSI7YOEEY7dwi60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E3DF4413C;
	Tue, 12 May 2026 07:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A162EC2BCB0;
	Tue, 12 May 2026 07:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778572136;
	bh=W1sWVav77uChxJzFCxQ1pVlTmhfGKv0xL+Q/RQCskXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uCa1nNIKd5PutJrooTknPXUs80TLQpe5mDuqGyg3XdKeFcMgbrXW4uhM0VlL8QJAS
	 tQkUOtlMj9URZs76ee1yVbbtMvlzQY/vQl4CvVAEqVWWEOBDxx1clD350rQubg+2Ur
	 bViQdkGWZkA+laQ9XhWC5TXa81qIP9c404lIrdeEKWrXAez/FqMegKBkgXZHVqUk+U
	 XOWjtI2YE5PNbOeJb/1H+HvjlvpCrQa/1ySqbQrMKQMu4fY6jDFEk9ygBnlEMUbuPa
	 rr/nC0VGKvcPvc6GUqQaHH8BlFsA9sqw1CPDYVOT88H9nLO9WdrbESu/nYgX1gy7kh
	 NH0TPCI2BTCug==
Message-ID: <0edd94cf-0895-4f49-8afe-44651681965e@kernel.org>
Date: Tue, 12 May 2026 09:48:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)
To: Michal Hocko <mhocko@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <agLawTyWlnuC9Rz1@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agLawTyWlnuC9Rz1@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0DE9C4000A
X-Rspam-User: 
X-Stat-Signature: chjt44561rrgitij8m8ooh3m81h8iuub
X-HE-Tag: 1778572136-374655
X-HE-Meta: U2FsdGVkX181hI0LID8l9B854+/0IRBed637sZ97wl7hykych29NNOskIRDW+3JHWB42DD68gYdxhQkcOGYYZ6WeJjGwqBxIsAMVxvg+erCL/4KqCzH5JfpS/jNTxXDr5fhnY6NVFnndQLP0Ykx5yMk88++CKvJlFi3F5doedGLQTi0P28K1t0WgOuPGgouvYbzL9Oilkqey8UAcsWoFh9a4MrkEb7Y4bqu0a00aeNo4Key876RyHurPp/R1FjJRhPSIdZT+Zzp9LeLHMq1MnCuoM1i+ESNXr+hQ9JQ5INVjW4Hw8n1O1z22ZgaJWGllgtx6rMt8GOU76TscGvqIsh1LlEjUgMvhOUrSTT+YRq8LHr7CtfOJ2Ew/5KvG6kPAnEUScbkUDA74H2k0wqY5xf0epb2fqCNxORnbbw43HcFxzihUIQ9nBnAbAiwjwfKzhqBRrn6tpa5YtHNqAZ1f3yGyv531lazK/dQwnAeph8qxIGtKz+kcSN0+Bmpp4dPOBaRCimujMLUxIeErqE1EjFA4dFtO2fHrToqS1MrxFyxWqwwUrUtzwQE6QpkmdpJdsMq5vb5FXgOPJKouRLey1ZtZOOtMJnjCawR9UmHUy0SPPRygAXRBNwS/iFmE4WL4ghS86KZ+rhd469X/pZkHjlTQsbrAiLkPYbjzapJahHa02/CjyQEe/HlD0o5qNSw3tGCcmkrCS/w/U924B5HCIBqhZ9hispC7ENhB5xQALJqoLWjja84N5jtSIy7otMo+FXoxpjpfai9C48F3/nyHfe7ehJb2azvxx55YKNKUBrsAYquPwxKrWlojxq43BiKqrPa7tSW2Wd0S07qzywNhQoU+Qbkn3oti2DbidF0nyZdIQ1NXx/hRkTGe3n2M0oGiSgVsY+Zp/Q6AD2a3uz3PVCC+bjIFbviMI3RvSKcmXl7r3zE35r5B9100c7WKRyjS0MOgBxk9mYMOb1hrjiJ
 HrzB0UYa
 ma1Lua5DQbtxF3cpkWByhhbWha847Lk9v8XH4mDopjuZw4Fh6+CD4oDMryHVcqZ27V1La9AdNbM2JrkRHDEsc/KvPiHVXs/OEt4l2tHzuFCGhCyXHDkzpQWHRgHv0Q8n6fumlPacY39eErDt5v6PDsFl5S6xebBfkn4iBHMy+nQNSODXXzwTY/HJYtcVqG3/3RWsi4Wef4hsAKKKhwemwRCfbvVc3xh2T8Wg3/J6u47GJg3BbFlolVPkAIThFX7fB3LlDBM9iuWCS8BvfnyMmN5Q4+44sTk6O7GKFk8Uw93EK90sxhHOJM2wsH0Ba/uTEcrxHW2QnGNf9T92+OcZp/voqmOUAahvO5H3vpmxbhkU6dYhU3SP6PNfQzrz2/jFWpXyPVxJRIvM3GHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 09:46, Michal Hocko wrote:
> On Mon 11-05-26 16:05:28, David Hildenbrand wrote:
>> We want to remove CONFIG_HAVE_BOOTMEM_INFO_NODE. As a first step,
>> let's limit the remaining harm to x86 and core code, removing
>> sparc, ppc and s390 leftovers, starting the stepwise removal by removing
>> and simplifying some code.
>>
>> Once a related x86 vmemmap fix [1] is in, we can merge part 2 that will
>> remove CONFIG_HAVE_BOOTMEM_INFO_NODE entirely.
>>
>> Tested on x86-64 with hugetlb vmemmap optimization in combination with
>> KMEMLEAK, making sure that the problem reported in dd0ff4d12dd2 ("bootmem:
>> remove the vmemmap pages from kmemleak in put_page_bootmem") does not
>> reappear -- hoping I managed to trigger the original problem.
>>
>> Heavily cross-compiled, but let's let build bots run on it for a bit.
>>
>> [1] https://lore.kernel.org/r/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org 
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> David Hildenbrand (Arm) (8):
>>       sparc/mm: remove register_page_bootmem_info()
>>       mm/bootmem_info: drop initialization of page->lru
>>       mm/bootmem_info: stop using PG_private
>>       mm/bootmem_info: remove call to kmemleak_free_part_phys()
>>       mm/bootmem_info: stop marking the pgdat as NODE_INFO
>>       mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
>>       s390/mm: use free_reserved_page() in vmem_free_pages()
>>       powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
>>
>>  arch/powerpc/mm/init_64.c    |  8 --------
>>  arch/s390/mm/vmem.c          |  3 +--
>>  arch/sparc/mm/init_64.c      | 20 --------------------
>>  include/linux/bootmem_info.h |  1 -
>>  mm/Kconfig                   |  2 +-
>>  mm/bootmem_info.c            | 25 ++-----------------------
>>  6 files changed, 4 insertions(+), 55 deletions(-)
> 
> Good clean up. Feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> to all patches but kmemleak one which I do not feel qualified to judge.

It's black magic to me as well. I tried to test that scenario in particular and
was not able to trigger the problem.

-- 
Cheers,

David

