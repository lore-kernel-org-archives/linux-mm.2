Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFFBFF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6956B008C; Tue, 31 Mar 2026 05:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96A96B0098; Tue, 31 Mar 2026 05:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85876B0099; Tue, 31 Mar 2026 05:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6E886B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:18:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B7D65C991
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:18:17 +0000 (UTC)
X-FDA: 84605807034.02.2E42134
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 870BF160003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:18:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CJUiDad8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948695; a=rsa-sha256;
	cv=none;
	b=4E7EY0L/U0mb8Pn5aNXAgzrTBkbYykN69DLsmErQp/nCMMJWlDh+FWLWNfMVwKMi6fHgAC
	MVjf1WsC25J6JRGOxvqg0MfU8kqZ+eobCIdOHugitEmfz7jzgYc2a6Pxju5Zf7J5f7ts5n
	RaUC5bZ0eHt1f0vs7SBtGBXXALdgo4g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CJUiDad8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEdkmigAEVqczid4AF8EblZrFULW10CxExgl595pn5Q=;
	b=sp3iqY4ueBlPhfwfGGmguYd69E8ITvYefjP9diuPushS+leOgpgp0g7f8NyqvX+MDal/gt
	pcF2BSXGL23At1YHJgC3dHKg1/fylw4N7XcWNVcnswPWYpD9NaDjXDCpyKbMgvBxzkUYaI
	76Ta1dJWyYOVG6e6EL6dR7VY5dYwQ4w=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c76af7b0f94so484065a12.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774948694; x=1775553494; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BEdkmigAEVqczid4AF8EblZrFULW10CxExgl595pn5Q=;
        b=CJUiDad8p4B/YC684ICujU3dQLtl2lw9dCM2BcVyR3pjl4eTIIIvb+V+23WrMWRcFz
         TEjR/HMLjddYm4w4iL0q5kT9AaZ3QYc/lXIwyyInrHT4tpkpSTYJhVLKmRbIEg1p4m9U
         Dl83C+BaoMixhqIQoTwllYv3xOHWRYe/fHf4KtUS4sP+7F/HsqPr7rx0pUaDKxtiRab6
         /BIMRGqeyJbEikp7L5jZkfQD8jLbjsUIyLxo0VK93hgpHyKaA2G8JbeHFU7ALbhgJT7s
         HTZT0/pOgA6ttXES2uGdUdMik1JxFXRM3GLfLxxqcEiyi1tGlK7SWxQJt8yHTBJ8uJpz
         OEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774948694; x=1775553494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEdkmigAEVqczid4AF8EblZrFULW10CxExgl595pn5Q=;
        b=heRfJD78bavrBoB0J7j+bEbu9RGZ8DemAQsl7s8TQJhptP6ofykMSZMePgSbdwTTVR
         krtWhg7fYbXOlcRfUi8rnX2RLhu6oOCaD4a+C6YE47AKPsbnbf45JHPF6bOewqrEqgC9
         rxCtPnxJ+uVZhM3nLw4yWYWFDv78qYR8m9ULMNx4aiharCUX8gwqC2i/6PWqeRGCsnJ/
         Ir5CAUGoB/bo/QUi/QbmkzYwA61mVXQYueC1PvBKdlxWjfhTxJwelnCvnDMpnEz7OIzK
         o/zNnFXOUk31dZvLVnHOstNJEz9zaM+XlOmGD6Sov4zoF+eyx1BcKfDVqvtXCKZLDrZn
         j4Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWP1kwlWv6rzCQKX/waw+EmAx7vxepKR/OjIXUjpOSepqKmWfp3r0TUl5VQASQjqk9VePHWU3k4wg==@kvack.org
X-Gm-Message-State: AOJu0YyODDgJivrsBaNY73GJnb55VbsRKW9xDXqv2UGuVb5cGtB5QXu9
	fXjRm8Xwx5bZMBSIGLKQr4QhTEPrLSVleg14rtdHDp9RbgEuexeFAnIp
X-Gm-Gg: ATEYQzyWha2Lypk2LmKP2OxZWteyZeTOzu7FF25HsU36W2v4pXaKr8Qap97bbNFa3iw
	A6JkpWlYHzCpDobJVWqshM2fX4qnc9BIofbtk3kMWpwoVrv/188OWz40N7BLDbv58qM1zFUGj/J
	uD9m9bgrMP20nElmhW23atcVgCqhCQUiJ6vqVXq1uV71hGohkh9Gybthmgfs0XuJ0cJ8GsqqK2/
	jPLQk3wGoqwfMqFU+nHbHlnjaS6MiACAKv5rLEKzIa0MOG0CFCNvLBDgeuEFR0D+vQSix9+FSSo
	bs5J87don3fpgAuVIZMJOmzA/PMhBk2cLMfhMInOK3j+Ymv7MuOf81+nK2QH90KfazZphuUvI6q
	hsMflpYR5cJMr/SQKm8lLsq2ETp4GXPr8LCwTx1NeuQHT+XzXswC75t7asuX9ZNkE55aGO/Jc2K
	gg7ZSyixCDn6n4bJpY+wyndEH94WFEllwvzNEaoeKA39TIrt4SxtO7NBpkwg7amC4NFWdiDcCcy
	d8h5Sw=
