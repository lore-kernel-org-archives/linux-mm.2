Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 416FFCD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680A56B0005; Tue, 19 May 2026 17:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6310D6B0088; Tue, 19 May 2026 17:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F94F6B008A; Tue, 19 May 2026 17:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 404426B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:19:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB17A140B56
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:19:08 +0000 (UTC)
X-FDA: 84785434776.27.A4AECD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id F3C698000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:19:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G0UA/FEU";
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779225547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smo6PG71gks5CdB+S9N8OQcbl9Tnm001jvZXKeMS2ow=;
	b=5FAaR0a2213N3YZT8u8GU5LHjH/Tel8Sn8S7ixz6QB7H+ll5gSywYMIJzD94In6iFg18ZX
	lvH7nRoKWOjuMsDJueP62Ab4qH3lMGhVZ4+Eok6SBdfAgrS2joLvr/jZfgyIBJDjwRZKgX
	Ii9fHueyFoKoFqL43qVIXgeKc/X8idc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G0UA/FEU";
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779225547; a=rsa-sha256;
	cv=none;
	b=E8t2OSzIEXqDMwqxeN+Kogp9BsXnsM2uqlAdhZmngD7eBdQQSdVbrzYycNRaxiPEmTbXNu
	noSkqZfTWsadP1t9PyBSZtx3OGBN9SFtRv9F4E7860KpDjO8kIdsXSlwdiL7mg0GiytLWL
	FtPI71FqCMZxj7BMTVcsJx4RWl0A1r0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2060D43B39
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088501F000E9
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779225546;
	bh=smo6PG71gks5CdB+S9N8OQcbl9Tnm001jvZXKeMS2ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G0UA/FEUjFyqWTBjXqy1D8nN6XnTQ/tza69bu7vYaT0U10Sf/fzWhK84PK8XxJ2Ly
	 Q5tidnkgGYVMjh5cZmn+SAtLMpLCLN8NY9CkWHNjvuKJzRaieEXAjAb4/x/if7h6b3
	 gn+7uNEnbSssk+8waSayxSlSvL7spIhn0aJVJbOyvon5Yp9BUHNF/Gqx4jXbvdqqaQ
	 BIPUCZaGw1DdYYR+BXWzCBq2UWKnaY+/3hUvSdfI0ZgL1/wrZ/fJZznjTq1cg/HBj9
	 9cabSz0K8+eDjB/T0z5WlMgXUWxq75PfpXIGDmdGF+r4yBmaptV2x85KwaugcAxKPs
	 Y8few1sLpog3g==
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50d7c12e48eso44234331cf.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 14:19:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/C8LrLnzCfJie4PGDSpyUSxfoNYbTtYpOIJmw4jIR4LqxafMsRGARHXtzlleIAM4JBVX8E9hBC/A==@kvack.org
X-Gm-Message-State: AOJu0YzYWIFuVT/cCVugTKMQfXx12isA5y9GVLsH5f66y1E18q0HhUzo
	M0ITUEIi6dgL2eEx+C3pNSdOo6v04P+Gllqaj/gaOA/+waGVLmtFiumBj9Pqc8z6/zHX76Sw9gb
	ntARU9X8CfCWfZn4og6uKQJj0WevD0Us=
X-Received: by 2002:a05:622a:8599:b0:50e:32cd:52fa with SMTP id
 d75a77b69052e-5164155aed1mr241957021cf.3.1779225544934; Tue, 19 May 2026
 14:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com> <agxbq1TxJdniMQT3@lucifer>
