Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA22F8925C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 11:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6006B0088; Tue, 21 Apr 2026 07:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC6D6B0089; Tue, 21 Apr 2026 07:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2B16B008A; Tue, 21 Apr 2026 07:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18E3E6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:12:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD763140CA2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:12:24 +0000 (UTC)
X-FDA: 84682299408.12.323821F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7BA0140014
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:12:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHYYWGIQ;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776769943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+qFuBqdY2oGRrt5HXrYFGCOTyPAy0vzEzpdnuuP46Q=;
	b=BebsnPyISdtrZJct3XkH/TGIDgx377heI5AJ3ullTcLK5ORTeysB7BUmySpffZXNpKmupv
	+0qF12z8YnOlvPz2KsqL5J2JCEbX4odwB6hrP1O34fQVjs912ai697UagHyIrl3WEk8T2g
	/BapFB09sFRDdu3TQRoH88gXA2Ef7U0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776769943; a=rsa-sha256;
	cv=none;
	b=OAtDrNDhowsZlvijScAD6pj9TSW8N+tI4HZdL3+zWIoqsBsnvMx/H5Tg/NuBHv1Q+8skr1
	BFdf1rPEvJxGpC4Y1HXUP0wMBhi4VpMCBMMWMT0YjZYEmBOnt0G1zggiV6pEggMLi+bVlv
	t5c3bzp6cavfDEa+JmPQLGrAx4uzfH8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vHYYWGIQ;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01EB2436A0;
	Tue, 21 Apr 2026 11:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E6CC2BCB0;
	Tue, 21 Apr 2026 11:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776769941;
	bh=h0ZfPS8N0B54B+EWjuQ7SygZYX7IrUZB4L9pra+xp04=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=vHYYWGIQ+rmLOH/dplvjRPF4vYo2dyyx6zOOYaYT+TEKlyOq5K/savikcr+8DwtZq
	 TU83RqsoUo7DFezsnyPSWhV0niz/XQHBSYlPWAMylIBL0rYeM1jXoROAv6f/EztRd1
	 4DHS0P8/EmC7je2SNtQcdoHhpw1EcnO4wBTdzpE1zazgVq6kvJdl1lItBLr/rMNYoA
	 eHGNLz0Jm0s/YOSycNCe0KhMXrtjUeurXmivk101OPP9HaFMgOMfrSw2ZhCWsoBM8T
	 cFYLWV8cxRik7tETOXqO2it1/wvqXFRQYZwKRNhN1TAhuCfIB94QSrQX+CklKnP8Ip
	 Q9+jThh6/X0gw==
Message-ID: <068cdadf-d979-4170-9ff3-2468f46e9786@kernel.org>
Date: Tue, 21 Apr 2026 13:12:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 11/18] mm: skip zeroing in
 vma_alloc_zeroed_movable_folio for pre-zeroed pages
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <39c3c8e647fc4c8e3dcb5c9d12f2e29b5404e8f2.1776689093.git.mst@redhat.com>
 <b7fc296b-06bc-4d52-b607-2da94c123fa4@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b7fc296b-06bc-4d52-b607-2da94c123fa4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D7BA0140014
