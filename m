Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49BE606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L63UwzrP
Received: by kanga.kvack.org (Postfix)
	id E4D136B05B7; Fri,  6 Nov 2026 17:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25176B05B8; Fri,  6 Nov 2026 17:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A116B05B9; Fri,  6 Nov 2026 17:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE2456B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C6CEC0225
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:42:54 +0000 (UTC)
X-FDA: 85406170668.21.04C351E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6FB9F160005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:42:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L63UwzrP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrGWYrqGixJhZjc6cA3u15ineEoMPVTqbCNBS3vO/E8=;
	b=YqQ1Pk5Dlci+5/3KqA7iDHdx7dxch6mywEaOwdpSOrwzfBzADeU+VjKiJYcV94QiKRRSg4
	1nrYL0In33ELvDnxqGwH8wy/JB/erVFQd3K/y59BMrzt3TKJUpiQszbtsKGTRe0sZcjuYt
	X9D0OHS96zmRqcLo5a0wdiSBE/W9bSw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L63UwzrP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794004972;
	b=Q11wk3/fzbcbpFBSNPFfDMuGQ53+LI0ffumVnoqoHHjXmoV0cYo1dSTv62rXuBom9SZyKB
	6YOpVMzBNqEIcbfYSd5bM1u9HgQx8QyV+1f0L2vfriBJz+NOqm8kXd8dJf2xHLy9bO3EYp
	79SsJB2mHQK9CptaVirfuHybMK6z6ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A87114183D;
	Fri,  6 Nov 2026 22:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019D31F0089F;
	Fri,  6 Nov 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794004971;
	bh=xrGWYrqGixJhZjc6cA3u15ineEoMPVTqbCNBS3vO/E8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L63UwzrPS2ataztpBxby6ngbB/ads9+t+yjRipL316Dhw0VSCOCocujlpDrXQuR92
	 8cHpI5LF473Ryale/9WffhFi44DKGSYK/ZKvCx/DE/l3c1ItJmN6w0NuBhoDgnTVim
	 R0DJ5yQCaHR1w6HEmo9gpud9qnI/d42WwKGteXUoEtngqrw8LxtvSBXHqCXAOCRQK8
	 DCWqGNxp8pGnD9fk5PGtMcnSu4BYj3TXiWyH31as3EUW4+fGpL7NWJmAsPyq4O1QVu
	 UWgmOZlW8cQq63VBB2npIDRUKf9QYGivudLkoE0YWyW/Nw19B2w3UDUxxAcWiNZ6/d
	 Zm3KgmdtNVSrQ==
Message-ID: <9c86902c-b942-4641-aee0-672adcc84823@kernel.org>
Date: Fri, 6 Nov 2026 23:42:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm/gup: limit pagecache folio refcount when grabbing
 references
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
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
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-5-70b9c655da3e@kernel.org>
 <4763a039-60f8-4263-8124-beb0f9ab3366@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4763a039-60f8-4263-8124-beb0f9ab3366@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6FB9F160005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: oz5zrno55pp349msut1w5j8kdqxc7c7b
