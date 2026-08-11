Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19AC5C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4006B0096; Tue, 11 Aug 2026 11:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165396B009F; Tue, 11 Aug 2026 11:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02CD76B00A0; Tue, 11 Aug 2026 11:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1E0B6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:27:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 694351C1122
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:45 +0000 (UTC)
X-FDA: 85089368490.19.0185B33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB21240008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/6/bnLe";
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vem2xsFlpo0+sWC3l/kxNB7POgGE6gpeRa35NgLYw6I=;
	b=i2/EWy+HuJDcJadxY1RxGYnLfAthpYNeNfVDgUo/gYgHUavB/UKyCQn9N24+Qjvn8VrfdV
	+yWSU4ozq0rvW03G3xf3tFMx2pIejqSM4UeU6jrFOUBTBXmceOumCZRjYgZR+TT90KRgBQ
	s8Pk9mlmRGoQ7m0CZZCAV2EcowtG464=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462063;
	b=BcLFqxk6sVzdvaq9YAQ6N6rSB4PbPBinLEJMgfddOwQvYunQP/s/K3BlDaJLCoUiASg85Z
	50IeB+ToObBZx7t6icEgfh22sfH2RT/5NKqt3m6x1TjHy2ys7nLCFs5wToywGkeFBGn81j
	NZYkvZVriuzvMmnSTiTwKXUbEOa21HE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/6/bnLe";
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44DEA600E2;
	Tue, 11 Aug 2026 15:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FCF1F00A3A;
	Tue, 11 Aug 2026 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462063;
	bh=vem2xsFlpo0+sWC3l/kxNB7POgGE6gpeRa35NgLYw6I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a/6/bnLeoX9AstuTEYVT9BGZD2qYKRDb97wunLXwXts7QaNjyUzcB5AHy5sjmE40S
	 6opyHuFyx3LhMRWACbJ/XkJtuqANTlhEjlPNcZEkSi8vDJkvRDME+UPn7SdBi78rjc
	 DD52380Eoh9d2MJJaC+QBRqfQYJn3+96s0nVG/H2LObZXr+1vTOiDGvlq3UmEvbI0G
	 BmDptAGWxSW6a/7tnZ10RCk+iblQlTDJSkY1oJnWgkijjuMuE1/0y/1Rcay6oNxL5J
	 KwP08f4hpXhgWT1dknZL72SB1kMKA7ex6IcgtCc9q4MhWD+eaKAN8BzxL162v46ymx
	 icMeoJuuFGO8g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:23 +0200
Subject: [PATCH 02/11] selftests/coredump: collapse the expected request
 check into the helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-2-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=8194; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/WE7FwKgQXlwVzHyeztNVUhNPPEXhv6nrZrHM54peHw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2ydwMay6tdplnk7BlGnv9XXXbezfymfu0n9sQf7/T
 5bLM8Med5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk6UyGvxJ8D2052yc/nq9e
 bnvk9TyetNBdKy40vrB7fpxDQmVzriMjQ9+Dk0d2d3q2LvTZylSuo+C89iHLr+4F+dlCT23N64O
 MGQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB21240008
