Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD87CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB98A6B008C; Wed, 14 Oct 2026 15:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B116B0092; Wed, 14 Oct 2026 15:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959206B0095; Wed, 14 Oct 2026 15:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7498E6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:18:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0363B1607CD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:18:30 +0000 (UTC)
X-FDA: 85322193222.04.7C86FCD
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4BEF3120003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:18:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oRaNjq9H;
	spf=pass (imf29.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792005509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nTdH3X2l/etlrD2v+ho/jiApqNL7hD+sA31og7/oRbo=;
	b=0ZcGLvEgDaRVqzq9s7S365+rMG37gftoaHluwuC5WQvC2dmCm8e+/gVznzGgmwozolaV/s
	iim6eTguhMUZobAAsEy0BQ2k8YPYIOY/VQjGQ5abST0RBeo01Pt5SCT84bTCR9h2D0IfkX
	fLt8CaxQzU7PDLxZwrfMO1NQ836NeP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792005509;
	b=AzFGlh/TCDHgty1JkJyJp11HsyyotQLzX4ydq1QLD8CxqKxpO/5u2kMbSmH3DO9lBuYDe9
	eb8aKadK75YGdCvgKeXKgQjf8sWRFdidWmbUKfInCfPX/QE0NFIpQhNiDQ+gN/M40D1Xwi
	CITgB7SRK6fZLe2xBd+6nLFQw0LdG/0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oRaNjq9H;
	spf=pass (imf29.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48c4d870d54so2856052f8f.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792005508; x=1792610308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nTdH3X2l/etlrD2v+ho/jiApqNL7hD+sA31og7/oRbo=;
        b=oRaNjq9HoCZwTINpWg5e/J8NnbmUbIE+hEc/7L9TVohh6pSxtGWR0Gh4L0Aeh6efOs
         cUMYI24/N2rMnvr2rsu0t8XeCK8rqHDY+fTbIE4CkqOCQHOKBqQKfhrwUbmzFCnWaar3
         mBqT/+YEX997HL7gdfaGDPWsyu2OsWZc+K48Tu089DG0CbKsykqVm+gepk3R25t3CDjh
         QHn8U0ACAgt3plr/ehT9G5gj2Tb6NzMOURp1aAVFdMvFcVnN2GdsaCW7AK7fkQuG8qPd
         A91mJWMb8wasrumJEQxMw8c/uY+F74f9JkpdQr2XVimD0BhGUuUsAZE6Jk+wSi4BTyWT
         BmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792005508; x=1792610308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nTdH3X2l/etlrD2v+ho/jiApqNL7hD+sA31og7/oRbo=;
        b=GBqjrIgFQpZz1i6UZh60aR8O6oMQIemYq2391UDMI7Bx1zASxUfKSETHuDqVrI/iip
         TYU9b7dS2DSxfklRMQCyJFf9g/yURunaLZxsoG4f2t2aLq7U3BwYLJrFmxeDj4f1VpvU
         yK1eRR09flUo7IM+Stuji4A6e2wwNfRBoCOA7r4IJ7S7mnifwgiFdIGRn41DHfEaA21q
         t6C67ogrqEuO3/4Di62prLtLqiTwQ1lMnNZc3GcFJA3TJ0pfCojO4jI1qxvf+AeZOcIn
         4rkxSK/BxoHmliCgV1F5rukFtfpcnB9aW21gqOHX1P+upGESNHgaL/5DBaE7q+XuzwPT
         XI2w==
X-Gm-Message-State: AFq9FYKJB4eb83i9ypoDphqf8EDTKZsvGobYNJi+rGk9z5feaxlYjjG1
	hMj3lUT4a44yscThxzTcjhHsYRbCjmBH0OTJgDytSJnYa6UnZ3nGwGvm
X-Gm-Gg: AYBFou1dbURDos4iPUtmKfD4T5LOtJeAi3GANhTVv5mq1i2EoBrNoHWxuTdREeDRtKH
	SYj5Upv7i0A80pYsYQDxPuzbrAAibFVEKzWdvFLyifGjOMHC74ez79jVgNoj0b5QZuTYVHaVD/S
	lEwfVk7T0Y+Z4AF37VF8sHXAfRfDsMZsM8/GSrl56AtzWvOFcbeTuWI1+hWEBWauCgFtCPvQemW
	fzRM8h4cCKXvIxfGkO8NJ8AVi6g4Fm17LRRWEw5L7OM1QJOytHQIFvUrZ+d1jmFmIXAujwdVYHX
	NMS1ZLAQRVVkBZXhBijUCiASKMuIfV1tjp8fOUAdOCj9zK8VxFAX/zsPta9c7RK2Q1MKBnYKq26
	JyXPV+1Dj/j68bn5v6oIj0go+TIpHOi8YxjKIooL0avdnc7ISpihlXcDAFVAjQ5m1SyvZl+K6mE
	WvicwPgb07TDz2pLNwdYLINBgMjJvnjwf0ngLCB9UUr4WHTDrmj444y4hnsWbwxg==
X-Received: by 2002:a05:6000:2610:b0:48b:60a:760c with SMTP id ffacd0b85a97d-48dbacdbca4mr33861568f8f.31.1792005507598;
        Wed, 14 Oct 2026 12:18:27 -0700 (PDT)
Received: from fedora ([2a02:4540:a7:16c0:b518:4b00:679:375])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc6b82sm14114691f8f.51.2026.10.14.12.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 12:18:26 -0700 (PDT)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH] selftests/mm: test mremap DONTUNMAP with locked memory
Date: Wed, 14 Oct 2026 22:48:03 +0330
Message-ID: <20261014191803.196515-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4BEF3120003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sn7rfocbrfj53eatnomic4dps5mke8id
X-HE-Tag: 1792005509-257922
X-HE-Meta: U2FsdGVkX18f8RFfY0heknVEP9VopYIdmGJ5zqXhqnhO4387dl+rdZGXABFUu2qGGicGGbFaPXQEfMQ2SmozzTyY8LU2aOS59Jwz+usBV6E2PPGdoz1fGF6h8VxPDkdkFg4Ez15hKsUrZvopE/45FZhxXj5OCg4k5yF/qrAaG1pcqq3igZ3s+xTgJabHet5EljZQnYlvoAH2u2oUWfOc/u6wIwgA7OuX8yGjQAFiGURdsgppSh+yRHqfKzQFuKjB9mxHQZObyOa2FBqABWU+phPMsawj6Vub6fms2LhPaexMwcqA1GsrQQip3hwITr/cfstoF2yPtLWGLL5WZL6P0SZVgl7NVL17CWElAmRR6DMeqi5ZzzsFCgAoTpOkyHO//PUU4qV41FtTEDkSfQtFghduMkozU1AS6o9z8mJTmF+81uhBx9GVkryuK69bem3gqS7nRMEWNDzFd6JiK/CNjLT1eSTmrkrjMy/0INfXfbedWrHtCZd/XxJT7gUGhR0Rcf6cU7J4VMmUxLg/gWBRw0jigzWuKzf7MXZOZB8vl0ZqcMUjuBgXiV4laLaHh21k5ZMjhF4VSg06ZLd/6TG5OT+XJNXYDg0nhC3FlDwvuuDZgEL4xks/zH5dx2AQZKJ1/Av1ELFl+eD300KsrTweB1VRp5r9ou5TD+k4XuxRf2DQDrhTxL2MFOhwi135ITmap7ZOVAn4kX9845wZsWCy+bzh+YWJeAzYmpUQIoQo7lr2lsg0ipBibHwKcA9dSrhBi6ySjdYqsthn6Gnq+NCKmZRbgF6GAJnezOrn4oQu2aEKjj7ruMHuAiqgNqPdGO+H7YFVeI/0n/8AdRIpjdfXvgGVKMqeAfOdzR25kvxj8Ji/9JVL3w4NvGxlg1lefZUrH3WlMJd487zT9GpwjAhJxGhSE82bezdMUBClxFqJWu2fKs1ZgO0zwhnNOfDhK7sOBfjTdJ/jMUePZYro/ez
 C0r4WBDX
 PpwNCZEzOhTlfr/B9U1LG72NJc+FKSxn9YPE5aOdZX+Trzfzs7d7Fpln8fP5Gb4vqlr74aH1NGU0Ahu5DjKvEv/yPMXUVkAoPX7EpbZ5I1Eeia6WKVmIIJ0cFTrleCdY+Fk58PzFGD3W3k+P4tbdF8abrhqBJSVSeZPdLOvC2zagOtqjYCbreSYPSQxNfXwZTUwtQY2UqBxH074AGVcQs5BPimhv/yaDFXdfj9Q7aKbP871OniloiAN/zDgp8IgXIrc5dhhBO8YT20nwJmlaTy3yCw8L2xQOar+L7d4pInYJVimbR46xWbR96UPYl728c7S6HZtUGLS2mXOwt8IiQNTIlkWZMrXc1g9HHsJTTgRXNOIA7pkCbAw7qEdAdHtDIm//APyuabcV7B2ZH5FYzm/4baqsZYX00Ox7sNgQyOWLOlJWI+SSJARkGECSGcQci4IqFiKzRMQWWGjbBytYo6MPvLea6aEO/hP/mzAJefTlUWPQwqlzJNayHgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check that a partial MREMAP_DONTUNMAP operation on mlocked memory
preserves locked-memory accounting and that unmapping both mappings
returns VmLck to its original value.

This tests for a locked_vm accounting leak after a partial remap.

Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 tools/testing/selftests/mm/mremap_dontunmap.c | 95 ++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_dontunmap.c b/tools/testing/selftests/mm/mremap_dontunmap.c
index 96ba537facf..a0fd99ff825 100644
--- a/tools/testing/selftests/mm/mremap_dontunmap.c
+++ b/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -335,6 +335,98 @@ static void mremap_dontunmap_partial_mapping_overwrite(void)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
+static long get_vmlck_kb(void)
+{
+	FILE *f = fopen("/proc/self/status", "r");
+	char *line = NULL;
+	size_t len = 0;
+	long kb = -1;
+
+	if (!f)
+		ksft_exit_fail_msg("fopen /proc/self/status: %s\n",
+				   strerror(errno));
+
+	while (getline(&line, &len, f) != -1) {
+		if (sscanf(line, "VmLck: %ld kB", &kb) == 1)
+			break;
+	}
+
+	free(line);
+	fclose(f);
+
+	if (kb < 0)
+		ksft_exit_fail_msg("VmLck not found in /proc/self/status\n");
+
+	return kb;
+}
+
+static void mremap_dontunmap_partial_mlocked(void)
+{
+	unsigned long num_pages = 10;
+	size_t size = num_pages * page_size;
+	size_t half = (num_pages / 2) * page_size;
+	void *src, *dst;
+	long baseline, locked, remapped, after;
+	bool pass;
+
+	baseline = get_vmlck_kb();
+
+	src = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (src == MAP_FAILED)
+		ksft_exit_fail_msg("mmap source: %s\n", strerror(errno));
+
+	dst = mmap(NULL, half, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (dst == MAP_FAILED)
+		ksft_exit_fail_msg("mmap destination: %s\n", strerror(errno));
+
+	memset(src, 'a', size);
+
+	if (mlock(src, size)) {
+		if (errno == EPERM || errno == ENOMEM) {
+			ksft_print_msg("mlock unavailable: %s\n",
+				       strerror(errno));
+
+			if (munmap(dst, half))
+				ksft_exit_fail_msg("munmap destination: %s\n",
+						   strerror(errno));
+			if (munmap(src, size))
+				ksft_exit_fail_msg("munmap source: %s\n",
+						   strerror(errno));
+
+			ksft_test_result_skip("%s\n", __func__);
+			return;
+		}
+		ksft_exit_fail_msg("mlock: %s\n", strerror(errno));
+	}
+
+	locked = get_vmlck_kb();
+
+	if (mremap(src + half, half, half,
+		   MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_DONTUNMAP,
+		   dst) == MAP_FAILED)
+		ksft_exit_fail_msg("mremap: %s\n", strerror(errno));
+
+	remapped = get_vmlck_kb();
+
+	if (munmap(dst, half))
+		ksft_exit_fail_msg("munmap destination: %s\n",
+				   strerror(errno));
+	if (munmap(src, size))
+		ksft_exit_fail_msg("munmap source: %s\n", strerror(errno));
+
+	after = get_vmlck_kb();
+
+	pass = locked == baseline + (long)(size / 1024) &&
+	       remapped == locked &&
+	       after == baseline;
+
+	ksft_test_result(pass,
+			 "%s (baseline=%ld kB, locked=%ld kB, remapped=%ld kB, after=%ld kB)\n",
+			 __func__, baseline, locked, remapped, after);
+}
+
 int main(void)
 {
 	ksft_print_header();
@@ -348,7 +440,7 @@ int main(void)
 		ksft_finished();
 	}
 
-	ksft_set_plan(5);
+	ksft_set_plan(6);
 
 	// Keep a page sized buffer around for when we need it.
 	page_buffer =
@@ -361,6 +453,7 @@ int main(void)
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
 	mremap_dontunmap_partial_mapping_overwrite();
+	mremap_dontunmap_partial_mlocked();
 
 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");
-- 
2.55.0


