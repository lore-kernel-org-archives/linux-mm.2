Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79147CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45308E0025; Thu, 23 Oct 2025 21:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CD28E0002; Thu, 23 Oct 2025 21:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C288E0025; Thu, 23 Oct 2025 21:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD4188E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:20:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48FEF129E71
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:20:09 +0000 (UTC)
X-FDA: 84031251738.23.E90D3F7
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 642FF20007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:20:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lXzizmCO;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761268807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvyUZmMO8VPiZdlgVO/IJ2704hYsi6LPcWtQZ//HkFI=;
	b=bH0c6IAq5/HD+w3yF8PXfMensehvE0PtIAtzv4ddLByeI3H5jvmixrHAFYxzjRSJT1x1pc
	ECWczn0nRTj544S3Cl6fmLjtUYLuw6qiCdt/usoy84K0695k0m2NdUdOs3l+nJT5J8ZQGd
	3cqQArqa1pY4w0JZHkdh1PSgoANnmRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761268807; a=rsa-sha256;
	cv=none;
	b=19NXfFFTp1bSBOsY/u+Ls/YV5oH9RTRc4kgjtbLYSIllxyYRkO0cG6oNPebu66yMSV26Oo
	hT2IF5L+QOdahjbtuGgu4Mw6rDHx+Jc45Mvsy12jPk8HZOqytqdMBpF601Eu10faHskFyL
	at/k2p+7KZZzcA9e6cEQOLyy4Awa2Q8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lXzizmCO;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4298bada5bdso1071804f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761268806; x=1761873606; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YvyUZmMO8VPiZdlgVO/IJ2704hYsi6LPcWtQZ//HkFI=;
        b=lXzizmCOUGUhQC5p21p+plTwQs/Pd4TueYpJygBeHC99IeVbQhtJRMPejHAbvwh68W
         k9sZ91Zp2khisfdRZwi/gqFjzzXQ/sgD8rn7v6bHXhqVuksJs5jfkdValF+vvDTxBa7n
         aOAY+6WcHACKLvbJGz7q4fJJfCipxMAtk79otM1bh1tLQMdVimQWGHpRM/vpXh1CBN18
         trAaVQbdzJRLv0Vonj5W8Jax/rcnvxRhzzwPTqBZpu7QrneBhWB4LK9UlZBFpWyCG9vt
         iBmVj5F2FYZQRHtWtZVKs2yihf0XoKmpCg/Bax/UD5FHDXZ+g183uv3FDt7/hbM66lbe
         jWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761268806; x=1761873606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YvyUZmMO8VPiZdlgVO/IJ2704hYsi6LPcWtQZ//HkFI=;
        b=Z/mKhNIri8auILyKERGf4nzCdQ+29j2Uyxb3vJ+EKNK4ZAxf4KSCGNUAtVg5LAjgca
         GkP6+GuL4k7J8XDy8fsxHw76wPCZZCRh6UOwK4mhTPs4LCa2QGIrWwPyK7/n/g94Katr
         ijyxm0J/x+EbIjVmGyS7bKSKfcgju5cb1mAe+CPWjlIkBfOYU7gHSRRJPiGmS1VWrB+P
         kV82L4oD9Nou8KbZTG+fRkFxoU91I7QT2jvxmjaDSmSxy0027dI6Cos9s0FLbm80MnkF
         cjrT0Nb/ocQofOsa8aOSghDgo0gGLYasGMO1nJGOY2DmC1tnvhISQIs7xKi2cTEPC8+W
         RMaA==
X-Forwarded-Encrypted: i=1; AJvYcCVLAyuM6adF7rawKfQkohsLdOL01ML4ytdAoW6cz6loEme6apm4EBBTSFRrP8wFmW+gMXkUjgq8pw==@kvack.org
X-Gm-Message-State: AOJu0Ywho3S1tfAOkxOIAyOzVfpyZE0DiQDN6v4JfVpT2L+wN6kKU7Uj
	NMn+GycAyMBcAn1w+w5nj3UxNpxKwSSSQSontM3rXNiPLMk7t+h7wXHEampvUKoqyFgX00FtSPT
	8D+8V/AVXWCHCLW6TVIIWcogkQPQueNQ=
X-Gm-Gg: ASbGncuzPlH5ylMtmGfan1WlFqknk04mV49bCLb/xA1RW1erq9+0oSdFflwBcPtqZHb
	ztLbPMRPIZpffrxg6swxTlB0+TpNP6pFQJTlTH/4kMwyxN02dgqIrtvZ/thDvBbEzKpvXgZF5q+
	tAhMxG1PNHeIkAqWhbK/Y2UrivoXNT4r5EDXpxH2H1Gn3RsUlnxezvx1wcAOvcXJrHpULAv0s6k
	/M1Q1lW+gzpmupsX6/dgbUq31IC+234k1kAOiQgYEVI41XaXMtg0NFb+CTWCE+K7egBzqfs6U19
	Qb6TPPy+prJcTMmne6Z3Q/7vWJP8pQ==
