Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD3D606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U+OJHXap
Received: by kanga.kvack.org (Postfix)
	id BA00B6B05BA; Sat,  7 Nov 2026 13:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50916B05BB; Sat,  7 Nov 2026 13:16:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18C26B05BC; Sat,  7 Nov 2026 13:16:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 735246B05BA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:16:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05B47A03C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:16:26 +0000 (UTC)
X-FDA: 85409127972.22.E2B2CEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 334ECA000D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:16:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+OJHXap;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794075384;
	b=DyahkpIVo9ncDvR0vBc03/38lOdWqD2ixs/IPtggqOv6rMAMuZcamYzEby6SV8qDU2oZtX
	DcSYD8HCZ7XGVYVZPgWwysEW3JaQIf/5l1bH17AT43xncXGeE4+Uk9qJ8GQr6ymKynZO2S
	hn3ahaPLH+gj8AVl6gjBL2frFKjc8hI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+OJHXap;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794075384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcbqNqcpzKvUfzgtHCXNH24af2lOq+kn030ftGV9OnM=;
	b=GNn9dmO3Jc0sLxnyfys/Hc+9ilg65fRIzmEzdhYfmPMHO+o1UhYkXpFwpdGQ2sK93ONkoo
	CghiHOGxcpwMGojNDp3JmbSGDwxsUB7MGXtsKYCn8LJ1IiNuFFAWGj6QxaFnZvNX0HE3ql
	6E0LTL6wdzQWeg1SKCK5wpXlLUFL+T8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C4EF605C9;
	Sat,  7 Nov 2026 18:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472851F0089F;
	Sat,  7 Nov 2026 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794075383;
	bh=fcbqNqcpzKvUfzgtHCXNH24af2lOq+kn030ftGV9OnM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U+OJHXap11UuKLzVJkpfDYMFmCFzGDsj8L0KjObdN00RCCvLKYG7gerxG8aJ6wXIt
	 uV2K8X5IBMvcO7r0dglmzL9BAMh0DNe5KXy18EHEQh7F93oUdsMLNpyL1LXQQjNOud
	 vS0whWN6v0rUDd0fehPKXz3oRZWnFr8muUc07iODmAyKQkIztI93RX/dqtRCTBk7yd
	 2rDW/sm7aMdJ5R/WEGiXgJQ4sX8VsvorAn7AKgPz/zbtMHgI7zc2vJdS9AxobNz5XZ
	 HIDST2+SL1raR0o8mFqRbnu0VlMNKPLNcTS3BzU916LiwnjqjtMjuTPYQrWpaw93Mb
	 LSiJDibk+l22g==
Message-ID: <c15e171b-d0c2-4808-8d42-e5a650b03150@kernel.org>
Date: Sat, 7 Nov 2026 19:16:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA
 expansion/duplication
