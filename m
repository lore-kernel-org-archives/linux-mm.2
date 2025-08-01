Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998A4C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6D56B007B; Fri,  1 Aug 2025 00:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97A96B0088; Fri,  1 Aug 2025 00:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD956B008A; Fri,  1 Aug 2025 00:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C82866B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:30:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E5EF5E1D7
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:30:22 +0000 (UTC)
X-FDA: 83726911884.28.BCA3B6C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 73F7A1C0003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:30:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=deDieKCr;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754022620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=piYJV8Y4LjN/W8XtRqLL1KO0JAveKpssg3VbBT7bOd4=;
	b=pMiHLuxip5MkXzMPb5ivE7aWbdGYXy61Yuw2QWru4IKBDfmn4POcxGbyOpr3WDVCFlSYuf
	j6w10Fe2tZ6//rSfeM4Q12eXgrR3RuCva4mIAhi/PabATzByn5UTBemtAKfZ41oLDUmUdM
	i/XguZkgFnligc171SAIqz50DzVSw1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754022620; a=rsa-sha256;
	cv=none;
	b=ONCwDwfYroEB++sGKMBTn7CnZLgQtH78+PjKLxVi6KhC0Dx33D1qWuoz3GnAabYJhXU1bw
	Uull/LQItXTXu0868kAOIGrtZKvgDDlP+0eWx6zD+NIAcKTOfQpIeh+Pb7qcMQGExtrsLB
	tsHsbsLZXVHkmnuia3+MIiRmpW5nB+M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=deDieKCr;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b421b70f986so1443687a12.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754022619; x=1754627419; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=piYJV8Y4LjN/W8XtRqLL1KO0JAveKpssg3VbBT7bOd4=;
        b=deDieKCrMo+M6OgaXmzf4kv61/3NA41UTPKifvflUR3N0HzS/NKmjDwIwjHzIxZtp6
         t2FVjKuWePKzQzaOnjjmc9uMoaNvEfytSw24J5aB5mrcqDXxBl4U7J0boa5JoxtuZ/4S
         H6J3ymez+eSDn4MdeoYb5yn+Bt1m+U8NRamIez8769ZA3KpFX5Jkd/tS/7y/N1ghiplY
         Oq6OPFyPL7+yBl8FMqR6bZnw5Ez5m039hD+csBMcxr57RRs7tddClULAJCiNKlkLEbP2
         svvi+cpMivkm7u23z/b7NxhHZU+diKEr0MtZEn4E3DYPZDMJ0cqOQri+QeH5hsC/VAMT
         bEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754022619; x=1754627419;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=piYJV8Y4LjN/W8XtRqLL1KO0JAveKpssg3VbBT7bOd4=;
        b=Z2e7RxnVJ3JpIQDeXu09+PXrb2t75UGgHefevO2M7SilGPD4N9tJ1iSDeOxrPf7e33
         ci+0q2JgOtj3jzp7hHctHXDdA2bA+pBI/j3j3X0sdgBuLviqe59Uqc/DjkIlKJ+38euL
         dYB1FdS+8SxZwFoYJW531iOMLYz+zo7QuY1HuEkN2AifmZkjqCtvbW/90EelOswD2ipG
         SAoU5Bb5RWgpU/yPUA1XZEi0IT4bVTHQR9aGqNK5rAwde9vZSB6RDlgwJmfXzQA/5tdh
         a5PO3yUvIyWVIW0/S3AYsATw/9QfyqUFNYe0Buao1cxwzWO51BLUSD1x7IArdFbS2mif
         VgOA==
X-Forwarded-Encrypted: i=1; AJvYcCVioWKjDclWbRY0n12JueAYtHV96c2lCpnnC5LZaAUrgRG4mxglLH0aDC1Kt68R5XgUHVJJeRwuSg==@kvack.org
X-Gm-Message-State: AOJu0Yzx7KAJr2OAUbEJGA9DI5wlTipxA7Ii/yxV2fWQW/k0Q2KP1hYN
	ZJyR4jcusA0efOV7n3y9ZUtX8SRTJhYCSC+rkwZ3j5+xLluBYi8wXl7j
X-Gm-Gg: ASbGnctpU0zsr2XNWWAszPKsGexzFlNc7WDXjnkdJkQPjAoh17o5wVWOEJiOl1S9D/T
	UXVYAtpeRiQr1N3n2RhiC+2NAOKlNVm2rhvAzDGx0wRHJFw7uG7pXg7L9iOwiUsRtF9mqdNj/8b
	Xamvm7uYUiLyBw/JomNPpL4jRZ0D3FMLthChWExlq1BntqdSAnXuoj31NhSFlQeJ+521GH/TsO9
	veeDotSgXEOcYR7nN4bPK8Ru43Nx1Jz3FLYJz4GpS57ajm2mtfq1eZQM6f60KY3mwYrm4EvieCy
	tj1YikVzQEIodmItJ6kiZH42C3QBmVE98A/n552JmveyElTB1HgyCvGiNn8OgQHd+OgL41qLyu7
	W2Iyo4nNynkJmqjY=
X-Google-Smtp-Source: AGHT+IHsBcZ7jbf88T/H26yKkIr5RGXZAEkQ0zGeJsJopMViNuzkuMhxbnUjM/2qC4wMrVQtn4dP+A==
X-Received: by 2002:a05:6a20:12d1:b0:21f:a6c9:34d with SMTP id adf61e73a8af0-23dc0cf620fmr14523968637.1.1754022619024;
        Thu, 31 Jul 2025 21:30:19 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8fa92sm2999321b3a.45.2025.07.31.21.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 21:30:18 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 2/4] mm: add static huge zero folio
