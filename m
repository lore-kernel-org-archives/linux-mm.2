Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FC1606A335
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2TIJK6kS;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mNR5ZW0F;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=OxTEdmT4;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oSENy4AI
Received: by kanga.kvack.org (Postfix)
	id 97BF36B0733; Tue, 27 Oct 2026 09:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FBD6B0735; Tue, 27 Oct 2026 09:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865476B0736; Tue, 27 Oct 2026 09:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0ED6B0733
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:05:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD74B809D4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:11 +0000 (UTC)
X-FDA: 85368426822.15.2859E66
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id A8CAE100010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2TIJK6kS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mNR5ZW0F;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OxTEdmT4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oSENy4AI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxlXm+JcRuAJZIHAVM0FX8ZHdQ6f/pCfzF5ht6AP94U=;
	b=0wQmJ0y3TBref+SaRg32taj31+aqDpw38w2qZRWT31b4xTmBVlRVnLITa8jo0PNrIBUWQF
	2tKtoa3Vg1hE33quDNpruK2XpdW7wlWT96vJOVoQW+p1vIWuK1Tx9WW0tzGpFnHbbu/L6O
	L3Ghdpa8xO0ju7BlHdGIqk+XGCIYeaU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2TIJK6kS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mNR5ZW0F;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OxTEdmT4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oSENy4AI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106309;
	b=uMgCYagpBNUVsEc5qIcVJlGjFT3yi3Her0TfWmUpCTkWUQyErdJvlTj1lq4yDg8EwTeBS2
	skmICM8jJKDGYe8mvHeOofzlWuqnYCJYAbSb8FLzdOyK3DRhHW8ZTb42//svkuTFO9Xmjz
	qaey6UxZwteakxoo0ita1pGHlWzE9y8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1506D21F1B;
	Tue, 27 Oct 2026 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793106308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vxlXm+JcRuAJZIHAVM0FX8ZHdQ6f/pCfzF5ht6AP94U=;
	b=2TIJK6kSYwtJxtHRZ39rZVVNY0AR31nfI1PuejIxbZeiZiqFy+GRSKfHWknogiqkslYvcu
	nwjCSAKVQcOn/7DX1/dxfBbtKy9vQnW/YzoXcofN0xgCHg/yDNad/G/G0U4jOy8mjcgntl
	xbeHVhv1LjkWY428Umn/cCGhSRR56Fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793106308;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vxlXm+JcRuAJZIHAVM0FX8ZHdQ6f/pCfzF5ht6AP94U=;
	b=mNR5ZW0FeJZXkqsRpkN0o/2uKcITi/xifXB3YJyDN4d/WNvxHj/bsNGHDAc3RbUNTyrpFL
	KGoUlPgd2434IcBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793106307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vxlXm+JcRuAJZIHAVM0FX8ZHdQ6f/pCfzF5ht6AP94U=;
	b=OxTEdmT4nSTnt7CdzJcgf3rZM4SwpU44Udr1Rq3aynEJaCDdIxhebT3D7yyqOpiuzV6Voz
	zHgvtKJiGBt+7yUibaJ9BivFj7e+fiSnIxxdGgCiLS0G7w1rS664T6d0U1VBCCg7htIe4q
	EFITZastB4c8RFfbOQk5RcBRaBrnIWM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793106307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vxlXm+JcRuAJZIHAVM0FX8ZHdQ6f/pCfzF5ht6AP94U=;
	b=oSENy4AIIUzpSEatcjRKcZCBduwcXroNH+DqUF1imGtnVA5oX9JDQtd4g2pXvs/DlHuWfp
	Ity9Qu5b+pbCG0Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D13C13319;
	Tue, 27 Oct 2026 13:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gzdcGYGh4GpsMgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 13:05:05 +0000
Date: Tue, 27 Oct 2026 13:05:03 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	usama.arif@linux.dev, kas@kernel.org, jack@suse.cz, djwong@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, hch@lst.de, 
	ngocthang2710.1999@gmail.com, syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
Message-ID: <auCg6dXegweUB5m0@pedro-suse.tail5790ac.ts.net>
References: <20261026152013.10511-1-lance.yang@linux.dev>
 <321017a4-58cb-4178-8ff2-055a9bbb28b6@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <321017a4-58cb-4178-8ff2-055a9bbb28b6@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8CAE100010
