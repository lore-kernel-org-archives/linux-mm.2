Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0795A1125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0217F6B00A3; Wed, 11 Mar 2026 16:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B906B00A4; Wed, 11 Mar 2026 16:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72886B00A7; Wed, 11 Mar 2026 16:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D70376B00A3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:05:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 884A4C1ABD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:05:49 +0000 (UTC)
X-FDA: 84534862818.29.94E07A2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 950BE2000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:05:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZejbzGCR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XAhyUCPdN0YxPo/49Qsd/d35pyJg70HQ5AoWjWJKM4M=;
	b=AS8GksLKER1As45HmLzRn/rkfVl/hTS1pB99uExoNvxFfZt54qkty57lCpXlYrpein0Fpj
	S1wU+e4+EDZHOboozem8aGMJIdYRCFuE8ExsrynV3b5z2WfJ87Lj3ETOx8hbkIWPdMPPpJ
	uiYyeNKbyW4Xu1pyxvQo++3adEWtZq8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZejbzGCR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773259547; a=rsa-sha256;
	cv=none;
	b=a0NDLxgv2WmvOjvCteqSnCF7u8C8tT+sGeIlhrAlT5yvN4Cj49NG52GEVWyblE8uRkmAzv
	hgJ9ybiCnLv4cb5k9Dgz9VidSK8EkuOXTQv0wAYI5mHofQSq3LNRmTIZnvbKASPAjSnf+s
	9NJYdpERJVlaNcB9SpF/iRks8jra65I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773259547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XAhyUCPdN0YxPo/49Qsd/d35pyJg70HQ5AoWjWJKM4M=;
	b=ZejbzGCRb9uGWr+k5O3YMnd6cbaxisD6wmW5R3JngTCPRPjd2WHkQqUolGwlKWBy+OliIc
	oU8ufq0lHEREXOrsjRAogmRuLByEB7mWEVOM+/7Fj/u5yYlVL+5M53Qk+ZtTfTvwiGG51U
	XNvdNC73fddJ2YqJ3U+7msIAimnx1DI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192-mfchlU81My2mdCgh7zI6mA-1; Wed,
 11 Mar 2026 16:05:43 -0400
X-MC-Unique: mfchlU81My2mdCgh7zI6mA-1
X-Mimecast-MFC-AGG-ID: mfchlU81My2mdCgh7zI6mA_1773259539
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 019E218005B8;
	Wed, 11 Mar 2026 20:05:39 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.90.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A497330002D2;
	Wed, 11 Mar 2026 20:05:35 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v3] selftest: memcg: Skip memcg_sock test if address family not supported
