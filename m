Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35412FD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B516B01F6; Thu, 26 Feb 2026 15:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60EDE6B01F8; Thu, 26 Feb 2026 15:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3856B01FF; Thu, 26 Feb 2026 15:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37AB36B01F6
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:48:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9E7A1C0B9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:48:18 +0000 (UTC)
X-FDA: 84487795476.22.7C4CFE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E52AA0019
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:48:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ICCyM2KG;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772138896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBGoyglCoH58OEzLS/UrEve2JlXeuQURn1O9kwrT3LQ=;
	b=YIApAqJqlKMs+59TESnbHNoYJaRICTqUcKto1SgN9YgEBLv3EbxLwCeKvnBLFbyya/7Dy9
	M5cGSY0GTUFLFo0anOCckoK9GSUaodQqYr6w5tluPJL16sOENPI9ulyX9Vd1YDZFVV3SGp
	jFcw2e9kzIq6+f50cEDWTGnN8o/GlAY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ICCyM2KG;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772138896; a=rsa-sha256;
	cv=none;
	b=Ivudo6W8sUOfwZpnW00SlLdV9GEJlgJFuQjdxspe4B/L8sz1evNu3rw8qTnht5TjL3LQZC
	L03gIXLE1HC68FuIm1zoPs3D3frRzDlxOcSpRUDhHc7OeuaS3Nzy4oS8LJx7tBMEqRWwLv
	scxTa/Suug/ziwh3GShHXjhMPJi3ex0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772138896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DBGoyglCoH58OEzLS/UrEve2JlXeuQURn1O9kwrT3LQ=;
	b=ICCyM2KG2hhTcRjPu7XnHwBoH59AwAaNTBW8O4Ws4Cu1QfPoxyHEDSv9IR3rjOP6k+mkQA
	3g+GcrIBuHUDVTga70WPNQnaZIEvMiKRv7FgGodPRfRhfJHxqaUMcW3kpWrtNZRwQqGCyO
	/4sLVv1RsMViE/IBUlU0Tx5ASrmv8W4=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-e--aC8vHPNWOzTJtvismmQ-1; Thu, 26 Feb 2026 15:48:12 -0500
X-MC-Unique: e--aC8vHPNWOzTJtvismmQ-1
X-Mimecast-MFC-AGG-ID: e--aC8vHPNWOzTJtvismmQ_1772138892
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-64c9d15b682so1933992d50.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:48:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772138891; x=1772743691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DBGoyglCoH58OEzLS/UrEve2JlXeuQURn1O9kwrT3LQ=;
        b=b65WgJyHmNJt46ahFxNleXyc6ZLyqjaahjvvzv/nl+i8wjVU43P3kxOoPrxavFv3CW
         zHWd+4uq2NL3b99hSb2YyoTNpDdpjShkhwNa7rUn7jbKA92J53sw1HdMvHVmXWI0TkfY
         ZspQcZ5Lk37GL4YVnRTmBLmxmCshO2UbiVkrAD5+mB0VkFOKYzLTgdtt751u03Ude2IJ
         Xji/7eL0EuUi6UOTLnA+an9Gi+ULwC4twB8vA57614H2nQ9T4Az3evmnzSy3etbQufYQ
         ovr+R905DeSzvFUCMD8u4YAvoUPH3Jk/E2etzFy3J58LXq71H3peJ/ctCRfCUZoBrgYa
         zBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKDavtLHlgPiqBmrSHEOZvkF8nJONsWyn2eCc4u/k6pyidnRmTdZXHhlXYNBhExG8Tsntz3Yg+Hg==@kvack.org
X-Gm-Message-State: AOJu0YxZz4lcr7iRztIDXJ54fVwkQqIou6H2cQEdrnyJnwyp2Ed/rS5b
	IqKeOVNMFMYK+qtKRvvTvDiCApv5azdoTPdq23gcBsByaNaRH+Y3oCS+0aX5CMPC4kee5XSsHwq
	qfVEUMhYxNGf0M1cvJgBY4tewIhogw+7SYXfQ6922UC1JLRE/PfYkzgnocOkra39dK9xJuevSxP
	ecYwL64LvQ7ExQelEhGlqrwk0WDqo=
X-Gm-Gg: ATEYQzz7vxKfTB9qLWHQPsDFpa/d1gC1jl/leQRTeFCZiYJYiDsOy7JdcyoiW3kTFbm
	+8lStRjmaqDXhP566KyED8mShyx9bdwsZFDGkQ0JUbrtWHR6OGp8AlXbi+6WDABaywQqiHNB1Uf
	bCo4UNO2mqFvW8jRTZsyBzBkyJxCWWG8b7GJXhFo4ZH77uLaU8BdWPPX5lSBXP4BR0mRDbj+1cD
	wVU
