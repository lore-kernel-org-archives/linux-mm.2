Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29599C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC496B00A6; Tue, 30 Jun 2026 19:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D3E6B00A8; Tue, 30 Jun 2026 19:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BC56B00A9; Tue, 30 Jun 2026 19:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 615456B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:55:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7678A011C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:55:54 +0000 (UTC)
X-FDA: 84938239428.20.CF2A4C2
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id E186A40009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:55:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z6S2hSFy;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782863752;
	b=awTM9iuPjMonBPofiP7nBS2bF/rTqVhe8ZgE3OkiWTMQVTtaEANQ2djDLZmXduCLmuHbKm
	SkhVqhLlQmMlbYWV+0suWy8TCwnNvueBMlfrE70IpPeBHF8gzjDXwGsrTZdBw9A60C1vLz
	nAOaohhLrrwJ6dC8UKpeE4JMSM08NBc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782863752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYGFmPNTsPWcLLLz5II6AmDWi4dt4jx8f/C1sSPaA9c=;
	b=KlfWvJCrT3RvuSo0zY8IrkgQuqsI3nAPQJ1OuZo/738G9aykml+J0OJ4seQg7AofuhlUDr
	81BD5TlwqOFlD6wZ+x+R5s+OyjLrzDdTmfQR/nz4vznkNMVs5Kjms7vschJA9wrduoQw+N
	QQv/tO1ptSanADXaXU1s4nWQI1WtygI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z6S2hSFy;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10ed63c0so57551cf.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:55:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782863752; cv=none;
        d=google.com; s=arc-20260327;
        b=GM9TCn4oSCaTCDjzNK37QuVmHAOtrPLC9LXrr/FQ1aj/ph0PnjD1cqtjh2mrTP6+mo
         RUygACExgx+0sbQi+hvDN2Js4SLmcb+PuJw+nWa9LSkAPBtfHZLe9CQjXB68C+QAMrFN
         GmhGeVAg6qtmlqefRor3Js0mrb87hAJfSTpeI9Zra6KJZG8Z8a+7FAPRIxraNGNuQ7ih
         G/+EQThPL7q7u1MyWQTx/dRKkV+Tt8V6sTJsf26+ZkxZ+pRsqd4wg+NXWmR8H0Q8dME3
         5dqE5ZYnIdMhHxMBZtExDqRGc8jaMmgAntTT1GJdLE8ZQ0Y6PKvRgAQEY9JsEXoUmUhp
         uWtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NYGFmPNTsPWcLLLz5II6AmDWi4dt4jx8f/C1sSPaA9c=;
        fh=+EYFAfws1TiT+NEBn69tjGugZceWf3T5CYCpqLjbYmQ=;
        b=opvPvpHsZUjJsLSQA49DCbTUxWAvBp+EXeImejROXmZllIShNvVb8ZDCTB/87wdZIY
         eLf6PcxFWta29Rbmahnjet1GXqhnGwXhGBpUJXAmzN/WiAWXd+THDfWS+odmpNGIMT24
         6luUDQ6J1HmfzuiiQyXtOrYPcUE8PmaYBP6VIWDR1pq2Zed4GXlecCap+KAbji1dPGUW
         LOsHMPZGj7k7iyaBri32KQnbuNRyJGLQyNGmAR2vuzl/0u4lPHX3x1Y2E+aUsT5jw2s4
         cfPSYn/FUftbXJ2r7CPDcyeGq7+pt0BOTtmkG9ndTcFrU4s/wZGFy7h3rdb7t8NfkO4m
         uMxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782863752; x=1783468552; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NYGFmPNTsPWcLLLz5II6AmDWi4dt4jx8f/C1sSPaA9c=;
        b=Z6S2hSFypN4wgkMZIrf7NIC92SVCJ5+D7Fuc+8jrupXbef1YAjQRc6nig2gvmrHTiN
         ZVm4DS1d+dQzTZSgf90vf1tohZ9MsN6d4l1n8oJ72szSGPbdG5nuJZug5uHODawLrpyz
         cRkwD1oDfwIDraOHl9PgzZ2vjmaiLgx+lVgGIAhovi2my+fEOjbxt3dxHu8VGlotTfuB
         BFUFtqHaiAUDyyMu5cv8SqXa1go3TO8g7+YUnuDSdM4JUu4De1YgTRoRZKu7R9q9fz4+
         1TwutPCGRr2fCP+YKl7e97R4ElG0n1evdXJC2MR3xMPNksRgah2etz2a8HhgxhV7VZX5
         b0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782863752; x=1783468552;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NYGFmPNTsPWcLLLz5II6AmDWi4dt4jx8f/C1sSPaA9c=;
        b=NIm3beBVt8ggF17l0yvQb5ptwA5Ij6vgpmUQDfZxLL+t1Y83HW2Ctmbfhw421dCfSe
         HGE03wuIApimrKPWzjo3wZzk6nnNuBjKGIBdURqs0ZOGHX3o93NZVTgBdUgJAf2N3da8
         JYXBHgA+Ke9tsEz9s/e3J7fZJjoaGaiUhLShkdj5IlfXpEvq8/tOMPOjaWTIOZy8HHrA
         DnMMr6vhRG1xsMAXLOOAtfmbkKN4RcVbnaVCIuUUv2vTwT/3vmvAcDbt+1dTxdJozwfP
         KmAxgEMgsrU+2sX9Yio+D4NThqq3cpSyakTCpOQMih1TSCp95QOXA1W07UpKuruSbAMH
         hh+g==
X-Forwarded-Encrypted: i=1; AFNElJ8mc6d/KvsEF+5e/IZFgNk6PBQVg1xNgEWGosLZJzeTX1RKo2Swxx8akkvjfqvHlKW8F0RD7HmCIw==@kvack.org
X-Gm-Message-State: AOJu0YxDL9g9J0vMYzVq/k5zmR2o9lBggPOuBMonqagAtvpLwRDrkUga
	u/gpV4GE+YdOFYsn0q+QyxGBLYXpdRHYGF5g9caxiRntVMR9gVpyhtT3bvK6XNbkkNEh1Lfq2Rl
	u3WSMx4eUJKL7xnV6sMJSyqFp8IeIox9fYGHO6T4u
