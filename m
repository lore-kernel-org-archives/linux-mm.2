Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202A1D185F8
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861006B009D; Thu,  8 Jan 2026 08:38:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806FE6B009E; Thu,  8 Jan 2026 08:38:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6B96B009F; Thu,  8 Jan 2026 08:38:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5446B009D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:38:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF1FF1A0136
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:38:09 +0000 (UTC)
X-FDA: 84308900298.09.149DE01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D95F100002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:38:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKSNSmMu;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767879488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Onnwl6/+EKiyeH9xjAmodGneCE3rl2mtBrTRBmDbsI=;
	b=uCKJvvs62GONTsMZKSumY0T7xeb5aHRdBF7OmvBwuOPWLIMj9N2rcwsBpIZaShSX8PayEF
	TIL4vt9TxmW1JIII2SRMgL8uK49Uu2FZfQuOo/jlo//UavFSmVXqO5nz65Xg7eOs1qMuKn
	CWL3gww+zNre5Bauw9i0/N6tQSwE/Tg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKSNSmMu;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767879488; a=rsa-sha256;
	cv=none;
	b=VdjHrUJGht1mzahFyK9WaO7IkhPncWRR1JHBgYipz19vtnrSLS9ikHM/of0YweguG3in/7
	Cf/D8ur+V+Fhf3Ua1jZXPejZw2AumMTJSqLTKdCg2nAKKZWn4LwcsbFa7NUG7fffcUBR71
	Lw3IoiQ+8zNFVGDRwgkhup5gu6aESsE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F95860131;
	Thu,  8 Jan 2026 13:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE32C116C6;
	Thu,  8 Jan 2026 13:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767879487;
	bh=VJKhVx5DGpVLVYb2XKJ8mMHhMksRI4ZPi6UFAnGjOes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lKSNSmMui9b0uWXSR001Pt88qSwhYL4W2bFV32qwFJ/6CmW/Ao5TYVAY3Z+59376e
	 LGMD9MiGBnRAvJH8NMvzcia4RujNN/Ji55DA7R7FC9V5WsJbqtoAPJTAPUCr5atPUE
	 poGy32Xu92IK7Q6/R8BLK5Dfhvm0ifmZuiuV3C9vgar8FlNP1ez1Sr09T2iAeyAOsS
	 gk385QWtqNoWlz57jEfTxAmmfx4P4Mski6nsScaJkhVKadirubTC5FVXcq8viEItJc
	 1AEPIPxLDV87+Z5JZ+lhld5Il8971MVKAXSlnW8bHrCKUMYsXlt6o7qcTWAv0XBwbd
	 WP7HoXXSByWCw==
Date: Thu, 8 Jan 2026 15:37:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kalle Niemi <kaleposti@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org,
	matti Vaittinen <mazziesaccount@gmail.com>
Subject: Re: [PATCH v2 22/28] arch, mm: consolidate initialization of nodes,
 zones and memory map
Message-ID: <aV-zKGYP6EUETaQ2@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-23-rppt@kernel.org>
 <5f9a0269-f9d5-4ee0-bf57-62148d762f7f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f9a0269-f9d5-4ee0-bf57-62148d762f7f@gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 1joxbc3m9ie1j6h6hpxtq1wr9bpseyrr
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D95F100002
X-HE-Tag: 1767879488-315563
X-HE-Meta: U2FsdGVkX1/u4Sp+qP+P6k22u0nFfVRqng4pKHbccIfhcYktbVHFIfx6b6uQqDRtKHwQFQWCDfKNhR6U4/Lsen0NoXOGjrvkH1H+oDSPwRNdRnFOwcMUD0RYX/NQtkew6weBuylgoXtF1bLs7BROu3XcDjvYoNn3rfvSPPR54drEAY4+qR4YmKrZ4ypPegcWh5AvIbes8QkuvTaJubJxqDp8LRhcRJmmkeoWdyTLE+2IeOBpCeTyVCuyYVNbDEWKYvfihDlQWaRlqA4z3azC2I24w3WDww/Kq4gsXpfij2+q2dKDiIP2SmdTG5hB0nT6zAuHhLT9G94F96qfYal7os7RoiUvElZ9g8EJLvBqYGKJSFR/7OBKtJ2hHSp2WC6OJWU1ASAQ1LGgvNGhy7oyRj2PjYxb8wXr+VHDKrj2a6PDnHar5i3dtt7sVK42C6kNspgTh6EHQ5ZsJBUnFK9fFSLi3QqMjgO3Vrfn/qQTvqXCWpyw90xN2IJ0sptnOyEltYHessGvM5kI3Sir2httWeGV/NuhJBLXFNktrS/uFPgJEWT2YfQtRpG0f9Zbg6rcyVhD9z9b0c7NbkbOVP3QHgozlUTwWXrtrwDU4OvlHVzwPEr9vN3EzAgSeeMxx5gnPXpsySDAtACpxzxGw7wdccF56YpNcwzDcbslK2HRrsKg/zXComFxypvEtLRXUKyZKMyaGBn/tUs3/eRdSaYTWsmAPlDLHb4Bua+sy2si8JzWafAiLFwamXYu99r78pB78Ai9bHfp84ovhLEJK6qMtB48akAHjEd5yOdMu9NS/oqpK3O0NR3Ky/Kl+l2MgMbGOHHL1Gvp2uM2atrr7/Nc+e2GwdJTfI+FLfqYheasaXCqEpj6TR1Z7xHJzfOGHG/qiYWBPUtx9kSM3ZBTy2dgJn7qEpWR1zxgEP9e1ilb9MD/QAO5TjK6Ljbww6Oj4Atwaf4SgNfOCiOPLbgt3oH
 qKaUDS33
 tU4Q1K7OCkRa1RhN0sCgzCqukgcEeJR4QxLqYgeqSh8pInAQdAVO4E4+LUjnX2F1O+TcDNhIGVTptxzTniJugts/X/hWVezLAOHe7AwxLx7jAXNO2FOEdDS2XZYkh/dnOQizxt6X27+GFGwaZ6VPMYq7NqNBlUL5O5k2cK5ma00v5JLAkLkzXkw85DC35xDj8nZipLQ6X7aUTeS0l3HE6KcOKs7gQn7B3IxPG6hBbFk0sY78Y5gIJczghWNLGQ+KA6HgDXGXpWALT8ibNlhIdwt+ioA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Jan 08, 2026 at 11:24:07AM +0200, Kalle Niemi wrote:
> On 1/2/26 08:59, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> Hello,
> 
> This patch got bisected to cause BeagleBone Black boot failure in linux-next
> version next-20260107.

Can you check if this patch fixes it?

https://lore.kernel.org/all/aVpWpLV4Dut5Muo2@kernel.org/
 
> At the moment I cannot provide any helpful information about this.
> 
> BR
> Kalle

-- 
Sincerely yours,
Mike.

