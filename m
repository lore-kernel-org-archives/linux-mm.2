Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D388C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316956B008C; Wed, 23 Sep 2026 07:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A01E6B0092; Wed, 23 Sep 2026 07:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167A96B0093; Wed, 23 Sep 2026 07:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4CFD6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:01:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61444A6B64
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:01:40 +0000 (UTC)
X-FDA: 85244736360.02.A75B789
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 974A91C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:01:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B19aC+k3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790161298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ThaIcwLu+h6n8SHAWLUBhfisAMS/h6JPEqKO0DXHT3I=;
	b=AzNtd1DXMvEWJdsOhd+fExue/Y7loE03ihEwDCFEWnCn4Of+N/F82GG3PlEAk3uOAI+8Uy
	jGjIsCfV/mbFfvf1PmPUxRDhDDcpm2zVjAfk6vWTfYDVca11kd+fZwYbEz4T+8iYIC6OeQ
	OOMhUZxUYpV3DpO/YBLcWbbIHDEp/is=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B19aC+k3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790161298;
	b=3t4hRRSbCPJR11DCTjuIdHvuMg/zS19nGLgu1VbY3UZrs9XgWe1OaJUho8PRkbov/1sW69
	3aI/TuMjnlhMl5Sv+a1hHWiRwGjQ3cLFpS6gc9ohDfbG0dtxg3TkcYPKiGlO5xWKhR5SyZ
	3EQLXW+YhTo1x5t927UJxPzHp8MPnic=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16BBE1516;
	Wed, 23 Sep 2026 04:01:34 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E10033F86C;
	Wed, 23 Sep 2026 04:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790161297; bh=os7TsDMccUA+latXENT28M3rbe2rwbG6e5bpzP+PvA0=;
	h=From:To:Cc:Subject:Date:From;
	b=B19aC+k3DJZH7LZHsx1nheIHI3NcBwkKbYzkIJI0QetJd9bC3WeSL0paLVy6G3TEF
	 Sr695yJAqfOJ/zb461yzyF8vYI8b7AKYtK35NJrB0xMpGNh2QssHAsCO1cBj+cO60h
	 LA9qEAowJOSWAeju53Sp5/ns50Nr2gIxMumIxOyM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH] kselftest: mm: use helper to identify anon_ops in khugepaged test
Date: Wed, 23 Sep 2026 12:01:33 +0100
Message-ID: <20260923110133.429745-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hkj3mqxkqpswyfitertjk1twbrdhjkyz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 974A91C0008
X-HE-Tag: 1790161298-108587
X-HE-Meta: U2FsdGVkX1+B3kYsXjbhIpZi0b4811nCR+m8CNRu2cwcPxVjf/0AeYEkZINlHkcgEDerfUdb15M6Q1JaILpbsQ8MFupR3QJ3SRCxeK7WEKBdwpj7WbAHsZK1uYJbrhjPbOCKl/4Ts7zn4leTJtifCmmkzUkh8NoB90TWpsw4P1Nx3EY6v/n3OWOOxpkedY/TMPjA19LjG3HNUGh944W6dNExWKiBqmcbs5xPRtK3uRuZ4JES+HloG4nMQ1w7T0Mg73EGkAWeB6LhELFz4vSfyOGZkGck8dmOV02c5do8dY9YRyeEIGUjPxkRKYmSLekrTu4gQ7UrSrmb0hYnHjXNH+6mRAunpCxiMlN5sHzNK/XpJTPF+iCXW2KbUKEWNBLn+TXVF2+eHQqs6DfX6wPfnbOFCKU4w5ZO3jU+6KT1JZWGq3Jr+jvJ8/LNqLjO9+BIDAumiJUWqfwYelY3Y0wckZRJNBfyVlHYWQ/Tm/eV7PM+jxzZCoW0l6zhSrAAdAQF4V5eYM+eLfOvR6msZXUDAPqbLZVWSEjCWkJaxr/2Gv0qk8gXAvVEFJX7YNRi7TbzmHpTogR3JBsLrjy7ktuI2obITr1zNKKTP1xlnZCXF9Ps5D6d42l2dXzUDJ+oL1QcKtuBmBynXb5SddoVnk+dqlPWdXRWuBpSMB0XmeZXM0YBzFz75lF0Hbptw5C6FOBhoFQPFJmT4V9n8a6wReBYCkO6BPNz5Vj1t9zCivN8AwllB+9pLRN2I2ek/tdKf60Gg79RVrPjLBmlFqyMt/FHiwxLTn2Lie/juJREcrRJdqlkcNJBajAxC1hs8EM2qxbEQIBym9B1wMtHbfHdo8dqrAfaH25XwbCpwAs137oKvrKR01sNRkYXcXR4ydzZLWrGy6UdtviQ/M0Jpb1RQk1oJh901LLyVbfpayiwRFA+zvlRwE7mD/FSIk4yDaeVOM/MNtP9lulVlxXe3q9w1Iu
 0AUrtCwf
 ylJobjncEkG1OKCUWcAg5WgYqAikHqpmBZZiD+za+bEvTvRj75mJrLMVWCTr1xZm93SXzEEhRU0ZBIw5pQDRJnls8SRWOwL4buPVlmw/ywUD7qhFuOlsm+ebTaDOe5pDv2fdsl7uU6LZeiS3YwHwyDfLPzo+nGTIoGT9UYPGwo2Tmcaauqems7cLkh6NJyD4itOX/b9r0mDRE/wcMmc7LQcaFLLB1L5LH2Mo/d8gJ0b9Kt0DJQ/1Pbqi6WMb5JCYTk+k+QDX/HwlTaJMZZu7iFNnOktSmo7BE/KO9knHQ+uXsZeQtC3dvsowqOjR/I+zp/Oc5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of comparing mem_ops->name to determine whether mem_ops is
anon_ops, use the is_anon() helper.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
NOTE:
  This patch is based on mm/mm-unstable.
---
 tools/testing/selftests/mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index bdc0c7c117d9..b0cb02bf1a73 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -618,7 +618,7 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		usleep(TICK);
 	}
 
-	if (!strncmp(ops->name, "anon", 4))
+	if (is_anon(ops))
 		madvise(p, len, MADV_NOHUGEPAGE);
 
 	return timeout == -1;
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


