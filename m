Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C39CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D818E0011; Tue, 11 Nov 2025 14:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED888E0008; Tue, 11 Nov 2025 14:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCC18E0011; Tue, 11 Nov 2025 14:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5EB08E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:48:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F6C41A01BF
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:48:23 +0000 (UTC)
X-FDA: 84099362886.21.6F16177
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C8ECA000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:48:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ky4HQqn/";
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762890501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbE0DBTQIFEdPxSSdzhQNw1lCZYmDmkNb+ii//A3mIs=;
	b=urZLc7JseX18Awt+P+/ABDxF39yL6o29mKyn4lQBYrSgvrSnqlGIRvP8f6rfHIUbZ3vLDX
	HQWmftqyB0BC8/9AUJx2CFx8dMHj4ZbJSyFSuGyTIGp8mC/HjK1TqRWDsQ1xaECmTifArX
	v5AyhpjnNCzuhUTJFM/IoYA0+172n1I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ky4HQqn/";
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762890501; a=rsa-sha256;
	cv=none;
	b=vBZZGZ6m1KjJn5gIbSBJCI/TKlZ0u4PUmZd/DwCQzia8YAvlWjJp+TXjRPCEhORYcSZeX4
	+RhTLRm0fqW9r8lfgrTCrl7rxfSBqw4hyoOVFpvitp3LywcZb/GNt1gPlT2TiiRjkCfGqM
	+uV884KJtfnVtWCKAq6QtFELcq4fgwE=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4774f41628bso91175e9.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762890500; x=1763495300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbE0DBTQIFEdPxSSdzhQNw1lCZYmDmkNb+ii//A3mIs=;
        b=ky4HQqn/pNcWmdCN55JxrLwYB55Rh21wF21g2QRJWfyxgH3SZzd1fJjTdMEt/RaVcQ
         6lmZ7ChXENJtRuv/icvtbhh6WvabONH+QVuaTeG/hz2OKc16kHiIfE26iXhHxrt/v6Zt
         AWkH3xysHLOIyQQpwqY3qavy1iqsrQCZu95SMV6iQHT7W98Z9yy1XuXK5TH9XsPB7Xzb
         p2wRpRtCDa6YUewiWjSXxFYeUG2jez+8osom8GosgjymXXhTiTSPsiMbTtRHU7FxUOnw
         OgvfwXkKBlqAnme+phBKAFWn1yLbaC9f6D7RfBf/9X1rJhR077li1sKX5v7jqADpeAOn
         jixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762890500; x=1763495300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UbE0DBTQIFEdPxSSdzhQNw1lCZYmDmkNb+ii//A3mIs=;
        b=kPKJHvzRvi4C0zrJW1vrvzph6dnGamahoTOBlNGNulZ7bT0iIV2QlF6tPpmbtkk/IN
         wRud+TiKtMBcN9TJnTtuH/AwSmmN7iSczbaHj5WjnAPn/b4Dqen+bipmZq++SGI9Muad
         oMnbbkCH+Xo9PJ38Z66sPjOD/ubskhBbJgHRAiOnYpCdttgrlXJkPRqs45y/1zQTzItt
         VsZWY7+rAaVkOJ4LdkVNAanCx4Z9z5HWblQjOmSky5G/lLu52Q21Ju9b4ef6RHoXwt8a
         N51leUK5TRPPmDJaq5YZUXXL8nxtZ+1RSTltEkf97nPaPiI0dtPe54Hnhs3itTRbBAVz
         tRvQ==
X-Gm-Message-State: AOJu0YyzeYMHd/82l6xYhmk5lfwCFEDOzbMmPPfvptFGURXK+XIV5hXY
	SqvXmMznZP7qqGfSTmr+RVZvBzHw14tJM+OOlV0KpV/GK3DZPoLNBNn8qhtwpwCrzyiSOtiG7jj
	FG4w6URB2iMDmwLCM39eluJrdjTXaTJ0=
