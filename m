Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB93F3D5F6
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 08:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8814F6B008C; Sun, 29 Mar 2026 04:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831EC6B0095; Sun, 29 Mar 2026 04:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748046B0096; Sun, 29 Mar 2026 04:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 64C1A6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:21:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB4281603F9
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 08:21:40 +0000 (UTC)
X-FDA: 84598406760.15.A5D94CA
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34ABEA0005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 08:21:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9Wwy2EA;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774772499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtTGmq6mxA5M4Te1SDcD+20cKbTRttxCNlc+5BeOn9Q=;
	b=8ZorQNJH4YefpNNMjv2W6bNy5w8avY0d8IgrjFTF9QpKJYV4Et0RLpXbBdkLP2fRS9az7u
	YuRv46c9adgC6j1tOONEZIUxla05efqRzHxxUsAN7jw2uUEa8pi0qopQfYBo8o02JSUg/p
	msaqTuVJtBrM2wjIRqYzLBFyvN8huQs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9Wwy2EA;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774772499; a=rsa-sha256;
	cv=none;
	b=doBxgVP6ALDwTAwbdmjPzxZ3qrISxII6ecS1bNkhlCyU2qgyP1rFe7w6omy1o+NwkOI8fd
	atry7l2NIGI30HNROcmHgpr4UlEA9kiTwAKPnmukQcgk4aVC6jdJSuZfOCmMefOj7F79Og
	cuuBrZ4LSY0Xxw+CrWt06EPgcG4eU+s=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82985f42664so1977968b3a.0
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 01:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774772498; x=1775377298; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BtTGmq6mxA5M4Te1SDcD+20cKbTRttxCNlc+5BeOn9Q=;
        b=P9Wwy2EAhrNFbUDnrdot75ExFJxaFSsr9dIIb2glD8VpZiD32aGNcl0niH1pD49tWv
         r9U3DN0dhRRhIH4C5z0wLld3J6USPJOz42MCATIbHTXLuxknZQ20fEZ81gxhIscDD2XF
         dQ0wEGDPO4X0t0tQVVvUi8Bz7LP3kuwJGQTmaaQ6eeFNNnFeE79b0m0OfULGL8Y1Osep
         z+N1qnZ+UWor4kcdaxYYmQvRt/aU/YQUGAwNXnGNgMShx9+WWA7RAQrMED29qQ/Scabs
         HZ9P83k7Nn33UhyjV2X8/ZzkVhH+EQiUXZ1CvHZM1SolFWYxNorqFLlEpYw3qXl5O7VG
         +FxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774772498; x=1775377298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtTGmq6mxA5M4Te1SDcD+20cKbTRttxCNlc+5BeOn9Q=;
        b=ckibPb8hBuS5cwf12HZoQUnDNhn5cvWpkdRdvoZcWO1XB6f/YJa2Q22ldwVrrrto2Y
         r2rSLRvoyczIjIUeqKpTuLsyyzAAKgzrdq/R+as7bjWjhbLOKVsefPkg8c+wWoMJfpNv
         Nj0ScMI0GDBuOQNfXjOoieBMqCPN61KU6JL/7yrhZbK8GTggm/1+BNHVZYMwV+Cg+xvH
         CEkxeYwlbu9N+0wHflwMFugT4QYU+PqVcn6/wLxspBOC3Rbsr3+zg/B5oHjhh69ZSISs
         jU2+V7C5XHlmxoaApcIiPYI1h7WGbiqGcXfePzkMLk5Q4ltkHibOCelOcLrykqrvV5g+
         rW6g==
X-Gm-Message-State: AOJu0Yz3++lQVpWU4ME0GFx7qQJY+6IvbNpWdNwY9kjA0JYZW/b7W7AF
	pyOxMBHzpP3HU2Kb5QUt68qiI69QmqaT9+rBpY+ZfGecHjQ0TQDagFwQYHJo/bjk+oWKpg==
