Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34079CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33DA86B0088; Mon, 12 Oct 2026 07:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE8D6B008A; Mon, 12 Oct 2026 07:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205616B008C; Mon, 12 Oct 2026 07:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE7E76B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:00:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 606F2C0AFF
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:00:07 +0000 (UTC)
X-FDA: 85313679654.29.76654F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4A3DEA0008
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:00:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HMUrWNKO;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791802805;
	b=z2N1y+m7RKz0MeKDpUAiKFr+KRo7JEM5AvRQUYE3jW01QJ3yc8MjE1bmSoiaH9rZH0Qox9
	Iav6wNEbPlJX9DhDR5vPI/42/5W3IBrhaOp/OtMDf6exaKnDvBcvB5O8IH59rRm0TiHKfY
	fs7FyKQxv2wC7JJImGIh2YKcmyon+6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HMUrWNKO;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791802805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZUyYooaNkAreZrRLDqDxoLKaeDJp0HzcVnuWZtLzvw=;
	b=vo5PxdBgj0CAfQ9YSF4Kful4hHHS1dfQN1f2Oa4ZFxXRX1gqVowyWfFljh0yQkbaWIdakm
	HhE16v2BJZqc1YbpOc9LQXSnbkNdjqz/iihabuuN1vC41uKG4W+NV3U/u9nVL/Sh0R3vM6
	D2voOg7BhsVbMDpKMRRJ8zz900Z6YWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67C8A43A05;
	Mon, 12 Oct 2026 11:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F121F0089D;
	Mon, 12 Oct 2026 11:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802804;
	bh=wZUyYooaNkAreZrRLDqDxoLKaeDJp0HzcVnuWZtLzvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HMUrWNKOO069NBFceAk0ri4lP2xidDUhnyq4Kz36oZ6QNxxWLwkRIOMgObMvxpXg7
	 pi0lPBdSHnMQdBvfehf+TBimOMcMAoUA0NIzoTCFrFLY0TAcq2va6N3KdzP85rO2ri
	 3ztYkREun9slv/VkzLtkLE591gncOUlM+3/UVxz9X1kEswiiyyncZ4ds1bQIKsOKt9
	 eQN7VDfZZD1xZgLVQyYGMHWNOnFCOmqKraQVc4oi7R7MzWpKU6IProNqZK2Z5+opjM
	 S1Q/LHVnfLjTUB/VOjHXK2Z/rhC7Vi1AOCpU5Z3oA783s5a/wuzZ05pPDXpkUTr9m0
	 YwO5X61VqPQxw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 147CE198004A;
	Mon, 12 Oct 2026 06:59:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 12 Oct 2026 07:00:00 -0400
X-ME-Sender: <xms:rb3Mao11WcOR3DIGuR1Pf4VTM82MDu4rd3QyXp04Q6ZFJSnbUL3XHA>
    <xme:rb3MamBRPQ67jo9e10CpRdepr1hHlyb4IM_1PT75p0HPAYLfLqpws6m3UIZXKIbRX
    3Oet2_K8aDgrql4-SoFZBqoFivEJzsug6kZhM3w71oK7k_Ujg6zKhkXfQ>
X-ME-Received: <xmr:rb3MalGxuYO1t-W5X7i5ZqbnZ_n-JzTEUvpMfVAWyXQi30aBVHsKqAUFFmY>
X-ME-Proxy-Cause: dmFkZTEEaa1BbtdKDc3jlhza91VHJVzeik9AwuPPJE2+YRNb0VWxDJ7KxairyrNw7HjkuC
    Hf9gpzGlUcEgROp7zYAAvBKeeSyF6Emj0HwB1Low+mJ7BNrLMBeKnhUYdksboY/BugnrGR
    FAfBZKo7foRbum/OqvDikts/NThdyfqlBTa1yXdRdLER5NVgxS0OPfAZ3HpqdAy0FC/Mde
    krdyHwCeycv0FRyPfNtVioW02hPDA3mdm9zLpCxVKdyzMnemfHEJlYUTN5Wfobkq1fYRH+
    ZgYmJCfhhQgEC3qcr/yg996V6aOJbsJnB8KqPL1CBWtwkbHCwyO4YtdFEw4WYbvBHHdnBg
    FvuQXk7wGYOpuDV8cax3XjqMaBvXroysO7Fc5s9AIa/ZaOAsdMbjtiEUxLjcq+LUlHDLxW
    M1vnZMzHlA8uDbKoVTtKOuwIGsIKtBLxLSfOVg1fVwZJkl/LgpJMucR0Yzo5J7c6fBWYbj
    Dpb7D2WvMvmC3LxG8SMLyHcr+/byurNzGsJh+pDxiJ2OoMJZzuIgVyYr+BXX2avkMRiiF4
    /BWwsSxeznYbSFQ24YPmm3ErFkDJ80MMSNdG2BuAtAPVyFTwxbq7l13umOiqpYr7QesYmb
    exG1Nlet5munosOLD+Rqdn8X4SDF4c8d9Us55yTz20nL+RIAW73JU7GZYpng
