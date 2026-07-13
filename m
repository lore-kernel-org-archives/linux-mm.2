Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4CDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 09:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC736B0005; Mon, 13 Jul 2026 05:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CE96B0088; Mon, 13 Jul 2026 05:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E7E6B008A; Mon, 13 Jul 2026 05:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58E786B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:16:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB1981C8048
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:16:13 +0000 (UTC)
X-FDA: 84983197026.02.98E1369
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf08.hostedemail.com (Postfix) with ESMTP id B8C28160006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:16:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="v A8o/S5";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=TFo790AH;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783934171;
	b=yCOTK3vZ+UR0oV6IGp2VC/doH4p68FuvtU/5Y8osEsZC0tx5kyc/4dXpTjZ5Ne8w7Flgty
	/FLuTKDj5qZ9vP8VrQCqnGs6yxopi5BugjEaip/hXjhnnG8rlOPxraDf7/H78VuhqwyJ1h
	UgDAVJoEmjElGRsyNBAD36eIKIFvHUI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="v A8o/S5";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=TFo790AH;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783934171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCkZsKklgMbU6h9abQ6OltJgVod+mMJ6I9NuFl07crE=;
	b=r38kb3bPrIYPc6o4kgKuR7gZnLvu8zo/Y0eSeNp7HYP4tdV39NOxeDC4X2Pq5OhhBsM04o
	GOXeMz4y8Q6d0l00RnKvoVMCb+TBAZox7i5IoSC6fXdjwt1JGOqTMAGfn2Zw0mlGyG67yu
	TSrJRsh3/DeIReanqdnNO10KNxcN898=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id DE09C130006F;
	Mon, 13 Jul 2026 05:16:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 13 Jul 2026 05:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783934169; x=
	1783941369; bh=FCkZsKklgMbU6h9abQ6OltJgVod+mMJ6I9NuFl07crE=; b=v
	A8o/S5wjGfuAgn5RhOgfrmYAlz3mbA2So1IHVCi27GwvRKYj9htmwUfwI5+AXo9I
	Q6TPSq81L/cD10OOZ4JBSoYfpv8Sb2KWl6kg+ZIN9aNUj+bPoEJAuIJCVKvVQ7BB
	2XxKlKf1551RseQEwxhXWq7NyAhYms7TmDWQrUbGFWOMEJxv5yFrmh8OAcdaq8Nr
	lwXsxyenkxcpsOrQnIcEZv62dGx9Zesj8jhAXWTeE78LNjbsMTjC2DHJ2EXl3JNw
	ki1VRBeJ4qN6tpAa6m/aItvsgU2/+7qTrU2rQwUdiPSQ8gn8LolhTXVoGx8UzFdK
	w/qyHQdIp+ACXjaOnPhoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783934169; x=1783941369; bh=FCkZsKklgMbU6h9abQ6OltJgVod+mMJ6I9N
	uFl07crE=; b=TFo790AHrbMrEAeD+u9Ujo6VAqBl+PcuHvL6kVgUhg80RhT40CW
	I434epKkdMyZc5lxHucvMzoUXKJ9ETeI5lx2/OWk9NsI7BQXdYecrXQKaMOOGr2U
	6UD5rscJBy0UdFX/ALb5joTFfTG346VXXnnfyDyeUgB6j7L46I1/3yFLEr4l4Crt
	TrgDot5U82bBGetwaPvDpbpWewO7n96knXSBAF/nxmdyYmPtl1+ZgDw6wokYCXS5
	SMHbehOi15KrFTofN5hA0avmJ090rNEruQNVQB6Trn0olnVT3QghuQCopIvLqRxA
	FVxewWgJhMuCKLnBPN3aPMZ6bMP4mgxHzFA==
X-ME-Sender: <xms:2KxUaljYRAUm7jx40lulj3o3nP-3TOUXhQDXjmvPfCmwNDA5AVfBrA>
    <xme:2KxUagIRWteYr14R5vZQP84HAflPxwa-XiDKL_H3C_qgbJZACMFc2QKUiD_eFN9Ju
    4ZOW2S91xEuP6dj2BUDaZcairG23G_JBlND1tx1D4NUOzSKsRm6F64>