X-Stat-Signature: tghicgq5cxgjno9cae9rpgpiygrtqzz1
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793106309-517433
X-HE-Meta: U2FsdGVkX1+Z9EB7pcs8LAh9SFPD4VnLEtLyU1K8nhn3rSXuIiunGtqWb5YSrHKNJ5I7/DVx2oHXCDfcj9zech1H/NOiKe99TqhSh5TT4rJciIiRb7UWk78ohspfnFvL1uTXumq89n2MUEQcVaREjA1xXtHtcKD5yJvk8VXdaWomNhGXdEXte8/e4Mpjq/vXhpRo9DDW1RmGR4d1znlcYR2u7qSdYznp/m88NBHv7uVIarS6T+DG+J2om5JNsmOgJAM9Ogf73M4r7C+++pP5Dpdc5oQytlCOD5xy8VC/yG+2Y1GnXGd4mcBRafhPzCupkYEmy1l+VaC6uy3o0+jSaM9jo1JANQtezPXjrJtaabbyV54W3nPUmZyHWAXJe7s8RRlwJaBwymNlgOxhyXIp+KfEDb4NX4+F9Yk93TbyAL8YWmJuq16+tqMOl+Xfg2qUCG4+Btp+CVEewYAR7jIRyjhJTjkcA+RAjkc6wuYjwUTMErAy8GnsxqO0j3H8yWH1cZLEsK+IfqH4zC+mXmLzxxqkC/+g5bO4gwqNGJvNi17NN6c7ovXlfqHVmtVh4YqoroV353LaCK7O0qxDuaXttDhp8fRnn1AAVuKVmy8NyIod9H9cr+3Lcc9PEAAl3DNgl79MQXlshggpzhPZYkaEUi7kutUdd866Z58GzfIMeZExT6c6fEluCp/cJ85hAiRoUhywxA5RsPGMtuRuS3Ehqi3lUzI1YsnDhK99eBZyVohFYdwEqdZDSeLZF0fmPX5kL4ymZI/GuwA8o6JlpLFDfckQ/xC3EI/8XjBU/OGcBFN/5x43GjNFXYlj2R0ydY3rGBGTob2QsEeZ9VL9XCKGstzMGk0F+pxQr0m0HOVP1hYHrZEnFfgx5oSfMcDZb1DbEKrtcJ+6qG0dtTJP2UB9lPXfjZo1gaF19qQbIu+QXAsyCYqgaDddct+PUn9IwD5nJyz2G3TZ7xye6mD37Ea
 SYDZb/Do
 JEN7kXjnFOB6U7uZxwY/ib8ObJF1yofuiZvbcgfF/hofuD0lPBJUKITUGml2RJh0yu+8b8amTal4I5UBQxmLn/+Xkc63KEQp8cpOmVvo6GXDFU9tG3xeMXtX8x5zjLdCu3dmLZREPcGZ72Zg4CqoTS21eOYIrUE3WZ1aqDhLmAuAsIK4eIsrjjx5hxGGrPRZ80x+vzbka+2BhSQb/2mAMMVanl1NZLad4ud3haLSQFx4S7OEz1IEBhB5ZlpR01UMNQpHdBCfA93IUUsDnwN2/r+y0Su/fKr8CZ+VKes+KB3LMqk5XHcbUSPogsJ3H+UMWR9G7X0ZRt8u679nCwhCfOxrZS8kFJgv5eusQKlX5N30HkxrMZ+40MLnknPTs3FN9R4wVR8eJ/faeBTuA2YPtJU5hIsy9FOtjvN1UWZYr8bzJjEyh2rG+hlxcvXL28M6ZfSQn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:06:05PM +0100, David Hildenbrand (Arm) wrote:
> On 10/26/26 16:20, Lance Yang wrote:
> > collapse_file() can call page_cache_sync_readahead() while still holding
> > source folios locked. If truncate holds mapping->invalidate_lock
> > exclusively and waits for one of those folios, readahead waits for
> > invalidate_lock and neither side can make progress.
> > 
> > We need to release those folio locks before starting readahead. On a page
> > cache miss, roll back first, populate the collapse range, and retry once.
> > Doing readahead after rollback avoids an extra pass when all folios are
> > already present. If another miss occurs on retry, give up rather than keep
> > retrying while truncate or reclaim removes folios.
> 
> Makes sense. So we simply try readahead on all folios.
> 
> Any reason we don't simply add a second loop after the first loop where we don't
> take the folio locks and do the swapin/readahead dance, then a second loop where
> we do all the other stuff?

I'm not sure I understand. You want to nest two loops? Or do you want a loop
upfront? I don't think we want a loop upfont. That's slow and involves
starting/waiting for IO. Fallback logic makes more sense IMO.

FWIW, I plan on rebasing my refactoring patches for 7.5, and hopefully knock
some sense into this code. That will hopefully make this cleaner.

-- 
Pedro

