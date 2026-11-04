Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C8D606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fy2ko+/0;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kLN+Zm+G;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fy2ko+/0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=kLN+Zm+G
Received: by kanga.kvack.org (Postfix)
	id 35A2A6B05B1; Wed,  4 Nov 2026 06:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304146B05B2; Wed,  4 Nov 2026 06:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2586B05B3; Wed,  4 Nov 2026 06:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0D686B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:57:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 494FC1606E1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:57:43 +0000 (UTC)
X-FDA: 85397287206.04.2A7ADA5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 10B2940007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:57:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fy2ko+/0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kLN+Zm+G;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fy2ko+/0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kLN+Zm+G;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793793461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHluHhAO0xC/KF78ZIKkidib22uHHwF0MmD/UX1TZas=;
	b=KeaUvt9M5olB7Mu21Rwhuv77w9fw5xLdS6VQ7Kl3IUEX0i61HpR6nCnVX9ecRVl21TF1kB
	THXyiEouzEThEZ4MZX4FvaoMVJOO8st6+Q03Y2iH4/X9WaGPgKWYroZ9Szr0opySTr4C5K
	G7lsxdezUZ33J7hLVPzjQrYhS9WxQWM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793793461;
	b=tVPh8PORS0VeX3yPd+Ubl3mu8TpuEoLFDRXVqxXfyzLuj6JQF3A9Wif8KM+nzLsLWZ9FSy
	yHWE2CJdz8o9hV09TdnwH0i/OfkRMoxIcRAt4UWDkXzCUJrYh3dNh5B6xp30fBck3VICGC
	jRr89tIVd9dvS/yNxJLq6JDAuQHyTIU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fy2ko+/0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kLN+Zm+G;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fy2ko+/0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kLN+Zm+G;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B1131F7B0;
	Wed,  4 Nov 2026 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793793459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rHluHhAO0xC/KF78ZIKkidib22uHHwF0MmD/UX1TZas=;
	b=fy2ko+/0ozIyB3q5s1uUqEpVwnWUMej8/uCnv72PKBECMQziYobfMfkgZJnziOgYNg3dM8
	A5HDIT7ZR7CHYeiJWOdEq5LqDc0xqfsu3uokHefPpQ+Tl1Uf5NhrUM+cMvxTTSzcgs8y1L
	HXGQGTUYpkj3RmyBhEazvvf3rhDnhZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793793459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rHluHhAO0xC/KF78ZIKkidib22uHHwF0MmD/UX1TZas=;
	b=kLN+Zm+Gxs3JqSjmXH3tgisagn/MTlDuir+JU00r6OsUmaTBNDsC6Xg0AFvQMX/ZKxrkQT
	qR27tUOPLZQTaQDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793793459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rHluHhAO0xC/KF78ZIKkidib22uHHwF0MmD/UX1TZas=;
	b=fy2ko+/0ozIyB3q5s1uUqEpVwnWUMej8/uCnv72PKBECMQziYobfMfkgZJnziOgYNg3dM8
	A5HDIT7ZR7CHYeiJWOdEq5LqDc0xqfsu3uokHefPpQ+Tl1Uf5NhrUM+cMvxTTSzcgs8y1L
	HXGQGTUYpkj3RmyBhEazvvf3rhDnhZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793793459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rHluHhAO0xC/KF78ZIKkidib22uHHwF0MmD/UX1TZas=;
	b=kLN+Zm+Gxs3JqSjmXH3tgisagn/MTlDuir+JU00r6OsUmaTBNDsC6Xg0AFvQMX/ZKxrkQT
	qR27tUOPLZQTaQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F47E134F0;
	Wed,  4 Nov 2026 11:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S2RxB7Md62olTwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 11:57:39 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C285BB336; Wed, 04 Nov 2026 12:57:38 +0100 (CET)
