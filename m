Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8EFC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AFAD6B0095; Wed, 19 Aug 2026 06:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360A86B0098; Wed, 19 Aug 2026 06:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F746B009B; Wed, 19 Aug 2026 06:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9C5E6B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:38:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F1F5404DF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:38:52 +0000 (UTC)
X-FDA: 85117670904.16.5287DE5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 083BD40004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:38:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="iVD/4Cp5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aTzsLFv3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mgovgj49;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NFjcIplH;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787135930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v++ePnllGB7jQcdK/4IlYL0dLfyVmV3SrOMPLDqxA/Q=;
	b=rcghc8pqdRFTdRI4cDIcXOC+UTdRyepaCZOllgMykldV9bOXGXI8K6MxndbvrDAo01/jq5
	oQwE/f8L3v6GUxINengRqKSGcLkMf0TWVfjo8zdGYD5ttHZHsWsGw32IZwZzM+s1FZiESJ
	SuJBSjpKAx6fgPd+kj29+Z0xFnAl2h8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787135930;
	b=48nl91mggaG0AFu2/st/deleWSOaz0nLjfbGIwrO/lY7jNPVjGHE7PVGuR8jZnTq0CwuT6
	ApESgH04NDKUx4PBGThK15DS/TqkhkAS9sqS0qd/SnLWfwoD9gfyQMlmXHx6C0hEyyoOWs
	oWBt6oessdnH1uJL7g8LddolWPpSSLo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="iVD/4Cp5";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aTzsLFv3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mgovgj49;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NFjcIplH;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 44FB084A92;
	Wed, 19 Aug 2026 10:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787135924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v++ePnllGB7jQcdK/4IlYL0dLfyVmV3SrOMPLDqxA/Q=;
	b=iVD/4Cp5MgtI2q2JRuXglb5i4OnjDtOiZVe6SZ1x+dzgwnTF+WWSW9hVinnLTt/PMIOLTN
	gdSm89HoGec20DHHV8H5eRlguDFN9mSbRIhM/2t1N7Tsotdb5hrCdTJcbr25zfBcj5Kj2U
	x0AlBzMwc6zN5AH7vSJxRa4t4rWtBQs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787135924;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v++ePnllGB7jQcdK/4IlYL0dLfyVmV3SrOMPLDqxA/Q=;
	b=aTzsLFv3IOizPYI3W2zd7k2xaqckTMkDZRGW95KjcDYXdeSYjwTvS4YC8r6IJuup8l8Xmv
	eDSqdYjh8EF9KMCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787135920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v++ePnllGB7jQcdK/4IlYL0dLfyVmV3SrOMPLDqxA/Q=;
	b=Mgovgj49FAimkPaIFmHfqixuZgisNSBeepX6UN6oao0XCucPh7ffnbdT7JVvOHE/QrDNY7
	GWewaWJBl+oHa3iO2v/j9njRRMykIVYTULd+qsHlcrhhTrc8h1M13DdoBkMNiu68c507OU
	alY8PKhtlpTtLhgfTKvNEtplzVOs33Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787135920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v++ePnllGB7jQcdK/4IlYL0dLfyVmV3SrOMPLDqxA/Q=;
	b=NFjcIplHV8Lp3d9H4cKbPfbeV4oejIsUoDs49NZduCozj+A0rzjS5N/nT6bwWBxJoHvfvd
	vX56Hcbe1Vrw2wDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C0B62F81;
	Wed, 19 Aug 2026 10:38:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GoWjDrCHhWrqIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 19 Aug 2026 10:38:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CF662A13B2; Wed, 19 Aug 2026 12:38:35 +0200 (CEST)
Date: Wed, 19 Aug 2026 12:38:35 +0200
From: Jan Kara <jack@suse.cz>
To: Ayhan Aydin <nsd.project.dev@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache
 prefetcher
