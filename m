Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7723ED29DCB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF63C6B0005; Tue, 13 Jan 2026 00:33:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3D26B0089; Tue, 13 Jan 2026 00:33:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977C16B008A; Tue, 13 Jan 2026 00:33:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81D306B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:33:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 053CA1ABAA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:33:26 +0000 (UTC)
X-FDA: 84325822812.05.BE532EB
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id F191B120004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:33:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J1571UWW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jasonmiu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768282404; a=rsa-sha256;
	cv=none;
	b=Gtk/Tf9sjy6a4uUKLclVDLXUElN/VytnfFGekJYgwl8KFcZLRnFEKkOaW7a6sCpbqvuikD
	53NKqr+ssP+K9BQ/BvVVMLbhdmWgsZudWbgeNfe73UEtsAuLoY9S002daXF2x0DqRQ88ki
	p8Jy6g/XUeMwT2DJzkYP2tfM4rdZ3FY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J1571UWW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of jasonmiu@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jasonmiu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768282404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78QjJmPPcRBD9z/YkfxYdK7B4K+CO0yClwJwNbFrsWI=;
	b=rmK2t1+tMR+nCKigCJz6b09+loOq1v3yImr07CHK3j3/yv6EaMR0sOJO5LEwE6dklaBhxV
	XkFodcw9pbvTr/rXczCNhXD4RxvOf3bRaejDDjRsul3WO8dj/Zhvo4Zyc9Sa+r2z3DRI85
	5akz1G+WDHjCdgCOJjvoKWQkwxN88q0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47796a837c7so48634725e9.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768282402; x=1768887202; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78QjJmPPcRBD9z/YkfxYdK7B4K+CO0yClwJwNbFrsWI=;
        b=J1571UWWx+yM0PzA6XpaFTT6DX6v/6BP+cg0OxnZ4HrpmZ2+18ts9XOn+WUL1j/bwW
         HnhSv7dkDeUgfQvl7qNU9seRVqPQSIKtFt0UP1zBnaa2K3rTTKvNnXkx1FBKKhR38Ted
         8h6NiO0AfTYJEdbQ5vZdycMin3psevOMkryyebNhdMBxyGsPHVfGh7wq0CsgJVwZxLlN
         SPl4/6xluApzCMkM5NQ3ScsMnAopKx3BfxvjKHqVVmInzrLsgjQIk0w13tqXQYgLlT6s
         zBkW/FWXZUbCqIsBG7zapN48ye9HX3kxcErelToBpZocF0j+g2P0NqqGaVwF8QCo3Mnb
         6nDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768282402; x=1768887202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=78QjJmPPcRBD9z/YkfxYdK7B4K+CO0yClwJwNbFrsWI=;
        b=opsNrXMtqHEtwV8NcMLMweuqTuPQIiYwDRbcMGrnVAzhQG5fiYdH/Nsio1JhDTuU07
         MoS/fgmh14wOYRUpcsYM6aO++gOOcFGW/2XSjItdpe6FjOWSanJK4nEonZl3tc2c8F8Q
         g9c8UmonqlcHaL7LQQP/6eSu13DfU630s/YsaK1VgcAGJH4D41oLi+dTczP+CoFH7MOf
         /05Y2fzI3W225gcAdkP/yFSmolLpWWXeMuYkM/haiWIamFXQQFA0id13jtbD/ihl9DaC
         8BcChn+ntOf2wDpQhaLALq21DoE3cI/5CtnQyLISLZ8abXMj8tYNX2WoUpLfXsWDht7O
         izRg==
X-Forwarded-Encrypted: i=1; AJvYcCVHIdeNlfhRUksAoUn/KCDHK/suaFn/KErDfPMDF9aY/sxiewT25WmEYoDes6xLRuIPg4khkmGQFw==@kvack.org
X-Gm-Message-State: AOJu0YwqPwohuY/Rbetn94cCUudbSpHS2SFD3xgOnzCCdFvqp+JvKJGh
	vGw9FWc3SH3rF7LF8/2EWmLF3JIoLm4U5oKljFHTHprD/DliBPFW2yOxc3J385LcUDemViCDJFz
	utnHgZm3m1cp3cDLz4+QtB7oRRuFCnlpRsNzA7g7F
