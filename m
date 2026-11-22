Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40DE606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AJZb3O4G
Received: by kanga.kvack.org (Postfix)
	id A102B6B05B3; Sat, 21 Nov 2026 22:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0AA6B05B4; Sat, 21 Nov 2026 22:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864DB6B05B5; Sat, 21 Nov 2026 22:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8DC6B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:37:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A26241A02F9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:37:15 +0000 (UTC)
X-FDA: 85461344430.13.701A1A9
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5D0D100007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:37:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AJZb3O4G;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795318633;
	b=QBeKrO3Bj5+lGDQXt6St426QSD4gU1I3RBYq460w9UzYZOwtT58pk382xHj8cf0wlhQNTi
	sGDN9wO7L9GDThovQX49u+JtV8y9ybBgNaIc4kbEK5UPOrQSCYU8P08AtQDhRTkSkgZRg2
	s1/bL/cO9xKcUeg5ooek/eV+vMl4Pn8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795318633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LfQyaKPdDmtAwB9hpMWlkNP+E6RdLGt5t+eKHjqhEM=;
	b=tSbu5QiRWAxupiZ64RWJo9ndsti8K49jmtiwhy7XaR9RzsknGeCkaQNd3SRYhqwaByWjzJ
	p3dsMGk/ahJFdzVKwKw+9AXlw5HcbwEXSuLQ1iXcwiDTLDShccOn7wJDLl/pPWCQkZPajc
	ky0giLtMR9mWZRTQUVti2F/TYLct5+s=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AJZb3O4G;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-54492d8a988so215321cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:37:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795318633; cv=none;
        d=google.com; s=arc-20260327;
        b=pd13/7QLTs96JIDxngRrp8pW/7a5fHHjiB0+hTGpzam0tIQguA5zK0I0tMrzGEqRkK
         AhriQHAP9Rc1fDR3joV6g9KoL3Fgy5f/vHnDZouSp5GgMejrnZ51Kba0eBLbbDEhK1Q4
         LSqv3IeURmGqTUeB7kAH0yv1Z2jrLgY3O6Sbhnd8GG6x4U6wSoMzgcniM6WxGccvvo2m
         zKHGNrSqGIxU7vOXyAiYNmyq3jUG6Kq2z4vhTD56iuSeGMF1jC9cLFdkY0d8hrRoUFMN
         e4GOV3/Y1Wvtc9siM5ANWyxzrCZ2aOD1iaMtoz5GAcK7H9gSzvuWKUdBNyKMs0CiIJa8
         JIgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2LfQyaKPdDmtAwB9hpMWlkNP+E6RdLGt5t+eKHjqhEM=;
        fh=rEcovH3l8VxGoVouXvJDawLXVo4CpTwMZH5T4Nzj7cc=;
        b=WNkQpnTVMBgEU47NkFfjH2VOGuehOKbeeJjvN8fxdlt/W4/LyQ246d4KPpIj1J8Ym3
         7rap5GiFwH7OM6J0vOGg9fulvIK3f57NX/7j55IUr8cI8tL4Nr54XqQaPGrOCUJKF/kx
         pfO6o04QdZQjjx0kblHcAOKBuKg/FG5UJTEcjLqnQztDdm2d2S8PlsEXCo8y7POcrogY
         M7JhkJ8AHJL56whZdXTHKOCutXzygHaRnWTY2HX9Ajf+uRvgQjTh9Pa/zaIc1cA52FEC
         KWBSP8whrsrpxeUyW5SnTRj8WVAu/GftUTTfh+zhGGd5ZkFAP6fd4yti4xHo2Hg4Cj69
         Sj1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795318633; x=1795923433; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2LfQyaKPdDmtAwB9hpMWlkNP+E6RdLGt5t+eKHjqhEM=;
        b=AJZb3O4GkZv8CkcjcAqNjDpL4VxDZcv+1V+UbFDsTKEnvtDHZ8HgG3pP6MxRzUEITA
         UJSVu8A5EOkcbbV4E2uPJPlQhc6XobKtI480i03EMBW31kMmb+9lAxyOdKkqY/0TL6Uc
         CmWLusO/cMf51aADoNkMhq7UF9jwSj1/4fKi8t8NSldh8jjlP8ZrzvHi7uKjTOxe4xXd
         dJIVPaFBGmtIcSAfHi03kzuPDElQImHQe0kkm0b71h40QutVcGXEWSot8b6yeBQj5xtm
         MYZq2lm3D9Gn2AZQtcsUbshRsdC+qeEZB/PPmNY0Zpen1CT8B4yOKi1AYu8bZDAj7T5m
         iYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795318633; x=1795923433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2LfQyaKPdDmtAwB9hpMWlkNP+E6RdLGt5t+eKHjqhEM=;
        b=xT+x1MAPy9RecGFWsMh+DxWOtdcnmP/Rn72lGcSNopQKqEseIX44Fho2HlNpblSqtc
         3xeUsvPKlPZFtFzuVvsfKLr5MkTaFcRC/aK3Xlok+QlPXefUXDuBXAPxAyTIJ1G7hwyJ
         XNqdT8pGHEL4+188yKRvT2FUWHlu53SyVRgQtgFLXS4Qy6kxt31sO8FFFg17i54hMnK9
         oGjVNp1O05j0j5L8hsqEeqPwztr1lX6wz0ItvG5m8dcAgBqlHr10ckj3/VR8y8xIpcb2
         N2bcZ+jw3esgJOolmMWqdy9DAlVK32YhMA0I74qncPsGxZKYhKSYhf5D8psHfGZbAu4f
         Ho+Q==
