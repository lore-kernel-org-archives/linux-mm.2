Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DA0C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3D06B007B; Fri,  1 Aug 2025 11:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A256B0089; Fri,  1 Aug 2025 11:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A8D6B008A; Fri,  1 Aug 2025 11:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 951F16B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:12:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FE34802AF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:12:10 +0000 (UTC)
X-FDA: 83728529220.29.C2EFA1C
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 49AEA1A000F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:12:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MsfUnsBl;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754061128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoCvDf2STWqjlVzd+8uazfHv+yAfec07kh2ZhHKg+3g=;
	b=VcxNopjKiROV+LxxO420o4BJJcpt8w19ss3gtahJpP9lnOZgbh87VsY1lImMQMam+i55n5
	tuUy+HLDrmZR+lQprdNTFflW+AtLMeEA6+edDjiVQ6z64L0POewZwKrF2nlSP4d5bdSJkO
	VOfgil251DRKQF/54gcG30OfwukN1iA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754061128; a=rsa-sha256;
	cv=none;
	b=Vph0sB1aNJWYhHNP70UvQ3JCXEoshLBPh1/3FAANpspugJJHo80+wDUrsXlICDWHJ1/E/+
	/VM4uy495g2TlIe50Eun8Casfgr2zHMc1H1lYU3anFhsGx3KiLGKHN0mAuT1+5i4KRpm+Q
	onQR2GvKrTbp/UpBFKQLomttsnDzHI4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MsfUnsBl;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4aef56cea5bso186891cf.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754061127; x=1754665927; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SoCvDf2STWqjlVzd+8uazfHv+yAfec07kh2ZhHKg+3g=;
        b=MsfUnsBl4z8dKCQjyS+kgDER+eV4xhSZSXKlOTNJKn/lk9hnPhByBCmL+ZfPufR5Az
         ee75oFWioNa5KDXrFdhTywth5CQyDyPI0BlEACspmSwanXkI4XET7pOnoH4qJJbx8lhq
         qOy3Gvz02GvvGS4F3vYxJxrnYufJfSc7DwDf/vbT4bzmsS5iRmiKgR83xmixf+QzBI16
         hsG/s3vqLb36dshqCLNOFGShMIe7kmOG+mAANOs0Ma7NHMy3JRxI1O9wQrIgcc21k2TF
         8WQrKkjBppNqxRT6kXX1WNXMtEQAORR3fVWa/0rVmsET/WU9cFySxylqPFrkmUTiI3el
         wxHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754061127; x=1754665927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SoCvDf2STWqjlVzd+8uazfHv+yAfec07kh2ZhHKg+3g=;
        b=Tlx6oIVXNkF+EQ4DpcTGNK/cObnJndFZt4vf+dmZOQwdm2ArpotLKk23ilODfI7Agf
         6gL44ZSPg0rakx6Hd9C+Gd+n9+gRpWcgBlhin8H+Uuh1SF2Rv9RNgoha8YVt+sdWZF+4
         InnCXVmaG/0tVnpyqnnG+of+db+8JDSIVIDnB04QXjmZ6ISAft/PfW6f+/DCdITmlk6q
         Thy3dSHJnz0RPEiTqcu1DQes6n6F8WsRmIgyB+J4ldZmkvEX0yk512q453q1gi4+QEkK
         u3bKVqoyIfpPANdWbCflgGXPqzXo5gTKq7ENtrPpZtHZfpq1Id+7M81h9biSBQqhA/AD
         EPAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVB+X3k7BLplgOBKs/ZrUWYqMl/cC0vveTfysFoMvLttsumUbHVJO/Vb4OkCP1S0VoxDNMVzRnIWg==@kvack.org
X-Gm-Message-State: AOJu0YzY6S7fGXMmrWMJy7jnyttiE8nN5uN6gGzUQXH9or4olDuSCHbB
	OeCxlzw+QvuggT/MheUbiTzjw07g0o6qGyYqJeiIv3NivXtgDf6t3SYT9vRnfnMGTgwSN/7LxBl
	Z89eM7lexMa+zZEXonoFSQQu5vod+F5oD7lI5Sre3mtzG0fL513ZQCTpR
