Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8DF109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E8D6B009F; Wed, 25 Mar 2026 10:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDEA06B00A0; Wed, 25 Mar 2026 10:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6946B00A1; Wed, 25 Mar 2026 10:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 967AE6B009F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:58:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60B5C8C4A0
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:54 +0000 (UTC)
X-FDA: 84584892588.01.1BC1EF9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 238A6C0007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IhruEwm7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pyz7FTFK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IhruEwm7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pyz7FTFK;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=fNvzamKKG/xSI6PmTPhKglzcy07zV37oPY2DW+RhJT80bIvEAr/tFQb6C/SDDotmmVbgZD
	0f9R3+R/IPpz42b1UD8T0HfcnunY4jCg8qwMQmLvU+slcU+lvMliUUQrtKbtz74Fdvh+gJ
	mSm4lQdxkxJCMFnzN9aJOqVYE51Cxqk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IhruEwm7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pyz7FTFK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IhruEwm7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pyz7FTFK;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450732; a=rsa-sha256;
	cv=none;
	b=SA5He+I3cQc/awRq0SUI2WGV8Mg0k9to64YzeaZGtGYsTaV6G30Mx0ov+u0DcukgXfcN8T
	ul3t/B46hNCOhCMr3g7UOmykNkAZFLrFcJzHepJHn1uszlCnKP/dw61l/VQLfWDmbAXyOL
	wQUSElW0GRm1SwuK7xytH7wRDU0zldg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E3734D247;
	Wed, 25 Mar 2026 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=IhruEwm7GYgYiYdj14/ihXFaqlkQSYC9mJzbZEysOgULoLEYc2th5nMp30ovZGWxl6scH9
	VdKlgBokFm+JYe99fBAmGMdwcFB/jXWuYdNtgJ0Kp4Q2puyNmhT7wAu5U/54EYpY7SC3QQ
	8kJnz33VQL3afgG9AY4l6hrcUQuCiEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=pyz7FTFKDSPa38IybHttOLNkOCxY8GUGNa+tVSLpg0w3uGkk7fONUm1DgIECQNVtgiV0pG
	s838nfi0QtNQzJBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=IhruEwm7GYgYiYdj14/ihXFaqlkQSYC9mJzbZEysOgULoLEYc2th5nMp30ovZGWxl6scH9
	VdKlgBokFm+JYe99fBAmGMdwcFB/jXWuYdNtgJ0Kp4Q2puyNmhT7wAu5U/54EYpY7SC3QQ
	8kJnz33VQL3afgG9AY4l6hrcUQuCiEs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jwFJ1YKM01Dmk1VMUDaLnYk2jOJpFExVOl5kgZ5RDj0=;
	b=pyz7FTFKDSPa38IybHttOLNkOCxY8GUGNa+tVSLpg0w3uGkk7fONUm1DgIECQNVtgiV0pG
	s838nfi0QtNQzJBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B017944466;
	Wed, 25 Mar 2026 14:58:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gDSRJyf4w2mXZwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:58:47 +0000
Date: Wed, 25 Mar 2026 14:58:46 +0000
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
Subject: Re: [PATCH 5/6] mm: reintroduce vma_desc_test() as a singular flag
 test
Message-ID: <kci3actvfoj2rc2i6znf2ff24yu5q7ewgo2byqegmhjiv7ptzy@4ppp3xt5mwq2>
References: <cover.1772704455.git.ljs@kernel.org>
 <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a65ca23defb05060333f0586428fe279a484564.1772704455.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 238A6C0007
X-Stat-Signature: 5bryph7xmma1mjeufqbrdacq6zcj9mg7
X-Rspam-User: 
X-HE-Tag: 1774450731-781382
X-HE-Meta: U2FsdGVkX18Utx0esV+8Ppomwuij4kySprJ67kknMUA3h5KblivHsv54Gb03Z3nHqqSByrfCLDDz6TrVUrcqbdDZWin5zGljAJzvE+l9dsIJycnM5M9Oq0Xd5jwkVEYrGtimnhCxV+ZT+Xrle6+iQ/F7ZASSKa88D9GlGaEb5qIA8PcVxrpzKoIK+6+OHivPdNSPRPQ0gw/lVk8Jlw6D0A0M8X1cVR3RsQgIyEtz1RMrk9nUjcrKVZWIGUskDtlZupk9Mzi6KSXiqNnbDwMvT1Srh/XWLJFVcFkx97+AtijBEssrvaaKJDXaDNl9hH2FtuwSHOMnAnw48YQvRL2ZeTmbEVQiIwRRNoYRjTjxWLQkaArleNjVrjqxwqUU1/vxyALWjuBWyuEC6yd5wGJ1VIbjiZLJgWHZCgQezso3eddDW0Gj7zwW3nJTV7uNmwT2drlBTEPZSiFxxIefcHnjzsyR6FUcH+UnkfsznQL69j5jUMDgEqt8mGH97gMdOCChluCQ+5yFfiLVvJfTSqul35Y0iuMUAPamyRu93UCMmTxUgqRmgJZWd6Uu01LZKT0wdRPy+XHkFIlRKwkzuvxCYvmavrUxeT2Fm7v/tp6HAGbPqSbiTvsqLB0hG3jybNlAL7g2WE86wEJdcK8YbOWH6F/hW2R39ybe/oWb9EMcmPN+4KjBoJtS0R3Xvqvo+ipahkfoVVayzE3w646F37QzsPmyvKobwve7eW2v3dYRnhwX2D+fV2K5tCXXtROCD/AVCRC8NYLPOg9c8K0gkMUTYb11mCVl1AikqMTahIp+BnO85rAptV3I78cSGoum4+e3M2qHYbDSuhJX80t+9r32T7t3tzZHcxcqV8dTqqPax151cxMyo2j9xUHOGhziVmD6jOWY3d42+E8TlILoa43BIzOaty3C3cidyTzV92vcZdgo1wmp7jO+5aOlY4wPvQbFgDfu43qlothy9e1RCY0
 iBRtdTTl
 6scphjMG1A3M5FvOERZWbrxZeyRCdU6NIifz41soynSwYz498uiR4iIZLjHb7M+0swvRElemdneh1UHnDvqwAd1bdrIlHGS57i5GL2dPz+QAocfCvtEmYYfBb3wTtDJD52hDx3a7oRwOoaH/KFH+Ac7aWER5TdxeGGZGUnopwY4VAO86Nnj8XhCT7OLxKd8S+nSheY0MCTQh0cZn0X8stuZlSwsDrOjOBDMljKKMxieeYGnXQsfHl3VvzzEsV+U5SkxZimjZCjN/i8MAlZv6GUeFSRqe8vEfw+xSuMnxUare6fKGqG6Ca9F97bkKeCyy1ByFm6Z0rp16CKBXZcNqZNWYJDMxDMiY1vK15hJft8OZtUi1zTvhjAXrSgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:50:18AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Similar to vma_flags_test(), we have previously renamed vma_desc_test() to
> vma_desc_test_any(). Now that is in place, we can reintroduce
> vma_desc_test() to explicitly check for a single VMA flag.
> 
> As with vma_flags_test(), this is useful as often flag tests are against a
> single flag, and vma_desc_test_any(flags, VMA_READ_BIT) reads oddly and
> potentially causes confusion.
> 
> As with vma_flags_test() a combination of sparse and vma_flags_t being a
> struct means that users cannot misuse this function without it getting
> flagged.
> 
> Also update the VMA tests to reflect this change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Similarly LGTM.

-- 
Pedro

