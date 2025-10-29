Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC745CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 02:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF668E0027; Tue, 28 Oct 2025 22:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080558E0015; Tue, 28 Oct 2025 22:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB10A8E0027; Tue, 28 Oct 2025 22:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6E4D8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:08:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65391140648
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:08:43 +0000 (UTC)
X-FDA: 84049518126.16.439DD97
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5EEAE180007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:08:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CyWWQrMX;
	spf=pass (imf06.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761703721; a=rsa-sha256;
	cv=none;
	b=LykAb9rUyKtYWfxunytdLJEyjMC21anolXCruKAeXEGphxh0bYYyH+R8mhwG6ik1jOV4og
	QL9vZ9BDn7dZ6pA4Xhsl0GEfODXzEHHTRcLDWw3v6kuX8LDZEaKT4IuSv/ikHxwv5mc7y/
	MmDEoZnSCvOPgvh0JSoojdeFIXqR3Hk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CyWWQrMX;
	spf=pass (imf06.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761703721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViE2IJMZsT38eN1nZhUPu2n0lIp+ocL0/8G3rWAGTZ4=;
	b=VJQEE2YdDnsr9gt0tneT2YdPxyL5UlnnbYw7wflxBUEOq7Cravc3tI+UuSxnveNvUVUeyY
	UNRiw1Qk9/9rBsERk6SONroQlH7vi6b8QIjC2BUvGGq+YCKOSlvSmdpU8/rs+VIZVeVoDt
	yGfIDmTiNYdvpBfBiFNOmtCBpwYWJ2k=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-475dab5a5acso24766225e9.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761703720; x=1762308520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViE2IJMZsT38eN1nZhUPu2n0lIp+ocL0/8G3rWAGTZ4=;
        b=CyWWQrMXw3X+zxq2H17YgA0nPrxryTdlg7PJGhOjVVci0ziBhuLrIs4xrJzgPQpBQt
         LLRgtZHRTdsZje+PXUBNp29Ro2E8nR1Ni2bp/u5d0rEIxJacsgRmjfJTZ6B1Dku3aXkv
         yevrZwyDZMNRt3ZNUsAuD/WrQKyRefb/wE74soFWeitwNvgP6ise9umD+rxE3XhmtbnF
         +vVM8UEgc0lAfjdjW9A4+QlfO0XWlyBFvFIPtGGEQ1VjCZToweLqFox/0p4833J8HwnM
         pwGwlqFcAl7ojmgj/bhhqScq85oFG+jdjhPmozfoYH1SkRdWwxqPgUKK02ZGCtXl7Hyg
         SOzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761703720; x=1762308520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ViE2IJMZsT38eN1nZhUPu2n0lIp+ocL0/8G3rWAGTZ4=;
        b=NnpskqsFDCc1pWRJTXWZs/yJqyXDxDC6QeareGuo08yOMv6x7BQ+kObD1hfKQ4/8tP
         dVJwwmjLJrJ523BFiNEYjcCZ9oVG1ed1MRid+zh18mU0XgmD7gaeIoOMEGzCmOgNN0l6
         WA1oyqk7800IYUUSNT5ohJ3c7Qed6hC7GRaq2VmWn6WXVxNOtxDczWsJGB3X+GNGYh4D
         xwzdkvnERSdfs6Rudp52tP0vz0Nv+F3S2WkOTZz8i5uLSOugkA2PdmvXftbUJAw5UN+e
         X3G92rgTthbxrwGjM7IZySC5F2X+lvdNY+JkUb3SyZ83mRQvWO4tSj0Jp4HQBnBSgPvS
         8cjA==
X-Forwarded-Encrypted: i=1; AJvYcCXBZTYrubsXlI9aZzGhM2GW0Z+4bDt2t87DCNXFf8j/pyFis+RFMY+T3av/5LeAWTyvJv4yungbqw==@kvack.org
X-Gm-Message-State: AOJu0YyrOZ/PZ5PVR3c/xsT+4BTpShPOU1CSJ4ZjiSZc1hBsqW5j5AY8
	GY1OtdQD4B+S1hNlfVRgbeu1D6EA991xoZCN4073eXHp393/w5OPTIaOUOCB/FI9wWIc2oqNcLP
	11/TTwCH7VLMcs2stl2Fq1p1cgebPuglUkm4JujuG
X-Gm-Gg: ASbGncuhLpTYOUY9Yw8ylz19LSA6fCSW63/rPRl6dd73QgmqFaduyc6nbN+XIHvCT5I
	ijkW4/Y1dAqGiHzAMNUD48dsAoKbjaoxV2lkfLdknGvuY2UmBCwsL0u7tCvhYA6MFudvKp1PWHg
	4psf2Wxa+Yn0tpXuQgyeNq338C6la4ViPTcu2cHDYZkNxLDLqJqr+spOJTMxV0nMmVFiTQRtFAh
	NutG0NxHRJ6uyMPNhqD+/Yr7A6A/1EUfRovuWum/92pnI+lao7oyWJ90OnkDe+1FZKPaJiOs6UV
	ng7EgHhxrm7iLYA=
X-Google-Smtp-Source: AGHT+IFZSk1aVcDaiZG1WuRbrPfpYeQn9yjnQ/yehfVemqM2wa4pmyOLOTvDDNrzAwfyZ4ClnhC6dYEQulkvBDKpLAA=
X-Received: by 2002:a05:6000:2508:b0:3fb:aca3:d5d9 with SMTP id
 ffacd0b85a97d-429aef76469mr656025f8f.1.1761703719439; Tue, 28 Oct 2025
 19:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com> <20251020100306.2709352-2-jasonmiu@google.com>
 <aP9dTNhZ4LduuXb3@kernel.org>
In-Reply-To: <aP9dTNhZ4LduuXb3@kernel.org>
From: Jason Miu <jasonmiu@google.com>
Date: Tue, 28 Oct 2025 19:08:27 -0700
X-Gm-Features: AWmQ_bnowmRLlgmKDoJlRCBEY1XavrLAyi7DtGAa01tD5hlwi4aNGIgYxzT4Uf0
Message-ID: <CAHN2nPL2+qs9MZnOYq-Oh_D1ehOSfSLsViLa8pZ7bt4AE4zZXg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] kho: Adopt KHO radix tree data structures
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: wrioad5prfbyf6139swmhedwr1jt4gwh
X-Rspamd-Queue-Id: 5EEAE180007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761703721-438739
X-HE-Meta: U2FsdGVkX1+xyECVv1ayet+xBya6nHhcI10iG1E8HFO0hy4XimE8H+iUfUyhSSxL/sH/YvCI6QZ1EG20/GROn6H7VfnCkeQtADZKzgDz3T2K+3XmX8jhmUEJcnu0R3R9QgVCVbWAJm/t/2vmf4euAhyLWR92RYctHNruIu2aJ8GNeGggBkoeYn7gg0G8mETAydxfVn07xtwHslAM5NOEKw8BronOOCvtGhDqoathd3fTTXJqDGsVdYD8IC1+9MZAeiwVUk+2HyTG/xQnt8rXNwKMaOsRJNs9Ijd5THWsD8eWwQgbtjYNJLWH2R93Jbrs2LbFtpSc1lrp+S3ea57SDQm4ITTiwt9rf3ZXJeMw9nqwiDF/kKFZfhavReAkc7AZDytRlH6EXjAnihq4w1ck6ffT+Xd4nqqmTrd+1uiTX1QZAF2X9ztAM7Fa5/rSVk0BX1zZk6xBNxGdC0XxNeR2iGDUraqUNWYOb8dJH9wAtDDYJn/VSsMIsL7UZPtABouW/RFYLIlfVhmB1q8lQjlF9CkPKL2fJEkoR+P1KUyTaH3bEYmPUTAw51w9gmrPZ4+oPrQGjOhuDKGQSLG/4FOfJgCMeD84inG+0x6zMSLWOLWEsSAgNl11vfi0yzGMFcTXUYuc187kbU1vPnmxAOGLHCkw9QSd2YdaIroiSWJqQVp1KiDmX4zhAXdkpW1yFhpRz2T8i2WfPfNe1tHRlmEMFX0Z6m1asvjHJVjOZafyY0Ld+0ryMF8AUqz9FG1LnVgRqF0hs/mTQdyR+dQWwEszgMRfvo6G3tYuAz19DGC0j+oBqhfT77l2NcaRDQaeeW1CxVOdyFVB1VOK1u8R7JQcn6WFqbQGtp/LZuLW0pHLEmnCN4Lz3cenP9yuYTVC9t60zZ8Kl0/oeM9KVwRSkZUJIc7+lBuGXXsyad3U2awk7RW0mkB0z34+3aJU618aJcga2z0pEw/eGzR1jxuMXRW
 WpCI7WIW
 ZIl6uigc9mZej1vMvK7sZemmAwGVNZCVGp2Wy6+YmHFdpqmVGziKq9xSb/QRDePF7E95QKCKvOJYA209mu43WSAQMwWpWwmGoOWMN+eGt3hB/7jboAjDNNXPuIWjOLZ0PUeERZqiApbm9WVCWEJcJUT5EEE95+/XC0VPf5Jb9YkPMydyr7K0FOdZXpCEpG/DrUONxLPeBa4WTF0JYD+dOhD/UcH4NBSP6N64CZ6NI0WoT8uWUiqfeE6vxtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thank you very much for providing your comments.

On Mon, Oct 27, 2025 at 4:53=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Oct 20, 2025 at 03:03:04AM -0700, Jason Miu wrote:
> > Introduce a radix tree data structure for tracking preserved
> > memory pages in KHO, which will replace the current xarray-based
> > implementation.
> >
> > The primary motivation for this change is to eliminate the need for
> > serialization. By marking preserved pages directly in the new KHO
> > radix tree and passing them to the next kernel, the entire
> > serialization process can be removed. This ultimately allows for the
> > removal of the KHO finalize and abort states, simplifying the overall
> > design.
> >
> > The preserved page physical address and its order are encoded in to a
> > value. The KHO radix tree has multiple level of nodes where each node
> > is a table contining a descriptor to the next level of nodes. The
> > encoded value get split and stored its parts along the tree
> > traversal. The tree traversal ends with the `kho_bitmap_table`, where
> > each bit represents a single preserved page.
> >
> > Instead of serializing the memory map, the first kernel store the KHO
> > radix tree root in the FDT. This KHO radix tree root is passed to the
> > second kernel after kexec, hence elimitated the KHO finalize and abort
> > states.
> >
> > The second kernel walks the passed-in KHO radix tree from its root. It
> > restores the memory pages and their orders by decoding the value
> > stored in the KHO radix tree.
> >
> > This architectural shift to using a shared radix tree structure
> > simplifies the KHO design and eliminates the overhead of serializing
> > and deserializing the preserved memory map.
> >
> > Signed-off-by: Jason Miu <jasonmiu@google.com>
> > ---
> >  MAINTAINERS                                   |   2 +
> >  include/linux/kexec_handover.h                |  23 +-
> >  .../linux/live_update/abi/kexec_handover.h    |  10 +
> >  kernel/kexec_handover.c                       | 861 +++++++++---------
> >  4 files changed, 458 insertions(+), 438 deletions(-)
> >  create mode 100644 include/linux/live_update/abi/kexec_handover.h
> >
> > diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_hando=
ver.h
> > index 348844cffb13..bc2f9e060a79 100644
> > --- a/include/linux/kexec_handover.h
> > +++ b/include/linux/kexec_handover.h
> > @@ -45,6 +28,7 @@ int kho_preserve_folio(struct folio *folio);
> >  int kho_preserve_phys(phys_addr_t phys, size_t size);
> >  struct folio *kho_restore_folio(phys_addr_t phys);
> >  int kho_add_subtree(struct kho_serialization *ser, const char *name, v=
oid *fdt);
> > +int kho_remove_subtree(const char *name);
>
> This change seems unrelated.

I want to add the "kho_remove_subtree()" as a counterpart of the
"kho_add_subtree()". You are right that "kho_remove_subtree()" is not
very related to this radix tree data struct change. Do you prefer I
split this kho_remove_subtree() change as another patch in this
series, or do you prefer another independent patch series? (I like the
latter option more personally)

>
> >  int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
> >
> >  int register_kho_notifier(struct notifier_block *nb);
> > @@ -86,6 +70,11 @@ static inline int kho_retrieve_subtree(const char *n=
ame, phys_addr_t *phys)
> >       return -EOPNOTSUPP;
> >  }
> >
> > +static inline int kho_remove_subtree(const char *name)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
>
> Ditto.
>
> >  static inline int register_kho_notifier(struct notifier_block *nb)
> >  {
> >       return -EOPNOTSUPP;
> > diff --git a/include/linux/live_update/abi/kexec_handover.h b/include/l=
inux/live_update/abi/kexec_handover.h
> > new file mode 100644
> > index 000000000000..3154e5c33851
> > --- /dev/null
> > +++ b/include/linux/live_update/abi/kexec_handover.h
> > @@ -0,0 +1,10 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _ABI__KEXEC_HANDOVER_H
> > +#define _ABI__KEXEC_HANDOVER_H
> > +
> > +#define KHO_FDT_COMPATIBLE "kho-v2"
> > +#define PROP_PRESERVED_PAGE_RADIX_TREE "preserved-page-radix-tree"
>
> The property describes the preserved memory, it's not important if it's a
> radix tree, a linked list or whatever else, so I don't think
> page-radix-tree is a good name.
>
> IMHO we can keep the preserved-memory-map name because version bump ensur=
es
> we won't attempt to parse v1 data structure.
>

Sure, I can just keep the preserved-memory-map name.

> > +#define PROP_SUB_FDT "fdt"
> > +
> > +#endif
> > diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> > index ecd1ac210dbd..2fc5975690a7 100644
> > --- a/kernel/kexec_handover.c
> > +++ b/kernel/kexec_handover.c
> > @@ -46,143 +45,305 @@ static int __init kho_parse_enable(char *p)
> >  }
> >  early_param("kho", kho_parse_enable);
> >
> > +typedef int (*kho_radix_tree_walk_callback_t)(unsigned long encoded);
> > +
> >  /*
> > - * Keep track of memory that is to be preserved across KHO.
>
> Please leave this sentence.
>
> > + * The KHO radix tree tracks preserved memory pages. It is a hierarchi=
cal
> > + * structure that starts with a single root `kho_radix_tree`. This sin=
gle
> > + * tree stores pages of all orders.
>
> I'd combine this comment and the comment above declaration of enum
> kho_radix_consts into something like this:
>

Yes, I will move the kho_radix_consts up so its comment will be
combined and stay close to the comment of kho_radix_tree.

> /*
>  * KHO tracks preserved memory using a radix tree data structure. Each no=
de of
>  * the tree is PAGE_SIZE and it is PAGE_SIZE aligned.
>  *
>  * The leaf nodes of the tree are bitmaps where each set bit represents a
>  * single preserved page. The intermediate and root nodes of the tree are
>  * tables of physical addresses that point to a lower level node:
>  *
>  * kho_radix_tree_root
>  * +-------------------+
>  * |     Level 5       | (struct kho_radix_tree)
>  * +-------------------+
>  *   |
>  *   v
>  * +-------------------+
>  * |     Level 4       | (struct kho_radix_tree)
>  * +-------------------+
>  *   |
>  *   | ... (intermediate levels)
>  *   |
>  *   v
>  * +-------------------+
>  * |      Level 0      | (struct kho_bitmap_table)
>  * +-------------------+
>  *
>  * The physical address of the preserved page and its order are encoded i=
nto a
>  * single unsigned long value where higher bits represent the order and t=
he
>  * lower bits represent the page offset:
>  *
>  *   <-- Higher Bits ------------------------------------ Lower Bits -->
>  *  +--------------------------+-----------------------------------------=
+
>  *  |        Order Bits        |               Page Offset               =
|
>  *  +--------------------------+-----------------------------------------=
+
>  *  |0| ... 0 0 0 1            | pa >> (PAGE_SHIFT + 0)                  =
|
>  *  |1| ... 0 0 0 0 1            | pa >> (PAGE_SHIFT + 1)                =
|
>  *  |2| ... 0 0 0 0 0 1            | pa >> (PAGE_SHIFT + 2)              =
|
>  *  +------------------------------+-------------------------------------=
+
>  *                  ^
>  *                  |
>  *  This single '1' bit's position uniquely identifies the 'order'.
>  *
>  * Page Offset:
>  * The 'page offset' is the physical address normalized for its order. It
>  * effectively represents the page offset for the given order.
>  *
>  * Order Bits:
>  * The 'order bits' encode the page order by setting a single bit at a
>  * specific position. The position of this bit itself represents the orde=
r.
>  *
>  * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT =3D 12), t=
he
>  * maximum range for a page offset (for order 0) is 52 bits (64 - 12). Th=
is
>  * offset occupies bits [0-51]. For order 0, the order bit is set at
>  * position 52.
>  *
>  * As the order increases, the number of bits required for the 'page offs=
et'
>  * decreases. For example, order 1 requires one less bit for its page
>  * offset. This allows its order bit to be set at position 51,
>  * i.e. shifting right, without conflicting with the page offset bits.
>  *
>  * Bitfields in this encoded value are used as indices into the tables fo=
r
>  * upper levels and as bitmap index for the lowest level.
>  *
>  * The following diagram illustrates how the encoded value is split into
>  * indices for the tree levels, with PAGE_SIZE of 4KB:
>  *
>  *      63:60   59:51    50:42    41:33    32:24    23:15         14:0
>  * +---------+--------+--------+--------+--------+--------+--------------=
---+
>  * |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (bitmap=
)  |
>  * +---------+--------+--------+--------+--------+--------+--------------=
---+
>  *
>  * This design stores pages of all sizes (orders) in a single 6-level tab=
le.
>  * It efficiently shares lower table levels, especially due to common zer=
o top
>  * address bits, allowing a single, efficient algorithm to manage all pag=
es.
>  *
>  * < a paragraph about memory consumption >
>  */
>
> > + *
> > + * This is achieved by encoding the page's physical address and its or=
der into
> > + * a single `unsigned long` value. This encoded value is then used to =
traverse
> > + * the tree.
>
> ...
>
> > + * Each `kho_radix_tree` (Levels 1-5) and `kho_bitmap_table` (Level 0)=
 is
