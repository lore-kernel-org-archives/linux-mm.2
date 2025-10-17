Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE24BCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3EF8E009D; Fri, 17 Oct 2025 10:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074998E003B; Fri, 17 Oct 2025 10:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA67A8E009D; Fri, 17 Oct 2025 10:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D62D58E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:16:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AB7C56FBE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:16:03 +0000 (UTC)
X-FDA: 84007805406.10.37C692A
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90693C0007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:16:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qPDdpRwr;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760710561; a=rsa-sha256;
	cv=none;
	b=yEr/sEY7XlNRz0lLMeiXJELBUes4KtT1wHo26lrXDqpLhwBC17QCAA/+7OPKG+2b636+gG
	w+DM+2wIphYqDVlvo0HVMxmPNu3StMScl22u8cIadlKmqEzVSigO64pE7RYCLnxe+/D1e3
	gFajxisZb4NU4eZ8dhH4p3OplplwBsY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qPDdpRwr;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760710561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVzUxOueMoe23PedV99GX09iPb7gK5CB+nvolBA9pVM=;
	b=NQ7BdIokcKo0XyWNNDJmgmNdXoEwwM8ZVHlWV7OPjDIgrgKGoQDyfNhJcsLQp6u03TFUBk
	N7xvhXJqCCCtwv0Tswn6RNp1Zbv+k7Rkzyu/jpf2GFRDpJ0dXE2KvUxQrIVO2sxR8oDko4
	gC3QS6CWMsf5jI1H1iFr6wi/fvT+YO8=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-87c237eca60so12632256d6.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760710561; x=1761315361; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qVzUxOueMoe23PedV99GX09iPb7gK5CB+nvolBA9pVM=;
        b=qPDdpRwrqplhntWFsq3Xz+ZrC7NX2ZWmpIXdHbZAqMALjrKhfXFa2j++rEUshazAEA
         5PG8/YreNhbCj/wDAcKClWYIRaq2RTn3/HcN6QzwSJSwAGo0XHNu0UdAzFpT/VCqI7v/
         bSrUMdtRFfHgJ0sDamyGTWVJ3pEgcvvXLAMNoa0NA+7HvtWfXrstBGbAsILYkXUj3gLH
         JMmG/8H3n8srUdGcHUx3RcSs/0CoKceWXMgx3JRtKcNgsYNizCBLDTr3Vk9qCtDQbt73
         t6qFEBNRzGVy1BjIdu7DoA8AvWKOJSCNndM011v9nT9/Z0qMh4TWotGS0lzP1jkTm8kx
         uVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710561; x=1761315361;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qVzUxOueMoe23PedV99GX09iPb7gK5CB+nvolBA9pVM=;
        b=Sz5k1qrfAG88CKnq7G2ZwlPrRmC2kY2oqBvrn9XEix5Meu9C7OdLq+5h62Z+OWlBUC
         CjWxjv/51jENZ6z6339KVUAYy9Ih2N6ahyuqMzlvzp4ZXEpY4dY6fpI2iiyM5PEsbGDr
         ZfBb94C1eMDBWgHymSsn6AsvfoTJ8A9+amslSFAEJiJpimFDFwJEKfuFexHIIm/Jcfo9
         Tp86Tb15US5w6o+HfLbXdxH2B20ItfNMMdYRLU1/yw6xXG9rfgBeB+U3UFDl7oxT6o8O
         Lh3IOll/KIhhnA62Nchg66bK7ESjpJzmTFH3GFrBaq/aIZLTExDB8wHoFO/05swscjdw
         pO3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQ1NVtgwh+TvkSB1XfBu0YLwD7zf9dRghPedv5kQlCCuLjjlu7OoHJ0lwiRAl/3ERsf6lkaP2x4g==@kvack.org
