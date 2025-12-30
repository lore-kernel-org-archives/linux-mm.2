Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED528EE499C
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 19:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6FC6B0089; Tue, 30 Dec 2025 14:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7F26B008A; Tue, 30 Dec 2025 14:35:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289BF6B008C; Tue, 30 Dec 2025 14:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1546F6B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:35:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB24A8A8FF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:35:19 +0000 (UTC)
X-FDA: 84277141158.30.FEB39F9
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id A17904000A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:35:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="oOesI/vn";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767123317; a=rsa-sha256;
	cv=pass;
	b=5SPDw0iMvGjSZUq99vQHKyPtBeAzLTrjVGHA6NueGCPycLI4xI6QtR4FT/TVykt5xOw0PV
	KxELvTS286fxXH2R7OkCP44mFC0hK7LUEuFXK7uBBFyQ6BfvWsUg/cQ3HTFVcIvlnZcOxc
	hi4n+y9cHuTYxU1k5dLllrdArTmDlbM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="oOesI/vn";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767123317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgvRjsZOGyKSe/knuwAYxqkyWhzvXXHljajOPYFJW0U=;
	b=0EhQMTQ56PIYCFCOOHviniM95BvoIo6dLrnHoXHPTxyzL7SiR5Uxyf455TflDXnbwwAVfW
	iD6DvqwTSCYu/GrzYv28qamgSUtHrwiaGSLJlmHIJxEvJqWJmrKhJVgk34vXw1p5pMTgod
	98lN3btIRWaNKBg6oRiUutqHLMagJVk=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so915a12.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:35:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767123316; cv=none;
        d=google.com; s=arc-20240605;
        b=hJuJwE3kpcDylTg1ALj5vXTo2X4AOE63RXnSsKiXlepBOCaJsO020Tg/c0cNsDdefP
         PRPPeEvdqbDWd4mPwaqm/ethdu42q6dRAuDsOH1ClKs5Wxpr1wNlFPNF4t8DE0oB60+W
         wiqHLg9M7AkiMM38bEAYOXHlou6IZVmBMY+TsfCKxkYgMWsXIiB1k4m+qPFi6+QFENj4
         8siC6umTsVXiGA1bhXBojJBrtoLJqy0HWm7163on1Eqt3boMy8mQzNcerC3iJTQ8ocC8
         TDli4bhE5o68S8SHjQIrhMJW6EGwoFu9qnjAmHpTGCOqU9hWqQBWCvax/42swwcppQGF
         JN3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DgvRjsZOGyKSe/knuwAYxqkyWhzvXXHljajOPYFJW0U=;
        fh=WVukIM8gLfgjfYfzDms+7pD4J2WFNXD9/IIbo3Rd85c=;
        b=ENS7kla+eo+7G0ZU8FFL9Ey8NteHvU7sHNmUsqJYfu8LM4m2IcwyUyNSczz1qynvB7
         ASl9vX8HYFsPDBykpPJErFCHzDK8Se5kxudWlprtP01hA4gqsvR/JfeMwfR+7sWZcWRc
         mf6/6U+e7QjFNBpbY7ihC/NN04LInPeWkKHrijqZV0rNToex/kTDG0emhhmqmGqy/iwE
         3OHAvSRtXauwozCz1WOfqkFMQrhCAC0Y3vD6Rf33XfUXODlcz0lbduesXbKo/NmcIiMR
         q7bf+TWW5pUyNgnVm2Y4Pxrf0fRyC4t9/ZxSdNPjEKo8Oy4fphs4aZDx8FoS16+YIlTx
         Xghw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767123316; x=1767728116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DgvRjsZOGyKSe/knuwAYxqkyWhzvXXHljajOPYFJW0U=;
        b=oOesI/vnV2guxVjMPSa/TSQ+jAck0rKUE/1BD7juCdigabWeI3V2A2t7spM7rDYqJj
         dI/Jj7Q0QPnjJiW0PnXUUzg3AOEskoXfgm+iut5/ycCSLfhQWmNm+C4tDeQrcGg10lCx
         xb5TuTKPVdgKLQiFpWX0JysHnzq2OwIZuA0z/ZGtZIALiGODAr2d4OYVGOxXNW4Dkjh+
         BhzMUvAD3+gt70dzX1znFEZbYiEFwPSXPvJ/ggACico+4+YLjO86cSiohBtZaMkaf1/B
         y6LwvXIX+HQwPtsYthCEC81GSJPIUimdMwDRa7f5GCDutkEuFfXENx2T0DDT+PtDK82G
         SfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767123316; x=1767728116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DgvRjsZOGyKSe/knuwAYxqkyWhzvXXHljajOPYFJW0U=;
        b=kkWUbAPfkji8OFqHlnEsNr4VVPcu3Ku3FtqSMDAAK8TUYICfz/Umj4l3fel+bRtKrO
         8e9kSYFiRwHgfNRXOGVI+9FFRZqiEzS4f3dZVccOeoron6/55Ep1BbBNQ/y3w8j8p977
         mtKum9Z0s+x5hs00G/t8HUcp09VeIGR+tkhVtiF++cea2hBLIvgLzDmXC6Mt/3qV3VJB
         MwfjqOFuButmTr+8YaNpkTWfsYdJi1Incj5c7/d4OF9YGC1kOorTVdsWHtsrS2ZLyHRN
         9Ln7s+SJOHwewAT+i0JX4L5wffSCgfObNaKzxqE5UBWqcFuYQn3clvmwi+HA758GJl3c
         BlRA==
