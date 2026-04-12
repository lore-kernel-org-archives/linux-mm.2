Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF5C4E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B446B00A8; Sun, 12 Apr 2026 13:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914BE6B00A9; Sun, 12 Apr 2026 13:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5716B00AA; Sun, 12 Apr 2026 13:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62FD66B00A8
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:48:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2C89BC25A
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:48:23 +0000 (UTC)
X-FDA: 84650638086.09.1749B83
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B32940002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:48:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTfKYHBP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of lgs201920130244@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776016102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rm8zl5J35CpU3jnFsSRYIzi1x6YziVzsrJSoZV0+Zq4=;
	b=KZINrhzOroeyQ5Zfsf1ocNrQxPodR1ofwAtKP1JhRUquZEg9ew+FPIn+hehOkC3nC8/gfS
	pzew0YFeAvPTKzUCpAp1rpNZeulmlS8zvJ0Dc2LblR4YytwYf5XdmKBRdHRyzO1uav2UYI
	NN+bCFPaqbUWQ8FvQDPRCW12oazbxTk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776016102; a=rsa-sha256;
	cv=pass;
	b=5KPZX3XtkKlm2N+jMd6E1qhiEUzbrcvzlVNCdc7Gwts1cDJDgJNLKiuSKjH3sR50WsvvoN
	ufpxXHlkAqUTzGA8l2EExiRJJUX+rMUJysW6kpm3bg6sxIjGmoVWV3ZyYGhsIjwufKm4dx
	6VoLayIzRJ/ORam2xOArrl4Xt6wlxec=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTfKYHBP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of lgs201920130244@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-651bc8f864fso308716d50.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 10:48:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776016101; cv=none;
        d=google.com; s=arc-20240605;
        b=Ckb/Tc3LXx2Kr9MXwKsymdwsE26k0ow2FpwhykFs4xA71H08VTR2hwnL6ZRW5PyYFz
         U9nn1SpH8u19nFthqlBTRtl/T5NpF3UjzQfc7d4wF6cENrChh8g6OCiOoq4ja118mEP/
         2N/q3onvoihRSP07WeAsDYfa1PhsIaw4mzz/OJTkoc1+9U8NJQc3Hd3cOPCR8oy+6jPL
         iY/tddkdan2nHVhkauARbwMOk/0xF+Aw+gJ36VgD+yEl8u/y69dG3uFZlFcIho+S1TC3
         IlboUXTkQWxcFsJ7/efdAVpc2YK84hpqiM29/ErsFqWDolfxP1VfUk4yg4t/QIERu9h3
         Fb0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rm8zl5J35CpU3jnFsSRYIzi1x6YziVzsrJSoZV0+Zq4=;
        fh=2d1fqQXWkRIcdy2u0h7dtYD80GXkHLrXRO8kZ4TdPa4=;
        b=UnpJOD77S3EMOBo4op00ml2IA28iV101cMQikNzyY+bGuyW3/pG62fBumG1L21xZQw
         YgGuIt2gGVmwnPJDsSKW/APkOmRQ9qdLNXK9STu/xKoR5OZQ4648TDcGbobxcpyc+e7R
         t0WOWksYQt7NMMEhDWjKLdcBRx7Q7jfb1gl1Idjw3OOWV6HPt0P7Zp2UgDAt38vxk6XY
         0E33iT/UTVIBhasqdalU7BmmB4YDMrJdJNYlBy70CkWqmG33h9aho6qTA3EyKh0npsHM
         glGe1XwxkQNA8Op1gSP8ggNfu4fPp9b/Evw1PA7CkYGyy1U3wt6MpqOCCFyL+iX2bxXh
         9naQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776016101; x=1776620901; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rm8zl5J35CpU3jnFsSRYIzi1x6YziVzsrJSoZV0+Zq4=;
        b=DTfKYHBP0kbC8bgbjDpdI+/rgmKqOTJ230HJrNhg/HThAkdM3JZogs2b5lnl83xs3E
         BP528JSZt4UXfQ0mcuABHYrsi5hO+cjfkdFpAQdS+XPfIx+uH8RoTMG9PK1MTt1tItoZ
         XV07VL6nTemjCIjamelVragJlwL82OaCSbGn937GRqCWPeWnjAEP7tfzJqTJrzG+2i1c
         4Ewfsy6ddx0dHtuoOD1IGjEiAl4n0gib3sHyMuYh+AgU/y9d3Wkxwtu9qvf6/3yyfJwj
         qEufX6VV8kgJAMLoeadYe5NWXGs2KuBYJp4B5aVhR+pzBkGRYkBaq/w4PytUFIyYJzNW
         oL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776016101; x=1776620901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rm8zl5J35CpU3jnFsSRYIzi1x6YziVzsrJSoZV0+Zq4=;
        b=WRkUg5GTBEcVToI7qtbAR994L6tSXzbI7KjXjT1XB+iLVSoIUUKIsVJyA1RXidBNTR
         C1m/z0AKPPcFijOCknPelEkqJKdUkBae/Il/nADenk3y2WLU36Z4/LW3VDfY0JVgsfMz
         5C2xRwPpd7uW9H+yATpO/zNRRVv5GgwEhJg0ahYzS6IvEp3KUjmGeI5gEC5FxzNgpZ9c
         xcqDKrL1qE55Cdf3ezrscjxXOOomzkbP3Iz06K+7GBWOwUojH69bqNmccb66O+FPFfJM
         KsxHHe3BqrfV6nlAvIDmNfsDBK4FfBnRMrCYL10xBA05Vf8dtCESdGvDOhi2jflEN4Kg
         UlVg==
