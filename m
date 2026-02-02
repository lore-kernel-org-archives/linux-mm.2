Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0710BE7DF19
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A936B00C5; Mon,  2 Feb 2026 13:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4189C6B00C8; Mon,  2 Feb 2026 13:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA296B00CB; Mon,  2 Feb 2026 13:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2576B00C5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:23:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5366D4597
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:23:00 +0000 (UTC)
X-FDA: 84400338120.16.68B3F2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 507D3180002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:22:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PxS71KXE;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770056578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ur01aK8sfRu+SWTu2hkenYEKIT1CG+FNnR70J+3IkM0=;
	b=US+EB1DROAt1hfujGIqFEMLco5wCegzbjEyYk/QPR8r+DthGI/QYyZ3F5Clokz8A+jWOCy
	7Sk+Ct/Fnn+uR+VfSovEjXYdeJx29q/2RGmYoi9hmj2oDeOZZRctEgaCWTQqtu+saRwFGg
	rB+zCZ3IG9ptegQgKrBPdr1SXWfklhA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PxS71KXE;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770056578; a=rsa-sha256;
	cv=none;
	b=BEMH4Jmb376jx6Xo/xWfDGLtteXfL5h/Z+zYW1VMUILCLLrtMLvmjlBhDdMfmzQvxq1hke
	5oWX/iRlS2AZ+Gj4yhXBrfN5Iw2dcYJVWhdWUdKSx/6PzIy7j/ZFG1yhEfH5n58NeMiv6E
	Hb2lVh67siBDs9kC6TPg0BsI4TgJoVk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FB7740D9B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E715C116C6
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770056577;
	bh=yTbKlhssYa+J+5WXq31Hb2HVv88TbxVkZ8xgo+2qC+8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PxS71KXE0XX8PS754fVKeQyfOKjd0DlyFHlzQV499NC9EF9mWn6RitGkA6KJ6Xq69
	 klgA63gHeLUh4euLHPdm9+JuBLjY3egpsqCJKVSnQ01dXgTB6BtEQcsgA5hh3I7ynQ
	 K1MTPAm8crzd26gLRnUGS4TMAzk03ubqjrp5oCN0b40cv/X+IZMr4oN+yMRnkoOeA/
	 +UuOF0uzHC0ghsRehC28VqytsmxFJalU3LIc5LcdKvfQkY5yGhTLlWIbiuhfuGQELQ
	 jqejgxUP8PuMBdnpO1HcxFiw/R5j8SgQKrPfiKu6JCOVkl1eXDaez9JemTzlqhGGBm
	 kKajcaLOjVlLw==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-790992528f6so43387007b3.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 10:22:57 -0800 (PST)
X-Gm-Message-State: AOJu0Yyt6QPyREViEmmikfJ0bmy4O5SWb07u7Vu8ExeuJk/BxmFNelu6
	GysxONQo6VBWaCaXE45KEtQgBD/RjoEs1h8hP+MqsIVxIor+A8AsiUzl54T/G6Y+qh8V6D4Rrpg
	THv4fgyPPxr/U18NVImJd34zT+ptWldXVbUlmTbB/cQ==
X-Received: by 2002:a05:690c:60c3:b0:794:70f6:a87f with SMTP id
 00721157ae682-7949dec6ec3mr105333257b3.19.1770056576448; Mon, 02 Feb 2026
 10:22:56 -0800 (PST)
