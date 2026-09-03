Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7FB3C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0346B0088; Thu,  3 Sep 2026 13:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F7A6B008A; Thu,  3 Sep 2026 13:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538CB6B008C; Thu,  3 Sep 2026 13:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20F776B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:03:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACEB41C244D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:03:20 +0000 (UTC)
X-FDA: 85173071760.06.EBE8C9C
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id B234516000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:03:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=recall.ai header.s=google header.b=C52MpWuN;
	dmarc=pass (policy=reject) header.from=recall.ai;
	spf=pass (imf08.hostedemail.com: domain of mike@recall.ai designates 209.85.216.48 as permitted sender) smtp.mailfrom=mike@recall.ai;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788454998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bg557z9Z5rLGa5JWDNXpniIcVZCak9b6Tl4QhppYszY=;
	b=hRGEPYNBZLacQwjGnUZ87BNraqLu89QXZ9Ya8JrTqO6MSt9tkrWL8cX+wpj8vpGZjpIzg2
	OM4qCMH4oPa9hPqLr0bGjOMD5/ks9HIGjSv+HnqprIe8kCiB5bx7Lnt11Zw+z7Ihd3eWXH
	2wSmQKNZ1vBFX4uUb0OAmHVtjcU2VVk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=recall.ai header.s=google header.b=C52MpWuN;
	dmarc=pass (policy=reject) header.from=recall.ai;
	spf=pass (imf08.hostedemail.com: domain of mike@recall.ai designates 209.85.216.48 as permitted sender) smtp.mailfrom=mike@recall.ai;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788454998;
	b=C12s1HjZq71m7MNvw+Km+DIDQM+CGx+AFXdQJwnjrpOWTkxnskibVQulpYVS7oSTBTsi2Z
	QbW6rnMepeh5kYPB4Adc3/GUXEaWTBSgdlUUzoVksEROBC0Wo6kMeTmNM/P/rGQrsfJQ8Y
	dp0hZAk9ftQkLPd2PK7qXbgTwCyjWUs=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so32635a91.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 10:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788454997; cv=none;
        d=google.com; s=arc-20260327;
        b=ANTAr8pt3y+FRvUAZ/In/qywD1TPVqmRQ3FKmzM3y7xc1roMW1CyzoV/5j632Ti3ea
         YQ4ZKm5eF8Wmb5wwW89ON3OSONfQRT9Wpm7j5A0YuI3g5fET+n4B2ZgiNlvL0pp7SF44
         +lQuY8/ctYtAaSmO0mbO+SQJIc48vXa8I+s59oRe9t8XOLc7pCEddXez79IR9hnlHBGw
         7pnYW0ysFarB/UYI4d7R38bWV2Ayn/KatXgIxz3hU3UyICFdXFmJ86OrRtu9W89VDDOz
         SczqU+zu4/h8Um7vF/CvZnyGLLH/MCBl6QyYvR88q9AOW4fXm2IKLL1tMs9V0e2dRV5g
         b24A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bg557z9Z5rLGa5JWDNXpniIcVZCak9b6Tl4QhppYszY=;
        fh=uCgZcwz4M07747tgHs9OBoriRrs+vDqT81hwyPAYCNk=;
        b=aHDj9/QRVypm0DWw7aEi3+LrG2KOykADz1P/hSe5EL86yun+MuFjuhMIFGNiz35jSB
         09cvFv7GXXvbho7yMsfDypQtVSie5mDJMNP7YKf4IfErOoUnnVoxDYRQXU+tGB2mYQjM
         3D+l98NzkAIH35N3KGCKV+Cc/z8Au76Eg6MJGI3h8GLYQZpmztTtgES9cvdJlrMzRSrW
         QWfmJWOUYko1xC+NWe8OfZo0JC710ZVEaydespiuo+n0PhYa0Ql7/W5l+w4MPMSh+pF6
         7SMRfKUelDTpjaOtBACgWJKxxrgnUwrCGmLQj6gg+CyCmtSMuHmWFoKdPaey+PQXKHCW
         i9Bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=recall.ai; s=google; t=1788454997; x=1789059797; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bg557z9Z5rLGa5JWDNXpniIcVZCak9b6Tl4QhppYszY=;
        b=C52MpWuNlFykf+4wqNVMd51KJ7+fBj1/EJHUU5w9jtk9QL5hjmc5XPdUXupCFexgK1
         YZ4kqWB5nXWCbGThiN/elYaTseH6TVHPR4Li9DGCJp82wF0k3g80PSUcJSQoMF0iXYk0
         M0wsvLSspLyf3i1QZORosL5Wy933xxNn2+pjEri0GAIWja/JBUpSl+v7Yv7wJXzTlv2G
         Y/osYBIuwiFyDI13bZkwQEC8UVYeH8QmR802M4XxS7DZC/VPhcjktpyM4kJKHSEHI6SY
         lbQ+Lrk4DpIQgEImir7QPPNaSnmzydjN7JTwyKUo/IzNfRHoI5BuNeCWbk49mrN5Sdr8
         7oRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788454997; x=1789059797;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bg557z9Z5rLGa5JWDNXpniIcVZCak9b6Tl4QhppYszY=;
        b=iYLT5wDlLDFIAsMojOsLVQSNQ24NIu8BoUElRYqjGeqorqM8fzTQ2kOM8PwGhhJ3Eu
         5cqZArlg2oasMUo68YakgOEV2d88a4RPXVio5NGlJM5tWVHXItPMV+XfVuHqlOfsNBnR
         AzKDDEbWAwBQd5Cnm/UPZSNJdxSbKcQg0LaFMXoF0mSl51AoSLe9LI0wUV/hDHoROpG4
         AfyDKeXaIpiEFfS2qxVtbESb+bWrF3vHbx9Yxiw/2qCQPovJQvHS+SfG0nX/M4uZSx1d
         dgMISsicaD8R6gvP2SHEH+kGHziuFBRE3h/Ja1Ws4uw16r4JhckTrVwYSPc7NrjPr60/
         f0Ew==
