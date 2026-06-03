Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62E8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105896B008C; Wed,  3 Jun 2026 08:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCF36B0096; Wed,  3 Jun 2026 08:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A256B0098; Wed,  3 Jun 2026 08:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E592B6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:54:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82DD912031B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:54:25 +0000 (UTC)
X-FDA: 84838594890.03.B6EC11D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CD3C5100015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:54:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKld6tc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30TlrB+n50Kd02bZUSUoY+UoKZNYPWG5yVxkJ95GHA0=;
	b=4WZGFV4ALtimOJz0Ng1p2G6SFKPE4zrxV7EHGLs0b1ohkgOvyqLPG6bMCr7FUxzIZaGgV9
	yowdAP7XThzZfj9m5auWE4RAT5uIqnWAoGY6DFzie7ygdz5gLjKL8pdBWlYs91Uom1Oq+P
	OiKogVFzGqPADelOCZlkv+rz0ujURPs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oKld6tc8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491263;
	b=LzgwjBBDndtFF06vKuXtj6+mSHxueWVKxuLe8tS0zel0IHvKfosD2i1o0LM6wfRkhWyhsj
	/DHrPZ8/dlMHAP1rBfTRpAqqfI2jGxxQS7YHGj9UEbdiUIZIHUmOzFIjvLpYlAV5mgXdmp
	wTFDkaL8Sddn+TTLmIQllVDkgmXWC9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0289A44273;
	Wed,  3 Jun 2026 12:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06B11F00893;
	Wed,  3 Jun 2026 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780491262;
	bh=30TlrB+n50Kd02bZUSUoY+UoKZNYPWG5yVxkJ95GHA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oKld6tc89tXPvQ+Ce4LoyO3EWpk6t09l7ALcOBmE9UcFl2b5rSDRjGyhEgl7k8sml
	 kBtuhQYcOxkSa9Db29wn5Piol8H6yXp2VPK4MxoXYihtLmibdkBlDbeiQ75MANBdc4
	 ggwGWirs8KRwx0Zc4qz9sqt6DzcJlnDfV8c1QBo443+2I9oqvxqT1kYdWV1vUPry5r
	 KKsEQirB2k0vNFONmWMQN1KRLN0/8WbKLwEZC5q41sWq3Ofsv5ZTLYyapYzx14jCrI
	 wvoUnqr5U7sPWZ45LYmA59Lwt9hxQwZyVyt3v+TdaOGxY87g0FPpc9d7pNYJDxUO5f
	 2nsQDmcx4o2sA==
Date: Wed, 3 Jun 2026 13:54:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 04/15] userfaultfd: test uffd VMA flags through the
 vma_flags_t API
Message-ID: <aiAj3teg1-9-GoyQ@lucifer>
References: <20260529172716.357179-1-kas@kernel.org>
 <20260529172716.357179-5-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529172716.357179-5-kas@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD3C5100015