In-Reply-To: <20250724145001.487878-3-kernel@pankajraghav.com>
Date: Fri, 01 Aug 2025 09:53:56 +0530
Message-ID: <87tt2rr7oj.fsf@gmail.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com> <20250724145001.487878-3-kernel@pankajraghav.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 73F7A1C0003
X-Stat-Signature: b9kozg7h4negbgqao9aau1e7wouh96ks
X-Rspam-User: 
X-HE-Tag: 1754022620-102309
X-HE-Meta: U2FsdGVkX18kW4FTeoTf47KOysKJsra56jkCvgrgFyd3nV0rxe+G/lZ61jIZJBoobT472wED64RCNsd7f4mf3cSQKk9b7cKOqWfZ9YogP/mr9TlMJa8tiib7VQTXDIw7pXAN7dHMzgU35H18sfwEspUCQ009rn+TUREbPX9X0tWte+q/rpcyXiRyDkNXF8aDHhDX5jgP4Lrx2QTwpLfW4mYd12/imISc5w8qWrBOFgQngAD090aGDoeDeoLB27s1y45MtsA82zuDMaKaub7TsoeTrjSjkqIOrUgiARLYqZN9YfhziaHcZhkbN3STI35HXB6C+CF5a0ZzAKHPOdQcgW3y1SfJIjlq0rtE3gdEkBWiSpeLh//zzJ1HqM9dJKqe8SUK/WdjzM7YqQVgjG9oSbgPA6X1tzTm6Pht8t8cGIGNh29L5a3khcdb8sapsmdyNThD/aWwaI7LYE3b+qWpX4ELKEr67HgAZkMavguhkr1s7yrgIy4l/CnSg4qAWMBtMNJVx5uP23wHDDb4UgRxYA2IaoLFWuTj/2undb6KVIVn1YedPXSItp3lncQ+RK+CQWPS4FFhzzQtP76zzgLjg3KzvplUX4x+lyia5TuVCGoDO9aMHl5Scn3iVDlzo5V4neGyj62jFWeKC1gZVl2Li3FU9XkybLrZKXGlnssdyjWWcFtguImswqE0Y3hhrKPHEVqPLhaoPF4Blspyr6pnt533ZS0AI6yeA/bdquOVTZu/6lomiz+EN8728sk2lAnZgMP6xsUsv4j/cZmcdPYWT7x2JSLMrsA0CEPkZsMfMD5G/voos2hNdr8yn9sc9Vu6jOAZp/+gDDuuTWqYE0j0TBq4GIsX8eKOjNmTkXFfQKAplX7n7qV6JOv2Vnpc2N52/1rK4poof97PfV/Io5CuiDff66ByJAA5STze+WgSIUGXWMTmkIUJaax48JW9rgVgqFkPwBwohnHZEcpIyUv
 09R6c8Mm
 hRRyXR5gUKWS+DmjGDud8H4PSNReWHk70cNdXKxIVcp46jpmdio16hmgw73bG1GmMsPDXG4Yj+TrDzVQ7nDB1pAsn4xUFIUVuw7MaM+hOlsx9GdU0UjYBUOkwmO4wtWWSsU5qdeQjDZPq1CNAELs3byDvugI6mgykI82pYHzYXrSolb5GDpOnzXDTGpDuSaprmoOGqZf+nvmHkdMo/OwF5u4tGrPkqB6zolrVd36QqoP/jcp8wxbHVI38Yre1Ii1Jri/aRpHXYBTK+wpOtx3qlchg1J+yZzfJKcgeClVaRK+kqvbJd6Xp0llKKNneoolOmoVo97h6D45Yr1GRq3VwLLnPQ5TfubOhZ8bUPNKXMUJ2V2qceCsGi14PzlByYwbMiRADovzyzyEom/j4frHd6fW8uZEyI6xANV1GTVY5Gy9TjhjorZe0H6J4fMpo7mUu2bHWWHCKbllKsgPz9ra1CntXtiqO/KdBOEIgnt8HculPcgr6U44Ne3ephQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:

> From: Pankaj Raghav <p.raghav@samsung.com>
>
> There are many places in the kernel where we need to zeroout larger
> chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> is limited by PAGE_SIZE.
>
> This is especially annoying in block devices and filesystems where we
> attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
> bvec support in block layer, it is much more efficient to send out
> larger zero pages as a part of single bvec.
>
> This concern was raised during the review of adding LBS support to
> XFS[1][2].
>
> Usually huge_zero_folio is allocated on demand, and it will be
> deallocated by the shrinker if there are no users of it left. At moment,
> huge_zero_folio infrastructure refcount is tied to the process lifetime
> that created it. This might not work for bio layer as the completions
> can be async and the process that created the huge_zero_folio might no
> longer be alive. And, one of the main point that came during discussion
> is to have something bigger than zero page as a drop-in replacement.
>
> Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
> the huge_zero_folio, and it will never drop the reference. This makes
> using the huge_zero_folio without having to pass any mm struct and does
> not tie the lifetime of the zero folio to anything, making it a drop-in
> replacement for ZERO_PAGE.
>
> If STATIC_HUGE_ZERO_FOLIO config option is enabled, then
> mm_get_huge_zero_folio() will simply return this page instead of
> dynamically allocating a new PMD page.
>
> This option can waste memory in small systems or systems with 64k base
> page size. So make it an opt-in and also add an option from individual
> architecture so that we don't enable this feature for larger base page
> size systems.

Can you please help me understand why will there be memory waste with
64k base pagesize, if this feature gets enabled?

Is it because systems with 64k base pagsize can have a much larger PMD
size then 2M and hence this static huge folio won't really get used?

Just want to understand this better. On Power with Radix MMU, PMD size
is still 2M, but with Hash it can be 16M.
So I was considering if we should enable this with Radix. Hence the ask
to better understand this.

-ritesh

