Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21505C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD9F6B009D; Thu, 24 Sep 2026 03:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACF96B009E; Thu, 24 Sep 2026 03:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875596B009F; Thu, 24 Sep 2026 03:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6298A6B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:36:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7192A02A9
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:18 +0000 (UTC)
X-FDA: 85247847636.11.EE66676
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9F1BC80003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iYrPQsXd;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0h6IJhcmiEtJdjoFG8xXoR5aFr6QBu55uhw+svnqeNY=;
	b=PLMWdXNCTkpNxXONNgLrjhfvwuE3LDBG3RIfmEa7yw+8slwl2h7bPpjceqOzuCM11Z+sCe
	uTWWWmaRTvKXuPTKuG3x9Pfh81/Z9CFJJShn6nE/aD6OauDTrmTbcWlkPyimsdyLJaIeSB
	ONt5Uv1WKlmjMEhsRmeS9x9IBnBOfq8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iYrPQsXd;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235377;
	b=W+Yu0LqBz0LvW7d3+RPYFTRoN70Xrj1SAsDI8/RnMn0pGtioNhzFpZm1qpOgMjXAE8p70Q
	YSDa4n+N4e07vj/m3IIPowIlEw7BFxeY4fF1Qis+CL8rpSe5jpF8rCMDC2kt3Gsr0FQ3s7
	j0KyGEFwfr7B/Kx3ncvgIUwbFrffDOc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0h6IJhcmiEtJdjoFG8xXoR5aFr6QBu55uhw+svnqeNY=;
	b=iYrPQsXd2Wy1Wk1bSiOR7getgDZXSDXLXyQ1wc59ropjoOVpb7McqRxbpvrLoS3QGDoWOo+Gy
	pUXez0EL4XNgGTZ6YsHvqxuXjoF9uCU0QGFCSqvesgGux/0HPrDIKi6D0JqtPnTUEeI1boGIFhx
	DO3LRhjVEfQqCVYRPpA1KTc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hr52741s1zcb4D;
	Thu, 24 Sep 2026 15:24:47 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EE9F4057D;
	Thu, 24 Sep 2026 15:36:13 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:11 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 4/5] Docs/admin-guide/cgroup-v2: document upfront socket budget charging
Date: Thu, 24 Sep 2026 16:02:18 +0800
Message-ID: <20260924080219.1036588-5-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)
X-Stat-Signature: mesynas5dbordoib5pqqn9oqr7pqspyx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F1BC80003
X-HE-Tag: 1790235376-375162
X-HE-Meta: U2FsdGVkX1+QwYnj81C81575z1+LwYMTwdXn+h0HF2sr7Ka80vx6iPHxHPQgGR9heiIAsVnSDy4/sRuK5Em2Lk4H0o779+gfSoxtxsO94x2zYEDsN65mjJN8h3v25X2vXAw78S4pH4KJHhWX26sCEJmgF9vgt0X/4GKYWvkg5FMg8P0K9Q8YvXiTVYDsrxh9f0vVDfkJe15K1Wn90rvI449tdRMNZ9mD/TGi0M4hxbrN6SPymnD4Z/v412xmPtx/F6ZB+peZU1pKTe0wPNzwzmCBwvwxwNIlIxE6fMHpKxtMjzb5uJa3u6AVvh2B0dJ7KRx+/TZFz/bJy5RkhNmup1aje58yvtD2AV587Pa5cwD4szcaxj3cV/JieT+PJXA/HQYyDv8vlZ7uSLEpz3ci75Ge+IAH1+mCqhMjUM/cp5W3ZQEISkBWAnXheE7SNuzVoW8TfUPSlttD4wo7h2l0Ok93mnwtRisTrZ+zMrsZpHFra8DkvXL2OEf9E3fMPuXlsw5B55QXwXWQU3hcE8qZFd1T9YVvAaKyTlqhH8qZ0pVdw0AjsV2r5hSE0L6cx5Ea8pyqRxcyouApN3xYbh6DcOUglH/WeEAUwy3XET/Pbjewi+WTG5PSg99W+Ze0v/hh9nZPJRv9QU7CZpMZCXI3iBZqaVrPTjVToUDiArF0wuUL3NPPfxtNyjIygJIPjJv/NVghEZuwz/EpFSgAucyi0YoG7t7doRh8APZakIbFsJDSoadFKeCQciuSkggccUyD4hSsdfjNmYw3GI4xW/wRNZZWboZFvlXYxBFaO3gIneWMbcZfNnWEUf46gdkvGB6IYMpaMz4Ztd+/GY6+DhefGoKNRrkpCxniWi+hQOYDeMMKZCX044FfRePJbOIhTHsKRlfhtUw3YCPBDbMzcN/k+FvL0jWXxOxysNCCY60z40z6wRZZM1+xE/Ci75F0bkiNnA3PFAaAtilxSMXz4h1
 sXBAMAY/
 0lhJOOrVSr9CKBd7TPzQXzSxsgm9F7Hgl+ME3iUIs40PuLYVzRGX18OAW8excXvdZs/ET8Y5ZDzktOK9j/1PaJwOPSxgjqY2VDq4qRmXVDhg4E+kjMNoQiNM7fhDfKaG86etvzVWyErocZ4gvdd4KIuMf1gr457Sy5j6YVFelPe3pjpjekQRI17gbpVxoZq6jRIBD2g8ZGrvUIOxcfSbkSuRxs5jLv7y6bGZyc9iTyLvKHOlMCbMIOvRcWgB2Fi7qIRHrFGEjOI/g4x8xIMkGmHIO9DSahyQSIO1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "TCP socket buffers" entry in the memory.stat description leaves
the impression that the charge tracks in-flight packet buffers.
Since the budget-charging rework, a socket is instead charged its full
established memory budget (send buffer, receive buffer and
SO_RESERVE_MEM reservation) when the budget is created or resized, and
the charge is returned when the budget shrinks or the socket is
closed.  Say so.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 8d2603751c51..4f26a459cfdc 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1309,7 +1309,11 @@ following types of memory usages are tracked.
 
 - Kernel data structures such as dentries and inodes.
 
-- TCP socket buffers.
+- TCP socket buffers. These are charged upfront for the socket's
+  established memory budget (send buffer, receive buffer and
+  SO_RESERVE_MEM reservation) when the budget is created or resized,
+  and returned when the budget shrinks or the socket is closed; the
+  charge is not tied to per-packet buffer usage.
 
 The above list may expand in the future for better coverage.
 
-- 
2.18.0.huawei.25


