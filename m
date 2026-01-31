Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CE1E63C8C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 05:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99EC16B0088; Sat, 31 Jan 2026 00:22:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4126B008A; Sat, 31 Jan 2026 00:22:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D526B008C; Sat, 31 Jan 2026 00:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66F476B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 00:22:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FFAA1A02A7
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 05:22:13 +0000 (UTC)
X-FDA: 84391112946.18.EE24007
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1592E40005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 05:22:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f8z7IjyM;
	spf=pass (imf04.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769836931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqbuj1RcfrAvy7V6cbhroU0aoAlPDCA0FikcXviwmoc=;
	b=serw9KGveH2s3IpddqX+BqLMkqirl++222H0mU/CxWDekLQuy9sIsI2PW6OIvup6HPgfl+
	CgrbBRVuOw/1YfUNn/A6x2iO0XNq1/Y/nAt4GpDIkHp2qmHlTrxarzfOkXZ/gTK6hIrVaL
	usQV1STUmFBmeh2RtMJdXIvjWRzs2S4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f8z7IjyM;
	spf=pass (imf04.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769836931; a=rsa-sha256;
	cv=pass;
	b=w5BlRfPbjBp6A+xI7+aOHoeLTDtoJCYD7USgGZIc4C6rUqx3oATBh6Oy8ItdbK6MghxEfn
	dNSnbDMhskX9SQiK68OuSVSI5hNOmNqBs1X4TA67VQJmSHfDN4/3AkMkG3FKaZpJjSG6ZI
	tjwTLVse073s0qm/2X4JaU3vumddEN4=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4801cf7c2c7so20305e9.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:22:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769836930; cv=none;
        d=google.com; s=arc-20240605;
        b=bcBU/MK5BGZYiJI/9ajRr+rGB1n3tGLBnCoGGnLdTtBW3z3ISnopyataQjjhjP5GfY
         gxxV01+qhx6Eaf9mmpsPLABEgE30Rn6RmQfCh2tT8WhW+W4uscS6cCB2QCtF5vlGgTdt
         XQTQlTaTTeTdLqSfu2sdIVgWuuls8fK3Kw/LkX554kbdX7FxoXmux2mBSsMTkQyO8emt
         lNzVQO0oi/gvszD1xiHzPzUNefN6Xrssm4nEDHnNnPYfEayGMfMA7l/K9GnFF9E27DGN
         M8tEQ0CBZYoRnI3IbB+4Q6uN+K9/QAL0oRKdYNAo0iJZzAnlS1UyMbiSss4KEtacnMTd
         4s/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aqbuj1RcfrAvy7V6cbhroU0aoAlPDCA0FikcXviwmoc=;
        fh=kWPDa9xSmQk0m64m2ZAhSqVcwWZdeX3XI519V6PtvNE=;
        b=iarsR3sp4ImFI52z2E/0dBCbdPLn3FGvEl5bYlnIRVuXS7NUvUYIO8Pyo+J0p7tvEi
         7L/g1M/mKND30EYdTb28xP6qnpyw5Vr4lFSTQG7pVZGy+tC4FsZoxWy5jNg3hk/BZiRF
         +9xy9AMLdzkfp230PHUGn2CVbhyiCFvUK3Yq5y/HoEqFlwQVholY3i0Zs1068bCooJdJ
         0UMp5yJVSsmJkX0VEr6XT1Ytjt3mIQs2Uc6NBsJfKj2sF7muYit4MmJJSjzZtUTw0nja
         /jKRjNXfk0UfjXnPDLuCLQRJFr93fpa8G1ZMKQnPeRnkVvl+j618Mc0oBplEqseAsIwm
         CA6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769836930; x=1770441730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aqbuj1RcfrAvy7V6cbhroU0aoAlPDCA0FikcXviwmoc=;
        b=f8z7IjyMPq2aJcNoIoQ2KfJgqDb8aulnINEQgRM30aDRmsRODmUqBJO8Cuf2x3g8Wm
         RSt9ZLc+CSTNL/B3fdW2iEHNYjjrjb7805W4DHfEP7872hdxv3RVNdBV5M0zVrNjO/X7
         wstJxCeGXLdJI7mTqqCpWGo4AnfsFK1XFdKnLDg90+BE7RT7blzbAbqXY7np54O2potP
         GbaUDSZ0l0WKA509P5ngznFMRFFlHUGAp9ihx/l3EfmV72SWes3FFTZN77nWnyXdxrjo
         zx1SQ60i880+WFmYiDaabuRI6q02qd+ltL/SR/4cTFcor9FZgZxPp85HoUtVvwEJyN3m
         Befg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769836930; x=1770441730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aqbuj1RcfrAvy7V6cbhroU0aoAlPDCA0FikcXviwmoc=;
        b=QUkemTxeOk+9kZVzvXJdX+pXwElZ6lU4IxY5OEkLq86Fzp07jvMv/63QZgYyWZtlQn
         Sfaehi7MNABQCP+BIwbbKVKCUTWELQv7TC0gsYIcyca8urKGdtH4c+j1frgrKX0T5lPJ
         ohtYyd7Qd0mfiXsbHsZqxPmNG72+q1oIXSM05XYWCx9sdjEqHJ5HJqmxugmTYoXlm2Lf
         aPEUGhUetn5P99LAYMI/3dRcOm+j6MRs+tTvmK3qh8GeaoXTGsf+y0cGyem9Y955t3Uo
         3By6fOvpRn1TPo0rhSyBTLrp2HCH7Pw7RODIj3wOfRsubGtykkvLAbOMZz5dHVEk8dbv
         W1jA==
X-Forwarded-Encrypted: i=1; AJvYcCW481SjQD/zdPH1KjCehPJ6PLQnvX73KkhNmlEhPPDucVRBtCSBNEkLZwsWguAV1hzU25pJaEg3iA==@kvack.org
X-Gm-Message-State: AOJu0YzKd9r7zrb/a+WImJhNgAE9BuMy6SReu02t5VQMTECu4pyxaGMs
	OWWu8Fwazf1NUuOb7VbMbshBX+W5K7Tfj5me4BXfpbhHbFzCUSQ7oklDJmaf87mHXAYefyyecX3
	kdpXWc2GgsRcu4JDDdHo5B8yJqJm08jz97HJk2m3D
X-Gm-Gg: AZuq6aJtTHpDUEuKDGwJL6hl0gSujpboPW4sXNn+2O0FBoVnlWE9uKsErPaYal2m6dv
	QdFy4OwCIrqgMibtMgbFL/wO7gt0DoToTnwLQVvxbAcziK3in8b1A9V4+UsVbJrC0xshtSvvP5S
	Y8sO4/xmEzgiicDQwQp54//HbHv0U6IicYBQPEdxE7U8dJvS2TtaCfz2apdlj3YcdHS8GeKoMrN
	oQh8kzJqcz5WtK1BbGUwi88YUNeUhnPZ3fG6zDB4p5GYkedl9y1W3VD+b+ofeGWbZTTvykil0Pq
	DkdDTp027uCmFtW+5i5Sr7hUShaB
X-Received: by 2002:a05:600c:64ce:b0:477:772e:9b76 with SMTP id
 5b1f17b1804b1-482ea45ea83mr312635e9.7.1769836929183; Fri, 30 Jan 2026
 21:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20251116013223.1557158-1-jiaqiyan@google.com> <20251116013223.1557158-2-jiaqiyan@google.com>
 <8e1b84f9-e14f-4946-8097-12325516cdfa@oracle.com>
In-Reply-To: <8e1b84f9-e14f-4946-8097-12325516cdfa@oracle.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 30 Jan 2026 21:21:57 -0800
X-Gm-Features: AZwV_QjV7b28BUeDy66odxvU6FaINtY1e_-1X3YiYRTV9Y4bIzVUNPn9UO814ds
Message-ID: <CACw3F519AtT-d8K3ur3S=5Z7entLZMpxmpZTgn=i_cfz15HUcA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: William Roche <william.roche@oracle.com>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, harry.yoo@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 6f8q58r915xjy8mh9c45xkcwimtzhwoz
X-Rspam-User: 
X-Rspamd-Queue-Id: 1592E40005
X-HE-Tag: 1769836930-616765
X-HE-Meta: U2FsdGVkX1+ZZmh85T+Al2L3kzjz/Z/o6ie0dwZZcbkmisX9uRVl0ghAx3x/LSylDeOHNfEgPmQ1CFjwyzoJu06hCPRxgq1hLX5qh/yeOQKtXQNMyxzMD3cNqXRRZrEiH4zoR/TiwszfYjKcVU1aLnteDHzx6MnXTwxSmijKpf0ly/CnUiWmcXyFzGZBwC38Z3sFNDcFXoxjtejKekd6BC8A111r7liQLO2G4u4Qh9QCisAY833KnElNLx4haeesfW8pCvRUFZGdBno7gjMkQl8w6L6HInW+gjcmJivmm5h+5SNWmAGmvvkVUg0zcbVYgLFhSczRBLPPdbudXhmemRH75RLtHYmeMhUyN1fQy7BIj6k5EbffPk7BwHG3lmP0LpIlvsWeK3YRNBY21wTa4Yq1iOCZMTof3nffYxnrC2unuRL7Te6yPbZNvl7H1TOjc6d6yUYBGxha7THGmBUeRjOpKwZ7OvEYuTiQluYCwuFK2Jeygr8D7w5Tyi3HNwVdv+STiniDxSp6K30jyVi+CtJkICNz4pzluJsBECn/E2oynaVX2jkWjomRt3722T2aVxAlf0SdjoHghKomcSjdZAWbFtDWM4E2B9xcmMqHhN6w36eyG4+CFdQ08/2XKfdjmr+ESQyA8reQuFRRYnAG4XxAQAZmTsUwTtGwJzD85DEsm2oU3szUm/xmUdTbH42T5/7dZexQ4mLafXwAangkJV2s9bn9GfF4WCSNyTgnIA0WjQjYSSitfLb/J0VaRgUd6dxie6WYMSmkC91A2BcXrc1WeLxbezZ/Y9eIkI6E1QH7P7z0ADUdxLNZodXcJhPIwhdez8SvXd5zfqA/czI6YdXxMK36wArj7/F3P6dhtxtZKyOl/KWVdAmefgxii795LY+Jy7GQzcqxBQlgARk7wjgAjnEkoLVRkD82EWGu4jsWFMZsoYElK5RVyj/mRhQktRzMkzHjtlQaZlvqaa6
 VPsMzWWm
 lVcsGpEf8pwhFWsuCIcYa5hT+8THYFQU35QBkrimYMLFGajSNlDTZZjIQSal+FzG5A+8PLoFH2Yai67aqzsiugQFM7BnJZdG9fAbXEJMXUxqplCkIm+P2dKbBeKasguC09zZ/0J/tq8v3f8Q1tSeY/dADq5EoeBQ+oL4SaISdkBCHXk7VcE7f7Jp7rgpSr2YAh+0hgXMcWqFLOU+/0oVqDOgfI2GUO295njNi/RDtLwSIWpKUyNoT3kt0uvr5jdoaYXy3qnhIL2QYSVMCg69/PjxBudgnglwG3/EjIVwcdsmuULCQjUFRaEA9bIGgXIUkpya2VjsxB7lxLRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi William,

Thanks for your reviews, I should be able to address your comments in v3.

On Tue, Nov 25, 2025 at 2:04=E2=80=AFPM William Roche <william.roche@oracle=
.com> wrote:
>
> Sorry, resending for the non-HTML version.
>   --
>
> Hello Jiaqi,
>
> Here is a summary of a few nits in this code:
>
>   - Some functions declarations are problematic according to me
>   - The parameter testing to activate the feature looks incorrect
>   - The function signature change is probably not necessary
>   - Maybe we should wait for an agreement on your other proposal:
> [PATCH v1 0/2] Only free healthy pages in high-order HWPoison folio
>
> The last item is not a nit, but as your above proposal may require to
> keep all data of a
> hugetlb folio to recycle it correctly (especially the list of poisoned
> sub-pages), and
> to avoid the race condition with returning poisoned pages to the
> freelist right before
> removing them; you may need to change some aspects of this current code.
>
>
>
>
> On 11/16/25 02:32, Jiaqi Yan wrote:
> > [...]
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 8e63e46b8e1f0..b7733ef5ee917 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -871,10 +871,17 @@ int dissolve_free_hugetlb_folios(unsigned long st=
art_pfn,
> >
> >   #ifdef CONFIG_MEMORY_FAILURE
> >   extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
> > +extern bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
> > +                                             struct address_space *map=
ping);
> >   #else
> >   static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
> >   {
> >   }
> > +static inline bool hugetlb_should_keep_hwpoison_mapped(struct folio *f=
olio
> > +                                                    struct address_spa=
ce *mapping)
> > +{
> > +     return false;
> > +}
> >   #endif
>
> You are conditionally declaring this
> hugetlb_should_keep_hwpoison_mapped() function and implementing
> it into mm/hugetlb.c, but this file can be compiled in both cases
> (CONFIG_MEMORY_FAILURE enabled or not)
> So you either need to have a single consistent declaration with the
> implementation and use something like that:
>
>   bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
>                                           struct address_space *mapping)
>   {
> +#ifdef CONFIG_MEMORY_FAILURE
>          if (WARN_ON_ONCE(!folio_test_hugetlb(folio)))
>                  return false;
>
> @@ -6087,6 +6088,9 @@ bool hugetlb_should_keep_hwpoison_mapped(struct
> folio *folio,
>                  return false;
>
>          return mapping_mf_keep_ue_mapped(mapping);
> +#else
> +       return false;
> +#endif
>   }
>
> Or keep your double declaration and hide the implementation when
> CONFIG_MEMORY_FAILURE is enabled:
>
> +#ifdef CONFIG_MEMORY_FAILURE
>   bool hugetlb_should_keep_hwpoison_mapped(struct folio *folio,
>                                           struct address_space *mapping)
>   {
>          if (WARN_ON_ONCE(!folio_test_hugetlb(folio)))
>                  return false;
>
>   @@ -6087,6 +6088,9 @@ bool hugetlb_should_keep_hwpoison_mapped(struct
> folio *folio,
>                  return false;
>
>          return mapping_mf_keep_ue_mapped(mapping);
>   }
> +#endif
>

Thanks for your suggestions! I think probably I can move the real
hugetlb_should_keep_hwpoison_mapped() implementation to
memory_failure.c, similar to how folio_clear_hugetlb_hwpoison() is
implemented.

>
>
> >
> >   #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 09b581c1d878d..9ad511aacde7c 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -213,6 +213,8 @@ enum mapping_flags {
> >       AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,
> >       AS_KERNEL_FILE =3D 10,    /* mapping for a fake kernel file that =
shouldn't
> >                                  account usage to user cgroups */
> > +     /* For MFD_MF_KEEP_UE_MAPPED. */
> > +     AS_MF_KEEP_UE_MAPPED =3D 11,
> >       /* Bits 16-25 are used for FOLIO_ORDER */
> >       AS_FOLIO_ORDER_BITS =3D 5,
> >       AS_FOLIO_ORDER_MIN =3D 16,
> > @@ -348,6 +350,16 @@ static inline bool mapping_writeback_may_deadlock_=
on_reclaim(const struct addres
> >       return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->f=
lags);
> >   }
> >
> > +static inline bool mapping_mf_keep_ue_mapped(const struct address_spac=
e *mapping)
> > +{
> > +     return test_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> > +}
> > +
> > +static inline void mapping_set_mf_keep_ue_mapped(struct address_space =
*mapping)
> > +{
> > +     set_bit(AS_MF_KEEP_UE_MAPPED, &mapping->flags);
> > +}
> > +
> >   static inline gfp_t mapping_gfp_mask(const struct address_space *mapp=
ing)
> >   {
> >       return mapping->gfp_mask;
> > @@ -1274,6 +1286,18 @@ void replace_page_cache_folio(struct folio *old,=
 struct folio *new);
> >   void delete_from_page_cache_batch(struct address_space *mapping,
> >                                 struct folio_batch *fbatch);
> >   bool filemap_release_folio(struct folio *folio, gfp_t gfp);
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +/*
> > + * Provided by memory failure to offline HWPoison-ed folio managed by =
memfd.
> > + */
> > +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> > +                                 struct folio *folio);
> > +#else
> > +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> > +                                 struct folio *folio)
> > +{
> > +}
> > +#endif
> >   loff_t mapping_seek_hole_data(struct address_space *, loff_t start, l=
off_t end,
> >               int whence);
> >
>
> This filemap_offline_hwpoison_folio() declaration also is problematic in
> the case without
> CONFIG_MEMORY_FAILURE, as we implement a public function
> filemap_offline_hwpoison_folio()
> in all the files including this "pagemap.h" header.
>
> This coud be solved using "static inline" in this second case.

Yep, will do in v3.

>
>
>
> > diff --git a/mm/memfd.c b/mm/memfd.c
> > index 1d109c1acf211..bfdde4cf90500 100644
> > --- a/mm/memfd.c
> > +++ b/mm/memfd.c
> > @@ -313,7 +313,8 @@ long memfd_fcntl(struct file *file, unsigned int cm=
d, unsigned int arg)
> >   #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
> >   #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
> >
> > -#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB |=
 MFD_NOEXEC_SEAL | MFD_EXEC)
