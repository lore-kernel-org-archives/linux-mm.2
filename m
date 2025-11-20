Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6615CFA442
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 19:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2CB6B0007; Thu, 20 Nov 2025 14:56:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D632A6B0008; Thu, 20 Nov 2025 14:56:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78F46B002A; Thu, 20 Nov 2025 14:56:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B53116B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:56:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6649412F92B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:56:19 +0000 (UTC)
X-FDA: 84132042078.07.9D4529C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9539120002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:56:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s2EPi/es";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763668577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYC40L8sQ+P2147+k130cpCq8h5yBBFwMhFNnLakTj8=;
	b=r5QcFLRK35ynAWgCRf+nnCCiz8+Bc7xfWVcVTM8rTL4gCYEYvhei3DUuJil8ZqMKt0bAVS
	0v2xhIl2HQYHDMcQgPdaY+9Xp+nT90J9JcX68XKXFCGl3HoSpMv5sCGJGdfckyUEva9/yq
	b9L5vHzULU8sZNf5dXCqhkw6wbMt8R0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s2EPi/es";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763668577; a=rsa-sha256;
	cv=none;
	b=pyF7GQBg/BBGMJUYwFh1WmH512HP95OOh0G2Q22jIeWx0JglmGaAVPCF6e7cW7WCIu6xmr
	5bChxjMECZiQ1SuG+0ZpDue7XygSzfq8je5Z8Bia7+32F+exRSZb8/Fo921XWIEq3WcoGQ
	tSXOzWxHfbwhIT1LkxsAv05QZiOGx78=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E5CE43727;
	Thu, 20 Nov 2025 19:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2534C4CEF1;
	Thu, 20 Nov 2025 19:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763668576;
	bh=qtHvUpDPE2SB/7d+oRdbHGsrVFL/jkakr/Kb85gdfuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s2EPi/esShxVmKeGCrkp0KRAHLvnhdW/GcHJ8d+tDjKFM7F8KsywJTyMOj6UPKEUN
	 JfICeRLft9enfyA48HZS7fZIhmli01y5IKtxQStFgbnQYh+Wg/hJdKNQu5pKrWGI6U
	 aUE4Uh2NfkDnWPjyfjVoId8/4u0TJdwMKJcgE5W/E4ibcScQ9xzkpoJRaXaaMeB0va
	 bCoxFkkS82ym5DC9YfXtS9NvCeowXC/n1nOniqwrGjbrcXl873VWPm7GUHrysXlcpR
	 IFBQ7MYOy5bnX8XxTEKbVaGPK6E7tucBykq4p+bB5GZloovvY47vJAsWFlKC27h9Gl
	 1Al2xQMhRMsvA==
Message-ID: <c29e2ec1-c607-4467-b500-617584c8fb6c@kernel.org>
Date: Thu, 20 Nov 2025 20:56:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
 <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
 <FCFED9E9-56A9-4260-8B42-D0BCFC83C506@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <FCFED9E9-56A9-4260-8B42-D0BCFC83C506@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9539120002
