Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A51E7F531D9
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 21:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C5D6B009E; Mon, 13 Apr 2026 17:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133F36B009F; Mon, 13 Apr 2026 17:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049566B00A0; Mon, 13 Apr 2026 17:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E87BD6B009E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:37:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C752C1699
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:37:58 +0000 (UTC)
X-FDA: 84654845436.15.2D7AA00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 37A7A10000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:37:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aaWV0dvi;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776116276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zypwX4nPzqqGkby3h4xchNBDXe75SXkmhVGTD+QMyg0=;
	b=b5ZLRKqQi2+x2DwTAg7FX4iVx4ZbU0RDjIVVJnX5f8GEy3JimE1wjft2YVa2kHSJA51VZn
	kklVXTPx4qHRQLBrYTX42dh67JeT1PQkTz2J3A4RddgwxBDZ9iW3kEQkoxHd8HO0vAcVWy
	y0DflCxTts2vPgqvXD4IbG9HvV172Tk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776116276; a=rsa-sha256;
	cv=none;
	b=FCwA5wESlSmIaVmKW2fDkC4OUjgUKvOVLkEBKXHxv5uEiwC3MkUZs3hPN66U7GVDkfX55o
	YLDjMChjzVo7X/CcTlT8ND5EbPaoeI5WxZJAX/HIjhXHG3EeUsBjkDkF5V0kEb2/No4XYu
	B5RhAer4x7rTUG2Kbvy2BXZ1+xC+IhE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aaWV0dvi;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776116275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zypwX4nPzqqGkby3h4xchNBDXe75SXkmhVGTD+QMyg0=;
	b=aaWV0dvi0mCKNYAzEvWX6FuZXx3YPOFXrYLOZG1Tkv/Fp8fy0pASyFAXIs0+U0scE2xB56
	XD/JIv6l5rKlCVwtN/xz//07q2UEtiv49f9Xf+5CvHJAup/JM53Lw+5JMtli1/U/EMr9yc
	Qs67mEgIw7kSViZxlRHR+m/rKRkPnnA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-kDzjAv7jMnufTcm2zj_lWQ-1; Mon, 13 Apr 2026 17:37:52 -0400
X-MC-Unique: kDzjAv7jMnufTcm2zj_lWQ-1
X-Mimecast-MFC-AGG-ID: kDzjAv7jMnufTcm2zj_lWQ_1776116271
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d00dd913cso5313570f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:37:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776116271; x=1776721071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zypwX4nPzqqGkby3h4xchNBDXe75SXkmhVGTD+QMyg0=;
        b=sSnySoAFKUTecvjgUeVFOtsJ8KM9+zSdif0pLFZWzjLUGrtGbQwOwuON/lQT8cOw7O
         VGZMJxaur+sGWgG19Zj4q5zCFdsinR05sS8PMKwg04pv10cZ3+ITLRBZbEBKI9dwmnX/
         VwiS26MPLDskgYhBB0gXzaPiupx8u5Y923HUDsfYcKZ+ATYiBXb4ih1M0m+P1WSCCz0t
         bkrXfNoQIoEyJny2C4gDUyZYNGy1nmyu49C1HVPVsm2bBK73CrGIiz9gYdtEK+jRCR+A
         zhCyVDQKZU2ORnhJ6oeo9vi1l/GKG4rv1dq/eeEEY/6cbIUO/vPRIjYCMtY7oH2k6GN2
         hVZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/28imFUED6S+wXQeQK/NskCmGr60NXl1lS+E933YpFJXC+tyaczXyONOGIaPi+81m7tFVj7j9gXQ==@kvack.org
X-Gm-Message-State: AOJu0YwT3NIPWCbrgaCppIYe6PfMNDOixoabjZxezfBEGY7HZN1iU1u6
	LzTkEnBXNgrBr8lWKFPgg3R6aVHnvuGisdV0RIiXjvmcgqK1FGx1weQtw2r9Cceampc8xqwqEmF
	pX0/K+mhDu4mOsl+NctnBH+yZRLSc+f+3Kjcpdojz1tKcbQ+taw/1