X-Gm-Gg: ASbGncvSEKXNTXw76sBk5m134ya4QQPe6BFzSaxbitIU4mY+/7lIIcUxXBKW13kPiTF
	zvYOeTsDEPLG8gMeHL2rLoZ/L/hHS/e2Jnr4yJGtce7vbtE9Pt3QW9Vc/YfQQQfn7jIyhXjJKnc
	iFfd+5MlUwlPaXZa1bRFXJDn2Kg+WmetJeRTZmUnoVsVMR6mUxswZgJEosysM5C1eQURcVBMYuz
	liLnNFSUQNQVFGNq1a6zySrWiG+ZKt//hhT5RoKXXXYBF+oH7QoDoOEiqeG
X-Google-Smtp-Source: AGHT+IFXK4RlJhG5N0ePOzGo2aczS5G6iw+lxf53O9oDZtZdPYxRASWBOWz3i7tmyMb7gaU0omWaNjuw8uXf/sXa9jw=
X-Received: by 2002:a05:600c:2942:b0:475:de06:dbaf with SMTP id
 5b1f17b1804b1-4778144eaf9mr29391645e9.17.1762890499699; Tue, 11 Nov 2025
 11:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com>
In-Reply-To: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Nov 2025 11:48:08 -0800
X-Gm-Features: AWmQ_bkqvQTvzr2wIJqIY0mYNqX5zE1OAJvC7EppmNrvuhY6ZoKspaTSdmcDjb4
Message-ID: <CAKEwX=OuhWBZWAKs0JYG6mLqe=NvyiD9L0dOEb=5ZJB-jfFi1Q@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: fix potential UAF issue for VMA readahead
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Huang Ying <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C8ECA000B
X-Stat-Signature: qjxck7w7wpaawkxsx3kxsoyh5xbq9aze
X-Rspam-User: 
X-HE-Tag: 1762890501-609187
X-HE-Meta: U2FsdGVkX19nCLknkvcyL6IeLAo7xsDsf9t+XszqVp6A4gYwEVROzUuUEAeKX9nWrvaejxJLQV4Zbs0/5qZMqrWRi2/IsxLg9K73Dhp5bwU8sX6ipn3aFhdVn2pJ5N6XBBJPzoHFno5IxVoYudnqcqOG1gA3mguyENMCcujlkhg2ttGE7Djtga6OSB7tXxX2YNBjcGfQczXIqlo7nACdWKbgZ6fNmS+ZbDJ9Z/eNh+Qj3HOz4QpVK9OQNcfbKoXxSempFWKD0iwBQpb7tGAIySblp4PHXaACm/cFn9MY5fwgmzvBhKtNJfJDV30fnHPISMVS5jdfy2lp+/3vKI3ZpavbGLL0bBTHzEKlzuRXWBvnUzwcPB36dqLQAN/0brEfntE3HtN48ThQi2qAR/WlAwSDxX3PtGRX1n3ymDfkVUb3gJSO9U3Go/EPP2FjoOAsftWnB/qcWMU43Gx48Pru4G6PuaoJXO+q13c7jJMKv35G71EfOaYyFyQsC+LcJ/PqBB1h/UtncQllroQej8HH+RkbprOAVYe2t7UxZqdaRYIjWS3YvYhMDNEifLVLlO2Fo0gCMHANpOhnp1AUq/KDNMU+fejoMXJjMbEUf1AXgSVSbGMf8viXhDEW+Y1Xi/Pzi+BmERZdf9lQIGp8Lxtqliav+1rtWJz3FTzvcjXJzpjoF+jBggN35QDPZs9tibef+xLeO66z1qD18muaTPVvv0n9VCuJtbK9485wu4l5gFynXBFx/z6gpDhzjAhgTrKowqvnwp0l43Ij723js2n0kqACW2xKUUxppsB7qgO6B9a9gSH1AWdE6QbTrXWOFk3D60fyxryGzWw5tEA1SMhBVO4IxwWYkb0YGWK8GzXY1wmt7nNsne2u+sXvYLVW01nnfYvV57B8+P/h7Q0bnU53lTpXdsmOjWgE7HqbLkZpsCuYh40QeVheByNpNGcBQwtqQFqYMZHRxI2X3QLsJZw
 JlXRG0Ja
 Q+yblGQNWH7+bYVI55Al24nmmxPjSKf6QLXKIEdKWgT0krdp+epX38bP8IWTJaeqHvIg1HAyfX+j8nC1f1hlMTC+6+y+XSlkyKR8tfHwpafGC/j8R0pFnntuZjkmrHAedzbZXlvjENmACEbs8CJctSqJHC+ln7TjjjEdd9sp2uRL4inCuvU9uio/WnXbkucsVWKGxOA8OwXk1htPQOeJnUDRwnshOlPwMx+JvH7CaDxRey4pXqpOeKtJ9tWvkd7gF+KhlrpcXfhXONFg0enLj/5Z6TNJYz0qH6JW43ymvu2bNQIlElkFENnG+/ECKjRgwgeRq4pbzCTl83kaGYXKJZ6Iv8VQq3exdeYFhBRWfqm9S1yBrzm+X4Xk4jQyeGSOHkYGGDLLVY79709AYpNzfn7HhvDTA5VTRTvS7C7ukwNiO0XlCsfleAdq1mDJ+7tdTvz5y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 5:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
