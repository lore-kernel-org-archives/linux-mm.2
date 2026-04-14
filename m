Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26202F531ED
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2666B0088; Tue, 14 Apr 2026 07:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9F76B0095; Tue, 14 Apr 2026 07:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6F06B0096; Tue, 14 Apr 2026 07:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0AE6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:06:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AEB1E3983
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:06:44 +0000 (UTC)
X-FDA: 84656883528.20.14F6FEF
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 722D2180015
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:06:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VW8Jbnkt;
	spf=pass (imf06.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg2tnVpaCRON/cP+7gSdWa+iWUUmwfSiFQT93SEuIFU=;
	b=wbj95ml9JJ+ZQT6zZBMfODx1XqKCrtWuhAlKOiaiWRut25gbCiMoBr4YqoC5LbSAMf9t5J
	bnQrCs3icJT5rE+ZAVWKevhEAFMsK3Ny0waWOj6EsmEF5Rg2tO2rjOzXhTENAJSbmRjFiq
	ST0NMj0fzFaT4CpNGVK2yz3AS/gwtUQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VW8Jbnkt;
	spf=pass (imf06.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164802; a=rsa-sha256;
	cv=none;
	b=OPPud3nViXPxrqe+T7nXVmOuny18SGDd0RixIwfTseRS012iNRyN7VPaVZB115vj41W2TK
	3TRf7Efwnkh5Nfen23aQXZDRiusSdHa9LrfnVw48OjQw60QJmicW7gNbVzU+qt4EzkZ+1j
	yJSKMxjhN+6b22LUxZWPxAUQE3HUm8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Sg
	2tnVpaCRON/cP+7gSdWa+iWUUmwfSiFQT93SEuIFU=; b=VW8JbnktrCN31hXN/m
	ZRxuZMCswnlDTlAW8P2XreK8Dw/m569blPObWwb51TYYrfmmSxRl1yIQuM2bPZ3a
	qqDK4QWbFCDvGELskajRHbhSeKOh9AYb6rzAfbJawxfA1WU83m7WFJlqVPhID6It
	8OB3JNh436NC2mM/ZpMDjAbUo=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBnrLh2H95pqLbvEg--.46126S4;
	Tue, 14 Apr 2026 19:05:32 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	kuba@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 2/2] kselftests: cgroup: account for slab memory in test_percpu_basic
Date: Tue, 14 Apr 2026 11:05:24 +0000
Message-ID: <20260414110524.2414-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414110524.2414-1-ranxiaokai627@163.com>
References: <20260414110524.2414-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnrLh2H95pqLbvEg--.46126S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw4fGr17GF45WrWfCF18Grg_yoW8WF1xpF
	ykG34qya10gFnxCa10kr4kXrWrW3s5Za18Gw1DAw1xAwsxtr9rtr1SyFWUJr97CFZ2vr1Y
	v34ag3sxu3WUA3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR8OzxUUUUU=
X-Originating-IP: [2409:8a62:14:edb0:5054:ff:fe85:ffcf]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhz4RWneH3yBlgAA3k
X-Rspamd-Queue-Id: 722D2180015
X-Stat-Signature: k1jgde653sdah6owns6z81jfcekxopp5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776164801-856278
X-HE-Meta: U2FsdGVkX1+vd2EGQfLbJoUDwVje0uud4xwBW49R73jleo/6bVdeV9wb8b3DQe0Vlgms8QMN8GsU+FlEQk5L7WBG6CrRBlhlSbykgpT5vwlpCaHaR/aqOhm2EqJFPL7SnR710eG0fHsS5jEXqxonool3aM7KsucXlCPVIkyo2m3oruF23V+43Yio+wCgKVDcnjXhA0TJsKyZDf6u7GNy46MnImBI5mAeCMjc4R8odkJzw0xfA/0+ocLHN7KZGR/y1vio86QB55Bhw4QJHpGyZkqaiVczQpGnbdT9HU1CAFTOI/woQcI+1lwDogJsLhDlQt+X90FUOGQ9SVS9E8f+E2XkZ60UvofQnk7w0QQ7vKE4946AQ+7w6OFk24aiDrlRCABmSx49/0VHWgcEg3rbVV8bAYzCDXNLtypz/LslLIZmZSxXGhvGQxIKFkDCzV14wNlG5o85vAd4BSRkzVuyY2aXwuHI3yLyhNHSJ5vu1TexBofQVnD2EfOjGfxWNsT2PkKyWFzlbrdo58eRzFLhxFgVI0r2bTavFwyS4QVKTSgiqOzFuBWusM9O9e/I8CKYJWmdn6Y7CCFEzxZt5j3+3cwW0BAT86UBa21CogTNZiRZhQ/pcM1/kv57WqG3cBEvaPQLvKFdtFkiRjxgUaqqwF6HM8qRT3CsUrlkFi3xp3CH+i7UFoBpe1i7mcfG2dAC/urSadMAdtHOuc7ggHG+u6lOquo+eDJhed6nN/PA2jJDaxrgeWObMXdPtjvGsWJAzelIhBwRfQScoEsFGcfrC/snNqolXuraQ/BnmthiTcdKW8y+qNWumkQlObtVti0ZUFx55xDN8amHkaGneL2uGZn8S7Jcuv6AzQ9UPhnXvhPByH1Ir2A8EASqoJ5wKhoOw4alztcdLnEhXLuDVUpnrgGDWAnKrNwTmeAh7w5LxYsih8MHAxTMqlYvX6ZnZmbfN1nXJeEHQutlJjpkDEB
 eYMr22G/
 ja/ehqt+7QPJmwRdC/cxuyFOTmT18byw0JhreO/LSCcytUpqYpZ+iKgTJ3wPlauC5Gz9qjAJ1rRx6bQrRhcBq88getQDv7MZHNEVb3JmXMLoKZ8yBzjpj+NpqOna5+euVUbsNM/+mhd8yB1d3czQnYwIx4TrLQPXOgqZ0Rr+uZDpqH+F2qSb7fzLNmMGv6XLgBELdIjkhwL9hFs/ch9kWIYKMYH9398ekKOIfw0GH3stHuLfDMb8b9cil3ywsLlsC9pg8c75leAnqSlooj4NHA6eJY/vzXA6/DARmmhjxhPg1knRWR2n6NeI1hSIio3KnKYND+o26/p/7LgcaIQbsHBKXVQroxlUcFGMuzCQs6XtWZLPF4wrd5GQfYjcDXNXzqkDwYEHzKCOWAk8xxbYJzK+7H0TpTOGLlxoKvAoCh0eBa+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

The test verifies memory.current approximates memory.stat.percpu within
a tolerance. However, memory.current includes slab overhead. On systems
with few CPUs(<= 4), slab consumption exceeds percpu usage. While percpu
usage grows linearly and dominates as CPU count increases, the
significant slab portion on such few CPU systems causes the difference
to exceed MAX_VMSTAT_ERROR, leading to false test failures.

Fix this by including slab memory in the calculation.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 15b8bb424cb5..263aedb0727a 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -360,7 +360,7 @@ static int test_percpu_basic(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *parent, *child;
-	long current, percpu;
+	long current, percpu, slab;
 	int i;
 
 	parent = cg_name(root, "percpu_basic_test");
@@ -386,8 +386,9 @@ static int test_percpu_basic(const char *root)
 
 	current = cg_read_long(parent, "memory.current");
 	percpu = cg_read_key_long(parent, "memory.stat", "percpu ");
+	slab = cg_read_key_long(parent, "memory.stat", "slab ");
 
-	if (current > 0 && percpu > 0 && labs(current - percpu) <
+	if (current > 0 && percpu > 0 && labs(current - percpu - slab) <
 	    MAX_VMSTAT_ERROR)
 		ret = KSFT_PASS;
 	else
-- 
2.25.1