MIME-Version: 1.0
References: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
In-Reply-To: <20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 2 Feb 2026 10:22:45 -0800
X-Gmail-Original-Message-ID: <CACePvbUQaAw5Upz86kV0Wc9E71UHEm6MATYPAPajy2X2O=eWew@mail.gmail.com>
X-Gm-Features: AZwV_QiSj4eo8Mfc4E0Q1W-pDir9H_xKh1YofvGSFBSixKG-idrDQtrCmrSkD-U
Message-ID: <CACePvbUQaAw5Upz86kV0Wc9E71UHEm6MATYPAPajy2X2O=eWew@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 507D3180002
X-Stat-Signature: 7emy1j9ozcdyhozur1gwkiybhcycaw7a
X-Rspam-User: 
X-HE-Tag: 1770056578-957897
X-HE-Meta: U2FsdGVkX181V+2Iu8blL2KjCK3Ugge4nB429p2t6jL0F4vDaAKVSS+tfjr+o/7aP2ixa+p3R6Cu4W4WPCvMqo/DAJdKSSfLaCHMoHpuF31kpVWLgd4q49sX+ln/upl8JCjwDjCbcAR0rV26/VBTgCF5M4yA0ErkVApEU2tve5dERuZvMYPtLTnAXu2IgvkfDfK/rH68NgjAHWJ2Yy/jYn960en8WudA9VwvOy/SGgGg5C7k116+2FrzC7SBmMLxXLwFAkNJu2EnzSsvjHZSTqhAN/wpWNhXA3XzMPUBPgyfCtfE3LV6U/yVPik4wC8O2a+Or0LFvQYj7pd01CTVuk6+xfVoN2aXTc5rJT+tNQkr5rF1uf6dSJkflCzg7o0z16g9CX1FP9U9FX+v+1GZ2W9jrVzedoNDm9a2JKXpj63mT8jvF2Y4VWGQ6XkprDZQNzZPgn4dqlCBOpxQB4UU010JvaGC+6duuYhmfNv8aslxC6NWtMoXyohJkB4usqDDkXiT23ucfhckNkgwt67W6j2YkulzXJIxo8efvyP/UAMHaZ9GUBX7z0vzsxS6EA86FC+fgYBa9gRPrbX9XHc9sieH8SJmKOKL5ev06VTUrfRZ248VAPKPtaFsfY863pAZavKpkak5TcNvgFzK9sNKPB9yDx84Azca1kBHNg9V/vdhjDxTi8sIY4MqD/4RPq2Nuos7k45G8uKAyhMXqgNCPNYU6xkS0nMOZ+z8+uP/nocijrI59kp+RAR5OLbVpCoSj9aFBlY1+upGf621ay1auHxY6MerVNZOKwomtDSp10zIClJfGxwVJsyu1aJywSS66YhRrDijC8rhzPmbfjY6TDNpSkvFTiPn5FZcO1Mdi9zqRKYX61wtzBbEEm/4mFywNI5tJPQmpI6Z2GfW4PfIAa8uwKoNaVzCeSPHJXvtfLSkz0cBWQMCB+aaGEhw7N5WBIvlfTQUeiGSFX8HgLk
 ArlHTGzX
 vsk9yJ/ZCR1OppZsVLAoZUi7b2MhfTf3HX0TX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 1, 2026 at 9:47=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap
> cache, including those from SWP_SYNCHRONOUS_IO devices like
> zram. Which means the workaround for swap cache bypassing
> introduced by commit 25cd241408a2 ("mm: zswap: fix data loss on
> SWP_SYNCHRONOUS_IO devices") is no longer needed. Remove it, but
> keep the comments that are still helpful.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

>
> Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/zswap.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3d2d59ac3f9c..8cd61603ff79 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1589,11 +1589,11 @@ int zswap_load(struct folio *folio)
>  {
>         swp_entry_t swp =3D folio->swap;
>         pgoff_t offset =3D swp_offset(swp);
> -       bool swapcache =3D folio_test_swapcache(folio);
>         struct xarray *tree =3D swap_zswap_tree(swp);
>         struct zswap_entry *entry;
>
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +       VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>
>         if (zswap_never_enabled())
>                 return -ENOENT;
> @@ -1624,22 +1624,15 @@ int zswap_load(struct folio *folio)
>                 count_objcg_events(entry->objcg, ZSWPIN, 1);
>
>         /*
> -        * When reading into the swapcache, invalidate our entry. The
> -        * swapcache can be the authoritative owner of the page and
> +        * We are reading into the swapcache, invalidate zswap entry.
> +        * The swapcache is the authoritative owner of the page and
>          * its mappings, and the pressure that results from having two
>          * in-memory copies outweighs any benefits of caching the
>          * compression work.
> -        *
> -        * (Most swapins go through the swapcache. The notable
> -        * exception is the singleton fault on SWP_SYNCHRONOUS_IO
> -        * files, which reads into a private page and may free it if
> -        * the fault fails. We remain the primary owner of the entry.)
>          */
> -       if (swapcache) {
> -               folio_mark_dirty(folio);
> -               xa_erase(tree, offset);
> -               zswap_entry_free(entry);
> -       }
> +       folio_mark_dirty(folio);
> +       xa_erase(tree, offset);
> +       zswap_entry_free(entry);
>
>         folio_unlock(folio);
>         return 0;
>
> ---
> base-commit: 2c263046cbe6d9d5fce3dfeba063f199f7e6298f
> change-id: 20251226-zswap-syncio-cleanup-a05b7fc6180f
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>

