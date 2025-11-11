Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC42FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B50E8E0012; Tue, 11 Nov 2025 03:12:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E358E0002; Tue, 11 Nov 2025 03:12:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354338E0012; Tue, 11 Nov 2025 03:12:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 268C18E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:12:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3D7712D23C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:12:35 +0000 (UTC)
X-FDA: 84097609470.11.3591479
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 62565140009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:12:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QSeQCwo5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=snAKhbrQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QSeQCwo5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=snAKhbrQ;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762848753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LkEVwwVdNPznr54vahDaFux3Gygrf9L3jYzCPD/I9qQ=;
	b=pH+nQsh8kxWqcBjaLhTfEo/fyGqO4df1zpdFbdpVa6sstwdkp8YZgp3ASFIM3Iu9+EVsyf
	Yxui0Dk2rcfJBvt8+qCDQhiYgSkuOWJxFrwD6p2XIWDvxkTW+4fGx4xjLB+/FgO/sHbEdV
	2zgHw6AuFOxhOSPgmgC9YC3UuJ9dhUw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QSeQCwo5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=snAKhbrQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QSeQCwo5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=snAKhbrQ;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762848753; a=rsa-sha256;
	cv=none;
	b=AscNO34QxEUa+eQQlSll8emTcKxo3P/+WomKTRKlLQb4soXJrt60jVzL9Mr+eOLY78PXFL
	OYqpedmZC9ZzgTucvwSPmTPTDxnK4+d2RLoO9Pv3ocEpJccUPXe0K5XukDMBO42R1g/CSm
	9oheySw+YWjthvh5sJgPYpqz3aCly7c=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 692BD1F456;
	Tue, 11 Nov 2025 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762848751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LkEVwwVdNPznr54vahDaFux3Gygrf9L3jYzCPD/I9qQ=;
	b=QSeQCwo5M54KhAE4J05hu391Htp7HY4Bdk7GVXnd/Ujz8Sb79fOOWsgwrpSYjnchc1lZo4
	QhESx/55W77dQ3UXmgmv+8tVSSM5EMtBM2WkFWxmejHtPxBO87Kdb+VZi5TZEE7cYWVPLc
	yYDiWLM5FTsgp9+2Bv06bDFKC03574c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762848751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LkEVwwVdNPznr54vahDaFux3Gygrf9L3jYzCPD/I9qQ=;
	b=snAKhbrQ6eVKcyi3GeEbDy8IfNz6t7anBidR0KznKeGLQ5p8Cz52iYod75ny2v5oxnbnhw
	qdmNQnPmaJgzJzDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762848751; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LkEVwwVdNPznr54vahDaFux3Gygrf9L3jYzCPD/I9qQ=;
	b=QSeQCwo5M54KhAE4J05hu391Htp7HY4Bdk7GVXnd/Ujz8Sb79fOOWsgwrpSYjnchc1lZo4
	QhESx/55W77dQ3UXmgmv+8tVSSM5EMtBM2WkFWxmejHtPxBO87Kdb+VZi5TZEE7cYWVPLc
	yYDiWLM5FTsgp9+2Bv06bDFKC03574c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762848751;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LkEVwwVdNPznr54vahDaFux3Gygrf9L3jYzCPD/I9qQ=;
	b=snAKhbrQ6eVKcyi3GeEbDy8IfNz6t7anBidR0KznKeGLQ5p8Cz52iYod75ny2v5oxnbnhw
	qdmNQnPmaJgzJzDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4361D1485F;
	Tue, 11 Nov 2025 08:12:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CcAaEO/vEmkWIgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 11 Nov 2025 08:12:31 +0000
Message-ID: <8584cfa8-1da3-46c6-8f5d-7ab49c341e19@suse.cz>
Date: Tue, 11 Nov 2025 09:12:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/madvise: allow guard page install/remove under
 VMA lock
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
 <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <cca1edbd99cd1386ad20556d08ebdb356c45ef91.1762795245.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 62565140009