In-Reply-To: <agxbq1TxJdniMQT3@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Wed, 20 May 2026 05:18:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
X-Gm-Features: AVHnY4J8Vo_CuCIfUx0l4iAJBGF2Iz4ZMOGZd3FV7sXmKyNFMh0JMXgCJ8QhKkw
Message-ID: <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zmtdgz5qtdrr61t7ui1j6cn8ufozcytb
X-Rspamd-Queue-Id: F3C698000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779225546-719411
X-HE-Meta: U2FsdGVkX19la8F/EoBkGvX6tSy0LTCObOAJgVUlLbdX9m+EbIAkdC6ITmuBuMNvVbCgPbDkj/zFWOpUvBBn3tWe6BqW2+bGTC1lJEBRV7TblqPTuqnE6fiOGDudc57fOZdHwWbBiAwXnlwX2TG/+xUVuHLgins38a3bCRQaxCxp9nRb76FVNPvKDLIyTlG7ON3NAdiXpPwwx0Sdu7EfHcIke7+Z1Gbm11F0gkFQoPAfhzmD3hTUaxKJaYRrCEdnzvbu082ud4/30A9CG12OBAiHRp4MrsA0RvLDxAAAguTHz1T5xqf+VSTlgpmRGQvqLKufw9uw6KBvLrlrVwSlLwtVuMNRT1ZAtFoGJi9DOCyusJ3l6oGyohdgUGjoeV/66dhurNbendg71p+0dmh2YqQ0+NxXcaPUPtc/bpW0PYYdTRGsB2aKpR26eyd5wM2z5X/zWgTZNAU2WCh/QPApuWYiy8RL+wq/ZJ1eFhM0SPiHkeuzusbzih72I1ma3AdGPFYBwitCcGtfJwfgtrMUyAmQb/5XkIz7x/BRyeFMquM3O9tlKFxMuelUUOQ+s7C/mvofvs2HV2RE4PXpt9YybmaZUp44TRHo/eEdAAjZV1VIsEKv1ffdu/ysDTzcaMhHRj4zmH/uuAhcWNuRnaoEPAybnFoNZMyPKLnPyqhxZQgYIArpF+3rxTjIcZtY7efImQ8K4P9MIZtyBYS+BbeNwHrkVXk5TeTFyb0NWcqmTLHJcxWcb0knJAhkY6xnLwqy7FE2m2eMqlgGazRWEwyWNkVAxOe5JZ5hs+jBWZMjwIKF3NKhzMMEVSX5HGkUPnXJXhiPBPn/XLTWqveGQGo9OkLNb4/rZ7FUWBVSu7PL+AYUtPdza5qt0/98b8IHnhTohc/t5VOj2rEapzpRN5pQA1wB//j3We+RFEo8XEv7LcQu7h+olyCTHMuzVBHMZYGhw/7r6VwLm3B/jmW1qZs
 1JEUp63l
 syCgX72f1F3zX5IsKouG7BTseYGYv+mcSfao9SgXDtUin9mHAmTLGw+KUjfnf6fgfXKOnrPICj3QSd4xWSP6arT2D2oj8gzeOuWMM8IiCmoZcpY2IKGTZqXnGYY5x3vk8wOGhvA63KybcOW8eo2v4IhHVd3ODPeCmiNXRu46rVA+OHjyPnVpolqiI0tXHpqmRwr270ShBsYHO4Oyfmy220sdbEwfGG164GsUD5N5GEQ+2fd9Lx5iw1W/56AsHvJzjMx8jWwDQYIvrVPkq7PLEeC4SKEf8XtlDM76zEA4cPA4vtmRw+RGScHTfvM14VfQ6vS2B568drslaMc24kYdmcFNuiW30eaoRFW8Iwfxwte6V+lBMn571Mq6UtCMdAXTTiwVCNciuy/y3J+NzAA/ZW0xcUjxw9Trj6Uwssah2rL+dLKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 8:53=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
>
> > >
> > > I think we either need to fix `fork()`, or keep the current
> > > behavior of dropping the VMA lock before performing I/O.
> >
> > I see. So, this problem arises from the fact that we are changing the
> > pagefaults requiring I/O operation to hold VMA lock...
> > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > any VMA modification. On the surface, that looks ok to me but I might
> > be missing some corner cases. If nobody sees any obvious issues, I
> > think it's worth a try.
>
> Not sure if you noticed but I did raise concerns ;)
>
> I wonder if you've confused the fault path and fork here, as I think Barr=
y has
> been a little unclear on that.

I think I=E2=80=99ve been absolutely clear :-)
We should either stick to the current behavior - drop
the VMA lock before doing I/O, or change fork() so that it
does not wait on vma_start_write().

Before per-VMA locks, page faults dropped mmap_lock before
doing I/O. After per-VMA locks, page faults dropped the
VMA lock before doing I/O. In both cases, fork() would not
wait for I/O in the page-fault path.

Now you guys are suggesting performing I/O while holding
the VMA lock, which means fork() must wait for that I/O to
complete. Since an application can have more than 1000
VMAs, and I/O can be stalled for an unpredictable amount
of time in the bio/request queue or filesystem GC, fork()
could end up blocked on multiple VMAs while taking
vma_start_write() for each of them.

As a result, fork() could hold mmap_lock for a very, very,
very long time. fork() itself would become extremely slow,
and any other task needing mmap_lock would also be blocked
behind it.

>
> What's being suggested in this thread is to fundamentally change fork beh=
aviour
> so it's different from the entire history of the kernel (or - presumably =
- at
> least recent history :) and permit concurrent page faults to occur on a f=
orking
> process.
>
> I absolutely object to this for being pretty crazy. I mean I'm not sure w=
e
> really want to be simultaneously modifying page tables while invoking
> copy_page_range()? No?

If you object to touching fork(), can you at least accept
keeping the existing behavior of dropping the VMA lock
before doing I/O? If you object to both approaches, then I
really do not know how we can continue :-)

Thanks
Barry

