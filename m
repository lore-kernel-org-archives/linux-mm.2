Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A408AFEA82E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7326C6B008C; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5926B0093; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5572A6B008C; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB536B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEEE11607E5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:20 +0000 (UTC)
X-FDA: 84583782360.12.7F50AE8
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 45E8F8000F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=jzrXLtt4;
	spf=pass (imf30.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfsen0gLvtXHaCR+ZdiNVDmc40Ve97E4q2t/q4WxGfc=;
	b=y6PJLKr2uh7GhQMff1rHZLyF0Ggp/TzZaseLT5CvC1E3GdSRrfIC+qSlnj1mOIamLvXEiM
	HS0jZVH4NNbvnPekT7Bp8J2LtKfrfAExhN0uxTjdkgidzj22jA+tnjjA2uEVCWRHI2tIEG
	lvCexdbtCuMuz+6n1TMnGx3t3HLbXu8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=jzrXLtt4;
	spf=pass (imf30.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774424299; a=rsa-sha256;
	cv=pass;
	b=cpVkkj/oZh8iIMRfc6rW658oOHJaAF/XpxYJrdNE/kfBdYsgi9Wrz2R9Vtlamld4V6aQrX
	dXi990NyiEvwfBzcD5huNObuTgy5uonJa9a5agvVkLI56qvUnAg2tmk929eOmz3UQmQQD0
	ADNES1AdjpYZXHJglcGb0rNtkBlsJ3g=
ARC-Seal: i=1; a=rsa-sha256; t=1774424286; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=PU+fmdve85QzTNEQtdk1LW3R84NoQHbynext5PvuzY2NocmffcS4kg0/HDQIf9iYlueM73SUzbpEndp21M6z2ZbE5M02ofyYK8dtWtzL8UTe0ieaxvuxrAw/vztyGLcBTsqZYaQ/Z/P4aHk7PCXVvgu6I7i4i0O/8Qlw5IujHh8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774424286; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=tfsen0gLvtXHaCR+ZdiNVDmc40Ve97E4q2t/q4WxGfc=; 
	b=gMo1eQxduiJH6BgxCkkPj0rXLqguv59IAvmwUXIX05+9SHJXku+KRzwW9NOAmcf/w3Bki9KOaAamDvQowmY8QNzHk+XXiOlQ550xPBHWd6qkL9XRgghFsaarI2/cLadn8+e6j1bhNrELGxIWSBMSajbvJOSIC55JSUzUEZUAPQM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774424286;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=tfsen0gLvtXHaCR+ZdiNVDmc40Ve97E4q2t/q4WxGfc=;
	b=jzrXLtt4DNgzDl3UVvlGzVzgOfbyJNaUyDhOgaWC1p1rj+E5v35hGzvqP2mqNgb9
	NIEwOcb4JzHTjArQ3m5tTLJddd9xAwhY/+T/YTEVyFVw4JqMF+jHwr7eoUUMUvWlQ87
	gj2N/ini0dllgt+XWQTHYIr10L6c241483PcYTUY=
Received: by mx.zoho.eu with SMTPS id 1774424283087612.4270641961702;
	Wed, 25 Mar 2026 08:38:03 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 2/3] mm/damon/core: use damon_nr_regions() in damon_commit_target_regions()
Date: Wed, 25 Mar 2026 07:37:59 +0000
Message-Id: <20260325073800.141756-3-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325073800.141756-1-objecting@objecting.org>
References: <20260325073800.141756-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45E8F8000F
X-Stat-Signature: tcdokw974e5pwrj8ijqnckt8ssrqtz6r
X-Rspam-User: 
X-HE-Tag: 1774424299-633703
X-HE-Meta: U2FsdGVkX1/159I3iown6Y8+tvlPD47aRZc99dZUa57aPZj+v6UFESbz7uKqq28YZ2eVtTM/B9ou8FJhLtIxUDNKkdkySEtAvezaMiD/kAtMC6cJgjDg15YgZHMBAKOrmi+sF693nXVr/a0ZcWrvTWU1AcDTKLGTTXE5Qz57vfiBvoxoHQMY8AiAqgSM8bze7Mg5A9iEK1LjS2OYDB54uAMXNuAzkQloDcjWmFCW7oy4Y14y2FfAYZQD0MRrQHAS/yEoJawU6VqXddaGnGzRqaAwEBDnPMgT8akuF5c3DXSXI39zbibez8g1XvqfXQpUMyTE2R3qqtylABr59kL0Uc8yI6JjlbSMPHENtzomNDFU0pbRqsMI4swOke2UZBA9bybjXqmt4yv3Jrmb62MSQAPYvwrYtvzJwCx2HENMQ97MTHDqP7yP1wc5RMPHMywXb3dxAFxGddyOKaM3p4grPsFn4l6x8FXEpYt6C/DcJKe1pJoV3grTWfFsnKAk3QMp+zsXzzT/+P9IkwVrxpPcuFAoDE+k0Am0YE3vHhSpjNdlx8jUFsqTLEO4LPQZYOORErdP05zXQ5/oCuUPCr6o8UZVpr1W7DAJy4HDYdc5POMcmzkD5SZAXf0Jiia4fjHv2teLDwav/sXoKR/SCB3qEYBPPk9Xy/SpTjP/ufK0T/wV/9sj5zgqtUXaZ9MQ13n6bzInuuLasKPvqRFU35Ft+8KBXuioBVA9JSXjTyzZkQLZHl90wSOT5y+i7FBTcZkRkJ2y++NsjG98fma8dG/4sZJitgEE6w9Ayw8xjrWr2Qt3v+zvIA6uEPR2GmOKmfFO2Q3PGX26GIGFgTPxsZg7Nnfw8Be2HgiKg5IdEYjHYjQo4ettQ7HUGttEdTqgLK79CJSN7aNeB3GoVdDujIPM9IQIej45VgNaaa4eCPNkxPdUPO0I8lWDFTRSuV9dXuKXnu5kehXFtgSW3hhGSWd
 h+3LMogO
 PFuf5FRAtlQD+RSYeNrCM6exNByIp7I3Nxi5+sDMSPS2XtAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_target_regions() walks the source region list twice: once
to count regions and again to copy their address ranges.  Use the
already-maintained damon_nr_regions() instead of the counting traversal.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 56372e577931..6c1f738e265c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1217,17 +1217,15 @@ static int damon_commit_target_regions(struct damon_target *dst,
 {
 	struct damon_region *src_region;
 	struct damon_addr_range *ranges;
+	unsigned int nr = damon_nr_regions(src);
 	int i = 0, err;
 
-	damon_for_each_region(src_region, src)
-		i++;
-	if (!i)
+	if (!nr)
 		return 0;
 
-	ranges = kmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
+	ranges = kmalloc_objs(*ranges, nr, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
-	i = 0;
 	damon_for_each_region(src_region, src)
 		ranges[i++] = src_region->ar;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
-- 
2.34.1


