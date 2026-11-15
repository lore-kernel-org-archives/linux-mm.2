Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CBF606A33A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TYkoSKuW
Received: by kanga.kvack.org (Postfix)
	id ADA906B05C8; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6196B05CD; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F5C6B05CB; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2706B05C9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAA58160822
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
X-FDA: 85438492860.29.27A1911
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3AEBD40003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYkoSKuW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4c30zMvWlF/HAu21CDBSrVZTsdtRg90kDV5GhwCdMQ=;
	b=oSkPtq59UACLVohT3VqYOQm7VUTEYHdGWMrJRf55a3I+/J7MiGi3hRuO9f0RgW6DnP+1mk
	AgO7GplPiRCwMrd0OYvSXfX2nydYumiWrn0EJD49OjPZor0UjQQr4lAsbZf4RQ315lNCoV
	xhoUiH4tyDsUgbQ+oWYIa7bdLjm+wrw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYkoSKuW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774549;
	b=vmRbJMnzmKn9he91O8Mq177PODKs0KYHbJPuckkRXm9kpQTkUoB7sQoV3CYe4bPw5U07Pk
	RbZXLrC8pz9tmv76PXXd+EeIuz5/UEA7yMik57DvriM0aFcC5AOv/Fczyi24AxFHsCZaLk
	NMPecUfpkgNcfOwSA9OXpNi3puKOTQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0933945B1E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AFC1F0092F;
	Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774548;
	bh=R4c30zMvWlF/HAu21CDBSrVZTsdtRg90kDV5GhwCdMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYkoSKuWfQsNuWi/eULR3JcxU3gdigMHHsHn7j6bwN4bOEIk61BwtVIwGSymSTMzG
	 u/AD5pWuTZX3JM0+maLO8ATwa+b4ik6pfB4nxZXOtabiRu9AF+kXkrLlFXv842GxyJ
	 PViaOWyRnUijD2uNU/zBC/9DAj9fV72OEu+jsJLAhoiiOU5Gt+GK7+XJhXO+VDXx0h
	 aSnERvsstocaZzq/1S0uFSsXk5nO1kRchFqyRiLONy5dTQgGJP9liDtmuViR8eabnM
	 Z6kA+7vRRaEowugbShKIbbmCdlQ5omxQWC0H7SYUvqV5BD78DKdpOXlug8W/m+DJiE
	 PVxiB+sHeR6ww==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 19/27] Docs/ABI/damon: update for REPORT_MADE probe filter
Date: Sun, 15 Nov 2026 12:28:37 -0800
Message-ID: <20261115202849.99134-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AEBD40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4fbh4apggar3me3s96yzgpcm64jz7sgh
X-HE-Tag: 1794774549-211224
X-HE-Meta: U2FsdGVkX190Cu3E/QmkEcck4oUumLx/h0+LEmTebdEAcypSAx+LfKIgHewFntFrq0xghTMLOLHW5DKLdC48iGhyYAqeb76umHpy1TFK5ZpUFeEn+paFEb6Af41L/NVLk2BtGC7CMpAPQ1ai/jyiXEGJJKmNUUS2OU8Uf8LYYJPB9vURUjBpx/sqJBR0fHehz6WjKkkL+pt3hRVb4o39KmLWJz0aTaJWSUuxIhR+7aUmQi/A++II2JMVXCc6QjVV0k6h+Np0PcHuV+7rWtJd/y3lFj7P0g5sKxQrgDOuiiIFyHDSp4Ph7uB5XNXc9fcbZlu0uCwyX0aCj7Qkk6fdjJIeSQxwDk4PA4Wh+wFQVZ6bW8y5+Qc1cPHf64TU1JdTtqpeI634BVSx1VIPM2B5dmbHjkQIgoINii9hcUvr9U9qu7FJLzGybUfOIsz7yiNqQs271FL45JZNsjJ15pKexodPXRgDf98LhqI9/zVL+1pUvfi23Hegb352T2xndZay0aNK2m9aPhoOw63UprCEphcuAFAgHWSlkYDeNk59QjY1BNr4Sikoo0I8Ym+L03DTEARFzgP/ScS6JHDoKe6DLBr7fNVcXdNWNniWNqkX5CK3W64bKRxmEXSvrTGjo9NLGs8SNbjgGxLhgLTQM0X72Ik+pjdoYLFAdC/180Ow8yj+uAcaRgy/1jxeXF13wQbhIYjM55FOKTAn32n/qJcirNG+GRtXBzb0SgI/Mhynllb6Mwb5wtV5nlcRqQ3l4uTE1dvLTqqE23RxWP1tipsxbvDDtGzJQQ1cJ3VBV5ZfG4LWuOw0yqzea/gZNHswjMPKKgsq4++f/JPU0ztw1X3uqtDLmEEsVSiQqI42iZO3JpinzNuvadDkS105MNEjO/qO3QECkokE6nTwndLFgR8FJPLWzCEufAkzOcv2reholLmRH0PJHHZSBy6PqSn8vUYMaW3G79gdkgCof88xSQh
 wMxN38wQ
 V3bE5xqIZcVtqj8vesHgJUHqUTKnJUKCUb4+Mjd/PAr/IzA3qmRDrLp5zWWZelqhnCu0Lshl74gyRR7IvX5sIWXZDxXfRw9ksDI/CXrBVD9gvtYOQKP+tH3VDOhoSlHSZsL/IECi9EwFciVgUkao3hi3wEAgs0Gaoal+qFkuQ1F+OEobk9qBQwnHz3TGXKxlsO3jRv3rJzueQq8uq+3p1pJjQBQ1/kRs+TyhW/V+mfJU1c3H4qhj5ADU/yWWgzYI4iHDKjdB4wYL2XyrK1VoabR/aUbkFY0+Ter4EDAvjebQdg5f+cTBWviN/rxYoMxGKxOnu5KSA+eeogYuHo7yMufTYVmAlqkuqv7mY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added REPORT_MADE type probe
filter support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index c9f718f126c70..e558dd4212f2c 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -233,6 +233,13 @@ Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		hitting the probe for the memory that satisfies the 'type' and
 		the 'matching' of the directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/filter_report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'report_made' is written to the 'type' file, writing to and
+		reading from this file sets and gets the 'report_type' of the
+		reports that this filter is working for.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

