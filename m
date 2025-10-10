Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A19CCCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDAA8E0009; Thu,  9 Oct 2025 22:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5C48E0002; Thu,  9 Oct 2025 22:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB618E0009; Thu,  9 Oct 2025 22:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 474F08E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:34:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04C81140135
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:34:06 +0000 (UTC)
X-FDA: 83980634934.13.0B1F50B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E5C59140002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:34:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dhZtLNWW;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760063645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dk5g4E0pi6CaTMbbnIcHXV1D2lUpzZlT33d3PjipDL0=;
	b=AoiWvHpy2Em7iwuHrYiRUiODNw1f2V/CAdZ2fraQgRGTy+HSElIapkVnt7j4/xAfdwAL61
	tF3/6GkjPUtiLdygXPbZsjcGYSyMR/PjDgUjjA3DMKiy1sItaBKv311qV3UCTyLz/g1q1Y
	gorU0RrDagfe+IU1POYYUZYEgCKXSc4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dhZtLNWW;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760063645; a=rsa-sha256;
	cv=none;
	b=A/knsrD3v4B6Al/nhS7CwSHLRTdVToKswaiw6GUaWqGdJB5XbkgQ0kP5UKldVa8QJ5k3WA
	fdF5MiCe3Cdrt5ywvNTNmJi8aRGH+5ai7c3fz9V1k+B7aEnKOYoWYA31LywXng4exaNyVZ
	bXSs+VCTWOFx8Dm3XOSvXBR4e25ATMw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83C93490C8
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EDFC113D0
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760063643;
	bh=s7oTfnFp9x/xps66UrNaurNxraa06/mt/HUxQX5Oe34=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dhZtLNWWAGDa78l9MJ4HJWFuMZErJXIgMYrgMoXaCpVPRxnmwAJFvx8oS0uN7snJE
	 1cmm+KIiWXhP5/OARDpib/rsor0iPyORbZmW55PRqvpE8oCDwFxjdH3nrnN4flLLsj
	 s4bTcjHVqFMMMf+URIAcmoRYSsDxfsptbkVsokFKyrwtFyo6jRlr7vu8I8FJ6hdQxt
	 85I9ldm7YGVMnK+f3kZzdkQtgjfJt2GDqJ/TbjdoLqX01vGgY2Xe6NGCLNPTk+TD/B
	 vdhNJycsNdgCImD+Z/EI0Fjz0IZcht6q6Lqs8ISdcQWBQqIt/W53/IqR97cMj2Zui4
	 smWv+MFA3k/IA==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-633b87e7b9fso1576686d50.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 19:34:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX8EDT4mqeRhA1mTB+UAV27BEHOZ6GoepNE8CMH3Dbp7KvbpmwDr9dZT95phm2BSS136hwkpvnfog==@kvack.org
X-Gm-Message-State: AOJu0YxN89MnKO3cpwQ8TtlknG4uMX/QPdB5CkeV8H6CPRVitugx7FAO
	8rkLVrH++lVhKzeA2WectbubEgIwhbCLVTGoL2iWrAxy1ziBBQbPlN2F8JGe/Ya1FHg5wW0CVKA
	YuN5Wz8DIsFu9pNOUGjFaOwCLHLj9mLu2IGjm/x0ZbA==
X-Google-Smtp-Source: AGHT+IE05dozEBFY/dl7KjSP9vOFCO6QNZ3NykuLbJdxMDAt5B16X167/UAh81GTR11s7oMovh1d4WflO9F5eYh9oAg=
X-Received: by 2002:a53:db49:0:b0:628:9b45:5e29 with SMTP id
 956f58d0204a3-63ccb851f46mr7842592d50.15.1760063642579; Thu, 09 Oct 2025
 19:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
 <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv> <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
