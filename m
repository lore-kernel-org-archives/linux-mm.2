Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC802EE4999
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 19:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA576B0088; Tue, 30 Dec 2025 14:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3947E6B0089; Tue, 30 Dec 2025 14:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297446B008A; Tue, 30 Dec 2025 14:50:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A33D6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:50:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C064213A3E4
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:50:48 +0000 (UTC)
X-FDA: 84277180176.06.F062778
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id C01D980008
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:50:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pQZps75D;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767124246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU0dvOJy1s4p1s5ON6BETu9CliPlU/FD1RY1WBFa4II=;
	b=IMpNTvfkaXIRcNblVJ9aH5CQaPsyXZkgOlVcudqWltfIAW/mAenv4oaW2Ns0HcrRrWGbDu
	iQMek3o2+t78zaQN7G2WwjTPcrYrRbi8RXKV8ZERYR7OdiYulxgAEEyqgYlljqiJKODKtT
	0kYvGLMPT8xzIF2qFDGKi6Ib9NG9bLM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767124246; a=rsa-sha256;
	cv=pass;
	b=VVUjvK31eiVfhhoRlmYmw57z6TlvEEY44kVv1aolo51tr8xmc/GtyDuQDVrOgNBFRscIHm
	U6DrS+CsHjtWyl6mdICDMxmgZ/hEmQgj2m2mZDzRzehl5njwyEyaGJttQB8V0goOYjfBxg
	+l7u/RcQz2kx7BeAz9zbk+GMYyJpEI0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pQZps75D;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee243b98caso32791cf.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:50:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767124246; cv=none;
        d=google.com; s=arc-20240605;
        b=JV6kzya7LOgXGNTBZcD8Mu0YT8aH03zIBHM86sPvCqot0Bp4ElD47YaUlZo4LeU9lE
         /pAElQNutp5DnBZC2F+ksp7RB/LpSRcdad5uDPmAXXnx6FSo/Fwf0C/PKynvL4VvaIc+
         FJ1WdUR+hrn09wY+HmwCrgygp2flWhX3tt6/BMz2eYOeka8uiDKaIhyywB7zN3lcnSIA
         aJH6iKYRNG/8+FnKm9xe61g6bJJ97nmskq0VrhF+hCud0HmNt3v05Xj2Z3yfq5SbPgws
         XORWXUlZonbognkAU1jUyNaEs8vUTd2HsjK5oQVY5DGJXHm9FQEfxfbPDuKxmJF9M5u5
         JpeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mU0dvOJy1s4p1s5ON6BETu9CliPlU/FD1RY1WBFa4II=;
        fh=q4ntysiekT4V+Ej7s8ZPAQuFmjQEzswS23VCGZWDA28=;
        b=ADwYsk0qswADxWdwx7RJ3qnvCrGCz547IQ6FSWdPUbmmqo7FbeLYPhgMAJ221YTbRR
         /XKKgqVHlTkskoNJB8h/DWeuks9R7e+7PODzrxsfrlDlBCn7X+omAdz77J1C9PJ3W31l
         i7s/BwEfCs8jaylFp3Wog1hnvmujx7C/WwdZLMB1XPbsAGl6omx53kLsesg3DWQXmSnY
         a4ABOenBfmJS19VQ5/gIArBx3FaI+k0lDtX2vM+pO+k3XTFdBwZJnAx9DDAtWBfqTQRA
         TMmjBqg4uNLAgrT34DV1LG7nl3ZugLUrsfQk9QPdFp3FcpaL1QszS9aobMInicbqEf33
         50Og==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767124246; x=1767729046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mU0dvOJy1s4p1s5ON6BETu9CliPlU/FD1RY1WBFa4II=;
        b=pQZps75D1DSBSaLMC4cmxovzlW15z+IsTLZM6WCwG/7EG2WXFvqZAAQqbA8ex22+Jd
         pN3f0JJrL1o5oEb779LmWCVSjHqkMo7LnlmeklmC9BUPSrP0OJL3YUrJcSXDIonKPjZk
         TqA+eQqSh2C4d6zqeG1K8uC9JsCHh9DFIpEMTcB7rT6zDHuRSIHoaGFjqrAocNZW47TJ
         s6kgpavZZuSukkDrjZttJHlDANCVUFuSPz6yQxFtXypvwpPErzl0Z0SQs+YaiF4V6uiA
         AjiaUZkk7Y0THFQkmoCNKlg13EGTC3WhtQTvDRrjYT6vMkO9vEPDuJfBeCUo1vydBKiQ
         7nvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767124246; x=1767729046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mU0dvOJy1s4p1s5ON6BETu9CliPlU/FD1RY1WBFa4II=;
        b=rNJjdB/ExrphvCXP2wJI0V/0YeHjWT0ZrtkUnAXJ9ZE91n0fvYw56fttr70noO4Juk
         uNgpYfg59Au8HoGJLugYhGaDAC/rapIWnBq2HTGAEu83s4IjQxFv4gjUdfvy2a8MJdDs
         MDlD/7B8OhNRCSudFOuDHjq6MXXu70pASDXiUARfL9gO0/ngZilnJ+tpSxesSZBlsIBw
         wz4FkxlgisBgAzy+9/j2ENrf+qbv1t8bMi2HqkiVwEKFFp6+Tj+zpGNY/ikkLqnt1wU2
         ByLNdBlcUyYAwTd1BpYUzYEH5ge73YxinV5ZtbAXlto3Cmo0zBVxWDY1SQRREELW5gvv
         Dh2w==
