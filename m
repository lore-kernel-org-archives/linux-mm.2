Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1989FC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E55D6B0092; Thu, 30 Jul 2026 09:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD126B0093; Thu, 30 Jul 2026 09:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFB46B0095; Thu, 30 Jul 2026 09:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C188B6B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:08:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52921A0725
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:08:10 +0000 (UTC)
X-FDA: 85045471140.04.2F63099
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 812234000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:08:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPqsL5zZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785416888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s66c5Yht/lK/HodOzOy20J4b5DnxB3/+AhdoBRuSQ7w=;
	b=sjBgoXmoERi6Ox9x3d0AFvdTrf1kY2BdvjUtTjALnwvVyEQMMIG4wwjMc6M+3rJ83Zg42K
	rdxwFU2Wm/RLzThR6+WtUAncdm/5BKQ/h9IaIb1HwFO/+a8IXMAOcAps6UgtyRGg2i58Fq
	ca10xAdOiD2z7vtJob6gfKtJdegbX30=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPqsL5zZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785416888;
	b=KIV0qMreJbNAx8ioSo5P3Fy3s7C8IXXmHLr/tp1AeYXF4dMGi7q3gI4phsIZ/8OGs3wwKz
	ti4Ski8hP/zgjJPAomQYxd3L9s8dzXDRNZlo/Twgov+hrP5vVxRQ+DWghFVMpLnv20PeYX
	WTNYEnFwcyDlLbE+k9gPTGX2fl22L/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 963C440253;
	Thu, 30 Jul 2026 13:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECCD1F000E9;
	Thu, 30 Jul 2026 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785416887;
	bh=s66c5Yht/lK/HodOzOy20J4b5DnxB3/+AhdoBRuSQ7w=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=HPqsL5zZrU84eK3NAVOtdXHrR3bAcD5lgmYW///zxHyhOkRfbb+LSeOTRxmdR6+d8
	 M3/RNwR1IoJuRC8zwdFpltWAfgu3+i0W5O2pb8+jfXrZDaLrsgU1v8zf2VSPvT42nx
	 XgcW5p46g5m6UldNLISjzPMw2t9+PBAgpHP81yhU4KntBtXkgCZFR4AHw1LKssIpVq
	 tZeFfdgsrx97QT+XHwvZV3t6TV9VgAJioG/FnUwilXqoeTLuFJMuSVyZV5Mi7vgSVv
	 Da/zMP0oxZf9xudOkAmf0WhsXpQ8A1b2d03iTOhvHXrtUsJZyHfbXnGRmO7qJ+L+KX
	 kouSyJAgTGcgA==
Message-ID: <51102823-ceab-499f-8b6a-162e392f864f@kernel.org>
Date: Thu, 30 Jul 2026 15:08:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use proper PTE accessor in move_ptes()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Pu Lehui <pulehui@huawei.com>
References: <20260720141633.501799-1-agordeev@linux.ibm.com>
 <7f60a20f-7293-489b-8539-847fa1b96789@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7f60a20f-7293-489b-8539-847fa1b96789@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 812234000A
X-Rspam-User: 
X-Stat-Signature: w7fe1c4nne7mtfnybrrubt3jty7het8y
X-HE-Tag: 1785416888-500120
X-HE-Meta: U2FsdGVkX1+7Gt1mjfbpCZaNVoGCbgeXBU/WY+SFXEDhN5nyekqKDnwaUf9S98xzVV9rP17IOVSbD9UDKDLKFdwLkq73tzJ1N/im4PRiatZ3WT/4jVQl98DMN3GRPfW4cwINLClzOVxVtHXUTfl1qT3o7wHo4SgFEtZedGL/HHSf0QmbkPMEZqx1NWFcoA7n6WuD4vNNRI6JoYx/XUTBRJzZOTc0gCYqYchfKjZ3PFmNo2zPVi9WXS+Kb1b+wDKpcYZe3l9uokjH3Fu3T1wsAE2k9Q0btdiV0WyesWdae0YOF74Aks5K/w9GDPjUzRrhCSNnwo/H1el48ejCEoYC40JjHh0x+QhAjAWBZSo9PYJl05elvE6JaclJ7g9OVMIyYhojpsT+OQwfUf/7Gxg9kVSl6kq9yls2VRDrSmR4XhSwHEvAcegn4uhUIZQHRleELOO5/LLYTq5Rfpx/x9C7GINR7jSuixW4OCqao00zWIf57Kd8YL6e95xBOETgE4R4qDGFVdWrS/yaMR7gbL3NPRLMS9xl72mHtQx4Az2wM3JEtkZLdO1zOIgtArsjK7ERoATvEivXOG4xx9w2FDuWRiDwDFj/KhJEfTCKgFNxFnETIByMBjLwMcCl3aIqmnKR6RWdAM+sfERBARv4XOrAreNqOZlAXRhT2NDnz2zyRZVvO5bhLLBis76eiLgRelsxqxcJ8m48KQ8eZhJQhWDzJrEJ0Qd1hr+Ws74dvnHYbYyeXL7cnPibJNQPYfbDG1He+84fWU7EFfMaOD7YBGjz/4zjboVG+a5D28t42TDczjuAOfGmAZYJ/eQOxekzyybQoUB7qb3ekO0G0VVoT73ztFqv9omrAVvR8Mj0DH2sZKnzXemFfJpKAiWMNw3a2SlHwd7cXHTFvrvNEBFeMZElCIgrp4AOzDk6NV3uP2+CQI6oKQNnTrPYS4V4W/qqTAdlsfTBXEDsNbU0NSJ8uzF
 msRnoFbV
 n1G/J/QFhZhMZg6mIvckHV8PNCwVVZex+RSQuBA9GF59EpQWAItElg19K4Ea64El933PbDDmBcu1xnlJ7rGkmIZcvhCQNVHWfyWuBpkiFh827CUEJNkDZhjeXlbrZZOj50SVQ1HIgWyN2FzMveGrMTPd8tA1JQ4+NouMUGOOrgeYI+qNYmGrdB/C9rNwBbR7py1rEL41BgAlldgRLVzatApPwdpEzRJF78pQwto3PV+dZKeRfdS8hijNYAnYEcjaf1DpqabcEsV49Kf438Mdq8n+IrUX21DwQksECnB07xJI1BRDY7/A7LluzHAOR5BnXyeSVXkq8L1+/phVSnJpbGgabid/VyQ4gqT/d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 15:07, David Hildenbrand (Arm) wrote:
> On 7/20/26 16:16, Alexander Gordeev wrote:
>> Follow the pattern established by commit c33c794828f2
>> ("mm: ptep_get() conversion") and use the proper PTE
>> accessor instead of a direct pointer dereference.
>>
>> Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
>> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>> ---
>>  mm/mremap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mremap.c b/mm/mremap.c
>> index 0dfe3de39ccc..e99b19a9850b 100644
>> --- a/mm/mremap.c
>> +++ b/mm/mremap.c
>> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>>  
>>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
>>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
>> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
>> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
>>  
>>  		nr_ptes = 1;
>>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Ah, but I think we should drop the Fixes: tag, or am I missing something?

-- 
Cheers,

David