X-Forwarded-Encrypted: i=1; AL+hErH0zz2TO24IHRIC/kieGTbTPtppb+1HaR+QECLQL8wj3hjtNP1CFqnNPP4pymKSEyFmedUjoHBs9w==@kvack.org
X-Gm-Message-State: APuU4Z+12/rCJ95e5Ia/0a9nMtcb7BCqk7rD6HaxMiClA7PRNCRYP1/H
	9lrdzEaok8QFO++db2KFPyGUSBIimcP1+tMET4HAsjovvCFvaHMk8l+kl8kKONBf2JPwpZrmpjQ
	knhylh1Kphksl6F18BC/76q4+h+2D5UZptq/snkbG
X-Gm-Gg: AZFdTZcpyfy/tF8gO1telpSkAOmSr6l/LZ13Eto0BvHTFaNq/cd02SpmH3ynyFyjwzs
	vNd0/quM2/QXhHH1kObAemQ3keUCrsHqHhitnGIW8Pxuot5KARZfe9i/71sIK+qM8BmO8HJbZjs
	lqtI5e0Fiwn/pEAlh/KC8MvzYbqMjO6Kz1jN7qqXMnhLfvFpY+rubodAdb9NiKGpoZTSXrmFFvi
	n6FEP15w/yMJoV5Qgv3POQaY267wBztpv9KNEiCl94RplNSa9A2aIXqCHEIq+ptM5UUrmbuGAgR
	K5kMoilD6kWqvU/LiCsM/czJjcqWunn08Vrka87iXZAvSShZ80d+y8jxKE8wDYN5HWET3CdB8YX
	LfcVxnF0t5lHpSzQCtsGSPw3dm9rZbFv1NH9uvhwaoIr6sD6eaZ8F64ILPyE2/nduIKHtF3Jxom
	u9vZlOCAn8L7SnGhQE
X-Received: by 2002:a05:622a:544d:b0:535:ce3:ee07 with SMTP id
 d75a77b69052e-55d89061678mr17270921cf.13.1795318632302; Sat, 21 Nov 2026
 19:37:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:37:01 -0800
X-Gm-Features: Aa3M54qOE2eAiS_4WrdIE1htjEWK1zJnqa2hRoPrBF_s_15MhPGp5CEUFjZBJkM
Message-ID: <CAJuCfpHAw6GJuMrbHZG37u3mPx7MZ-DkryQXQBf=F+aNcX4Y8w@mail.gmail.com>
Subject: Re: [PATCH 5/7] mm/mremap: apply the mmap() offset limits on expansion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a8iho7ozbqth4fi84ihii9y4cfa878sd
X-Rspamd-Queue-Id: B5D0D100007
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795318633-713027
X-HE-Meta: U2FsdGVkX18I1Xn7kXpYXWPhAqKrQ5KhpDtYnYd6EX+12RK9a5PSp0MqecL4Wp5QLdp11Ely6SHpwEROliCvF85UL/h24QcbwFyxrQCvF4Up6D8Hix+ZhtIWAYFT23j+dOuyJhqfOtLwyLclYfPr6lV70j++AwA+okEVuktetwmgpLOl7mmifkici0Dbeldig2tOYX807WwTvbr5FKm2Lj+zZ1MltZ2NArpksQ9n2pUNog4g1nwfN7FcAV9jD40/4FeviJagDMwFlAQq6zDgfACT1GtnW2wPczioJKJpCleoEnh6cWVO65vdXDsgSbnJ+gzGb9LgHsKECkmiVxrDscuC0XAqFsF3Wt0nDy7Dh4hEEWyKX4rWQevBlJK0RUzFc8xXHJqllmu4nzu6zmaxIXql9hbOqfVCt6zlE9uTewkw/PKGqaVloprEci5eI+erM4IwgSmTClRCDZRxcY5Yc6MLrME1+lKhKRJtI67tkZBDWtOCHcaiO6V/+rHI2SwKdbmC7VF+gTE5P9EgnMt9Ojbw3uJCO/DDby2MYKn7ejyQwxPamd4I7QhCtQVhLvNaVd1WCXhaEpWxVofxa7o25vx8R8NDcumGX5nwC9WDhbJuXuRwvk2xdS3ExmK2P16J/3HoiJycd1l7+mPdnHYf5KZfWx7e1QaHXIq6FKzXsFXocfo19Ns06nhgA35vumBifheCebMR9SADAk4b5NKjOLRApYe/4csKGJmeeNEUtMbonINCucIBV2zmejH4JU/x/725oYWfVxCdIonTeAWBvE8PL8cw5t+fm5pui1hkoXom7PSOjT1/zr7FaS2sDur7/qUUV0RB/LByhpNJbaoDLqjY2btZ4lne7im1fEGwN6C04Yr5U9MFipxRCJwLx0GseDolNjz9HOIVeFPDsbRJ3XsNiT2ujRSg1gXiiAKRWJ2mTTTr59+Cnl/5UE8BspVroTWendDhnBPz2IQP0GT
 PhNKk99T
 CUKHQsBZEhLAgA2Um4n4XZQnW9XuMHpZpw+SrLYBYA2wpgzW2Fe3hrh5+zyCLdfM7jl7ziLyRurwXTfRTa7i+p0soT43K9ji++WkPizoN8w3fpSomwQk/f5y7XxQM3Lp6/6MoFnivzY2BWUShmigh4/xMbZvr5xaEhmpeLW7sT5EQMjKinSx8/3TblxR2SoOAKV0ky/oqXK0aJHWwXmVQZJlfuQgiwQ7QJ0NFHM4oWy2hdHwFNkiCm9dUNaajFpKXSVJ9VZRlLE8dVTRAJrsy0ePWCkH5akMtJdUAnze+CThzfsSxr9SzJfLY8Q+lEN3K0HCO1bap8Gtu5HtrGvZZvHIvtUiojQ41JZNHIdEtnfkAxqQpC9fvQlJ8pZP/LG+tGM+sjVwoUo0qwWoNI/HmS+VwqsGC46A7ikdgGKCbrNIriVn8lbVtMlhrjMlhBVu/tmwqwfczVCvEbRZpQJgbTixZ3gwRp0aDINYszQSnMxsZnEd5Gd5rwG189sXJxEIjarHB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> From: Chris Mason <mason@kernel.org>
