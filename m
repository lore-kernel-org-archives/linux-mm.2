Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D783C1091930
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B8F6B04AD; Thu, 19 Mar 2026 19:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451106B04AE; Thu, 19 Mar 2026 19:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366E26B04B2; Thu, 19 Mar 2026 19:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 264C46B04AD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:49:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C54BABB035
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:49:11 +0000 (UTC)
X-FDA: 84564456102.16.60DCE7F
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE44CC0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:49:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mj6tJyKq;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773964148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DlEPbCLDVpmn0/Q4nWSHyM9JBVmBy6y7Z8PevIioZU=;
	b=fXhS/Wbv9YPNZgVjq3/9OEGlbXUDwtFaTfVRiVgJRaR2tR3qe/RofI/+jfAUjV2cgeJeSS
	AA+cdcmXwuAFGDXkPON/zj6UoCMZLr6CilXbmV1OzX0ndhbE629WITwF4RtfCjXHoUK4LM
	ee6PDBSIYogMsk2XddzvEtH9EsgrcGg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mj6tJyKq;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773964148; a=rsa-sha256;
	cv=pass;
	b=Hs7A0exoIgv7TWiFy0t1G9U4NiRkbNYB46ZVVOmovFjGJuo0IgrAvRj0/+w4zP3GC3iU0b
	2Flpv39CR/DQycfqEcMMXvOqO2ZuQoyJBsIiomJn7UiimRAUdt3qaMZQEEG3DHPwFwRa9V
	fT5eRArHg8alHUjDcw48eGRwzzPe4qM=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6628cc1bd69so2493a12.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:49:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773964147; cv=none;
        d=google.com; s=arc-20240605;
        b=lGEoGbVg1E4Dh1IdLboM9s0m9wVGaLolJQoh8oyWYMrPxSHsHGa1nXWcB5/Cyiwtld
         6PNsiKo04qu1wMnVujUxkvzFKePXByzxJEbv0eTlGkWJFoc3jcGdFm+O67KxEhEFOl5O
         b/9oDRARBrdgFzlNi5V9UgLZAegyENcGp+3q1UFkqi9qyL2PZ/ePLS/1k7p584QqWqJn
         QpzA6WtCQNM6u4tgJaNqjpWyi466FwDg9b1yjFI8YMbuEP/OKOcWI/n5i41h1tk1wyEI
         qDryRG1dOOjnm7jwlPc+Ye4KZU4IdwmYfOb6WDZ2waW8GABurg2Jt0IT758QhSBXNX6h
         v12Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3DlEPbCLDVpmn0/Q4nWSHyM9JBVmBy6y7Z8PevIioZU=;
        fh=madyjFsaK8809gu0baxyQVODPh/uFrbr69EcQTgFAsM=;
        b=dtFq6gxfDWb9Jg1jRDZw1z5A+mwG3cBaTCHK4LZNutPULCjJl7JrMPgmZq2iEGfcUi
         g9W+HtE8yh5q6Bd+fu8q6z5FRmhGAdJmhNA6KtnKKcl7D9kucoib4SzPnbzwOfEaA5qk
         zcgcItEyd7K4ha+xw+TSLEc1Ja4GgTE29P9Rp0mZmG2EvcGERn5LYbqj3dThbJzMV/9V
         WWvZxM0vvcufdw2R/LzvLff6rQinMUefDR9TfWMhROq8rr7cUpQn/716aeHX2PBUCa7S
         BajQywEhW/0rO2ETbdGzs7eKAZxqgUBKruqQ40pe8j+kcv5IBklwJOilkd/o5TGs/wTn
         Vf1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773964147; x=1774568947; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DlEPbCLDVpmn0/Q4nWSHyM9JBVmBy6y7Z8PevIioZU=;
        b=Mj6tJyKqZO2YUY2YeNf3fLlYCjiDWil2wqcjHaDfuAeUCTYtpMo3vIJQ+kOTHfGYtQ
         GZ64U+cWuO5x2h6x0ilx3EjBX7zMQw9AGo9XdxyCydWFrnqo+2rmzaH+Zn3U0/XbhaT7
         H0nEqrXZdFYSEZmHgoEvEuqMPY220ifjLgX1M8SiGnV0wVG/XD83P9ww7uEhP+AMc1VP
         hiZu63Xo5SHRzqerceIt2/WiowuYCKPMwFyAAR7oH0CNXAAjsR9zPTxbeUnB6Raz+3Xv
         pBWeFFFS78LpFSeTwgUA7LdFtaDg7RdaSOSy1u7Q0TXulmRCtaPalPMaUquzyx78mXMP
         GSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773964147; x=1774568947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3DlEPbCLDVpmn0/Q4nWSHyM9JBVmBy6y7Z8PevIioZU=;
        b=lCrv2OkDa4zUtJorTLnlOP5PIimKtHZO6VptVvHYt3c7DDGkOVT9PjboRE6Qpzed0g
         S6ZRRe1h0HGSn8pO1hmGmdK52n+y96qLzzTFnmx29w3gY6wmP1QKrp6FYIf96d3jd1xk
         XSKcpafAOYWsnrEeQzERTBSW47PoktEyaksbv6Ge7zZD/QKINTUGLN3oSW8hrRHeK9FX
         GWhG0XQi8Asa1wfYnytnrAGFpZlxueq/9CfM4qVTnNVpxs1m0X0trBnGQlpIt4EWNHgD
         7jlCQbL/zWKOVCLZ/Kx7dydFkr9FAydvpZ169AEy6QeFHrNUVKsSuVOnjMolfUS0H9gS
         4ZSg==
