Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5CD606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kzXwZUgx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sYZQ50X/;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tCXN4/UT;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=axaS3z55
Received: by kanga.kvack.org (Postfix)
	id 709966B05B8; Mon, 26 Oct 2026 09:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0B76B05B9; Mon, 26 Oct 2026 09:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F60B6B05BA; Mon, 26 Oct 2026 09:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8C86B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:07:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C15E31C3FF1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:07:21 +0000 (UTC)
X-FDA: 85364803482.30.EB4C684
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6AB1B20009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:07:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kzXwZUgx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="sYZQ50X/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tCXN4/UT";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=axaS3z55;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793020039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4aTtckkNIZTj3KdHwLDdVPDSaAWMqxSQJcGzbmfPd8=;
	b=ONwRmYSXFtzU1rLkSNjtGJbETI6cv0qrkClr16iVSWK6/irgLplgRYXEdBsXmIxuh0yGsJ
	LVTOY7Qn67EJmJzxyXgCWj/W/m6LERS2sx9Y7B6yRzaaIappju8FtVjQ2eya3dFXeSVD5+
	uA+PZOBBKNN0HtL8A1jVadoNAKMIJ6Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kzXwZUgx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="sYZQ50X/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="tCXN4/UT";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=axaS3z55;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793020039;
	b=8LmtzULqsOSL9Xrf18teIZYWV5YEnayhm1cbfCnmaR9Bs2BAqMoIDM5cgnk7jThPtqDcAR
	BRZHr5BWZT2fkp/QfkKsG2IvMI7ld/pr7X360Jt4SAtpoxzaVGNB06p2Eni9BzdvN6SJCR
	L2foNNubkWPPkhmPdl0eirtRxijjMlI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B8A621E84;
	Mon, 26 Oct 2026 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793020038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4aTtckkNIZTj3KdHwLDdVPDSaAWMqxSQJcGzbmfPd8=;
	b=kzXwZUgxjb3dLMkfPC4/6iPI5q3nlBiWjKcS+LICVn1f7NgrpyijK9kPMkQXmpEQNDgKs0
	5wRC3t70dv3tfM4m9rjrGyi3sWZHHdagCD65ztwyGgV4bPaAnTCemVzDvw/Cml1vHSdZ6L
	9w6zrs9dgniLswGBLc6zRCnVi6YE6mE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793020038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4aTtckkNIZTj3KdHwLDdVPDSaAWMqxSQJcGzbmfPd8=;
	b=sYZQ50X/hGcQnVBiApUx0JvHUaM1W8X7Q9/5/pqzMS0x6EMYYvXIdE98tb4CW8gwaS1dAM
	UrxsYNdfYBQqAWBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793020037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4aTtckkNIZTj3KdHwLDdVPDSaAWMqxSQJcGzbmfPd8=;
	b=tCXN4/UTrJkFRabug2fy7KFrUD8//yjdscptoZ2fnQL1W6IvqOP6GOi4p6C1Ow/a0llnl0
	qKyeiaQiX3zQaqck1GpvjD/4jaCL/ov3M88TtbQtB2KL4aXUxggySnv2p+RDFBmUPjHctf
	VcYapD8oNUn0plwwEc92uZQGyo/mgqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793020037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p4aTtckkNIZTj3KdHwLDdVPDSaAWMqxSQJcGzbmfPd8=;
	b=axaS3z55G30XACXvwbOHlXmOTQjSeNrlUlKDROuoWn555U5+DlXxrsO8NgblQq/nIYYLA9
	wnP5qY1NcQLSPOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09E6213408;
	Mon, 26 Oct 2026 13:07:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vpa6MoNQ32rGXwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:07:15 +0000
Date: Mon, 26 Oct 2026 13:07:14 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
	Colin Cross <ccross@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/vma: avoid losing atomic VMA flags when setting
 sticky VMA flags