X-Stat-Signature: bupfx65gk91dt4e88sof5uaiq3bcbx6k
X-HE-Tag: 1786462063-709920
X-HE-Meta: U2FsdGVkX1+5+sbP3k6gtadaS5I7ZKjh2g7f0is84mb2JH5HWbfiIwfoEvttbh3RZA5MdClB/SUIS/bswqoFx48zwLFGwmrWHTPmk72ubhW86rIn1VZdeGHMfBVTzhopxnSOPXtnjsQO/C5MNOLks1YYnw1ktLqBuZiZKPbrA4Do66EYE8EsqPNpNqrttZ8Xfh3GJJqtIuTNQ2gy1xm7wnKgOWQCP5LZYhrUtmx27+qNFtPWT6kKZkgxQcxEPyifDe2aDJxx2X9Io9VMQjCnQaFe3c76O8uNBzN7Fk8Va0zT506UpPcCQK/8DbPuEniAo9nYCvZ++C1ITwZdZrsTtBgGTvKW+Z8nmZVRgpK/zmYXMnCaTr68stZITd362Tlpa0G+dqaE3D0e9jxcg93jKl5SIRBQNwOgd5k2VKOMZigYKRq1dz0YK1G44M4RV5Lyj68sYZowJDlOgSPgHghZB8xWCErWPC4uBACAxcfiROfw6jQR/pQEeJiLA3G/3QAn93lR4hq4boFjUZLEsixxeE3ifMd4XiWaA01JT3ibDPGs5Ixya+OxB9HYVe6F9GBai874YS21A0bXGw64Aa8eBxiLp4Tc1XLvy0WB/ik+Tlr4WVPszUMW7UJroYdSN/hoj+Vh85NqtmxqAVF7wy/D2f5OOw08R33Jkbg3YIXwuHDAYGiWCXm1oDyfpdSNI8PUYBbtaF6j4o5Z5GpwibVAevHA2ruvS7a7cG5Kd3px1glE+VjzGQpLT58xFK9fFTX3UUrj4HsOaagncfRnnLk7VYsaIz9rxVfahQhPfhayPt5QttA1+WOahvLZQfyIJix4SXznrmLbDxOSv1HISFoOReARc4fUjtED/66UBDAMT3Zxr5kt14m+o/EoZvA+LfZZ8SmtuWwvbMAO9epL0RcrvXg84myBVuDosofll0woVHZB3HBFijBGaE5zfyOIzBK6zlDUQznyXRmqz0styri
 2qIC8DAF
 ary+/06o7kREIYYRqvOKiSBQwNXSsmggty+A0/iFVZZwnpPQ2cO3fDMIZt83B2XUUdT52KYJjW4B7TEZgeXP/Z5rkzJuzt067zj/tsmihPA26hbPfTUtaXNKDLhRkzSaaJDfjOWAQwGH0BS8uEPER3icjQrn9jungB6Xg2qRN4iqmgLXK8oiljw3rTZMqe+a1nwN9ogijheIgg2H9YTat5z/u4oSDBXV5h7mzN1YyRk4BtfBrPWIFRc2V5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All nine callers spell the expected flags. So every new feature bit the
kernel learns has to be cargo culted.

The callers also all pass COREDUMP_ACK_SIZE_VER0 as the minimum request
size although what is being validated is coredump_req->size. And
read_coredump_req() makes the same mixup twice more.

Clean this all up.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 36 ++++++----------------
 tools/testing/selftests/coredump/coredump_test.h   |  3 +-
 .../selftests/coredump/coredump_test_helpers.c     | 35 +++++++++++++--------
 3 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index d9fa6239b5a9..60a357e628eb 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -151,9 +151,7 @@ TEST_F(coredump, socket_request_kernel)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_kernel: check_coredump_req failed\n");
 			goto out;
 		}
@@ -301,9 +299,7 @@ TEST_F(coredump, socket_request_userspace)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_userspace: check_coredump_req failed\n");
 			goto out;
 		}
@@ -441,9 +437,7 @@ TEST_F(coredump, socket_request_reject)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_reject: check_coredump_req failed\n");
 			goto out;
 		}
@@ -581,9 +575,7 @@ TEST_F(coredump, socket_request_invalid_flag_combination)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_invalid_flag_combination: check_coredump_req failed\n");
 			goto out;
 		}
@@ -702,9 +694,7 @@ TEST_F(coredump, socket_request_unknown_flag)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_unknown_flag: check_coredump_req failed\n");
 			goto out;
 		}
@@ -822,9 +812,7 @@ TEST_F(coredump, socket_request_invalid_size_small)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_invalid_size_small: check_coredump_req failed\n");
 			goto out;
 		}
@@ -944,9 +932,7 @@ TEST_F(coredump, socket_request_invalid_size_large)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_invalid_size_large: check_coredump_req failed\n");
 			goto out;
 		}
@@ -1355,9 +1341,7 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps, 500)
 				goto out;
 			}
 
-			if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-						COREDUMP_KERNEL | COREDUMP_USERSPACE |
-						COREDUMP_REJECT | COREDUMP_WAIT)) {
+			if (!check_coredump_req(&req)) {
 				fprintf(stderr, "check_coredump_req failed for fd %d\n", fd_coredump);
 				goto out;
 			}
@@ -1509,9 +1493,7 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps_epoll_workers, 500)
 				fprintf(stderr, "socket_multiple_crashing_coredumps_epoll_workers: read_coredump_req failed\n");
 				goto out;
 			}
