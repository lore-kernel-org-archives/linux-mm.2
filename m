Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF591D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 03:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D896B008A; Sun, 28 Dec 2025 22:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442076B008C; Sun, 28 Dec 2025 22:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33AC06B0092; Sun, 28 Dec 2025 22:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24C4C6B008A
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:14:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9F121607C6
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:14:29 +0000 (UTC)
X-FDA: 84271040658.24.A0A8FB7
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 02F2240002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:14:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsTctdZ8;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766978068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23WFVh4QD8EwOyb+DiEjMorTSabGcCdF0HCkzTj5UcI=;
	b=4LZrxBQtcvS/mlbq7H/FO/wDrpz2nr6j0kIAd1cBz/YAmOBZlqbUlarkcMcsGTFFKuiJ80
	CHS097eLDCCBzNM7swYhgOGoeBlUnIbVtBNz87RwJMPDuWIi10LEQVw/ocii8YZMOBour0
	ZQT8defJhkplk6FY1cPm3TiXgFWw0e4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766978068; a=rsa-sha256;
	cv=none;
	b=5eSgh9vlRNyuwceCMm43fqTnoYEMC30L60e/PxXqXO7kYxTBsoguW+om8n/UXnvFCwK1V+
	5tdpFtenlj4GylV32AdJIV/BkN7RIfeOACYg40i5xPMh1glUklAJvmUegSdsbnMJlQhrUX
	Kc5EN0srl81iQlYiXGTMDGXqGdNTh6Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsTctdZ8;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766978065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23WFVh4QD8EwOyb+DiEjMorTSabGcCdF0HCkzTj5UcI=;
	b=CsTctdZ8U9pUZlVucTzftHHmp2gnI1r0CzZFlnpRDH9PaP1qXa4UPAYSva2HLine9CfV90
	9W72CV4/QFwNiVWLYQ5mHLAgZrQcKb5qzwdX5woVQVU6YQn8JsHteRlat/Z+Spad7CIWaS
	h++GDN5U6j2LdFzXpT0UvZYdzjPHOv4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 28/28] Revert "mm/hugetlb: deal with multiple calls to
 hugetlb_bootmem_alloc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251228124001.3624742-29-rppt@kernel.org>
Date: Mon, 29 Dec 2025 11:13:26 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alex Shi <alexs@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>,
 Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>,
 Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>,
 Michal Simek <monstr@monstr.eu>,
 Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>,
 Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>,
 x86@kernel.org,
 linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org,
 linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C8C5C80F-BA99-445D-9711-2665B1262C66@linux.dev>
References: <20251228124001.3624742-1-rppt@kernel.org>
 <20251228124001.3624742-29-rppt@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r8nw497dfdwx1t5ogw6epnpfeu1cmi5x
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02F2240002
X-Rspam-User: 
X-HE-Tag: 1766978067-513421
X-HE-Meta: U2FsdGVkX1/+M4IUGRINK2zfrWTaPNmj6kB6CefWEsGrykVjX8jtA2oXa5Dn3PvgYtsouYaIX+QkQf8Cqvq3yrv5gxZhSewy60Ys4mYii6A6uXm5M4RpdZanlqEc6HM5ZDEMvAMNKTtHqqkHeMkT8mZyOgiBbgJzNv5iUNM70GKxkb0EgJEjVJNX+XSv6btTkZTOErV4DQw5ir5UqXv0YBVCg1a/IoOQ+/VtVADA5R0isJQSiFndP247vg4FIW3YGrJ1PtAgoM7WSinm/pkrrJdy+CiljqqlLrQO9tUc9EseJM+8kSvkW/9+qwr16eEtE+a4wzcYqobcF40zOIZnrW9EzBPktztu3/Ur+OvkrZ9eMtPyABNqe5SRvO41WOjhHrEV36+E1MCxraKCiHFzt+Pu7JkpiyR3Q++PkWHaa02dwfOxkQ6ZVscNxY2Rm+7aF0F0beuAYdGon3VvZHSPRv6f05h0E1V+kXfNo2aP/4OzhVbQejWG22fbJlLG9sZts7YeDIgFcOQ8uHg6aHh7784j4PU2qenQ/1aWt9lQ9LxMVLau9pQSbXP0HeEOavCkm6RWLL0chGCKg9sI9VaPL5s4WHKbmqCE1qa9teg7SQEmJnIq9C7sn33be8gudad1Bs5kLpov48YZ5hbIA+9UMwuGHXjMX25Yf7hMEPplBcWXJDJgJ1JujDB6LEf7j7HhssWzcdRKHQhVPKKU2DLViUkBsiOX2O3lTtfkJimAs916hbovXh+eMKhmzSLrKott/S1QuIeDpRHVeKB0Lwjzth54s4cgikjTW2NtBJVgRQB1F3uzK3srqgIRdjBE0tbNgSeu1/CT+KHrMxaaxDFOSpiNlHOkvxDJGPCP9M2OrWy7A60pLNEbca/5o7TnJPpYJD4edSRjOplsUpC/3nBhWBnZIkcVx/f1aHc0qW0iw6G+2ejRAT8FVqQ3dFM/2pII4II82H8/70Tn7S+8lIS
 vJxNg8xb
 0RJVI6W2a0NrN7h+X8p7APIN2B0KZu40Ed/3HGw0TzADtPHf1WeSQ2uoLqEmeFBC5O1kLD9QeE/dcu4jOB/+TYez7tfwZUi2OsJLwHioSs4M71h5SkYH9jkUQYowYVLvRofWJ7ZSr4TNS9os+Yf+F33JS4iiVogPS5wjMYjgTSxoSnaATI39FkEK4hZzbTRkEKquIrrzsnRrcMrBC3dgtaYFhdlge7kjeEKVGhsVBxtF803dhbBvmXlTKMWf21wv7YcjUfqxZzViA3LDsYOmTZ+SW1mEmEHVfnX4NrsrvGmg58yVN3BBxRrrt7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 28, 2025, at 20:39, Mike Rapoport <rppt@kernel.org> wrote:
> 
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb_bootmem_alloc() is called only once, no need to check if it was
> called aready at its entry.
> 
> Other checks performed during HVO initialization are also no longer
> necessary because sparse_init() that calls hugetlb_vmemmap_init_early()
> and hugetlb_vmemmap_init_late() is alaways called after
> hugetlb_bootmem_alloc().
> 
> This reverts commit d58b2498200724e4f8c12d71a5953da03c8c8bdf.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Nice cleanup.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


