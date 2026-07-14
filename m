Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BCBC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 16:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3D46B00D0; Tue, 14 Jul 2026 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E642E6B00D2; Tue, 14 Jul 2026 12:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54316B00D5; Tue, 14 Jul 2026 12:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4ED16B00D0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:51:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B485120444
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:51:18 +0000 (UTC)
X-FDA: 84987972636.03.E82F029
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 29E7440007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LJE9Gnqg;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784047876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFYx/PcJYBHS7M9Y27BjGgk5pg7WT/rEUT06432k7IQ=;
	b=WpmE6+U38FQTZ0xJ6eVmL6yjlkC3PoFRb/x6Wo5rEyYdElMQyeI/n0DILEJ1VRlJOsWjfU
	SKJ2xqRUeZp7fCnGa46MJaQt/kxtj6ETqCrOm2AgZxX8O0yirfRk24gguSHQdeh1r+z5TW
	DX66qKRlQeUzFaAjyy0EEXMCzZHOc68=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LJE9Gnqg;
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784047876;
	b=NMOGdzCBEC5XTNh+FVuwdLrtK/po13IQsMC/DSQqtL/LrNtiDs9eHvNM6eHmk+aG/r66ZC
	D5FwWpgHksUR8kOsJS6UBR/yfF108CI2+LOllf/nBfZmS+x7yfxZLicPxBbNk1aPx8RRrx
	xagm8Tn+of9szJHvaOMA3I1dtY0LqyM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34AC11477;
	Tue, 14 Jul 2026 09:51:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92B183F7B4;
	Tue, 14 Jul 2026 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784047873; bh=UvBhg+nD12g2Xn0O2D0o4P28bmGT2yfpQKOxtSEnl1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LJE9GnqgPAJTHNyrHvXiGytDU8Y+XMmq5qcc7VQwk9xF51NV6qToYp1rk0iHEdw2c
	 SQefERcHjF0VMLdrLpD4VYdyPuCv0noF41iChasEg/du+6t2wy8gA1iDS6Ph+r4Igc
	 KCRrQeoHcKvxhPGR+tFzzHZ+eCmo3MvDkxCNZGoc=
Date: Tue, 14 Jul 2026 17:51:01 +0100
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
Message-ID: <alZo9feSrSB_StfO@e129823.arm.com>
References: <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
 <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
 <alZe-Cu7yQw9qRXU@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alZe-Cu7yQw9qRXU@e129823.arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29E7440007
X-Stat-Signature: 3ihxz69676s75qjpcufg7wi9op9kc41u
X-HE-Tag: 1784047875-518312
X-HE-Meta: U2FsdGVkX1/p3ky83RQQ1MpYuIKn7NmqLZPwyXJ0h5/vPzNLiKnI4LVl1zsuHLk8QGRmAfsDmbtF8W0dgtbA4FrdOOJWDY/BQg5USnncChRsv9nLY78KYEG6BBgxBhsZi4NaaAkMJoLJkFBK96bqGTqM51Omp/BjL7WH1sS6d3/v5POFaUe9x5EJFeK9rlZVif2oTcca7oOzXW6bDG8CMcSmRQHTA+c6t5+yDkBEbEZEKCV9Vb3CJB4Rx2GtjT4n0mXmsdJaMWxtmwD9AOAFksIMa8IPZ6N0huz6SG30Nu9TSndb5drcWNr4Sl5HLr38TaLpzsUv55JQ4wRrcMJrmF88mXiZZbPF7KmqtXVTGMJZbEHeZsSmWcV/rMVRS1AB0A3cyRNWsWUSZaIssFiKbC9E9+WR4+Hlcw0m7D2K56DPxnMcoLwRSPEFmsXlhP5q2HL18nJzb9oAOBuIbdH+JaAS9V47Mh73FQ+LTqzL1rZI0v4jN6U+5Xnoqin5x/OahJFHf+RlopxSgbWoGJUoCcyYE5Z/H19u0Dle/D7EzOuWqEXCjOg1sJF7xIJww7MPc6HsztB0y5KiTD5QNI05XlsCjjrc/TR8l2wHY+LGckb/T+Pd9PNaiYat4n7dqYwbxURkH6f+AKZPfWnEwchQG3saENYRYQtYgeIAnnPD97MVkYj84Y3vn7w0ORE5NRkh6MvwZTUj5LfAZtEnctOb4RBFyLUOKs9isx58dspbC9PDcc1t4uO2s9gFRgaUTp4EQ0rckKFg72wVlmPpM3PrEkh/EKQyx8w8soUIqal8aw3xNOQh98HktTfX1jOi5iY57Ilw7v5PuqaeIT/ufpAza20R/9sJX9l+NCe+BYRAuCLNN/97ydb1TwaQPy4TdwykZgR1xl3LDrV8X62ErMRaIcDSBkB9nG8UmvO2dMICSz4CT7RG/HXSlItHt9rTFi5XjQrMqGyMiCM8fTY1Nhb
 kiufs8OA
 y/8uv9cMpRUQAEAQzTpxc8Xe1XL2O4oyHte3/zXH8diAA6O79jjzivYjd1xNUGOX7DY5LIZuj17iuOFdepTvuieyCVcE/iVWKcGkVvYccgH8eBcbJEVZJAeD5FUYurLqUg45xZYtF2tUl0NchNn4+fPzQVbkY6PMwEYvupJ5ylKXjYECWUJVZKiZ3eOhvichd8tM0u3zP03Jyp5eIsfL+9eEBYVFy77FhSJYXpG+zCmnbROfmHY0GqA728ZM3HMGHG/ldK4qpmll8MhYJo7+3X1hXlalRcMMMQ8mZiBh3BiDFFSQkSxZQ7AEJ+dhrHQYfOWOe0eujklAc4WEOo+WXVwfu5XlbAx/OrXAHqA7CpKehCSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 05:08:24PM +0100, Yeoreum Yun wrote:
> On Tue, Jul 14, 2026 at 07:35:19AM -0700, Dave Hansen wrote:
> > On 7/14/26 04:40, Yeoreum Yun wrote:
> > > @@ -254,22 +255,8 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
> > >         struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
> > >         pgprotval_t prot = val & PTE_FLAGS_MASK;
> > >         pgprotval_t effective;
> > > -       bool first_level = false;
> > > 
> > > -       /* Ignore folded levels ... */
> > > -       if (((level == 0) && mm_p4d_folded(st->mm)) ||
> > > -           ((level == 1) && mm_pud_folded(st->mm)) ||
> > > -           ((level == 2) && mm_pmd_folded(st->mm)))
> > > -               return;
> > > -
> > > -       /* ... and make the actual first level remember the protection. */
> > > -       if (((level == 0)) ||
> > > -           ((level == 1) && mm_p4d_folded(st->mm)) ||
> > > -           ((level == 2) && mm_pud_folded(st->mm)) ||
> > > -           ((level == 3) && mm_pmd_folded(st->mm)))
> > > -               first_level = true;
> > > -
> > > -       if (!first_level) {
> > > +       if (first_level > st->first_level) {
> > >                 pgprotval_t higher_prot = st->prot_levels[level - 1];
> > > 
> > >                 effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
> > > @@ -471,6 +458,15 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
> > >                 .seq            = m
> > >         };
> > > 
> > > +       if (mm_pmd_folded (mm))
> > > +               st->first_level = 3;
> > > +       else if (mm_pud_folded (mm))
> > > +               st->first_level = 2;
> > > +       else if (mm_p4d_folded (mm))
> > > +               st->first_level = 1;
> > > +       else
> > > +               st->first_level = 0;
> > > +
> > >         ptdump_walk_pgd(&st.ptdump, mm, pgd);
> > 
> > This is indeed an improvement and a step in the right direction! Thanks
> > for looking at this.
> > 
> > But one of my test for whether it's good x86 code is whether there's any
> > actually x86-specific logic in it. Isn't this basically a translation
> > between the integer level number and whether it is folded?
> > 
> > That seems like a common helper that more than one arch could use. Could
> > this be stuck in a helper so that all arch/x86 has to do is:
> > 
> > 	if (mm_pt_level_folded(mm, level))
> > 		return;
> 
> Yes. at least the level semantic in ptdump (pgd is level 0,
> p4d is level 1, ...) is same to all archs where use ptdump.
> So It seems reasonable to add this common helper in ptdump.c
> 

Furthermore, the effective_prot() need to require to identify whether
it's the first pgtable to prevent the inheriting from dummy value.
So I think it seems to make a ptdump_pt_level_first() like:

diff --git a/mm/ptdump.c b/mm/ptdump.c
index 973020000096c..2ec5700e4be5e 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -190,6 +190,23 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
        st->note_page_flush(st);
 }

+bool pdtump_pt_level_first(struct mm_struct *mm, int level)
+{
+       if (!mm || level > CONFIG_PGTABLE_LEVELS)
+               return false;
+
+       if (mm_pmd_folded(mm) && level == 3)
+               return true;
+       if (mm_pud_folded(mm) && level == 2)
+               return true;
+       if (mm_p4d_folded(mm) && level == 1)
+               return true;
+       if (level == 0)
+               return true;
+
+       return false;
+}

-- 
Sincerely,
Yeoreum Yun

