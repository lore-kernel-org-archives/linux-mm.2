Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E2F60A2602
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=s5toU3II;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6UsZQgGZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=s9543PU+;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QcUqJ5OS
Received: by kanga.kvack.org (Postfix)
	id 98B316B05B9; Wed, 28 Oct 2026 09:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AC16B05BA; Wed, 28 Oct 2026 09:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8029A6B05BB; Wed, 28 Oct 2026 09:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC666B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:27:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BF0CA0CDD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:27:02 +0000 (UTC)
X-FDA: 85372110684.07.D2C4F76
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 767588000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:27:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s5toU3II;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6UsZQgGZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s9543PU+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QcUqJ5OS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gbg3rAkaJieZrLUAH3flPys0KLppPQxSh26pBiYtSeg=;
	b=oxeyvtVL4Xd1oPN8lcQgkNN0rDDql5QhEpKBnLZKZ8PVCwdI6yZFI8NelZwXvC7YNduaXP
	54Zo0CymiL3X8QT/9loKpVUTUURVxfwiJC9RgwFhFfgn4730oxpTNRqeyWQkjkaFgunM/p
	wH1F3w3e2H7mjq4KFrD/r4LHKQnXPR0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s5toU3II;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6UsZQgGZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s9543PU+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QcUqJ5OS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194020;
	b=z8ocdmfhT6z3jHUF4FH1OCdxdkDTAF/8zk0EHAfRlSK9cdOOKwLM9jjE48Gzv1JzPQZR0H
	T7Reit6io0HQ4ECLzqx2Us7WzVLB2wRkVB3tyBijtjAqxHTo1sjhrjszRYeY+FZI2cqbjL
	HdmY173OjDYiti/1IyPqmqAsNoiahfc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D04BF1F7AF;
	Wed, 28 Oct 2026 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793194019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gbg3rAkaJieZrLUAH3flPys0KLppPQxSh26pBiYtSeg=;
	b=s5toU3IIDlHCPW+HgQHPginjt8csZCKinyyx1fKRGZ/uiwlPWB5XPE3nfYHV6X+hyj85hY
	wHZosPWDzohQPwvC6P1gQEnpsu0UZwWQHCFCaA4QT/drpsabPmbjxrYFH6nejt03TSShEz
	LO6gTlSruGI0JRlVm9ANkaatF/CRhTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793194019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gbg3rAkaJieZrLUAH3flPys0KLppPQxSh26pBiYtSeg=;
	b=6UsZQgGZ9hEZZAWlOkKq75kVznhmh1sh15//5Z3I+gr8cWfD4mRqVEuTlIQyg5SwiV16WW
	EPD4qFb8zNGjeyDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793194018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gbg3rAkaJieZrLUAH3flPys0KLppPQxSh26pBiYtSeg=;
	b=s9543PU+5+yZIsAmIvMnVbYZDH9U5m5AlL0Tgdp+ajgDcFY95LzLkOxoC1JHbFPhRc+EUu
	Eue9APZJ8A3c/p/AiPnvaIoRMZRRAoIz4ptt1KGvUZgtz9ouvfTFIbX4T6iYDTkuPtrhQS
	AcmCsPO/PLg3GvdG+OoDIIfEZBXkgCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793194018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gbg3rAkaJieZrLUAH3flPys0KLppPQxSh26pBiYtSeg=;
	b=QcUqJ5OS7+zDu+FcPbnwMHqPF7DtIH8TA00g54/gLqEJVUZaEccDQ85X5BHLnef5O6sAL9
	FUpYCRapszkkRfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B355213419;
	Wed, 28 Oct 2026 13:26:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kSoIIB744Wq5NwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 13:26:54 +0000
