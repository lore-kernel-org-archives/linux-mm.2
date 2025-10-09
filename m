Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12190CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 02:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64EE38E005C; Wed,  8 Oct 2025 22:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF8B8E0002; Wed,  8 Oct 2025 22:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7118E005C; Wed,  8 Oct 2025 22:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35FD08E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 22:07:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B41EC46546
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:07:33 +0000 (UTC)
X-FDA: 83976939186.21.8C2AA85
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id C50FB4000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:07:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T3udmLLD;
	spf=pass (imf12.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOYj62ptF6atgMYt5r0y+73WXkLSYqfPTH3G+5RzDpE=;
	b=117nnxYYXGCfVazE2F+2kv3Ww55GEVz3+MFsjxuz+IYqLzQ3fBihWkAlunc1z233zftmEB
	vX+w+KcDALghTFPrvHNr+m2eMK2d63EP/V1XYqM3o8psvQUtRlRpQQjfqFLO3XG7m8beMM
	n20zVH90UibP/KTgoj5hS3kA1gDKSdo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T3udmLLD;
	spf=pass (imf12.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975651; a=rsa-sha256;
	cv=none;
	b=i4asGowdYM2d6Rmq/3UR6Z+iHWyRuPS6/SS8a1NFrTyrAVpAyg5xM2FupmolXSNrq2AiP2
	Z/fimOHC5cxPUHWKmnYi8EjRSRV9iCtfE+i7/Iumepim3wG+2HaR9ZksyIQ3JdElLT70hJ
	Jk+S67X9MPvYf0YXTKXuOrAXfe5kYAQ=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-41174604d88so211332f8f.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 19:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759975650; x=1760580450; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOYj62ptF6atgMYt5r0y+73WXkLSYqfPTH3G+5RzDpE=;
        b=T3udmLLDRepMMZIfKQPioz5W6B3Ep6vMAGYZcjbbFnIlxvTENrcd+JgiW3MikD+AUT
         wAOeQbHl2VSOHkqEzO/JRimGXkfOUPSz4HfIZtpxxUpepnRSvPS/zIxDaaLN5fHojP3N
         Za+1w5yF55JVXs7C8hXdXlQV7NZ3EAjLz2v6oASjc5RRNU5VJfsiB6pEssfCe12L++pF
         jhe5XfwqOYPJe2BHs5pwz+FvMAtTLnNzLF+5VniP3IsusWglpNTqkHdLRefaW6qQF0fA
         HGuUKG6rlNTXU2Y8SXsi467j+w12hAIEuAcSH9lrBcPdSUEYR1uLW1PunfE+RqM388f2
         3BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975650; x=1760580450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOYj62ptF6atgMYt5r0y+73WXkLSYqfPTH3G+5RzDpE=;
        b=W+Vb8U4YOV8SUAc99+zP1GlJI5WWC/wgBK1nocp+eaHw9XweEjRL+ffDEq8QPOGNQg
         DumS9OJco/5CFjYHgPJs+wAdZeHTwPsBmW4M24US0QzWlJPFDsopHEA+a0xh6yVBNXNw
         3Hxz+9bDUOMZ7yBcPqn6Wp2BCrytGEz5k+7wEoIVONeM84K3zYbYo1I2HIFqKhgqwPEr
         9chEe58GcKY3ozxixpjqqaKuCgMoJeKiuZuKmpRdbvphIk8mJ2QcZhlGQWB4EjZC6Boa
         MXSGkWpi4MBcKQmBLHMjW3lPu5qE+vCVJIlGvwSBf6gHxWCSFhI5P4TS+WctqcAsRObF
         J7og==
X-Forwarded-Encrypted: i=1; AJvYcCXkk9kAleHMm7WLHtTkGvhy3M4zptGLwqwNtXl4CtsDM6KlaVRbqRZ9zR3Hro8b1yKZy0fDayP+/g==@kvack.org
X-Gm-Message-State: AOJu0YxF/3ENPoNgiCMy2VhvTB/PSuFdT3R/RZg35JLIRRJYPhy5Cfby
	cdvqOyFN05NfUTcrjm/2rcuCWNCBZJgy7yanRbqa+BejeGJre4frSeBl1S/aB3IcvL6OS0/8QM5
	g+zMwy2d1L+EShCgg5O6Cs4RIqOThKoV1T93+n+aq
X-Gm-Gg: ASbGncs/afKOTEa5skatdmW+o4PCpDOOH9DbMeW5XmrBfSe+nONgeJXgj+Mj7ZlEDug
	UWh3OlcMsfL0Nc7Z3Fp0+Bp4GmQU1nh1Kpr9RqbxP+GLu5s0NRkXsOaWmdP3n3HrRHavZYCHTBU
	LjMOAkFYsMQturS/d6nZWPS30gtoHsnKD7uQu5xdswG1pjWDMOWfYcgMDtmneO1q5wwMKMIo34U
	y0iHe3+HmBTUJyuItiHciMLEW2ioV718NdsBKh+N2NLLib4Z1NH+3LQu7OHcQn/vlnLDhRzEXf+
	6hw=
X-Google-Smtp-Source: AGHT+IHFGBlwkyomkdGP+02MpVf0OmgYgkGJzmO0wXhaXnPevK+aEz3O3W5DnuNfHGv90uQYvqNSpuGSu7q/Lmv5aj8=
X-Received: by 2002:a05:6000:4202:b0:425:7346:d1b6 with SMTP id
 ffacd0b85a97d-42667177b78mr3443459f8f.17.1759975649815; Wed, 08 Oct 2025
 19:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251001011941.1513050-1-jasonmiu@google.com> <20251001011941.1513050-2-jasonmiu@google.com>
 <20251006141444.GN3360665@nvidia.com>
In-Reply-To: <20251006141444.GN3360665@nvidia.com>
From: Jason Miu <jasonmiu@google.com>
Date: Wed, 8 Oct 2025 19:07:18 -0700
X-Gm-Features: AS18NWB4PW66azTKpAtdJovUwEfqAjBAxqz9kEyCAdzq27GwUtBpfhjUIx6ym0g
Message-ID: <CAHN2nPKjg6=0QTcSoptxvQW9MpP0YwGUTx_gQDBxgCtSzxY5Pg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] kho: Adopt KHO radix tree data structures
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ag8offrsapx5u1tjrprg61s5wy8rx8kr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C50FB4000C
X-HE-Tag: 1759975651-821810
X-HE-Meta: U2FsdGVkX19gz0t6wmUJcjWJm720PfflCA/rUOUCCzBY4z8tV3sadU3sKDvl/hWTGIWafiRV//rEzSR7o5mkD9DCDDD3oZsvY5oME0CuCRpCAC99dIceuKj6qICFHX5+xloZSwhthIHVvc/kaicHeRz0y+ZP0rB6JYuxG2dkYfE8JzPbUgnyHbVL0ciUFQq9KM5l6XaF4eZzRs34wbyfADoHqI2wYpfA5EOBHmTxCbDeIO7jQAqAyVawO50p1MIaSCAUCHk/d9MOperk0a3UpFWZravPjUyFHjHh6tIlYstVcO7Q8HXrRVZLWE55crkJMQLFwM4Pj6y0jXqb14m39BEDInlBWkxlHp2rW/TAkCbbhzFN0pTXS93BghMNYDpzrbaZ/nkh4zB5Qcw4enUn/eHd/DdCs6UnCD9Q+/mmznGB89bKC4asiwA+WTkpd+hQcqkgQtSf3GcYd9getGwyKAwL1tQ/fx3mf5JgAt1Cf04kcXAmUgU2IbkNoZoa+f79VZDR+s9DvRGi5XO2uoEmkt2Ct3eHa3KX4CuazVktDOxOXAu2vCREddQxuFrZPOa12sb06J7nClYhKqM8ZY9dyI6lSvMCVwf5KFW/aHE/MF2nfP+fF5nQ2AOFoJDNSIhbEwB8llZHnl00TFunBYHz7wvP48X5AjCtq7GDIP+xiLn0zX5Mz+mWr60sqA92zX4leycUz2QIzdC4hAxEMVikw2f4l+mBjshkdWbn+JSzHGoMWQo0kmZrIJE0MXoyLmqWNALI6E+Q8LnbCW1yT9Dvwbiy0K/vVlbXBilAKF81GrSeEEGfI2zt6KZsqtJsXckHGx2M7kYDsfPA8u93mo0xDHMzyI29f2ssZx4kmsbM4dbs7QPWbtS1tqa6jXFj3ZGmIp8KgEvY/hqpNDWI2A0FHnZ7LzNHxFTJq0t4PTKtWwltEBQyM1BlV6P5UP/rdxUVokOQRHYi1d3CUH2HfWk
 H/rzYBIb
 GdM4wZqmqe1KE2DIVrj5ypJ4NpM0UuEMHlWlxNXjt7JkpQv6t0nzVKI3Wcj9P3IACQPoIjDwdkydyBkTM7J2NTvSTETho0crjSZMlDgNzHt41BfA/eaQGvophMhgY4DNTjUV3IstwL7nMPcGRQSTSQwx/FW3Sf7J4d6wKUsHN+lw/2S4VE9tnAEUAmVAvPBriTFjkB9RsuqiEUhlDlQzL7/rMqLzNPZ8sgEBY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

Thank you very much for your feedback again.

On Mon, Oct 6, 2025 at 7:14=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
> >  #define KHO_FDT_COMPATIBLE "kho-v1"
>
> We don't bump this?
Will do. Will be "kho-v2".

>
> > -#define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
> > +#define PROP_PRESERVED_PAGE_RADIX_TREE "preserved-page-radix-tree"
> >  #define PROP_SUB_FDT "fdt"
>
> I'de really like to see all of these sorts of definitions in some
> structured ABI header not open coded all over the place..

Do you think `include/linux/kexec_handover.h` is the appropriate
place, or would you prefer a new, dedicated ABI header (e.g., in
`include/uapi/linux/`) for all KHO-related FDT constants?


>
> >   */
> > +struct kho_radix_tree {
> > +     unsigned long table[PAGE_SIZE / sizeof(unsigned long)];
>
> This should be phys_addr_t.
>
> > +};
>
> You dropped the macros so now we don't know these are actually
> pointers to 'struct kho_radix_tree'
>

Agreed. Will change `u64` according to Pasha's comment. And we use
explicit casts like `(u64)virt_to_phys(new_tree)` and `(struct
kho_radix_tree *)phys_to_virt(table_entry)` in the current series. I
believe this, along with the `u64` type, makes it clear that the table
stores physical addresses.


> > +static int kho_radix_tree_max_depth(void)
> > +{
> > +     int page_offset_bit_num =3D BITS_PER_LONG - PAGE_SHIFT;
> > +     int order_bit_num =3D ilog2(__roundup_pow_of_two(page_offset_bit_=
num));
> > +     int bitmap_bit_num =3D PAGE_SHIFT + ilog2(BITS_PER_BYTE);
> > +     int table_bit_num =3D ilog2(PAGE_SIZE / sizeof(unsigned long));
> > +     int table_level_num =3D DIV_ROUND_UP(page_offset_bit_num -
> > +                                        bitmap_bit_num + order_bit_num=
,
> > +                                        table_bit_num);
>
> All should be unsigned int. Below I suggest to put it in an enum and
> use different names.. And since the function is constant it can just
> be an enum TOP_LEVEL too.
>

Yes I did think of returning a const for `kho_radix_tree_max_depth()`.
I think using enums is a better idea and I can place all above values
as enums.


> > + */
> > +static unsigned long kho_radix_encode(unsigned long pa, unsigned int o=
rder)
>
> pa is phys_addr_t in the kernel, never unsigned long.
>
> If you want to make it all dynamic then this should be phys_addr_t

Should this also be `u64`, or we stay with `phys_addr_t` for all page
addresses?

>
> > +{
> > +     unsigned long h =3D 1UL << (BITS_PER_LONG - PAGE_SHIFT - order);
>
> And this BITS_PER_LONG is confused, it is BITS_PER_PHYS_ADDR_T which
> may not exist.
>
> Use an enum ORDER_0_LG2 maybe

I prefer `KHO_RADIX_ORDER_0_BIT_POS` (defined as `BITS_PER_LONG -
PAGE_SHIFT`) over `ORDER_0_LG2`, as I think the latter is a bit hard
to understand, what do you think? This constant, along with others,
will be placed in the enum.

>
> > +     unsigned long l =3D pa >> (PAGE_SHIFT + order);
> >
> > +     return h | l;
> > +}
> >
> > +static unsigned long kho_radix_decode(unsigned long encoded, unsigned =
int *order)
>
> Returns phys_addr_t
>
> >  {
> > -     void *elm, *res;
> > +     unsigned long order_bit =3D fls64(encoded);
>
> unsigned int
>
> > +     unsigned long pa;
>
> phys_addr_t
>
> > +     *order =3D BITS_PER_LONG - PAGE_SHIFT - order_bit + 1;
>
> ORDER_0_LG2
>
> > +     pa =3D encoded << (PAGE_SHIFT + *order);
>
> I'd add a comment that the shift always discards order.
>
> > +     return pa;
> > +}
> >
> > +static unsigned long kho_radix_get_index(unsigned long encoded, int le=
vel)
>
> unsigned int level
>
> > +{
> > +     int table_bit_num =3D ilog2(PAGE_SIZE / sizeof(unsigned long));
> > +     int bitmap_bit_num =3D PAGE_SHIFT + ilog2(BITS_PER_BYTE);
>
> Stick all the constants that kho_radix_tree_max_depth() are computing
> in an enum instead of recomputing them..
>
> > +     unsigned long mask;
> > +     int s;
>
> unsigned for all of these.
>
> > +
> > +     if (level =3D=3D 1) {
>
> I think the math is easier if level 0 =3D=3D bitmap..
>
> > +             s =3D 0;
> > +             mask =3D (1UL << bitmap_bit_num) - 1;
> > +     } else {
> > +             s =3D ((level - 2) * table_bit_num) + bitmap_bit_num;
>
> eg here you are doing level-2 which is a bit weird only because of the
> arbitary choice to make level=3D1 be the bitmap.
>
> I'd also use some different names
>
> table_bit_num =3D=3D TABLE_SIZE_LG2
> BITMAP_BIT_NUM =3D BITMAP_SIZE_LG2
>
> Log2 designates the value is 1<<LG2

Good point on the level numbering, we'll switch to 0-based where level
0 is the bitmap. The modulo operations you suggested play nicely with
the 0-based numbering too, thanks. Will also update the names and put
them in enum.
>
> > +             mask =3D (1UL << table_bit_num) - 1;
> >       }
> >
> > -     return elm;
> > +     return (encoded >> s) & mask;
>
> It is just:
>
> return encoded % (1 << BITMAP_SIZE_LG2);
> return (encoded >> s) % (1 << TABLE_SIZE_LG2);
>
> The compiler is smart enough to choose bit logic if that is the
> fastest option and the above is more readable.
>
> > +static int kho_radix_set_bitmap(struct kho_bitmap_table *bit_tlb, unsi=
gned long offset)
> >  {
> > +     if (!bit_tlb ||
> > +         offset >=3D PAGE_SIZE * BITS_PER_BYTE)
> > +             return -EINVAL;
> >
> > +     set_bit(offset, bit_tlb->bitmaps);
>
> set_bit is an atomic, you want __set_bit()
>
> > +     return 0;
> > +}
> >
> > +static int kho_radix_preserve_page(unsigned long pa, unsigned int orde=
r)
>
> phys_addr_t
>
> > +{
> > +     unsigned long encoded =3D kho_radix_encode(pa, order);
> > +     int num_tree_level =3D kho_radix_tree_max_depth();
>
> kho_radix_tree_max_depth() is constant, stick it in an enum with the
> rest of them.
>
> > +     struct kho_radix_tree *current_tree, *new_tree;
> > +     struct kho_bitmap_table *bitmap_table;
> > +     int err =3D 0;
> > +     int i, idx;
>
> various unsigned int.
>
> >
> > +     down_write(&kho_radix_tree_root_sem);
> >
> > +     current_tree =3D kho_radix_tree_root;
> >
> > +     /* Go from high levels to low levels */
> > +     for (i =3D num_tree_level; i >=3D 1; i--) {
> > +             idx =3D kho_radix_get_index(encoded, i);
> > +
> > +             if (i =3D=3D 1) {
> > +                     bitmap_table =3D (struct kho_bitmap_table *)curre=
nt_tree;
> > +                     err =3D kho_radix_set_bitmap(bitmap_table, idx);
> > +                     goto out;
> > +             }
> > +
> > +             if (!current_tree->table[idx]) {
> > +                     new_tree =3D kho_alloc_radix_tree();
> > +                     if (!new_tree) {
> > +                             err =3D -ENOMEM;
> > +                             goto out;
> > +                     }
> > +
> > +                     current_tree->table[idx] =3D
> > +                             (unsigned long)virt_to_phys(new_tree);
>
> current_tree =3D new_tree
> > +             }
>
> else
>
> > +
> > +             current_tree =3D (struct kho_radix_tree *)
> > +                     phys_to_virt(current_tree->table[idx]);
> >       }
> > +
> > +out:
> > +     up_write(&kho_radix_tree_root_sem);
> > +     return err;
> >  }
> >
> > +static int kho_radix_walk_bitmaps(struct kho_bitmap_table *bit_tlb,
> > +                               unsigned long offset,
>
> phys_addr_t
>
> > +                               kho_radix_tree_walk_callback_t cb)
> >  {
> > +     unsigned long encoded =3D offset << (PAGE_SHIFT + ilog2(BITS_PER_=
BYTE));
> > +     unsigned long *bitmap =3D (unsigned long *)bit_tlb;
> > +     int err =3D 0;
> > +     int i;
> >
> > +     for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> > +             err =3D cb(encoded | i);
> > +             if (err)
> > +                     return err;
> > +     }
> >
> > +     return 0;
> > +}
> >
> > +static int kho_radix_walk_trees(struct kho_radix_tree *root, int level=
,
>
> unsigned int
>
> > +                             unsigned long offset,
>
> phys_addr_t.  I would call this start not offset..
>
> > +                             kho_radix_tree_walk_callback_t cb)
> > +{
> > +     int level_shift =3D ilog2(PAGE_SIZE / sizeof(unsigned long));
> > +     struct kho_radix_tree *next_tree;
> > +     unsigned long encoded, i;
> > +     int err =3D 0;
> >
> > +     if (level =3D=3D 1) {
> > +             encoded =3D offset;
> > +             return kho_radix_walk_bitmaps((struct kho_bitmap_table *)=
root,
> > +                                           encoded, cb);
>
> Better to do this in the caller  a few lines below

But the caller is in a different tree level? Should we only walk the
bitmaps at the lowest level?

>
> > +     }
>
> >
> > +     for (i =3D 0; i < PAGE_SIZE / sizeof(unsigned long); i++) {
> > +             if (root->table[i]) {
> > +                     encoded =3D offset << level_shift | i;
>
> This doesn't seem right..
>
> The argument to the walker should be the starting encoded of the table
> it is about to walk.
>
> Since everything always starts at 0 it should always be
>   start | (i << level_shift)
>
> ?

You're right that this line might not be immediately intuitive. The
var `level_shift` (which is constant value 9 here) is applied to the
*accumulated* `offset` from the parent level. Let's consider an
example of a preserved page at physical address `0x1000`, which
encodes to `0x10000000000001` (bit 52 is set for order 0, bit 0 is set
for page 1).

If we were to use `start | (i << level_shift)` where `level_shift` is
a constant 9, and `start` is the value from the parent call:
  - At Level 6, `start` is `0`. `i` is 2 as bit 51:59 =3D 2. Result: `0
| (2 << 9) =3D 0x400`. This is passed to Level 5.
  - At Level 5, `start` is `0x400`, `i` is 0 as bit 50:42 =3D 0. Result:
`0x400 | (0 << 9) =3D 0x400`. This is passed to Level 4.
  - At Level 4, `start` is `0x400`, `i` is 0 as bit 33:41 =3D 0. Result:
`0x400 | (0 << 9) =3D 0x400`. And so on.

As you can see, the encoded value is not correctly reconstructed. This
will work if the `level_shift` represents the total shift from the LSB
for each specific level, but it is not the case here.

I will, however, add a detailed comment to `kho_radix_walk_trees` to
clarify this logic. I also agree to change the name of `offset` to
make it more clearer, how about `base_encoded`, or do you still prefer
`start`?

>
> > +                     next_tree =3D (struct kho_radix_tree *)
> > +                             phys_to_virt(root->table[i]);
> > +                     err =3D kho_radix_walk_trees(next_tree, level - 1=
, encoded, cb);
> >                       if (err)
> >                               return err;
> >               }
> >       }
> >
> > +     return 0;
> > +}
> >
> > +static int kho_memblock_reserve(phys_addr_t pa, int order)
> > +{
> > +     int sz =3D 1 << (order + PAGE_SHIFT);
> > +     struct page *page =3D phys_to_page(pa);
> > +
> > +     memblock_reserve(pa, sz);
> > +     memblock_reserved_mark_noinit(pa, sz);
> > +     page->private =3D order;
> >
> >       return 0;
> >  }
> >
> > +static int kho_radix_walk_trees_callback(unsigned long encoded)
> > +{
> > +     unsigned int order;
> > +     unsigned long pa;
> > +
> > +     pa =3D kho_radix_decode(encoded, &order);
> > +
> > +     return kho_memblock_reserve(pa, order);
> > +}
> > +
> > +struct kho_serialization {
> > +     struct page *fdt;
> > +     struct list_head fdt_list;
> > +     struct dentry *sub_fdt_dir;
> > +};
> > +
> > +static int __kho_preserve_order(unsigned long pfn, unsigned int order)
> > +{
> > +     unsigned long pa =3D PFN_PHYS(pfn);
>
> phys_addr_t
>
> Jason

Will do the update in the next patch version. Thanks again.

--
Jason Miu

