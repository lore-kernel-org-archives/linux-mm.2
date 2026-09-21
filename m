Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC481C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63AAE6B008A; Mon, 21 Sep 2026 16:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBCD6B0092; Mon, 21 Sep 2026 16:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2A76B0093; Mon, 21 Sep 2026 16:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22E6B6B008A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:26:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C852120257
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:26:52 +0000 (UTC)
X-FDA: 85238903064.25.E764120
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id B215B1C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:26:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZJQgJ1u3;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790022411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKlHwbT8ASwRLPex8E1OY2M9CVTtEmrdoC0xdX0PqgM=;
	b=UelgkdoFNxE1l+GHTRXNzYvqo1NIPibBsAjqbPA5sIwjFYqdCQMqJjB88GoR9JiS0j+nGN
	Zd2lf8b1pYFLA1iaMB/5eojy4cheFnJlQgA3TFEUauD3ksRlGpopCeqoYV6K4vJP3K+8fW
	Jhz5bJa4lojirmlQFv0SgRwT0I8QH70=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZJQgJ1u3;
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790022411;
	b=tLmn80KmifJpl5u4QwphPU/BJCoAGIKbSYSC4n4jQpPZR2rYPWJxiO/KVTjEhL5FX8snpo
	PCaq2RtWh+HqgvbMyEV2bQyhRyRf9Urk58P+Fp8/6gQ43DcNjqLqGRRagY+z1Gd30sEE4C
	7rAfdcdNXK4d7+LWf80IBF0hrjmRBDA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E89C5176C;
	Mon, 21 Sep 2026 13:26:45 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19DCC3F632;
	Mon, 21 Sep 2026 13:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790022409; bh=YR8KjfryI7McmdGWbe5RjCYF03qe877YQVcwQ4evUyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJQgJ1u3+XbrE14CRndMnlfvZodRjo8Owgd4VUfyb4ysv/TCeswI4E1slRGuH0ZC5
	 gEB41b7eQMFvIpiPafng381AyyipSmuL+EUBfZkrewzD7VQyDMaw6gvMc8JJ8U+oLq
	 2RkB+DvgV9b00Ftlc/0AMEXk2kIo1XjoleH7ftTk=
Date: Mon, 21 Sep 2026 21:26:40 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Randy Dunlap <rdunlap@infradead.org>
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH 21/21] Documentation: mm: clarify behaviour of
 compile-time folded page tables
Message-ID: <arGTAMyNaJVjKiuC@e129823.arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
 <20260921-dummy_ptxp3-v1-21-cd40cf68242e@arm.com>
 <c0c67459-6b75-4bcd-b068-3752e23afbf6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0c67459-6b75-4bcd-b068-3752e23afbf6@infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B215B1C0003
X-Stat-Signature: 4m835oozne5mkewrxkri3n1qzkahu6js
X-Rspam-User: 
X-HE-Tag: 1790022410-763838
X-HE-Meta: U2FsdGVkX1/sEuLvlL/qd7mUZUwXh+jOsJWzXYptyw9DAQ/p13abld64d2VfzyOX4FDKiFbyFqN9C48Wz5oazxV3AKFAG9rnnQRFlz8ubJ97k9fy9ClGu/m3VdXHu0kbXBgPdhst29WcLEgrEl93nBn/M/RaQc9ycaioIKRHqhO+oSe8KPOVCIJIUDdPQUv3g246aN7zB5v9k2nrydjp9MoQ7H1siero9s3gz/nmmVCPt4ciNf6r5rBG90VtC9KMwS75g22w9X9J16kHq+1TNWZeahtYamLNCFB5Y1c+79gNK9kijqTDNOCG6maxMJug9c7HPRMJ+lGPqpS+m/cQiMk7rHUUURIZPg+1KE8qP7fnA3VQlZodbCwu9rVpHAFADJPKCTo2+J4ShcpkvHF/MPTFS7eqKdxhRlfM4PrxISfpKcL6vSqOoxJgHl/+1JL6ZdV/QUunl1OLLozFJKkUCB/eDsHu43Msoj5cabs8/gEbUVoRaZNIiJZX4ZC7m2I7JYLPuSghjHYjDPFArgct+o8f/5iCYnV5dtXLoMsPC4Cp4Ku804SIJWXlzuiC287GdN8BCg06EpoaWk0Zbr3VdOGbFjI6FtckRs4JX56Z1tYL0ZlesuAezYObBo2m/khBMKGG80sqoMqRJh7/e+S+h6DxJoSyZui52Qhgrivpta8L46DTwdmDJfiydwEoEnxgkVBobHz1Ieq1XGeqrnKi6WgVNiLvgtwxHK7iOoD2GwpTcUYmUDwH+NnUJxQT1vuEo1WGzDJjKqHo2Ze27hJHDi+xZEE8qWYc4BtpwD3ArtB0pJrnagtugS1O10aeV2EYhLX7VT9aWsg9jm44Kt+fXHR2q98EabVfTDSagu5l4ymmQo1WGOBDN3/RNaG/QoZoCJUaZX/ou05kgPQ9870T7Xjao3HIjs5oG4ar4/cIxbL6NS/jP9Kl5V8Qb+SiORjfBNv1p/b9aut8oLhrqKA
 P/rF72Ol
 aBrTTo84fI0NddaW7b2y4i+k5u6dDPucvfSAcMMh3N5pTO6flsv9HKXsMr9jqBEy3L9giDsNHPt6OX7KYs+H04+IQQpOCgtGx9iHHIv+hpw75+RO6RirIZL1mrKRwA1ux4ttu8nSV/VbzieKuLrFroNjHTUnZ1C2rvRBSosWdOY0519s1JOkG8sSj0J+rMrJ5IFRI1hS6cGyjh1o6AoqMgc/fz9Ue6qjq0RMJq2Q+HlB+YxMbV25Z8+ZVuRSwjn9wL/zF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Randy,

> 
> 
> On 9/21/26 3:55 AM, Yeoreum Yun wrote:
> > From: "David Hildenbrand (Arm)" <david@kernel.org>
> > 
> > Compile-time folded page tables are not necessarily easy to understand, and even
> > people the were once familiar with the concept might need to refresh their memory.
> > 
> > Add proper documentation, including a nice diagram, for the current design.
> > Mention details about dummy functions, including the recently changed pXdp_get()
> > helpers.
> > 
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Documentation/mm/page_tables.rst:197: WARNING: Bullet list ends without a blank line; unexpected unindent. [docutils]
> 
> See below for a fix.

[...]

> > +Note that the arrows from PGD to NOP4D represent page-table-walker
> > +transitions, not pointers stored in the pgd entries.
> > +
> > +Using p4d as an example, `nop4d`/`p4d folded` translates to the following:
> > +
> > +- p4d is considered folded into pgd; both are operating on the same page
> > + table.
> 
>      table.
> (add one more prefix space to align the indentation)
> 

Thanks! I'll fix it!

[...]
-- 
Sincerely,
Yeoreum Yun

