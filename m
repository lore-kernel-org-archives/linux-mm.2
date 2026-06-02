Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 733E5CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD50B6B03C2; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11296B03C6; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8ABF6B03C7; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 888F86B03C2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59EAA1A078A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:12:25 +0000 (UTC)
X-FDA: 84835011450.05.50A2BB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9FF8B100011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:12:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mR5547fp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0KWJlg0Sqr5Z7raeF0KU8zyzsqRO8RTi4QDjPMOW+A=;
	b=t3c1qSAlZFpRH3+W/uz+6zZUQ5cveAwUMam8VEVogfgvOAlYmRFBO9qeFYAOzaLf/hUJ/p
	JMfQpuwNhS325ltITD0NGZRmiJE1PedizX5IrdSCP0d3mpn7lB5ENf1Sz2lXD6vJbvJGlj
	U5Y22CyOvjPTl3zRK48i6N5z3Hww2IY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mR5547fp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405943;
	b=ZqzzljhNGa4hPdAzGpT0F18vyq4Jv3DZpEYOlQEZN7D6RdcXaT0WRczq3mSnZd21GFHyS3
	ef/QEx+mO28Q+emIcv2VeBqbL0erMNZCQy00sJCIGRpTgYSOl3QYr23VoXuS7zWFY4AVcE
	Nmk8mr29r155MuJqAr8xlwB8U7dEfO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6EB543B3C;
	Tue,  2 Jun 2026 13:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BB21F00899;
	Tue,  2 Jun 2026 13:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780405942;
	bh=V0KWJlg0Sqr5Z7raeF0KU8zyzsqRO8RTi4QDjPMOW+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mR5547fpKxCJf0XlTdI9xDkvs66R5fMpuoyFGy3sz+isEcGZKY/mYsjmZY6KBlkKm
	 S12vTHBxWqDDRaeNVwQikJkA9snuJhlZ2zE5KPbrnDnnWOa6XgIzEP/iDb6eSk13qT
	 WBnHDbMvAtHGtyoMHkjDwtmN3ffUNad1alOJNuakUnY0oklWGAfP3lZ3gU89Gqoil2
	 wk9hpuBDLrtpHOKqX6Y/hI2pvcBDK/YO2F8tIICTaYojkQwOLVNGOOtSdldwj/ThuG
	 XeHRaU8sm5kKPCrlZnPatsIEaaraxxDzznOaCIQ0cyBpyjnhzEfQk3NtiF71zvYj7f
	 HaogrdbefYn0A==
Date: Tue, 2 Jun 2026 14:12:17 +0100
From: Will Deacon <will@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org, kevin.brodsky@arm.com
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ah7WsY02cNAN1LCS@willie-the-truck>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
 <20260601212225.11f277a85d5ed15083b08cc2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601212225.11f277a85d5ed15083b08cc2@linux-foundation.org>
