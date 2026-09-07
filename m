Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73090C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780B76B009D; Mon,  7 Sep 2026 04:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7585B6B009E; Mon,  7 Sep 2026 04:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6474D6B009F; Mon,  7 Sep 2026 04:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD826B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:06:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BACA340680
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:06:36 +0000 (UTC)
X-FDA: 85186234392.06.AB57D6F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id B4CC240008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:06:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vX9YEFxm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLneHqp9CVXxFhIny9FEzIvHWoE/SpJ3/9kxBNrJ/tc=;
	b=hJS9XhvDnGqdelUC6rZ2c9JJjkU9KwpS6t1PHnZDyC4iJxtFmDW+c2/yoRx0hl2zckD0Qc
	LGnwG2zWClpY3QNo3QmmZEC1kzoqi4fFBFGLsZzXQE43L/1Zi6qvk3FnP4nXfyNnUitwct
	nF/mnLa7CuVrEKMobYQ+XEfB7WROVBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768395;
	b=ioitzw8zsvLuK9mqaayMkUnyibxlefUaVwvk3eqqZHyYLqXOXls1YOI8UkLGfDeBaxXp4F
	xS7vnKX3t67lcUTggyCdalPvV598qZhB3IO08zHF4In8jhWmgvWkU0CvUbaClj19twEb6A
	/owZ3Q8/5ILMDGAAF1/6+n3RIybr6aY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vX9YEFxm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB1BC1477;
	Mon,  7 Sep 2026 01:06:29 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18C753F7D8;
	Mon,  7 Sep 2026 01:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788768393; bh=M02Zz7duqtLH9w5WcLt9dmTeIbG6UdWlqLh0VhnRN2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vX9YEFxmN++GHfkO2xxc2HRCAVQZnfcF+y1vVz4p+I67mwn/6aHZjc3V5wQk92028
	 QjFA4Ff9sydSH7mdW6Ml8i/iDQuE/cqvG/ChPtrzIxW16rDWLljleu6TZ5iGFYY1Y2
	 dWFeU1IDBLwdUjSKvUI2sIAZ7djSAJVGofJYXeo8=
Date: Mon, 7 Sep 2026 09:06:24 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dave Hansen <dave.hansen@intel.com>
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
Subject: Re: [PATCH RFC v3 13/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
Message-ID: <ap5wgC-J6Byt7nPS@e129823.arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
 <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
 <8f3979a9-238a-4d7d-a040-6aa526fedec5@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f3979a9-238a-4d7d-a040-6aa526fedec5@intel.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4CC240008
X-Stat-Signature: 9dutzgbaw8frez67s5gf1jhisib3fmdd
X-Rspam-User: 
X-HE-Tag: 1788768394-230000
X-HE-Meta: U2FsdGVkX1/Mg/0Vl8b4qkQwGbOqbRvorq0iB3BiwSpa+nuzUWGcMp+YBss1a/N+DYdcDiduInWSuaAs6x2mNmdZQjMb/Z5VmWMa9vvL+ZgXYmhl1sYpC0xIR5phAwpf7rp3OikY7A+G17iTagIjzUknFn5Oy+xhpbQ5ibSZR5C9raYs22ucrmN4SvIYJk8rL7OWuTUagnGCq/UpBLkAmQyYd2b1Ne39Gr/zzIv4wnnV7RYzKqHuVUfnAfOozr5bnj/s2JqFCTMVPYKlA4YsPpM8Qt6rBeumV/3ixgDt2shBy/g7FTpFV3F9SDkCOvHTsKg3Giu8KAYJUJS+Vjlrmf34VTAn02h9xkPUagA4deggnwbC42NL8dWFzHzZCGAH+B3r/VY7q8rVJ3GEzmpZZ5b9ZIeFg1eRem8xVDc2Xsnefk3GSRkH2A/dlVMGsr48SlqRGqzwYMakX7NdwJDlycONVDbFBRKd94jZvjiUApXmlyy2qy5YdNRUhncWmWNAebbQ7njPYma2jCfgxiXMCSQH4IMPc+lKyNPR8H04uAmvxqW7sbdHlzGt9j8WP8TEpg+24xqplXOidfUe4dvkkUzGvy/Lnyut0Hda3JpRsnWqmOJYyHJ5/CBrqcgeI6MTah/S+RE9XS3QF9PlW88lSbwdw/7I/pTnt5xVC3eXTABwJGmBbakI2K0wOXR2FwgL4soVtKCdIPPS0kGpARn/8J9nIw0Y8GoI6jO45/x8aiaKc+pzjyaz5gvT8SK4K/KMj99+8LXa75t5uLokaFeqM5vDy+hYhXZr4P2WXUISMFQakIUoIIuTZnFKJsX+Rov1JwoZ83dJu5Q8SzGWP7YJ/2AAO7plWjV3wxhYq7no4Pi5+vB2gAu1QFEb56FcI80Sc0WXe2R4qyA64r1Zd++SV8hmXY2OaRGbGrjN/wwl1cbiJhMZH4wJGHlxOL/wn7OzoGl+hw5+C5dcijGeJ1J
 fVq2qzZS
 O8GPsFEOcVAyaFoUXBbrihPS9LBWi3KgpgCHMyywlEmH6G3tN5S7mqokjYhQVogmUYxXNDIHH9D2srmHj7RjYp8u6l0b5WamNkl7FRJ9jXW7DbqZO/D1JrLee56TLCj+bMuwbu9tbkWukg3BAN/pnG8UcnWIH702KWN3PtUj2CQijZUPLTeNfo7kNspoOl+CoVSNJnKbHJGeioq2PTp+clHHFwzXroSundsUUShbdDHSRbbHIQHrWs+G0S2ujg/0toYBZ4f+/ZkbWPZfLhx+a4hxTJpwmmQSN1pfkIPES1FauXxiz4TVVcRQsfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 01:48:03PM -0700, Dave Hansen wrote:
> On 9/2/26 04:56, Yeoreum Yun wrote:
> > Instead of using hard-coded integer in effective_prot_pXd(), use
> > pgtable level enum.
> 
> Does this actually *do* anything? ;)
> 
> I guess it's nice to have a wee bit of type safety from the enum and it
> means that you don't have to *know* which level number a PUD is, for
> example.
> 
> Either way:
> 
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Thanks!

-- 
Sincerely,
Yeoreum Yun

