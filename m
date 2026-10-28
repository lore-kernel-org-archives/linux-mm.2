Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB604606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRDfQyGg
Received: by kanga.kvack.org (Postfix)
	id B7CDF6B05B2; Wed, 28 Oct 2026 07:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D846B05B5; Wed, 28 Oct 2026 07:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A5E6B05B6; Wed, 28 Oct 2026 07:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85FC36B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:38:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ADEF140C1A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:38:39 +0000 (UTC)
X-FDA: 85371837558.30.323E831
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6ABF6100003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:38:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZRDfQyGg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187517;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywWl7XcLzr2gYC9cMN39pI9Pkm7GstMpNH/8mWgoT6A=;
	b=JHfOIAzkSJ8el5IK/ZOnTDFJKpaYQerPVGTmqLC991z7tr7ETKFDSCYjZaPca6zNG1iKBx
	tIyhfNaTCJD588FgACX4U99JAAy5TAKCMXs8kYOiD6/vDYMQEzYMRelLATM9n7oJBaEte5
	NDjM6x5R8jv40THv+YiTd+v/BHwJqe0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZRDfQyGg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187517;
	b=4ZS/bcfwGGjgTIJRuEF6fgRN+N7IXz3OZJpJcy4rMBg8UgbwPU1IdWUpvuOzB/F75MvgMT
	hi4LIXD87kTZcnHONydM/4pYmtWTpW4txZZpr6rJASu3k4KtlJMqyqC3mR87NFVg0Mmqdg
	3YJqkoTr+AIYJLouMYNf83U/K7mlk54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88894601FE;
	Wed, 28 Oct 2026 11:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C6D1F031E1;
	Wed, 28 Oct 2026 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793187516;
	bh=ywWl7XcLzr2gYC9cMN39pI9Pkm7GstMpNH/8mWgoT6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZRDfQyGg0JZJ06lb7swngyFiH3oCkUY52mMcko6dlv7CwCjdNrAvzKn2D4Xrzv0aZ
	 C7gwJy0hhT6+UVkx+cnhbddYsh2kRCVf0no8/8GEsCmy57Bs/5LQIwQysbHJm0/tQx
	 +8xYf6+sM99r0fx/JTkfIcDNrppHau6nPiC1MMtv/7in4ICQbrXQjYC/G9bmxi+stT
	 OkGFtUsBEKftdnSyuPbHjSvTqCgf6EKOv2EYeQ4qeQGpyl3MpNAlMdutS19cbKiSnQ
	 h6F3fcHOMAiyrr0KhZH4xU1KsbwRe7QqLkSlXj2eBoelA0yGgR1DO0Q4/IL6Nzrz5T
	 DPXMzK1qN1oQQ==
Message-ID: <sashiko-outbox-187827@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guilherme Giacomo Simoes" <trintaeoitogc@gmail.com>, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org
In-Reply-To: <20261027113813.1332096-1-trintaeoitogc@gmail.com>
References: <20261027113813.1332096-1-trintaeoitogc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 11:38:35 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6ABF6100003
X-Stat-Signature: zzfrjyqh3xrauk3sjq1h8hztgyozqzw3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793187517-934686
X-HE-Meta: U2FsdGVkX1+W1KS4IbZq2lGKclqRuRdThtwho/yaP2M5ribJW4gW7igrxpD9UY+n+/w0uJt3P40x7unJ+l+qLo8y4ylc8eJ/tVgMwogkGbNoCBeosDUCf/bMbggcZFNhxfI4e7Y4anfde646Nd7YA/0xvmGqnnPvdpCBjTe2JF7WVeihHpoSs1BssjfwhkVr9js74+8ThbZ2uMbg7OZQWdkWurtD4v5Jy/c6+L9xQBOzUlRTEZbccKKAKTGLfjYcK90OiKv3t+XywOwU78L6SkzXObaY8u4cwdl0S8rXUKwJRJKp8yFKv6z8dZXcYnmrRx2pyVhil+2Km+97CwNgqOz+JQ3RutAXwcpKrGc5jSxyrwCXAFpHg5p6NQiMXjhvlSr+a6n1oMLR8lsUo72R5ZjLkUTT8NoxqUocrWC4z0qIPXISTS1WTHrhO9dNoYXEOGK16dLWxbFMrzWWn2LgDMfJHIIQIBgETMIeAlGIPILbY1ZS48HyHAQ9ek/zvX0Q6vKTkUQuFi3JlEHxRHeaCoClhGHnR87gTrpOQzEi9R31gj/mzleGp6MdR8sljHwJ7tYJYOSkrW4wrJvrBIYIrUxyMPyOnSSrOdHMqzOkbPd+XcP7gqRwzvQ9Yv7Gst1/NiB6OTBU74yR4p+ABd+olPxPJoJOqXfkWy1W0FcoxVwFA/OcuqE+t5rxAf/8uxUyArvuF40yL87GJ2qt0x47qRHGPs6o3KTsdKUYzNsm9pBGTjmkF3jF0mmm5p8rukTbaDe1HMjUhorIe37euCqNhjeYzjSA6S2qjBohUCs3kYD1w4CZE2UDmtdV5J4si1RLkQXuZ8BYE8SFESs1whbpAejqNKIKIvkW0njyucPS1ry+wv9/JSESfj0+Iozzcg8SdkDtl1ZMTG+MSQRcuQEM28pUhWC2rR6B1LJKfPsy9Ytuvj3GZ9pNFj1nXRIFROc8NjRq3CzUtOysNq4BR78
 rLQKOfTD
 It2ek0qRA+VbQZiky0j0GrqIMQTAKenjdp2GJKSNk1wxx62aKkKfi5+MCgYGLcYZllE8CzY9y4NCJsAcsuWbiZ7atgOlDdUtw8dtTQbDPRcW3q1TgSgaDAd8/mRa1KSft6Bp+jlkMNaQkZ9wtpeHZ1V548Uxuo1KpqteZdZgFURy67YrOoatxXMXrUKTrpyUtrpQZQjQOMAMGK1m6zGKUzh4L+b0SQCTPK/c/jE53NCiOxQsMUKyJpSVyV3NA8958QHVI/xmy1yOZjpTfF2R920VVmZCir8Z+528TrpzICfZFYazXoph8vqlVXeTPPeLxVpz6aEFledwy2WYhuhYkpeHCf2qCl8ZZ1yixYa7G4zwItxPdNkEDJhj+m0/zwgusvZVfgD8QItDPPzD3mSUJuaMVG4IqgZ4cG2hN1tRQytz18R6jSSzTPnSOahU6BTHE6z7tE5BoIGzbNR+yOQbh8T86ZVAQigdig1rpgB6YVroyl3KD55+/I6GLZBEuw/p1IjDWqxO8nt+OzGVq5JwYa9H7/3NR9CzL0594JqRjZwU1XbmYX7zYjwO43ms/RPZdkEyxo1j20nO3vhny26cKGAM7lGBKR8TjNrdJSt5ouHdKQeDk2jywYcajuV+PTR/hKZ/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: double decrement in pmdp_invalidate() via page_table_check_pmd=
