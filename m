Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B690C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB7D6B0095; Tue, 21 Jul 2026 14:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2F66B0096; Tue, 21 Jul 2026 14:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38B66B0098; Tue, 21 Jul 2026 14:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C53916B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:30:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C3F4A0263
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:30:41 +0000 (UTC)
X-FDA: 85013624682.18.61177FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 914254000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:30:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ByYK4o3C;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784658639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zO9yiMTAazx5bwGvEvIyBcvPS46sW+B44wcbxVnE5g=;
	b=naXmpiI5oNcWrftPVYYPlc4hDNHi8zDVAuu3qdsvL3HwWvhCUJ5CX4L8DQU2NgxEtyjJPu
	94Q9cGLeFoecpZZvWKMs1ICHretZOKnGNObpu4qU8k4ulKAibwoTyv3zEkVpG44KV64Dt6
	bDsdt4jBU5Zx/KybEY7JAaxfWzTQXZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784658639;
	b=DuqbCqxCqLQvB34T+/0CVg0aoIJBmJwDBBIpihzvKZxt2qBIHOvsa/GGOXnBhUuDXnsOMu
	y2BSzAbgkx/KTjpdh6rXTgorOpDUVxjGt/c90Fc5O16DoftHXL50Pk6MoOCCvT+/L5y6bh
	SYZZQN+mGskGHbwmA7CDOwykf7/feJk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ByYK4o3C;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBE0360103;
	Tue, 21 Jul 2026 18:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0DE1F00A3A;
	Tue, 21 Jul 2026 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658638;
	bh=9zO9yiMTAazx5bwGvEvIyBcvPS46sW+B44wcbxVnE5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ByYK4o3Cka+hTsFRrAZAJRNYhFGvW7e38UptX/Hs7lUB1boZoKI/JB79A96h/sJlt
	 YKqi6ru/0HEtyn5K1g1fKFvrrOvAs55HrxyU1PfQKIYMBQpvNRutYSbErst/xzLFT2
	 5geUT2eCxPXWhMAI7fAevDyJeTIGeFMK22SP/rV56hOgG5rIOPcfSZnBK8/yramW/9
	 5j646seiC6BJN7K+hbtAwOp0ZDuR1NSGUi+9LNhopPTljgCIcz8FIMem/5jmuNKlHz
	 M1MQRG8RBAEZdihKmF6FW6rAvGtDzXs9xOhBrO2BggxJWR7HuxG3+1Sm2YW2C5sGbx
	 a0g4ar95F9w/A==
Date: Tue, 21 Jul 2026 21:30:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on
 debug_pagealloc_enabled()
Message-ID: <al-6woCPBH5d-lwP@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721-generic-set-memory-v0-1-v1-1-2c1fc62306b3@kernel.org>
 <al-oTOKY7vkdPHr5@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al-oTOKY7vkdPHr5@lucifer>
