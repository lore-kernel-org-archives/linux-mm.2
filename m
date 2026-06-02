Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64940CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13ACD6B0095; Tue,  2 Jun 2026 17:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC486B0096; Tue,  2 Jun 2026 17:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59DE6B0098; Tue,  2 Jun 2026 17:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C33516B0095
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EE1D8B304
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:13 +0000 (UTC)
X-FDA: 84836331426.11.F15A320
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id A7ED340007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pvHcXVgG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3elEfagYKCPEprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3elEfagYKCPEprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVk9IZSmeQ2ojFO9YakU9Uvjo4C4aXJx9fyWGDEUtbc=;
	b=S8Fd782pipvDx+y8o9EyDlPAyk9ILWI0uZgBHRDi03XohnNFZ5o69mHTES2HKOFwZlVUW4
	8LVfRgBCqdMGfwKAqUYGXzu/06IPYMU47hKI0owr1ltkFSgQz50aOnVuJcgf3gkPEQDFk2
	TgE4prTUm00U3ddpOeQN7v2ZGL3zZpk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pvHcXVgG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3elEfagYKCPEprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3elEfagYKCPEprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437371;
	b=OjZYWlehzw3MomJb9vJ0I3TM8EvBkrxuRJ+EDQ1oys4rgcT6dUtME0qnFuZHR7O3u7Ya8/
	Br1INDx9TkOv+vmfo0z3Ymdm8537Gv46M0S/NydWqDwlQONZgGjQs9pjDGobMAzhxG0wbQ
	AG1gWDU6Od1rOdMn9vwufPkCIBfX/aE=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8423efdbe6fso597132b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437370; x=1781042170; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PVk9IZSmeQ2ojFO9YakU9Uvjo4C4aXJx9fyWGDEUtbc=;
        b=pvHcXVgGdykFhuuECKkyOo004f8uGb6T51MvfObCcc8KFYYcORX0566Q6TQHWFIjPI
         2hyYp9AaXIO4WPsrDOmqo+W4qGoH35d2nGEwHv7fO1AHt55zl6YQMHFEW1YtiY+oSr06
         VwkXCxVD1uj0jSeliErRsJ0HLIRy2vELJIx4fmvERKAX42AMrwCjQgjpdj+46edbUQU3
         F0Y3SxPnjCLDl7Pyugi6walb8uSOMKeTl5qTlRKz23qmyBxW4viHsQcuK1oK8X+fx3jK
         GddcW+dHoBxHrrUK46b59ql3L7A5McJO3VYUdgHcJHXWCGuCpAF1Wr7izsNpZUBk3ebv
         9TbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437370; x=1781042170;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PVk9IZSmeQ2ojFO9YakU9Uvjo4C4aXJx9fyWGDEUtbc=;
        b=mypuOHpCGpeYN3/nQTBcMCLft9DNzvmUk1m1qFKQVXThJmP7SdX5BNwKSQOFau8ST0
         MtNqAZ/S0gY1ZmGCn7IhckVsJUvvZPcHCo5MigAOvl2W5z4ZnMhl5krVbs+Pvjgh2Ev7
         vUrcWPrR+RwlIhkcwyPrHeC5xtKrjwis7FWHr/DH5R2Sy+2hYwuG9M7OIJAGgllWfM18
         TrsHxZaFAnmNqGDFUV0fyXkbk7qJnqKZa67PCYZ52bZxPFzzbrd7VPBCW4ST5q+kYWWU
         59IL8wTnTF2V0l4A2HL8e1/ZLNFe2TrzcE5FSVhVOv8oaGWsdd9WCbJ39LU1Afzvrvbm
         neuA==
X-Forwarded-Encrypted: i=1; AFNElJ8kDEEmEao2NGe0KfrfMiTb4k7ZTxdqUn7LqOkK7b41XZOWZOfM5FgjKweQAAFC3KXbMASKWgZfzg==@kvack.org
X-Gm-Message-State: AOJu0Yx+Oa6jurmKz44zt3d7fLKYgxG/HtgctyT1ozHbkZ1bBRS9tS9a
	1tHt/F7aNLrIaqu3lt21A9rZeqfynB1bjBO/th4cGbh2opubEv+Ek5Dh7WETeg0s00h+4HK7jul
	qvAErQQ==
