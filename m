Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A3CCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CC76B0005; Thu, 25 Jun 2026 04:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65136B008A; Thu, 25 Jun 2026 04:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5046B0092; Thu, 25 Jun 2026 04:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83F946B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:03:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16E171205BE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:03:23 +0000 (UTC)
X-FDA: 84917695086.01.37F9715
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 031094000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:03:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=M4jQmsnu;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782374601;
	b=SFK6SeGVHHP1Jpo1ixh7EhaPi6tn3mVNaZyurA3vHglv1AKHC5gmLiX+6u67h0t4hfh75b
	jZSBRh0wqVvl/Br3XGcT6CoDythF1tJ7rXl6kZVIzWITcFttiQQ+yyqf21mDHdlj+ABMv5
	6/y/P1q/hbN4j0xWVarDECMe79ayLKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782374601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5ehHNRQWt8k8oodTzPUy9F0uqknQosXwAUR++V4lbY=;
	b=6YQKcqyZk7lERghyVqd6ZEuT5ihFyzbjvkDNBBLNMXYkiZrrpFPncrdJycHjQ8Cm2U/pDA
	q6GOh35rptzB8Rc8xlPOXkbulyu4Byi35MdHac0K7OhWw56fpSrnfvOy9eTXwrYd4d1jpA
	1Iku4CWbzNqXHbaY7FWN/I4YuSMx4eE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=M4jQmsnu;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5337515A1;
	Thu, 25 Jun 2026 01:03:15 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A8423F915;
	Thu, 25 Jun 2026 01:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782374599; bh=aAbiQ0kC3g2kpXXxbZWIR5lShtLiakkafy46q5goelw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M4jQmsnuPIRvYaZFh5IORzmFo567AEHUtqQ3dVOoZpvslmKRwfGE2vVVY7nZyEWkJ
	 BzDMxDgufZjCVSb5BsWx9fB2sEsY19ztI4drtxdP4wJgDH6YyciK2n8+0F7ylTUOs5
	 RUIfPbyR6Do+Xh4Sg/kga5ozK9Cla8cfO/myz+Zo=
Message-ID: <614e89a8-5108-4ac1-bdf8-fecca48bd91b@arm.com>
Date: Thu, 25 Jun 2026 13:33:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260625042853.2752898-1-dev.jain@arm.com>
 <ca31c254-504f-4857-bec7-10b8c2de94ed@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ca31c254-504f-4857-bec7-10b8c2de94ed@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gd44xg3pa9h1o98fn4ud14jzyurrjpyx
X-Rspamd-Queue-Id: 031094000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1782374600-544251
X-HE-Meta: U2FsdGVkX19K9K2NmroxGGy0CFZnGMk0YbM8f/iHIcbfRo5d6f5Ey3zPaRtJ23qOjHdAgJd8ZnLpgUQjUl1i3Kv4/yaC3FgZOB+gUSewlFaSWJm1XTkSYedXrroFYWCYB0KjjuTVpFb1qSGQz/qlaJgfy4Ldatiexu+GSqCbK6odb67ON6QsSJWCfiYfGenoSy6T9buA+eAXQD5m6BnUfHeGUEo+RRfxtMAUX+JJEKflOW92y2C1PcWJGdv0Lrefa846NFhz6SYIeOeIQnMJQEvFYSz0IyXMGMDA43xZPa1Y2zE2PbsSclxAxICwOIJ4581NIWXiqlFzD3Io7h9rGHpihN1tYC5Rrei3FS9t5gVrm7flXHQ+s415CG803Qur8JDIGjYIJpCS/KeEffk/OJk95fQMXQC2JgpjkDrWX1iJUH8meMsvtKVmB76HtPEIklqGS6lv5tJLbD3YW71F2ZgueiHXqLudtpR6xcY1NialKkZjbGdnOAEFAQf9d5md+uQUr09ET6B6Agy84ZWobIbHT169tL1X+w0/j1VuHzZUycZakU17naF4WtMvj9zt3dsalcJBtuHvHXJ+FscWCp48SMPHESLa7sOegEPbyQrXRBMf9C5AAiOVkFhEiTrhE9z9M6K6AL33yOEpEKFWeffAoA5SS3Tdp85aGMsxrIlUK6DppVyKgfQ+RkOxe5JN/ko6CyNwZUe3mrpuc16nfXA3GvZG4FyRaZmPlZ6UgCxWoJI3UW68Du1csO2sSlWJFfrP5IryT/XeiuOpaZQIKemU4tgeQtPMhyxfryAEfCJMjdCq6YtFaNf+WB8dH6aHbZNHDCqlc/zSa3IAFJTU51ahsgqGxizhh0i/M/3kZU1RVBbQn/y6Brhs4vIgUBmsOMukCZl5VFI6Pq5SQ301TEuZvlx5o5zhuEvnkt/lonMbxt9f6tikOYzPx+Qr9tVNlGscMurdClQS1ib5i+z
 GZpnB9Xz
 cp8SPbqbb1frjP/+YMP37Ppwvw5+e3IrROiaKSp0/PPUtXok11E3ohFG5mNLyanx4cVUUFn/81oKZcr+FHDtYqmkXN6IeLxlYDjWvYaQ54J9c5Wo3HRexfH+vr+vJPsFIl19G53N2mLegaF85P2qQtR4Wuk/ydRHVM3rNGgFOXj+DnJ5axXxaxcFfq8fkBwUPq9HSEHo/Scvcku3Aa95PKkr/CHmfVm0AAMICFAPIad9ojy6HrGJVYgwezi0F4tqqPmXrhr38wF8dPbQHOwFf/E69RIllMjjNHxSVMv60uSseAAphQtJH9kWP48IwIcAfAryFhbpLss8/gnYTO/BwEx/oDElt9VTkbA3Q0cZxyjBGdEA8OuGHMbk9sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/06/26 1:26 pm, David Hildenbrand (Arm) wrote:
> On 6/25/26 06:28, Dev Jain wrote:
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
>>
>> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>> Applies on mm-unstable (d17fe8a046a2).
>> There are similar old bugs present, in try_to_migrate_one(), check_pte(),
>> remove_migration_pte(), prot_none_hugetlb_entry().
> 
> Yeah, we should handle all these cases properly. Can you send fixes?
> 
> Using ptep_get() on something that's not a PTE entry is shaky on some architectures.

I can send the fixes blaming the commit till which backport is relatively simple. The bug will
still remain before that, where we don't even do ptep_get(), just a plain dereference, if
that is fine. Probably no one is running pre-2017 kernels.

> 


