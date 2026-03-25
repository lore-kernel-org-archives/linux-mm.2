Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2C8109C02D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E992A6B0005; Wed, 25 Mar 2026 10:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E712C6B0098; Wed, 25 Mar 2026 10:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86C76B0099; Wed, 25 Mar 2026 10:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CCB3B6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:54:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E038E0AA4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:54:59 +0000 (UTC)
X-FDA: 84584882718.02.3137B59
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7681E1C000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:54:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kfjBhpkW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KxKmaq0G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eslfnx7h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bOKSc2s0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450497; a=rsa-sha256;
	cv=none;
	b=JBe/6JspUgSS8S5G7pOVoz7c4sK6OO046rXmkCQD+/Vd9IHWgLQCBoGqN36IhNBqC4hb7q
	jeq1kiLasAdtVcXTGmXjXNZwGCOK+Kk4see1hEVewUs7A2Z7aa5wNFwUP7IKij9v6jsnfl
	4cZX+TNPxI16yjV7foDdgwVqF0GUILA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kfjBhpkW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KxKmaq0G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eslfnx7h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bOKSc2s0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=xewGptK0QKJeFKk2peOCkcB+BaYIWsCukgAJeVyF9SpXfGdEW+Td3fr3G1sArdEHeqnwqw
	Fbk+ODGShXaqn6x0/UXKxusoBucUYut2g9V2FWCNsts9/HFqfBm78QvFJcO/oz/h+n1OgA
	KJLUtx9SspiLivK7us1fhIZS2j6ZR7A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2A964D244;
	Wed, 25 Mar 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=kfjBhpkWS16JY8q2qhzrpMm8Qqcs2ZrtKS4zlJEvRrcKzCGUHSYFoBdcLJsmKv4hjTURyd
	yd4A/VFS1ynIvUXSdfbN+WxSwj3zLyvx02En3KZUx/jYp4phNK6LAOI8yTXuWVz/Nltv20
	hyTn2mpZxIoIAv6/6Rvb3UfWqNm23fM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=KxKmaq0GZ6SbmxU5yVYvT3J98IVPybrqCzJYC2RmzYb9aKP+qaSl9V6BjPBkq9CVdvc8UG
	MmoaFM8Fl1XcZvBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=eslfnx7hQIz+CqBMaKTHFfI4A5TaGYs6A9oOjOoC6EAoJqhv9gkRua4SGXrrlzy3kuKdzT
	bzw+G48vIqIIz5lkBfsEk+Dd6ymbTjzXBQMGW1sbCTIV5CxReOHAtNecLZSpjk1qvgUfR9
	nmZyWiv2dQf45miza5KfPMuQPZOpR3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450494;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D/wXjEuEJQTN4k0jag/OQOqiBqUpftxguZi3Bfxxazc=;
	b=bOKSc2s03svO8ZobkiDMrnkLqmSYPCdv3zFSNzJ05OB0u9gYR0s9JtEEpIiTbIKzp6ATVb
	nBCfqs3dIyX5voCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F61244462;
	Wed, 25 Mar 2026 14:54:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tAkWDDz3w2lQYwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:54:52 +0000
Date: Wed, 25 Mar 2026 14:54:50 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
X-Stat-Signature: j1f77bqfuaxykr9grf14bhbpb8tr136b
X-Rspamd-Queue-Id: 7681E1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774450497-364807
X-HE-Meta: U2FsdGVkX1/rFrWJTS90tcsM4MXcWWwBSKtuo29odaNOY79dybQ2xet0SqujtEHQOVl/kzK7XKLqDLRwnt5AJ5QXU6iExEtKjteLxvwwxpOhPa94iYRuHhmp47w01238vwZBuCx3J722MUWJA4hHG0iRc2h1A5Gs9UR3E32iYwpEc3PUMe9pTZmOkustxovyjWglGU/uvykffJlgEp3BvKjmn3vUAtpYHrGShVGUVv0h7F7at8ebXaAUH8Se9TdEZFyO3kS8z66FBiCInatBAcdu76AQPZuqW4JBi0FWaG25L5U64NJvOIZ+DWR/AsXq8C9tY+yhQc9ej5uH2cwtzjoQoHwW2jz76+qQ+19LeFS9kV65yoM/4on9mPPbYB/ppUfA6SRwz/bAN7Qr/lLw6gXSQj99Jc8eZInYvnfKXO04n7vo/7pIxm9GFUgPwKNZKFwd6yakwW8Ta4nKCGKUYk0phv79gtAvQKhM1h+Jbus0RDDwvLgLSDgLCPmtiVPbqHguNnJ1SHSjWBJ4bTArlhts6yJhq97Y1rW6U8QSP/s6gD6Uqq2NQfSViWvMKOafHoxo7d5a3qDaPjscaHVDaKtfCjDhjKBaasqVjS0Sq/9BST/TPDg8FqKpCUlDffxvQJWGMA4n5AbKhrtklhwyaU2O3wzut3jMdRvfQu8RZr5iiwd0olybvSGBiKhHynrBhwVOYlwN79rvvPAFRshoydQk/MFGqqxTioNolf8c32+2QXqQoWQbKl/uq9jK5QNBy5+c3ykU+tPL9c0WXSbrSCsPbdM0XWuSK8VjVTt/XKWgQO6OEOiAFExJ7A0+lJrx7aaX1k8pUJGo4Gj78FGDXPnpuIezx8Ys4id8xx/zUcq93qE7DDHur/8qr9lFJvHeSoZdQPDYmyjMCKLrQBcu8VOFk7Yu7WBnDeX0RFJRGEOoh+Oyp+Wm2RKslLmMHQV/FVrP3ry4YztxOa+B84m
 EA3/uT5H
 sMoPwTWpnQDxf0wL3xmzvmVfLUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> macro) always being inline, as we rely on the compiler converting this
> function into meaningful.
		meaningful what?

> 
> Also update all of the functions __mk_vma_flags() ultimately invokes to be
> always inline too.
> 
> Note that test_bitmap_const_eval() asserts that the relevant bitmap
> functions result in build time constant values.
> 
> Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
> inconsistently named versus other VMA flags functions.
> 
> We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
> about its new name being rather cumbersome, so rename it to
> vma_flags_set_flag() to disambiguate it from vma_flags_set().
> 
> Also update the VMA test headers to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Is there an actual difference in codegen here? On -O2.

-- 
Pedro

