Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E40606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gQEWG2IB
Received: by kanga.kvack.org (Postfix)
	id D0CE66B00EF; Mon,  9 Nov 2026 04:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE256B05B0; Mon,  9 Nov 2026 04:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADEA6B05B5; Mon,  9 Nov 2026 04:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 813646B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:30:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7C65160606
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:30:52 +0000 (UTC)
X-FDA: 85415061144.23.BCE947D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 055B440009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:30:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQEWG2IB;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnLuB1koimLEfQ+FWHiIsUD83n76RtlgKdSdoCMVJq8=;
	b=e54unyOrQoJUe+zfgfxRkDPM1q3DAkcEf8O6COAqNfr+iZTwq2ZEm2TuIp6BiN4SAnJJVw
	5jl+xT/ygeO5ZMem3H/FDXQgS4i5FIxgEPinRlpbCEW0FsYWZt1zZ6F1yg8HSq5y+2yn0k
	6xNwGMXI1HuTmMHZSc9Mi43PLFholLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794216651;
	b=GzMaMUNEQxcf6vr/30BqAw+I20yTft1u8uqhrhFzDiPUY5hwb+uImlnEg9vQuZPRdAZeCs
	PBz87HSotJh3UdRSP6K/k3AeFXA/dQAuItXGt8wvbBiSIKgsVdErHJAMtA8ZGrr6ZQE8Hh
	rfiNP/wFOFgzWhE5R0DMH+i4Js6zZDc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQEWG2IB;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2685642AD9;
	Mon,  9 Nov 2026 09:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFC81F0089F;
	Mon,  9 Nov 2026 09:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794216650;
	bh=CnLuB1koimLEfQ+FWHiIsUD83n76RtlgKdSdoCMVJq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gQEWG2IBcfNstZNIv1Xnc+lP4lR+pAahDXpU3RGCGBOMinSgmiwz75vj8fKpk38lN
	 kH5xmhCQZgrfUViEmJt0bM3/0Hor4tjeJmlNYBbO/RvJR7wCGR3z5orTe1/+Q344wH
	 Xurgc6ggije9UGeZylAM9cpTVpGpRrlb8fi6hWTxUmoLE+Jgrp4MdWUQqJMwaeXhBO
	 js93YjM1f/w5NEd4CwqPVdYJB27S2BTrkOSR9Covkf3vxI93K8oMWcdtXGKhFihX/4
	 CZjLSINByS89lCwi+7uv1mzc3Ky5AcyS5UbzVMnwcZNOqjwb9Y0UPtG9D8qW3T1D3i
	 eYTeMcCM3QqBQ==
Message-ID: <8d23b1eb-72aa-479d-9486-dbfd86d8414c@kernel.org>
Date: Mon, 9 Nov 2026 10:30:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
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
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
 <a9fb2d3c-d518-49d3-9479-a25fa2cfc5b3@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a9fb2d3c-d518-49d3-9479-a25fa2cfc5b3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nk43uan9nhxq3znxgymc1zf3dzi7qhr8
X-Rspamd-Queue-Id: 055B440009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794216650-816959
X-HE-Meta: U2FsdGVkX1/MQFtZ4XRYjMaCpxLnUojHsAHIRIGNj8BKogdTC7RkBGuDCNMIm/gWTqixf1DWKYG3iPUrIRQyNJMAGEviUU9ZzvORtag64F14KDzZCZWlpdBMmOswI+d5ybn/fAw8bxLcg6KHzC+ey74wJCnTFjCrptVYEbCQsUAsx/cvdWEScrwrSGOV0UPB+b6v6kc13Sumaz7/cMZK2CwAuoOmuBuxsn9FK76TD/2msgvgUHWjef2spN2TJusmvvLhJa1pXuYgw+SMLcarEfEGHKPN+2Ob+2X+4PL0bCiB+XHueEqO37Bu/3evXGzbEQv8GyMNGbtBjm3gb/h0Ct4IZ9fepVzKpJLa2vOTPt6AeesBbej+qa5edaPR+NGqTmGcpQPcI5TsjtMlnZLaXTj5aBEPxKJJfc3+zTFZSXcXhSJsCtp9jpT1ZQhXIL7uWchiLWta2BjCJ8M9Zn9vlPjAX0vJg2NGIQFnyuqiApNaWK2f7hAiwA2yGKGb6hqeUMLD7mso03EZuuRhzW2aWrRP0BuiXBHpQTGQGn6x7DFWAkJ43ir5DEf/ULq5yFoIJcElea7uH8l7fZHQyv5zFLl5K7pKdzRSJP3NUpkyv6tfA1/zGBeRqfTOxIXF31ua1zUiL0ofXTxWduFp0tX0M8AIRgADfVCHkWrwi38L5bsD5teTh3crdrP304fm4gBDyT1UIUcNhBW/Jm9Z7SRiIENNHqxO1vax1TJik9N6/vgYpO0CIUMoV3/SbF68fWyrfqdgvsHtqL/9sCEDVAdK1evJMKZfHDU7SuB5UR8MzTnJ/DHg2sdiSFS4bMUDEEEs8SH5bCwhW/JWA5ysf3KV4np0c1fsbhtYZ5Aw4NsarF3JbHHuj70EPVUSYAqaEly374p09+4NmdViROwZF7dNzcZV+z+NyFDrtpTmk8teg23KV7gd2K7+Sm6YduD4RO4gL+z2MFrwRYvfb0qrEI4
 AYeyt+ZH
 FZISCW4VYHdFn8UMT0BXsyJs4m0Nw3Ito1dgaurlWYhmFfKBN14xMY9eHEaXYRIxthO/pLJ0h5Pt0rTO/F+vwnrwq/y0AdPRR8xhOsw7P6APQKUlOkB5+TAFsiikgWgoBruZDT2GXSPAQcoSV6z4uykH9CZKLt0CqakZNVF0EhKBvpyrFCjxRVWL9zKg/zqQX+D8ZedwWyFtZ0P60LNNzvZouc5Zv0LNCKLZJwV6pdLl7oy2et4NCqWVzjtIpcTXKdUS+5FLXYsp46W0RSF5e5aW6v8R//jcT0YdxePyzzhXGUvVLc/d9Xmyynj9bE6pZvLhSrRtHQAQtw5Kgrg2TSMAWHOVnEa/ptyIE3VWLy3ZCjQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 09:57, Jose A. Perez de Azpillaga wrote:
