Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171D2CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3307A6B008C; Wed, 14 Oct 2026 10:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307B06B0096; Wed, 14 Oct 2026 10:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244F86B0098; Wed, 14 Oct 2026 10:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0356C6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:57:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CBB8C05BC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:57:09 +0000 (UTC)
X-FDA: 85321534578.15.9B46E38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1FD5C000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:57:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EbMvOooE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMSlHyjUU02bSE6X5r7bmxpu4G21C9qfseYw6MgAPQg=;
	b=USBuTI4qWTDOWLlgH30JRKSR00WNjEC7OXBk1BhavmXsRMqa2qRv+E+FuWATwpRtS6Y0rh
	XohDb686FIWX4/Vgo6t271FzxyfeVjgI1BY9IkE3WY+k5qrov1v2+iDSroumfpa7A2hQBw
	hrRxdKMkHQK1fQiM/A11en3fw9I/W78=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EbMvOooE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791989827;
	b=GUgoBrqPZK6QyTZizy3YROXu9wuH81he6Q0snOKfHg4hmCVhnLAk910BsFW/PLURDbJUX9
	nIqoxpQCK1L5e8m46ovYH49xx34Tp1zBz8S2D1Hs3ehxxsbFbSGZqDeZXg6aggoVt0sfVr
	DXN7FiVifJDgEfiTIacyvQGxcPhhwGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 154D4408D4;
	Wed, 14 Oct 2026 14:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79231F000C4;
	Wed, 14 Oct 2026 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791989827;
	bh=dMSlHyjUU02bSE6X5r7bmxpu4G21C9qfseYw6MgAPQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EbMvOooECTvm/Ipx8SAwgZIMtCfZihKqt+i5jpyRsbYq1Tke2SaGkP6ka1W3LCa2x
	 hudVD7+nufM2VAtPfxpv3a4CR1d4yQjgpm7+r/lPFOkCOfT3W1CZgESrLlWQTqq4S4
	 DipzIM9r/24kdNAjhUEK7p3omVzWLrhAaKn3jbiSuM2cqeuBqwEam/Tm1R4I252ORA
	 rioZLKupo3RlFRG0WwWB1yCYhTq9en5eeHDETNKdXBnOgPCkUl556Iiergz0QHWHlR
	 eSr3MRBI4uI2VDMFk95c/T0BOPwwG6JRSsaQWoE07NSvw4TPE+5Tfp6WI6vD+bln6B
	 TA9Ib1VaXhiiw==
Date: Wed, 14 Oct 2026 15:57:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ying Huang <huang.ying.caritas@gmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
Message-ID: <as-YFIBeupNnW8Pf@gremlin>
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <as4kvHe9IFZH5qrC@gremlin>
 <9add8400-66c1-47e9-b5af-7a4081ebf3c4@kernel.org>
 <as-BZibPscw4cxsD@gremlin>
 <06930044-4bcb-4478-8a6f-2dd3cf6d290e@kernel.org>
 <807e8d2e-e7c1-4491-a3e1-21d84cc58946@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <807e8d2e-e7c1-4491-a3e1-21d84cc58946@kernel.org>