X-Google-Smtp-Source: AGHT+IFneXM0xr4BTxmFteom5iOTrMBRm3KDcNn8ea5ZwZKTXCozstAADZ8mhAUFw9RZH5CCePq+VFJYDG3ckmafY1o=
X-Received: by 2002:a5d:5d0a:0:b0:426:ff46:93b8 with SMTP id
 ffacd0b85a97d-42704d8444amr14973841f8f.8.1761268805783; Thu, 23 Oct 2025
 18:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251023131600.1103431-1-harry.yoo@oracle.com>
In-Reply-To: <20251023131600.1103431-1-harry.yoo@oracle.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 24 Oct 2025 03:19:54 +0200
X-Gm-Features: AWmQ_bn7k-8N3nBX8QuM-JrNgQDPCvNlJAZ7mTQNODGDz59t7Iwz4Fszp2T7gmY
Message-ID: <CA+fCnZfJjXez_bq-jnmPTP40tPuq9XUc3Z2MtSgU7TnPz0bWyQ@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are word-aligned
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, 
	Alexander Potapenko <glider@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Feng Tang <feng.79.tang@gmail.com>, 
	Christoph Lameter <cl@gentwo.org>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: ybgnh9d8zxfwc9qc5ujcnzptui4r8uy7
X-Rspam-User: 
X-Rspamd-Queue-Id: 642FF20007
X-HE-Tag: 1761268807-456795
X-HE-Meta: U2FsdGVkX18EwyqpFunn+3sOtxP1btGANkgriXDO7x4Ux/nIWbijJmg477Z11HmBQ0Nq9ilnlGgBy04ZiHKw08C+1EAnmnKqQy7LYW7Bs7RJyDXDEJe2Tjc/H+7bJzw+ltrH13LkkG/uNjuUV049vew9tl/ba4DMfpsnUdAu0XMe1zBaAXEXuT97kyj0ZEC/TzvlF8o1et+4RtE/P4Epq9N/ejIQokI9qqsz7th5P2DzhKeaFcq11pcR2Ln0ZQHfnvknZXCD0W1unMmr1aJ/nyi9oOXm+B9hqxOGMpGwiV5v+fs2ZYZFkcMe5CUc+yTDUTHTfsnXe1H5mOlHklsrpYOfEcXpxa0doW4FBBPn4F6zstXptxQCxqACcXcmBAnmOuV8NZWqzweh++77XpyauTdJ5miwv7WVNeKiekMPYwd1zoxxvaqV2iIzwjnD25iefPL5lpi6/3PefFg2pEwcd8/erWprwKKC+6yab8Aq7CbCHPb3Myg9qrvJo/8TMIUyGhnAMfR5zs59eVho9UzvOxw5Et/Rprj1jycGnmuBvap4t9pUYS2UHGOsiIyGvRQL9+gucQdJbrkQxSFGV3Ww9Quvq+oadyvnx4aHl3bU18BjedHRNvxxN0cmfNZozLj2o0b//JRuNXsciqG+N9rgv0E66ajx103kQKKXrYxGscBHpTqY8BtKjbN2+wufTlmaNw8lPZK/DTNM8ltgP5mo4dBce74d3+vohgWJ0ySenSXKzZQ0bRjYu8oFE5/6bttJ8OAw9FvjroFKY7cTCZRthuHqf56tL1jOeP8Fpz4a4rcEWziVqMiy0CzQ22lwX9uszxxxtQexmqKGb4Yt38sB7a6ukImf5kEvBoVE9T4eMF7ILXmTJPdW+k/3fSCQJbp4HlqfcAeM40vds+fB5K8TmWoXsrJ4qnRx6Q8ay4JbKY7ihx3qrR/XdB5/boQ2Au9gmuLxpoOd2sXaNlrCXhN
 ZMOMgYtz
 ICx3RnKeVySPuKL3OZp+vvIBV4srBpOHoEqrTR4DWRVQCOiV/aaIfOf0Z00FeZoY2KZUR5ritFRMg3e5x8uPfu7brhvD57f5RuvGs/i5XspbPToCUKgFBtLFBjvW24XyatUNqA+x49wLGPFwdBgQh3BnXgjWfoBHpfOIdSnNsEV3U/ds4cWsTyz6b1Tp+hGKHTT5OMz9LEkRHT7Y3ZFkNapgiBvRCpPlj0Cfru7FV18GH6crQ36Wp8XQbO1JL+hou1ae4a5D+vuDA1nPUJmr2agweFNmSmFh1K6J/xMqAwgJb+WDDTOzUQsmWWNIVTdNYeo6rRgjX5eiwgvUI6FxqLHbE3zhog1k7goSmJL+ju+ht3hLdJadPuQBzxse9Kh8b++G8UolFhct2FKGcjvpgoxt8NHrr7UZ26vyRs0TPIfA0CN5+MpqvFuLWafyEMsSXGZvMTdB1DUtIj/OFj2WMbtcvFYnwUMRboXjpROGjNjXUy4JDA5k8G0LOPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 3:16=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> When the SLAB_STORE_USER debug flag is used, any metadata placed after