X-Gm-Gg: AY/fxX65UNZVxbOQM7Rx9rROvIzJ/F2THk2IPOxBO6pqhfSajcDQEwe4ZvphzPA0sLj
	VPmVyNXU+rHaDl29QW2idkKaVLq5iF2n6/7GG2RzHWiQpVVTbc/wDQIY9EhAUMwZWdBaLQYDhZk
	+/nB9jFvyPt0Ni0Ov+LkCX6K3KYEWCY7Ew9PWJ9xC4oJUJOEnuFk3S0nZUJ7dd/XIrSQ+4cyi4A
	cbXP9If3ykc4pj6rVtvlZ8jB8d/S4qfwopOzM2E8sb0nCAo5Ko2WO3Sm3R1wvUi9UiWNbjPQdlE
	TEIpzp39kSlBAmtbpPkuwXUMNg==
X-Google-Smtp-Source: AGHT+IEEN4AWGOx75npEubvSu4mCUXKcXIZgHx1LK0Y31u42UnqHzT4YTtI0ga8X/oxUo8uM9cnrKT9V0xnvF0Shwds=
X-Received: by 2002:a05:600c:82c3:b0:47a:8154:33e3 with SMTP id
 5b1f17b1804b1-47d84b5b4b4mr195755735e9.28.1768282402050; Mon, 12 Jan 2026
 21:33:22 -0800 (PST)
