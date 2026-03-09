Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE66F4180C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A28F6B0005; Mon,  9 Mar 2026 12:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1735A6B008C; Mon,  9 Mar 2026 12:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADF46B0092; Mon,  9 Mar 2026 12:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF0296B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:03:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D0845745C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:03:02 +0000 (UTC)
X-FDA: 84526993404.05.35257C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52BB480004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:03:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UUNZkt0Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773072180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u4dkpXFG4aTyAb5XVO2UTWBuvIYgMqymSwley3GnlI8=;
	b=R/aTroACWHJHnqYqSlXsAGFxKLEAkJtDkeCmHiR12sJciyOkubBCrkWDsnKHwVaesIqPdC
	EwPpKbMAdTO8aVDdJZBLWtkNYyG/mRpVDidyyRH4P+dM7NobO+4xLtCo31xpW2Dz1R0yOv
	KHvcBzxx/EnD5e3FDjwHyrPHb/bCyKY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UUNZkt0Z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773072180; a=rsa-sha256;
	cv=none;
	b=5zHGNJ4FLuOr0f36eOE2af/5Y6satPjCqBeHRrI8JpVfBxH3s9PWJuyMR5I575cD+UPFFh
	u4iVEOT5TSdgaq7hmIFi47wlkT2az/eaiNY+Cgir2Kdpr7zdRjCdL9oeTgVOcjS/d+lILE
	NPexF8E+ZddNVWTn5LM03Kzwvm1NX5c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773072179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=u4dkpXFG4aTyAb5XVO2UTWBuvIYgMqymSwley3GnlI8=;
	b=UUNZkt0Z0Ygdf3zRxldVcPWoT8qftkmoJE0V4pegy7bBRoEfDuAqz1pwYUAXGZ+xE8O3Ld
	AzWC2fAodeBwXjO/pEBjnFaP/L1GULLyT3dKS3CxWdL7v2h0sprUpErxU4JlfiqzC2iTeO
	apICNab2PQGLxsgYbompco8GGIkmhtI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-B65hgm3aN2CjtyE_8CYC3A-1; Mon,
 09 Mar 2026 12:02:54 -0400
X-MC-Unique: B65hgm3aN2CjtyE_8CYC3A-1
X-Mimecast-MFC-AGG-ID: B65hgm3aN2CjtyE_8CYC3A_1773072172
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00B881955D48;
	Mon,  9 Mar 2026 16:02:29 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.81.138])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 285521955D71;
	Mon,  9 Mar 2026 16:02:25 +0000 (UTC)
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
Subject: [PATCH] selftest: memcg: Skp memcg_sock test if address family not supported
Date: Mon,  9 Mar 2026 12:02:05 -0400
Message-ID: <20260309160205.651754-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Pr3NPOS001WwHgvUtVlECaPTj8teT3g2kx9hkDDDf_w_1773072172
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52BB480004
X-Stat-Signature: ffxs4h3piyeq35xp91p5jjddc3jq6h73
X-Rspam-User: 
X-HE-Tag: 1773072180-449532
X-HE-Meta: U2FsdGVkX1+yovXv2losjkv7FrfbA261PcNOSsGMtmrs3Lgcf0FOJiVIei29+W1pKrlsv/2DGkb97MpxJ1O5r5nqoK4OITyGQLO5JmmqjisgEKPinrs3FsDKkORdJWkQgcIhLfTlbPUB6/frP3Ds8ueACyzq7lgmQIp3MsPRpSL8owdoM/nLZexBs0v+datvtEr5nEsjWZVD6sCGw2KvLoDRHG86osL9cWiC0/26TACIU5u7RAoTe5Ro1O/6oujAvKq2MlG2cXK1KWVg/1ZDDHT4ImSe5T6e8I4o6kYxrdBV4C3ruKsVU91I2B4P2MNyupgsjJLjjyR8r8PhHlija1hb0BnS4xh657WERlZ4qppGXLNAWUX97GjRaAdV/f+yQSPNB9LWG3DX2gJ8D9wh2X5YXytmg/tBAquniCRtTX074Ynkz1L1gCJ7k/ovfonKnhK5LcbVaa2osNxuIFigtoDjqS/+t4/8AF7k/mTqSa+ovsVTfKgEdDozk+yNyxvCKbojb5nnJJIZkn8i9B+0757t2h14gvuedSRHXOQZ7lNoZYU4Yw6qY56Ch7yz7AIvl8UJxP2zaZBHb0lDnmJMd6EgFUpiJ5Q+tZmywbFKM7OlyZa2ztsCQ64bSZL5WHeRmPZSYiXHtVbISAcBn8KC+7XZJH7RmgUwdT8rVuvnk5I6SG58/jIBu4TQUHjK6Jc1IJrwWb3VyqHDif1svd7J67WaMGjSeyLdD046Q0vxQGf2kxY3NnAgYT08ps3Zg2YY4B0pthEz+vgQ3asIS5rSPzJLsmDEWIeRI+4QwFQsr5XWp/kKjeWJeMX42ZpwuQEEv+SUmvI4sZ/VmoDMZl0GFjINFKEwMxdraZ2u79qWT21+py8PG/Ad7odxq5IbKRqlEm9E7xsO1LQPeiguVFbnmU6YHC+j3ZlZdZcDR0e5DDA4hrJuwMr7dHmh0PT2NniUrpW7aXGwigLOhI+tplW
 j91asFNr
 3rYqkoPxfu1krtOd0hc+K8WsCH/jjkAL12AKZaNIAVWvLBcVKAAXplWnXrlds0KTWuhB3VxQeCesxPj4iiwmpScRMMs1SGI2Zl9apHKwOruROfqWBF4qECXfHr0CozuWNmMh4g3fZ7a+1Ndmb44CbVs+HEuN/B/9q0XcM3YG9SIsbic7YfX4vgXIUvyo2EP+rpga9viIiCo5yr4hnInk0S8SehMvQEdzK0wczG7AlELw6G/Qa0e5kAfwvaIUv21rY9nEPBmf1JgIVBGdHHo3Y1uQKuPsEC8d4x16EEGqyPW6yX+RanGTkhWxnTmtv008rn5q4MEbPCXwTXCzsxzFD1KQfXfTOTbkYx8urnJH7yOYYOJnuNVCf7i6euMu3NNHakGDJQaVnEvczmEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems where IPv6 isn't enabled or not configured to support
SOCK_STREAM, the test_memcg_sock test always fails. The purpose
of the test_memcg_sock test is to verify that memory.stat.sock and
memory.current values are close. If the socket() call fails, there is
no way we can test that. I believe it is better to just skip the test
in this case instead of reporting a test failure hinting that there
may be something wrong with the memcg code.

Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for socket accounting")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 2fb096a2a9f9..3c13ef67fafb 100644
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
@@ -1414,6 +1417,9 @@ static int test_memcg_sock(const char *root)
 
 		if (!err)
 			break;
+		if (err == EAFNOSUPPORT)
+			/* Skip if address family not supported by protocol */
+			goto skip;
 		if (err != EADDRINUSE)
 			goto cleanup;
 
@@ -1460,6 +1466,9 @@ static int test_memcg_sock(const char *root)
 	free(memcg);
 
 	return ret;
+skip:
+	ret = KSFT_SKIP;
+	goto cleanup;
 }
 
 /*
-- 
2.53.0


