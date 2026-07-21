Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3DAC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA886B0096; Tue, 21 Jul 2026 13:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91EB6B009B; Tue, 21 Jul 2026 13:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80E96B009D; Tue, 21 Jul 2026 13:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 882D86B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:45:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17FE3A08FD
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:45:35 +0000 (UTC)
X-FDA: 85013511030.20.1FC44E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 04CEC40007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:45:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YcdJ0SMk;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784655933;
	b=TD0j2Zw3DsIJ+Vv5dPFwpVO3zj0NB5B4SiUdTo48hTiNHxxVm9Zy1GmVanJfK+dQeoEp4y
	M2AzFeCvVpG7qNmPAWJLjjccRwejQ7SGoHW1EnANkXWjjhgN1pZFedayPuioNjcWGmSG0a
	wCkl2OtU6gwKpgePj86cfsQ7Hns6l5s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YcdJ0SMk;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784655933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIqhc5mzWqiWFR6uw08XQmwgYzK9rGaJ67g6AaDHDX8=;
	b=4JrjcYx2tN/OQD7miXrHRyFWi5p+ADh4iAIKxKYKLjlP+ziPjrVhYINtwdXKc+jQeJq5pQ
	5JwN+vfdsINxH6LrYes8N/dHYyWjZUSk0U9VuxjQrJLFAhrs4ixJNST/jN1QzEIaz8iUjG
	1B9clIqsq7ruSDb1cqIAopUXWUUOKxc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD47A1AC1;
	Tue, 21 Jul 2026 10:45:27 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 873643F58B;
	Tue, 21 Jul 2026 10:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784655931; bh=hrYivZRwvgo4Jln4t+vd90e0saYnNKOsQL0oUJ6U/zA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YcdJ0SMkJGlBA6zcU5v7DCrlzSEWCTP6ZWedBSSkSSjm8uzBucCY02WFFlppbTou0
	 7Vtk7Wne8hYcoyIusG8mtsWATS11C/0DiJBcsPsfedbFHDz9wkKju5sMGuQL/9I8hl
	 uF20WzjU/fp1spnK9FfiincvEjVknHZCmFNVhFQs=
Date: Tue, 21 Jul 2026 18:45:17 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
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
Message-ID: <al-wLXp0tAv7hNv-@e129823.arm.com>
References: <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
 <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alYgMxKqRnF6_X0A@e129823.arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04CEC40007
