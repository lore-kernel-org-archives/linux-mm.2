Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECFD5D3EE84
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AE586B02C9; Thu, 22 Jan 2026 12:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126426B02CA; Thu, 22 Jan 2026 12:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E5E6B02CB; Thu, 22 Jan 2026 12:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB4956B02C9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A18A41A046E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:50 +0000 (UTC)
X-FDA: 84360219300.23.6234E24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id DEF0E40012
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k9qid6Od4GKTlt3Y9sLqV+gcbSx9kZPvh8CSTrziCyo=;
	b=D6sGfGxe9BTAWNW4Il31j0scWcnMCZ8BNBkJpgHaPeFYOcdeJoyOi6kXe73SEpUn5l3J72
	fNH8qQX/9VXsyuxlxGWXZqdZtlDZ4h0neHv50IxnNOD4re3L8Czs2QW3RdfeKPHVvM1Kzs
	0VyxD2NFfEipH0/tHhdF6zZTHy476+I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101369; a=rsa-sha256;
	cv=none;
	b=u0rvUZJITgwpWhGpF+qoFitMNhWOlkqQGf3xRuCKTfOI5xMtdZxyZB2BNdPqTxcTsZgs/M
	BG5Q8xE9mrVu8NqHMC/1AD189CmpBanwLEEWCXmNKXxSll2H++ki5LhxGJFjFv+SD9DRX2
	qJQGJGzqmvauub3VOWHyTDOXkDtq6hI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7F9A1596;
	Thu, 22 Jan 2026 09:02:41 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94F103F632;
	Thu, 22 Jan 2026 09:02:46 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>
Subject: [PATCH v3 8/9] selftests/mm: fix exit code in pagemap_ioctl
Date: Thu, 22 Jan 2026 17:02:23 +0000
Message-ID: <20260122170224.4056513-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEF0E40012
X-Stat-Signature: 8dxgtxph78fqdj3db3z6xa6mcy1phytw
X-Rspam-User: 
X-HE-Tag: 1769101368-688646
X-HE-Meta: U2FsdGVkX18ECaDEFSyQypxjdXi9xukRY9+WI69YWia0YVzSXhNloMVXjMqe+7B5OD4w/VMgcPJ6ZgMs9V/VN+HvTe4VIhpdTVOqCaKFlJiQG4F56s+tvevLB8xixdLTw4Php7DCIyA+hZze0U9s6VMy5qe1R15wXBtSt/WWD4JBpiwaBxyfIbPjj3JJRUd0iOaGsPO3Ve8mVTjznr6/EKxtt2LGhB8Gu17urBfacmdH3cZipieKJAvg3K7jVei9hAUJzHPDSHGqrY3JS99Wk1CB+JFjBukn0S7ixfCGjnjuOHIp5nZbXNYAAGTZ8J7htlk41xiHT8rg3fsf9ZZeQQ5D/5eV+IY7F3/UWMnJVo2cIAunskCag8qjfMEZFiNd9umWr/KsAeUR9CMYD/xSPNc7IaiqVNUJlciYoako4BhQ368eLFlQ/YjrmdFsYJxu1dPnkg5OFNIX/BsA79t8SSxpOqZa9Ox0dMZLJ7OBx3JQvE0T0FW/CHUXl/tLRk6sDS6K9yMDw/EWubc7WLZsKLuPiBkRQX0+GyPWJOiJHCoXaladcaOLecoUV90AJi7b7+zg28nCi+3F3/vo1QGa8QjfyCSDhMLMxSYCTHkU0k3Ix+fxWsILX+QkkbX3inKmxD/t8HI5AtYffZ3wh+JCLehSfkXKFJKkQUEwS9YExLoHaIiIoI/uz4yVtPEp5GboMe3QxQWTSa8OOEmxwEpz3ZLFtMgzry2po+rpSaYp7N655EEZWRMbMfWWbflkZtpmZ0EePzXsr38vbiQL2YOiu5vZJpDB7vkF/cAjTuqcN1YZZcCNh7RIy8B5sborLiQLb/RIPpkhPFdvFHr/ru6k+cQWO7Mct0n/yB1g5yO8owgHnk8qHhmX9XNtxsdnDe3YPIfwZPYm0Qhoyn5rEra9vqUn8iXLhfRG4+b7X7hmb/g99JDqt+PkglUWwqWiyJ2NxM6DJv1ysNQfEPUw0QZ
 QIeyODRU
 assOJTumnKucCWqRnKTJIGj5ERGQcbYv5IWdCRgwvIxr7KdXOgXJm4FfWetbvOK8n91Vn0HcQq1DEl81dLrJyl2hKeyxTJ1o0ZFRDvb2lORrfSDQ1c2M97bRlplK8m0Tkra+Hkt6jnVPbk80VQZ5LxYXKznbwzZtLWzJ8upvWWQJ6e35M91W4DqSfm6RiFR1Y6BI6TNeoAhpigbet+yyyvJ/fIjO7xOLz+qKB0s46vuSE9M1hwdHGHbBpr1DJCLZBS/dF/jQFiLWEkMO9Mh5XFOQkhgvbthG8V/9oRU4HOO2O4Il0Kl5CfOBoR+OVtRlopx5e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure pagemap_ioctl exits with an appropriate value:

* If the tests are run, call ksft_finished() to report the right
  status instead of reporting PASS unconditionally.

* Report SKIP if userfaultfd isn't available (in line with other
  tests)

* Report FAIL if we failed to open /proc/self/pagemap, as this file
  has been added a long time ago and doesn't depend on any CONFIG
  option (returning -EINVAL from main() is meaningless)

Cc: Usama Anjum <Usama.Anjum@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 1896c7d4f72e..2ca8a7e3c27e 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1552,7 +1552,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	ksft_print_header();
 
 	if (init_uffd())
-		ksft_exit_pass();
+		ksft_exit_skip("Failed to initialize userfaultfd\n");
 
 	ksft_set_plan(117);
 
@@ -1561,7 +1561,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
-		return -EINVAL;
+		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
 
 	/* 1. Sanity testing */
 	sanity_tests_sd();
@@ -1733,5 +1733,5 @@ int main(int __attribute__((unused)) argc, char *argv[])
 	zeropfn_tests();
 
 	close(pagemap_fd);
-	ksft_exit_pass();
+	ksft_finished();
 }
-- 
2.51.2


