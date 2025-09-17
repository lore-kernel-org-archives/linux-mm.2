Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2934CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CC78E0007; Wed, 17 Sep 2025 07:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064B18E0001; Wed, 17 Sep 2025 07:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC8A8E0007; Wed, 17 Sep 2025 07:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8A628E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:08:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C4E211A4B9
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:08:06 +0000 (UTC)
X-FDA: 83898467772.30.4559ACF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40AD280003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:08:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ptkrptGs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CuqXr5mf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ptkrptGs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CuqXr5mf;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758107284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/j+TghCbMxS6Hr+M6Px03nxBiobgKniH+u2vLxerW8=;
	b=UM3DkF4/wQmGySVHKrrepRkwITYm1VUxQaX1nf+G9No4wdFmQkO/3/PRrf95cjP60coYTV
	weE13cYv6vNOiYA+3Y3QPAwhxRzovrStp1Jxoq+VHhlK7Yd8/UW03pwnr2puXOBikiKMCW
	osiCn3xXdy+MR7PbQWhvy5Q/5+LXjdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758107284; a=rsa-sha256;
	cv=none;
	b=DIHQ3irLN3nYZYNHtfqnYpVu7XYO4SIHiaRQPYiDYDfHm/kr1opdc6l8G7mfPVmYjKtsAd
	GS2iDMe54BlNV0DXKSBVGtC3+QEWAatp7OCzPyHvPP7Eb+RiG6FsNRGaAGswrmkVYYgt/B
	2Sjbw3L+Zgr6ijsGpIVe9FUe6/07578=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ptkrptGs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CuqXr5mf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ptkrptGs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CuqXr5mf;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 709D02126A;
	Wed, 17 Sep 2025 11:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758107282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8/j+TghCbMxS6Hr+M6Px03nxBiobgKniH+u2vLxerW8=;
	b=ptkrptGseCISVsQSxi+p8tUW59Rrjz0N5sPnd1wzkFhKOxrWCHCwTIW4TWDHSpOespuFww
	1e1PZQAzfRkjbo8bpdzp23GXJKOG2bLZpYH6zuvmfjqFO+esZfZXR+lBVUjtyUWkNHbwAY
	0UVQEfLseGzXPrwa54eoqUh4Ta4r680=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758107282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8/j+TghCbMxS6Hr+M6Px03nxBiobgKniH+u2vLxerW8=;
	b=CuqXr5mf1f5gVEyVE/lNW/q6XMjuaOaU8Fo7jUe67po6sdGNuF62L3WB6GMPs7nmsIzR+e
	XeKtsoSUgaSSfvAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758107282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8/j+TghCbMxS6Hr+M6Px03nxBiobgKniH+u2vLxerW8=;
	b=ptkrptGseCISVsQSxi+p8tUW59Rrjz0N5sPnd1wzkFhKOxrWCHCwTIW4TWDHSpOespuFww
	1e1PZQAzfRkjbo8bpdzp23GXJKOG2bLZpYH6zuvmfjqFO+esZfZXR+lBVUjtyUWkNHbwAY
	0UVQEfLseGzXPrwa54eoqUh4Ta4r680=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758107282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8/j+TghCbMxS6Hr+M6Px03nxBiobgKniH+u2vLxerW8=;
	b=CuqXr5mf1f5gVEyVE/lNW/q6XMjuaOaU8Fo7jUe67po6sdGNuF62L3WB6GMPs7nmsIzR+e
	XeKtsoSUgaSSfvAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D09581368D;
	Wed, 17 Sep 2025 11:07:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1iOPL46WymikQwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 11:07:58 +0000
Date: Wed, 17 Sep 2025 12:07:52 +0100
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
Subject: Re: [PATCH v3 06/13] mm: add remap_pfn_range_prepare(),
 remap_pfn_range_complete()
