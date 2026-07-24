Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7EDCC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 11:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B0A6B008C; Fri, 24 Jul 2026 07:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC5A6B0092; Fri, 24 Jul 2026 07:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484A66B0095; Fri, 24 Jul 2026 07:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DED56B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:50:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 999D31A01E3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:50:03 +0000 (UTC)
X-FDA: 85023501486.14.00C1B64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90DF514000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:50:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=onlJqJS2;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784893802;
	b=4BEh6ikuyHrZXmVFkee+6LSB/vBUBaFETx/PGwXj8zDUn33Xw55tykj5xKs0v2s/p5d/aM
	DYhFCH8ciDkLEmZMzsDN6IfYqvNjgmrvddIGkiHypZHWmFF62BNPlOCbZC1cCoiB98sMS0
	sHP+04QC6Lc0e3xYCvkZN4g/bTPnScM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=onlJqJS2;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784893802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYg0AW0zpayy1BdimbaTwLDMmNSvtbTMeBCTOdhagAQ=;
	b=C9+PfQTuYmuKybMIiUYZVdUqZZ3KNfE5p2RgUcdeBUqxq0LrapaT+5XqjsLUY4JzvWDVPl
	m5pp3EONq78Rdl3i0G5k8twO+BFgThfbvQ1AdRrcwCWcRuG7L9R7uK+aFF9UMr/rv+nzUB
	OL2oKHHzoQxANEnvz5N3ZWH3yx+Alh8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA1941477;
	Fri, 24 Jul 2026 04:49:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F2463F59E;
	Fri, 24 Jul 2026 04:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784893799; bh=lSGi/T62Qz3zkTtfJoxDSfari9OyrmBQakjPywG4Wwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=onlJqJS22YoDsKaG6SiKSkuKsNv+WmGR0K4ecfdNyqZf1u/+3JEGvSxKfGGrvm5nJ
	 MXCh4HNavE1AO8qDTOoQLnL6W10waJKQJvwWm9dJxKiy7ypA0biilE7i0COMFUcgAZ
	 cBx7VbhxE8imKHXZsbg7suIUPJzdyNKYFStD+n4k=
Date: Fri, 24 Jul 2026 12:49:45 +0100
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
Subject: Re: [PATCH RFC v2 14/20] x86: mm: skip pud setup when using generic
 compile-time folded pagetable
Message-ID: <amNRWR-8BCBNU0sR@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-14-d9e4bad31e0a@arm.com>
 <0ea931f1-4801-4d32-b6ce-4787a8d3daa9@intel.com>
 <amD7ab_KuJPdBQBh@e129823.arm.com>
 <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com>
 <amElnEbvRTjv2hyU@e129823.arm.com>
 <3620750c-54d7-45a0-b067-bc813dd3cd9b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3620750c-54d7-45a0-b067-bc813dd3cd9b@intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 90DF514000B
X-Stat-Signature: doff7rhwf9qqkf361nxspsrmk1y8jdmt
X-Rspam-User: 
X-HE-Tag: 1784893801-866215
X-HE-Meta: U2FsdGVkX18LS41QHM4pmOpyihMhVz5xfsMYIlmC+p7MdbNYnXtbkKLkfBmIGiRWnM1EAHdrvJ0pqUcZkU7nnH0zJP+/yohobPFOyfknEUPQlLs8HDJtzT1xqpwizG+QIA+s8gh11fx6UZfklTtmzdBTbk6b8Tzs20Q7X5x3tq/S5dokGRi3LvGuxk+wr7z13zI5t9BGQYl2uLGIUS5kL4925kb5iE9N1fx4rWEOLdTuNn36R+WEBXEgJITUwAoWI1qW4scfAlND9hk1cyWuECSDY+Uba7+yqdsgWjTcP6UzuKg0oYumAD1ayTUAi7vIQA9WOAcWX6PRaDgydcwoDpKMtipwnvoIqcix5gA6kYqqJvNBNNPxF0R5TjAIh/anXdWRR4dElMWX/IcM8Ygq81I4nwgyRXNKU+pUOqEEipetQKo152+Eot44COpnTZDgF4GF0e2iiSgM0Anpx3UwV8XBpjvlAYeZg1lVZ0jJinBIK+3xge8q6lBPENQgtzYchugkhp4Kz8nxILeUqXCgFrKts9N2+2jF/KGTmw0cPOhFw5DPo+UF93OuphZQte2S58FTXjRgctL/nSU8yskx+nfjm20g1vNRZJVhIe4WaJeeu8kEIdzr3U4gE7rVQtT0sDrjsZRTXlAvNWOZJWkWDHcAzVzZ05vdAe9DY00Dhn1nimoV1M2g5vEqKCtoekee/kuI+dfnh33wzhcaghSWSEmsPSJsY4PTcEA0visUQbhvxDYkG1P4lXIfy74FjGmZ/CMfc3aZ2L79LarH30ck1CEX/UNNBwrHtaw6bvogoKLAvhQbI37v6SY5vNaxRLxSPN7qGRd3j8h3bOVN3COwnQG+TsxW59FY05ogSrQKS0tOFg4u+4Y+/r9iZyBonH+dEzpdDiO0clns56xeFyJgFoubCg1MPO9LVuvKFlOEoxpNxo+Ni90s90JboDhky9R1sjOWya8V08VnAAN+ZuR
 nC0Xr/8I
 WBaJpazwzGYbbnGgsGZG+63kjeucSTE9ucXCfVrGuzp1mmRbVjeU9S7JR5OcC3Tz+x8lKwQ8VJmcmn9z2XeI5ZygBw9j1dneTnC2ci6E26Ifh/Y1CeAfRZVJ8u5Kx6QfKaqc0iP5jsbTceQdv/W3ybacOlfaRcye4YuFeiKaHUBE/A7FKaeMUB+cCsLM/6egcK+M7RtKjJDe1TnPFIlG02VubrzhKg5J2qPGcPfzLoyfJhus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 01:22:04PM -0700, Dave Hansen wrote:
> On 7/22/26 13:18, Yeoreum Yun wrote:
> > Sorry. But do you mean check with cpu_feature_enabled() not with
> > boot_cpu_has()?
> > IIRC, the boot_cpu_has() doesn't use the DISABLE_MASK_BIT_SET() but
> > uses REQUIRED_MASK_BIT_SET() and I don't expect it wouldn't make
> > an optimisation to constant check which is contrast to DISABLE_MASK_BIT_SET().
> 
> Ahh, yes. I forgot about that nuance! Moving to cpu_feature_enabled()
> would be great!

When I see again, using cpu_feature_enabled(), this would give a chance
to optimisation when the feature disabled and there would be no harm for
when feature enabled since cpu_feature_enabbled() also fallback to
boot_cpu_has().

So, it might be good to change with cpu_feature_enabled() as we
discussed.

@Dave, Should I send above change separately or include it in this patch?

-- 
Sincerely,
Yeoreum Yun

