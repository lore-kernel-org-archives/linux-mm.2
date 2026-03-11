Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D5C1125826
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B5C6B00A5; Wed, 11 Mar 2026 16:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05476B00A6; Wed, 11 Mar 2026 16:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE366B00A7; Wed, 11 Mar 2026 16:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB3C6B00A5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:20:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33AB916039A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:20:42 +0000 (UTC)
X-FDA: 84534900324.10.AF1BFA3
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 89BF1C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:20:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mpNkqc7I;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3yE0fOt9QsxeZmuU8QoQzZqCv9ze5YFahl5XE1THs8=;
	b=1YCOmzov9Sw4tJGKN87GzD2K0aWvu3j4vuby0ESBZI2weelOov4tlg1oSgiyylSQj4i7wO
	kRNzyb/LbGQi0PBTokPjCucfqPiYjri45TKk/gp3NDMlWocRTu/2gx45PG+XZqMRUaMZvx
	Hev8LX3DZ2qxQG8TbFyqi2oE9eq8nmk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mpNkqc7I;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773260440; a=rsa-sha256;
	cv=none;
	b=Si97hsDEpyldljmukUFzAe90FryQiOKIi95LVGzw4DP3kKEanMAuuqAWE2uA9mUsGGmr1x
	wiWLWo0PGUJunRI/pTVHzBVyIKOABFnEKaCF4zeg26+l7BjokN9mvGD+KZFxGMWyy8jBHW
	SeH5YkWiq3IpcuewNSv5ttjyOqJ32+8=
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-464bc03efd8so231865b6e.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773260439; x=1773865239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3yE0fOt9QsxeZmuU8QoQzZqCv9ze5YFahl5XE1THs8=;
        b=mpNkqc7Ik6TSSbDFS6WUw8soNvUa8fzPvCqq4mJaQ9xTaWiGjf8FTsVmhj6g4Gh64o
         3O15foKjIFVQl45mennlKexmHPJPXZgWm0hLS+1uzf9ITIRhbRNEa+TQifAaqZVUYhTQ
         89F957yS9oCQENCThPcHovu2UzUjaNhSa+qp21ofK2FiWagQ/cNC+kuUm4ASOS98jD9h
         O7hoXZNyT0YPE0x/wgQqP90BCj6w8nvoLVd6e4BrQdhU7cIZt4VtcmCfhka0n65WLC5U
         Zd7J+NTMdp6mZ3aZa7IMiBzYMNUXFfoNalYDBLQ2tWN9zKC8Zpz2Fh1g6HT7sYEYnjc2
         1yCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773260439; x=1773865239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L3yE0fOt9QsxeZmuU8QoQzZqCv9ze5YFahl5XE1THs8=;
        b=C94WbPzL/0WbwOPS2GNOaaH3+JiliB3+mHvHRH76D2W7QOuD8gX5Dj5y5120EXAVqs
         VJHwPiN9tkrNXbRJxVjOHzSJ2B9MArOGUGcXFUic1D070bsOSUeCrVL6qaLXUIusgKUw
         Rsszg/4h1bFslLd/lAUjrpD6dF5zU7TiCg4nVMsnXRPiMk+gfAlCtzU3NYQeDLSia7r0
         oudUTgoKWCh+KWmK0tFvhYDdlc8wfhOz8Co+hSdXq14GUTY/2siY5wJPXrHm1R6chDEC
         CQfar2tUtupBz29dWThVhSaIPfj3yVbqrGAcJXYjs0oEcH2ug7gmPtd0iaOO9Njod35h
         hrvw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ5Njh2k2bwXcaLhJ72RR8o2PP9AQh/2Hc+4wspfFNuR04vP0I9xcyVsG/+/t8FmlttBmkAGAe7A==@kvack.org
X-Gm-Message-State: AOJu0YyfrTeghD4xO/kpR4Oz2Zya+oni2HcndyNveCunkJY+rHGdurkK
	TB8P07t8EmLCdJzM175OhbC7KgMnQuBgLFL34MgOucwIy0tbRRTYqUW0
