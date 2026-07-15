Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7EEC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FA06B0092; Wed, 15 Jul 2026 11:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07346B0095; Wed, 15 Jul 2026 11:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C5F6B0099; Wed, 15 Jul 2026 11:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 874406B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:52:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06038A0203
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:52:28 +0000 (UTC)
X-FDA: 84991453176.12.99AFDA5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 211C414000F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:52:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MKGT2LTS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784130746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWgBpxHnWpKz04YeWJzaau0+Llvhi6GnlbNod4OskE8=;
	b=5TmEDoEzDM22pYsBDVtTrxHDjYjYH/KG2CW9HGOV4zqO3oq6Uk+Q03ZDKp3Yn2EWVvDC9a
	O4YDbd4UbI5UwPriMYBdSgiMDo4V5CIGpUFrxNzzafeL/XhdQh1VFbID4KL1USt5jSgsnh
	pxrQmg5EDXhKmFgPZtLXIQkcg26RPQU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MKGT2LTS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784130746;
	b=ClXpmXWv7/Ua64FEMROxk38Fh7HdMxBUkCcJtodYKnY8Lryq6U/xlXyEje9tn75Sbp2xun
	OknRmYMtetNAHhL5cQ+xVh/NFWh1FtJANhLTsxBf6RtvXcJ16gbeujoEYhuhexg6JQBjPA
	4vEzw39N5pxxzIZwK+0hF1jcb1GnswE=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47640541585so2789415f8f.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784130744; x=1784735544; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sWgBpxHnWpKz04YeWJzaau0+Llvhi6GnlbNod4OskE8=;
        b=MKGT2LTSJS5rJPYml6YD59jIu7ikJ9UQEe58T9m91uoSmaaFhWsuQspDfFvTbssG8C
         JHoRk+vqBjZxmGTSNwuivHbFJpC669t1gTX9+RSjCxlRyxPCB0KDITd7kywfX32hV+88
         H7MJ0foZKe+8X6eVClKj3W3A4FZWek6PzM8jTWV5T5gIMzr3+ApicHjLh43XxafNFxWw
         j3uc9r5A/92XUm3W30QfGcAshulY2TedSR+WRJQUZN0+M6JjVGbU84qKaBHmkZVkEbNM
         aB4JKi9ewEZe52H4F1YrKCeBVm3gmbolKG15MtsWHvPu7H2BmiuvpHdSbSqeDDQo/E0M
         0NtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784130744; x=1784735544;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sWgBpxHnWpKz04YeWJzaau0+Llvhi6GnlbNod4OskE8=;
        b=deXK1KJwLEmDDWa1CCT5WJFNYGW26K7zAnZxxT9TGlibe+aX/SX5xIO8Jx/3/UyB6T
         J4D52JcirwGaJBpZqb8agCQpltaM/DCOIemOtVZSNk+3S7XfZDvXzuJ/iv+FZQhoeSPe
         okbGyS5JH1dT+9NY8qhdqdMir4pygMnAARH9KeB3lfs39siK9yKC4Hz9PsAIh0hPgNt6
         5beJMkxb4h9wDPVUeYh6YZN2bOYZX1GipN0mPRmyF9m9cRmZ+4yRZvwa5GBxBgm7yZ7n
         vsDuDG9r4Cm7wkUfSyM7GiA1Rr2aK7lOkfuBV3K2Oz6DrJ/wcexyvqPOX56H7fvarUrR
         BrFQ==
X-Forwarded-Encrypted: i=1; AHgh+Royb2j12VIAqnMn7m/avdO+ctd04VWaN4snAuZ20mdtu30dybG3lV1qKdB18LmsI+DtPXy7XBbrIA==@kvack.org
X-Gm-Message-State: AOJu0Yw3O/zQ33G1LAhDc3Rkg+0fPPlNetYYVoFXMtKwbTi2VVVS0flk
	rGIaKUAGC2xd4F4VCxLBCD1j1mGzKhPIaBGIXTts0QN+NjnxIbOdUvbP
X-Gm-Gg: AfdE7clwx6rfMgYbXBFEE1Il0mvKDC6P8JEOtWGd1iS3YBtjbhjAlPqi+516XcxO4Qd
	xqkYpiPTfoyEhzelDz6W6B1JL0uR/C0ngEDZI39W1YPycZecNmrdCaGz8zFATyxBrQnyKNzjEM6
	xDsNHcwArbBqzMpt0bMjgzN+DOiLQju5htj2RhMl5IhLXHpYmFKdU+WE+J7rIx0QLRIfI/VVee9
	8ZwZUwreurKp16U8xRRJ87A1XazjkEgJNeUhVh8V80OmjO5ARC8tKMQl3xJZS3Q+3Kyj0rseovv
	6dMjZPjvZ9qOmt3u8wgaDSGZ95e9IIUOvmxwvioT9VDsxdrdKTzfpUaDkHd/fN4ED0USvvrwmpN
	XvD0znvVg9v9AK7fpbVmCJEcGoM9xAHXi/W0JQaTcsh9h1IlBirTOe0IIkjxq5vGw2babvMtwhv
	3yLMgMy21kyd/9NyuebW9DafH0XfPstOqvdHI5vL3SD68dYlGVyQ==
