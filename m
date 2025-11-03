Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA3DCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5F28E00A4; Mon,  3 Nov 2025 11:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D838E0057; Mon,  3 Nov 2025 11:21:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B38B8E00A4; Mon,  3 Nov 2025 11:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDF38E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:21:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4A31A0232
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:21:18 +0000 (UTC)
X-FDA: 84069810636.03.D9101D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 56927C0009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:21:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XNgPkdmH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762186877; a=rsa-sha256;
	cv=none;
	b=oV+RfYWGHRDA9GHXQyjHCFi88IyBy+UrJMm0fHnr2D+DUOvxZnvcrwLxKeDZ8Od4iVtb4w
	Wb4dJZqcXSGoqyyvGZtDdH8iM5VyPvwMCGjrqgBodPtjWxUp39uiOcvVcISkoWyQXC0eVP
	YQkivv+cMuS4O2zNbNTLQoHcikAX0bU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XNgPkdmH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wmEKafgmpjrV4kkPvL9IfnolIO7VcqaGRd12hwUrHs=;
	b=B0Yjm4UM/zOWgchETXbloK2rlHkMu1af79fuJh1oqvwAdQzRr0q9krthfJDAxlX88Rc1Nt
	QcWU6GtnsUFEC0TmpsNchuTjxX3eOUWxNREoX55EwYHPp9OeAOiH2c8T4EW/RUTPKZR8L4
	lsgiy3rC9hdczCju03tA30MUiphqVuU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4A4A6013E;
	Mon,  3 Nov 2025 16:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11386C4CEE7;
	Mon,  3 Nov 2025 16:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762186876;
	bh=JGeX1BKkY1raNUcgvp1nkjfIgjOBJn9n6oYQnFSG/GY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=XNgPkdmHLEUc9kz6jG+ILhyLvbq5dDaAQIX36rcGiwoUNqhtvGTeras7KgGN0M/Gx
	 BpO56ZrPcv0sCai3jkLmXKW4jnhLKcwyYQHmdfcxdzFZ+C7cnqD6MmItV4Dh3oPnGr
	 5W73mdT/hFmuCWYIBFyRSaXxYWTk5JbvsiArun6DKZW8VJXSdBiwlLR/bM3Dw3Datx
	 2JTsZIjXg4DSq+jc368Ibf8qHDXWbKjknQEdNjmc3C2Zsdop8gUohQZfoHVFPXW7cr
	 9bMuV0uDmzn0xo1Q46Zte6/VLSt9VrdZzYVyXXtwGDb3BwpXE6QTUVc67+udUdjdZq
	 Lv0eSDFptYcNQ==
Message-ID: <3b098e0f-7632-40b7-9201-41a1b5b0ae42@kernel.org>
Date: Mon, 3 Nov 2025 17:21:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
 <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
Content-Language: en-US
In-Reply-To: <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56927C0009
X-Stat-Signature: 79omteqnmx63xb4nsoerhb3y51a4xdzo
X-HE-Tag: 1762186877-537718
X-HE-Meta: U2FsdGVkX1+PennhD3Z4aHiO+5SvXNK3KDmzzU9040ZSSTWFTTRl77aCGfbjSasOC7h4ngX1BNrutf6SIWPrjfqT+0WrQH9zsYOv7UkASKG83R7Yzhi3FRmQjixoXVTppxrti/D314omlqXkWGG+OLIzz+sQkDHF6NaXUuGeuEGC0vD+WtYoO+7DWQdbUotMhYn105Q2HkWWQKiFLHP2lxdALb18682E59ifu5eWISliS7Gpy4lw4krYTjS1Qc0z+gfpYsA2PQjbWodPRgeDPpMpTdhmdc8b6ePj+3xD9b78QF8IZZZuGwrWWyWu2v5dixhf7Vttx1USoQlWk6bJcUorVqFyIeyrnI1Bj6DLyGilli3gVafFKQHNsK9mZCcMH9nrcf4qID0Wr8modIpQmPC16h4AHgXwNSO5Y13ps3Hq9I8TN5qMRNEUnzRNGKDQKP/5s02SBDN1JV3gcEDkgSIDBvg7lR+yWtBRKHtV3cuUTOngHBdhWkh0vENOEBfE1F1m/iuQBGC40Mq/WK+4qiM+j+ZSELlJR1u3wx5Ao1B3+zCSQTs/YoizyHifKg6UZcenLmFZiJYtTEtFkmVln4W8ywz7+j4l/5UsQfX9JYAeGSg2RVV8jtaIAs3x0hXSGrOtOmU6AdXL/Ki8TJhg9PhGPB5BEfyQKCMcHMPBOa+6tRWxkH0yM+eAD/CFL7B6nHf8XbJWDSav90deyv6DfMHYlcF0skk83SEsh1LV39JPWVp8ZAsKvkvyHvwoAHtg5VlY/C92J9tJCvjBYeI43GYsxiruSPWSFzW8e9YkJhdv3ul6/2uYraRCLvTjWCpjWp1wJxvNCeF4I8g7ZRWkJ10XNAsfThvhnBdISy3kMuwLqSJUBKEE99KQRILN/83cf6oBszEjpkOapL8nonLrTqOjKU+1OMKPjOHtLvoviSlQ32ZkCy+A7sjTk+LX9/NeIaZHaTJ7KHLEK/4utfy
 O34k/mVI
 WYA6W4ZHy5tXQFEQ2sdAFuivc7lvtYtTPyeGuIbM3WPfmPXXv6NGxsqd0GlnH4NDeqvQ0CaaI/659fIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 17:20, David Hildenbrand (Red Hat) wrote:
> On 01.11.25 01:29, Wei Yang wrote:
>> The folio splitting process involves several related tasks that are
>> executed together:
>>
>>       Adjusting memcg (memory control group) accounting.
>>       Updating page owner tracking.
>>       Splitting the folio to the target size (new_order).
>>       Updating necessary folio statistics.
>>
>> This commit introduces the new helper function,
>> __split_folio_and_update_stats(), to gather all these tasks. This
>> consolidation improves modularity and is a necessary preparation step
>> for further cleanup and simplification of the surrounding folio
>> splitting logic.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>    mm/huge_memory.c | 28 +++++++++++++++++-----------
>>    1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index c37fe6ad0c96..abde0f1aa8ff 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>    		ClearPageCompound(&folio->page);
>>    }
>>    
>> +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
>> +		int new_order, bool is_anon)
> 
> Is there any good reason we want to pass things like "is_anon" instead
> of just querying it in that helper?
> 
> 
>> +{
>> +	int nr_new_folios = 1UL << (old_order - new_order);
> 
> Could be const.
> 
> 

Looking at it again, and that we are not reusing this function on patch 
#2, I am not sure factoring this out is really helpful at this point?

-- 
Cheers

David


