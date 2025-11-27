Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7144ECFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 04:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F0A6B0010; Wed, 26 Nov 2025 23:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F536B0012; Wed, 26 Nov 2025 23:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5453B6B0022; Wed, 26 Nov 2025 23:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 42DFC6B0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:09:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF9DC1A08F1
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:09:47 +0000 (UTC)
X-FDA: 84155058414.18.3A21CE4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12A90180007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:09:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AP3I5dIw;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764216586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UH5HZWU7w1Qz5ka8h7XjqhmojO13fL0L+YMlTFhSDA=;
	b=BsgQ0fFT6Y24LvaPOpqjEc2hqziSUQKfDprHqtMl/rbN2oGApTSAv2Ev9n1Yye5cCsHzde
	Topm/a0fUuIvASFwuvW+pyCCnzV76dCcwQdvNpbpk45KLaOrJX16MnOuALoN5Bkw8zQwhP
	1ayU5r6DRFeqYcclyVWzIsuEkyL8QdI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AP3I5dIw;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764216586; a=rsa-sha256;
	cv=none;
	b=Yzkg6H4I6awcfrRmZZrPs2jh+tftr+wZXtblGpOs/PYcZ7z0GVd5thQ2pUkpdV2QvbfXXx
	xZ2nbSgI2WrkqDwrbDoMSlfsHjlB87/TO/jDLR9Fy3E0XII6kAGYFxz9BLu54mHiTSOkgn
	RpELcM0USBtweGKdmnM2de/eqyMFcss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9UH5HZWU7w1Qz5ka8h7XjqhmojO13fL0L+YMlTFhSDA=; b=AP3I5dIw8MUlt7xSzk3qgcc3sN
	AHu26Cs0wtwdgwSRwY+BmvEPRpHfoPjKAv6EqeaGAtEZ8MvH02yG8ScNHL7P49Rb/gM+u6ij5a6XG
	jy4hg3/q6KDo+jTVMSPbxO9fXKm9iGjW+uF8fMcq7GPSByWP3cICDpktaeP3bee4XCg1AvMMv/Moj
	YSEuEpY6zqKoGrYyt7uU+flpdycrYQcResJLx8oQU2IoaQaPpPfiBo/O1co/fExGrf5J1lFda0oK/
	nNuM2+NAvUP42wEG8HkfVsWnCKASM8uniovBmROKgYy8568Nvncst6z24djS+35maVgZIA3CoAYDO
	v2Mud80A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOTJl-0000000BB6Z-3S6J;
	Thu, 27 Nov 2025 04:09:17 +0000
Date: Thu, 27 Nov 2025 04:09:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	Barry Song <v-songbaohua@oppo.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Oven Liyang <liyangouwen1@oppo.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Nam Cao <namcao@linutronix.de>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
Message-ID: <aSfO7fA-04SBtTug@casper.infradead.org>
References: <20251127011438.6918-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127011438.6918-1-21cnbao@gmail.com>
X-Stat-Signature: 8y9t88m7wy4u7phii169bb7b3xqbxja3
X-Rspam-User: 
X-Rspamd-Queue-Id: 12A90180007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764216584-5294
X-HE-Meta: U2FsdGVkX1+pe0ammUSB8hdCT/Z/2pmieb7NmfVyui/+Y1OQ7C7DemifKBNslJYKtMpkis6LGjICGeRx0fQT67GBrK9YtGjU85KDxSV6S0PYCxRIUE2FRR0vNHkRQB/xb2TShj2Sk0Kt6rfo+DC4rZV4pQDF0HW5GnWlbzmpRvN1BFRWYfCG8RzGrOQbi5o1Qu1+kaG9rGRbnozdFL84V7/xiXwyyjzv2NHAPk3wwvtCCOuc9cI69c5tREX8DeDWzSMnkbV9wfA/t6NcMZvaDqFCTz9c4Y5B9jEOT9YudKnJlWIKnbqOxptfCgtbjDNf2Tjy+b5wjPe+osRp/AlsOjTiPcjBOirgqI2j+htSHkoZmjbwHNplQOn7D22KdDMaJ4T7uiIA9p6cf5owxrx907bAJUqHKS1dxRN5UE0mO9kJD3WY3ZVwQ/QzS6XGTB2QeSygj/sQZz+Oc7giVDGhZIbDDt39rsKqmfmb4YnIBmTRw9SjCMjhkDr+2CBnC2kKYF5+GiCLXIEtQOmFpZHrbrCj1cNR+dUd+ZKaNAOEUUgdQ4LRk+E409QoBOxdubKKoWKOfIZLyjleyT5Yen8GHO2y/+eKd/MagEbp8UNk5LIhPSqrHyKZIzSV+5S5iVBEkNEehlwyoq9mnFBq+IGuHtU7njuv53dVWC2VwRkxsxYm092cUV3EYJKlJwDs1fzRl90ilibCoBsXgHDqK5ob+S1kepoalWs3txz4cgsWPKhrPI0K4x5i0NZQ8JxmZa1JJzAv5tkJXWrf3n57Ea1PuHujwiOmCMJlqelibABG64Kw7mTu5t0qiDAxj3IdCdiwIDjnyopazQB/hONk3l+8luENkib0MS83IM5YlM35QGT4cwPRFQ1dv7hVsZY08IScOHtrQNv3fO9VV1hvZsiDC9a6h4tJOGvExIffmsVAFcDCjk5VaEXDpxtbzSjxRYYJ7MBJUJVNJ3N+cbKixo7
 UJJWa7cP
 O96R8XiO3l1NSFRwXUANF5Kb7ZTD3YCQsTvb7J/Pru8DHWQElAZuI4qIAmcPxks0JTXNK9uxTuWPJuCcL3TK4AHf5RLHoGX1P2VfyLFEbLrv1vc2rVqqnIWANNQRASVNa2lLEXMgzmrkv4SDzd5szgFhp2fDqR3dt/ZtSpOqagno7Xdjey5fxhvwmi5o1/hwiRJijI2j/9fZUNraq4sX+I/MMD0PKzQNSVI1typQ6V/a1+cyFcrXPgGHpBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> There is no need to always fall back to mmap_lock if the per-VMA
> lock was released only to wait for pagecache or swapcache to
> become ready.

Something I've been wondering about is removing all the "drop the MM
locks while we wait for I/O" gunk.  It's a nice amount of code removed:

 include/linux/pagemap.h |  8 +---
 mm/filemap.c            | 98 ++++++++++++-------------------------------------
 mm/internal.h           | 21 -----------
 mm/memory.c             | 13 +------
 mm/shmem.c              |  6 ---
 5 files changed, 27 insertions(+), 119 deletions(-)

and I'm not sure we still need to do it with per-VMA locks.  What I
have here doesn't boot and I ran out of time to debug it.

