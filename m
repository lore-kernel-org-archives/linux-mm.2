Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2951FCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE4D6B0088; Wed,  3 Jun 2026 07:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EE26B008A; Wed,  3 Jun 2026 07:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D416B008C; Wed,  3 Jun 2026 07:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 304E36B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:22:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1A8B120302
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:22:27 +0000 (UTC)
X-FDA: 84838363134.23.BDDCAEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40214A000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:22:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOUzc5Op;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780485746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXEjc/5hFRDYA1JmIf1Nf0sHw2o3MsqDWZosJ8VPs34=;
	b=CUD+Ehu1qwC8XqaOvH+2wUzL8ejCXYO0c9oBDzW0Ttu32rfmElXBWJJuTSs/Mn7dSjqxZQ
	48fIedYEeYOLI3KzK+qj3YA8woWa+FOpnTjNRCIIPJ5LqYA/rXLnNqDvnG4xw0kEx/nWhQ
	5USbeHUpGPIszBBClZIiGL+hSfEVHP0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOUzc5Op;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780485746;
	b=yhWaTyJjUL+cqsY7TS5LassElhhuN481fM1yQyyOW/kZksAf2+xUuC+okHI8T7lMW7PyvX
	z4zIZNMKXt6e5in2dHY9tNzsNR0OrXgKq8IkpowL9udOOmG9Rtgv4Zomu0u3Az2dFl/sWS
	y2ck3NYvD1WvmTYL8wC7adscYlVCBh0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B19D60052;
	Wed,  3 Jun 2026 11:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB941F00893;
	Wed,  3 Jun 2026 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780485745;
	bh=cXEjc/5hFRDYA1JmIf1Nf0sHw2o3MsqDWZosJ8VPs34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nOUzc5Op+hlkXIq555+AjTA9AOIZ7Z/YhcVbMSB4YwqOyXHfvGEboKFwb1vMLFt7z
	 rgKJtmrr9RSDpWZVJgclHeFWHWqp6QeZ+OTN48bM6NozoU4da0Hk9Gt2Y/JcudJEq2
	 GUczLX4n71GwBEEel4mmlmoZUS9yEwOF0baAxVKlshP+xIZDOeW+gOltyQf0EeJOxa
	 v1kSlqwBO+BJhMb/5PBSK1Cte2N6RJllzVJUPROBTzHF2O2Db4t8JgXrZllrcxfwyR
	 iQ0iWfIYE/MAD2Xc8q8C2xQaw0gMJu5BOUJL2/LSuVWBwP1A5hpdzljfWlbC8DcGez
	 f+NxByEYGWbkg==
Date: Wed, 3 Jun 2026 12:22:17 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb+git@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
	linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-sh@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH v7 00/15] arm64: Unmap linear alias of kernel data/bss
Message-ID: <aiAOaYwPlGEG6FML@willie-the-truck>
References: <20260529150150.1670604-17-ardb+git@google.com>
 <178041415770.4024555.11336437584927054639.b4-ty@kernel.org>
 <2c7929d4-6622-475d-af1b-bcd0cd997cd3@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c7929d4-6622-475d-af1b-bcd0cd997cd3@app.fastmail.com>