X-Received: from pfih3.prod.google.com ([2002:a05:6a00:2183:b0:842:2674:ba4e])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4aca:b0:842:6e9f:9d3
 with SMTP id d2e1a72fcca58-84284f61a4cmr515894b3a.43.1780437370305; Tue, 02
 Jun 2026 14:56:10 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:45 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=5052;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=ERS9n/C66Pu/CFQvxwGbdMovjGhnOPXiuO/oE3uJErA=; b=gl04QDueWfY5Mz/UMSTqZqEfqFAcCz8GPZv3rivd+R/DZnODOzzs+ShfEwjBLFL8XbbcCoOEl
 EknEUQ6a+G2AsmhRcocPCnKsgzKYa/SK4ZFwcl1YJ+i0YPAHx/u9JBc
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-5-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 5/7] mm: selftests: Add shmem into memory failure test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: A7ED340007
X-Rspam-User: 
X-Stat-Signature: nswchpihqmdyy9heizqm5yoomc4qi4eo
X-Rspamd-Server: rspam09
X-HE-Tag: 1780437371-194851
X-HE-Meta: U2FsdGVkX1/ISLs36EDwbDkYH1VWb9TEo2FpVVE2xi/4BPqWMlP2KLyM1+9dirFlEZUsVWAa+9+aX9lJY4zLruySdmASOAX0JGcZcMP5CmFTEBVSQS5w1VgIKhFZ9iMjFH7yYUVj07Ypw2RVbPWQ64f4xioBbSemB4KwGbHmq+4e9y6WNpeH3pbHRm1xS7XF4X6LbcnoJ/wMLbTF5QUNnHIjrw78djPM6IJ/pOlQdAccA3Um6dpq/uHI6taVBRcKMFd4JC+gJgz6+UuX3zkYcILQtTTAZquXsYAmz0Br4+vy70OrZCxqlt9KbSpCsHXK1k10unC2r20xk3cqZpfst5EchIogIDML5zFN6cG1/nA9KDMh/PTtmkVv7JwYOUl71jJFTwFk0mCPDtF9MbpGPPlZd2N93sr6a/+w1RAR3BUp9q6hT5b7gWif2rmFtaICk1bLlyua7WTxMkrp1+nUnyx2knJyNJ5OFP87yjsux3UL6T6McSVxM7DeFtXU5UtCuTLFoS7UKI3ym3poVGHve+Lrpaj5p7slB1WFLeKcuq89599gO8qLHE4vGLD1VAYP3ih6AlTfmXVfIHQf9qncgairM4uB4JyJntyaYYXG34ExA88nCCXRKtBpX1vvG3Nx7pzymZGS+JSpy89MuO+8CD/44eZ78HkbAg/eLEWY58vAkC4KZwgGuCIlQyDy7ALvnhPZGaf7aiuY4MJXGBH5PZtpwx2CMDDEWXln18y2W/oqtjVgVUtdTwrGpkThfsgNU3qnl/eI3TRZSfK+jgDPHf5kZLOWG3+/p2A3+dbTEL+TDPwneBMj8ZA7RarrvOn/RZ9A+GJN35MJrMtTMwZKXJzpnP4U3fcfBwHQKDwhEztYXP2wdk0PwJdZ9PiEiTUxQBahkOcoH3Qmk4VYJSRpFLmesUotUIzTk/2+n5DYKhRRDiSI86EfzlNYTPp2xXZezw0KNEwjpANLrVffYFt
 dKmvIGYe
 6IrlH/WX4B4kEJ5P0CxpuEuneLNnkDPyG5qXOZBAWMSmT5P1aixGjS5U9ZLENYN0Psj4mJDYcookUdjpdA4k6hAcy64zvuG/wwN4b+Fw95+eDZzi6rwBjO0EOZZt/AjwafHY2r3vg+7q3EvgjHKBJa676qA+dMAkq4aIXZJM+2Urr372ta6ILojI+XhDGcN2NbeTo7qtjTHX4RhGbnz1WnapkB/2xUmq8N7mBPFxmVdGHD6RK7o7Cx72ENhf2RiWpSbPwymAiFSaHxfdiSLmgGHoKeX3GBGi+pDZIH+umrxc5sL8lcJv+GxG9GDDdBbdoIkQ/Zo9oF8v/OayYpl4Pa15dCh9RgWQhv/44RnIAKPVFZYgdZW0nFoTAY1lsiOEbc6goCbxyTxqFCRPOPT6O8oiy7UgLmvlJnGi1lloBQoI/gxbo46tSEuD21vpTRSpNxwB0ZM9SN9m8CPrdXHHxpmQf08RwVk0vE9hOI95cOTydR5zS6BWnohmDEkdWjJMIYSGiTVcdrqBvzDVys8khkk3gwVeyIVtzCAKQaobfIdE8EAPB05KNX/xshZXsJ0qFU+2cupW4KUjXQmh9IaqpKx6sdHjjmk6GmaN7zLaCcydGYt4pxOhH76u9ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shmem memory failure selftest to test the shmem memory failure is
