Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615AECA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D666B009B; Mon, 12 Oct 2026 14:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225E36B009D; Mon, 12 Oct 2026 14:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEDF6B009E; Mon, 12 Oct 2026 14:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF5016B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:59:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68FB340C9B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:59:31 +0000 (UTC)
X-FDA: 85314887742.22.E59F034
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD0B840007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:59:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=wuqJNlLp;
	spf=pass (imf07.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xABwQzsz7Q7HeYTm3a7cqXm8Re+2/3UYBe4Ql6Rc5uk=;
	b=YKDpFaQZdcM7dkBCL3M1YnAfuAcWx5zRc20Wrt2zC7phgUV3j6U+OQmsh3GXS+6VoQWUEG
	qF89gp8iJo67XAiypOnvcXca22x79GWHwIFZWWb7ovEBEj5Y6Xo8jMGnRixDWc8q4kHUc7
	sP92re1/+XAn4jX6yg4NAl9dkQeZiXs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=wuqJNlLp;
	spf=pass (imf07.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831569;
	b=mSryphQGbXOxlfep5hUx+8YrABuVx8z2cSMyPsAqA3BJIMzSpePjvzxOVBoy4qoNqJYZyM
	AmJlMpnB//CCpvqRuh+u2hTZQ4ANuTf/bghFeoh8lBRJKjcH0QpVzpHu11NObBp2zicLvD
	+NfmxjWwumLpPCskJsd6Wp18fRxjSIQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=xABwQzsz7Q7HeYTm3a7cqXm8Re+2/3UYBe4Ql6Rc5uk=; b=wuqJNlLpTPZXGeWPY6z
	RbmO3Xtnk2lTELwJlu8MCShhrdKvYkJq9irIolxAXzPM0naiCrGW3pH8qr54ncd++swVD7hXNWoBz
	hEHnkbdPAi07FA+8ZpDtydwtxFnao/WsBWoiLs4IHVuOuHdo3j7Xm7F4djjbG1tfSYF1pZRSsaYrT
	dln7qcJPBYYpbug69GSuHVpv77hDNNZ9mQLBoPf760E6Ylp9MwUMAoigjb6FWXzJ1vD2Y2qbKAEX/
	iS1grzdQGFbdPn8o+YaOQQOkUoTW4fQ+Hww32qQYInENDATweU+fW25vXJ/qhhhfRXBtvUkKykUC6
	RhrN1IfJ3FordbA==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLBb-007pPW-0K;
	Mon, 12 Oct 2026 20:59:08 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 12 Oct 2026 20:59:05 +0200
Subject: [PATCH 1/2] selftests: cgroup: skip test_memcg_sock under
 cgroup.memory=nosocket
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-1-bc864b1950ad@virtuozzo.com>
References: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
In-Reply-To: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
To: Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=NDcnXEQvkxTSDc7OEmOpPUIL28bEAcCqKO16/nQ9nHY=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS4Dq31RlSyeRnJrQb5BqdajPr4aqA1nSsHEP
 tO3tnluCEyJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uAwAKCRBRlgpH+WFc
 Kq9zD/9hCfrn+3/QeRccmHR5iUlw8bwPXqJF0/A/r0TWCtxaq6wsiclWoWkfYmVqaCiIBssMXn/
 wQYqt8NQcCMiGopXo+1sT6yiEjE1QY+WVSkAFi2SooA0ums9KcN/RqvH4Y3ei6FnGy51pL1tPXR
 QhUqk5B9HEOpLdj05cjU2unGkTS0+a9eZKwBG9J3BMENdXmtxzB6PVe77COpbQFbFrEQ1XOZKC2
 KL0Cr2fE7lsDn5oeDCNQcklnquShVlaUbQ65GauytxgDrVfdbaz3noDy2vntGrDOBlkr+pI2E6o
 FVgoOObbPMejOgXEXmUzM4rh7E7AxACvZYse8kAG46RLp0+fdk5PHiXMdOhannqA1w1wIQGFn6N
 XBiUciNPno2Kyhz6EZaUxbXCsLTHIJsZKbBc3p05k2eQrC4W9zWNgh0F4Ip8M5gFvU+TfGNZZ0P
 GQUMVIAXFg9wYJuoXEYqtc6Wgf21WO4Aq3wC9A1C8kgVkM/ompDWh4IYVIPY8uftRi1rS+7zkWl
 FBcI/fbSNktog4X2gc7jWOGPyyHANwD7cDXIJSaEtlrSpsuWHTJHnPMFcpQZ7d4t4ElMEpIQ4h7
 ewNE2mTnItIMoukD/Lg89R7/x9Fp05p5AWHvh8lekHFg6xx5FK0WBp+fwesnCxWBFdRAQKwCug9
 Wl4TFPQ6oDmWBTg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD0B840007
X-Rspam-User: 
X-Stat-Signature: nnbzi53ojhqhiu45a3z4tnzddkgj3ath
X-HE-Tag: 1791831569-409832
X-HE-Meta: U2FsdGVkX19UIU5WlnMOkqInjRX5SDqEbdFoNVJZctuTXqHcZ45UXzpQVZ5Vd7fjJbt6TNGNaCaQSAyP9KiPZyuWg/UUF58zgTdWovZdJHrIjn0yuVEPZlUCwlmnD+vbe8HugJloclHJQtmiF9XXXQjRWaqeYzYnfoM/djuLbw+FiKqt5VpGntSVwI/BTMs9JIEB5ltjyOJLzUX2Btthoxd9J1Piiw5e5/vBxOgahb4AAq+83UcIciYXUCGUZwFhrv/S+gg0dAShunjxxt9c6+Qm5l0nK5hsZt66bM6Ue4RirqyveK+urTFPyjXrXCv46QwknXjW/Ztd4jdJdv02RnS8ogBB6X1NUTOpv4bLCX+xPKu0s+cfmAsn01xWhpdGKseHlDzLEJ7GHlDfbM1c29e9puEvu3kR9NNoKARSU97/lcoxSfcZj8laaBZpvEunzr2Ixel+vASmYB1B39ybKu/b77iSkzr8TEz5BTbzSkZzm1IYcRUiXNB4vV9wcUwL735gleRWUzccHcM5Fi4XJuSc+EBSNuBhOxOqPk1mQfMs/hj+pFKRR6LnfW03cbcyzn1BiCsHniUntq98X7GrAZMjLRhaaaX57a0v9mmE/5q0sk0ecluBwDjJ+k0LqLkbYJL48LvJoQXuTK3JNm4HrAxB5wYTi9aLWeubGRk9p6Zl+hz7o99KlKWEHmtjmeA6fah+QTDz8FHW2qEn0+RxdaeZZmd69/dESDBo4NvbV2+nCiFkf3OCFuhWGdoUaOUusyov2cbdtJFjhP15zYc1A0lJc+6j/faptAApFuhEU2lNu9iSomdSLTiy6NKZduD07FHcd56ZCytVcuvyLRRwJ4KpAMLvmQXizbAT4HgtkzpjUi97iEaEiO6Tl0DVwRdBbNkMI0plPkUuhz/2oQQXdHiZtnwO6Ynz3PnpPeLIvLMBlHs5zvSiYStWvWoCDyt304izF2NKevb5rFJ+qU2
 2f1LLADl
 j/KSB1tQrArcBgsgs1qWf3iJOjV/00f+Cwx5ybt0fMWpcq0s8o73nmJb9+L6Zu9XCWh2ftk5Y0DxVcj2RhZo3B/wW1+pQVJkqhOf0Wdw2/oT2QXyxAf0o46PTa9vw/kDCoR2f7/QQYvntnJzC8w3obnpsNU+OWc2i2LEE06bKpUot5jDqDmApHM/G7PZGr8Y4utG7rcJxHzzR/zrQE1sgaYq+4rE0lc3miHwlxZ9SKNw5s67KheH7WTTsvaO7kukbhxut5GIOSW6FmCqzP4lBJdmrbCFXyY0wLzhT6/NWGEOAZuMEdHt2lmRfpkZ5I7clHDjA9hQfQ6VMeUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With cgroup.memory=nosocket the memory controller does not charge
socket memory, so the "sock " entry of memory.stat stays 0 and
memory.current moves only by the kernel objects accept() allocates.
tcp_client() then passes on 0 == 0 without having checked any
accounting, or fails if those objects took a fresh charge batch.

Look for nosocket among the cgroup.memory= options on the kernel command
line and skip the test there.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044ed..a24c1e07b2035 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1379,6 +1379,24 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	return ret;
 }
 
+static bool memcg_sockets_disabled(void)
+{
+	char buf[4 * BUF_SIZE], *opt;
+
+	if (read_text("/proc/cmdline", buf, sizeof(buf)) <= 0)
+		return false;
+
+	for (opt = strstr(buf, "cgroup.memory="); opt;
+	     opt = strstr(opt + 1, "cgroup.memory=")) {
+		char *end = strchrnul(opt, ' ');
+		char *ns = strstr(opt, "nosocket");
+
+		if (ns && ns < end)
+			return true;
+	}
+	return false;
+}
+
 /*
  * This test checks socket memory accounting.
  * The test forks a TCP server listens on a random port between 1000
@@ -1394,6 +1412,9 @@ static int test_memcg_sock(const char *root)
 	char *memcg;
 	long sock_post = -1;
 
+	if (memcg_sockets_disabled())
+		return KSFT_SKIP;
+
 	memcg = cg_name(root, "memcg_test");
 	if (!memcg)
 		goto cleanup;

-- 
2.43.0


