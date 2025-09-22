Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40969CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 18:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5773A8E000D; Mon, 22 Sep 2025 14:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527928E0001; Mon, 22 Sep 2025 14:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D638E000D; Mon, 22 Sep 2025 14:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 324DA8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:09:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A61C118706
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:09:55 +0000 (UTC)
X-FDA: 83917674750.17.E66E2F3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C249A001F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:09:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=V78bR3D8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758564593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FK0vhlcwzVJAcejz4cqAmDuYQ9iMTjiS8A6uqr3V9Oc=;
	b=ciP2X/C57rXD8dhaqi4NY2fHNcsZmEGDVBX/WbKm5BOv517olLoED7C8wvk/w5ONhOYK45
	rq/E/+kO3gwz7HuQGguuXBVcWCw43QiJw2a4k53ZsdgpY1TPeRvoWkwZYcjinNP6timH+l
	h4QxurQwqlqa66k5ryb7pVwwr0ZBPEc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=V78bR3D8;
	spf=none (imf15.hostedemail.com: domain of BATV+e8c047cf282baadaaf50+8065+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e8c047cf282baadaaf50+8065+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758564593; a=rsa-sha256;
	cv=none;
	b=4XfnAqmAe4AA4ZoZzrllQj9J36ZML3LOhi+ux7B3eZKgaEHrIc2f4y8mneoqIZLpP6orf+
	AIRRprdAFiFqeoIMmCwJel2TEc2XxaQLitrw6jfJIt3U9H0iZai8HOxkqiaHPr+kYYxAb7
	M4IjzlWJkvPuCzOrZ4J/fZRK6rN/8fA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FK0vhlcwzVJAcejz4cqAmDuYQ9iMTjiS8A6uqr3V9Oc=; b=V78bR3D8A5q1wK68XXXyD43mjM
	v9k4tb6BPM2wWULfmvZxAOgd63Nt0qA3qTKyd1a5ZIfitDlETwgbhuMmci8VKDs6tCg15oKI0n1q+
	67zHBTQy4A8EHZmgNNAJs+9YW5p0vaPpces4GfB1etOYPP4UBnmpmLW6pRTKWsCdj/WLzKALZDWKH
	ROumwbJZ+6xAzHPetLhZ8np8HEhCvuAyltz1DQbCdl3FqGvZfe8EmMgq87eUdPjUVyRPDKTr/Z9Cb
	0aJm3eLOuqpLB5CAE0anOgU5ed7IRsMqzXAraXI7YYAxmKjzRvFZA6r3svtkGZCZvDGL+UFZlLpzS
	ObcBJ3IA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0kyx-0000000BDg1-3gyU;
	Mon, 22 Sep 2025 18:09:47 +0000
Date: Mon, 22 Sep 2025 11:09:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [RFC PATCH] driver: loop: introduce synchronized read for loop
 driver
Message-ID: <aNGQ66CD9F82BFP-@infradead.org>
References: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1C249A001F
X-Stat-Signature: a6pykog1t5hunpgjkzx1pompi48qab7u
X-HE-Tag: 1758564592-516937
X-HE-Meta: U2FsdGVkX19uha/sk041zcuhN7C+Jy3bcr1QMKI4zEDEl67yHNTyCPE43z0Kw6gAMBXubI6LhFUv3rGqZTYH9SV72FmOoL+miwfd+3GBLuy84zAEfB1q2dlZlWIRDaqY6U9w9ELzP2z8N+QiH0dATYmBmcEVE0g2NOB840rw2jtATW5nD0Sf+wXgKXPqXPPZel5iBQYdpnlEEN3mwuYpTLqhh+Cs6ti2r+v4sSTQmXbNTLNPXZQbXy6ZC2O4RS8RuZokQuoLxlSj8CBRJ0GbF2pKxUVRuxQ1vJj34ViD3yZkOhpVNWdcZ2YpOggsJmvfUrSUGvruqbYFNeKC4lbVnl4AtWSHWknc3DfwUEUSurkmZcFhBKTU649oGFdX5ctuQqvHv7B6tB2w8IwkitaxsEXKmvVQis+5KlQ96RMf9K09R38Qikkq29fQGRGWQBvx8x/lulSn/FGVjKO8M0jYJvRTzMdR6z7FejIJuUVYULGc7eMq2M3ydUQvaltIv5hb6zWveqoPPcqVbZTeFB7lHfLWKiFPdaoFdvJictvnial/TKsy5hAg5XLtLAi5G/xV1m+OJUu2GF13YWMXuZ+N2dnbrkOOeQL4JzgVoKW3C34xkpOm2M6bYrmIxJCg2bQ/Mj1vNnReMtuy7FMr7ov+az1F2Wzw0HxlfS3juBv2QMNaTwJJrnLCi0WQDrdnlvDow6Asi72f1Os689pLHATU5Be9/5PjPg35XzWAotwEIhbv8Y/Pvt6vjG+TlEo7Kh9WUWSY524dZJsa5tOqPVQjPPG7h884T10j5LflXq93S1Xc46GVrN1lo88XzNZfzvlKyNy4iZN0qkGQqfdP5PLR4FHbID19OqJ5sZLU4O2NWEsEweOrBMEPm8NO2dL+Uq11qiknzzDufbdPKrZH8JwbPQZA+drACL/lqFgwlv2u2FjgvA7a0ivjtaLQ2sMpOnN1yYrJg/jawuX8EYwLCkV
 n6iv1NEK
 5kkkSuLUczTf39Wbxa/0chH1Wqn00oqARBmH3rlG+GRF91myaAYW4NooVggzx4e7drnKzj7kW0lSsGeQNw0AvhnY+B8pNWQosTbXm7hBc+5xidJXqJhHJ88KilMEJJ8SYrmNW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 11:29:15AM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> For now, my android system with per pid memcgv2 setup are suffering
> high block_rq_issue to block_rq_complete latency which is actually
> introduced by schedule latency of too many kworker threads. By further
> investigation, we found that the EAS scheduler which will pack small
> load tasks into one CPU core will make this scenario worse. This commit
> would like to introduce a way of synchronized read to be helpful on
> this scenario. The I2C of loop device's request reduced from 14ms to
> 2.1ms under fio test.

So fix the scheduler, or create less helper threads, but this work
around really look like fixing the symptoms instead of even trying
to aim for the root cause.


