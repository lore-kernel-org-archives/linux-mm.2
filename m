Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88630C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFBB6B00DD; Fri, 17 Jul 2026 14:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B71A6B00DF; Fri, 17 Jul 2026 14:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD4B6B00E0; Fri, 17 Jul 2026 14:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE5D6B00DD
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:24:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7D658022E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:24:23 +0000 (UTC)
X-FDA: 84999093606.18.AE7E329
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D356100008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:24:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FJMX7hxD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlBBcS3yoy86Hd8Tk6gkvICDLvh7sVRSb6A5C2ruF/k=;
	b=xLq9phICsxNT8Ld5u0Qy5SI4PR3dvcbhGNdeTc6nvlhTzv++9sS6kREHyipK9SbOJGhCTU
	zKh/hIGAuG0GCnp2ISHB6CwE5sS5hTRN917AFezaGyLFvOJCED8qawgEPCVQjqWu309uka
	mWoSRL9nA6ZPDi84jffGSWc8s1NXFWg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FJMX7hxD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312662;
	b=CDdu7gr2z5sROZimIBcqzLn1QxSuak14peBcFVdi0L2SCFUW7ADdVFrDWUzPEh5QKdOlaL
	T0vhIM5w33vgxTOQoR8L9BqiLohekcLr3LrukjSO1ptnt/g7YD/srgTykKHBM9y97xdhQ2
	cB1ooY7JWfW0k+KHwlNUDt7s3JxBqRs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D137600DA;
	Fri, 17 Jul 2026 18:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D501F00A3A;
	Fri, 17 Jul 2026 18:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312661;
	bh=HlBBcS3yoy86Hd8Tk6gkvICDLvh7sVRSb6A5C2ruF/k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FJMX7hxDC041A9zZr9hhXc4BMh6S0gtjj56+ThInE05IAekRkJBz1uxfru/bZbJL+
	 UT5kerNVwDA7zM63We4ymno/jVhzefiBRhPCgsvS6otAaNI/xEYowngkTmylTPVsY3
	 ybLLX8thyqHcCh3+kJ+7xCKR2dSGJKQmSoVmvk/iCVbPQ7L619ffw+2yn4N4ffWtAD
	 lq+lBaIaqDSOHIqdmYbEDWt3qT5aRZQ+fqezWb0azl2zNcEwpJYm6v1NQuP41RNWz/
	 b0ARS/VR+cVKjktU62J5KKwpDcyDYcDXxH78WJEHctdiHDCLJuTR4ArPI82rU6sN5S
	 ibsabnGCRIoJA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:52 +0100
Subject: [PATCH 14/15] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-14-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2619; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2PKWXL01QnSXKidEY/TWtRsvAkg/KT5p1XRORzualh4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivaF7IjUzTZd3XfC3aN2vYhS7cr2B8qdptqW3r23v
 fnf+vV1lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCLG3Az/LPXZ3P5eXiq39NLa
 Cot3zRKZGkZTX14vNb+iUfb4D4dWESPD2gB2S1tZzeD9S6ykq0/mnY6dEjT1hNRX3Z2Sotv5lJ5
 yAwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 7a678pjzt5f8gnc44djf4thr8u9uh157
X-Rspamd-Queue-Id: 0D356100008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784312661-512461
X-HE-Meta: U2FsdGVkX19ObV7TwPk35cV0H4HkIBllddFnKG1eO+H7jlcfoq2enqu+lCQyWjXYCkuxztI1BdtGwiOtmkNaIfLYcm2m1MeqOaB8YOMIW4FN8B/dI3iEGT+iRMOxaL6jird3hSYgbFdR9hnfmrmibPC9+d3SWTGe795zVrLCXHw+7ebCFXFl7R6PyjT//DEeStB7CSpL1cLKVqd/HDwV6/dMPA0lkfiuu+OeMxYyJUufH1W50JSP+OqAqgTPN21FNRoAXgLGY5C3gczPheh2Rm259vmd9GhnXe9OSqZ82V5gDT0WCRmLCKhA7y4ouIi3cRY6HRH8g/MysGN4mocBKwn8I9DXeLebuk/rfjo08SGvikDe81zW9DhfoD6OB0vo/wPfg+4w8AftFgCG4jXFFREdAPl2MBTNX91pLUkvkhEFr7LBLW5fDo3rqCbXr0VUHJV47q8pln/w/XlmI/nu6VvdrUaMY8H4UF/187poBu8c3lhihL3EFHvLvMQ7LMiO/T/b0ZnpQ0GXKqZwJB3VeSgFkEVU2ADWSDQgHEzIxjRGFrN/rD8PfRmgLvxx5ku+29bCLzjGGDKANVp3S2lsHuSJBQLrybqAS7YyIU4T2R72xBMYZcyFeoKhv0b81Uh/kWcobKfqwk+jzoqR50AC0wNY96GxbnCuHTEXfO+yTWBzJCZhLCDUY4W65ngBa3dDBvu2ZKk6wQxeOUh/TyFHnO3rVxNiTs5jFYTuLRppAjI01kr4imLY3pCB0V3s6E3EgZ6F+p2imIoxRTh4jq8nB6npcnlNEQi3ILcJ4bajpA7F7MYMyOrTio3kNSkn+/k8Wb5yELhnY7IMOo7/h1RrCr0STurRxQhhyjWKu+GmpVGBkcEd/FzkhhAbpDvpIQweAqVqxLdXl0NqFyCNWTclM9gi1UGFyd+pcnxEbGjjM97EiIAWtKRpXThwaEnn69FmdeFo3o7eMNDEToqAZYl
 Limuw6uV
 juHvQXD0UI93ijLRScd81x0QO0OgKBQv4MddrmUJ/9FBfGCrKhRQbh1KKNXWdOG2i97gojIkAcIHn/GSctiQKhfH+fzRNfwl2gLwjHhCJODGnv7Ua8Rcc06c+XItc302jIlfkbreNWOwIP1IADaVMrQjfIjJdGmITIrmRr/bUBLPCHe21DjTmRUsnqdVfHXbAJxE9K1xFChtdny9xO6AKXIN/sXyiWtZMx1UaAn9DyIh2Qy7c5hNpS13k+lG4FjdFU6ZNfXaThL5Avsj/18NzPD7USxjAjwrQB5LdyJxPThJYr2jclY8ufJcn79y69MsnFbpDP9ZEF73eRVmda/S0vkMgC4D7hV4+PFlfydvstQzGWGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add a
VMA userland test to assert that this is the case and everything is as
we would expect for an anonymous mapping.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/include/dup.h |  1 +
 tools/testing/vma/tests/mmap.c  | 49 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 93049241b297..b4f0f7c24fcb 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -20,6 +20,7 @@ struct task_struct *get_current(void);
 
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
 
 #define MEM_MAJOR		1
 #define DEVZERO_MINOR	5
diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..0c8a3446b905 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,56 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static int dummy_mmap_prepare(struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	const struct file_operations f_op = {
+		.mmap_prepare = dummy_mmap_prepare,
+	};
+	struct inode inode = {
+		.i_rdev = MKDEV(MEM_MAJOR, DEVZERO_MINOR),
+	};
+	struct file file = {
+		.f_inode = &inode,
+		.f_op = &f_op,
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
+	 * offset of 0x10, which we expect to be reset to the virtual page
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
+	/* Expect virtual page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0x300);
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


