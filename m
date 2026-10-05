Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D7DCA5FFD
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4DC6B0092; Mon,  5 Oct 2026 02:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65A86B0093; Mon,  5 Oct 2026 02:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53F86B0095; Mon,  5 Oct 2026 02:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB276B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:09:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2C1E40134
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:09:48 +0000 (UTC)
X-FDA: 85287546456.11.2088C62
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F54B140005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:09:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ry9geKI6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="//qhazbQ";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SJbVbon5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=B8Z8v9rg;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791180586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/ejuC82x28bAndFLSItnOGKHqAeicBTwXUq8uK5v1Q=;
	b=plcXgceYH93jTeIzPb7vN5+JvKto0oIshm/tWts6RbejRafl2SjU2LMkFzRLDfn6bKKRQ8
	4BQUVW/MaEW+e0AWBukkXSUP5BVbmHO7HNZwypPyXwyQysCiwOI54Qgp70m+q1xASsPRIx
	gDDccBhyX1fhN+oermWwvPs//TCn0ic=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ry9geKI6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="//qhazbQ";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SJbVbon5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=B8Z8v9rg;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791180586;
	b=hgoGIgDVFoYwsig3KUkb+Vh38hJ6JUKmRxUuD4XbHV5K17nXnfX2WzYvjsHyZ6KeU0ksHx
	Y13HN8GssJzMoXn0KtrkyoFisV1XvUZH0TsLCrFHh0JNHNy+1ceHyhrSsIXoYFvZq4hTKQ
	35suab8ndK6cQVoRcDdy6H9EmcEExII=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA62A21E86;
	Mon,  5 Oct 2026 06:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791180580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/ejuC82x28bAndFLSItnOGKHqAeicBTwXUq8uK5v1Q=;
	b=ry9geKI6pF6M9QVELgUcIpqEQ1VAuj2yrQmleMftMLPZATU/dwl0qyKb7B8r0bOjnkqvf0
	L8x5kSRDo/CjphWS/wnmUarWkywSKnrJINMOaPu2WnmR3/WQwPc8AbGNytuZ0OIM2t5RfQ
	+0jLOqGdTDbZwjaTtXKifrQXReOReE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791180580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/ejuC82x28bAndFLSItnOGKHqAeicBTwXUq8uK5v1Q=;
	b=//qhazbQCMNmF5Go41k/pRzufO5Rjb3yi/U7HM5ED0wRsmGLuKk9aF6Ll8GiIpM2Nil3Km
	DVonZWNtJdEiSqCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791180576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/ejuC82x28bAndFLSItnOGKHqAeicBTwXUq8uK5v1Q=;
	b=SJbVbon5JV5mnQRgQ0jGovGLeXzEt4BOwiYjz6efFIVmmOQkAr0PEjfUM/7P0ASQNPcgfD
	9GBwCkzf84o8MK42Ov2jVfGvsI/LBoB9onMzzRqsp7PQVNCPlC1W/bTb7O+rQEcrba+DED
	NtdXomhXQ7CZLLvurEp0yRa8A6JgdEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791180576;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/ejuC82x28bAndFLSItnOGKHqAeicBTwXUq8uK5v1Q=;
	b=B8Z8v9rgicrwKF/cCc2/ox4K/Z+vy5h9dn8QcYR2drEnQhtfKAe5ccHZQeLXeVWBocQRFw
	SnTv6tpReDGIOpDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43831132D3;
	Mon,  5 Oct 2026 06:09:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z2cGASA/w2oBDwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 05 Oct 2026 06:09:36 +0000