X-Rspamd-Queue-Id: 40214A000E
X-Rspam-User: 
X-Stat-Signature: okgog3z516whrng9xawzckp3ukwnrsad
X-Rspamd-Server: rspam09
X-HE-Tag: 1780485746-594817
X-HE-Meta: U2FsdGVkX189wOepUgD4GvoHJKh60V9P7ielMof+zhSImyzmbVRB1YP2dZdi8zAagqCaMLWEqBrKDDvFUpmD1dsLxNEWiqEPQQCMpBjZRlAqR5zURhDdZCE5R3DCqVtU/ewfa5vMwdq4IoDnwkzOIVmQ5W3tGFLY7nJAUeYyT6Ft3b/LSeU8owHJLlXIeNOWzZUhNNtA1Qz5w3gz/qu/XtXWw1ivXuwSJivPdtbnCKLjvpSBqVUXTdeikUCbUsCSXJlsd+dQe9AQf0cf7YXaqfaFIRdx1WEUh31dQqNnWQpN/mTcAASDJ6vp3lhRNOY97yj7dnR6M6ktUUX5aVE0LVhvjrNGFW2xCH22zjzJs714YRiHjsJ9nVdMiH7nz0JICgME8JhHqYzTrUqAZ4Mp4BBwB579z7EYZKZSLAemJVsrpIaDokWMvwOs0TBSZkO8vUQrtDg7FfOj6sm8LfFemJe7XcyZlpzkuMhvQtEsFZlyAHBxCP63+NMIB8MnAjIrxN0f6Jp6zaBP5MaVDTf3LXWMPZ7j/1Axsy4DHnDi8DEHsRxkXR1iNiK27rNEb7t+5v3yb/X4RXiJdNBIA6OjRWcOmMI9iXJrpAgsPSjPUCKMszmUGikk5AuxjxSJGbAt4o6kBWNpilP6DxiuDzPj4JI+StrtlncW9y/Jy8UEq99dXi8qwBe0ZIxh7H+MBPr8X15wDPxsD4IzPtAZH2Hv4fDQJSGlSRM5JEvct8OFqCL3aHFdSKgR8YlvclI9cZdra5tkV3qdoYq4dwSXw39n93jh6yI+qr0O2riF2+pj6qhWSHMRsznCLiI3gTzOViqRIfbJTIhB93JBdDI5oi1VTInACn160PDAhTDRuySiaj/wJoINCiKzdifkxxblBVi8Yq5aAJxl1LCu4Y1f/8DhzjNlYK8ncbSVbckQP/36KnZhLstfLcEnnwLsNP8tOQMAnL5gtmmayA7AYXcoHLi
 pXex6dYB
 rIdfl2soaxJrYmrD2CFORhWaT1SW4ZCy9HH8lfmav2BKFRG0YNa0vcx3hQL23ckma4UIb8NCii0FZYJ37svmrZQYNToK3Fh6b51XTNccwhyx/2CJe5Y62HZc2trsWW/KxBqpCL5j+ANIitKmyYajciQUE/A0c7KDahQktvPSdeZcz9rV9t1Rp51dEioGg4dYBpTPZ9disl+xTzwx9IY/2LdTKhBmra3rmBjNc/S8ukL67zu0nDitYwXlu57J1E8Hexv2sgejad6zZjZkJvgni2zQR+oriKB9X7Jz1zielA4wG4JcKZ3NivQ7pa0joUkYkMKmkE3JfipsAwSk1LHiLPlemBmGACZLUCPkI0C0XRHyF6pH63SATphisMEucO9L7mxqL8eKafjqt+WnE5jM5PYzheoNtP+oHkSJKWYLL6MpwvuqNfW+OlGZi7LujjWsP38BNHe5pQw0zS6C9swz67B/lAT4XjLd2bTHQo7btZIXP0fBSghp2cd3Cp2+IMClHblzOLFe9eHDd8pIc1jSjdxrnpEAxPe45jyqffiPzEztrvJxny0h9F0eJnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:57:49AM +0200, Ard Biesheuvel wrote:
> (cc Marc)
> 
> On Tue, 2 Jun 2026, at 22:34, Will Deacon wrote:
> > On Fri, 29 May 2026 17:01:51 +0200, Ard Biesheuvel wrote:
> >> One of the reasons the lack of randomization of the linear map on arm64
> >> is considered problematic is the fact that bootloaders adhering to the
> >> original arm64 boot protocol (i.e., a substantial fraction of all
> >> Android phones) may place the kernel at the base of DRAM, and therefore
> >> at the base of the non-randomized linear map. This puts a writable alias
> >> of the kernel's data and bss regions at a predictable location, removing
> >> the need for an attacker to guess where KASLR mapped the kernel.
> >> 
> >> [...]
> >
> > It would've been nice to hear from the ppc folks on patch 11, but I've
> > picked it up on the assumption that they'll love the negative diff stat.
> > Worst case, we can drop/revert stuff if they have late objections.
> >
> 
> Thanks.
> 
> There is a de facto ack from Michael Ellerman in the Link:, which is why
> I included it.
> 
> Note that Sashiko found an issue with KVM+MTE, where a read-only mapping
> of the zero page in the linear map may result in issues:
> 
> """
> Does moving the zero page to .rodata (or unmapping/read-only mapping its
> linear alias) expose a guest-to-host denial of service with KVM and MTE?
> When an MTE-enabled KVM guest reads an unmapped memory address, KVM handles
> the stage-2 fault by mapping the host's shared zero page. KVM will then
> call sanitise_mte_tags() in arch/arm64/kvm/mmu.c.
> Since the PG_mte_tagged flag is never set on the zero page, KVM's
> try_page_mte_tagging() succeeds, and it calls mte_clear_page_tags().
> This executes the STGM instruction using the zero page's linear map alias.
> If this alias is read-only or unmapped, won't the STGM instruction trigger
> a synchronous permission fault or translation fault in EL1, causing a host
> kernel panic?
> """
> 
> Marc seems to think it is legit, so I came up with the following (I'll send
> it out separately with another pair of tweaks):

Thanks, it also looks like we're getting some early WARN_ON()s firing in
CI from split_kernel_leaf_mapping() after applying your changes:

https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2571596185/test_aarch64/14662134813/artifacts/jobwatch/logs/recipes/21399931/tasks/219104268/results/1007729692/logs/journalctl.log

Will

