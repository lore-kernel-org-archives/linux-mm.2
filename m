Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA1D606A8A9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=to54GCkb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PitML+Rd;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RBEjlCSn;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=H28d6Wmt
Received: by kanga.kvack.org (Postfix)
	id A9C826B05B6; Thu, 12 Nov 2026 06:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D086B05E4; Thu, 12 Nov 2026 06:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914E46B05E5; Thu, 12 Nov 2026 06:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF256B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:29:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C02301A0598
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:51 +0000 (UTC)
X-FDA: 85426247382.27.1A5033B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id B7D4340007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=to54GCkb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PitML+Rd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RBEjlCSn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H28d6Wmt;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482990;
	b=VHKwMQo8H1ySLXiuFv7FDhXFE4Z8abe1VcjbjrmouOYQolE9K2YZjsIY5T8mmU/NSiRxSG
	rkcZeAI2l6kF4UAm7H5xKZZr4HPTSB4VtoimoAGfaB5HAyAlmsB10xNseInGjRj2fCZqX0
	s84ZM3GbP6atB/8d4MmXWSDfTXRRYtk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=to54GCkb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PitML+Rd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RBEjlCSn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H28d6Wmt;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYLOaavEbW4iApPv81a0Y6PhFd+cCkE0qo7yuiEZUSk=;
	b=VbQbcxuODooLQdDgzdSWOS7bKGkxwnRVXM186byZGhOYqmlZTWqnIdoFEIPV3bzUXyKV0R
	SRAa1EI+56Ah2KiAPdvcUZPi15gRSq6AeROHXm/fT44niyIzFFvIRo/1Z46PsiUvQYC0C8
	jrLaJ/QvSs6o6trn6JFljn1eCouN8Ps=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 611621F797;
	Thu, 12 Nov 2026 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794482988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pYLOaavEbW4iApPv81a0Y6PhFd+cCkE0qo7yuiEZUSk=;
	b=to54GCkbVCxZ/diMW7G1IQMQmvUBWfc5Wqj4nB8bVynPIC35nDFaOUT2N1/+x14fNa4GN+
	ZtdrOhOCyzgQVjrP7/CPLe+SxOgAmak8BCpALmBIL+TfgTzL+sv5iMeO+rKbcRBgiBii89
	DVgQEmudKgjG8yNJWaTG3Kq7tH53vBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794482988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pYLOaavEbW4iApPv81a0Y6PhFd+cCkE0qo7yuiEZUSk=;
	b=PitML+Rd6/FbAjxbvTklfUFViCbOjw8a1WGmn4hm/6lqgYw7cY1kVdbgx5j1LshRZ1X4gr
	nXwmwm63Q6pJ0eDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794482987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pYLOaavEbW4iApPv81a0Y6PhFd+cCkE0qo7yuiEZUSk=;
	b=RBEjlCSnA8LAIUw6maTMYmC9YmKjx8cNXuuzzU/05zLDHMSLZKvqSSKaqdvqXmE4wez30Z
	F9xbJL3MacPWJy6t5qzGxCYw7eMxkU0qPJ8m00waC6DOXtHzaiIwuke3lzea3mMW8sxZFY
	e9y0jqy8PlI3CBJVqM6G0boPmyhZg/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794482987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pYLOaavEbW4iApPv81a0Y6PhFd+cCkE0qo7yuiEZUSk=;
	b=H28d6WmtFpXtb7/PfdZN+l4eTWOzSM8zFwUNiUoO+uHIkm0bS4pvFCih97Uu1qR13Z1mSp
	0RMwitGiLi88qCDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3ACE134A0;
	Thu, 12 Nov 2026 11:29:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FKaQKCij9WrVBgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 11:29:44 +0000
