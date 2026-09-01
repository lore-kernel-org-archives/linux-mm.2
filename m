Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75686C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B76B6B0092; Tue,  1 Sep 2026 13:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6679F6B0095; Tue,  1 Sep 2026 13:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557446B0096; Tue,  1 Sep 2026 13:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFF46B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:48:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F1131604AC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:48:42 +0000 (UTC)
X-FDA: 85165928484.01.002BFBF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 978F0C0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:48:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UVtis7e+;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788284921;
	b=tQe1r4x2LKH4B6PN8GXOF3cFUTAF4Mze8qHkYWCgAXrsemljLfFJfP8MqmTomUM0KqedrF
	CIREhPv7/XUUI8RduDrPfBJUhCgNhY5cBnGPXp5VWILlDuVpcFrxcRPv6B8PzuCnP6Bbhm
	hnRS7nVTrwVefNonVzLl6EXVroiLZ4w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UVtis7e+;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788284921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQNx8cP7/H92zG22iJw5UI7f9yq7f8zWrRV0yPrbUWI=;
	b=ffcCTOCWPY3uhj4dNeab4Qao1SpjLWsj5pFFoz79Y3Gvld3YKpqA7IksIPcCCee/prIGS5
	kW16UiG17K8+5zMsIbkZ1JTgBCJ+qHHTQCbagEfqir79nR2q638nWPHjDOE2NTq0JK7x1L
	CO8c8/tjrtwvcghHWP+F/ngirMOhbmw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PQNx8cP7/H92zG22iJw5UI7f9yq7f8zWrRV0yPrbUWI=; b=UVtis7e+r5/G27TIqfxZ+en6iD
	ewP14Pe2h9SnqatfXnO6L1fC4qcBnFOELp+V8WjW5RT1xwY3uZi3XSEv9Vu+4qZ1jP6BGVn7PXBEA
	4Uw0Phr831M7R4vLdI8REUIOdbiINbJ1LMU5Mje2MkkXTCbCEn9Xn2ArP+y9asBIjud478+zn1SSo
	lebc9FLfrg1/y0a6m2dAyJLJ3yltmw6G3+vcRUXeO4yRAwAxeKznEDSHVJJRWpAMX3il8mcbEeTWo
	3139sv5kbIIlk0Z/E868rddoQ5sSESOXVT4ZQj4kMrc2J++kPSB2h0IKqxPLn0UnyiWT6B5SeVd+c
	852DOAfw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1SaY-0000000Crxj-16sr;
	Tue, 01 Sep 2026 17:48:03 +0000
Date: Tue, 1 Sep 2026 13:47:49 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
	Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <px4uwbuq4ixucmjzudxulldk5l2tbuymaoaheyc624jdznnac6@px5wkmxqjmfo>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
 <apbiB51hjm-9pRzf@gremlin>
 <apbuO_QveZNAz3ns@thinkstation>
 <kasi4mkjkt56wxsrmphm5o2qfg2lwsdxf3tlmzx5tq6t7uez74@kozleoavd6r2>
 <apcHiE7jDQaFYXOM@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apcHiE7jDQaFYXOM@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 978F0C0003
X-Stat-Signature: brwiy8ixfkzi4wxmkscmsc8tqyuj5axf
X-HE-Tag: 1788284920-327251
X-HE-Meta: U2FsdGVkX19XlY0zTzfU3g7WA+iYmJRnSqQggxnII8STUUCgMKlqLCUNN3MMNDHiPchHsSyo5GR0jGb5S/c1Nhh/9rGaUob/TAaxC1HZtx5z7JqR3RhL8MjFag27F4lVB/zv0QQW99LbNBKl8WJTrE6MAFp9Id1/ARc96iRYK+qpF+9KrUAgxORyhaUVZYMsyc+sZWSeZqb2Vr8qbwbksyDSUO74pJhjjNCvObMwhrzfTV0t34gkm4I73sgITqDMJcoEBqDqwfiy0Wj61V70HRiibLaPFVn3ITmlRmxx78wSJVN9wpwIywDu0alY/Bc9MTlbWdxboFZ8hh9R7yTHkZyY7Nas4D83RDGZ+6febDTXxaLmpyU0AQzENXwJl313vK9utqSbBTARcAM/5LDTk8wS8VoDC1hKa5NNmashAjrA5X5UFxAfb3k7wtA2sCErNoihpt9NFdu5c7FKZCu0+U8+xphttFGzDf9uWJoNcJfFJCpvwzvVd7NTwVPL4LD6/knZRiWqHVtvzMqZAkDOdVEUQDJpKf1q+1w5sLMQvSA4HxL9DtSqZl28BE1hBJBCwYe5BoL2moGE+Am/cQtmDHB3YVKaJcNhgHAfO8nHT5reasHmOeS69HZs2lGL/tKEWzhvxcN4rF3sUebvul/uZPymeH312r5VD9ahZIVvaMlf8uVm4jqQRLa3HXqDXwX8R4VVeFpbYvAjRyOIGL74PzvNmDExuoX9hkWgtBE/lokyMVkVuO7YEG5KPxDs/XA6+s66gDcaNm6MnCMYlXGDDiDEPjmHCq4SDcdIcpwy7624wuqLIqz4LMYOZ6G/nYtgV8CuKkdSsyE5ohHQhMCggnRzuZ16Gz07o5EuiY+ViF+mwdS1sC9cVToU5K15cWSIKd6KnUITMpkYtlsMs6bdLd2Qd2Qd3hzBoHD9YJknh/IzxoDhKn1wa7gEGUBvDocuM83PcUzrBxRm0dhSGnM
 aJ0aHuE+
 MwXNo4ApC4NCDhsydhAMC2RWxLKOjNtttfjYFhN9WPtLxNzDT82VJkkECF7iMsxEhPW95qxByHdiHgsJcZB/oFULI/6nzFP3co8vtt5zc8ubcCIb4QpXztIYNT4nKOk6ChoGvCFNihbwl8ZEsM7Tok7A1ipMGX4IqxzXhFFn6PAqi5jrKmDa7cJvH0B6bBCo56a2P50PPlEU1Q1eduPxelpSEgvB8JpC3xhloz3f3GqaRKoUnNAiHAwVG0uqR+mawxnVM2sKqwEiY2WLIcPYX7sHMcEf+a0pw/4dUHsD2F6aAvJlj+3XMSSVA6zeecM/C/kEwoGjKEH3yruZnoVKA/zKp3V2Az7lcQ2DkI0LF1Y0TsGoIDdXbmukVm5L2KxTFEaf+xINAk+wVgxVZuzeCKe/ecg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/01 06:13PM, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 11:54:47AM -0400, Liam R. Howlett wrote:
> > Do you have munmap() performance dependent workload that you are
> > concerned about regressing?
> 
> exit(2) path is performance critical for many workloads. Like, if you
> need to restart VM.
> 

That is not enough to see any impact, although less overall work would
be done during the exit call.

It would be very difficult to come up with a scenario that this would
have a measurable difference and an even harder time to come up with one
that is slower.


