Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF85606D839
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wlGuuBra;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YFal0Hsu;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wlGuuBra;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YFal0Hsu
Received: by kanga.kvack.org (Postfix)
	id 82BF46B05B4; Mon,  2 Nov 2026 16:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC696B05B5; Mon,  2 Nov 2026 16:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F30A6B05B6; Mon,  2 Nov 2026 16:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C42B6B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:47:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D12E71A01FE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:47:05 +0000 (UTC)
X-FDA: 85391514810.12.BBFBB31
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4659C140003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:47:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlGuuBra;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YFal0Hsu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlGuuBra;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YFal0Hsu;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793656023;
	b=6I+w+yTaqdcd4OOprjZ8GhUk8VCsBLXQwngm9mYS17ZZGiFxThR0sXYL05z+X0pYWbq3Xc
	h+3Iok61r7fR9bJT5kxSu/XnIQE0/femk0gwHYkqAD5Dr0nzPvZ2MVPYMao8k/47tOYzuF
	12slXzNYijBhFzjhaVYnWhDyScr2zFg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlGuuBra;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YFal0Hsu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlGuuBra;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YFal0Hsu;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793656023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umkgUxq2rfgJ8NLFTrV8RBmSaYpLglNk+AEj6kYyfO8=;
	b=1WFoHZYFqPQZDsYD57RQeP4IUdlsI3bukDNSo19VIjgeJSJEJNa4PKz9QGzjsbcgLeQhoV
	kEt92OPVxd1gQrRUwttuWJn+toiZXz1tGUKrDa5tPv6zGAMhh7SR3GkYrkRcUbmfpPi/Kp
	DGadm3g7Foq0PHes2RdbpvGQBm96XPM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 34C491FB0B;
	Mon,  2 Nov 2026 21:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=umkgUxq2rfgJ8NLFTrV8RBmSaYpLglNk+AEj6kYyfO8=;
	b=wlGuuBraz5HKRr2tw/43UB5Yuv+PiOe6oD78Gy2DExn6MmnICbnFIL0hnqgIYj55NjFn/h
	yyNAE+HMDOBWohS7eneAyQu3M3yJPh1DXvz6fU2T9cVx3MdCm0YO+JqxDaderAQlrU5YJ7
	Rm6CzGphWaw1sRyMOTjs0kKdzvKH8lM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=umkgUxq2rfgJ8NLFTrV8RBmSaYpLglNk+AEj6kYyfO8=;
	b=YFal0HsuhA7TGhN4xzisVTmXdG7rgPHRTH67cFJF8HNhqCyqL7LPenFhPQ38Z6J/GDyOGc
	UXLd6y0VlguRo7Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=umkgUxq2rfgJ8NLFTrV8RBmSaYpLglNk+AEj6kYyfO8=;
	b=wlGuuBraz5HKRr2tw/43UB5Yuv+PiOe6oD78Gy2DExn6MmnICbnFIL0hnqgIYj55NjFn/h
	yyNAE+HMDOBWohS7eneAyQu3M3yJPh1DXvz6fU2T9cVx3MdCm0YO+JqxDaderAQlrU5YJ7
	Rm6CzGphWaw1sRyMOTjs0kKdzvKH8lM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656021;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=umkgUxq2rfgJ8NLFTrV8RBmSaYpLglNk+AEj6kYyfO8=;
	b=YFal0HsuhA7TGhN4xzisVTmXdG7rgPHRTH67cFJF8HNhqCyqL7LPenFhPQ38Z6J/GDyOGc
	UXLd6y0VlguRo7Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08F12134B3;
	Mon,  2 Nov 2026 21:47:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DOPMN9QE6WqLAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:47:01 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A9A36B16F; Mon, 02 Nov 2026 22:46:56 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:56 +0100
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm/shmem: remove truncated folios from the page cache in
 batches
