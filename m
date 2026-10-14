Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3311FCC6B2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 22:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A0B6B0088; Wed, 14 Oct 2026 18:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B9B6B008A; Wed, 14 Oct 2026 18:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903E06B008C; Wed, 14 Oct 2026 18:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64EAD6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:22:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC212C0836
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:22:03 +0000 (UTC)
X-FDA: 85322655726.19.B00636E
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id DCA98180004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:22:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n81o06VC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792016521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8QQjN27s0Pot0JCVcrmzcvPmF+Pv8lSLqLgVFGNeaI=;
	b=u9ET5GaZaT0hNqf4b9GvRUwHzR+MAlmWgh2kbQDK6U39RebfSPqXilvMM7Vf/oirwC+HtI
	wfPLD7F/9egANbz6uPdlXFMt4CNHnOIa5kFreyhjVuAJjTk27R0Z4bg2SvKltYe/PkHEr8
	lugQQi0KUFs2gaBSMJKRH/U61wNAWZM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n81o06VC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792016521;
	b=iBKVVumhVUOieYnFLaWT1bkQYspHtJux0OJAkG+RkGHLE5vJ5tN2dDpvFGFk2PC+rWpcWa
	g0PWdKmjHI51vN8xwGSEbIIM+vK/GPsOkkOoAmc30u4hTX26qBik3IIjldEKYgnL482+st
	cGT+pF5IwBYA0viv1KtkTGBQWHOjgUw=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-486e8faff03so2017598f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:22:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792016520; cv=none;
        d=google.com; s=arc-20260327;
        b=i6W4KWWxdte0/bDHyXL8n2izGP6Mb+cAuAoDm3h50Iio7o4orS9OycAjyUhwfF6+e2
         1TCpCfqfenIQS6UnJdWRE2f34yu2D/ZgiYpQgZeGTDI2yVKUX11df3s3NsS3cNfiznAV
         HhFn8ngBeSg/QSbY3NkbA6T+hUgiallD6T/Q3CRIw2ov+6n3VcOOfKbsGCDanHzHdNbT
         ueIZYlDIpmTPAyP8Aft7CGzJ6mYRybb5AoZlhUsB28YQ1mXyR9QLwT3OlC8wHAeTzH7h
         MG/J1CJog9uHtAB4fO5+e5L9zxCak4SPV4yPHdBZ9iv1WcPg5ZnahoS8kLZ2QBXmkE5n
         jh+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U8QQjN27s0Pot0JCVcrmzcvPmF+Pv8lSLqLgVFGNeaI=;
        fh=xrPwPx7uYwy0nqTlQg3chyKrs+SkROcDz3j+ZmY9Ing=;
        b=cOgdKhFYjmqTqaEmLmRO4MomZmKCjFkeOLqG7FxuhK2AkrMmxmnenDLoA4YsQXPZph
         Ms26oMmzBsoX5Sc7zEDiD+BHMmLPivLkw4vljJYeN/8CWE4nuQtNcPaECOLKGx8mv/66
         ramU7UnWF2znUOEQhP2hYk01krFe4ftOdFlpLjN7b10ZLb6mJ/lxcRicbL6fSpNr9ihD
         JP3ISwQJNDAC7SyqaWX/ahpq2IXDcjOMKTbSK2btYNI6XhDZ12LrqL6XRSTI03FRsCkD
         P1vkuikmn79UveBxnH/s5skmwwbjxVYsDR1TBWTwnO2PQrrqVZS+qmZfQiH+RVhPph4W
         b5aA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792016520; x=1792621320; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U8QQjN27s0Pot0JCVcrmzcvPmF+Pv8lSLqLgVFGNeaI=;
        b=n81o06VCXwI8nW30ciKJLQaI/n510m2HS2f8vwQUujOJMjw2w1GR6p2gXtAjJxbW3X
         lYkFl9MeC/gPayajrtnb8T8YE7C6jJWpIi8I0JKiJ/6rIyhGnsCbYMSpT25wF/ii7jY7
         AOktBWxvgWnViUT4ETtgjK1j8Y6EgIGiDBDw62zqK9GSG1RoOMDEjsJGh7+YdLeiCA6a
         vJdXb5EIM7mVkc5jpvGX4nlaL/FEsrYXdrSc7MCffQUDZatV8S36tWLgxg9YMbrXbPl4
         74pqQjrkIBoQA7tDo0F34c/PDXtwtbdwmxCFvg0fJw4E5LgVUgYJOIEdm6QIekzlQ0pH
         4oow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016520; x=1792621320;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U8QQjN27s0Pot0JCVcrmzcvPmF+Pv8lSLqLgVFGNeaI=;
        b=07cIC+d/+ZPfUT9YrfRFNRTD/vewl869Za15LF/LOkpOhNObiGlL+4RFIUoBIM/RdA
         xtekOkXGd1m37ndFo/ssyNv3Luio7Iw3jScK0grWL9Q8plXuy52e175DfCsvq7Z57Aih
         Sphw+bKpCKh101jegmWqQJ6zJfP4n5sjHYGWVWwQqO/9+cQfxf5USo4iHXE0UYRl0Bkz
         ay4kBC9VWACS3AsxteyGu8EvjUfxEPwW6MGb5vDKSCqc8ydPjS1/ma8i4FEawCmXIvJu
         Mo5f8ID4VLhiYFNeX2KwySWw7KbG5LaSuU/xBNI3J8iZkMa+D0JG27Cy+8lluPmCz9nQ
         sJyQ==
