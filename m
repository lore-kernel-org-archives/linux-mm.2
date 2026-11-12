Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F1F606B375
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sM7KPGRL;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gVQNZ2tZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sM7KPGRL;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gVQNZ2tZ
Received: by kanga.kvack.org (Postfix)
	id 5DD336B05D8; Thu, 12 Nov 2026 06:27:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B38D6B05D9; Thu, 12 Nov 2026 06:27:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3D36B05DA; Thu, 12 Nov 2026 06:27:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEBF6B05D8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:27:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2EBB14053D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:27:24 +0000 (UTC)
X-FDA: 85426241208.04.66E1D00
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9607E1C0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:27:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sM7KPGRL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gVQNZ2tZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sM7KPGRL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gVQNZ2tZ;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482842;
	b=aGhHOPfmMtilPhzNTQJV51i3Kc1tG9xZpPNNfbetSicF6zHB24qRhKjkSkK7sXpTR3sPZc
	XVl4BV+Wp6JlPkgRaMNS0REYJXc4jNR6h4IL4J09su9pbYCTpyzxflGlw+iQzMhbY3oPZo
	Gs/FnOK+LOfKthIETJRP9VWMbFE+Qbc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sM7KPGRL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gVQNZ2tZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sM7KPGRL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gVQNZ2tZ;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qfAWejTqt9HBexVssaPLw0dtgoyKn0a3iu0Ya7NvI8=;
	b=72bH8zyA1FqmCyXe8yBPYnGulEDjhARHRNTgctoG2CJBt1MBNEJ9AgXQ7f0e3gLPlR8eDz
	FZJ4kK7pFRaaCDMn8MRkChWVvWag9ympUwj6JXcWFg2+sX6QVufnb94hpPiV9h5HjkwN27
	BS3LPBHTcWD+c8+Kg4SEi/2ybL4oE+8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44CA61F792;
	Thu, 12 Nov 2026 11:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794482841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qfAWejTqt9HBexVssaPLw0dtgoyKn0a3iu0Ya7NvI8=;
	b=sM7KPGRLeR5zKC6G9M7E71I+TyYl/b2I6VJz2zCNKtDRDd5in59lK7f9hvT3dGVdXNqUhS
	fTKlp1A453ihhrHCqUUBwCwJXhKxa6+zZHADXxkB5F6vdEkqOC+TgbtU2OO0eR8IjbBB4R
	gPkM1gxlMfTuqg+VMshA41ucEGTN7WE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794482841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qfAWejTqt9HBexVssaPLw0dtgoyKn0a3iu0Ya7NvI8=;
	b=gVQNZ2tZMKKVdEHUKJ8nLTnuR3R3EyvsEkvOUc/dcVlKzdX84GpQyLU3dPhhTmn8bsiHjx
	Ff3efzWNTvBNcICA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794482841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qfAWejTqt9HBexVssaPLw0dtgoyKn0a3iu0Ya7NvI8=;
	b=sM7KPGRLeR5zKC6G9M7E71I+TyYl/b2I6VJz2zCNKtDRDd5in59lK7f9hvT3dGVdXNqUhS
	fTKlp1A453ihhrHCqUUBwCwJXhKxa6+zZHADXxkB5F6vdEkqOC+TgbtU2OO0eR8IjbBB4R
	gPkM1gxlMfTuqg+VMshA41ucEGTN7WE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794482841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qfAWejTqt9HBexVssaPLw0dtgoyKn0a3iu0Ya7NvI8=;
	b=gVQNZ2tZMKKVdEHUKJ8nLTnuR3R3EyvsEkvOUc/dcVlKzdX84GpQyLU3dPhhTmn8bsiHjx
	Ff3efzWNTvBNcICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A63AC134A0;
	Thu, 12 Nov 2026 11:27:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N8F0H5ai9WraAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 11:27:18 +0000
