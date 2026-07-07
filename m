Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DADC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC106B00AC; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CC26B00B0; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A338D6B00B1; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB186B00AC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B3811C3441
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:28 +0000 (UTC)
X-FDA: 84961031736.24.BF435AB
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id 968ECC0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=ZKqK2tjQ;
	spf=pass (imf22.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRJcdc6HHIkHeY/WGZrtx/DJe85hcbtj03n74JS9UWs=;
	b=VzbOGrjYXQd9nqYrcs4UmLRA84etGCy30bFBPVMos6v5RlLUf8+Z9FxSjtjeWYUcgRKmsi
	WCPN6m8/BN7GKvggCQdihH9epKBiThMcO6x9RXvoTCEIweFiazFok38EQfde4/j6PHFEJG
	Luhfb7XN4f9OPzKbxCdlCLJh1gMfCLA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=ZKqK2tjQ;
	spf=pass (imf22.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406426;
	b=WfKHdDqzf8pNGxKKDB1TnGLYtTorGBqrkMT4ARa5vgSTCHKAvuYs/n91dK6gfVy2iSXgCM
	1mN/db/cTiKzXi+9c6HtK6c2EI3m/hvZupvvYKsMJRHCWDK+BkK2RnEMfbRSjihgntrFXR
	ewziDtZ+rPD+JauzQK9iRGZT/o8E9KQ=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=bRJcdc6HHIkHeY/WGZrtx/DJe85hcbtj03n74JS9UWs=;
	b=ZKqK2tjQmEwe/29Z8hEet9dB8iGhvES1aUoWiDViQEkvEClWjwpSOPeMPVHgIFhuu8i4TcdJC
	9IuZHuVC0UJ+ptPS3D+6rHgC2io8ZWaf5GxRsoHYUMfiE8FMdPm3ZTHa9raxOOwWs4Rx6tWwrYN
	2bbevAeaofj8lR127dnMjC8=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gvWnK2YFMzYly8W;
	Tue,  7 Jul 2026 14:40:21 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:21 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:20 +0800
From: tao <tao.wangtao@honor.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>,
	<ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
	<baoquan.he@linux.dev>, <nao.horiguchi@gmail.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <damon@lists.linux.dev>, <shakeel.butt@linux.dev>,
	<ryncsn@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>, tao <tao.wangtao@honor.com>
Subject: [RFC PATCH v2 13/13] mm: Enable CONFIG_ANON_VMA_FRACTAL by default
Date: Tue, 7 Jul 2026 14:33:08 +0800
Message-ID: <20260707063308.29176-14-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: y3ph34ggbixuixi64hnmx8bq4dfzjph7
X-Rspamd-Queue-Id: 968ECC0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783406425-919331
X-HE-Meta: U2FsdGVkX19E/cl8pregOq7RwvQlrpTJPnld8Q8i1n1vt0Vl/ZM1vJ6cz4UfeuxZKpcQIJ9PcZSnmwmhrXjTyWtewxP1I8WlH2zCr9vbPwVFJa+Ys2Oupm2JehgUCcmelFP2eK4ctdHB2R5axCVY58ECmynpfmlZ4W7eXConqJHPJ1kKOqGr83BXiEMwDn82LIiAwRi9NuU/4BvdvdbuM9aQBrIIE6Ndx0xmcMa+wObpUMn3z34owaeDFnm7nM4PLujR+ngCjRwd1PSCanDGkubCLHAe24/gGdAEUZtT4McqXe8MDnbfqxee5oLm5U0t6ITc9uRvORU6n4gSmLaHrUBIz+0vc5eEoyUqo7OyDtoe7WVjji2sIUEWUu0/buuTQBIWX7/9Eb/fFfCvtTcDO8cXgoptTAdyCtr2dZkDgeorM9YtIqskaa1cguQhyH4/ZQNI2tH+l5FMGn3UIZRqlvtbZM/6HvtratdFB6sR0bVuo2lrm02rQobm1Ay3D3wUNcY3s7P/Wa60qedfLcu6lbsZ3XZqQnrmlnYufPsN+1liqjevjIZoidEi3u8sXeky1xIu9twzLIJf9yMw75ycxVvcOeX9jgnU4Y2/t9DxV1QP6QiX14Z+rAsvIPqjdi9mHk8ts/qjECc56ogdJD1KIyh29ORZRFDXc5gK24sstrkaMOkLf8acp1kr+rKCd+1XsalzqKZbLyt6dX4b8nngTqXOZNNJwex7kZ+DmoOa8oH5YOVohYf9dU/aG9cCNcCBmaCPIH0DnTBslF0o+NaLxbw0JsINFp0OzP+1EdKSRxhnBb9L6I95vcmpSt9vN3rV2BzfdY1kGkXll6mQo2fIwk3kEEOy/esBauSVvWouP+bYhtoIvkCqyKwRLsrsTUG2VMFZClvGfzuhw0PwT6LjyjvbGJAYR4IhN4zmB3egLyonc+7nHhdGuWy6+NP7fns+fKvb9oK9mgKLr4Hwwu6
 0NNKOXUT
 4h0dfVr3vsMAfNsRE7vFiFSiKTeMlyoCxcpBZwAjnr6S2MOjkw6xzFYnmO3hc8i20khZ3Un2iWD73gf/gpkQ7c4W6H1NuUegWEaxq1QG5kz6fTo8pO1ScXPXQciXeE+cQOI0VvidY/acEa/ObeIOtYgvaX6c160jcBcUO+fmRo2CBJdLmbj5nX8OLrzuF0qZSJKdRozQpbZIFOH/lxvBI0RhRUNO39qB0HNiaE8LLlVj13Jvwdytag31EEfpFcjEHxMPbZ/WTpW3Qf+BxgoACWiRnFK6a2PaE+c5X6gZ+25I2HIpfHlhSIDU7mkJcHWbXH9Vn8BzjS3FaKvSXfF2180WMDlBXLlyMm9HjOHjDG1JAOi5Oazmo99XHVjk2KsII4VvTKZE2To/NOW2jFNu8Eq0lhVh6lwEumbaC20VntzwDIZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Everything is now in place to enable CONFIG_ANON_VMA_FRACTAL and
CONFIG_ANON_VMA_SHARED_SEMS for further testing.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 1b909819035d..9d4b81bbd4e1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1453,7 +1453,7 @@ config LOCK_MM_AND_FIND_VMA
 
 config ANON_VMA_FRACTAL
 	bool "anon_vma fractal list"
-	def_bool n
+	def_bool y
 	depends on MMU
 	help
 	  This option uses vma_rmap_base(vma) during rmap to compute the page
@@ -1481,7 +1481,7 @@ config ANON_VMA_FRACTAL
 
 config ANON_VMA_SHARED_SEMS
 	bool "anon_vma shared semaphores"
-	def_bool n
+	def_bool y
 	depends on ANON_VMA_FRACTAL
 	help
 	  As rmap operations rarely run concurrently, and fork/delete updates
-- 
2.17.1


