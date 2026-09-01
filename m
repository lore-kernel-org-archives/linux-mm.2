Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D419AC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB46F6B00D7; Tue,  1 Sep 2026 10:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64A26B00D8; Tue,  1 Sep 2026 10:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06106B00DB; Tue,  1 Sep 2026 10:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72EAD6B00D7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:24:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4BDE160413
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:24:17 +0000 (UTC)
X-FDA: 85165413354.21.D01B3F6
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id CC94018000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:24:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=oMq8UQ5Q;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788272655;
	b=Q89IbB4rzFTXyJM1Dxn13W9z1PZpEdrertYBxlfrzFScIyGkW2UtG0I2i0VYDpW40xen76
	PKlTr30yMwCAJUVqliT1IOR/4ChNMSPzmAm30wjhDMj56pNylGJhLX5Gu1q0QWPvMzclcl
	Gvf5nxnJdtdCO+u03zzd3fE7XDyvytM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=oMq8UQ5Q;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788272655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMNw5MzyW2DJkQCetuS4jMUrMgDtCzVkmjImJH3QcQw=;
	b=x20bFb8e54FbSbifmG8LVlP8JqjnF/s2EuxgjGWXD3FauniFk5FDABKKMbJzSXBEapl5cb
	UALMzR/1u+/MYq1pMjJMsVTh03FbO0Fcfn8RfyI/dkiw/A+MDRoTM/p0K9NlG0Wxcq50kW
	JC5v9SExwUWL179dNQAi99WzdJdkzgs=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9371bcf1f8fso347685685a.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788272655; x=1788877455; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AMNw5MzyW2DJkQCetuS4jMUrMgDtCzVkmjImJH3QcQw=;
        b=oMq8UQ5QSImyqU5PBeHOwzZsgDXXb/o2Rq2fRAXeKCXDBHX4H/qHOQoKGcvcArxOPs
         O6dFrLauxjdUhe7eHnMN3bMGjVFL9PvcUOsf/k6xGGiEzu3JBRqliAbcI7bzwqj34GOO
         /5ovt0QdKtaWLr2lARfQlSIuQeLO2ilJHZaFf1zzJZgFjJt08SIxSNQAO7ShoGB1hjR+
         ZGzsYJV3KTRBVF0EJVItAcClSzn4djR0ACyvsAW/9x4uDMbuA9OCb2ouVZXGuFkDRSMX
         uCFXFcJa7DLBhx7qU+0V4ZZugbkn8dH1I/v7X54JbcW7Saf/ed+7qVFmq7ywM9U3rBjt
         AjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788272655; x=1788877455;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMNw5MzyW2DJkQCetuS4jMUrMgDtCzVkmjImJH3QcQw=;
        b=OCoMy6c+8MjIJbbFyEeGXv48q04PL8j1NlXhGluDgT0c9fjZLkiAaE725slUnxskJA
         IeXZ4NjYrNcFJ/glpu1ZlgG2hpR/eOShwz/mnhedoO5u2j2gNdjNJXL2xjd76022KcFD
         zFTQYSje3fnIcj+xrYNQm2WYODFFF5ZX7IiZwHYl6/Kh06WiSKQ5OJ+CUkf/jX7jh1j7
         XtXequga9/UQvjpWSKe5ikOidqsIS8p/aH+M60/cEtcZMSlkBP7rHTjt0GPCL1BeUjAr
         AwADMcLCv/npDF+nmowXI08rRwNC4DQMt1H7H4MFK/bGoo2NruNQgWBE1/jeJ/QrHCA9
         VrFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq17oTW3a35yghTxE6Zxt+B86xsKZqaVOTLj8iMYi2QFEx+89HJpn1JmmHB9C2ZodxKuZGhHTP1Lw==@kvack.org
X-Gm-Message-State: AFuF++npgNMfrrCVPv3yUS/JA28Qp2y9++l1Pao4GPbRY/pdroCc8gyX
	0qYIJqEvMFrNwGLiOjv0RyICZamT7l9YUgRQY9jsJWKVT9c4+FETrEHMcMTZKWsn0Z0=
X-Gm-Gg: AR+sD11F5pdTR3o2bbXodxxZdiDr7NSKvTb0QFcPAT9qMh6197sVdaZCE3i5+6wMdE0
	PpQU42+KNtoZEQcp1GVl3+92ZWgMu7r8pccWj7uyrDYBHIBKW1vRZiG0ZxktDK6MjCORr2nVnHY
	wOhTd7M3cKvTgM6+AZqAInkuZL9V9bhd4vxtlAmn3n8YdkD3snvIfVmwh54/fZyx/TKDAfuXWt8
	Hwn2QrOSZbYirGgGHhSNiV/kjhW8MeYnqbbs86FOqMAxQVVaMaMm/UJnkJ6Eks8yuDMmAbaGSjB
	H8Hz0rkB8bmK0RP5Y1K0lSbdYVXLAhs4GpPNV4N0juKHe5I9bYlQiCBdn3HxebLMOytGzlUgKJF
	4RTXpKVOiiLo63eNf6Iu2ngFV2nsSaqVeEudEcdqQNBkA3kmlRoU9ue/x+t4F0uto2PoE7VIIdS
	gSEaBGsANE3/64cvubKRXC8+pBjfW/URpOT23crm97yPIzv9ySyx2EJFnPLO8oyh5TB1pgtYuBH
	yXhlwHayvTl99AA7cc/jpTeVUpL52mZ9tRUtR9X0cl7EQ==
