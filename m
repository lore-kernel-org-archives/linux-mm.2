Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EFC606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=uGIYsDTD;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=A8EdLJV0;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Kn3yERPG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ucOfUodT
Received: by kanga.kvack.org (Postfix)
	id 209AB6B05B3; Thu,  5 Nov 2026 10:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC196B05B5; Thu,  5 Nov 2026 10:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083FF6B05B6; Thu,  5 Nov 2026 10:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C61806B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:38:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52848C0A61
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:38:02 +0000 (UTC)
X-FDA: 85401471204.16.9849A05
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3472C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:37:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uGIYsDTD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A8EdLJV0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Kn3yERPG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ucOfUodT;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rn+wFvbgmGD2mi6hZAgXI17+uY+nPNgmOpv7W0MTn8k=;
	b=R/HRouPzP6hsB/9ctdy9FZM1NLrSfYfO+dUu7EzfaRzyZruy+axRJgZP7dRa8EQOZQbehN
	Qq40409AVWHb60pCP74a7rC436YqCFdgbysKHTSdmBlrYCR0JlxNzDX1Y2VWRdklO3YKUB
	5ozf4hTw60bqobo6lapvJRvirUtKwCc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893080;
	b=iKUsQ2qY+JS4xVIeoxZiQ7Y990SUHPbd9IUpEWMTx/7dWCpnt+eXTfriAEU9r5woJ2AP1g
	CPxag6pQN5BG2u//JI62l8pJzwGoDOqqIdNLM0z2QmHWpOyL7r53mgJQH4yn1deYx6I8gW
	mP1a0LlppyS0vEyLMTqI8VP2t8lhn34=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uGIYsDTD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A8EdLJV0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Kn3yERPG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ucOfUodT;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A30721F99;
	Thu,  5 Nov 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793893078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rn+wFvbgmGD2mi6hZAgXI17+uY+nPNgmOpv7W0MTn8k=;
	b=uGIYsDTDJwSMXQ57mFgsz9hPxEJcLbCO4ZhjAoZW62cq79kzSLivDRrVKWs35c8RI9QeI8
	Vm+uRJg0Ut8bNXp6fTSWObSxWPQI1T3SwLdk8F7qtZu5Km2LbrPw62UOmcRYm9tlRKcBmI
	G4Nv0rQFicHkzdTbZ07OhdaDm5HPldM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793893078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rn+wFvbgmGD2mi6hZAgXI17+uY+nPNgmOpv7W0MTn8k=;
	b=A8EdLJV0Yrafz/6PhZ4oua84nhZbqniplcyqOxD+ihbl7DN87/znLkq/VPyk62IApoehHV
	PVdkHfZG4xA8n/CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793893077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rn+wFvbgmGD2mi6hZAgXI17+uY+nPNgmOpv7W0MTn8k=;
	b=Kn3yERPG1TCwzY+U7d6EGCGuUK3/U7M9d+rmSg13ESY+3Nm/6uYeB1tDATs+2Di6O8fGk1
	0IxMEOvKicr6gMWT+o2Js0rMSSNrGA6YMZ6QTVSejPQJEODdN/K736SUgJILsJW0FbsQyL
	q2iG/TX+YpjkNr84nIMTp30QENYT85A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793893077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rn+wFvbgmGD2mi6hZAgXI17+uY+nPNgmOpv7W0MTn8k=;
	b=ucOfUodTRPKzkbGc/r7LJnjonnyq4BR9/Ll/K73j5RipUtd5vajMhqU+qu8j1gm2APnd/m
	JQXyIxTX1PLElWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2F1F134F4;
	Thu,  5 Nov 2026 15:37:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KMWCL9Si7GrTcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 15:37:56 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 63758B747; Thu, 05 Nov 2026 16:37:48 +0100 (CET)
Date: Thu, 5 Nov 2026 16:37:48 +0100
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/readahead: align the async window in
 page_cache_ra_order()
