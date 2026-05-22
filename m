Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E736ECD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1DB6B00BF; Fri, 22 May 2026 12:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2F76B00C5; Fri, 22 May 2026 12:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392A26B00C6; Fri, 22 May 2026 12:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22F9E6B00BF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:00:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39F2140A3F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:20 +0000 (UTC)
X-FDA: 84795517800.08.5BC5C6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4197B40009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHdFvXgs;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779465619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LOOvoPFc1mo7/HC1v7nzO3pf/LAnx00Q0CZDsLJWW4=;
	b=exEZn4X7Y6PvxpbI2IIL/eha4Z61OnrtCm1DKlb6OzTfU5J15KbYNHVURVoNSAsvxBxVVD
	oohYuEPwZzHkbeOeg0XFBDdM3QlYxAcyiQ0fKYIFbWn3cPLpDJHTjDN7OkWqcm++X7gGqn
	VrF5v1h/PNi4IglL+URO5FK3sZ5jGfE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHdFvXgs;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779465619; a=rsa-sha256;
	cv=none;
	b=TxZiBSNlw5E3r0yv/DKlDYn6o8JyfT9szPQ/6QY6IX5JrRnJ1NQJlzOM+Qd9R0jcU7q7qT
	4rU2baKUoMP+sXHdKDyQhPqs1nowCqsA85Xw3tCEtsYxN9iRjXF6kbGFxeFBDEOezmS2ni
	JUNSzoxKr3ywuXg1DWT1qsTeFgPlJ9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EE6A42D84;
	Fri, 22 May 2026 16:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B653B1F000E9;
	Fri, 22 May 2026 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779465618;
	bh=8LOOvoPFc1mo7/HC1v7nzO3pf/LAnx00Q0CZDsLJWW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHdFvXgsYN95BR9977HUHQQgTuhBtlxR8o+rQH02po4VcJ//Nh2tmhcBYlkvtVX9s
	 kCULTY/FXdP2cjhP32hzVQG14Wxqy/JHiidi7bkTVckgN8VxTVXaN2pO/3GexjKY4O
	 9qz1T10MsuxxuMX6XEo0IwzY0TJbbg7GebhVqPD06vp0d0aql20oAETS5HY02gs09t
	 2mavmvbFhp+AW5ZpGCIz9uDOPS3a+aDeCN6bjOJWX6km0Z3BEZsBOFwig0W8GrX4xp
	 WNv9HnqiUKRFuWiCeS3L+2Zavc2v9xE9xw8fnTIlff6X6FmJNcDBTpMn5wlQWgRZzR
	 o7gjjUl998aAg==
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
Subject: [PATCH v2 1/3] drivers/char/mem: eliminate unnecessary use of success_hook
Date: Fri, 22 May 2026 17:00:09 +0100
Message-ID: <5d1e8bd29d6e070218ba7a03461df562e372b91e.1779462249.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779462249.git.ljs@kernel.org>
References: <cover.1779462249.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4197B40009
X-Stat-Signature: y71pkzbwhirfjctzaqrhgse6d9aynpqa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779465619-737695
X-HE-Meta: U2FsdGVkX18WZuknURN2b3jDNRFnNcKRH/SCv7Fwyg+UvPwGk0PtQp+nKSTgY81dan+Ao2+6D9v2btvFBQGI0ZxbYvFpSy4j3jUo6DNebOWlCI78diZkTLmCx6sJIU2WyOivmWbgjp65i+8mgV9EkehPpds0I8Ah7nyyZyjnv4C7cm8OoJK8boRjM0e3zaA1Nif8CLVxoh1liYCxkAFNCD/BrMatR+VAfH0r7kmlhtPyJZLWNo5Ea5h1V+7QSIwIdWqwn/edYy6bj+3XGkeAMsdxcoPAo6gagxkzW5bomtoJYxywOKzPVqgeel7tCdZYbjhb1veWdiJfuco+g73Ui/V+RZa8ithvL2F9QXyh2XaVxsgdKZJSv+tGyoptxzL8dwbikR/e5GVxbZNmaCYhRWPBYXUpm1nLTV72a6JWI0mCS7X3NxLBUeapItfc2NxWD0l617y0kUrLV7WhL5lVe1RWkIhsRR2Z6sBPVKE+xgNSvoSbY4Ig7Yo8o4cQKJdczmOG6nbA1M3CXo8FkRinwKIsmmi/kGzRNpAdycq6zERac8gUoHPKKup3Y/pP/wj37Gp+q/CGbX2MMrTySooj/UYCQEVFZ6UQhDm80x5ab6KVMzmXFjkg5ukB1SZ2Tb8TwYGpwxS1xj805XY1dLxXkgqdhxIk3AjIFFf4EuugH6xr0UFBp0+kcLKAuo90LI5KraMa2yafLxVyNfomF7L6YsOOommh+y+H6/AtjsQVGd8TiZ7B3n7DYgrPtmDUi0+H5kGlaSTUbBivGfDqszEa+av1Y35T4Ze/p9USm5hDTyDC3UqN9UTm5fvqxqM6byhuKrrVzSMKaKkO6puLS6rSazij9lmyyFRpXS3E3MSdZcbxORCDSO3l/1wRmWVDwrh/vmU1lMqK2tK1vOVdtXIpLSZYuvWcIlnJyfzoraRbVmS9ZHHaMalbd5QfH5bUjFINr72CPPSss59kpskIArS
 yjEv3/4n
 Fnp3Dh+9PfroXz0HhPJYtvCeGrS8s68WRML2VIp2proZyX3FcQFMMjm6boIyAunNx/FkYIP5x0KWz/yPFVjviVU1zKnQrKKJPQonN5n7sy9FYh0PvwET8DHOIqn8H6VBxWlWjxxUoazJvOQGJTzAwhyQeZfjwJ/bio1fU9hnE76NM+fwrVfZ3H6uvG7meRmLJ+btKwxds9Aq4foCV1u0om5DIvDimGItrA6lelys4hoxDwksHkGMSgIv0+w0zYdzUCUE5iZrxOEsVahFBrg2YK+goag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

