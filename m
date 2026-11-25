Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BC3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xWfccdjs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OO3e4siu;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=G5/pHpGg;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uThUAfA+
Received: by kanga.kvack.org (Postfix)
	id 373C06B093F; Wed, 25 Nov 2026 03:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324746B0941; Wed, 25 Nov 2026 03:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214696B0942; Wed, 25 Nov 2026 03:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB65C6B093F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:47:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DD5C1C496C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:47:49 +0000 (UTC)
X-FDA: 85473013458.13.DEB5F8F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29123C0003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:47:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xWfccdjs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OO3e4siu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G5/pHpGg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uThUAfA+;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596467;
	b=pppHyjGi1EBh2rRy/V/f/r4xZ1hSb72bMMH+fnVq+1ns5WC3zEwV1ErQWSSl0f6arITD04
	Enx5jG/oA7GO5N8/pBInn/tG1nHXOh1w23YTNGFJMX/C2//tVDQnJmIJgVfT8mGvpWP1rP
	uubTX78KcKX6xDokJR2lU+3pvFzqggw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLw5iSLUAmy5ESjmbTA6ThiW5AF9rDmQb0R0/WJ6aCs=;
	b=LHLPwiiJ4AyHvpwfrtxbhBTmzR/U06wIqc97osUqGSwpbaP4sonysb6CQQpFKCn/+61FHJ
	raxrLCdlyFoIivKs8vn5ykA4PT9KnLiGQy0z1u5ohkPYDwMr+g+iZgi7vSMvkAAOKu+hoM
	4VhNqOIl5Zf2CquF77mkojq1hHDZgss=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xWfccdjs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OO3e4siu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="G5/pHpGg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uThUAfA+;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BA8D221F6C;
	Wed, 25 Nov 2026 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795596465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WLw5iSLUAmy5ESjmbTA6ThiW5AF9rDmQb0R0/WJ6aCs=;
	b=xWfccdjs+1brj5kF+U2+aXs2cxkUEyD9UIBRARlzVvl9saKhVrlGVeG2182x+XRHh74x4L
	30ISI2+aHO20dRWdE5nYT7+NRhq0mYp8xn9klblBfquFqjIwNfnnZuxyxjGaW4tqecXeGt
	WzDf6SwJBfcMUEHQhMU7A+wf52Seuso=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795596465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WLw5iSLUAmy5ESjmbTA6ThiW5AF9rDmQb0R0/WJ6aCs=;
	b=OO3e4siu057blVR7oduuGttVRQ6uVbk+AYp0GveOXc/5mOKgZ2gVhEscpe/X8sc4cmWVPx
	11du91yR2QjGURAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795596463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WLw5iSLUAmy5ESjmbTA6ThiW5AF9rDmQb0R0/WJ6aCs=;
	b=G5/pHpGgJ+KX/BAPyqrfkORLpvZZ2w2sPOsdSr9Aa6d/S0BTaAsj041hgU6q8Xx7Es/HO4
	vCWtNLkkgWw69gT3KFSZkNdF4TImelbmEdC00v6oGMOc5Mhe2eGGphFvBf5ZxMVhq2WwUS
	/kZAgJWDINutbQZW2YZaZV5zvw8ht9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795596463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WLw5iSLUAmy5ESjmbTA6ThiW5AF9rDmQb0R0/WJ6aCs=;
	b=uThUAfA+mQDqsC3uBXC/kZ6qobt/aiXkG2wPdqYaV56ahkHKu4SUllbMGqyh6QdYUxnTHe
	76GoEn2qMIcPHnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90A7F134CA;
	Wed, 25 Nov 2026 08:47:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0yVvG6+gBmvGfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 08:47:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2440E27BBD; Wed, 25 Nov 2026 09:47:39 +0100 (CET)
