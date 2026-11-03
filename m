Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA50D6075BE5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BcJ9bV3p
Received: by kanga.kvack.org (Postfix)
	id 301116B05B5; Tue,  3 Nov 2026 05:28:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E18C6B05C0; Tue,  3 Nov 2026 05:28:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDA06B05B5; Tue,  3 Nov 2026 05:28:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7A156B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:28:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 634781C2A4A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:28:56 +0000 (UTC)
X-FDA: 85393434672.24.F8E727D
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9603710000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:28:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BcJ9bV3p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFvHrJ226gOIeLudLE6azLHSFzqJ0Fej3gicSvLOC2I=;
	b=Sk0KTt0SDvkxk6LtQoAaPY+e7NIMS3IZ9e8Nyz92nTOu2rESLejhEcBJeOgWyqr8UP0Dyu
	ZN7UxDoUe2T5KlVom9kVGTCBE4w2R7yTY68Vpzi/88gkKFcTzn8lpNcbOaRavMMeyHMzzV
	hLHqbBVQEQJkm1PpiWQEV8xTlGPlCnk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BcJ9bV3p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701734;
	b=6YUosN+FAWXB8XfqoxNMf6mLItx2AYVwY5KmiTCOSNiWRwZvaovzw6iHiANW9Chi+fZ5wp
	XfQuVJzU2is6mWH2zzgCyPcpVqT5z/RM2nKecYxA9ITnQ2Mh8p1UAzdGUXGCrt9dA8c6d3
	q0NY58k6TSam4wJ7VqWx7NmTK8IdTTo=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48dfb76b304so380603f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701733; x=1794306533; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yFvHrJ226gOIeLudLE6azLHSFzqJ0Fej3gicSvLOC2I=;
        b=BcJ9bV3pGAz1yrCmkczdian/hBOhY6r3PerRRzvFrlbJgUnir0QVyqz9gYNaElRLpr
         oex/+5+QhTcMpNETisLYLxY5Aw0n8HTORNEnjgE6a9433WPEb5VBydk2KO8kQRXvBwzZ
         zeYsdvKBm86wVDWE+Mh8fnNNuMfiBSFu1Ub6Ztk4TWIvKcwLBcOqnC77AqjKmlJWVpZm
         eh2wTtq1xUUN6wwEAwo3CFDrFpRkC6BmdCDZOZqhHzA9nI8ShSYg9N5ZdpwpX3Svxlcj
         8zIsQ+8W+pr/e9+Bo+GNIqc9d1YEQqBwJseCshGL6fZ7DGNya3OCcEUx/H/wTkd7Ogpr
         CrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701733; x=1794306533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yFvHrJ226gOIeLudLE6azLHSFzqJ0Fej3gicSvLOC2I=;
        b=vKunebP8+sv9fPmVt90GKZjSXX6y80EwYFleOaFDSvQO7nwAKcMaNJGdvO6bD7pDfo
         8DngMGXEogUw6BppfeQaVdwDVTjZj2Mcf6a5kzOnnUOWsEQ9it9hlZTmuZVtGjvcFKv3
         GO6HpyQ0mAuZQ4SMYBzqnTwktWqJPsFh7fjNpwAFV7MsxFWum5OCRU4kE4mLNpYK6iZb
         bXAU20SK5tJH8wcvBJs9etviHb4dJcsYNh/OL9qDqrkvxm2T5lgO+Y6quQzxkLOYWETy
         44m/09gaRDfZuL5oCti1PaMMtlK0VgDIu565TX0qIHcN9sPFyGUfpfIyFG0prbidWmty
         oifw==
X-Forwarded-Encrypted: i=1; AKwUvByY5BXLB+P/cSjI1quPzfCPPyTM6jptnoShDj+kO12LI/CIU2LQfRD7s2nO2fxtHMrCtb+5+SmlmA==@kvack.org
X-Gm-Message-State: APuU4Z/C0VMU8+wWUA/wQ48TeQXEpLgMk3b6PaHmA95jVXQ8RUfIYTuX
	ED+n3lIQtBFwvMi4Q241I5qBSvA1AwW0/6DCqRDVzksUgbR87ZNbq9l1
X-Gm-Gg: AYBFou06W2wSlKF7GToS7YR+Hl1jjtKYBg0xZ829QzXqKqdWRa5alWl8WpEuYsm87Nl
	D4r5P5p2ZoEkiVrpruk0s8HQS6Z/0oKho/GzROyw0tHXErUFE7cJbxN9OJbVQSq7ZncMVBFaTtT
	lGz46Y6EmhPzqQijPyWhJ4Yq9loq3aD4McrZXkRJk+ECenrc+G3jzDX1u/vcVq5Ipkqu5tmBluY
	xfTsQUA7yQsL74WTp67d82K0LxGw6yMhX3BpKa1IUwwoa4VKhsZ8Y2MSbegO7yF5DpiWeSXyno/
	zMSt6BE5apoBLxvwTWfFmQKqKEDDNL8rKhpOkXpVBW9w1JzXjvEpkztSNENgc1JE0RX9Z3U6Mhd
	RW/ZDNNETNLw+lBY77r2WOS+aRP5ANxltc6vPldZpmKx/AcQlF/Kr+bI9BaJJ88uSmex21BKfg2
	nejYEP0df2rM6/vtEdsE8ZGZtexb6oF9u6emAnVjV4kGyQyZerT8RhQaUyZCrUACFUbzN46PAcW
	o+wnZoif78vJFtDhOB93TIY/Z2Tjjdrq7fke/4+0irLfd62kOOXT52lwXgJs184EfiTMJo7/FdG
	Ox/uTdOqr6FMsg==