X-Gm-Gg: AeBDietYFiv5rt3AD1dOnKeHkblNa4t65k8494pZ3xHENQ6hsxPyNRIAxKDHxC5YgrF
	+61tSdiDCwR+R225Rj6YVSBCv4thJYDVnlxO9iQuOoOa1c4/Nw7NAO7vNYJ9XAwIe6xdQm/sdLu
	dLOiWwjNznQ7x5sGdmoE4HnNbB4AJBRItgfcGmVGe9qUtyQ2MboTVbYuXsCtVqKK5kRL+smUfHw
	q32vP3sd9xLUMickn/bXUQ/2+o0DIpYHY1HFJRkoWjCKKWovkQHAD1ay2ODW8YP3EaXhVCgOlt/
	sQA009BaUECXP3hfTv1hUQRqvGvMNzi6U/q0iqZ6aTyAZpwmbLh+uA2mCCDpmAGdjXcaDpOX7HG
	Bskp4HDWYMBQvQVaIrzCUi2066BsB2MHKxGYfvHTfc48=
X-Received: by 2002:a05:6000:2dc1:b0:43d:7a97:78b7 with SMTP id ffacd0b85a97d-43d7a977b07mr6473085f8f.50.1776116270806;
        Mon, 13 Apr 2026 14:37:50 -0700 (PDT)
X-Received: by 2002:a05:6000:2dc1:b0:43d:7a97:78b7 with SMTP id ffacd0b85a97d-43d7a977b07mr6473061f8f.50.1776116270231;
        Mon, 13 Apr 2026 14:37:50 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7cf533b7sm6776966f8f.18.2026.04.13.14.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 14:37:49 -0700 (PDT)
Date: Mon, 13 Apr 2026 17:37:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <20260413172139-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A4a6XdIEdoL4MZCxVM4oBOz0UkCBgP1HGU6iqZBjSno_1776116271
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 37A7A10000F
X-Stat-Signature: 87f6hotrkddedhjxcfwaj3mpc97jgcdk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776116276-856986
X-HE-Meta: U2FsdGVkX1/1mH49g7xwc1U/GT5Wmcnei4Fd+4pRfAvPhMQi7cacSuILbW3D+ng/lVCoIN9AoWMu1M5OIXW+l72P3LMDY08zJornL8yV3cucdkB2SxizjZxECS2LHSgqJ6RYwb537aSGrxowkDkS4jsevAVRHd2vRz8JrVuTK3yFe82FulG0es9NxwLL3/M6atHme4uK7JnkZpjUIfEKK2yEXM70keirLVjgEUowqk9bo8wm6scF23pG69yOmYgJeTcvzfqOmh/okdoH3X0tZn3GM7XmW/EXrd2PGcPIxwT8IiXBP30LLBi0P7umn9U5N0kSCNWtSh7lh4J8gDvN+SQm4FlOqa/Jy8kVgN3fq5z8EgT5hiZirPpj6Flq+ycwpr+wttQkPAmaaJRHnyQ1yTi9aIEtuHIgi8KEGwSauOslrjn3nBsUSQLC9S1c4fL5cJ+Zd7ugzkbuHRQcvK6HzY1+w7GGvrQ4t9r/T9vfvOyrX5g7sOTaAAkuXKQxWBDFbC7tqvttEvqAemP0864lzcEpjOM+Ta9bld3tKxzMF09ysLZFsTRnPRUV+FskcdN+cQl45g9Lax0415av+GlOcZt1ieYlHXK49mGo8BW75n6kXAieYWNaCXKZbzjzBlyktmaMhZaJbCoufl/aB6KT6i1Wx74TRXEXxb76OLd2WbLflT/G3qvjkxDnuuo+HnuySsCH3Y7ATvc4KgMn16wu9qoUMy3ucZ4YhoLQq+V9L+NO5ZBfTepa1wBnj8wVpHadAOqO8gsPhjtky94I9r8hUsy1QtLHTVmPL1vG8akGIwZYDCclJhuDLmAyQM9slWGM060N0lrvAn3iJZd6iAzxbbpNjuunKLZb6Urvj2zXltyeknPD1sAoNVD/Fy9j+iZhLrBrRQJcU1L3j+9abC3MZgswI/CvUxGuEFh2FT+o+sdbtp3/p3ePIAM7YnNiV2LKeG+s3a8E/b0VYubeO66
 UFQil42Y
 lV6bsue33V3VOPdC8TJaDd5fu2oRSnVxxuFcOjrGyWL9iR0I3Tof05ulij79qlo2+61E8n/Ska6syoD22Oz+pmyHGVJEGnvhvQ/Gqe/rLiSXAfiUd4CfnK4Hlht9k74D1AhmtfBKsH4ht/051UZCLyE2ikCJLkFY4/DCs54n6qX8rEdRr44oIdUXovHlGUj1+A56sOXPj6ZNEhi3hkayLJNckDs1p4y9zT+iqQ8AFZWOio6LOC0I0vSZhn5bquBZo+I9HY/HLB2Hw8drRT9b4TZhUmO9wb6J+hLs19A+bQqwLghD1EYK7F1THcmh5N8Rj9GnmlnNsPD44om6hNHQkjtqTTUNmzfuIVJuGPbhpHVnXLBx53DQ6edTGh7TS7CTnAVNP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> > The previous patch skips zeroing in post_alloc_hook() when
