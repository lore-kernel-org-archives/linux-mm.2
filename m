Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4C110AB83F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BE96B008C; Thu, 26 Mar 2026 21:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C886B00A1; Thu, 26 Mar 2026 21:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53166B00A2; Thu, 26 Mar 2026 21:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C51EA6B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:55:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 755AEE08D1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:55:55 +0000 (UTC)
X-FDA: 84590177070.04.9C57449
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50E3440009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:55:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CAQtoUjU;
	spf=pass (imf11.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774576553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4/C6+dxmJ86MqBFYBzHKr+NUyGTfoaoGAJ7iveTtgs=;
	b=DlN/gXH4BeUbf6qOLuWLU+UeW8u+Io067hd/99bigJrthy8J9+6UflN+a8NT4Mki/OtJT7
	1HUkfhZdpGUq0GRjaVWIs2w1rtUxHTVPZPbSonlxsgauLpQbhjgbbYq7En7zZ9VIvnJoiB
	WSTRdcN/nbRsrlxFfhIjvTk8k1eE9Yc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CAQtoUjU;
	spf=pass (imf11.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774576553; a=rsa-sha256;
	cv=pass;
	b=x89Xog5AmbTEl6G2iQGDT0zuP4Eu3J/49Yr+zKw1bgeTFRcyasuC7yp0K9QsIgSVK21KcZ
	5TTtE/rje+64iLyimCRpmBoUhJBwf+l587C8od10wZWWBhlPZr+tdwTBnI8h3rplyDGlHG
	H+zHrE2XKWIQJbQqWAWEid7MH9Wken8=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b97bca3797dso247989266b.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:55:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774576552; cv=none;
        d=google.com; s=arc-20240605;
        b=JYRdY6NRcWPFngeZ/gTdqo/IGr3SFKYePSdvXLd5i3DaHpeJqrDj9K5GbZ1J7vdNRJ
         dfKKI02z82ZmF0F7BwGaNfGpdILVxU386dOVnxhTJ2dnDEfmIkJiTZkKkXzzwgimZq9P
         gmvf4WIYKAgC9yH149S6V2uuO8mC7ObWQgo8DMUmVjVwlpjECxHt3mZDurwLEFM9DTy0
         /F8+mPqSp1SyoPrPfA4m9CWeNFFQwj7feR4a6C/CNjQ8Rzk27aolTOTsNy/JFiJLf4JY
         yVZn8sghdgZX8zf0dQsWjc5oeenC+OUgas39aA2kQmeKja8Iow/Jaq3bvfFh4wL+zPJJ
         4zsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v4/C6+dxmJ86MqBFYBzHKr+NUyGTfoaoGAJ7iveTtgs=;
        fh=w7dCC1iOcIcXaZrhHktkyhuJmNnZRSDvTZsVUA0oFbY=;
        b=OSzc293RQyZ4/FZtK1eg/IAjcUpUJocw1AWnMSi9BuQhB6JIHwM/yFBa4ck6gdlhSO
         hBS08m9DmXlxoj3BYzqYmWjMU97UGAVo4J/ewISirRscMt0Voh+flC+mOV6uK/XKMRec
         JlBdYYn17RVvAvOqwBPs/FRcnPP8u3ywnBIhFRqW8x54vxb+XrzCPrfqjsfalfwKVaOH
         /0VGhbJvAUEuhw4KzoRslE4A2mqsIu0iONE3LlopQ+OrE4Pv1cNP49jMeqQ7EQV23ag7
         Byo3p62msZTIfvjPZJbFxFv2YgHxK8HwtWzkmEu8i8IHXAibICJ/CBqkQ1Xmt8JaQxXq
         AUsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774576552; x=1775181352; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4/C6+dxmJ86MqBFYBzHKr+NUyGTfoaoGAJ7iveTtgs=;
        b=CAQtoUjUgFxH0Svnp4JNHQnWrsdQEgxAx5+74PYpRzLtV8aS+fvvsVF9BEK9xgNlcq
         QAnrsmgF7tuN1tUPWLDVcwo6rtGbZPAUphkfIVSSkbxY9hSwQYfYKle6lE1KyJMI2Ki3
         witSpB4KLbk8FOnKqMVNByTMwK4sDOhdXRh3tsH7PAqTcHP0fGQxWpDOu018VW2ixGB7
         8StU9Miqyw2ePnweLRQNUfzpGHa/1c5XAPJ+1BUE746Qbh/bjkDrckz5FMrxs/d5bMIX
         Uj0OI3zqMKuajzoHrvESyuT6cyvyqz/XP+6Pp/Qy7nUKir9eR1cLzaoYUY8rq/wjCWKi
         coxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774576552; x=1775181352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v4/C6+dxmJ86MqBFYBzHKr+NUyGTfoaoGAJ7iveTtgs=;
        b=Rxi0JmmhYmA0K1AyTnAtpKUvprKj1hR2HdOUDCS2dqm8aAPvq7fdvtAjf1Fq6f7HD4
         8L9UCL59Wtip2n0EYSSK2Hj9nZYC1TI8pQpPTD3LC2BqhGGH5sMTt7O09Mlnt9YmSU7w
         b+lrdMiyOBZXb5E3XucONS7r/ijKlb8eX/eAQTC163I5tXjtCQHEM9ssc77vPDfYdNQ7
         0iy0z3xbOovjgjBIQlbmltksw637Qn1oBxM0LDY7FsS/9eTH415hP9hsrCO1xf9A8lGI
         rhAwhf5p2WsUh7SGoReQn5hcMc9MRk8w29Jhtm6fOt9/PQ06OC/q95sUWOZPCkOSuY82
         qdog==
X-Forwarded-Encrypted: i=1; AJvYcCXDU4nd6ywmWcN5p3KoF1DF5Rds/b4Qhqbh/J0LDWiN10/DqMZKDx38TfKPlbeIWARwjJoshpQLXg==@kvack.org
X-Gm-Message-State: AOJu0YxvvlJGWpQMrjWS0ANKWm43K9q3NWGphLPD5zw+FNzjBlodKudL
	M7FWcHX5lqTUp7n0LPFej/ICqw2UrH52feZegA4bY4MjNzBM0egk+JyrF9sHVRQbA7AQevON9JV
	lcveAUDuj3yjbqnc5Csle/fXVFHgLDQhvBpUYGItz
X-Gm-Gg: ATEYQzzc/3BVE5fC/W0HF3JXhv4Md66L2Uzy1din6QVB0vtmIqCBI1KRqq6u61Eyd5v
	/Q2zwKTDGK00j2Uiuz0QicOf7kaCWKLaTZcIdduZwIqdlha9SdqVDyAjonhl+dkd8JQP2DAzEz7
	G3M4PusHqpcHsciflkqS7BYugN+awkc3RrUFTvchJ1hGJrqkAtyQMcZDK3gU4DnuQy3UV0wnjJo
	1tnJDhdrRrzYrmUxpMPUtVHQcD6LJVlShsIcxzCxZfCHDilYKuzWvFmFw4Dlr8ZuYerW+oG5uh6
	KCtl08ZuyAcDwrOD2zLzsCChvQNXy3htYrm/sUWMf4zLiJTiVDwwNt2TlxgV2nev7br13g==
X-Received: by 2002:a17:907:e158:b0:b98:c69:f07d with SMTP id
 a640c23a62f3a-b9b5090a9b8mr25881366b.34.1774576551262; Thu, 26 Mar 2026
 18:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-1-rppt@kernel.org> <20260306171815.3160826-13-rppt@kernel.org>
In-Reply-To: <20260306171815.3160826-13-rppt@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 26 Mar 2026 18:55:15 -0700
X-Gm-Features: AQROBzDUg7nnPrShRG0yBUvJphXCQFgkh8YtYxeiIRK_yAgzpeQjdeV5p-bfc2o
Message-ID: <CADrL8HVUJ5FL97d9ytxp2WXos6HS+U+ycpsi5VxffsW9vacr9Q@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] mm: generalize handling of userfaults in __do_fault()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 50E3440009
X-Stat-Signature: bx4fp4xy8sobc74hhqk8hz8sfiotug8e
X-Rspam-User: 
X-HE-Tag: 1774576553-195241
X-HE-Meta: U2FsdGVkX1+Md6ix11bJFQ46zImCLacDg9c/DFs2Rz/gUGRE+I/CeTv43ad8P7DKU1skvtC7nzGKd4wVj2RuZ6ecqCO6td7FBcUZo5usJIA0i8eSDkMwD5HW0+uPWfkam1d1K37rltA0+d8sC7flgIyOYADTrSMjgVnkSA7DuNGEHqPsSFFb64f+61UXdEPYoDHfyWmt3Bl/pMSLJ05B0Npgdh9bRHQDjkWrLzQQfthzunY+Kn2eonO68CSXTIp1o0GmQ7FbnKnes1H60K976eK8tVMIxqkhjcdV8U/tAFgN2LURRbErWEQlRf0fvJsq8X0dTLaQ+SIZxBH1yPpIZBWdmMdoo2hSEmRXY+9sy05Da1lKlFiYrdmbe2zscXPyd3l6/Lij4H0la9k7nZGcvQ+ZwfvkQ6cjn2xlE6DJv8xW0QPHYwOP8YP3o80lCEKYnzao7MYea5uPXJZIcD1GMZuPf7lIYX7vdCHh6wEkTZUIR77V3DrOWPvJTtqSwDNm5ryAAeI5XfEYkzEiN6YN/uTKedu7Omsl8/h7xytqrl51JorY6G2p/c7bqpdBwqBh8UV9NRyyqzMWDjJi8VPdDQum3i2ExOUlZZZyRVXmYWJWCoJqjKVljMlKwWcMT1FGw97iWzPSdb07m0erZTikC6JifgeAL39CyPpR9hJk6p3vM0tvzGatpfRs57oMTNFWVjpvPXErqptuo0xE/0gA3w9610BnXnTm4dTY17lnlmqeHTgIn1OuJospmRpsRfHraqbconRlhSzE1b3p1B0297sgmDmqz7AtNWhMcm9jp1my+sLgsW5YQhFzs8agaOnqAN0MYX8qBDBAYlxCf9fqWv+xAw96YnMmUJyQuOM32E3JoXzM4LT+TLgBOqtGxsG4For3EnDUOT+mY+bKfyOmy9CDJO1E9FIWOUlnMN2DOCWrzHaUvXXoJvGS0XAyY0ebXGK2g6kAFOghc+nDi85
 /hdGAYED
 JCCjOf5VOaopwANUjvZ/Kuv+yuCDzvFQYBMKSJuUsyYI7l7QE0I0VWDaSlI7qAfapTpsffL1jwKPcXbP4V4hXQ8LGysOU811nD3XbTp+bR48YbEWeFxMroJglnLrTR6j9jQEmH0NlZjpcvNzvzzHUZj9UgOQoR+wQ5ZpSlQlPUc6tg3XLxS+hPf1jzaXL81aKYEgfNobMUFGuSjWQAZMyC+9cDDibB6HoaSRpR3YhhEFgDRUTmu9F+1hGmRlkcUDbmCoS8pGFxOsmxcBQZerv45vfjacEju+cxkM4xAlCr07c9vEyun0vqlFWseSB3WrjZ0QQkF8Ke9qxRrQl/bjyXx4bdhFk7tbAU6wK5Qa6NMe9PhAC0jk3Z0eGckorTEJZWLb1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 9:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> From: Peter Xu <peterx@redhat.com>
>
> When a VMA is registered with userfaulfd, its ->fault()
> method should check if a folio exists in the page cache and call
> handle_userfault() with appropriate mode:
>
> - VM_UFFD_MINOR if VMA is registered in minor mode and the folio exists
> - VM_UFFD_MISSING if VMA is registered in missing mode and the folio
>   does not exist
>
> Instead of calling handle_userfault() directly from a specific ->fault()
> handler, call __do_userfault() helper from the generic __do_fault().
>
> For VMAs registered with userfaultfd the new __do_userfault() helper
> will check if the folio is found in the page cache using
> vm_uffd_ops->get_folio_noalloc() and call handle_userfault() with the
> appropriate mode.
>
> Make vm_uffd_ops->get_folio_noalloc() required method for non-anonymous
> VMAs mapped at PTE level.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/memory.c      | 43 +++++++++++++++++++++++++++++++++++++++++++
>  mm/shmem.c       | 12 ------------
>  mm/userfaultfd.c |  8 ++++++++
>  3 files changed, 51 insertions(+), 12 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..e2183c44d70b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5328,6 +5328,41 @@ static vm_fault_t do_anonymous_page(struct vm_faul=
t *vmf)
>         return VM_FAULT_OOM;
>  }
>
> +#ifdef CONFIG_USERFAULTFD
> +static vm_fault_t __do_userfault(struct vm_fault *vmf)
> +{
> +       struct vm_area_struct *vma =3D vmf->vma;
> +       struct inode *inode;
> +       struct folio *folio;
> +
> +       if (!(userfaultfd_missing(vma) || userfaultfd_minor(vma)))
> +               return 0;
> +
> +       inode =3D file_inode(vma->vm_file);
> +       folio =3D vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pg=
off);

