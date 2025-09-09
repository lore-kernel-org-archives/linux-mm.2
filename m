Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD0ACA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 21:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951778E0003; Tue,  9 Sep 2025 17:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929518E0002; Tue,  9 Sep 2025 17:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F068E0003; Tue,  9 Sep 2025 17:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717458E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:29:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F9AE1DE51D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:29:40 +0000 (UTC)
X-FDA: 83871003720.22.EC264E4
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B597A0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:29:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GoBujIvk;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757453378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzshIuP25Lf/LgUwHvyQlavyLmps1lc6Uyl+gXnRofA=;
	b=SI+QpWQsXHEcNuDfjXs3VtEHZVTs4/WvLJZAwoG3g0JDHD39RD+Oqp2ibWe9jkvmkU4kbm
	eViyj5zki15L/Ge33UuL7iCvJo2d1SDWLbxvc5ude6grPjVuPCv4jkIOa+rDlHiqsS7Rrk
	TfA7epc2abU1Jso5ZEPfNQJHdxTNsSE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GoBujIvk;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757453378; a=rsa-sha256;
	cv=none;
	b=jyi3GSoOi5PQB+e+o252HsjpRwGxwJvoYUg1vR/oTCYFyZhzzqn4GAKSTh/KBGzEpd7ZAR
	8j1+OpTc3z2l0h1KO1Lfu4dXgdJ+eoVYgLjoo8GdI+zy5YbMmUl5OwCxdTE3zGj9nuJxsS
	Nh4LC5w69LXtU6fLiKpYd/3V04jT9q8=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so5072a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 14:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757453376; x=1758058176; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzshIuP25Lf/LgUwHvyQlavyLmps1lc6Uyl+gXnRofA=;
        b=GoBujIvkUcJYjkoceG1A2tSXOiTZ7yp4c4se9Qf14aFJFUdWIClxlbHRTczls7kvnp
         XPJOGNW/GC4wwlCyQNrdrhgntP+zxEzikwdxlx4fyMsu89QeaLuryxaiANBYmycDo83a
         c4ofXkPJqA7FY7v5mSILn5hSLdJvn1mYS628Hr92YZTs8bdZoHsb9jINMyiBaIV6vUrz
         qxa3tkolLhL94aAgbNexLpDs/S5KcZDo/AI8O+9hu0XujBpe9z5dH+tMFCBMmqEOGyPd
         UCH6v5ybJpM62TU1fnragMll94BYmSKFNisJEjBsjxuLtXNnRCzB41lDwSbJjOwdkyLS
         8Kfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757453376; x=1758058176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzshIuP25Lf/LgUwHvyQlavyLmps1lc6Uyl+gXnRofA=;
        b=pT4+MxglLq/Lhn+PGvi/RSlazYSkYB7ZOtM5XK47SwX/nQVTwYgtO0nsijcs9ssREH
         bo9hEACrki/UooMEKBHig+kuVufm/hWNGNqqs2EuhaicQc1DY7vSaFdGc3GTczZNXYGL
         JhwWO/Oju4En1wMXMfNRFDSQca1rJlNJ5UTaTT3TYtWfh8UuRpvDenz438+GYJpqZHcI
         DTM57ETZCA1fiIfgm+7d0E49xDJujfF/reV976JKLMA7seoNSHAxsevIV1hIDDHYtg2d
         21FwxjAX0xkbyQCaSPkXOW0tZtJhLPUK5lxqqBKsU1E4FSZNkY18JlWewjiZFOg6pLEM
         GWtg==
X-Forwarded-Encrypted: i=1; AJvYcCV58GwQAbmIYQRsaXapDvEOlxyNzNG+MfuxGqkBcS5FFlSDHsr94t5693pyQLyP8PZN75mbL0Pn3w==@kvack.org
X-Gm-Message-State: AOJu0YwFm0SvEjVil3XY/a21zyRDWdkG8I5z9TRQ204D4PbGjaO8AXmO
	x2bRVoVnjBzW9h3qq2TJR3PP6y5NK+83Drr4pxk0Ysl4aGRsywh4NJXc/O6dmiJ4CgK9yqIPi77
	C1ssLiNZhIDdvPscEjaP4yekSc5YZyzSJVqjrAaY9
X-Gm-Gg: ASbGncudumAbIqilHc5hTyINTTnLBegcL2PG2rN/CLvUFipWBh2nW1f4KzMNfGNKiqi
	gHWIBbeGC0V3z8s5Y0XSfXjXpYDsqVTdVC8O3wNL+qZmScTt5FJ56Aseg5NE19VQPE6jJhAESfs
	IQ4nMt8uWJ1I7BP2D6Vq9TdVcpdREDnxgRvbjFsSZg27rwX0NWlFqWEeMPj3RnwhbhEF1klvAq6
	LfC5vW1BpThNGbFb3Zz3Gx5Hml5QXcoDEKcULILTBP0
X-Google-Smtp-Source: AGHT+IG3Bk5jtrADtC8DToS6oiX6FI8o3Fb6PEL11mpb8Jwou6oOmQTziCZTSqNNrEujN8hDJXcpLR1UXiFaeVgmlUA=
X-Received: by 2002:aa7:d7cb:0:b0:61e:c6ae:7a58 with SMTP id
 4fb4d7f45d1cf-62d22df05d0mr26258a12.0.1757453376378; Tue, 09 Sep 2025
 14:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-6-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-6-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 14:29:23 -0700
