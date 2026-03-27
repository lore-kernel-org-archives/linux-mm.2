Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B1310AB83B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302DE6B0099; Thu, 26 Mar 2026 21:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D586B009D; Thu, 26 Mar 2026 21:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DFF6B009E; Thu, 26 Mar 2026 21:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC2436B0099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:14:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC5BD5DA74
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:14:18 +0000 (UTC)
X-FDA: 84590072196.25.388402A
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8BC3C20004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:14:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oQxhfn6C;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774574056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhxZX2O1RE14J5J20PYHIBXD8rpdMgbUWp57ctYeyoA=;
	b=T14een+DgAEANhCP/o5aDJwYMVsd4sC98blTIM213YX12SKmYu6Autpby6XngbEduLxJdT
	F3AmTejiGY48mQsQgCWSFBoHjYTe/i94r0cPvzfTTHCYy5iNcYJBLUF9XC2YIfImcH0EQO
	p0nNeZO2sTzcPYFr3+Tw4AaP1lf8Pxk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774574056; a=rsa-sha256;
	cv=pass;
	b=UR+/YSZ+oC4ORDyKtzG8wbU2H3j3erP8Z5unAZkfbmiDXLIoPpCgNkfWX4lgmdDL8B7yoY
	w8GCh5sZ1C2+LT+gMmCtiMH9g6wLi0KEj0iZxQwg/xBDGEOIzcxAksQhZ3PElrJJH3r9Mr
	OqMJoeHxm+B0480dATTalo4xII4Eig4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oQxhfn6C;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b980b35534eso408738966b.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:14:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774574055; cv=none;
        d=google.com; s=arc-20240605;
        b=CBGAeRCt0lSJ+EQhx45inYV2EIRgKZ/BJE+71GO9+J/nS5AuqwKabisI2hX4q3scOj
         ZP3hWj321jJsl+4zbBNLi+gA9/+NlY04D54ht6NqWYn99bob8edMSgsbzQNXmFLl8Gb9
         10lXGL/piCDmUTiyW1x21PT3ySu/uL/YX3dqRSCssx/4tFT2WlVQOlOv3GxGpYBCNTgi
         b0JLb1zcNxomsIBSjzv0M0rm4r8CPy3cLSx14+uhbAAbjAXt9TTjInY4TxPd6GQjSA6V
         7NzIe7vKiQsLv7dexdY9/Hq/EeqqyhHWWPMQiFw7p+fdtKK44bZR/ewY+Aok9w3ZVMSO
         wMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HhxZX2O1RE14J5J20PYHIBXD8rpdMgbUWp57ctYeyoA=;
        fh=GWNBY8yJ8mZtNUGgCJ1uzxDE3MXLn6P3pma8a2DNu14=;
        b=Km3L02jx4XzlOlVsKM+5jCtG2hn3nA4gtug2CmiROmMYBozQz2OpHHpZiTdUy+x7jl
         d8aMlFIfoYccVZiG5bnVDTjfhvk5BXgG+xAIBBjg6xg389zwr+OGjMqkIVS0vbWIGwCx
         DMw9k6b3cZCa59BQyk2Nd6ycUdCHjCCpnDCL1aqyhZZCta9YCBZK30hnroFYlQXdvcku
         x3QvkLzpwlOEQ3elYAHHnWBJww2HlBK8sEEPPX46B32u1fHetgbq0i3Ww2UVb11yLbiM
         STXU448juGtXfGhboShKEsuB1k4U+FxX1rgTT8SPd/sJJUy+6lb7wnXUmrecEYZWcDsk
         nKsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774574055; x=1775178855; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhxZX2O1RE14J5J20PYHIBXD8rpdMgbUWp57ctYeyoA=;
        b=oQxhfn6Cw5X8YleHD472tOOLUlzCN06zTV5Kseqyggg0vLXx8Pkf7wSkeJVmdO+K1S
         v/dZYPqvQHhSnjCOzCseFSsO3qqzj9QkEVGeN7Hejax2smb8vg2FKUQnukGUnC4hUdeh
         t/BkZhRTTuqh9Wnxs0siVxybVGZuYW0rPGcH8aUPK8gDlhuiwS75fn+LdrzfLWgL+Q7r
         OOwt2S3RtPtpr6+eMDkrqqqbg0AND1VH/ejzGFM+JT5D1dEyyDo/IyBn7JCQ7IkMGU93
         NizrunMYLyU/3Wl0Zt3TyeWV9S/zv9ynFSyHBohUm0J0msepUGTmCb3o07eWHK3bS88I
         X5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774574055; x=1775178855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HhxZX2O1RE14J5J20PYHIBXD8rpdMgbUWp57ctYeyoA=;
        b=HPYcBpWgZgeZ8JL7EU7pOEdy9hW4bYlvuwOKzJXUUVR0kaZ9X6UbMbZ0lWXXLCkV4L
         4lWIKlOHtw8EW4EPpsWJvDNcfymGw8xf+tepfQdgiffUsewsv7jYHnSc/+b3xfkhC+j5
         KuXr3x5u19njb1ALz42Ys7fymXLuPtB4l/pOpihhGP7W4+WeFwSJ+ZUNOr8t4jcddYz/
         QZaUWyW0NO834o1l+2aofNr0f4chuMY5HXgtMDoJq2EWMzl1xZfpsntS4xyMfMkxjYEE
         kkYxBb0S8AQ5mppfUrunZWLTk9+6/NmXCDjjjWYpJn0wc9ZOj8ds1xTHEyrbM56rZVDR
         jsrg==
