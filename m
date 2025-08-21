Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84625CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233E38E004E; Thu, 21 Aug 2025 08:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C128E004B; Thu, 21 Aug 2025 08:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122618E004E; Thu, 21 Aug 2025 08:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3B098E004B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:02:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B55AC03D0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:02:08 +0000 (UTC)
X-FDA: 83800626336.22.25F883E
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B444100017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:02:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nGCQXosK;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755777726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1yM8dOC77qLUHZz3KU09N9w0QVN7Fqkv+h9RU3R0NU=;
	b=JVXFv+JM7pPOHWMHSRAQ7knnQCeQ3tU8HJ+FUCttkCb7pgvirFQTqRvkUcne1e+GfpyA14
	qTtSak4UteH0aHjYeE4WbzIHzjUSujKj2gtH1Rq0l/10vN4VWXnVQsnkf0dwJuzYGwATS3
	YZx53e1Gt5zVvqC/ir5gM3fyn+Tjqk8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nGCQXosK;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755777726; a=rsa-sha256;
	cv=none;
	b=RvfY4byoOMjWXfqvADJ7qz76HgGUBN5tktt4l8fwZkf17lQrH/YAyD7qFnxZIj/cIplRUq
	QU24LBQMzODqo3tJNU6ujen6BurOufsAgAIyoVXEJ/82WM7iErdIaP+23wc34eXUdT7UMy
	5+IdwH6TaG8fvnHJq7Q6clEb1kgF8Pk=
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-890190c7912so179587241.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755777726; x=1756382526; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1yM8dOC77qLUHZz3KU09N9w0QVN7Fqkv+h9RU3R0NU=;
        b=nGCQXosKZ9GXeFaKcuBe8LWQ37MNRqHyiFUCzmyn56/e2y4yE7Ro5Uwa5rVmHmVms3
         SX+iyiJbqLXh2zYUY7NpIYDcEhdHW6HowoHAUayLBLHzq6orVyHxyzh9h2HA3QMrmmLv
         OAMLWFYUCwqXcAwKWqNzQ68B/vrTkpI1FLZ/qNDtzwj2R2Mj/A0T4I24/s//BOeyw5ix
         h9sFvXltvZNU0uyr+i9ZgLZ6cNSQ5oLQjdd7t8EMAXrW7cOtU8N34poOTlwkHpgY5Cdc
         IKWi+Sn6U/mKXjJPBv2S/0zJlLdz/uMwpdKMAD1Ww8A4Ew0ebf+bZH0HeYD3VORYiFu8
         pNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755777726; x=1756382526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1yM8dOC77qLUHZz3KU09N9w0QVN7Fqkv+h9RU3R0NU=;
        b=FE49lzcF3uMFMPfFXl76NzOnP7ai4iUpuJotzORMnICIigs4FY5U1m+feOAuHojgbP
         CZzCPP6xxcsKaokjBT8Ox/XGrkizH10ebUxkFVV0W/JlImcv06+RYUKL+x0cB0VvAGsI
         dw6djW3/6RqLApnZuplVNGZ4kj0k8gayQY05I6u4nwP4GxbmWyNfzw6WJWgkfsOALa0i
         TMPVjnp7rMYPNXU8vnFxVoppxIWIIz6E0X3Dxl6HDB+NJ1cQ/cR9iFby8MU3XcmPtCc8
         E6hmOzjdh7LmNBgCi13LQrXysG/MMD3Xv92/tW0XjCaqGXhLxyh2fNiGE8cf0beT5LwK
         yn0A==
X-Gm-Message-State: AOJu0YxrNXEjYupcm4PD6Y8TbO+uovWpUxB6OyjmqqT+7sfsMRplgktO
	e7usus30hTIwz4mDXc7KkVLZjex+8HC2WGwdru4Am2Z5vhqc4YQ2Hh56osLXKqoPApiytvuPWqG
	az+n96gG9qQGMiuY0q//vQDeMcwFtw/U=
X-Gm-Gg: ASbGncsN7O1wifePFGefIvopmOQFQ8hKj3poU+hy08Lw0Tr4r65VDRBHFL/M2FWpXQM
	a64u+cA52LCxckkXDfU9SwC7wUUOEW471HsuXW4gfd4+8aO+ZqLKvKRZmoPaaZJZjbRsPilqu3O
	4IDves7RxJadLl9Y01HJMS0UEsCAFNL1ySAnxMkp+Aj2j8y1/puEBNf8fOsq9b8O/oRlQeRul+D
	m3KshbHGJ++2dpTpw==
X-Google-Smtp-Source: AGHT+IGT8JOKVJersb9ahJ2+7N339JQWlZizsvMvS91QuBeOG8DXRaSRq//h+LFFPAaPbOiUivwGE9RbpnaQTIeZKY4=
X-Received: by 2002:a05:6102:5813:b0:4e7:b728:e34b with SMTP id
 ada2fe7eead31-51bdea2c9cdmr553343137.3.1755777725233; Thu, 21 Aug 2025
 05:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO6dR5=4zaecmYqQqOX4702wwGSTX=4+Ani_Q9+o+WUnQA@mail.gmail.com>
 <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
