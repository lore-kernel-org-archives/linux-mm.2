Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA54BCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CEC6B0099; Mon, 18 May 2026 15:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065006B009B; Mon, 18 May 2026 15:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC986B009D; Mon, 18 May 2026 15:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D59FE6B0099
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:22:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D867140A79
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:22:11 +0000 (UTC)
X-FDA: 84781511262.01.28B0B79
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 753D74000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:22:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vY4rZdlE;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779132129; a=rsa-sha256;
	cv=pass;
	b=jzG8TCogYwVIDqvD7w2xyr8PWhPpASJ/rZb+J9B95b6o9u8Y2VE9B4lHbAvJKhiMozYMz6
	HUIDkprGWOeeh9u8/c1+V5wD9zboLDcQ8in0uDFrdVQ6r7BYjgNwuwa2MqOnRsrrdKUkft
	fzvPxU4Lo+4frwZe6Qz0DKT93OrzZaY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vY4rZdlE;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779132129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tamJOUr/gFpbNHYCsIZYX+iIMAFW5aR8+J/DZkkw+Z4=;
	b=d1DKuKpbfDFdrek1lwEFgBVeGNnNGWKnNikWNn/KimN7TxsEZfsvhVw+lKybKsLeElFiZl
	xWFMffvyoh1en33DzUOqIfwTv0fwmydYVDnTv61sM6uVE7RQietvcHyNkHFXb3qTTuC1Pc
	NWMjPxgdcEHrmM8hnetg9U1bbEj1ry4=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48d1c670255so805e9.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:22:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779132128; cv=none;
        d=google.com; s=arc-20240605;
        b=TH5B+6XipbHGjLoYZX+nNSYbOjTY2aktGPE2SLwQfeRlvqR58bcZQPa2ajS5K21tHk
         iS5ldfxOYnfWA80mWuTpuOAy0EwLvle/eILOdO4RDEYaqRNjK8N0WG5MUJi8nsnkwol6
         RsnCDi+Ryq6c74s487GRmmvO88tiLxFmDvJqxrb0wp4vonHYj9NCHdSYtswa1uRH8aKq
         cpGmenXmhb6Ml3616bIklfjiTISj/q3z650Rat40h+Rjl8XoHNnMyiMQhT3zHL8Drvxl
         PMCPRdRJ8U8JcZykfb5YCPH8gCUFl6yYm0Q7GeZA2xVTHzaV74ahfFRJfwnKn/ZOxDBg
         mpTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tamJOUr/gFpbNHYCsIZYX+iIMAFW5aR8+J/DZkkw+Z4=;
        fh=vBJ2aSupqSpQkYC7Bqz4iTtDFNXFX+c/iYFj+dLu9qU=;
        b=P6O641RFw3hFNyK/Ss12UnWdccgnyXOo+qNLCGaGwNWt8H5UwwJYDcQcIXmXtKXX6S
         2em9O01Dri0hLH3q4miWRffJPX7qVWclotThtw2nMW3xYWAmC2Q9gFSxejPr6MZddmNh
         X7gNO6wWUVbwdQRc1msRtKHOX6Y6h2T55+dix/R78cYNUvnRp/lnH97e1jIXwzruct1S
         sMpVlGaxtKIePC97b7hsVD9pEX9hd6ebsGeoGCBMW87nId108yovsIe7DpqpHfPocnZO
         elDyJAACKVI6OziNhnesc38kTJdDtih3uK9mzLy5gjdIyDHs7nxhChHEMhiNHtJeWxBF
         DLIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779132128; x=1779736928; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tamJOUr/gFpbNHYCsIZYX+iIMAFW5aR8+J/DZkkw+Z4=;
        b=vY4rZdlEfOh1AUz9gsoOYJhzvX/q6CTphUP9IOZTyx25hZOt++nDuxt6Q6KynZ8wMH
         rCCekBchViDbHm2CEfl7NnvGrFLMROBrgWfW78QVfvDyQigDmhJGUxG+jNV/vX8hT9/C
         JvV8d8aEbqzjj0LpQt3kQyQFMK4UHga9LfV0UOPusec4+BxjwDCjpiYuvfSuzQZkFN6Z
         VMYoRLEtKETsUfwYZ9m+Je07CAQDYVSSQrd+xIZ1qf/OOUH3NBR0BWWS2pxBYoWMd4X3
         1UCpj5KMRIkkWoK8iIK826t56R+i8wsaVgfqdCX+SXfSLT17+Eedq5Ex1fkUpYh4g+zJ
         Hr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779132128; x=1779736928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tamJOUr/gFpbNHYCsIZYX+iIMAFW5aR8+J/DZkkw+Z4=;
        b=rUT2YBP7IiVEb2FQgYdqzQ2OTNU0fvRlt75dkKRG/ilmoLiDfkQVh0Kj3rOug6ssRf
         Qwu8ZYXuaH1oqvyuQedRaekhH6I6M5lyjpwUweohD00ir1o1CjoqPmgR25OuZAbzCh4q
         aBA2tv27hiNMN7jzUu2I/tCJ/M7/KKb93VRVHIlz9IOahCdejBt/e4rWAw+O1sYAXpbq
         CLDVpXOY63mPa5NSZsWKX7RHiO7BdLJWVp9hFg4TT/f+/w/hZCWhlAzI5RKydPQQlejj
         wG+HzVazI85qnKC3TlSDn+GBG0svsvxzLaHj9ne1mS+zNMpAzqukHyBM2xVgHaKuxRb7
         LwKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Mt2JwxV5WUgSruS03AMmoqnnrD0wFnNgh3jMGHFhlt6U/sNUIy69+nJH8FPq549mRkcEbnt/S/g==@kvack.org
