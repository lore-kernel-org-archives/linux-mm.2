Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF8BCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 16:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8FE6B00AE; Thu, 21 May 2026 12:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A1F6B00AF; Thu, 21 May 2026 12:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748DF6B00B0; Thu, 21 May 2026 12:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 639C96B00AE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:22:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D94B16136D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:08 +0000 (UTC)
X-FDA: 84791943936.28.263D22B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 743EE1A0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nqjZAVh3;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779380526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcfNGGjgx+NSZAuu90jBs3Qr8P55dHAXd7ftObLSo1w=;
	b=Vy/ER9g00Roe6tZZKCDn47sfRLeaJyPFZzAuCnUzT3yskS1ITrkrDJ6yA5oeYICF1YRnxm
	sUwttUH392Scj4LDR0IVu+Pw+6pEP1r205MZC8I0ipIUYxql7EvX9kO57mK8h82BKl8hFx
	5dpqpeouqgkHYKGgTo5xosUn0Ge3qSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779380526; a=rsa-sha256;
	cv=none;
	b=5ggpp5DmFJg3tM7mFVzgJb0oikn+55P9/oA2sBEZzBfQffw1wGYg8+6r/4o0tz010qGrd5
	YNGF4DP/ZzprgaSwiH6euDxMJZzNqZsAgClb8G7er34d2fnLLlfqPETXihkbnsMZ4dqs7x
	WmK5u4BayA8iJn62IZIJYoi5K04VMUc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nqjZAVh3;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5660E444CF;
	Thu, 21 May 2026 16:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27081F000E9;
	Thu, 21 May 2026 16:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779380525;
	bh=dcfNGGjgx+NSZAuu90jBs3Qr8P55dHAXd7ftObLSo1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqjZAVh3PyIoAeEkzPIV1rUZ6koUPIajoobZVez4REJMBrP5PUMiCT4NA+vjfKxzC
	 5VXS/ogr8g8x8JzO1bGf6z3gEI4LpMM6VQMB7WzQRDK2EheYvrUDs9KSP51FxqiGw7
	 KcjFZl6X+Tl2CHi9HHx0JMxuXTej35em5oq4Xm9SZRwtg2eJ0Y7gCY0buuxkjbWhg5
	 7eoPyLV/T1+hQJEwZErnyU9Qyo+fbXbrbTLjRAPD9R3mNV7nul71qXBUj+lqnTg4Qt
	 MzwY+EqvemEENsHd3SueAxjspmnc0uzm4mtOyY6NBla/uvDuoYKOYRrYgPEGo3DXnX
	 uvq30KXMIO8yw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] drivers/char/mem: eliminate unnecessary use of success_hook
