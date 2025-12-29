Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C57B4E92FCB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 18:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303C36B0088; Mon, 29 Dec 2025 13:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1EB6B0089; Mon, 29 Dec 2025 13:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD476B008A; Mon, 29 Dec 2025 13:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5846B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:57:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E8BF160648
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:57:38 +0000 (UTC)
X-FDA: 84273417396.08.F38BB36
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0093120006
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 18:57:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SezCreRH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of fvdl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767034656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+nHNogZ32sJjYsZfXaKxOBMdetlmU5pep4sjUdC+nY=;
	b=sRSibGjh0LnVPpgwqlFrbF/MEwppvZfTxXdyPzSR4vp3P0t573D/TectJWYNdB0YeqZOC0
	KPemFC2JFwiVs5p+/hSMttggRETmir7qFke3VAYP8YBqt2UyGlhOIP3N3eDCAt+D0Y60iH
	bP6q8xkZOqs2Q7xoV+giivCF9lwh2ho=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SezCreRH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of fvdl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767034656; a=rsa-sha256;
	cv=pass;
	b=KrXcyLHOO/nvCyphPlEz0UZVq3mtFJ7NWx3Pegt4MgRrO9RYdbrb+ai3mgSgb2yZPhEtzR
	vtVkSHHHMqrfBs+JLoHp169P4aiH+mNI+RBoaeNW/LYVnu7CEqjn0Ne0U8NJYAt9cCF3Ng
	JmCA3wWqFxuANC1TNEcEUmwRdVbwGz4=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4f34f257a1bso3251721cf.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:57:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767034656; cv=none;
        d=google.com; s=arc-20240605;
        b=f7NQVK9E22WBRLL7fhusnwFhT0OCjFlUdBx4sN+xRckoSvqe1xSrsuy5OhcYFQrBtx
         jc3Ti0qDv1usj96z+f9TFsfUREjl6/fI3u9bfvmAo2UIcoYMdhhswxM1twvTAwLKFNr9
         APPBHXbKRX4dUE8LgUt2NcyZXwOscRv0IUp8N823CO94rRIvIPawevP+T8+5vAKnSXnI
         X5BUEe31/LqKBLZ6s5Fq3Uw3Dckfr3FtW54PxLIqOEPZYJ7EDH8pjvI/8aQ9laNCPkGO
         3d9IAOVDxmajGkOgv3EsoQzYHGt8OxMQsv4RM25drMtFuTLiMDA4JJA7+BXIc3znn3r9
         IyeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4+nHNogZ32sJjYsZfXaKxOBMdetlmU5pep4sjUdC+nY=;
        fh=aFwVKW0Vo+c0Tbav0cQJSoFzA01qnruRqtDCI4maxmM=;
        b=JrYAquZr06EiWKLfVWx1hcR2qxu1aVRm8wXgZRay59yq4QGjkljxIWmjNIP84UbjqK
         nJCFvxpgqVTH6aL9SfNqJ05Nn3C8iK8EPt4rABGZpQve3rvPJq3xIyCGHgB9c9nX6tRb
         ZN36U9uPLJC5+1/PodFOnjI2uSNGvJDT6dGxJ3DqeeCydpPYB65FmE6NAveUF1qpRnTM
         ySnV6qGtMwDHk1Hh/K1fOXG6wU+LGZNd9YVfO40uHaz7q8jXHvaK6PqF6WQ4LBbB+1h0
         F9BcRpnaGtvXTvmHK7uNQ21XEbq1A6EblV4mZuzRcC93wgeySHs87OuG8oJAFxyegYbp
         B4Yg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767034656; x=1767639456; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+nHNogZ32sJjYsZfXaKxOBMdetlmU5pep4sjUdC+nY=;
        b=SezCreRH5LkSH25YzgULvMoBMTzovoD3Rwmm1JY4bm1teOGPHd5gAVUOYqF6l1zcs4
         FC4UwkRJ3D+YHIpqSC3ufJ8qnOGdPu09JvD8N149zMk73halsd3MRXQG9O2VBzoqnjhj
         ADWhEpk0je/WU3o7yxuaidTFiO7slwyWzIHmHCWYRvjnOC3MRogYNVuwVL27fF1ulosw
         4MwyvqlEtpYH457rap+WkSkG7WU7t0sCvqidQ646TPvHHaIyAUs3V1vsLKW8FFd0nlpv
         urChDe8R9ZLsl2rgbOAQo+Nr5Qog8Pvb+B7HW3RrBwaaQV60UmXrapYA6Ngm+4//Mt9e
         M3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767034656; x=1767639456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4+nHNogZ32sJjYsZfXaKxOBMdetlmU5pep4sjUdC+nY=;
        b=PSKNxedOkQhgJK5geeJWkG+QxwF0dMBvPi/htI4uzVAij8lvooGP2r1F55/XJ6+8L6
         YtIQpq6lIsOi40PjIhUqtwnia9snDPrqnZvuY9O7DfESTU9tMyuwRT8LEP+7yhkWMNc2
         bHGWbSw6c5oFE9sjAYcW6tnr4VxDz/l6UT23C/yNlZCotUmaFD+6wM1fAz6+FPM396n4
         RFxDOxU27xN6B8SyCqRQIXpabHWa8GE0KwpD6sUeRIzCtkF3s1q0Ih1WuHdpgsZ7lQA2
         a/PTcrp6/J/fQpv6InhD+AsGNSwz1LWZrXesF014QTVuqHnr+LAzIs9GeBSF3Li52Hl6
         BvRw==
