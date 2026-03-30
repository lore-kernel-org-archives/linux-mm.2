Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB7111061B09
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EE46B009D; Mon, 30 Mar 2026 11:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156486B009E; Mon, 30 Mar 2026 11:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06CE06B009F; Mon, 30 Mar 2026 11:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8F296B009D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:16:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2E891607EB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:11 +0000 (UTC)
X-FDA: 84603080142.03.B26F045
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id BDC121C0011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IVQRZlAy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883769; a=rsa-sha256;
	cv=none;
	b=WHYptkeC4lcvd8Ao4GzjAUEuh6L/+oY7OkOOpVsY0W899rWX50tkATyTxHVk/8TxUtAlD1
	ju9vcue2SWR7fEA+vjL7p1hSz3xGE7m5OwzOipergY7/Z5nm49iKBUPdwcwT41FoTjaxY8
	bS7917c85YJxom1tiltrMqBiBSw0L+w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IVQRZlAy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1tErw3apD+S1FQUsZ/S4dLljpIAMgHXSr6sgIoc4Ns=;
	b=ZulYNvJ6c9aISmC/YbnD7J509Uq8T84Zt0Rru032vz0Qf7txtbbuIoVc1a9T7Niquopcql
	TFQravyYCyA1/z5MUV5tBv6C4M15FHARDE3dP/xtCGo8TOT+7GMo1DRTDi2ctl91MrA0ma
	bNUrV+8GGV2vvZHS6nclyYbdo19yeuk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1tErw3apD+S1FQUsZ/S4dLljpIAMgHXSr6sgIoc4Ns=;
	b=IVQRZlAya4PVieTfrVWdbFPLrBa/DNW9qi2XaN92EgAYJBTcJ5GQ/9rBfwZFs1P63G9Z7L
	uwmvKgw2nYs3GHRxEicDCUfyQGySxt7WMq34PcfttFnlmkYhWhjXIskp1vdXdXkIMYjzPD
	d2qX2uEUGraaQU5ncqG3cg4+1rQjH54=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-D_PY-4v-O-iwOZ2SptaFdw-1; Mon,
 30 Mar 2026 11:16:03 -0400
