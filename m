Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DC7CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08D16B0092; Wed, 10 Jun 2026 23:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE04C6B0093; Wed, 10 Jun 2026 23:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF61F6B0095; Wed, 10 Jun 2026 23:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC9406B0092
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:18:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89107164FCD
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:18:20 +0000 (UTC)
X-FDA: 84866173560.23.7C8BEB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B25C8160002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:18:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FBgBeVv7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/x68ABRg379J30fMcenonWGwnmir0RuQ5ej/rkgPavY=;
	b=Dyv1fbJZRlBgifG++2dtuYm2SKd0ICW6vF1mbrLSTzKFhkB30VtlnSOoPvF4DOYLFf/wRt
	mcyiciob4tHczsFjAIBQFt85SbK0pFCvxC+ak+jxuHft5ibhcQLjSpT8X2sxL+cGA6z63n
	J8dc00GdDp8GrQsk2ZqCqZ6I6fHx19E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FBgBeVv7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781147898;
	b=HeRgBO7KXDSp+6a3vuOl/oPbqnLuwvsFYUW+HdinSeE9eAizvtW3n6vBNNUAelJZu2pQS5
	kqFt9LuN6y/Rtbc8LJExwVQOhnmQyg3wGFcRjfHKOGTUQkzlsbmIsZISjiW7RkUDc5IQ3M
	/HvuIPH7ceg7a7KwQGQ6a0Q1pFooBMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 494576020F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EE01F0089F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781147898;
	bh=/x68ABRg379J30fMcenonWGwnmir0RuQ5ej/rkgPavY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FBgBeVv7dBjKkNGP2yJxVgW8+TNt1tgecCDspEgeQ5f000BfZ3laEFc4Hvw4QOgLq
	 FnjuZhv1BRpYCJHz89pyrhXtSDC+T822iqjvZidyWJYWaIlhdKqiNdH+NGlzQTFb2i
	 3oTK4vXAVc+RrE15wvfNbiI97oryyLJVDLnsocpnE67KXbk6MLXe/rF1k1hAyABr/K
	 8dmTOPQ+jySwCzm1P7kO8LklHDeT+D3HKRNUefkK2iCQAC069+PvuPiH/zKdQ1PX52
	 g05+ZlS7xGnEqzp16MI3Glnc33nhKig06y/QlikGDhiasapoDbgvmtKcCrwPMZ8Pzq
	 K64TFoLmy6QKg==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-660ea43107fso7201198d50.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:18:17 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxx6dZ7T+sDPDlsg/iSeVl6FUiLdhh8yC5hRRklNxdoKXv0dnUD
	qmkQrceChFYqF5DsK33X9sW8xifhYpMOmdXHnL8GZxaTY3zAgzhvrPUWDR+9ruNr1/jr1k7Jbkn
	7sOqRzcPfw8rPbip8Nz0NuoLdas17MpVuNgwf7vZZcw==
X-Received: by 2002:a05:690e:4087:b0:660:651a:26e2 with SMTP id
 956f58d0204a3-662696264aemr832644d50.13.1781147897429; Wed, 10 Jun 2026
 20:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
