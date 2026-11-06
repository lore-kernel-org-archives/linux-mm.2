Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8374606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YrVHuq3J
Received: by kanga.kvack.org (Postfix)
	id B5E666B05B2; Fri,  6 Nov 2026 15:09:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7A26B05B3; Fri,  6 Nov 2026 15:09:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98AF66B05B4; Fri,  6 Nov 2026 15:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ACA26B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:09:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 824621601ED
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:09:27 +0000 (UTC)
X-FDA: 85405783974.10.8A9A7CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD1AF1C0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:09:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrVHuq3J;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793995765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYKpj50QcPFYT5hlR28ZO7Qz7JK2NgENQ8jSUlp2pWU=;
	b=wLlgv6PQBBUpeAFxbS/e4HDlDRUxrWbM6RXzssz9Lnhnyy7TYopM/59rv0d9zJYamF8EPj
	wXgbyRs3d6Sa5KXnP08euhVSsFFkBDNTDwZ7Zjn+QCMDifaMjXoijrvlP7Q1Di2xJWVBNq
	NHB5I4NID/0NWs8UOgBUO6xpZMEEP1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793995765;
	b=IoDki4dsiAZ+ehJgK/a6TYo+vB6VbOi0FFQn5W857RudGpgjotXZ/N+kYGqoFRFQ2h8MrJ
	V+mos3T1u/bOCQyslTOmocdtNlTYAaikpcekFtgwFQYOkQtsBrNp2gl5Rr72x9tvJQfOjk
	Gm2xC/vNoUyVLSaqVDY9Nilzn1l9b6A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YrVHuq3J;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E01D42B6A;
	Fri,  6 Nov 2026 20:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA0E1F0089F;
	Fri,  6 Nov 2026 20:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793995764;
	bh=QYKpj50QcPFYT5hlR28ZO7Qz7JK2NgENQ8jSUlp2pWU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YrVHuq3JuRIEd7tjBfUeT/Qk0DuNfXl4YVMThJcT80ptmZzANGzEFsALP5sxZlfys
	 ZABuxRNId9i2ezwIzNGhupGpPTeG/+Ua0IrtHAZyldbRgEphdzF0p3FPQ7z2zoF1kn
	 nnpyFnX40vBIUYmViW8+50dWaKQ2zK/tAClXS4kmgJtUsTS0KOxjpN86eOoHQVGSep
	 mHAXwv6xOdHMx1KYuOPXddB6d1cGWA8dfX7t2r/bAOguAP/l+m6+jUWmmCYirJz51i
	 p+FWCDRFD6IkmQ3s3PTHPzmFC44LSnKdiFht+QMqWssMW7YWrzR8NFKdbo6HzPrjQq
	 e3DYi6gFzU+wg==