X-HE-Tag: 1794004972-962514
X-HE-Meta: U2FsdGVkX191GrWp8JL+dAcqWNiS0aMCOxfzWMxTPiplNQHm8ctdLxNM3f1aHbwSZ7rPoYwJ8qGYFKzEVZKFC8YagItWssWvNFz4NEE8mRIjHQzFSzm6gaNAKJu5A5ORjL248H+fGcsp9DKnsirOu+rpDIN1Wua/G3Xgrv6GCaN59DkJPgYKQ7u/ieJvBTgTp+H+xJjSDMgeaAfoxNZwQP+4C0kN9TaWqXrLpWf1fhQG1gYul2/E8/olnjlLnsq3pozZ7JVMjbiZVpCED1TFcRXPkizW442gK48m6QhgWrafhT8iTRd5RK3dkmF2JxLj7wtmTIv2cKjwc3AM1xxdx44B/t1aYfIFp7tvpcpsinODPm5stBD3ZbBlcTTTBNEnqzz9Jz2YiyxasGfb7TEpy9/xIjOo5qHN1BDDFaPWE46X0sW0Fuaz11/MWEgyEA4K68ztnnVAiuQ6ExuexRI5RYOmmm//Sm6jPVFKCoJ08+5pC6Q0k6HZA/PYGxB+/pD8ithQW+ehUAvrpiEe/XEq2oUWUW1tdXAHC4V+A4bXodkmlEem51+i2xooDEoP5hdtzgZlwjYvckN1WlSfJu0eeaAGncwEy2dWPoI1yd+IQ6dqy+2cjK3Rl2+tqMjX51UvbeSXE3h18si8Ak2eOXPqJJrNfdluvNXC9bWBU3oVsd5iLXRYQx2XefmZgCqz9yIr0Hsq3fyxZuWneLjKHoluYTLJRW+1v8uDJeuH7JNJFNbtv9cruHsngaRx1ed5D3A/5zfroy8G1WCGzn2uG5N6MLDlLIWIZpWHrr+TGkeu1CQNtAn2LHIpqzmrXXEytZFjOsFHytAj1pULlOxPF0xIsjS03H+qf3k+jKsEcmVSdGYtH6bAgzo1Xb9FWPyAxjQotGYQhxJhwz+nKiYpSKd2fS7dgWOsTAaJ6zazRyafEYRUccmye/L1v2a9hNSLjCZMUbmB4oMFyRh/PseI1Ms
 01UB5u0c
 vfcaFMtHielFrqM7gnCkx8wDintiVjl7+C8m5F9l4TxAIO5TXb2jBzEWbcHnaxmfpBXjvHvfHTBF9bTj83glVplqgnDy2GJyHwpCpJ8YGua0mPSvhBxvmLglVyiYJfH2yMW8Acxqm1J0oeyvR18YgcM19giTPSu8/LX7I0YSinCwvCYFs6ys/iu5aGq/FwPYKSdlVxML0JBLSztzZxGSnIxnQhJAy69Jhg07ZtfYCR2l2mBkXTpJVC8Zaoivkq7OxQi8RnHuNM2bP1tEM0jSBjdyfrHXpIxM3MFMQ71tyYCoOqihlppEiamneWC+P1Dz3FJrmzSNrNlMNUGFXGwee1h4qvtD5NVOkkQhDJub1WC+vE+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:13, Jose A. Perez de Azpillaga wrote:
> On 11/5/26 2:10 PM, David Hildenbrand (Arm) wrote:
>> Let's replace our existing safety check by the new
>> folio_ref_count_over_limit() check in fast and slow GUP before acquiring
>> additional references or pins.
>>
>> Keep it simple and use the check for all folio types.
>>
>> Drop the WARN_ON_ONCE(), because apparently these things can currently
>> happen with large pagecache folios.
>>
>> Keep the zero-refcount rejection if the refcount is 0.
>>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/gup.c | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 2ab42fc6834e5..db9db6b2a4662 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -77,7 +77,7 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>>  
>>  retry:
>>  	folio = page_folio(page);
>> -	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
>> +	if (unlikely(folio_ref_count_over_limit(folio)))
>>  		return NULL;
>>  	if (unlikely(!folio_ref_try_add(folio, refs)))
>>  		return NULL;
>> @@ -140,7 +140,11 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
>>  int __must_check try_grab_folio(struct folio *folio, int refs,
>>  				unsigned int flags)
>>  {
>> -	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
>> +	if ((flags & (FOLL_GET | FOLL_PIN)) &&
>> +	    unlikely(folio_ref_count_over_limit(folio)))
>> +		return -ENOMEM;
>> +
>> +	if (WARN_ON_ONCE(!folio_ref_count(folio)))
>>  		return -ENOMEM;
>>  
>>  	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
>> @@ -1482,8 +1486,8 @@ static long __get_user_pages(struct mm_struct *mm,
>>  				struct folio *folio = page_folio(page);
>>  
>>  				/*
>> -				 * Since we already hold refcount on the
>> -				 * large folio, this should never fail.
>> +				 * Grabbing more references can fail once we
>> +				 * hit folio refcount limits.
>>  				 */
>>  				if (try_grab_folio(folio, page_increm - 1,
>>  						   gup_flags)) {
> 
> this can fail now, so shouldn't the error path below return -ENOMEM like
> the first page does, instead of -EFAULT?

Hm, indeed, that's inconsistent. The issue is that we have this -EREMOTEIO check
mangled in there. But the ordinary path would already have checked that and
failed with he same error.

So this hunk would become:

                                /*
-                                * Since we already hold refcount on the
-                                * large folio, this should never fail.
+                                * Grabbing more references can fail once we
+                                * hit folio refcount limits.
                                 */
-                               if (try_grab_folio(folio, page_increm - 1,
-                                                  gup_flags)) {
+                               ret = try_grab_folio(folio, page_increm - 1,
+                                                    gup_flags);
+                               if (ret) {
                                        /*
-                                        * Release the 1st page ref if the
-                                        * folio is problematic, fail hard.
+                                        * Release the folio reference we
+                                        * already took.
                                         */
                                        gup_put_folio(folio, 1, gup_flags);
-                                       ret = -EFAULT;
                                        goto out;
                                }
                        }

-- 
Cheers,

David

