Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6A4D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61CF6B00A8; Mon,  8 Dec 2025 01:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12CC6B00A9; Mon,  8 Dec 2025 01:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA896B00AA; Mon,  8 Dec 2025 01:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC176B00A8
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E62DC06B0
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:33 +0000 (UTC)
X-FDA: 84195329946.29.1DE0C26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B11F38000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRoORpL2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvNAnhhTIWKXi8/ll4g/8VOFSydLR5rY+D90z4a/gIg=;
	b=mvOx0TowYAgqO4lgQMTT+dXEaRtIdwFC3BAUAtRaEmL16oZPVz3JQlbr9+2NkF9XePlweF
	JA0M9djEjrm0nff6sxIluPEtV/tWeXirZwGNRD7MzQDvrOs9dpw0xIMMx/Lev0Tz1atysR
	5shbPRd6dyX6ZE0J1XeKcY8NpNd7j2k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRoORpL2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175431; a=rsa-sha256;
	cv=none;
	b=CYJ/iGP333f646hGJiCFSUdNi7dGLdYF39co+H5td54iX5K/jHSCZsPiSv2ID6Z9CpjLq1
	fF6bbb/XQ7It9byJPU7AyzaS9F986vsoAg9cKyj1iOrLrK2cd+DKBbt996JEUbRGIiX/pd
	PQYTrIhIEnmP4ZqImBU7E5JQyt+Pt5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE5FB404D5;
	Mon,  8 Dec 2025 06:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AF1C116B1;
	Mon,  8 Dec 2025 06:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175430;
	bh=r7GPIONjiVkaUh4sMuF9LOredJ7nNRhajhKCAfUCZiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRoORpL2ykkJNrHjZAbab6K5OR2TidIB5ylB9NIAUOm0kdPhMebK6wNPzQcvsUBzd
	 GvhpiQIf/Ott8rwvoHP2Rew4ueO5b2lhpAKmZAxxmfXefloTY5pKmNETdULJIan6zj
	 0WyjrmAbH+cMJESAjRevzCXUnkJAlsajrXMgJsrSIX7feapX9ddTkp8h8hmKvdMsrq
	 H3ztjraMeKsU6FZQNVtH0ZQLVRqjmpbXyWNVecz1565U2DMhBzzc+heIEkEnXwCO2J
	 yMXlAmjOpkmY8Yo1vo3JrmEGpg/xkw9tOFTSiR822DpAJvN5kX8EhRqpRml+FCdhvb
	 CPzbMFDn7trOg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 27/37] mm/damon/core: report access-generated thread id of the fault event
Date: Sun,  7 Dec 2025 22:29:31 -0800
Message-ID: <20251208062943.68824-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wwpx1xnjkk8kku9p33oifuqsu97gqtnw
X-Rspamd-Queue-Id: B11F38000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1765175431-709445
X-HE-Meta: U2FsdGVkX1+3fYzb4f90+jxyN4sQ76qTKv99/nKewV8+SoLbXxprNaseopuF4l5t8ENlTh77qefu+4/Z6RMDHWtNqkF8KUn0f+2jGURTT0Az5IxsRmAUi9h2Q3J3IDQPHJY9xiKNxACqLxLEJYjbV5tJ0mV5PjvaY98Uo4IBfRQZbK9/OKX5FZU14Hq5Y/NJYqgfh+v367PDqPoyPlT2s5HL+TAfBPOPQytvAKObcb9eJl++3k02bakJwqCpfJ2oy85JPFtJ1sE0BDmsTh35xGvBpJZHwhETDFbRepO7goV9NKBMiU9GBSN2427WcPXcAeMk4ybcGjx3kt3MfMXuigoppRzINM356oiq5lheOTuepkS3v/La8ceVb7vVGrD3gwprXU1KLDx/yLhaWIlYgoovn3gaERS4/a32aR7/yrixCTsPm+bQNvGmsR48eIS/dfkB8/0afrrwQJ/c9RmhhibhNAnIV/dhjGvP/0MzNbOgVvGIflhcEgkTa7zD+RkF/O8/DoqRnZpAMZP/gaWNiPokwYFcuEKTJqdYxPlBRqpSfigsfOySz70AFSB6KXRzpA5xz8Ll9wQv7pQo6N/5qnnhf/mILz1RGijvK6FjL//clv6jXPpvTLxxOcIZ8ZnG92WAU4QM1ZDUzotI3LxkFOwNIGEH/kIleYFb7o/7uMJKSlRTAV6elg9vBgcutfIBuFIEmIdeJA6nCrj4IyQDzqS6xp6Ge95yuiLwqYeX0Zpny7H6iy24fn5fOrgWRRCB2YniOA8CCfMzqVTuFzjZh5CjZGB4cQGuah1hC52SM/ldyTuPp/FLYvRXbb1O3jcpwllLTr7q53rRMJZNZEq+IesJpUQVuzMKQ44vTg6Aiul85+6KUXYvYehbh7+H/gSx6gJ27CmBEhG9qvEFwqZcv/RpvgEUk9YcIRkPakLP7WShSvszXY57VG5qQPBx6W7TgKLmlTb3DaiyYHXzje+
 VQvl2WK+
 IgK6XmTZcRFWvfO5GchYge3KnYVDM6TntZ6/L54w6y5Fk4v7cPVfyoKMfnX1l3syQlYsZyOzANybcDgtvJrTfKuYdORNTbVl17+wFwOiPNNT9X3SBk/Cfs/SJTY/oRsuI98iTA40vE6C6yfkr9LD9jM115uCkvCUanHA72R35dp/g7X3VW71xzxGRjXLRmK+Wunqcg+g3++AilZOew1CimLibG2xNmSOTkJhpPHVAR2dudQnKOQjXvhpWgtPdKCdb5ltI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page fault event reporting function can know which thread is making the
access.  Add the information to the report.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b627fc84161c..4971647d4b5e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1712,6 +1712,7 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 	struct damon_access_report access_report = {
 		.size = 1,	/* todo: set appripriately */
 		.cpu = smp_processor_id(),
+		.tid = task_pid_vnr(current),
 	};
 
 	if (huge_pmd)
-- 
2.47.3

