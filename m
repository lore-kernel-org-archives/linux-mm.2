Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE2DE9413E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 09:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1526B0005; Tue, 30 Dec 2025 04:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888A96B0089; Tue, 30 Dec 2025 04:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787496B008A; Tue, 30 Dec 2025 04:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 670826B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:28:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E87551A84ED
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:27:59 +0000 (UTC)
X-FDA: 84275610678.19.0763DD5
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9FC2A40004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 09:27:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767086878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ynZYan+u4IBN11WW4RnZgtO0kWhmB52Ee+Kvaf/4voA=;
	b=6/gps6WwPVYyeMNAsmAQWC0HRMrFJcW45pDqV+TwxcGSXPqNW2mimGT60b49m6zTBtUFAp
	um869D50DuArrJM8i3iGY06I1M97bvdfk3EX0k9A8YYq033IC+yvQhcRFFkI6/86KmMqEV
	y9ExQTdQDn6SIRF24WIsLYH/o84na9g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767086878; a=rsa-sha256;
	cv=none;
	b=zrPoyhUwFVXZo83jQPyWCeRpRz/I6jtzaaqaAh0JZZtbwDYyzpMCtlKpB3XxCjUZdQr/ZC
	F0NRf9ovpBozQ5ys/4os2wSQfIcTnY4NLDpmVWX/zw0nEbTCYSRHr+zO6kZRF1ubYAbJV3
	5v+BaxpIk1HLxmFUnBUYanrqyOOvEqw=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwCHjmIXm1NpMxX9BA--.334S2;
	Tue, 30 Dec 2025 17:27:51 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwC3DuwWm1NpEL8PAA--.14076S2;
	Tue, 30 Dec 2025 17:27:51 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	wangyinfeng@phytium.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Date: Tue, 30 Dec 2025 17:27:50 +0800
Message-Id: <20251230092750.856060-1-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwC3DuwWm1NpEL8PAA--.14076S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAAAGlS4KwHiQAHs-
X-Coremail-Antispam: 1Uk129KBjvJXoW7Jr4DWw18trW5uFy3tFW3GFg_yoW8JrW8pa
	13XFy8XFWkGr17G3Z29w1DGw1IgF1fKF4YgFZrCws8ZF4Fgr18ZrWSqrn2vr4ktrWrA3ZY
	qF4Dta15Zw1kZFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9FC2A40004
X-Stat-Signature: s7te7q9qhdnmihi45nsufuyyw14cmzuw
X-Rspam-User: 
X-HE-Tag: 1767086876-965816
X-HE-Meta: U2FsdGVkX1/wN7mt0xzzh6ZqMVew0wjbomcm+Mus7u5jVtl8tty80e+wYR/BQaKc+oyRbtJvcg66WOatfEc7WIzB++JPdKW9BfNTCc8T8VuprCSLk9S1xCmxqjb3Us+/wNuFc+eT7KPs+P/v9AsYDAEijC3hoBoN4Bt8I5FG9RSXlCF38yr8jidJw1Vh+dVor+qXif+a6fzCxo0WuaT6FJJnEs+2Vpbylj+PII15yrjgZQJoJRb16BMc+8Sj29YffoRd03B2K/JhtaMJaYGAQQp1qgzU7vIMpgVhZ59xIp61LnIEm7B1pFgV9ZX1w6xM1cypqzD6nT7qD4UKpEUDQdhFVX8A1AD5JUlaTLRhCpNcdHzNoyYgfsrCJcl75z3bHNT1KeU3MOgByxlmul1GtKiTyQPCMByvb/uiky6o2R82ExOyqF5RUJJD2JqREN5ANuO1c80fKI1sl75lgETG4xUFvpAkFOVtLaSZAZS2W03Qzf4TQpnOY7DfpfzuaGSv7Y0ArYp6wcx/awNsu4jQXjpGgq/mKYI8hYQhHy/Pa4AXuu463d8/knDDz0lXEonr4PXiXx0Hd0n2DNQSf6qzVX48GX1hyadgzfOtWQuruRFDgkrTdWB6qjbLwPikWlphtKux2dvFZsbMACMl81EzteYgLzhDD5evZQsWpGp63xF0ElPUT4lmaORr28RHk3FQoBwQ9u4ghMpjsGUKBqTR87GRG1YLP21J/q0qL714Rgwq9e9xASM1CAtRBpjIPMJIpNrtEnpHZnD96PLfnoCsp/xNU0djOgiqpE2pgEC3OajEi+B67OxkA/xjJ2k3Dwz/8HxKN0yxORA2h3iIgP/R7T3oGuJkrrotAdnT9Ul+/JlXXg7G4CAJtgUHgjRVOw7R0d0zCyrnGMyxlDJPbn75kb5+5dbMsXlCAVqfJr8d8j1hrkf6GdP/vv22p+AYt6HkziwvTUn5qQU8aE0Xijn
 G58AaiW5
 N9yZwUWjH3U9ciU6catSzHl4cUclsQKAYBsenYc50CWUrDum1HeRV4d35JYX2Kj1VhuJTVnY4RCg8e+zTlkHM5vXXpNn6BheuglY3AlDBwcS3yYNuqupuh/+s93F4TiIyBpXArh0lHDGHjcGDlPrtOWNy7OWxi0NLl+aLR6foDGXqc5mVnenCcnVNkuqDgR4ozJOg3zEuL+FfEgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In some physical memory layout designs, the address space of CFMW
resides between multiple segments of system memory belonging to
the same NUMA node. In numa_cleanup_meminfo, these multiple segments
of system memory are merged into a larger numa_memblk. When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory. To address this
scenario, accurately identifying the correct NUMA node can be achieved
by checking whether the region belongs to both numa_meminfo and
numa_reserved_meminfo.

Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
---
 mm/numa_memblks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 5b009a9cd8b4..1ef037f0e0e0 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -573,7 +573,8 @@ int phys_to_target_node(u64 start)
 	 * Prefer online nodes, but if reserved memory might be
 	 * hot-added continue the search with reserved ranges.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE &&
+		meminfo_to_nid(&numa_reserved_meminfo, start) == NUMA_NO_NODE)
 		return nid;
 
 	return meminfo_to_nid(&numa_reserved_meminfo, start);
-- 
2.33.0


