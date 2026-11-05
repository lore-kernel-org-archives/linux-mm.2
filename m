Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6280606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wj+bnQFe
Received: by kanga.kvack.org (Postfix)
	id EFB146B05C0; Thu,  5 Nov 2026 04:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEDC6B05C2; Thu,  5 Nov 2026 04:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72A56B05C3; Thu,  5 Nov 2026 04:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA5976B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:36:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B559A864E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:33 +0000 (UTC)
X-FDA: 85400560266.10.65B916D
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5238120003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wj+bnQFe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7tMtv9nbHUIAtxv3eTEVgmJcIdaFB9h8nrHOfA0Uqg=;
	b=sdLaR71xzVg2rvpxmHi4IwkUigbEDAg2RNVL7OVaLYEtezQLLSy8Q7n3MLm5c+ftjHTVHg
	4sEEhYr+EK71aw7pzkvZUhWnmy2AEfmiBM4EFB9AMNfcBszO58Aj5PvqQt6i9KkoxLticN
	iUbjObI4YGjBvnxmuYGPNgJSPzVeEWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871391;
	b=im7eaVadOfG62KDMlN9OxTiy4HBKIAZ6Xb/ajy6Yu/zoEp+qId7vN0t5p/x2HUgT/Bch0Q
	6O+o95wZB/clEr3X5a33GwumO6ujK7Cr6utqkLNGQhl2xJUSsohIyJBOp0D/PWbV+/qIgQ
	U0lgYSGzgwBO5/0YV+vvPPScFYPuCxM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Wj+bnQFe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-353804b591eso3192823eec.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793871390; x=1794476190; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t7tMtv9nbHUIAtxv3eTEVgmJcIdaFB9h8nrHOfA0Uqg=;
        b=Wj+bnQFe6aNFnFerQVRu+YijFyU9YCd92ejG/vykNHF88RV0xub9ZW6sLrk6rEqeZ9
         ZPf1YfZTigpc5nvVFjzpXac6T988NBu7sD3OsSZxd6kptqXBNtAU5WEBa7pcoa7mRRPJ
         d7Zh/dbCEKSnTuG+Bu1JQBUVurRIEDNIWwmKU2x6+z1w2O+Vft1BjhzpP3cdXdrkNzkd
         y1dZ7l2BgFrVhbG883xLJaFEFI3rqtCGT1tauElnTp5sNW8C2r53PrDn9IF5/8+ADSCu
         Ps54PWw9t4Q/fBGZOLTvdIljDmmu7I6JXuMetmFb3NtxSILNtUXTUfLS9pQbqgjL35Ke
         LXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793871390; x=1794476190;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t7tMtv9nbHUIAtxv3eTEVgmJcIdaFB9h8nrHOfA0Uqg=;
        b=vs8HLRBcf7QDypht6M4Yf/xM+Tp8GfvPQpjIXj9dRB9Sp3KW4t2k1HM6JZXAIlDDiN
         LGAmndeiY5vKqzyAOtNB36UuYKaglmPecyF2azyeMQ5gzGJRfcvsO36n6p5f9eDTK/9F
         tlR6Wy2aEaJRqJqkx+QknidCLGyKQzCbOiAsEInzCTg9kBjrMjyr8XSXcw/qIpMKJw54
         VSA18jr51lcp+Bi32C59kQ4Z+w6M0uMmSXNi4I6LSF6H1KJFGOFYYOyYMeL6I7mV96u4
         QaH1aJ/ZZGS86DGaFUMwS+j0wSkJ2EgT/1ZN1dSQcmMkl1VfWO5WM+B8VjySWSH/LqWj
         vWBQ==
X-Gm-Message-State: APuU4Z8YSCO/squNx7ECzuWzg9VZOgXdH49xIZB8siN37HyWV//khoHL
	KtzSewZIoqpB9ULkvPGkUbaVwC0lybx99/kntokeUeNCt9spCM5dvU54
