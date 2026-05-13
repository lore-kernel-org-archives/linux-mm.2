Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47C6CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E866A6B0005; Tue, 12 May 2026 22:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36DE6B008A; Tue, 12 May 2026 22:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73C56B008C; Tue, 12 May 2026 22:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C98FF6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:21:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AA07406A7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:35 +0000 (UTC)
X-FDA: 84760795350.17.73DE7AC
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFDFD40002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:21:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pVcqdVUr;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778638894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mAeuDUZY4oa7sPsWfqEpo6uZDXzZyX155Ulp1Mkpt3E=;
	b=w/I3dhuNho5lH/Mkx585bPhbb9ohwD4/PXcCvSUsipAOpbei1blBhgoGNzNN49Z18d3Evf
	AzXyyrsNnXu3A7ZxEv0cjdN8seyLtTeDMnJP4xEZ2xMIb+ZqjRH8dLM0fcHcMEDoKmEEJG
	m2oc95q4WupP2/R+I7X1AGT1LpAiE4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778638894; a=rsa-sha256;
	cv=none;
	b=f6xTG5I8Udquz1QD+PXzXpgLKZMHAphTWiaIWD4ovJ46Sxl1wPzX3qo7YY8tmxbt9VBRAo
	XffxnQg92zUQ7B0ZA5zfHVUgrfXXuWOuKIaLS/YdGVU1To0C0WCSRXIBZCaeIhig4HU/vw
	sX932uS9Ljrw9SK/xCl4eDXF+8USnm0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pVcqdVUr;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778638890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mAeuDUZY4oa7sPsWfqEpo6uZDXzZyX155Ulp1Mkpt3E=;
	b=pVcqdVUr4XY/hrzTGZ+iCB+Wa192zZljgm02Eom32RdNPGk11DUgcyBLFqiUc3D2NiLvN9
	4BOQqINl2/QBDEVSNyI819L6VMQpQsso6rC3KO5tAI9B4xpN9U1ouH1uu6XeOJYISUV1kJ
	gfzdYIr/cuURkEfoU6IeBu5n3E8G1gA=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tools/mm/page-types: Fix misc bugs
Date: Wed, 13 May 2026 10:21:15 +0800
Message-ID: <20260513022120.58033-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AFDFD40002
X-Stat-Signature: t94bp3p1srit7zbh5rydk68o9fbb3459
X-Rspam-User: 
X-HE-Tag: 1778638893-597409
X-HE-Meta: U2FsdGVkX18Davr1yg/y9zVXTxFutA5pzZPFRWX/ygBzclcmDGJdZ9F+6F5pfh+29E2JN0pWTd0b2DoX91RayQBKBg7NXI0ymlAhgIxIFs6SkjtS5WA5MCiErg9/ca4w4AFSS1G0ofWGl26Q7urMjnph9/U7fIUKqSrx5JFjOt2ilJVbRyPqGmA4U7cL7sQd/nen6vOmlMEb1o3PbgjZ3FZEs5R1TAfB8mJx1Ci52uMLoo/oDibgOisgF3UpCI01CqybIJah6kMvYFK6xANtC5UM55kkTS5aZH3kvJMzu7FIc0Q8MKaIotqT8OWs7dG2Xmb9QLSOg9+jHVBbrmNkgR9N+n+yaIlWu/a55cNXp+gqpLYMwulV2gBBaHcVW0r38Tmru+7g1hNyTbxKXvMTXcHQKrRLu7Ddnp/v9zBKUgTuEzEkAKS7XV3x/9/6mk07OK362owKwlmGHzXLIavKe4SR8Fdfp3mfvkEDw5upJKmo/on2v1bwrETCv4dn6YranP5IGV0TAKuUBmP4IQMBAcpo+uagOEjBcQDcRsWQyKXZoU4gM+K/NEB6jgLZFiM1XFMRja6wKC+uGKEKY3Xo6Om0p5qtEx2kXg6cn4C5Hq9plEs/D/oBn3SLwZhTGWL3sETVxUl9ajnlgDZBY6QDas7rconku3NL7whzwfa5Cu8wLT6o7hFeEUXVr051viWBxAw9S/7dMmTSBw+RhDVusJ5z8UsYEyNgHsnPvizhOEdiEJq7Sxxxm1eOEIbz5LWWENwg1qI+bFkk464xvg6Junikxj4bqNRd/UQCw8NlY9Vj5VnOQ/uJH2ew9JY+bWpyXFOAc86CgrA6Nszjikwh9ptiBqpqneUNipWU3CsRWrA+D3VmQQGluG3ZrMqHZv53xayUTL+CUyUxSYavcE3PKhSrmRzNBTiHzVGq9vVqdWGT8lAoHkzbinPZedQCDsV04zBnlcjQD7S/wECevaQ
 nFY5ArKm
 Q6xw0fJBSWY1wivIN6TwCJ7zK6RaCeRvDhG2YoN35jBRZmSHcn7XUwYlk31k8tGwFtTIfm5jzSR5jQd3cPQEXDVGS1wh80keCVESh37pS/cNQdCw7z8YPBZZIpizdaJeVaMO6LQxWbFpGvzpbW4FrGhGZPTScKLx+XcTA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

This series fixes three issues in tools/mm/page-types.c:

1. Fix two typos in madvise() error messages ("madvice" -> "madvise")
2. Fix operator precedence bug in the sigbus handler where the ternary
   operator binds looser than addition, producing incorrect offset
   calculation when sigbus_addr is non-NULL
3. Fix --kpageflags option declaration in getopt_long: has_arg should
   be 1 (required_argument) since the option requires a file path

Ye Liu (3):
  tools/mm/page-types: Fix typo in madvise() error message
  tools/mm/page-types: Fix ternary operator precedence in sigbus handler
  tools/mm/page-types: Fix kpageflags option argument in getopt_long

 tools/mm/page-types.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.43.0


