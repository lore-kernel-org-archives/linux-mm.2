Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92EE3CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0606B008A; Tue, 12 May 2026 09:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76DA6B008C; Tue, 12 May 2026 09:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65EF6B0092; Tue, 12 May 2026 09:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A53AC6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:58:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69F141404CB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:58:34 +0000 (UTC)
X-FDA: 84758922948.10.90767CB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id D194CC0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:58:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iU40lfBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=59RRpz5u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iU40lfBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=59RRpz5u;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/WMKLvXTakOwtcQCPmwP1f7LuJLeIEf0/ngyLHcaDo=;
	b=CsU5MpI3MLt7pxyfBl+osDdZodFiSIoGL7fgPGPDHADB2Z3JH+dPXf9z4rhx05uvFgsQCA
	UgNHdXskINSo1wPTa7C3aS0MuD82sr9coP7R+aYyfXfwquTCiET9MvKEAWETL4Vubl2e+X
	CQ/vbZ5G6fxtvq+YA4FPMZhou6y8s1M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iU40lfBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=59RRpz5u;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iU40lfBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=59RRpz5u;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594312; a=rsa-sha256;
	cv=none;
	b=QQpAHsBRoMwJt3u4q/7/kdpC7EQ3BuW55t+hsUXye9Uw75g/kU4JnQFWN4H9UyGYPYaNaU
	vaZLgGRYM+bIgNRNsYEjodMTo9jM6t4kO4W0egTuSnb8LahIwybwcyF6NStOLAtQUMLXmj
	o373EijGBA7srRmgqJ2U+DWi24DjZ4E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 306EF6A92B;
	Tue, 12 May 2026 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778594310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/WMKLvXTakOwtcQCPmwP1f7LuJLeIEf0/ngyLHcaDo=;
	b=iU40lfBcKYFLIF2OHmGSUAfvpl4nfAgf194chhYws9yDEb3DxOnb3xiRlbS7bQTusUdU2E
	ni01ZeqaJ+Y9zyZTRYP9ARLN+TshLHI2Jdx9WCJNsMCuxCion8XMzzt/YlNDCH9rRP3ySj
	xCzWegLpvRqZVVhL4JmfQelsXqMl4po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778594310;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/WMKLvXTakOwtcQCPmwP1f7LuJLeIEf0/ngyLHcaDo=;
	b=59RRpz5uKRSwZuk3tmE0LVQS/rHnOlt1W7AHo63MzMrHcNg2Q+5Nbb5dRzHoGbOS/RA6d5
	XpjQh9LYr1JSaJBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778594310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/WMKLvXTakOwtcQCPmwP1f7LuJLeIEf0/ngyLHcaDo=;
	b=iU40lfBcKYFLIF2OHmGSUAfvpl4nfAgf194chhYws9yDEb3DxOnb3xiRlbS7bQTusUdU2E
	ni01ZeqaJ+Y9zyZTRYP9ARLN+TshLHI2Jdx9WCJNsMCuxCion8XMzzt/YlNDCH9rRP3ySj
	xCzWegLpvRqZVVhL4JmfQelsXqMl4po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778594310;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/WMKLvXTakOwtcQCPmwP1f7LuJLeIEf0/ngyLHcaDo=;
	b=59RRpz5uKRSwZuk3tmE0LVQS/rHnOlt1W7AHo63MzMrHcNg2Q+5Nbb5dRzHoGbOS/RA6d5
	XpjQh9LYr1JSaJBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23D7E593A9;
	Tue, 12 May 2026 13:58:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cGAKCAYyA2q7cgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 13:58:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3EACA07B5; Tue, 12 May 2026 15:58:21 +0200 (CEST)
