Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5B6CD484C
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BC96B0102; Mon, 11 May 2026 12:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE0A6B0103; Mon, 11 May 2026 12:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC45D6B0104; Mon, 11 May 2026 12:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B095F6B0102
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C54C40217
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:42 +0000 (UTC)
X-FDA: 84755680044.15.274D9C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0A311C0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PjYNyoLN;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCu9wuZW707fIn++ZYRdiIXgbEKt5aFCJdlEHSRBAvA=;
	b=TIoOiTjIfvnK6OA6wIgv9LQQR8vQLISn6qBEk3K5JIvKrCdSjTx+1OQnPyxrH3bzs+td5R
	mv4ElWTnDmtbVavp93TPWv3uUG3z9ZEcT94zU/qRFj3RquOe7A1c82Vpcx37moGUPxJffs
	YTwCKk5KJfXa6CinhGv5XbtQ//6eMa0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PjYNyoLN;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517100; a=rsa-sha256;
	cv=none;
	b=wASV7myifrXiZSHLJFwOtuGm9HuIcWTTGbapEAAb1bCUZCcqG45GduAkkWZ2HrvUJ34CWM
	JjbqCkk0AWoDo6bbA2u8DMN2JEYS1NNL36TfWgBMkV/BgjVibA8KU1EwrYGu0XD/lX7eVS
	atQooqT1kfKdK+c3Thq73HxtlwpJb8I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F6E560121;
	Mon, 11 May 2026 16:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037D9C2BCC9;
	Mon, 11 May 2026 16:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517100;
	bh=pXMsXnfWgM/h8m4iqvonRVvJ3etoKtdEnVR62w9G5c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjYNyoLND5Zg6UaBYPSQw5v0x/Vy47GLwb8zx8AoTqLfjseDimzGA4KpTXjS3f2aR
	 eqQQkOAi4IRYToUe/txG4NTBGHFBHnPUfw+YpCedkz3v9DiTnWoqQjGxKxV78vGz/z
	 toWzuQMu11kE2aQIMJlCN2XiathLHZT+WzDbWvVlI8rG8MhGQG+6pR0GG0RJj8Gybm
	 SPavGf8DuhNvqj8mJCE3U6LlWmaOheL6Wfj8FZaMp468PEPt7j82qlI25sxLwX/4qh
	 pg/HyWd+zlqO34m5UrZTg6tHA1s/SS+QLBUDoTGfF2jQWKHHLziIh7laJJzVkad1cn
	 AbEN6ZLFklXnw==
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
Subject: [PATCH v4 26/55] selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
Date: Mon, 11 May 2026 19:28:10 +0300
Message-ID: <20260511162840.375890-27-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0A311C0007
X-Stat-Signature: qrpy3gmtm6ghrazgwac7thh5wcbs414g
X-HE-Tag: 1778517100-247449
X-HE-Meta: U2FsdGVkX187tOtSt9EV7iKm1NdrwRW9oGWVIQWYaJa0i6MiVAVVKEyi6sL0SSBWzsKmTruXd4hxBqvjpRA55SSCWfjiZLg0uDu1OBp+EzWd0cYF76iHDt97QBiInUxFCllqRFFPdRnijH3j9QTKpO42RhLV1KeVr3fbryrxixCWxSqJonbuVCE7aCzwgb/kH/I/iEfxDeu0VfQ6h5l9eRRedlHb8a/OSXnceVpUYLRwjUMM0R0NqXEtSXt0z8hLz8bnOIiGYVGjeMxrDqpYFA9mjnKEBYxct2vWmcz9dd8NFJbijDlXoRJBCr9GIbPk8fNXP0zKKoEYY0Nw0FL/jlZdUWek+yKjEcD07v6QMLwLho9WCPCaxysMt6YOAvS9hDF5SF8U9t8oRavMatY53etaC4fC9VCR51wyBTIlUAfPGLoUPkPidy7ymUPgooHuHZXpYB2Qk9LkrYRcGw46dGWc+z0Dd/LwPPUVOjHMhYnZuo+RHCMfmeRVCy7ULdHDHGZvYHBQNFuKVANYaMQvNFLAYv5uInogv5mem4Z/I/kOsD4NGWvmjDvjbbk6ZhCs6nOTUAwXYZ6zNN0+F2oLiuEK5t4D36AxZD7bpdPr5u9+JxjGn52tpUEXSdzqn5sljy7QraKcvOl7mx8Ji4ZsZn6nwPrKUnCDay/OmHIvlbEMDyNAZSfoUg2OzFhewW3R1Da5ytqYj0w+WgGUwSmRT69cEclXe3AZfHl5oDaMLNTax0rjT0GpfYHCgCtGHbbjYiPdADcQL98+rOS0F06KzQ1l6+HQh5cp7DwwDNtKT4mdDAZLmapdGRm+5UhxZA9bx619ixb6DIPJZs08qIPuLCbt9dlJMcvXMETh4aPm8dqrm3IHJV1qS2YU3S5f4ei3VkBAwhcNDAAx6NOVrX3ZfxmeMI17qJsVSzmp/wtgbSFSho+lErZBZMwzs1ty6vwN/JYq6w+sOsVXMrTDLG+
 q3unTo5e
 Mfu3f20quJJvXoAYv0AeV30Cmmn/11+eBZXZSOuhgTa4Jw3GaJmmda1B3sqHHtruvnJUXqqSwKYpeXD56Mk4/4hCv4Q7jHVr90Qrcv3rT1T8LhsMJB1zgkwtd9qClkUKmGaVX2/ZchLi8LhLxYk/tn0NCTC9kxR3almpv/I1/aSk7EKQi81C6wh2P5tR6dum7NphFcXV4ViMoLmESlz0b1jTtLGnR1uOjLDFs35g5QfN+2Twkk4HsxJEndt8wkKBrC2AztnZGxw6SRgHKmqzsrSvssGQS31M6re69x5OD8ObZqMw2KKO/D+yNqg3/tXLj5LWPWiqvd+vSQa6pwh2STFcnkxEmpKXQUYG/NT2bkDaeJ5Y=
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

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 25 +++++++++++++++++++
 .../testing/selftests/mm/hugepage_settings.h  | 23 +++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index fa635667aabb..99402cfccb6d 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -463,3 +463,28 @@ unsigned long get_free_hugepages(void)
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
index f49bd7fba512..e66302926377 100644
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
 #endif /* __HUGEPAGE_SETTINGS_H__ */
-- 
2.53.0


