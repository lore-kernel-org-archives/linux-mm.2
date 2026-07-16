Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F69C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11A86B013C; Thu, 16 Jul 2026 11:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9DF6B013F; Thu, 16 Jul 2026 11:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB806B0141; Thu, 16 Jul 2026 11:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBAF6B013C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:28:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2D80140216
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:28:31 +0000 (UTC)
X-FDA: 84995021622.27.50768D4
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id ED95D20005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:28:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f1/1nOax";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784215709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
	b=FXJ1PHMXBPWJMYNHbJ/p1Wi2J9e2liCcFehnAMwXHSxktPPWhxVT6kHmu3glcj/NCHHN6S
	n1RxPjiWKhODi12YzzfO2mvsr2Ok6v2CHQFhc3s8NcyXM3ej6qDwQ4MSJ0r9RiX+OAH1gj
	uQb2RF9uNYO5oRQsUXAp9FrUnTrWeJ8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="f1/1nOax";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784215709;
	b=5IDSsWUZfcvYSS171rDBkwL4AdTYKLJJJbQ6v+gpK5RqTQiu6vTbSNR1s3imuWdkxNXOOV
	yYIEKJ3/lRFxHUexD1a0h4qW2iXtbZyjbbdcgo9mM5B81GPFAwEqXjcD3oXBHiOWXOTP23
	tWdpSoWKuQCzRGiRBGsGXZG/tdEkrA0=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10e86e52so30481cf.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:28:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215709; cv=none;
        d=google.com; s=arc-20260327;
        b=WmqQ9pzTBCfhthUr2mQ8/AILtVM+7UQhS4w8AReA+ud7RLXiwm9l2vLrkvzI2gxDX2
         57NNVfNa7/DoslgZ2Nt+m9afzgoXYOstccvaXyuJ21FCYP0tK2y+D7Yz49UiWGPIMBsB
         kFP+MCkrDItglClFJFUwqTZwzywTe/ZHFxQtfMDuq5ODv3MOMHg4g/PHhwLMl3a1w2oS
         d6nBX3IE7qs5F6WIE8wN7W7z+3ruZ+VjVEW7rbg7iQuS1Bj+nWnqYcOWfQASPc7fFnuk
         MYXcM8OSVbS2gCg1XRSCF0eQVYabGw+xlLqFBOCD8Q0JmlsE8C+sEgdRtr/1n4IM6DuC
         aLig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
        fh=xkI95bapSSrnNNh70/GK7J4v0quP+qso3sxH+iTs2IE=;
        b=kd9LRXnqLTD+2RM84SiNwAFC2ARwIw9t/gWOgp5FRiDHzHGz7U1PZhAG1TwgjZlJcZ
         mGQxkVPM+iIzMJtQTZEUIzipMhOI+3RVgJD8+tQeL4cZbwHuuLmDLjJUgu0j7vyo1IT7
         KqyKpYbFVXI2W7fPktkT9y1MNgDl2HKq/2ct4qpXoT9nPZ7bxusE4daqa0upblRDZpsk
         LixJZLk6Uw6bSFNc94KF5sa5LiNv17NxALJdiwTe5azR26aK/byIBGIdu6Wcg5cbAR6V
         qaMDxFrQ2PSNO2OWNnwil7rKSohbzq7tnbNVIcibIerdDRLalYJiYhJfLRy2laEjXzD0
         V7jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215709; x=1784820509; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
        b=f1/1nOaxG9E6Ci39RCdyi3phQU9t0qfnJVEefCQMozCDBAYfDL0JDFs14C2yjh7QLL
         7f5Uiszo4qrWczBEYbnDNS0+OxGLyj2xDYmYGTE6Z6s4bCYfFTFOYaOtPHBKFhKvAWhy
         L+rH7lbE+FciG4ryyqWL1VcKcx6RHrBz1DmE2El4qPQiPc5jPR3ycF1Y0dO5zHQleoyD
         VwZGijaC9mmcHv1ydx06oEM1EZK9gtFQwFkS2jNE3cMkcf7Xl0Vpai6Cq/hxq3GGrhyT
         YSV4orczyZ0b8vsrRmUMM0K1xMaon/cNPVAV6t0Wx4+WWfzOcKYkwIwZCu1dWJLVSaSg
         OJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215709; x=1784820509;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9MTmsp7P9R6NbE0jd3nKRTx/bls+aSkmj63tjPdkby8=;
        b=hdA3TEEdVQ/juwoVCRvJ+DGTHZtPfmeyVCm+rOFQVQrWjr7iqi81ZFgq+ZJvy/qFWr
         w9B7sHPhjcjni9jf322uJbC811a4I75bPIL1WbX14d9A885HxJFdecGlb1AcmvNQxLfq
         ZAbQSiUevBlQ3t6rieUvnSTu2gr3mWHCHX1f5yeyh0K89yWFg5p3SqxWTWDRp922mObe
         Jy9RCxC1S8cCMp2pZkqHjNg7/tSpg43QH9SDOdYexQWIDXqZcT/VhNxnsqM28WcK+5vz
         kJDxfIHosiWuOtRBkxY+Rvjc2z4/heofsiMw4EaVJ0kRoMpUr2LRaWqkAuWnjpqeoMJi
         kRJw==
