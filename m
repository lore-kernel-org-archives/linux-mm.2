Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBBD10BA45E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3746B00AD; Fri, 27 Mar 2026 05:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AC26B00AE; Fri, 27 Mar 2026 05:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391076B00AF; Fri, 27 Mar 2026 05:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29DB16B00AD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:19:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA1D91A0F6F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:19:08 +0000 (UTC)
X-FDA: 84591293976.18.01AE20E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7EFD0C0009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:19:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y1LLfb6f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sxIChQwp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y1LLfb6f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sxIChQwp;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603146; a=rsa-sha256;
	cv=none;
	b=aWYkhAy6+yGC7yxYQ1taYJSzOU9FMwgTXABDU72fkVRXSj04dWvuMI5hOXMER82fZVnabY
	obVSFLXuCWCY1/pt6DxmseZuS9CfuS0nlfgR599/p+n2f5WG7hOYbbZqc2pHDqIvCveU4I
	XGfQCaHi4UZUpzChcBXN+BbRoezkQ/c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y1LLfb6f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sxIChQwp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Y1LLfb6f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sxIChQwp;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyDqTqiQQjs+Kv98x3ahOOCkSIyenOg1lTzeqwlIC9w=;
	b=uB2sbnXons8ABuXfmXtvtIZNDwG3337TxV8bSLaUYp7Y7OVj1WRk2a/Tip6ja/7ibS7V9P
	xfqwLBnSxIIleucHzRV88rI+QGPhVbMiEOOz6Xpa4/JotZ+XYYGnoqWahHyMwhfIeN3NKH
	q57oHAcn/XjPJFi2LtwfiH3IoLeJx+U=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D09AC5BCD1;
	Fri, 27 Mar 2026 09:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IyDqTqiQQjs+Kv98x3ahOOCkSIyenOg1lTzeqwlIC9w=;
	b=Y1LLfb6feuBJ+Koo1WOGcWA7j63HEInJ6OEOeAwJPG83EeD8YAdsezJJYtAOTLSg3lPn4W
	/dGvgHnrlS3KugcBhf3jMB+SPVAQwX/+PXT9ONW8nfRgrdLNBpRrrQuIZ60uN3AKWn0Ee/
	vfkV0wZvZeVk+J6zw4vPgWZtnRrCn1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IyDqTqiQQjs+Kv98x3ahOOCkSIyenOg1lTzeqwlIC9w=;
	b=sxIChQwpUZqRucdywaYxqyug1LyhUqhnSE9jn9hgX2VUnSTYY1fROujwsaHIGBA8lqpKJj
	FAddXhuHKnsWcXBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IyDqTqiQQjs+Kv98x3ahOOCkSIyenOg1lTzeqwlIC9w=;
	b=Y1LLfb6feuBJ+Koo1WOGcWA7j63HEInJ6OEOeAwJPG83EeD8YAdsezJJYtAOTLSg3lPn4W
	/dGvgHnrlS3KugcBhf3jMB+SPVAQwX/+PXT9ONW8nfRgrdLNBpRrrQuIZ60uN3AKWn0Ee/
	vfkV0wZvZeVk+J6zw4vPgWZtnRrCn1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IyDqTqiQQjs+Kv98x3ahOOCkSIyenOg1lTzeqwlIC9w=;
	b=sxIChQwpUZqRucdywaYxqyug1LyhUqhnSE9jn9hgX2VUnSTYY1fROujwsaHIGBA8lqpKJj
	FAddXhuHKnsWcXBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09F2C4A0A2;
	Fri, 27 Mar 2026 09:19:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g0ypOodLxmk/FQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Mar 2026 09:19:03 +0000
Date: Fri, 27 Mar 2026 09:19:02 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jianzhou Zhao <luckd0g@163.com>, 
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 1/3] mm/mremap: correct invalid map count check
Message-ID: <gigiefu6cc6qz3gjghzb67lhlay67ljn2g27mmricgwbmg33j6@li2nqvunflpl>
References: <cover.1773249037.git.ljs@kernel.org>
 <73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 7EFD0C0009
