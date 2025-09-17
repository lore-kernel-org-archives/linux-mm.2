Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5352CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CEA8E000C; Wed, 17 Sep 2025 07:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4B78E0001; Wed, 17 Sep 2025 07:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AA18E000C; Wed, 17 Sep 2025 07:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F30288E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:12:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A88471404D7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:12:26 +0000 (UTC)
X-FDA: 83898478692.13.EC27114
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 47F3C40013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:12:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRDp6TyL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXsXFJUG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRDp6TyL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXsXFJUG;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758107544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlHRHVHtHHtuuDqiW+QVhwCo9b5r8skmryrvZTDKlw8=;
	b=hu3NPfqTHwsnj/BiOgCWHG004DEsJKbEFQjh/uU9xt869oEhZVrZ3WE7F5p+xIYzfAdg1V
	CZOvLEHM52vhlcB0Mgnt2rJigRoauhwMCJel7mOGcbDQqwXPeSg1RWigyF8gIEQaT06bPz
	+0UWsPsdBpy9wt30EMzgm2hWJxKaE78=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRDp6TyL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXsXFJUG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRDp6TyL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qXsXFJUG;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758107544; a=rsa-sha256;
	cv=none;
	b=PDs5g7/JT/vqwUA0urVZHW2+o27utSiWf3TpNYYQjqS+Kt41nYa/bG/MtHFBU5l1/mguCn
	SgZU6Wju04AFexH4koyJ2XNPzErchsvvh1fFXHVKfNOgkyqlGdWxQkV8AZEQ/LyRb6ccBP
	0QHEUoSLry37xEI8m7zW02TXtMPKPvY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BA911F7AB;
	Wed, 17 Sep 2025 11:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758107542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHRHVHtHHtuuDqiW+QVhwCo9b5r8skmryrvZTDKlw8=;
	b=qRDp6TyL80LuJ4tMZvgKAmj8yXTrwYKIhNs5bqbLNAGiZQiJ+EpFejI3viuKISLeK2aUSW
	UV6hEmeha1xrUMXqimuA6nOF4oXhscwJpjLOCW7JNsMh8sp9f1QdyfIcA+jv9qOfo7WIub
	snNW9rF695OrEwT2/Xwm2ndPKK/6ljE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758107542;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHRHVHtHHtuuDqiW+QVhwCo9b5r8skmryrvZTDKlw8=;
	b=qXsXFJUGGX96shLz4Web5WHYiKLK6P1KIVDe5fic2PzZsrfigCFNZePQdSaMNUe/nxYUDQ
	RhxoO7Oh0pwJAEAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758107542; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHRHVHtHHtuuDqiW+QVhwCo9b5r8skmryrvZTDKlw8=;
	b=qRDp6TyL80LuJ4tMZvgKAmj8yXTrwYKIhNs5bqbLNAGiZQiJ+EpFejI3viuKISLeK2aUSW
	UV6hEmeha1xrUMXqimuA6nOF4oXhscwJpjLOCW7JNsMh8sp9f1QdyfIcA+jv9qOfo7WIub
	snNW9rF695OrEwT2/Xwm2ndPKK/6ljE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758107542;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qlHRHVHtHHtuuDqiW+QVhwCo9b5r8skmryrvZTDKlw8=;
	b=qXsXFJUGGX96shLz4Web5WHYiKLK6P1KIVDe5fic2PzZsrfigCFNZePQdSaMNUe/nxYUDQ
	RhxoO7Oh0pwJAEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B4E01368D;
	Wed, 17 Sep 2025 11:12:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MRcsO5KXymghRQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 11:12:18 +0000
Date: Wed, 17 Sep 2025 12:12:17 +0100
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
Subject: Re: [PATCH v3 07/13] mm: introduce io_remap_pfn_range_[prepare,
 complete]()
