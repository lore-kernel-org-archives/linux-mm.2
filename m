Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 543F6F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAF06B0095; Mon, 23 Mar 2026 11:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92836B0096; Mon, 23 Mar 2026 11:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A818D6B0098; Mon, 23 Mar 2026 11:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9529D6B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:18:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44A1DC3828
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:53 +0000 (UTC)
X-FDA: 84577685346.30.33A33F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6C12D140016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A2FZW3FR;
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K89HWSWpfVYqvEFD4x4gGS5mGEm/+AIxXEbbLx4GIvo=;
	b=TYPBuPM8CViYAtKUMYVe0wN+OqQxm5R7k+epma2l2UIXBbF2lc2YpD253VgdXGAgNvIbaE
	d/0Hu+CC2DCB5KhT3r+vzUD2XEpiSk77pXUTj+Xp6okQjYzohWSOJIhfstKuy67FmmC1MG
	X7ri3a5+6h3Hua4n46LGVSeazmkwqmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279131; a=rsa-sha256;
	cv=none;
	b=c5D3OPYByb0FV2xH6iY4XHTMnoPyZnQTvBDTUy1jzPnnNQHm/lz0gkMCuOiMqhPWChORhT
	r4JVpo7gLtw1dO4w23OXJLK1sBEl2IDFADg3c39L8V+mekz53gFEUHpgy3jPCVe9bsBQve
	+z7WRb4FeSekVEFzbH3fL5eI8Tvpt+M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A2FZW3FR;
	spf=pass (imf23.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K89HWSWpfVYqvEFD4x4gGS5mGEm/+AIxXEbbLx4GIvo=;
	b=A2FZW3FRZxyE5JACP397M7cHTCe0+mu/JC6uAWvqkwV1EJ7iVmPIi2L7oIdposg5B4YisE
	V0tj4wdo5jFm7xc5fYqoq7gh2ETsZe3x9z+pN5frye7hjMKo01lGAMG1bK1/1hnjsq9BPr
	OtkWy0Cnc5WZMgrGYkj9p1kjdSciT8Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-6G7Fq-g4MEyxsY17lVplLg-1; Mon,
 23 Mar 2026 11:18:46 -0400
X-MC-Unique: 6G7Fq-g4MEyxsY17lVplLg-1
X-Mimecast-MFC-AGG-ID: 6G7Fq-g4MEyxsY17lVplLg_1774279122
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 749F518002D1;
	Mon, 23 Mar 2026 15:18:42 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 885031955D71;
	Mon, 23 Mar 2026 15:18:34 +0000 (UTC)
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
Subject: [PATCH v5 4/6] selftests/mm/vm_util: robust write_file()
Date: Mon, 23 Mar 2026 23:17:51 +0800
Message-ID: <20260323151753.2576137-5-chuhu@redhat.com>
In-Reply-To: <20260323151753.2576137-1-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: lgSApnc8sRaWouDDkDypyCuoEFG-sCVE9cu9XNzgbhg_1774279122
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: ykdkgm6e49r9rqf51njbwtcs7i4ghg84
X-Rspamd-Queue-Id: 6C12D140016
X-Rspam-User: 
X-HE-Tag: 1774279131-851561
X-HE-Meta: U2FsdGVkX188TdhMYwZafEz7mBheB/DRkjoXo9xsYaxrovuJ45h3QGlDZl8QnHUwyTk6aLpc7jY0wFls5DN9HmA6x04TNxOjlhuNE5FZkCHcBAw7ACJpEqFx1h06rC7+3ghnpFrMPyqPgdIA3ttg0MW8IAb43cTsdjblQeUtwuTCUiG+VA88Zorxj2eisiespqzzrwcZN+wjZ08F3xWyDHMZakldBejhJ3zWGcOp5s0QZbsH184iHZPXoXgYQ6CuEmVAW94ZOV+2yrxVb8muVwlmmG+R+m8h4Aon952ntciySfhLUdWVuLOOhXKXbA4i+WUspc86NshFQKJj52xsfhu+yVrGXYac1A+rCBntXQmhQiLWzv0LFVdXSuB9VnXzRbGvLMC82yMl3uZiTpSijz9No1+9lVnDQKB+4YFQp1UhKlqJeUHoBvQBRH6JzCkWDw/TyRFuFG2olsoQmXep4VkxznlPGpGTP6q5bhp0/WW1NFxosbaKgHUzq9jmRmLkClIjbFNv0jSC7hW4Ov9hmAIEK7DTSdiOCEaH0mQ5/EAiK+gL60u44USLbZ5PvmhJg3U/yHbc0rq4no0bnoGqjHRh97pppS7GBJB1Q57oX93Nf8FEcRRgkwMoBtDvbH+Vei4YhFV3TrMiprLOOowZpsXPH6ZH2pg6ySM2f9zf0MOf6472pHiWgR3PSgfMrAH5jU72SCmPVUdxXRpFZtM7ucVe72dA4Mi8s6t5XIPpn4BLdG3Qxq/bmgEhpAQWUvI6ZOvbSnnrXqK1RTHIcif4/o7xNVdeX/c6jU2FZ/b3ao4euaYG+Haha8P//9JMrlvo9XSw1AZCVKc/yPNx+6h93M2Zbz0Va+3nTOc9NI62EOhAUtXFsGDySl8beaY7r7lL9dsjEadL03mqkQmoTVc18+MmWjUUl8rFFpBt0l6PHwUWdoRL/1rtdXR/WvJFNnXb6f0ze2IGb3j1EOfJ/fz
 k9EzMtks
 IwB760bmz9WvhtAtTQFfuvwvmKqv8+P9YKUTwvjSLeJp3f+iU+R//Q1cFMcLCJ84RNZKHO8s+34MrF9umU9ObzYrxe+ZXQ/tzZ6/OYdRBVGAZkz1SVfq4cXNlMHB24w6heKaMtXX97dbiUSeuT6w9/om8zpe4GgssSPIplx5JM8XT6Ws716qRyrAYC2yAjhuUz6PpIIL7D0hLjQUiUnC6eatiDVvUNU++cpTyYmDUKl6v+cqBrTgj1vdrndXg46zzCTLkRE+Ag4BgFdWpTN+kVbo2xiQnBIqyYTk9KCVXCGz2++jDQMbCzzN7KgJRFvDUtqUkyoCvRGkgTQ4vV/QznqhSvG97ktVvNqgp4dgMGHi3D4cQ/piAVO3W0Tzl9+TS0lN90jVg6DMv164=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two more checks for buflen and numwritten. The buflen should be at
least one, otherwise the 'buflen - 1' could underflow and cause trouble.
The numwritten should be equal to 'buflen - 1'. The test will exit if
any of these conditions aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Chagnes in v5:
  - new patch for making improve on write_file. Add more safety checks and
    diagnostics info in log
---
 tools/testing/selftests/mm/vm_util.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ad96d19d1b85..02db3caad646 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -769,6 +769,8 @@ void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd;
 	ssize_t numwritten;
+	if (buflen < 1)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
@@ -777,5 +779,9 @@ void write_file(const char *path, const char *buf, size_t buflen)
 	numwritten = write(fd, buf, buflen - 1);
 	close(fd);
 	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
+				strerror(errno));
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, buf, buflen - 1, numwritten);
 }
-- 
2.53.0


