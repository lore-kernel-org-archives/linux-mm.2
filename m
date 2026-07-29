Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F29C54F52
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B556B00A9; Wed, 29 Jul 2026 09:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AB06B00AA; Wed, 29 Jul 2026 09:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2045F6B00AB; Wed, 29 Jul 2026 09:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECEB36B00A9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:57:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E18631206A7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:42:44 +0000 (UTC)
X-FDA: 85041778248.10.0F2FF89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 437C680006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:42:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIiVNrud;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785328963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCfnfjBFYExAnxJTD/rzMs4G+JVWk8LnuYF1LstcYDw=;
	b=voRpqMs0RiVLromeLLMN1I+nVoKLcKaqcE8TRuriXmsssY4RrhYwXtWatPS7jVkK8FpHCy
	/MFSrFojgfATIIj1CaE0Jd3BiA2gYL9ankwzoqmT18hszY+AQyxo07ZjZLftzZx3uGRLFK
	B3ZZBrIGba7DAKSBCpNZ1XQQzDpGlt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785328963;
	b=4G87AQx66R6LU/vuzfxJYQ3Jgubly9Iba+iRGiToQDGx6fG8zEjUcjz8nog9Kftw92ptDL
	P6S6gX8KYe8PM6ChXfXNZ0YFQJfuc7SBcP1rn1UynGzmQ6sjECEEc0Lyc53MlCRZQjDh7Z
	7/VqSRdZ40SfDVN/eRCAGKPszd4uyOo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIiVNrud;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B98626004E;
	Wed, 29 Jul 2026 12:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1321F000E9;
	Wed, 29 Jul 2026 12:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328962;
	bh=CCfnfjBFYExAnxJTD/rzMs4G+JVWk8LnuYF1LstcYDw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OIiVNrudGYMgEdVIx0kkjz41K/abfMmWQCuVMoltvKL88ry5vvzeu9fzcY/9OXDWp
	 urmM5jTj5uYEwxtowv6dnJlwSS9PTo7quWtNi7gHj3ZqfWleJMlYHWWtwoq0IDEkky
	 8P8JnLCx+cJFeHdNFsas608FWlQT7bVkC2bwM046FAmQ7zDEHB0zW1hDtHOw8f8bql
	 4k70NlZODBKCZTfjYFNVdqOJ/v1f/eicr7a9D82muWKPn8AlDCyXeFCuwaSWyiZ0iA
	 7EW64naZjqP6zUdWAdVwIEaL++olcUVsOGEeMV8mWUj+uyYo7qTGP16v8aSA/cUEkI
	 1GtsvDfHUTVwQ==
Message-ID: <5abb6bbb-973e-41e7-820c-057e85edeb95@kernel.org>
Date: Wed, 29 Jul 2026 14:42:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/11] misc/sgi-gru: use ptep_get() for page-table
 reads
To: Pedro Falcato <pfalcato@suse.de>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, agordeev@linux.ibm.com, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-10-usama.anjum@arm.com>
 <amnxCmFU40QQaxTx@pedro-suse.lan>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amnxCmFU40QQaxTx@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 437C680006
