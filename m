Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECCEC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 07:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6754D6B008C; Sat, 26 Sep 2026 03:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626886B0092; Sat, 26 Sep 2026 03:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE366B0093; Sat, 26 Sep 2026 03:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 176A06B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:47:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E29FC07E0
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:47:10 +0000 (UTC)
X-FDA: 85255132620.26.0BEB103
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AEC31140003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:47:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLfMscGB;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790408828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrw6MYauCv8ojbkVGE0/DH1V6nBqh+BVfWF8V89VP1s=;
	b=ieFlxwju0FoS4WXobe2tuOx3iH0wcOpP2zH+wFfpKOBqCYzm64VUmqs2RX3H4FaTQ9/0/a
	daMYv39cphsD13skRuX4kqPVtRnQbqLctCppAQzAhb8KCA2urIEdiqen1dySUBzFpx3wbL
	L+vE/RjzkTjj90gtVa5qpRZU/cgkVcU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLfMscGB;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790408828;
	b=zrihXLO9pN1D+8oMoq41FM5gyLA+u0Xh0ONIaT86x1sLWtkKb92yHpYma4M8VrY6AfrekB
	FrsgZ7zzz18DngST0te4rQRY36FlH8NsuWPQo7OseGaYymm6WMjxPPCU4myZZoKHUK40zd
	gkV9K9x3AZxk8GnoDKXhYSVYs3Da0WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 788B943C06;
	Sat, 26 Sep 2026 07:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F58A1F000FF;
	Sat, 26 Sep 2026 07:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790408827;
	bh=wrw6MYauCv8ojbkVGE0/DH1V6nBqh+BVfWF8V89VP1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OLfMscGBr6BX8Yna19+gsaP22UJ+VC6W76Sm1UE/FlcJ15iqFYFvbP8d90Igg0AX1
	 etwZZWvdBFqYZ7NSvihHp+SwEwBuk701GAxfmSO6piNYjNYiaHlu046T9GjwlMO2xf
	 4c1bAB9kwCau4RjnCCKk9fIPdqnFDhybBXluZ4npAQ+/Qvix5ljL2AzBzj8Usd+RJB
	 alu3Ul+qNVip0JJyq+c0VPs71CaO7MwDN5xY42FOblZ0wy/sGg+Vkn4Rt8NPoSJNVK
	 MPrtXSD7KUf/JpSLiGjV6OU4NBwSkGGFUelmNzH6itp7ArEwWPKw0np5F/RZkSk9Pv
	 v3y9vQMfZ/lsg==
Date: Sat, 26 Sep 2026 10:46:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] arch, mm: promote DEBUG_WX to CHECK_WX
Message-ID: <ard4bg-fJZUwlZav@kernel.org>
References: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
 <c8bd5eb2-d411-4b11-8f51-1309374bd466@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8bd5eb2-d411-4b11-8f51-1309374bd466@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AEC31140003
