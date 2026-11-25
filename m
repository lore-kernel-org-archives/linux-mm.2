Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B563606A338
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1R4oRQ/i;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Xseqmy5b;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1R4oRQ/i;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Xseqmy5b
Received: by kanga.kvack.org (Postfix)
	id 2F8CA6B093D; Wed, 25 Nov 2026 03:45:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9BC6B093F; Wed, 25 Nov 2026 03:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199D86B0940; Wed, 25 Nov 2026 03:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E09BE6B093D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:45:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B83EA0E77
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:45:10 +0000 (UTC)
X-FDA: 85473006780.01.4F120A0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3839B18000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:45:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1R4oRQ/i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xseqmy5b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1R4oRQ/i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xseqmy5b;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596308;
	b=ZS0JwCVIHwevLxHKltkiCjr7IQrgGO5fSvgPB93NbQy9TQLcBqRu5ZlBI6Gkp5vF/Y2hvp
	grTTSvrJ4301aQEiZwGMu9hKtiXeEmF6q01sgoZxp8r/9t7pgSXBkHhRHxajPMav4l5MUc
	fIiN1lf4CQkQA5Wb7klu1+d3UHmAvH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIQGPFCJd67xaKCihbcJC3tux5xClyxULhK31mQOmgA=;
	b=kV7m2IwTOI3EstaPgBbo1ot8yGYvwI1KaJwdf/8S5NHrS+fnrlHrLKZ3brtj0I14Z5BpoA
	4onzK3L2OeoNBAmxpusArE+/chg6TXVFpziVA3S2sZglRN+6BBIyN8bIfvu8MXthKncpQI
	YZMJF84mQiIcWuXrgGpi6yQay9JjwlY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1R4oRQ/i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xseqmy5b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="1R4oRQ/i";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Xseqmy5b;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 78AE61F747;
	Wed, 25 Nov 2026 08:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795596306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIQGPFCJd67xaKCihbcJC3tux5xClyxULhK31mQOmgA=;
	b=1R4oRQ/iWiVF3GfygHgPI9xqm0DU0PL/33RSEd0kAHFOjj03JbHnGcDeKjPUuZVKUfQ/C3
	se0iiVMXGurVPeKjOHJAJnk/StmPKNjpbtuFJjiXHDzF2B6Iiqw2/KkYzF02DFKI3odKHe
	4PRjahV3Nz4geMoybs+TdWwUp9oQtfo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795596306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIQGPFCJd67xaKCihbcJC3tux5xClyxULhK31mQOmgA=;
	b=Xseqmy5b9lVtcOfm6N7qVKeOgqlUYxNKD7bCD3QFJ2Xcfd0l+ZHy35FU1NbGLHKMQyqpAk
	Kdvq0lCqAMg4XqBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795596306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIQGPFCJd67xaKCihbcJC3tux5xClyxULhK31mQOmgA=;
	b=1R4oRQ/iWiVF3GfygHgPI9xqm0DU0PL/33RSEd0kAHFOjj03JbHnGcDeKjPUuZVKUfQ/C3
	se0iiVMXGurVPeKjOHJAJnk/StmPKNjpbtuFJjiXHDzF2B6Iiqw2/KkYzF02DFKI3odKHe
	4PRjahV3Nz4geMoybs+TdWwUp9oQtfo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795596306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIQGPFCJd67xaKCihbcJC3tux5xClyxULhK31mQOmgA=;
	b=Xseqmy5b9lVtcOfm6N7qVKeOgqlUYxNKD7bCD3QFJ2Xcfd0l+ZHy35FU1NbGLHKMQyqpAk
	Kdvq0lCqAMg4XqBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D533134CA;
	Wed, 25 Nov 2026 08:45:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FrpCChKgBmvYegAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 08:45:06 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C7C0F27BBB; Wed, 25 Nov 2026 09:45:01 +0100 (CET)
Date: Wed, 25 Nov 2026 09:45:01 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 4/5] mm/vmscan: be more careful when releasing FS
 metadata if buffer_heads_over_limit
