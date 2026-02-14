Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D5EEF5856
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 21:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DC56B0005; Sat, 14 Feb 2026 16:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFED36B0088; Sat, 14 Feb 2026 16:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49406B008A; Sat, 14 Feb 2026 16:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D45FF6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:41:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E2101395D8
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:41:36 +0000 (UTC)
X-FDA: 84444384192.06.9F7250C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0343A40006
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:41:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jIlYlZF+;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771105295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m6g2s5yn4jbXbdwbAXFZ2R+BGlK4rpdXcyqeN3XMenE=;
	b=wL2236ej6Stj6v+NSxDiUoVEHIOMxJEca/GPlzI3C+Kf5uzLBOmMTUY3l54tNQr+qE44dZ
	aFShRNlg40qUJWfJQqNEK/TXWxDv5Nbz+VXrcpLm236eC7PJDnJO9US0y6j8FHMRq9pIFI
	s+w1pQDH+DmyrRgYTDajOEkogRHqvn8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jIlYlZF+;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771105295; a=rsa-sha256;
	cv=none;
	b=UxIkJHcPT8fc2tNKahBM/amC4j/N5mojdBNW5Q3d5QmPUMleCZP5WPbhU4m8Vf+IHtzHBI
	cPVCRvLbZ5f7FveMXSmuFL26jrFEnlcOQR9Erwhjda+eL8N9XLw/E0e2ZdalIGRK9VtPTz
	99cpuLlf19dsNio2XN5dqFxwigXPNps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E773600BB;
	Sat, 14 Feb 2026 21:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B0DC16AAE;
	Sat, 14 Feb 2026 21:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771105294;
	bh=pjkwKmulTQMrj0f/NejRYLH42ooATAnuXxjLQOaFmfM=;
	h=From:To:Cc:Subject:Date:From;
	b=jIlYlZF+4PBNJ7bt04XHmqAWbG0k5pm94I/ik9/XFVg5T9UhMReiebz6qrbNCjikC
	 2VrBquWKBfpb9Wy9KM7Q24Sld5kulGZUULOwxzDwoxy6+d+1SiCPF5aIW21weTa2LV
	 Yltx3HWvDYu+TI7i3NPhEJ/7SnQUmXsRT8BKjvs09BY7YI0svnh4dm6hHDZfKHNjJV
	 j55Qq7pDtKVuS+wS+CSfxxQK7DA4NBt7rATEF6VVe08XrDbABHfMx8fT2UOjcLZo/8
	 3wpnmUzh09Bbba6wsoEuJaIFH2voQemC00BkqAvA2QjKoZBRPdY8CIXExtDgGwkAHj
	 SioomFYV9E26Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: disallow non-power of two min_region_sz
Date: Sat, 14 Feb 2026 13:41:21 -0800
Message-ID: <20260214214124.87689-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 46hfmsnk6rooo3nroxhfmrxmc3krzk3t
X-Rspam-User: 
X-Rspamd-Queue-Id: 0343A40006
X-HE-Tag: 1771105294-606326
X-HE-Meta: U2FsdGVkX1/hMg0XsH/H0m/GI0RMgBOCojsGIMjUwew1STYx5abZ/FghOfvmpLuaGVAl0R1w/iLxVv99K3waGUROQ7BIbxltMkKrN2/L8CPpmXPm7M05pWj0iymStrP6VCfNDgrOccyHP4F+M3HmtZaKUbwzT0n5MiD1abUCex6q2imoixb1PSW8vjCCo20UaUoFNmADK/P7kYwL17pMfJzTAoO/ywm0KAJ7eT8jAM5KxRoEe1A9A9KOTyR5czo5LJIAPQ5wnEuxlGFjmf46dBasPqZ3g4ZtKU0za+6IbQNPVj34frf/9TRZSxeIQK0uU06BtT7/E71JmNskqpKR9Y3ox8tMPa4/CAMVaj/ItxWfZnMBT76FciZAtcM7SNsTF0MFzIW7NvuT9QilZ1WfxFxRtP6Hdo1A9+7kakwY9xV7N7C1PsigEKK68V+rmy4Q34vPblCy47+wnIGXWqlDTZzPcEwZPy/XXjItxtlqkxq5Ng7ayFF+k80TYZCRsb6BqA/QsguNEgQBlVG0rr3hlxaXUXc4XF765sKFpMwmQwHH58lRLHYbVMw8j/vNkXup3ZRHyJCOM9duIQ9CKMQDpjsWYk0wRHsOb4QK/6hil7vG4tcgHyMpgOydb+ZBaQppsE+3mtrCRxi7fRbxBjqwOXFBV/QFfTCSkXVwWPU39MA0+3IiY5kWaGGqEGvob/NwJUILtFV2viaG0RqBAsdO578sDdhR+JkZDzZ4IsnaEHaLoJT90h+Iz/1MiCzz3S/w1fCHNlWCL205NjrH/h5cilbjjjwJ+TX2ooWkduaWst/o/Zr1GTrcgI0Ck/CIWHnxwF8lpsdfdB+6DbCL7BnyNsBheLjEKjByY/kVbVgWaFDgtOmvwvnIsKHJ96RmGsOC//56OIZODbofNASF2JvSiSjfxfAOtLBGHqnW93eLlw9CSxmLrEoM8pPidJP+WAg/nZTwDuuw2Tyn4CeZ6V7
 5sIWR11l
 Fy/2o15CCkz5wNxKtdg83CRf+vj7fM9ga9lE2pOMyBsBwxdkb2PHNU0YM+CHFHjTtmVLSKLsNZpoBHADVcDpUnVQXr+dMQG4f3N309jTGwdfNijAkHCFR5+QgSm6xZalu9szyJyc2f2lm5SoQhlcb1k3dTi7Q11yH28QbrJSSOV1F7r8ZRdzxaxCw1lUxnsjSYn0hqjENHxvVA99q4bJF7f/UIbDeo0kOkKcrgdW0/SGiu6NPHCrjLtqCzhQMxdbHFh4qqwo6UmBD3dXBkZlU88Hrjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core uses min_region_sz parameter value as the DAMON region
alignment.  The alignment is made using ALIGN() and ALIGN_DOWN(), which
support only the power of two alignments.  But DAMON core API callers
can set min_region_sz to an arbitrary number.  Users can also set it
indirectly, using addr_unit.

When the alignment is not properly set, DAMON behavior becomes difficult
to expect and understand, makes it effectively broken.  It doesn't cause
a kernel crash-like significant issue, though.

Fix the issue by disallowing min_region_sz input that is not a power of
two.  Add the check to damon_commit_ctx(), as all DAMON API callers who
set min_region_sz uses the function.

This can be a sort of behavioral change, but it does not break users,
for the following reasons.  As the symptom is making DAMON effectively
broken, it is not reasonable to believe there are real use cases of
non-power of two min_region_sz.  There is no known use case or issue
reports from the setup, either.

In future, if we find real use cases of non-power of two alignments and
we can support it with low enough overhead, we can consider moving the
restriction.  But, for now, simply disallowing the corner case should be
good enough as a hot fix.

Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 925908415a041..55cbf86476006 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1252,6 +1252,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
 
+	if (!is_power_of_2(src->min_region_sz))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;

base-commit: 918647226184ca20e5f86ee7d4df3e34c7433799
-- 
2.47.3

