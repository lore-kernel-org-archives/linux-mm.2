Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA4CCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA0D6B008C; Tue, 12 May 2026 05:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95ADC6B0093; Tue, 12 May 2026 05:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8707E6B0095; Tue, 12 May 2026 05:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 755A56B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:01:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22428160411
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:01:13 +0000 (UTC)
X-FDA: 84758173626.17.09C57B5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id E54DD120009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:01:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bFndAirc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="f4EaLA/9";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WxcQy8D1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+aFIXJOf;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/z7ZTk/tQ8MkYUf+nJ2M5F66Apw+zBhv2IgQMZTmJY=;
	b=w1//WksgWk41BJg8PojSDNFWRIyWAUlzT7iTreJlvl20/zRu45hTxLws0zQYk4XZnyGEAc
	LdgxKmO+++5VVtbu9mKVMCURprggyzE49jIaIQKxbYp+brida+jXbLsF3sItG2/LUQ7H6E
	ALNb39iyy9V4a8bkYbcSVw5M2WsiqoE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bFndAirc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="f4EaLA/9";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WxcQy8D1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+aFIXJOf;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576471; a=rsa-sha256;
	cv=none;
	b=vrBRwl5fwDl2yRfYZv9zRkJsbhoQF4RQXuy7lR3Xy/gcBewYGkiSNrC5spJ8COiGDx1p4+
	bTOZ+BElq5yWMg8K8J2IO4PXl16v8y2POtHd98KYHImrxLBcVD0V0ZD93yNHEqTTYKEFIW
	dbxD+RQW1fkJIJJCSVJTfFw+bm1CZaA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 846806C086;
	Tue, 12 May 2026 09:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778576465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/z7ZTk/tQ8MkYUf+nJ2M5F66Apw+zBhv2IgQMZTmJY=;
	b=bFndAircj6+1Iv4cxlSlzbaapEK5J/tU+FELrckYs0QFPl7KAV1V54ZgvYP5IBYYN53EtF
	Qk6hZvpoGl8jA998BnN15JuYhGBumMLysmKfCr81OehqGmFq4EObaECqi7R45EMYXBFjqo
	p5q/BLk5f4gC7o+YZfb11BVKGe9pLGI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778576465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/z7ZTk/tQ8MkYUf+nJ2M5F66Apw+zBhv2IgQMZTmJY=;
	b=f4EaLA/9+meXhx5VCjOiTGPPfyXS89pL6iIJdOhfhy6h1hw/5Ic8F0tBHKGenlVsdUU7pg
	TXCdLtOKNizK9dAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778576460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/z7ZTk/tQ8MkYUf+nJ2M5F66Apw+zBhv2IgQMZTmJY=;
	b=WxcQy8D1XEtGhDGDeVWdTTkVAzO/AN6iyMxRRs1kblvvn69iGGmTj5g9qNjhDDiD1vBI8H
	fz7jew0aXEKqgF0a5dI5KQxaHuh/RrWFPGw4C4B+FHuOlOTptMGfA5UQ6+ZqRjNkyljlEu
	cOazouVeFZ2m655gIoZkInOJ0wsx3Hc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778576460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/z7ZTk/tQ8MkYUf+nJ2M5F66Apw+zBhv2IgQMZTmJY=;
	b=+aFIXJOfEyUf1rLxTRzulY7j0rGUN0PNYQnqpcaFbhutZtHtcxfb+M5wTutiEQzHUfYf+c
	U33XZ4FvOcUES+DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74BD9593A9;
	Tue, 12 May 2026 09:00:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KLVdGkvsAmrfHAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 09:00:59 +0000
Date: Tue, 12 May 2026 11:00:53 +0200
From: Oscar Salvador <osalvador@suse.de>
To: ackerleytng@google.com
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev,
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com,
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] mm: hugetlb: Consolidate interpretation of
 gbl_chg within alloc_hugetlb_folio()
Message-ID: <agLsRc9TiRoCHeBm@localhost.localdomain>
References: <20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com>
 <20260506-hugetlb-open-up-v2-1-826a0c5f28fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506-hugetlb-open-up-v2-1-826a0c5f28fc@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E54DD120009
