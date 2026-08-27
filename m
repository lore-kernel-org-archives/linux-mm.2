Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6DCC61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 01:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3A86B0088; Wed, 26 Aug 2026 21:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABD46B008C; Wed, 26 Aug 2026 21:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F046E6B0095; Wed, 26 Aug 2026 21:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C99286B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:24:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F45214020A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:24:26 +0000 (UTC)
X-FDA: 85145304132.02.CE15B0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 490C51C0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:24:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNzUrhEs;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787793864;
	b=ZgXR6BEyLLKrrP5woJbvHiOqPNGK5vpOiXqgLQ/zZBdls0aG8H4GKLrcxEA85Mkaz9mQ2v
	vE7CR0cwnxpvjse9r/9w4W4Duz47Sa1LpZC/Vt1s5E2aS2pxga5yj/DRTnjmTg++kbiIoP
	jNyZ0InS3e5z1tYGk0lvpp+CHshbUwY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNzUrhEs;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787793864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQaF2XYCw0UqjA7wFgy6Ma0exqCO9jPfwIWCMzyga1E=;
	b=1xHbZku1zTBBMxQGC4s/Qqijos+0NmQ+iJWAsBekSJA4sufXvUd34YmyrSU1k/pM7oZBz4
	qE3DE7fx911KTF+vTpz0kX+fM70aJ0xEuO8ys1gnisIDxzLqlTIvHcvkX2lXMw2H62oFEJ
	yyAgN0cK6snZPQfeTqyMaGtyAm6S3uk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BCC743ECB
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4272A1F00A3F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787793863;
	bh=PQaF2XYCw0UqjA7wFgy6Ma0exqCO9jPfwIWCMzyga1E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hNzUrhEshXc26SmGiGBHoB439gJYfw9HCnrwOSDQlFVDUMjwa4I+PLxuhBt+9iSF+
	 Dv1Kk19HGzwkwbSDu1bG0vbrk/At5f1VsiqDa1knU5ewaPyN8BiBoz0SeUSMzur4yP
	 63K1dwnahsY8v5dHhYlCdmcKGjV3GYFW36zUHAWJygq/lztFerRcauPelQ5i24j9hY
	 8zJTbm0tTb5rLf+oCNVlMLYseNOCm4pA9sMUrb/CmYRIEs4tZxT9vZ1SMO/FheF6GQ
	 tNl/1djzxxU8ncUshFmOQ9mOGKvuaQYmvtOqq4wjF8xdiXB55KaZhEuzvvt3r/VpMK
	 /a9zuwSl6ZKUw==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c8e2e39easo17473051cf.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:24:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqUa17Qtb7TTF89xoxBi2KloUHFhzQQIQKdk79l+bljNJZrK7BGLiJpsw7OMHU2gvjHPRZaj8E4fQ==@kvack.org
X-Gm-Message-State: AFuF++nGwrJMvI+FuxHBx+m8wYwOgRucIolmkTTzbe8AEH2lSrHQEWUY
	xM/xYAjrud/DST6pf/2rNVuRrIPAB5rrm/s0fmURvxWP5WabEfeKoK1FATjymYB51sMkNLtrTxE
	SAZz+K9uvn2lgjGKZdiFxRHmzaW/SAEE=
X-Received: by 2002:a05:622a:5144:b0:52d:6096:b398 with SMTP id
 d75a77b69052e-52e423193c5mr121277711cf.10.1787793862520; Wed, 26 Aug 2026
 18:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora> <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
 <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv>
