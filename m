Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0979F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5036B6B00CB; Mon,  6 Apr 2026 10:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4316B00CD; Mon,  6 Apr 2026 10:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1EE6B00CE; Mon,  6 Apr 2026 10:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEB46B00CB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4D2F13ACEF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:30 +0000 (UTC)
X-FDA: 84628341420.02.3A29081
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4557F18000E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qPJrWVSY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485229; a=rsa-sha256;
	cv=none;
	b=Riu1MX+aN/+a9IMtC50cB+IwyfOwWFvTJs1/JDjjf6vj58pPGDPfAlY6oZ8lKT7G/SGcAL
	BdUfGdd/E/fAMhOdX46IEWp6g46s5RrogXTLqhT5SHTomv67bV9ggHmty8DQ8/8ZZHXg1j
	EiBcs5x9KugyHDSRQbtNwawsyRWt4jY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qPJrWVSY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3KYmiOhib6UgMB+RvvAlGmKtMO4Cjsc7yUgYi6viDk=;
	b=Pg8vLSZQ+LD0CeXfzzF2Lld8610zyVm/gnnlCJOfIH8cOnZ4eMJJyv2Svh4vAG70vFC56M
	5xcdxBGTb81B9DyF0YjiWqCUkDseLlwkpdx+WhTAFKbB4J95uOuDyOpArsXGwcS/Of5iDz
	w5C778ML9EB0L3TAsj1dZCtQwnZdddk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D449B6012A;
	Mon,  6 Apr 2026 14:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A920C4CEF7;
	Mon,  6 Apr 2026 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485228;
	bh=tO4w/saWs4TngI1dGJjVb/BDaQv7f0xtr7dZaOtNvYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPJrWVSYPEcYgqWceoyxpdlNMa2cxJaWbuvyhl+Wf32f9z5uavVsPdQxgPzIrwgHQ
	 N8JmXTzhzNKBsrEB70pVaZMU8CYlUI7oDNSG73oQXwTHZBInQf8/zwChhEaIZnzdVS
	 Xwe6wmCtsUfN0mgHw1NR/CtQoMf0Q4dXbCl9SlPDX/LA8UuFZUz6m7xmu323Ikl8dr
	 0aNx9EcqzS47/Mpmpv03X7uHOccrv9ixIK7P8i2zRLkle+wyHtivXl0jNdkFuGxiEj
	 423+e1VWKXe/FPU3eIjleclk73L9pctdblACnQynTaVw1SujZj6LkUGuoIJX/kFibi
	 aZ2lyEbPLiRrw==
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
Subject: [PATCH 28/53] selftests/mm: vm_util: add helpers to set and restore shm limits
Date: Mon,  6 Apr 2026 17:17:10 +0300
Message-ID: <20260406141735.2179309-29-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5m1yrt63sm5p7no8s78i8yqxpzox7xk9
X-Rspamd-Queue-Id: 4557F18000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485229-892837
X-HE-Meta: U2FsdGVkX1/m727nM65WshWQIDv78GOzn6f2DNm6vO/cmQxhK3XQgh2NowBCRjWWHMQwPDVQf3lJoUgCT4HNV6h842iRUqN9tMU5U5rtwlC80hVuFyo6CUZdIAhYbLSCtIoIFKXgsG7Ya+1PYWsYx4kVISu6cwKb/V4EXsxos8WqAGniZz8rEkfqS9rFZeXmV+iMdrNPbBf17NEhQm4KfYs33M1SgXpb4Opa++QdWBz6quglU7/hZRc7EcyNDk1LD6PqelES3yWIdT4RmGFckjaHQyEgh6zB16ArHgrzqLaCgVSjvd2TEX4X4W0ocHWxNYdOf7cFlmVLZuoNGV5tjMZGQqTT74zgIOLKm5loENXreHgvz4ODzzsG3ObM1a7iYRKcSwd8xPs0CJLwMWwvuL8aLfVg/P5sHYY9TT9Bnt25lSFOw1paTn3gVmcuuZL0f6zQRMU3+AIISm1o99CtCKHQ+82LeLRnerxzc2tdDyqEQYnNDjUgktRjTPIgpWncM8Z5AfD2/i33euB2/GIBQVJ6egH5umdkxW7L0Z260pDNu/jgBbCd9kerUI6Ek0mEwCmzn85H8qWdV5lc5LtUAq0uiq5yFSF5tDFQbsSk5kff9pJHAOz0aUQ+tcwPwWFaGQqUEwzWp5nGPCjzuzxIEJV8YiPUyRy6eReeGb/nIKqP0swhsbPy4vSddz0ysjtf49kmU2uj/amKYRelty1p7AUDpRj3bpBO1E/kIvWujfphfywV67tbVgQwjP4mPzzF6NJTlJ+6uwD5tmOtcMdoCjPESh4fmYj8451dz3dZwgHB2WSPpIUuoJ26cyJ71s0yVlWapCihgAj3UxYqQG9eudx65TUsuWaNa1ZciMNdtXr0NntCXvpisFK/KawVwTzkbiXYX5yuaaof5zccFFi09DxvmC7hAnIGdWXlfMPZywLMovMzfqqlnl/kPzYaU8BGG9tSSYWJQFFoKfgGVnR
 YvWraTdU
 fmn31YEFQOUtpn6wqAz4Us9pPcXsKyWdxWoIZOyFomAbLTkmgbNGSwE+D55Zj6GG+Pt3j5dAjnyVnXt03aLFuTdSqDKn+0TXGowsMz7hT8hO/PDDdsnb2ON2DtWZwoynNPVeYexFV6INoCIGdBkjSAQw0ABTjx4N+HSr4RzAVE9l+8mlsBNE1BjovzECVkgQX8OfISYbodJIAbv3by994Ih9/KwvN0bpWlptbBPnCRumQmm2GWLllP1Ugx7pJaAwtuHoYol1dSkjOP2oZCgN6bfkojg==
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


