Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22FDC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 10:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC796B0088; Sat, 29 Aug 2026 06:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E4B6B008A; Sat, 29 Aug 2026 06:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1B16B008C; Sat, 29 Aug 2026 06:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7C06B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:48:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D207E1C223E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:48:43 +0000 (UTC)
X-FDA: 85153983726.09.3A1A79F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 296F9C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:48:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWRmvwZ5;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788000522;
	b=6185h+Fp+LW6pkidyMXp3ABRv6HdV/bOawViEPvDVQW8Tsluau+nav/WnQ4Uym9FvZwwA8
	B11Jnz8w+b2bI+YAVJmqFQDvMsSYU2jaTnPXZAm+Sd5B5SbR7l+zAzuDcSfczDpRbpcAxh
	0KeSu0j0SWPsDcU2nSCPgR9bFrm4I3Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWRmvwZ5;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788000522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFZ1nhGEZbR6O/VCAicWb32eNrolFHOIlFtmV4ujfk4=;
	b=nyCIlUPXDbrVj2hGl43QnfDA5+fR8F2t5O+ZywhJk1dwP1ENPBYerhWr3C3HuLMsL0LE5Z
	7KB+2LcBb9045iNXr8HIHYMdJ2rzssXvh7qd4y3hvhni+eTs/QI3Qs1tEVQY12X0Y9m0zz
	xckLwNxmTDXqTyXdUFUdYwE+LHqSvQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15621437B7;
	Sat, 29 Aug 2026 10:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C6B1F000E9;
	Sat, 29 Aug 2026 10:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788000520;
	bh=KFZ1nhGEZbR6O/VCAicWb32eNrolFHOIlFtmV4ujfk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LWRmvwZ5mPls4Z+BaiG1qXwR10+CBxW+bUOShLfZyRmLMeWBsXFZbiPwmkePznqr5
	 RDgCI5JSJI/PnwyJzmrjiTTIt4pQEyHh4ig4dGZIGujt3YWBOXTXM28p4gyqeJwbxf
	 WsaqKftKKe5VsQ0VW/PEX8SxuQhw1GHVsePh+UKddYUexwRXUbdmDfNrJmoD2ZI1v6
	 YA0GuLxzRK2viPxmPZf5a9S7TnaLyvMWbeiiVwoWcOVI5CYLFrXFWBc0Jr3YfAzGPD
	 ENSQxCrpJykei+zA/nljjaxyFx/CEE02iM1psN14xjNoYwJ+aBxdLXjvTaTWkcJoke
	 quOJdXXFQrxWg==
Date: Sat, 29 Aug 2026 13:48:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v2 0/6] arch, mm/execmem: resolve confusion about
 set_direct_map_valid_noflush()
Message-ID: <apK4_MgCtPFlDwoc@kernel.org>
References: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
 <20260827223947.c773e6a7324eaf3fe0d8362f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827223947.c773e6a7324eaf3fe0d8362f@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 296F9C0004