> the original kmalloc request size (orig_size) is not properly aligned
> on 64-bit architectures because its type is unsigned int. When both KASAN
> and SLAB_STORE_USER are enabled, kasan_alloc_meta is misaligned.
>
> Because not all architectures support unaligned memory accesses,
> ensure that all metadata (track, orig_size, kasan_{alloc,free}_meta)
> in a slab object are word-aligned. struct track, kasan_{alloc,free}_meta
> are aligned by adding __aligned(sizeof(unsigned long)).
>
> For orig_size, use ALIGN(sizeof(unsigned int), sizeof(unsigned long)) to
> make clear that its size remains unsigned int but it must be aligned to
> a word boundary. On 64-bit architectures, this reserves 8 bytes for
> orig_size, which is acceptable since kmalloc's original request size
> tracking is intended for debugging rather than production use.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc=
")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/kasan/kasan.h |  4 ++--
>  mm/slub.c        | 16 +++++++++++-----
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 129178be5e64..d4ea7ecc20c3 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -265,7 +265,7 @@ struct kasan_alloc_meta {
>         struct kasan_track alloc_track;
>         /* Free track is stored in kasan_free_meta. */
>         depot_stack_handle_t aux_stack[2];
> -};
> +} __aligned(sizeof(unsigned long));
>
>  struct qlist_node {
>         struct qlist_node *next;
> @@ -289,7 +289,7 @@ struct qlist_node {
>  struct kasan_free_meta {
>         struct qlist_node quarantine_link;
>         struct kasan_track free_track;
> -};
> +} __aligned(sizeof(unsigned long));
>
>  #endif /* CONFIG_KASAN_GENERIC */
>
> diff --git a/mm/slub.c b/mm/slub.c
> index a585d0ac45d4..b921f91723c2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -344,7 +344,7 @@ struct track {
>         int cpu;                /* Was running on cpu */
>         int pid;                /* Pid context */
>         unsigned long when;     /* When did the operation occur */
> -};
> +} __aligned(sizeof(unsigned long));
>
>  enum track_item { TRACK_ALLOC, TRACK_FREE };
>
> @@ -1196,7 +1196,7 @@ static void print_trailer(struct kmem_cache *s, str=
uct slab *slab, u8 *p)
>                 off +=3D 2 * sizeof(struct track);
>
>         if (slub_debug_orig_size(s))
> -               off +=3D sizeof(unsigned int);
> +               off +=3D ALIGN(sizeof(unsigned int), sizeof(unsigned long=
));
>
>         off +=3D kasan_metadata_size(s, false);
>
> @@ -1392,7 +1392,8 @@ static int check_pad_bytes(struct kmem_cache *s, st=
ruct slab *slab, u8 *p)
>                 off +=3D 2 * sizeof(struct track);
>
>                 if (s->flags & SLAB_KMALLOC)
> -                       off +=3D sizeof(unsigned int);
> +                       off +=3D ALIGN(sizeof(unsigned int),
> +                                    sizeof(unsigned long));
>         }
>
>         off +=3D kasan_metadata_size(s, false);
> @@ -7820,9 +7821,14 @@ static int calculate_sizes(struct kmem_cache_args =
*args, struct kmem_cache *s)
>                  */
>                 size +=3D 2 * sizeof(struct track);
>
> -               /* Save the original kmalloc request size */
> +               /*
> +                * Save the original kmalloc request size.
> +                * Although the request size is an unsigned int,
> +                * make sure that is aligned to word boundary.
> +                */
>                 if (flags & SLAB_KMALLOC)
> -                       size +=3D sizeof(unsigned int);
> +                       size +=3D ALIGN(sizeof(unsigned int),
> +                                     sizeof(unsigned long));
>         }
>  #endif
>
> --
> 2.43.0
>

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

