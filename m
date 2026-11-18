Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3CA606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zfz7cacu
Received: by kanga.kvack.org (Postfix)
	id AC1926B05D6; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A719B6B05D7; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9126D6B05D8; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 633BD6B05D6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB145A7FF7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:42 +0000 (UTC)
X-FDA: 85446641364.06.E697B4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A8DE40004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zfz7cacu;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968561;
	b=MiS4RpA1q9bW2DFCBHTGuahDZvZounYdMYSYenACC1ZRysZ1WNHLUCRJiH2KtBNYs2UYhX
	DV2cbt/0uZOCCCeRZTs0NgG9DDW6GDSl0Hr3/yhBF3nTpxmrFcgqBo2hwBaGtuGttmobBy
	P+PIcvvy2fy9iibn1DtndHvB5QJ4P50=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zfz7cacu;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvjOO/+bldLi0/nuMY9P6FGGyFYE4cHne1cw3VHENC8=;
	b=zSH96GWIiJedCJZFQ6S7NFlVkQjtqu4xM2KC1OKn4PPsJu7WuEngvKT4+P9FGq75Y2M54R
	TbHF/15Y0EuVVVhDP4Fg6UyWEDPQ2iZYP6q9ek/mGfuaCkUN90v4+Yao31N3vXlFZ+TKEC
	ywIOXQrqtITiWoGVl+nYM0ESojwgc0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F8FA61F3D;
	Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA0D1F000D4;
	Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968561;
	bh=NvjOO/+bldLi0/nuMY9P6FGGyFYE4cHne1cw3VHENC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zfz7cacux/v5GdYH1AuV6xtxi/eRrHARePwugEIDfZSDLDpj/enac1aQqaJafBda5
	 I815yBy+XZYzF7Bm0GPqdjg6UCLqTztBosnhIkesIXcZlOxJ5giq4MbuPyuSxMAo0C
	 Kjcxq09uScbcYQ+E40JMTGMO4Q6WJCU9/rzonAWKI2AZD22/Kx+8X/j6mpnp+Tw74f
	 tQpUTArGQ6UxJIBBM6kJyH6Ir8Oq5UxOfnmmrWq2mbK8PBkSgho+tlzGMUPM4x3Cu6
	 mazWRooGZ6V/e4GtCAlCQzyXD2CB7nvVkZk0xTkGT0mdKGHSv67YckNi880FIe4hIp
	 WYcR6IRmVLeWQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 25/27] Docs/mm/damon/design: update for user report support
Date: Tue, 17 Nov 2026 18:22:20 -0800
Message-ID: <20261118022225.100659-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A8DE40004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 936tbwdeqk9tz7bp5k4xzwe1mktzz5u7
X-Rspam-User: 
X-HE-Tag: 1794968561-342936
X-HE-Meta: U2FsdGVkX19Jq9YoRHMr5ZzMiH3hOHXQ+2SuGtqkV2et+YXZSfmSpFYcqorSlFDoOjdKBiHQAaERFQMW95B6AwsXRQpxUfMCtahjnOKPd0AEwdR3gvboBjF1o7ZMHo1Qi9U9AK4KcdjU0fYoqxIMvlCvpS5cVst4hpEUzuIkfysz+p9V/JAHyYTY0vkAehuTr4pJosDZGKMBoC/IbL95LYh2quuhZcs+Bmnszs9pEu+9hUGAJ1XYRhuWBdLkqjfuiHL8b4BpuUSmY2NV3xocvrYM46hMCcP0htY//3E1t6KNDehJ/yembGHZOW5nTFeLB0kUKW3jSLsgAPTAtSu0inkvTMsdOokYzUZBsG3UDtQhWG+VM+ZGZrTfm2f2ol6/ng++dJ1nV1JoqcziNpz8pnZX5a5dtmFBkP9DpARqXrkiRhjmtwdWPGoDBfmaYJ0g4Ihzyb3OFgGVFTdrmqQDF/VBLMq+A9wtHPoNMBbz/KMC4LZYI2/gmi6iYkX5fT4oOSVUZQ77MjomWBqjchNpxsmv0166tyup0/XHidYK7R0L7Rre3xIFvcsg7fAkUNsK99AzV+Vr9dqYrcLGWfHQV3Q54+NiRYVvniMBF5tcTEVSzaW5WbcaALIAZrQkUuHk6ekDWyccz8IuPChel9U6KZXLTvcfX+fe/Fg3aPiSmJuntsEsO0gVloWnTZF+DraOo9cVzKCYBax2jcRu0aDJHOtXhCSfG0w7G1fh9t5+3x/nd9oXalMichpxKyLrh+Fwf/HXNa0NZz5snVtPru209JDEniClbbuuaQAXzVe/mMzdkQZKId/HPXgqkkX8bwu87t+4zaVB4qlDDrPl7sSiXEobU50tjFd6WPi4UUAmzfDpOVsaVW4GM7NeKQ3Cul3BzPMT8MQpqCWZkr/99K4xlKboEC5E1XokZDqUJMo57RZ9PuaA6/VAV3On9SZ01fBiDWKyzNL/u3TvFpte6/V
 17i7psUK
 mef6+TGPImDzqF8PYKxx+PzQEfSzVJ2hY96a0xhPttGLd0+7hvCdV+O8TcxZsmrkXtjCgS5EW8uOy4rU5AIQXTKVTLswkfbv+uCr9s26qd6b7BR5hXSDLMOCcn3MEmibMAPmoD7acT96AQBwEXWXuaz70NNXtIWCvoZx7x/yfazuf9iWFmSH4UuAFlBUfWL2LEY/K7EavApZDsXvGRc5y2yyry2SXrvNOE5oa/x9vo8oxk8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly aded user_report type data
attribute reports.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 31ca623385718..39b508bc572c3 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -382,12 +382,25 @@ can generate and submit reports of the given type.  The generations and
 submissions could be done automatically by the kernel or manually by the user,
 depending on the type of the report.
 
-For now, no report type is supported.
+Below report types are supported.
+
+- ``user_report``: User-provided report.  To use this, the user should set the
+  address range of the memory to report for.  This type of report is not
+  automatically generated and submitted to DAMON.  The user should manually
+  generate and submit each report using the interface.
 
 The data attribute probe supports the reports.  The probes can be configured to
 hit for a given memory region if a specific type of valid reports that are
 associated with the probing memory exist in the reports queue.
 
+For example, users can run DAMON in the classical page table accessed bits
+based access monitoring.  In addition to that, users could find hot data that
+might not be able to found by DAMON.  DAMON might not able to find that due to
+limitations in page table accessed bits or its overhead control mechanism.
+Users may be able to find that using their access to workload source code,
+experiment results or other tools.  Users can complement monitoring results by
+feeding the information as user reports.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