X-Forwarded-Encrypted: i=1; AFNElJ8hXfDC03R3uqzGUIgdW8AyZfK0iMnhLwz39FIXbxNX1fDtrrxh7GeN8Dw40EqTaspy/9WE5A6IxQ==@kvack.org
X-Gm-Message-State: AOJu0Yw78XiaxHTTX+xxxUhlygRDmrkEjr9gxGJcYIaNvFC3i07NoliB
	tmVC83OLtuw89GA5nI6gJw6SNXte9P91q01Fe19jq1lSBORGPz21g9zlIxsAXv1TkoGsrwXfZKH
	nijfs2GXcVjTnxYsDx7dGJNriReY/So8=
X-Gm-Gg: AeBDiet3KKW2oBW0fZvsChaxPl1hnkfnGN1np8GE2mEGJM4JTE4hcu3k/KGmRY1meXm
	rV6Fh3cFAwTLTCwt3Xc7+nmpWIh8Gr6Jcn4a4tiuhHnzs7LP8zRzC8IPujiO17KP+WphkhXZgVw
	QBAYTeW2RqGwEN0icd0Rs4NC+GrObxPsbmrz+s6fiTO2znuLk7fw6/hxbeAdNNvLr0B5JCGPr2B
	hDRAbO3OJIYbWABsLXO8CP9ZOUA+2pvxQx3jweuoW3TeJDz+o1lgxibLNi8o7F2KscJda6v4JND
	pDxUdtNI
X-Received: by 2002:a05:690e:4841:b0:649:e6de:8f4a with SMTP id
 956f58d0204a3-65198b72cdemr7352447d50.42.1776016101031; Sun, 12 Apr 2026
 10:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
 <20260411142858.85496-1-lance.yang@linux.dev> <848180C7-F98C-44B2-AB1F-579BF9EEA28E@nvidia.com>
 <3e688ea1-05ba-4e75-9d92-2751ff6f3b7b@linux.dev> <75F536FE-6710-4AE7-B6DB-2997D846237E@nvidia.com>
In-Reply-To: <75F536FE-6710-4AE7-B6DB-2997D846237E@nvidia.com>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Mon, 13 Apr 2026 01:48:11 +0800
X-Gm-Features: AQROBzCTa9E1N3xrHdXc-IGVPR5wSvNpHV_7nILnImYBrIIchwBXudfJpaQLPfQ
Message-ID: <CANUHTR_F3gZpzV0YHmJw_6yBwgG5a6-M2aaNNjmLq5Q9cZ-0KQ@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
To: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B32940002
X-Stat-Signature: g1zbkcudyqeda4a1kzmmwrk8iqw59nua
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776016101-932509
X-HE-Meta: U2FsdGVkX1+dJSNajVZKm9JKkGomcZNbVzKO5kCl8zQNJsCYVEraTejvmyF+uglvYgpTI/Kt1ZRrhWmR54OgeWCZVpFyVWD6pZ9AUtaYbvVH9FwvZQdS3d+uJhr2qrPK/yIEdHcK5HfuAbGf2NAXOLNe4VgiWJ2XX1xUJmuPU2K5tsn/K5dF2gr+ZIlJ5ztKDPQc1zUaHvkYqD8Jkwtwi/TYqwVoZVsaCm+mXHxtdfQKKrcmMar5yLs7F84bRt5x+Zrir0QcQOyMpFFY+lalC2O9IgshANYCrJekuIDFwG3f941fqSGBt4dDuNGgHhSIW06VTi0zPDgZadsDUcVQtb5Awp2R3qQBWpQccyioBg4QaWiUe0tMwrqXG9yJzUOX/u1+ReCsoEK8cNiDPe7qCLbWgbpurCOg9G4TSFt6+ZqaSBplrJwrftbkPWY6AB0PjrjXHixoFGJ2QvzQBJSCztJhbtV5ntwS3YMDJMIVIeyZDj8KI3z0UIeL+8DD+mcaFclVrU08hiVBIYcEH+ePBUX8Y5sfa8qod7VP2SEyfwkCHd8ig4i594jFkaB0RQ0s6u18Moh2OjclgVZBt3PHLBsGATugqhc4grX6S2aw5AR/nhHMp/gFkeAOouXUNLjC8fEsh3vl+/GeU4bWdFekpE6rm0BkpI8z0Tipa+tEuh/sI4XziwrseOpjvwFfgTd31iPWtaFoAXrlvZwWMCzFhBh+Y42rGMy2otlyEeQKuqRV8PEpl5Ge74AEkCVu6F1NfliEKB35xslbI1wVGSdbqbOLsfeibz/KFNc3sNT2G/RQ21cGz9GLNT6g/1T3ly52VOPNoGVK1lmw2hfUpqa039Ug/8Cflk0PYapRFfIhVIbOyIyE8lCmNUVXJoMJKjyvzm8W2+fG7q32swlcHHm5TZUqEvY+Fh9MCM5wA3ChARM2gTCw8VFS4LfkjkbF/d8zElG66mSpAzwA2gVQxdD
 xE/4LL3c
 jX+HCXJMhSmsL1DbNjJZgyBzJlo9Mhpg4bz4qCho6x6Rjc+vaCzPw3/N19j2xWcKabR0gBI90qjIA5ygaHTIvYwu1aoytxpqQJmkYME/0QXSb2Z3cgOEcgDnoxeRWwMkQd47dboM3apa/xpHGOQzs3aSc1DnvVIA/47GyO3BFbHzi+RHdoPN/qsT6sxhpD9q2n8nfp72CUmBDVBfWe+5GWeVmtOJOGANXgztmj0axeFquChS4VA5EX2aqqiVZfwu/SRhKMk8/DRDZWpVlgDcZG4TIYUxPVMkgeFfBiHJezGoYzLO/mAaa0j/XvuSbThxMmzaSRbYPh9/MNPHsxduxGm8k53ug2QxXDcb180UGrvf1uqbY1aPaFQWRqnpRvMxNIGk+Z6IaS/4dPhlMqGW/CD3qNuIYt421V4ztnXt5cUEuEAIQybmyzlBJG6L8AqL7SuuQmM/o9whP/8hmIYLX20JISA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance, Zi,

