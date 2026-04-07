Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F44BFEEF4A
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CF36B008A; Tue,  7 Apr 2026 10:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603E56B008C; Tue,  7 Apr 2026 10:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541426B0092; Tue,  7 Apr 2026 10:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 463DD6B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:01:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09E85C28B0
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:01:39 +0000 (UTC)
X-FDA: 84631922718.11.19977CE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0792140009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:01:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tFqVVOxr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PgiGJC1H;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zRrfbvXH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/3zVSRaZ";
	dmarc=temperror reason="query timed out" header.from=suse.de (policy=temperror);
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B20974E48D;
	Tue,  7 Apr 2026 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775570480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zphuR49ZgxD27f4MeQaLTuj00hwvlLjv/AVtSqgU2j4=;
	b=tFqVVOxrilz4dSZwqfS3MU5fUGLsxZciJHpep5v5nkhBRqkkpTb/Anu9OS44icVS/Y+jau
	nwKv/oT7pnwmRHGlw9ahZ28zVTyBWGM+Vdb3dCKoaJxItQJFAseSxd3PtiYMDBytiFRx6j
	oMm6HwgtNAOdTujI5c7uCTyc0HZ8GeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775570480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zphuR49ZgxD27f4MeQaLTuj00hwvlLjv/AVtSqgU2j4=;
	b=PgiGJC1HSkGUfqgVrhAtKOMu1J0Bs0VH08W2HvRf1HVbDOebl4ZbEzYVsuGvvs0ih7nh75
	vr/Kg47QgMLEynDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775570475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zphuR49ZgxD27f4MeQaLTuj00hwvlLjv/AVtSqgU2j4=;
	b=zRrfbvXHs4+kvXL80+ocphL/gaRd8NwayIPvqrEcZdI+kmPif1Tu2u9C/yIknLG0bSGGjA
	R80dGt7fC04CEdw5wVP7TWOVIwerPOrUrkpEgHNi+V0Lr0y1LEtVtR3y/gFm67fDJ51OUR
	KSZGyfBqhVD3tOCXYgiJzs3YwWJypmM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775570475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zphuR49ZgxD27f4MeQaLTuj00hwvlLjv/AVtSqgU2j4=;
	b=/3zVSRaZkbTKNQT445h4Oo7TWPRyQSCkSnY6NI0IbQA53eTrepiZszzVwf/dut/SQWjqxV
	HtS5KNPpYuHySdAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBDF74A0B0;
	Tue,  7 Apr 2026 14:01:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zz1VNioO1WmncwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 07 Apr 2026 14:01:14 +0000
Date: Tue, 7 Apr 2026 15:01:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-ID: <nl7yfkp2d5lburcweyyg76izfjbpr3hllu3ttbuggbja433aky@hn5uyub23755>
References: <20260402141628.3367596-1-pfalcato@suse.de>
 <20260402141628.3367596-3-pfalcato@suse.de>
 <e4f0923a-f2c4-497b-895b-4e83a09b2f04@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4f0923a-f2c4-497b-895b-4e83a09b2f04@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0792140009
X-Stat-Signature: fsfhocuuac6fpgaf9i4uxutkmcxyiybp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775570482-796497
X-HE-Meta: U2FsdGVkX1+g0QymRmg/LiHwZ61Ie/OOPLH4jQHBc33dJlxCuUydj+U4Ccqegad14QRHleXLs4qt1xdEhAIF58IpyyM5a5EeYpZZhDGxi+eajsjQUsX5kI0ErSNhqBVdcTCwDu6yIEzPlPeKB8ya21EXNo3J4BnLFVY+iWDR1kNgx+5EaM3tajMQjk7NzGC1TPQGiV4AL2Xs67oTl/WLq6KHYe9Pz6nlEhQJWBgxfrAxKvO32rvfAx4H0sriTXPKS1eUXzyLurKzdMRW4pu1vWymrut5jc5LuPLWHBGoMW6s2wAVSInZEg+mIJ80Wrc0Xb3aveAG9+zJCxWEW7IwinFC/GMzAfWWtELoLPtQjiQwiWR6f7MZEN2hitgPPe3fBluc4mhUTskQlgMVVxVXfbRQ46fN6FCCOtj5t5dSYV6vt/10KkqUyOio/E4szawEz1x467LXVwGQv/ABqknuVo+/zhLHOMXjTmstBi8KDVz6/P/bshrv2kylj5UhnS8xdjT0/hpUYtepKCe33u9eBnPpl8GBF1alTVXfpnpPf9gjhwUPwp9a+a05ILwoJMbuw5HRcokMo/q5ypbWbhQ6o4tv6BM6yObZF0GU8C78hVncOEc7mnWkf0WWCnOG6uA9tl75pAO1TGsuRAInyDqwP9jm492xGu81jby4C9Ei+JVYPiBE7jJr/xvX7AU/wJPyuEVRk03KnFroUgjp2bYl4YL33iUdPy6eI7gk5ZUuCmaU5nN03aXwAh7lJ0fGfhpDoeo92KJBdc3naymRK5g7I+YDFZwbOcU1MFtFGzvNeOQicIPdwCmpPHDxSdEyfoMqbLSp8UJXmdDgDsM9f/X8340OMKFRc4C0ujgRlACDGKJdDO63IJ+OAUxb0CGxCKVZWJ1g2YuThC+VD/uTAUB1JzJoHgBoCcgZNugj0pBoOSs84S1o4oWurSarCDBt54mnF1LtGVedpCmqs9NXdwY
 UcYBvG4m
 czBa8s8bPN1TYINBHSapZwVPfJo1zpru2C1KA7MwRgproKiKj5Bx5OPzLuo3f8ksH2E2Bf1g4voD3z0UI9UIgI1mGE2wYy/KWncIQfWOSMGHB0DV4HECcB+Lb9Nxk8i+d0khukuVFvdPvnEef6qu7rHLmfynqpw7oeq96dXV9F5IWJzyj91H5fW//MSojdjJNJk1y7XJ6uSnL0vJCJ6cFnqbXsAacRiXfmPkIb6EhB5M68viOmE7PfPtY7mj8CJvdpjQS/jTw9fe7XKf1GlpwWu6osd+iUJW3C0+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:31:29PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/2/26 16:16, Pedro Falcato wrote:
> > The common order-0 case is important enough to want its own branch, and
> > avoids the hairy, large loop logic that the CPU does not seem to handle
> > particularly well.
> > 
> > While at it, encourage the compiler to inline batch PTE logic and resolve
> > constant branches by adding __always_inline strategically.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > Tested-by: Luke Yang <luyang@redhat.com>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Can't say I'm thrilled about these hacks, but seems to work, so
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> 
> > +			if (likely(nr_ptes == 1)) {
> > +				change_present_ptes(tlb, vma, addr, pte, 1,
> > +					end, newprot, folio, page, cp_flags);
> > +			} else {
> > +				change_present_ptes(tlb, vma, addr, pte,
> > +					nr_ptes, end, newprot, folio, page,
> > +					cp_flags);
> > +			}
> 
> I wonder if there's anything about this trick that ensures the compilers
> will not eventually stop compiling it the way you intend. Have you talked to
> compiler people? :)

These kinds of tricks are pretty ingrained across kernel code, e.g:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/include/asm/cmpxchg.h#n65

and similar. In these cases if it fails to do constant propagation you'll
get an actual build error. In our case you just get a regression back :)

-- 
Pedro