>
> Commit be83bbf80682 ("mmap: introduce sane default mmap limits") made
> do_mmap() reject file mappings which extend beyond the maximum offset the
> file can support, via file_mmap_ok().
>
> However mremap() can expand a file mapping and only checks that the page
> offset does not wrap, so a mapping can be grown past the limit that mmap(=
)
> would have enforced.
>
> Fault handlers rely on that limit. For instance dax_iomap_pte_fault()
> converts vmf->pgoff into a loff_t, which overflows for such an offset and
> defeats its i_size check.
>
> Fix the issue by applying file_mmap_ok() to the expanded range in
> check_prep_vma(), failing the mremap() with -EINVAL if it exceeds the
> limit.
>
> This means that mremap() now refuses expansions it previously permitted,
> however no file can have data at these offsets, and mmap() already refuse=
s
> the equivalent mapping.
>
> Fixes: be83bbf80682 ("mmap: introduce sane default mmap limits")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: fixed up commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/internal.h | 2 ++
>  mm/mmap.c     | 4 ++--
>  mm/mremap.c   | 6 ++++++
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index a09dbdfd615d..aa7fba0a1c41 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -941,6 +941,8 @@ extern long faultin_page_range(struct mm_struct *mm, =
unsigned long start,
>                 unsigned long end, bool write, int *locked);
>  bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
>                 unsigned long bytes);
> +bool file_mmap_ok(struct file *file, struct inode *inode, unsigned long =
pgoff,
> +                 unsigned long len);
>
>  /*
>   * NOTE: This function can't tell whether the folio is "fully mapped" in=
 the
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7618e72766a5..79702841c06c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -264,8 +264,8 @@ static inline u64 file_mmap_size_max(struct file *fil=
e, struct inode *inode)
>         return ULONG_MAX;
>  }
>
> -static inline bool file_mmap_ok(struct file *file, struct inode *inode,
> -                               unsigned long pgoff, unsigned long len)
> +bool file_mmap_ok(struct file *file, struct inode *inode, unsigned long =
pgoff,
> +                 unsigned long len)
>  {
>         u64 maxsize =3D file_mmap_size_max(file, inode);
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index fff0465f5e06..8043c425b5df 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1791,6 +1791,7 @@ static int check_prep_vma(struct vma_remap_struct *=
vrm)
>         struct mm_struct *mm =3D current->mm;
>         unsigned long addr =3D vrm->addr;
>         unsigned long old_len, new_len, pgoff;
> +       struct file *file;
>
>         if (!vma)
>                 return -EFAULT;
> @@ -1870,6 +1871,11 @@ static int check_prep_vma(struct vma_remap_struct =
*vrm)
>         if (vma_is_fixed_mapping(vma))
>                 return -EFAULT;
>
> +       /* The expanded range must obey the same offset limits as mmap().=
 */
> +       file =3D vma->vm_file;
> +       if (file && !file_mmap_ok(file, file_inode(file), pgoff, new_len)=
)
> +               return -EINVAL;
> +
>         if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delt=
a))
>                 return -EAGAIN;
>
>
> --
> 2.56.0
>