> > + * PAGE_SIZE. Each entry in a `kho_radix_tree` is a descriptor (a phys=
ical
> > + * address) pointing to the next level node. For Level 1 `kho_radix_tr=
ee`
> > + * nodes, these descriptors point to a `kho_bitmap_table`. The final
> > + * `kho_bitmap_table` is a bitmap where each set bit represents a sing=
le
> > + * preserved page.
> >   */
>
> Please add an empty line between description and the declaration.
>
> > +struct kho_radix_tree {
>
> I think the name should reflect that this data structure is for tracking
> memory in KHO. Otherwise it reads like a generic data structure that can =
be
> used with KHO, like kho_array Pratyush proposed a while ago.
>
> Maybe struct kho_mem_radix_tree? Or even drop the 'radix', I don't think
> it's really important here.
>

I use the 'radix' here as we need a step to convert the page address
to a radix tree key. I agree that `kho_mem_radix_tree` sounds better.

> > +     phys_addr_t table[PAGE_SIZE / sizeof(phys_addr_t)];
> > +};
> >
> > -#define PRESERVE_BITS (512 * 8)
> > -
> > -struct kho_mem_phys_bits {
> > -     DECLARE_BITMAP(preserve, PRESERVE_BITS);
> > +struct kho_bitmap_table {
> > +     unsigned long bitmaps[PAGE_SIZE / sizeof(unsigned long)];
>
> What's wrong with kho_mem_phys_bits and DECLARE_BITMAP?
> Simply adjust PRESERVE_BITS to match PAGE_SIZE.
>

I used `kho_bitmap_table` as I wanted to highlight it as a patch of
bitmap that has to be in the size of PAGE_SIZE. I found the original
`kho_mem_phys_bits` harder to understand as a bit in this bitmap is
referring to one memory page. I can update it as

#define PRESERVE_PAGE_BITS (PAGE_SIZE * 8)
struct kho_bitmap {
    DECLARE_BITMAP(preserve_page, PRESERVE_PAGE_BITS);
};

what do you think?

> >  };
> >
> > -struct kho_mem_phys {
> > +/*
> > + * The KHO radix tree tracks preserved pages by encoding a page's phys=
ical
>
> ...
>
> > + * address bits, allowing a single, efficient algorithm to manage all =
pages.
> > + */
> > +enum kho_radix_consts {
>
> I think this should be declared before the structs, so that there will be
> one long description before the enum, structs and code.
>

yes, will move this enum up.

> > +     /* The bit position of a 0-order page, only supports 64bits syste=
m */
> > +     ORDER_0_LG2 =3D 64 - PAGE_SHIFT,
> > +     /* Bit number used for each level of tables */
> > +     TABLE_SIZE_LG2 =3D const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
> > +     /* Bit number used for lowest level of bitmaps */
> > +     BITMAP_SIZE_LG2 =3D PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
> >       /*
> > -      * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit i=
s sized
> > -      * to order.
> > +      * The total tree depth is the number of intermediate levels
> > +      * and 1 bitmap level.
> >        */
> > -     struct xarray phys_bits;
> > +     TREE_MAX_DEPTH =3D DIV_ROUND_UP(ORDER_0_LG2 - BITMAP_SIZE_LG2,
> > +                                   TABLE_SIZE_LG2) + 1,
> >  };
> >
> > -struct kho_mem_track {
> > -     /* Points to kho_mem_phys, each order gets its own bitmap tree */
> > -     struct xarray orders;
> > -};
> > +/*
> > + * `kho_radix_tree_root` points to a page thats serves as the root of =
the
> > + * KHO radix tree. This page is allocated during KHO module initializa=
tion.
> > + * Its physical address is written to the FDT and passed to the next k=
ernel
> > + * during kexec.
> > + */
> > +static struct kho_radix_tree *kho_radix_tree_root;
> > +static DECLARE_RWSEM(kho_radix_tree_root_sem);
>
> I believe it's clearer to have struct kho_mem_track containing the pointe=
r
> to root and the semaphore, e.g.
>
> struct kho_mem_track {
>         struct kho_mem_tree *root;
>         struct rw_semaphore sem;
> };
>

Sure.

> > -struct khoser_mem_chunk;
> > +static inline phys_addr_t kho_radix_tree_desc(struct kho_radix_tree *v=
a)
>
> I think kho_mem_tree is a better prefix than kho_radix.

As above, I tend to use `kho_mem_radix_tree`.

>
> > +{
> > +     return (phys_addr_t)virt_to_phys(va);
> > +}
> >
> > -struct kho_serialization {
> > -     struct page *fdt;
> > -     struct list_head fdt_list;
> > -     struct dentry *sub_fdt_dir;
> > -     struct kho_mem_track track;
> > -     /* First chunk of serialized preserved memory map */
> > -     struct khoser_mem_chunk *preserved_mem_map;
> > -};
> > +static inline struct kho_radix_tree *kho_radix_tree(phys_addr_t desc)
>
> This is not really a 'desc', this is a plain physical address, i.e. 'pa'.
> It's probably will be clearer to just use phys_to_virt() and virt_to_phys=
()
> directly rather than introduce these wrappers.

We had some previous discussions that using helper functions for
converting between the va and pa. But I agree with what you said that
"this is not ready a desc". How about "kho_radix_tree(phys_addr_t
node_pa)", to align with the variable name of the tree iterator below?

>
> > +{
> > +     return (struct kho_radix_tree *)(phys_to_virt(desc));
> > +}
> >
> > -static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, =
size_t sz)
> > +static struct kho_radix_tree *kho_alloc_radix_tree(void)
> >  {
> > -     void *elm, *res;
> > +     return (struct kho_radix_tree *)get_zeroed_page(GFP_KERNEL);
> > +}
> >
> > -     elm =3D xa_load(xa, index);
> > -     if (elm)
> > -             return elm;
> > +static unsigned long kho_radix_encode(phys_addr_t pa, unsigned int ord=
er)
>
> This name is really cryptic. Encode to what? Can't say I have great ideas=
,
> but this name should reflect that physical address and order are encoded
> into combined index into the tree.
>
> Maybe _encode_indices()?

