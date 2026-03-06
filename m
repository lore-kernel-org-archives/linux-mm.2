Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC35F01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54BDF6B0093; Fri,  6 Mar 2026 06:13:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F61C6B0095; Fri,  6 Mar 2026 06:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9386B0096; Fri,  6 Mar 2026 06:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7226B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:13:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D79991A0553
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:13:48 +0000 (UTC)
X-FDA: 84515378136.15.30F1E4C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A539C0002
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:13:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vL4DUgk0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bYCXQtON;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m55eivUy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vyBaWIVr;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFDy3mPH4NjmVrHKBxbSgKTS73hgxOdxEWk4nSkOndU=;
	b=v3XqINELWI3E37zdKIppBD6z+yvCHzHXxZZPHlPK2c6RNKDmYTBr8QXLfnGSgYX+qThJHH
	VyZoPc4pYV8xN2U++LSmkRQZEfFcifMOGQM2MuEhb5ur9UeZrOpi894zyPYYm8C1U5P7tg
	0Rvh0Fl0h3Fob58Tm7xZBKFVy3ulEjE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vL4DUgk0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bYCXQtON;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m55eivUy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vyBaWIVr;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772795626; a=rsa-sha256;
	cv=none;
	b=jsa7g64eIfeMNTZ6lhr8syn6zWfgcobNqujhbjhHChSmJU8WJl3cI7JMN1h9ptPHaW2Ve3
	1nofVZ09jrjZdAlCe6F7Nm2LKi0fflsQ1LioSOAIyJCeMCSWTm6cskjBqeKA2MzFlw3x0r
	UPzFrxgNGq0nEKSb/DmJCnvBos8LY0o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D2AB23E732;
	Fri,  6 Mar 2026 11:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772795625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MFDy3mPH4NjmVrHKBxbSgKTS73hgxOdxEWk4nSkOndU=;
	b=vL4DUgk0v/L/3CUv9SxUSaftBMk8NhHHABnsXjxDGcCdoH1oiTD/xz+/I/n3MdV7ToXXIx
	V8LiVrJoNauf/tg8ZoStpt1VJSU3xf+KKl3dNgjkNEvMXD04W3qhCGUMVVUaYjQWICuYZz
	Mz71Na2lz2x0yWejULElNR4Q1tKWyXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772795625;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MFDy3mPH4NjmVrHKBxbSgKTS73hgxOdxEWk4nSkOndU=;
	b=bYCXQtON6yDnKmZ3aKuWDpdKv4t7vJ7xTNt+IexnRe+Ai1tbt+5s14elVSQ3PM3GomXNkl
	qNKs1ulOf4eyAODg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772795624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MFDy3mPH4NjmVrHKBxbSgKTS73hgxOdxEWk4nSkOndU=;
	b=m55eivUyjBSUSCnbe+niTSegT7FmMA9p+gLBFl5TEKQ0mZg0c8I93cLkT16KprZTKSuC8n
	bWWLvdgME0995C3y5ZPeqf0FDWtJ+BSvXxtTGmAaVS5j+q//F6lCHTzZmUyCg24uGJ6ftJ
	JIU+zwNFr0QmjWJcc4edouVMk6d69b8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772795624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MFDy3mPH4NjmVrHKBxbSgKTS73hgxOdxEWk4nSkOndU=;
	b=vyBaWIVr/wdi4MydAjPdePLE4DZi9z/doIFgj4j6TJS5Pu0eviD2WccjGLJl1xAT1kwMcy
	GxF6WXoRQH9KU4CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8045C3EA75;
	Fri,  6 Mar 2026 11:13:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sNnrG+e2qmkkaAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Mar 2026 11:13:43 +0000
