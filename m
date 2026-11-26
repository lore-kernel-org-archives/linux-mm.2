Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9085606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eTrh4ivt
Received: by kanga.kvack.org (Postfix)
	id 4203C6B05B0; Thu, 26 Nov 2026 13:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F90F6B05B2; Thu, 26 Nov 2026 13:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335C86B05B3; Thu, 26 Nov 2026 13:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED4DD6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:11:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63ADCA7432
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:11:07 +0000 (UTC)
X-FDA: 85478061774.10.E46B9DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1572940003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:11:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTrh4ivt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795716664;
	b=oFRkzSTOZ+RBpUnGqFMpb+y/w5AKPdVLcs/M6o1GZKXSCTKutFvH/ZAho73PcdmK78greR
	cqFaGS2zJwMPEQdJddNp1q5DWmGAKOmO12GQTGi75qfgB0J/LnlSdr0uayLL6HigA8xbEk
	sjxMysWPBSM2TFQI0IAj23Tyyxgyjig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795716664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9v575CLn7pmoDOzWOn9peb7SoijlK+LbrKGpES9aRg=;
	b=1DQsZF6Uu4vG5vrciFJxEi8S5wN5owuHrGTI9fiWfmHKAG6ugQ8OvzEjUVJADVLTz47d8N
	JdPqwn5gSvnOrS0c/nAz3SLMWD2CmP19chwm7q9DlPhdLbxTrwWehB2GrP6VgEIUtJiYd/
	C70/qTQ9sKufZMNbgC7zrSVs5iUfG/c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eTrh4ivt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DC174482C;
	Thu, 26 Nov 2026 18:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52761F00AD3;
	Thu, 26 Nov 2026 18:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795716662;
	bh=u9v575CLn7pmoDOzWOn9peb7SoijlK+LbrKGpES9aRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eTrh4ivtfPOlk36i/Syox5jVW6dXJmhOgZwioO+nYxMKjGShC7TMyjjJl/zzRZ/W3
	 SkP6MLdWC5iwrRV6uvUn6/rKonHWO56PFB3c75THzdQTim1Mri+dYH52nOteGfRTCj
	 M+BZepOCmKNRYHvlRa117MS6yceBdzXjdmtuENyHhISgbQTyWosUB771P8KFuwQKC8
	 pVw08LjMZlVYdDIpRqOeWvsFhzaGdSX4qDT0MagmIoJIq2tNOTskLwvuvj9X76KZmW
	 omTnmVri/xaVPYJp7AvvaZYW/JxAmTrlzAhShiP47YqYQ+fQwkXl5svB+CMxRIbwv0
	 XMDyeevoEqAuQ==
Date: Thu, 26 Nov 2026 20:10:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RESEND v2 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum
 with ascend order from PGD
Message-ID: <awh2I4llsjkB7Vds@kernel.org>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
 <20261102-dummy_ptxp3-v2-12-78840b2ec73c@arm.com>
 <awXD4i47F-VAG1tD@kernel.org>
 <awXc0MSZl9t9VW8e@e129823.arm.com>
 <682c765f-332f-4ac2-b448-4201c8fae6fc@kernel.org>
 <awhCnpiUc1R_BLx4@e129823.arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awhCnpiUc1R_BLx4@e129823.arm.com>