X-Gm-Message-State: AOJu0YzzQ1A1iEKueUPA1IFSZoc6d6SeILu59moDWGd+gy/zxfh0wF4E
	E8vf1owtZw7QOKPMRyFafpbJayoP1nL7tFiTOTQ5MyhYIFxH4fQBP/4G5Tde+CJuKT8=
X-Gm-Gg: ASbGncslK4nL0m6EbRCdMw+vx3gbbMC+D+ZFaf/fHkn2E0CTor8vfyABCVKz0HEUHCD
	BxnPvWWM2QCQtOUa8dJMXv29JFsvgZIP5rPh+RVImMxFvaeBrWQ91M3f2LP+trqOBCDEoJis5eC
	QJKdWoG92XKmVhoaKANPXbul9VJscESK2QWyGJy/TRRZlmeoridyAcbMOa4RtktkVBLObEn2Gfl
	XNPOSlLTRvLuBSX5zV9d1hytoRylI62GcnbTkdL5FatT2AY5cLTuXHIocE3BXSQW7hbFavC7+pF
	Sl9jIKhTH5LnlsEBnPT1CecnD94XXrJLTQwfduOOq/xLWpvGm8XbAoKXClxHSLDjlzHZYOVbxRE
	6fD0jer3dIc8rmklKeBGBvnJnD3XW0y2H1XqGwTmUNQhOCcfm84FvjsEN4P+qkpcNBI3boVSFYl
	3dX9IYE9f0/O2LSjVMNg7jD/RSLutmvipVbBR+56GQFcz+56b9zCPcq1qeJYyqAaWBt84MPA==
X-Google-Smtp-Source: AGHT+IHYGMe/FQy2ELhyRR228KkbeZxsT8SFrCJQWGcsvds5mR5O+zJihPxkSY4vC4O8HUM03y5vTg==
X-Received: by 2002:a05:622a:15c2:b0:4e7:20ed:2fc3 with SMTP id d75a77b69052e-4e89d1fe50cmr43536201cf.5.1760710560578;
        Fri, 17 Oct 2025 07:16:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e881c8a219sm66162341cf.18.2025.10.17.07.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:16:00 -0700 (PDT)
Date: Fri, 17 Oct 2025 10:15:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
References: <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
 <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
 <20250925162426.00007474@huawei.com>
 <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com>
 <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
 <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
 <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: qby3zgkqthdtkb55wudd5e6qet5ya6r1