X-Forwarded-Encrypted: i=1; AHgh+RqvkVnYEI3VzhcoWzeyDPEqx9pYuyA81EESIK36FgeRpDDmStdtSRMkeV7e9qk6TJ2NnMTWxX7YZA==@kvack.org
X-Gm-Message-State: AOJu0YyFzzJpphx84IXdmTQAJLq4/9deRIKO9igL/v81Rzn5xrSthlKG
	Mi7FOGDoWOo/VsUvNrsEf33jZQCpIzZcEkDnwRwWX7VL2nTMpFo2qBJlq5XsK5CncSZJBfhoEB4
	RxA2SnJwQK8k6psz7fta3YVffnyCIcJWlhwoT/3rX
X-Gm-Gg: AfdE7ck/98sl2Ln500y6aivLc25FEgtmSVcw1Op9KlFcdgrc2OaYSTwKouKA+y4RM2Q
	dFuKjS6kHg1mc1LHUew9DPS4jGxXRntcn+jykRltDNRIHUiH6Cp5AsB5mZ7x6kNNgfJBovfVO7Q
	IVd5tq/CmX0M09XnWBK6FSLZ7hJaCuqyVe2siUEXQMxqJCzAWseIdNtyFG6HEzgGe6eSGSqDWju
	s5A1jeAG168Cyfj5OjZsa3VfDKXuGUSAvUx7pRzMIY+g3oLLxSZcWDmF10iPkWL/09VBlHo7GU2
	TP1/zNcey8baOU0=
X-Received: by 2002:a05:622a:2618:b0:51c:e80:9e88 with SMTP id
 d75a77b69052e-51f7f3ca787mr11136661cf.16.1784215708609; Thu, 16 Jul 2026
 08:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-8-9a49c4ccf4c3@kernel.org> <CAJuCfpGq3Yv8Dq=2mPgR5LGC=40VSNTA6mg4BjTRE0ADXMZkbg@mail.gmail.com>
 <01aa6803-e6a7-4172-94ef-043914e2f794@kernel.org>
