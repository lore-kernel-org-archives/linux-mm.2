Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC84C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 22:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E996A6B05DE; Thu, 13 Aug 2026 18:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2AA76B05DF; Thu, 13 Aug 2026 18:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D128C6B05E0; Thu, 13 Aug 2026 18:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94B1A6B05DE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:53:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59DEE1C1038
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:53:45 +0000 (UTC)
X-FDA: 85097750010.23.A01CAEA
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F9F810000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:53:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNG1PS9P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786661623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QcZaXKSZ+vl5BQB5E9TRFwg6GdaSdB6v8ybUxPjYbic=;
	b=fpEfzMBPfx/s1NN7GNZd/g6vniDdwBePEXCcWqovoNrY/avmoHrjMXT8FKmxu/JqogntN+
	TfLeOvpj1UCILCQlCTWZFxQeZ7x40wr8amL9Tdef91F/RhYYd3jbYYXW6+VGG6R8/ekA/a
	oscuqc6xrf4OCuU1mA3rguEuXiyc5s8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pNG1PS9P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786661623;
	b=SscSOJHQuOiRMIaeCzWRkaeE4JpN2y++mqUYVg0qfzfjcyscmxmQyC01dYrWrCUUJCNTf9
	MvdLgXfurlvUaVaDn98z+LHRsGqMJCI//P+tyNCBuUoqGtPbX+U9jPFydhgdbd0fpwPCR5
	SYXMsgsGHnyjV3prsFDuzKu2ChMJN1w=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cca0c5799eso4389115ad.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786661622; x=1787266422; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QcZaXKSZ+vl5BQB5E9TRFwg6GdaSdB6v8ybUxPjYbic=;
        b=pNG1PS9P3ioPVKABsG1w7bp8betzMj6kTAcL8pYj8HTX+xQBm3QHRJB16yR99Lq52R
         APOwEvefBDkFYzLI1jUGoNeVaMSuRAkxXq0dgU12f7MO5CDdcso3ot/QpwzWFqQ8CX2G
         CeOva+NXlK/oesk71nW5avfdA9qRk2R3d1zFSD70pqvAyuVi++KbduhojkKFp2hmoCBd
         UFUaelVs+T7Ek7gI6yxHFOp/IegqeROjF7YCbAa4ROu8xO4OPtlYWKkjBmi57r8ZPNpN
         t8d2OJl6z3khdCN2c9LKBRXGT/vwWY8RoLhXNbsRl7xRlJfTLLG/q+myRk57sbhvVrWM
         s7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786661622; x=1787266422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QcZaXKSZ+vl5BQB5E9TRFwg6GdaSdB6v8ybUxPjYbic=;
        b=OaG2vlRMG8j8l6quEUku8/h/HiQa97E9OdgFLtgJX+2v/7zqjwgehnRJA3nrpPPnVr
         3UTuJLebUWPaSWiXZBPfyy3UiZ8qTZNcXxt5bb7ut3TGNOjMFxAgknknLFanRxC09j7Q
         mJ1+ApWoeIiEuwPN/RT+OnVKyEmf3EK3POdIFeo6eQxYd6z0Qz7xr4hqx74ArmPIVX+F
         JIIzPuDesAY2GuUbvGqbsaubSzAfOjC3X8P/VHHjSEVfcLi4JcwV8bchYBx7UeBr7Gra
         R532LVcPyiBOdPxCE7sqPlSRxDA6K2wDqFxru3/LC1YLQgOlUsYJNXBMwtZJXHocRBXQ
         tX2Q==
X-Forwarded-Encrypted: i=1; AHgh+RpqajbKd82Jaf4Hf0dDA2V3c7IuXoE5p+t3lCsPeOAi9K7Rj0+0PUIhraDSW6itwA9Vsj4hDdngrA==@kvack.org
X-Gm-Message-State: AOJu0YwFhzcxW9q3HkLm4w8fNqIW+MpjCRatkUTGuBN2L02s9daGi1g5
	3e80BLpn2+u3ULU3+Gmem5Ez39ZELepTgkEFWyNr75fHfyjoySojGznm
