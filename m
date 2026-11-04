Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B39606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UjGpG3oB
Received: by kanga.kvack.org (Postfix)
	id 5A2346B00EF; Tue,  3 Nov 2026 20:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552856B05B3; Tue,  3 Nov 2026 20:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441D46B05B4; Tue,  3 Nov 2026 20:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 217E96B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:21:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACE5C40612
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:21:53 +0000 (UTC)
X-FDA: 85395684906.03.B8AF63E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id E48051A0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:21:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UjGpG3oB;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793755312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Q5/n+lMO8hXflt+/fw8C33ZJeW4TIpqo/+mXVJXPEc=;
	b=2qLhluGAmwsnW8jXitvV8dTqmJukuguLUOscFHUZDwKEDAEYvRQUazKS5VQUApUGY6upvk
	mP/0nLCOwJVRtlb+4ZnbjYvsoKh3uIOli+qjm9pfNd9Lj4s+nU5lwKrExWn7RvNTAlfK+l
	ZAc0gzFqhMRiIRX9cTrcCsniivkhjvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793755312;
	b=wt/V7zoKjmbVW+6Mtji5zP7PkgFfMBGniOQWg+laHN2xcn3UrmRA+DzreTNKvGFctaawc6
	7u0S7PRAFLG9vxoJ+AtCPDkVXwuE1kjc8vY6TFxanXU8zkV7eUstHeIHPbsibqlS8uKniL
	T48TVq2doWjbJVWK/C0YgVOZVZiK2ZU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UjGpG3oB;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DDEC60142;
	Wed,  4 Nov 2026 01:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914531F000C1;
	Wed,  4 Nov 2026 01:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793755311;
	bh=3Q5/n+lMO8hXflt+/fw8C33ZJeW4TIpqo/+mXVJXPEc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UjGpG3oBmG7swsK9ZzyPdqaDfK2bSJXx673GJ32yahnXtcyErEZd5uEkYt1QyYNJb
	 dupMFGFBaex2t7vP8gfvw5utKKJTtTzI3wtIt7K8G9XXC3hsWIWTgSCioRoPJ7PYv8
	 HL95CDgWBQrE0B3pFRJgpmGyFguBp5Pq+B2LuOIo=
Date: Tue, 3 Nov 2026 17:21:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: fix pointer width warnings on 32-bit
 architectures
Message-Id: <20261103172150.3753dfa00f3106b6014e4d2c@linux-foundation.org>
In-Reply-To: <20261103212805.1537354-1-sashal@kernel.org>
References: <20261103212805.1537354-1-sashal@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kw41wr3h6g7dydn8q7oi38bamx657g94
X-Rspamd-Queue-Id: E48051A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793755311-934036
X-HE-Meta: U2FsdGVkX18HJZ0gw0UgQnxhkGbfiPGx+MFvrLyUAl4X4Mp53OOJ1rIHVk624nuqw/pRdSKu3EJCfZ7eWjwLuJz4VXOTHRVa1y2P8Ro4Z4O484zYOyzy0lGh7KNf8Vhru1F2cSYXCsH4qX2UESGrBMUvKyjcstIMouhXM6Yl64ZCyLwskq55Fi+mGktodYedibIJM5JcxQQwrQ1FWi3yF+PtUv5OSxr1clwZuz7RdJLFiC2Ne4v02CCOdHLiTlw9VxdxxdAJMZYswtlAAbONY/y1oFLod5nEit06WvH7U2Oyp2s+cWZh044R32dMhMInF0VvkDnUh/ubdHrgWEuVrz9opasws3BYX+Fy6LvGFbhEKV8lyJ1b/KD3QApQdIz8opdkvsLr4ewMiKlwGFSnURu0tttzHH/ggqKZiiff4gJTYMNhrKc/Q2wKCk8fMAEbHn6DkeVhQuPBU9d9PBigfbpZVZBElQ+GNjxgFn4ihnk+L7OePOV6Dn4EqMrOVJJsoZ/BAMYTp8BrL4JhKQiyiIcIe2QhsccruYkJJO2S4Ei+vpiTp/WLiBJk4q0FLHnJ+3s4QOddruf6XQCj2NzjJcAFsfpG4BD2SXHDIhAy9SUK1MAz9wRi66eymJanL+7WUkUq+nKmFgYxouSpSzUcTL+ncWqklrjGtmWEoyw9E1lBiAwaOOzMnLmPSRqByCpwdt/HOhGnKCPE1UAmngjKVHrORpM7fEnoPqmA7N7fbf69Psy+IYckLqkGUOJZEDPlxpohEGJVu3rM40Xu9fR4KbvJZNMF8ALgTM18fIlKhX2SCdTbXiUexn+rP+gPSc7t4VBlgzm+Z3FNgkoIGl+pDWJzXMhiOrd2PYUOSX8h58HZIjdVSfrZDn+20W+0b9G32wu51nzdgzIlZxb1KAW0/nVcjUcew/+rwoxuk/4W85ADsvoZROd7Q/aoDbtzV3lgNBoezcfITcgUWd9uUAb
 tFPj075n
 KraXC9YV9OiCq4HQKH7Ip3hlfgsQjyJtuAiL9MPn/jLpHhIj8jwGlowKNk/CT/CsuQASOVfNQ2IM+6cvoyoYar1RZZeZJwQQQCu5SbRwmahWCi6FEwcHn0Lm6xFsrITOK7+yXNvMZZOUcqHa2/Sd8nKBISgWg1u1wz9TiYjVrFj6PK3n7nMDOYLoMzsW/FY/44p9DOKh5I1ckNleqDwHlLBkCUQHnkupJ4hep+1JB9GSpoLrnxFMhv+V8MPV3O3CvzrnSo2Lcn/I1JuM8K4jfIBK1bw1YMwIQYGuJwYdcNvN20UsA8P+s5ZGWBN8zDTriP5nQcpOobyiB/GM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue,  3 Nov 2026 16:28:05 -0500 Sasha Levin <sashal@kernel.org> wrote:

> Several mm tests convert between pointers and 64-bit integers with a
> plain cast, which warns on 32-bit architectures, and hugetlb-mremap
> passes 47-bit mmap() hints that don't fit in an unsigned long:
> 
>   uffd-unit-tests.c:344:31: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> 
> Add ptr_to_u64() and u64_to_ptr() to vm_util.h, which cast through
> uintptr_t, and use them where pointers meet the 64-bit UAPI fields and
> the 64-bit address arithmetic in mremap_test. The hugetlb-mremap hints
> don't fit in a 32-bit address space, so only pass them when long is 64
> bits.

lgtm, thanks.  I used this as the first test case for my shiny new
kernel testing bunnybot,

Turns out, you accidentally fixed a bug!

: I compiled all six affected C files with GCC 13.3 for i386 and x86-64.
: The patch eliminated all 40 targeted warnings on i386. In a Debian VM,
: both ABIs passed checks for pointer round trips and high-bit addresses.
: All three hugepage mmap hints were NULL on i386 and retained their
: requested values on x86-64.
: 
: There's also a runtime fix worth mentioning in the changelog. In the
: unpatched i386 wp-unpopulated test, UFFDIO_REGISTER successfully
: registered 0xf3f7a000. The test then passed the sign-extended address
: 0xfffffffff3f7a000 to UFFDIO_WRITEPROTECT and got EINVAL. With the
: cast through uintptr_t, wp-unpopulated passed on every run.
: 
: With userfaultfd enabled, hugetlb-mremap and the userfaultfd case in
: mremap_test passed on both ABIs, with and without the patch.
: 
: Separately, mremap_test cases 10-13 failed with EINVAL on i386 both
: before and after the patch. Each tries to move a 2 GiB mapping from a
: 1 GiB-aligned source to a nonoverlapping destination. Only the
: destination alignment varies: 4 KiB, 1 MiB, 2 MiB or 1 GiB. The two
: ranges alone would fill a 32-bit address space. As a follow-up, I'd
: make these four cases report SKIP for 32-bit userspace and keep the
: existing coverage on 64-bit.
: 
: Tested-by: Andrew Morton <akpm@linux-foundation.org>


By my count, we have 15 implementations of ptr_to_u64() splattered all
over the tree. 

> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -59,6 +59,16 @@ static inline unsigned int pshift(void)
>  	return __page_shift;
>  }
>  
> +static inline uint64_t ptr_to_u64(const void *ptr)
> +{
> +	return (uintptr_t)ptr;
> +}

16!