X-Gm-Gg: AYBFou1A6RM8EGQpvkLQ7Y+EL2X/DG7Pzqkpaqk+QirTnDK/ktscT+CioDrgg4V0oJI
	ttArBD223I3gKVyVcrRSON4bwxbM9xwYDE1V1YuB2QatvN3l5u1h6pKrT7ox+/OBnlqyHWXEZc1
	oGN4vLORiGbCaw9F6pFrgns4Lzit1s15uOblf3Nr+ealMWj8mpmSAkUqjr7d/wtPLC6wUWhMGMK
	++O0ceIH9iHVpdMGB+MMM+7ORf5CZcIABr9UkJLPGdqb0yVS/0ecAarvSWWv1JBpk25sBYf9ZEp
	MOyiU53WqyEA/gWxo9BvcOcVNR9QgiTWUQw2TTFHGpypIUUgUkSNUkkZz//SNua1351ZSMlvpk5
	iB+TF/daj3ZQBgT5H3SzeRI/gd9V2CFqrbYZhYMhLOubDaBRM3N8fiPq2S/MeeCqgSu+oX0heMI
	S2YRNVpsoRC2svti1Ho+803bh4YiKQXaiVBLPtvG3MvvjBlAZwv953x0rpSQ1LFGe4kWSbzw+/L
	I7ObdwvnimrSyWMJgvASmfLBg23A05YzEdgAvJ4+25AsT0DYmkCFjQslxxxO+ppVAFMVoGfK4h3
	vl8R1vkeVOyXBBkM4OpTAZkq
X-Received: by 2002:a05:693c:8817:10b0:36a:1788:3d1c with SMTP id 5a478bee46e88-36a423fd04dmr28133229eec.34.1793871389924;
        Thu, 05 Nov 2026 01:36:29 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38fa273sm17363207eec.16.2026.11.05.01.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:36:29 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 05 Nov 2026 04:36:15 -0500
Subject: [PATCH v2 2/2] selftests/mm: cover merging KSM pages aged by smart
 scan
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-2-8a9780b6844e@gmail.com>
References: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
In-Reply-To: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 9utz7ihx5u9415z5sko17uihz8ffwhom
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5238120003
X-HE-Tag: 1793871391-390064
X-HE-Meta: U2FsdGVkX18p1hQ4gkxLE38t0jZrR8okIAA6d1NbnCTu8DO5rMS5fF1Jpb5L6b7jxKCxe/oClP5mQsgXQk7iJykflMgje1k4fx84RnRFjlHEtSJpNyyvb/ZAm4GUccZlxgc2sShCxu/N+R9PqIUSnh5X1LFN7xDpxDow9uhZ0NMBEfcgwi7vSLTujphip7NO9cRQgR/gxDTK0FBnX29qTkQkOJXG4BDVs4Q03hoNLF2bjFbTlO2dh7ZcmtExo+NwmzJy8W0M/kcD1BsrxCMXpSU4HiKv9ahcH9ZBKbNnSJDEZMytwCeFclKpZgi5YkaZuyKdYAk3J+M+ZYVdjAsjAvanbHLm377aHhWhaJVrhtJCnDGqznaVbG5qGsmJcKK1T5ueH7uKUPhQAX9SzmLWZBnOuKK1f12Dbr2XcyImOAKvMQO35XTADhK10RSU9QZ18Ze9frSrWygAncrUPA1zwHAGbCECokPib3g5D6jG9Ph/6Gzh9f445wmlBo2+OBgTHF70BVfT2TIADUasiGJt4O9jgTEaO2WZS3emd8qPJVWH9bXwtv3GQ8cReFl+MxRkhknEdKZKpdOA0Z0WY40DcE2rvJY48MQPPfnXGlK75XWUYR20hTCB3SqgLJifvfKadHPJ7tj1Fy2RPnlQN+PId8myQmphT9uCar8Tj4jrH4wlVstKwcwyelYP8dgRF/LwdnzADrHDc1BXtUTNxxc6NGArd5jJeMSDQm+uJF0t0Ja5/+6hIJzJHTCvSCHw1Jg1SyZZVVtr1SFBMNFA54aghMf3hCZYzj1y6OdLrNstnDIybP+aJ/BF5pJmHgf69ZfuY8Yswtf3QozIUkPD0ZkcGTWc9C/V4xTR87D0klRhAeOYpul7Y0iVIXLPlhe4phqOSUjKZ5bNhJNOEK9I55I+E0a6IBxFxCTKaoKcPu5Bu/tJqXFYv0Xc63il+0fbJwCc0/SlLefJJP9/woY2KcG
 dkx/HFc7
 7RYH9N05TU/0G5Bmlxv9jruAfgBn44MPBpCaV2C1Cr6Nlu2gkT7XVRSWu0ZgQME3AvGL4CjIAtxVRWuLQaHMkNSrF/N8tCpLLMzGiK1tP4vVpJHGqIWIk5LeqPxxXMZ3Az5wqpVkjvqIZHVljSi1aeWw6opZn0KLhUhg9F6BksTVRAeaECCOOZrV+Z1HLob2p9MUoyifnwrYv5LDrab8TvxvE1e+pXSEfasZqsS3X/8LOqalUst+/KyJPTnhZFcL67xlwjiYWmdk2S6k45bty009mwHmlYrM/U6G23cnr2RuSibNQMSJVRRCQUfy+cFv6DCBkVWtmT2xYdQZVBaQAsbBrWnKtTerr1tayHh04sOS615UuhCVCH9QGChsUs+P92YKW+F+qb7HfXlw89W/ylB4lpe1EcPfjET8QunidOSZHEnnw0HPb59am5+Qc/TMdwZ5JRzr60YrRByc9XpYbmHOjzaHcxfxjOWxhS8776V84NaDqmaESSbAxh0QirZsXlpMYLbUS5ovcRUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ksm_functional_tests checks merging and unmerging with ksmd's default
