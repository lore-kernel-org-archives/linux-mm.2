Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85B4FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8D36B00C4; Tue, 28 Apr 2026 16:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F156B00C6; Tue, 28 Apr 2026 16:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B52B6B00C7; Tue, 28 Apr 2026 16:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B30A6B00C4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7B62120237
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:38 +0000 (UTC)
X-FDA: 84709145556.24.98B0347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24CBA100002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2Yk6W1T;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VUcD001jzpiQXtrj7RFlcVDxuMqwRaPydFSJTdD1Bc=;
	b=kML8NeEd6WMAkgfjwzzZOt5AOpE4KtPetEvybddOUHeob+e9LOJKeEeC/ccv61xnl7eIsh
	xGgD6H3oSz/pTWH6sPrSCMaalI3rBjx3JsAHlFaYHdBmJz3HjL97u0pNZEVGIe5Ca2CrsO
	t0Pxb89B2wkPnFs3s/yvCPe5jDrFoqQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q2Yk6W1T;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409137; a=rsa-sha256;
	cv=none;
	b=gDDA3KE3/w6DGGKuEe+eUw/czxfZj8PjjieGLu4qhUD04RcC0rLW+vbjj950IMDTyqyCtD
	+2dh4AQKvneBPzsc69XlPuJyIr/dJht0OU2gkFQp5ZAPruqz/Ty+gCv+NA5N4ILOjUquPl
	V0I4HNcpZC9Py00ZUatgZ7FDOHfjj30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B45C40A78;
	Tue, 28 Apr 2026 20:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F61C4AF09;
	Tue, 28 Apr 2026 20:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409136;
	bh=6tmwrYqrWIbuMw5GfhGQhH/MUUQ+JMHsDHml8bmka3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2Yk6W1Tup/ZKaBNBSStPROW97IQHtgQWyBmaOm5+R37bRMYIQJ7GHA3ktQ/z/LiK
	 nX2UGEfOWlweXBNBx4SnO3CWQq7yqnB1GEu+Ma0CC0m1wGge9NjWH2qT4yfXA/CzHn
	 h0LJFmfeHrO2kO2Myyjdk6ztJ0aLOVm8sHGMovafiXVeX3WRJ3wMRIzt1MnwL+0Cly
	 VFUY/m2GrrJ7HrS6dIz/VAagWeXXOh564Yb4BsQI/270BYsWtReYEjbWt0kQSHngru
	 li09iiog7F9s8PKsg7EzlxiA8ZHCFFieMcwxuTE9l86B1QSECVusLnkoxALJbXFlTZ
	 137gvmJ8Y35JA==
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
Subject: [PATCH v3 25/54] selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
Date: Tue, 28 Apr 2026 23:42:11 +0300
Message-ID: <20260428204240.1924129-26-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24CBA100002
X-Stat-Signature: foztm6f999d51q6mi5nm5jdn19mbmz85
X-HE-Tag: 1777409136-115804
X-HE-Meta: U2FsdGVkX1/9++6GfDG7plvnyjafV0g49/cmp8ey9kSo23n+EX52K7e3mfPgPSxASXyr5YsFGv4xkV/XyjV5J+mH1tqIRI7TBvcNxZSRsDWqz9fcewoo3LtzvYtIQ5aldS/9pjpqlookpiKRoZDPlT5DgDkjIJ/mE/09GpvFHIMxg9UscdWSX4kz90tPSA39ksUbbFARHZjTk98ofs6fX1j4yv0A9wMv7eUfO7JL6EYRR0ddylzOtJ8GINJdqV5JPf9kNTpX5doC7Wa8XhD3YmwIvUndHcJ41kWbGQRa9gLOfIT8NQxZg2B3iMqWam+eKkCQQslWak7iaTuB1p5MNN3VD16kVR1fC9CGGQWG4lwbxsN9nuOK1s+1qSsZD4nuMZaezQGL9DsJppD1BnLFUQKhnLSfDudkTzVuafFFdH3CgVi3ECmWQuCiPYxc7IgOh/l86fYobkf6S2mC6bKarQH6vvp6XiGBrRKQmjKhzCTnGrppXq6JYRYZTWY1K+hAPpmS5qNcD+EE5L/Z/vvSHSd85LuBiGRKRBJA4Kdg8UFs1PGZRW/hC3NLRDVdqa41r3UKvW4ZHxxsXCcc2NPjO6ad6jfQyG6Xs3fcYof1cL9zY5fkiq0qXpWT+rlyB5gJk6WePYCAXj88xAcjyRMaFtCx+CYpVNjEgQdY11vvOCrtJkhoM5xLajE/zbTMr1ZCTxc+SKMv0wYUMUF94fqLjwXVaCs+QuWNxJKFh4p2EXJwrUHjqktPMqhlBnjSgKkTJfNZ1BW3jRa3pDgVPP7TZlTU1MTQ11kP9jOX6WXgfYDMcRJhMtWVLcfAQ02pXyxLbK8bvGv6VJ7JM8Tf85sGU2khATouP4h1vmToWxpYztWORhGVPQY0LyoJKfRmD2Y200ClY/XhVRoeoTAZn9/3c6tjiqWF25BhkhJb5r44Q/9rpx8cBBTLvhfYPLYLvaVZzh8vCBU62PbDb4uRfcX
 j/I78TzX
 CLdV+X1N/OsZM4Zxi0HYObRAUsWk2VsMx5JwEQsuF7mtzdnsSUqS/KCiOG47uAglKWkZAPwuHV8b/fBZe73VgAEq/3lDZfV3/iEnKvO/dSDPoLvy2WfImZW8W1fRHFIpCozscJAtrMV+Aw7iQ/m/g3Vh4P7quXTfPjnqXhdyftSplGRqVgFV7BABLUcaCtqa8spNG4/FpH+dXdiLTKy0jVx0FRzLbo9xCwsXFcIkUrKE2punDlUThR+uT/x31Bj9xGhcAbIV/PzeZZRkL9YC1Sk9qMNwDXjPxLVLg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Add APIs that allow reading and writing of

/sys/kernel/mm/hugepages/hugepages-NkB/nr_hugepages

to detect and change the amount of HugeTLB pages of different sizes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 25 +++++++++++++++++++
 .../testing/selftests/mm/hugepage_settings.h  | 23 +++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 8f563315b1fc..5961229b9931 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -464,3 +464,28 @@ unsigned long get_free_hugepages(void)
 	fclose(f);
 	return fhp;
 }
+
+static void hugetlb_sysfs_path(char *buf, size_t buflen,
+			       unsigned long size, const char *attr)
+{
+	snprintf(buf, buflen, "/sys/kernel/mm/hugepages/hugepages-%lukB/%s",
+		 size / 1024, attr);
+}
+
+unsigned long hugetlb_nr_pages(unsigned long size)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+
+	return read_num(path);
+}
+
+void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
+{
+	char path[PATH_MAX];
+
+	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
+
+	write_num(path, nr);
+}
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 9357d07e6c1b..d6f41a45e8ee 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -94,4 +94,27 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
+unsigned long hugetlb_nr_pages(unsigned long size);
+void hugetlb_set_nr_pages(unsigned long size, unsigned long nr);
+
+static inline unsigned long hugetlb_nr_default_pages(void)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return 0;
+
+	return hugetlb_nr_pages(size);
+}
+
+static inline void hugetlb_set_nr_default_pages(unsigned long nr)
+{
+	unsigned long size = default_huge_page_size();
+
+	if (!size)
+		return;
+
+	hugetlb_set_nr_pages(size, nr);
+}
+
 #endif /* __THP_SETTINGS_H__ */
-- 
2.53.0


