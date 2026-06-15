Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7BB9CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299E56B008C; Mon, 15 Jun 2026 07:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2236F6B009D; Mon, 15 Jun 2026 07:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112426B00A1; Mon, 15 Jun 2026 07:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0F8B6B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:58:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B38751409F2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:58:22 +0000 (UTC)
X-FDA: 84881999244.28.75BADEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E16A9180006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:58:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=luqAq5Ws;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524700;
	b=dacZmE8VgB3+o7zHiecOlDgAcnqXotNJD4Or49Jv4aYkS3QA5V1bgoSyZwufcgc9itZnwh
	O9jbnrFO7lRV6dHFg37l7KU6UEekNYkytYFKe2o9tjoE2+FEy4LyVoHieJxOyFZPLlN7r7
	kgB60OCy98gQf66E5fnWSDL3zKkCfZM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=luqAq5Ws;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nob7Ef0LhlOFzeo/NONUfcSw5/BZ0C2rsatl1k+CwG0=;
	b=GJi+UvfodQxbFqo1nd+kJRci00ZMSAVQjmrtHHaqLFhwmfv2LNgK8bfQBB6pUlMCkSkwqP
	CKZFtF0VtgGKYn3Z15CmQgmI34SaRc0WabY2IHtZ2OnEyTT0Dn3kTxsY6vxv7gX9IvuMth
	CS4S8PieqwskZsqBFACNeIehKzgkhms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E692600AB;
	Mon, 15 Jun 2026 11:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C3B1F000E9;
	Mon, 15 Jun 2026 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524700;
	bh=nob7Ef0LhlOFzeo/NONUfcSw5/BZ0C2rsatl1k+CwG0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=luqAq5Ws195uyaNNIqx+TtXLqYwS693yXltM2TcKwMEPE9xcEJ9gXkebKd6da5RvT
	 aAetj7reft8CUSF4tJAD9LUsRfwVv1o2iMAeKI/D7fY+9cxkdZ8RXhupWE6A+X0sNy
	 70pSyWH+eg6GmOqPpzWKo59VOZ0tk8aIB7nMONpv10msu/A1w2CjvA7BTKHvlLk6N6
	 dnfzbUvRsGafRRh5PlQymk0GdV65M+uNECKCD6FD5LatW1RC9OMb1pD8sOcqeir4Tx
	 8O8slBqcLy7jGqX7aUP7Xe7pJfZyrQqbfh1MxNrMTin+UGI3DGmGdHLxFhBTsdAGKT
	 O/UMy/Lz0NpJw==
Message-ID: <2d48ef0d-1110-4a9d-adcb-f701a1ce2cfa@kernel.org>
Date: Mon, 15 Jun 2026 13:58:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>, akpm@linux-foundation.org,
 ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, sj@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 stable@vger.kernel.org
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
 <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
 <20260512143542.izpp3gu4iqxttw3f@master>
 <113dddc5-27e3-4e9e-a90c-f076a4629f51@kernel.org>
 <20260612024840.qdw76serbgj67yrv@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260612024840.qdw76serbgj67yrv@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E16A9180006