Date: Wed, 4 Nov 2026 12:57:38 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	lczerner@redhat.com, tytso@mit.edu, hughd@google.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: skip empty finite ranges in truncate_pagecache_range
Message-ID: <l53ckhx3h6jyt7bnosdycttcesuyt2jxvspnhs3gdftrxuj67y@djj4esw62ht7>
References: <20261027211505.22044-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027211505.22044-1-dennylin0707@gmail.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10B2940007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s1sjrrnnipijukjr5ir7ugph9kmdetkr
X-Rspam-User: 
X-HE-Tag: 1793793460-35810
X-HE-Meta: U2FsdGVkX1+qJluKQ1sHM+ihbazU3KEfswzVrbE+ydVZ0zOaAuRHqJ5peJ7DgnliKvHe0w9YPnhjmzBe/kcgc3VqHwC83HUwetuzQliMHRjL38pR8VPxTXeJk8qkyW1nyCGz9w4vV+XoTfeQ69AM/ekIaNb6K10gDUbZ9P8NNiP1Wj5tBmfSGvnooEexUi1jOhCtg6cZ/Rs1CEsTTesl0SUaUIUM9gMpQko+GQKmAO/hvi9pJtdDtA15stzmeAITRNtyhKrh6M2L2XQJFcYdx8J5D5RK3QtmZ4GhMgSxi/aXtNmg5UN0+Pw5epuJGtS/N/dSksnkvkAxlb36/fIb0SqJDhWArvnNP5vM0gvyv1zssWvDvmHIRxJ84kzIiem3xzmK+wVjq+BYJyGnexVRSaDz4M8qkK61ktarEO0LSlfpPgdBdUsD8UZhj6xq+ueiuLJelb6Itfb204MrOrkW1hqAtJNFBhHNkvjlsOaZN9py1hrAwdxC9XvvoClSbeyvvixpWhdfoIgWXpKTo1ol4W4/6Dt7MNurnpwFXokWfuamNhp82ejlDzNXCDNniWzVbg4cs0l0s3+E5/WQGGY+atNp9bBxn1vYWN9rajX/3ZTlYiHKBy+dJwsA9MIRB3oEsxkTwFExcRSdfzoTwjmanDtl4qOf4FWl2Lcr8o8b9pqzQPTqkd15+NghbVQ4sRgRFjeSG2E2CZL1ppUXpcIMGf/0tkS6qHyP2K4HqFRPa6kOEzpZ9VKlJPEgyn+EivcopLtN1u9SAd5edU721B/JY/tBBOTUozqcjjU7w6QZ7qJDrblcoUfj+0PrFr8GZhxUw/IvZhDzIqeRcXiKigFB27LcjzCMQRcP/t72OnGJakgCo3E2ugSAlGOxs0qx+myNjLx5DKVJG4KZCyNfR048v1XHYmxVJGCt3aJgY2GWsW5cv2aj6R7iBkYjYqgriuFoVOnx8Cev0kNy1UlQhft
 4UgyxCWn
 TF9OsO920LmeQVnrac0Rrgy5GEeq+HGhmWF0EjO/iJcnANlHFoYG+g4Jq8s8CsHZtB1m14XiBKLHPmyB3NYPFt27m4MjsR0AQwOcpehc4SXGwqtLlWNlkHMmtVXJDlZu6mw/o1ogPGojNSdVY2fpZrXtMH29o7qezopjHhskIdKHvarir87y3MEehR8nZGFFr/ELUXVdHSSorSfirNOijg8JoU9tVMRAMGtuYb2fhRh82JzE2vPhNEKAy7Do5iG85UzlNRO/o+3aeqni3WUppd9taZj5f2Y0pJhKedl0Zpd7i5CP4G+ty0NXpQW6jw29fi3IAeWX1e2it01InBrWy02ZCfSqg//au5s/kxoBkzA6eE8DPa9jJVzby6qRUflKJdDpNawFue7eQupRfucP6HDgL1bh1svczz21T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 27-10-26 21:15:05, Hungyu Lin wrote:
> For a finite range ending before the first page boundary,
> truncate_pagecache_range() calculates unmap_end as -1. The unsigned
> comparison then treats the empty full-page interval as nonempty.
> 
> For example, lstart == 0 and lend == 0 cause unmap_mapping_range() to be
> called with a zero length, meaning unmap to EOF. Punching one byte at
> offset zero in a mapped FUSE file can therefore remove mappings outside
> the hole, causing unnecessary page-table work and subsequent faults.
> 
> Compare the exclusive rounded end against the rounded start, while
> explicitly preserving lend == -1 as the EOF sentinel. Perform the
> addition after converting to u64 so the largest inclusive end does not
> introduce a signed overflow in the comparison.
> 
> Fixes: 5a7203947a1d ("mm: teach truncate_inode_pages_range() to handle non page aligned ranges")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Hum, so I agree about the problem but the rounding logic in
truncate_pagecache_range() has more flaws AFAICS. For example if lend ==
LLONG_MAX, then unmap_end with overflow to huge negative value. So maybe
let's fix it all at once. Maybe something like:

	if (lend == -1 || lend == LLONG_MAX)
		unmap_end = LLONG_MAX;
	else if (lend < PAGE_SIZE - 1)
		unmap_end = 0;
	else
		unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;

And then you can leave the condition checking whether to call
unmap_mapping_range() untouched.

								Honza

> ---
>  mm/truncate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..43c6cf99027f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -919,7 +919,7 @@ void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
>  	 * once (before truncating pagecache), and without "even_cows" flag:
>  	 * hole-punching should not remove private COWed pages from the hole.
>  	 */
> -	if ((u64)unmap_end > (u64)unmap_start)
> +	if (lend == -1 || (u64)unmap_end + 1 > (u64)unmap_start)
>  		unmap_mapping_range(mapping, unmap_start,
>  				    1 + unmap_end - unmap_start, 0);
>  	truncate_inode_pages_range(mapping, lstart, lend);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