X-Forwarded-Encrypted: i=1; AJvYcCVPPPpiR6Q3VXLLQ/ANbz75ayPTEMLIPXHKbsz9kguxUa8QidISVqmqAO3RgM18YZ7zSOcmcefGsQ==@kvack.org
X-Gm-Message-State: AOJu0YzaKieNdVXSh6QfYm79B39sEVtwEXL1+LaQbSeE3RJrvDQAfU0u
	7o23+SRTPQ3ebISWE3FlsRkFR9B4sSwXJ7/e+0LD4htrBDcLNvHkfR0EoWKmTpxF/EHHjWLeHZV
	XIXD8CKPpMvZII00Q5rmhjCbL3LTXxoqLpa07uRTx
X-Gm-Gg: AY/fxX7TyqDakIflCSHuRfjoXQGq+Bqs3A4kMCkOCi5H82vHI55WLjQb64iOZHy39TF
	1G/CucjGhu+XaFk7sy2co3HXXOszs9ILoeQKi1aSlLRcEuGYusc7aAhrNdAEIPOP5MUoJHxC2iS
	nl44e9mYSFAzQGeDECFwfeoJpTcafgJ2mhxp7beJq9+dF6XJP1k9kNpShXz/mHozNJcKatAclXi
	wZkdDso0vTbMJ2HhODojGD1SZDBv7D/frtk5qNDdSaR/J0N0zFFg7Rc3B+aLJBND4D5fcY=
X-Google-Smtp-Source: AGHT+IHgJd18VD39De8iyWfLo0axlH5fgsGhVuhjF3mx+HMDrXBEBSkEJgWUesoZAy87pkhHst3G0L4q+3WWt0o/+3I=
X-Received: by 2002:ac8:6216:0:b0:4f4:e645:2b6 with SMTP id
 d75a77b69052e-4f5fb649f7amr16385051cf.2.1767034655485; Mon, 29 Dec 2025
 10:57:35 -0800 (PST)
MIME-Version: 1.0
References: <CAPTztWZPGAijX2eAt_tKfF=XDnN2nXHRBXPzh0xsE5Czfw+FAg@mail.gmail.com>
 <20251229122537.6903-1-lizhe.67@bytedance.com>
