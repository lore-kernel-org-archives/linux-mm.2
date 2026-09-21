Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351DFC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04616B00A9; Mon, 21 Sep 2026 05:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBAA6B00C7; Mon, 21 Sep 2026 05:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA746B00CF; Mon, 21 Sep 2026 05:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92CF76B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:05:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E147C1205A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:05:43 +0000 (UTC)
X-FDA: 85237186566.12.C81D4B8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 884AF1C0008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:05:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w3sT7iiC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h67AoicV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2u63eRNe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Er2ICYL+;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789981541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=V8juFL0dYz6d8NGLHNvgjSmXY3EH+7UI6udXQgAbk4PXGgg+cvyfQvpVvLjgsa3iR21Xs3
	R8EpQGQqzDzjm2FOvgCpNkjTBwQ768UH/hJqEa/mztvborbv04SEn+WAxkgrn6MFLboxCt
	rObbNcCYrFqiJQLk2dtuQjOV7rRFlNM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w3sT7iiC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h67AoicV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2u63eRNe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Er2ICYL+;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789981542;
	b=etlxs4c1mPQGAFGtW9a9AFezdJM/XBWdB/8KtxLNWqscJavLQju59OKnlL33HCeQtCeQkt
	btitKBW+0XuUFuTdtWFDAl/bF1Fk9T6ZyCQoGG5LZhfO+tt/KfnrNuoMJ8e1OGP3vb2pr3
	wmKcdRgZGYVvrwSEHAMLtjNqqJ7RKr0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11E2E21BEB;
	Mon, 21 Sep 2026 09:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789981536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=w3sT7iiCAazpsuKTVMrFJHv6mMjNCatc59il/499A4jHrA3PPIW+eKsxLzcFS44O3LFvbz
	MA6g5laDghLb8hboOBExIiD0qpqnm2nFq59ClXXbAmBOPs/G2nMNUwcm9uij3xNhl4X/yr
	sT0q15Y4qnX0akqIQ5fy2LSDxnqS6cc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789981536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=h67AoicVyYvGnf/OlXQt8jfuHXBhzkkxk69LRi3LBCeeivUlRSGkR7pEFBJYww3KaIU2w4
	gIKU2icDXWiuevBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789981532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=2u63eRNeWiQn/VmGZAhYh4Tmg57l9C7Sf7ypON88JJI0s9g2LvbXSERb4QDUwYYpYXXSNL
	3/eBO7bvoM+Y07V9NDETMBLqHTm+JNL3EkPB6jaI9yHw4RSDVEmtM/GuHlmTpUxyrnbdEM
	AdmsEiBKFwWCmKaoDKi8Qld1OPqoVYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789981532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qM3WFeKUFpvCjJ8UIMGd6U0TzUGKAEa9PlIpW6zUaJA=;
	b=Er2ICYL+dW3cGUa5xH/JfrS49D9KyhwzeDp9mJKF2x1OnV2ZKye68YV+6aEY2JUcAHXLhG
	dAcpqEgoe+X1/kDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC9291368D;
	Mon, 21 Sep 2026 09:05:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BXzSLVvzsGqsXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 21 Sep 2026 09:05:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6E8DFA13D5; Mon, 21 Sep 2026 11:05:31 +0200 (CEST)
Date: Mon, 21 Sep 2026 11:05:31 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Zhang Yi <yizhang089@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hughd@google.com, 
	baolin.wang@linux.alibaba.com, willy@infradead.org, bfoster@redhat.com, joannelkoong@gmail.com, 
	djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Message-ID: <35me4qswsu2dd3howvfdglh4ge4t5vihkizoutxt2jhiyul6xj@i6kqsnqpvbra>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
 <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
 <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
 <9d931f5e-cb34-4721-9def-7aeeda48700c@gmail.com>
 <453d0054-4f53-452a-9737-cd37d30a7d44@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <453d0054-4f53-452a-9737-cd37d30a7d44@huaweicloud.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 884AF1C0008
