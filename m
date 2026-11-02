Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E63606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mb0y4r0n
Received: by kanga.kvack.org (Postfix)
	id F0C986B05B6; Mon,  2 Nov 2026 03:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48136B05B7; Mon,  2 Nov 2026 03:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72976B05B8; Mon,  2 Nov 2026 03:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 847F26B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:11:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EEF140C92
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:11:54 +0000 (UTC)
X-FDA: 85389460548.09.02ED8C3
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id C3B8040005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:11:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Mb0y4r0n;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793607112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Skgy5VZxk2gILLHcPLrF17iQzssiYgUtpst1TmBVQUQ=;
	b=cYnPyBfvhV6JYDRt/OaKCC0LqLPpCThd4L9mwYtK6n/Qa6wuCkmcSEOQSpnIJU8Bd5QKjM
	/mT9swIObHJ7a3Ql0BTT7ORyb+4bZ2UA6rwWIEJ+eHDziDu4y3uy8Qy/QxWlpvudHJnYNy
	hr/IR5M96hGmnW29EPGwnIFiEFAgdnA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Mb0y4r0n;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793607112;
	b=aevxgcVyBWJyANSa9mhmGXh43R8ZZgwVX935Rq+cYW/5YWgK3b6qj4goPv4IF/pFbBrWG6
	JANaMhrtTvDIaqAmSfn5kC7LR+XP9jVxjnmE+MxOx/GbGyJ+uQgFqYc4T26aBBK4MGCWgp
	L2JleSUCNw4auYlI/42wgJuCjx2K/Y8=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so28305465e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793607111; x=1794211911; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Skgy5VZxk2gILLHcPLrF17iQzssiYgUtpst1TmBVQUQ=;
        b=Mb0y4r0nV93Z0vurJriK676T+VQj7jCWpC5DcY7RJfm65RSu39LybzcZlEDerUKbHl
         8ScGN3uNIZ8P7RaZrxs46uJtsxs3wTsSnNEipsWx3d4xve0hFrUoXqTYfONKDIYCrKe4
         AtxkyV53/op3WM3IC5IVV+KHtrmTL5UAM/sH9+29gBPIGpmPRficBDmYNYzUcss2s99O
         vlcsQwnHQVccshnmXAZgxDv1RfLb8rcfkmH2cdz19Zol5wXJhRm7cfE6RjpI73Yh1Hk1
         AaYnadS0cNAatMQOr6MVOJnWAJJacUi7G7uAQo7czLLa4Ya3dBgEOTXiKnAUVDxVoC5o
         YRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793607111; x=1794211911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Skgy5VZxk2gILLHcPLrF17iQzssiYgUtpst1TmBVQUQ=;
        b=DjsYSx2ga+09/TUqL7evK+H5+M51yCY8kBzjNBeP+IIC4qT2ilaxtEIvR3mYh1aK4g
         Y9wm837XEhiED6DNbBjYfrfPEf/DXJdczanM7w6Xu8XnIS6zfYDO/CSNEkG5xSiAVYyB
         b1AjRfVDCj/DKxulaH20c/olCPfJ/VVPgwdSEiK8hGllkZuz/5u+Km8yI5IxRlqLOgJC
         Ph7RGFEooGeHM1/BzmMmXqOnNtZHGl7ECRm4K8kcNjF2vUbBNeunLM0JacgnMgBIIt/A
         +TRCW6MdLhsttCq7AlDWlInTAyA8/BF54FCmEsIOr8VSoy7P2/JThSfUIUFT7qjXh9VY
         NzkQ==
X-Forwarded-Encrypted: i=1; AKwUvByWY4m6ZGW172tyghh3F2ZPN+5RvvaF6V4rMGaROSeEdsDcV3pXYqa6WD7/gnwwhls+altOdkKbjQ==@kvack.org
X-Gm-Message-State: AFq9FYL6asd9OFmp9Iof2eYI9XblxrzRDYHvDnJ8tIkWqERVJnaf4tjf
	F1s+nFpGMSXVskhmawjDmkgjRwchGyqYNLqoXYvCqUBo3Yx97UpwsBqN
X-Gm-Gg: AYBFou1fh8uPAoKQv2Tq1Xa6+H4p8SPtil+d9kDgIlTay/+jO8vuLTOKfqJjjrxtqPS
	RoBPnWejGVQpvNLCz2Rf6ak9OdXLX4YMD+Q21MPZ644Tw6tZKaYVZDH4SA+vcc1yAr+W60UADDZ
	50nVYXTMPWjae7cc2SynKkEO/uBHhEa7dUc6Gxvx1v0lCckUSGIZdnnExrH7Sej9PLJ0MaME+1O
	pstApbqgvGBi97I6zDojM/33x0UjLVLYpt6YJkanuUI7OUmAKTtLI5XVbOwE042xxeL5gGqq3t9
	GyOc0VS6WsMouQ2+JqK7RVbJg0S0ltLBZo7faqlkyJaZMyZqMqPLk40uIdEIlPNXLvUcZwr5rLQ
	HchssCgvUyJ14QK8oG15Xm48cLzGBaGOk3QGQzrT+XwoWnS8AJ/JCh7AyrWCXGux1L/uQ7g3hcy
	JTujMNInNImMX4hMna6xvGotqUMWNXKEWoyF18PmFAhbFtEK6hIpmPzlfkymNbK5L6YUK8zGs4a
	cjIURDrOjEVMxIk09onW9BrfXQNn1lmLteXCaJja+X2wVEzZP8++CKJ/0dvVoecdsuxrJPSz3AF
	HM4xSv2wVgnE2g==