X-Stat-Signature: dqz371dao96498pnwuijcyntham17z65
X-Rspam-User: 
X-HE-Tag: 1784655932-641908
X-HE-Meta: U2FsdGVkX1+qFyxVR2bnITgGxvg2fOHa4108pSWwPX3/W02h6BS9ODocB+cB94XdFmdVSHbfNyFC2HJAD5IT7bCP1ZfL+8ecgaUsYuNh94de6XpL38aANwNPFY7cPcv8MyfGHMjJzLQqpLYboVGHK/JvHlHTeLJoNXWI3ZgNQ7i53FvKxiOnpre5BFGlmIZ/4R8EW82RLwW+El+9vmUy3LJIv6D5dvy/23Id9lU0hJR5/BrK0cAp3RGYRr/v9m7pLk4ZnlY7Ay7bbbe8fZget7TTT+MsovdimRH1/5ufWHPbxaiF47QCBKxmKH3sb5v1vJ919d1b0VDB3szZSUdb02tPgX56vMaZLiN98hSK19gHwwteD59Ej+7rDDCCihsW0D4JB1cxCydvliPn3m0kbPAyqMvhiKRnN/yU5yU59A3Ly36EvDyAQHSbsIwk5973H4f4n7dj0Bg5Of6ckWDxPBZyoRry8whnF4NQ3yUL0BM1QRU4MbwG3Dom9+0hr8v5g/MpP/w2rVwqjOQ8/HCp/TVN2ztFDi9LK05rr9Htbw5yC5d7OvOwPXT98UN7T4R4kCn6c6YSbza6vSzRROaLXxG0jCd2okdO0yqKGBN8kznRuni7mGb2uHXJ6AOCxr6iqHvpNtiweTbKqgNdtFqpn14EvXGul0QliC4g/zJ8ubdfcMHt3p1kedoGsxvde0+H1E8MDPK8jGZL8myjYt9sY1nANMNVcYoGsmyuLm60pocuPHSwyjoxyGr4V2PiP8k/3WKbAcXv2uYN2RpttFqYcUUTHgVUH9u2EJ/doTsCXGeJMsqUJJaRcSw5tAZCdmdRgG7DsvMWxN5pEeM/rzYpRC2b1B8aX5EmszJKjY8bTpQoI0WXjSVJ8LS5RUoPnjgucoHsGpFsu2EhPldsSYenb5Ksgq/P3ni51Nie/tWC+Avkyq8JPewPgFV4bsx21XYcoXomnly257jiZjkRxSq
 kieP51Mj
 n3s8NbXgBlGCVCUi1CEj25/V4oqAaIEQgFw7V8GsJRLRZv6hUhUc1O7DznNBE879okOGwL3Irk84t5D46xeqCGQZdDoQsRfRaqo9LcS7I74BWQBP/HJ0hqeVN/fVsaJEnXgSK/bOE/oED7CjB0VsgraCcYNKxIVhuz78+7j9Jdpilukrqw3fbkeJuUXj59lVbs94umWm3bu6zmlbnP77gOxHZ3rNL233Qeqr8C+BJxNwNS4bqT6OnDmd1prUeneWJP1HVyvcoV06gOKaSyi6M70aq25BY48DZDnE5ojyvbYvae6iXNo+GzkY3iPznfgNUmPPdXiMlb9HAKAlm54YNArFmjeW3/tUi08svA4byr4svnFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > On 7/13/26 23:40, Dave Hansen wrote:
> > > On 7/13/26 14:17, David Hildenbrand (Arm) wrote:
> > >>> To me, the double READ_ONCE() is a non-issue.
> > >> To other arch maintainers, it is!
> > > 
> > > Ahh, so it seems like Christophe in ppc32 land was looking at this more
> > > like a regression that needed to get fixed.
> > 
> > Yes, exactly. :)
> > 
> > And I agree that it is something we should be optimizing.
> > 
> > > 
> > > Christophe, just out of curiosity, was this something that was causing
> > > you practical problems like measurable performance regressions, or was
> > > it really just insane code generation that seems unacceptably suboptimal?
> > 
> > I'd be curious about that as well. I mean, looking at the generated code
> > it's clear that it is suboptimal.
> > 
> > 
> > The solution space I see:
> > 
> > 
> > (1) Pass the result from e.g., pgdp_get() into p4d_get(), so it can just return 
> >     the value with folded p4ds.
> > 
> > That requires extreme amounts of churn in core-mm AFAIKS, so I don't see that as feasible.
> > 
> > 
> > (2) Rewrite folding code to make p4d_present() be a dummy instead of 
> >     pgd_present(), and make p4dp_get() return a dummy value.
> > 
> > ... a lot of churn across architectures. I'm sure we'll learn soon why it was done 
> > ike the way it is today in the first place. Something interesting to look at,
> > certainly, but a bit of a stretch just to optimize reads.
> > 
> > 
> > (3) Make folded pgdp_get() use an ordinary read instead of a READ_ONCE / dummy.
> > 
> > I don't like that, because we couldn't catch easily if the value is then
> > actually used some old/new code.
> > 
> > If pgd_present() etc are supposed to ignore the value, I'd rather have a mechanism
> > that enforces that the values are actually ignore in pgd_offset() etc as well.
> > 
> > 
> > (4) What we do in this series, but instead of forbidding set_pgd(), make it only 
> >     complain when we are passing in a dummy value.
> > 
> > The expectation is that it would avoid touching most architecture code in patch
> > 12 -> 27 and still prevent mistakes in the future.
> > 
> > @Yeoreum can you play with that and see what the end result would be?

If there's no comment anymore for (4), Could I post next version on tomorrow?

Thanks.

[...]

-- 
Sincerely,
Yeoreum Yun

