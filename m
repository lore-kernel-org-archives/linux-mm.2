Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0811EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482D06B0005; Mon,  2 Mar 2026 14:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A136B0088; Mon,  2 Mar 2026 14:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367906B0089; Mon,  2 Mar 2026 14:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 20D126B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:36:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E28791C18D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:36:06 +0000 (UTC)
X-FDA: 84502128732.18.0872203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1ED8340007
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:36:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rpTFX/R1";
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772480165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ll1zVLFoCdzxILtFeORl9PKfpfKiREGHp3dCHsEJNDM=;
	b=Gu8C/5uNhRWg1OB8IsVSWCXu1padM03Ds80sTFLSvMsscFYy0mFwM+9/nljiaw4TZQGHD0
	xeQAxtErIAFJPqJSMgN2LL3iEvHjR6Tj3GXdOyvmyuJHIx7JNdVT2JosSZp+ujf+C+t79j
	dDsnQQm6HTquvsMphb9MAl23uidUi1c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rpTFX/R1";
	spf=pass (imf12.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772480165; a=rsa-sha256;
	cv=none;
	b=WJcFF3DiTxGHqGacdhLM2+XrxX8/ewfaEkhNuwqHRak8JM+abJQaAKWESUGsCxm5E42zqX
	gWapKOd6CL1GzMbYf7CaO/dAsQAjtpEK9AxRXDNm3X2d9xJUgNsj91y21QrBr7ed/y9ETA
	ffGaRTlDqEQYuidrY4v7nZwoFJf2OKw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 87718600AE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDA0C2BCB1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772480164;
	bh=/TPMrf0mYCs4hSJ7iK2Xaq+/0Ax5mSYXNGvZttrksbY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rpTFX/R1FC6uYBKWV4SKW//6p0UW+Hy0F0X/0nFVC4P/sOfpzUlWJBmcK8Zwaps1V
	 Gst1Trl+nNrv+0UouI+GXSZ8qsRFDdtFi1BUAbXk/1Hy422bs4U8GiVkCbGlSCFm0E
	 RBNvNe6Va3QBD6U5OyIg3201xbCYOFVMSie1u0TagBXs5rxmZhtGZnRHSEF9Fa4/sH
	 PiSRRckFtU+JItD3HlWOJnjAbrQGm6Hx1V4OspA8KqeQvCA4q58dguaqk4rn5jhjjf
	 cu64yEtMVwKwh9W6kCf8kSVuhy6zpIq7kjdZ74ZfLDxwMbSnLyCaS+YcuhDFxPbV9F
	 5buI0EZFmv3XQ==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64ad79df972so4605182d50.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:36:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXxlA+iahDNU7vAgrD5YC11AAjnVTKngARqcWG4IDoMsvFHEASD9IcrjbWw+xaUGOhcUJfBY3+ufg==@kvack.org
X-Gm-Message-State: AOJu0YwTTiOhtDyVr650epL0D7gIv6wEjDXBr+ZAP98825sYhJhgpFm4
	BQVP4WbCU0gQvIHIORHK9cFI26plNGNQcDrAi+Xg0WnQYwSzWDDSLxUkq2dVLbcJo+e3NwLB0SY
	vciPDfLxcksy31wlXhK/eEcqgkZsaTegCAoMAxGorkA==
X-Received: by 2002:a05:690e:15cf:b0:64c:99d7:8d14 with SMTP id
 956f58d0204a3-64cc204a1f1mr9775613d50.13.1772480163537; Mon, 02 Mar 2026
 11:36:03 -0800 (PST)
MIME-Version: 1.0
References: <20260302104016.163542-1-bhe@redhat.com> <20260302104016.163542-3-bhe@redhat.com>
 <aaWaM57jui+iuEj1@yjaykim-PowerEdge-T330>
In-Reply-To: <aaWaM57jui+iuEj1@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 2 Mar 2026 11:35:52 -0800
X-Gmail-Original-Message-ID: <CACePvbUr+xEs3zM_g6ZhwosF=Qt2=2W5fjYPs4gDL6MTo9rmrw@mail.gmail.com>
X-Gm-Features: AaiRm50oJRMmXbWRCfP-wyxdo0gZoE0mCqXlHleXG-PuVhejH4RZE-s8SUbGAlY
Message-ID: <CACePvbUr+xEs3zM_g6ZhwosF=Qt2=2W5fjYPs4gDL6MTo9rmrw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's methods
To: YoungJun Park <youngjun.park@lge.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baohua@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5fqy3hrfffyw8xgrsmcnigyacmn3puqm
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ED8340007
X-HE-Tag: 1772480164-999562
X-HE-Meta: U2FsdGVkX191wR7SUNTgo36JhrqJf4kdhuydMXL5rx4juiHZDBTeBO4naYiNsHg9DV0Sm4Ogmbvrzqgt4wG/brurTiN5Yiq3jXNWncL3XQXPxLWaoWT/+84a1Dw/9HiL6ZASBXMjpozroZNrf2I654ZU960Q/PyXljrYVQXOtnrxmdAjYAv2Wk5+pIjAHN8/qKCPM6zTgFAKbX5SA+72A5M3AHsyHWwG8APK/+q5lFmPJPYQo4/qcidC5Pdx4HuRMFjszpUsWIkROSa/NtasWiP/h9Hz30DhcmCmFS0vpQpjRWnHIsI/H6NFsNOf6TafFi1FialI4Mg/7YPVt86KAg1sDIOQrAISyGzOl98ZZxeHwVub4Qd/lLEodCidIoIaNVdvXwgJxEH0ifTBtdzRFQyUlLKBNOokNNDZY1n9kQ5kKbgtQvGlQhBc9Ivj3QhdjPPvG1AxKNslBcNKDkhxCINO8anUi890xBBiMC4oBA3+ZurjkAsG1VDiVpE+h1epiHB4itVNxxaQLjFKhyOioKj468Bb6HlXVSp8P2ZOYUdcleefDaTLyqPLbqOf6/6znCFXXVVa+Yp2Eg6si2bq0oz2ROP992SEj2ti0nARDocu037BqvF8Zg9XAB9BK8yqHX6MdtG6mgqb0OZUQ/Nngb6H7xaLQXN86JvnbGsrsk5/IyCKVffBcwUeLUL69Vx9wMNyBLhWxM6gWvObFcq26+jeVGZlsNw7FZfm8QJHdf+PIesWFC7fybAmnP76sGAPnWtYtNIJw/HfIz3BlC10AKcaCu9ySmZfzMcGdt9PYsrlTHSK9zfQVL3PZnlpsYBtbpcSMyp4RxniUShHunTm4qcTpPwxg06V2w6hioIVcfFN5LttOohOKaRQtVizwpuY2JUxV3FjKecjck6yM/HWwe14/0o5fAQpjWnXeUxcWZg6YiAGRR9qb5bhbREPkl5SOCp3qYrKDVNBBTt9zHV
 pOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 6:10=E2=80=AFAM YoungJun Park <youngjun.park@lge.com=
> wrote:
>
> On Mon, Mar 02, 2026 at 06:40:15PM +0800, Baoquan He wrote:
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> >
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  include/linux/swap.h |  13 ++++++
> >  mm/swap.h            |   1 -
> >  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
> >  mm/swapfile.c        |   2 +
> >  mm/zswap.c           |   3 +-
> >  5 files changed, 76 insertions(+), 45 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 0effe3cc50f5..448e5e66ec5c 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -19,6 +19,7 @@
> >  struct notifier_block;
> >
> >  struct bio;
> > +struct swap_iocb;
> >
> >  struct pagevec;
> >
> > @@ -222,6 +223,17 @@ enum {
> >  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
> >  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
> >
> > +struct swap_ops {
> > +     void (*read_folio)(struct swap_info_struct *sis,
> > +                        struct folio *folio,
> > +                        struct swap_iocb **plug);
> > +     void (*write_folio)(struct swap_info_struct *sis,
> > +                         struct folio *folio,
> > +                         struct swap_iocb **plug);
> > +};
>
> I think swap_iocb is only required for fs-swap
> (swap_folio_read_fs/swap_folio_write_fs).
>
> If the goal is to support fs-swap through swap_ops, it might be worth

Consider this series as a starting point for discussion. Nothing is
set to stone.

> considering a more complete integration, including activate/deactivate
> and swap_rw from aops, rather than only adding read/write hooks.

Can be add as follow up patches to introduce active/deactive and
swap_rw from aops. In fact I want to see it as incremental patches
rather than add every possible swap_ops in one go. It is likely easier
to review as well.
>
> So.. we could keep SWP_FS_OPS as-is for now and just split
> sync/async paths, and revisit a cleaner fs-swap integration later.
> (I mean removing fs ops, and call swap_read/write_folio_fs on sync/async =
ops.)

You can propose incremental patches to add your additional swap ops
and into the series as the later iteration.
The sync/async split is just a MVP to introduce the first step of the swap_=
ops.

Chris

