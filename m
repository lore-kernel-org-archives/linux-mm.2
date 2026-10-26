Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C2D606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cjje+TyJ
Received: by kanga.kvack.org (Postfix)
	id 12B916B05B1; Mon, 26 Oct 2026 02:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC216B05B2; Mon, 26 Oct 2026 02:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F339A6B05B3; Mon, 26 Oct 2026 02:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB71C6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:45:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59F5212070F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:45:45 +0000 (UTC)
X-FDA: 85363841850.11.707C8B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BD0DE40005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:45:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cjje+TyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792997143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSJeqW/JSAYgRuY93wLK4C5nODhaGQjLKEspR3ljmIs=;
	b=sGijwFyEt9+qO1YX3ZHrIl6C5kEzEooxwRhCPUgr2k03dPEnh9V6WSrxi6Vhxpb7ZjRzFS
	QNkkjMRAbT7eNdOyE4GhxpVCrOftZodqNXtNNSKoZPK4M2ytE1kC7D5QyFtnPkh+igfw8g
	tZGDGItFvnWZGwn1VdFKJQnEy3gAS+k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cjje+TyJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792997143;
	b=YrYE9tqCaBqFIdWEQ5tAFkoxEYecgZOLHi1HW/zAVYSB6XY/BswAvAzxMMOVdKsauYX724
	O72lSePMEnGc3A7InNCTrQp7Mq57MfPFasY4uQQUiLSOt/Yp5HGeUNQ/D5UteWgEWfVe8C
	HOgbe7lX73mGYMshgGUC8CYckpeIYi0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1691B4343C;
	Mon, 26 Oct 2026 06:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11441F01825;
	Mon, 26 Oct 2026 06:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792997143;
	bh=tSJeqW/JSAYgRuY93wLK4C5nODhaGQjLKEspR3ljmIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cjje+TyJe1CjksRtcHVbhALfF3kCywMkR6E82jRbwK5yU3HW7sthh3PN26Q/IjWK9
	 uoBC3LrKmpjDstiQkA/8HQHoWfOlVnl1jfLNe0h/9RxM+os0U6iIMEKVlCJEapHf7X
	 0HtlKwgjbQrYV9JTgwkNTwIDH1kiehlsUxVdaw6tVzC5QFQTV8M+UgytO9uX53CTbk
	 Z9P8A50y9pQciRZBtX2J97yvvXIHMUS5hO0Wk0Bc4QosutayXT3no4xlQQJAg+xTYK
	 vcTcvjoPf4z6R9oXFdGRraqpLcIiIab39GuC4W/GwvTzHVSpe9R5OworkePg0f1Z26
	 MZXEyTNvhyvSw==
Date: Mon, 26 Oct 2026 02:45:42 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: sashiko-reviews@lists.linux.dev, Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org, Chuck Lever <cel@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Anna Schumaker <anna@kernel.org>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v9 6/6] NFSD: drop a shared boundary page only once both
 WRITEs have written it
Message-ID: <at73FnE5dVNyQO_L@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
 <20261024221152.6965-7-snitzer@kernel.org>
 <sashiko-outbox-184467@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-184467@kernel.org>