X-Gm-Gg: AR+sD11/Ozc6hhWvcJx7C2iRW6xeH74t2Vxs4F/+Uqgb1SSOVapgPFOo/MbQLUmr6ZV
	KcG92BoCS/xBTr3L4R7GQYSvElE7H5gNgdBkEUXM18Qdf1+2HQdjs0hJ3fvFk/xOQLpZexkLI2l
	cCtzyI/zS3pISNNw6/MwvR3fZN5ojenM6iCOoUxkZSjfJH0ra/2RjVaglVPHPndwvlumIFOMd7f
	V2EsGwvMa2C7p/NsDgXzEU1+LoiFHX5sCZe4gcEB68XClfdOmqGEeHLkPb9akJgpvve+JT3iYaX
	uC8hTgTmqvsTIBzom1pOjkhHtAPexxcdvcYzhIPQ17yFIQrNYre1A+1RX7UbaaFm+qvXRnR5nMe
	xmH9gVQVpnhTuX45VS4o987t6Gjp4BnfTHQWxMpNujgy8r1ZlDUfgxjqhEl8eQ7joqczSs70o3m
	Xo97yLju73I0Tm9W6rBEGP5lT95TDchFkefdzzFfRx0e9uAviLfZuV1lm9AfjjhPgt2R/dA6YU
X-Received: by 2002:a17:903:9cf:b0:2bf:27b2:4b80 with SMTP id d9443c01a7336-2d3b0d1302amr15512025ad.14.1786661622331;
        Thu, 13 Aug 2026 15:53:42 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae804b32sm2657265ad.35.2026.08.13.15.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 15:53:40 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH] mm/secretmem: prevent uncharged mremap expansion after fork
Date: Fri, 14 Aug 2026 07:53:28 +0900
Message-ID: <20260813225328.2010303-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9yfhc3yqtb9k4jgydhynzh4wfbmnpche
X-Rspamd-Queue-Id: 9F9F810000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786661623-534485
X-HE-Meta: U2FsdGVkX1/hhj9auanpnmx2KFNtpKzNSfy083TgGh3ZILmZGculUjNwIZ+6foBifN5ZqpFv44/Pw58JKCRwvaubIAJZdcush158f9Zr88wdlm5eYq/qWoMv0hKon3t9mvESLLrnSIUYpoFImtw6bU17SGuiVNPRunDnIZ8zGIBXC9AAAiYNqNMUR6c2nKRa23PsLlNSCHFC6wH0lEl0OO2KtNzYdcTKu0sMM8h1kNqcBuXlUcTgitcY6y8603rfFOAR5huT+JS9JVCWKkIuu/trVoDScba5Sas1a/oNoBo55Cgf+nAT5b+uxyy5MMzxfV6h4Pg2/+RGMeNdnvd1Bo/B7OWeowwvbNk0PVxuOBuNnwSIMXvuMANDY75Q8UOs+ER8nWpDt1uDFFfY2O4QXoOdBWL/yc3bkOUf1DNAkxvmgfrbLsu23eYi9VlsfvWbtxPizdurU5P5elw6qbBts+TKqMnzZz+Xa22HCvLi7M1Azw28O3616ffJRRVkBDYgF2t293TYzGi0H8zFvTcXiBoMurSfB+HuhbbwfDf3mcXgkn1zqC0IvLt4GS16Tx+Gjhnm9kJjzmxA6Z4zsJpm2aKmIGNqCgyGCvD0H3aQj9EYYz7sd3tIJZ6tAQUNuODh+VfQsErwXZ1JtK0nxJKGzcT7iXqFlYWPCePDsZiiWNlMNIbZ4Nebk0gaZOQs7M2xvdwDA8ZHDFogMZwhFQjJwFKZKrmb9M/2q0/rI2ssnaymvWpgnVeUJMkE5Ni1f1jZ4+xmJzdSLSERbDqb4Vww5wJK7I++Bq3dCQsjXvggzCBukZJguzNQqQy2kqtazaEVOwOiGd52ZZBOdThXZH9rmmRgnCPxR1dY11mReAXdUhHwyufK0eJbdd6WlHEttlde0JUTZb2HZbRuIHFWUAc71pREXdnc1v/Lbx4+i1VpIauGoyXLvUI8e5kBHPKLrgnlB6agzs6K0OvsOI7ay6x
 301eSrxj
 zXUTx+cHp3PvL6R4/RA5TN0JdBXGte+ZUHscqjqAwdLvjzb3KUfIQy20q4J3fCpaV+AQUIloU0UfK0o+oP+CR/qRUFFK0d1jt8nRbNPFe/E7JeRUoEuVXvyeAwLA+DgwP+l8qhppO3GM3qHvfPuYv3hLyOYCnwOqolNhDH2fcvyv9UEWMz86NWB1O/6/DtrHZ2WZO1NRyg5uocGiURx1VT8sN23zjekYELWa88NgNE4gn8/qKXfbleJko+Z7tXfZGqj3mcooTYNyZqbD+c9uVlnnRxfQenlQqyDZFsTw+nY7P61nJSMjjSxVfUDD6np4r9tw4V8BcS0+MjjPZA2xtW5kHyAyNb5KDlq/jao76rvNib3PVopXWBNDwLQf9aU2z4ITVvOQK5mmvwCyWGNW8gojpV2Qac7quwZPULGKCpi3T1srEZHKSaXuaFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Secretmem mappings are charged against RLIMIT_MEMLOCK and marked
