Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B28606E953
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IYmCQ62v
Received: by kanga.kvack.org (Postfix)
	id CF65A6B05B6; Thu, 12 Nov 2026 12:38:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD986B05C2; Thu, 12 Nov 2026 12:38:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0A9A6B05C3; Thu, 12 Nov 2026 12:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AECD6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:38:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E32CA1205AB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:38:39 +0000 (UTC)
X-FDA: 85427176758.30.CFC79DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EC139C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:38:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYmCQ62v;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794505118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6FLvIP+02fU3D3EgmUsZmg/BxYUoYrdtHX2qDoNfAQg=;
	b=sh/kcLu8KuK/Bez4x7JfTLsljeZxt/MV3B98fVBbw0cdTGaCo/igcri2wYlPqLLxRABwtN
	uoE2SfAKhRQwnedR+kDF3rhRaazzYZFbgZIKaU7CRfXSruog4PJSWEN0s/r3FjCJ0KTR7A
	uo7ZLFPe0mHiGwfLKNTNNZi8XDOnC/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794505118;
	b=DbazMOFWSBZenho2ZI4f9qIlLb5ywHD4zj4peUds/dCPfRFVC3zEW0PMvaydNddpiNkRe3
	sl51EGkgnBIf7XHzgm4oky0mqyiPzAlmbJamaZOCNfwqJY5iHiuXSmzKoaR4g1x1kyLdBv
	vPnn/TZtOv44/5hXptXaOEOWivpjQR4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYmCQ62v;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BA6F6126A;
	Thu, 12 Nov 2026 17:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17701F000C5;
	Thu, 12 Nov 2026 17:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794505117;
	bh=6FLvIP+02fU3D3EgmUsZmg/BxYUoYrdtHX2qDoNfAQg=;
	h=From:Date:Subject:To:Cc;
	b=IYmCQ62vcyGAlECdg2yNK4EBmQ0N2pVumUcV+aM8yemIWDbalFnkxINv12qk8EsCm
	 LgPnQ/WxzTcQoGOFK9ksV2JZdhoqvx21bldoapI3zR9oQzQ8gqriMC9Afykl2JaaUK
	 jlOzqpPJVwOeHTBYtPSSp9mqgvvH/p9U4Tg2KeWVK6rh/AJiqhQEWsfLVfPA1zHyaB
	 o5tjUIGuXWI+ZVn+GMrBbFB6aK8LzUA5J4bkNU5QI5ikb51kDhNWGL+NiLEpqX1EIx
	 ybWd+krBH9eoKS3LZboAMPfFMiBbO6Wg8fPz2l04Ah7bdih/etLOjcTQ0dSAt/WOkZ
	 OR2qr0jQPr5Qw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 12 Nov 2026 17:38:26 +0000
Subject: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQrCQAxA0auUrA00QS3tVcRFNJkaKNMysVUov
 buDy/cXf4ew4hYwNDsU2zx8zhV0auD5kjwaulYDt3wlIkb1kGmaP7impDiuUhQ9x7tGlAv3Z+J
 etHtAPSzFkn//99v9OH48gYlIbQAAAA==
X-Change-ID: 20261112-disallow-uffd-guard-install-a5294129ad7b
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, ljs@kernel.org, 
 Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4426; i=ljs@kernel.org;
 h=from:subject:message-id; bh=z0lXvuNFITlSBw/W7A69EZHiCMx/P/HmR1ujagLOP60=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+/py565nBh+S5gr8zV/1c4aC3+OoVrrXfg9817//ze
 I0jR+qK9x2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYyMJ0hr8SQRty4qT8WP2m
 nBLcfaZhwp5jfxYmepQwbeMtWWFQ4byBkWHGb7PzTYtM2JpCH2Wk37RKXKBtu+b6lrPyp1csdWi
 /z80FAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ozmq65q1tadmch8h6f3gr37urofig7c1
