Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A80BC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED89B6B007B; Thu, 31 Jul 2025 13:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E895B6B0089; Thu, 31 Jul 2025 13:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CE36B008A; Thu, 31 Jul 2025 13:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C82826B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:31:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C3A480DC9
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:31:02 +0000 (UTC)
X-FDA: 83725250364.12.F9F3A66
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 852DE180006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:31:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h5k8Aa/K";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753983060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTYZ6ctQGC42ES6NTcAXoMAQOzCvBSfMLOvM1LONwic=;
	b=sDzT3x8Cn/xkMW2996ro693f6oIlrU4O6nkYqf6OUdrONT8QsA3fHWTrA3MFPhuJcktMXa
	yjzQT54s/EeQKmRJ0aJ37acJ1I2o/layP6IJQSMWIysHv6VRv0Ab45lzObXIzR/phg7LPr
	IBRFhgBr6PnbtACKgNDGlAksl2e/zak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753983060; a=rsa-sha256;
	cv=none;
	b=C5kfG63xeyYx5fa9mOLn/TNJBRlw8PF5StNrqMM/J74imp1W7pKnGXC/0jnEpz0dZCrA7S
	ZmSo8LcpvQaokrr3UtDAdI8KHHwrWrGiqo+pNRjJP18IHD+yEysMPStOi77PKGtDkz9iIR
	iud4qDVE6w9af8QqFePcd8BUhf2XSYU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h5k8Aa/K";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6154c7b3ee7so860a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753983059; x=1754587859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTYZ6ctQGC42ES6NTcAXoMAQOzCvBSfMLOvM1LONwic=;
        b=h5k8Aa/KEjBErN7DGGU0TsWLCor4ipFom9H7hEky6m4EOjraieRMnptYb2nC5VUJ3G
         qX6mPHJENR1hsUHIb+dqlt2HcIatjI71eBZF1HWaoC0LNN+ynv5OqIZQoRnqZ3qyPXNO
         uFe4nMxClJqg36QGi34sFvvNgDT9z1IJZt4jDQKFkZoet/HoMK8QDu0XWb7eX3xakHoi
         2y/aPTWrVokW+DCzsYOY7sou2zPL3SrlTY5/0PD0pcvMqW04BXAiexCjMLrEkKbdBTbx
         HE0os1swSA/GyDpQ69Yk27/fLvyy6a+gwMfAbumn6wMNAhvy7LpV5qMOxbY0E/DTqoVL
         k9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753983059; x=1754587859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTYZ6ctQGC42ES6NTcAXoMAQOzCvBSfMLOvM1LONwic=;
        b=oXhAqcpvxxdufqo18aw/Y7Ryrqihj6fVZsz3CDFPRrb9RJXNLtSdO5caQ0nm3YX/AS
         QmzfvEkZ2FW3m92jkY8Fq33JbxdyEMmqMB8CvqSTsqS4Tu1TWt5PXEEdXdLcj8UZOBWA
         /2HkTH5a1LK8vGDLv0KPmQhzg9NGYZL7odszKGWXdvwWtH2U0yM9p7fsF8A52xSkNy2T
         gl4QJKYBDvf+sH6zxo02h1JopGgcHsw1I6XEMNP9cI1uFXrMJA+rHF7eCgsuNQD1xBlt
         odefWQ/RVA+wE/yHbEY0fH4gh7rpZlZfwV+kkc5/qe4rX7MkGdwcvtbdHfXShdNFZGmU
         P+JA==
X-Forwarded-Encrypted: i=1; AJvYcCUu5COIuUfvH63w6m/5oCtd0Jx6Wo/4A+D5e2zWRwBqqZ9Z+xb5ocjeCWQ8FGd+ORL5HplxQeIqkA==@kvack.org
X-Gm-Message-State: AOJu0YytX11ZgwA8D0yJSn+0pHC2s6IM0Z93t6+CbhBv53ug5jGrg8+M
	6ZwbS0YSJ3adUExx4WEzfLs3J89Dc8o8cBTZIuoBhp8znxIVJwxNMRETZK2f32OnUW5AzQMwY4J
	nwqZPT7jEgSynE2OuE7qERRcYFVtaB1vN5yVOiJcD