Thanks for the review and for pointing this out.

You are right =E2=80=94 that was my mistake in the changelog wording. After
rechecking the failure path more carefully, I do not think a
use-after-free can actually happen here. The real issue is that the
error path skips the proper kobject cleanup flow, so the problem is
better described as an unbalanced kobject reference / refcount
handling issue rather than a potential UAF.

I will update the commit message accordingly and send a v2 shortly.

Thanks,
Guangshuo

Zi Yan <ziy@nvidia.com> =E4=BA=8E2026=E5=B9=B44=E6=9C=8812=E6=97=A5=E5=91=
=A8=E6=97=A5 21:33=E5=86=99=E9=81=93=EF=BC=9A
>
> On 11 Apr 2026, at 23:24, Lance Yang wrote:
>
> > On 2026/4/12 09:49, Zi Yan wrote:
> >> On 11 Apr 2026, at 10:28, Lance Yang wrote:
> >>
> >>> On Sat, Apr 11, 2026 at 02:21:52PM +0800, Guangshuo Li wrote:
> >>>> After kobject_init_and_add(), the lifetime of the embedded struct
> >>>> kobject is expected to be managed through the kobject core reference
> >>>> counting.
> >>>>
> >>>> In thpsize_create(), if kobject_init_and_add() fails, thpsize is fre=
ed
> >>>> directly with kfree() rather than releasing the kobject reference wi=
th
> >>>> kobject_put(). This may leave the reference count of the embedded st=
ruct
> >>>
> >>> Right. As documented for kobject_init_and_add(), once it has been
> >>> called, the error path should go through kobject_put():
> >>>
> >>> /**
> >>>   * kobject_init_and_add() - Initialize a kobject structure and add i=
t to
> >>>   *                          the kobject hierarchy.
> >>> ...
> >>>   *
> >>>   * This function combines the call to kobject_init() and kobject_add=
().
> >>>   *
> >>>   * If this function returns an error, kobject_put() must be called t=
o
> >>>   * properly clean up the memory associated with the object.  This is=
 the
> >>> ...
> >>>   */
> >>> int kobject_init_and_add(struct kobject *kobj, const struct kobj_type=
 *ktype,
> >>>                      struct kobject *parent, const char *fmt, ...)
> >>>
> >>>> kobject unbalanced, resulting in a refcount leak and potentially lea=
ding
> >>>> to a use-after-free.
> >>>
> >>> IIUC, this looks more like wrong kobject lifetime handling and likely=
 a
> >>> leak, not a clear UAF :)
> >>
> >> kobject_put() ends up with calling kobj_type->release(), which is just
> >> kfree(to_thpsize(kobj)), equivalent to kfree(thpsize) in the old code.
> >> IIUC, there is no leak. Let me know if I miss anything.
> >
> > Right, the fix is correct. I was only commenting on the changelog
> > wording, especially:
> >
> > "resulting in a refcount leak and potentially leading to a use-after-fr=
ee"
> >
> > The old code does skip the required kobject cleanup path, but is
> > a UAF actually possible there?
>
> That is my question too. The original code might not cause any real issue=
.
>
> Guangshuo, let us know if we get it wrong. Thanks.
>
> >
> > Just a wording nit.
>
>
> --
> Best Regards,
> Yan, Zi

