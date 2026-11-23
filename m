Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E33606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OysjsEEQ
Received: by kanga.kvack.org (Postfix)
	id 6ADDB6B05C5; Mon, 23 Nov 2026 18:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685E66B05C6; Mon, 23 Nov 2026 18:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E006B05C7; Mon, 23 Nov 2026 18:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 133536B05C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4904780A34
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:55 +0000 (UTC)
X-FDA: 85468003950.23.A079E97
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F00E1C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OysjsEEQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3yM4EawgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3yM4EawgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477193;
	b=QLq0iBLFiaua7AjrHgicRoJ7CcVnWEwFK3googQZHxWsQeuNSItl4DE1EALOTzBv5sx0Bl
	y4Tboi7uAzeoAYYa9rAqtizJP2z4O99L3G8kB04cBh3bibilAPFyW4yRSfLsSac6tsC5Ua
	eTC+cgSbw/NXdp+jbB2LSMymgBFGeQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKJ0YhG5KuD0pKI8GbolHfK4XjQIGbL51iUEGtZcrrg=;
	b=pOlIqdGQgc9UT1A42jgfnbPHzR6Y5HTIOrE6wOjRwusjfQxRCF9ttDGB/uALLxXrz/Kllf
	PT2dZ4K+1CYS19veYs9loEmgNTz/xEM5oit3xwQvbKbB8W3pCy9jIhmd2jyGyQoMSNZ0Kv
	+YYxHeA3VF/jXvqAfYvQFTA4n/FJ/Go=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OysjsEEQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3yM4EawgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3yM4EawgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-57289376805so3952802b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477193; x=1796081993; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iKJ0YhG5KuD0pKI8GbolHfK4XjQIGbL51iUEGtZcrrg=;
        b=OysjsEEQXslyjsWtvehMmpDHKddmo9pzleDPKhRk8e/v8VfDHKQXHSB3hkXuOI4Bmh
         O9lwt8w2AFAHWC/WxbMBvXCJjP3U/cp2+Vz11pV8r0FJ4NzvBJNYf6wgHsgZQRKocJiJ
         p9sNywrYWL0pWzfW4Ismr9BkZMK5+LmKGQnB3MEmOGMVbGkA6do0LpxVTDGYPZxW+H1r
         QiZmGqRFngIHHB3zjgOlIjBfv4+fUX8wJgy3TJd25ey9LPb8iZGqo1tOMd4mZAfEVlvL
         qrNg/Io0aNM6CooFb5+91uTtUQfRpY4nDxNeFH2MdY8uyRDZyuI1ogdtHL6jp5Tp8I53
         7NaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477193; x=1796081993;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iKJ0YhG5KuD0pKI8GbolHfK4XjQIGbL51iUEGtZcrrg=;
        b=tE3+SpL0fabnP3t89Npz/wh8q/wButXSJ5ODMwCj3aQW5XEPA4NUsof3xc++xx6ZjW
         bq2hrFGGoh4Y5gF5BUZg1ZQ4L5a+45pH+9jx+/7buEiXwr2ww/xGMqSbCR+Ot2hexAhz
         ipovo+xSQi+ObF40k72Y06SLTC2W2jMkqhhpWr+yLOseymsTpr2ix4Gg9ViFnYJ4beVq
         ThGGZqwkK9FDpL2ACzVCK2lZDzvWQwmgshCb3GTQWYoykr+eq2QQPo12qdrUZYSnWzkw
         1+41ddcGwEkLTR4FWA/xLAa0MTOQZFF1q5+X9I2XxOuBUcHX6rtGA+m56yJbcxIpxBw/
         WxhA==
X-Forwarded-Encrypted: i=1; AL+hErE5lVBz6T91Hh+jIpd+eXlso35Pr9/QhyqS8gc1bv/YWIxaaGXH1PZhAYFw/ZYcOrPWe4SgL2L11g==@kvack.org
X-Gm-Message-State: APuU4Z/2jCjKIbnIRte/LooO/ie0/xypFm09dOOgG+Kn3uZlKHADHg2i
	AbucKO40FA+5QgLat1TCxItasBhxQooGkQhwUrNQJqqT1u6ciOEvizSJA6nPiKs1BualGMuGF9a
	xA2VkSjV/nI82/A==
