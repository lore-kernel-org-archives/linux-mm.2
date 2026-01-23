Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D35FD74EE3
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB206B0501; Fri, 23 Jan 2026 10:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8696B0502; Fri, 23 Jan 2026 10:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAAA6B0503; Fri, 23 Jan 2026 10:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 976636B0501
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:25:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41DEB140351
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:25:38 +0000 (UTC)
X-FDA: 84363603156.02.D2385C7
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 132D040007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:25:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Im53rgdA;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769181936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zt7gqfG4H997WAPNAtB2/qQUO8vg1QiONhm0+kcWcYs=;
	b=OQMnWvdP6Lh+2xykR+lSPJx986AXTQ8gqaMyqyAtZBHvaWY6s/jTH7NIKFjCaURAV8WAVR
	I79NNOsE0vpfezcQJuDVIEkvxpsYEoUi9n5SMJAjkdzKrCi0LKtqMLG/GQdIkKmS0OaATi
	5AB/dg7qjEuOYXgO6jiwXR97UOp+mU4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Im53rgdA;
	spf=pass (imf07.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769181936; a=rsa-sha256;
	cv=pass;
	b=mUL+rB8mQ3/G7FdqNW/kbL36mWgUM8mDOmdQg79qZL8p6iHESoxHEQeD/hBsSUNJjx/Th5
	VL6dnVWMHnAau4fiD6Kz7AOR+uOBtegyVl4L/Pmqdq/Kl2aeNis2Rxd8QTz1/8y1UBTsjB
	mJ3YXVGzMO8luBC8pBFgd8BR33SHlN0=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59b6f267721so2058620e87.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:25:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769181934; cv=none;
        d=google.com; s=arc-20240605;
        b=Zyg9RYLpKxWk29siSf8fdQuvr5qfcmcp6y8E4aMwYgAcCg1tUJBB7j+R9Pvf8pQygT
         LWly6EQuuLmAIf+C8PmviqYBuUH6Wx7PUSa7Ib9WjSz9Cr+zzHIV/npZx/2J5oOIdoe3
         v2vTD6J7b165NI4hLjv29rf93i7IMFELHOeyxNCsVUZ1N1UZh0x9Wa0n8jRu9G4d0utt
         mT0YgMe88NTb0BiycsV50wVRZiVJqKihUNrwW+e+LV7hoJpSPLpVBlLikDJ4ROOtJIgq
         E558aTlrFWQfYaO5+yLQUeUflM4hAoZ6072OMI3z5EAtj9uetYRqrETo8+wvHK4Ewtr2
         DTgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zt7gqfG4H997WAPNAtB2/qQUO8vg1QiONhm0+kcWcYs=;
        fh=U7TCXS3K7dq4bqIODp5cJpi69KCEarpleHiPkdAJ/ac=;
        b=CjJfkrZVQUwNk5i9bqXnhXmppbrQBrT+4dGsfAgZOhAp6Nd82Ql2UlTE25y+LNjpVP
         FvAS0VKNwjndoA4GR+fqX+rQMFY+jMt6BhM38ZrpnC+o90e/ENnUtocsHCARuLxA5+Mt
         S/CbO2JFUAqa/VNEY+KfO3vzLLPJ3Ke1ORs7/0ExL7vWraiXRQGkNdbWWx17l8bF4QHX
         KwfKcgvZtHYHriL3TKeWWxB0qNguGYSD5J/vr47r8onX4h//drhqBEQBZfpRyvX/B2WH
         HxgPftWUDbXNNFGfV6RttnXk5uUiWB1HuxG6He+4x6E9V2UJlZbuG2kO5RK82lXhikvk
         09gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769181934; x=1769786734; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zt7gqfG4H997WAPNAtB2/qQUO8vg1QiONhm0+kcWcYs=;
        b=Im53rgdAi4s5CFpuh2NsbZVQVxYMdSUCaTrg7ALbkOIe/8ioHdW+KeH/6kdLtl1IdY
         R2/NAAtfglnRER/Jjw3CmE0QI1gsxas4rTPwBd9x807Qo7Ef1c1TlODEen8BluEQGiFp
         XKNpbIeRuJ1jGzfz4QOhzx1NU81eyUJktNtCSoZ1TVnEijyz98F3E4K35RREINnYyJOO
         6AYFX39Y+ffsn/vYH2WxpFCKunKcnqVhXxVRKfsw06tmEd1+jabDmz6mPbNPWH39KPY/
         PhmY+VHwWcdWhYpQfK9m+lpEGvST31gvU6a/Y34MI+b20lB1/OJgYHuTsA/v+9/PZBRn
         Tblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769181934; x=1769786734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zt7gqfG4H997WAPNAtB2/qQUO8vg1QiONhm0+kcWcYs=;
        b=R8cxu4TRmjzdCF6WA981fjyYeg/ELjVhTpfbttt1Ze2M9qFru/XPEF5PMxGIictQKq
         zQPjkmeHMJ0Hs9puSvN8l35Rs3/Ckjh9jct4BDhFfiGBz2WKzd+Bsh85LhpyipJBETb7
         padpyFrSk1kd/us0I5l4pIc5qWxsuUi9rE3If2rcq8YHMZwJtEeOZXsvujNzDoxUdKq9
         pW3k9b0gj/+X2VoVqYne/JlHiYtqld8yIDSsnVcPZ7vssABwVjiAvQfXq5ncL5u+UemG
         eLJYdXTFSF6x/D+gDRfS3FzwId7MLznj0lwzek9NKCkhISpLCg5F0liM62/xEL5WtHIh
         MujQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV/7tIB28cHmteNFEb03eXHlOxidEl7ZznO/MEK+77l/5YPD9v816439GkasoIW4t7xxsrn06LMQ==@kvack.org
X-Gm-Message-State: AOJu0YzDUfxeDGwBH8MGg1LU0fdmAhcGMDkdPn+sT6djCJ6hIWLG7wxN
	5XacxfXmcElCFwJ4rLwWf8UZ5Vf2Kxm3yyKBmct62S8W4sFC8KG80tvkiYgBjTWiaPNmEL6EWPw
	wgt1lbE3yY8WbgqO+3L2t/38tfNxK2DY=
X-Gm-Gg: AZuq6aKgHe0qbjxTmqO8ijBvJiPJdJ+QmPjkZ9040CClVPmYSunPGdrBE1a9eS5sJVH
	G0xSEc5HHe4syJ7CGoXsjhEtko0gueQ29HINMF3GBLxTvYa7RsXcqsEmugoGx+dfciaSEFWJdJI
	qr0UbzC62WrGhbG/W4mRN2ZeNZJUApE/a52KYY+tFst+jANQv3N7rwG3+euyFE032ZPHUbJpd5A
	60UxX4/hzwjTNAT9hw7cH9Lq0crIftttN+gqP14Sx2GRKkh51DqgmhKiKNN6115lK7E2tQ=
X-Received: by 2002:a05:6512:3ca7:b0:59d:e08e:143b with SMTP id
 2adb3069b0e04-59de4a2fb2bmr1087433e87.46.1769181933804; Fri, 23 Jan 2026
 07:25:33 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-3-vernon2gm@gmail.com>
 <98bdfd16-cb50-47a8-999a-bbd9829c6350@arm.com>
In-Reply-To: <98bdfd16-cb50-47a8-999a-bbd9829c6350@arm.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Fri, 23 Jan 2026 23:25:20 +0800
X-Gm-Features: AZwV_Qj_Hsh1Cu7nqkDGuL3XbUj3UumeepnWhQo0psdhCsf6bPC8yAN2FAejh9k
Message-ID: <CACZaFFN-dES3HuifdQTjfNr6P=EZQfYkt+O7V_rZ6+yC9Kf98Q@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 132D040007
X-Stat-Signature: qsawmk3iiy3yexohfraqaotrhd8z9dae
X-Rspam-User: 
X-HE-Tag: 1769181935-325770
X-HE-Meta: U2FsdGVkX1+dwZkOXj0oCWcSGqqZbMTeseLolxKchdOtSIRj5/IXH2FnFSylNDdX5g8GYHd4MgtvKUx9muGQA2iYa1/nHgPPCttpMIZ0hmvhZ+/m39hNOg6LTaJKQcoOnSQoy12A+LcXRm7ewSQH3BKthv+oPNkfvorO6Zuo+uCVKFcFpyRbwbFz7vDa0nJazmlJGcP57fY1pXmbMJ9ExZFZsypnoxOhGo/tBOuOdE5l12kX+ckN/f/XVK+hswYC9gp1VuNKTvqQ0KITKDeqB7Jx50XgAbdDWQhCkqNW+CzB6HLfcMgzEJFOfJXNFfBbrWELbZvFLNP/D+/CbZYftjOuXcbxImAvtDHC7uq/XUnjd/tdeK5KxXUt7naTZlbT08aDGbL+0j6Omjz+R1FKz1fzpJ2KMa8s8duk82SlZ/jnMqCPcBh4Rev5VWej3BHGEqf8GDZOfyDWewET4DTl0Jet48Vl42j51bFtiH+34L5n1Bh6sMERKfArB3DBSPEhNY/q5JsHeJ+cJ1hKrXRrDwplKCQOmRkT08BzVdaAeg9WmNkAM9O1l9WM3P1+kTAmMEzChbmf659DU2dYJXBFKBvxbkSedsUQsxK0nNFKyUwye8kVpvE4EGENRnOBrca5mPSkK92/ut+SC7sHvdMsUOJP0w4OlCVeNWY4KLwIpGFYfZtWyFhINPvCPhyjZF1zcCHC24QNUtBPJBCMdwpL+F4YMwyTjCBSSOQxMcmfPd+jx5zvujpag+pCuQYuib61lDZKX3IKhxa0rlkBLQP2LacXUbcc9ARlu7tD3V4YPI+QGYECRMgJCYrn13NbfVRa14uIJOohzgOoOX1c+QqfDFY8sZA2RQKgwy8Q8in6OhBeASwn7Kfh1KrJrp6un6LPBgwfkkYFegjqHA11YBLlP4/b8y558k+/usxA/BaOTTZIKsyt6LZFaMRj4S+mtSyio4X7SSOpsUwtmXZ9eOG
 OZAYH6+T
 qY4Svq6KAvI/V6G3WjWog4IHj1LTxRRlLpk6yGS5d7oadXbhrdqYFI3LAoD5KGcsCMm6o/TMUnhlKq+N+LyqRF1zsnOhJpQaBBigmP4dpDHuLX4THbkVmULarIcqT/wq3vZJjjkVhHImOKD7x28Q/fRTKAspFvm6dXBl+nvleOTjKW8gQ+kFdap53bEojY3cmG42vmpbUAWJtRNBpKCax/rrzTbkWc9qbBP1XO2qCc9lv3Nw7f11x6B+xOkVzsDD+mM5J4VfjsvCYuYbotNuEXLkorn/3VuOYCPPqu2XyJl47NhXeZcwL9stx/d36PwUJ4jFjYv82w0FEmfNRJnOpJUphsL2fX9FPKB2KQDp+QYhL09jrVFdI5vyriT8s+lLDD8NzZMlcaG5zheVC2ObmOr0am3uM2XaXxpO0Jz0prFVC1vZtLNsosQ5b9Um0I6kyfDH1nyUIv44LDsKPQdFT/jPSc2JxM55wP+riXr2XnQjJtcj+HaWbiGaUmJaqsCXzji7xjempu8iH6nQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 6:46=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> On 23/01/26 1:52 pm, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> > even if only scanning a single PTE/PMD entry.
> >
> > - When only scanning a sigle PTE entry, let me provide a detailed
> >   example:
> >
> > static int hpage_collapse_scan_pmd()
> > {
> >       for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD_NR=
;
> >            _pte++, addr +=3D PAGE_SIZE) {
> >               pte_t pteval =3D ptep_get(_pte);
> >               ...
> >               if (pte_uffd_wp(pteval)) { <-- first scan hit
> >                       result =3D SCAN_PTE_UFFD_WP;
> >                       goto out_unmap;
> >               }
> >       }
> > }
> >
> > During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> > directly. In practice, only one PTE is scanned before termination.
> > Here, "progress +=3D 1" reflects the actual number of PTEs scanned, but
> > previously "progress +=3D HPAGE_PMD_NR" always.
> >
> > - When the memory has been collapsed to PMD, let me provide a detailed
> >   example:
> >
> > The following data is traced by bpftrace on a desktop system. After
> > the system has been left idle for 10 minutes upon booting, a lot of
> > SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> > by khugepaged.
> >
> > @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> > @scan_pmd_status[6]: 2           ## SCAN_EXCEED_SHARED_PTE
> > @scan_pmd_status[3]: 142         ## SCAN_PMD_MAPPED
> > @scan_pmd_status[2]: 178         ## SCAN_NO_PTE_TABLE
> > total progress size: 674 MB
> > Total time         : 419 seconds ## include khugepaged_scan_sleep_milli=
secs
> >
> > The khugepaged_scan list save all task that support collapse into hugep=
age,
> > as long as the task is not destroyed, khugepaged will not remove it fro=
m
> > the khugepaged_scan list. This exist a phenomenon where task has alread=
y
> > collapsed all memory regions into hugepage, but khugepaged continues to
> > scan it, which wastes CPU time and invalid, and due to
> > khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> > scanning a large number of invalid task, so scanning really valid task
> > is later.
> >
> > After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> > SCAN_NO_PTE_TABLE, just skip it, as follow:
> >
> > @scan_pmd_status[6]: 2
> > @scan_pmd_status[3]: 147
> > @scan_pmd_status[2]: 173
> > total progress size: 45 MB
> > Total time         : 20 seconds
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/linux/xarray.h |  9 ++++++++
> >  mm/khugepaged.c        | 47 ++++++++++++++++++++++++++++++++++--------
> >  2 files changed, 47 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> > index be850174e802..f77d97d7b957 100644
> > --- a/include/linux/xarray.h
> > +++ b/include/linux/xarray.h
> > @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas,=
 unsigned long index)
