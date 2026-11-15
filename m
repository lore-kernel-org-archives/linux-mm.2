Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B89606A33D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNde60AY
Received: by kanga.kvack.org (Postfix)
	id 37B226B05C7; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32BD96B05C8; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241E36B05C9; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF0D86B05C7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F3791A081F
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
X-FDA: 85438492860.30.46CE20B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D9BCF1C0007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNde60AY;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GO4qPmpKkLYaXtklU/IsiZJrq+Hr5ONxZjvupaws1z4=;
	b=Isnob1XMHO+QK8nVWvWdPSPYt/9exmwCsh8UrJ3KO8GlRiqrzyj9ZGaPnB5nwMcP10HnYS
	qE3XdJw4RhKqbtAmKYiUayw/XcPow0e+5ViO/2NjldnYJ9xj2t/GDr18Pa+u0+4WfjAf7a
	yJh/aEWsI8MlQef/4X3XDrN4p8f6ux4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774548;
	b=0gKZooVF7fXV6dbb/p6Fxbd9TH3Tk+K1qbOpKYLrGaQxpbxLTfMzH6Cj+T2u/NtYWioCNn
	qDHbMb9UY7D6stzTW+UC6chEjN13kpdNdg13qcIfbFzwdYI8emZCtr+aUzjw9/QH3ZMVZl
	e6aKyJt8kZhPnLJDCFY9u2sFYByGaUI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNde60AY;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8127C624CD;
	Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37641F000D0;
	Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774548;
	bh=GO4qPmpKkLYaXtklU/IsiZJrq+Hr5ONxZjvupaws1z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNde60AYsTywB6ie+feFYh/TvlfQ5LKFpsCBUi9JahDZIkzUtGieYnjtZWpoyDlQQ
	 5YD4DqtIJvBRjFKqUJERpUsNvUGFdzJRzZxiYFxi68JdZ/nmSs+5/QBcaoy5b146oS
	 0d4JlvSSwkU1nPvpEvTDKoJIAuwCnSsdZssu1WqABfm8FDVRzYC5y0T0S8jILVs0XB
	 SgyG4kxNkznS+PTUvcaeyFg5qghSkSjkSlB9yZx6sYM7OCbE/DBp3YsG6xKlCPjFLR
	 SGcrJwrDA/bcRiI3BfKY9Euu3MSuizwOE7dPes6nm4wdrhis7s3DCaBXE4TU88TdQe
	 nZyS2v+p1qNCw==
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
Subject: [RFC PATCH 17/27] Docs/mm/damon/design: update for report_made probe filter type
Date: Sun, 15 Nov 2026 12:28:35 -0800
Message-ID: <20261115202849.99134-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 8668oumoyckjb34s3u9f6qc9kmpyobzr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D9BCF1C0007
X-Rspam-User: 
X-HE-Tag: 1794774548-365821
X-HE-Meta: U2FsdGVkX1/yUF28xZRl5lsj/H25QPwn2i0NElNtsni0wsUSCPykaezD5eN88TpE6GMm/GTRXPKyn3+kguzc63/bP470UBnTiQEQ/XR2svw238DuTUxlTWNnzf/tSNGoK3aWB1jYyqjNc8UHbncrd9ZOyP/Cz6rKQSwmbWG8FIwWzOqPmZqoTOQbCJAzSrtp/NXhKZhz1bwLs9zgmcEApesv3nQfIHCCU6Yypzn5xr3TtzF82vGOP8FxHrwIb+vroKvR4u3dWMB2oslPXR0qahrG0tBkunJGRpM31Ng4yClaY9Oa9dmpEp02cEyUxFIbDgZtpzrX5Ofnqx83Q+EmLhIzjtq0anJYjyMocbiBTd8AnhFzhCibLTvsEpB31aPMf1zdXYt/l0IJb883+a/ae1tIO3BZiMm47eLWSokeh7y/2ecREiAmkTBfiX0rS2VasycihT8WPrrrhLaAR4ywCnRixbTJN7UUVabNofHAUUbRnyYvZLlIxJK941CBwAs+kNSJFteMPnMoaxY4AMob5ZXH7Yo1qMrid5uMt7HOS5kRGbxLjYP0AO8m4CaSHR6CDVrpb+Xa0F7hdHfkyJNEkYgiloasP18AOfNLS5JQqHk+M/p5IopwwgSMVzN0LnpJop54nsnrHEY9TZJuMJXIAMORCSf0k6/9KFwIFRzPpjLc9L0sTrGpHt2L0EuIVO7BuNBPZXrF1fZoXwTdJDDgUZkdrqfnw6hM6SgcFYRAvC8MfOget3+vYVi3YiOJX2as0RGsoPYQdyAQg+PLW2X3Po4uJ1OC98tgFwkSdiRjk+V5ekpYbcPXwaMuiYbHgGdZglvs+AS73IRVjujbmJtYrs9VyooeLheQHDNndGDY1v+yzBlkwAO5hbL+JmsItkaW9r/oaCmLTGrBBlaXt30qeeRAIWNgca/5oX+hdbwblW8Sj478NhZ3A3RN12CqCiT2rvSaIOjn1aE0tg+wHpF
 crrov9co
 aNdJ+ry8UcT+OrFoKDRCiGNj6xayxgj+vsCeDcQ5HHka60zUw0wnbiQ5/ZXs3OnVcm8lge/EwUbEvzLwJg3N4h3CUQSdgUjeft3pPo2IE6h704PZaDdhj4OnPdC02xY27oBARQfkWSAcrJyq1W3Kt43nTOYQXEmG+CvO8b4sfEvWsLjBvfcKn8x8s7kS4dSpAhsQQp6x3kdJfzAjZfb1kNqGuyxS3vm3PUCfIRZcwxcjv4gp3SbiRQKtNofkePVwdCQePEiMjrncCR3MAuBfSqBMgAhMAMK4i2Nfm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added data attribute report
existence type probe filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e0eb53d7694f7..68cd80e2788cd 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -303,6 +303,8 @@ filter types.  Currently below filter types are supported.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
 - ``active``: Same to that for DAMOS filters.
+- ``report_made``: Matches if a :ref:`report <damon_design_attr_reporting>` for
+  the memory is made in last sampling interval.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -382,6 +384,10 @@ depending on the type of the report.
 
 For now, no report type is supported.
 
+The data attribute probe supports the reports.  The probes can be configured to
+hit for a given memory region if a specific type of valid reports that are
+associated with the probing memory exist in the reports queue.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