X-Rspam-User: 
X-Stat-Signature: ot5c5xk83up5gg56grw4guj1brau6586
X-HE-Tag: 1778576470-711034
X-HE-Meta: U2FsdGVkX1+BBbUilqO4syAEZHxjwVb1XjCnaObVP9ugeSVWmidt6Z/YLjW040CTQ1XXGeM+pZDL8rrBKQ1IC40ltDbGzOk9tSdLz4jbpSlhSWabP8FoovSRT2UkLmP0wRlDXewBxaAAOKWp5roYg8sWJPPfMm6ouu284GG1sdHL2WlR8LKYbhbj77yYf3IBzLGLhJODE9UGdHZ1BhEAHoqNMRmKdwFn/agEjpTHUVsQS7GM3hT9ufShFmJ1PRX+Y2vDPEDV8WA0J8Af0MlIIf4LdZrjP7MXieykG8ShQc/CSpmy37nYoONcZpPYtPi2qX3IeX5bxYQ+BNTHqvhLlrcOK3frE5Yv7gkaQHM7MGVKklRrTfM8F072NYcQJs5JQZ0U6D0b3uTOigJj70fvQL+rrqKowAYTWZvMmEL3Rxku8i0TeSER4GiU8CPOVxbGqA5zuUx5LVh+dj5h0Wi7RNapTeYXhplS2LPTZFfC35LuEkJAhdYx/Ii0ZvCYUgykZ80boYmYSnXGqGFNMjSEqxyVgWhzTmTfYaBTrhKqjatljkqxSLF8KqrCmjxyaI7Orx7T3OQnYwkLzcCLEu8yQYdE7N9oyHIx/mVQT6U819FNOfXVkyBGsxOyIEfLyEshxDcSUDObbKlBaYvCo1VrQ/z/Pdh66C0MWcK7ebVJ21ImbBwwF5C+4He3I/Kdu41t46jjkGpinjhiwt22VtUO4pE/g4diJTxQaBB+4LIVzb9SMsHqrbde6c3uSS3bxnZ0+mLLj+VUCXqdMwNtxM2HSZAd2koHE1iNqm9OyjK/H4fhGcMN/WaJefern4YA1d/xO/wA7hiiZqnnciEtC5nkrRQ5nWALduZ9VBNLSkKbWMaMIA+AHJ+wDyUGomIR3K0NwRvqJvMWSOvF2zSCrXxZefv1bkreoFNZKy6k27r0GolpKVTAefOpfzaNwZ3XyFwQpaET1QmoUGE5oEwohAq
 mNpkWL26
 jjJIxPgyTXE6Qg/CRZ1/OO6yi76P8KjOPGct+d1I2xF9cHJdAMOEdKUYwlnwC2CVwsLCJ68O5utJ8tSW83BUdr1rw4Mgk5FYHTRNBXBGLsne38JH1jc13hyQ3CgIAIQFN79Q5RjohhHixdNDeIUpYCjZkNpzDfaDQ/vx2wRgsBu2X9SVg1RFvVc9mPSsUOj4CVXkWB6jmLoHFuOThyKzcHr2uZeoFIa45lmMnwTZXAITcY9Qk3UEVwkmUH4hXWd+fWn7lZi86xB7E/FLEqGJr+vH7ToQeLTDSoEfxKMmJbF0CSQ6iN2kN2anV7CYOLvXCZrpTrzkOWGPl2hVt0HeuQwAxluH+yDNLsf0mNozKMYimA0A9QS3BhnCEaUf2nq5ik5+MDgK6fkobohroeFEG7RQnG80UNhRoaGCWRnaIBc+SreISzx1PFuZOh4jQpYc2/6WB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 08:54:37AM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> The dequeue_hugetlb_folio_vma() function currently handles the gbl_chg
> parameter to determine if a folio can be dequeued based on global page
> availability. This leaks reservation-specific logic into the dequeueing
> path.
> 
> Relocate this logic to alloc_hugetlb_folio() so that
> dequeue_hugetlb_folio_vma() focuses solely on selecting and dequeuing a
> folio. In alloc_hugetlb_folio(), only attempt to dequeue a folio if a
> reservation exists (gbl_chg == 0) or if there are available huge pages in
> the global pool.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: James Houghton <jthoughton@google.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

I am ok with this but:

> ---
>  mm/hugetlb.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047e..8be246b4e6134 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
...
> @@ -2939,12 +2929,16 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		goto out_uncharge_cgroup_reservation;
>  
>  	spin_lock_irq(&hugetlb_lock);
> +
>  	/*
> -	 * glb_chg is passed to indicate whether or not a page must be taken
> -	 * from the global free pool (global change).  gbl_chg == 0 indicates
> -	 * a reservation exists for the allocation.
> +	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
> +	 * try dequeuing a page. If there are available_huge_pages(), try using
> +	 * them!

This comment is a bit obfuscated.

I miss "in case there is no reservation, check whether we have available
pages in the pool to satisfy the request"

or something like that.

 

-- 
Oscar Salvador
SUSE Labs

