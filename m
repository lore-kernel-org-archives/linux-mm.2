Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628BDCD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B473A8E000F; Thu, 13 Nov 2025 14:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EE88E0008; Thu, 13 Nov 2025 14:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A343E8E000F; Thu, 13 Nov 2025 14:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 932128E0008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:14:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A10001A0AC4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:14:44 +0000 (UTC)
X-FDA: 84106535688.15.356BB57
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id C69A2A0016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:14:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KoUrOlvq;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQ+yXI1edJ97AoZpFD1eked/PxAa6sQK7CGRupCejDA=;
	b=E8wkt5PEh7UAVwFtstnvfoy1GwRkDV7N75BrRlwvxntJJzli1F4Tjfq/CCPlIhTZXI8iuB
	UX87M0MI6r6a4FZMe6aHf7QF/HQfoW631D6DlmOYbYzL1OkWuN+v3Md9dpT2/ipwsSy+1u
	v8Ln+AUveLIG6+puE0p20nYU2WHaaD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061282; a=rsa-sha256;
	cv=none;
	b=uaQUqL5tEqQaV53NzcLbUFCx8WDhDz7v14n+xuF9BBZmuA0Nvui20wnIrJ1nNj8GqUs9ZI
	HdlK26r0NvoHjA5sFDhVlLxCsb5bQtkaXShMETAlU8U/3d58wuCYmWtn+3XBlqBq85FfgA
	2Lkmbk4FWThdxO93F80oSATLekY8xOQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KoUrOlvq;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bc59a785697so457273a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763061281; x=1763666081; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VQ+yXI1edJ97AoZpFD1eked/PxAa6sQK7CGRupCejDA=;
        b=KoUrOlvqcv5WizyHmm+o9tV1dd7FQAsG8C+WUWS4W96CuCpV/t8DQo6tB5lLU5y5ge
         P82/OIw7VikfT1I5uKAoY3zxlnKTbekK0fzx8R8WyAWkXSNx7HHpfubU4HpicX9oP7TT
         gZsAK/4ZP+DA3c0j6qpTrqgaExbmgpzURcmvh5/da1EO4fbN8IMjHuBxEdWLZ+1apZwf
         /gjh/iTJH8Gv39ElihsU050i8QAEiHeo0/R6Fj1vRv/A1ICzgsUBUa9grMynYg7yx+Zp
         8rzQOi0fGfNncsF/iYGArUjALmVnE9JmyPiEBuF/jWaWdjzinhmqU8mS6JRpSB8uFneW
         2+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763061281; x=1763666081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQ+yXI1edJ97AoZpFD1eked/PxAa6sQK7CGRupCejDA=;
        b=La9wKsvA2mwSD+jo33bvOPd9zKHWzKWe7uI7n9DsLq94+OtQjniV3yWDWLiVukxSuW
         pTJiyBF7RGh/AfOSPFkSalJ7YcRjOSeAaSQssZvM30BTy4yI+mQGltYEy1rhC9PrxwIb
         QoHrtVe2KUXqeaDtQseMGZjZxY2DWoW3DYKNxN6YTlTA8WRQLjfLgTSEkb0lRHhUkqq0
         clqxarPYaR+os4tlQpRwzhu3+6XoY+E9xZcfd7zcU91ha/PZTpH0jD/2tpMoBr3JY/Yx
         l3r8dy04jBhWyJpQQkSjJ2zFeXKlLfJtZvVEYQ2/7g9Zs4iMBNwmAWPKidGfXVh74dXR
         lrVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzXtHkPXjsfSzAs0Yg/+swxrqCpUdft9thvI5/rfwvB4Po60qE2nG38vC+7bwJtJu8N9pqLiLw+A==@kvack.org
X-Gm-Message-State: AOJu0YyC2fr6fpiG2x3GvANNfnb7irw8O1Uu70kAQzW8n6T+WVl3caxE
	myUsETqTYXQ5ASa+YTptI+uJx4iT1i7Ov8iWFci+cIJlAcAZ+jMVYWHy
X-Gm-Gg: ASbGnctc04L8EVN/7ppqbPYozcC4iM60AXwkchr+fgkvN7TifXFFwAcnoEUcrZxqxSq
	JuFtVUMvsz00jhy2ySpeN/1AVXNT+bqCaW143N5dLAEuwbQMTfNG51602/EX/jmsfRg6NqTnJPK
	OEYjgMm37r+U4BShSceiw86YuWRCdbfmixZbManoiX4YVBzVgEwFf5hqiyumIAFL3orNsJGhc2a
	vI7yk0+ImUrHfuB1LtyOBTtETNbte1U3qtcghf9hbjyR88azLjv3/iYLH3AFwiCcFilGsYkiSsd
	sikm6+XnPvK8an3H7QEU7BcRqJM6uVTlEoCtxJo7H+2x5IABBvRBHZ7Vnm7HlTR4cfb/IvI55EU
	gWArxegA9DJ8PqNUXZxB5CRDYTaqjunmdI1j8FUQ18XWhpcwDglFiuYbCpZpAT4K2Dz0EHzjQM8
	3FJz28Iy8ro1wZ81H7+0RfN4DBKs9L7N0lDbShmuNvU2s=
X-Google-Smtp-Source: AGHT+IGpMg8McnoePWdkDbXsLJod4sFp+EU6JJgACuTGT2Vise3W0v7UGDs8FHBlHijAHmwT21ZHpg==
X-Received: by 2002:a05:7022:f684:b0:11a:2e9c:1132 with SMTP id a92af1059eb24-11b4120dba4mr293409c88.37.1763061281447;
        Thu, 13 Nov 2025 11:14:41 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b060885c0sm711918c88.3.2025.11.13.11.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 11:14:40 -0800 (PST)
