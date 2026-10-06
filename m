Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42878CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E2F6B00AA; Tue,  6 Oct 2026 05:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426026B00AB; Tue,  6 Oct 2026 05:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3637D6B00AC; Tue,  6 Oct 2026 05:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 108CA6B00AA
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:25:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AE321C35FD
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:42 +0000 (UTC)
X-FDA: 85291668924.05.6456EF1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA0BF140005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:25:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=amZ7w9bQ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jNHUz3d+cv9DUHQq6vgU0LsNa5i1pYpsvAVMUZeVWo=;
	b=uJmVtyvKa6uVgvmeIM2Tzj3TbBLRY6CMcfF/nlyt9wC+mqcfwQm2qTNNkHCAa6nFlQGi6S
	n1uvJjKEd9O3UyVL+Bmk4SlF1qz9Tm446t+s0IJWRueM8gnQbGoLaC7AUlf0ZfW8ksMBJL
	sIfDuTPq3IFoQaJiERfvHrTRDt5nWok=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=amZ7w9bQ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278741;
	b=paouFySb9fdbJtwWWQ2xz8jaUCtoCqo1DooqCRULTjid8uB4BFc2y6VAJoPA8a0vlHLIyS
	x0lR6CyveEUNTNiDk3BnpOWa1+bNQGVdnODho5GIyHiJdgiZeBncMQnvLvn6XRRId5nT5f
	7b0pskW+nBnjS7sWTxUiuqaUi3ZSS7o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92A3C152B;
	Tue,  6 Oct 2026 02:25:36 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ACEFD3F763;
	Tue,  6 Oct 2026 02:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791278739; bh=pQa9n9na/unDTq1Miq8zfVgvzrRNO5BX3kT/+B7XDiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amZ7w9bQrVuAlJ3HPbZo2g6Q+B6AZx3BsEqAvLxBxeyhvZwr1gvGDu6z1/vYaaOW1
	 UsRAKxU7NRytwwUTwZlfZd8T/ocvSAew59VTLGMK3d4DkXOCSFnr0OlSBN9HSsLnn1
	 f7yK5GEiwqeRMSBXo32ihCSY4em3fZNd2hcjrgZ0=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	jhubbard@nvidia.com,
	kaleshsingh@google.com,
	anshuman.khandual@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2 03/12] selftests/mm: mremap_test: simplify errno handling
