Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE580606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqJ88WTF
Received: by kanga.kvack.org (Postfix)
	id 0A67B6B05B3; Thu, 12 Nov 2026 04:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057266B05BD; Thu, 12 Nov 2026 04:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61CA6B05BE; Thu, 12 Nov 2026 04:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB2F26B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:01:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EF8AA808D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:12 +0000 (UTC)
X-FDA: 85425872784.22.F13D0D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84F1A10000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqJ88WTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qciPwLaBZFP6o7YxCmllxM7jttEflMmVhO8zxQVZp0I=;
	b=DnVVa9mW45oBD4rQgAMfpKbCp6GNKh3Va+dykNh5oCgVGMlVczHsMsLUN8CZdvbVq6Os0m
	hRUHrxCQRrwfIMMnBWqJUi2z3YHH1h6GZBgNR6WsNqt9JKqD4bTEMXwjEZflMbzBnaA4p2
	QXpMrHa2EQI3eMIDFTYpcuomipT04Zc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474070;
	b=Ei3N5d4Q+3MdJCglUFC7UvCjEckvMrLCNmM0RwDlZ704m7J2pOFGIe7bj5IBu6bhXin57V
	prRbfoD86RDHcT24v/bf7Nlvc6okjjGS9N9/uygJWB4If7IaPEhdXO8bYhzmSUorqSboPN
	Vi9C6N+LnO9i1PB86B5wadRmvKcp4Yc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqJ88WTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01D5A601CF;
	Thu, 12 Nov 2026 09:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DADD1F00A05;
	Thu, 12 Nov 2026 09:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794474069;
	bh=qciPwLaBZFP6o7YxCmllxM7jttEflMmVhO8zxQVZp0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eqJ88WTFS/snVoxu58sVmq8uHDu4I1OkqM4vdWANTNKIIfmJ1w9MYYdR5HV8jJcZH
	 awsHKGx8ThOvURM6nxnrnHV1waU8nBFTufG1MQgkjzhaswCWgtLDy1DTkNFm1APez6
	 YdGKg5ohl5wbpwSAhPTVn16WRnYJcpu+zlmt/RCLWUyHmrbmtN+q1BIWJ9zmKRmPve
	 +BAGtRBaDKPyAa2bDbG4wPHi8H9u8uE+tyrm+xvYdnDwBD+QFa0hRPnBC8v6qQpdo+
	 JUAU3QMzAwXA4wz0gIWW4+cYjfb1iQR/S+6XQKUvmIg8xOJVgPy5r/mNZqrALRZppw
	 T4X7xZAwEYhVg==
