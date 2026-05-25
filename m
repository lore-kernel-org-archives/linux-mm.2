Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25ECDCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6736B008A; Mon, 25 May 2026 06:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896EF6B008C; Mon, 25 May 2026 06:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD436B0093; Mon, 25 May 2026 06:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6821B6B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:27:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 062F51A00E0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:27:55 +0000 (UTC)
X-FDA: 84805566510.17.9D78D5C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1026120002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:27:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mjGAC55V;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf29.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779704873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+6csErv+Pv1Qi+AE0pn2ZKMaZU84igUPr4oR5FIA3g=;
	b=biXE1vcuujO267CJ8Uila6x02ai3IykuctMbp40YDQqSY+bSTav4j/5WAEg6EEMXycGEzm
	ERaEVS553FjN+l7zkE/CN9W+arelYL6De9FT6DHSEpEwYneXB9YYYd1tPW9SfYtKnkaviU
	uwhsntd4otWw8SX/FSViBpkbHF1JaV4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mjGAC55V;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf29.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779704873; a=rsa-sha256;
	cv=none;
	b=Mb+Ditu+LW4Wr6M6LPpna+2EAIasFiXkDgaVZosTELOdqPfJmi/M/C3ILDA3scbNg+Ghy1
	PwJONgT5AuN/UcWWKBP5RzQsNnMxytQwM5/NpmcbpBllsHKD5NH3yj7fkslB29DMoXmg9N
	mBRkZ98yxFhj+2K4EpyLCcVdhwjQBZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=g+
	6csErv+Pv1Qi+AE0pn2ZKMaZU84igUPr4oR5FIA3g=; b=mjGAC55VKZq5OAW9Qn
	K6kIwbQ/JOZ1zMhkkJAq6IrIhKWKhhuyf76uJUdMBiMbTjJOryuZecgTsuZYoT4p
	JIVzMARepXOx8SmPT1HIYqp4vJu+IaZl0OOQepVSG80NcgeGDfRsdgLJibqH7YX2
	F1SeyzsrcT+wowWd34a3iMZ/0=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3V9L2IxRqXqahDg--.22926S4;
	Mon, 25 May 2026 18:27:07 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v4 2/2] mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays
Date: Mon, 25 May 2026 10:27:00 +0000
Message-ID: <20260525102700.68707-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260525102700.68707-1-ranxiaokai627@163.com>
References: <20260525102700.68707-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3V9L2IxRqXqahDg--.22926S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zw4UZryfZryfXFW5Xr4xJFb_yoW8KFW3pF
	WfCasIyrW8AFykKrWxWFW8tryFgr4fJ3W5trZrJayrZ3Z8Jrn09F92k34rZ34UA3yrGw4a
	gr1xuF9FgFyDtw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRwjjkUUUUU=
