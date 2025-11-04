Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF38ECCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 04:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3128E00E6; Mon,  3 Nov 2025 23:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62888E00DC; Mon,  3 Nov 2025 23:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52498E00E6; Mon,  3 Nov 2025 23:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADC618E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 23:19:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D87D1603BA
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:19:51 +0000 (UTC)
X-FDA: 84071621382.04.7FAFEE9
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 82B4210000A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:19:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jl+kcMbN;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762229989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHJdjMEE/xapcpdDdK8KASqwyVZ/30uRlTXAFHL0inQ=;
	b=tK4vq/Iz3yIW3fk7X+YTzUxnNlW7KlUYehyqF4HjHxpdnTbwJ0yG5dFd0ZaKqNfmLZ9S1I
	fXXxsEYcDN+i+TFe0L/7el6+hgzROnVKzvzEVO7ukHt4fLtvdLECKhXCEXYq4EjxO8m7G+
	SeUgS6G5Y/8cqGB6Ug8edcFSwhcgz9s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jl+kcMbN;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762229989; a=rsa-sha256;
	cv=none;
	b=lsDXpFWc3FCjI6yZNtsOnK0wVumsz8+qh3zLRRCevB6mHTwyUtprgaWzR1C48FRKc+ZRgd
	MoSQ23LSIU3n7cUu69boWi/Yk/orvSFYsyFgEdPmRc3Bdbj9IVUV3CnwRqs12YPG/jh78i
	BvdOS71egUpbSvqKcSFHb0cdEUWppVk=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-891208f6185so482582185a.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 20:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762229988; x=1762834788; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHJdjMEE/xapcpdDdK8KASqwyVZ/30uRlTXAFHL0inQ=;
        b=Jl+kcMbNeK9UgM76vI3mGkE3CUFNxkIoaBsb9Dqxy5HWsUNsI/UoVcGuZKrg0FhExW
         S1UotYQz8iW9+1jbyuavwHIn3ABB8mpIvg6txxyE1OuQH3TBg/B6xmEJobZf+KoTnesj
         bm3KJM0WQ9c6dHYROxb6KmGuk+ssbE0L7T9Warlcx+zu9R4WLi1pnjyZUA4y+gaFzNc6
         zh1/3ctOg5fnMaQ38zwuJWsm6iowzknaSCTFX0MBf3MlUNGM6S1O8o33vgx/WdnvFYy8
         0JtAkQfith/2IfktJ0xaavMvgrKwGlX6XJccBqdIni1nSGH0bgonTdAjEFF2kDNIYfJ4
         a7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762229988; x=1762834788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHJdjMEE/xapcpdDdK8KASqwyVZ/30uRlTXAFHL0inQ=;
        b=YuGJ21gRTTO3+tFHEohSezg0iGyEgZ9EBnUgO3nx+MRP/Do9MpNg6XEhPJ1blzHmxI
         U5PFjdVLE6fFpp0zTQid/HPWNbtiqySjuOgj4xCYLEBbWQlD7vLGZ+whRz8nCpNH164E
         8wMJvMfCSt1yT9T1fAN8/9QmfaIQG3S+/WQdNW+vT5kYOHdG7tThq1gqIIjP2UsG/FlI
         Sg3i9WvJW7qtaarOhy3YDg8y+S5LamRuBJ4LXYJyekISN0sD2+tZgpO7U0AY9Rjgoe8/
         PE8J024MOTqYUj88G6Mpn2pDwgElvdgIfkivlWe+Uh7S3QWebzxjzcV7+CQOBtILdEYu
         MgLA==
X-Gm-Message-State: AOJu0YxQk7VMiGirbsiq0L7zzUrA5NTHKoABhS1ftbf1OeQ64L3bxLK0
	U7L0FWLpG8S8PSy6WrhtjSCsfRiJWalmInaA1t3Vh38OTeqNTYolmomFZ43Aa+vIL8Agq0P6Z7o
	lqx6S+cv6O3AyA9JnD6UtVYCtjZiaODpy/BwB