X-Forwarded-Encrypted: i=1; AJvYcCUDaYU50XQ1ZVpaW6aAM8Zy8Z5CbJEFpKLw93xE3U7IqvClg4LF/CYQbBe/VCHpkk7RIC+ZmIQePA==@kvack.org
X-Gm-Message-State: AOJu0YxhrBB+84L8GfcA0TChcrIN2so51rtro4jchkFXSUGO6eqYNMo7
	QAHqb+MKBqilr2J5eG63r2mdfGmkatK5ylP5CPwvEgGwS3Z40IfSgng9uVaUZaHBw9dMy9iN5gq
	oEoCxqXXmlWCUBEEmxazCTpjlpzJ+BmMJ8Z1xvCHR
X-Gm-Gg: ATEYQzyWAfVb2le9i0y3i29B05ppPJT+tCQRSzAmUZWeszqJ5b+a9hUoymJCehrTyaW
	LDAOv8Lk61IiP0SO8UWi6cWIKWJSLP+4nPmv326q08tVVoTRez0qzXOfmQeSNfS04gGaZ/B6D7t
	b7nC3iWy/izQSrhEo8rfV6o1U4twKNITPM2H5F0oSpPJkGepp4Og/WNvkxIxr2mnrqRseX8q2N8
	ZZW+9r+QGLZHvdnRm1WblXcT4fK6M3Zxo0jmMevZ9XX99E9TiW/pxLUCAdehZkGlX6MXUv0VHHT
	4uMfcVAZ78kXg56zLKhrM1Ros3mFawq1RF7duJ38orGuw2UVaIWqRfKtaLJdvmJTUta1mrw8HgV
	HLP5M
X-Received: by 2002:a17:907:1c1e:b0:b96:f02b:3d5a with SMTP id
 a640c23a62f3a-b9b2e9b5216mr262667266b.16.1774574054212; Thu, 26 Mar 2026
 18:14:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-1-rppt@kernel.org> <20260306171815.3160826-11-rppt@kernel.org>
