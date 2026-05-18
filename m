Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E5EDCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DA26B0005; Mon, 18 May 2026 04:12:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7246B0092; Mon, 18 May 2026 04:12:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97EC86B0093; Mon, 18 May 2026 04:12:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83ACE6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:12:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 339D3120808
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:12:31 +0000 (UTC)
X-FDA: 84779823702.06.5CBD069
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70612C0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:12:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wk+mnhQR;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779091949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8US5g7HpJPOtKRU/LANp5xi4Uzulq5hB5YuARUN1Mw=;
	b=zh7bH2N7ZRaej/+gRG/SfKlExcROS9x1bg7hvAehTqlr50p2k7L9r6VNN4EIRN9xzL5D10
	YJx9m3yiJ+CQru01mKVKyecx5HLqhFci4Im2A4O5F6AAahnhHNJuDz8ZrX2/iQmY/DlXU3
	FC094zCW8c+5Jm7Y1T/lBJzYn+xPjO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779091949; a=rsa-sha256;
	cv=none;
	b=yz5xQBfRAMv7+DgJHi05qVwyMiTclo8EdDHiVGOWMOye9cpAALEZZdQZxc/VOsXPFvkkYa
	PW7R5W53YerbbKSAlic+P94s/w2nBFZ7KQeS22uqpbEsmaxcMkYC/YV+PgdpNvIbWPTEw6
	0YYbqlrA5V9rMgJGDJCH/RsL1B994Wk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wk+mnhQR;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD09860125;
	Mon, 18 May 2026 08:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D4FC2BCB7;
	Mon, 18 May 2026 08:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779091948;
	bh=34myPK7G/Gc629/p0zS4E42ttWmJWp1ecSfOah9mJYc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wk+mnhQR+OCm1hOe4tPd3Kv3gc82WTURWpQSNjNHgrzq13vCAsBdnFyoZrBuppIAm
	 V2oHCDRYnIWO8kHrNgKAhMGFv/8Ozo2cqagl19c7yChaKRN2ZlEdSFhGYESw9YfZsr
	 nQORpPiyAI/+q0kVEedeIWx8LLp1XGKFN5TItYNjyvhpKmgIZeTPJcp+6U+1GRyf2R
	 v31vs7S7QfGMDG+ITHno5beSouPGNYByRJkWONHkBGHDRlKA2xXlwG9bvshkIIKhAS
	 vrUf/ESMZB4PiL+a92b7obWWRjQjKc1MFy4gfq5rFIkOTs9fCLpUgHIb+1+9pUNV3y
	 oD1m4RSKoUk0w==