X-Gm-Gg: ATEYQzx3sY/qeQS1KHQ3PSLNSuf5MDPG/Z9pzoG4ujdt6yRi6bDKkzZszSfUT1o3eSZ
	awYijdZ69kIJ5oJa5cAyb4sDHUx/nyaX+o8PU0BE12Lmq7FDFX7vpFXpkxVQddbbZBTl0NPIslE
	e5SmE+h11cnxa9FiNs0x4nXs2A8zR9M4NWGtyL+4BC4eLDPwzXGRwvDuXoU61Y2I+rORo01GFqK
	A/YOjQjgm9Jz2oEsLKqauzBnE+2r8YFTlDc28W/J+ztUDzSbqHPofB15KMWU/cgP/QC6UmCKxUz
	EhQ8KxfO+rS6tyr3mZeITcy4lgRnS0cUBjKYa74iMgMExhIuXBWAlmpSvDFGqO5bpXFI/+wWGxx
	BHijlvAqd4ExLNpYZduLxfeAUSI8aZpOS2YJsUwRTEZm4oCrg3cJvt+9G9hHbbCRfEcUdVhp7UG
	lIpr7zkqBNKRH0LkIWS6MpGw==
X-Received: by 2002:a05:6808:4f6b:b0:459:b569:702f with SMTP id 5614622812f47-46733431a6emr1950640b6e.15.1773260439503;
        Wed, 11 Mar 2026 13:20:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467342c0382sm1914583b6e.10.2026.03.11.13.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 13:20:38 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 03/11] mm/zsmalloc: Introduce conditional memcg awareness to zs_pool
Date: Wed, 11 Mar 2026 13:20:37 -0700
Message-ID: <20260311202037.265101-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <abHNog8CV0mWummY@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 89BF1C0005
X-Rspamd-Server: rspam08
X-Stat-Signature: 7w48kcdnzyinjo3yh4r5r7utybuefkzs
X-HE-Tag: 1773260440-711651
X-HE-Meta: U2FsdGVkX18u6wPkXEZR6LF3bB9M5r5NFwVOtJruf+onZQB3t9OI5JLA2Hhjo3yA/GxyGC9fsQi7c6RMsGQrAmoS4hD/ub0fgP96oRoHLaxj9nRlUuslIQuMi3nyW0t+RTGVbMyrERXIIJUnmS4L+Y7evr4d1o7uqaVL0KhpmsJ4QPcXPptfrY4LyA/pwYw6dMc+QMrL0bQmqjX2ctp9y6TWmOqppWiyJAWouHZcgueysbBCsMjrs4SC0+G6V4fR8kQGr3K8xidPuJcKDK3lT3Fu6noWsC0a5cbaBsgALwcIhXIyPG6k/mNY+yNDg3xMel5PCKaKUJSAXwN0tpng4ou6vtNxVPULuDlxOJNNX/AtjboU+R2mcdsv60HCmm0xPBt3k4d+83uf+uLKkqgppwEbRgClmtuXHD4p1j741n27eKXeQIgKU5gupn9VBTmUz2NZmiNDd7jhnlRe5ND0hezU0EFgRdMj9HyLE8/ABrdB5F7veuPqLyHwfHgB+n/pxay5AbIv9t1logNCKasoR1vvb0q9jLOSgT66CrnJGzlt5LLKZ9Bvq/QU7Lfc9CpB5cX9zNkb/QAdhXqAlvyjXxjuc5IqCcNEXW4wZMAkdF0x+BrBPZHb9RZHlQzktvz2usmxYYekJAabiLG8b2MWIBNvEfiMvEtbOslY3fE2so8QItGVbaq4WsbtNE1gJskYiirfizhbZq6M1ltfkrpM05XdTIa5MD5TuAg72hKRyJ/RxelOtiTk/zcNRLwDIaiOR3KWzFWKTw5TZ5CjwmLkzD0Lyi+Q+zYUe/ym70wfgNEPhITlDcNCDp3THixlHdTkeMWSqfgViuONip1znJycAEpKYf95dvBtqw8NxvIxDMFTudDVK8GRV5TVFG+46Ds/VqfnEfKp0sDwEOz0NCxVFEiszpL0vPJbje4Fa4gBWowSTjhMdXqCUG2n7/2Bx8gfcVt+eBxVDaYyWFmwK5t
 wnGDPwyv
 hwv+9KuUun56qm1dZni0wxz7YCso+d0uKdJui0yVH3R0XdS4HlyjRp60UiwvNA1XafVFZp/NCDKOnQFD3RpYQ95b5aR9JoOTVHIQcNiaryBIKPJB1kaAsB6ExzMIZ2U5P2TIvkkaMqTz/tdh2PdwZQM7F+nHF19KPM57OFIALOy7/weTpaXliqaBndw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 16:16:34 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Wed, Mar 11, 2026 at 12:51:40PM -0700, Joshua Hahn wrote:
> > Introduce 3 new fields to struct zs_pool to allow individual zpools to
> > be "memcg-aware": memcg_aware, compressed_stat, and uncompressed_stat.
> > 
> > memcg_aware is used in later patches to determine whether memory
> > should be allocated to keep track of per-compresed object objgs.
> > compressed_stat and uncompressed_stat are enum indices that point into
> > memcg (node) stats that zsmalloc will account towards.
> > 
> > In reality, these fields help distinguish between the two users of
> > zsmalloc, zswap and zram. The enum indices compressed_stat and
> > uncompressed_stat are parametrized to minimize zswap-specific hardcoding
> > in zsmalloc.
> > 
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  drivers/block/zram/zram_drv.c |  3 ++-
> >  include/linux/zsmalloc.h      |  5 ++++-
> >  mm/zsmalloc.c                 | 13 ++++++++++++-
> >  mm/zswap.c                    |  3 ++-
> >  4 files changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index bca33403fc8b..d1eae5c20df7 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -1980,7 +1980,8 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
> >  	if (!zram->table)
> >  		return false;
> >  
> > -	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
> > +	/* zram does not support memcg accounting */
> > +	zram->mem_pool = zs_create_pool(zram->disk->disk_name, false, 0, 0);

Hello Johannes,

Thank you for your review! I hope you are doing well : -)

> It's a bit awkward that 0 is valid (MEMCG_SWAP). Plus you store these
> values in every pool, even though they're always the same for all
> zswap pools.

Agreed. Originally I thought of removing memcg_aware and doing a bitwise
OR check of the two stats, but thought this was also a bit strange
(also because 0 is not a valid enum state for memcg_stat_item anyways)

> How about:
> 
> /* zsmalloc.h */
> struct zs_memcg_params {
> 	enum memcg_stat_item compressed;
> 	enum memcg_stat_item uncompressed;
> };
> struct zs_pool *zs_create_pool(const char *name, struct zs_memcg_params *memcg_params);
> 
> /* zswap.c */
> static struct zs_memcg_params zswap_memcg_params = {
> 	.compressed = MEMCG_ZSWAP_B,
> 	.uncompressed = MEMCG_ZSWAPPED,
> };
> 
> then pass &zswap_memcg_params from zswap and NULL from zram.
> 
> > @@ -2071,6 +2079,9 @@ struct zs_pool *zs_create_pool(const char *name)
> >  	rwlock_init(&pool->lock);
> >  	atomic_set(&pool->compaction_in_progress, 0);
> >  
> > +	pool->memcg_aware = memcg_aware;
> > +	pool->compressed_stat = compressed_stat;
> > +	pool->uncompressed_stat = uncompressed_stat;
> 
> 	pool->memcg_params = memcg_params;
> 
> And then use if (pool->memcg_params) to gate in zsmalloc.c.

These definitely look a lot cleaner. Will make these changes in v3!

Thanks again. I hope you have a great day!
Joshua

