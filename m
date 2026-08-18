Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCB3C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7666B0260; Tue, 18 Aug 2026 06:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE356B0657; Tue, 18 Aug 2026 06:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBE36B081A; Tue, 18 Aug 2026 06:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5BC6B0260
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:15:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0DC51409B9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:15:06 +0000 (UTC)
X-FDA: 85113982212.12.08BEC7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50F14A0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:15:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4PSJVx4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787048105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cluiy09pOghvUJ1vr/fx9GIpCaOWrEgz3nZIxDTE4ug=;
	b=w60cZs5ID/nYGgV6jPceDooAvFE8pBmt3K0ftaUr/D7xuGzgqjqRc4hcisEyHY08Xrh+MT
	IFNDTLFKzVyTqxfNi9y5FfRI1dUmeB+ZTtJBQsulnkAL5d9hylwQCHlKP27Tzqeg3O8oBU
	euiSKZ6n7HaHUXDS51VGDZHjdtMFxw8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4PSJVx4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787048105;
	b=wMtIdxrCjnpKkCUwrBgOPGbbLCh6eWBQtEa85eCZaQf8hAjp4HaYeDxxxVdktkRxj5xjGr
	IMZ6hUfzBOa0eP1dodx5gXSjiguYVCEtm/HmcXsFrpvWZZJE3FEnBe4Ud24DtugSECBhnu
	T52s2JTz9LsO5XHmflTWaTAMrehwaU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2596601E0;
	Tue, 18 Aug 2026 10:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAF91F00A3A;
	Tue, 18 Aug 2026 10:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048104;
	bh=cluiy09pOghvUJ1vr/fx9GIpCaOWrEgz3nZIxDTE4ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a4PSJVx4vl8tYRySMA+6J/08GytwKborNSuTp6TDaVIRau6QTZIdtYC/vUGQkyXIu
	 ynwocxOnPYhxD+mBQSvBNsvicS0XWwneX0X5P5TWAk4gO3zEvpu3UVFY1kva+bmXOF
	 RnsntiBbiD/1/Qth8yBSr+fQMXNPF/sCeKCsrIOWlvtMtrPenLxpbtGYAyAwXesCW9
	 wx65S+WoiRh6P/rerqzY35ttG/674QmuJ4twR5QwWgbBizJi/eSla44GOl/WoPOGEx
	 G+chOo9tcwD0EPpvnwjp6AsIajBhu0yNK1XZfa8bb1nBoHdkr73dn3TCr65AIw9bhJ
	 eIHIeoazZsOBg==
Date: Tue, 18 Aug 2026 11:14:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 07/19] selftests/mm: move is_backed_by_folio() into
 vm_util
Message-ID: <aoQwizWbYM7_T72f@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-8-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-8-kirill@shutemov.name>
X-Stat-Signature: rmbtaoxmiqq7c4iyqrf8i1bf6f9qegrj
X-Rspamd-Queue-Id: 50F14A0007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787048105-747711
X-HE-Meta: U2FsdGVkX19vfmldWJ/j4GDGbVuEvIJ8PDJ4AeoqfawSMXq//ZzX+kjs1sVEeGImSnfU2mywqMD6Kxtiji5dTQ5KaVM1aCBQQsE0tDZzx4S+mZ07tJ8WIs47doaS3UsjXUye2RQBTiSZemSZcGMeXa/AYFrnaAc3j891hp0sTzd2gIkjX/8b+6BPWyDvng4YWkcJ0qfMnD5RV32mlLZNcMkdiu8uMaOWfHSS/OnISiS2MoLEh4dFlwflVLW9wzvvmCO0oEXobhML5a8K92ABaqxlxS3xdalk0fXD4usEsqtFyFfnN8fSQ6f+++eRuoYO52aKiGLfStyaVu8bVs0110bJBUqbecUCwbWtztrjjMPwC4oVmzYa9VKKCHnPzL2Mt6ceAoc8VPzaA9h7hdfufdaFJiNmYLkk33CENiIro0XdXT8pG/lJZ1YXHPbfDooeOuQjTD1iRaIa3EDBKA08F8oowVCPz2lSTHKa1uOwr+pGesqvwcRcw7/iD4GkeuMdaCATPU5fQeAhkL9VijvG+3pKM2i3Ha2tcvNWfXSHwH+90bCNnvx7amsFiA+vdCMrbiKFPR5ZtSEtEZ3MBulUQ8E18SZ9JEQsUVjV2vwtktsmCgH4HqYQPWfUwSlbuTe7Zer7+8CFig1NBDQV15hH31CPVNJqCUTdyWzdNspH+9uHtXn9r75J10z4RAr34oeCejaymuF7abeIVoUkzAzWTb+VeMUBUhn1fTYkWeOZnkbtLzILtPkzs11Kitei3K2OeD+r26O16Bcp9CUMRUyiVpUfAX3PTDhS0401Th4QzmP7B+A2opYJ55w3rlUIRYyyCNCYiH8poBDSaC9fLWPt8X3TVs2/44mpy8+fPkXzWuNC3dflbPmtFUoWkYude3IuA0YKIhWfy6nhKJA8cKHDF9LlCrHz9qVWHTc9lvCyjl5e/Y+uanCzi/EFtavyORM68ghwMtwyOCsVGs7swhE
 hWjZg+RQ
 hG3kAIEfFMorSz+4kMct0A4FUpBNRsWyzqSuSgbfz8Dccq0y9HJKcbpP1tdzKYFAMdMs5NwGIhtwWdnp5fFNzwoS0jjsU99EVWVOdk6oUqcfDcnb+htZdWXdmEH6qTgWKDnwLJhZQjtRqR2FzQNtRQAGchGfKAGKO5ZW1U2nnuv4EAHytZu2JBcvER/0Nkc867O74nkfg5PiMau1VLjPoli+iQ6RGqSpfVzwbDk7EmEUwJGub4eZt6EiyIskErn6ydR2iMfLPCD0mkC4wStpxfU0QT2kRHsNyYNHwTwb5Ff2gFqhgm0QOVKsmxVKHKm6H4fzuHu0tWcaTrrgPqBG6tayORFkCaXsKddpl1YIQJLz9rhHERAyTvab7fSbvBisaXvLb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:49AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Checking that an address range is backed by a folio of a given order is
