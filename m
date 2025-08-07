Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E95C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 20:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB3F6B0098; Thu,  7 Aug 2025 16:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974ED6B00A0; Thu,  7 Aug 2025 16:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864086B00A6; Thu,  7 Aug 2025 16:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 738576B0098
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:05:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29288140B7B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:05:33 +0000 (UTC)
X-FDA: 83751041346.20.AD1B425
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4473C4000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:05:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XxCrht3F;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754597131; a=rsa-sha256;
	cv=none;
	b=wqcZkDRISS6AxDKZ8nsgut3SPHmzCdhCGAOwfDjSwaBKd88rkJ7xHFwfCx5HhkZV5EXqRp
	svzjcgTmsK1+kAAaPebGGC1tqB3Vp1g2kPyQOYJDZndbHnjuM8qrNtMlilZKMSMMoY0sNs
	ostqSyp6WcrPT0qDEzFESnDx7B8tfs8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XxCrht3F;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754597131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0C61XKHNGp1+eioPKY889x5RJjYc+RK8QZh4oQMa/B0=;
	b=CQxvQ8inkTs6922T6/3TkMXB542d43khkAoM/vMcJNmug8/GZCcQmCoddWOytfQVx7zL5v
	N6uqQigC7/ttmlbt740UpnqfJUHivdlGrT5rnt2ynhLq7VuYDIAWXVDfbBPQS0yi+SrJc1
	Y+UqgLT68/SMlhs5sXYP05G5W0Fyky8=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b0673b0a7cso76571cf.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 13:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597130; x=1755201930; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0C61XKHNGp1+eioPKY889x5RJjYc+RK8QZh4oQMa/B0=;
        b=XxCrht3FQIuEHzADK9/qL8yxzFVSu3swD+4+TFlAzRjYPaScIru1XPjXF/92HQdi2e
         gGXhdVw0QMWaskS8Cp7+KXCiKFXUUG2KJbF3Fq86EplmyriBRDj0ekCVh4bNOm1Gj9cV
         C/bG59QnwZ4tg0QA9Z9PElymYsC17nVPWbMcsUdnSrZJ3z1iTKqzQl+fR149CAs9LOfN
         mrD1vhoacHe4u6fF9iyGejzhSI0P2D6yDvLfsCvA9Vf4Mui/uaTMMwT+9WuWkFpLNWkC
         WT1XDZwpc/DHfI5sWrx8wR8BwnqcaU123AQBKqAc8G3u+67IpYM//tKQNpq/NE+QQrjt
         ZFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597130; x=1755201930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0C61XKHNGp1+eioPKY889x5RJjYc+RK8QZh4oQMa/B0=;
        b=HYd4e8jBsAg4u9Bke2Dhw87nl//GI1ZoYR2pgr/GAnTv72tP3KJhBs7CNyLESg6gJm
         fT8+YcwaLyaEA4BRJBs/Sb1cNj8XOtxgAppusozxZzOHk9bLmu6CvXg3E2zypk5GLq3D
         mHzHt/hZjEf3mzRTwLHjFyYcV9Amse+1VNUSJXX1LRRlx4zmVdS49SsZ1A25oVeocRB9
         w8NfVoMs7Vv1j4wvtpA6cec1EuH9I9PjALbXAfChjW+m761gaKQct09EnvLvo2qpsrck
         8T8KMhav+aoV6ppgcrOEhd9SkPO4Mr4ayCgKybeo1mo4Qb2MuXDy4NxOg5RaGveagTZ+
         S7Jw==
X-Forwarded-Encrypted: i=1; AJvYcCUMQH/7+v5uaQS3LphGKsJtf+OKJoDIdnK8xs3OjuUJVEcGUoBpgBH81+ft9OhrbeKIn/UBeltkfQ==@kvack.org
X-Gm-Message-State: AOJu0YxPzxKd24eFxFKI/1uHTwjzAZJslcWmsvPJtxzH7wQlfsjK9GEY
	CR2GNwcpSMZmA28hht0VtkubL2EG94VTHttZrWFCigxyFOXr1patjvscJX/Bs8e48UQO0rHakOa
	v42IrD3+iloNa2DpmzySN6q7sdr2VKGwKJPxg1IjX
