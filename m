Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E11EC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87ADD6B00A9; Tue, 25 Aug 2026 08:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852596B00AC; Tue, 25 Aug 2026 08:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768336B00AD; Tue, 25 Aug 2026 08:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 584CA6B00A9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:21:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF3BDA36F0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:21:36 +0000 (UTC)
X-FDA: 85139702592.27.2A13FE9
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id 762B720009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:21:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Sz8uslrC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787660495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kU+A+Wt7hykq+6fByqXAGIrE2CqDx8Nal+lBckyJZAs=;
	b=B/JPROeNNi8o5bGjSpm3AJrZWA22QczwTmleA1hOlBCLFmE/NnTpW04u3jslJ8wjnezWy4
	K0zZoEpKoXmVyLdrRqGXEoXj7QowFphBFHO7wDqIH0OHEm9UFS92w+dOLcfhq521t7GwCy
	1W4n3+G9FClo3wD0v14UbHphDFauY+I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Sz8uslrC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787660495;
	b=Cu5uJCwQo+kdJgWsAiXexOgjjoHuRjo29WV9mUz8PDs0UEXG1gKE+Q1KQU4iUx359U+xgA
	ynE/xYcAjrNfQwZYCOTiVNNKDoV+TwOomAlE/DRcPv0QUukdCm/XDruNuh33FnnkE7ESLk
	0ysK4T2F+UQ+i5Nanr5myC2ovWMbYc8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kU+A+Wt7hykq+6fByqXAGIrE2CqDx8Nal+lBckyJZAs=;
	b=Sz8uslrCljAOIqTjgzHB1V2b+lqiPf+sWFXli26StxyGbJvXoJVSoZwJoQ0gJIroKn0xGI2eH
	5Oa3u96QVTs2tRz2kOo2VoGgk9RfFV0y1mvKSoK572Bt6wHDGZoTMjLBSLZVZhXcdIXo9uruH0Z
	7D42Hzt3FBddtToAPawmAYc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hTmnp0Bhgz1prKd;
	Tue, 25 Aug 2026 20:10:38 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 08BA0202E6;
	Tue, 25 Aug 2026 20:21:25 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 25 Aug
 2026 20:21:24 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v3 0/2] mm/page_isolation: fix UBSAN shift-out-of-bounds in isolate_single_pageblock
Date: Tue, 25 Aug 2026 20:05:47 +0800
Message-ID: <20260825120549.966271-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Stat-Signature: pjnpzukfseoo6tnyp3g954mubfex5r8g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 762B720009
X-HE-Tag: 1787660493-486892
X-HE-Meta: U2FsdGVkX18mq28q12BJC7cIpI1nWQQRGvId21dkiTCk0mUjl2B6JZt8ZpmkQ/ybn7+8Y2fjjrzJtCzC/8p9PrBxrtVWw7amW5pwn0ts0sYm9xr1VKgjaJZ0D7RYjSUzLCkaAc3FLp8sWX9uwtLaGpdzG1m5uoiN9F/gZ4DyVEQbuG5ral+RyX4aNDO+p2ombTlthg64xg2nsd+cmu8UjIxXtzNmyqI9FbiV3SI1H162OowjbLqHkmSZgQEI2cN1T32Jqj3b36ymHkFvNAVn3vv6yG909E728HCd/22slo38qI9ypaxy2xeRjV8LHvx93txd0Db2dx1beFko/95+OD8FVcdwuHjWObQNYLIwvBk+aDyA07gcW92XAfa/qTTsebQtgwjrca/5BR2+zYi42RvOXMagAqYNPmNctJwK1Xo8uYoVQmy6joWMnf3o9VLAEkR9aqCh02dyW5CA581PR4p9pnN2BJzeXaD03DJvJ9f5tad+AwNnew1ur3ZCp0/8/LjS+MsT0HnfmguJHqsE3Z3J5O/1GRrC6V+fvJHxhFyGdZo9yP8aOh/ZfvJQrS7n77N0reVD8ri+JYk+XRDRlW1cc2hqpz1X/HVYIwX6o/O1/+qdXGZkD/WVJnU3kwXkztHpH9b2IzHzKhOiCX6Mz4JlWwbjKo1l3SHV5/HmMXa3QhPFokI7JpORiTjLSpIEwhvZ4diGsxKq+rgbXjsJBbttmHwbW8PiX65XaOztl1F3sD2OJYoutgYp3MVO5cOUfnBONnQK3wuxUWFm6ejQCc/LG18ZEUzVmIzeVIVKOKme2bCLWdEdcsYlJ4XrzYzhUiaN3+U3PkLqDp8jjtAP2Tgh5Buv+Kd/2+leddr2A0tUAm1RFbftqxig7GPtlIaDG78N+OiSL0EbOFcESZaNxmhIx6oaMr87bbSZCCvTFzle6zSEtGJoZO0ykT+xKyixf69pVcTEXQd+aWn8PE/
 3hpMa86b
 CPWniuNf0wP1kHJTkkembrw8Ah7un0hLHCEmdMdno+2U70s8/9T4J3Z0sBAbDduH9/W3G4JKj9XeY6/aHvX/XYxUZDv99Wk4GjbgoYEHRPAHkUki/PO2864Jb66DOSlLvsKyWaWu18bUYrJ4e3xvyRpEb7Nk8G2EyaehjJAVwlIC5eu0W2OSrlrkYHkA5Ip1fKTb5hFnGMw1KnUs5gMa5fvz/G7QsX7fM540THEZGj6EMPeGUY8Qt1onK9Y5yvryJRupw/haWVVqvx0O3yNJgyfnbZcM77XQmVmU2LNGFr5YZgg8SN4CXWf75JZlGzO486SNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 fixes a UBSAN shift-out-of-bounds warning in the PageBuddy branch
of isolate_single_pageblock() triggered by concurrent buddy allocation.

Patch 2 addresses the same class of issue in the PageCompound branch, where
racy compound_order() and compound_head() reads could lead to out-of-range
shifts or incorrect page skipping.

Changes since v2:
- Patch 1: add a comment clarifying pageblock_isolate_and_move_free_pages()
    splits cross-boundary PageBuddy. No code change.

Changes since v1:
- Patch 1: drop VM_WARN_ON_ONCE, bail out with -EBUSY instead
- Patch 2: new patch addressing PageCompound branch race

Qi Xi (2):
  mm/page_isolation: fix UBSAN shift-out-of-bounds warning
  mm/page_isolation: guard compound_order() against racing

 mm/page_isolation.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

-- 
2.33.0


