Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3300DCD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E706B0088; Tue,  9 Jun 2026 14:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935D16B008C; Tue,  9 Jun 2026 14:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8730C6B0092; Tue,  9 Jun 2026 14:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76A9A6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:56:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16B27A071C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:56:14 +0000 (UTC)
X-FDA: 84861279468.17.153D719
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC48C40004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:56:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KgUBY17s;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781031372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/v+WblXcnGgy+TlIRC7nygK9sdfkr6uI/reg9Mx6Tc=;
	b=zfUIccVLOeG4OmsDqujSSs+I1QHMEeNMtIBzV+bLPWNwW6pGSP1W05KD8XM107hg2W7VGj
	kx3OJwgFC3P5TsNK/xsbLmnnDJ+mRgPIiZIi6NNzoxba3valVyFBevX36cBIIcM8lq74Qo
	MUGZeNGaMVJA1A+ULLPxWWauHUKV3sY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KgUBY17s;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781031372;
	b=qcTV2utVBooxoiOguY1bLsnL7wT2xGHOkhARqQAkSK0Buwe/Ty1clMuVImUG0CNXQgY7wt
	CmBpeIKjmcluiP7/cCK/JLSJsYh+PwOdTFvUFT727rO6K17g5x3hwXyUPBvxJp0oeuNT22
	CWM8akFoFutFL1+CvQWZh1nGqkIh18M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E392A44019;
	Tue,  9 Jun 2026 18:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734A81F00893;
	Tue,  9 Jun 2026 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781031370;
	bh=G/v+WblXcnGgy+TlIRC7nygK9sdfkr6uI/reg9Mx6Tc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KgUBY17s1bXkxFcYqTeyKQBrFrsxOzx1IYBJHwlCkXC6g3sXvL4mRwkvCO1ROtxGd
	 BsqHxw6wT1dv+mRU9Q6jfuztb2pQ/dZNCOCWLNLfylSefVYQLRAv+KF95fAqtNbDkO
	 PWTZvSEbhnCVKXOUECwBVTk5ZeeDdbQKEJ//jl3Y=
Date: Tue, 9 Jun 2026 11:56:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap
 PTE accounting
Message-Id: <20260609115610.9a62a2dbb814bb9d5a19ac2e@linux-foundation.org>
In-Reply-To: <71507be5-8430-4a3d-af80-6777a421565e@linux.dev>
References: <20260609120443.71864-1-lance.yang@linux.dev>
	<b2d0cb7a-15fb-4b29-b86b-795d5b904a9d@kernel.org>
	<71507be5-8430-4a3d-af80-6777a421565e@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EC48C40004
X-Rspam-User: 
X-Stat-Signature: g6jucuxc41e1xmg4wumjh9px6njhns7r
X-Rspamd-Server: rspam09
X-HE-Tag: 1781031371-53342
X-HE-Meta: U2FsdGVkX19uJxen8qwxyY2CkpY+DVBC9TQ78eFA4GodVddeoeCPlVEXWyjA0YBaRdGD7sN4yn9CgvQorOqxxsT4AAKYN0uciPQqVZJCz+4IW6+t29uGtAYl1plMZoxrkcttsBtQzNF7+41hoeLuizNcbFKtoWeARP722HCEUzhzYc2f6O+jxSwnIfGSYUnBIEX3/nGayhtOnkG1WH1ybcThtXeqowhAL6tfLwdMixEPqdLEZtpzozdxETPYz1/hfn8C+sqg7l/dp8zTl8hh96ToYP+S0Mq4lEC8nmKYnTCU6lMwsKSStMh6KxNkGvtGdM84oe5HP8gWASgsTSoCwk1b5HJnqz/xi9yJvg0YscRF1KttMlidEQU8sV1UHqpv7Wk87Dt++wrjOndLQGb0dcOMnq2wcUYA1LK8r2jHmHJgFrx85jTBgCuJBlD1BizsjjMNeCbiVNnamNAwY3+xSlwWQaaKPl21Kg8IPuYkyl8vxwzzU6PbFkz05iFRbYabkYgl0l/f6jiUFK6fqvG5K5I75N3+QybkQWZeEAnJC3LIG1arLqvu/Mplf6ZQOmFrXA/5bquMoC2joZWM0Qod3xpB7m/R/3WYppjKkGH9tPutdtUwFj7A2c+Kmmfs+E3qD5758c3xPbfLNQ0IZgFGd4yTvXwpMwoxQAE9reEXInStCLNRI1Bakd9rY7T83E0RQMUeSN6ex2ZRlNYYll884veZaHYDefitFOutplwJG5NxdRpWWIxhurzR+oSviFsVL4LTpH4uyaHbQG0K11veu2aL/DpM4GHE/fDMax5Xm1qNBcUB3QBGiH5ZaKDs6FYwKLE1bKsZ5lIaMAcHzh70m5Kk3iklbV3T5OfxF+DtLB5+rmHyhVOArnGkpukNLZabc8ku2wnYGzMTAT4BnXwjZaf84d227DkZcXw1zAvPBIMRzUONrbvrG2AZXl3uWbAAIVXXRyrQxDHn8qTCgd9
 Wia/TWDE
 8eNJBUGVTVgQ1Yy4TqWhxph/Yxzjk4XBOqR1LaVNtHstHxHiirZyG9szTT/Dmu28bT2VKqK6YkZmaHXeQhdj/KjTBkdNnhCxnvfG86sP/N4hx+lobLvZROoqBvZqLJp/TPkmKvXpIU0aeCaEREW5XIrBnRvGFQXGdufCLy2lsONJuLgIWpO2D/ijSlOAX02dSCSZ+mSBymEFIuJrFgSIVwTn3U6gbUrwSmRTNbWfGGChixbaHIS6yak9ryY+gkviSAHUr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 21:56:13 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> >> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >> ---
> >> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> >> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
> > 
> > Right, probably we just want to add the Fixes: tag once Andrew moves the series
> > to mm-stable?
> 
> Yep, hopefully Andrew can add the Fixes: tag when applying this, once
> the series lands in mm-stable.

No probs.

> Should be soon, I guess :P

I move the second batch into mm-stable after Linus has merged the first
batch, usually.

