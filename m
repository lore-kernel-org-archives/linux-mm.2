Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD95E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kupXkdCx
Received: by kanga.kvack.org (Postfix)
	id EBB786B05B0; Mon, 23 Nov 2026 01:57:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C4A6B05B3; Mon, 23 Nov 2026 01:57:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B3C6B05B4; Mon, 23 Nov 2026 01:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0E206B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:57:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41C14C081A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:57:43 +0000 (UTC)
X-FDA: 85465478406.28.C2B770C
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4DE8640005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:57:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kupXkdCx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795417061;
	b=Y5s1MErkt2pNeYHkBm1/x56y9Y4sn6NIGAMTHAMGJM9UNIU1O2PLuC6PE4rCkqutXHlprn
	tIIQ3udJWhPNls1oL2JyHeUgdLZ3Q2x/EVkYRwP1lW3MvE7vfH3FKHm5IJ2+7IEpRZQedk
	cZ1JVREXMgFW45LA8caJ9ZFRlbJnGlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795417061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQmPDHR50ny9yG8I6ZWZCZxGsKK1lbvYAkLm3ZuJw50=;
	b=DiTkMq6Cl1KGI2BZJIJm0l6XI5jY4D+SxMAeAtQbXR6VgRB15BnpXU9W19fJaTMLdneahx
	jVZR1t2xUqbR99brnr7ZE0ZTacrGW0Fm7MYuuXLaVjFKgBdmODiyEuU1yEDGKmjuYvhJ1n
	nwaRVU3av/KDdIHXkDQBq8SHImtz5q4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kupXkdCx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2ed216ed287so17854255ad.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795417060; x=1796021860; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fQmPDHR50ny9yG8I6ZWZCZxGsKK1lbvYAkLm3ZuJw50=;
        b=kupXkdCxp3YyC+eftZC7C1ZSxmroPH7BEYOR0VzhmCvR92T1g3ab/v9mDFg4AIDaSi
         az4IH8YihfGEbuzK260e1JUjWYC8tPeBOkVlKQ9lpfvBhSHx1ap22RVmO/PRCMbLupOM
         EDGYxgsonPmjuoHihMRryUl2bfe5kXakoudh62HiFjcGpGptrjYaIDdeporEFhIWO//f
         /aQl0cXLcM2Tn3r+LQZ3o/JKwGgMEmNS7so2z8dlEWLr89yoUOlIR7H3af9oVSHBwQiw
         7tKryJPZKLeX5+2HKGuMdB3ga2njLMvmUjXdxPl32e8I4goeoVrZDmFnVspPWh8CPlmx
         sU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795417060; x=1796021860;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fQmPDHR50ny9yG8I6ZWZCZxGsKK1lbvYAkLm3ZuJw50=;
        b=z9sFQf51h9dV++icdMbwoSIyG75kohlfcAyAL+EKgKaC2Oewn60DX0/LJCPc+0ZaJa
         fBgEIieAFHE7gJhfydgfatfmVu+n27EE7jPkTl9Wc0SFQN2iv+BaI+2KUzLLftx8jESR
         7NG+NXAh6Bw/SOprPVJ45dFkrxUXFJmdM9DtJguCBNBlwLkjCO7AqNJXf5hNtQnTaBXc
         vHqAkkFrdTUJAkvtNSCPFCfRX04tG2okQjm7r9HNBcDkrHOCUI9c/T/xO4VGp32cK8EG
         sk5IH7KCpWAClVrkDdxLrpVUbQDtOW7Gnj+P0FXsp9bm7pYP0XOOAQQcFV8JHK9bF9R2
         bnvQ==
X-Forwarded-Encrypted: i=1; AL+hErEizyYKkM1B9IHLFEWoOVIt29cYmfsXP7YydQ1R9iJhR8+6E/v+eavFLedlzaHLoyMW57STUiRGJg==@kvack.org
X-Gm-Message-State: APuU4Z/rI9ie53rQ9c45tkwd7rs64vhys9IaQSQuzdmdV2peYtfpx+qS
	j7nYD0qgJSWXjXq93EO+OuDUGFtG5oZSHgq2DIZVG1XFzibTnM+kbTQ8
