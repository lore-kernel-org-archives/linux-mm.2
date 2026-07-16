Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFFFC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 19:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE3E6B00DA; Thu, 16 Jul 2026 15:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD54B6B00DB; Thu, 16 Jul 2026 15:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEAFA6B00DC; Thu, 16 Jul 2026 15:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5196B00DA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:05:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6FB9A023F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 19:05:12 +0000 (UTC)
X-FDA: 84995567664.09.FDD09E8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id D5BF914000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 19:05:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gqrSwabc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784228711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbGqQ9kUGDYUcGELgHwYoCyqJQeL0ln3eyr2xFBUGKA=;
	b=FIaBPwVQaCJIBdcqMNIk7cY9tPPzjdCujwhX01mRp5zAlkCI9Hx4Qlwd6uFv6cKz6745hr
	Mj3X3TwiDymS/qnJDV+Ww031mf5SfFxaF6NJjb2yYRFNHlgNZWukLFNKsMrYkQLwxFddsk
	3XUV/pUFnJf9tCe0tkZQzkTkmLYDb5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gqrSwabc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784228711;
	b=ClLUmKbGKN7Px4S3ZwE1iLETH/ZcwZ36Pr2/ZPfEPD/SaO9dA0iV1UD9dFXx8JJqI+Mygq
	PukxH8k+W4TSnExdkCdGrXiowzvVk5v1pvNxDpPX4P/R15urOYNlS+inGpcwXxBk70gUjf
	rtpaJoA5var7j0tsFDSHuU4tarAa+b4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C1121477;
	Thu, 16 Jul 2026 12:05:05 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 138523F66F;
	Thu, 16 Jul 2026 12:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784228709; bh=f1ULhbuK1iL4hbXSB2hrLrFezeJ/gE3hgeZAl2sOvUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gqrSwabcapydV8BcaRXrJ+3InJ/tYr8/7EQjfec8M11rV1LYtTO+i0hHOG3fWMVI8
	 dzyFvALZUm6i3TwmO5xjMl+fdsthUr0DH07IaBF30UE5oiJvESqOEKP1mAzb+bHmtc
	 WHJaM3g6tBoTuQz7uLK9ZM2XZRplDibEbr4kfqX4=
Date: Thu, 16 Jul 2026 20:04:56 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	Linux-Arch <linux-arch@vger.kernel.org>,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
	"linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
	linux-m68k@lists.linux-m68k.org,
	"linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Magnus Lindholm <linmag7@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Klara Modin <klarasmodin@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	"Kirill A. Shutemov" <kas@kernel.org>, zhangtianyang@loongson.cn,
	wangyuli@aosc.io, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Lorenzo Stoakes <ljs@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rohan McLure <rmclure@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Anup Patel <anup@brainfault.org>, atish.patra@linux.dev,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, qi.zheng@linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>, chaitanyas.prakash@arm.com,
	Ard Biesheuvel <ardb@kernel.org>, guoren <guoren@kernel.org>,
	yang.li85200@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	"schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>, junhui.liu@pigmoral.tech,
	Muchun Song <muchun.song@linux.dev>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Nam Cao <namcao@linutronix.de>, Pavel Machek <pavel@kernel.org>,
	djbw@kernel.org, yu-cheng.yu@intel.com,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Coiby Xu <coxu@redhat.com>, Andreas Larsson <andreas@gaisler.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stafford Horne <shorne@gmail.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Message-ID: <alkrWNECXmoxkrUC@e129823.arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com>
 <alYL7B0HAvmLVHGU@pedro-suse>
 <b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5BF914000C
