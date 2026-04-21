Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C921BF8FA6D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9306B008C; Tue, 21 Apr 2026 09:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358BE6B0092; Tue, 21 Apr 2026 09:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248386B0093; Tue, 21 Apr 2026 09:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 140736B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:20:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E9F58D28E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:20:00 +0000 (UTC)
X-FDA: 84682620960.22.8A1701A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 48358140004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:19:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VjZXF5fV;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776777598; a=rsa-sha256;
	cv=none;
	b=irGgwVLT93NhoECqJSKhkFiEJ/DUAScX59yjDA356J1bkL91ylJM/ZePN+6ysFysqeN00j
	irQ2YysAprWWuPYEZwGU2CqYKRKzVrQYBLoJ9F6mkn4DyeYJUEuytx3/5qO914yUCs/W1N
	csTLb6pJ4LCKfQ3VSrXGh3EvZ1AWlQg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VjZXF5fV;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776777598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xexzte0yTqtWkjudFGvCNSwnTYifigEpG3qwMv3/9fw=;
	b=MIuy3TY+TeEL2/b48OsvyjbC9j6DubyOPRstG++XhaI63i5HAVp0mbd2Q9pnKye5lMNsXg
	VwjgqGSAowbRgGAvIMcgIhh8I0WC4SPldXcmXoA/cD0jQQo5mPgVc0Aql/oSBF7N0rABCu
	rFkR7jV3oN2JuR1hghCWBgYLrwAlBQM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776777597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xexzte0yTqtWkjudFGvCNSwnTYifigEpG3qwMv3/9fw=;
	b=VjZXF5fVWEOR2/fxWkpbcOOjI713qxDj9ngtC6SGeTmF4YDY7iNsILEqsnfntYOx+KEn+N
	WeHojdBc4ontOn1/8QdY27cSWdcH8MG9r8EK8WbK1leR8t4ur0yHpwuZK/LaWRJbha/dz9
	o2oFYJA6kiN9IK9FTDOqWHFPjWeHGQY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-esKcHlxANBG8z6ixMX4m6Q-1; Tue, 21 Apr 2026 09:19:56 -0400
X-MC-Unique: esKcHlxANBG8z6ixMX4m6Q-1
X-Mimecast-MFC-AGG-ID: esKcHlxANBG8z6ixMX4m6Q_1776777595
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-66e6f1b315dso3635832a12.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776777595; x=1777382395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xexzte0yTqtWkjudFGvCNSwnTYifigEpG3qwMv3/9fw=;
        b=UuafhQRRFb2WyXie7dk3Y/TdbJ39tmzWfDaLKt6Ps5TJ1nJC6idGKqzRzhdnW1K72n
         B3196KKrxMka1z4roJUBLxD1VKeGK4p3wtuGZr+mOKrMMNGMTsvcZpY8VTkvS9urjM9m
         1ng1Atr1OHKq70uyFQiiBd7xVgfLbOG5Lh4buIWxcqeB1mwnTuAc4IOFWfZCshHSnBrE
         t1ZkmJkPKbKbCiLkC/XfnkDAvGNucRtyRet5e6ow6qCdwTiXdDhJD9Yf4JGC1EJnYx9j
         EeXtSBKYoqpBeKN2PikOKbbq0Q2bvvd+c7/BFw+nGU0VQbKoMpsAKIXJTopYKz28y4fW
         5G6w==
X-Forwarded-Encrypted: i=1; AFNElJ9M1cEp25H6r/kJYIGMyS3yd89OVBXakV92zz64uk3q/hUHG0AHiFUNEW6qbEMRx1xYIBAlFnzfUg==@kvack.org
X-Gm-Message-State: AOJu0YzSD7nJ2e9NUVRKBenldK/rNYM4jisrRMnvUWFzEVp1mOpJ5Ls7
	ONPwKMg25aAVaS2RViZnAr1opSiJy7rw7mXbMTZgjjRiI/8vlmSn0WsBSWSPKbueLP824bf/9bG
	oTk4JUyXP56JRDJOHW3tIVjmkv/OSnrhQ+Rr4yaL8FRvDsqHjF2/Y
