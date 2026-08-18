Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6D7C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E776B013E; Mon, 17 Aug 2026 23:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06076B0140; Mon, 17 Aug 2026 23:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4636B0141; Mon, 17 Aug 2026 23:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6940D6B013E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:46:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C903640A4A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:18 +0000 (UTC)
X-FDA: 85113002436.30.04391F3
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id A1BCD180009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20251104.gappssmtp.com header.s=20251104 header.b="j/NcW8xx";
	spf=pass (imf24.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787024777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcV78j2ZP/Yix6CCbssJ5cpLVJY9XnuazqlvUAmQ51E=;
	b=gtq9B9HJO7EvMkeZOFKo8jrDV1RR3QyHQnHLuCDJlhZ1y4pd95B7SEBbIjmps6hUHeWmxC
	W1LeZN1obnFA6HgEzQYq+EL6B7PRPLSsdg7mlmGyrtfvrDuwxMaYSqG5h3gHXXnvdNHjTQ
	6gYIYOKQM6pTWdipxmmtOOomXA6N/TA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20251104.gappssmtp.com header.s=20251104 header.b="j/NcW8xx";
	spf=pass (imf24.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787024777;
	b=4OLOEztxV3Y4bpdpswgeDoPTnwl3lJpqHMqwBBFMA5oDddzfWPb2TivijKa5Edd4O9Bxn1
	i+aRa3GZ20nH5IzXEen4anCGE2aXB32x5wrNfmwSnZaQWD3dqnkqWVf6wBt8aA6w/pTmvD
	RCr5/dN2DhxOAUG/zNuMGhOmCnqK9sU=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d049069377so43223025ad.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20251104.gappssmtp.com; s=20251104; t=1787024775; x=1787629575; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lcV78j2ZP/Yix6CCbssJ5cpLVJY9XnuazqlvUAmQ51E=;
        b=j/NcW8xxrU0+FsAC34j/jpMletbEKaEQE2/9aZsCKqDZJLvzckltShFIlIgKIwqZk1
         8aDTNGk84k/+VohtJ6aX2OyGUwBTic34CV19+ZwlniI3tPBx1KZbFEdVRlIcV/M6QSB8
         wbEgkndWnzu/gT69GJUz9o3shBNbehQIx1amWz8Mih24GICDxz2hpNDiDInxgA3WcYNu
         W5npXdCY0JrOla8A9PCC5ykDCi0Fqx+h0HXp8khgjwsjdfVIS6NPz2caGdYr1DNyNldQ
         bqZkwYWNPfqZ1f9ktjrxX0Y1gXV6pctwWK5TOeTKXqePeEBTTRERefObkkRnGlXM1wE/
         yLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787024775; x=1787629575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lcV78j2ZP/Yix6CCbssJ5cpLVJY9XnuazqlvUAmQ51E=;
        b=XJOJA1x2MY9riBktSIZpRoDTxmhWKNPGsWnCnL5sIkCbnaZrmvsHsfpCl+e6JsVTx8
         9qVjVdr88ovIgNWcf/v/M7iScES3lj1jk0nnEGqmlIpi+czmCQRtzSwSesHw924gKm3z
         pjtiGZpGXoAfI10JmpZQRz8b1Jzg/6x65qtvP8TplY8WIID7qgC97DwYiQlwEeFnMqqQ
         qtcjDnjV4+8DLrO1pTRyLj3qiYZD4WkQtSZmm1f7/F634GG0G7HsB6ahfqOVgntyuAo1
         vwDwTPmXhySYNoln5prehWAE39pZMBdTuZlvxonvCr09H/WUvVevIE2nyuz+NVQlGLxj
         rq0A==
X-Forwarded-Encrypted: i=1; AHgh+Roe3hOrtNOwV0VT3RqN2C0eoNoe1aKUyfcQgyE+hrqTM/3DLM6KGDzxooEp4zFOh+WF8qcyMYFhTw==@kvack.org
X-Gm-Message-State: AOJu0Yzi/2xrcCvat9VR7vV12E1fM38ohNilrs7gV+yyFQLoMdzmJsVl
	dg4lPssqsWcoRAoEZrD7S0+Z8xhCxmb/myVxTFSqOWNfKU0hp4/L7SBQAcvFkusRMsM=
X-Gm-Gg: AR+sD102KPaDRMW4fjPZYuJUQSvVp2ohb+O6jfwRDmXzQoDuqpsF0Wa4x5Es8K41GnN
	Trb0lJTFHw+wib44wESwh0X770XLCJGMyl+8pp5nJ7Q7sOpQAk4Z/2s/naRGTJPpjS60vlnrkuS
	kQLJ/5pGrMChDTHuyi1ZjvXObUbcSS8ujezpXzYbsrAIGJBarjdRn6oONtl1xFHIO1YY30r0//w
	d5EiKU2JqKTwlwwLelA0ifOuIGBLFFbf2Kc6BuVNX5JlZ51ppmEwTG+4sRXlO7gPnDnMniT9o8/
	IKNB9YoqxfQ1/sT/zMM1bsoPQTUgoYKr3Dc8iA0e8mXLNs74Wt1lNV58ioNy+JzVklu+F1RiXq3
	ZqQI3AO4dhJM2ztkzRa2lO7iJQhLExZKSVAHizw2vpjFdgPWvcR2RS3u73sAC/tDY9l9lqPNqud
	iOD3X9HX1UvXzXlyUAbxvhVO8W3iEyx0Bm9OCrZrASRma/J/3s83yAYhZsIO5w5lKo9Kd16yizl
	rmgC5gwrBlpmIkz
X-Received: by 2002:a17:902:e950:b0:2d3:a6db:299 with SMTP id d9443c01a7336-2d3b0c312b7mr344343175ad.6.1787024775405;
        Mon, 17 Aug 2026 20:46:15 -0700 (PDT)
Received: from damon-kunit-dev.tailb106f5.ts.net ([73.93.135.51])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267be8e35bsm11453293eec.14.2026.08.17.20.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:46:14 -0700 (PDT)
From: Jason Angelov <jasonangelov@ucla.edu>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jason Angelov <jasonangelov@ucla.edu>
Subject: [PATCH 1/2] mm/damon/core-kunit: test probe_hits handling at region split and merge
Date: Tue, 18 Aug 2026 03:45:51 +0000
Message-ID: <20260818034552.11975-2-jasonangelov@ucla.edu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818034552.11975-1-jasonangelov@ucla.edu>
References: <20260818034552.11975-1-jasonangelov@ucla.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1BCD180009
X-Stat-Signature: cpps5nfk7k756xrp9qfekk9sqa9g456h
X-Rspam-User: 
X-HE-Tag: 1787024776-54744
X-HE-Meta: U2FsdGVkX19bwhcHVdwyDMRehEvKjX2yS4Kn2XaG+fGhb7Ewq/6hfUVOdJToJhj4j29DkjeuzD1dJB5G+S3VYII3rx4ZJPGx5sqKrjE+ctxtdqX2KN0vv5TmLeRtWM+RbqSM/l5Lnn0YXml7Yn0xtMNbMCndu2KbjX2T9i1EnLrxKdqu+SGdS+kF+95ZXMw43QAD8SuxZNk32PctaT7kG+Hcq8wEJKJLcdCZSZT8XhEqnLO0EGxLj4Eweljr0HFIG5ZcTn9sZ+UHQkhv63BYeEL6xWcQTCwa6KrxeG1GD5wZl3tFWTOVWBIu29QKTE9fH77mtOxdGAo/GCO0uw/FgWTvKMV35eOomXyZTQZyhgPKUBqv6UypW0vBfhWysSKZCUcgJNazqxemkUwC18KvgEV/crZka/8cZZj19hvCHTLN5Pk7WEYASg6ktsKr2gv5utVqmr53xBDXqGTdTBz1hPQvUQboehSEm8fVqKfvxXG7DORXKFfoWVYNnFSjkKdn9qgIrxIR8qrR9/dKu1qk0BLBRRvLh7knKFCKgj2ULmlkR6ljftE5SPN+lbC7OasZSd5/cCpGR+bXbEq9b6Oen0asjZFKPE66VHirNbFbyr7aNRBD3F4e0tCdv8nUom00/xTR7Mg794Ajjpj/7NHuCNT8RRjP3ue+1eJE4y1Rljia3HeMx+7ixNNrrH42D3U34jG/q7ha4Ye4UB31Z5ci5gKqb/x3tvbEaSGILr80YBTbfB6ahu09K7aEyACymj6QjGH9qi0fGBjXN3m1lfWYaERU/3OBIHDKFI2QhMKGe1YuFjGbZyXu22/2YfjHKTsTq3Fot0OLwE8dGGHHYVD7iL9vfn207JeTTDWgxRiuHRlGLT/9qHiKFztzPLqPMk7+0cb2u0Fpx3QmJKtqkQ1FP2ybk6EvN99xxKpfMZwrNOR7TgEVta9VyHJ4KwiFoY8Z1WVsMu1H3WyceX6tQlI
 lW5Y0iUe
 B8JIdQW+boT8kTPjutsPn7QlQnj9aexIAOhASScgUHXOsJlIuvp2E3hy4GU6fn1ZOWp8Qik6VADNzC3SGO/3PB0FNH9MyCIRyxoCdGPLJlT4n49zhb3I3mRl8bhCTG5hicJAoGXENyXy+laoQqiMtaPcvmBNrhcVyMTKL5sh8K7PuDGfXFjyTwopuTLoqB697KtMANYYFKTyBshMGvVsfp+ZBgzegPGDREl52CzUbX5qBncsiME4cTvITYcqKNHoE6QyfbeZe1S1oDHcN3IVU9ZcCJ9Xpe8Utwv9fdLD1T/4MUr3mjbF58UwoWN8pyD1uNMm/88GhCZRyZ021kFprlPXtJDJVGnBdRzZiuo1+gVyclBsqCv/a+dCZwdBUTX5q9zF7lj8/Sz0bgkoO4+h95uC+uicgRmp51NIHoL7rI6/6Hkll2zxPp6aFZfU5KUXNlH0KOfNnEeAy8tvAj8HG6pL9S8MUa8Kq68yI2lMOwux7W9bpykFcGomudkcE2GgVJScU8h90eraZq7jA9jnrzycmUL1p1NOhoe2K3xkjKtv5uuUgi61+Z8ONuVXAq80NHQNVENmQpmWBim0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_split_region_at() copies probe_hits[] and last_probe_hits[] to
the new split region.
damon_merge_two_regions() sets probe_hits[] to the size-weighted
average of the merged regions.

Extend damon_test_split_at() and damon_test_merge_two() tests to
cover those fields.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..2db94d49c9ba 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -152,6 +152,8 @@ static void damon_test_split_at(struct kunit *test)
 	}
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->probe_hits[0] = 7;
+	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
@@ -168,6 +170,8 @@ static void damon_test_split_at(struct kunit *test)
 
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], r_new->probe_hits[0]);
+	KUNIT_EXPECT_EQ(test, r->last_probe_hits[0], r_new->last_probe_hits[0]);
 	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 out:
@@ -189,6 +193,7 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 	}
 	r->nr_accesses = 10;
+	r->probe_hits[0] = 6;
 	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
@@ -197,6 +202,7 @@ static void damon_test_merge_two(struct kunit *test)
 		kunit_skip(test, "second region alloc fail");
 	}
 	r2->nr_accesses = 20;
+	r2->probe_hits[0] = 14;
 	r2->age = 21;
 	damon_add_region(r2, t);
 
@@ -204,6 +210,7 @@ static void damon_test_merge_two(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->probe_hits[0], 11);
 	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
-- 
2.43.0


