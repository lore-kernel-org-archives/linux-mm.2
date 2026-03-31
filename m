Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C230FF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B906B008C; Tue, 31 Mar 2026 05:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703816B0095; Tue, 31 Mar 2026 05:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618B46B0096; Tue, 31 Mar 2026 05:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 513E86B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:30:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F25CBE122D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:30:12 +0000 (UTC)
X-FDA: 84605837064.28.664B7C7
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8F6B100010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:30:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dO3M8zHl;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dO3M8zHl;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949411; a=rsa-sha256;
	cv=none;
	b=L9h0yBOUxs1Qbign89NHGuLZ2waOSVz5T/NBCVOyKn34JxsI3PEdqeO2DHGxVPWPGyEHTG
	JDqXBPRg2ctXlDcusfNf5rYUgcGqH1NOsHL8TEIg6i62KURLNz1mm2ei8m5gK+YLAgKMcz
	IfoC3ywmhPl3xDPoIxmJufEXnMHJuts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDJbRrmR6P4+bOcvvHxpRXwGXp36zFt9hwZGamgixpA=;
	b=cxKraNoR1PYXRFH8Rgkqy+4Auk8OfyvmFfy6aOljlHAszkQpGp5OePtgWs/Nb/wcXKDk+Q
	L7SFC7y75qsCNI/CrsUI6Vkyx53+TEoOCQMLqCsfLTVEe+9NQv7Mq8jo2f403VfqOzv2Qr
	B6l0LZ6lWgj7J9LSz6QtiObHNrZNPN0=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82418b0178cso2633649b3a.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774949410; x=1775554210; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fDJbRrmR6P4+bOcvvHxpRXwGXp36zFt9hwZGamgixpA=;
        b=dO3M8zHlgXk0ZI1EmxLJIxEkeHw9T5kduJeiXHPdG9fR+PJJy563swttesj/llQX9v
         zGcceQZziFTzhW1n6f7Q2QfKK8fgmYeOWY/NqVyXC8cUON19ugDyr/ABWTj+PLCQW9tV
         plYYzLeDV3YVwV96AOP6sh0FY6eWqPl3L8cjGDShgIbdw31CD3/kp8bWzqwm6tXgI/Zu
         1s1h0Box6/0+3lQWuitmnRE/jlGBEGGxLEaC0zBTe+6DzIhDOikqEVxnhYtCGabsU90i
         9zJR6gwwqFHzpaqOZoRbsDineXZ3LpuBLBdO3jkyXnOGljQlUKBKHf1EEtaELnOhoJ/S
         uSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774949410; x=1775554210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDJbRrmR6P4+bOcvvHxpRXwGXp36zFt9hwZGamgixpA=;
        b=RDJVw4iYoh3+YXS+egxYgpUaeIKEIEf/VrjSwWiTQcwuozgn3PzR06tIyW0+Cd3OY7
         j/JMcV+PhSr9FQE4xuEnzwPDSWvWGznF6y+5z5JmcKDb+gArM2peqMHcu/wbTzyEx599
         6qAQF3v2IS35i5LeVMy9vktC/sBAIAF2hYvpytttQVShqTNpPq1QOP1S/O7pk9FSF15a
         1hk9v/P/tApxo/oZWYzHQj/U/zuJDgpK/bt55H85vUJSqA7PPqLvXtAs0zJUYbhoGQZn
         omSpK9Jyp2blJfjlkQP7AtTbOb6cD0cZnvUe5ENsQiSeiXo3vVlEhya6rKp41yzIgN8H
         50pg==
X-Forwarded-Encrypted: i=1; AJvYcCUwkjnZpwIy6GN9tkZuYMVbVDytZyk+tzYImmb2ilGIcQYgOKmWmpiAvkwjjIfH5IAmCYsi5G7cjA==@kvack.org
X-Gm-Message-State: AOJu0Yyci4vNfBpJ77DUKz4Ds+5fa6HJ3jGFH6MUJMTzT4VZeHwgphVV
	ChaAuwwoucrVLCyIjTeLjsJZ+hFjdlex27hxAuNdcL2QoKnq88PP3/4x