> useful to any test that builds or collapses large folios.  mTHP collapse
> coverage in the khugepaged selftest needs exactly that.
>
> split_huge_page_test.c already has the building block:
> is_backed_by_folio() reads the compound head and tail flags from
> /proc/kpageflags to classify the folio behind a page.
>
> Move it into vm_util so other tests can use it.  No functional change.
>
> Assisted-by: Claude-Code:claude-opus-5
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  .../selftests/mm/split_huge_page_test.c       | 62 -------------------
>  tools/testing/selftests/mm/vm_util.c          | 62 +++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.h          |  2 +
>  3 files changed, 64 insertions(+), 62 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 86a603692826..0adfe7dde7e5 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -42,68 +42,6 @@ const char *kpageflags_proc = "/proc/kpageflags";
>  int pagemap_fd;
>  int kpageflags_fd;
>
> -static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
> -		int kpageflags_fd)
> -{
> -	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
> -	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
> -	const unsigned long nr_pages = 1UL << order;
> -	unsigned long pfn_head;
> -	uint64_t pfn_flags;
> -	unsigned long pfn;
> -	unsigned long i;
> -
> -	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
> -
> -	/* non present page */
> -	if (pfn == -1UL)
> -		return false;
> -
> -	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
> -		goto fail;
> -
> -	/* check for order-0 pages */
> -	if (!order) {
> -		if (pfn_flags & (folio_head_flags | folio_tail_flags))
> -			return false;
> -		return true;
> -	}
> -
> -	/* non THP folio */
> -	if (!(pfn_flags & KPF_THP))
> -		return false;
> -
> -	pfn_head = pfn & ~(nr_pages - 1);
> -
> -	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
> -		goto fail;
> -
> -	/* head PFN has no compound_head flag set */
> -	if ((pfn_flags & folio_head_flags) != folio_head_flags)
> -		return false;
> -
> -	/* check all tail PFN flags */
> -	for (i = 1; i < nr_pages; i++) {
> -		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
> -			goto fail;
> -		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
> -			return false;
> -	}
> -
> -	/*
> -	 * check the PFN after this folio, but if its flags cannot be obtained,
> -	 * assume this folio has the expected order
> -	 */
> -	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
> -		return true;
> -
> -	/* If we find another tail page, then the folio is larger. */
> -	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
> -fail:
> -	ksft_exit_fail_msg("Failed to get folio info\n");
> -	return false;
> -}
> -
>  static int check_after_split_folio_orders(char *vaddr_start, size_t len,
>  		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
>  {
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 80bc9f597b52..5db1a7774f49 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -494,6 +494,68 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
>  	return 0;
>  }
>
> +bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
> +			int kpageflags_fd)
> +{
> +	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
> +	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
> +	const unsigned long nr_pages = 1UL << order;
> +	unsigned long pfn_head;
> +	uint64_t pfn_flags;
> +	unsigned long pfn;
> +	unsigned long i;
> +
> +	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
> +
> +	/* non present page */
> +	if (pfn == -1UL)
> +		return false;
> +
> +	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
> +		goto fail;
> +
> +	/* check for order-0 pages */
> +	if (!order) {
> +		if (pfn_flags & (folio_head_flags | folio_tail_flags))
> +			return false;
> +		return true;
> +	}
> +
> +	/* non THP folio */
> +	if (!(pfn_flags & KPF_THP))
> +		return false;
> +
> +	pfn_head = pfn & ~(nr_pages - 1);
> +
> +	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
> +		goto fail;
> +
> +	/* head PFN has no compound_head flag set */
> +	if ((pfn_flags & folio_head_flags) != folio_head_flags)
> +		return false;
> +
> +	/* check all tail PFN flags */
> +	for (i = 1; i < nr_pages; i++) {
> +		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
> +			goto fail;
> +		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
> +			return false;
> +	}
> +
> +	/*
> +	 * check the PFN after this folio, but if its flags cannot be obtained,
> +	 * assume this folio has the expected order
> +	 */
> +	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
> +		return true;
> +
> +	/* If we find another tail page, then the folio is larger. */
> +	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
> +fail:
> +	ksft_exit_fail_msg("Failed to get folio info\n");
> +	return false;
> +}
> +
>  /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
>  int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>  			      bool miss, bool wp, bool minor, uint64_t *ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 9a49af88702e..56a28ce7d029 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -97,6 +97,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
>  int gather_folio_orders(char *vaddr_start, size_t len,
>  		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
> +bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
> +			int kpageflags_fd);
>
>  int uffd_register(int uffd, void *addr, uint64_t len,
>  		  bool miss, bool wp, bool minor);
> --
> 2.54.0
>

--
Cheers, Lorenzo

