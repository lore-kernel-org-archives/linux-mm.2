Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A737C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8486B00A9; Tue,  1 Sep 2026 13:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759266B00AA; Tue,  1 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621866B00AB; Tue,  1 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33EB86B00A9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:12:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD8FF120494
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:12:26 +0000 (UTC)
X-FDA: 85165837092.10.CA19ED1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB06FA0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:12:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7xGurub;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788282744;
	b=7jfLGKX2reC5nL5qyQSotiU3eDYVJBxmy8SxGpQP00BL1YwD4Rol/TBSr4hyOe8Vha2RUA
	YJR6J2xcKiY4kS6fuQVEYAWXsq73AymhvbH02a4GE22UyWciYUtc+aNLK5wvRr6jzmypEe
	S1FkHzBY7xJZV9HSGWdb09TCFBKPgao=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7xGurub;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788282744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StaeALLek35hMlcSHa6BZyUhT0ljTsLx6yTS5xCyYM0=;
	b=lB7oOQcVEf+IBdQ3O91PvySffHRBAXZLIA8u1LdeCHeR71nEhUCw2QS+zY1vzpDgMNlmW8
	6rQX50+WwnSMBtqqFL54ubrMiTlCahMUJYlcqdS6CcVwCzXSUSWN2aLwd12LTvaoQSyYZ7
	q3G5dvQdE4U3aiJGi2feghfGQzzgd0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECEA9602D0;
	Tue,  1 Sep 2026 17:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D9A1F00A3A;
	Tue,  1 Sep 2026 17:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788282743;
	bh=StaeALLek35hMlcSHa6BZyUhT0ljTsLx6yTS5xCyYM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F7xGurub5lZpjDs1aDGfwYQjsUqqlOosQvLNchGQQWzDsAsXjm/bfgFuGkM+2goEl
	 A3tZmuNFbM2kRhPZvh9S1P22IeFE5iiGfDDDDd17F5D804y5rPdv5sEw5oeDGtpjHk
	 8fMhWsj66KRnRGkecbBoYbTDb8JlfScb/+tAumYYrtdivETCM9805zMhAy2jNPFBgG
	 3+rxVhNNGTh6W8+MHuBjYezyNfaAPbKmDaQDJzZEL8uqbRiqCFQhAdUZPRkTUZSKA5
	 Y/Jp66nLB14uDCATCQFaq6J05pPq9ClrATCE9vY0dAVxZMs/4MGJpMLvDMj+NbBsPA
	 VSWBMdQkIOIhg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 509151980082;
	Tue,  1 Sep 2026 13:12:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 01 Sep 2026 13:12:17 -0400
X-ME-Sender: <xms:YQeXarupuu8lP4hODV4Kl4cTBMZRESUvNFli0neseEvSVdU6eTqegQ>
    <xme:YQeXaujYR-JcqcZ5XRB19_Sp4AidO5MknnGtlz5Ss_8D6FAekB1GDKTys9TKm5dQ7
    9-CzIWyGX5yW7Y4wxP7-FxE2PboOlz7Sija6KJsrP8cvzQQUwq3uQCR>
X-ME-Received: <xmr:YQeXapWFsxw_1UNeqnO8z4EZg2oOg-FIVaehIEwbl2C9sTmSY05S5RPiU9I>
X-ME-Proxy-Cause: dmFkZTE95wHRzu4Jku/uqR1uWajKbrR5zJX2cXnYtALksDxTaOWWCUqT0ALShYzFchhR19
    jABbL3NMpQdq2Q4yk1wxABfpkhz1tXbwJ0ETPbBKtnkrOsetjBDE6HJPSHCSzQ+lV8p7hR
    m8B5tw0NCYc8nr5KG+JJnI7EqrKbJ9j/iB4uBQ8v3yh2BnmhuMnsKxLkWZCbcUsikaiaIb
    afOgG11+NHa8fIFfGiaQPV11ZUcZ/PxqcPGfORQq/nrNuM+iA2OtyKWdZtMIzuN7Y+Bitk
    xOhO/HMBDeF+31R8MKrPNSYAO9QueQgK/MZ6ZozJxRSVjUBLpeca5t06PFY2rHErDLj+iW
    2yn2As7fL8DmU2YIyhDqY4qqwa2/ZrsmjL2YjjyNf5Ut5V+o1Q2jHYwdnRpVE4qQekDIlA
    0QFGDvxUI/D1PW8k3h1xG2sm2CMe+07Xc1+6x36TyY7o9SD12A1XaguCEJgvlOl/E4/LPo
    GFNx+zoYsO4VdClgp1h7hc4suTeM5K0X91cofeEj76CiP8ubXYR9unXAMBRmzaTibsCFRl
    htnRbe1HGqYqK8cW0PalkL3qgmd3CH6stsr7YLE6PHlCrh2N2VCi400sm4iXeFTUQOgmsx
    q+kN/77vj/DcD2YNv53dz8Mkn5XTiexA6E9lSNNFtklTEqyElGj/pD/1naEQ
