Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE4ACA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 15:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C318E0008; Mon, 22 Sep 2025 11:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0433D8E0001; Mon, 22 Sep 2025 11:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74558E0008; Mon, 22 Sep 2025 11:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0DB58E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:49:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 749CE16016B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:49:42 +0000 (UTC)
X-FDA: 83917321404.12.2FDBF1F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06945140006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:49:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tah8mBCO;
	spf=pass (imf09.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758556180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvTIa0UHUb3091v98Rc0WTr4g3ow6gkAOn4IFBOnK64=;
	b=r3DcM6BTOjODqbtgC1cQL0+nGIF+3i/8QKMDDBQuJUJIBtaRQ452a+T1tq/jqutMnryasp
	MXagOErqHaVAAUAyWloVIJI8CN9pn5R+GsCm+YTVv+Kl8CColPaFzk3Exh+V/72ZsUOIMP
	cZ92IXk1S4A6F5n7wLQgcMuLLau/VbY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758556180; a=rsa-sha256;
	cv=none;
	b=SgJhJGNU2IQpdyGF6nFnQlQ9zzw0hRGscUKSlGDAAlM5opoWVHEomAl6VaD3TDrQsQMHN6
	Jeyh8qCJbVuC0wfaxdq0pCqfZnFV9ya3me2BgGINom285huS3ZOQSzwm4Q/kkoc+2+csrA
	9WqsFH/w4RSVORtL6FekqYBEk0jiMyw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tah8mBCO;
	spf=pass (imf09.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758556177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jvTIa0UHUb3091v98Rc0WTr4g3ow6gkAOn4IFBOnK64=;
	b=Tah8mBCOuBzSJi1Wz2ET1VyxrOB9DuLrLjE2/q2NkhFS5xGD2xOe3Oi0QTGfGuR/mRCcqn
	3chr6XF56AbeM0Hfn447y/FADNuiBZlkosM0RskctyaQS62EUY9qDmfBorPHxkhNl+dGVy
	C/vgzN+doHaAkG4tNRp1XgFbnwz7J3k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-G4yqXsvIMlSDUtkuAkmlVQ-1; Mon, 22 Sep 2025 11:49:36 -0400
X-MC-Unique: G4yqXsvIMlSDUtkuAkmlVQ-1
X-Mimecast-MFC-AGG-ID: G4yqXsvIMlSDUtkuAkmlVQ_1758556174
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b0438a5f20fso313574366b.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758556174; x=1759160974;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WywYXktQLEVHQCnoOhp4jbR+ceLDEmxLbtgIxFgQwIk=;
        b=KlCWvGLvMZIJegENq8ABmT/n+ra5lw87ekoUKB8rfedRviQBw0Ht6yrz9YtM9YOjA2
         U/Q78UmDnyCBVdpo0cyuxPjFT/WJDPGt7BVrrXzpMRhXdueabmj82IXN2W9wuKK9snqz
         ufmkBRVmk7P/E2Hu4pYKXJR7zR7wKOpB3ornDbwnt3vbNySdpQwjSfeljL31OAmQMD+a
         CrfHSEEtoAoG6qpt8/UwnruIaXsGx73hsgVzq8tB93SNqfZzJywpgpkWixTUkgHScDBu
         zXs9zG3H57JuE+Ly8kNCDlC0vmnGaKt9pkd9jm97PsioGmAKRg4C96cWv3372VVlCq+G
         42MA==
X-Forwarded-Encrypted: i=1; AJvYcCVdUzLG+sLLwLJV1u/ep0Hy+tRf3SIhAxgyGwam34S6PLuWmbCXoO0T3ySckyQIfZ8Oh6kiICBeYA==@kvack.org
X-Gm-Message-State: AOJu0YxWRbRE+Xmf9Um5XWTqFySCzZPZnfbVXMFVOfWkQ+kKubLnSV4M
	BzHAmy/g/niH4Z9gPL4OzO7nWC0s1DE1S6cFm3Ixl4XYZ9EBX5hqW7sNL3a7lmLqtgD885Hi8Q8
	OYnpAtb5d/ZbbSCWily0Pm0xf2Z+CyccU0vn0Qt4vFbb2iwwdeNoX
X-Gm-Gg: ASbGncvlveXsg/hfeOHCQWasyAos1JfeyxSzmlCc6V/R+YLMll6TfNgujJMgPyJ0v/7
	PXt0mxUt7ZOpuaxB+kY3Ze2nUQ7FU5fZSxLSk4RGoLqx8oQ9oezTCtWKJ39KzKCq7fQ6a6ywPn+
	VJNqXx906oXQ0UyuaPSLIvlGKflIe9Aacbe7RCOy7yvQWXhZXVNQ0GvMMQt1W5A0UawhKsOflrg
	/Ux047H4h+zZGv9ur1i06vwUgOBPSGlgHM8012MvvjtAlFNV8AtZdZluVFBD/jrK2zYl028ftKb
	rqZjHuEZdm/QVz2wsWw4M56GECwnF5R2gqqaWepwDNFfPl8v0jrnyLr4YnEO+hzTYrk=
X-Received: by 2002:a17:907:1df2:b0:b2d:b5d3:9623 with SMTP id a640c23a62f3a-b2db5d398c8mr186934166b.54.1758556174290;
        Mon, 22 Sep 2025 08:49:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9PXzNI7iuT6NoL+4FC5uVdHnMWrw8Q4gLh9w8pt9x5WwEnqsqHm/CAfVJFEadke+VixQp6w==
X-Received: by 2002:a17:907:1df2:b0:b2d:b5d3:9623 with SMTP id a640c23a62f3a-b2db5d398c8mr186931566b.54.1758556173806;
        Mon, 22 Sep 2025 08:49:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b288062c045sm590259966b.45.2025.09.22.08.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 08:49:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id AA3F1276A38; Mon, 22 Sep 2025 17:49:31 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Mina Almasry <almasrymina@google.com>
Cc: Helge Deller <deller@gmx.de>, Helge Deller <deller@kernel.org>, David
 Hildenbrand <david@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller"
 <davem@davemloft.net>, Linux Memory Management List <linux-mm@kvack.org>,
 netdev@vger.kernel.org, Linux parisc List <linux-parisc@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
In-Reply-To: <CAHS8izNMHYuRk9w0BUEbXBob38NVkMOVMmvvcq30TstGFpob6A@mail.gmail.com>
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
 <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
 <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
 <87y0qerbld.fsf@toke.dk>
 <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
 <87tt11qtl8.fsf@toke.dk>
 <CAHS8izNMHYuRk9w0BUEbXBob38NVkMOVMmvvcq30TstGFpob6A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Mon, 22 Sep 2025 17:49:31 +0200
Message-ID: <87cy7iv65w.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3v_MMvPhx3P4f0wwWZeUNZ3WULUZKEYoaMjW_fOBy0k_1758556174
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 06945140006
X-Stat-Signature: mseacmi9nb5ka6hjgumbkpfxmnukei8x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758556179-92027
X-HE-Meta: U2FsdGVkX19EqszhcJyvYh9o+WD1ADOKoFYCenLIvfihRJu3WlbOFilw8UB9CL7AYvCJ5Ze4wEy8FuGw/g3Q8OGYxkyD/HCDJh3i3LPAyskCngrBObUEbUWQawG9xAXbK8h4SyuBlZ2C+CMVKmAr49eD1WPk5QRSHSWMEbo+5KQHImUbIHtxJ1XjGpLSl6XAL9Gi1/qBgqtVdRWTiHKEr9KATlt56IrloSi3MCLd6SnMKHgZ9Tbhck3Pcud3On7uv1uOc6hRAOxrGi/Jx+sIV4AURscX+5iWHCs7eTojsEPaOiCrwY1Ce/ym6YUrI6kjWdewpCwjLI5qcf/QXsUp4Yaf/+CDJ3QPYcIXWOtN13Ta5MrE9ANBKWxPxxL9bNVIyBdMtWUYj8lndzxuxxYa8Oh07nlcesFI3TO8P/6OdqTQbje50BQU5eqYlRODfLtFqT3VOFUYCaO4aQdB8fq5Wz9kDBtzVMJooLAtxRC3iUfrxjlmy6mRQCn9hOKy0ybyUiDFojpJ7v7faFP347Eqp6x0KOogXTwzUXrIfp4SAL14iCbMW7ESQjjge7bcwnq0Bjr1SgN9w1G3O+iUsWxkFNWlvmhycxvFVIJeYbKEOZpeSo/dNdKvZa+69p7uORI9u9Zow2LOTOKSZz4Y6QmVY1kwbnDdfsLd7zzMCMPFMtkalhG5bLYCrZTXyR6NAFnQ/W9Uj9aQdQ51TuFCar19VxDN78CmpIvRA+7d9XKKhTMR+IE75RkmfLOZgENefYrJUuCavwTKLeWY4YLaU/6ivDtaWcnGJKRITDNlk6T3STs4mjXo2lWG4oYpHROqZmHqjePfsZN2N3PyPqsiLM1ZpJzj0FGUTdYVSC7mK7a5hqT2UMHebLpZIYyLRBP+lqmcKll3TMOPClY1OkzWHrFi9uOHVajTvn0/RZCqs+E+nAiiJzCGne59A80u6AZKIN3cfkL6hL3rqNGz4ok0bHO
 IjFeCRtB
 rdv/ZPUAKDCCqRNpwcb+gb4YWFaI03tU8XGtuMEbffBYG8pKgoyiZJ5C8zY8/rOOVbtWr1MvN8tjiRxDWHtHJRncIh/P5y3u8VkYjf1gNkIDBIZgRR/HfkD9jqU8ST6aHo7aMOCImOxbU7FP0cm+Fxzg6ucrpor3hgXqsQX1vUZ1kcGiKQuU+ZLvvQam81D2IpwgG8m/x6eJnWXWtJlAeNXN2fMSnLnlkylLd7XP3khanfzAFSOMdwfGCGwySsfHghEZBnxmQlHF/Yqitm7SBujgbU9YJ4LLhzo1s146/NyENZ5p4Y43wOqEV5mK71k0n05oqC4vFQ8JuyULlFSU5NnSnRDzZV+mpLcv9ZlXV4f9FiPqn6FC96B0evzh8qUqZmSsN9glgG2L/Agw4C4wzmTNcD9WmJ2q/XfBIMftVLL+8hCgT4anQfhyVySptf+V85w5cbks2aJ793ZXSh8AQ3UTLaHHpeQb7O/Mt6Tj4qd3f1qHPDbYqjkdvsY4eUXG2Xe5TaBAfhTFmpN9S9vUKVBOa1r5xFzL9FuNkFT0a9fen6qAkTLuT/vMSBkhD0f1+avnGvm5rBqm4RVy68uV5NLZBiLy93BysbfXHkvQ4Mua9GKaXb6jS4/V0cwx70B0tV1wc3NKABpyZCnBnJ8+YokknM4/CIgYNxQe6BNNLW1mRSgwyme772olSEmpccLcDXdEz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mina Almasry <almasrymina@google.com> writes:

> On Wed, Sep 17, 2025 at 3:09=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>>
>> Mina Almasry <almasrymina@google.com> writes:
>>
>> > On Tue, Sep 16, 2025 at 2:27=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgens=
en <toke@redhat.com> wrote:
>> >>
>> >> Mina Almasry <almasrymina@google.com> writes:
>> >>
>> >> > On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de=
> wrote:
>> >> >>
>> >> >> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> >> > Helge Deller <deller@kernel.org> writes:
>> >> >> >
>> >> >> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unm=
ap them when
>> >> >> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to =
0xc000007c on
>> >> >> >> 32-bit platforms.
>> >> >> >>
>> >> >> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to ident=
ify page pool
>> >> >> >> pages, but the remaining bits are not sufficient to unambiguous=
ly identify
>> >> >> >> such pages any longer.
>> >> >> >
>> >> >> > Why not? What values end up in pp_magic that are mistaken for th=
e
>> >> >> > pp_signature?
>> >> >>
>> >> >> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
>> >> >> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA =
is zero on 32-bit platforms).
>> >> >> That means, that before page_pool_page_is_pp() could clearly ident=
ify such pages,
>> >> >> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
>> >> >> So, basically only the 0x40 value indicated a PP page.
>> >> >>
>> >> >> Now with the mask a whole bunch of pointers suddenly qualify as be=
ing a pp page,
>> >> >> just showing a few examples:
>> >> >> 0x01111040
>> >> >> 0x082330C0
>> >> >> 0x03264040
>> >> >> 0x0ad686c0 ....
>> >> >>
>> >> >> For me it crashes immediately at bootup when memblocked pages are =
handed
>> >> >> over to become normal pages.
>> >> >>
>> >> >
>> >> > I tried to take a look to double check here and AFAICT Helge is cor=
rect.
>> >> >
>> >> > Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basic=
ally
>> >> > 0x40 is the only pointer that may be mistaken as a valid pp_magic.
>> >> > AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
>> >> > significant bits), doubles the number of pointers that can be mista=
ken
>> >> > for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
>> >> > mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values c=
an
>> >> > be mistaken as pp_magic?
>> >> >
>> >> > I don't know that there is any bits we can take away from
>> >> > PP_MAGIC_MASK I think? As each bit doubles the probablity :(
>> >> >
>> >> > I would usually say we can check the 3 least significant bits to te=
ll
>> >> > if pp_magic is a pointer or not, but pp_magic is unioned with
>> >> > page->lru I believe which will use those bits.
>> >>
>> >> So if the pointers stored in the same field can be any arbitrary valu=
e,
>> >> you are quite right, there is no safe value. The critical assumption =
in
>> >> the bit stuffing scheme is that the pointers stored in the field will
>> >> always be above PAGE_OFFSET, and that PAGE_OFFSET has one (or both) o=
f
>> >> the two top-most bits set (that is what the VMSPLIT reference in the
>> >> comment above the PP_DMA_INDEX_SHIFT definition is alluding to).
>> >>
>> >
>> > I see... but where does the 'PAGE_OFFSET has one (or both) of the two
>> > top-most bits set)' assumption come from? Is it from this code?
>>
>> Well, from me grepping through the code and trying to make sense of all
>> the different cases of the preprocessor and config directives across
>> architectures. Seems I did not quite succeed :/
>>
>> > /*
>> >  * PAGE_OFFSET -- the first address of the first page of memory.
>> >  * When not using MMU this corresponds to the first free page in
>> >  * physical memory (aligned on a page boundary).
>> >  */
>> > #ifdef CONFIG_MMU
>> > #ifdef CONFIG_64BIT
>> > ....
>> > #else
>> > #define PAGE_OFFSET _AC(0xc0000000, UL)
>> > #endif /* CONFIG_64BIT */
>> > #else
>> > #define PAGE_OFFSET ((unsigned long)phys_ram_base)
>> > #endif /* CONFIG_MMU */
>> >
>> > It looks like with !CONFIG_MMU we use phys_ram_base and I'm unable to
>> > confirm that all the values of this have the first 2 bits set. I
>> > wonder if his setup is !CONFIG_MMU indeed.
>>
>> Right, that's certainly one thing I missed. As was the parisc arch
>> thing, as Helge followed up with. Ugh :/
>>
>> > It also looks like pp_magic is also union'd with __folio_index in
>> > struct page, and it looks like the data there is sometimes used as a
>> > pointer and sometimes not.
>>
>> Not according to my pahole:
>>
>> [...]
>>                         union {
>>                                 long unsigned int __folio_index; /*    3=
2     8 */
>> [...]
>>         struct {
>>                         long unsigned int pp_magic;      /*     8     8 =
*/
>>
>> So I think we're good with this, no?
>>
>> So given the above, we could do something equivalent to this, I think?
>>
>> diff --git i/include/linux/mm.h w/include/linux/mm.h
>> index 1ae97a0b8ec7..615aaa19c60c 100644
>> --- i/include/linux/mm.h
>> +++ w/include/linux/mm.h
>> @@ -4175,8 +4175,12 @@ int arch_lock_shadow_stack_status(struct task_str=
uct *t, unsigned long status);
>>   */
>>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_=
INDEX_SHIFT)
>>  #else
>> +#if PAGE_OFFSET > PP_SIGNATURE
>>  /* Always leave out the topmost two; see above. */
>> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - =
2)
>> +#define PP_DMA_INDEX_BITS MIN(32, __fls(PAGE_OFFSET) - PP_DMA_INDEX_SHI=
FT - 1)
>
> Shouldn't have this been:
>
> #define PP_DMA_INDEX_BITS MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT=
)
>
> I.e. you're trying to use the space between the least significant bit
> set in PAGE_OFFSET and the most significant bit set in PP_SIGNATURE.
> Hmm. I'm not sure I understand this, I may be reading wrong.

