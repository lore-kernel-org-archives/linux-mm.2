Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E67E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xNYCnS85
Received: by kanga.kvack.org (Postfix)
	id C23B36B05B2; Fri,  6 Nov 2026 17:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAF26B05B3; Fri,  6 Nov 2026 17:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37DC6B05B4; Fri,  6 Nov 2026 17:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90D186B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:39:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B9C6160247
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:39:19 +0000 (UTC)
X-FDA: 85406161638.21.FAC72EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 267C4A0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:39:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xNYCnS85;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794004757;
	b=vHZ6LY7CSIRg8w0++T0DlrNlBBfseWaZwWlhecDywFsYX4igpvrs84U/MtzS4tHQT/A1cH
	f00rZPYieUHoIKaSpBYug1ULXK4AO7BG5Ldu8MjVIxEkq8iszTkPLWMMJwYgakvRzf5cBZ
	kzmTK4Pdf33rEmtme1P9rX0ty4bV8ms=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xNYCnS85;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gusY0KSUVKJcXw6Hq1PL8ajvvWfgIQrgRs/gFrGi9gA=;
	b=kjCG8/lPWkqyfsw86TsYegf6C64ABYL7KNYa9PqxA5miclAZ3+XbgQuYgE4FBEkogwdQcS
	lph0LqkOD2yoJz0pyf/HpP0kNggwWqPbPqMVrvHnmDFht5WPVbJjKFCCHvTTJdKShZn2K5
	bMbVyPiKVETJPtG5RqZgIdtXNdvC+M4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16E0A43292;
	Fri,  6 Nov 2026 22:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA091F0089F;
	Fri,  6 Nov 2026 22:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794004756;
	bh=gusY0KSUVKJcXw6Hq1PL8ajvvWfgIQrgRs/gFrGi9gA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xNYCnS85enGxqL0orgxtArZoKCY5STlQNAhTy563XuE3RJgdU4JNFllcCADOnxuIY
	 PRk4mq1utmrnYWLqkJwBzSijnliR4rjbFetNmdtJwT4DWUp4ple6ih0LYBA3R9Y7qC
	 S3Rjwu5qLxnwrJxgOmqm2d9NLqtQtjyiX4auMD9E=
Date: Fri, 6 Nov 2026 14:39:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mt4022@columbia.edu
Cc: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, David Hildenbrand <david@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Kiryl Shutsemau
 <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 tz2294@columbia.edu, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
Message-Id: <20261106143914.16a42b8cdf7436d045b85aa6@linux-foundation.org>
In-Reply-To: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n5nsgen9cghz9ya77b3twtdp7g1c4zca
X-Rspamd-Queue-Id: 267C4A0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794004757-530451
X-HE-Meta: U2FsdGVkX1+zCrpcd6BVhbknr//UMIaqfM4G2ZgUks5FaBKvuxIWGeQVDYX+B56A1yx6zRe8SCr3s/Xe1DGsJAHKvrGBOHjeoUvhPl0gkSw8esl/3GOdnYGoGkEMtNYfkn0gMhkiM+vAdJf7UzmqEFw3Ug8rQ1brt0IEEeWe1yvQiGRJcXFuCOypNLZmAPoT8q5LxvKrwKVQ14R4ejJKXHDC6UC9xxwPbtikjSdQxKdBIfL9q2ARPX6pbhl7O8jWXG3UqO55cx0LCS9FaLx4h+EtQM3ukZoOGY/YjBgJRzFN0iT6N28e9mLFbrKrd/3iONdvKwvlY0BaFUHatCsjRAK7EdbAVWkF2Xy8x9Rc9V6jcaq8L8XgEUTcHn+1cY3m7GhrUW6Ti+DOu7/RbWGLE9CUCb7PJklgqOU0xGA/UNWk3NPbJr00DNtDKC1YgJZxsIVIBIKoMRMK9s1zkGJtXxK3Xq7efNH/c2enpg0upC1LjoayV8mm9hsf0Y5eN+HlJt9Ku4ZsUVk+o6wwyJQii/OioYVCouqqgXZk8mVT3dHSRtLWU08IBRqidsN/g7sd5I02AGkJfSUVTi2akbm6XwkP31XHEPKWMuZtUWKxd9CabV4Th2v++c79KuP5qNxBx0ln1tr7MP4XTqfc0emFNMtwr53rCvi5qWJZpO8XATgEEFsxqDQgcih4u7QXmxRJ/t3Hu7/id/w65QIq/tCWG7g2I+PJ3Bw3e6b5zPUFLWes5dnY4H71DdxTBLbFejcMBedrsjKcd+DGsyUCaU+xRkmqI054r/pbkW/hnNsPZgWmch/86QokHYC3kvVANoIuZLCrMLx4f+MADh1itPmfkBZphzzmT9YsBHWyC01vs/yFMwgoEqHhudTDgk1ARpFgaY20u6gIzVgSOmNAjRu6eEAlObBKmrZ6ZsQmAMVnWkxKIGvEOsw52qDz+cB3IfLnbZciUS6za7hMEgBziQT
 yUBx5SG/
 Af9ECtaQdCsql5pf/HQTanrrQzl/NtpLuo6cscjuJ4ynBw3ChIB8xscHOHuI0TNTvkFMyjuFtobqDKYf5uC9TFkqZEUdyjsyVTmmjpnYqTEGLZCEZKc4beIOO6f450eN/vmdpBcBnfbr6vlCo8T8ibDisYTfjoBXrexKiTZDGrZpft4TXWBl8TJ0CFGuLtXAC0JMkdQOWtyY1gW5LrFcf5raM1HAGQjw6CIcNk+IG50BbRb1E2LgYSHPw3jWolugTOad2xkYTAudpCZ61ZkRSYBMwURjFjKG5Z25bgONDezJ+JvafYjjnXNedVgIAYEr5jc+KYwieNPNLLJvO1HAIO7PqrralDFgf53jTtUKaWXwAk7XBPvG9Oa3DBOJyhbXl9olPULQgiY3r2mwqQXBW7jpiGUC05COyoDLxGfVYlMeLZgknYqqAU1UzzPuZ8Aqa9xrykWDFilY6VPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 11:09:50 -0500 Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org> wrote:

> From: Mani Tofigh <mt4022@columbia.edu>
> 
> memory_failure() checks under hugetlb_lock that the page isn't part of
> a hugetlb folio and sets PG_hwpoison only after dropping the lock.  The
> page can become a tail page of a new hugetlb folio in the meantime.
> With hugetlb_free_vmemmap=on its struct page then lives in the tail
> page that all such folios in the zone share, so the flag lands on tail
> pages of every one of them:
> 
>   Task A (memory_failure)              Task B (nr_hugepages write)
>   get_huge_page_for_hwpoison()
>     /* P not hugetlb */
>                                        alloc_fresh_hugetlb_folio()
>                                          /* P becomes a tail page */
>                                          hugetlb_vmemmap_optimize_folio()
>                                            /* P's struct page now in
>                                               the shared tail page */
>   TestSetPageHWPoison(P)
> 
> The error on P itself is ignored, while healthy pages of other folios
> stay marked and are never reused once their folio is freed.  After
> freeing the pool, /proc/kpageflags shows them as hwpoisoned.
> 
> This is the allocation side of the race that commit 32c877191e02
> ("hugetlb: do not clear hugetlb dtor until allocating vmemmap") fixed
> for freeing.
> 
> Set the hugetlb flag of a new folio under hugetlb_lock and set
> PG_hwpoison of a non-hugetlb page inside the locked check, so that the
> vmemmap can't be optimized in between.  The retry path clears it under
> the same lock, unless the page has become part of a hugetlb folio in
> the meantime and its struct page isn't in the first vmemmap page of the
> folio, which HVO doesn't share.  The retry then knows the flag is its
> own.  With the fix, no healthy page gets marked anymore.
> 
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within about 35s.

Thanks.

So as I understand it, if a single 4k page turns bad at just the right
time, we can mark a lot of healthy 4k pages as bad (hence lost until
reboot) while the bad 4k page remains in use?  But that race is very
unlikely?

> Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
> Cc: stable@vger.kernel.org

I'm hoping we don't need to backport, because the race is so unlikely,
the consequences aren't world-ending and the backporting story is
messy.

But I don't think I'll get my hope, because the consequences of this
race are worse in older kernels:

In 6.6.162 HVO maps shared tail metadata read-only, so the misplaced
PG_hwpoison write can cause an oops.

Also in 6.6.162 memory_failure() still has a ClearPageHWPoison(p) in
its PageCompound retry block so with HVO enabled and
CONFIG_TRANSPARENT_HUGEPAGE=n, its compound retry can still reach
read-only tail metadata.

Miaohe, wdyt?

