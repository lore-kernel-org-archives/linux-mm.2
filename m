Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3005CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 21:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E15C6B0008; Thu, 11 Sep 2025 17:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9C66B000C; Thu, 11 Sep 2025 17:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF166B000D; Thu, 11 Sep 2025 17:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF94D6B0008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:51:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 960D81405CB
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:51:39 +0000 (UTC)
X-FDA: 83878316718.18.594DB71
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id B92DD40005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:51:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GFdnf7aL;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757627497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67rcoc0tiLSiwLVQ0lP6T2Ab+0hzeaK8IugOY+L2aq0=;
	b=JLRcdWJ1mcNAZsWWM5nwyZOEQXrsqzavhIDxL6wQD7ckCeaurpRB12a2lIokbmMPbQ3FoR
	Ud3tWGQgTVlbuEA/2sZmY1we0wwTGIV5YvVAc4rkEoLbsok4uZ7nVB2Mi9SWjrNavHVOTh
	MQSv1m1izdmGMMtrlNZAy5Ttx64VSWM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GFdnf7aL;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757627497; a=rsa-sha256;
	cv=none;
	b=Kr3gZNJ6DzDaJemYZt/dkC4jGkq0v46CvUsvpwFu2E1mOBggw8UWYxLJGVqiCsg7MgnAZG
	/dOsBwkUCbeNEAN4/wRZNWtEm+iB80UjwkL7XhRi4LFVsebTs10HpmVoo00KxQqaO8OyJ8
	7w6ihIHXzxVvXDVfI1pMbmJAindZ4oI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so159701cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757627497; x=1758232297; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67rcoc0tiLSiwLVQ0lP6T2Ab+0hzeaK8IugOY+L2aq0=;
        b=GFdnf7aL++lNfw6w5RbsmFHIPbZ6cmubIQQV0Tp2gDaHhN8oftGv4rmptu4DLYxFj4
         bNbYMrMWtov8QNHMh+zcvyxGDgzpyBpVMu4SJoe1ahsm3TtwygKBkqNl5KyqyX7JtAVr
         +ifBi65WOycRJKNP+f45ENrLycPMgx4byNE6khiibfEEAKmX5er1Sn8aduN/KGe7uYzp
         pbwEp31g91Y4M/Z7fIi+8tR6FZ2yapiMn3TVGkX9mJSOFMH4Y6Mo1Oytn8FVNmZ1oWEj
         qjxEAAEnUWCL47x8YzsE0bYtB7kxIa4nmUc+1senDQr0uKSof0CC06GqYsgSmAL8YxOz
         OUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757627497; x=1758232297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67rcoc0tiLSiwLVQ0lP6T2Ab+0hzeaK8IugOY+L2aq0=;
        b=pQJb4UC/EkCvRxRtWSljpYrN6pfSrKUUWvzpBmc0EExw7ExzUxkTYvlGJR2ORq2bm2
         dEF9fwhbdMg/7kcfYO8djjGM/XD0QRvv2gFkyRrXpE/pSS6jWF4hhFUjV2bZeKVtRVTQ
         ybjwqVJFJFk8yodxwaS29l+LZE9sHDB505oNCgeDI+u1idztepoDrW+LXgRybTk1swGx
         EcSO2RhQu4guEuqiMQtWxPQt7HNzyVEfC6D4ViXmhJw1CXijiuVFmHYMaB/KfbOKdYaV
         10jmgF7kNcvhqDNsy1tmGRCxlWlNeTVBRpOVxu3gNw64ulyFFO5JnTbwmf2hchvc+Qud
         wwvw==
