Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB85E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705AF6B00D5; Sun, 21 Dec 2025 07:27:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6806B00D7; Sun, 21 Dec 2025 07:27:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6004C6B00D8; Sun, 21 Dec 2025 07:27:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CBC06B00D5
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:27:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D60CF5B5CD
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:27:00 +0000 (UTC)
X-FDA: 84243402600.10.B03BE1F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2935820005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:26:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GcoFNiwz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320019; a=rsa-sha256;
	cv=none;
	b=18f/EgiNz4rfyyQDJCn1XpStZcD0NyXX7DX4Z7A9dUBhIjk5jBp5CN4MH5fS8p9jJbQm6r
	aZi/l8fp0585E5s78z47bUqvHNfbSx2R7btzFZbKy8+oSQBSYQQP7S3ayGAxgGrg4NpLCg
	Lc4uHfAj24QUQhehN38/eGwMEIqDk9Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GcoFNiwz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/oaz55RIgwHHbP5HbFfkXnPCuvWreBFUWRc63qZ0WQ=;
	b=D+59a0z4LLdHaVpHCgrJsI0exfIg5yGX39XHKcMHlRzaXUY62bvlWLZVnWfWPcuefGpzTs
	tLR2+jsntnpyq0K/gogPdfXeBm/AcpKvWpWdGokfZ/lE4cRRf7b+NC6/cWokjke3CU1Hl/
	h3lHLdNR6aEuPBYpAB+LAA1IBMOyY6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766320018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/oaz55RIgwHHbP5HbFfkXnPCuvWreBFUWRc63qZ0WQ=;
	b=GcoFNiwztl+niIwsesJl/3gs49J4yAGhp5ipfMXlGQciAro42wn9suEI/sTdpOAVPhFzuC
	l6Y0HdK2W2YZFteYbHrVdHUfInJLDc+ZklV3NFSAw92IjbQRnGbyi9N42xhq9ym9T6zuFU
	CbqGJJhwKx7YBqdrqeJ6OFGJYfmuiNk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-K90Ry8O3Os-k_MrDsuatRA-1; Sun,
 21 Dec 2025 07:26:53 -0500
X-MC-Unique: K90Ry8O3Os-k_MrDsuatRA-1
X-Mimecast-MFC-AGG-ID: K90Ry8O3Os-k_MrDsuatRA_1766320011
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DC6D1800358;
	Sun, 21 Dec 2025 12:26:51 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EFE119560B4;
	Sun, 21 Dec 2025 12:26:47 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as size_t
