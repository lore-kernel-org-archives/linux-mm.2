Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138411091900
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE7D6B056A; Thu, 19 Mar 2026 13:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6536B056C; Thu, 19 Mar 2026 13:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC1E6B056D; Thu, 19 Mar 2026 13:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1BA6B056A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18D42C177C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:09 +0000 (UTC)
X-FDA: 84563523618.13.25A3A8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 15BF2A0013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bJM8tMQS;
	spf=pass (imf25.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/jvmDsSdenM6skBubfPrd0khnqGba7F4XN6aWwL11s=;
	b=AD5KviLNCDgt34iz8OucfB0Vj1CAy2hQ3ySWk0VCO3Tw6JnrQOuWUl2In5N8lWp0RRElkv
	Gt1uMy6iY503szadUMtqiTW6yjpkLbcij0nksSlqEUJnn/Q6pxFjU2uBTa9xA3M0x0rC2J
	09OtLc5m/4ApY7K32/W+HW48meymx8s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bJM8tMQS;
	spf=pass (imf25.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941947; a=rsa-sha256;
	cv=none;
	b=fPfYCt5sCC3j0LDWqhSnuPX3BQ52N/xKUeZWwCYEzKLE/uVwCy0zxYxY3I/2fTgIvzux6g
	Tlnau+yzBg1AO4QiXiZFNiwE0e6eKwriEdgj4nTJ9rKy0tPAlUklRqrLO0x9Utz07sXzjo
	MR0elVcwyJ7mwYoWCG+UWbOymTSVlq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/jvmDsSdenM6skBubfPrd0khnqGba7F4XN6aWwL11s=;
	b=bJM8tMQSgc6w8YG0CMzmCGjOd48rSBJNSQwO+MhOxcNh/rP/a8hN768p6QJPYpIhk4Rzqh
	L/u4UMiGkcz5/0m4rH6UhVLJPR60tYmH3B1MZKtzU02haDikb7nTDZcrfCwWiBi7onZPlM
	PuQM4GczXy5XWop/28v42Ugrr/LOIj0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-98-vOcC0yM0NdWBC-rmiE8CEw-1; Thu,
 19 Mar 2026 13:39:02 -0400
X-MC-Unique: vOcC0yM0NdWBC-rmiE8CEw-1
X-Mimecast-MFC-AGG-ID: vOcC0yM0NdWBC-rmiE8CEw_1773941939
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3593E1800464;
	Thu, 19 Mar 2026 17:38:59 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E99A830002DF;
	Thu, 19 Mar 2026 17:38:55 +0000 (UTC)
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
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 3/7] selftests: memcg: Iterate pages based on the actual page size
Date: Thu, 19 Mar 2026 13:37:48 -0400
Message-ID: <20260319173752.1472864-4-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: hmL-c6m0ugK7mtEFvJzM96g4WLagOtTyz11vVv3IiHw_1773941939
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 15BF2A0013
X-Stat-Signature: sqhqxh55d98kujugehs155pwfzhgz9f7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773941946-78254
X-HE-Meta: U2FsdGVkX19c/iMmbauXRtyBSiMeqINFFD3IkAq44xuaj5UJdbZUsDi56io3jAQuf/y3S9+6hVYny94snNQaMwBfO+iMULn+J1aihIDFFXgwUNRJUMHTR6djzQZD1sRcfFTAh4Ef4vCUPSPtCiNBN8UZR1K59k2470YA2aQrj7YF2sqNnEzY1VwrAcjPca8T7WvthuUp2aE3aQqUHwdDP+XMHbPMNCnIRqovxS9WK9F9Nt6Ppt5470BoERr6AdfNy7V6HBtblJfnE50BQ97kjWSv5o1AqkIOCJEfZmkXu0tB7uiipQuq+G81st/ukR9qr5EjTLRC5FIikhaITwgwozKH4dhRoKyv7L2Z06jUyATqoFPM7m9JKt/AwUq66l2TDErrLI4txDI6hpctCo6Pkn/uStpAAPFOhtt1wB9co4p/aXWtIFqO19NNkrEM+uEhwhR4GV+eTD8bxjbjf7qOxXR/wD0jVvFLNwXEUOg/alKQHIyX/1QLxBNqGKFOBCvyCulwkuKwlaP5pU3jvqqRLlcEKyCY+KG7vqz6h86gl25gFCrhQgVQe32xUlgufwMezTycfI8SdzTGDr/YOxLj6koNkMnSnpmS8stp/PwU4EBDvYuQKQ2hQe53eKxI0DbeTjfiv8+xX7YzYbOyRTQXwMOfsyQIks4TiBFS1959GVlvCvZcJRYTHRwtQZBmcxSknRvcrpeOL+3WaPImTqO5QuodouJy4l4W7Poko9YeCsnh1U1Yzx7iOYdnPpNqs+kEn+IOf4O+BaZa3LbfqhedoYkkeqpnsQANj6ALeDfBvQf5a568Sf0si3TiGLfqPP8bhrjGkN3GkN3orUhmQtR/N73QCckluYOcLotQklhxPkVf+gpKz0P3ffts2Ir9F4hsRJV7rTT8jn1R5Y2CuiddSfmwF9xhSrHXNOyRiGj+nh+KxGvYJHUWULc8u4JIE1v5+qTZEspIUCUYrc+xbZ5
 iO5c9fyV
 nklH3C3GZpF2AIWViq4018eyl54cH+VakRCwvn7dywOUNwPfi+a6oif3HqeBT25DRJ1mjYM4a9tSKiEkS79DE7JshRjoZsGCOY5S1ARAouaDshv/OBV4HeqCmT9mB/yLs6hlsimbOElhOpobTG1CTpoeqn572GTfmrFUVna3kUXAy0RAD4IT9s8as/6gYPNmpVmlaGMriJ6Ns3+DSOgQgWu48HADcZls1CSelkIVFw0G6YLpAY0WAjNVgyvXQT5O+ugZIMs0dIdI5gRmRW8WpmXK5fydAYY3NNUXWzBaZaExC9YyqVVSIm1ORVOWXuEn7eMAGiBF3k2UyIfTBZCpXwb9nrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current test_memcontrol test fault in memory by write a value
to the start of a page based on the default value of 4k page size.
Micro-optimize it by using the actual system page size to do the
iteration.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index a25eb097b31c..3cc8a432be91 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -25,6 +25,7 @@
 
 static bool has_localevents;
 static bool has_recursiveprot;
+static int page_size;
 
 int get_temp_fd(void)
 {
@@ -60,7 +61,7 @@ int alloc_anon(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	free(buf);
@@ -183,7 +184,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	current = cg_read_long(cgroup, "memory.current");
@@ -413,7 +414,7 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	while (getppid() == ppid)
@@ -999,7 +1000,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 	}
 
-	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+	for (ptr = buf; ptr < buf + size; ptr += page_size)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
@@ -1679,6 +1680,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, proc_status;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0


