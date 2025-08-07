Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14D8C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FB98E0002; Thu,  7 Aug 2025 13:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2201C8E0001; Thu,  7 Aug 2025 13:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D018E0002; Thu,  7 Aug 2025 13:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0504C8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:28:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52A62140A32
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:28:03 +0000 (UTC)
X-FDA: 83750644446.21.C9A3DB2
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5CF2C140002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:28:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y4ks0sqF;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754587681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvjzDrIKgQsl2erKo7Ihb16VcGyaazDWcGJoJP+5K/o=;
	b=jgdDO7/F6kO/mqVh70gWxILFLsCyzyd5+2IG5vkQ2bQB7TbR5WtIMb4xGPIyyRZWLF9Osf
	BltoRxMorLlmczeIm7yKJkIFcG0N/M1wcK/DmXbPE8a0TxFmgUngVnLknrCuHK2fXeDOAC
	tdqLvpyUdz46zTU+Zk6TRwuBn6JL8cI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754587681; a=rsa-sha256;
	cv=none;
	b=QbvcVP4up2JMdcmJID8ofqt8VVqgspMcrCNROxmmihlsuDiL9jXdo3AGLt7SHnAX2l2upb
	/uphFHum0CcTRmwAoKiutZYXr59s+XQuI9a86bKI1P0gH1AIibQXH0ZtfJDvXj9XED8Fjq
	j8jNaVLuhHe0wCS7eGC/uRDAKhNadMo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y4ks0sqF;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-32cd0dfbdb8so11284171fa.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 10:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754587680; x=1755192480; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LvjzDrIKgQsl2erKo7Ihb16VcGyaazDWcGJoJP+5K/o=;
        b=Y4ks0sqFKk5zk3jEoYEHLuWEdVsLzbyHmFSb4Qi8i22tn74VsSguKb4qH/ZasZUp+w
         I+4Vu2sTofnBlacByz4azQ8k0YwT6A8f32Y/I9h1glI+jh8dBuIKUVhj0s1XT7qQNhk7
         PrCwJFnnXiFxytZqYjEcodgPFen/dJu1Fec0ovXncYob5++LG72ZylTMbfUcaTwGBiiC
         HWBq/3rsBcvAuuwvOZIcwIgug0xfHPKxvyDApp3rafgSpoeFU5u6Qjh6MwUF7wdQzjRB
         tAcEY2cC8td9Q0VY7kMmUydkR2NCeL3OrjEI7AI+wE9D+vWdehmHtpjGO4a/9l35dPdH
         pNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754587680; x=1755192480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LvjzDrIKgQsl2erKo7Ihb16VcGyaazDWcGJoJP+5K/o=;
        b=RipjPr/z0OYk23XDYHAAdX6fvvMfrWcF/GS6Y1XmDdAHZuIsBZUOkO+Wirw5dhzfGh
         7qoecXjAdE0YC3RFYvqytd2ld2v7zT1sBQzwgoSVMfhjEI1iQ9nIpcjxIg4L2GbTL6Jm
         Ml0ffR6+nalOUMHNhB/myIKBx0/OzoKSa89JYm12maShFJuuvAz5+6FmEO9vOJxRSVIE
         rFxo+W8AEBRKu7HYzI6yV2/QordbsapcU4GGWUgVnyxSb4fW2uXXuQM+CEMYYGf/HTUV
         foChFoDAaahbum6SefSSSL8r9W831BJRN5grTvKIyqzoyKMNN7CnN10UNoIoaXvoUsoL
         6MpQ==
X-Gm-Message-State: AOJu0YysOMeOCDLrSfSMIqHU99jmABdre8J0pP5knzpppqhmOEAwIHOA
	/6W0jX3PArGiwYFccjZE8tNoU9ek7xDysBIQMmdATmzYCAYC9V3wwigUdBDr1yEE18tCW3Ojuga
	cU21IgiNCTZGEy2V7gzQTCoAbS3sFQrg=
X-Gm-Gg: ASbGncvut9puNae7HSR5h6ZMp8IwX2dBcdyEHZEERoEdvY6uEJRRYo1L2NWDJoSZbC/
	R0xfBNIC4EttIocSBOl5VKGPABQQkl7GbnLeh5uOhsevGUc+FMjoKGcwPShS3lnptdZ8LMfY0Vt
	KWv+jLfQy78m1mPz2bu/kbLCkezVUPyLFpFHsxG+q4vZuArfs535scytnAxqnp0BkDmLgQBEFFw
	DhfbNsK+vn+DRKkpw==
X-Google-Smtp-Source: AGHT+IEsofgEMhOWhxj+6CrqZxW8VohN4VKvhX5Y/sB1Q6lk09l9sgHuPrSa5zu+rayoeA04o5iPmoqGWRidyTDUFt0=
X-Received: by 2002:a05:651c:220f:b0:332:5ffa:762f with SMTP id
 38308e7fff4ca-333813c31e7mr20434821fa.20.1754587679313; Thu, 07 Aug 2025
 10:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250807152720.62032-1-ryncsn@gmail.com> <20250807152720.62032-4-ryncsn@gmail.com>
 <CAG48ez114_bmuca2UL-g0ZY76-VqhL-4rQtJM_k0N2NJXE4vdg@mail.gmail.com>