X-Gm-Gg: ASbGncvPUj5iYrUu5bixZ3Ty8NsSAVtySj+sarxyCTTQQsv3L+cGmBc/0A6VqrY0Z7h
	yPRqlq13StDYMmT4H8dXmFU4ckVAqkt83+EUMdFNxCGzLQ0yNX+mQGGB317ZquQJipS+Z0IjgBJ
	RXJf9YsrB3SBfUv+iBLAIudF7cZVyGQRbrsPNowMTLzWK2jizOiI9elHnFmK6s1lhG/eeAqOwjx
	pwo+2i0odW+fVI7T3j5fWR7O/xzIM++J70=
X-Google-Smtp-Source: AGHT+IGQMe/wQvvb3DLWm+i0vcjYFqmqa45BGVHVdA8UQtjXkWXTK/VdaJDL20XcA1/NNzl54vQHgeEojTt03r+bOWo=
X-Received: by 2002:a05:622a:1491:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4b0af2645f8mr894961cf.3.1754597129862; Thu, 07 Aug 2025
 13:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250806220022.926763-1-surenb@google.com> <3eba855a-740c-4423-b2ed-24d622af29a5@redhat.com>
 <CAJuCfpExxYOtsWZo6r0FncA0TMeuhpe3SdhLbF+udtbqQ+B_Qg@mail.gmail.com>
 <43f91e3e-84c5-4fd1-9b63-4e2cb28dab36@redhat.com> <CAJuCfpECC9w6RdfbH34Y906uV=egUDct=6H54Xn79okKK80cjw@mail.gmail.com>
In-Reply-To: <CAJuCfpECC9w6RdfbH34Y906uV=egUDct=6H54Xn79okKK80cjw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 7 Aug 2025 20:05:18 +0000
X-Gm-Features: Ac12FXzODY9k8UiGEYg8VNmmjfzF8pjbaTykoNeJX-IcPkHHbmkD8MlKlZ5muOU
Message-ID: <CAJuCfpF+OFZ3RNFaBVBQWmCG_EKxj9Jrb4QGz-Ladw3HJ9AN8A@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD
 is a migration entry
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: friam8wan7tcb3gsf8srs4od8kdruddh
X-Rspam-User: 
X-Rspamd-Queue-Id: 4473C4000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754597131-377039
X-HE-Meta: U2FsdGVkX18uAUxbZH6gImlWBXIMbNWySWTh/L86GP6kkeslLRj3N0GLjSpiV2apPXg/OIzkr/3PadYq2eTdjZLd01QzEqx0JHfnf5op1lt5lDbPGcCjhoafs76jEuC4GDEBPTKvb3gyewV8n10+xQ7WCgKjUfAdHwhxdpiLE2xB5sTald8KMi2TUTFH1QSfp3hmrtDYhP6ol7whWE84bTtvJrpAI1nfSe78d/NC7pdRXzGXWWt+qrR2blMe9JvlExsKEQF8hvJqLYcgLKuZXCbTiZXQQU/2+D4m0EbCrv0ZbK88TAVRntyEr9Cy2x5JjVsxrhUkgoR6hpBUeKyaA0zjt28dUMkl/qGceI8zS3NBbHD1WyaRf7eiKbhAuQ9HwA0XYZ4oldz/P77KBpk47ELUVuVPfJtUIpMLCueSQ0QXIhqaOTht4Eb3QKjz3zxbarafyMbzvCvT547l4GG2f72E0k+ux/q3gL+n+wXmWVojhFjNGAV82kNzfHmebdLftSBjoSW8C6c6qPnDOQt5OZ+yh+q+5mc0ubYZkt9lZzZLuhC3cQkPX/DkRubkrL8rSlUEVz3fsNIr/ik4GncVP+FhC/CsvjTLuC1CjkRhOj7gQiJdcm9EhRM34AfkqgsaQP4iNQxk5Q0V0KKnez+1xVDEJ37JNYajcPUhXHyByCvka1axBFE/cLuH39lQWcsN/wnzdG6ENf/TnKfeeDhf+6lHc5Y1AxAx2ea9s54zL3ms2JLVDodch5+CAcCd2U0bYUk2qESzCz1cXfgwzBxd5vh71m6HA4mCWtkaCcBJDQMGvMKI59XU2wMQPjuVsLlMBAswC0VmZbgVkkMK6EmCOhU6ASfiZWZim/0QQzgaJymJjeGAJ4Wm38ro2SG9DPwpJD9i5ZyTlP3VhW3BSit9xt1eSxrACd3hxjTsuyFrxsEb2i07E2DFn/3xshsAKu+zc8tYfgCESduKF29qKM5
 rz6092rq
 mF8xAue9MLZGKVGQ+AeHIyk1xZDQpH85YsbyhESkx13X9/rZ1lVt6P8NG7v64Y1SLsnZ/XaDPL/VyGjpnMIaFso63eBY5A0T6oHLWtap2JHcTgSqfPky9ITMXcvS4ae5V/wkkWzHqU60ZLHgb/QYISzqemlyggZ+z+Lld7ZNMXue2Js0jUf3khYgFrmQfO48dFlw83R2FX8cdDVazf4G0ONRcCPqtFY48ynSKn5G3SnMn6jnxKpfFr+bFkrwNpTQ9VS85zlr2nWtpUN50mRhrQn69Tyy77v03xu9zHFw+/7Yklw8uPdtMlW2hxr9LvnAi4e0rvuodszzTiE6nXrv0ZsWYzF2BnOuwlR+du3E3DqGZUaAzWgeZXXCU+JXgYZLQheL+9kEUAg8cHL7MnaMfVRNgmsjhme4VZ0i+W8D2KPgT7L5T0aKzzVVgwk4288Qbt5AKG2HK+ZdhAQmkztNnGpMFdoo9N0uRt8UvR5VvYOs+rMicbwJzy/SezQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 7:48=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Thu, Aug 7, 2025 at 7:42=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
