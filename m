Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19F82CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B668E000A; Tue,  9 Sep 2025 16:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB9E8E0001; Tue,  9 Sep 2025 16:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA378E000A; Tue,  9 Sep 2025 16:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30C058E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:10:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD52A1A0632
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:10:04 +0000 (UTC)
X-FDA: 83870803128.18.DBD3421
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id F3EFA180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:10:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MQcs0CyE;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6moEsQrMOvaJDyHg83dzxwUYK12SAvE5EtoliwNDps=;
	b=Uh9w7CqAFjzbntjrQBTaDETiGVpEwz76rg4mha/jU6Kxs4PWmSgfkPOWhdjdhT9gDounLB
	YtKdDA7nBZn/o/LFVGRvmR/JlI0BE4PulTlo+aXbeG4jBSC10ySH/qtyxi2+2d06PIl9zY
	R+ThuKlCL9C5/xv4x8aLybTRwbVs74g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448603; a=rsa-sha256;
	cv=none;
	b=y816risayM7K/9G+jzvKkMQ71zhuSYI1Wsmf/jLCUXKaNLcb9wBU7C2itHqVU9XhngD9YK
	94ghf20JX4SBWkj9GZ2FFw/v8kai85N9a07gGJ9ZUPipie2IdbyK52tTpFLmd1+/ot+Kt5
	uq++AHf3xqPRA+0c7/x02MLWPbymv6o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MQcs0CyE;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so111811cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 13:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757448602; x=1758053402; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6moEsQrMOvaJDyHg83dzxwUYK12SAvE5EtoliwNDps=;
        b=MQcs0CyEh8osRH91KO62SDU4ecvDXJ8Vi5yUhqsBUGWHQUmtrAsv4so5FPljz2UNDj
         PIIIgxvNtMkMxM768Zb9u10FsE1mczBs9pSl/Ka80fkMjWFBSzkTFKWrff1UPxLGQ/DD
         mbkkqVKHt3dL+rW1x9niyzuozbLi9H9nuSRXlKBKQA9ubOHGSQTvnf/0YcR/N+mr8Pt5
         RbBXyIYPOewOfmQGnDvegekTgfvTBqIqKsu6m4V/73aOCbpL32S1Ls87PItfIki7ymRS
         bFOZCkUSzsY50GtKwxFPUBqQEW4qkcs18roDd72JuiQbIZXvdIElk3urWXn6SuW2mAYl
         4P0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757448602; x=1758053402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t6moEsQrMOvaJDyHg83dzxwUYK12SAvE5EtoliwNDps=;
        b=RC2Korkasx6CInhc7uOWvEPLRWAsYK0uc08XesQ93G9tny7Rtbk7haxhLiz3p61GO+
         Hja5ACB3xtl/w7zbTqv997oBfne/4hfuCz0iNvig/GKJskgZI8TAMZAf4Iegf710Ss4I
         UVoDZyb3xPibjniyhaFng4jK3CuAZ0aJVT3+2uwk3FCij7EpIIkjPKAGhhsG67DHyLvZ
         bg/jXjgm72AeVKIhVzoD4FnbuRRgLYYpXDtXNk+MQm/0VMHQTwZFSghIc1bBkui9q1My
         XKMUguNw85Y0w0wmWKYCIzbFs7ExmLI1eBX04HsbumHGBXpuQzqR/gidO6jJXQGXmoVl
         09YQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJZQWUpm97vCeO9YFSrXk28AUdbgOOvjKnk0x6AP0E1wF4KIp4SesUKm7F4NJGYfgREW95LoFeww==@kvack.org
X-Gm-Message-State: AOJu0YysQ5BhYKQk5Cg2UMQ2u82q2oZJD/yA0QupgusnR2OJZDc85DDe
	6XwZJKtrrZWA4w5hTLdazJfHDhwgwf7OpiCz6y/67F0hY8SSkgC+/glfOJ7wqwu9kBTvNPsD8X4
	iAaDXTRMu+w0P1GEasWZ8QV+4QPml3GSMO7sR8Bab
X-Gm-Gg: ASbGncu2x1zMA27uNHyuhu3wRASM+UgCsmJvIaWdsrxTWKZ1xUclfEKlQS0g/atZdcZ
	WKW01wx+YQTqZMLiwNkg4GB12FxECl6rydHaoUh4zC/vbK10R36f2XFktmhS7f6eOZ0HxYH6oJf
	+gLA+EZIzcy/AD6R7bWuX6fEVX4GYXdsmLX4c3stAHcB+BihIOBl4JK4vd2696lij1QBtCZ0vSV
	v6tms6RhfVJqZcG3AKsxCTG6jkMwg4RQ1K3HEtUZeU78/3qHt05xCc=
X-Google-Smtp-Source: AGHT+IHnHLlgpvqGEl14YzylQSH61T6ExMaMJwPOn7axIYhzTaqY2adH/yufFSZhoXIEb2CxQVDlO/GRoeTM7lDQUWE=
X-Received: by 2002:a05:622a:14c:b0:4b4:9863:5d76 with SMTP id
 d75a77b69052e-4b6252075bbmr949291cf.8.1757448601620; Tue, 09 Sep 2025
 13:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-4-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-4-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 13:09:50 -0700