X-Rspam-User: 
X-Stat-Signature: ynstoocc3799wnqokn1k5wotmycxrjuk
X-HE-Tag: 1790408828-582224
X-HE-Meta: U2FsdGVkX1+6Vd0AWNOKmeuIT5xRaUOeWNHv+m/AcTgeU5Ew/yT9osJmh/MzWBWiIGair8pA0wLWhH/D/73ti2oO4NLUUIoX+rg8lTSbY8H/tYpyzEK8relOJOWP51otJTIDgspRntLTbU+8kjPaLTJrsOLFe4lzaV15t3gxFjw9jOULJzepq+X9TJXKJ4SZJ62g33gxr1c3TgD5SNivV5mh3650slvFgk63fVG8GF08bZK2Z6M+Ws65HvdolRkkgQe+aqUJZPv45GaRJOP2vfd0GeksKYA+qx0f6fi6U6JCGBjFRqPf2W9gK+KTy+b5yXEsC/YAVW2fyBmjHhsdANQeKnmmAXAN2TtB8GQWsc7BI/VcMuncLjQBnkp/UZ1mXUOCKJyWLpJIkhMbIbAXc+eWgWif2bjXzv5Nwrt4gE1ciayN/nJDYEzBCwdo73y4HkVe1d+pQIX8Fm6Wa3FKzg1bfUtsM46hNGTg0oEqqjLWOu8efW+21qtIWPYwZQMp4CCDq2T+fWvzvnG9no1Cl0XYTz7VE66i1qPBNaXucGIZtdnXv9dPWLERcLnlGRefHAVZDCGXqVqJRx+zTKKQwQeexlIG150V6YrOz+vrpiAvnHvyPXSlAFXx68vQFxhwucoaX0sGEhDijYHLpwlhqX8fARb6kN8u+OSGyWvTpHgeFo/mSnrwwv0wj6VIIoh6CUZ3dFDJ48n+Ljw/AtC/WQtW6zmfEhUSL5A63p0AS8UNq0t2oSe37Jn4pYBh8BWIbSus36Tr95aLg0fVKCVUPLvHVSqdecWm9AIlQGc48mvSd3cDyN8G3/WKphc9hv3ivex1fUsMEKxmTYVvpMu6chOcaNo4vZt8Z59NaB6Jmof/9nDC5AOauvJnxXhn4di9SpTwPboNfWKZWLqV5y1IL7KHOAuVEfd9pcuIi6IfnPqdTretUezwRrh6DHx9r3hLg9+d0VmWr1MfJuEQQkK
 QLa8tXN5
 Ua/kBGkuXEIcTgdRtuOQZ1xQWbYJQ8B6FNm5merEe3ZP55Y5pQcoqyG9nw6kPnGRycSG+chOS2K+GrhOCGSjIQCusX3/90KVAry5vKrrgZleLChgsOcXQdgcyNS27FZju32LaDX1xMzxFOpWlLTHKT56QaRA9xElSHyExsRMtKkhIBBXaXvlg1LUkdNFACv7ocxnEEJRbEci9aJAnZ3nvE6Wh+P4cM6SVibBAzF+Rmih3hxOOiSsdLgC3W84B35Hh+zELgfzpvydzvhuuvhY8AMA2mdg7PO28UAK65u7jAjldyAp2obooEozKEj0DYc8M0SWotym0IjaqEIiGiOld0IxooKFdCN937WGr4icHJDpqeUpNL8LLnnts3KQlGwnhtCllEP3B1uF+4lbnbBKzq6f0IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 08:47:50AM +0200, Christophe Leroy (CS GROUP) wrote:
> Hi Mike,
> 
> Le 25/09/2026 à 11:53, Mike Rapoport (Microsoft) a écrit :
> > Verification that the kernel does not have writable + executable
> > mappings is about detecting security risks rather than a pure debug
> > feature.
> > 
> > Major distribution configurations enable it in their kernels as well as
> > defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
> > 
> > Rename relevant generic configuration options to use CHECK_WX and move
> > their definitions from mm/Kconfig.debug to mm/Kconfig.
> > 
> > For arm that does not widely enable it, only rename its variants of the
> > config options.
> > 
> > Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
> > the added size can be slightly reduced with churny updates of
> > architecture implementations of ptdump, the core functionality takes
> > most of the added size. It cannot be moved to .init.text because the
> > verification has to happen after init sections are freed.
> > 
> > With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> > still leaving users targeting small kernels the possibility to opt-out.
> 
> Looking at how it is done in powerpc I have some doubt with your reasoning.
> 
> ptdump_check_wx() will report regardless of CONFIG_DEBUG_WX:
> 
> 	if (st.wx_pages) {
> 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found\n",
> 			st.wx_pages);
> 
> 		return false;
> 	} else {
> 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
> 
> 		return true;
> 	}
> 
> The only difference is we won't get the WARN_ONCE():
> 
> 	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
> 		  "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",
> 		  (void *)st->start_address, (void *)st->start_address);
> 
> 
> And I believe a big fat warning like this is a debug option not to be
> enabled on production kernels.

It's arguable that this indicates a security risk and you want to see it in
production as well. And on many major distros DEBUG_WX is on, so you do
have it in production.
 
> So I think we should instead do:
> 
> diff --git a/include/linux/ptdump.h b/include/linux/ptdump.h
> index 240bd3bff18dd..714f63fb604a0 100644
> --- a/include/linux/ptdump.h
> +++ b/include/linux/ptdump.h
> @@ -33,7 +33,7 @@ bool ptdump_check_wx(void);
> 
>  static inline void debug_checkwx(void)
>  {
> -	if (IS_ENABLED(CONFIG_DEBUG_WX))
> +	if (IS_ENABLED(CONFIG_PTDUMP))

I don't think we should change that.
It's up to the architecture how they want to report it. If an architecture
wants to keep the warning only for debug it should convert WARN_ to
VM_WARN_.

What we actually should change is debug_checkwx name :)

>  		ptdump_check_wx();
>  }
> 
> 
> That way you should get (untested) the following warning but not the big fat
> debug WARN():
> 
>   Checked W+X mappings: FAILED, %lu W+X pages found
> 
> Christophe
> 

-- 
Sincerely yours,
Mike.

