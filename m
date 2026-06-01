Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BEFCD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74B66B019A; Sun, 31 May 2026 20:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25616B019B; Sun, 31 May 2026 20:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B796B019C; Sun, 31 May 2026 20:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93A906B019A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:44:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27A7E12034B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:44:44 +0000 (UTC)
X-FDA: 84829498488.08.6341314
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 34D2680005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:44:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AyH87CHF;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780274682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vl0+i9lBVVrChfNcXDU3z/ylyAnTJmpZS1smzdIiy48=;
	b=VmDSm43BBa7K2HmCfo02dsKpagII2eGM/8kKsJ2FUSSL08m8qCoUiNcgKKclEoB7fKdnFH
	+w1AwBQTySwY7flzeBQnCnDMVKKwn8IFIPjRdQ2ikbkBvB5FVfhowLqv8j2PmF0x4Z+BS2
	L912aygb4PqKVB7a5DDqnd8G19bI+3c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AyH87CHF;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780274682; a=rsa-sha256;
	cv=none;
	b=I2Ky+lsKrw0d8BrKDXZumgvkPVJmXLsCrsDvbQ4T1tbofJtMSvXxM7K01hWOZA+3mA3rVn
	QEky5nmqrkwp0bOzgfNSzNinAbtBb6MnbO5MRnCFZL72zhnBQ5tm74befiewsXys6vgMfy
	2K+LaKrqpAdyI0mFmR5OcdUdI7d5yGg=
Date: Mon, 1 Jun 2026 08:44:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780274678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vl0+i9lBVVrChfNcXDU3z/ylyAnTJmpZS1smzdIiy48=;
	b=AyH87CHFsWkATRHkmQkgeLR4UJ+4tVYLBNSr1cxz3MHymtYfbr0UGdeQLEuYU7yxAiA3/v
	pAnKJ4aSEVeUhCsQbrBbG7C0dpND4Z81NiS6UeDDDx25j2hg+h9/T3XSS3zMznwEPPiMnM
	w0AxCaVty8nmj913IxznD/pKablp9qI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Barry Song <baohua@kernel.org>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] zram: fix partial I/O config check
Message-ID: <ahzV6P4n2SICvh4R@MiWiFi-R3L-srv>
References: <20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com>
 <CAGsJ_4wB5XyUrPpg1O-pkySxo91RsHxaaUkR+Kt+heP4_OeeqA@mail.gmail.com>
 <CAJxJ_jgk8o12OYAi68JznpwKYTUJOUizp2PAZvNz2VdVGJWstw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJxJ_jgk8o12OYAi68JznpwKYTUJOUizp2PAZvNz2VdVGJWstw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wdidebqd9tbq6zmh55iwerdhpn6pmmtk
X-Rspamd-Queue-Id: 34D2680005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780274682-115243
X-HE-Meta: U2FsdGVkX1/0Z+F8vFfNA2v8/+AhSeisZV3S3xXDfPef9kOdCJWvI4zgR4eoaFU33sY3/OLJ3HnOCboF0VeYaF8jJpLYiSVuY5exlpQeqruJt2RS7EI7gLk+T8ssY+mKgkFersswUEtJ/vZ7H9uNlD+CYyZboQajLwKEro18jiU36qwNlmV//3e+4e0BFi97cGNEZrO3tz+Dkh9gKrlS2T13YsvtQ10PGcKX/ShLV4NCzeWTtdpCFBPa1t1JYrgEttEvtjsQeYxZiHAxK8NZTBmjEwnpZsxvr7QDVvcL9yPveji0sk/Jhtsya3tT1fQj2ao5btQBSBw0ogrOfHDotah++Bj018Fy8vz9Bh4v7jw/kxdVCfFOZAHh/UFWqMrUXepWJE2Lw5Qs7yFvccfp+VrD37Faw1FCava9ySKhrW/Rz4+9FuT/jxr8BaQOmj8VGpmxBHnTBN7aNy7NIXq/g7DIf40V9NOXQatYxnFeY3rABCMo+Sw7qVuvrD8M1Tc4o2LW0Q0A72jzcBYEeQQFZFDB2dCOpWSaFraZpVkMRysM9KHUq65cNosOjDYhHPEDLIRbOgUdKDRn85sPe9NU8ba9RU5oBcJ9wyMaiT7JuyeBD43GDs5VjYXIhReQDs2MXZXMUNiGOIEJT3ALReb+R2nkrDGZ92X9y3q1y+mnTlTkI/6AAoB7BQGNQzlfm38WsA8bBdoWWLYjppH+3gT6pgNj6QKk2SMddrintU0gF73tVYlj7PmdtW9RXCSyt4ZKedakilCHslotErgczoCFUgMVzZ/x7v7tod7JPwEh+Eg5PkKegm2ZdO/+zCMw5PE6L++RvjKDf4SaOGChpxrYHlp13yg7ICXeH3utg2GOn+LujtqsYDuMIvS8M3sWsJaC7Y048NLIiGn+My6tMEfCJYAZhUZyYRalutB2dDrHbC2l8i3T5bDr9MbqWsRbkIjxEp5VU+d5J0X2ITLiznb
 mW8qTxHZ
 fOM5l8JAXwLmhXVtCNosFG2y7z3Y5U1hjugpVlKglcPFVLzwhh9FQ9oxI+RM3JoE/MwVWOPS9hI5UxI5XNLxNg4kbtAh7kTr46yAy8chNWF8cTdFyZK84VebEL1lkfCG5wHbuvrf88vysskIfl1OSXEWN9XUvfM8EnWsCZNPKtfbdBLMekBfZqpQhAnqBKe0KHgpGQqb2genK+Qo6b+Icrj2fnGZnraZhx9Vh2PUrga7N5ZXyrNddw0eCYTiwpvDoSJiFSDvjwVe9di5QnJjssohZuQmMJmsgW5B17tyDfoKKGQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 08:25am, Jianyue Wu wrote:
> On Mon, Jun 1, 2026 at 5:38 AM Barry Song <baohua@kernel.org> wrote:
> > > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > > index 6e1330ce4bc1..72f89fd5572e 100644
> > > --- a/drivers/block/zram/zram_drv.c
> > > +++ b/drivers/block/zram/zram_drv.c
> > > @@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
> > >  {
> > >         atomic64_inc(&zram->stats.bd_reads);
> > >         if (!parent) {
> > > -               if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
> > > +               if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO)))
> >
> > However, I don't see ZRAM_PARTIAL_IO defined as a Kconfig option.
> 
> You are right. ZRAM_PARTIAL_IO is a local source-level define, not a
> Kconfig symbol.


How about removing ZRAM_PARTIAL_IO and use PAGE_SIZE to check?

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 07111455eecf..ca0c29482283 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -221,7 +221,6 @@ static inline bool is_partial_io(struct bio_vec *bvec)
 {
 	return bvec->bv_len != PAGE_SIZE;
 }
-#define ZRAM_PARTIAL_IO		1
 #else
 static inline bool is_partial_io(struct bio_vec *bvec)
 {
@@ -1507,7 +1506,7 @@ static int read_from_bdev(struct zram *zram, struct page *page, u32 index,
 {
 	atomic64_inc(&zram->stats.bd_reads);
 	if (!parent) {
-		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
+		if (WARN_ON_ONCE(PAGE_SIZE == 4096))
 			return -EIO;
 		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}