-			if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-						COREDUMP_KERNEL | COREDUMP_USERSPACE |
-						COREDUMP_REJECT | COREDUMP_WAIT)) {
+			if (!check_coredump_req(&req)) {
 				fprintf(stderr, "socket_multiple_crashing_coredumps_epoll_workers: check_coredump_req failed\n");
 				goto out;
 			}
diff --git a/tools/testing/selftests/coredump/coredump_test.h b/tools/testing/selftests/coredump/coredump_test.h
index ed47f01fa53c..a02809145e2d 100644
--- a/tools/testing/selftests/coredump/coredump_test.h
+++ b/tools/testing/selftests/coredump/coredump_test.h
@@ -51,8 +51,7 @@ bool read_marker(int fd, enum coredump_mark mark);
 bool read_coredump_req(int fd, struct coredump_req *req);
 bool send_coredump_ack(int fd, const struct coredump_req *req,
 		       __u64 mask, size_t size_ack);
-bool check_coredump_req(const struct coredump_req *req, size_t min_size,
-			__u64 required_mask);
+bool check_coredump_req(const struct coredump_req *req);
 int open_coredump_tmpfile(int fd_tmpfs_detached);
 void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_file);
 
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 524fa5370593..d32d96436779 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -200,7 +200,7 @@ bool read_marker(int fd, enum coredump_mark mark)
 bool read_coredump_req(int fd, struct coredump_req *req)
 {
 	ssize_t ret;
-	size_t field_size, user_size, ack_size, kernel_size, remaining_size;
+	size_t field_size, user_size, known, kernel_size, remaining_size;
 
 	memset(req, 0, sizeof(*req));
 	field_size = sizeof(req->size);
@@ -214,9 +214,9 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	}
 	kernel_size = req->size;
 
-	if (kernel_size < COREDUMP_ACK_SIZE_VER0) {
+	if (kernel_size < COREDUMP_REQ_SIZE_VER0) {
 		fprintf(stderr, "read_coredump_req: kernel_size %zu < min %d\n",
-			kernel_size, COREDUMP_ACK_SIZE_VER0);
+			kernel_size, COREDUMP_REQ_SIZE_VER0);
 		return false;
 	}
 	if (kernel_size >= PAGE_SIZE) {
@@ -225,11 +225,11 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 		return false;
 	}
 
-	/* Use the minimum of user and kernel size to read the full request. */
+	/* Consume as much of the request as we know about. */
 	user_size = sizeof(struct coredump_req);
-	ack_size = user_size < kernel_size ? user_size : kernel_size;
-	ret = recv(fd, req, ack_size, MSG_WAITALL);
-	if (ret != ack_size)
+	known = user_size < kernel_size ? user_size : kernel_size;
+	ret = recv(fd, req, known, MSG_WAITALL);
+	if (ret != known)
 		return false;
 
 	fprintf(stderr, "Read coredump request with size %u and mask 0x%llx\n",
@@ -287,15 +287,24 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 	return true;
 }
 
-bool check_coredump_req(const struct coredump_req *req, size_t min_size,
-			__u64 required_mask)
+/* Every option the kernel is expected to advertise in coredump_req->mask. */
+#define COREDUMP_REQ_MASK_ALL					\
+	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
+	 COREDUMP_REJECT | COREDUMP_WAIT)
+
+bool check_coredump_req(const struct coredump_req *req)
 {
-	if (req->size < min_size)
-		return false;
-	if ((req->mask & required_mask) != required_mask)
+	if (req->size < COREDUMP_REQ_SIZE_VER0) {
+		fprintf(stderr, "%s: size %u below minimum %d\n",
+			__func__, req->size, COREDUMP_REQ_SIZE_VER0);
 		return false;
-	if (req->mask & ~required_mask)
+	}
+	if (req->mask != COREDUMP_REQ_MASK_ALL) {
+		fprintf(stderr, "%s: mask 0x%llx, expected 0x%llx\n",
+			__func__, (unsigned long long)req->mask,
+			(unsigned long long)COREDUMP_REQ_MASK_ALL);
 		return false;
+	}
 	return true;
 }
 

-- 
2.53.0


