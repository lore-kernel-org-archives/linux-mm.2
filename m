Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5494CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C176B0088; Mon,  5 Oct 2026 08:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC946B008C; Mon,  5 Oct 2026 08:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACC86B0092; Mon,  5 Oct 2026 08:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4757E6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:10:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE5D940232
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:10:41 +0000 (UTC)
X-FDA: 85288455882.25.D9EFD5D
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf17.hostedemail.com (Postfix) with ESMTP id 852BA40005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:10:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qc4uRKrd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202240;
	b=pVQLlONBC0obvzwXZq4dLxGbBF9b7X8fzwdQJzvHz5p18yakwiZI2Loeirjq4y0BXJwg7Y
	7yiVkPw/tWwhRT7ArewGiwgFEcjrBxblVEbn4pNInX76kzBVGLPBwdXipTAfNatgGdlGll
	hUtv7dmn3Boh1RbmqoQX5ndzbYydMvE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qc4uRKrd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNIZcxXT6r5wej2lIv3KVpzpQUzRHt7gkUpZ/IoU0R8=;
	b=ealPNJLlfZ9FPn26PF0XzFSml6eWJid+PFONm5Xa6hJp36yaeNa39Ji/phVkYhdYBCtLao
	DD/12ZIxJv5PuuxfG/mK8agzTs6psMuYYlLziWUPfGyS87M/cSjvs9xLo0fPD7j9OhA/SA
	hz2QDep3M1x+brJEcerpyto/3Rz4Q34=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f+hFXIzzuMe3tcXs0GPJ00JVOEjMIu0ORPYVIQIfNH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791202237; v=1; x=1791807037;
 b=qc4uRKrdD6qeP5GjqsjJ4Cz/Rrj6iackxl9sFUoPmCvOaYE8EX8Hbl6TnvA+elrpiXZPs0Du
 GJRdmcMJ+6fTBQ47KSYs4kVRaEXBale69wybiJ6i3YGqbb45Hmy9hpcsA559USq/HiU1/NaGSUH
 19T5pTfp6wE6ki5goZxoBEDg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b52a094f8f923b80;
	Mon, 05 Oct 2026 12:10:37 +0000