X-Stat-Signature: yay1qiannpdgm6a53meaztj5a3znqdpz
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781524700-503075
X-HE-Meta: U2FsdGVkX1/b0NE4twwKfUdKA2xNljxSShZN84+ec7wBFEj6BDduwxmNwJqSBZNo0WMOzzyOGFMOBnjkaHqYl510dXslGUwjl7we/zRKqoTlsWFZgJnQkyVNXtcXmOm7UHP/s+2TQW3WznsZGJlNQREHrG7hjzucJtCzo5aXXZ6F768uk5iu2USkfc9iLX0fD+p7ABlEPW0bg1z/5cIpiFLLfkVrA0MhAPVQY9s0zjxJPmtCR0xfqK/+THQwkJin9PpNUP/0bxcxqNxde1D4ZwXm0Msxnr3agYwdsdLU+tiOpOOx5bt+wgJ7X1THgqS9qX+VycYCeEj74fee0thUk7EJ2Kdf4ddu/T9GrclSA5xa9qUfqeNPzN/A59VpKgTi54kdPLV+g6rOhnuU4ctXbaUZTaFOrkqDFcR6GvPm6u+XlTRYN8wO0kvHJa3G+JgKdK6AVEBcLZpgjQEsius/NGe2e1DQMsX862g0rvPGXyFi9p4GkFHq2td5sbjW0fhvhBm/RLLtNkHJCRvkShPdZsiCpkCx+AiGeaySNZTz0Fqn4oCQAJ5FxEgrbNy/jE6QJdTNgc7WkvqsTCDoTz1koEff3ak1HgZdfnkE5XMBqk8quXbemqX8gKb7MWCIzokQkvuEMz7ZCOr2eiSCRRcLywsBnF7iOxBiyGQETybPaQt4Qce4R1UeoMYZfITWJMPbnMcMLw8mECb0cAx2QTmMinCnsp1J8cn4Om8V3zmWlh0iUhcCdFmQE67V0iaycZr2f4LvIvtcivvCGQhfJyyO3SD22RlrC9U9LDarGJk6XHhMJuFD048VHxodNA7XKEDzB/9Uy96LP+Ro8fkWeE2Q8BocSFMIIzS5J3CphfFsOcQcmAZ+cjaSyQY+zwOCAmQ8fYle1+nCkhbmhViM7C1LbrVW5/EOd8KOM0dHW9b/WQKoLbbtUMTMUHuYNiDezSdowtf0TjTnUf7b+bKioWL
 v3i/vhEb
 CYYfkSGBPvJ1Qg9/YapQJ+xBtURDWT7lYVRsOu/uFdjp+/HadkNwcR6G3+3i4z+5/DXnYPdXdrUFY44bSC84yrxJq31L+/98m4E/dylrG7lnqvMcsWeh59xrfqkiOqcD0JCyYqnP38rH3SkFKUACAzBN11wuT1B4aeFmFAF7W0v5/fY8h21RqNhsq31/oia/f2S50DmCG9bO+Ijd3PK7RAI/2IcSMy4uyangTlvE/GTcxIpkqE8GJy2HsE4R8pP+S5vbVZxi8ZQA0YnAboZKA2H3tTdaHWPVTwFJpt1sFCSxd66QShGMn+ktHU/elTp1Kt+TRzerVtlRitSLeBYb4RdOV4SQ3tB0xoGg1iiiDHTnECavQiqJHl1uAfYJUrq/Ktr42
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 04:48, Wei Yang wrote:
> On Tue, May 12, 2026 at 08:55:47PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/12/26 16:35, Wei Yang wrote:
>>>
>>> I tried to compress above logic like this, hope it could look cleaner.
>>>
>>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>>> 		unsigned long pfn;
>>> 		bool is_migration = pmd_is_migration_entry(pmde);
>>> 		bool for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>>>
>>> 		if (is_migration != for_migration)
>>> 			return not_found(pvmw);
>>>
>>> 		if (pmd_trans_huge(pmde))
>>> 			pfn = pmd_pfn(pmde);
>>> 		else
>>> 			pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
>>>
>>> 		if (!check_pmd(pfn, pvmw))
>>> 			return not_found(pvmw);
>>> 	} else if (!pmd_present(pmde)) {
>>
>> It's more compact, but not necessarily cleaner. In particular, I detest
>> pmd_trans_huge(), we should phase it out.
>>
>> if (pmd_present(pmde) && !pmd_leaf(pmde)) {
>> 	goto pte_table;
>> } else if (pmd_present(pmde) || pmd_is_valid_softleaf(pmde))
>>
>> ...
>>
>> Might work as well. But once we add support for other softleaf types, we'll have
>> to touch it again. So I'd rather just list what we actually expect.
>>
> 
> Hi, David

Hi,

> 
> I may not follow you. Just want to confirm whether you prefer this goes as a
> fix first, or you prefer it goes as what you suggested here as a cleanup?

I guess we should just do it properly when we're touching the code already.

Does that answer your question? Will you send a proper patch?

-- 
Cheers,

David

