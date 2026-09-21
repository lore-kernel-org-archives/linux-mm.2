Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AACC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CF36B00A1; Mon, 21 Sep 2026 14:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3DD26B00C3; Mon, 21 Sep 2026 14:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54A46B00C5; Mon, 21 Sep 2026 14:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 814276B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:53:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76D3FA016F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:52:59 +0000 (UTC)
X-FDA: 85238666478.19.08CCB08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A7FC340005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:52:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jnq63Tuv;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790016777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfpxOT295Cqy5dFG4ckdzBDycmvuVGEuSlnWiQ/SQeg=;
	b=iXk/Z/X/WQakNfig/gesjLCa2wcgufa6NpWPGHAvtGMSXV3VHbj4V+uJMkVwjzguOaiqkd
	sxqWyJjufwuUC3r4CsFs5SL2/fUdIUXW6EiY86xiXXs+nwKjxuWvddUyKgQ9f/Kr5iFHXc
	W0GA9AewxvwLWUdiR0IJEMOgX907N+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790016777;
	b=J7Pl0rt1IIEjI+FZJzKWozSVzTvgH8qJHApiMeONs3MdmDC4oesXxeOahDXeccIiZ6B452
	8CV3c685ovTp0BBU4/kT8i6yNIm+aPQPYt+wyRm7hh5eQwRdFBY8rTbCPTFUasr93M9NVD
	fKvuB9f1tS2xjbftskhQu6e3UIelyS4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jnq63Tuv;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC63D40697;
	Mon, 21 Sep 2026 18:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1981F000FF;
	Mon, 21 Sep 2026 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016776;
	bh=OfpxOT295Cqy5dFG4ckdzBDycmvuVGEuSlnWiQ/SQeg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jnq63TuvJEI9WpDbfOjntptRn/RdFpP+Zjx3XXhcutv4efWciRNs/gDn9y2frz8nf
	 /YIQN8T3B1Mk8g5fnsB6WYtYjPQs3Cn7fIqkVN0yVN51i84XW8wK3ZrnKR/FHhdf01
	 /OyI8bEh8LoSfsTFORhVaPNaU9KLKaLbi+NL67LPNJLTeSIHvunJ9k/3fN4gHapstO
	 0G/YCEHOc4LhJUkU08axdyME58tgh7J2/CY7z93TD9E6MtaRPoFwNF1ErPedXl0Pkb
	 RYXHnOiPnFnMDbbZmuvQx7jIIzPYK0JUvPN53RLXpxIrjPwpFv/y8GD7uZQ5E49VGo
	 zJuKbwJH/+kdA==
