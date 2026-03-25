Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95544109C02A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063366B0089; Wed, 25 Mar 2026 10:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03AA06B008C; Wed, 25 Mar 2026 10:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92E56B0092; Wed, 25 Mar 2026 10:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5FA06B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:51:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7985CC2FA1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:51:13 +0000 (UTC)
X-FDA: 84584873226.14.D6B9E0D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 213C1140012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:51:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HWmOZ5Fg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u14cIhOK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HWmOZ5Fg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u14cIhOK;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=yyJ/UtV8rS9zlz0L908z8QTi971uziR/bWTGZQlj1gEcJUTvxDJa256z5d1XHmFgDvV+jL
	N4nkeKAvYA4AZ486KRMrkDVMD+wI+Yyz3akLBG7gCEnFJg/Z19hKZA4tBPbWrYiAyPGVvm
	E09esZ6n9dKncWlVw6Haz95TqRNhFvE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HWmOZ5Fg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u14cIhOK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HWmOZ5Fg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=u14cIhOK;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450271; a=rsa-sha256;
	cv=none;
	b=3mJbRJMB78SHByCZFw8BzvbEOduSDpLozEdDiGUIaVUQ80sJvCZZQJRiflnE/vHYqVuKe+
	J/sA+D8MoC9UBCKGqcKtgroGL9EnD0gISIFkkzDrmpcEo+3w2lc+utXYyiZKpie7sgH/yK
	R7xuBpEobir+4PRdTIarF1kATaxaecA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63F235BD52;
	Wed, 25 Mar 2026 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=HWmOZ5FgwDtrteSM2Ew5PXqlKiEfNmaAxZwNcrDu5cm7qqyNqx+T4KuS+fzLrhGhLe0BMw
	4jK5lnRLUqHsAlBFQz+I+hBfsPpC3uQ9V4D0BKTscU6LcEG3GYwivCMcvxhC1hemevb4sH
	uOKbUkmNtRHNhlJlq6nBbg/lY2lzSfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=u14cIhOKRc22D/k23HZ0bIZUBPARER5TAWoWA++mI3iuA8hY3F7HH/iLi3+LZe1XvB+eno
	2GHcX4DZFxOCZCDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=HWmOZ5FgwDtrteSM2Ew5PXqlKiEfNmaAxZwNcrDu5cm7qqyNqx+T4KuS+fzLrhGhLe0BMw
	4jK5lnRLUqHsAlBFQz+I+hBfsPpC3uQ9V4D0BKTscU6LcEG3GYwivCMcvxhC1hemevb4sH
	uOKbUkmNtRHNhlJlq6nBbg/lY2lzSfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IbrNguOL2oU7ugpbxDymPY+bcfAOeIY2ch0aNWgxbs=;
	b=u14cIhOKRc22D/k23HZ0bIZUBPARER5TAWoWA++mI3iuA8hY3F7HH/iLi3+LZe1XvB+eno
	2GHcX4DZFxOCZCDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7C9A4445E;
	Wed, 25 Mar 2026 14:51:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zMJkKVr2w2nWXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:51:06 +0000
Date: Wed, 25 Mar 2026 14:51:04 +0000
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
Subject: Re: [PATCH 1/6] mm: rename VMA flag helpers to be more readable
Message-ID: <6c6le67q23xsity3tkfq2uazzhwustmqcsqj3talft6qq737hz@dytog6bi4vsa>
References: <cover.1772704455.git.ljs@kernel.org>
 <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 213C1140012
