Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B850FE94619
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B89E6B0005; Mon,  9 Feb 2026 23:47:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262EA6B0088; Mon,  9 Feb 2026 23:47:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111136B0089; Mon,  9 Feb 2026 23:47:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 009046B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:47:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD3F91A0381
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:12 +0000 (UTC)
X-FDA: 84427312704.14.F6402F3
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8183640008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NtH4nNQX;
	spf=pass (imf01.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xh0cHnb2Uzw2254gJcy7ClMZ1utgFHkkePdFq3QRDkc=;
	b=prAt23JdwCcdhTyxtT4LiFZqycK7S6lLUmH+ZU65GFlPJVzZqAVzDGgDqQym9FbN4ypvyv
	EYUhG1n2zN6KB433GqiRyE7gv6tIcwKNOOP3c6rltgdvMzYsIgTt1btilM1Tml81Mgby67
	gxQ/68FTTRqeR/JRgfwgO1z4VmOJpG8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NtH4nNQX;
	spf=pass (imf01.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770698830; a=rsa-sha256;
	cv=pass;
	b=0gJu26S4OdzSUpCJySgvD/lK0sqSeR3cd4R1IE50UtWzvTYDeHV/1yAdHlsvr0X8pmT3MB
	sxgTmGHcVwY6HDzLiCqaq7/Vp7snnv31HR9XZ1CRxWQxAI6g+Ycrz9cs3lximv92PB82S4
	1vcFw6t8KovmsnEq2K1iSq8f57D3x0U=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806b0963a9so26015e9.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 20:47:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770698829; cv=none;
        d=google.com; s=arc-20240605;
        b=HfcW86/zUUxbWmK/wJf9RCO0NW5wRMBLq4ijic3JnrcnNY60RAK/5hAjpkijefbDPj
         a+1fihLJLuglg3W8JvH9g6ytrYQPqHXXQI01eXeMRlPBFgm1fqUgvdKDUh287V6EU7bz
         rgd3GUP2n4NSHsWGK3qUhxSW0Y1+bKMgLVtUUzAk2pyVfxHnz+cmHB4539cd77c6dILJ
         AheYK8vN2aWapzp0TjCBi/T85Et5P4WvojFsScxK0SQa0C68a2aBSz7iYl8tBpsBq36f
         LHUaa8Bl8cRM5nhZudWlrgDphJ9Ie3cwKtEMpDWZVnf5s2YTvQ1JpkezKNzpKR0A8z2W
         g+yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xh0cHnb2Uzw2254gJcy7ClMZ1utgFHkkePdFq3QRDkc=;
        fh=FbCpVPjPTwd7q6SxeiyM2m4oi9MA8fwx3ovzNGq0IXQ=;
        b=BYeokF64JxV1SV58p1RRoZ/Y+GtjGgODeBYSmGRQNsSzjgNnqSskcOgvSclRTs0lXy
         RqJbZktPefa2Zki22rbHwSZ2t/EVHzSB2dOCSJLEX2D5LVP4/F+wZ6fppjV7mUTGCIRr
         vtV6wjPbbZi5XFtIQ1wGR0zQngr2w3K3PijX93wmnFhfxnJ+ZOnbVTw2g0aURrmxCK8E
         k+WHVj7Dz84g5VFJ2wPGlT7C4NpO+hJxfAQ5PA5LmZNBH050iRvFMYC4ICFklCqOJ6cq
         ABwN45R27zqkYSNqAuF4fngmf3ezISUQM3MHll2Q+SRWFI2DszsBiz+6oy+zKHFyWlsS
         bixA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770698829; x=1771303629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xh0cHnb2Uzw2254gJcy7ClMZ1utgFHkkePdFq3QRDkc=;
        b=NtH4nNQXiVANMtfhgk20v0oPhZuk+NDxgvO6a5Ol9OtdZUAapwRQesfWhDbz+3tNC7
         XCbzXV0uR0A3N6Yu1fQa2sTWd+iPkNl/huYNC+YS5vPgiunLA34QCOqAitDjJwsGRUhD
         2HvSJ0fZm0fJ+gQ2hOpw7Y/wCS8ozWySTf7blTbMWQXx2DR4W4WhAw+SeWtKqzOm4XWQ
         6yrHqC3GnOIuDPFcTRwweqT48iQ55vZstjZv0vq07YEvTvkLsbffmjEaySihyzbDVG6J
         CTzXgiStfjgcq34XgZpXk9LZ93ReGFrD/eM2CZWlB9pVQJg8AZNthA1bOJ594YkTIHOs
         WQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770698829; x=1771303629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xh0cHnb2Uzw2254gJcy7ClMZ1utgFHkkePdFq3QRDkc=;
        b=ME6AO00heN6FPc+G65bgptg9iLF3+utjeIFOXtshn9GyHAGXfpCgd2UMU98DKO94qp
         rFdiDdDf1kP1TE3py7xvG3pdgB3qYJTO6GUk3TGfAGD/sclBVlJmtDLptSps5DV28yAj
         IKn1/dcNBuRn7l2BJhsYfgDIhuybafCrvfHE+m+xA0YlTn+vRCOVKMnCWmMg8IxlqD3v
         2NQp3hQsp2xNW4S3GOUKWZwnV+ZZ2zOlGS9t3QojJ3YtVhzfJsbfnnwe0PzwhR9/VfvL
         ptPNsVAoNDiFcHQd5gpsyEcSgMyFgVvW7zzA9mduToqc2Hkj01ifzDiLH1CHTMZGrwP7
         x9hw==
X-Forwarded-Encrypted: i=1; AJvYcCULNfZpnyoz8X1RzMCkrJogPISMTnCyXCZkIpit61GMr+kIAsjKKEu3yigsnBkOAz0uKcaQ9p38qg==@kvack.org
X-Gm-Message-State: AOJu0YzX/gDqMYGw1PckA23PqZHjOSqeaCJqP8N8HbWn+IpxgrVdUf21
	HgIqa/pVKHFMHyA6AD+5yLWYFP5m9pNWiejzkbEAgmtUY0sL2myUDD1FeY7R1LyouAxjfgUwnFM
	g7aa5sf/UMM8pZGKsmEZl8BYHrO1Sz0Mh01l1t7uP
X-Gm-Gg: AZuq6aIDsEJZtNLS/poanzKNePworeDxrgzSARNrDNZLMyD4g1PCRthzkaN/ttjkUgc
	5nzphX1geFecB7YZO6VhHrAKlJzpSR34oxcUdLV4pvdm/H4Aru7ZQoGHjwcVvJdJZ239tEiwsmJ
	ZaPGPsr/lG+4SGK/mBOWKBZmKf1UGBy87z9BwpyicYaSllmHBepju/36fLgy3diilxcF9LAgZM5
	cc9UBwXLU92Ce62k8n/MYh7I9CwCs7O3sBYL6xdamJl+16yj5qZFN3ctRRfv3PAioHqMt4Swhs/
	jlRUB7B3nZUlgl50MK1vHYvn0q9nYokJUBHzDRIR
X-Received: by 2002:a05:600c:a0d:b0:483:1093:f29b with SMTP id
 5b1f17b1804b1-4834efac31fmr722865e9.8.1770698828448; Mon, 09 Feb 2026
 20:47:08 -0800 (PST)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-2-jiaqiyan@google.com>
 <01d1c0f5-5b07-4084-b2d4-33fb3b7c02b4@oracle.com>
In-Reply-To: <01d1c0f5-5b07-4084-b2d4-33fb3b7c02b4@oracle.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 9 Feb 2026 20:46:57 -0800
X-Gm-Features: AZwV_QjV91dFot7ayh0f1ZjXLIniXMg-clH4kIMK48-lKWBdDzOW989Sj-GjMWQ
Message-ID: <CACw3F528fGutxsdiaA6ef6iP=O2hPVL0fuhwokvmOvbNVtsf+Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: William Roche <william.roche@oracle.com>
Cc: linmiaohe@huawei.com, harry.yoo@oracle.com, jane.chu@oracle.com, 
	nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8183640008
X-Stat-Signature: ph4raiase55mei6gnm4hs8cfduf5dcwy
X-Rspam-User: 
X-HE-Tag: 1770698830-13447
X-HE-Meta: U2FsdGVkX1+XEXLhxwo69UGrVN1XfZtbYyhs3K53DJWamtIe0l96SfKf9ADvDN2oGh3RXNMPlZSigr92A1cHkFzUZ2OKSVoC+fAjnlcBplMRZmwK/39wMPt1XAPr1+VcjyKVfMcHjCkntIdaJfREuTs8Qn3cgcmocHSHbH+wWwhEF6MnjnwWPH/dsrmfpqd6To56zJpjK6KQ+TOeIq1aQ+Mtmbq/GGsXYrI7hEhREFZrbA8l5hJ4rb1Ge4hoiLGIiuTMORJZf3XTITRI37YhyLJjYayqkuXTQVbOHjaZZj2NkPRvXn9u/vCczeBEuEviXbEAiWONsg5JkO9dg2Se0YwEde+8AJWEaCSQnglxqaSZo5uQ8Ei5lGZvshwaSi5XOYXO9STOrZhN+IUcB7bNsxX39e3FOxYin8b7vOQMsALttAsOLqGJ6KUEzSNTQn2kjgUCIWgVu0ciwAJ2JJ/y30WLOd9QL/MqwYAoCkoivWzZaQRXlVm7e+W+WOQG1ltqx1CAlgwKa6t4/oBvBuAM6bBVgpG2Oi21vbWoLbue+0AAsqRM1hFo4pL4mVd6TcEFyh1ZeftDw/PQ2yLTaM0N0/3yK76CinTUB3hqEAEEDujFFT9kd+4rBDaYSYW9y0c/ehcK7kWjddCjpdq6uEug/jKc3RYqPuFAUwiKyaZ+8+3l2drBnwdUgRYe+XcDFvPibkrRZGrsQtVflSJARELMr/b0ImXlHI/Mw/2U83gGN7hI+otQuCnj4sCIYFmqmw0p/rSq1FwmQ3Ufx/OH+vBjL2La0x/hze/uEHLnDaw9r7Z24mTxgQBG43+cM9ytllYn2s7PEbFEDg8TYoOKICX0RDfs36yU18SKJAKPZcOMZwrEhihXI9L0Hhw3S1QLfeYP1BB/aJPwRAtL1a4a2wKF+4lcxmCT5G0+MyrTVjQWY3pYe/GqTLIaSMwuKrYTXozI2G3Orc/HaQTrE27OXik
 Jf5jfttL
 a1WHp+n6HzB2WN0ZYqA+jGikh8qX2xg6P9u8Bx4mexBUS/ygLPlyh5L1RVNKxDy+vm8uo1rgK0bU+BNA8ZGXDL+ZdjaO2qtmvQQHGAeE04JZdjLku48Lk+8pS4TPN3ja2EeksDpzb3Tx8gVOZn1d254W01pEtn0thKXNYRSOFx8h2P+lxYSobdD61p2D+YlO0bsxUzK+quhHHLa3yb1eGw4iqylCPHFWXZejMltyo4X0i8scxvteWZ3dZzDnWTXdZ7bTYkX8twVoQ3+3EHujWIEtOI7jPB7UPH6E6bWfaCzClwMZzwQhwJ6DXUNSCrsYdQMYO84Ixco8DUhkMLh155S6Qd9ecca/HZUdG+hW2kvBy9VcCbsxX32jX4ptlj/Jue5StkAiFv+ofLJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 4, 2026 at 9:30=E2=80=AFAM William Roche <william.roche@oracle.=
com> wrote:
>
> On 2/3/26 20:23, Jiaqi Yan wrote:
> > [...]
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index 3b4c152c5c73a..8b0f5aa49711f 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -551,6 +551,18 @@ static bool remove_inode_single_folio(struct hstat=
e *h, struct inode *inode,
> >       }
> >
> >       folio_unlock(folio);
> > +
> > +     /*
> > +      * There may be pending HWPoison-ed folios when a memfd is being
> > +      * removed or part of it is being truncated.
> > +      *
> > +      * HugeTLBFS' error_remove_folio keeps the HWPoison-ed folios in
> > +      * page cache until mm wants to drop the folio at the end of the
> > +      * of the filemap. At this point, if memory failure was delayed
>
> "of the" is repeated
>
> > +      * by MFD_MF_KEEP_UE_MAPPED in the past, we can now deal with it.
> > +      */
> > +     filemap_offline_hwpoison_folio(mapping, folio);
> > +
> >       return ret;
> >   }
> >
> > @@ -582,13 +594,13 @@ static void remove_inode_hugepages(struct inode *=
inode, loff_t lstart,
> >       const pgoff_t end =3D lend >> PAGE_SHIFT;
> >       struct folio_batch fbatch;
> >       pgoff_t next, index;
> > -     int i, freed =3D 0;
> > +     int i, j, freed =3D 0;
> >       bool truncate_op =3D (lend =3D=3D LLONG_MAX);
> >
> >       folio_batch_init(&fbatch);
> >       next =3D lstart >> PAGE_SHIFT;
> >       while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
> > -             for (i =3D 0; i < folio_batch_count(&fbatch); ++i) {
> > +             for (i =3D 0, j =3D 0; i < folio_batch_count(&fbatch); ++=
i) {
> >                       struct folio *folio =3D fbatch.folios[i];
> >                       u32 hash =3D 0;
> >
> > @@ -603,8 +615,17 @@ static void remove_inode_hugepages(struct inode *i=
node, loff_t lstart,
> >                                                       index, truncate_o=
p))
> >                               freed++;
> >
> > +                     /*
> > +                      * Skip HWPoison-ed hugepages, which should no
> > +                      * longer be hugetlb if successfully dissolved.
> > +                      */
> > +                     if (folio_test_hugetlb(folio))
> > +                             fbatch.folios[j++] =3D folio;
> > +
> >                       mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> >               }
> > +             fbatch.nr =3D j;
> > +
> >               folio_batch_release(&fbatch);
> >               cond_resched();
> >       }
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index e51b8ef0cebd9..7fadf1772335d 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -879,10 +879,17 @@ int dissolve_free_hugetlb_folios(unsigned long st=
art_pfn,
> >
> >   #ifdef CONFIG_MEMORY_FAILURE
> >   extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
> > +extern bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
> > +                                             struct address_space *map=
ping);
> >   #else
> >   static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
> >   {
> >   }
> > +static inline bool hugetlb_should_keep_hwpoison_mapped(struct folio *f=
olio
>
> comma is missing
>
> > +                                                    struct address_spa=
ce *mapping)
> > +{
> > +     return false;
> > +}
> >   #endif
> >
> >   #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index ec442af3f8861..53772c29451eb 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -211,6 +211,7 @@ enum mapping_flags {
> >       AS_KERNEL_FILE =3D 10,    /* mapping for a fake kernel file that =
shouldn't
> >                                  account usage to user cgroups */
> >       AS_NO_DATA_INTEGRITY =3D 11, /* no data integrity guarantees */
> > +     AS_MF_KEEP_UE_MAPPED =3D 12, /* For MFD_MF_KEEP_UE_MAPPED. */
> >       /* Bits 16-25 are used for FOLIO_ORDER */
> >       AS_FOLIO_ORDER_BITS =3D 5,
> >       AS_FOLIO_ORDER_MIN =3D 16,
> > @@ -356,6 +357,16 @@ static inline bool mapping_no_data_integrity(const=
 struct address_space *mapping
> >       return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> >   }
> >
> > +static inline bool mapping_mf_keep_ue_mapped(const struct address_spac=
e *mapping)
> > +{
> > +     return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> > +}
> > +
> > +static inline void mapping_set_mf_keep_ue_mapped(struct address_space =
*mapping)
> > +{
> > +     set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> > +}
> > +
> >   static inline gfp_t mapping_gfp_mask(const struct address_space *mapp=
ing)
> >   {
> >       return mapping->gfp_mask;
> > @@ -1303,6 +1314,18 @@ void replace_page_cache_folio(struct folio *old,=
 struct folio *new);
> >   void delete_from_page_cache_batch(struct address_space *mapping,
> >                                 struct folio_batch *fbatch);
> >   bool filemap_release_folio(struct folio *folio, gfp_t gfp);
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +/*
> > + * Provided by memory failure to offline HWPoison-ed folio managed by =
memfd.
> > + */
> > +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> > +                                 struct folio *folio);
> > +#else
> > +static inline void filemap_offline_hwpoison_folio(struct address_space=
 *mapping,
> > +                                               struct folio *folio)
> > +{
> > +}
> > +#endif
> >   loff_t mapping_seek_hole_data(struct address_space *, loff_t start, l=
off_t end,
> >               int whence);
> >
> > diff --git a/include/uapi/linux/memfd.h b/include/uapi/linux/memfd.h
> > index 273a4e15dfcff..d9875da551b7f 100644
> > --- a/include/uapi/linux/memfd.h
> > +++ b/include/uapi/linux/memfd.h
> > @@ -12,6 +12,12 @@
> >   #define MFD_NOEXEC_SEAL             0x0008U
> >   /* executable */
> >   #define MFD_EXEC            0x0010U
> > +/*
> > + * Keep owned folios mapped when uncorrectable memory errors (UE) caus=
es
> > + * memory failure (MF) within the folio. Only at the end of the mappin=
g
> > + * will its HWPoison-ed folios be dealt with.
> > + */
> > +#define MFD_MF_KEEP_UE_MAPPED        0x0020U
> >
> >   /*
> >    * Huge page size encoding when MFD_HUGETLB is specified, and a huge =
page
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index a1832da0f6236..2a161c281da2a 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -5836,9 +5836,11 @@ static vm_fault_t hugetlb_no_page(struct address=
_space *mapping,
> >                * So we need to block hugepage fault by PG_hwpoison bit =
check.
> >                */
> >               if (unlikely(folio_test_hwpoison(folio))) {
> > -                     ret =3D VM_FAULT_HWPOISON_LARGE |
> > -                             VM_FAULT_SET_HINDEX(hstate_index(h));
> > -                     goto backout_unlocked;
> > +                     if (!mapping_mf_keep_ue_mapped(mapping)) {
> > +                             ret =3D VM_FAULT_HWPOISON_LARGE |
> > +                                   VM_FAULT_SET_HINDEX(hstate_index(h)=
);
> > +                             goto backout_unlocked;
> > +                     }
> >               }
> >
> >               /* Check for page in userfault range. */
> > diff --git a/mm/memfd.c b/mm/memfd.c
> > index ab5312aff14b9..f9fdf014b67ba 100644
> > --- a/mm/memfd.c
> > +++ b/mm/memfd.c
> > @@ -340,7 +340,8 @@ long memfd_fcntl(struct file *file, unsigned int cm=
d, unsigned int arg)
> >   #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
> >   #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
> >
> > -#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB |=
 MFD_NOEXEC_SEAL | MFD_EXEC)