X-Gm-Features: AS18NWCtVVHoJovdoA_YZXVgLcM8he286fzD9VywAnIKmyeEKVWRIu_7WPtm7FA
Message-ID: <CAJuCfpG6US+wPA7V5-0Dkho+BRs6uNUCYCV1GyRrbvpzC1N=sg@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] mm/vma: Add page table limit to unmap_region()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3B597A0006
X-Rspamd-Server: rspam05
X-Stat-Signature: pdy9zeau1bc5j6aynn9xpn596pjohek4
X-Rspam-User: 
X-HE-Tag: 1757453377-282352
X-HE-Meta: U2FsdGVkX1+V6RQyTvNKNDudrCAQfKLk8HE77GHgLDOEsiCu0XN2bXCpnoYvL5OKBRuOaz8xJRa++iIZkXQnaRbGbl1c9pekhwQuA5+6tBZ70ZIBnVN9r/Z7EJUKhWbn8qyOMGSfGrCqnbyvoXIjhpt7V8jnEE0ARP1m8ba8JsxsGvte9ADlfu/ErKgPXavDl7KanSgFsKRk2bH9aVAk3p2gTDYtRR9Tg23td8CSPsPVao9/X6FdHOdjPZCgU74raWTgoygIEPfM0NjwzlmdkiQaqBleLPDdmCFI/+WNWO/rqfh+mNZgabjk7Jkj5qJ1NCO6NJRtBCyVRVEDwGMyLXks8Aja3CSs9D/rrYM502zdOFBklpoURH0NXaGxNeSKiSmdFUYHAPPgPethQ50dwHNRBLkWGlq8k6gvdyyYQuHZgyhvKR4rw2AZG8Im3dYG3bxDZz2uFZVbWYY1pho5ChGPEfdBi0r2uinR0DZrJTWkp2c8U0yRuppwt2JhY+L8ghGG8NwmEyXsA/HgUavhDrhDZqgqa+Etu5IaQXGafQbN9o+fsy6VRuXAdPBB/mVezTjgdwsXJMvuKwKoiYENxEZKQPRn5+7dZ6J2Enw7NRTPrqqs/r4Lnr0p0VJd4yB6yo2MnNnU0BoBM5c4+7+5I2OlnC/2QMjVLEx0j/a+iCr8tizHLi1FQS3GEW9/h75Xfi1cFEjmQ6/BsvYnGId+7uLVOJoyQBPjJZXBSbz4vJacFXI6S55V/Po2A93wwjR2jPLXrYLh45tV24dm4Ir8N3siAiuQOzJ4lsIX9t3Z+aVPJo2zKhLG/GHidRYfsqt+ntEfT+sVhvDnR60uQxYUQd5Nbxz8tB4ZSJ/0qlICpZu7ho7LxWBX9vtGTthJGyWyp9AnU2W2AQoGQnFWgxgdk/zI+GC8mlV6AOJM0snCKOmYvpZKaJ/z9hvwF9i4YLylJPJwJzi4kaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:10=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> The unmap_region() calls need to pass through the page table limit for a
> future patch.
>
> No functional changes intended.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/vma.c | 5 +++--
>  mm/vma.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 1bae142bbc0f1..4c850ffd83a4b 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -474,7 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
>   * Called with the mm semaphore held.
>   */
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> -               unsigned long vma_min, unsigned long vma_max,
> +               unsigned long vma_min, unsigned long vma_max, unsigned lo=
ng pg_max,
>                 struct vm_area_struct *prev, struct vm_area_struct *next)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
> @@ -487,7 +487,7 @@ void unmap_region(struct ma_state *mas, struct vm_are=
a_struct *vma,
>         mas_set(mas, vma->vm_end);
>         free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_AD=
DRESS,
>                       next ? next->vm_start : USER_PGTABLES_CEILING,
> -                     next ? next->vm_start : USER_PGTABLES_CEILING,
> +                     pg_max,

Hmm. The free_pgtables() parameters were advertised as:

@floor: The lowest page table address
@ceiling: The highest page table address
@tree_max: The highest tree search address

but here tree_max=3Dpg_max. I would expect pg_max to mean "The highest
page table address", IOW we should have ceiling=3Dpg_max. Either the
order of the parameters is wrong here or the names are misleading.
I also think in the previous patch we should have renamed
free_pgtables() parameters to vma_min, vma_max and pg_max like here
for consistency and to avoid confusion.

>                       /* mm_wr_locked =3D */ true);
>         tlb_finish_mmu(&tlb);
>  }
> @@ -2420,6 +2420,7 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
>                 unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
> +                            map->next ? map->next->vm_start : USER_PGTAB=
LES_CEILING,
>                              map->prev, map->next);
>
>                 return error;
> diff --git a/mm/vma.h b/mm/vma.h
> index a9d0cef684ddb..b0ebc81d5862e 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -261,7 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm=
_struct *mm,
>  void remove_vma(struct vm_area_struct *vma);
>
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> -               unsigned long min, unsigned long max,
> +               unsigned long min, unsigned long max, unsigned long pg_ma=
x,
>                 struct vm_area_struct *prev, struct vm_area_struct *next)=
;
>
>  /* We are about to modify the VMA's flags. */
> --
> 2.47.2
>

