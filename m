Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954BE606D2C8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HQVe4u8C
Received: by kanga.kvack.org (Postfix)
	id 0BA9B6B05B2; Fri, 13 Nov 2026 10:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF936B05B3; Fri, 13 Nov 2026 10:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B526B05B4; Fri, 13 Nov 2026 10:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9DC6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:59:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F378440277
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:18 +0000 (UTC)
X-FDA: 85430555196.03.C0291B0
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 041734000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=HQVe4u8C;
	spf=pass (imf12.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.44 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794585557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/inMl5ihTFO44VU9pWq4Bx3NmmHKW+CV93YX/kcCu/0=;
	b=yIPCdE23rzdvPV1p7EiCRa8Wp6jGvo4SJqPtpQBX2t8Q79aS+vm0LEf+rq9SB9j+T5OvLf
	3ZI138xr8wtgRnlOcC7VPr0CT/IKB7JiNSNS3xSYcSARb8w8sH3vk9fQUT9R3qS6YM8owz
	JZclhqzcmbVbJ1ReYamoJk7qck3hcl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794585557;
	b=T74NyaAIxYnLpQIt+2eodbpbNJXbw9mU21TKjUEfeDScBHVBWHpHs/Izym7BNZAlukji9Z
	Koqa+mPpKDHaok+27KHPeTIgGvUvSDvNh+XSgQMzOZAFVDIOhw845GD0xKXQ7H5OrWOYQU
	dhq8DhuqTegki9jAT/30Rc1blSw2TZ0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=HQVe4u8C;
	spf=pass (imf12.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.44 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so750396c88.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794585556; x=1795190356; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/inMl5ihTFO44VU9pWq4Bx3NmmHKW+CV93YX/kcCu/0=;
        b=HQVe4u8Ck0qgqZAEsVBta3Un8uz/7SipbCrNnpdyLRc1Wh+7zG1G0LNQG6Vfyn4vw6
         UB6zeVbUM9W2OwjKS+KdhazBDdF9VXXoT48h1qVEx4P6ameozAIt9Qk3u6WB10jor6Sc
         uYf0b6lGAsf1AMoYaIEqtjBWx6u0Pg8oFtVyUBoOeIGiyEN4cAmbMHW0fYYD47zFfUNo
         PNF4R9JYbMvBDmt079VltXggHBXMZZF4nALRZtYfcnmEnKNiEpGLT4cq1GGIq2m/+Dsf
         PkABlZunOf/iD9hXu8g8qEUyeS67/kLzif/ooInU/9BdLkGl+OwihzQIBjy2I/2ji6mw
         XgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585556; x=1795190356;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/inMl5ihTFO44VU9pWq4Bx3NmmHKW+CV93YX/kcCu/0=;
        b=urNsbAFwPFaD2HqjMDFAF8gK3ReJc5rpyERFABGEXeBZatM/Dtt9doccIXmsG1154U
         RPISwgQhlx5zz8opACFu/PvNDc42ww1usyA6CIlFJwFORhepDuAOtH5sikQJQunOGQWZ
         LQswlQdFpJjcAfetOIjfGjDm1L9ZmNKR1IqJfPlNmkLpAh1/F+MAtyx6yB+m69HxmNQ0
         GbLCdQLM43OQ9XY2ptZrLLjQqaoseqAlmG4wqq4pQW0E/Ena+kJXgo55iRenlN5eR+cy
         3wSZPvpDslZx7GstoQCu99D7JhPUKXHDKl8921mAzVvrH4peTnsBzY2CocWPzBJhNbB/
         xUdg==
X-Forwarded-Encrypted: i=1; AL+hErFtY68F8lSqIK9yYAYRkLFzCXeJShEE7Hk21AfeGoGIwvuKd7RmVnJV6bKNF6SxY3FzqPytc/+scQ==@kvack.org
X-Gm-Message-State: APuU4Z84u/zz791uE8ldT8h0Ib7mGY+XBa8MifmNxfb7ZvCxzA3I9tmi
	SSFHdX1jueP8BqF0Ga0KjEXqCuYzuXY54FCDAnj+rm4rXSH0chizvhQhlZrNm3NK2mqEcY9UVvV
	GFRzIa+Z+Dg==
X-Gm-Gg: AYBFou2nx8bnc9U2PODrABBLgg1Ebq3bwA2uXcxgWlhQok7VsCmsXr6OBFhhjm8w5C/
	/L8ATazQXagwssvgpQo+xFcg90Qvy7T4FvfVlY0qPQOySY6+ItuS6CHS2KspW7S1rd4MvWSoUjz
	URGWJrh3l8AapyODzLVoUB4dOovQjtAYjfCEwQLwsITHQiTcvPnfkvJJO4Gu9QSvLOFli/CF9U6
	uzBLlURRrC3U676e71VXPd5NSaCCQXJBfm99GwZajRziGl7BzEw6/Qn+NlF61Iwjl6mQeHtN3S4
	8bhIGJQdxyjw+Ig2DbtR2SQeOkK9lbUC/0cJLUuCKb8Jlc+WUNuo+btJckhfIrg+TKh+/oy3+rC
	tcIUtAfwMjZwkKt34QGUUKpg+8YWJPwx/UOhqSCMMq3AyTu0RnR+SrMuBP5whnaHpRmBd6ZV3bM
	RGmloifh+Yzm/Fl9BObzpDOZdlWNLGrLKa3my5rZXuImWQ6jc5Sz8wNEeP1q4GiY5vs6dYr9QKi
	FNUijpsZy9m+ZdBojWXtGHO12PfQEQif8UNL3+Dz+c/x7CTI2DvLbzUYtouBnZTlpmZbMsnCa4K
	+vSTpiP49kDPSHzbSzYPZFZXNgwqlb0PjPT0RHrGx8erxAp/+pE=
X-Received: by 2002:a05:7022:7e8e:b0:165:aced:1fde with SMTP id a92af1059eb24-1b502fe08c6mr3364841c88.0.1794585555597;
        Fri, 13 Nov 2026 07:59:15 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031bc518sm7868383c88.15.2026.11.13.07.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:59:15 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Date: Fri, 13 Nov 2026 07:58:55 -0800
Subject: [PATCH 1/3] mm/damon/tests/core-kunit: test
 DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-test-age-ms-filter-v1-1-b99eab2f71bb@ucla.edu>
References: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
In-Reply-To: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Stat-Signature: eak68pwkqxykp4q6gcp4oqwtxcrx7b5q
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 041734000C
X-Rspam-User: 
X-HE-Tag: 1794585556-385839
X-HE-Meta: U2FsdGVkX1+fZKIuyc5/NtrhM21KDSXjyCJhOWgRgLkrjYHjqbvLjwzNNDL2Ka9CdRWWRIUTI2rXfD/ITNKVSppQBU0NXdSZDTj79vcdeNwNk4P9bygiBnvNOc1rudTaQrUGo/0nh+ysQwkIMftQKxJam3CpV/MN/A/gfHGjzg85kyznvU2qbGPMY4VMuTna1keVcYwYpAzGJtJXoSReZOm0Ixtj1VDAdAeOBMsVI0KDMdTZjug0pbplO2Ai8y3ynVEdAuZu4UNkW5q1lAwnweSWRKghqSHzVgksPnpWcIoz2wdVkzJwdd4r8WOZKoQptVJGjv4nMx0clmcqo657Y93DuxQpYBteXulZe2Wrf9Rx6SKFwG/veHGqCTvcPvv6eDuhntWwq2mP0Yy1iNOB2m+U8WEibUl6yxNQvivFkQ2lNgQqYuU3HrAgFXuA8OVZOd8Z9uyb5uPBf18utw6vGjOgKOrf8yPYjJXcJJIba7zkZCmTPwrGbVCMw+5xWwYZH8IqajoXipsT+ZMuKavfExJDWwAJXjsJqC+yIF1G3B9TSX8bYFX9rUdaZSx0Dey4iuQCl/z0zfXNPL11fOPCDvxNFN00NAPLMUjlnImJti9sI0LzCBZiSCqIWB7Ri1fBDKdlP8sae3ue3lRz96XPgY9VQ1Dvh3btov7mgyYi027FyMqEBY+UjJ30hCoQ1XD62x6ahjk2Mpy+ecsbUFCXYC5vPqsoDzNFk1eYbEhq4b0W9aH8BFlhvDrubBJj7LLt4VO0hp/A31/Zr8mb1Ge3vJANH0Y62RqqGsv4uTlaS+alIGmp6ZTZHNs0wTaCjzsJjeG9tYM+KIzQNwvbB/uINK5i/HHD5TIfNazRSx+cRntaUV2npZbKhRlE39ANWhjDpXfUcxUUYT1MdTMpus6IhfSU4wr1EhA5QEGjF7mIK6IzcOpYbAx7OEM6WELktGNFubb8rwcVrbzy80BNoiT
 z9UpRWV2
 vSBLt8uZwEYyQLx8emQWSBG+UYeJulBZw/RC5cpBTdRr0ngd8wDX9o9R0ylBTu8O4vRtESCjue7WLgbzC+8OLmteXqDICx9BVvNPXEcV+87eH0vQU8izNZGf34v1eRXinRl0vM/N4DAL67JKbPmxgF7l3SmHAoBe4qZnvKGcWwbmeLX3Ym4Rg+s27N2zr4WvBrXHFQs0SOuy7+mlCtYDOxiRKYU+Uobx6HYwLZD52am/bGtip7bO4KK8jiGUVsUhpMlitT/lb5g6XWglj53BG+42nRUkvd1wbghv83VKC7bRFrk5GLSFZGVoEoqVlHhGcEVLK4yn+3Oys1Z7Sq7uHBwhmDHnEMfBA6u4sBH0VGzp+ti9sxaYfCk97jCKY9dkrE7oig0GcZZ07gDFADNNzJRF0Z0gFAlYoZUhQnrV5t0sDd6dZbso39kLah0oi69GLhlkkkoKGyLEZTAHTt1YUYmCkGU59IUw8IadXvRXC3Ug2EQL8EC4I6nIN7JpCpBHdyYxdYellWDModMvaLpm8rzSVHPmtE7wwbwSZWtNM1Tqo6lmJO/pVnFJld579Vqm6uojkplyB5iru8jQ2GmrYJSEf2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

add kunit tests that commit DAMOS core filter type
DAMOS_FILTER_TYPE_AGE_MS.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a5ca4bfe2f0d..0eb5dcdba0ae 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1271,6 +1271,10 @@ static void damos_test_commit_filter_for(struct kunit *test,
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
 	switch (src->type) {
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		KUNIT_EXPECT_EQ(test, dst->range_min, src->range_min);
+		KUNIT_EXPECT_EQ(test, dst->range_max, src->range_max);
+		break;
 	case DAMOS_FILTER_TYPE_MEMCG:
 		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
 		break;
@@ -1304,6 +1308,22 @@ static void damos_test_commit_filter(struct kunit *test)
 		.allow = false,
 	};
 
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_AGE_MS,
+			.matching = true,
+			.allow = true,
+			.range_min = 36,
+			.range_max = 14
+			}, true);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_AGE_MS,
+			.matching = true,
+			.allow = true,
+			.range_min = 14,
+			.range_max = 36
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_ANON,

-- 
2.53.0


