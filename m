Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14D01099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CC46B011E; Fri, 20 Mar 2026 16:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E69D6B0122; Fri, 20 Mar 2026 16:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC156B0123; Fri, 20 Mar 2026 16:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB55A6B011E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5845C1895
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:27 +0000 (UTC)
X-FDA: 84567616854.18.4034242
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id E2952120010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O6Og5iij;
	spf=pass (imf29.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHG2nfg0B6suxMqU67D+nlAd3e+FK+NpiYnNJSdtKWs=;
	b=r55tgfc6iC5YBSj4eNeK4ChpB95oAped+i3kolYKw2R3sErAg79tPFctWRO4eCGlYq7+qr
	LnZ+YbXAMkkxMZH+CxHq108XU53/Z4BzUCjgAHOGw+UlwcEUz4h69ekOboHpz2Kie3x4Fo
	4UO8oimgGoRQ0hhI4Ijw7cbrQiKqjpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039405; a=rsa-sha256;
	cv=none;
	b=qSDquKXyuvAFtYLJHmsMlZ5anNDYDNziVVJKi5sWswdUkm1d3FGRHvGICZWLJSh4dqiVhe
	IsTDiOAuVnry/1ae6pJavFx3daZgKGpLL8O4dxfpilYqgAq/FyKA+ThP+f386l5ckKkWdh
	PlscNJGAkXQ2cm1sqYViCJoNKCaL69k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O6Og5iij;
	spf=pass (imf29.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sHG2nfg0B6suxMqU67D+nlAd3e+FK+NpiYnNJSdtKWs=;
	b=O6Og5iijOCVFJX49fuJGP6B3Cl5CpBa+P+43pj76C5HggMO57lYYS0GoJGXv98qgEuPKES
	KS5NTCWOE1qddfblxqxAvuQU90Y8VtzR27vYb/3cbc3f6FJ9Lfppbt0sdlNqj88TiONe10
	BqdyxbgX/4tIL4y9E07KixSMgiPrdC8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-3zwt_kK3PZmZkZVa34aB0w-1; Fri,
 20 Mar 2026 16:43:20 -0400
X-MC-Unique: 3zwt_kK3PZmZkZVa34aB0w-1
X-Mimecast-MFC-AGG-ID: 3zwt_kK3PZmZkZVa34aB0w_1774039398
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 682C819560B4;
	Fri, 20 Mar 2026 20:43:18 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 23EE81800764;
	Fri, 20 Mar 2026 20:43:15 +0000 (UTC)
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
Subject: [PATCH v2 6/7] selftests: memcg: Don't call reclaim_until() if already in target
Date: Fri, 20 Mar 2026 16:42:40 -0400
Message-ID: <20260320204241.1613861-7-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: v7EltRxiGH1JkMOu6Xv1oAHtIwHLh4TzUph7kRsHBTA_1774039398
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 7b6ekerdyuep3h77no68bxburkorf598
X-Rspam-User: 
X-Rspamd-Queue-Id: E2952120010
X-Rspamd-Server: rspam12
X-HE-Tag: 1774039405-840753
X-HE-Meta: U2FsdGVkX1/EEFzAxAAdYwcVzSd7SOwobpnY+j0ZtL2tCCevzGVj6/iawHa+i97mAa++kTKcVdpwntgojG9mhkR9dRXx3VPSoaQOWOSfY3KnMojOqOtdru3ZcUAYxVP9fZoG7mQ1prHNpr+QOQbxdiyK7krD26unTjNMLUc4TKwZzjMjLIHQciSWB4oSf1wMgRGyLQe5rO8aYUjFcqVMu3L8SFawJ+1gt3ePsCNKUFhysbf7sBVsOKqkUeYoHkIwadwHV2MN5M/ZXMExThHxT63Ik4KbHFrlBBL9H/AOMnnOZxTLBeBWI32ewfNVUmPYOQvmwjd+x3qvULwyuyDl59Q0j6t8J6Ahz8hl1xeWMYfvnYJZZasI4XY4rn6LXahq435UoLKKTEXa/cmSdiX5ojLArHm/WYlqT02+49b4V8PI71OrPNnI9FnPJkvoaiFbxoyhAyGZvEqRVDomNEQfo9GAqJXXCWnE4SctEMZf5IU3rcdNTYS7ulWQlVjwp+pD0CLSSHPxoJC0Q4H0m7UPGA5ZL9T7m81TTh5ABnqdkyVl/H/NHX0PxlpSIq9fEuAbu4J3qFRNJYD0nVCGvRW+3zn6BlmQTga18ynIFq2q+rjZQUlSYZI9fby+Wc0shP6bfYdlNwzNaoG0pr6YbXTCrA6UzdkvDxkXHwjTOjjJ104PafnQv9zbxGfb5Wtj66ymIAmNFTe2GiqiakBB14Ewk2f6f8KvOj7E1aiK8mdvRWjCEGC8BRcLukFVOqiOAqyHr+h0jb/6qvcfDKjw33JR2Bu/KuA13hk+HghOSCNvKVeVGp2DFnEvGx98tCPFeH233d7Atww3beCHF9Mck8gP811wv8cxXJd5yFuH5T6uxHFrY/x679y4MN6W/MGnE0VQ5tquEPy34LxjDF93lxUaAkG6qJp9FJBslBOph+oSCMX9O+v+28kGS90x2bRyYDV0YrP34j3aIbZmwZn+ENq
 5N6rehyc
 qlwp1tjr/NuX6ZRYI4FeSJS7PF55P452m2PzE+/O16eeOKKJFagIZ73z9NJX0dPKmUd4FhTQKG1JAw4hnmhG6i3FM6CZL+gdHjHoZqMDYn6mQXmbIyrEOCJ3q0Pb4cwOW69pMd5WjlqlNJhHtYzU8T6oJFx8mB2OH6f7NvW42mLfwkEFv+HlYjSQvNUleGEgQ1IfMesNINnwff+5ECcauM/Vz6OxSCfoJgOwYF0DSzgY8oJHpiDgC+khVNOeN2KeulEmqewKxPK+KN6L3Cqsm1lJMXe7FJTdI0DwpkFDbKtUuUQ7NCIaGggbNyeKdWXXMMW7K/gy1sIp4N1FboQaJHYyCeCeOdsuso9ajH6a+VDAwNl7CRJEc7XAW47iyQV/LdYnWvdF5fof/hdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Near the end of test_memcg_protection(), reclaim_until() is called
to reduce memory.current of children[0] to 10M. It was found that
with larger page size (e.g. 64k) the various memory cgroups in
test_memcg_protection() would deviate further from the expected values
especially for the test_memcg_low test. As a result, children[0] might
have reached the target already without reclamation. The will cause the
reclaim_until() function to report failure as no reclamation is needed.

Avoid this unexpected failure by skipping the reclaim_until() call if
memory.current of children[0] has already reached the target size for
kernel with non-4k page size.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 3832ded1e47b..5336be5ed2f5 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -490,6 +490,7 @@ static int test_memcg_protection(const char *root, bool min)
 	long current;
 	int i, attempts;
 	int fd;
+	bool do_reclaim;
 
 	fd = get_temp_fd();
 	if (fd < 0)
@@ -602,7 +603,15 @@ static int test_memcg_protection(const char *root, bool min)
 				       9 + (min ? 0 : 6) * pscale_factor))
 		goto cleanup;
 
-	if (!reclaim_until(children[0], MB(10)))
+	/*
+	 * With larger page size, it is possible that memory.current of
+	 * children[0] is close to 10M. Skip the reclaim_until() call if
+	 * that is the case.
+	 */
+	current = cg_read_long(children[0], "memory.current");
+	do_reclaim = (page_size == KB(4)) ||
+		     ((current > MB(10)) && !values_close(current, MB(10), 3));
+	if (do_reclaim && !reclaim_until(children[0], MB(10)))
 		goto cleanup;
 
 	if (min) {
-- 
2.53.0