In-Reply-To: <CA+EESO6iqowMAOnBPJjERqZym_qvd6kx8BDMQG8+3xQSrNFytw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 21 Aug 2025 20:01:54 +0800
X-Gm-Features: Ac12FXwWXbrur_ZyKDJu7GJ10IVxUDihTxhab_C9BDYqJHmx7_tmZV1--hTvA_k
Message-ID: <CAGsJ_4xccre0rz5zgRTA=NbFzF4FLS-ZUohgLFnfTGY9Jdequg@mail.gmail.com>
Subject: Re: [RFC] Unconditionally lock folios when calling rmap_walk()
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9jmtoyt6t65afmrqx4ujskmam8pdyjfa
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B444100017
X-Rspamd-Server: rspam01
X-HE-Tag: 1755777726-500607
X-HE-Meta: U2FsdGVkX1/Gj9EdwnoDWMCosE59uJEpyCXbTz/5NV4k9WvPQi2TKb6bjWyeCxZ4+g9co0OJkRbSaIj4BJ5s1DyohxNNjXc2IaxhSfeOG6Bf/F4Qv1iV/R2OdyGXVuNfil3yzmGbt2MLVV5rX0BU9C6SKekUoZo+RQ/szzH36I+4piTuj2s3SgWtrpOvlagrORnTPXClCcjg7/8nzztZ0SEo7dNi7vcroxdLIaaNegFxjL8ZzdrMCbzxl858C3NCDZOyZe6yjbiflsEXR4e0JAuWj1FYDNDiyJDs2jntpmKdqa7VTqKOpX/P5ExDCP7TvFOlK3Wu9RYmLYzj8J0JduThiZpN2byEZxxzf51olIDdAPPALHNSdugSN7BjZRZ1ADA/6uCH4r5P+krm88TVSJSdm3gb+EoIRQzRQ9FxSFLx1UIhacmXO4nWAapHgQCsO80QCegX+gpB3t06BphHOPstN+6Kvladrzl4l/Xh/NMht0weAnmv58ri8cSLUEHR0Dr28xYLXa2No12AQ8chwhS40ncyYKS0cewaxuBPh29cYH8LG2MV6HjjP9fQVT7MTQNykEpWHNG81rYfItGdWpQnl/ZQT3c8lza5pgSCH9T7+5t5WH79mHhU3tUv+PjS5wyc4AJDUX1u5+j6yYshrGw8mY3xzAeN5nSUS7cKZ5x/7yGwaOx8s3l7UBr1UQtGyI5GPKzltpDmPLlkb8aCcOkERtVTqMTbi94BdTkfbtP5WubOyU9oOyRjdFpS8ysBQWvVHZgGFrfSntrBuufTEmYbGRBEtKMSZq5EGUoMhsmS+qKQRKIKYfXtCcdVdqUbwUMTjMDqk9DD/LH5OdFsCbGxvgSWVXIUr2Fog55Hy6/KLNhe/pPbNxrfYHom7nhNSKkFXam8exFjwEK7HBRZ18m3Ycyb1LvRr1bmUZIr8WKvWdt8Q8uUg0rrB0VgmILgeY88kv0WH1lr3X9jUGu
 ajXcBzT/
 E98O5beyYc55QzHkEzN1zd15TExnibNj9Z75H+Etkk70CzzgglPPqXzijo9Jq01P/BBpsvBJaQSsv1P5e4ixJ8FnyWHK+N0OvTfDNN68u/yH7wnd6cuHC04eoHhlo6hqA1Vci59gTmtCyG+S7Oum/7BzPzTf1pJ1Ddttu421QbFHVGYzbi4SC8RRhUdk+ygTt58al81Ck7VtLIFuAjGta+EqjfAA9yUE8WSml+u2Hg35vnZrmZm1cwyGkSXEP3EzLCwOjjSlf845TfNq9nkPCK+gidxZgNHfodI45rlYirYhNuzKahgTlR6UrGxEOBcl+cnhWQV1DK4IdIE2oUNq7nwxpuPhoGPvRyIRnG5C3GJZ+3BXc502GYtkYmz96ota7qe4ScEq1U6Av6Wi5bEGeRGw2dZGH2zsUk7MU346ko8wYxlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:29=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
>
> Adding linux-mm mailing list. Mistakenly used the wrong email address.
>
> On Wed, Aug 20, 2025 at 9:23=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.=
com> wrote:
> >
> > Hi all,
> >
> > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > non-ksm anon folios. This necessitates serialization through anon_vma
> > write-lock when folio->mapping and/or folio->index (fields involved in
> > rmap_walk()) are to be updated. This hurts scalability due to coarse
> > granularity of the lock. For instance, when multiple threads invoke
> > userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distinct pages =
from
> > the same src VMA, they all contend for the corresponding anon_vma=E2=80=
=99s
> > lock. Field traces for arm64 android devices reveal over 30ms of
> > uninterruptible sleep in the main UI thread, leading to janky user
> > interactions.
> >
> > Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> > folio_referenced() is the most critical (others are
> > page_idle_clear_pte_refs(), damon_folio_young(), and
> > damon_folio_mkold()). The relevant code in folio_referenced() is:
> >
> > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> >         we_locked =3D folio_trylock(folio);
> >         if (!we_locked)
> >                 return 1;
> > }
> >
> > It=E2=80=99s unclear why locking anon_vma (when updating folio->mapping=
) is
> > beneficial over locking the folio here. It=E2=80=99s in the reclaim pat=
h, so
> > should not be a critical path that necessitates some special
> > treatment, unless I=E2=80=99m missing something.
> >
> > Therefore, I propose simplifying the locking mechanism by
> > unconditionally try-locking the folio in such cases. This helps avoid
> > locking anon_vma when updating folio->mapping, which, for instance,
> > will help eliminate the uninterruptible sleep observed in the field
> > traces mentioned earlier. Furthermore, it enables us to simplify the
> > code in folio_lock_anon_vma_read() by removing the re-check to ensure
> > that the field hasn=E2=80=99t changed under us.

Thanks, I=E2=80=99m personally quite interested in this topic and will take=
 a
closer look as well. Beyond this one userfaultfd move, we=E2=80=99ve observ=
ed
severe anon_vma lock contention between fork, unmap (process exit), and
memory reclamation. This has caused noticeable UI stutters, especially
when many VMAs share the same anon_vma root.

Thanks
Barry

