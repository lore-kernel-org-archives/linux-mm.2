Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 397BAC98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527BF6B0088; Wed, 23 Sep 2026 07:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF3C6B009B; Wed, 23 Sep 2026 07:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF076B009D; Wed, 23 Sep 2026 07:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17C7B6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:55:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94D82C0735
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:55:57 +0000 (UTC)
X-FDA: 85244873154.14.D08E757
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 03BB940009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:55:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYz1Pt5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164556;
	b=vtDAVslUYI+o5JsO7Rp8INe+FBKWXRF7z9sh+FhNj3i820gbidQVawjaRMu3IGTApuP7CD
	gXEpb0BBrodTFz13MHP9zuUHHn4dLNE/3lGbf6ZDmzKGV/BfchLTp3eX1PRqMNdIA30Qn/
	Qc38/XGTVPoa/k95nSHeYMDzpRcjbMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYz1Pt5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFgWbkSrnnzB4diBo+Fp62kuEHCA64AGOW6NYy35L6o=;
	b=8fxWDcjpzymZwt7UpjGI/ZC6vQoopNQ1bdqBxbvGSi4gsxL3TiDi91MrZK6alu2uXFI8kx
	Q/zUmyYIhbbglqezT5SVgHpc0kMP7CxTiSfAHRDGBH6RMJoaxplunOu+f0qmoqG2+2NLiu
	d/nN7dp0Fk3Ymoe+dbXnGwanfRJXbE8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E9936021A;
	Wed, 23 Sep 2026 11:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE8B1F000FF;
	Wed, 23 Sep 2026 11:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164554;
	bh=QFgWbkSrnnzB4diBo+Fp62kuEHCA64AGOW6NYy35L6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gYz1Pt5PUhNtjbLXn1RLrw2dFysefT++UNiHs/SY0zWy5shyg/oEU6E0yjY37gDeZ
	 9rsf10akyHx7s8T7g8XCeeIKm6JD/TBTo+rbL9FidMwyb4MQL2taRuxWv6XNsJ2Tt4
	 N784KzTEgcnkVGUYZhttWOE8oa6UAPy77g1bCEwXeUUTBuPyaUy79r/OgIPnXhbNZN
	 GAd8MzN+orb0DLZflODRpffDhPgXrHiWn71IMcOoF/KLaOTeF7y9kFNYkCXycUbuH8
	 FWnYsVp3707DiRyWGtxaVY+tnF+ffZNWg/NkRfDfo3LM1TPERhDg1+mA0b1Bx5ZIl+
	 J0ITAsTfBBCkA==
Date: Wed, 23 Sep 2026 12:55:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
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
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 12/12] mm: change the contract for free_pgtables(),
 update docs
Message-ID: <arO855eMmfBYoAON@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-12-fe1ad1f1e303@kernel.org>
 <92b52e07-39e0-4df0-8b8d-ffa18ccc8820@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92b52e07-39e0-4df0-8b8d-ffa18ccc8820@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: d38hyejt8da6uforgyr54mjsxxantn13