In-Reply-To: <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 9 Oct 2025 19:33:51 -0700
X-Gmail-Original-Message-ID: <CACePvbVPW9FMjWcx55ebMpd8AwCJAK0w8Y0Oec1TpJX8SoUhCg@mail.gmail.com>
X-Gm-Features: AS18NWDFxoIRg7ez6WvKhJVHKDPtBOrrQTDq5COWX3zIk-jaZjzDv8RtlhWI8g4
Message-ID: <CACePvbVPW9FMjWcx55ebMpd8AwCJAK0w8Y0Oec1TpJX8SoUhCg@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 13mothtx5x597rkrw36jgoiz715taaiq
X-Rspamd-Queue-Id: E5C59140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760063644-507011
X-HE-Meta: U2FsdGVkX19kbhJsqGmOnHCDvr0zknM2UGiKLaQtNKWafIH8p6PfnM5wBQQ79yJtAT1W2t3irquC9hIK/7nnbEzTNYlY11AWa7f5ziRlzVRkm7wukKNqIrLgTwXGde6rnL+KrHQNID2zsIgIBGq6Wvw/HMU1tAgIIqD9Y9wfYN3IjbD8QEuduPRsYkTmk0M97KMxucWvYeEvfMLo9rMm5fdEqN2gGDLy9/d9ZTHl6QtS2rbz0f7odYrbEHmPxgk77aahSkgU7OlqDyAyHeXCNmAE4SbwTY2+eFLqkhJdgGAdRwNB6qXl3Zcrr+V6rjroJ5zQ/dDOUCmEIPwRWfFN/63OlY1LxwuNZ5oJ7Z3LfioEwGt4uTotikRXTpSZa1T75VD1deNxL+3r46Ylzt2JyzaROC0uZfGEgD+xB8HdjtTp27TZO0tcElGobPE5aAEQIQwi03UwJOIHvs7el/vYdsO0lmPoXV5j5lCCp6OXK2BfvUA+XoNgLzpHFpuJjs0lAm0mhQ7lpyPdqe4qpEuzH34Ykwe15NpybHkysJSMS0N3Go4wJ20f30kZ7Cv4y0b9Wy7FId3ihqMu2flP5TDxOik12/RGopV0noqkoxctUuZXMRWbQBdE3dCg9EbhhF0rdKPCIc3+rozslHmzCSHSTUhG07LJiy5Dj2Ncnn8VMCuWSFp3uM4sHVHL+RcNEQ3kyjrQRhVsufHVlHifYpNnv1F7TFfl+PQDOmWeBdbfIYaRJgkV/9LI7KYiTtK1iIrh+KD7TO/YBiAm4/hE5eNY7sTh9Hz+nez2C/8Q+Nr8TX1LH4DL5DKJ9TwHVYGZjDnrpcqhZt5rG3VvlhtWULLdLyIhsP0tp5GgSOYQcZz6lr/9HOzir9G0rgFqGTqU5SD0qTwYW+VKCzkYeVnBsRAcf5rfJuddtH0ejWP2w/90fgQgC333G+c4PYEmhYeLkXvYH1FcIo1HSKZzw3xqmou
 XiGcpOHu
 V1n8g2B2aKz719u3Vx0TMdxSD6+d1zPNo2th4iq+Hm3XEM96NmWm3SThqDolDAAcf/l1bfIRr0QteP95kfcy7YxVmkvbSbEEeqdza151htvebAjLmQ8IDx44Yu4z5KoOBP5HNUGCX2iIkYAw5/5uX9pNuBH5IFLCen0SvCT+cXruBZT1xfsZlgzGQV5CKO8TU7YXI43YdntlWPFi6307lc1WumbNr6xk7jPwp9WmuUAfMc/cxO0X4YhCHAZbsqe8qJZ5XiJ+7MoJVs4t9Y+OjmXoLIaz6NKWUvoiM5xB5Q/utKSfs4Lq694Evv8PpbD4L5m3nFKeH4eWgDxXfDtU5uhU78apCMtxVV3nL52tZ80nDAI+ouAr+OfhD9eQV9+obCmd8kIo/gZWLLBAkhz27n5AAk16uz22rUGT+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 6:28=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 9 Oct 2025 15:47:06 +0800 Baoquan He <bhe@redhat.com> wrote:
>
> > On 10/08/25 at 08:26pm, Andrew Morton wrote:
> > > On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrote:
> > >
> > > > There's no user of swap_active_head, remove it now.
> > > >
> > > > ...
> > > >
> > > > @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_inf=
o_struct *si)
> > > >
> > > >   assert_spin_locked(&swap_lock);
> > > >
> > > > - plist_add(&si->list, &swap_active_head);
> > > > -
> > >
> > > There's a large comment in _enable_swap_info() which needs to be
> > > removed or updated?
> >
> > This patchset depends on below patchset:
> > [PATCH v3 0/2] mm/swapfile.c: select the swap device with default prior=
ity round robin
>
> Oh, OK, sorry, missed that.

Yes, that round robin series is consider good to merge.

>
> (When I'm working on the post-merge-window patch pile (700+ emails) I
> go in reverse-time order, so highlighting dependencies like this helps!)

Understand, that is why I emphasize to  Baoquan to highlight the
dependency patch series as well.

> > By the way, Chris worried the plist swap_active_head could be reused by
> > the ongoing swap-tier work and suggested to hold off this patchset till
> > swap-tier work is clear. Now seems it won't impact swap-tier, I will
> > send a v2 against mm-new.

I will wish this swap_active_head  patch series to hold off for a
month or so to make sure swap tiers won't use it.

>
> OK.
>
> Is Baoquan's "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
> default priority round robin" series still considered good to merge?

That series is still considered good to merge. It has 18% performance
gain by switching the complex per node id swap file priority to simple
round robin. Let me reply to that patch email thread.

Chris