X-Forwarded-Encrypted: i=1; AKwUvBzHAKf/CbR7eRUqspmyhxgni/+zSuFwHJ1bIEgs+A0LrDXnUfodva7QCgrIJLEYPxd2j58lpTkFjg==@kvack.org
X-Gm-Message-State: AFq9FYIFIYuMiHGOyusn/6yTktQN6S4I7bIpa8McS9L2VXytfnKwpdHO
	wIXQJ1uRffW/ztzM86ZnRAu5N8OTM5CaYUK9P1HrY+0ax8vjJga8KzZH1Yk3+itEK7eEdBsUnaO
	dgjf4jb1YbCCF4iZRHqVCdn26GpMddKE=
X-Gm-Gg: AYBFou0GDffv2fG89bqm9A2AGpNc/ixcnNuDZxoSE4P+fVKkM2ErdClmWjoRSKfyP9g
	DhoDPq1XKeQm5oS27Emr7aAcRzp4e+DzWgt7bkY5elYNjIMzBme8PP2E8RoS+/7G91lJeX8jnil
	gGyHqlm46C/oZIdbyGIHdJkHqMhrgGZGxQKrmGop1hjrfr2eKIIK1dSH2aD+slQXm0ClRcdBAae
	EMnBO8qbRp9jv9ztiMMlLqqc2Fdh0z6RlLGR9K1j5L9MFcVVqFdugGkfEfIawk5OwYscx+R+LqV
	voWZpiscOCZpvmIjXhzeN60+q9A/pi4HMCz0J+bg+FBuymDHQD7ab2q0+lVPCj7hSkdrkBPBSHs
	RgxQ0i18Mfs9C9dNoMgFWewtLkjilUGBeawiigQ==
X-Received: by 2002:adf:fad1:0:b0:487:342:d142 with SMTP id
 ffacd0b85a97d-48dbacf59d2mr23574589f8f.44.1792016520219; Wed, 14 Oct 2026
 15:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20261013221307.850803-1-joannelkoong@gmail.com> <b90ec4b6-e0a4-4f46-aa3b-b1a3a08570c9@kernel.org>
