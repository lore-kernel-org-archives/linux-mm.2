Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DD6CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1C36B0028; Mon, 24 Nov 2025 05:17:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382316B0029; Mon, 24 Nov 2025 05:17:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271F16B002A; Mon, 24 Nov 2025 05:17:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11C2D6B0028
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:17:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B62F4160309
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:17:41 +0000 (UTC)
X-FDA: 84145099122.25.DD58F86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20628180008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:17:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H1uBk/yw";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763979460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXWLA3oTruhCCyjyVBTL7n82p/hxmYJmumq84NHG00Q=;
	b=ObVhJYVwpeVvk+Cu/2BKDkHEvOo9jGRpgRpnDXORKcrzJ9Y4MNAzgQ+eJgdxybaH1nHfiE
	W4eyyoTDudQhZczW6ticPYnmQ0wzZPRffhhaIIyyWEWGG3YiJjac0gGe615RBD4I2+lql/
	xuaGJGUq8DMgmkgx2Jd0bR18J0yDGiM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="H1uBk/yw";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763979460; a=rsa-sha256;
	cv=none;
	b=6f7KOIp4CrmD9V6M+tdnrT2COqNvXLEouRPXJpmhd9Qem1S4RIMuEjtTnvwCI8FLjduoAy
	yH6kex9psBE+y9gkw+5YS97CYJD1mwtrf5f0OWlynf1b5BScIvwYh1pBNWKEno7XGa9Nuw
	SmEtaWj0mi8ZJ5XAWdiIZNVFch8pSf8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D43160138;
	Mon, 24 Nov 2025 10:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734C0C4CEF1;
	Mon, 24 Nov 2025 10:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763979458;
	bh=BHZLLVaKtHbJtuUBDAHntZWxmUQzmBKPu5HpOi8S0kE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H1uBk/ywLkiHwnL5I8onigZKl9NS0kqoh0Oys4QUZVaCXMzNStaPvdVvExrgr+qlb
	 RhxfLA+iWa9SiLItjfRTJ8yU/Fq3uihfniSEhC01afA+no34iudhP+rp/TlpehiZSv
	 sXyRfVV+wWcVb+JDXYG2tAC4JUTWDd7HsO2MxsAM4JRcMnxpF9N4elAa78JTaqW9a9
	 09GfkoMmnQSI6FArP6RHzbrECNagf9lTcPlAVrwTLx6C75F2mYYBpbz2t/+VbNfvcm
	 Ph01Kvo7IcjN+kd/pj1eklV8FDv0tbNuVTXnpSpFsMmdIxPaC+bNU4GCfP/QVtUnN+
	 fmfREVWcb5Nkg==
Message-ID: <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org>
Date: Mon, 24 Nov 2025 11:17:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
 <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20628180008
X-Stat-Signature: rnjk5ip6onqm8kned8kqkwyyujfan871
X-Rspam-User: 
X-HE-Tag: 1763979459-109741
X-HE-Meta: U2FsdGVkX1/SWFdhyodCQ2OaFeyDMAnsSyPRA4yU2JyDBHx1LKUYc/guh2CrFQCEYIZlsytGx0yUj79caeSbVSnsFXlwAeMstxSfHfXRzvHb7sIx9d/xLOwgWRcxGuivr80QaSPKSlPxSK4ypR0J3QSPZMNoxD15juYSHkOG64Dx1xIK5be4wG6tGFwrlQjakRjQJoOlN+ESRmWUPutCIX2RoNz55Gu1VgQZbMBmHJdEVpr8P3++Xk+Sk6uEeJLRQA3525TJn1am+ehE14J1sE3P4zBRtF+GMBdEbMihpUo/qw0Q5P4K3M/2E5R9UUe+t7TW6XscAlgrCT/VaGwPeckiCjUYKbGCtdY6crelRKhnW4qI1LEf4E68U39P8wbuxu8eKrSebUZes2KqrjnlMZeuN8p6iTzYDE5jUsizDjU0TIECWGAEyPODNfoH3MuHzLQAiefEddsDYY49heDYzSLWew1iGp6VQPjvx0SxrZKC6sTWeELpi39uKy6ab9oN7ShoK+PVh7aYB/r2QzhRq34OizC/4pVoomcDiRFPTrSpgpZdo9d6g1QAONkKvLF6zCfdo08l3QL0wBekuAyR981XIucBWaM4dUe6zlBPcd3y/ye+zzXzT5xJjnDHg8QCdYH3Rj5DieaLQEitmwPls+fYfPpksfop9ZRSFuOMDPiNk+UX0c1SRA5Nfu6qh+ooG9/mtB+jxBpj/yZgoqCnBOtdZaCG13zMqhK4DqUnW0nHDAcmBH4PltcnhoTYzPZqKy5cT14R7U2DONyZFSiswcrxNT5IS/IY2bog9xzzKhdWRDv94ENf6Y5zcxuvi0x5ymZ2mPkf0zfKXJrgD/gcgb0HDRyRSH5vd3/5RB6B3CrAME7hIKHmxb9HcaitgBnW9ckqElhSL3Z0eFLp6/urSGU57EIGX1S9mOabWIAJN/x8Yq3X39lXE4ZmeMiUGFFnOGk1SpBorymRJII9XLQ
 /lGD0Yo/
 gfpdLbDKilhc1qRShgjJNoJyG/uN2SJ8syhO0IGflMbgGjb15dCvHQYy3vz0DuCh9DMpNp6NBi88xXkTdrMP5yZjNn4jwehE4D7t/mQOShl2/79JoNdrt90fF6cK2R0dASsjbmfCZ/PB2kay3GtorMJuDW/HFQexsOILwmadN9hjXbVc3LNnJurqCmpAvce+c4ARI2Ejw9mHF1LBglwYaSf/bQnHP2uzMYg8LoenRbWMcWPgik9KwDTYHs8uu8W3fuHmlEITYjbV/tz9Zog42BevhgVwFLBCsSgrKLuAlb1HyU/8Uu+PlZfbjGYucdmzksYL1xaKzSj43dDXso6MdNK3DaIByOSffa3goU+9dbJOOSDHa7ncz3Va7QGiuC9ZoiyKR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 12:53, Christophe Leroy (CS GROUP) wrote:
> 
> 
> Le 21/11/2025 à 21:23, Ankur Arora a écrit :
>> From: David Hildenbrand <david@redhat.com>
>>
>> Let's drop all variants that effectively map to clear_page() and
>> provide it in a generic variant instead.
>>
>> We'll use the macro clear_user_page to indicate whether an architecture
>> provides it's own variant.
>>
>> We have to be a bit careful if an architecture provides a custom
>> clear_user_highpage(), because then it's very likely that some special
>> flushing magic is happening behind the scenes.
>>
>> Maybe at some point these should be CONFIG_ options.
>>
>> Note that for parisc, clear_page() and clear_user_page() map to
>> clear_page_asm(), so we can just get rid of the custom clear_user_page()
>> implementation. There is a clear_user_page_asm() function on parisc,
>> that seems to be unused. Not sure what's up with that.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> 
> ...
> 
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 7c79b3369b82..6fa6c188f99a 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3879,6 +3879,28 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>    				unsigned int order) {}
>>    #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>    
>> +#ifndef clear_user_page
>> +/**
>> + * clear_user_page() - clear a page to be mapped to user space
>> + * @addr: the address of the page
>> + * @vaddr: the address of the user mapping
>> + * @page: the page
>> + */
>> +static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
>> +{
>> +#ifdef clear_user_highpage
>> +	/*
>> +	 * If an architecture defines its own clear_user_highpage() variant,
>> +	 * then we have to be a bit more careful here and cannot simply
>> +	 * rely on clear_page().
>> +	 */
>> +	clear_user_highpage(page, vaddr);
>> +#else
>> +	clear_page(addr);
>> +#endif
>> +}
>> +#endif
>> +
>>    #ifdef __HAVE_ARCH_GATE_AREA
>>    extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>    extern int in_gate_area_no_mm(unsigned long addr);
> 
> 
> Isn't it chicken and egg with clear_user_highpage() in linux/highmem.h ? :

No really, because we make use of clear_user_highpage() only when the 
arch defines it, so the highmem.h variant is ignored?

Not that I particularly enjoy this way of handling it, so something 
cleaner would be nice :)

(in particular, relying on highmem.h defines in mm.h is a bit suboptimal)

> 
> #ifndef clear_user_highpage
> static inline void clear_user_highpage(struct page *page, unsigned long
> vaddr)
> {
> 	void *addr = kmap_local_page(page);
> 	clear_user_page(addr, vaddr, page);
> 	kunmap_local(addr);
> }
> #endif
> 
> And at the end this function is the only caller of clear_user_page() so
> there is apparently no need for a generic clear_user_page(), at least
> not when clear_user_highpage() is defined.
> 
> I think is would be simpler and cleaner to instead add the following in
> linux/highmem.c:

I assume you mean highmem.h

It's not really highmem.h material, but if it makes things cleaner, sure.

Might be that the compiler will not be happy about that.

@Ankur can you play with that and see if we can make compilers happy one 
way or the other?

-- 
Cheers

David