In-Reply-To: <01aa6803-e6a7-4172-94ef-043914e2f794@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 16 Jul 2026 08:28:17 -0700
X-Gm-Features: AUfX_mxXFm8bI5YPQvcEPkQ_QsAl3HLbXj-fL32BvT9M-JPrvDl12nUblHbqJTo
Message-ID: <CAJuCfpGDzsoTp0Byg5QzeiOOJKoPWNXYcADOXC4hieHLNu1HQg@mail.gmail.com>
Subject: Re: [PATCH RFC 08/12] mm/slab: change struct slabobj_ext to a union
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED95D20005
X-Stat-Signature: 199mpgcby1p6jk9r3wksrpcobwwbyozp
X-HE-Tag: 1784215709-330567
X-HE-Meta: U2FsdGVkX1/3afP5N6WwUN/uQ6WIjDZjBR5MpMQSUd0/YXCURt/DTMkwH8fEFHVlpXr1EMd3vRb3i3NMeSa6y4u7Fw0yP+mQ34oTWiU+QKvskZHq49LUtQMPrqNeBRyImm5CKC1elmdTjtZHQCpD1b3amtw5rwKOLpSVZcbRq6/zr6MeRDz7AJ4GPcIGdL1idG/Mn0vq4jNwFrNZBmx/hQFLjJP6fiiNjewkWAdx7J34FRKKw0ibHUf3KFyXcaHrj5Y+zqxRqaIjDgqhnGcjFxzEUgo8lSidVEhrQ6csaPBOLS3vAVAQ40jvEYx5Wftg+c77igDctifVzkNUJVtaiCvIC57Ah72RTSVixotB4IIaE0gtHzXK1dTRfmfk0AXDK4RuxK8u0Wa7wBfr1e5Yg8goyq6+HTlHruTzMCcrgSMZsHaImSi9mlgViw+MKZcNQFobWUqB4vg2PtjbfQbKb5k/lneJp1dPEFN0vlw88dPVw2z0XKQF1T/HJZ/LA3/rNPCrv69t8ccxpVO4pRpsm4z+75dEa00nuz68CBjfoBLqIHK0QZ806VzaH1Wos6MqiyRrExzJ6HO25ojD550bp5oIEyMCiynsxyUU5EaXcbNjWuWlDbu7G2VT7Iz9Fhhh0106JF9wSTzRGkifqFrhZHUePJ2Y4PW/XmLwMUtw6IFia1e17OClruz2EvAPI4BYzLpd9gV5Lze6CC5qib+TLWQebOkeOFGGaWEZ/U/4+rowIwDoG7Kka/XzlopNy9PunXB0z5uMG7cArWNVrOv7Mclyx/Tt+aGk2lwMVsus5v1mMfUPklDkBnfOZhcl0iLe8fIwAo8A05SHxo6114MttaJjxWG59WXiqDscjnui7B0rAUNzsgX9uyGKS1PRPtc4acHA2okHDl6Wsqj0FTUVaOCa3IiDwjDJ2m0/ApP0By1uV+9AyJrRunFtGBIXzEQ+IACDdhSi5SlI5OtO04m
 I5a4hbym
 n1dMdfEQ3WPaK+UBa2PGNghSzh83/TKya32tvcAX0tLuXz5DPd1twxQlpAsnUVN/z0wtsAZiOFkVDaWXKGplnn3fNM8TwMjVOti5xL00sT6PWup7PFiU7UzUPqOnDeUEGNaMcVUX2HBNlX7tpH9DTOIblt0+Bg1TqLhJ8nRYAUlQwqwyhLNgwAKF+qKRM+arc6a9w2wsLCHp3sUfglsqtR9YXyqk8BAmAxKOLz8gTcvpmDpVZkkrMuiV+muHxGTUx8tAlpTxSE1LXQ2M67XmoPLMckWwpMmZ3U+X8gHr+wV/8VVy+O/vWicz0TuhEipY5LDzUiCv4lLb/YpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 7:43=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 7/16/26 06:11, Suren Baghdasaryan wrote:
> > On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >> No functional change intended, the layout is still effectively static.
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >
> > This is much cleaner than what I was preparing. Nicely done!
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> >> ---
> >>  mm/slab.h | 41 +++++++++++++++++++++++++++++++++--------
> >>  mm/slub.c | 17 +++++++++--------
> >>  2 files changed, 42 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index 3ad9777ad600..359ab8caf61e 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -554,14 +554,34 @@ static inline bool need_kmalloc_no_objext(void)
> >>   * if MEMCG_DATA_OBJEXTS is set.
> >>   */
> >>  struct slabobj_ext {
> >
> > Perhaps we should add a comment here stating that every element of
> > this union should be pointer-sized?
> >
>
> OK, how about this?
>
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -550,10 +550,14 @@ static inline bool need_kmalloc_no_objext(void)
>  }
>
>  /*
> - * Extended information for slab objects stored as an array in page->mem=
cg_data
> - * if MEMCG_DATA_OBJEXTS is set.
> + * Extended information for slab objects stored as a pointer to an array=
 in
> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is s=
et.
>   */
>  struct slabobj_ext {
> +       /*
> +        * All elements of the union should be pointer-sized to avoid mem=
ory
> +        * waste
> +        */

Perfect. Thank you!

>         union {
>  #ifdef CONFIG_MEMCG
>                 struct obj_cgroup *_objcg;
>