In-Reply-To: <20251229122537.6903-1-lizhe.67@bytedance.com>
From: Frank van der Linden <fvdl@google.com>
Date: Mon, 29 Dec 2025 10:57:23 -0800
X-Gm-Features: AQt7F2oWGiPfcd355xjTC9IDaMfEr5PpoKJXJOy1GKnJR3kHvIYZAHhlVNudRHU
Message-ID: <CAPTztWYMhh3+V=-jXaMz5muTsj8fBX29umgJcsW7JfHA2LouuA@mail.gmail.com>
Subject: Re: [PATCH 4/8] mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A0093120006
X-Stat-Signature: tkpeyszhekfygxnaujycqg4817abkkj4
X-Rspam-User: 
X-HE-Tag: 1767034656-229644
X-HE-Meta: U2FsdGVkX1+8+rQvKwoe9Ld2yq8CpaU9R4lXYD8QRN/z+pFrBUVCaNy43OALs7uK+1Lk6okZaJIEQmXZSglMClH2rvRA3Or++SZBYiIQM85GqROz6XHmWAYUWcARMGljTUb0dJGKYABjMvUmTHWc0gKyFxSXBelmbAv6UemK8xEit2EeJJxQJs3pl7HmsKKjX6YazvF9LS8Ju/YweaEBkd3EaY1oh1lr4k2WEK+94zPT93hA0OOG2Y+BH0vUykk9QYeSKjML2w+kONjwbwQMDQwqWQFIMQ0VH9AuapBrlhBdxnMFUHy0iUwo80o+qeXLx33LHBGaUXYkPi82FZ6VZFaEDxC+F8dEqeUKw+6XGOCNCMhErJLsGlMK5+3wHKEeVWfKmaSTFwibJQkn0bZxzPleciyXTJGw8GK4jQrGKBpj/U8csKYogitx/ibamTnyvmHL5OaD59EEnspBmIdUYkijwnEGuVoFrjn6G6kHi/9hIjP5WMxtMKFq+5iOcCjRDOHsq6o33oCqGAoxb2WKTI+tIp7sowFkSBHM8nQAokRruClo8GpV3rYEsINDFU/ILqkb+3CG8AoOdtXuDEGOyLYMbKyfOzyeXxUp/lYfDGm6Rh65IOBLKpZVVLbe188dv3YbRAASC/4vQPHfF6OXxSL6X8gb2wUCXldIrZ/AMMYoRE1NfA6PJ0OaRq0bGhGULYx16dyyuFugzc/ydbJiHfoGvHxujSml5+9xAFrL/1x7TMM2CMCKbn4BJZw/Z60utmK5rOSoJrKsrpbwHHB+uaLpVCgvX/u0m2c7SAcUrqp5WSzqZqhfuwLg4yg7DPQWczPFSa8mmATAg3SbMYYSaLkCJq8WqUma6sb/cG3zB235jGDWDiG+3giTVP2o0/zbXLwNBiWSDo9RsnDSWliUFPrheUYpd3VAe4yNi7MxsxPyFwHx2npygIfcf2UAS+JfTlnK2WeJnB4VsQUEsBU
 JhZIQY7A
 5EVk4jJ0HBWKyrOnGwLhm1PrEMuKXwfKn0U0PNJMTYmYdx2eK6eCRaS4hN0PeOBojBWGYDug6wmztD9N9+R4iefQnQmqElFfqz/ESDvkL04ivsQsvqg+MqjkIvDYFiWuRIsj/GrwLd6B7zF2pRD5JDmUeUtJ/RARhXPYBVkOZU0wPuPHiQnBS6hsyLd2JELpuMZBHyac0EXYUXdLLmuL5LPfzUQVibqFUvVq9qoJytmoNbeOgygPffkpwGzi8uKrkPF6ToD5pk7Mvy2Yku/G7wC+fYHhuQ0yoxYSoRxpCCH/B1zZqFgnfCQ3Xu8ugUCB0WPuCot7J9tf6TyU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 4:26=E2=80=AFAM Li Zhe <lizhe.67@bytedance.com> wro=
