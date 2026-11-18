Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F313D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MqKzVFaf
Received: by kanga.kvack.org (Postfix)
	id 1098A6B00EF; Wed, 18 Nov 2026 10:30:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1E26B05B8; Wed, 18 Nov 2026 10:30:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39B56B05BD; Wed, 18 Nov 2026 10:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D42CA6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:30:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74CB2120782
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:30:08 +0000 (UTC)
X-FDA: 85448625696.25.B055F33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B1B5140004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:30:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqKzVFaf;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015806;
	b=V4toM+CCFS+33hDMwZChImJyk3yq+EI2BHvIodMxm3epv5qJlETa/OFURogqGPZmX7zHaF
	oH0PizREhaiX2iLF+CYFKqab4uESO6m/x5XaduGs2Ua3ex1rqTAiDE34EquG63X6PiGm3I
	sVGTrXGFgvDyQ4Cc5nRdzzZVaZ9fJcM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqKzVFaf;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEsG1ygQhHDKkltmP3Oxd/BhfWlhyyMtgVg9fXj6PcU=;
	b=pFYtLQJAaHjK0JgkHaTyfsbiRMXW18g6+YKTplwxPmOwAAeKqwvdOkKqyOhhUL86C86Mzh
	L7P+12Kemkpy8qbjKChuk2UXwvF6Y02OIrR52uKGyEA42GJmyk4fecKn36KnE92YahP8Bv
	42Ztv7HnSECrh8E4VTk6uVWCeALmZ+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A785E4061D;
	Wed, 18 Nov 2026 15:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFD01F000C4;
	Wed, 18 Nov 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015805;
	bh=VEsG1ygQhHDKkltmP3Oxd/BhfWlhyyMtgVg9fXj6PcU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MqKzVFafR6OEDeMVbQsaqV1MheUR8J3CN38RRFTz32LiysIU0IqJusIZM9drzp9+I
	 W2/9HdOSxOpNYNvRS7GHtF+HXw84WOGi4Bt24C+/4PSp6wQWNxgheTf1A5QtZhe0AL
	 Ifg9UgBhse41HvzCQauNfKviiUSjQOV9vhDGKBOFmOM692Cz/UJNlVB6KiWiJj5Hb6
	 ht7aN0GBe+pIqW3wt/v/dMP7eTyYsNdzur5Z2l8tszMlsaLeAhDwbtOFeOHWwKRihV
	 n6KCHxT3hePSdmpZGT2H0t+z9+95XPguYFr4drNSS60u/x/X+zbXIUXfdOJKFP26NR
	 mCenL5kieDxhA==