settings, but nothing there exercises smart scan, which skips pages KSM
has failed to merge for a while.

Smart scan used to time those skips per page, so two identical pages
that became mergeable some scans apart could end up never being looked
at in the same scan, and were never merged. "mm/ksm: align smart scan
skips with the scan number" fixed that.

Add a case that lets sixteen unique pages age for a dozen scans, then
makes a duplicate of each mergeable one scan apart, and expects every
pair to be merged 32 scans later:

  kernel               failures, two boots
  before the fix       20/20, 20/20
  with the fix          0/20,  0/20

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 108 +++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 31c06c72203fd..71d9b3cbdb8c1 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -695,6 +695,111 @@ static void test_fork_ksm_merging_page_count(void)
 	munmap(map, size);
 }
 
+static int ksm_wait_full_scans(long nr)
+{
+	long start, cur;
+
+	start = ksm_get_full_scans();
+	if (start < 0)
+		return start;
+	do {
+		cur = ksm_get_full_scans();
+		if (cur < 0)
+			return cur;
+	} while (cur < start + nr);
+
+	return 0;
+}
+
+static void test_merge_aged_pairs(void)
+{
+	const unsigned int pairs = 16;
+	const unsigned long size = 2 * pairs * pagesize;
+	char *map, old_smart_scan = '1';
+	int smart_scan_fd;
+	unsigned int i;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_RDWR);
+	if (smart_scan_fd < 0) {
+		ksft_test_result_skip("smart_scan not supported\n");
+		return;
+	}
+	if (pread(smart_scan_fd, &old_smart_scan, 1, 0) != 1 ||
+	    pwrite(smart_scan_fd, "1", 1, 0) != 1) {
+		ksft_test_result_fail("Enabling smart_scan failed\n");
+		goto close_fd;
+	}
+
+	if (ksm_stop() < 0) {
+		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
+		goto restore;
+	}
+
+	map = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (map == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto restore;
+	}
+	if (madvise(map, size, MADV_NOHUGEPAGE) && errno != EINVAL) {
+		ksft_test_result_fail("MADV_NOHUGEPAGE failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Page i of the first half and page i of the second half form a
+	 * pair with content no other page shares.
+	 */
+	for (i = 0; i < pairs; i++) {
+		memset(map + i * pagesize, i + 1, pagesize);
+		memset(map + (pairs + i) * pagesize, i + 1, pagesize);
+	}
+
+	/* Let the first page of each pair age without a duplicate. */
+	if (madvise(map, size / 2, MADV_MERGEABLE)) {
+		ksft_test_result_fail("MADV_MERGEABLE failed\n");
+		goto unmap;
+	}
+	if (ksm_start() < 0 || ksm_wait_full_scans(12) < 0) {
+		ksft_test_result_fail("Running KSM failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Make the duplicates mergeable one scan apart so that each pair
+	 * starts out with a different distance in scans.
+	 */
+	for (i = 0; i < pairs; i++) {
+		if (madvise(map + (pairs + i) * pagesize, pagesize,
+			    MADV_MERGEABLE)) {
+			ksft_test_result_fail("MADV_MERGEABLE failed\n");
+			goto unmap;
+		}
+		if (ksm_wait_full_scans(1) < 0) {
+			ksft_test_result_fail("Running KSM failed\n");
+			goto unmap;
+		}
+	}
+
+	if (ksm_wait_full_scans(32) < 0) {
+		ksft_test_result_fail("Running KSM failed\n");
+		goto unmap;
+	}
+
+	ksft_test_result(ksm_get_self_merging_pages() == 2 * pairs,
+			 "Pages aged by smart scan got merged\n");
+unmap:
+	ksm_stop();
+	munmap(map, size);
+restore:
+	if (pwrite(smart_scan_fd, &old_smart_scan, 1, 0) != 1)
+		ksft_print_msg("Restoring smart_scan failed\n");
+close_fd:
+	close(smart_scan_fd);
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -720,7 +825,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 9;
+	unsigned int tests = 10;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -753,6 +858,7 @@ int main(int argc, char **argv)
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
 	test_fork_ksm_merging_page_count();
+	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
 	if (err)

-- 
2.43.0