Message-ID: <d74a277f-f14c-436d-868f-2566d90bc144@kernel.org>
Date: Thu, 12 Nov 2026 09:56:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: don't PTE-batch a swap-in over a
 hardware-poisoned subpage
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-2-usama.arif@linux.dev> <avRqaatdOUunxrcZ@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avRqaatdOUunxrcZ@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z4spnbtts5iwgtr9gwx6s1ufmq8dmepi
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84F1A10000D
X-HE-Tag: 1794474070-69575
X-HE-Meta: U2FsdGVkX18Wg8EZdcywX25YXJgKWIFrt5eT3sl7SOXBZsdTgNRhy3mfCC13PCNKCQGrKzoBw94hzrF7Ox4aXTXSttSJhIARA9ffaIbz3dCo9bKD4KU0/dvDPkaYDzlm+0LJ/PM3VeW8yVWvbKrJMIsvuXi2/ZxHmjidYDrJytY6Doqw/ixERzeAn4Pj9bwOrLtoJivFegqKj6e0oOL7RvG4ZFbPgyu2mpYjslFcfBG2XzgZJhBuad/l8vgmvWIIyg8AAEB5BjokmV8lZkCQJm+TefjHxtTSPyxhkMpSJB52KM9ThZjN8l4XAoh+OC3cLXO33vB6X3j8EIk9ZpIGs6I1xMOFDBINk9YItLO+xM08zyMxxaAUUYVQXvYtcpn7azXZhLABt0+2U1V6NQxtW1Rv/9589+4HsW8D0vmSxRP0yUg6v7+X3TtiWhNgIiaUHnCE784qlBC4UkPG+nXrFqrb60frUtUE8igW+1RLbsBPnbetNFbzgW52GaJOA79vXP9cUq+eCZ9Fm367X0OBeZG5dN4+XWLktlfy6N4RL6l4l9qGErAW8btzXIWvWGRXs2m8KoaZNMHVck49yOrB358rNNqtM3IrA/qiJO50IkBgYL0RxyjSp8Z9+VfZMKTXsj1vcLUfCfRvOtaEcpO6N/qPLpLHQmf4yKbyVPjGgkRq11je+d79dtmWiGYyVyFNnNvgqoJ0eS4dGLNlxciacqMvFxQQvnd5RHrMjdEnqi9l3B9BfWt1oTPs6YH1khoWuIt2PdF9dOqP3LNu0SIk/5IJtWd6ZduvWA/QC5nyR8eL8cSyJHQj23VW1JR4dyb+1aalLvXod7B1KpaBn4riK8ZVgZPFLnfCiKL9QKP4olICj+/hJUf5FOkViQUOwOrH2V+l0+LGCa6DyqqYDUAdPtoVQyj+mIzPLPvJ9T74qclArX7TJNJxKz/8hT0SnfYxp6mlHXobQHeErNiwmuC
 drQNlimm
 +ru6CaoZLbJeeIEjWlBvE2ASfUtcyLM4PWXZgA2cc97ar9uHsQYXO/5IUbpCssXkSxPqF8vCvjFixxWwNw1yzkqHGOFPC2p8IJLMaseZqwsy72bwdiXwcoGVWMVdDRqLXTpYRTpJ0F5q3/nId0SgF+D66uebrQqKv1yTWmY2nORA5NnpnWxIagmCgb9gVjk0zXByf1YVcrK7bD9YFS6DBGYXo5WWvZFWa22kNvSKrJUJbY/cyiNpUxum7Q/YR4S/ZOna8ftbqR8z4vNXVPWZs3wL44BsAXA2KkiZBGNcg7BUSsewfQhSxwUKno2fpJSr4HypIfCSyjo25iee4NE4yAISG8xw+nE3mydm0L9/rfPh+gHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 14:18, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 03:38:29AM -0800, Usama Arif wrote:
>> do_swap_page() checks PageHWPoison() on the faulting page, but the
>> large-folio batching path then maps the rest of the folio without looking
>> at the other subpages. A poisoned subpage that is not the one being
>> faulted gets mapped anyway, and the fault that would have reported it
>> never happens.
>>
>> Skip batching for such a folio and let each page take its own fault,
>> where the existing check catches it.
>>
>> Scan the subpages rather than testing the folio-level PG_has_hwpoisoned:
>> memory_failure() sets PageHWPoison() on the subpage first and only sets
>> the folio flag much later, and the bail-outs in between - for example
>> get_hwpoison_page() losing a page lifecycle race - return with the
>> subpage marked and the folio flag never set.
>>
>> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/internal.h | 15 +++++++++++++++
>>  mm/memory.c   |  4 ++++
>>  2 files changed, 19 insertions(+)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index cd3675c044e0a..e61c02f4019b0 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -28,6 +28,21 @@ struct folio_batch;
>>  int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
>>  		void *buf, int len, unsigned int gup_flags);
>>
>> +/*
>> + * Check every page of the folio for HWPoison, rather than relying on the
>> + * folio-level PG_has_hwpoisoned, which memory_failure() can leave clear.
>> + */
>> +static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
>> +{
>> +	long nr = folio_nr_pages(folio);
>> +	long i;
>> +
>> +	for (i = 0; i < nr; i++)
>> +		if (PageHWPoison(folio_page(folio, i)))
>> +			return true;
>> +	return false;
>> +}
>> +
>>  /* mm/workingset.c */
>>  bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>>  			    bool flush);
>> diff --git a/mm/memory.c b/mm/memory.c
>> index d477a4f986bc8..4b7d456332200 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5158,6 +5158,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
>>  			goto check_folio;
>>
>> +		/* Let a poisoned subpage take its own fault. */
>> +		if (folio_has_any_hwpoisoned_page(folio))
>> +			goto check_folio;
>> +
> 
> Hm, isn't scanning every single page in the folio potentially quite costly
> here?  I thought the point of batching was to improve performance overall?

Yeah, we don't really want another helper to check for hwpoison.

If we race with concurrent hwpoison, bad luck. The slapped on memory-failure
code is full of races. That needs a proper long-term solution, not more pain to
core-mm.

So let's please try reusing existing helpers that test the large-folio bit.

-- 
Cheers,

David