Message-ID: <97deec5f-d692-4580-8e8d-439c8d733e23@kernel.org>
Date: Mon, 18 May 2026 10:12:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] ksm: add vm_pgoff into ksm_rmap_item
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, ljs@kernel.org, hughd@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, michel@lespinasse.org
References: <20260516171513673dGPsqh62DnbliovuIDPAk@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260516171513673dGPsqh62DnbliovuIDPAk@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70612C0007
X-Rspam-User: 
X-Stat-Signature: eaeqbfriyjeg9qbnxqox7657rxbeb85d
X-HE-Tag: 1779091949-549546
X-HE-Meta: U2FsdGVkX19lelD9dmVN8ksVbzbXB1AVI0Jwco26Pfc9O1tTpkHlxajcV4FVPQFM/VM7McZmCYHx0Qzuj7NLyif37cBV2DPcyQFS3kLsGL7CD8w/C/27uoLVBIoOZfCoG3VfRs8hJqSMObCScW5fe8xFLc/QAut8iYpGTOE29csn+TPQ4q0dWvOeDFONdpnAq1y5cBOiPmAFJ5N1X4/ZbtQuLLJR11IpyJ15V4hpxaDxceRdDwAMhdbRtRd89uYQXwhNo66oKKUUgJC2POFgQDdSkzAUAzVVA6VFRLiX+IanK/HZwRfpQvEp5Y6r/BDzpVqRFqvases0oQzkq5O1EH5XsjMrclzMy7funjJyAuzOlmvg6Z0flRiJI51AseEqtBlvW9aqaN/JTcbmqdtNd2LD5ipgwitHAUfo7588K2DgIm6+gEHVbrCYAsIF3TC1M+IbN2VxP3smA+W8yQj3RzNhvz9uRG0yQka0hyqTreBr1trzd10R6aburQT+adLLvbUNlUCpPl/s+cR7x0yXEl7zqJ9hq+EpeqeX0L8bKk5C8Qej8WsVEsTlTsnQlZcca+oAN6WdgUyyxTiV1JjmTM7sCX3l7YqQcl43kvs58Fg4YFQi0xceK7ma2JecUGyhcHmNJbDQO+I8kV+UVrjxWClXCk6UkoCUYcwezzIKO6KqNqAskq0N2dEOP+QgpGtHjbHC0fbHJ51ZrYPXSfIt2kncGWD4n8mYSbcy6pq6tX7yoqBKMn1TfqdRRRsXqo0shz/F7H/lpL9kXbfgKUC1CJt1gSwmAUqZzUX/rsME+zqgfZMAz90uRBybwLsVIxb2NHS2neSjXLnVnAaaknKoI5LfldUBExWNaKhkxbEj+qsUJrTWc2nTOKi5uU2aFbj9LmPGh+CZ2n1WdfUX3FebCOhsdfEuHIElHzYZ5aE44JDw4zCUX/wfHFqfcs9wC7ZmTO2kHzHJ5ULmNzNA4/H
 5iDP1OPA
 ZXulc9dCd4yiZSUe6fE6kB/DwLhOACQiFMd3DOwD42mP59lNSePgrHrAhmT5RS0pQiWwjFjFNEuaWh+r2r7WPVi3IJ5EZ8FITw3+uFewcHX2QftI2hMEKeRLuLed0L6gK4OemaMHUhc199BnsOxqVl85/CKtDGiuNr+fZZPnn3eiD+j4ue3ljhSa/ko41ZFHU5c/UsnYULlFcutX6v30eOxzRjmVIBheYxcKbXP9NwWccAtufaefVHD/Ww/X6WXqnEspoInKGD10MEcGEjQ3VIPhKYZtRbXpEGmISKt0w1j1tNyznnIwZ2ZzBOgQBCGZZ7KtLDOkf1cl1kGmFROXnYVa5BGD5KYDhKCyNZdGWU5iTRa35HDAxd6PgH0S8B1AZHo0YQnYdJsby03e8LgzSvNJgKpshJyhmvCbZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/16/26 11:15, xu.xin16@zte.com.cn wrote:
