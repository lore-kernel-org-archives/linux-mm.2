Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB310C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F96B6B008C; Mon, 20 Jul 2026 13:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA866B0092; Mon, 20 Jul 2026 13:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872F46B0093; Mon, 20 Jul 2026 13:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE506B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:26:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B98C3120260
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:26:17 +0000 (UTC)
X-FDA: 85009833594.05.F71B0CF
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE486100002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:26:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nZDksBNJ;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784568376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuNoMT9tYeRPYMpWqWaN4lATHuSPR1MQ4bXWUnUxpyA=;
	b=ykx7rwLQJXkYNE//WP5Xf/i58vt1EDF7o6K+rRSG/kYEFIuEE/T2NL1PzvbJuoyBGxG3Z5
	Bzc599h2Kb+/evk+HZ90+nl5lHB0c164jHzx6gSUdVRzI6gzUlWGjadEC06b84j/dIgTA/
	zv9aUpVZ9OmDwtgU3EYXjt5hiKsD5PE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nZDksBNJ;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784568376;
	b=ACgQQO9de12VSnH+324P8dnqmOJK4Hvp9lUnVWAIU6vMAtC0Je7kLiCV+mM7n2v2vpjrxl
	pUuLJl5v53ZgM9wVKrz5rYbbJQeSZKqlSKwVJQPYvZpeowADsow04RyGCMWla6m9DSBeT2
	jit+SPqPBP7YV02m5m17D+UTfVMJ1dI=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92ed3993c1eso430764285a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784568375; x=1785173175; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xuNoMT9tYeRPYMpWqWaN4lATHuSPR1MQ4bXWUnUxpyA=;
        b=nZDksBNJE1rc68bhz1ALAg4ZC4NWcrWwdaC1PF8/1wAXE7PAbfU9GtIC5WOMNeneQs
         oEsv7rexCjm/7b1ytk87DtQPzhu8zHjHKwD528s1tTbGSOdMDqTy1oZPFt1IVlE7gmN3
         0/a7/PK23LAl9wF7jmTX+9Tin7yqIRSvn4zwgEwJE1acsqoQmSqTX8vdX3wcW2h8x7Xq
         VAVhJ636PKCSR+NzX+2F5p50/p3tcA8pT/0GZX9o9eACd+pan4uI0iLAgSsbbuMEAbXc
         ZmUOLIR0e4TrZxI2Hu99j67bp2CJOvr4F2BMHAQUeq2nq8bgO9+rUV6Kz6Boz7xOaggh
         2MPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784568375; x=1785173175;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xuNoMT9tYeRPYMpWqWaN4lATHuSPR1MQ4bXWUnUxpyA=;
        b=P9pG7qT6URr4UVMWepDJ6fuvJT4ogEXaNN7fnnZ0GCpR+wy6av0FJAARpZEYzkzSrA
         96eIT9DXAbAWox6s0PPTmp1k+VuvAMirMw+nd18OuR8HQKa4dVWb2PnE51bb+/HyO2tR
         xADKXVlAZ7PHlDNs3I/3YhzPWsFyIseG6hnHSwybC0Fz22fqOn9L0+DBlTTi6F+lt10f
         Fzt9NK+Ns9TYSmuM+ovC75gIM9oklz+voxog0cuOr2Xvbp8igkZ1wUbmbvmDBQFUD+xr
         knQklGqt+KxRxWR74TsGGRj0Aj33t5d8o77/yD3+luAVXK79XnM71vRhlR0/awUVUe+1
         6j9w==
X-Forwarded-Encrypted: i=1; AHgh+Rq3jh/r1nFX8/phHY6WjqlX3zP6fbf5Gtr7kYPmB1g+oYunLof04Vnd7smfZRaTFoMwEHwEYwTA/w==@kvack.org
X-Gm-Message-State: AOJu0YxHiVmj7KPc4OJb9aV4gqLNdZCuwyaq5OrxU3lDzkzuN6I6WzbO
	A89RoXoMjhcZthDOlDsu2V8wgL9GddVQ66az2adimCAlCgAZO+2uu0CEVqjSTV9ib2c=
X-Gm-Gg: AfdE7cmuwXSzMGCps2FBl87QL3JeV3d+wJZhadC3mZZrGJgEsbU6ztlbxjO1waOP+4X
	0ckuNAm3vpOF6aZxtEYFazblEylB8Q8+evj1hN1FaB9dCW8wM3hwb1fVch2UIl/QBy0yx4jA3xh
	pPoVs5MG8oCUlobg/Ji7nAXPy8QrR4LM28viSESg1enQARTIBIMDgMtFUJ83gzMl0XLExxMS1hJ
	9GZf+9qYBhzS5QahGgk+5aypMlI/z3XMRKaGhhClszw42lFXUv/vzvQj6v6Ecllj2m35uPq0SKm
	v7n+5TYIdoWt1oKLC+wOfzlz0fx0+iUh1C96xjRdYHRrSqMspVFza3iDSoGLG2cYdOF+dGgqpVe
	+W68VghJfIP5UEktyjYS2gfuXiNvCwPYTG98EvedhDBU5BDPKOy3uH2DUe6o2GPAXndRE+HhqV9
	ESv9SwpF/EgwELJkQ5TLAKrqZOX7uhV8gLW/MTGqnBQGUa4OE9nZiuUNBWBg==
