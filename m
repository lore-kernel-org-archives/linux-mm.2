Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DE7606A328
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=HWueAitF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=73hMXDMw;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=crw8ZLd1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=WrNmMXSe
Received: by kanga.kvack.org (Postfix)
	id 6EDD96B0BA3; Fri, 23 Oct 2026 13:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E666B0BA4; Fri, 23 Oct 2026 13:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565526B0BA5; Fri, 23 Oct 2026 13:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6E66B0BA3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:09:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B632A1401DE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:09:31 +0000 (UTC)
X-FDA: 85354527342.17.5623B6C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A813180006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:09:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HWueAitF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=73hMXDMw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=crw8ZLd1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WrNmMXSe;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792775369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67SB6LSP3YZL4fyvJpHJjL1fYzDhmkmSaoMKutRzZoQ=;
	b=XVxrTpAK8YFnm9qpoQdDqKCgGJt8xAkJPKiP1OGNA+8P15jboTqDa+aqesY4gUZTak95Jt
	bYViflb7bE9XoKiZwcg31luKKQ2eygS9RA4coYR9ALE/yPX2KWHmutNW1QtBCmrR6gWVIX
	GUAOOwRH4zEicXAKG99JGObAOIpvvtQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HWueAitF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=73hMXDMw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=crw8ZLd1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WrNmMXSe;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792775369;
	b=7fcUT6nhHc4u1uCpliUVe5xj1fugiqMOzjhch+C64001Z5/cD8NsYSPQ+utb708H8nBGZl
	T6t95u6LBvssWzsoEJ9/HFZ2ce7Q0RPfkevjzbSgxVWeY11e2LW3DkulobKuAkjJDzSQRc
	cSrd8YMB8EQj6D5ynPdnalLvI8a2rIw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E866622166;
	Fri, 23 Oct 2026 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792775368; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67SB6LSP3YZL4fyvJpHJjL1fYzDhmkmSaoMKutRzZoQ=;
	b=HWueAitFYISYzSNe5YnyHEb+shlX8K0h7k14BJhPzBH/7EB9lkaz+S2WIPLskS6loSJdvG
	aUR2ufGJE2HCFhRI/neX9GOF9E09SUh5tnsRlHnKP1mp+RBxUigYVFk6x5H30msdd6hprA
	ONLQlbOaGFyv52ucs7VwuxW57NFz6rk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792775368;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67SB6LSP3YZL4fyvJpHJjL1fYzDhmkmSaoMKutRzZoQ=;
	b=73hMXDMwt6yPnVFNBXW0a7ItPpJrVM58oXKVcgDoYb7sxilADmqvuSH+mahIreGVj6Jc9q
	DZxK56TCIadLHUAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792775367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67SB6LSP3YZL4fyvJpHJjL1fYzDhmkmSaoMKutRzZoQ=;
	b=crw8ZLd1JuBzD5b00IiO2YPRlqnKODD6XVDQYYxA0MbIaeiiuNmVOd33K2W5PuP2/KhWA0
	gxHjIOwJ8JSjW5xzj2TcHfbTtyMraZ7Zxxnr53lmvy6LxIdq65njQzO/gIPfcdBlyyHJoD
	o1owhOMYE6Es66BCTMUp+MNFTxzXdHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792775367;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67SB6LSP3YZL4fyvJpHJjL1fYzDhmkmSaoMKutRzZoQ=;
	b=WrNmMXSe/Xxlt29YJzdzeNGaBcxolLMTBpi/xUZp2whYbFL/dMDg3iXMI8VskPLoPLwsIS
	LBorCiVjxe0EWxCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F175C133F3;
	Fri, 23 Oct 2026 17:09:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0J9gI8aU22oYMwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 23 Oct 2026 17:09:26 +0000
Date: Fri, 23 Oct 2026 18:09:16 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: Re: [PATCH] mm/mremap: populate calculated fields in vrm state
 correctly