To: Junyoung Jang <graypanda.inzag@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Hugh Dickins <hughd@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
 <c243e6ab-3eb9-471c-9b6e-91064528ce82@kernel.org>
 <CAO7ntTQGLNtHiu3SY+6HaRZi5gimqjbmw_FoeTSRYpqi1EbnbQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAO7ntTQGLNtHiu3SY+6HaRZi5gimqjbmw_FoeTSRYpqi1EbnbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1wqsknqrm9tn1gyk6m1psasoumqxd13t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 334ECA000D
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794075384-275230
X-HE-Meta: U2FsdGVkX1/Ztfok0t6GJ7M/pJO0aZZTXek+xaoP6O5SNI0MsOTUMz08aZPiUjQWwaB1/8thN5jtqqM3rpowHME1H4YVHxtlyN68wC5CY1U9SN8t0nH93p1WHJJ3/cjkanylc02bRhpVLCColw09M5ueERjGVUAoLtFJSpxgGx9giW3zo2y9MzufMtMJrd61ARvCANAsmEbIz4GfMGQxpTSRAsjOUEMK+aQQN/E2wT6ci6lVdBNJrZXTYE1ivj57gRF2J3VU1D5lmqtelXS+CRGgfDGSeRH0L2Gl9tMoBrZhS66QMCFDU28116Kv0zh2zQsGL9Hmx45yWUsmPEQTas8Uzhw+3LhFjYLeFJuF2bjoFw+cgJHfWdyf+NBkDpKdEa7qRKsMcJjw9oqvqT58vlVUcK6MoL6Wp2Cw13k9Qu3U2SaqdiXJzWNJG2mQ8eA5OLUT4osuN/n1X6+yU6z2hn5IGTG4NQQnFYqkL3GQYLkNaI9+NfWQW12mUU4SF9oISZWEV7eMKJcgSXtwkHvQwYNgWCDBlAswNNA3El2oqqZBXwroJwOLjZxjwOpD5GFTvfdx8Cucr0h4pw94tXYp+lT50CgNbfU48l/bqzovHFKEc0VU1JcAQkpdBbSWw36nbSp6bcQxfDPaGktj4f4+6if7+K2euKQnthFLoW0Ht1L5nd1KqGfL7lBDk8Te0m6d3DnUu2fUumGat0B46L1BVdnYCowGapVxVLGWjkCZylxvzbW85jAHP3d0afKO47WcyIz2Tj8ZOJqKFWBGelew9Uqf+GvB8VXha4bx3D9b98o+biWhLy9o8oyjV4fhtf+C220OlzDyV21eRpNJv4X9Aix4Lv48udhMakODALnRKspctSdZQP2smainy8NJ9wdWVyyhp0BP+3QVlnFriyQhv25vX02V9ipq9UVg1SqhZiSwcr5NhuuiX5Mp58z0KAxIvx/J3/J2l2yNF4hqIEe
 ROK1WYfA
 Miuj16yQRfI5z+xJVksz5+BVY//zg0nxzqi8HnjjkJcY5CclfATjnKKgxHPVmJJiAsw3xWhVo8g+zPQdmL7Dxxf+iFhj6BfcWKKaQxYjPgnv2awYlVTdULUc3v04H06R5pymZeIq+mUsMK8mrp8yc7MsTZJ24equPGCeGVuDkY/A6XNGSowk6P9x7O0qOxWg3qvFp76a454vVaF2trnUAADtF3NCjJy3gap++7XWjyCZ9U0AYqWD+dfpk0iALosl5+HFtAgZKG5YcPm92C2wqeySaqxJwvOnKeYWk3ntEtSs15eG3u98CYwHC89229AjlybHwlrkrdoUiTugHFdye1xVmdDOz0I8kgyHStB5PIngkNyaaxWMUOOUx/SaNN3g4Iz3ygL5F26L3QXB+1hcSDogp1QaTgZSLnT6ZYnBJO8HtnoDOuqq/AA2pYB/VvRgIxFbYu+/OHgZNiyjZhOAG90lNfTrRvc7sVm3tYD7Kb88VuwU6T8CxwWA31wyEOpith0+DMR0ATzgREE0aOThiKZ2yLaQQID5j7YMN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 16:19, Junyoung Jang wrote:
> On 11/7/26 04:07, ... wrote:
>> On 11/7/26 04:07, Junyoung Jang wrote:
>>> Hello,
>>
>> Hi,
>>
>>>
>>> I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A process
>>> holding a one-page shared writable memfd mapping created before the seal can
>>> use mremap() after the seal to gain writable access to additional file pages.
>>
>> F_SEAL_FUTURE_WRITE is not really range-aware. What makes you believe that it
>> would be?
>>
>> I'd say it's expected that if someone has write access to the memfd, it has
>> write access to the whole thing, not just some subset that was obtained through
>> the initial mmap.
>>
>> Any documentation that made you believe that it works that way?
> 
> Hi,

Hi :)