te:
>
> On Fri, 26 Dec 2025 10:51:01 -0800, fvdl@google.com wrote:
>
> > > +static ssize_t zeroable_hugepages_show(struct kobject *kobj,
> > > +                                       struct kobj_attribute *attr, =
char *buf)
> > > +{
> > > +       struct hstate *h;
> > > +       unsigned long free_huge_pages_zero;
> > > +       int nid;
> > > +
> > > +       h =3D kobj_to_hstate(kobj, &nid);
> > > +       if (WARN_ON(nid =3D=3D NUMA_NO_NODE))
> > > +               return -EPERM;
> > > +
> > > +       free_huge_pages_zero =3D h->free_huge_pages_node[nid] -
> > > +                              h->free_huge_pages_zero_node[nid];
> > > +
> > > +       return sprintf(buf, "%lu\n", free_huge_pages_zero);
> > > +}
> > > +
> > > +static inline bool zero_should_abort(struct hstate *h, int nid)
> > > +{
> > > +       return (h->free_huge_pages_zero_node[nid] =3D=3D
> > > +               h->free_huge_pages_node[nid]) ||
> > > +               list_empty(&h->hugepage_freelists[nid]);
> > > +}
> > > +
> > > +static void zero_free_hugepages_nid(struct hstate *h,
> > > +                                  int nid, unsigned int nr_zero)
> > > +{
> > > +       struct list_head *freelist =3D &h->hugepage_freelists[nid];
> > > +       unsigned int nr_zerod =3D 0;
> > > +       struct folio *folio;
> > > +
> > > +       if (zero_should_abort(h, nid))
> > > +               return;
> > > +
> > > +       spin_lock_irq(&hugetlb_lock);
> > > +
> > > +       while (nr_zerod < nr_zero) {
> > > +
> > > +               if (zero_should_abort(h, nid) || fatal_signal_pending=
(current))
> > > +                       break;
> > > +
> > > +               freelist =3D freelist->prev;
> > > +               if (unlikely(list_is_head(freelist, &h->hugepage_free=
lists[nid])))
> > > +                       break;
> > > +               folio =3D list_entry(freelist, struct folio, lru);
> > > +
> > > +               if (folio_test_hugetlb_zeroed(folio) ||
> > > +                   folio_test_hugetlb_zeroing(folio))
> > > +                       continue;
> > > +
> > > +               folio_set_hugetlb_zeroing(folio);
> > > +
> > > +               /*
> > > +                * Incrementing this here is a bit of a fib, since
> > > +                * the page hasn't been cleared yet (it will be done
> > > +                * immediately after dropping the lock below). But
> > > +                * it keeps the count consistent with the overall
> > > +                * free count in case the page gets taken off the
> > > +                * freelist while we're working on it.
> > > +                */
> > > +               h->free_huge_pages_zero_node[nid]++;
> > > +               spin_unlock_irq(&hugetlb_lock);
> > > +
> > > +               /*
> > > +                * HWPoison pages may show up on the freelist.
> > > +                * Don't try to zero it out, but do set the flag
> > > +                * and counts, so that we don't consider it again.
> > > +                */
> > > +               if (!folio_test_hwpoison(folio))
> > > +                       folio_zero_user(folio, 0);
> > > +
> > > +               cond_resched();
> > > +
> > > +               spin_lock_irq(&hugetlb_lock);
> > > +               folio_set_hugetlb_zeroed(folio);
> > > +               folio_clear_hugetlb_zeroing(folio);
> > > +
> > > +               /*
> > > +                * If the page is still on the free list, move
> > > +                * it to the head.
> > > +                */
> > > +               if (folio_test_hugetlb_freed(folio))
> > > +                       list_move(&folio->lru, &h->hugepage_freelists=
[nid]);
> > > +
> > > +               /*
> > > +                * If someone was waiting for the zero to
> > > +                * finish, wake them up.
> > > +                */
> > > +               if (waitqueue_active(&h->dqzero_wait[nid]))
> > > +                       wake_up(&h->dqzero_wait[nid]);
> > > +               nr_zerod++;
> > > +               freelist =3D &h->hugepage_freelists[nid];
> > > +       }
> > > +       spin_unlock_irq(&hugetlb_lock);
> > > +}
> >
> > Nit: s/nr_zerod/nr_zeroed/
>
> Thank you for the reminder. I will address this issue in v2.
>
> > Feels like the list logic can be cleaned up a bit here. Since the
> > zeroed folios are at the head of the list, and the dirty ones at the
> > tail, and you start walking from the tail, you don't need to check if
> > you circled back to the head - just stop if you encounter a prezeroed
> > folio. If you encounter a prezeroed folio while walking from the tail,
> > that means that all other folios from that one to the head will also
> > be prezeroed already.
>
> Thank you for the thoughtful suggestion. Your line of reasoning is,
> in most situations, perfectly valid. Under extreme concurrency,
> however, a corner case can still appear. Imagine two processes
> simultaneously zeroing huge pages: Process A enters
> zero_free_hugepages_nid(), completes the zeroing of one huge page,
> and marks the folio in the list as pre-zeroed. Should Process B enter
> the same function moments later and decide to exit as soon as it
> meets a prezeroed folio, the intended parallel zeroing would quietly
> fall back to a single-threaded pace.

Hm, setting the prezeroed bit and moving the folio to the front of the
free list happens while holding hugetlb_lock. In other words, if you
encounter a folio with the prezeroed bit set while holding
hugetlb_lock, it will always be in a contiguous stretch of prezeroed
folios at the head of the free list.

Since the check for 'is this already prezeroed' is done while holding
hugetlb_lock, you know for sure that the folio is part of a list of
prezeroed folios at the head, and you can stop, right?

- Frank