Date: Fri, 6 Mar 2026 11:13:41 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
References: <20260306101600.57355-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A539C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: 6e6jspwznffa4gxwf9d7on9zpsdmatro
X-HE-Tag: 1772795626-748561
X-HE-Meta: U2FsdGVkX1+MaF5EKwWCu5qA+uVwBc3TqTHP/80J6PThJJWxXuJ1hRkZdzAMAlwDmn5t25XV3JEpJiiLdByn8O45xVEGl1CLbAm3OHOdjj7Zq1gAm22SVOQv0z1RbVeZd9VEVH5sOA16RyV8vI65q5XWBApzco+UPWofuJx3BvWSXZeuoHiNLm22D5UgsX/bxbTCgIYnzl2GKW/al8+S9y/wz5wMzIK5/hjGOSQGZDbW9Ow8ovjbeWF/z9aY1A6fST7eg1pbNANHFE0ZgnXHWGdLrlEXSqbQBCRy0W15N557GlqPoMQwpsMdrh/wqyMssknzI6IXPuC30O7cn/FVX1SgTwrUFnEJXzCPnaEE4ctPE/l5g28SPmdaAhU4CagbPzzc1aHdnQZGAtBhmJVF6cEKt8BTEWuzTp4UIbLHf5medcx4wCLXWwYvqn2eewkI7883GL4FaoBNfCihKpeR1vKNq9WGtINlmx4z3tzhcRSu6QX+K+TfVqq6lQL8Wq4cO5I9dmxcsd2FkxiGBtMJS/uLmIt3akybnmqyjCEy7OmH63i/0/X5SrVARyDJVxRrNCILmZD8UqO/2xLI3Ndh5IVjiLyJdoAca1PF2jWD6ZEVJ/QWbPqXjSTVCyEV1S5WD/tX0xNsNQ+PVZuVMaxXOfwvExk07+ZmSf88PZ7GpcoB8b0q9EquKxG+sYTzP50822eNd0FKWWXgC8Na807UaAKqfOoU84GIxhNCRBnhPEQfpB1Qd8yAPewJOydwPLOltv0dcJfE++SEaOtbHxMhh8FX3lGxTfZjOLSW88rersIP81azxWC5Ew/Wi8xRuHLWULHsGfVC7ivGaNcSo6CZvIYggN0/Cq/WjHi34m0jQNYUxiCB7xL7eKx2T2vvvNxGY8o/KbXn/RPF23bgdkW9XzbyzWQ86mfSvG8xXYoGp5TrxSOeLXanwDMbMcyKdj6THxrEcd/bX09SzMoR7KL
 of/3jj+r
 cNDuxBnuaTzYkQ2glLUPcliYE8dqxQ1rly1ECZD1fBccmNe0hYad5w7k2SpWbt+OjRQ1kMTBIcyefXxuLCsiwy1R9ljTybfj/qYf4IpjlcYvJqZwhi5VZ+iXEeEebM+x8eMnjHQXQBSX21ermD9we2cimhSxsiY50voy9DkegtG8mtHeDpUA/bzV543WW6mDSnZuuWnv8mLUmZJzQsHHeOpADWIil9rZMeUSigBhlEpiXZrNbB1z3aOFIB4RyI/vchp+KwYnKQWFhGVOjMeiyZLd+j3AnQcKqCIoe0yy63IIwncu+3Er/47B9PIAHEgvmzjDqoIUlt4momDWZrS+SBAhA/mUfWPY+hFbEVOn3WtqgM/2PvtTiyfUSUvwijUvUl1VztibLk6ted7rGZTi/uqWt9xwK03q3DQNO4y4+oh3OeekvsViwG08QQ1sLAlVbabJ1jemo6uGOAbXjtwi/2aYNoO4RyaIRP54dRRCwntwfrW96+pecZXVCGbwxYsrIBO+tuJ33/ximFZ8y1jljL0p/wZObZKMCxtvPLK9R6OjNSbb/XH5KzKK7Kv7zwJUuW/8lNMENUKFg3+FHizRZIvsM+EKzoNjH102C1FlC7Qb8/N/h10ggTymOIUAH7S7FmOM7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> scenario where DAX would not do the right thing when the kernel is
> not compiled with hugetlb support.
> 
> Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> code.
> 
> Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> I don't think this is stable material, but am not 100% sure.
> 
> Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> inclusion from KVM code.
> 
> Cross-compiled heavily.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Although we all love less mail, FYI it seems like this didn't work properly
for the patches (no CC's on there).

Did you try git-email --cc-cover?

-- 
Pedro