> > +#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB |=
 \
> > +                    MFD_NOEXEC_SEAL | MFD_EXEC | MFD_MF_KEEP_UE_MAPPED=
)
> >
> >   static int check_sysctl_memfd_noexec(unsigned int *flags)
> >   {
> > @@ -387,6 +388,8 @@ static int sanitize_flags(unsigned int *flags_ptr)
> >       if (!(flags & MFD_HUGETLB)) {
> >               if (flags & ~MFD_ALL_FLAGS)
> >                       return -EINVAL;
> > +             if (flags & MFD_MF_KEEP_UE_MAPPED)
> > +                     return -EINVAL;
> >       } else {
> >               /* Allow huge page size encoding in flags. */
> >               if (flags & ~(MFD_ALL_FLAGS |
> > @@ -447,6 +450,16 @@ static struct file *alloc_file(const char *name, u=
nsigned int flags)
> >       file->f_mode |=3D FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
> >       file->f_flags |=3D O_LARGEFILE;
> >
> > +     /*
> > +      * MFD_MF_KEEP_UE_MAPPED can only be specified in memfd_create; n=
o API
> > +      * to update it once memfd is created. MFD_MF_KEEP_UE_MAPPED is n=
ot
> > +      * seal-able.
> > +      *
> > +      * For now MFD_MF_KEEP_UE_MAPPED is only supported by HugeTLBFS.
> > +      */
> > +     if (flags & (MFD_HUGETLB | MFD_MF_KEEP_UE_MAPPED))
> > +             mapping_set_mf_keep_ue_mapped(file->f_mapping);
> > +
>
> The flags value that we need to have in order to set the "keep" value on
> the address space
> is MFD_MF_KEEP_UE_MAPPED alone, as we already verified that the value is
> only given combined
> to MFD_HUGETLB.
> This is a nit identified by Harry Yoo during our internal conversations.
> Thanks Harry !

Yeah, this is redundant to sanitize_flags(). Will simplify in v3.

>
>
> >       if (flags & MFD_NOEXEC_SEAL) {
> >               struct inode *inode =3D file_inode(file);
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 3edebb0cda30b..c5e3e28872797 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -373,11 +373,13 @@ static unsigned long dev_pagemap_mapping_shift(st=
ruct vm_area_struct *vma,
> >    * Schedule a process for later kill.
> >    * Uses GFP_ATOMIC allocations to avoid potential recursions in the V=
M.
> >    */
> > -static void __add_to_kill(struct task_struct *tsk, const struct page *=
p,
> > +static void __add_to_kill(struct task_struct *tsk, struct page *p,
> >                         struct vm_area_struct *vma, struct list_head *t=
o_kill,
> >                         unsigned long addr)
>
> Is there any reason to remove the "const" on the page structure in the
> signature ?
> It looks like you only do that for the new call to page_folio(p), but we
> don't touch the page
>
>
> >   {
> >       struct to_kill *tk;
> > +     struct folio *folio;
>
> You could use a "const" struct folio *folio too.

Yes, will revert the changes to "const" all over the places.

>
>
>
> > +     struct address_space *mapping;
> >
> >       tk =3D kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
> >       if (!tk) {
> > @@ -388,8 +390,19 @@ static void __add_to_kill(struct task_struct *tsk,=
 const struct page *p,
> >       tk->addr =3D addr;
> >       if (is_zone_device_page(p))
> >               tk->size_shift =3D dev_pagemap_mapping_shift(vma, tk->add=
r);
> > -     else
> > -             tk->size_shift =3D folio_shift(page_folio(p));
> > +     else {
> > +             folio =3D page_folio(p);
>
> Now with both folio and p being "const", the code should work.
>
>
>
> > +             mapping =3D folio_mapping(folio);
> > +             if (mapping && mapping_mf_keep_ue_mapped(mapping))
> > +                     /*
> > +                      * Let userspace know the radius of HWPoison is
> > +                      * the size of raw page; accessing other pages
> > +                      * inside the folio is still ok.
> > +                      */
> > +                     tk->size_shift =3D PAGE_SHIFT;
> > +             else
> > +                     tk->size_shift =3D folio_shift(folio);
> > +     }
> >
> >       /*
> >        * Send SIGKILL if "tk->addr =3D=3D -EFAULT". Also, as
> > @@ -414,7 +427,7 @@ static void __add_to_kill(struct task_struct *tsk, =
const struct page *p,
> >       list_add_tail(&tk->nd, to_kill);
> >   }
> >
> > -static void add_to_kill_anon_file(struct task_struct *tsk, const struc=
t page *p,
> > +static void add_to_kill_anon_file(struct task_struct *tsk, struct page=
 *p,
>
> No need to change the signature here too (otherwise you would have
> missed both functions
> add_to_kill_fsdax() and add_to_kill_ksm().
>
>
> >               struct vm_area_struct *vma, struct list_head *to_kill,
> >               unsigned long addr)
> >   {
> > @@ -535,7 +548,7 @@ struct task_struct *task_early_kill(struct task_str=
uct *tsk, int force_early)
> >    * Collect processes when the error hit an anonymous page.
> >    */
> >   static void collect_procs_anon(const struct folio *folio,
> > -             const struct page *page, struct list_head *to_kill,
> > +             struct page *page, struct list_head *to_kill,
>
> No need to change
>
>
> >               int force_early)
> >   {
> >       struct task_struct *tsk;
> > @@ -573,7 +586,7 @@ static void collect_procs_anon(const struct folio *=
folio,
> >    * Collect processes when the error hit a file mapped page.
> >    */
> >   static void collect_procs_file(const struct folio *folio,
> > -             const struct page *page, struct list_head *to_kill,
> > +             struct page *page, struct list_head *to_kill,
> >               int force_early)
>
> No need to change
>
> >   {
> >       struct vm_area_struct *vma;
> > @@ -655,7 +668,7 @@ static void collect_procs_fsdax(const struct page *=
page,
> >   /*
> >    * Collect the processes who have the corrupted page mapped to kill.
> >    */
> > -static void collect_procs(const struct folio *folio, const struct page=
 *page,
> > +static void collect_procs(const struct folio *folio, struct page *page=
,
> >               struct list_head *tokill, int force_early)
> >   {
> >       if (!folio->mapping)
> > @@ -1173,6 +1186,13 @@ static int me_huge_page(struct page_state *ps, s=
truct page *p)
> >               }
> >       }
> >
> > +     /*
> > +      * MF still needs to holds a refcount for the deferred actions in
> > +      * filemap_offline_hwpoison_folio.
> > +      */
> > +     if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> > +             return res;
> > +
> >       if (has_extra_refcount(ps, p, extra_pins))
> >               res =3D MF_FAILED;
> >
> > @@ -1569,6 +1589,7 @@ static bool hwpoison_user_mappings(struct folio *=
folio, struct page *p,
> >   {
> >       LIST_HEAD(tokill);
> >       bool unmap_success;
> > +     bool keep_mapped;
> >       int forcekill;
> >       bool mlocked =3D folio_test_mlocked(folio);
> >
> > @@ -1596,8 +1617,12 @@ static bool hwpoison_user_mappings(struct folio =
*folio, struct page *p,
> >        */
> >       collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> >
> > -     unmap_success =3D !unmap_poisoned_folio(folio, pfn, flags & MF_MU=
ST_KILL);
> > -     if (!unmap_success)
> > +     keep_mapped =3D hugetlb_should_keep_hwpoison_mapped(folio, folio-=
>mapping);
> > +     if (!keep_mapped)
> > +             unmap_poisoned_folio(folio, pfn, flags & MF_MUST_KILL);
> > +
> > +     unmap_success =3D !folio_mapped(folio);
> > +     if (!keep_mapped && !unmap_success)
> >               pr_err("%#lx: failed to unmap page (folio mapcount=3D%d)\=
n",
> >                      pfn, folio_mapcount(folio));
> >
> > @@ -1622,7 +1647,7 @@ static bool hwpoison_user_mappings(struct folio *=
folio, struct page *p,
> >                   !unmap_success;
> >       kill_procs(&tokill, forcekill, pfn, flags);
> >
> > -     return unmap_success;
> > +     return unmap_success || keep_mapped;
> >   }
> >
> >   static int identify_page_state(unsigned long pfn, struct page *p,
> > @@ -1862,6 +1887,13 @@ static unsigned long __folio_free_raw_hwp(struct=
 folio *folio, bool move_flag)
> >       unsigned long count =3D 0;
> >
> >       head =3D llist_del_all(raw_hwp_list_head(folio));
> > +     /*
> > +      * If filemap_offline_hwpoison_folio_hugetlb is handling this fol=
io,
> > +      * it has already taken off the head of the llist.
> > +      */
> > +     if (head =3D=3D NULL)
> > +             return 0;
> > +
>
> This may not be necessary depending on how we recycle hugetlb pages --
> see below too.
>
> >       llist_for_each_entry_safe(p, next, head, node) {
> >               if (move_flag)
> >                       SetPageHWPoison(p->page);
> > @@ -1878,7 +1910,8 @@ static int folio_set_hugetlb_hwpoison(struct foli=
o *folio, struct page *page)
> >       struct llist_head *head;
> >       struct raw_hwp_page *raw_hwp;
> >       struct raw_hwp_page *p;
> > -     int ret =3D folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
> > +     struct address_space *mapping =3D folio->mapping;
> > +     bool has_hwpoison =3D folio_test_set_hwpoison(folio);
> >
> >       /*
> >        * Once the hwpoison hugepage has lost reliable raw error info,
> > @@ -1897,8 +1930,15 @@ static int folio_set_hugetlb_hwpoison(struct fol=
io *folio, struct page *page)
> >       if (raw_hwp) {
> >               raw_hwp->page =3D page;
> >               llist_add(&raw_hwp->node, head);
> > +             if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> > +                     /*
> > +                      * A new raw HWPoison page. Don't return HWPOISON=
.
> > +                      * Error event will be counted in action_result()=
.
> > +                      */
> > +                     return 0;
> > +
> >               /* the first error event will be counted in action_result=
(). */
> > -             if (ret)
> > +             if (has_hwpoison)
> >                       num_poisoned_pages_inc(page_to_pfn(page));
> >       } else {
> >               /*
> > @@ -1913,7 +1953,8 @@ static int folio_set_hugetlb_hwpoison(struct foli=
o *folio, struct page *page)
> >                */
> >               __folio_free_raw_hwp(folio, false);
> >       }
> > -     return ret;
> > +
> > +     return has_hwpoison ? -EHWPOISON : 0;
> >   }
> >
> >   static unsigned long folio_free_raw_hwp(struct folio *folio, bool mov=
e_flag)
> > @@ -2002,6 +2043,63 @@ int __get_huge_page_for_hwpoison(unsigned long p=
fn, int flags,
> >       return ret;
> >   }
> >
> > +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio=
)
> > +{
> > +     int ret;
> > +     struct llist_node *head;
> > +     struct raw_hwp_page *curr, *next;
> > +     struct page *page;
> > +     unsigned long pfn;
> > +
> > +     /*
> > +      * Since folio is still in the folio_batch, drop the refcount
> > +      * elevated by filemap_get_folios.
> > +      */
> > +     folio_put_refs(folio, 1);
> > +     head =3D llist_del_all(raw_hwp_list_head(folio));
>
> According to me we should wait until your other patch set is approved to
> decide if the folio raw_hwp_list
> has to be removed from the folio or if is should be left there so that
> the recycling of this huge page
> works correctly...
>
> > +
> > +     /*
> > +      * Release refcounts held by try_memory_failure_hugetlb, one per
> > +      * HWPoison-ed page in the raw hwp list.
> > +      */
> > +     llist_for_each_entry(curr, head, node) {
> > +             SetPageHWPoison(curr->page);
> > +             folio_put(folio);
> > +     }
> > +
> > +     /* Refcount now should be zero and ready to dissolve folio. */
> > +     ret =3D dissolve_free_hugetlb_folio(folio);
> > +     if (ret) {
> > +             pr_err("failed to dissolve hugetlb folio: %d\n", ret);
> > +             return;
> > +     }
> > +
> > +     llist_for_each_entry_safe(curr, next, head, node) {
> > +             page =3D curr->page;
> > +             pfn =3D page_to_pfn(page);
> > +             drain_all_pages(page_zone(page));
> > +             if (!take_page_off_buddy(page))
> > +                     pr_err("%#lx: unable to take off buddy allocator\=
n", pfn);
> > +
> > +             page_ref_inc(page);
> > +             kfree(curr);
> > +             pr_info("%#lx: pending hard offline completed\n", pfn);
> > +     }
> > +}
>
> Let's revisit this above function when an agreement is reached on the
> recycling hugetlb pages proposal.

From what I can tell, free_has_hwpoisoned() is promising. So in v3 I
will post much simplified filemap_offline_hwpoison_folio_hugetlb(),
assuming dissolve_free_hugetlb_folio() recycles only the healthy
pages.

>
>
>
>
>
> > +
> > +void filemap_offline_hwpoison_folio(struct address_space *mapping,
> > +                                 struct folio *folio)
> > +{
> > +     WARN_ON_ONCE(!mapping);
> > +
> > +     if (!folio_test_hwpoison(folio))
> > +             return;
> > +
> > +     /* Pending MFR currently only exist for hugetlb. */
> > +     if (hugetlb_should_keep_hwpoison_mapped(folio, mapping))
> > +             filemap_offline_hwpoison_folio_hugetlb(folio);
> > +}
> > +
> >   /*
> >    * Taking refcount of hugetlb pages needs extra care about race condi=
tions
> >    * with basic operations like hugepage allocation/free/demotion.
>
>
> HTH
>
> Best regards,
> William.

