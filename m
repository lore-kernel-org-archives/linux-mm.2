Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11DB4CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F16D6B008C; Wed, 10 Jun 2026 23:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A21F6B0092; Wed, 10 Jun 2026 23:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490C76B0093; Wed, 10 Jun 2026 23:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 392196B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:17:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFCFB164BE3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:17:39 +0000 (UTC)
X-FDA: 84866171838.06.B8115F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 040861C0002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:17:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ociBo8my;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781147858;
	b=io/gJQ7AJ2o0s7Puwyac//wJJuu1HlIyV+Iueq05UzgkQ9/dj/A3VlTLMrvQdxNhRQiDcp
	duBrLFS8nr+cAa6TManuqh+LdEof2nWDJuxV7vK7iPJttElF1VpJCDJpmqvDSz5E2ZVUwF
	W2UklpYO5jji2BI59zX/ifcnFhDzBZA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ociBo8my;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLooqN0yndNNSOMAEv1OhI/neTi7ZUfo9M9dFDLWUXk=;
	b=3WrKzPIAkoa7G9bE1cOCn1TX/ccgZDMvU+A3xCsi0boUDkZ47jamwO/FoKy3xYqS3UfxtB
	BD6+xOHQFDtYOXtE2tP4bkorYrPBoLKuyRf7wVVgJdEpp82T4BKg+SUaMAwrNdt7zQ5ycr
	ghVy2vojs0CyixawuOGEywo81031RH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 365AA6020C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23491F0089C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781147856;
	bh=FLooqN0yndNNSOMAEv1OhI/neTi7ZUfo9M9dFDLWUXk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ociBo8myi7nMA486WCJzTn9Ba+l0h3FmAOM+NUMm7gfUh7e6tTolanB0q1Ny0TeFX
	 Lo5t5AeDsneWeLLNICX9fdslBly5TkGNtLDKKI2y9x7aS9QaGcaDkXCzJunaRyDesO
	 wMRnNTwlX9xWklDReE7Qn8q3rFTkhUdKoBEKJke7VjWb5+PyU5dA8bMpaUsDr8DD7e
	 jHZ/6nnxvVWE5KFaOjNe61/BzaG1xkMnEOoJ5Gz7VL+R6+KX1UPSjv8amr73M4S73l
	 GpDzNwZCKSkzKvvFn09eZEjUieAb+C8aVXm8spcE/EoYQZEJEdJZ/zrAyOAI3T42cv
	 2EH3S7cPGM5MA==
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6606d5900dbso2895450d50.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:17:36 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyn/VpLH/NrHQwLPnkyQe+X5/lZRIdYagBrepLZFhMEopKdRokN
	kPJRmgboO42A80PdHa5T/mkk4hUSkU0vVlWamPBO/gDSLXl/vHln3CdlezCU6y5DHldV5T8IZoE
	OAVq7B7pbloQlUFAOp7eJTvXtfm6b4nrWZdKHN8fpwA==
X-Received: by 2002:a05:690e:1555:20b0:660:5a88:6445 with SMTP id
 956f58d0204a3-66269a1c8d5mr623151d50.63.1781147856233; Wed, 10 Jun 2026
 20:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781000840.git.ritesh.list@gmail.com> <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com>