X-Gm-Gg: AfdE7ckvPnjb5of/D0x7sRCM7dBqbmSNm+/ty+NAltF9oEf7EXPUPJwUwjsvSsyLHHe
	lWuqj9R4HLimz1tgU53LliEUeIP002Os91iw3AqOxMxU+95Xn8BySn4w4gWmBr19HwsSOLCkGOv
	fpz4RNuWjWdaJ1l6gz86QINyEFIOVRAgW+EKsjuA1WACLGx/cyiCeczJvhnjb4x6Ls6+lGIhIbG
	gOFLRL2y8i5Zb3exlu6//ZD9tGIsgA6oEvWQpeyR0XQanZpI9FFNaCht89qcVHp7qcOd8k=
X-Received: by 2002:a05:622a:90e:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51c2177d19emr3298091cf.16.1782863751090; Tue, 30 Jun 2026
 16:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org> <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org> <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org> <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org> <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev> <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
In-Reply-To: <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Jun 2026 16:55:39 -0700
X-Gm-Features: AVVi8CdklnwzRzdYqHyHST7ySa2NDDxRnhvnohjju3D2dp_nAGbZREeoJzxw4qk
Message-ID: <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Harry Yoo <harry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000925b27065581508b"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E186A40009
X-Rspam-User: 
X-Stat-Signature: xhzii3347j5mu7k5skxs58dc4jarwk47
X-HE-Tag: 1782863752-509500
X-HE-Meta: U2FsdGVkX19ypsVtIEfsSv6c73Mzctcm4/wNxOxznU28Cfb7U9Jne/G4KfjDlYkah3AE1hV8AYY2tG6jzHsumNZekDADV7ZXsd4j1V/dt6nKuNcloF81e9H7wcceXe+8m+klYXtQseAZvsOviqeRBFIJlozzlkXvbloRPTDxpywIgg9u0Kt0n7xJfW+La7B4/3tapH+4Ja3RVakPtFjfp51aYoGfozv9J8G7kTh+9u2bIlLme3R4xKXbe5Bgg1NKub5+V4MWFhdE4Rqa0OxOGezBdgZv//fE0WiQ+6FP+yoNTZyQpv9jFPWhXYRoBK7qnuGtjk5D8P/BMp9WrogbvNb9BygCNPAoRvHUgc10sDJDz+Q5gEXkAs0Cg5sC86Iooa4QqAlQ9zNmFhpObQ4zX41qsSMnMHK5oA/4ajqRLY7ZJFlnuzAW0nrlNgkGafQhm8gRq+ZY/JnNLIuxvHuFclmzqGYmzT2Q6HFN+JlPC4O5apH/Sr7O7xyDIiciJ1E7R44BscdF1pGGr226doT0EMteTy93qF5yM2qFelprOFR2AEwaAk2w96iElPdWX4VtyHT8s+Crr8zrO407s19yvXVelPCefmm3KRw0wT2zoppzGxslqIwrKhS6GW3uCJTTXW4hKzkQFySiHf+GbEtkaZrE/VRS0/QxxWp3Ii0jDKL04aha0gS805dYQB1dsPHe0zOlWDuhlDfAjmcO0ePrDlS8uC1e9O8LKgSLjI7EKxQgPoPlf8vn4/UVWpePWk7LgHrx7e95W3GXIDz/L9Wxqs2IiibJhauKNiq+sD+X1+g8UbMGuofyOUofcFeNQmQEU5Xds/YZ+lbq1NeUA10ClYP47pohA2UmvZqmN+DIw4xAy/jF/RjJxsHW7ez66nvnwjlcjj06l+NWFu3pCKD9RW4+0C54Y45A5Pj6YQLP+iS8yYOO1QDEgIKXth4kFNKm6gGnhfen7fOo8XBFt00
 1rz2kymL
 MQ94p5xEZkYu9ugGs1SXabE/e7hS3tgw2Q2pyIldDOQ7XOZf7G8oEAY1sL6hmwgd8zjoc1Ih/O1Q6qP1lOm76BZQi5H1O9BWzAWlwSMahhWSVg6JwSXDpF6HBHniaP8RuHvCs0dNgIOh+YKsj8QtkNqdLNz0h9/92eGDn/Vzyie3OaoNrOyal1d/nsGjilMA5d8a7nMgcPPKowg/hJE7qGskPraBosMj3CkPgywEjbijXu0Bh8puCIXbDAphsai8hlbl4ZB6seCvV1jkyYJzJYLOG8dF88jOQgDxBauiEYBi3aZZVCaCtZCMCZmkUiKIOlkJU1NIZqMBRHosSNMJSfOx/b2kouEZwD8iLC4MHRgBCUvBNisx1ftsKb0DukvABZEB+pjWLuRX1xiTVfA/3R093krXcyHVNdlbCkiAGiudCzBXLsMMHOXkxzcSAABDjEdEHp2cNBGiR5EkByBCi9a6S7nUTax8CkC8w95CnoSjpw7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000925b27065581508b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 8:27=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/30/26 11:52 PM, Suren Baghdasaryan wrote:
> > On Tue, Jun 30, 2026 at 7:36=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> >>
> >> On Tue, Jun 30, 2026 at 04:03:30PM +0900, Harry Yoo wrote:
> >>>
> >>>
> >>> On 6/30/26 3:12 PM, Vlastimil Babka (SUSE) wrote:
> >>>> On 6/30/26 07:29, Suren Baghdasaryan wrote:
> >>>>> On Mon, Jun 29, 2026 at 9:42=E2=80=AFPM Harry Yoo <harry@kernel.org=
> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
> >>>>>>> On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <suren=
b@google.com> wrote:
> >>>>>>>>
> >>>>>>
> >>>>>> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TY=
PE or
> >>>>>> SLAB_BUCKETS approach.
> >>>>>>
> >>>>>>>> Yes, it's worth backporting, so we can merge Shakeel's change as=
 is
