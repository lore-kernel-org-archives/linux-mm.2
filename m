Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F09D3ABD6
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 01:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C016C6B0337; Fri,  5 Dec 2025 20:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9986B0339; Fri,  5 Dec 2025 20:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15D06B033A; Fri,  5 Dec 2025 20:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0D6A6B0337
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:25:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2125E1A0370
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:25:54 +0000 (UTC)
X-FDA: 84187304628.04.D54C6D1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7505E4000B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:25:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=O7BwMqIr;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764984352; a=rsa-sha256;
	cv=none;
	b=1a85PLLVqLKeeTsSdWJHOLWCxZ6ALJKyWx4JHYRf0LSAkPRDgd71W/mvQAUn8Avz8ZKoK8
	DGxWkAyeIa2VVxLFY5EJimzLv5qoKYfXoK7N9qrzqzsdj54/3n6q9pc3F8YGcHD1NPJY2W
	amCS+uJGRTIntJxTNU8nSPN/F5nsBZU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=O7BwMqIr;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764984352;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxMUTPrkAZTGMcrjPXj4RfoXgnl9iUjMPVIZTyujls0=;
	b=vZiZAV0MXI4mbLsKurRtNhbn14nIIDc0xaqGug/HlJlmYleLwuHkCEL7PQJXw/Z7maacPd
	Rqaz7OhfyAgPfBcJHmh2yxv1x6d+pM9JjpsuxVb6pJvihc98IRzfoW9/fFmI8GEKDWj0Hl
	eUUVeVF0/lIS6ha7gf8wp/pq4vnsYSA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AxMUTPrkAZTGMcrjPXj4RfoXgnl9iUjMPVIZTyujls0=; b=O7BwMqIrdFF9CkePwh/M+8p5j0
	t4FAqufD8mv2VNTzJqb/h605ECIFwGCAiGrNqEIKAEVJYf0LBFd0ajsBc6hByElUVyl4+Sfqno9Fh
	mnxI2LRXGgcIjeCrNS6HsfOnwjbJQIX3vJG7XS1NFanddj17lgKrf4+qJ/g7AtRZ09ovAB6JUCP17
	Cjnw2ULSn0Gs9k0ZaeW7QAnyGRK1VH+L78Zwvp/uQrxSPXldbUwaXUKVOpIJ8V1UmoPhWpYGswWBR
	yaA1cBZws5Yx0o+OFaHH/LvIJgyAY8VtR78129HrLenoEI1RLaSYurLWPsv8HTbl8WqCmdLccsiro
	uOClFnIw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vRh3o-000000040At-19iq;
	Sat, 06 Dec 2025 01:26:08 +0000