X-Gm-Message-State: AOJu0YxNoybCpjIaiNYElBM7KgaxWHaVvS1w/iDPxOFpOZq6af+sDTgT
	qTXAxxPE/i87NgVhqnbH3+Ns08ST5cb7sbLiRe3CF7oGVYseKHkorWTaHKUC3oKSpplmhK9+sY8
	PhPla9x7S1QpdXo89Rd9ClK0iavFucJS7IlsiGa3j
X-Gm-Gg: Acq92OH39c/9mgUNhfcy4EKjEBM/7nOoPpO2fCBWjjg5oBVnsZf2r3DkwuyeaVyp/jZ
	cpW2c1G0sGCPkA02lizBM75woq5AwYkjyBdv5PtS+TckllXSDWLkhXqc1yUi7WPLKDl6ElsGvT6
	V4211ACBlOQabPWiDKq55tq5m3FbTG9JFe1yfNSgMQCXzj9Z5YKbu77dWdaK/qSPkxhy1jF65UY
	h+TXYbrxmYp9d+tp9cJmc3ru58AAMp4bQvdfsQgDDqS8nMCHNBZMJHeAs+LQwX53Ob6My8j8L/o
	SZAPV9IneH9hdsn2uGIUeq9+iZMjjRWhxCKhnHOlNZlv3dcM
X-Received: by 2002:a05:600c:6299:b0:483:6a76:11a6 with SMTP id
 5b1f17b1804b1-48ffd84253emr3382295e9.5.1779132127442; Mon, 18 May 2026
 12:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <afXGeq1AvqFY76MY@stanley.mountain> <agsrBPXYXA2vZgj1@willie-the-truck>
In-Reply-To: <agsrBPXYXA2vZgj1@willie-the-truck>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 18 May 2026 12:21:55 -0700
X-Gm-Features: AVHnY4IaFTCEtAbkOTHrQii7e8-AzKA2Ul7h3BwOA0peBU4GDfj3y7WV26rf3CU
Message-ID: <CABdmKX0hPe7itx4orMAx2Q6EQa+A4uL6yFa4in7q3vHRBQRn1w@mail.gmail.com>
Subject: Re: [bug report] dma-buf: heaps: Rework heap allocation hooks to
 return struct dma_buf instead of fd
To: Will Deacon <will@kernel.org>
Cc: Dan Carpenter <error27@gmail.com>, jstultz@google.com, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Sumit Semwal <sumit.semwal@linaro.org>, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m9obt4e8fpxye3891oteacyp8yhpppr9
X-Rspam-User: 
X-Rspamd-Queue-Id: 753D74000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1779132129-964163
X-HE-Meta: U2FsdGVkX1/OlfE369lWJ+el7a/p3tvolubS+nozdxOkzLzJT7GA0INUYc/AhCBDTrjLodbmNumdGjmcPU8ahFb6NuvTFET2TgSTv1FM6fOEQTqCPcPU5F4DMYxkR74qo/l4x2zELJ3y8YNXu2r/ucb+bIggqDxZ6Vr69cML7Zg5HBe3cWUXYMpapWrDkVuec1PsHI8vdo9YvORSuAPir55dcanVOFbKhx6IEKzMOSrGeCGL1KSdyGKZHk9yFPq9r7Wv/Dt+qb2QLPoWh6uX9DT4VfncKjg8JfrgXfAa1lS/dDN57EwV6qIP+a7TkYW+xav5Q19NkShjL6uDTBwHL68iLgyuG35PfAfhkXZtZK26EHqHsN1bvY0MCtn5xM7JRYotjerltS0W98llHVUuCm0pqr5u+or5VnT2XA7wgyE5op3O+SODRkvzI9eVxodRY6Uqvim8F8JRqgWtZLsZ1cVRcdgUUqVv06AOyx3ycb5Kq6lPzV/ikLRRAuvhoXJjv2/fBdYp6AhNAmBIMO1UFy628mpOQJJjzGlBWgVvF0W7P3WAmsYWFD+p67j1MZEwd6k1cknSJqFO0osGFeuQAYbvdYlPAc7edDkI/qV6JYFql9hRe4oVnRJXQto4Cefh2H2neVnWDcLC98tLBaX/+l20aPobiBm6XMtX0crPMcvXuQZID3uhkDU6Ezhq2/63gSQYeyJUD6a4IpmzZbVNwLwbbR+Fe/CaTMjNN8us22IvfBQVL6OczqpeCMJQ8Fm6P3ZJddLX4NFd+IXduKMbKlJS0+eWeOnJbMLhC4VJ1/TjsGdH7vKqyjmxCKiER1d/ksirKSo5+JaVCQE3mJcAP2EcOFSSeMHLHCvdnCTK5rwkQctVobNmJ1OSeUP0Y++pOUNddmV9VaPbbKh4TETcu01UBVvsRiEtsY/VXzewLYwAySoaKKjzG88f34TvJneZD+SxOrSXt08RCNDdDs/
 V6QLHTQU
 3uDHVmE24lsD424t1bPTgfw82h7v9dWwaO5bkrD75N30Wly1rENDA9eJeCIUAEdZi+22oAQ+f8Mp1koVldU/imCW6HDZwR0StM1aOEhDtBhMCKTPtbwUFYxOAIKPQUro+RxLz17huZSv3AH6FHlb9N3oNMaM9T9S3az/ZFP3RKX15mpsMD2wZGNTwVmb4ZaY5dI3apa1WvxoqH2mt+E00Pl67/WLhsijjWaWEgCgfQm4HIx3qR+gj6/lAkcYzI1mVh2qaNX5zRevidWoG3U3636AC8veIegivyomUpMBqycmcnGZHa2tu9p4ivtPHySwXmDyLSq7zLp6PaY/0eX1+SrFjFNbYW3O3MvxvAaFFGyXyEmpDyK5VboPvRuic2KAraMZXUqHnYDltCXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:06=E2=80=AFAM Will Deacon <will@kernel.org> wrote=
