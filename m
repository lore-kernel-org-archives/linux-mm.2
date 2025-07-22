Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24B3C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 02:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEF06B00A1; Mon, 21 Jul 2025 22:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397426B00A3; Mon, 21 Jul 2025 22:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD676B00A4; Mon, 21 Jul 2025 22:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18D936B00A1
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:23:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DDD4110C76
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:23:53 +0000 (UTC)
X-FDA: 83690305146.09.27ECFE3
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id B08691A0005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:23:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fHSRFZs7;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753151031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/C+U2K3/i43umoAQCo3nc2pCSOMDyoCKEEcB2BDhGM=;
	b=z61Mmy/Kk+dju2WzrqsZC78fdEYdqOOZjWSH1S6A0ZJgbDxj5dgqFkD7bOtHWJFsN9KJCv
	1AZ0ZXbH6dq7wSiKEuIeRswlA0bavx6+Yb192LbkPNB+Ons4UwISZU4aghonFhjm1SoIgd
	EM7/79zzJZA6Ui8fZGGQjtQNmad/YqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753151031; a=rsa-sha256;
	cv=none;
	b=q3TXqfDlX9ONMnvQhIpl/5IABkuC5/96ZTM0U9FNNdkQN8WZ3r+glT2l+h8Zb40LUMiRn/
	nqGyCtxXYh9v4LLfqp8jdBmRRbto2NeKOimfBFLSdVN526C/hHg8JCTdEqVh8/1hcJZWf2
	S+wCthQmH9s1X+40WJbDQakbdxUVyLM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fHSRFZs7;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-52d9a275c27so2663084e0c.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753151031; x=1753755831; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/C+U2K3/i43umoAQCo3nc2pCSOMDyoCKEEcB2BDhGM=;
        b=fHSRFZs7llYzZzBJ+Dp+jdjKbfETJxPxq66r5KpJ7jslmuCAogdCRbMb6bDqehL7Am
         7zFfsMyKkDofHR7KFafloNdNgl6p1qImYSGScO4W7kbIjrB5TazAY03Wczg6YjnjpmtJ
         PS0pe8wZHLaS0AuFPCLWECKp0ngHlmdhzXovwLD4BNVqnRMPO3JFVS36rn2PB1Sp8On/
         84RmXzrdgP/9JBAwc/4u6BexUWmA56qZIrthvFlIVbq98LZNvXkh6vroZFH0pc8BMYBs
         T6YMSMoX2ZB4VTjE6c2NerHtB4VXDbn1WC4V7C+B/GP60M/1MCmH8eX4Z+jBYgLJ5OA6
         M4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753151031; x=1753755831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/C+U2K3/i43umoAQCo3nc2pCSOMDyoCKEEcB2BDhGM=;
        b=d8vO7xOq0qpvLJaBuvY04IStl4fZHm6El9su77gdlYsQtSzR0QZn7e+ztPyOEOXL+b
         gr7RmI9GNuTAxpM9zbOxOpO3ulzNd6vJI/VAiI7kZVic/9YRC3pWN9l35mG89dG8UPyT
         gEvyR/h2pd0mPvZlXMXed+tJYop7GQ13CiB1GuHDrCZWXAORQvrfzwU87Y2U/ZVfAC7H
         1UbGA9qrWhi1RZ44ZFxU9unHz854BSnNvW16/HUCas70lkKpQprjyiO8aJpbqihyhlnT
         hW/DPA57vhP4p4uh+ASWXzf5sLZJXDd3T9r/+ZFyhp+4JghexB1bPH8DqNQulsmaxFGR
         3DWg==
X-Forwarded-Encrypted: i=1; AJvYcCV+OxgcZf5OtEARxygdALhvCFmQ2z+06hX+I7HzBK49fkPvT+9/NOgTXflDUnv1bwUb5CKqqBl8TA==@kvack.org
X-Gm-Message-State: AOJu0YzRd4KHQKll9gufcrSIHJl1Q1D8BptSpsodE1Wb+fe1+3G3pa5Y
	hVVRcOyaZkgq8TC0q3K85VLJ/HvgKxD/cvH/1NkxiKDdmz4l3JKnEx3LGbR84SzEFPp/xppeXNp
	JV7UvyLhhTduoOOvCR45NN/qWaYOnJFw=
X-Gm-Gg: ASbGncvPFN+7dQAD2JcxkSltrmjINQ5J9mYF/ttlAagQYMuWh8lZJN2rvuHWdadgRzn
	ksAlKouoR2WzYnXcFJ/o5jnY2c9LYkSGV8RSR13fR5ThN+XCWJkbO2YI2GMZNcFIUo27ZlCLg8u
	dSXlxAwuU9kkv41Ydj/g1gKpkOUTCzFgdLmnnO1mOEz6MUONQ/8zgEXY43vKyI6pDqkkUffTe+B
	CXPDxs=
X-Google-Smtp-Source: AGHT+IGesNlr5e/sM49NBb9K/B4x7qfIWHZWh698rKyBwCLi7wWon4ZhVCgWQfP34NW6TE1MplcctXDbbJZ71bGMN64=
X-Received: by 2002:a05:6122:3286:b0:535:e35d:49f4 with SMTP id
 71dfb90a1353d-5373fcbc0d3mr10995191e0c.11.1753151030620; Mon, 21 Jul 2025
 19:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com> <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
