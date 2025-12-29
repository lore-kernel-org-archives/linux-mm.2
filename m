Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874EBE92FE4
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 22:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F51E6B0088; Mon, 29 Dec 2025 17:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2C16B0089; Mon, 29 Dec 2025 17:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5848D6B008A; Mon, 29 Dec 2025 17:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44D7C6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 17:18:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA2D0C330F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 22:18:07 +0000 (UTC)
X-FDA: 84273922614.07.922E335
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id E71134000A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 22:18:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xSn4eJQ4;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767046686; a=rsa-sha256;
	cv=pass;
	b=RV58Fe5afVFMctJ5xmYTf++yZ0977H7zZvCEqdCpxhzXh2jU/eqooV82aICdfWqwu8F8vt
	5FqTllifN02WU2Z8v4kWyq0REjbeVTG6ATs0uXNB3lZdGxvu8L1n6EAJWs0IDgdP0ht8wM
	QTucZz9QecnaF2k58ikKCmTVD345LwI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xSn4eJQ4;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767046686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeChDKeFNuym6T0vKimesxWC0M98diDBtB6Ij7wnrHQ=;
	b=loNaLsAbdzZCWYOQ25Qeoo7f3RowXSqd+ytS3v6Ut43eHEbvdA6XZwkX5D27RmqZ0s/QaW
	0Iptw9atE46he4IevWjbdfJIh+5ZmgMZxpUhUdSjhMGb3nis8MXkIHZ+iBFk01hbVWbKA/
	WRZhutmeaEOGpbx3aoN95m1Eu8DYUhY=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso37421cf.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:18:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767046685; cv=none;
        d=google.com; s=arc-20240605;
        b=X5IzxwC+79BtXFFRKL5UJFnjlfJ8haZloGmV7H4QLn/OCKyKyyjGcWd9ThGbKRPQO3
         VbcLMChKDQutF32tq8VC4UjPYC7ElwjYv+wyOWfnKC1eY9NH77OxAfhqH2P1cjqjC0GP
         Owt5N4+dMR/9olfnj5isC2enJ6pcGTPEPCq7bVXDpDiIVbzYP5M5UBQ5C45IwmUqnT/D
         747hTps3cyHLohIymQVOYoAd3dufWt2CtKKdrxO5DgAmwPkTwUvu5yQm68pmN1oJ2/kq
         07si8VMtlZNve9y0yzev7Sn4i/oEwg0n77B8yLCodnbTlQCaTwKkPYIxTEnAQCLM2ehZ
         n6JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VeChDKeFNuym6T0vKimesxWC0M98diDBtB6Ij7wnrHQ=;
        fh=jDAB8qzU1p4qM93wNlJtiV8EbzI7vBFDzIq8t8DaslI=;
        b=VtwDMTx0uHbTG7CPX6p9VNXaHHEfW9nFOZqaListEDzLtcDeCweW7C2u2S1qxJHpNF
         ij/P9s8zdnHdOIta6ryeNU0mDS105352/z/oLmSiAzCJmGiaqhKZUQxmwL9mj8Hdt0xa
         0yt1ntelwqBGMj91E7MtdIUc6F0NiDbfytDvt+aAY4F4E1sW77ediEdP4S3bm/Fwn8oj
         7Z89rPf19OdgQoNgDfsd2m8yHPVDYUCUgOYC2tlyyJrRtIGfm/Go9lOZs669Y0cQrOXS
         HkFjdKZgBXSsa6EEYLR2sy8OIsooTLcj2EV7H32/DOUjVsDAhO7S19yxZIkLWtFPCSM4
         UEIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767046685; x=1767651485; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VeChDKeFNuym6T0vKimesxWC0M98diDBtB6Ij7wnrHQ=;
        b=xSn4eJQ4Oe6OGnomcMxuraeVk3lBDlWWqtltLVqYH8bqC908duLQUKPdRvrevPxxEv
         nPGYE15qsLfvmldVi+MsjTFJYM7dneuMP4a4gf8EEl+sQrEoDPRFbxYF1zBkHVGVH3Et
         8AHjNHXcEHODe3UXdapdzCBs11qPck9UPqarfoHZR1ooAIdvySN7ldQouorGC1hnSZ6X
         AsTSbj2u7Hawe4bFFtrqVKCfwVcg+WX/NiktWnKXdFjc/cwu5U9DS58Qb8ShkUL5jetu
         zMuj835ovOKlS72cHu9egTyTq7BgAus/+cya7q3JqNA684QcNleHB06jXcAaXnn0nt2j
         v9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767046685; x=1767651485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VeChDKeFNuym6T0vKimesxWC0M98diDBtB6Ij7wnrHQ=;
        b=wytgEmjbP69IPjSS8YyGkbtpD9U7sOn0ykrUMMCYPvtNsmiKZ09WsY4uXevae1AN4u
         z/oWvCIwQCzV3nJPeNyehpl56EKGJxGnjw2/+25IqBFlCvxLioa2Ld8rzemg2eVqIghq
         3nTzRmVKOpIwg/MTB9K3Qphim4TP7UCO87z8LXT60Nr2czejpniYoPfOP1Zx3x0Tw9FF
         CaaBGSbCWh2DTvUvTJ1Wr8EhN3OvqaMaQXQAh8O8ZtTwoDQM6axcI4J+nxtgAn1WtZXn
         M0oDC41YDz/OWzilcPbJZaNr6nF4uH39iy9hWlhbKusYTOLm4rcXM4WZzbxzMKMXdRHB
         wyRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWipQSh5m0U39cYUIRymLS/FAO0AXP5E63J2kXjf4a9QwL4euA0ZcfY9dox38lmvY7RetVEKl1TVw==@kvack.org