X-Forwarded-Encrypted: i=1; AJvYcCXIBuImw1js760iN0pCwFNx+/EW+p2Y5ZYevmvA7Rx1UbVuKBmFVwxeMCrhe3o2On3ZPzGlP6FmGQ==@kvack.org
X-Gm-Message-State: AOJu0YzXm2tQecvrkRWNiwKC/Jj5CdaXTYe/x0rCeIJPbQvSyGSfS3m7
	1gFs0cxMdXF7YG9MhpgcYUdoA72ePjHSyT0jH6Y6PJEFCk8AEx+nmUyJmdzvwWhx5NPiab4ka8i
	uocQ/5lG/lZLcuXr69NxZd/eqHY2dA1RIEqJCva3h
X-Gm-Gg: AY/fxX7CgczmEZY/6/D906MQjERuVSKFDmJW+D/FRH1QBPp5G/HF4aUY1y7lCBsTwJo
	5kqy3u+WWMXdxtruqlIZSSg+iaHLpYLU1Rk6K5s7ofGVJliOVbkoORSSV+XJPzBgO1awewVOfPk
	ffAjRfO4JbmtNZ5ENqoXucVhozgQY93uxOFgqpMUKI0lt+6MP9ymRUZS0pQcbRM+kbanrLpXEim
	z8DA//04b/iN/kG66aGu1pOt6MmLoM6md8y2ZCyzrLNy+KvIy+orI21xG6xIPYrh2JEEvbvHz1C
	4aPF4vlguAu3FfMyrMercZCAnw==
X-Google-Smtp-Source: AGHT+IGvOANmbwtY5S7RjObO12ig817h9MWuJBPtde2I9vjPx3BIWer2hLNdxtREijh/OKt25yNq16l/38a8DlGuVL8=
X-Received: by 2002:a05:6402:d6:b0:643:6984:cee9 with SMTP id
 4fb4d7f45d1cf-64f41c62ab0mr3829a12.12.1767123315826; Tue, 30 Dec 2025
 11:35:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com> <ea57e3ee7b4d2d40cb7f77703baf0c3ef34bc304.1765970117.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <ea57e3ee7b4d2d40cb7f77703baf0c3ef34bc304.1765970117.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Dec 2025 11:35:02 -0800
