Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC8A606A337
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vgUl/W5W
Received: by kanga.kvack.org (Postfix)
	id 6C5D06B05B7; Sat,  7 Nov 2026 11:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6767D6B05B8; Sat,  7 Nov 2026 11:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5652B6B05B9; Sat,  7 Nov 2026 11:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 238366B05B7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:57:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A04F114034A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:34 +0000 (UTC)
X-FDA: 85408929228.25.870D8DD
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9BEA120004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:57:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vgUl/W5W";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794070652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdH1Q08JYIXzl7woAIVqMXKqevpqYl9Em5ExAHktt1c=;
	b=WkpImogTxDApmd7hvUH4eaLQ71PpbTwvlst3yFKAEfCncMVxL2MQsBYpZ775G7i0ih1G0A
	Ru/jwazFc+zFIGfMeL8DGZosZd9y2bOPGgaefYvYZBBhroh9XYYariKMw43ONn4GiYgExA
	pKNCpSn+7xqqqzqN6oMabKZxJUETeOo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vgUl/W5W";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794070652;
	b=MeHKHOfWmsI18uu7R4XXQpTEfAD8u+MpiDz5mKttApQyZFBFxMLIbTH6CXW+ZhwsfNZE7B
	6c2Ms/1w780s5EFWYPo+pq5ZqrjP3hv6OBcnIUIIkN9xeRq8J0iT1eP2PGFhJ31Z7Gg1Od
	YPP2Qw5HoRc5Cc0AL775KtgzIBLFqwo=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so2060619c88.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 08:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070652; x=1794675452; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SdH1Q08JYIXzl7woAIVqMXKqevpqYl9Em5ExAHktt1c=;
        b=vgUl/W5WLAyjhsvSQ8nNijYHQLRHDLfi8Rts+Az5heMWFMggCgObmXGtqSh86+49jw
         n7F5r7nz3Y563XTHHn6jIgcMQWUpzXfnMk5MFEVjBZBJlxUbdcmXcbPIYYnzCI1sVA1V
         6lJkwWdkXLz7+FUrEpW89rkwRvq53fZRnwr9De2T/GYyg630IWnNym2mOy5bBMoJU3QC
         tonReL/7aSiZysCfOxhPEg9n/Y22cGrdcU5yRxABOpbF9dii74c9TkHsYsOebFVnK4nj
         MdMKSoztSNezKvUxPIXMzNzFZ6b2UIgKVIGNP/ov3e1cJkj+6Q5QiYaJ57hDszroqpvW
         TZew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070652; x=1794675452;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SdH1Q08JYIXzl7woAIVqMXKqevpqYl9Em5ExAHktt1c=;
        b=cKYktHuR0h4MIsTIblMhBQuVoWk9zsl7P01SQitsYLdUkeaUT//fDu4ZwyKaDRuSE6
         LCyXapHZSw1IsQE1IOh84tfIx4MWCCpJifL7fcyp2G3Gnymp/XhAwV+ryn2CEEleOhMV
         20r+WA8ynuUXIs1eR0+aZRSgcZWm3JwS4nO2jfCwL0TTvMKNBoDklglBlnSAyjkiDo8Z
         23Z9KE40zm5HixvUBIvvBm/eBM/hlylTcVkrjB8+GwB9bnkbBoYHYEr7QJMZqiflVIeV
         wuqOd2YtpfZ5+IOKDlXMKytgA4AtaHNAz+k0ocsm1YHO/I1FBdpCeqEIRZP8H9B5yZhf
         PerQ==
X-Gm-Message-State: APuU4Z88B9K9aTBcCoAIadLtPhI4dPNQ5SkW8mRG3BpJaUmaunzbpe5R
	sofL8cSgdQ8dbe2icAPbLyTM8/ygwwxTWwB2ZBWif6gtM67Wh0EGiEfu
