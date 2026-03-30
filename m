Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FACFC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6124E6B009B; Mon, 30 Mar 2026 11:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA046B009D; Mon, 30 Mar 2026 11:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500226B009E; Mon, 30 Mar 2026 11:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7266B009B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:16:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB4B61B8C44
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:01 +0000 (UTC)
X-FDA: 84603079722.10.23001CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id F027D1C0015
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ebxAwGU5;
	spf=pass (imf20.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ebxAwGU5;
	spf=pass (imf20.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883760; a=rsa-sha256;
	cv=none;
	b=lMavcAAh8Wrb3ajC9J9XjaBGx4fraTjO1y/p5mfqGF9pSQdteS771j74PJejmiThUZEuNn
	rjGnxqy6Rw6q/oC4O1U5j7g9A9q8K98epxxs5NGT9Qb0abhoZGkAdMZrpYPMOsrXqL4Duk
	YhCNlD1eQiS+byZtQb14ePrp5P6e9Qs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ie9j02dRCYKPPj+cFCU+BtD494a7hZlu7MrIBbhAVwo=;
	b=TsDAVPiW3IrYCK1TpOdI3vysy7BEigzKZMrKl/2YBaAPXWaT6u3HjRlVtcXLtCBSuBeQNb
	4JwZsvuibBTYJcUN9N6aDrhHTczUe+akzDiZr/WmGINiRZi1CBg32a/3OsmS6J47fVwd/B
	bxSWoiMjJPG9/IA1Ai6Up3jo3cBPeCw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ie9j02dRCYKPPj+cFCU+BtD494a7hZlu7MrIBbhAVwo=;
	b=ebxAwGU5YenEcIwdYT8hxgXGixqYJV3eT6yd3JqlBrMUW++o/P26WukaVrPTpXXc2jpPI7
	gH2IAA2sf5RJGALrA1U89Ypqnx2fZrIp7C7ks7TqkcvZMY2z1yfI/PEwpLb8Qtwsj6mTJF
	Hv32mPM3V+hGsg7iBcFBTiJavxuMSao=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-Plyn5C7LNeaQvCTlucDj4Q-1; Mon,
 30 Mar 2026 11:15:54 -0400
X-MC-Unique: Plyn5C7LNeaQvCTlucDj4Q-1
X-Mimecast-MFC-AGG-ID: Plyn5C7LNeaQvCTlucDj4Q_1774883752
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E13B318002E9;
	Mon, 30 Mar 2026 15:15:51 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E440719560AB;
	Mon, 30 Mar 2026 15:15:43 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf style arguments
Date: Mon, 30 Mar 2026 23:15:00 +0800
Message-ID: <20260330151503.670415-5-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: AgyYv5zO3-WjLRFQUp56GzRXzczo0cL10AlM_06U1kk_1774883752
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F027D1C0015
X-Stat-Signature: morhgjynur36k5ytbf4sp543tufnz3yo
X-Rspam-User: 
X-HE-Tag: 1774883759-890798
X-HE-Meta: U2FsdGVkX1+vW9FockGk18QI5iZyaTJp8T2zp47NgoN4iSq4PpWCL88PnbNMtSbWoRO6bJG2fWgXY3JGUgygN/YFHuzCj5ZM2jQ2ilcRaGd/B8Tm9FcVwizIZjIo8V0VrUZddZHeoSxKzG9L3Lji15q3bc1d6TyUl+QuPeBYHlKIKsKvFrkPzqgqim+CP3lnz85WtcFUEZmvI9iLVdbIkhRhXXes0mRGx+aCy5f93b8hhgYV7441uJoehOntJ9rhJZoCkgkB5zlP6hlIw3nng5hra3X/rtgDcS1iQQiXT/8aHz9iAB/XgleXW25a1pBtXjcP7TVZh8phnwxZEvvtYZregCTibN2yYB69xKzVbPwdzhQO7ZxdR/h9nbkiqR15KrI07LP9uRUKRa2vOJQI/hRrIex7fHo9aPHk7tjSKH2gKWWNynwvCqHsUfLOPwoFsWN2WQRCoPXiQFKLTsMPDvOVj5T4LfNgGNSGjpyFWZ3KcuAbhGcrpLnsntEZA0T2iGZNxmP1Sd9/X34uaoFMNczoS9Uv8F+wy23vdCKUtaGec0BOrC/SQ+moEVOtr2bxJxk6asc3bj9Sep9OfR+0tMLXwPPY2Y4FRLM8g0RCQOQzcgQqK3llU6WyF5VVeF/0Xbg6opJdlgLTfw1dHn5Zu9D8BbxIFN6NCDwpqkHHQr01hzPdErsDd5xyrk4uuzy+2qztV02UG4QbwHMZS/hIRQkB2YouW7QDWZb7QVKEaKDj2b6JFetvEmyGHmdgWBMP6dofekToxhA1ttpAe4yB/guLYr91YgS+WEmP5p1Unzmkju8yDlwfpAzqW95tvRlJlNP71V29SfdrIiDjYh6MRxEJ+pdYOJ563tpxjCzYBV3QCTPJBs6TVz5PhX8LJKL5f9d07mMkfsMwE31yb0BbfD7UoZMx0joJRyd7Sl/YndX/+vIhgnw6JGGzGeirfIn01iRrOy5KtHf248sIjCp
 y+mD4r4/
 Hggm105XLXUUsYXjR2ckzAZ9co/8wR5XUJNMu/AUS1Og4jmRkXyPH/hAto7bKG8MEazNKUSohm4901mOAetAwv614/CakOXdBHTHBmOTI+QaFbUQn4G5p3irO4nKm4ivMWqyS1dY1qb72cyQNhQ1Mr/c6rShNpkii3n2JbBkWM6o6zshqmE4TtI4tae9BSft2k/5QOKH1OHQOIRFHcitHzJ3q8sHhiEEPPPfONAyGAZ5Bh9ibSwWnk0UCPbOXs35Z0Ur24CKhht3SgeClv6ax4LaysbuTQGYfWXFiIi0xA8oJZVej9fAjsGt6/O5ODVLojq48o4pyKHw1XQ4AulY9aEfwAgnPQKWmE8nd/bbVK2ZLI0NJidsAZTyBeaNHJMIvm/jua5hAuiBK3tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ksft_exit_fail_perror function previously only accepted a single string
argument, which limited its flexibility for providing specific context to
failure messages.

This change updates ksft_exit_fail_perror to support variable arguments,
similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enables
compile-time checking for format string correctness.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v7:
  - new patch to convert ksft_exit_fail_perror support variable arguments
---
 tools/testing/selftests/kselftest.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index afbcf8412ae5..11cabdabb3f6 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -43,7 +43,7 @@
  * the program is aborting before finishing all tests):
  *
  *    ksft_exit_fail_msg(fmt, ...);
- *    ksft_exit_fail_perror(msg);
+ *    ksft_exit_fail_perror(fmt, ...);
  *
  */
 #ifndef __KSELFTEST_H
@@ -417,9 +417,24 @@ static inline __noreturn __printf(1, 2) void ksft_exit_fail_msg(const char *msg,
 	exit(KSFT_FAIL);
 }
 
-static inline __noreturn void ksft_exit_fail_perror(const char *msg)
+static inline __noreturn __printf(1, 2) void ksft_exit_fail_perror(const char *msg, ...)
 {
-	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
+	va_list args;
+	char *buf = NULL;
+	int saved_errno = errno;
+
+	va_start(args, msg);
+	if (vasprintf(&buf, msg, args) == -1) {
+		va_end(args);
+		ksft_exit_fail_msg("vasprintf failed: %s (%d)\n", strerror(saved_errno),
+				saved_errno);
+	}
+	va_end(args);
+
+	errno = saved_errno;
+	ksft_exit_fail_msg("%s: %s (%d)\n", buf, strerror(errno), errno);
+
+	free(buf);
 }
 
 static inline __noreturn void ksft_exit_xfail(void)
-- 
2.53.0


