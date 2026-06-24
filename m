Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0FE7CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBEF56B00A2; Wed, 24 Jun 2026 12:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B969A6B00A6; Wed, 24 Jun 2026 12:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A871B6B00A8; Wed, 24 Jun 2026 12:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 844506B00A2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:04:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D9841C1EAE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:04:20 +0000 (UTC)
X-FDA: 84915278280.12.329561D
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1250B40014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:04:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Odb53rh4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782317058;
	b=sREEgzS/+OHPa92DXXPY/cG5J3Zgcar4H0ah+S+Mx38qhhsZiX9RBTImmc7UECs6uFYJnt
	iWmSo3Msh4+WyAQj9RF+suqlNjxayrNct78oM8SdsCE9/URIAB5zWfINJ+SQYfNO7Ryl7f
	nhfuMmqwkJxTG/ecD+jnmHjajg/6v1I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782317058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhiS7oy2LfTCZ3XodtRawKKdXn1sLVFN3zBm3POyKAE=;
	b=WemA2fUH6evmtpXSJYoFMuXs2c2aFwtA+ou1BrSq5BGEInOA7aQeqqUnULZaFCwaaGhbnM
	TaNlf1hKKT+ayEy1xBXm4j7mCtQmF/k7j8C0Ff5SAbcZ5aWJ0cOzgWjSHq6SaVHlpg8/Ol
	3e9gkraP60MHcckBWPvrP7D7wYKydrs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Odb53rh4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-519ed52bcc6so330351cf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:04:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782317057; cv=none;
        d=google.com; s=arc-20260327;
        b=gatSL7KY7Q6Z09cwH/QmCUEyZvb6vXxLCYgLMOSgzUbLJdMZwpoBnZwijWQCgdJgAT
         zLPWgXcXEi2HKORnUqQ9vXJmohoau9b2MXwnX9u1PIeWV2nSNRe6ijQcLgTu8HzjuhyF
         2nxvIugjNioVTInkfJjx9S55pMM98xS4MSi4Hffg4uaKQ2VyYQuYvDPSPZxBz9Zw/dee
         Fq1XzG0EsiWuM9vY2bnT8zGZ3U91Ba/d0IMkbPiYsrGYP7Z83CXxbCB6Y8gePysEIPtJ
         PXqRmIwbh9A1bX1S6hhVjZrBPjt8ryiKp1cyjfA1hTG0iDIutmzCFkHcIi3wC1KNbpkU
         rwvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZhiS7oy2LfTCZ3XodtRawKKdXn1sLVFN3zBm3POyKAE=;
        fh=Fd5QAhpJv0Wru1ACykzEAGhGusvVFF5Yd3vW2Z/NAi8=;
        b=Xj51/mHeUez8P5s4Zpfk+EIUomSfg/psNvBsX4/SiPvq5GfMI7HjTzt8oI2uKVB/dV
         1vzMSFIhpym7oQmJWa8FMb27+1/8Efs1rnctjblLJl+a0Qvpp+tiRZffThUihH2bADNi
         lx68ycy7/no6snd/PW+hJ2skoAldz6ahnrXf683OiFr0aFMWcs2Mid9Gv3Dl2vxlrmBL
         iKuyvPNUtgelu4ngPexDDGA9nUvStkOxKdSnFa6kYfi8KN5lCj3GWmUesNjUXUWvdptq
         n/fdsxFkKDLTYpZveITeXiDEism0fiK1f/Z+5t8E85hFijvX9QRyJJ26sZJzet0KhrRC
         AAyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782317057; x=1782921857; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZhiS7oy2LfTCZ3XodtRawKKdXn1sLVFN3zBm3POyKAE=;
        b=Odb53rh48f508+UvN2Vn0waNv9g+iyrunm90jjaQ/mQe8l7o1VJD+PV7p5FZn+1zCY
         Nl5Boahhy1aUsrUvRRIZVQ6pUohJLSdTQ+X3ynlW0jxDSRo7++vjVSb7tr+txulVMC61
         Cx+ix4t+I/4aE6aDfdE3W6o1K5MICSRWWe0GSPgemi/U766KZqkW5qyadi8ZGiCMpgZf
         IbsFIdcWFYifH6Iqk8+WDZ7tB2Nczx6pZApSaM8I2olvXnwnyAdVLUKersmhK2SIl056
         Ne9Ozf944GCRkEZZlBJ6P0Gka/lvMQzuccdBvXNpjqC8p9AtnhV81s+wm6fUSosKSl+K
         s7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782317057; x=1782921857;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZhiS7oy2LfTCZ3XodtRawKKdXn1sLVFN3zBm3POyKAE=;
        b=eHUeGPvQ3gwXTjqqlRGCSrcURv5rAfnJt72iMJATdbts1edaWoj3IZq372s/xjL6jK
         iiXTXKl51BhpC4bSACCJPd6DgoUpifm3DBn6hjSYUl4XSdwej9r1LVzeWMmOA47tWevH
         90qldkLf00JMf4i30wmDPUYC6doeaG/z1H3RxzknVSgUFxRi7QIzQg6OimqCxyCeb3Mr
         JNW9PF6x7EKXhX+FaIidKxBlgaXfhECRtTwd93FHXjXgGZTlGxLkUHHpQT2e6R56ugFQ
         zkWuefoFgjxDWC0S01DV9RHPuKUGGNBVdTufE0h2pLYn06jxn94jrvyQxZlIwRTJTrU+
         1SOw==
