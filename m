Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A695606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 22:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VxGGp3c6
Received: by kanga.kvack.org (Postfix)
	id A95796B05B6; Thu, 29 Oct 2026 18:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A016B05B5; Thu, 29 Oct 2026 18:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FD66B05B5; Thu, 29 Oct 2026 18:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4446B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:11:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCF131A0563
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:44 +0000 (UTC)
X-FDA: 85377061728.16.20D2F47
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id D98871C0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:11:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VxGGp3c6;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793311902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ItLu3zI4jj0VkRO3F8vNU1JfE+9qdeT+xzrqd6vWApU=;
	b=lv0lpdKuhjxD7OWEMVA9zLT3bA1g585zwKi5G9mWMFPiE3AEnvH/8y60CIJ3oX15iDMV35
	ER35FnCs8l/qSFGAqbLALR9BAJuF9PSlh6CCF1mnfm/fY6wZjKybTEfu7VspExbDi5Ot/k
	fKrom3ypDWchRhD2dVM+umzSS4wbDXI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VxGGp3c6;
	spf=pass (imf18.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793311902;
	b=vLsrR7uWslRGyMTLYwioo2MCvF7NQ+UpkCxj1w38+5nDjdN7p5BVEYuz0edbS3ufwRLLTS
	8hePfj+HhUePqSsEgeN1MqEhHafOkiGKaYk88v0eGhN42jd3J4/Gb5P+zixgmYJ6xRthRY
	/Yf0aHBp4hOBmEGZD/oQEuxJdyTPXkQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a208d93758so395675e9.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793311901; x=1793916701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ItLu3zI4jj0VkRO3F8vNU1JfE+9qdeT+xzrqd6vWApU=;
        b=VxGGp3c6U68aNFe2hAnLF3ToRFXIDtMMB0P5KLPmJCdP044SN14yRtDdsAES2UKlMj
         L+CynhCi/zWL71Yub6zkq+avBrgtfu6TtAX3yPjEhcr+1rd8i8lwCuBhSQcebYVx2Se6
         BYYqnVa84EhzgUm4SWYJ/7E2xh75MPRj5bFygxqLC0b+XkxEB/TYhVmJzAb/LR8xLYt7
         TPHa1SNUsfASZlAj5A1A1WivuhEWRZHDqk7bWoZrelQWT4O3s6gH05zwKEgo3BXAREF/
         ot4k/3rmv5gQ3b4j3Fn4IcEAligznCUY1qgbqQJVkRdIGH/At/1JHr7v1a/3YEwHksTI
         OA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793311901; x=1793916701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ItLu3zI4jj0VkRO3F8vNU1JfE+9qdeT+xzrqd6vWApU=;
        b=eHdrSbrfeKtjj08ghEnZ1TcanUkOs1l3ucvHE/1gRXiGz6cPT9o+VBzUuf5iD9xnvT
         vwLFLOh01tlP9xd2jIbr8qaV3DVaidZXboceQ1U9TJrsUiNMLyl/CmWqcd0ESFGbxUoM
         OZXuXSW47T2hEpo+jrMFrvUXejFpGADpHBS+mydv8IZ7vhYyl7zc2aFK56ZPMc6b3kp1
         jirGgG2Me2sl1LTzKs8GqaPuVFmELMK239/bO/c+QIgVE4bUuVS9zOGBqEqzp/txSfwQ
         9+XUVm0JN+Hj5wjhMZ3EhIb+Gl5Q1/2nPegqrJTKuLPbuR/sbAKn0dBl6C/PGL7Puz7J
         WP0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzvUiI766MULVeDOxY2FgfstMcaevCim/4DY16WWef3te2iZGuZKtni4sHyYP3RhgbyZvkJajp/Qg==@kvack.org
X-Gm-Message-State: AFq9FYJaDbmNIeRJfhz2libk4R/FWHcry1hBSl2Fs9hIPWs5I81+mK5J
	XHeaOH2oElZrez0LeEGGKlKqOcJMS/NAcojFeppw1dwdY3d2caL7lLHU
X-Gm-Gg: AYBFou2O9qS+nSKDYphoVwXo9qDHKuLqYSKfWToO2y4Jvg5PAiMQTANESUeV8DNExxN
	xgI7wkxGmr3CfjT14p/i2y0X29Q6p920AcG2avUt21sc4tKXBEsz/O0ABpsi6SyuMb/I94qKYCt
	tYVbDQwD9X06SdXGaVJmQUKAn3nqoJo0YHTfULW5/+Ka1Z0vcAFINVsCmcnh2QE1oiWSYnmMZXP
	awOU1TI4mF/fVt1jxHFcpaLYdpBM1Dw0Uskw5EIyqEBnia6S5oUC9IyJlZYmyr/XRNdKYlDg2tX
	xCr2+suG4VdBuH+3YKyCpt5VxwE8hfDSftr12QH2x4LZS9WmJnMK+SBOqhAFTlnko9XVima4DdP
	gtx86Sd2qG76jX9y2i9Pxil1rAYo/GNO/7sXVNJYcrb2EgERMjWRK/1IGdcYMK6YM30Wy4CwqQT
	EqISE9q8ThBzLhRTubShZYpxd7Gt4joL9fNptaIQU6C7KYoHXj+cnguvQ+o7tKuRG2vGKQTW+TZ
	dnAw23d+rAz70ih/lxVfUCYvCsSLlMalN/wgcBNM9ud+VNRCb8F1UQg38EqCf101HgVIzCbVzBP
	oDdD3qEszOdq2g==
X-Received: by 2002:a05:600c:468c:b0:4a3:59c9:a750 with SMTP id 5b1f17b1804b1-4ac17d168bcmr7131775e9.9.1793311901449;
        Thu, 29 Oct 2026 15:11:41 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896fesm104011305e9.10.2026.10.29.15.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 15:11:41 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 2/2] selftests/mm: add a uffd test for re-registering during UFFDIO_COPY