In-Reply-To: <68591daf0d679e5a0072d63751f187d14613e2b0.1781146877.git.ritesh.list@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Jun 2026 20:18:06 -0700
X-Gmail-Original-Message-ID: <CACePvbV5StK2W47UsoVBM9V_XPoFfd1UMfS+QS_j3jfLvrk9vQ@mail.gmail.com>
X-Gm-Features: AVVi8CdqmWc_pAJZ1j0CGRdRempowIcbT1sudR1BZVzbc-u16prEzm_YyQdKOVY
Message-ID: <CACePvbV5StK2W47UsoVBM9V_XPoFfd1UMfS+QS_j3jfLvrk9vQ@mail.gmail.com>
Subject: Re: [PATCH v2] include/linux/swap.h: Remove unused leftovers
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xee9duwin1s6dbkzgio94aazur3rb39i
X-Rspamd-Queue-Id: B25C8160002
X-HE-Tag: 1781147898-327945
X-HE-Meta: U2FsdGVkX1/6t86D5XqRjVLw1lZ7mZR6flareCR1Iy7PDu++LgSiNKFamgcnmOpUXDPjLpxFj5HH/pDtz//ON31R+v7RMFpTHr/deu2ChpdOuQIO7x+X9VjtEo6/Cv54t161q6vf0sMlXMcrDjpy0m/jiSrkeaqOkktJ22T5rsP9KDtKyk2o352RGEcb2gX8daszaKBeN0w9JjlbRwB1+ql44SHrq2lZsi6ExlCTX23ZGd2xQkwBdfiuD2Wd8bqTrZkxoPUnCu/ebZ4yF04lXjHDxU6xQVFntzi26wJyejjiB4dkz7boWdgRkqGfuxOB1n0+9WTHWTs7ak+HZ89zOoySA4RKkRmfXF8W9jkWfdodSA3TMrklT52zK1ZEDJCAP+33nHgvI3SfKwexmTqTIEFZsX2NP4lGrmSwf6tuBjBc4NIjhqhqUh8p6ZSl0aWAO5OGXzF1OUYmwoScJ+ajcuRSeA18+91Dctjz8nGosuWewpBcFmOmY81aOQjSPhJ6rKHsPCsDvfz7An8cLie829W1R8xlvBIy6EFdLiFBxxio6/QhJDkXIErLI2kYzobjWkwKd/9NIEWjf99+Kr35cNOgq+ybGaFny2xv8dIqC51/SJvMAWQsAP5SY7MlAOgVhFKCaD4gfcCEFJxpi0vZci4n8lCl9VVkHH05ntQo3fq8bHDr7MdycG+eZLF8hxCmiC6boQEjFoWFAY/MKIxDIIh4dl2euunZgVDwIKt2DD4LOBTw0mIZswDski3HyfnXDiopAqFCWYL5Sf+GbH58S9JPkEBm2M5Y4z/WgmdJmZaRbGmgIKfm74c3Y/B+HA6MQ/Ac+M1kO8L/FAIWlIeXnSMR+gQdlw9V6rzm2sJxiQSqyv3uZBC/nIGC5oiMR/uX432rjzZy1SDBg89zmCfOSrtvKogmqfD3AIQkkhMKesEImyWImWgTnVyrfp/w4ihufdRoK7s2N+7z+qPGvkz
 vu+3gLtF
 g9vG08eS8XFMmrOptnz9wVHukp8AfYquQXj8ca5gT8CwFA9Ob2YXa3PQ0WPZJdiTqE/EB0523WgGABC/jlbrS5ejgV1YcI821eFiWklLiRVQcIMLW8pswfpP1gY1TW+5rZD/wsBSsf1kB8IMbl2rLy5HPLgyeiCf/gLuYaVRZD82ytyP0nd9y9jeHgCX+fB0LUswsW1OEXL314CSYGSLSnAidS77rgXratRTEEXvbaoTa4O4U4yQFljKqoESfbijr3i5PGAGCH/7oiiskG2MzWgnvQML4/CHbg/QLBH+0vxMTNWZV0JwCJbjTfu5ED99lcmHt0VwsLMiWqZbeT8oY6qCXDDvOgD1m2qC/gczJR76wd4O6xN0xsImgMlnUUEv+iMJgy39Uafi/+tCwpRdbS2n1nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 8:09=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> This removed unused leftovers, most of them are forward structure
> declarations. Also removes SWAP_BATCH macro which isn't used any
> where in the code.
>
> Found these during manual code review.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
> RFC -> v2:
> - separated from the rest of the series (enable thp swap on PowerPC Book3=
s64)
> - RB from Barry
> [RFC]: https://lore.kernel.org/linuxppc-dev/cover.1781000840.git.ritesh.l=
ist@gmail.com/
>
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