X-Gm-Gg: AYBFou3n2BlBJ+z3NyCUQ5Yd4wXHgpX8pigYYPgyGIk1UTAquPhni+gwxwksluILgES
	Xx2yItWFdjdbu06SN50q9O9JMakzK3i4xBCuiHB57hXFMEc5tAd1vkToTpQ5qtM86SDgMeYwFlS
	BWsBDoDalWp0w/WZNL0Ayum2zVeNUkz6Ka5x4gh2XUIvs0/ASMb2rAslm3AQek7xgOFXabrwJkn
	S22fasn3t/qGU26y3EIxgzOQzSr72+tqtM4wDhz9rAm2H1UKaTYUpC5xWUhY1QCWqNvKFJ2+GQM
	4WDdvZgaqQKWqdD4zlA/oSijtcArvK/7DPAOvZheptgkx/USgU90mXYCRHjSu3O4mV9iouihisM
	qfWoQD4NywR66mWZG51MYaSHcLmndQA8t+B2fAjwfD0iSqvKaYm+coUQcFT03tKeEoDks6cunn/
	9RrJ7nHp3idvuBhz3UYzwuKXpy+3OofaMQssFfMbcorr0U3tIql2DK2KIxqXcz+rw1HAxg3Gsbe
	VWNyJJkgdQSkDnYA1/MntastxyB4ITZKw3RTw2Cv27ugQapRWo+vrz8bRp0lCj8T0inl8CKCndY
	RE5jdwihqQA8ZAGAMhRn9Sfk
X-Received: by 2002:a05:7022:3c12:b0:1a8:9857:2102 with SMTP id a92af1059eb24-1b25d3445demr7016509c88.30.1794070651262;
        Sat, 07 Nov 2026 08:57:31 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4b4aa7sm15456126c88.13.2026.11.07.08.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:57:30 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sat, 07 Nov 2026 11:57:03 -0500
Subject: [PATCH v3 4/4] selftests/mm: cover merging KSM pages aged by smart
 scan
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-4-16d5ce8b5fd6@gmail.com>
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9BEA120004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ti9oe489giigzbk99wf16qebmt38n9hy
X-HE-Tag: 1794070652-213784
X-HE-Meta: U2FsdGVkX18vSWyZxzlJMxa2uzYFK20NACOdfFzE6BUomgGva6L5l/aPxgWlCMeMkPdWGujmJq0o1y3MbgZcPENAjapZu6dduVkbxg9/9tCmaczoJ/0NdKMMJiYVXuQiX3w+tNZXaXjiOX8uivwWCPgblEbQAJwKT1sZ3lBExQAaTOJ3pZVyrtm9QORlQLLH3YDz475dVaInj93ZsXcivxbiKatodP1vr2kyK5uuvtU8tcXTfsQkzSGcRdtZlWP+xvEBmhZDgF91p0dM8YxK/QsXIA3BszxHlWtro7H93Ze4jV9Mm2qKnZDkZSkrvga9ko42+CMA48LzNb3V8OWQprXrRMigici/PhPZYsmeb7HHKxcBVXnz2oFjRT88KrMZidR90figEUddKKAClVzvFZYegT9kwgG09/VpGIcC/+7MKIzH47Gx1qGXQcH1/5b3fnapgweEdR5e8++H755g8N5CsIYj/Qih6RQ91F3Z70GXQaTmCIw6oYzctDMJlUC39PTakhxdG4spG8bH30TZ7k2G5VUGG5mNOCk+xZ2wep35rmLd8fSKzhGxwMwT/9kVSgZyvqdmPWPyyhMIg8M9atxnHlvvHkw0nKsnU5oo3tD0cccThLjv0XJycXCJsGJU3J6Nt7HhzWuh0IOghgUw06GXduIA/sD1A0Iyep0whhqiIKMuBOKBikIhw58Tu7I2dsidUFs7J7w8bcFWvG8w7ftADqppwi5yBIdDPZkxW7jhKf/m3Sa99vi6cpfEc5zSa31Z3KRYs3JPD6vteDDesgbYIiAkr/PKIE+dVpA7rpgVharKlmEI8iNgvoFmPLeDIIyrbNxk6Yc7MnaXjzndVeE6Kp/ifIY0UmzkMJA9kisCISasDcAPTDul76vToI+GFoopnFJkUXK0ePTfkJrFIeZOI9kxEzg25lKA/nSvujcKc+k+RFOnPvBGReVkzjBMc6DTVD0HEdoVICCx9Mi
 kladVd0h
 p9aG5Q0noV4yMqOYAEXyS0/MB/FpgkciHA7bYG2TLyHGnxZCMmy8G5Z49cLWiNnfdcsvGB4/5tVyJeKTuCaCR0U47qBeyWGMNCc8JW3Zv9uL0yyGgdboRMf3cqy9WhcE92z3RpbNG48cQVfSthv2VQ9snlyT2iRI5o10HG7FYl9dgrwkegx4yeobA7CiYzl66R3rDvVptWTswyJK7eaAjTrc4194Ux746Ya1R//gWBCrge2S6CBUxI/YimRtDw1MJ9IDzbNL1nSB4qVq+L28If9r3SdpIb4TZMKVMOpvFzJKUXe7RUKsU2Pr4Aoci4JqHCGsrz0JoCjoT2v9SE4tA8Q/KW5F3vv4BJDSEjZB59AG1E4ceQg1dGZTLBERnrr0fzh72zbasJRI0huVYP6Yn1yGhtBRVx6nEA9412GwU1yJAlQ42tKSajdFjlRTK94mm09WfjCIRae6tCbe6/SygUqiMnKF3QpM1ItDxc2x+/6p07cJvRmD9N/AQRffqI89O4T7lES0AzxghaoA=
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

