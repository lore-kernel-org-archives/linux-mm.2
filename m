Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC3FCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7C08E0016; Wed, 12 Nov 2025 04:51:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A068E0002; Wed, 12 Nov 2025 04:51:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D298F8E0016; Wed, 12 Nov 2025 04:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAD8C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:51:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 628FCC0446
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:51:50 +0000 (UTC)
X-FDA: 84101488380.07.46E98F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8732D100010
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:51:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=blWZyuhn;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762941108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSPak/G3ooeBRjGhS+wC8fKO72bBj9gWkBo+099LaLA=;
	b=dUqJYwxzpevLoucb2nj9SdGl/uI59QqTeJ7FsGF9PcdlFrlYbocUpp/Hg5jBypylL8XSDJ
	Ehd6XbIcntMwrECVuZuQQlO5ix45BuP+o44K2qUOatF1/bGp7+8Vuloj5Qw9WskqcB/lwi
	p2Ihi4Fjj+DgwXWIOPgcKmzBmSHk3g8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=blWZyuhn;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762941108; a=rsa-sha256;
	cv=none;
	b=y82gYTKs9VA3ixd/zIy0lnZQlr7KoWrf2Nsd7++PPTCeCBySRNESHWKA9XNOf9XF0MkHPV
	G/H7MFRAc4Fq5JdzHBGZNenYI338/9CCw3ZFpbZRUg+IQ4kfA3yAVwCq3f+tvmDPWIkBN1
	kPG3z3PhPQ9zZax0GTlLoG83qujb4lg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6CC4416F4;
	Wed, 12 Nov 2025 09:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE067C4CEF7;
	Wed, 12 Nov 2025 09:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762941107;
	bh=JpCm7hIOXYoCacl8skSZV8a5tTlSpGCfcV94O6Mv+U0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=blWZyuhnbETFn27f6OqpWrXth2ubBEfvedwLSFDNclPYXgtCbAhDrxvX4YbPzgnY4
	 GafPHFEqrHG3MGl+70esf4QkMiGaiHFMmDwXqV4rmExiGPGhuX/r8NIMkiujtvBNPR
	 TWE4RtI14v78OTGKHAhyaTe0mIVCVIrDc+JhilPz/wSxNmJIFX+kUp+0D4jgXOPjus
	 eQ3KbK9iKGOv6ywSd/6nTK44qZwWJTJ17MALEJpcGihTUP9TkcGMegy96fWkUKfkV6
	 EGJ6h5OFB0YhGJzJButnuR6EuXpSghAsJo0ezQXkb6sNsJDOa3EO39EqZpxOEzRc10
	 ed1wBFFsUQtMw==
Message-ID: <d4e055dc-be45-4ced-870b-2b62f3507c71@kernel.org>
Date: Wed, 12 Nov 2025 10:51:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
 <04e8e813-b43b-423e-8ad9-fb13ac953055@kernel.org>
Content-Language: en-US
In-Reply-To: <04e8e813-b43b-423e-8ad9-fb13ac953055@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8732D100010
X-Stat-Signature: daf7799oit8agb78kh145sniuugzc3bg
X-Rspam-User: 
X-HE-Tag: 1762941108-872275
X-HE-Meta: U2FsdGVkX19KrKn+DmUp1vhPUpjvCif2fnNXpcJZTiSVKq6l9WrX4BGtRr3wIbu/sSpxS4HZikpgV741Ao7XGr2pzAjT2l37sqRQXDX/G4M9gxVH6NCPX7pLMJddo8M/C05b4vY5s0fEVG2FjyAETCvxTkijrBor5qAcLl+Y8+EPbRRgCbD7mMvmtkDye1TRcrUSo6fuqFUNALHN3/gQPDyMg3jex1AMwnoOdsWYh90TP0VCrSy7PEeFjmbClR1Lp7lOhu3p/LqakGOtsofqpjgcmOayd+uAn8pK+zRWakO6jJZ2EWxoXJ5h05mGNXIw93iPTCc1VcAsbSptyxUFDSRudOG0nIB3LOWTnJ8LUbfoQo2wliFY5ByQ6MepwJmRO19KcVxpZ6nPr6h6PpMXRiZZLqF1r93T8Km1ORe/FubcBC5S+mngthFtAK0KZVhyYaq1P/9sYJM5agijvV6jxz2ECtnW3hofrrXGpBHBAD84AXNqy7ZHUX/8lRQbsJdr6w9vB/r6IXcGsI7P9/6MM4aHWecJUqWRt90pa/kY27jA/2ArsbUGkLhbt0ytGSnHOmUG97ODM/zP/PbgcSW5+nHmEwA8D1GHK2BUwKM6iLbgddrJMGZy+In5wwObCogLObGN4KYbFMrXmF0WycQAtxkh0iJHZka9JM2hA0dQCNSdVa9JjgrHdwuM7Bz1M1Fbz5+RC3gUv+D3v/PBTM/QOF8PDxgGcfMPehT4gY+IR1wfLa6YonU1MhFkwSAGLKvZolddFTSPhtROWbFm0pEHCmtXs6qwEq3lq7oh+NcZh6JkP8UcSsDsZleIKBHPyhlle3Nvvldy85wKSD0wgnfAPn0efBeq+JxhucEXk0xqADuQGTqkIQohdTxzVd1hTBqsQRvvyLY+NRhKOLwfLDq647/GAmd78fp5tsbNWHgQmP7/wzK4dlkL8vLSQwU6THY4bIPOUYSADrjnqAkE932
 HEiwDZyM
 V8u37qsjH1ZmWHefnn2YPSX10Q3IwpVf1dBkXX1qpktdGpnB96jZqr9YIBvVEXppS0ssfj+kQLkwfR9WOvnsB2By61xdAKCN0lxrFX6eBzp8VQJrZjU9Z6b4eqzSyW/kUZkPwuQHvzGYzuFeu3o8Hp1tx2Du4Me6miGBvMAA1aBO2PhUZfU8DpMONf6Venqld8xRvcIsZ/P7626ey79kzqlEJ9eexIpsPwk2z/Hz78WtyI/v28qJX/zvjg1tJS1/TYZWkUfGLY6Z0PuStjGBB0l3scFMCjHY5ynkUMzXN+5g+mCx6eNSorOnM82swCVdnICWSEwYfGic813wafU1uS6qwIy/9gGG+5jP9TkhEi5XFGfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 10:51, David Hildenbrand (Red Hat) wrote:
> On 12.11.25 03:00, Wei Yang wrote:
>> SCAN_PMD_NONE means current pmd is empty, but we can still continue
>> collapse next pmd range.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>    mm/khugepaged.c | 1 +
>>    1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7e8cb181d5bd..4c2217076ad3 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2835,6 +2835,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>    			goto handle_result;
>>    		/* Whitelisted set of results where continuing OK */
>>    		case SCAN_PMD_NULL:
>> +		case SCAN_PMD_NONE:
>>    		case SCAN_PTE_NON_PRESENT:
>>    		case SCAN_PTE_UFFD_WP:
>>    		case SCAN_LACK_REFERENCED_PAGE:
> 
> Looks ok to me.
> 
> I am really confused about PMD_NONE vs. PMD_NULL.
> 
> Is my understanding correct, hat with your patch we can just merge both
> into a single NO_PMD_TABLE or sth. like that?

NO_PTE_TABLE, actually

-- 
Cheers

David

