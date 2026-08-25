Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D25C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E591F6B00E5; Tue, 25 Aug 2026 08:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A166B00E6; Tue, 25 Aug 2026 08:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FD46B00E7; Tue, 25 Aug 2026 08:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B658A6B00E5
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:52:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D135C0334
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:52:22 +0000 (UTC)
X-FDA: 85139780124.20.8B63B3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A854EA0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:52:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQ5nvPxj;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662340;
	b=o98A5uGxx6bmxnRiwIKO8E4Sf5pwz+7LvLYHL/gZnGHndPbHNro3JZBuNSPtMoPMwDaNJc
	4HJqW1WPJ+U/9b20ncsp5v8h3WFcJp95o0HIY8jyrB61JQmEjq7iGbn/oj/WRDpigQyZyY
	SJb5JfyiRRnCepJdLJyowOzO6k6SjxU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQ5nvPxj;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxThQMjnWy7RIkTnG90BC8uPhJYun+rex4exdMBz3hg=;
	b=3AH/cwDTmSQeZuKaANrFTPkNWRaP5Z6Xx/l0LDej3yXEh1ZjDTtsdcLhAEgogyVI8VWkFN
	esmT4go9FG3VFNiqNISSnHmYEeh6dZZehGFXGAWOSR9TO3djxeJjSr9lWJVjxEhHNtOoek
	K9uuOSS9ysVi55rLQ30ogFIScl12jZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D9CD6011F;
	Tue, 25 Aug 2026 12:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2401F00A3A;
	Tue, 25 Aug 2026 12:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662339;
	bh=OxThQMjnWy7RIkTnG90BC8uPhJYun+rex4exdMBz3hg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LQ5nvPxjEUoH4UEpC+8nl9nHb7+a3spWZ1e6xJHVYG5VYUQp9ECoGZjRh0QYQAqEz
	 QRmN5Nm/8IQRzcLqU4LyjAVB9DwnZgeuhVVgavbmtoryP8S6i08KZ6DkYIXDtvUA9B
	 p2vF8vfnmvJBfadpy1P5t6y+27ZzOfS68O+M/jIsjQ+7Hi8Acc/qsPMOV4K7TQaT/I
	 fB8VvYeiPpD+sCEDS33e49JgZMUJc8NGFpeVqKrQdLHlI6kBJWENW4v9zfm/dVKN92
	 qM4w1G10t43d9PPWmNzGVinKbB4k173ze1dCaggrxVmzddSxHgoz6c4Q7wqDqXuRBR
	 1FjM8KkoSdBeQ==
Date: Tue, 25 Aug 2026 13:52:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Avi Weiss <thnkslprpt@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Soheil Hassas Yeganeh <soheil@google.com>, Arjun Roy <arjunroy@google.com>, 
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: return -ENOMEM for page-table allocation
 failure in insert_pages()
Message-ID: <ao2P4Ey3fy9MxRUJ@gremlin>
References: <cover.1785847364.git.thnkslprpt@gmail.com>
 <a486e90cca91f443552b70ab2a18510bcc5dd8b6.1785847364.git.thnkslprpt@gmail.com>
 <e4a7bffe-7d23-4d7b-8ec6-5b966419c615@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4a7bffe-7d23-4d7b-8ec6-5b966419c615@kernel.org>
