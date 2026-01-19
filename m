Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8B8C9830C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF746B00EC; Sun, 18 Jan 2026 22:17:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C71F6B00ED; Sun, 18 Jan 2026 22:17:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D31E6B00EE; Sun, 18 Jan 2026 22:17:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6967C6B00EC
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:17:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F2EE13B614
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:17:55 +0000 (UTC)
X-FDA: 84347254110.26.48A78B4
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1796D120006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:17:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bm4Us7YM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768792673; a=rsa-sha256;
	cv=pass;
	b=XMaF+eixTBpSvo1B3jUTVSILdJtsL6TUZ90tHiXSuu75+5nwHrAZTBTMLECvKQs++xvnYb
	mdnWKQ/PKqd3Y3i35wN+t92Yd4PX8DJzOaZ2sPLkn04xOld7JvKduu9QYKxWwRhmpIG2Hn
	k0YrW+rpk92/8/L+RVHxen977l0Q7Tc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bm4Us7YM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768792673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnEMERETZXpYSLDDchr/WHVXPVN1Akoe4lLaRnfg5HI=;
	b=pEMfgc6KQI2uPpiltQUcoH3R+JIOpW+NJPnVDNDgl2sgLXYWqy6PgdU77UD5hGnPFbT68c
	VfF2puUnZ0QplRhuQ8ZULdyC4fB/9s/pwQQn9m4x5rlmXFq0j/NZtcIqNr8pGM4ItjcYww
	qqgAVd2Ws3Yml1frmHxj33jyCI0YRvE=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c3e921afad1so1544736a12.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:17:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768792672; cv=none;
        d=google.com; s=arc-20240605;
        b=QypyiLtsH05Psot/4xtrzDtZMOufSoiFZSnkWtUidUMR00Lr807EEuEutEDXo7Ys0D
         yXe156cUnHY+ubkIrMIm6M20rDlgclGXsRtRKN9ctl2m6WiDi4+VSSjnfQB/iE2fJ2lP
         oS2b8Myf15zh+vt4KVCY0igteuf49Lt3prLqK/vjaJigHLHKEygc2oRhyBQjEDNdchRM
         zL2sLuyFfmPgrz4MwtC/Iwrn0LcBxwYuY/UxIjKqhON9c1A3pJmBmruhMry7YInXmb8p
         BK0xVzgYSp3kFf731I7d4c3HvK6GeO1Gq8cE9cWt+U9iwC37NZICGvmBoBcQs7rX/8m1
         YwWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HnEMERETZXpYSLDDchr/WHVXPVN1Akoe4lLaRnfg5HI=;
        fh=VAUNHol+phgHkz29m8OmMAkSsgxAKljQdOa7P9Zgj20=;
        b=F4JwDbmATiFQfo00kIcacvFqNs/buFMQpZwmy2ZwA/Hslc8xMpUnGr5IIhOOjIN1mS
         V4fF7ZluxZ0U4k7aS7mu2SKxzyn/JnlMjUgpNKne6pik2s0a4QslMFaxe1///JqBDPbt
         d+1PLnUDp8iq7vPYfMwoPg+gpnd2DXHvRDcTkVbSJ3c8zrFP60aJAJeSWF7lwEfB/xH/
         iPcqLkqoQoUor/4QvoCwv2sDE7S+oKxOZ1tJyMQw2SRfQLYLmHqWNBCq9fcp/QsmP1uG
         TOxVMBYBPgsung+nMwGawJwpN5jeHRr3LWKo8WHFfZwlJz7BnMayM+veED9fRPoG/lq4
         pt8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768792672; x=1769397472; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnEMERETZXpYSLDDchr/WHVXPVN1Akoe4lLaRnfg5HI=;
        b=bm4Us7YM+AouVSlRJ0k8BsdcPV4jytKke3cCo+WnBYpFhTf7v6apOXzd1krrZmkLCg
         ReNF5iVrV0rPOnoiKf4HU6U7MZgVrjkf2yx6wONFyBjX3nEhj4GFyqow5TTOUmDygEqO
         WK48nthm9GdcR/0Ofoo/XMND2feMHDRnPKCMcNGeG4cwSvbVa9LQmWos7slFsc2w0p7l
         boAwZoSZMGEFvyfB4kiNnnrEqxiygsVCaGpBGCe9+MGSEh9fJaWGQ8jjzY6UA2Lplxme
         zrEGXKjgw/E4StJYDfLfY9gBQ2Etv/EvV4kEZWeEjS9D8UWMfL6cJO7F+Jdn9F4CQvyR
         nWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768792672; x=1769397472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HnEMERETZXpYSLDDchr/WHVXPVN1Akoe4lLaRnfg5HI=;
        b=R4pt/1Hp6eBp1WPYZkMChGbA4W7uNZuKV4XieD+gRQ40aPOQ4jUJnFYgQQzWn8ZJBY
         2949SkBjbtYv3FaGrmUgDQWNlWHDjycQlCheKBAvO7TFs1OOhrJWE50vJVOpuyX36Hgp
         jPk/1Bai+ju/OAP5faXEBcMd1Isbned4ckv25XC/1FB41urMvM9DYuWn1lEFCUceSWdi
         QSQjPXdrp5ZlaBZXrBhf0qkmQAaiyaCXXMZB2JZ1sVdTNBIhNu+P7IG1Nbw8ZjJcSEqN
         gnn6gyEAj3v7N69yPmsN5UjYarvhMTZxhrFlrgjv3nDFxSvyok7yc6lpaYhvtxtz+0XD
         VkUw==
