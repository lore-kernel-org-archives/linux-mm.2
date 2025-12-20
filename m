Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC29E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 11:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DFA6B0089; Sat, 20 Dec 2025 06:17:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDFA6B008A; Sat, 20 Dec 2025 06:17:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B466B008C; Sat, 20 Dec 2025 06:17:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8118C6B0089
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:17:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E80E60468
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:17:10 +0000 (UTC)
X-FDA: 84239597820.03.8A1EBAD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6348D80008
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:17:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V7KwCF2i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766229428; a=rsa-sha256;
	cv=none;
	b=hrZbPf2ReGGd7rpE3SLNM0Q534zhR5FeK3WRxcPa4aE5sqHE8XNK+51P6UMJDc3bDg84vV
	w4jSn9piMjYa93wO7mhGi8vfSTWtz09foqU3Cq0/GWdTctWM6V0o/8OxGMHtDpzXMY2Das
	9Zerf7MZnES7LiCFUqnCmFqjy6cCKFU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V7KwCF2i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766229428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5kBTxWJa2eNeFiRt+EFDa1P9P2/qpjVXOHl0w8hecE=;
	b=mG7IyYBgxUgfDGkkCnNUEmm/mTZJKtLoigtjVIHxktimC1Rx/RaSvllxqweKpDF5eNMlZJ
	F07K7xtHpo1CQzPft2/t98FPtlHzfLxnpEjNM1D1DUAtGfKevndcTr7EjHsi76lqfC3IxG
	iJpQy6PgQ4L5m0hS9KNSxsUMCnMPp3Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766229427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C5kBTxWJa2eNeFiRt+EFDa1P9P2/qpjVXOHl0w8hecE=;
	b=V7KwCF2iaGxXVeLCMpimcYfVMDUwx1MHgRjl3Dvccj5H4rK96ed5guIos+d0LcrD0s/o8t
	896YdiIZnQiltPJz8B7mBQJfL8gT8xRdQepOvud9coaRac6ySEfPLXlmAoKaziPOqN0XTW
	rE14xj+FMhx8dSvG00ecrVc43Jcq1zc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-CzDuxXM-PSOh1jjNwt91Iw-1; Sat,
 20 Dec 2025 06:17:03 -0500
X-MC-Unique: CzDuxXM-PSOh1jjNwt91Iw-1
X-Mimecast-MFC-AGG-ID: CzDuxXM-PSOh1jjNwt91Iw_1766229422
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDA891800358;
	Sat, 20 Dec 2025 11:17:01 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81BB1180066C;
	Sat, 20 Dec 2025 11:16:53 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 1/3] selftests/mm/write_to_hugetlbfs: parse -s with strtoull and use size_t
Date: Sat, 20 Dec 2025 19:16:43 +0800
Message-ID: <20251220111645.2246009-2-liwang@redhat.com>
In-Reply-To: <20251220111645.2246009-1-liwang@redhat.com>
References: <20251220111645.2246009-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6348D80008
X-Stat-Signature: uy4dm7qe59q719s7s4emr1w9rnnzehrf
X-HE-Tag: 1766229428-946092
X-HE-Meta: U2FsdGVkX1/fF7JRiIp0Gk4gu9oi1FGko83VCo4ufjc18hTTOVA8FxYrDy7QNyN3FXX655HCrE/pTgFflFt+SFoepbnd+g5wXPAwgXRHUDLYPe1RL9cKwNtDIFyrBQJimbcYwGMjaaOUygK5eTUv+LyFy1Yi4wRzIOPSrvlcX4accAxqwudxtcBAE405/MVUZayBJo0JuucI5Q42LoKLcHRpUiGlETAAJiA6j3kCscaeJw2yLa+FSiAOlo53DlhAYhCXR71NRFriCa8LbyZMKLktNtKUTECFC4V3yBSg4LELRYbtKd8qMM93E1TcXzSIJK9w87usBQq0tGU5E1Sl4uM4rUegtBpNnl/uW+pPzd6cgZvugYTcoLx89/WIK/MZttZf3U/M0k3ZdyqxF/iT6J6zHma1Jhk3IDiTr0z93czyvqObg8jeroRKOHNUwbtgAVi8iVQq45zMEvDjeGTLrCc+VNwItoBL5FJDH2pfO9ynsfovCrrCsi8XnDBz/j+7QJy9XnhsnielMEqdmXLM5qxNGKdNAo6hIl5nxSwag9jWMC82PfhaXZEIUTXvDEao17cBoR6371f14o+fbnZZmjkJwTHN/puG3+PKL6ftU5PktnenXsz4QBi2cHidg5u4zLDoqFJCYeQ50jpMUQfBtsica7mq6LMHfvGo1QMpz/ZxNlR+70omDXs28bJj3QmerSKMRChxhQiZz9aRDXGQf/8pgrCwM//mCwjWEXM3DbO/RwZxED6Cxlg75CenoQBIae1gCGr9h9Wgl/KuRIA7zI2ybf+ysvbjq6AQjuy80Box93pSD0BpktkD5lVKol/STIsDHyqQYb5bUodf++eaBsJl1+DCa4gkaPH3H0pkZ9xhQc9eypylVJ4GQlUZ24LZj4jCrx7VZIl3mXLWKtIASkBrP/tu+1EuoZmoEdiuV9YNaQlBFLWcQJdZVDovfbmnvwyIMZqf3yNV3Qt2KFj
 u3aJn1Gl
 yWqh22lJRTCeZ6ZbN6M9vzQFigi8X2RIfHhAXTtZBVo7KqYl4G3tbEleScNznxrYv0oLCr1SyQjo+O1LvOpn8BmCcSKO0u6vyiFXlLMggnSStJPXeK6WpEiUbiza3E22aOyLxk1UZLshZ+M9DCis37FMJEo/8nwoONnYuIea8nOMtQSI/iFo88MQz4Bmdspgjzy741D7TJNsb6xMpzP68YVYa7JD6fngww2rcCpmuMHE3RDOp/JujdyrZ03KW1XWO2DjGHJF0i6vGJwkpP+GFQSAPyqjrzI1cNy+slDZG1rCZR3AZKmnokGFc2mehfMOHAXv5EN3P6KAMKrtmpyD+ZTJI0Vx5BzLYmo80yAbiCWeSCE28wwIzHlyjVlj9KsLDOLJIeI1oI+1fHI1tNZqjz+mu2w==
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

Switch size to size_t and parse -s using strtoull() with proper validation.
Also print the size using %zu.

This makes the test utility more robust and avoids undefined/incorrect
behavior with large or invalid -s values.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 .../testing/selftests/mm/write_to_hugetlbfs.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
index 34c91f7e6128..61f34b35dc27 100644
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
@@ -86,7 +86,20 @@ int main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
 		switch (c) {
 		case 's':
-			size = atoi(optarg);
+			errno = 0;
+			char *end = NULL;
+			unsigned long long tmp = strtoull(optarg, &end, 10);
+			if (errno || end == optarg || *end != '\0') {
+				errno = EINVAL;
+				perror("Invalid -s size");
+				exit_usage();
+			}
+			if (tmp == 0) {
+				errno = EINVAL;
+				perror("size not found");
+				exit_usage();
+			}
+			size = (size_t)tmp;
 			break;
 		case 'p':
 			strncpy(path, optarg, sizeof(path) - 1);
@@ -131,7 +144,7 @@ int main(int argc, char **argv)
 	}
 
 	if (size != 0) {
-		printf("Writing this size: %d\n", size);
+		printf("Writing this size: %zu\n", size);
 	} else {
 		errno = EINVAL;
 		perror("size not found");
-- 
2.49.0