Message-ID: <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org>
 <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nsd.1787001235.35928@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: n93tf174qosencrk88wqdur7pa1bx7ye
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 083BD40004
X-HE-Tag: 1787135929-847394
X-HE-Meta: U2FsdGVkX1+aiiggUTpjpQPm8fevX1idU909YawrKPBBMXBHA04QcYascaDQ5uO1s81IQHhMwPatiXzfspn0wUKY8U96ayg32QPp9C+y6QwX9jJey0HzcjL8qan5jWhGrwH7I+kuA9FpUCJWH28gko/usvhVSCvOv9X5tzHH4QFSMgCNTfRMtPePWyzVVeG8nJSc1+P396t/QfYQpN6+ef9HhJNXxws9lYLM7vr6yLZxaXismJrVhefBg8XrPbWCzd0Dfr1u0lq2z32zEDeCSMQO2eJhAMyDnotFKSWmExd/JvSrhPM4zdtcK40oE1fhIXabs7z4GKKqCJrryTKDw8lTBr1mXe9bL/MNWtXbcO4gr8HRSYbL0FBEfO27bMKOGJaAgx6WZFPDL7BVvUgs6GOZQyHM5R1E2MY5Pv6Z5X7CO0LrefUQyx1uD9UrHGcfzUtUtTcBiXvkwzz87nsWtdvzYzDDm6Q5c2AzPoGyUmgPUnrE1JH2YZ+DBz4K0a7yVxafp0FEWB4cH4o6HsVTym3PaojYuiiAyyDBZfew11BWzMVakA1XdgSdslKTi4CekUrUdvbitv45sH8EWNwZexYqeGDFyEIZY2S35vLMrlHVv2rAjHck24CJ7lcAygToRqP5EUlSnOffbsWAvL89Ag5UXRESKUKY2P3wboLfzekpmU5nIhMtaSaWJvsDnqJPxw7Gq41KhmNJCYBKBPcTwD3FFhFUYkJUYP4e8xmR6C44BkTAv+Ra+2I62JBJTxstzCQaNCj71ym6CcA98EJnB+a82lEu1TzCLr9kyNkyeIOCDDjiKCK3FN7KkdkE+zwI/gnrZPTfI+t4rI1msz/juOsAo//xWqJs+iODa08/OkYjK2gB5foEnsNUs4bO+U0FPNHn2Namm1/LMc9MzRu43aolHfykP3bTcTXHH3vqBBlzkr4UJmgP2K/tBIbyDAp7jkpaOl/JnPWwdrKDxWG
 YuDGDEHD
 62gkEhBgFfTg5HUtl4QXh7Mbijy+I+L+DgSchCSfO5Mjm3eox76Pjja8awDlvKmuw6+asqotq/IbP+wj2DdYJ8OcMl6D5bK7zC84e8RTiy+S3fnC9KcJxH3rFAZshX7aMMqIPAZoQiY9ZbVOgYLmk5dDfPQm+e662IygiUBW3JkvEtsLB/NlwONQEt7wR2mkbit9tSlpCeJOXeAloc+Oc/wztFnj59q17RXiHcY2SG2tkTiKSInmI9fNcESGG/719P6lpybe19/mq91I17+YxvliviM+iG6XHfGTEV4+nygTIuDgt8WQ1ZurGkUvDPLadBeXLfo41xW7y4GHcQprVcGhOxeG3lnYnVoIqTDwxVGSO2kAMjzxD+CFwI+DDJz+DEJqQntKwv+WxrNlxhXR6VCdAwgxp7yKkyPVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 21:13:55, Ayhan Aydin wrote:
> On Mon, Aug 17, 2026 at 06:22:46PM +0200, Jan Kara wrote:
> > I can see how SQLite table scans could be improved but I'm really surprised
> > by the 64k sequential buffered read. That's basically what the current
> > readahead logic is built for. So how is the sync readahead you trigger
> > better than what generic async readahead does?
> 
> Hi Honza,
> 
> Thanks for the careful question. This is exactly the workload the
> generic readahead was built for, so I was equally surprised at first.
> Let me share what we measured and how we explain it.
> 
> We reran the benchmarks with a strict A/B methodology: interleaved
> ON/OFF passes on the same machine, drop_caches before every pass, and
> the OFF state verified through the module's own counters (no prefetch
> activity during OFF passes).
> 
> Seq 64K buffered read (2 GB file, 3 interleaved passes):
> 
>   OFF: 396, 400, 396 MB/s   (avg 397 MB/s)
>   ON:  483, 507, 508 MB/s   (avg 499 MB/s)  -> +25.7%
> 
> To answer how the sync readahead we trigger can beat generic async
> readahead, we traced the IO requests actually submitted to the device
> (block_rq_issue, filtered to the reader task) in both modes:
> 
>   OFF: 16,385 requests, median size 128 KiB  (100% in the 64 to 128 KiB band)
>   ON:   8,195 requests, median size 256 KiB  (100% above 128 KiB)
> 
> In the OFF case, the generic readahead keeps issuing fixed 128 KiB
> windows (the default read_ahead_kb) for the entire 2 GB run. It never
> grows beyond that. When NSD is enabled, it detects the sequential
> pattern and expands the readahead window to 256 KiB, then delegates
> the actual page insertion to page_cache_sync_readahead(). The kernel
> then issues half the requests, each twice as large, which is what this
> SSD prefers (about +27% throughput here).

Ah, OK, thanks for the details. So the default 128k read_ahead_kb is the
culprit. We know it for a long time this default is too low for modern HW
so most distro's actually tune this to 1m or similar in their default
configurations. If you tune read_ahead_kb to 1m, does the difference for
sequential read go away? And what about SQLite?

> In other words, NSD does not bypass or reimplement the kernel
> machinery. It tunes the ra_state window that the existing readahead
> code then acts upon.

Yes, understood.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

