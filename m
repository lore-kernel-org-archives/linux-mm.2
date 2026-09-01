Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4981DC624D6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F09D6B00AE; Tue,  1 Sep 2026 13:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0E96B00B0; Tue,  1 Sep 2026 13:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A196B00B1; Tue,  1 Sep 2026 13:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09BB76B00AE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:15:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44A8E1404B5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:15:44 +0000 (UTC)
X-FDA: 85165845408.09.0F83810
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5771080002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:15:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EjDkff8+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788282942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGNWee/yfyIYUeq0phNhaEpYpUuczRbQOv0XGs51Szs=;
	b=kts58/cO4XCO9f8veEpCN3aRTHO7HNSDZ1C3/LqbsdvYSHm/EmQDEcCBLKr+Sl1lBJC3yL
	LQgFcy9+5ZVZI9dtw0M340bZEtRVFAldEO/EiAxHB8Fxk9IMvjCjYTMvxBjzJnm7tjgGId
	PDLM6B60/Vq8UKgBvVssyqTWPI+En3o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EjDkff8+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788282942;
	b=iof5DnyI0zIL2LOjgzFWvRcSQGgtfxild/OQQG17rI+EFp0wisQhY40pHK+BluwKM+0/np
	x3uQ6hr3u1ySmYF4J6MwvZTQFQrDczYwxq+YB6cwLnlglviNALt0ooPbjSILY5dtF8oo5m
	hXCA4QE/z92FvnNNxzvBOmKR6X5qLeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA53C6022D;
	Tue,  1 Sep 2026 17:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7DE1F00A3D;
	Tue,  1 Sep 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788282941;
	bh=FGNWee/yfyIYUeq0phNhaEpYpUuczRbQOv0XGs51Szs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EjDkff8+PB/PqMSdkvLTNkRB1RR2uQN6hGW85hkDNe66dk+tGPcziIsgxwIXFJ+9t
	 tbCD8FYmEfQQIAMLueKZrLVZKDA76MgFrGPoWNGJQOTR4Fbd2wzNFboNKFeQ8O6bgf
	 g9UmLVoDBcHSh1Bk0cGeKv2N8qx4AJAjr4n3Ab8kFFqwsIRhyTO9wipt15ul7+AfC1
	 ZzDvM3NRhCjFHcYyZfZTmOA/gtzXdArKE0hSwUNfLiJH+KEwFD+W9EF52D8D3QyBBR
	 2sQ1KYb4uykiDVH82Cr+sPdgF++1bzpUbEI2we1O/PSJA7oAGGEWvXkrUPiYIvBk7Q
	 gDzS6ddLMDyrA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8D10B1980082;
	Tue,  1 Sep 2026 13:15:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 01 Sep 2026 13:15:36 -0400
X-ME-Sender: <xms:KAiXamaWurlDWcSWtiiI_a8Lcfn91lpmibrmHgLKZ6ypEgYGgUt4tg>
    <xme:KAiXarwzI-qXlEY39EylIjZLSRQmv6T2YJJlC7pBrl-WfQSDaeds8uYj56TGi28LW
    lvu44LT0krOxbglBo974viVzoKsnxOQiDnBrYXcWz59mggZdBV4yEMQ>
X-ME-Received: <xmr:KAiXalWBs4NrLqXlTlwp0u3zvZXANRO3tSUHxaylIfQKC8ElPGDWAJQ9itc>
X-ME-Proxy-Cause: dmFkZTEYX5efotjdzBxG3ALFHNBriUAjRl1NaDQcBbtf545JlTWl8puARyoc1M48QLkTle
    Zy+DNI48newDPVlWImF1Faw5W1GdOvkG331QFNWqXsS36x8nYIvZkExZ02FyZDNo3imqSO
    vx+6PbbCZjIWTmWK3f9wDaPsdOrKllg3nPiDeTujNg7QScH79PdB1/uzR6LCnWC3G64VYn
    GHMdJtZr7tl3naSkkwKGVvaRI3xNIM1Vpn9wQM1eNoqT7XIGThtVtOA+q2qz2+cjtaTpZj
    qEM5PDu25TZmRuhbx6DVTKRpS6Xkl1hJA5Lrjt0ldQvhD92NmcHWzFHmiu5NS/Ddrh91RS
    oEIYoI6jcBVZRYEqPIQ3YWxmK7df4Xai0OPDkg2MfU9DIhhXQx3bsZyOPdYoBu1fZzi3mI
    9COKHxpd51axawUzzdPbbHo4qFiQXCsINSt5OTD8o2xsQivlbyxj6NFVUlP4m225t89xIR
    dJ5apX7XlKEtt4HhCJ9eBLLmWDTmsQzhqfdzCVOyy89B/ed+iZD0tvpmPkm8HXDlmFmgUX
    pI+m2W4cNU8lg3Mlsu1jG0yzbdxBrZA1C5l94jk+JqKA2fZ/+87Dm/Bai+4A0tSdNZXigK
    1YTCuTPU5tr3c9qwCJxPS8mFmNq97ErTQXKYdjvem1U1fQYobqoM2g+1Krcg