X-Stat-Signature: hkzweyp453jjh6sk9rzakc5r4kmgdahi
X-Rspam-User: 
X-Rspamd-Queue-Id: C1FD5C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791989827-760797
X-HE-Meta: U2FsdGVkX1+pGz7lr2yXWNoNIxeV3xdyk7n02jTenLeFtUoytTBOzBf+w0ZpxoQmcVQ38SZpxwVL+UntPaGKJZBWU8h4i3Gss5irfh6Ghk0gIatqNCcJYvVEb9bu9enLSsFANIj/5UXy4JcC6CjFxhvjAeBVNDhNenKkLT5HPmWXBX7YJSegvAm+Psyn4oSMs3TlXu+9wNhyR3CaVbh46vkFC4TZeBELtHfWkIOCGSY/YoPir48tad461+b6RwfqgbhjOmCP7Pl2YsbnmLTuqeZnq9RS7AAw/phaX1bVirKWaJQZ4GIQ6TtkKvj3NZHtn0W6g7T9Oc2UTF0faWznxAc4MaH/FTgbumMHXDUZFq+8mZuauBQuJC0GFPlfAzNwhZMm3ycpvgtU3fXhAg8ZmuGaTTOMxSoATho0B68cOndvgGtOdxnRKPOdU0gOsOF/Mxth4oM8utkYZO0ErPNoSJUz9ov5InG/kjUp/3eJgTw6dTFy8blxjDbXqLsFwkfBWtbF3zHjz0+KlJ4p1Zr9Twpc/ZtVT+KEuXPMMpeGTe9haDFstsrd7MFYeyZDqLx9JdHW+A7NpZOTpjzhtdWm+2Mfv+rokpFE7nQYLje2PPGndd/JUFC6z+lwEOAtGHTOgUIUnX46Pk2aymrv5EpMqhfiswMQoxCYJFj85qNjay9qFR9St0w0fmaX96eInGQPny2ygycW3TOhXLaXIctJdL4k4eTzP8Ufl1o816JqO4xarVJ8a9H5j6KCH/st1qfJc0COz3hKFZj1ZAv4pPY3kKRNCefLEwUP556drIf74Ui1LnzW6RpHmNrAGvuu+audiYWk13/ckOdbiuR5jvRumiQ+bZrDV79vE8pDVD6oH5RuhOkOVnnfdmH4HCZcFY+mubPkxkDVkSuJSW4MqsohphLmYSs5syKTE6oVOsJwOLtP7+LwYQbslmRdih4vtSIh/qKs2CzjrcEMgtPNnhy
 Jm/g9051
 HEHu/BxwtJno2bhc051l0DNw7UNmTP066f7l51wIUIs3U46zhMN2QGHXujrxRxZjZroyObzmexSxc/YJKFrnIBX1Kea9g9bD5fTOTZpGbfrKfT/D+5NwjB3QFYX6jt11VgTY2b6msOIdiQWPHS3oSmbohU2RDI/kAhG7moT4by94UWSldug283cJ/+/7BCP+Z/+4Yo2H/1j/m1bntNsdVAeCGp00lcXjpFfJ707MsCj5A+V/L6qJJuOAQ9XUL5iKhSrYzJKbJ3UvMpRPkn1XCPC7s+sWLgBAPYf4VYS1l21XesDG//D+NsAeVXx+eXr8ZencinI49DlCC+ywMPDWrMjnyxP82rMj2grhI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 03:49:05PM +0200, David Hildenbrand (Arm) wrote:
> > I think we have to assume here that with NOPMD we will never end up in this code
> > because large folios will not apply (each PMD table has exactly one entry as of
> > today, so we cannot map large folios .... I think).
> >
> > I can try condensing that in a comment and cross my fingers that that is the
> > case. I tried that now. and codex review already tells me:
> >
> >   • [P1] Folded PMDs can reach this helper — memory.c:4948 (mm/memory.c:4948).
> > The comment’s assumption is false: arm64 with 64 KiB pages and 42-bit VA uses
> > folded PMDs and supports THP and
> >     NUMA balancing. Here, pmd_addr_end() returns vma->vm_end without clamping. A
> > large folio remapped across a PTE-table boundary can therefore make
> > numa_rebuild_large_mapping() walk beyond
> >     the mapped PTE table. The previous code explicitly limited this to pt_start
> > + PMD_SIZE. Cap the forward distance at PMD_SIZE - (addr & ~PMD_MASK) as well as
> > the VMA and folio limits.
> >
> > Let me see if there is any truth to that ...
>
> Ok, the PMD table as a single entry, but the PTE table obviously has 2k entries :)
>
> So large folios are possible and pmd_addr_end() would be wrong in this context.
>
> pmd_addr_end() really only works in page table walkers ...

Ack!

OK yeah, I missed that it gets redefined when wrapped, so forget about that.

A quick comment should do the job re: understanding.

--
Cheers, Lorenzo