In-Reply-To: <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 22 Jul 2025 10:23:39 +0800
X-Gm-Features: Ac12FXx4o5zzStPLAnFL7QFhqYq_Lgoa4m8TQ4nfuZBMUKJ2dVDoDaKYQTkIF2I
Message-ID: <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never" setting
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B08691A0005
X-Stat-Signature: x5uccid6jj9r57h3e51ggrphunr3iqqu
X-Rspam-User: 
X-HE-Tag: 1753151031-484374
X-HE-Meta: U2FsdGVkX19x2jaWX3lyNW3IB/pTfG7aXbhIvfV9/9YfWFF85FfirONhgazatXMkTyVspihLZrrJegxWvaVZyrYhw6v+2cT8MglbTCCT7QbYmfrfWvMRCvjyWefaOjvVWK0YXl0XIM4S94d9W8m3PbWSybeGNyYL3KJr+D+rKrdyxsQCcc9JOZF8zs0X3AnMhnh6+qNqMbg/ciQ0c0IeeEUCJF8gs8Ej3+LsGq/2UexOPBh1tZ25tcR+otWlBcKFKd2pWJkgMdtV683H8gxlXs/2td7DzJYgUeOHe8WtIqLulhiLTHt2zFTwqPDJCrX2469HeSHLg/ClhApEZuggrktXhlXs7+m2PkWmihlfggZ2HOjz8dPGOL3MWSFPv5Z0NL75ioiEkuUkQuH98vVWi0UlbTnRbuXxiU0XLPaALi5Sab9tANerqJxtAWM9zJMAB5r5I75mMt8y7ApvhwC9XIC0Z4axzRzncV1WeFgc3qa/kmV3J0bWYP8zkERYeLJhWXp5oGc1Tu64IHWnN9urVdqJLurD4zDFD6nyJd2saA6keHiPweybvgdDt2ldhIEwH15bcqe/WOM85Mf4pDUZ2VLcR9bjJuHzAyLsxg0RKze5rTzQjEJIVMSvD//aR0RpYezo8zNVUvP2YgMH8Nt6UkTQeRknX5iLRQ7l9/lYeaX6eoiwlia7fD1tPrjMooVKOnChesSE3YjdBh50lvHVzh+unp9DlWU60r1pDgrXcKMwkYaA3tQoF2VB1A3MsyRyfGCYZn+N2iMn8iLq+k3LDj5iYF6Ezewq/6zMv9MjQJtl84b+//57GFQKrxD2l4JxpLL1vOj4JwEDjHBioYlBY20pVsM1fLjJbc3+mXxWbBRGY8Txow0+YdhYzb9N62KDVy/NEQRqfNgbYpwWazg0LOhJ7gm1JKdmPAgPnQTIZA//6Pi8kZajvy0EQ0wCXc/iZuaCspjyGtHfADJMDWY
 DgOQzPpU
 tCqVE3yfIWL+wq0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 9:30=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/7/21 23:55, Lorenzo Stoakes wrote:
> > Rather confusingly, setting all Transparent Huge Page sysfs settings to
> > "never" does not in fact result in THP being globally disabled.
> >
> > Rather, it results in khugepaged being disabled, but one can still obta=
in
> > THP pages using madvise(..., MADV_COLLAPSE).
> >
> > This is something that has remained poorly documented for some time, an=
d it
> > is likely the received wisdom of most users of THP that never does, in
> > fact, mean never.
> >
> > It is therefore important to highlight, very clearly, that this is not =
the
> > ase.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >   Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
> >   1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation=
/admin-guide/mm/transhuge.rst
> > index dff8d5985f0f..182519197ef7 100644
> > --- a/Documentation/admin-guide/mm/transhuge.rst
> > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > @@ -107,7 +107,7 @@ sysfs
> >   Global THP controls
> >   -------------------
> >
> > -Transparent Hugepage Support for anonymous memory can be entirely disa=
bled
> > +Transparent Hugepage Support for anonymous memory can be disabled
> >   (mostly for debugging purposes) or only enabled inside MADV_HUGEPAGE
> >   regions (to avoid the risk of consuming more memory resources) or ena=
bled
> >   system wide. This can be achieved per-supported-THP-size with one of:=
:
> > @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-TH=
P-size with one of::
> >   where <size> is the hugepage size being addressed, the available size=
s
> >   for which vary by system.
> >
> > +.. note:: Setting "never" in all sysfs THP controls does **not** disab=
le
> > +          Transparent Huge Pages globally. This is because ``madvise(.=
..,
> > +          MADV_COLLAPSE)`` ignores these settings and collapses ranges=
 to
> > +          PMD-sized huge pages unconditionally.
> > +
> >   For example::
> >
> >       echo always >/sys/kernel/mm/transparent_hugepage/hugepages-2048kB=
/enabled
> > @@ -187,7 +192,9 @@ madvise
> >       behaviour.
> >
> >   never
> > -     should be self-explanatory.
> > +     should be self-explanatory. Note that ``madvise(...,
> > +     MADV_COLLAPSE)`` can still cause transparent huge pages to be
> > +     obtained even if this mode is specified everywhere.
>
> I hope this part of the explanation is also copy-pasted into the
> 'Hugepages in tmpfs/shmem' section. Otherwise look good to me. Thanks.

Apologies if this is a silly question, but regarding this patchset:
https://lore.kernel.org/linux-mm/cover.1750815384.git.baolin.wang@linux.ali=
baba.com/

It looks like the intention is to disable hugepages even for
`MADV_COLLAPSE` when the user has set the policy to 'never'. However,
based on Lorenzo's documentation update, it seems we still want to allow
hugepages for `MADV_COLLAPSE` even if 'never' is set?

Could you clarify what the intended behavior is? It seems we've decided
to keep the existing behavior unchanged=E2=80=94am I understanding that
correctly?

Thanks
Barry