Date: Thu, 29 Oct 2026 23:11:02 +0100
Message-ID: <20261029221129.89068-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029221129.89068-1-azpijr@gmail.com>
References: <20261029221129.89068-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D98871C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dyguwzops4jedq8epc3qpp7oep7bzs5h
X-HE-Tag: 1793311902-712292
X-HE-Meta: U2FsdGVkX1/3ZTH4q52sXAxZraBHOcn2q+lvIHlOAh2Wm/pRM72p6MDqo/BvPd5wTGOD1ZUrvNOAJr89lfkTUnTIKIDrX2dW1RGEL38q0L+OLzn+qh/cp1UZB3vQQkc/vnczSje2z0QNh8cpFrjkkN3tUbrXdi/iHPqTdlj5637866/UlrfTEHiwI/5QOfCll5CJMIpaLfwshZOKj2bEwq4IGyTxj1AOCEprOADdFW47LBJlM1FWp49ETO2DQtyIwuOW49K2iozR0LDL+T/+rf6czhYfY9fQ9lS0YoatwYiEoYqIau4BVsdxEQvLgqADk7+PLSKjL4UgOKWRpQQimtMoQ/yywYFo0TaXoNgsv8gkuOkcTZzZT8bq3wKPqekoVsV0MdMFm+yvaMP9lofRyyHQZmP8m/Y88g8ZqESgJeLi9GU71OWKO5tgV9R1HIcyshvYdFFRM/XS/2deWcPpjZA+VWrgrzU0JyrbHWE5VQiAj246ZbEDwHaN7LjrT4fs+LO3j/Ll9pzruubeGZ6EkkdRJLzlwMoLOpwx86s+hkByI48ZCgFw2sbINgmJvHr8V9Cgwk/Hjb+EppfyKBEKRQmPzMonS/TFtSH183UV+4V+0DPBtL2ZqWxYk0C/CZ1bkdMazGzY2o2fDL7HOaHkMLgf26Kkjub9R8vulDzDxyHLr/vZanYU37/AvQdy/7xaI8vbq9fa2WQUYAYJvxUPM0etrOHf/EBH8Cg9d5KLXzeSnW2bzZKuM5QI9oRfa170u0Obn1q0i+Zw5jM885kODYhyVUfdmRNWspoGAxTOwV+MzSS6/JJH73tqVPGc/ibIGmfeQgANU+Na6Ev3HpES+86nGkoKQUsA1zU9qD7fisVmD8mCJmAESd7CvBNklFmKLUELf5XbGNImQApH9FqdOBqbzSGGL6fkfFMsLy4UY9Vy/BMGbKOVcvoOYo21VqsuDF4vU+kfJLJlyewZ7CC
 lo3ytWMu
 h/tRKfnZx6Zbm8Fq8KN5xuKl5RVrFIKfTNexNvmrTwusNfSXNEy60VBk/DFrKDsJmPrUyQujW1Ds8wXyI6u8LM5kqlurZlfI/UrsB4ne/N/lic08Q1wz6epM4WYrF7UllPNKHVkdS69mk1HWvfzm8TBhQauAIVVynBllqeMls2iVvWOlmr5+I6FNsmgDtYM38rgk9fjU+l1l1MlXxMAzEwcE83bZbb1rYkgw7ZCknme2/lYGom6/rkMV/OxNeyo6HlBglCnHpMFaPyqpFOAMxszT0iBknLO+alMtfo7afsn9rx97qtV7em5kj10d3o1A/U7WEhKdMve5v1njQacKFhf+sVMHm+JLH+E/WldY1EIU5ILESH41Mj0+j8Tab/fCldOluU9fUUtXF+hgwkHzrvSXc5437krwLKsJytLAiA3bTcm4dMLkKi6MNvaWVblyApOM2LBJep/lMPmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Re-register the destination without WP while a UFFDIO_COPY_MODE_WP copy
