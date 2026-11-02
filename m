Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6354606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Cj6s93ZI
Received: by kanga.kvack.org (Postfix)
	id E7D696B05B6; Mon,  2 Nov 2026 05:02:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53F96B05B7; Mon,  2 Nov 2026 05:02:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A056B05B8; Mon,  2 Nov 2026 05:02:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B61316B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:02:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BD921C46B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:56 +0000 (UTC)
X-FDA: 85389740352.06.508D25F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 86B3B1C000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cj6s93ZI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fS2c2C7KwS+6ZnSiJLsAY1EuAFU3bigFxhXvD4SjIqg=;
	b=cuPh3THC0urGLGezxvdFMSSfpTPLGWks7mAmtBQDyTqbdoengB6JT9OIjc7NccrHZaCMfZ
	dOfjzTMBwYd+8DiHzYdj2y4/leyidaF8/myDbClCxxLxwZ4D+ktlVkdoMD2gMofCNIKYki
	R6lho/W47H9hsUTOMgHhrbWP9M8dyNA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cj6s93ZI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613774;
	b=HcWJUv4jH92JrRadaCEO0J2JAJz2s/S7e7lOvawQ0eJFtwmEiEhbmQgS5Vt8cMZxN+nW3v
	fKy0QQWAXk+gcGDRnqNPvYtubUULQa8tJ79L9WtzKruqxdeLiem4uCLWNktOMe2FoPvkxJ
	Vr17EFxrrTWwUSg6PEq2LIVFIg6T4Gs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A2D6293B;
	Mon,  2 Nov 2026 02:02:50 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 417313F59E;
	Mon,  2 Nov 2026 02:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613773; bh=8wsfGgLEdsKEjl6cnefytFCOo2oRceki3G1+uaW7P0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cj6s93ZI5cOA9As6Jz4UP/a6fwDKPjsNH1FDr57csxvtGo3Tpf9DN/B6dbyINrW+k
	 CyqhN2q+Smlfgo4haUaHe9GeO+Sx2ohv5eF363R2Fq3CFa+wXfa1CUDHLUkaF2wN3y
	 o9hrGMIjtf3HF75L01kb0JKMV+E0xeh+d8Jnm6uE=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND v2 03/12] selftests/mm: mremap_test: simplify errno handling
Date: Mon,  2 Nov 2026 15:32:02 +0530
Message-ID: <20261102100211.141831-4-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 86B3B1C000B
X-Rspam-User: 
X-Stat-Signature: s9tp4f8owni4cafzx4opo1g8cs8rzowk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793613774-429525
X-HE-Meta: U2FsdGVkX18oLqRck8s1pwGvFUpMNwBtZdHhmUlh3O8S5WhNBaRXWphFCjBi8qPTZfKx4RrA3bhRL38XXWK6d9Nstp0pUgvKg/hIltjAlZY5PMn/sVxbw2PhgQZHCj/dJ8HGu1lj9jBVZqAcQcENkZlNsg/EM21g2dTYtFaV00ZzjkUXkFclNW7pmKkF68trHz805XOkWjnvp77e4ga5ANHkWamEChb7/IkD/qCcFsKmqFUZqls1kpzdOxu1CoOPi9zyDByai2L+iviebnu51UbpdKXe5ZiwgdmsnHJ8Zk+pLZ44zelrTJn6Vm14vAorXUFfMT21ozHfbOgvzG+yWUkdBGWNGlG4nP3IIP/HuhdqDFxAv8t1mMjWTlqDVuScHcEJjvRqF8gQON22+WGjDhDByExv0prGUb8YNkxDPcA2ql3j8s/h5Yb5P9cscsAoM1xALQifl0gpD5t2TkxwB1GPxiO4SlxdG1TL/FH8kV+BvqKJJdlo7sbj58GGfauNj72JAW7+by97yPgClzJsReO8shXvczs5bYKsdMnPwN9qSNK3WvqAi87TP982CVwPWiRqde9djnAyfxvY7lKuqoxChr64y1n1zcdEipZ/k5NM3GPMMgTaq1P5QzOk/oq1sv+maz8zVvBLk3McU+YvCJPVakYAi5+agwQO/PpUYUfv2khe1NFLnnSmv+nzQnOj1xYz3K07tKynJeE16RQqL8tOtOVMd3cGFdxRHLOuh2H8QWuE3xxsjYFlA/x+wqILnT1JIk1JPwRed+itMpjKjx4TzpQ4bK4U4jdr009CqDmZxovUbrq4H0PmE6cD3sUMlvK5pkn3Z53qh7Atr+F6xjvxrt9gWIOAjFMqqpyKpzrUXNTqGNuG3T86LyvBym2Z6/kCn7LUf4NWmPIZoqDtXn2My1D0Z0MsG8kQbdWqr9XOAlOwL05KQ+AdC3PiSawV2gbJukl2P1ldd95U86e
 mMuumIME
 DDAlohCQiK1llaA5DP1V+KRODg8sWd/M8+u9NoVC6lE/3aQnVQuDNbQwlHV9CasjurF7DBnNdjX8d2y+u3K3SNghpaEuM68BYE0b6xNodVwK1IDXHMwMKCyINDbZbJN8ofXLGiXPsnlTuBbs0QP9aL0zdsVYsl1QHVyMmPBUzGUmYh9YS9Uu3QZMZm8+h2eCpcUzffj4P9xlj9zOLNKj6WRxQ/+IqKYnjadUqgfH7UBHS3biDFWo8W0Qq1QXqA5wvDqmd+hDa3PliUhNQfMo2nKhGesf0mZBc8txo1tATB4tUset9MdWqBLl18G5TCWDKDJdL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index ea1348a9532e..72e6e4c3bd87 100644
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