X-ME-Proxy: <xmx:YQeXaiCrGQOdc0DQyRgUDZV_Q7rbwwtsvYy_6612aWm1Dw459aKeLg>
    <xmx:YQeXak3aszLb-RuoyQQti3VDFiBgP4eq84UZpaU9PzzzbGI3kIPqQQ>
    <xmx:YQeXagyRzlL5sf79pX7TX42r92YD-ITwLJRci3UCGMw3KLjWYgQL6Q>
    <xmx:YQeXan2N5VeJKbhgyOObCD-q2vQfw0NbQQLabtDLgtNHoJWCeTl7HA>
    <xmx:YQeXanzxgCScGaao3xUiAb6wqDwwmrMtpplfWrXaivHsO8SbqI1rMQni>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 13:11:59 -0400 (EDT)
Date: Tue, 1 Sep 2026 18:11:57 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
 	Andrew Morton <akpm@linux-foundation.org>,
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
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, 	linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 	linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, 	linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 	linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 Hugh Dickins <hughd@google.com>, 	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apcFUthh0XSFg3JQ@thinkstation>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
 <apbiB51hjm-9pRzf@gremlin>
 <apbuO_QveZNAz3ns@thinkstation>
 <apbvoN6ttgHfI_xg@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbvoN6ttgHfI_xg@gremlin>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB06FA0009
X-Stat-Signature: 3bwd5r83x6gmic68f3gnydbzwppwq3ih
X-Rspam-User: 
X-HE-Tag: 1788282744-855927
X-HE-Meta: U2FsdGVkX1/Z187kBv+ux6DwANalu5wXkQ91Yu5AE0as4rDvzxcm8JuOE/GyllcDZ/68KCT56Z9sfEfZYYG9DoGtGRQFSutJqWnMQeqrhS86OKpVJ7+N1l7CsP1SKwmPjpVBldBi/P7os6BnO/fhU6rQtsaQdFFPeSL/hMTzTEEESbxMdC16N9Z5um9VF1xZW5L67oKC+qeKNIb4gB1AMW2nrU7Dt2hRmbV2OLu3JxupWlH1VDlnkV8vcWzkcwjRY013Ld7u68tSoam4rXbRJnZWWZzEzE5PhqkT2oMyzTiIe9MwHvpSNQCmkY3IvYZ+MMiATlFzUlq6rsgGgpK7fE089DenyLj0u7LkpX7P4jH90PWsXR+7skCMULLE5gO13p9njCktrPS35l6lN8g8tSSmbi55rh4T9gmZnRsj+DkLhRbzFXYqkfvP4gcqXO0gAclu37l+ek7J+ASzy8Vg62ztVDtgP7JDXfvshf3F729UK6H5DZJXWxIS8UNXUMyW5mDxNCBq0R4fL4NEnlE4RCT+UadtBgRfsKgzqXLVnw+yTgvPWC6Vb7Z8xfIS5fAiqJgDEN6udplvYn12y+AhqKYlIB/ppqhcRGTq1SmMD1QNrXDuUeNhx6dc0ulpRz5GyYh8D9N9msSuIWve5/ErUpvRm3fh27taTJJuTtUrqABo6gSzRXYbICAta//lSO0B/fHOIs/l1HPhUPbG1LDqc0K5/9j2KKSzXryVA94LJ6Du7dLbwJ3RNnJ4RupL6zLzHi3R2es1+OV9RiZQzg1LVVGQmfCAeECS5sIlvUa/0m4VPGceLdAtPZS2js+ap8BdKYjsIxJOShGidH5f0LIQt8ugpnK7y+E84BepzdwITGSV5xP7tUVD94EnWtYucr43I175SLnjRAtURNRSiQzZVLe4rrT6/dK+zNFXThf4+aR3PiYPnf+4lCwAZQm15dJy4YIBAuXCVV3Q0O0kZYb
 dyPOecRJ
 Ok6MCyOO2LiVqBS1amBjMenKVGCTqyH2U4SUo3hjxF8THYSzv3cSjLFKohtfPwaRG7HiVwjmKjCj9jSnQSo0kk61ijYl/cviBUr9cEpVMFgzWhbRuSbu8/0u0uQCLRgdv/cR8KZ8zRngEK6T/QSRau3h7HtQ9v+YpamrZxakNEfcki6F15q6gdjWHfq6QkliVRPrlxwirtN5MADz++SBENBbEeMjrGwwKxY3wPJsUGnfJbGXt7N6U3YFf+Tl+QIB0nyC7CsTh733QZliCc4pjD61fvI6j65f4nVt16n5MFXeTBx+Mqiz7Ya0Uz1vFq1X1eUR9KvQvsxNoMN2aT23lYHWwcqQgaIn/ZAzwJBsisiY4i9oaWxynC+DMGNYEAmte0QRe4bectaOHbhK0ChgHa3K2Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 04:45:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> > munmap() of 64G worth of THP should be enough to demonstrate the
> > problem.
> 
> I mean you're going to hit that from RCU freeing page tables already, which
> most architectures already do right?

Not at the same rate -- tlb_remove_table() batches into struct
mmu_table_batch. One call_rcu() per MAX_TABLE_BATCH.

> So if RCU saturation is a problem, that problem already exists, but I've
> not heard of that being a problem at all?

I did quick test and I don't see a measurable difference in munmap()
wall time of 40G of THPs. I see ~17x more softirqs, but this is
expected.

The objection is retracted.

We can return to this later if it is going to be visible anywhere.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