Add ksm_get_smart_scan() and ksm_set_smart_scan() to vm_util, and a
case that enables smart scan, lets sixteen unique pages age for a dozen
scans, then makes a duplicate of each mergeable one scan apart, and
expects every pair to be merged 32 scans later:

  kernel               failures, two boots
  before the fix       20/20, 20/20
  with the fix          0/20,  0/20

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 89 ++++++++++++++++++++++-
 tools/testing/selftests/mm/vm_util.c              | 32 ++++++++
 tools/testing/selftests/mm/vm_util.h              |  2 +
 3 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 31c06c72203fd..135191f99962d 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -695,6 +695,92 @@ static void test_fork_ksm_merging_page_count(void)
 	munmap(map, size);
 }
 
+static void test_merge_aged_pairs(void)
+{
+	const unsigned int pairs = 16;
+	const unsigned long size = 2 * pairs * pagesize;
+	int old_smart_scan;
+	unsigned int i;
+	char *map;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	old_smart_scan = ksm_get_smart_scan();
+	if (old_smart_scan < 0) {
+		ksft_test_result_skip("smart_scan not supported\n");
+		return;
+	}
+	if (ksm_set_smart_scan(true) < 0) {
+		ksft_test_result_fail("Enabling smart_scan failed\n");
+		return;
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
+	if (ksm_set_smart_scan(old_smart_scan) < 0)
+		ksft_print_msg("Restoring smart_scan failed\n");
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -720,7 +806,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 9;
+	unsigned int tests = 10;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -753,6 +839,7 @@ int main(int argc, char **argv)
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
 	test_fork_ksm_merging_page_count();
+	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
 	if (err)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 1c2bac54696dd..490e3c7161e8d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -984,6 +984,38 @@ int ksm_use_zero_pages(void)
 	return ret == 1 ? 0 : -errno;
 }
 
+int ksm_get_smart_scan(void)
+{
+	int smart_scan_fd;
+	char buf;
+	ssize_t ret;
+
+	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_RDONLY);
+	if (smart_scan_fd < 0)
+		return -errno;
+
+	ret = pread(smart_scan_fd, &buf, 1, 0);
+	close(smart_scan_fd);
+	if (ret != 1)
+		return -errno;
+
+	return buf == '1';
+}
+
+int ksm_set_smart_scan(bool enable)
+{
+	int smart_scan_fd;
+	ssize_t ret;
+
+	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_WRONLY);
+	if (smart_scan_fd < 0)
+		return -errno;
+
+	ret = write(smart_scan_fd, enable ? "1" : "0", 1);
+	close(smart_scan_fd);
+	return ret == 1 ? 0 : -errno;
+}
+
 int ksm_wait_full_scans(long nr)
 {
 	long start_scans, end_scans;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 7e00030077d2f..ab1325dc65800 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -163,6 +163,8 @@ long ksm_get_self_zero_pages(void);
 long ksm_get_self_merging_pages(void);
 long ksm_get_full_scans(void);
 int ksm_wait_full_scans(long nr);
+int ksm_get_smart_scan(void);
+int ksm_set_smart_scan(bool enable);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
 int ksm_stop(void);

-- 
2.43.0