> 
> Thank you for the quick feedback.
> 
> My understanding came from the following documentation and commit history:
> 
> 1. Linux man-pages: F_ADD_SEALS(2const) / fcntl(2) (under "File Sealing" ->
>    "F_SEAL_FUTURE_WRITE"):
> 
>    "The effect of this seal is similar to F_SEAL_WRITE, but the contents
>     of the file can still be modified via shared writable mappings that
>     were created prior to the seal being set. Any attempt to create a new
>     writable mapping on the file via mmap(2) will fail with EPERM.
>     Similarly, an attempt to write to the file via write(2) will fail
>     with EPERM."

Note that "mapping" here means "file mapping" not "folio/page mapping".

> 
>    (Reference: https://man7.org/linux/man-pages/man2/F_ADD_SEALS.2const.html)
> 
> 2. The original commit introducing F_SEAL_FUTURE_WRITE, commit ab3948f58ff8
>    ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd"), which states
>    that the seal:
> 
>    "...prevents any future mmap and write syscalls from succeeding while
>     keeping the existing mmap active."

Right. The thing is that somebody that didn't have write access to the file
before (through an existing mmap()) won't be able to gain write access (through
a new mmap/write) later.

Expanding mmap() or mremap() modify an *existing* mapping, they don't create a
new one. I think we don't guarantee that expanding mmap works, but mremap() must
work.

> 
>    (Reference: https://git.kernel.org/linus/ab3948f58ff8)
> 
> 3. Linux man-pages: mremap(2) (man2/mremap.2, regarding old_size == 0)
>    and the comment in mm/mremap.c:check_prep_vma():
> 
>    mremap(2) documents that when old_size is 0 on a shareable mapping,
>    it behaves by "creating a new mapping". Similarly, check_prep_vma()
>    notes that "!old_len is a special case where an attempt is made to
>    'duplicate' the existing mapping".

Right, the relevant part here is:

	old = mmap(NULL, page, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

and later (after sealing):

	expanded = mremap(old, 0, 2 * page, MREMAP_MAYMOVE);

With your reproducer:

$ sudo ./memfd_future_write_mremap_poc
writer uid=10001; mmap=EPERM; pwrite=EPERM; mremap write=Z; result=63
owner uid=10002; file page 2=Z; size=8192; result=255

Assuming I specify instead

	expanded = mremap(old, page, 2 * page, MREMAP_MAYMOVE);$

$ sudo ./memfd_future_write_mremap_poc
writer uid=10001; mmap=EPERM; pwrite=EPERM; mremap write=Z; result=63
owner uid=10002; file page 2=Z; size=8192; result=255

So same result. What am I missing?

> 
>    (Reference: https://man7.org/linux/man-pages/man2/mremap.2.html)
> > Combining these references, I interpreted the intended invariant to be that
> post-seal writes are restricted to the pre-existing mapping itself, rather
> than granting the process blanket write access to the entire memfd.

Again, mapping talks about "file mapping", not "page/folio page-table mapping".

> 
> In particular, two behaviors seemed inconsistent with the idea that the
> process simply has whole-file write access:
> 
> - Even when holding a pre-seal writable mapping on page 1, the same process
>   cannot call pwrite(2) or a fresh mmap(2) with PROT_WRITE on page 2 (both
>   fail with -EPERM).

Right, but the main challenge here is rather figuring out whether the process
already had access. We'd have to scan existing VMAs which is just unwarranted
complexity for something nobody really needs ;)

> - Calling mremap(2) with old_len=0 creates a brand new VMA covering page 2,
>   which appears to bypass the restriction against creating a new writable
>   mapping after the seal.
> 
> However, if the intended design in mm is strictly an mmap()-time check—where
> any pre-existing VM_MAYWRITE VMA implicitly retains the right to be
> duplicated or expanded over unmapped file ranges via mremap(2)—then I
> understand why this is considered expected behavior. If that is the case,
> perhaps clarifying this in the F_ADD_SEALS(2const) man page would be helpful.

Correct me if I'm wrong, the only confusion is about the mremap() doc saying
"old_len=0 creates a brand new VMA covering page 2".

And you seem to assume that "new VMA" implies "must be rejected", whereby we
already have a writable VMA there and there is not really a reason to reject it.

-- 
Cheers,

David

