Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 386FBC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A976B0093; Wed, 23 Sep 2026 07:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BAE46B0098; Wed, 23 Sep 2026 07:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9FF6B0099; Wed, 23 Sep 2026 07:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 160916B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:40:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89B47A07C0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:40:02 +0000 (UTC)
X-FDA: 85244833044.03.FB2AE68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BED8140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:40:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BVRkS6gt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790163600;
	b=O/T4hESXMVKLwHewHZKqwUsAHUgUu/LY5TQo+Q/ROkA4iFj0x0GwZfY/4OvtS6kY7m7nL4
	2Wwu0HJZuI08Pi4HQk2TjbpRLLXC4hox7lc5en3eYqUGhipDGcbS+hV81F5ewF4lVuk2uK
	egP3D1gkYWEgbXXgZo731kIFom/EisY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BVRkS6gt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790163600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLrpgKuhQkoqnu0vp0p8SbJmXaLTmBHhu9O+CiN2Vjw=;
	b=HVqfANyXV39QxzZnPAHeYBjT31j95HGSN9EQSHsAossYmKRHrakUd55FmsaA6RnrouCflq
	iwo7p2+WJGyyQG9sV42sieN2rWd8CvcGKrbsds/ihWeTTUCpuWo4qCzZqpsBgS5r63WLTV
	mOudj6Lu3aYWFThDT8PXOtVl9b7glpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6993540DB0;
	Wed, 23 Sep 2026 11:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8711F000FF;
	Wed, 23 Sep 2026 11:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790163599;
	bh=eLrpgKuhQkoqnu0vp0p8SbJmXaLTmBHhu9O+CiN2Vjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BVRkS6gt4XoYQOeCEfHPhRO7ByeHkhEEqQphfsSe4SuC1tCT0cXzY7rwECIeYfmTQ
	 3re4dkJjl7SIZd81ZkMc56LvPd1cysERrJMNbmXFLXhsqS3rtneWLoeLPSSv6Uv8w9
	 NqkNMMg1o3qPDa9QeTRxreqsGE9tRJkygczoThYC6QrTl2ldDxoW9x8DTR+mvQh2uK
	 s2F7yV0/wbhQRtUjiExmkJXBbJDhmPYa+/Zos6QWnaG7zkq3Gk8Aeud5bark6jRmzS
	 Xv0T5RU8A1tfwnKhxw4IPFOwigl65eC/Zok10skwSamz+CrUYHC1z0FbIRAVJRQIwx
	 NnBagpGL/fxrQ==
Date: Wed, 23 Sep 2026 12:39:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <arO6UpHLChZqAjBm@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
 <9dcde7e4-dadb-4644-9dff-7fd8a26e29a6@kernel.org>
 <arOVbT5B1FOMe1wb@gremlin>
 <77db2f8f-dfc2-49c6-82f6-8e6c4f7c1fd0@kernel.org>
 <300f92ef-1526-44d9-a01f-e9b8f3fc0cd1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <300f92ef-1526-44d9-a01f-e9b8f3fc0cd1@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: pmyndasx1y3qs8e1spns95n3wgny49cx
