Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FD1CD0431
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CB66B008A; Mon,  5 Jan 2026 22:40:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3256B0093; Mon,  5 Jan 2026 22:40:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB80E6B0095; Mon,  5 Jan 2026 22:40:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965236B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:40:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11FFA1B1C9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:40:16 +0000 (UTC)
X-FDA: 84300136032.25.7253B72
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 21B8140005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:40:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KhJ1Op5a;
	spf=pass (imf11.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767670814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OI28tWzY6U22JWm/9Yp2SYQCzAoFs3Lpg0JJ4aS/rmg=;
	b=zjsqh9IqqQBcMteZhdRickWELMrYX7ARc3ZAojpXJng4wE2VAJkJ9RNcaIozYcGMB9qtAt
	aCz7+fTjVxVdWL+VF2g/cnZqwGslpjwUTrp2e+41kctq3pFytYBATCWWm1ufCDkS5BYzRd
	dvZ58PlLqrg8Z6pstpgUEvsSMiwVPjw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KhJ1Op5a;
	spf=pass (imf11.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767670814; a=rsa-sha256;
	cv=pass;
	b=b9QRS6c8xpl4Mplf4sYQF5Su8F3OHvw9fcrCdJdVxgLLHnFe9Fy94HEORS08qpz5A4C6rS
	Re6Qwpm0nL26Sp9lF32H1Ktzxj3MhaS9f3K0UUn21nO44r69dqBgrLGNMSMTJBuOIoFW0z
	WCbqvY9cTvjXfXqpu+4rZMp/Pj15NXU=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so35335e9.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 19:40:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767670812; cv=none;
        d=google.com; s=arc-20240605;
        b=QGq0UDIbr1OclOIE5JvbA83GHnwGbgiXzkh4hJOTiLIs4B8UYTDEfSNUZGqBv6QASV
         eb2Lufrxy9IV+RuLalwtqDrHfBWAM0ueUOm1RTkkLktR5+z4R5oeBMaHoiwBJLDUfb7n
         pNLUT7YK5Rk+O25egaxaWsVxOApJY9lBXijnm/gvSUt/Nvx25eLY5faldKlRTEVsmzAD
         LytLOXBsQXjZ0RAhWvGAFFU385o0+QfufQ7pZrRZTyTF+P6pPrsI4NsLWLELNiay9h49
         o4QV6AUkjglsvERGxkRYilhZkDQhjeFZKfZynFSbNHV396RAdJBFO5bDbi4+zZ3OSwXC
         rMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OI28tWzY6U22JWm/9Yp2SYQCzAoFs3Lpg0JJ4aS/rmg=;
        fh=cOBHd3DPRjZtycQKJ69UQfE7/QDev+/rpFONMx3rKjU=;
        b=JpYQCjqOXhKS5ZyIw1kGYraf5uFuMsXrL+bFZxlUKROw1t8Vl8uNx6T7HiZhkFAfg8
         AhQY3S5xhbSbRoKL+TOouyc0oZghQgJIokDVU6xr4YmFZebDOvkI1HEyZx+m2LVKYlyC
         c93baabQRVbUWRszMf426nXe5F1JVZXGV8cH2vzQe1xDky8/uTju1+GfWzu3XLzjjof0
         YCrjNf3dF9jmEq5K8hgQ2xzrhTaPqmmRTDzHzelBLj+ceXgFR2ofamigrqIZDiZ+7Pnb
         nOHyyEx2QjrSeucyVkCd1fm8LmOC2J/nxepeg7PuWmANB/j2r6Yu3xdNbm7jA2AuBpgF
         48hQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767670812; x=1768275612; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OI28tWzY6U22JWm/9Yp2SYQCzAoFs3Lpg0JJ4aS/rmg=;
        b=KhJ1Op5aDzqOwG2WEzXX3jVpvHHRq6XgM9/tFiJxvALkSq5PX8W2Z4eQuhtJU0+OJd
         PYcoapJ0sEi7pa/SXPqS/yZAHFoU3f5VE5924Ja+ZaARHAWcC6ftVOj6EjmqNnRWKFqm
         rWY84eUerKWsYPgdv2Vt/LlqFJ/N1Qb8UEWyNYbrG7g6m4VPqMLh64X+y2Xli679jV1c
         a3XRfGupo+V/pzhXAKE+jgyYoC74csARsPV9XayQkhBYmB42BRqOy3H1qG+XcKkF6a/w
         ad0IIiOeH35XsV9pw0B5kvt4NZ85bIo7XsE/WasHkOuADbZTlpc+TFbJP8jNKsTc5gu5
         FUMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767670812; x=1768275612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OI28tWzY6U22JWm/9Yp2SYQCzAoFs3Lpg0JJ4aS/rmg=;
        b=N6sqBLekvzK3ukgycLiepGK3OewNn1lL904jI4fOAIzOPx0txCohdaiio02WXgsm4B
         ZUFpUYfwpAh1bvbW2HggocbFbfHkWnzU2mZ/kHXcxker2jlLU0phQRxR7snVWqyCXxV6
         uvxPoqQGl5jvq8FrLt2qrPtLLbfCMw+wCcX3FWQQ12zJV5fsqpvoRBkI495HMZolfw3w
         rN/QZzpyKsWpo8hHDOBDKEYrbpuMb5CUnPSIaTmCtWnirir4muPa8fzIXIBEjP+ExNzs
         phtQO6/GcxyjZgVURXk6r9UVZLgjDTCrjTdVIPvNXwNilsn1ydu2lVHknPLvWgkigkoz
         SHCg==
X-Forwarded-Encrypted: i=1; AJvYcCUudm3qgAVjIvPYvBbjDAnXWf01BIPrT3wJ29H3cFFdtRboixxisKkfV6OfKzjzmkO88HcxpzJ7TA==@kvack.org
X-Gm-Message-State: AOJu0YxoDyVHT//0ZXUfVgQvKBB/s6cDsmq/wD05feadI9k1VrcTRL8r
	MYb48KcJaxIZ/r5r0hruWgYqkjAFuRjOuMMjia4L21fwzd27hgrGK+ifgiI3gd8OZLGDkr3RY27
	oOzBVfpMKUalnfAt7XF7HcimdpAOq0FNFbTtVE3JN
X-Gm-Gg: AY/fxX4sSZyFJv6p7xK39xMgLToZ+02KCE/p1mOKrRaJf18Yx/hEL+0/ZCrB38vI2zD
	MFiY5uVasbxUtYiW0YikI2q+0PFIUK234B3308HPv1Ryp1tjFcl83Bta1fXpGzo9xLlfZH/+Eok
	usyeYpcfAjasDVM6GYfFX+h6u69T6kQQTTbb0i74hp41scBMF7hi821IaB9m9atJZmZVLZx/pnP
	FfwKTUnmrbQZdBw/vCiOUbXDK8KPgSIfsnHT3fTNZSbnRC62TwPK0j8MvqFPMiLUw3/TAC6u3oC
	BR9L2/jHx/EOj/vAW6d7IIiM4gsQ
X-Google-Smtp-Source: AGHT+IEEczmRJa7jtD53BsBRrDLj1HcLZxDHB5WVMJ1FleqTiwQOjWrBl1Q4euBFkfYP3GyNWj3vXXQJ8JCH3Hh5Sxs=
X-Received: by 2002:a05:600c:2e16:b0:477:95a8:3805 with SMTP id
 5b1f17b1804b1-47d8079aad8mr138055e9.15.1767670812091; Mon, 05 Jan 2026
 19:40:12 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com> <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo> <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
 <aVHWOMa9n40_8Yu3@hyeyoo> <CACw3F53p9TyAZs2pn+aHo85=aZx0+unaoLjeFtEK8DJ8A5TD4A@mail.gmail.com>
 <aVSojEWdFPsb1fg7@hyeyoo>
In-Reply-To: <aVSojEWdFPsb1fg7@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 5 Jan 2026 19:40:00 -0800
X-Gm-Features: AQt7F2qJwprkVvvf7liNxjiGZPYyMDCHOlMdpepHEq8d_Y_r3EObr3_zkfBQbFs
Message-ID: <CACw3F51ZnjaHtsorT0ao8S5K8Tvzgqb6fT9hr-WBavkqivz+BQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
To: Harry Yoo <harry.yoo@oracle.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: odas7yp9sexupt8wdowkguybk86m3yha
X-Rspam-User: 
X-Rspamd-Queue-Id: 21B8140005
X-HE-Tag: 1767670813-418398
X-HE-Meta: U2FsdGVkX18qfyL8JTtxv1JsTewyNKWH6dsU6k5lSip/Q3QJKDg/fw1YgU9YG38qF7j2M0pfQT/uRKeUn/o9jYkYH1hdmBqEtM6sffcpm3rAeFs8ayBvMe7PCvhdsvDFuoX5NG3yafmmp9RMn8nbfRMYbL7K2y+fk698QO1BlN92UO+eDCgZqMQCRNWqx8fK+2EBDNHuw0UDL1g1VAkGL7NJKR9yU7dQPeLjn8Rq4CHWa96cSvk1Q5Ss3pSBuJHYYd35enX2CnNzysA9PfCbxrYu2TYi5acL4nMPw9F5M1Ygln/BxSaHaqEUjG3EN6Z2fCA4SMeWFI3SJJ+ipU26SpeYitbA9SF8VxjNF2L31PvBOY42TxMrY2Nny1HXHoD5kwrabz8GqvL9SnHs1B1LIoxzbe05rwHfh19ZNWlSUqvc9a+HRe19yJWOMYrd8yuMZPrDIC5AWRm/7yxjC4OxVdv4m3elmDZ7uWb2/hffI2r2tItvLO52KhyoPhyaOWJ1LhF4irBRkdt3pfxnGwzjsf1xJj9ALisw5ZpZjBCU3t7k6fzpYgW47YciczASWMd63uIZhQIDhQR20Oo9IMpNLGYIhYE7gVSM3sonz4eIAegbLs7n0RN1IAQhStvT/DSJ+EWFV8+X7Lj9gqPqfXJqNBZ7+Xjcs7GABnW6hZUIJ07aF1gH9OWK4n98nYXRN8eDDyfEZaw6NBoxOn4BTbP5Li8ifEp3uexu6OOlG8qAAGRuwfjOEbcbch0dggViZ42PfpCEDPbZByvZFg/SusNbpZFMRTZSHFeIi7v61zamrRoLGmjUWp3acCvL0T2otle7doydW+Jc96dft+K51RzYt5MFdigbNqV45DzF48ToMsqsj62Ocwkhnh8AP/NewM8czrI8/KMLQYtz0TC6g0Cfpv8XKvypiHMm7jUrIE7nzl0/OPgBI+/bpJDzaoi5YYvvSDR07yYT58bUAzy+GLz
 3EfgcRKT
 vmeQW+tV5tToIrWxEPSALyfnzrpgRmzsjVYDAiGjzSEFBBKceAY2sRfwX1aa31NYZbfU9U57qnYL7tUUzBGJ/YG1ag9hJ9dGAkdtc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 8:37=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Dec 30, 2025 at 04:19:50PM -0800, Jiaqi Yan wrote:
> > On Sun, Dec 28, 2025 at 5:15=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > > On Fri, Dec 26, 2025 at 05:50:59PM -0800, Jiaqi Yan wrote:
> > > > On Mon, Dec 22, 2025 at 9:14=E2=80=AFPM Harry Yoo <harry.yoo@oracle=
.com> wrote:
> > > > > On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > > > > > ---
> > > > > >  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++=
++++++++
> > > > > >  1 file changed, 101 insertions(+)
> > > > > >
> > > > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > > > index 822e05f1a9646..20c8862ce594e 100644
> > > > > > --- a/mm/page_alloc.c
> > > > > > +++ b/mm/page_alloc.c
> > > > > > +/*
> > > > > > + * Given a high-order compound page containing certain number =
of HWPoison
> > > > > > + * pages, free only the healthy ones to buddy allocator.
> > > > > > + *
> > > > > > + * It calls __free_frozen_pages O(2^order) times and cause non=
trivial
> > > > > > + * overhead. So only use this when compound page really contai=
ns HWPoison.
> > > > > > + *
> > > > > > + * This implementation doesn't work in memdesc world.
> > > > > > + */
> > > > > > +static void free_has_hwpoison_pages(struct page *page, unsigne=
d int order)
> > > > > > +{
> > > > > > +     struct page *curr =3D page;
> > > > > > +     struct page *end =3D page + (1 << order);
> > > > > > +     struct page *next;
> > > > > > +     unsigned long flags =3D page->flags.f;
> > > > > > +     unsigned long nr_pages;
> > > > > > +     unsigned long total_freed =3D 0;
> > > > > > +     unsigned long total_hwp =3D 0;
> > > > > > +
> > > > > > +     VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> > > > > > +
> > > > > > +     while (curr < end) {
> > > > > > +             next =3D curr;
> > > > > > +             nr_pages =3D 0;
> > > > > > +
> > > > > > +             while (next < end && !PageHWPoison(next)) {
> > > > > > +                     ++next;
> > > > > > +                     ++nr_pages;
> > > > > > +             }
> > > > > > +
> > > > > > +             if (PageHWPoison(next))
> > > > > > +                     ++total_hwp;
> > > > > > +
> > > > > > +             free_contiguous_pages(curr, next, flags);
> > > > >
> > > > > page_owner, memory profiling (anything else?) will be confused
> > > > > because it was allocated as a larger size, but we're freeing only
> > > > > some portion of it.
> > > >
> > > > I am not sure, but looking at __split_unmapped_folio, it calls
> > > > pgalloc_tag_split(folio, old_order, split_order) when splitting an
> > > > old_order-order folio into a new split_order.
> > > >
> > > > Maybe prepare_compound_page_to_free really should
> > > > update_page_tag_ref(), I need to take a closer look at this with
> > > > CONFIG_MEM_ALLOC_PROFILING (not something I usually enable).
> > > >
> > > > > Perhaps we need to run some portion of this code snippet
> > > > > (from free_pages_prepare()), before freeing portions of it:
> > > > >
> > > > >         page_cpupid_reset_last(page);
> > > > >         page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> > > > >         reset_page_owner(page, order);
> > > > >         page_table_check_free(page, order);
> > > > >         pgalloc_tag_sub(page, 1 << order);
> > > >
> > > > Since they come from free_pages_prepare, I believe these lines are
> > > > already executed via free_contiguous_pages()=3D> __free_frozen_page=
s()=3D>
> > > > free_pages_prepare(), right? Or am I missing something?
> > >
> > > But they're called with order that is smaller than the original order=
.
> > > That's could be problematic; for example, memory profiling stores met=
adata
> > > only on the first page. If you pass anything other than the first pag=
e
> > > to free_pages_prepare(), it will not recognize that metadata was stor=
ed
> > > during allocation.
> > >
> >
> > Right, with MEM_ALLOC_PROFILING enabled, I ran into the following
> > WARNING when freeing all blocks except the 1st one (which contains the
> > original head page):
> >
> > [ 2101.713669] ------------[ cut here ]------------
> > [ 2101.713670] alloc_tag was not set
> > [ 2101.713671] WARNING: ./include/linux/alloc_tag.h:164 at
> > __pgalloc_tag_sub+0xdf/0x160, CPU#18: hugetlb-mfr-3pa/33675
> > [ 2101.713693] CPU: 18 UID: 0 PID: 33675 Comm: hugetlb-mfr-3pa
> > Tainted: G S W O 6.19.0-smp-DEV #2 NONE
> > [ 2101.713698] Tainted: [S]=3DCPU_OUT_OF_SPEC, [W]=3DWARN, [O]=3DOOT_MO=
DULE
> > [ 2101.713702] RIP: 0010:__pgalloc_tag_sub+0xdf/0x160
> > ...
> > [ 2101.713723] Call Trace:
> > [ 2101.713725] <TASK>
> > [ 2101.713727] free_has_hwpoison_pages+0xbc/0x370
> > [ 2101.713731] free_frozen_pages+0xb3/0x100
> > [ 2101.713733] __folio_put+0xd5/0x100
> > [ 2101.713739] dissolve_free_hugetlb_folio+0x17f/0x1a0
> > [ 2101.713743] filemap_offline_hwpoison_folio+0x193/0x4c0
> > [ 2101.713747] ? __pfx_workingset_update_node+0x10/0x10
> > [ 2101.713751] remove_inode_hugepages+0x209/0x690
> > [ 2101.713757] ? on_each_cpu_cond_mask+0x1a/0x20
> > [ 2101.713760] ? __cond_resched+0x23/0x60
> > [ 2101.713768] ? n_tty_write+0x4c7/0x500
> > [ 2101.713773] hugetlbfs_setattr+0x127/0x170
> > [ 2101.713776] notify_change+0x32e/0x390
> > [ 2101.713781] do_ftruncate+0x12c/0x1a0
> > [ 2101.713786] __x64_sys_ftruncate+0x3e/0x70
> > [ 2101.713789] do_syscall_64+0x6f/0x890
> > [ 2101.713792] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 2101.713811] </TASK>
> > [ 2101.713812] ---[ end trace 0000000000000000 ]---
> >
> > This is because in free_pages_prepare(), pgalloc_tag_sub() found there
> > is no alloc tag on the compound page being freeing.
> >
> > > In general, I think they're not designed to handle cases where
> > > the allocation order and the free order differ (unless we split
> > > metadata like __split_unmapped_folio() does).
> >
> > I believe the proper way to fix this is to do something similar to
> > pgalloc_tag_split(), used by __split_unmapped_folio().
>
> Yeah, that will work.
>
> The difference is that pgalloc_tag_split(), split_page_owner(), and
> split_page_memcg() only support splitting the whole page into many (> 1)
> smaller pieces, but we're trying to create only one smaller page from the
> original page.
>
> > When we split a
> > new block from the original folio, we create a compound page from the
> > block (just the way prep_compound_page_to_free does) and link the
> > alloc tag of the original head page to the head of the new compound
> > page.
> >
> > Something like copy_alloc_tag (to be added in v3) below to demo
> > my idea, assuming tag=3Dpgalloc_tag_get(original head page):

Actually I had another idea for page metadata like page alloc tag and
page owner - how about we do the special handling AFTER
free_pages_prepare()?

Looking at free_pages_prepare, it actually breaks down compound page
(if it is compound, using free_tail_page_prepare), adjust page flags,
and deals page metadata:

for (i =3D 1; i < (1 << order); i++) {
    if (compound)
        bad +=3D free_tail_page_prepare(page, page + i);
...
page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
reset_page_owner(page, order);
page_table_check_free(page, order);
pgalloc_tag_sub(page, 1 << order);

Even the original compound page has some HWPoison pages, these
operations should be done in the same way when no HWPoison page exist.
The compound structure will be gone after free, the alloc tag will be
reduced after free, the page owner will be reset after free. So
instead of splitting these stuff into temporary compound pages, why
not getting rid of them in the first place with free_pages_prepare()?
This is unique to the freeing path, so we don't need to mimic
everything __split_unmapped_folio() does.

At high level, applying the idea to __free_pages_ok (or
__free_frozen_pages) looks like this:

+static bool compound_has_hwpoisoned(struct page *page, unsigned int order)
 {
+       if (order =3D=3D 0 || !PageCompound(page))
+               return false;
+
+       return folio_test_has_hwpoisoned(page_folio(page));
+}

static void __free_pages_ok(struct page *page, unsigned int order,
 {
        unsigned long pfn =3D page_to_pfn(page);
        struct zone *zone =3D page_zone(page);
+       bool should_fhh =3D compound_has_hwpoisoned(page, order);

-       if (free_pages_prepare(page, order))
-               free_one_page(zone, page, pfn, order, fpi_flags);
+       if (!free_pages_prepare(page, order))
+               return;
+
+       if (should_fhh) {
+               free_has_hwpoisoned(page, order, fpi_flags);
+               return;
+       }
+
+       free_one_page(zone, page, pfn, order, fpi_flags);
 }

Under this idea, free_has_hwpoisoned() doesn't need
prepare_compound_page_to_free() anymore. It can just directly call
free_one_page() when it selects the right order.

The only imperfect part is compound_has_hwpoisoned(), that we need to
make a call to whether free_has_hwpoisoned() or not ealier than
free_pages_prepare(). free_pages_prepare() clears PAGE_FLAGS_SECOND
flags on the first tail page of a compound, which clears
PG_has_hwpoisoned. On the other hand, we can't easily exclude
PG_has_hwpoisoned from PAGE_FLAGS_SECOND. Because PG_has_hwpoisoned =3D=3D
PG_active, free_page_is_bad() will confuse and complaint that the
first tail page is still active.

I have implemented a working prototype and tested just fine. I can
send it out as v3 after clean it up.

> >
> > +/*
> > + * Point page's alloc tag to an existing one.
> > + */
> > +static void copy_alloc_tag(struct page *page, struct alloc_tag *tag)
>
> This should be defined in lib/alloc_tag.c
>
> > +{
> > +       union pgtag_ref_handle handle;
> > +       union codetag_ref ref;
> > +       unsigned long pfn =3D page_to_pfn(page);
> > +
> > +       if (!mem_alloc_profiling_enabled())
> > +               return;
> > +
> > +       /* tag is NULL if HugeTLB page is allocated in boot process. */
> > +       if (!tag)
> > +               return;
> > +
> > +       if (!get_page_tag_ref(page, &ref, &handle))
> > +               return;
> > +
> > +       /* Avoid overriding existing alloc tag from page. */
> > +       if (!ref.ct || is_codetag_empty(&ref)) {
>
> Is it an error if the page already has a valid tag?

Probably not important anymore, but I don't think it is an error. The
split block having the original folio's head page will have a valid
tag. We don't need to set + update for this block; otherwise
alloc_tag_add_check will WARN().

>
> > +               alloc_tag_ref_set(&ref, tag);
> > +               update_page_tag_ref(handle, &ref);
> > +       }
> > +       put_page_tag_ref(handle);
> > +}
> > +
> > +static void prep_compound_page_to_free(struct page *head, unsigned int=
 order,
> > +                                      unsigned long flags, struct
> > alloc_tag *tag)
> > +{
> > +       head->flags.f =3D flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > +       head->mapping =3D NULL;
> > +       head->private =3D 0;
> > +
> > +       clear_compound_head(head);
> > +       if (order)
> > +               prep_compound_page(head, order);
> > +
> > +       copy_alloc_tag(head, tag);
>
> Do we need a similar thing for memcg? Probably not, since it should have

Yes, I think we don't need to do anything for memgc, it is already
uncharged in __folio_put().

> been uncharged before freeing (as long as we're not using it for kmem pag=
es)

You mean the folio was charged to kernel memory, right? From my
reading of uncharge_folio(), it covers the kmem case.

> Perhaps a comment on why we don't need to split memcg will be enough.
>
> Do we need a similar thing for page_owner? I think yes, although it won't
> crash or cause a warning, it will be inconsistent if we split page_owner =
in
> split_page()/__split_unmapped_folio()/etc but not in
> prep_compound_page_to_free().
>
> > +}
> >
> > I tested now the WARNING from include/linux/alloc_tag.h:164 is gone
> > for both 2M and 1G pages. BTW we also need to copy_alloc_tag() for
> > HWPoison pages before pgalloc_tag_sub().
> >
> > > > > > +             total_freed +=3D nr_pages;
> > > > > > +             curr =3D PageHWPoison(next) ? next + 1 : next;
> > > > > > +     }
> > > > > > +
> > > > > > +     pr_info("Excluded %lu hwpoison pages from folio\n", total=
_hwp);
> > > > > > +     pr_info("Freed %#lx pages from folio\n", total_freed);
> > > > > > +}
> > > > > > +
> > > > > >  void free_frozen_pages(struct page *page, unsigned int order)
> > > > > >  {
> > > > > > +     struct folio *folio =3D page_folio(page);
> > > > > > +
> > > > > > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio=
))) {
> > > > > > +             folio_clear_has_hwpoisoned(folio);
> > > > > > +             free_has_hwpoison_pages(page, order);
> > > > > > +             return;
> > > > > > +     }
> > > > > > +
> > > > >
> > > > > It feels like it's a bit random place to do has_hwpoisoned check.
> > > > > Can we move this to free_pages_prepare() where we have some
> > > > > sanity checks (and also order-0 hwpoison page handling)?
> > > >
> > > > While free_pages_prepare() seems to be a better place to do the
> > > > has_hwpoisoned check, it is not a good place to do
> > > > free_has_hwpoison_pages().
> > >
> > > Why is it not a good place for free_has_hwpoison_pages()?
> > >
> > > Callers of free_pages_prepare() are supposed to avoid freeing it back=
 to
> > > the buddy or using the page when it returns false.
> >
> > What I mean is, callers of free_pages_prepare() wouldn't know from the
> > single false return value whether 1) they should completely bail out
> > or 2) they should retry with free_has_hwpoison_pages.
>
> I was thinking that once free_pages_prepare() returns false, it already
> has done all the work to isolate HWPoison pages and freed healthy portion=
s,
> so the caller doesn't have to do anything and can bail out completely.

Does this change the meaning of free_pages_prepare()'s return value?
My first take is it returns if the preparation+check works are good. I
don't know if doing the freeing work in free_pages_prepare() is a good
idea. But if it is fine, we can actually hide the ugly
compound_has_hwpoisoned() entirely inside free_pages_prepare():
- true means preparation + check work are all good but caller needs to
free prepared+checked pages itself
- false means one of the two:
  - some check failed and it is impossible to safely free pages for callers
  - this is a compound page with some HWPoison pages, and healthy
pages are already freed safely

Doesn't seem very clean with a boolean return type...

>
> > So for now I
> > think it'd better that free_frozen_pages does the check and act upon
> > the check result. Not sure if there is a better place, or worthy to
> > change free_pages_prepare()'s return type?
> >
> > > ...except compaction_free(), which I don't have much idea what it's
> > > doing.
> > >
> > > > > >       __free_frozen_pages(page, order, FPI_NONE);
> > > > > >  }
>
> --
> Cheers,
> Harry / Hyeonggon

