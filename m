Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A87FF60C2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC846B008C; Tue, 31 Mar 2026 00:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F9C6B0095; Tue, 31 Mar 2026 00:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7336B0096; Tue, 31 Mar 2026 00:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1346B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:18:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 355158CBD7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:18:52 +0000 (UTC)
X-FDA: 84605052504.06.110F31C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9224510000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:18:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q0j9+sxl;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774930730; a=rsa-sha256;
	cv=none;
	b=djy5UY0iv+EYgiRfaTbypU4eT6NBbnC3WKRtdKLTcKpc6pNzqdeAIrrWagwnEl+a/d1jEG
	ds1xjATGNbum2LcFsk1wqD1jRXK5IRE0yzy0jk1iTj1fU/ghujpH39i38N/aunVZ6Va01B
	tr9IS1BoxvmPbkVXNezM1fyFrFt2MyM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q0j9+sxl;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774930730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YPEYrx2KoWLOWVKHshYKYPi1T3Col0/e0HPuW6yJMU=;
	b=ePIMRbr0oCFzF94AnPdSCoFgMwbd+dFWQ4S+V2Xl7UzgLlqjVYE/iv1XZU84h3hfV5rUTJ
	7I+voS9C2AMPa+RofoDoBDR/kmwhKNIalzDu9ZksOd+YE7H6oSCq/8QcqTfZeHIQHlJ5Dr
	Ep8DnQtDjd5stQOD/wPlfDrmq7svNmk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30FA841B05;
	Tue, 31 Mar 2026 04:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55B5C19423;
	Tue, 31 Mar 2026 04:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774930729;
	bh=OSpIVe29UbdvbUCBvkXi5tp6fu4U/6QSDun7Xql9Q4s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q0j9+sxl2WHbwhzae7hyXyPKIaMAE1YcTzOf/JgGqnIipaHQHamJTixv6+faaTA2g
	 0rxQzO0yuOQbX/yrQECv8nEMi/UABRc/JRkkf4S4tKd8rCpq0L/2IKuRz23a/P/Tgk
	 pSJDXfWJ3b9gTHpriv9QQXNSGZ0ZfW/J37WEu2kc=
Date: Mon, 30 Mar 2026 21:18:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
 <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: Re: [PATCH v2] mm/hugetlb: fix memory offline failure due to
 hwpoisoned file hugetlb
Message-Id: <20260330211848.a838814f501463ea8f003aec@linux-foundation.org>
In-Reply-To: <20260321021031.2240780-1-tujinjiang@huawei.com>
References: <20260321021031.2240780-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9224510000A
X-Stat-Signature: ytags4owhi5kr1cmq9xp43g8ehwpqw66
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774930730-28362
X-HE-Meta: U2FsdGVkX1/fKgE3epiflVe3rMD86drc/4mNJeXhpobMNlyupCboffixBe58Nz3XWFWWQ7v2IwFx3Bv+Ga1yNCXhGLxVfMvjgGLDbSi2MPMFf3AHorglofdYAbvzLtkVPctZ6qYVb6vMBP4TC+QqYSVlIifVmG1v/j5ILnA+62OXbV5TxYpxFcSHAm6vCDcJ+NlX3RD6Cz7Q2TEJuxo9HTQeAYJnSoTPZ5G/Z4PYqVxmBViKWuo0/OAkWiwuxv7uixAdV499BpLETA4qllBHuWCxiC96xQiiMWwn1ySMyiN1EG53DuTLLBN1/PuUocYy/1k3ZcC4rjMwu5daJPxFTz1MyMpa1RSMrmJZA1qBTPp74J+6PBZFpuDvEPN4ysFM1UdSM0u2c0QwBUF3YwKliYhS1Ya96Hze/mo2HbCOYjU4tgFrFnQHwSoWxAYvFWzo77HS2kg3bubFocH2yokwSouy+7mXQFfzhgnh74Q9tWQp6MNmyJogFN1ZRvpXmNrQgz0BqrNC9XrkS6e8PlbweizLEt8QftRBuWFPUgaAwLCX/QqD5qnAyTRTb1YrmKj/lM5OOQMR+YnSoyT0ELTzTw2zPa8yM00DkUp2TmY0JZaUvJS/VwbzOIsXcgqxt8veou5B5HcUNaGzGyz2yYFG9hjxebmc0Y5Ghf6GVtOrwvUdsSXnC3IV0XE43XimY0jZck40oAFwU+ElMCzO/8lenw124gA+b40GxvmcW8fr4kPbOkWxd1PK49c2Pv9cpZJ82zRpcb/m5hGpv/3isSin2oQq9EYeFWAY5yxqPuRRi/28kw33CvtU2lPJcBCvrm0Y16G5IyqOSQ2MS7qj8qkyJRS5DsdJ8g2RLQnvri36DPEplKoqjpuc74SRyCJJpv51kHu+68ZCSsXhGXW52ZyKbP9lqRcsThO+KEpHHjkC2yVAWnPlCEe69y8Ugj2Hw4qJCCNRvAB3t8eA5IOxmGM
 zrE2Ey1H
 2gSMQQIMuBf8A3hRyUigg3AlZ6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 10:10:31 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
> after the hugetlb file is deleted, the hugetlb folio is still leaked.
> 
> If we want to offline the memory block that the hwpoisoned hugetlb folio
> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
> hwpoisoned hugetlb folio isn't free.
> 
> I can reproduce this issue with the following steps in qemu:
>  1) echo offline >/sys/devices/system/memory/auto_online_blocks
>  2) in qemu monitor:
>        object_add memory-backend-ram,id=mem10,size=1G
>        device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>  3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>  4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>  5) run ./hugetlb_file. This process will receive SIGBUS.
>  6) remove the hugetlbfs file.
>  7) echo offline > /sys/devices/system/node/node2/memory136/state
> 
> hugetlb_file.c:
>   fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>   fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>   addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
> 		MAP_SHARED | MAP_HUGETLB, fd, 0);
>   memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>   madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
> 
> To fix it, force to put ref of hwpoisoned hugetlb in memory offline, the
> hwpoisoned hugetlb will be freed and succeeds to be dissolved. We couldn't
> avoid races here, just like commit b023f46813cd ("memory-hotplug: skip
> HWPoisoned page when offlining pages"), which force to skip hwpoisoned
> page regardless of refcount.

Well, David sounds skeptical, although discussion petered out a week
ago.  We haven't heard from Miahoe or Muchun and the AI review might be
seeing some issues
(https://sashiko.dev/#/patchset/20260321021031.2240780-1-tujinjiang@huawei.com).

So I'll drop this one.

Please feel free to resend after -rc1 if you feel this is a desirable
change.  When doing so, please review the concerns which have been
raised thus far and attempt to address those within the updated
changelog.

Thanks.