X-Gm-Message-State: AOJu0Yza2vToJOQEOqszULylrmNXHvk97y4dKKlnEvkl2up5s+G2t14/
	S4UpVYWeg0QlkPlRzoe2QPgwejrofxgW+Bn4nOlpLnmVxlDKT65XLMefdt0LruHF9gIhEr5E0Pu
	QqeBtjRdfvj2pus6mei6iBG7YZvSxZomzPi3lzOpr
X-Gm-Gg: AY/fxX5jW/7LBHMxGJnM5Lq3g4EYjw1+GtyGOkoIoKVzrjRZXJ3V9+F3WMrcKNV2NwB
	4B+MVPhQaznwrnCVMsLfjWw6dI6bizVH6QkhGl5djqs0bpfDxDKj0ivSI0jbPtHPl41S2dfNSm1
	ipyAHnPj4zt4iwZ1mDtyf+OsV+bfGSWJg3b21RmSQR4JVtT1+GphYajGY4jhQOIiWIo2eM3g62e
	Ejk04ktmwmh8Dg9TQGqrRbjfwCBvA3fwxq4SgvbcVRCBsF0GIRyYcLBCJ8xhD5h0ZJlfQ==
X-Google-Smtp-Source: AGHT+IGrh/zGjbLTv/VIfMgWVgpRyBaqC7hZ8qe+2twz82jtZWhmuMNm8CaNqtWo9LVdFPVajM04hkI8GRJlzkmuzxc=
X-Received: by 2002:ac8:7d47:0:b0:4f1:b421:1afd with SMTP id
 d75a77b69052e-4fab52274ffmr508671cf.3.1767046684497; Mon, 29 Dec 2025
 14:18:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com> <454c0680d4fdd5504b1e90b2fdaa098bd70d4d2d.1765970117.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <454c0680d4fdd5504b1e90b2fdaa098bd70d4d2d.1765970117.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 29 Dec 2025 14:17:53 -0800