Message-ID: <cs7sng2kwgcdbuxfk56sbc3x4ku6jtxk6nzwhaaqbjvmi5fqd6@nac6orsarmta>
References: <20261103-mm-readahead-async-align-v2-1-c3c304cbca59@samsung.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lgcir5uumdsu3tbv"
Content-Disposition: inline
In-Reply-To: <20261103-mm-readahead-async-align-v2-1-c3c304cbca59@samsung.com>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: yos55mgbxnjq9nzhetxhmmp9x4ufm9je
X-Rspamd-Queue-Id: C3472C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793893079-99092
X-HE-Meta: U2FsdGVkX1+5fZR+s+k/pvNnGRYMiDSC9SBiqA8NSYU2MSLsfcmcgj5zczphvZq/EuCQo3W4kfUO0H1OFiK41sYUqgOvBAZNXbyOXDSea5gEs0BCFJ6f0yhJIkVgc28rUD4QXTLubZaGRe3HmDNZX75sXCvCoPFax2uHEZePSmdW8jdxx3j080q57+btyLIyCHoVe+jkRJdPcFpKeGMaRLAqAQ69FSobrxAE0HYhpT3yHDN+LQQ4eSMmRi8O+IhYgT9E0xcC/AZlP4WOrFKLL8OAX0MRRvwCKHyCc8+A/QUhw/BYF07nSGJeNKTKDmAx0s2/Pue0it7ePSa9i0DTKnZ+mCeRNlX6FcuqlnJNYgtEGtEaB0jxX8Jso1Aq7kVVeP2pjUf3jMgNJQgrJV+ZHd1sHZ/BU6CCq3B1QqAaXEDZbtNhB51THYS8UqPOEeq0ZwAOLeBofI1tAqMqbXyvsimzoj1Zu9LYvxCtcQuZKKrHtLD2oJFzBZG4Q4fhVVD5y6yR3aJ9pYIHLn0s8MmlLjvRQEQwvql7CnuYFeg5mH8+TwJLnFAAGrZZN5ReDMAhrrldGdgEodnsHWTZXDeq8F3kr4kdIJpQnaDsca4z2wVW/HIeIHaC0idTfxRPYc5zFZTQ6OtsTY5dHJBZnOKODzxcpo/zE89mWvtRwzoPn6ahHvdTHtg1yrlmuHm97lwOIVF9LYPFALgeLVRg9YTegHXTd4bXDQ8ibtMgEZy9RTllnlnx7Fff/Qstj1BhGW9tHqfNr07+cwoRxcZj34cJ6LHJIRWCcdPazeJbLlj3oUXc5FwbpUgdlzYp+Ffy1f0pFE6YRlq+uvX1mOOu8XGJ/wvhnr6VeDpqUwEEmyCA5IDfe7gGQW4euzZ8TRRf5B+a/XJsf109d8IG5k/qNhDO2d5VHwsKHLu+07h2xvp90qo5qumH6qWm+/wHGa0SqRxtLfUjgk6Ck7c4S+c3+IO
 E+4l4D2y
 7pVx5uvHxesXsByzK2LkYlDqKfPGC+KCpIGMzoCg+D4h/hE6+rUdhanvZtYW/uTXSa1YoPJthl8dWhg3oFxcb6fQbTxWeW7ONnBcw+QLetOPKLDRSKkYVk/GCwcCLAiHdRt2mBWO1dCrreN5tcNYNm+S/Dv/EPMKK6/uR5g/T9uLS7WSxKHpdloITrbARvySmtjnnxsH3TgdPP00a36iuA38BV9PzFE0ZN/mIBUVsvFxgpO1eny5GophK9Y5RHTA58QPO3TIgXgoXMF4zakY+dP6kV4z+7xVSLeJHUeuj53aESarF8o/lj/QFHbQT2Tl479rrqrRdLLxmaoYoVZuycWRR1MAzq0PYRhTBXmr2jXImhqV5hmg+bjWKK1lUx8jKRFRRdR4X+AN9etda+XWn9gFZo1nXMjKju9K5+TQ4GCtgNxF0/fRYj22DfuoQTA8vM63gjNUN4pRYho8wb31ebhciSeJEKU+F+cU7yK9/IvsVjErMEJIDVhc69/ZHrEpejG7LLFYtc9DHUPREdOPYMcxTbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--lgcir5uumdsu3tbv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 03-11-26 13:19:26, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> page_cache_async_ra() rounds each window end down to a multiple of
