Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F3CC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2536B0095; Thu, 20 Aug 2026 03:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88EB6B0098; Thu, 20 Aug 2026 03:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5BC6B009D; Thu, 20 Aug 2026 03:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B00CA6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:10:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23FD0C037E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:10:15 +0000 (UTC)
X-FDA: 85120773990.03.44DD3C9
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3FB6C0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:10:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LIQ35nAs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787209813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hQqFVUCRMzsebtGyK0iuZYvf2IcU+yw+QCoVCPy9pXs=;
	b=N3PL3aG8wXRJAKdSvq7K+LVHty+7+fSeQYSnRLtgko7zn9iv+nWFGBZ/0tyhiu6pM3VZ/w
	YlJ1vTYI8PfiNU/O4ENVGHZbm5FokzW8nITZO9djF3yWRGpXqnGooRVDibJlFcF3K09Ou5
	/y619PgGE5Rqwr/97r5BoVAgzN+6EO0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LIQ35nAs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787209813;
	b=jzGIbK7hTBK7LL2koCZCwz4ALTRI+t28PFEx0sLIzbi9EwoNhmgpPou82ecb2QlVHrSwmh
	2+Tz7sd5NhTttIck2XDcNHrp8znIuhcHH27ygiOU+5HQH0ys9dhUGx/7S7l3P+4zogFwMK
	XN/iREkuVuKI68C/BraVLIBjdxrSMuo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2+3QA95E2Qu2z4Bb6C3P8E4Hs/HGV5s2I/yaYEntkPM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787209808; v=1; x=1787814608;
 b=LIQ35nAsg6QJauv+pYa4RnQF6Ym2wlWvjOYeLoznppA0uVJXFftwqfpwq2+vet7yMx0CffAO
 Op+lFbTnu67gjWChUDwyWQwYJtvBGAM7I3Ni9EMND2ezOF46q8JRztzR4/USjWCEl7flpoiXb7V
 UbKbUNIGqVY4ibbEcbbgYnUo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id f83ced2c4d3f1100;
	Thu, 20 Aug 2026 07:09:58 +0000
X-Mizu-Trace-ID: f83ced2c4d3f1100
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Thu, 20 Aug 2026 15:09:44 +0800
Message-ID: <20260820070944.31451-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A3FB6C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: r3cejsqykwk5t38feecftn3fcgjr9xia
X-HE-Tag: 1787209811-677629
X-HE-Meta: U2FsdGVkX1+n+NCceE//6S0/IikI8w1Dj7bKkckY6u3+Mic69G1ARcG2iwfRqzn2JNMz5iK0vlvIPCianjRVMMWNajIXDCQpViF0VHKgetcC9xEl/4rC+hXJx3UYmAIgM2v3ZQ1s2rK9wqf+woL7D9YrZ92A9r1oYDqycav3kBUYSNYpi+1FZr8e7e2fG0ufBVQPmObc3ULUE9IruBGPIWXV3gKPPYGVmFExsjKsRUS2XoKvzmzav0P94doW3Q9txeSZ8ZWE7VNhcVBAEsUp9K3cxKlIJH5fRRhoFIov5n9La0z/8BvjB8UkVd6njuWhll6iapKl/BoC3YAi/Rp014vsyL6fJgiaxZEUsZy1VvC2ykRDulYxwrfpfC3ujFHo7P0yb0ogbO2XAXvzVLMcOHv3yxwD7F7iKFvv6mOt89NFJ0ekAyYuZ4Iq2S5RLjQBE8VJNRq+16chtCsqHHx7jaDydzmKW4hDAUDMGYG6s/K8//QeS5yCIapRTFvsnOxka2/HGHdtG7UctoZEpJSOAYiIn8XZeecWj3V7WR0VQgSndFhk/IJdSyUN6Edggp1R/t5xTtPXo1K1zI7UXA5TbDPrMER1rbnYT+x/Qryyn5g1xVA5EhiVDoeC/6sSDzZvf6TDmoxst45e83j9LE+kSXMrBEkRa4f8IIBtY5JueFAoCjW2+uiEH08vcOHxKcFfXhwrgwARe1tUGdR84y1mYOe4wlKZRSA5FkQZr64KLPkDh3QZOseR0Y9JzGz1kry7hu7632RtwyJ4klLiK+6ZxOoTlaHbBsvCNBtheuOtOd+M02eicnWxXGd1frvwyRhpisHt6l/cemblxpRASisN+6fWRbzqqmIG2xQ18v0VJXXCqRBV2iEzmItNBXb41OgvUigluTCWag1N1KRhtFhTtNGci1APsys7mjCRmI8QGHccj4CWl5DYvVpkxIJ4sby4vJLM4JOsBqhIoaw8BdJ
 9U9sFCCx
 rTxmaPKgB7dk7QvGUJJ2ryMt2MhuzboMmSRFXyeU2hc53vPHDdxgzfdAPP3qgjpsg31J7VJ6k8IfkuI839Wan7/WRtSvkNxNWkQQJdLNAvUS6pDM9Yj102F6U1QNz9gotf4vrdsckLO+4PfgCRArIExxvkS3Fi6UWAuNYpsnEZF/Dzp6LnQW6xNg+1SoUWCFKseuKsz27r/zfwDiOBt9YQ+15zSimpvh04K7m1snX2/jPLRGPPAG+Ug5mqJ8zfQxXMKKGQgGsuRoBck8MNBJDWJKaYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

cg_run_in_subcgroups() discards its arg and always passes NULL to cg_run(),
turning the (void *)100 from test_kmem_dead_cgroups() into NULL so no
allocation occurs.

This makes test_kmem_dead_cgroups() falsely pass without exercising the
"dying cgroup with charged slab" scenario it intends to test.

Pass the arg through to cg_run() to fix this.

Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting tests")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 1db0ba1226b9..98e9f9f45ab9 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -145,7 +145,7 @@ static int cg_run_in_subcgroups(const char *parent,
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
-- 
2.54.0


