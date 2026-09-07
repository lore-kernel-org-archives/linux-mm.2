Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74654C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEB06B009B; Mon,  7 Sep 2026 03:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F726B009D; Mon,  7 Sep 2026 03:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395206B009E; Mon,  7 Sep 2026 03:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3D1F6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:53:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 893E4806C3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:53:27 +0000 (UTC)
X-FDA: 85186201254.27.DC76458
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05977100003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:53:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOcXGWgd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788767606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPZ1F3J8KBi9MBahvagaR9ROmfUoSVBBVkLS8cERORw=;
	b=OIBi1ry6Bt0MP0zg4fiVw49w/eKfaoatu2x5ifhrbLBJkD70Euf8Ef5m/dhOm4dGRRtAai
	Dl2yKT2OiajftWzttA8yl5acqj//WpuhyW9AsMUwkQEHsz3qbQ9eRRj0+S5lH4Dvk3Mnbr
	8RN352R11uaqFEsYg8NFrc6jHUDW+kc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOcXGWgd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788767606;
	b=F+ZYehMji86xmD/S5/ZfrluFgMUyncQm0SAIjwwkxKbriI7ghSwN0WncNFv2oWF3s9IlTd
	g/K33KW3H+J4RWY+EYE/BVNfFjXWhYBHDODbpk03KVK3mNdWTfS+eJGUcFSbGJV75M6qjL
	5dXjKpmfpupzWPbdFoEUttosY/+u7u4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 841B360052;
	Mon,  7 Sep 2026 07:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7821F00A3A;
	Mon,  7 Sep 2026 07:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788767605;
	bh=kPZ1F3J8KBi9MBahvagaR9ROmfUoSVBBVkLS8cERORw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MOcXGWgdidzTr8uSm3nVezqHIcr1nc28xnbSu6ByjN1peFiglJMoQ7TMIxM1rAuTo
	 +LlTSFr+sxJbGh23IWkyDELK3sIkYklSEX408UnsFuy9KFMnoN42sFcRJvzJ81RUZv
	 UH6SeeXYOqAk+dQLWuIXR7TZ2mGz9gbS6JMchxSKBC7mEGIWpb3InoZVHJ3ELsAuDd
	 66jalnuy7h0pOV2+WXP+Q97rTsRn2tzkmOQaABQkCzIqMMWqDSRO9ml93GCdfaK7y6
	 1gbsdCpfJaQ+C8zd9OdbBb+T33wq6Gz0pEhqAKaqjg0eAo5vPuC+iOVgOIaLEVm+gc
	 2JhtpdNdvGt7g==
Date: Mon, 7 Sep 2026 08:53:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: "Liam R . Howlett" <liam@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/vma: cover hole filling through
 __mmap_region()