X-Rspam-User: 
X-Rspamd-Queue-Id: 03BB940009
X-HE-Tag: 1790164555-259053
X-HE-Meta: U2FsdGVkX18O8CbtnOJCB6luFM95DG3drvUmNkDJe2G5Wxjh9qc5Jx7IvNjVzFpHyk5rEMMEMk3boMJ/lui3QjEr+DzUhW5LATx9wcm6SQpeIHvhQR+qKrHcyg2/mGmwzIMnxVzDBmsCP19p/84fHlotoQ/a0W7EkbN5YFKLFNn5ODQICSCLISz3qeuk6BhapTUB/+swQoD65axjUi2GfvJL3pPjTP2B955IHNlgWjEpgFhi2GVtF7zIId+i1VMantRFLVC4DrS2yf3VPn+1f3Lx63kUkZEx1y1a2ttlvoXvU+UOBM11YCHM4jMikAfENRNXQt9k7j/p/GdbycmKcW+GlBm6BSxcxzucTsT+kTmTvLlHH+DU+x8k7PsSB8yF4Bk5q0sQMaL7qzFXtTceN3O+ygbFTHQFzO2XFiaYYt9fbsPSVDqk+/6qmJKgQjNYt+rthr12EjPfKZ/UJdZY31fAflA+PMMiiBWHayTCsYNuwBR+jX46IpysaWnLD0fBAEZ6+EijBvh8wFFfVm8EPWndSH67+VIzQz/EcI2QbZjkGGlWt3tfe0Wp3H4Z2dd5TqMlSAPJAkxPVWOp74bikGgTIyAkuXDGpH0yaIkqXxx6Z96K+08p45NWqV+ws6YmrEWCV+cuJ7ZkaJSAP/EGLOiFW/EW9UoPfasuux/JNmO+POF87aEZCl9TcpReir4xQNUNanjN0H8R20zZSq74CcyRtKPYeWPa5rfHKwM51Mmhh9F+2fwu0nBQD4dLra3DR/jgQ/zBoQb+rhKGLorhhtYhWxqJMoKGWlbRHxvsklItcSScQbjBRF7iw0VNCjsY9p9nhLIXjxSzS/Yl6Z+Con1G0ybPXS3UeGjeve9imfY1LEtSlh0htnJNi0OHluWdiGiS3oAd2RfjRYSNgdftC0QbDhMkWe+lSOfH163AfJtkJuX5KOfV8J3r7apGNAbYiRD8T+HpW57oRUolRmi
 SDqPnLa6
 9MF/ebK64luMV5vhOqvaQskL0e2xQZMllpc/GWcNh2ov92ju8FAkvbAv1fMQXT5weeWoCVhrneGJ3YIpCvKHIoDw3NkY0zu8fvrZiKevM5+TufAePpTQ1Ub98zOR/1NyAv0RBhStoDzfF5YH4N6SKlNyL8zB0PqacvbWKdQC/1YhngOLcXyOMzV6JgingvovjV+yySYTErwWsobTIPUF+Ki4RmDQ/PQYoulOERJwGCOJM2Rqn33ED+jiXOr4IJ2j7jKLl2REX40H4kk/XvlUck7qNrbNl4pBDGi7vd8VpRMtSDUPBcpqymCtWjEtjuY1R2uNTLMt32m1L7YGmWoL9RPP3mNympWV8iuENj8QXOIc4DYRdfO8iW2Vq/qBwjNFk6zSi1DjmdG+OXhM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:08:11AM +0200, David Hildenbrand (Arm) wrote:
> On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
> > Now that page tables are freed after an RCU grace period, it is safe for
> > read-only page table walkers to walk page table ranges that are being
> > concurrently torn down, provided the mm is kept alive via mmgrab().
> >
> > It is however unsafe for writers to do so, as they must obtain an
> > appropriate lock to do so safely.
> >
> > Update the pte_offset_map_lock()'s comment block to reflect this.
> >
> > Similarly update the process addresses documentation.
> >
> > Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  Documentation/mm/process_addrs.rst |  6 ++++++
> >  mm/pgtable-generic.c               | 15 +++++++++++----
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> > index a7296f251799..b1f4f44d75eb 100644
> > --- a/Documentation/mm/process_addrs.rst
> > +++ b/Documentation/mm/process_addrs.rst
> > @@ -537,6 +537,12 @@ We establish basic locking rules when interacting with page tables:
> >  * When changing a page table entry the page table lock for that page table
> >    **must** be held, except if you can safely assume nobody can access the page
> >    tables concurrently (such as on invocation of :c:func:`!free_pgtables`).
> > +* Page tables may be *walked* under RCU alone, as page tables are freed only
> > +  after an RCU grace period has elapsed. However, any entry found must be
> > +  revalidated after the page table lock is taken (such as the
> > +  :c:func:`!pmd_same` recheck performed by :c:func:`!pte_offset_map_lock`)
> > +  before it is acted upon. Changing an entry requires the page table
> > +  lock and one of the locks that excludes teardown (mmap or VMA lock).
>
> While we can walk the page tables, I assume there are some limits to what we can
> actually do with leaf entries. E.g., Doing a careless pte->folio lookup might be
> dangerous.

Yes.

>
> I wonder if we want to hint at that here: that walking under RCU (traversing
> page tables) is something different than actually operating on the leaf entries.

Yeah I can add a new entry in the list perhaps like:

* When traversing page tables under RCU alone it is important to take care when
  operating upon leaf entries - if the value is operated upon (for instance
  getting the folio associated with a PTE) an appropriate lock must be taken to
  prevent concurrent modification.

?

>
> Apart from that LGTM.
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

