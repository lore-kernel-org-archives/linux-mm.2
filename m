Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B84C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E8F6B0171; Tue, 18 Aug 2026 06:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE996B0174; Tue, 18 Aug 2026 06:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDB96B0177; Tue, 18 Aug 2026 06:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 378CE6B0171
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:25:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA3A240BB4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:25:51 +0000 (UTC)
X-FDA: 85114009302.30.2BDA840
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37F44140004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:25:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQGfEf4S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787048750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9venlAYI7bc+4UF3P+DsNZ7UbsjWk6/adcKmtx/yJEs=;
	b=7I03WySKrwg6XqEkwZ/VL1Rs+YxmmNsKx34j+KxxaMqMEM+IQAtuWgFda8hm/yPgiF/Q/T
	v7AqWbeRQF0sMI/X/gYSRMzA5ydaEWX/kwnaSXRetudVHNag9o6EAOKzWcVy2W4f7Zm4dY
	39OBdeDTuXh0OmI+YO3b7ujBzaPoyO0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQGfEf4S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787048750;
	b=AhD++hw22D8K7Gw476lWIRqpSeRuIB8gcZAZY9sjKUTIhMElu7RpFYlzSkP3ZmuzfbAplR
	AwVUFc6tayiQFJN7FygzzxC/BV9OceDBU6rZVkVO7gLaDDSfnvIJdyH5k9knLUHtS3QLv3
	fzGuDK+cz202DpTsEjwHYA87bApcAao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F999601DE;
	Tue, 18 Aug 2026 10:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A71F000E9;
	Tue, 18 Aug 2026 10:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048749;
	bh=9venlAYI7bc+4UF3P+DsNZ7UbsjWk6/adcKmtx/yJEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iQGfEf4Sjm0ecEEdEi7v/xrseuBpYZHAmo+r1TVdH/Suu9l1kSwUkIpdROZ8L9Bba
	 7Rtbzq39W022yjAIC+ffKOFr9Jgo5oN0JCCv3evZG6Pgnv+Gu/Z5n/+wLuNYpRzjp3
	 HUuyxmJBiQCQENoSTw/vN61x5nNYf+HCAlXpZyl/2LI1yE7y/WqTWhU+WR8y7/Ooln
	 n5w40LWFVGT2AQuHtpxwROQwqIhKsX+uirM48GMhGbvgdtniYn7fnLDmKEydrr0wP/
	 XcoPdKamXHCfApYT5TfAJZoYe08HtZG1BtwhDh2sfJk8RYitTOOje0mNWb1ZQoVH5X
	 hAS8Pl5ntln5w==
Date: Tue, 18 Aug 2026 11:25:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 08/19] selftests/mm: add folio-order check for address
 ranges
Message-ID: <aoQxLVg3IsTuA9NE@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-9-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-9-kirill@shutemov.name>
X-Rspamd-Queue-Id: 37F44140004
X-Stat-Signature: nwjf3kdwxpaud33m5r8kb5e4dgnuzufc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787048750-117833
X-HE-Meta: U2FsdGVkX1+e/iQByTkrITkNTHhlwmBV80SqxlxhBOJBamRlk1v8vKuawBLPMpxHT2zPF0hAI+VWq+m5B4wllULkccy4lXumzGXo8ghPVu/yF6FyS9cQbIJzN/LJJovaQXzwLxQZAUGxkb2QuVbMVWDdwYy1JDPuozVhdu/hOUvQ8X9s6ahOdDSdJJqEOpogCL/92SgZ7oNSMMLIY52cfykWdy8pydzByTg4y2VWLXGvv9N8mCAIJ7BqGLGdy655vF/JtjC+cw0BmKjnsc8dY9ek8Cn682TMGQvw2HBPW5Wn5tOqShPhcXwutccXTD4rYnXZGYjdiwVpTMUDN369jc72v83emaHhQYSFl/3L1tRhRJgsmvcakouDxXsESsLuPWMiMxhyofoUU+2U6Kmu/k9glwOg6Oy4KcpSvJHgo45x/xN3fTD5SkAMRNV73rrn/Jvm9qhY4awlnbjtVSELJJTpPWCHZwtRyVXhvBVyXkiDMBYBH7b+pBTEybq2lLXQoEIuGizJuQcXcu1b3pOT2bFbH+UNLA05jHP/2lgXfcoA3ZGYypYi4LgGzPA5RL5CfZO6JF3R+kklL0uqeAJSzmD93JV80vgOBUTa4zAtoWYYR0nxU2S8VZTOsPiwxO6tBs6XWv4CS4zAFpIY0fhSZGi93ZS2RYqWA6UiZGM9adaLcAppqa/gBgW74pw82Hr3EYtUUJadHQTHUcH0YBmFIZLcJiXhQ8EGUiaAIHj0X1FPiSGtpLj9ohMpPtzuU3w8WXa0g/b7PUkE4rLWMVuangwSVZR04W51+9eEICeJ1czaWsk0a3XJsiLKlBqVvADHvBigUZpMeynM0vH6Ilb0PUdMagzP8HQ1A3IyZRtOx0x3KuC+I7ErJXYLIEZFm5akUlJfFCDFelX2pDu/itpijA2RQZGwMK9W68fM9xN4B2HDuSfZzVDI6e0fGnEAlTUDS9S7NLQRSfmkxoP0LnN
 Xaor5IU1
 24PqdPVn2xnAeozm7meMkZiZbclUM+0CZ1R8B9BSWuoiMgJthNkVplXgMVAC4yj1xDiXRejTiSbZWE45/zqqZ0+3Oak2IZSuGOGsxzxe9V/7Wr3O3j0/T726YTr8AUe9hfd4ZyLA63ztRX7efDMs1NACeHsY0+dqjerKgEKbDwtLyRhwMaHIoGRapfzyp9qCbJZS/eGbDIfjVYWBQA4ydIuWUSkV5bAmr8kkQDAXIaS92xBIdCcjDVJp3OzLZIATZ/1P/pr4B38SiIgrpBfC/iXL4EXylQk3g6c0SSaYfvtgcpApXYLkhQBta462K427AebTFSF4iYfsdk4FiSdFy5ZHdGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:50AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> An mTHP collapse test needs to know that a range is backed by folios of the