X-Received: by 2002:a05:600c:46d1:b0:4a1:df52:3e36 with SMTP id 5b1f17b1804b1-4ac17b2cdc2mr215325315e9.27.1793607111269;
        Mon, 02 Nov 2026 00:11:51 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa8213ead6sm333331005e9.14.2026.11.02.00.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 00:11:50 -0800 (PST)
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
Subject: [PATCH v2 2/2] selftests/mm: add a uffd test for re-registering during UFFDIO_COPY
Date: Mon,  2 Nov 2026 09:11:31 +0100
Message-ID: <20261102081140.201987-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102081140.201987-1-azpijr@gmail.com>
References: <20261102081140.201987-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3B8040005
X-Stat-Signature: dgqcecuyzuosarfnf7mcfaxrsok3ndn8
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793607112-469742
X-HE-Meta: U2FsdGVkX1/qNld5PUNr+Tu+QnV+J8SDbPBGdHqL4QVefnz5tQiFhKRWNBLUu1a4i6KBOoaUN/9is7KZfj/maN3rNSIMIvxFxVnALPjwpjw6xoLLTLih5hT4tkxuycrO5gJWWNOAr1yUsPuHFcLdSAQ60m4zUXmyeV/K9rupbQ4E2lfrXkkYuahZkASr+AdyZm7DhUqXIDVhHlw+WkmEAsKajY9MXMiyVwe1xp6OteR5obHJDuTnIIKZgd27cyGAMUxdF6A0EZVriTmJ4olUhglazAgPO6oI+nyDk/obh8FauGxMqViue3WHwwA5HgCrZsf5iPIbpCu/hRAnVFvQlHAu0dHodjGKDrxWjKQ58xzECcf85h6edo463rNqvcv4VELW+BcW53COfUDVDwrU7JX/oSgJMNbXmLQ8qQ+scvPesiAnevgtwPDOcstCdZ2/qVHIx9KazNATuhDcun12pRvWE8QlAD05IfeKP+rvS5zfUXbjut+7n3FNFW0JMg27GiyBpoR+tkmrzC33QFvXDZ2iScBKgqOeaDM1hVolNzf1cLUG41kvXoQ/4zQGwY6f1Jckgd/IuXJRK8ZeIGONqCW1Dpmk1mYT39hf20M4qZTK4OAyVHMXC9W7wfuVrYXonU+I1znzTzOYkOREvz/89Kvjd5LLlE6irw95P6HBHMccIicLS++AGQD2VkKWXBA6rGEYvSVRqg2l1Jikx0q1JhQZ17HMTp2VTl9JIMG/X8r7VaUZ0WXYP2da/aZdTGXjcfWGgnn2EN6oj0xTmCZSkqtpCAoNUurbJfXUAAvLsUN57K+qXOfGSVOaV5g+g1HaD3rhhOszKokTVG3vytb8g3ulVlnjwQZybtWgIK5eey1BWRRc9H+8pE9WheHV+4/vPoQOw/GWu0nOnFElRU67ZIvUWKPt63EiOVijqeBSIfNBk/GUZ0P0C4yJdUVHnJeCx1/QOqQnI3adu9UaYjH
 v8SQHZKN
 fJjeNdBm7wBzoDQmzeJMI4Z5mzdBJiPwlNRu3q0HRMisBSNZONXfFVSpLz1Q8Dy/KikQsmrrxflh9GhWAT6FjoxxYd2/dy+ewqQCs/BXkr+/j77Awlg2egS94R/KNcWxmRx6SFV0jN8yf/nnueXOBcDjWiF8bX72cQQJoP1g5cJZg3J3ABcAuMjcNrzs9UyW5L5A7kk6sMiDPnd7QwTYfwfpjQRZ/gsHp2XU8RLIs1ITpVhXACXAyaoaOQMKJzd6X8QOcRuYur1QmaLrfUDz+9Y28AeW3aMHaO6He4hBErGgo4wgBN6tALnMeKVFhtsl6ZPf4gTN0HaFTfjYc+UuR8kjN29qC92/AMhgbWWqJPG/l134/FGDVP0Ik0hFHnzoi6UDMx8b3cz8gFCuof+1csmMk33Y+4Zg3IHqJref7pKRKdI+ZfNr7CxCJ0UW4MUlHvjDH9/cFI3NJhfi3ugGJpgkV0J3TsuW4lPgOBzAv78mtib0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Re-register the destination without WP while a UFFDIO_COPY_MODE_WP copy
waits for its source page, then check that the copy fails with -EINVAL
and leaves no uffd-wp bit behind. This covers all memory types.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- "all memory types" in the commit message
- rename copy to result

v1: https://lore.kernel.org/20261029221129.89068-3-azpijr@gmail.com

 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb..cc22b4cde621 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
 	uffd_test_pass();
 }
 
+struct wp_copy_args {
+	uffd_global_test_opts_t *gopts;
+	char *src;
+	__s64 result;
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
+	args->result = copy.copy;
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
+	if (copy_args.result != -EINVAL)
+		err("UFFDIO_COPY returned %lld, expected %d",
+		    (long long)copy_args.result, -EINVAL);
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
2.56.0


