Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A1DAC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3586B008A; Tue,  8 Sep 2026 07:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D546B6B008C; Tue,  8 Sep 2026 07:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46766B0092; Tue,  8 Sep 2026 07:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A23546B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:12:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26FB01404D8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:12:30 +0000 (UTC)
X-FDA: 85190331660.01.B38A7C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6051012000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:12:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0YvJw5X;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788865948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8zEZzYXKDWjMscmRriONU7KthgG+ikNsFsSCx8Kl7U=;
	b=he84eCAhnQC3IqVxWVAHb0InElbe7bXje7KfMmbpUlibc//tqHHyP/5aUWc46b58xF3G0p
	gN0HszpD7007WV0xRMtOJLitxYaolENT4O9yIkPq3nQQuMVIZ0ewLLoRijRqpKh/mbLdyi
	tsI0U3H9pWfHOAjPG0AREVrOUpvTKvk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788865948;
	b=N3yKq0LWeVcgBqksFqCAiNaJykcnZ8PAuUtgma9oHN7jKTbRIRMec9+CYKLpvUsk992MRA
	vuFUKwPYias0tkNpCIIesjP+67zbtXWrNCw6jQMoT5WJVyID24/Xa7H18fEi3Vkh/spT6+
	p3cM0QMVBkkMP2hh0qvk7uejTNrtcR8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j0YvJw5X;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FC6D412D4;
	Tue,  8 Sep 2026 11:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCEF1F00A3A;
	Tue,  8 Sep 2026 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788865947;
	bh=+8zEZzYXKDWjMscmRriONU7KthgG+ikNsFsSCx8Kl7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j0YvJw5XRabkDRwY07U/Nr51yNYPwxCyv+z3STNN3DvhiZbQ2LLliKVdQxWj7ppq+
	 zv9BhrPbhWQJAVescoenFKCBK8dIe4FnLE41q0oGajg4NKGEFMqenvTN8qGcT5KALG
	 fQMcuKC+7NJE6h1JkAWJGjRFe7kuNrWWBJi63S3F7fZ6YaNOkz2UdfAh8vmFC5EXcp
	 bHxMCUACQA7hH4tJIGFFrWqfN8HNtsfKVFr7W/ZxLarzhz8HriGsNqqucFmQRW8PiZ
	 axL0F5cVKdHUSq7uODecJDsNjdMRPzRgNMNU9BLViewX8ONteqjFxwoO/2vXDW+IOk
	 Uivt3hlM1NCZw==
Date: Tue, 8 Sep 2026 14:12:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH v3 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
Message-ID: <ap_tjOTR48tja_8e@kernel.org>
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
 <2b0f5877-e71a-4824-adeb-5af2dd8b0269@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b0f5877-e71a-4824-adeb-5af2dd8b0269@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1m516pgms6mb1stkmb4sz3rpsrbp8x4o
X-Rspamd-Queue-Id: 6051012000B
X-HE-Tag: 1788865948-553000
X-HE-Meta: U2FsdGVkX183MK45kekQFy05OsyqPDxftnPW/v6IWviNE9+5WOmyMbyOB5FN+0TVyS8Umn3Cu1kjm61YcnURxPzm5rBxCS9E6XTqWBMeTvRfYQxCQJME4CGp4VIuvQwxvRq8p8uFtziv8RkvUZ3ecQPTFcLvgEWxpcgirivtKH3nOyhadYd6QCQcLaS12byINziX9M5uSFWADOvZDL6klwu4k/ubeREqWeF7gKGOdBgAhs9yOYbOo+n0bksptcFaNhAnNLqnyjKBudjkQMLRzO4llVaZhYWtk90IAq0lwV4V3zxl1RFiVWA9Nk/KItz69mQ2uDYoDlXR/Q2TsOmNI9mNBbQvoKrLh2qt+Se6MAKJe/d9jsVaQhj1p5IeEX+PAdMXGZTcsF9Etsmrrq5gUwon7Vo48haZXwd3ILTlfE2GhL2xEdDhyp2W/x/gbPzmppMwII7VrE5OkwiGAxxABQLzcHn82UzeB+IepFwyoC3VwiOXVKPQpOZf1re+Gwbl1IiGwCClqOX+wbC7Si3bUggD2AjQe/xzWReFsMTdXbdFxVOxV3qilXkmNGIvzJUupZT5Hom8WRxaQ+CY2Jh5ibIzJSFbHfAnQaVysNYbWU8frOMh8i0tT2Oyj6SrqnTEV9VVrwF9LLNrpHG5VuGQnp25McHVK0PBft9MaWEFXjN312QNTMXPET4abxFBTZKarcQqO5u/z28J1544NOamHYJD7dnJrmm0b/e+G3qKDuD9ZNOIk1BksraQnYyzGBhpLcca2Ds8A6dH0c11MYqkz0ieyAAAdV6TpHgeJ8Hc06WsNFA0Y6gYXEseMso/9wEUf5BHTmbr/6SlAzobH1JnzQKahCrFZnvSimv9vBNqOOZNzGGh5BnBHmQCK9/zdFmiNdYmF+MflZJSihU+wPVwDoW8zQpF98OUnLv+E4vFfX3C0L9NvuuTLQMv0xrTWSDqClXX+0ai8zmCyfOrsp1
 SQS+WEie
 R9qrmwALG+f1UJFW/LvQa7zsqXhAA5BgEFj+PvH+dzg2zR1edJV34ThO8lrBeLsXXyQxeEy6iVfzbwJnfEEtVoj4uTuiRlzp3vKyh+chWc3++AWF/D2wNLI2oGDJld1WqP2xDcAgW2u7amyDfu1vVM05eayq40efR91T9u6gIa1UZLWSjbFI7P1scDYGMavxIER6FIEk/fCXusp7a+nwa35g09P2tlDkK/B/NNNRbK5XPBANJSDwSynOWADqY+GBCRAELmvv+6lRa51drUlawcnXPf3bsF2EN8eSwy/rJPG+ue9V73igx9eqHrQ55vp1cSPOZD4Gs7W/nHRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 12:41:48PM +0200, David Hildenbrand (Arm) wrote:
> On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
> > set_area_direct_map() always updates direct map alias permissions in
> > single page increments.
> > 
> > For HUGE_VMAP areas it's suboptimal. Not only the loop in
> > set_area_direct_map() needlessly has more iterations (e.g times 512 on
> > x86), but it also causes fragmentation of the direct map that could be
> > avoided for the HUGE_VMAP areas populated with large pages.
> > 
> > All pages in an area are always of the same order: either same-order
> > large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
> > successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
> > cleared or when huge pages allocation fails and fallback path is taken.
> > 
> > Instead of updating the direct map permissions for every order-0 page in
> > an area, use the area's page_order as the loop increment and update the
> > large pages in one call to set_direct_map_{invalid,default}_noflush().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/vmalloc.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 5506b180f5c27..6ed6c160abed7 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3367,12 +3367,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
> >  				       int (*set_direct_map)(struct page *page,
> >  							     unsigned int nr))
> >  {
> > -	unsigned long i;
> > +	unsigned int nr = (1U << vm_area_page_order(area));
> > +
> > +	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
> > +		if (page_address(area->pages[i])) {
> > +			int err = set_direct_map(area->pages[i], nr);
> 
> Do we really expect some pages to have a directmap and others not?

Every page in the area can be allocated separately and
__vmalloc_area_node() has

	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
		gfp_mask |= __GFP_HIGHMEM;

so generally speaking yes :)

> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

