Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CD4CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3151A6B008C; Mon,  8 Jun 2026 10:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6596B0092; Mon,  8 Jun 2026 10:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC0E6B0093; Mon,  8 Jun 2026 10:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5C06B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:36:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E5DCA0156
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:36:48 +0000 (UTC)
X-FDA: 84856996896.15.75CE909
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07A6218000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:36:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHIH4JHV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780929407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ+dww3i2Z4HuF+mzXwFox0d5fpRC3Vr7GjOrj3pNoQ=;
	b=OSf2+6QPibpiAgHhUTQl1eXO3QVGrd+begpTIkZTQ0JrldpBvTWQy8TFXLdKfvLu6MWiKV
	PIBb3s4fKdha3SINvphFlMhx+AhfHVLO1kd1DPUMrVwFskqS/wjGIFTN2QJrctI+pOXUg9
	CtvUNdonZn0X90VJsd9TP1GgqpjoQGA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AHIH4JHV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780929407;
	b=TIeieTjw2lSozRY5k/hefrUXzPu1ssX3hHcivI0zNTlJjdNBGvWuvhbEZ+NAdQEcFLz2Zi
	j4kSrDZDPaY6bS4qa6a8eVJ1sjagi3ArNZpoeyx04JcYN+MtwYzOuVWyfcqco9FfwqzLcg
	g8t6SRULIJS4uqddvrOUMyN2F7PMmcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7966C601FA;
	Mon,  8 Jun 2026 14:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90C61F00893;
	Mon,  8 Jun 2026 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780929406;
	bh=YJ+dww3i2Z4HuF+mzXwFox0d5fpRC3Vr7GjOrj3pNoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHIH4JHVf6Yqub9+Vx6THiZh/2oKTkLESUFxvgzdVVtvsXIKS0AY/Mkaub9aKTK3L
	 6Ku1JVaNWn5yDHIroDJ+BK7agCu4FDVip183rNznQ/sW2CSNcMRlvuhdgme9+3nIlS
	 U4Rd804umICyA1tHihcxUkG+TiSzGg14KuBwN+INo5qSzaP+GB/CMwwRlRQYyctPpI
	 qBAx3l7cqIFjfkmiUBBqu7wRfdwjpEBJ7LM7TqcRWHFoIHlV6FjdBTHOj//rpa/Z07
	 7h8BChGRoFARDXt8qrAnRHM53OJZQRiBLpz24ZOiVEbDgacVrXoM15I3XR0PLtvVX8
	 mYHmAfzgZhftQ==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity check
Date: Mon,  8 Jun 2026 07:36:38 -0700
Message-ID: <20260608143638.69148-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f8d25003-357d-cd65-dcf6-568dcbdc6412@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07A6218000C
X-Rspam-User: 
X-Stat-Signature: xsgxqownbk1x4utx57phk75ijqc485ts
X-Rspamd-Server: rspam09
X-HE-Tag: 1780929406-294602
X-HE-Meta: U2FsdGVkX1+JS1GDaLSTx3iHM7y1HEGjcQLiEiARTFzSQg7XjRkC3n/OQD+7iTP17SbAL9EeQnY5BBEArrD1l4CP8Doh5GBcLDUIsIk9yc77Lmi1RJYD8khD6mNC99hMcu80hg2/ICWsnI8/5BlIgUieNaL5nLSwMZO6gsJ7mvgIXD3zaSh62nSuoo77C5iZcOBBGdhE92Xk4Rhk/h32MFcJIuQRxzh160LbieeJ90iRz52hGtlzDdg/nUZzOJy9L1jU7XLkyDXL//s6Mdu+Adpfcpm+yZwLzamBNoJFJGPNPGD1lWUuBKfgFsWSlN6CBPjWMSzo1MdidXu9pLlZxvsB3roAvE60R5UkZDutUmveWsid9D8t+1JBEI+tq47XlTjuwZnB4+/OI8F10QnH4hg/h8yL4Au7WroKpnehXZjmqQFxcYSXymwo9irDxSu3yISeGaq9u2VXOtoGOLGDKaDA3ynCVtLaLpj6Okl3c9+2LS5rjlOquzaUUAtWXV5jy+YGEC6juT+3eaS79vLdP2KGa5QQ8BFv6MBWeCX3ZosB2FG96imbPXtbvCvbicxNLPaMYqhpJZf0SbZX/BDWt5eYQHvNJPnRowV6GwFL7WGsaid8jza2szvUzBs/uzf7DEVbDa0MqymiwEkZiLKAgoIrNFsdKnnpZ/6oOngEDfm3NWikSjKDSbWrnA3059/AxnmBvJN+iE2CjXy5LXUf9pHlbXfIgnTqqyRQ6a14IuVfQjve3YSbWF3UewU3Rz24w+x69YFc9BkZFq0cLJmnM9LJ3Z8Njd9zfhbVZfu50KXkj9VI9mzhl6eR057mWteVp64FZcqgIjBwOZ3qEFs7oxE7rLzuBsRse8qGfY9Ubt9KoYvlRmIZJu2caZYAAEzB5U9MR7sTPl7hetbVpcC/qQ5745pwg1YoDo+in64azp+4h1Cc0QNjzEsfqn4O0dP2zEgHXb5/e38dDrCQzPo
 M0HaCEWb
 y2eQSkTJ++u2dzGkozdP2lIK/Ef7YeDkVXJamKXWAjrJFwJbMYk1GAg1V3kMEDfLJFXXF2ahOGoumKJIiQ6DN8OXy7lHL7SnWfYZ2bnIcdNLIFpSymDBmzMP8Db6yZ4llTYNwCKWfXWNYblamXnBB7LBgHXbyngWNAglUI9kyxgW3szY0H+tR7JDO7VnXeh5c9rQJGyd+Od2L+JJ8hceZCjvJh1xQqAYljcAuCsHmX+d7ssTFW5ZOyya/O+euRe1QTzj1D8nikx2jp8o6fMReSC/uj447WEqV3FbPmpbxRZKHBDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Jun 2026 19:07:28 +0800 Zenghui Yu <yuzenghui@huawei.com> wrote:

> On 2026/6/8 0:53, SeongJae Park wrote:
> > Hello Zenghui,
> > 
> > On Sun, 7 Jun 2026 23:24:27 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:
[...]
> > > --- a/samples/damon/mtier.c
> > > +++ b/samples/damon/mtier.c
> > > @@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
> > >  	} else {
> > >  		addr.start = promote ? node1_start_addr : node0_start_addr;
> > >  		addr.end = promote ? node1_end_addr : node0_end_addr;
> > > +
> > > +		if (addr.start >= addr.end)
> > > +			goto free_out;
> > >  	}
> > >  
> > >  	region = damon_new_region(addr.start, addr.end);
> > 
> > Because mtier is just a sample module, and this doesn't cause a catastrophic
> > situation like system crash, I think this is very urgent.
> 
> I assume you meant "this is not very urgent" ;) .

Ah, you are right :)

> 
> > But, given the
> > simplicity of the change, this looks good to me.  If you'd like to send a
> > patch, please feel free to do.
> 
> Sure, I will send it out shortly.

Cool, I got it [1].

[1] https://lore.kernel.org/20260608111534.264-1-yuzenghui@huawei.com


Thanks,
SJ

[...]