Message-ID: <hfczgna46ok6zvh3xxgzdhf5t5nzqybpxkmvuulbzncagmgrcy@ase57zw2xsj5>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <3d8f72ece78c1b470382b6a1f12eef0eacd4c068.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8f72ece78c1b470382b6a1f12eef0eacd4c068.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 47F3C40013
X-Rspamd-Server: rspam05
X-Stat-Signature: ettxijzfukmwncdxw6sep9f7w9qf7dxq
X-Rspam-User: 
X-HE-Tag: 1758107544-412688
X-HE-Meta: U2FsdGVkX19VfliYYVl5RJjwvEHF3hR2LdPv+n1g+Qj9HenQxxOUNhuQubYaSutBmikQQB/1rdP5PjaFvLKx+jAP4MkQeyxlrg0W2pakZzTe5WpiAvjPhgUO+a6QLN7ReGvidD5Ih1DVD1be9lCAUoZhfkGzgrof2VVvqN56g5ITqSXcmSY2i7ShmzRGa+La/1h9Kd69jncu+IZ7fqEDHwiTP+GTkpkRNtuPNmujkZ7vQAYa5diMfAT31b8qavMPMiFae3lc795KS8xnV1x80hER01+g/hY8XzMUkcox9rIV8wbVDU1A3hCzLV6t+eVTECG5Va8WlSE6H3uE2IIsh1z6DTUQkPiaXBC5G2mzzfGNBDFJljr4XjuKhp9QePhc5Dav7jphYyFZ6ddwyrYMog1ugBkIeZA6CKbXlDQ26tSwc9hnr2B3Lxpv3lcfT38S7iyBrvWrL1VmmkMeXS6v86OLX/4pL6JJ6v2rn5ACFgF+aEMzZEK60Eayyl7wbDxWIgWxSia9NeXpy3hC8CoYILMUXIiH/O+j4eJCjsQPL4oKuSBEoXcv59phjo0eDimINaV/PTzIeQ0t7B/uqNEGcb8c0ofCk7YJ2fYubW8nFS0wQWQRmTGaZ8UIOZRFPhCbbzcBhK7xk9cGLoUQILSX+sTaU8bDkJjYolnHqAOQpPkY18cm1Nlvvu+eIJqhuGTdPHDnZZVYmXj7HJvoR0z35hU9SFm3/oh58tdPhlJDW26uQvr4VFN3JjTqyOTiwV1K5oDq1m4ZvmjZdAE321EWEEVv985C3dRFuz8kOIZeHT6SmW0WS0nq28XmB0j47TCELMcc34tzBqIZvL2CNFQvkrxvbSCu3aH6Xgyuy42VO7spp666NayFH4DOSUMaIZ9PfmWzSBOSv5D2swXhnOt3bVGUkXP40wBeMil3KRd3CFqxE3YevxNDlgHMVAGm8RZfj/1KhC68/Xaj9cppc4v
 CZ6LDrh3
 cPx0W3qtK94BO9jZ9Vj5Vuk1Ooaqndu2pS+4LVl9HRJEum20jQU9WLPl85OpVt9lTdxjLiSc+Kabh+aHgFnVwCfV49GALT64LeO+NlpKHtRiH9C7SqK5zK6UlD62UPcDVw8wm5PNgbnMEERaJFhYsuZpoW6fQaQYrOhjSRZzQcvmYH7a7i88r1oMPwEjNeeq8b2E7+GY38nEB7/bMnxE5t7Iq82gNSj4hOFW82ydHpOOA7bOsSJd8gO5kssRyKBKY2kZ0Tirv7DNKipNv1kkR1Jf8RFe3FRrEWrNSVOiDELWuLsDLtvlNDLhnG5LaNz4Bx2c9qvlf7gEzmdbrSHfZZKjMn8qx43qjm8U5QD4it4fb0SK5sLkG5jR/nKhxvwTM56k3GlJLXMd332GDqCmQCUauYnJDmVeL+jHd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:53PM +0100, Lorenzo Stoakes wrote:
> We introduce the io_remap*() equivalents of remap_pfn_range_prepare() and
> remap_pfn_range_complete() to allow for I/O remapping via mmap_prepare.
> 
> We have to make some architecture-specific changes for those architectures
> which define customised handlers.
> 
> It doesn't really make sense to make this internal-only as arches specify
> their version of these functions so we declare these in mm.h.

Similar question to the remap_pfn_range patch.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks ok, but again, i'm no expert on this.

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