> target order, and that they sit where a collapse would put them.  Nothing
> answers that today: is_backed_by_folio() classifies the folio behind a
> single page, and check_huge_anon() reads smaps AnonHugePages, which only
> accounts PMD mappings.
>
> Add is_range_backed_by_folio_orders().  For every order-aligned window of
> the range it requires a present head PFN at its natural alignment and a
> contiguous PFN run across the window.
>
> A window backed by two smaller folios fails the contiguity check, and a
> folio mapped off the window's alignment fails the head check.  The mTHP
> cases need both to tell a collapsed window from the one beside it.
>
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/vm_util.c | 42 ++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.h |  2 ++
>  2 files changed, 44 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 5db1a7774f49..c9bd6c92fa41 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -556,6 +556,48 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
>  	return false;
>  }
>
> +/*
> + * Check whether every order-@order window of [start, len) maps exactly one

Strange to reference @order in a non-kdoc comment. And then to start referring
to start and len without @? :)

And I'm not sure 'window' is really clear here as a term...

> + * folio of that order, head to tail.  The address range must be naturally
> + * aligned, each window's PFN run must be contiguous, and a window's first
> + * PFN must be the folio head.

Also 'PFN run' is adding a new vague term.

> + *
> + * This is the check "did this range collapse into order-@order folios": a
> + * window assembled from parts of several folios, or mapping a folio shifted
> + * from its natural position, fails.

I think you could simplify this to something like:

	Check that the buffer @start of @len bytes is mTHP-backed by @order
	folios wholly contained within the range.

	This requires that @buffer is aligned to @order and that every folio
	is fully contained head-to-tail.

	Returns: true if wholly mTHP backed, false otherwise.

> + */
> +bool is_range_backed_by_folio_orders(char *start, size_t len, int order,

is_range_mthp_backed() seems a lot clearer?

> +				     int pagemap_fd, int kpageflags_fd)
> +{
> +	const unsigned long nr_pages = 1UL << order;
> +	const size_t window = nr_pages * psize();

folio_size seems clearer?

> +	char *vaddr;
> +
> +	if ((uintptr_t)start % window || len % window)
> +		return false;
> +
> +	for (vaddr = start; vaddr < start + len; vaddr += window) {
> +		unsigned long pfn = pagemap_get_pfn(pagemap_fd, vaddr);

NIT: can const-ify.

> +		unsigned long i;
> +
> +		/* Not present, or not mapping the folio head. */

'Or a tail page' maybe?

> +		if (pfn == -1UL || pfn % nr_pages)
> +			return false;
> +
> +		for (i = 1; i < nr_pages; i++) {
> +			if (pagemap_get_pfn(pagemap_fd, vaddr + i * psize()) !=
> +			    pfn + i)
> +				return false;
> +		}

NIT: can drop the {}.

> +
> +		if (!is_backed_by_folio(vaddr, order, pagemap_fd,
> +					kpageflags_fd))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
>  int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>  			      bool miss, bool wp, bool minor, uint64_t *ioctls)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 56a28ce7d029..39dfb18dc10c 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -99,6 +99,8 @@ int gather_folio_orders(char *vaddr_start, size_t len,
>  		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
>  bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
>  			int kpageflags_fd);
> +bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
> +				     int pagemap_fd, int kpageflags_fd);
>
>  int uffd_register(int uffd, void *addr, uint64_t len,
>  		  bool miss, bool wp, bool minor);
> --
> 2.54.0
>

--
Cheers, Lorenzo