In-Reply-To: <20260306171815.3160826-11-rppt@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 26 Mar 2026 18:13:37 -0700
X-Gm-Features: AQROBzBQyge7wu5M6M8_oSuF4nnH7MkTzeWL7KSgT2vc7Vxrdz4Z0F92-JPqKdQ
Message-ID: <CADrL8HXajnfE=WusxL=DeF7VcvrsX9z5XDC4mPt1JfMOd7J5DA@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] shmem, userfaultfd: implement shmem uffd
 operations using vm_uffd_ops
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
X-Rspamd-Queue-Id: 8BC3C20004
X-Stat-Signature: otgmpsbmmoi98fiyjgdmhiacy6ytbngm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774574056-969667
X-HE-Meta: U2FsdGVkX1+AfSfrgGJZedwOf1V5hLUh/hUpr0yQz3zP2DRrgye/Wja+M94e7OWft17HaoKi0aQVDnBgcigxpQoumnvSYLeapGnWZcROIYhwe3pcw14f/1+Aa0Q3YLiq5GhD1N5qcJvgot4g6s/qi/uV7WHY95KWNt6vTH+tDSlTsGHb3DNov/ytpP4UM5AmPBpOGBrDBtfGGVgQU4jg5VrxcRJJ8yKUmvBweMtfF9I2qM+Xy3id7kFV9FXvG5kSRyN8fN2T75RUUYarW3PlKHW+gwvcz1UfcgeZnF0EktIV7UwgW7A8Sr49rBS5cb/HiWZyh1ZAG6XtdUjgFJwe1bcNXJdkWfWmsEci4DwxWsQGkl1Bl7PywxqLsJ36a9qIGHfdeXhiRt/DNJGaO5YJrqwdkgSGpdHwPXONHbxWh4NT9AAZBG03yKKZwTdI3p/pjKQJ3F7bG/4gVeP+7v3flBRSR+v8iPmt78ezQvYTb3CdupIs3c/1+q+BYxISZHjA6Kd3BjzzsZODei7drDjd/B0a+uJHMv/uN42qZe3nEOmo7Ov/7kN+Xb34u6yHR85mTeMwltTAyVRYJrNWOn0rhHLYUr6ojNFRx3jdCDkM7ZoXdCS474xhY8u3jkUxtFvFofc4O6R81/ts7VMWoBbeSBYj7Jr7sstZsJQHzmNWZ7JQp+l/PTAZ/Fi1F2CBKhAtqMoJTcWIKRSQ2nxTy709WagdzhfQ3n799sZWAHCeuwizsDElFScKwmHKpDnMUvmtHP2uttQtt+rvw6zxMwG5/+OR/3l1P1ME2o4uaf7ki0DRoZHgz8iO7R6Ub29BOe6vLF77Zl+xg+S+L2ZQ0vGH4wLBR2ISEM46VQf0bBqW2fM7OsLSh+nDSAUwTQdg2ssqB/zpADmSMnHbHp5k/dO9bERe8hI+UKca+fhoH0WZ7mQxCL26IVevQ8o8mgvEM51k+IMhX3OPTnRxEyo4hx7
 0OSOYzIk
 X8bVoKdFNfHE4JJ8xx0zjeZYCKE40E/NRWVSCB2mMe9BmLXeFQ+wY6GNhBdHYZetbHcE06M+veUJRAim/gT4fRoRyr7W0BbsapC8m+TcQOswcnf6NHkEyu4V4S3oGqFJNodvUIsnNKYXnNpwrjU5IWhUFLDByHAP+aytQkSS0KHX/2RZ70qavnpZbJpMy9HaTDswGglJPSFhIZ3WWhV7rPhZkUm50lKYcDdVBHn6rgfhmJb6E5Rgs4ZeVLCTaJjOkUMRQaHmcAbvGZcoP38d0zL7MbGOfsPVxUDv6XO7/XsBlZxV89A6negM8rRk99Q08F9kW+8F10cRUa/IPL1Lg30pfpdUpA+aqjpPACywI8PzIUj1JfSkVsmpGWUbNR1WIu+a1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 9:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Add filemap_add() and filemap_remove() methods to vm_uffd_ops and use