> >       xas->xa_node =3D XAS_RESTART;
> >  }
> >
> > +/**
> > + * xas_get_index() - Get XArray operation state for a different index.
> > + * @xas: XArray operation state.
> > + */
> > +static inline unsigned long xas_get_index(struct xa_state *xas)
> > +{
> > +     return xas->xa_index;
> > +}
> > +
>
> Why is this needed?

Please refer to hpage_collapse_scan_file(), which obtains the starting
address of the last folio when exiting xas_for_each().

Using "xas->xa_index" directly is also acceptable.

> >  /**
> >   * xas_advance() - Skip over sibling entries.
> >   * @xas: XArray operation state.
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 6f0f05148765..de95029e3763 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -68,7 +68,10 @@ enum scan_result {
> >  static struct task_struct *khugepaged_thread __read_mostly;
> >  static DEFINE_MUTEX(khugepaged_mutex);
> >
> > -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> > +/*
> > + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> > + * every 10 second.
> > + */
> >  static unsigned int khugepaged_pages_to_scan __read_mostly;
> >  static unsigned int khugepaged_pages_collapsed;
> >  static unsigned int khugepaged_full_scans;
> > @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct=
 mm_struct *mm, unsigned long a
> >  }
> >
> >  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > -             struct vm_area_struct *vma, unsigned long start_addr, boo=
l *mmap_locked,
> > +             struct vm_area_struct *vma, unsigned long start_addr,
> > +             bool *mmap_locked, unsigned int *cur_progress,
> >               struct collapse_control *cc)
> >  {
> >       pmd_t *pmd;
> > @@ -1255,6 +1259,9 @@ static enum scan_result hpage_collapse_scan_pmd(s=
truct mm_struct *mm,
> >
> >       VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >
> > +     if (cur_progress)
> > +             *cur_progress +=3D 1;
> > +
>
> 1. Why do we need to do if (cur_progress). Isn't it guaranteed that the p=
ointer will never be NULL.

cur_progress is NULL at madvise_collapse()

> 2. Why do we increment this on function entry?

When the memory has been collapsed to PMD, we increment one only, same as
the previous PATCH #3 [1].

[1] https://lore.kernel.org/linux-mm/20260111121909.8410-4-yanglincheng@kyl=
inos.cn

>
> >       result =3D find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out;
> > @@ -1396,6 +1403,12 @@ static enum scan_result hpage_collapse_scan_pmd(=
struct mm_struct *mm,
> >               result =3D SCAN_SUCCEED;
> >       }
> >  out_unmap:
> > +     if (cur_progress) {
> > +             if (_pte >=3D pte + HPAGE_PMD_NR)
> > +                     *cur_progress +=3D HPAGE_PMD_NR - 1;
> > +             else
> > +                     *cur_progress +=3D _pte - pte;
> > +     }
>
> Why are two cases required here - shouldn't it just be _pte - pte?

At the function entry, "cur_progress +=3D 1", If this PMD is SCAN_PMD_MAPPE=
D
or SCAN_NO_PTE_TABLE, return directly. otherwise,

When "_pte =3D=3D pte + HPAGE_PMD_NR" to exit loop, HPAGE_PMD_NR
(also "_pte - pte") PTEs have been scanned, the "cur_progress" needs to be
incremented by "HPAGE_PMD_NR - 1".

When "_pte < pte + HPAGE_PMD_NR" to break loop, "_pte - pte + 1" PTEs have
been scanned, and "cur_progress" needs to be incremented by "_pte - pte".

> >       pte_unmap_unlock(pte, ptl);
> >       if (result =3D=3D SCAN_SUCCEED) {
> >               result =3D collapse_huge_page(mm, start_addr, referenced,
> > @@ -2286,8 +2299,9 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
> >       return result;
> >  }
> >
> > -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,=
 unsigned long addr,
> > -             struct file *file, pgoff_t start, struct collapse_control=
 *cc)
> > +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> > +             unsigned long addr, struct file *file, pgoff_t start,
> > +             unsigned int *cur_progress, struct collapse_control *cc)
> >  {
> >       struct folio *folio =3D NULL;
> >       struct address_space *mapping =3D file->f_mapping;
> > @@ -2376,6 +2390,18 @@ static enum scan_result hpage_collapse_scan_file=
(struct mm_struct *mm, unsigned
> >                       cond_resched_rcu();
> >               }
> >       }
> > +     if (cur_progress) {
> > +             unsigned long idx =3D xas_get_index(&xas) - start;
> > +
> > +             if (folio =3D=3D NULL)
> > +                     *cur_progress +=3D HPAGE_PMD_NR;
> > +             else if (xa_is_value(folio))
> > +                     *cur_progress +=3D idx + (1 << xas_get_order(&xas=
));
> > +             else if (folio_order(folio) =3D=3D HPAGE_PMD_ORDER)
> > +                     *cur_progress +=3D idx + 1;
> > +             else
> > +                     *cur_progress +=3D idx + folio_nr_pages(folio);
> > +     }
> >       rcu_read_unlock();
> >
> >       if (result =3D=3D SCAN_SUCCEED) {
> > @@ -2456,6 +2482,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >
> >               while (khugepaged_scan.address < hend) {
> >                       bool mmap_locked =3D true;
> > +                     unsigned int cur_progress =3D 0;
> >
> >                       cond_resched();
> >                       if (unlikely(hpage_collapse_test_exit_or_disable(=
mm)))
> > @@ -2472,7 +2499,8 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >                               mmap_read_unlock(mm);
> >                               mmap_locked =3D false;
> >                               *result =3D hpage_collapse_scan_file(mm,
> > -                                     khugepaged_scan.address, file, pg=
off, cc);
> > +                                     khugepaged_scan.address, file, pg=
off,
> > +                                     &cur_progress, cc);
> >                               fput(file);
> >                               if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
> >                                       mmap_read_lock(mm);
> > @@ -2486,7 +2514,8 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >                               }
> >                       } else {
> >                               *result =3D hpage_collapse_scan_pmd(mm, v=
ma,
> > -                                     khugepaged_scan.address, &mmap_lo=
cked, cc);
> > +                                     khugepaged_scan.address, &mmap_lo=
cked,
> > +                                     &cur_progress, cc);
> >                       }
> >
> >                       if (*result =3D=3D SCAN_SUCCEED)
> > @@ -2494,7 +2523,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> > -                     progress +=3D HPAGE_PMD_NR;
> > +                     progress +=3D cur_progress;
> >                       if (!mmap_locked)
> >                               /*
> >                                * We released mmap_lock so break loop.  =
Note
> > @@ -2817,7 +2846,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >                       mmap_locked =3D false;
> >                       *lock_dropped =3D true;
> >                       result =3D hpage_collapse_scan_file(mm, addr, fil=
e, pgoff,
> > -                                                       cc);
> > +                                                       NULL, cc);
> >
> >                       if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&=
 !triggered_wb &&
> >                           mapping_can_writeback(file->f_mapping)) {
> > @@ -2832,7 +2861,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >                       fput(file);
> >               } else {
> >                       result =3D hpage_collapse_scan_pmd(mm, vma, addr,
> > -                                                      &mmap_locked, cc=
);
> > +                                                      &mmap_locked, NU=
LL, cc);
> >               }
> >               if (!mmap_locked)
> >                       *lock_dropped =3D true;

