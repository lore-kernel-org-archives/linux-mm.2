Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 406DDCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9346B008A; Thu, 28 May 2026 08:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A436B008C; Thu, 28 May 2026 08:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3704F6B0092; Thu, 28 May 2026 08:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261F06B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:45:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5ADE1C070E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:45:09 +0000 (UTC)
X-FDA: 84816798738.24.90F509C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36CC4180004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:45:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvBdIusV;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGCkHYlaxTOFZUyCB3RVYY+plkaf3HsUJr6zIiU9rC4=;
	b=oLq9A9r3jMIa81KiT7RiQUIdupVIefsUPFaoRQ4Sf8xJdWykVihHuD/+pGmNLlzwlLLU8p
	atmr94iBB4TdFy3a+KfR0M7kMRH3OlH7xDLJCdVORuuX2uHk5KeeeBMvMNrnGy4dUZvFmJ
	+mt6va4ai7L3KhwSBaSfqXyA4k36UPY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvBdIusV;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972308; a=rsa-sha256;
	cv=none;
	b=UcHG3cebYnLedeUoZGL1koNt+KHjD1EwyjOL9WHUJkPdzjKYYi1XJTjGwwg5w+FNamT8BE
	o6qf16sUn8nOUunG3Ewuxp55vrPrZtClnWJFlsmScg6vYPvo+30EYN7r+Q1k8u41JBqf6h
	iT+ehJArxSXWPdosR9Wfz37N59WvyN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F15960123;
	Thu, 28 May 2026 12:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570A51F00A3C;
	Thu, 28 May 2026 12:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779972307;
	bh=YGCkHYlaxTOFZUyCB3RVYY+plkaf3HsUJr6zIiU9rC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KvBdIusVfuG+rSr77UEkcZ6KVcwGEc85pKwgLl42lw625N3EAUFSlBSRAMVaEfFIW
	 S4PLHmQtxIkSWu1RHQuderc7YsYrNSfLliG2tA5ElX+QTYPInXsILnFWXBoUaL0m6b
	 43k6JJ67+SgWHb9nYF+uk4tbkt2Pz48cr6iOL+TbLhop+rk3GuHtuL5tWxmP0xW5KE
	 1y56F4q263hWyKgKoo2uf75w0uhHHKjupFKcdfueMPkBIjJTDLix8ACPdzghGEjdti
	 RbwdIJxfObXt83/PpDpDSOnkjoVrwy+deILtkAdY3euWJL3dy1LwKoz4/IdLfjRYmZ
	 0cMkAR9s+ZfJQ==
Date: Thu, 28 May 2026 14:45:01 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Karsten Desler <kdesler@soohrt.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <ahg4zTSRK6THd2yP@localhost.localdomain>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
 <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
 <ahfWdMdxX68ni4ZM@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahfWdMdxX68ni4ZM@localhost.localdomain>
