Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE36EC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7BD16B00CE; Tue,  1 Sep 2026 09:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53FF6B00D0; Tue,  1 Sep 2026 09:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44CE6B00D5; Tue,  1 Sep 2026 09:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB7F86B00CE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:33:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B2DC1603D0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:33:42 +0000 (UTC)
X-FDA: 85165285884.26.59F43E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E3B240014
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:33:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndLlqhHl;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269620;
	b=EtNs8kXN5ozum9RgjvbDjkf/Cup2KeSotLOcXjyCzkou5VzHADS5ouk4f/93dk9z+Nt56j
	I+GOIUktaJvZaarZxhdeZCk0u5fCWRC+ATbZgBcTxqS8pkxyN48CdOmOMwJFCsj1XsT+Vb
	xFm+iecJXsrf3S82uM4YcDbBBsP3DbE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndLlqhHl;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jcbNqyZ4CJOFUcx+fZWWPKksNhyQwz/xPjmgvkWytSE=;
	b=zzbItJ3+k7NjGH2ycq/JrXB+VDCHoBe91Uf+TQShxIFXhTQmbTQD2WhbqBr4WEUS99kKjv
	rPDHDQiYgnvVdlZDSgxt84J1HIeYUtdBCN9X21D5NYNf1QYGUilj1Dq32aoRqWhXxPHuwm
	gPsH+nwy6uX+I8YmMB8RtugoruCnjGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E7436020C;
	Tue,  1 Sep 2026 13:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C1B1F000E9;
	Tue,  1 Sep 2026 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269618;
	bh=jcbNqyZ4CJOFUcx+fZWWPKksNhyQwz/xPjmgvkWytSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ndLlqhHlVeL1h7g7ph+Wt2NFtmrZ4rOV34TH/BkR1LV3hXV72TFKXBa6SSiWah+YS
	 osor63kOccehDjmVkh3sQpwcQSMSNYVcFsZhRDfV0BOZWC20X/uzVpPoz11vEPx72u
	 kLe6Dj8pgXjqMdQBlQ+iOksFRpcAk/cRL2f/1AsjTtd62N9p9KMdTkAyeamslLimmh
	 rePS6mrE/57HAXFkLSbWMR+W5a6VAq9eNnH/iI1RsHXSsazC5suOIyBDNrTwwP628+
	 9FLGn6PmlvlXDRo7ABVcbcGo7/AsOm/eX+GOgiWGn/e+QIZmVf+XE4geioRTZyxcRH
	 0zLk/FGxJh8gA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 57E291980064;
	Tue,  1 Sep 2026 09:33:18 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 01 Sep 2026 09:33:33 -0400
X-ME-Sender: <xms:HdSWar0zDxM1rzMXPVKSiiHY4KJJXKW9_dKFmXqdbTa_fmaDqPnrAQ>
    <xme:HdSWasJnHNfyfuCbnPXJ41QnOfMcQ3IsJbdR3mnGKXr-4wj9FELqFm8ZdfeRPj7fy
    bnm6jh3UIcKaloZqTodN2-BguOMyRSr9poABUPkwGcmSl04lFepx8g>
X-ME-Received: <xmr:HdSWamc0hBDzYeZ6meHT1N8NrjNwQDlG7ndA51A5p6yJYm1erjaIFQqZ_aA>
X-ME-Proxy-Cause: dmFkZTE7XYI88DUY2gRkJOK6+ZyCIFoNn8bzP7pT6CkwBKHBvKWUe6kvcLZyJKqoR/mFua
    tnuce/0i36y0TC7Im4WvZyoy/crD2rPu16GAU43MkToFESYNa+q/dgDmYeFoLAKy++6ZgW
    8jn2vUxLTK4d+JU7NpIMhvmFWN+lBL6CrhfWBNMDXcQ2eFN5VMfwvgG7wpe8357MD3J5gK
    7xFBRFrqPTsz4yMLY+EEChvmjl1qNNrFzTmc4wdkVOaUc1KRt3nz4X6b9lgB4AP7QFsDWQ
    tYyrUQvI3wO8SrGFb+1aGvYLJgVsklk3Kc0+LAmLAEM6pSFrAQvRZGfFtBIFEXt5smoDZ8
    0sIIODp3p+XbaMM1IQmfCvE2+2bbjw/rRlbPqyxvx3AWjW0wx69YF5Ocr+JktO0nTZOok2
    HEw0ft0H3myd2V1s6FmW7lpkinX5D+jdOQrkC/osJIL3mBMTcjL7XfwqTbI8tt3mank0qt
    BcT630GiS2PTitGfmJ6/iVLTorQObFhmiWUpu/4o8m4w+lLom0XGtnouU3SvS4FcugWWNZ
    7nEECz0GGK+6YbBSmEMxBhw/vyLb4HqtpoQS+cM14FfTsm1gjY737Jmi4qjcP7ghw4NaMo
    mSjmk0LJqLELQl49SSqDTw86/FRQj/i6o2/Z7vFbf6wnUbIU1mKMMzFy+Xyw
