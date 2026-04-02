Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A156B1112279
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E976B0089; Wed,  1 Apr 2026 22:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF5A6B008A; Wed,  1 Apr 2026 22:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4C96B008C; Wed,  1 Apr 2026 22:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0BF6B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:44:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CD5B13A989
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:44:29 +0000 (UTC)
X-FDA: 84612072258.04.7CC5F4C
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78EB3C0006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:44:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cLt5hV06;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775097867; a=rsa-sha256;
	cv=none;
	b=r/8KfBzSkUTNr63NQ2WUNI8Tnbwn3/vRRH717PmrabfloexX90QYkw/vsflo97vBqAFiG8
	n8SqXJxoeVDBpvNufl2RDjOcHh68sS+bbCMYFZzuvyC4la8HCCHrPGtnUiDF0yO7IP1cXW
	wgJ9W/ZHB0E5saLqOlMB0KiuPIUS6CE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775097867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ac06C/bkaz63cj4mi6CGIZnecILBcucCVZHeS3ed2uE=;
	b=Nd3xNGt7dHIb2uwEFU+S7t+3G1+0KIbBZWepX9N/fIOS21LRFgO7RkX/n2JjLZ9XI37Wwf
	YS421UoKE3FK0yrSk/byIS89WTLT6rSWtv5yJukruflpgMh5n/3wKBOampZ3c/9D8h6gVS
	Tt6mhZHJ2tOOEXG4Y6xj98vxa55z3uI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cLt5hV06;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82cd98be655so279481b3a.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 19:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775097866; x=1775702666; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ac06C/bkaz63cj4mi6CGIZnecILBcucCVZHeS3ed2uE=;
        b=cLt5hV06TsY2o9LQ5FONVSIgvR/TFlQQua7rUuw5fvc9C7DjFXjdkzs6rsQPwfipXf
         T29ixFSgy/H1PG3/ztp+/osJ6K711VbXWuJcwnTcpUllQ10NturWmb48fnsDFcKaKLFJ
         PoXwSqSYPmmKokHkjkW5Utq4xJQpxGVkK86H/3+S3lactiLYJ57/EJtSZaIJzdO+KNNx
         36r1PtI9YHgGGnGbsviKJoeymp6KBsUii35fYMFCHUeH8xkZszubkKwxr611Qys7Uwdb
         E+qZNFhlma3AKRCy5qrGFnHEgJwDEwQXGZIgI2y/eus+asQH8EHZHREgizcJygKEk7/u
         338A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775097866; x=1775702666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ac06C/bkaz63cj4mi6CGIZnecILBcucCVZHeS3ed2uE=;
        b=RK3fwy0rNU/K2JsLVwBhZM3ZcXtKwdRDZDmVLX9b4eCOOKYgbqiC38Eew0Wq3jon0T
         gODnEQS919y/ZsU7AnODz9PQYikU3eeJfBm2LF3M78JWSU9astwBFLI5uwMuWC9OS6kq
         VanEnJf0+uXZJR9gdXfShjUmp8/OZl9caGT1WpQKIh9+R3eKuusX6Ry83zNSA1k+WNUM
         ZsHpn2vBwwIMT24yLpmJQBR19Fn/MfCF3wRmppvaF2F+U9LE50VJzhpDP+ZvPPo8Y2SN
         uTuYY3Y9G2Rk1qAfKweycCBJkxc7VrgqHKDMvpCykymM87/JQqnp8t02Mq6HrvWMU3Xn
         rcXA==
X-Forwarded-Encrypted: i=1; AJvYcCUC2tkGCiWy+vvRXHl5MzdWZeyvFlX9EwisdzBumP6M1osq6t8Y0Cm8oiB7SyTtp7z0nkevbY45bw==@kvack.org
X-Gm-Message-State: AOJu0Yzs8INV4td1dmI+BGPehuki3emsOAq2CZ/QH94JnmoA5tKVwkNm
	K5rsv0qqeRtRRrIUj3MBrISwfmILknz1KZMZvixwkn0YdvSNjwsMp5y9
X-Gm-Gg: ATEYQzy2nrqpzB2iJxYxoTWKyUGg4a1Uurh2aKQwcUaW3huh22M/IbZiTcE/jFNiTIy
	cUnNneyJTxAk1kpBXaQxkp/vyTvs9op11HzwQ1ypxLSle0x0UBA5OvGxHRRWlJ9ntp69Rit7i3X
	7vQ7VJYk9ET1VMoNO2uUsysTchZykE114PkQhx2CoalCGlL6SFfrUxbUqhT7q68cpp/5h0TyVyU
	ZpI1TXztVGEBZ06BulkViSV48ZPjN5H9k/yoau99cxef5FrwHhqtFYK0fhYtBwRNeAfbV1IaCUE
	1LNDmnecBX15yAGQmJ4U3UEayGdbL2YZCB9/SXeI87VI60PV/FsSVidKFHPi96bUM7CFbivT/qY
	CCpbkk7Oa8XcdSTTR1KtasL3aw+Y3mfGlDGQkxED4ABW+Xz2DI3Pap5H0B1qg2pjTFNp0FiMNCu
	XutK3GVZFo9teAp1/bCMMhWEYLFkzauV4VjoLVMc2meSht5s7b1rbrmAkTlIzTrfMeurDU