X-Received: by 2002:a05:620a:29d4:b0:934:ab73:ac53 with SMTP id af79cd13be357-939134fe550mr3924451085a.0.1788272649971;
        Tue, 01 Sep 2026 07:24:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93917012b65sm1040535485a.2.2026.09.01.07.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:24:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1PPE-0000000BgeE-10ID;
	Tue, 01 Sep 2026 11:24:08 -0300
Date: Tue, 1 Sep 2026 11:24:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
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
	Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
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
	Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <20260901142408.GA56830@ziepe.ca>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbcoMTVlL42G5tg@gremlin>
X-Rspam-User: 
X-Stat-Signature: m5sxjdy68sp3fgjmsmc1gt78miteihjk
X-Rspamd-Queue-Id: CC94018000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1788272655-825589
X-HE-Meta: U2FsdGVkX19vevD601n1dHt3vL7a4DU8FRXesLvN+G7FNQKGQHwsn6qB52ej/tpg75v4pCNZ2SgT8XVl2BdkJg7ilXQidPYu0CLrHMjRHlaub95CfrsXYDj5qNhVhJE/u2j/NEn47UWwJMExyliqAgl4B2ra3fhSFgtE4EEKI84ZXOvL0QkYa7iJAbYHPg5KWIG7w85AQQg9Ecw25x2UMo+Y3S8TO0sHf22hEFgo/4uoKHklcvyJtL1/6xVsgHsRVz5BfR7lcr/0RqR663//y3wN2FMfONJI3mR3lsJmnC6/wGtAFYhL7HawK21epcVhP2NDzwOpxwpdDQgheBlFFFbd+Aiu+mn5fBeY8BSL6dcNZXDoe31NbZkGLW2r1XnnvECQ6+9CK5fFUx+0Zu36FDU8oQYPM90G2yVwAN+6EtqCuXmECGdhss4goIzMiNrM9z7NJTJdo3GIs9RVKw39xwET8iEOBb9ZFXQxDCn1qRzpdQ7CqL1KOj3lzuIEf6nIi7mIGVrVI+1C0g53SbWumR4T33wlis7A733m/tI8vYDMABExMiCHAC8NV9fb0+CaDDv6G7EFv1xNB/0pbfWWRmk9b5eaekYyQyf1N688xO/DgjsOYDLLahe29AsX8FokcUizuYcwHRN3VoeugjP9PCFj9UNnKdsvSPNS9ne0X1JJIv0UnVGAT4tNQoqDtjmMdLAooNkuHaiEWK1dGF9cbg+62lvnR0izOhc+tRurZDK6ajRkz+dAtoOI+1c6i2jYkVtp8fvFG+tNz5N97lmbMAR+nB7/86ZRkLqj245rp9G0EnysXjJNLQE1/kBk9iz/DzKPoXJqQX+PGBwTJu9W/YN6CKa6C4dMf4AIA1baQHJCNvqqgKv2pf1VJRHh9O06wPfeiBN/syLBYcYnN1J8Hf+py3e4fbVqdalnMrwNB44kADIDFOEStZ4OTnj8AdPHoOpJfyWkAuXyiwspBZn
 kIAO4cH8
 M50ttLm0tbsFCQP8/afKluCj8APIpCe4wKJ63z//sBTZEdjH0v47ZYBIEQs7LfFc7VBmuCB5Esy6l88PqD4qQRYqWn28QhFWvCLmM3ChxGunexp7NVCiyuWhkxQ+FEFu0MhhBusMBQLZOhy2ZTKXZ6VZbF/qWkC4JLpm3IHrSWbNe2A5u/LS6Mc9K/Q5fAh1KHMwC2B9PsMrw5c6X71ExzsinuFh4ng1EKFmj8Ld0vU+DFGT3ZBnSxZ04HZF9myq4N3+IG+Pl1n+MPUuJKSttOwxfvRYz9LDlCNBPjrmnJhVaYjsB4Fjdv3s3Zu+MWi3Ekj46PfUyiGC8M8e5PQC6CZKWJI8MFeIAQr78J0nIDB7AjZMARYFYYOSDkrsETR3lkumzNiTei5Kn8d0E+H4sHKaQQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 03:12:45PM +0100, Lorenzo Stoakes (ARM) wrote:

> It won't be costly at the time of the calls obviously as its deferred. Maybe
> increase some time spent in softirq but again is 512x that big of a deal?
> 
> I'm not sure how you'd both defer the free and somehow utilise mmu_gather here
> either really, certainly not without it becoming extremely messy.

The less costly version is to thread the page to be freed onto the
mmu_gather through a linked list in the struct page memory. This is
super cheap since it is just a singly linked list operation.

Then when the mmu_gather is flushed it does a single call_rcu using
the rcu head of the struct page of the head of the list. The callback
clears the entire linked list of pages.

Since you have to tlb flush anyhow, it makes sense to always use the
mmu_gather. For example the design I ended up with for iommupt
accumulates all the invalidations and all the free-able memory into a
gather then invalidates and frees.

This allows maximizing the tlbi efficiency too. You can't do call_srcu
until you flush the tlb and if you call once per table then you are
also tlb flushing once per table too.

So if the kernel really does want to clear out 512 leaf tables the
optimal implementation is one range tlbi for 512 entries followed by
one call_rcu to free the memory. Hence the gather..

Jason