X-Stat-Signature: pufrsrnep9tduqrz4cq5j78t41gde1mi
X-Rspam-User: 
X-HE-Tag: 1780491263-384163
X-HE-Meta: U2FsdGVkX182pcFriOOee7xiW6ToGHWeeRhWUvYw1CEvZionzFRQT5TwfcdSplc92KByBuxfSV5MCx/Yi4UV93K3JGCi9PoNotXI1Ywj+rSIFOu9nTg8AKpil+8fAQars0Tc9WJ+B5BR2OvE1FRJ6gtzCuz6/VZPJn9CmKNzvgFlgbh9Ku3pw5iidtFj90/zN0sYMK+DkJg68vJ31lzRHBHW6ZiJwtnWDIvWljWT+twoRIKI7bek2eq3WW48MtAc/mtRx5ZI4mHR23Wpk+EevcdemKsPYk92XHUxHcgNnAcEH4qJ4oC5uFthFFNPXpUfYDbKiQL0fabxoHopgvxo3qqvYeb0qVID7zn7NIdYviEK3qKJFHoVGd3jZ/1KQSq5FJ+q9QNK7zATwXsqWAzKDLcQR0o5Y43pA/VVC3u9CZ17eDeuD8m+cqfrirxCynylqEXJ+RMg3Q4xxhC5fBgGoiyjMuHuHA7PpE5wwbrtcKxsjwdz3bLmzq1qUS49OetIbkjQ05oc6mdDq9N90njopM6VJvFvdoI6nxQRD2v92Htf+FIq2g5zs6RWD+/QVoTFta3iGXcf6GJzw7gNxkZ/QBNSZT4hP8W9dDUcftI/1SwIpZ79A/AlPTnqccRNpG2HosMoBsyRB4KuiJjP9ogZzkxf02KQUPwdcnAN2G4L4M2m1g//0jXyMkRlEVVqNnwrtAwDYXRlWzIrTpyrtYWRnBXDJY3bAhbwkKr/9zcYraIt+rNNLeBavoBmHqHbybv5cIgi64dATC2mf8kfs9HM66CRuK7oOf+xi70sw7BaKvYqiGh2qw8Q5DqPz3RXFFMHWdJZeqfnQCRfz8/C2x108PHPJ8H3IHqUt15TMauKnb+ORcNUCQKH4s5cwVRBWM9cbta1Q7dLISxG6V85I1/lUbco2KpWiTwH6Qrg1V+++sfhYlHzJpIPKqMExHwpCQgOyvTv1u5MGgdIrlPCbil
 XJehjZ/l
 4d9z8iT0aq2HyFv5heRiv/L/qYvVJDspLNyy6Q1z3rL7Zht3YvSwnoiI6uUX1Og12dz1gfHfHqqdwhqs+OOYZIlN6uwDoouyMqY+m3aVqtIAUEPEGxgrCXq0aHHPLl+0WS6in8+hl3veJSJWROaOoPaXPm3YgJhHqGSnpf3bMifkSKCp1mQnKSOJqMWTVMN9ec5qoJ2p5jT4OtY8lrkIU4cw4w5m4kJbJjpLqV6WCWKpBwXf/SQYr/7w0b5a8jhQgHvnP3ryGcMWbri+nkIPWTpcbr1KJJyBPvH58iLfUhYepfijmdQkmKHGfgd1YgIDjOqxR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:26:33PM +0100, Kiryl Shutsemau (Meta) wrote:
> The uffd VMA-flag helpers read vma->vm_flags directly. Now that
> config-gated per-mode masks exist, switch them to the vma_flags_t
> accessor vma_test_any_mask(), which is the going-forward API and keeps a
> single place (the VMA_UFFD_* masks) that knows which modes are available
> on the current build.
>
> No functional change: vma_flags_t is in union with vm_flags, so the same
> bits are read, and the masks fold to the same code the open-coded
> vm_flags tests produced -- verified identical on gcc and clang, 32- and
> 64-bit.
>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Thanks, LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> Assisted-by: Claude:claude-opus-4-8
> ---
>  include/linux/userfaultfd_k.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 658740df2978..c4f2cc6dfcf0 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -178,7 +178,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> +	return vma_test_any_mask(vma,
> +		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
>  }
>
>  /*
> @@ -190,22 +191,23 @@ static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
>   */
>  static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
> +	return vma_test_any_mask(vma,
> +		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
>  }
>
>  static inline bool userfaultfd_missing(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & VM_UFFD_MISSING;
> +	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
>  }
>
>  static inline bool userfaultfd_wp(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & VM_UFFD_WP;
> +	return vma_test_any_mask(vma, VMA_UFFD_WP);
>  }
>
>  static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & VM_UFFD_MINOR;
> +	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
>  }
>
>  static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
> @@ -222,7 +224,7 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
>
>  static inline bool userfaultfd_armed(struct vm_area_struct *vma)
>  {
> -	return vma->vm_flags & __VM_UFFD_FLAGS;
> +	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
>  }
>
>  static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
> --
> 2.54.0
>

