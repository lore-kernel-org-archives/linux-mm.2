Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191AFCCD185
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 02:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3C98E0027; Mon, 13 Oct 2025 22:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684578E0007; Mon, 13 Oct 2025 22:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C178E0027; Mon, 13 Oct 2025 22:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411EF8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:34:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E49BFBAC7E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:34:48 +0000 (UTC)
X-FDA: 83995151856.20.1F41497
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1BDC680011
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:34:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760409287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hZjisJgnzE8Y+BY1h4B2KaiB1xBx662MQM1196IO0b0=;
	b=3d4N4dZbMmfoLp8BYnfTayehYkWTih0sIkpCIiTa7kr+cujR1HIkmnRaAFEiFD/bznS/4R
	a3tFz60KLue/Aeui9w8JNLoWbJER6vJJYfkBlEqwHVQ/1Ym5FZtR3bB2oF84SuvcwSyVLa
	YKUf+SOknmMjaBbmhcU+KpQppGqQrA8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760409287; a=rsa-sha256;
	cv=none;
	b=5x2R3o01uj54I+kRjNFsI/9E7z/tIh82ddYF/XhaXgy/CJjVdVR6yQy6uDk8JjYmpqFrMq
	Xd0jDILxYZxZovZvYpEDcFd3b1Hv+ICoCgOR6/jVv165NQfdbwL39bd84Rh1uxAer+6uh9
	sUirSvAHqjjMs0oDh2jRZ4+QDS724QI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-781db5068b8so3841785b3a.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760409286; x=1761014086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZjisJgnzE8Y+BY1h4B2KaiB1xBx662MQM1196IO0b0=;
        b=EgBlO+YEv78AmalCPlmbEeJgt0H6dxrbCFHbh7YYcqFoehy2QRWrp8kkBXXC9cZp+G
         xaMTl+zP7F0TFp3jLDFyIwvK4m73HLhs9lXikB9JkIpXjOz9zTgT9Vffjs3+kY8qFN9Z
         wHLsH8z+nBPGl71zSRlj9Ndr2utg8eqg5yrwNUvkZg4cEh+cKC8VIk5v57sSorn22oIx
         IIIyBGJ2B4+yqfqGo7isNg+pAUdjPMw+Cv3P2ro5heT0ZHghaqucJeKcwargd9v6kzU1
         3SCn2QzKuP8NpmmJ6LHjgEFATYHokhQF8BHL2kxuNoXrMjQg36UbQDmDpYR2apF3IWJh
         9HeQ==
X-Gm-Message-State: AOJu0YyonREocFXiDKmtbchp48ZWP8/c1UZZTHhgcf0/GvXWYF2p6mmj
	RuqilptbSQNIh7h4m95Jq1lqzLzANdu0+1o/IEoZ20CpG73VwrFH7h6MurP5+Hej
X-Gm-Gg: ASbGnctE2l28bV57lXBw2lum77psudunyo8GONGMI3JuPlrL/4SEXr0LwW6Eze8pKvT
	nz/YaEk6Ma96SLI1MgcTBvv7j8Oehy6ONtG48uOenaXP01UH/W1N5LMgyKvGWXR6S5NEeHO2U5G
	kxFZ9u4x7IydVinJtxixUz1TIfkflj/pQsNcTi/odeCZa6Fj2X73XTkhokYRVedB8Ymll5KuxYG
	VWilgkmj2XhwXLngIG7gnj0cHtEPfWepw/9thaACBvAJh5hlnLLncHWgGhGSvo6WeDdhTZAAB5J
	q7miGvil8l0bblfko5So4z9556EpNd+T/FO1x8WeYt6Lr2jCA/68Rh4Tj0zqQPmKBWn31o4Q6i+
	A9j3ksNE9QlASsTbpkAeYreusbBDzeg==
X-Google-Smtp-Source: AGHT+IHAt1umQylxa4/Yajbo01iA4gOrM9C/4jJR27f0749sEEubSjiAiTZ3/Ohup96fdMKMZ2M4DQ==
X-Received: by 2002:a05:6a00:a0a:b0:77d:13e3:cd08 with SMTP id d2e1a72fcca58-793859f64aemr27785297b3a.5.1760409285802;
        Mon, 13 Oct 2025 19:34:45 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a11:3:200::202c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b060c4esm13322561b3a.14.2025.10.13.19.34.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 19:34:45 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Shuah Khan <shuah@kernel.org>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12.y 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Tue, 14 Oct 2025 10:34:28 +0800
