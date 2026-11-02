Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D39606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SeoBF77x
Received: by kanga.kvack.org (Postfix)
	id 9B03D6B05B5; Mon,  2 Nov 2026 02:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9391E6B05B6; Mon,  2 Nov 2026 02:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D95F6B05B7; Mon,  2 Nov 2026 02:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 461C46B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:44:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E31EFC0C40
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:30 +0000 (UTC)
X-FDA: 85389391500.09.3ECF2D4
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2667640005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:44:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SeoBF77x;
	spf=pass (imf27.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793605469;
	b=NEwdaq+wvXPEQ/eNdGXGEkNCTtmhP06kB0HYV1WvKAVfe9+HvVh4q6YD9w9fOq3LK0PD2E
	HJ+aFhV0CU/IivmLN0/GhdXYs/WUQrS4ye1FBU3L4D/SBXP1mb1al5MzeqglTPV0NG31AI
	3MZ/pYuSvdjqcLD+jRVW+riJ3250lAM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SeoBF77x;
	spf=pass (imf27.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793605469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbEqoEmiOLpfQLZXaMwfuY090SS6ZvbC9oI0iDoMLRc=;
	b=fKtuRpN/fu1yo75WYsDVNTpBDEFjgvG2gPahXP5OkbKj7/KPa1DVP6/5nASwuJ8ZkZ5z3f
	S7cq6tmMmzZSI0jLXsVW14U0/dmxQRPecNcFlPI545oVkS6lZmzwdM348UU9L+z9F1ILVy
	2sTC781t9ufheqgfhFnhaEQ3Y33EunQ=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b042c0759so1287945f8f.2
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605468; x=1794210268; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tbEqoEmiOLpfQLZXaMwfuY090SS6ZvbC9oI0iDoMLRc=;
        b=SeoBF77xr0sR50jjSZJTUWj+8Bb07XYH8to3YekMqNc0XTiC9ExhuIjN72gHhjXF6o
         DBdRxTJkWaBvp3FYD5c/lK9QvgsbXCUlZbZ29HoopNsiTYgKv0sTAhfvmGBz8tNCa/HO
         DFLlljwpBUx3qYnUnVAv5clNyE6rX39HA2bQHH65vYlbCw7topiGSbVGUX4TN8E/H7hj
         RV1Ez16uvufO0CDZFcjvnJgF4CfjaYwQPP/F5eBQIhfamzZ/NlPBJV8v4z9urbEA/EGU
         l2W6oQR4l2X6Q+3rw8mZ8RhaKNQz7z4J1Ej24Zu8daEjolY/Agda/vdcqJe5Pmh5Jyzr
         ytYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605468; x=1794210268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tbEqoEmiOLpfQLZXaMwfuY090SS6ZvbC9oI0iDoMLRc=;
        b=rZxB0tBdgSPijD8RpWrlhnDhbnPMXZFhLeSMIjEeYM55LMvRqXmCvffm9xIyYUrEsM
         jvtMYPMam5slUfTJpwvg8xxbiVNRGPf2eboM25lpI2GLpBWfzlEgfdMFDBUdnEEtw2ib
         +t8AFA/vksMMfW7/twzav6sJajftkhb4T4faEBLUr9RBesO2owbCzeIfq2ff4ZTXemFH
         RNyjP0nLHOwe7mtRN8L0Ear/3pg6g/aiXEqmVCblLEZq6mzsnttYuGq3KVugiMde4P0M
         JN/xrPRQ1LnFVZFs0GArD8/hlEXQRuuErBof0qM2z8WEKbSAL5+jR5dX1RxlyXyZsN2j
         cLuA==
X-Forwarded-Encrypted: i=1; AKwUvBwMcJqnSg4LJbfH2DxITqfyt3VArsT3WhlEosaI3V9oKIZxBF8RkfngTd1tRjzivn5/Bh81zI0QQA==@kvack.org
X-Gm-Message-State: APuU4Z+to2s7uceh8qoknvWsORhTDnP4vgVhZO88+YFDuYEtIZgbhwQC
	Ftqwkc7hHlyGj9nOjAAWf5fHph6M6d8Tssxnx+959LD9y+BjFlAFrVxz
X-Gm-Gg: AYBFou3nvfiTkH7V3ZlA/e/Kr6EGbY8jXXGIn8MjO6Slj71/2piBdfCfLqlZ6TCTUZM
	MpcZh353MONYGCRY/wkXQ0QTdHuYQC17BWJ1hEc4B+EHDVXu/dXrd5nohOVQqN+d2uHpBfl/sW3
	6T397gsVJ2mbOipp8O7jum8Cu88rCmDwDEV06wIg90Oww5prOU+oW53YFr8QH3Z53Ht+7O6nVNo
	maFWXgr1yk6QuPL9FTGqsLb0SvdkPh9wrRTOW5HV+8tBvuroU5U1L+Q1zxrZo+GPE4tAOwl7U7X
	C/0/heEWUf/YX0aLQXus3uRvFdqDWCWqmwU13ixky2QdiYNh/LpiNibH5Y5B7r6JwzB6guXKT3t
	jP9VCYEJ9tAtNcOxWbPqTA2+wZzK+TLILgmgBuEJCNSYEv45fndaFNx5ymKdw9r7M6fc9IX4KjO
	B+llr2hrpp7yTTS8DqzYmdKCrTO7C8zyL/wYlT40Lgmb22P2cGGDHdze2FOqtrZkYV0WdleFfBt
	RLLsQXuar2GIwIFHYANtn3HkIpMNG5+NOAQzazund9ni/6VAhm2ZsXbHtYgFkFHyinYbFGw2WYU
	JrpHaUSk8YHyoOrmGTte9/962oxCmKT8Cw0=
X-Received: by 2002:a05:6000:144f:b0:48d:de0f:b79 with SMTP id ffacd0b85a97d-48e6e264067mr23884219f8f.0.1793605467644;
        Sun, 01 Nov 2026 23:44:27 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:27 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 3/3] selftests/mm: test mlock() and munlock() range normalisation
Date: Mon,  2 Nov 2026 08:44:01 +0100
Message-ID: <20261102074412.189554-4-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102074412.189554-1-azpijr@gmail.com>
References: <20261102074412.189554-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j8pkswduwaidk8e4az8tc6fhxgjkniyg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2667640005
X-Rspam-User: 
X-HE-Tag: 1793605469-449805
X-HE-Meta: U2FsdGVkX18tHgxBijMkFCLKT8erYmVGp7vmiPnbsTKCEDSX6VYdv4bflIJPWgKN6OL2fg9c5Yy8tO+QikOFKHU7xCJPSJxB3hcwHI7Gs/WAj9enDi1cRFxqadxi89OcJbL9Batm963BfvGsQF07990mgqMKthNIeHC7IP+OxjH5hcVOSnBDa7jSd60R5KZyVe2tE1OXhtkuqFoMcJy3ME8o6KGco+opf3P2cxe6Co4H63tU7MSQ1owqrE7acIf3x3lYcjP1aWlrAynJmeorUkmLlsxQ0kQoQMX2jFB8rn0AibOLmbSJlxIu2AEDy3uEhUVgNQ+0dxwcg63LPAU4dwsYIa643Rr2jFb7YCwu6Te++2IIszNp7JwkClkvf8CB9aborD1/hEy5EItGMEY6Se0U3g5CQAnQtib8e+q4V41TPluZEhY+gMpQZsIne+Mb+Bzi4GJsEsltN9VTyVpNU13LP45IC6eMLHVeAp3FByVIWX0GOjT6GuTOCinOFoHJ8X0X5NKUmOvbq3/kkAgUOVIdKs8Uq8nlmNANckS5Ho9ZARO9eXbZ1MSnQtt6iSxOaktLeSpnAvlB2aW/VeGQkU+3g5WekV17bZ/T3cyIhxwjLtTZB35XEuDDRmFm0S6bsXbZssc8Ac83tR7gtMyDOkGnjhYIwNB1ms8H4jKWr9tDapIGNQHtmtWqyynQ5Md8b5CN89nc2eVyr1ErcjXlYhSoZEV3QPEOVNpgifFPCf++LVn5V0V0Jftw02/15nCUKiWCRJLsTHvmAdjQd8UfTKn4J82EL8Mn2n1QWUMCxdieFUY01qLrxw9d4TErW+7rErBEKRK1Mpjg1eBKj0j8xx7iZbVmTyg2t/k909oeLmVdfqZXN/0XwysHmQNxbrCulefli3MViz+dvlp6oMWvbtGaF3qgAqwgykigcXAz77ecsUNmA3CxpNiCicTtr3VXvwTLs6D2mm1f9gISPo2
 eplPccbH
 RYHCO0R2+4Fp+82OrT68vmxvvOzE1vi3GArMkioVnkKzclISltD6fyZ0TDpF1GmOXQ26AcNOGaIUEJC162lNEXRpuANT6Z5/Tdkh23ZUTBhuiJj2+f6VNuOjI3ddl1MPu3nM+u3tIEWE9AYLigWa8LifZWbozjJGaGq0PronXiTHSVsKXaqxsrLh5Htosm4bWycCXmxI/InEHfpR9a8V5abLWAnvircGs6KVQDBw1nhMoi87Ps31YPaEuzCFiO0OQ0JoJrW9r9swYuRQEB2RLbBS0k+3v0WWfYkPq50p2Pln4yq6h5Mke5KdsALoNeY/Lp8FpuyusEw+TdadhfeSPBbP0mGQ+la82nViO0G52GBvAGJnFKpnuoKp7ff8sB+XDYuN8rzFFC0bAiQw94dicY3peyfrA3/Mw1NcqM9wiKRgGa48GhvfNtY1/8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add mlock2-tests cases for a zero length at aligned and unaligned
addresses, for a length that wraps when rounded to pages, and for an
overflowing start + len, checking the return value and VmLck.  The
overflow cases expect -EINVAL with and without CAP_IPC_LOCK, so running
the test unprivileged also covers the errno that used to depend on it.

The wrapping cases assume the test is built for the kernel's word size: a
32-bit binary on a 64-bit kernel cannot pass a range that wraps.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 tools/testing/selftests/mm/mlock2-tests.c | 191 +++++++++++++++++++++-
 1 file changed, 190 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index 144b550813a6..3dca349c4738 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -2,6 +2,7 @@
 #define _GNU_SOURCE
 #include <sys/mman.h>
 #include <linux/mman.h>
+#include <limits.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <string.h>
@@ -91,6 +92,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
 #define SIZE "Size:"
 #define RSS  "Rss:"
 #define LOCKED "lo"
+#define VMLCK "VmLck:"
 
 static unsigned long get_value_for_name(unsigned long addr, const char *name)
 {
@@ -177,6 +179,27 @@ static int unlock_lock_check(char *map, bool mlock_supported)
 	return 1;
 }
 
+static unsigned long get_vmlck(void)
+{
+	unsigned long vmlck;
+	char line[1024];
+	FILE *file;
+
+	file = fopen("/proc/self/status", "r");
+	if (!file)
+		ksft_exit_fail_msg("fopen: %s\n", strerror(errno));
+
+	while (fgets(line, sizeof(line), file)) {
+		if (sscanf(line, VMLCK "\t%lu kB", &vmlck) == 1) {
+			fclose(file);
+			return vmlck << 10;
+		}
+	}
+
+	fclose(file);
+	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status\n");
+}
+
 static void test_mlock_lock(void)
 {
 	char *map;
@@ -204,6 +227,167 @@ static void test_mlock_lock(void)
 	munmap(map, 2 * page_size);
 }
 
+static void test_mlock_zero_length(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(!mlock(map, 0),
+			 "%s: zero length mlock() at an aligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length mlock() at an aligned address locked nothing\n",
+			 __func__);
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(!mlock(map + 5, 0),
+			 "%s: zero length mlock() at an unaligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length mlock() at an unaligned address locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_munlock_zero_length(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	if (mlock(map, 2 * page_size)) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock(): %s\n", strerror(errno));
+	}
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(vmlck_before > 0,
+			 "%s: the range to release is accounted as locked\n",
+			 __func__);
+	ksft_test_result(!munlock(map + 5, 0),
+			 "%s: zero length munlock() at an unaligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length munlock() at an unaligned address released nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlock_length_wrap(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+	int ret;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map, ULONG_MAX);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: mlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: mlock() with a wrapping length locked nothing\n",
+			 __func__);
+
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map + 5, ULONG_MAX);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: unaligned mlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: unaligned mlock() with a wrapping length locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlock_addr_overflow(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	size_t len;
+	char *map;
+	int ret;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	/* addr + len wraps to 0 */
+	len = (size_t)(0UL - (unsigned long)map);
+
+	/* -EINVAL with or without CAP_IPC_LOCK */
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map, len);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: mlock() with an overflowing addr + len is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: mlock() with an overflowing addr + len locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_munlock_range_overflow(void)
+{
+	unsigned long page_size = getpagesize();
+	size_t len;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	errno = 0;
+	ksft_test_result(munlock(map, ULONG_MAX) == -1 && errno == EINVAL,
+			 "%s: munlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	errno = 0;
+	ksft_test_result(munlock(map + 5, ULONG_MAX) == -1 && errno == EINVAL,
+			 "%s: unaligned munlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	len = (size_t)(0UL - (unsigned long)map);
+	errno = 0;
+	ksft_test_result(munlock(map, len) == -1 && errno == EINVAL,
+			 "%s: munlock() with an overflowing addr + len is rejected\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
 static int onfault_check(char *map)
 {
 	*map = 'a';
@@ -506,9 +690,14 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(15);
+	ksft_set_plan(31);
 
 	test_mlock_lock();
+	test_mlock_zero_length();
+	test_munlock_zero_length();
+	test_mlock_length_wrap();
+	test_mlock_addr_overflow();
+	test_munlock_range_overflow();
 	test_mlock_onfault();
 	test_munlockall0();
 	test_munlockall1();
-- 
2.56.0