X-Forwarded-Encrypted: i=1; AJvYcCXFS/femHa4SzdFbXAFms1VootjE6z9jOWI52GLZN+pK2e86aCyM5barb1OYx9eqXyuxRQM2W2SsQ==@kvack.org
X-Gm-Message-State: AOJu0YzA3CowXU9KEq79T0yjWLiDXVtZ2vxxODqh4KOObhT5dZGu91WG
	DxkmYIhYwZf5owaDh9DxmH+saOVe0X7pj+/nwxhHPJh4/4ze0O401/IF58x+kkJ0BAtzfsrRden
	oiSIg7en/E3P02QsodpXk/IJjWNWhY8JqChRUehdy
X-Gm-Gg: ATEYQzycHGzybRlaXEBeNIGCGblDWq6RaKPrQDs1tIXWHfBlWiyNNlWgfnZZewWVyBa
	b2awXqHu7IQDFMNn96m8FXIDSegWjUBEoK0HPzEbrim+ezD8U3kajvf9vkKrWzv56t87nZXlzGj
	P1El3l4/p/4pB4HsxyD9NBN3725Td9mlNUkuasXxrAmcr6tmad7wUQ7Bt3fCTQJakz9/9uLkFId
	1XOi+WKj6wuL9xkKoU4VS/BXQHvPQze8hpImnWugeuIw8S9crqoyxFt0I55dk0cA5FwpiQq6F9j
	hBU0ew==
X-Received: by 2002:a05:6402:a2c1:20b0:660:efc9:900a with SMTP id
 4fb4d7f45d1cf-668d05850d2mr15571a12.10.1773964146560; Thu, 19 Mar 2026
 16:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
 <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
