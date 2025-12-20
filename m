Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A689DE668B1
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD5D6B0098; Fri, 19 Dec 2025 23:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186886B0099; Fri, 19 Dec 2025 23:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097626B009B; Fri, 19 Dec 2025 23:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBB976B0098
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A432B9881
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:52 +0000 (UTC)
X-FDA: 84238531104.03.F4B0739
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id BAE33140006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P6tiDflu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204030; a=rsa-sha256;
	cv=none;
	b=WqUH1VfOU6+lbjfm2kOYPT3/wleD4USXHqMElLUZ6HOU0OKwCPGSD0FdEM8V2hx5CU25QA
	P312oBj9JMIrsdtYUs2IBLgPQHGAiI90kw8YuPLgc8HaFxPTVlegLSpYEnve/ILpxWtUwx
	PxWqnnzGHBThxNNPjzfqlO72iNSP97Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P6tiDflu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J25dvtxGtZzzFvAfUXeEFYiBBGrfnhtqGw9nh11r9u0=;
	b=aSF2id0PJukB23VnzRhu11Gmqb6ehB15zdVJlTns5qfbdn/hb9ibKpv0qt5ZcEWwFRoDp+
	XIUajwJtiLL/nptfPx/PRtvDdJ8cUCM3ORqVqLaDFno/J6w7w4OmECb951gA3eAt/kDWER
	hEGBFDugxrk11QzxLMkF6exBU4ORPOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766204024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J25dvtxGtZzzFvAfUXeEFYiBBGrfnhtqGw9nh11r9u0=;
	b=P6tiDfluQlmW/6/a6KD97hG0+XGOO2Mie8XtSgTQqFKw1271aIHMxpDKUAKKK3oCV+rzty
	ZNYSMOR3QGB4nmGgzdJGuOg/aADPC1xEq2pJeu1fL/rp+/iv4zzdTEZ6wDDO8gaoTFDWWF
	+BYUvv+r5Lya74vxd9zrfhEHDBytNwI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v2 7/7] MAINTAINERS: add an entry for MM BPF extensions
Date: Fri, 19 Dec 2025 20:12:50 -0800
Message-ID: <20251220041250.372179-8-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-1-roman.gushchin@linux.dev>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: BAE33140006
X-Rspamd-Server: rspam10
X-Stat-Signature: n86ppdad8754w6odz1ogq33f8wgjiadp
X-HE-Tag: 1766204030-517886
X-HE-Meta: U2FsdGVkX18FWjYQ7I1B+xqkwMoZnVtIfCqe2e2sQGjGx/m5zm6J1co3zVWO8JMPE5fkU+z9oB3Sp3p7yd3OYuIXV/9zrp0tZ/yTvVNeYcavZjw7qojQkJ1TAhJeF+DiMtBSJRVt2MSqPnMQIukFwBel8REaMaEWTKL6/I2l8gxvOtmMwiuJbd4Qsv6Ee2Mf/+18fTI3HNYkzk0GGkY+yenwFcIhenL6DC7uBtwfHA+oAcrzKeK5MW6GM+YnYbY6IPddrEvXfmnmz9LdNT2JpT/MLLAi5FtJD6xtyyj51dwu8D858TNzg0F8CJo08OCzid4KCQK8hX9h+YSqqXnv7rfhuNNjDO/1tH33JiEfDoaldk39ff6SdeYpKbBzHqkpvclmVNkRDgeo+LKW6SBG0bUyIUe59buMRnCqQ7E9nJxIKpabZTY9hCIhNhL1yR+CvDmzbAvJvG1TVJh7X4i58v7dqA95J8xJs2dElXeGoYHX6B2HuPW135HjoYmKYNMHheiPasRlPoagsMj5CGuWsFOdR3KG/dui2e3WnlHjsYDjODlEICg3+KnILBk7FULdzqj919jafPXRs0w+QIH93ys5xupvIKHSWe8xV6UTL2CGYzZ/ahMiyM3+Gj06ixIEjPFVCH03DFPBUuov55CcgkStZ6YFfBRnr2WKnZWdh9WTbzrXXjGC7X2HMt2+r0MQhxwlQPTBxuioYVHU02EuP1Xm8JoWAnaVWc+9Qxqnkd3jvd6/8aWIpc04mu+sELfwRv7j5f57G270Fxktc93dfsSKprcm4/b54zYzu0axI+0cpemEnnWKYJjKXzvGTRPQVWiDVXYmZhcL+UZE3NXnPBZn2bB5Kc8swKLbm4a9VNG21VPUocAqFK63cnEEnNKOIZcnNtkliemO0nOW4Xy/43OcorqVd6Wbwqy2aSHa1aBaYYHufwLOKSnCr8+ypK3kyM0cY8FuG6KVZlHEyGU
 P5wua2XY
 vu16ar7hYLKnQ0PnWpCC+FobECVyXzgU76BisNVWQtIoWHsLT7XWKGBWJ1MeWnuP65AmzGOYuXq3NLY0tQw3df3EYGCmHm/fkdGEMRtwoXH1iK2oHz79xIOCiT//WGIYrU0UPzJQG7+20rpFRPXs5H+zWVVQMtX02goRJB6hkln20LBJGwW98cEDFBTQlysidrSWiiY1rSoVbftIHISjK8Xxoyd0lBx+sQ4X7b4T3Q4K+JFxByQ8pbFhgYhKYFmYIA98PuJ5VTrbDMQtotyltMGyqyyroggI/q+3M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's create a separate entry for MM BPF extensions: these patches
often require an attention from both bpf and mm communities.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c0030e126fc8..59e3053e1122 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4798,6 +4798,13 @@ L:	bpf@vger.kernel.org
 S:	Maintained
 F:	tools/lib/bpf/
 
+BPF [MEMORY MANAGEMENT EXTENSIONS]
+M:	Roman Gushchin <roman.gushchin@linux.dev>
+L:	bpf@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/bpf_memcontrol.c
+
 BPF [MISC]
 L:	bpf@vger.kernel.org
 S:	Odd Fixes
-- 
2.52.0


