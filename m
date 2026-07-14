Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE91C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 16:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE866B00E4; Tue, 14 Jul 2026 12:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F526B00E6; Tue, 14 Jul 2026 12:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6486B00E8; Tue, 14 Jul 2026 12:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0606B00E4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:08:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D100F1403E0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:08:39 +0000 (UTC)
X-FDA: 84987865158.10.AFE67EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADC601C0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:08:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iCzZbGET;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784045318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vi1DydRXtX7bGPT3LMqOXRQKIoXwlIclgcCEzEexLhk=;
	b=mwrrmSuJiz/GuiZpgfYcDrPYKxa96X32Q706/pBQkEveQbxeWFB+Za70/wev96KYOh60e8
	CTLr+JqUpdnATx3Z2CSRB+KnLeh5tZP5vyStgZdYM2Q9y2RUyp6ntTp1ObZKTSaGjcUyiv
	PgqrqL8n0xcRL6wMQf+IgixUSUB7Jes=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iCzZbGET;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784045318;
	b=iBdL8VB4vmj1g89scHZQHjYe9bhcJ0AvCCAE7qBuqBIwJR5f+L3yQOEm0E4vSyvHM6NDe1
	AxtzQkDA18z2/AHtdIPERCsKsd+82XtJzrUgs14UP/zZNCpFxNXhfiGdOuwFzFlQ/0bcrB
	AIHm27AFIzZ2b0M85pBBW4HEsiYj9ms=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C0F7339;
	Tue, 14 Jul 2026 09:08:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E9193F7B4;
	Tue, 14 Jul 2026 09:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784045316; bh=zgLVwM1JwHFja7lLv/ELj5WdO9n9zTqb8IzXUFezT90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iCzZbGETk1sjjX6eOrBH+8HsRtioG5p9ficyglXR5ZOGjWAywCxpvKBCX5YKjzVO3
	 lqTbW4BkVoCgjyW6aQc14TvI91LoFiK/lix5zRJXBa7aprCYI8FSFGSdrtX3ku0RTb
	 mnDMqhPMuq2pJz8eXOt4MCF6VA5P5DAEnERr6DDk=
Date: Tue, 14 Jul 2026 17:08:24 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux@armlinux.org.uk, akpm@linux-foundation.org,
	ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
	chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
	kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
	wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org,
	jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
	arnd@arndb.de, ryan.roberts@arm.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, baolin.wang@linux.alibaba.com, tj@kernel.org,
	kevin.brodsky@arm.com, anup@brainfault.org, atish.patra@linux.dev,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, dave.hansen@linux.intel.com, luto@kernel.org,
	peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, hannes@cmpxchg.org, mhocko@kernel.org,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, kasong@tencent.com,
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com, yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com, ardb@kernel.org, guoren@kernel.org,
	yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
	dinguyen@kernel.org, schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech,
	muchun.song@linux.dev, vishal.moola@gmail.com, namcao@linutronix.de,
	pavel@kernel.org, djbw@kernel.org, yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com, Jonathan.Cameron@huawei.com,
	coxu@redhat.com, andreas@gaisler.com, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
Message-ID: <alZe-Cu7yQw9qRXU@e129823.arm.com>
References: <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
 <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ADC601C0005
X-Stat-Signature: qy95nzk8c8796rdect8dccc8e3x336od
X-Rspam-User: 
X-HE-Tag: 1784045317-646336
X-HE-Meta: U2FsdGVkX19Owi9JLGIrif3tCHKTyLFiijDCB2J5HjDg3Bot/c+U6rEj1FECjiUVY+YRmT4NjhziJeP0cNIeMBbRTd7vmJHneym/HX7iFKa5q5PsGFosnXdijDRg+FElqtg/V3cHMSuKrpHODaExkr8d/MWf7XD7wdA7Ib5ObdSQxweoac1k4cODWeJBReOlHNMazOMvClnQBVUAx4dSRTJCaOG37PCJZ6wLDfj/m5Q2ay2pKTasAeSXM2WdEQhlO3jLExqOTFJ7scoyMs0Qq2RQQHmJV4YJ75P7vmT+xW4socjcD/AQ5EpTqJ+C12DlcIlxyPocmx17Ga5N3F3lTkrLMJkPDHfTW8e7GDwciFXv3F3GesN0Zts7WDWiL8j3mUNFgSfmJjTNEq7OsC+/0qoYjtmZbMXO+bCj1pUnesixFnDCWkZ+JjlCP5/v+0UdeMcCvMkCR67IxXt8jRt/bX95UJ77i1+2xZwqgxznwUm2jR/nE3OtIh6tQxuUHKjVtsjgbXCvD43Jxp02xNixGEZXTG08TesQY6R2J4D6TZzeNkCFq/qSt3qiMNybYCYaTkftGeFfy92lR2BnCzWVVVTKZbL3s0Zo8W0F/Hja6Do/UtEkPyPJnyg+MMl8Hs0CoPSo60DularJJ0ShPDyMwP1/l7krR85lZb+H7RGDyKjX/Ks2Cjye62q7pVuaKmgmkX2yyuCa19bsHRJAhlNU1wdhMzjDASBos09THo7/qJItaDWest9QA2X/YbNI7r+MTgBT5wzaGrbo/14zPYa52/DSaiYZ37c29kJBKYi9mmQ7eryRonWlLgXMHkAiLM6Vt6VRgyG+zH0+MITA/v4OL5H8qhpRIV1K2549Qdn693R7BQkKyfE2SRtCGP73HhZfSzvsAMKQTzC/m1DjkKw3pW9rkLgVpulvwoOxtTuj5gWRtbWHhxVH/XtSn+YNQPakBWgM0BOFK/dXzcsi7sG
 94WAs+uo
 g9SEz78xjkSwvYQMXcffxX5tNb3XDYGMwmCxXbOHE9nAsDrBwVGykpPOyE2iSOou2eiiL/8KtV4DakUi91W5JJHKheh2N2DL7Hm+gJFfWOlWRba8/RYB+joQ52a1Ys/fAAku0E9kJk+iOVkhZcRWo5UVDtS/Z4GOIwiG+GuYrNDOGcw0wVgqFDiUFLjOFEHqFBIsgipyfgTYwjdGihaQYtMVALSVm6s6BAplSXQOBv4vVuy4h6AhMTpmFQoX4I/bHvUwshj1DEiL1scTclNzU5h8BEXQI5Hvmp6ASB5/bPtDnt0LI9QWHR1yKxKZ/RmIM5oZPK2isAxiKSoiHuEixThYZdMuY0xZa3n78II0YEEGuAB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:35:19AM -0700, Dave Hansen wrote:
> On 7/14/26 04:40, Yeoreum Yun wrote:
> > @@ -254,22 +255,8 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
> >         struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
> >         pgprotval_t prot = val & PTE_FLAGS_MASK;
> >         pgprotval_t effective;
> > -       bool first_level = false;
> > 
> > -       /* Ignore folded levels ... */
> > -       if (((level == 0) && mm_p4d_folded(st->mm)) ||
> > -           ((level == 1) && mm_pud_folded(st->mm)) ||
> > -           ((level == 2) && mm_pmd_folded(st->mm)))
> > -               return;
> > -
> > -       /* ... and make the actual first level remember the protection. */
> > -       if (((level == 0)) ||
> > -           ((level == 1) && mm_p4d_folded(st->mm)) ||
> > -           ((level == 2) && mm_pud_folded(st->mm)) ||
> > -           ((level == 3) && mm_pmd_folded(st->mm)))
> > -               first_level = true;
> > -
> > -       if (!first_level) {
> > +       if (first_level > st->first_level) {
> >                 pgprotval_t higher_prot = st->prot_levels[level - 1];
> > 
> >                 effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
> > @@ -471,6 +458,15 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
> >                 .seq            = m
> >         };
> > 
> > +       if (mm_pmd_folded (mm))
> > +               st->first_level = 3;
> > +       else if (mm_pud_folded (mm))
> > +               st->first_level = 2;
> > +       else if (mm_p4d_folded (mm))
> > +               st->first_level = 1;
> > +       else
> > +               st->first_level = 0;
> > +
> >         ptdump_walk_pgd(&st.ptdump, mm, pgd);
> 
> This is indeed an improvement and a step in the right direction! Thanks
> for looking at this.
> 
> But one of my test for whether it's good x86 code is whether there's any
> actually x86-specific logic in it. Isn't this basically a translation
> between the integer level number and whether it is folded?
> 
> That seems like a common helper that more than one arch could use. Could
> this be stuck in a helper so that all arch/x86 has to do is:
> 
> 	if (mm_pt_level_folded(mm, level))
> 		return;

Yes. at least the level semantic in ptdump (pgd is level 0,
p4d is level 1, ...) is same to all archs where use ptdump.
So It seems reasonable to add this common helper in ptdump.c

> 
> This makes a *ton* of sense in effective_prot() especially. Its entire
> job is mirroring the hardware's job of inheriting permissions from
> higher levels of the page tables and enforcing them on lower level leaf
> entries. If a higher level is folded, there's nothing to inherit.
> 
> I also think it's worth taking a brief pause on the coding to think
> about what kind of design would actually be nice here. If the design
> really is that the pgd is folded, the 'struct mm_walk_ops' code would
> ideally not even call ->pgd_entry(). It would just (for example) *start*
> at ->pud_entry() for a 3-level hardware page table.
> 
> If there are no pgds, why bother calling ->pgd_entry()? It couldn't be
> done transparently to mm_walk users of course but it could be done
> incrementally where users move one at a time over to a new scheme.

Agree. Calling a pXd_entry() about folded one seems meaningless.
But seems enough to check mm_pXd_folded() before calling pXd_entry()
in each walk_pXd_range().

[...]

-- 
Sincerely,
Yeoreum Yun