X-Gm-Gg: AeBDievy0LJJS4AGhFXzTkbI7oqn1Mcfudh9XNdOepp1ZhRYm1J3kIncphqVtig7a16
	pw3UJW4YMLIjUYGWti5s9vh+kUFRl6T5lNL12h9XSE7coMFnY3b02qKM/L7dTkB4ZcDKlU4jl7y
	Put567VYFonWP13uARfhqtR+KFOAXIKAXcNi/sEY+DCO1gVrItGVvBy8U3SGPFSeabkZVv4KlSh
	P86Y+wtfTQBG+QZdqpncHQd6cLj0qRBDBGH9MvYbkKu+WCUpJUf9Q1SYky2oBoO+gE/Kd1CgKIm
	QRbjnDJ7lS8JquDCje+81CRrfx2w188yGENOyduWXdUauLcVn3xBzK73wkF8WtHHge2z+82CEfK
	MFfHaDtXIKmnikbarp+CsfpA7aiW/FuSxvxBCk8AbTSt7nLlaB+TSCw==
X-Received: by 2002:a05:6402:2b9b:b0:670:8b30:a8a7 with SMTP id 4fb4d7f45d1cf-672bfc12ae6mr8152683a12.0.1776777594825;
        Tue, 21 Apr 2026 06:19:54 -0700 (PDT)
X-Received: by 2002:a05:6402:2b9b:b0:670:8b30:a8a7 with SMTP id 4fb4d7f45d1cf-672bfc12ae6mr8152659a12.0.1776777594246;
        Tue, 21 Apr 2026 06:19:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6744dcdf29fsm2080687a12.30.2026.04.21.06.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:19:53 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:19:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH RFC v2 11/18] mm: skip zeroing in
 vma_alloc_zeroed_movable_folio for pre-zeroed pages