X-Received: by 2002:a05:6000:46c2:b0:47f:5298:a010 with SMTP id ffacd0b85a97d-47f5298a31emr2117677f8f.41.1784130744504;
        Wed, 15 Jul 2026 08:52:24 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c30a9sm16692342f8f.31.2026.07.15.08.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 08:52:24 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:52:22 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, Andrew Morton
 <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, linux-mm@kvack.org, Mike Rapoport
 <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] mm/sparse: drop power-of-2 size requirement for
 struct mem_section
Message-ID: <20260715165222.0164a76c@pumpkin>
In-Reply-To: <71E70E00-98A1-4769-A167-5F4CB59EC96B@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
	<20260702093821.2740183-2-songmuchun@bytedance.com>
	<20260715103445.31b2f727@pumpkin>
	<71E70E00-98A1-4769-A167-5F4CB59EC96B@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 211C414000F
X-Stat-Signature: 63r1ywj997b54zeas3up4n1ar8nzzanq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784130745-757798
X-HE-Meta: U2FsdGVkX1+ZLUq7K5ZKKP84vh26bGncojgz2G7zDhs7bzwFnqiuDQ2VS/QvB5Q9JO2MDPdEsMc9+KlscYqPCTf/bas91BWbXIx9IY34AbWf8LOpQCiMGcbzC+GgzTIXUUxBey2mJAfJOW7RV8ZbpRnk6wWPVkPfRw2jtDgAWVozoLF1ogLikgobkHRFYNsGHX7trfbwrfRZVyjr017/6ntDb43vmWojOrIsVi1c0DsYAILgulzt/k2zJzfflPfkNHgwed6yTKaq3QadtJgksJ/DoolFx+banmNHX7MqF1e7pc2miOrpivujVocLC/lNJlZxHRYHr52hETJPbeYm/1yNiBOT6ltMKrqiF7QQx/gkcQPrsj73CB7EoNziBn8SJ8kyM7MZk94CIqNzWZ5nx/ULfrDW7OP/gY5Y95/pwq47Y/YRpZ15+BnupQF7vSjDtdBuBkZLCBU4bf+WSn/zfeCMkwWIKXYJsRwwBL+OXhBdXOv+gpRLgEaPGa2+/lHtB20NYjUbPFBIr/bZhKFDsTY1uegmOYZ9SLvn5l+1Bt7NSb80SWV+gswPt5/b0p/fe1Qjd2JERmqmT/NOqqm5BewWNKJCrQEfYI5p1AjDVe3tUOlh1YPZ1lss6yqisdPxojjWLSwEyQD8+LQrweDddGPoZLVE90Z4KAh72mon7pwAOi3yfLo27hpihWOJgtT1n2VPGGUGSzYX0oyeGfXaj2A+/zAI4yO08rZ6ipztKMka1H0yq+OVD6LrUIMiD6QdJr++Hhr1uu6PtihRp0zIB9NISC5TAO4Cj0WnV2AhZbgY8MEQ57R0S5otB0sKr8qrnYZMiNtU4qm5lEO7tXgcr1RRNdR+PEoU96ZLe1X9PzcNSu7xcSXaBRAa7eepVbWZPJMUFDa2EtmR98u2S78qtgmJ5LN/wu12ui6gKnlfswnQhhvEwycErQXgXdkYGADmYNt1GNPpyVW3kxDjxpd
 kfJCvvEl
 SJvrBbD/l0QfDc5Ppa8yhsJPIwa3MPhi6d2LTeBqCWSL327OGsgESPn3BIyu+ZnIvs2EzjTznl8F8UFYBBstyuM04g2n0MQu/z36538z4G+FPbbYZdP1uHEp1PzvXVkoaP/JDqewl8mvg/wxjSkr1d9n+V2wlc1QDhUbkStWmArR2SGqyAR5JDykmOjFYSRkZaWD+9lGoIXfguEOQuB0f46MvSllwu/LRfM3sRVnYpkCEfBeJG8pFegTxlQ+kv8+q9Kmc57ihjTeQtBdQlqTBepIKzNmRR1kTZsM/b/vz6WJFyr9O6sU7VIM69TbQzf+ZQcunQrTGuHxzJ7knO1Q0ydGNHb9CJLcM71ZQewxxj20H3ERbogKCToDFAkP3tcI9VQJv9vXzqw2jGemmnc5XxDTuRZpNUVJEoDsh9dYROrWkDY1JK50KANvjkENJ3jUgLAK16H4V8V9/l+gZSz+eR6t/CSgcM2uSKoLpnrKeWtyMV1Ca85WH0+WAloSMAEbnMQYEENcv7YSXecXS0QZtpV/XnAnOsp+KTcCxW9d+NhccE8MF7f4Tml6F/kP9Ur/48QMKY/dALZgKbWde1K0X5sDDtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 21:15:45 +0800
