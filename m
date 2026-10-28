Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF128606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IkyIrlCN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=h5eyniOO;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2FB/MODf;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4dic7x3T
Received: by kanga.kvack.org (Postfix)
	id 1E8A46B05B2; Wed, 28 Oct 2026 09:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1666B05B3; Wed, 28 Oct 2026 09:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7926B05B6; Wed, 28 Oct 2026 09:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E11FA6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:05:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DEF61C471E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:05:14 +0000 (UTC)
X-FDA: 85372055748.29.5F6EE4D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id DBD351C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:05:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IkyIrlCN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h5eyniOO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2FB/MODf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4dic7x3T;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793192712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFm+LF82pi5PZQRWnWdZtQasBy7k0lWkzPhNGbo8lwQ=;
	b=1VMsfzot8EFDl/or9C1p0u2LnLWOlAxSP6AE5hA8e0JyGEdVkG0D3w+UdSVeyUqkV9MyEQ
	KdtQ+5L+GruSFvjqu457Adqn4vi5yWZnSZpEV5hZPuR0T+iiMHTbtgo7BSv46GCrUDNvty
	lChw+GiimkHzJ8xu2PdrzdKffiYlGJs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IkyIrlCN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=h5eyniOO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="2FB/MODf";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4dic7x3T;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793192712;
	b=ZrESt4Tde6Si8ntKqH7TcKhYuC5EokiH4SX5kDP8sNVJ6F2is+O2tOtir7bAA/ouQrvURv
	KUcLYSVAfQo23whUb0wPQXpYSzCpkO3y8+cHaXimYKkisAPC6pfe88BBVMriB7sK9Pssiy
	/U1oDzroX0xqtdAuEDjg1rTESE9P8oY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7717A2213F;
	Wed, 28 Oct 2026 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793192710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFm+LF82pi5PZQRWnWdZtQasBy7k0lWkzPhNGbo8lwQ=;
	b=IkyIrlCN7G+xZvqNgVghwMpBI8ng2bOlKjOdDzhEfMRQg6rt8YafWJYQp4jgsQ9w/lB33H
	9FBPHphhQPAOp/XOKHNr+fu5p9eYndRTrRcFNq/0Op99xtiVrbRQFMThClRVauNxgN6V6X
	wfczOgguTF4x3tTmDUcStTIG3Iah8x4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793192710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFm+LF82pi5PZQRWnWdZtQasBy7k0lWkzPhNGbo8lwQ=;
	b=h5eyniOOwdXc2q7T7Pk7UL3no1bmGUgM+F/72NEfzo9ftuBZSX85MPbkgavJ2oP0IWltjD
	1iXG9iI4uKqlVkCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793192709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFm+LF82pi5PZQRWnWdZtQasBy7k0lWkzPhNGbo8lwQ=;
	b=2FB/MODfxpZ0ilwA5PHgCW7NNYtSrq/W5boCvDL1GRtYqDPKkanrGQkl2gpE9zCifdCSBB
	nXXGSTtLKo5Qg9iFAVvIlvlt2JPsj5aQlGkeHsfbUV/bRZhcWaORCRSTbSoRnb8rfrtgqf
	Zw/R3EHhTn49+ohBRC96Ycd2MjnI+KA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793192709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZFm+LF82pi5PZQRWnWdZtQasBy7k0lWkzPhNGbo8lwQ=;
	b=4dic7x3TPMbFvoBJ+if+DDgdTri1Ltf7/N9AT6Le0B5ucrxb0ojV3Z+Ip1NOCne3m0B14q
	S8AEDvM3JKZPQnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FA2E13419;
	Wed, 28 Oct 2026 13:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7Zm8CQHz4WrpIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 13:05:05 +0000
Date: Wed, 28 Oct 2026 13:05:03 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 11/46] mm/huge_memory: properly handle refcounted PUD
 mappings on fork