X-Originating-IP: [117.176.242.242]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hum8moUI-utfwAA3V
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1026120002
X-Stat-Signature: bondbredyu6n5affrowk86mb4oy91gis
X-Rspam-User: 
X-HE-Tag: 1779704871-275795
X-HE-Meta: U2FsdGVkX181LQnhA4zGEBUKUzhdV9hNBopdMeJjAf0r4RqiJ+Srx6POZTxQkQflbRU1+50oqbuzMrVX3Ff/bcwDjGwwC9ulBXp0WFmAb9QuYsfKiZKfL77sAuiUiTtc/iPXmwKOcPPr1FOmGHVFXnjrQ+rYFMwGjWBzzgH/47yM6uIfNgVCo0eoGikUThNPKBw/7a9bjA+rfnVhkwN13C9lZL6CYjcC8q8CrA0rfUeyUzg1wjhGcYLaXMpxRFyTSrwX+0YRDBSAiwNgludJwCifPfrpVIdXELNcJOZ4XLvINyb8xUTkgLBTa0Ftz842O3yTfaCC6uMixvQzqQjiZwUjuoKzxnfow5kCV2Ua7dm0CRQ52yv+e1OSRf7X9lziNEITQJ8+JDGI8er4vo+s4IVSO6GFsGrhrxXtgBJF+by4/2P3WVPyKAsG/7fz1fw3w5asEAdZAyr+yBcElZLhBaplfXXSUjdrXh+xg6vbwHg6mPYAsVnheCrgwCgrCY4zeI/xDx9qoWiqrCAbtNVauc5LOqhz1KtFhMufU1WHT8ZHbfyU2NP2mUXPo0xkdcDH3rQKw6qtzkJpr40v813gR0K1L3qLyLuz7Mls8T+lnlp2HLCdyWo7Wy6cAQY+23EJzL0ZND3thZSwxgu4DXtiN4LG8yZWMJd0prsD6brnqB6VEhZRGylh2zMLM3Aj6P8io84hs1TrD/YnVsiNLZg2i3w+dufEhhTek2qY46Dklmp8zfS1+YTQj7/cR8KTRN8Mehtk2RpemZe8kC/yv29mZkVvUDHY6/391q2Ska1/XU7vkkEAr5bGAAV/zxvxJB7tS1TSnsAj4QV/4cxcoRT8161YsFJ5d/cvhly31UWNAovKUDdrM/fJlPdGaODcnQM20gaIkrMebMlPUSeIFC+SUbQC6FJuseJu9dyvRJS3W8vd8G/hkveupj7f8wYNMbEwZSjIovYaLqfJIRLcP63
 N1FD+pcN
 j+S9NKa3S6WuqjOSP/OZabB9fgX1kWCnlxnRXid8Z0JdOK/tZg+6iCqIjiqOaWn3zbfVRncJofoRIK4Ucvuiq0ENJVHRsKJVcSxfu1t0mn/c+z9NmKVAEgyacFHLsVrQliJQtaobKSxZXH258vwMdx//hVxwuPHPD9w3SQOb/sgzG1FThVGY+2n2RuzTVzIyffIJB6JF36oZx0IXkQyIDl4xSlrGZCmU3c8MlukYalQdBT+h44oiLdIVTlYT9o7EGm0ZXapQpoD2cbbpQVqSJWKEvP8n8kjw/b6KFRWh0qamAJ1gj3CoLY5ugY9yntYjhtuUDSHyFYsqER04Aktym5WehOzFPonpsUt5Dlk9h/L9hRLkiMokIeJrG0hUmZlXVp3ohgJj7yfQJNcivrqGy8KyoyPXWAr7V+2YZ3n171tATbTWQt6U9fEvC7s+F0GpIaMuKjeEQdOxj75jfYZrK5E9zmXtyHjKl+YZ1GbC1oS299zPaXqHXRLyq8nxy/KtJf2GFaAWQJQPdoBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Replace the hardcoded if/else chain of test_bit() calls and string
literals in thpsize_shmem_enabled_show() with a loop over
huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.

This makes thpsize_shmem_enabled_show() consistent with
thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
---
 mm/shmem.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 288942b44db6..d9b499860433 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5553,20 +5553,30 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
 					  struct kobj_attribute *attr, char *buf)
 {
 	int order = to_thpsize(kobj)->order;
-	const char *output;
-
-	if (test_bit(order, &huge_shmem_orders_always))
-		output = "[always] inherit within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_inherit))
-		output = "always [inherit] within_size advise never";
-	else if (test_bit(order, &huge_shmem_orders_within_size))
-		output = "always inherit [within_size] advise never";
-	else if (test_bit(order, &huge_shmem_orders_madvise))
-		output = "always inherit within_size [advise] never";
-	else
-		output = "always inherit within_size advise [never]";
+	int active = HUGE_SHMEM_ENABLED_NEVER;
+	int len = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(huge_mode_orders); i++) {
+		if (test_bit(order, huge_mode_orders[i])) {
+			active = i;
+			break;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(huge_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     huge_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     huge_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
 
-	return sysfs_emit(buf, "%s\n", output);
+	return len;
 }
 
 static bool set_shmem_enabled_mode(int order, enum huge_mode mode)
-- 
2.25.1



