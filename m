Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68BE606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IAPMaKU5
Received: by kanga.kvack.org (Postfix)
	id 65D7F6B0919; Wed, 25 Nov 2026 01:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634AC6B091B; Wed, 25 Nov 2026 01:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A0B6B091C; Wed, 25 Nov 2026 01:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23A746B0919
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:53:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2535A8CCF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:53:41 +0000 (UTC)
X-FDA: 85472725842.18.3224D3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79B9520002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:53:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IAPMaKU5;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795589620;
	b=OAB/so4Gmu7F/cbD0r15DcKbeVfduHXmvz05h6yvnU7KOIE7uNhbZowED0LyXqG3TZ6sux
	CD9Ld2UpK0k4+SDn89KemdQyC+lqAr0kIjf3WT9opQPg0BHM4eg0a2i8dZDZkF0CsvjARh
	cjO8dqxjyveRPlG4DDqGF2dOdCmtHGk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795589620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Dqt6DaQK+/ILwEG6W5V3a06/GqmDZB86Dc26lkXrVJo=;
	b=d8mAWYoekd2K5J+llyBWkY0CwSwaU7jljwoPm78MdVQ80uV+Tkafz1i0Cu81iJ6IpSWo6T
	PrAzvaK7FnD3qPp6cxU9+0oJeJ5+SuIv48zqJmqsAt/m8BLxyZ/2/l8cyAeCGz2ni/a/Xx
	wK8djz0vjfy97k6F0UUOgs9Bt0GfxAA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IAPMaKU5;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2FBE61B77;
	Wed, 25 Nov 2026 06:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669921F000D4;
	Wed, 25 Nov 2026 06:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795589619;
	bh=Dqt6DaQK+/ILwEG6W5V3a06/GqmDZB86Dc26lkXrVJo=;
	h=Date:To:Cc:From:Subject;
	b=IAPMaKU5nts/5uCKxYRGxGmJjtOjnrm5rs39P+06ZUpsMkhTRKAFMJwybOGY4uXoY
	 bKsfQWs5VyzLZmdS2o43R+tS39X8rXRyhYqlpVGqGUAy+HRmMQ02mKW9yWtWZlfysp
	 X7C/4PC2fuWIVY3lNaJkZIbTDCkvju5c1fTeUoxU=
Date: Tue, 24 Nov 2026 22:53:38 -0800
To: Mika =?utf-8?q?Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Aveline Noir <jm5905938@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 stable@vger.kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
Subject: [PATCH] lib/test_hmm: invalidate all mirrors on device-private migration
X-Stat-Signature: id8dcnmocbib75f184x4t498dudxat3n
X-Rspamd-Queue-Id: 79B9520002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795589620-787128
X-HE-Meta: U2FsdGVkX1/I1JolHQpAhXtcXcixzle+zee9DWDZ/6ju9D07/WY+K5aHKXQa1p6/JEt4rripYBHclOuEfuq40YL9/LqlOn01Mf+J/H50sqVCLr+DAzM3/eP3JH0tH3qR0j6Yv4Ry0bR0QNLEgWgumXElD6omFnhauRvrMjHCbb0u/Fr5YFIGOO1+x7Wb3XXQeLHhafcUT84Hk24so93oMhSWlOBYtpqfYOR+HXH3ITSntEIaPB+ak1VzyDmchpAclGt1CfgWBsJn7zSDfqCnZW4EElDpBPY2W3XbfT92RawkDqoGDzRK3ylJHZEhSD0DbGiINRYRegPJIRHPcl3DeXLp6Mj/qrLlVj0gqmZpZxavQR/fSOEvwp32782L6R+2i2Pr4W/WlQHjDTaLQEAPt12jE7M/CVchIm03PbTcqL2QitrdH+jPLq3gqLZUv9EbUMNvP4WCZW++AXjWa59o1cpSAr7IhLYZH8K5Z0BCk4eoDyU+VvEuzE2sC29uy89gaQBszRyKo/pAjB3mHClxKOj8h3FV/8rStFqDavcpxjl9s3O7k2J2Xpf+ghkcL3Q3r9ccM5j1oio7nfsYoClfc9CRFPfx4voAb4oOyBqYfW28bQIbtu07AJx/cC1A6lRyMOS/5LpRLBzcmUFulpwIu6ll2cw8vz+eSrgcB/vVbg+FSzimwwZ9cYvZM3yDMbJH9usGiEJl5QHge5dOEbGZ/4e4o7aX0XOLeIkRsYF7Mt90T278fakAj6Kvl6QRl2GOmk6g8SYKP6CJLsBWFzA7bE0Qe0HP5ELW6/YZB0GqSUpH0fDYHMDPqq3MHjlOgDNPKf2nLPkEStOhT1J5PMLhOrCIaO7t+YBQJOMLLjdmUuZm0rfOEngVtq8aPUV+qIRQkG1DiPrH1qvh4ZjWTAYX4k+9X0R/6S6MGqc37IpKmGRHQjJekyV00oqVPoJzFDGSAGYNQmocGfdsxEtiy5F
 IaHCAwOF
 H0jaXoFdZ3gGzv1zfhwn591zi0kMKfIVjYtjUNmOZtiBJTzDZIePPO/1FooHkevKhNm9rWWAYRnxIgLSZ82ufM8TYA3R708QR7T4PEtpjX79EoI0VQYKI7VEVH8vzcobDUcWg5uPnSBkA1sLosxftQyqtGDl9WEOM+6VhWIuD1MMXNx9+WwakiKIuFAzRuiFExwatq8fpLooxUXM3ltQfvuNWnziieFkSqHkJy8oBRapBYxJA2AE32As+Acvz0cvbTvOHDSHlTvX2xfjO0m5Vcb1GrjSsazuHDxeASZcHstH56Q5NNJpaXdstSIlrk9LKi3PVdq2sxoTd+FBercni38dOIKZHu3ondvYuDLUGKDTEi8CsPbMxzSmoC3b77Cmy4POpIjo2v2/1PBhNePy5TLsVetp/VMkzEHQulKC+PUNF/4g6Dw3p3vPktbsE3jWkXBLO0vD01o32lcoSq79TFhA2zl2gqXhhaOcVSZeKIV6pIqfQb9b8bQAzNGF+1l/Zc+C41KK2hFpPpgSArsv2ev0WpnrJUnVxKJNeboIo1U7Ttn1kC7C7jdEwvjF9xpBXhm9Vpsm9Nhxx4madIX1Zf0bp/9nxS6i+i8ACIKLIOT/ej95bp7znYrzGJ0+XQoKtghEGyq2el0Cw7q3IeKZFtJ3Re82vvooJl8sP5drC5moxcNMOeNi5hMv4K7YrKYkHSRS1ji7+fJ6D+d2H22zqDZrV5IB15NQ2DhgY2KcgIiw2VvwhQG03MVrPwEKh16DhMU5R//7SmwbkDuL/Rwl2UrqHDIZhyCgMTfi355Cpg67U/NQUZnEnPOYzyK6ImOC1XTk9UaKkCeJt0+VQ9DUAq9fepEx4DMTR7RV+oE7zeKNVlL+OSFG/RQgKHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: invalidate all mirrors on device-private migration
