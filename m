Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C24FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25FB46B008A; Tue, 28 Apr 2026 06:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E93B6B0093; Tue, 28 Apr 2026 06:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D84D6B0095; Tue, 28 Apr 2026 06:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB1AA6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:07:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99892140542
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:07:42 +0000 (UTC)
X-FDA: 84707537964.12.F3388D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E701120006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:07:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NY22Njy5;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RR7FfFkP/gfr2MBST/nZx797sxi+R24IgrKvn1/Vtbc=;
	b=RChSXZX22EPxamQEkm36I44aIkm0jdut0rt+pq+c7b9RCiedDmZ94leDsxaGQKgL1+1/k3
	u2s7o943vv6lh5dnU11e8FdeekaxWFzRasoP/1K/xeqqGP4MzDkvnd34arYBqTRr/7iXMC
	eV1V29J5+QA/0MF1QoKibxecT3/nzxw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NY22Njy5;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370860; a=rsa-sha256;
	cv=none;
	b=oIFpmwCWhZDW446n2O6FajOgPRtzBoqkZeORI73cpcEoxn3uo1volQ+xT4BtOlQ/kFEXfU
	8Nn09KDzwAeodD57r9P33KBVSpFWLp7kbWjPDGMKrJxnsWkx8SBBO6rWheNA6S5dG1stCn
	d3LXOXyHB+KQbaMkQI5WuwlNvLl1Q9A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C5DA60141;
	Tue, 28 Apr 2026 10:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB894C2BCAF;
	Tue, 28 Apr 2026 10:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777370860;
	bh=we5RUTtK9BBrAx6WOi8PWHN82eXXZYUIrgpPPhKr5yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NY22Njy5Q5KdvpVPewa/YRTnvi9owrLVBDACvvAwqjrcc1inXnRJDvTYNfJ/CaPMi
	 g+soSXkNpHK32TgY2YDOWww6Rs26KRPvQ07I0q/oxo/6LvZMGGvulfak5zAN1wMEDy
	 6ZxxnJM6e9PbiYw/xnqDeC3PR3ZewkC35mIfglVmPXg7D5aveR50qIrifvuTMCdA+4
	 EFUM0r6WkaNO28Tt9WtaMmV+lkJKLc+jfB/SVTqRf5oW1Qpo863r78sYuVTECQ6NHb
	 J014Du9XlPcz/YhNcBy0ZrImxZbXYo5S4Fh7Y+xDJ+/sDQW0ZEPAlEz2yO8fPiDC5E
	 i3gOAZnWEsCqw==
Message-ID: <5b1defae-fa59-4088-96cd-d769ad475907@kernel.org>
Date: Tue, 28 Apr 2026 12:07:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
 <20260428100058.62554-1-agarwal.vineet2006@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428100058.62554-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E701120006
