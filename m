Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FBDCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1EF8E0002; Wed, 17 Sep 2025 06:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1624C8E0001; Wed, 17 Sep 2025 06:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0782C8E0002; Wed, 17 Sep 2025 06:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6BBC8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:09:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9534CB9ABE
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:09:04 +0000 (UTC)
X-FDA: 83898319008.01.E3526EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34E03140002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:09:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lk6hPLcz;
	spf=pass (imf26.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758103742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPSc2KBdNgueSs5LPgCxOVr3ZwhKbxThXqd0U4AHGkE=;
	b=brcd+OcQPQRCrtpBjGGnS0xW9xBXHgpKepRC1W3r8ZYT2yIWssknxCQg1CXqMnQrYGhid4
	gpwlAUWuVY1uu7a3V7yQGjU4wMGj0lTr5ehHZm2Ebe9aByTM2CIJNAGkhRl8CTr7gBb4/A
	YIijzkkAMjfv1oam3jOkrQuTAMuIj6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758103742; a=rsa-sha256;
	cv=none;
	b=HNCVGV7VwPnW4rZJuDEju8EU6nXVCuI4b1/Kwc6HHZ3iOgyi6B9fBYO3dNTcLC6U4qKcIZ
	G73dBSXW1GlFyxi/Ied+Pvt+kHTJm2kptGs0+fBuKUbFaARjUKz/oU5PXvkr2G8P+4A3vH
	5UqHWJOp1u0Xhq05JbewC0xFxwivqHM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lk6hPLcz;
	spf=pass (imf26.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758103741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JPSc2KBdNgueSs5LPgCxOVr3ZwhKbxThXqd0U4AHGkE=;
	b=Lk6hPLczruJfICLQqUd9Ci6a4BWfp7hdPfmHdT3a9goAzbtVdnVW588F4RssIcGGSeRRDU
	dJd0lpoiRLdnTdqVPGrQ1/7LtLYP29k8rH9jtevRpTzWecJvvhos+z4eus7Uha/zalOmLQ
	fZz0Fo3ez4HqbcUk3AiqlWjNNYHxHW0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-y5gHNDdAPQKmpOswm9Ytog-1; Wed, 17 Sep 2025 06:09:00 -0400
X-MC-Unique: y5gHNDdAPQKmpOswm9Ytog-1
X-Mimecast-MFC-AGG-ID: y5gHNDdAPQKmpOswm9Ytog_1758103739
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-62f5135a320so2488584a12.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:09:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758103739; x=1758708539;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MSOmPKgNbwtM2LXmxImTNwZCiqRgQA6WDM55Gtf8iCI=;
        b=vEC58WP+NE2qgclHXw3G9W8nujzGFtjEWmp27fNdDrgMtlnd44U1hFaJzEM26mwIcM
         pPXRnob/lLFZRi2CmmU8dqGxDgVk067UavAHfxb15nXpv84tsWT1I4CuKk7ShefusBKE
         ipO4rOjyK6oinazxjZatsp2yMpTiIctvhkj4vMfkuZ/1PqV56ZsmXQC6NxJ/xkgttvLE
         cPZ1pddA9KcyYbNgiDdtFcnrOvKLoWPF0AQPuJuJmMYsQYHmNefQ/1JwQ3mqwsqhoiji
         GDKalpfSP0e4+FBLH8z1yZbbPtL5CCUGxo0W49k7BgQr505Yh8/Bqo7xX2170hlr4mpv
         nSiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq2qa9ZxFUpYIvq9tpYy9xuOUWSrdcMXwXHvYbQJqshKr0ORz3qgjJJfClUvkh5n/RmMgg6xWvEw==@kvack.org
X-Gm-Message-State: AOJu0Yy52O2GZlI2tATJaoBku/c7U4V3CPQD2zP4Brka9PwOdGSz702A
	6mHENAZ5T5/kL981cOpBxL3cagNg3nfwf2TIyHJpVNcywudvbCbyLVivcrY5OJKJJ87l4m7mn5P
	JN/RNm5X2JWy5j1dHa8ITAc7J/LU7vRwAtEfiV7X9tNoOf5+RpgAk
X-Gm-Gg: ASbGncuoZsCxj3OVqGzd/nxeg8Gd24g9fl2jDDmGU05S2y0GORO6SWcSMmKtX5AGo4S
	sBUOOtlRiJZZZ+Ked+NEV9KTSDtnNcJzZelFIXLQn5W9QU6am/XPuJZ3Zb0GKUp86ZMcROlivdu
	4bwjPTgyLtvvX650R4xosMtUn7qNAhCTaLaKkSeqvpquaYeEvpglO4LqrZwNZCivfHNJI7UbNaf
	xka5w6isn28ACHZhw4CACv7p7Z05eA6FeCBpIJgrR2Bm5sGoXkgqJ/xkIKD7fNp2mJKM6tTDAX/
	XKtVk/Z9fziQwHFSQX+Znpr3tEr9ErokrdRt6POJSvWmdHAgmv0ti3f7Kr/JcAi+xgg=
X-Received: by 2002:a05:6402:46cb:b0:628:aace:ee7f with SMTP id 4fb4d7f45d1cf-62f84213e1cmr1661582a12.15.1758103738962;
        Wed, 17 Sep 2025 03:08:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCI1bwwBAT5IkwS4xgabTZJQZfa1X7g+mAYVRtNfR3fNJSI8m+TnvZR9JSOQ17ir48t7RJGw==
X-Received: by 2002:a05:6402:46cb:b0:628:aace:ee7f with SMTP id 4fb4d7f45d1cf-62f84213e1cmr1661562a12.15.1758103738506;
        Wed, 17 Sep 2025 03:08:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec33ad242sm13053380a12.17.2025.09.17.03.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 03:08:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 87B8B25C74B; Wed, 17 Sep 2025 12:08:51 +0200 (CEST)
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
In-Reply-To: <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
 <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
 <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
 <87y0qerbld.fsf@toke.dk>
 <CAHS8izOY3aSe96aUQBV76ZRpqj5mXwkPenNvmN6yN0cJmceLUA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Wed, 17 Sep 2025 12:08:51 +0200
Message-ID: <87tt11qtl8.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w06IDPmQKHzHuwfazRM-l18BJfzvNyZ404FG0-1Knng_1758103739
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34E03140002
X-Stat-Signature: 84ru4hb33btg3oj99jjzz8dubr7ire3x
X-Rspam-User: 
X-HE-Tag: 1758103742-742353
X-HE-Meta: U2FsdGVkX1+XmUYQV/sePP5qtl7dTehCMVU89NLB85ZgyQLd3k0WD2I0Q9q+QvF6Hxl2qd0g9bSD8uFHyp/XUvHLQqklcfZk3Bubtopag291AZbJCR5MZu8q0nAI2Q59sgItvVnawVsViCUS8BHjSClKyy+Hrn9en2VfQ4Lkkexd/qv4HPD0lW0fEe/ET4an+T0jgFCYKC7OTYs32DUcrDEi/1NsdQAUd9MOAqLno2B24I0XAUArbPj6mPXEE8cwoi9qPYG5swsu3p6ei/Cc9hLRBWuGZgxSurqAnb7Soj8dC8NXe4EUgBpEUHSko7akgv/XUH/RZ23FRotR9eT4BclAVAupyC4SY8GayfRlIVzMmi9RhP/GtrXmW1lf6XegitFlY0aUUADauU37/H37lwEXxlxm8Z3/8KSSxXtDM2C2VYyvhtQ5K3GFn6eqghI85rWXEEF4Nd6MUm4Qev0Sd7MVDBj8L9Lv+cqfHRD85B/5ZWfYAvMZG8TgjlNMtq/v/ow2tthJFHHOdNZW2O3ABVMvdLU3wjMh4x/QE14eDxkFQcMRrSwas4Hg0gN62Ceq8RH9obgcbA5hE2Fqf7fEDtLNpHBG0Oca8ncGWymsPG+wMClF62BbkiL8RU1yoDysg63/YW1NdXKFdsAurUZyu4w1yp+FZBB2AIqOapifFHpAMgy+UVEWpDzjLiZV30POgJCMuWgvkPyWkFDZF1jtYG6dGWaGJMgu4rZVXn1soygAJDoM/w51h3hUhEdOlLkrMFvrCoyt6IxH9Dogaa3+Ztkh5I6wVN41dK1wdlAh6HzVNWMeLn49NdOdgUDmENU74VA5svrNL17n7NXg3xKh3e1dMaHT013ec7dqcKqLrpxH8x44HdiB4xfM/HemHAE09yP/56k2Dt8NGeA4KT0MycqTevW6La58BdXu6XkN9/1oZHePryUptdonhiazFF7LnXxXZCkgBhgUPAxsOTM
 L/muJo+9
 xego7hLSRL/NGfmXO4TamIgUKotUWD1YjIXIXMu6n8nbkpoRrh1VWEsJfpTrs/JbQcdr9b+Ha5g5vl3XP20duBDa+4chiiNISwIe/bdmTIFFDal+eFiyrYGLId2QAH5099aTkTpjlMzgy8P1mVB7zrQJz+sLhLd0GPT6HjjmOHIImHfeaUmL78So0oIAMV/bzKqUavxK+Yc8ZdoiXAWT0AOb+29T2V4fkbc7FaiZ+fVzwu41D4JSh46YCb9guAXYyvGKKP7EfXRdmWjq61ftkOdDAowb9HNQLxUrVF+NkoRDF9SWgbtiXwzafi3itl83/1RAMBbKrz4s4rhyVn41TDYnDEPT5gibzsjR0RtaB2id+swJ77s3rNS4JghLbeUaPELJfVboNj6QB7Lkuh626mUCuCEe5XNoQ4F60xfOUbhU4NWzfP2ipsg8E9Kqn0rXorsCnZAwZKswwlnfmxb7KbOHUkTfFFioso4SObYT8g2n/lfRfZubHV3heZxQz3mM+32rfPmEsQUxDdD8TW2FfTPi1KRk5ZCFGeMo7adbE7REUuSRW2oPV5x8pFAZqROSba7ym
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mina Almasry <almasrymina@google.com> writes:

> On Tue, Sep 16, 2025 at 2:27=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>>
>> Mina Almasry <almasrymina@google.com> writes:
>>
>> > On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de> w=
rote:
>> >>
>> >> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> >> > Helge Deller <deller@kernel.org> writes:
>> >> >
>> >> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap =
them when
>> >> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc=
000007c on
>> >> >> 32-bit platforms.
>> >> >>
>> >> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify=
 page pool
>> >> >> pages, but the remaining bits are not sufficient to unambiguously =
identify
>> >> >> such pages any longer.
>> >> >
>> >> > Why not? What values end up in pp_magic that are mistaken for the
>> >> > pp_signature?
>> >>
>> >> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
>> >> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is =
zero on 32-bit platforms).
>> >> That means, that before page_pool_page_is_pp() could clearly identify=
 such pages,
>> >> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
>> >> So, basically only the 0x40 value indicated a PP page.
>> >>
>> >> Now with the mask a whole bunch of pointers suddenly qualify as being=
 a pp page,
>> >> just showing a few examples:
>> >> 0x01111040
>> >> 0x082330C0
>> >> 0x03264040
>> >> 0x0ad686c0 ....
>> >>
>> >> For me it crashes immediately at bootup when memblocked pages are han=
ded
>> >> over to become normal pages.
>> >>
>> >
>> > I tried to take a look to double check here and AFAICT Helge is correc=
t.
>> >
>> > Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basicall=
y
>> > 0x40 is the only pointer that may be mistaken as a valid pp_magic.
>> > AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
>> > significant bits), doubles the number of pointers that can be mistaken
>> > for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
>> > mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values can
>> > be mistaken as pp_magic?
>> >
>> > I don't know that there is any bits we can take away from
>> > PP_MAGIC_MASK I think? As each bit doubles the probablity :(
>> >
>> > I would usually say we can check the 3 least significant bits to tell
>> > if pp_magic is a pointer or not, but pp_magic is unioned with
>> > page->lru I believe which will use those bits.
>>
>> So if the pointers stored in the same field can be any arbitrary value,
>> you are quite right, there is no safe value. The critical assumption in
>> the bit stuffing scheme is that the pointers stored in the field will
>> always be above PAGE_OFFSET, and that PAGE_OFFSET has one (or both) of
>> the two top-most bits set (that is what the VMSPLIT reference in the
>> comment above the PP_DMA_INDEX_SHIFT definition is alluding to).
>>
>
> I see... but where does the 'PAGE_OFFSET has one (or both) of the two
> top-most bits set)' assumption come from? Is it from this code?

