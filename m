Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB5B606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kjcg+BHT
Received: by kanga.kvack.org (Postfix)
	id B6C746B05B1; Mon, 16 Nov 2026 17:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43E66B05B2; Mon, 16 Nov 2026 17:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A956B05B3; Mon, 16 Nov 2026 17:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4936B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:17:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93FAD12026B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:17:16 +0000 (UTC)
X-FDA: 85442394072.24.D676997
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B46F41C0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:17:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kjcg+BHT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794867434;
	b=wbLsqg7M08aHeHJrdG/uyP3jF9jlneqkxR78LVBpM1CpuGJVtFPwwOwUAIYDDQVQhE7lnm
	ONeVhj/gflZY5nmGXAczmG82GUIH7rQluKH/dNiJUn8MwFtMmE24BNKC0WSARo4uIu3tb9
	4Vykhx5iWHxhZsdoCMdfYOhwwDodTeQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kjcg+BHT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794867434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOn0Z88dVKwZ0ETyYsO0NUgjT+SgYNtaukLmc0QbESM=;
	b=SkfkxDDxfYelGsWRoS6hFgOIFjINcUOvTsP1r6L0QTeKA27eBhGuEcqMq32yQpPTKalG/T
	3LB/QlBF93Fx0F8+thNF75wQEjW83wI2Y3QGzqYbqZMgN1xz+wK7/2JlOmXLttSliNIhZd
	g0dpWMzo0b/j/oUgKkpFLwKZCOWIqSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23F6140A12;
	Mon, 16 Nov 2026 22:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D1A1F000C4;
	Mon, 16 Nov 2026 22:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794867433;
	bh=mOn0Z88dVKwZ0ETyYsO0NUgjT+SgYNtaukLmc0QbESM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Kjcg+BHTj/y0bhtKVbveYKYgXspyGA/eVA3DCkHJ9RN3bi0x9vivPSJoqH5MWbhz3
	 3xcYV8yU/mamfHsNR6+Gd2il56NRYvQIfZpu/UNek1U6iBbTgewMvxklmtL/agmKla
	 E88CNMut2tscGJafu+WBtaY44n+meQFYDgKtw2KUlwzbhPIhROKEWsy9t4/NzbA1hF
	 GTSkonsLK3/ShQykedYh0t4MsbkwjYZmWUsslyTsaWlewdmM7P+9m0MAs2gzMQAyIA
	 QXIaxwhn7nyBF3fkuk95QU7+Vo/ORY05QXBkNdxPAzUXkIrQMt4iDg4PsigxGDO1ZK
	 2kZg8uWVi/4uw==
Message-ID: <8e63a932-ede9-4751-9181-5ae25815ce0e@kernel.org>
Date: Mon, 16 Nov 2026 23:17:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mempolicy: limit shared policy ranges per inode
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-2-16688b2644dc@kernel.org>
 <179467808112.482102.13365594235443107281.b4-reply@b4>
 <70740a32-92f5-4425-8676-68863f3e44c3@kernel.org>
 <179468794889.482102.14066028910704780583.b4-reply@b4>
 <76fc4555-b458-491b-ba2c-ec030879dafe@kernel.org>
 <179484562114.482102.7068121367282977254.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179484562114.482102.7068121367282977254.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B46F41C0002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hspkco6shuynx6upup4tfzokaty6xdeo
X-Rspam-User: 
X-HE-Tag: 1794867434-672988
X-HE-Meta: U2FsdGVkX1+nHCPUE1WKgCHf7ZGPNv+9QUaJZ0cxIERvbNuNyjXaMHZR40sXoDOiebaVjiE+TWNx0z2z38FLwaaKVIvp33tVLW5j3Uv4rcOjpmS97SvsGLRFUa/vPakm2XfxdzsDE3zAwKR2RzU5bE2SxDROEPtCrUaH/2vdfIj+hbsA/nkBW2oTZyskKHa6ZqwuJ0u4Yz1o/pJ6DpYljjKSpRe4QqrUiRs0bPWtOubnIG1v6acEcWUsx+4nGbWoijuE2CbfXVr+rw/ADMDBTVURcroFcvWLQbu6Plepnaf72KZhhjC64Hi1lcMtIcNY+ksNldwL1Nz4oJL9IApRZUfrcIG16sdNfc/yl39jP8k0cGuKRSWzIP/Q43BuhgGCkl90QGFjDdP+0eiSM+6oFlMPtQLmraxn0KZ50Xn8dXg4pUMUJ/1pAzdgI2COXpFkciHxZyXvYghNj5yign2CDYADOYm5Owa5BK4LhsUt4d4Z//hqWyr/z8TJOuh9165E2H/iCLVu+L7CwYNFOtODPmiULPZ1KFafQvfOX1secVjrw+li+1y/FkLbmi5zdeCQpV1JGrn2zgLgUqs4hWr4D0guEZGPtIsAny3udq85HldS2biFDG+Ss3unBqjO2naCh/xkbqSCKApNg9H9X0qQVlsd0WLMffHFoE3y6UKxKG4IigfeTHrUHEbihyl3/cT6KTNqd2Cp3XhE7ZoXAVTZXJ6pGKtVC7EoEy5bW6Sffi3LA/Og4NeSKHejnXIPJq2WwHOuzMBd3EZSjn06MbK8tR72T/0opKyS0fdj0NNdni+sedzeAZfVrY/ecWsPHxBCY62r3WdQrAL4abT896F6kgTL0dCnafQld59vMN3/KmZMKZfv75iZ70a+c8FgfigqqOMSU7/PDyL6+64eXfks2PnluSZOwKJHVc1drNwlF9yf2qQZbRjYtOi4Plp7vfn7W3UBCMaHwoJXAWcqq4K
 /bgEfqrX
 0/boCZKKb/RUVMcxsqekAoClVKMqdNZbMwLcx4CBhsOXIrerzmrFJl0TTmOSdnI8ki62KKSnkMM07lLaF+ciTkvc/Z1phw3OpTeNR1wkr8N+HKPfykc7WRZ9O8yVLQfB4UyW9JpkL6yqpE/gIRNQ8mPv8dmADBgPhMtlmsZyKTT22zXvGKSorWfBdrZLxvNkAXraZ6C7JzFToopMmTyzbF5NYt0fPInsW3CdifLBep0qDqgvR10Bq1dL5CcomIj34uESXwnQ1QBtYIhysRRet0PSXySKCb2Jbrar+JEIS/c4mcd5qKs7WkqvY9q2SYnJkSi+Y/+OOHTj/QyHi1ywDJoLzCFAsjsNtl8X1npqwtgkrTopKYosWgZL++E9JGJ2AVtTzep0zou4PGn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 17:13, Gregory Price (Meta) wrote:
> On 2026-11-15 17:40 +0100, David Hildenbrand (Arm) wrote:
>> On 11/14/26 21:25, Gregory Price (Meta) wrote:
>>>
>>> Just want to make sure the bases are covered.
>>>
>>
>> Yes, and I'd be very happy to learn about use cases.
>>
>> Maybe we can let this stay in -next for a while before moving forward with this?
>>
> 
> Seems reasonable, although just kind of delaying the inevitable.
> 
> I suppose the mitigation for it causing issues is backporting an
> increase to the default size.
> 
> Eh, if the concern here isn't a big deal, I'd just say ship it.
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks, I'll wait a bit longer for feedback, especially from Hugh and Baolin;
maybe they have some examples where we would actually end up using way more than
1024 disting shared policy ranges even after #1.

-- 
Cheers,

David

