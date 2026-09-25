Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30A0C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FAA6B0088; Fri, 25 Sep 2026 00:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EAB26B008A; Fri, 25 Sep 2026 00:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48ABC6B008C; Fri, 25 Sep 2026 00:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 144046B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:53:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 828AFC03EC
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:53:40 +0000 (UTC)
X-FDA: 85251066600.17.C88F541
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id CBF68180003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:53:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D5vuQXFN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790312018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=REUbZZ1eN3AuH9mm9MMP7henzS05a7UB/qvCM8QAct8=;
	b=eNxZfgp6wnbKctlzt+M+QSQjnZJPwsFW0+BAmzL1evxf530YoLs0ENvTm8aVvGErU1TwIa
	DCu/lxB6DG+UUlUFgjerSKM0FtV60fvbIfYRua7HzUKqPO9L4RenKMX/ZkmXr9rLgxWhEO
	mYUK+iiuX4cV3d4DEUZXoz3moGjyKaE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D5vuQXFN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790312018;
	b=2Nb3dzN/qPx2CJ6PFlSSx5I4Bl7rV6q+CfT1eGnNbWlmjk1zdoNZDQsDbI8PNWNQZFmpp5
	w2EYiNyfxkhqXbr2Zlm/AYSrrUYOup3q6/j7GHLsWpghFiGLFnr4QuRYk6wF7UyEqOfSfR
	5pdiH9iIolv1NU2VbI0ZKaN/ws1ARfI=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so252302a12.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790312018; x=1790916818; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=REUbZZ1eN3AuH9mm9MMP7henzS05a7UB/qvCM8QAct8=;
        b=D5vuQXFNTne5J6G5lKBQgxTyEQe6b7xNJ9sou9Lch7fMPR94EmcSPAqyZPerNoVn3f
         VFWIQsLFQl4S3i5OGF00dVuDE9WtMk2CdeUPmKpKTLKku1VdqUp8IeXcb7vfINU0oyNY
         4bBJGwo4qYqmHjUPTLzlZnvB3i9xquuPuZYaR1nM5WHp0QOWk+urAJmo8wQ0PGsBv9yo
         pOI95wLypdxV3Fwu/z4uwfcsUU67n1GFlQwRWLO1ctwftgFlFdd5XxgoIffnIzS35zNM
         e0KqKzh51r0Os9NZBRlwo0U4RXe3ogg7i5zaUX+/3Car+3g4nCgeJV4zjuRhUazMTW5A
         Xhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790312018; x=1790916818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=REUbZZ1eN3AuH9mm9MMP7henzS05a7UB/qvCM8QAct8=;
        b=m5RSV/lJoww5OyLX8mUlu7lxpUYLqOGRpSL/aRF8LVSoECsYuOeweK3M2psOLLFFyE
         g7B6ENzsjl5mG7CmieJJfBafe7t0Ua2TyfeQCtmSuLl5diV50Gtt6cwxgJM8FGLXDGPq
         cxPsHZKlfdMiFUkbRUfZb5qcsXEJZXDnPwB8qMfpNk+pbtljp2YtvPs8egST3g2RAizO
         BIwtCWXgeBT/dTXUy9RPqamyg/tM+FxSOF2Tm5y3UeZ6V5OOQLZzFCLlNJ5Ep3zXp0bx
         pDpeE+92ZQOqnFfV89LctnKHDG1CYPPJS50IzbRCPSVBK/sUDL/qetznwnu9uoC9qfuZ
         ynvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDXnLp8JRjXdBvDLlpRUVglCgosaEmQmO/OmQVIxbCubA/RlVzR8la1r+yY4s3pJi9QzJwYrhi1A==@kvack.org
X-Gm-Message-State: AFuF++kh3Or91HrFeBqSQ3WqyvS79unzjKuVOsbXqvCVmVebokxdXC+b
	e4kj1Y41tzv7eR62B/mkANo766JD50jTAaXqk+jJh/SQWWOzRLeFT2BT
X-Gm-Gg: AYBFou1n5jfWG1WCt2AuPBN3muUZVx5ci1bc4+j/5pYK7LA0D+3OJQVzd9fz0vkG06C
	rBJw4v8MjhQWUGR0/1abDqy5OxfgYF+Palg+EjqT0TtUSdviPVf5vd14FVCtbwaG6xE10mBk9uC
	lLdujGmSi/CFbHpsUBFSzsWqccED6DnwEBfTov5HYA3XRZbILJEx8ezcbrPtgWexojFaBnElCIq
	0myCoGSbhgtHinykqKGsk4+xI5+RHE3+/hLT0BM4EEm/bFHGmcgmUyzK9ivswxAu6nfnArnDcl9
	irvrsz+figwM4JFDTh4dfb9gq7cRdLnAguguJ+kmVpohaZduCng9jphvzUZ5ojTD4daK9fClzsJ
	YpkD/MH9Dt/wIyBj/SDI3d6RvkA3Han7nkGXC9/oDobjpEbbTffy/Nx+rj7AWbsNaAOmFcCQdzr
	HC4OsHKRzJlEEMF3VX4gAvNGwR4fL4bfOjNW/a1EO4Uyi8QAIfNP0Ahq8VA5RLDpzwtx5UhKFR
X-Received: by 2002:a17:90b:1dcd:b0:39e:d36c:ee54 with SMTP id 98e67ed59e1d1-3a0bb55308cmr926280a91.5.1790312017647;
        Thu, 24 Sep 2026 21:53:37 -0700 (PDT)
