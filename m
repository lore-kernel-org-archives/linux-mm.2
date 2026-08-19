Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52AF9C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 04:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76196B008A; Wed, 19 Aug 2026 00:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26B66B008C; Wed, 19 Aug 2026 00:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C566B0092; Wed, 19 Aug 2026 00:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A56306B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:17:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE64B1C13B5
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:17:52 +0000 (UTC)
X-FDA: 85116710784.07.C3FCE41
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2C331C0007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:17:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hp6hAJjc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787113070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIurJflnvFF91DRPSkKVXaQAGarfbqju+vgf+4SCSCM=;
	b=Il2miV9ZpcUkxG3NHDfQi3BoylWMWrdf/rHupr0VnpMth5dPL2ID8Fix0fjPBcaA4nFxE7
	YmmxntvvAVpe+YeKMcb77jOfLjLwwrEu/WpejdNkK9NPITiuWvpREyK6UTWyKZw//F6IVe
	alNCudk1fhYTcRT9R4i4V5mPtg3MMKo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hp6hAJjc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787113070;
	b=a7PgenBEc6QN+BC5M24htsXqnTrmlJFA2emDY0vJibYtfbUTGJePD6gpd2FCreNK+8jQFu
	/PX7PLEDGzTUVaoT1K7rFux14mVXbSGt3GbF25jCgokeB+wBeKrlgp1U3LnkJSlf0KHcAb
	HcGKhbxUrTb41LblCPwFDZH23FP8+m8=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7f3fd905828so438912a34.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787113070; x=1787717870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FIurJflnvFF91DRPSkKVXaQAGarfbqju+vgf+4SCSCM=;
        b=Hp6hAJjcCK1F6Oas9fOV8gSRF4Z6peICvHqGcZZxGqQCYDpDkQlHJdDMKbHXT25X71
         3f2P1E7zqx2wfmM//QETRRLd6X0kc5QBGTBfQkBj0LmD4dsV0V1aA8CwsZs8aEug/xW0
         NJTCCbJgq95ihkL9W3wsN2er7dTEH/xtKBr6ajLAOGEvqIFKRPQGPjS12s2QuJnL8RhX
         FTUQgvv4iKozXJz0Q1Q0IK0EiIqtOdpho3nxNd2FPpMjG7pNzew6OSGYSbdG0xijjluM
         /f0gEHG9sWH9nBJQvEKG5/1aHig6ZnPiaKxkfwFuqjU2EJAa9dYtXwIEuNYseCokxy5C
         hllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787113070; x=1787717870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FIurJflnvFF91DRPSkKVXaQAGarfbqju+vgf+4SCSCM=;
        b=qh3RvRb72nzxmLcFXMw3T2FvG7h1i3re6r+miFNYYcTnvCRFQKovxyPfvzjFZgF0GZ
         xslLCsiYJykgwk4M2dQ6rxgRktNd6nQ4wBS+H417Spua6GQH7VpBTZPFzQUDs1GBjwPo
         u1Od/nLIOaoi0AotVkTv2g3UbaFco/Ip+MbuVwbpytJ46yvV1lGwuwckx9JvOBQukolh
         e/bx5415V7j9RD+3GKnsrV5bKj+aVIwKtjyMO39+ATbpGZ+mHNuPI9pSX3iHHBLYGByf
         51tofCnJ3pr+9CivKPleldlKd0f9Z0VlC4HNx4raFcyKRGugw2mPwDpjqKGd2Hq381MA
         kvig==
X-Forwarded-Encrypted: i=1; AHgh+RoHivVx13+ePCtmDgtrnNuzh1lHVtmiodjZwURKeMjZXUWL2uE3r9lTc8n6Govn0rneBnT0T+x4Ng==@kvack.org
X-Gm-Message-State: AOJu0YxQkQzUWsItlLHO3xcuiT4aO/N1MIcYqR+CCxVMmsZaqnYmNAkr
	gxDawTj+K9D85jgDfTQbDEdwAhuFj49nhUM40chhw+BDnDv54XIVHDUx
X-Gm-Gg: AR+sD11BRlsvR9WijnO7v+hBIzPK2f4Gy2QkrafTGWP6XfoR8UR3BAupnQ6woMfclVv
	9INbbZPJeEgKyHdgL7ZgChL0C0W3QRzs1bwZcF727lmsXPUlm5Lqmusz8EBuM9LFOO7wUdlO56Q
	RwQLdhzywvv4SvpWSyjccWehYvQpbead93g2eQG1gtwep6Rk9PFLj0Rj5IhuYq0QoXAF99InTys
	AQHf9M7W2vN0f+lZ0H3j1YMuB+3jcLSGwZ5H8fZdOEHOMiN8FuLZlPUmmnrysjBZdm5Vz8d9VaC
	ZVcxY3VGm6+1Jcwa8F0fSWqR0tYgUtPDOz8mfLsJrzA6RecNJSE62frV6E44RY6Ht8zcapTYefZ
	PyFPVve7xnNlxMkqUhQkq59eHiIAQGeb7GFnnvgxbCCMHVrBllslxZ4VZTYc6zRN4lwDzV4NL7H
	4w+mAXt2Z18XSIM4btEWHNe+d2qKoKqMRw3CZSBP+5WERlg58ok274TAExTKvG5KuOfLuicojCD
	4f3f6FcrD7viUv29w==
