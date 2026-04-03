Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501ABD730A2
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 05:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAFB76B008A; Fri,  3 Apr 2026 01:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86FD6B008C; Fri,  3 Apr 2026 01:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76536B0092; Fri,  3 Apr 2026 01:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 961FA6B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:29:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33F2713B00A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:29:24 +0000 (UTC)
X-FDA: 84616116648.05.3BCD89E
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E69F140007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:29:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bQaiGwpS;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775194162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DhGk7ekX3JpECpQ0RXFDeILDJMOxG359GUgFUbcyx0=;
	b=fKfwLOl/FOa+fBpxfkZ9946urCWallK8Y9zuW0oFbTxaMae+uRdI7YVMelzgu5llahNk5E
	ArD/U299rMS6qDNbdoEOJXoM3gOLNYOsTalwrEiXrwsh6LgZrB4Bd+TugRR9kmU6DGe4o+
	tBD/DP19RMbsEvI0cMKbT2EihVgfGU4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bQaiGwpS;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775194162; a=rsa-sha256;
	cv=none;
	b=HxuRQyftv3YgB0vqoAbA2CXtYsHix0IcwG9bJRuwniBu2nFrSxWzIIi7um3bLZt/n8OPpU
	5vbFhffL60aw3OqEfuXyEzWxDa50KarngEsZhYGWvDTicrNOWOgDatpthtHK5PzRBm6gH/
	oTCE2h/A4NVkZfXNInq3ZnEGi+f1+jw=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82c28f0a4ecso1204901b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 22:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775194161; x=1775798961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DhGk7ekX3JpECpQ0RXFDeILDJMOxG359GUgFUbcyx0=;
        b=bQaiGwpSRSIJrFDyQA0IclnTEjCtn+B0PaauBwBDNtmiAF3nPDJhMTpKVHMFFtWjoO
         +LMHt2bDU0w9de9XrHYUNrQLpwXUS+LRR+nvJO6KIOCDtszKtdrYPumoEa58uMRlqYDr
         kNuAFc9dUA3BESk3AV7HxWM+7XoEdQLBYD3fk/uc4wxukr1oGJWkx9x7w3gVpyqVx0gu
         AyrrSe0Up66lV54o0Xsi9kwI/n8YaemtShw/4NhbQrlXV4dkf2D5rsZ5MvJlUFTWDB2C
         RTEFN6BmVLQzAoff0mpnuskA6HGoYdVBQlkPtR/1qrVEn8GkSmjyEsXPUgjGK4ZTMA46
         hVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775194161; x=1775798961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7DhGk7ekX3JpECpQ0RXFDeILDJMOxG359GUgFUbcyx0=;
        b=bXyTKNKDhseSdRX/gC1xG1nRFZCZ96nJwfOglfU1T2LfebmeKW7zSJoD7znnXeOGQ3
         ZRG3X6MJ9/XeMUn8olRizdO2x0tscPTLmnlFhcDyoqkbiOomdlCmf87tQsht7D41TEHH
         TXkYwcyasWnRpgXWRU9V+5Cd4zyB399tNYGbp837zaZI5+vEY74lMN7zilP3+oJYYThV
         Fg4NWI4fNirhrO2fCJBdNG8weLDr5Ar9TD5oo5KGy4LHB4gZ6h4wIfIYlFpj9kc573Vj
         7qGq+xJO3YEzg4C3/BRiiLtkCRv+T2yOWnLaiBJTH3ocK++L2Pg1dH9putX0JVWMv23+
         FUkA==
X-Forwarded-Encrypted: i=1; AJvYcCVpVEtzDN4h10GgRMcIsN2Tn56p+lvyL6d9n4xRrbmusaox6WBE31+Js1bTosTJ/ub5Zoan8JGs7w==@kvack.org
X-Gm-Message-State: AOJu0YzvruIXk9AiRHqtU2POD6o0DToNZ/zC/g6P0JljjNTa3yyygd0Y
	akvbHIrVU13KhfijW7ffBc0T8W1dLTJ0S42oO27hD9OD0p/vs8e/PQ8g
X-Gm-Gg: ATEYQzyIfwN12ceYmGeUi8fzcXIqxULemspPMGzD92QICV7PVgKphgW6zkzRjoBBMAP
	h7yZjrt+NfnRS2AoogQVMLbWVG/KK+GvHp63JXIm53sFdgh+0tE2mxRUleRA/9yh8HZBQTCNOGt
	j1L+hri6xF5wX8kkiY+hayveIdiOvLYlDzr34ybUgRziGe9SaZPX27yFQB5cjSP2DO7dtxh1cuj
	4qPJ/KtiZlZ/up69BJmtDx57+HVbe+PMeMmn9pSsW/3hEh5I++HhXXwiFnQYrsHSt9OjsSJBbfR
	5DnvLJzPv9P4QddFehsy/XKJKNGm2gsLUdQtUsUD4hOGr6Hii/jxm/KY50jUYZe4KU/IwosZugH
	18ZGeEhkEkrFwqdAEmDQZZ1i1eWnq3CJWfutUiNJHYq90IE8xWiIUWccAfjvM9REyiin8ElB1kA
	09Zm9VM/17SKqQ1KHjX1/bbEvDWuMItY6Oq3NTPw==