Message-ID: <at9QWd9wst333TWx@pedro-suse.tail5790ac.ts.net>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <20261023-fix-vma-atomic-v1-4-8ff4fae1fc85@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-fix-vma-atomic-v1-4-8ff4fae1fc85@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AB1B20009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gto3b7ie94nqeuowkrjkq89nfetf9h7d
X-HE-Tag: 1793020040-490090
X-HE-Meta: U2FsdGVkX1/Ak3EqkJv5tqgE23/NRzyNo/agUmOQ86xn3hhppblGZ1D50CsCLHfXs2WXEOx4F3lRwYHemngbKWHWWGA/EJkQfgVei0QFaScAv0pNT9HmWhEFGqINv1X1FgBGb04igaxUZ3po5ihe1qgoyOt/liNdKNJ81pVcg4CPC/KkfgN9grkvbimHG5qapBLS030AYD3uGwJWAVLsfngqy6L8wJXH1yWNhB+Py2hFlP2+BRMMM1pyYgN0M6HGN4I4eDGhEgSf6GimvrUQRMRydacFoY1RQsOr+EpLrQ6RNpElk6LVVuGM/zh2PdLGuqLA7pik2ODY+waNC8v77fMevytB36BhdTEHrC8YBoL5yE88zMGTZymUY70cqSaLfSdYCUw0raHDepd6zOAdyp2kKMYTV02weebOiwBQZ/L5gsponQ4tBKzX4sObX0+15XWWbNG+UbzVXXzUPcHbda3mcXq9T55+wsJzxBMU5fY5I8tAtZSylaBSaICAN/ydbDYTuWHFZraAlA8rkkG9ntUFBGBGZ02iQYSI+HDlBHwwvXNS2Mv8QFN+h2qcL6XpnOh2yDz7Igfv/A/Azjojzn3oYqUefJUCs3WgW0pdpk+kqJrvdFyGbWSrTUJ7SSrUybYeq4NV1vigdGGOnKgRXiMuF8F5nJhqcaTeSUF6xc+b9p8dMswbGNs4NTNPr0pisk+WdNf3zdWmsRRXpC3jV/V/CGILLZ9sjDSBaKVSGkbw8BX9brStwLOZXqBcAaTxQw4i8jiTeicUtLGqGabuABO2mPB/qclK1st+//EwEvSOXHYn0FToESOgxkxB9Zo+gucOuRYBI+ZQ1x56xPhQt2hecWcez624k0qC4GhYhpdGcBjyYjan6RXBlzEsgr1sTwwnxLnqt9/cBXRjhWhd5OcqpNuT3rTl/lcMl8gr4zDGSFWqGWYtJK8fLtnWy5Qy9c7PiT+v8BcQukpW+mg
 zPDpuEAA
 6ZJ4hLegJ2oPyEGd9Fc4Dtd108HlcnvmMiSQwXMUoDUBW8crgQo6FStSNmdgtR/em2A2oPzcdxo+BgJD+Ow1kgKP5rKZiMxL+xZr3Zy+y+M2zhThizNmzQRysz0TGSBrFSyI66g8aIxJ+8cFXh2USwjdNhGpilN16ewcQpJ0fHqYB1sIIgrJtTjbPkSh6rp3pSyb4YAmb/y5vhU84+NfzJ0B/yPPCuKAYowNtspjjJ1I0jzBoxQoGHN3OVW51D1/sGp+veq13UIjypOIHkDhNKSaSsynXpql9XjR1O+t7TF1sa7Dv9KNovWuaLvzQ5BGBNuCdg2qVyYti6tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:47:30PM +0100, Lorenzo Stoakes (ARM) wrote:
> vma_merge_existing_range() merges an existing VMA (middle) when its
> attributes have changed to match those of one or both adjacent VMAs.
> 
> Sticky flags are propagated if they are set in any of the merged VMAs. They
> are initialised from vmg->vma_flags, which is assumed to contain middle's
> sticky flags when the function is invoked.
> 
> However, the VMA write lock is not held for middle when they are first
> populated, so concurrent updates to atomic VMA flags may occur, which will
> be lost upon merge.
> 
> This can result in fork failing to propagate guard region markers and (if
> file-backed) THP collapse discarding them.
> 
> Resolve this by propagating the sticky flags after middle is locked.
> 
> Make life easier by factoring this into propagate_sticky_flags(), which
> treats vmg->vma_flags as its base (in case any sticky flags are set there),
> updating it as sticky flags are accumulated from merged VMAs.
> 
> Also update vma_expand() to use propagate_sticky_flags() so all merge paths
> utilise it.
> 
> propagate_sticky_flags() also asserts that the VMA write lock is held for
> the VMA whose sticky flags are being read, with a comment explaining why.
> 
> Another means by which atomic VMA flags can fail to be observed is when the
> merge is finalised in commit_merge().
> 
> rmap locks are dropped in vma_complete() before the sticky flags are
> written, meaning an rmap walker can observe the VMA without sticky flags
> set, which can also result in retract_page_tables() discarding guard
> markers.
> 
> Resolve this by assigning the sticky flags before dropping rmap locks,
> factored into commit_sticky_flags() with a write assert on the VMA being
> written to.
> 
> Also remove the vma_set_flags_mask() invocation at the end of
> vma_merge_existing_range() as this was introduced by commit
> 64212ba02e66 ("mm: implement sticky VMA flags") to propagate sticky flags,
> which is now redundant with the introduction of commit_sticky_flags().
> 
> The vma_set_flags_mask() invocation at the end of vma_expand() setting
> sticky flags only is also removed for the same reason.
> 
> Also update vma_merge_existing_range()'s comment to reflect the fact that
> vmg->vma_flags gets updated.
> 
> Finally, update the userland VMA tests to reflect a previously missed
> const-ification in vma_assert_write_locked() which would otherwise cause a
> warning when building them.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
> Fixes: 49e14dabed7a ("mm: set the VM_MAYBE_GUARD flag on guard region install")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