Date: Wed, 25 Nov 2026 09:47:39 +0100
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
Subject: Re: [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned
 folios
Message-ID: <fsmnfotflgrddrlak24cve7vkcjkellsgb3xbei5ysxvmqnul6@byvxblm4dtqm>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Queue-Id: 29123C0003
X-Stat-Signature: 8n33i8yjmz6my4f7tf8kzt3yyxka8wou
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795596467-984832
X-HE-Meta: U2FsdGVkX18cC4On9Hf130s/knFOj3i67N1DlC/hj1MV9lsmivQC2l78k8k/Trp9NOYdLYliZkW5QQYsuJPK8QnuXFdv21EwT4b51vbWsd+fZbQhtPxbdeZnXcUObSCKOPgx6iWy8q+lCft/1gPAmUzfgxouBfTEp+YJqSTUvIWns5wcwtL1a5Wu7kHEQLX1Y59UaDVjj26RnfHoD4eAXBJtH67rwOVXqvOzo6+1uL0co9tsvwgdxMH8Y8YoCvBeJgHH9wQU9R7eTclBiV1NgMVKgcA7YlfKUzKcW7mEeJW0uh82CbNMFPDWEDVp1+PcmnVFZaluO1O6IBhlCGEpVeA+uEjscq1iAn/ODjo1aO0zW6VxV/dlAkintrIvES71p+hl3AxTZHxKtf/XNbre/CvMaXEEzwJEYHoKdrmMfqPQB0SfB8mtfw/Op32PyQreJjIy7egDIxm+1YCHelcfk6BlZ22AxtV8OZMrDYQ6AilozwuTf62FQgMFni+sf62OBT0eqhr5/7x1A3yYiROXCpHnfA75PYJ77CVMcCgSFw0Tx41gJXpNo171pTYYqdXgSk1rBt1WN4+8o+k+GONBtLez2w+/lZe4Hq0uydY9Z8VFDVZb9SF9EqHl41vbSRBMfHS4F/aHZEashLtzApIo34BWWpCrcNutbDMVhPcNDC7ZUu7aw0shQPOY3T2Nz5K8hevHH9d4jmSY00T8UiKG7t5+fn82Ty12jAXc1vOwQwTnWOx+Ik2QUSMzENP8r1Hp/WmKasHBJ4LCUpGRMmzQdkY09yMVrDsUMShLX+FagKOfKx2xuwSS8WGdbxk/KlFYv7qcurlcK1t44E61x5I7k4JbX1eYm2p19MAU/P8Buw4oDIa+aqyW8IbpmPLyyCB7WB0A4oTpY7ZvErV5byJrWwCSjtn9NWAX/5K5EoXn2m30E6rFa408iK0epQdrWKjPxIw/3JBxc4KzSTUIfSN
 WNObBrL0
 Vt+cE1DKGTFGRcR0LnRRTCdy0OOcTEt5cHfg59s8LF9d6A5S572aLpq0vDrWJmt4rOKreQIntmCLIe1ts6BOM6fX40GHkx2J4eS1hT07JasXuR8eNp3R+UNOd1yKtyNczR1YPiOvii3GLMmWihdgL9yvGrADE5jPEw7y7Rf22NGXiw/eyHuCX3pc70g4eDFRt1FzqZN59P68Sbh8pXh8ZEbDHqn96PprKZ3ozacRewOR3Z56OT2HpcPkjxJuDKUyyRIgeMSTveIxsSjG9FjstA4rDcAsfwO5lMNN8+zwr6udlU87+Kvpu5WrfR//j7ElXVC0oJ9RnwSzwRMp2ZFHexrBnKOYH4IBni15VFhGZUEDgyM7kF0bA8921pVoMcbaPAdXVnH/dqYRcf78lCqLDd6NdCwEpxpZkbReQIIPGlZpege6LFxdY67Oqhb9RbpSd/J28HalNWYakgeQX5/uy26VngLtufRg8rUyliR6exJwjqY9dvcYaU4c9Jo0HSvE/NWECIZ5m7PYH1BwOSReG8kFSciFaORfi009Lmt7p5N07t8zky/5KpEbengUaq9PmCsu4KvULxwUzUqS57ThFdmxN5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 19-11-26 20:10:48, Pedro Falcato wrote:
> Some callers, like folio_unmap_invalidate(), call filemap_release_folio()
> without any care for folio refcounts. This is on purpose. As
> folio_unmap_invalidate() states, invalidate_inode_pages2() needs stronger
> guarantees, and "can't afford to leave folios behind because
> shrink_folio_list() has a temp ref on them". Ok.
> 
> Use folio_maybe_dma_pinned() universally, in filemap_release_folio(). This
> has a much lower false positive rate, and should be ok enough for most
> serious cases.
> 
> While here, properly assert that no folio passed to release_folio is
> mapped.
> 
> Cc: stable@vger.kernel.org
> Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

and we'll see whether there's some path which actually required private
data on pinned page to be freed in some cornercase :)

								Honza

> ---
>  mm/filemap.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index f9e34144c53c..4fa75663b7f3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4571,8 +4571,11 @@ bool filemap_release_folio(struct folio *folio, gfp_t gfp)
>  	struct address_space * const mapping = folio->mapping;
>  
>  	BUG_ON(!folio_test_locked(folio));
> +	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
>  	if (!folio_needs_release(folio))
>  		return true;
> +	if (folio_maybe_dma_pinned(folio))
> +		return false;
>  	if (folio_test_writeback(folio))
>  		return false;
>  
> 
> -- 
> 2.56.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

