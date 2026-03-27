Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF7F10BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBFE6B00A5; Fri, 27 Mar 2026 03:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3706B00A8; Fri, 27 Mar 2026 03:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0476B00A9; Fri, 27 Mar 2026 03:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4001D6B00A5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:35:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 084D1BE57B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:35:45 +0000 (UTC)
X-FDA: 84591033450.28.0438EFF
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2D297C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:35:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=au5Ukkkl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774596943; a=rsa-sha256;
	cv=none;
	b=LYH5thUlYdKQsnscrSjJf4XUlR10tELHJLa648bNbZjqDErYVYEOHNJt0F/HTjF6zv1H9z
	TwYgcKC9rIhnALo1f3LU6SektlcxYgqiTkGy5RYFM+FhBjxF28tCXhgsTZahA2G3xOiUQT
	FsZZWKpJ7pvCEnig7P268GgK0sWvGRA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=au5Ukkkl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774596943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLtU4cYf5f4ETgIAG+QOLy27idZtqxL/V9it4mlnfGA=;
	b=ZwO4sjp51EGeRJflsCyc82xXQvrvhQFedaNNIeIt7GTYkuBCL3PW8bwo5ea3QhqLrEnJGm
	BdBTuJAjzf3oboeGqw10lw4EdwsrlgRpVkSV87cjl/h9D8jnYxjYb7zLvU5gc3Qwv7g2Ak
	pA3U8cSNXzrCB4mxcjhjuY4bw+OAxlw=
Message-ID: <5d7c5690-eb85-454c-ac82-b4cefb4a37f8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774596941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLtU4cYf5f4ETgIAG+QOLy27idZtqxL/V9it4mlnfGA=;
	b=au5UkkklscMhF8BiLUMaSWklas9uysoBQuuD5MOuqCv/qB8+OgduNHqgh+UFXezl/6xv8e
	nrmScX5uN68uU0+H2Lp8zA9iJXEHXLVXwfjo4Q/qfYQiWvb3lD4Jhn7CrTudxykmtmWUCR
	GGaKymYb+rmaEcH7ZaELVBlUH1Cafpo=
Date: Fri, 27 Mar 2026 15:35:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Content-Language: en-US
To: ziy@nvidia.com
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-3-ziy@nvidia.com>
 <20260327072917.68630-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260327072917.68630-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xpnbtqbec1p1i7njkcn8d7zqy34oabta
X-Rspamd-Queue-Id: 2D297C0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774596942-826629
X-HE-Meta: U2FsdGVkX18/oyV5ol/OETVJ40MKV2hXHw7UUES33FZdvUYLdBG7dPPVhYpsnfjZk93zutDxHu6BHnoU3yPZ6dwlnVU2wUhCmDLmxHBb2FMkjyE84dg2BrBG3/XROGsWf9it7v0TKkWBDBv8px02k42I/7oOEE7dI2bCw+0cTLaxorY4J4ZSGif5UcIb4jWkWwFsUc9LkQGVXsNlcmat77Q9i+nYcTP7wzFO5zYsWHSfJGEqM4KYRP7+FSpHyOZYFgYudWsZjP0BoJgzhJwVqQxTZzN2RPYYuZkDh0py9Xb01h6kQd0N2dRNkVELpDVinHI3W0M8rcF5Flj1xtFOYWK7fHn4aReYpBH4iXpagIsfO/Abtq+bXozHfpxG8wixkYIFHC1SKLaG703W2yg9fkJClDvD1NPtKCPlOyXREygtk5PkW2G5Gu5I3jI198dRMi0BHEJhpJZT+24K3ekkiqwRx7yC1akdThIczcS1+WOrs0RUDpUg0NCzl1uWIuCjFTnJNHfEMwEzqL74BPP9Wo/h0Q2Gw0dH06YczIzmZin+c+4ZPG95Ih7Xndrvm5U6YkFDoCzM9ifs5l7IMUWZvgBv3j2VnV9cvVvYR4Ti0DVZClpT8wETkag64smEKaHKbdWIMQ9SeeWNB8/7M4bx9e+iROj7yOn3Rcs2a7jNTFUVDfm6KkWJGXUvW+Qngrq5egujsl+I84M130Zc+G6azTyFTlC/rVG6dEPXHALmLGqRcSMnsSgavziQ+oo8s/NLgWoIMfdBgNtuEyOlf7bld7lp+4pUFMB7bK7Ra+J4yvaXLw/TtFKIDikAcL6/0GI0TJ6Ov1zVGqxd9ccowrgveNAUwZRcvHh3Zni2SdikDt8UE8ku9NjlNJz5icNyuKOp0A7455CI4onF/BEGtQ/3YVUvtK2ls+qDq1DZOMt4D2SiSJgPBlaX2Wk3pXiO+6fEkdEwJi1qI5GlO5Cv+eq
 5inf0yWA
 dXkTFkW4jZS9z8XOGNPVnFtlQYedaESZy9q3iTFOP2+ucr6SIxgzsCcR+WvRh2lXnDkWNKRgxH8XtBNRC6fMHscn6PMvx4Q9kikWPadJ13WBOl0X7KHgL2beowUXjiEmjI8BiuO/Skqi8P1VroaygLLz1DFCthkXA/3f6H93Fr05Q4yJHkBFiZKDGdmimrTWfVF42gMu1CWFNyhwD3MLb2lEGFn3y0S6iPUReDWlqA3IdoY6QFqm5LKZ/cmc5Qs5rZQxQNw/GigJVy1QkQsLqx+O+FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/27 15:29, Lance Yang wrote:
> 
> On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>> huge option turned on also sets large folio order on mapping, so the check
>> also applies to shmem.
>>
>> While at it, replace VM_BUG_ON with returning failure values.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> mm/khugepaged.c | 7 +++++--
>> 1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d06d84219e1b..45b12ffb1550 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> 	int nr_none = 0;
>> 	bool is_shmem = shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>> +		return SCAN_FAIL;
> 
> Yep, for shmem inodes, if the mount has huge= enabled, inode creation
> marks the mapping are large-folio capable:

Oops, s/are/as/

> 
> 	/* Don't consider 'deny' for emergencies and 'force' for testing */
> 	if (sbinfo->huge)
> 		mapping_set_large_folios(inode->i_mapping);
> 
> LGTM!
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>