X-Stat-Signature: 1b58sxadugpihr48qqpgfh1zoq8rcbxz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785328963-98920
X-HE-Meta: U2FsdGVkX1+5CDbcwOrsp3Aqnn1WTAJwpQCT9amp5XcXawPV63H9nVo6+WPsru8wyaZ64aztJCro3IRgDVXORYhynXH6+8gWO/i0vrHE1BTD1Yd9bnvRfWuY5Irs719ZerYyjV4M9DPdWumKOL6TQZVlAD7FtAKvqJSq+w7EUGX+imnkFbv50JsFsk1pw29K1S7nOEjW5Fzd0ejDdD0NW/zPTvxwejuMSqcJgPKX+KRLKRjEkFsnW5Dh6SGHnV3bYuR9Qh9YKzVAKtZOA16/z150Esel89BzVVOENWFHoTg9mzEBa7rQsb/0bSXEjr/R+KWersG/0XynIX5Sd2GnAfLdKm7yn5reRxpa1GmKtHfA2pr+5AX9KpRjem0//ZH90uc415M6TqfrPwhQk8mFrv9Cek5J8xB3WTn9/9cBeaabVETnIZ5IS3MgL1Yiqoiz9wWukxvAuEE9DbQm7sf6vqZQ536W1FT++0CpJSrQ70iF9C7SlvooFhO0wdd6G8H5noqU/9FAEqPI3kyl10invo6FtQARoWXmYdoYnR1UX/kEj2jUid5FHdZi6VcSM/5MaLs/OMOLk1UYgFYsk2d/SoAzDYdzZvhBcyvJMJJncQmNYoktJeYIux672XG+9EeH5hAD9KQkqcW05jUB9JwgL+ZSF8YokVouZwHZTSwkxN/kHyAUA7cIZApm4mjQWfDILIPcBl0pNcXlPCeXZW0UNdHUrhhUN7GSZDLImC+ZIIiozjesQCh6JhuyMk7orkFuxhnUttGMyMsh7TPm4aS+JvjW9oJIfDKod7pHSLlme+UwEop+zzAq20Q2g1irQWJaAVHyiLmYOYryTL0if0Q2+Au+zSCqP6Kw+QoPsArhYSLM+Zxa+1a8gH+ZZiU1u1k39IxoeKQl7/80XDJabtc2r84z/sVM4NGtObKVT1iFeZezO9h1QYVINpCE7Zx9id3tWLadFg9HxhNgbd6jhjf
 bh/Ouk7f
 DFN99o03Kb5JRRb8UiR5Q8vnOrde3BZ3X0yNJRzqmhuzigMxdugoVh9AtOwWah4GkYj6eEoEHc+p7KhUZKXswHmPco/6d9mx5ZenNk50/D9ZGWqOOQ+BjBxkfSO+I0zgquR5ONrc3nkEG5BTHlbaQh+7ienINSXzSKbcyMLd3l7PidVSS0hgQYg8DkE8OajO/XrPJ9xSq5zvMh32VnqaAQbidDFZZXbpoOX7r3JOYAezr4/w8/61fAvVUUSlnNMDpzXdlE0IuaWi7ZQT3DKsqeNGgW6PF0EidRQVqKBu1dEYn9Zpnhc78aTVfGf1sHzfUSfvpWRrom30Hv8qkq3RnroFO7oAlzUHnwCuPOqtM4SRYlIxX0sKegt2jqFRKW0hngumFlfyO0S2/gKn+uVABdpd3+QtjYvKZ0XjLsYBFtXK3BYR701eyz8J80Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 14:36, Pedro Falcato wrote:
> On Mon, Jul 27, 2026 at 05:47:00PM +0100, Muhammad Usama Anjum wrote:
>> A leaf PMD is being read through ptep_get() by treating the PMD address
>> as PTE-sized table storage. ptep_get() now accepts hw_pte_t *, so update
>> the cast accordingly.
>>
>> pte_offset_kernel() also returns hw_pte_t *. Get pte_t value by calling
>> ptep_get().
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  drivers/misc/sgi-gru/grufault.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
>> index 3557d78ee47a2..ff89d34ad2aa4 100644
>> --- a/drivers/misc/sgi-gru/grufault.c
>> +++ b/drivers/misc/sgi-gru/grufault.c
>> @@ -228,10 +228,10 @@ static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
>>  		goto err;
>>  #ifdef CONFIG_X86_64
>>  	if (unlikely(pmd_leaf(*pmdp)))
>> -		pte = ptep_get((pte_t *)pmdp);
>> +		pte = ptep_get((hw_pte_t *)pmdp);
>>  	else
>>  #endif
>> -		pte = *pte_offset_kernel(pmdp, vaddr);
>> +		pte = ptep_get(pte_offset_kernel(pmdp, vaddr));
>>  
>>  	if (unlikely(!pte_present(pte) ||
>>  		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
> 
> This code is super, super broken. Can we remove this ASAP? For starters,
> we're using is_vm_hugetlb_page() to detect page shift, the code does not
> grab refs on the pages, uses pte_offset_kernel() on user page tables,
> does not handle PUD-level hugepages, does not handle PMD-level hugepages on !x86_64,
> does not hold page table locks nor check for pte table retraction, etc
> 
> I don't think I need to go on.
> 

Heh, when Usama first showed me an early diffstat I was like "what the hell are
drivers doing with page tables here, they shouldn't be doing that".

atomic_pte_lookup documents: "Only supports Intel large pages (2MB only) on
x86_64. ZZZ - hugepage support is incomplete"

What is this crap? :)

-- 
Cheers,

David