Date: Wed, 11 Mar 2026 16:05:26 -0400
Message-ID: <20260311200526.885899-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Wc8pwiUZGn6MVl55smVImzpAOPhPsNTab2cB-Uv3SKk_1773259539
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 950BE2000E
X-Stat-Signature: pa96asm6sjqzkgerwjpe1sqdr7b9x7fp
X-Rspam-User: 
X-HE-Tag: 1773259547-864797
X-HE-Meta: U2FsdGVkX1+05SCnXx8QYwOSstkHENFdWJxrhWRKsF4unWXvFFxRE/N7+Q8EqM2mpm6LhvHZueEwu6ksQYVqReT/qwRbJyjBVeCrj0nkl1mVDwZR1cvP/sBaaF7FpIw9zEhPPTN6kooT4tLReGLZxluTDufGobGiyOeAmrk5P0A/nDjhSThYx/gXnoGOZCKy7fhfz5RZNhyTB3bUjDjfKJ+9hxAK7xlFW+nHiWU3KHN82ofX6gE3o7e07u6ybH63/5yCCABGi2xr6s+nyP5C41akswkBIxcbMO+KVTWknmbIGoAXtuvw0pofr0mZqeuBFo+mzHLg2xymACvDyTYu0ikEb3UmpS7BRp3LLpodoWTS41W6nMW+VynURY8bO+oocsxMwzWko2cIbxnPWHptFUuzOKOv6xF+uCeDwphQM/On/fEX8lreZKCqGRFPfw7npzLmkn8SBBQJ62Ts+s72hGBxTj0cBKvOec7G/S+W/AcKqv4Rdo0GjJo5NbpHTHeSPJ8dCX+naHwMEPlU6K5xSDsofznU/PM93vaRhUrehnSV1zFSWwyOn//uJVH2dJ+sS6v50f8VCdQVas8qVIU3V2WzOa+MDLNpMjGcCQvgvyXU/YRnlsMajf4Qi35+x9ec8n93xe4SxYqRZC7EJPD8UYhfVaE3DIb1eufkVQ00EMJgw7COpD62RKKv3LixZxyP4g/9gHgJLIuvoyGGlAJRJ4eA4ncNaKwzZDUNPRzMk6u/lL5Z0h2vvFGNDUKpcDoUiKcIhMm1y54151W97Gj+X+msvTlpNygsgmiJj/dzlw36+3OaMVN9D0w7ZpbfmtARvvvT7R7iqNPwMg1fVnfs9/inXZwN0LaZtwJBW2WYHadxZ7azfIHPGFTcr/n0szAFNkb2MZ9/nzA9oqdrmzbjt+67vuPfSib/lsaKG/wMKC+pQX5Pvx46G81m9zOS0m9qx0AGcWKlCbr3Fq0vTaG
 /dWZCA/v
 OV3UgIqLihPVSO3CwpByJSQqhdIYx4v99JQPg8JiVboi1Vam3gG1/e4jefSd+mkOpZWFLFTIDq6Ht1Rv83YWeE8Oa4ok1PMZUAuzoDyYTG9g6DQ5aq17OihI6uOWrPTWukx8HRhqObuXw62CNl8nQwFjxeEh5WRdzy/g/xutIvsvXAKNDvU0fzrYMVrI3vPR5uh8LzXCyNUJZPq5yq2mPdgR/UHOzmPgzUbvjfRGxFMf1Nuu2L697K7w37UM4JmRtIzvZQ9PkKcL/fAAVfhDTUsc2XEGYzD9LUx3op7wZCgfJK0jhjFsM5SQPg8e+cSl5lnD0+TDXtKQGgjqijaLFCEutsm298DyGmBu3hy21LIymqXbpx36wgRbT6qeta0WaESWU0MB6qYQEqMOxWEq8JMRfXCipGfg6NJAo40LsG6vLJ6ZeKBDQXcfHXbF8kU0okZ46wkMVUfu+vNusa0J42g7pDRo23RphzHJ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test_memcg_sock test in memcontrol.c sets up an IPv6 socket and
send data over it to consume memory and verify that memory.stat.sock
and memory.current values are close.

On systems where IPv6 isn't enabled or not configured to support
SOCK_STREAM, the test_memcg_sock test always fails.  When the socket()
call fails, there is no way we can test the memory consumption and
verify the above claim. I believe it is better to just skip the test
in this case instead of reporting a test failure hinting that there
may be something wrong with the memcg code.

Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for socket accounting")
Acked-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

 [v3] Add tags and fix typo in subject line

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 2fb096a2a9f9..a25eb097b31c 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1280,8 +1280,11 @@ static int tcp_server(const char *cgroup, void *arg)
 	saddr.sin6_port = htons(srv_args->port);
 
 	sk = socket(AF_INET6, SOCK_STREAM, 0);
-	if (sk < 0)
+	if (sk < 0) {
+		/* Pass back errno to the ctl_fd */
+		write(ctl_fd, &errno, sizeof(errno));
 		return ret;
+	}
 
 	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0)
 		goto cleanup;
@@ -1412,6 +1415,12 @@ static int test_memcg_sock(const char *root)
 			goto cleanup;
 		close(args.ctl[0]);
 
+		/* Skip if address family not supported by protocol */
+		if (err == EAFNOSUPPORT) {
+			ret = KSFT_SKIP;
+			goto cleanup;
+		}
+
 		if (!err)
 			break;
 		if (err != EADDRINUSE)
-- 
2.53.0


