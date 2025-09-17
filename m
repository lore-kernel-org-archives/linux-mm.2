Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2E1CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FBD8E0011; Wed, 17 Sep 2025 06:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047808E0001; Wed, 17 Sep 2025 06:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F0F8E0011; Wed, 17 Sep 2025 06:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8D238E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:40:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 667BE59105
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:40:00 +0000 (UTC)
X-FDA: 83898396960.23.69BFCCA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BC8380002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:39:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzKn6rsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m05UphUC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzKn6rsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m05UphUC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105598; a=rsa-sha256;
	cv=none;
	b=RlaEis/lyxCvLPUcWiLcaj45PioINxjaktXqRdZzMEF/BRiVyasgs/vTw6v7eBGWwxdZgG
	V3bxqMLtkshmV0XvWscx5/W9byzgqEKouFjbTui3syj62kMu23hLQKsLZv146PApIOhPI4
	MHoMt1DJC/ET7LOFvxh3CTR56SdvTZE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzKn6rsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m05UphUC;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lzKn6rsx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m05UphUC;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTjTogDxANa0Qzws4WbQ8f3o4nXNMeX98mY4+62yrZI=;
	b=bY+Ztje+LE7Wjq4/pdVq+nF1WQgIEgX3dvLmGXogMRNSEYZeX5TZtNiw9abCHo/1y9pXvj
	VrK/D3M/TyK2OeoWwOtrh6CBBmJd6VYfU8bY2p2zXrOMxyoZfuGoQ78pTwEudYNrGCrDI+
	aiAvZ2NlIuEyN/CPr8M8KuLjmMOqCrM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 579AB222CE;
	Wed, 17 Sep 2025 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTjTogDxANa0Qzws4WbQ8f3o4nXNMeX98mY4+62yrZI=;
	b=lzKn6rsx96M01nsIps344q318bjExYm7c47/GA2AJuj+wsJabMjH9h1a7v07SnWn6ll3c5
	At4V4a2NRUnyC02g6Ia/cYXNwQbHIw8uwkYxX8QiQeVCE0ljoYNfhHhH7Q0KPG4tMw77HB
	Khc3IHGBEaPbM2iorjGxiL03pp4nOgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105596;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTjTogDxANa0Qzws4WbQ8f3o4nXNMeX98mY4+62yrZI=;
	b=m05UphUCjG6VcfiTq7HuxEQMpLR8mEO4LF9xom7TIutgiUjjowN6ss0ovAhE8CQtPjS8Ff
	wBEKg5ywLVyBDwDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105596; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTjTogDxANa0Qzws4WbQ8f3o4nXNMeX98mY4+62yrZI=;
	b=lzKn6rsx96M01nsIps344q318bjExYm7c47/GA2AJuj+wsJabMjH9h1a7v07SnWn6ll3c5
	At4V4a2NRUnyC02g6Ia/cYXNwQbHIw8uwkYxX8QiQeVCE0ljoYNfhHhH7Q0KPG4tMw77HB
	Khc3IHGBEaPbM2iorjGxiL03pp4nOgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105596;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTjTogDxANa0Qzws4WbQ8f3o4nXNMeX98mY4+62yrZI=;
	b=m05UphUCjG6VcfiTq7HuxEQMpLR8mEO4LF9xom7TIutgiUjjowN6ss0ovAhE8CQtPjS8Ff
	wBEKg5ywLVyBDwDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C98341368D;
	Wed, 17 Sep 2025 10:39:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id He73LfiPymjZOQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:39:52 +0000
Date: Wed, 17 Sep 2025 11:39:43 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	kexec@lists.infradead.org, kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>, 
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 03/13] mm: add vma_desc_size(), vma_desc_pages()
 helpers