correct after modifying shmem return value.

Specifically, test the expected behavior under various scenarios
combining page dirtiness (dirty vs clean) and failure types (hard vs
soft):
+ Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
  SIGBUS when reading the page again.
+ Dirty + Soft: No SIGBUS is triggered, and the original value can be
  read successfully.
+ Clean + Hard: No SIGBUS is triggered on injection, but trigger a
  SIGBUS when trying to read the page again.
+ Clean + Soft: No SIGBUS is triggered, and the page can be read
  successfully.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 111 +++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 3d9e0b9ffb41..43949b3b3565 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -30,9 +30,14 @@ enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
+	MADV_HARD_CLEAN_SHMEM,
+	MADV_HARD_DIRTY_SHMEM,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
 	MADV_SOFT_DIRTY_PAGECACHE,
+	MADV_SOFT_CLEAN_SHMEM,
+	MADV_SOFT_DIRTY_SHMEM,
+	READ_ERROR,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -165,17 +170,21 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
 	case MADV_SOFT_DIRTY_PAGECACHE:
-		/* It is not expected to receive a SIGBUS signal. */
-		ASSERT_EQ(setjmp, 0);
-
+	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
+	case MADV_HARD_CLEAN_SHMEM:
+	case MADV_SOFT_CLEAN_SHMEM:
+		/* It is not expected to receive a SIGBUS signal. */
+		ASSERT_EQ(setjmp, 0);
 
 		/* The backing pfn of addr should have changed. */
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
 	case MADV_HARD_DIRTY_PAGECACHE:
+	case MADV_HARD_DIRTY_SHMEM:
+	case READ_ERROR:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -260,6 +269,20 @@ static int prepare_file(const char *fname, unsigned long size)
 	return fd;
 }
 
+static int prepare_shmem(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = memfd_create(fname, 0);
+	if (fd < 0)
+		return -1;
+	if (ftruncate(fd, size) < 0) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
 /* Borrowed from mm/gup_longterm.c. */
 static int get_fs_type(int fd)
 {
@@ -356,4 +379,86 @@ TEST_F(memory_failure, dirty_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (ret == 0)
+		ASSERT_EQ(variant->inject(self, addr), 0);
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+	cleanup(_metadata, self, addr);
+}
+
+TEST_F(memory_failure, clean_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	FORCE_READ(*addr);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (ret == 0)
+		ASSERT_EQ(variant->inject(self, addr), 0);
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_CLEAN_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		/* Test the address accessability without check_memory(). */
+		FORCE_READ(*addr);
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+	cleanup(_metadata, self, addr);
+}
+
 TEST_HARNESS_MAIN

-- 
2.54.0.1013.g208068f2d8-goog


