Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7447A606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=C3aFddts
Received: by kanga.kvack.org (Postfix)
	id 91BD66B05B7; Mon, 16 Nov 2026 01:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4EF6B05B8; Mon, 16 Nov 2026 01:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793C26B05C5; Mon, 16 Nov 2026 01:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52A6D6B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:56:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B92CCC07FF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:56:56 +0000 (UTC)
X-FDA: 85440074832.06.BEAFF65
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EF6440009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:56:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C3aFddts;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794812215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Av8Qql1PFCbNo0ym4O0ZY8gbj5FgwCTE5iiuHlTnyDA=;
	b=l430qAlmktwkqHRfG1C5xQ0TGbXvkXMmN7qw8O7DiCrKlvNPDNHeBdIhrbQlscJhqM+0K9
	Fv03WpeEuK7iuKdqFhcZe/y1PtZt7/1IA9ECPcP54Cxbz+ctbhRSNg4PhHCo1dBZKnw2Is
	4hYn/fqK9Ng4aas3xvt0LS9Eem1gVXk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=C3aFddts;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794812215;
	b=AVAtF3+e5w8GF+ZnQQhk3wAYy2nQNhHKRaF0IhA5aKecWiveGhmyulAo6z/vNUqtcnChLW
	sjfaGDr2HAjDl6Qy3gSlyPrnqVuq1lIUeeG4LbN7+dU1pmkq53aogrYFW1RnW6Dv6tOuDl
	zk4wAeXqyIlTeWRwtSMneRptb3vrxEI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DB12143D;
	Sun, 15 Nov 2026 22:56:50 -0800 (PST)
Received: from [10.163.155.94] (unknown [10.163.155.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C5003F632;
	Sun, 15 Nov 2026 22:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794812213; bh=iJSVzWp3/nSBdi9cZI1iskHcjerH/hi74/XTquikmPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C3aFddts8iOCMXlkDDHaAcQg7bsRD+smfjKxKYK5fRswDNVlUKNtAQRdKxeFQ18Ta
	 T8LjGnwNYkkZPALZcA+TvIc+u1SUOSDDYIjLW8qbraexmbYBEdNluSHkqA3OMC/Y5J
	 qTrubTZPG8r87GvQScYmKm0/IzMAYOTALGAPvpsc=
Message-ID: <3dab1bbf-77e4-4ce6-8314-2b3154be74dd@arm.com>
Date: Mon, 16 Nov 2026 12:26:40 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] mm, sparc: batch arch_unmap_one()
To: sashiko-reviews@lists.linux.dev, david@kernel.org, ljs@kernel.org,
 akpm@linux-foundation.org, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, davem@davemloft.net, andreas@gaisler.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, anshuman.khandual@arm.com, geert@linux-m68k.org,
 sparclinux@vger.kernel.org, ryan.roberts@arm.com
References: <20261115143905.3045084-1-dev.jain@arm.com>
 <20261115143905.3045084-10-dev.jain@arm.com>
 <sashiko-outbox-215629@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <sashiko-outbox-215629@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EF6440009
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cq817yabz8b86fut3nuskzu6inikq8tn
X-HE-Tag: 1794812214-692326
X-HE-Meta: U2FsdGVkX19fvVum69ObCrxUim511ifzNe7gHOw+1YW1sdM5paONgx5VyVtuJOfKxsveYf6Onf3uETRELaF7qHoWXDzBxguvKRqJoM548zGwpOa3UfuU1hoeL5AwIuDm91JyDZBJxKZovLiU6ewoV6E5p5yEomf59A5rcz+GA4Xo6MMVVIjrCKasx9KyjXaV3MQJIJGo4fM8uc+bJkZ2cspxEpHAiGkblIfRw6Ogd+EMgbwwPOZtdrwVXdftI3K3asjYdWYsCmRJAAdyGt0XfPb/GbpZzUEoesfsTAUuf75EL0w4R+up+siyUaaqs7SCCQ9i15zvQKHr2Tgas2M+fh6QYPFRk+VJVMaLsLCNmxlRVBX+FlmVsBuxDHunG5/d08sR1K3ioP4pVJUEcU06pd4aUxrrYWAmHJ02/RLFVv3g7hDX/Eqn9WTy9q6illkaS1uk0fPXDa+brnqWAV+omrumna2rKKs8InCIkZk0iAVe5BU2c/tLlSxoM/UjTFFE7aV63c3vKIZ3EXW8pkHZKpVd1tz4CyQR/Styh5E8j8mm5YvWKQAyVy8YFqP145mJ1lE84fJqE+JqOWFXLBb/i5cg9J/6C2dLPLzFnc+GfaL04WkxaWKhUh5Rq/BxzQWz04QYL0wI/9fU1E7Q3uLlRA9koMu17jn/k+OoKJt7KXLWdC9Z25HwXUQLRICVtYmY36h6TmoxEzhd9F7OiHiz0vWE55H0EXu1Ns/BKPgZlpFofrU7eCSUG/AeAATC9tIYGRdhbp6S9iadAUmqaG48repEfpuc/QCSnilQ6KFaPpgzzeOrPyvg0ooCdegOeRBFDrIAfza8E+5qQ5bsza+9H68mVsyMmcOMY1WnglhJiPL/hGrX4iIS/OLh+Awt6FGW33KEBdGCy53uKtBSjKVjS35b4D3/Xbjbr+keLXaDgeoVUhqPvsnzyxl891Xyhht3A/wqk5KmroVgYHcHRzb
 LhqPSOJJ
 HbUy751io5daQ5hsbVDpCYPOCegplQAaUnUGSST53ZUdxlaiifAbR0ChgOtJ4JDz5SgzrLi8royQd6U1CRuPNqzzPu4eyLbTlDCNGhwfJ5EKxv8quBWegiOw3Z5OKJKpv960cxP9oIW6MLadghwwxfkIY+OaPZVZaFX4PT0CFt9cH7HUhw7kCVSCn/o5x95NOW4pWJhsen9THsT0sSddfnp3xKxX0VUusdXmsR5a+J6ewQsauWBeLsPUy0AEaL4ra6ejsiGzMFjQg7azzQ34vOr2xFyjtgtqY9N37X1jToa7FyvGqWbiEBjW57UcNZ6ggZDSGb8alAcvHlOD8MzjzIr1LpL+2I2RAw/tObtXwK2wXnqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 15/11/26 8:53 pm, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] sparc: leak of ADI tag_users and tag storage in