X-Gm-Gg: ASbGncsKuyx2kQU+XfUErTzgtw9jJJlt8hwSYPKmSgnzFo0fZwqK9+FGtVGj03LQ3Oi
	+0ASmIw0YELm3airgCyvX/zkqFK5G7du4DxyxwZxsPOG3uEHInCCEGwc9CkhbDKGNJ+bzW5hlt5
	7XYrNNWU50pDBARLPc6MjFVNSfLY0RkPhHkxQHPLQfMBbP6ZugqU9EjzxlMq3iZyE1lV53RXGzV
	3B6J3DhF73qK2Q5K3KKTteYCrM3uxUzr5HDFCiH7BtWVngJJklRVJ4clieM9xSS+HBWGNGT5SE1
	FfdWaks5iOSTo8YgnEH5pKBEe1Y=
X-Google-Smtp-Source: AGHT+IH+5RRmTLyNpLIP6XrC7qEFKTxDYBgtFCpqxbfJLWWu5/DWtPIwC9vO7peSq0UZx7LZCNaKunPtQOQRW95H5sI=
X-Received: by 2002:a05:620a:7103:b0:866:73f7:25a2 with SMTP id
 af79cd13be357-8ab9b598b23mr1762087485a.64.1762229988351; Mon, 03 Nov 2025
 20:19:48 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com> <20251029-swap-table-p2-v1-4-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-4-3d43f3b6ec32@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 4 Nov 2025 12:19:37 +0800
X-Gm-Features: AWmQ_bmTFRrhwXCcOBLUnvIw4tjUmphj21GmvzG37YUU2k9yPanr3-g3-dGf8iw
Message-ID: <CAGsJ_4xOd0CJLZvzvZu9mRLjVvV0OSKE8NcBAYe3wvHFtLjWyA@mail.gmail.com>
Subject: Re: [PATCH 04/19] mm, swap: always try to free swap cache for
 SWP_SYNCHRONOUS_IO devices
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82B4210000A
X-Stat-Signature: atq93kdj3be4yqaaaxofpjdteuj7e4p8
X-Rspam-User: 
X-HE-Tag: 1762229989-689886
X-HE-Meta: U2FsdGVkX19DjNSQme+IhYEElkPiS+BuEQjSZsHJQj1/kIhL51g417/pqPwsl2Hf2kOCg0ujXJOxfDOng0tfe+9l6QHkMC+72+mgrpzQ77wlwpiLmEtnD2iJTi+fTV3oU70+n7dgQYftPRli8HgcgSa2IqXzE4w3Pbtmf8gRfCk1MIvyNDtLXpfFhsSd++SfTeBcb79MO4OlWBK7wMCoFjk099aJ37DXG9i12TwItXidwkH57JUC1JOO7thiA0zhwkjPzW122GHjxhW2MBlxfByXrOVr/5lswHHE7iPAw9fmjqYTFxvDYxDieuZ0hJBe2e/Ad6UyeH1kcCFC72EX2PXCz3/lVXy3aea5AFQYzpKDlcoRB3DMBJ/1zpwrflZRWtuGq9fp+zcrLeasxOddFCGYmordn3MLTnqn1/B6bfNgCwmg+BCTHjyeg7qohLs5CZ2S0XK+ExRI8fIfwl8uSVmmvMgbVX7Mrbyk5ds8nCvRgxovg/imtMNPZL/1bZu0955fCjXdsugyvdFKCcMHaWRqd7L8oWtXeIaXDV6nOeLnTEoCOZCDXkMR/9y2+GEGr9dPXEDx4DyWL7cmXVrl1DU9Xl7p07KwNvMW3Q0Urufx75WC+jZZrKEEZNq7oaE9z1YVBMOYHE+7VzNzqN+NvZjvfC5EZZu77ISAtj/KX8P/66WkkKqfVl2jtoF44dC7vE9PcdPFHt1ANMMjuXOZ1AUer8RwxsIlw944k+Xlhag5NlE6UP1YAoFGj3qOVIxwVopL9nN1eX2sMj20FJkV0Eilwn2DwUa+roVSuElGHSLnPVc/os2d7qDbr9wSq6r3bQ63lycQuDdERo1G+ljR/T0aXJBQ3p3J14WiTJ+TE+/OZSmEXaLQVFq/X/R6MKkGXxKYvm+aRNFHk1oTFyQ6pPAVp8rJgkfWqcVRTIkyn8YNebWDbKnODRREiR6Ft27wgTuRuTT0whhZTCRLeno
 C6nSwwSD
 CLC82hf+Grts6A2DWNJQhiZCFqqRz82q4OPRftqDem1fMLEFVBx4XDh+JRoXDdE0b3+Rz6RWJHbQ/+6xW01vIJgZ6KeU/heGldfqSIpDQ/bm6zd5z0HzfPSblHGb9hg1hUHJ8GvcWuzuvrVFWmgCl8HLFArDIjWG38W/+JpzWoJslqWWnpT51WL7F1ahd4yIzW8I4am0MXvh2eG9LDqoxE5MXMkZI5ploI++ne/+aWZ/HVzBE7/ioCvfYHpVRMHFR3IrSD85ZCm6EM6wdF6Yd/H6lFEZtCiUXnYHgjCX8JA83Y62VGXVbAXxxrtCeno7Ya042dl9UBEClxiBtV2B07kMqrg+SVk04VfAEm0GB6BkBewBId6cNxN0Tm2K8fUzxDMO3L6Xd8OFzXiUYDSkg4JwfzRO65OzDkwRLokTMxrO3aYGd30rPe4pFvpyvyqnEmImonbP3Zpff/aI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now SWP_SYNCHRONOUS_IO devices are also using swap cache. One side
