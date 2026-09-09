Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 960C5C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DDA6B0092; Wed,  9 Sep 2026 05:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620B76B0093; Wed,  9 Sep 2026 05:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6386B0095; Wed,  9 Sep 2026 05:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6456B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:26:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D381120157
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:26:30 +0000 (UTC)
X-FDA: 85193693340.24.7B8AD4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 52B3080007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:26:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3hNuKz3;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788945988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YX/JSkYghr9nrINIMWcFmmh29g3GmX1nU9kCwJO/qRo=;
	b=VWNG/eCjQWC9ougx/muTTgDBwcab5DAWmYcATuTdgJjAkpRdpKMMg7u1GZDOqgIWn6NqsT
	TsoOLyxeg/4rWby44l9bOIpArIW8Sl3IsLXx6v2uV7tF7NpvZI2bR6rmaiveOEuV+SnbdB
	+e1xbU9/M9ZmJrzVtIslvLYZINT0Ixk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788945988;
	b=XbHdJYEoWbO9uwRIrGWvukbFRzyUIf018odYE6ZSUYZHMx06/S+Q6EpOL5FMyjFvKPf755
	stYR+ea+YOEy3i85XD/lSFLt2Owjjb1EzV43cCkGcu1nTcKEtdz5tZxjMufcFYBZi3fOCR
	FRcskBbo9v//YEJRjG+U607e+1Wvlk0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3hNuKz3;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84049601FF;
	Wed,  9 Sep 2026 09:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337F81F00A3E;
	Wed,  9 Sep 2026 09:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945987;
	bh=YX/JSkYghr9nrINIMWcFmmh29g3GmX1nU9kCwJO/qRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3hNuKz3OgOosFhevpA/IqX36FPKhUlyv3lVsw0nO4Q+4iBZl/clJgolxkJENxlW+
	 t6saypoG4p8f2rOaIqxJouXLfbwGSBJmqkhTA9IoVq2e8cdm0lDPKvINT3bQYZ1OCx
	 WaM9SWYsHM40rBkUpzpJin5l0bvytMAcZJNPrVD1ZG0kQjBHOgqAl8kRnLHclGAK4u
	 2GvxIgrqW15jpgq6k0V9Z3OGDWN8Llv18W9TYZPgWGAcuRDhj92SSf+69DAkaT17id
	 633vQ8gtKuc4OEm1aRtDRgQTtxgqkZRsnMJadehXtqzhErBkyngMzyHilQbpi7ZahO
	 Z3SURmZp6fL+Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 36DE6198003A;
	Wed,  9 Sep 2026 05:26:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 09 Sep 2026 05:26:20 -0400
X-ME-Sender: <xms:LSahakXWIT_tvMZpAA4tisSYzPACPbNz90sUvrKt6CnZT7f0bznCEQ>
    <xme:LSahag53DfWVoWKflreXJqLcFkpU92hBAWTzNjRTqAW2ze0rgIAhIsSChKIn5Ti_6
    KANr8G0vz3pvYzhqK6VUilcolUQhOTSLzW4l2jvSqWcWV7i5Wr00qmD>
X-ME-Received: <xmr:LSahajm1t3WFULvmjgrvyoRWrSpX6TH6JtiTt4jZbvxEM0QXBcnMCsVPuQM>
X-ME-Proxy-Cause: dmFkZTG4Xf5HQCh02zpqVvbKCxDxzvOSSyHgHOP3uMLvoamU0KCtlJg5G7fmz9Cf9LwJ4+
    u43d35HyzgT45XS4YAKZHukESCUbAy6ZShLloStMpjHT/y6x5XvWA6PxDLOyWt9+ikMKjc
    zETlWFHuSZ8ORVsn+jAlUAvv2EBzWWsscPi4QFgDlrLa3yw68FIjtTKVaZqM0eJSg/GuFG
    PATxH5LCPqzMkEKCwvoxWevBpaE5KCPic5zvLKY5EIapHD6v0GUJQwsC7esq16fDb0nPXf
    16/0Hsa4P7Gc/AUvOZ0A8A9rcDB4OFqVFmJGna/qdlpcowZ2nVhVucQOP/2UhdOWkjcsJG
    bn5bMQWMV42DveAl7CVcZkwPb5GLbvc1Cf0IzGc9irZASBEiK3FCaxRyq1M73CWs3bmbiy
    ff8K3sgP/N5TIqIlCpWMeIHRSWHEI6dt3xf82VJDupYGSlhNmr9yqFk6w/2dorxNJoWXbf
    YgPEiAWDmBrJh7NfpaNcz3nd9MaiqYGNbDW6RIkrAkS9QWCGiiWtJzvkou0Tm89GVe3kCZ
    2dXCb88A9l1toZ6Oe2eQbItaBH+l/shJecWdB3aE/wGnes1LHEntmse3E+X5e88WLWEJXk
    LTYzE9igbNTFH2Vdd7kfG0gwnEhXZFP9DLJvxDWPIoXNnK4NDvajy5q5fhuA