X-Gm-Message-State: AFuF++mJbJLB9trsEwb7aCjXUbDIK8L5preLrwHnmngbRQYluqah9kaK
	8iBUbYvJeiq6nw5PNh8KjnvajUpPdsa2cGgQmLpPqZUozFDs8C4nARbjbBNrfwr13rsL918TUeo
	IKuE7XR9QANCa97FJTTvHlyldpXZF6iIi1Z+drxC5RQ==
X-Gm-Gg: AYBFou1IP9qCuQ19/2wVuSHZnYolgMCVsaRLeoBsIuHtN7NiVaPOnLuQz8UQaWC+dZ7
	aPs+y73YZBBSK2mbTI/fGtVe5pi4z30TpbKL9iCu572amef+bcFKVamKxIbRu563TKyOLn1YLJL
	rGlmdGd7fN15Qz77CKtZrNYa+MUIXN8Eqf4j5dTCo5EyMsEYtgCoPPkeNwb9WNTjXwJE31Gq0TL
	OQNXl/IZQSqLBviFbDDBQadRf4XHkayVEvTU+bq3RmpDnn2WyOxsDARvRBj8fYtydobdWeBHqXu
	F0cRzZoxzjTWX74qF1ZdEsMvvv0BijqnEzjv3mI8gf2Gp2zHRBitJ77FFR4EB+An/1vo5EvRgb7
	OxcFSL8sVbHV/
X-Received: by 2002:a17:90b:2b43:b0:38e:c7b0:84ad with SMTP id
 98e67ed59e1d1-39b25ed34f3mr17750a91.0.1788454997150; Thu, 03 Sep 2026
 10:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com>
 <55D30905BB95B9F8+20260903070523.2032364-1-zhaozhengzhuo@uniontech.com>