X-Rspam-User: 
X-Rspamd-Queue-Id: BED8140004
X-HE-Tag: 1790163600-238172
X-HE-Meta: U2FsdGVkX1/ty/qfLkbpN93x47uvzP38LvnH6GrMXZ0HX7iqF3Q2A/G6F9FlvaVQTaVfFdVbQNgq9EaTT4E9PnIBCKBIiK1eLu/BtFHmRXGDvvj/7RciVSGmKzRfuAxi94DRWnCHoWDdLLRRMZz9bSTjgyeqBBbDG82og0bfBi2Z2ddJVcNWwlOonDdcWfYikYxLhUuUtYSkoonyqUAalwlISmyxrq+H/sL+D2nHOVD7I+7y8b2GFlpolTCKuzrygUgS8kkFMgZeeGBQOK5iJ8W3BGZVOHxFiyKNIkIwYxVRRXe1AxaGD6etcvJGmfFSGe2ex5axAmZ99y5wLxMuA8c+IGB/M3pOFFu3IUrD18kHfQKoxyxtQ0Hcx+LIFwPMLJIC0cEKqJci1/Bf8p7uewP2QrfvyUPjIjqWGyprd7RIdd9Q8q6+W+Ayw4tb/08hfP8i9i87PZPzwV5Sh9wRJsL79s0zIJOChVQzuKAqChURDgrk0D5TC/FJH4lgpgs1rBk85TeK13WenBzfjS4Js/GKQ8D2JoQJRCcdMdCNpBkf71+Zcr7LmbIyoeLbKSwTos0IeQWoCKB8sDbawbDUJ5+iWfJdcJyx9b2N6LzIrDwygV6gS3FFv5sJKGki9/cpB74UI+sC8McmDcl3WPB9ByljUhEXTOOOcsc3I4p9VJaw1/yQxmX7RNSy6/wefrbfNWDOjGv+zFeLYGwfMuMSMxww0I4oBvhwxCchKixlhlYxfA+1Q2a+I04X7+R1+kXFtjlEkwGzdsiocS78PoXsrwJAfWQQ/0xVJiHww95eH0hCJppQWNx5SidQ+1t55eQPN6r3Qfdl2BDrYP0vd20r6HJLVl5pzr67ncBI07++dfIlR1QjnpXl5CrRyBmOePrdK1XgPVZfyDlEGTbw2hlQZnoRTTRQUATWIomPqGu5MFTNgss+niCYbYaMEVzlFbSaxGAcepgHFSjxSTWQffz
 k+WiZO2/
 9xmASOkOfRUmU+UlbIoYjgA2d6jV8EoJusUwEel/BP0f44hnTwr5JzChe1TAoTxUrMqgAepdKwCAzF408jZ+BZiEWp3DHTAFbegzKeR5bqjjSReWJ1Jm7vGzqN5P2s4SeErlEdnIlR5+ZoZipfr/HkFcYy79UgYDDw8dCoLy8HQ+wp3UWuTAktoe2egK8n/KKlsuq6kwmOJvWBxiMcl5pxEDgdY9vHA9MfcXAq5xBi43uhHuEGF28lC075eIU0fS/s9YS2GjsZMB4J2DkP8SlDt6RFKqRPtbWxXXlKVU2SbNZo572XLvDWKmVkaYvo6OTv9uViX3XMHisq6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:39:27AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/23/26 11:15, David Hildenbrand (Arm) wrote:
> > On 9/23/26 11:04, Lorenzo Stoakes (ARM) wrote:
> >> On Wed, Sep 23, 2026 at 10:45:33AM +0200, David Hildenbrand (Arm) wrote:
> >>> On 9/23/26 01:00, Andrew Morton wrote:
> >>>>
> >>>>
> >>>> Do we have reason to believe that anyone is seeing any effects from
> >>>> their arch's failure to rcu-free the page tables?
> >>>>
> >>>> This sounds like a rather long-standing wart, yes?
> >>>>
> >>>> The patchset is thinly reviewed and mm.git is bursting at the seams
> >>>> again.  I'll play wait-and-see on this series.
> >>> Do we want to nudge arch maintainers to review?
> >>
> >> (Just to note that I replied separately, 'thinly reviewed' is incorrect, it's
> >> been in -next for weeks and the whole thing was reviewed by Kiryl.)
> >
> > Ack.
> >
> >>
> >> The only places where that would be useful is m68k motorola, sparc32.
> >>
> >> But in any case it has been heavily tested including on every single arch
> >> listed with stress testing performed (I think I cover that in the cover
> >> letter).
> >>
> >> The changes are not controversial so I don't think that's a blocker, but
> >> it'd be nice?
> >
> > I doubt we'll ever get sparc32 reviews :)
> >
> > I'd definitely appreciate some review on the arch bits from arch maintainers,
> > but if they don't reply within the next weeks I wouldn't wait on that.
>
> Indeed, for minor arches like this the lack of review (it would be a whole
> cycle by the merge window) shouldn't be a blocker for important tree-wide
> progress.

Thanks appreciated!

Greg from m68k has had a look so seems we have movement there anyway! :)

--
Cheers, Lorenzo

