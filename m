Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C094FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035646B009B; Tue, 31 Mar 2026 05:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28C76B009D; Tue, 31 Mar 2026 05:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EF36B009E; Tue, 31 Mar 2026 05:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D25536B009B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:40:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7ADEBBF10
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:40:24 +0000 (UTC)
X-FDA: 84605862768.22.6268EAC
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id DBB8AA0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:40:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qb1IGKOG;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qb1IGKOG;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950023; a=rsa-sha256;
	cv=none;
	b=d8RNJKW3TXzD/v+lsj5nIHr9FEftDizqwqL0g0LLLOel/KOuYASvgln6oB3zlIk8vOtJ4u
	kNyd/TUw8j4WCtU7V5gyfb9a3MSVE8z1CmjPaGAojMey8Cw6yUrj1OdU86TrKbvrDJWZmw
	nc9h9274kNTgJoTaNJfbM2g9j8qdTXQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiTwdGFbqg7vVs9GT/X/QgkKkcZLbR551j3h4hBPKpU=;
	b=5qhsdi7Kak3+b9tGhUnd81XRRBD6qRt+MTOPJFtFo9LHHMlt450LSvJB1hwoJApYstuioz
	XQmk/jZgRWB+6Zouto3Ft+/Uxj6xjyPqsBRk+uJbNakMt4oLb/6/cdQYKUUpf5p8hAFQel
	God/8MiA7dkQXxQmoJyB5rzv56aXaXY=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so3865731a91.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774950022; x=1775554822; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xiTwdGFbqg7vVs9GT/X/QgkKkcZLbR551j3h4hBPKpU=;
        b=Qb1IGKOGtypWNNYQ0H9ayx47JrsQgK5B58tJftr2Fgs5ZgBRpMr1vdGSafnHI2ABda
         qKuNxNHo//K8bQ4Su2eJh+oWmLISDmebOKhoEqdlrk+E3kxBcTCnoNGbVQgiKuc0pSO9
         /IaPPHQEF/U/snAZUOzUUcfK79sbIwgfOZGQqnSNYhjb83R+k9jChpLKQu1LAFvfK4TU
         HOiJUN9TJYDzwwYxudc50cjgAQI6M0s7xM1TtPVb+/LFPFgiUAE7YB35eil4WXVrBszx
         XHdgqtT5IqQk9nqQVJJrouHecFy3WoYbsaQgM2kJ0yJwXWL/aGXVlrOEr/zli4cfFmkQ
         iahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774950022; x=1775554822;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xiTwdGFbqg7vVs9GT/X/QgkKkcZLbR551j3h4hBPKpU=;
        b=RKYZZ3Zr2yfalz4lmaBRL8KXSuNeLbxonhJ02My1LLMBluoqoX8bRajiSB5MgqcOwH
         tZz/qqZY9glKMk2F/eyRxSUsL5HdzYAdyWXxrOOx1VKikSrt4H0c0g584LcYkLrLaqPC
         0I2jBGhT5gGOcpFEfHC+lQ8/tsHXQ6W/GprNK/iEoJx+AGmrVWSUH8sJJP9VSxXVgoM+
         wrfLrZ539V0Ij0K4daGy2PkHlA4cFViYale3+L53UuBIS/JFYrcvXWAd38ftOpSgNL9M
         ODMr3prcm+hagjEd5i+oUESjhPA01TBgZ0aQuCVj5sUvtShUtn/J/y951jWx2nND59EK
         HPEw==
X-Forwarded-Encrypted: i=1; AJvYcCU+FNOnCwPDwOtSiphK1t+2vFQ2w9iMNWedhxSSLBn55LfSXEulBeXqpsLgGatypg3DUTSAa2VSQA==@kvack.org
X-Gm-Message-State: AOJu0YwiPv6yQGosRfLeeSqK/vJJ8EPF4KUE4ZfH8I3opjP5HdQksD6A
	SuoACXofrLNLY/fXSVSPluaUEm66KcpikjM4CE+R1Ri5fzjyM/t3LsYa