X-Received: by 2002:a05:6a00:6ca8:b0:82c:28e8:a009 with SMTP id d2e1a72fcca58-82d0dbc7a68mr1847464b3a.51.1775194161239;
        Thu, 02 Apr 2026 22:29:21 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82d11cd2ce2sm782120b3a.6.2026.04.02.22.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 22:29:20 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 13:23:50 +0800
Message-ID: <20260403052837.58063-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403052837.58063-1-aethernet65535@gmail.com>
References: <20260403052837.58063-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E69F140007
X-Stat-Signature: 74q9tdkdf6hihyuibozofkdn8octwq57
X-Rspamd-Server: rspam06
X-HE-Tag: 1775194162-506071
X-HE-Meta: U2FsdGVkX18kHRwfd8pp3U2bFH7BJO421x6PcAFxWnv2VjShjns/L5IDd6FqpiaV8G8hA9l8NSoCPkkzPgVuX/+26lCru3doVomFokjQxiXFuASE854WEb+DbNO0NxTlqmg26AoCLBTFznrcoNWNwKzpHOu8+pqphjwxTeuZBgGgfmMQGZebRqK73YUUslS9xt4+qPmqZIB9ZK52Y9qZcTvsfDgvx32/dkJcdj+IktONzsmXUUYbGcOXFeEBkDKzzGu1TPY+6vld00HLtMw8wN0bgHUu/JdGE+RLKdhNf7ig71BWbuazFh74cy3JbRvSkf5TldrSiVqjiRgViaBguJ9vALIAoKVbpJu3KszrosabE5zZAQSWM4S4qxKdyI47yNetSNVRN7UhJWKze7xhpMMdnFvDaZhS7iTXP8eSnkY7aL1AsaIHlZbHeCY29zpT2+KCbzSNUUPcbeRN4SawwRExsEgVlGGEUjt5rLmtIdvRD6sTPp3MHJfJn3o0wK2fgY1v0JNJ9Cqgf4NsOdW2qEYuVaotrIOqGUYfL7hbu4PwN8pKjkOIXZcKcNAPaMg7NrrRRuR1nxPF3E/LLKsOZPYU54VHbHBZfCPkEZwp7/7T1aig1eHcEoZeFuj2kAJijZYOZrLBQh9t15vEnjDuIPgPrjTDx2wYA1py+F0pJlQ/YU647lPmaOxTcR3ZlB0u5xq7jz2uV6p5pzucZpOu7SlLRckpOJJQlHGT6ChzLpzZu1CJG1ZfNrmwqR+PHzDxozZlUDCV4tlgGnZqZho5uB2UyriDq2ncerFll03mndIs94pPClfX3+ZfY13zsQmY1c9jwFKyl/w0m0sbOBqOzu6WCHO3ba5zhCWpHTiHokzmEntQmop92d+ZrQxJYayY7uGfFvGA4tKvJ9mGbNdS6AKKPLbIgAgH1Az8bh8LyjrbkVlxi1ejqine10Dcfvo/Y9v7BcXqSIayTmoBF0G
 C5bNKMZH
 6JoLRDy/L3aXVdwquhO0AZCwAHfOkz2RHm3fHpNlKeJ0qvyY8ejZ/eje9s4BuO3rgG6UxmO3HuUnE2mEDRA5XpXzUDgo+8zv3TtoLKeEUhdVatOtIwhNvMZkvO019YpiMVuFWexHUaTbI+0d7q5T8ErolHOSNPSgNhWbnfvS1V7sIy03RUL3T5wptQ1nchocBOQWqMcgO5Yn9PSVaRcls175HZ77LKOveRAeu35S771LfmQYfDuHdeX1h1s17Y8wjBUYGF+Vv5UIsa7ap4lQOCVlVviDuj/ivg9cg2qcvmrBP//ed/UyiMQy/I8LoNKQ91H+QNns6GfRXksQ19P9ycvvIgmVYLALX+sJ/BUQqE4rSym6rPJzQoKQKq+zhcKlqFOcKUXAYRHQja3rLzCanMSLgQY6WIMq0rZrRAOb1THAsKQzgJQLiiB9dSNj+Sw5f+ei9gyOrayLLI9iQCEGJx/VvVmUgYja4vfyPVUjCjcWrCwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_commit_ctx() checks if 'min_region_sz' is a power-of-2.
However, if an invalid input is provided via the DAMON_RECLAIM interface,
the validation failure occurs too late, causing kdamond to terminate
unexpectedly.

To reproduce:
1. Enable DAMON_RECLAIM.
2. Set an invalid 'addr_unit' (e.g., addr_unit=3) so that
   'min_region_sz = DAMON_MIN_REGION_SZ / addr_unit' becomes
   non-power-of-2.
3. Commit parameters, and observe kdamond termination.

This patch adds an early check in damon_reclaim_apply_parameters() to
validate 'min_region_sz' and return -EINVAL immediately if it is not a
power-of-2, preventing unexpected kdamond termination.

Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/reclaim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..2747eef5919d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