Date: Tue, 12 May 2026 15:58:21 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v7 1/3] mm: preserve PG_dropbehind flag during folio split
Message-ID: <2lqxu3m6ueiiaqykqwgujxzddq7blcn2zmtntv742mvae3wqtd@ntr4mnzm6vic>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-1-2848ddce8090@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-dontcache-v7-1-2848ddce8090@kernel.org>
X-Stat-Signature: wi5no49u9mgnztza568rye87ywzyyrfn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D194CC0002
X-Rspam-User: 
X-HE-Tag: 1778594311-633994
X-HE-Meta: U2FsdGVkX19G4LxHRIst1+yfu81VvzVdIrH+eyRRxl8+ZctR07wKlVX1ioUnQ65agz4Vxwp7mliqtoL7Y4/LLcvrxASukUhJrD8x2XfpZPXKMCtbh/xSZZlTJEClc2EK01iiwt2bO8ue48+fEDPVA42suD18PQigsoMW53jORhm55wd5mYjcCP5qqhDDOZH6TLe1vAzgZz5Ct4M4IWUPcs0JOamkEk1aogA+akLWcFj+6cWn/y7ddQMEh9Y5eI3bu1yUPIbufF2CM6IQgvgAU+UqLxw/nAlHwRNQUkBNC82mDWlMAxyvSssg8buUUuOSJp6nXx7h3u1T/7kbrXdEVe+Ar6Pa1xqguX/ACSNrklzVxhtDnTLKrUC8bWxTySVdOQg4CtgoxnwPf+3Ls4PiT6+139pCmlGPXiU3li7khjjwRunNR6BDErYDZcdJPHesjV9BiJHH1h1qYNBqy8UDNevtCPT8B0sSOjTysrUzj5YyaGR+NGsQ23PxCm60KvRjRAnalXRefJFw8zr2lxgliE83RI+DTNTtJ1srhwWq/H0bxrVapihtkKUr6FzIYvTKIuqkJlEPpLSqHrpBK1YNFLbzKy4kQZHxqoAjuRmCD2w+MgPvWiJf/eqPoqdHEedGNLGIm4QU2908LmtlUgu/uX3lD6UWehM7I/FjuizL3Xzw3+E1X0KcVZS/ehfsgCS9gTNdA6+MrgTp1p5uk5XCOm5NfLzfNtW3EN5EQZdK16VEpuJP808T7rlSl2CK5XdcdxXJEzLgNWXAjdQyRxdLx9PinJ58ZINB/F4yhsjJ8zDIQBuqDAA0n8z0m4PbMa4bO04E8Oa1StjZ8l2jjsN314Qfp9EuQGNv9/8xoMu2xwy6WEvN81n+WQ099CU4WjKPAecXAygwBxGkIdCbgSChJoMrH0Lw7VRzooOvufgyErO0OczmaCZTxQN1M86VlhMJRP3JbryiQWSK3zLGSSE
 SYbyNA2+
 coaEw05T0S5xPPBwNQ+7q5nyhV/mddAfjt+5LboR6T8yfnDtC1ZVwXhm5Jp4g6OCXqEBRjfASUEfzLOMB2SUj1hqWreJ6QkA5RBju3i9S5CouVsI/SddVKbzI2qsxY7vm4XH1mZ6HXKnVsY9efM1KeBF8J84mjZJ5Tph/p9oSeCl2/RaPsV9hpUEoUti+B/+HROuCcPOp8VIVtk3SSc/5/0TqaITw96DHyImY6igSNyJA2xGc/ZCqxCb9bY4ikZZTOdjcQzuPkj8tEOZUWx82axWwt8ZC5p0qiIPZs05HjMIzgSS8Q8q1W7m42wB8XHkKXKJq/enF5P+fehjC4XFOPg5aLAevg28U1BdOavEXqwqJD9ByMdvEyIIhX//xxIqOcG480dVgK+7g4bXb7VX08iYRBp+H/jf6IORZNUHTKYEsQtxyM1hQWnuabxxUi/no0OF5aZYnt2REoNsfislfThGFU8Jr6As8zReO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 07:58:27, Jeff Layton wrote:
> __split_folio_to_order() copies page flags from the original folio to
> newly created sub-folios using an explicit allowlist, but PG_dropbehind
> is not included. When a large folio with PG_dropbehind set is split,
> only the head sub-folio retains the flag; all tail sub-folios silently
> lose it and will not be reclaimed eagerly after writeback completes.
> 
> Add PG_dropbehind to the flag copy mask so that the drop-behind hint
> is preserved across folio splits.
> 
> Fixes: a323281cdfec ("mm: add PG_dropbehind folio flag")
> Assisted-by: Claude:claude-opus-4-6
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

I'm not really very knowledgeable in this code but the change looks good to
me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/huge_memory.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..e01917b14d1a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3642,6 +3642,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  				 (1L << PG_arch_3) |
>  #endif
>  				 (1L << PG_dirty) |
> +				 (1L << PG_dropbehind) |
>  				 LRU_GEN_MASK | LRU_REFS_MASK));
>  
>  		if (handle_hwpoison &&
> 
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

