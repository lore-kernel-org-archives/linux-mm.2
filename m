Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A9A1CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C415B8E000E; Wed,  5 Nov 2025 09:21:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1598E0003; Wed,  5 Nov 2025 09:21:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE12D8E000E; Wed,  5 Nov 2025 09:21:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97A3E8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:21:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36A12886E3
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:21:26 +0000 (UTC)
X-FDA: 84076766172.14.92FF1FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 51FA3100018
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:21:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PMVDDg6Y;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762352484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJXA9Vsg/Vef0RGpPu+bhWkC3ge0cfRJ+glIvliLJr8=;
	b=fYyox60aswsf7IWcsROajcVMTUjDugywWi39y1ld6S3oO+xeDlQvQI7ljDc52GNKx+48ug
	oodNrTDQB5f2va4+KgB1E0h6T5cUC9XohU1scdDZ/nl+oMf7HWXZXG4A0CSFz2949t5mn/
	1G/ax2ATbURkuS3qZ+PhGiDToh46Hds=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PMVDDg6Y;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762352484; a=rsa-sha256;
	cv=none;
	b=y0+DYkb81xP54M9LqHOcpHl1jK5tbsP5P5ym3Lwfv4V27Ifpc/Fb3BlMMiOUGmNQnGJA6k
	M0zGn9rvwX6ze9HErUUGD3e5EU2MiFhDSXodUDnXvzSygdmep4eGzDwCQaneWpCySnxGFk
	h1+PgQOdeUG4ukmrOx//EBuCmH1djx0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37623446A5;
	Wed,  5 Nov 2025 14:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54263C4CEF5;
	Wed,  5 Nov 2025 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762352483;
	bh=KDZATPE9X1vCi/Nk0hVLycBqSpHsTQBD3TNCN9EBGvs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PMVDDg6Yo0t9IjFgm+3etBRD3hShAzZ9ImdsaRXGGOvEvjYmA6Nozb10N0c5kZcAe
	 mnkdv70xnmcmKC/RqRSkW0SqYq5TSHISco8uy0uAX8TUPzIT1Ih/Ize61KenaBCkwE
	 azc9KHtUkxkzSu4ibpfRFAFXUe9tnO8AyZppkCJY1kxEGb9iU/GdLTsK2Elwrr7Zr9
	 9Njk6NccBQtvPdDUqoQ0ZJbz9VdLad6ogrzujuSLQ4lam4sA7IR6yy6idCbWRHsfCV
	 i66ttLJBjKY9iIAveH3CtdGHE987+oH08DpPjCPDCmUh/OWJoPA8kXbC2BGe9rKdBQ
	 evLb1C6Sj+TiQ==
Message-ID: <c6e5aa34-25ab-44f9-b6dc-127f3084adc8@kernel.org>
Date: Wed, 5 Nov 2025 15:21:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] Revert "mm/ksm: convert break_ksm() from
 walk_page_range_vma() to folio_walk"
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
 <20251031174625.127417-2-pedrodemargomes@gmail.com>
 <a6574561-02bc-4ba6-9fb4-418dcb07cd5f@kernel.org>
 <42byvvz55omaszu6ep3g7n2dj5z7mfxy5h3zbc3xjdnslemkpp@kvdzrjz423mb>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <42byvvz55omaszu6ep3g7n2dj5z7mfxy5h3zbc3xjdnslemkpp@kvdzrjz423mb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 51FA3100018