X-Gm-Gg: AZFdTZdlKd2CAkE9fQ3ctBefiK26RpnllNNrMBXKawlZ34m5+GnK0fvYtg7GIbFUfZx
	K2iW8u98mXDaKBQE5RG6M5c1ZFpGhZD7BjlgNs10rxpySnB5yEORJqPAxTMd1aixbuYMSiVcvB2
	b1jvYnT7Mir/pfi2YpMwK9qs6JxncMTycg+ANdSlOI7xslve7i9Hf5kfWxMn0mzSwfrnU5S2Qc/
	OJspucw1jZ1dbCyEwzs0KbdmScUe/G0sStsT0CNA9Q9CEePn4jr26eywsdeoa9APlpF2oASQ//e
	4FCNbON35oe9HRCafrrzUpWLyv5USxQAmHg08/T1yOxzSXUvt2KNYuLUimfzBtVIyzlcFnk4mD1
	flbXD4yj2CNqZoq9wpXHCCnijVKpbKBkJXSfbG1MnJPlSQjz7SbGeeNsvLcmCqGflvkETtO5Znq
	pmaIO53w3TSxjqTNf8odWuSU4pYTzjgVKPNMH1zfPPHIMBThi0e2kQiSlBz9dWzJtMcCRqriaJq
	E+5SclxrHgRsWcnjg3KA//51g3HbjYc6XxGvKx7LEUfp+gon8092kc6+hpqVx8prElDjKoGZ8O9
	Ej+9reTZhwwnMWLljarsnrs1ha/qsYi/HSkbOUlT5xd4K+RTIwLOMLbWEg==
X-Received: by 2002:a17:902:ec8a:b0:2ef:e25e:e13c with SMTP id d9443c01a7336-2f03efb015amr114577535ad.5.1795417059794;
        Sun, 22 Nov 2026 22:57:39 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1215d7sm46393385ad.65.2026.11.22.22.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 22:57:38 -0800 (PST)
Message-ID: <4eb6d496-4100-42db-8322-2b8f7f4ee36d@gmail.com>
Date: Mon, 23 Nov 2026 14:57:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: factor out common softleaf offset PTE batch
 scanning
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
 <20261120032949.2036731-2-chenwandun1@gmail.com> <awBnU0jVXCS2hj1S@gremlin>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <awBnU0jVXCS2hj1S@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4DE8640005
X-Stat-Signature: 19fx78tu5q38eriqea5ysntcshcdghf3
X-HE-Tag: 1795417061-421413
X-HE-Meta: U2FsdGVkX195z34ExiTGNxGCVOE7RjqY+ikuMePfl6gBOwr3pJ+bOIAjctQX10tEZ3UFr2VLl7AhT7LCFZ2zaEl0jMAYyqVyD/F609cMRTmN5WhifWc5hPJohMSkqIjxgLMsNtAYDsNMZnB+gk1nW2FwXs3M2G8fHv+DE3ZO0UjG60BIc5qtuCo6A9K3jMt/v0yB1gOuX9HObne3qvCHuOvnV0YSdXZSQ1/mSecITAhdfWP1QP5O2taryaquoZdlXuLA3GZWhJALQ8woldhda6CLWJRAqmEa5yPSVdE0pkMranz9ucvUCPGN3dWHNUcWbAQBEHBOyF/Y6X6e5pY0qdxqpcwSNs6GawLMP4xhMLeFlgJd1vw59zsEl2V5doizHp0gfTJxbKKC/hY7hQ84D0RfoD8uOORAzMtg0y6EDzjBU5KFK/xXq8gG94ENNJnbafwHr/VMoNHbbvxTiB8F3hDMdLPjw3g+0m1BYPJOVo5jK7rdmX1CDSY1z8rosXvlpxE9wPq2MYztmNPlHnYw6z4GWe6K20mHGpEwfiLmFkN2oAcWqKdIcBCpA5I006b1grrt+oEmpM01E65mgLkNK+jj39XwYKr+mX7Zn/3G+TPrjHLA6/Efi1a2cpuvdzQ3q7spgudRRdhJA0oTL65mZgc3y0QmB5GqhAz8EZmDaNJG/35MF7PO+WwjLATsG9uIoS9/eq7tQQkYNUAergYYTGWoE73LijHM/2G6qjEr/8pL2m4JMoNrJvZrQ5udXKPqgYdBt1W+H22pKWlXRCsgICXWuHgk/WVV7kG/gUaUmjC4TRxJWVBC+gu8TZijjPiJqIBJB4EMSomkCOtG0jI849iGexw1+6LEBWuT5OCT/5GQa5qxDsErIAIGzIESsLPGRCez/Fl+4fk/4osEf8DzzTp9nOZ0AoR/nZDRDEqHEBEa22sIwWDKJ0X8RhgbeT6lFNnMz0Xd0ib4QaTyXNA
 dRafvuj5
 hNss8z1T87MWSUHE894csQbLaTchUo9GKNtW/wxhfhzy9bTmhUSNnVfVgwbB5NAPNoStYSJdg/vaKa6xjKAtZRP6YYaySunm8/WK25FgW9DQS2uZTaColKL7v7O34TJiCalmHvKMJaK6HjhZot1L1KDuAsuCWJC/CHLBIehM5Fqcuvo1d8tQTlbO8BcvoQrEmn0+etd4T2pspmMUfkXPnyvXhZ9VxWzwdkbnUsrMCJsjDbapjlyuv6XT9F/zQnsCgwop7f9dgqCw4sawgESAXttysSkwAaKu0hMOX5fbZ7c+ckTKd5BaS86ssRdVPCkiXdV0dt0BwOmWlDxnaZwjI/jOaMDzYkQD1A6yCAdHBjdebJ4BjJaxICtdr42JTUSouPif5pYZinXuc6/DWDwsKStdl95pUZcXze3SymUqQ9OCiywXPLEuzOUR8MZY37bXMLyayKLKAmanQym2HrI2c7J8cb6zFupZ30hNzCa5mfBbDQEBRT+XaKlzseqrqPKvZwJeLw2c7ylsqFls4r8caAvNMn6Dl6apqwj/F57ek/sgtHjmFaW4dUdvToObf30jJWJTGEcywgKk6MT18WP6yK4UWjJ5sK0ZdXId5eZyznOYt6bFwmeUPNfDQLEt8mBgw8t0Jd0h0M6Pj/nrEXQymYiPHAQ/YxV2X317OsssUL3k8UFIENxMQH717nrwg0xG3FS22zHuPDd3oneVr7dS2tYwx82KkQqdYtZ9bBZpy3WC7PfxLgeMdcxbGCLlBikNHyvcSdsy4AFsq2yikR0xB6mUryBhNImWDqDBn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 23:34, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 20, 2026 at 11:29:47AM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> Extract the consecutive-offset scan from swap_pte_batch() into