Date: Thu, 12 Nov 2026 11:27:16 +0000
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
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 02/13] mm: cachestat: count each page only once
Message-ID: <avWicfogDlC5xLZQ@pedro-suse.tail5790ac.ts.net>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9607E1C0007
X-Stat-Signature: jw45xcoocoyw5tkk7nwj4gufa18a47sp
X-Rspam-User: 
X-HE-Tag: 1794482842-356129
X-HE-Meta: U2FsdGVkX19Zhuwv39spiqLjGzatbecFR+iZp6X92tFRo77TUNgtOiuDjfw2JlP6LSd9MTTub/3OZzCu8UOB8bZguh2E7LFinKoX08L57JkimvoyNbu9z+GYCQfo2KcsWONByfApk/8MrIKAkz9f2Bb467m6jerjY6nXf0iwf8rlxA5eK2N1OWC2VUEsZarD/iCSHOds0iFuKsR1C82iLatrkSOup+35mc2ePBBVVfQqUx8FRf5RqjoGzG1S5zNgDc55pDxR+vdKfY/l0wTxb+UJDCO3g6ERqMThfGMA0NrXtF6uHOzvKLF1aqZYkW4Ha3/C2+sHfr8Ktv89P/9WADHWyRYDWwdUBxNyh/OlNGWicjfJYdORtyrQbZURPr7GhgprCTuDlGrQY3ySG1UOuqZiraf0AKjexGSdUE+ojkn8j81ayXaHE5J40wVSfbTrHrBU6j6LO9V4vc1522KQMFEwN6a3zhDMsV/TerNRYxWcDOK8Dm3aOCdVdMjegpADKt5D+yg5cSMoHLU8vVHfxsA5XQg3T1m6MHMW4xpjVVkBYHjXFlzAiTfRE9KtRlknTA/FBxj59hLr0z3EyDDrddYrgYq71bB54qCIbM06XtxRtHiFJ30NfEQyIPO9fWgpguSoO/v3pHpZpn1lq218DgDcGrhuXeqN2oGVFmOZpfF2k0KttuioeCw6XYvvC/l7zZpJ881aDPB9v/5ebWyJ9KwOTyskmMIlDV3dP0d/Ia5hrWe/e0c/tv3IBxm0zjVm19xpLgKc5Zc+6eyIZZb/lWKzrd9kVFtlwS1lz/N8TyZ9B9ucvbcdI9ft9VzW0LVb/J3zLR0kS4nXeeyXPGjStnuUPzK01o8z391xT3G6aTZxQI9KjwObfFD+V/gjkPbIE6zn7YfcyQ1Tu94RoWuk+Q6s+vYA95c+P/a5VcoN6y0h4pZnXOrano5G/OwIjsgDD8NaEpO0iomBvD0Ed01
 wNydlF4w
 7ISC1aXDDomGBjRCO4LyvZssOftxF0I12mohcwLWvn8g7QGF7xSdIuuXq58eGrgEyBnIa6JaFOJ+MkqfGrspEc3wESz5CJA/CbkgADolaKg/e1jceOX+8OlTORF687oo6VKbOEkolc9yFgfvWRrSjtuy6Zs0RJTkq/VNoGDq2540hRGyOkxFPRDvmQXvT3vyN0CGUI0fGeunxBYoBnBO9aCbw+sgw6fuaHCYhjDigWqrK/q5Gl0dktBKXUTBjboY5CSaEQUEM7mEfezYbgjpI3jjkN02Ve6wNWqmLrYxed4hIO+nb2x3Z1bjxX0529Zddmg/ocE/iS3gD2qxeiaaVefp7E1ZFn0v7kEwWoa12bT0ddDyfUQmlaSgipm+z7EqE0E7ENf68YnX0XNikZa2r7Hs93Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:16PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> It turns out that filemap_cachestat() can unwittingly return incorrect
> page counts, if large folios are present.
> 
> This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
> kernel if the input range starts more than 64 pages into a folio that is
> split during the call.
> 
> It can also occur due to pages after a large folio being skipped if the
> range starts in its second or later XArray slot and the call reschedules at
> that folio.
> 
> Finally it can be caused by pages being counted twice due to folios in the
> range being split or collapsed during the call.
> 
> filemap_cachestat() walks the page cache under the RCU read lock only,
> and for each entry it counts the pages that lie in the range. It does
> not track how far it has counted, so the counts are only right if the
> walk returns each index once.
> 
> But a large folio can be split during the walk, or small folios can be
> collapsed into a large one, and the next entries then cover indices that
> were already counted.
> 
> Resolve the issue by tracking the current index as one past the last index
> in the folio, and explicitly using xas_set() to set the current position in
> the XArray.
> 
> Additionally, add a check for folio_last_index reaching or exceeding
> last_index and break out of the loop if so.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: updated to use curr_index, fixed comments, updated commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