X-Rspamd-Server: rspam12
X-Stat-Signature: 81ah3gxyhoj9ksqh1jhcbt8h8au6q1te
X-Rspam-User: 
X-Rspamd-Queue-Id: 36CC4180004
X-HE-Tag: 1779972308-180356
X-HE-Meta: U2FsdGVkX18AbY5awfAcPjlkWEaOTv0LLMgiGUu3T8HoB6hzLWX4vsFNMMIQWk3y1guUfkog+5bq8uVGm+JzLTDnNeeovcuimiOagWwm1lMTAmUeieVU1n5CiOSIuS6nPs2a65iUMPIQSKi/mry2a9YNF90gSj2fj5kK5qbdtfsOntfvu0JTVP3ZcKF7PXH8WZQVjqrW6s5dEjWtG5L9H0z66AcNS1mkMgT4Y/oD6CqBdJ6Za75kveiDPFNwH/IKQ/O+wRGBZIZv656aC2/DDA9+NW2x8666ZceJamoep25LMHsHETdFp3cSAaNCDsWPUGGTnsaqhspaXBp0u+/ZSop0vydY2hHUzJgxBaDd7BBWlR0NyE+j99j3PiDavCr66+CU9dUxSXU6470MmK07+x9nSsc8KfdASLZbrqeDKTtrAMcPCTuHb9jmOpRgtByBCmLEqMb4nbztywh4++h/hMtvy2NIaHfU6UjRlcaTciW3HC3n7Lk87seebIySIcoiBmNm/PFbN2f6GV/PU8jnLjzFmR4ajhXTekTjLhbyJK4k6S4G1eKfVE6yOpGYFWzQXZFf8MIXfFb0/TrxSV/rCNyvGN6eQokksyMFi3GecQMIfJyekTLV5pPORJI78B0wuF5TQsDAgA3PXG4of1AO2WbhGNfkho8KVFfZ4MySqTuU5ArUxDco1siP82szAoME85p1EPj0G+rBhXpZIUNYLrt/BskfCul5H/KQmev2qmpzgniVbXAp4CzzAe1CJv0PEGRQ20jhhUc5n/FzA9AShvWm9lh12PorjyjuK2VfuldHxeO/TIGmNl3KoTfrUF6zu8UcHyrQ/uHnFQzIEkf48XFVCIK0nkrYuiVnuuNdH8lXVVEEm1rCDgCDfrIMahL85IqO7hvnSF55g813akIO+4mKybeJccf8YAKddBkGkMszCqD5gH89xofh6C0Iwxg2YL8Vfv05FvZ9SqhdXSO
 jRTcqCO7
 qm7luYNO/jCvFpQYOeQXlbLdFykQsJz0vrg5GQK8aV5hz6zUDg751zVDro5WB7Nwa58ZURdw4A3tg/5uCoIzvTTvcwTVSHNGJy0HM4sBDntndRTquxcIV1lhATOv3fhqRsoR6CnjW2UWquaMOi9OMqQoLCf/otB3Ja4doX5EPSu72KdFPvtQbROMk5raNo+bGf89LZBMnu7PmohFVHHgggY7nb+Uva/rTkfvNog16Y2i71dg2h7LiWZfbTNnW27+6uiHQ/9m7hMxlr6jxUSLFIGEw1hG8qqXDEunQFbtGoc18r1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 07:45:24AM +0200, Oscar Salvador (SUSE) wrote:
> On Wed, May 27, 2026 at 02:04:10PM -0700, Dave Hansen wrote:
> > On 5/27/26 11:28, Oscar Salvador (SUSE) wrote:
> > >   	if (filp) {
> > >   		info.align_mask = get_align_mask(filp);
> > >  -		info.align_offset += get_align_bits();
> > >  +		/*
> > >  +		 * Hugepages must remain hugepage-aligned, so skip adding an offset
> > >  +		 * in case we enabled 'align_va_addr'.
> > >  +		 */
> > >  +		if (!is_file_hugepages(filp))
> > >  +			info.align_offset += get_align_bits();
> > >   	}
> > 
> > That's a good hack to show the scope of the problem.
> 
> Haha, do not worry, I myself have 0 interestin spreading hugetlb-specific
> code around (on the contrary), but I wanted to proof the point.
> 
> > 
> > But I'd really rather this be dealt with in the arch-independent code,
> > not by adding hugetlb hacks to arch code. It isn't even clear to me what
> > exactly goes wrong when you set a tiny ->align_offset and have a larger
> > ->align_mask. Shouldn't the tiny offset just get masked off?
> > 
> >         gap += (info->align_offset - gap) & info->align_mask;

Ok, I finally got to it.

So, let us assume we ask for a 2MB hugetlb page.

~huge_page_mask = 0x1fffff

huge_page_mask_align = PAGE_MASK & ~huge_page_mask(hstate_file(file)) = 0x1ff000

unmapped_area_topdown()
 info->length = 0x200000 (2MB)
 info->align_mask = 0x1ff000

 /* Adjust search length to account for worst case alignment overhead */
 total_gap_lenght_requested = info->length + info->align_mask = 0x3ff000

 We find a gap: 0x7f28cfb10000 - 0x7f28cfd10000 (2MB) and assuming align_offset is = 0:

 gap -= (gap - info->align_offset) & info->align_mask
 0x7f28cfb10000 -= 0x7f28cfb10000 & 0x1ff000 = 7f28cfa00000 (2MB aligned)

IIUC, we mask what we got with align_mask to know how much we need to substract in
order to be properly aligned (and since we already accounted for extra length before,
we are sure we do not overstep anything below).

Now, I have to acknowledge that I had to look at the code several times, because
it was not clear to me why we were not just masking off 2MB, but I guess if we do we
lose whatever align_offset gives us (if smaller than align_mask).

I mean, code was already like that before my refactoring, just that back
then we did "align_offset = 0" unilaterally for hugetlb mappings.

The only thing bugging is, should not the same happen for THP-file-backed mappings?


-- 
Oscar Salvador
SUSE Labs