X-Received: from ilei3-n2.prod.google.com ([2002:a05:6e02:61c3:20b0:53c:e043:6f2d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:50a1:b0:55b:f8cc:aef1 with SMTP id 5614622812f47-57a0a930345mr13528096b6e.15.1795477192273;
 Mon, 23 Nov 2026 15:39:52 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:22 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-18-dmatlack@google.com>
Subject: [PATCH v5 17/18] selftests/liveupdate: Test retrieving tmpfs files
 preserved read-only
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: ymjpsqqzhogykmph3gkbpfqmyxaop8sx
X-Rspamd-Queue-Id: 8F00E1C0004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795477193-844260
X-HE-Meta: U2FsdGVkX1/lOh8pagu/UKbF86CYfdrU5rVg5t19XYkqS3XOoNpvlHYoU/+IRV9ItJNfp4zXwi66fA3+sxYsE07pl1kUolMczPTpXmnYFs/w0JoZq25lH0LU9C0QN4kBH4LAsix8m7bgDKqOqAc6pHrsIumf2mSFGnfSVhd3AY4C0dFD45duJ9mAKm4VpBhRi8pIUzNXZHWLs5uenM93+iAcBCXpGqnBAMK0AGW9c6QLMj0rdXIdCan3YkYTKSIYI6H0niq+w/efsl4WuicEZVXwSNyjIuM8hPca/5GfKJ9Sg8CXAa+MOULAv6ga5BPivLDeDRoOH0r9JVYH+cl/Rl2KT3krr9EG7ui2uCyqBe+/dMKOGD+aJSwyaZQlXcd+YeKfj+sFr1kX8OeOa2nCR9X5b90WWmV+aAmYOB7Ea/aXeCoAJu56FsdAoCQZCqAoPqbI3eBb6ZotWVTkxkRsHumzyskalP6Q/stg0F65IdqBTFL3ejPuVGsOnFgTXZl8F9pPrS2CsywPaK3Etv9CdPM/XCH82Mmx7JUtuDGogwe7V926rSgcpYy4nvvdyir4eWumU7IgQDCzuWQjv6TUQycs7fRqfg93lQhJ9q7iIBR7wj+klb/XhGczzTMrZq2xL+a6bvPi+C1MU1LuvDtc4rDjSIIOo6/JAAehtmYSg/uODTvQ4z0S1JUuBHPdIjPleLQXuHix6Q4iO3SOPDUA7NCX7RFd7lf7u5rAM2Dn5qupv+eQ3k7EZuaDEUKfaNVYg5u1gLUIT075DT2xtRSCEqUL40tybO/w2DzQOw/5SXt6uD2y1nGZWBP/L5uQajcdl9K6fiKGQ7Y1t/4qA998n9AJRfF3o0oiFYxPUMU+dX+p54QJw0MWyaPjF/dHfiegUvORcenodFO0vaBdGaPspVjUTtsKh0oZLfw/hbjDRar7oxD3ylGMYJ/QVMmfsdJ4hcill+poiFtix/IjeLP
 AWlPSklc
 hWRYLsfge+U2y+N48PzcupTNPwKwuhMOs4jYen9UL8P8IXEA2uFpQCSEql4jdXXJ/2iv+kY8v+//sNPXiEgI7x2Nw+KZ5fwBDrNPtocYSMn546z6lOwa9jLj0QTGyh04bg1uw9adU0Kq2JSkvEfuSLBrA6ry39J40iD/RtaK4HKJxN2D3dTpubvQeVcqTHmQ7lWBOP5ojJs9kkeWRUg3RB6m2PC0G/MYIxajSSy1cgAZvN/1Iu2JlupsA+n1YugA83ARTxn5qatQWCEatd8JNfI9DP+naiRzKbO4Rr9lpRuDa9DNH+oXr32JlbR5LZ5WcKbZOJkAIjCQHxLKNoKyv/Sb8R17l+H32ImzRacOQuH0UKBlOEp/7xcvNs9YoJvSPKVrS+HBrqkL01Fs3eshgOs4olJZdFvygqw1JunXqgWnno+UxRxcSAJzmdDyuCFcpQ4zlfNMN9xuv4qEEPLrfwKE1qU5jO5pclGS7qxZkxup8BMNG9l4FO5bZaeWZVvsJenddPKM75gL1PVJIFf7RpyEfkAoQSyvO30GYXqDXzB5s2H7z2GFAOIhsn7T2hXNM5TVNAk9ELsPUScoKKHeSusmih/z/Yg9om/30BM6d2zZfjaEQPi2+1B01zFISnj7k8jl6hE9oM+YEr9zAc8iq5S1OyDZ8ihmWyr2fKCN66IWXEcsY1glThFhg0qa1vWIqezFVtZH15RkuZgUdFcfW2qfhPhbNFVA7hMlR3FtErdzyXbK9XAwybu+goMJeWFpeJhfloIzLoQoO9XystiJRBlBJmVRPTNn/Z5WS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add test cases to luo_tmpfs for source files preserved through a
read-only fd, through a read-only mount, on a read-only superblock, and
immutable files. Each of these cases except the first also preserves a
sparse file, whose holes are filled when it is preserved. Check that
the files are retrieved with their contents. Also check that the size of
a preserved file is frozen, even when the file is opened by its path,
and that writes within the file are preserved.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 305 ++++++++++++++++++
 1 file changed, 305 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
index 27ec750351da..7911ac28188f 100644
--- a/tools/testing/selftests/liveupdate/luo_tmpfs.c
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -462,6 +462,13 @@ static int preserve_memfd(struct test_case *tc, unsigned int flags,
 	return ret;
 }
 
+/* Skip a case whose source file couldn't be preserved in stage 1. */
+static int skip_not_preserved(struct test_case *tc)
+{
+	ksft_print_msg("%s: The source file was not preserved\n", tc->name);
+	return KSFT_SKIP;
+}
+
 static int drop_privileges(void)
 {
 	CHECK_EQ(syscall(__NR_setgroups, 0, NULL), 0);
@@ -838,6 +845,175 @@ static int linked_target_verify(struct test_case *tc)
 	return KSFT_PASS;
 }
 
+static int rdonly_source_preserve(struct test_case *tc)
+{
+	int fd, ret;
+
+	fd = create_source("src/rdonly_source", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	fd = open("src/rdonly_source", O_RDONLY);
+	CHECK(fd >= 0);
+	ret = preserve_fd(fd, tc->pos, tc->token);
+	close(fd);
+
+	return ret;
+}
+
+/* Create a sparse file at @path, with a hole after the first page. */
+static int create_sparse_source(const char *path, __u64 token)
+{
+	int fd;
+
+	fd = create_source(path, page_size, token);
+	if (fd < 0)
+		return -1;
+
+	if (ftruncate(fd, 2 * page_size)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+/* Open @path with O_RDONLY and try to preserve it with @token. */
+static int try_preserve_path(const char *path, __u64 token)
+{
+	int fd, ret;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = luo_session_preserve_fd(session_fd, fd, token);
+	close(fd);
+	return ret;
+}
+
+/* Check that the file preserved with @token has the source of @tc. */
+static int check_preserved(struct test_case *tc, __u64 token, size_t size)
+{
+	int fd;
+
+	fd = retrieve_new(token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), size);
+	TRY(check_contents(fd, size, tc->token));
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+/* Check that the file preserved with @token is a create_sparse_source(). */
+static int check_sparse_preserved(struct test_case *tc, __u64 token)
+{
+	unsigned char *p;
+	int fd;
+
+	fd = retrieve_new(token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), 2 * page_size);
+
+	/* Preserving the file filled the hole. */
+	CHECK_EQ(file_pages(fd), 2);
+	p = mmap(NULL, 2 * page_size, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+	TRY(check_range(p, 0, page_size, tc->token));
+	TRY(check_range(p, page_size, 2 * page_size, 0));
+
+	munmap(p, 2 * page_size);
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int rdonly_mount_source_preserve(struct test_case *tc)
+{
+	int fd;
+
+	fd = create_source("src/rdonly_mount_source", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_sparse_source("src/rdonly_mount_sparse", tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	CHECK_EQ(mkdir("src_ro", 0755), 0);
+	CHECK_EQ(do_mount("src", "src_ro", NULL, MS_BIND, NULL), 0);
+	CHECK_EQ(do_mount("none", "src_ro", NULL,
+			  MS_REMOUNT | MS_BIND | MS_RDONLY, NULL), 0);
+
+	/*
+	 * Files can be preserved through a read-only mount. Their holes are
+	 * filled as if by read faults, which work through read-only mounts too.
+	 */
+	CHECK_EQ(try_preserve_path("src_ro/rdonly_mount_source", tc->token), 0);
+	CHECK_EQ(try_preserve_path("src_ro/rdonly_mount_sparse", tc->token + 1),
+		 0);
+	return KSFT_PASS;
+}
+
+static int rdonly_mount_source_verify(struct test_case *tc)
+{
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	TRY(check_preserved(tc, tc->token, tc->size));
+	TRY(check_sparse_preserved(tc, tc->token + 1));
+	return KSFT_PASS;
+}
+
+static int rdonly_sb_source_child(struct test_case *tc)
+{
+	TRY(drop_privileges());
+
+	/* The owner can preserve a file whose size can't change anyway... */
+	CHECK_EQ(try_preserve_path("src_rosb/own", tc->token + 1), 0);
+
+	/* ... but nobody else can. */
+	CHECK(try_preserve_path("src_rosb/other", tc->token + 2) < 0);
+	return KSFT_PASS;
+}
+
+static int rdonly_sb_source_preserve(struct test_case *tc)
+{
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("src_rosb", 16, NULL), 0);
+	fd = create_source("src_rosb/root", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_source("src_rosb/own", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	CHECK_EQ(chown("src_rosb/own", NOBODY, NOBODY), 0);
+	fd = create_source("src_rosb/other", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_sparse_source("src_rosb/sparse", tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	CHECK_EQ(do_mount(NULL, "src_rosb", NULL, MS_REMOUNT | MS_RDONLY, NULL),
+		 0);
+
+	CHECK_EQ(try_preserve_path("src_rosb/root", tc->token), 0);
+	TRY(run_child(rdonly_sb_source_child, tc));
+
+	/* Holes are filled as if by read faults, even on a read-only sb. */
+	CHECK_EQ(try_preserve_path("src_rosb/sparse", tc->token + 3), 0);
+	return KSFT_PASS;
+}
+
+static int rdonly_sb_source_verify(struct test_case *tc)
+{
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	TRY(check_preserved(tc, tc->token, tc->size));
+	TRY(check_preserved(tc, tc->token + 1, tc->size));
+	CHECK_EQ(luo_session_retrieve_fd(session_fd, tc->token + 2), -ENOENT);
+	TRY(check_sparse_preserved(tc, tc->token + 3));
+	return KSFT_PASS;
+}
+
 /* Set the inode flag @flag, e.g. FS_IMMUTABLE_FL, on the file at @path. */
 static int set_inode_flag(const char *path, int flag)
 {
@@ -859,6 +1035,104 @@ static int set_inode_flag(const char *path, int flag)
 	return ret;
 }
 
+static int immutable_source_preserve(struct test_case *tc)
+{
+	int fd, ret;
+
+	fd = create_source("src/immutable_source", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_sparse_source("src/immutable_sparse", tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	ret = set_inode_flag("src/immutable_source", FS_IMMUTABLE_FL);
+	if (ret == -ENOTTY || ret == -EOPNOTSUPP) {
+		ksft_print_msg("%s: FS_IOC_SETFLAGS is not supported\n",
+			       tc->name);
+		return KSFT_SKIP;
+	}
+	CHECK_EQ(ret, 0);
+	CHECK_EQ(set_inode_flag("src/immutable_sparse", FS_IMMUTABLE_FL), 0);
+
+	/*
+	 * The size of an immutable file can't change anyway, so its owner can
+	 * preserve it. Its holes are filled as if by read faults.
+	 */
+	CHECK_EQ(try_preserve_path("src/immutable_source", tc->token), 0);
+	CHECK_EQ(try_preserve_path("src/immutable_sparse", tc->token + 1), 0);
+	return KSFT_PASS;
+}
+
+static int immutable_source_verify(struct test_case *tc)
+{
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	if (fd == -ENOENT)
+		return skip_not_preserved(tc);
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), tc->size);
+	TRY(check_contents(fd, tc->size, tc->token));
+	close(fd);
+
+	TRY(check_sparse_preserved(tc, tc->token + 1));
+	return KSFT_PASS;
+}
+
+#define FROZEN_OFFSET		100
+#define FROZEN_DATA		"frozen"
+
+static int frozen_source_preserve(struct test_case *tc)
+{
+	size_t len = strlen(FROZEN_DATA);
+	int fd;
+
+	TRY(preserve_file(tc));
+
+	/* The size of a preserved file can't change, even through its path. */
+	fd = open("src/frozen_source", O_RDWR);
+	CHECK(fd >= 0);
+	CHECK_ERRNO(ftruncate(fd, tc->size / 2), EPERM);
+	CHECK_ERRNO(ftruncate(fd, tc->size * 2), EPERM);
+	CHECK_ERRNO(do_fallocate(fd, 0, 0, tc->size * 2), EPERM);
+	CHECK_ERRNO(do_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				 0, page_size), EPERM);
+	CHECK_EQ(lseek(fd, tc->size, SEEK_SET), tc->size);
+	CHECK_ERRNO(write(fd, "x", 1), EPERM);
+	CHECK_EQ(file_size(fd), tc->size);
+
+	/* Writes within the file work, and the data is preserved. */
+	CHECK_EQ(lseek(fd, FROZEN_OFFSET, SEEK_SET), FROZEN_OFFSET);
+	CHECK_EQ(write(fd, FROZEN_DATA, len), len);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int frozen_source_verify(struct test_case *tc)
+{
+	size_t len = strlen(FROZEN_DATA);
+	unsigned char *p;
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), tc->size);
+
+	p = mmap(NULL, tc->size, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+	TRY(check_range(p, 0, FROZEN_OFFSET, tc->token));
+	CHECK(!memcmp(p + FROZEN_OFFSET, FROZEN_DATA, len));
+	TRY(check_range(p, FROZEN_OFFSET + len, tc->size, tc->token));
+
+	munmap(p, tc->size);
+	close(fd);
+	return KSFT_PASS;
+}
+
 static int target_rdonly_verify(struct test_case *tc)
 {
 	int target, rd_fd;
@@ -1319,6 +1593,37 @@ static struct test_case test_cases[] = {
 		.size = SMALL_SIZE,
 		.verify = linked_target_verify,
 	},
+	/* Preserving files. */
+	{
+		.name = "rdonly_source",
+		.size = SMALL_SIZE,
+		.preserve = rdonly_source_preserve,
+		.verify = restore_verify,
+	},
+	{
+		.name = "rdonly_mount_source",
+		.size = SMALL_SIZE,
+		.preserve = rdonly_mount_source_preserve,
+		.verify = rdonly_mount_source_verify,
+	},
+	{
+		.name = "rdonly_sb_source",
+		.size = SMALL_SIZE,
+		.preserve = rdonly_sb_source_preserve,
+		.verify = rdonly_sb_source_verify,
+	},
+	{
+		.name = "immutable_source",
+		.size = SMALL_SIZE,
+		.preserve = immutable_source_preserve,
+		.verify = immutable_source_verify,
+	},
+	{
+		.name = "frozen_source",
+		.size = SMALL_SIZE,
+		.preserve = frozen_source_preserve,
+		.verify = frozen_source_verify,
+	},
 	/* The target file. */
 	{
 		.name = "target_rdonly",
-- 
2.56.1.809.ga0b61035b5-goog


