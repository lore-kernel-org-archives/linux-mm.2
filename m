Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C40106705A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7307C6B0089; Thu, 12 Mar 2026 11:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE666B008A; Thu, 12 Mar 2026 11:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFA86B008C; Thu, 12 Mar 2026 11:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7A96B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:57:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16F6AB7F14
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:57:28 +0000 (UTC)
X-FDA: 84537865776.27.8EC503C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 633FB1A0012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:57:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ceJNPdeD;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773331046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qlfOgdmRUAWPLgL9De2K4vaZe3zG/IcMGraYm12MlU=;
	b=Fomx0CGUWhU2/SjemUoY7NxkUVSuypYeHi8Zlnv11ket6D6OGE4p0Bi0mUMgQYYkYTALiN
	OeHF84395wntcafBkTKaIXp3wFAX1bzOjL4nfX8PEMvabSuMfuwvKGc+8nf5Jek24sFnc+
	1FJWwu6nk2ISNo+oNLGkUOty7jBtNr0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ceJNPdeD;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773331046; a=rsa-sha256;
	cv=none;
	b=vx6ee03zXLGTJttCf80mZoatTxoF2mdC1m8yjUpwyR/NJwEbqOGwMrM9CmueAa4C4ZvAJ1
	DtrfC/XoGUCdyBRTGN7ClRe912SCd+g4PeC/ff38fAb3pS8lsgc0AsQT5yopQb8OgqbdvC
	aJZxuqGgJ85L8fZMh4fx/KCs7jyMZdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C84AD6012A;
	Thu, 12 Mar 2026 15:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9288AC4CEF7;
	Thu, 12 Mar 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773331045;
	bh=0lxXbZpZUFDVWnN/96oUxmCbLTJ0sneSV2/Bv1lDlaY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ceJNPdeD9e8GzyqujCfaV5h8YRL8GlW4O8Cpc0dVrs2ir2msTZE3hzWCSKXfxW85b
	 JvnGAue4B1m3nWKsdg9H67CY7zgnm/DlOJFHOeorjveNwK8Dd/fpaFEjrE985jNUar
	 NfDLs/o/Q1e3nQSkECkY+MCO7Yz03R6/H4VIhL29OX1mNq5IcVOA72+sZZJw5Jkv+b
	 0QJksiwUWIowBAK+tXnVZL5riYp6D8qfhgVsEQKNkdGE+K+Ho9vGzi/tMjcDJPjFD4
	 q3XeRXccHqEYV/73QT8OajUE5QdOWhDykgtxf3pqkQxqyLzbFaySEGhsq+nUE94K6L
	 wtxCiGL+f8HIw==
Message-ID: <7937d789-539f-47db-838f-c153ca6cfc50@kernel.org>
Date: Thu, 12 Mar 2026 16:57:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] huge_mm: add stubs for THP-disabled configs
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: WANG Rui <r@hev.cc>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260310031138.509730-1-r@hev.cc>
 <20260310031138.509730-2-r@hev.cc>
 <bca4ea00-3052-425b-8f39-729d504fd4db@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bca4ea00-3052-425b-8f39-729d504fd4db@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 633FB1A0012
X-Stat-Signature: 1xuajdjfxhdxwqspo1br5egf1mpr6ga4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773331046-757058
X-HE-Meta: U2FsdGVkX1+4dqtq3D/UsCtinxUM6iTNUNcwY0X7GhGA5iDlsSwMKW9MSYuCU5fCOkGoEU2H+OQIUq0uyE6sNxocOvrOevvPnpfdeg8u+lExU0XR6PUozz/+b72Lpe9VZZXWSK3ruQNxaDoRUPaTgpDHWK/v899+KBfhbmZCJ4EEDBDJt2Y7uivazO/Phy3KCleREs1bltQysBkM4e7F9ZCE82wWWwfV1/DPpTXi761jA15espa6HiyMirbS/cjs1L4YjAhiSeZP+2Svs7XiKiXT3doz0Xqm3kPdsJhScnOTbq3uA/0NV2hm+U0iA5zwqU1cnFBJzd45I2Q8oexl0Ew8x6ka5Iw8xgjpNmHi4YIhDzVQ/UU08PXbnfkoGMB++VK8+ti51jLZK0cZGbYTXU27ME8+CRiL/xjTZkEDrv/QHLZPcqnnksNLdnF1k/JrimGao7AzP70jzSC9S5Ksbh4euEwVV80TROvxVAQogoSLcWB9gBnohmPeGuVpQLoG1HFbVHjc7EFV1xQ1D/8+wyQw77M3fTu8FsaLmLTjLtOEAc3knUDfZ8HcKTpUieRGqcDQr1Q6HOMVw/PBkm4IrPBLLUvDcILB+i+8UphoeIkWjkohG5UVkC5MlwqYkr0mRp1QsnXlD0V43b8DNSKwrDQuflfHGS5EehXjwvKAgLY/+uRcwaoGCrR6Ym9pjsUthkFNF1/z9r8oAPh/ACLP0k6/96u+7gYtaFJ4RWt72RfBAkt2ChQsyIHVdGiedIbrPwPpAHRd5kwBz8zwH/MPxVx7n+8xhpFQwTZ+NqL3kEfi/NRwL3knbrW/LlCFFoN9ZF4NBWuEVei6VEyvJEcSKjNPhKOUmwaPpF9S5LtR+qShSJ58A7lWd02jY1wEZjlcdLu6THnCZgUIbAKG94OYBIH/WMQ53X8PtQond7ZDEbVCizQCrak+Q1Xkci7AnDZI3OWoANWVHQ7dpg2gjVO
 cy0OTmDR
 cjzOSWw/ikTBzBrc0yOUXgX/GH7KSpw6PFx0UiuFTdMcXsru7GQO6XxlRjihFvgOXQnXmH9TQvwn3+Rl4Q24KVzH9kL+VHlbPojc27/ay85C8BWZq1To3kP9y54NdnFIPtEavaDuSHGMrCYtX9GMSOjkSZ/T4h++x5UkvC+BCc/s25ThBMF/7KjIRHvlB09xlceW8C+mJpPBhslnYddf0taw6IwBCY16Xy3cqlOV/zFPL1K00a44CuviQh3QZSQvC3qGBs5aS95RA7oGi+ZnO5cM+gcxsP+CLqXAxczaYMoVcJJ1ULIYcTtsSCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 16:53, David Hildenbrand (Arm) wrote:
> On 3/10/26 04:11, WANG Rui wrote:
>> hugepage_global_enabled() and hugepage_global_always() only exist
>> when CONFIG_TRANSPARENT_HUGEPAGE is set.  Add inline stubs that
>> return false to let code compile when THP is disabled.
>>
>> Signed-off-by: WANG Rui <r@hev.cc>
>> ---
>>  include/linux/huge_mm.h | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index a4d9f964dfde..badeebd4ea98 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -570,6 +570,16 @@ void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>>  
>>  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>>  
>> +static inline bool hugepage_global_enabled(void)
>> +{
>> +	return false;
>> +}
>> +
>> +static inline bool hugepage_global_always(void)
>> +{
>> +	return false;
>> +}
>> +
>>  static inline bool folio_test_pmd_mappable(struct folio *folio)
>>  {
>>  	return false;
> 
> There are other ways to enable PMD THP. So I don't quite think this is
> the right tool for the job.

Ah, you care about file THPs ... gah.

Why can't we simply do the alignment without considering the current
setting?

-- 
Cheers,

David

