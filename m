Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE01C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DF16B0098; Wed,  6 Aug 2025 17:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE106B0099; Wed,  6 Aug 2025 17:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD176B009A; Wed,  6 Aug 2025 17:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09E786B0098
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:54:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC05BBB0B3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:54:54 +0000 (UTC)
X-FDA: 83747688108.04.D183E28
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE0D140005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:54:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="b/zZ/FsX";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754517292; a=rsa-sha256;
	cv=none;
	b=JH/37awkFKrR1Oy9CVnw+eRQYVBG1L5NfnRR2L06oMle9x8+EXvWti/ZB/rFLIpiQ7GeUV
	hit+rynyph0aVkqqTGovsrDTjsltJ3CbOFtMebtmM+xPNyNPZNEi6cOCByl2NNJ91LfoZ5
	YXG5dccOI7/mLWXhH+wwz0503g4THOc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="b/zZ/FsX";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754517292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzwCwuhZLT/+kj+O3V6lcQiJXb33vcCbaKrtnnQwVGI=;
	b=Fc25DWfhPVNvwDipO2AgET+t1+9bvYgeTTULX6JMTCKrgwTnGMww/9v4N/TfGksScRKlme
	rTwbJmVSKevQSqtCSVvfF61DF25oJ1sS2ndP+V/CGe7uKOSN9wrJ41raO7BUkVwJ/7aAAR
	r17E8NCVx3JlRQa/yuIfOSwYOPBsL1I=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24070ef9e2eso63545ad.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 14:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754517292; x=1755122092; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzwCwuhZLT/+kj+O3V6lcQiJXb33vcCbaKrtnnQwVGI=;
        b=b/zZ/FsXeCYhrYIOc7Irme2WLPNY1tChfMPOmUFB2amAbqsvlvWtKnu6WIN6ZCteUO
         WHmmB2RGvshsY7dOtSfoZwT6fBHN8t9mV+GNNxFGiJ2Sm0InUoBXVNW7tgx2q24XRpzK
         4MjHTYVmEEVcLldTykR/TKvQNJdhm8rNIQTfWB9uZ7d9EBW5quhxRzeuhkK2f8Wi1Uen
         Sof5yUrf2Bb50DYV9KZOwJccifG5FXwg0JaH0UsWYC7vk4RAgUZKkfwYrUet+iAga7zp
         CEP683TBGN6zxzCUFGxJxSe2ikVnM3rrxmkzl+qv2RSBzIpi1/MYPStiJIB9YfB8BkV0
         KAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517292; x=1755122092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzwCwuhZLT/+kj+O3V6lcQiJXb33vcCbaKrtnnQwVGI=;
        b=DoQ5hfagN+QlpK0DP5ONOVQOKASEAM+cloq6CeLsOvQ0U/OmENVOYJkHPz9Lha1Dl6
         Ywlfdr5QpssPNViIwHx7BambS7BUA4ylR610svrd915jI2s3l1UfPB0lJMiIN6ImJTdp
         9AjlDKbgRmuUpqOJfJbJYJD/a7Mt9HP8tgCTxPI4mLzUrW2hucf7xX5wlJ9zXWjIangR
         FEMkbD6yF//F+w2sJp2oMQPQ8Q19mm/0b2kWJc6FOdpJatOqvImAAbotbtvraccFZnsR
         Cc93iBn5tyS0eQvh8X9DWYXd/fX9w4gEU4ezla2fzJo4H0ZmkX0K9tIHdzPRWhj+yQMf
         Lyxw==
X-Forwarded-Encrypted: i=1; AJvYcCVcb3vK+ixRBcOqb3b97u3IiUi2HreNkv+4zEPu2+AAtFIWQMcV3daY8Uc6IB2y9Nw3bU/Rr8l6KA==@kvack.org
X-Gm-Message-State: AOJu0YyTJcpceVTTd7lluvP0ZCw6vX5CARK/y/ZlpCAbpBL6hf6xBc5B
	/5RIr11uKOoZPmpJAjppnAhfoZFSXJsbdYIHNbLmOKv+dxWpGTc39OAanch6VXugvy8vJikP2F4
	TSRQdmUwmGPAVlLv/gqoRKcsogF3/k+bLV6gEEaDP
X-Gm-Gg: ASbGncvDBHVgUX2yqlGWwwU0eRNp3qhCI1oONA3DbgMNqgdtjxh0VeSzTrWbclfONtO
	kvLZ66aOl9fc1G3X2+cQTjMRlxsU1gZzxAdgUNp0og60wyUXOcFajRFc4+pGjQXdZ5l+2/qpjzN
	88QK5G9TKBVLPn1LuoQFeExlGr6of+54MF1FXos+vYTLWJ5EQRd+JZtah89T52uepCh3TIe1zZ2
	+qJlbFjeF+nvJXuDpY12rCTEBE+iHQAuQD/Pa2M3oDgZDaI
X-Google-Smtp-Source: AGHT+IFYqrtp7JG0RfEaCFBlvsdX3gPrSrR0w79mzMBohMX0IZtkG8ES6BAULUyIYgI5eIGYjgMK4NZ+91j3WRygSds=
X-Received: by 2002:a17:902:f685:b0:231:d0ef:e8ff with SMTP id
 d9443c01a7336-242b19cdb6emr1226665ad.8.1754517291353; Wed, 06 Aug 2025
 14:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz> <CAJDx_rjvYdjPYHbBDKvkaWV=-OPJG=oRdSAugaOyJAXaOVu-9w@mail.gmail.com>
 <ee7ba479-4917-4d83-8130-8c247c08d2d0@suse.cz>
