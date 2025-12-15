Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4325DD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 06:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397646B0006; Mon, 15 Dec 2025 01:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DFA6B0007; Mon, 15 Dec 2025 01:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DBE6B0008; Mon, 15 Dec 2025 01:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1452D6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:59:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 916E91369B4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:59:16 +0000 (UTC)
X-FDA: 84220803912.14.43F1E99
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id DA686180007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:59:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4BSHxxje;
	spf=none (imf06.hostedemail.com: domain of BATV+7f9eb436284ccdec0213+8149+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7f9eb436284ccdec0213+8149+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765781954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwJMnZv4O2KS7JbGg+hlCsT0qlO0aGhYisR4zAG21iE=;
	b=dz5CKsV8ZMZ9BSD8ZgJ/jh5QduxLEViQCom5UChfHMyvTT3OoH66wMQglpmiUuy11MgdNb
	nr8oSkDnhYOqFZNWwy+Lm1RKbetH98wUGQkJX1bsJbeh87GMaHLodT1rabiUgMNj/uZfrM
	bfxbr4xIouZIVJuhCnbSfCoz53aaYVs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4BSHxxje;
	spf=none (imf06.hostedemail.com: domain of BATV+7f9eb436284ccdec0213+8149+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7f9eb436284ccdec0213+8149+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765781954; a=rsa-sha256;
	cv=none;
	b=mNW7uBQh4Hhu6n1GiXx1KSjAzR4JlelnUQevaH42uPNIHeIYtt7Ob4kSep76avqRIijQSK
	jNeZJlyKzzstWifzq7VQSeIc65n931yPYNjjgzGrQMvZbwseXW7pNQZZL4sucPn9FGzmrO
	WkDA4zZjboQrmURXW+9DgDVqYE2mi8A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vwJMnZv4O2KS7JbGg+hlCsT0qlO0aGhYisR4zAG21iE=; b=4BSHxxjevVg68YdWTxLIftGPsI
	+MtOLp/rV2x4zbcffQzZlIR1ecP/uUvPeieNIix7+kkuPW5UdfBdrxJtK3YGVYgMF9hZ+k8w05CEg
	AtGtdAbOxSBhxd2XhlauoGfES+Itb7wcQ36hZ6QC8NH4iKfuCn/qksV99tx6DSiRwCJBd1Jt+nEn9
	603+ZF3ed2zGOr8udl5BIACij1QDa+MCX8THUpSHI6m0oYKu4zAe99nuRQcNykW9zpyagojcmt1Rh
	P33ssYJ88Q3BNwt0zcQX7oFA4lmOjaXdhMDcOrQdmyNogdVZOlgFGjsonwSeqGWS9QQxzXpsiOhor
	R6VCv9jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV2Y3-00000003Az8-2YW5;
	Mon, 15 Dec 2025 06:59:11 +0000
Date: Sun, 14 Dec 2025 22:59:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <aT-xv1BNYabnZB_n@infradead.org>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215041200.GB905277@cmpxchg.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Stat-Signature: yqdf6kztura17rsa8fnoyrus5sxe76tq
X-Rspam-User: 
X-Rspamd-Queue-Id: DA686180007
X-HE-Tag: 1765781953-939759
X-HE-Meta: U2FsdGVkX1914v+B/dK8vgb/L80I6NThxFcV7Usq+Xsz+J2TDk18mgjeNwDOI3K52pK8UOTJj3yBfG2kNLMDwlk5+kVRqEwBdE7DMG3OZ7ar8tPUKQzAp2t9dfmzwbU0JAiJFY21Y4CJQuUCnXxvDDeItWA8DmWIKyhvE4XlxfiQfo6rqOtG2EKKi9ElzkyUcHGtEpq/JzAiLq0+NRgsJjdSezj2DfHnPGjCa6pVfii+dKsGsXYyIGIvMqeP/CblDBKKdg5AwZnlSMt7A3/DdV2PnldhzhnBO6NEp0zTZ/14JISiWqkWSGtSuqH84vAtCz/l7QDYSmP7V5zKNDUw16EXZyusqCWxC6LoL1AemCBpWdr17uAe285Y7l7tTzrVv9+VDN6wspF3NtvdTTnyY19dszcrIyQDYElv2nG+K0+wWm2y04YtuVOjJDuINknpfdsu/6mcbEN9oB/2hZygAGDKpZHT12fI2fZNTw2dVVTRmQPlAJeewNYPj0Ok04lq6GDRAiuCEvK5QVMRb6Wb88QFq/WB0X954HLwmfRO3pfpOI/uq42dVhscg7W5ynkFhM8M5/C5wOiYLUEVkrlHgt9azpKT+afSXUhn1vcG4DQ7DaVj3f8tRd75c+ci5g9l/BHQ5AMhyxhe9De5nPAVHl63hXhmqEjXnAmApggdD0jqRuLX/GKQ2s5LkAdceoSpC58cHLdbzgm8ry9Dw88sTQtPO0Dh/CCL5Ni5zNQQrPsHZ/YMrPT9CS8ojZoi/lToYh5exDxBSxBD9PcNEjDpfhdKy38iAy3crIS5X+b0lm7D573Gv+qBs/QHcJiq+gNf8bwAOmDLrQ4cuK9R4lV/gMsk3B0AeXphmRYMZYN6BkQDoieDYvnVznT74jdIQtAwmXSNvYP2QULUU7pnskc3o2QnnXGpODx14/JkysvT5kWi3WjKOEygvC9a3qEHeZ+kCZYOQI4IEhLlDLXFv1B
 5JrvOT+f
 xr/5zAgCEoirsKQh5o/pzTBZn/L1kGoIc5z9mGV9gk2JkWMSvZtKkXqHpr5EFvX5RF2ywLi6IgKrV8/euWc4Evzf0/vsm4lc6AOALWZO3eLcqZVUXl2HrlF6k/rW7+r4fx3rJspPN9r9AoeiJkqWofkgqga5jaowXD24rvjgifvcR0sCFl2KBJs2EtHVRWKTvQ8wg4uw276aR8DadIZFifweG5zD7pdgKAMFonfkLsZHGoXyykYu1m5TSASNJxZ53hzOD59DXfgQhDMeNaog/5diFHsQN52+KQ2lI2e3+IxJgt+OSm2SO9G5f1CjDECeKCpS1pinovDLJkNdqzDzv3WTvqCJ1cE7x8JQMfjUOML4OUNFPOqQ/ocA9Y51VRP9vb6QCl8KwqmG7A6apvHRI2/653MuZC69jE5OaVHTTBzoW7b9md7usgy2dao3APMQmVpMlRH4wMKP7qo1KJAEUWvVVVfOhFpwDkRJvgikWLogzT2SLOB3NQQxFFa1xBEQSAKJGRfToMKLtqAB2Y1OgG44h0lTFkAUuK/bnpdn0nYLDtQw2N6WsHLeDGHtMvZ7asG1wwNPB9ibjc7lulcQYW/gp5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 11:12:00PM -0500, Johannes Weiner wrote:
> That reasoning doesn't make sense to me. Reclaim is always in response
> to an allocation need. The laptop_mode idea applies to cgroup reclaim
> as much as any other reclaim.
> 
> Now obviously all of this is pretty dated. Reclaim doesn't do
> filesystem writes anymore, and I'm not sure there are a whole lot of
> laptops with rotational drives left, either. Also I doubt anybody is
> still using zone_reclaim_mode (which is where the may_unmap is from).

Yeah.  I wonder if we should retire laptop_mode.  It was a cute hack
back then, but it has it's ugly fingers in way to many places and
should be mostly obsolete by how writeback works these days.


