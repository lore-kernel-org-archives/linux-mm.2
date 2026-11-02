Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52F9606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsaOqqxm
Received: by kanga.kvack.org (Postfix)
	id ED4166B00EF; Mon,  2 Nov 2026 07:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85296B05B5; Mon,  2 Nov 2026 07:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A026B05B6; Mon,  2 Nov 2026 07:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8B666B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:14:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53997160BB4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:14:19 +0000 (UTC)
X-FDA: 85390071438.19.1689B6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EAD940003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:14:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsaOqqxm;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793621657;
	b=mItzE9kQYiFU0sK1+EZT9lLMN24M292zr5T73mK2Hli9Q/assd0wSh6DcPvBIBF8uPVQQY
	O4gdmJiEvUhuVyFwM/USv3gvboXJ6g0I0Q5yLeawPStAKBTJGMFJlgPF+SL+IfWxnSjOIJ
	PH36TcbJfJTz3AY9QVPHdIV1D0hDERg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsaOqqxm;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793621657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPahiPVhIkHB9HIPU+lncEVEvfQq7XDuVADEkW0Ex9s=;
	b=2BMBVlLUFKtSVFdqny9gaWfzLW/u7klC2oC1rchmJeG6x7ktYdK4WtiDgvcJhWCC/gSUrL
	rLNbwXk9ucTHBcOWQf9434Ayw+KCjujwAdVUWkWGbCdreDziUY+OJOWQY69DNPgx7rS4R4
	eDYiFtokXRSsxUAEAoKxXcKJMA/3fLk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D99D043F10;
	Mon,  2 Nov 2026 12:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F291F00A18;
	Mon,  2 Nov 2026 12:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793621656;
	bh=KPahiPVhIkHB9HIPU+lncEVEvfQq7XDuVADEkW0Ex9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bsaOqqxmm/wDTF06kQLZ7usCwZDMQcBem0NCjGecfGqC8YxYpb9r7JBcYY8Y3CUOZ
	 wjZmF4155okl3WVzEtR20fDyljYMSWuw6Qr8mUKjbLg/NXVbkQIbcLqDpcD8wCG306
	 pBzCi+pp2Cxgy8A92vrmJLMrhr/0+FIiO1/EqFkjRn/wKONa403xxZRAiICU7lrmiE
	 NSFjE2bN/rmb3XQ4Avj7NRfd5ekWjdPD1FRlQYZ72m6UTyzKHgzu3luE1vDqEnwL/N
	 /Q9dn1lPhX67PiGQPuNtSBpn8Ka5cotgaNAMYx9H0B9U8LBxNRdb1DJmqSYvtgMULQ
	 QjQv5OT5wLnJg==
Date: Mon, 2 Nov 2026 12:14:11 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin@linux.dev
Cc: zhaogongyi@bytedance.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@redhat.com
Subject: Re: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
Message-ID: <auh9cfHS7DYJAzgP@gremlin>
References: <20261031182256.40205-1-zhaogongyi@bytedance.com>
 <20261102101831.218090-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261102101831.218090-1-xu.xin@linux.dev>