X-Stat-Signature: qkoyp8prxrx83ngamo5438fx4kdc7174
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 914254000E
X-HE-Tag: 1784658639-655363
X-HE-Meta: U2FsdGVkX19eKICpcGvSC11L5+CfGlPMTHfl3VPAQlv5ZqPtDnaCC+s/a1E/mDa3RqEEd3zMu6qFo9y691wG14rogOPnVfvN/kSTsK9tAQu9lQBSYdZS4jAjEfkUVQsGowN+8TLpUcTzUvrlfVRfPURVs44kJa/3mkuAcbdYwf6MU2kZTi61Fgi0zm/NLT+bKWIfbzJOTmSgJMpEHsFxEdjy33KM0RVVjv+7dkPO2jLx8Htt1uA6Tg6uZsz1qdVSOpvG1u9c48Gpy/PQldpkCaQUz+hsi0oI0plO07QiTB95kmjKE4ego4wR7UxGCGeB1y59vZDFd2ADosrCxt41xQlnQsIM1zXPBHFvIaOLGrp4I6V8kM3lco16HHCZJeC5ReTc7xIw/g3EbllXQ8niKl1z4EdcXh40yAfmToqrj7xCqSDISvoLv4UZMWwM8vNQf2x7ETbFPFvEqJeb5tyrJGUwwK9HGZpz0AY3OMS6J7GX7Zd7ob54R1NzCZNt7qjo1fAMWrHHEXO3uigXY9MQ1XtA4Y5eX7U02p3/YmO8zNdLAk2ufp5GaRixSLT2nVzN+zRB95oby+DdxbW5dSAHhgHbHDilA+6Etuil7K5l1dXTWVb8f6sYwO4CtX7WM5fd/agu3bTrnAYuhYE0d7JCyY3CpdpvQPDNvX7H7LrSmwCI2Sq3w7aR/1kjkCACKuJQHiQ20uPVF5ro7eqbbrofrER6AIVX9eazIOiVgC4qiTnx4YIgaS8DzVxY8plt/hDiCRfszsFH75ldyieiP0GyT2TQlu+kDpZGeivQpMPJdI4qKN3c8S478AtNZH/Ptc3daq+nwlYb+kxZyZAzIrpHRDtPMwtKPVxisNFOKf6dsh0hmJZ7CXZFvi8/JMDglvoTyw+1Hjm0yGWwGya1MOX3XnexSg5VMg1Qk5qd4/AMfmg9UCHFeCATITsjo3UTOdHhiHBVs84EaH/dC7D3SZO
 6+o2rdc0
 HA4e1Nw/2JOzMgyTe7m2wEUfSMU/YakjZDorCipdPVgTYtUy5V+o1j0VmPxcMRzp2W+dQT24jB0+CbS6n9FCSVFatDUWBRclQTRMtZgzpyCpjOh9HTdaTBWbyJB9E/s8ypqgWRqVVRnWIljRdFpiUoWgS7v1A9+OH2UHDNnTkrWI4CndBj3K+3GGYeUToZU8iM6jKep91qeJCV/I+Ks+Q5NXQ7eR9n7ststkyoySiNo6rkJ+1SpcmUXBqK6/scMTI4fMY23Tz0JcXP3VasptHHRGTlS855sD3MWyM96Q7XXF4pgmt6D+6sxtC1EZjINbrooCr3+oztamiW5W9mxPzQ52LBaMyGb+HQZ7ulInS5UDAa+F4mNK5oD+XckXO7vC4MT+P62Nua2GWIDd7BnIopeFtB/vI74bfgWKiu+7bh2MhZfggCkfxrF7lyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 06:16:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 21, 2026 at 07:23:24PM +0300, Mike Rapoport (Microsoft) wrote:
> > The splitting and merging of kernel page table mappings between small and
> > large is protected by cpa_lock. The merging is relatively new but the
> > splitting is ancient.
> >
> > The splitting has a locking optimization: since DEBUG_PAGEALLOC forces all
> > mappings to 4k, there are no large pages to split. So the code that *might*
> > cause a split can just skip the locking (and a few other things).
> >
> > This is entertaining, but it adds complexity and makes for weird locking
> > rules. Plus it's all for a debugging feature which makes the kernel super
> > slow in the first place. Optimizing something which is already super slow
> > and not used in production is not the best way to spend our complexity
> > budget.
> >
> > Stop gating cpa_lock on debug_pagealloc_enabled() to simplify the code
> > and the locking rules.
> >
> > [ dhansen: flesh out changelog ]
> >
> > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Link: https://patch.msgid.link/20260715144519.934289-1-rppt@kernel.org
> > Link: https://lore.kernel.org/all/aab44f08-89f8-47fe-bee4-0ab6b25968c6@intel.com/
> 
> Hmm this patch is already taken separately though? ([0]) (obv. commented there
> already with review feedback).
> 
> Intended to be with this series as some kind of background or? Probably better
> to separate out given it's a live patch

From the cover letter:

  Patch 1 is already applied to the tip tree and I posted patch 2
  separately [4], but I included them both here for the completeness.
 
> Thanks, Lorenzo

-- 
Sincerely yours,
Mike.