X-Stat-Signature: s57ouwip4zxpspue8s8ni996jr868acb
X-Rspam-User: 
X-HE-Tag: 1784228710-184859
X-HE-Meta: U2FsdGVkX18j4M+RGV3JYbsEF840AaZya7QvN3F/VFvbA/EoDxCxoBkF+QJsvKXtIVzPt/WsWVJ05YyWfyMmW4I//VEIUX3tqtRIRHOFr5TQvy7hr6jke/Rkpq4wurdRBLDDJriZmSTEn4iktMlLCe4QKX2PkT+2y0y278ThkdHMNWvA7XJ8723Smp/n5SLhCISxwWX7G0GjyNZjjzniI1UsMSy3nKqdjMm8kNP6UEbw1fYrpMZRjw+auFzgeRSO12do6L0tnuLPUyh8UimDxF5bEcz3OwbQvn/0joV64SS4a4HAl670fXaV1OyOc3vwGJCRH4bnPd3RKwwFyh401ZeuMgAR/Tib+QRrdhmmPUm90Z8WKZP9WMhFPLn8Gu9BRlrhRfDXVtpN5WQd7jGZwupDTHa5WeY6C4+p5xaVw5dX70k3xP8BSDInU5y6LIlFv3AVbIaO1toiiRgxk0ZEyX9Z4tkQ4302ZDvrFrMOVt6CJ6TtDR0bEgepvNWN9iFDlGF+hFYI0zltUAax0Skg52kB02EU6GYfcxHytEtMLsUqUnTTre01XE9+/NAmSPfkM4AlBpCK9zSCQ3dCljQqBhBWgKCgwjj/QwCVQ0WIvRLtMdBKn1buSCi/rWkqvKcMmgritNWRsO8TtDqicl6M4BiwAelVbfT5IJ7wkiCxgMAlDxSCOhIv4xOksBswPA5pIsESyqCvvmf9EJmSbHpCtU6JNa9XaYqkERVDp+FJJWN8I9C63n1PFhwHjQuisOP7hIcYC7yO7KbAdUVH96/2r38XdiY5eyE9YHJ2pCmLlpX2l+Lm+HKvYPtOa16x6Fdn+B95YaVW0sdPs/7+he8+o1oJ6Qg2/8XeyjVTO/ygXy+HlP9e0FMlyQb2CBBg1HxBdDzOUKbaWtoLHNrzqqhnzcO5j+cGc/zCik3v1bxNgDgFSOYcW2XRYSu2VyP/hxpPnJjZNS9IMDDBHss5xMe
 6G7O20o7
 nG9IUg/gcwrCoW//+Y1GejLEnHC4jG64mQUIYlg5NSL9nexfuhalKv7m2Bj3jJM9py/AaLbzILe+iUizANILXxcKzoAMUJzjh0NHFp9r50aPos5kixHVYGr6WUg7qakXU8ma6am4nf3RZ+0Sk+pVRvcP7OKInnyxIJC+LmWOm1OyaWzdOqtJpRy7p3zRuXCh5aN6wL1D5x09B9D5KZ60XimCJ2ZB3lqyKC7J7gjZ15YR3u0yNaueCq15MM/QcTbt6gUqqIHK9kiGTm4pUMc5Met5BiC9eG1OWWhk1qyYHiFlNXLQxy+AZkfRQHWLcvYkBf06TE2VewhUCmLb0+nxC12J1dzXnw+dZ35v8sIpev21qrckF8Z9zeAMntroxEGcp0v3/q0sTldLn4b4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> > Ugh. This isn't correct C code. It only works because the kernel passes
> > -fno-strict-aliasing.
> 
> I think the bigger problem is the code dereferencing the pgd
> pointer in the first place: Since the pgd pair is written in
> 32-bit units in __pmd_populate(), anything reading it would
> technically have to operate on both entries.
> 
> As the kernel relies on -fno-strict-aliasing, the type mismatch
> is less of a problem than actually doing the potentially wrong
> thing.
> 
> As far as I can tell, we are however saved by pgd_val()
> only ever being used for debug prints, where printing
> the first entry is likely all that is needed to analyse
> the real bug.
> 
> > I would recommend either forcing a struct here, or
> > using a u64 with bitmasks/shifts.
> 
> That would require extra complexity for the big-endian
> case though.

Agree. And since the users of pgd_val() mostly uses with
pmd_pfn(), pmd_page() and etc. I think it doesn't matter to return
lower pmdval_t or higher one.

Therefore, without considering endianess, it's enough with downcast
like:

   #define pgd_val(x)      ((pmdval_t)x)

Could we apply this in next version?

-- 
Sincerely,
Yeoreum Yun

