Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C059606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c8oIL1rm
Received: by kanga.kvack.org (Postfix)
	id 475456B00EF; Sun, 15 Nov 2026 16:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4294F6B05B0; Sun, 15 Nov 2026 16:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DC06B05B1; Sun, 15 Nov 2026 16:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147EC6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:35:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8477940852
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:35:45 +0000 (UTC)
X-FDA: 85438660650.25.EDF6B28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D467B20004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:35:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8oIL1rm;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794778544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seYfiqW9sYksqDlchrDoMfIpdIMNoieEec+Ihfz/jxA=;
	b=K5GHIJzC9xAuVmBDSbSYa6dqYg0T8wrQ75es/lhqBdthMjiRToBpAL2eNSdb8y1RIjRAq9
	aiG0Ko902k3hGUOJ5QmI3D+ADSXeW56CcrLa8mp0ix8yx2hbak4CZF95DppUdc8+Q5Xcly
	BgaawBJQ2o9u43NpPOcLWWlc1C0+VPY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794778544;
	b=veLGk6sfDPwQ41tWn3GkN3Hxj+foYj255HWLankNFkoRimrDqn5PCfJgBRkUHMvVYv9lVo
	xKhpV3it85iKyZo6/LpLT8d7FlR416741raTSGh5yIN2cxG0ANNp43Q5NpiX/Aot7HaGxn
	NaDARY4sC4Z2X9yEyw9Ie7ywFGkzOiQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c8oIL1rm;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C008B60617;
	Sun, 15 Nov 2026 21:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D67A1F000C4;
	Sun, 15 Nov 2026 21:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794778542;
	bh=seYfiqW9sYksqDlchrDoMfIpdIMNoieEec+Ihfz/jxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8oIL1rmrVsbQZXgaZ3kryZObNNSR/loTyje4n4lAp9ZlUh0sxtCJ0QkD3qyooSdh
	 AQ4gZ8LxCcIvfjyMGc9qLx7+sZY4h5GVGh3UynMulSDz4Rxtl8xYNtfDkjwKK0/sqy
	 AASjeL7BGIsDjk54Da/RRpuPN0RrOwPf3gPNwYtLUHadO6vZDcmJMfrZa4Nfr6nUQq
	 r+qkphEqejKexT8z69xQxcWYLTSC24EiuhZJw2p8/NjM1M11QbhlqaClzOuwRRxG5e
	 vXHaJdJs2f28VhC1bXgUHviXZYPdrIC8eiNmsEIuDTp14w3U2R7DuiQ7eLJWLnn4aE
	 9R+MPpHj9lTvQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 13/27] mm/damon/core: introduce damon_report_exist()
Date: Sun, 15 Nov 2026 13:35:34 -0800
Message-ID: <20261115213535.103582-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215847@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: krs7tuusms8yy37swfr45rp9ttgye995
X-Rspamd-Queue-Id: D467B20004
X-Rspam-User: 
X-HE-Tag: 1794778543-726186
X-HE-Meta: U2FsdGVkX18d72Xc/Ynz69QV1JWb8G5Q4jPYmFiDUAv1Xg4n1Y0/F7EJaqFY8ozA7AUZQoEAz+Qqgjwf2h72OtuDqDLOEG+TD9qMamOGKWc1VvOakOJ4BQ+9Ip6oIxpcTmrz/TlAOOtqj/2bX9hDGY4o08PNZF0yqA9KfM5ExIru62iJjQ4EV/5BzGZndAy8w+nRLGHhrH6ush7P8TueD9Hmg78S2FVUDS+ln1DYQVQNauyoGf2TzFAf96L7d/EYvFR/USayJzGK/ECrPpTqUR07YH5AC3Oh3kUiX705WJrKQfDTAA4viUWxsboLWqyeKgrAxtxsocpU0sNemV2dRwxKGsYREEmkNdSOXPOd12fFD04lgPTcPyscZIFZJOrd2Bkc6jFPCdh6RlIlTTvgeapIkHnaxz9Kbjy+lV6LQOV6by90UwqBpPYrAIui8r3yzMvHNHJc8dCM7lipL+dCHUVRVCYK7JhHtEfnj07HZC1Iqn+Wj6DXBG9kl4bPrmDK5EH+/mceZ7CvDyXAhAha4QQlPGvQCcyuZK57PBwM9NO3DeY2meFMv9nS7h8G3e72yEiqsSlpfGUIa5zU9vKGE3LUKVlnb9KgrgwP5N1GLmib0+PjnDkGNEEuwz/OdOPjPATsXYW+lEp42oGakUUcAFR2BIsqErmzmqpxkO6MXKQDBlUZS7t4B/Wgk6/PspyF4iG2t0kxP+Fmi0vKxWLz68E0ZRYOn9YrRxiSi13tN77VB9Cu7KD57YQK3t3D2nBX0dp+cN0GhOCBWHv7B02nOEMqzSD2s0aS1sus3Oh9pZUEyL6A9viPehhjm/QPO7HVC+Osi8q622uDH+lFaUg0L3Jn/pTnVSRDiJY9DCZkwAlW4O01h864LgwDyzz6LQbyggav3Cpn7hK8oDWswnpuauMQJNj9Gup3aRt/N8mYKgyaT74/D0f7DPPz5ObzimYFCth0W2TDzS2AQQUbQsQ
 gqM61tUB
 9Sygb8i9nd6oxzpXD8mWnBLyFi/iMFbkVW01UTP2GR37Y6UXqezUJfv+/nQDQDV+NtVS02M4HgbVuEKyLB2T/Ww8OlNcmbKS68aG3Dzlgp3GZAbCq0b9B2v44y42ud4rvmZMk1VTAFyunZiL6EOaCUh54yQi2ZE4YVqAl60APmnnuxAWcMDBm0BPnny8uRirAM9iDzg2QisGKXeKEJcRdOFFOEd9LUa2PkjR8PV0EkUpNt/gtxJ9eGv/wyDyYwMmOT/Og2wSdlPYvkRXlSUVJDE85AmDs75+/e0LvHbZwKrucI2XKhqKWo7qWHBltnUGsb2Sqi2eMThbKiTLA1FLoIqEAvY/DWGzIH772PmSjUpgaK1vCRWxbk2Z5GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:37:19 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/damon/core: out-of-bounds and uninitialized read in