X-Forwarded-Encrypted: i=1; AFNElJ+Gbwt6bdGClR8qRKLsOI5mraYTFLsoCh1G16JIv7faeTpsJLMAofRKSfovXGA8Aa5bDck/Tex/Jw==@kvack.org
X-Gm-Message-State: AOJu0Yzw/D/EHy4Jmf2y2DhHqKv0Kce4I2p2K687WfbMlelDonGRGDHs
	Xuce5tRFf5jfW2khNkW/pcU+TGPHLoDTr/pTW67SMG8Uxd40tFGlFyz06PfKpjfXOPZdSgHYgEL
	EB1swMFx+BmP8H60nh/+kf5PZ1sjyn5stRiEFxNOF
X-Gm-Gg: AfdE7ckbw6iYGWk0nsx1rPEeDB0WtxoLiF1wRsi+zGVYchclp919Dh+VDTwZqrM11uj
	v7hvZrDYUaYry+XxjIQRrXHKDSXFfVrgRFvKimCHjm3vW34yA7LDfpX07h7h6LR7vgSQAtCFVJy
	EOL23kkrTBXzAmXF+oW8xhVtMDQm94bcwhf/+z4z/uAWI0SEKqS6anf6iLd128sodlsRWoawN3T
	Ry8z4u0DP5izvbbOD3J8QojLWx7pGeHl0iE1AOLUpx79cSnt0JonR6NwIBVOXSVZnn4gxRNzeAN
	ZCiRlNrfzXBBJlgh8mFJQnmgG14=
X-Received: by 2002:ac8:5987:0:b0:510:fa1:73c5 with SMTP id
 d75a77b69052e-51a618d11d3mr10106971cf.16.1782317056213; Wed, 24 Jun 2026
 09:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com> <20260622-alloc-trylock-v2-4-31f31367d420@google.com>
