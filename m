Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7997F606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJ7Vxsxc
Received: by kanga.kvack.org (Postfix)
	id 98D9D6B05BE; Mon, 26 Oct 2026 09:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964FD6B05BF; Mon, 26 Oct 2026 09:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2D06B05C0; Mon, 26 Oct 2026 09:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7806B05BE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:38:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1BC3160769
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:38:49 +0000 (UTC)
X-FDA: 85364882778.01.338FF2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4FECE1C0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:38:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJ7Vxsxc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFX7NaawqsbNS11cXFXnnBm6IAwlYAmGpbTbUui7AhU=;
	b=sXEQn1B2ij5SCDstE+EFgp8FrUHUr0q9yYBeS8+A0Ce20zzwC0pWXtvLTDRRPN9Zc+RsLm
	NFNEu/reNt0JVBlIy6adv9F25RvKOYbHCnAHgYnE40aZo/XxcC34GzKOkDqV1qiwF46Wq5
	eJALGHJG1VvvXqZtjOe7jFg+n67srk8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJ7Vxsxc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021928;
	b=NyN3gOg3POHaTcNrpAB+iGnqbex+PCQhG0TUqcuIj5GjHhx266nF+6c8tKzyw9fhP/EU8m
	be/gEvVCoKpoc+Xwb8OMpOMT4Drt0Uca4ofhT2Q7wZYHR6Rk7wCvB+dwFACLWtCX6gtW9k
	khQUwpLd7RlJPoPKZKZAe7Jj0+3QOVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 872F843FBA;
	Mon, 26 Oct 2026 13:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD92E1F01201;
	Mon, 26 Oct 2026 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793021927;
	bh=gFX7NaawqsbNS11cXFXnnBm6IAwlYAmGpbTbUui7AhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PJ7VxsxcFmyNjHFYZr2u90ra8L7rHkS9EPkgd4kX2JXInDzTgmLp4gtccMcpvcJyR
	 a4p+non0wGhtVl9w5OcsGfM+4MeNiXCjsi0x8Qx+CMwPqt4Y95G4eokv4RHozuUpST
	 /VVMkADwdpbzCmr+4688bMp6oKvKlLqtmAOCkq8MkH93eltGzKtsjrYFoM0dUi7qD8
	 HmY8Ys2GjgpYAww6wnxlbMTL7kKqCaOv0rIdz3A/bBsowZSgY1Uqn8OVVHJHO/vRYN
	 PbFXj4mWd+eVlDC9pnC0OgxhC1op0UHOMDLFa6ge/gwZcFj7IpqRF2y5d2tBL63lDP
	 vF/Y0QGrhMO8Q==
Date: Mon, 26 Oct 2026 13:38:42 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
Message-ID: <at9XoYEOWynH5skT@gremlin>
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
 <at8-42OwXk2z6-HB@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at8-42OwXk2z6-HB@gremlin>
X-Rspamd-Queue-Id: 4FECE1C0005
X-Stat-Signature: kaz9xungkw7j3urdacjnj9upepn4diak
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021928-783727
X-HE-Meta: U2FsdGVkX1+69IHoaoo7EIxfCB+/v1gVgijrVjM9piz/3FAYe46m2mfYc4bTn87RFbbhujMZwAKy9aBKLJPmW/cI9+jCtNwA155ic3UmVfTtca+k/xPsFzFpcpT/vw2VQtDe32U+/fca6vgj8smFzl2wrJwR6LQwq/PsUz/AkB6sAvsGVGB9BcdoZi9batJ6g4jRbldBjLjhhzAqmZyj/QWA27g/yg3gG9i0bmjSe1BlQGYupsOIgGx+nDFmQK1J75Yf9c9bl9XzFaP8cVqCdt2t1d8ScnCiV7DoNYbrf5gxeaJ4JJeOXklyNF0sBFadHWx2iLPUvoKFctU+TBdvlQs4+OCZb/8K+wXoZsqygtVR9KxxLD1T9xONbYF8WrRJ3xdEy5OYuPrQOeiFKew5/0blzCi/maFC0HMcNOwD587LWiBzi3m14HjQAhqVf9gEAQ0ipsc+dnFlToiuGgSUSjkGq72VjSuYu9GrWGk4scovJzmmVFQ1Cs0lFlttMfisvPrQx6/3kOZ46VRqedENSVQmdg25yRxCeA5/jUPxSYGmX6m4uF+V24EddJXieNGFSXE9PzdJQbZpj6k/akV8MOz3CU7ZGaiP7hBcw3gI1IIWKA4JcNJlh1Jl4PqE61XaD07x9WnyGdLMWYX9RNILtmIIk0EsBl+oDSgRt9+hJWA1Lbi73SBTErmi5QvlALbL90rcn+vqKjvqotH/MM9WRTWcZ0LUKkE/Vnj9BZ7IChna3/a74afBSYJJkNaC+zPygYw1588DP9T2mVWg0Ey6cQaueKiw0SFW6+BucJQt7HTzUGdh9VhXIyvwbQaB/u6X4vNbiLnuQQzHeS42gE+uDtqk8LxidE1I1uRMmi72IwL3/DFQq5wUvOMRiarTKK7zLmpt2HF3r529pFAGINkRspoPi6sVMLxBLAaM/eAdf0B3evnPKCGGFu45gJFQAbhtEQIbg1Of+/D9y7rJ60l
 Mu0v5Iap
 4Yy6OcNJk5nS7Ov4Afsai1IGtwfRPK3HhK6CEzmPfkPOLWcDu3GvagZjb5AQCMEUOa0/iQ7OjyYKLqjMMpfFgbnocyLUg7ZDlM+Ph/W49Mz9rn3YFiHV9oZO61ImsOTTcsQ1S/f+The1zG7s27eN4fhfSZ+KRS8aRQaQ/cToqBietNA5Qp+Nw+Qw/0fmOZnp6WNC36NyfMQindAxrdaHLWpkkHa0IyE26q4c98CVTmF/Yd3pd4xsMWCVnt6Q4Fw9MKGjrRXnBs873ksJkKIuc5Ej6/i4OCtYF6Tg02DRNVD2Q6UE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 01:35:23PM +0000, Lorenzo Stoakes (ARM) wrote:
> /* Returns true if mmap write unlocked. */
> static bool reset_walk_if_mmap_lock_dropped(struct vma_iterator *vmi,
> 		struct mm_struct *mm, unsigned long from_addr,
> 		unsigned int *last_seq)
> {
> 	if (vma_tree_maybe_changed(mm, *last_seq)) {
> 		/* Reset walk and re-speculate. */
> 		vma_iter_set(vmi, from_addr);
> 		return mmap_lock_speculate_try_begin(mm, last_seq);
> 	}
>
> 	return true;
> }

Actually, nicer as:

/* Returns true if mmap write unlocked. */
static bool reset_walk_if_mmap_lock_dropped(struct vma_iterator *vmi,
		struct mm_struct *mm, unsigned long from_addr,
		unsigned int *last_seq)
{
	if (!vma_tree_maybe_changed(mm, *last_seq))
		return true;

	/* Reset walk and re-speculate. */
	vma_iter_set(vmi, from_addr);
	return mmap_lock_speculate_try_begin(mm, last_seq);
}

--
Cheers, Lorenzo