/dev/zero, uniquely, marks memory mapped there as anonymous. This is
currently achieved using the mmap_action->success_hook.

However this hook circumvents the abstraction of VMA initialisation so it's
preferable to do things a different way.

To achieve this, this patch firstly defaults the VMA descriptor's vm_ops
field to the dummy VMA operations, which is what file-backed VMAs default
this field to.

That way, we can detect whether a driver sets this field to NULL in order
to mark it anonymous.

We then introduce vma_desc_set_anonymous() to do this explicitly, and
invoke it in mmap_zero_prepare().

This way, any driver which does not explicitly set desc->vm_ops, retains
the dummy vm_ops as they would previously.

We also update set_vma_user_defined_fields() to make clear that we are
either setting vma->vm_ops to what is provided by the driver (or defaulting
to dummy_vm_ops if not set), or setting the VMA anonymous.

This lays the groundwork for removing the success hook.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 drivers/char/mem.c              | 17 +++++------------
 include/linux/mm.h              |  5 +++++
 mm/util.c                       |  1 +
 mm/vma.c                        |  3 +++
 tools/testing/vma/include/dup.h |  1 +
 5 files changed, 15 insertions(+), 12 deletions(-)

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
diff --git a/mm/util.c b/mm/util.c
index 3cc949a0b7ed..2b2a9df689d7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1192,6 +1192,7 @@ void compat_set_desc_from_vma(struct vm_area_desc *desc,
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;
 
 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
diff --git a/mm/vma.c b/mm/vma.c
index d90791b00a7b..9eea2850818a 100644
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
 
@@ -2744,6 +2746,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		.action = {
 			.type = MMAP_NOTHING, /* Default to no further action. */
 		},
+		.vm_ops = &vma_dummy_vm_ops,
 	};
 	bool allocated_new = false;
 	int error;
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9e0dfd3a85b0..306171d061e7 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1303,6 +1303,7 @@ static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
 	desc->vm_file = vma->vm_file;
 	desc->vma_flags = vma->flags;
 	desc->page_prot = vma->vm_page_prot;
+	desc->vm_ops = vma->vm_ops;
 
 	/* Default. */
 	desc->action.type = MMAP_NOTHING;
-- 
2.54.0