X-Rspam-User:
X-Stat-Signature: p3jii1yyc9nxddmxsxk6qnfkbfi4cbjg
X-Rspamd-Queue-Id: 1572940003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795716663-724923
X-HE-Meta: U2FsdGVkX1/qiJIUpasAJ0dE5efiyyaA+AAOrkCpqOfEM2j027N97Cgm973pyAZ+rxiYnXx7KXH4TUTaJ3cyNwxD1qKbxjAFu0iKaAnEw3LFBzK2U+ZqjMiHTajvz17POismLiGVycHWtRW02VOomAZbt1NRFZnt9ZFg3XVmjh3ThvUrY0ps+f3vWasU+MG4TUbDG2z23q7YDjWgbAzFUOyNAveX2wvu3ycCMDVdFagZN4JF8vigpdW+oX+b8TWTbQz1Pp4a5l8MAc+kxYfvAoYMBi0stGrpHTGs7Oa+dXDrA7g6AvljxLphraM2h+nL0vjVsUl13gznOUg9gzp35+cg7f+Dnn+TfHgIUIPWCLDrWVWFapm9lCH3pl3GScErWu04m7Vi4NMDdj+Ag6Ly19eE47ivQAs1ERBgO+0Pwhs6sieugdYTkZrUtbjQ4FxoP3rdndc7RtLUyV/2VUn9QvqKyDSA/ri/mOz2VeakOij64c32pecaRzzvKR3uUXV27tQlXjrpBDY51b7ylsnYS7HqbDGJEJryDNGqJSFkEuA7SsBgDVSTpoyYhZuzRVZ2aB0HCQ7J1P8zdEJU36z7b1Pc8pjscyFsdEtejFCbrtAy9AtQXa1OQ0yxFu7Y9af3LGN0IuA4XE4isBFbTCq2tJ2+AIBoN9vKyGUqTDT1r1aNz9dcn+CSXJ2LHisE5a2Ow3Ih0HKxVOGZTJHtHQrnxqnIbcRP8OphS+JMdg4H5olYMMqa6tAdnTYDVh03UKMTOK71gPWNpvfbpngjulIAINlvjJ1seofSKoki2scoAHvz483wl07GwMOIh5aHx4FmUtw4fnmlUORimUYAjNGac6junu0wKU+gD5BQYpzgC1+OHteiGCIubITcemZlT2/MlyYx7/JJ5iXXIpgwZS75tq4duNUwi97sGci5sRLw+4XVr3IpMqr5egOzJXlSklWeEQJZtR0slemywz3XXS1
 PM7NiHX/
 b2VDI4cX3ChY1k2ehzxrRnv+Ko/7mpqArr2l99cTtTKQYmZ+8WvR9HeAePCnOEbWIpywWbfiqLyo1IuRZYFAWss90U3SneXb2J8m3k83+KXwd1p4Rj4tqFyKulzW5huWTSKZKk8+UdAat3MwWUrkmYLMsaAKdOU89p19txS4S4OvQp0yp2ekOzEDsPIs8/HxYzMAPMSZM40GjYIh9HuTjyfecjEmK4eeLD4b6lZCsUfw2F0hO3IrP7B/kbeREq6HrvsIMtyaWaXSufe431TJ2r2+MdcBtzBpnwtkL9ej3BC8jpldlrI6tlh16zVWdQ1QCPYbKRX8AOG0revf5sY87mJwG2e33GRRp4JpvCUJkh5/76I5FPmHoSzRM44RTfu/IxtrKaLGzW2xy0RWVbVrRoEbB/X6zN8rRkPXt6sMciSEnlyKCuEXWKtjyb8jWPC7xZvW6pR53A9/ueJdBpBccmE1G7cNOy0OOdAGN9IXttRMPoSN0OA5m/4rIENO9Oigvc7AyoRnKGOW9QGNk3n6J7YVCtv8eprkdl5yva3JiORQQWKubKqSPdBdLbazMwF4PLuV/aFAgYqcbOpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 02:30:54PM +0000, Yeoreum Yun wrote:
> On Thu, Nov 26, 2026 at 03:19:13PM +0100, David Hildenbrand (Arm) wrote:
> > On 11/24/26 19:52, Yeoreum Yun wrote:
> > > On Tue, Nov 24, 2026 at 07:05:38PM +0200, Mike Rapoport wrote:
> > >> On Mon, Nov 02, 2026 at 11:21:25AM +0000, Yeoreum Yun wrote:
> > >>> The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
> > >>> from their intended usage.
> > >>>
> > >>> Intuitively, higher page table levels should have smaller enum values,
> > >>> but PTE is currently assigned 0.
> > >>
> > >> That's not what x86 thinks :)
> > >> They even expose it in /proc/vmstat with smaller numbers meaning lower levels
> > >>
> > >> $ grep direct_map /proc/vmstat 
> > >> direct_map_level2_splits 152
> > >> direct_map_level3_splits 4
> > >> direct_map_level2_collapses 0
> > >> direct_map_level3_collapses 0
> > >>
> > >> Just an observation, I don't mind either order.
> > > 
> > > Right. I made this change because a depth-based scheme seems more intuitive.
> > > 
> > > As you pointed out, though, the x86 specification uses smaller
> > > numbers (0) for lower levels (pte), so I think we can leave the
> > > x86-specific direct_map_* entries as they are.
> > 
> > patch #14 depends on this, no?
> 
> Interestingly, x86 documentation numbers the PGD level as 4 or 5,
> whereas helpers such as effective_prot_pgd() use 0 for PGD.
> 
> Anyway, this follows the usage and semantics of effective_prot_pXd(),
> rather than architecture-specific level numbering, which varies across
> architectures.

I asked an LLM and here's what it told me:

  x86, s390, riscv, LoongArch and powerpc count from the leaf. arm64 and
  ARM count from the root, and so does the generic page walk and ptdump.

My guess that the only reason that generic ptdump counts from the root is
because it came from @arm.com :)

> And yes, patch #14 depends on this, although changing the condition to
> level != PGD_LEVEL would remove that dependency.

I think the only real hard dependency on levels numbering is x86's KVM code
that manages secondary page tables, but it anyway does not use enum
pgtable_level but rather x86's own enum pg_level.

> -- 
> Sincerely,
> Yeoreum Yun

-- 
Sincerely yours,
Mike.