Received: from celestia ([2402:1980:867:387a:70b:38f1:a1dd:9303])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9589bbfsm2053242a91.9.2026.09.24.21.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 21:53:37 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Fri, 25 Sep 2026 12:53:35 +0800
Message-ID: <20260925045350.66595-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ehihnko375iibk5td7wba1t8qx93nygr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBF68180003
X-HE-Tag: 1790312018-833276
X-HE-Meta: U2FsdGVkX1859+ZwOrKYWJL/ltfEkmxoHeULx2Iz3m+//M5SEh/140skacU54p1p9H6k3HFtleoH+BAWE0v4hsrrXX6XYKlgxLAx9OXAlVJNDlcN75bILemZZCnQK5NdrfN7iMpzDX8sowmGJUWNQ6HcQGl+JApqUqDB5bQrYCJr12z3IpHBBPvChm9HFPbG0PTzzFBL3q9NardlpVTkSuSWcSmlMA4HG9RG8KjhPxwzviD2UxDkglAxfF8Cvpiv0SnRThJLxYkDofktm3BkZIS0UVUuumVM+oiQm2UjW675xbSQ0jC3pD+s1PxObWuD3rUHR++D/xrGePXRKpcpIaQ4wrDf1tjduPPEadECZhCWmoYMmKCTMg2GYf5nfhW4paKjh4PQvSwRHqhAoLfT1CCYJpkSA0iQTTvvXw03MleCG4dFuwGw9H63/FMNP0FQQYNOqPUK3XMbM70OMUTE2EIla0DoRBXDV62FNdrOwZ6yzlpNA+Pu/pRahnz4IuIPstuYF1k8xj7Nut8PV5scXCd6zBGy52sX9wNoHUnZE2Mu7nMBz+Ds4h8PSa+obRFNUEOqNDb54nKW0OolkQ8QcN7BYSGHnwnI9CSJJkx6REQkXg7J6x/cnBU+YR3cmG4+6OKXP1cBm+KTEm5vRsme6Adbb4zXYc/aYJoNUMz2Dw8of+XRzCnkX2orKPsN9/Dez1nxLipOqluIJfKJWNb3PZ8i/Z0W43jReEwtUEwqIbCLe10NuqsqmLWNttV29ZkVTF3IxydQkU61ebpvGddemXm7BDajw5FlatYdg2UzVNhCY0MQqIEpObZDB8+B60Om2eF8hbtypPq/pT7kVTVWyRSDoeeLmq8rIjU1hWmCU9n+0L3F8NxXM/Yh8cRATfurNYC2aQIxrEzrPXZMI24eoDYRD9bnSA6WBmC/haNg5ndQvGDrZU99MUiEFiQLSMR02woWgw/bh54Had8M5u9
 RZaaMpVg
 2wK1+isF57vcos4tfWO3f/9xOkJJELUFmGYflGFojxnWv7zO/CYkrnJhNWjndeS1daocbmAh7GX/6EmAOfxK+VbQjH7+nAEf08CieKftczkzedFTbav/cKEzDO7Oqi34omwH549stmEyrBkt3YwJ4b+SMafeFt44iAkxL/fsYuWH/ZxGd4dPXkYdmcBrJ/1dBUn/O+jCxJ4lK5G+3u7DG+Hfe41bUUD/WwuKeLg9M+LFQTe5u58Y//6PVuquSKKwgw/JPsTeBKUjmk4J99wvpreYN4zzfMUN/yqnJj+to8woy2bYdtbQ0QTmajLi1cyARu5W1f220VEV1JqY7rXybq3ErXwTvafJFxH9Y1HneBj9Jg/8U7FglJnIIK6HY3n20keoAoa/PdSBYnJFJK2ee6e8M2Daxmw7y4I2NAoPQhY2FstjGZ7TfZc750rdDmPQUvLTo6Li89W3HkGvEgWziVw4B0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
regions") introduced a minor issue that causes the last region to be
skipped before it is processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

Add a test to prevent this regression in the future.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v1 RESEND:
- v1 RESEND: https://lore.kernel.org/damon/20260919080453.628679-1-aethernet65535@gmail.com
- Drop braces for single line, as suggested [1] in coding-style.
- Set min_region_sz initial value to power-of-2 value, '1'.
- [1] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces

Changes from v1:
- v1: https://lore.kernel.org/damon/20260831113735.3349-1-aethernet65535@gmail.com
- Resend since the dependent patch is merged into mm-new, that would
  help us getting AI review help.

---
 mm/damon/tests/core-kunit.h | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..f4237436e1b4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1632,6 +1632,47 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damon_test_last_region_quota_reset(struct kunit *test)
+{
+	struct damos s = {0};
+	struct damon_target *t;
+	struct damon_region *r1, *r2;
+	unsigned long min_region_sz = 1;
+	bool skipped;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+
+	r1 = damon_new_region(0, 100);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region 1 alloc fail");
+	}
+	damon_add_region(r1, t);
+
+	r2 = damon_new_region(100, 200);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "region 2 alloc fail");
+	}
+	damon_add_region(r2, t);
+
+	s.quota.charge_target_from = t;
+	s.quota.charge_addr_from = r1->ar.end;
+
+	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+
+	/* 'r2' is not processed, it should not skip */
+	KUNIT_EXPECT_EQ(test, skipped, false);
+
+	/* 'r2' is last region, it should reset charge_{target,addr}_from */
+	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
+
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1664,6 +1705,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damon_test_last_region_quota_reset),
 	{},
 };
 
-- 
2.55.0


