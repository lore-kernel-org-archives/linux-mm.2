Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783AD606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csvcTsOU
Received: by kanga.kvack.org (Postfix)
	id 953826B05B8; Mon,  2 Nov 2026 07:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B1E6B05B9; Mon,  2 Nov 2026 07:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B0A6B05BA; Mon,  2 Nov 2026 07:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4356B05B8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:54:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECA45C0CCC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:54:18 +0000 (UTC)
X-FDA: 85390172196.10.9FDDB89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3ACFD180007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:54:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csvcTsOU;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYKdbODKc1prEg/TSIAKCpPLWFj9bHZOX1ZDiVmUN/E=;
	b=QVHF4P2POSm8rLbh7emqPMSOFU7Yfv91XCFkRjtiWT4L+hAzpqXGTlERApqX2AU+0kFrmw
	te97FR5eAmkwdF9nY1p2HpDqspRpMoGn4tZKQ4W6oUDDmcMhQUwPn5R8BmvtFESxpG1sk+
	0d7m8JU0x8e71KoSzZNE5BukCx1q768=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csvcTsOU;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624057;
	b=jGPOJtGUrrqp2bJpI+aXs7KbFMZJdfaXcy6RMkCMEUFaCorYXd7Or5OsniKYsK3CS4G+jJ
	WCPB7OkL6Hr5e7IfFl8zeKf0Abi/JQ6itO+oFMw0SpgEDqJO4oRAGdfglBBvblSflqvEbH
	DC22rp0xnYcCfw4/nsGJvW3YaoygCqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B44CA602C5;
	Mon,  2 Nov 2026 12:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B651F00A16;
	Mon,  2 Nov 2026 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793624056;
	bh=MYKdbODKc1prEg/TSIAKCpPLWFj9bHZOX1ZDiVmUN/E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=csvcTsOUYC23IF5THZRKLkyoa8+bR3vOPOvcfHV1GbL03Pc0uq4mCw9+53mIF4ErN
	 MtvQVl9QC1exMlpUh/LNqLsdxSLvFxPPkCNJuwA6bMm++7lghNlev2lLb67EfsqjSk
	 4WLj/TyIG906qxCp+7j1OM8uKsUVLiPYjJRwQMQbm5RlSiV9xdyUgX5kOTFs3SZ2VZ
	 8dUQakbFT6sWB0GBISiaRU2M6b9amfOtTvYlM9z1T28yTAz7Grux/KR7DRiMIoqhza
	 87k9tQ+6GTFFRzU4v2SQ4mtWHCViIeMReaJNBIG/DbWU10n/S+lfFR6SfaIY8HW469
	 ll4JZH22VNegg==
Message-ID: <47abd304-e269-42dd-9d9a-3b7300ce23e3@kernel.org>
Date: Mon, 2 Nov 2026 13:54:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/15] mm/hugetlb: compare against persistent count when
 freeing lowmem folios
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, stable@kernel.org
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-2-a0a033db180f@kernel.org>
 <68EFA1E5-4898-4278-8718-06B1A010DFFD@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <68EFA1E5-4898-4278-8718-06B1A010DFFD@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3ACFD180007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: xw33zzxfws1dcdb88h61ta4hg1mc5e7r
X-HE-Tag: 1793624057-561253
X-HE-Meta: U2FsdGVkX1+B3F2NeCiF+GK6zqJhnE+QyPesLemEVNFVXVtZVNEv6bFmGdjwdxr92xyxG/+igWNCcpVzVinI+wjpahW7L5gycNwwcn4JPd7zHGv/DpUkS7GoYeHN5pAxgYgDdWStoYlrovehPa3fnAIGj0dJtyKu8cxcncDKPx+xaZgnl9NGLb1rDNcI4Dod312QM5STcnA7Txlv7uH6O2bxJ/gNU1GxoaipKAIt6yHtf6R9PjMjepYwQ/gG1g3FfaQlE9SVxHX1JgBTmEu8YOcCgzhPJ4xztWCwv68qMzwPpnli2cPr6NW0ugPQ7ou0DZV+BTmKsIkWVt+QvkuIZWxgyhJmMIUAX9C91bkDLXk0kQU8P/59cjfezQjKDKA0wKjZ2SlbHWKNPQ0Yw3fY81irVQ6XtvUYxD+5yfkYDb/3W4ipberqxI4URUZagbF7ShYfhFUksA5yDkpPBurJqtnQ3ehBCJV+nsO45Bu/S2AYtH0/rbVFu1U/kbeKj2Tp0Z6IMFn+GA2R7vZg9eiTGF6dvkhqSk/IIp1eYmk2EGIom0ka0xaay2h0hPUhEE9aDSkBH9bA1dIHws1Ier+xn/VHwzFyVwlLj9UaFJkBhRx6znHR/gFliNZ+aszD5rqWIMFmhOPNnlLpq2Y3ZBd1UeC9uHWjYQCbZjvfvapyNiLiR9gGcfBRNinN7qpFz2pA04u1aKEL/0luWa9tiDIGhotyX2w2DDU2aAX7YugEnhYfw4S23t1wq8YtsdlyxonFD5Ji3pakx/TbCbfSJ61pgpATnzYdkCITeF3a8zXxcsefqxttlrcMY30ZJ4BGe6g/6JkZABSp9QrbynCxrySxEb/Wnamuu5iejK0SgT4WFSizSwvkj1FItuKHPDtG4gixW7xakDtfU6/G2e0QYZ3p+UglQj5DT9FXnzjR270gIUeV17cGdqmWqfunzFDKq/1+uwcwQZMV+UceKSNUoCm
 9n/P8Jed
 dF2DFLocuzCueS7i737pLIke/6gX0/Pkbr087DuH0IdQ2JZ9SjQ5EX9Vqn+qFRlCbemAwaCRbuuSVn6O/dHei7JswqwlD4/vQ9P7/7/0koKVVCTk4syhXIv4ht9XY4uucitlBiAxeOI5NMmxCUhciLa94KY1pyPSTic3ttR1E90Uv/W7cHxeLt2pXkfaA7xGTiKra88CiprHRCnpj2K05ky4xHKkJSqcttfmjxEFT9EMhQhRhzroZtfzbbtqqYb2GNN3jsI9suxzog4bvrmSK3y0DxDWDDqzpzT2OPjINotSiLQ3VogrT7WTl96151nAcrnvrgUbE97tyIH3fp23caCbDYtE8jT2pxv4ZSzKuelxNwbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 04:39, Muchun Song wrote:
> 
> 
>> On Oct 29, 2026, at 04:13, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> try_to_free_low() gets a target number of persistent folios, but
>> compares it with "nr_huge_pages", which includes surplus folios. As a
>> result, it can free lowmem folios below that target.
>>
>> For example, with two persistent folios and one surplus folio, a target
>> of two can still end up freeing one persistent folio.
>>
>> Compare against persistent_huge_pages() instead. Convert the macro to a
>> helper function and place it before try_to_free_low().
>>
>> Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings")
>> Cc: stable@kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>
> 
> One nit bellow.
> 
>> ---
>> mm/hugetlb.c | 8 ++++++--
>> 1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index da5d04edf7c1..3a94ea1c9457 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1335,6 +1335,11 @@ static unsigned long available_huge_pages(struct hstate *h)
>> 	return h->free_huge_pages - h->resv_huge_pages;
>> }
>>
>> +static unsigned long persistent_huge_pages(struct hstate *h)
> 
> Better to make *h const?

Agreed, thanks!

-- 
Cheers,

David