X-Rspamd-Queue-Id: A854EA0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: eun4yk9jk1wxwrbr1y771e7udb84qtaf
X-HE-Tag: 1787662340-878615
X-HE-Meta: U2FsdGVkX1/2RhfQF98l4+znUz0RWZVTTI8fBcRLG+VZaKKjf/eSz5cygWz8qQ2IZNbil7br64QKdOMKutZA8N3Tf8bz2xi/vKw1HmKut++m7hZgoWcIRYmNgHxMCZfTWjEDdiNPu7uww8pKNJOycHo8AjsCQgpMvvtSzDwOw0N0IFsmsiuWESevCDoFGIwmksBNf0JxdHvKwmetWrQEOOBXKY+Pt5hEXuyEsu6Lp/gPFWvl4WLW975v+h8Oxm3eKUd2tlwr+xHa+NMvtTsoxcLTWsoKkLW7J4yOrjGXYyxcbXDAlnEuvjmZjeMZmT981Dps7M8SlQ0IqILRVnMDRShDikZB8dVkpjSAXqb3jOItW23XL2P4fguta9dMBEnuI2fClobQy2XiyXYTOXUismBSZUVjUlkY3K8unl9D6nMf3aY58UlJqxn1YauVousNCjw5GOrHV/kRE64UeJHUWeZVeoJeCvLAEbQ5df3385sa/CE4Kx9NePcTKFvtrNXQ1qBuZpii6Li9705tLtPhL83O1Nh7Vdd1DZp1luWgEtGCEvhsMSJ4J1ll0EogMwA1jnYOpy3oCfGpjDmKP6gT+K0gjLIFl4s/GcfMmAzeS4UuPrTfPIyuu2V5+RYFMewgifR3+UVg5+YQJoTMKRu03GE6JQdkSND2lKyVsZv3ATCjW1AuMT7Ip1lA7ijVzmrajRtjdxzFnMj6nRQoY9WThjZA0qdOVKyw4MI2wzSrpBtN72+MpdQc1eB4nMvWV7ZT6clmjOlTpI4LdiA7k2vdE/fij8kn0v6OBIGTmNjJH3kIRZDs9kPKZ1mB0lfGETvgp3PxjIrJU+WQDth0As+XR4zqmo0sqMGwJvYEQ1SHddMibw2nKnPdSzXWjYf95A/As61D2lGsww6oUk67tBfz9wslNngjBMyIu4r69t6QSg7OybxioJcAqPFT51zJoi8f7eeNtl7ff78B5tFWYgt
 UjuJvhCb
 g2xM61/1LTHsUgj3PFiYkYlphfOgMegDzw1dZJuxNgaGkE1s98P0qE/UME6GtZq80geAiEHGCSS2idODn1rX4mKkWF9qyhRkvEGsopg5V7tl6t5Z/zAj8tcLky64gqf00Z3C3HpBZ3KW46Lc1IW8BR/8r403T5a/Mulgy0pLuqX8qeF/0Xb6R4dccyDYJkkqZYO2V4KxsHBQRqD98A3I2W24IXoPE/zucxlo8mtR1QBOe3yTAP4ixmGQMR06qe1NGxWbmBAzQyaxuT58Dh/pS0TV9sdCEQcSdEbw8xybDrmAzJx7r8MEn/P6cEivVeII9TeHZnwlbYJNfoiMLtNnVJHeWNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/memory: please let's be consistent on all of the patches in the series.

On Tue, Aug 25, 2026 at 12:40:36PM +0200, David Hildenbrand (Arm) wrote:
> On 8/5/26 16:42, Avi Weiss wrote:
> > populate_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
> > pmd_alloc() fails. These are page-table allocation failures, but
> > insert_pages() currently reports them as -EFAULT.
> >
> > Return -ENOMEM instead, consistent with the subsequent pte_alloc()
> > failure and with the single-page insert_page() path, which reports
> > failure of the same page-table allocation chain as -ENOMEM.
> >
> > Address and range validation failures in vm_insert_pages() continue to
> > return -EFAULT. Keep the later -EFAULT return for
> > pte_offset_map_lock(), which is not an allocation failure.
> >
> > Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> > ---
> >  mm/memory.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 11bb4fb98761..16093479d341 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2438,7 +2438,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >  more:
> >  	pmd = populate_to_pmd(mm, addr);
> >  	if (!pmd) {
> > -		err = -EFAULT;
> > +		err = -ENOMEM;
> >  		goto out;
> >  	}
> >
>
> For this patch:
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

LGTM too so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

