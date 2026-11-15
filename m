Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58764606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RXpLkgB1
Received: by kanga.kvack.org (Postfix)
	id 7738C6B05CE; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A816B05CF; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4D96B05D2; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3796D6B05CE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4327160829
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:12 +0000 (UTC)
X-FDA: 85438492944.23.3EB4FCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 29C3240003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXpLkgB1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m32SW2Gde9+gzbvdZVnXzz0kef4/aUNp9r/u29SR630=;
	b=lPyoDoHiNpEgxvLFzlbsKc+UUWrMCqrmQC6p9GP+L9q3n0w9b23T/rO0MJCN0btoGlsiDN
	bKKWXnd8gpVZfNUXtXtEDwr5NqB9AR5tste91mTrZQaLXQEi2YSuGwuS5IDofQ7Oy0FkgI
	IknKII24Xm3JU5jCshV1Y1SEp37TZn4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXpLkgB1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774551;
	b=VtNXSc7WckCEGCWs8GpCu+DLJCLqzX+YWEQNhCLVnGTrM/dZFamfU5LgoFWuDirDlBxxmQ
	/iQIBtc+r/9dSm1GOyEmXoCsD/KGBCAi/zzPwAsfPeyRd+ym0zZuZ7zrq+mOoFk+GMDtMG
	C52q2Ff+jNPa293tYrzGTRtDs/YRu6o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC7DC45B1E;
	Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992571F000C9;
	Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774550;
	bh=m32SW2Gde9+gzbvdZVnXzz0kef4/aUNp9r/u29SR630=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXpLkgB1dtmnhdNpwrfTlCXKs0BJA24fyiWuoBW3FDNWaELoId5zB21+s+3ggKc0D
	 UhF/uCep+xw0+VdBPGt2TCNCjo2nz0qjeKpadbh0P4NzaA7xqqffNSYoxrSCTqLPJc
	 tlpWLEqcBcoax5uoRq73xzvmPy3oSbLgSJLIkRr9dQFpsPxfhka7BSClk0cV7uMiFG
	 iN7UF8+vr1LWfnmWKHQL37YJY9OUC3fU1GYxoyHEVVs/x4E3V+POkyqpYaxZcyZVEv
	 Vgng8evr/daFU2Mkh54152pSaKFlIYTt6/vxj17AmKBfK+A3Iu5wJe24cOc0+NGOXt
	 BNIax5xAW60+A==
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
Subject: [RFC PATCH 25/27] Docs/mm/damon/design: update for user report support
Date: Sun, 15 Nov 2026 12:28:43 -0800
Message-ID: <20261115202849.99134-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29C3240003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ch863rfyg1h5mabzktecngeisarq3mid
X-HE-Tag: 1794774551-528937
X-HE-Meta: U2FsdGVkX19Wdwkc6E0ko+RbqzbPy/+/L9MpqzrvVkbAHw9T/71NjJxak0x4PPmeg8iEX79auW/0RuRTWl0ChDNRSfprSpTOfv9YMMYbTM50kIVOkggL9PtjTXW5eL3YPd5KNSDRZinKh4uDKtotjiEhFm4Q8u9+r3XMvqDvDLxp/czguQ9b4LKkwcRCNmo3eNbNTgprqocojamxdcByjtx03B/lpkDgJF87JYSRjpyJqVxfdhnbum16q+XOBSYWIqH/X4Kt2dNE1gddiqOSA/Ggj16QPNRsjiBGYz/JacC6XB0jV3bk5317TfaxkvPNTmLXGfd1Aevfq6r2DFXBDXki9007lkJSUS0kBO6YJNraY9usZCyjvLlEaCDwBJeptzrFFSI3buRNJQuaJFptYBGxoY0NS9caKWGa5+a0FdFcNZvhoXDo4fVss43GfcteFNahIlYdRihFRtmym6x/XkQHcdBQfgvv8Cqlm1KYa4FRVNgoirs+MB2cuGYKdtyLoOonQR5whCCUrjINu0p5WjI03rnTGu+HbZqx7UtseLNnQ733fKAGt2MQzkivAs9DdZqINe/PL5qaesUKnDiR7Om6FnwoC8GBTWTnMn3EKQpvaVn0D4zz4iczpgymL433gV7HzRA/CTIkDjLuriMzAt4JYvDWZcLjXpDk9Nl1kemNhoZ75pXAKEkDFz8Tr4ZiRP5td3e2uqlXWZjRbg2r6LQqF/eG5bNEhuTkqCQ/v74S74i8OJ4ef5bsLqWTqh3yVzWILGrgugHGWMTcxTDLER6lKb11EbU8ivIebo9AQ0Zr26+gVHEpu6aNAbAjtmqjcZnvk1gcs2dlikRICm8rFf5Br0NTSuqSpnoeX4RTsSkX7+q46OvvEbqbxyGiJ3Tim+HV4m2rAMBTIiSqFaNIMIQjV9iLd0ZqCdYGTHJcLJkEvxcdfn+C9yYFiSKuARzUSiEL63jOqbGm1N5AX1k
 fwoIagNF
 OC66e3B4Zt3JSI9IB8aNf6wl1EkmG+knVW+SHRlCXrnWvYuZDUwUwaxjUGPqdc6qbt6mcK/MVDzM+8Bi/6apGHzEhnBGqhuTT+AtmErBxzqzAOHrcvGzCNXvRKY/lInzRSXI8fx6I6H2rYpER9WUeFH/EmrK3IYVGaYOQUG25/AzvQFYOznaY1AaAbpf8+8G+corbF4+5DK/dnJZIWEX8sPgCU8gVdlqpnEY4WeMIMBuDgG0=
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
index 68cd80e2788cd..3f6779cd6ed48 100644
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

