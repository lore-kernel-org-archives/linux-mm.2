Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A816606D54E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYw+Y5g5
Received: by kanga.kvack.org (Postfix)
	id 5D7046B05D3; Thu, 12 Nov 2026 09:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEAD6B05D4; Thu, 12 Nov 2026 09:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4D16B05D5; Thu, 12 Nov 2026 09:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9126B05D3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:34:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA36F1C1EB7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:34:24 +0000 (UTC)
X-FDA: 85426712448.30.49735C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C946180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:34:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYw+Y5g5;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794494063;
	b=z8GAB/Ors5SJWjgIH+nXmKkLozMWqBmdnC4cORfaON2wqC2Js2RzRP69hvOvbAfZTdWVA0
	UHa+MvvA1vKgWrw0am5D1JHPXs5TMLh2FRUR51kgEzXJ74+Qelor8OCEsBonRLHwPU2dTg
	Rl4onIek663dulJvMEJ+/1h6FhuCz/s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYw+Y5g5;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794494063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLmrGBLIWl1ASvJcUvds5+aGJW/ZT+3+4c5mJcBaLgo=;
	b=i0tH9pDEG1EqaHKLy6Gtxssk2ckqU2IpqSvSv2N0FrKO3ChPiF4LTPh2yPH3QVBSUbgCMp
	tncG+qoQyKifYvM028G1d3yah9IsddtrbBxcEgu4YboAnSqRz+TCI0fAxeMqi1aSSXNWnC
	obcbYOxtwOGopZn0mvbG+M2Sgt8KtEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DB9965871;
	Thu, 12 Nov 2026 14:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0041F1F00A05;
	Thu, 12 Nov 2026 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794494062;
	bh=PLmrGBLIWl1ASvJcUvds5+aGJW/ZT+3+4c5mJcBaLgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SYw+Y5g55tXcxGIospu8+1z27xVvAMZw2tjzdoMxe47TIMe5HetQl4QWdF133IPoA
	 BqM8lDlHsw+Ml8XhmLUHSapr6iHdcLhIjTdUJnAsn0orTun1eVoTzA3PQtz0ukEGlM
	 gkpiO6jR4DZ11dTsFVugUmSDuPCALrNu6vTXAHxcJfWtTMEPKDuUqjoS6X1bpUVWmB
	 UjESldenidkLlsBrJiHX9zhr8BieGqomu7fS6eaZIYy1C+X8Vn/O9JOTTx+pWKPN4I
	 eUkXXyZ5vaGujt+tbNOF3GL3aNTH7uvj/aDwXpA5WSXEwarSme664SeruGsnDjWeyE
	 iwKfkLmMrDZDQ==
Message-ID: <58ea8025-f8ba-4e48-83c1-b17998b80484@kernel.org>
Date: Thu, 12 Nov 2026 15:33:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm/gup: limit pagecache folio refcount when
 grabbing references
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-5-318625d63a98@kernel.org>
 <avW7MFzYJJZ0B85d@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avW7MFzYJJZ0B85d@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h9z556p48mumr1yxj9x4iq1rkfsadawi
X-Rspamd-Queue-Id: 0C946180003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794494062-753192
X-HE-Meta: U2FsdGVkX1/ZnsqkphuEIbxKiqXlllBBJBYDEmDVSFltnGKarU5TG8bpgnevDKYUJkT2GIa1tUr0bGMMOsIcO8U/6WXAJWKqO4IUUS4IqH8VbcN4ISyqOIzfJSDOhgJRHh0S7n9HT1vJvtT2lguZREcW7Cc41VPqk7SPDhuswVFqeF94tOWo51Cdu0Joq8T/n7kWwrqo68EwNdiq7uSChvBVJ8mb0duOTQA5mh6mqmndAHFfXdIKxsRiE4MyV0wMmbFVTLjt4Wg/tHo7Pm60FWA6+TBnS0/MM9MQ3SIGM+v93tH8Y5WDIvMlLxyoh2mSzmd0S/hXLKfLwvIorM2M4mC1vofSUcQqK/ETqDCl7kNyBEQj1mfWNTDbrjTRpZ0Z+e99GXuDJ3akVSgQwQHxgLJVfOzpBR/D1IU0FfoGEfL4uE6rA6qm0FnI6AE8+jOaQnBNVkVUS1vdrTmBKX2HaXhdi+NXkclqoyo7o4ixpqYOnRxwhzRiJl1hQ9/ZUxPPFWhvJu0iMW+f//KMt3dEjyoBLScW2zMyAXUkPSvVTfpzYLrRamWPRGSBSQd5eblpNRqN5r0L1h11eRR8rj6Fl8/O+cXwnntkb7yAHWsEq5yz6aH0lPYAzNl3KnOAR3F7vHSLeZzu44BV+OoDICDS4yCg+KX0cu/5zLBfCXbJvbdgSzgVQdxXfHw3K2CpNDC+hFnS8XWuPN/2+YvF6isde0NmqiBu2ovaqKGdjSwB9Qo3ity0jHUbaToN2XPyjxdN+YQQTZVYRct8wBTv5xpuCrHgI4tIXOFBAFPNeS3Jjrb/R0N2meTukp9hCXWY+6h0VJdAFK08ThPzdZhka1KyqBvUE4xgnKLWKpbae9Jc2PwkVuI6GeSivTp7/NvFXmto/DM183V8Tnz9dBvXTAXSKFkNDsdfIZJRAX0RAOax4+QwPuCQEGRaBAKzhuzQEe2mIeXqylFX+PJw3Ndx2uI
 3tuEWyIT
 8o4+qJlU64zYM816n6+fO5VjWQlm7bWsm1FbMcbFBNVuaHoyucxP8atijPT+WJJvOIuTDrr4StwO+DFDtNihwPHUEfpmeD75hux+6jhHLeCmX2J/h3F/vd5rnlqI8xFAj6RxA20ejBDKsHHOTh3pWH7TW7AjCAYe6EP3p9UEXHmJf0wIoNwchQ6oSZehYFCjgPdDAl+Yj/9c8OYiHysUNegTTUYGzZCEe5IUrEUo76kIsAyw9ZStjsRdfGJgneZOBl+42oscTBuaWs2a6e25hOnqHqa0HXpd8OOauNC22qLRTHVbgRSmi4rE5Zn9IRL2IMsOFAnt9Qx/xHgEs/5eVVUq7hy+8cXmnkpHRFIy12nBR2reYppf4iWur5f74LbsNOh6w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 14:12, Pedro Falcato wrote:
> On Tue, Nov 10, 2026 at 09:35:45PM +0100, David Hildenbrand (Arm) wrote:
>> Let's add a folio_ref_count_over_limit() check in fast and slow GUP
>> before acquiring additional references or pins.
>>
>> Keep it simple and use the check for all folio types.
>>
>> Also propagate try_grab_folio() errors when grabbing additional
>> references in __get_user_pages() and in memfd_pin_folios(), so hitting
>> the limit returns -ENOMEM instead of -EFAULT and -EINVAL, respectively.
>>
>> Keep the existing invalid-refcount warnings.
>>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Same points about funny weird inefficiency applies, in any case:

Yes, thanks. Adding a second function that consumes folio+refcount was easy, so
I did that in patch #2.

-- 
Cheers,

David

