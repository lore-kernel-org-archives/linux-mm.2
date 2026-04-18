Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A23FF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24456B026C; Sat, 18 Apr 2026 06:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4D96B026E; Sat, 18 Apr 2026 06:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3B56B026F; Sat, 18 Apr 2026 06:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4D596B026C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 811991A0403
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:43 +0000 (UTC)
X-FDA: 84671378526.10.2856F73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C08AF40003
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6KSaXQZ;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3KYmiOhib6UgMB+RvvAlGmKtMO4Cjsc7yUgYi6viDk=;
	b=tRkMsBtBnXFy+wUzdbosDFrrYM+uJlrwdiuhI/C7J2oQ32j6UqbAee9RIukjt3zfErWoW+
	44go1xS/Xw8U/mbP7/iD0JLekS12ZmeEV9eeGadCwm94gv4A0wkQnPrjimZjjQZ1FdMxV8
	zKr/4xQi1DMPtz8zlB4yV8fmW5zXkCI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6KSaXQZ;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509921; a=rsa-sha256;
	cv=none;
	b=lea3UTaF4nqFZbvAH2r1AKUoxDBPuB/MSu2pzRfr5yOEw2WGBHb05akij4IbbCHDGtfLTs
	U9wxz61PHYbGUs3pU+RH/WQvVI/EFvU5QiGve+KzYOOe7Veth+Xxtqwd8oKUyI/q2CGbiH
	m/bFyYxjpY1P8Wm5857PrZM/FW5YA5c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFC0143A32;
	Sat, 18 Apr 2026 10:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F9AC19424;
	Sat, 18 Apr 2026 10:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509920;
	bh=tO4w/saWs4TngI1dGJjVb/BDaQv7f0xtr7dZaOtNvYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6KSaXQZaGAhrrP5EcrMULI1xIeSosu5JdbGWyBKBsyIj2G8+D16czUib5V1hugDO
	 kvUh6fNx/3oZReBNgCjX+Y8WpX6Su1MyhFviBLBbiQB2PEzmqNJRpiFcsmpXUaMmpL
	 avsWfPvrxXxK5zyRvV9ertZ0j5T0R4j8BIX/x6OzFjtwsd4VMoO5QbMpY56CA8MUjX
	 wxQfr9YksbgooACyHgtWmbpDE1zHr2gddjCTon3ck5mGkBhgJp/AMYxPmuRhBUYRpc
	 4a5GZw4Ni1XQGTUaODB2Dve8PR8ow5L/mCtOa7r9HZk5qXiAu7GvP+j77y8InVBX0y
	 DfQeO5QqnPXzQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 28/53] selftests/mm: vm_util: add helpers to set and restore shm limits
