Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D718F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U3vfl+0U
Received: by kanga.kvack.org (Postfix)
	id F2EF76B05B0; Mon, 26 Oct 2026 02:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF816B05B1; Mon, 26 Oct 2026 02:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0F26B05B2; Mon, 26 Oct 2026 02:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B75C06B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:42:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 388DB1206F4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:42:52 +0000 (UTC)
X-FDA: 85363834584.25.B469631
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9327340002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:42:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3vfl+0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792996970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5Vk1C6Gb4AlFXKC7EAJi6d5JIRefGvea6Uz6EyXsKA=;
	b=2MY0c93AevP4Hl4/lmtmWZiC4fiKXSnNL7TDOZiGOW9vTOJSNmXVwruQbrTVg2eqbA0V1h
	4hNeci8VS19iUgIFciP3XY1UsqucDGRfgniHcVrYiWeszSQ0WzjjYMGdaA5D9L9Ijid1wa
	8gQEB0itzQkEICWxdfJuSOFRcq2jjsY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U3vfl+0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792996970;
	b=td5EbB7Cm/e3XB1fU5EUS9wSLykGYVK/QL3TsHf4y1E0Dowvwkk85oZokLqXSkBC186iao
	+AsrbWpiAdrOWaoAT5A3KJSJP46H2906Vc6eJChmqt/dW9y6sGQTpojDGchy3cpm2er37b
	/nnUMT0CcawXWX1JElFuzN+ZI6r+y0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85AF4402CC;
	Mon, 26 Oct 2026 06:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366FC1F01825;
	Mon, 26 Oct 2026 06:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792996969;
	bh=n5Vk1C6Gb4AlFXKC7EAJi6d5JIRefGvea6Uz6EyXsKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U3vfl+0Ufgj5Eylaf+izJI/NCOCXf1RAVfxUNxZMCO0XtbSTeXllCooJOfS3a4LkS
	 3tHuJxvhJSMSXvdydTrXXKK5E3u607J1NUnlV3SF5+KVzoIxr9jR+avWhDZVgcOQot
	 Y/2Ub/n5idcTyiwO0X3MvaY2tL078Miw7XCTEnBwVqVPt3H5rFGFtmZeUUuOhOQJoY
	 KqJiBd7l3Aaa8647V6HxKE0+VrjycPaPERRKcaqgr/zcZTZhhzHgoY/fcccLFZG9Rs
	 +T5WoEE3kp0j02152ZzQJpBQ9xqa5QZVFXue5fjwyG5JuP0HQJQRau/qdrn4ggccJW
	 XxBL1dx5C4KRA==
Date: Mon, 26 Oct 2026 02:42:44 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: sashiko-reviews@lists.linux.dev, Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Anna Schumaker <anna@kernel.org>
Subject: Re: [PATCH v9 3/6] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Message-ID: <at72ZLeWWQyptVq0@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
 <20261024221152.6965-4-snitzer@kernel.org>
 <sashiko-outbox-184464@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-184464@kernel.org>
