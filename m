Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75180CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5276B0088; Thu, 25 Jun 2026 01:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F4C6B008A; Thu, 25 Jun 2026 01:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2633C6B0092; Thu, 25 Jun 2026 01:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9FEB6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:06:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5BC44C2646
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:06:12 +0000 (UTC)
X-FDA: 84917248584.27.99A200B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 892661C000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:06:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UiR8YwXC;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782363970;
	b=2T5otpW+flgcZErCf2b4Wmb9dYEckwPq4mk3MrMgdHfAStouTndxGEz6K2aNiFa8DEHZwg
	kDcQQRkgVzpbYFq4V7MP8wyXVHTxPzPjbXVESlZeph49iKyeS7zHiTb76Z1tvhB2SXcCnh
	iIA36gFFT/wojyFP3nZvpE4siF8WHYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782363970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WA8fiNtW4EDsKl9qcqsY9YG2Ghxj0TJ8jhn+9R2j2w=;
	b=BnV6SMzOVJoCtEeI+7PFtZOJ7NbjOXQI7A+dAC6ltbMKFK7ILOvf7N/1EdXopPqvfEKkDM
	PErWy6ogYMy8oompGGxsC1e1R0dpoKnwcJ3rooSMMU5A+eXp1pdLt1bQVadvcrx65hFMFo
	Yq2omboK0xNwHQrZJARTzgPEV9uJVgk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UiR8YwXC;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0E762BCE;
	Wed, 24 Jun 2026 22:06:04 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 994CC3F905;
	Wed, 24 Jun 2026 22:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782363969; bh=Lay1HVOEFuLeVqkTA0aGqyvQ+T34DBOYVeHMQyWlWxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UiR8YwXC0OcWwu5H/2F2xG3WeZQPa7DTkaff1XDArWPQ5iDEW4vKBeqhsms5v91dY
	 nqB/Pji3MJWFNE6eJIjpqk1zLtQ/xjJKzh1aVx9RrmCi8V/V0xd7EUS57VvjCat5l4
	 CF/2pyXu3QWf/JrjUquDEykrcJRasB6AnnkTJwH4=
Message-ID: <c17ea0ca-1e6c-4504-87f5-219f13c846f5@arm.com>
Date: Thu, 25 Jun 2026 10:36:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
 <20260624214230.4aff522ec8fa4a8f1607c942@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260624214230.4aff522ec8fa4a8f1607c942@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 892661C000D
