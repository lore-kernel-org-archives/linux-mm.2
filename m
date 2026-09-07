Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2982C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF86D6B009D; Mon,  7 Sep 2026 09:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFE26B009E; Mon,  7 Sep 2026 09:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D0F6B00A0; Mon,  7 Sep 2026 09:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7636B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:56:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 235E116017B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:56:42 +0000 (UTC)
X-FDA: 85187116644.08.F8F5231
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C67340008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:56:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=coNMpP0i;
	spf=pass (imf12.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789400;
	b=4zXRbQXfzwNYfgtsZg7kUmYAjzyUJ+tXO8GnUX0Jn6dUzMDsKOkoV3fkPM7fanHDhNWADx
	YKkK5ZCRS8N+8LZ5EJm4Wc7r89mVG+0tfviNz/1p8uH5NVpLAmBULQHX9WNpPbwLuYEOJp
	qo+AuSvCije61KU96lInOxqrKS69xBk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=coNMpP0i;
	spf=pass (imf12.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yVusgxzBnkCzU/kDP1m5pihJpV6USkvZzX7kYZWBBdA=;
	b=sCgUUbgp3hA/IpAg0bgnPoizebNIfeUbMjVFply1T1T/RIaVCsdPT0uwA/7hSbaw6ayL1+
	rknwR6nHyeuw2lWdhO0VyAEjOVA7luQSTfiL/C8ezSNgaeUg93D9tdxVyJJLMea/02Y+nc
	MqC3318WRH22kHjfly9kuJdGqOGcl74=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ku9/UBu99vSafYGo9adeFr1f9lBsBT9crq+anMw3VDM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788789395; v=1; x=1789394195;
 b=coNMpP0iL2skrqQ1eElLFpIaIfj4nan1asy2MqeBQqjHyQntRGLGREgjuUcP2kwsYpwmlfYP
 FR2gBqzzSkfhYiwMzXojMGBm1VK1QCFvvzrRqVru3QzS0Twcr3aPTMR1xAtwPuq8RyOdJCeC78z
 0XLv58ituWXzHhwBDMlcj9lo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 66dd265d53de2e57;
	Mon, 07 Sep 2026 13:56:35 +0000
X-Mizu-Trace-ID: 66dd265d53de2e57
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: fix size truncation in pagemap_ioctl test
Date: Mon,  7 Sep 2026 21:56:13 +0800
Message-ID: <20260907135613.68692-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ukzbug4kusbxp9koooohjcn1785sfhbf
X-Rspamd-Queue-Id: 2C67340008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788789397-130796
X-HE-Meta: U2FsdGVkX1+XW/vzcvWnBwv+kPJ0ijRpSj6dEGgkQ2/EV3oJrYNKWxvYEt/+nWtFi/lA1fMNLnYDB7WfZCjgxlwaaXE/4GFCPnGO2XNGleqN/OVqnPEMc+0GKE8uUIVlJUF5zB5mzx1rX0BG6O81nK6FWGdoLBG4J0xAfiCmOsKU4xZXWuR2/icmx/jBxOGSUoFnW+Zpe+R/+h2YnJhrJUgJkC9fbZfztEawC/YjnHiUnAoS8Egmc8hRNvny28ZrKuKz90vzOTLSM4iZx8cTDSVSxZwCrO+Nb5SGXQq02CknERcXxJ8EcOiGUYAnUaUl95e/6w1oWLC0gjrJ6/FosnU16VCyssIb5dFYCIcMLTschXcc/0Ej8f3WDxk+G3vQsw+Wl0VYDEpjT07SihTzJ/J98LMPdAouNKybfEhgv0Vascch7X3cbNdbDrBQpuleFx6+vsK6pp4/cJ+vsH0ypi4Xg/DJUUqlWILYXl2OD+uCam3pl/6bcJE0LicGD85s2sNmBmxTd3dHMcLn8c8pjIGwYtuDj+31qycachE2RzV4TfZ666nxoca3ChJ7SRpSWFXLJemQyoH6c7N9iuQERc+JX+DBVRcd/33gGnZzhp5Jv6l14XKCkKy9ahEX898auZ/PveFZgQxdc8KwiVItZkcVS1YUelZxMnoDYvu4yF8T3gzQ6MATL+enpFKNnL0yxJDwM60pkalfVJ2X6UsQab4wuprp3bGUb2yCzbkvBwLRFzWLhAaOxqKFmtRsh4LpJdCoqLMtNmj26hKJJBq8eNi4WPm2F2PlCMsLS8qLw0jqUy2vC26Bwhc6Abvc/ER44lKkSokIA9JIJKjS7XUheapFM4U1dsDEGEvyrpgV6SPl0F97Jhwk8v/20sveq3x3E5ujBdOmvyvvZLUdOtJdDs9H383ukWCnX7vFJmLyrVnnESeQBJPPCBmJfdfnGi/y3vVnr4DdNlx02U5KtKc
 bri/RbjI
 btgj6ys9psgZNK8YpvKZISWbVlccDsGgtcGYrwy7caYwh3GydopNzz8T8n89YXkwG+tRyXdXO9d65koJdOSLaRZzVI0m0EV5zAuDdCZWqjI0njgb7iw8VzZNQQjqt7gsw9Kd8nbCgCyVlfldbflf07a5wmAq5e3ls0ZwRkBvRoK53/st69CjvQmqvX5r40HdzjpwUCTzmkD/p/kirtZlySgQL9e/1uB7Qkug9GOG/pLPGct4Gy1lWmnK+5pyVXbyVY6EeWPS7QfyhcPFfCBcj5hotYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

On arm64 with 64K base pages, the huge page size is 512 MiB, and
hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
exceeds the range of the int size parameters of gethugepage(),
wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
makes gethugepage() allocate a too small buffer, while the callers keep
operating on the original 5 GiB range, resulting in spurious failures or
SIGSEGV.

Change those size parameters to size_t.

Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
Assisted-by: GLM-5.3 OpenCode
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index eadc7159ca5b..48cbea3a33c9 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -44,7 +44,7 @@ const char *progname;
 
 #define LEN(region)	((region.end - region.start)/page_size)
 
-static long pagemap_ioctl(void *start, int len, void *vec, int vec_len, int flag,
+static long pagemap_ioctl(void *start, size_t len, void *vec, int vec_len, int flag,
 			  int max_pages, long required_mask, long anyof_mask, long excluded_mask,
 			  long return_mask)
 {
@@ -152,7 +152,7 @@ int wp_free(void *addr, long size)
 	return 0;
 }
 
-int wp_addr_range(void *addr, int size)
+int wp_addr_range(void *addr, size_t size)
 {
 	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
@@ -787,7 +787,7 @@ int base_tests(char *prefix, char *mem, unsigned long long mem_size, int skip)
 	return 0;
 }
 
-void *gethugepage(int map_size)
+void *gethugepage(size_t map_size)
 {
 	int ret;
 	char *map;
-- 
2.53.0


