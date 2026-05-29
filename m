Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47786CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A354C6B0088; Fri, 29 May 2026 10:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BE66B008C; Fri, 29 May 2026 10:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948BE6B0092; Fri, 29 May 2026 10:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853676B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:00:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 499B614017B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:00:26 +0000 (UTC)
X-FDA: 84820617252.15.AE5E7DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 487B140021
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:00:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neeNnvpP;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780063224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o53KZSM1xwnMx9qRi9blrTJDTT9nvtmbWfg0I22/pKw=;
	b=KAcu0xsMQ8zz08EvQCRo6TdNJTSFxYVRll1OtU4EtFai1BBDiRvMzI0udMUDy4J4S5/mTl
	bZY3LRVkbo6etRr6WAue7guN2re1GxmCTRJcq61Vvozjaf852sJ4BsZPoNmZds4RobjF4G
	k/poc9tQLHpf4WE8vzoFq8sxlp5JNSY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neeNnvpP;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780063224; a=rsa-sha256;
	cv=none;
	b=KvDWmu6ZkjonsrS5gK3kmoQfoGaepH8yZi6ntSzZyyu5+hVWXYbr5GZRUbAyHhvTEbzyIQ
	glSdarBDzEFP43cAQSvfvSixWhiSJ0Kp4Wl9W8hsb6MBYpXFomElLYwwqbzG1tf+xwQ1TS
	NTcRNV5QYHK+enrO8PMmbUzrz+ygL9c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1254743F01;
	Fri, 29 May 2026 14:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFDA1F00893;
	Fri, 29 May 2026 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780063223;
	bh=o53KZSM1xwnMx9qRi9blrTJDTT9nvtmbWfg0I22/pKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=neeNnvpPJ5li6VA0xHi+YFqdkMv2Z2MOaS7H1Wgd4ceLe4M5SB91cfCT5ZZ8dDZlV
	 PKe6T3haHkhV+DXKVCfhRjx0RiQJjkgdRnG2MNfFrDkdri/AJFgSEU+FM0qR59oiAo
	 +CDHcC1rjjFIkvr716svKIRiGkFhqD7ts2Iup6pf4yA54hvqRcmfah0snxc0hJQ7FB
	 sSBT8f1Q8LOXvAoS+ftsJRLjaNhK9Y5nkxKrIK0E+/eiIg4/187gfg0UqH/50Q6JS7
	 MvkeYaQdtGqiC//rj1Hce2Aj/IOHTDZmenaNoPt6hQMEr3yF8fev/ZeUZyMbJ8F7+X
	 w6Tv3aWA/tCLA==