In-Reply-To: <b90ec4b6-e0a4-4f46-aa3b-b1a3a08570c9@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 14 Oct 2026 15:21:48 -0700
X-Gm-Features: AclHuK_tUcdkEvV4W4vq6H3QP4SX_X0yPFMq0-te8p6YxVgvDdJo3929XLEFj8I
Message-ID: <CAJnrk1aroGboovN=VVSkODEvcGxkAOaDmg_dh1NyqDkTjwF4Uw@mail.gmail.com>
Subject: Re: [PATCH v1] mm: unqueue deferred split folios outside the lruvec lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DCA98180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 9wm7n58pc9y9sd83y7toume9zjcbaf86
X-HE-Tag: 1792016521-212982
X-HE-Meta: U2FsdGVkX1/baG9+soo5irJzlKAlqtaW7tIpW80EhGM1TFY+AoIu2ovQQi0/iY0hzcUciKvnQzJjr/iuSqwTaofi73QkkK0316JT/9M0S0ZclBccEQowCHBXaod1YqFkUZ6PBiW0egeriWOB7iVfK4RjW2ooOGJNmHh8Ys1OUes+Ibck9UNlrER1SNpHeRyoY4ajvfe6Y8KNNKwB35Ufn7UwN/+uOu6aCa1Bf/SNlv8bwIFFgt4C7DMuGw8RzBiqsVocmwUfD9nR2G5gV1TaVhA0vC54kZsifiTmLMmdmEj+aF231HGw+LJJZzT8B7fOJzAPM18jY9o14wWekKxcvfsum2XDh4nbGGLqyCRTOT65BKQOMUwqoAl/0+geV0u4CdlxdlV7DVdio5A965krIplvWviIzQtk/vBrRtTLwJQbQXXt8Id7QgHyZhG28mkx4zmvd138ZQbE9rpZGJuwRI4nAnbvRQfb1dp9yBzsWWprZWDtQ7mAa4HjbKQAl0PsHeNHUO8VP81fx47U5UbLgNM8MJ1rKW6MO7qNqxsU9jhG9dYuF5ZO8doBilbdTrZAV7QpxGTMtgD2A/RP+gk0CvfW7WVTR+iu5YZ9cm5mYq+Lj3EKqcA/hRvzdUDGVHt+IHqFunHkcS48RbQRYHUK/14fpUBkp5UTXoFxwymO9e37WfJm1lpLG93wigEmkcD+m9Hgq5fYHxOb2eapyhM/UnXPOu+oGtN4Ppb9N0NrFHb8D/XDQ/IrgUKWPtaZMYjYpxY7r2G7UAtlJaPDbFUkkmkC60T6A4hw6ARlx63QaZYp7j1LuYaj3aT5kKEXIljeQNtiqbbLiY3gVxretX8vHlwbG9HB9SBGXWc7EWazIRhUC4c0jwRyoUbZZJEVdIEy/L6YlM7Cx594llMbnoBp5YEO5MeXMYcGW4JYGlDXtFJRNDWKJhZJP/+BNgtFwKDaMWu0M5w8U2azlCmtolG
 J1RKM+x6
 /uc7wxV1FbYW7QCN7dKIEWhd+82Zlxf773gs+cTBStC6qIdazIwFS2lnSRG36kvSw/yDdBIcnvBy69C7XIY3rVczBGAvw04aa1zp60hK3JKulSHo62B2Tghae72jKScXNlrMyLkSboV3jHdOlnLB5dPFF7QRSd653hM3H22t5bsjXdowqpAE/HebWAAFFIgcWhDNiDp4UqVXA06rR9K/C1t6Ml58TIMiVStzpiFLhpBR2306H/xNFnCIPoz0SfkUk3xSYP6rnhFchAsRp6jSsMjtM7QhJRF7PRr0fKpueV4B4ledScozdVvdLXTqCT1nAXIlsBBRmlrjPV4fkeqFzehkuRv4zRptbLr4I6wWaAt0o2cIhdFu+wyIyiV4sLsAgmNluxSMi+tPsVUwT1Z9q5Siny7YAZZRxOHFXMfaGe9c7AMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 2:31=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> > @@ -177,14 +190,10 @@ static void folio_batch_move_lru(struct folio_bat=
ch *fbatch, move_fn_t move_fn)
> >                *
> >                * We're bypassing normal cleanup. Clear flags that are n=
ot
> >                * applicable to dead folios.
> > -              *
> > -              * Since the folio may be part of a huge page, unqueue fr=
om
> > -              * deferred split list to avoid a dangling list entry.
> >                */
> >               if (is_lru_add && folio_ref_freeze(folio, 1)) {
> >                       __folio_clear_active(folio);
> >                       __folio_clear_unevictable(folio);
> > -                     folio_unqueue_deferred_split(folio);
> >                       fbatch->folios[i] =3D NULL;
> >                       folio_batch_add(&free_fbatch, folio);
> >                       continue;
> > @@ -201,6 +210,11 @@ static void folio_batch_move_lru(struct folio_batc=
h *fbatch, move_fn_t move_fn)
> >
> >       /* Cleanup filtered dead folios. */
> >       if (is_lru_add) {
> > +             /*
> > +              * Since the folios may be part of a huge page, unqueue t=
hem
> > +              * from the deferred split list to avoid a dangling list =
entry.
> > +              */
>
> In general, this lgtm, thanks. I am confused about this existing comment =
you are
> moving.
>
> folios being *part of* a huge page? Huh? A folio might represent a huge p=
age,
> but what does the "part of" thing mean here.
>
> Is it simply "Dequeue any large folios" ?

Agreed, I'll reword this to "Unqueue any large folios from the
deferred split queue to avoid a dangling list entry once the folios
are freed".

Thanks,
Joanne

