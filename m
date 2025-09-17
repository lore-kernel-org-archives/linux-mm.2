Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC6ACAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53FA18E0008; Wed, 17 Sep 2025 06:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFCB8E0001; Wed, 17 Sep 2025 06:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7538E0008; Wed, 17 Sep 2025 06:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 252C78E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:49:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC3CD160134
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:49:27 +0000 (UTC)
X-FDA: 83898420774.17.E55A9EE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA47E80009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:49:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=niTkxtcE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7sXTFmdj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=niTkxtcE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7sXTFmdj;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758106166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=d695oaOP4GKQAO0frVTlTBmK8i0ksJWjRm3q3QQLWHcZtiAb9w+PBuZKFKNPXrVP7dnIJE
	7s5qK00f4vGZDho/TkPN/Qsc7NzOjTz7a8+jfisZBlJWhzy1Z0f69hgPn7k5rfa9gPQuiS
	QswhAoWqOGR7tjDDOsHs5ZYTlO3egFo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=niTkxtcE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7sXTFmdj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=niTkxtcE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7sXTFmdj;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758106166; a=rsa-sha256;
	cv=none;
	b=jDdVYHgO4+Rw+/Vr+hdb5oRU8E77hcoTj/KlvJFF6jQTca6ep9s9oEsFUOp+/JNpCtw/ow
	7d0ihf4z50SeMYXulBE3JC7BPxtq7b6bSCkXlMkQ5HfujJwMP+VmSlUJW7eHajTZ2HSKet
	yoBQdgR9rh0EiJsrtgtohI1eysiuxOQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 054001F7B8;
	Wed, 17 Sep 2025 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758106164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=niTkxtcEsWHMLusW2uhOMmiQ+Zfat7dgrfB4F9HpeVv6d6//vidrvTnU/aJ4FYqBUF6/31
	S8xdorf8fnri1Yz4VUshF2jJ8nD3YR9xyA5krXG5aE2bhuBHqd5dn3msDcKISdnCbwA/zG
	3PnSCfyh+pAV2PK+IzaNWAQWDSAuWLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758106164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=7sXTFmdjfBvPh9vPl+957gltmt72YVjGoLfmTjzZc9/62+QYrp3JFMXUWd+wQo8Bl2PL++
	hD8DSBFfFKYnHNBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758106164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=niTkxtcEsWHMLusW2uhOMmiQ+Zfat7dgrfB4F9HpeVv6d6//vidrvTnU/aJ4FYqBUF6/31
	S8xdorf8fnri1Yz4VUshF2jJ8nD3YR9xyA5krXG5aE2bhuBHqd5dn3msDcKISdnCbwA/zG
	3PnSCfyh+pAV2PK+IzaNWAQWDSAuWLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758106164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u8t6SHPjmQz0qqNQrQ8pFqlRTGyimMO7f4zNnyjDmnw=;
	b=7sXTFmdjfBvPh9vPl+957gltmt72YVjGoLfmTjzZc9/62+QYrp3JFMXUWd+wQo8Bl2PL++
	hD8DSBFfFKYnHNBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66CFE1368D;
	Wed, 17 Sep 2025 10:49:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 50PgFTCSymh8PQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:49:20 +0000
Date: Wed, 17 Sep 2025 11:49:18 +0100
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
Subject: Re: [PATCH v3 05/13] mm/vma: rename __mmap_prepare() function to
 avoid confusion
Message-ID: <jokgdkyv4ca4sb7nl2wjkzxclhzhaee4p4luwj546tsdbylfei@laplfpugf3of>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <3063484588ffc8a74cca35e1f0c16f6f3d458259.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3063484588ffc8a74cca35e1f0c16f6f3d458259.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: CA47E80009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i86yq7i5un17dat6mejgdk6r4sects7m
X-HE-Tag: 1758106165-317283
X-HE-Meta: U2FsdGVkX1+izHZ20HL49saSzw0vYcOVUJM+/W6Kw8bMP+ZHasUg7HcTnRoSfm9PAbM8Iqy+FzM+ZdBBxUWPYpDeW5dQyB+MDsVeI9a8dlAs33oZTAcn/c9P7CpVYNYhuoUjz+WLWiRaxD1vqHH9potbZzMzJRQp32klT7pKWcST9hFt1+B5TZjYCAugg/SrYDpULeTwBmZd2xa+F/XUQUYkdMTdGAWDEFE98jh6PC/EkHFrdU1KvlvJ87M0dJzbU7sq6Q6sJr8LVKPlltKpr/ZS2DBzJG3H0a4XiPYLQ0/K2Ow52xLBeiVS+4Bv+ZHNZoSHm5yGNJARcKboamy/cBkp0TySROMHXv2Ebx3yCRWqHNtUBO86cThW5nupIOgPUNLuZ655qwdeHrU++HRXlbkSBhUxrO6EhvDdTHlDgmXI0C+1PueiBtU689w8tj7Ub6hP9n0CatzBCQiN/JoACEI+kNlWXgLvZsyW4u1/mQjpr4NY9GymvS09dcfska+qI/RTUFdFHAIvA4gkbRSNMDNCYLN2P64XxgQ42bEkpohIdsGtuIG7x6qOnzjYD1+1MVncvDm2vkCjxJm7+TSqfiU769f3yVy02UbO90JCNwp+6EnPrEZ/Zp5BGCDx5ZrTS6dPZv3e4y1ACKOEYoLGVcTKT/0v6ukdh/89A6oXmZ2euNtcEL6lg5czGvFA6rQdW7ux4ITOMms9kzy4fiyiCv3gBHzm9NZVqpZCuBfJWE39JiYZs7pbfB16fXjRQX9POiUSk2agM5pz/S5g2D6PsOikXh7UY68fAbxms+l0jgOVuRxrFQyGvy0cfDEwpDMSmdgcNBIXW4lc4wzRO+lWetzK3zbf+C3JAJhnx9JRQByvoppZEwJdBYjqa6tAMtoVv0VG/EocJSoUGUSOiJcY8OzeXVpo7Zaucdz0NLKCMwiaslyLSf06W6KlEq2g8/9rsZ3kHirMBy/tEJELqJq
 vuqoEIDg
 lLMB0HjQQHbmNCOcrxmOAAmz5MZVc6mPDfiONCOTdxNzHOHNNy4FNgfUM/6P8uZ/X2LHI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:51PM +0100, Lorenzo Stoakes wrote:
> Now we have the f_op->mmap_prepare() hook, having a static function called
> __mmap_prepare() that has nothing to do with it is confusing, so rename
> the function to __mmap_setup().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

I would love to bikeshed on the new name (maybe something more descriptive?),
but I don't really mind.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

