Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1503CEB596A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 06:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2430A6B0005; Wed, 11 Feb 2026 01:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0086B0089; Wed, 11 Feb 2026 01:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1E76B008A; Wed, 11 Feb 2026 01:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF21D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:16:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 811C4C124F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:16:23 +0000 (UTC)
X-FDA: 84431166246.09.DDEDADF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2E487160005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:16:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ChOF3ywZ;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770790581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YkPanqxTe0ehKn/AVX6jzupRDYp87zz+QBp9N9tfSY=;
	b=Zgws/EKOtQ2U9RWJzVeqf55uqKFLZ4iHvZ0e/cnZOAiIjcs/v88Pdo65EC52Rr4QtLrX5U
	Ddv33EWZhm9SXeQjIb2IvpdzH56hTsrCFphIx2pL39fP5tvXywbPzuqqSt1PsqzHGkKsJP
	V5vUesI/BNR0vCwUG93oaz/mceywdYU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ChOF3ywZ;
	spf=pass (imf08.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770790581; a=rsa-sha256;
	cv=none;
	b=5FPbfdqtSVhdZlXwF9tYZ64LfZ6U03s+fS8/YH4XTX4FmRKJSMLZiA1A4FTse1A+9/bTmI
	0nNx5WZ4a70RTTF828XhPLN0uU2g695rUqFjjavcGv2xfXlgMWBNZGtYDbM4cDBnR9i4W+
	nzQ1PaQxFhW+dIUzincskzzX03DE+M0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770790580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9YkPanqxTe0ehKn/AVX6jzupRDYp87zz+QBp9N9tfSY=;
	b=ChOF3ywZuzI3v4AvugiYPHT1rasahDolJFDksw1OWWmOMAvmDMXEh6kcNsVfY5rsjtNRkg
	0RcEZH8DszawEP9dcfMSDSs1mgRWKihRcnMTxqEmYL3HeLdc57ioeSJYk/eN/nEL/aypDz
	VtTM9+E007VR1IagCG5tuyrXHo/0b5Y=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-2HMZPe3yNLibxjgq9fwTBA-1; Wed, 11 Feb 2026 01:16:19 -0500
X-MC-Unique: 2HMZPe3yNLibxjgq9fwTBA-1
X-Mimecast-MFC-AGG-ID: 2HMZPe3yNLibxjgq9fwTBA_1770790578
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-78fc790162bso62191767b3.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:16:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770790578; x=1771395378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9YkPanqxTe0ehKn/AVX6jzupRDYp87zz+QBp9N9tfSY=;
        b=tAWTm/NXP2DiKUunXZqy4g5tRWj2unt17pH6mCCPAFuRqtBpMSbh+dZ9Lfb5djPar4
         ne6OsZSh0VtUYeedLbPAjBzmHWcplTM5v158Feq+F/Jk8FprQe0oBwQIAm7jhHc64Qrz
         7hq8xsZip25M9rnyjPeCuurc3kNmyhMKnz95UCQNMS1OxKS9retdCvaDVSK9lbc1WbQX
         guiL34HybUEt6tQBpo8VXfQfcLk0BrhWgitR5+isHLZtviTAbgc7aOz/jSL5YO4oUcBm
         Yiuw+GYkpRSYOAktl+i2xXkcEjyjIARw2txQVILN0zztz3a+z4+I5daPwHl5TxhNMY2g
         W+hw==
X-Forwarded-Encrypted: i=1; AJvYcCXqyjoaI/iK2XuVdcy8fVmDNp+jbPsOCMU8ZgWFf3xCupRpHIUsrRnO14Cfg40raDCF3h97fIo8sA==@kvack.org
X-Gm-Message-State: AOJu0Yx35mzoWbXqCNhaMOtc2OTE9PuuJZN+z9AikAi+nx/5NgSBm4TY
	oK+DxIW3Pmc/H/8X0Fh2U8yfOAQaCxzHFMn0kdAvGPAXNcuV3o179/to5OEN1liho45yCj+ytOd
	hZjqhjseK7m4WlioX5e/0aICn2lCT+Y/w9wHi0D70eHyIQupbtIso/uHFCYVbgCePpF6M6H23+Q
	lr9jcLjAeKLGlXRd2qunwsCyvfWg4=
X-Gm-Gg: AZuq6aL1qgEmNRFfzF8rGLptDhA5/oDzIgkKVC3CxPIkvfO8KOVDlZ6Hzo4yYnvaoM7
	vaoaaiVQg2ZxTJLOxO3pOzgXf6Pz7jkT9hCpMyEStw1MiUipsJt3MNl76sVf8N94MZYokHAjYya
	roBDpS7kpT6I5gey9Gld383WzNMv5O3aRNK8s3AqBWm2tSaNJzxyJCpci2OZSz3dDeZCaWZLSVj
	VLH
X-Received: by 2002:a05:690c:c50b:b0:794:b5aa:9c71 with SMTP id 00721157ae682-7966aaa4a87mr12337647b3.34.1770790578548;
        Tue, 10 Feb 2026 22:16:18 -0800 (PST)
X-Received: by 2002:a05:690c:c50b:b0:794:b5aa:9c71 with SMTP id
 00721157ae682-7966aaa4a87mr12337537b3.34.1770790578186; Tue, 10 Feb 2026
 22:16:18 -0800 (PST)
MIME-Version: 1.0
References: <20260211031512.261127-1-senozhatsky@chromium.org>
In-Reply-To: <20260211031512.261127-1-senozhatsky@chromium.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 10 Feb 2026 23:15:52 -0700
X-Gm-Features: AZwV_Qh_iVpvEC5HEA7kAQ_X-Ds2o1CqyyYvsjm4JoFkdA9yHt0YUMrrpuO2d9I
Message-ID: <CAA1CXcA-V7FtK-QkyRHak1GBtepiFiTHFtF7g93P7mM41_2LMw@mail.gmail.com>
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s7sBp-70_h2O1QvRic5j1eLTzQts7kEzmDLPvXbxPtU_1770790578
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E487160005
X-Rspamd-Server: rspam07
X-Stat-Signature: m6y4o7fqcpsxp7iw8km4yex8m5ythey8
X-HE-Tag: 1770790581-261536
X-HE-Meta: U2FsdGVkX1+IpzE93TDISex3I5KieoLDus5RTxcwovLtxxCI8/bSn/x7A3JE4Lm79f9EERoliWeK+daEuF+DHhbrDxuB9dgm5xYJ9R2H6TraKiUWRIuHMpgk6fk+L4ndYrxFWlm/7nu0H9yqxLuNtx9648O6yG9ApHv1bAPm8zYA7H5HpnRglkwB4VCUkC8u8yYr+7L2X6+UJRuW8ocKpDujOyogCK9rxkJW44OBxhwKeXD+oCOPPrSvHpJ6aeeT/n4Vx3geh/kTbjz3HswJgJteRVstJFwHOjvT3neAr6zFOWjA2SIfKUgoNlnkvgLMBrqR8J8fwe1+qywn04zaz6g2VFQ9qAsHv8Um1O8/GyskxwoO0LDQt4tsA5c+fZpAtKlDSnt9EgK/8Me8BEOT+JzeX84YsguSckbL2mKcMuScCrxXaynHjgoo5qj9WtKaDE7L79oKrF5QF4O5rqrshWDgDZZ5rrQLA9qO/r5ZdeO79TnkJ5FvDQbTu0maY4I3tYI3lS21BkvKBQwdIlsteYE17hSosoJKoNeMdXjIpdxKsso8ZojahJbwhJTJnFx5khY6E5c1dGmhyt85X0jkO2f8RYXdGJ72wFnq9LwVsGtNgHEWuos1OD0X1j/SdwodmVTw2qO2UDpefuotykisCLcaQCcw0uCNTr8vmHohy/FLASjzPRE/x8ZsnK7ql4BGdNlCa4qPgSvJPazKZ0EN2S486ChhUtvnLDzueIWWlPaij419rto2yraEnq2Y5d92k6HMBoBKfF1swG97Oryw3JgEkqErxXrMloYx2Yz9BSP0u78Ik5X08Zln0mo/9Hi00LHzLSlvUGgurQBIbAWhBS+ENYKoxFKOnGm8z2DxKGQV9Vxk8fi4zEdm7vCEmkKAwkZRPdaRbeWl564DFv1BtBqnMEzIyzHfqQZWx9T6ZrdrsbY8e+5YXWagCVeqaeeIV5LjMB7SKgug5l2p9VW
 64USdS3H
 P+PGoC3OBpyHRUDRYw42gk8SoAWMOpFWtrHV4QwEtdzfWC0g+aOuRIKiXr2veBdxzKvI5Te3qv27EuhBB7jowATiVbpu7T++MmO2Y6JOskMZ7SzKJaV7ZpgE0IJvlYMFiUUEwO+k/0JDV/oti7pMHl0sZq8UgsmiFAnUA4YG84SViJxWx81+RrzZUpGE9zo8Vwvhkq0td0YTsZbY7SljSfJ//deNgo0wYy7lMQcSsxMpe4G1n16+rkjNH7NrUK+jRKMS/W4CI8fnXLcXj1SgbceAQ6UxaJdzwd0wAbqxNNr2O+PQhcI90ecExRQUUysCt3fEDVEh1V42hM4Eihw1EExFTMGwF+RMoRgGg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 8:15=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> A number of khugepaaged's loops, e.g. khugepaged_scan_mm_slot(),
> are time unbound, which can become problematic during system
> suspend:
>
> PM: suspend entry (s2idle)
> Filesystems sync: 0.003 seconds
> Freezing user space processes
> Freezing user space processes completed (elapsed 0.003 seconds)
> OOM killer disabled.
> Freezing remaining freezable tasks
> Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks r=
efusing to freeze, wq_busy=3D0):
> task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00=
004000
> Call Trace:
>  <TASK>
>  schedule+0x523/0x16a0
>  schedule_timeout+0x23b/0x6e0
>  io_schedule_timeout+0x3f/0x80
>  wait_for_completion_io_timeout+0xe4/0x170
>  submit_bio_wait+0x79/0xc0
>  swap_readpage+0x150/0x2d0
>  swap_cluster_readahead+0x3be/0x750
>  shmem_swapin+0xa7/0x100
>  shmem_swapin_folio+0xcd/0x2e0
>  shmem_get_folio+0x237/0x580
>  collapse_file+0x247/0x1280
>  hpage_collapse_scan_file+0x26e/0x380
>  khugepaged+0x43b/0x810
>  kthread+0xfb/0x120
>  </TASK>
>
> Make hpage_collapse_test_exit_or_disable() suspend aware so
> that khugepaaged's scan loops can terminate in a timely manner
> and let system enter the sleep state.
>
> Co-developed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Hi Sergey!

