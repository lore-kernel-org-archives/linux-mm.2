Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0407CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A7A6B0088; Mon,  8 Jun 2026 07:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1D96B009D; Mon,  8 Jun 2026 07:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB7F6B00A2; Mon,  8 Jun 2026 07:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2FB16B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:15:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA333A0ABB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:15:47 +0000 (UTC)
X-FDA: 84856490334.13.C6E5AE3
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf20.hostedemail.com (Postfix) with ESMTP id 97FD71C000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:15:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MTm0efw7;
	spf=pass (imf20.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780917346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5FPC2aDwg5mBNqHLEf0QUYF464aa6oMYs9z5oC3+/mQ=;
	b=a1P6xIMh/unLm77NEEHPXKy+4Oq7yU8GBDjRu4QRpYT1FnqkGb02dG8V4hCGToGE3lq7hT
	SRLYTgG2nHkTDHjrJur36k3/CttJM1thO/Mt/AcjfrDcKph+wd+vIgFwIRg9Dw3Tr/s0B1
	b1U4+5w2zbL5LP5OIn5KlFpvrmly688=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MTm0efw7;
	spf=pass (imf20.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780917346;
	b=LSc9YzThZz4CF75vy/S8tFYA10AJNpR2+PZ1qytvlfDektYeAhoYx/ODGK1ga1doOyGovW
	BDFMuWH/WULSfjKJZBL9orH63ydOo2YcJGTbNEADg/UjMvRBWFskhiRkuJIw5K5sNWxu4/
	Du7zdRwblk15hkdet+KPE6KK1n+LLIA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5FPC2aDwg5mBNqHLEf0QUYF464aa6oMYs9z5oC3+/mQ=;
	b=MTm0efw7c9Kg084CS0dQqAJe5WrTttbpao8SeMxt3fefxTd2DcxZJBgejnC92rLgTGh2VQRaD
	Xf48sm+p7iPqkzJPii/f/Tk9j+WBsTc4bm9DguS732djCEQoW2VNpQWqvHnzcUGS9UMUx8Rqbbi
	zSWAaL1IO0t1RWfgKe52KfQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gYq5L49b8znTVy;
	Mon,  8 Jun 2026 19:07:50 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id C20E640575;
	Mon,  8 Jun 2026 19:15:40 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Jun 2026 19:15:40 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <sj@kernel.org>, <akpm@linux-foundation.org>, <wangzhigang17@huawei.com>,
	<liqiqi23@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] samples/damon/mtier: fail early if address range parameters are invalid
Date: Mon, 8 Jun 2026 19:15:34 +0800
Message-ID: <20260608111534.264-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200017.china.huawei.com (7.202.194.83)
X-Rspamd-Queue-Id: 97FD71C000F
X-Stat-Signature: ibgr6auwfhtwu4ct1x5whjnqb531f4y6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780917345-962256
X-HE-Meta: U2FsdGVkX1/tCsSLy03aSOLf+CFG2EjNKqTQ4VaPBvEiA2Y0dnoaPnEoiYV+//e5Hk5ufV5aXIqGAts+82eUOjS/rsXdKX8wYRCw/RK3J+4xMcTuJzJrAiO6lEty+q6V5iD6WnXFfY69th4nijZxMbnMLVOSXu6NUwBu31Vydngb6rRuEXzfVOzck0RkIuWmbOD+otcjizJyhQOhLjKl4DJSmmEIZQScta/6d4jXxsY5jehlTs1/gKCYBXnp0EX5CD63ta9KcmPmox/O9iM6FMXLUTpF+nh5i3M9022oQXs3xyYh9q8SSxoJcyQSeLJQ35TvbnfcvaEkchmnKTL3u9fF+ziRBGYn4ND4LswWk4EDjS+3Kc2OkriPA8wcYRqd8/J/jkuqqeq1aFaIt0uZ0L65dm1pWqySPPrANck9V+5XizXkK7Eb8awHQiWdoHSdVccprPeqc+KTRRd+rj+0xzZ1jZcNWOr1j1y/Xv6Aov/WfqzL3WsWA4Jq2geV6poCaGxp6EquySJZ70Q9k9TlBVspbVOphmPvi6Mh7FdlW0SxLz6Ne4OewBfXuJx8V68ZsgN2u3raJVl1P3Xn2hy9PcM9BlF7EOpzt/7BZnjK9g0DgWMN1ZtuP7vO7EN41SJcj3sMQZqkyIy1vz8zi46iLuePs30X0KieoCJKMiXBXwKpUDLYuH9FzFMyP8yjnX7VvFw5oK/Rtz8kBunvNZsg4Ex/86oz55vfVz+h+UO09/4pD3j7HY9zzJH/tkjASGxC3UIc1fi8XMA8OV3mp6EbOS7MILRbEI5laSndMFa+erGgN1cWAb9bHb5F87Fe30DnxPjgzfgIWIv5c+EZV4DwATZBz3Rlh1AvkEg9+WmicUQBVqNE5lrAb3/2Hfbmur2sK3+ZfJ6EoZGkOUnHoEaeiMdZB9oMvPTeSxFkpdtXQFjc5BdgZRcG9utMeXSKRs5CL4BqLF7HHHBEFq+wyBC
 rSraAw2X
 R2lWAJ5U//JoNnmkWqmzfD/gPeZg0oDpfjyFIwP0VHrCh9r3ZiYqq3wySPPvqqj1u2AqOuG8UFqwFEEEt21Rloca7ioQy7cf5/4OvWb5n2bspBSLIuB0jTznTAPAQyb7Or99N9Peo4PltVW+WIYk2dsE2MExRFIaIStHW9L0qkFh5wvlaCZHtvWZKqKr6ta5bESQZP6dI3uUx32ZTlEZuCjTSWaipRTC1zzXM0Nu+I7uSthAT8kRQIExof+6zJDA20ZtfrOa6O1AUOlvIfGhykr23Dv9wWGQZBOM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment on top of `struct damon_region` clearly says that

    For any use case, @ar should be non-zero positive size.

which is now verified in damon_verify_new_region() if the kernel is built
with DAMON_DEBUG_SANITY.

The WARN_ONCE() can be triggered if the mtier sample module is enabled
before node{0,1}_{start,end}_addr have been properly initialized, which is
obviously not good.

 ------------[ cut here ]------------
 start 0 >= end 0
 WARNING: mm/damon/core.c:116 at damon_new_region+0xf0/0x118, CPU#39: bash/34144
 Call trace:
  damon_new_region+0xf0/0x118 (P)
  damon_sample_mtier_build_ctx+0xd4/0x368
  damon_sample_mtier_start+0x1c/0x90
  damon_sample_mtier_enable_store+0x98/0xb0
  param_attr_store+0xb4/0x128
  module_attr_store+0x2c/0x50
  sysfs_kf_write+0x58/0x90
  kernfs_fop_write_iter+0x16c/0x238
  vfs_write+0x2c0/0x370
  ksys_write+0x74/0x118
  __arm64_sys_write+0x24/0x38
  invoke_syscall+0xa8/0x118
  el0_svc_common.constprop.0+0x48/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x54/0x370
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x1ac/0x1b0
 ---[ end trace 0000000000000000 ]---

Fix it by checking the validity of parameters right before
damon_new_region() and fail early if they're invalid.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d93..4a5d3fb12e1b 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	} else {
 		addr.start = promote ? node1_start_addr : node0_start_addr;
 		addr.end = promote ? node1_end_addr : node0_end_addr;
+
+		if (addr.start >= addr.end)
+			goto free_out;
 	}
 
 	region = damon_new_region(addr.start, addr.end);
-- 
2.33.0