Message-ID: <893568b3-1989-44e4-ad7f-65f92f26af2b@kernel.org>
Date: Wed, 18 Nov 2026 16:29:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] mm/migrate_device: don't collect a range twice
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-5-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B1B5140004
X-Stat-Signature: 7didbyjwswujuegg1huho6wnpz8r6afu
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795015806-946171
X-HE-Meta: U2FsdGVkX1/W4NDnMl+CQY+dYXjejDGJGsj7V6BHF/AtJ0jNftE93hxuJvbHxDoZiOgjpnNdC2VgWAgTYwAoc93KE69aePJRqopedYWMY086PIMs2VYzxTOzo+6Fqt01sPrZW3NdQ7acP/WK7uEYPynT+KnWJQHnw+HkRmYg+5TSo4zSsxLIMy5ib0lV7gBUXloJBTr+pZUW/h+VRp6RTa4d64784I1mSUdZh+WFiESx/7ywxxqyllhx01cK3lGJajCdbDYVljL9WXu3sNkFj/Jt5ygOftVZE01vMokFkhO2lc2P99D8r54J3BfC1iBp7T48I7LnIebrcFDO9OC/5bEYmj8dNtHD+TSA+MK79bIl1Mf664xr2b0l+U4cM3Z73qJc68Qldwyfo1Maq/vZ+DLJ/T1FMHztrq0BQq2VqIEozVXzvxcFpvyPOKoCyDU0lAjSvG0C4fxZFPf2qOkb3YKOKR3/9DpAkkYrft4Qlpu2w26ooguBedZZgnw6Cobe1jvDgRCF8SONFMYHMjbg8LC5JQW/zew56ws4s+egjsZWEI374YYD4wb08OYDprGZ55sziw9X3Br/3h9i0nA15X34ohQOJ8gQdjRimLB9uNo+xqEZkYhi1XSCzs+qd9sXbjYutjfvtwV4NupXTgwV4Yygi5M2h0iF7y+lAszbmE5lVAS0b9tJlPaovg+AC35+7CcCLmgUR84VsIBfB5NFSt3VXHDUUOGzSeBb6TOg4qFfYtv4zNv9eoHv27EYvV6N1M2FMcJUaEaZC0wtWxekL7+K3WlY/fNWzDDhKQsD7c8ygsvOJ2LRqyOEzOpkAmW4TljCG4ApH/90DCTzwIJBZd+zcHhBfkwWehiuXIyNpLahcVkR9m4SEcnw2nmnZzg/Dmap1Z75z8J/INQmFMQyxUVvBsq0tUgWaK8vAe/ykpAl8zZK+N+vj+UXTTcn6G3A6j+NjvKtnJE+neqvjrl
 L5Vvg26I
 egUEkzRVbKekOLimS5A3Bxel5mSllocTaD6otg40zv3Wc49+rhHtq2G15MN8FTtWTn2l9F3F3PsVDSMK+5X0ijBtRQ4nRaIVDtw/AUtUNMcVMG4YpXOEvx5m5xnaL8FCr9THHxGenShwZNpln219NC/2mg9J1oMYnPD6VjE7JR+bkOY3Wks1Y9nzgRoP3LSn2j5/i4icLO/SDbZQZv7qWBheGvmYSgN4RXabQ+kRBofzo0QNki8FRfph9VfpBqvyh/YueUVkZpM0ZbUDS3xUDCorkGxOKLp9NW0AA/8cEmxmRujvhZRFokISKoYlKYYuxROPCgXQ8iiYVkW7ygu1DOqV5xbI7i5e+EUvMOxyFdklwHh93xcJJnObP4qjZkZZeoKdxX1TjS2BJ3eJ4+fyBWkbwM5XeZn7119RHrhzeceGFZa8S0JyrCJT5QJ3a6VjFI3bMNXFR6AtPLKuCV1Bilt6YxVpWeBbWl++H7GedHM7QVVsjBqmQa4HptNemRSFFyHKFyfT93u5e1yI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> migrate_vma_collect_pmd() drops the page table lock to split a large folio
> which it finds in the middle of a page table, and then starts over at the
> "again" label. The entries for [start, addr) are in migrate->src[] and
> migrate->dst[] by then.
> 
> While the page table lock is dropped the page table can go away, in which
> case the restarted walk invokes migrate_vma_collect_huge_pmd(). However
> this is passed start rather than addr, so [start, addr) is collected a
> second time.
> 
> This can result in migrate->npages exceeding the number of pages the
> caller asked for, and therefore in writes past the end of the
> migrate->src[] and migrate->dst[] arrays.
> 
> Fix this by only handing over what has not yet been collected,
> page-by-page, and flush the TLB for those entries which have been
> previously replaced, similar to the other returns in the function.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: cleanup commit message ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 9e5dab8e1b77..28ed706109da 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -257,13 +257,17 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	pte_t *ptep;
>  
>  again:
> +	/* [start, addr) is collected if we get here after splitting a folio */
>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
> -		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
> +		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
>  
>  		if (ret == -EAGAIN)
>  			goto again;
> -		if (ret == 0)
> +		if (ret == 0) {
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, end);

Flushing TLBs after dropping the PTL ... hmmm, that looks shaky. But just as
shaky as the other stuff in this horrible, horrible abomination of a function.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