Message-ID: <atuUijJitqDu00ZS@pedro-suse.tail5790ac.ts.net>
References: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A813180006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t6umk1bda9exuzmtt56xd5np7juig1my
X-HE-Tag: 1792775369-524950
X-HE-Meta: U2FsdGVkX1946hyP2/ik7YN0CBSeoKL2vLbfBfKSIIgR8BCMJljm+Rx23QAeK1IhtQag31Kmc9nOd0gk7ZOtHNIyt7nZCNx+pS9VWYWCmxIPXIoi1Dh9AmI4KV7CyMM0edDBSsdMyoS8uN3obG9xN4aYwQJluWICk0mqECTbaGtdhVVk5eNq+Z6nhSXKthDMT7jAbjjgBE9ggCnc9R5UkHizfG8ul859BSKWyfdlRwMGRYYWqwtyVMxssoCsqSV5ZL+/vIphV8E96hjJvNWrGt4z64jVjvSUVLsQElLLOBJy1yI9fa6cLQAsOhgqbOO/ytCD7V1ilytfozQDnIqyzgtb65TgWI4pBppSenTP+XVGAdlgLI4ieQ5d1jxY22YhO/7XSaNd/fgCb1c09rTUVvNndQXJYrv16ISEegi3TMh+I6a1Vcn2XnMY2bous0qA5QJD/+nb7p/EFpdfoM6hcnvMzrnCoMmPZxqSlZWhvAjxrlCtIJ0KLnv+0YUpfJgz8fiwXbFslHllLshV3ZjuP9XJdVT3JxD+h7bZF8OPV26GGqQzRj5CPF2b1d4/nIux+XuiBMQSjH1dCr3EXpGvRokuUarBmSn/2Q1/qn2/UYIpSgchuMqT0UqfUCNkua7NJpDICpA43fEs1XG7rbtYhPkYl3M7sbzpNsZr1Z6YR/+bTeuBzW2oohP2OqYhov8G1XcwJlC4QYqofbIcB/Yd53tCipcZjLFCzjIiQohUkxGCRwYnd7M8ADBllhbZOlex62Qa3UZqBvPuhWkviTsljVyta6ZxTROqPPVdnPVgzNAKGT8Mjf682tiJ5t+/wy6LN7ZSETfrKP/sFl1GomeTFxGh9wH7rCTWpVFKvbykaABj4q5lbZpy0+LtG0qNIo2hnSX2HSBKZay/D+c23kvBpji/k5d61jnPmPU86f0FdLPbWCsyiA++xEm+bcZGHQhfnR9oFsu0n17uAZ028fL
 QgDGjuvH
 Mt4cf5fea2WX7ucTdku/z+HvrBM3SXw6htPO01m8mktHu6buy61+6e8njgvYQKLUUImNJrLucUX5TNOgjGyoKDuqiLjr6rDBakc/uSVRQ6h4R3o4i/+1WOTtL6lKx1JBKSW0M9B/HCJvN8AteN/sVPKUdYA+ZiohLtfsFbh3S1pWFODe/v5JwGqPqz9TopMeppVxT0a4XR/rX/Sq7DyTlRPRT6iuxP/U1QlCxjrDaw+ugoCb+LkTYCGe6C/S7Txa+PgqyFlXlUW5bBriWr2l/qnpVaJytYVOuLwM/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 03:28:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
> introduced the vma_remap_struct helper to pass state sanely through
> mremap() logic.
> 
> Part of this state is vrm->delta - equal to the absolute difference between
> vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
> respectively).
> 
> This value is used to correctly charge accounted VMAs.
> 
> When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
> having performed the shrink of the VMA first, prior to any potential
> move (e.g. MREMAP_FIXED | MREMAP_MAYMOVE specified).
> 
> However it does not recalculate vrm->delta, which results in incorrectly
> overcharging the VMA.
> 
> The charge leaks to Committed_AS globally, meaning a mischievous user can
> cause allocations to fail across the system in strict overcommit mode.
> 
> Resolve the issue by abstracting the update of vrm->delta to
> vrm_populate_calculated() and invoking this from mremap_to() when
> vrm->old_len is changed.
> 
> Additionally, update vrm->remap_type whose value depends on
> vrm->delta. The field is not read again after the shrink, but it is the
> logically correct thing to do and protects against future changes which
> break this.
> 
> Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
> Cc: stable@vger.kernel.org
> Reported-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Closes: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

As always, thank you for being so responsive in dealing with AI security
reports :))

-- 
Pedro