X-ME-Proxy: <xmx:rb3MavDIu79lY70WSuAhd-Iq77WcQ-_FrDaaE5jcR-tYYpmPV_WabQ>
    <xmx:rb3ManaWqhntIALVVi1vay4oU85_4vEWQvxTl_3EeZul7B6bU-gsag>
    <xmx:rb3MavNQWERFoZyMhiHgGi8yeeHaxJRKYp4xKw2YE8YA2zFHfho8Fw>
    <xmx:rb3MagQSwl-h1VqV4P8PxvDmSFRw-Fc2spJswSbYFdxPTOhv3hAsIA>
    <xmx:rb3MakS5DSfMj4Nmrutg59IiU_8NhLEiPm8AX18Xq2MeyfVxPgkkX8Wr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Oct 2026 06:59:56 -0400 (EDT)
Date: Mon, 12 Oct 2026 11:59:56 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Yang Shi <shy828301@gmail.com>, zokeefe@google.com, hughd@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
Message-ID: <asy9PMMWm6waSXEz@thinkstation>
References: <20261003001859.502725-1-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003001859.502725-1-jthoughton@google.com>
X-Stat-Signature: gj3g45fyy859ymma846osr5t8ahc65ay
X-Rspamd-Queue-Id: 4A3DEA0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791802805-370901
X-HE-Meta: U2FsdGVkX18Roa3i3ERXunjK4h0m12dEA1PyuODY9jYrnZV2XmC97VeZZhxzx5Iq7EhkGC4p7PRn1oTHSeZhBEjm69XcvDHjAM6x5m+pk8rMH2OEkkj49DFbZ2yOPHoQN49LYkiAad5uQ7hxLZVokBdZlzMcbg6rbZQsgaI7vztb5ojOMrXsfEXR8AjLY/ZUkTHvRrtvMPozwok+GH+aMkSTFY8T3QpKt6HKrSJVYcwgJYSKa/JGr9mzPiQS/qD4FxaX1sKBdYxNFZZRdkxHSMlfi7KmIRMV7f5K9OAEkaLf75/2iOQ9dJ2bkXLmaiPjSE46pMMleOldN0UA6rn9zxPyB4u8sueElOJu/t06tNui6+4XHEto1qCfRA2OupUOW3Y4kUH8o6mh6pPCT0R5I99oDds2ph4xASZhJEg/D7Xrvtan/7F8gSSUS/ZWutHyEAZsBIxBcRUg0213yjCFU3J3EF0fqE00bbTVWc69wumMZxCT1AucPQb8M6McfL3k7NHz3DY39VK7YhTu9RbDfD90bk432ayK5huMaRC0+EfrP+9F7K8OIRqTWbhcsme35N6Tb+b09K3VCy51UAqsNJEcqPUBMhyBTOmvDl8A06QwWvlmLaYJ2ITvqVZFicfnKtPetAMRjFWmWpAIyH/TDQBuYVYOfpRUoz3Ftdf25AyMbT8ef9TX0OkIDfmDgMO6DqbJx3oTzssM/WpNpcig9yOg+Xptvx5Uw4DpapbUTTtbr/phzy1YOx1Kx2xPXLdxP36WlD9tnNhMqHn9PnRuWly7qmZMJRf+Mesa6lx6FNNt0T3IiZFHWPWADFVypjG46hQQ6quJTf/5ipFnwaIVP9k1C4CdGfHjtHEGn+3ziv/TWgD2HGe7u33HBHIT9GEYKNxKl/Xo5QibsN9v2fG7d/+m7WD93BHmbAr2K1QVkvMnZgu686F1/Sz+qMShvhwqFiW8KnL911ooIsNvLC/
 PIL6G76X
 3+Qohtk1FVpo2Wmw8+JNemQdWIxLg+DYtcb1HPf08o7Qr9lO/rtwPJAqpnZ2B4cbnmWl/wOOVaQ1zhq5HqtSW9DQFIhPjRjE7WpJQ+n/d/HLTOw3q298zSC/MStXnn/ivahzI3fzYQzOeQxhsVKHBWqOxRDCsnIFZIf5+6xN1OAYqwkE/R1jVWxIvegU7ucYkPUYYNe+WfbHZ+ihQgmMosMxcAENx6RWEHZkICV07DDP+rhliF5nUqAZPFygxaSItLUPOC0VnZYasRtkroNIMfobNE34NWQ76GPkKo7LX2MZ917v8i2WVESQFZn38L1fV4+LLrPhWz2BmpPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 12:18:58AM +0000, James Houghton wrote:
