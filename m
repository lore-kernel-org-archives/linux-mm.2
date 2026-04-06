Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CEEF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5789C6B00C3; Mon,  6 Apr 2026 10:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FD96B00C5; Mon,  6 Apr 2026 10:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4666F6B00C6; Mon,  6 Apr 2026 10:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 352906B00C3
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F005AE13F4
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:07 +0000 (UTC)
X-FDA: 84628340454.11.B9A7F8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C2264000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPUR8tbe;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VUcD001jzpiQXtrj7RFlcVDxuMqwRaPydFSJTdD1Bc=;
	b=wIhXCdXk7pwNuF9vu+Mr+cs+dNjlp+m9uc3r3iRpPuUdLl44uPytY7fTuRizC/HOu72PJX
	wyNqn9rNuob6K37G0+3MnzFs9PJHXd9s3LdzYWe6rw6U1yXmL35ax16wazk+v7rz0q3WrI
	jAul+0jFKL97GHCpO2j1P5H88/Is+rg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPUR8tbe;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485206; a=rsa-sha256;
	cv=none;
	b=zjaE0fF+BN5fgCtgdWsk+BeAAKOb2Cpr2IqWHs1MHU4oS1O2cU8L443Z9J/14R3qG9+Rb6
	bHsOKWbJpsSy2FbzF1YFDAb8XqgbipyHLvR3xQqdXOQwvB35PriaakmavY06M13kXKeH6+
	IBlzIYgdy0FDAMlCZBDGHjcfiCxOftU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0E6F60126;
	Mon,  6 Apr 2026 14:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A92C4CEF7;
	Mon,  6 Apr 2026 14:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485205;
	bh=6tmwrYqrWIbuMw5GfhGQhH/MUUQ+JMHsDHml8bmka3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPUR8tbehrq8sIopJHruHA24Q29wdaN7HX0Sz2TRH7iMVw5RMfgKIetZ9TB+Q8AA6
	 G5NHtI7C6wjBhU9iWbl8OrsdtgjyLHaayZ6DejemmqazztZwFBMx6C++c2fGzXZfuw
	 LfSeHm7zncRGlptJZC098O1y6faDJknZ/k3GljRFrZgHmlQDOnmZHEnBXS3ZVFEnCk
	 F+jfBh/dlcxQ1i3tYuJT4HQOzwsVzlx4lT5NATSuKcS0qwjMow4aUCsmP5txEjbRDN
	 zgfGn7Ud1YxY3jW2THQD8S32qDM1sGTuQwXgo7PwNKx1PwmMEZhyRk1n24l0lIBLXw
	 8zc+m/aFOWtmg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 24/53] selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
Date: Mon,  6 Apr 2026 17:17:06 +0300
Message-ID: <20260406141735.2179309-25-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ocqh1cdnjua3mehd9sqan5tsy3oe8wcf
X-Rspamd-Queue-Id: 4C2264000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1775485206-510379
X-HE-Meta: U2FsdGVkX18Sqk6g7Ok5OwJy/x2XefcVBL05LVtnMOrak5Uihx0870A8j9O84EP1OtgHr70mWDF9/a6wC4pU0pni9PRAY7RHVg935T8aPSQu/63OofmwaAlPiDTymZqYbSHKfXsH/teGdko4MOZXkx+u2jfqTUeIBerV1vQdU5HoY+DSJW413wpx8Vc0PZ970+RT+C8G6XiZPzUuwN7cnGVQm9Q8oQ/FMY7FW0KLpcw9+5tx8usP7W9Tgmrv3GP85Zaxc3Ehh7o6kCXbZgJQKjq6oRikeIsr3HWPPu+DCFf7cswu1dVItL4M7tykXRDrLCqgQVQMA2FB5Sk3/RbotZ6QBnO26KZNLKwPOutEZXmHg1RNwmPWTWjTLXgz5zAjRWqnfsKbl+szRJRzYfE3jnpWt8oeNsBAq7WHHS+K82zpZcCbBey3/tc1CZq3sdkxakp6BVYFvDMefZJTmSfCow6aDGg/Ww2Hpgfb3MXPaqsknfloHlL5OLrMzDEU/mnYaZYSopcXMV8tDxcPq7Y7ocp36YXolz8RtFoaQbPRxsprohwOk6hlyPA5cYv7XA3K6jGcadJj6uq7jGtPkWQU6Qn/n9mv7q1yMtKxU0OPnPE919x+HP6/5zO+MJaNdoilbTTuZHNnU16Xks15uvq9V5kQiLCru+b9UElNPTfDxG42jYs2cckKNDtnyn0HSdZLCoNLp3bqhIJVZSNkCjYCoeAxytfb5UzQIQIuhTOayQn33D0XGkfo/qfHof1IvC8rf7RfXczQCuy4MoArjzuLcIyvZ9iQD5RxkqDW3eNwoaF9+WCdlsUSbqwYq9NnVlN5jAVeZa63YVB1PBmxtgvAljSjC04FzxTLYB3ZDe7IxXQrSTaC9vjg3T9aIiUpvGhaNad8Wy1DBovhHZ1eCEFQdMUYNy61mJa+gvRRIVAiQGgPzKOchilXw69gpOP4WkqMTbxz8C22jsgRfAAt7zu
 T5J/Wz+u
 T78MsFYvlMj+Q3Xh4+7Q2Dmw2wEq6WytHeNITDK/YcoPa7UGE9F/CICo0FEfaHKmm5bE4/RTR9uH2J3h45SzMBuCUGtP8BBXnt8yuLFWqOamW1HfEPscJLIZYndzfwVrucf/PrB9sMLV9YAtDv92/insh1O1hv/UTxdSGybj18JeziL/kPKRnvTp4n+UWA4pNlvkmarTN2D//iirIK1DxOwDmkioTA5zJAj9QuADfqrRBchk5m2+peLIfzOU8kHdRnLMRbUcsCCltzmiZmU11r+yUYWCy7UT7fHwX
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