Date: Thu, 13 Nov 2025 11:14:38 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <aRYuHl4zKwcwWN7t@fedora>
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-2-willy@infradead.org>
 <aRYiW91uAGH02UGL@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYiW91uAGH02UGL@fedora>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C69A2A0016
X-Stat-Signature: dfis3er4xx69g6jf7ozdnrn1fbxwuas5
X-Rspam-User: 
X-HE-Tag: 1763061282-532488
X-HE-Meta: U2FsdGVkX1+IzGzxAYz3veMbq0xLpfb6CVWqzHXt10v5aMEpP6509+qxvntKqbSza/yAHj+vSBntH6J+GdgzvhMQn6bYhjW3ew1UgsJfIx1u7u16NijJJCkabHBj6Jl9ZfDKYtcTG2mbujQihiTXhMefH/Tdvvc4NGVDUUkgnSPjiU5l5Z03agydNuE8RiyRHcAsaNnB8wXE2i4LLFUmnl/LkaVOLTFoO0icUkoZJR40TjlI5yKE6VEEPv4X3rgpxQ81VUy2ecS9MbNpaLyQhahR9CROd36b5yGU3isyCuL0PKIIjItg49xuCpZ3em/uscxA7TJHGdc4METly+lilzT1+26lh7YLNbhFN5Hc+jiYhRYirtpM6JhvYob27Tvze+neWlXimhHdBEzg4M7JD8u2W6QvC0luSlTchMaeK7zEm4fsBD+fVB2EszrqGmvo++Aulrzsbac7gqOOMhTq11kZGIwH93O11SvJNLsB6NhHQFtDTqgyD9mP8g4HmSrYq8rCHmMpH2/ZuYP3S0J3NwV5nAuEyas1nSnh7I4UYdC/lnTSB/51LhCkU0TqOTc+Ye5jGMNxOfIy1pfHJmrQCb0pD41bigAWfko2JHy2HKpydRMW3i5F6Xh3r/IItrWEzzhiSDFjKvHK9z1rbhHgJxvi8WdqCnbOxxLeOwsZzqGLnI6mTO7cpf1lB3ZnjancCAbNgmpAH5MiAuWrlsVsZSji4aHkwXUwLiDrjGk1wyMfDm9Sx4DM+3VBkbhBYGp4pZz7KdxY5x/jpA08JCfVWnclEIw5YW4TSDrzjJK4FFPkz35xT2X2rKn11yUoP6t1J56yVTXotE0ofOxvZshhuxuM0jqkClOQrIuPZ4tiTBVQh6+AZ3CqmwYYMdZcU1Pm0H9HhHPg06UBpnjSzyhFR8uDgyCCqtE6+mdWrjNv6sNE+xAvw+JptBlCSQklo+YKjBVjT2r2DeY5tqKfUXT
 1BGzujvy
 7fClJ05yPSMdyYDEzDY5hJtvdNFXMxd+NNQOjUVZimKCQC9Cdb8huK5YVnk9jbAmMZcvhJYkSGRED/QnmzITgrIJFQ7MFVIP3KiMk0NduLGtgt7X+KmoXZkFJwC8BM/pc0E0w9+S/m/eYclZfK9GQL3IJBStfsN8V3upa0OECkGiNyq9MIIZaHBgNW0Zk8YhrLRB6uAt4p7y5tcrksODWhpev10agzdbE4GG/FYevXvOaeqRTuPJHIqdGFLauGLqASF4jC9PEFqoKbc6MxVGVDEoiVhxNQfRjjKm/Y+Lcj6O4UJifoZC7MZywQATobQLXPgkZyUrYjS5CfGVUkcc+YE1gIFGRxmoZXKui5dliIBm+isflfHm1CUyZwDWmBjyGOdcretSQ3rlAYupl4hROsvGXC7S8DG+BeFPElwe8YNStKwZWt29b4KOUJGyLGDkn3OiMb/jkpaObZgO/8PCSGCkPkia8rExhg6xEu/hiB0/y8xx1hJtIqob+L/nopIkaWAjAROFEgHRfb6Yiz4KAnpH//nLP4OqhJPnT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 10:24:27AM -0800, Vishal Moola (Oracle) wrote:
> On Thu, Nov 13, 2025 at 02:04:43PM +0000, Matthew Wilcox (Oracle) wrote:
> > Page tables do not use the reference count.  That means we can avoid

While looking into the second patch, I came across this one instance in
sparc32. Commit 1996d47a0db ("sparc32: mm: Only call ctor()/dtor()
functions for first and last user") decided to start using the refcount
for something.

I'm not certain this code should even be using ptdescs, but theres a
page_ptdesc() call in there for now :(.

As far as I can tell, this is only a thing for sparc32. Cc-ing Will as
the author of those commits.

> > two atomic operations (one on alloc, one on free) by allocating frozen
> > pages here.  This does not interfere with compaction as page tables are
> > non-movable allocations.
> > 
> > pagetable_alloc() and pagetable_free() need to move out of line to make
> > this work as alloc_frozen_page() and free_frozen_page() are not exported
> 
> Nit: s/page/pages/g
> 
> > outside the mm for now.  We'll want them out of line anyway soon.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> LGTM.
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

So I guess I retract this for now...