> On 11/7/26 11:23 PM, David Hildenbrand (Arm) wrote:
>> Similar to mapping pagecache folios into page tables, let's reject
>> additional references when splicing folios into a pipe if the refcount
>> is at its limit, similar to how we handle it during GUP.
>>
>> This will prevent more cases of possible folio refcount overflows with
>> large pagecache folios.
>>
>> Let's keep it simple and check in the two callers of
>> splice_folio_into_pipe(). Return -EOVERFLOW if the limit prevents any
>> progress, so do_splice_read() can fall back to copy_splice_read() when
>> read_iter is available. This keeps sendfile() and other splice users
>> working when ordinary reads would still succeed.
>>
>> Also fall back to copying in FUSE when taking another reference through
>> fuse_ref_folio() would exceed the limit.
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
>>  fs/fuse/dev.c      |  5 +++--
>>  fs/splice.c        |  8 +++++++-
>>  include/linux/mm.h |  9 ++++++---
>>  mm/filemap.c       | 11 ++++++++---
>>  mm/shmem.c         |  4 ++++
>>  5 files changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index 3641abb90d6bb..4f6b7b42bfd3e 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -1265,9 +1265,10 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>>  		if (cs->write && cs->pipebufs && folio) {
>>  			/*
>>  			 * Can't control lifetime of pipe buffers, so always
>> -			 * copy user pages.
>> +			 * copy user pages. Also copy folios at their refcount limit.
>>  			 */
>> -			if (cs->req->args->user_pages) {
>> +			if (cs->req->args->user_pages ||
>> +			    unlikely(folio_ref_count_over_limit(folio))) {
>>  				err = fuse_copy_fill(cs);
>>  				if (err)
>>  					return err;
>> diff --git a/fs/splice.c b/fs/splice.c
>> index e6d43329ed3f0..df73a4e65118b 100644
>> --- a/fs/splice.c
>> +++ b/fs/splice.c
>> @@ -956,6 +956,7 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>>  			      unsigned int flags)
>>  {
>>  	unsigned int p_space;
>> +	ssize_t ret;
>>  
>>  	if (unlikely(!(in->f_mode & FMODE_READ)))
>>  		return -EBADF;
>> @@ -977,7 +978,12 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>>  	 */
>>  	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host))
>>  		return copy_splice_read(in, ppos, pipe, len, flags);
>> -	return in->f_op->splice_read(in, ppos, pipe, len, flags);
>> +	ret = in->f_op->splice_read(in, ppos, pipe, len, flags);
>> +
>> +	/* Fallback to copying when hitting folio refcount limits. */
>> +	if (unlikely(ret == -EOVERFLOW) && in->f_op->read_iter)
>> +		ret = copy_splice_read(in, ppos, pipe, len, flags);
> 
> here it can't tell where the -EOVERFLOW came from, if another file
> returns -EOVERFLOW (i.e. tty_fops uses copy_splice_read, and
> n_hdlc_tty_read() returns -EOVERFLOW after dropping the frame), it now
> gets a second read.


That's what claude told me during review, and when asked whether that actually
happened in practice it said no ;)

So is that actually a problem?

> also, the first read already lost data. so the data
> read returns different data, the dropped frame is never reported and
> returns the next frame instead.

I don't follow. Can you give an example?

-- 
Cheers,

David