X-Stat-Signature: 4pk1b34b5aswpbr1817r99yfi1xr71tk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762352484-462614
X-HE-Meta: U2FsdGVkX1//oInwuXxPZL74TE4uzkgUa3AblMxXpR0WxQBLTuvwHRmmcTfARhYj8o1Md/Y+sBaNdg5/YZ0C8c/K3u3MdAvg/M8CC/+e2QsPwojjcyzHsPq/hIunQy6PSAKaRNkFBHHYgkTK5LwSbxPPFsRwHOnPb3BOXTqy+P86EaNZcwZtRhtWlFVL1OKs+TpBuPXprfRs0cCulH9Qd7YGbAqQB3V8cnBE6ytTaw/0idm8MH0wI4/GnDCqWxWWGwq4aSB+c4xQDSE2NkNgPeDJCQAf/ZUdrq8TXxV11FBpR263djfhLNTeAFfDuMS/DUrX7JaCLdnk6O9WG8/oNXfDLddEDoBxGDOuDiiImoSdNEJ1nwymCRHdV3knG1tN5FGDHlPR66sR0gapeqH9Hb92Fht50fogInLNA8mL/dtuf3DhdSTzlXutcv6rBdBsPvutHd9SFfTfk41tiz23FCnSnTNltzgnbG26QyYgoU3DZrs/t/h7dxKDH/4FnSoUOfem0NOz/UWsRZZn0UesjsiIuqKEcBTcoaTSSqnm6frotnWYUYdBPestZGS6JqigAo9v+sGUnsFlPkO9BlpZyBLCIUzuhc5pwdS+GP6dN+EP91xflSRoZPPlW2GkHVYvT7288NQawXD+kX2MD9XGdAw986Hp2Vn9nJ2U0IvniKrPAfd/fDYajachjsE8mBzCaWfa+zhzczwIvtSA4GUlLBAXFLwDjlCfQktuCkuNQRJxLjzkUfGCmnt6ct1prbMTIPdb9Qhg5PumUZXDl5ThM92tx6vNa+IqmChblOKqKCsvjfI1PUBMTRK3SsZwn4HWWE66CME47dn0QDpAEXSjvgGxi+DRG4agk2oEyKwtxcoXS9MOMhya/290j1x+JSAjEtEJDr6ALIN9CgMrdRUsgWcJdk19HNr0iceKQQzhSiv7TLyLvUD+kI9jDylsPGxDfzEYI74U4T+QnpRtFEU
 Y/Z8Nicv
 WN5vPCTtl0OVgjV1t0hy1emy7MRCX6gtPNbiTagzjwZ4mUUAOPP+zZ+sOuWx8YZSS48ybjFgtXsUWsfZ3cPvYXTDSlJCVbisZkEI4oQSFW44wE1yD+trGHOjwhG2pEH1NWL34cqXtxb+bg8LEZMmACiVOC/rrzkRx54upULuYWlTIXfff47fnB1rmgiOhxSSFlFL93GmB+F3VqlIZDvMZ77QjSgJODtVKVh3eiCva8UX3+3GTvTTyuQ79Q6YQLr4Gqzpo1R4TQabmLKr00PNK38wlyjN98SomaG7uKHGgoGV/twRvhfboIgbb4AQ/FenD4+eZcVC6r1ga0jjetmHOZYtoOAviabp0AOHP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 14:28, Pedro Demarchi Gomes wrote:
> On Mon, Nov 03, 2025 at 06:00:08PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 31.10.25 18:46, Pedro Demarchi Gomes wrote:
>>> This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
>>> function break_ksm_pmd_entry() to use folios.
>>>
>>> This reverts break_ksm() to use walk_page_range_vma() instead of
>>> folio_walk_start().
>>> This will make it easier to later modify break_ksm() to perform a proper
>>> range walk.
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
>>> ---
>>>    mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
>>>    1 file changed, 47 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>> index 4f672f4f2140..922d2936e206 100644
>>> --- a/mm/ksm.c
>>> +++ b/mm/ksm.c
>>> @@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
>>>    	return atomic_read(&mm->mm_users) == 0;
>>>    }
>>> +static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
>>> +			struct mm_walk *walk)
>>> +{
>>> +	struct folio *folio = NULL;
>>> +	spinlock_t *ptl;
>>> +	pte_t *pte;
>>> +	pte_t ptent;
>>> +	int ret;
>>> +
>>> +	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
>>> +	if (!pte)
>>> +		return 0;
>>> +	ptent = ptep_get(pte);
>>> +	if (pte_present(ptent)) {
>>> +		folio = vm_normal_folio(walk->vma, addr, ptent);
>>> +	} else if (!pte_none(ptent)) {
>>> +		swp_entry_t entry = pte_to_swp_entry(ptent);
>>> +
>>> +		/*
>>> +		 * As KSM pages remain KSM pages until freed, no need to wait
>>> +		 * here for migration to end.
>>> +		 */
>>> +		if (is_migration_entry(entry))
>>> +			folio = pfn_swap_entry_folio(entry);
>>> +	}
>>> +	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
>>> +	ret = (folio && folio_test_ksm(folio)) || is_ksm_zero_pte(ptent);
>>
>> Staring again, we should really call is_ksm_zero_pte() only if we know the
>> folio is present.
>>
>> It's not super dangerous in the old code (because we would only look at
>> present an migration entries), but now you are making it possible to call it
>> on even more non-present ptes.
>>
> 
> IIUC vm_normal_folio will return NULL in the case of a ksm zero pte, so
> we can not do
> 	found = folio && (folio_test_ksm(folio) || is_ksm_zero_pte(pte))
> because it will always be false for a ksm zero pte.
> So we should do
> 	found = (folio && folio_test_ksm(folio)) || (pte_present(ptent)
> 		&& is_ksm_zero_pte(ptent));
> since if the pte is present and is a zero pte we can guarantee that
> the folio is present.

Yes exactly.


-- 
Cheers

David