Message-ID: <20251014023428.26814-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <2025101329-cyclic-cylinder-9e6b@gregkh>
References: <2025101329-cyclic-cylinder-9e6b@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BDC680011
X-Rspamd-Server: rspam02
X-Stat-Signature: n6rzodurwxrhew99uxtaj5bayp685un8
X-HE-Tag: 1760409286-612962
X-HE-Meta: U2FsdGVkX1+5LiaauV8rHyr5DV4xklgGBWaBfbWWDad+OW+NIagoUYj5YHGIrj5AkSUTIxnU/UBfuPhh+S0v9zfOZdxVn1Ggm8wQ7LaAm7FvTvHdZCu357Ral40plmKuVo3qddu7NWuZsHV6qJyK6u0+47dozaqk7WvhN7/Ol4Rmjc03XozaU+0qGAQ3L6B05f2o/n3/LettPdP8jYzj1AqlELvysr69z1il3N9EFaNhkPJ5HW8WuKc4ZgzaF+XLjBAkBTiseTyrlSKjttq2rB/e2lSsLRPtqkaBkwkbry5B4CtPFBVvGFjRf3pFAQEil1SyjfSVBzXOOJott6Qqxr4UefBJQxHRfuWuLev+uvqC1LAb1hlIUnZYG7/kCACjkF+A5e0LlfIyHLXES+hT3WithHO/w5aRFgRy2XMIqsUBNsv/kQx89nGaKn4MWiPgUUxEJb6eE6ffwElONd3D6rUeGN1tiLSVngBjwy7faN94prrAd18UILhyNg+BjL1NdsSMmSMCz9yBsfZBR6gxDjmJWc9xNbyQKas7+n/1KcuURh7CNRWjjfYCgWuRLha2BwXPRDy9BYwDo/JwGT8X5YTOehrA5aNK4ZHlU4a6aVfJUR3er9IK2pPVk4K+diM3VLfGy9/m6X3f1fGiNkA/dU4teYP6/D8rSRJPZfdOe77FoC43eth/TiykE5rQG4Y6UjBSo4R1cAtg5OKePLIa03XpKBIEBju4HhUKco6ao6JugTdCPqOmm3zxg66d8oizlOwNbOeZRK4PY/brSixOC/AO22pXEo8jy+iA0oIKFfkNf1o2l/Mlu8eNb1UdF7nsZyiQLfsw/cphZ9y6y35JARD5uqDtnNaDvuruwkLyDTDbJSMN1MBx/UlZex6r1tx5+d5K+RaQ3iCV60/MAXhtHXNfw9FxvyDOamZ5Y4IpA1vxvHdWRHfgCBEoXbTBbVdqHfxfCRyLwPlcg0zo3wR
 P9PLi59F
 3FRUWIzIFb7DbB1k34uboJ1Xv2Zh7Jh1uZz13006HynZjnk9pGz0woJGDHiASgRUSIIV6c8rBN3Xw+j5oQv78jyY7Tw03cEwYJTa5Hkjf4BQlIXq1xaIneUrHAS7bMQfRXyuGVUsMTsOUtsWu3RQKqn3+hUrbIGeh7jOSkzjWHF1YbTgssz3dTm6rr9Bfs5O8ggZSfag1SIMt17+8pEsnYq5yLlIntT7Bo3dmzdahQiNPi8/3JUr7kIEsZjo6yCj11gUe3iHtLM+0L7Ei5vaz4QyEKeD8JAlKKsJYYDkL0C2XkqD4V8dMVZ0THbhpBgZVL+s2rFIuIQrXUH7CGltaK29Dr1qHi+74BnX+9REvxRmJKEsdTcbDSkSDQYZV2OAqHcbkwYpSiNP4PrK0MT7zFqKZSlGGapcrZyR7PYf477ZkFELixu4X9uAUwPB+cnPNOl3zZJ0PrfH2UGK3ER04jrpmnyf/O010rLbJVk8fwfLqRSX3Z8Rt+MLanWA2sqvsZnlqiCkRcT3s2zsFFkONEdgR31/41DmPHJrTc5+yOmVY6bSZ7XWrEmZixlcWqIhxk60rBx+xEKCuDptOLA+faQX1UZURwVysgy/NZRLahyOjUww912zY7hTWeOJQXdmN9GH1t4su9t4y0ooVXkG5IPQwuV3aXoyEP3vhJEk/IcxDdeVl3D3hPPOsdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The madv_populate and soft-dirty kselftests currently fail on systems