X-Forwarded-Encrypted: i=1; AJvYcCXJ1iclys2M1kAmWH/RtMpSHDzZL/iTi444W1GNybBlb3YgLEumdlBHW3CnMv73tmZw5kzMXyvP4g==@kvack.org
X-Gm-Message-State: AOJu0YyMZOgG/uW+fY4pPf5uJiFPhEy8CBn+EsBUXvE0UbnFls5HteUa
	6etdTMKFbCyKTTQksHW1fJPUh1cGTbVxXXSbwQyc9ngFhA8bSVm73uH2ekajOJ3aTgeeW/r7Q5J
	22zhsA5C1dgXFR2Cz0cTEjiAhCq5tHmtRVhwh25Wz
X-Gm-Gg: AY/fxX5qbJOHgblylfeiWX4rpyFUZATOOrdezeRpRUUKNpj1ZPotI3ZC+0iWslLly8b
	508I+F6lLgeL2WHBi/zHCzvlW893bYli2q26IuK2fNZ7wjI6Onhg3BFpoTZ/Y3dMk5vN7kqYkJJ
	3bmoz4Wi2wVnh8gUVjFr4OqwSjqKASTQ8sy2IVSFIBYS9juHcujSt4zvPnwpfyd4qu8U7TkQiMb
	wXUmcFW9M8PB7fP39pUtdRzZj8whYIVd389CNk+DhXi5dqOwVvDDfJTMNedFcbaKbwHzk8V3p/p
	ZEtjF8FPHkJKY7aEA+dEQ1xYwIc4SjkdnM1y
X-Google-Smtp-Source: AGHT+IHRYPgKvRztM6n8rO8cOVTiE720Du1IeDCA3YUPor5YUNjwNYwqgnCrnK7P6wP3jpC9vqTsaUZcGaOSi4gR0H4=
X-Received: by 2002:ac8:7f8c:0:b0:4ed:18ef:4060 with SMTP id
 d75a77b69052e-4fbb3ba1a00mr1518361cf.8.1767124245556; Tue, 30 Dec 2025
 11:50:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com> <d3d98a5fe9ecd0b17acfc359d0c92b9e929cf34c.1765970117.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <d3d98a5fe9ecd0b17acfc359d0c92b9e929cf34c.1765970117.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Dec 2025 11:50:34 -0800