X-Rspamd-Queue-Id: EC139C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794505117-98798
X-HE-Meta: U2FsdGVkX1+HYEWjchoMZwXPJ1BOOY8WcBf0EyAzQUi9BS51MWJXLyW4+9PZKN2o85/szGgdlTmGMBtk66mgETtAZ0LY5q6F6+yGVOLTbv4sglp+qLy6freDBpFGRSS4NQBhD2lsMkg8bvX5bxfjNxOsrTyvSI77p6SK25oOBDGsxeLkQOAfxiZ0h1UxHblEG3jw5sqNzaLqPLg5iqYRC88PyBUCOHP4U2kQ8A9Us2+MhjV2aRpE+X2Hpm7+CmsoCFcl1TO4TvCYI6hzn4abO2yge4jOaTe8a5Ei9el0Z2rVt0HCw313VtvLVaF4ofehEGPIPnJrME7PT73xswfmy9E/87ilddU/v5I8uXLXhgGgSsqI2Dl1/PS2p25u0sdDLSaKULUoxcYUfNSZUN4o4HmKF2B00o/t8txPe2GaqY8GpPIWanAmVkBI0vKHnAAsgDL4O5WJrIFLO7mGwuevvFchAM4jF8diMjuUiZ/LJ4ow89zySqKIjjbG0XmP77fq1e92R3DcAnYQ5UWBqRICu6OrFU9Hj5cnndkpo8lRqOCPwtt7W/QWfcMmP4kCjuYZ4T5lHsMDgEpMlD6j3qx6u4jT+90v8dLIRMqjvReoLdCkSoMoTXmBg5z+Rq2xCEY2Esf/72QgqE3y0dF30pBVGxszm8k3WSo7H7s/DKM2BfmQ8r5yHwuIagRd+ghwXKFi2bfVbO8Hki7fHLhTK/8zz4DtfFyAon/IAIAcVGSG3rQVzUKQtRsqRQzril3WYHR9oazln57qWKKHUtBGvej7n70RJo3gCjBpEdFd/gVkgB6cBnqaZm5HdRV0tzabVN5qBjxR6xzfgfnvR9vGES6M+q3tkwamQmUhomD0zxQMQSFRrS9CvDLrAZcl3e0xjyrrw0fHWBZUR+KoogpiQICVYaU8kMRefwi7FrO9V5nkhIGJ0TrX2Rf9uyV9MGvJkwvmAzVFyACvqeVV2GkagY3
 7yVLMnK2
 4XOvfMkxgXnNvLnjYtQJkZ6859e7Er6Ns88LnDrbjGLESchhi/6pfHmcJ9XySNvDaklX7yYZTHLeYN31Z9get1040DYntZivn30hWKXhA7xe3aNDJEThP51+xizfDbQsFa3GuMQNZwVF0XRfVrwVSztEmlp51PRNHYPryQ9dYw9zjKK3Vi3zo/Ohos5h2eewl8K53L+gOLzwvTtzkpIihJO1TTiUBH7+fv/AmBQUx3w43gMcVtpuGelAyHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In order to establish guard regions, guard markers are installed in the
page tables of a mapped VMA.

However, problems arise when one tries to combine this with registering a
VMA for userfaultfd, as such operations may themselves need to install page
table markers such as uffd-wp.

When this installation is attempted the guard marker prevents these markers
being applied, which can lead to unexpected results (especially if the
guard regions are later removed.)

This is especially problematic because guard region installation causes the
regions to be zapped first, meaning that the removal of userfaultfd-tracked
ranges will not be logged in this case.

Therefore, disallow this.

This makes sense as conceptually, guard regions mark a part of a VMA as
effectively unmapped at the page table level, and removing the markers is
like mapping the VMA again, over which operation uffd markers would in any
case be lost.

Only check for this on installation, as a VMA can be registered for
userfaultfd after guard regions are established.

In this case, the guard regions cannot have new markers installed, and no
faults can occur in the guard regions, until they are removed, at which
point everything should function normally.

A survey of open source users indicates nobody is relying on installing
guard regions in uffd-armed VMAs. Software including glibc, android,
tcmalloc and CRIU were checked.

Fix the selftest to reflect the change.

Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
Reported-by: Tal Zussman <tz2294@columbia.edu>
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c                               |  4 ++++
 tools/testing/selftests/mm/guard-regions.c | 12 ++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 0214efd2a014..268731e90f12 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1156,6 +1156,10 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
 		return -EINVAL;
 
+	/* Guard markers are incompatible with UFFD markers. */
+	if (userfaultfd_armed(vma))
+		return -EINVAL;
+
 	/*
 	 * Set atomically under read lock. All pertinent readers will need to
 	 * acquire an mmap/VMA write lock to read it. All remaining readers may
diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 02f69244f9a4..97da54dcf3a4 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -1476,7 +1476,7 @@ TEST_F(guard_regions, cold_pageout)
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }
 
-/* Ensure that guard pages do not break userfaultd. */
+/* Ensure that guard regions cannot be installed in uffd-armed VMAs. */
 TEST_F(guard_regions, uffd)
 {
 	const unsigned long page_size = self->page_size;
@@ -1526,10 +1526,15 @@ TEST_F(guard_regions, uffd)
 	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
 	ASSERT_EQ(ioctl(uffd, UFFDIO_REGISTER, &reg), 0);
 
-	/* Guard the range. This should not trigger the uffd. */
+	/* Now try to guard, should fail with EINVAL. */
+	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	/* Once unregistered, we should be able to guard the range. */
+	ASSERT_EQ(ioctl(uffd, UFFDIO_UNREGISTER, &range), 0);
 	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), 0);
 
-	/* The guarding should behave as usual with no uffd intervention. */
+	/* The guarding should behave as usual. */
 	for (i = 0; i < 10; i++) {
 		char *curr = &ptr[i * page_size];
 
@@ -1537,7 +1542,6 @@ TEST_F(guard_regions, uffd)
 	}
 
 	/* Cleanup. */
-	ASSERT_EQ(ioctl(uffd, UFFDIO_UNREGISTER, &range), 0);
 	close(uffd);
 	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
 }

---
base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
change-id: 20261112-disallow-uffd-guard-install-a5294129ad7b

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


