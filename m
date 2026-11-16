Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F7D606FE9A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZH3cLIbV
Received: by kanga.kvack.org (Postfix)
	id 39CFA6B05D9; Mon, 16 Nov 2026 06:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3760A6B05DA; Mon, 16 Nov 2026 06:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2A56B05DB; Mon, 16 Nov 2026 06:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5406B05D9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92170C094A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:51 +0000 (UTC)
X-FDA: 85440704622.10.01212F1
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id A0989140010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=ZH3cLIbV;
	spf=pass (imf09.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.50 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1STAPeBDhVJdiPrWnEBENabND8c5F/YLGiEN4UGv2I=;
	b=GOCcLJ85ykLpRVcGASFsCxJJ3gjXrctk7p7L+uGVg2Qg6uKrXtHt5WfActEpr1e17jAAzl
	vbLBl2f7l219wLNEEaDRDEnpTpEO+it3b8D54OluR7OquSgnNjeQsOZ4qJBk+YTI8kTVUV
	bFqGNEAbjvZo2bw2PxbG5jwlGnrQIxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827209;
	b=5i6x+L9TeCn3PfT51T5iI0aYwmSxkQW2pCQI1TixoVvHgpwwqV1ehv6UNleUbyuFDsZ8W0
	gjd/NZmqw4YJB+sBUQUglUGKtKUkvlPsxbdAIdZHXz+wERQCA/nOkTkJ7ckqNYNXreFln1
	tJE8P5R0Eu+CcBf512JEpzIKR7M0hF4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=ZH3cLIbV;
	spf=pass (imf09.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.50 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b244fb7fffso3725575c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794827208; x=1795432008; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n1STAPeBDhVJdiPrWnEBENabND8c5F/YLGiEN4UGv2I=;
        b=ZH3cLIbV45krv+lz6VDq1JF6CPwwj9M2Xhau1LKPf7tSJanQBGZOPloKB/hVuUOG59
         Iri5wSSU7GXZVkWpKi6cXt4gPqvEhoiuxkBFj71XvkowGR4YKYHbhKITeytzGpsgo6Y3
         OA7xLitAJU3ZTNo5FH0Pjgc1LBRZC5iYXjYyKIM8I0pXUBz2SakDMp6HRE0gooeZllnT
         l+QTFHzq7rQpUZ+Ek7yAH2Hzdp3bkDwGzdG2SoI4NMBMoDiMLPbm6hKTQEDyweNftS9o
         1VxNSwo2djNaKe00Vf5a341A20R2UM8DlPbUzM15VZT1Y2jQNHXqSmsbJU/fT4GKc34S
         X/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827208; x=1795432008;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n1STAPeBDhVJdiPrWnEBENabND8c5F/YLGiEN4UGv2I=;
        b=z7o/Ad8dhDAhY15eI2Tw0cILMVtiICEiKtlK4mxB/UJhJWt0WlNuYDpF1EpwTS/BIA
         JnNt8QP8eCFtVnWPgpjjlJDY0AdViDaxCgQObDEboOkaWev5xqy6wDNUfauSuDKcUbh5
         h2GGJ0jkksYcJZDB8CGwTQZX83mAtC+ac3hRb5dcDKz4MjQoZqm1T9cy0K5sJseZ1CDL
         99LM5JipUkd5Cxe8hnoJpCwY35fG/Ci1gx/0EGSuWBpf6dcNfqB1IiNjzvp6D64KImPs
         z2eIF0DwiQeDI7Tu2H+X56fiab6G6E6CRFqkoHS1p2YrBfgQ0BkzdOCMTOZHiisAogzO
         +83Q==
X-Forwarded-Encrypted: i=1; AL+hErHBx7cZggoJmGJoOwGyyAceBkw20dQHXB6TVZmUD8aGnokSI1L5cw/fvh3370YB3h8I5DCzClG44w==@kvack.org
X-Gm-Message-State: APuU4Z92Au81bGdC+G6D3gL5dnOktgtveVIR8QIGsoMwvOfLdEm6tM63
	EKyd6Co7eavOSwn2plh2O5oZBr00GzB/TpFhUylpHkpi6d0I935+Mrd636WxNhF2Pwo=
X-Gm-Gg: AYBFou1savf5AIXQaU1okD44Z5WsfGtkrCfzKm6VkJSj86rcyYY5wBk/mwZneQjZcJC
	hGxjgT271lqmq/uU5TurIEb5kHFfBCrGG0IYJbF/1SbwOqQqkwkFVqLCFtkWPaprwbzR7wiAPtr
	tjByOVkTrxuVPgP2OdkIQbww9ls6qCuw4QE9mLyrITEMJBns0ZgA+E1L82GCYjAR3qv1H+KgDWd
	D7VqWuCkZiQzkRj0ldEOKp9hRprpxmRMBhiqCzN49mRwlgB8bX992TK5d+KArR3WVcjdIs1BQuv
	ykUEsBiAKgxdPSN3n4Wo5eeviXVAA4UNPy4oYafGTyMNP2g/lZTY9ubkESbodGByBwoLZ38DvRr
	TqlBhSFt02qrCfdaNzIfB6nioAlLMU63qH8eTWfQT6PgSWbosMVWEzHPB2xQ0WC63t5M4wDUlhK
	5rv7UqAj6IvC2C2OR1QgJMBSH8tqO9Tvfl06xB9KhMOVgIP/rYMwle1a41JH+uj91nw83S2Ft1R
	w54ERgsdlBz5xipE+udpB53qBuRUfooFOgaTD5ypuMPQDX5/S4nRcEcVzh72rV6EIFU91+xD8L2
	4ZPN+K5bhIQOe9ARRWgN0hidWxq0KA==
X-Received: by 2002:a05:701b:42c9:10b0:1b2:6eef:3f32 with SMTP id a92af1059eb24-1b503137c87mr10395040c88.37.1794827208245;
        Mon, 16 Nov 2026 03:06:48 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b524049e0asm12522103c88.4.2026.11.16.03.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:06:47 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Date: Mon, 16 Nov 2026 03:06:21 -0800
Subject: [PATCH v2 1/3] mm/damon/tests/core-kunit: test
 DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-test-age-ms-filter-v2-1-3b265d59ec98@ucla.edu>
References: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
In-Reply-To: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Stat-Signature: o3i6tsckcrpoq8fkm8op5uawdidmmzep
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A0989140010
X-Rspam-User: 
X-HE-Tag: 1794827209-619100
X-HE-Meta: U2FsdGVkX19/+jNUMXNKDquUEwGiEZtLjPw77XWHNqDRUwE4CfbCJN+nblc/binvxZpdbg6HtHZYQhE/JLP6KIdTQEzSDCUP59fNeGM0Z1PWEF0M5J9mJKHcyZdNwX2zOe7/JVSPipm2G8o4dzymRRyz8Q6KcJo8bcumX+cqGBnYzOT2HqLQhWEfYLrTuDki3B4VSZoqNY8njzn2eG+ZSmh7ktAgilqy1zKoVS/HSWMBUKZ1hXiUZ0PdltMP/73BYy4qgmywPll/myHSA3SQF0rZBw3qhO6oGrA2d4mn4c2+Xwgwa3Vgwn5x4PYWQZQ9+5lWA7C6WhzrhZ6HlzZY1acixtr9QRvRE+aOJ+7+rQoEtOZI16Ld4YwOsaDwDwGSimCFcMr69xIZm9+K4Du/9leD04f7cwO71n1SApsRqXhWxHGBDBny9H6zX9uf+ZyEAI8XG0IwYFKwJtu1gySPkTjyA0VCg+FMkOWJVpqh4sUMkqjoiK5GDIdYc0w7bvmCt3nRsoPIDKzBnpnCKzNyR6M8RpftgwK9v6S4Dis7mbv2RxodVRd3RJdaYVd/n7yFkAZeXvE4KACIa85GHw9WDkUtCdAkCWm0UtHJDo9QiZqYutvSQmZTPjN0u1NzQZcTB2Nhye7TT91VQ3voXb4uYDRh6P9Z+eiPqwzZijEZR4FO/geRBnfY+xYYgeUuitZSi/9BUJ4gqF+9O2YjW03bf/tvdpo2SoxKyHjq7hbHFgvpPFrbFTyplwvo4Hhgx/wArRx39OeNn6I15K2M9OHuuCdotEcywEt3vfgflFQOv87BacR+gBnjwOIL7cGvUdYrNVvDGF5SDPgIvmV6Yg/lAT8TNYjIObXyANmPH3x886kQk1weMCXsMT2PJvKkljWai/PHq8Reg1cAVJuwfuipdNCUCybMQ4XZTLWM/FXRFbVMQcAefEsLKNshVvyh4JIku+W2yuIQYyehLJw3wky
 Yn0j58qA
 K0v0G/hL4EwdVGhG07aUkUfDUtvm8xPsL1b1HX+YHfGRv0sHtrFrfgMjyJ7aphcUytehJMHG5+YpNN3e0RtJz+DSGw7arBAqu7znCCkFl0aDtrTCBkkuokNQskC7FsQNZw0fQyTw4i5UgvGKtpYWq9QWPWCLmFm/pemS+mj53zcGdiHrcMflMlYddBBnzMSuAFRhqFpmgR1W202FecSuDvTj/SxTXlmm+vUKbWH3fGOvY6k+nDQFwGWf6gxw9cNXqJRtnW9/hNNBjsfcRHQy1Rt1+yXSpgv2Z+ecM9MO52b8qdiSEnBplKNibU3kKhrs6i4DDV6GU8zuVx3ehg+8enlZtvBNXLXSN2i+Miqe3/lhPVzsFdhvGMkBIc+KmgpwVES1PObKNslqWq4PeQNJFErkVRupkgWvWrpz7YkxjKhoIxgvYU9BrzXd3rJ+huUwRdq3NK0hBOIImux8kAw093j3KpdyRkA7xr886Qjj0enqSYM9FQXBiJnrn4eI8pa9uErTaG3w7eMANkM8jgjHXMOefRthw12upBbJHQVOb0H+VcYJf4EmzaXMK5s6IHKZ2wIPq7TSAfxEZEZcZJJlt+ymJOUIZhkOtqCL3/NJqfeySMNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add kunit tests that commit DAMOS core filter type
DAMOS_FILTER_TYPE_AGE_MS.

Reviewed-by: SJ Park <sj@kernel.org>
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


