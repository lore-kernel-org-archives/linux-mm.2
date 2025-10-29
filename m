Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF9ECCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A688C8E001F; Tue, 28 Oct 2025 21:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A18F88E0015; Tue, 28 Oct 2025 21:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955CC8E001F; Tue, 28 Oct 2025 21:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 838368E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:28:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2BBE13B7AC
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:28:17 +0000 (UTC)
X-FDA: 84049416234.14.EA2B014
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0046C180002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:28:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dknrR5IO;
	spf=pass (imf24.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761701296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkMWjO1rSdAnohkJyNyWXb5OhMJ5uqLxrhrL1OkZrHQ=;
	b=Tjd1AGEfuXaWeHP4E9NTZjpXAtECmLP/ZMeGlDLGfkQSjHuenbNNdEACw5SReeV9J0XKYF
	Q/1pAj1vQ6ZF6p6LYcpxfrvj7vcEnGCPdNmANkFnmceMPE26Dcoz/W7IYkwcR0kjT4J/m4
	LgtpCK0egTuQSZI3UFFfJ11CNA/HOgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761701296; a=rsa-sha256;
	cv=none;
	b=bqKfueJkRS4TWju/MouXIA+J/aEhPeDe84MHGtuXsv8c6M39dY6raDB+NYJksemER4S4Cy
	LCqj6Ob9e0vcLADkPzLzQ0RH4awdmys0U2jOWQd7clXx6mmji1FhTGHcZloaqstEukpA72
	G9HznQYhvqpbTp+z7q5vB4E0eHyRAv0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dknrR5IO;
	spf=pass (imf24.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so66178705e9.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761701294; x=1762306094; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FkMWjO1rSdAnohkJyNyWXb5OhMJ5uqLxrhrL1OkZrHQ=;
        b=dknrR5IOUZKc1W6ma7QLWHVz3jNoxIlDJINuPrhgctkIswVnC20EDuwfSMTW5X8kOr
         YcJBD8E0Z6KSfwdr2xAPGcsA9OZXR0849XMQ1XxTf+mGA4mEXWX/bwhD8gutvhCnAKPd
         5Z5bYcF8I5CuuGCmwGHkACIphr64Jw+LFQHMoeTrnVn8dNnxmwXiJmHuSiH+QbDgaFCo
         pcVrGP6l4DdvHP/+TqAf4dLy54phoBExxOXsFAdYA6Ywh9PJMAVSt1eAi4zOmk2dEIgZ
         SmFNJaLshEZKizwUH993GR+L7vhgWu3qk4JutyubK9E/H8xSjvHcaB1fROfiEVOpYpXc
         cRtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761701294; x=1762306094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkMWjO1rSdAnohkJyNyWXb5OhMJ5uqLxrhrL1OkZrHQ=;
        b=Tqa/gW54lzKZizHN/0uhmq431WggxxhIvbeLRN4FzFZaFhq483yL56C4IzTL5vtUq1
         68MKO1FvDueqMB5wiHeZhnuFD9KWfJUCIRQ2QRNonHbWQWFFS9L8nYcc1IrzAQHaq5/d
         GZTjkp/YQDU/QlWzT3lHt8uKK0EuwZ0geWO3C0+0dhQUUHb9SQVU7onOV+PBQ8CeSO12
         VYgHDYylZ3TYMuHWcLIqx5xEc9tTd7jcG6oLCELs7JG0lX9Z5HLifuYBjCwJ1uc3YHW3
         R4Yu9idVhOyLVd9VRllzMG0W3i8AF2OSNmNYZEgbc1kA6nFXPM4TH+E2xQhEfYkm/ul5
         eCZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqT3NZaSBe45XqQta50cRp61hFTxZ0ObREDx7TZdvMqvGsAckdG4bfuaQhXoUYJe2nKfLpGAPjng==@kvack.org
X-Gm-Message-State: AOJu0YwDgMNmWyobtoLWAbYRHSWqZyeJGUIJhk6CEmPZr5il0G1X+CIe
	XYITEjDaGawM3+rnUwcX1GmSppm5OATyitOIHniSVhVXUtT6AXPiXTDOzYhG7FSg9H7zw8gR0NX
	mFiGLtwsmqSqeTC0zhOspD3Llal1vdRyScyBUqqe3
X-Gm-Gg: ASbGncvf99NTirXWazJaWobms8/kf0USHuME6YhxF46xCau3fPKrWLF8L3d2AsAtYUF
	p2WWuFh809EWeJHyFHSV5JGzRJ2v+p1gxlpTMKWpUMg8D/Un+XG2tXXcp+JR6M65EJDZC4TjPHz
	qCvTbAZCtQXhcNIyJu2d4svwXED6n3OqawNXK/4nQRxO8D23aEUa+bSeEThyefiEoXIfTQOv2pY
	AMc8DKjC1xYQcsRHt7ki2VymaxFjJ5O3gkI4C+tNOkrzkqVySgURgAAWDYVUXmdcVi5bj826t9k
	CkcKipq33gW5zvs=
X-Google-Smtp-Source: AGHT+IG3KRiPIoob60XGXfb5m+5xbP/GP4YmXgJstFq9lCOwlcC3zoZDZB5x16vG8VyFsQPcmth6oAyMlVZsee0e+BM=
X-Received: by 2002:a05:600c:6384:b0:475:e007:baf2 with SMTP id
 5b1f17b1804b1-4771e1f5a1fmr8930625e9.41.1761701294081; Tue, 28 Oct 2025
 18:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com> <20251020100306.2709352-2-jasonmiu@google.com>
 <20251023174317.GO262900@nvidia.com>
In-Reply-To: <20251023174317.GO262900@nvidia.com>
From: Jason Miu <jasonmiu@google.com>
Date: Tue, 28 Oct 2025 18:28:02 -0700
X-Gm-Features: AWmQ_blKKmsXCeIJmd0P-TrVuYl0Tfsj5kSCFLMW2X0j-f70Ldi62zWKU78x_VA
Message-ID: <CAHN2nPKbxM5Bc9SDHHyvHbUPvsatMa6W59tXuVwfytxF7v+DRg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kho: Adopt KHO radix tree data structures
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: xc3zkzj3mf7x9cnwqbayujzwn9m5wupn
X-Rspam-User: 
X-Rspamd-Queue-Id: 0046C180002
X-HE-Tag: 1761701295-563120
X-HE-Meta: U2FsdGVkX19m/PRk6KVOEG76qM4eKi4yIia/0VSVO78QypNUYWc4pQx9qQJr9+fwDeNdlCgMc5OH4O0VwzgHP7eMwBCCzqf2+hi0EVcV5g4e0CFDdSveOEBmc0mcpu+cJTweK7/tyuQ40JY4aPAIhpqTlMtoYA+jJONwLy6thv+12jWjBJsPX1ukt/JX6/mqrg3NehR6GHxzK5n/4xtq5b/iglqQ7qQVX0K21t7d6yx7n1NvyjlS/BJ1iQFlRQaQKnNe5jwAVLUJkDR909TlkvCEnKdtAQ1fQaucWa7u3soffI1+l5gHeolP1lhiDRh1a4x02/h48sArU+lMX/XMIBF8gZtZ9eaerWi8qP6B780n7guKnmr7veirg/Y/siDRZ2p1r7txFjCDzb19QrwmeytMzfzzKJ3evchonFtNUFXH6QKMRfbdOptwnEZft38BfpGPRnPvfvmUIZ3T+B7m/BFwpmhfIJZubvj+81GdT4u5GWod3LYvCFjsD/zvshnMEOEW2Aaig7cZcXik5GI1xAQ+2pzoRknK8Iwt7NTUGPT0R1lZEdxlJ8IkAF9+WOpL30WbO9nD74SkZ+hfzn2G2xMSCfKXoZqf5K/YiH9GCL9huPkeBJ5QrSr0F5soKk4eOLd+UodyfPDdhV29y+zVlP+D1Uf4AlR01Sns7fSa2Uq1+TNhdx1uF9ZkiWg+RjPDugEDQgePCRSCr0oEl6YqspbOFh/HyqGBAL61J+lKqLCurn1vrIH7SOmftSKrSg6AQEL1FOyWr1UCWYMbIb/fXESmguQI0Fe4LAiC4z1bOXwz9qkTJWwn1LA7Pl3kv2dLWig+m+ZXQ7kPs52c/0Dzeyz/sRb8lA5NhDuScZdsq05VljTufmZuNoqP4cJPJ3OHt2283b/+Zq+RBPQTOePGb/ju4ykVOV4BIJXAuRs2wIIbISvpEiclZ57yP1Bs1jsd+Y+B1+rbgEhURgEgM/k
 aeX2YnTj
 0oGjrwNk+nGR+Kdrzw6880+ChwtuTTwdYc3Kof9gvjgtOG4im2e3kglUrFZv6qKzBp4/Ad5LLeq4BdRaQwIcDzyjL8wrjFh1Qv1+kcNlDqQIA0VCGvibms4CzHPyHGsghHXi1VafxChVLoKUIO6xXu8PmmJEGBadAedRb8aA+h68OHe2XhoCQPNnluA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 10:43=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Mon, Oct 20, 2025 at 03:03:04AM -0700, Jason Miu wrote:
> > - * Keep track of memory that is to be preserved across KHO.
> > + * The KHO radix tree tracks preserved memory pages. It is a hierarchi=
cal
> > + * structure that starts with a single root `kho_radix_tree`. This sin=
gle
> > + * tree stores pages of all orders.
> > + *
> > + * This is achieved by encoding the page's physical address and its or=
der into
> > + * a single `unsigned long` value. This encoded value is then used to =
traverse
> > + * the tree.
> > + *
> > + * The tree hierarchy is shown below:
> > + *
> > + * kho_radix_tree_root
> > + * +-------------------+
> > + * |     Level 5       | (struct kho_radix_tree)
> > + * +-------------------+
> > + *   |
> > + *   v
> > + * +-------------------+
> > + * |     Level 4       | (struct kho_radix_tree)
> > + * +-------------------+
> > + *   |
> > + *   | ... (intermediate levels)
> > + *   |
> > + *   v
> > + * +-------------------+
> > + * |      Level 0      | (struct kho_bitmap_table)
> > + * +-------------------+
> >   *
> > - * The serializing side uses two levels of xarrays to manage chunks of=
 per-order
> > - * 512 byte bitmaps. For instance if PAGE_SIZE =3D 4096, the entire 1G=
 order of a
> > - * 1TB system would fit inside a single 512 byte bitmap. For order 0 a=
llocations
> > - * each bitmap will cover 16M of address space. Thus, for 16G of memor=
y at most
> > - * 512K of bitmap memory will be needed for order 0.
>
> I think it is valuable to preserve this justification for
> bitmaps. There was a lot of debate over bitmaps vs ranges and this is
> the advantage of bitmaps. It is a bit subtle..

Sure, I will update the description about using the bitmap, along with
the new values.


> > +/*
> > + * The KHO radix tree tracks preserved pages by encoding a page's phys=
ical
> > + * address (pa) and its order into a single unsigned long value. This =
value
> > + * is then used to traverse the tree. The encoded value is composed of=
 two
> > + * parts: the 'order bits' in the upper part and the 'page offset' in =
the
> > + * lower part.
> > + *
> > + *   <-- Higher Bits ------------------------------------ Lower Bits -=
->
> > + *  +--------------------------+--------------------------------------=
---+
> > + *  |        Order Bits        |               Page Offset            =
   |
> > + *  +--------------------------+--------------------------------------=
---+
> > + *  | ... 0 0 1 0 0 ...        | pa >> (PAGE_SHIFT + order)           =
   |
> > + *  +--------------------------+--------------------------------------=
---+
> > + *            ^
> > + *            |
> > + *  This single '1' bit's position
> > + *  uniquely identifies the 'order'.
> > + *
> > + *
> > + * Page Offset:
> > + * The 'page offset' is the physical address normalized for its order.=
 It
> > + * effectively represents the page offset for the given order.
> > + *
> > + * Order Bits:
> > + * The 'order bits' encode the page order by setting a single bit at a
> > + * specific position. The position of this bit itself represents the o=
rder.
> > + *
> > + * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT =3D 12)=
, the
> > + * maximum range for a page offset (for order 0) is 52 bits (64 - 12).=
 This
> > + * offset occupies bits [0-51]. For order 0, the order bit is set at
> > + * position 52.
> > + *
> > + * As the order increases, the number of bits required for the 'page o=
ffset'
> > + * decreases. For example, order 1 requires one less bit for its page
> > + * offset. This allows its order bit to be set at position 51,
> > + * i.e. shifting right, without conflicting with the page offset bits.
>
> This description is correct, but the diagram is misleading. Maybe like th=
is:
>
>  *  |0| ... 0 0 0 1          | pa >> (PAGE_SHIFT + 0)              |
>  *  |1| ... 0 0 0 0 1        | pa >> (PAGE_SHIFT + 1)              |
>  *  |2| ... 0 0 0 0 0 1      | pa >> (PAGE_SHIFT + 2)              |
>  [..]
>

I see, giving new examples makes the order bit positions more clearer.

>
> > + *
> > + * This design stores pages of all sizes (orders) in a single 6-level =
table.  It
> > + * efficiently shares lower table levels, especially due to common zer=
o top
> > + * address bits, allowing a single, efficient algorithm to manage all =
pages.
> > + */
> > +enum kho_radix_consts {
> > +     /* The bit position of a 0-order page, only supports 64bits syste=
m */
> > +     ORDER_0_LG2 =3D 64 - PAGE_SHIFT,
> > +     /* Bit number used for each level of tables */
> > +     TABLE_SIZE_LG2 =3D const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
> > +     /* Bit number used for lowest level of bitmaps */
> > +     BITMAP_SIZE_LG2 =3D PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
>
> "bit number" is a bit confusing when using a lg2 terms..
>
>         /* Size of the table in kho_radix_tree, in lg2 */
>         TABLE_SIZE_LG2 =3D const_ilog2(PAGE_SIZE / sizeof(phys_addr_t))
>
>         /* Number of bits in the kho_bitmap_table, in lg2 */
>         BITMAP_SIZE_LG2 =3D const_ilog2(BITS_PER_BYTE * PAGE_SIZE)
>
> Then use the constants in the structs:
>
> struct kho_radix_tree {
>        phys_addr_t table[1 << TABLE_SIZE_LG2];
> };
> struct kho_bitmap_table {
>        unsigned long bitmaps[(1 << BITMAP_SIZE_LG2) / BITS_PER_LONG];
> };
>
> > -struct khoser_mem_chunk;
> > +static inline phys_addr_t kho_radix_tree_desc(struct kho_radix_tree *v=
a)
> > +{
> > +     return (phys_addr_t)virt_to_phys(va);
> > +}
>
> virt_to_phys already returns phys_addr_t ?
>
> > +static inline struct kho_radix_tree *kho_radix_tree(phys_addr_t desc)
> > +{
> > +     return (struct kho_radix_tree *)(phys_to_virt(desc));
> > +}
>
> phys_to_virt returns void *, no need for a cast
>

Yup, will update the types in both functions.

> > +static int kho_radix_set_bitmap(struct kho_bitmap_table *bit_tlb,
> > +                             unsigned long offset)
> > +{
> > +     if (!bit_tlb ||
> > +         offset >=3D PAGE_SIZE * BITS_PER_BYTE)
> > +             return -EINVAL;
>
> WARN_ON ? These are assertions aren't they?

Yes, will add an assertion here. Or should we use "BUG_ON"? As if this
error happened something is quite wrong and I do not think it is
recoverable.

>
> > +static int kho_radix_walk_trees(struct kho_radix_tree *root, unsigned =
int level,
> > +                             unsigned long start,
> > +                             kho_radix_tree_walk_callback_t cb)
> > +{
> > +     struct kho_radix_tree *next_tree;
> > +     struct kho_bitmap_table *bitmap_table;
> > +     unsigned long encoded, i;
> > +     unsigned int level_shift;
> > +     int err =3D 0;
> > +
> > +     for (i =3D 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
> > +             if (root->table[i]) {
>
>
> if (!root->table[i])
>    continue
>
> Remove a level of indentation here
>
> > +static int __kho_preserve_order(unsigned long pfn, unsigned int order)
> > +{
> > +     unsigned long pa =3D PFN_PHYS(pfn);
> > +
> > +     might_sleep();
> > +
> > +     return kho_radix_preserve_page(pa, order);
>
> might_sleep should be in kho_radix_preserve_page() ? The might should
> be placed around if statements that might avoid a sleep, and that is
> not in this function.
>

I got another feedback that we can merge the kho_radix_preserve_page()
__kho_preserve_order(), so the might_sleep() will be in the if
statements.

> >  static void __init kho_mem_deserialize(const void *fdt)
> >  {
> > +     struct kho_radix_tree *tree_root;
> >       const phys_addr_t *mem;
> >       int len;
> >
> > +     /* Retrieve the KHO radix tree from passed-in FDT. */
> > +     mem =3D fdt_getprop(fdt, 0, PROP_PRESERVED_PAGE_RADIX_TREE, &len)=
;
> >
> >       if (!mem || len !=3D sizeof(*mem)) {
> > +             pr_err("failed to get preserved KHO memory tree\n");
> >               return;
> >       }
> >
> > +     tree_root =3D *mem ?
> > +             (struct kho_radix_tree *)phys_to_virt(*mem) :
> > +             NULL;
> >
> > +     if (!tree_root)
> > +             return;
>
> Seems weird?
>
> if (!*mem)
>    return;
>
> tree_root =3D phys_to_virt(*mem)
> kho_radix_walk_trees(tree_root, TREE_MAX_DEPTH - 1, 0,
>                              kho_radix_walk_trees_memblock_callback);
>

Yup, this looks more natural, my mind was thinking to check tree_root.

>
> This is prettty good now, IMHO
>
> Jason