>   adi_save_tags_range()

Legit, so I have no choice but to add the restore side of arch_unmap_one(),
brilliant :)


> --
> 
> commit ccbef0704b88d6e8aff2c2f0c82f32d9131dcc3f
> Author: Dev Jain <dev.jain@arm.com>
> 
> mm, sparc: batch arch_unmap_one()
> 
> This commit extends arch_unmap_one() to accept a page count so SPARC can
> save ADI tags across a PTE batch during anonymous large-folio unmapping.
> 
>> diff --git a/arch/sparc/kernel/adi_64.c b/arch/sparc/kernel/adi_64.c
>> index 18036a43cf568..ffa378accefe3 100644
>> --- a/arch/sparc/kernel/adi_64.c
>> +++ b/arch/sparc/kernel/adi_64.c
> [ ... ]
>> @@ -394,3 +395,23 @@ int adi_save_tags(struct mm_struct *mm, struct vm_area_struct *vma,
>>  
>>  	return 0;
>>  }
>> +
>> +int adi_save_tags_range(struct mm_struct *mm, struct vm_area_struct *vma,
>> +			unsigned long addr, pte_t oldpte, unsigned long nr)
>> +{
>> +	unsigned long i;
>> +
>> +	for (i = 0; i < nr; i++, addr += PAGE_SIZE,
>> +	     oldpte = pte_next_pfn(oldpte)) {
>> +		int ret;
>> +
>> +		if (!(pte_val(oldpte) & _PAGE_MCD_4V))
>> +			continue;
>> +
>> +		ret = adi_save_tags(mm, vma, addr, oldpte);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> [Severity: Medium]
> Does this leak tag_desc->tag_users references and tag storage when
> adi_save_tags() fails partway through a batch?
> 
> Each successful adi_save_tags() call invokes alloc_tag_store(), which
> allocates a tag_storage_desc_t slot (and its tag_desc->tags buffer) or
> increments tag_desc->tag_users on an existing descriptor:
> 
> arch/sparc/kernel/adi_64.c:alloc_tag_store() {
>     ...
> 				if ((addr >= tag_desc->start) &&
> 				    (tag_desc->end >= (addr + PAGE_SIZE - 1))) {
> 					tag_desc->tag_users++;
> 					goto out;
> 				}
>     ...
> }
> 
> If a batch crosses tag_desc->end at page i > 0 and alloc_tag_store() fails
> its GFP_NOWAIT allocation for the new range, adi_save_tags_range() returns
> an error without unwinding the first i pages.  In mm/rmap.c,
> __ttu_anon_swapbacked_folio() then fails and ttu_anon_swapbacked_folio()
> restores the present PTEs for the entire sub-batch via set_ptes().  Because
> those first i pages are not swapped out, adi_restore_tags() ->
> del_tag_store() never runs for them, leaking their tag_users references and
> preventing del_tag_store() from freeing tag_desc->tags or releasing the
> descriptor slot until process exit.
> 


