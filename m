Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696E4C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2FB6B00AE; Wed, 22 Jul 2026 16:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D906B00B0; Wed, 22 Jul 2026 16:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4159E6B00B1; Wed, 22 Jul 2026 16:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 153776B00AE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:40:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 901DC12025D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:40:54 +0000 (UTC)
X-FDA: 85017581628.14.4B7D763
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CE4F6A000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:40:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u905XyTg;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784752853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKBipMgFuCrzcHQyl/Xa43Q9KRF4LHRa/xmzRHuI4is=;
	b=wT8qM97IXefBMkZa5unGwrDYJPYb4HuBKl7ChkeDtrJMNghkZ+Nk4w5ynev0n1CUrOoCWz
	a1GyJGGR+hzce1dt7lzRXJmMcLaCpWoduaSy/dAv7GljHjFlaVHhjfOhFB5CjZuWx1cBep
	1doc8VCWQHLvmmMgUCz421xR/2jBYSw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784752853;
	b=QlgP7lOvL3YjutKKAk+jDWC3/PAcrHL2mjdGTN9CZ6HumaMHn0wDMd7xJL4SAAH+YC7Nuj
	W8V1NAV8hIRAV8dagNLMwZKbdUHkf9j9+KP/JCDe7v5SJo5YDPrzzfssFg9kb3fgtB6J+H
	W5InCR4KaU+10CdlKqVVmIWdP/JZcLM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=u905XyTg;
	spf=pass (imf25.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A41A51595;
	Wed, 22 Jul 2026 13:40:47 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AED0A3F59E;
	Wed, 22 Jul 2026 13:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784752851; bh=MW7m2jjynF2iry9O2w1L4Qc+wiQ9bjVZq6XG6lr4jCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u905XyTg55ekAxzZmoFPwtPfxi5ZSTHzMYONIJRUH3y3Fm3Ceef193xeIS/KNVet8
	 yxQtUrz5r9bnDKhbmP7Q6WsDlqh8n+se4+8VEFwxrwJi+9h/I/UO3XVjm15kHRCI43
	 GxZw79GmfpaXJMh5WlC6vJc6NU4kBvXcntwV3zC8=
Date: Wed, 22 Jul 2026 21:40:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
	Russell King <linux@armlinux.org.uk>,
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
Message-ID: <amEqyjdoUnD5lYev@e129823.arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
 <20260722-dummy_ptxp3-v2-14-d9e4bad31e0a@arm.com>
 <0ea931f1-4801-4d32-b6ce-4787a8d3daa9@intel.com>
 <amD7ab_KuJPdBQBh@e129823.arm.com>
 <6f5060a7-0a64-49fc-81a3-ae88729ef794@intel.com>
 <amElnEbvRTjv2hyU@e129823.arm.com>
 <3620750c-54d7-45a0-b067-bc813dd3cd9b@intel.com>
 <1064CF47-9371-4D9C-B2AD-1457CA41CDB2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1064CF47-9371-4D9C-B2AD-1457CA41CDB2@zytor.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE4F6A000C
X-Stat-Signature: sxrrfcpcn8bwm7yzjn93gg5gmgtgccst
X-Rspam-User: 
X-HE-Tag: 1784752852-96759
X-HE-Meta: U2FsdGVkX1/tRHD91/T2eZxS5Jws2hE2gM5Mo/BAWdHKnwwtRMOPjwfgPfQUNo1mwnaHcCjjrjoFNqpfzvvsAt+gIxnLR8F5r9JEgQ+bjolDPAIZ+yqmauvA0hhKsQ3dYYMoAkWvLltMhFbaRiig2S+jythqVJ4tfKDrzPiQg8rtgnAI6p0Rc6ES29mNYAHC6gFLBWyqRWRxdSkWExWL1CAIfkVilcdtEzDtx+ehfzPGo1TaAp57WJh+LW6GswOaPTkKFV0SFSld8Y6FWSG4T4aK5w66nh4bXRPfmkj1lo0X1qAL4QarDrNlDUg5tcqQIgi4y0q7IQL6W/45g68fykVWW5m66uJ8ahOdh6uwV94NDOwgR1CB6wJ8dhPoCcx9rHUBKTa3M/lfcH3adNLF+J9T88bII6ADaoWeruRKnt4Swul2r29kzarFzRVKOpHF5xYTkiUVnzlqyEtXWsminc0wfSIfipVbTNUqx3sTRSfwZFxESaLhgAJBPCm1LrBEaAIYkbhBqlUE9R9QVSphxHNvgHrUOhVwprFSgpEhmAhYvGMwb3gMdmjbZHxkDIhjCM/FYh9G0Q4jVMjkhCy7hN4b36bmCQ4nDxnFsEwhtul1RtVvanrnIL0BXL9ZA0IpgTN13AKIzYgs7YnDNebgjOsJpLEWMINI0UTMhR+mfzzOJaKwBae6+rwyH8I3sj3+TxiF31xsht/pVDMcSZHgnvIgc4P5E0m7TnpKAvAK74JMvB+yu4tk46TwvsYcfexK9+8413Oxf26lLGyznMX5wD2O4+johj+XDpl18LDC2c/FKygiiFb791BpiHVdDRWDh6DQJIvS/hXV+i+b4G83P92mAHkpV8h4kDq6sKhBkRx16rQD5USzrqY2MQTDWHIfuGDw5ssId9Av7UcNyBQ+Ll6T0ng6EPkE/xiGwZFy8dmC8pQCr+cxM76o14d9AOSNlCVzyLFE7fC3j6INpg7
 DAT6Iqjb
 VZlIPpubYO9IVq0u1uP+x2yWvoPbN035mKspuCkTZYqD2CjV0IdqmbMGPdZ/koLCq0SN1p4pwJuELDpdA72Gfy7osTKPV6gdnj4FR94VjP7wPf4dSQojEJxxRk+RK7vqJnFk5TLLxh/HpSfiUSVl0ACUXfSwq3Rt+Z4QLhhTHBgwFGIXFOWUFSBKko3YmHQlj3nJ938KGX5xUtetwwym2W/wKCRVY/hNQB0ItjiB2Ol/w7wwVxtairZQGcrzO29fWcrmb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 01:28:40PM -0700, H. Peter Anvin wrote:
> On July 22, 2026 1:22:04 PM PDT, Dave Hansen <dave.hansen@intel.com> wrote:
> >On 7/22/26 13:18, Yeoreum Yun wrote:
> >> Sorry. But do you mean check with cpu_feature_enabled() not with
> >> boot_cpu_has()?
> >> IIRC, the boot_cpu_has() doesn't use the DISABLE_MASK_BIT_SET() but
> >> uses REQUIRED_MASK_BIT_SET() and I don't expect it wouldn't make
> >> an optimisation to constant check which is contrast to DISABLE_MASK_BIT_SET().
> >
> >Ahh, yes. I forgot about that nuance! Moving to cpu_feature_enabled()
> >would be great!
> 
> It is supposed to. That's the point of the required mask.

Sorry, IIUC if the X86_DIRECT_GBPAGES is not enabled, it would fallback
to test_cpu_cap() which wouldn't be optimised at compile time IIUC.
So It would be better to use cpu_feature_enabled().

Am I missing something?

-- 
Sincerely,
Yeoreum Yun

