Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C43BCD6E4A
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 08:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62966B008A; Sat, 30 May 2026 04:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A6B6B0092; Sat, 30 May 2026 04:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78186B0093; Sat, 30 May 2026 04:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C83B86B008A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 04:54:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5ABF3161742
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:54:47 +0000 (UTC)
X-FDA: 84823475814.07.D0E5E51
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC5FA40006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:54:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J7vXrRCj;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131285; a=rsa-sha256;
	cv=none;
	b=UJ2/nCxlUwGhs6UIQ2UnztFHdDxCrSCOfRbgXoY1lrpb4dY8exrs66KWhqakgtkVeTpS3t
	3jp7O3Si/J8iaKwxWESRC6y+bkg+Zk4nml9xbKnevmg0gLqVXAf7E18An8o7csySwfCmkl
	BSQ6RDhB521dWF0fkAGfAYtMuvS9O28=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J7vXrRCj;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV/ZWQ3rF4MvdlVmTGBF+4W5wBX8ACeXUvMu6sa5XYo=;
	b=Oc761akwaZdywVXSUP7Afn8whuit6GmHTYE253q8MfO9i3GJITpKgfg6CKmgDsKFIkJsoT
	qOxFsanvXBo5RDGB10YEmTrS49L1Pb7FL4rAApzeHVLXxu5IM/5yHyLjNfqIy7TG7ixQ3c
	F8Eja9Lz2EUgQd+7hU3HTkCpL05cqhw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A27CF3515;
	Sat, 30 May 2026 01:54:38 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 443803F632;
	Sat, 30 May 2026 01:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780131283; bh=4cZov+A3y+NozKLYxMCn9IIRmUK0h0TSROhccA5wsa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7vXrRCjeTz2K4K0t8Fb3OQAuJPDHX31KDGsmxXofYv0yvYJf/qvZ2wnpRROnnaYP
	 e04nFWjsRPDSwCg1cDKvzlSgwdatl7o2A8PHdvJc0b/SICzm4S0K6Wp56KYICONENR
	 zMn57gcJqiGle9dAxIDEtfCYkzdGByEtp95V17l0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	david@kernel.org,
	shuah@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	usama.arif@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries
Date: Sat, 30 May 2026 08:54:12 +0000
Message-ID: <20260530085413.1270139-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260530085413.1270139-1-dev.jain@arm.com>
References: <20260530085413.1270139-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AC5FA40006
X-Rspamd-Server: rspam03
X-Stat-Signature: coyadr6nrkwdozq91zpdn59ja4a4pmxb
X-HE-Tag: 1780131285-507720
X-HE-Meta: U2FsdGVkX1/kliJdzh0rkMDkHYjjK7+XqgdLpu8MsqRuoikfBkwUk/BvRf3kBLdLnzQ13GgUGASrrHJoh6fkIHK5kuDma/+W+T793i649bkxVtTbq29gS4N2OLUXUCht6xbvLf/QuH47MoFa61IEzz3PRLeJz8cDwIY1k6n5KhibLpWNgeGcZ/W8DxyPPdtZiksGtJv9J35AeK1pBKHPCAhRqyuUkQqGiBZjec34C2P9SNANknliVYapbYFpJ+bCfpXulCPM4kQ+Xy6i5IoskiTj2BIr50yJZohiFYGAjr3P3ricVRWDfYl78KyPEUPqcJ7YUmcvqOy4zegRQcj9EllSQ6i275eJtp/dwgmWGUvQ66clpdzjd1A9xu1Z0rTjdqJ3QSliqoakQkofDKIQuSlOIEZYQWM1Qdyg+TYrEtw/JGPcven/UAjSATuMfxD47DUbsBRRkqrzPVZmKSv1rRuy5K1q61IWTKi7dsZWrCBCSTYVEfEGIVIlIzlKQ98WhIkoKsKQSI0VmNVzIo1MnlyAKQA/qS059r526Nn9/YE8adqQZWKN7lOmCrONkLwigTl3sRcYvPmmMXNx4JodnW9jH+L+WZNkY4MeMW7XpoEEmSsiy9QqjcmmS1BhQ8p3ZMB44pn0JNbXsSgfRmOpPaxiXT4AXQ1rtgIwR8DLY6eOyHZpEXPkXhP9z1oHw+IfMH1C1SDri1C4LAZPHFc5tcgIlGBctGPNJoL4Qwz0ODnHezcmCkEk74HHxYPl9tRqjDTTWZ9w479L72loUGxlijXsx+/CYtFQA7KlApvoHjk+jEQo41q9P126epTy02OlCV6X+cocu6KB8GJynmDa0CL1OPTC6ew2irSHUkJTcaO1ZvdkW/S/ilksz1UPPz8QIUW8GRjbyhiqmVUw8CGsDVyjYSRcyq3SmRgBfVRktxrwajnjdemM7zi+3yiMt7wI/ZU8ADGpxBMOlo1J7hn
 Sbw1IFwq
 dZmMiShFwMm94JdJpRm9gs2ZMDjKs89J9MmVZzi6V/rUXW8WPvUGwW0XQus15cQ/9kORZSE57OAjVsHkcWxRY+ry5Zd5s6JEXn8KQ05T4yWUYSzvMx9wCA001odRsKCqU1wnwXmZ+IyECgNVkGm+lAG+SpeDDBwsCEQyxrCze74X/ZehdT3aonjikP0CtfRSo72XKzTGGUs92Uce1UZTyiDNc2OokbRwsEtraHjklDV4XjxKQh27DAJrNvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To cover pagemap paths scanning PMD entries, add assertions to check
whether a device-private PMD entry has the correct pagemap information -
the PM_SWAP bit must be on in the pagemap entry. Before that, we must
assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
at PMD level and not PTE level.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e1c8a679a4cf3..d09d4a9081de1 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	unsigned long npages;
 	unsigned long size;
 	unsigned long i;
+	unsigned char *m;
+	uint64_t entry;
 	void *old_ptr;
 	void *map;
+	int pagemap_fd;
 	int *ptr;
 	int ret;
 
@@ -2318,6 +2321,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
 
+	if (!hmm_is_coherent_type(variant->device_number)) {
+		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
+				      buffer, npages);
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, npages);
+
+		m = buffer->mirror;
+		for (i = 0; i < npages; ++i)
+			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
+					HMM_DMIRROR_PROT_WRITE |
+					HMM_DMIRROR_PROT_PMD);
+
+		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+		ASSERT_GE(pagemap_fd, 0);
+
+		for (i = 0; i < npages; ++i) {
+			entry = pagemap_get_entry(pagemap_fd,
+					(char *)buffer->ptr + i * self->page_size);
+
+			ASSERT_NE(entry & PM_SWAP, 0);
+			ASSERT_EQ(entry & PM_PRESENT, 0);
+		}
+
+		close(pagemap_fd);
+	}
+
 	/* Fault pages back to system memory and check them. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
-- 
2.43.0