> > +#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB |=
 \
> > +                    MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED=
)
> >
> >   static int check_sysctl_memfd_noexec(unsigned int *flags)
> >   {
> > @@ -414,6 +415,8 @@ static int sanitize_flags(unsigned int *flags_ptr)
> >       if (!(flags & MFD_HUGETLB)) {
> >               if (flags & ~MFD_ALL_FLAGS)
> >                       return -EINVAL;
> > +             if (flags & MFD_MF_KEEP_UE_MAPPED)
> > +                     return -EINVAL;
> >       } else {
> >               /* Allow huge page size encoding in flags. */
> >               if (flags & ~(MFD_ALL_FLAGS |
> > @@ -486,6 +489,16 @@ static struct file *alloc_file(const char *name, u=
nsigned int flags)
> >       file->f_mode |=3D FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
> >       file->f_flags |=3D O_LARGEFILE;
> >
> > +     /*
> > +      * MFD_MF_KEEP_UE_MAPPED can only be specified in memfd_create;
> > +      * no API to update it once memfd is created. MFD_MF_KEEP_UE_MAPP=
ED
> > +      * is not seal-able.
> > +      *
> > +      * For now MFD_MF_KEEP_UE_MAPPED is only supported by HugeTLBFS.
> > +      */
> > +     if (flags & MFD_MF_KEEP_UE_MAPPED)
> > +             mapping_set_mf_keep_ue_mapped(file->f_mapping);
> > +
> >       if (flags & MFD_NOEXEC_SEAL) {
> >               inode->i_mode &=3D ~0111;
> >               file_seals =3D memfd_file_seals_ptr(file);
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 58b34f5d2c05d..b9cecbbe08dae 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -410,6 +410,8 @@ static void __add_to_kill(struct task_struct *tsk, =
const struct page *p,
> >                         unsigned long addr)
> >   {
> >       struct to_kill *tk;
> > +     const struct folio *folio;
> > +     struct address_space *mapping;
> >
> >       tk =3D kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
> >       if (!tk) {
> > @@ -420,8 +422,19 @@ static void __add_to_kill(struct task_struct *tsk,=
 const struct page *p,
> >       tk->addr =3D addr;
> >       if (is_zone_device_page(p))
> >               tk->size_shift =3D dev_pagemap_mapping_shift(vma, tk->add=
r);
> > -     else
> > -             tk->size_shift =3D folio_shift(page_folio(p));
> > +     else {
> > +             folio =3D page_folio(p);
> > +             mapping =3D folio_mapping(folio);
> > +             if (mapping && mapping_mf_keep_ue_mapped(mapping))
> > +                     /*
> > +                      * Let userspace know the radius of HWPoison is
> > +                      * the size of raw page; accessing other pages
> > +                      * inside the folio is still ok.
> > +                      */
> > +                     tk->size_shift =3D PAGE_SHIFT;
> > +             else
> > +                     tk->size_shift =3D folio_shift(folio);
> > +     }
> >
> >       /*
> >        * Send SIGKILL if "tk->addr =3D=3D -EFAULT". Also, as
> > @@ -844,6 +857,8 @@ static int kill_accessing_process(struct task_struc=
t *p, unsigned long pfn,
> >                                 int flags)
> >   {
> >       int ret;
> > +     struct folio *folio;
> > +     struct address_space *mapping;
> >       struct hwpoison_walk priv =3D {
> >               .pfn =3D pfn,
> >       };
> > @@ -861,8 +876,14 @@ static int kill_accessing_process(struct task_stru=
ct *p, unsigned long pfn,
> >        * ret =3D 0 when poison page is a clean page and it's dropped, n=
o
> >        * SIGBUS is needed.
> >        */
> > -     if (ret =3D=3D 1 && priv.tk.addr)
> > +     if (ret =3D=3D 1 && priv.tk.addr) {
> > +             folio =3D pfn_folio(pfn);
> > +             mapping =3D folio_mapping(folio);
> > +             if (mapping && mapping_mf_keep_ue_mapped(mapping))
> > +                     priv.tk.size_shift =3D PAGE_SHIFT;
> > +
> >               kill_proc(&priv.tk, pfn, flags);
> > +     }
> >       mmap_read_unlock(p->mm);
> >
> >       return ret > 0 ? -EHWPOISON : 0;
> > @@ -1206,6 +1227,13 @@ static int me_huge_page(struct page_state *ps, s=
truct page *p)
> >               }
> >       }
> >
> > +     /*
> > +      * MF still needs to holds a refcount for the deferred actions in
>
> to hold (without the s)
>
> > +      * filemap_offline_hwpoison_folio.
> > +      */
> > +     if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> > +             return res;
> > +
> >       if (has_extra_refcount(ps, p, extra_pins))
> >               res =3D MF_FAILED;
> >
> > @@ -1602,6 +1630,7 @@ static bool hwpoison_user_mappings(struct folio *=
folio, struct page *p,
> >   {
> >       LIST_HEAD(tokill);
> >       bool unmap_success;
> > +     bool keep_mapped;
> >       int forcekill;
> >       bool mlocked =3D folio_test_mlocked(folio);
> >
> > @@ -1629,8 +1658,12 @@ static bool hwpoison_user_mappings(struct folio =
*folio, struct page *p,
> >        */
> >       collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> >
> > -     unmap_success =3D !unmap_poisoned_folio(folio, pfn, flags & MF_MU=
ST_KILL);
> > -     if (!unmap_success)
> > +     keep_mapped =3D hugetlb_should_keep_hwpoison_mapped(folio, folio-=
>mapping);
>
> We shoud use folio_mapping(folio) instead of folio->mapping.
>
> But more importantly this function can be called on non hugepages
> folios, and hugetlb_should_keep_hwpoison_mapped() is warning (ONCE) in
> this case. So shouldn't the caller make sure that we are dealing with
> hugepages first ?

I guess the WARN_ON_ONCE() in hugetlb_should_keep_hwpoison_mapped() is
confusing. I want hugetlb_should_keep_hwpoison_mapped() to test and
return false for non hugepage. Let me remove WARN_ON_ONCE().

>
>
> > +     if (!keep_mapped)
> > +             unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
> > +
> > +     unmap_success =3D !folio_mapped(folio);
> > +     if (!keep_mapped && !unmap_success)
> >               pr_err("%#lx: failed to unmap page (folio mapcount=3D%d)\=
n",
> >                      pfn, folio_mapcount(folio));
> >
> > @@ -1655,7 +1688,7 @@ static bool hwpoison_user_mappings(struct folio *=
folio, struct page *p,
> >                   !unmap_success;
> >       kill_procs(&tokill, forcekill, pfn, flags);
> >
> > -     return unmap_success;
> > +     return unmap_success || keep_mapped;
> >   }
> >
> >   static int identify_page_state(unsigned long pfn, struct page *p,
> > @@ -1896,6 +1929,13 @@ static unsigned long __folio_free_raw_hwp(struct=
 folio *folio, bool move_flag)
> >       unsigned long count =3D 0;
> >
> >       head =3D llist_del_all(raw_hwp_list_head(folio));
> > +     /*
> > +      * If filemap_offline_hwpoison_folio_hugetlb is handling this fol=
io,
> > +      * it has already taken off the head of the llist.
> > +      */
> > +     if (head =3D=3D NULL)
> > +             return 0;
> > +
> >       llist_for_each_entry_safe(p, next, head, node) {
> >               if (move_flag)
> >                       SetPageHWPoison(p->page);
> > @@ -1912,7 +1952,8 @@ static int folio_set_hugetlb_hwpoison(struct foli=
o *folio, struct page *page)
> >       struct llist_head *head;
> >       struct raw_hwp_page *raw_hwp;
> >       struct raw_hwp_page *p;
> > -     int ret =3D folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
> > +     struct address_space *mapping =3D folio->mapping;
>
> Same here - We shoud use folio_mapping(folio) instead of folio->mapping.
>
> > +     bool has_hwpoison =3D folio_test_set_hwpoison(folio);
> >
> >       /*
> >        * Once the hwpoison hugepage has lost reliable raw error info,
> > @@ -1931,8 +1972,15 @@ static int folio_set_hugetlb_hwpoison(struct fol=
io *folio, struct page *page)
> >       if (raw_hwp) {
> >               raw_hwp->page =3D page;
> >               llist_add(&raw_hwp->node, head);
> > +             if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> > +                     /*
> > +                      * A new raw HWPoison page. Don't return HWPOISON=
.
> > +                      * Error event will be counted in action_result()=
.
> > +                      */
> > +                     return 0;
> > +
> >               /* the first error event will be counted in action_result=
(). */
> > -             if (ret)
> > +             if (has_hwpoison)
> >                       num_poisoned_pages_inc(page_to_pfn(page));
> >       } else {
> >               /*
> > @@ -1947,7 +1995,8 @@ static int folio_set_hugetlb_hwpoison(struct foli=
o *folio, struct page *page)
> >                */
> >               __folio_free_raw_hwp(folio, false);
> >       }
> > -     return ret;
> > +
> > +     return has_hwpoison ? -EHWPOISON : 0;
> >   }
> >
> >   static unsigned long folio_free_raw_hwp(struct folio *folio, bool mov=
e_flag)
> > @@ -1980,6 +2029,18 @@ void folio_clear_hugetlb_hwpoison(struct folio *=
folio)
> >       folio_free_raw_hwp(folio, true);
> >   }
> >
> > +bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
> > +                                      struct address_space *mapping)
> > +{
> > +     if (WARN_ON_ONCE(!folio_test_hugetlb(folio)))
> > +             return false;
> > +
> > +     if (!mapping)
> > +             return false;
> > +
> > +     return mapping_mf_keep_ue_mapped(mapping);
> > +}
>
> The definition of this above function should be encapsulated with
> #ifdef CONFIG_MEMORY_FAILURE
> #endif
>
> > +
> >   /*
> >    * Called from hugetlb code with hugetlb_lock held.
> >    *
> > @@ -2037,6 +2098,51 @@ int __get_huge_page_for_hwpoison(unsigned long p=
fn, int flags,
> >       return ret;
> >   }
> >
> > +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio=
)
> > +{
> > +     int ret;
> > +     struct llist_node *head;
> > +     struct raw_hwp_page *curr, *next;
> > +
> > +     /*
> > +      * Since folio is still in the folio_batch, drop the refcount
> > +      * elevated by filemap_get_folios.
> > +      */
> > +     folio_put_refs(folio, 1);
> > +     head =3D llist_del_all(raw_hwp_list_head(folio));
> > +
> > +     /*
> > +      * Release refcounts held by try_memory_failure_hugetlb, one per
> > +      * HWPoison-ed page in the raw hwp list.
> > +      *
> > +      * Set HWPoison flag on each page so that free_has_hwpoisoned()
> > +      * can exclude them during dissolve_free_hugetlb_folio().
> > +      */
> > +     llist_for_each_entry_safe(curr, next, head, node) {
> > +             folio_put(folio);
> > +             SetPageHWPoison(curr->page);
> > +             kfree(curr);
> > +     }
> > +
> > +     /* Refcount now should be zero and ready to dissolve folio. */
> > +     ret =3D dissolve_free_hugetlb_folio(folio);
> > +     if (ret)
> > +             pr_err("failed to dissolve hugetlb folio: %d\n", ret);
> > +}
> > +
> > +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> > +                                 struct folio *folio)
> > +{
> > +     WARN_ON_ONCE(!mapping);
> > +
> > +     if (!folio_test_hwpoison(folio))
> > +             return;
> > +
> > +     /* Pending MFR currently only exist for hugetlb. */
> > +     if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> > +             filemap_offline_hwpoison_folio_hugetlb(folio);
>
> Shouldn't we also test here that we are dealing with hugepages first
> before testing hugetlb_should_keep_hwpoison_mapped(folio, mapping) ?
>
> > +}
> > +
> >   /*
> >    * Taking refcount of hugetlb pages needs extra care about race condi=
tions
> >    * with basic operations like hugepage allocation/free/demotion.
>
>
> Don't we also need to take into account the repeated errors in
> try_memory_failure_hugetlb() ?

Ah, looks like I haven't pull the recently commit a148a2040191
("mm/memory-failure: fix missing ->mf_stats count in hugetlb poison").

When dealing with a new error in already HWPoison folio,
MFD_MF_KEEP_UE_MAPPED makes folio_set_hugetlb_hwpoison() return 0 (now
MF_HUGETLB_IN_USED for hugetlb_update_hwpoison()) so
__get_huge_page_for_hwpoison() can return 1/MF_HUGETLB_IN_USED. The
idea is to make try_memory_failure_hugetlb() just handle new error as
a first-time poisoned in-use hugetlb page.

Of course for an old error __get_huge_page_for_hwpoison should return
MF_HUGETLB_PAGE_PRE_POISONED.

>
> Something like that:
>
> @@ -2036,9 +2099,10 @@ static int try_memory_failure_hugetlb(unsigned
> long pfn, int flags, int *hugetlb
>   {
>         int res, rv;
>         struct page *p =3D pfn_to_page(pfn);
> -       struct folio *folio;
> +       struct folio *folio =3D page_folio(p);
>         unsigned long page_flags;
>         bool migratable_cleared =3D false;
> +       struct address_space *mapping =3D folio_mapping(folio);
>
>         *hugetlb =3D 1;
>   retry:
> @@ -2060,15 +2124,17 @@ static int try_memory_failure_hugetlb(unsigned
> long pfn, int flags, int *hugetlb
>                         rv =3D kill_accessing_process(current, pfn, flags=
);
>                 if (res =3D=3D MF_HUGETLB_PAGE_PRE_POISONED)
>                         action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FA=
ILED);
> -               else
> +               else {
> +                       if (hugetlb_should_keep_hwpoison_mapped(folio, ma=
pping))
> +                               return action_result(pfn, MF_MSG_UNMAP_FA=
ILED, MF_DELAYED);

If hugetlb_update_hwpoison() returns MF_HUGETLB_IN_USED for
MFD_MF_KEEP_UE_MAPPED, then try_memory_failure_hugetlb() should
normally run to the end and report MF_MSG_HUGE + MF_RECOVERED.

>                         action_result(pfn, MF_MSG_HUGE, MF_FAILED);
> +               }
>                 return rv;
>         default:
>                 WARN_ON((res !=3D MF_HUGETLB_FREED) && (res !=3D MF_HUGET=
LB_IN_USED));
>                 break;
>         }
>
> -       folio =3D page_folio(p);
>         folio_lock(folio);
>
>         if (hwpoison_filter(p)) {
>
>
> So that we don't call action_result(pfn, MF_MSG_HUGE, MF_FAILED); for a
> repeated error ?
>
>
> --
> 2.47.3
>