X-Gm-Features: AQt7F2rHRS6rqWuHla8VYDGoV9dSY--r1_wddPvgtwAdA6fFSSn0VSUpfgOL4L4
Message-ID: <CAJuCfpHuv44yisSaaiv6F4MnVYvOdRyjSfsXZkwvWYmKvZ3VhQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/mmap_lock: add vma_is_attached() helper
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8wm4dm78yifhruj9i8jyodskbb36qw4r
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C01D980008
X-Rspam-User: 
X-HE-Tag: 1767124246-128263
X-HE-Meta: U2FsdGVkX1+oyjU0YBLVzYXraCNLWHXclzOwh9gD/Z9hB40DK+A1D/D1VS3o5aLXP8eYlbwUJTv4cSaQy5GM/emMuKCk2KomBAJJ9f9My/pdULjmWToJXwgzqka1T4s3iSrHyBxaOgak6OENHQn8TjVPQD2+hswmI8gt+F+iczIQ1S8xsq3f/ZAZpqsjZKOVyI8i7SWSpSgXt4mTWpytRYRx64lHiEs1agoArC4K9/phcsia+G5II4irRvfFdg98/Ne1lfvkCAcGTsKwswNGVUojclCX/aNOG7eYouOslMjyi0Dx4+Ybl4NOJ6a18sl2f3fVTFd51Vv+zNOvebV6FlbSoBBIzgEYbQwIAY/1wV4Emkfj2g8RScIeK0pqYEnvXus6ot9QAL3pkOEPPGAbU0f1rifPI5WKhQiqSWAHlzLhgbG3ScjWZMXlmxKoqV1NOuASiFK2bfFuRahjYcDDi1jgfvNWZep3tX70BaPOTk/qB0rRtTeJDZraMUZWf2/qJ2xb4n47wOKuxwC9ONpxRta81bwsTMgjY9Ud4FPgd/VDpAoP+QQ8U8ybrIwBmoeV/uisKchiQkvDB+WioWyOBn7yFE6IXRpBWYLW+015nBJxfpPaS1TzKDRt7blS1rG1p5dkZYYeMmCpZKEIPtvHprOwU0tN8nDLkjput5cIOduSnKV0t2y7fBv28khvenr9ZywtLu7vzpYQIXYr4s+R+noHP7eY+Pwc/dFgWCtoOS/n2UEetyQkiRscyJYx8boXYz5yTuxQyk8laJRNjttrN0FS+NuJTU6LNrtGYezh7F49uY/fJzWkxlLwyxEjM2NCcyZiTagaPGNJNp1W6BQbNDyuX2WFfWTJasePUSHFjL3een8j0g0G3RgDdWEVs1VKAL9nu86Qpi5f5MriFnccsH6gaRL9ir64D9RE4OzEIxWxu16Bdnsrz7j28f/l+/bsEkhM3Q1T/WTVHOwhcAr
 juRHRqq2
 2jcjbdGWqu9TkmkNDk2yRyyds6nsYVZEEJ6LUy/VANc8CbWq8UXJf26WnNbJEW3Z43hQIIWIL3TuYzYdv+K6BpyYWeVf+CEbhOH0rE8/TkFxkQ6PWCLnqEpVhhUQDnm7bSW8KAXZhhC8GL7zygEBSLCzvmwNv/AMF7vKbDFTxFmtYi+NRf8Cr9wAYKRKwA7SwQfdgQGJQsXwY60grC8NqOkdRn0rB+74ixpFdqo9yY6qjTaOJVvOmXDXzoAJLEFd895hZ8bIs/yi5EUcGx1SSpIBygwOhflpbJDGe4GXOhNYkEaB3EZ/xfdze6zFqbMEO8LYg8vJCsS0t3+dY/6uRVfnSAsl+jc6nP/Cjeb3YbK1ZpUo=
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
> This makes it easy to explicitly check for VMA detachment, which is usefu=
l
> for things like asserts.
>
> Note that we intentionally do not allow this function to be available
> should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
> and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
> no correct state for vma_is_attached() to be in if this configuration
> option is not specified.
>
> Therefore users elsewhere must invoke this function only after checking f=
or
> CONFIG_PER_VMA_LOCK.
>
> We rework the assert functions to utilise this.

Thank you! This nicely documents vm_refcnt attached state. Another
step in this direction is adding:

static inline bool vma_is_read_locked(struct vm_area_struct *vma)
{
        return refcount_read(&vma->vm_refcnt) > 1;
}

and changing vma_assert_locked() to use it.
But I can do that in a separate patch, so LGTM.

>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index d53f72dba7fe..b50416fbba20 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -251,6 +251,11 @@ static inline void vma_assert_locked(struct vm_area_=
struct *vma)
>                       !__is_vma_write_locked(vma, &mm_lock_seq), vma);
>  }
>
> +static inline bool vma_is_attached(struct vm_area_struct *vma)
> +{
> +       return refcount_read(&vma->vm_refcnt);
> +}
> +
>  /*
>   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached()=
, these
>   * assertions should be made either under mmap_write_lock or when the ob=
ject
> @@ -258,12 +263,12 @@ static inline void vma_assert_locked(struct vm_area=
_struct *vma)
>   */
>  static inline void vma_assert_attached(struct vm_area_struct *vma)
>  {
> -       WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
> +       WARN_ON_ONCE(!vma_is_attached(vma));
>  }
>
>  static inline void vma_assert_detached(struct vm_area_struct *vma)
>  {
> -       WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
> +       WARN_ON_ONCE(vma_is_attached(vma));
>  }
>
>  static inline void vma_mark_attached(struct vm_area_struct *vma)
> --
> 2.52.0