X-ME-Received: <xmr:2KxUarm7qtDEIbYHj_lkg8rtqBUMRNw-q_DpR63Xht7DeLHEO4dPuH0aSwuYig>
X-ME-Proxy-Cause: dmFkZTFpjGdNNNZHzGyOsdRvDPmeJOQXKVkSAGkVkGu2fgkSNH3LPYHy7jTW74F8XTcZMN
    pZOVvcgJ+Y2ro8jUVfaKG2GvwSRocHCxj1NBpBmzqT0PqPZGUf35cYRjjGRlf7xtPBQo79
    S2YpLr/uIyOMja5s20SZDYXrnf6/JmuwdWfBW9Ausgb8a1y23Uh5MhJy0rVWusMomPtDQy
    HoYfVDeI0uyhJELu+w/u8JjhXRpkOzm8cHmofWyU9N8Jkt+UZoeOszkEc/bznIX/j52CyN
    DnYnxzAw2QGZHf2JqNj15t2eH0Tq79P32xEyaXxftEXZLDjV+HDxE2DHl980eZv+SDvyL0
    DAyyQUJTIqFFpOUbjO2ZEj0Q5NzFu5S9D9YBTUfxqCJQkQHk7zA+FKFcF+N5NeDAxAf4Wp
    9x0wtrrHRCVkXQsD0Ge3lKGAqFzCmgg63XL+yXZW4aF/kwMQCzHBGsVZzJ3RMAHae8vAOT
    cKTqIqVNuw4Eg0btbXjxE46sp89qetqvz51qZnFjPgoygwcsEuAv9Kmn6bYf+rnjeIksDp
    jASmzHM5WdLXnkHkyUuYN69TW7zlSjq5I0AEFAVT3eItlAepbh1i31vpJ1q27xE4YjK8aE
    Ezsqw+7zIVkd7JwKlbfyPdOXUBaVWUB53d6o9tx2EWQmoxHlZOMv5r+PJwow
X-ME-Proxy: <xmx:2KxUakS5foqvcfbRw_fXzPqbyeP-ytEe6mya6PcjVMrPPNvo03W_NA>
    <xmx:2axUamYZH2jletZqspcy07f7C_r6pcIbjXdUD8DCjNTzzKq3vGIO_w>
    <xmx:2axUakjdimjyCbalVpIVhR-Vc7_UPrK4AgRCtYGyJOMFZUanhJwPqQ>
    <xmx:2axUanWO_EadNZolmxWW8HUZooWR4WkgL-YNakoUR47YMaa_ZvsKvQ>
    <xmx:2axUavUc8ZCcJdraIcWd0QMCuyKoZY3Z0aMsrjHro4IGr9Q6-SPMy67o>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 05:16:08 -0400 (EDT)
Date: Mon, 13 Jul 2026 10:16:07 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: akpm@linux-foundation.org, usama.anjum@collabora.com, 
	peterx@redhat.com, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, david@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for
 PMD holes
Message-ID: <alSqkTahOx9uc2Uc@thinkstation>
References: <20260709121629.205562-1-kirill@shutemov.name>
 <88169a4d-157a-4307-8e21-554b122fb411@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88169a4d-157a-4307-8e21-554b122fb411@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8C28160006
X-Stat-Signature: zwc8hzm3geazyfie5u1qbyr8bj9donoy
X-HE-Tag: 1783934171-810117
X-HE-Meta: U2FsdGVkX19EnD43IKaG5bGMhvW1tPdumhx14QDAZAlmbjmjDYniM98jx/d0+blxabj3mR0o5+l88GIxz/tBE479pv6xAZC/8kZoyBDCNEnyLi66R0Nn0P9lMwGl/CY50pZn5lBKjF5wPzP+DmnTWOzmiAmdJFm2tgvJwWA4x5R0w47auVEae2voVxuJRcQuGHYkRjo6j2rnzCxQZseo4xn0sanOuSNgraYXyOWMLTHWzfosToljjjUhhaAZhD6VpZB9DwKKHhAj+Gjf/doEKdkCbW0GCJnQjJBnfonlWvVT6oC7kxoMad6LWNC7GCjDeDn9oHNs9cIEXtqFdPWq4xksOdIpiYP1yqdRxafo0Qw6HUu+4rBvtf4QwXfkL9zBrBATRb7qtJXeDf/pByIJwqo4+4IVN6rAyANsBYjfEhIX8JN3xr0YBIE9EQz4hhTM8QQgCflGPi/3jgGs5u+cBsTLZwlrGhB2bJJtYfbu9jt7b4pfF3DrfVp9ha1iWIrMudo8/kyC55lF9/Uh1v7X00skIQbEhj80qG9z6MicTSVfexYbIvY6VbZCmugiRWjCOKYAzlQegeuyoLqh1CbrqQ/q+6lghfAy4VIQhgRz2GCQBa+UIrCFpdWpl+fcMG7zcPNLbFWwbO2yCPURGpdtmI1DF0jBbXsLENNFVisgY6ADqEq1ue4OFYbaQYTExGMM4nmpaK67iCOf/PNbYwiy5bBfwrOcuOYGbQnPzuY4FSaYA/2XJkAJypmf7DEE2hJc3zhZieRm4wkae+GNZA57R3frbX49NKR4DVriJ2p0q5sKY0Afg3im1UqQYFa57naYSxrmFm3VY1VxhnDWYEhD1vxdbaJEfpcTsRtyT+d7cGIbAOudd1zQj+vovQJK3qGMEyX/ToLEesphI2loU9obidg0vwZ0GW/6GBLz6wV0ROlFl0aZl/4KjgXE7v72muOnViwJdSKWigdJMqGC6RL
 3TueG0Cg
 qca/qQxAz4JlTFkOVFLD0CKe0dCRr6+H+AZy7RO+RWkuV/1JV2aw4xjL9dbNBxphIrcWQpxZADfJudK1tdDtc4u9RZp5OSO02nhSpPGEmjBGzDsWCXdQT7lg8RyQEwPsVsJ/OjtJtV4/FrrN0mZS849niedd4O7TdyKorWsMe1CDS/4s0ukqjlUgUfYtw257dc+VbDF3WwSg0hbj3NuPsQGUhB3EfyjjrDU8KpSV2SGWn6uLiIWrJZSjtStgsZTBnbYw2yc/uOPBfZgm3c2jEHFrYYiweJCWLa2gdq8PL+DM3V8nUdBjwZVHih5OJLhDY+nUGnZRjhQ0+p6y7ZUx7OOcYNOwqV7KG5G34NTEfi3fXwFuRRDK0DpU5tWp6qpYA+vBV9DbppTDdtszRa3h7zi0EA21+5dYJ7mRsHrLxw7uMojTrBf/+7X3I8ezNF24Dt61eK/Bt+WsKWhqPezUf4IzLfQY9RH+N9bq62evVbxMVIezEzkI3++cbaIRdO7y7zdpjIv4wH1/ovTPy20yYtxhKA4lZ3dLv+TqXyDORefa4M2TY1BEHQjpnxVbUjDD+3Vf8QW9YwNA8Drs7mkilWSmjrkPY2THUcVdPnhTDGhuGO6/JMMkRIe2l9YTpAyqD7dWKmmXEmZTGBM88XyhQ/9Phh2WN2A2gzy8aqdRObHlBRS0YmmZC4lbvEnvdduRvmny0RfdlnGuh6RZNnrxhkluYAevgXZ0W9pp+OJci7fvOPT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 09:14:12AM +0800, Zenghui Yu wrote:
> Hi Kiryl,
> 
> On 7/9/26 8:16 PM, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written, but
> > a range with no page table at all -- a PMD hole -- is skipped:
> > pagemap_scan_pte_hole() tests p->cur_vma_category, which never carries
> > PAGE_IS_WRITTEN, so the hole is neither reported nor (under
> > PM_SCAN_WP_MATCHING) armed.
> > 
> > MADV_DONTNEED has fill-with-zeros semantics: it changes the contents of
> > the range to zeroes (a subsequent read maps the zero page), which write
> > tracking must report as written. An anonymous THP is write-protected in
> > place as a huge PMD, so a full-PMD MADV_DONTNEED clears it to pmd_none --
> > a hole -- and the zeroing goes unreported. A write-tracking
> > checkpoint/migration tool (e.g. CRIU) then treats the range as unchanged
> > and keeps its previous contents, so after restore or live migration the
> > process reads stale data instead of zeroes -- data corruption.
> > 
> > Report a hole in a non-hugetlb uffd-wp VMA as written, matching the
> > pte_none handling in pagemap_page_category(); the existing
> > PM_SCAN_WP_MATCHING path then arms it via uffd_wp_range().
> > 
> > hugetlb is excluded: pagemap_hugetlb_category() reports an empty hugetlb
> > entry (huge_pte_none) as not-written, unlike pagemap_page_category(),
> > which reports pte_none as written. pagemap_scan_pte_hole() fires for a
> > hugetlb slot only when it has no page table; keeping that not-written
> > matches how an allocated-but-empty hugetlb entry reads, so the hole and
> > the empty-entry cases agree within the VMA.
> > 
> > Add a pagemap_ioctl selftest covering the anon-THP PMD-hole case.
> > 
> > Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name
> > Fixes: 2bad466cc9d9 ("mm/uffd: UFFD_FEATURE_WP_UNPOPULATED")
> > Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-fable-5
> > ---
> > 
> > Changes since v2 [1], addressing Andrew's review:
> >   - Describe the user-visible effect: MADV_DONTNEED has fill-with-zeros
> >     semantics, so the range must be reported written; otherwise a
> >     checkpoint/migration tool (CRIU) keeps stale data and the process
> >     reads corrupted contents after restore. Add Reported-by/Closes.
> >   - Reword the hugetlb carve-out to rest on the category functions:
> >     pagemap_hugetlb_category() reads an empty hugetlb entry as
> >     not-written, unlike pagemap_page_category().
> >   - Drop the redundant MADV_COLLAPSE fallback #define; it is in
> >     <asm-generic/mman-common.h> and used directly by other mm selftests.
> 
> I hit the following compilation error on mm-new:
> 
> [root@localhost mm]# make
>   CC       pagemap_ioctl
> pagemap_ioctl.c: In function 'unpopulated_thp_hole_test':
> pagemap_ioctl.c:1130:31: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
>  1130 |  if (madvise(mem, hpage_size, MADV_COLLAPSE) ||
>       |                               ^~~~~~~~~~~~~
>       |                               MADV_COLD
> pagemap_ioctl.c:1130:31: note: each undeclared identifier is reported only once for each function it appears in
> make: *** [../lib.mk:225: /root/code/mm/tools/testing/selftests/mm/pagemap_ioctl] Error 1
> 
> Could you consider addressing it like fd5295afae91 ("selftests/mm:
> hmm-tests: include linux/mman.h to access MADV_COLLAPSE")?

Yep, will send v4.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