X-Gm-Gg: ATEYQzydtirxb/p21USWsgzuFq7XycfgKyzgqPE3vjhXgz6HOkilXh5GkM94AHICGyO
	fyIJb0WEEiTSt2kj5sEzKPU/bH8ftAEPq7Js5G3js7XLfU9sbj0ezg8UOBGCC1F1RrY/zvi8bvc
	hYV31Ejl271ER0uDf51Gc50gNYjNiJ1kXrP58prKNXQd+2O4loVKZgFxM1N6rE3tZlJaKSPJsPH
	2gxp6uJXmuK393CFr5cmD2Gfi5HgiRlxgG0LQiLTfAaQv7atw1fns/fJkNutfYdZ+sx5Hj05wOi
	pY7h2NiLH90SGa3/l0+TXm9JWE2nxBdY4gnIBFza+jvktylUlL7NivgNNE/T0zQH3r5Bk609zIw
	3Qc4w4ga+o4Tc1EC35+PtU06PD0nmJy4yf/ApvpUJtm05hEV4SiQmrDSPhtKNFzUFSLGZv/+/eY
	fbWhrm3rMu3DZIvws4V40gJCIZxgN15XiGne58USSJ+KUy6VYAgVL1GSgwZoN3B9PoSwbZ
X-Received: by 2002:a17:90a:1048:b0:35d:93ff:2854 with SMTP id 98e67ed59e1d1-35d93ff2b0amr6482293a91.8.1774950021601;
        Tue, 31 Mar 2026 02:40:21 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe95abc3sm1080389a91.15.2026.03.31.02.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:40:21 -0700 (PDT)
Date: Tue, 31 Mar 2026 17:40:13 +0800
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
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic
 and throttling
Message-ID: <acuV1GA-Tn7tIQqh@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
 <052ae271-509c-42c3-877e-ac8822b314e5@linux.alibaba.com>
 <acuTMVSnGb0XRvTV@KASONG-MC4>
 <522f4898-78c3-453f-8367-29327e29290e@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <522f4898-78c3-453f-8367-29327e29290e@linux.alibaba.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DBB8AA0002
X-Stat-Signature: bfpnqyhgcnwtzx3xc81xnds5mrs8d8fw
X-Rspam-User: 
X-HE-Tag: 1774950022-693560
X-HE-Meta: U2FsdGVkX192gdbUwhJi99fnMILgkuExlf8inVrvjtFdOo7Wr5xuYbjsvT/pxPMUh6bO2GXiVbu9Eu12UqPsomAKU8xU7J1765NOcy6DrBtPwj76vY3/beLaAyQ/pPN7UoolyI40LiBIYwxFLD/TLrHdjtrboholZmgNBS9k7KOc3M0a5h4DXe7ooHVIgT24uV99gsRfkKyvrXGdfknn+iR7sSUIiHGkLTRtXw9gSiPrutTIppqRYdBxWn9MhTbHiN0waV86I8FZyoi4oSaEHbv21BNFxViazgUmWrdkYn1O2UubrGz+Cv+UVKZY4KyV2wgLI2JWep3OyoP7WPZ5HcS2PEEJax0yQ+sc2ABOLNuLdDPzwH1TNx/WS8n3uWY0wzI+DwRmtK58eBjcHqKVtx21czNlU07WpT/Epgc308gnE9n2d4fpT4i95KpyFoRdc7otX7ArWCcZelRHwuTccTCoHaCrOss0OC/UvApi8NTyzWIXQ1lEiTZELJfdV1G4qVmOq6w2zEwucRvAiv0E64074EHe4BodGC0e7p0F/s5Ohtg6AIrYJe514dTqluTFeleqPMj+xYU/4NiAj6lZ/BkMjvA2fiyXdLtrkcnLj3yiPGFnLaP4imai5kKuap5SGSQOICVH3i7nIS+Lok4HI+slvsRL5c9EZbTEfm2HYlPhQ9fpmqYDNG4+al0M7VrVwa1iqSpIS9lyVuGv1PhAAKxwQjRtoQApJWFhFvY3mXVNgA0WJocCGyGyoq4kpm5yZQxmN+JdAj3vTWbnmzpyERRzsrU+G9/NiuE/l+dBJdA6G36SykT80LtAlWXAy94BMjEkBGTHU81YzPla45gb2AfW5q2+8vLlvEX98gglZIAHiga0cw9Cex72oQ2oyVUAM5XlFDcd1DHbiVM+cb1aEodNIxNUIFTuc1HRbasmcbtpzTrVXclpWprFE3eOivAkh/r+keCKMBJLRbynt4J
 3r5edcCi
 h0Qp1mYf8+uO6n0dWh52B2nUJOXmimF2HaSZa6VMlugzCcrXhWaYkUOPzMEOhvwnJ3sfiDsRIcXVRSj8ucaSPOlC2Rg+lSF7hHiASejBv+kHnZvBi74FDbybkiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:36:26PM +0800, Baolin Wang wrote:
> 
> 
> On 3/31/26 5:29 PM, Kairui Song wrote:
> > On Tue, Mar 31, 2026 at 05:24:39PM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > > 
> > > > Currently MGLRU and non-MGLRU handle the reclaim statistic and
> > > > writeback handling very differently, especially throttling.
> > > > Basically MGLRU just ignored the throttling part.
> > > > 
> > > > Let's just unify this part, use a helper to deduplicate the code
> > > > so both setups will share the same behavior. Also remove the
> > > > folio_clear_reclaim in isolate_folio which was actively invalidating
> > > > the congestion control. PG_reclaim is now handled by shrink_folio_list,
> > > > keeping it in isolate_folio is not helpful.
> > > > 
> > > > Test using following reproducer using bash:
> > > > 
> > > >     echo "Setup a slow device using dm delay"
> > > >     dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
> > > >     LOOP=$(losetup --show -f /var/tmp/backing)
> > > >     mkfs.ext4 -q $LOOP
> > > >     echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
> > > >         dmsetup create slow_dev
> > > >     mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> > > > 
> > > >     echo "Start writeback pressure"
> > > >     sync && echo 3 > /proc/sys/vm/drop_caches
> > > >     mkdir /sys/fs/cgroup/test_wb
> > > >     echo 128M > /sys/fs/cgroup/test_wb/memory.max
> > > >     (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
> > > >         dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> > > > 
> > > >     echo "Clean up"
> > > >     echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
> > > >     dmsetup resume slow_dev
> > > >     umount -l /mnt/slow && sync
> > > >     dmsetup remove slow_dev
> > > > 
> > > > Before this commit, `dd` will get OOM killed immediately if
> > > > MGLRU is enabled. Classic LRU is fine.
> > > > 
> > > > After this commit, congestion control is now effective and no more
> > > > spin on LRU or premature OOM.
> > > > 
> > > > Stress test on other workloads also looking good.
> > > > 
> > > > Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >    mm/vmscan.c | 93 +++++++++++++++++++++++++++----------------------------------
> > > >    1 file changed, 41 insertions(+), 52 deletions(-)
> > > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 1783da54ada1..83c8fdf8fdc4 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
> > > >    	return !(current->flags & PF_LOCAL_THROTTLE);
> > > >    }
> > > > +static void handle_reclaim_writeback(unsigned long nr_taken,
> > > > +				     struct pglist_data *pgdat,
> > > > +				     struct scan_control *sc,
> > > > +				     struct reclaim_stat *stat)
> > > > +{
> > > > +	/*
> > > > +	 * If dirty folios are scanned that are not queued for IO, it
> > > > +	 * implies that flushers are not doing their job. This can
> > > > +	 * happen when memory pressure pushes dirty folios to the end of
> > > > +	 * the LRU before the dirty limits are breached and the dirty
> > > > +	 * data has expired. It can also happen when the proportion of
> > > > +	 * dirty folios grows not through writes but through memory
> > > > +	 * pressure reclaiming all the clean cache. And in some cases,
> > > > +	 * the flushers simply cannot keep up with the allocation
> > > > +	 * rate. Nudge the flusher threads in case they are asleep.
> > > > +	 */
> > > > +	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
> > > > +		wakeup_flusher_threads(WB_REASON_VMSCAN);
> > > > +		/*
> > > > +		 * For cgroupv1 dirty throttling is achieved by waking up
> > > > +		 * the kernel flusher here and later waiting on folios
> > > > +		 * which are in writeback to finish (see shrink_folio_list()).
> > > > +		 *
> > > > +		 * Flusher may not be able to issue writeback quickly
> > > > +		 * enough for cgroupv1 writeback throttling to work
> > > > +		 * on a large system.
> > > > +		 */
> > > > +		if (!writeback_throttling_sane(sc))
> > > > +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> > > > +	}
> > > > +
> > > > +	sc->nr.dirty += stat->nr_dirty;
> > > > +	sc->nr.congested += stat->nr_congested;
> > > > +	sc->nr.writeback += stat->nr_writeback;
> > > > +	sc->nr.immediate += stat->nr_immediate;
> > > > +	sc->nr.taken += nr_taken;
> > > > +}
> > > > +
> > > >    /*
> > > >     * shrink_inactive_list() is a helper for shrink_node().  It returns the number
> > > >     * of reclaimed pages
> > > > @@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
> > > >    	lruvec_lock_irq(lruvec);
> > > >    	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
> > > >    					nr_scanned - nr_reclaimed);
> > > > -
> > > > -	/*
> > > > -	 * If dirty folios are scanned that are not queued for IO, it
> > > > -	 * implies that flushers are not doing their job. This can
> > > > -	 * happen when memory pressure pushes dirty folios to the end of
> > > > -	 * the LRU before the dirty limits are breached and the dirty
> > > > -	 * data has expired. It can also happen when the proportion of
> > > > -	 * dirty folios grows not through writes but through memory
> > > > -	 * pressure reclaiming all the clean cache. And in some cases,
> > > > -	 * the flushers simply cannot keep up with the allocation
> > > > -	 * rate. Nudge the flusher threads in case they are asleep.
> > > > -	 */
> > > > -	if (stat.nr_unqueued_dirty == nr_taken) {
> > > > -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> > > > -		/*
> > > > -		 * For cgroupv1 dirty throttling is achieved by waking up
> > > > -		 * the kernel flusher here and later waiting on folios
> > > > -		 * which are in writeback to finish (see shrink_folio_list()).
> > > > -		 *
> > > > -		 * Flusher may not be able to issue writeback quickly
> > > > -		 * enough for cgroupv1 writeback throttling to work
> > > > -		 * on a large system.
> > > > -		 */
> > > > -		if (!writeback_throttling_sane(sc))
> > > > -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> > > > -	}
> > > > -
> > > > -	sc->nr.dirty += stat.nr_dirty;
> > > > -	sc->nr.congested += stat.nr_congested;
> > > > -	sc->nr.writeback += stat.nr_writeback;
> > > > -	sc->nr.immediate += stat.nr_immediate;
> > > > -	sc->nr.taken += nr_taken;
> > > > -
> > > > +	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
> > > >    	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> > > >    			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
> > > >    	return nr_reclaimed;
> > > > @@ -4651,9 +4657,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
> > > >    	if (!folio_test_referenced(folio))
> > > >    		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
> > > > -	/* for shrink_folio_list() */
> > > > -	folio_clear_reclaim(folio);
> > > 
> > > IMO, Moving this change into patch 8 would make more sense. Otherwise LGTM.
> > 
> > Thanks for the review! I made it a separate patch so we can better
> > identify which part had the performance gain, and patch 8 can keep
> > the review by. Patch 8 is still good without this, a few counters
> > are updated with no user, kind of wasted but that's harmless.
> 
> I’m not referring to all the above changes. What I mean is that the
> 'folio_clear_reclaim' removal should belong to patch 8. Since
> shrink_folio_list() in patch 8 will handle the writeback logic,
> folio_clear_reclaim() should also be removed in the same patch.

Ah, that's a very good point then. Can move it in V3, thanks!