Muchun Song <muchun.song@linux.dev> wrote:

> > On Jul 15, 2026, at 17:34, David Laight <david.laight.linux@gmail.com> =
wrote:
> >=20
> > On Thu,  2 Jul 2026 17:38:05 +0800
> > Muchun Song <songmuchun@bytedance.com> wrote:
> >  =20
> >> struct mem_section is currently forced to a power-of-2 size so the
> >> section-to-root lookup can use a mask instead of a modulo.
> >>=20
> >> That requirement adds configuration-dependent padding, especially with
> >> CONFIG_PAGE_EXTENSION, just to preserve the lookup scheme.
> >>=20
> >> Drop the constraint and use a plain modulo for the lookup instead. The
> >> divisor is constant, so the generated code remains cheap while avoiding
> >> the extra padding. It also removes an unnecessary layout constraint
> >> from the type. =20
> >=20
> > This has a side effect of changing the size of the 'section' from
> > PAGE_SIZE to something 'a bit smaller' when CONFIG_PAGE_EXTENSION
> > is defined.
> > I don't think it actually matters, the allocation is done by:
> >=20
> > static noinline struct mem_section __ref *sparse_index_alloc(int nid)
> > {
> > 	struct mem_section *section =3D NULL;
> > 	unsigned long array_size =3D SECTIONS_PER_ROOT *
> > 				   sizeof(struct mem_section);
> >=20
> > 	if (slab_is_available()) {
> > 		section =3D kzalloc_node(array_size, GFP_KERNEL, nid);
> > 	} else {
> > 		section =3D memblock_alloc_node(array_size, SMP_CACHE_BYTES,
> > 					      nid);
> >=20
> > so the size might get rounded up to PAGE_SIZE anyway. =20
>=20
> I'm not sure I really understand what you mean. You might be asking wheth=
er
> the reduction in the size of the `mem_section` structure does not actuall=
y result
> in memory savings? If so, please let me explain clearly. As you mentioned=
, the
> size of memory allocated each time here should be PAGE_SIZE. Before the
> modification, one page could hold 4096/32 =3D 128 `struct mem_section` in=
stances;
> with the modified code, the number of `struct mem_section` instances that=
 can fit
> is 4096/24 =3D 170. Therefore, the range of memory sections that a PAGE_S=
IZE can
> cover has increased 32%.
>=20
> Please let me know if I didn=E2=80=99t get your point.

170 * 24 is 4080 - 16 bytes less than PAGE_SIZE.
In principle kmalloc() need not allocate a full page for it which would
lead to the data crossing a page boundary - which may not be intended.

>=20
> >=20
> > I also suspect that '% 24u' might be enough slower than '% 32u' to
> > generate a measurable performance drop.
> > (It doesn't matter whether you do '& 31' or '% 32u'.) =20
>=20
> David, I agree that % 24u is slower than % 32u =E2=80=94 the latter maps =
to =E2=80=98and', while the
> former requires a multiply-shift sequence. However, since the divisor is =
a constant,
> the compiler should uses the magic multiplier approach at -O2, which is ~=
3-5 cycles
> instead of 1. So I think the per-lookup overhead is real but small.

The divide/remainder is by 170 not 24 - but the effect is the same.

Indeed, but it might be a hot enough path to be measurable.
I've just done a pile of test compiles, see https://godbolt.org/z/zq8WjaqGj

The remainder code has to do the divide, gcc might notice it has already
done it - but it would be better to do it explicitly.
However, both sparc64 and looooongarch64 end up executing divides.
Also some of the others aren't as short as you might expect, both
generating the constant for the multiply and avoiding a 'mul' instruction
for the remainder (esp. s390).

	David

>=20
> Thanks for your review.
>=20
> Muchun
>=20
> >=20
> > 	David =20
>=20