Date: Sat, 6 Dec 2025 01:26:08 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251206012608.GN1712166@ZenIV>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251206011435.GM1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206011435.GM1712166@ZenIV>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7505E4000B
X-Stat-Signature: dx6c1urhqhmu46sace4g618pdat3ea77
X-Rspam-User: 
X-HE-Tag: 1764984352-881363
X-HE-Meta: U2FsdGVkX1/NA9fN5LaTMTpJobEuOywUgxjp54EuLwkqAj7EJ1xL49jNNAe9h5AVjzLL3ifMn26Gc/AJ8A8+k/jvcSHSQsSsNW0/pimg+vkbEINiCnetpK24ef+b2Is8z5adAlLgAwhwiDIC9id8vVukVozNemkAGjTbWTYfEfYTrYill5BHQzrgJf0xkqVEYoAaRGiLacmr+JAWzMHHz4LM5KPr5LfWQABu/eOrZjM8ds2lb2u+znpjEEHlxt4CDTYBveKl3JbUFH5ovCuuaqx8IIhVituWZjK1TJlWe3qBOO0s77xDnD0+v2pwHTNaWb0kcfJfC/yu8dhgFsYIQFRPQGvc713/nsJv+drk47a0wdNhgR0+YFM/fFFzXbgBJsrOFRsFehE6fwmIbv7WlIYDmsdYWlyRmwbGxX9i0NnHK3/sClAESE0vyftLnmH4DxTz5suxTk8uv7gDwGM5JDhT6ghWli0VM9mXBMZScfIaRXGqx4YDvaX/3XscA1vnPLwiBevZfXapnAt169dr7WBHLYUvKwU4JWohMj+eI9UmXx2s6iOgAD+29gbTPRKOk2yB7MflClZLXW4ZdHcAze1kltGWv5wyKNG9EWpczB59/UPV4guObVAcCtVdy64KMZHjRWdGTdIu3VT1t/NrqOAXhiROU3rXczBYOqN9j/ijfVjBUa98xFqDeiEPzDDlCDWnJ1EU6Lhqe31d6stladdPWE14481h04hzZhoFEnL8LfbUJjJc93+fL+/o5w2WvbLEfv51p0qpd1q5CHSU5DRl4j8BG44myrkYLyOCZwUJE39+qr6ExIlpIYvchIz+ZFIimTjDCU7hkHqRSA0PYG3o5GlqWFzwIcIWYNm397WsDSHIy26sMI6v6qbPAp+rm7jz6kzALKrymPB+V49izakZOxkm7Ilky3b5Ew1OBJLPWE5+ag5X/NfGcXTALYtBsIHW9g1sZvMv5mzWjZg
 8M6R2dtu
 tTpuFncXbWRd1qYzMHE2x1AHn2SRDM7q/Y0il2jKW8C6HRt1QhrrliuFLfxnyUT1caUipsgPk115djIeNbes1SCYF30d0Sf8pN/U0EXEr9WB7UQ8i7B7oveD4vBIPAHzTQjq2FwUFpDso8ZLIGOREJhkD/yUM/uAAt7qT8e2JfYbfCpbUTsceK8V999PnqVQIKg1c0C+2OiEeyIMPokPxjCp8QAQxNz4FdwOfKnBvRTWznqUwQXjjjcNpzaGDj3p1nSab8ltegNU/FR2L8RNy0+kJVF/Mxda1VMfZv+QGavz5WcCz2FxoqkxpF3wgmxb8XHmg8aMyeBqyoFlwwvrX7Uhqno8fXUItNMiu7JNS7rDO3TAcLE0z6LSHw9LKboyapG95G+nPCgoISvCkAFiTmFC00zN3mK0GcPXsyi1C5Myb7BO2Ti64tGI5WDfzXsyedTO+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 01:14:35AM +0000, Al Viro wrote:
> On Fri, Dec 05, 2025 at 05:50:37PM +0000, Lorenzo Stoakes wrote:
> > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > how VMA flags are declared, utilising an enum of VMA bit values and
> > ifdef-fery VM_xxx flag declarations via macro.
> > 
> > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > the newly introduced VMA bit numbers.
> > 
> > However, use of this macro results in apparently unfortunate macro
> > expansion and resulted in a performance degradation.This appears to be due
> > to the (__force int), which is required for the sparse typechecking to
> > work.
> 
> > -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> > +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
> 
> What the hell is __bitwise doing on these enum values?
> Could we please get rid of that ridiculous cargo-culting?
> 
> Bitwise operations on BIT NUMBERS make no sense whatsoever; why are those
> declared __bitwise?

FWIW, bitwise does make sense for things like (1 << SOME_CONSTANT);
then you get warned about arithmetics and conversions to integer
for those, with bitwise operations explicitly allowed.

VM_... are such; VMA_..._BIT are not.  VM_READ | VM_EXEC is fine;
VM_READ + 14 is nonsense and should be warned about.  That's where
__bitwise would make sense.  On bit numbers it's not - what makes
VMA_BIT_MAYREAD ^ VMA_BIT_SHARED any better than 3 * VMA_BIT_MAYREAD?