X-Gm-Gg: ASbGncsL9u8vEEYtRtfrzfGrMpCL3jcm6yjpwU0hvrXemww5MKIIVdSjrwG/v/I6dcM
	goXGCeMC2YFYkm69IUPSg9gDyYNGrwf1G6DLz/Rq4OVEbKlRQAGcSqt62h2Czkv6xeS8BwoTzLz
	z9CnREZ5ogi8G47TvEvCUZYyh3mrvmjYCyRol3OKaZ1StIgDRQuO9D/X0Yw+9i9JqSdPlQxXBZV
	M8/hsoEw0g9rDbUBY2AfTfCmgrXIUFdBMX5kEtMNQ==
X-Google-Smtp-Source: AGHT+IF1QJ83Q6c4dkzDCM2z6KKYFAxir5RDC4UAZQtNvYOpT4gEPwIqWv3dD6bsp3P9MtuExIQPvuxLjZH4h+ZidhU=
X-Received: by 2002:aa7:c687:0:b0:615:2899:a4e5 with SMTP id
 4fb4d7f45d1cf-615aeb102b5mr84457a12.5.1753983058516; Thu, 31 Jul 2025
 10:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com>
In-Reply-To: <20250731154442.319568-1-surenb@google.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 31 Jul 2025 10:30:46 -0700
X-Gm-Features: Ac12FXwZbn_-TO6sOPye9GKpC7g4hj7tbdyDuoXOlj14tXOv6tXKAlm_xFPsw5k
Message-ID: <CA+EESO4T-rYwmd_h3AxAkiiHgqcLQQzE1SmGNSGqOFbGvEShGg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@redhat.com, 
	aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 852DE180006
X-Stat-Signature: eoxnk4aqjeczfaaoughxb7xw16tkzgpf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753983060-671253
X-HE-Meta: U2FsdGVkX1/Hz3Sm9mNZBUVJbLGNkhqtlQWwy8Ufq30T4AIZKHnK7zJv4S7miUyPmyDuPEetRcBwScMPBBewKLpa9eM+yXmBvzBdigEVPILnjHE8PftT5Y4EsEAIVZO/pbZnt6o8hgtOGhcs1MkOHFuG14RpMT0aZg1UXEnL8GJvOPmbNXMkYRdyA1wO8uo0tXQO5Umj1nxHXtqTWW/nztM7HfL4Xp4KZsEiWTF79p3pJK5AeKeLkW8WNtwaNs5uBOYn97xVq/qQF2R5IfqwGmpix+8vgkrKZxqWgeICuzFwDFvlF+vscWMRsKelStPIcNyELoor61wIdmkNm6/sMan6byyc959TlvM06QIF7O+6asaCslSGYQNhoEKXTLl3rmSMDyx8E4D2INzxdR/IC32mswjunWpokEkTjDIgtLXvs3l1DvyjZzFum32HPdyS3MC1YZd2B75vgn4K/R34YiIiHMDWQ6ezfOtCraYypaVFg33LNmP8Puhos33Ew7y8miBVv7oJ4Q+WW5XGquT3/RYPlY5yDXiEQwKDWJFo9XEDY/wym61p1ZCTHXJ4kHlnQaTVCi6cG9/h90nLPXykx03nAo5EaACAo3S5qS4irrq4pQp/WUEgh1xMgM8DBtdMwDFp6GTOIKC5A7Ukkqu2QgkcNc3/Ztpxb+25x/4KqkMhjyiKg8gnp+PW/WRk+LbjjoXec3m1VnXgk8AdiwuUlK5tcQoHZFA19WUSkK0zbfulrUhZ/zZ29VLMqBuf12DNABZepshJFYUE/Utw9e063G504J9taUhkrU4G/7xM09io5Ax0uV2ULMeTGv4HmQGl96yywpxKqGnHdhz8LTJC/g0TPzKUzH/xzeDox0JyP3kIf2DcCjUKsVtlow2UVFEKWLqFdaD8rkfJM2sYTCFTq++qnWRIsV5pVh/I+dfkNKuwIKW8DexCTn8MJ5egMLmh2nQsxg/mtRTyqIvBMku
 /74qkTmW
 RaiotAWkE3tA9VQP3xOFViVu/17jxL6Fw1XjPjLJkpZVPiQqDhbQN1hpakDN9MEyb9ERI9PYzaJmn7UowAN19QXLz0A2dNst9q5jFZOgjcARZnsnO2wG3D+RcUEi3UyxeOV8j9sQddCWTpNzWYYVG513UAG3iy6kcIn8auttNrQvSIxcXxrwBxNAgrgyu3d7SqqtEbnomsDxjWa15HDZLCuSp933oqYjii+Yu+DpIN6RNwrvm7F7Bj9ezWxxf4NFRNrGQ7hk2c7OsuSjKcDf0VBMYJej6mh1vyy7DL+WF2TF6RIhkeU0Gp/gngqtIlYJCODXJNVxV4ucLvYzJALLd1BJ5DkjfnWgbH6d9jtVQ9R/VKXvytZaRAeBeRRikmF4FeSguH/se4wBQr5S6uSUDmLwXxvNc5sBBuID/33TGr0VRZIzDtZTb+up0TQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 8:44=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> encounters a non-present THP, it fails to properly recognize an unmapped