X-Rspamd-Server: rspam07
X-Stat-Signature: z9koo3xek6ti6urdxuxy8nmrqdu7ou7o
X-Rspam-User: 
X-HE-Tag: 1776769942-52361
X-HE-Meta: U2FsdGVkX1/pnfNkGoeNLszQZ3FiIorhpT4aB8Se5IlVk7pjGlYYMohL8tvQBScYbIbCzAXgrtzROWEa89htF1mOQpvIhnQBvcV5Y0wHo2a6kMt6yXUOpzYUfVsFDttho9l+MGuQqxoS7aVwTXqNQ9yPWw8A+tQTyRziVeGq2oarwzwV/h2lbpmZfDEDaErQTJYHLj92HtaTI/tarSHG7W4u/+TpXcZtUKsYDp66bAXNisiFT1CGMhWeCYs0J/kEJtdnuXdeYNmZwh9TZfFhCO7QwfTe9LIEUzSRjPTRsQ0qXAkK4raqYGlmUQ0AvVwEPc95JFLZuj0LWS+AwGBwGBrlaJo8c7FVXMgk4MPHLtd5UtWty+cfKm+f7TX8Ggh7HJubjJ0SUPSgDQdruQzzjgxOMk/9WEy0AJF2fra8IXzYB7e8c2C4MGbNK8YFQR5Idrk+GAlqVmMJsjwAuWnc/6jArqbzBwWR0T/ujhLzSYpl8WzqTgsSeM9r3CqZvkJ90DT5MIyJqroitJVSdwCJCwZlgOOiA8M5UF8sKE+ZWlrl/nGoUOJhLr1yRs4Qz1i1Qsm+yZPu10wNKQwJWH4BON/TsPbtLgVGAQHzsY5QdhPwzV6ybtaveuverWNcuOJT0isfjb4s1k+zcriP1RzqgiSMkEDWR+UoFaE+DvfjewdLOlTJFu9kjgftYH67m/BqqJdOHIk/q47kqK1VF/oJft7yHIQ7l+iR6rHQSyJGkF+3mqfN2N9TA52ZFpAT4/2KLHTn9lsJorsP8lOm2+KrZ5HTSIx9T4zWs3K6RYP0qyjEgB34AmYAifwYg7EUdN4YCp5APXVgo37kXN96hyFe9Ft6srEwoTJHytefzDjA9Okl0kuiCBL/2+T97Aa51Y3kFUiaJH4diMNukkWiaqoiGkNkh4H5t3mjElKU0MuBVSO5fLjHqTZCMRwpHEf3RhPBHSYXJh/nC4/FrmSS8rW
 9MdNWsx6
 3Kz/3BAlGc7wgKteGg7zewd0RNFCIjV3JgpuAgKvJIrm3SWcO98BoJwlAyKlW6NXXVgWMcGYEJQILP1Kra+lAnGUSBkauVHfeX83rLOBAR3goTT5o7um5HuLcaxN+8BT1OoiG8xscj4CfsXl+Mh5t4+PArYYhTlu90ULM5DkTEpfWBEghZibJ1khFq6lpvjAHqSi5kHgHmq5i431hCeF6decIKPEYQNLYBU+G09GkN6kCXOuhK6iyx8KFP6zmoAxQijHXsU1L66DF8L4WmyNRL67UlDL3E1zoDhLUNFVaGWhQfHpak0YHV40De168pUqqhJZqqSga2WGUnBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 12:58, David Hildenbrand (Arm) wrote:
> On 4/20/26 14:50, Michael S. Tsirkin wrote:
>> Use vma_alloc_folio_hints() and check PGHINT_ZEROED to skip
>> clear_user_highpage() when the page is already zeroed.
>>
>> On x86, vma_alloc_zeroed_movable_folio is overridden by a macro
>> that uses __GFP_ZERO directly, so this change has no effect there.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Assisted-by: Claude:claude-opus-4-6
>> Assisted-by: cursor-agent:GPT-5.4-xhigh
>> ---
>>  include/linux/highmem.h | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index af03db851a1d..8bb67772c1cb 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -321,9 +321,11 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>  				   unsigned long vaddr)
>>  {
>>  	struct folio *folio;
>> +	pghint_t hints;
>>  
>> -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
>> -	if (folio && user_alloc_needs_zeroing())
>> +	folio = vma_alloc_folio_hints(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr,
>> +				      &hints);
>> +	if (folio && user_alloc_needs_zeroing() && !(hints & PGHINT_ZEROED))
>>  		clear_user_highpage(&folio->page, vaddr);
>>  
>>  	return folio;
> 
> 
> For others reading along, the variant on your other branch:
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index af03db851a1d9..ffa683f64f1d1 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -320,13 +320,8 @@ static inline
>  struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  				   unsigned long vaddr)
>  {
> -	struct folio *folio;
> -
> -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> -	if (folio && user_alloc_needs_zeroing())
> -		clear_user_highpage(&folio->page, vaddr);
> -
> -	return folio;
> +	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
> +			      0, vma, vaddr);
>  }
>  #endif
> 
> Looks like an extremely clean interface.
> 

And we could likely just do the following on top I assume.

diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index d2532bc407ef..f511b763a235 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -12,9 +12,6 @@ extern unsigned long memory_end;
 
 #define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-       vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #define __pa(vaddr)            ((unsigned long)(vaddr))
 #define __va(paddr)            ((void *)((unsigned long)(paddr)))
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 56da819a79e6..e995d2a413f9 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -67,9 +67,6 @@ static inline void copy_page(void *to, void *from)
 
 #define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-       vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifdef CONFIG_STRICT_MM_TYPECHECKS
 #define STRICT_MM_TYPECHECKS
 #endif
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 416dc88e35c1..92fa975b46f3 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -28,9 +28,6 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
        copy_page(to, from);
 }
 
-#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
-       vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
-
 #ifndef __pa
 #define __pa(x)                __phys_addr((unsigned long)(x))
 #endif


-- 
Cheers,

David