In-Reply-To: <20260622-alloc-trylock-v2-4-31f31367d420@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Jun 2026 09:04:05 -0700
X-Gm-Features: AVVi8Cd6lslf4L8Pa56jgYl7vha7nodZ13IZY76_KASlAg5iU8NzS-0fLnwiqjc
Message-ID: <CAJuCfpHCPr7Wy0XQ4UG3X61KjdNH14FiB=J7dvdUkMrGxN0Fbw@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] mm/page_alloc: relax GFP WARN in nolock allocs
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: giqxm1gxj96pt4n9sttzgr3n7c5kmsby
X-Rspamd-Queue-Id: 1250B40014
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782317057-308740
X-HE-Meta: U2FsdGVkX1/PdSCixqo5/L/O1W2w568/I+UwyxhQUR4mpBsEzuAHQejdOWq2WFsEFo3ODWi07h3apdllGsY2JU4V+iT0u8Uu2iG5bJ/YBPlHy2X66wqqbO/1eqeOJ80hra4Cc9k2pI1czV+7eDv+1ierKIwx3K2sTn3615RqFJMrryVWViaH4sDnIj5t0zBjmE2mu8wrmcHWPKbt5RKtluNzjMLW77QdsFFEwFFb2ZZXo2RxTzLjI0gYcaHu8QOFMStCBeLbzTdoPkqSrC4RkDqGRUjv+E67Hc2SEYCAh5q7lkkJc+/ocEinvP2Pg5BkFRUOx8vroTsoQWhA0J6Kgo/0uCUOEYGkGbLXY/Kt//VOtMcc06cZMkBrcqRJC+ol8HaKXQ7C+fMr2R/spMYvzp/RcEDfTZucJfktyAQ8CLKkn6XvsvX4QoQODT4zU5MZ8K+IQFeBbip42qw+hEAW8CobnOYngATPUogQh9uzwJ0dOpCLEHJu5kOhtbOxVqQNN/1PDmKKF/UBuY6ccAVxRM12dHsmLS5dO+UA2aejaMEn7mC7YsnkoiJRRnJvYsXY69Ls2nXBucZcI9lnxWkAdNt5b9iOpPbjusXKTJZ8vFIucTefMycmdZWCDY6KtThCuqb6qwa/6hGwhgCU+5XXXBT3lN20imi0+ATqHlxJuATRqYPwDissnUNAPgvgEiDOb557YYAE3aWX9/qsnCM9+lDfCSZ9O6YK4a07b5rXVe5N6OoPXMP0dmBAMa+hiisIS5HfjiEojFgBbLKBdryTcx/wkAeiTbXvI+mHHezfxthibI1kx75MJhpy2P4Hr6KsyKvAtzIgtHXy1F+bOVFRI4L27o+WTi/DvToWJMk6M0XeXIuyM8JjsJ5pddciXRFXFhR39RPlaa135VpCFw1lBJdSSMwgoIbi6EPSAscZGe6iOG6JKNaMocWhYWGxbvnqYtkg7Wn4zkEpqNzA2qA
 RgAyJ5lf
 kvSLghXp7ITF4mWUY23px12YGM2Lh46w5a5nyUWDCSE8Q2oauZ4zTfTOgabTVQ++YP6bZx0TScg3S/dzYeetmOzuNvUcaxyEUTvqfkRIPWJBdwKbkzxPRBZLe4Z6Pc8EgB/vp4WqlvWmrOTq+Uj4vVeKAH7z+mvA1ubPZnvYUsH6uwgGkchsSWYKiJYw0IKLxTdHEMroDZx+z3pTzjtRLhpTQjKoN1KWH1mpta/IENyVAye/MTp/Zksi/5ricc/lWbP/1YI4gYxgryC8iHUpqAZsO6aiV5iiPdSzumi8uyE0yBstSf6GwXOLGDioXaDabsUn7IF67/NHbZYkE/B74TAYfhtqNUxISFveA+6YHFl+CMAMtUt8gmGF/WPgeUCSGDboDwe0OLwDwAiX7Me7nqm0lf24FYyX1Ij/7SKOvgQ1iNNhB8luT0wF7U56jZLgS7Rd46RYQV12LLvonhpQ7kL84vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 3:01=E2=80=AFAM Brendan Jackman <jackmanb@google.co=
m> wrote:
>
> This WARN forbids setting other flags than __GFP_ACCOUNT but we
> unconditionally set the ones in gfp_nolock so they are certainly fine
> for the caller to set.
>
> There are other GFP flags that are almost certainly fine to set here;
> Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL. But,
> nolock allocation is rather special, so be conservative to try and
> ensure we have a chance to think carefully before nontrivial new
> usecases arise.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradead.=
org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e31babe2181a1..074e007bf1bc3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5337,7 +5337,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp,=
 unsigned int order,
>                 return NULL;
>
>         if (alloc_flags & ALLOC_NOLOCK) {
> -               VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
> +               /* Certain other flags could be supported later if needed=
. */
> +               VM_WARN_ON_ONCE(gfp & ~(__GFP_ACCOUNT | gfp_nolock));
>                 if (!alloc_trylock_allowed())
>                         return NULL;
>                 gfp |=3D gfp_nolock;
>
> --
> 2.54.0
>