X-MC-Unique: D_PY-4v-O-iwOZ2SptaFdw-1
X-Mimecast-MFC-AGG-ID: D_PY-4v-O-iwOZ2SptaFdw_1774883760
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8442419560A7;
	Mon, 30 Mar 2026 15:16:00 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F8C419560AB;
	Mon, 30 Mar 2026 15:15:52 +0000 (UTC)
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
Subject: [PATCH v7 5/7] selftests/mm/vm_util: robust write_file()
Date: Mon, 30 Mar 2026 23:15:01 +0800
Message-ID: <20260330151503.670415-6-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: PU2y-J5m6tb4DwoQTiQNf1R7pjYx88YGcq4Uldkfbl0_1774883760
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 6z1n455yoymghksjg5tfokrh9hqtqi37
X-Rspamd-Queue-Id: BDC121C0011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774883769-402344
X-HE-Meta: U2FsdGVkX1/w2FwVOhSbUTFq+N4fUxLjrcduW4C3t3WbVITR20q8IZoj0795Ng2t5LDmJ4XHH7roRC12rZJ2wN0aDKujQRjl8AI2+WCVH1x97H5DJSmDe+u8MvFLFpvDvATowzGGSoBhDC/nzYqFwezUJCdN92x/iC64pe3u3nEeInjM7anBad6Z1rGBAtcemQEqJmbgUYYqb2k4IjX1ZQV23g1yfPqMjRPOfZsFLJNc14q4x+CPNWPFM8GYUr+odpQKiwjGyxD7H7W6XRnArjvQSF7nqegAZ6JEYotcG0eY28XP+q9pZoefK0h9KU0anDBWuKq5T4AF4E1MXNCtFhOKbqSbadWvrXOJ8/dvZ/wfsC6gYSDQOS+ppCrygQ999hLio8QK3PJKWsAPkUQf28722oh3n6JdQ2gxuJAN8tJCNQuo2fi5sqdyyHiQsxHk11fXEM9961hjfL0k474nDp5ZCGUBy1XaRLEvG4dFZYT7UdWvs1FPTgch5LdatpDOkU/u2f84M8K+Y07vHafJ+LYZQFhaYaYL9JwzWiuYLEVXk9fgfaR9NDQfEMZzD8OK/IO6ZvocX9R2W6laY0bnGG+zY62fR1TnHPaaJSjHGVLuqOuFiU2Buxv40WwTl0Z6vVcP+CqASSjONdG/XiyoHuiLDMQqnciFzGd7WDuYtkZBs82zAOC8wZGUqp6BqVELqMLgOMoHcoDxPSJnocFmmTEOIALSo2Iinw0VvXt4qn6WAHFSW3MB99HcHCvxuLCyLAk5Fh6QzAt/yc8oZ03uhOnHzLxUhIWMnL0sisNhRCXnfFucxZfCRKhfe+wH6h+UxQ6sxfkJk1AKS8krYCgZaFVIDbTf01J1FZ+29aFSQoe9H3uUAO56+fUaskIlROxkUbNBgcyN41IpT8PWJJNr/bZdCWb3AkXEfcMCIvc7+n4ITKLR+ZV/xVaX3YEi4OAhU4wb0wBs+aevxkRO7h3
 55f3euF6
 bC0t9StFZOwAluZ1fLATUeTrIcaSMcDtHN54xQMeX9Aip+77nNruGPafPPTHDKBFBKz8tw4VP7rCLsaFZFTPVKb7k/B6HWtfy60La+sBJMvaGtIzUsj6w4TSXghmNGQUZPOXCyqNOWHVyNidguelmRqkQ2LWxXPQtSmwf/d3WWDXjmkVzeFWZI/ofBDLAnWKaNlviiZLn9qeu5c6DeUGl/bSU+/18iNHtxZiRg3hR7izGXwIt/C4Djkh/6VZrMKTlB+Ul/CA2NsMIYkSirAkWiKqu+Rc89rLKHNGQhfNKrRVwNWmW0fom25xQbyeEDc0I/GAA0oiKAQmA+sRCD3Ey0nRWRRju2wm5j56SRMbMt+vECKC+zsqtDEYWXjZ7egH+s0XWw42MtTxcMi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three more checks for buflen and numwritten. The buflen should be at
least two, that means at least one char and the null-end. The error case
check is added by checking numwriten < 0 instead of numwritten < 1. And the
truncate case is checked. The test will exit if any of these conditions
aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v7:
  - add an empty line before the 'buflen < 1' line.  And change to
   'buflen < 2 to limit the buflen at least to be 2, so at least one char
    is allowed.
  - handle the numwriten < 0 case, which is the error path.
  - use ksft_exit_fail_perror in error exit path.
  - use %.*s to print the buf when error happened
Changes in v6:
  - save/restore errno before and after the close(), so the log could show
    the correct error info on failure. Suggested by AI.
Chagnes in v5:
  - new patch for making improve on write_file. Add more safety checks and
    diagnostics info in log
---
 tools/testing/selftests/mm/vm_util.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ad96d19d1b85..00aaf33387f5 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -767,15 +767,24 @@ int unpoison_memory(unsigned long pfn)
 
 void write_file(const char *path, const char *buf, size_t buflen)
 {
-	int fd;
+	int fd, saved_errno;
 	ssize_t numwritten;
 
+	if (buflen < 2)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
+
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+		ksft_exit_fail_perror("%s open failed", path);
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+	errno = saved_errno;
+	if (numwritten < 0)
+		ksft_exit_fail_perror("%s write(%.*s) failed", path, (int)(buflen - 1),
+				buf);
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
-- 
2.53.0


