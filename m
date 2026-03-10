Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADC1EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7A16B00B6; Tue, 10 Mar 2026 10:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991C06B00B7; Tue, 10 Mar 2026 10:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEEE6B00BA; Tue, 10 Mar 2026 10:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9BC6B00B6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:40:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 332E81399B1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:40:38 +0000 (UTC)
X-FDA: 84530414556.15.AB15A9F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 683C6C0012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:40:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DDgFIsR0;
	spf=pass (imf28.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773153636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=H2KXlUhYjyvsk/adOesgn1eiMUOMZJsVsfNB2OlVCtA=;
	b=ds5/J+hMqvNv2ilPO8FLpa2voIQdKDC3s1scTyb/F/kw+gy9itM3/XJcyQcVt6fYIVK8yH
	bB8ciw2IReC/f2ufF/vRWC8Ddd4dlzcI3THuKx+aCi4o4duP2DqLTwQND6aS/a5/vyxz1V
	2flUaaId1LzVQmBidIkcij18zujxdy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773153636; a=rsa-sha256;
	cv=none;
	b=amJdVcNTAgjgZj/J8UjMZEf9OJaLARUs+pdrs9uNQPCPMb3jPfUBcCeSoaW/dNDIfNLsAJ
	YvHqQn80wyRXMaK3MjGXyfzHwH1hCfCzQ4iLFkZq+enxrmcrYbhRyswtRup7hwjy4nkqmv
	aDTb1Q0fhnxc/4Jyu78nd7gQN8xApL8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DDgFIsR0;
	spf=pass (imf28.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773153635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=H2KXlUhYjyvsk/adOesgn1eiMUOMZJsVsfNB2OlVCtA=;
	b=DDgFIsR0eKpsNa70/lf7KmgAneRDCEWFu+qQUUwNYSMdrKGjTWSjQFCdJ4hGlwD8Jo3e19
	fqYyw7mqVw9vp9dKMOB9g+9WToVxjsMALVghyvrmjmNIi/QJNamuBZYOAW7bPwioM2qQxB
	49cbUl3bYO9kQvmTL1sf8Sj5/sXllL0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-tdmInL87MA-qqhnECWWfXA-1; Tue,
 10 Mar 2026 10:40:32 -0400
X-MC-Unique: tdmInL87MA-qqhnECWWfXA-1
X-Mimecast-MFC-AGG-ID: tdmInL87MA-qqhnECWWfXA_1773153630
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55B31186A475;
	Tue, 10 Mar 2026 14:39:50 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.89.94])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9457E1800759;
	Tue, 10 Mar 2026 14:39:47 +0000 (UTC)
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
Subject: [PATCH v2] selftest: memcg: Skp memcg_sock test if address family not supported
Date: Tue, 10 Mar 2026 10:39:35 -0400
Message-ID: <20260310143936.720592-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: m7vHXTTBq-hKU3yTcSLzqYukW62_y1UJ1qe7PTRbmV0_1773153630
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 683C6C0012
X-Stat-Signature: dnut19w1de8ncgzpg5rptu13u5jpz55d
X-Rspam-User: 
X-HE-Tag: 1773153636-380413
X-HE-Meta: U2FsdGVkX19WV4PgJngopMiZArrL19LkaVxOMOxmxv5GyXz2YPpoRVfdTRt5Z8HcBHjkYFGDUlWq1G1RwzB/+pcVP8+CB1j/5MRGjv3XqLEZd1ZT4GRvQkz+NslHV5jKs82vJFzO12mtalDvMWgprqJOFgjSSVQkxDE1FbXhtvkaFM4p0SUi06ClwsuYOHdv38Z3peuXWLxnuM06VgDip64ain58Ca8j0/WxSPSCieE22MnR54ASDjsNeDM7UmNNChz60akef6UVkALw3XUNuV8WGNB+xjTtmRin2c3g4Y4nDti09T5W7ufSUZfPR8ZI/fahdXi8SyUL6dZk8IhN9kfyuva8kbxbscuV248hu2/RhCehaAlUb95ivAuNm/eRREbKom5O9EGKDL8cGEc2D02xoN2cytG3O6nK7nl972liccguG366LWc+8y/0YTDgzYnoqhIfJXt/PW0li7gnKcns8QtyZScvHFfpUhivKE4bKieumOjO9hWZMGlg5P285LGz1MsPE9CyaXT2Aouv359ysrTbynLrHLCZZ7Vglo6glN++p27xLCKv2dly5Y9IGFn5ebyvvbVpOJ+gip/dIEF/Ps7UA7WQErLX8haibtmlAqaw1zCCzdzGPh09AbOsEUstJ6sP5MkQdxcPvxP5em0pBXGbsNueqbJ92NDfoUbhuPKL330cSV0uH8A+huzN/YHArIlRx30SNS6HWerV9NoHo8P70ImeK1My+3oy4KcugZDv2BfcDXATZgaPi8/3pP1GUWwJWTpwJley4YkKNL2fwlMAvmSzccyB30uwoJsYh2sDt2yp0edYfgOGsFC5/WMfBUH+UVpydq6mznrn6EZIxZnTuo0jzyy86ZOsUM4c7J5ZAiQckAZlOgJbtfHduzS7sqy2Hl7fvcdzQNOX6I9ePWg1P3ApdYHTrkypmoI6pD/idIvpSjTA514Bo2fP05bNyWQ+kBszh4qNWf0
 oRU79gx1
 UZWzij7756L88zR1EbhNEJVujjavt/pYMk9ZVwDMwQP6HK2WFRF9Ivt6wBD36pcEDIiuC
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
Signed-off-by: Waiman Long <longman@redhat.com>

[v2] Update and commit log & adjust the skip code as suggested by Michael.

---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

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


