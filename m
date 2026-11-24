Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F925606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sp9xq77Y;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lCNfS4CM;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sp9xq77Y;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lCNfS4CM
Received: by kanga.kvack.org (Postfix)
	id A141B6B06A6; Tue, 24 Nov 2026 07:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C47A6B06A7; Tue, 24 Nov 2026 07:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3836B06A8; Tue, 24 Nov 2026 07:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5988C6B06A6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:42:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FF9A1A0956
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:42:43 +0000 (UTC)
X-FDA: 85469976606.02.4189B34
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id DD493A0011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:42:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sp9xq77Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lCNfS4CM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sp9xq77Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lCNfS4CM;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795524161;
	b=5ymWRutlQ1FEJNaw7QUeB/nshyrsiM3DUV2Q7af5aRcRRi0ymugZsdzS4A4eoLOLPpAxkf
	ZyyHVslbT9Ykn2UrnK8d0Wj9qwqxhecwm+5CpRBe+cMcQRfgyQmaEiegYTTTTFMilKB1//
	+cNajKiaqB5nwyJcX1DRHWKThGPTLWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795524161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTqJqtLVAhClH0Un/jCsQSvDa5fEGXg/BziUfu+XFT0=;
	b=3siGk0R8BS9PB1UTkeTqMK53r1nxUaTzTTbOO6LlpqpQdxjI7qRkWvXXeuStvQ+eJ5i9Ia
	pwclNjoNJSG1Run9MACjN5yZv+ZURbdeFS/Oa7KaGICsAwCFTAOUph4JrWDkmLHlxNVitu
	SnLwRWdythESqbSoIjJbbpeZ67e0leI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sp9xq77Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lCNfS4CM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sp9xq77Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lCNfS4CM;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6CA641F461;
	Tue, 24 Nov 2026 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795524159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTqJqtLVAhClH0Un/jCsQSvDa5fEGXg/BziUfu+XFT0=;
	b=sp9xq77Y3UGi+wL44/r6/dl1iC7T/d1MmIfEnA/XjjNQjky3qmaYkvg4+UjHfbKMU2pK1+
	Y3pMvDkyeho9IlFQKeIFMfe7nJBnrF0O1Vgw6lCUcMCkNL8mpySRs3rjsn01E0N1ZJKNtL
	EtZwWvvrNUsa3i4vLB5h+zpoxOFn4Iw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795524159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTqJqtLVAhClH0Un/jCsQSvDa5fEGXg/BziUfu+XFT0=;
	b=lCNfS4CMRo0oF/zKFxD4us1DHCLI/Qs7BRlFIV3VUqKxL2o0Q+2IOvaApUWJLy3TD1Cdsf
	dwnMHQ606Uud1DAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795524159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTqJqtLVAhClH0Un/jCsQSvDa5fEGXg/BziUfu+XFT0=;
	b=sp9xq77Y3UGi+wL44/r6/dl1iC7T/d1MmIfEnA/XjjNQjky3qmaYkvg4+UjHfbKMU2pK1+
	Y3pMvDkyeho9IlFQKeIFMfe7nJBnrF0O1Vgw6lCUcMCkNL8mpySRs3rjsn01E0N1ZJKNtL
	EtZwWvvrNUsa3i4vLB5h+zpoxOFn4Iw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795524159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zTqJqtLVAhClH0Un/jCsQSvDa5fEGXg/BziUfu+XFT0=;
	b=lCNfS4CMRo0oF/zKFxD4us1DHCLI/Qs7BRlFIV3VUqKxL2o0Q+2IOvaApUWJLy3TD1Cdsf
	dwnMHQ606Uud1DAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4285A1339F;
	Tue, 24 Nov 2026 12:42:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yC5VCD+GBWucEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 12:42:39 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CA50227875; Tue, 24 Nov 2026 13:42:34 +0100 (CET)