X-Gm-Message-State: AOJu0YxxRjLm1y58ZWC+9bOCWPMAQc7YtQ7H8SveE1a6ApF4Ea+XAVOz
	i9cG+wm6bRtBhmJnR3JJ0Xkm6DDPj5KAbWcd54viW6HNzk539MUMfNxZLLxZxK33utgRLLsgRnu
	EauCw3GJgDP+ZUXPfxn7MyiERzhw3SWA=
X-Gm-Gg: AY/fxX6+Dh3jyBFegkwdNzCpBzTXPm9v8YQQuIZw2kmRctPEq8SdjqBPcXmPsyVgzWo
	qYAvMof8Si+kekZbEp7/12QzcR8fvY4vYKomL7QF+7yeah/zAYIWcbHfPpoi1WXhJ6NYjzQBI62
	K0+V/UvDx3YRhQD10nt81tLwE8kyNEtqDNxHnOJA9b2rGKCC7SSdCYUeQpPNQ0aFOEwn6d6KQU3
	qlnNuvkt4e8jPj6mB0ejDrRrrALyBsR8mtm5xJ7+NCnMgiz59hAXqbjXs0WzXPOjXOE/aoFE1Fn
	bh/47clB0utQGowZWDx6rmM/hBg=
X-Received: by 2002:a05:6a21:68a:b0:38d:f2db:ea50 with SMTP id
 adf61e73a8af0-38dfe7e53e2mr9426676637.73.1768792671736; Sun, 18 Jan 2026
 19:17:51 -0800 (PST)
