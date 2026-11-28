Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3549E606A68E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2OFUQRoK
Received: by kanga.kvack.org (Postfix)
	id 264CF6B05B0; Sat, 28 Nov 2026 01:50:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE696B05B1; Sat, 28 Nov 2026 01:50:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE626B05B2; Sat, 28 Nov 2026 01:50:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A21886B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:50:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 961051C3DCC
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:50:45 +0000 (UTC)
X-FDA: 85483604850.11.2345177
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B9FA3100007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:50:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2OFUQRoK;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848644;
	b=cOu8QdaE94tng+C6vWVPuJGzv0p7EE0V7TgnSpiWFFPtfzZessz6qgdnOXoqdTenCD54Lp
	ac6buDtpjNOLZ0E9qwYi6NjCKBAYUrM6cvgkPsuQMsouNiliT/QRhQEpRRGhsw6VIyjiif
	kFf8WSs4vM4gQr/+Kjuye0pqgXaF3iw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOlVHY/wyAKwfQn6ewbvx7N2qcH8FDvBchLks/jIQ24=;
	b=DyiHvpHeb2pSGfujVL3KER0bPu0XLHeytWATOKQFRFlQ0cmfFewRm5U7yNtQIMu0dMMfFR
	2Tn7jDcGiAufaeBBw+mSSqPTn0kkHH0NiUab8M/t/EiTKp4UjxzX+khuTQpHz7p9Ayrydk
	mXR0hHE/QIirDRz6KsBC/MqAdzUnrR4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2OFUQRoK;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AAF643B17;
	Sat, 28 Nov 2026 06:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EBB1F000C1;
	Sat, 28 Nov 2026 06:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848642;
	bh=kOlVHY/wyAKwfQn6ewbvx7N2qcH8FDvBchLks/jIQ24=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2OFUQRoKI6wxHO5tDUu5d6QoZnR9uVTzbm81K+82RSRNJnkiTI0ok8i7sh3WvPGsb
	 pNc/QOesP1xluqeoPN1BLIpfaYLOw4bJkAJeq1PpNia+j57AZ+iSK46F5BvZhpa2Z9
	 6fLxplM035rDtgQuscWsEplqf8kat7r42dm92X84=
Date: Fri, 27 Nov 2026 22:50:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kurt Lin <lylin1023@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH] selftests/mm: skip hard dirty page-cache test on FUSE
Message-Id: <20261127225041.504dba5029c3519b9ca8b6f2@linux-foundation.org>
In-Reply-To: <20261123-memory-failure-fuse-skip-v1-1-19dcbda6e2e8@gmail.com>
References: <20261123-memory-failure-fuse-skip-v1-1-19dcbda6e2e8@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xfeqij9a4rw8zipcemensdj1nbjekjxd
X-Rspamd-Queue-Id: B9FA3100007
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848643-585040
X-HE-Meta: U2FsdGVkX1/M8TZ2DWLzgGDFcbrV210N+nXAJq/vCy6+y6tyXgga0HVWotMwlXNQg7tZPV81JYe4VFfY3KkG31fW+DtTg2Ag2bXrLBOaN7p4//4BXUOfbF3CB0mB8NBY2DDYKMTD8iWl4xL2QOs6xDjIg9bvKecwv4BGMdmQnR9xgoEFp/r4yvsDKxEVWHQN4S3brFEVmRu7vJbIcO0/Pnq1xPChT67QlQYbdtVazyZIYg2EHY/85mQ4jth2XawDpDt22bZiPtCAPdPLzfotEzURApi1tbfr+kz2bvq6EBPe8yFbJ9aaLLJ278+ioDehQLdV8hjVSolkOEQV+oZnQbXFMnm4J21jQV2XK9uEotS58f/hGQkmu5zgA4w9ofst06S+3pdH8eGR5WSa+NPNCCjglNsr88XItUGBQYwwXqn/71VxyhnamODqC6GTCxURImGP5djJIPjO309gjLsXG2IyG5VmBqQcPlA6YcxbopohYWYxFgLhs43e/G1j02pQEJVGlkKvloVZPr9AH1yI89VldqPZc1MKmxL1XKdiSB34HirlW3ctdolW8WCwG2a9PzaabINiZY80JNQRMxFMGV6VE5CTtCtfEV/H3WLQDFqhYIHAWYaN7lIc0vDXcHN6JH/GC0XVTQ6K4V2nZhGjzKra1iRoj0aKC8YSWFEYxN6pYVyNNTTZjS/7J+aEaXrOzRGzP6Qg5dixT7XPCsJOK2JYM3il71swNj9ux8xhp3dXZ77c4mS1FIJAuqChXlvZTenvsfcJh5DyIwdmAqI3ktYwaUd0eVKOz2aK0t4hLf4pMWpbWRhA5sJW1OoMucNM8uvJJ0zdtnUQApn7yJ6PqI0TDvPa0OckyePqcvQzpbAuZA6ORpsw4MUwYldvtiG+aHEP/kkfkmVHlWSnrWTLz/452jUbczIQj+AMG5WYgAhyhKCMKDqevNDNU6No48TA7gTKmsERSILjGLjHL86
 229hQAo8
 RtMcDE20F6EjVw0AuTohuWkAAvpdBracY4jzFhXrycCrlAKbzzSNPgkoziIzhchY5jAcYxNLEKy7c6yrjV5fkOptl4aC7YwS/zYvRBwa7Zr1rYsfuQkcJoOjNwlZgIWHYbT4BuvyS8/60ZZSR7Y1dP81EmNCgwAGY90J9+gEvqCtXqVXKtwKT4D7oGs+L4SOJ45gesX4wa1BH2rZ+eYSAj1krU4FyXbs8PbnY2HyZdPcrNGNTSZdi7H9pOrZ6BAM9Y7FOWiCj+nTB2XT6i8Av1WaEqGD5nSPu7WZWZcMlPhCovC3JSbIXo7op97P/QRC7ZPu11VMxneKMzySvVq08z6lmCLUaYnhK/HEoW5hJnVzLkxGYrD0GVLIIhT/6teKmTYk8jJ6uOm3xGPaEK5nbZ7mgxOmp7cwsS7qME6t1s4yRuou0ALxDWfP19pJsWzebG9CLACZFD/s3A/ya89tpb0Qd5NyEDBETDd5i3Mb9+klhuBNH4T7MGTMh77Cdde+7HxRSx7ev4Oiz06GyDm0Jwp+34A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 01:58:43 +0800 Kurt Lin <lylin1023@gmail.com> wrote:

> Like NFS, FUSE reports on close() the -EIO that MADV_HWPOISON records
> in the mapping of a dirty page-cache page, as fuse_flush() calls
> filemap_check_errors(). Run from a virtiofs directory, e.g. in a
> virtme-ng guest, the hard dirty_pagecache variant fails on its final
> close():
> 
>   memory-failure.c:389:dirty_pagecache:Expected close(fd) (-1) == 0 (0)
> 
> Skip it on FUSE, as commit e14e52a7ce02 ("selftests/mm: skip hard dirty
> page-cache test on NFS") does for NFS.
> 

That test is broken :(

> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -355,11 +355,12 @@ TEST_F(memory_failure, dirty_pagecache)
>  	fs_type = get_fs_type(fd);
>  	/*
>  	 * MADV_HARD poisoning of dirty page-cache data records an expected
> -	 * -EIO in the file mapping. NFS reports this error on close(), so
> -	 * skip this variant.
> +	 * -EIO in the file mapping. NFS and FUSE report this error on
> +	 * close(), so skip this variant.
>  	 */
>  	if (!fs_type || fs_type == TMPFS_MAGIC ||
> -	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
> +	    ((fs_type == NFS_SUPER_MAGIC || fs_type == FUSE_SUPER_MAGIC) &&
> +	     variant->type == MADV_HARD)) {
>  		close(fd);
>  		SKIP(return, "unsupported filesystem :%x\n", fs_type);
>  	}

I invented that store-errors-in-the-mapping thing about a million years
ago.  It was never intended that close() report errors - that's silly
because the file might still have gigs of unwritten dirty pagecache.

If a filesystem is checking mapping->AS_foo at close() then that's
quite misguided - it presumably works for O_[D]SYNC-opened files which
were dirtied only by write(), but still no good if the pagecache was
dirtied via MAP_SHARED.

The way for userspace to check for errors is to run msync() if needed
then fsync() and check its return value and that's what we should
(self)test for.  And after fsync() has read and cleared the mapping's
AS_foo, a close() should return 0, so we can selftest for that also.

And boy you sent me down a Sunday (then Monday) rathole with this one.

I ended up with one nice clean patch for memory-failure.c which makes
it work for all well-behaved filesystems.  Then eight patches which
pile in hacks and workarounds for all the weird/broken fs behavior I
hit.  The end result is that this poor little selftest gets "pass" or
"skip" for all Linux flesystems.

I have fixes for a few filesystems here so if maintainers merge them we
can remove some of memory-failure's hacks and workarounds.

I'll hose all these patches out in a sec.  Probably it'll be best to
fold them all into a single patch.



There's some really bad behavior in there!  Responsible and careful
userspace which cares about its data should do:

	write(fd);
	err = fsync(fd);
	if (err)
		/* eeek, we lost data */

But in some cases, the kernel is lying to userspace.  If data was lost
due to dirty pagecache memory-failures or even to plain old device
-EIO, the kernel will report "all safely written back" when in fact
userspace just lost its data.  This is a fundamental data integrity
flaw.