Date: Tue, 24 Nov 2026 13:42:34 +0100
From: Jan Kara <jack@suse.cz>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix cachestat NULL pgdat dereference on DAX mappings
Message-ID: <lh4cnpy2kw3tdtmhubwhhvim25kxpqxo6xttt7sihyx7x5hqdf@3tvivew2qh7m>
References: <20261123030014.3116755-1-bsdhenrymartin@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123030014.3116755-1-bsdhenrymartin@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Stat-Signature: 7cmorxxbwiipcdnm37j46m1ry44u4eci
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD493A0011
X-HE-Tag: 1795524160-927139
X-HE-Meta: U2FsdGVkX1+4TLH5jsT5hqdqtsWfWVgmul50anrgUAIb3cLdN/XUzw1NfV+edONk8DXTSbY/6Zvy3P16/HNioWqCxol8VdtsNDiMldSli1fDdB7qDwWQEupV1wkKJ3/do4+dF6bHhFv7dEV5oVibOBlMymgVFbFkYHg6ULozOa+XtwvRvaBiyecigHtRtj+ZZTr6ql4reTi7I4S2PY4I8wOHvwbsJPv6KADmJwnOAOfVXYFHxuUZ6oLeLJ308D4nvhxpAJ4qp9pjYo5VFIWF4BQb50M8S3hWcs/NpzIHZerezOqIbclCWkgnRUjPYl1vNTv65tz9w5YOaXaPiX6uBltegAs2v2inz58COHBKJ3TwFZ8tYUIu5IHBuu5XyioDKgfnGcL01HP/N3lJR62dxjCIEb7Is1k1XsuNn8AyS+rnmz4sZweQqyr9TSPMmLaIjnNj3EHuJTKBE45evnie+a9fUosKJnmJ0GOZnRYLJCTxMECKuzp3AWDm/ksimMgA9X7Vs1OSXoKFeeQPFSBYPgSmPdQyiEF6ruz6bIZZ+rHwZuRU4PWfTMU6rOvcRbfqqfoQhf9URdRfw9uYpJcIWhuKXYjmaVH8aUdozIzyfM4BWLF6l7q6O3lCkhFaO5FvLp0gxgK52H6w5pOO+f5IL+jY7Bz8cYsWVhR+j2xnLFpagttFQPx53r5kqli0gneu17imou6q0LlZe1/CermD6vFrQcc/KfxgSzN2Vw2TUBFIYiqqNZ1GxKHFPbk58xgptwaMyXUrgwsxv9TC9Be37EfbS37i7uYnSHxWBOLvHBP9vVXyOMKOrsiVtbih0IEN19ghhAEhqrlHx3WT7z/DYbV5jnq6Anj/HeCFEVs4kw1oO0aEHGZFN0+mpP6b1G1xwQBjBfKqpy2xVxeAewltpkVr91mgzvsyp+WLijz7NI/0m+scZdW38vojrFhQG3vSdeqEq6VeU1fpW+M8H+8
 XZVCX+gB
 iQgX4+F1Vg9JdufQHdfk/lA7KZ67smxjZYSHZ5mFWVKNMaRPdbvShks9cEhMhnr9uU1Ql+euBY/CMKBk1udaPHaHZvmIGLEZFzzcTec0SVMp06kYVmiANttOx7dEgQvEm3bz7HzAJlc5AgNcvQJVekG4z30eDq0ySwHldrofPhy+p7SvWr2HReEf5m+Vm8RjEju+HDilNEd9DUqJMfIXDKPx9E51E5Pu/C9Qw//aZFa/GnXNFlipeNptuzztTwvPiI7VgPrO2ESoEHtuashE84742b2JGoarpxhTX1WXXRdD9qxfYflYCDrMJyWABNVSPqn6ISlbkqktZq3C2PQCvGK5CR6lW5Rryz6dP6AObPRr0vYnguFJCwiP6AmZKOcNqQpf3Hz14sVgh25a3chrjLJ2Fa7n/I55Iq549+cWnUbd9rXXOCrTToUloEmOCxmYRqkU4SNUU+xhT/hUhV1N0zAJQHKDW8loexkhZxLpOsvOIGnr0LHX9SIPV4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 23-11-26 11:00:14, Henry Martin wrote:
> filemap_cachestat() treats every xarray value entry as a workingset
> shadow.  On DAX mappings, value entries are DAX exceptional entries:
> same value bit, different bit layout (flags in the low bits, pfn
> above).  Decoded as a shadow, a DAX entry yields a bogus node id;
> NODE_DATA() for it can be NULL, and lru_gen_test_recent() then
> dereferences it:
> 
>   Oops: general protection fault
>   RIP: 0010:lru_gen_test_recent+0xde/0x300
>   Call Trace:
>    workingset_test_recent
>    filemap_cachestat
>    __x64_sys_cachestat
> 
> Any writable file on a DAX mount triggers this once an mmap write
> fault has populated entries.
> 
> DAX entries track present pages, not evicted folios.  Count them as
> cached and skip the workingset decode, mirroring the dax_mapping()
> split in the invalidation paths in mm/truncate.c.  PMD-order entries
> are counted as one page, as value entries carry no order information.
> 
> This issue was discovered by Tencent CodeBuddy Security.
> Cc: stable@vger.kernel.org
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>

I think that for DAX mappings, cachestat should just return all zeros
because none of the fields really make sense there. There's simply no page
cache for DAX mappings.

								Honza

> ---
>  mm/filemap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a1b2ca5b933c..caad0adde792 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4694,6 +4694,16 @@ static void filemap_cachestat(struct address_space *mapping,
>  			void *shadow = (void *)folio;
>  			bool workingset; /* not used */
>  
> +			/*
> +			 * DAX exceptional entries track present pages, not
> +			 * evicted folios.  They must not be decoded as
> +			 * workingset shadows.
> +			 */
> +			if (dax_mapping(mapping)) {
> +				cs->nr_cache += nr_pages;
> +				goto resched;
> +			}
> +
>  			cs->nr_evicted += nr_pages;
>  
>  #ifdef CONFIG_SWAP /* implies CONFIG_MMU */
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