> >>>>>>
> >>>>>> Right.
> >>>>>>
> >>>>>>>> and then once Vlastimil's patch is merged we can implement the n=
ew
> >>>>>>
> >>>>>> Vlastimil's patch has already landed mainline, by the way :)
> >>>>>
> >>>>> Nice! I suggest posting Shakeel's patch CC'ing stable for backports
> >>>>> and then following up with the fix using KMALLOC_TYPE. Vlastimil,
> >>>>> WDYT?
> >>>>
> >>>> Sounded like a plan, but then I realized I misunderstood the amount =
of the
> >>>> wastage. E.g. on my system kmalloc-8k with 4 objects per slab would =
have
> >>>> obj_ext size of 64, but now it's 16k? That's ridiculous.
> >>>
> >>> Right.
> >>
> >> Yeah I should have given more thought on wastage.
> >
> > Ugh! I didn't realize the wastage was that high.
>
> Ouch!
>
> >>> ...which is why I was assuming either the KMALLOC_TYPE or SLAB_BUCKET=
S
> >>> approach would be backported as a follow-up. Err, should have
> >>> communicated clearly, apologies.
> >>
> >> Harry, do you want to take a stab at prototyping these? If these look =
simple
> >> enough, we can request backports of this.
>
> Ack, let's see what would be the minimal changes to resolve this.
>
> > I'll also give it some thought to see if there is maybe a different
> > way to fix this that would be easy to backport.
>
> Thanks, let's discuss!

So, below patch is based on stable linux-7.1.y branch and I think it's
the simplest backportable way to fix this issue. Build-tested only, so
use just as a prototype. Not sure if making buckets parameter
unconditional from CONFIG_SLAB_BUCKETS has side-effects...

Attaching the patch as well since I'm sure gmail will butcher the tabs.

The fix for 7.2 should be much simpler using a new flag in
kmalloc_flags() for obj_ext vector allocations and serving these from
a dedicated cache.
Please let me know what you think:

---
 include/linux/slab.h | 42 +++++++++++++++++++++---------
 mm/slub.c            | 61 +++++++++++---------------------------------
 2 files changed, 45 insertions(+), 58 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..2d4a6e3064a3 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -618,6 +618,10 @@ static inline unsigned int arch_slab_minalign(void)
 #define RANDOM_KMALLOC_CACHES_NR        0
 #endif

+#if defined(CONFIG_MEM_ALLOC_PROFILING) && defined(CONFIG_SLUB_TINY)
+#define OBJ_EXT_VEC_CACHE
+#endif
+
 /*
  * Whenever changing this, take care of that kmalloc_type() and
  * create_kmalloc_caches() still work as intended.
@@ -646,6 +650,9 @@ enum kmalloc_cache_type {
 #endif
 #ifdef CONFIG_MEMCG
         KMALLOC_CGROUP,
+#endif
+#ifdef OBJ_EXT_VEC_CACHE
+        KMALLOC_OBJ_EXT_VEC,
 #endif
         NR_KMALLOC_TYPES
 };
@@ -654,6 +661,18 @@ typedef struct kmem_cache *
kmem_buckets[KMALLOC_SHIFT_HIGH + 1];

 extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];

+#ifdef OBJ_EXT_VEC_CACHE
+static inline kmem_buckets *obj_ext_vec_buckets(void)
+{
+        return &kmalloc_caches[KMALLOC_OBJ_EXT_VEC];
+}
+#else
+static inline kmem_buckets *obj_ext_vec_buckets(void)
+{
+        return NULL;
+}
+#endif
+
 /*
  * Define gfp bits that should not be set for KMALLOC_NORMAL.
  */
@@ -843,20 +862,10 @@ void *kmem_cache_alloc_from_sheaf_noprof(struct
kmem_cache *cachep, gfp_t gfp,

 unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);

-/*
- * These macros allow declaring a kmem_buckets * parameter alongside
size, which
- * can be compiled out with CONFIG_SLAB_BUCKETS=3Dn so that a large
number of call
- * sites don't have to pass NULL.
- */
-#ifdef CONFIG_SLAB_BUCKETS
+/* TODO: these macros should be removed in a prerequisite patch */
 #define DECL_BUCKET_PARAMS(_size, _b)        size_t (_size), kmem_buckets =
*(_b)
 #define PASS_BUCKET_PARAMS(_size, _b)        (_size), (_b)
 #define PASS_BUCKET_PARAM(_b)                (_b)
