Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE86AC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72856B0098; Tue, 22 Sep 2026 08:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A228B6B00B1; Tue, 22 Sep 2026 08:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911D66B00B2; Tue, 22 Sep 2026 08:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC7E6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:52:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECD5514048F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:52:55 +0000 (UTC)
X-FDA: 85241387910.20.92242CE
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf09.hostedemail.com (Postfix) with ESMTP id 97705140003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:52:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nxPbQTi7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWEkGnkJbTXDIRIKBzMedQjTco/m0rFaJmBUYfZQCpU=;
	b=SanVu6Mho+7q2/VUwskj5BvnCxH+r6ncoPByXkbZdAZi+oJVQ5gqTve2EfFaNpZIXb2dZ4
	DWaXC4q/qzGjZF1+I4pMaWgWpz7NkJGLyAwOcUq+ZP5X1CCSfNll0iFhEcO1eewgqkgVaQ
	hsBMzXtrxKZZt0Wx4Ph1coi/TN4Jcns=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nxPbQTi7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081574;
	b=mzs415BgQfAeNA3L9kRf97R24sm9ITIs7oSV739+Elh5IjnOv+trEI4GQLoG1W4a7o70xY
	Q4I9nENSzwYvY3eD8aQtWonMLK/r7W6jTI+0qPwtnMMKC33TRRSUrMAWIqh1Ij630b1hon
	gdYSpodbsqXz5lkxAN30nxfhamTqPRE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Jae59hpYchWjFu5lmM2YnvXbv7hvGTzJEokKNdRbnnA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790081572; v=1; x=1790686372;
 b=nxPbQTi79vF9CUl8eezgYLh9Qdy4s+5kv/DBz2cICTmalmIeDKUvG2BEryNN6gi977Rncrqu
 nEljd/+ZzxjWRbYuUAbB96sHJ5aihuI9vrv8a/Ez0OUqO3HmKHeShOmA3tTINyauiwqBO7MeSU6
 77xt9COVa8rCdWe+OlJtl5s0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d19d6af701ceeb03;
	Tue, 22 Sep 2026 12:52:52 +0000
X-Mizu-Trace-ID: d19d6af701ceeb03
X-Migadu-Flow: FLOW_OUT
Message-ID: <fcadabef-4859-45f6-9612-a819599c0fdc@linux.dev>
Date: Tue, 22 Sep 2026 13:52:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 07/29] x86: mm: add PMD swap-exclusive helpers
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com,
 kernel-team@meta.com, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-8-usama.arif@linux.dev>
 <aqqmClGl0lt5Qzee@thinkstation>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aqqmClGl0lt5Qzee@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: twkyuokjmre4cbyp7roicpiubdtmi4em
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 97705140003
X-HE-Tag: 1790081573-67487
X-HE-Meta: U2FsdGVkX180unDJq/+Nhpclz+8gr4U52hNca4GMXBPkgGg22v3Hk0BuQ2XxWbur8NN/IUPORgym/R9+SJb7jniFHtBDrVy+Bxp7jBZOVWcJ2FxKC+61IgodOn/peTh7MIUrNVqefdHmTzrNScLmtQepNp2NiEEFamWBV4d8K40fIBbSPTDCt9PTwX9sH8twuAeJqSZxUY1EZABK50q/JwwWh70XvF7cxrM6i/qIFPxoljoehZBqIFFYTd0K2dpzVd7upuLFhmkLxyEIYRscb1EJeUy3TQz7sPxl/0+zZtEyEBaEl6H8+KN75ywnTYVjexVZ+msNmd2sUgAZ0yzXCc+o2FrXqOgw7pSgIrOtB7wU4AMwdLTim4uF9JVYh8WNnrX5Uk0NSoKdGrqqPZ6qIQKYtG+EdA/F1vuBS0KE4abP2p4w43xP1lD4yMtliWVPCqBspdpzO7lNXOBOr/Nd+Rmg0FmuxE8811R/Ij877jKJj0lxstLyTr9dKoIy1BqDhD88hiQRrG369QCzIOG9wRLR4PKccbAWmIzsIixc2d3XDlc2H/vRUcShEQLtQIusy6nkSvDjlvuju14wgh5QTtYnMRkUQAOU37LeMke5i17rNeOmSLGEL37Blg+DP4D3kI7eGrkkzgJvfGvtgYSDHzfBBlsVJzNdu6ysBxFEIw/mvApHPj+/F7u54JQIGdWPoC2faXCN48B9O74nlwVCOl3VwXRvmLLOscXOT2wiRvA4K3L6sMlJbLfP+AkbH7PTdvvUuEGsFACpS0eOxaFn3UA98NMgqIM3NGxw89NF/pOIsbBPhjExruikukfs4PCrYkiJmhG0wf49TKTeH9JSxi358ZkmQrcDQDBN0OdJ0BrEDRChXOXWnzw/TPCYJThaKVYFDendzaxoTG03NwrreO23WfbAtot0xn8GyqD/6e8ybkwdqslsPYPRoe7UfF8GatOCfwRJXoP/E6w5ZYq
 aTuBS9Cy
 PVBYqK0E8ZQcXw3P+zNfGVBThi1mHhLiGZKq6g029FvHXCJGOTMAqlYmilKN+pqVaVVh1Bcs/NLbtCeQcAuNWQ/Mu3qon1oy/gMUa7UmZqT0jSo7ZysDphND07YVGUOVyhLH6hnKx+Id0gniRU3wtTNqTHzEipwLnan8ayWr4P246YmBpc0Inge2egfvhjmSNmf8NUnPX9BvIdzjaDx2+hgShqM15rfpR+oMih4AyzMhv989Xx5qWAHKLietnt8psVaIx/3bLSg0ilI9yKCLHtam0gRQ131IS7U4fIVF3zssz+wl+50sLjHP4Ls9QSxGdmEM5k5wqWtNnu9kyp4CtKlASjEEyCzJyU5/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/09/2026 15:31, Kiryl Shutsemau wrote:
> On Mon, Sep 14, 2026 at 05:27:57AM -0700, Usama Arif wrote:
>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
>> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
>> not just in a swap PTE.
>>
>> x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
>> _PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
>> for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
>> not select ARCH_HAS_PMD_SOFTLEAVES.
>>
>> Cc: Thomas Gleixner <tglx@kernel.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: x86@kernel.org
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/x86/include/asm/pgtable.h | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index d551120a7c889..a2d1cd03cba23 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -1525,6 +1525,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>>  	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
>>  }
>>  
>> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
>> +{
>> +	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
>> +}
>> +
>> +static inline bool pmd_swp_exclusive(pmd_t pmd)
>> +{
>> +	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
>> +}
>> +
>> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
>> +{
>> +	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
>> +}
>> +#endif
>> +
> 
> I was about to comment that it is broken on 32-bit as
> _PAGE_SWP_EXCLUSIVE there is _PAGE_PSE which would make exclusive swap
> entries pmd_present(). But CONFIG_ARCH_HAS_PMD_SOFTLEAVES is only
> selected for X86_64.
> 
> Do we want some BUILD_BUG_ON() to catch if anyone would try to enable
> it for 32-bit machines?

I added static_assert(_PAGE_SWP_EXCLUSIVE != _PAGE_PSE);

Thanks for the review!

> 
> Otherwise:
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> 
>>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>>  {
>> -- 
>> 2.53.0-Meta
>>
> 


