Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C904CCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 17:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264D46B0005; Mon, 22 Jun 2026 13:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215C56B008A; Mon, 22 Jun 2026 13:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106146B008C; Mon, 22 Jun 2026 13:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3A256B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:11:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42DF6120234
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:11:30 +0000 (UTC)
X-FDA: 84908189940.17.DEA9DB2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id B75E2100010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:11:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=erB7xUSe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782148288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ob4n515gwjUACWmJ3PEmGOd7nhYBm2e6boWfItYT/o=;
	b=5b+rOsGJtXbiAa7RreviHDW5yFbNAX64YIIVSXrfbFF7nCNkUUWY1/mayl1lYxhtdZgwVi
	HOFToramZkQ3m/i/H70B63RBO1KDlXSB//QkJlglVw0XJET989NuBAEjfgnf7slpV8v6gU
	bjKShL75twCsQkVE5aTykcnORreTmhI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=erB7xUSe;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782148288;
	b=xI5evNjdmJK40ZvCRupgLz1KlwekVUBxumFBWu1c2dCE6YnIicpvknJHDMHQ6P7hHdAe4g
	9reDHM9Osgl5Rp3Z8+/nz4wL9e5De+4Dlpss6zwMidvrI2gzDT0IIGfi8QnjzhxkculPf2
	3WGaOV7cIp9iWjRJ1piX6cd6c7zLhwc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6Ob4n515gwjUACWmJ3PEmGOd7nhYBm2e6boWfItYT/o=; b=erB7xUSeC1VU5j7O3O4Dd9QPaI
	+Q3OSYWIPxsxt/C9U1wyrVC3FWoIzshmgw5dy5Brh2q9nPsbxaEFYoOMnjoN4UyeGQ3NsR8ZGdl6q
	Y7HX4WrENJjfKbcTznAl++DBjHOV7Omzl5/k/gu/K3xt20MIr2g+oqR9qLLo1FjoxG9XPX8D76Vxs
	jLwhTzEILHFWDtobbQZOib1/ybqikxLSbhobg4ZmZxlijjbaIo/8B/CGOoasm+v3cSErUpKRtPxO6
	KzNNPDnEEcxowK6CtNxZXpEP0GWk3liMGeAg8sB+9++YIvhgCg/ar7ldMaSfniFpyJ+kIHqeItjlH
	ydu+JrNw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbiB8-00000004bnx-22CY;
	Mon, 22 Jun 2026 17:11:22 +0000
Date: Mon, 22 Jun 2026 18:11:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Frederick Mayle <fmayle@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajlsum91zeh-oRz6@casper.infradead.org>
References: <ajV0TbwEyaKMzoa6@lucifer>
 <ajV49Fyogfa6aIjy@pedro-suse>
 <CAJuCfpGdxsPDbxOwQFdY+Xt7mZGFvoKWmed6FteTongvFgjgww@mail.gmail.com>
 <ajWAYBXHJniJAO4u@casper.infradead.org>
 <CAJuCfpHF1qtpHZQzLmLi7xz06OWgBfduHqBHF_-0Vkx7OtBmcw@mail.gmail.com>
 <ajWXEn7gECvgG7F5@pedro-suse.lan>
 <CAJuCfpFfr_SQ4ZDFojOkDKWbO2dKdL3pUPA06B2ZC-usUnYRgA@mail.gmail.com>
 <7ftrqtta2bw2xxtrzelrs46t7khr7tf2vmh2ur2mhdphtymlsr@rqbd3pfjxdp7>
 <ajk-NMghY50F6Sli@lucifer>
 <20260622095855.50e4276e331cb2d01db7183a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622095855.50e4276e331cb2d01db7183a@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: z8a3hzhe75xmaqc7emssr3f7hbs9y66j
X-Rspamd-Queue-Id: B75E2100010
X-Rspamd-Server: rspam11
X-HE-Tag: 1782148287-245499
X-HE-Meta: U2FsdGVkX19fBhVqit/4wfIhp3daQVhhe574rkrfTCpZVXTZpyiFYCiREEBlTT1xP0Gh4I16rncrRj/pMqZ0X93GqIlwlxCHep4FA8Sokbsuxqje+McPiD3V2Es31H8cS1wf9hQC9kNbkKPlhfRZCfLZalBR2WrVOxs2aG3Tn+wumoq87UkvLS1HAddxwfKU/V14HFBjv3phR+/8fLF/WphVuykzAKg/nAnA/D3MGudrImwHhfTtTsx2b6MJicazlShR2i1j9rZCajr7NcbTkzn7goNjgdM6LqlyY9tDimkp8gSEj9FP/5I9bH/6HhvPvQuc7KWoALrNkdKwicxOc8MtU2NDYk5GEiYZb6NHTiSJEdKu/grymZsQAWwyhrzcRBEZPQMmXra9ibCbJHw4QDaaPFoNHiHkdWiXJgg8aWcRNAy1QehoSIuluKExRyZkCHiEv58vzxEjz01qxdlW/7VRTcLJzulKqQJx3N9IycyE5MY7TGAkqV9ug5ChZIkKTnnhXH8YX/fZ1hDEG33DWwF7ZaZ8CZHiH+uTHdfeO3Tp2foylDiXQZ3gb7U6oZAxJFskF42MMGiPYE8lgG0SUzeTrMMmFur0G/aIWTIsgAbVjn6+VsqKgxNL17TRln2Atd4CZSQhLaNQzPRcPfEKjIGaaBKaC6zWTsXfvneAmKwrfgWT8gTwuISl/GrG8LCfgQDsQvrPfBKOFE1reuf42k/zGUAi9pSbNvcKe1PBN/yU/0ipinIIsfC3fcTBomxLhZGwRbpcX2VpDmMf0teiS8IBhLd/HD8AXGmdDrG+LmrtftYSXxMVARsglLSUlwHcU38Y8VL3a90yEFJ9WVhKkAmZR3MgMW9qiGpyVK0qcB/1/p6APxNDD3oA/CW6OUy17xdUR6AM/niRCjDJvAgkpy/YYvonJ1hWZasnC5a88GCSrAILuxzN2k/b+AWNlWrKoc3jhryVMlUOBW1m6Uq
 kDTBcjHt
 wNk+TcFlj9ShOI4256SHOcMIx4ux4+IeSJn4SPlM2uDKf7IAcgKeVP8hPA6tYmzAmPBKBUafANOzGhOnW/usKh6JWa38slJrqp+HRDh6nVVJQ8zOgARVfWCmjae34C3MZnH6MAOG7/992L93Ilo5jJtfqaVcPW4zW7JhdlVQ1HUk99paP3l8NqVH22RB/8TpLmtZv+F4Au9G01BOzykZjxFGNGufqH6/qmAJW83+/I0n4nxgB//CMyDNNthFbtkOSzMTbgZHLDcnZYGlGyPtBRyYl1j6xa60zUW/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 09:58:55AM -0700, Andrew Morton wrote:
> > > much as I personally find restricting mmap readahead to a VMA a sensible
> > > thing to do). We just need to figure out how to improve the Android
> > > usecase.
> 
> Would a helpful heuristic be to do what 7b32f64bc512 is doing, but only
> if PROT_EXEC?

I was wondering the same thing.  But I think it's right to back this out
for now and try that after -rc1 so it gets some time soaking and
bot-teesting.


