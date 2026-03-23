Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B14D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC626B0092; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A4B6B008A; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9FD6B008A; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDF36B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31087140771
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:46 +0000 (UTC)
X-FDA: 84578887092.22.55EDDD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A77D8100011
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VnSjFPvf;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbxQY3lvzqhT/iqaqHhhtJ4GZyPdebweaPj+BWQtC58=;
	b=iCLlnx9M/vmN9j5bnpxvj+Ic8cbugQ6nsFKUc+DtLsMsK2z3wTfIbvr77UigclctVm7GOT
	u7WT1iJL3NIz6C/xGw/dADUxlEBb6BUHfR+MkWSyGIwgBHY/SKnwPCBdrWCNkJnFCcWO40
	5OlptAs3twl3pDwFwM6/LCy3yrL2tFw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VnSjFPvf;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307744; a=rsa-sha256;
	cv=none;
	b=HZSHGGb23GkYgztTHnx6CP2afmLKVo2xF7A/zoEIT3lv+tyCFy2Eg/axm/2Juj+eOxbpA8
	gkdkswHWeufJYgcQFJKTt5rITj0uzuhp8ZMKp+gM7Xoa64cGDDQWI7LO9m0i0RXjvtBjuH
	RQXgZ9Yqr3zQK9YctZa4C9nxJyBLIZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D27F60132
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E003CC2BCB5;
	Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307744;
	bh=acrZio7SwTIWWe0wc5YY1SpE9hMTqgCgT01pPcG9A6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnSjFPvfAcvUf0/tfHq8Sc/28cxKBdedQrh8rBtsF+MA5bsuetvpBvO0qwRRvuycd
	 DdMT43ydffE7qwBl9caifEwjpI1i+5eKrjccPXHPG5H4N8RIbCLK0SbinAkSyov+Fb
	 851T063Zdho2vvyMHk52YbLCSfdJY026nE38oGZXYNRc66WWUp/PlwxIVH+AZfdiV/
	 mCrLfmUImz9LAGecK4HeuM+u8ce3fkoEV4g6VE4YKoSwrRu6AAbIEHjOFzI05BpyWl
	 ewFCo0N0HlqE6/nS9MF6uSXGeUl59sf4OqkiXfaGsBK04VydE6WHq7i18dKnXTj4Tx
	 xGVPwnUDrkZ4Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 05/10] Docs/ABI/damon: update for pause sysfs file
Date: Mon, 23 Mar 2026 16:15:30 -0700
Message-ID: <20260323231538.84452-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A77D8100011
X-Stat-Signature: 588bex18aoojcjaxtxw5e1trhithbhun
X-Rspam-User: 
X-HE-Tag: 1774307744-814010
X-HE-Meta: U2FsdGVkX19k+itiDSq1klZrhd56njjDPJbn7rAeL6Qg8y6Ja/2KoJop1v3e95d62hIE3yrYzMheqG7r1JU+JoFQh7Twe0vl3rsiOfqiL5SgcpcYIiodUSLE/MF7fvBSnW5AM3gANHcGBU7nsyDsBwZOKBXWl02uawDa1JDfRclwB1KkgH0IXMEA6Rqj0iubCN2tVLelHKic2MPOW8MF5YqW3zD5rePRcXKsoqdRQZU55G4nW/1N6EgE4lFDZ3kW5yF+OKZRB6i3of+HTNS7rCUMBvqAr+xBAlzHWkg8GtTHwiSCxgJBWl4XmRarUU0UO2iHybeEPIZr5WdhmxuxvBI4qG/Nr1Bv2Q/e+niBrH4+h4FmQgiy2NEHbAbHk/o2SYMo9Og8vHDnin/QahVJMqD/TN7N/N8+UmotmW2bWUogm5402fBZErIJn/cDay1iks6J7FoKtNXkz9lmZ4EkbuF+8sJEcRKwZrXccJM4GlRHmGBvHlMtYBv8v3ytR8LuBIoqLrLSSD7ffqYIEHDHwGpfVWnradYv5UnVi9chJZMCdEIPx5Ux04QzdkGd4gxTlMv6QaLXsKrl7zxRfpBRFz0iQowqcZ1O1t4P7t4NgP8BMpxv/k5MTgZS5L5eVO+MWHbQd4epHSiaYwkKMvnw9hi330BuKCKPCgpC6Z/kL3stjFjqrqvWmzSQWYOMgY+xH9kv8PUVj3x703+mdxfRKlBMN3Takij64Hpkjmwe3E1kWVTVQXG+w32lv9QTetd1bje1rjC8xZaiNMxPqFlKVo6HmPu6uUj4JkAvkInC7z4Sg7p/MieYbqMREnXUAqqaceL9yOulyCTOZXPIWPqWDzqNSwmzv1on613mhwfQSvi7xyHORi4jS5DMfxt9Eak9UtpEUkv5aBus6QlVWVku69REzg5j8J81K02nrF7nP//q6LKI8QM0ExJE1rlMEIREgseDsF8u9Oqm8FBS64X
 WaotCM6X
 twNv1c3HiVA3/+fZYCWh0ucn9MRxWpZpi1t2nJi9Vzsv/mmUxlwwAp+B3pgnv8rE1WrQCt1AMJ3lU8J7smYqW8OI418+kG4MBGDmSYL/U+BQGkzwW5Jl/fZsvk3F1c9OA1XgaZMu6FUDGX1Lb+gl3fJIMPXltVkyI6aIRm/axtNJ8+aH0YxDPeoJioTqJmKj53JeLRSydRgvCC62C106MsWBIOqhlScvLjX5/47SmkTYkXBcR99aDEoqpuChVVqjIcFIaIYYGFC9BoLeQavQvIbE8Jlecz12TNo1o2MzPbCLNh48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 2424237ebb105..7059f540940f0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -84,6 +84,13 @@ Description:	Writing an integer to this file sets the 'address unit'
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a boolean keyword to this file sets the 'pause' request
+		parameter for the context.  Reading the file returns the
+		last-written 'pause' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