Message-ID: <wm57zjtvdpexvbfygmdggw2ytsazelyds4rt3mtx6oy6u72mke@rhviuzp26rt6>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-4-236d69f25c24@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-gup-dirty-what-v1-4-236d69f25c24@suse.de>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: tcycyoye1xf6beq31ed4r7x7gmaxs36a
X-Rspamd-Queue-Id: 3839B18000B
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795596308-624681
X-HE-Meta: U2FsdGVkX19oX9/i9Jp/TMueIfN/mb0ohsckSqkf5U29dl6Mpu+wq/eo90cEDpf7hB2QOQaBh/4GgHxyeU3aOx91gY1UL0V20omGkE4Uqgu6BXOALaqRs4C8DMS8kyAl/kxzxus9TRXoEkdK4ELJpTiOWmYzIWDIRCKLYQfVdgKkPkuMCaJkhfNbWsIqZlOwzm04JfAUZo9BGALJ81EC+GlsU6s78B64qY5QSduiD8+aPBlRaCifC8PViObMhfHUM8K6Djaa8h5MZJFN8/Qbyuy11OqoRx2KCZ3W0wvVxCE1n8ksyIPpm3eaPIzeRXY9TfjWZgBN8t0qyJWeEOLcc3IT/vMclFOfUMU7zZCTLw6REsWn52P8SPcSjWExYIBLcOFNsgZlZuGeB1CmaA/cxIJiGosNTOaacwQ/Qj5adY9ZAXeSL2OCBTUxtPIbxK5wS7Hs4dF8e+GXKuZi2hTZxykxPaGqHZB/3JgFL92UKl3+UioFsY0aWqECjwmfdF5Euw1Ul5LqhKmBxOhq94E2sIfWAkaRXK9/hOO8tLAizDBz3rxUzIVluV8nQacb/GxmeQ3oS32ogXm3pFTiDyTqedJwToGXAdz87R1eYlfmV0KZHXGHXdVp8W3BS2y2r37p8cX1H78ExS1VEuwW9JA/84vbEJWKk+K2BjG0z2pw+nfCE29Ce3vUgaO4br2Iun1IQI35KVUuKd0Ew95/BiMVUgRU1p9VXqFoCYO6CaO5bEdJicTec4eQwuSKqcRKykiqy+54l0rzF/lTmYPoLf57QwxLZV0ziqedEWhzZqbSIHiikOU+iT5ve1uPUwdlHJ6brU1USarLisclXlOAxflAKbbDj2o9klb10iKyZRIEm9pX8F8CD7KspfAzhrmKbHX9SUQfVnhLx/HXGRMfKASPDEOe+u2yOx/IAmxSncl4Rbo6qeNjU2EHTb0SzkSgfoB9GBRZbjE31h0+7wggMjz
 ac36+pM4
 EQgrWVll9QuL9D7xw/b1DGezd7j8dC0kFX2tXjQQZ268T/b/Tiv57GADtbMTpQv7jugJHR3CpzNclwWJQ4zMUMz3iolGvXiuL3XVRKvvbJbMBKCfNWPIOdKwbcHt7UxDZ2KpymeNv3noXQwTB+fVxkPrFoLPlYq5D7ILH6qsfbmyeZdCo26cRJAG6trO8GsKKZYwVnvBM3WvenOiEXtWNOhTZjormIzrrdg4nPCcklp53Ze+69Y73zJ5x0Ml3PEeAiKzSSwBoW8cwh7HYbdekCzwJmZ5QJ4FTIXPv7YXSeJGM0S4DRdMpxrACoFB5zmvbbIVtKdTxTBpVcM5IxStOiUlKfdCNbONMVMeql2x4PyeaZk9cgLWwV8RXLkrzTO+5TqWsOzbS1DbvtkxHwca76xeu4EnX/eetuqzY1npLENi6Lfq0vq+YO/014ZPUqILflwIcgyj+puGkgWUlPtIFSxxa8eOGUNNlnhJPDBeC7ExvBwpSgDZfeseYC94oRnblV8YtYJL6cDiADSoi2VIJhVhN5fOzpYHmP67ocaEst+sxoIY+SwfOvjGVBtjl5JWUlxcNd9usDXcSJQQsGtoNReL8gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 19-11-26 20:10:47, Pedro Falcato wrote:
> Namely, don't call ->release_folio() for mapped or referenced folios.
> Since this is the active list, there's no actual point in doing
> unmapping. In fact, that would be counterproductive for active folios.
> 
> So, gate on !mapped && may_release_folio.
> 
> Reported-by: David Hildenbrand <david@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

This is OK with me but so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just given buffer_heads_over_limit is a HIGHMEM thing and given how much we
care (not) about HIGHMEM, maybe just completely ripping out the whole
buffer_heads_over_limit logic is a better "solution"? I mean it's a crude
heuristic anyway and for struct buffer_head to occupy significant portion
of ZONE_NORMAL, you'd have to have several GB of pagecache with buffers
which means the machine has to have quite some highmem which makes the
setup even more dubious...

								Honza 

> ---
>  mm/vmscan.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d80bbb607a15..986742d7fb6a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2217,7 +2217,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  		if (unlikely(buffer_heads_over_limit)) {
>  			if (folio_needs_release(folio) &&
>  			    folio_trylock(folio)) {
> -				filemap_release_folio(folio, 0);
> +				if (!folio_mapped(folio) &&
> +				    filemap_may_release_folio(folio, 1)) {
> +					filemap_release_folio(folio, 0);
> +				}
>  				folio_unlock(folio);
>  			}
>  		}
> 
> -- 
> 2.56.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