Message-ID: <23f947e2-ff06-426d-adb7-396871304736@kernel.org>
Date: Fri, 6 Nov 2026 21:09:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing into
 pipes
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
 <n3l2cnx6d25jovloqyoxiz566mh62janclmiewjvumtmqfezo7@zmsmco5vvssn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <n3l2cnx6d25jovloqyoxiz566mh62janclmiewjvumtmqfezo7@zmsmco5vvssn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pbfgtkqafe5mrntt3unoujjx888n5b1f
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: AD1AF1C0008
X-Rspam-User: 
X-HE-Tag: 1793995765-345933
X-HE-Meta: U2FsdGVkX1/dLcXNnV4JUPHlgxIIs9hUfeK7scirHeV1EHIbLBehQPVQjHJ8P/GeNiUNadVuuBY60EU7RR49JQGwvo5ofczC+/a7TnPPhGZgHpKOg9K82VfiKQV0ZBWv097QRaThqWfs2xD7TzIhj6ewaMCjoqIfyv+ZDqQjmt4AsJJz677sLffQYvnLcymTKu2ZL1N+ixiDwn0OTzsxn7ysB/qWx5w3VP3y53tnuJYQL3ZEfpzoa5nQGxvthR/doycq4DyRBofYMpQokUbHECkgGEYURP3Avwa6HLgSLBACfl0XcojTIL4mnxsbrcOgeM8ND5jOCT0cfOG88olNDd4xbWw7VQRPYozxsU77NtoUt5YTHMD404JK3LuoKLJrmMqVC9fLsISYjYt3WTNo1NTZy9hZGm9s875AIx0j6AJiyAOBSSTzAtN0qP5RD4Hptnsm7CWIZrXFtxaErWRn2QHLU8dpkm7kdSod1klCfdWnoHABC1p/YaW3FkLu9Gzj+/pXUc1o5L7uNOemewehHzI56jL3td1dtJP68XC3McJvNbz4PfBEyawvKNIn+IgsogYhkKlrLybxKG3UYsRWGsJmcNVHRLIjZF4MXNF+sB3mdQTHnzUSHcm3Lx/xfZNpCXgBmvQuAQTt0/3B2LsYEEx5aVcx7svdUkRue8AAvngjY7vq9QShxKvVCVBLsJgwkj/B32EtO0+WVrtBS0uX9uPbJTBksMN4jatgU3GlS/VdiP3+a3S/krIw17Op2ncG5noKnUkoURl7TqJy2vVb4kcrqiXKRXRdsfj5ekPvVXkHEW8SUJgYoB5hEiGC+8h2/KYlXubKuAhrkL6Pdl0MSLw+VSVDImR64iKdeoFrzXgfec6fp8pM1mH+EpO2Nh69/xAQJizXRkCQEV/LMqThkYIp3wMdMEdHTIAqMlOGG1gMbISy58VzgiUTD7NUPXU8BtC2z6TOmX966rGYMyf
 /FVsUfPd
 JhpsEeI+hcWVkIVGhOY+Gq5/tcsDquw1OxUSRBd5FroDDosJRTyY59rjBRizaOV4nKGpBNCH/DRHhbcUZvO78Btp/gF9ySB6FOH5fFoInTC3QdzyQFmMSwdXpWYdbXWqlRdOo/6t9k5+etc5u27JoNZSJpXtNhgczJ0JliomkEfkkAmSt0mNui/kGNFzJxIUb3wiT3r2BtukXiz2JMaexkWojgDP6kcR3BDNh2jk5bwsRdh9EWdEL03gS39vhWUJVg6r7x7LyFYl1ttl3ei6o08eHW4/B7VbN4DbN1N2mmwiaIFcudKh9yIdoGP0xvZOGU/yK3kaj39wZbEKmcrciY6c7c27sCTbGo8Ue/w8m7qltaiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 18:58, Josef Bacik wrote:
> On Thu, Nov 05, 2026 at 02:10:11PM +0100, David Hildenbrand (Arm) wrote:
>> Similar to mapping pagecache folios into page tables, let's reject splicing
>> folios into a pipe if the refcount is at it's limit, similar to how we
>> handle it during GUP.
>>
>> This will prevent more cases of possible folio refcount overflows with
>> large pagecache folios.
>>
>> Let's keep it simple and check in the two callers of
>> splice_folio_into_pipe().
>>
>> Also check in try_get_page() to cover pipe-buffer duplication by tee()
>> and partial pipe-to-pipe splicing.
>>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  include/linux/mm.h | 9 ++++++---
>>  mm/filemap.c       | 4 ++++
>>  mm/shmem.c         | 4 ++++
>>  3 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 79ae8fc0d6bb4..a82cfbce18215 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2287,10 +2287,13 @@ static inline void get_page(struct page *page)
>>  
>>  static inline __must_check bool try_get_page(struct page *page)
>>  {
>> -	page = compound_head(page);
>> -	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
>> +	struct folio *folio = page_folio(page);
>> +
>> +	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
> 
> Since you're here anyway can you change this to something other than
> WARN_ON_ONCE, since that results in an OOPS with panic_on_warn set?
> Thanks,

If it actually turns negative (or 0) with out changes, we had an overflow and
for sure want to know about it :)

-- 
Cheers,

David

