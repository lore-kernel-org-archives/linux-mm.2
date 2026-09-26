Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421F2C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7306B0099; Sat, 26 Sep 2026 06:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABA76B009B; Sat, 26 Sep 2026 06:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376D26B009D; Sat, 26 Sep 2026 06:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158CB6B0099
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99BD54082D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:48 +0000 (UTC)
X-FDA: 85255572696.04.DA8EBC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D5E8720004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOsVDr1l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419306;
	b=IRgkGfaCHc6XfAUfm2MRDpuAGoIJdGQXxLT/4ZnrjYz1rfM8Ig7RV0GQzmfaCAHszXTxvG
	Lk/qjWU/N8ic9vb83dYGYTmINWncMQTodg6uIzM+D+RkpteubIGp39MC+R55+hg8SlEiId
	qfftUhZ5QA0XW1Ak10UgG1RF8/vw3vo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOsVDr1l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7INaOtP/gm2Q0CwFqGyhMMm+FXe4/enBYyOAMoEMKqg=;
	b=7S7XXctTJTYqey2LHZ5itf+wJ0rIL+/9j15PCk6wOgnx+wBW6UMfdn8XtJgfeax3pctAwA
	XwE5XnCpPNoNRN0FBIeLqjI9VAwbKzG0G3/NLs/SOIdJcKc6rND4hMsQ7dytmKTdhOeMyX
	v0MuvVkVMkACGuLw51fBwcFV1z4W/4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3126C405DA;
	Sat, 26 Sep 2026 10:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFB01F000FF;
	Sat, 26 Sep 2026 10:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419306;
	bh=7INaOtP/gm2Q0CwFqGyhMMm+FXe4/enBYyOAMoEMKqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FOsVDr1lPbdLbth/FdBj5KzXf0oIdA6hCu9mLssK1wFzaBK7SOzL2rFrbZQ8bHdFb
	 +NRHHqxQudc2nRYJ1z6B2okgHcmH3Qa8RHn2nNuv+gzZORsamL5057k+nLTZvMks2H
	 CQvk+OGjt0XOPqUwSaY/SaIaxC2RNRJyuugqLkgdUKOT1BZgeVZNC79AGrl60NU85U
	 xozIGYhzxWRg56hAQEfbIaBWA8PZWVor0VpmS3L4B8+Dgbs2ThIn5DOPdbqsDUpJjy
	 zWbmPHl6dHArcrZuIrxNf4gxZ1w0140QygSC+R/wcRCO2cVNCT7sZ/FMNZYhQh2lCs
	 5YMpWKbsnVYSQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 26 Sep 2026 11:41:10 +0100
Subject: [PATCH v3 5/6] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-map-private-dev-zero-v3-5-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1881; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MuW0MgECKFqsgKYanDvHZ2zzAEiQ7iCtWQ9chN/jOZY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/ThnMwp/NdRf3l60KLN0u0+J8QnJbIkff2y9ehr/
 qNu7dLdHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIzXiG/9nudyI6qi5MLnc9
 UZecrdL263/01u7jldNfqDkUzHU8uIWR4WzMwkTmt7nexn/yZ6asiFzVbydhudHvRFBUX8SlTav
 FOQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: ybotapih9bi7z1gr88s95n1j9hjab5hn
X-Rspam-User: 
X-Rspamd-Queue-Id: D5E8720004
X-HE-Tag: 1790419306-984557
X-HE-Meta: U2FsdGVkX19qhfNxOhbwe69aeElc6VQ8V8wohlbrPUFQJqZfcrGSulD8wkCrP6H5oupsE6Fb9pLbIi6JRnmgWxUxSOaX/HMiFoMom37vHFHJqtBvaBxD8wHqzjEGDaRsTgApqkG+nVyQcIL4sDLKporyeN2PbMMKtHfcZozL2sVMiXYGgc/odeH3elU1+PA44Ic+Uq9RhAItcsUdTbr6fBsqtwD89lKt7EUXWMNMKznQlqAsgvfEcg2UViuFlJFep5V0wK0BTfv/p+I3pv51QtLWuDEZyEr0Lrg8ilSniL5VDReXOkw49VPigXXMnk6P9Vtx6gYPDTA2TT76MPlkF8S7e2wCZdAtKTjjZJZ87FWR0YuZOQ7lZ1RONfzS3IWRY06YSBx2LJI3UfF+S17Z9W9aafSQbV/avbyQUlxXCZGDZNCGhMY+DfaKq94naTb7Dn9U3JyCcpq3pg/uhlYEAXPFTwNw9qYrflf4K8jUdCXf/gjpA9dfsjzWHxIhQmu9HPzb526m7x+EpNrmotVhwvjsSgFY2emO8DP0CXGkgTmcF0TuPuBBYcmqsGVA5xn44Tf2kitIuK8eXmthCLANnEdJa9DFdgBavYfNz/hgusA67rM2wG7K2CW/0NSMJJ5rr1j598zWOqBPj4VFTfp2c4iPPdRyxJ3OhozL9Vs1jQ/iS8KdB1QLx46PAXTvDrXUk97ulyZ9cLmexy3j9i/kqGCmkmk+j1fm/Jq0EJuucnPTlUKHgyXv+gSA5qLJgitjYL5WBJ3trLhoAr9XAJ2sREN6373oFw9bDLijiasBWPG7pxmKlASgsZzjxwgtfM4oZEweu8GD2E7FLrADMULHMTI8Q9/jsMbMhpjqr5tHRQqSTwGgFUVTEmGUiPZq4loXtrgdOpdq0kTi9qlnsjCKCB1SDUGyjr7rsN4EfeLHumdGZCGIlok+PLNc5vHzCNcVXG/O0J4sgt/H9DN7bBH
 L1kFNBqG
 10x1Xc4ITlZwIMDmPeJdK5vZCWqaD2q4WP0NDYzfK2XVtD0XSIsd8hQVPrH+/nZjourZJIGL2x7sVk0HrdkX6ooVLQq19+dWIRwVWmWO3C+5Pj7dk5ldBOb0gCNaskagovPsRwH/TywmoNnX1eHcxmzMPlTyuSs1YhV+zLdtyQcFTXwNbUal92KNpwYee2c7S5tnBmUjfg/GUtx8YVu3rA33/gvQ2ExrDlKoSTbUX6I1yOIAYO6chabWN1t9Cgh2jskxOs72MTrj0/Mq10YQdUUQOYVb1wzFB6mSX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add a
VMA userland test to assert that this is the case and everything is as we
would expect for an anonymous mapping.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/mmap.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..fa73faff2262 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,44 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	struct file file = {
+		.f_op = &zero_fops,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the anonymous page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }

-- 
2.55.0