X-Forwarded-Encrypted: i=1; AJvYcCVKhr+EQBztJMgaX7RrVCxL181AoqMLtBY5iynO+Y+2SL9RF4bRnJmM/GmJEWPQ1pptWGZbG1X5Qw==@kvack.org
X-Gm-Message-State: AOJu0YxcJ8xNbo9UVez+bkp6J838NIA7Uo7KEmyquU8KgefZnQlgPbgH
	OsK3qRqNEjYgsYdXTJNnFVkYANlxJteXnZzM6kG/lyI2Uwzis1LyBNytwRCHYq4KuQavH1sLay/
	qFbXd9NiTphYsnVsuA2PbXHPfU+FJjFjj2A/GlBIK
X-Gm-Gg: ASbGncsrP2mcIPVjZQkdq7R1G0Nuj1At6t5knYYDN/33P/CG8F7yZvv8BEeKCKfBYON
	CA/PloYDCdmOm2FRL52hc8VJnsZbbR+viL6zXaJY/8SjdaUxdFA/c55NzUj1sHWLNH9iKjGw3wN
	1TVaKnhgNlnyDTwUjAxCQrGtRxQF0otUgFAUotXaVYS05EneGtrk5+s7fbN+TZM2/4vLPdiB6j5
	n21xwabTv8sG62FJG60C4av5+2N8uOL32F/QATwaPPH
X-Google-Smtp-Source: AGHT+IFKCZ97d8yEAXy0IzqL/xIeSOsq8eTyCtL7p4R+IKNl+kbV2vPdoUW+XGceL7axm7TLgZ+JNFRKf5KyFaTuUv0=
X-Received: by 2002:a05:622a:c9:b0:4b3:4ed0:c6f6 with SMTP id
 d75a77b69052e-4b62522c93bmr17274971cf.16.1757627496389; Thu, 11 Sep 2025
 14:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com> <20250909233409.1013367-4-surenb@google.com>
 <zxbgiqf4d3nlww2xxoea7rud3q4oj2osk657xnhu6r7du4lf3p@es7mqt7joo7b>
 <CAJuCfpFV0d=JSwA8zDpdrg4C2TpTTZypeX0Qype-EFKHho2bQQ@mail.gmail.com> <yfebg4bs4nck7kvc3d3irbxpfja45pcyjbtip2jtcojiv5pj4f@jp53hiso6vga>