X-Stat-Signature: xup1ndhneu5isixremj8p7ds1rnopqgo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9EAD940003
X-Rspam-User: 
X-HE-Tag: 1793621657-743586
X-HE-Meta: U2FsdGVkX1+xO0gIfn+tN/IjjoB0xGsjvbO+WZw0C6snqgUFF+wKsXySia9pUDIqtWnRtwTALpNwmVNJbhlgrJ+C83YnJ4YlTgq8JwhbK25owlskaTSq6Ok9MLcEy3A9nFfVMpklVR1PwN6Xcb9Cvte1w9gmOaSiiQYSHDlwaZGUCfWPG5ZKVMjcM8vRSmyHg/ev9Ct1eY4rWlMX9wD6sKV0Ql0gU77JmbKh4NgX4cA74tCKdFLS4YUyZQAhWJZwgM4OmoJRZinD9bsa90T4H6/T17V8iUI8lGuX3gJijUO5yBpnMVmM+HPI0VIBqLQ4+3uuBWknO3TdBwczaYoQi1lqQVyolqUFKo6xWp5Yxnu53dQXXmjUnAJKvLrjsPLDsWLT46tajzDcPs1zQsuGkp/d9EIUFllFiv5G7+D8KmuiP6kYieLIFdK9NQHp3s/rd9pBRFEa7WbqPImG+DOx/KrdJlD+EHgcBrd8r7IDm1oR/LULrFDG8AFa9YGkMfb0heFdcVwmQcqQBL2W/4WP0rE2+YHdwIpCY+5V4TCW04jgYqUxv6tIC+pWbRQP3I29zf5MnOA5YlSPbqPPNB0E+5rN6owy/KwsSOo3wL6ylxe/z5d6owtxUIpw5uEq3vDOh0sPi5W0Q/xOp3eyM5qkOx41kc3dDFRURrgYEANQD9s8BvwPXHXHh13FXNMlZkm9bZyDHv5DDblXHIFqATyZkj1XxEf5tWYG6fzFgY8sgAzO2r6ZshK7uKossWPYVbkKBeWnvA8n0gBphH+76Qy0TahguAVr2laEDLdLBqmzOd0I/k/VdOXy6CNDU7xf1w3yOfik/t387Xcwe389M5FROIG55LgYRY0XDkj0jvRg1iqWz71ECaORXnBPkhiKbrmJDpaT25/P4HMlIAtsoxCP8VCGouNOq7iw8bDaplxeKJk7dixTVbg60UhyBfr85GsMuHhLMkB3Mr65hksfgBE
 j4FF+v9U
 EIhT6jrbAnaGv1jLd0w2aDEuB9v+G/IpoDsfk6moU+ym/cs4mBpFMrrsCIpFZvY02ZyNMU8Vt++SMyt8dejGi7+67lkIJ3Z8SHL4YviSvrQs8sfUSNPJi4chrWHMA7EY9+BabngTGIZJki+Ex4S8S5gZg2re5oe9C0z8YNcaGHNACv3P08xVlzkBjAzIKDpur7ka9l0HXLi4rSBrgOdbe/GenYBhwp+BoGq8D9ds2VHgu9P/KCvxwwLenhwHbDpntNFqnZJHI0QgMsLUK60Lcnf4OGPWpkFtaoRp978tdk5KE+Gd8Yt4ASQb9zJPAVs8VQYYlaICjFKfs2kF6WEoApO4BuGiR0bWNCYA/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 06:18:31PM +0800, xu.xin@linux.dev wrote:
> > KASAN reports a use-after-free in page_address_in_vma() while ksmd
> > merges pages. ksmd keeps a folio reference across an mmap_lock drop,
> > during which mremap() can remove its last mapping and free its
> > anon_vma. page_address_in_vma() then dereferences the stale pointer
> > from folio->mapping.
> >
> > KSM needs only a candidate address. write_protect_page() checks that
> > the PTE maps the folio, and replace_page() verifies the saved PTE
> > before replacing it. Compute the candidate from the folio index and
> > VMA instead of dereferencing the folio-side anon_vma. Reject KSM
> > folios because their page index is not meaningful.
> >
> > Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
> > Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> > ---
> > Testing:
> >   Unpatched mm-new: fixed-pool KSM/mremap reproduced the KASAN UAF.
> >   Patched mm-new: the same workload ran for 12 minutes without KASAN,
> >   BUG or WARNING; fork/COW KSM smoke passed.
>
> Thanks for the report.
>
> I’d like to ask whether this issue is easy to reproduce on 6.18 since
> I suspect the accuracy of the “fixes” tag in the commit description.
>
> Besides, adding an extra folio_test_ksm() check is unneeded, see reasons below.
>
> >
> >  mm/ksm.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index d6f736a..f8af5ee 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -1307,7 +1307,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
> >  	if (WARN_ON_ONCE(folio_test_large(folio)))
> >  		return err;
> >
> > -	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
> > +	pvmw.address = vma_anon_address(vma, folio_pgoff(folio), 1);
> >  	if (pvmw.address == -EFAULT)
> >  		goto out;
> >
> > @@ -1408,7 +1408,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
> >  	int err = -EFAULT;
> >  	struct mmu_notifier_range range;
> >
> > -	addr = page_address_in_vma(folio, page, vma);
> > +	addr = vma_anon_address(vma, page_pgoff(folio, page), 1);
> >  	if (addr == -EFAULT)
> >  		goto out;
> >
> > @@ -1515,7 +1515,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
> >  	if (page == kpage)			/* ksm page forked */
> >  		return 0;
> >
> > -	if (!folio_test_anon(folio))
> > +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
> >  		goto out;
>
> The check folio_test_ksm(folio)) in try_to_merge_one_page is unnecessary, because before
> try_to_merge_one_page() is called, cmp_and_merge_page() invokes folio_stable_node(), which already checks
> whether this is a KSM page. Only KSM fork pages are allowed to pass through; even if they do pass, they
> will ultimately be intercepted by the if (page == kpage) check in try_to_merge_one_page.

This doesn't quite cover it, as cmp_and_merge_page() doesn't bail if
!folio_test_ksm(), it can then fall through to stable_tree_search() which can
return NULL legitimately there, so the page ends up in th eunstable tree.

Actually right now what's saving us is page_address_in_vma() implicitly
rejecting KSM folios (since folio_anon_vma() returns NULL for them).

So if you remove that, you have to re-add the check there.

This is very fiddly, and KSM is very worrying :)

(I'm sending a fix separately.)

--
Cheers, Lorenzo

