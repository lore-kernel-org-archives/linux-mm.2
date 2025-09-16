Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77FA5CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947498E0018; Tue, 16 Sep 2025 05:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91ED98E0001; Tue, 16 Sep 2025 05:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834B08E0018; Tue, 16 Sep 2025 05:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72DA98E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:27:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2B881DFC89
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:27:49 +0000 (UTC)
X-FDA: 83894586258.29.1F91AE2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id A967A180002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:27:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejzW+gt0;
	spf=pass (imf16.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758014867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jQ2xIOlZcY5kkEacuWoU5YrT4TbiuRFkDjU2o439/o=;
	b=75efFc6fyd1LQdILM3PwLtF7Yu78s10Eac5vQb/MIl4i1ON7Rtvkrgp62wYyMZk61eSJaB
	UpulETdNiROr2dwDi95nSKm9r18Fht+19UhOKlmZJPYvIVQ7o1jvZPedGSoPm66GDyNyVV
	51c6hsqkJyo/A2orePRBKkv3p7mXffs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758014867; a=rsa-sha256;
	cv=none;
	b=fqUbOwihWliRbHy5cMd3BU4/rR0MV5e+tqsJFOjvj56y9dWMshwsv/RqRyGQAkHYUvrIfn
	+6aa+o0rPDmah0CEnhmWKZ+wiMj6xWLkmHqvskhWE47GTujvPLPC4vZz1nkRr39MpVNF5V
	funSlhLFTGLDdXL8OQ8vMBFnN+zYVp0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ejzW+gt0;
	spf=pass (imf16.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758014867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3jQ2xIOlZcY5kkEacuWoU5YrT4TbiuRFkDjU2o439/o=;
	b=ejzW+gt0j4opwT/qu0TrAtWdbagsx2NnIQnpSkBHm3kCWV3Bk6EYCOmUEjdJHz6jIsou3n
	UPM4SghQjmcjyOKonu61MbL1oXEIRJk8ZBT4/ZcB5raN/maaGLWplTYkOM4simnR/4ljCK
	lWuOv6i8H/2sSj39zB7Llw7kAL0zKCw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-QS0rt7jYOXugZul_rQExqg-1; Tue, 16 Sep 2025 05:27:45 -0400
X-MC-Unique: QS0rt7jYOXugZul_rQExqg-1
X-Mimecast-MFC-AGG-ID: QS0rt7jYOXugZul_rQExqg_1758014865
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-afe81959e5cso504884466b.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758014864; x=1758619664;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J59OiJgG+nalIV3FMKbGlZSlucF0/CWesH+hT77dSmU=;
        b=ZoaQa9bWMNA8M8AlHW56T2NlRCUNZX6jQSnMZRqFU9CMh1j6qKnDCzXqftXqIvLapF
         o3OKd37l5uHykPVCnFM2AGeKHugEp/0920jd4efABMt3N8gErk1B97LPWE6wWPt0K4aT
         mR6SyiPklGML06GQPW0jcf1Z0PAYCtlb0jcWKkAA/awOOLEWpC3w+yV23l9Mf2CiCfSC
         p0He/QXvXXVwx4HRL80XBcAK4R5hO1/alp6khtwLGPzuNyOauQwlqKsVpsslwF8DtT73
         iCa31xM/LNYKxiVdladmjknV0zu150zZFkRsMTTyV0c9oeTxI8GbMpztPDo3OT6tw6vv
         6BvA==
X-Forwarded-Encrypted: i=1; AJvYcCWC39Yyx0tWe5bzY3ipiI7+OEDZfhozRA5vgUnqk0+X2O83yvNJLSCNZkiSzwFqTjQ4pWZhJAK/FQ==@kvack.org
X-Gm-Message-State: AOJu0YyNbySwwDw4mijhDw0sNLMkINyeWy6PR2V4Qfi1pH3DjFpIo1TW
	+2SkwEoxx0EmZdAGnlQJbAX0zPqGSPi5Mrw9w750ceEBAMTAiRBoxyks5X10tQjTgHOBIugDM2K
	E4bvw65oABFccTdVyzw4agy162cFqH1JeYk8g2fLlG25SaNYRCZAB
X-Gm-Gg: ASbGncsbzXb4HRjE+jN1mSgFCJIOoCuQbbEZ7R4qToXcV5rFtVpndZMiZZCA1UehQLh
	OlB+5QpegQviS/0LYqgiywlVHLrrIbaFNWqCpkbsCl7oEvQWKshnDGexDIKVRIwDrSc8u8cSoC2
	088C8/c5ttGdg1J/AOmGbt+w6A7IcMxXiknivufhOFnD3VhFugTQvK8ks+Tx1q9HNmISgO/CoSn
	UEDEXmEgcqORAsOSiTt9m9XvydPUA7WeWo/ruXzikcCGPRoqj++oGissZq88V+0C4mgSsYnCHu3
	KNRf1VRpxVO64llu1+/U2B8mYOjOwCwOvMdv1H9WJ2mc+lO677k6vAHIZluzLM1/
X-Received: by 2002:a17:906:b310:b0:b07:de2c:1268 with SMTP id a640c23a62f3a-b07de2c15famr931578566b.5.1758014864434;
        Tue, 16 Sep 2025 02:27:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk1ALl6UsSbSFvHQ00Kgc7RvzsxEkP3PZF56LrtF0J0ob9LrtksUQ3RV5zpsIq7u1tOeNfbg==
X-Received: by 2002:a17:906:b310:b0:b07:de2c:1268 with SMTP id a640c23a62f3a-b07de2c15famr931576466b.5.1758014864011;
        Tue, 16 Sep 2025 02:27:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b333437bsm1107159566b.95.2025.09.16.02.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:27:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 0EDB025C5AA; Tue, 16 Sep 2025 11:27:42 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Mina Almasry <almasrymina@google.com>, Helge Deller <deller@gmx.de>
Cc: Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>,
 Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org,
 Linux parisc List <linux-parisc@vger.kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
In-Reply-To: <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk>
 <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
 <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 16 Sep 2025 11:27:42 +0200
Message-ID: <87y0qerbld.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LjJo5d5byW6Ry3ZL1kLswmnB5t2l8BaD1lhefyfdJR8_1758014865
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w1mbn716pt38hzhseixh3cc4bhkzgsie
X-Rspam-User: 
X-Rspamd-Queue-Id: A967A180002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758014867-326998
X-HE-Meta: U2FsdGVkX19PEkJTmgRFLnPyKyWLyKLLlt6BbXyNbVeeT5IDS14XOhjuH0AN413rSRi4nmcIpvnd4BQsSjjt/26HTk++SGKceU4ecoUbZTjvpdY5NJxHST6j1KRLHy9BAh4S796P6dI9zsMO8UWoRKdfc3IYHQ/I+Lwbf2RWmAsuDML+jpYcMTGeV7TmUlTpv9SYOPjQESMFr0wginfCfYYpHjhcvIvF7PN9hskmelgFOzocnPoSfB3grkGCLRaKheecQs9ELQzhrBM4+u65zL/ao8dzkgANab/Nz4oZS2JnwEqYXD5Ma0JyrPhN/32zWm/uOKdZnun7Nq9xb+guKidHdLYrQcqBlIJ/bbthGjpw0ngNhpphpIiFdsKjuBuXgfDUW/WXUkn0V19hgxOanN/BLx7tyeQkCFoXw0mmeJ4yJpXtPYUlvWCgZkaT1QNyPt8bOPo9XXjbIWYQzpdUZE88QhasavpF8JG0jayg8NkTzM4zqw7Vq+dXzTfzWS8Vq1QXPVfZChc1ONdslcOh9DnCqPYHCypgOFLEUh7KItj1D7GmQJ0DxZv8sidCyzTJdqiPvlorZhbckqSJxwm3QIPPWWiE5VaP8Nxm9uvHeRZkjDQ3f1SHCndkBIY7hDtBmKNGN0A2F7MEIk7YhUMxCmTFnMAGobyNDx0Lxz7N9YR8rejM61vlOctT09O4csgWRtkwsdUaGMZGquTfVw2WJ77E5JUthuAJoLLGI6zMD7KLsBq3RazWZnUUrXaFl72xzSaEHgPHOi5zRKwJmUe38xM8K3aBtccd2/dMjV7bkCKeM/mW3cH2gVpGybtyk0BWQ9erzcWHEP7vUBu57rOkNxurFq5QDQj5Ng/w0PO0hk94mcstOcOxesUemgFmfdjUiOQKbVYdXBNrdVxPnJeeBwS7N/NPFoXZLiF+Q04xNTHl6/ehnQrwGHmHUi3Vb+KCqFEDz/ict/6LhaKlWlU
 7/UKAnkl
 gQcRW9rIgT1cZ0mLHykQF0lN7DNugEKo+Dk8n7WZ3nGvabbMw9Z2ZDnl0lq2jiG5H2p3tt3zgtpZaJzBhmy+Sq1T6cbkvrHhUHD+ZVXPy740rvH+g0noz6nk0fqQf+0EIz7hk8tz4WxHBJXM9pnKvuAhCSpyU9OK/1d1aALOzT0m8tjbfTgfLU+yAsmcl7lyYO7p43noykUo9b6bWMuuzmIIDNMq1Bg9O/iDmMbrDH8Vjyezw44Pdhy9J8SGE+n87JQpARsQvlfhPQz6SuuQ43WmvVPcAi2RLCU01TfJfWGZlsGF0f9d3LJ0TYevD5WaDFrY7Ok9xXaZMMRYJv3kdxZmlbZa5sY5bMuzyb3wB7N+5wq8zdEdQXfag+kkkKLm8YUY/b1wRrh9GQiJ7FZJ9GvFe1LZ1vpU7vI7wUEX60YlsWXs3JFEwA6+iImKzvHa7+vG4ZiH5k7isuzMMO5LSFb7il4MFHER6TSJyVBWhmEQQ/XrmtVE8UOeURHczpvtUYloz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mina Almasry <almasrymina@google.com> writes:

> On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de> wrot=
e:
>>
>> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > Helge Deller <deller@kernel.org> writes:
>> >
>> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap the=
m when
>> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000=
007c on
>> >> 32-bit platforms.
>> >>
>> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify pa=
ge pool
>> >> pages, but the remaining bits are not sufficient to unambiguously ide=
ntify
>> >> such pages any longer.
>> >
>> > Why not? What values end up in pp_magic that are mistaken for the
>> > pp_signature?
>>
>> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
>> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is zer=
o on 32-bit platforms).
>> That means, that before page_pool_page_is_pp() could clearly identify su=
ch pages,
>> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
>> So, basically only the 0x40 value indicated a PP page.
>>
>> Now with the mask a whole bunch of pointers suddenly qualify as being a =
pp page,
>> just showing a few examples:
>> 0x01111040
>> 0x082330C0
>> 0x03264040
>> 0x0ad686c0 ....
>>
>> For me it crashes immediately at bootup when memblocked pages are handed
>> over to become normal pages.
>>
>
> I tried to take a look to double check here and AFAICT Helge is correct.
>
> Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basically
> 0x40 is the only pointer that may be mistaken as a valid pp_magic.
> AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
> significant bits), doubles the number of pointers that can be mistaken
> for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
> mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values can
> be mistaken as pp_magic?
>
> I don't know that there is any bits we can take away from
> PP_MAGIC_MASK I think? As each bit doubles the probablity :(
>
> I would usually say we can check the 3 least significant bits to tell
> if pp_magic is a pointer or not, but pp_magic is unioned with
> page->lru I believe which will use those bits.

So if the pointers stored in the same field can be any arbitrary value,
you are quite right, there is no safe value. The critical assumption in
the bit stuffing scheme is that the pointers stored in the field will
always be above PAGE_OFFSET, and that PAGE_OFFSET has one (or both) of
the two top-most bits set (that is what the VMSPLIT reference in the
comment above the PP_DMA_INDEX_SHIFT definition is alluding to).

The crash Helge reported obviously indicates that this assumption
doesn't hold. What I'd like to understand if whether this is because I
have completely misunderstood how things work, or whether it is only on
*some* 32-bit systems that this assumption on the range of kernel
pointers doesn't hold?

> AFAICT, only proper resolution I see is a revert of the breaking patch
> + reland after we can make pp a page-flag and deprecate using
> pp_magic. Sorry about that. Thoughts Toke? Anything better you can
> think of here?

We can just conditionally disable the tracking if we don't have enough
bits? Something like the below (which could maybe be narrowed down
further depending on the answer to my question above).

-Toke


diff --git i/include/linux/mm.h w/include/linux/mm.h
index 1ae97a0b8ec7..3e3b090104d9 100644
--- i/include/linux/mm.h
+++ w/include/linux/mm.h
@@ -4175,8 +4175,8 @@ int arch_lock_shadow_stack_status(struct task_struct =
*t, unsigned long status);
  */
 #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_IND=
EX_SHIFT)
 #else