Message-ID: <ap5pmX-RddQ-c90O@gremlin>
References: <20260906144100.849288-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906144100.849288-1-hi@tychen.cc>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yhnjzykwp4onc365jw6rx1h8xsug3imr
X-Rspamd-Queue-Id: 05977100003
X-HE-Tag: 1788767605-552136
X-HE-Meta: U2FsdGVkX1/IEJGJmra+6ubXECJyamJ4Jp3SXaiLGxillhwQni94En1DpCVM5Ezv3ZM0F6boSyAhcs1M7JtbYTYwr54DH9oIzyM3LISNj7/mFKlXtyLcS0Of5Umu2lsZgPTwL6TDIhvdCr5YEaKua/rzmlLCiGGq0YpocPPtwZBBYL/KoF4TqzX9Mj0e/GImW5YztqUNWT7ClkHWaqkDS8cQqQhcayveG5ZV6v6XaR17TpYlCQfYB7wDMmIIVGh3Cp6/OVBYTmkKQe+4jgEr3/PSbcZ/1Z7Kb0BfDYjlKj+bMWjtp2zVQrKCn6S2iMztw5pGc8s1aaY4oChoq9oMI6GeAD7MEllNKHUEs8giVkk5V2p2GiJUpImrjb525ZCHeu3/cQRVyjhKp7of9R1/JDVH691u1nKJPd+/DZJT+Zjx3EqUq6b+7BtoaV9Zvjizp/Ck3TioFMEUDzXn3OBr/lp26LFcNmPzCz5CQpwW5KVUCNFPZdF9EnLm2GlXCPpeZSgtrqui22Ny93poIHI0fXNG8vNeUGGLH7czIImcQhWZvdSuEj8RJDXS7G3jVKR3D5dBDQyV+7rMZYd7sjwU4Ax/GvN1KdCZ2gUW1upCLRt3f3kqEfRj6h5B0k2LwYyAGE3CkpF++/6NlRkEEVYtDVpp+lVDBPilMvc+wU8AxXltN6Ol+hPXCF7BIu5DjhECpJ1PUPKVl2dJ4BYNzHRzAa5Tl1yH80KX45jX22C5pUyPwRLicNR2rgtrD0sIui9j51IyBjxk5++S28tlnYyvueCbvDG/BAw2cJXOJU94tVcbPlZkaeIpYqoGGWQVtONgPNyesgSQMGM/sHkrFTroi9ETbreU9j+zUyZ0LEnYbqD5W2Iv9pYmAfDAVUwFTeJtv5kIvM6XoAKi38xlQWCCPvngy3XABEdC/nZirGJL/F5WK3g52tuJo25lUb72aaaQ7WtaoLuXI9FI1R0OfC1
 wZJ4R+PI
 jGcciFwGyaXJ9NY92VonbiGwimvaRxhUWspchuU9WoGyV3ay0oTRimu4uFUjECLG1RGl0KcEuhVPsEa1H9Q6PGLFv/vLRwhuXQM+WizEY/5LRad3Sib896ieAXasFSu9gKckeNxh5LJZHRmJt6qKlL4qFsRXv4kgc+aKgRt7j9NzkLkamBKfTT+wzH6pIVMwkvXqNsjIpHePZ+wtL2nP2drHo2TBhhQ69XzFsyM1i5z+mQTQ15f4uxtX9RRAxpgiORf0ioNY6NHldVpiE0oLYokUn/L8D6R+jNspeSd7pDGIBzQ/LhdTW/6rIgo7o01sqTY6V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 10:41:00PM +0800, Tianyi Chen wrote:
> The mmap tests extend existing mappings one neighbor at a time, while
> merge tests construct merge state directly. Neither exercises filling
> a hole between compatible mappings through the mmap setup and completion
> path.
>
> Fill a gap through __mmap_region() and require both neighbors to merge
> into one VMA. Repeat with only the new mapping's execute permission set
> and require three separate VMAs. Check boundaries, permissions, page
> offsets, map_count and tree lookups across the mapped pages.
>
> The full VMA test suite passes all 28 tests with ASan and UBSan enabled.
>
> Assisted-by: LLM

Thanks for adding the tag, always much appreciated!

I may actually set my own LLM loose on these tests to expand some more. Is
a good area for such work I think.

Though it still needs massaging to get good code :)

> Signed-off-by: Tianyi Chen <hi@tychen.cc>

General idea seems reasonable to me, and never any harm in adding more
tests :)

A bunch of stuff to fix below, but with those addressed patch should be
good.

Also please rebase this on the mm-unstable branch of Andrew's tree:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/

As there is a minor conflict with my upcoming work :)