In-Reply-To: <55D30905BB95B9F8+20260903070523.2032364-1-zhaozhengzhuo@uniontech.com>
From: Mike Kaplinskiy <mike@recall.ai>
Date: Thu, 3 Sep 2026 10:03:05 -0700
X-Gm-Features: AcwNN1UCge0nmg6QM2bN3A3-asAi6nwZc9Bzjhlxfv03JsH3ayoQNi3a5CgqHWw
Message-ID: <CABeknB82T0d3VUjz6Xwcdfa8spHvNzO6tZNTMwjJgF00EwrWWA@mail.gmail.com>
Subject: Re: [BUG/RFC] mm/madvise: MADV_WILLNEED skips swapped file-backed COW pages
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Content-Type: multipart/alternative; boundary="000000000000cd5ff3065a97208e"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tm8xn57p1trocdhbranzp3dgut8b1u1y
X-Rspamd-Queue-Id: B234516000B
X-HE-Tag: 1788454998-314063
X-HE-Meta: U2FsdGVkX18/2UfrOiWg640hH4+28e4nG3UR+NQint43BIo47CNYZuPJ8OpOsfFGPXa0hoGULPH3aLFAQrkTWB4EBRg2C5WYuTbrMAIH2nUtg6/ZTB+hSN4bgwaRRdHxU0QIJAVJGW6WIWjK8/HqOwYEVoW5HCNgsFT8F8o2rngkFDx6uudENZVB6NaKRIwgyNnm/GB7mW1fw/uf7/KCiFee3edtXRWl2fGrmiKQITkxe+3jKNKLV09BSyBsyTgF3f0sOVC/t/auqVf5sW5LMjLGojRiPrTKXsPkwkR9jwNUjgqmcmWvUtorpgC8X9+S5sr2VI/sHn4t0lHvlXOLJVSIeSCeDG/zfu9XHjB8YZ8rVOdKYmeUQ6VIpm3eEaLkUH6M8N648GvNJuuGG5bccl3QfwmMIGGDJVDq5c40afqrrHPPVh0G0Hsp/g0xOOgODCHlGFO0lueIfwG4r/B+Gfn1M9O83mduMUEOXmrB1OezNbw7x5Wd3uzvVgilAt79fXcMphvAdASlVrAzjYtjZvGEy7JXwnQkLqQZzcuDsiklPQq6R6oHrJmI/fLdnRQWxEWeNDyPUHHU1Nnb9WcIo9fPEvmPPBWU3xRuR6chZjJXVtUER6VbUe3PYaIU8LncDZ2Fv7ztv7mRRgYDkjXbQcZ67uEZem6vwHk65EBv1lIHout/z5AFs45+GU0J8fj2O4pGa9TOGpZUxBHSApC00UnFGR70Stw8rJ5XeUW9kcAw09CX6O3NGTV3o64YYsFdjUA5fFP6VsvG5fVr6ptFzjDmmdO1T1miG9tvf6VoxlHQJmAeGEO+vEXy8z0VWvyrAcDi1D5fPdF1GdQH1PGehrFplNwm4Zl1iviTd3OWP4m1pMShbcVrDVqwghygGjyB8TwTFa0cP7/yMgXqIjTLJy55/TnG7tM8vl6/7FhuXCxhd1DjBwCQ9p9vg5O3hJvQ7a1Fl6DKFyfPH1ctkwY
 kcPUZFc4
 5RDxNMqWEc064U7IqNCMxt7GYmBzBfv4XxtfgSyfLtUvoKopVo2yvNvAqXAtvtUYoqOeeUI6mPFh8ldvM66NgePGe5II8HW1s6fW222qNizkQ1XQbOrgvldzfVR28hJEEgxYHlS+ikMlBuilXsaNFtFMyI/dQg0dvG7o9RfVSCSr1CneUJWubNxXDT0JpjnCawv1LYwXzD/ykA7Lc5lFAgJ2T1jiLmnjykC1zLg5e+eCXtRuLFO3+LKAIXplKib9Z7N7xH2CJrJYlIYAmW98+pAZJuAMdIYq8xNgXL04ZU/iGPWgA6ZfG3+RF7dntucMOqbyROuiHjgfBe6GAzGHC6zVo6gXK6LRicCzk6J9yI9XVu9duoJ4I1tCobTW9VJI4Hk2VgQEVpanyNgAv5VzvHE38qaZVja7QMTDeaTAXE5j3mvKSELwFHs6TAHOvJ7EmWoHs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000cd5ff3065a97208e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi zhaozhengzhuo,

I am not currently working on a fix, so if you would like to take it on, I
definitely do not mind! I don't have a kernel development environment set
up, so it may take me a while to get this done. Let me know if you'd prefer
I make a patch here!