Date: Sat, 18 Apr 2026 13:55:13 +0300
Message-ID: <20260418105539.1261536-29-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C08AF40003
X-Stat-Signature: jquj55hktgbyoa9xprost3sdzoxpjqex
X-Rspam-User: 
X-HE-Tag: 1776509921-663308
X-HE-Meta: U2FsdGVkX18czhzOOPXgGeG3ZK5NLDEZliQ5Vgx8BHAxUXEMgydiK+yNwmPgCa9KpUB3W/Rr3GWvDA4m8Ws1lquCdDA3l8qMmvut8nt3MYnKI3j5qzs1nFi8aJlYf21OiHHfFcS3onenwovdzc747vWFArEvba1Xy+AvP6JbFKVzTMSk+9d6lrFPe8aiG1ziXOH9b87HSmzEDIgcfB7eXd2PLa3Che/F+b8P6MlwSgk2+2zU9EughjnIV2scf9IqLiknyXbQQSXfvUNfiMyNb7epCA6wUjQ+ggj9lOrDbyJwNLU1JtfckSsG8vPPCbaTRZhfUn6TSJm7Zb2gik9zjRxXYTdJ6DpgMmWAtkaIq8IsELxWiLO1BEqVvHtd5ndbsxqaqKhDLd6xWxlxt668akKCy7ACKNwlWCp/Sl1a/S/L4rEvftEuD1TIBogHhWNYajloFEYzheDDJ/98ONySOkaYdULJQ6FaNtIFnWXElKPbJKuqrr99fSTJa/0QIkga68/JpsuntpDvQqFVX569btU6qajw4szz9TAMrvb4AJSu224GNXiG4jmUh9MHvVpvt5yPK5DWbNM3OQTR2bIqhvedDHNMy4xQSvANm8uLuyUa5APEW5TzfSug2tkt9bN74p60jz7pVncTfylOhnYB4tOFgmhC+YvqTpLWVK2n4s2Sk340VRXRE7nat+IcmEfLklT+4g7lm0u6OFcyM0ijHhZ4iDLalHDaS5k1ipnFlAaX8lErlsd0kRgcauzLjHsBwUzsrqk3TbaMEjB4IZN3kpKJH6swOcX+RfH/oxHGT9mgY6jbmIAHMzj3aZf+P+gxxljERxubdc0wt5WSKGH4+xerpx49gxdbMvbb4K1Op3JE5wPaQYX0VjUoz40+eg6VN3TosaUDglS8yf63gCdoSfiVWPboxAujkVUeGZpQDYwBfw3eyaEw9/NYv+8mvMD6wfoSYXDG2KoehrFROIK
 1I7hKs8b
 QXcEV/z4yt2znalIypDd64Cv07+urOUa2xTimVScwUL8EblbETEOSOSgn/uw9MZvDsDjLD1UDy2xhJ2olVxrhItCRq7ZFte8K0omKAIbjzPxxSGn7ONWwXS8NbQQrVpCbMNg3FxlSLVjyIYNsJlJreVHQLypZv6RUWuGedk/7P+RyqyAK8EPf/tIGsEReGlOqCva81AMwNYMSa0qQT/9BEP8MZQPii13y5v/L8vT87gX94iC/XSPtSiPyoe5tueLANIvlB2dr4ITt/aMsgDihVZMAVEHllUGgbG6T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-shm and thuge-gen tests require that limits defined by
/proc/sys/kernel/{shmmax,shmall} should be higher than certain values.

Add helpers that allow setting these limits and restoring their settings on
a test exit.

They will be used later in hugetlb-shm and thuge-gen.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 28 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  9 +++++++++
 2 files changed, 37 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 752566f75c0b..5a89c2d903be 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -761,3 +761,31 @@ void write_num(const char *path, unsigned long num)
 	sprintf(buf, "%lu", num);
 	write_file(path, buf, strlen(buf) + 1);
 }
+
+static unsigned long shmall, shmmax;
+
+void __shm_limits_restore(void)
+{
+	if (shmmax)
+		write_num("/proc/sys/kernel/shmmax", shmmax);
+	if (shmall)
+		write_num("/proc/sys/kernel/shmall", shmall);
+}
+
+void shm_limits_prepare(unsigned long length)
+{
+	unsigned long nr = length / psize();
+	unsigned long val;
+
+	val = read_num("/proc/sys/kernel/shmmax");
+	if (val < length) {
+		write_num("/proc/sys/kernel/shmmax", length);
+		shmmax = val;
+	}
+
+	val = read_num("/proc/sys/kernel/shmall");
+	if (val < nr) {
+		write_num("/proc/sys/kernel/shmall", nr);
+		shmall = val;
+	}
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 5fc9707f6b9a..ea8fc8fdf0eb 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -168,3 +168,12 @@ void write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+
+void shm_limits_prepare(unsigned long length);
+void __shm_limits_restore(void);
+
+#define SHM_LIMITS_RESTORE()						\
+static void __attribute__((destructor)) shm_limits_restore(void)	\
+{									\
+	__shm_limits_restore();						\
+}
-- 
2.53.0