X-ME-Proxy: <xmx:LSahaqZiJgtSP1S1SXg4ApLr7vjawzMbaok1DlQFBAfjnNWf23YTSQ>
    <xmx:LSahavGJasYuwmK-LtmlKjypYyuDUaWGs252xt1j5xv93UHUhE-04w>
    <xmx:LSahavvD36JEO0uwWjWHHIu5-ZNg6oK3QNWBiPqsc3XTl13vJahNcQ>
    <xmx:LSahasNhB-3rvAirGtHcE-v5Ps2Pehi66hIVbkaqldNeNCBRdVfH3w>
    <xmx:LSahan07FiGk0MNCDzy03CWVja0Qnj4KqABWoK0gdzZFR-lpCNl87xrf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 05:26:03 -0400 (EDT)
Date: Wed, 9 Sep 2026 10:26:03 +0100
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
Subject: Re: [PATCH v2 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <aqEl9zv8M_o1yW62@thinkstation>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xb9q8tqe1xfw96ui7zfe9t5t4yf1o54y
X-Rspamd-Queue-Id: 52B3080007
X-HE-Tag: 1788945988-22817
X-HE-Meta: U2FsdGVkX1/4AkDmI9UVncCPXrFH/cEwTEnYPSzTXcMUzQAkw9CXuZds/O5Wom56YekArvTo5t1U1FIb00FZCLIAWBc1cK8asvNhZKCA8j0qdiqC1Ht1QK0r6bUIQ6EOqo3qecbp1Kwp8Osv+DXV9UFYm7PQCKjBKTUaURU/FUNtmW+BddW1+NZR+oX6IRBqitHOP3smo7GfhycK0eKEKKDjKJI/6y0cNaktpy18B2C5NYlbf4H89dutoWsrUg5kCwdyQ1Hgc9EQR0vvTgxtSMVohlk2MMoAuGuRjctQ1cFTZoL3yBF7OkHJENCD1CxyKmicdbQkHwRZFtbeyblcHctxbQ6owQq/q8UW5b0mTuzbHCInYpNek3pSUIJFvdCrOpzfO7MdVl70OgD4EAK6HzRmz673uOLpNHZJprcoFzRNRkJm0GpyXVlK16wivoL0n7BVZAETCiZ/Z+BKotFRBdnbF0sh/gUJYDVsRZoGE4mkQKjWHetjixD11DmwZrgXwTZ5efxExioXZ6DcwmpFpwtpQh202FT7+OcFIv6dVaTgzhDj3yb/KbmAeYHcrJ6PVOKo0aUKCZxBw8S96ER54sx8UC6VSjOpjn6SmIIvOTBNQgby3biIXx/kbShZf1MwWFT+CDUD6P0OAfZRR3EfmfLn1Bbyd+aNV01SDzQehgp2iTWJblNUPdkMG13nNMjy9ZQMnBfAB0gLJOQv99Ctn1wk4N4K30Qz5ThQgXg3PS3JERVc0SQ8E6qB3I4hrUMrQpgh3ubeFXnWJOigXqgAQ/g1R3TPY2e1wHupAqSYOkhutNLyACJLxwoTEL3IzyfLxxXfq14PwzB9c52hmIndhue8rQUYb6kFdmFqBkjRyIKjul+klkh5sfjED2Tk31bDphAwZU9a2H21mD/qrQEVT5RX8d80lgO9tvF8ykH8o2iqPRVGtPcYyCByoCrbsKFbGwedqrncF65NZuHmj+a
 cP1c0h0Y
 VuJ0eT1FZhCJP9AdDLxXiUjj3N09UHbYvK/IIW3Wpb+TyQELcyW9ncy1BZypKVLK5JnxqIlbuBvKYGSfU8oD461RPpH9NtCcNQgdEQ0RorDPgSIaUErLBwoGUZcP6C+vNyw2hqudJ18r4tZ4t/aUTnRU6XKbgDiMqkCZ2wAYZ9aZaleRkvjRZMWTD5nY+JEnxq6Wpwb6Oc2v2j6Ef4a+oalx4zGcmE5hvhdBIfZqKAlt0H3IwElF4xGiSmUeVkH9lWklKP7SAPmHT4aWL95IUheYa/OH4n/Th7UoYAR632iZ0o3HsURR1kyNtcQr1prgIsJJvHFA42XZNBjH48inGcN1NcGG1hKJCOIK2FlxNmtwfA7jjQLMv8X3SIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 01:32:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> The majority of architectures in the kernel defer page table freeing until
> an RCU grace period has elapsed, this series converts all remaining
> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> altogether.

Apart from few nitpicks, the patchset looks good to me:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