Date: Sun, 21 Dec 2025 20:26:37 +0800
Message-ID: <20251221122639.3168038-2-liwang@redhat.com>
In-Reply-To: <20251221122639.3168038-1-liwang@redhat.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 2935820005
X-Stat-Signature: d6acq7rkgr5xzx6o53timupf9hxk391f
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766320018-692678
X-HE-Meta: U2FsdGVkX1/aCQqDWHVKqKbfRx8yiY7PV8ejGqxB91ViN4f4LN1lk0nPglEL4plpnmulDF5U9wTVTUYhvwUcDKX2GGyeX8YyFhfzyxFfM2BpDv2E1dthkB7Z2SuYj20e4t131C1g/mpFmvLItGhamvPSDNm6xejCKmpZH/0TMszBt77u3J+DOjCNtBtJ8K+z0O1hocfCzB7MJrz003FBbjC5u7GtYcrV4QLN/F4pJ1EBbd6YMlya6wpYGHlyEj/RKxr+qjMAbuqDQ2Yu4TSTc3zdzKFood3p/NbHyN28guPB2yHnHNFG6lk2a5wtPVoNkyGI9UGCV2RpD2o/1kqHZa8EC9oVqdc6h+G7vwz/3sLWL+nkIi+kqX+4/KAbmgIu5DVFbKvE1vYVCP91CuoZUAqI58d1fhgKWNrYnzTBXZ5wvPLOI/JRsolJhMnVA3zkNt8QfJzpV3H4lA8woboYMG+S87CcslsTmAkED6/8BEdrTQ/G93r8TC4ct8Qjhgc9sT06911u1ZUdzSKGpsrFnFxTzCqD+kQ/GEc+jwi2O6xsFkK7k2LKYyd7/wLKBXREH6jIoh9dxyOH9ZM6TemRm30v687GmHjkxj7XGWH8x4URDP88yn2z97mrwuIkfGo7H1emohkrxMTWjxKB+Hpqn+ZhGfd+vfp5BRlhMLPGgMcvs2ci3BmmBEFPbLY0ihyS9bpJlF/UrOP6+R34kAvGli1WVYFro+IFT4qFCyPO9UTlyLXOfXGH8m5omNUWhi7ywYi6UE1D1YKHivzredzS5nRR22CK/eYb+vDmgfRnRxg6sMdrtz3sMt8Rsog5UykMyNqF/X3km0ucOYxCNg7vdAXz4OcUITXT/Lq6VYe5rOG6qan1QbxOvy60MXQFh0Ico5LL66CWIap3uF3KvzZFjzru3f48K0DRmN7XfdY9zcagPwqJsvv0sSLDjS7rhIhusG23eNJRZdUO18iqzTo
 Dz2YliY7
 UTNbOYbK3TP41Pt8CCq11e62Tcs44VBk6l+0K1SyILy3NXIffPIm9TlNi9PRvFoTS9hsXiIOEg0bQGozNiMf4AHG1uu+lrTHWoFXi1Ek2OPNPix5JVTqk+XF746ODG/3GHST6n8SzbhuQlP9INzDccL0PUh36jK+YGbH+TKtMMF57k3V7BWSOrtGJb0LT574BzpTroKdnmo/o+9YahTtWYwKbuhErCHtcPI84u9PVc7T/cuIOo+ZW50nWVguXKLrf1tkQyPqWcJKsxV57Mvj+7ZvOfexVp9W1+leGDSCwD31pklszn3R9BHflH48lZVYspdcxQl5cQVqwP9OcpwjLJLPHsULcStbhSFL54pwHiUFmFPUrVfL3NsrXwWzdLfqNce+TXw+RQshDr+tYrORDQlmUWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

write_to_hugetlbfs currently parses the -s size argument with atoi()
into an int. This silently accepts malformed input, cannot report overflow,
and can truncate large sizes.

--- Error log ---
 # uname -r
 6.12.0-xxx.el10.aarch64+64k

 # ls /sys/kernel/mm/hugepages/hugepages-*
 hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/

 #./charge_reserved_hugetlb.sh -cgroup-v2
 # -----------------------------------------
 ...
 # nr hugepages = 10
 # writing cgroup limit: 5368709120
 # writing reseravation limit: 5368709120
 ...
 # Writing to this path: /mnt/huge/test
 # Writing this size: -1610612736        <--------

Switch the size variable to size_t and parse -s with sscanf("%zu", ...).
Also print the size using %zu.

This avoids incorrect behavior with large -s values and makes the utility
more robust.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 tools/testing/selftests/mm/write_to_hugetlbfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
index 34c91f7e6128..ecb5f7619960 100644
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 	int key = 0;
 	int *ptr = NULL;
 	int c = 0;
-	int size = 0;
+	size_t size = 0;
 	char path[256] = "";
 	enum method method = MAX_METHOD;
 	int want_sleep = 0, private = 0;
@@ -86,7 +86,10 @@ int main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
 		switch (c) {
 		case 's':
-			size = atoi(optarg);
+			if (sscanf(optarg, "%zu", &size) != 1) {
+				perror("Invalid -s.");
+				exit_usage();
+			}
 			break;
 		case 'p':
 			strncpy(path, optarg, sizeof(path) - 1);
@@ -131,7 +134,7 @@ int main(int argc, char **argv)
 	}
 
 	if (size != 0) {
-		printf("Writing this size: %d\n", size);
+		printf("Writing this size: %zu\n", size);
 	} else {
 		errno = EINVAL;
 		perror("size not found");
-- 
2.49.0


