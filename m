Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEC6C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 03:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B0E6B0095; Mon, 21 Jul 2025 23:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DB76B0098; Mon, 21 Jul 2025 23:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CEA6B009B; Mon, 21 Jul 2025 23:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C97D16B0095
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:04:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A2BC578AB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:04:37 +0000 (UTC)
X-FDA: 83690407794.28.BDEC8DB
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf08.hostedemail.com (Postfix) with ESMTP id B213116000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:04:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMPA1BEo;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753153475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p63N5mdRCPJ6x//6L+/3sLsATx+F40hwdqx94B4OV24=;
	b=yKtljc0KeYMv5dB8xGtp4ZP1XLsdZhZM9usKCKaz7G7GO5Ec38Z/hbe/I/jnO1QNw/Jkin
	T5FqtF4f4V5p5X/4+OJtccairZAVGR4sNmH4luEzaB3af2Mhj33dZRVEZeo+uJmduxYe2e
	3ZSVkNiIvy+AXQnMSrboAeZjol4U9lw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMPA1BEo;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753153475; a=rsa-sha256;
	cv=none;
	b=cZ5eHu123/3g6eMY80n8/yM3qeKu9D57cD15ec/3tpiGQPzqFN+dJrGdmzENNw5h2XuyHf
	OBTjzjwGKnUA8sWfjM44umHFyxanuhcwbOhrA3gXp+E/vJ7J1w6ef+OLNcuwQ9zoIOI+rB
	Av08B7rfulKUKqj/FS6F49LP41bd8ZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 04BACA55E65;
	Tue, 22 Jul 2025 03:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EF6C4CEED;
	Tue, 22 Jul 2025 03:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753153474;
	bh=1vu1a22AWWwZkHho/rnSIgq17cO+xwEhtZK2Cpr3X8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMPA1BEoE0LY9kjEl/GoVYAvIUSlIA+ToqWKUWbCxRNxVoZKSNofX0m2mClGpnLnt
	 twggXxhe4aSrhPWFZsJCyWWrPo1NaUUSQhMAEg2/OL0Gc0PLe3fkl9rtDJbC2/JjXI
	 JL3CRlG/WjD2ilLPCtL+Me2tcgguGVpJYurgTjtv1obzf//LBriPxuNMjunihyt3zl
	 IDfT4z67gV07G5hNGLx0PlGH9QYbcvlYNaC8gyNTITKoVzuWAATu10iTswVq7vR9o7
	 kHhFFKQ3Bt4PlB9ex+bTZasNdngo4NroA0YbsAKkvCEtYXuDV82MxdnTPBVPgJKbfW
	 ZQjfH9zsCl6LA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/ops-common: ignore migration request to invalid nodes
Date: Mon, 21 Jul 2025 20:04:31 -0700
Message-Id: <20250722030431.56507-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250721195658.935f5e2436045cc311575c9c@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B213116000B
X-Rspamd-Server: rspam06
X-Stat-Signature: sdeabwu68pcsrr6ihmzt3juhwjpzb9bm
X-HE-Tag: 1753153475-726571
X-HE-Meta: U2FsdGVkX1+ShEZt+48clZ6qMybHC58YjV38LzKb9KrTOOeDlpAijSjXc5IK1gSYh0LrdV8+yaKMBMMvbv72kHvz5LUTRczm0nk1AMHg4mjCwFn7/2yK+JXJCC6hONbkW0pMdsK7x95rlbv/lZqot5JlbxPBPBXbNA7O7+xrFBfEFFqWy4pAa4S05m5O52uSQ2o1j57Fo1txWv1k6x+N1KiyaxI3qWT+WKc3hPwe+o2V1+LV28ysKC53oO2t/rHXev4RgRoVV7gw6R4sKfKWTvJ0AD2CAhMoNW0kTcWWD+2Ie+YKCN35K6wA6jyisfb2/e+d7kT91XncBvOQftWW3dDuQ8eZ8jwD4G2NKaXjGSWblPBhwf4GWCqDnVKrnr/RRMwxgINJZFmPdlqzNEIV8zmxc8BhUZnW/Pp+zwPLc8nTgW8DpNG53I8KelBw0k4tNkgwEMBI3K00RITdiCNidA9yWMejpDlV8HyA6GNoUkJS2Kv9iWA4OH+smLMnFxCwZcrHDPT8pG1dMspFTjSOCQFUGIbVPRatV8V9jGpfJVUZKuBWhuD9HkTKz4f11wVLMoFkEdPcjsCjYFycF+dcMdneeTAKbQHIEAFHF3tKgsbBu18Xl40fNb5esz0Aua0U2scvVVlpGopB81nmQpwhnch5FSsGvpWXcp9WEYrH8BPO2ouAqxlXbEwWyqHqzsbfkPAqu74rwm44wzm2+6hUazJsC+NqiRSljih66zwsV8e8s0Kf79mzRSfryrIPFAWuq64xdffO7cHL/ACnOwUvYQ7LBs8dY4q2Xmh89D+x6k0jxpHcVxhI+v/LLoX/OiSXxBlZms4ntDG7QmeRHbpOep6GrLVMkcYGfc6PuLsyzX3SCeseimVJh28MsiJYvz0mAft5cm45BkSY6vULUktYbf43/0jPuO80DB090PDGvVxZ4IIhRyrl1lxw2WWSndUcdYmt2Tog1EIIELAz36F
 pnI+/7UP
 K5nrMqswVwQRDpwXEe8wr9FqUjy9OQmE0KsFnhLsDqoYr+nJBWgzeIfjZWbry6Mtf1CM9VSr3ZbIoeTmpJGjQkqO2Bh0xoxdSeubmCSRMwZmR88YYRLXq2+wEe9wUcvlFi7NRxZkqNwUjWzVHdX1Uy46qM4mlKs/Ex4C12ss36WtHL5MYn8zBYhKBLm7804fy3rHMZxGfmej3zI6PBAKuFvAgS7b4o9xCibTE91jbw89tDHGlcwF958BAk7elScOF5p/dlAFBqn2Ow4ICPU5M4hXbkkrxcyzjkNdW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Jul 2025 19:56:58 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 20 Jul 2025 11:58:22 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
[...]
> > Add a target node validity check in damon_migrate_pages().  The validity
> > check is stolen from that of do_pages_move(), which is being used for
> > move_pages() system call.
> > 
> > Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion") # 6.11.x
> > Cc: stable@vger.kernel.org
> >
> > ...
> >
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -383,6 +383,10 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
> >  	if (list_empty(folio_list))
> >  		return nr_migrated;
> >  
> > +	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
> > +			!node_state(target_nid, N_MEMORY))
> > +		return nr_migrated;
> > +
> >  	noreclaim_flag = memalloc_noreclaim_save();
> >  
> >  	nid = folio_nid(lru_to_folio(folio_list));
> > 
> 
> OK.  damon_migrate_pages() exists only in mm.git thanks to 13dde31db71f
> ("mm/damon: move migration helpers from paddr to ops-common").  I
> assume that you'll send the -stable people a patch which adds this check into
> damon_pa_migrate_pages() when called upon to do so.

That's very correct, Andrew.  I am planning to do so as soon as this is merged
into the mainline :)


Thanks,
SJ