Message-ID: <fdkqhtegozzwx3p4fqzkar7dfbzffn7xiz7ht365c3pe4x6hk3@zbfwoktrhci3>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <7c050219963aade148332365f8d2223f267dd89a.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c050219963aade148332365f8d2223f267dd89a.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Stat-Signature: 9o719km7qzzqdzhiwn8hqyjfea4t5mro
X-Rspamd-Queue-Id: 40AD280003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758107283-562883
X-HE-Meta: U2FsdGVkX18erTXCdk4g8U1QbFIVEHugAqK+RBTV6RY9MnC6sw8SEakktX62+x1EfPUu3CJwabpU71TJ3+wwIYrllp2tCIYPcplItctMr3JYmM6/KdgbVtEG6MSbNee2uQsfUIulC0XLP2mSXITBlDUckgZ5uKuUej6cNbgbeHGaJP6yI8tb5NRpVlpytQY2T+wP6GNZ3Up/R1tbDEIarK/0hkiyLNxSQMPw68/HsKJfA0j+FOAxGKrjb9MvkYAP1nJQzJYXVrHhgyaLgDmbVEQfh1xocrkwYWTfnYnZ1CO2gjFWGaqJKL1RW3Om0zloi0M5WnhBufpdlPM6wniCyBFXq4clw4Ava8KU/Smyd0xmNuy71Ba0AubK9n8DzvR988c06an/iM35Nst0cLQqgHkLWrrShlz0zvdaAGxDRaL78AlbVcR2uLO411gIxCQSnt59DQ9FGMtQSffB3AKy7ghAMgUg7AxNuyDJgNrED+GzKDWsJ5EIAprUbYO9uBFXBs9PtstQivDnr0j1HkPwgNbPIvE1fYQAYkV5dmsHcrmdHzKFCjiAK0o6PF1eHUFshAXA09c2ADroDvCnQhGHYE04cgfIdv6U+nnIrby8RI5Yey4/UUFPCqp6XQeakQz0ygoLmikd/ea6q415bTXMyfzU23GAtUIhW91YSge0fGGdvJi1mk1BtHirxVVNMAsId0Xcu8NlIY8BXJz2PxYAE3NbiFSorPKidNeCfLTuOUPB0NGfFYN8FbFB4jmq9FTUd9DEWH9xZkBYqQ7ePMXoKamqExSrjQUOMP8NyVV4dKdD8HKPaFrlJnsGs/p+nK9gpitGhWXdW8J7nINjUxc6rRxXF3gmG0SODyV9ccqxvxHOBN7Ny5wIaPELhqcXyE5qsOG1fFiOPRat+fX7/oQ9AMjrLamP6ffNIMhjjMxkkrvDN+TDAIPHi2C6tfUCQm6j6H62Q1x79+UUMMPPsVw
 h6S7VdMI
 QdcUqPFmfpuMy0jPjj5PprsVmVd31eDFqEjig09ZsX0xKyII+uF4sJEd85v3Kck4uZVuD376Z7GRVFdvhtVZns459IcM4xV421cOy6f79svOObUG8J0n9SHePWlcdZqtKyma961eRdztSt6n49YhjVlqX7jOUFwT6b/WyIZKjlFa3FUzzH29pEUZUHvpZSA0jBG8nRrwZ7ZGEcOc7dgNxAuA097do+JUnUcoYrJJbqbGMEFO+rMAIns+4yFO6Qf43jmQ7lLPj2doDr8GJApwtHYDE1njLLjOkaGXsTEyIfE5cXS98EIUy1Ymna5rCtIzi0arHljSwThXeD3VHFJAOpkZcJdl3j4nfW/P3we6vkX2lgOj9yQzqz1NAR3zvunjZm7PyFnB8FFPa/1+cXOgSSfiJoZt6b8o3pmmU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:52PM +0100, Lorenzo Stoakes wrote:
> We need the ability to split PFN remap between updating the VMA and
> performing the actual remap, in order to do away with the legacy
> f_op->mmap hook.
> 
> To do so, update the PFN remap code to provide shared logic, and also make
> remap_pfn_range_notrack() static, as its one user, io_mapping_map_user()
> was removed in commit 9a4f90e24661 ("mm: remove mm/io-mapping.c").
> 
> Then, introduce remap_pfn_range_prepare(), which accepts VMA descriptor
> and PFN parameters, and remap_pfn_range_complete() which accepts the same
> parameters as remap_pfn_rangte().
                remap_pfn_range

> 
> remap_pfn_range_prepare() will set the cow vma->vm_pgoff if necessary, so
> it must be supplied with a correct PFN to do so.  If the caller must hold
> locks to be able to do this, those locks should be held across the
> operation, and mmap_abort() should be provided to revoke the lock should
> an error arise.
> 
> While we're here, also clean up the duplicated #ifdef
> __HAVE_PFNMAP_TRACKING check and put into a single #ifdef/#else block.
> 
> We would prefer to define these functions in mm/internal.h, however we
> will do the same for io_remap*() and these have arch defines that require
> access to the remap functions.
>

I'm confused. What's stopping us from declaring these new functions in
internal.h? It's supposed to be used by core mm only anyway?


> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

The changes themselves look OK to me, but I'm not super familiar with these
bits anyway.

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

