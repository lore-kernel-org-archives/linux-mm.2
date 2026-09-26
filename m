Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC84C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F20F6B009D; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDA86B00A5; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D416B00A4; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3BD6B00A6
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3A20A07C5
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.25.8D075AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3B95A0006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T4ZJIXko;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=rDhv8DHNNnzsRYk9qqcMK1GZNEec9rwsVopb0FEeE4vKr9jLxdolCCT9s90YwWgRVBg5H0
	Kw7grTUkRK2V9ADdb73IzTSSCeaiJ/MhQlvfIetUn9puwRdTeJ81tIwEHlZFEErayxbrfX
	Xdum2OWL2PMDCIvyZy2xGr+iZCpJLNk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T4ZJIXko;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyHNmyRsDPMJpONLdxvG5mhCyZOfEfBkS7qIfef2f7U=;
	b=wzzwrbn0EXkyH6w9SicG18AQCP2JS873KGm0fZM/oEBEt5hfafwZ4HHkO35rEeCS+59XLS
	qXRmCCLyPY87qi3GBNuUcdO/WriQ8C1cqLN2n84TLid2FQM5lOZej1k9pYHTr+xLGx+EXZ
	UzpD6oeDI2zwnUiHzaP+pplDoCNQ83g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B890406CC;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A991C2BCF4;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=n+q1qgFLiSwvjUPpDAXg+gMGkb9JtV4aKYDtoDohKlo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=T4ZJIXkomUX+C339mTXSfpVBbkd+iDAy47mofvTXwI7dxotGESB6mJNaacxyB4JgV
	 R/0t6pjDCA2FY+ghcii20tO4VkIMmU3A6uGbUZ+AzTl2l1p2ns8f9iooHD72Fa8qsX
	 sdpRlb/xWk0Ps/CW36hYg8Rd4fS+V64iQ9ZmZYqsFvMX5X+3oyQLxMQv+vxWaaGVsq
	 otZ0pq92bdjhqVxf0jUiJU4DHl/Ws97djuhOohXuyW1I0cP7Vb3f+lBkdtAjYlcQVC
	 HUvIIAjExqjrmDzuy4cTZ+qtB0cxmKmEp7DZ8tbQDYZhnpK5vWjYAw5qVHouuHSJpj
	 9g9Ph5fEeKQPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A9BC9830E;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:51:01 -0700
