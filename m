Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D6AC98304
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A866B0088; Tue, 22 Sep 2026 19:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDCC6B008A; Tue, 22 Sep 2026 19:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE146B008C; Tue, 22 Sep 2026 19:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B42F96B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:00:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 415E88036B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:00:28 +0000 (UTC)
X-FDA: 85242918936.11.CB4E114
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D186160005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:00:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f4enYMEQ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790118026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67Wnb1WqUtfvvqvCH5gthEhN54uXfj3OJmtQ8451vqc=;
	b=g7Yajxqg3dwSMrWqhw4xsjxqxRG6q/uSOjSZZcgXDZr/XZ974wYSSPgz4LzkeXK0pei1Y6
	nlbHPwObm0rbv4b8FDZhcPKD0DC9cU5AeYm+SReyw88/fg4WjiKHAKxgk86VUwVknvvMPm
	H4vz5XGuRck2hDTXjDommdGZrOy6PPU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f4enYMEQ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790118026;
	b=hSATWxt/8eaZfqTe+iETw0MtGdjlqckYhrcZGQmJQ2r7lAhTHi0LV513qGYUvcds7NUuNY
	1GMz0jvC6hcBk6JlaWAN/cqaIonYJhpBn4mIVF7h71WAKsg35Hcm5UiiTeCaTQMK3VMRKt
	eCTFZcMnj8HsMeeOREjuVTHlb+uEdXk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87FC943584;
	Tue, 22 Sep 2026 23:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DD81F000FF;
	Tue, 22 Sep 2026 23:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790118024;
	bh=67Wnb1WqUtfvvqvCH5gthEhN54uXfj3OJmtQ8451vqc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f4enYMEQW7QizF7EO1g1cQ4u8gA82wou/SQ/2W3Thvjli+h6aobD5ZlJDs/jfh1FV
	 zSB+Kfk4FuUqyw9bmcvk46t07MCBzK0NBIy1fjrGw3Rhfy7nWNjaUOxIcpoiKWtmMx
	 CWvPp7SZoe+aH84d+5DNVA8gveOr1sRQo2MPtAwc=
Date: Tue, 22 Sep 2026 16:00:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren
 <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster
 <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne
 <shorne@gmail.com>, Rich Felker <dalias@libc.org>, John Paul Adrian
 Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>,
 Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris
 Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, Will Deacon
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick
 Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland
 <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge
 Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel
 Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Randy
 Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins
 <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-Id: <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3scejeoryejwrpzcgstarfrxzmru79pe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D186160005
X-HE-Tag: 1790118026-824905
X-HE-Meta: U2FsdGVkX18E+4J/LTiPOiCsGUL1nSI2QJLHS6BGWur3+cpuPdHgjgXpRhhSt0+U4k+zFdg5CRpUJN9LUynEsOJBKl1aFHdKM2OASfs9bmgDT0kJpq5L62oIXbXasITp2LCkQhSfch+Cvm+qIvutwT6/QlajldgVrSDMK8YANQGOPnTPIkKxVus1SPkwcaV3UMeERE8brzwrzSgDE7FkvrJyD/slnz/Ae3LBNEmg0nm0YvOLrfk2ai1tmu4X09G6K4HtNnGv3nSyUeT4SCVvSoymkLeiXkDFmPXDGZaFbfohuAILQSfdrosxEipCdziVQyPR6f1DUkMdbOsFxylWyZKl5LxQdaDgFIyD0enwFbhkoN+UyoXT7861bk79rQHmKeguMMu6mTaZ12Cth7pHmVWANWj7ObgjfIqtlK0YnSy0JFjpyZ79GrJvAKBNR3vSiFx/L7a1U52R7TZXqIcje14StKjZ7NiVcR64OoVsM8YP/YwUWgS+WWlyY2du0gemrdhj52tmjG5UZSJbi/hOA+B6KCjnWDfcnhlVhxkjSz1U3o4dP8BAByLXzGvTXEQytYtxlEFf87Gmcx6s71QL2TJhgtCRw2Pqh9qxN7RSLF8vLf5g1Uqg1Bp71dpVlpoy8It3rUPYLluDiWxzE4RBdGfCCAwCs/zKUDMDxY9JG3nd21fHRihMdiPS6vjQynoGt9Rrzv9nqAbZb0Q/ersaHXp8/0IqITYUEvDNngPxjptJ7Du6RpMF10rpNYJgIihs4vl46upb/IeYqwf0bXcbIWifWJ3pNN46pp3V31H4US0wHVnJCmmkQKPbJKerl13K2xv/3V1YS1QYDqlR+/rl+P+4l+fYcaFHwnmRxE6EvX17OyjG70UJ/F7gN+9aILySYtKnSEsxgsDI2vhznKDkP/pRoZ2h71+WN8PXLLIOsQkXzMCtvNgTqIe9BL41LR6XGbiiqaOx6nm4reJlIak
 mLl+pMs8
 mYL3KuWj3VhiI7qLjlvbqY2QlhyimdNviam17nA/PKphH/a9sYVxpiVqWgmCWp1fmrTnBaorwbku+QWEtcJj3lc7tgRZdUc6lQ+AsiHl8C2AAicAMrF+Wo39RvHUaqzEzhXzJf5WEaCQARUvjEbxbJb5KpnYx14fSEEeI78TgM3CiXUhNmldklh5Kaw5xshW+E7fqaM3FrHfc0jvQfhX/lbBMUBL1iOot1CeKpFH0pNQCbMBa4IR++nmJZgRMwmuhVU177gbQ3R3U+G44hVmYHl/Oo7It9GZTHtUb5VRz3Qlc/uOWtkMxOo+5PDwKei9xiOJ4KIIvkzM7Wm6g3iwpcaB59m2e7/brObGW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 16:35:31 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The majority of architectures in the kernel defer page table freeing until
> an RCU grace period has elapsed, this series converts all remaining
> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> altogether.
> 
> This is important because it enables safe lockless page table walking under
> RCU alone.

Do we have reason to believe that anyone is seeing any effects from
their arch's failure to rcu-free the page tables?

This sounds like a rather long-standing wart, yes?

The patchset is thinly reviewed and mm.git is bursting at the seams
again.  I'll play wait-and-see on this series.  Feel free to cluebat me
if that's a bad call.