X-Gm-Features: AQt7F2peCSXa47f7IbROJV1mVx1HDMKhgHDy5YyFHUfSCbLemXplRQe0ecPjQZ4
Message-ID: <CAJuCfpEWwdnNs458wSb__C0eHSEvbvJ9nK3ryQWLTjA3+b3BmQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E71134000A
X-Rspamd-Server: rspam03
X-Stat-Signature: ryuhnpzz97bsncbc17y6inrege4rgc5y
X-Rspam-User: 
X-HE-Tag: 1767046685-973762
X-HE-Meta: U2FsdGVkX18lSmZTSQFl5Qp+Vem1FMuU3IFR3p75JbD25a+fYYKgQdOWyDuUpm2/wO6/KR+HBKHRTqFH7OOwT+66fKw0uVQfRvEtGDbAOFNeMU+2NqHAfF/92zX55BphAGxYBGf/c081x7aqn9/v6jeZK2ubiiedrRlki4e5gZ0Un7BN7tL3dIp7Fa1gcjgBrjoOze3n9eHhIfVgkSJ2t+rETEe3nv35HyCyU5rKHoZp2BaMBkte2cO9fEnwM0HP7YIz23SRALjPZtofanwI4KGGCQsd9P38LwXx3tQXPIO/cDOWMBhAjwSmRTHkpJ54/PfzmMCL2BtZLWslR1blJaSvjvAj7mzZVb78Btlp1G2XCs3n7+vCMWS/VdfW76kBhaO9bXgaP9B3gL5UPrY1ak7yp2VsPgp/hvhiplioZLR5grvq8/o/Mrl/moYSFiXuZB3jJyiMcYqHcvr3bCd0cJwL6j2qATxuLLoNv5lpvuZem8CACeuMuncII7zuYoyAubsBTV1J7c3OGqzGsQeTJntq4Mcqdr/Q3zFk9Kqwg6+wfsrBPp6gDfqejVgnxIvQxK5uoO8h1sWrYOZ9a8eyPFODHdsngngjD1h7GaNS+6zuUTYv5iJ5xJal9wlQIDtjai8XNIciflEMrhIQAQoaUvnA+vwab0UvVfVzEXjYgBzvfHoud91loecCsvXDYPFYQoWeJbMElXx3aaFHWxEM5OBdkOIVxvIJXn/sZCMZpZ07eMjmbFF8gtjSlDW+j+BkZ6/mQsKdByOVPjAlqFh2soHVnAwZTEV6MOfVUJlI77IKedVnLfvg0YUymuyW/KG0BXdVYjaymHyZeZQucHrIWu9492Z1+WgImkecuPnU0nOnZctOjoKxDpyGfucDRhZlvGtQHUNH+KJUQNVuS/rg7xbp7jcUkGUkLnWZD8dmlmgw/fcPUvxVGOgatkyJWctmkUJMmnxXglUHgGwTS+Y
 w9tqxzab
 GqLkNqzFISUXUMY1KzSa9M3+VnQBVdpGTUpd8wW061KIE2IQQd6b2JnsXjU653mydQXbJ2KRczqMWbV8SW0ZSK39z5fdifyXvwVYBRVQ6Rd+9EVk0RGfTmuj2f/bORxzbmiAhvT9bbE5K5NzPMX0dy3VA7R+aedGWx6fjnPP2KR3a1106Qddt6iRsAWm/9gvkjqwJJbgqdsUeD+cHhHHTKV6jBd6Ajg1vSJ3IiCOzrp8gQxNlfqCKKZ5cvQtQhREDDGcrEbup+8WY1U99hgkfCH+Eaw==
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
> The root anon_vma of all anon_vma's linked to a VMA must by definition be
> the same - a VMA and all of its descendants/ancestors must exist in the
> same CoW chain.
>
> Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences i=
n
> anon_vma_clone()") introduced paranoid checking of the root anon_vma
> remaining the same throughout all AVC's in 2011.
>
> I think 15 years later we can safely assume that this is always the case.
>
> Additionally, since unfaulted VMAs being cloned from or unlinked are
> no-op's, we can simply lock the anon_vma's associated with this rather th=
an
> doing any specific dance around this.
>
> This removes unnecessary checks and makes it clear that the root anon_vma
> is shared between all anon_vma's in a given VMA's anon_vma_chain.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/rmap.c | 48 ++++++++++++------------------------------------
>  1 file changed, 12 insertions(+), 36 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9332d1cbc643..60134a566073 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -231,32 +231,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>         return -ENOMEM;
>  }
>
> -/*
> - * This is a useful helper function for locking the anon_vma root as
> - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> - * have the same vma.
> - *
> - * Such anon_vma's should have the same root, so you'd expect to see
> - * just a single mutex_lock for the whole traversal.
> - */
> -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root,=
 struct anon_vma *anon_vma)
