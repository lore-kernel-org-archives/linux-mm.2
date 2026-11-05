Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1446077B5B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DLWI4iKk
Received: by kanga.kvack.org (Postfix)
	id 041F46B05B4; Thu,  5 Nov 2026 14:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34806B05B5; Thu,  5 Nov 2026 14:35:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BB46B05C5; Thu,  5 Nov 2026 14:35:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC26B6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:35:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2BA4A0C0B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:23 +0000 (UTC)
X-FDA: 85402069326.10.D17EEAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 261DE4000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLWI4iKk;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53L1YKr8K72nT9+wdtzmGCre0RXQPHPg0/Frt6ozyWA=;
	b=KTPfMbOGs1lxoz8VSxClJxKaP+e4BJhOWOGoVdgNmFerSQn+VeDJrrFS43su0CkJwdET2K
	LYdYbCMqIJQ4meIQIeCqexaFg/z3TSSYikyJLRRDwH11l6ak72fkjEj/VEA9gOsra+VY0F
	Ow++9TeMziqv0CWBAXFJ1jZTwVK5fUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907322;
	b=QK9KBZM1EDCY3Pmc+Kx/LtK4AE4xMf74ONBPAbtzQ/BmpIqE8DhhIUNhSgbSfMvXOoDgu6
	vrLcfLL1zH96tzjhic784/vhMZKBvR0niwbhQ8lyMhQWdBFPeiB/uhHiuN2H2Pkj3G46eX
	pUtrQK96SjKjAwutmdNVOc6CGTYZGBs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DLWI4iKk;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A57A4601D5;
	Thu,  5 Nov 2026 19:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4ED1F008A3;
	Thu,  5 Nov 2026 19:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907321;
	bh=53L1YKr8K72nT9+wdtzmGCre0RXQPHPg0/Frt6ozyWA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DLWI4iKkdY8yretBkpgEF0qHmeQsbFGyIGPqIQFl7cG5VQKrz7byvgxmeDoRb0vW3
	 2IMK2S+7K+nkJOTAPvPgmvX0sS+ZimeC4NoLjq1UcHb7hV4lZgTvE2sdr6ZTfXoZv+
	 bmwdJUHQjY5et6yV+mj3u3I2cgcspELGc+BTktO8by50k86xeIVKakVRqYzHEQ3lWn
	 Daq0CW4F7SkD/p8HxXLfKmexxrfUJzgzy7JSqci5mmpCpPjEjmTX11rRlmsIKhBaDp
	 Y3Mx4603duZfntY0isGRjwGz2yk4Sgx8yfrShgzDkUk6Atmv70+FNyIbfclpDgiYuu
	 v7PhqHi4DXmRA==
Message-ID: <4e935565-a22f-4cfe-935a-bbee3e81d7a6@kernel.org>
Date: Thu, 5 Nov 2026 20:35:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Lance Yang <lance.yang@linux.dev>, baolin.wang@linux.alibaba.com
Cc: baohua@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
 <20261105132258.99528-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105132258.99528-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9493pneb8ixq79ezbj4cwfdjuh7g8kt5
X-Rspamd-Queue-Id: 261DE4000D
X-Rspam-User: 
X-HE-Tag: 1793907321-988981
X-HE-Meta: U2FsdGVkX18cfkqaOSHxMYosNzYjvj0bPfXBN36gibeg0m41cN7FjJrRGar827uheIiaTnlFOYfUEeq6wtVNJnl7v5/8T6gfCP6jSunLDq84b3M08pItdwMtvhwKamrdUDPGPzvXpEOhJCDACWF9XO0aSJun5CNkStNdw3j44+q8iGcoSta9ZkuwHIcXOgyGflGPoLg7oZ9kYMfwH0aniHfuj9SrepaWND9eu4FJKlP2D+ppfcOkASnpulooqZs6cMRhnKki3NN6914DmPVTKhuDymIA8n4KRUgUNBmqmSy1m74AOhFbhjeTYyXkGdArFJ6dUTpDBY9s6LKyPg4uvqPLaw8lTf6FvsK84AzrLdMszj4Ik+4b570z0+6/zpiss/dNR8Kx2fH0HtZUlOrcx7edJlmnV8JxLvBn43a2sWDUFR5BfyeWXtmqNFtEtTfqF3LsTXrNWzrIF73AGKD/Uq9oQPvu9LL8uqLWdxwyZxioeBjPyolZziAMTyBFIPXj6mjlyK7b06NWleMX1gydcvfnkbWPRlLQpAL1B9F7wc5Tltz9GwIW+u6XI8dCJs1D1FcRSQusdtCDnaF3PRKJyvQYVAhmoG1EPDIYnSrNYZG1gI8AMOOqfCmF2KEocEubaC4U2T9HlSIVis5nvhdCQd+aA0Yf07uT58iD+LGueJm3HmSRRAYw71RwKmGaku2+1PfGW3WCB5tCosq8nXxEWZ/qOrVHflVffEajf2zES7F0ftSiUNBzTXVys3xE37CFhVxmNdgqxHeMcmwPQMLoYac6LmLK4UWtcyGevlmfGZGK+bkLIz2NKQ6CickX0bafI1AGgQ6qRqYJhJjuV2YF90FHxEXnW72SetajvFWSSoUiqUHaGr7hW42WsUVWYgj3rls3gTxKWkudj1eEiwB75ueaOZbs809ByEdbjkQVk2oCFFJH0pS1TYl3otB3UnhAt6+VENCqp/t/GsAMrRS
 JR3wIJNf
 HueQAT+I22P97qagYoB+HPUyftexU6AmbWvu5+OJwDYcT859tS6vlzec90BPsWDkMll2BSzy8ShpI620hIKkLUqhaYoAa8a/cM5uvOb2YhrllVflA1H9YzM2Bm4V2kE9hDyf7rQ7ZUTw9iv2vmRkQAgCii01xGVxzsPW37yhbXO96dlYhZtKkgdUPOdXkVx1UHkB24rPTtg12KKPExGSx3B8ngfHoJTIprYOOUIfhjK8kZpWqwr6vG3/23KlIvWVw/FyRdUzJTM8Yuj5Et6y5inDArWYfuFHZmPPwI7wy6PkPE728YMBYD36BuUdjpuCg60iCfTPQQh1DlEfgZCJEEYAs7fAgRvJobd5bqXcgbCw7OjOkAD+ZkFzLbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 14:22, Lance Yang wrote:
> 
> On Thu, Nov 05, 2026 at 11:06:29AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/5/26 10:00, Baolin Wang wrote:
>>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>>
>>>
>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which is used
>>> to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, it means the
>>> caller can tolerate some racy checks.
>>>
>>> For this case, I think we should set TTU_SYNC unconditionally in
>>> shrink_folio_list(). Barry, what do you think?
>>
>> That makes sense. I hope this doesn't throw a big wrench into our reclaim
>> performance numbers.
>>
>> Can someone benchmark this?
>>
>> But maybe we should really follow-up with the folio-size based optimization in
>> sync_with_folio_pmd_zap(), where we only need a memory barrier (and sufficient
>> documentation why something that cannot be PMD-mapped can get away cheaper).
> 
> Dug into the history a bit :D
> 
> TTU_SYNC goes back to Hugh's THP splitting fix [1]. A racing zap could
> clear the PTE/PMD before updating mapcount, so the walker could skip the
> lock and return before the accounting caught up.
> 
> Barry later enabled it for large-folio reclaim [2], to avoid skipping
> temporarily cleared PTEs and ending up with a partially unmapped folio.
> He mentioned that small folios had the same race, but with just one PTE,
> they couldn't be partially unmapped. That's where the large-folio check
> in shrink_folio_list() came from.
> 
> Then PTE table reclaim [3] added another way to end up with an empty PMD,
> even for a folio that can't be PMD-mapped. The truncation fix [4] moved
> the rmap flush before the PMD clear and extended synchronization in
> zap_pmd_range() to cover those folios too.
> 
> Looking back at the truncation discussion [5], you also pointed out that
> page_vma_mapped_walk() needed checking, and suggested a possible
> folio-size based optimization in the helper.
> 
> [1] https://lore.kernel.org/all/c1e95853-8bcd-d8fd-55fa-e7f2488e78f@google.com/
> [2] https://lore.kernel.org/all/20240306095219.71086-1-21cnbao@gmail.com/
> [3] https://lore.kernel.org/all/92aba2b319a734913f18ba41e7d86a265f0b84e2.1733305182.git.zhengqi.arch@bytedance.com/
> [4] https://lore.kernel.org/all/14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com/
> [5] https://lore.kernel.org/all/08a0907f-8e3a-4071-a2e4-fd1411c446f3@kernel.org/
> 
> So, how about starting with order-0 folios?
> 
> ---8<---
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 74cca0e3c726..d01fe8282417 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -872,6 +872,8 @@ struct page_vma_mapped_walk {
>  	spinlock_t *ptl;
>  	unsigned int flags;
>  	bool pgoff_is_anon : 1;
> +	/* Set from the folio, not the number of pages being walked. */
> +	bool folio_is_order0 : 1;
>  };
> 
>  #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
> @@ -883,6 +885,7 @@ struct page_vma_mapped_walk {
>  		.address = _address,					\
>  		.flags = _flags,					\
>  		.pgoff_is_anon = folio_test_anon(_folio),		\
> +		.folio_is_order0 = !folio_test_large(_folio),	\
>  	}

We should pass the actual folio ;)

But yes, this goes into the direction I had in mind.

But I do wonder whether we need a separate fix first before we improve it?

-- 
Cheers,

David