X-Gm-Features: AS18NWCLA-Laybgj0BVgoTc0VsNcV6DuM6nWCtOdabz2PeHFWlEO9xtiR7vwsbA
Message-ID: <CAJuCfpGSX3VMnFH3u67mKZTe1pXOYXoFc92XiU+TVjPs==5mcA@mail.gmail.com>
Subject: Re: [PATCH v1 3/9] mm/vma: Add limits to unmap_region() for vmas
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
X-Stat-Signature: cfrbhttof3asmgdudd8jwgbfhdoe4a93
X-Rspam-User: 
X-Rspamd-Queue-Id: F3EFA180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757448602-12053
X-HE-Meta: U2FsdGVkX19YtPY5ahhFSxzkST8pfISgSgliGJ7HYkjXlXwkZFPscr5xDSDSf3w3cQhZ4OqvUFcHo4c/yk9NCx0r/NMdjgFvpQHIWCaZ9rrYsmMtkajmOl7bZLQoRafLacEsTsKIRsRmHohj6Q/1orFn1Xy1m1roxn8c7p3lyBCJMXPiYLXYlVk4i8v1ZgcMtzr6i4Xi8JGPEw3/FlcU4Toey7dyjKtpSQRNoc700miKg5NLGiV7ulotFPbQo0ShLothAJWau3Fcymj/hzxlHPnKMkzv5w3cR3BDS+L5vJVf2IqtemSbY/LqoeAtmT0N+XXskg/SwK2GzGD54dP9uL6/wnD7aXJ+axmXNFTJocnx9rnTKateLaEnV5F14rZ7NqPbkbnFpburbeErujmXUFnRcc4KpmSrNE3cE2WtneeWNkCoqhZxXaA8+UtbBOUOibJHsZKxAwz0sLYIvmsENq9un7AYCYMlV4ymafvLDt5Otnwb0DOGvj8DiCZo1UGO4Gs0cxW4LPvyTYP0RytNyodU/O2BjjDAzcII3KgWNt2QvDiLNkhzkk8Z/MTH8XQuJn8MdJxScQ/CgoAkEWcIO0J8MnmoVafWtyeZMe/ScBsG5KtUMLqpVwvTMDu5Lxm9rA3cNVt3UdAViAJ13xakLbQMEJCfI22BQ+Skatbf3I3e/r3fihzKhTNwih2YuHpVHXUfXaefC6935ZQUR7JhKc2slHXpW7nUP2YZtz2On0+G/fU9F0z8PsKMinPiMdR1zYBcH5j2SlUjA59VLdlGZQ9ogYrQENZPaVv0Ufho9h6xRJ1pBs1jeCiN+WJ+xt6T2a4sHAuRpqkCKaq89P2gQ/RvK+vZhHHlqIFyb5GU0ndX1L6T8RJo1cdPekRLIl/YTxPSvX+60qxlSLG8qOGWaYsb/SnW2wSrpqGKMc2OhhsbjUWu7SvM1orX3LRsGl2+THFPyrfdeQY/Jyxjtik
 usFVO60w
 HYf0XYd+3qBkFmKvQ6PEHNWD8zyZTsppCW7ZRCcn2djPyDgYHIoTvBNCXP8FdWEets9In2SGtkPPGsf7jZK5RsVLpL9lgXp0qnwuBsw3CIoyTNACGnHm51p2A6VgQcumW1PUcjwDIn9ks3NHfvkgO9USVxww4OFAOWvfo5GRp9w8L9r7RcLX6CJbs21jsAy1Z5SpFoDrfGSMaE6SHTdCy1+0Qt1cbDXQdZdq6f7nVT9J+DtSrxKCTaflZZz+l3gkUXb9GOSBLUJlb56JqBTKh1UQc4A1jGizwotLKzDiXnbUyPCbF18UTBecyHBdPLNz8iy8J
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
> Add a limit to the vma search instead of using the start and end of the
> one passed in.

Would be good to explain why this is needed. I'm sure I'll find the
answer in the later patches though.


>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 6 ++++--
>  mm/vma.h | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index abe0da33c8446..a648e0555c873 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
>   * Called with the mm semaphore held.
>   */
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +               unsigned long vma_min, unsigned long vma_max,
>                 struct vm_area_struct *prev, struct vm_area_struct *next)
>  {
>         struct mm_struct *mm =3D vma->vm_mm;
> @@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_are=
a_struct *vma,
>
>         tlb_gather_mmu(&tlb, mm);
>         update_hiwater_rss(mm);
> -       unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_en=
d,
> +       unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
>                    /* mm_wr_locked =3D */ true);
>         mas_set(mas, vma->vm_end);
>         free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_AD=
DRESS,
> @@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state *m=
ap,
>
>                 vma_iter_set(vmi, vma->vm_end);
>                 /* Undo any partial mapping done by a device driver. */
> -               unmap_region(&vmi->mas, vma, map->prev, map->next);
> +               unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
> +                            map->prev, map->next);
>
>                 return error;
>         }
> diff --git a/mm/vma.h b/mm/vma.h
> index 9183fe5490090..a9d0cef684ddb 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -261,6 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm=
_struct *mm,
>  void remove_vma(struct vm_area_struct *vma);
>
>  void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> +               unsigned long min, unsigned long max,
>                 struct vm_area_struct *prev, struct vm_area_struct *next)=
;
>
>  /* We are about to modify the VMA's flags. */
> --
> 2.47.2
>