> >
> > On 07.08.25 17:27, Suren Baghdasaryan wrote:
> > > On Thu, Aug 7, 2025 at 3:31=E2=80=AFAM David Hildenbrand <david@redha=
t.com> wrote:
> > >>
> > >> On 07.08.25 00:00, Suren Baghdasaryan wrote:
> > >>> When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
> > >>> obtaining a folio and accessing it even though the entry is swp_ent=
ry_t.
> > >>> Add the missing check and let split_huge_pmd() handle migration ent=
ries.
> > >>>
> > >>> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > >>> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > >>> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GA=
E@google.com/
> > >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >>> Reviewed-by: Peter Xu <peterx@redhat.com>
> > >>> Cc: stable@vger.kernel.org
> > >>> ---
> > >>> Changes since v3 [1]
> > >>> - Updated the title and changelog, per Peter Xu
> > >>> - Added Reviewed-by: per Peter Xu
> > >>>
> > >>> [1] https://lore.kernel.org/all/20250806154015.769024-1-surenb@goog=
le.com/
> > >>>
> > >>>    mm/userfaultfd.c | 17 ++++++++++-------
> > >>>    1 file changed, 10 insertions(+), 7 deletions(-)
> > >>>
> > >>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > >>> index 5431c9dd7fd7..116481606be8 100644
> > >>> --- a/mm/userfaultfd.c
> > >>> +++ b/mm/userfaultfd.c
> > >>> @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *=
ctx, unsigned long dst_start,
> > >>>                        /* Check if we can move the pmd without spli=
tting it. */
> > >>>                        if (move_splits_huge_pmd(dst_addr, src_addr,=
 src_start + len) ||
> > >>>                            !pmd_none(dst_pmdval)) {
> > >>> -                             struct folio *folio =3D pmd_folio(*sr=
c_pmd);
> > >>> -
> > >>> -                             if (!folio || (!is_huge_zero_folio(fo=
lio) &&
> > >>> -                                            !PageAnonExclusive(&fo=
lio->page))) {
> > >>> -                                     spin_unlock(ptl);
> > >>> -                                     err =3D -EBUSY;
> > >>> -                                     break;
> > >>> +                             /* Can be a migration entry */
> > >>> +                             if (pmd_present(*src_pmd)) {
> > >>> +                                     struct folio *folio =3D pmd_f=
olio(*src_pmd);
> > >>> +
> > >>> +                                     if (!folio
> > >>
> > >>
> > >> How could you get !folio here? That only makes sense when calling
> > >> vm_normal_folio_pmd(), no?
> > >
> > > Yes, I think you are right, this check is not needed. I can fold it
> > > into this fix or post a separate cleanup patch. I'm guessing a
> > > separate patch would be better?
> >
> > I think you can just post a fixup inline here and ask Andrew to squash
> > it. He will shout if he wants a completely new version :)
>
> I wouldn't do that to him! :)
> Let me quickly send an updated version instead.

Update posted at
https://lore.kernel.org/all/20250807200418.1963585-1-surenb@google.com/

>
> >
> > --
> > Cheers,
> >
> > David / dhildenb
> >