X-Gm-Features: AQt7F2rTiGdk8z3mFql8ITVHBHZdk4WPi8pPIj7u6qb8I1T2E1oSs_19lApPC1E
Message-ID: <CAJuCfpFTSAyzHBiz3u599td_A9DrcTjhTi94vE+=V_V0Bkawrg@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/rmap: remove anon_vma_merge() function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A17904000A
X-Stat-Signature: 1d3w8yhpyafb6n5xpbkjqhm59jdw6qjd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767123317-649136
X-HE-Meta: U2FsdGVkX1/UoP1seqrMo7JGEhUrNZoSDOcXcv1lLyatx1SvfenOEm8Bnn37rlMZJAeKcwWBZLEhAGd6E3c5OSeNVGPCA1FDdq07itiXSyE92ScoXc5BjvV2xOIN1MNdsrxuzvgvKu2kmv0JT4Gde0IC6kzTPOow4D9q8yEZOl9JJv8LgWWT9iS01MnnDjd98EFPS/mfc+f/1d7wFLvjPFveJsJ1+OGcSgJUxvKD+lCyNL8lrTyRMyqWu0+uF9fWiscxjNpFDX+n6bbWbypOX5JowOz0uotBBV/NQ9TDMmVwU+LGCYe9jQWON4FMEM0um8XryV5hM3AL4nyrj+uZ5IhsL+gjO+85zIe1EV3vXeIvLLVo+pHZWDigXMhR8i5874RLljltlH04HW48ig7nTuAeqkojv3bfWEAlpakPk03qxRtoSXMhnlfbOEAjE6vNf7hyrapGMsgRQw08B+pLay4iL4BhGa9SXJyjUeMAPf+ermddIG9bSXv3hq5av0xiM4vUQn1NSP+TdAQR94yvI4okkDDGCVra0P9Ld25psbTuPM8r7qkZOqKBg1NYms7JRPrQY6a6pfKmvJgRCqTSy0aP5Egz2K6LsM4HvG/bHHX1sIZqaR+g1HJMWCNUMfeceNaVpR4/MyI+GNe/7eh+kWkvVywQuB49QTjJc1PmK4Yp2vD1LqrXYp8bMfNUVEo8VGFp2ewPIb5pCTUrOFjkYazHnaKmf8k5D7Jh2U+2FSPcfJs6dCYZSVP0uAvtlFmN3UVH5PPzIOZuMRabIrKGdaHTRBJYkmwkb+nAdITg9h/ejQXdj080bTH7BLhFyUZfxO7xYJbw1ILBQv2TNDtIqasgO25GmeXO0VGepJaypM7L1RWK/VjV3PR6YLhYcMgF6ZIRThg3laVsi1wWTrg8LUjIK0exx/cCik2xYPNRJZlPIZKeA0IGoZwZEUHimSlIgLmzH72T2BQuxNiod8v
 0XCXd+Et
 J4MNQ6Ce5Yr0WhlDNcXmrhqqz7lklgOU9qDbLQ5TfMvS1aoRpM6iD9aYfIbqsrXgme16wPk6BYgV9B9T59pm9cNEDicSxEKt3hfiyxaVcazJRdaTXVNUS+xoFNVuvjF8s7DQwtKX5/G9bP/kDGaS45grgYMMZz0Yuuk4VltXup1c7ja+fi4x2BfQhWHs7GzEG4EgmuzhZzvfz2byB0wYmb00oUDe8zBdwxb3Q+yi1eGv4/Ma45tRKPNRM25RUmro9KlbueNOVuljp/+A/LoxBDAOOnYqf8qs6JYFVG0FO6h6CON67r3HmVjRfHOtunwSI2XmUIdGLOunio1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 4:27=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> This function is confusing, we already have the concept of anon_vma merge
> to adjacent VMA's anon_vma's to increase probability of anon_vma
> compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
> as well as anon_vma reuse, along side the usual VMA merge logic.
>
> We can remove the anon_vma check as it is redundant - a merge would not
> have been permitted with removal if the anon_vma's were not the same (and
> in the case of an unfaulted/faulted merge, we would have already set the
> unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).
>
> Avoid overloading this term when we're very simply unlinking anon_vma sta=
te
> from a removed VMA upon merge.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/rmap.h             | 7 -------
>  mm/vma.c                         | 2 +-
>  tools/testing/vma/vma_internal.h | 5 -----
>  3 files changed, 1 insertion(+), 13 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d..832bfc0ccfc6 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struct vm_area_st=
ruct *vma)
>         return __anon_vma_prepare(vma);
>  }
>
> -static inline void anon_vma_merge(struct vm_area_struct *vma,
> -                                 struct vm_area_struct *next)
> -{
> -       VM_BUG_ON_VMA(vma->anon_vma !=3D next->anon_vma, vma);
> -       unlink_anon_vmas(next);
> -}
> -
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>
>  #ifdef CONFIG_MM_ID
> diff --git a/mm/vma.c b/mm/vma.c
> index fc90befd162f..feb4bbd3b259 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -376,7 +376,7 @@ static void vma_complete(struct vma_prepare *vp, stru=
ct vma_iterator *vmi,
>                         fput(vp->file);
>                 }
>                 if (vp->remove->anon_vma)
> -                       anon_vma_merge(vp->vma, vp->remove);
> +                       unlink_anon_vmas(vp->remove);
>                 mm->map_count--;
>                 mpol_put(vma_policy(vp->remove));
>                 if (!vp->remove2)
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 9f0a9f5ed0fe..93e5792306d9 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(struct addr=
ess_space *mapping)
>  {
>  }
>
> -static inline void anon_vma_merge(struct vm_area_struct *vma,
> -                                 struct vm_area_struct *next)
> -{
> -}
> -
>  static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
>                                          unsigned long start,
>                                          unsigned long end,
> --
> 2.52.0