> them in __mfill_atomic_pte() to add shmem folios to page cache and
> remove them in case of error.
>
> Implement these methods in shmem along with vm_uffd_ops->alloc_folio()
> and drop shmem_mfill_atomic_pte().
>
> Since userfaultfd now does not reference any functions from shmem, drop
> include if linux/shmem_fs.h from mm/userfaultfd.c
>
> mfill_atomic_install_pte() is not used anywhere outside of
> mm/userfaultfd, make it static.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/shmem_fs.h      |  14 ----
>  include/linux/userfaultfd_k.h |  21 +++--
>  mm/shmem.c                    | 148 ++++++++++++----------------------
>  mm/userfaultfd.c              |  79 +++++++++---------
>  4 files changed, 106 insertions(+), 156 deletions(-)
>
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index a8273b32e041..1a345142af7d 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -221,20 +221,6 @@ static inline pgoff_t shmem_fallocend(struct inode *=
inode, pgoff_t eof)
>
>  extern bool shmem_charge(struct inode *inode, long pages);
>
> -#ifdef CONFIG_USERFAULTFD
> -#ifdef CONFIG_SHMEM
> -extern int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> -                                 struct vm_area_struct *dst_vma,
> -                                 unsigned long dst_addr,
> -                                 unsigned long src_addr,
> -                                 uffd_flags_t flags,
> -                                 struct folio **foliop);
> -#else /* !CONFIG_SHMEM */
> -#define shmem_mfill_atomic_pte(dst_pmd, dst_vma, dst_addr, \
> -                              src_addr, flags, foliop) ({ BUG(); 0; })
> -#endif /* CONFIG_SHMEM */
> -#endif /* CONFIG_USERFAULTFD */
> -
>  /*
>   * Used space is stored as unsigned 64-bit value in bytes but
>   * quota core supports only signed 64-bit values so use that
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.=
h
> index 4d8b879eed91..bf4e595ac914 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -93,10 +93,24 @@ struct vm_uffd_ops {
>         struct folio *(*get_folio_noalloc)(struct inode *inode, pgoff_t p=
goff);
>         /*
>          * Called during resolution of UFFDIO_COPY request.
> -        * Should return allocate a and return folio or NULL if allocatio=
n fails.
> +        * Should allocate and return a folio or NULL if allocation
> +        * fails.
>          */
>         struct folio *(*alloc_folio)(struct vm_area_struct *vma,
>                                      unsigned long addr);
> +       /*
> +        * Called during resolution of UFFDIO_COPY request.
> +        * Should lock the folio and add it to VMA's page cache.

I don't think "should lock the folio" is accurate. That sounds like
"it will call folio_lock()" but it actually calls
__folio_set_locked(). Maybe this is better:

"Should only be called with a folio returned by alloc_folio() above.
The folio will set to locked."

> +        * Returns 0 on success, error code on failure.
> +        */
> +       int (*filemap_add)(struct folio *folio, struct vm_area_struct *vm=
a,
> +                        unsigned long addr);
> +       /*
> +        * Called during resolution of UFFDIO_COPY request on the error
> +        * handling path.
> +        * Should revert the operation of ->filemap_add().
> +        */
> +       void (*filemap_remove)(struct folio *folio, struct vm_area_struct=
 *vma);