X-Rspamd-Queue-Id: 9FF8B100011
X-Rspam-User: 
X-Stat-Signature: 3k8guy6os1y4cmoxxfimdwmwmue7wpos
X-Rspamd-Server: rspam09
X-HE-Tag: 1780405943-836556
X-HE-Meta: U2FsdGVkX1+blywAiAJcNla2It1swMl4/NXv7MSfNwItCO4nOwpAxsbFnqGm98JZb0jaj7QNyFwCJgdCSmNZsbSPeTNPsJn2ojLITSLTf6Ef+aA8aCVnUJot2qiITBZVdH8Oeq/JAwuhTaCpBADNPDmlfv2IyZpPsEXYpk7tQAIHgEdMwVcKm+dqOd0mv8AC81wAS8BheHVbmgHFHmPKm2VoMN5D9ozCsGjm9+NPmn03J8gORKh2WkQwNFC7ZBOnEyPdOEZd469W+X/IZmSoTCdcHzP6Wsncxu19WYJbjvzKq9845n0AhFBc+4eOWlv+wdpEme03BJQAJ3b48INrA+gNuF6l39e/zMJmtH+GhoP63FXAMW2dUVf5Z0Vt1adGyU12oArHOPqY84dTPoULVyyjojvbIhI9nyybKC4mjK7SjHoi//U38hbfXQnMistQ/8oacx4GtwFwnXrffVmKikU47QHWkvlg/rw9yjfN1N8mw6v6Wyy171jZKKgxOnLvibEcrW3xzoLdXC+mo6gsZ6De92m1ZNFWL45zUz3p3/tswQYqiEnW3LWqVqyw6hSTJw5beaUYlRCfKtWKKaCsDvDUCDM4+xCiFCcPgL8bFLg648tYXLUEAcOv+tsFu5/kOWEwItZmY260T9BLMGSjasXIgGIUlYuzDbJwIaXnx5Eiw+n57veFWU43UhVZalavfNG2O2jjmTgr6qpd13iQKNsdGIwIdm8+pGO/gjKe5oKj5N/b+GeYtuJF+G347QqHrMKMEHWSF6BwMFqWRX+odkETHNYXaUCCx4WLeqhSszgeCSeIStRZphmEBiBFwjpnyMG5NYAdSCK5g6XufeVQdEO9w1Q5A9BpiCfPOkZml3QcV9rLhYEhPr27txq5o57YKokHn2Uh07x/+RN3VdjH4yWgjkEl4aP0VFrnVNRr8x6CwqmXdWVca6gRhIl2uuN6T/A0cnI2pI94nyxXpo8
 6dQGtoU4
 5O7ptojME6fTqr0MTBtW4fswQRLxHXurb+a8i5WhCBd1qkx3SQkqtTovwWMz4whLCp3brJT+hhMkP767TNKOmVmjexKnfsBupGzJ0nmNUvohSHY/oBXij1xug2tjla953E7b6aff4NzqffQ/dLH6SaF12Km3ikYThq8z16jpJUWdK8nQGSPzdD+wgvXMROHafRHPbDmwyolDVIDvCUQLnFUTHBTCYSmg+4LdQXwrPbFT4LK64b3jKHJrJ8+3xspvmN7YsNPP+TWX0J19ktSIu90bPrJYC3ylpgGl12eEes0YZt8D1VRhc3niav46H8midiLztecIN4+IkApNbi+rgDuVuPZauzJDQaL9641wTOlAWDLc1JC2OzT4FjJgt/kbIPcflZClyLsrnYVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 09:22:25PM -0700, Andrew Morton wrote:
> On Fri, 22 May 2026 08:15:09 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > > > --- a/arch/arm64/mm/mmu.c
> > > > +++ b/arch/arm64/mm/mmu.c
> > > > @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> > > >  
> > > >  static void free_hotplug_pgtable_page(struct page *page)
> > > >  {
> > > > +	pagetable_dtor(page_ptdesc(page));
> > > >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> > > >  }
> > > 
> > > I'd of course prefer that arm maintainers handle this.  But
> > > 5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
> > > fix it.
> > 
> > That's fine but Sashiko has some points:
> > 
> > https://sashiko.dev/#/patchset/20260521032730.2104017-1-apopple@nvidia.com
> > 
> > The __remove_pgd_mapping() path is fine but we also have the
> > vmemmap_free() path where the constructor was never called.
> > 
> > We could pass around a bool dtor argument but I wonder whether we could
> > just check it's a pgtable page:
> > 
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 4c8959153ac4..9d42cbddce27 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> > @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >  
> >  static void free_hotplug_pgtable_page(struct page *page)
> >  {
> > +	if (folio_test_pgtable(page_folio(page)))
> > +		pagetable_dtor(page_ptdesc(page));
> > +
> >  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> >  }
> 
> This patch is still floating around in mm.git awaiting some
> finalization.  What to do?

From what I can tell (assuming I've been following along correctly!):

1. This patch improves the situation, so makes sense in its own right
2. There is additional work to be more consistent with the constructors
   for page-table pages, which Kevin is going to look at but is probably
   a little more long-term.
3. I'm happy to take this via arm64 but also have no issues with you taking
   it via mm (so please shout if you want me to pick it up).

Will

