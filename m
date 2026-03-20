Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA5011099B3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7686B0105; Fri, 20 Mar 2026 16:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EE26B0119; Fri, 20 Mar 2026 16:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457E76B011A; Fri, 20 Mar 2026 16:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12FDE6B0105
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 906C013A6FE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:16 +0000 (UTC)
X-FDA: 84567616392.17.866FA22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id AAAC12000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UuNQi5iO;
	spf=pass (imf13.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfO//jEnSYldzUsKOHPHJUlVmZFV93Ikx/CBgNaV2RU=;
	b=f7DMNWdu8EFKXA47qlZnqd+T58WEdur+MnflTqb5hUJ0pJXg1XYniBaNBmRAIGv/mZ2OmW
	ZdrGg1+FpyTpzfE/ngZJy5GEBKP6PeDP07bdE1r0G9SVmcfEW3wxBMkV0PlKyBqK3Rb+fK
	Kq3XMRpcXV8Uzv/FQol6X4LausJ0IC0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UuNQi5iO;
	spf=pass (imf13.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039394; a=rsa-sha256;
	cv=none;
	b=JpbTHB2qNf6xY8RZ1gv5ksjK2Xq8mfYgXws/AFzg6+0u0U9+zoHF5mMamBK8yaC64Sy2yB
	pvnR7wcZ59fb36aKUPE8hogCxgcPNvOYSlEfFIbGPmYq9NmkqpbbqWQN7y0gRz/bisJIK7
	QlWWgje125fAHMvl3SlY1+ljuAoiHcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pfO//jEnSYldzUsKOHPHJUlVmZFV93Ikx/CBgNaV2RU=;
	b=UuNQi5iOgN24XYMau4fkrzZfkyaECdeU3bkAgvIFyLXJBzH2IUbx2eIW8vYCiYfMbQ/63p
	SA/khuRuisxP5HWajRomjBrvl+FRbueNMYTvsMiRfoxPCJlczcvkrMfc1BU+9CnZocLSaZ
	dhELxgt6T2hw2JRkFcMRQFD0IejO9XY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-711-chUDSaZ6POmwEwwfCUIlXw-1; Fri,
 20 Mar 2026 16:43:10 -0400
X-MC-Unique: chUDSaZ6POmwEwwfCUIlXw-1
X-Mimecast-MFC-AGG-ID: chUDSaZ6POmwEwwfCUIlXw_1774039387
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BD1318002CA;
	Fri, 20 Mar 2026 20:43:07 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3256E180075B;
	Fri, 20 Mar 2026 20:43:03 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v2 3/7] selftests: memcg: Iterate pages based on the actual page size
Date: Fri, 20 Mar 2026 16:42:37 -0400
Message-ID: <20260320204241.1613861-4-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: IDcHkinoTTkAMq-kCWpRHcNQSHgwKfsxk-hype8l3IM_1774039387
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: AAAC12000C
X-Rspamd-Server: rspam08
X-Stat-Signature: nwomyxy39m771k77sb1hqikp1cxgasg5
X-HE-Tag: 1774039394-552514
X-HE-Meta: U2FsdGVkX1+feENQCWJq4esg9/qssXp6yELMSMIL64lFw8aJQV8GCYSiGj6a6YSEAAQ8SdN0/16a+XltGB83zo1JvjmjmaclSxYQHGHdzmnZoAjIVvk8dhz49W3pukWwbwNmc2YFJEfRppliMkVeJTVbfzqZQ6XFCiw2fSIfc8OGo4aZTkXmkj/urQEFr7CWGhOh4+VJ7uNI1Zi8C2MSZCnZx/UhOLtBdR17LGhPNs/frt6CyKcnhEK8MD1LfPoo6KpnqW+D3l24luAqKeTl4keTFmZoPfV0qTf8wvT3Zej0M+JF475TJW21mjSXLdfeeHxTC8RJTsdz6ofkBLdau63hEzit1cDqJbQ9DPZcksGWlUGCx5l/FenzrnFVFhoWXb50ty12hT6WMMQO5Y7wCV9jOeyCQVtXba6n+tpnO3DFYISRibgk6YIpKxeGtNWiRFPprVTqH0ar2GFnu5aIJgQlqwdrBf4pncK4+8sv+3D+eh98d49Fgy8dvs5Pj/dOPCLb4dPARlJPCldPg/xOdUF3BIaK2yMF7eeped+fDQ1WxIm0I8zfvY0eA9sh/ZokYnPkkKyL2FC623X1wU/Wz7vnukEVJXcssPeDDsnC6F40+X/ewU27etP9YIizjRLY9TL6IoEVjeF+Vp7rdnFBgRhTDcQE/GPnPgd0BmQG4uaHk9+voM8ma326B2MHUeRftmlrspduq8yIyiO1oD9gdgQFblM4wgiEnxju5y5EriPN8QruqQHFWl49i89XiPPQjJSMbIHOgCPly9n1PfPW/d7Mp2QDgJwefYlgUVhuEg0UCL+XkXr23+b24od2Mhpn5N8qxnUiIDk4O5OT2D/nQ73hys/hwbR8jMRMH1YNfuNFjhoTnQdCdwTn0CePI3bxHYliFEHvMHQIqYI3Tmkol01wl3AaFzSBgyVtjbZsS+Ncu+AKSh6j5oaOAzC0EGeZhPjLbm8tIqgJeQP6G/G
 lWxnrHwI
 cDCz1HNQH5ltfJwCdPtlrbY7nHHzry6lnN8dqY0L0tNu3mi2N0GUqTCkR+ObwaZ0QBCMWwzHY3F3Lhv2Hk4RA8UYjIbcS/iX0ZYnOYlkv9pxh/oqZQ5y56CO3y/H9dc3mVHl4tLyuTDWyYhuME4WJAWBWygFtE1B/B5C6wJPl2c+cGQjdxRm6XHXZQLYtsCB86IouFzsq7MQ0MkExQDSmQKujApD82djZ0mp3NXVRlRx8yCXHZYOOd08swOcqDC1R/xsczU9TPjzLOK2qEOP4vwxn9SRXLHQjpGGQFPzGV69buxHKEjefdZvj5HM4tTL4ueI1YSVSwaHNe4aQee+7C1RHeg==
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

Reviewed-by: Li Wang <liwang@redhat.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index a25eb097b31c..babbfad10aaf 100644
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
@@ -1679,6 +1680,10 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, proc_status;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+	if (page_size <= 0)
+		page_size = PAGE_SIZE;
+
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0