X-Gm-Gg: ATEYQzx8YRPE18PVqQqbS8zeszVBGf8Cry3y5WnN/6T6sX5P7Q/a87H6RZKRqpQ+Hr9
	cp+jRNSVhuAuqXQlBkUvT8y7XmVCkYq3EIoreebVJUVISO72iDtl423gbQ0zKBeQ6dMisyVP4PX
	fOV4NzZi9yf8TpXrNrYbUB9MHbg/WQeNVg//9iJeHUXeSgsXp5vi2yzqh5LEfXHbIy8bXm/YfYY
	uBlaps47qifO4mYIS7/Wpd+LyFPxGGEpxceH5DX1t5ahfeSCxIJHOCidyF4P5y0OXRpPXEEg2Yx
	W7sTimx0Q4qPyTYiwG4w7yltRdB+zsgZbYNK2R5Tu4jcFkFFARrgK0IsYwWr207XfO2O0ef7k4W
	ArpJACmsOoscA8abZga9E4FYe6JZEGbbiogA9NaAQ44Xb7R9xqdWoCU95vZVBmgJbOW0pPmdaF6
	lvx2oIqsuVIqQv7q5kUosdGBhNk054WaObEFkQPpJ08g950jx0xIE79q+2UqY=
X-Received: by 2002:a05:6a00:bc90:b0:829:803e:6798 with SMTP id d2e1a72fcca58-82c96038f67mr7975297b3a.56.1774772497553;
        Sun, 29 Mar 2026 01:21:37 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca843db09sm4386606b3a.7.2026.03.29.01.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 01:21:37 -0700 (PDT)
Date: Sun, 29 Mar 2026 16:21:29 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: kasong@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
Message-ID: <acjLfIeCFcX7ZEQb@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
X-Rspam-User: 
X-Stat-Signature: w4nxxd31ogpwykwctbi3d5x1jydi97dz
X-Rspamd-Queue-Id: 34ABEA0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774772499-205346
X-HE-Meta: U2FsdGVkX187QH4kUsQAKmA5M1g7t1MT7dskfZWLwaWWNsRFkQ/YdE5nt8sObUI6HbkwqhDATQuUwnCS3u4UY4XSXspOMqBsUlcIQcNSl4DiQHHAJ4N2LL6168XiT1eEVytpcg6IP0HBk0hkfY4OUd3+8XrqQ3amLTWnpgd7AfpeGwh2XouBHjRbMeDWDW4g/ZABEZX3SaP4hRsp67fQMFJkaXP76ILAlFOBa7URmymHl3es6fuFaTV2+Uq1Yh1MB51XwxKNOmgrncoYuiH68Q3hyr3eFKB5vQC9QiOy7+FpqUkXKDpXAoqJX1Ox8tP+1kxyDzYCzOkpeqMVbCkBJ9x2bYbXut5bd3zxCgsCAIRXekpT9TppCL44/M8h9dIomxDB4PMDhY6U8EqEjUTecu6CYMTSWkLPPDwq7m9RZFmN6Z6JUo4LMqWZHPc9KkV4y9KaVM9a8/HULxdM6x+82dCZ1cqLUKzcQOLiXDYMKOVHbiLkMifAXMiCHfECconGs5Ag5QEV0GUmgOFCVykm1apDVzFKlFTmVZLBqmqEmlkSpl8wAkLys143TX/m5oxE6aQjPRxSEFAHGYkRApd/+DK5GF3AxqKirpn6A8EPbGtxvBxmjLe4G/Bl+cO5z2cmVFx0+nxOpEe39RSyZaOPERcmhwkA/0gIRrA7rcN4F/urnTSdXwgkzJ9KnBrHtdcsswGw7f6EavO2mOkAHWhBbnSysY3r+/IqzNRBNvKEqUooYwL4pDxrSvwDDqAGBwEBWJfGJGEU2RUHxOD6aZGLFtHcVZVaLPWiiCpoOX/hDe07/VkWwwurF3tbnJJPmSbqal9QiznXoW9sknskVZKFCFxFCJ2Iae1101jNjktYXi2ZTraBBaI4EoV/0qjJQq3WQqLTZFzTeF6dUAjgjaDgHFpm+MWjuCDau3F+7ZET42SJp/G3tLuWAl1vWbMkjmDse7jhbbXTpSHMWsyjd8o
 pgU7EN6l
 GU4S4Xp1/bylZtzqPjfv/2e+BSW4lgBkEkE9Aq2rf6c4+G+/Ae+bSDF2HcKZwbHHt21w8iOI8se2Zi0Spe1L9cJWI2zKyfOyzNHqolzMe/+Y2ISGLmWbZsvPRwHBwfVB7XVOLoC2ohJ5cMgzhChMEEsId1YH2qgZV/MgB9mUhzULME71q8HduETCvpNNfAWaZZbbUt1eLL+KM0NlZ4AhGbQoeBkZuS4zeU0Rk9QcPVBk8+8ER58WhdF4WXV16rk4fdxXkdxSroIMAMn+oBNME9xjCNy/Hy+KhQC9Y9cpmavq+f3HzaQt5r2g/JWIhlPyrtRBVbCBeRGnLaSX9XmFN1w2GXLUOgbUwRYXhlB1awXy5Tt3KyXdGFTp85LsQ1wWyDf2ZJdYl+7Hjc90kr/sgHJmh8N0D65jEw93nEyPNuK8vuUQLP+9U2H4+LYbxV4aSUZK/1JdItzNDSiiiG+bVuFeu3JKjjPCF4fo3TTfX0AaaGJjH1uJmmURAm1bBAu0dfOUvd74Fhzaf7II9FqkfRTSfBE4HSZAY3SN5BLUObX+82ho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review:

https://sashiko.dev/#/message/20260329-mglru-reclaim-v2-8-b53a3678513c%40tencent.com

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 8de5c8d5849e..17b5318fad39 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
> >  		return true;
> >  	}
> >  
> > -	dirty = folio_test_dirty(folio);
> > -	writeback = folio_test_writeback(folio);
> > -	if (type == LRU_GEN_FILE && dirty) {
> > -		sc->nr.file_taken += delta;
> > -		if (!writeback)
> > -			sc->nr.unqueued_dirty += delta;
> > -	}
> > -
> > -	/* waiting for writeback */
> > -	if (writeback || (type == LRU_GEN_FILE && dirty)) {
> > -		gen = folio_inc_gen(lruvec, folio, true);
> > -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> > -		return true;
> > -	}
> > -
> >  	return false;
> >  }
>
> Could removing this proactive promotion cause a livelock and premature OOM
> during GFP_NOIO or GFP_NOFS direct reclaim?
> Without this check, dirty file folios fall through to isolate_folio(). If
> the reclaim does not have __GFP_IO, isolate_folio() will skip them.
> These skipped folios are spliced back to the front of the oldest generation
> list in scan_folios(). Because isolate_folio() isolates 0 folios,
> evict_folios() returns early.
> This completely bypasses the new wakeup_flusher_threads() call, leaving the
> dirty folios unqueued for writeback, and the oldest generation can never
> advance.

This is a nice found. For GFP_NOIO (or actually !__GFP_IO), we also need
to active and set reclaim for the dirty folios. It's a narrow case though.

Following update should work:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8170aee096e9..342ba3afe77c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4641,8 +4641,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
        /* swap constrained */
        if (!(sc->gfp_mask & __GFP_IO) &&
-           (folio_test_dirty(folio) ||
-            (folio_test_anon(folio) && !folio_test_swapcache(folio))))
+            (folio_test_anon(folio) && !folio_test_swapcache(folio)))
                return false;

> [ ... ]
> > @@ -4858,12 +4840,27 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >  		return scanned;
> >  retry:
> >  	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
> > -	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
> >  	sc->nr_reclaimed += reclaimed;
> >  	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> >  			type_scanned, reclaimed, &stat, sc->priority,
> >  			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> >  
> > +	/*
> > +	 * If too many file cache in the coldest generation can't be evicted
> > +	 * due to being dirty, wake up the flusher.
> > +	 */
> > +	if (stat.nr_unqueued_dirty == isolated) {
>
> Is the isolated variable stale when evaluated on the retry path?
> If evict_folios() jumps back to the retry label, shrink_folio_list()
> processes a smaller list of only clean folios. The isolated variable retains
> the size of the original list, while stat.nr_unqueued_dirty can only be as
> large as the new, smaller list.
> Does this logically impossible condition cause any unintended behavior, or
> should the check be moved outside the retry loop to avoid confusion?

This is fine, stat.nr_unqueued_dirty is always smaller than isolated. The
"retry" label above only used to handle some folios that are failed to be
reclaimed after isolation. Meanwhile I do think we should clean up this
retry logic as it will also confuse the tracepoint. Better do it later.