X-Stat-Signature: m64cwsxjhodoo8zcota7yhbbou6zc1qf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774450270-652858
X-HE-Meta: U2FsdGVkX1/hgo955+zGIt3JwRgNDEuzxiX+hlxlKGqiC4LzvNeE92C9B/cgJ361p0T+eUyqYmDko4wVfnMgctRN32DNKmISttB8TOyhHDR5dCYOFhxKfSv2DBAAQNuBzeOGVGUY7Mjlmu/4AsLOXtN85RT9J2eDqGMNoWgoanZyzIul8BbCcZyXk7O8zhIm/lFWhlIZ8I2yIZB8X9XKyh2ZgYzqswM2lZPUOzxTaXkrJz2Ho/4/Aucs4t+fEjTPlZFS/k3IXsx44YImUA6Coeoql9pT9tQEMA2CM9DUbbi28EN+3gCJTtl6XdosV+hNBvJDFw/PoFZ94tkMcvbXY6+6HYduoKsLwIwxMJKT2kjXBUKZtNc5DNzBiFiTrIDuF+lCW6EgD/jA7l3wLIK7b9qSEbLKLEpw7B7cdIizViH3hmj3AlFQnk0/AiWL8l7RZQ8A6txM7zhihG8E26jvaZKCtzlzr1cKWJCp+pwtuppaTyMV/zQIw1OqJtQzlROK1WmoILviz9ZlM20nnoYmYXfoTHPFuTVVKtY2ssvbjOzIf3WuzqkWtDUE8vHPAgsMtG6qdm9pm6QaSTuQIMFNfJ+yYqUUumyERfSPO8iTcqQnJ0trXux33xuJCIlkbswquacuC26/1zPCzyV1OPeJn4PS9IF5CCKOSWG5E833aeKND4Gy2KsVoQUKGYBCQ7wCjpcuCDjq+zZvUOON7d+B84ISUhhIanN+T6RyvJxiNUtOtqTzTSx/UKtbsKAgktnKHa1f8lzmKf4dQbBkZLw6PddZiocM/35Px9TPmoUZaxpixnKFFWSlkMgkPDKpSFtPUamkpXTxRIRTwkCvDd7Z+Yb1zks32ErFNg2FxLKKkn8fDB6M6YeR0anVpsLakNt5toUN35KPUom6Pgeppc7J71qxTXy+arrzotxTYn0tdoN+4Vs/mdAy1pltWMjpeTQZJJ2B2EBQVOJAUI2Mlw2
 txhZlPUs
 g5/HQZ1NK35F9OU/NLeM4KABmySmQm77dGcnElO8W2tn1zpSGwsUNkmjSSeO43dlB1wwUifgnw8VBST4c+iqVsgGuGWWDkIWC9E2Qjb5yLUjocimHffCfQ7yq3PxRmE5iRsppVYsmoiM1Wm8BCctOL1tOM0cpQRhMDXZvtEdVsCwVkAG7fFcA/tpbeBQe6uIiA8XteeFhhCwdrBq+//2omFS+sbTTEVZuTX9ivFD/8/3own8xA8a2j9A1yGhgJxHg/UpgQQqU+TDod8OiBdyEXUyiz7saw2WaY4kAwbbRRSrzb8C4k6Yi8qbVa/B9qNvBQDsvdAXug3aOjQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:50:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On reflection, it's confusing to have vma_flags_test() and
> vma_desc_test_flags() test whether any comma-separated VMA flag bit is set,
> while also having vma_flags_test_all() and vma_test_all_flags() separately
> test whether all flags are set.
> 
> Firstly, rename vma_flags_test() to vma_flags_test_any() to eliminate this
> confusion.

Hmm. The names are getting longer. We should fix this One Day.

> 
> Secondly, since the VMA descriptor flag functions are becoming rather
> cumbersome, prefer vma_desc_test*() to vma_desc_test_flags*(), and also
> rename vma_desc_test_flags() to vma_desc_test_any().

> 
> Finally, rename vma_test_all_flags() to vma_test_all() to keep the
> VMA-specific helper consistent with the VMA descriptor naming convention
> and to help avoid confusion vs. vma_flags_test_all().
> 
> While we're here, also update whitespace to be consistent in helper
> functions.

Extremely amazing patch! you were truly inspired!


> Suggested-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