> > __GFP_ZERO is used.  However, several page allocation paths
> > zero pages via folio_zero_user() or clear_user_highpage() after
> > allocation, not via __GFP_ZERO.
> > 
> > Add __GFP_PREZEROED gfp flag that tells post_alloc_hook() to
> > preserve the MAGIC_PAGE_ZEROED sentinel in page->private so the
> > caller can detect pre-zeroed pages and skip its own zeroing.
> > Add folio_test_clear_prezeroed() helper to check and clear
> > the sentinel.
> 
> I really don't like __GFP_PREZEROED, and wonder how we can avoid it.
> 
> 
> What you want is, allocate a folio (well, actually a page that becomes
> a folio) and know whether zeroing for that folio (once we establish it
> from a page) is still required.
> 
> Or you just allocate a folio, specify GFP_ZERO, and let the folio
> allocation code deal with that.
> 
> 
> I think we have two options:
> 
> (1) Use an indication that can be sticky for callers that do not care.
> 
> Assuming we would use a page flag that is only ever used on folios, all
> we'd have to do is make sure that we clear the flag once we convert
> the to a folio.
> 
> For example, PG_dropbehind is only ever set on folios in the pagecache. 
> 
> Paths that allocate folios would have to clear the flag. For non-hugetlb
> folios that happens through page_rmappable_folio().
> 
> I'm not super-happy about that, but it would be doable.


I suspect PG_dropbehind (or any flag, e.g. PG_owner_priv_1
that the patch that I sent uses) won't work as-is for
this.  The issue is PAGE_FLAGS_CHECK_AT_PREP:

       #define PAGE_FLAGS_CHECK_AT_PREP \
               ((PAGEFLAGS_MASK & ~__PG_HWPOISON) | ...)

This includes all page flags except hwpoison.  check_new_pages()
verifies that none of these flags are set on an allocated page.

PG_dropbehind is part of PAGEFLAGS_MASK, so if we set it in
page_del_and_expand() to mark a page as pre-zeroed, check_new_pages()
would reject it as a bad page.


I guess we could exclude it unconditionally, but this
looks like a riskier change to me. No?



> 
> (2) Use a dedicated allocation interface for user pages in the buddy.
> 
> I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
> 
> It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
> all that.
> 
> 
> For example, vma_alloc_folio() already gets passed the address in.
> 
> Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
> folio_alloc_noprof() use a buddy interface that can handle it.
> 
> Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
> do what folio_zero_user() does, and only if really required.
> 
> The whole user_alloc_needs_zeroing() could go away and you could just handle the
> pre-zeroed optimization internally.


It's all rather messy, from what I saw so far there are arch specific
hacks actually around this.


> -- 
> Cheers,
> 
> David