X-Rspamd-Queue-Id: BD0DE40005
X-Rspam-User: 
X-Stat-Signature: 4k99145fbh93jc5fzrynn3cdjytaukqm
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792997143-782765
X-HE-Meta: U2FsdGVkX1+11WKe7HXsVmhzyfc4c2idGViylaFk+BLrC5Ku07/oktN6gihwnnm9Fvl72WNQrkvClbc+sYwdm7E/kC3GXbUV/5mJXG5c4IvelCef8uuWxKOpaZ/0QsQOzIqHthZnuLUlv2SuqYigtMXz/s7VKahZ9twX1JlcniblfU9aRiyoqDkGogTcJu6DirPo2BJiFZ2fGjMu4K4hLAeq8CPipj3AWaNuUtqTrnKeqd7AHVeDM5MIYYfe0KEDy8fog62L9ZDApzkdTlQLg4Bx94nLHRTdwrRrdIF0eC0Ayn31+BxRZuO4cKmgrtwyQyCLlAkiYwelu9njv5A5AM29n12yb45wsly7uyxbwta+uSuXO8MgFuIRWVN9XbUlGec7qAhwlNOVikaM60exLtAel73wy4tgnu/CUGOp5+6ikPjI5RaF3AvVkniZjapeS+OgGilZR5Na1/50x5E3jvNfpREAWeP7AdWeJNxSO4qImME7zBrtWE3zTQ8X8JqDhlEAtIK9CF+JHUmKQToJJ+13L2R/OF9HI8qSrICDypBWHB++0HZQpbwopMmkzhRoe6Kv44QKOn093Y12wzZ4TIkXvWn9fsSauEMu38XgmGUOzKAMNr4i2/IU+05tAL/V8zVuFyltId/SCmlU0iF4SwjkMeoPn3FDBYAIAEFOM+Kam0MEHdo8bmHlBzzHZGVSys1kJHfAP4oWKWizsYji9lD0oHJ8mH/0vcXqPdQvPseU3RhKq8sy7ks2aXM4KQxL18x2xjCIml5I5A5G1W1L/jX+Iw+INmi1vpf+b1Lq7YUiqfNl667zLPFWCTPJtULcjxs9p3cdan2Qv61LsRREgJB/MC7uyzR/GBV5IxOVt5lkl6pB+BFKJwFvMImUwAm3nNKYhqpgAneq0LviKEnlx1Z1BZDm6icukUT4SGW7Mgsh8WoG4o1Ou+iLE9ojlKVl/e4N1FHtmmhP3cYedmG
 zHYxP3N3
 zxn0ASevSWhwY2VoDBnsUa1qageMCd9Womp8G9TIu4PqzEyHFy2JfKg6UMR3heW7Dm/pXCbH+Ga3X+tfQrQg2RiqaweMqcLZAyNwx09l83R40fES8z8M2izWZxZg7A9iiUQ11yZXIYpimTbo1Op6YGpfSXvIZ/xzXglLzUyIGgaAffwSCXZVRcubb3bs7tKcVim2JyFU+W0jEDfnL2tO/2tZ0+F2ltAQtWEDsTvr96FmveFCv4Gt3l9T5S5B1S2reABcPhLtpWpbKz+H1T3WhM2BR9mo7atNQBt/yJbqtzTYq3ppkmMeyOAz4sPgiwude94LbxIcu3SODezI9Hdv1ZMuexyH7l9kZMx5H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 10:12:10PM +0000, sashiko-bot@kernel.org wrote:
> However, in fs/nfsd/vfs.c:nfsd_write_dio_iters_init(), the boundary
> between the buffered prefix or suffix and the direct middle segment is
> still cut at max_t(u32, offset_align, PAGE_SIZE):
[...]
> Should cut in nfsd_write_dio_iters_init() also take
> mapping_min_folio_nrbytes(nf->nf_file->f_mapping) into account so that
> buffered prefix and suffix segments are cut on unit boundaries?

Yes, and a separate patch already does that.  "NFSD: cut a misaligned
direct-mode WRITE at folio boundaries" replaces the commit in
cel/nfsd-testing that added this cut:

  https://lore.kernel.org/linux-nfs/at0DFod8CcUfus2S@kernel.org/

With it, a misaligned end is cut at

	cut = max_t(unsigned long, offset_align,
		    mapping_min_folio_nrbytes(nf->nf_file->f_mapping));

so the buffered prefix and suffix end on a boundary of the smallest folio,
the same unit that nfsd_write_dio_seg_hold() uses.  The cover letter of
v9 says that v8 1/7 went out separately.  This review ran on the v9 base
(cel/nfsd-testing), which does not have that replacement yet.  v9 applies
on top of the replacement without change.

An end that is already aligned to offset_align keeps no buffered segment,
mid-folio or not.  This keeps such a WRITE direct, on purpose.

Mike