X-Received: by 2002:a05:620a:6ccd:b0:915:5cbd:1d96 with SMTP id af79cd13be357-930b3ea9fbdmr1533624685a.33.1784568375015;
        Mon, 20 Jul 2026 10:26:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b54773fbsm912994185a.39.2026.07.20.10.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 10:26:14 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:26:09 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 01/15] mm/vma: introduce VMA virtual page offset field
 and add helpers
Message-ID: <al5ZPYH-0T6IPXox@gourry-fedora-PF4VCD3F>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
 <al5CPpc7XpRX7Vbt@gourry-fedora-PF4VCD3F>
 <al5Surm6fPIl4LNA@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al5Surm6fPIl4LNA@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE486100002
X-Stat-Signature: mz497g3rufeyqme1pm84cmr8etbsb6yk
X-HE-Tag: 1784568375-724552
X-HE-Meta: U2FsdGVkX1+EFtlJ3DfISUCA830JceOKFZex8cnKakBqu+DDUWyR5oEqMVWIEUj91m2Pom+/u4TRqXyfkMdjgbNVhw8bxqOGjizCADsIzTQlQdVcvIzKAlv946ooErT5Q+FP7rmP+FkriGd/n/DoBd/Zk3agDc3+290xZ6/SClEZILw3WyOdF2Ivjtkz8MqTqgaWEqNIGZw28mziWn/jDoqM09F/Lrf6EYjF/Sggk+GSBiR3de0ttZHi37SKDOK33vrSQ9+2iHnRxa886nlZ501AnFXYAbpVq4GHMgFMrDpEmtSJAJds8n8fSbpteFI5IBaOvgV1cJvpXC45udfh5A4lM2ozQVcbdepANlpKOZZ6jKNv189cw1GOVUamN2AUy9UMCBm6WgjRh61DF65qHWpW2ZFsMLx3RoiksLX2xnevxLc/SWVaFzPgn8raRMxLEI1iR/gRmoMyg8iHYussGtiFS6rmjBoBWzWIHNsMBOCQxnkM+O8k6J2/ziudGwbfz87yazWxWgb8Hc8TPeBLLRfInCYV+52/xko04MJAzHmSSXFzVHyx24ExYvL13AlCg7dZ9cYzRTWQCm7mAF4cZAwE5O5BKnyaBkwsfmzPV6ZdwGp6fW+LFWjbX15l5KoBLR+uAl9Iebhn2e2Kc4Nft/vmKuTXdxmUOEShl/aB69k4DxATz88KY69PVBLGqtc2bGsSBRn/vBoVxQKFpp62IaLHloQc0j0Yzc8SXlKZp5OOFJv7eZwN2ntvcPvQRVDwb4nsbFdka+JLW6BBBKKm5r5OxmjCnuG4EEdo2fdkt1akIvZFo+GyG5+oyzLjWxvAmF6EG1K2gQ2Bk/TWib3n8+H+HL8sIy5Rek1KFDpezgocMBmrxMR6D0BYCrHypJpj0ssYj6yQB0fsjevzbulwcoFV7pBTVKJNde6SE9AwjJcqiBtokkQCCEeQuSuQzr1txZDrHOeHLxtVJa3y28e
 6RnJRYDu
 8BMC5jZzw/pPLgbg8SCj2k8Gb8APB1ye1Xlo7EXu4BUeL6W/3OeR7eOghKlUgMwPf4tijdFGtLZ0oUE6+vm+cqy6pkdkwX8GgWZ8y3AneSAXDKm7+XDKeD1gv0s6TM0SO5VS2DpnoqTjSfsnY16fkq33fYfnlgrOC6nIWb9+qM/M30b8aNuL39zgoqT0BWFcMKDH9OBsaIrQ+YKA4P6IVN325+TKkjw7B7YKtjOiGbszMv8BwzkLknNbyhpiLXQNG5Ro97232PDcOGjmCn7/TwCJnEVz6ehcI07Q/nzKf98K5OROgsdt8LhTXhJhedSJlkP/d4JAf+/Q4x3vI71TAu3ZwUZyUfJV8eGpMV18RuxfRRirIv+PeytNhL9LdEDPHr/6kk72BDEX9Brg3yCl5tiG41w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 05:56:52PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 20, 2026 at 11:49:00AM -0400, Gregory Price wrote:
> > On Mon, Jul 20, 2026 at 03:38:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> > >
> > > The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> > > they are unfaulted or were not remapped, otherwise it is equal to this
> > > value at the point of first fault.
> > >
> >
> > The latter half of this description is a bit confusing.
> >
> > Why would the value differ from (vma->vm_start >> PAGE_SHIFT)?
> > (because it's file backed?
> 
> Because the VMA gets remapped.
> 
> If it's remapped when it's unfaulted, then virtual page offset gets updated, if
> it's faulted then not.
> 

ahhhhh the wording is just wonky then

when faulted or remapped, x is...
when unfaulted or unremapped, x is...

instead of

x is ... if unfaulted or were not remapped, otherwise...

Sort of a complex combination of 3 negatives there.

~Gregory