X-Rspamd-Queue-Id: 90693C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760710561-327030
X-HE-Meta: U2FsdGVkX1+hEUCH7tkkj9h5vb0mDUDSQuKEcG4pnN+F0Hp28F82s8uhCieQ2Rp1l/Op/rFF4yrk1sGQZ0YIXZs5W3rWt3IGZ3koWD0h3UMqmeV1VjkiS7yNhVZLnNYMgXsDE4ISO+hA0/C71w0QGPQ8nqFT7GuFAuMSi4Z1SLPD0iKtIbPq/y+aAMhv3EMHwobt13pdaFZAc3UjGuG0NNE344APjc1kxRUKQkWzAVuJlttb9YkTtzqy1UyH929k7J1YWx85BaaLlSyil+ctFeckdgkkXLGhRAFDzSvcp23iwEkCxP+ljvbDRI+rmDEByoi9j1mDyOpo9isyvOGRFPZfQv51ofLRDt4mODq3m20e4NIOw8Ev+ircpMSlLjhQshDkNen/p2pLQF61UQXx30bxVfnKRn4hMPJhh+ailCE+N7EzyOa938+mx81mfNP+Zi+UNSs0eR2kIcDH/9zDyzBsrQljVaR+Z/3NkNy3rFQ8QhtHrat1TJslfmdeokBaPxSKYuPm5gXlOMjrRCG87b0rJ6f2jAw0xt7rrds9FRpR7q6hMQtLAdJC96D6xxnRqNnPAtE2l0Fr1FTaHn0CbwRm3tE9vMQNGm5yLdQE5VtRkR4IlZtn1/shlbxyUknVB283gW3DHgsYDGZSH8bC2WLcYk6TVHEwdI14RtdEoHO0Vg6wIF9r0RhYuSdsFJ9q6K2FraMI/RZDPm3shH6UzjYftiffLstso0LtfkSHDm5959gcTDOq4YQAaQpW8sYu5PTChy51EF6a7S9ewJG0Cj4FedA4e5WE46Dm7IX4cUppTonB65DWILw6W9iAZaa22RaofGYwz8h02NqQvhmLgQ8q0yJH37BXzxs/+QJTia43aMDH7hMrcOuWNupYCLt7RqtXbYAFfAZ8kekN90yWGtQSbiikfM+cbJ3NvToN6E+x/CARX4EZNKEQhlOsjI+GpVZj1iA7EndrOznUFoj
 EO5CAYmn
 ungd9gN71x1HomOK5ULjd57Axo3CD4OiKaEYGf0WT4q7cWVTTJTglJPigY02ewOk34KMX51+NfRl60JXkTqxKOz6PuegF3dHPUctoXiMStJ7cB2bV/asyb8/LQyXU7ibUikWJgBChix0uBN0bGsECG888DihRQ2qht5Rby2uVhCKdUy0dpniLeIZHR1wWPQnAE1M6bcDIlvuv3TFGSv9zmZZbu8FpDnhFl2a4ct+XgjDtCSran4ynPweid1uVZ0oRlpw5BFsvs/kkAFkJ0E/xJK962piAHEbG4SFJNbumbL4BpfcGgfc0tcLfyzOJSDu7MF8OYhYHMtsFHf/kXkRgc45O3klb+uRXJFtuW5hdSto8vIc5Cw6nOBx1K6XCeXoauj3l+6OJpxH9M60nTX4n4kaI3jIXyGkyCycpS7rynlHeuZhPj3n/RtD9fe/NwyX309oREGORezXGGk2T57VhzttBSZPgYLaiVdaDs5cUGYEZAfI35eiCPVDBvLhdDg/AYpxYVdbRNLNIaCW2u462B2TZQthMfJXgehrOxVewfc5jr0ILhe/fvy0QIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 11:53:31AM +0200, Yiannis Nikolakopoulos wrote:
> On Wed, Oct 1, 2025 at 9:22 AM Gregory Price <gourry@gourry.net> wrote:
> > 1. Carve out an explicit proximity domain (NUMA node) for the compressed
> >    region via SRAT.
> >    https://docs.kernel.org/driver-api/cxl/platform/acpi/srat.html
> >
> > 2. Make sure this proximity domain (NUMA node) has separate data in the
> >    HMAT so it can be an explicit demotion target for higher tiers
> >    https://docs.kernel.org/driver-api/cxl/platform/acpi/hmat.html
> This makes sense. I've done a dirty hardcoding trick in my prototype
> so that my node is always the last target. I'll have a look on how to
> make this right.

I think it's probably a CEDT/CDAT/HMAT/SRAT/etc negotiation.

Essentially the platform needs to allow a single device to expose
multiple numa nodes based on different expected performance.  From
those ranges.  Then software needs to program the HDM decoders
appropriately.

> > 5. in `alloc_migration_target()` mm/migrate.c
> >    Since nid is not a valid buddy-allocator target, everything here
> >    will fail.  So we can simply append the following to the bottom
> >
> >    device_folio_alloc = nid_to_alloc(nid, DEVICE_FOLIO_ALLOC);
> >    if (device_folio_alloc)
> >        folio = device_folio_alloc(...)
> >    return folio;
> In my current prototype alloc_migration_target was working (naively).
> Steps 3, 4 and 5 seem like an interesting thing to try after all this
> discussion.
> >

Right because the memory is directly accessible to the buddy allocator.
What i'm proposing would remove this memory from the buddy allocator and
force more explicit integration (in this case with this function).

more explicitly: in this design __folio_alloc can never access this
                 memory.

~Gregory