:
>
> On Sat, May 02, 2026 at 12:40:10PM +0300, Dan Carpenter wrote:
> > I'm not sure exactly who to report this bug too.  Probably the mm
> > devs?
>
> [Adding John and TJ, in case they are interested / able to help]
>
> Will
>
> (original report follows)
>
> >       drivers/dma-buf/heaps/system_heap.c:499 system_heap_allocate()
> >       warn: passing positive error code 's32min-(-1),1' to 'ERR_PTR'
> >
> > drivers/dma-buf/heaps/system_heap.c
> >     459         if (cc_shared) {
> >     460                 for_each_sgtable_sg(table, sg, i) {
> >     461                         ret =3D system_heap_set_page_decrypted(=
sg_page(sg));
> >     462                         if (ret)
> >     463                                 goto free_pages;
> >
> > It kind of looks like system_heap_set_page_decrypted() can return 1.
> >
> >     464                 }
> >     465         }
> >     466
> >     467         /* create the dmabuf */
> >     468         exp_info.exp_name =3D dma_heap_get_name(heap);
> >     469         exp_info.ops =3D &system_heap_buf_ops;
> >     470         exp_info.size =3D buffer->len;
> >     471         exp_info.flags =3D fd_flags;
> >     472         exp_info.priv =3D buffer;
> >     473         dmabuf =3D dma_buf_export(&exp_info);
> >     474         if (IS_ERR(dmabuf)) {
> >     475                 ret =3D PTR_ERR(dmabuf);
> >     476                 goto free_pages;
> >     477         }
> >     478         return dmabuf;
> >     479
> >     480 free_pages:
> >     481         for_each_sgtable_sg(table, sg, i) {
> >     482                 struct page *p =3D sg_page(sg);
> >     483
> >     484                 /*
> >     485                  * Intentionally leak pages that cannot be re-e=
ncrypted
> >     486                  * to prevent shared memory from being reused.
> >     487                  */
> >     488                 if (buffer->cc_shared &&
> >     489                     system_heap_set_page_encrypted(p))
> >     490                         continue;
> >     491                 __free_pages(p, compound_order(p));
> >     492         }
> >     493         sg_free_table(table);
> >     494 free_buffer:
> >     495         list_for_each_entry_safe(page, tmp_page, &pages, lru)
> >     496                 __free_pages(page, compound_order(page));
> >     497         kfree(buffer);
> >     498
> > --> 499         return ERR_PTR(ret);
> >     500 }
> >
> > The problem is that add_to_pagemap() returns PM_END_OF_BUFFER (1)
> > which is used by pagemap_read() and nowhere else.  The call tree
> > is:
> >
> > system_heap_allocate()
> > system_heap_set_page_decrypted()
> > set_memory_decrypted()
> > realm_set_memory_decrypted()
> > __set_memory_enc_dec()
> > __change_memory_common()
> > update_range_prot()
> > walk_kernel_page_table_range_lockless()
> > walk_pgd_range()
> > pagemap_pte_hole()

This doesn't look right to me. update_range_prot is in arm64 arch
code. It uses the arm64 pageattr_ops which does not provide a pte_hole
op. So walk_pgd_range should never call ops->pt_hole.

> > add_to_pagemap()
> >
> > This code seems sort of old and I guess no one has reported the bug
> > so maybe it's a false positive, but it feels like it's asking for
> > problems to return the PM_END_OF_BUFFER.  There aren't any comments
> > on any of those functions above explaining what return values are
> > expected.
> >
> > This email is a free service from the Smatch-CI project [smatch.sf.net]=
.
> >
> > regards,
> > dan carpenter