X-Gm-Gg: ASbGncvqrJZD+XhY2rNK6qdCefAbhChLO/ucpGjB6V6Qg/v3Sk9fxOarAIQoRPd/dLF
	MwUJFYzQ7FAMGWo9yxVBQ4hjLnAAtN3dYv6t9E5hNYw3RwCCtBEXedZmQY6nG9jA7ZRcFjkABnB
	dynlGX0TUzxgQZ+gdn9EnZR6Nm8qhIm6uU/aLCwI+5E6TnHECJFd/OXYQEY8rr5mnCCU0Dr9Oqt
	VXBqQiMfB1DZYxSRbtqF9QKpaLZ8ey4WyEH9A==
X-Google-Smtp-Source: AGHT+IEcXXFNQJXhQXaLDDs9kA4bqVnd84TK3sznmDH2mazS4z6rzXjrqdGlkijgDyhkzMQKRWnLp921znoYXPeBhuo=
X-Received: by 2002:a05:622a:86:b0:4ae:e478:268d with SMTP id
 d75a77b69052e-4af0079bc5cmr4436381cf.5.1754061126793; Fri, 01 Aug 2025
 08:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com> <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
In-Reply-To: <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 08:11:54 -0700
X-Gm-Features: Ac12FXwHTk6dY4NJRJgP0bh8zoHGQ_RejUiRmgYpnRzf77eWrvYI8LNs-_ARMGI
Message-ID: <CAJuCfpHkxe1Sb3jL6hK02+zQVFw7yOYte3BR5XDnHRvx7aTjNg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 49AEA1A000F
X-Stat-Signature: 79n165ey8b3qwewxfpm1s543gmo7rtd6
X-Rspam-User: 
X-HE-Tag: 1754061128-294105
X-HE-Meta: U2FsdGVkX19tBaJm9QZMZiSd3mE1r1KMc/Ed+jJDJvRXy1cJs87d5ksmIIkc+jVQrzfzTVTLZL91gRPTVcSa6OQYJPv/HQoxjpEraMcFSKT2NmjohCI/rYOzLVgE0ihvyAF0POQnl1hqofc2QpjPUVrnXa0YlfuaXbKSXrn1XJ414/L4CfxulJ1kuTXZ1VAVcdoRqHiKY8ko8vP1slNtfJullO+S9rtnZ/PyyD27R28ydMPO4NEF+q85wgthjrr00alt0NhKxhdS69VHT+c80cBytdkAn3MqMlAoEXmYwiZd3I43mHhT9Uoau5Mp2GHpa6O57Z+vcIDwKc7C2Dqw2gNv9/ZRAcxDuCCZNZ+y0Y2l5PrFo4L8LztCq/DOc+Pw4kKr1pqJWx9lnDFoO+ozI41i77Bm5vZRICVk4Hj2cb/bTYH/FR7+XU7L6vWsQGELffDCMjU53Gkoz4Gow1FGby9jkWEmxitp5pgS9Q56yXX8ICwFpfhKx6q7le5JyCXSk1mYqROr/46TeBRz/5sDt93NKDm7n37+o37NppQ/5nOVz8S3BjG4XRCJNByBisiaiCGS7bsdp46v4eplJUz90HvV1nr854VQpAdo/GWUwWabVi44Sm1Osuqie/0yWz66DD6SZ8BBA2RhDN9DUg3vW5RJTrK8qdAWSWfLM1KW8SByu5RbJfF1d602015Rr4IHgp1Uvz6+CyvyIJLicXUZ4dM+ebkW3Rr7i6kS6Y8rhHVGIsTqzXzUe6waxRJlHs2G3tM5W1kUQWzZ7bdBTGE2N2uBVTL5MyV2H0VlGINaDZeDncl33Hh+rl/VxwQt4xJlj7ONxT2w6dfa+HDbzVFudKEtIkVYtSkH+BdIcDNUkkwoxun+HjGbdle/qailAAd7wlRUu3bch80Mi56oBOSXxAlRB4zwEVprZ8jCSr9ZU+EbdEtUTCjCLAyNgZpzytdrwyLWE0zuNVSBnjyszyQ
 MqrpWkfS
 4WHfbYm6+1n7JNRncBxYq5RkOe/00Vr7QEawqTVyp4+H1Kqbh2Y3RObr68ctbo8sTg2mgcFSZmHsbvLwu2oXSRnr1tLQkT07EBDOGpdYQap0dlkjioWKE/dLa6cQc3uVKmM6LqLU1RFrt/hzSJbraEuEIw8Ur8bApj7SDkKxTYPNktutPYB6BijpIitzqldJpE07x7IJA6Sfpk8qQ0RN87i6dBKmIOXympU6+MV+8WSYDEo8frgNCiKUNUq7e6CQ5trSnTZT+WE6WPHRouiE59HO+8id5E198EO+8kyRWEd8aAt0QYys5w1bO8fQKYf+emgdTVVtBNRv2pMGMV84aPTQ9sfHRVSCFWaqHxLKkJQ2JX27XRLQ+XuqNC+czMN9xaH/7Fbr1xWCImwTB+2MFf3wWT75ey2tQ/ZNe6wCA7FwTZmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 7:21=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 31.07.25 17:44, Suren Baghdasaryan wrote:
>
> Hi!
>
> Did you mean in you patch description:
>
> "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
>
> Talking about THP holes is very very confusing.

Hi David,
Yes, "hole" is not a technical term, so I'll change as you suggested.

>
> > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > encounters a non-present THP, it fails to properly recognize an unmappe=
d
>
> You mean a "non-present PMD that is not a migration entry".

Yes, will fix.


>
> > hole and tries to access a non-existent folio, resulting in
> > a crash. Add a check to skip non-present THPs.
>
> That makes sense. The code we have after this patch is rather
> complicated and hard to read.
>
> >
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@go=
ogle.com/
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> > Changes since v1 [1]
> > - Fixed step size calculation, per Lokesh Gidra
> > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh =
Gidra
> >
> > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.=
com/
> >
> >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> >   1 file changed, 29 insertions(+), 16 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index cbed91b09640..b5af31c22731 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> >
> >               ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> >               if (ptl) {
> > -                     /* Check if we can move the pmd without splitting=
 it. */
> > -                     if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> > -                         !pmd_none(dst_pmdval)) {
> > -                             struct folio *folio =3D pmd_folio(*src_pm=
d);
> > +                     if (pmd_present(*src_pmd) || is_pmd_migration_ent=
ry(*src_pmd)) {
> > +                             /* Check if we can move the pmd without s=
plitting it. */
> > +                             if (move_splits_huge_pmd(dst_addr, src_ad=
dr, src_start + len) ||
> > +                                 !pmd_none(dst_pmdval)) {
> > +                                     if (pmd_present(*src_pmd)) {
> > +                                             struct folio *folio =3D p=
md_folio(*src_pmd);
> > +
> > +                                             if (!folio || (!is_huge_z=
ero_folio(folio) &&
> > +                                                            !PageAnonE=
xclusive(&folio->page))) {
> > +                                                     spin_unlock(ptl);
> > +                                                     err =3D -EBUSY;
> > +                                                     break;
> > +                                             }
> > +                                     }
>
> ... in particular that. Is there some way to make this code simpler /
> easier to read? Like moving that whole last folio-check thingy into a
> helper?

Do you mean refactor the section after "if (ptf)" into a separate function?
I was trying to minimize the code changes to simplify backporting but
since additional indentation changes this whole block, I think it does
not make much difference. Please let me know if I understood you
correctly and I'll move the code into a separate function.
Thanks,
Suren.

>
>
> --
> Cheers,
>
> David / dhildenb
>