Message-ID: <bc3703c3-5798-40a8-88ae-98e1a9ea4bf0@kernel.org>
Date: Mon, 21 Sep 2026 20:52:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Yang Shi <shy828301@gmail.com>, zokeefe@google.com, hughd@google.com,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260910023411.514987-1-jthoughton@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260910023411.514987-1-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: irrz6rtg64forw3poxgf79fyefc1oqym
X-Rspamd-Queue-Id: A7FC340005
X-HE-Tag: 1790016777-764494
X-HE-Meta: U2FsdGVkX1/XX5Pyaaa9nRopfGfLMbWPw4AFnOsci7hGqUmYpsv1ZSYH4wgQ9B9hRe/c0ieHufQW4Cmpv18UKiJaaw8NGv9wWriVekFbSbyuAe9haCGy9hcMuwpSmJPLp+HcySvX4EhBzM0b5aex7ML6dxNypnSdlYoB6Y79w7iEGsgI8F0PjIoASY5jXjDbACvWmyWTX0mg30tz8KWiBrMp6wUQSpAopCT5zNlCZz3tausDadZo13f9m8u5OOH9KrAmxymgokyLv6DjiPlkjWYXYt5yXgJoVLZHnBH7x9JY11dPAysBFbgj3BR3xsdt1NesrmdIlI0I5K2Rh43RiVbQaLQwDk/JSarx7cmP39JacO3S5bkXxYNF3nglo2tC9foVZHU4izocU9sEZbj6TUS6KuYlJ1ZRVFCRTWKeo7iK4LHDVXiqfr5l6T8Mqfb3y+rGKvGe+hbuVVYLYrXmJ81OyB0xiSwK8jdGIoPEopTWQYfvEM+s6L7n7KMX0aykPvjyWozGhsc5K5FUoAKoibpJ5JaD7GlLTZB9ogcd6ZBZXdDntMU18an4+BMPMDJF6PBNLkWkl1Y7fMsR4s/N+v5Hbzabi6y4BCEhgUqCi5IR7A+xCi71BtNkMJDc633anxitl0AoOcdLt+rat/0dajUguHgfUZiTGObIj8mirnBdPA5yjeqDT6eg42bo5/T8+lsBffaEg0KJBIf6g9uEZWi5YCZ7cGQWHAlAT7V1xczFofl1veaUp5pFUJd8bw827tVbpFf4ofo7bxg5nRVsCaq/bEK6y/sa/CD7arh3o6IVuSK0zyXAuBxjoPXOxAsR8/Qe1QRbAnh75wlOuJBCYrzfcIgQrQTLpgE3w5n+6QSxZbRw2XocVa4YpAmp8odzwKm1pemAA5x8INs9tGKtSf1ojjZ8Yb0J0mbts/piA9kSnFXPcJU6TIO/YVoMzj/+IBmaLY+gSjn/jggof4M
 C7hRHSt4
 1xd1azN5gvusq6VWTRatf+jkJSFuC1riY1hGUtNoBhvfPDrp/2u0XPDe8U7qH5eDzla+k24rZig5RSRP1tKKI4GYPqwGmNsnMEmB9I75qK/loq8CTysjBTjqoRdChoYcWv7NksMKAH2wCoxAl7gh8+2vtewwcxHZGTszrmljYTC04Mv3mgb0Kxlxcgnr75imrzFb+QUk/9p5Mm6r8VerJSZx9loIaYiJwqrj0lk+JjCyUrwIwHuL6OYevfhaFV7d688Hz7zx17+9av15GN8vVRm0nUAYA5VBO8Fw4wscma8ueljPdI64qRWM/Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 04:34, James Houghton wrote:
> Userfaultfd minor faults provides userspace with the ability to manually
> install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
> holes in the VMA when a naturally-aligned THP is present. This is not
> true for khugepaged collapse: the PTEs will be retracted, but a PMD will
> not be installed.

You might want to add a breadcrumb here that collapse_file() never returns
SCAN_PTE_MAPPED_HUGEPAGE for khugepaged.

The whole thing makes me wonder why that khugepaged check is buried so deep down
in that function. Makes me wonder whether that check can actually get pulled
further out (maybe Kiryl's patches do that).

try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);

is rather confusing when we never end up there with khugepaged ...

> 
> When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
> userspace is likely to expect UFFDIO_CONTINUE to succeed on the
> should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.
> 
> This is not inherently a problem, as MADV_COLLAPSE is an explicit
> userspace action. But, especially because MADV_COLLAPSE can be invoked
> by an external process via process_madvise(), a rogue caller could break
> a userfaultfd-minor resolver thread. If khugepaged is later updated to
> install PMDs for khugepaged collapsing, that would be a genuine problem.
> 
> Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
> faults, as MADV_COLLAPSE will only resolve such faults if a
> naturally-aligned THP is present.
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
> v2: https://lore.kernel.org/linux-mm/20260828222640.1638457-1-jthoughton@google.com/
> Changes since v2:
>  - Drop cc:stable and update the changelog for the main patch.
>    khugepaged doesn't actually install PMDs, so it is impossible for the
>    kernel to silently install mappings that userspace didn't ask for.
>    Therefore this patch does not need to be backported.
>  - Update the uffd-unit-tests selftest to account for the new behavior
>    (new patch). This patched selftest is equivalent to the reproducer I
>    provided in v1.
> 
> v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughton@google.com/
> ---
>  mm/khugepaged.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 75639298efc2..e6947fe142ee 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1894,6 +1894,13 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  	if (userfaultfd_protected(vma))
>  		return SCAN_PTE_UFFD;
>  
> +	/*
> +	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
> +	 * userspace is expecting to explicitly install PTEs.
> +	 */
> +	if (userfaultfd_minor(vma))
> +		return SCAN_PTE_UFFD;

Can we just combine the two uffd checks to have less uffd noise? :)

"Don't collapse if we might have UFFD markers or if userspace fills the page
tables through uffd minor faults".

Overall LGTM

-- 
Cheers,

David