Subject: [PATCH RFC 14/17] KVM: selftests: Test memory allocation against
 shared tmpfs resource pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-14-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=1937;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=e5T0d60S1RJIK+yOTmGq9i0vT2WW1I1oApGjOS3UiOo=;
 b=9FIMY/6EtN+BUMK9CipyVOXFBib9h5+8+GiXMOwHojyWfqXUItP+KcJF14AQK4ZJmIOmh91rJ
 ZO/6zjGODO0B0t6LgIt14X3vvd4keOV4Nh9d0fwsEHcMg4dK1F0E3fr
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Stat-Signature: 7oqp8zm3z9rnm4n6mb316sbkesjestrh
X-Rspam-User: 
X-Rspamd-Queue-Id: A3B95A0006
X-HE-Tag: 1790383855-242872
X-HE-Meta: U2FsdGVkX1+u0uQwrACgnnMYQ/GuWzMNrngUcQWAf3xtPPommsTpnq5eZYIvBcpvvsnwgLlkBEYNlmRPO/jk7LcIPJjdyBxismXmoZVJK7rdim9gBPBFsiWQTsBAFe9zFnkBTGy0kgdJg1V+X2Jm8zh+TQIZ1YlHTB9m/hv6ATPH1Ov9pK4Sbeu1wbfXa9HSyVtKuOt3Bv8mFX0lglrkLJ6zaABErYYv00X2HzVrv5X2Ws5FqeR4BOGMaaYuFfgMtG4QCYHfL9H8lCwoVOQMIyT4plEZmhgFhJGG+o1rWzgHqlLR6b9LbRgkHT/GYzEGkcI/sxFb6gKZL5SdNXjmdaD+od5JAluKSLy7kplPLyIFFj4XYCrjL6w2b9gOLdKN3CwxiL+5zIwl6mFvaHKeqx0M+aaQOlFYU8yjlyn/pQWfAm0DeIlUbEpZFAe+Qw78y72AbyVi1qEh6eBezpT1/VLdW2Wa31XcLh6I1VznzSgzSvlu+E4ptgjuIqdKsObxlJHfP43hG98BF7Ug2kLjqLJ9kiJQTCTbf3FQnXk+oXFku9MkyR0EWcMwOCSPeXWPRs9WhUmgliERwHM1P63O1zJfCCZ4XOCPtu9pr0DNU2ACdEAKgqvOfDLEQiK0H/yNcbFKZH308lnEHHeXhZxtgnXu18bl0JUPy/FRWbTvbfxs55LK5EH7OTaj26My1hdXR0kxRHbJJKyLT+1ybjzpq+aQ0TK8b3bqXVUNOh+5YCCSdfjhDjIwnRxGK0aaQKISIqeSZu2hrl48TDL7US2mwIBo4/otFwBCax7CNjUPmXvT8l6iQLc8h7etIhv0odJdtAR+H4/jCZb5KMOB5REj0XCOjN5avWNCBZ6Ii91lllFMpBlIZjpPSz4pZpPqv9CI8tYDpLpIgaxQnLrcXu/k2zstgQii0UDFx7JSlfgrEmupeFNzYtGjopOStvfzvwv2vIQBdL9y98wt0KoHpMd
 sfJVjZjK
 cM0qZbbAS5KBSJpzlGKX46h9M2spocqMMHeDK8QMWDGGJ0rLwjC1PYqQvFcO9IUKEE+jbTW+QG33BHpYWGAuk25XXEsuWCFt7TOwCXtnyHrgAHF/j80OJRTU+G1TC+JNHPnomwRk3kLHAeqF3cIvOsC65U9MVFk3sLjjHZ/5hgyMldBhzyc9JFXzd6K+8hqyCkn4xljIzfWy9achTb29XO+/a1ZgIlhU2CoajLKPr6uLH2XUg5zgYKzwZaIoxgPGYvYFYyWp9JSuQKkB11IZi1sZb9vVoSFYxTsmbKt+HqKFM2+0iUh4A8zuA/UZe7ogmFdE1rWprjuLBTT9vu2nO5RI1VV9ySFt+72J0ZNjU9BkUYYsXLAf6sgr7N8/OqnqHJ/C6h3ncJyfa8oS2ZUGW+F5TbN9s+DUYUMXCd5MkqBRbUf4ejFrTdnu95AP6ItkTAcRtskpb84zH/aDeVTFy13BSO1cUZpq2jINyrwDdkw3IUy1BMcNQy/k1WrWukb+gKCmbloDy9zduoji6JmYv7YjlrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Verify that allocating folios in multiple guest_memfd instances sharing
the same tmpfs resource pool consumes blocks from the underlying pool as
reported by filesystem statistics.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 81311be059923..4610eeab39be6 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -19,6 +19,7 @@
 #include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/statvfs.h>
 
 #include "kvm_syscalls.h"
 #include "kvm_util.h"
@@ -545,7 +546,8 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 
 static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 {
-	int pool_fd, fd1, fd2;
+	int pool_fd, fd1, fd2, ret;
+	struct statvfs svfs;
 	struct stat st1, st2;
 
 	pool_fd = create_tmpfs_pool_fd("never", true, page_size * 2);
@@ -573,6 +575,18 @@ static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 	TEST_ASSERT(st1.st_ino != st2.st_ino,
 		    "different guest_memfd instances should have distinct inodes");
 
+	ret = fallocate(fd1, FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate on fd1 should succeed");
+
+	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
+	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 1);
+
+	ret = fallocate(fd2, FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate on fd2 should succeed");
+
+	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
+	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 2);
+
 	close(fd2);
 	close(fd1);
 	close(pool_fd);

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