MIME-Version: 1.0
References: <20260119-shmem-swap-fix-v2-1-034c946fd393@tencent.com> <74fd3fd1-97d0-46a3-b76e-435808efff02@linux.alibaba.com>
In-Reply-To: <74fd3fd1-97d0-46a3-b76e-435808efff02@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 19 Jan 2026 11:17:12 +0800
X-Gm-Features: AZwV_QginFqBQArXq2rn6NQNo6CY6DV85PfDMsi4G0hCBNm7nTXd3hYpAKKCKlg
Message-ID: <CAMgjq7Bw9Ascd5FdTg=wf8dHtQN2n=cJPqREsatBJPoDLJVG=Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shmem, swap: fix race of truncate and swap entry split
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zt5fodbx1jwhtbxjf4phxcrfekhinynj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1796D120006
X-Rspam-User: 
X-HE-Tag: 1768792672-860065
X-HE-Meta: U2FsdGVkX1/gNnAx/FQ79dCpEiheIkgcHYd667aFnEeSOvc0yAsBoCtJMjOLJqeymcOEQvMEh/P/mdJu8fdCiD/XsU00nLLkNKQjSoiUeUK6dI5GdTB5HWhkhg61emnjfTJ4C2l29+3n2VJXZtjJmKBX3Z6j+/SKy3Au5rATqXtOr5z9KYbniy4OwHBJuTTBFwdSTN4x4Gn5+afkfz+7SvujCe8xivjXuPAIk/Z9snMwRmLAIASHFRWNt24tKcC5LkrMlih9CX4iOOS57I+VVjJkXgPm7MpKpUGHAt8ZLL8HI7uZadgdKqyOWpPBKtrv+a/fAJskWOgqscOCobqTirKXXIS+CVU958Hv9wZ1qJJwtdBDA0ZRZDlbNkM2NR6IaWEQtQVWrFKZVxaRhfNqlGBUrwbZ3gJHeYoCqnpWcoSBLU+O0SRQ0F91+hHKpeoo/fkWkOZKHTQyGuGW4AVxbXMUcePgqAVkZItV6smTt/FUJSj1A5jsg7hfPfXGhfnjCofScu1XRQPISct5WR0w/lOaKyzTlT3KZj6bLQykfICdRo3kUcm+S27+csL7ISoe4+3NggOlvbV5uNQnz9h/MV+/P91QITd7bNputk7EsN5LaFb9pOJjma/nV/1P7ebjZUOujeQTuCVqf1gWQDsYdc/VNdZAu5ZMZsOgkxfHbwukSLfAFyYMKqbErjo6XBUVYq+Yu6MWGVyKeLFo9WRbgdrEnXhXLTY2PVB9y07jlSO8N/E3kpXi7QvTcjfqc73jWYqNs7XLfzdddixXmdxU+LAo/0YnmsZSn/VrYAlXcZdXN9RSDSpT5w/cHKdjc/JfajDB0RrQLnpqeQXGU1oG/MOTH4gzYqr8cxVrXrk2Vx12mpOYw1xjE+j9ckh8l1N39M/16u5aqe6s/3RI/mxyDMXI2Htl4xChDbGo6mL0tGDrnt9rYUUSLCRH2cxA513mIFZ992C1tW24HBA6UsW
 0aehrc3V
 4R+RdN1OR2R1vwHlOfk74A6wUAJbS4EtlSx512XsIuCGB9/3lFbDQ737O7tx23Ikds+82I+PGqDisJM3mGCY1znIM5AFiMJpAWPRHe1oVSP2lsfh16qksFdWwRO3szKkcGoA4KxAdp5DgyS792UzRiIYhpQmFCcDnrz1ShiGEsvqot/Wwv8nLp4svy79NXe8JMjKS73itbHjXM4T8Nrc4kvYvZGVRybKKXV36JpTDoiSyR5ammMPWTJTlVGhZ4nttjer2tJm2i8CN1AMJxEbBSF8td0UJ1Wb79PDLxHQdwpX+MrmXx3FaquInbxGmqUkrOp55WmZu/VXKlLLvvfbnjAUM3vhTUAI1zDO2/uHjNj0Zj39KFhkrZp5SqL+LNaX8FHIkLXMOs6E9Xn74Tj5tzvQzCG30aBhWCqyvUeiRx4afahYM35UF23f20rAwNA0/rClR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.007932, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:04=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 1/19/26 12:55 AM, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> >                               if (!swaps_freed) {
> > +                                     /*
> > +                                      * If found a large swap entry cr=
oss the end border,
> > +                                      * skip it as the truncate_inode_=
partial_folio above
> > +                                      * should have at least zerod its=
 content once.
> > +                                      */
> > +                                     order =3D shmem_confirm_swap(mapp=
ing, indices[i],
> > +                                                                radix_=
to_swp_entry(folio));
> > +                                     if (order > 0 && indices[i] + ord=
er > end)
> > +                                             continue;
>
> The latter check shoud be 'indices[i] + 1 << order > end', right?

Yes, you are right, it should be 1 << order, thanks!