In-Reply-To: <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 16:48:52 -0700
X-Gm-Features: AaiRm539o1m3fb1D8SMyh2uOyM5KTq-1EXJcgzUhfWSaEQm7dv3GVBlm-ysCZ4w
Message-ID: <CAJuCfpHD4SB30oP7Bdm=ey+2W7CAsFPruedEbqgR5OumrQErxQ@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AE44CC0003
X-Stat-Signature: qbcph5kxm6rfqdgqzphkxya3qcyzxwza
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773964148-80707
X-HE-Meta: U2FsdGVkX1+aKYgfLqH5ClBVJJk0jwXX52UH2p9OtQXLJAP9WgJQm5aohKZdDQY8l9+8iu5mTNeCa2g/t//GYCakS5OR5BZU/gxIySZCU5+sOV7kj8i0EFY6PUyq3qtfCzUKft865bOyijHV+HAn8+B4W6YpvO6THbTiGur05UZVMebsovE4bKliaJNUmFvhVGf1mmcFfwP9rRj+WIBJdWTTwXiZD94ryGYXAPy/WWA7taCtBQ21OrNCZ1/8zDVNSCU3VpSh/1h4WM+ACvkdJnsP1qbFIqnlp2oQ1sd2CaR2cXYJJ4AcrXO/OJEtQ27K0rd0PTJmlky0pQl8ugMRgs7caSd5e+A/XhUp8NfiaJ0SNTBdr95LnMA1ZOtJRQRlx/wha4a7ruI3WjJ1lvacE0HjoLC4osKCcvXWMSRTRV1myWtpDT/+M5hm/VBmJWt6gIHa8HITlBE7jTIg4E4Wb4C7+wQiqmEG50rJZH6ZfbAEx/uCdHEOUXm2VSldGxKY0e+yY8/x+qSV+3PSWzq/uNxtl+XE1DgAYB3zeqsu3EwDk7rc/Em1UJS6h5Js9ZePMgx2QBhU4jEwUPQ4Srf4w0L0AXBAEkQ7yYhRo3l1Zw7CbwJgVEzS89we8SP/sufaFZoCsx9tEPk444wO/4wl2Sg3bqtnuYpiSQrIqXDORIl/KjT3Gjlnj7pjqqfKUymPgaXE6hfigxIt2tiCOV7hZxEi2HJ+fPgp9G0jxdBrIak9OxgNT7zXkiXIrOGTpLV8n46h6DlJFp8pZ8J3hwhtsmQPWyUyws2Op3HI8VDI5z2tC21lIoMuM/z7TP3lZ0R8b5XosesD64+ujx5F6/yr5HFT20S7HrahPxpRJazTI1pcB5SNkhGvkYkHe1OqkTk2kDnhCbr47PCNpSTBLPPfP6DT01kyVkTjs+4/sQpopUz/kpzmkWHK8HDmOWd+krJP3JGI3eIAJx9pTxgE/XZ
 yDECUdc4
 pLl/a20BLPjC1FNQdcx7ij+vWNWQZU4T6Rj6rIw9leTTzWDd6mERELDYdcE2ZpydsEvCqcoTrPC20sV7IxR1Gjgy+ddsLiig/mjvp8q+YD6oiFv0HDe16E6SCIcinL92S6aMlwhAHXKe+fQM4S/0Ln49DCUw5oUdk5n2zk6MnYR08USMWEYkA05ittJ3nS7W6iqFThxoURWKZzayL/n3HxBrc2zlqrx3lusvCUzKxFMzuTCtHktT5cK8Zcr7oAY/Wdj6Ubz7Ly+2Ne0wDB3y9jB5TMvIgTouZL3W23sNpP+WJvEJNDv1w/hHLSAmMBh90lWGYzjVnUPL/s+2CrkccD3JD17qpyOejMcmdI2PfdCZ8/1as4W7q46tZ7Uhq9HYIGhgcc9RV+qhd9OY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 4:44=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Mar 19, 2026 at 3:28=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >
> > > Due to initialization ordering, page_ext is allocated and initialized
> > > relatively late during boot. Some pages have already been allocated
> > > and freed before page_ext becomes available, leaving their codetag
> > > uninitialized.
>
> Hi Hao,
> Thanks for the report.
> Hmm. So, we are allocating pages before page_ext is initialized...
>
> > >
> > > A clear example is in init_section_page_ext(): alloc_page_ext() calls
> > > kmemleak_alloc().

Forgot to ask. The example you are using here is for page_ext
allocation itself. Do you have any other examples where page
allocation happens before page_ext initialization? If that's the only
place, then we might be able to fix this in a simpler way by doing
something special for alloc_page_ext().