where CONFIG_MEM_SOFT_DIRTY is disabled.

Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
tests are properly skipped when the feature is not enabled.

Link: https://lkml.kernel.org/r/20250917133137.62802-1-lance.yang@linux.dev
Fixes: 9f3265db6ae8 ("selftests: vm: add test for Soft-Dirty PTE bit")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 0389c305ef56cbadca4cbef44affc0ec3213ed30)
---
 tools/testing/selftests/mm/madv_populate.c | 21 +-----
 tools/testing/selftests/mm/soft-dirty.c    |  5 +-
 tools/testing/selftests/mm/vm_util.c       | 77 ++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |  1 +
 4 files changed, 84 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index ef7d911da13e..16f5754b8b1f 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -264,23 +264,6 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
-static int system_has_softdirty(void)
-{
-	/*
-	 * There is no way to check if the kernel supports soft-dirty, other
-	 * than by writing to a page and seeing if the bit was set. But the
-	 * tests are intended to check that the bit gets set when it should, so
-	 * doing that check would turn a potentially legitimate fail into a
-	 * skip. Fortunately, we know for sure that arm64 does not support
-	 * soft-dirty. So for now, let's just use the arch as a corse guide.
-	 */
-#if defined(__aarch64__)
-	return 0;
-#else
-	return 1;
-#endif
-}
-
 int main(int argc, char **argv)
 {
 	int nr_tests = 16;
@@ -288,7 +271,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		nr_tests += 5;
 
 	ksft_print_header();
@@ -300,7 +283,7 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		test_softdirty();
 
 	err = ksft_get_fail_cnt();
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index bdfa5d085f00..7b91df12ce5b 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -193,8 +193,11 @@ int main(int argc, char **argv)
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(15);
 
+	if (!softdirty_supported())
+		ksft_exit_skip("soft-dirty is not support\n");
+
+	ksft_set_plan(15);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index d8d0cf04bb57..a4a2805d3d3e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -193,6 +193,42 @@ unsigned long rss_anon(void)
 	return rss_anon;
 }
 
+char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
+{
+	int ret;
+	FILE *fp;
+	char *entry = NULL;
+	char addr_pattern[MAX_LINE_LENGTH];
+
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
+		       (unsigned long)addr);
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
+
+	fp = fopen(SMAP_FILE_PATH, "r");
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__,
+				   SMAP_FILE_PATH);
+
+	if (!check_for_pattern(fp, addr_pattern, buf, len))
+		goto err_out;
+
+	/* Fetch the pattern in the same block */
+	if (!check_for_pattern(fp, pattern, buf, len))
+		goto err_out;
+
+	/* Trim trailing newline */
+	entry = strchr(buf, '\n');
+	if (entry)
+		*entry = '\0';
+
+	entry = buf + strlen(pattern);
+
+err_out:
+	fclose(fp);
+	return entry;
+}
+
 bool __check_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
@@ -384,3 +420,44 @@ unsigned long get_free_hugepages(void)
 	fclose(f);
 	return fhp;
 }
+
+static bool check_vmflag(void *addr, const char *flag)
+{
+	char buffer[MAX_LINE_LENGTH];
+	const char *flags;
+	size_t flaglen;
+
+	flags = __get_smap_entry(addr, "VmFlags:", buffer, sizeof(buffer));
+	if (!flags)
+		ksft_exit_fail_msg("%s: No VmFlags for %p\n", __func__, addr);
+
+	while (true) {
+		flags += strspn(flags, " ");
+
+		flaglen = strcspn(flags, " ");
+		if (!flaglen)
+			return false;
+
+		if (flaglen == strlen(flag) && !memcmp(flags, flag, flaglen))
+			return true;
+
+		flags += flaglen;
+	}
+}
+
+bool softdirty_supported(void)
+{
+	char *addr;
+	bool supported = false;
+	const size_t pagesize = getpagesize();
+
+	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	supported = check_vmflag(addr, "sd");
+	munmap(addr, pagesize);
+	return supported;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 2eaed8209925..823d07d84ad0 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -53,6 +53,7 @@ int uffd_unregister(int uffd, void *addr, uint64_t len);
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 unsigned long get_free_hugepages(void);
+bool softdirty_supported(void);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
-- 
2.49.0