MIME-Version: 1.0
References: <20260109001127.2596222-1-jasonmiu@google.com> <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org>
In-Reply-To: <aWTJ2v9J-Aa6ykBf@kernel.org>
From: Jason Miu <jasonmiu@google.com>
Date: Mon, 12 Jan 2026 21:33:10 -0800
X-Gm-Features: AZwV_QiirD93hHTgP_r628fIv81n3_PDlKfZ1YgIy6hbB_xwpILRrNBnr0ZrVfU
Message-ID: <CAHN2nPL=wnqjici92Vj5Ub5w=xXN8CDfOVjOTUOWs4VeJC107Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory tracking
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F191B120004
X-Stat-Signature: 9atxggedm1k4pxetd3y36m1mawfgiq76
X-Rspam-User: 
X-HE-Tag: 1768282403-307008
X-HE-Meta: U2FsdGVkX1/DxjoVWIcz17iyhMmLaV1x9CGcYFUOGQ3EMWIQyVj7ctFGMTuahqk6ekDZJEgBNBVW6f+AQAQATh0YRXLmEF7WZ0PPsa1PBXHTeRwjtHSsHlrYNQwHM31Ou2rpUxJXA6xq370zoK25RINsIQBOwUcLjQBYcOzZxft6T0dLvx7NmZiq7GJrTJUJ3wkNw0QZ2Ewuk0dKiB4iiSVZ9ukOdfi53PJpX24wL7/jFbYtWvutVCN0VomdU8b8kERFfVEOoY5hS4q7+Z8BmuQpBhjThG3K/FYSPLcOVJljYc35RYlgWsIgNoHOIdYWZil56SrtMJ6pYf9es8tAPO8jojPG7WFFg1qPreG8T9buAM538VWbdujVsfiqfD5F7TF8WtWtQnrVvxcSl+jqAaBCMgcaWmYNJ8UH4QwmzrK5MRw0DaovwHwPh0+WRwFNOFLVAqE8ZWszb80W0ounn/5538d0ZfCileJfHq7TzSH5Xd7xt9LgG+AjAQMEbjxhFMcYiKszpLTTEPjrhi+7RPQnKVNZNU+CsRC4iVphE536LGW/h8nCb0esEuqs3dLlgSdPiN8QDdDO7r+03YXin0eMlS2aEFpbL6cHvkRxLdQi6a4zasNUJWWFSt7dS7eYD/nMjGkvz9fD8GVkKyzSVdfz1SnGUSuYxqQt9MKTltRlgArtiEGGJp+qa10gW3MO41GTyH+k1PVpEwzjW7wa+GzV1TB+z9o875XPpcl74wfUPMDfsCdy5nReeOpOXAT4HwvvndwNg+i9Dj+CtyzRiN6EpWjNzkKY2AWsLdDJYoIs73mhB1+ew2yUFznzRCkl3rvusI7ol4Mr2jW/PQNRAY2K4jMGf7W9CKt+IwQDT972ikO/LIXDgskW7Mwx3sI7WoQEmhpLBoDC15OWB67dmpcmeX+c9bQVy2hZKtzPfROnJBrccV4My2vpejLfSgz4/yseoAQ55AtlZwvZ4ax
 LviIxaoM
 OFGc6KRcneXR1CbcmJteVmzmDXUFuNPFTWKi9EDRbJzSznUQvBcpYJ2B0r1XmyRErZK3WMClXBtj2mZ7Pt8ia7W/IrNn44hGnzGpuvYSu2HUJz861u0TzVwIlCSy/IvT8c5DSsuvk1enLbul8/62TXvf4lSRLGfQJVGU4kvj2rQOEwzqYbXMZQPJYGsB6aHpqRgFxwg2Aa3JwnCNHi+eQH5adxKW0Uui4vque
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 2:16=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Jan 08, 2026 at 04:11:26PM -0800, Jason Miu wrote:
> > Introduce a radix tree implementation for tracking preserved memory
> > pages and switch the KHO memory tracking mechanism to use it. This
> > lays the groundwork for a stateless KHO implementation that eliminates
> > the need for serialization and the associated "finalize" state.
> >
...
>
> ...
>
> > +/**
> > + * DOC: KHO persistent memory tracker
> > + *
> > + * KHO tracks preserved memory using a radix tree data structure. Each=
 node of
> > + * the tree is exactly a single page. The leaf nodes are bitmaps where=
 each set
> > + * bit is a preserved page of any order. The intermediate nodes are ta=
bles of
> > + * physical addresses that point to a lower level node.
> > + *
> > + * The tree hierarchy is shown below::
> > + *
> > + *   root
> > + *   +-------------------+
> > + *   |     Level 5       | (struct kho_radix_node)
> > + *   +-------------------+
> > + *     |
> > + *     v
> > + *   +-------------------+
> > + *   |     Level 4       | (struct kho_radix_node)
> > + *   +-------------------+
> > + *     |
> > + *     | ... (intermediate levels)
> > + *     |
> > + *     v
> > + *   +-------------------+
> > + *   |      Level 0      | (struct kho_radix_leaf)
> > + *   +-------------------+
> > + *
> > + * The tree is traversed using a key that encodes the page's physical =
address
> > + * (pa) and its order into a single unsigned long value. The encoded k=
ey value
> > + * is composed of two parts: the 'order bit' in the upper part and the=
 'page
> > + * offset' in the lower part.::
> > + *
> > + *   +------------+-----------------------------+---------------------=
-----+
> > + *   | Page Order | Order Bit                   | Page Offset         =
     |
> > + *   +------------+-----------------------------+---------------------=
-----+
> > + *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + =
0)   |
> > + *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + =
1)   |
> > + *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + =
2)   |
> > + *   | ...        | ...                         | ...                 =
     |
> > + *   +------------+-----------------------------+---------------------=
-----+
> > + *
> > + * Page Offset:
>
> To me "page offset" reads as offset from somewhere and here it's rather p=
fn
> on steroids :)
> Also in many places in the kernel "page offset" refers to the offset insi=
de a
> page.
>
> Can't say I can think of a better name, but it feels that it should expre=
ss
> that this is an address more explicitly.
>

I updated this to "Shifted Physical Address," borrowing the idea from
Jason Gunthorpe. (Thank you =3D)

> > + * The 'page offset' is the physical address normalized for its order.=
 It
> > + * effectively represents the page offset for the given order.
> > + *
> > + * Order Bit:
> > + * The 'order bit' encodes the page order by setting a single bit at a
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
> > + * The following diagram illustrates how the encoded key value is spli=
t into
> > + * indices for the tree levels, with PAGE_SIZE of 4KB::
> > + *
> > + *        63:60   59:51    50:42    41:33    32:24    23:15         14=
:0
> > + *   +---------+--------+--------+--------+--------+--------+---------=
--------+
> > + *   |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (b=
itmap)  |
> > + *   +---------+--------+--------+--------+--------+--------+---------=
--------+
> > + *
> > + * The radix tree stores pages of all sizes (orders) in a single 6-lev=
el
>
> "sizes" can be misleading here because "all sizes" can mean non power-of-=
2
> sizes as well. I'd just use "pages of all orders".
>
> > + * hierarchy. It efficiently shares lower table levels, especially due=
 to
>
> Don't we share the higher levels? Also using "tree" instead of "table"
> seems clearer to me.
>
yes, updated.

> > + * common zero top address bits, allowing a single, efficient algorith=
m to
> > + * manage all pages. This bitmap approach also offers memory efficienc=
y; for
> > + * example, a 512KB bitmap can cover a 16GB memory range for 0-order p=
ages with
> > + * PAGE_SIZE =3D 4KB.
> > + *
> > + * The data structures defined here are part of the KHO ABI. Any modif=
ication
> > + * to these structures that breaks backward compatibility must be acco=
mpanied by
> > + * an update to the "compatible" string. This ensures that a newer ker=
nel can
> > + * correctly interpret the data passed by an older kernel.
> > + */
> > +
> > +/*
> > + * Defines constants for the KHO radix tree structure, used to track p=
reserved
> > + * memory. These constants govern the indexing, sizing, and depth of t=
he tree.
> > + */
> > +enum kho_radix_consts {
> > +     /*
> > +      * The bit position of the order bit (and also the length of the
> > +      * page offset) for an order-0 page.
> > +      */
> > +     KHO_ORDER_0_LOG2 =3D 64 - PAGE_SHIFT,
> > +
> > +     /* Size of the table in kho_radix_node, in log2 */
> > +     KHO_TABLE_SIZE_LOG2 =3D const_ilog2(PAGE_SIZE / sizeof(phys_addr_=
t)),
> > +
> > +     /* Number of bits in the kho_radix_leaf bitmap, in log2 */
> > +     KHO_BITMAP_SIZE_LOG2 =3D PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
> > +
> > +     /*
> > +      * The total tree depth is the number of intermediate levels
> > +      * and 1 bitmap level.
> > +      */
> > +     KHO_TREE_MAX_DEPTH =3D
> > +     DIV_ROUND_UP(KHO_ORDER_0_LOG2 - KHO_BITMAP_SIZE_LOG2,
> > +                  KHO_TABLE_SIZE_LOG2) + 1,
>
> Extra tab in indentation of DIV_ROUND_UP would make it more readable IMHO=
.
>
> > +};
> > +
> > +struct kho_radix_node {
> > +     u64 table[1 << KHO_TABLE_SIZE_LOG2];
> > +};
> > +
> > +struct kho_radix_leaf {
> > +     DECLARE_BITMAP(bitmap, 1 << KHO_BITMAP_SIZE_LOG2);
> > +};
> > +
> >  #endif       /* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
> > diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_t=
ree.h
> > new file mode 100644
> > index 000000000000..8f03dd226dd9
> > --- /dev/null
> > +++ b/include/linux/kho_radix_tree.h
> > @@ -0,0 +1,72 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _LINUX_KHO_ABI_RADIX_TREE_H
> > +#define _LINUX_KHO_ABI_RADIX_TREE_H
>
> I misinterpreted the file name during v3 review, no need for _ABI here :)
>
> > +#include <linux/err.h>
> > +#include <linux/errno.h>
> > +#include <linux/mutex_types.h>
> > +#include <linux/types.h>
>
> ...
>
> > +#ifdef CONFIG_KEXEC_HANDOVER
> > +
> > +int kho_radix_add_page(struct kho_radix_tree *tree, unsigned long pfn,
> > +                    unsigned int order);
> > +
> > +void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn=
,
> > +                     unsigned int order);
> > +
> > +int kho_radix_walk_tree(struct kho_radix_tree *tree, unsigned int leve=
l,
>
> I think 'level' and 'start' should not be a part of public API. We don't
> want to expose walking the tree from arbitrary place.
>

Sure, update the function implementation as well.

> > +                     unsigned long start, kho_radix_tree_walk_callback=
_t cb);
> > +
> > +#else  /* #ifdef CONFIG_KEXEC_HANDOVER */
>
> ...
>
> > +/**
> > + * kho_radix_decode_key - Decodes a radix key back into a physical add=
ress and order.
> > + * @key: The unsigned long key to decode.
> > + * @order: An output parameter, a pointer to an unsigned int where the=
 decoded
> > + *         page order will be stored.
> > + *
> > + * This function reverses the encoding performed by kho_radix_encode_k=
ey(),
> > + * extracting the original physical address and page order from a give=
n key.
> > + *
> > + * Return: The decoded physical address.
> > + */
> > +static phys_addr_t kho_radix_decode_key(unsigned long key,
> > +                                     unsigned int *order)
>
> Nit: *order can be on the same line as key
>
> >  {
>
> ...
>
> > +static unsigned long kho_radix_get_index(unsigned long key,
> > +                                      unsigned int level)
> > +{
> > +     int s;
> > +
> > +     if (level =3D=3D 0)
> > +             return kho_radix_get_bitmap_index(key);
>
> I'd drop this and use get_bitmap_index() explicitly for level-0.
> Maybe also rename _get_index() to _get_table_index().
>

The function name is udpated and the caller will call
kho_radix_get_bitmap_index() for bitmap level explicitly.

> > +
> > +     s =3D ((level - 1) * KHO_TABLE_SIZE_LOG2) + KHO_BITMAP_SIZE_LOG2;
> > +     return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
> > +}
>
> ...
>
> > +void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn=
,
> > +                     unsigned int order)
> > +{
> > +     unsigned long key =3D kho_radix_encode_key(PFN_PHYS(pfn), order);
> > +     struct kho_radix_node *node =3D tree->root;
> > +     struct kho_radix_leaf *leaf;
> > +     unsigned int i, idx;
> > +
> > +     if (WARN_ON_ONCE(!tree->root))
> > +             return;
> > +
> > +     might_sleep();
> > +
> > +     guard(mutex)(&tree->lock);
> > +
> > +     /* Go from high levels to low levels */
> > +     for (i =3D KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
> > +             idx =3D kho_radix_get_index(key, i);
> > +
> > +             /*
> > +              * Attempting to delete a page that has not been preserve=
d,
> > +              * return with a warning.
> > +              */
> > +             if (WARN_ON(!node->table[idx]))
> > +                     return;
> > +
> > +             if (node->table[idx])
>
> There's already WARN_ON(!node->table) and return, no need for another if
> here.
>
> > +                     node =3D phys_to_virt((phys_addr_t)node->table[id=
x]);
> > +     }
> > +
> > +     /* Handle the leaf level bitmap (level 0) */
> > +     leaf =3D (struct kho_radix_leaf *)node;
> > +     idx =3D kho_radix_get_index(key, 0);
> > +     __clear_bit(idx, leaf->bitmap);
>
> I think I already mentioned it in earlier reviews, but I don't remember a=
ny
> response.
>
> How do we approach freeing empty bitmaps and intermediate nodes?
> If we do a few preserve/uppreserve cycles for memory that can be allocate=
d
> and freed in between we might get many unused bitmaps.
>
> My view is that we should free the empty bitmaps, maybe asynchronously.
> The intermediate nodes probably don't take that much memory to bother wit=
h
> them.
>

I think memory preserving and than unpreserving is not a common use
case. I suggest keeping the current simpler implementation instead of
doing the cleanup, we can address this memory usage optimization
later. If we implement this, I tend to clean up all the empty bitmaps
and intermediate nodes to avoid incomplete tree traversing paths.

> > +}
> > +EXPORT_SYMBOL_GPL(kho_radix_del_page);
>
> ...
>
> > +/**
> > + * kho_radix_walk_tree - Traverses the radix tree and calls a callback=
 for each preserved page.
> > + * @tree: A pointer to the KHO radix tree to walk.
> > + * @level: The starting level for the walk (typically KHO_TREE_MAX_DEP=
TH - 1).
> > + * @start: The initial key prefix for the walk (typically 0).
> > + * @cb: A callback function of type kho_radix_tree_walk_callback_t tha=
t will be
> > + *      invoked for each preserved page found in the tree. The callbac=
k receives
> > + *      the physical address and order of the preserved page.
> > + *
> > + * This function walks the radix tree, searching from the specified to=
p level
> > + * (@level) down to the lowest level (level 0). For each preserved pag=
e found,
> > + * it invokes the provided callback, passing the page's physical addre=
ss and
> > + * order.
> > + *
> > + * Return: 0 if the walk completed the specified tree, or the non-zero=
 return
> > + *         value from the callback that stopped the walk.
> > + */
> > +int kho_radix_walk_tree(struct kho_radix_tree *tree, unsigned int leve=
l,
> > +                     unsigned long start, kho_radix_tree_walk_callback=
_t cb)
> > +{
> > +     if (WARN_ON_ONCE(!tree->root))
> > +             return -EINVAL;
> > +
> > +     guard(mutex)(&tree->lock);
> > +
> > +     return __kho_radix_walk_tree(tree->root, level, start, cb);
>
> Like I said, let's make it
>
>         return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, =
0, cb);
>
> and drop level and start parameters.
>
> > +}
> > +EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
>
> ...
>
> > @@ -260,11 +388,20 @@ static struct page *kho_restore_page(phys_addr_t =
phys, bool is_folio)
> >
> >       /* Clear private to make sure later restores on this page error o=
ut. */
> >       page->private =3D 0;
> > +     /* Head page gets refcount of 1. */
> > +     set_page_count(page, 1);
> >
> > -     if (is_folio)
> > -             kho_init_folio(page, info.order);
> > -     else
> > -             kho_init_pages(page, nr_pages);
> > +     /*
> > +      * For higher order folios, tail pages get a page count of zero.
> > +      * For physically contiguous order-0 pages every pages gets a pag=
e
> > +      * count of 1
> > +      */
> > +     ref_cnt =3D is_folio ? 0 : 1;
> > +     for (unsigned int i =3D 1; i < nr_pages; i++)
> > +             set_page_count(page + i, ref_cnt);
> > +
> > +     if (is_folio && info.order)
> > +             prep_compound_page(page, info.order);
>
> It looks like this reverts latest Pratyush's changes to kho_restore_page(=
),
> please rebase on a newer version of mm.git/linux-next.git.
>