> > > If the slab cache has no free objects, it falls back
> > > to the buddy allocator to allocate memory. However, at this point pag=
e_ext
> > > is not yet fully initialized, so these newly allocated pages have no
> > > codetag set. These pages may later be reclaimed by KASAN,which causes
> > > the warning to trigger when they are freed because their codetag ref =
is
> > > still empty.
> > >
> > > Use a global array to track pages allocated before page_ext is fully
> > > initialized, similar to how kmemleak tracks early allocations.
> > > When page_ext initialization completes, set their codetag
> > > to empty to avoid warnings when they are freed later.
> > >
> > > ...
> > >
> > > --- a/include/linux/alloc_tag.h
> > > +++ b/include/linux/alloc_tag.h
> > > @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codetag_=
ref *ref)
> > >
> > >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > >
> > > +bool mem_profiling_is_available(void);
> > > +void alloc_tag_add_early_pfn(unsigned long pfn);
> > > +
> > >  #define ALLOC_TAG_SECTION_NAME       "alloc_tags"
> > >
> > >  struct codetag_bytes {
> > > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > index 58991ab09d84..a5bf4e72c154 100644
> > > --- a/lib/alloc_tag.c
> > > +++ b/lib/alloc_tag.c
> > > @@ -6,6 +6,7 @@
> > >  #include <linux/kallsyms.h>
> > >  #include <linux/module.h>
> > >  #include <linux/page_ext.h>
> > > +#include <linux/pgalloc_tag.h>
> > >  #include <linux/proc_fs.h>
> > >  #include <linux/seq_buf.h>
> > >  #include <linux/seq_file.h>
> > > @@ -26,6 +27,82 @@ static bool mem_profiling_support;
> > >
> > >  static struct codetag_type *alloc_tag_cttype;
> > >
> > > +/*
> > > + * State of the alloc_tag
> > > + *
> > > + * This is used to describe the states of the alloc_tag during bootu=
p.
> > > + *
> > > + * When we need to allocate page_ext to store codetag, we face an
> > > + * initialization timing problem:
> > > + *
> > > + * Due to initialization order, pages may be allocated via buddy sys=
tem
> > > + * before page_ext is fully allocated and initialized. Although thes=
e
> > > + * pages call the allocation hooks, the codetag will not be set beca=
use
> > > + * page_ext is not yet available.
> > > + *
> > > + * When these pages are later free to the buddy system, it triggers
> > > + * warnings because their codetag is actually empty if
> > > + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> > > + *
> > > + * Additionally, in this situation, we cannot record detailed alloca=
tion
> > > + * information for these pages.
> > > + */
> > > +enum mem_profiling_state {
> > > +     DOWN,                   /* No mem_profiling functionality yet *=
/
> > > +     UP                      /* Everything is working */
> > > +};
> > > +
> > > +static enum mem_profiling_state mem_profiling_state =3D DOWN;
> > > +
> > > +bool mem_profiling_is_available(void)
> > > +{
> > > +     return mem_profiling_state =3D=3D UP;
> > > +}
> > > +
> > > +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> > > +
> > > +#define EARLY_ALLOC_PFN_MAX          256
> > > +
> > > +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
> >
> > It's unfortunate that this isn't __initdata.
> >
> > > +static unsigned int early_pfn_count;
> > > +static DEFINE_SPINLOCK(early_pfn_lock);
> > > +
> > >
> > > ...
> > >
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, stru=
ct task_struct *task,
> > >               alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> > >               update_page_tag_ref(handle, &ref);
> > >               put_page_tag_ref(handle);
> > > +     } else {
>
> This branch can be marked as "unlikely".
>
> > > +             /*
> > > +              * page_ext is not available yet, record the pfn so we =
can
> > > +              * clear the tag ref later when page_ext is initialized=
.
> > > +              */
> > > +             if (!mem_profiling_is_available())
> > > +                     alloc_tag_add_early_pfn(page_to_pfn(page));
> > >       }
> > >  }
> >
> > All because of this, I believe.  Is this fixable?
> >
> > If we take that `else', we know we're running in __init code, yes?  I
> > don't see how `__init pgalloc_tag_add_early()' could be made to work.
> > hrm.  Something clever, please.
>
> We can have a pointer to a function that is initialized to point to
> alloc_tag_add_early_pfn, which is defined as __init and uses
> early_pfns which now can be defined as __initdata. After
> clear_early_alloc_pfn_tag_refs() is done we reset that pointer to
> NULL. __pgalloc_tag_add() instead of calling alloc_tag_add_early_pfn()
> directly checks that pointer and if it's not NULL then calls the
> function that it points to. This way __pgalloc_tag_add() which is not
> an __init function will be invoking alloc_tag_add_early_pfn() __init
> function only until we are done with initialization. I haven't tried
> this but I think that should work. This also eliminates the need for
> mem_profiling_state variable since we can use this function pointer
> instead.
>
>
> >

