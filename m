Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B69CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA24D8E0024; Wed, 15 Oct 2025 05:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D5F8E0002; Wed, 15 Oct 2025 05:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A646F8E0024; Wed, 15 Oct 2025 05:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94F6D8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:39:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F850140926
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:39:23 +0000 (UTC)
X-FDA: 83999850606.10.3B58734
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8ECF316000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:39:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6rxyh97;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760521161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ur1d4sLkDam2tvoH0vVKlEKqUTS0tNi3WqMUYtOXl7U=;
	b=RDN48JXY6TTLObT41aUBnrZfL/DcguFNg5+bQDLqQftlcD+ziuexqqwvs64eGY+tUIjQpu
	4mwsyMzIxadcHvILhvKeEMP2BwWOqETcG5ZpF7J8Z2nAbJaZ7I8jDk+gaSx2dKEWSfunR/
	M3zv/rFUyIxcptMa01Dty0fQEQRDDBo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6rxyh97;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760521161; a=rsa-sha256;
	cv=none;
	b=L6iiSjCmtSZX27iDQp+UkpiCHyv+hxYTj6DN3QDqD4DcEQtNshYvAeR0b6lh4+tGekE2os
	HoAD9qfpGcM8h3qs9VSBqZsUCIqd8XC+Jc3xEDA8c3aHHg6myHsBOQg+qmQwyPr8mFtC0K
	2mtzf0LW4CZwST+MYGsjQpj7HjALmmI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760521160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ur1d4sLkDam2tvoH0vVKlEKqUTS0tNi3WqMUYtOXl7U=;
	b=j6rxyh97ml79IjAgqiQnQzHMMd/EofCDZYKUXuggEKW0nvK/nE6EdKR1Ejhb4cm1frKw3d
	WEmu6iCqO3/hLtVpu9L4uJoQCnopALzM1CltFYyxinEFljti5uaX4R91XUqKzWZAZXOLCB
	jW/9/bfehQT63Lb8EIfKRregnhPVdnA=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] tools/mm: use <stdbool.h> in page_owner_sort.c
Date: Wed, 15 Oct 2025 17:38:50 +0800
Message-ID: <20251015093851.109663-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8ECF316000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pz9sybuaianzg4bgfysk4miyfbw6omaj
X-HE-Tag: 1760521161-522436
X-HE-Meta: U2FsdGVkX19m6JDMwZq4i0Nk5I57RNxGSlSL7W/EuBYaCIhtXTajz+2RtiKUwFPtKJ+NWloP1n0nKZ5m/CGQJBC+3BCOZfKcBwpYn5xlyECJ4j2yMM24Te65IEzFEn+ukB7BOqRedpV6ZsbuOrJ2dWDT7KUQWUvdLCUXJy5SNf5v429XQQraiv2206LyqJoWm98gyAD/1l7KN5eNdqteriSBhGDrQicCDEYmpJVm3DeNV3U1GYIZh7RrfZZ0kolsRjyQtgHGNXJs9bt30cGyq36g9W+bleC+ieOAgbJfqGb1uU4F65dDA+sG9P2ykIBSr90xvOIUpKTLAMQ8jtmXQSQ78t+ktJxgahx4l2ue1gZVTDjZzpo0HFC6i3dwazQYTMAfxFpmJ0JFhWwlzwQaMfcaKGXjulq4EyZzjeO+3N9ZD9bIRs6GVI6olQEJaqe/hMZ3v2mNKDDkLcClb6vyQWs0kGDYkuNloyGKL0c+w99g3xdhzgqTquuUW+9NEdDYu2spd0nL1aUa2alhSHjNnGW8N7zC0psLWt9qFvXaKGVD1LtslkR8yPq8rSmbI6UdQsiBvExPI4zcOa2+WX5S1QttuJ4Bvq+M/zea0yjVGXvgcDxH3eNiPs5VByWNSejvWU9Z7ih+tI3AdeXot07t9kGoPt0TyOSJ1HuYxfqPMGgRGL5DD33E/vG1hTY2eKeeKbipvxXhEvJpL81jmp+LRqYJ54jRweQXMqDQKEspyLQwRMgHxXBO/RPekHHmfi8MrNeR+LNecggftlJ510BmKCMsOi0ll3iTBP93qWkuWAlo2Ihc6HrM0ktlOMhstsYe9aUFRtgJK/VJKjR8MbHDyPeKTs0NiNmJN5fkXUT5v/COItHsNaPgkav8kz8/Q6nDasF9Wv7e5VEr91lNdYwjV+Augt9N7co7aUhRYJbpJQic1amBFhoQym3jVafitYpW1hDx5ZbmdzHTciPN7LB
 J7ZhD8Eo
 RioWVQUFIbOcGoazSJPSTZjF7UiSalmUaFDxoNpSQV0xRVO2s5KQwZ37nmsz1GU0tI5r92/dgmxvx7szgwxTb+NIv1Gpz16nqXWIENz14wirZWpvO1L7Q1ZicjOFqzoDmQwbv1RKhSPy+0Es38HZlY3KnafSdBTqBaYpA77TaTmQCwHdap4QO3u/fA9X/nb7m8Y5948HU1Dt26h6q9G6MU+og5LWQqBaZ66GEtYbt0m985iudiy21WTBdEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use standard <stdbool.h> instead of manually defining bool, true and false.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 880e36df0c11..894a765652ac 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -13,6 +13,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -23,9 +24,6 @@
 #include <linux/types.h>
 #include <getopt.h>
 
-#define bool int
-#define true 1
-#define false 0
 #define TASK_COMM_LEN 16
 
 struct block_list {
-- 
2.43.0