> Userfaultfd minor faults provides userspace with the ability to manually
> install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
> holes in the VMA when a naturally-aligned THP is present. This is not
> true for khugepaged collapse: the PTEs will be retracted, but a PMD will
> not be installed.
> 
> When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
> userspace is likely to expect UFFDIO_CONTINUE to succeed on the
> should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.
> 
> This is not inherently a problem, as MADV_COLLAPSE is an explicit
> userspace action. But, especially because MADV_COLLAPSE can be invoked
> by an external process via process_madvise(), a rogue caller could break
> a userfaultfd-minor resolver thread.
> 
> Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
> faults, as MADV_COLLAPSE will only resolve such faults if a
> naturally-aligned THP is present, so this is not a functional
> regression for userspace.
> 
> The naturally-aligned THP case is the only case where this quirk exists.
> Collapsing otherwise requires all PTEs to be present for
> userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
> correct. This check is essentially bypassed for naturally-aligned THPs.
> 
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> Changes since v3:
>   - Prevent page table retraction in patch 1. Please see the comment
>     next to it. So this patch now has two hunks instead of one.
>   - Reworded the comment and combined the userfaultfd checks in patch 1.
>     (Thanks David)
>   - Simplified the selftest a bit given the behavior change in patch 1.
>   - Undid a change in v3's selftest that incorrectly handled the case
>     where MADV_COLLAPSE was not supported entirely.
>   - Rebased on top of mm-unstable, which includes Kiryl's changes.
> v3: https://lore.kernel.org/linux-mm/20260910023411.514987-1-jthoughton@google.com/
> v2: https://lore.kernel.org/linux-mm/20260828222640.1638457-1-jthoughton@google.com/
> v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughton@google.com/
> ---
>  mm/khugepaged.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 913086eaf17b..438c4af1c058 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1868,10 +1868,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  		return SCAN_VMA_CHECK;
>  
>  	/*
> -	 * Keep pmd pgtable while the uffd bit is in use; see comment in
> -	 * retract_page_tables().
> +	 * Don't collapse if there might be PTE markers for userfaultfd-based
> +	 * access protection or if collapsing might bypass userfaultfd minor
> +	 * faults.
>  	 */
> -	if (userfaultfd_protected(vma))
> +	if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
>  		return SCAN_PTE_UFFD;
>  
>  	folio = filemap_lock_folio(vma->vm_file->f_mapping,
> @@ -2093,8 +2094,13 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
>  	 * and cannot be recycled to a shared PMD. Other vmas can still
>  	 * have the same file mapped hugely, but skip this one: it will
>  	 * always be mapped in small page size for these registrations.
> +	 *
> +	 * Userfaultfd-minor-registered VMAs should also not be retracted.
> +	 * PMDs will not be installed, as doing so can suppress minor faults.
> +	 * If retraction were allowed, khugepaged might continually cause
> +	 * unnecessary userfaultfd minor faults for already-CONTINUE'd pages.
>  	 */
> -	if (userfaultfd_protected(vma))
> +	if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
>  		return false;
>  
>  	/*


Did you run 2/2 on current mm-unstable?

Here, on e8d0f6a1b2a4 plus this series, minor-collapse fails every run:

  # failed reason: [unexpected memory contents after collapse]
  not ok 1 minor-collapse on shmem

This patch refuses the collapse too late.

collapse_scan_file() has no VMA, so the uffd check in
collapse_max_ptes_none() never applies, and collapse_file() goes ahead:
it try_to_unmap()s the PTEs userspace already CONTINUE'd and replaces
the page cache.

Only then does try_collapse_pte_mapped_thp() return SCAN_PTE_UFFD.

MADV_COLLAPSE fails with -EINVAL, but the page the test read beforehand
is already unmapped, takes a second minor fault, and gets flipped twice.

Also, your 2/2 missing Signed-off-by.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