X-Received: by 2002:a53:b3cd:0:b0:64c:21c4:d017 with SMTP id 956f58d0204a3-64cc23040bdmr466110d50.78.1772138891641;
        Thu, 26 Feb 2026 12:48:11 -0800 (PST)
X-Received: by 2002:a53:b3cd:0:b0:64c:21c4:d017 with SMTP id
 956f58d0204a3-64cc23040bdmr466079d50.78.1772138891111; Thu, 26 Feb 2026
 12:48:11 -0800 (PST)
MIME-Version: 1.0
References: <20260226032631.234234-1-npache@redhat.com> <20260226162653.3802758-1-usama.arif@linux.dev>
In-Reply-To: <20260226162653.3802758-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Thu, 26 Feb 2026 13:47:45 -0700
X-Gm-Features: AaiRm52157O9qaaRKfnMN5AsfoDvaP_wlb8rkPZ8cTI77RXDfAxJaKiPZ96ZOHw
Message-ID: <CAA1CXcCwXAn8uSidF52o=PBUUY-JwT14U70yxtMuUX=iQqRaPw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v15 11/13] mm/khugepaged: avoid unnecessary
 mTHP collapse attempts
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0odAW-jIjAlg6lMW4JgimiA_bciYGf2WTGx6Zfy-qyk_1772138892
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3dhq6skeijphmtk8sk7mfamypzd35s4u
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E52AA0019
X-Rspamd-Server: rspam04
X-HE-Tag: 1772138896-765544
X-HE-Meta: U2FsdGVkX1+03ylgO1GF0LR5jp3EYELKQJMQ3S8RsLhAEwwPGFjhUK3tIvaa+TEWF0ZZ5Hgpld4KoxE/hMbHhNIgV8uVQLuO4pWoKU+i7/dj0hqSXKEv3CYouCpk7NlLstV7VPbAY+FQBUeZMNcdtzyyRIKITFhscvJCKrXpamSeRvipxogZpIvhOpscjNGXKYne6DQdgjhLc+FzOt1Sk9ow5eVlDGs9a5q+lHzFvDpkjmPxZPLxEj8aqOLekNQ1oiGlWr0nia7rRR2zGkFZmRHkamycBhCvhbL6N/VX5j/fi/rj6szp/D27tK4jzmqUJf+qlInYcKZrHtSKsY7NYDT9kWCw5dP4yTexqjQwiOSWo5GJZlJj2z4841r6N9bRUg7KsyftlyV4XdHXEssI2JBwHCZXCl7sy2+KN7yU9NZnagmeImtpPWvhJeotqWe7iwhwWIM4xFsCSzEqD4rvv0l+f8nAOgO4XyPobO+7y4ed8nDXacHtzzrip6UetkJDAWzJLoBC5abqcHR4FCro9lT6+7GZfm3s7cDNAqkKDCjh8bIxecfjlWRpQ5G5GOqjjxWa7h+23Nkdg95JGGes8YdZCNCDWaZs0BEDCh24oJOuR81ClqPy8vJFXCy4KTtTQxmDW5UO5WD7awzEdrQ09AYD6Ul8G/n2OrGreKOUoq73oOpJD2KXdmA3w/uGvVTlquyxRTJdjabWKHW+0q6sMQr8o6I6CODcbDXf3uqQ/wzMjY5yatBCpBN9LfBh3za2KZgRC4ch/Oe6LDieoLUGWiWeFQeZyYvRCWt4Za8w9/1lhTjzL2RdFRgTlRO3fyxdFDJlzcHFzcQpxzzpwFbHWNU4Ro+89gJR/T37zDfYq1SWSxdTXe4vVHOEgv7WFu2mdzsAibuVQ5uBmN+rDGvEVqgmK6Xx9D7z9Gdjt2oL9xt8FGBuy6NRDumm1P6DyZ4HbIgkYiVIM6896gFcvve
 P798k18C
 vi3XZjq3CMB6xi3B5/lxDQdWGz0WTEpC6ZAc0wtSXoK5qwWvOcr3Je2Ip3cndwt8//XTdhgSKvNGl3+JAX/M6l/yses4sVBKmF6ogag4WEV8+gZg1ENoQEncbVTCo64N2HxK6UnK/rqZbsviLFkhggjAKzMStPtxPCQfzf7FFVKXP5nDR1kUof14EfClGrmcNb5r12ZJ1GxEnyzIk31Jl8zSPo8B3QsTlB+Y7dr5vU9QPZAotoH/nm2zBbzArPShtGmurT9Vl9sjXuvTGj9Bo9G3saq7g2ZoELYOA4JYMJFEiLxx/EdaE4v8Q1k2NAhF3xXnn0N5LDuTkoYiBf4tVRo5O1Yb3nSwVTEFLb6RYfIHT2WsUFwE1xMvTdDQl5MyOmzLXrpwGGv9Toz5xY7WYoetS8AjJqassUOkdpDdBUxLg2XuLI1sdhwfJmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:27=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> On Wed, 25 Feb 2026 20:26:31 -0700 Nico Pache <npache@redhat.com> wrote:
>
> > There are cases where, if an attempted collapse fails, all subsequent
> > orders are guaranteed to also fail. Avoid these collapse attempts by
> > bailing out early.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 1c3711ed4513..388d3f2537e2 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1492,9 +1492,42 @@ static int mthp_collapse(struct mm_struct *mm, u=
nsigned long address,
> >                       ret =3D collapse_huge_page(mm, collapse_address, =
referenced,
> >                                                unmapped, cc, mmap_locke=
d,
> >                                                order);
> > -                     if (ret =3D=3D SCAN_SUCCEED) {
> > +
> > +                     switch (ret) {
> > +                     /* Cases were we continue to next collapse candid=
ate */
> > +                     case SCAN_SUCCEED:
> >                               collapsed +=3D nr_pte_entries;
> > +                             fallthrough;
> > +                     case SCAN_PTE_MAPPED_HUGEPAGE:
> >                               continue;
> > +                     /* Cases were lower orders might still succeed */
> > +                     case SCAN_LACK_REFERENCED_PAGE:
> > +                     case SCAN_EXCEED_NONE_PTE:
> > +                     case SCAN_EXCEED_SWAP_PTE:
> > +                     case SCAN_EXCEED_SHARED_PTE:
> > +                     case SCAN_PAGE_LOCK:
> > +                     case SCAN_PAGE_COUNT:
> > +                     case SCAN_PAGE_LRU:
> > +                     case SCAN_PAGE_NULL:
> > +                     case SCAN_DEL_PAGE_LRU:
> > +                     case SCAN_PTE_NON_PRESENT:
> > +                     case SCAN_PTE_UFFD_WP:
> > +                     case SCAN_ALLOC_HUGE_PAGE_FAIL:
> > +                             goto next_order;
> > +                     /* Cases were no further collapse is possible */
> > +                     case SCAN_CGROUP_CHARGE_FAIL:
>
> The only one that stands out to me is SCAN_CGROUP_CHARGE_FAIL. memcg char=
ging
> of higher order folio might fail, but a lower order folio might pass?
> That said, if the cgroup is that tight, continuing collapse work may not
> be productive.
>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thanks! IIRC, David and I discussed all of these off chain to confirm
their placement. I had this in the 'next_order' case at some point and
David recommended it to "fail" for the same reason you state here:
collapsing or charging large order pages in such a tight cgroup is
likely unproductive and not worth the effort.

In contrast, SCAN_ALLOC_HUGE_PAGE_FAIL does not necessarily indicate a
resource constraint, but it could. We might fail to allocate an N-page
size due to fragmentation, but we could easily find an (N-1) size. We
could also have a scenario where a lack of memory causes the failure,
iterating all the way down, which would be unproductive. However, at
that point the OOM reaper should be active and the system will already
be cornered in multiple ways, so it should be ok.

Hopefully that gives some insight into the decisions made here :)

Cheers,
-- Nico

>
> > +                     case SCAN_COPY_MC:
> > +                     case SCAN_ADDRESS_RANGE:
> > +                     case SCAN_NO_PTE_TABLE:
> > +                     case SCAN_ANY_PROCESS:
> > +                     case SCAN_VMA_NULL:
> > +                     case SCAN_VMA_CHECK:
> > +                     case SCAN_SCAN_ABORT:
> > +                     case SCAN_PAGE_ANON:
> > +                     case SCAN_PMD_MAPPED:
> > +                     case SCAN_FAIL:
> > +                     default:
> > +                             return collapsed;
> >                       }
> >               }
> >
> > --
> > 2.53.0
> >
> >
>


