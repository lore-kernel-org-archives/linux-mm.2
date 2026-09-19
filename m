Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B66A5C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95CC6B00A0; Sat, 19 Sep 2026 03:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E0A6B00A1; Sat, 19 Sep 2026 03:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37456B00A2; Sat, 19 Sep 2026 03:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7A86B00A0
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:13:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DCFF16016D
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:13:37 +0000 (UTC)
X-FDA: 85229646474.08.68F2CDF
Received: from mail-pz2-f21.google.com (mail-pz2-f21.google.com [74.125.228.21])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CCA840003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:13:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OyWxl5Ah;
	spf=pass (imf17.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.21 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7zSksbU63dtRbVANyp6hQdrkXI5XkDjvPOFv3Zg/ek=;
	b=DM2/Jv+3cWYixTKE2YN8nIhQ9f1nF3WIBLuV+YoTyY+xvhUmioqtWGvuEXhN+YR2l4TRNG
	/r2aVjzkACTRRLnOimWqFsNR5d7ZecOPuujrWDVJRbczFNac8isliu55i2bx3VdOQ285bZ
	+3XMAjCFEUgKD4wiv5K2tHiaRuuvsMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OyWxl5Ah;
	spf=pass (imf17.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.21 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802015;
	b=sioZLsst6hLGxj/vMgykbqy/tfTNpzytkgbV+RJNF0eLsFe8hIr63kZDlQlrxEvHq+uMnA
	TS2d/05+T7h7uWvFxv5mf7G32ILYZSCtTwgWm3a5G4IQ8yc2O06V9nYARcHxM7d9YzxqJ5
	FPoo6jbeSSmrgHa5VLxDeyyeoX5YwSA=
Received: by mail-pz2-f21.google.com with SMTP id 41be03b00d2f7-cc4cacd3409so1609195a12.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789802014; x=1790406814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v7zSksbU63dtRbVANyp6hQdrkXI5XkDjvPOFv3Zg/ek=;
        b=OyWxl5AhMgjL3LUu2w95YMv7y8cAsdDl8j6s9qhXcT4M/q8qTcQ5h1cRcm9rPTXG8o
         g6A285VRsb9f9yiLAvGJmfc1XGLemy4sif1dhyDBgINtAIl6p3hIEZS5W1rHLiAMcthW
         q0ZsgejD4ug4I0dF/TzUg+rBKbEUZ3AMH6a2gBezn65IMKlljbx4ptgCQZdRNWXr5lDf
         nhA/uALFhvOeQr/MsK2bubYGxPGe6dnaTEgxqy63h5KvA3BXjAybJV1u5L965knOEKAI
         IXktvxuagUHYy0HO0EXOzR7vlbintMXQ9c6mijpaZhVC0y/uszY43Av3by/okBpROTUG
         Dnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789802014; x=1790406814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v7zSksbU63dtRbVANyp6hQdrkXI5XkDjvPOFv3Zg/ek=;
        b=LjG3bDKqH34psPaZ88j7wzKzycfxgFy3ROIm0yEOd9TBz8WuIAvU7wQAlWdR9gRBRv
         d3Hp0bhKS4HSZOKHTW5G5lrMyXPo0AL+6SCvEAW8L7xVpArSQWUDI3lnF/Alet060Jm6
         efS/KUdhcrkdGOrO6MsJdtcPnYFkHRkJWVe6xIXV1YJ4shqsew9RZh4qxz/rAvpVmeX/
         GrmZ1R9IAb1n0InsJoGXpsLwUnVdvusVmLdA28B5f0UO0CLUNargwX7SJ+L7VreXRJMi
         e7v1WRka/VFyHTsLH9OgnUqKJj+GugXHFcQp569a8SaV7tNvLS+P/dTHIMwMBkYGIXG2
         snHA==
X-Forwarded-Encrypted: i=1; AKwUvByOUKM+7wDsAe3g1cXecZ6aSF0I3Yi1izjtimXC42EosvijHvE0qMG7cV033KTwcsh8OQ+k2QRTiw==@kvack.org
X-Gm-Message-State: AFuF++lmC4G+Xk3F4C91Syk+byh014wmHHUWsesnKYCzgi44skO4y169
	WmWivTnCcquRU8zF1BKT3CsTcsikWCal3LMcWIPBSc7TTMXZLEliWVo=
X-Gm-Gg: AYBFou0GD+VEd9S2yxVWeO1hrIhQ190XQd937oRJKZKOaOEENrmu41AdGgLIYc02SDJ
	Vd76bFS/15NOLeXV3VQOy/zsoyfk3cbhtkEVP+l07NY/iN+HzsYx+MQ+OGdZeJDBdBh5eIK+sWD
	WB0CJ1vSONpcPR9cDVTEi0aXuVDIjwUwWPio2JKAup5MdLUzhQ2BABqii+z5ngxOHxZwwSSN7hq
	3cRmVxlbHjeIF5UhnSfe0VZn8N7UGbHV/KdZqLcYC+LTD/SC9IkIG7wJtJ6a9aa+Y4qZzFag6aV
	r8ehHrZE4iD8fKsuI2iMewmIH73cnRwwNmc+eh5ulqf+fcSjssdP4x9Pfgkg2jtHk9YK0XxDpm7
	BUIunV3Mb9SaI6zDz4IZKjzVDGzql6vJmBGDaJjrM1P8qurDB8u/R4aECFA1b70UlUMHBEzKf4J
	sA2R/Ydu+l7uv3egCwCpBPG7oHYaD+x8ieCPai/AOVl9XtvEc0ncSwEs7Y1z+gjgLw42qT4VXtX
	JcMNg4N2mrPJgg23aqofgYnDBA=
X-Received: by 2002:a17:90b:164a:b0:39e:4d7b:b247 with SMTP id 98e67ed59e1d1-39e54ea66cbmr9161582a91.19.1789802013941;
        Sat, 19 Sep 2026 00:13:33 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:45e5:9e39:6356:6164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a02738654csm1050170a91.3.2026.09.19.00.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:13:33 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v1 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Sat, 19 Sep 2026 16:13:23 +0900
Message-ID: <20260919071324.1583280-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919071324.1583280-1-donggeunyoo.kernel@gmail.com>
References: <20260919071324.1583280-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: imhx7bo5jpr4zpw9eek18sqwdodzsoi4
X-Rspamd-Queue-Id: 4CCA840003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789802015-858420
X-HE-Meta: U2FsdGVkX1/yHjCpGpmLaYLiKTutHUIEvkdQVfwxxQEPvicBGIEzUP5V8Kxv8k9WB0LlgyU0G1Chf+kA/lEhChb+RWLBky0MMnCYCFaOR7wS1aaLt3d+0mCRnWSQkx5GS+G8xiu8ClteCl0VrU+UCnYADx3mL84uDeh+WbeEXk3ILWG+5GXXqfTeWtY6hcbJGaDUDTNRLOci1eZejJ6yPOc86biTIM3+DgR83inEEtHrClyZxQVRdnXvQq3mgd2mX5lCz9CLb8awwDMIbhDsbo/SjYIibIvYEJY+11Tgy3rJgPrZ1/6dp2hl7xzrhhpBgp7JYn9/cwaKCO+IstQVEnZWQr0TPF9vBE3VqNCgDv0V84VF3Fx3SwTSUhl86oVLyk4n1X/+g2zHJdgUEN5udEc6KsKlR3oKLBHzn+x47Qxa0cxhyb7Bqdxm285GYnSdYneG6HHdrZ3MDpHSAP0Yj7MWHT9ttn4J6vqRtDZV4A5zzEGUeu+z4Lms3besT4fQzViTp42XEyeeprB3IsKeZwJEvwryZ1alvvITyISWb7H0HVzJDLMsbF7PFW9DNUcwKspxszSz2k4VSZ4ByLlM1iHxrDwhpF/WYs3IPwbUZFkhHrCxfhDAHIPYng6wFCurNq3LiZMw/meZNKVeDYU8LCYx1IEI0RZCiVZ4bqqZnbF123+UdStHT1DQIym9DA1ELtl/VgmasAIFO1/KLY784T5ZO6QYROtWucPlJPYBUViGPqBtjUNKOw4qFf4oLZaxRmxoGNEFr3MncN9m8DvWlrv+s1I7sGFGm+OLIHejWlnjSrkU3eUpVTD0LzM03vhfGjad/0lqcqFMbHWUro2RriSKNz7wDB9/yyJ3CuEHtTCdabFPvcsMWZWA+G3vlnpkweZwg8jWz3TUZn8iF5E4hfb+3hrEZAQZ3u6boPk4KxUh2ITj56NbtHRImi+dvqosgiLf8Y7IW3HTiWeeGWh
 ztuMYwxh
 PbMhXua6Txaw21UUFr0gDw15kLrnphQq0x616x5wjDabpXaLP7ruTYyqXYfeLqRBGv+Ap7nKpiaTJ1nn8a0h0+o3NvetlNf6eKMhtpNsQodl0+bf5dXSJ/qjjq+3LeCJYTbeYqi1i07zEZHa8K9UVB7dHvORnDU9ilVTgnk3T5w+eVpGjtNBQpKAM1wDXmUduUS3PHpFv2DwNuX1Oz2VjtiwnBA0B4grPYr1Ydg7ySfNdgKfOtjlUJT0kRzWhlTqIZuaHLnPjhXUwyMT7O9TeI8FHBvxeO+0AugZ4C4XmVQhHUMRHthge7+B7lQSiq059xq9MdloPpuxFqh4FaiLF5zCSOYmgsnueHSpK1s/4X467Fsx1eyRKcGKVzokC+8Th9H/1lh1pVPT1HZqJX8mGGpRP7/HGnIifN8H4Htir0R/yUZ2MNkF7YZkRZkffvWmI+ZAwemkpLuNaPNpumF69g0NmwFtxxtGSs4Nu0IJOmdbwVn/+HfOHsovM6XWTeAyMbicQeIpjfXRsE8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota into
basis points with "quota->esz_bp = quota->sz * 10000", both unsigned long,
and damos_set_effective_quota() divides the result back by 10000.
quotas/bytes is unbounded; bytes_store() hands it to kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX / 10000,
that is 429496 bytes.  Documentation/admin-guide/mm/damon/usage.rst
instructs "echo $((1024*1024*1024)) > quotas/bytes", and 1 GiB * 10000 is
2500 * 2^32, so that documented value wraps to exactly zero; 256 MiB and
every multiple of it do the same.  quota->esz then becomes zero while the
goal is not achieved, the trailing "if (quota->sz && quota->sz < esz)" can
only lower esz further, and damos_quota_is_full() is true on the first test
of every charge window, so the scheme applies nothing and the goal is never
approached.  Other sizes are wrong without being zero: 500000 yields 70503.

Saturate to ULONG_MAX, which is what the same function already writes for a
scheme with no size quota.  Widening esz_bp instead would reach the consist
tuner, which runs the same field through damon_feed_loop_next_input(),
unsigned long in and out; bounding the multiply keeps the change to this
branch.  On 32-bit a large size quota then behaves like no size quota
rather than like a dead scheme.

Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
Measured on i386 under QEMU: one paddr context with a stat scheme, the
temporal goal tuner, and one unachieved user_input goal.  Each size is
written to quotas/bytes, the kdamond is started, and
quotas/effective_bytes is read back after
update_schemes_effective_quotas.

  quotas/bytes    effective_bytes    effective_bytes
                  before             after
  4096            4096               4096
  429496          429496             429496
  429497          0                  429496
  268435456       0                  429496
  1073741824      0                  429496
  500000          70503              429496
  4294967295      429495             429496
  0               429496             429496

Everything the conversion can hold is unchanged, and 429496 is what the
no-size-quota row already produced before the patch.

Patch 2 pins the same boundary at ULONG_MAX / 10000 and so runs on any
word size.  Without this patch it fails on x86_64:

  # damos_test_esz_goal_temporal: EXPECTATION FAILED at mm/damon/tests/core-kunit.h:1959
  Expected s.quota.esz == max_sz, but
      s.quota.esz == 0 (0x0)
      max_sz == 1844674407370955 (0x68db8bac710cb)

 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2258b72da7a7..5ec476cef4db 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3274,10 +3274,10 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
-		quota->esz_bp = quota->sz * 10000;
-	else
+	else if (!quota->sz || quota->sz > ULONG_MAX / 10000)
 		quota->esz_bp = ULONG_MAX;
+	else
+		quota->esz_bp = quota->sz * 10000;
 }
 
 /*
-- 
2.53.0