X-Stat-Signature: d96ncs6sddbcgk7iqkkpu163sye9msye
X-Rspam-User: 
X-HE-Tag: 1762848753-704951
X-HE-Meta: U2FsdGVkX1+R6zuIPKs1syb+qldDBrbIAOreDYmUCB5PL5qxmAVJ7QAF+iPvRgRgIyu114TqJ+r6iLqAOynADhYMTef1L4JfZEtoYZVjqRsyLFSg8cDp9D2g/cBH5JypEan+qaoGY/U5xYjki3jxnlKjn0j4cSOzwT8MVg2eiRF01RK8t3HmEaWuV2bKnvZFIBi8pNGl2Iy3X/3mmC5Q69TqEACgK72Fe/x7c/5RM69e1v1zbNsXTgLIDkRgQrOF8QogSw/g5KmzN1POkn3ZY8pG3+IWriz0RCTwe9vHzvjg4nROR4INJ/TjG1yD4YDOSvK6ZP+rgGKjH3NO/w7GPl+ajClc7cdTMBdhDqMDvbiCw4ciJOVJVDlU0RuEgG6JzGo87PgPEa8DdL5MKSpUMCS9vUerwKNTxccDDkUVhTauLAyXExarYLpWim2P7ZgreghTmN5ks6femVP3h/OyFKYwgZeGWifMKX13J8mYTh+YvHo10FtSMnpAuZs9+zXJZsUsjQfMEs/ke7pm4oEGmcIt+xWF0Cr2unpy9bJ0d/GfGd5qF6Dflhrgb8izAAMetia/2UExP7W54xi9jvslSgZsrvxE8r8PJN89MZLu2YvKw5BdRsRrnn2ImP2ZnBnQHxWLmMbvsoVV/9PNUK80LyNlDxb6ysvLk5v354peMpBSCvHCN4rBzrYfwGzUhF95EwvBlfZq2fs8ag63X4RGWx7XiYjy/kp6kzaoZmsLmIb3TFilUrnRMylFUqGY9f3TToZLvHjbzi4sr/ryguwedChdOcPHKJsZmJAvKqJkXH93gBzWptvVD7/UlPZiGqdl31ahd8x9+8R3uORRDep4B6Gq/Y/inKPnXSGLqGpNcj2fh0Qtn/r9/6SeRpyIMtG1GeOcOecyyecKDf3y5U2YoEKatuXilIrFB9IZeF+EkR/Y5pAe2lTFAM3Ni+ZkQDqQw2wGdoGfDju4jh5l/6S
 ZmKwRKnH
 4yNcs2H6vl23Y8crt5TfTjvg2x49kQNIAAVgXavikqofr/cNvHYJRTTV731Fh0kGObgTGti1oMynFIHgpqqJ0N8al4rxAwN8WrnOpQkD9Fzgqn+/yR3K7Pec/ZCsnEJoY6Yd6ErpYOTyT1qD4+nxulyAKBl5gaxgfV6cquJRS3GHJIytNAQUX60NAspHn7StKCSygfly/4hsqu07TkdcV4NFDJyzVw1C8ch6j3u+95Hai18bZPfjzudNWDkTrI8jgNaYEA32DXGjs5IuXf60cu837QdNPQskxLF9+aYsWGT0vKvepnBFiU5oL2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 18:22, Lorenzo Stoakes wrote:
> We only need to keep the page table stable so we can perform this operation
> under the VMA lock. PTE installation is stabilised via the PTE lock.
> 
> One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
> lock. We can account for this by adapting the VMA locking logic to
> explicitly check for this case and prevent a VMA lock from being acquired
> should it be the case.
> 
> This check is safe, as while we might be raced on anon_vma installation,
> this would simply make the check conservative, there's no way for us to see
> an anon_vma and then for it to be cleared, as doing so requires the
> mmap/VMA write lock.
> 
> We abstract the VMA lock validity logic to is_vma_lock_sufficient() for
> this purpose, and add prepares_anon_vma() to abstract the anon_vma logic.
> 
> In order to do this we need to have a way of installing page tables
> explicitly for an identified VMA, so we export walk_page_range_vma() in an
> unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
> read lock be taken.
> 
> We additionally update the comments in madvise_guard_install() to more
> accurately reflect the cases in which the logic may be reattempted,
> specifically THP huge pages being present.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