Date: Wed, 28 Oct 2026 13:26:52 +0000
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
Subject: Re: [PATCH 30/46] mm/mremap: recheck PUDs under the page table lock
Message-ID: <auH3yLClSjgVAIdW@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-30-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-30-6f74bec9a5bb@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 767588000E
X-Stat-Signature: c57f4eftsey9h7g9u96aemzpdacuhptc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793194020-950812
X-HE-Meta: U2FsdGVkX18ZZ5vHhwSMdtaDz7LzGd6Un54t/dRuhEhknuaGpDHwcq9FekeZJZ3LfWWGs4RUD6UZjr3dSXAEV2vFDxcposHt3VW8Y8jLIJvwDoaHCF/XO1EJjD6x1mQ0ixM8vTnvS6Q+7fRwagO0t3cf6gVe46MK1lnNN1RUlGGYH4Vn29qK8NUveknThwZGSEd1g4FXkwoX3WibqfGcc40KFkxK9GCPndYUpZzytWxRitizuPY5r1O+tXZVY7sWU1XmJKjamr2JwkCuOeWW7Jsx9oAnfGk6OM1Lb8VB6xwM60/hgZZ6FDmWRmdEmBprlxrueY2RpArw4XG4Er/uHIgBp8AchdeKXMNrcoTSDuPMqLeEpXPShV6vFAq/DTLsktT0IA/BsAvx0ACviH5iexl23EYQ47Zfapn4dtNSigCmj3G4vyzSnkDiHgMg3Zt04nrOx/FfisH6KGhx6fK3S61OqW09hQScfpQQPTpxep0vIGPr2Qtzf2anJWIgrqUId/8LDJgA5mEuFVgSne1zDeDvXjnqUia4w+DwK0v/Ulx4HeNSHNWg4LsAyhd9ab9sG7t7QvTS++SjSqRLJXWKBhPmU1Dlr22b33CmqLkUoRjYHI7Litw508ZMLufgb2B1Dx9pwKLE1ybZduSFH7BCgz6Igbi2I6wNJc+5XXFBLblbl4YNntGkF0towIoC1mvFdVg6T/tLsEW/NEYI8a0q4xvIsihIAcNHeXKNOviiU3AhLkY26knSY/smtZMI6y6MYeppaNmo4RVAYrLdXh6kRcxcZFg6oDWMbK0fj3De3GOZM3Wg30cqVOV7WuW6i3XiO17glPKgOjAvffxTrIxQLeYOi92OijPqx0ASMIVcXIvmmqvJ8eZtbQ7IfzxTgGpyhf784KBi+vG61rEAND/iA7GG0WofQ9eWh9PVIT0BFv/Dd6KBk+nBR7aUQKrIoUUN6xyEBWRNpoeZPDFfPDd
 YiWyW5Uz
 v6Nh8yvR1/H98m6Zih4Co6UOx2QMbJqnNTlU4LHCRmnI0Mnd5n9fJx7lKnVhK+NpscPNxhz67YF6P1uhI5v/+hddmgZMvq5/gtMYTN6zizX5p/JCMwAOgS+gGlPIyaoTIVI9qUMKJBixBDJMMuXb+NaJPA71SHnKhcm2Jg3POHU8oFztjYU7Khr9yq8NPq9uXVlRnXTPekv1J6J1oL60CJL01x+eEF6/Qixh4r5GNQG+TpHC+kYFNszunosFjnGX2USK+Xhf66y6ibdbeLRNaMZlYhr08GeCAAoxP0FjUribZ4LrTPtlXmrsNTXmjujVDqa47f50ALoUj9xvSkj14AWY9OusZY4YZ6OftnQ3p65UUVqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:50AM +0100, David Hildenbrand (Arm) wrote:
> Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
> clear a leaf between the lookup and the move. Holding mmap_lock in write
> mode does not prevent this.
> 
> If the zap happens before move_page_tables() tests the entry, an empty
> PUD can reach move_normal_pud(), where pud_populate() turns it into a
> present page table entry. If it happens after the test, move_huge_pud()
> can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
> warnings on powerpc.
> 
> Recheck the source under the page table lock in both helpers. Treat an
> empty source in move_normal_pud() as a completed move, and use
> __pud_trans_huge_lock() in move_huge_pud().
> 
> In the future we should likely have the code lookup a PUD/PMD lockless
> once, instead of multiple times, because one of the problematic bits
> here is the:
> 
> 	pud_trans_huge(*old_pud)
> 
> Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
> Cc: stable@vger.kernel.org
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