X-Mizu-Trace-ID: b52a094f8f923b80
X-Migadu-Flow: FLOW_OUT
Message-ID: <c07ede42-408a-4959-9ca5-bb94ff851b0f@linux.dev>
Date: Mon, 5 Oct 2026 20:10:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Pedro Falcato <pfalcato@suse.de>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
 andrew.cooper3@citrix.com, Manali.Shukla@amd.com, mingo@kernel.org,
 stable@vger.kernel.org, toshi.kani@hpe.com, david@kernel.org,
 mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <asN4wjUbDAIcrfA-@pedro-suse.tail5790ac.ts.net>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <asN4wjUbDAIcrfA-@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3dfjb9hpuhcpcup1k1hwm4up37qjx146
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 852BA40005
X-HE-Tag: 1791202239-9512
X-HE-Meta: U2FsdGVkX1/FU+MLMYs1hAOZT3E/iNKzao6G+OxALqeHn/sm1YbCUn0gerGf8dM2RQpjjCcViavtQHgItv8HvqlJSn6sXAU2UuYjslBLEVPSjZRtYVMo1i4hyJYAPyBjCb3WKoVCpuqvco5kAhx3/6vhi5I/kjz9wBeKh6DC+qSQ1Z9a5Y9UctMj9Xzg8n/lYo1BS6PeCBTiRvhun9yog5TFWJcKQkiMXV/BwCjFuphMGfPJCt6a20AHjOBMRKi3q8MqFtS/HOOW+kFVNRTRNQi7sP2yYrmi5rXMEo2YKPtAButEgdUFIrxaLol4oyr5bJJtvP4pOwo8jspoaZdtrhxOqlvpsbHMNmEwQOWIl2S/H/Uz6kHzMpcbzZLGRRIprptl7E+IBaeOCoC6JrgjhKxOg2UchUJbS+qwjevoO+eu0dmJyKcL8DDzwPx50sZDwPY/nxeS6tCBCnqEdmpXRC7nebm8YG/4UFF/5MgeVtW7bfnaqAJ8N4sQBbYOdsdGLNUtouR2WfA+HVt6pzq4ntoFtrs1M/GbcslR5B5JDcGixbaGaQ1iAosa7ABLbfmDduz53V67bzlAiJgl4PAByyR6UipQ5YRi1dhMEK10aUUPfD7L5TQq9qk9a4SlNF4URM9m/sdRRvl6RqZ38FhGrudPl5t85OliQXWYI7fUF71mBW/3ENf66V65hhaLLxiaNPbvgZWmi/aS4F+Am945nRvivwnNVYHKExvHUk+XLPQToY8R1EwAv5Nhr2EVH+/Inf7IeFQWOuI9gO8z8WG7+VgeWa+9Rsz8ZQKj2NUDHJtDsnViBCk0x5mlLf9HzMmYSMNYIMmNvTlX2PfC9ypxM0hFjEHBRLhUMLeWYXJ2tqjzB9ALpiimFLavh+Z8KjiBKhtHQ9qIADO9SNnFP1+n2CFcY3uXtItVz+ntQIciHT5YLcdjLwDmeH14fvUv595O9VJkvKhdSdOwJUZbovM
 QZ1XWlha
 4sn+4MWm58CCZ5NOPAKSz7NTqvNi4v9KJNF9JqKx0Fi0hbOkh1ppacBGMVoBaCZrL67Vkxn7MSlNfOkawMrvZnLwOZ2clAhw8l9c2YmpK5MNxurtycfFqhLM0S8KIcXAFgfP4jXl7TCrn//3LLmLt/u1PuYe1cIla/UMLmHJ7KXT/jGfEGr/5Mmr2IYeIP2VsI5HaVg/Xmhojg+hjCOID5ww/eoSNaT4iN2iMGojm9SWv0avJKB8GmOB9dxzkHE/WkCGJ/eN3eZwxd8Mqoe9fcGuPkM7/o12KEfvuxPcgbHFT+gq1vkI/I7k6uMaCa9nYoyvbB4dSQwOMZ+2q3RKSfpZiNKSnz9eDUkXF5DC5ZKsuiw3RNaA4hXo9Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 18:24, Pedro Falcato wrote:
> On Mon, Oct 05, 2026 at 03:29:22PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/10/5 14:09, Pedro Falcato wrote:
>>> On Mon, Oct 05, 2026 at 01:23:02PM +0800, Lance Yang wrote:
>>>> pud_free_pmd_page() uses a single-address invalidation to flush the
>>>> paging-structure caches before freeing the page tables. With AMD TCE
>>>> enabled, this only invalidates upper-level entries associated with the
>>>> target address. Cached PMD entries for other addresses in the PUD range can
>>>> still reference the PTE pages being freed.
>>>>
>>>> The AMD manual quoted in the commit enabling TCE says these instructions
>>>> remove
>>>>
>>>>     "only those upper-level entries that lead to the target PTE in the page
>>>>     table hierarchy, leaving unrelated upper-level entries intact."
>>>>
>>>> Even with all PTEs cleared, speculative page walks can cache present PMD
>>>> entries after the earlier TLB purge.
>>>>
>>>> Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
>>>> the single-address invalidation otherwise.
>>>>
>>>> Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>
>>> I'm not sure this is correct. The PUD is clear. We invalidate the TLB, which
>>> invalidates the translation caches for that walk. invlpg will notice the PUD
>>> isn't present. I don't see a case where it can ever not clear the rest
>>> of the translation caches for all leaves. And, in fact, by that point the CPU
>>> can (does?) probably formally treat the PUD as the leaf.
>>
>> IIUC, clearing the PUD in memory doesn't invalidate cached PMD entries by
>> itself. With TCE enabled, flushing one address only invalidates the entries
>> associated with that address ...
>>
>> (That's how I read the manual, but AMD folks, please correct me if I'm
>> missing something.)
>>
>> So couldn't other cached PMDs under the same PUD survive?
> 
> I don't read it as that. I read it as "flushing one address only invalidates
> the entries on that path". So, if you flush one address, you'll flush the
> whole translation cache for that range. And page table zapping agrees; if you
> follow the code from zap_pte_range() -> pte_free_tlb(), it will do a single flush
> for each PTE table (if the whole table is empty/non-present).

Let's wait for AMD folks to clarify whether a single-address flush is
sufficient :)