Mike.


On Thu, Sep 3, 2026 at 12:07=E2=80=AFAM zhaozhengzhuo <zhaozhengzhuo@uniont=
ech.com>
wrote:

> Hi Mike,
>
> Thanks for the report. I reproduced this on x86-64 with the current
> mm-unstable tree at:
>
>   e3b5239afe1b ("mm: gup: cleanup the gup_fast_*() call chain")
>
> The test used a 64 MiB ordinary file-backed MAP_PRIVATE mapping and
> disk-backed swap. Since the test machine has 128 GiB of RAM, the pages
> initially remained in swap cache after MADV_PAGEOUT. I therefore added
> controlled memory pressure between MADV_PAGEOUT and MADV_WILLNEED so
> that the swap-cache folios were actually reclaimed.
>
> Across three runs, the pswpin deltas (in 4 KiB pages) were:
>
>                         run 1     run 2     run 3
>   after MADV_WILLNEED       2         0         0
>   during subsequent touch 16327     15811     15676
>
> The mapping still reported about 64 MiB in Swap after MADV_WILLNEED,
> and almost all swap reads occurred only when the pages were touched.
>
> This appears to confirm that madvise_willneed() skips the private swap
> entries because the VMA still has vm_file and therefore takes the file
> readahead path. vfs_fadvise(POSIX_FADV_WILLNEED) can prefetch the
> underlying file contents, but not the modified private contents stored
> in swap.
>
> Are you already working on a fix? If testing or other help would be
> useful, I would be happy to help.
>
> Thanks,
> zhaozhengzhuo
>

--000000000000cd5ff3065a97208e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi zhaozhengzhuo,<br><br>I am not currently working on a f=
ix, so if you would like to take it on, I definitely do not mind! I don&#39=
;t have a kernel development environment set up, so it may take me a while =
to get this done. Let me know if you&#39;d prefer I make a patch here!<br><=
br>Mike.<br><br></div><br><div class=3D"gmail_quote gmail_quote_container">=
<div dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 3, 2026 at 12:07=E2=80=AF=
AM zhaozhengzhuo &lt;<a href=3D"mailto:zhaozhengzhuo@uniontech.com">zhaozhe=
ngzhuo@uniontech.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">Hi Mike,<br>
<br>
Thanks for the report. I reproduced this on x86-64 with the current<br>
mm-unstable tree at:<br>
<br>
=C2=A0 e3b5239afe1b (&quot;mm: gup: cleanup the gup_fast_*() call chain&quo=
t;)<br>
<br>
The test used a 64 MiB ordinary file-backed MAP_PRIVATE mapping and<br>
disk-backed swap. Since the test machine has 128 GiB of RAM, the pages<br>
initially remained in swap cache after MADV_PAGEOUT. I therefore added<br>
controlled memory pressure between MADV_PAGEOUT and MADV_WILLNEED so<br>
that the swap-cache folios were actually reclaimed.<br>
<br>
Across three runs, the pswpin deltas (in 4 KiB pages) were:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 run 1=C2=A0 =C2=A0 =C2=A0run 2=C2=A0 =C2=A0 =C2=A0run 3<br>
=C2=A0 after MADV_WILLNEED=C2=A0 =C2=A0 =C2=A0 =C2=A02=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A00=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00<br>
=C2=A0 during subsequent touch 16327=C2=A0 =C2=A0 =C2=A015811=C2=A0 =C2=A0 =
=C2=A015676<br>
<br>
The mapping still reported about 64 MiB in Swap after MADV_WILLNEED,<br>
and almost all swap reads occurred only when the pages were touched.<br>
<br>
This appears to confirm that madvise_willneed() skips the private swap<br>
entries because the VMA still has vm_file and therefore takes the file<br>
readahead path. vfs_fadvise(POSIX_FADV_WILLNEED) can prefetch the<br>
underlying file contents, but not the modified private contents stored<br>
in swap.<br>
<br>
Are you already working on a fix? If testing or other help would be<br>
useful, I would be happy to help.<br>
<br>
Thanks,<br>
zhaozhengzhuo<br>
</blockquote></div>

--000000000000cd5ff3065a97208e--