Date: Thu, 12 Nov 2026 11:29:43 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 03/13] mm: cachestat: restart the walk after each entry
Message-ID: <avWjDYe8QqLtEBX_@pedro-suse.tail5790ac.ts.net>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B7D4340007
X-Stat-Signature: 8dtyztiuascs73k8t4ouxuh7te6fip6g
X-Rspam-User: 
X-HE-Tag: 1794482989-466459
X-HE-Meta: U2FsdGVkX1++D2mBfcNvZg4wo11oftViv0ZbNRO9FfQKchnR4BGXhfsmzSmORXrYlwaT9VVVPRM79K8Ak7QYUzOw4BbJp30sQtXeQlyeFtpFTltbDrEIYSBn9vrlA2zaKK1DP+VKNeLJRYFwLRYjXQTg1NcSlcCSKDYGsxvX7nSEu5KTZbD6U2OynjXOgsYZyYjnBikbfRQ1jjpJ3+9SI5EiI473As8Dj0gYHvAl+mCmTBwznWJ1PMS+Q1F+UNHejMD7FzHAQYm/wTQ7u+cfITVVmLdF+638Yh3Q3af5adZYdpv0p7kG+BxNCHrZ3BKQTZBEUQYYgh/2CcWPfz3wVuTSPOayUl5hpsif4vEM9iJcdYO+OPeSGyuASZxRvSOpz5PHZ0LzIqHP2Dnt9lfIZHxflr+GIH2r/dZWL/BzheMv4JlsFafXl/3Dt3lKyhi/Tg4MgEtqI8Sqq/brGEFCRLLIK5HfszxcYbpAY1RbNWiL+nCTfy7bKHqzxbCpGnUANSrTM2sfMeD8ChhpI762LY29VgoS5fMJbABpsMWtHKFwz6CQOMh4fC2bdaPbqLD9RVmC9rgsjrlG6ikBN79yrEEEz+0vqPHLyXbIIt1Tim25qVk5xPAgyklq1xygPBPVt2ei71fzmqiqGQ7onNnPh3R3CFmrUdsaW/n6snYSyUTOvdOFjkm9cI/RT0mdwC3Gu/UlzSHLcuQtxE2qCOxnkPvJCtiAr3zKED+wAN6s2yxqGYwsqDmsVaM2seD92etyVijmtwaeKkfOIp+ytaTI/GfOLh/xFjfwtULBu+DgyDrHJTiiFTikkzgVn2u2UAdcCeCtxf0Jz8j6BfxdFObcu9RyWvCnidUmrR/LybtguIsbztf3ZYxI7EN1HHmreYwILnuk+SxDIMLeHavU3Lu2zsez3tdY1RR0bzD7yTvn3QYPITW2m15LfjWrtiJ8+IjbKSGErCF5KG+1TVQxxm9
 U68EefB0
 ctilQpnHlYhey5kwtapg8O4pO5vHVJ7qnm8NAUjSXtxWAy66p9y7U2lwEq9o/vBIk7w1ULpTrptIVH+s6ckcFgaA661a4kODAnrI8jyznWZ7sJhh/Gntawct6uVq8f1YZ0M57iBzb13JzTZGql+Rntn+PZzu8UaMfKJBWmkfiW+WsvTk/eDcK0ZN5cyDTy1Xj2I+Ue/aHw40rmpl5pEtqAugTdbuGTq5fgc8apblwfdOuJ3BmhniG6ctyzhuVnOj+BfeXYmsbca+U+ep7noVKV2Wvog/GilNUpvsZKxENPhwdOZwSmRKXuORZ1FdToR+XYsAXm6CN05RyYKPtuHcAvjBf3yf35u6NMsFAaYSG6Cnxzog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:17PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> cachestat() can leave cached pages out of its counts. This happens if
> the entry that the call has just counted is replaced by a larger folio
> that starts in the same XArray slot.
> 
> The issue is that filemap_cachestat() walks the page cache under the RCU
> read lock, so racing concurrent collapse/split is possible.
> 
> Thus, an entry can be replaced immediately after the walk has returned
> it. When that happens, the next xas_find() skips the sibling entries that
> point to the slot of that entry, since ordinarily they belong to that
> entry.
> 
> However a concurrent collapse_file() or __filemap_add_folio() (when
> replacing a shadow entry) can store a larger folio in the slot, in which
> case the sibling entries belong to the new folio and the walk still skips
> them.
> 
> Consider:
> 
>     cachestat                         collapse
>     =========                         ========
>     count a 64-page folio in slot 8
>                                       store a 512-page folio in slot 8,
>                                       with sibling entries in slots 9-15
>     xas_find() starts at slot 8
>     and skips slots 9-15
>       /* 448 pages are never counted */
> 
> Also consider:
> 
>     filemap_cachestat()                  __filemap_add_folio()
>     ===================                  =====================
>     counts the shadow entry in slot 0
>                                          slot 0: a folio of 32 pages
>                                          slots 1-31: siblings of slot 0
>     xas_find() skips slots 1-31
>       /* 31 pages are never counted */
> 
> Essentially the fact that large folios might be present means we cannot
> safely continue the XArray walk, and must reset the iterator each time.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

