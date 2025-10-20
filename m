Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F4ACCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0328E0024; Mon, 20 Oct 2025 11:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3505E8E0002; Mon, 20 Oct 2025 11:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5658E0024; Mon, 20 Oct 2025 11:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8F98E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:06:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9AFB1399B1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:06:30 +0000 (UTC)
X-FDA: 84018818940.23.5E8C106
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2ED0F40004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:06:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sZdcZcDB;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EETKSaBBadv9Qa09qrJ0ao8aohhvc/sv6C7kZ+5YJaQ=;
	b=IsD62m2I4D7xASvIiFfWT5EbwoU9INTLTmhZzxbMye5IuWsQNP4SJ1JeBcvyAhBqiKetAy
	w22mbSdKzoGWSL9m1Ax3z7GDBuqJcQr4T88N6x2fz2ntEszVA2BkSMWYoXYoiJenr0mA8r
	riHYMYr2kPMi4RCwQV+aa7Hu+EgpmXU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sZdcZcDB;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972789; a=rsa-sha256;
	cv=none;
	b=p5IposLyzUqYjj/UWpD7exuI3h8kmVgiJTXQ7Q4tzSbmvkh7f1JInb1nwmEajgpwtJbwtZ
	KnvIGdZ2ozRgBO4dxd/dEZElDWvsn9/SftimhJe5xvPisyPYh35dcNopbdstAz2oXUxhTD
	jE6tSXfQHWcI/nFkSSfPkTKz8YKJvuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52B1761FAE;
	Mon, 20 Oct 2025 15:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC2EC4CEF9;
	Mon, 20 Oct 2025 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760972788;
	bh=Jx+0bHoZRra68oiIu/Fb1T1NX9AirIX/qKXZ/176/eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZdcZcDBryJILGpdBSHUtPft7MCimeWMPyB0O+afFG7JVBbqrnkXhvMI12vtYWiFA
	 NAsGpNr5s45X6ortFiSnLfngd58KVOInHf2GHjurEgfx1c9pB7bUr5W754Vl1pJFIk
	 p9cFAxiyFRqhXAPnPNfWoTzdyhOJsTo94VkSV6U9zOy+7QLCTTYXEbKmJuD6YTypwv
	 fWrfYol2ndYIeWcWvjtP/BTgazY1luJhuCfoKnguZGmjjmNp2U2GFHKBlgsUfZypbn
	 lzp/sMEgkyjck01zD+xHEvKjydSAVpYCAjGHEVdF8C5gzTjyTgokiRPQ3JYw9wbpmw
	 Gydx1eD2T+9qw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 0/2] mm/damon: fixes for address alignment issues in DAMON_LRU_SORT and DAMON_RECLAIM
Date: Mon, 20 Oct 2025 08:06:25 -0700
Message-ID: <20251020150625.34941-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020130125.2875164-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2ED0F40004
X-Stat-Signature: gdnbpfp41ocdskj3uqgxues4t5qfyxc7
X-Rspam-User: 
X-HE-Tag: 1760972788-390384
X-HE-Meta: U2FsdGVkX19GC7a70nqC7m6rWKCSjHLr/j+YIhPibyB4wrRu0tBoHOdZmZsSKYCZZIXdKad1JisdCNwpq64c2MA4LBTIgVnmKcZV5t6tOzMmLat2iIed1YUGi6Ycj9UVkzGnA0Zx3zlxt3e8aTRxTHIgbhAhQAykEt1v1fNVq7KQkrcrma+HNvViZftJ0lHuIgygQ2iqS6Dg+S+bHS0jU/A8uH68cIi3uCnwAW1DSxougewRkHEgn+D+I6nzH8oMLk5S8V653lmB5wXMkW/+SBMwNtOIcVjZFIs6Xio37S5708RZpNE1OYTz5s0t4WlW5U7VTN+PaUNVlqkkTozZArttqphHR049j+RU8Y2EfpCVt3ydXt87EbLdsA4RV8rQIsvf9PHxWraWe57z+lsbcwy+MPUG6ekA86qfKZkDD73nHJ4vLyc0EGLcQp6kFey++aguqU4ib3pQkJwx0OYbZpIvQIshpVobyiUnwMIZ5ZUKlM3TQAuA16ROUNWE0bRMd3DkQLdWs+Bv1smyj+Ks+CYiEL9+9S5//SKcmyZP5d1mZkywQLiUQMzAoEyth1TKHBi4+QdGxgxYRaMv/hnA+skX207+WG7oRus/vxShzYVWQWjLAYHvMGFRlvRbx83ApmijY2XbkH+mQYGx/k7/a2HA305Y25FWJiyHHxuB5xdq0+W017tR7QsoHqREZvYuoKqb1jwo2WLS9K988PTCQyDbXVasQfWbNE5ATk+sn8bgqF3XDD+/yMeoEpplxvKecmUHm1Moz6xHZERXYAHEnNwg9ot6MuiuobAhA7IVQmfa1pqJdfQPxLQGOliGbusnsQ8fyPL/HjObMMH/spxZnJpCi4yRSo2z7MXuciupCquLjg9T3nNzGaMC1vXMO9UMsKtDbp6nokI04TldX65d4RqnG0wc/RSMxq3Oju3d8S7pWJdZStXQfLaFlqYfda+cbETpdQTzSVPfiXQlX+F
 Ae5SZqdV
 ur3z5QLJOzBUPLVGEERX4v0Vk5FnWD7OqezhtZpXnX6DPZ8m62W92YyLoVwW4BmJcm0AjXS3U0hPTD/BRNnMhoqvoCblCBShoaFWyr1dkgzIxx4KyFf9bImPs2S/8L/ZLK0EqaFWHYUm9sQ8QkOQj2QIPIm8CTFUftM2aNC52PnrFfyX59xwI15lZl4574CAr+yGg6iy7jqqaBoT5jMwFJUYrim9ipw5RjXlMOj6KLW4YNwGeWA8WSQ3ZwoVrL6+CwmsBar8lmj7FgyZnue6NrWMxJrO7ha5B01dsUCyD5SiyTVA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 21:01:23 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In DAMON_LRU_SORT and DAMON_RECLAIM, damon_set_regions() will apply
> DAMON_MIN_REGION as the core address alignment, and the monitoring
> target address ranges would be aligned on DAMON_MIN_REGION * addr_unit.
> When users 1) set addr_unit to a value larger than 1, and 2) set the
> monitoring target address range as not aligned on DAMON_MIN_REGION *
> addr_unit, it will cause DAMON_LRU_SORT and DAMON_RECLAIM to operate
> on unexpectedly large physical address ranges.
> 
> For example, if the user sets the monitoring target address range to
> [4, 8) and addr_unit as 1024, the aimed monitoring target address range
> is [4 KiB, 8 KiB). Assuming DAMON_MIN_REGION is 4096, so resulting
> target address range will be [0, 4096) in the DAMON core layer address
> system, and [0, 4 MiB) in the physical address space, which is an
> unexpected range.
> 
> To fix the issue, add a min_sz_region parameter to
> damon_set_region_biggest_system_ram_default() and use it when calling
> damon_set_regions(), replacing the direct use of DAMON_MIN_REGION.
> 
> Changes from v1
> (https://lore.kernel.org/all/20251016104717.2194909-1-yanquanmin1@huawei.com/)
> - Added more issue description in the commit message.
> - Split the original fix patch into two separate patches.

Thank you for nicely revising this!


Thanks,
SJ

[...]

