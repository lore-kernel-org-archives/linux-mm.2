Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EEC4CF45D8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9AE6B00A2; Mon, 12 Jan 2026 17:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BF66B00A3; Mon, 12 Jan 2026 17:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530176B00A4; Mon, 12 Jan 2026 17:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41E686B00A2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:23:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E35ED13C5BD
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:23:28 +0000 (UTC)
X-FDA: 84324739296.05.4EE43D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 313331C0017
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:23:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Cu3Pfm/+";
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768256607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51z0RRn6rM0eJ/b6q41tGegeBoCrn/fTIV68gsegujM=;
	b=mn1oYZIFzHj168PV1+ByLGreozyYQYDAxC1Q72qXiYnosHuhdN9yPkjyXbBIltxo7fFcD1
	CsdjyhhTG+NMZG7GjW1uXXrBnezMMeNNkvqqKSHQikWV5OTfhORDXCJxDyjnfmz0/BKtNy
	RV/7kcNXTxI0C7Sxqyza+JnCyH2pmoA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Cu3Pfm/+";
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768256607; a=rsa-sha256;
	cv=none;
	b=wBsRsne+SsyHnUKNgQG9HX0/fOL8Ww26tyU9Aoh9yB2OIcqn30ES19bt4UFi7vBWEB9TkY
	7kHpd43hRKxHn8uBHEGJRMboth+A+VBbIg2NZp1bETEY0lz9GoixA2veBFOkNKyY+m+H9p
	bk0Q4e7AXTCcaqj/X6HGje4hxNWjMSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED79B6000A;
	Mon, 12 Jan 2026 22:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AAAC116D0;
	Mon, 12 Jan 2026 22:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768256605;
	bh=SpuDKcG9IirDr1Ez2z498LsN8t6S/nWxhPc0slzDnQc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Cu3Pfm/+1TcchxFM/qGiV5fGrKj24o0e3dohdRVVx8JRBK5f1xTeaKdQe1aN7KItj
	 nSpF4OOybQ5f2IlmddpVi4OD3JNYihOeyIRTxNzuxSiGem9/NnrlLPMv/9xRBenAfz
	 EMoQzi5wVQrdA51MdiCDjlgWkvA7qQuIwG0aa67A=
Date: Mon, 12 Jan 2026 14:23:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>, Kalle Niemi <kaleposti@gmail.com>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@kernel.org>, Dinh
 Nguyen <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge
 Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, John Paul
 Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
 <corbet@lwn.net>, Klara Modin <klarasmodin@gmail.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>, Max
 Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, Muchun
 Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Palmer
 Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>, Richard
 Weinberger <richard@nod.at>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily
 Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, Vlastimil
 Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 00/29] arch, mm: consolidate hugetlb early
 reservation
Message-Id: <20260112142323.495fc43e662e7d276b0fa371@linux-foundation.org>
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a4e3gbu4qq8b5t8fcrs44m1kx5cdw18z
X-Rspamd-Queue-Id: 313331C0017
X-Rspamd-Server: rspam04
X-HE-Tag: 1768256607-15820
X-HE-Meta: U2FsdGVkX1/6oNe5D1Ad9yHMDLTCbk6kUnOTM4KwWQaje1oJK792TkXqlT4VSp38F9RgFQT0PVky9nslvIYQ6MB1ncI43If+DXur990OwivyQme4ojI80d0sQfvtheF4z4VukeUP+xxjflMh+H7Iaej7ViD0w1vppAn3sN2ZB2sPoRg+9K/BHtpCRfqGrizcWLl+0/plmcXtDuuGD02QLvTtFK5n8E6f6JAfEwqHRHafFZo5ifBjNuuKyuOsCTYs6ndSFRdHNX4wWcwDbsdSuoqWTsXHNsQcCCKrdpcQQPrvVy3oql7Vegj1zfJI8/jATfDTBbvZAgEcBow5nhKBlQ1QyC4TnXAM4WPXdq29MhMgQC2E98zp9h1hQpeMqwLbsbRnUyBTjxgIMS1KtOATTCWmunBQGSbIzITJh/1NUgxBAP/b2VxdwoBjqawuU7+t1KnHgVJuDuARtrXYrGh5UR24JQNX1JHyWDQP5Ex7BrVTCKi0XL+wsTror3fE7z9D2r4a+dUYT5Lo0++K2Z4XLaxDh1RCCX6THJOk0Af6IwKRuSD/4sQ+7V3PbmDSw1LOSgdWkIsUj8/9qNXOI48SHVZaGvix3my5sqH+ayWlhbkbJAYxO0qfaHbjaB8Rz9cYAwT1q/u4AQnR3gE4YgkfQSYeLCORxVxfMg58Tnd2JAiQvBzIayjOdFVMhozW9Vj+/1Qd78usFK5OkzBh5Is2asje/HmAFTiChDx+sfVqFCaL3l1ct2w7CSGTrmrqXtjsDv/4aWH6PondMknDnZb2XKIiQOg31purKO9/dp8/72SY+Zfkh3i6lnTgFpReno8vBwrtR6tR9QjYNCpBtMWM1nL8doJ2SEuXDxhl+kBxfgqhTIryg9v3Adu9xue7o4W7VXVJh6kj7ltj3PG3AQxJEbceZAfKt7CO/oegFl1E9MYMWX9bqBCpl8745W7GAinrsMqvDWvoO8zXF/71cBZ
 0XMEdoPp
 c8bQnkD25jbMX8+NAZf3elpsbThoLlzFesXSSivM2N5sA26PGqo/3Vh5AqDXs4YtuT7KVRTlAn91tyhKU3/D5XbzfFUNUIeOBEn81eobOACf6TeZ5cqwTbs9n62SUUxDMxx1tCWNdfypyWD9yk4cO8ymU52kBB2LlKqy16JHbEi9rI7uGfW8pw+oXWkvRUgq6T8EJMshQ3/xnvPMQPHwWRYh2JfdmMwW4evficn2k+I0TRk9eN5NkyEakXdgOgHTmJV10Y+rnb1pNoLIk2/u245o30ZHdzpyl3eBvxsCRo/H8BYIku51taW2vB1NNcCG8z5W/l9ObugR4Lz3mGn62gAgp9PENso6HBvX77hwhs9UT7Lmu9BRyTmD2CcqOTYKAU9zg6o0EskjozaYF8c7ey7Dmhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 11 Jan 2026 10:20:34 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> v3 changes:
> * fix empty_zero_page initialization on arm
> * fix ZONE_DMA limit calculation on powerpc
> * add Acks

updated, thanks.  I'll suppress the ensuing email flood.

Kalle, can you please retest sometime, see if the BeagleBone Black boot
failure was fixed?

Seems we haven't heard back from rmk regarding
https://lkml.kernel.org/r/aVrUDeSkqqY9ZCtS@shell.armlinux.org.uk.