X-Stat-Signature: 6aire9rz38jthhc7q6cm8d91uf9ebunh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774603146-644658
X-HE-Meta: U2FsdGVkX1/uYs3P7UwOQXJDW9KVVsS1pzRRjOL3ZzrMerSoYfr/XVvYrm580vaYe+6PHEsPOI0cD5ZwKBRijVNfDnC1GY094uHvmdOJea3zVrBGnp7oTZ+k1XoI3rMbm+qGo8yNB809st9iG7ObufHkBo1E+I99JYSBM33kokFADA3wz+Z7WoR56PalqX1KC+mgcVANetO7NqLiLW9zIq+aWo2yIebxJqRSCyUxUnTw/JJdrzOS3m5gxtO3A/L6zoHTdc2PNrem+e1bXJJ+U/knsdxfuHgH/csX3oUDql7pO5/V4H3h/4SkSNFOlUhIHE1ni1XhqjZXQ4Dvft/foUoorxGpxcrjqUYNoGCsSk5Bf5kacfgVj2OzIRu/3sN/+Qkr1fPVK5jYLuJ5oDOFl/9am6mRUhZrfeZocqbI5aSUI9jFs2G5y5NizULH3z34UwqgU0Pzx8xHEQbYOtylLg5vP391XLfJoY9PYMkC8DMTfhmS6quYZQXuW0zgjLS88bD6LjbI95Qtf+o3smeUm22H4W8jiHlI32+Jgbgft2u+b1eF0+Fj21qUTBeBFxsuNLJA29VWlAqmBD/Z9Jt/K939UcE3R392U2e0HbeYAuxqjFWTWvWlN0+P57UXqoCTmXOkseYK5Kmhc0GyncTiC1r75Bd/JUOYHC6nctO6JKSIp1RdNdXbHdyOud7ZqMmHK/iAWwakaItbQMMH9WZBDIm/EmlVMy4jrRbnSVLs4kOWAb/JIjjTs/H1NMP98AtB9s4eXUKdLobwEZLuwgrcG+f91IzCxEhSaiOZXvYttcMSfwnxT89USaGOigPTuQIa8kx4McppxdWrM39kHpD7tVk+IM3DKl8bzBQ1Y1SyfFNphTmOUvjja+apXcRdPJNK1ovwbhLThmwP6CrpGvPSDlOPK3A1q6rNjaybfwZDuCkKNwotBSmofdWhZJ9IaWclgNfRZNkZzn8eWX0YqJw
 NDEFcWaj
 9p6KHoDFLvcjegoX3EMvjBQIhAoXuZwD3UWAhUUZs+fLjm9rgGEZ0WPpmbdbY63RxeeMOzOx0x62Bp58Bao1VwL/sHM3ytN5eaG4J55XOF9heLEHpsR+qF2wGvN0WFooYqV3y2ya7fFciNPzz5NN3V+RbvufY8pkVEDpEDCpaZqCbSTXY5QLQRiRxeBe1u+WOk6fky6cabPu2AbjPCC/TIzBirEqW+zDi+CP+P6t5BaeDK0L4IIm2Q5KCpDcJ8E1s9Y/8DtMm7iB91HZJEzWjlNcpqylkhPfuiu1h48cIIkaqdRO6TvxWHHSTJhpjhZsYzEdjdGkQCJG4g2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:24:36PM +0000, Lorenzo Stoakes (Oracle) wrote:
> We currently check to see, if on moving a VMA when doing mremap(), if it
> might violate the sys.vm.max_map_count limit.
> 
> This was introduced in the mists of time prior to 2.6.12.
> 
> At this point in time, as now, the move_vma() operation would copy the
> VMA (+1 mapping if not merged), then potentially split the source VMA upon
> unmap.
> 
> Prior to commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
> temporarily exceeded in munmap()"), a VMA split would check whether
> mm->map_count >= sysctl_max_map_count prior to a split before it ran.
> 
> On unmap of the source VMA, if we are moving a partial VMA, we might split
> the VMA twice.
> 
> This would mean, on invocation of split_vma() (as was), we'd check whether
> mm->map_count >= sysctl_max_map_count with a map count elevated by one,
> then again with a map count elevated by two, ending up with a map count
> elevated by three.
> 
> At this point we'd reduce the map count on unmap.
> 
> At the start of move_vma(), there was a check that has remained throughout
> mremap()'s history of mm->map_count >= sysctl_max_map_count - 3 (which
> implies mm->mmap_count + 4 > sysctl_max_map_count - that is, we must have
> headroom for 4 additional mappings).
> 
> After mm->map_count is elevated by 3, it is decremented by one once the
> unmap completes. The mmap write lock is held, so nothing else will observe
> mm->map_count > sysctl_max_map_count.
> 
> It appears this check was always incorrect - it should have either be one
> of 'mm->map_count > sysctl_max_map_count - 3' or 'mm->map_count >=
> sysctl_max_map_count - 2'.
> 
> After commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
> temporarily exceeded in munmap()"), the map count check on split is
> eliminated in the newly introduced __split_vma(), which the unmap path
> uses, and has that path check whether mm->map_count >=
> sysctl_max_map_count.
> 
> This is valid since, net, an unmap can only cause an increase in map count
> of 1 (split both sides, unmap middle).
> 
> Since we only copy a VMA and (if MREMAP_DONTUNMAP is not set) unmap
> afterwards, the maximum number of additional mappings that will actually be
> subject to any check will be 2.
> 
> Therefore, update the check to assert this corrected value. Additionally,
> update the check introduced by commit ea2c3f6f5545 ("mm,mremap: bail out
> earlier in mremap_to under map pressure") to account for this.
> 
> While we're here, clean up the comment prior to that.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