Date: Mon, 5 Oct 2026 08:09:30 +0200
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	riel@surriel.com, linux-kernel@vger.kernel.org, qi.zheng@linux.dev, 
	nadav.amit@gmail.com, thomas.lendacky@amd.com, kernel-team@meta.com, 
	linux-mm@kvack.org, akpm@linux-foundation.org, brendan.jackman@linux.dev, 
	jannh@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com, 
	Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org, toshi.kani@hpe.com, 
	david@kernel.org, mikhail.v.gavrilov@gmail.com
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Message-ID: <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
References: <20261005052302.43042-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005052302.43042-1-lance.yang@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F54B140005
X-Rspam-User: 
X-Stat-Signature: uiz8eonumwu8ztis3scz6i8p1za69e91
X-HE-Tag: 1791180586-877291
X-HE-Meta: U2FsdGVkX19dbyccbBLJtRpMiaYSxBclHWrvHBTaC0tZ1a5a4x1M0OX+/TgpW6T0mObF9E00h+xa/5jwIs31nsLu4enoUTAT12netpoT4PXbswnMfP+9RD1RmuefwZ6qnbmAQ5/Bg3wZ9v4GgiynB65wFJUjqBv9Z/rpyJRKPA9WW8TVfx/1SpVBHJHFRWOc4Y1HQ8oOd8M4vDVGcnhfGpTIW1vrSLj2diDb2DtBxp9m9xYb4LEr68p1VJEoQeM47xdeHpqsSmiVwJ4+Yg5ZTG92anLExBYNHz2PxGgK53FToym1l4osSWlg0fwSYQE4LRQS+kRtVlsvEwiuN6lk4Mg7YM5MwwAXD5oEL6izT7ZtY+HRgMihG5MUqWnEHE5dzy0peLKAhWmZL57iV3ZHIKyQvsDrnBTP5/lnORcASR7UhhvYMoDbC9EYbUvG52Io42KaqXkQqed+Ru6hhdi/e9aj4CkERoWCW5VTJcnABK4djl7ah7th0rRRBDHqsWW//UMVOsjqft+562AGG+gR5HYX9hEJrImIuf8iuKPmc+PsIZbTyekip1AdImzuD3KGvrQBhgketU1957EnjpSZFGnkE0r0VbWaLR+IXJh8khoXAr7CUeNhKpH7cPgowjQoco/b6dtfxX4rAnWqJRZTHxN/SZyeyD4P1wFADI1wiAg0xTaelrCFSKYUjlpWeULxeG4/fn43uEHzPmnk9oHJcIXWNmedjttwquEZ5S+eeu6is3z3Vf+f3XFrp3CFzSVBO9ZKUTZDPEOFTLxNjdVSsbGrkvhReV7wBKGmM0JgZ4jVXDjl0Peg3qEXyw92CVD0BC3WSkP9D+t06Ar7kg/fE9Tw7KRGMqUG2bXLYN4ffnJ8yYQvRCfksvNPDwUyqhYZZ7gHv7XajS+TMFgRdCQU06+xvpprZ7joG2R6f1kzB4bFTYxOiFKuZMOVKVetZvXJpdzTs3IiICkh7p+h2th
 glJx2mhK
 ExywvLmwjEKlTJCRqjnND+mpL9kBApRn+Qd5OmgFzP1CLDy1JXCC/m9VUY+HBLvxSb/MZ0JnqvVmD0MJr3bNxkuIUi4t9B6PFUWISQ310riskistKOvJPKuIoswfgsl9e85URsf2R7oXNeC/xsm+eAvF9tecAY7ptSZdrKqkKqMtl6r44BixwLfry01aQAMpMld7bzu61k0H2uUJDdNH9b/7YHZLhLgvvwqSWO8xqSBN5UTSopA+NPBAU1YhqptNSpcDSIxHkNYkprWtgRqXIV2L8PRZMD+/dlBuZqdTfTbnqKrPGyAklL4sWxmk5g/IIkJpeMudnzXokYHxm/e/IOdaBEHRDprqvJZNAntCjE+0awaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 01:23:02PM +0800, Lance Yang wrote:
> pud_free_pmd_page() uses a single-address invalidation to flush the
> paging-structure caches before freeing the page tables. With AMD TCE
> enabled, this only invalidates upper-level entries associated with the
> target address. Cached PMD entries for other addresses in the PUD range can
> still reference the PTE pages being freed.
> 
> The AMD manual quoted in the commit enabling TCE says these instructions
> remove
> 
>   "only those upper-level entries that lead to the target PTE in the page
>   table hierarchy, leaving unrelated upper-level entries intact."
> 
> Even with all PTEs cleared, speculative page walks can cache present PMD
> entries after the earlier TLB purge.
> 
> Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
> the single-address invalidation otherwise.
> 
> Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

I'm not sure this is correct. The PUD is clear. We invalidate the TLB, which
invalidates the translation caches for that walk. invlpg will notice the PUD
isn't present. I don't see a case where it can ever not clear the rest
of the translation caches for all leaves. And, in fact, by that point the CPU
can (does?) probably formally treat the PUD as the leaf.

Did you repro any bug related to this? The functionality is perhaps
underspecified in the AMD manual.

-- 
Pedro

