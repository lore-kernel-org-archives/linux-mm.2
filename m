Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1160606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HxpQmHpN
Received: by kanga.kvack.org (Postfix)
	id E19316B083B; Tue, 24 Nov 2026 13:52:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF14D6B083D; Tue, 24 Nov 2026 13:52:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEFB6B083E; Tue, 24 Nov 2026 13:52:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA38C6B083B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:52:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E6D8A8843
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:52:14 +0000 (UTC)
X-FDA: 85470907788.14.E1582A7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 664C810000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:52:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HxpQmHpN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795546332;
	b=TtALvsVmnhJGUUGysNjsSf1yK/4lexgBI9mi/LouuLOXWDtLAtvzQpFf0KBUiumo5yV6O4
	lT+EXNL/FyO/W4fQwLzk/A+NoUzS51eVNrt2dVG0bqziPVZ4ZOo4FD6KI8kmOv5VB6cE7Y
	yTl8oW1ZZyaGpLjb7CwB2TaUh7OhcH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sNoW/KWYC5fenn6W3ZO2QgTuASrJJ6ujM7Ci83DK9o=;
	b=OwnBaIMQJHXxE20bxmNDf1qm2Cm1/ZxCoIw/dobVNy4kqnh3vXjLQ299cXatqsBJfgvSti
	+RdlRvYR98IC9KnrXhAnUhh6QOYgOpnKwXecvWaH3QUhcTEbDUvjbD4RBqe+mdkjwoeDhv
	1OJNA9aTnd1FJSHH37r1R/328eO6DoM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HxpQmHpN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1019F497;
	Tue, 24 Nov 2026 10:52:08 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EAC33F86C;
	Tue, 24 Nov 2026 10:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795546330; bh=cEx0NNr4v9OqxertlfeaIBCZsjK0gqeBlEmSznQ0QE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HxpQmHpNrqXVqUfjE0HPfLK3ewOjjeolAx23daMcxTI88aKM+hL6rA2Fg+4rqd8+R
	 qMFVk/rzRBXFpbU1Dfr/ftkZEjuXw3RMnNovsFD1RM3+rwaFKpdU0NBWTD4cVkNWWE
	 Ki55UEoYDf7IlCgUAL9LE2jIQWyjvIsSNBfWze2I=
Date: Tue, 24 Nov 2026 18:52:00 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
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
	David Hildenbrand <david@kernel.org>,
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
Message-ID: <awXc0MSZl9t9VW8e@e129823.arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
 <20261102-dummy_ptxp3-v2-12-78840b2ec73c@arm.com>
 <awXD4i47F-VAG1tD@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awXD4i47F-VAG1tD@kernel.org>
