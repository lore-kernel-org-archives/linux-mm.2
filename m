Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F770C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962756B009E; Thu, 24 Sep 2026 03:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939E16B009F; Thu, 24 Sep 2026 03:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8500A6B00A0; Thu, 24 Sep 2026 03:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61DAB6B009E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:36:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9E31A0246
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:23 +0000 (UTC)
X-FDA: 85247847846.04.5857BD4
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C045140007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xo4e0qcW;
	spf=pass (imf26.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AM/1COYI+X2cxZahYdg2nMaQ9CPWb/Pi9FF0HZq9dI8=;
	b=RnCvvHOpOFqKTCszZ9bm1pUiXH+UEq0tS4e6YRS+Dm51+qWkxYOy49WS+uWsNd5Ko6yYYC
	eVgtspvNTzF4kilZegGgQBZ84tIDmL+BtRkXjgP7TwBoXzRWDj/uY8J+4KEFi60yMEX/7Z
	wOx1Nx1e26DsMeYjRtixZtUlypQVJqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235382;
	b=n9iPMjo5kdK9QYBERCHmTT2XvzKv26rMTrPCXSFBKbqHmE3jy3ZOu9qKbCoCPuWM15pfiJ
	Gtn8dlSGetU8Oj6wXGpLZGfrV9Zos0x6TU3zJ3ohWc+Bm1I5XHfw4kUaXe89xwCPhF539w
	sGIya0zKmso0YGnIxsySQXaZBw0xvTc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xo4e0qcW;
	spf=pass (imf26.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AM/1COYI+X2cxZahYdg2nMaQ9CPWb/Pi9FF0HZq9dI8=;
	b=xo4e0qcWYUKb+XSdoEELGMTI9wjW82TMlWcj31whkd2V3Qjx9MHato7sp5L3DCl4rrjFgXAk2
	l+apV22HWtkX2LDdzIWioU1kaq2lpBRU81qUybOOqT721sSCyjyEdMe63VVppSohvA0QfMgfApF
	wvtZ8BublnUnhUv4ijDY2XM=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hr51N5Gw1z1prLc;
	Thu, 24 Sep 2026 15:24:08 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D41C40537;
	Thu, 24 Sep 2026 15:36:16 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:14 +0800
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
Subject: [PATCH RFC -next 5/5] selftests/cgroup: compare socket memory deltas in test_memcg_sock
Date: Thu, 24 Sep 2026 16:02:19 +0800
Message-ID: <20260924080219.1036588-6-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C045140007
X-Stat-Signature: xyckt4hwesjbfikq11nek8u6c7wk89hg
X-HE-Tag: 1790235380-629756
X-HE-Meta: U2FsdGVkX18GeW+Gwn8NCAiCQIE+jrPVjUd6t67tZkpDcUd/NP4tMA+MIlpf47hRbx073qaiE0Hx9bbU/jPa4e1TTvfE9GgKp5SUSbmLISXhkaLNcSKMJSaBZkCnjRCHJynuheKdytHUIn+Y1fGHx3e38eWPkfrEttqXArV/LJCVEtFfvCIpGwAupcktBBOe+r6JHqSuDL6LEHXarlx1ay4FktTmwfL2c9vf/pk4PVc9tBuIrtLipuJA/BBLof3Fnty87jeJSHg41JWFVSm/0LrmzloTL2/ytKVakp/mGXIrBwBb9ApzaybziWPOVCjzmWCcRRdF1ZBqvBi8h5PAhHzLAxWa7KgBo8c2VQbLd8U2EdhU1tvAlt87xpSIsPqRnc5kmaxvYsPX/Z9b0/MxBGTON+YsTbkXQ0RDC6pTsrsDMK/6nozRKaGS8hNYkIid72/WtVvin4Bi7Rtzo17q7h6UYvMY2LCxHr1kj0VAPFVE+akMYdZB+VjXXUWd7CypxmYSsEXkyUCbVLNM+AY4Jz2SjLNjXw2iVdCaf+a+2WhLxKEudahv//4vkQU2FR1yM+2Yh/CLv97ug/n66wnQrPRQGQZ8DMOYVFVcdTd4bmcZQVk+7W1/u2k8JIGubg8g/mzcCHPxgsvB4YT0iiSf2E1s+C2spPIyMvsZLlpwI14h3Rh6rIc/GWisxnKdo0Mbuo7brxr3qlhXDTeX6aeg5cMjkHaMDUdHnCBkeLu7fTz2jczBJrx71b5kTrbhiU15YECdoKSNqrA3+lukY3EBcaVR/4ALfLiBucFhJAq5CxHF7H6Tb4dCH5h3Rbji4y0wzj8iQjbN6UAqkGlDoIfZtjmp6Aid3/CMd9II+xh+VmZ+Hc4LMxl3unH0noPpju1ShhyAT8Yj4Pe2ZFCcG7AICYItlYjuCySUjYVY4/tJUeEpe6eODLWdWcnctgVzdI3FAb+1DST73bEkP3OFTt4
 wXfv+WZg
 dXhAygAxKGaXXj8ZiNhCk/Y5ZRDr8D3/MunDLxJvQa9Kkdfmn2EXwsVLCFzZVMSupGt6lllChGoker49JXxwWlRG5xNHN45DlBCmeOnqXt6T/QwvSgV2vIoRmQFyLdztSxNs+/RmmnTqvjsfoO6sB8cIA7DOnSkT6ZaukSDG5ImFAkvMg2BHUgzqr5QCdIpcWmCJpqSLqXfZhR0Aw4YJsqIWHuVpRS1mr+/yQTxxdXUCrUS4vn4afOFRgIxWGwSkoxWjUxeiKms+zlj6+MaMN9WPSm4a5HJdqenfd8UyqfnazmxCzZHVsLZX2JeczvbDsAlUZlR4xYD0b/GpqymH4TZUubA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcg_sock() baselines memory.current and then requires the
growth of memory.current to match the absolute value of the "sock"
counter.  That relies on "sock" being zero at the baseline: with an
idle listener it used to be, because socket memory was only charged
for in-flight buffers.

With upfront budget charging, a listening socket is charged its full
buffer budget as soon as it exists, so "sock" is non-zero at the
baseline and the absolute comparison breaks.  Baseline the "sock"
counter as well and compare the growth of both counters; this is valid
under both the old and the new accounting model.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 .../testing/selftests/cgroup/test_memcontrol.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 3a84d068fbf3..54dae37291c3 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1335,9 +1335,12 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	char servport[6];
 	int retries = 0x10; /* nice round number */
 	int sk, ret;
-	long allocated;
+	long allocated, sock_pre;
 
 	allocated = cg_read_long(cgroup, "memory.current");
+	sock_pre = cg_read_key_long(cgroup, "memory.stat", "sock ");
+	if (sock_pre < 0)
+		return KSFT_FAIL;
 	snprintf(servport, sizeof(servport), "%hd", port);
 	ret = getaddrinfo(server, servport, NULL, &ai);
 	if (ret)
@@ -1365,8 +1368,12 @@ static int tcp_client(const char *cgroup, unsigned short port)
 		if (current < 0 || sock < 0)
 			goto close_sk;
 
-		/* exclude the memory not related to socket connection */
-		if (values_close(current - allocated, sock, 10)) {
+		/* exclude the memory not related to socket connection;
+		 * compare the growth of both counters since the baseline,
+		 * as the listening socket may already hold socket memory
+		 * (e.g. its pre-charged memory budget) at the baseline.
+		 */
+		if (values_close(current - allocated, sock - sock_pre, 10)) {
 			ret = KSFT_PASS;
 			break;
 		}
@@ -1384,8 +1391,9 @@ static int tcp_client(const char *cgroup, unsigned short port)
  * The test forks a TCP server listens on a random port between 1000
  * and 61000. Once it gets a client connection, it starts writing to
  * its socket.
- * The TCP client interleaves reads from the socket with check whether
- * memory.current and memory.stat.sock are similar.
+ * The TCP client interleaves reads from the socket with checking whether
+ * the growth of memory.current and memory.stat.sock since the baseline
+ * are similar.
  */
 static int test_memcg_sock(const char *root)
 {
-- 
2.18.0.huawei.25