Message-ID: <auHy17vcHxNIAlCF@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-11-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-11-6f74bec9a5bb@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBD351C0006
X-Stat-Signature: 1njymuayy7177iibwrgmzib8tjnuoz4b
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793192711-220978
X-HE-Meta: U2FsdGVkX1/paA0ndaUgUrHUrKv4EkXkM0GbdmDBUKnatacPvSmLI9ZTZmvsl2Zmv2kLOqaG58S3OWoaQDxlJh0wX1Rkgeg2/BwYbKIVPahdarkvY1PJRFhAjkU9an5I3w7jJK5VwUSkEuuZqrKhwZZ8Svbh/i9CAHW1i23UpGOZCFdUuWTOV3vlN6wnXnAsnlPnISMw7bu3yZ3maAoHqlzdr20zVBvP2ymIkC8G0D+B9I8Ks+cHilAIcLRRYP7HnULNQDrHP/rodNzNn2zgtj2cOyT4SqDYZ8SOxX7Ab59DWuAZaGFOTtYBInDz/g7/oNZ9mcGfRHJvHE6uIzVG95RcL6zoclwbCrc6qwOGJgMuQ6wHobpAS4R5yxvxziwN7vkbpi6kvFIEXDg12sPQdac9RRCPhmbS3MbvLV34xhAsvcsreUEpsDtq7c6+lzULO5l0FgIk+QzMkEmE9QfLE2bBPCKaCA69MMQ5tsgnDADu9eGHLrsTco68EPa98MQsNN/zKADOg1+Hdy6cQov7sAf66x5D8kf9lgsdTg/TMoIVDNQyE+06xU6jc7Jga+VP5hTBIxXBClwx/ovYah6W9GAbKHU8XltYCISmcQhLGBLHwFJIvbYr+kW8x72EBpTCTbG2zwAvn3CwsldiVajB3xSZQANpZrZedcxVYjMMpm1DeUoy1agy/OpnW8UTB3vK0fHV8GKNtbwK441PkqKyqk52vKBcXI8V5T8iG4N0b3i1rB/t6H7/0MW+cWOdm96YZPD/m5f2GWQo9KlDhWGrqJnxyYIVgzio6gRtvJBrX8G5C1pmUy+EmqXHMohXW27rgdQ3luo8cJk3av23bPGNBeIqTCkj9yuff0uLUf2mMWUNN622l0eYUjp7x6cjqON0BDkzFRwpgry58yc4Lj4COaZxxPhhUOTWs8k6gXbVneFcz8jUWtBdunAlzABQrXDdjgRidxhprJNuK+wR+AI
 5V9ynUQA
 qBXTh9WCRXqZYNQWzPOttdKymTrwLHqxfDop31QrnTDey1naOoaknnlNESmfKOnNAUyjow8BeLV/UqCInFe2TwvjasyYa0XyHwp4vojxH0kzIeamUtV3JbUapct69GpwKVEkwZt8jRptrJuTE2yOmYU7kRZapS2sec+BjGNiDhTijHc5BU+N9V2ipwk1PKGYDCN05ppzwL2Lo+QuKzRvcE3TTpHRjWCf2dJ0TUZxx0NUZ6CEktp2r+h618Qas/e69L7QUstD6lL+6XJtFERN24Y+fn7SmxZwMdzmRKVEBpM3wNkKL4JtiU/Ha+Lfb/7oevRmih/21dYFR1mO7Y9crKHN0rwGU40u7rHOrzKh9bv70YJjqkKKhda1l9+XKvlVtpoF0WD8+q9Fx7xG2Qcfp+Oponw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:31AM +0100, David Hildenbrand (Arm) wrote:
> copy_huge_pud() copies device-DAX entries without taking a folio reference
> or updating mapcounts and the child's RSS.
> 
> For example, MADV_GUARD_INSTALL sets VM_MAYBE_GUARD on a device-DAX VMA,
> forcing copy_page_range() to traverse the whole VMA on fork. Any remaining
> huge PUDs are then copied without accounting for the new mappings.
> Unmapping them in the child decrements accounting that was never added.
> 
> Use vm_normal_page_pud() to identify refcounted mappings. Take a folio
> reference and add the child's PUD rmap and RSS accounting before installing
> the copied entry. Pass src and dst VMAs consistently instead of src and
> dst MM. Move the TODO.
> 
> Fixes: aed877c2b4257 ("device/dax: properly refcount device dax pages when mapping")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