> -{
> -       struct anon_vma *new_root =3D anon_vma->root;
> -       if (new_root !=3D root) {
> -               if (WARN_ON_ONCE(root))
> -                       up_write(&root->rwsem);
> -               root =3D new_root;
> -               down_write(&root->rwsem);
> -       }
> -       return root;
> -}
> -
> -static inline void unlock_anon_vma_root(struct anon_vma *root)
> -{
> -       if (root)
> -               up_write(&root->rwsem);
> -}
> -
>  static void check_anon_vma_clone(struct vm_area_struct *dst,
>                                  struct vm_area_struct *src)
>  {
> @@ -307,26 +281,25 @@ static void check_anon_vma_clone(struct vm_area_str=
uct *dst,
>  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c)
>  {
>         struct anon_vma_chain *avc, *pavc;
> -       struct anon_vma *root =3D NULL;
>
>         if (!src->anon_vma)
>                 return 0;
>
>         check_anon_vma_clone(dst, src);
>
> +       anon_vma_lock_write(src->anon_vma);
>         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
>                 struct anon_vma *anon_vma;
>
>                 avc =3D anon_vma_chain_alloc(GFP_NOWAIT);
>                 if (unlikely(!avc)) {
> -                       unlock_anon_vma_root(root);
> -                       root =3D NULL;
> +                       anon_vma_unlock_write(src->anon_vma);
>                         avc =3D anon_vma_chain_alloc(GFP_KERNEL);
>                         if (!avc)
>                                 goto enomem_failure;
> +                       anon_vma_lock_write(src->anon_vma);

So, we drop and then reacquire src->anon_vma->root->rwsem, expecting
src->anon_vma and src->anon_vma->root to be the same. And IIUC
src->vm_mm's mmap lock is what guarantees all this. If so, could you
please add a clarifying comment here?

>                 }
>                 anon_vma =3D pavc->anon_vma;
> -               root =3D lock_anon_vma_root(root, anon_vma);
>                 anon_vma_chain_link(dst, avc, anon_vma);
>
>                 /*
> @@ -343,7 +316,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct=
 vm_area_struct *src)
>         }
>         if (dst->anon_vma)
>                 dst->anon_vma->num_active_vmas++;
> -       unlock_anon_vma_root(root);
> +
> +       anon_vma_unlock_write(src->anon_vma);
>         return 0;
>
>   enomem_failure:
> @@ -438,15 +412,17 @@ int anon_vma_fork(struct vm_area_struct *vma, struc=
t vm_area_struct *pvma)
>  void unlink_anon_vmas(struct vm_area_struct *vma)
>  {
>         struct anon_vma_chain *avc, *next;
> -       struct anon_vma *root =3D NULL;
> +       struct anon_vma *active_anon_vma =3D vma->anon_vma;
>
>         /* Always hold mmap lock, read-lock on unmap possibly. */
>         mmap_assert_locked(vma->vm_mm);
>
>         /* Unfaulted is a no-op. */
> -       if (!vma->anon_vma)
> +       if (!active_anon_vma)
>                 return;
>
> +       anon_vma_lock_write(active_anon_vma);
> +
>         /*
>          * Unlink each anon_vma chained to the VMA.  This list is ordered
>          * from newest to oldest, ensuring the root anon_vma gets freed l=
ast.
> @@ -454,7 +430,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>         list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vm=
a) {
>                 struct anon_vma *anon_vma =3D avc->anon_vma;
>
> -               root =3D lock_anon_vma_root(root, anon_vma);
>                 anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
>
>                 /*
> @@ -470,13 +445,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>                 anon_vma_chain_free(avc);
>         }
>
> -       vma->anon_vma->num_active_vmas--;
> +       active_anon_vma->num_active_vmas--;
>         /*
>          * vma would still be needed after unlink, and anon_vma will be p=
repared
>          * when handle fault.
>          */
>         vma->anon_vma =3D NULL;
> -       unlock_anon_vma_root(root);
> +       anon_vma_unlock_write(active_anon_vma);
> +
>
>         /*
>          * Iterate the list once more, it now only contains empty and unl=
inked
> --
> 2.52.0
>