As the "indices" can also refer to an entry of the table in a KHO mem
radix tree node. We are actually encoding a radix tree key, so may be
kho_radix_encode_key() ?

>
> > +{
> > +     /* Order bits part */
> > +     unsigned long h =3D 1UL << (ORDER_0_LG2 - order);
> > +     /* Page offset part */
> > +     unsigned long l =3D pa >> (PAGE_SHIFT + order);
> >
> > -     elm =3D kzalloc(sz, GFP_KERNEL);
> > -     if (!elm)
> > -             return ERR_PTR(-ENOMEM);
> > +     return h | l;
> > +}
> >
> > -     res =3D xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> > -     if (xa_is_err(res))
> > -             res =3D ERR_PTR(xa_err(res));
> > +static phys_addr_t kho_radix_decode(unsigned long encoded, unsigned in=
t *order)
>
> The same here. Maybe
>
>         _decode_indices(unsigned long indices, unsigned int *order)
>
> > +{
> > +     unsigned int order_bit =3D fls64(encoded);
> > +     phys_addr_t pa;
> >
> > -     if (res) {
> > -             kfree(elm);
> > -             return res;
> > -     }
> > +     /* order_bit is numbered starting at 1 from fls64 */
> > +     *order =3D ORDER_0_LG2 - order_bit + 1;
> > +     /* The order is discarded by the shift */
> > +     pa =3D encoded << (PAGE_SHIFT + *order);
> >
> > -     return elm;
> > +     return pa;
> >  }
> >
> > -static void __kho_unpreserve(struct kho_mem_track *track, unsigned lon=
g pfn,
> > -                          unsigned long end_pfn)
> > +static unsigned long kho_radix_get_index(unsigned long encoded,
>
> I don't like 'encoded' here and below as well.
>

If we agree with the name above, I think we can use
"kho_radix_get_index(unsigned long radix_key" here.

> > +                                      unsigned int level)
> >  {
> > -     struct kho_mem_phys_bits *bits;
> > -     struct kho_mem_phys *physxa;
> > -
> > -     while (pfn < end_pfn) {
> > -             const unsigned int order =3D
> > -                     min(count_trailing_zeros(pfn), ilog2(end_pfn - pf=
n));
> > -             const unsigned long pfn_high =3D pfn >> order;
> > +     int s;
> >
> > -             physxa =3D xa_load(&track->orders, order);
> > -             if (!physxa)
> > -                     continue;
> > +     if (level =3D=3D 0)
> > +             return encoded % (1 << BITMAP_SIZE_LG2);
> >
> > -             bits =3D xa_load(&physxa->phys_bits, pfn_high / PRESERVE_=
BITS);
> > -             if (!bits)
> > -                     continue;
> > +     s =3D ((level - 1) * TABLE_SIZE_LG2) + BITMAP_SIZE_LG2;
> > +     return (encoded >> s) % (1 << TABLE_SIZE_LG2);
> > +}
> >
> > -             clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
> > +static int kho_radix_set_bitmap(struct kho_bitmap_table *bit_tlb,
>
>                                                            ^ bitmap

Yes, let's just call it `struct kho_bitmap`.

>
> > +                             unsigned long offset)
> > +{
> > +     if (!bit_tlb ||
> > +         offset >=3D PAGE_SIZE * BITS_PER_BYTE)
>
> No need for two lines here
>
> > +             return -EINVAL;
> >
> > -             pfn +=3D 1 << order;
> > -     }
> > +     __set_bit(offset, bit_tlb->bitmaps);
> > +     return 0;
> >  }
> >
> > -static int __kho_preserve_order(struct kho_mem_track *track, unsigned =
long pfn,
> > -                             unsigned int order)
> > +static int kho_radix_preserve_page(phys_addr_t pa, unsigned int order)
> >  {
> > -     struct kho_mem_phys_bits *bits;
> > -     struct kho_mem_phys *physxa, *new_physxa;
> > -     const unsigned long pfn_high =3D pfn >> order;
> > +     unsigned long encoded =3D kho_radix_encode(pa, order);
> > +     struct kho_radix_tree *current_tree, *new_tree;
>
> current_ is excessive IMHO and 'node' seems to be a better name for a tre=
e
> iterator:
>
>         struct kho_radix_tree *node;
>
> is fine, the new_tree can be declared in the scope that uses it.
>
> > +     struct kho_bitmap_table *bitmap_table;
>
> _table is excessive on both the type name and variable name
>
> > +     unsigned int tree_level =3D TREE_MAX_DEPTH - 1;
>
> Just 'level' is enough.
>
> > +     unsigned int err =3D 0;
>
> err is signed.
>
> > +     unsigned int i, idx;
> >
> > -     might_sleep();
> > +     down_write(&kho_radix_tree_root_sem);
> >
> > -     physxa =3D xa_load(&track->orders, order);
> > -     if (!physxa) {
> > -             int err;
> > +     if (!kho_radix_tree_root) {
>
> Isn't this an assert?
> Also I don't see concurrency for accessing the root, the assertion can be
> outside the lock.
>

Yes, I will add a WARN_ON here.

> > +             err =3D -EINVAL;
> > +             goto out;
> > +     }
> >
> > -             new_physxa =3D kzalloc(sizeof(*physxa), GFP_KERNEL);
> > -             if (!new_physxa)
> > -                     return -ENOMEM;
> > +     current_tree =3D kho_radix_tree_root;
> >
> > -             xa_init(&new_physxa->phys_bits);
> > -             physxa =3D xa_cmpxchg(&track->orders, order, NULL, new_ph=
ysxa,
> > -                                 GFP_KERNEL);
> > +     /* Go from high levels to low levels */
> > +     for (i =3D tree_level; i >=3D 0; i--) {
> > +             idx =3D kho_radix_get_index(encoded, i);
> >
> > -             err =3D xa_err(physxa);
> > -             if (err || physxa) {
> > -                     xa_destroy(&new_physxa->phys_bits);
> > -                     kfree(new_physxa);
> > +             if (i =3D=3D 0) {
> > +                     bitmap_table =3D (struct kho_bitmap_table *)curre=
nt_tree;
> > +                     err =3D kho_radix_set_bitmap(bitmap_table, idx);
>
> I'd consider making the loop until 'i > 0' and putting this outside the
> loop.
>
> > +                     goto out;
> > +             }
> > +
>
>                 if (node->table[idx]) {
>                         node =3D kho_radix_tree(node->table[idx]);
>                         continue;
>                 }
>
> and reduce the indentation for allocating a new table.
>
> > +             if (!current_tree->table[idx]) {
> > +                     new_tree =3D kho_alloc_radix_tree();
> > +                     if (!new_tree) {
> > +                             err =3D -ENOMEM;
> > +                             goto out;
> > +                     }
> >
> > -                     if (err)
> > -                             return err;
> > +                     current_tree->table[idx] =3D
> > +                             kho_radix_tree_desc(new_tree);
> > +                     current_tree =3D new_tree;
> >               } else {
> > -                     physxa =3D new_physxa;
> > +                     current_tree =3D kho_radix_tree(current_tree->tab=
le[idx]);
> >               }
> >       }
> >
> > -     bits =3D xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE=
_BITS,
> > -                             sizeof(*bits));
> > -     if (IS_ERR(bits))
> > -             return PTR_ERR(bits);
> > +out:
> > +     up_write(&kho_radix_tree_root_sem);
> > +     return err;
> > +}
> > +
> > +static int kho_radix_walk_bitmaps(struct kho_bitmap_table *bit_tlb,
> > +                               unsigned long encoded,
> > +                               kho_radix_tree_walk_callback_t cb)
> > +{
> > +     unsigned long *bitmap =3D (unsigned long *)bit_tlb;
> > +     unsigned int i;
> > +     int err =3D 0;
> > +
> > +     for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> > +             err =3D cb(encoded | i);
> > +             if (err)
> > +                     return err;
> > +     }
> >
> > -     set_bit(pfn_high % PRESERVE_BITS, bits->preserve);
> > +     return 0;
> > +}
> > +
> > +static int kho_radix_walk_trees(struct kho_radix_tree *root, unsigned =
int level,
>
> static int kho_radix_walk_tree(struct kho_radix_tree *parent, ...
>
> > +                             unsigned long start,
> > +                             kho_radix_tree_walk_callback_t cb)
> > +{
> > +     struct kho_radix_tree *next_tree;
>
>         struct kho_radix_tree *node;
>
> > +     struct kho_bitmap_table *bitmap_table;
>
>                                 ^ bitmap;
>
> > +     unsigned long encoded, i;
> > +     unsigned int level_shift;
>
> This can move to the scope where it's used and 'shift' would be enough.
>
> > +     int err =3D 0;
>
> ...
>
> > +static int __kho_preserve_order(unsigned long pfn, unsigned int order)
> > +{
> > +     unsigned long pa =3D PFN_PHYS(pfn);
> > +
> > +     might_sleep();
> > +
> > +     return kho_radix_preserve_page(pa, order);
>
> I don't think that __kho_preserve_order() wrapper is useful, just rename
> kho_radix_preserve_page to __kho_preserve_order()

Will merge both.

>
> > +}
> > +
> >  /* almost as free_reserved_page(), just don't free the page */
> >  static void kho_restore_page(struct page *page, unsigned int order)
> >  {
> > @@ -224,152 +385,49 @@ struct folio *kho_restore_folio(phys_addr_t phys=
)
> >  }
> >  EXPORT_SYMBOL_GPL(kho_restore_folio);
>
> ...
>
> > -static int kho_mem_serialize(struct kho_serialization *ser)
> > +static int __init kho_radix_walk_trees_memblock_callback(unsigned long=
 encoded)
>
> I wonder if we expect other callbacks for tree traversal?
> For now there's only one case when we traverse the tree, so it seems
> simpler to just merge the code here into kho_radix_walk_bitmaps() and
> rename kho_radix_walk_trees() and kho_radix_walk_bitmaps() to reflect tha=
t
> they are reserving the preserved memory.
>

Currently only `kho_radix_walk_trees_memblock_callback()` is used in
tree walking, but having a callback in the tree walking helps for
debugging the KHO mem tree. I can imagine that we can have different
build options for different callbacks. If there is no big objection, I
tend to keep the callback.

> >  {
> > +     unsigned int order;
> > +     unsigned long pa;
> > +     struct page *page;
> > +     int sz;
> >
> > +     pa =3D kho_radix_decode(encoded, &order);
> > +     sz =3D 1 << (order + PAGE_SHIFT);
> > +     page =3D phys_to_page(pa);
> >
> > +     /* Reserve the memory preserved in KHO radix tree in memblock */
> > +     memblock_reserve(pa, sz);
> > +     memblock_reserved_mark_noinit(pa, sz);
> > +     page->private =3D order;
> >  }
> >
> >  static void __init kho_mem_deserialize(const void *fdt)
>
> Well, it's not deserialize anymore.

Yeah, I did think about this name too... How about  kho_mem_retrieve() ?

>
> >  {
> > @@ -599,6 +657,35 @@ static int kho_debugfs_fdt_add(struct list_head *l=
ist, struct dentry *dir,
> >       return 0;
> >  }
>
> It seems that a lot of the changes below are not related to changing the
> mechanism for tracking the preserved memory.
>
> I'm stopping here.
>
> --
> Sincerely yours,
> Mike.

Thanks again, Mike.

