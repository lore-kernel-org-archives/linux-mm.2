Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD14DCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9098C6B0005; Wed, 17 Jun 2026 02:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA126B0088; Wed, 17 Jun 2026 02:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFED6B0092; Wed, 17 Jun 2026 02:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51CC66B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:17:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3A3F12033D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:17:49 +0000 (UTC)
X-FDA: 84888398658.27.AEBF69D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id D74EF40010
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:17:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781677068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/2FVP4iOkR4NlTT2FYyJZW7mNU7r0TcbWyTUfhw1cQ=;
	b=1TGXYJ5OF/5hfqTvpjd6TJdLG+9Dy3To5sEq9aNVvpcAThH4M5hplGGZ2yJYIJGg12LnEC
	tN9IB6Z5B1GdwunfRyre5tnEHGd8jlkRXjQm10p0+zzLpx8A1d4sAGN9bIbvevWJSZ02xp
	eDTbF13+4/YI4qKH6Hh5Ff2sTffF6GY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781677068;
	b=78xNk+Scnneuauu/DMHke4jZe9ObGYjhXyZUycyRPO9XRLcHasbN0Nti1Pqg/dVRgKsUHa
	OJok7FfL2+xwclyiwU/qJXRHEs2KNPLbWe0mqCtLkbSZiFWgzpPS8tUIB0qd292YzX5p91
	iJtHVfRDuufPT2iochvHEdTH5oe6sYE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4450A68AFE; Wed, 17 Jun 2026 08:17:43 +0200 (CEST)
Date: Wed, 17 Jun 2026 08:17:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
Message-ID: <20260617061743.GA19844@lst.de>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com> <20260616123646.GB21024@lst.de> <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5wui4ks9egarj8fpon1ik3z8ghgjtoqe
X-Rspamd-Queue-Id: D74EF40010
X-HE-Tag: 1781677067-980728
X-HE-Meta: U2FsdGVkX1+VFM8pwDTwtPkVlTJqhFDOOUE9KzdywZoBI0tyCBBMZTZnf/hNfozK0ZrWINFxpthr9waQgZ+mWnkpxqAtwHLs7vFzeGeYHUB99NPWZ4zd2P42umR/JngtBj3ongJhQw6fBNbyahsyFL7TjEvojlj3+Kk4U8wVQj5I3S5ZBcBE+HJP74VYKpumOPmELpnpCx8MaKTktS8V4MzzH/0+XmhDU0ZUj3IXxHW1Y320969UPokawMbrlflFvzfzjivUhbqdofZd3qTCv7nLdLbwrLivGTqdoaM/Kzdq1ll50qcS4j1Ddda/SES+6mOLeSg/lzVs0im6OXGqAcoiVuLOdiGafAn9wW5G7+ze5B/cioZfa05rC/fwA5XReqAO5xePFbzQZTXuk+skgJmtgRzaE1xKxdB3XkLS3Nz0RCUQtHSaXbqGput1ZX0iApNdNfBioDRylLkb4wt5ZXi9cAs19yjXU06CTzVVryUwHDuHKaORBkJKUM6nIp5w4X9kgMsOTkDQbwY/WHCOcSPRD8CKYgqdqUutlI/I6ZaANGgN2CQjoTUudIajitwGQummPYmRjngZ9zAellJIsbrB3wu148NaQbXowFG6U6YtVrTj6pqTjYzkxOgm8MRtnWwdGjcI9Y48E3wfw10Adffk2qOVaRYVeCLWpdZdSilcl+VDUwAV2MzCPEKpG3FLvOU6UntUn9kkDtMMbyeTgy2T7I42zxMG5+xXqArM062h/6QMF2vrsYT2LNtga4L83fO4YsM9usPHKBiyAq7soIbmrFANYcZUMi7BZ2osejmqYVSUEw7N1WyCcqdx9CDrib6GKcT16bq+F0m6DPlw2Eb14CDqCZanwDzJr1HKQFK++CdC3S8kAfj9opqO/ax3kUUAHskeKbId3/Z+LNDovVAICB8dDKOMw6tIG8UHHaZnOd1yRckTEyhDWFljcQJzmbhaGHTe2BxocXxJlNK
 NBvBQxkU
 kfDKzmYpBXfBCH3MSZSB2pMBRtx4ItIT/89Lj8bIrsW7YvopK0MnN8J8bP1lHsuZFoVVqsZgKjrG5tZJWj2Xx5/JYONF7yK6HSxjqwRQ+enI5RIby828whdy7+bqN6uYKD4DxA37UnqSM6ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 11:38:02AM +0800, Jianyue Wu wrote:
> Before I rework or drop the RFC, could you outline how you see that
> core-side model working? In particular:
>   - How should a compressed backend like zram or future block device
>     plug into swap_iocb / swap_ops?

I don't think that is the right layer.  The virtual swap layer that is
currently in the process of being upstreamed is the right level, and
the actual swap devices or swap files are just a dumb backend for what
they higher level code does.

>   - What role do you expect zram to keep while the legacy block interface
>     remains: current block swap only, or something else?

For now we'll need to keep it working as-is.  It is heavily used in
android and potentially elsewhere.  Once we have zswap fully working
in the virtual swap layer world it might make sense to say never
compress again in zram when REQ_SWAP is set (or maybe a new
REQ_COPRESSED) so that we can use the core compression code without
breaking existing setups.