X-Rspamd-Queue-Id: 9327340002
X-Stat-Signature: pa8pgxny4yrp5dsz3ictsropw4eequkq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792996970-155520
X-HE-Meta: U2FsdGVkX1/PxhxogBXEiQEKmG376CT607s4tOxk1lBPUXcOSvGxgcPBGWMFLLlxvbEmrSQw/TiamKijw8s24HRURqJNyJiwrzqL1V/xNTwAUDXSupL4JiK3qs06olnJiQhneLb1VT4SgDx8baYeeqkAS0c8i2bjngnC3TUBw42G7n8cKdkWHbIzrhWQBCXLd2MHpa9eCEA1U/rqKOsKvFihEfHWerXZNZ8MlbuzXXOxfo2AahMoRCBCYC4uCnQHcbwJ60dq2U97ZkFYohpPFJo3g4xwjnBegc+M7xF/J5BW/9mhdEtOTxalvHhwDvWC3/pZI41DYhVcsnkaZ93xi01RtUDcODaDIZs3GqccuF7HRC1vvnXhKvOVfvWom7odQ5dJ/rjPx1OGTULEcMIkEqj0E6JRLqX2m0MQYCpEUTJi46oZtPfloLD/ThcVNoZw8+COtB8EffZ8sS11LHLrrYrukiugH+CKQaxbRCNlN3UhZyHFXhv9rlDpOYD8gCS8Opk6XNfBlrmvgjSf2hM+yA0fDhgeezQhh1YuyGxj+llmgor4tZhhauhGR8FH+zS3dzH2hAROn5PJzyYerHY3nloQSs+bgAYmzyePwi72yMSEt8XJ2d6KwLiCcpFVvDr024ggeQWmLSY09iTBmL2pfM5IzVEmMU1O8gpQLm3AiPNHmu/vwyT+gJnvU3CYKiIAFaFJKXso9xgmfFlcelDeNAzZP6B6yzS0W1RrzQfDHRsAFq8vyo8NNsbEj99FkKVV0L4Pche+nmtxjqGwXlIwk/CSvh2F8A2sbMNMaEgifP9Nz3fBrCEyoIrUtJQXZMnCNjqJJC0vf8myRVtiVyt4R3ctEXijlZJSLtmha5PlYIqCWKRpTerh18IVJoql4FWCboqOm3CA0v6lo1FH/yscUlwrNYx1j109gkIfhEDPywqaJzYclg5pkEFCLvbzrPC5GrpURYawhtJbM+U2bD0
 01rFU1uS
 Y262b/RpycQiqioieZlvkqizJHnJs5zJrM8SvvTETWS39JHA2cHYJnVsiT4HnJjpbWC/1nIirYucZKcm0FKZ8+Ka41IiSvAP6k2SeJxjtIT/8enUC8WTvnVZ9MQ65dWsxxBAUUdVelGZgxTO/BcSFOMr9wLOo+616xP901kUTFnxq6O/7Q/gSAxfz0B1t/ov9AEcjmBALK/ydtiF1Vcer7LYvhG4F3NP+kluDHYkNz08asUuu9g90KPPiLxxnHnjygFPnPytlUnQ+6c33ZAMBLbh8xgn659KfvFWSvvNInkIhJNHwr0FfR/O1NENLq1rAiYb65ZLIV15qHairYnUHSfz+Sru1SqAEanQ5Bc+3C+dphsscnyPGJ6dSYNowBRflvXR5jmbjyADKw8S791KWdIcd3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 10:12:09PM +0000, sashiko-bot@kernel.org wrote:
> Can WB_DONTCACHE_DIRTY still be double-counted here if a stale
> PAGECACHE_TAG_DIRTY coincides with an unlocked dirtier that has just set
> PG_dirty?

Yes, in that window.  The folio must be clean with a stale dirty tag.
On XFS that happens when iomap_writeback_handle_eof() skips a folio that
a truncate put beyond EOF.  Then an unlocked dirtier sets PG_dirty, and
folio_mark_dropbehind() or filemap_clear_dropbehind() runs on that folio
before the dirtier takes the i_pages lock.  In that gap, a counted folio
and an uncounted one look the same: PG_dirty and the dirty tag are both
set.  Closing it needs a new page flag, or a tag clear in the paths that
uncount a folio.  Both are core mm changes.

Only the counter changes.  WB_DONTCACHE_DIRTY tells
wb_check_start_dontcache() how many pages the DONTCACHE writeback kick
writes.  A count that is too high makes the kick write more dirty pages.
A count below zero makes it write none.  Data and page state do not
change.  Before 1/6, the clear in __filemap_get_folio_mpol() decided by
PG_dirty alone, so this window and a wider one were already there.

I do not plan to change this in this series.  If linux-mm wants it
closed, I can follow up with whichever of the two changes linux-mm
prefers.