Message-ID: <dru32b7k62tbur7kmk6vv52zd6jnglnzzz4pvhlsqez6smcjip@gjuh6fud4nir>
References: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Stat-Signature: 6puejrf1xzr4uy7t8bjdrdjbor15j439
X-Rspamd-Queue-Id: 4659C140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793656022-514725
X-HE-Meta: U2FsdGVkX1/hRPS4tdMc98ZFTUVQiYk4NNbuqffU/f13te6b6z7FjAPL4ev6XzR044NAfInwAcQA2feci89OUdbf6COlUp7DHRRKw2unfubUVrIpnr0BAg7ERYuNuWpoXTi17bQAIYksijuUfdIBG3oQCk2eEmhyVf3xgNaQGs2FCJsdxt0tYwwdQjJiC8bDoztEjCxiaV7PIGJLtI00vfM6ZpLxBPweTQT605ETnxOlgiCIikA0uI0rkalWOld1OTkSiylPF62TxmLF51D0ILePUQMA2ljWcQrGxe7EtRxQNXT88/EkIKlhGIa39Z9HuqAcLOCnSY0zAdnmT/ILuY6VeS9xviG5DJN82KMKEvu0XUCiRpBaggzRx1jnSTPRorEE1EceKHgqWsMJ9EiaKHs658sXjWQs7UkqJaA7La7uYDUBoc3tybv5Grig19BbtxW72u2/T+NOxR920ZUgTSqn11QxB2KsQa/pfUZDqGPjQgW10Xw2ZcGrfCbygFi0fNnscT5h42oItDVecgn59ekKhmApRz3T07oSmOCFVHLXNE724iG0juE5dFlEnXE4RDP07M+gDvsBMkVZFM1d6PQ5HoMlF56nmcKj8hqLO+JoHUL7Xu/snWECMwm8juVoE+vIU01LSFrM76IgVmnT9xJR39wpr+e/BCMqzoxRmtlSYHImUVhNxI3QqfQfaPet/JPNGJajbOzp+7CCP0TXyEPZ68lGWYng+IufG07UY0J9hymzDOA+eircLUO6OaVj8I+vLqZJPrqVjitq2aSQrr8GyykV5r+GNf87d5LfJvtJvzQG/rbHPRHMHMduT/gHE1xU8Sjyrqz9bj7n3vMxUnJQen021ukhaVX/9n8S6JWmTfCj0aPLefocG+7CubuhbRehSZORf32OXxPe7Nxe2QAJvJ6vQYEcEIMKaj9GQhHIzU+tW3IvqIxdf5c9rRg8n0HbAVtA9K6w7pM5JFH
 MHnbddhr
 DYBjBWpXLB9fDZLzgXJygDxl2UjbhDEGdR05jg71ZzLRS8nK8rHyLtPKFc0YoM9IaLJVk34yshOITb/UpsR6g/wk0CcaG7efahqTBSwBu04WU85T3JcLencylpf9l+J5rdicQaEtwIojBy99RCHaq7Q7vPGHJUcYpnDrXY/NY+pUxnnSCTg0TpboCFKcCrsVhgsBWHPruROfaw+mI6XkqMrYToivJfHNk6YNsaRhpS89egHX/Cjb8q5/IUYl8SP6xMRggN66Uwt1IF2Mjk/QMqNx54e6kfHYbMVVZivQmHJnW6bv5llE0AB0vAdnX40JWCMP/NvSAB+UdzZuwAgVriO/HUZK4hGFbelHSPOsHyKhcyYeEX6mlPrXPLWF82r8s0zMDTGrxdu6Y9GJBXjYpjdovTI1YHlkCB6GA5SwEWD4gW40UVmL+85hIlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 29-10-26 23:44:57, Qiliang Yuan wrote:
> truncate_inode_pages_range() takes the folios it finds out of the page
> cache with delete_from_page_cache_batch(), which takes the inode's
> i_lock and the i_pages lock once for each batch of up to
> FOLIO_BATCH_SIZE folios.
> 
> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
> so filemap_remove_folio() takes and drops both locks once per folio.
> Truncating, punching or freeing a tmpfs file or memfd made of small
> folios, such as a large /dev/shm segment, pays for that on every page.
> 
> Clean each folio up as truncate_inode_folio() does, collect the ones to
> remove and take them out with delete_from_page_cache_batch(), which
> needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
> the folios kept when undoing a failed fallocate(), stay out of the
> batch. Dropping an 8 GiB file of 4K folios, median of five runs,
> averaged over two boots of each kernel, in a 32 vCPU VM:
> 
>                         before    after
>   ftruncate() to 0     1163 ms   913 ms
>   hole punch           1155 ms   914 ms
>   close() of a memfd   1161 ms   914 ms
>   unlink()             1162 ms   916 ms
> 
> Files of PMD-sized folios take 20-25 ms with or without this change.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
> To see it, fill and remove a large /dev/shm file:
> 
>   fallocate -l 8G /dev/shm/f && time rm /dev/shm/f

Looks sensible. Just one nit below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> @@ -1352,6 +1352,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  	index = start;
>  	while (index < end && find_lock_entries(mapping, &index, end - 1,
>  			&fbatch, indices)) {
> +		struct folio_batch remove;
> +
> +		folio_batch_init(&remove);
>  		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>  			folio = fbatch.folios[i];
>  
> @@ -1363,9 +1366,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>  				continue;
>  			}
>  
> -			if (!unfalloc || !folio_test_uptodate(folio))
> -				truncate_inode_folio(mapping, folio);
> -			folio_unlock(folio);
> +			if (!unfalloc || !folio_test_uptodate(folio)) {
> +				truncate_cleanup_folio(folio);
> +				folio_batch_add(&remove, folio);
> +			}
> +		}
> +		delete_from_page_cache_batch(mapping, &remove);
> +		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> +			folio = fbatch.folios[i];
> +			if (!xa_is_value(folio))

You can move this loop after folio_batch_remove_exceptionals() and drop
this condition.

> +				folio_unlock(folio);
>  		}
>  		folio_batch_remove_exceptionals(&fbatch);
>  		folio_batch_release(&fbatch);

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