> pinning"), the common helper for allocating and preparing a folio in the
> swap cache layer no longer tries to get a swap device reference
> internally, because all callers of __read_swap_cache_async are already
> holding a swap entry reference. The repeated swap device pinning isn't
> needed on the same swap device.
>
> Caller of VMA readahead is also holding a reference to the target
> entry's swap device, but VMA readahead walks the page table, so it might
> encounter swap entries from other devices, and call
> __read_swap_cache_async on another device without holding a reference to
> it.
>
> So it is possible to cause a UAF when swapoff of device A raced with
> swapin on device B, and VMA readahead tries to read swap entries from
> device A. It's not easy to trigger, but in theory, it could cause real
> issues.
>
> Make VMA readahead try to get the device reference first if the swap
> device is a different one from the target entry.
>
> Cc: stable@vger.kernel.org
> Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Sending as a new patch instead of V2 because the approach is very
> different.
>
> Previous patch:
> https://lore.kernel.org/linux-mm/20251110-revert-78524b05f1a3-v1-1-88313f=
2b9b20@tencent.com/
> ---
>  mm/swap_state.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 0cf9853a9232..da0481e163a4 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -745,6 +745,7 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>
>         blk_start_plug(&plug);
>         for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> +               struct swap_info_struct *si =3D NULL;
>                 softleaf_t entry;
>
>                 if (!pte++) {
> @@ -759,8 +760,19 @@ static struct folio *swap_vma_readahead(swp_entry_t =
targ_entry, gfp_t gfp_mask,
>                         continue;
>                 pte_unmap(pte);
>                 pte =3D NULL;
> +               /*
> +                * Readahead entry may come from a device that we are not
> +                * holding a reference to, try to grab a reference, or sk=
ip.
> +                */
> +               if (swp_type(entry) !=3D swp_type(targ_entry)) {
> +                       si =3D get_swap_device(entry);
> +                       if (!si)
> +                               continue;
> +               }
>                 folio =3D __read_swap_cache_async(entry, gfp_mask, mpol, =
ilx,
>                                                 &page_allocated, false);
> +               if (si)
> +                       put_swap_device(si);

Shouldn't we reset si to NULL here?

Otherwise, suppose we're swapping in a readahead window. One of the
swap entries in the window is on a different swapfile from the target
entry. We look up and get a reference to that different swapfile,
setting it to si.

We do the swapping in work, then we release the recently acquired reference=
.

In the next iteration in the for loop, we will still see si !=3D NULL,
and we put_swap_device() it again, i.e double releasing reference to
that swap device.

Or am I missing something?

>                 if (!folio)
>                         continue;
>                 if (page_allocated) {
>

