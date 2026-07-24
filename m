Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C7C3C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBF96B008A; Fri, 24 Jul 2026 10:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D436B008C; Fri, 24 Jul 2026 10:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C2A6B0092; Fri, 24 Jul 2026 10:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE1886B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:14:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1315C03C5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:14:26 +0000 (UTC)
X-FDA: 85023865332.10.48587C2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E0FD40002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:14:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="b3FaE/15";
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784902465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sqQq2Owm1obwOGEA9eotW/m1MLzuoJQfAmp5HBaVcd8=;
	b=bUUSAaKPGSaD1tWpSPqsk+TVbvnWPrKYtxSIAuIyKQpDw9P+eL/4/D3a053VsLoibrcQ9q
	SxenGM2hxBIH5F0UpL2AbYODP4QVeBBZTv9sVsXFv+0omrmqKhbaNeGX3EOv/hnTSUQ9/u
	RAvDXnAk/5CcEezG1p3dbmFbj9u3bGg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="b3FaE/15";
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784902465;
	b=KX/ogGiWWOkwnii5PjKqsz+gQKeuRUeQJ/XM8++b8PNvgZjiRn7ttmJyCO8W6UnG+TC2eC
	dYeDrM1BPI9fq9Pmv+untlD0MAFFyYRrK5eK+1+FznuaUnTcJ4aSCJFyy+eMRBJE/9N6vO
	QdpIz8cqTVqgyCfjb1na8+SrcXA2NoE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sqQq2Owm1obwOGEA9eotW/m1MLzuoJQfAmp5HBaVcd8=; b=b3FaE/15gGHycdVRSEH7kk8gXg
	ziED/cLtyY3G9U83si7GAn5Ol84senjYN1m4jLjO0UtBZIPJDA8wUFOchOARYzauL2VUm0k7nZpzN
	K07SPvCGF24b8xDHwesu9/XXFOC/xHyVYN0uSucmDm+HCF3RUQvxf7WqMkuuVnzM1qoNRsMjxDcj9
	uhiGquYmGmqrNAnYWz2mPt+rVVhLzVIZYA3vpLT1TxNs0sooD2gummR7OMhrl7SLQIfux9q544RXB
	8pK5bJXka726CjSXoWptNMLW0fFoYyvvcYKrkavP6fm72xKjr3YlkbnKKrHXHEs0HDQz3K+4Q60X8
	AYR/0EFw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnGf7-00000003fU1-11AE;
	Fri, 24 Jul 2026 14:14:05 +0000
Date: Fri, 24 Jul 2026 15:14:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
Message-ID: <amNzLXuwflIZFKtI@casper.infradead.org>
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E0FD40002
X-Rspamd-Server: rspam01
X-Stat-Signature: a3dx96ot8pkwyfbromk4qxpgon6w4j5z
X-HE-Tag: 1784902464-20450
X-HE-Meta: U2FsdGVkX19vDPAapMu6Xai1wmX3ZHzz0WMxmt8y1EXzmHc2YEfcQP5G13dqLpdG+WRqaPwTOnNnEYAw2bqnMwKf2sIzn9EA3SOLVwC5FKCkj2j3GM982Rv+nTB6/Vde3ORwPyBn/GKTHfhccL5FQuYgRcbLSivItmFmrim6r5pEREJckmekWk2100yZax/T7bCWgDSFOlBE8qRg0/dYM9fNYTkMy4z3GdscT/JHt7KzWGxmMDLoxqWgoFxIJ16bVL3f+uN6kRE8wpW8S+Isq2S4GRKAYl8+wedi0vcHFmqWooAPEUv6Xx2ATVjgbPP0Q4T6/qPIsHgcJ+ln0wxRzn8RbuhAn0OnMls17Zg6n8Sa9MEOOcsfNO7WyyhVyfb6x7ePGbkRGdAjGBRXo/WAg+JSXimi74BL16wj/1UOwczW5gmNZgbHDAAL4cMzxP3XRnPzY1Hfe01TGkEXZbjsk6uQIHzQog2KvYO6peq+zTWk/L1EZFcx2Ows2odbSLmw0pG8zSqFsb/xjAOVSOscSC/2Ylj3n04xXjq7aAr1qdlXPBCiktxHbM7mOcb1JaIHWHvnsqQk/+RB6nHEj5YuS/iyIEOfq2x/oHI0lixDrd+n3VfC1rgcPBHvXuZGvDUTRAfIRA4NzglZ4mVnFiTbxWKi/LS/cqqoXnFYFnhGcpqT3jwuCc5yKdDHA2icxgeDSmD0BJ3D8+QGtIechujPayFNti/3ceN2J6uq/T8ZsJ+gFo3FyUVPQ9PmDlSnEZi3QctOGAZnYFijzLOAd4p9V5ZkGRr6QqKzBqjktf3De98hFaOmx7OsZ/dRRKjiv6NjhLb1p3NZC0XsiYsJiHcu+yL7wlnxyUgHmaDoJbey63FaXsVsUOnVYNFvuK2TImTQ3CmfOCkNopgwRQFrTUvUjxse7AiA1NUvBW8KgX1Rhe2gomsJsU0JSGEZf7LQ5aCpfXneV2NEs29dyJ5Kzis
 vDQEET9g
 UrcNXi1XLvb9bj8gSW6B1sEmqgyV37ReltgjU2rnlBvB1VmV3T1gZORvTAWMiVK4LWC3rfn+rX0crgI6VnwjVNr33+nbSnxq1/umjJzOrIgpHZ+dSPq8vcPXdzSC38Tj1qSSwDMMbZ7rx/mC+Vp6jQbB5tKQ/AR2iiCUQ/8nYeLQJPw/pI8W78n6a4m2LFlBd6DO6YLsCaMulofvWFW6EpR9CNY0Vco76sYTIfHi5cl74AxMUBSJfYLHWDxxNc6apdNaUqPFnrc5FT5xNpGsiz2/SUiQSGzs07cHBkrRwqC38kiSt0SZGXQ7GlBRxKRqQf5E8WNA8j3gYx0ivC4DK8NKV3GTAcOY67/bPyg9MDZXYUco/7AJy8cADkgMDNrkdiUg7qlXvWiHevVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
> 
> 
> On 24/07/2026 11:20, Pedro Falcato wrote:
> > ptep_get() does not need write access to the PTE.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  arch/parisc/include/asm/pgtable.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> hmm I think you might break build bisectibility if
> you separate out the patches, you should squash patch 3 and 4,
> with patch 1.

I don't see how this breaks bisectability.  Can you elaborate on what
you think would break?

