Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DF1C5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 08:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8146B0112; Sun,  9 Aug 2026 04:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9E46B0113; Sun,  9 Aug 2026 04:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFAC6B0114; Sun,  9 Aug 2026 04:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A91A26B0112
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 04:09:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35DB8A2675
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 08:03:48 +0000 (UTC)
X-FDA: 85080992136.18.99E32DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 998C21C000A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 08:03:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eN4rk+K1;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786262626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UUnD4YT4HuSOBagwB//yv3X0Nx1d1hKHYt4Fov9+dc8=;
	b=8VlTiLnvarZCMikotYIabj5f+dOZZbHNd9lzUz3VqNJFnCFIsiBjVib82t7GlFKrihwqv6
	ZdO2XLN06sYwUSaTu7ziwp/k0SN8CTcxnknWi5u3RR25U43sEIhozvJddZKf6Lx6CjnHbq
	r0C36yxzDbMWHwkooOW9Awqw1gQD2ao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786262626;
	b=bXPFYCa6JnIkiFQdNQd5idZasDKI1lI429uBcTOhTs2REzNCx9nOwc8Y/h1U0rcd5sXi3b
	PVzBlyVZ6fxHN/xRw/xnV1yuKXVyQ8YZ9oti5SevT1tPr/WUYXmWNe5KtykqbfE+0lJJer
	KMstRLQE59SWlyv+sYhwa6ux6cZyLA8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eN4rk+K1;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9974D60008;
	Sun,  9 Aug 2026 08:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F91F000E9;
	Sun,  9 Aug 2026 08:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786262625;
	bh=UUnD4YT4HuSOBagwB//yv3X0Nx1d1hKHYt4Fov9+dc8=;
	h=From:Date:Subject:To:Cc;
	b=eN4rk+K1PFz/8b8/Qu0TTafuUNHxYuoiiH5kdUll/FLdwZtnj3kIbKRy4GfaohDFT
	 XhNKai0vQ/+l02TMioR+oB56F1d+WFZZe4yBhasn1z7GoHNc2q9egVNMDjz2P5Ghgy
	 V2VeBdI+o57IwyRmBXxx1n6hjKyk4SgD911/SoJq5rFpSPZIfjCA7R3ymZK9bXksC+
	 4iq9M/NMZFv0DcR/7x5njYxH6geX7j/gtmRP8DNzejUN3qhNRNB83PILJ3Xwprk8px
	 Ppqld6zT+v9L+nNV3i7AHhmcCnvbyHFnBqC5z9rEDB8Th/WdzClA5l1SQVE4XvVAv8
	 PXYm0tpZfc68Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 09 Aug 2026 11:03:35 +0300
Subject: [PATCH] selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260809-selftests-thuge-gen-fix-v1-1-1919f4b3d12f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFY0eGoC/yWMyw7CIBBFf6WZtROxhvr4FeMCcGgxhRpmMCZN/
 13Q5Tn3sQJTDsRw7VbI9A4cllThsOvATSaNhOFRGXrVD+qsLsg0eyEWRplKjUdK6MMHtXFKez0
 c1clBXb8yVf17vt3/zMU+yUm7aw1rmNBmk9zUVIyLxH2MWBKLsTPBtn0B2IuDMZ8AAAA=