Yes, sync-ed again.

> >
> >       adjust_managed_page_count(page, nr_pages);
> >       return page;
>
> ...
>
> > +static int __init kho_radix_memblock_reserve(phys_addr_t phys,
> > +                                          unsigned int order)
>
> I don't think _radix should be mentioned in the callback at all.
> How about
>
> kho_preserved_memory_reserve()?
>
> >  {
>
> ...
>
> > +     /* Reserve the memory preserved in KHO radix tree in memblock */
>
>         /* Reserve memory preserved by KHO in memblock */
>
> What data structure is used to track the preserved memory is not importan=
t
> here.
>
> > +     memblock_reserve(phys, sz);
> > +     memblock_reserved_mark_noinit(phys, sz);
> > +     info.magic =3D KHO_PAGE_MAGIC;
> > +     info.order =3D order;
> > +     page->private =3D info.page_private;
> >
> >       return 0;
> >  }
>
> ...
>
> >  static __init int kho_out_fdt_setup(void)
> >  {
> > +     struct kho_radix_tree *tree =3D &kho_out.radix_tree;
> >       void *root =3D kho_out.fdt;
> > -     u64 empty_mem_map =3D 0;
> > +     u64 preserved_mem_tree_pa;
> >       int err;
> >
> >       err =3D fdt_create(root, PAGE_SIZE);
> >       err |=3D fdt_finish_reservemap(root);
> >       err |=3D fdt_begin_node(root, "");
> >       err |=3D fdt_property_string(root, "compatible", KHO_FDT_COMPATIB=
LE);
> > -     err |=3D fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_=
mem_map,
> > -                         sizeof(empty_mem_map));
> > +
> > +     scoped_guard(mutex, &tree->lock) {
>
> This runs exactly one time on boot and there's no place in the code that
> can concurrently change tree->root.
>

Updated and I understand the idea. Personally I think having a mutex
lock always when accessing the tree makes the logic symmetric, but
this change is certainly more optimal. =3D)

