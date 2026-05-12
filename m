Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8874ECD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED22F6B008C; Tue, 12 May 2026 10:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA646B0092; Tue, 12 May 2026 10:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFAF6B0093; Tue, 12 May 2026 10:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD9346B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:35:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A3251C03C6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:35:52 +0000 (UTC)
X-FDA: 84759016944.22.674A59D
Received: from cvsmtppost19.nm.naver.com (cvsmtppost19.nm.naver.com [114.111.35.160])
	by imf25.hostedemail.com (Postfix) with ESMTP id D28C1A000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:35:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=E88gBDzO;
	spf=pass (imf25.hostedemail.com: domain of s9430939@naver.com designates 114.111.35.160 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yp5PcRPh4m9bCVn8DBb1GKpVmSC6MiZI/PZ0taFO27Y=;
	b=5I6qo4CPky8NgXuG6JIICfCuc9abW3k3D0DYX4CAPgHYWPdN3nK07Hlg0iKYHLDTAZ2Rjr
	CAF0quXNpD+sPWTJ3jpi3KaQ/KsfSx7VE1vDydroPGFxSjcRWYa7ao6DkSuLFP4WuWFiWT
	VvZNDBLZiWEsGW/rKHVSTvfM8GXgNDs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=naver.com header.s=s20171208 header.b=E88gBDzO;
	spf=pass (imf25.hostedemail.com: domain of s9430939@naver.com designates 114.111.35.160 as permitted sender) smtp.mailfrom=s9430939@naver.com;
	dmarc=pass (policy=none) header.from=naver.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596550; a=rsa-sha256;
	cv=none;
	b=ewHgeYHFD8W/3gbOa6l81F4oRgATlCgLrWcHLXR8+aYNQ0YxVjrvcs8yeD1BgJMnnMyckl
	6jTtBph7hhrPKvfU1PNzOn4C+aOqjjV0cRNqE7MS6HcYRLh7UVB17Db42KuzsXKIf66YKD
	Mq52mipWUoNf6n0t4Gwyd+8dfzBAALE=
X-Originating-IP: 14.38.141.199
Received: from cvsendbo021.nm ([10.112.18.58])
  by cvsmtppost19.nm.naver.com with ESMTP id xCuKbXj6Ryu5-YIbCHO14g
  for <linux-mm@kvack.org>;
  Tue, 12 May 2026 14:35:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1778596546; bh=L76w+ouDkw8KYqvjRGLBKNLlN0zpsQMNQulS8XZCbK8=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=E88gBDzOdN7NOnLbUwRzFgYq3TakG9Mh6VkE2/xd0Hl9nQMYH1LivpmqxFjvsewUI
	 1IzbKgK0N5xw/w0RIB879VDUtdGQxaq4B90OG5wk2G7ifcEXAjmxljddkcTiu8oOjA
	 QdU7uXqVL85YluZfK5oALfNtdhIN/MPCbRFNZJKuGJQusCZZRIbuTpotpQc5v76zUy
	 itNVtvKNkBMZsEIIyLGnQbnkF7Ce/RsnYVCgQYftlXJ60Nupsc3oPv67dfGNxvYGbh
	 /Whqb3xUNJjj22HbU0+a7yH2iIiCxveqcrsPe4vP2B6td09nsc+KZ+N5iBxH5oO6AY
	 K25GLUldEafvw==
X-Session-ID: rkY7GxkhQYavHSniVnx2YA
X-Originating-IP: 14.38.141.199
X-Works-Send-Opt: LdYwjAJYjHmZaAKqKBmmKxbwKqpYkEljxBmwjAg=
X-Works-Smtp-Source: VZnrFx2XFqJZ+Hm9FAud+6E=
Received: from JMW-Ubuntu.. ([14.38.141.199])
  by cvnsmtp009.nm.naver.com with ESMTP id rkY7GxkhQYavHSniVnx2YA
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 12 May 2026 14:35:45 -0000
From: Minu Jin <s9430939@naver.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Minu Jin <s9430939@naver.com>
Subject: [PATCH] mm: fix misleading comment for remap_pfn_range()
Date: Tue, 12 May 2026 23:35:43 +0900
Message-ID: <20260512143543.258399-1-s9430939@naver.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D28C1A000B
X-Stat-Signature: pk618uygfd83u4rrqp55ehid7pd3r9pf
X-HE-Tag: 1778596549-986530
X-HE-Meta: U2FsdGVkX1/sLfarjr/zP35Xl2QtD3Hqc1BOPbyRMcDejEnEhVcBEOI98ubyRV6z6DkAG/iO8NVG7PskvBTeJf2diUkncJ3rZ17SHLjFevFzhCXcdccClyzfViq4aX8peq3HAT/KBaB/4qSyZYWoOSMg1GWodhu1VK36+R2Bqu3bEdqOS0WOlef3vR/AFhxSwZlvDmzh1RZQBmUozMb55uduFWFhzsgAuMZ5m/ndIIKhhjLS9zD85V+t7uDMeChrNKFhwN9ByK7dVdw8UpSOdx8HWVo7lqnA8ru0q/Y/ZXLCcHVf0Mq93/jNrqsQbaCFCqp4nKaFHhBrDCQrIX5WqXl+I9RJDpp25kRgLFDPlBY/3GR6vTmfUy5/G9qJXlTH3o+NB39FUe2szlmwV93VJJN+5oGrpPlobo69XB+YyVzXSkjpaSoiasLlfS4QK7hWd57N6KXrudqDQMz2pnlaHaTVypLtCq1Fcw4yDW6eAyz6FL8ahdVoGdD1XOCbqUAfy1FcuDeIbFdTU9Yejp2nsLupy1Aof1oh0j/fOmb6i1ludbeuJtunapvN7cD/Wo1Gnumc7xZ2aFqnMpYuj2SDn9jFTSgmjiJC8Sjg8Y5S7auBmLWizOBybfh2wVGRlHdcNEjsDTef7wzxq0H3Q/ITcOjLNP8haiY1WkVhQCXzXFKrHgyFSkdZeQqY/S0VS2lCXwFj8MmHih9DjGI3voZl/d5IbfhzfGDr3a2OLPyy8bO4rmdLx1xpXTQqw8qxNXHagwpJRwcCMVzWcCIfUhKL17LQxh0Q23aVqRYy84NxnsfrKQd5rOJzdJ0cOqW7DsOofM0muvSRU/1lPVy8tEIO6ZPgIMPEwYotdvPnysMrR29ToJwtHRAC3nEVbzLkEJaLE2autJQiomqazTisznZx+UZFkPWYA5Y6fdZ2dkEjKLbT831djDRyiMppQbhfDEHMfptmC6dNqSbh6IIh5De
 SDhBjbXF
 oOYp0byRgFaqZFLFN610KAJbf7EhnEvm/YgGHMfB8fe23ilsuOO/IIiSPv/5JrPphVeHwhpuOHWHGQ3eHqV33y8dEkiN5pyMm7n5Jaq2IlA3s+px0CcKwoLYype04THfHGPzsQiZHUE88Va6MTQPE/0Qa2l6C8dJSzUbalM/uNXVKDqO2jdOFE93/cWXncj+Sd5KGGyDbmblURo4iiE/hADTvi0Ss3j95uPnWRwoxGxkcdFJp0sFVAipz8oJ1EfdlASbnTiHPxKH9g1rILYnJr0eL8Egi1BcK/wUHf4DvUp3ZTsGzuED5FsphSIm3Ap0TJO9buDgVArqQGHbC8z9mCf0UiGtag91K9v5h2+JYqtb4/2XdTk0C6qyeMQ/7pfg8xtwlYJvifEJ7N17xCPmp6VV0rx4OUwZs3W4lNhsZlm2rM8NQBu4ELEVpWIbDSICQ5Ln9lbqQpeT1jdUPPp3PNgm5JdJm7SHO8bFM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function summary describes this as remapping "kernel memory",
but remap_pfn_range() operates on arbitrary PFNs, including
device MMIO regions that are not kernel memory at all.

Replace with "physical address range".
It describes accurately what the function maps.

Signed-off-by: Minu Jin <s9430939@naver.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..4e07e03a76a4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3172,7 +3172,7 @@ static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
 }
 
 /**
- * remap_pfn_range - remap kernel memory to userspace
+ * remap_pfn_range - remap physical address range to user space
  * @vma: user vma to map to
  * @addr: target page aligned user address to start at
  * @pfn: page frame number of kernel physical memory address
-- 
2.43.0