X-Gm-Gg: ATEYQzx6/IiaEkrC4GT5pe2Db1u5Yb6j09s4Lz/8VDhc7WDtrh1eOyivtqGJ03WwK56
	urnivcQpRL5iEFj5be6Dn+1MSF/KXbfxS9Ma+U7lpoxlyOvmb1KC1HKff+W86uaeSFnOSaqvnXU
	nWelrQy2/mKN9REQQwNDs8O0QNxfJ3UraUDjjfoWxRbnQsZ12IMmCjGDui7XGtZ/d3QcjOADvi6
	0H5IpaUrNMwRzP4cfXX7/VVRh9JIRW8QeV9BJcbCMoc1svsoJBNglQoAiOoN0Z6n0/2wWTfOEh+
	EM8TQuR+3ao6N7fBdCPKepxrJBtbCATosVRoPRvO/zrbUGXZrcIn626+wPndRkaYM5uhh5ME3P5
	tuuXTOV5kZxZi+MIIbHxN4yNVHAlehBCUa7jIT3hh9vWvEyVVKP9cf7y2Cg/3L5KWwIpoNEJuen
	vQK2+KejsV10NXM2ApZDPOLyesaTZqGjrYlxd/DSXmhOmCaUCQzqdyHv6sjfnFKVBsa1Nh
X-Received: by 2002:a05:6a00:8b96:b0:82c:9f7e:518c with SMTP id d2e1a72fcca58-82c9f7e5570mr9014194b3a.25.1774949409128;
        Tue, 31 Mar 2026 02:30:09 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca862dee1sm10374642b3a.61.2026.03.31.02.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:30:08 -0700 (PDT)
Date: Tue, 31 Mar 2026 17:29:55 +0800
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
Message-ID: <acuTMVSnGb0XRvTV@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
 <052ae271-509c-42c3-877e-ac8822b314e5@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <052ae271-509c-42c3-877e-ac8822b314e5@linux.alibaba.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8F6B100010
