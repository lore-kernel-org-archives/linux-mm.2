Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2252FC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011576B00F1; Thu, 16 Jul 2026 11:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01266B0133; Thu, 16 Jul 2026 11:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA29B6B0134; Thu, 16 Jul 2026 11:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1C9F6B0132
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:42:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E48A6A0117
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:57:17 +0000 (UTC)
X-FDA: 84994338114.05.E90EC53
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1ED1A100008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:57:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d5tkmkG5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784199436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lConI3LXeKVmSOoLa6olJeUmsouLqDOj/10hcsi7mv4=;
	b=CtWakx2z9oy7IE6i1HGgIlzZo6Cp8NL05bL7C/livvPE99EIT0p+K9vNano2O+35+AsWvO
	p3ND3eGWU5WC/xOkf6RtnbYX4KFFjyXg3gggOPM+KHt7E4k/jgILn5aas74l09PDkVsbUH
	InEpv1kShjlWiE8Lw0ulmHzLHE+HG8s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d5tkmkG5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784199436;
	b=vckzNqFntwcJkZdRrxAn2zwJzMghUMZey6ubJd4TaxLMrXB3VmkY+60CMJmzJYk9sHdMTz
	rwp0vsC4XlFJ7cYjYit+WMGvrDB9pnqpzg2+2wWowqGr6U6hCBmP3rG7kxIWt/jhiFqaY2
	Btz2gm/aR713KkqSH7hyLtLZk6I4Yas=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 878791477;
	Thu, 16 Jul 2026 03:57:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 517673F7B4;
	Thu, 16 Jul 2026 03:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784199434; bh=183FD52geXzLnicj8PRvEsp/u5QGzLUNfdkFvdlvTLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d5tkmkG5Kp9Oy0MkBeywkl/rzGCiym7zyN9Xb6/iGX41TcFOTCCI9eR7n1jDeY++C
	 MtXWXxwIyUA2P3b5+IQeTXGcW4DMtqA0RMDGfpR/q3XGIcPnKOXQYVi9AyUle/pECm
	 jJ4P3dTj7+rJAFitSQuPUx0nY/0/JxwJCdCuhuF4=
Date: Thu, 16 Jul 2026 11:56:58 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
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
Message-ID: <ali4-ibN7Jp9n22Q@e129823.arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com>
 <4a0f9161-961e-47f9-8672-9a06e52fefea@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a0f9161-961e-47f9-8672-9a06e52fefea@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ED1A100008
X-Stat-Signature: s1rf5fj7xz7e13ddsppqg3e5suqak1yz
X-HE-Tag: 1784199435-959511
X-HE-Meta: U2FsdGVkX18bkndkW5cVZbvV5PI5BowRFntYwrWTKciybMJiqu9B9VmDzgBOukxxmDltwYfjLLnOunv734iMv2rPdmQvt4+udl0DyIEZwjB41DDMOISRQy7QJ/Vn5NLyps00QY4cmpYg4KxYnNqlOV7Px4pZmfE6E/278YqnPmBxB5qoVBn3joxQjaSdf81bKZSKOkBRm8LvqBOaXEFrU1RwFnjev4HsWxdiEUAfuD2qeqY0rvNfuj2ObYouEpSl/XdB75SgjkWqkcPb5H+d7Sqg3zhV+bINO47Ziec/QuzGhayzlE1OZvhmJAGd9jtPuJ7S7ZJIlFpmfwQ37k9SX3tsJgPGUaFLb6k4QCkVO1tQPTftb1TrYRf6rEECYpy+9Nt5Kf+nRL9mIcaS9G1wr6+QVeaWUUjA3vfUUO1y4TC1yt/ud4sPLd8rc127K/P6QaqoqBxtlTUIfQ5Hgal/jsZPGGwUhlO/F9raupjVR9/neS99RCfS3/UndSiF3hfL+6nu7atrSobDIx7bDTz+5hOgvWKtO0mWGfucamrIyBMvBZW++KhwHg2sM6kxlS0jAJsRQR3ua0ofjLFY6f1NGRtfc5tQbvTZos8PQDTg9G6V21M0Q9IdlBtvQ/gQANMH3HlYtZhs9Oou7lH+nJgmw2jKhMGZlLx/JgerpaJ0HsPZwLkscO3fjWHyXDVLRM/NwUIMKqY2Co6GL7nbGBP4OPlfVaeY+mxkyHzuZOGpAks9Xd5XyFPxrcAvzcE7zGjh85ztxrQ0OMFXFC1CwrQAaG1uIAauoYk8x3CcimC/0qloaFS7HyTioK5UNGO1aXHGjtLUnAv5jTw594ZZFkjJmyrbmMvf2odfdGRFjkvD85Bz6ISybd72rYgICgy9JkhkfjJyPoxiCwvQxB422AGv0J81EpqH6pSQDDtX9BS1B2IH8b75SjaL/4KY94zXfquEcJTf7dLqKsaaocAvr44
 EcKDOcWt
 oiVtKnutHEW9TVBC2TauygaYIhQ2GzIwvL+e8QViU2K4xI3onq4mcRvLEOYfZlf0eTypzwFRQzIne8/ZK/Z0u/97JWQhiyNydF4NXD34H35VNKbXGNz5b17LpZpNZHl8esXpKRbSXuIvbdrOOSyjhoeM+ARjSHhVbUX+NgojB2HSV0Vzp4m3fYk6sUxuMVJ1Yi2hvIRC5d7xCJaKc5qdtAtR7NZli2FkmeJeaniYDS7iCri6/6yR8Tr7D86Aq0zgFBTe4Tr6V6ltP4rOFLhHNN0OKS1N7kn5iwg/4WyXxBxy/IOmgcVGInFPRjbwbJjJYEqRFc4QpIWLpSFDoI3ynUHXGtpfxo4++j/M08LU8Lmc/zYhT0/s9MS1x9CF86DvKfZJ1qii81bsSnAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> On Mon, Jul 13, 2026, at 15:55, Yeoreum Yun wrote:
> 
> >  typedef pteval_t pte_t;
> >  typedef pmdval_t pmd_t;
> > -typedef pmdval_t pgd_t[2];
> > +typedef pgdval_t pgd_t;
> >  typedef pteval_t pgprot_t;
> > 
> 
> Just noticed one more issue here, I think this will break these
> two macros that now access four entries instead of two:
> 
> #define copy_pmd(pmdpd,pmdps)           \
>         do {                            \
>                 pmdpd[0] = pmdps[0];    \
>                 pmdpd[1] = pmdps[1];    \
>                 flush_pmd_entry(pmdpd); \
>         } while (0)
> 
> #define pmd_clear(pmdp)                 \
>         do {                            \
>                 pmdp[0] = __pmd(0);     \
>                 pmdp[1] = __pmd(0);     \
>                 clean_pmd_entry(pmdp);  \
>         } while (0)
> 
>     Arnd

I don't this this change wouldn't affect for this macros since
both of them still uses *pmd_t* which is u32.
So it still only changes tow entries.

-- 
Sincerely,
Yeoreum Yun