In-Reply-To: <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 09:24:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
X-Gm-Features: AcwNN1WjsBANY_EUTzkF7Ra3M4p0_sIYtGKnM5C4G_HdYSDH8YFZQRvcUca6J2M
Message-ID: <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 490C51C0003
X-Stat-Signature: wbikrnneabqe1qudw1nbmiamtq599eq4
X-HE-Tag: 1787793864-290227
X-HE-Meta: U2FsdGVkX18G1Ciy7LII5vm2zDVoX7UOxyaTL3mYgzwwe0ccDbgaXZQ6XljpURAxY1DHNqH1cfiTo61pGbbXld6fYHS+e1fpRBdw5ZX1/+SLXtdCtNLUqYANL3YujotPC57LVMnEDsO01BxkVz0wQ8C1+yEEZNbvKNQCqF1ad1M9ueoSnEZKcmGUC4kss3FZ6bXSlVoNytdGOY9izDTXZxRDVVdt0mCFfz7m7MPianLgTfg+tpfcD56ar4xJrBM78XVuOyHdjahwOVdI87HXKxDWv7wwFeBDXrvUZeT9TAz/mDo/w3ItbdYtcDjf8myDThUGBogiriKWhuDw8sgbht2ULpVXFw7F4zEwm3vj9uQqhloQtM+yLeALoZEE+csHLNUvJUUenHM/WlrPeWrW7PFQ4y0wXEX5dj/n8Xvmk1zuQSD1kwc5VG1YuJSc9r0r+aRSQvueEyKLL19wQ78xtdQLdZVDeYYf2LKP8XtyOO0hRO60+b/xPPQbxV+Xzb9CCeqwcDTWiTl2S+Un9ul9uIyDPymqzsveWHU4h90G96rnYkppCydpARjZ2TrAuKe8UY0KNAfHh1giZ2m5a2uc6gOISntSxxjAF98Fdkhrj0cSqLwgdv+a/0Ngrem/vwp3BUVCJiDftkGLmBpTYnRXZ9VVdPMMkZStMVDIDp01mDgF0C3B0sctEDwvA+lBFWCF3imD58kKaZmL9UOh8tkQK3iAhU6X1Nq59FiMsrUAJGvyVBU4XncdNuPW4zajLoZ4RAfNIa38lGszYD6ZgDTFnSyy4ClAZmoW5wrT9uNUNmpbw6aExDXIJq0Mv/g6xXx1m9kGLPOgDuGHrxfV8ckchDD/Tt0JcCM2ZIwKDOtCNSFyJvtYutdSbc8UH+jshYlByNsDNsMxXbEHjsUpov2XgXdTaX4pY2GsbfGaseFcO/fufWdPK5A/q8Dgtmq9BsBHNS+AUXTVFI3l3IrNE+B
 JiUrwhZG
 vALyAjPBOM4v/0XmlkyaLJ7fFX3ynneGpNijnAg9Fi4fe4UG205PJJ3R7RgZbA2VJpLK1Mr9XOGFJL1RssE1QYTrxhMLGpWafrlKRcUys5KRwYWG0AKitkgXid07LsFHOHH7E13fJIxU/Ye9BCFA8jfIAWt5m3IAtP/Jksy8tNbtjWewdG7jytwXO0Mr3Vy83P7JZMMhj8cPn2tmSp+N7cSnL6YpQhb+gXhweIDqwhn0+ut03qCuKg36sa3dobtwXwoLchckI0956kNRzdaK3zcmVHYGqMyVxgXY72+KEF/gDnAWzQHYjK6cfTz5UpwNIQ9Vz8FCM4WtFJLTcgam3Fawkliq9zJKQZl0HCQV/pxtrvxnlddvVKZ+bH1ON1AE6jroFP9HDe0zaFVUMJi3KJCkP7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 8:46=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 08/27/26 at 05:43am, Barry Song wrote:
> > On Wed, Aug 26, 2026 at 4:56=E2=80=AFPM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > > During aging, a folio's generation may already have been updated by
> > > > folio_update_gen(), even though it has not yet been moved to the
> > > > corresponding generation list. Such folios are hotter than those
> > > > already in that generation.
> > > >
> > > > It makes sense for inc_min_seq() to increment the generation of
> > > > folios that were never promoted during aging and move them to the
> > > > tail of the new oldest generation. However, folios that were alread=
y
> > > > promoted should instead be moved to the head of their updated
> > > > generation, just as sort_folio() does in scan_folios().
> > >
> > > While sort_folio() move protected folio to the head of next gen too.
> > > It only moves ineligible folios to the tail of next gen.
> > >
> >
> > Hi Baoquan,
> >
> > Thanks for the review! I=E2=80=99m not quite sure I understand what you=
 mean :-)
> > Could you please clarify what you=E2=80=99re suggesting?
>
> Sorry for the confusion, Barry. I meant this is a good one, and
> sort_folio() has the similar issue in which the protected folios are
> moved to the head, wondering if that need be adjusted too. One consistent
> rule for both is better.

I think it might be fine for sort_folio() to move protected folios to the
head, since those folios have either been accessed multiple times or have
reached a tier higher than tier_idx. They are sort of hot in theory, right?

if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDTH) + 1)

But for inc_min_seq(), it is just catching up to make sure the newest
generation doesn't overlap with the oldest generation. Those non-promoted
folios themselves aren't hot , so I feel these are actually different?

Best Regards
Barry