>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>> index 7d5b76478f0b..0299a53ba7c9 100644
>>> --- a/mm/ksm.c
>>> +++ b/mm/ksm.c
>>> @@ -195,22 +195,28 @@ struct ksm_stable_node {
>>>   * @node: rb node of this rmap_item in the unstable tree
>>>   * @head: pointer to stable_node heading this list in the stable tree
>>>   * @hlist: link into hlist of rmap_items hanging off that stable_node
>>> - * @age: number of scan iterations since creation
>>> - * @remaining_skips: how many scans to skip
>>> + * @age: number of scan iterations since creation (unstable node)
>>> + * @remaining_skips: how many scans to skip (unstable node)
>>> + * @vm_pgoff: vm_pgoff into the original VMA where the page is mapped (stable node)
>>>   */
>>>  struct ksm_rmap_item {
>>>  	struct ksm_rmap_item *rmap_list;
>>>  	union {
>>> -		struct anon_vma *anon_vma;	/* when stable */
>>> +		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
>>>  #ifdef CONFIG_NUMA
>>>  		int nid;		/* when node of unstable tree */
>>>  #endif
>>>  	};
>>>  	struct mm_struct *mm;
>>>  	unsigned long address;		/* + low bits used for flags below */
>>> -	unsigned int oldchecksum;	/* when unstable */
>>> -	rmap_age_t age;
>>> -	rmap_age_t remaining_skips;
>>> +	union {
>>> +		struct {
>>> +			unsigned int oldchecksum;
>>> +			rmap_age_t age;
>>> +			rmap_age_t remaining_skips;
>>> +		};			/* when unstable */
>>> +		unsigned long vm_pgoff;		/* for reverse mapping, when stable */
>>> +	};
>>>  	union {
>>>  		struct rb_node node;	/* when node of unstable tree */
>>>  		struct {		/* when listed from stable tree */
>>> @@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
>>>  	return vma;
>>>  }
>>>
>>> +/*
>>> + * break_cow: actively break the write-protect of the VMA. This is calld when
>>
>> s/called/called/
> 
> Thanks.
> 
>>
>> But why are we changing the documentation as part of this patch?
> 
> I want to make it more clear and readable bacause from its function name we can't tell that
> implicit assumption: "it's only called when rmap_item has not yet become stable, but page has
> been merged."
> 
> Based on that assumption, the following confusion was clarified.
> 
>>
>>> + * rmap_item has not yet become stable, but page has been merged.
>>> + */
>>>  static void break_cow(struct ksm_rmap_item *rmap_item)
>>>  {
>>>  	struct mm_struct *mm = rmap_item->mm;
>>> @@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>>>  	 * to undo, we also need to drop a reference to the anon_vma.
>>>  	 */
>>>  	put_anon_vma(rmap_item->anon_vma);
>>> +	/* Reset pgoff that overlays age-related information. (still unstable) */
>>> +	rmap_item->vm_pgoff = 0;
>>>
>>>  	mmap_read_lock(mm);
>>>  	vma = find_mergeable_vma(mm, addr);
>>> @@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
>>>  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>>>  		stable_node->rmap_hlist_len--;
>>>  		put_anon_vma(rmap_item->anon_vma);
>>> +		/* Reset pgoff that overlays age-related information. */
>>
>> AI review says that this might not be the case on 32bit. So I guess the comment
>> should be
>>
>> "might overlay"
> 
> ok, thanks.
> 
>>
>>> +		rmap_item->vm_pgoff = 0;
>>>  		rmap_item->address &= PAGE_MASK;
>>>  		cond_resched();
>>>  	}
>>> @@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
>>>  		stable_node->rmap_hlist_len--;
>>>
>>>  		put_anon_vma(rmap_item->anon_vma);
>>> +		/* Reset pgoff that overlays age-related information. */
>>
>> Same here.
>>
>>> +		rmap_item->vm_pgoff = 0;
>>>  		rmap_item->head = NULL;
>>>  		rmap_item->address &= PAGE_MASK;
>>>
>>> @@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>>>  	/* Unstable nid is in union with stable anon_vma: remove first */
>>>  	remove_rmap_item_from_tree(rmap_item);
>>>
>>> -	/* Must get reference to anon_vma while still holding mmap_lock */
>>> +	/*
>>> +	 * Must get reference to anon_vma while still holding mmap_lock,
>>> +	 * We set these two members of stable node here instead of
>>> +	 * stable_tree_append(), maybe because we don't want to hold
>>> +	 * mmap_read_lock again? Here mmap_read_lock is already held to
>>> +	 * find_mergeable_vma before merging.
>>> +	 */
>>>  	rmap_item->anon_vma = vma->anon_vma;
>>> +	rmap_item->vm_pgoff = vma->vm_pgoff;
>>
>> I suggested to use the actual linear page index instead at [1]. Storing the
>> vm_pgoff is wrong I think.
> 
> Yes, you are right, I have comment the reason in last email. will correct it as you said.
> 
>>
>> [1] https://lore.kernel.org/all/5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org/
>>
>>
>> In another comment I said:
>>
>> But it's all confusing. Because we might temporarily have rmap_item->anon_vma
>> set on an rmap_entry that does not yet have the STABLE_FLAG flag set through
>> stable_tree_append().
>>
>> And then we magically call break_cow() which does a magical
>>
>> 	put_anon_vma(rmap_item->anon_vma);
>>
>> (this doesn't look correct in once case) ... anyhow.
>>
>> So we might want to reset the pgoff there as well, OR only store
>> the pgoff in stable_tree_append() where we actually set STABLE_FLAG.
>>
>>
>> So I guess we have to figure that out as well.
>>
> 
> I think it should be correct in general, but that code was indeed a bit confusing.
> So I've added some comments to make it as clear as possible.
> 
> The underlying idea should be this: when a page is merged (try_to_merge_with_ksm_page)
> and becomes a KSM page, we should promptly store rmap_item->anon_vma
> (so that rmap_walk_ksm can succeed). However, there are various subsequent reasons why
> the page might fail to acquire the STABLE_FLAG—for example, a second attempt in
> try_to_merge_with_ksm_page fails (see the implementation of try_to_merge_two_pages), or
> stable_tree_insert fails (in cmp_and_merge_page). In such cases, we need to revert the
> page back to an anonymous page, so we must explicitly call break_cow() and
> put_anon_vma(rmap_item->anon_vma).
> 
> So generally, I keep the same way to store the pgoff as anon_vma.

Please document that carefully in the patch description :)

-- 
Cheers,

David