X-Received: by 2002:a05:6a00:2e94:b0:829:6f37:158a with SMTP id d2e1a72fcca58-82ce88e4f64mr6184763b3a.18.1775097866176;
        Wed, 01 Apr 2026 19:44:26 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b2443dsm1570003b3a.4.2026.04.01.19.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 19:44:25 -0700 (PDT)
Date: Thu, 2 Apr 2026 10:44:20 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, ljs@kernel.org, 
	baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jingxiang Zeng <linuszeng@tencent.com>
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
Message-ID: <ac3Pqq2WrGTJZLB_@KASONG-MC4>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
 <ac18iLvF-nNtxk1-@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac18iLvF-nNtxk1-@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78EB3C0006
X-Stat-Signature: pcojwhod1671kysex77z8wtrc8jm1ieh
X-HE-Tag: 1775097867-608436
X-HE-Meta: U2FsdGVkX19Dt5g1e1joj6f1J0xXQmi53lXaI5bmlgXTS2PUi5Xyv9PrxOFJwi0m7CJLkKUrACT3k22l0YSpKnnrzuA64ia+uXkc6skMoSgzZFkviqsjNN0FCfqPUiTI/LGHef6qa+H3Fz00b35d6y5IdTBUp1We84y+HZWOrxBGxl9KUR7QnZuF1bX7E6C/ezbW9K7/fhvYYU4YQVbdXsFX8QYOMlGq3WgAEBuLU8iM1PfM/iGq+odlnM/A4qric6bh6I6lIQ4yza5Ck1K3kM2kboZVEF0xqvNnPyZBOjQcNwtIBUEe+jEVvhW+rMCymfRa2uFRJEBqGn9Liyf1rJmmTySsDjVVbMqs5Abj4dQcKvDJL9SgotvFa9yxHvh3WYZL/DHgdwu9JJcTOXf5TExV0fZoZBO4gnExAFMp/ViqJY90ZUPYVNk/NZSs3WqwLf7cTad4jWrWJ+OLIxdEqdOZOYaLj9iy6tvs3Gp+GoAvvEwdJvRhEPDK8ZwVsWoOJ+fn1CPpPIDlNAgU1nXvvrguRnTX+90XfQTqndsVTbIxlC3VDBvTUJLI3+EgtQ2efEJMA+p4UCftnpmzt/HUFRJL3SiNMcjnB7B4K2K+dHwcAJIO1k2OMha6oTWTInHaYo0jW4ZIRX+ELwOE8rMj6X6lvNlQ18rwQ40LkKhPlhsaMkRNJcv2vMmIZa+0JsmBr0bY2O64KnAD3tpDK1qWydqiuU3459E9ju81UppOaBvipgzWtSI/VvTm9t0N5syP+z+qx+7yvvWP1F9qI1Vb9OHxILFVVGQmYLYu93I58rZjTHhFgZNtcSxkN+gVSKRgcYxBntnZWgFWEzFOqqGzA4FMk9ZR/fCh2Jz1UJ90IMDpEzTfhzmlZ0eEt96CSHVlPF0G6i7gZGH9Y/n2RN4lqXd/qM/0ikFc3tqgSpQ7lOeKVxQXgNYhKAN569bRhWxeVuSHHyKWs8AnPg7gLe/
 1PnqQdBw
 kv0oP/nn/uBCT5U6fiF5SHp1274DrBME9r66btwj5haFJG4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 01:32:40PM +0800, Shakeel Butt wrote:
> On Fri, Mar 27, 2026 at 06:21:08PM +0800, Baolin Wang wrote:
> > The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> > See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> > on traditional hierarchies").
> > 
> > Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> > longer attempt to write back filesystem folios through reclaim.
> > 
> > On large memory systems, the flusher may not be able to write back quickly
> > enough. Consequently, MGLRU will encounter many folios that are already
> > under writeback. Since we cannot reclaim these dirty folios, the system
> > may run out of memory and trigger the OOM killer.
> > 
> > Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> > which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> > pages throttling on cgroup v1"), to avoid unnecessary OOM.
> > 
> > The following test program can easily reproduce the OOM issue. With this patch
> > applied, the test passes successfully.
> > 
> > $mkdir /sys/fs/cgroup/memory/test
> > $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> > $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> > $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
> > 
> > Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > ---
> > Changes from RFC:
> >  - Add the Fixes tag.
> >  - Add reviewed tag from Barry and Kairui. Thanks.
> > ---
> >  mm/vmscan.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 46657d2cef42..b5fdad1444af 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5036,9 +5036,24 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  	 * If too many file cache in the coldest generation can't be evicted
> >  	 * due to being dirty, wake up the flusher.
> >  	 */
> > -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
> > +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
> > +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> > +
> >  		wakeup_flusher_threads(WB_REASON_VMSCAN);
> >  
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
> 
> This seems fine but note that this throttling is not really the same as the
> throttling happening for traditional LRU. In traditional LRU, the kernel may
> throttle much more due to throttling check happening at each batch within
> shrink_inactive_list() while here the check is happening after full scan for the
> given memcg's lruvec. So, throttling can be much more aggressive for traditional
> LRU.

Right, I think Baolin's fix is great, but to improve the whole trottling
mechanism we need some rework for MGLRU, currently I posted another
series for this.

> 
> This is v1 only and I don't care much but what is stopping you from moving away
> from v1?

For example memsw?

https://lore.kernel.org/linux-mm/q2x4drxpjbxcxgns6bjp446ynsxgl32ckcljqcol7posds4nit@3n3tjq35anvb/

I remember Jingxiang's plan is to improve the page counter first.