Date: Tue,  6 Oct 2026 14:55:02 +0530
Message-ID: <20261006092511.145776-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6gh7hba5x1k195h4n4ix4b17p455piiy
X-Rspam-User: 
X-Rspamd-Queue-Id: BA0BF140005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791278740-312619
X-HE-Meta: U2FsdGVkX1+wMdP/RiEDiZdqbhBnJbM5p26ztthE2PvWxOYHjvEvOWiHMqR05ypPT3Bfqwh5V1oHJGGrzBiHTeJLQp0ueC844EBZvUDoD8abXHLTdD4MnaM5kJ5RfaMGYek36zt2Nu6brMIXupmCcMcqMv0L6ot4oyCHO7DvpwvfCHylA+L3nPSOFTluz+u+NIc0cCSq3zG4HIhVroRJsBgt088NYrQAwfUdHxMUiq2Fi5grd82NAHI7DxseWU1gVlDOKR7wg1tmo6Vic7aRsrJabbyth+fhlezEi6TS7HFHDsKRHqJfBxcZjna5nTqygNPUC3hSqTQZ8uoOqnaNckto/L7+UhAZA9/oD+aOZFJtjpWeZjTW89nE3B14Vne+U4P5Z1lKHu9zS/FPuSqlC9N5XuH2DJ2Mt9wqQ6brPO1UlStabacJaTy9LDHj5yP5t/AIv8UP6LsqfVww+if+bNh/Adsglo3+69cKZ0YVN/3cMHN3+MvbdIva1kL40SLygoRzhgdHqiWP8rj3aIxYSrYsBdrktQG9aibc4EK6Cjm69GtvsgpeRft3PQE59N0W0BUxwgC2hIlXw6xzEmrA93Gd0TmgunTcPINhQfR0vaT/3aLPm53gM+ftsW64o3TS514Aj6BzWkwIidysbkfhl5tcqt6M7wGDiH/YmdP25k5xQAPlL4P0u5PlT6vK+uYROqdkqWYKsr1nTKvJKv3ZBj25QX7B1o+H7DnASjTGVwxvtgv+bXEklz1WsBkMM6JtGNyCbwzE0KXmuKbKuMM8Mz0yy1bCaY4j+eEnxRrq+hwN0FUPW1OdDTkzK01ynaY+8zvTd4Wa97fXdToFmCWen6+ITs7S9HA+xFzpGjL7zoXp2Z2ytV4FCGoCmtXV4YHsxFZMxBKgQ2a42i4Y3GaYzjduiGQFMO20IqAtn4DlWr2P5S8pcIPxVitX407W4xZ479L6klG7paQ6FeBpHdW
 HsN5X7Zx
 o32GFqeDhj/mQAlGB+kga8qsVqmdzUMhoMWq8o+prpZNZVPXZfm2bUkjm8BuHix48UPyQTpLTa4WNHJqbapSCPMCEuOgUX12x2qFRhWTvFysRaKU+Imr5bEMaiU3B4ezJm021xh3IwHf+nxV8q23fCMtIHlKJiPMRzB1vFWtzmQ0tykpobIZfphWvCbuWMoGTN7Ddm4iDViaM6sZehe+RxUtygE3iH7O2jaK6rrnsReAq4kh6au9d3bjjShAWEXSJ514P7ulNZGkAK/O0LsUZ//V6DAHxejTlmnP5rO/po5F73JcIznHpSBZMrjQ2y7cQS82K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_move_multi_invalid_vmas() saves and restores
errno around several checks even when no other function
call can change it. Remove these instances and compare
errno directly.

Also move perror() after the userfaultfd skip check
to avoid printing an error when the test is skipped.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/mremap_test.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 95ce6563289c..7cf1d235f309 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -727,7 +727,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	const size_t size = 10 * page_size;
 	bool success = true;
 	char *ptr, *tgt_ptr;
-	int uffd, err, i;
+	int uffd, i;
 	void *res;
 	struct uffdio_api api = {
 		.api = UFFD_API,
@@ -736,12 +736,11 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 
 	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
 	if (uffd == -1) {
-		err = errno;
-		perror("userfaultfd");
-		if (err == EPERM) {
+		if (errno == EPERM) {
 			ksft_test_result_skip("%s - missing uffd", test_name);
 			return;
 		}
+		perror("userfaultfd");
 		success = false;
 		goto out;
 	}
@@ -810,14 +809,12 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 * time.
 	 */
 	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
-	err = errno;
 	if (res != MAP_FAILED) {
 		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
 		success = false;
 		goto out_unmap;
 	}
-	if (err != EFAULT) {
-		errno = err;
+	if (errno != EFAULT) {
 		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
@@ -863,14 +860,12 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 * first VMA, but no others, and report a failure.
 	 */
 	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
-	err = errno;
 	if (res != MAP_FAILED) {
 		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
 		success = false;
 		goto out_unmap;
 	}
-	if (err != EFAULT) {
-		errno = err;
+	if (errno != EFAULT) {
 		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
@@ -912,14 +907,12 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	 * the last VMA, and report a failure.
 	 */
 	res = mremap(ptr, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, tgt_ptr);
-	err = errno;
 	if (res != MAP_FAILED) {
 		fprintf(stderr, "mremap() succeeded for multi VMA uffd armed\n");
 		success = false;
 		goto out_unmap;
 	}
-	if (err != EFAULT) {
-		errno = err;
+	if (errno != EFAULT) {
 		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
-- 
2.53.0