X-Change-ID: 20260809-selftests-thuge-gen-fix-5ac05f56307c
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 998C21C000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: abbjpbpwugf85f3bgwhpfc8es4nt8etn
X-HE-Tag: 1786262626-684211
X-HE-Meta: U2FsdGVkX19gGClrCkFWbbtDlm0bzV0IGIuzGt9SREI4zd0UkAaSnGzdL9JjhCN4LP+EetiQkdpuLDlaExN9WVLDb+0zXBfiAuOtx+Op+jTiHAHBYmS+CHYvIn4+otvdPbivts8/th6HFAsVdag0xH/iU19Q2NzXJ8tLBt0SSC8t5eid9pPh5hi9/7qxviLHbe3sFrYvxgR32280zPv9CvZSkekhoYV51L1xrbh2ehxvexGxHbfLETIOYrpWLHnz0WADJuHSd4ZdEGh78XunSLv0U8cy3t1W5xQFLuuggvGzVGUWJEDuk7TProW+2+fAHj+qt0+BvtJi89K5EPTZrPTIeJX/8Hh6OqaoaKI7nl8XpptQwn3jlECihHwxaXbXcW0jEjxyRXIgVGxBqfvIvVnVlXiBVYsuO7R8WHXQRxmcx4G2/IbH2f0YjRyb7D9vQn6P33DE30QeVx2oCZvmGeiVvSU9n5m71onQiwCsxK9KOHMMZuPCb+d0m3qegfXBg65rBdag4ZQAWb4LmehHiKXLh3iziW1+iPwF4QuKYf39ZCIkREGjXmO4tT3+8x6KVPJefdZISCKZkL+7nDBzZizY2TQKhsB55uWU701uJdSHcBdj991ZCh26RMoOMV7NOpwNB+4xlSMdmg2IIb3TLfiwejzNmRcFulSTQcnYmEqo2N7mo+ol0HnA1GOK6a4dCnMy1vcJnm1L/htPENidGZ7QykxZFS2yjPXAF67dy+aDmpmVtNDVaBh8oDpuu+ijHe8Nr172kyNoxb2WGsBzCrvjhcJw2fjzeXWlVfJm+Xbt+ijzjamw8g87ux/14041NNkgO9ZgWiJ+2vteEwWe6n3+qE4tfRdVqwPW2FRSoPTqxHXUdNvNxZOUYvmfyreWmu6ZmJlSsG2NHBazrewFx0uNJtJ3yIsEZMzdF96cGUHHwO3kdBzP3/9WgkWEUjcw4UK286iSveBncV488L3
 HRijwVCg
 FL7uqEYjuaKgTQjRBfYibvoBcDFYM/D7eTOQIZhzJOX6ryuTryB5NGrVvRUKGeypW/qquvtokHdKSvC8sQaQMsHeVCtW7fQ7/8frre8NOGZz4ZgIxZC+5Rnmhe7Q4OqAnfz10hpcFpY6bAr22CrAp1aKkYg+hUe6VmdNHrtvljShjCibyymYXxtieF9/nJw4UE4SzFBj/IGzC23vPmyy7aFW82TESi9gvPdzm2qZLRV1BRTt6/k6jHxXk0JO/FF1s1MnKTjx3cdjBAd0AZ09u6b5aSndMjslHxxpg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
changed thuge-gen test to use common functions for reading hugetlb
attributes from sysfs, but it missed that the original read_free() function
special cased PAGE_SIZE tests.

For PAGE_SIZE tests, failure to read sysfs was ignored and read_free()
returned 0.

This allowed test_shmget() to essentially skip the check of how many huge
pages was consumed when it ran with PAGE_SIZE.

Commit 3199b0c09efa ("selftests/mm: fix read_file() return value check")
fixed the common read_file() to actually return error on failure and this
exposed the issue in test_shmget() that checks the number of free hugetlb
pages even for PAGE_SIZE test, tries to access

/sys/kernel/mm/hugepages/hugepages-<PAGE_SIZE>/free_hugepages

and obviously fails there.

Gate the checks for free huge pages on size != getpagesize() and initialize
before and after variables to values matching PAGE_SIZE test.

Fixes: 49a4e7186b08 ("selftests/mm: thuge-gen: add setup of HugeTLB pages")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
selftests/mm: thuge-gen: fix test_shmget() for PAGE_SIZE check
---
 tools/testing/selftests/mm/thuge-gen.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 22b9c2f1c35d..50d0805b65db 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -71,12 +71,16 @@ void test_mmap(unsigned long size, unsigned flags)
 
 void test_shmget(unsigned long size, unsigned flags)
 {
-	int id;
-	unsigned long before, after;
+	/* values for PAGE_SIZE test */
+	unsigned long before = NUM_PAGES;
+	unsigned long after = 0;
 	struct shm_info i;
 	char *map;
+	int id;
+
+	if (size != getpagesize())
+		before = hugetlb_free_pages(size);
 
-	before = hugetlb_free_pages(size);
 	id = shmget(IPC_PRIVATE, size * NUM_PAGES, IPC_CREAT|0600|flags);
 	if (id < 0) {
 		if (errno == EPERM) {
@@ -97,10 +101,11 @@ void test_shmget(unsigned long size, unsigned flags)
 	shmctl(id, IPC_RMID, NULL);
 
 	memset(map, 0xff, size*NUM_PAGES);
-	after = hugetlb_free_pages(size);
+	if (size != getpagesize())
+		after = hugetlb_free_pages(size);
 
 	show(size);
-	ksft_test_result(size == getpagesize() || (before - after) == NUM_PAGES,
+	ksft_test_result((before - after) == NUM_PAGES,
 			 "%s: mmap %lu %x\n", __func__, size, flags);
 	if (shmdt(map))
 		ksft_exit_fail_msg("%s: shmdt: %s\n", __func__, strerror(errno));

---
base-commit: 17e5919bdca144d4e67337f53bf57d7811f62192
change-id: 20260809-selftests-thuge-gen-fix-5ac05f56307c

--
Sincerely yours,
Mike.