In-Reply-To: <CAG48ez114_bmuca2UL-g0ZY76-VqhL-4rQtJM_k0N2NJXE4vdg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 8 Aug 2025 01:27:22 +0800
X-Gm-Features: Ac12FXz2l6lNInPFGDit_HyoORi-NE2WSIgBtNtHvx6HzsR_ww-M4jCga4R7IBQ
Message-ID: <CAMgjq7BhfGC7jVHQ62wAJBfTKCDG2+VdgpjiZ7hjxXeC5fHg-w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm/mincore: avoid touching the PTL
To: Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CF2C140002
X-Stat-Signature: 6ebueqx6u4nze45y8e1hng46jrsdcknz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754587681-135505
X-HE-Meta: U2FsdGVkX19tlLqiIbp0OUJEA7wEuC1cxrLXAjZ6sCYQKHHrPyafooicuVAQ875tNIQLxQ6yoECkFYSrB069ygjgUdu6TgUm8qVogumQXFhos3+YNP4SIjy2e8dHMNZLLlg6DQMGwCzchPD5D+MCejzO/2Pk6M6J1Ro08oHbX97GjNlJGex3prZlA+Mcy6ytwyCaBKrMf0rYuw+qyB0sS8Pwt0GNrw5lBMEeN2vVLgvCKyL6Sgkc5ZaRVPzJXEEoEtL8J8nOKkazZzIj4WxeutPs4kW9ZMP6K4G+I54mVs5ZPhLOPWU1999p3pktgdHER0T3sOZ0Nxc+SwM8xtGfrO6DaJP0oG/r/0Z/j4tNuPnRpDfNTvUFYIgqzex7SFJKejNAIe4hZA8VaL0tSYcdwuiNCyJplxSUoyunWCmVL+JE8eE1PQqprzZQ5zRDDvO4625Z2vbdd2v4ZHjLuLmKykjqfg4uzSbejjjuWjt9Exwu+v8kKOCiytAvc0oUsbI2RDohYi8OqXO8R0Pwr9MixVmq4pIQ0VpsW+eXCdfAdTLk3KpgHPfn74rDarE2ErVfaoh7HVbTHLs/Fv3oY31w1+8B09BvWwQf73zp0Qw9yg9ULHLqP9UZvuJ1x5wKLxMo3sTws5TuXQx53oy3gBYS9frysPBRQDIAUcTjT3PRaWV7DmlSYNsL/alS+vdqzRngzYxjiozOy4DNCqNYzddoGjczmxmNNJ3guEwfPtBAtV2dgolg/1WRKUp9L9bEyf9dsf56/9JlNviBDQo4jghwjKrHbsfrTQyDkikmNd5PzDKGHTtv+sIv+I/NTdiIR88LuRFte+DTgxdKPgt05zJEDW/p3U/5/FgXfomWz1m33xutLaanlV1FDcY3NigSydg3IhvmhNhqe9Po6Xh3yr9ud/zOQB06RJyONoIZSbGClfQ6sni+8WpI9+o8fM4z2UQVb49LYNETPnRH/MOMBnt
 rPxxsgW6
 yayZOT5eIIq2st8D5x0j79CKzLrbfjq1GChGHE0JB7mgwixlEGCwpxaIJBULvmOvBs4hDfIDEMS+3HUD0w9rvUMVh/H9diD631Ue1V968P/OeFVwBKIhdslBJpNrwAHC4QoL7hKcKbebZZmxkyZBxX/I2e3ml+/t+q97NZjOf0FdtjTZ12T54JhKVH4fxUzt95RSOebF2qhAzg9jzk7t8n8nZS7SHCW0WCyu2uZ4xQ1yC5JUot1x/pP4+VjsgkkkfRmr/2RVpGu/Lu69gMPkW9YwI2/qRjyknyRkQSBTAn0kuvcuwhlPkBjoSAXmt/goY5t7Nv0kyfIjHZ1AEsxSaGprGd3dSENiOgakxUZGiD4UArWrwDuom+dvi0TMA86saBlgZkZ8hyzr3ZaFoDQhDRGhX0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 12:06=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Thu, Aug 7, 2025 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
> > mincore only interested in the existence of a page, which is a
> > changing state by nature, locking and making it stable is not needed.
> > And now neither mincore_page or mincore_swap requires PTL, this PTL
> > locking can be dropped.
>
> This means you can race such that you end up looking at an unrelated
> page of another process, right?

I was thinking If the PTE is gone, it will make mincore go check the
page cache, but even if we hold the PTL here, the next mincore call
(if called soon enough) could check the page cache using the same
address. And it never checks any actual page if the PTE is not none.

Perhaps you mean that it's now doing the page / swap cache lookup
without holding PTL so if the PTE changed, then the lookup could be
using an invalidated index, and may find an unrelated page.

A changing PTE also means the mincore return value is changing, and if
called earlier or later by a little bit, the result of that address
could be opposite, and mincore only checks if the page existed,
it's hard to say the returned value is a false positive / negative?

Or could this introduce a new security issue?

> And your patch intentionally allows that to happen in order to make minco=
re() faster?

When doing a clean up (patch 1) I noticed and didn't understand why we
need a PTL here. It will no longer block others and go faster as we
remove one lock, I can drop this one if we are not comfortable with
it.