Date: Sun, 22 Nov 2026 08:53:12 -0800

When one open of the fake HMM device migrates a folio to device-private
memory, a second open can fault the same address into its mirror page
table. The second mirror then stores the inaccessible device page, which
can oops the kernel when dmirror_do_read() copies from it. Store the
corresponding RAM backing subpage instead.

That conversion also makes the backing page's lifetime significant to
the second mirror. migrate_vma_setup() notifies all mirrors before CPU
faultback, but dmirror_interval_invalidate() skips the notification for
every open on the same device. The faulting open clears only its own
XArray entry. The other open can read or write the backing page after
migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
and stale data through the second open.

Handle migration invalidation for every mirror under its mutex. This
clears pointers before faultback can free the backing pages and waits
for an active mirror read or write. During system-to-device migration,
the migrating open installs new entries after migration; other opens
refault on their next access. Remove the now redundant XArray erase
from the faultback copy loop.

Extend the PMD migration selftest to read its last device-private
subpage through a second open, then fault it back to RAM, change it,
and read the new value through that open. The trigger is available to
a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
enabled; it does not depend on physical GPU hardware.

[akpm@linux-foundation.org: fix device-private backing subpage selection]
Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org
Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-reply@b4
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Aveline Noir <jm5905938@gmail.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>

 lib/test_hmm.c                         |   20 +++++++-----------
 tools/testing/selftests/mm/hmm-tests.c |   25 +++++++++++++++++++++++
 2 files changed, 33 insertions(+), 12 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
+++ a/lib/test_hmm.c
@@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
 		page = hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
 
+		if (is_device_private_page(page)) {
+			struct folio *folio = page_folio(page);
+			struct page *backing = BACKING_PAGE(&folio->page);
+
+			page = backing + folio_page_idx(folio, page);
+		}
 		entry = page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
@@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
 {
 	struct dmirror *dmirror = container_of(mni, struct dmirror, notifier);
 
-	/*
-	 * Ignore invalidation callbacks for device private pages since
-	 * the invalidation is handled as part of the migration process.
-	 */
-	if (range->event == MMU_NOTIFY_MIGRATE &&
-	    range->owner == dmirror->mdevice)
-		return true;
-
 	if (mmu_notifier_range_blockable(range))
 		mutex_lock(&dmirror->mutex);
 	else if (!mutex_trylock(&dmirror->mutex))
@@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
 
 			src_page = pfn_to_page(page_to_pfn(spage) + i);
 
-			xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
 			addr += PAGE_SIZE;
 			copy_highpage(dst_page, src_page);
 		}
@@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
 	}
 	migrate_vma_pages(&args);
 	/*
-	 * No device finalize step is needed since
-	 * dmirror_devmem_fault_alloc_and_copy() will have already
-	 * invalidated the device page table.
+	 * The migration notifier has invalidated all mirror page tables
+	 * before the backing pages can be freed.
 	 */
 	migrate_vma_finalize(&args);
 err:
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-mirrors-on-device-private-migration
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 = -1;
 	int *ptr;
 	int ret;
 
@@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
 
 		close(pagemap_fd);
+
+		/* Read a device-private subpage through another open. */
+		fd2 = hmm_open(variant->device_number);
+		ASSERT_GE(fd2, 0);
+		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
+		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr = map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(*(int *)buffer->mirror,
+			  (npages - 1) * self->page_size / sizeof(int));
 	}
 
 	/* Fault pages back to system memory and check them. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
+	if (fd2 >= 0) {
+		/* This open must not retain the freed device backing page. */
+		ptr[(npages - 1) * self->page_size / sizeof(*ptr)] = -1;
+		buffer->ptr = (char *)map + (npages - 1) * self->page_size;
+		ret = hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr = map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(buffer->faults, 1);
+		ASSERT_EQ(*(int *)buffer->mirror, -1);
+		ASSERT_EQ(close(fd2), 0);
+	}
+
 	buffer->ptr = old_ptr;
 	hmm_buffer_free(buffer);
 }
_