> ---
>  tools/testing/vma/tests/mmap.c | 75 ++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>
> diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
> index c85bc000d1c..b66ec932a75 100644
> --- a/tools/testing/vma/tests/mmap.c
> +++ b/tools/testing/vma/tests/mmap.c
> @@ -45,7 +45,82 @@ static bool test_mmap_region_basic(void)
>  	return true;
>  }
>
> +static bool mmap_region_fill_hole(bool merge)
> +{
> +	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> +			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
> +	vma_flags_t hole_flags = vma_flags;

Hole is the wrong word, maybe 'middle_flags'?

> +	struct mm_struct mm = {};
> +	struct vm_area_struct *vma;
> +	unsigned long addr;
> +	int count = 0;
> +	VMA_ITERATOR(vmi, &mm, 0);
> +
> +	current->mm = &mm;
> +	if (!merge)
> +		vma_flags_set(&hole_flags, VMA_EXEC_BIT);
> +
> +	/* Leave a hole between two otherwise mergeable mappings. */
> +	addr = __mmap_region(NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
> +	ASSERT_EQ(addr, 0x300000);
> +	addr = __mmap_region(NULL, 0x306000, 0x3000, vma_flags, 0x306, NULL);
> +	ASSERT_EQ(addr, 0x306000);
> +	ASSERT_EQ(mm.map_count, 2);

Everything here is reasonable but can you please add comments like other tests
like:

	/* Map at 0x306000, length 0x3000. */

etc.

> +	vma_iter_set(&vmi, 0x303000);
> +	ASSERT_EQ(vma_iter_load(&vmi), NULL);
> +	vma_iter_set(&vmi, 0x305fff);
> +	ASSERT_EQ(vma_iter_load(&vmi), NULL);

Let's drop these 4 lines they're a bit useless I think.

> +
> +	/* A single flag difference must prevent merging with either neighbor. */

Similar to above re: comment.

Also worth saying

> +	addr = __mmap_region(NULL, 0x303000, 0x3000, hole_flags, 0x303, NULL);
> +	ASSERT_EQ(addr, 0x303000);
> +	ASSERT_EQ(mm.map_count, merge ? 1 : 3);
> +
> +	vma_iter_set(&vmi, 0);
> +	for_each_vma(vmi, vma) {
> +		unsigned long start = 0x300000 + count * 0x3000;
> +		unsigned long end = merge ? 0x309000 : start + 0x3000;

NIT: Can we make these const please?

> +		VMA_ITERATOR(lookup, &mm, start);
> +
> +		ASSERT_EQ(vma->vm_start, start);
> +		ASSERT_EQ(vma->vm_end, end);
> +		ASSERT_EQ(vma_start_pgoff(vma), start >> PAGE_SHIFT);
> +		ASSERT_EQ(vma_start_anon_pgoff(vma), start >> PAGE_SHIFT);

Newline here maybe as basic stuff above.

> +		ASSERT_TRUE(vma_test_all(vma, VMA_READ_BIT, VMA_WRITE_BIT,
> +					VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT,
> +					VMA_MAYEXEC_BIT));
> +		ASSERT_EQ(vma_test(vma, VMA_EXEC_BIT), !merge && count == 1);

Also can we separate out the !merge && count bit? So put this at the start
of the for_each_vma() block:

	/* If testing the non-merge case, middle VMA will be set VMA_EXEC. */
	const bool is_middle_vma = count == 1;
	const expect_exec_vma = is_middle_vma && !merge;

Then here:

	ASSERT_EQ(vma_test(vma, VMA_EXEC_BIT), expect_exec_vma);

Also a newline here would be nice.

> +		for (addr = start; addr < end; addr += PAGE_SIZE) {
> +			vma_iter_set(&lookup, addr);
> +			ASSERT_EQ(vma_iter_load(&lookup), vma);
> +			vma_iter_set(&lookup, addr + PAGE_SIZE - 1);
> +			ASSERT_EQ(vma_iter_load(&lookup), vma);
> +		}

Let's drop this entire block please I don't think it's achieving anything
useful.

> +		count++;
> +	}

Newline here please.

> +	ASSERT_EQ(count, mm.map_count);
> +	vma_iter_set(&vmi, 0x2fffff);
> +	ASSERT_EQ(vma_iter_load(&vmi), NULL);
> +	vma_iter_set(&vmi, 0x309000);
> +	ASSERT_EQ(vma_iter_load(&vmi), NULL);

Again let's drop this block, it's not useful I don't think.

> +
> +	ASSERT_EQ(cleanup_mm(&mm, &vmi), count);
> +	return true;
> +}
> +
> +static bool test_mmap_region_fill_hole_merge(void)
> +{
> +	return mmap_region_fill_hole(true);
> +}
> +
> +static bool test_mmap_region_fill_hole_flags_mismatch(void)
> +{
> +	return mmap_region_fill_hole(false);
> +}
> +
>  static void run_mmap_tests(int *num_tests, int *num_fail)
>  {
>  	TEST(mmap_region_basic);
> +	TEST(mmap_region_fill_hole_merge);
> +	TEST(mmap_region_fill_hole_flags_mismatch);
>  }
> --
> 2.55.0
>

--
Cheers, Lorenzo