In-Reply-To: <yfebg4bs4nck7kvc3d3irbxpfja45pcyjbtip2jtcojiv5pj4f@jp53hiso6vga>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 14:51:25 -0700
X-Gm-Features: AS18NWAYJD7p3_wAWHt6t9BtXnrobKcobygiyfTNh5kX10qBbZB119SkJzlYs_E
Message-ID: <CAJuCfpEAfvFfFdNusJwPQGXM2sTMaB4RoEwjrUtwp1n3Afwk=Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B92DD40005
X-Stat-Signature: px1mup83k8qnunugaqm8g8awfrce3izh
X-HE-Tag: 1757627497-382929
X-HE-Meta: U2FsdGVkX18r3IfIcKSxeo8Mq08iLSjfeIJNStIPDSjDLVDlzicw5lKDxJb9PdgfcfhxL0d2lzgWFFSTOokRt5bEDozBJE+93zTZ/FqDJ8zkWaqAIfbBVUV00BKCOE9zaLTXFR1nU372lkscrb07VBZ2p/plqRhhk/ZsIHsHNWHlLDeE8Miax3VZ0m0b3jvDHkmH4VfVEPLNOWcUaFXjMbpLtMmmdTpe43l4XtfdHD6cHxFMJHNDbBioJWvXNISBTGYIlotJ61qgYgGjq7YNQegHVJI1GBlJLf+XGkPVbas5mVRxmH+5dN4Febi9YjN1ayEjkCDb4/dZTFDFbaGgIZTj9Dhgce6v5sR6yTbLvaDVITvscjGGBYomXDigL1D6qsr/uwSxT6fuuEt61dVdSg3t0voc+ezXSpry5dpJAzgRPtnvpG9qItC++yDAhGIYcRHxc8cuY0hYwdVCJZl2LMScBddWrM+1KI7LY5D+ot+PH+YHOL0dH77VUwjkb7kj1xoSelcoWmEGYnfj4/vHwCCQXSB5IWyS/VNEUisX40/auFOYKuAhyXr3tiRKrrLy6+g/K/9QKaIgrr4zyeBCYMhxtTzw+irWgGOFqrLF5gfkKzLvNHeRgzuycWWzHZ/YT9IAg+E5CJC+vVjsyWR1fMxE14qg6p8LFZYSs2YiTA6nFn2fd44zwW7BpR2UAyeom3egLow7IcPLVQ8YgbHblUXSqwq8ftraSm+jt9ss0mw0oT8G7MWI4Ju+EboHXA+EpzPzWGWyfoCtjzEkblPbpB4ipiNQqYpSaUTy0/zBZ0ocGoRDS5U6cZnmdnpJK6K8XWXUSZI+mgEJDL/1fBG2vSS4Vca9kbb2YP/RSr9n9QyPoplQ7ag230WDGdeYG3cVht24Sn8j1PuyozZc4F/s33ILE0Ge1Lu0mbf9FMjd0reiFfrNHJOZD/fhAatfvc4+dhHyzAcwr79GtLhWt6r
 nH0XsqLP
 8idZrEgmIQnGCf8ApXfd+2Mc6SF9fgCm8lAh6mTXhjX/S2Z9/SuNRd0d5VA0ilZ24nIdpcxqMqjWQ4rWfDmQW1lPrup/UOSQqf4vZSyQ4ncm2+Mfb+UGMSKTTxcZW6XCXdavIsTEZSX5gLtFdUdunTa7gfQlS6eCu1MXPXz3Hv5QlwEoqpumhVWMIPixmBwcrvm4sZ1oYgt00KaLRr+yBpgFK/+m4YParJkH3VgajsmZzgVmVMHifhqWuD86PhzN+3coCzFQ5zPX/JU0VCuYxW6P3YXpZ5dLGJcD7ofmuz8kuwKkUnfDccr9FHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 2:45=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Sep 11, 2025 at 01:12:11PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Sep 11, 2025 at 1:01=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Tue, Sep 09, 2025 at 04:34:09PM -0700, Suren Baghdasaryan wrote:
> > > > When freeing "tail" pages of a non-compount high-order page, we pro=
perly
> > > > subtract the allocation tag counters, however later when these page=
s are
> > > > released, alloc_tag_sub() will issue warnings because tags for thes=
e pages
> > > > are NULL.
> > > > This issue was originally anticipated by Vlastimil in his review [1=
] and
> > > > then recently reported by David.
> > > > Prevent warnings by marking the tags empty.
> > > >
> > > > [1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b=
8@suse.cz/
> > > >
> > > > Suggested-by: David Wang <00107082@163.com>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > ---
> > > >  mm/page_alloc.c | 9 ++++++++-
> > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 1760346bbd24..d21a411e807e 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *page,=
 unsigned int order,
> > > >               __free_frozen_pages(page, order, fpi_flags);
> > > >       else if (!head) {
> > > >               pgalloc_tag_sub_pages(tag, (1 << order) - 1);
> > > > -             while (order-- > 0)
> > > > +             while (order-- > 0) {
> > > > +                     /*
> > > > +                      * The "tail" pages of this non-compound high=
-order
> > > > +                      * page will have no code tags, so to avoid w=
arnings
> > > > +                      * mark them as empty.
> > > > +                      */
> > > > +                     clear_page_tag_ref(page + (1 << order));
> > >
> > > Do we need something similar for the release_pages() code path or is =
it
> > > happening already?
> >
> > Pages released with release_pages() should have valid tags, so I
> > expect no warnings.
> >
>
> Oh so this is orthogonal to your first patch which is replacing
> __free_page with release_pages(). This non-compound high-order page is
> not an issue in the codepath vm_module_tags_populate(), correct?

Yes, these are independent fixes.