X-Received: by 2002:a5d:5f89:0:b0:48a:f0cd:8712 with SMTP id ffacd0b85a97d-48e6e5004c1mr26768734f8f.50.1793701733040;
        Tue, 03 Nov 2026 02:28:53 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b7815fsm24941003f8f.22.2026.11.03.02.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:28:52 -0800 (PST)
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
Subject: [PATCH v3 2/2] selftests/mm: add a uffd test for re-registering during UFFDIO_COPY
Date: Tue,  3 Nov 2026 11:28:36 +0100
Message-ID: <20261103102840.68903-3-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103102840.68903-1-azpijr@gmail.com>
References: <20261103102840.68903-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9603710000C
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: faikmhgf9rh85ios94pk3s36tgu8d1bd
X-HE-Tag: 1793701734-323965
X-HE-Meta: U2FsdGVkX19u5aP6oEIN0LYZs6zXvw0Hdu2p7dRrVgKH85p7vf1cDxrFUJbKoscUvUV787Ku5aGcqciWAhqSA+jbwZ7fP6V7amkgqbEk3Q66b9XpYyguQsDyuTDrLi6pVhjZ2jkuMjVW0Ouo816dE8u2qkJq23UV8uqYLK9AH3lK9goimVlslXav5H/mlqksjbzU9tKSFFTGDxAX6mpkBvxHprtTk8TCw5PqQ1xnjjBSOaNAslebG3bzgP0hhhoAR+k+GrkKQ01swPW/K6gRijQYrgYpEMdZkz58alh3Q4h7PEcRV+fVZJqvX7OWjO27bdx2Q5wxyLdWd1sqEc93HorwZpoAsqfFd9oMV9QJFRoTGuuQbidHxTiBwB9GL9ONQCoZgfs/UtLr97IBxEZ5woy73LG8BOiOhyRj+1ZAknVRsNGaB8QhNDbYPDjVRI1+dL+RmPTpbzNWh1041gv+/3aGNT+JcMXuUSKkwmtYweJI6BEyANFqHo5QHrcTKwnQKfopArMZ8P145W5EseLluqIM8nNgnVBwZiY/+sAQRcfVDYIqo2ofPCV6V5U4mDOoMpvPfx4rVIfMaHiSgEJmKkZsI+HXnf0SVGVB5Ggqe2FVDeLrk7NFWWfYB0BILhrdypHDKvsahxcXYplR/sNefCkRHIvpcAR3+/EVAI58O7K+fPM1/gnBFGhAQzPUv9Gc6SJCFWwzjFW6xisbX98+XUDekEG2enjf35XNtGuoek0LwERUnulojGvDL8dE4jgnrpvpMvwIGFZ/wFiCmP3Mm0uT0ez3MZ8b4jg8K2i1JqKJXtJL+IahlquxtjNanspB4qaTUWd3XgpXWeHtB+7SRSqdApCzUMO2yoN4gTrfUgKBLRBEAmkFpsS/b7fLv9msT8/g2cMb/pdQXeHEgLvI9BGQOvSMysmaQtMrcf8VUo9++BE+B2KPrNojl+MlhF6S2cVU60Gptd7KNgR4+EW
 d8bxvztN
 Jt2izL42OqGxrcLAZMkiS0zWi9tGyrnoz2Hky59tnPMsEhpLv26bGwCyUuABeZBj3UReLBQLCxiQqw8EJkJgh+RdvkSeibY3T2JxNef8X3bUbZDoI6lV2AE1tQeRhK09iWQ4Han4RurNEM0LzH+7gdJ/1XbLCMLzRaOq0XpVHoOaasVo3ASlmC9nwhzux1AjU549+J9VVetQPSLni8wHMcFswMVqBvNahXHw77suJuLI4uwcEzYF06KfgJVh69tp+SbcFbe6jjclUKXHMWdQwjXOh7/aY3j8BGzknV9lpOCLpyyF9lDATFGQRQt4Q+LAgmrRm9OCXUtgnUTbJMzQIunDUdQS/ycnTRBYC3FY7WnbeWiEVOiOu5Hr6SaXtRCIQXYXMIVajXaEh0S/pmqNcrGt3keBdFVnG5JlikPSp6hcnHIH8a/QDgN5ji2F0gILh3pj69Uk6NzV68WcUqNZ7WG0jfAQeWR/B0WV6UNu7JsDnFyc=
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v3:
- open the source userfaultfd with O_NONBLOCK and check for POLLIN, so
  poll() waits for the fault instead of returning POLLERR at once
  (reported by sashiko [1])
- add Mike's Reviewed-by

Changes in v2:
- "all memory types" in the commit message
- rename copy to result

[1] https://lore.kernel.org/sashiko-outbox-194303@kernel.org

v2: https://lore.kernel.org/20261102081140.201987-3-azpijr@gmail.com
v1: https://lore.kernel.org/20261029221129.89068-3-azpijr@gmail.com

 tools/testing/selftests/mm/uffd-unit-tests.c | 105 +++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 298609544445..e811ca49bb83 100644
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
+	src_uffd = uffd_open(UFFD_FLAGS & ~UFFD_USER_MODE_ONLY);
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
+	if (poll(&pfd, 1, 10000) != 1 || !(pfd.revents & POLLIN))
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