-#else
-#define DECL_BUCKET_PARAMS(_size, _b)        size_t (_size)
-#define PASS_BUCKET_PARAMS(_size, _b)        (_size)
-#define PASS_BUCKET_PARAM(_b)                NULL
-#endif

 /*
  * The following functions are not to be used directly and are intended on=
ly
@@ -955,7 +964,13 @@ static __always_inline __alloc_size(1) void
*kmalloc_noprof(size_t size, gfp_t f
 }
 #define kmalloc(...)
alloc_hooks(kmalloc_noprof(__VA_ARGS__))

-void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
+void *__kmalloc_nolock_noprof(size_t size, kmem_buckets *b, gfp_t
gfp_flags, int node);
+#define __kmalloc_nolock(...)
alloc_hooks(__kmalloc_nolock_noprof(__VA_ARGS__))
+
+static __always_inline void *kmalloc_nolock_noprof(size_t size, gfp_t
gfp_flags, int node)
+{
+        return __kmalloc_nolock_noprof(size, NULL, gfp_flags, node);
+}
 #define kmalloc_nolock(...)
alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))

 /**
@@ -1062,6 +1077,9 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t
gfp_flags, int node);
 #define kmem_buckets_alloc(_b, _size, _flags)        \
         alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size,
_b), _flags, NUMA_NO_NODE))

+#define kmem_buckets_node_alloc(_size, _b, _flags, _node)        \
+        alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size,
_b), _flags, _node))
+
 #define kmem_buckets_alloc_track_caller(_b, _size, _flags)        \
         alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(=
_size,
_b), _flags, NUMA_NO_NODE, _RET_IP_))

diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..c59d9ee4f4f3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2106,42 +2106,6 @@ static inline void init_slab_obj_exts(struct slab *s=
lab)
         slab->obj_exts =3D 0;
 }

-/*
- * Calculate the allocation size for slabobj_ext array.
- *
- * When memory allocation profiling is enabled, the obj_exts array
- * could be allocated from the same slab cache it's being allocated for.
- * This would prevent the slab from ever being freed because it would
- * always contain at least one allocated object (its own obj_exts array).
- *
- * To avoid this, increase the allocation size when we detect the array
- * may come from the same cache, forcing it to use a different cache.
- */
-static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
-                                         struct slab *slab, gfp_t gfp)
-{
-        size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
-        struct kmem_cache *obj_exts_cache;
-
-        if (sz > KMALLOC_MAX_CACHE_SIZE)
-                return sz;
-
-        if (!is_kmalloc_normal(s))
-                return sz;
-
-        obj_exts_cache =3D kmalloc_slab(sz, NULL, gfp, 0);
-        /*
-         * We can't simply compare s with obj_exts_cache, because
random kmalloc
-         * caches have multiple caches per size, selected by caller addres=
s.
-         * Since caller address may differ between kmalloc_slab() and actu=
al
-         * allocation, bump size when sizes are equal.
-         */
-        if (s->object_size =3D=3D obj_exts_cache->object_size)
-                return obj_exts_cache->object_size + 1;
-
-        return sz;
-}
-
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
                         gfp_t gfp, bool new_slab)
 {
@@ -2156,19 +2120,23 @@ int alloc_slab_obj_exts(struct slab *slab,
struct kmem_cache *s,
         /* Prevent recursive extension vector allocation */
         gfp |=3D __GFP_NO_OBJ_EXT;

-        sz =3D obj_exts_alloc_size(s, slab, gfp);
-
+        sz =3D sizeof(struct slabobj_ext) * slab->objects;
         /*
          * Note that allow_spin may be false during early boot and its
          * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporti=
ng
          * architectures with cmpxchg16b, early obj_exts will be missing f=
or
          * very early allocations on those.
          */
-        if (unlikely(!allow_spin))
-                vec =3D kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
-                                     slab_nid(slab));
-        else
-                vec =3D kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab))=
;
+        if (unlikely(!allow_spin)) {
+                vec =3D __kmalloc_nolock(sz, obj_ext_vec_buckets(),
+                                       __GFP_ZERO | __GFP_NO_OBJ_EXT,
slab_nid(slab));
+        } else {
+                if (sz > KMALLOC_MAX_CACHE_SIZE)
+                        vec =3D  kmalloc_node(sz, gfp | __GFP_ZERO,
slab_nid(slab));
+                else
+                        vec =3D kmem_buckets_node_alloc(sz,
obj_ext_vec_buckets(),
+                                                      gfp |
__GFP_ZERO, slab_nid(slab));
+        }

         if (!vec) {
                 /*
@@ -5311,6 +5279,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);

 /**
  * kmalloc_nolock - Allocate an object of given size from any context.
+ * @b: kmem_cach bucket
  * @size: size to allocate
  * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
  * allowed.
@@ -5320,7 +5289,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
  * NULL does not mean EBUSY or EAGAIN. It means ENOMEM.
  * There is no reason to call it again and expect !NULL.
  */
-void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
+void *__kmalloc_nolock_noprof(size_t size, kmem_buckets *b, gfp_t
gfp_flags, int node)
 {
         gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
         struct kmem_cache *s;
@@ -5347,7 +5316,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t
gfp_flags, int node)
 retry:
         if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
                 return NULL;
-        s =3D kmalloc_slab(size, NULL, alloc_gfp, _RET_IP_);
+        s =3D kmalloc_slab(size, b, alloc_gfp, _RET_IP_);

         if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
                 /*
@@ -5400,7 +5369,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t
gfp_flags, int node)
         ret =3D kasan_kmalloc(s, ret, size, alloc_gfp);
         return ret;
 }
-EXPORT_SYMBOL_GPL(kmalloc_nolock_noprof);
+EXPORT_SYMBOL_GPL(__kmalloc_nolock_noprof);

 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b),
gfp_t flags,
                                          int node, unsigned long caller)

--




>
> >>>> We could say it's for a debugging feature, but also it's running in
> >>>> production fleets (and Android?), so probably not that easy to dismi=
ss.
> >>>
> >>> I think a key factor is when it's enabled in production.
> >>>
> >>> kconfigs says Android selects MEM_ALLOC_PROFILING, but not
> >>> MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
> >>>
> >>> I assumed that turning it on by default in the entire fleet
> >>> would be bit hard to justify... (please correct me,
> >>> if it's not the case)
> >>
> >> Actually we have memory profiling enabled by default across Meta fleet=
. So, the
> >> issue is very real.
>
> I see, thanks for clarifying.
>
> >> At the moment, we are seeing this issue on a specific
> >> type of machine and we have disabled memory profiling for those machin=
es.
> >> Internally we did discuss to simply disable memory allocation profilin=
g for
> >> kmalloc-normal caches but to me that was a big hammer and thus suggest=
ed the
> >> current approach.
>
> --
> Cheers,
> Harry / Hyeonggon

--000000000000925b27065581508b
Content-Type: application/x-patch; 
	name="0001-prototype-for-a-fix-to-the-circular-allocation-issue.patch"
Content-Disposition: attachment; 
	filename="0001-prototype-for-a-fix-to-the-circular-allocation-issue.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mr1b168c0>
X-Attachment-Id: f_mr1b168c0

RnJvbSA3MzRiYmRlODQ1ODkwZmQyNzg4ZTBmOGM0NGU0YTc5ZmJmZTBjODAzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdXJlbiBCYWdoZGFzYXJ5YW4gPHN1cmVuYkBnb29nbGUuY29t
PgpEYXRlOiBUdWUsIDMwIEp1biAyMDI2IDEzOjA0OjAyIC0wNzAwClN1YmplY3Q6IFtQQVRDSCAx
LzFdIHByb3RvdHlwZSBmb3IgYSBmaXggdG8gdGhlIGNpcmN1bGFyIGFsbG9jYXRpb24gaXNzdWUg
ZnJvbQogWzFdCgpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwNjI1MjMwMDI5
LjcwMzc1MC0xLXNoYWtlZWwuYnV0dEBsaW51eC5kZXYvCgpTaWduZWQtb2ZmLWJ5OiBTdXJlbiBC
YWdoZGFzYXJ5YW4gPHN1cmVuYkBnb29nbGUuY29tPgotLS0KIGluY2x1ZGUvbGludXgvc2xhYi5o
IHwgNDIgKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tCiBtbS9zbHViLmMgICAgICAgICAg
ICB8IDYxICsrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAyIGZp
bGVzIGNoYW5nZWQsIDQ1IGluc2VydGlvbnMoKyksIDU4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvc2xhYi5oIGIvaW5jbHVkZS9saW51eC9zbGFiLmgKaW5kZXggMmI1
YWI0ODhlOTZiLi4yZDRhNmUzMDY0YTMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc2xhYi5o
CisrKyBiL2luY2x1ZGUvbGludXgvc2xhYi5oCkBAIC02MTgsNiArNjE4LDEwIEBAIHN0YXRpYyBp
bmxpbmUgdW5zaWduZWQgaW50IGFyY2hfc2xhYl9taW5hbGlnbih2b2lkKQogI2RlZmluZSBSQU5E
T01fS01BTExPQ19DQUNIRVNfTlIJMAogI2VuZGlmCiAKKyNpZiBkZWZpbmVkKENPTkZJR19NRU1f
QUxMT0NfUFJPRklMSU5HKSAmJiBkZWZpbmVkKENPTkZJR19TTFVCX1RJTlkpCisjZGVmaW5lIE9C
Sl9FWFRfVkVDX0NBQ0hFCisjZW5kaWYKKwogLyoKICAqIFdoZW5ldmVyIGNoYW5naW5nIHRoaXMs
IHRha2UgY2FyZSBvZiB0aGF0IGttYWxsb2NfdHlwZSgpIGFuZAogICogY3JlYXRlX2ttYWxsb2Nf
Y2FjaGVzKCkgc3RpbGwgd29yayBhcyBpbnRlbmRlZC4KQEAgLTY0Niw2ICs2NTAsOSBAQCBlbnVt
IGttYWxsb2NfY2FjaGVfdHlwZSB7CiAjZW5kaWYKICNpZmRlZiBDT05GSUdfTUVNQ0cKIAlLTUFM
TE9DX0NHUk9VUCwKKyNlbmRpZgorI2lmZGVmIE9CSl9FWFRfVkVDX0NBQ0hFCisJS01BTExPQ19P
QkpfRVhUX1ZFQywKICNlbmRpZgogCU5SX0tNQUxMT0NfVFlQRVMKIH07CkBAIC02NTQsNiArNjYx
LDE4IEBAIHR5cGVkZWYgc3RydWN0IGttZW1fY2FjaGUgKiBrbWVtX2J1Y2tldHNbS01BTExPQ19T
SElGVF9ISUdIICsgMV07CiAKIGV4dGVybiBrbWVtX2J1Y2tldHMga21hbGxvY19jYWNoZXNbTlJf
S01BTExPQ19UWVBFU107CiAKKyNpZmRlZiBPQkpfRVhUX1ZFQ19DQUNIRQorc3RhdGljIGlubGlu
ZSBrbWVtX2J1Y2tldHMgKm9ial9leHRfdmVjX2J1Y2tldHModm9pZCkKK3sKKwlyZXR1cm4gJmtt
YWxsb2NfY2FjaGVzW0tNQUxMT0NfT0JKX0VYVF9WRUNdOworfQorI2Vsc2UKK3N0YXRpYyBpbmxp
bmUga21lbV9idWNrZXRzICpvYmpfZXh0X3ZlY19idWNrZXRzKHZvaWQpCit7CisJcmV0dXJuIE5V
TEw7Cit9CisjZW5kaWYKKwogLyoKICAqIERlZmluZSBnZnAgYml0cyB0aGF0IHNob3VsZCBub3Qg
YmUgc2V0IGZvciBLTUFMTE9DX05PUk1BTC4KICAqLwpAQCAtODQzLDIwICs4NjIsMTAgQEAgdm9p
ZCAqa21lbV9jYWNoZV9hbGxvY19mcm9tX3NoZWFmX25vcHJvZihzdHJ1Y3Qga21lbV9jYWNoZSAq
Y2FjaGVwLCBnZnBfdCBnZnAsCiAKIHVuc2lnbmVkIGludCBrbWVtX2NhY2hlX3NoZWFmX3NpemUo
c3RydWN0IHNsYWJfc2hlYWYgKnNoZWFmKTsKIAotLyoKLSAqIFRoZXNlIG1hY3JvcyBhbGxvdyBk
ZWNsYXJpbmcgYSBrbWVtX2J1Y2tldHMgKiBwYXJhbWV0ZXIgYWxvbmdzaWRlIHNpemUsIHdoaWNo
Ci0gKiBjYW4gYmUgY29tcGlsZWQgb3V0IHdpdGggQ09ORklHX1NMQUJfQlVDS0VUUz1uIHNvIHRo
YXQgYSBsYXJnZSBudW1iZXIgb2YgY2FsbAotICogc2l0ZXMgZG9uJ3QgaGF2ZSB0byBwYXNzIE5V
TEwuCi0gKi8KLSNpZmRlZiBDT05GSUdfU0xBQl9CVUNLRVRTCisvKiBUT0RPOiB0aGVzZSBtYWNy
b3Mgc2hvdWxkIGJlIHJlbW92ZWQgaW4gYSBwcmVyZXF1aXNpdGUgcGF0Y2ggKi8KICNkZWZpbmUg
REVDTF9CVUNLRVRfUEFSQU1TKF9zaXplLCBfYikJc2l6ZV90IChfc2l6ZSksIGttZW1fYnVja2V0
cyAqKF9iKQogI2RlZmluZSBQQVNTX0JVQ0tFVF9QQVJBTVMoX3NpemUsIF9iKQkoX3NpemUpLCAo
X2IpCiAjZGVmaW5lIFBBU1NfQlVDS0VUX1BBUkFNKF9iKQkJKF9iKQotI2Vsc2UKLSNkZWZpbmUg
REVDTF9CVUNLRVRfUEFSQU1TKF9zaXplLCBfYikJc2l6ZV90IChfc2l6ZSkKLSNkZWZpbmUgUEFT
U19CVUNLRVRfUEFSQU1TKF9zaXplLCBfYikJKF9zaXplKQotI2RlZmluZSBQQVNTX0JVQ0tFVF9Q
QVJBTShfYikJCU5VTEwKLSNlbmRpZgogCiAvKgogICogVGhlIGZvbGxvd2luZyBmdW5jdGlvbnMg
YXJlIG5vdCB0byBiZSB1c2VkIGRpcmVjdGx5IGFuZCBhcmUgaW50ZW5kZWQgb25seQpAQCAtOTU1
LDcgKzk2NCwxMyBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIF9fYWxsb2Nfc2l6ZSgxKSB2b2lk
ICprbWFsbG9jX25vcHJvZihzaXplX3Qgc2l6ZSwgZ2ZwX3QgZgogfQogI2RlZmluZSBrbWFsbG9j
KC4uLikJCQkJYWxsb2NfaG9va3Moa21hbGxvY19ub3Byb2YoX19WQV9BUkdTX18pKQogCi12b2lk
ICprbWFsbG9jX25vbG9ja19ub3Byb2Yoc2l6ZV90IHNpemUsIGdmcF90IGdmcF9mbGFncywgaW50
IG5vZGUpOwordm9pZCAqX19rbWFsbG9jX25vbG9ja19ub3Byb2Yoc2l6ZV90IHNpemUsIGttZW1f
YnVja2V0cyAqYiwgZ2ZwX3QgZ2ZwX2ZsYWdzLCBpbnQgbm9kZSk7CisjZGVmaW5lIF9fa21hbGxv
Y19ub2xvY2soLi4uKQkJCWFsbG9jX2hvb2tzKF9fa21hbGxvY19ub2xvY2tfbm9wcm9mKF9fVkFf
QVJHU19fKSkKKworc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkICprbWFsbG9jX25vbG9ja19u
b3Byb2Yoc2l6ZV90IHNpemUsIGdmcF90IGdmcF9mbGFncywgaW50IG5vZGUpCit7CisJcmV0dXJu
IF9fa21hbGxvY19ub2xvY2tfbm9wcm9mKHNpemUsIE5VTEwsIGdmcF9mbGFncywgbm9kZSk7Cit9
CiAjZGVmaW5lIGttYWxsb2Nfbm9sb2NrKC4uLikJCQlhbGxvY19ob29rcyhrbWFsbG9jX25vbG9j
a19ub3Byb2YoX19WQV9BUkdTX18pKQogCiAvKioKQEAgLTEwNjIsNiArMTA3Nyw5IEBAIHZvaWQg
KmttYWxsb2Nfbm9sb2NrX25vcHJvZihzaXplX3Qgc2l6ZSwgZ2ZwX3QgZ2ZwX2ZsYWdzLCBpbnQg
bm9kZSk7CiAjZGVmaW5lIGttZW1fYnVja2V0c19hbGxvYyhfYiwgX3NpemUsIF9mbGFncykJXAog
CWFsbG9jX2hvb2tzKF9fa21hbGxvY19ub2RlX25vcHJvZihQQVNTX0JVQ0tFVF9QQVJBTVMoX3Np
emUsIF9iKSwgX2ZsYWdzLCBOVU1BX05PX05PREUpKQogCisjZGVmaW5lIGttZW1fYnVja2V0c19u
b2RlX2FsbG9jKF9zaXplLCBfYiwgX2ZsYWdzLCBfbm9kZSkJXAorCWFsbG9jX2hvb2tzKF9fa21h
bGxvY19ub2RlX25vcHJvZihQQVNTX0JVQ0tFVF9QQVJBTVMoX3NpemUsIF9iKSwgX2ZsYWdzLCBf
bm9kZSkpCisKICNkZWZpbmUga21lbV9idWNrZXRzX2FsbG9jX3RyYWNrX2NhbGxlcihfYiwgX3Np
emUsIF9mbGFncykJXAogCWFsbG9jX2hvb2tzKF9fa21hbGxvY19ub2RlX3RyYWNrX2NhbGxlcl9u
b3Byb2YoUEFTU19CVUNLRVRfUEFSQU1TKF9zaXplLCBfYiksIF9mbGFncywgTlVNQV9OT19OT0RF
LCBfUkVUX0lQXykpCiAKZGlmZiAtLWdpdCBhL21tL3NsdWIuYyBiL21tL3NsdWIuYwppbmRleCBh
MmJmMzc1NmNhN2QuLmM1OWQ5ZWU0ZjRmMyAxMDA2NDQKLS0tIGEvbW0vc2x1Yi5jCisrKyBiL21t
L3NsdWIuYwpAQCAtMjEwNiw0MiArMjEwNiw2IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBpbml0X3Ns
YWJfb2JqX2V4dHMoc3RydWN0IHNsYWIgKnNsYWIpCiAJc2xhYi0+b2JqX2V4dHMgPSAwOwogfQog
Ci0vKgotICogQ2FsY3VsYXRlIHRoZSBhbGxvY2F0aW9uIHNpemUgZm9yIHNsYWJvYmpfZXh0IGFy
cmF5LgotICoKLSAqIFdoZW4gbWVtb3J5IGFsbG9jYXRpb24gcHJvZmlsaW5nIGlzIGVuYWJsZWQs
IHRoZSBvYmpfZXh0cyBhcnJheQotICogY291bGQgYmUgYWxsb2NhdGVkIGZyb20gdGhlIHNhbWUg
c2xhYiBjYWNoZSBpdCdzIGJlaW5nIGFsbG9jYXRlZCBmb3IuCi0gKiBUaGlzIHdvdWxkIHByZXZl
bnQgdGhlIHNsYWIgZnJvbSBldmVyIGJlaW5nIGZyZWVkIGJlY2F1c2UgaXQgd291bGQKLSAqIGFs
d2F5cyBjb250YWluIGF0IGxlYXN0IG9uZSBhbGxvY2F0ZWQgb2JqZWN0IChpdHMgb3duIG9ial9l
eHRzIGFycmF5KS4KLSAqCi0gKiBUbyBhdm9pZCB0aGlzLCBpbmNyZWFzZSB0aGUgYWxsb2NhdGlv
biBzaXplIHdoZW4gd2UgZGV0ZWN0IHRoZSBhcnJheQotICogbWF5IGNvbWUgZnJvbSB0aGUgc2Ft
ZSBjYWNoZSwgZm9yY2luZyBpdCB0byB1c2UgYSBkaWZmZXJlbnQgY2FjaGUuCi0gKi8KLXN0YXRp
YyBpbmxpbmUgc2l6ZV90IG9ial9leHRzX2FsbG9jX3NpemUoc3RydWN0IGttZW1fY2FjaGUgKnMs
Ci0JCQkJCSBzdHJ1Y3Qgc2xhYiAqc2xhYiwgZ2ZwX3QgZ2ZwKQotewotCXNpemVfdCBzeiA9IHNp
emVvZihzdHJ1Y3Qgc2xhYm9ial9leHQpICogc2xhYi0+b2JqZWN0czsKLQlzdHJ1Y3Qga21lbV9j
YWNoZSAqb2JqX2V4dHNfY2FjaGU7Ci0KLQlpZiAoc3ogPiBLTUFMTE9DX01BWF9DQUNIRV9TSVpF
KQotCQlyZXR1cm4gc3o7Ci0KLQlpZiAoIWlzX2ttYWxsb2Nfbm9ybWFsKHMpKQotCQlyZXR1cm4g
c3o7Ci0KLQlvYmpfZXh0c19jYWNoZSA9IGttYWxsb2Nfc2xhYihzeiwgTlVMTCwgZ2ZwLCAwKTsK
LQkvKgotCSAqIFdlIGNhbid0IHNpbXBseSBjb21wYXJlIHMgd2l0aCBvYmpfZXh0c19jYWNoZSwg
YmVjYXVzZSByYW5kb20ga21hbGxvYwotCSAqIGNhY2hlcyBoYXZlIG11bHRpcGxlIGNhY2hlcyBw
ZXIgc2l6ZSwgc2VsZWN0ZWQgYnkgY2FsbGVyIGFkZHJlc3MuCi0JICogU2luY2UgY2FsbGVyIGFk
ZHJlc3MgbWF5IGRpZmZlciBiZXR3ZWVuIGttYWxsb2Nfc2xhYigpIGFuZCBhY3R1YWwKLQkgKiBh
bGxvY2F0aW9uLCBidW1wIHNpemUgd2hlbiBzaXplcyBhcmUgZXF1YWwuCi0JICovCi0JaWYgKHMt
Pm9iamVjdF9zaXplID09IG9ial9leHRzX2NhY2hlLT5vYmplY3Rfc2l6ZSkKLQkJcmV0dXJuIG9i
al9leHRzX2NhY2hlLT5vYmplY3Rfc2l6ZSArIDE7Ci0KLQlyZXR1cm4gc3o7Ci19Ci0KIGludCBh
bGxvY19zbGFiX29ial9leHRzKHN0cnVjdCBzbGFiICpzbGFiLCBzdHJ1Y3Qga21lbV9jYWNoZSAq
cywKIAkJICAgICAgICBnZnBfdCBnZnAsIGJvb2wgbmV3X3NsYWIpCiB7CkBAIC0yMTU2LDE5ICsy
MTIwLDIzIEBAIGludCBhbGxvY19zbGFiX29ial9leHRzKHN0cnVjdCBzbGFiICpzbGFiLCBzdHJ1
Y3Qga21lbV9jYWNoZSAqcywKIAkvKiBQcmV2ZW50IHJlY3Vyc2l2ZSBleHRlbnNpb24gdmVjdG9y
IGFsbG9jYXRpb24gKi8KIAlnZnAgfD0gX19HRlBfTk9fT0JKX0VYVDsKIAotCXN6ID0gb2JqX2V4
dHNfYWxsb2Nfc2l6ZShzLCBzbGFiLCBnZnApOwotCisJc3ogPSBzaXplb2Yoc3RydWN0IHNsYWJv
YmpfZXh0KSAqIHNsYWItPm9iamVjdHM7CiAJLyoKIAkgKiBOb3RlIHRoYXQgYWxsb3dfc3BpbiBt
YXkgYmUgZmFsc2UgZHVyaW5nIGVhcmx5IGJvb3QgYW5kIGl0cwogCSAqIHJlc3RyaWN0ZWQgR0ZQ
X0JPT1RfTUFTSy4gRHVlIHRvIGttYWxsb2Nfbm9sb2NrKCkgb25seSBzdXBwb3J0aW5nCiAJICog
YXJjaGl0ZWN0dXJlcyB3aXRoIGNtcHhjaGcxNmIsIGVhcmx5IG9ial9leHRzIHdpbGwgYmUgbWlz
c2luZyBmb3IKIAkgKiB2ZXJ5IGVhcmx5IGFsbG9jYXRpb25zIG9uIHRob3NlLgogCSAqLwotCWlm
ICh1bmxpa2VseSghYWxsb3dfc3BpbikpCi0JCXZlYyA9IGttYWxsb2Nfbm9sb2NrKHN6LCBfX0dG
UF9aRVJPIHwgX19HRlBfTk9fT0JKX0VYVCwKLQkJCQkgICAgIHNsYWJfbmlkKHNsYWIpKTsKLQll
bHNlCi0JCXZlYyA9IGttYWxsb2Nfbm9kZShzeiwgZ2ZwIHwgX19HRlBfWkVSTywgc2xhYl9uaWQo
c2xhYikpOworCWlmICh1bmxpa2VseSghYWxsb3dfc3BpbikpIHsKKwkJdmVjID0gX19rbWFsbG9j
X25vbG9jayhzeiwgb2JqX2V4dF92ZWNfYnVja2V0cygpLAorCQkJCSAgICAgICBfX0dGUF9aRVJP
IHwgX19HRlBfTk9fT0JKX0VYVCwgc2xhYl9uaWQoc2xhYikpOworCX0gZWxzZSB7CisJCWlmIChz
eiA+IEtNQUxMT0NfTUFYX0NBQ0hFX1NJWkUpCisJCQl2ZWMgPSAga21hbGxvY19ub2RlKHN6LCBn
ZnAgfCBfX0dGUF9aRVJPLCBzbGFiX25pZChzbGFiKSk7CisJCWVsc2UKKwkJCXZlYyA9IGttZW1f
YnVja2V0c19ub2RlX2FsbG9jKHN6LCBvYmpfZXh0X3ZlY19idWNrZXRzKCksCisJCQkJCQkgICAg
ICBnZnAgfCBfX0dGUF9aRVJPLCBzbGFiX25pZChzbGFiKSk7CisJfQogCiAJaWYgKCF2ZWMpIHsK
IAkJLyoKQEAgLTUzMTEsNiArNTI3OSw3IEBAIEVYUE9SVF9TWU1CT0woX19rbWFsbG9jX25vcHJv
Zik7CiAKIC8qKgogICoga21hbGxvY19ub2xvY2sgLSBBbGxvY2F0ZSBhbiBvYmplY3Qgb2YgZ2l2
ZW4gc2l6ZSBmcm9tIGFueSBjb250ZXh0LgorICogQGI6IGttZW1fY2FjaCBidWNrZXQKICAqIEBz
aXplOiBzaXplIHRvIGFsbG9jYXRlCiAgKiBAZ2ZwX2ZsYWdzOiBHRlAgZmxhZ3MuIE9ubHkgX19H
RlBfQUNDT1VOVCwgX19HRlBfWkVSTywgX19HRlBfTk9fT0JKX0VYVAogICogYWxsb3dlZC4KQEAg
LTUzMjAsNyArNTI4OSw3IEBAIEVYUE9SVF9TWU1CT0woX19rbWFsbG9jX25vcHJvZik7CiAgKiBO
VUxMIGRvZXMgbm90IG1lYW4gRUJVU1kgb3IgRUFHQUlOLiBJdCBtZWFucyBFTk9NRU0uCiAgKiBU
aGVyZSBpcyBubyByZWFzb24gdG8gY2FsbCBpdCBhZ2FpbiBhbmQgZXhwZWN0ICFOVUxMLgogICov
Ci12b2lkICprbWFsbG9jX25vbG9ja19ub3Byb2Yoc2l6ZV90IHNpemUsIGdmcF90IGdmcF9mbGFn
cywgaW50IG5vZGUpCit2b2lkICpfX2ttYWxsb2Nfbm9sb2NrX25vcHJvZihzaXplX3Qgc2l6ZSwg
a21lbV9idWNrZXRzICpiLCBnZnBfdCBnZnBfZmxhZ3MsIGludCBub2RlKQogewogCWdmcF90IGFs
bG9jX2dmcCA9IF9fR0ZQX05PV0FSTiB8IF9fR0ZQX05PTUVNQUxMT0MgfCBnZnBfZmxhZ3M7CiAJ
c3RydWN0IGttZW1fY2FjaGUgKnM7CkBAIC01MzQ3LDcgKzUzMTYsNyBAQCB2b2lkICprbWFsbG9j
X25vbG9ja19ub3Byb2Yoc2l6ZV90IHNpemUsIGdmcF90IGdmcF9mbGFncywgaW50IG5vZGUpCiBy
ZXRyeToKIAlpZiAodW5saWtlbHkoc2l6ZSA+IEtNQUxMT0NfTUFYX0NBQ0hFX1NJWkUpKQogCQly
ZXR1cm4gTlVMTDsKLQlzID0ga21hbGxvY19zbGFiKHNpemUsIE5VTEwsIGFsbG9jX2dmcCwgX1JF
VF9JUF8pOworCXMgPSBrbWFsbG9jX3NsYWIoc2l6ZSwgYiwgYWxsb2NfZ2ZwLCBfUkVUX0lQXyk7
CiAKIAlpZiAoIShzLT5mbGFncyAmIF9fQ01QWENIR19ET1VCTEUpICYmICFrbWVtX2NhY2hlX2Rl
YnVnKHMpKQogCQkvKgpAQCAtNTQwMCw3ICs1MzY5LDcgQEAgdm9pZCAqa21hbGxvY19ub2xvY2tf
bm9wcm9mKHNpemVfdCBzaXplLCBnZnBfdCBnZnBfZmxhZ3MsIGludCBub2RlKQogCXJldCA9IGth
c2FuX2ttYWxsb2MocywgcmV0LCBzaXplLCBhbGxvY19nZnApOwogCXJldHVybiByZXQ7CiB9Ci1F
WFBPUlRfU1lNQk9MX0dQTChrbWFsbG9jX25vbG9ja19ub3Byb2YpOworRVhQT1JUX1NZTUJPTF9H
UEwoX19rbWFsbG9jX25vbG9ja19ub3Byb2YpOwogCiB2b2lkICpfX2ttYWxsb2Nfbm9kZV90cmFj
a19jYWxsZXJfbm9wcm9mKERFQ0xfQlVDS0VUX1BBUkFNUyhzaXplLCBiKSwgZ2ZwX3QgZmxhZ3Ms
CiAJCQkJCSBpbnQgbm9kZSwgdW5zaWduZWQgbG9uZyBjYWxsZXIpCi0tIAoyLjU1LjAucmMwLjc5
OS5nZDZmOTRlZDU5My1nb29nCgo=
--000000000000925b27065581508b--

