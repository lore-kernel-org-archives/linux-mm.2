Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017CACAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 06:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10F68E0003; Mon, 29 Sep 2025 02:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1458E0002; Mon, 29 Sep 2025 02:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD74F8E0003; Mon, 29 Sep 2025 02:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5B328E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 02:40:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EA261DE329
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:40:47 +0000 (UTC)
X-FDA: 83941339734.27.20AB0EF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 553E5C0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:40:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=b4e8nJQX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759128045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YacQbj1YmkiJVhrtk3+KVfBFzhjCzjCVTO6GT84rzec=;
	b=JuiXkVbDDUlvSfN5btnlmVgOg8hjaruqPYRWgrgwFzjZIdM5dDPIxh3pqTeek2Wf6pxYwG
	zBZMXvuxKq1+PbQJRviwQiAlKD1wGt1+yTyf18jtoSPJKErcQa+6vIfXPoJgp3RS7K2cad
	fsm9prpk4V/qLLZ6pgoBFQHYT4qmhZM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=b4e8nJQX;
	spf=none (imf28.hostedemail.com: domain of BATV+4ad0d7335f7bc220e5dc+8072+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4ad0d7335f7bc220e5dc+8072+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759128045; a=rsa-sha256;
	cv=none;
	b=F5XmD/k5NsEwrDfQL6pP4Ze6jUUY7dKNF05eT+YQCrD2JqLRGUr2+mqHujo5V50siXjYyB
	elRC+FvPSib0C2FbsYzHR9N5boaHjBmTHFO6Spzj9taIaBk/otDiyQdfkZnwjDfZi4DMLg
	rtlB2idfhpLQ9263rHj/8sPeyMd0PVg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YacQbj1YmkiJVhrtk3+KVfBFzhjCzjCVTO6GT84rzec=; b=b4e8nJQXOeW+6CokvZQpUpX5YN
	v1Xa/jLEtCpGBcZrEmKuTYpfa+RbISQjDEfwwqwBYXMIMkBKLLrt1iRfrbd5pCYHSEOUqa2YLpSFN
	Hxf+spZ0GkJ2MGJmyjpaiaLmdwHGDRd8QdE0Rqv5h25j26GBq4yl8OkbTtsCxhuUhDzZUbZFNwZyS
	/3c/ZVOfu/u1Kl2L4Mpr2s+HqR9Y47zTpV7V5WAnNRjenrA89Pa/WHgimhsqwF6WRCq8pXQex6DUA
	dsm9aZFA0BFVAYTSx3MokPjZjAGRjDmi0ZW9b6Q+Unt7n0vh24/+DqS/3Mnt3Xd+VgKzzPLvWnBoe
	A+ndfkZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v37Yn-00000001VVX-0STq;
	Mon, 29 Sep 2025 06:40:33 +0000
Date: Sun, 28 Sep 2025 23:40:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
	byungchul@sk.com, cem@kernel.org, david@fromorbit.com,
	david@redhat.com, gourry@gourry.net, harry.yoo@oracle.com,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matthew.brost@intel.com, mhocko@suse.com,
	penguin-kernel@i-love.sakura.ne.jp, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
	willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
Message-ID: <aNop4ZBrfuqrX40Y@infradead.org>
References: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
 <68d973fc.a00a0220.102ee.002b.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d973fc.a00a0220.102ee.002b.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: idsubiz144wsactgmxagg69jafx785ze
X-Rspam-User: 
X-Rspamd-Queue-Id: 553E5C0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759128043-466388
X-HE-Meta: U2FsdGVkX1/8zpbR+GXBdnFcClmRb14TLwt01XOYX0tmYaev7s+szDNJZIhqBsUgHDqFvS2+1N66YSu46n5QhevdlrAsiS0NDOcn3tB/b1dJ20Lb2jRBFCGqlxbLaNlk+ZODyz0CR6pSj0EzMjo5DvEEg33br6o/7i7SncZycRhrBBHW7Hjlh+EGdahlnwfaozSMO/D7JvQhEs/PjdtTkZhfqBHz4u/CmGFfLJ+s25LTt86/8s3NyFNcCZbuY/A2VFR3SErCIQCSdy84eLjZ27iYTvH4QX8hmoPp6DDrzobh9d2hF2zk5WI5swmW+Bsft+OPylvnCt8FJX3JMfXGUYfcilap5FNEKjgRzPk6kx1FCZYJdpmlAq74vgJm7/NJClUfITAEkMykDAunZGhRB18ASVcJVo+My51a5P/Fu9+xekmdqaCcb/SOmepJwoJ8EVYE0ZajNM0dd/tgT1IN61V/5coHzjw2lfAYfuBkNugpVJJVJaE2mpjpPUa8YTD3JrvpIaG68k7XPNY6F7R+GRhM79p8QWavRfYPA5sn7aNRFtWkLf0qW1cGlX2HLg3kFmCsonfBEnllWNosOlBeg/K9sx8tzzgUZESLoKYjKU9MQWsySOvuMVOLAC3l3eZ1hXwUgDIqwO6Fh+hJ9vuSlnX/RBsMq06GyhvjLUxbWZODw5auBMTG9Oz5pr0gev+FDmOj1PcSN6TDmI9yP2S9ZIY1DrTyR8vGpJX6gxdG3HvyeboizbHl++lZ+AIOa5kvEPj7FilLJa2Dibcj6a3tk4+NQwSgD5OHcvhsLQ1vH26+rfA5puXaeCGBOKNYghaNiUDrOmbe6NvLPHVgF4EPEns12t/NcRDLQH9efhENW5yI+qN6tEi9mhTQ0IRNhvkXci1z7K1FKTuj+9r+Ou1zsNgkTcxf2mn8WO+yFDXSZf9HnJAcuXb6upWsWeZ7RL/jEHHTDo4sC4SSp5E5Qff
 y+J0DhxS
 oIA3EdIRrl8exkFLne4qoaXIro3SHLyGjshf03ENBEecoj1WfvX4qtWk/9bW1bUv3jUijjil2+uTlh1DxW0OO+dxaY5o3tPkOLFCyPB3XSMo7waH88LCG9vSWXTl8Bcvl4CzeMVFlNZXOUJB4D5K/nF1KADms3oPACJNrY9FJCPcChQapAo8NIqoc3MuMNYAB4EXCbL9EnVjTfoyEAW+NQTkym2j/86ZKrwCm+Ez4v+a71ZEJmK1OwnCrqjvZiohW+rLNM3mTO5YITBAQL3lPFpWx958g1Y49R/InYFxrJ8eX8QHaaXCV5LbL1V/u9+J+Y9sZ5/kDJLZrDlM82sMAEmCxr6AOD8nsV/lu781kJ73MWGNRiz73eQ26crK+WgqM4hRD2LsrPuXy0NEKEYawM9MEbYVo6YaIFI5W2QOTsk0e7q3Y1x4mPYk9MlqUYc3turezLdGj/QAVZtqCW8qzuUdDq7xjc84pXiHXFxOnv0izKls7zzIvE0tpSGmdGNXAW3sIT9MTrmB7T7KUBHzsABCtwxINGRZcgzuI/6VjowzyUAfDIurix+CCAIjtotuoXf8C9zcc760Ieq05ZckaaD1uyDVN1PlNRbwNZtB4f+ESXjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This looks like slub turning a < PAGE_SIZE allocation into a order > 0
folio allocation, which the page allocator then complains about.

We'll either need to make slab not propagate < PAGE_SIZE allocations
to order > 0 page allocation, or make the page allocator handle the
latter.

And XFS shouldn't need the NOFAIL allocation here, but this will break
things elsewhere as well.


