Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3A2C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5F76B0095; Thu, 31 Jul 2025 12:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCCC6B0096; Thu, 31 Jul 2025 12:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2716B0098; Thu, 31 Jul 2025 12:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4864A6B0095
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:02:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 060D0134BA1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:59 +0000 (UTC)
X-FDA: 83725028478.18.AF69E2E
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id E771B20011
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=S1rC1MQy;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXpQvoH9jL/54pJyNmcqlS3Y6t709TK/3sP/jYyYCZU=;
	b=xWpLf3pPAxwqI9Fa3Mr8ktVjsEW4REaOYQbI+/hU6G1MuivEj0QzbuWPoG0GkJL9Z1lhZ8
	KhAcqWyQbOhu3DYE+qSGqIqzXQrBkeBfXeiNQWz3obDKipXlxewx8cgZrZP6DcCOrx9osJ
	YFC6uZbN3dg6YnBn4SyFry/P7V9LDAw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977777; a=rsa-sha256;
	cv=pass;
	b=0x+XxzSxzBr7Sm9SpHIkmpEjBAHaywAPGRLPCkBqANS602ijgTuZxoXonk0kN80Pf0zCqR
	f3XSQ5afD6IT5q2+YD7CJS7zK5Mzz8o3pNuFHPS8tWG03bLKYacZbcEVBqR3q0usHUTCk6
	3BsIl6l30JPKXluHd913cOwSeRbnn+g=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=S1rC1MQy;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1753977760; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kNoE6JDxCi1zslQy1xpg+mF1/vsqY1D3IqpBnpStBmj+OXDL0sRiK9X/8RP0WJWhQV9EKf6arQbng8mdB1tISDmG3vzzJlBS5uQb92J4ctr3c0tK6Divd0PQ7nSxl5QW/LjfuA7kV1cn+p7frVI8nWvHO6p15RpIQAnQ81pLKM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977760; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=CXpQvoH9jL/54pJyNmcqlS3Y6t709TK/3sP/jYyYCZU=; 
	b=NZyZzrXp0QdTzwxwKsCxIjIaiVVOA+no4R91yXoWdSxF0z/gyHj5/Gpjidw12oRfYSrdld3Yzur+XoJDWV9ZfNDjTkCXXsjngucvUvvrykcXVyW/yAXYwv+80v8ozhEpkkaUKJGM7OqeS8arsYYbWWHWniiSLhs950yL99WZQRg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977760;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=CXpQvoH9jL/54pJyNmcqlS3Y6t709TK/3sP/jYyYCZU=;
	b=S1rC1MQyyVxUh5al7QzD/wEtVu0CmD2bLe+i9LKJ+7ptHaYzR0G48z6r+BrAVQW7
	jYiG5zrcVD4s2Lfc/fxvmu6Yth9ziyoLW5uiVmJVlmwAKFvZM2WY+t0wU4jbYoDkg5t
	7ThNDHHQcLZAZz6U2Oa5pA93JU1WwkDUolq7NmkI=
Received: by mx.zohomail.com with SMTPS id 1753977758262407.9841044700861;
	Thu, 31 Jul 2025 09:02:38 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 3/8] selftests: kselftest.h: Add __unused macro
Date: Thu, 31 Jul 2025 21:01:27 +0500
Message-Id: <20250731160132.1795351-4-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: E771B20011
X-Stat-Signature: aefbnx8b8ni5nqyn4zpw6rrqa3zpzipt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753977776-524123
X-HE-Meta: U2FsdGVkX18+5LZfi7SlRoxjkvltzF4AysHOwyS031jTtcJVuFRXXGDLqz2PD8nta3tFiJPXFj8k4oVpHEJF75QGaFhzZrxT+b9k2WdeeBjZl2HxyxPj5wwdU3GSdkLPITiE8OaoAqeFQWcxsdryGA3W4icjFdc0vQrHKx8vGFd/OUmtiYSlyxSQD8naQaLkbWyVjqRqug04r7zhw3l6o8EQATqcM9It3j7Oxn6y0OZb8wSeTbSeC2F1yQI4n+KeGZ8hjR60kpQ5dE1qTvAiu90uVrcRjhnScuwGwrLfHGvwnTdmXls+lq54Lj+CQaoB85XtPCNwsw6OsNi5tZmUVHaOlP3JSwkA6vQmCZwWTTj3n0qaNYpLWy1hs0tg0lL5/qOPwNdwd5wvL1S5dCjquaME8MYV9YfiY8iCb+5j+3AA5laxHIor+N+ZaQO/onOrzAHTM3uERMk9Z1r4pCS5lT3p/sp9PyDRCeYgiqKccqJofDQOKt+7fd7/9QSxcy4Y8FnIyb10dEFcd+q91PjpdS4ltZwr8+I8N4PBNv4OsFhBe02hMZn5aZCGIKaE75gr7icSX17vZbK+V3ETAF01zlypCQfB49MeWzVFr3fjtFfy1rzenUWXP4ZNDd0YFyqlsx9H0e1QUzVkLpRPJVe69L8rgIr3icp873SawKGelXWgVIAuKioU+15WojISCVQ1x2MfcPGASO3BtQI+G9yPesn6cUOOegS5MhXrAIeUWwJRQChomN6HBmJYnZKSjRheJLlLWo5Qh/3pJGRNXtpt930gSgm86+hrQ6LBwSLwxpyCWsukjCCLxpyUrqyW5AKy1WJGLrRdzD/vhWmc/4FP8L6zCo6q0K89f7u7vb/f6Cr1dRgZ6sl8MHkceXNeB8Rpbt99e0WMPPo21zRZu6/VTRgQKID23tHDN+vm9W4HOUQktUrBQtSGq1tpgKue4/rO9Qkjt9pNasEXXU8ZdWR
 hqxP7Ugb
 REXKdPcXbqje/UIxB1ijpJnAJ1TJwqFet3lpFHVtVle1L5GQadyjFwD7Wco6t7FjTwuZG2l+3dBbcG+Bw8gugimF/OycTt9C0cYrEO7n7K584zq52uIYOegSNhI8tPD1taVy649ITkNqXKW6CSsKBMW+hwQLOsSn+7XXGwoElvOgt02nbJzW6fj8GqYyDghjoDa9s4A1briboX5j65ziEpir2wMYOpeeUSKv2fNfgXd13EIOhN1dkRtAciFV4dYS3ZLgreMvlDWLFqaXl3NShgpZizXsCVXRuQzS4GpuFeQPq03aVoQqzFih+OPmf16Ql8FiJL0lP6x4VuD2D3JqYNbxsg6BhMn30Fl8SGdWe3+1bIVnxzaFjtKRXfqifa6yh1ni0oFnFZtUunLZzG1CoBVgD+SSAeT8KQCOgGxNMSsPYRudloASP4aJvXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add __unused macro instead of using the complete verbose unused compiler
attribute. The raw __attribute__((__unused__)) is quite long and makes
code too much verbose to the kernel developer's taste.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/kselftest.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index c3b6d2604b1e4..8d17036d88396 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -92,6 +92,10 @@
 #endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
+#ifndef __unused
+#define __unused         __attribute__((__unused__))
+#endif
+
 /* counters */
 struct ksft_count {
 	unsigned int ksft_pass;
-- 
2.39.5