X-ME-Proxy: <xmx:KQiXav4pWFuyTgFAhbzVsukM2InctHMMf5E4KwRh2L53m9-W8MpSmw>
    <xmx:KQiXatUBtjn6n3-i-vWEuVZzfqmIQzC6k_DG1rn628nvEiKBCu-HvQ>
    <xmx:KQiXal5jB87KLgjgKNo3_zppQxD0Dv25MMvSTMtfoGVpBmJxAI4ywg>
    <xmx:KQiXakkzMZzUmAt3b-3WpwA8iMAsSzmNzZjVeX-fJEA7W_zTyKoJaQ>
    <xmx:KQiXanZv46oZZYjbuhaIstn0oU5BW-0SoVImP3l6ujABxChFibnEYBig>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 13:15:18 -0400 (EDT)
Date: Tue, 1 Sep 2026 18:15:17 +0100
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
Subject: Re: [PATCH 12/12] mm: change the contract for free_pgtables(),
 update docs
Message-ID: <apcH74QsR5I-DIbL@thinkstation>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
 <apbUpMDJglS99_yK@thinkstation>
 <apbfzUwBQyxe3P9R@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbfzUwBQyxe3P9R@gremlin>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5771080002
X-Stat-Signature: ypfr6oahsebts91wr1bhaf686w37bwq7
X-Rspam-User: 
X-HE-Tag: 1788282942-923924
X-HE-Meta: U2FsdGVkX1/ZaqccfhuvzVu33h69GQlVqHj+lUFl8r67MZFqxrBpUqnlhBSpEa/QAZOaj18hNadMwxDYam6H+bXsnLPkmmv7RTCfdfM4lSdAiXbpaE9hSfdVl5kJsqEjqQD8du5CL211wRialZtNHg5Snw6UqzmHyzIsiNrRKs2V+IZJPN7VRR9DErA7KVD0M3YUwSikq4K8st8qK8r+cKzE/daoUI2PR6mjfLJ10aZR8gFTUwwchk11CtRDiL7Glh10TFsww8jbbMzuwH2X9BNyq0lgBHssGe+JViJEFGsYoVeK/3bg4AOMBZOQI8HeGdtENe5uo0vgL7LSOb1wtUzCp9MlGQB8mNwM2YyNdvPScHMALRnBSdXH7qU2H4/Lxo7Tl3SXlf4z4tdyHMwK1oyI6x5ukA7WSnaXLY4Vk7lppMRRlil667kTF0nazbEYmBkMMQ4EYRNriDGXN1SILvYqhb7lWNkKEG8luEn/FeB4Yl1wPi+FlQ9Dvc2Zmuw3rDO1bsU90oC/N6E8WONQF8BeiTJx0dhBAgeo6YtJcWZFNX3xzzv+kGBlJQc25tMc9TaOToFwGEodFokjMVidG/I3iJ0tR2d9uHHzP7bEkvmIQVgcEZ6FhlB4N0x8zBpPcdrFvS3dFyPiXh38JfmiRl4d/4Cul5oEvCz7p+QOCGQU8SI8e9uhQY5e7tr/cIBWCU+xW5zc5xUUapHbHBlVe+0kfH822SqUvU7zL8hnqgEhS0lPVIUelithpUaEqOskpq3gcgSKFm6SeoguIbFNeKj5rEy3zx6CU4gptn1RlSqXprJfFw+A6gEakOm2i/V0no7f7maen6LPR6g24ytzk4IFGWj4JDlC77xPGzavLq0e/A/0Ayg2LdIDC2sigz3445AyXeebTF8jwhuYn6KlGB4zzerKZCq06EHe2AqVD+98yjJQ2EXs9rka0k0xMQKJzhhBBsPLZhMai5AxevC
 IleOM7BS
 05bP1IEyy8y5nDjqildw+Kw9gzn1LD5OHhE49LSUUp/6CAymHXD2zFyl6M+GsGTAPivkYNb74Uv0P+CVPqxNlpJcstBi7LeAyal0LTwTQDOpi1k03oV+5mrTlLlmScb9k80yJblzkHrjAreYYwJ+N0dJGLHqjJCWOK+viLMZc4xzSN3NlhaxDJ6b/Ahkfz5tGhxOPRBs5zwg+W72Vo22OLorzE21ut1vkGi/xuYnz0jnQ86XEwSzsczV5IAv/sFskpoZNqg2QytAZ7MkQYOqY0AuOgH0H++UhO3gygk0NO4YATobtRnL28D0MjquUFCCV+Q72Reop5wTjm1d+YX+qnJFc/FH0jhcH/xIk6w8yAsAeK7zOeXpzl+RvaBh1wuy2PmVYR38GLqnkhwImF1DXrk63pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 03:31:26PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 02:57:13PM +0100, Kiryl Shutsemau wrote:
> > On Tue, Sep 01, 2026 at 12:01:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > > index b91b1a98029c..ff8ff3706485 100644
> > > --- a/mm/pgtable-generic.c
> > > +++ b/mm/pgtable-generic.c
> > > @@ -386,9 +386,21 @@ pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
> > >   * be read-only/read-write protected.
> > >   *
> > >   * Note that free_pgtables(), used after unmapping detached vmas, or when
> > > - * exiting the whole mm, does not take page table lock before freeing a page
> > > - * table, and may not use RCU at all: "outsiders" like khugepaged should avoid
> > > - * pte_offset_map() and co once the vma is detached from mm or mm_users is zero.
> > > + * exiting the whole mm, does not take the page table lock before freeing a
> > > + * table.
> > > + *
> > > + * However, the PMD entry is cleared first, and the table freed only after
> > > + * an RCU grace period, so a walker that mapped the table under
> > > + * rcu_read_lock() stays safe, and the pmd_same() recheck in
> > > + * pte_offset_map_lock() detects the teardown.
> > > + *
> > > + * Therefore it is safe for "outsiders" like khugepaged to use
> > > + * pte_offset_map() and co. for VMAs that might be undergoing page table
> > > + * teardown.
> >
> > Is it strictly true?
> >
> > free_pte_range() clears the pmd without taking the PTL, so the
> > pmd_same() recheck in pte_offset_map_lock() can pass and the pmd gets
> > cleared right after.
> >
> > Readers are fine -- __pte_offset_map() holds rcu_read_lock() until
> > pte_unmap(), so the table cannot go away.
> >
> > khugepaged is an odd example here. collapse_pte_mapped_thp() and
> > retract_page_tables() don't rely on this recheck -- they take pmd_lock()
> > plus the ptl and do their own pmd_same() under both.
> >
> > Can we say walks are safe and leave the write rule where it is?
> 
> Hmm yeah, ah page tables, what a rabbit hole of horror :)
> 
> I guess this is effectively a reflection of the 'write lock on write, RCU load
> on read' pattern in RCU itself generally.
> 
> So, maybe something like:
> 
>  * Note that free_pgtables(), used after unampping detached vmas, or when
>  * exiting the whoel mm, does not take a page table lock before freeing a page
>  * table.
>  *
>  * As page table freeing itself is RCU-safe, page table readers can safely run
>  * concurrently with page table teardown. However, writers cannot, as without
>  * a lock nothing prevents concurrent teardown.
>  */
> 
> Instead? What do you think?

s/whoel/whole/

Otherwise, LGTM.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