If you do away with the change you made to vma_can_userfault(), please
add a WARN_ON_ONCE() here if uffd_ops or uffd_ops->get_folio_noalloc
are not present.

> +       if (!IS_ERR_OR_NULL(folio)) {
> +               /*
> +                * TODO: provide a flag for get_folio_noalloc() to avoid
> +                * locking (or even the extra reference?)
> +                */

I think a whole new op is better than adding a flag. Something like
uffd_ops->folio_present().

> +               folio_unlock(folio);
> +               folio_put(folio);
> +               if (userfaultfd_minor(vma))
> +                       return handle_userfault(vmf, VM_UFFD_MINOR);
> +       } else {
> +               if (userfaultfd_missing(vma))
> +                       return handle_userfault(vmf, VM_UFFD_MISSING);
> +       }
> +
> +       return 0;
> +}
> +#else
> +static inline vm_fault_t __do_userfault(struct vm_fault *vmf)
> +{
> +       return 0;
> +}
> +#endif
> +
>  /*
>   * The mmap_lock must have been held on entry, and may have been
>   * released depending on flags and vma->vm_ops->fault() return value.
> @@ -5360,6 +5395,14 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>                         return VM_FAULT_OOM;
>         }
>
> +       /*
> +        * If this is an userfaultfd trap, process it in advance before

"If this is a userfault"

> +        * triggering the genuine fault handler.
> +        */
> +       ret =3D __do_userfault(vmf);
> +       if (ret)
> +               return ret;
> +
>         ret =3D vma->vm_ops->fault(vmf);
>         if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_R=
ETRY |
>                             VM_FAULT_DONE_COW)))
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 68620caaf75f..239545352cd2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2489,13 +2489,6 @@ static int shmem_get_folio_gfp(struct inode *inode=
, pgoff_t index,
>         fault_mm =3D vma ? vma->vm_mm : NULL;
>
>         folio =3D filemap_get_entry(inode->i_mapping, index);
> -       if (folio && vma && userfaultfd_minor(vma)) {
> -               if (!xa_is_value(folio))
> -                       folio_put(folio);
> -               *fault_type =3D handle_userfault(vmf, VM_UFFD_MINOR);
> -               return 0;
> -       }
> -
>         if (xa_is_value(folio)) {
>                 error =3D shmem_swapin_folio(inode, index, &folio,
>                                            sgp, gfp, vma, fault_type);
> @@ -2540,11 +2533,6 @@ static int shmem_get_folio_gfp(struct inode *inode=
, pgoff_t index,
>          * Fast cache lookup and swap lookup did not find it: allocate.
>          */
>
> -       if (vma && userfaultfd_missing(vma)) {
> -               *fault_type =3D handle_userfault(vmf, VM_UFFD_MISSING);
> -               return 0;
> -       }
> -
>         /* Find hugepage orders that are allowed for anonymous shmem and =
tmpfs. */
>         orders =3D shmem_allowable_huge_orders(inode, vma, index, write_e=
nd, false);
>         if (orders > 0) {
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 7cd7c5d1ce84..2ac5fad0ed6c 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2045,6 +2045,14 @@ bool vma_can_userfault(struct vm_area_struct *vma,=
 vm_flags_t vm_flags,
>             !vma_is_anonymous(vma))
>                 return false;
>
> +       /*
> +        * File backed memory with PTE level mappigns must implement

"File-backed VMAs (except HugeTLB VMAs) must implement
ops->get_folio_alloc() to support userfaults, as all userfaults in
file-backed VMAs wlll call ops->get_folio_alloc() to determine the
userfault type."

> +        * ops->get_folio_noalloc()
> +        */
> +       if (!vma_is_anonymous(vma) && !is_vm_hugetlb_page(vma) &&
> +           !ops->get_folio_noalloc)

With the separate folio_present() (or whatever) op, this check becomes
more obvious. (Looking at this right now, it looks like we're checking
for UFFDIO_CONTINUE/minor fault support here, but that's not really
what's going on.)

Honestly I'm not 100% sure if this check should be here. If it's going
to be here, then we should probably also have checks like these here:

if (vm_flags & VM_UFFD_MINOR && !ops->get_folio_noalloc)

and

if (vm_flags & VM_UFFD_MISSING && !ops->alloc_folio)

So, maybe we should just leave it up to ops->can_userfault() to make
sure we're doing the right thing?

> +               return false;
> +
>         return ops->can_userfault(vma, vm_flags);
>  }
>
> --
> 2.51.0
>