>  };
>
>  /* A combined operation mode + behavior flags. */
> @@ -130,11 +144,6 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_=
flags_t flags, enum mfill_at
>  /* Flags controlling behavior. These behavior changes are mode-independe=
nt. */
>  #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
>
> -extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
> -                                   struct vm_area_struct *dst_vma,
> -                                   unsigned long dst_addr, struct page *=
page,
> -                                   bool newly_allocated, uffd_flags_t fl=
ags);
> -
>  extern ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned l=
ong dst_start,
>                                  unsigned long src_start, unsigned long l=
en,
>                                  uffd_flags_t flags);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 7bd887b64f62..68620caaf75f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3181,118 +3181,73 @@ static struct inode *shmem_get_inode(struct mnt_=
idmap *idmap,
>  #endif /* CONFIG_TMPFS_QUOTA */
>
>  #ifdef CONFIG_USERFAULTFD
> -int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> -                          struct vm_area_struct *dst_vma,
> -                          unsigned long dst_addr,
> -                          unsigned long src_addr,
> -                          uffd_flags_t flags,
> -                          struct folio **foliop)
> -{
> -       struct inode *inode =3D file_inode(dst_vma->vm_file);
> -       struct shmem_inode_info *info =3D SHMEM_I(inode);
> +static struct folio *shmem_mfill_folio_alloc(struct vm_area_struct *vma,
> +                                            unsigned long addr)
> +{
> +       struct inode *inode =3D file_inode(vma->vm_file);
>         struct address_space *mapping =3D inode->i_mapping;
> +       struct shmem_inode_info *info =3D SHMEM_I(inode);
> +       pgoff_t pgoff =3D linear_page_index(vma, addr);
>         gfp_t gfp =3D mapping_gfp_mask(mapping);
> -       pgoff_t pgoff =3D linear_page_index(dst_vma, dst_addr);
> -       void *page_kaddr;
>         struct folio *folio;
> -       int ret;
> -       pgoff_t max_off;
> -
> -       if (shmem_inode_acct_blocks(inode, 1)) {
> -               /*
> -                * We may have got a page, returned -ENOENT triggering a =
retry,
> -                * and now we find ourselves with -ENOMEM. Release the pa=
ge, to
> -                * avoid a BUG_ON in our caller.
> -                */
> -               if (unlikely(*foliop)) {
> -                       folio_put(*foliop);
> -                       *foliop =3D NULL;
> -               }
> -               return -ENOMEM;
> -       }
>
> -       if (!*foliop) {
> -               ret =3D -ENOMEM;
> -               folio =3D shmem_alloc_folio(gfp, 0, info, pgoff);
> -               if (!folio)
> -                       goto out_unacct_blocks;
> +       if (unlikely(pgoff >=3D DIV_ROUND_UP(i_size_read(inode), PAGE_SIZ=
E)))
> +               return NULL;
>
> -               if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY)) {
> -                       page_kaddr =3D kmap_local_folio(folio, 0);
> -                       /*
> -                        * The read mmap_lock is held here.  Despite the
> -                        * mmap_lock being read recursive a deadlock is s=
till
> -                        * possible if a writer has taken a lock.  For ex=
ample:
> -                        *
> -                        * process A thread 1 takes read lock on own mmap=
_lock
> -                        * process A thread 2 calls mmap, blocks taking w=
rite lock
> -                        * process B thread 1 takes page fault, read lock=
 on own mmap lock
> -                        * process B thread 2 calls mmap, blocks taking w=
rite lock
> -                        * process A thread 1 blocks taking read lock on =
process B
> -                        * process B thread 1 blocks taking read lock on =
process A
> -                        *
> -                        * Disable page faults to prevent potential deadl=
ock
> -                        * and retry the copy outside the mmap_lock.
> -                        */
> -                       pagefault_disable();
> -                       ret =3D copy_from_user(page_kaddr,
> -                                            (const void __user *)src_add=
r,
> -                                            PAGE_SIZE);
> -                       pagefault_enable();
> -                       kunmap_local(page_kaddr);
> -
> -                       /* fallback to copy_from_user outside mmap_lock *=
/
> -                       if (unlikely(ret)) {
> -                               *foliop =3D folio;
> -                               ret =3D -ENOENT;
> -                               /* don't free the page */
> -                               goto out_unacct_blocks;
> -                       }
> +       folio =3D shmem_alloc_folio(gfp, 0, info, pgoff);
> +       if (!folio)
> +               return NULL;
>
> -                       flush_dcache_folio(folio);
> -               } else {                /* ZEROPAGE */
> -                       clear_user_highpage(&folio->page, dst_addr);
> -               }
> -       } else {
> -               folio =3D *foliop;
> -               VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
> -               *foliop =3D NULL;
> +       if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL)) {
> +               folio_put(folio);
> +               return NULL;
>         }
>
> -       VM_BUG_ON(folio_test_locked(folio));
> -       VM_BUG_ON(folio_test_swapbacked(folio));
> +       return folio;
> +}
> +
> +static int shmem_mfill_filemap_add(struct folio *folio,
> +                                  struct vm_area_struct *vma,
> +                                  unsigned long addr)
> +{
> +       struct inode *inode =3D file_inode(vma->vm_file);
> +       struct address_space *mapping =3D inode->i_mapping;
> +       pgoff_t pgoff =3D linear_page_index(vma, addr);
> +       gfp_t gfp =3D mapping_gfp_mask(mapping);
> +       int err;
> +
>         __folio_set_locked(folio);
>         __folio_set_swapbacked(folio);
> -       __folio_mark_uptodate(folio);
> -
> -       ret =3D -EFAULT;
> -       max_off =3D DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> -       if (unlikely(pgoff >=3D max_off))
> -               goto out_release;
>
> -       ret =3D mem_cgroup_charge(folio, dst_vma->vm_mm, gfp);
> -       if (ret)
> -               goto out_release;
> -       ret =3D shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp)=
;
> -       if (ret)
> -               goto out_release;
> +       err =3D shmem_add_to_page_cache(folio, mapping, pgoff, NULL, gfp)=
;
> +       if (err)
> +               goto err_unlock;
>
> -       ret =3D mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -                                      &folio->page, true, flags);
> -       if (ret)
> -               goto out_delete_from_cache;
> +       if (shmem_inode_acct_blocks(inode, 1)) {
> +               err =3D -ENOMEM;
> +               goto err_delete_from_cache;
> +       }
>
> +       folio_add_lru(folio);
>         shmem_recalc_inode(inode, 1, 0);
> -       folio_unlock(folio);
> +
>         return 0;
> -out_delete_from_cache:
> +
> +err_delete_from_cache:
>         filemap_remove_folio(folio);
> -out_release:
> +err_unlock:
> +       folio_unlock(folio);
> +       return err;
> +}
> +
> +static void shmem_mfill_filemap_remove(struct folio *folio,
> +                                      struct vm_area_struct *vma)
> +{
> +       struct inode *inode =3D file_inode(vma->vm_file);
> +
> +       filemap_remove_folio(folio);
> +       shmem_recalc_inode(inode, 0, 0);
>         folio_unlock(folio);
> -       folio_put(folio);
> -out_unacct_blocks:
> -       shmem_inode_unacct_blocks(inode, 1);
> -       return ret;
>  }
>
>  static struct folio *shmem_get_folio_noalloc(struct inode *inode, pgoff_=
t pgoff)
> @@ -3315,6 +3270,9 @@ static bool shmem_can_userfault(struct vm_area_stru=
ct *vma, vm_flags_t vm_flags)
>  static const struct vm_uffd_ops shmem_uffd_ops =3D {
>         .can_userfault          =3D shmem_can_userfault,
>         .get_folio_noalloc      =3D shmem_get_folio_noalloc,
> +       .alloc_folio            =3D shmem_mfill_folio_alloc,
> +       .filemap_add            =3D shmem_mfill_filemap_add,
> +       .filemap_remove         =3D shmem_mfill_filemap_remove,
>  };
>  #endif /* CONFIG_USERFAULTFD */
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 31f3ab6a73e2..a0f8e67006d6 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -14,7 +14,6 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/hugetlb.h>
> -#include <linux/shmem_fs.h>
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -340,10 +339,10 @@ static bool mfill_file_over_size(struct vm_area_str=
uct *dst_vma,
>   * This function handles both MCOPY_ATOMIC_NORMAL and _CONTINUE for both=
 shmem
>   * and anon, and for both shared and private VMAs.
>   */
> -int mfill_atomic_install_pte(pmd_t *dst_pmd,
> -                            struct vm_area_struct *dst_vma,
> -                            unsigned long dst_addr, struct page *page,
> -                            bool newly_allocated, uffd_flags_t flags)
> +static int mfill_atomic_install_pte(pmd_t *dst_pmd,
> +                                   struct vm_area_struct *dst_vma,
> +                                   unsigned long dst_addr, struct page *=
page,
> +                                   uffd_flags_t flags)
>  {
>         int ret;
>         struct mm_struct *dst_mm =3D dst_vma->vm_mm;
> @@ -387,9 +386,6 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>                 goto out_unlock;
>
>         if (page_in_cache) {
> -               /* Usually, cache pages are already added to LRU */
> -               if (newly_allocated)
> -                       folio_add_lru(folio);
>                 folio_add_file_rmap_pte(folio, page, dst_vma);
>         } else {
>                 folio_add_new_anon_rmap(folio, dst_vma, dst_addr, RMAP_EX=
CLUSIVE);
> @@ -404,6 +400,9 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
>
>         set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
>
> +       if (page_in_cache)
> +               folio_unlock(folio);

I don't really like doing the folio_unlock() *here*, I think it's
clearer if the callers (mfill_atomic_pte_continue() and
__mfill_atomic_pte()) unlocked the folio themselves. But that's just
my opinion.

> +
>         /* No need to invalidate - it was non-present before */
>         update_mmu_cache(dst_vma, dst_addr, dst_pte);
>         ret =3D 0;
> @@ -516,13 +515,22 @@ static int __mfill_atomic_pte(struct mfill_state *s=
tate,
>          */
>         __folio_mark_uptodate(folio);
>
> +       if (ops->filemap_add) {
> +               ret =3D ops->filemap_add(folio, state->vma, state->dst_ad=
dr);
> +               if (ret)
> +                       goto err_folio_put;
> +       }
> +
>         ret =3D mfill_atomic_install_pte(state->pmd, state->vma, dst_addr=
,
> -                                      &folio->page, true, flags);
> +                                      &folio->page, flags);
>         if (ret)
> -               goto err_folio_put;
> +               goto err_filemap_remove;
>
>         return 0;
>
> +err_filemap_remove:
> +       if (ops->filemap_remove)
> +               ops->filemap_remove(folio, state->vma);
>  err_folio_put:
>         folio_put(folio);
>         /* Don't return -ENOENT so that our caller won't retry */
> @@ -535,6 +543,18 @@ static int mfill_atomic_pte_copy(struct mfill_state =
*state)
>  {
>         const struct vm_uffd_ops *ops =3D vma_uffd_ops(state->vma);
>
> +       /*
> +        * The normal page fault path for a MAP_PRIVATE mapping in a
> +        * file-backed VMA will invoke the fault, fill the hole in the fi=
le and
> +        * COW it right away. The result generates plain anonymous memory=
.
> +        * So when we are asked to fill a hole in a MAP_PRIVATE mapping, =
we'll
> +        * generate anonymous memory directly without actually filling th=
e
> +        * hole. For the MAP_PRIVATE case the robustness check only happe=
ns in
> +        * the pagetable (to verify it's still none) and not in the page =
cache.
> +        */
> +       if (!(state->vma->vm_flags & VM_SHARED))
> +               ops =3D &anon_uffd_ops;
> +
>         return __mfill_atomic_pte(state, ops);
>  }
>
> @@ -554,7 +574,8 @@ static int mfill_atomic_pte_zeropage(struct mfill_sta=
te *state)
>         spinlock_t *ptl;
>         int ret;
>
> -       if (mm_forbids_zeropage(dst_vma->vm_mm))
> +       if (mm_forbids_zeropage(dst_vma->vm_mm) ||
> +           (dst_vma->vm_flags & VM_SHARED))
>                 return mfill_atomic_pte_zeroed_folio(state);
>
>         _dst_pte =3D pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
> @@ -609,11 +630,10 @@ static int mfill_atomic_pte_continue(struct mfill_s=
tate *state)
>         }
>
>         ret =3D mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> -                                      page, false, flags);
> +                                      page, flags);
>         if (ret)
>                 goto out_release;
>
> -       folio_unlock(folio);
>         return 0;
>
>  out_release:
> @@ -836,41 +856,18 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaul=
tfd_ctx *ctx,
>
>  static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *stat=
e)
>  {
> -       struct vm_area_struct *dst_vma =3D state->vma;
> -       unsigned long src_addr =3D state->src_addr;
> -       unsigned long dst_addr =3D state->dst_addr;
> -       struct folio **foliop =3D &state->folio;
>         uffd_flags_t flags =3D state->flags;
> -       pmd_t *dst_pmd =3D state->pmd;
> -       ssize_t err;
>
>         if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
>                 return mfill_atomic_pte_continue(state);
>         if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
>                 return mfill_atomic_pte_poison(state);
> +       if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> +               return mfill_atomic_pte_copy(state);
> +       if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
> +               return mfill_atomic_pte_zeropage(state);

Thanks for this cleanup. :)

>
> -       /*
> -        * The normal page fault path for a shmem will invoke the
> -        * fault, fill the hole in the file and COW it right away. The
> -        * result generates plain anonymous memory. So when we are
> -        * asked to fill an hole in a MAP_PRIVATE shmem mapping, we'll
> -        * generate anonymous memory directly without actually filling
> -        * the hole. For the MAP_PRIVATE case the robustness check
> -        * only happens in the pagetable (to verify it's still none)
> -        * and not in the radix tree.
> -        */
> -       if (!(dst_vma->vm_flags & VM_SHARED)) {
> -               if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
> -                       err =3D mfill_atomic_pte_copy(state);
> -               else
> -                       err =3D mfill_atomic_pte_zeropage(state);
> -       } else {
> -               err =3D shmem_mfill_atomic_pte(dst_pmd, dst_vma,
> -                                            dst_addr, src_addr,
> -                                            flags, foliop);
> -       }
> -
> -       return err;
> +       return -EOPNOTSUPP;

WARN_ONCE() here I think.

Feel free to add:

Reviewed-by: James Houghton <jthoughton@google.com>

