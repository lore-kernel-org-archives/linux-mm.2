Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9161ECCF2DF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCDC6B0178; Mon, 19 Jan 2026 05:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D848C6B017A; Mon, 19 Jan 2026 05:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1A66B017B; Mon, 19 Jan 2026 05:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B91B66B0178
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:56:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59A28BAC5D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:56:01 +0000 (UTC)
X-FDA: 84348408522.25.A5FE1DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A538CA0009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:55:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5HR1K7C;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768820159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P35aYUTF6UKDnObz1wSiQGtREaZnDhwN2Xd4XYDwFOA=;
	b=lAh5kUCjfv50m8XL+8wNHr7Y3ScoQWYFXm7TWaUyxUv6uOyS5aEZImhBkmpN/qYzerflVe
	JCxLW4FxOUNAt8SyJgekO0bsNMGNDQvEYncEqyFLcfENi/MxiFUPaPb12JS9KSg4pTchHJ
	59cwHVXTHm7ZB+FgRW6fRijYwPKzrMo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5HR1K7C;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768820159; a=rsa-sha256;
	cv=none;
	b=LZrIJ582D5Ahiu7DlTV8jPnZI7cw2b0zS2nhS1taBT8aB0Z86eFAReBTfCGnL31y7G7fiK
	OpVcdjFDEn2f0NdECfi4+SBOhD2kTcluKCkFtQ//5wh6M0sxsrRPV++qMRDjfLrEW/ME1n
	TYKl/smFTeb0kNO3TlgJdU2q5CWqMhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08C1760140;
	Mon, 19 Jan 2026 10:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7E2C116C6;
	Mon, 19 Jan 2026 10:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820158;
	bh=bsXo26KZ+K1aH/HZ8wolPUoG9a2d4fNHkR3P0zLa+8g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U5HR1K7Cjv0Cp+7YA9y3rZzYh3llbIkfZP8dDEoV9I93qC40yuDZuPbkDtUVAE8Xg
	 W7/u0Dc4zylWNGHI2B/csqj7mS8kuwdP6elJFVLdx6UbEdH6hy7LNPodk4rb2UvPku
	 PRsyafmBOay1dqnXvPNE9mACu05Ir5P33XWVzP8Bc91mrb8vmXgUkQqrGf1DRxq/Nb
	 9MdLKrAaR2r//UIh9a4FhU6Nq64ghVu9kwpROwSidCRdJtB2M2Xbz/SlUJqMImyGP4
	 ouTywClMcWbwMw59omh7dCa2luVHaowpKS6lyNbYgozqnWikaAZQprzz+3UpK3ecTj
	 yUcKnCrZxwa4g==
Message-ID: <aa0ad9eb-dab8-4c29-827d-bed4983a584b@kernel.org>
Date: Mon, 19 Jan 2026 11:55:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] selftests/mm: introduce helper to read every page
 in range
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-6-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107164842.3289559-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fqx94b3o5idmpqtjrye8ozwi6geg4qbo
X-Rspamd-Queue-Id: A538CA0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768820159-306086
X-HE-Meta: U2FsdGVkX192X7EcabNPhKLlDJacQzUStVW3wfbC7NPvzlC9czESDIkZajC6uRAQxLNS5qmJlVms6aXwYe+lzXqc40t9jKuc1CzD5PwywrJm8/7HueIrAhBnTkKiNWUeGQBxjzLTx2ToW5YUOHdjWFDO1nFTBQgNXbnNeTJa/Z7hWV3WZ3Zo0XOocNDdzKKZpVAekEZ8vuvl6bRCcjgXk8UwJscYVjpZ93AoVJkLA/3olEBfnzdhSCGyvL8E0SI2WWt6RSa49Ez1BLbyhXUR9rFBapvZioTaHo1vBHqb1QyVNVbts51biSL6BcsGBqDMbiw7nP4mPQGNE1WkxWUdLN6+ebiSX5x3pOnVDwp2MVyubv/Cu0dgpxFz6bC90UE3hrGQz+/LsuIo8NQAK3cK5X9KNb7pQN2FD2qIFacvoHDSTkD3/YDc1LNbjbIleh08sntMMr3E29+Yb680cmLJlCaRktXY7EPVa+3nYgEh9NgzjttjOoTb5jn6KjoTlWlhzc8T5aPCTF9zUfym989a/WGMPr11p3WIJLY/2gpiWIlg53UJNdwkl8wvZogOn0622ay+2vKoiDzYfAf1wk16x6HLvIaB87Eyje5cgxoF8wCihm1XCYJgRcMOY/5qbToCy5EueQDseDSC9Kp+o/Vt9hufEx/dazUcWjML+sJuuLnMfSdplheNkpgghf5r35TaWXB0gXKBjfjjzPcK8HmSOKhSzHeyvBwGKhIDpDjY4JpC0reBehCY93VFgCsuADOXc8j+T7xWv2LwK9k6Yw+Nou1KAF5q0EYZZPurCx1pRG3fgTLnBLqS46C6Qy1VHO9mZY5bZ3YzjFG51N1suTZAmL9Xv0T1cbaiirIW94voNxUVXVUn7CoZD8KF67JazRhjNYkHxQJUvHI4vmcwCcd3sKe+ctmXVQLzOacB9QEToy1zN2+rHVMEL+pbXC7zIGJz+4J+AquJem5IP8gbi11
 bSYt7TFD
 Yzy6EzRiuAvUGQJvTo1VqC7+nzqoXDAr89hCZcU7Vgx0+SjPp3ltMXuSgJF4ScuUJy9rSSPuJE3no5skX4FC+X6/RcvT7CZVeAdnnR5gc7GJO4sluFqkQte5E7RcZpNXzV54Z4WGnJYBtIB5URCJE5r9wUECGspEgW3OTyr/oEuN2dS4GsRy6fruG73zCZlfysYZDnuG+dIzZt5hxNnlRAa85DilGWON4FTV4yL4mervpdc0edxnAnA3lKuH3DfXDaof+3OIFprgfRAS8DBIh/skq7f6EI03iZhsLVA6lAfPfwarcJLTKSum9NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 17:48, Kevin Brodsky wrote:
> FORCE_READ(*addr) ensures that the compiler will emit a load from
> addr. Several tests need to trigger such a load for every page in
> the range [addr, addr + len), ensuring that every page is faulted
> in, if it wasn't already.
> 
> Introduce a new helper force_read_pages_in_range() that does exactly
> that and replace existing loops with a call to it. Some of those
> loops have a different step size, but reading from every page is
> appropriate in all cases.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   tools/testing/selftests/mm/hugetlb-madvise.c     |  9 +--------
>   tools/testing/selftests/mm/pfnmap.c              | 16 ++++++----------
>   .../testing/selftests/mm/split_huge_page_test.c  |  6 +-----
>   tools/testing/selftests/mm/vm_util.h             |  6 ++++++
>   4 files changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 05d9d2805ae4..1f82568ae262 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long nr_pages)
>   
>   void read_fault_pages(void *addr, unsigned long nr_pages)
>   {
> -	unsigned long i;
> -
> -	for (i = 0; i < nr_pages; i++) {
> -		unsigned long *addr2 =
> -			((unsigned long *)(addr + (i * huge_page_size)));
> -		/* Prevent the compiler from optimizing out the entire loop: */
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages_in_range(addr, nr_pages * huge_page_size);
>   }
>   
>   int main(int argc, char **argv)
> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
> index f546dfb10cae..35b0e3ed54cd 100644
> --- a/tools/testing/selftests/mm/pfnmap.c
> +++ b/tools/testing/selftests/mm/pfnmap.c
> @@ -33,20 +33,17 @@ static void signal_handler(int sig)
>   	siglongjmp(sigjmp_buf_env, -EFAULT);
>   }
>   
> -static int test_read_access(char *addr, size_t size, size_t pagesize)
> +static int test_read_access(char *addr, size_t size)
>   {
> -	size_t offs;
>   	int ret;
>   
>   	if (signal(SIGSEGV, signal_handler) == SIG_ERR)
>   		return -EINVAL;
>   
>   	ret = sigsetjmp(sigjmp_buf_env, 1);
> -	if (!ret) {
> -		for (offs = 0; offs < size; offs += pagesize)
> -			/* Force a read that the compiler cannot optimize out. */
> -			*((volatile char *)(addr + offs));
> -	}
> +	if (!ret)
> +		force_read_pages_in_range(addr, size);
> +
>   	if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
>   		return -EINVAL;
>   
> @@ -138,7 +135,7 @@ FIXTURE_SETUP(pfnmap)
>   		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
>   
>   	/* ... and want to be able to read from them. */
> -	if (test_read_access(self->addr1, self->size1, self->pagesize))
> +	if (test_read_access(self->addr1, self->size1))
>   		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
>   
>   	self->size2 = 0;
> @@ -243,8 +240,7 @@ TEST_F(pfnmap, fork)
>   	ASSERT_GE(pid, 0);
>   
>   	if (!pid) {
> -		EXPECT_EQ(test_read_access(self->addr1, self->size1,
> -					   self->pagesize), 0);
> +		EXPECT_EQ(test_read_access(self->addr1, self->size1), 0);
>   		exit(0);
>   	}
>   
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 40799f3f0213..65a89ceca4a5 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>   	}
>   	madvise(*addr, fd_size, MADV_HUGEPAGE);
>   
> -	for (size_t i = 0; i < fd_size; i++) {
> -		char *addr2 = *addr + i;
> -
> -		FORCE_READ(*addr2);
> -	}
> +	force_read_pages_in_range(*addr, fd_size);
>   
>   	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
>   		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 6ad32b1830f1..74bdf96161d7 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -54,6 +54,12 @@ static inline unsigned int pshift(void)
>   	return __page_shift;
>   }
>   
> +static inline void force_read_pages_in_range(char *addr, size_t len)
> +{
> +	for (size_t i = 0; i < len; i += psize())
> +		FORCE_READ(addr[i]);
> +}
> +

Of course, we could also just pass the pagesize

static inline void force_read_pages_in_range(char *addr, size_t len,
	size_t pagesize)
{
	for (size_t i = 0; i < len; i += pagesize)
		FORCE_READ(addr[i]);
}


Or alternatively even better:

static inline void force_read_pages(char *addr, unsigned int nr_pages,
	size_t pagesize)
{
	for (size_t i = 0; i < nr_pages; i++)
		FORCE_READ(addr[i * pagesize]);
}

Then there is no change at all and we avoid the repeated psize() naturally.

Thoughts?

-- 
Cheers

David

