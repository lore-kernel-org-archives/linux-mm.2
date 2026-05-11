Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C044CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 06:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC8B6B0088; Mon, 11 May 2026 02:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59CE76B008A; Mon, 11 May 2026 02:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2E96B008C; Mon, 11 May 2026 02:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39CAD6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:46:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDC001C1267
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:46:57 +0000 (UTC)
X-FDA: 84754206474.24.84688F2
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 00CBA2000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:46:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=WfQsprSE;
	spf=pass (imf03.hostedemail.com: domain of fujunjie1@qq.com designates 43.163.128.48 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778482015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvcBiJ61ExhUr8Ag0SmSBeGGSQWpBNyi4VxNqzF8cb8=;
	b=TlXURqmhW2LDZy2KI+331jE18CFxKZ6SFK/hor5VUwHHfbnGQuWmKBV20hI0yMuepfcaii
	tyadSeU3TFTdISu/SrGPp57Yv8acHFZs99CV7D5j8kRGbIQ9uryhCejLzTGHB9FH53WE/2
	wCe64a+D1U22cOrOOXjVOYmPAIQsDc4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=WfQsprSE;
	spf=pass (imf03.hostedemail.com: domain of fujunjie1@qq.com designates 43.163.128.48 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778482015; a=rsa-sha256;
	cv=none;
	b=uMYiB1rXko0daz9rRTGOEmjIk+QWrDKfDTav67ODl0h3pJB/4SHZ9Y6UoNdfNiqVAPGgJo
	fuc0rpoAbhB03svPRxMyb0e3aRzs3JTRqXSrVGfucaf5nUVcpsPS+iCXO4wPfNkLCbXGOJ
	j+Z5+FiEeGz9tw40Oo/H/wz/anjJi+k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778482011; bh=KvcBiJ61ExhUr8Ag0SmSBeGGSQWpBNyi4VxNqzF8cb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WfQsprSEWvLn8OC480A8B9x15Vb5Xm7g6hUqFu3AV15j3bwKr5cqw432ATbwcl5u2
	 P5h5kio9UiiIfTv0+wYQzFmbkvVD6J3g71daRBke+BL2pUkMXN6frp5/HmUNdlWUQA
	 NRZa3o0Gkv6YtXXMbKA6X7UDNlf1cVi8GCxIM1Uc=
Received: from [IPV6:240e:604:311:bdd:c445:e8ec:eca9:fced] ([240e:604:311:bdd:c445:e8ec:eca9:fced])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id BB0BF0BC; Mon, 11 May 2026 14:46:48 +0800
X-QQ-mid: xmsmtpt1778482008tbnsg6sdz
Message-ID: <tencent_38E69D3DB046106F5E2D0AB9769E27149509@qq.com>
X-QQ-XMAILINFO: MR/iVh5QLeieeOvOqEro+wX77w6fbh/2onfyY6207ZU0kC23izLwOt3CLQFU5j
	 NRyOylqvK1has+Fn1jt0JgQPVtqFzeUjmqe+7AuxMJIA3od4DZHplZexHRsyN/CBC3KrXLoHP7pw
	 XMXkKqNtv6CtyN6POJ4/+5/W6Vi9/b1gWonKex7zdJOsnGkyzMivCY/NJNd0LyxC7g1ipGC/AiEg
	 uKAEH4NPJWw7TtFYkOKlDUa28AQ6AkUh1aZltLBYiAfV1Nh2+biOaKsKl4MaN6Yv1TQwiozKbUbH
	 oihXRWguy8VxL69zb9OKg5YHI4hfm3TSCHeHicPE5vgjlBHoMOnbaOTYtFt5uV1567UFk98zgra/
	 y3rJxJ1Pm+wTqTsDLc+czk4qSNmUReLmWXPUJ3slKy+ZzDKKRb+cUUoT89vQDvGjUjtkSWVyARg3
	 RE1mecvEbW8eiCHZSgmT/DNlCs60Th/k21bKD36zufk0XQp2RIVyivi3SCpgXRL1EzU1/5c+trHX
	 n/nN4wP8WkHdzGlqtkoO/Pp8pOIk0CkomxpoPki9KbUxplwqc/yYz7tH9ZncHOZSftlAC5TFeF3G
	 SPi7hTBpbfQ8rctpFeZZmxS/vda5oxwjeWoMbWzIUkilyXjkZhLHFelmcjE2G+iT4hbrEPyM6OGS
	 yMhZ3jsqFgJhaiVf1qpOW8ZuWp5ONiNwT6Jy9zBPA2JbHxkGmrM3YnbmorzF2BuPUwr4S/8cPrzv
	 futcMPsytsf/O8Hen4sr6G/5hHz+t8VBras/ojpO0NenVvkhKj7Bzy+4+VPJ/B7mjHIzsugjHKgl
	 uYpUUxFvyS/J44jFxhq76J618Uvfr4QmyLoCYR9MrOuky/2Kj5IT80caqFKt/M77orBdJjogIidO
	 PI9/GFc7U99JoqZxvSSOm1hqu5kXU2Tn9r2mCrqWsyveuqEToahIML+ICIj5/ZWvCfiVu+XK8jnJ
	 u22p31IVKaWOEDN5/gCwV0PQE0hMwfRHsh+/6DBGUioj5nx5iFa1pFAm2LbQG8SZ9esCXnwizu+q
	 nCbic2aRbZogyoseYzSrL4BkEi2H//xk+I9rreaLZfLEbwXAzbexIcYb2Nhde0Y8GJUjcCtYN0gR
	 FjcVVi7eOsesZC6uU=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-OQ-MSGID: <de715a64-b3c6-4530-9003-d5e4d66da029@qq.com>
Date: Mon, 11 May 2026 14:46:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/fadvise: avoid remote LRU drain for mapped folio
 failures
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
 <f7669744-f71c-49ee-9241-c015ed90f165@kernel.org>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <f7669744-f71c-49ee-9241-c015ed90f165@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00CBA2000B
X-Rspam-User: 
X-Stat-Signature: 65n3x5c83maq8cf1tf9awtj7iob7k95e
X-HE-Tag: 1778482014-492820
X-HE-Meta: U2FsdGVkX18oWWUomPue0VUpB1uWNyZuLUl1UGmP+LJNAYFGfRnVY2pPWqxTjynyE17OFVLsW0g2MnBs9Qfsvi75vo771pVs2+G+kjIJIaGTBjHOQbUjEZbiydbif0t7pES/6mg/8joe12kGrYWlxkAfHbgRBqThlZXkLmLDkzPfl90TGR4yoRyw4QhNebz2eUu/qe1OnmhdUmvdZAar8y/CWOAbqzrLwv0EVPtZtpsF3koDFbKrAACfOXhBwz3Rwonu2G7PKWvjn7qSI86w75Gkru8qSfjxJ42Li7wQez//6gVc9wF1WwDVDpn92ZHJCpzrW7qHghvkNEGuNZ8qx7kCa3m5vfKniXFq8RJPjLH7p5t9iPrCNmGkrmuc0ZxkZMvLxBmNltGelN8O/J0AIR0D+SVk0B4rbc8zqS9UDX017NzjN/sSqIcyeVteHOMf01oBMyRnzIkLKDSRboQUdYyVAzPaqwS1CMmktgadaBA316E9YRgpZdprmspO/clxG2Frt5R8TyoRWWu7viFulDuS1pYQoeB0gzvfEmnzPyld8mHmdgnGdVjDcBj+swiIv3U4uaV5UEpy3TOo/Ut03bfCzVLlyOpDaABz9d0CYDsEfxon4jhFcKL0ey3MkZ1UDjxTkPKlkbkYA6hwW3lAl/KYWbLr3e9cuLr7bAgb3lQcyfltXD9Qv1X02M4MZlH6jwBAqaROBwed9uSfcsokpT1w6hLAucvSAYwNb/uzUidiWMmB2VGQot218FMwOEfFNeqpBV5ZXFlbnOTZMFHMkYx1oqEwxrWjYlWr56iSdSY1ReqxTyOdqoU6Seu9SUzaAqf8e0+vc/nEjX2z0PL8HyJi73nzDloe/U3Ia4njmiLwCt9tGgNaw0ynin0jtBen7P+nUdv6wiYICRtQ/ntMGY8QQuWpwWzQglRSpQx3LHIucqHISqsZBVwjGYFL/iv0knKrXC2GgFA+6BbLRpA
 CuvbgJ0o
 0kUHBI2Gs0Z+ABVCZqfbLnZVTVyi3UKmGOoPN2WD3s0awBKZDk8L78DyyGmNJ2iMyhjeB8x+htDQhudADz4bqmL8IoY7ZRHGkC7BK6cDIEKZxgOOeJFhGok4WwYXlasUEfJKgBrOgs9rB0jGijlu8e+QcU1SdXr0dTOmdbYw0qYlw2HE3rzXQ4ulYVOubpoPxpazN7wyWypJWIqeBX5H9+9jP6Z3jtu1de4On6mJKUAYEvMgzUYaIyTCOw+cC+1XB8mVLsfUtTPCAD+JSggDYjlS2+R3X5GDT7fct2x1jLf2r+1J350etVEoNPtIbREm4nvP0uhHD8llG2gg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/11/2026 1:47 PM, David Hildenbrand (Arm) wrote:
>> -long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>> +static long __mapping_evict_folio(struct address_space *mapping,
>> +				  struct folio *folio, bool *lru_refs)
>>  {
>> +	if (lru_refs)
>> +		*lru_refs = false;
>>  	/* The page may have been truncated before it was locked */
>>  	if (!mapping)
>>  		return 0;
>> @@ -331,14 +323,38 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>>  		return 0;
>>  	/* The refcount will be elevated if any page in the folio is mapped */
>>  	if (folio_ref_count(folio) >
>> -			folio_nr_pages(folio) + folio_has_private(folio) + 1)
>> +			folio_nr_pages(folio) + folio_has_private(folio) + 1) {
>> +		/*
>> +		 * A remote LRU drain can only help with extra references on
>> +		 * otherwise evictable folios.  Mapped folios also have an
>> +		 * elevated refcount, but draining LRU caches cannot unmap them.
>> +		 */
>> +		if (lru_refs && !folio_mapped(folio))
>> +			*lru_refs = true;
> 
> How can you conclude that it's a LRU refs? Could also just be something trivial
> like a remaining GUP reference, or am I wrong?
> 

You're right. The elevated refcount does not prove that the extra
reference is from a remote LRU batch; it could be GUP or another transient
reference.

The intent was to use this as an approximate filter: avoid the remote
drain for failures where it clearly cannot help, such as mapped folios,
rather than to prove the exact source of the extra reference.

"lru_refs" is too strong or misleading as a name. For v2 I will take
Matthew's suggestion into account as well: avoid adding
__mapping_evict_folio(), do the folio_mapped() test in
mapping_try_invalidate(), and think more carefully about where the
fallback boundary should be. I will also use naming that describes the
decision more accurately rather than implying that the extra reference
has been proven to be an LRU-batch reference.