X-Stat-Signature: r3erz7d4zhw6o3pee3kapg5hgjwa8z9d
X-Rspam-User: 
X-HE-Tag: 1789981541-547229
X-HE-Meta: U2FsdGVkX19i5PZImCv0eS4FqbuaJb4pawOtJbSeOAqScxI/B+GjWZ4ufd+IEZEQcqNAzJlUWlEPfs1DFOcuCtbgP2GB/QaGlWNjS7gaSlbAKwpbogrg+B/swHQaS6qvGGDI7iMSEQjXrJwKyxkHlfn6ybOM5a8OYa8XeV7kMcsZrPFXzaMnCp8I6rE7hYztomNrGVuGK7dZ6xJRM+hMZdtTwRMtTAybxqektw3ZoHvaMB0CChRvAilN+BEVmqR7pB70E9tqsc2sQfFhicfOKjRGPYFzTOm/aATUIqfy2EP2ASzpGLpVaiv5/TX2/mjmTbgB5TRQnsT+J3juEXgbBKXy+cMTN46LVuHVACwuMc1LOEfSbOXvP3SnV+QlXrriKpIWpDzu/R6YCWFZD6WTGCboSbDiSyhmI1dyhwxYqXqdk4fWlpB+Vk6cJCyOvjjTefG9LjghTNrZJ6ejEuyyfZbe6dpCFSoNV2LiJiqcbD2iec+vVGgqWIXu/L2Ok4ofaO7pnin30BSA5VURTNNeQUMUwkDlbA2i/S0UyNRG/XOqcm7M/wJ3lapmDv/37K4MB4An4ys8lncsUqwrTjFcadDVkN72rSuOCD33ES375liw/ttdIbr7R2AY4NvexQunHLjkZjfj4BosJLokVJeU70niPtwSCBJndXn+OKJXnAeWT0SiMYryAm3WIMNiszuV6stiTczTN/HFiRkV8VXPGS9UcRee08ftVkVussv/30Lv0nqVbL3YAnM1s7RSIG+YWlu6m6XHCFiV9dWAIGmhUp/sW+TfCsFPdStAd3QSRCcT/tm+4yFmO3R9AJLNpPFRL5tHpsg0smZWI9sNKYdO1CfWItir9+1P9jOYwdzXdlvoIoi1A1ew9/dmedkCVo56iJSY0yVH4fsF0it9fBvBBodZKi/0heR66eSKAbqF3E0elpgqLq+05/Bb6lm+7NDgxzEubSQ2eX1AFc8HbU1
 u4UJtogN
 NjzA9GvtgeAaabPuTUCgr7IyR02fBvPzyfGlpVnKWASLErh6/yEpOXWJCjfKtPY9ovAdYVHQEb9rM1OypIVB0PUMfxcSQdmCwf+AZK/jbQSUkE5a2o5TUWCwEQs0A+FRLrtaIqlCr+RxIgT3mdvOEaxmKleIsQxCpy+NdiUL4LA+iQ2QqkopHHwVi6exF7HsVUWAfikGV9AJGZssx/8TuQBHmCmhuHPPDS+ff5baKEsRyV/9uw2L35Yovp5oI/UZO2XrC420YHYX0aeIthZ6oljpwphmWxvfOASukw1jagsz5gNrunnKyueM7ciUJLIUwNCe9NYOlMIHXht5xvQn4AWzvEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 17-09-26 20:03:57, Zhang Yi wrote:
> Sorry, the previous diff format was incorrect, reposting it.
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 23c90f00b530..b5e5bdf5f9ef 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -279,51 +279,46 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  			*pstart = round_up(pos + offset,
>  					   min_nrbytes) >> PAGE_SHIFT;
> 
> -		if (offset + length == size) {
> -			end = aligned_end;
> +		end = aligned_end;
> +		if (offset + length == size)
>  			goto out;
> -		}
> -
> -		split_at2 = folio_page(folio,
> -				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
> -		folio2 = page_folio(split_at2);
> 
>  		/*
> -		 * folio2 may become stale due to a concurrent split or
> -		 * freeing, so validate it before and after taking its lock.
> -		 * If it fails, we can't get an accurate end position and fall
> -		 * back to folio->index, which may leave sub-folios split off
> -		 * at the offset edge in the page cache this round.
> +		 * After the first split at the start edge, the folio at the
> +		 * end edge may be freed and reused concurrently.
> +		 * __filemap_get_folio() looks up the straddler at
> +		 * aligned_end and returns it locked and ref'd with the
> +		 * mapping validated.
>  		 */
> -		end = folio->index;
> -		if (!folio_try_get(folio2))
> +		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
> +					     FGP_LOCK | FGP_NOWAIT, 0);
> +		if (IS_ERR(folio2)) {
> +			/*
> +			 * No sub-folio straddles the boundary when aligned_end
> +			 * is empty so discarding up to it is safe.  Otherwise
> +			 * the straddler is locked by someone else and we
> +			 * cannot obtain a reliable end position, so we fall
> +			 * back to folio->index.  This is safe but may leave
> +			 * pages split off at the offset edge lingering in the
> +			 * page cache this round.
> +			 */
> +			if (PTR_ERR(folio2) != -ENOENT)
> +				end = folio->index;
>  			goto out;
> -
> -		if (folio2->mapping != folio->mapping ||
> -		    !folio_test_large(folio2))
> -			goto out_put;
> -
> -		if (!folio_trylock(folio2))
> -			goto out_put;
> -
> -		if (page_folio(split_at2) != folio2) {
> -			folio_unlock(folio2);
> -			goto out_put;
> -		}
> -		if (!folio_test_large(folio2)) {
> -			end = aligned_end;
> -			folio_unlock(folio2);
> -			goto out_put;
>  		}
> 
> -		/* Split failed: back off to the head of the straddler */
> +		/* Already at the minimum order, nothing to split */
> +		if (folio_order(folio2) == min_order)
> +			goto out_put;
> +
> +		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
> +
> +		/* Split failed, keep the straddler intact */
>  		if (folio_split_or_unmap(folio2, split_at2, min_order))
>  			end = folio2->index;
> -		else
> -			end = aligned_end;
> 
> -		folio_unlock(folio2);
>  out_put:
> +		folio_unlock(folio2);
>  		folio_put(folio2);
>  out:
>  		if (pend)

FWIW this looks much more understandable to me. And since this is a
preexisting issue I agree this should be a separate patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