> 1 << ra->order pages before page_cache_ra_order() clamps the folio
> order. A window starting just below a boundary shrinks to a few pages.
> With read_ahead_kb=128 and max_sectors_kb=512, 1 MiB reads after a
> 4 KiB read at offset 0 hit this on one window in three. On a 512 MiB
> XFS file over QEMU NVMe (cold cache), that takes 0.251 s, 3329 device
> reads, and 9721 folios (none of order 7).
> 
> Pass a flag in struct readahead_control and align the window end in
> page_cache_ra_order(), stepping the order down to keep at least half of
> the window. The read then takes 0.200 s, 1031 device reads, and 1039
> folios (1021 of order 7).
> 
> Fixes: 18ebe55a9236 ("mm/readahead: terminate async readahead on natural boundary")
> Suggested-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/747jhqta3plrrx3bfikceoltsewshdpejdei2qjpn3onnvtu3p@cptmb4phbn54
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
...

> diff --git a/mm/readahead.c b/mm/readahead.c
> index 6e55632902..959c9a7b48 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -498,6 +498,35 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  		goto fallback;
>  	}
>  
> +	new_order = min(mapping_max_folio_order(mapping), new_order);
> +	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
> +	new_order = max(new_order, min_order);
> +
> +	/*
> +	 * The caller allows the window to shrink so that it ends on a folio
> +	 * boundary, rather than ending in small folios. Keep at least half of
> +	 * the window: one that starts just below a boundary would otherwise
> +	 * shrink to a few pages. Use a smaller order instead.
> +	 */
> +	if (ractl->_align_end) {
> +		pgoff_t end = start + ra->size;
> +
> +		while (new_order > min_order) {
> +			pgoff_t aligned_end = round_down(end, 1UL << new_order);
> +
> +			if (aligned_end <= start)
> +				break;
> +			if (2 * (aligned_end - start) >= ra->size) {
> +				ra->size = aligned_end - start;
> +				ra->async_size = ra->size;
> +				new_order = min_t(unsigned int, new_order,
> +						  ilog2(ra->size));
> +				break;
> +			}
> +			new_order--;
> +		}
> +	}

Um, this isn't quite what I meant because this is still quite ad hoc.
Rather something like attached change (plus the _align_end bits from this
patch). It will also end up guaranteeing at least half of the original
window is read but it is also implicitly taking into account alignment of
the starting offset and other possible factors.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--lgcir5uumdsu3tbv
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-readahead-Align-window-end-in-pagecache_ra_order.patch"

From 51aaef0da6965d13cfa44a7ddf8e0e846af5585f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 5 Nov 2026 16:31:59 +0100
Subject: [PATCH] readahead: Align window end in pagecache_ra_order()

---
 mm/readahead.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287..62e204eb3e7c 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -490,7 +490,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
-	unsigned int new_order = ra->order;
+	unsigned int new_order = ra->order, last_order = 0;
 
 	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
@@ -532,10 +532,22 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		/* Don't allocate pages past EOF */
 		while (order > min_order && index + (1UL << order) - 1 > limit)
 			order--;
+		/*
+		 * If we are allowed to align the end of readahead window, stop
+		 * the readahead as soon as we have to reduce folio order due
+		 * to it exceeding the RA window.
+		 */
+		if (ractl->_align_end && order < last_order) {
+			ra->size = index - start;
+			if (ra->async_size > ra->size)
+				ra->async_size = ra->size;
+			break;
+		}
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
 		index += 1UL << order;
+		last_order = order;
 	}
 
 	read_pages(ractl);
-- 
2.53.0


--lgcir5uumdsu3tbv--

