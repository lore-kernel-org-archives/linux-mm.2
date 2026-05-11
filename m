Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DB9CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0776B010C; Mon, 11 May 2026 12:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60D36B010E; Mon, 11 May 2026 12:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B500C6B010F; Mon, 11 May 2026 12:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A16B76B010C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C8481A01DA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:08 +0000 (UTC)
X-FDA: 84755681136.24.E160E75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D181D18000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pa7utrSP;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTlt896SSN5jJJb/Gk2L7erXYikXThQjMb+buPSLH1k=;
	b=tVPTybaR22zEQ+bzjBmBUeT6w0GtHsoC5oLMfwLuZ7RHbW+QABQLXlvfrO+rtyI4PtJ1oh
	21NRMJZi8XC4d83JOgD4AXcXA7az4XyYhs+lvtGk43P2z5o1Wv98hVhVxSmOsVyc6XKRaY
	K/OtkLJ2N/ES/b1iDanFY8Q3t/nN45g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pa7utrSP;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517126; a=rsa-sha256;
	cv=none;
	b=ZAVSvVq2V3TDsfH/WEoeky1xUipKFxpQW+sS1MnwR2FOa2+m+MYqKsDl5kMJbJgedNjYGB
	pTAvdHH9wAMnIw84WtwIhWYW40XT+tVfY4jVAnE3lvgslEHj2p2j69F3ExPElonQFsAPTg
	Cl8f9D4qir/k3Oc8Wy+f6OPBIaWc0Og=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65A31600CB;
	Mon, 11 May 2026 16:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D5DC2BCB0;
	Mon, 11 May 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517126;
	bh=z0JhOy+pHH/aI/Vimu7SOjVZzwdCPvl2MrL9FynQd78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa7utrSPXMPGNdz7bT41cMR+W0vj3TNLW7cbRM4lEY6I+HX4WtA6+BPt4o18iOvw7
	 AlIyzj4lOIQVm1ifNXdnYVZsryhRNNIPW0LaoFn7R15NwAtKm0B+k3GZ3cdDctIfSg
	 ADfOS3lRarImeNqPRshM7+B/J3lZ/cXhSX3axHtqk8R6Z0jmm6+flF1yU0+RP2Vu7F
	 Cd3SPW4aI9ZJOJxHQcuPrAsxrcOmtrMQUjmPsFXbR34uGBRrbBKSiwRTGinrRVsQ1W
	 yj4rp+jDJFWD6LdwoJEw/9lnMQlz0BvYcLeoAi+t7I1XULXNFQDFEY/oFrJoVscAhV
	 7nXoG4EEJxruA==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 30/55] selftests/mm: vm_util: add helpers to set and restore shm limits
Date: Mon, 11 May 2026 19:28:14 +0300
Message-ID: <20260511162840.375890-31-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: de59bczhi7k4j63sdy8g1yt3saxmusad
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D181D18000B
X-Rspam-User: 
X-HE-Tag: 1778517126-823408
X-HE-Meta: U2FsdGVkX1/oL2mPbUGM0VKHlMSMEjKt7C8k1AHiPqa9TeKz/1wImoIkD6OBLDzhp2HkJGS1s7bfnlTCZ7ZyPRlHmYa5q4+qPDSNJIo5TW5ILuiPk811nrF900ONn1KA2etE2uIY/jqVZ/4g0UMwBC4FvA0iILHzBxmOe1T032tc5M6j1GDE3QJhiCcyRebae3P8FkwgZujbQuorvu/YqfV1Z5DzLFsycb3gaUmaFKq2n1RepnjuNXZI7cZiGM6E9GfmmOHIZckbuo4uPrxOltHUHfJYjrf08fUythMTCmmDG2PilzdB2CQMPnopkuMnHAXaNYsY2uUawr+OqAScYiN8U5+og9DTQeNxwW4mJYlD0vbuye1MkEqYdetqUMoIXmv9TgS24BHEliN57+j1iSDo+ktLxCux8kOs69TR8iKG+p4pCVEoT90MFjfIPm28gaLCChcqKI3klIik6FJ2C95ZTRH5aD+IYXR4DY1SRRNQIfQ4zqNgSbwi8td1MGStHVNCAFaq/1FYQhZnD6jXknPqod6KkADkQkmwX44uKq+We6Sh6kjyDdL0Wmp6Vbmu2KjeoHhbceguwNkTlCj+ZU1fXBUbYjUSYasVBN8dpXRngFneIDI9QFggFVESNFtzf2o0JEHHr8FpvkX/MMaKxdxALnMvcoq+c0FihB0VMdJudgrDwYCI0i4iLI0MH+ltBLZ+R0yYAU7R6e34WAwfTPZgefEeGts/q28XcSWrOk3ViLVrYUKR/vQ0mmCdX11vtheS+G7QSNaMSeu0ZVoMymegyuYnyN/LCi4WyVbt0OMb0Mp5D1kO+ykhS194MQwbVvryS0wI+DjOx7Y7WeFPB6GgQ9NDkqQjZYeh8HIl4GfNjHALRnramD/Z+zfMrUximiU5Jx7frROEOlTbOgLm+6gfgvLa1/zh5BldppApgtzILIsdPayxmSKK/c24GzLHFTBdpyQNKt02muEFHno
 ASUEuiwM
 l/f66WdtI1j6TkfBdzdNmQNMV0QCGQNyhL/oF6wIwo9cNaXuYtB5hCwJFQzZuur1+DHqEZHPm8F3UXH1cdmo+NadwY6ZAeV1/p1gQR5J7kC+nngodqiAgAwWJre18G5Dj5qmH2SUOJpdZfCLpcpslexhNPBoxPXsCRV4cynCPVlemABsu8hxDcuRbHqb2WW3pwFXifNp96WFdLBV/ro8Pyc3+XxcpR4ZqMiyVw2fpIJ33M6s7J1G0A9GwL++f2M8WJOqDQyR0q5whPYKO3YIGhIQVm9B1UFBW402WYVlMxh6qThssgzmTbevw+W+goYd5FJwqQ6Zx1KqpUukVjZ7m3lPamAZ8MB8tDvtw8u2qFiJOV6Y=
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 28 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  9 +++++++++
 2 files changed, 37 insertions(+)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 9256bbbe38ea..336a26751d3f 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -760,3 +760,31 @@ void write_num(const char *path, unsigned long num)
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