Date: Fri, 29 May 2026 15:00:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ahmQvfNk7S4F0LBj@lucifer>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526130509.2748441-5-kirill@shutemov.name>
X-Rspamd-Server: rspam12
X-Stat-Signature: q3sb9n4ub9qx5kmcch46quj63rkqan18
X-Rspam-User: 
X-Rspamd-Queue-Id: 487B140021
X-HE-Tag: 1780063224-229064
X-HE-Meta: U2FsdGVkX1+IdrHcuA/G64CdIuXfsp17CiYoJtYXkCqO1BgBuZ+klpnlAWVoTRnIuNamEvfisaNoEsIiIY4mmaY1rqChqKD6cVt1JpRNCRfhGHbjqGLhTgO4qHUUv59l3Pq55E/vonWvNHSPwedlsd6bQXqeDuRnneFaFuTKWz/8Mo7Fqvu4/Ed/EuqlXkRv6v5ljmw4qx3xPYsmdsvbEOH3spgABeID3N6DAdUStvqjdWlCcdqoUVzy8FW1IdMnJIVD8mO5S2MPkyqvEXjZ9qMVlPFoDreTUP7gNj0ioayW8IVAX960qz6RQaDr5CCI6ciMgd4mmS3b9EfGEKiI1uB3ke6ODnn4RjSN0p/C4acN5pEHcb+yFG8sCEtwgVjkDInoSl7L+MMPUg6gg5cfyoep8J/e5aFt2+HpcWTGAVs//jxS6LSuDwlsACExzVa+IoeWcbmcIvc8juetZWl3DicWMWzFgE93cvFwy47DwmPHEmnUjLmYFfJfv4mPVJuNmyAhDzW3ZLUyqnLy6LmHnnTblpLUrAB7kP2Rc60GtkQ20VBFEXKnI+wyXANmXDWJt8vbfIRF0h5jZeLVQe35FYhR+6WwJQiUnxWw0FesH5UXXpdaBc2C0PAjrCb1d42nrllIytXCQFa2f1041EeXApSiREWUpMy9Ct6ftdDtK8cKUG4ipUIj+5GIJXHAEuF1QLbWh+o5oFpvapL/dR0V/1JRVCTPAGi5AP295V/YPXe5hpTI4pIzEbhIHiYJ3FlunewoMAI2lWf7Bxf1SCSG4NEIc4LjavYEX5qyFU4PcL3/wB/7ROZLNudvyTGJljIdgF/KICn+Uam5/DqN262SAk2YkhTGGkKuYZmF0vDjQXneKIf8ag8u2B5nr+xvO/XFwrEOExbd/RSBXw7Zvmaxm3T+BScNc8yioOY2cljSZglhdO+jtPtOewfcDv7oEPo0txBOBEHdYMquBE0g2Gd
 4wAdwCoD
 1yRMBF3mrmtHew6rKck8wIrhqw8eHsd+RzHwDQsZrkIN2yiurKKSVHxAnMKclHYsLNO5QcUMiBIRQJs24NxKB4e/yCXYrWBh10H3K8JdCh7i3nd4rTFjVgIts2q2Nh7F7MsaI2l+dJrouzEBxn1Xkr7Lhky9QtQSsjWgwfX8gp4yswelTWuQFrYWAtPiZ0cRfZsvRhKN/wfHCOKPYv9Lb63qf8rYngeqw2vtXxUPm0/IhqbJWL2Yf58mjWOozxC4sqCf95YdApLvGup/0Lx0uU39WbefljLQLk/a7wivoBcfZ5BxX7wPRefZQkyakmO8NWzA3fvhkngidE733Sqqi/SEM07y5JumR6/t68wiRekWigwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 02:04:52PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> vma_flags_t is one unsigned long on 32-bit -- NUM_VMA_FLAG_BITS ==
> BITS_PER_LONG by design, so VM_xxx-declared bits sit in the first
> word and hit the single-long fast path. But the bit enum declares
> some bits unconditionally above BITS_PER_LONG (VMA_UFFD_MINOR_BIT
> == 41 today, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
> actually carries the bit).

Yeah ugh.

>
> Passing such a bit to mk_vma_flags() goes through __set_bit(41,
> &one_long) and writes one word past the end. The compiler folds
> the OOB store with wraparound (1UL << (41 % 32) == bit 9) into
> the first word. Bit 9 is already in __VMA_UFFD_FLAGS so the mask
> happens to come out right today, but any high-numbered bit whose

That is... helpful :) but not great that this is the situation, an
oversight, clearly! How I hate 32-bit kernels :)

> mod-BITS_PER_LONG position is otherwise unused would silently OR
> an extra bit into the mask.
>
> Add VMA_NO_BIT and have DECLARE_VMA_BIT() resolve any bitnum out
> of range to it. vma_flags_set_flag() drops negative bit values.
> The ternary collapses at compile time, the runtime check folds
> away when the bit is in range, and the common path is unchanged.

Hmm are you sure it does?

A key design goal was that mk_vma_flags() generates compile-time constants
the same as if the bitmap were constructed independently.

This surely must generate code? Or at least runs a significant risk of it?

Setting a precedent here would probably lead to VMA_NO_BIT being used more
and therefore generating code in more places I think.

And I'm not sure I really want to bend over backwards here to work around
issues with 32-bit kernels when in the long run the intent is that we move
to making these values 64-bit anyway.

Perhaps it's even wise possibly to just make these values 64-bit already,
ahead of time?

(I did look at this in terms of wanting something like a VMA_NO_BIT so we
could get VM_NONE-like behaviour but nothing I tried failed to generate
code.)

A simple solution that doesn't require change to the core is to just uglify
userfaultfd_k.h a bit with:

#ifdef HAVE_ARCH_USERFAULTFD_MINOR
#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
				      VMA_UFFD_MINOR_BIT)
#else
#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT)
#endif

But of course that becomes much more horrible with your changes...

Another alternative, which I used for VMA_DROPPABLE is to add something
like this in mm.h:

#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
#define VM_UFFD_MINOR	INIT_VM_FLAG(UFFD_MINOR)
+define VMA_UFFD_MINOR	mk_vma_flags(VMA_UFFD_MINOR_BIT)
#else
#define VM_UFFD_MINOR	VM_NONE
+define VMA_UFFD_MINOR	EMPTY_VMA_FLAGS
#endif

Then we can do:

#define __VMA_UFFD_FLAGS append_vma_flags(VMA_MINOR, VMA_UFFD_MISSING_BIT, \
					  VMA_UFFD_WP_BIT)

With you changes in 08/18 on top it'd get hairier, but we could make our
life easier by implementing something like:

static __always_inline vma_flags_t __mk_vma_flags_from_masks(size_t count,
	const vma_flags_t *masks)
{
	vma_flags_t flags = EMPTY_VMA_FLAGS;
	int i;

	for (i = 0; i < count; i++)
		mask = vma_flags_set_mask(&flags, masks[i]);

	return flags;
}

#define mk_vma_flags_from_masks(...) __mk_vma_flags_from_masks(, \
		COUNT_ARGS(__VA_ARGS__), (const vma_flags_t []){__VA_ARGS__})

(untested code - you would need to ensure it generated equivalent
constants as VM_xxx would now :)

Then you could get VMA_UFFD_RWP with:

#ifdef CONFIG_USERFAULTFD_RWP
#define VMA_UFFD_RWP	mk_vma_flags(VMA_UFFD_RWP_BIT)
#else
#define VMA_UFFD_RWP	EMPTY_VMA_FLAGS
#endif

And then:


/* Always available if CONFIG_USERFAULTFD set. */
#define __VMA_UFFD_DEFAULT_FLAGS \
		mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT)

#define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(__VMA_UFFD_DEFAULT_FLAGS \
		VMA_MINOR, VMA_RWP)

Which is kind ok-ish right? I mean it's all a bit fugly obviously.

>
> Bits declared in the enum are now safe to pass to mk_vma_flags()
> regardless of arch.

I mean another issue here is we're then codifying behaviour that's legacy
ahead of time. I really want to avoid that.

>
> Fixes: 9ea35a25d51b ("mm: introduce VMA flags bitmap type")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  include/linux/mm.h | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0f2612a70fb1..71b11945e4fc 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -286,8 +286,17 @@ extern unsigned int kobjsize(const void *objp);
>   */
>  typedef int __bitwise vma_flag_t;
>
> -#define DECLARE_VMA_BIT(name, bitnum) \
> -	VMA_ ## name ## _BIT = ((__force vma_flag_t)bitnum)
> +/*
> + * VMA_NO_BIT means "no bit"; mk_vma_flags() skips it. DECLARE_VMA_BIT()
> + * below uses it for any bit number that doesn't fit in the bitmap, so
> + * callers don't need to track which bits are valid on the current build.
> + */
> +#define VMA_NO_BIT	((__force vma_flag_t)-1)
> +
> +#define DECLARE_VMA_BIT(name, bitnum)					\
> +	VMA_ ## name ## _BIT = (((bitnum) < NUM_VMA_FLAG_BITS) ?	\
> +				((__force vma_flag_t)(bitnum)) :	\
> +				VMA_NO_BIT)
>  #define DECLARE_VMA_BIT_ALIAS(name, aliased) \
>  	VMA_ ## name ## _BIT = (VMA_ ## aliased ## _BIT)
>  enum {
> @@ -1081,6 +1090,8 @@ static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
>  {
>  	unsigned long *bitmap = flags->__vma_flags;
>
> +	if ((__force int)bit < 0)
> +		return;
>  	__set_bit((__force int)bit, bitmap);
>  }
>
> --
> 2.54.0
>

Either way, I think we should break out any fix like this from the series.

Andrew is I think also not a fan of fixes patches in the middle of series
anyway :P

Cheers, Lorenzo