> > +             preserved_mem_tree_pa =3D (u64)virt_to_phys(tree->root);
>
> I don't think we should cast phys_addr_t to u64.
>
> > +     }
> > +
> > +     err |=3D fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
> > +                         &preserved_mem_tree_pa,
> > +                         sizeof(preserved_mem_tree_pa));
> > +
> >       err |=3D fdt_end_node(root);
> >       err |=3D fdt_finish(root);
> >
> > @@ -1332,16 +1329,26 @@ static __init int kho_out_fdt_setup(void)
> >
> >  static __init int kho_init(void)
> >  {
> > +     struct kho_radix_tree *tree =3D &kho_out.radix_tree;
> >       const void *fdt =3D kho_get_fdt();
> >       int err =3D 0;
> >
> >       if (!kho_enable)
> >               return 0;
> >
> > +     scoped_guard(mutex, &tree->lock) {
>
> No need for lock here. If anything tries to access the tree before the ro=
ot
> is allocated we are anyway doomed.
>
> > +             tree->root =3D (struct kho_radix_node *)
> > +                     kzalloc(PAGE_SIZE, GFP_KERNEL);
>
> No need for casting from void *.
>
> > +             if (!tree->root) {
> > +                     err =3D -ENOMEM;
> > +                     goto err_free_scratch;
> > +             }
> > +     }
>
> --
> Sincerely yours,
> Mike.

Thanks again, sending out the v5 patches.

--
Jason Miu