> effect is that a folio may stay in swap cache for a longer time due to
> lazy freeing (vm_swap_full()). This can help save some CPU / IO if folios
> are being swapped out very frequently right after swapin, hence improving
> the performance. But the long pinning of swap slots also increases the
> fragmentation rate of the swap device significantly, and currently,
> all in-tree SWP_SYNCHRONOUS_IO devices are RAM disks, so it also
> causes the backing memory to be pinned, increasing the memory pressure.
>
> So drop the swap cache immediately for SWP_SYNCHRONOUS_IO devices
> after swapin finishes. Swap cache has served its role as a
> synchronization layer to prevent any parallel swapin from wasting
> CPU or memory allocation, and the redundant IO is not a major concern
> for SWP_SYNCHRONOUS_IO devices.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9a43d4811781..78457347ae60 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4359,12 +4359,21 @@ static vm_fault_t remove_device_exclusive_entry(s=
truct vm_fault *vmf)
>         return 0;
>  }
>
> -static inline bool should_try_to_free_swap(struct folio *folio,
> +static inline bool should_try_to_free_swap(struct swap_info_struct *si,
> +                                          struct folio *folio,
>                                            struct vm_area_struct *vma,
>                                            unsigned int fault_flags)
>  {
>         if (!folio_test_swapcache(folio))
>                 return false;
> +       /*
> +        * Try to free swap cache for SWP_SYNCHRONOUS_IO devices.
> +        * Redundant IO is unlikely to be an issue for them, but a
> +        * slot being pinned by swap cache may cause more fragmentation
> +        * and delayed freeing of swap metadata.
> +        */

I don=E2=80=99t like the claim about =E2=80=9Credundant I/O=E2=80=9D =E2=80=
=94 it sounds misleading. Those
I/Os are not redundant; they are simply saved by swapcache, which prevents
some swap-out I/O when a recently swap-in folio is swapped out again.

So, could we make it a bit more specific in both the comment and the commit
message?

Thanks
Barry