VM_LOCKED because their pages are unevictable and removed from the direct
map.

dup_mmap() clears VM_LOCKED on the child copy, but mremap() uses that
flag to decide whether an expansion needs a memlock limit check and
accounting. An unprivileged child can therefore expand an inherited
secretmem VMA past its limit and populate the added range.

Add a VMA open callback that marks secretmem copies without VM_LOCKED as
VM_DONTEXPAND. dup_mmap() invokes the callback after clearing VM_LOCKED,
while the original charged mapping retains its existing ability to grow
within the limit.

Add a selftest that verifies expansion of an inherited secretmem VMA is
rejected.

Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 mm/secretmem.c                            | 11 +++++
 tools/testing/selftests/mm/memfd_secret.c | 58 ++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 4877c262cb1f6f..e5878ce91c768c 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -108,7 +108,18 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	return ret;
 }
 
+static void secretmem_open(struct vm_area_struct *vma)
+{
+	/*
+	 * dup_mmap() clears VM_LOCKED before calling ->open().  Prevent an
+	 * inherited, uncharged mapping from being expanded by mremap().
+	 */
+	if (!vma_test(vma, VMA_LOCKED_BIT))
+		vma_set_flags(vma, VMA_DONTEXPAND_BIT);
+}
+
 static const struct vm_operations_struct secretmem_vm_ops = {
+	.open = secretmem_open,
 	.fault = secretmem_fault,
 };
 
diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
index aac4f795c327bd..3d33487eaaccf3 100644
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -84,6 +84,61 @@ static void test_mlock_limit(int fd)
 	pass("mlock limit is respected\n");
 }
 
+static void test_mremap_after_fork(void)
+{
+	void *mem, *remapped;
+	pid_t pid, waited;
+	int fd, status;
+
+	fd = memfd_secret(0);
+	if (fd < 0) {
+		fail("memfd_secret failed: %s\n", strerror(errno));
+		return;
+	}
+
+	if (ftruncate(fd, page_size * 2)) {
+		fail("ftruncate failed: %s\n", strerror(errno));
+		goto close_fd;
+	}
+
+	mem = mmap(NULL, page_size, prot, mode, fd, 0);
+	if (mem == MAP_FAILED) {
+		fail("unable to mmap secret memory: %s\n", strerror(errno));
+		goto close_fd;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		fail("fork failed: %s\n", strerror(errno));
+		goto unmap;
+	}
+
+	if (pid == 0) {
+		remapped = mremap(mem, page_size, page_size * 2,
+				  MREMAP_MAYMOVE);
+		if (remapped != MAP_FAILED) {
+			munmap(remapped, page_size * 2);
+			_exit(KSFT_FAIL);
+		}
+		_exit(errno == EFAULT ? KSFT_PASS : KSFT_FAIL);
+	}
+
+	do {
+		waited = waitpid(pid, &status, 0);
+	} while (waited < 0 && errno == EINTR);
+
+	if (waited == pid && WIFEXITED(status) &&
+	    WEXITSTATUS(status) == KSFT_PASS)
+		pass("mremap expansion after fork is blocked\n");
+	else
+		fail("mremap expansion after fork was not blocked\n");
+
+unmap:
+	munmap(mem, page_size);
+close_fd:
+	close(fd);
+}
+
 static void test_vmsplice(int fd, const char *desc)
 {
 	ssize_t transferred;
@@ -297,7 +352,7 @@ static void prepare(void)
 				   strerror(errno));
 }
 
-#define NUM_TESTS 6
+#define NUM_TESTS 7
 
 int main(int argc, char *argv[])
 {
@@ -320,6 +375,7 @@ int main(int argc, char *argv[])
 		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
 
 	test_mlock_limit(fd);
+	test_mremap_after_fork();
 	test_file_apis(fd);
 	/*
 	 * We have to run the first vmsplice test before any secretmem page was
-- 
2.54.0