-/* Always leave out the topmost two; see above. */
-#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - 2)
+/* Can't store the DMA index if we don't have a poison offset */
+#define PP_DMA_INDEX_BITS 0
 #endif
=20
 #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT -=
 1, \
diff --git i/net/core/netmem_priv.h w/net/core/netmem_priv.h
index cd95394399b4..afc5a56bba03 100644
--- i/net/core/netmem_priv.h
+++ w/net/core/netmem_priv.h
@@ -38,6 +38,7 @@ static inline void netmem_set_dma_addr(netmem_ref netmem,
=20
 static inline unsigned long netmem_get_dma_index(netmem_ref netmem)
 {
+#if PP_DMA_INDEX_BITS > 0
 =09unsigned long magic;
=20
 =09if (WARN_ON_ONCE(netmem_is_net_iov(netmem)))
@@ -46,11 +47,13 @@ static inline unsigned long netmem_get_dma_index(netmem=
_ref netmem)
 =09magic =3D __netmem_clear_lsb(netmem)->pp_magic;
=20
 =09return (magic & PP_DMA_INDEX_MASK) >> PP_DMA_INDEX_SHIFT;
+#endif
 }
=20
 static inline void netmem_set_dma_index(netmem_ref netmem,
 =09=09=09=09=09unsigned long id)
 {
+#if PP_DMA_INDEX_BITS > 0
 =09unsigned long magic;
=20
 =09if (WARN_ON_ONCE(netmem_is_net_iov(netmem)))
@@ -58,5 +61,6 @@ static inline void netmem_set_dma_index(netmem_ref netmem=
,
=20
 =09magic =3D netmem_get_pp_magic(netmem) | (id << PP_DMA_INDEX_SHIFT);
 =09__netmem_clear_lsb(netmem)->pp_magic =3D magic;
+#endif
 }
 #endif
diff --git i/net/core/page_pool.c w/net/core/page_pool.c
index ba70569bd4b0..427fdf92b82c 100644
--- i/net/core/page_pool.c
+++ w/net/core/page_pool.c
@@ -495,6 +495,7 @@ static bool page_pool_dma_map(struct page_pool *pool, n=
etmem_ref netmem, gfp_t g
 =09=09goto unmap_failed;
 =09}
=20
+#if PP_DMA_INDEX_BITS > 0
 =09if (in_softirq())
 =09=09err =3D xa_alloc(&pool->dma_mapped, &id, netmem_to_page(netmem),
 =09=09=09       PP_DMA_INDEX_LIMIT, gfp);
@@ -507,6 +508,7 @@ static bool page_pool_dma_map(struct page_pool *pool, n=
etmem_ref netmem, gfp_t g
 =09}
=20
 =09netmem_set_dma_index(netmem, id);
+#endif
 =09page_pool_dma_sync_for_device(pool, netmem, pool->p.max_len);
=20
 =09return true;
@@ -688,6 +690,7 @@ static __always_inline void __page_pool_release_netmem_=
dma(struct page_pool *poo
 =09=09 */
 =09=09return;
=20
+#if PP_DMA_INDEX_BITS > 0
 =09id =3D netmem_get_dma_index(netmem);
 =09if (!id)
 =09=09return;
@@ -698,7 +701,7 @@ static __always_inline void __page_pool_release_netmem_=
dma(struct page_pool *poo
 =09=09old =3D xa_cmpxchg_bh(&pool->dma_mapped, id, page, NULL, 0);
 =09if (old !=3D page)
 =09=09return;
-
+#endif
 =09dma =3D page_pool_get_dma_addr_netmem(netmem);
=20
 =09/* When page is unmapped, it cannot be returned to our pool */