_clear()
--

commit df830550fc83c05eb08f00e78d36d32212821daf
Author: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>

mm: clear pmd in pmdp_invalidate()

This commit adds a call to page_table_check_pmd_clear() inside generic
pmdp_invalidate() after calling pmdp_establish() with pmd_mkinvalid(*pmdp).

> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 6e83ce3801b8a..bbf74c73a1471 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -215,6 +215,7 @@ pmd_t pmdp_invalidate(struct vm_area_struct *vma, uns=
igned long address,
>  {
>  	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
>  	pmd_t old =3D pmdp_establish(vma, address, pmdp, pmd_mkinvalid(*pmdp));
> +	page_table_check_pmd_clear(vma->vm_mm, address, old);

[Severity: High]
Does calling page_table_check_pmd_clear() here cause a double decrement of
ptc->anon_map_count or ptc->file_map_count when CONFIG_PAGE_TABLE_CHECK is
enabled, triggering a BUG_ON() in page_table_check_clear()?

On architectures that support CONFIG_PAGE_TABLE_CHECK and use the generic
pmdp_invalidate() implementation (x86, arm64, and riscv), pmdp_establish()
already invokes page_table_check_pmd_set() before replacing *pmdp. For
example, in arch/x86/include/asm/pgtable.h:pmdp_establish():

	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
	if (IS_ENABLED(CONFIG_SMP)) {
		return xchg(pmdp, pmd);

And similarly in arch/arm64/include/asm/pgtable.h:pmdp_establish() and
arch/riscv/include/asm/pgtable.h:pmdp_establish() (as well as
generic_pmdp_establish() via set_pmd_at()).

Inside mm/page_table_check.c:__page_table_check_pmds_set(), the existing
present PMD (*pmdp, which has the same value later returned as old) is
cleared first, and the new invalidated PMD is only accounted if
pmd_user_accessible_page() is true:

	for (i =3D 0; i < nr; i++)
		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
	if (pmd_user_accessible_page(mm, addr, pmd) &&
	    !page_table_check_huge_zero_pmd(pmd))
		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));

Because pmd_mkinvalid() clears the present/valid bits (including on riscv
since commit bdda2887cbf3 ("riscv: mm: Fixup compat arch_want_old_prefaulte=
d_pte()
and page_table_check")), pmd_user_accessible_page() returns false for the n=
ew
invalidated PMD and page_table_check_set() is not called.

When pmdp_invalidate() then calls page_table_check_pmd_clear() on old a
second time, mm/page_table_check.c:page_table_check_clear() decrements the
counter again:

		if (anon) {
			BUG_ON(atomic_read(&ptc->file_map_count));
			BUG_ON(atomic_dec_return(&ptc->anon_map_count) < 0);
		} else {
			BUG_ON(atomic_read(&ptc->anon_map_count));
			BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
		}

Wouldn't any call to pmdp_invalidate() on a present user-accessible PMD (su=
ch
as during THP splitting, madvise(), mprotect(), or mremap()) underflow
anon_map_count or file_map_count below zero and hit this BUG_ON()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027113813.1332=
096-1-trintaeoitogc@gmail.com?part=3D1