X-Stat-Signature: mxb1f5t91yzzk4aiy17qi7yim3z3wshd
X-Rspam-User: 
X-HE-Tag: 1774949410-786143
X-HE-Meta: U2FsdGVkX18HaZw/mZlUvNyMeSaBlmMy39xCOLqZRIMIqt9WddzeJZy4xYTff7/vS9kN8a/nc6I/0ig2ynhOwvWiwhCml23UR08Ew27AOKxSAVCy4VxUGh40CqOVMYq9U1WlSPpxx8iyNZl9wA7iOQECOuquXBIrQNFAdVH47wqD9NiYfOR56IsUHOo9K5UYSfpKxJIU6wDVZC+vcvpVxTj3EZTiJ7Vtkufw6J+MQyBiGnrJA7kIPU9PiWMyCw5td5mGViMgeOmtsK8IchLEpH8a/TdoDYrjlHhTFKrwz70L7eqsIWfQ1lbZBrEsxEmHDcEpyKLEwSMPiWBhobXZM6WyX3m9ty5pSe3ixUNRgosmzmnJHzvlu/SO04N+043jEo0Ao7TkCUU/45UjX5OKLkFSk8c+Wb0fUwooq3P9zN0IgRP1xLEn5DOx2sMKe9xBgqWIc2GFLF/fPEooWVGhGT7MpEF7F3Wmvg3GMHCwA8FUVpGERjM3MuIhBNov1xPIldcWbztfHubBqfanBDH4Qlduo3zHknFBdfm6lSslGyE9lXwEZT5fHFG0CgZkloZqaG81x/aVWyv4Sgh9gDLRFGjljADBLszSqoCHnsSs1tvkmASboiPixwXibrz6BMd4+H/dRK022YTy52G4R281uWsr+zNxAkayEfXvcAUyH5LcqYj24JjZQuOwUWZk7hhkks9IpIKjii9e1ktIx+ccbQ6RxroYr6SBsMRylMBHEPzr3bQiXuM7Jn4VjieCfO8Bsx90zqb8iM2gZZDuvd+6vEtvzTM55LgJQW4VY6eTpfmyS6Znc8Ep7P0EQpZqpHp+ZYKwW1GdXwQZJAgnD/4rKmsrUS8UKCzD3xncu4FtFeuUGeKFXinEXBjuBVBqtC1fRSB7HphR4yTKsrqqlP3zSJJmJq5NKnTENoruFsby8K4EPRViIIIqXww/7hVwnSFx8yAYfigAdYRSSD8gnjb
 tuFhzqnM
 HnEuhIJqTWSwzYeTNx1+kz9R7Ymgs24j7gMsvAjGXowmSuDq35TCorJxALoTjUkTN14JbaZxkkAhAHRPR/JlImxFy27RrslCAMHBjpZJtiLFkeNtneiopDV0n1w3Y3ViiC7+CfyIXxYAu3iDxQfIIXypVFxa2DB/5pXxNwJdtqcAHeELhTE7BtN5ox/H0/UaU0wzAu5d5a03H1FuQGExVBlQ6TbsGK/7CMOvM+4Pgq+OxXRP8nPcb5eIhJlhKTD8NZ6NUXPMkAR4MaNdDh736BWvlYCgdYv1iYKlkMYU8AvP6mfEntbtX5m+TB3hCrFBarWBs56ZkwigssWfBBUp/LDXGyVAtS9CfxZKVHPsHv+1EqDwsDCvlscMgyCzdbKjcSTHPv/puuj/jlY7jIOHdQBlPZioUZK1ZeVyEsgUOhojStetxDK7H8KN3SvtHd9Z0mA8KLTBJXuhnx3tXN0WaIM85WZBqYVquqeWZdf9H6pGbj3+IaTV8VaU8cPZPqmBS11YnK5SU03fsagqgyRkUd0msGd0M/Qs0DY8V35j3HkHwQV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:24:39PM +0800, Baolin Wang wrote:
> 
> 
> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Currently MGLRU and non-MGLRU handle the reclaim statistic and
> > writeback handling very differently, especially throttling.
> > Basically MGLRU just ignored the throttling part.
> > 
> > Let's just unify this part, use a helper to deduplicate the code
> > so both setups will share the same behavior. Also remove the
> > folio_clear_reclaim in isolate_folio which was actively invalidating
> > the congestion control. PG_reclaim is now handled by shrink_folio_list,
> > keeping it in isolate_folio is not helpful.
> > 
> > Test using following reproducer using bash:
> > 
> >    echo "Setup a slow device using dm delay"
> >    dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
> >    LOOP=$(losetup --show -f /var/tmp/backing)
> >    mkfs.ext4 -q $LOOP
> >    echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
> >        dmsetup create slow_dev
> >    mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> > 
> >    echo "Start writeback pressure"
> >    sync && echo 3 > /proc/sys/vm/drop_caches
> >    mkdir /sys/fs/cgroup/test_wb
> >    echo 128M > /sys/fs/cgroup/test_wb/memory.max
> >    (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
> >        dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> > 
> >    echo "Clean up"
> >    echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
> >    dmsetup resume slow_dev
> >    umount -l /mnt/slow && sync
> >    dmsetup remove slow_dev
> > 
> > Before this commit, `dd` will get OOM killed immediately if
> > MGLRU is enabled. Classic LRU is fine.
> > 
> > After this commit, congestion control is now effective and no more
> > spin on LRU or premature OOM.
> > 
> > Stress test on other workloads also looking good.
> > 
> > Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/vmscan.c | 93 +++++++++++++++++++++++++++----------------------------------
> >   1 file changed, 41 insertions(+), 52 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 1783da54ada1..83c8fdf8fdc4 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
> >   	return !(current->flags & PF_LOCAL_THROTTLE);
> >   }
> > +static void handle_reclaim_writeback(unsigned long nr_taken,
> > +				     struct pglist_data *pgdat,
> > +				     struct scan_control *sc,
> > +				     struct reclaim_stat *stat)
> > +{
> > +	/*
> > +	 * If dirty folios are scanned that are not queued for IO, it
> > +	 * implies that flushers are not doing their job. This can
> > +	 * happen when memory pressure pushes dirty folios to the end of
> > +	 * the LRU before the dirty limits are breached and the dirty
> > +	 * data has expired. It can also happen when the proportion of
> > +	 * dirty folios grows not through writes but through memory
> > +	 * pressure reclaiming all the clean cache. And in some cases,
> > +	 * the flushers simply cannot keep up with the allocation
> > +	 * rate. Nudge the flusher threads in case they are asleep.
> > +	 */
> > +	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
> > +		wakeup_flusher_threads(WB_REASON_VMSCAN);
> > +		/*
> > +		 * For cgroupv1 dirty throttling is achieved by waking up
> > +		 * the kernel flusher here and later waiting on folios
> > +		 * which are in writeback to finish (see shrink_folio_list()).
> > +		 *
> > +		 * Flusher may not be able to issue writeback quickly
> > +		 * enough for cgroupv1 writeback throttling to work
> > +		 * on a large system.
> > +		 */
> > +		if (!writeback_throttling_sane(sc))
> > +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> > +	}
> > +
> > +	sc->nr.dirty += stat->nr_dirty;
> > +	sc->nr.congested += stat->nr_congested;
> > +	sc->nr.writeback += stat->nr_writeback;
> > +	sc->nr.immediate += stat->nr_immediate;
> > +	sc->nr.taken += nr_taken;
> > +}
> > +
> >   /*
> >    * shrink_inactive_list() is a helper for shrink_node().  It returns the number
> >    * of reclaimed pages
> > @@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
> >   	lruvec_lock_irq(lruvec);
> >   	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
> >   					nr_scanned - nr_reclaimed);
> > -
> > -	/*
> > -	 * If dirty folios are scanned that are not queued for IO, it
> > -	 * implies that flushers are not doing their job. This can
> > -	 * happen when memory pressure pushes dirty folios to the end of
> > -	 * the LRU before the dirty limits are breached and the dirty
> > -	 * data has expired. It can also happen when the proportion of
> > -	 * dirty folios grows not through writes but through memory
> > -	 * pressure reclaiming all the clean cache. And in some cases,
> > -	 * the flushers simply cannot keep up with the allocation
> > -	 * rate. Nudge the flusher threads in case they are asleep.
> > -	 */
> > -	if (stat.nr_unqueued_dirty == nr_taken) {
> > -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> > -		/*
> > -		 * For cgroupv1 dirty throttling is achieved by waking up
> > -		 * the kernel flusher here and later waiting on folios
> > -		 * which are in writeback to finish (see shrink_folio_list()).
> > -		 *
> > -		 * Flusher may not be able to issue writeback quickly
> > -		 * enough for cgroupv1 writeback throttling to work
> > -		 * on a large system.
> > -		 */
> > -		if (!writeback_throttling_sane(sc))
> > -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> > -	}
> > -
> > -	sc->nr.dirty += stat.nr_dirty;
> > -	sc->nr.congested += stat.nr_congested;
> > -	sc->nr.writeback += stat.nr_writeback;
> > -	sc->nr.immediate += stat.nr_immediate;
> > -	sc->nr.taken += nr_taken;
> > -
> > +	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
> >   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
> >   			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
> >   	return nr_reclaimed;
> > @@ -4651,9 +4657,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
> >   	if (!folio_test_referenced(folio))
> >   		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
> > -	/* for shrink_folio_list() */
> > -	folio_clear_reclaim(folio);
> 
> IMO, Moving this change into patch 8 would make more sense. Otherwise LGTM.

Thanks for the review! I made it a separate patch so we can better
identify which part had the performance gain, and patch 8 can keep
the review by. Patch 8 is still good without this, a few counters
are updated with no user, kind of wasted but that's harmless.