>> __softleaf_pte_batch() to prepare for migration PTE batching in a
>> subsequent patch.
>>
>> No functional change.
>>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> ---
>>  mm/internal.h | 22 ++++++++++++++--------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 3a1643afedc0..9f78c12882cb 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -512,29 +512,26 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
>>  }
>>
>>  /**
>> - * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
>> + * __softleaf_pte_batch - detect a PTE batch for contiguous softleaf entries
>>   * @start_ptep: Page table pointer for the first entry.
>>   * @max_nr: The maximum number of table entries to consider.
>>   * @pte: Page table entry for the first entry.
>>   *
>> - * Detect a batch of contiguous swap entries: consecutive (non-present) PTEs
>> - * containing swap entries all with consecutive offsets and targeting the same
>> - * swap type, all with matching swp pte bits.
>> + * Detect a batch of contiguous swap or migration entries: consecutive
> 
> You mean softleaf entries?

Yes.

> 
>> + * (non-present) PTEs with consecutive offsets/PFNs and the same entry type,
>> + * all with matching swp pte bits.
> 
> Maybe 'softleaf bits'? Ah I wish I finished the softleaf conversion properly :P

Yes, that would be more appropriate, both will update in next version.

> 
>>   *
>>   * max_nr must be at least one and must be limited by the caller so scanning
>>   * cannot exceed a single page table.
>>   *
>>   * Return: the number of table entries in the batch.
>>   */
>> -static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>> +static inline int __softleaf_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>  {
>>  	pte_t expected_pte = pte_next_swp_offset(pte);
>>  	const pte_t *end_ptep = start_ptep + max_nr;
>>  	pte_t *ptep = start_ptep + 1;
>>
>> -	VM_WARN_ON(max_nr < 1);
>> -	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
>> -
>>  	while (ptep < end_ptep) {
>>  		pte = ptep_get(ptep);
>>
>> @@ -546,6 +543,15 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>>
>>  	return ptep - start_ptep;
>>  }
>> +
>> +static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>> +{
>> +	VM_WARN_ON(max_nr < 1);
> 
> I wonder if max_nr should be nr. Or is it a maximum range to examine I guess?

It is a maxinum range to examine.

> 
>> +	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
> 
> Since you're getting a softleaf_t here...
> 
>> +
>> +	return __softleaf_pte_batch(start_ptep, max_nr, pte);
> 
> ...Does the batching need the full PTE or can you just pass the entry?

The batching need the full PTE.

For example, two swap PTEs with consecutive offsets but different UFFD
flags must end up in separate batches, otherwise, some PTE flags would
be lost.


Thanks,
Wandun

> 
>> +}
>> +
>>  #endif /* CONFIG_MMU */
>>
>>  void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
>> --
>> 2.43.0
>>
> 
> --
> Cheers, Lorenzo