No, you're right, that was me getting things mixed up; but looks like
you got the gist of it so that's good :)

>> +#else
>> +#define PP_DMA_INDEX_BITS 0
>> +#endif /* PAGE_OFFSET > PP_SIGNATURE */
>>  #endif
>>
>>  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS +  PP_DMA_INDEX_SHI=
FT - 1, \
>>
>>
>> Except that it won't work in this form as-is because PAGE_OFFSET is not
>> always a constant (see the #define PAGE_OFFSET ((unsigned
>> long)phys_ram_base) that your quoted above), so we'll have to turn it
>> into an inline function or something.
>>
>> I'm not sure adding this extra complexity is really worth it, or if we
>> should just go with the '#define PP_DMA_INDEX_BITS 0' when
>> POISON_POINTER_DELTA is unset and leave it at that for the temporary
>> workaround. WDYT?
>>
>
> I think this would work. It still wouldn't handle cases where the data
> in pp_magic ends up used as a non-pointer at all or a pointer to some
> static variable in the code like `.mp_ops =3D &dmabuf_devmem_ops,`
> right? Because these were never allocated from memory so are unrelated
> to PAGE_OFFSET.
>
> But I guess things like that would have been a problem with the old
> code anwyway, so should be of no concern?

Yeah, this relies on the overlapping field only ever being used for
kernel-space pointers; which I believe is the case with page->lru (since
it's a list_head).

I'll see if I can find a way around the "PAGE_OFFSET may be a variable
reference" issue and post a proper patch, hopefully tomorrow.

-Toke