X-Received: by 2002:a05:6830:83b9:b0:7f4:922:ee8 with SMTP id 46e09a7af769-7f43fae4861mr1800325a34.10.1787113069803;
        Tue, 18 Aug 2026 21:17:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f440022fdasm708924a34.13.2026.08.18.21.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 21:17:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: Re: [PATCH] memcg: trim the per-cpu charge stock instead of draining it
Date: Tue, 18 Aug 2026 21:17:46 -0700
Message-ID: <20260819041747.1111965-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoQt2zKsQT-rvjd6@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E2C331C0007
X-Stat-Signature: 9bpxdimkeiukki39tpep67m6q6bk8mft
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787113070-499285
X-HE-Meta: U2FsdGVkX19XSQsnMPOPU7No77PfpizAGC2vwJYH320LSM9bz++rV7+b3Pr5eZUw9mUauoMJ2ljivGaE8rsMqBXieS8WeurKQBlkKwh++jHNmxHbBHWxAcM6CpwM4GkfONeO18q6G3FDlyHL8IdOuysGjaMfoJtVhMjFABUBpXbu6u4DGCk2k4UIEujNEuBVsUQzgMNfWuwMlBYiOuVaisTY6TjSRKuQFAwl+DbkVK5UVGm04GEAZsrfIGeHZxaarBmhg4xeVc3+l9uMFYnsk1b+j43U+jmKAe69tx2ZYjN0dE3vq7qQEJBwN717XvT0mlKVNYp7qB2CaL0+LT4HvyaHwu8EjqGGa84fhZkTg2Rz9NjBn3kKZzOqC0im1hMDUitAuyx7IWwRQc2GriQPNskHxo9Nqt64L3KllZkEscVe3UxWzcUfa+GrBvPuKidm7e63Pa0qhAd8cYDM0ewImokl6Z6Dy1wBa0vtvePAI4dfmXJtXgl7MnTAg8k+a0g7p7PCn7NE1xi+0i/8ESOF1AwHGEYZGdwGVsqrKYbrESY93h2n1uKtxzJ5tw1ExL3slroAOutqi7Ny0CtRxiz0vlDrGJ2LQKbJAFpxKtpUpAlEj+ImkMIegc2OiYOtk2YyFEE7f4p3TJr86p6obMDELodCIY6n36OA28xPbZSpkejQo1vGEBmVBP0Lh98A8lv5cPRj3h6MxssraJnKX/AyscsZmsTjUvVVLPB4MU+X0Av0pzEcnc8Te7k7sU3suXU/+xRr6aPd/JSNaXnhomVETPt/TzQojq5ikxvhjJLZiPKna29akcJaylUfRpRPwmjFDe4madoAyzqsn3sg9T5UfJD4CCxuOIb+GwUwEJDWmjlqgblA5wNwF6GXvyXWB1KLacRqvRE7fAWgoR5s7vCWZQOGFYEh9NHptCpLvlihNn1mR/2aJGwJJ2Irhd+whEGc5d+Rx1PX8ZBBmlac/74
 SkfLRtTL
 67QKB8OF19PiWaJK8vKZ1ixoONC1mMhfGHZvTDV5J7ysET/LzjsUnRW9WVf8ywqDDb36xHL5nhp4wRd1aeVMJORWWO6v/qP5qX+hVMeyhb70N9Xh9cigf5im7QVMS/O0xBTkAYUgbEUmuCKVhiansDTn9O5EHHcAtOwKgx/LknyHqxv61uMRrb23UgS8OlU5sOlbx7afw2ofSzbwsaC2iv0tKHnGRAk/6kJUfU2Dj1l/efDesv520pVCBcKrTb3PeADcIGi6zXPmpvKRidB6W3H72omv6tE1I7R+Ab3ROqRRqalK+JCGpebn6I376kTCpCGNY6Lsm+9FgWJvCbLTPXH+IdzE3x6dqUBVHVH7L5Jh3+jNs4gWz0iDSzd7Q2KATxE76iFcAnQC5c4GgokBlzHWW9f/g4ZDApTdJb1ZSWxCCnW7P0qM9PeqRyayMhvtAS0jXbuYjfJUzkd6+wTT2VFnK90lHgmg+AACTH0qdxVl10jlRXzts9U1BSe8/f+iAQtFkXt2e1EDC1i6mrS58iOsaf65pQBkj8wO6Ba9d770xqXDA6wCG6yKo8xh/l6T6k3htcdAWHifXpBGzjMH44N4LE/Cr9fihEURe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 12:03:07 +0200 Michal Hocko <mhocko@suse.com> wrote:

> On Mon 17-08-26 16:46:51, Shakeel Butt wrote:
> > Joy reported that an application generating a request/response traffic
> > pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
> > for a range of message sizes, against 0.27% to 0.71% outside that range.
> > Running from the root memcg, where socket memory accounting is skipped,
> > recovers the performance.
> > 
> > Tracing the charge path showed that the application generates a pattern
> > where the write syscall charges one page and the read syscall uncharges
> > two pages on the same CPU. This hits a corner case in the memcg percpu
> > stock code that thrashes the stock continuously.
> > 
> > In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
> > watermark and the emptying target, i.e. on a request to charge one page
> > the kernel charges MEMCG_CHARGE_BATCH pages and caches
> > (MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
> > uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
> > and refill_stock() then empties the cache completely. With such a
> > pattern the percpu stock becomes completely ineffective.

To be honest I never really understood why returning the stock and
making the nr_pages go over the batch size completely drained the stock.
One theory that I had was that if one uncharging is indicative that there
will be more future uncharges coming and we want to make room for those
uncharges to deposit their stocks, but now that I'm looking through the
code I'm pretty sure that sequential stock uncharges are not that
common, since we use uncharge_gather to batch up the LRU batch uncharging
area.

> > Instead of a single boundary point for charges, use the technique the
> > page allocator uses for its own percpu caches, which keeps the watermark
> > and the emptying target apart: nr_pcp_free() frees between batch and
> > high - batch pages, leaving at least pcp->batch on the list. Add a high
> > watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
> > return only the pages above MEMCG_STOCK_LOW. The watermarks are
> > MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
> > batch. Peak cached pages per memcg grows from 64 to 96, the same
> > high-versus-batch tradeoff the page allocator makes.

> The idea is sound. I would just not increase the overall stock size in
> the same patch. Fine tuning can be done independently and ideally with
> some numbers.
> Would it make sense to start with MEMCG_STOCK_HIGH := MEMCG_CHARGE_BATCH 
> and  MEMCG_CHARGE_BATCH := MEMCG_CHARGE_BATCH / 2. That would preserve
> the maximum stock size while preventing all or nothing behavior which is
> indeed suboptimal and pushing charging path to a slower path way too
> aggressively.

I like this idea and I think you meant { MEMCG_CHARGE_LOW :=
MEMCG_CHARGE_BATCH / 2 } right? That way the only new change we
reintroduce is to always drain to a level when we return too many
pages to the stock.

Have a great day, Michal and Shakeel!
Joshua

> WDYT?
> 
> > Reported-by: Joy Chaoyue Xiong <joyxiong@yahoo.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/memcontrol.c | 31 +++++++++++++++++++++++++------
> >  1 file changed, 25 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17da1f43b7d3..ff7fbcd27422 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2048,6 +2048,21 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
> >   * nr_pages in a single cacheline. This may change in future.
> >   */
> >  #define NR_MEMCG_STOCK 7
> > +
> > +/*
> > + * Watermarks for a charge stock slot, in the spirit of pcp->high and
> > + * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
> > + * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
> > + *
> > + * Using MEMCG_CHARGE_BATCH as both high watermark and emptying target
> > + * thrashes: charging one page stocks 63, an uncharge of 2 takes the count
> > + * to 65 and empties the slot, and the next charge misses. The watermarks
> > + * are MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a
> > + * full batch.
> > + */
> > +#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
> > +#define MEMCG_STOCK_HIGH	(MEMCG_STOCK_LOW + MEMCG_CHARGE_BATCH)
> > +
> >  #define FLUSHING_CACHED_CHARGE	0
> >  struct memcg_stock_pcp {
> >  	local_trylock_t lock;
> > @@ -2223,17 +2238,18 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  {
> >  	struct memcg_stock_pcp *stock;
> >  	struct mem_cgroup *cached;
> > -	uint8_t stock_pages;
> > +	unsigned int stock_pages;
> >  	bool success = false;
> >  	int empty_slot = -1;
> >  	int i;
> >  
> >  	/*
> > -	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
> > -	 * decide to increase it more than 127 then we will need more careful
> > -	 * handling of nr_pages[] in struct memcg_stock_pcp.
> > +	 * nr_pages[] is a uint8_t and a slot's count is capped at
> > +	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
> > +	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
> >  	 */
> >  	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
> > +	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
> >  
> >  	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
> >  
> > @@ -2254,9 +2270,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> >  			empty_slot = i;
> >  		if (memcg == READ_ONCE(stock->cached[i])) {
> >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > +				memcg_uncharge(memcg,
> > +					       stock_pages - MEMCG_STOCK_LOW);
> > +				stock_pages = MEMCG_STOCK_LOW;
> > +			}
> >  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> > -			if (stock_pages > MEMCG_CHARGE_BATCH)
> > -				drain_stock(stock, i);
> >  			success = true;
> >  			break;
> >  		}
> > -- 
> > 2.53.0-Meta
> 
> -- 
> Michal Hocko
> SUSE Labs

