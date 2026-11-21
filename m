Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BEFB606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mPx9/RWm
Received: by kanga.kvack.org (Postfix)
	id D94E96B05CA; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D445A6B05CB; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD7F6B05CC; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6636B05CA
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D8B1140278
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:32 +0000 (UTC)
X-FDA: 85460344704.28.9C54C0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60DA4140009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mPx9/RWm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294830;
	b=KOC2FKLxCW7KWTmgY3VmPqCmok2aW0Bu1vwN80BUpVzWID4bSyhH0enknSgkXK+U4wKXTx
	ZvHY+gIPJT9NnQpU7s0bZz+/AmGG6wJjRiBB0sDTsdIT9U2fAfIn2NNlBGyN7IdvO9jqDW
	buQOmXJRU05Fs1iuuWIp1OjmrqbsmsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvjOO/+bldLi0/nuMY9P6FGGyFYE4cHne1cw3VHENC8=;
	b=yyPe1Ht+OVbiDmis79+ZZihnJBYmQrkHY4Ea/XOanSbOgqTxdT/wuYhuHtPtpWcBG4AALh
	M4l8SOidi2V/7S9Fa3cY8IagJHFgqHkF65+ecYXpus3DNoXP7gZv2pchmk7X3XgFqIUY0k
	wvqtQTxbos+/rXZkazndSnkUGL6KHk4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mPx9/RWm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33CBF6185C;
	Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AA21F000C0;
	Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294829;
	bh=NvjOO/+bldLi0/nuMY9P6FGGyFYE4cHne1cw3VHENC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPx9/RWm3lssxvLRnk3HnUv0IEIAeVv0nkVtBDbktL2sHmJ3dRpkkpqPzo5u/6+x9
	 fK5aKX4qejxiql9Vrz764KW5Kp51YUJeQwRd/iwM5HyZeAIulJ+XhqZnVidk4OuWQU
	 hQAp8lBrKQcsWf3KpwXZyZgCjGInYKG1J0mPTjkpZFzmiJoi5cyV2DoyVVeZjNxG0S
	 oDYmPhP1sFDR/zOiQIl/mF4+tT20T0HYEP+5IbYwmG4QGxTI42S+SxC7C0Q3Ria6W+
	 S0+NWmhQRy2Fz9UMh/QnZj0UV4HkAWPO5mELvzRdDZFHvRr1nTm0HDvF7xNebyw75W
	 Rs9mJV1wFf4Ig==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 25/27] Docs/mm/damon/design: update for user report support
Date: Sat, 21 Nov 2026 13:00:09 -0800
Message-ID: <20261121210013.130397-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 60DA4140009
X-Stat-Signature: igkctj5pt679b5ei6hjok3cjkapi55oh
X-HE-Tag: 1795294830-91143
X-HE-Meta: U2FsdGVkX1+92NfXBPq23y3L0Cjbe3nYTEYQs5PBQ+iEGPYUu4aZdj1Z7gMzM3pj8v9nZCMdeGDmlWWn8vQOicb4PRC6UjfufDabSEvA3t9uueNRFIlWM36YMZ15+wCyWHpd7JMUEjdKXOpqiPPiLXlZcZPsE4z7F/n4WN+I1LwaRzikaLdSneET25NL9iOxnd/xVb75zc3ZVK1Rvb6Zx5RfABa4QztyB4cBBKFUhay6GeeK3diFygjEVqYtkSJp4mkoBehyUnhdHniqE46uU2quf9DnlgTBLjXiiSCAEB73lv8PIpqzkIAws226wZ8AAWKAMFZ+LWySSzVNY/fGxDV3o16aEGT2ufk/63YsfbNhtlWq6kMVLUrkxoVTVQlUSdFDgehkobgXpDqQ7X8Cd34pV+28vX/vznQK+pIWeMpJp2+hIXF4bvRKdzZdiNIErpTLpyRhiVWcQa4tt2W0Dgt1j0uRcfkZ314eto3A2GgWOdn2AO2Z/Qa2qrNl7y6lb+l0p59YnzJE4V/0M4HmxZuwDsJnzQ92SdlAT2Mu5szpNQ7d3yLHbeER8uh5eiUtboeRSSTIBG2a/IRohm1a0z5F9brYx+bSB5Bodu4dLQuN7KzdVEFEGoT6oBf/dgYSopWwYm62BGKiRUxkvtBdhqrilgqw31j6cXKtp1wyZfl+Lx+SQ1+FFWZpPZk9q1/yVfzv5Jpkk/jOJn6/ORjPOzJgEzp0TM9mECFe5B6Br2oKm7o9jVNlunOAXCs1yb90dRgBG+G4C5oOqVaci4ewVhCBgvMm3Zmuv8+c9fgVSphkCRS4ElRmaXk/svXCaxkP4Qhla2oxPBAfU7ix3U/1MOHxVO8OtzWiI9A4pT387Ps1fdLdo6ZuTSe3lnsjoscObbRfZUUCjDD/5nT7mYKpoA0RTSnwWWljJ7JrKy/3Vg8T0vidLX3SybpEGjAglRLjDFZqy0zawyK2qE+RqVc
 gso7Loja
 vQPC0ZT/t8+5QTsEPfA+EH3Uk5fXNZXrj9VxgjmQMu453HqOoF7Q7dd6GsssjkIdCjMjrKcHgwEU3YAOTNjCIs2VzSfHILVhLvz1K7Ghf54BPtrosdxlRFnUPzKi64ZJ5Q3E3vKGS/qI11PMNEuAP6mdn8xfxgE2Ioh03SGMgw8vFsVtdb7slHZ5rpSRXlmBjJwCPEw2OFPpAtbbYlGBSAk4HCkCU1WV0YcWyPDi7NlfA6XppfIAM0XtrsxTrFr9sXHvW2R9C+AlNhi+yTE1rtKiwoY2yD8FVKWHhioZj8vaprmHkuPQPk9Uc2qobuUQkjPPd0AXap9dMQV1TVNisznyvFw67KJFkRjMLXXpOVLijODL29R83FNIww8Cml5sX+5ShRo6D1aBjqj0z2wV11/newamDAoKd+HPi4+ewZqFTMDSW+DENqipvIWLi0SlRTsNDad6beIttosg=
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