X-Received: by 2002:a05:6a20:9187:b0:39c:a791:6ab1 with SMTP id adf61e73a8af0-39ca7916d08mr12865517637.31.1774948693982;
        Tue, 31 Mar 2026 02:18:13 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85fc72asm9765765b3a.48.2026.03.31.02.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:18:13 -0700 (PDT)
Date: Tue, 31 Mar 2026 17:18:05 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
Message-ID: <acuNtuf-mv3KJJdn@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
 <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
X-Rspamd-Queue-Id: 870BF160003
X-Stat-Signature: 1iofdjh7psci7nus48xxi9ji5pzbgadx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774948695-199098
X-HE-Meta: U2FsdGVkX19oCecjbEmKaTAXItxzyRMZ1lHmHbhrX2DAo7Ivg8Xqj7LA25K0dr4XSUHCYDg7DD6qOTnH28lVE3qlnkCoMvMOdAb9+a1/ZY4NQSKW93zunF88iKBJ3IL5s1Uzy93y116Dq+eJZf2OfNAdojcl6dEcY/TVmxf3YOcSVMZbdO+xRNScrqetkTNKB6Kt8gCUCtD8P7Pj8kQU/hhiAHkju0tOoEAZlVSkD4pqDA7ZNdFqYhIvbUUEXIaG8PC/ZFWWIeQe/tde3yiePYFNTW/0Twcouh6m90hR2IOz8wJVBepffhyzNXWP3Yah2CsH84uyiB80OZNzfIlyhNQBClqRAX2Agb/FQMnMBVSiG99ndZv1CIAfknKNnjymOuFY2Ks3b9ixjQ4r46BtnvhKl20LtrTrB4LQBEAoi/ozMDWu1qpW1I48m8/Qnq6HiGSbrGcZ5X5jLoIbkCRThW5S032PCEH+9R7RscNgiYWg/dAWu6pQCqBmqdZJXzFoOP57IBXeGPD4KS3ueWx54pU87ryUlZwRjkWsb2BDorXY0jVIdWmKbAs38watWMZyClgxpa0S3p7eC3S9WdI5Bawg5+WTQCxfZHKn5m10wsas9psAhZvKGNo9b+KG7kyC2zCCFsonQDpiadup4biXJ5bU2sF9jHB+hvWuKElt57VbTYZAfJcazqOR12DnG/MUDeu8MVkgmU+I6OiDCDJbu17Hvus19/u10HYQIJLG5Ylx6fsEBwG8IAneRr30hmGa2As5CEXWFRDfsoe6AQVJCxhDo6wuKpUxTr6ySLmTAaWnhf2CBNEImcEOfiITXcR+lUvUaBX8R8RZdOukRGgylQm5NNa5otJWqPjlSqn7VfIEyfv60z+7ltvo98jlhefmfyJXLs+vUtixtm9P1nxibr18GDutJnmzr1j0BdbIessIOoXXrtarjXLFVtt/T6eNAOVWr8lXpV9PyqPR24P
 VG/ms8F7
 lqAfQO/4vD0XyHhpdx7l3M1fBJet9wWCVfIPZRF7WH5D5+Ew3GKKIAwwU3CpVeKKJ8B7F2Dl3/oA4Yd7wAnXRQUuRrZAT4RsT0Ln13nb44f/+y6S0CMP/GqSnojyqsLwl6vTj7VfJqW5bpDeLfzPRiH/QlRm9RSYovIEaHqa0tsU2oQVk3aiHBmdWIS31WcI4DNxhlpXJQwUO+3y4o4NfVjJzaBLpd+uiRYkFRs6QncrFf82SV1tst5dL6wvjajSMRVa4elUEBPz8Neu0ecESifNJlrBpWhgoJNE+AcDgP6sV1jSGF3qUzV6bH9NJXOESrLtky+loDuLTpOGn+v/Z01Ax0P1hSpP8IwBw1NU5AH8cfrnBZLtJEW8AHL27o4V1LOc2YrvomQm1CcxBE3ZPwblXyFuyR1lpGFQEwDezCMpaCRQy/7ScFMqGNvP9MaNf57QyEocNK3wTKOCEnJqeGwk3L8TnyMJ60YcaagYuucvPVzgykcM4W8Lr+W/euh9ZzQpASu08+1aN6pb/5bOXz6tsnvQ177q8px+/bpZZqMkiuHwyBtbmBZ0SlGVQ6YOIecZzymJNitS1WjsT0w1a007btqmpY6RkH+6a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 04:42:59PM +0800, Baolin Wang wrote:
> 
> 
> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > The current handling of dirty writeback folios is not working well for
> > file page heavy workloads: Dirty folios are protected and move to next
> > gen upon isolation of getting throttled or reactivation upon pageout
> > (shrink_folio_list).
> > 
> > This might help to reduce the LRU lock contention slightly, but as a
> > result, the ping-pong effect of folios between head and tail of last two
> > gens is serious as the shrinker will run into protected dirty writeback
> > folios more frequently compared to activation. The dirty flush wakeup
> > condition is also much more passive compared to active/inactive LRU.
> > Active / inactve LRU wakes the flusher if one batch of folios passed to
> > shrink_folio_list is unevictable due to under writeback, but MGLRU
> > instead has to check this after the whole reclaim loop is done, and then
> > count the isolation protection number compared to the total reclaim
> > number.
> > 
> > And we previously saw OOM problems with it, too, which were fixed but
> > still not perfect [1].
> > 
> > So instead, just drop the special handling for dirty writeback, just
> > re-activate it like active / inactive LRU. And also move the dirty flush
> > wake up check right after shrink_folio_list. This should improve both
> > throttling and performance.
> > 
> > Test with YCSB workloadb showed a major performance improvement:
> > 
> > Before this series:
> > Throughput(ops/sec): 61642.78008938203
> > AverageLatency(us):  507.11127774145166
> > pgpgin 158190589
> > pgpgout 5880616
> > workingset_refault 7262988
> > 
> > After this commit:
> > Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> > AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> > pgpgin 101871227                        (-35.6%, lower is better)
> > pgpgout 5770028
> > workingset_refault 3418186              (-52.9%, lower is better)
> > 
> > The refault rate is ~50% lower, and throughput is ~30% higher, which
> > is a huge gain. We also observed significant performance gain for
> > other real-world workloads.
> > 
> > We were concerned that the dirty flush could cause more wear for SSD:
> > that should not be the problem here, since the wakeup condition is when
> > the dirty folios have been pushed to the tail of LRU, which indicates
> > that memory pressure is so high that writeback is blocking the workload
> > already.
> > 
> > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/vmscan.c | 57 ++++++++++++++++-----------------------------------------
> >   1 file changed, 16 insertions(+), 41 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 8de5c8d5849e..17b5318fad39 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
> >   		       int tier_idx)
> >   {
> >   	bool success;
> > -	bool dirty, writeback;
> >   	int gen = folio_lru_gen(folio);
> >   	int type = folio_is_file_lru(folio);
> >   	int zone = folio_zonenum(folio);
> > @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
> >   		return true;
> >   	}
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
> 
> I'm a bit concerned about the handling of dirty folios.
> 
> In the original logic, if we encounter a dirty folio, we increment its
> generation counter by 1 and move it to the *second oldest generation*.
> 
> However, with your patch, shrink_folio_list() will activate the dirty folio
> by calling folio_set_active(). Then, evict_folios() -> move_folios_to_lru()
> will put the dirty folio back into the MGLRU list.
> 
> But because the folio_test_active() is true for this dirty folio, the dirty
> folio will now be placed into the *second youngest generation* (see
> lru_gen_folio_seq()).

Yeah, and that's exactly what we want. Or else, these folios will
stay at oldest gen, following scan will keep seeing them and hence
keep bouncing these folios again and again to a younger gen since
they are not reclaimable.

The writeback callback (folio_rotate_reclaimable) will move them
back to tail once they are actually reclaimable. So we are not
losing any ability to reclaim them. Am I missing anything?

> 
> As a result, during the next eviction, these dirty folios won't be scanned
> again (because they are in the second youngest generation). Wouldn't this
> lead to a situation where the flusher cannot be woken up in time, making OOM
> more likely?

No? Flusher is already waken up by the time they are seen for the
first time. If we see these folios again very soon, the LRU is
congested, one following patch handles the congested case too by
throttling (which was completely missing previously). And now we
are actually a bit more proactive about waking up the flusher,
since the wakeup hook is moved inside the loop instead of after
the whole loop is finished.

These two behavior change above is basically just unifying MGLRU to do
what the classical LRU has been doing for years, and result looks
really good.

The global congestion handling is still missing after this series
though. Have to fix that later I guess...