Message-ID: <qqfw52uzfa3upljmv2nkpqsob373kyckhujsit2wkzuzik3lkg@2qkiclab53zw>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <011a41d86fce1141acb5cc9af2cea3f4e42b5e69.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011a41d86fce1141acb5cc9af2cea3f4e42b5e69.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BC8380002
X-Stat-Signature: kkdquybyo1atiuw4xbo3mcksjssu31eu
X-Rspam-User: 
X-HE-Tag: 1758105597-760719
X-HE-Meta: U2FsdGVkX1+c5RWTURpFeeVDqT4jDJWC6D08eK1Z6kFKz27NipQlFdbrC827uxDSQ1KbuMNI5OQm8BagR71Nv/YHQ4dYtKmgGb6g75+Sis3YpNGaDCW60TVt1qd1bq8WFZbQkzmKDvHATEfVnMDjgnFi1BMTh8gysUwB7EPrXSf66F6kEwP/koBbHRFZIx67z2+jjhMG8b/eX8AWzhiNs4jWUzTuBw/Qxflfet14/MMkPUvlspvGIoVkeylWNqCNFns5sdv48j/VlCtBp+XZRiwVf+y0MUKx53MhHFjxQ1YMQ9yVkOIGgHskf27LBR2sqRxwuKCyTAEIW/R16zql0IcSI1kLpvorjK71QerwLxr2hNlmMoR/UG+Ng3dWwW/LukrXEl6iFBnaTTAv5oO3Em3h/O4j90fq802ktVVSJrhSRVTMCxqN3NyGmx7Ib2lJoLgjwEZTjR5gw4oO8zjsFwrVghIKBlS7u9dXB2OP+GMKf8hCLfWzA+WILaO3vv6C4QZOWxWJSq83zpZCrX1qsjYuOHw7GSShVAZj5LtJRwqrQ8WCgNiqVy+T7iYwIckMgeHDkqLdMSQjKSRCgzgvI8NhnJvzQf3b6qZczsVpsGSEAeFph/uq6wEkJmpStJ2IZ6TAPcL356uqvPDnEErKki8N92zMw013A7ArQ0KTaL2mE+5AyJjJrlEUzA92RV0atD/T6wvc0tQ3r6ZE89kKqlzvzp8IC2tkjoKGGTRxY+Ta/DclwlXkL6h9/djWNu2OKRj5hwX8clL8viSGNlf5ujOcKNw93jWmXeYZ1mOTBv5gfLA7X4yujuTtbEZJrxR8TbGBngjI6Bemj9wMcqPRTZ1XQfaUHmtS70hzPM40XJdB+WmWKHF4JrCFBB6W3Mr1FuWzY+GLCGiGvkPZ1qBFpSv24PNbDZiyWxbmrFx8aO+K7udinIVJ2QJJPxva0/FbxfeY4NHs4K0c5Q0j3Xr
 qpJiJ3kr
 fQSza+v/Vec5Z+H9p7SPW5163W6gTq0QIQ3EgeFRpWmH6PPg2I0wKMRzxSKsGsZ1/Dch/84tEnrImJTtIPOZLXAxRIOmY947LcQJQ/kTHbmjczB0xYskS8c2DKnU5wat3MxGq+s4AryYh3wGULRyh8iz6KshFgMy+IThhVbvYwZxFk66SL/vCHTfXGt9kU3xxH2L3s/CQJuNZLizH7HIh2EDXkPxX4LiUxJYnnwmdCbYsqsYjj8nDpNCNktnmwj3UybiJTXa49uRRjrcxDF1a7PfLxAxAc3dLYIij4tdM+2SvS/MCLy0Ao0YTUGJCIOQJ8dvjfRzv2K1SCByHJiyjwzEHQTJ3D7sDtFdzFr/mR/KN3NdS/PV85oa4tknpwQecNtcCRmLXsG3pSHKvJRuE4fSj2TslAvxLcWfrS5KU8YphsFExUi5KRTSoTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:49PM +0100, Lorenzo Stoakes wrote:
> It's useful to be able to determine the size of a VMA descriptor range
> used on f_op->mmap_prepare, expressed both in bytes and pages, so add
> helpers for both and update code that could make use of it to do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
-- 
Pedro