X-ME-Proxy: <xmx:HdSWaorGnJV8X3w6RQ6-yTLBHwkt_MBfkV8RsDaiRQlkH0hCDXuTig>
    <xmx:HdSWam_C35Dm2JBzL0A5fzPuG5ZvMut58CN7trPjhfIb_5hDuszCGQ>
    <xmx:HdSWaobzZlmDe5Y-27Rtv7XIlXhpki_IJYzJN_lp2MB6mY3t1TeGow>
    <xmx:HdSWam8XuaM7yobHeA1s3aD4FW-Jnsz8789jiGSamkl6EtIN7IErBA>
    <xmx:HdSWaoYZmoLC2txSUqseUpEqs0XigJd8k-YHiiGmmzkLSGyss1bakguf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 09:33:15 -0400 (EDT)
Date: Tue, 1 Sep 2026 14:33:14 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, 	Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, 	Usama Arif <usama.arif@linux.dev>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 	Geert Uytterhoeven <geert@linux-m68k.org>,
 Dinh Nguyen <dinguyen@kernel.org>,
 	Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 	Yoshinori Sato <ysato@users.sourceforge.jp>,
 Rich Felker <dalias@libc.org>,
 	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, 	Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, 	Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, 	Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, 	Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 	Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 	Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 	Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 	Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 	Sven Schnelle <svens@linux.ibm.com>,
 Richard Weinberger <richard@nod.at>,
 	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, 	Arnd Bergmann <arnd@arndb.de>,
 Vlastimil Babka <vbabka@kernel.org>, 	Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, 	Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, 	John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, 	linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org,
 	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 sparclinux@vger.kernel.org, 	linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, 	linux-um@lists.infradead.org,
 Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 11/12] mm: make userland page table freeing RCU-safe
Message-ID: <apbSaL0YaQqtO9XB@thinkstation>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-11-5456a81c8212@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-11-5456a81c8212@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E3B240014
X-Stat-Signature: nxps8jy93u88ot88z8y4mfz6b7ks7kz1
X-HE-Tag: 1788269620-697702
X-HE-Meta: U2FsdGVkX1/BXAjO7Tk4HXvC0pPb1/W03GDVfPCXwBfmrw6pRXzaFIskWmG9f6MxPQbbZjmlXuNLyxwYTxY1g/bKt/uZ2qKx8BZzHVRcXs2BTjQceYquNY9OImaNCVWyjZZ0zpygJ+n5DUaC48E0N0HsSQr8IyIwvvM8i8vw7/KuOUYDuRm8MWx+mqq6mD2svFM7B/+apXUi61QM3tomMLG7rTgoqLPkfso+J0L8cCmF7l64r98a3RqW69uY9wegmSJcIas3sZU06ojvXJo+GUyD0iheeRfmIuYKYO/dA0kKtphcwQaLHjEp2uoWoyVlII4RhddXtGgtBaJi6uxD39QhpxcApRU4Io3iyQfpOY6/zULXHoPuxbPP5nWLI8zo6FSeD5t922/VZAmrmi6W9IpPrbOrkYtxEKA6lHAk+ceo+0lu8LqPCCDPrl/U/2JZKuboTd8/EUmtQr5B0LeZ6ay3rKTX06rs12gtNJmvFvwGMLF36vITcksrOzymX0qJ5F6YHYmpA2MtlpbPvXpmILPTvCyApe/7RtzE/7bF7tLNcqfRDkoKeiXCFZxKwP78OXI5odtk26DpB2SOSACvbn82KOoHLpX6oYC02LJINBvK7+BfJRvzyfs2eoBIiu7DsYJ45kjSEwliRtcfHevq40pqLAqcxGsTFBZKXsy5H0uNEJVSOhRthsDsyjtKI3Er+iHddsodQ2SfOxqhlAvDnO8OuulG7sxAktc/MNl4Fpzm60e8mzpCpy2lAWEXIxTAXmjoVqJm67g1/hYq8AzpSoYlfmz1KSc1N4pYzg1AbO04g+mlrve8jHlcj/1m5FcLN0fyQg08de4yEsztx6cef2bzHaAaQwAyuNO0eUfLRLB4v2av/Ayv1jLlaZydmUJ9WXWvAUJG3F/h4PHfCm8CMqOTvzco8Ey47lTuHRYnMzRoKOZBjT/T24Xko0RCJkkp7BR2hDVytw0t6ZZRsKu
 3uU8BT32
 Loa+epfXIU7Y8GF6wo1B2VOpNpob/aT2I1dBokgcH93somJokUL+72fAV2rLAM6ZvIeU+xMFVGz4PnjpQDsvh5BY+2viJpgfyRe7V93Okp+o3N3rXwdGveGqp/pGf53vILlSTfEv/GALKgTMDrF+8ujM2cAZah6jSY0bhd6NNhRlYNZ5RYF6GZdiUKTkpJ49WM8zuDw7WIlcC87x8qaabOxvC9ebkniZGAaXeeHdsNQNj99YD4NvuMl510ail9+l0QNM4IUaxOvlXQgvvok3usIAdfLfQwqusApt2dzetyk1BQmYhgIiNwabJNL308D66RCSy3GuY7uHnwbz6tuGAtnofPhzPZSnpq3Pa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 12:01:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> With this change in place the kernel policy is now that all page tables are

s/all/userspace/ as subject implies?

BTW, what is your take on kernel page tables? Do we want the same policy
there. pagetable_free_kernel() is not RCU-safe as it is.

> freed after an RCU grace period, and thus it is now safe to unconditionally
> perform page table walks under RCU, safe in the knowledge that page tables
> will not be freed underneath the walker.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