In-Reply-To: <ee7ba479-4917-4d83-8130-8c247c08d2d0@suse.cz>
From: Juan Yescas <jyescas@google.com>
Date: Wed, 6 Aug 2025 14:54:38 -0700
X-Gm-Features: Ac12FXzxJB1KJhmM9UUQIP_g3mb-qTY9IZidyxnzraRCfXRqR8AlpzShlLDxEgA
Message-ID: <CAJDx_rgL4bWnftmEfqnt87KuTYrvn-7J+ZOu5fd26q+fi0RVgQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>, akash.tyagi@mediatek.com, 
	Andrew Morton <akpm@linux-foundation.org>, angelogioacchino.delregno@collabora.com, 
	hannes@cmpxchg.org, Brendan Jackman <jackmanb@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, wsd_upstream@mediatek.com, Zi Yan <ziy@nvidia.com>, 
	Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x9ayq16jiowg5c7rrcwd7djw64ujfsus
X-Rspam-User: 
X-Rspamd-Queue-Id: CE0D140005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754517292-339873
X-HE-Meta: U2FsdGVkX19TUSBU30sYm2HM1hL7yWrcay+ybMj5AeIlP2PDYN5R7UZ1TgIZFvLqLb36iy9UpYrDMSENRQIdMggywiSJzYuAXJmNrNVvmAAzFsG/eIJgmmIdBRuZNt1+3Rliu2905c4q4e+pWfV+LDBjXBLM1eQq5f01qRWV+GdmrREwJveAieYQa6pBenOMLI2Tfqt2i+peDB5ADuk5alxk3lP3DtzKwMXdTVMDxGFzlHNb5DWo4WR4bQX0PjuIMgAppd3oPiH+GT7g9mV2eg+k2ADKyt5yaaN+k6dFSyXnyeVY/J3G5NVNzPScDPhjuvNsqay2VyDv2Zoh4ZKFiwYdexSX/Q7yoP4Sf/jFfMo/HOKojMUdhapXQERajDCAYEKK2Z4t4msyjMxviDzRGycBl1FHrbx2+PY+xkJ73n0vhTf31lRv8GP5IgV+3LDn7KoeZeIZO6A0VCXAQlqheZpOlJS+EBIQYXp3S9PKcTLFvnvTpJgxiYO+cppF0bcI0lleLHtVyj27Kuawhz8q+/VAoy24xW9iAfoZ5VkVFFhQ2Yrr7+Xld9XCcva2Yr13F4blajlw9KLI75xYGDUI0DkzqToFPh2UD6V5o82FmXn2TH0UsOLdoWdCifIusdOuUa2MG5a0X+ofcBH92ISAPaV7wd+MFhBcZj1L7oHKQdT2MqclxLy1TwAhg3z0QeiSe7T7R7ZiDGu8GOpmj3la4CK4mwH7AuognqKkwHYRHfN111QYK49S8ARDvReStFMe+qw3XOGUifpvVr5aszhIBHu2TvHPT8ZSQP+EumkIXATKlQnsM7P6bfFWyFJGnN7kOvmyK1la1VKH+S95d5CKwH7AYjJCRczqsISA3wkodHeKdEprC2RfaTCb32BcM1AO7t0q23TEaiORngwcyalc5Ebqmi8715LWDDXj9HNz2Nv7F/2jmb5xbStijIwNHyVD1+W9XUSAf6JIYJj+4hZ
 5lj9+KHO
 DjLcVEx5+bOSYrIB+ReV88XBHIbJ/hihDkvg/jYJRwceock5z2DmR7aUR4uenTNtEVQ++M3Huiq1dFNHYnxyjusCS8CvJ6x2jVGjBjv2LqN785mJGsa38oXE3kYgBhi4osyLEb0Fl21VofMQW0S0SHyV2MzNlVkTJaPFU58GTBXFj7DIM2xaOn9q7UE4ymm51vBxCrkxc+6mnQIFh/bfVU542eZN9FG8vRrpBFu1RUObvfNpkjg5NA621WRHthg9/QBjzpVkTm9ozU91je/QvzOUUGdIY6NQ9Zop7hXvypDi8gaGqiJoy7vjP5MJEKgoUl5JcElADSIqPggafWdKMwP/KFlLeolmIE9hEWDdV59drISW1Z+6oKJ9VTlVx+1aFWp7NvlGC/W7LzEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:09=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 8/5/25 19:12, Juan Yescas wrote:
> > On Tue, Aug 5, 2025 at 2:52=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz>=
 wrote:
> >>
> >> >
> >> > Thanks David for the quick overview.
> >> >
> >> >> I still have no clue what this patch here tried to solve: it doesn'=
t
> >> >> make any sense.
> >> >>
> >> >
> >> > The story started with this out of tree patch that is part of Androi=
d.
> >> >
> >> > https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeauror=
a.org/T/#u
> >> >
> >> > This patch introduced the __GFP_CMA flag that allocates pages from
> >> > MIGRATE_MOVABLE
> >> > or MIGRATE_CMA.
> >>
> >> What kinds of allocations would then use __GFP_CMA?
> >
> > The __GFP_CMA allocations are used to allocate userspace anonymous memo=
ry. This
> > was done initially in the alloc_zeroed_user_highpage_movable()
> > function, now it is done
> > in vma_alloc_zeroed_movable_folio().
>
> So that means you perceive the risk of anonymous memory being temporarily
> pinned and thwarting a alloc_contig_pages() device CMA allocation lower t=
han
> for file pages? The pinning can be a gup(), or a compaction migrating the
> page, etc...
>

I think that was the assumption when the patches were sent :(


>

