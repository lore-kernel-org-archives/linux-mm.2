Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90BAC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 16:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C993E6B0096; Tue, 22 Sep 2026 12:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C497E6B0098; Tue, 22 Sep 2026 12:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F476B009B; Tue, 22 Sep 2026 12:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DF016B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:43:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42CB4A059D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:43:02 +0000 (UTC)
X-FDA: 85241967804.11.B0C1B8A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1D73F180007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:42:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="DXSA/Gcd";
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790095380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acmbGOYX6e5b9nsGkh+Evf65NkqvOdBjs0iMPuA3tME=;
	b=bjBUw+wPYON2DbV8WNOknDXvR2XbzntRzfRJYubBdDt6TWRgNlGcd18OhKBtocX69bJknQ
	37YBC7BqvmeYRMxYfwfTjbgx9XF9nyIiZt1ojyutlEqI0zI43lqB2MVOXBkg+JL7QKqFhD
	1McZQxBuPM1Jw4YFmRdmAM7VKLrOv6U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790095380;
	b=ZZOYLKoki+aS/kJjGc9WdrDQjpo90AnE+Yjmb5POqkQg7hUkLGhaOHVmt8woZuUhuaMZpY
	QWU5+TpJc5++UfC2rL6u15CGu5XeEPzYP2PsxwqXmhtkG24t9OWvdk0el/CryySvSGgMib
	4McmwwdX52C1TyrG5Om78pNHC/HRxz8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="DXSA/Gcd";
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=acmbGOYX6e5b9nsGkh+Evf65NkqvOdBjs0iMPuA3tME=; b=DXSA/GcdR6HXs2iM/AY4Vz+edJ
	kA/NioItpmK4uLBa+N+yBYGy/TG5czyqFC4qExUiAy7txhD2ZetX+uytMySoVkb7vf95MpnQHobXs
	5nj+vhS0PUVYU2/JaoirFCdNajGdEWvlQ4wdWlfiL1oP8Yf0G8zCFuk5lYCptlXSEaQ0KOZm+zJN+
	NG7W2GGIrdOancjdcnpkIbZqCN7FFw8zwNf+GSbFUdO+K8gp+sYxBhPsjldvrqJGrSpLKHYWgpKte
	3kxOzApBvbjROOxG3nl5IbBdc+LakvvRp2Rg1UGqSPeIiJ9mKJOUkUI2TQFNOzS2neJmoa4FFivIy
	UMSxC1qg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x93ZL-00000009bF8-0eHw;
	Tue, 22 Sep 2026 16:42:11 +0000
Date: Tue, 22 Sep 2026 17:42:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Russell King <linux@armlinux.org.uk>,
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
	Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <arKv4qbF04KB2WxQ@casper.infradead.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D73F180007
X-Stat-Signature: iwcg8f7f8r3ha8wsi3ea6e6bu38p614j
X-HE-Tag: 1790095378-58717
X-HE-Meta: U2FsdGVkX1+WtWGh/WxXfKpPUX3YRv+hyeiKE3OVn281I6nrwhK+pzMvYpnb5YC/SXf+RMTtoPGkxdRSvUUDUZEBFOBLUsPfSsc9bXfQLCF9yJDkIvGBgvCvYeDZcb2EECCOxmzzmIqVpCyv6KgtRt1JKV55n8kEQlelKYXas5NyR5+mycv/M6vvn7Izekb6I6ThCVlMaoxnSBk2C0oh/8ByhiFibpR0RO+zUi+vQHR5JyAMlt+elv8zBWRi/Jyv7Yqu40W7UCQexwPiO73kA2hf+eSO6WKizTHt25HbSvmEAdLG/rMN1NBZMlCRnglkc9+EA1rc5Ql9+QYzE94zLD6jEXfVTUXkQs95D3H/T2vsJ0m0AHFPaWFx3r+QmPEzE0VCos5xfpyr2q3PSP/tApfkqUfBSByEWIwe0BXks0oqp2LrZkQ7IpKQQyOVf2sFbay49ACZWJr0YEmMg3qwFJT3ZuJ9XX68vaB/8w8PuhjWmI3M6c794dWZtwp0Y4OUEreo1jy+paWrox9llrZZtkEU9bCYQsoC/O+xhmVsxu2xGBFU0slH+oJ+zvwcAnsm1AEI90Umrj8wa4X6bgqTeso4CANxSPtojdnn3aOXX6E5V7yx64RmKe8+d5lvrAG4XpnFBlc7y0alGN0C106LBpksof/JzHu+7hgvaV/AijuEkVtvpo+RAWjaBpC3g9CTiTVGfSVxybXfeyU1g9zPxbdG6yNALFcnFs8qBGJ+yQnyW77NZk/8OM1SM67pTrWOJJoCXaizT8R7ibeXd4IaXb7Xm4e5klOpNl1PxzXo73gjIuRezUtoOG6s9Mt8RvnDSicwcbe+5KUE8Ny556OwHLtJUFp/f3CH5VwO15sEkir9gpmtgZdeIvpsnrKi11+m/EVJrraJK3bhZjFlWxSwOocTb9Qhr0EFvXjpXJTL+wmZinSe5DtszJY2BhV3JaPJ/gpbBvk2S6e88KpVXdR
 MhVFQQ7o
 6dYrbMsTnCYBzqBBkT32JNi81/gW+Q/SRmHkqjee2Na0Xr++6wnzZnEzBprmt0vZ65qZ6dZecTsx16fhNrkq56kip/XuyFy5w9iT9qpHD/05QyVCJJMRvq+vqxZBEXnzS0VyWUso93vHM00DBTiC3cgHwM+fjqvBXI7HeJWZr9XrTDaSyi07/fxaZPoNwClqg3z0swl9gjcCtjsmLGSv/TljdWOxPtqVfsOrOp5UmmSuYQrzLYfgs3yoAxHz19EiFdacrDu5c/h4uJx2YM+k8Jp3mCy/e82SieMeLMoqtAi9EAO1cCZG6gCGGZv9UQvqYKQtvVJlbG7TPZRZEInptFxyVydiOL4bP+HrW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 04:35:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> m68k-motorola required the biggest change - since RCU page table freeing
> uses call_rcu(), this means page table freeing can arise from softirq
> context.
> 
> This was fixed with an IRQ-safe spin lock used in both get_pointer_table()
> and free_pointer_table().

You don't need to use an irq-safe spinlock for softirqs.  It does work,
but it's overkill since it disables hardirqs.  If you use spin_lock_bh(),
only softirqs are prevented from running (and it's safe to call
spin_lock_bh() when in softirq context, just like it's safe to call
spin_lock_irqsave() in hardirq or softirq context).