In-Reply-To: <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Jun 2026 20:17:24 -0700
X-Gmail-Original-Message-ID: <CACePvbXDW-euoxVta8SL8gWG1L9WRVdid0PeenQsMzuBZbLb1w@mail.gmail.com>
X-Gm-Features: AVVi8CeRjfh7lIAOBd_MgIZBBjqz3E5dbnm1fw9CUyM3Tu5c7QEaUgnKV4cNBlY
Message-ID: <CACePvbXDW-euoxVta8SL8gWG1L9WRVdid0PeenQsMzuBZbLb1w@mail.gmail.com>
Subject: Re: [RFC 1/4] include/linux/swap.h: Remove unused leftovers
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 040861C0002
X-Stat-Signature: zrn76keyqyjp7asbgknmtxnyytem64yc
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781147857-874466
X-HE-Meta: U2FsdGVkX18RB1GyPX3R6NZ0sxs6WoOWNSC10I3FJ6Y9BOZih+MLV+Lxhzh5wjvJtG0vdCJJNokmZisVU4AOfuE159BRogZIFMWwNSOxhTIxCcG/8wsgDSiiOV+RekvvMIV17TSl7UO8GnZACtaL1B43VjZ+wY55V+wwEQ1QzM401m5nrWizKQ9RVEh1MLwjJwblZciK0Kbt1w6oCx6o+RKzDs49xp36+9k+U7svMVR3NnAjRdPWOM5Q9inmscEDl+0EFVwQBuOrQlPU1pvaEM2mvAyRItRF4Jkk4LHAEp/5MAWbRkqH8P4ZjE9VqwxNqkpsqr78h9JxJDcbzCmleMmpPBuSp8qIbinwFTDG0/lyj4ASuoribBVPcYhSlWP1AHRSEKOFMXqvqVvgU0/WOM4AXcmIbtPJAHjVkRgs9NhKYJDqAsVe3KLaE6OxrTSs7uL73FXhY1J8gWwpFjNkklRDInQKAM0B0COf/d35VZzEZSjikYEbAD3axtLyA9GcNqj4O6J4WvOP1607mNgHPaRXLZJUTYUpWaC4zUKUd03DxeNy8xYnGFWnE90Dd3jMLHGZFxla3s+8kxm7NL3NUo96xnpOVcsmNoTuKMQA5Se+XrSVY+mUUsyF9mQ9cjKrCK2cIUFOzdNB0cuG/ZC0DXZIP5b0DYyoMWhA/1/Eu2ov0ZBu2yBaYiHxktQLZwrU2ioXvFvQzq9nYsbmIONHJIdteJkv2B5+rmlhy2X+h8p6Kv0o69qlNm9yOVXGVH9taZPD0VXgMFUpp6xIWqiyqd5yPeYvMzzFhgdXf21hoaaMz/iXc8vswKkZiZNp9g1z7FVtkJm6mCKtkweKJpAikmEtIckLJxyjiUz1KQjnuk80RDPlw960mhkP7Od256e4ObXvtiIhCZ64z7/g+uTPMeBdKP5V95b8loIki7dtfalQjWNijeyZ9IwnkFnHCgJai1XxoX3HYGSibnEvS6s
 /oS/7u5Z
 ySM0NeK8nEuZJnLb466zsE02ICbFkwE7TlRV+rQ8nbtyVGu5E8IiIsutX/CQiPW8axGJdH1CU3nGmw6ZMhR8HV80m8HsmNZ4OIG1juhCbv7+Dgl9YdsV8FUnyRrop3HAxuNXBX+Onlvso8q4imDjgETLBOBjhyt5qJ128FVQB6S1MZACPs4dxg93nCQpHDAP7yspDhH6oSg+P8s12ZvaizGd1Y3iCoo0lKHefLJnZMVSQvIjxBzrEi2+seDSejqENJVhyqVYsA8+ZNlgQ9d7C+8xknFxnu2Egj26Q+2bDDoz9T5/uQJ21sA417Gv8AOcnG3ZW7PU8OgzVGbMUWVXqodzZzwTnyLsjRVi/j5qQc+TpoQYBVGidDNfJ8kywT7Z+Xru4m3pq0seedmh0oOxhEcJf0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 6:20=E2=80=AFAM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> This removed unused leftovers most of them are forward structure
> declarations. Also removes SWAP_BATCH macro which isn't used any
> where in the code.
>
> Found these during manual code review.

Thanks for the patch.

Obvious correct.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  include/linux/swap.h | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 8f0f68e245ba..46c25523d7b8 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -16,10 +16,6 @@
>  #include <uapi/linux/mempolicy.h>
>  #include <asm/page.h>
>
> -struct notifier_block;
> -
> -struct bio;
> -
>  #define SWAP_FLAG_PREFER       0x8000  /* set if swap priority specified=
 */
>  #define SWAP_FLAG_PRIO_MASK    0x7fff
>  #define SWAP_FLAG_DISCARD      0x10000 /* enable discard for swap */
> @@ -29,7 +25,6 @@ struct bio;
>  #define SWAP_FLAGS_VALID       (SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER |=
 \
>                                  SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ON=
CE | \
>                                  SWAP_FLAG_DISCARD_PAGES)
> -#define SWAP_BATCH 64
>
>  static inline int current_is_kswapd(void)
>  {
> @@ -175,7 +170,6 @@ static inline void mm_account_reclaimed_pages(unsigne=
d long pages)
>
>  struct address_space;
>  struct sysinfo;
> -struct writeback_control;
>  struct zone;
>
>  /*
> @@ -442,7 +436,6 @@ extern sector_t swapdev_block(int, pgoff_t);
>  extern int __swap_count(swp_entry_t entry);
>  extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t =
entry);
>  extern int swp_swapcount(swp_entry_t entry);
> -struct backing_dev_info;
>  extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
>  sector_t swap_folio_sector(struct folio *folio);
>
> --
> 2.39.5
>