X-Stat-Signature: saidxw5x5io95tceq7p6het7z5nqpaxi
X-HE-Tag: 1788000522-733056
X-HE-Meta: U2FsdGVkX1//NYN8qq0dWb6Mgv2hbZGSiARR9eU07WJrrF8q+CTjdeilIYwhbkZl26ZANCROkqvtGC3jKsvi2ByCIUxtSMJqXLVhXo+bTmpBNDlsqZWz2qr7OfqFf40u63z5eyRehMlv1NaTwUhkfvyJZyRFKpe5iigXtJod0H9pkaORL8t2J+NpotQveTQ8whlttIW/41Ail9HXVdthl4DIytta2segUNGaN/dxZYK77gHHKmdHM6klE8ym5+P323/dBxBDBNG2GsekMMTUv8oFGAU3lFnJfyrevWc49VvNJUW7n88zeVTybklT0BRr5DXgh+rsSlz2bx+dbCmA6hLu+v/b8OPfMdYfDIebD7ryIHGGBOYybcyWFXynDIkm832xwJ3GMIdXPsVGkoo6nbhT/+lBFiRtqs8iFn3LObF6NjiY0rDBUJeVSCZzy75FagnT3FttFxzye3oZ0Gg01FcJJHii4qcr8vSuuTnBm8xtJTT5sAqDET/uXVC745NAw+NSc0DUB9eV5rk5Vt4dk+9F40y4C2pLWQmJJgl/6qpiPz+rAgzzF1sZM3YVirwLg0C7e3H6R2twUNk2bENbxRuuo1AJNTOJV74PNMewmRyjZGKKUgiTVOyx97hD/WnbeSvae49jyMXjV83pNdNDW+1p5Z62EgjHdZ3DDLBg04SYVRg19Cc8SgiPAUw9bO3nyKk6O7nhV1/aw6O8WK47QFGW/bw58XF+8P+JFD4gLry5lxiWyuoriDjXIRbxcaqsyxIaa5TgptoRU4UewrR2hb9OspCz2ZlACXqaQ4UjqmjljX0NiuEO5ZIlK0t5aLKPODBthniv6XObdsl9rr+5B8h3CiAWfllOPCG311XYtISsusI/Qhg54nEel4ghmoNnjT8l6YeBItA3sm2YzUt51ZhzVzHeE0HtKkD3TnS9eg1gKa+FKe4S7rkxNdFX/qUYoqv/SDFn6Hg7v4hf0hN
 cj51rIC/
 sqnsKUIJcLAqxGZCYnzpmXu2olm3wr8wEmtfIL47hVOkmK89Obo+uWytOcnugQt6BaUu2CQt9dFgNYC2/MiwlE8Rzojkd0344cItzKrR/U6K39G158dZLv+/xUM8430Bq/c/6hTmBRCBAX8HaOhB1A1ZY/feMFtSGiIMkx1OlCfymmHHtKH5ZMyTkFoQ1bt59qG170RXjicTV/kcIAQCLrINlopI6FtZ9hgSGF/YovXN2FHHdqchBJ+axZvRfvbXGTF5yczSj44YLE/i9Jc+YIpyj85sRZGwfjYCNXiRIp0powbGMTpEAo3BjyQPvAY7pgnxcYpHaJn2wivZEO28Y3A0xnpwHhDhIjV8bGZVXe+I01PD4x8TYxnSTDx98WvkRxFnDQ4l9Xe1V8XUwXiilgdDApP2yd0aoiLiR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:39:47PM -0700, Andrew Morton wrote:
> On Sun, 23 Aug 2026 14:46:11 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> > Recent discussion about implementation of execmem's ROX caches on arm64
> 
> I'm assuming a "[1]" reference was intended here.

Yes :)
 
> > revealed a confusion about how set_direct_map_valid_noflush()
> > implemented on different architectures.
> > 
> > On arm64 it sets or clears the PTE_VALID bit marking a PTE as present or
> > not present.
> > 
> > On other architectures it's a range version of
> > set_direct_map_invalid_noflush() and set_direct_map_default_noflush()
> > 
> > Unlike arm64::set_direct_map_valid_noflush(),
> > set_direct_map_default_noflush() not only marks PTE as present, but also
> > sets its default protection mode.
> > 
> > Other than that, initial design of execmem ROX caches didn't rely on
> > restoration of large mappings that's now available on x86, but
> > completely removed the memory allocated for the ROX cache from the
> > direct map to ensure that large mappings are not split. This precluded
> > usage of VM_FLUSH_RESET_PERMS for the ROX cache allocations and required
> > execmem to implement manipulation of the direct map alias.
> > 
> > Current implementation of ROX caches does not remove the direct map
> > alias but simply calls set_memory_rox() that updates the permissions in
> > both vmalloc address space and the direct map and relies on
> > collapse_large_pages() in x86 CPA to keep large mappings.
> > 
> > This allow using VM_FLUSH_RESET_PERMS for execmem ROX cache allocations
> > with small adjustments to set_direct_map APIs and vmalloc::reset_perms()
> > behaviour: adding number of pages parameter to set_direct_map APIs and
> > making resetting of the direct map permissions in vmalloc VMAP_HUGE
> > friendly.
> > 
> > Implement these adjustments, make execmem always use
> > VM_FLUSH_RESET_PERMS and revert set_direct_map_valid_noflush() changes.
> > 
> > [1] https://lore.kernel.org/all/20260611130144.1385343-4-abarnas@google.com
> 
> The patchset is perhaps a little green but I tossed it in there, thanks.
> 
> I hit a few rejects in arch/x86/mm/pat/set_memory.c, but minor stuff.
> 
> I trust you've seen Sashiko's incidental oh-btw comments.
> 
> 	https://sashiko.dev/#/patchset/20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org

Yeah, it did discover something fishy with the fallbacks handling.
I'm looking into it.
 

-- 
Sincerely yours,
Mike.

