Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48932F36BA4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6AB6B008A; Fri, 10 Apr 2026 00:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A77C6B008C; Fri, 10 Apr 2026 00:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDAF6B0092; Fri, 10 Apr 2026 00:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 795CC6B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:29:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2277A5835A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:29:17 +0000 (UTC)
X-FDA: 84641366754.11.CF1FD48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F20640008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:29:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bjxI+aQ8;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775795355; a=rsa-sha256;
	cv=none;
	b=65eT5gfBWaXXQjUpWmzF7JWf73HbngugtbijBwBhQcBd05+VNgj3/pyGXEU823bpedor2P
	cl/SXmsKMNPo8DZTSIhVqlZCFemnUaiZZxUIfSsJzYCG4cE9VL1ezjWNUMFiCzI40TjbXy
	JDl/Jq65AKGcJOCuqd0P9YFUMjUY4UI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775795355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHebwTdaLWNAvs0/4wxR9L58v575xxVmSaA4yoh/ZUo=;
	b=Fib7ntwoGX9VKnheqME2eWwaAKmooSZ4vndosmHEp4B/xnXgKXOtDpEmn7j0lOZYZoRH1U
	AQJG2ekdnvQoGqKzaeJOkkEQ/UCWCY2A6Q7Ga16Z3VBpY5sow1QwePaGfKjsHKo4hlqQxH
	bz330FSZ41zzA7jKoaZS0/qmA1xl5bc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bjxI+aQ8;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B4522008;
	Thu,  9 Apr 2026 21:29:08 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37E5A3FAF5;
	Thu,  9 Apr 2026 21:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775795354; bh=BSdQ3Ls3b2H01n0rpr+1N/SbRJC1dCvd44chWo22Nbc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bjxI+aQ8zFM9SyTQFzyGuKMzJg2y75xsC8VOiuWuEm99z0f5vvZn0tIA7wR7+h4Iy
	 CzNTVCPduKNC02eWJmFtnGR1w9MZ9FUvS9hdN6XbJhkRIfwFDfcxyUx3QXbrABvHxb
	 FKKbokiyNtbnCQKEVUV+bW6T2cZvHRUFw5fAnldY=
Message-ID: <8ae905bd-fb1c-408d-bf50-77667a51e3a1@arm.com>
Date: Fri, 10 Apr 2026 09:59:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 02/16] mm: Add read-write accessors for vm_page_prot
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-3-anshuman.khandual@arm.com>
 <adeBg_eZvmz-ST67@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <adeBg_eZvmz-ST67@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F20640008
X-Stat-Signature: w8u3fjt5zaesnkoj3gk8pc9cm5gzjntk
X-HE-Tag: 1775795354-840888
X-HE-Meta: U2FsdGVkX18lZ/Vd7O9JPmh8ZjSIriL9KBW/jlop/6M9WLdISnF6uY1Yjj78E+D5L69oauaQm6+uwO44qIFTl5sCxj7SS7cYi1IxlWYVS0Y9OShd8egI5Z1HDjhlbNWjflpDUXBeB/1rgyIwd/bT8nMd0P13bqmPI1wgRmqsv3LIG9VcXOiaYaHBy0MOh4lSV/JgCRq7Bp2nlhsLRalL+T/LVY3Ga9uGNf2v5uUDkFDqzgCKAQok3jntqF1R986ahwZHu9XeDv4sdrU0oJmtqjpe0e4GlTwQWlXiLWGs5uSS13MaIxjtHxx3CwKiTnS6Df+bqYLb+PcYq63IkAA1TOm9Q+Vum1wJ8CDm/LZk4REgusVBXOGdX0aW1uo1VXIjPJrZaOlERcZLJYcNTrIyF0TBuP3msWdAWA37+SXx5UPi0sTfIXwn5RUjQtDJzUGoR2T7LPVR41BnuOSx+O8wLln8QyitjQvd87/wv0MT6GgQxLmNpCeKwhjo/8oebufhVjaDP8oERYeHdYeddph63klHeDyArOM2IXAYZOWB2yC2LfvKZRUYRgVOBNd+FPvvgUJgDH7qvppqBuuPOhmdCgNJeVxVIHFmcVb8qwKOkziQ5W19hp/IZ0rZv0Alqn9jbqX/aQSZDy958UeIr9eJZHVq6MsTo8ZkloZLy/rJjs+/lJVahVcoOf2P4EXsaNTfmeYMT3ucnQWE8Fm8dIWPn3M0GiwVdLnKkwkzEsnhKngBhLKSdxEFDVKLn2XGXgJtH2Hpz+DlqKq6PGAmLCOmmYRjNQBFgyhta62d1OH88dqQF90ZZ07vX8GLgAZAd31J2tznsP3x+BSVXEAwpnxffaEb66xumcb6ZHRB9h3XdZsZH/tGfYLAY7JHl/dhk2LvEhpsl8K9B1iO7ZJJrWMzaGdpjaAbQKkiKzNFLgwHar2QClAj+unDO0mbh5twu+DRnbKP3UCP5VVI98PW4wJ
 JwgcA+cf
 q+BncNBuS/clRNcYatwKB69zyufJrEqpn5v8c2LuzydMRdPfMf7ROdOC3VpANpdhMqfQprly3Y/f3B7vxj526+xqKmpx0n3HtixmSVQ+mfU/f4UrK3rVFrZf9rZQ4ZwU8/oqpRTKseuzFD5RoNA6Un0BPoHEbNmbGGLVb5cfzDd3AiIHBnBCyRqpSdQTIVn+mFAU+tQxAIYtWxMwq4JaN/pJSGJMJylGAC3OYuwSYC0Wv9Oll8doA18lkL8//O8o0eSWzwV/TV7mSSI0t8mVsB+rDpnkna4zizjMI5taAeicdT62m3MS3rOQa0bbB9zfn/RnBkOCrFAALmqp0KxDzknQJNvy3AdLeOMwrOf/0DG4I17mq5uZ52SGnhkzjTOED0QS33zYtDiQMxl0yFSNLw/5x3aNyzLxdFoQdtZvR4dRAUWLEwI81kulGbC21ERGiKrePDJs0NUaxh/OTacs2QEfNC/liD+vQEtFYJbEon7u2MM9Jto5BHAD3TRl4DPZvgfwO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/04/26 4:07 PM, Mike Rapoport wrote:
> Hi Anshuman,
> 
> On Tue, Feb 24, 2026 at 10:41:39AM +0530, Anshuman Khandual wrote:
>> Currently vma->vm_page_prot is safely read from and written to, without any
>> locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
>> tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
>> be handled with READ_ONCE() and WRITE_ONCE().
>>
>> Add read and write accessors for vm_page_prot like pgprot_read/write_once()
>> which any platform can override when required, although still defaulting as
>> READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  include/linux/pgtable.h | 14 ++++++++++++++
>>  mm/huge_memory.c        |  4 ++--
>>  mm/memory.c             |  2 +-
>>  mm/migrate.c            |  2 +-
>>  mm/mmap.c               |  2 +-
>>  5 files changed, 19 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index da17139a1279..8858b8b03a02 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -495,6 +495,20 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
>>  }
>>  #endif
>>  
>> +#ifndef pgprot_read_once
>> +static inline pgprot_t pgprot_read_once(pgprot_t *prot)
> 
> I don't think we need _once in the helper name. Presence of the helper
> already implies that pointer should not be just dereferenced from one side
> and that using the helper will do The Right Thing from the other side.


Makes sense - will drop __once from the helper name.


