Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA529FF886F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C166B0005; Mon,  4 May 2026 08:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15926B008A; Mon,  4 May 2026 08:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5EB6B008C; Mon,  4 May 2026 08:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A39116B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:53:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 404F0C013E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:53:49 +0000 (UTC)
X-FDA: 84729729378.11.A6E2AD2
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 513F92000D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:53:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fVXirpAe;
	spf=pass (imf13.hostedemail.com: domain of anindyaandy1904@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=anindyaandy1904@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777899227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtBRvGpq/jySeR27STNy2HB45CKlQPEyoqkKZeyW1gU=;
	b=dxiTG+Lv67eggpQ2ZLvAlFl9kmMcU6UpX8+NowntmNXieCRVekNZB6TgKlu3LLbUQPDX2U
	R9tD/4E2HgSiZHXd7fRik/XhH5p1vT5BZyVFajCg+zhVB3bj+Zq5RAn96dc7/Uc9TWmjmx
	qPCxqvK10iTA4gnT0JvZglNS4d3ego0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fVXirpAe;
	spf=pass (imf13.hostedemail.com: domain of anindyaandy1904@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=anindyaandy1904@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777899227; a=rsa-sha256;
	cv=pass;
	b=kFKDT7srs1WoQtITfoa4V+WyDoqhuQUMVPG5tqohTEysWkPeFCX9ZKX47BeEzHfm8WSH0y
	D2MTO42gE3EfCQfFK8I8X+0BVaDq6oml+n0nkU6JuZBqVPkdFVG7ZpbV6RrLN/NiZnNUbD
	rb+2UEru8yz6xICqDiwFopE+Tg6ncUc=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7dcdd1b492eso4251169a34.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 05:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777899226; cv=none;
        d=google.com; s=arc-20240605;
        b=Z6Jlbh4EP3mvxIkvb8x1FJqYBZxXXwiif24Nq6wyV/RYdIz8CtQamTFwk1XuJav1A6
         2FOkdXybgPU+YobXEGd9DyZLn8yX8Hzei/g02K5bZ8ffnRADFRmel2DGytnela/lPVkW
         kr0n2BwanLXZsCQkatfU+Fwuu6MXOkvs1L8pv6H774kvUsFMyPPspS7lU4O+riD02Eyc
         r6BQqqQl0nT6HDBKq3Pzg2PSty6zoBcx8Gyj8EBFpT3sAy2RrfgvfTimweAZr6PC8eOh
         gKbFiWNL7WkN/dAUQpDej1YhOQlKKawzBDCO2tDpOTkOnataf+z6ji+ztht3/LUYNsBa
         pMlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NtBRvGpq/jySeR27STNy2HB45CKlQPEyoqkKZeyW1gU=;
        fh=AiMe30Q0EZJNQI2NAcBoADJO9QcphX02e1CRWs4z6no=;
        b=TCbkfp+5eSWwjzPOyR1gtktmzXxDiOXQ6QZOtW4mYZcemj9QBAsmmB6lSs4GjkPq8r
         vvqFrS5zZ8Qf1/HrcsewHcKstIshpQrvXGb5BtI1S6xQLET7RgDPVBjfObfbsiFMen5e
         jLlL7i31QP87/JtnlP0psrIS3uDRJQfvVLS/JYw2HP4gCvmKMjAGrwhWZ4FNNfG8O1w6
         dNmhv5BH6Q7Ho3015u3YizCfZFGTChUoUV3RL5GFxUxWfW1cMaxI0PCk3v8KwARjwwMD
         VKDEDKeXhp/b54H+JXJjkKm1SHf1tIPnw2wStiPFPXLzFFBNtrOdvAKQJ596FlJwsL45
         egFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777899226; x=1778504026; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NtBRvGpq/jySeR27STNy2HB45CKlQPEyoqkKZeyW1gU=;
        b=fVXirpAeH81Q7mBXNMseTPUTWG2ZjYKT5xfkkLaytPNieJ4O/vlNQKysQrUsUf1mnr
         2jNJvtEuhsnSDpcxbvye1uL4ws15/xJeK0kMc03M94JVrlDHzDSE1Wv9e2YhM1UFGK6t
         cUpsdmMLWUlPYkaAKdbFWXNvMEt0WMLHVPuSwpplWP72uphitpcokfn69WsosTEGo1ZB
         lglBQ3/fog6CvHDSKdFEads8s/HwcxAIvQ9RNpHnWRKR5bmGurl9/Mr+EP1b/ePCiA5u
         VCtUbcM/v7jiirC4OOx14YChMgXFsbEXKPkGXy7KNEZMZGCbEoT6hNhcj7oKnKH1OBTW
         /tXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777899226; x=1778504026;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtBRvGpq/jySeR27STNy2HB45CKlQPEyoqkKZeyW1gU=;
        b=ph7VeSOD9SsisdnT7vPa27p0SV4i1SKlt/z2YTbCqXcibxbiW1IzfG/H00fYtDfum0
         Wc/hglDbGXlToQqcghoWcWaIWbt+ZDMcSc5dsXBBKlCY/IHeS8X1IfqGAf5jUGObzvAT
         QWMtTIavlVJvu/ETw6bKWrkoDTYPP6hrVhXwpDHjo3hvihBDZn4k+0hifF8HW6ThdZ2I
         cUB35zy/ROx1lO9KBQ8nTLjd12PeJ4ydfqrupB17NHVQkgIboDuJbcSYenNu2SgmanQE
         2L02wNqVcd8w/O9YlleyHnkxa2TkBBk2dx+r+9VUegAQYFAMBwkiuEZqN8wOeQAQx4dl
         Y84w==
X-Forwarded-Encrypted: i=1; AFNElJ/Ms6T3Apmk5EkH6O7Ey3YETG57kEz2WiqJWzpXiGbPT9lxMachcOlTmv0lqisreoNt4IDAGOBKXw==@kvack.org
X-Gm-Message-State: AOJu0Ywjjv4TapVuwFvcnwgAvgjgI5o4wMo4dfnBQyQWyEaO8lA5kuyU
	iG1RQsqFbqI6SBM4TGgd5JkizLTZvEAuF4V+iRZe6teUbrdaIagyR6TpEpujDr/AmN6OwxbxfX/
	gf0/jTe2e8/g6zH6/eUOETjLZE9vG+Io=
X-Gm-Gg: AeBDievDQddG3LcT6i20CHlU5dYwoG0sJytV5j6hGb0GBdbtSQdX95Sr6S+c4mUlH0i
	RGPDg8d/gwZXGOWwk6evQtBzrvkHJZ4BFn/Tsb0YzIg5dDrgdVsjLJtlxkWODe6dq/RcfigwmL5
	crbpfb7XU5KmNcZ6jimlxGJZlANQirWA6EmyML9QfME05M3bRxDCP7TsmjPqQ3zWTKi/r0H/gLV
	hLJSJBHWS8mFzy+gnJPH5Qlst7TCT5dg4QZucbQWPiyQEM5iMVQkQgAO9n1sOI4HgODltEod2t6
	5IF4fMBj/akYxL75cLkw
X-Received: by 2002:a05:6830:6dd0:b0:7db:d6c8:a21a with SMTP id
 46e09a7af769-7debe2c92c5mr6671446a34.3.1777899226126; Mon, 04 May 2026
 05:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAMyZbw_ppC7F98+5huwmGjz03UGv8L8MoU9zL2_YYDU=fA3Qxw@mail.gmail.com>
 <20260502024012.30be89b2549bb18a1a1d0ddc@linux-foundation.org> <afZP-uhukndgjtO1@kernel.org>
In-Reply-To: <afZP-uhukndgjtO1@kernel.org>
From: Anindya Roy <anindyaandy1904@gmail.com>
Date: Mon, 4 May 2026 18:23:25 +0530
X-Gm-Features: AVHnY4L3CDkPWKtvv5v-ILoYjmxi7ZqbUbnSU4YsOdEPHi1FunPneiI2KqIHFzw
Message-ID: <CAMyZbw-AkzN13cwuuX60sjL=2NCK=9nDf+gr4Q-ZAn_XtnfDqw@mail.gmail.com>
Subject: Re: [SECURITY] mm/userfaultfd: cross-inode page cache injection via mfill_copy_folio_retry()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org, 
	security@kernel.org, linux-mm@kvack.org, lokeshgidra@google.com
Content-Type: multipart/alternative; boundary="000000000000d1dff60650fd6b72"
X-Stat-Signature: 4xqa9weod9nawsoakmp6agfh3j6mc73e
X-Rspamd-Queue-Id: 513F92000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777899227-960245
X-HE-Meta: U2FsdGVkX1/vf2QDRdgBH+MBBY3Mt5lcwrK7ZGGKnoc83I2570LE3hnDZDcTzPlVDNQzZBixPV/whDM8CzMr4oYOBODA7XTmfQ/lfy2uXWlTygMKBV6Sf1K9rbMR5ixek2X3NKTf8dLsoShf6KnNkQJUw0jxcCuFfVTAAY5R+9XOWHESTtl3F4/3PaYz3qr4+JPoAYnKkQjJH1l45UnvdY1Eq4S99+6biVXk4/PsfdFw9cwPdHSokm9G1dxCxM0fQ1cEYTOoKHBD+25C1ZY1TM51Lf/I+D6ykOQOBohBDYlAP2+QWgXLcaONfmOkDjU5jdQ2VVrPPZfdHbxBP8dmv2DgrNQqi0uYC2kkj3gorPi2mtd0ca0sP8XtB7v8LVjlETu411b1PGs/Mjbpf2CeYJAR1cB4mL611PYzHumwadoUuvkc7DQmpL3y35zvDkr75ttof4BMkoXW1XKAzblcd4uQhk7ZRWFO23nMeLMUPowWgt6zFnIRjgmgip/Yc6+ef+pNWv6mN6e//ZgYTA0RUVCDjBIC/T15CDvKrLjp+8QR9Rq1PHm58L8XcSvAllCewqNA7doiDWNFO1jkRVFRv5eCeC4KZse9TdAvy5Ihf5FfauxS11yNmhUQLvd29trsG/52R4bTdL83fOiQ/8Vp5wNBlGomWhIWwsKP7XdxF8QjA0L2BeA87qfHlm7gqZh0JPF5ySrHUJnatTebOlpnSvBrmHOHvFnFoBaj+dRz8xid9zQqpkG0xyP40/H04a74jpqVhlTZZYxkpo4slHCNMnqTY+BJIpfrfZr3h9Oe2b7/+m9T1ljFLLKrjs8FSZkzSWup0qMoLg247/j34NU7ZoyrYG5tYkWhubYuTVVf/xeFwuDLBHbLuqoLcxnLQf9MVjGMqklaV1FAqoG4NPbw/wD7dSezqiPash/0/SRdpCKNS4rYmRHSIl0R2tkodwgvy4pjCzFAaZsT2w2JLWl
 24Pn0wwq
 zl3UNWFkei17pfD8OsUWjCkQcMAuUbyP62Yh7AKmWpq34/aXAMQzSpAWu90zzSwTF19i6/lrgWHerGat43JbMzio032gcRPVQ8yfYAksyb1/D4UOV1/3YGEi1nVmxyqAIsq5/4KdAZILqgdgRjcpPkKy/qGiLu6/QzPPlg1DvLgAS1oCjQZ/bCzejA0Em89LwECrm/ZsInbfQXPCAihQK4wkMIJ29fQDwXXRtqvyg4M8Yh3aDWqNRXZe6i07X+01E1BUWrh7lAZcx7+ccddY1v4u7rVIfPPUIsEwcvg02tQcGRZ2Lw97l6hXJVo77CsCkkB/wCJLuo6t+CpwuhMqK40xvHn7obE4gZhlcIljyXxZ9j6d075xj9f8QQYX3snhugzlmOjja/rMn4RNLpsc02a3vqYWUgjMhfIDvaStBJNg+fi4pd0qcPIqKg8EPmSLJ93y8zjTlg8QS1+h6QLBxSZcuzj+An/yDQKSo1R2U3ZdnL1tiHAtqXl91RfNGsETGtr5/1H2u3f5gCMEBBJUsE+hELG5aLpxTcTbGZOIVrYuPKcCTWIx8fHcncSVMj2yb1+zOx0obEkjJIOUbGVk3R5bsTGMfG+95RaMSx5cUK+2+WFPklqidyIht4LRfrPL8rF1T8z1NUyVx3bZilIukvOQicw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000d1dff60650fd6b72
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mike,

To add context: I have a working proof of concept that demonstrates this as
a complete local privilege escalation, not just a theoretical primitive.

The current ops check does not prevent the injection when the replacement
VMA is shmem to shmem with a different backing inode. The PoC uses
/dev/userfaultfd to intercept the kernel retry fault deterministically,
swaps the destination VMA to a different file via mmap(MAP_FIXED) during
that window, and injects controlled contents into the replacement file's
page cache. A victim process reading commands from /dev/shm then executes
the injected payload, producing euid=3D0.

I can share the full PoC if that would help drive the fix forward.

Thanks.

On Sun, 3 May 2026 at 00:56, Mike Rapoport <rppt@kernel.org> wrote:

> On Sat, May 02, 2026 at 02:40:12AM -0700, Andrew Morton wrote:
> > On Sat, 2 May 2026 13:50:02 +0530 Anindya Roy <anindyaandy1904@gmail.co=
m>
> wrote:
> >
> > > Hello,
> > >
> > > I would like to report a vulnerability in the Linux kernel userfaultf=
d
> > > implementation that allows cross-inode page cache injection due to VM=
A
> > > replacement during the UFFDIO_COPY retry path.
> > >
> > > *Summary:*
> > >
> > > A local unprivileged attacker can inject controlled data into the pag=
e
> > > cache of a different shmem/memfd/tmpfs inode than originally targeted=
.
> > >
> > > This occurs because mfill_copy_folio_retry() drops all locks, allowin=
g
> the
> > > destination VMA to be replaced, but does not verify that the underlyi=
ng
> > > file (vm_file) remains the same when execution resumes.
> > >
> > > As a result, a folio allocated for one inode can be inserted into
> another
> > > inode=E2=80=99s page cache.
> > >
> > > *Affected component:*
> > >
> > > File: mm/userfaultfd.c
> > > Function: mfill_copy_folio_retry()
> >
> > Thanks.
> >
> > > *Affected versions:*
> > >
> > > Introduced by: f5f035a72423
> >
> > Only in 7.1-rc1, fortunately.
> >
> > May I ask how you found this?
> >
> > Annoyingly, Sashiko found it:
> >
> > : If the locks are dropped during the retry, can the anonymous VMA be
> > : replaced by a different type of VMA (such as hugetlb or shared shmem)
> > : at the same address?
> > :
> > : mfill_get_vma() accepts these VMAs and returns 0.  When execution
> > : resumes in mfill_atomic_pte_copy(), it proceeds to
> > : mfill_atomic_install_pte() using the newly populated state->vma.
> > :
> > : For a hugetlb VMA, mfill_establish_pmd() will allocate a standard 4KB
> > : PMD into a hugepage page table hierarchy.  For a shared shmem VMA,
> > :
> > : folio_add_new_anon_rmap() will be called on a shared file-backed VMA.
> > : Could this sequence cause page table corruption or kernel crashes?
> >
> > We must have simply failed to look :(
>
> We did look, we didn't reach a consensus
>
> David Carlier sent a basic fix for changing VMA:
>
> https://lore.kernel.org/all/20260328170101.184163-1-devnexen@gmail.com/
>
> then Peter suggested to take a "VMA snapshot" to verify VMA didn't change=
:
>
> https://lore.kernel.org/all/acrRRRT1xrAqNraj@x1.local
>
> and then David sent a patch that compared vma->flags and
> vma->vm_file->f_inode:
>
> https://lore.kernel.org/all/20260331134158.622084-1-devnexen@gmail.com
>
> but since comparing all vma->flags is overkill and could break existing
> userspace we decided to postpone this until after rc1 and only check the
> ops to ensure kernel won't crash if the VMA changes.
>
> As for me I'd check if we are retrying with the same VMA, but we don't ha=
ve
> a way to verify that :/
>
> --
> Sincerely yours,
> Mike.
>

--000000000000d1dff60650fd6b72
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><p class=3D"gmail-font-claude-response-bo=
dy gmail-break-words gmail-whitespace-normal gmail-leading-[1.7]">Hi Mike,<=
/p><p class=3D"gmail-font-claude-response-body gmail-break-words gmail-whit=
espace-normal gmail-leading-[1.7]">To add context: I have a working proof o=
f concept that demonstrates this as a complete local privilege escalation, =
not just a theoretical primitive.</p><p class=3D"gmail-font-claude-response=
-body gmail-break-words gmail-whitespace-normal gmail-leading-[1.7]">The cu=
rrent ops check does not prevent the injection when the replacement VMA is =
shmem to shmem with a different backing inode. The PoC uses=C2=A0<code clas=
s=3D"gmail-bg-text-200/5 gmail-border gmail-border-0.5 gmail-border-border-=
300 gmail-text-danger-000 gmail-whitespace-pre-wrap gmail-rounded-[0.4rem] =
gmail-px-1 gmail-py-px gmail-text-[0.9rem]">/dev/userfaultfd</code>=C2=A0to=
 intercept the kernel retry fault deterministically, swaps the destination =
VMA to a different file via=C2=A0<code class=3D"gmail-bg-text-200/5 gmail-b=
order gmail-border-0.5 gmail-border-border-300 gmail-text-danger-000 gmail-=
whitespace-pre-wrap gmail-rounded-[0.4rem] gmail-px-1 gmail-py-px gmail-tex=
t-[0.9rem]">mmap(MAP_FIXED)</code>=C2=A0during that window, and injects con=
trolled contents into the replacement file&#39;s page cache. A victim proce=
ss reading commands from=C2=A0<code class=3D"gmail-bg-text-200/5 gmail-bord=
er gmail-border-0.5 gmail-border-border-300 gmail-text-danger-000 gmail-whi=
tespace-pre-wrap gmail-rounded-[0.4rem] gmail-px-1 gmail-py-px gmail-text-[=
0.9rem]">/dev/shm</code>=C2=A0then executes the injected payload, producing=
=C2=A0<code class=3D"gmail-bg-text-200/5 gmail-border gmail-border-0.5 gmai=
l-border-border-300 gmail-text-danger-000 gmail-whitespace-pre-wrap gmail-r=
ounded-[0.4rem] gmail-px-1 gmail-py-px gmail-text-[0.9rem]">euid=3D0</code>=
.</p><p class=3D"gmail-font-claude-response-body gmail-break-words gmail-wh=
itespace-normal gmail-leading-[1.7]">I can share the full PoC if that would=
 help drive the fix forward.</p><p class=3D"gmail-font-claude-response-body=
 gmail-break-words gmail-whitespace-normal gmail-leading-[1.7]">Thanks.<br>=
</p></div><br><img width=3D"0" height=3D"0" class=3D"mailtrack-img" alt=3D"=
" style=3D"display:flex" src=3D"https://mailtrack.io/trace/mail/a33b40bca4b=
44c8e864d24cfd1d96f1d83a43bd6.png?u=3D12810248"><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Sun, 3 May 2=
026 at 00:56, Mike Rapoport &lt;<a href=3D"mailto:rppt@kernel.org">rppt@ker=
nel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-lef=
t:1ex">On Sat, May 02, 2026 at 02:40:12AM -0700, Andrew Morton wrote:<br>
&gt; On Sat, 2 May 2026 13:50:02 +0530 Anindya Roy &lt;<a href=3D"mailto:an=
indyaandy1904@gmail.com" target=3D"_blank">anindyaandy1904@gmail.com</a>&gt=
; wrote:<br>
&gt; <br>
&gt; &gt; Hello,<br>
&gt; &gt; <br>
&gt; &gt; I would like to report a vulnerability in the Linux kernel userfa=
ultfd<br>
&gt; &gt; implementation that allows cross-inode page cache injection due t=
o VMA<br>
&gt; &gt; replacement during the UFFDIO_COPY retry path.<br>
&gt; &gt; <br>
&gt; &gt; *Summary:*<br>
&gt; &gt; <br>
&gt; &gt; A local unprivileged attacker can inject controlled data into the=
 page<br>
&gt; &gt; cache of a different shmem/memfd/tmpfs inode than originally targ=
eted.<br>
&gt; &gt; <br>
&gt; &gt; This occurs because mfill_copy_folio_retry() drops all locks, all=
owing the<br>
&gt; &gt; destination VMA to be replaced, but does not verify that the unde=
rlying<br>
&gt; &gt; file (vm_file) remains the same when execution resumes.<br>
&gt; &gt; <br>
&gt; &gt; As a result, a folio allocated for one inode can be inserted into=
 another<br>
&gt; &gt; inode=E2=80=99s page cache.<br>
&gt; &gt; <br>
&gt; &gt; *Affected component:*<br>
&gt; &gt; <br>
&gt; &gt; File: mm/userfaultfd.c<br>
&gt; &gt; Function: mfill_copy_folio_retry()<br>
&gt; <br>
&gt; Thanks.<br>
&gt; <br>
&gt; &gt; *Affected versions:*<br>
&gt; &gt; <br>
&gt; &gt; Introduced by: f5f035a72423<br>
&gt; <br>
&gt; Only in 7.1-rc1, fortunately.<br>
&gt; <br>
&gt; May I ask how you found this?<br>
&gt; <br>
&gt; Annoyingly, Sashiko found it:<br>
&gt; <br>
&gt; : If the locks are dropped during the retry, can the anonymous VMA be<=
br>
&gt; : replaced by a different type of VMA (such as hugetlb or shared shmem=
)<br>
&gt; : at the same address?<br>
&gt; : <br>
&gt; : mfill_get_vma() accepts these VMAs and returns 0.=C2=A0 When executi=
on<br>
&gt; : resumes in mfill_atomic_pte_copy(), it proceeds to<br>
&gt; : mfill_atomic_install_pte() using the newly populated state-&gt;vma.<=
br>
&gt; : <br>
&gt; : For a hugetlb VMA, mfill_establish_pmd() will allocate a standard 4K=
B<br>
&gt; : PMD into a hugepage page table hierarchy.=C2=A0 For a shared shmem V=
MA,<br>
&gt; : <br>
&gt; : folio_add_new_anon_rmap() will be called on a shared file-backed VMA=
. <br>
&gt; : Could this sequence cause page table corruption or kernel crashes?<b=
r>
&gt; <br>
&gt; We must have simply failed to look :(<br>
<br>
We did look, we didn&#39;t reach a consensus<br>
<br>
David Carlier sent a basic fix for changing VMA:<br>
<br>
<a href=3D"https://lore.kernel.org/all/20260328170101.184163-1-devnexen@gma=
il.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/all/2=
0260328170101.184163-1-devnexen@gmail.com/</a><br>
<br>
then Peter suggested to take a &quot;VMA snapshot&quot; to verify VMA didn&=
#39;t change:<br>
<br>
<a href=3D"https://lore.kernel.org/all/acrRRRT1xrAqNraj@x1.local" rel=3D"no=
referrer" target=3D"_blank">https://lore.kernel.org/all/acrRRRT1xrAqNraj@x1=
.local</a><br>
<br>
and then David sent a patch that compared vma-&gt;flags and<br>
vma-&gt;vm_file-&gt;f_inode:<br>
<br>
<a href=3D"https://lore.kernel.org/all/20260331134158.622084-1-devnexen@gma=
il.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/all/20=
260331134158.622084-1-devnexen@gmail.com</a><br>
<br>
but since comparing all vma-&gt;flags is overkill and could break existing<=
br>
userspace we decided to postpone this until after rc1 and only check the<br=
>
ops to ensure kernel won&#39;t crash if the VMA changes. <br>
<br>
As for me I&#39;d check if we are retrying with the same VMA, but we don&#3=
9;t have<br>
a way to verify that :/<br>
<br>
-- <br>
Sincerely yours,<br>
Mike.<br>
</blockquote></div></div>

--000000000000d1dff60650fd6b72--

