Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B818C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500A06B00E4; Mon, 21 Sep 2026 06:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1FA6B00E5; Mon, 21 Sep 2026 06:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379A56B00E6; Mon, 21 Sep 2026 06:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6006B00E4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:35:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7B8614011E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:30 +0000 (UTC)
X-FDA: 85237412820.16.A909B32
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC1F240004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:35:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bi+r4Pzf;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986929;
	b=2l9xFQEovdiamPx9+6H5bgiDYLHzWoKHP8dkwjP8sTvXMK5Kz5xnosLntqELb+ndeUnDm1
	5PNQnGjcqZbh/QVSBzcjPDlNCJ5HxxJr9zYZnRdkUgBtmW9+OJpbcsy7EDCR9oRARLdvOE
	UkMarQLRayPazSiTvTzw/4M3/pLZsnY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bi+r4Pzf;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YkzYvFe3EofYRqesJr3vJj/YGdhl0HksFtmxr25INk=;
	b=YMNJvXisyRVLudWIgt+37VNat60kCuZpaFKU+glzPbm2Bwr3SnSf7mCdxd6KZKZc08TGoY
	mmAnbZGrj0Qkl81Cv5rPZ9UBwbG2Lyj80jMzBqM7A6n1R8kAH0aT2niV75v1zWaljiAKql
	1gF7gR7kzzQJvBClTkQVAUx4y7ng48A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 556E41D13;
	Mon, 21 Sep 2026 03:35:24 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6633F86C;
	Mon, 21 Sep 2026 03:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789986927; bh=OXUOnvVGrm07rx45bJyXJlQdfRIainiGV7w2eQXNIIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Bi+r4Pzfu7LK1IDnv1iAnU1CxKUeRaP2t8oMyIAxvDICfZ0gntJ9AhAc+ehwKLvIL
	 10newgqW4Nh2YwMUpdV4D6yl2+D9Tms20DiVJzHray3RtuuCLjmDAUochKDNDE4uug
	 bHMBe9G3TQdEoYw9jtIY/e9y41s5KMDZqHszJ3oI=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:35:02 +0100
Subject: [PATCH v2 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
In-Reply-To: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2118; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=OXUOnvVGrm07rx45bJyXJlQdfRIainiGV7w2eQXNIIc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQhlJdHPWa4jn/M+z47EH8fWexmgZDgXPjOo2
 GS9NJ+vTPuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEIZQAKCRBt1cPRWsUx
 Mz0BDAC2VYxF9NnES1vwyT52W2QO7fnSf6o/iaq6vfit/DpNCWSGOVc47Lb34VolWmo8310yt/J
 2pYlXQlQIED2Halizd24uKh3dHF95WMrw8PlsjSUf99mKNCPnDPPLotxk75qPcpwcYyIgnOKGjr
 P8cc8s3UfWhJTjGWnT/56WeHXNQ0FoIHnoZ0idwApn5NcchHQMNZ856JUDplrGHG3FbV9pfjFKS
 hBqvLskYzTxz3TEy7w697RkDQYKzBUydOLUMW8847RYyamo5J0LwpyfAliI5RptnvbWJF9vVUH7
 lXAyIKA82Y4JecyrvgkEin6ob9PSN++tW3AU3bidPXG3fYNQ7MJx2Y7BOMmWez3gYHinCUBG6FO
 3Sz3xZF74VFrJ3aqwPheG81wvBJ9ZPm8I/H8I1NgpP+1U4BeibW20VsNhhQGvU5VZA3GkFbNwNu
 y42m1pII2ThSUxUUXlyRIwnbFH9fHVv83jDSCwBCFTcKnQoqZwZNsgVbpi+fwQWSb8A2M=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC1F240004
X-Stat-Signature: k1u45rnd5maat619o4ns753zdhh91tcm
X-HE-Tag: 1789986928-269338
X-HE-Meta: U2FsdGVkX19waAmgFs+DTfiLG3zpDWm6UK1ipWh25rUkjrOT/xUfVwMhZ1YkIdMcNmlsOYxcZXZgXr2xU2KDaz4N4q8QxKhw9+QeJgUoIHgIc3Zzvf8Y62MsTACh+FNVS0gEg46etzawehQebYysMi3Wj6q8zUN7vXF0HaNWriNgLHbuMOl7t+Lcft+5U++A5F5nT6C7yamC93OhlBz8AZ8P5IkH4zMmcj7l9mK3N+hUG6vHNuVJMN0M0rfVxSsmbuCLYYnSjVBBfYB63yyt7U4x4gLuoRL/bk2YqNeu1LStkAu/gxJPDc0C9x8E2UJIwJTrFxECUh7XXEmoJNBVPNTFDIzJoQRuNpi2uJAwELPVYvAh7e1dKBLsTwkbULnZgXROnosJVJl5wHD1ypa0H3zr/nBW3DgdX0E3GfG+y/9JgzlkKcznziiMqsHHXasAc1q3VlZcJn7Now9ouDn9t3rXw/nrZOEKPmxyU5Yw7U489qDKG8NbtnpE5ceUD8wWfA4ktO8LKaIWmEKvkMLORGPdOyPEEpZtQOLYRshT7J99TBjrJMwjKqbUjIE/gsy87syj27lGp0yd86KXdSYsbjgpYLyuNqmAjVNPOaTqE+Wrq+D4jY+zOWy9hdZ5KGR1BwFO1ZFx0YdDD2xRjEY7eUwshFQA27YI95QLolsFGu0+b6Ymrl3sJGBTeXpXxJJEGzw/o7OIyoF5NKlFbuxUBzraKTfi155C5nuJjTynmlhMNXRnJkaP+g9akWxlNw+Hm+cqG7e+x1auMvqNytzrDofP51RVpN0QcygVCP3H4EFdreoZfe5PZQ67VayT4ccxfce5qyCZhXOpOQQPGMnGy9xIqikOUZ0XwwWkI5+EK00wF5XPkMrGR3yVkzzMERzvUtYrB4RQApSx/mppt/jjT+21qUTft8zcjGOdCQrkGKDt/XyO+zlHaiCmq6n0ebXsgxVPK57Cu4p+vGA317U
 /v2oT/K0
 RbJeddaJvVdF+eybsfj1wGn5lNypbyHr6WDi8u1y2EEkQqqiAlkGrvG172XJsh+wuZSNg8bGt/7DF/6UxwfYmaEJy6MzCK5cxpMlqgc9LqOBZKIXM3xYA6p74S0pMjGztvOGTFDG0emabTzyCX7wMgZjyNMyCykkP95evCIcnenLD97+8ooZfwZeBvGR6nXSRdywjwM4HffyF8AAnGnGuVrmoGQb9FfAmgbeioUEwvjYqIIs5jJVW9SKDmZXzQp9qL9uq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  // while running ./khugepaged -s 2

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before wait_for_scan()
is called, causing a sanity check that expects uncollapsed pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them again
before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon. This prevents khugepaged from
collapsing it again before c->collapse() is called.

This failure was observed on NVIDIA Spark with 16KB page.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index c32244b565658..1aad4bb427ece 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		usleep(TICK);
 	}
 
+	if (!strncmp(ops->name, "anon", 4))
+		madvise(p, len, MADV_NOHUGEPAGE);
+
 	return timeout == -1;
 }
 

-- 
2.43.0


