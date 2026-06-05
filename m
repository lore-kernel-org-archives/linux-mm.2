Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E11FCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269106B008A; Fri,  5 Jun 2026 03:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A866B008C; Fri,  5 Jun 2026 03:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109416B0092; Fri,  5 Jun 2026 03:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 007146B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:25:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E41193BEF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:25:14 +0000 (UTC)
X-FDA: 84845022948.14.774F0C0
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 976634000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:25:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u54qnDqu;
	spf=pass (imf01.hostedemail.com: domain of edumazet@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780644312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKU63sZNkKiVuh/MwJ9Ce0lsts4Qigj8G34ohJIexYE=;
	b=FN8HQgN9OjjUIuodH3SCGOEoqdaaLOC1NaYTCMXzNs+FlTp84jUxZPSZfMkiZcBCItHoZv
	dK+Y/T8jVghjnkanFyj6dSk5Y9EFk0sCbGhabvZPNwtZ57oVOacDJy0ZZg6SeAGyOEQgeN
	OX+O71FeJ2X0YY1iBJWgWZo9Byq4aWw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780644312;
	b=SizC8x8Ze+Bq0ayDg6xVsD+yehDoyDY0pyzOsBlZ5zec9chydoifpcmJtcQgiK/ITlAxYg
	3f+pw3nUhyYsF4pSl/5coAPXOXnLmTSH2Y6Znw8W4aJlDgo+UiLk4MyfMVlPsoVy1vZb3I
	bj+JCsKNNltZt2W1xrmbNZYy39++QgM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u54qnDqu;
	spf=pass (imf01.hostedemail.com: domain of edumazet@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5177945a22eso10465541cf.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 00:25:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780644312; cv=none;
        d=google.com; s=arc-20240605;
        b=JbSTdIly6EDnUCw7GFkH5bD54ejDLmRejAWhi2nHzBGebQ6Jdvg13igq1aAEGDxSYT
         djNQXPjDPVQJOvvKZULmshSo4LlCyXfkkgoi2b6E2/nbigBbWdjdUUIGU2Tqz/uVThCA
         h0YKmGlnp9Gml26wJsyqt4aEFTIuJrcN3vfIq/GBHxxvDzowNzv3r0q1mt0Zt7zxP7uS
         12JndQR8+j4euQKQnREcZtqAbderx8rXcTLVIEMiBBTR0FhiDXUPJO6/MnrxeTNN/RG0
         KYPath93B4/dTySeShqP1qYth9D8OIwp4r6A9d0Y1KyhmZILBmWoYNVcIenBKfnGtDSX
         nC/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qKU63sZNkKiVuh/MwJ9Ce0lsts4Qigj8G34ohJIexYE=;
        fh=9voi1t8bGEYlKWkB0N5Gk+Z9SiVgQKgZ2M3NIAYS/ms=;
        b=C3TBvsLlc0mpBJ3bV9uPxWGmPB1fVECTlup2YfPZDhvBumhK+eqE9pC7v8w3kU3KgP
         XG4Gz8kuoPaUdVCfm0oagwMDAHKO+UR2cKbYAV7aRfu+JJbNk29wjQ/N2kRJmjeFUp9n
         zYKRXORWwpgWB21mOhNg2jsjplL41WLxGDQ6uXa5ivOFPDie+uWYH2RNflva+qo79V5k
         SjRjZzjVfHCPca7Fd7kyFUDUaysp2Ng22EVX5ZBxLzf56sOEaNuZCUw9M8W6rMjDgTah
         y4rnujm0wG20/TWsEueCMiKKdNFeVy3Z+GA4Rvwz86Hw6/trzmhXu5lXZYoQfyI6Ymdv
         78fQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780644312; x=1781249112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKU63sZNkKiVuh/MwJ9Ce0lsts4Qigj8G34ohJIexYE=;
        b=u54qnDquBxT9XM2S2ZNEn565yEEbKGpUfYUitYysbRv/13RBAIXLgpiCKOFr2RA7Qf
         S4GDcuUcZU9LGyFTl864pWgOM5h+6N+TICeyPy68hu2L+N3z4oGGjSWdbiwKeULELTuP
         xp0QuJZLW8Z7ySVJVIr3hebyYGhAi7Y78d7a0WIilzqhwppGcsy3E9riqu+syM78i2Hd
         ZX5kk5kSL2xB64vAcj+1ahyCPi8w7FDBlP6MZpzlelhD9D5LM5CeQ4fn/OpjPJdRby1k
         SfLdq0GASsXg4R3zY7oM71AmkJfJAZGEETuTgz/PKl7yw8U0fcpVuQaG8+HoEJqd117t
         ALaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780644312; x=1781249112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qKU63sZNkKiVuh/MwJ9Ce0lsts4Qigj8G34ohJIexYE=;
        b=a6+D5nYhQptBHHDi9NHYca/QGeb4iDIdRqkhiS2MkSXiocSJRSR3QUT/3Y/nwmJzmA
         7W2M/RG88I8A8wHV3O34Klt3vgO5ruBvpJIz6Qx48afVbqbugQPGo/5RF9NWYB8UgFgq
         LbXFcMB5D48uOLZ6S8MknUL2pVYwq+3vH4AmnSeCCCe9+oxmSTGNUYtkSjO1YRJYktGU
         bpHKvfW7eQaZkPSidT+WuxAB2dQu23XXCy9PYhbIiHwmAmamOH1u4yAkgeKkoJ8npAfL
         rnb0Lo047UnFYj2tsL3YEYkECXP5N/NlUVd+ptFcbIyJeXTc83G/Flv/ZEtJar6hTFuq
         ZcGA==
X-Forwarded-Encrypted: i=1; AFNElJ+tflAT92L5IoiBgagF8o2qdtzN8REHT7yYiPBnr5ulFocUzWFR4MmNIZPs5aHs4qjQ770SjVfJPw==@kvack.org
X-Gm-Message-State: AOJu0YxqZgL7jxaXfRHCZyi+ZDq7ruZAHMpYrt5XOh+q6Enq7U2zxSZN
	m4XF5zhr45ToUbDBiM4hsx4LLYVJJlg5boEEkZl4XQIXmqXf6cMKR+rqcqNzHalHTwvP/6UjkOl
	6hMu4Q8J4SEIOTYGoGGShAKXE1jEeVGVBI2rUaLK3
X-Gm-Gg: Acq92OHzWl5speGliaoZaVozeDypAHe20eotiUMQGX0y9zx0b8LtNcHz8+QbHk6L7FY
	/BE26C5O39t5n41nFCsKZF7faF26G0cUfcNuY6mcH+4n9mQqmFtVd3MftBL4r3cleQhgR7hBpOr
	oWdROM/gWL+ZBsY2b/o9PgPY6Z0s9dx45p2cYfzy+faJkiQjxOko+xZID8CyO4YdVKs8vgjg5fE
	MGztwMta36VT+VUZo8Hf4ohjW31ziRXPo56hceKGfonwx+j6UeD+/ObfnFwRK9+6rbGphRkEqEW
	0DR/UQftqlvcf9g8goiqVxr0jiPsoKZOpA4T77rakXjmsgiK5dtf0NhCwezGoJpe682iNXxFxrQ
	2JGfJASSkeLdiIayi1BEgv0/S2q6C8XT6QQGmipg=
X-Received: by 2002:a05:622a:4d09:b0:50d:65ec:a071 with SMTP id
 d75a77b69052e-51795a8da05mr40394911cf.5.1780644311231; Fri, 05 Jun 2026
 00:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260602183122.747759-1-pfalcato@suse.de> <20260602183122.747759-3-pfalcato@suse.de>
 <6d70757a-a849-4828-89e7-f3d51bf8c9f8@kernel.org> <aiHIQ4ZxnMSifhmi@pedro-suse>
 <0198cf7c-ba09-47e9-abc3-dd230c1183dc@kernel.org>
In-Reply-To: <0198cf7c-ba09-47e9-abc3-dd230c1183dc@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 5 Jun 2026 00:25:00 -0700
X-Gm-Features: AVHnY4Ljnr1fO2_Ja9ct9TI0Ly9oIHrrXA2zxGwHDZ7iMunMRBy7qMI9IIG7ZO8
Message-ID: <CANn89iK_4g-2_U41CGYNdmBLCXyOARGdAakj26eigDhaL8hkCA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: skb: isolate skb data area allocations into a
 separate bucket
To: Harry Yoo <harry@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 976634000A
X-Rspam-User: 
X-Stat-Signature: gamknn39fuy35zezreu34n84a68iysrd
X-Rspamd-Server: rspam08
X-HE-Tag: 1780644312-984540
X-HE-Meta: U2FsdGVkX1+qVwKwVI34aKjEJYXPQbaraUH0iXlgfMx6IKdDR9d4lHqAby+udJXbfxcTRPWmfVK1eVStatAKXQUjooJbarOq03VMk4blckKTAWWZ5zEGs7g9LCApNwxAfqSuRV+uDe15JEtGlhthaE0CovKLsncmofEnL+DfGwtsyrT6qG4FdUHzrX6N7ZExoWnBuE/V06djJopLucfZT0rFiaGaMFACbeJ2ePiuHZpDiJVFnaV4i/ttHyl1zvTUXwmDXlFvrjhpCJYzCAzjpW7JskaxfUlgjp2Ze5Tk4MsHi/zmuH+iE9hHsVm5qgFQZ5iXMaMXAVXebHX46JbZGUJ903j8tiOX+C68Ao/5uqh48fTze9sDqLHBcjhrcaEI4s9jkDFk0vNKNFPJuLtrJ6r16tstKLrjRfwprfO5sKGTqEZSseolDFsFNpQb36zgzC+KPyxY9R/G5fY09eUxRKKXVegVzVedGpSfEh04W8Uq6tc+FqS6o0omYBHiofyTsLYuyc4mC5c/R4cOZWkHgnl/WRyugMjNp+dneRC6wySpfmZixc3cpRLoIqtvRbzoc1YWHFlktI/QtOyYez5jFJJE7RjxB7dpv3BHV1Zc9RRy2LXTZElqv1UMUQLqsJRxBPcVswfifCrlX9ZC8PoC+uQ5WtFJxBneVmDiTeYjU7C+IsfBEbvBLfzYgcY6RwI2mV70+WjQnV0FecI8EnGmAZOcRMHkCs1qA2n+q7p4p25zTNk+hBKTiGEC6xQGOmwfFk0CHgOJ8LfQs06fR3DiJz+9kGxej4go1WrO+wtwDqEiFl1WM03lGULuixvDG1q/Hr3B9L4ovUC7SBGGkdizG+jk50lFEspsh2LG7ZPHE2tu7IPK3bEjOyuaTL8XpqhtnM4F2wqZR3TeK/Ft4N/EQy03Lwpn7QLIAQmks28hMVz+P1UxLlVYXGfOUwaPXpSu/3KfpceeSnYyb7OWRIZ
 3UF8AArU
 7m9gfi3yk2C+IqwJliXO9nkFP7XfFI9jIwTx7GhXSrHdXhBF5cV6k4GhzRhoaP31/74tspCmoquTjMXDlmXP+dJ/coCM/W0RHLxMlbcC7TgRidqknphaS7Jm/y0eliFLf4vq83tXMBR6ZPuWhgUQWaUss7dtkDbWuckt+sY6HkzUjpg1T6jn6jGkmDylMee+8F/1Vpk501rNW8yVNRM2vuaggP6k//kuT01ELGzTMfQ9wkmlS97bjkYqsETDzT1URe4F1zIvDPshoeUB6N8gLlToUfD4LRuUygh2Jspp/QMfBLWVGqXy2gHlsA5CLj0hh+8Tc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 10:45=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/5/26 4:12 AM, Pedro Falcato wrote:
> > On Thu, Jun 04, 2026 at 02:30:34PM +0900, Harry Yoo wrote:
> >>
> >>
> >> On 6/3/26 3:31 AM, Pedro Falcato wrote:
> >>> SKB data area allocations (as done from alloc_skb()) use kmalloc().
> >>> These allocations can be variably sized and their contents can be mor=
e
> >>> or less controlled from userspace, which makes them useful for attack=
ers
> >>> that want to overwrite a use-after-free'd object from the same kmallo=
c slab
> >>> (which often just requires the sizes to roughly match into the same k=
malloc
> >>> bucket). [0] is an easy example of an exploit that uses netlink skb
> >>> allocation to target another similarly-sized accidentally freed objec=
t.
> >>>
> >>> While other mitigations like CONFIG_RANDOM_KMALLOC_CACHES exist, thes=
e are
> >>> probabilistic. Use the existing kmem buckets API to further isolate t=
hese
> >>> allocations in a guaranteed fashion, when CONFIG_SLAB_BUCKETS=3Dy.
> >>>
> >>> Link: https://github.com/google/security-research/blob/master/pocs/li=
nux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]
> >>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >>> ---
> >>>  net/core/skbuff.c | 5 ++++-
> >>>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>> index 44a7f8401468..1f6c6b531ece 100644
> >>> --- a/net/core/skbuff.c
> >>> +++ b/net/core/skbuff.c
> >>> @@ -594,6 +594,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, =
gfp_t flags, int node)
> >>>     return kmalloc_node_track_caller(obj_size, flags, node);
> >>>  }
> >>>
> >>> +static kmem_buckets *skb_data_buckets __ro_after_init;
> >>> +
> >>>  /*
> >>>   * kmalloc_reserve is a wrapper around kmalloc_node_track_caller tha=
t tells
> >>>   * the caller if emergency pfmemalloc reserves are being used. If it=
 is and
> >>> @@ -632,7 +634,7 @@ static void *kmalloc_reserve(unsigned int *size, =
gfp_t flags, int node,
> >>>      * Try a regular allocation, when that fails and we're not entitl=
ed
> >>>      * to the reserves, fail.
> >>>      */
> >>> -   obj =3D kmalloc_node_track_caller(obj_size,
> >>> +   obj =3D kmem_buckets_alloc_node_track_caller(skb_data_buckets, ob=
j_size,
> >>>                                     flags | __GFP_NOMEMALLOC | __GFP_=
NOWARN,
> >>>                                     node);
> >>>     if (likely(obj))
> >>
> >> What about kmalloc_pfmemalloc()?
> >
> > Good point, that looks free as well.
> >
> > Sidenote: isolating kmem_cache_alloc for possibly-aliasing caches could=
 also
> > be useful. skb allocation has net_hotdata.skb_small_head_cache. It does=
n't merge
> > with anything for $raisins (odd size, plus I don't think usercopy cache=
s are
> > getting merged?) but it feels too... accidental?
>
> Right, we never merge caches with useroffset/usersize.
>
> Hmm...
>
> /* SKB_SMALL_HEAD_CACHE_SIZE is the size used for the skbuff_small_head
>  * kmem_cache. The non-power-of-2 padding is kept for historical reasons =
and
>  * to avoid potential collisions with generic kmalloc bucket sizes.
>  */
> #define SKB_SMALL_HEAD_CACHE_SIZE                                       \
>         (is_power_of_2(SKB_SMALL_HEAD_SIZE) ?                   \
>                 (SKB_SMALL_HEAD_SIZE + L1_CACHE_BYTES) :        \
>                 SKB_SMALL_HEAD_SIZE)
>
>
> What are "historical reasons" other than avoiding collisions with
> kmalloc caches?

git log/blame might help :)

commit 0f42e3f4fe2a58394e37241d02d9ca6ab7b7d516
Author: Jiayuan Chen <jiayuan.chen@linux.dev>
Date:   Fri Apr 3 09:45:12 2026 +0800

    net: skb: fix cross-cache free of KFENCE-allocated skb head

Note that MAX_SKB_FRAGS can be tuned.

config MAX_SKB_FRAGS
int "Maximum number of fragments per skb_shared_info"
range 17 45
default 17
help
  Having more fragments per skb_shared_info can help GRO efficiency.
  This helps BIG TCP workloads, but might expose bugs in some
  legacy drivers.
  This also increases memory overhead of small packets,
  and in drivers using build_skb().
  If unsure, say 17.



>
> > Maybe passing something like SLAB_NO_MERGE and making the size
> > standard-looking would be nice. I have a size of 704 bytes per object, =
and
> > this probably causes some weird wastage for each slab.
>
> Yes, unless the "historical reasons" do not make it infeasible to do that=
.
>
> And I wonder if net/core/skbuff.c intends to always prevent merging, or
> only with hardening configs like SLAB_BUCKETS.

We do not care anymore of merging or not.