Well, from me grepping through the code and trying to make sense of all
the different cases of the preprocessor and config directives across
architectures. Seems I did not quite succeed :/

> /*
>  * PAGE_OFFSET -- the first address of the first page of memory.
>  * When not using MMU this corresponds to the first free page in
>  * physical memory (aligned on a page boundary).
>  */
> #ifdef CONFIG_MMU
> #ifdef CONFIG_64BIT
> ....
> #else
> #define PAGE_OFFSET _AC(0xc0000000, UL)
> #endif /* CONFIG_64BIT */
> #else
> #define PAGE_OFFSET ((unsigned long)phys_ram_base)
> #endif /* CONFIG_MMU */
>
> It looks like with !CONFIG_MMU we use phys_ram_base and I'm unable to
> confirm that all the values of this have the first 2 bits set. I
> wonder if his setup is !CONFIG_MMU indeed.

Right, that's certainly one thing I missed. As was the parisc arch
thing, as Helge followed up with. Ugh :/

> It also looks like pp_magic is also union'd with __folio_index in
> struct page, and it looks like the data there is sometimes used as a
> pointer and sometimes not.

Not according to my pahole:

[...]
=09=09=09union {
=09=09=09=09long unsigned int __folio_index; /*    32     8 */
[...]
       =09struct {
=09=09=09long unsigned int pp_magic;      /*     8     8 */
=09
So I think we're good with this, no?

So given the above, we could do something equivalent to this, I think?

diff --git i/include/linux/mm.h w/include/linux/mm.h
index 1ae97a0b8ec7..615aaa19c60c 100644
--- i/include/linux/mm.h
+++ w/include/linux/mm.h
@@ -4175,8 +4175,12 @@ int arch_lock_shadow_stack_status(struct task_struct=
 *t, unsigned long status);
  */
 #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_IND=
EX_SHIFT)
 #else
+#if PAGE_OFFSET > PP_SIGNATURE
 /* Always leave out the topmost two; see above. */
-#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
+#define PP_DMA_INDEX_BITS MIN(32, __fls(PAGE_OFFSET) - PP_DMA_INDEX_SHIFT =
- 1)
+#else
+#define PP_DMA_INDEX_BITS 0
+#endif /* PAGE_OFFSET > PP_SIGNATURE */
 #endif
=20
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS +  PP_DMA_INDEX_SHIFT =
- 1, \


Except that it won't work in this form as-is because PAGE_OFFSET is not
always a constant (see the #define PAGE_OFFSET ((unsigned
long)phys_ram_base) that your quoted above), so we'll have to turn it
into an inline function or something.

I'm not sure adding this extra complexity is really worth it, or if we
should just go with the '#define PP_DMA_INDEX_BITS 0' when
POISON_POINTER_DELTA is unset and leave it at that for the temporary
workaround. WDYT?

-Toke