X-Stat-Signature: 1erff84dwkarjn7g6iubgwp6kkecm9ei
X-HE-Tag: 1782363970-57019
X-HE-Meta: U2FsdGVkX1/R2dsGL7PjtE8lh4HMM9e6Uq50UFE3qYj5mVBoxoniWx1bdVEV7rzwHyPyayEEWvNNP7i1CGhbT7C7YU+tFqF1SHG8/iziitJ7TBlhEjlAQKin/8kkSe7RqlBREHXfrYjOXE3eFtENzHEpY/tMlMbkolsCW0faLfX7hGLjeKcroKKqtY3StGgo0CcgmRGWDSj6Xmp3K/Puc2IqskeCaWp3ElGuQvDaFlXKpQYxtL3Z6fCDt85ZS+c4GdHE5kYQgKQS8tCe4fP8fZrjr4QebXCHf7nauD1BqdXN0v0qhJck8lwlm/jmQDd9LRSGF0DpDDrePVkw7CwmHKfeoLop67z2Rk484G6my1+GrLPDCjiCC6Y4amL8ZSqy4hEcteqqfaGEcLDykq0Q/EmaudDNShL6SLH+71Mrol6ScvDRxbWWPxv0ko60mMzzTo8SN1c+qmEx1DVArjIzCPARf5Tnea8mFMp5xZ7VnbfXzMc7OD1U7xptstMnt6VN5EevSPWDMc1QRD8kjE38gUUPZ4HXtpmU5qU0WhF8b0rQJvwZyYwlvFUgZTW4FPBtgVNBfXQ6jMNm6RmzGEPvlRuD9uaIR7GEcxj+ixTZhRwIU23qTrwVS+PhJKCX+Wbs6qBlehtJhMizd4ih6CmDI6dTmRDFccpetzNFb+hCoUr+u1pQcNjPqSAWpOBRYm5l8ORgasgFvDWwk3jTbfuPHG/yjkAstsFmzvxh1j5zUnTIY+IXYbzXkLR2qFQO+9wbSNGta7jBVOTXAo7gZNxTcuZEgsKbTEEP1J+GQilczI/9+N0NbdY4pYkj/tIMoTequYcyQTV1dNyh1qHkGdE3sENA7gNM3gyamoOXQtqVsA+csf2tmKTlsBJBIFrlSmfh8tn36Hj8wGsP8mZQ0tc40/VZu+YHbCyn7klczgW1+kt15RpSbkSW+SlZsieXL4OTgr4ZxLJbHzNaS7TIzDC
 TyZ5TClW
 Ij6At9wt/Qe1GJGK/ISGnHP6v+uU20KCk35Kv5f8VTnQzXcdo1rf/s+/KyM5aIOc0TS2h1VckTJxdXWHq/FwkS8erVF9L2pGv6zASfpxP/9R4TO1VhdAfvdZctaNu3SySm5TN0iYXp4iDB+WIEySIQUhkgdf1KE976v/F+jSYRrJW0fSP4Ku2zOWGdj0TYhxqY+eVHZDfVu1r8MK8MDf6vfMdFy69bJKB8t4TRWsTLT98vmUryZhKg/ZIGx7SaVNFl1KUUQWu6aYWUpNsxOlV7Subld4ywYKG1cBbNmeMFs5hcfMQJR8bExtmGW+s+MHnVU86bNusplTUa3S+NDQg8G5L6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/06/26 10:12 am, Andrew Morton wrote:
> On Thu, 25 Jun 2026 04:28:51 +0000 Dev Jain <dev.jain@arm.com> wrote:
> 
>> try_to_unmap_one() handles hugetlb folios when memory failure needs
>> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
>> case page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but
>> the code reads it with ptep_get() before decoding the PFN.
>>
>> That is wrong on architectures where hugetlb entries are not encoded as
>> regular PTEs. On s390, for example, a raw huge RSTE must be converted
>> by huge_ptep_get() before helpers such as pte_pfn() can inspect it. A
>> raw decode can select the wrong subpage, so try_to_unmap_one() can
>> install a hwpoison entry for the wrong PFN.
>>
>> The userspace-visible result is that a later access to the poisoned
>> hugetlb subpage can miss the expected SIGBUS. With DEBUG_VM, the wrong
>> subpage can also trip the PageHWPoison check.
>>
>> Use huge_ptep_get() for hugetlb mappings before decoding the PFN.
>>
>> Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
>> we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
>> bail out on mismatch. This would mean that the hwpoisoned entry will not
>> get installed.
>>
>> I am not sure what is the procedure on such kinds of very old bugs - how
>> back should I really go?
> 
> I think 9 years is enough ;)
> 
>> There are similar old bugs present, in try_to_migrate_one(), check_pte(),
>> remove_migration_pte(), prot_none_hugetlb_entry().
> 
> Why now?  Was there some more recent (s390?) change which exposed this?

I was refactoring the hugetlb bits in try_to_unmap_one, so the bug got
caught in review by David (which reminds me to put a "Reported-by" tag
on this patch).

I guess if someone would run hugetlb-read-hwpoison.c on s390, this would
be caught. Turns out, this selftest is in a category of "destructive tests"
in run_vmtests.sh, so ./run_vmtests.sh or even ./run_vmtests.sh -a won't
run this. We are supposed to run this with ./run_vmtests.sh -d, and that
option was broken until one month ago, see 3432cbb291aa. So essentially
no one has been running that test.
> 