Date: Thu, 21 May 2026 17:21:52 +0100
Message-ID: <68bd08d2c7432f94b87f9e40f379336860a9997c.1779379804.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779379804.git.ljs@kernel.org>
References: <cover.1779379804.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 743EE1A0002
X-Stat-Signature: yhrzw998qsddppkj6nebn4euo519t1jf
X-Rspamd-Server: rspam06
X-HE-Tag: 1779380526-8853
X-HE-Meta: U2FsdGVkX1+YglDc5RrZLaQ81vtcUJeK4n605r9MxR4WGqWTaJO1ezzGqo2516VmJ6lPLT/ELHoAzn1px+aDR1NXr7mfjjQL+WKqWoNl5ZSpMw2hMlaD4C0jFyujU0ypXNg3a/r+SaWHogJUOMLYwKm/Sh5iPhm5QgMTzl7e+LYXmfPBkzTlVjkh6+p4URCz8JKOEBAg1Ca++FYrbi0V+HgYN9gCEIeQo0k2TgWUz1ZgABJ0Uv7i5Vl9wgK5vRFhPBT0OD3o2qRmLvrUMl1AMRPr2Bfik7jwEq/a1uK47ZLDSQoY9xZEmcucD10DuZftYCK2gbxdJ44ZjacdZgLpBgkbM7hIwGokpydNUaadYCBdLvwif2EpfvdJkwzS6TOhy8K1jLeA0C5AXE8GCL+xnkyPxFg2zkuK11B4MZoQr9usWxnzF0LChUq4S1fBaJv77HUPxmlngTo/gukOwK9XO6kLV1Sw9rticSkpbaa4iLlYRnwr6TEuFkHRrOPD3YeMtN+Z8jT//kX26fCJtogEIts5/XwNIntI/bW7mnOdy/ZrKMM0QH5H3ly41TGOQkKQOhNQBwzpu0oJdRj7E4JPsEVZwQv+wYSsjDC4QdOsx08BAvc01rzIK2c0tB9NRnbplClVjYmxLrSmlPY3hCw0CvABn84n6nUEE3FCy0bad1Mmh8nxdBYMoxn4wEIsclMN4Cd3S2xjtbI9J3cDohmPI4eehjBao0MFoOdjq0n3dSpWFcRaspuXg/epvUoqTPRJ0baUyE97hWcZF7AUc2GlFPFb2Cd0VNQyPjBZxakcTtGZT6Uv0BJojy/3K/V61vGA06YaOvhwcItxt/cLzz6gug89l4Ghgg7S1Xp0OVYt7Lepaw47RHRh+hMGcNouEk0cTckHRBZVrcYT4gAPEy8b9DuLbp7HS0dqP7i37nkV58vNVLehY8JgNz3TjKVn10CoIbvJp7g7VYlu74Y/ZSm
 HhUJZKVq
 XQHJ0DPDTowXtUn+qmAzYm3xJ3axdpOqYBJPXKQFRHkFtVPpCq98H/eMCajvaN4ZZMIYX/zmbAELkN8nb3JQD7wtZaYAz/fsQQeA4pplTxNGEN9vyHvZfxpusiQoI0z9FeH674s7lYfM+emfOS+Zu2yU/8Iv7TXSP585MSGXdBDFuK/wKQSkvfzqRrTCmskgr1Yzwd+8YjPHxe9EuY7L6oASg+0hGeqcM6pfBinH4LpBj2thCLZaf7zQvVO/5caLBghHCr5OWfEud3mCAZq5kZ5k4uqQJVTAXYkZHPElkESRX37XYbu5rQNiLvDKiZjX+WTJG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce vma_desc_set_anonymous() and invoke it from mmap_zero_prepare()
in order to eliminate the use of the mmap_action->success_hook.

Note that file-backed VMAs default to vma->vm_ops == dummy_vm_ops, so if an
mmap or mmap_prepare hook does not set desc->vm_ops, the VMA will remain
file-backed.

We also update set_vma_user_defined_fields() to make clear that we are
either setting vma->vm_ops to what is provided by the driver (or defaulting
to dummy_vm_ops if not set), or setting the VMA anonymous.

This lays the groundwork for removing the success hook, which was provided
as a workaround for drivers (mostly, hugetlb) that still absolutely seemed
to rely upon having access to a VMA pointer.

However, for the transition to be useful, we really must eliminate this and
make no exceptions, otherwise drivers can simply work around it.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 drivers/char/mem.c | 17 +++++------------
 include/linux/mm.h |  5 +++++
 mm/vma.c           |  2 ++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5fd421e48c04..a4297eb39887 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -504,17 +504,6 @@ static ssize_t read_zero(struct file *file, char __user *buf,
 	return cleared;
 }
 
-static int mmap_zero_private_success(const struct vm_area_struct *vma)
-{
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_set_anonymous((struct vm_area_struct *)vma);
-
-	return 0;
-}
-
 static int mmap_zero_prepare(struct vm_area_desc *desc)
 {
 #ifndef CONFIG_MMU
@@ -523,7 +512,11 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	desc->action.success_hook = mmap_zero_private_success;
+	/*
+	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
+	 * of /dev/zero anonymous, despite it not being.
+	 */
+	vma_desc_set_anonymous(desc);
 	return 0;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9cedc5e75aa9..2138c86403f5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1489,6 +1489,11 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 	vma->vm_ops = NULL;
 }
 
+static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
+{
+	desc->vm_ops = NULL;
+}
+
 static inline bool vma_is_anonymous(struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
diff --git a/mm/vma.c b/mm/vma.c
index d90791b00a7b..07486390c692 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2697,6 +2697,8 @@ static void set_vma_user_defined_fields(struct vm_area_struct *vma,
 {
 	if (map->vm_ops)
 		vma->vm_ops = map->vm_ops;
+	else	/* Only /dev/zero should do this. */
+		vma_set_anonymous(vma);
 	vma->vm_private_data = map->vm_private_data;
 }
 
-- 
2.54.0