> hole and tries to access a non-existent folio, resulting in
> a crash. Add a check to skip non-present THPs.
>
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@goog=
le.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Lokesh Gidra <lokeshgidra@google.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v1 [1]
> - Fixed step size calculation, per Lokesh Gidra
> - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gi=
dra
>
> [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.co=
m/
>
>  mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
>  1 file changed, 29 insertions(+), 16 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index cbed91b09640..b5af31c22731 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
>
>                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
>                 if (ptl) {
> -                       /* Check if we can move the pmd without splitting=
 it. */
> -                       if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> -                           !pmd_none(dst_pmdval)) {
> -                               struct folio *folio =3D pmd_folio(*src_pm=
d);
> +                       if (pmd_present(*src_pmd) || is_pmd_migration_ent=
ry(*src_pmd)) {
> +                               /* Check if we can move the pmd without s=
plitting it. */
> +                               if (move_splits_huge_pmd(dst_addr, src_ad=
dr, src_start + len) ||
> +                                   !pmd_none(dst_pmdval)) {
> +                                       if (pmd_present(*src_pmd)) {
> +                                               struct folio *folio =3D p=
md_folio(*src_pmd);
> +
> +                                               if (!folio || (!is_huge_z=
ero_folio(folio) &&
> +                                                              !PageAnonE=
xclusive(&folio->page))) {
> +                                                       spin_unlock(ptl);
> +                                                       err =3D -EBUSY;
> +                                                       break;
> +                                               }
> +                                       }
>
> -                               if (!folio || (!is_huge_zero_folio(folio)=
 &&
> -                                              !PageAnonExclusive(&folio-=
>page))) {
>                                         spin_unlock(ptl);
> -                                       err =3D -EBUSY;
> -                                       break;
> +                                       split_huge_pmd(src_vma, src_pmd, =
src_addr);
> +                                       /* The folio will be split by mov=
e_pages_pte() */
> +                                       continue;
>                                 }
>
> +                               err =3D move_pages_huge_pmd(mm, dst_pmd, =
src_pmd,
> +                                                         dst_pmdval, dst=
_vma, src_vma,
> +                                                         dst_addr, src_a=
ddr);
> +                               step_size =3D HPAGE_PMD_SIZE;
> +                       } else {
>                                 spin_unlock(ptl);
> -                               split_huge_pmd(src_vma, src_pmd, src_addr=
);
> -                               /* The folio will be split by move_pages_=
pte() */
> -                               continue;
> +                               if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_H=
OLES)) {
> +                                       err =3D -ENOENT;
> +                                       break;
> +                               }
> +                               /* nothing to do to move a hole */
> +                               err =3D 0;
> +                               step_size =3D min(HPAGE_PMD_SIZE, src_sta=
rt + len - src_addr);
>                         }
> -
> -                       err =3D move_pages_huge_pmd(mm, dst_pmd, src_pmd,
> -                                                 dst_pmdval, dst_vma, sr=
c_vma,
> -                                                 dst_addr, src_addr);
> -                       step_size =3D HPAGE_PMD_SIZE;
>                 } else {
>                         if (pmd_none(*src_pmd)) {
>                                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_H=
OLES)) {
>
> base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
> --
> 2.50.1.552.g942d659e1b-goog
>