Thank you for reporting this and taking the time to investigate a fix.

Here are some simple review points then I'll comment on the code below.

- We usually send "To:" the mailing lists and "CC:" to all other people.
- Your subject contains "PATCHv2" there should be a space there
- It would be worth noting the "HOW" in the commit message

> ---
>
> v1->v2: Actually pass "cc" to hpage_collapse_test_exit_or_disable()
>
>  mm/khugepaged.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index eff9e3061925..d32a5ad27097 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct m=
m_struct *mm)
>         return atomic_read(&mm->mm_users) =3D=3D 0;
>  }
>
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *=
mm)
> +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *=
mm,
> +                                               struct collapse_control *=
cc)
>  {
> +       bool was_frozen =3D false;
> +
> +       if (cc->is_khugepaged &&
> +           unlikely(kthread_freezable_should_stop(&was_frozen)))
> +               return 1;
> +
>         return hpage_collapse_test_exit(mm) ||
> -               mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> +               mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
> +               was_frozen;

I dont really understand the freezer code, and there are few examples
of this. But given how other callers do it, this seems correct.

>  }
>
>  static bool hugepage_pmd_enabled(void)
> @@ -895,7 +903,7 @@ static enum scan_result hugepage_vma_revalidate(struc=
t mm_struct *mm, unsigned l
>         enum tva_type type =3D cc->is_khugepaged ? TVA_KHUGEPAGED :
>                                  TVA_FORCED_COLLAPSE;
>
> -       if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +       if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc)))
>                 return SCAN_ANY_PROCESS;
>
>         *vmap =3D vma =3D find_vma(mm, address);
> @@ -2420,7 +2428,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, enum scan_result
>                 goto breakouterloop_mmap_lock;
>
>         progress++;
> -       if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +       if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc)))
>                 goto breakouterloop;
>
>         vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2428,7 +2436,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, enum scan_result
>                 unsigned long hstart, hend;
>
>                 cond_resched();
> -               if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +               if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc))=
) {
>                         progress++;
>                         break;
>                 }
> @@ -2450,7 +2458,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, enum scan_result
>                         bool mmap_locked =3D true;
>
>                         cond_resched();
> -                       if (unlikely(hpage_collapse_test_exit_or_disable(=
mm)))
> +                       if (unlikely(hpage_collapse_test_exit_or_disable(=
mm, cc)))
>                                 goto breakouterloop;
>
>                         VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2468,7 +2476,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, enum scan_result
>                                 fput(file);
>                                 if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
>                                         mmap_read_lock(mm);
> -                                       if (hpage_collapse_test_exit_or_d=
isable(mm))
> +                                       if (hpage_collapse_test_exit_or_d=
isable(mm, cc))
>                                                 goto breakouterloop;
>                                         *result =3D try_collapse_pte_mapp=
ed_thp(mm,
>                                                 khugepaged_scan.address, =
false);
> --
> 2.53.0.239.g8d8fc8a987-goog
>


