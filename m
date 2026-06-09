Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C9DCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17D26B0005; Tue,  9 Jun 2026 02:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8AD6B0088; Tue,  9 Jun 2026 02:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE7B6B008A; Tue,  9 Jun 2026 02:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E79D6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:47:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38F801C23CC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:47:10 +0000 (UTC)
X-FDA: 84859442220.25.9947C0C
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id A52861C000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:47:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FxGQcsb1;
	spf=pass (imf21.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780987628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6O9vE//ZqlO4Gb4yDRMv8e+QwkXD/QOq+MMZNAQa+NU=;
	b=UNsU2MtUPrcKIvi/BbJlh1s7ypSnnZrtaQ526rg9BSG1bbGwa4+LEY0bow7pbv67TYHOB+
	2Yqcb/tXHWLrVhnifeyLQfzFrOc6AK0Nf6sw+JfsH5TxhUwpcN9vsWvciv6wmcx2lsYdEI
	LYsJUgnu/Oq6mNdy6gt2VoZRkZZfkZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780987628;
	b=AiUlwyMDh1ky4WnNo9/Od+MklQrVmosgwD8RadiXyeNDEBffojP9PIt9MDoyGWkdlAR/Pg
	w+zNCWzSlqd0AyA/ZWXyO70Ya7wya0SvDqbfQ6yOzR5fqLIuZAn4uojCaL24cvhDvfG7ew
	s/H8KgyV14S17bshEEVmwaC511P+5IY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FxGQcsb1;
	spf=pass (imf21.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6O9vE//ZqlO4Gb4yDRMv8e+QwkXD/QOq+MMZNAQa+NU=;
	b=FxGQcsb13I2Xm9LCs9JqyTH3wH2YCXzdIa1ZW0Y3G8ZTugZfgqpTv7RDq8ZRm07YCYsAI+26Q
	yMdHk3U02w/yMBNoPl0jIsqK6/uCpEkE7qKRFOmjUaqrQ1o9woK4h51AO4Okqv0sR0GYA+RMEWL
	cYHoHEVGHx8kJsKyPIPaXwI=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gZK4n6WTjzLlSX;
	Tue,  9 Jun 2026 14:39:05 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 149EF40562;
	Tue,  9 Jun 2026 14:46:59 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 14:46:58 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <sj@kernel.org>, <akpm@linux-foundation.org>, <wangzhigang17@huawei.com>,
	<liqiqi23@huawei.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2] samples/damon/mtier: fail early if address range parameters are invalid
Date: Tue, 9 Jun 2026 14:46:52 +0800
Message-ID: <20260609064653.1829-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200017.china.huawei.com (7.202.194.83)
X-Rspamd-Queue-Id: A52861C000C
X-Rspam-User: 
X-Stat-Signature: g5jx7ghju5yjhf8yqfj4ajerbt1agbpn
X-Rspamd-Server: rspam08
X-HE-Tag: 1780987625-770887
X-HE-Meta: U2FsdGVkX1/5ME5sIFIuwYzRgHC7wwV3eiv8TMhqGcDC66jiNY1KczN3dWErDQZiOOQGvpBsvAdd91XgJFj8QWSpXgmfujMZhAZw0kX5hGoC14I7sCTaCjosMO2ijNyTCOrqR0PRKtcvOxFKzGn8v2bjFQ7h4tGokk3uBHweO3hNutjP78H+Xim3PJ7vkyOPZiHTLNR07gK2q+xv7xZM6gr7EZcS3UE7+fJ4rNSaO/2cPt+x3QvUa3CWSgV0NdoB52fn92NoWfQhbQhE71VZ9xosoiL4ThMd1vGJogzBLdPRpuOfzcmCQWBzaEmcWRDx0UbwYLmtoLQeuzJ0LqgKCd03bmlHhm9bGIGgCkraXclpQfL0AXgph1YiWnCvoAjkXdPYskmJEPxZuhBgzGRr4JCcZPqyq+1Nrqr6GIFmgT0ItT0I2p8g/f2qbOb1XtsGJF+8FT4y1PRzY8fNwF6GF+vO4u3iQg+mqbXlNu7oJepIHl+P061RTamKSMVCQGnn/PlL/kZFnZekuQlGIYmqgeNTBnGsD/XHKeLeWl6pZhsRwuMrMeCC2FH8clUxtJB3Hil78Qd+pySk9sGlzeYtjj475g/6GxX+9RYqeUFqdopA3nLjmh35sSs84Ex3LpUSY2vAb8u/hI/OEOto+2pvMb1V7a1a8bbKFuNEJJ4CG0ylxOBeIiGVbd6kx13Vf8uisZRKcpV7D/sP1XtjQkS2Of30XCeTv3dFoUd8pQklvYNGaq9b110IgxtVZ5kuvGy7LeN5D0FjyRTbogjIPzdBpj/I4rX4MNtHTI6IMPC0MU1RA05aARUl6bp8wlTA10h68ThxLS9xZlrwMKimSZ+B8+ug5qimXqt+Nzjp7fwd3YHP3JXqn3pbRZ5/UyXFtvQHRbr2uuYV1sSWU9K5EoQKibkZBy5KQjarvjptqUiX9gcyOyw/AN7jRlKR5E2WXPsmmW8VaZjPOj06389GA6m
 3NKdftws
 5UXBUS2VrNTPJ4le0FJjmJBJlFh5ZX9okTZtDjMNqIM0hTFzw4Zpus/oT+EQjeTFlUcG4WYslsu+/lvWC3iS3cHa0YD3gKvS1fef9LuP9udfI/y51IncCOBp8dIIk/qpxgBzIzCusgg2/FX9oxyeYnPPQEEMJydHmUHQDxPhBPQAqOsIlVVA4HCd6l72k5vWdyc4E/YgHmYLPOe+NN896hpusi4Z3UTNiRjrufQNo52pPd3VRNm98p9iKqMszXvS+K27hux6ggq2evFPrx2q2WBuTg09tX6LP2Ak2tmjlC2XNpqYhFQs99imUGw==
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
 WARNING: mm/damon/core.c:217 at damon_new_region+0xf4/0x118, CPU#59: bash/341468
 Call trace:
  damon_new_region+0xf4/0x118 (P)
  damon_set_regions+0xfc/0x3c0
  damon_sample_mtier_build_ctx+0xe8/0x3a8
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

Note that the same issue can happen if detect_node_addresses is true, and
node 0 or 1 is memoryless. Fix it together by checking the validity of
parameters right before damon_new_region() and fail early if they're
invalid.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
* From v1 [1]:
  - take into account the detect_node_addresses case (Sashiko)
  - based on mm-new (SeongJae)

[1] https://lore.kernel.org/r/20260608111534.264-1-yuzenghui@huawei.com

 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index eb1143de8df1..3785b0c7ffb1 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -120,6 +120,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
+	if (addr.start >= addr.end)
+		goto free_out;
+
 	range.start = addr.start;
 	range.end = addr.end;
 
-- 
2.33.0