X-Stat-Signature: 3o6s57heo1ahtzek6pz81jtaooh8hgwp
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763668577-674756
X-HE-Meta: U2FsdGVkX18DivvEHQj5Cs29iwZANxXMBYbkDw/b2YwWpo1/VmIJP4Sg2d+7b8H84/HeS8H2iTwl3YzqgsaeRfkZmPrlkvjnUrKLS8KkJa5ssCzBTgVTYpzLgAAuOBzoBi2ttjLzPPfO/mDvDZ07Vvo46PyUNAZ6UZDR0KJColfWV4YzMl0XA9vADolzmMOsY1aUi05XIdcrlLdNWI+LqdbvYw64lnmOIF2Q7dy7J6YYNjjWHrMG2T04uUJx82fbXuHOLC3NoTwX9k0YRFaRIJgtWiMhNM1hB6/dKxJUKDE9br60jlvPMhIGQ7Glqjy3lUOOrifztnGJsJDTcbsz80mbD5fIsGxCXtmuGPjVR7TL1n3QIAtNj5Zs06w11ivzDplvSsrGLrjblJhQzxtDm3ma06sqdIlEv7r238emb14wQrCzZY2+DPoUlM18CavHIJSaR1YwJDBZhVvdm3UpCirHiB0GifkjT+dbS3V3sGfRV8lFfTVNQo/JFpvz7Jk+Y+jIVU5FmPj4bjMJrRvmhSju9cX8KI4w/ERRK9/kh6gWui1Z1PsG4BUR8DRSda0ITqYBAPdXePffjzaQgzX3scm6u3CjJomwA4+CAxhfLs7OPXvj3Mhw5Yz5+Gz7H7oLFsXyyuRemEc+/HXeXq+exF1lIncVWdcqYk3KzthFGISX/FcJsPf4uPQ5N3apatXDGS3YhgD4uOMUeMyeZTircvU/Gb508PBbk1Gd2BtAkFOi2G6DtpNrcDMYOb6oCc3mFvJss7l6cF72gqHMarzQNJ2FJPQx0TQXYgtZrzjZ71LP6boMwgNiJrwVl7Lo+JDQPWZcSTBa3rb9VUpvb5fMR34zZMx3gX50EekyX7/3lWI5ac12gnqhrWPURGAnwn+bys5s5A4T7JnWCo3t6Hk8a46/FtpxA60mSMB4wTFHDgDFcVeMYACDdZ6Cyi9mgPlKDmO7eXLIBUCzrCLtixb
 +WsSo18I
 bIUd3/VxrtRuoYDCR2oYqx/qs3iZeNf5lAigERq25Xmh/2Vx8xV/pE7xT/zS7sAt4wECOKpcpkYi5nEWy7mgj0ZNENvIoDuxZrcNQpHyoMd87CWSV+hKwcfOJzyMtNyEIRS7rpgTEnMFiteCt7H4Agl9yOIs4XvFT9h5hE0UyVMyP7JN1+dZQtPk0XR9niPNblcplTQGs3TBGzIiGCbbPvYtnDUJWbOScL67ibNoOxCdVf/WA6GMry0EKGSbYbCv4aEatQQ+X5fmV42n9wdR0SpSxsXFAKBKPaLRZrTv0g7yJJsfFm+V4bJOev6Pu6j2YXmt4TfI4S74rvVJT/TccQTOFlN5rPivFCZxdj7q/Uaw7W8sWM5ra/TOKTfpVJFBQUAeWia7incjCpq/Jp8QKh4BaDs/+9zrl3JWyV7sKaoWJDVgxLd+oB1Mv9xejaO/y85oQ8abNJdneFnTYNrF+rj301XQ56OI2UIkm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 15:41, Zi Yan wrote:
> On 20 Nov 2025, at 4:25, David Hildenbrand (Red Hat) wrote:
> 
>> On 11/20/25 04:59, Zi Yan wrote:
>>> folio_split_supported() used in try_folio_split_to_order() requires
>>> folio->mapping to be non NULL, but current try_folio_split_to_order() does
>>> not check it. Add the check to prevent NULL pointer dereference.
>>>
>>> There is no issue in the current code, since try_folio_split_to_order() is
>>> only used in truncate_inode_partial_folio(), where folio->mapping is not
>>> NULL.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    include/linux/huge_mm.h | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index 1d439de1ca2c..0d55354e3a34 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -407,6 +407,13 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>>>    static inline int try_folio_split_to_order(struct folio *folio,
>>>    		struct page *page, unsigned int new_order)
>>>    {
>>> +	/*
>>> +	 * Folios that just got truncated cannot get split. Signal to the
>>> +	 * caller that there was a race.
>>> +	 */
>>> +	if (!folio_test_anon(folio) && !folio->mapping)
>>> +		return -EBUSY;
>>> +
>>>    	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
>>>    		return split_huge_page_to_order(&folio->page, new_order);
>>>    	return folio_split(folio, new_order, page, NULL);
>>
>> I guess we'll take the one from Wei
>>
>> https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com
>>
>> right?
> 
> This is different. Wei’s fix is to __folio_split(), but mine is to
> try_folio_split_to_order(). Both call folio_split_supported(), thus
> both need the folio->mapping check.

Ah, good that I double-checked :)

> 
> That is also my question in the cover letter on whether we should
> move folio->mapping check to folio_split_supported() and return
> error code instead of bool. Otherwise, any folio_split_supported()
> caller needs to check folio->mapping.

I think the situation with truncation (-that shmem swapcache thing, 
let's ignore that for now) is that the folio cannot be split until fully 
freed. But we don't want to return -EINVAL to the caller, the assumption 
is that the folio will soon get resolved -- folio freed -- and the 
caller will be able to make progress. So it's not really expected to be 
persistent.

-EINVAL rather signals "this cannot possibly work, so fail whatever you 
are trying".

We rather want to indicate "there was some race situation, if you try 
again later it might work or might have resolved itself".

Not sure I like returning an error from folio_split_supported(), as it's 
rather a boolean check (supported vs. not supported).

Likely we could just return "false" for truncated folios in 
folio_split_supported(), but then state that that case must be handled 
upfront.

We could provide another helper to wrap the truncation check, hmmm


BTW, I wonder if the is_huge_zero_folio() check should go into 
folio_split_supported() and just return in -EINVAL. (we shouldn't really 
trigger that). Similarly we could add a hugetlb sanity check.

-- 
Cheers

David