waits for its source page, then check that the copy fails with -EINVAL
and leaves no uffd-wp bit behind. This covers both the hugetlb and the
non-hugetlb UFFDIO_COPY retry.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb..8a7efaa7b3ac 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
 	uffd_test_pass();
 }
 
+struct wp_copy_args {
+	uffd_global_test_opts_t *gopts;
+	char *src;
+	__s64 copy;
+};
+
+static void *wp_copy_thread(void *data)
+{
+	struct wp_copy_args *args = data;
+	struct uffdio_copy copy = {
+		.dst = (unsigned long)args->gopts->area_dst,
+		.src = (unsigned long)args->src,
+		.len = args->gopts->page_size,
+		.mode = UFFDIO_COPY_MODE_WP,
+	};
+
+	ioctl(args->gopts->uffd, UFFDIO_COPY, &copy);
+	args->copy = copy.copy;
+
+	return NULL;
+}
+
+/*
+ * UFFDIO_COPY drops its locks to fault in the source page.  Re-register the
+ * destination without WP while it waits there: the MODE_WP copy must then
+ * fail instead of leaving a uffd-wp bit in a VMA that no longer has WP.
+ */
+static void uffd_wp_copy_reregister_test(uffd_global_test_opts_t *gopts,
+					 uffd_test_args_t *args)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct wp_copy_args copy_args = { .gopts = gopts };
+	unsigned long len = gopts->page_size;
+	struct uffdio_zeropage zeropage;
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t thread;
+	uint64_t value;
+	int pagemap_fd;
+	int src_uffd;
+
+	/* The source fault comes from the kernel, so no UFFD_USER_MODE_ONLY */
+	src_uffd = uffd_open(O_CLOEXEC);
+	if (src_uffd < 0) {
+		uffd_test_skip("cannot open a kernel-mode userfaultfd");
+		return;
+	}
+	if (ioctl(src_uffd, UFFDIO_API, &api))
+		err("UFFDIO_API failed");
+
+	copy_args.src = mmap(NULL, len, PROT_READ | PROT_WRITE,
+			     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (copy_args.src == MAP_FAILED)
+		err("mmap() failed");
+
+	if (uffd_register(src_uffd, copy_args.src, len, true, false, false))
+		err("register src failed");
+	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, true, false))
+		err("register dst failed");
+
+	if (pthread_create(&thread, NULL, wp_copy_thread, &copy_args))
+		err("pthread_create() failed");
+
+	/* Wait until UFFDIO_COPY blocks on the source page */
+	pfd = (struct pollfd){ .fd = src_uffd, .events = POLLIN };
+	if (poll(&pfd, 1, 10000) != 1)
+		err("no fault on the source page");
+	if (read(src_uffd, &msg, sizeof(msg)) != sizeof(msg))
+		err("read() failed");
+
+	if (uffd_unregister(gopts->uffd, gopts->area_dst, len))
+		err("unregister dst failed");
+	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, false, false))
+		err("re-register dst failed");
+
+	zeropage.range.start = (unsigned long)copy_args.src;
+	zeropage.range.len = len;
+	zeropage.mode = 0;
+	if (ioctl(src_uffd, UFFDIO_ZEROPAGE, &zeropage))
+		err("UFFDIO_ZEROPAGE failed");
+
+	if (pthread_join(thread, NULL))
+		err("pthread_join() failed");
+
+	if (copy_args.copy != -EINVAL)
+		err("UFFDIO_COPY returned %lld, expected %d",
+		    (long long)copy_args.copy, -EINVAL);
+
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, false);
+	close(pagemap_fd);
+
+	munmap(copy_args.src, len);
+	close(src_uffd);
+	uffd_test_pass();
+}
+
 static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_args_t *args,
 				     bool with_event)
 {
@@ -2403,6 +2501,13 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required =
 		UFFD_FEATURE_PAGEFAULT_FLAG_WP | UFFD_FEATURE_WP_UNPOPULATED,
 	},
+	{
+		.name = "wp-copy-reregister",
+		.uffd_fn = uffd_wp_copy_reregister_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
 	{
 		.name = "minor",
 		.uffd_fn = uffd_minor_test,
-- 
2.55.0


