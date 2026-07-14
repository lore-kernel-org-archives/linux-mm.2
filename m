Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1896FC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7E86B009B; Tue, 14 Jul 2026 10:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68A56B00AD; Tue, 14 Jul 2026 10:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5026B00AE; Tue, 14 Jul 2026 10:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB0616B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43D7E140371
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:32 +0000 (UTC)
X-FDA: 84987544824.10.E21F964
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C63664000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opJbIRfx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xev+RArxStO4Y/fnuMkgg5H8N0EqMUfi6KCHf6ihSI=;
	b=u3xGtDwAX1XCGGxcTiSih5B6qerh3j1aPDE+tqM/n697A7sDImyNfHfN5BCliqI//yqP65
	q6XxllykoH+gn5zQRDPTgCB386yAQHEZn7/cy6G6tDf1qXmuY9yaPsK8tnlqXwlEvEyAUN
	4VyZJ9/kLpSrOl9AvJSzuGKjFqtRZ2I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=opJbIRfx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037689;
	b=oYpCyyJxKG1afbcSHJwfDC5hFcKTJ8ErywzyMx9ZKwo8RVrDzPXc5eudY8hKd9NowAz73O
	aFpqF3nlelC0SaMSdNvD59oT/XsRCo8wJbJy/FQ05wTLh1u4584HoPFx+A7wwdAc3PaO/y
	wUhP5/0mrk/195S/QZeyS9KRxPJFAFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46AE861375;
	Tue, 14 Jul 2026 14:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC41F000E9;
	Tue, 14 Jul 2026 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037689;
	bh=1xev+RArxStO4Y/fnuMkgg5H8N0EqMUfi6KCHf6ihSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opJbIRfxqGTV9/18goXySzxETF/pZnh0raFiuig78hrgEJkiIUC6Qx2izzC1MXb5d
	 VE5R6g9rINCV8X/9J1q1/kXRxyzE2ULnNeJpw8a6/lqtqRKzLBeXSaqy7dRbb1k3bU
	 rdY57GxrUYI7yRG8IYR8tMj7xmdTrC/V1jyjQB1BahjxvMHxWDZJpVpIG5clHr2/ii
	 yw/bqRNlvRKcz6vvyPuryJpzCuWF+A2aiBK2I2vpqF0+gnsi8Nx/lUOGIUOuPmYTUi
	 TbEFbLoPE/LP9UepXvgB181bZsyKxePo9AcHmuzK5uGqogU0Fk0LXeX9MhoWm3AcRG
	 eZ5n9ZxU9xVaQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Hu <husong@kylinos.cn>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SJ Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 4/4] Docs/ABI/damon: document tried_regions probe hits
Date: Tue, 14 Jul 2026 07:01:16 -0700
Message-ID: <20260714140117.94147-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714140117.94147-1-sj@kernel.org>
References: <20260714140117.94147-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 86sr9mfrj7qat7wz7f48tr5tudfmgs19
X-Rspamd-Queue-Id: C63664000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784037689-862563
X-HE-Meta: U2FsdGVkX19SEVQ60VH1ymswTsRw6zlX8Gal32tLs0gcAMDgWzCFjQR9qPqBefVw5hqG6A7HYuPS/bvc+sw1LzYVyITxFoQ4k6JdXT+hDfl0wkqeYaFdb+DLmllRYYZpXs3/CLnmj5K4HShp6d2+gCHTVafdoGwjYIPeltS3s+SYYjZWxE5pxVmACY8N4XIDdc5xhHo1B4t6sumo3QF5HPTe8sQBYwnU9YVHErc+eZg89WZzAimzOMshIYmdCmRdLGzxiq7JUEDZRRsmuslV7AD4//ajcGHvFy+VnKGkxoJ4Prq851Wn472egwkBVcwKf7JYzTdyyaGUJRDwjK4E6wzsbnGHGlTYn+asdUzdt4CUbSFaSr2I3FRtDJPsGErXoFBEx4aQwVCXOkT4QF9HCuk41z9NPu7JNNY5HgTAetSqVzaOB7+Xb8lBJeHTjOdduS6DfYkIzqthxshXFQHf7/FWLt7neaPgo2DIBWDfjDmhvHVsEb+5ZdV6bpZAk9Xly0/+WT9hfHKEy/qBZgn/mgnCYf8tncoizO5M4FSiBEvYMnc4HJFQqnokVrm+VWzLQ7p1CZECEWgqgy7RXdrOC/fj5cIFKSUDCaS6OSfRGRT5ADv4LCFYbWhS68h5Gi2xJ/AOHa72VunCCivlMR3Lnk1VD57SS+Go0PMDg+DC/k4JLHXU6unouY4+Nkr5964CFDvctc+hsXegFfyGHOVjxFvYotOwTJ3doLADGkuBs/1OhqUk7V5nEbM/9+ZuDcsjEsSB2XFp5i4N6SWjpz08hlJryCIzRyarc+pMTt6FLQYvg6uZLgBDxJPd7A0N2RXSlOwCDGuUWDn6ARtd4y1o/6dbQ5DDfB/Tuq9C5qcFnDGvOfe9l9N5QyYT9v6GFZ9knuhH7u2nlW8Av5CF8w6eYsG0Fp9ybaTTjT9EGDe0jLvRVhhhJW62s01ZKovQGZhihPybHFHyRDy8lw/Q4j0
 EZSpLtDC
 WsRUFi43KCeg4d2jG1BEExqrh7vSnrIYBc5e4vxBKa2StbGGqddnCbAxqoiisCu/DzV2ZcV5E9CQgp9EbhKUSIcDWnxvSrLC1so/zmgPzLVZnlAtRvoFyJoTyQb5KN1wuqspxQDSYFTZKcG2JRnV9UdwLKO+0U5k6hSCJZxcSug4AOPmf0QBLei6+ZIarT6Qypi0bpqexUNF8vdI/TRKs+IS5r0dfC6UB1af4gr/JolDJqVII5U132Tc+YgKmJ2ZsnHXQGSYS46UcQYy9BHmwl40aTXz+Ngl28IuqjEct6gA4trMdhizGrB2+emX+XHl2nY6q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

The 'tried_regions/<R>/probes/<P>/hits' file, added in commit
5b0de1bc3325 ("mm/damon/sysfs-schemes: implement probe/hits file"),
is described in usage.rst but missing from the canonical ABI document.

Document the 'probes/' directory and the 'probes/<P>/hits' file.

Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 1507e63ab1711..e675a57145e36 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -650,3 +650,15 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the size of the memory in the region
 		that passed DAMON operations layer-handled filters of the
 		scheme in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Directory for DAMON data-attribute monitoring probes of the
+		region.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/<P>/hits
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the number of data-attribute
+		monitoring probe-hit positive samples of the region.
-- 
2.47.3