X-Stat-Signature: itkkcnn6ie3skd775m9b1qwacmhoo7hg
X-HE-Tag: 1777370860-210025
X-HE-Meta: U2FsdGVkX1+k4j5yd8/TNw7VxCNNa0HxKXOpYtwp+1S8C3NEQGLDjZ8kEgqiymhBHNOfJ5IJXbR8vvv5YKo7GXmL0YFEq8dCnYmmhBmqWP3NKgjztI2lrIOFBQSbX9KHaPAaPBRnobzylpzzOaqEWBC3xnHW2oa0hreqES5y+Gusc3iK2iQgFhZ0ceAMfvB/ndAKYe/vY7D3NTBQFPDO/cLg6xCtqhypz0HN+4eUMsS2bMn3LFRWtfwF1z/4O7BVEpRc2b3WW3GE7QVTUoCxWroEzL/xJKzXDAjlYHjE94zBzV+SvgWzHSeVUmALWxCtxLhPrbwjDzO8cqKTOf4FcMSroB4C5927jGH0Nj1W4nUEB282+xpe5kqycYAJfUTsuixaf09Bl3Fl9wEyiLsYFajJlP7neSWqZlPDPe42bpK+Sb7JNiQVu+upsvaLwiGnaxAFmrNosIvKclmi8FOIISW5Yiv4AzZi5TvFaEqhUeF81DLd2BhUkUHaFU95FvIxVfOsDoX9+WZ6WhNIPFZHQL7ZDrAnYIu0paPD/kq6cFwpJrP+kC7kyZyItGo764QdUjC5yabA+9KC8ogjaAyG6Bull6wjr8Z151T1Am9bs+Vi5uvcQzl4GKg323B8v9aXuTFCzfAd8Zq8ix67RWKqgy2VzhRc/5/BgyVIRCT9BVburRjY5MkYOqNWqB+6iSATlzz1Ywjl3dITLnjcgCKiAqosuW2UXxQYfVuSU5NygGcu5qCMKO2ib3aCWXjWCrMrN8PHtVk7ikHX7zPMuctCyF+uH4JP23qoqF7C95WU2pObhhd2MyHm3RCnf3/O7m6E+8nVCVgMPrWSX4Nf6sgcxrL058zZp/h4Ym2DH/8UkiGxLNdY5RAK9M7C08i6qz+yGAQr4MARIZW/SBQkUtQndaXlsXcq3cthOB8+QtJMtouoc9miBrgiYypTQN1KHvOYAqJmPHr7Mf9cf/Y1oaZ
 ykKzfpix
 E+qBkED3oC9lSjrFOWshx+tcc6f86q0JpD8dyrx5DBmq120XpjqRbkFlqsZV5iMunXiN5QmgZl2HkdgkWOUrapANecb3edgyqqV+hg6ZsMH+9jZcqZXW+yGEHhfKWxnjn6g6xquFic+H/EaA8Do5KhxZRKbJlelTUwN6ymq00s/C212AH4+FwMLFRFx88hxBCpt72CByCEvxD79nGqFZiJIHj0lkMd2pcv4lPOuu6TEBwwuZi/4btFQ8JfOmtzrSv3OTSs4HWb/rXphIrqaHcbpAxtQB4qgXFd34wm+6TvcIrfgBo7IqhJzfIEG+j1wiR1eGMlONns8UO9mFn/1eo+kYnnnGvvwaMUsxZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 12:00, Vineet Agarwal wrote:
> file_setup_area() currently allocates anonymous memory, fills it,
> and writes it into the backing file used for collapse testing.
> 
> Instead of copying data through write(), resize the file with
> ftruncate(), map it directly with MAP_SHARED, and initialize the
> mapped area in place.
> 
> This simplifies the setup path and avoids the need for explicit
> partial write handling.


Please

a) Wait a bit longer before you resend.

b) Don't send as reply to earlier revisions.

> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..57ca4224bd5a 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -369,7 +369,6 @@ static void *file_setup_area(int nr_hpages)
>  	int fd;
>  	void *p;
>  	unsigned long size;
> -

Unrelated change.

>  	unlink(finfo.path);  /* Cleanup from previous failed tests */
>  	printf("Creating %s for collapse%s...", finfo.path,
>  	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
> @@ -381,11 +380,21 @@ static void *file_setup_area(int nr_hpages)
>  	}
>  
>  	size = nr_hpages * hpage_pmd_size;
> -	p = alloc_mapping(nr_hpages);
> +	if (ftruncate(fd, size)) {
> +		perror("ftruncate()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
> +	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
> +		MAP_SHARED, fd, 0);
> +	if (p == MAP_FAILED || p != BASE_ADDR) {
> +		perror("mmap()");
> +		close(fd);
> +		exit(EXIT_FAILURE);
> +	}
>  	fill_memory(p, 0, size);
> -	write(fd, p, size);
> -	close(fd);
>  	munmap(p, size);
> +	close(fd);

That change is not strictly required. We can munmap() after close().

Apart from that LGTM.

-- 
Cheers,

David