>   damon_report_exist()
> --
> 
> commit be7b07b7677627ddaaa72484649217b5172610a1
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: introduce damon_report_exist()
> 
> This commit adds damon_report_exist() to search damon_report_queue for a
> report matching a given type, address range, and minimum age in jiffies.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index c02c7fbc1d864..c60a6504d0a15 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2386,6 +2386,52 @@ int damon_submit_report(struct damon_report *report)
> >  	return 0;
> >  }
> >  
> > +/**
> > + * damon_report_exist() - Find if a report of a given condition exists.
> > + *
> > + * @report_type:	Type of the report.
> > + * @addr_range:		Address range of the report.
> > + * @jiffies_old:	Oldest jiffies to find the report for.
> > + *
> > + * Returns true if the report is found, false otherwise.
> > + */
> > +bool damon_report_exist(enum damon_report_type report_type,
> > +		struct damon_addr_range *addr_range, unsigned long jiffies_old)
> > +{
> > +	struct damon_report_queue *queue;
> > +	int lock_old_val;
> > +	unsigned int idx, nr_read;
> > +	struct damon_report *report;
> > +	bool found = false;
> > +
> > +	queue = &damon_report_queue;
> > +	lock_old_val = atomic_cmpxchg(&queue->lock, 0, 1);
> > +
> > +	if (lock_old_val)
> > +		return false;
> > +	idx = queue->tail;
> > +	for (nr_read = 0; nr_read < queue->nr_reports; nr_read++) {
> > +		report = &queue->reports[idx];
> > +		if (idx)
> > +			idx--;
> > +		else
> > +			idx = queue->size - 1;
> 
> [Severity: High]
> Can indexing queue->reports[idx] before decrementing and wrapping idx read
> uninitialized or out-of-bounds memory?
> 
> In damon_submit_report(), queue->tail is post-incremented after writing
> queue->reports[tail]:
> 
> mm/damon/core.c:damon_submit_report() {
> 	...
> 	tail = queue->tail;
> 	if (tail == queue->size)
> 		tail = 0;
> 	queue->reports[tail] = *report;
> 	queue->tail++;
> 	...
> }
> 
> Because queue->tail points one slot past the newest report, the first
> iteration of damon_report_exist() reads the unwritten slot at
> queue->reports[queue->tail] (which is allocated with kmalloc_objs() in
> damon_init() without zeroing) and never visits queue->reports[0].  Once
> queue->size (1000) reports have been submitted, queue->tail reaches 1000
> and the first iteration reads queue->reports[1000], one element past the
> end of the array.  Also, when damon_submit_report() wraps local tail to 0,
> queue->tail itself is not wrapped and increments past queue->size on
> subsequent submissions.
> 
> Should idx be decremented (wrapping from 0 to queue->size - 1) before
> indexing queue->reports[idx], with damon_submit_report() updating
> queue->tail = tail + 1?

Good catch.  I will move queue->reports[idx] after the idx decrement.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=13
> 


Thanks,
SJ