X-Rspamd-Queue-Id: 664C810000A
X-Stat-Signature: 5zfw9eqtcxgm4p1471mzimyaz38iakrb
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795546332-369477
X-HE-Meta: U2FsdGVkX1/ek7I+XRZ+/JoFfmSyBFhfaF4N0YO7DodmJyzVoKJKRsgMHcR0Q6GDhSyNhHTn21hCMFOHOaTRo5xBXqbrIszIcqQRtHVv2GRL8S6H/HTdc0FYQixXk1LPRPiDpgw1PNJOXqQYav6OSBE4lzZksBnwIVAAqpOwv61vmb5LyYjaGlAyFfX+Cy9/zKFC5NwJkbPy89cz5zPmejYZ/1vdg7DkndfHBhcNYof8wIjaVb7v7PX/fXE8QCZiqZh1yosFu4yVdgYUeJJgJk/Hx7dW6W2hdxwJhg3eU1A3KES2BuLAJ621TNgXkReNQ9+j3Q1DHsCuV3cRN/gKTMKU0b55quo8Wk3jAMQFeskVSQYeifH9lIZK9jUJPgxRvVtpcrXvRG9/IWgUQC2ETNvPr0FWBTgGGLDkJoZFQsOC3BeW97leBbjYYnFrZCccrOpSN7MzcFeCsKZseMiiDCngIYsndV6M4rfUAdtYDtAY5Dv3Ik2EZr0z/mcWyDppzv7Fizv05OtecClBtpY8CugMo6R3B7UE4u5xn9InjM/xgzC734JCIb2pMSnK9qAaW2/7zq4C2GCckvd5MoOegRRGcgb0Dcrneo0x22n0Aue9zYhn2YD3GP/HdlG1Rt6Tb0C9ZQNiUndQzkH3y+Zccb0jimZpopHPZaRmqEUJrusIaS/k9FcF/pbDW1vz8RUpc/IrJPgkfl7awN5e9glX0GGhRYhBRv75m9i0C+lKzF5Nwtvt4uQE+POXsd3q+bh6JuxTaiwwqu34cIwcAZKdj7aOHpS6ylBdrcvF843kRC3o38gn69g/6wITqlnLHqkMWhMG+FrT4nz+Ruxd/sSU4jgU8wPghJKtiagYk0UiPJZmG01pZW9iAH0Nu+/IwCjDrUatfB0TERTuOzb53D8etvpEBVkZtQ9aKmonVpwJ8FR12fEJQghVrmbKy3JGDt31yaKiwE8rJZ34mnuwJVG
 VcVM104F
 y+MdCN2kKk3wjTO9WVO4kMS+M2ZljmJEXaHztXL5cFR6jskSmCcx+g33y4ZSfZkyo6Xl0uZZ5dACn6Uzsxq1ymla9qcAXvVFm2JxidbDviks7ao2PQSU3YorsQTP/juH8N53oNIl2657dXeT3+vivqFEd9Utncuz3QNIAuvVUB9GT/LX81Hnkn2QS2Vpf/i7epJS61ZnvOhfKKamYeezrBMQk9DmMt7QYUl6zyOc4LNgB0EiWz5voKhbLJ96/gM+iQYT5MAqaGbZ35+UI51pK/l8ioAi5004eQfNxsVjUXPB/nuJqX+aecu1nfjkotEtb+khhvnMFvRkVS0HW0CJcceNlKkG8B6WMvd7NzJOVIWm097C39rDk3tMlBxjMOL6Eb9D+35Xeaerf425iy6jytrK5bk6r5aOGG5hqSahC9xrxYP57qnTgQlgb1NLdTlzITr2Pk0fwelIY1EwnCC66Kbwgk676D6fpCyxvAp999m3R2cphUfFKGrcfLvyF56OSE1g8Zo6ZOka+HjXvNAEI4rxUSSyOXsQS+hm8hz4Se1rO5KdN2Wh3TmpxfEBE65uDgU4KuYV7i6tPVBMmBi4g7LmWHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:05:38PM +0200, Mike Rapoport wrote:
> On Mon, Nov 02, 2026 at 11:21:25AM +0000, Yeoreum Yun wrote:
> > The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
> > from their intended usage.
> > 
> > Intuitively, higher page table levels should have smaller enum values,
> > but PTE is currently assigned 0.
> 
> That's not what x86 thinks :)
> They even expose it in /proc/vmstat with smaller numbers meaning lower levels
> 
> $ grep direct_map /proc/vmstat 
> direct_map_level2_splits 152
> direct_map_level3_splits 4
> direct_map_level2_collapses 0
> direct_map_level3_collapses 0
> 
> Just an observation, I don't mind either order.

Right. I made this change because a depth-based scheme seems more intuitive.

As you pointed out, though, the x86 specification uses smaller
numbers (0) for lower levels (pte), so I think we can leave the
x86-specific direct_map_* entries as they are.

>  
> > For consistency and cleanup, reverse the enum value ordering.
> > 
> > Since there is no current user relies on these numbers to be ascending from
> > PTE->PGD, so it can be changed to be ascending from PGD->PTE, in the
> > direction of the page table walk.
> > 
> > Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  include/linux/pgtable.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index 780fe849ff8b7..a032f95943357 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -2288,11 +2288,11 @@ static inline bool arch_has_pfn_modify_check(void)
> >  typedef unsigned int pgtbl_mod_mask;
> >  
> >  enum pgtable_level {
> > -	PGTABLE_LEVEL_PTE = 0,
> > -	PGTABLE_LEVEL_PMD,
> > -	PGTABLE_LEVEL_PUD,
> > +	PGTABLE_LEVEL_PGD = 0,
> >  	PGTABLE_LEVEL_P4D,
> > -	PGTABLE_LEVEL_PGD,
> > +	PGTABLE_LEVEL_PUD,
> > +	PGTABLE_LEVEL_PMD,
> > +	PGTABLE_LEVEL_PTE,
> >  };
> >  
> >  static inline const char *pgtable_level_to_str(enum pgtable_level level)
> > 
> > -- 
> > 2.43.0
> > 
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Sincerely,
Yeoreum Yun