Message-ID: <20260421091759-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <39c3c8e647fc4c8e3dcb5c9d12f2e29b5404e8f2.1776689093.git.mst@redhat.com>
 <b7fc296b-06bc-4d52-b607-2da94c123fa4@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b7fc296b-06bc-4d52-b607-2da94c123fa4@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fvqSeFZnQQXgY7wydB7_ApY6NMNmcR4Sb3TiM49wX1Q_1776777595
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 48358140004
X-Stat-Signature: qz7t43a1z17yd918gu3uzurw5jbikpam
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776777598-615239
X-HE-Meta: U2FsdGVkX19PtaCPTEjSIG5rjcBdgtATqtbqRcscaAEiU1aXQ2Q6Nnb+ajOs+lTKBSQpaGsAItxBR/CJMAMNoywRtRmE9+YwGzyt4vm7sDx+1d/Gyt7QfUoHj7kh2voNZpavpXT9z/xImIvKEI+CSnW/oEs1RrLlXPZOcaHWXf9h6vezFKZQ0jBx/2pU8xuxCM4KudkCJBD2w4g8jcnNjEYO9iYci8hqLyj1DAC8gE3MudjOhL4eed7OrLQofwBnITA7mnLNc4OR0WoeIn9VWj/BFDQ1OE9nMoF2p6gygqafeCIJsLT+rXpNHthRprMgTUnQ450Fx+eJv7TSO/U1dP05JlzJwafojhlgncACSJvKGSZfnnN9ebARZHq8q9e9XzeqQE0lHAUt1RqcJI59FpwfKFyMSVjNXiyPgVBEW8biocUkavUkr9E6lT0a1LifViagZk3CZ2kycob2jqWmV85u1+fLWLVMK3lFZkvaEn3ErEnU8VZ9+GhnXme6Wb4pPlIYsH2jUbC7V/iJ9hoFvs81bAGEKBf1gkttyMlqlgNngiv0TlQb6JeZryKjY3JRseFFxrTdhf8sK7LP3QyZpfHYy1V03iD/q/oZXOYBQhU8W6wN59rxeIDwok5L8MXT67hDEz0JoJTeo7jKbDoQ0hSORm00NMLQTX9Iya7dq0bV6utLPKV/cfMlO9RKi9lg40bm5u0N8yN2h5O7Xg1PxG/MVxu6jUtoPeGltT4ULB0XnspiCMjQRlvmxuEYQnuUsHVPwj2TLdi+E5W42T5ck8ZYmnd/G7dpjEsz0C7hxjrdX1i1NogNG9QCHlvNvmL38Wf5atswnxVSPd6R8JVSjuT+K6nEb6W4T6BqTwNUR3Y5USEHuQFVszwvI3MypVqFIPtMXLc5Qh84gxydkbFlYZdW2O8NnQHopKRgHzdCoB/n3zmyvisXW0u2Ko+QMR+yFNfti7edLDzvr5em+i3
 s8hWIIq0
 W/0qaesbXKImtUY/JU07L/M8Dz/iWt23c+xCv4joFkoCvgsfRBTG3GdkblcA9wB5DWWvmYjU8pNaQAQHvxAupgSWLnPp6/En3gsJJXl0bnX+RfO7Hgf/MdPxgyhJyFnhLZ7ZLpORgBj1wF82WfNKzqR6xb3ccmuHxtBGgPtHRu9RT7Hz27eSAiifVVejRUlTN7DbKsMr0tbmPiRPsV2xySqq4rbBcFEJg5jveIDOxFYaP7oagTcD4NBAxxQtJWxJDl1EQ4+XiGVOnw1vLOMptVQzQXTgc3bQFi64qeRZBUcdaYocHYoSbsmdigWgx8foKGys+Sx+01T3b6V34KBqNxtw02Rv4bq6Nhyg7a2fXZYPixHngyKROk9INHz+wUlubKA3p6CGf7jbdQCz0kCl+3NyqvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 12:58:11PM +0200, David Hildenbrand (Arm) wrote:
> On 4/20/26 14:50, Michael S. Tsirkin wrote:
> > Use vma_alloc_folio_hints() and check PGHINT_ZEROED to skip
> > clear_user_highpage() when the page is already zeroed.
> > 
> > On x86, vma_alloc_zeroed_movable_folio is overridden by a macro
> > that uses __GFP_ZERO directly, so this change has no effect there.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > ---
> >  include/linux/highmem.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> > index af03db851a1d..8bb67772c1cb 100644
> > --- a/include/linux/highmem.h
> > +++ b/include/linux/highmem.h
> > @@ -321,9 +321,11 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
> >  				   unsigned long vaddr)
> >  {
> >  	struct folio *folio;
> > +	pghint_t hints;
> >  
> > -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> > -	if (folio && user_alloc_needs_zeroing())
> > +	folio = vma_alloc_folio_hints(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr,
> > +				      &hints);
> > +	if (folio && user_alloc_needs_zeroing() && !(hints & PGHINT_ZEROED))
> >  		clear_user_highpage(&folio->page, vaddr);
> >  
> >  	return folio;
> 
> 
> For others reading along, the variant on your other branch:
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index af03db851a1d9..ffa683f64f1d1 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -320,13 +320,8 @@ static inline
>  struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>  				   unsigned long vaddr)
>  {
> -	struct folio *folio;
> -
> -	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, vaddr);
> -	if (folio && user_alloc_needs_zeroing())
> -		clear_user_highpage(&folio->page, vaddr);
> -
> -	return folio;
> +	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
> +			      0, vma, vaddr);
>  }
>  #endif
> 
> Looks like an extremely clean interface.

OK, sure. I will post that one as v3. Let me just add a changelog in the
cover letter, and see what to do about balloon.


> -- 
> Cheers,
> 
> David


