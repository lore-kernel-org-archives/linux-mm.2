Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9871AC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582056B007B; Mon, 10 Aug 2026 07:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C366B008A; Mon, 10 Aug 2026 07:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D37D6B008C; Mon, 10 Aug 2026 07:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF886B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:31:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C301400C8
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:31:31 +0000 (UTC)
X-FDA: 85085144382.17.AF4A222
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6DF91C000A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:31:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmtT0txz;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786361490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OmfN53jdXhgjT/kkE1FE9ziy0zE/HRDnoaVJ7fFdThM=;
	b=lb1l+lxMLL/bn9ynt7VjpHfFO3VVnnuui3wgYtMaYpzXXENUsaIgQkWntUfPdT7nRPa6pt
	7Asv+dlpUJp7Ud46bDpIzbl4QpchpAEVGIqaBGa96XPvGev7wFR08vxitYVmhYJdVDvnEU
	N9Lax7bKkQZ04UmsIdo3HgRNYe3Fcz4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LmtT0txz;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786361490;
	b=O6govOjr3Hut7eqEMB5DAr+luIDpx6hkgve6kmWJ522EL+OmO5cF67b4sN4gMVuMXrGgch
	+p6Vtc7vqz5VjOUEIxvakHjyqB1Nk9JOP32ulq5XTPmcIQlC3t1LvEVdrIL8Xzy1SNmcCN
	NDbswWDK3WOTumyvJ8+xWYCihhjrJPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12148408B4;
	Mon, 10 Aug 2026 11:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DB01F000E9;
	Mon, 10 Aug 2026 11:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786361489;
	bh=OmfN53jdXhgjT/kkE1FE9ziy0zE/HRDnoaVJ7fFdThM=;
	h=From:Date:Subject:To:Cc;
	b=LmtT0txz/pwPgj/6Vet/ajHdGfN993mvKMd5D0v643Vbm0eSui2nxa6vL+qNi5CxN
	 3c9m+TW814NsFOqCU6Nv8cHRLx93B1DceYuNIw7T80EgTVqZDjQSxBmcq/yeIYLyAD
	 p7pbY/DxqdTHGUGdDEM0QEOQM1+DOX/hpwjmv0NhBdOVU9SmgU0IIypJq+kJeKdbB+
	 1JF4Pbfj7o2TqS06TJTgN7hwHKFJeTFBId188uf+tjw+1G/t9oL0XNEM/9EiAKiO0v
	 vsfx94BwoSps+M0/CNiOVTJ1xK5bk7XoF8Xf+t5xa6MaZUtHx49SQTA9rzDdC7jWfj
	 Ab48uNrHFElWw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 10 Aug 2026 13:31:14 +0200
Subject: [PATCH] mm/gup_test: keep longterm pin state per file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-gup_test_data-v1-1-fb1d41be5bb4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIG2eWoC/yXMQQqDMBBG4avIrA1kFFvxKkVC1F87XVjJRBHEu
 xvb5bd47yBFECg12UEBm6h85wTOM+rffp5gZEimwhYPW7M107q4CI1u8NGbyj9RMzMwlpSaJWC
 U/fd7tX/r2n3Qx3tC53kBUip3TXEAAAA=
X-Change-ID: 20260810-gup_test_data-5a7e8111eef3
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Yang Li <yang.lee@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 yunhui cui <cuiyunhui@bytedance.com>, Yunhui Cui <cuiyunhui@bytedance.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: x8xfe4c7ba9rp4atm1i9erpj7z4gji76
X-Rspamd-Queue-Id: D6DF91C000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786361489-795036
X-HE-Meta: U2FsdGVkX19lFtcrhoFNMdFMVwVps0WO58SmlvEJs9akl+5N3npE1Gjv1HGSu/Mjxpez7NmYcs8+SFxSEcapQe3n+YMw2NnExEQBG+BeJHbXnYE2r7ArehVfCf7odn+Zl5aYcRTEHrrhsFz7eAaNl+ozwk7lisRoSMavXhCGsUEcP2s/knlZGzGsya4h2PXBbsddo9uvLJ82Gc36ajeObw/VoW3dLI4EQIMb20+SaZQLs92YNwOI5IjiZLNNBZT68pXI6giRar+vBcAjS/jfn7xDm3o+DpbZ4wG4tzX8ousljOP6LhKnKhC9RK4JRTadtsDXLH/cXhcdAm2C3BplVO0CH+qPav2H9zIbRhyL8q0rQ0udtJrInRzOBhtnH3Yi+iCgp4uGlU4ObrbCuWo+hFSCHG27B0PKfN4zl6SUV1pjFMjtC4LuPbNZoGeVv38DCdMc8rXiJJqelH+LUTxtgxHD+pKV12pWlAQUZUXUOVChfdXlgbgLoHxD+y6LW+iP5OypVRcSsejgSI4Vz8OVb7USULtgCSb1pLcUO1KWZnmvbSGdj8P9CNUu1ZOH8uYj059JN791XZQlGFktCBKs89C93R1PQkjwbOU1HSKfOoAdLFGzIVL0DrvnpScyIqucs50GHZqG+29kHKKi74zqnWvsX+ywLRW6STjyjo6J24Qkj+Z83/3kQATGGVrvACVcJdsvEj1X73ThzLVOM+6wYW4PCwY94z0j/E/aAQXBRTkZegt4dWL8v1J83MoCBu+nwWK3/HU42fQPBMlG/S9FXMYsEnAsQ87wK62okSsPGByHgK04lmaupMXhTnGsjmzGvzVAxDEMPA6HKoLvboOt8zFYJ9MXqJqHzZnv4V24J0lCVJQrGL65efIedW1EZrBCRp2sNg7yKjKf00yjjFNoheEFULgeznGdp5KZsR0JAWTpaEuPFziRgmh4QeYZmqwsaM9DUtutfjh/f/3GMz9
 4Nzr5tbh
 +bAXNC/YNgyAXSKuCSLL03kcrDYcKAj5a5WstdHaAeNnuZiA5K184TM/yFnCDKG+Ov6WGlIfbYzKZs4BieamfD3LCkS28+H8CkVhAtaallYEsaPnUFyrPhiEMrG9tWSB/Iit08zGxgn3jv98SeVV8YTKSs7gdmajaSret/Xa++oKuVu8sIW0J7GT9Vax+i8Bv2p+vP2YNqrhd7JabTjWh/C51LW7+yYa3IHhT1J6oJzQ9PcheSYM8Rq3Has9uY+HCec4DJYMOrUiEp08py2bLvWYKw59grhQbLLFLoHcIepPwhikxNeEyCQ5/AQ7GTIvvrZ9d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pin longterm test currently stores its data globally, shared among
multiple concurrent users of the interface (multiple open file
descriptors -> multiple "struct file"'s). That makes
the gup_test interface problematic to use concurrently: two users, such
as concurrent selftest runs, can interfere with the same longterm
pin state.

While this has not been observed as a problem so far in practice, let's
just handle it cleanly. There could be a way to trigger selftest
failures by e.g., running the cow.c and gup_longerm.c selftests
concurrently, but we usually run them sequentially. Let's add a "Fixes"
tag to be safe, but not need to CC stable.

Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
Reported-by: yunhui cui <cuiyunhui@bytedance.com>
Closes: https://lore.kernel.org/r/20260608025043.88087-1-cuiyunhui@bytedance.com
Tested-by: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Tested with cow+gup_longterm selftests that gup_test infrastructure
keeps working.
---
 mm/gup_test.c | 94 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 32 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index eb4c9cda16ed8..44c1cdfb9c371 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -8,6 +8,12 @@
 #include <linux/highmem.h>
 #include "gup_test.h"
 
+struct gup_test_data {
+	struct mutex longterm_mutex;
+	struct page **longterm_pages;
+	unsigned long longterm_nr_pages;
+};
+
 static void put_back_pages(unsigned int cmd, struct page **pages,
 			   unsigned long nr_pages, unsigned int gup_test_flags)
 {
@@ -208,23 +214,20 @@ static int __gup_test_ioctl(unsigned int cmd,
 	return ret;
 }
 
-static DEFINE_MUTEX(pin_longterm_test_mutex);
-static struct page **pin_longterm_test_pages;
-static unsigned long pin_longterm_test_nr_pages;
-
-static inline void pin_longterm_test_stop(void)
+static inline void pin_longterm_test_stop(struct gup_test_data *data)
 {
-	if (pin_longterm_test_pages) {
-		if (pin_longterm_test_nr_pages)
-			unpin_user_pages(pin_longterm_test_pages,
-					 pin_longterm_test_nr_pages);
-		kvfree(pin_longterm_test_pages);
-		pin_longterm_test_pages = NULL;
-		pin_longterm_test_nr_pages = 0;
+	if (data->longterm_pages) {
+		if (data->longterm_nr_pages)
+			unpin_user_pages(data->longterm_pages,
+					 data->longterm_nr_pages);
+		kvfree(data->longterm_pages);
+		data->longterm_pages = NULL;
+		data->longterm_nr_pages = 0;
 	}
 }
 
-static inline int pin_longterm_test_start(unsigned long arg)
+static inline int pin_longterm_test_start(struct gup_test_data *data,
+		unsigned long arg)
 {
 	long nr_pages, cur_pages, addr, remaining_pages;
 	int gup_flags = FOLL_LONGTERM;
@@ -233,7 +236,7 @@ static inline int pin_longterm_test_start(unsigned long arg)
 	int ret = 0;
 	bool fast;
 
-	if (pin_longterm_test_pages)
+	if (data->longterm_pages)
 		return -EINVAL;
 
 	if (copy_from_user(&args, (void __user *)arg, sizeof(args)))
@@ -263,12 +266,12 @@ static inline int pin_longterm_test_start(unsigned long arg)
 		return -EINTR;
 	}
 
-	pin_longterm_test_pages = pages;
-	pin_longterm_test_nr_pages = 0;
+	data->longterm_pages = pages;
+	data->longterm_nr_pages = 0;
 
-	while (nr_pages - pin_longterm_test_nr_pages) {
-		remaining_pages = nr_pages - pin_longterm_test_nr_pages;
-		addr = args.addr + pin_longterm_test_nr_pages * PAGE_SIZE;
+	while (nr_pages - data->longterm_nr_pages) {
+		remaining_pages = nr_pages - data->longterm_nr_pages;
+		addr = args.addr + data->longterm_nr_pages * PAGE_SIZE;
 
 		if (fast)
 			cur_pages = pin_user_pages_fast(addr, remaining_pages,
@@ -277,11 +280,11 @@ static inline int pin_longterm_test_start(unsigned long arg)
 			cur_pages = pin_user_pages(addr, remaining_pages,
 						   gup_flags, pages);
 		if (cur_pages < 0) {
-			pin_longterm_test_stop();
+			pin_longterm_test_stop(data);
 			ret = cur_pages;
 			break;
 		}
-		pin_longterm_test_nr_pages += cur_pages;
+		data->longterm_nr_pages += cur_pages;
 		pages += cur_pages;
 	}
 
@@ -290,19 +293,20 @@ static inline int pin_longterm_test_start(unsigned long arg)
 	return ret;
 }
 
-static inline int pin_longterm_test_read(unsigned long arg)
+static inline int pin_longterm_test_read(struct gup_test_data *data,
+		unsigned long arg)
 {
 	__u64 user_addr;
 	unsigned long i;
 
-	if (!pin_longterm_test_pages)
+	if (!data->longterm_pages)
 		return -EINVAL;
 
 	if (copy_from_user(&user_addr, (void __user *)arg, sizeof(user_addr)))
 		return -EFAULT;
 
-	for (i = 0; i < pin_longterm_test_nr_pages; i++) {
-		void *addr = kmap_local_page(pin_longterm_test_pages[i]);
+	for (i = 0; i < data->longterm_nr_pages; i++) {
+		void *addr = kmap_local_page(data->longterm_pages[i]);
 		unsigned long ret;
 
 		ret = copy_to_user((void __user *)(unsigned long)user_addr, addr,
@@ -318,25 +322,26 @@ static inline int pin_longterm_test_read(unsigned long arg)
 static long pin_longterm_test_ioctl(struct file *filep, unsigned int cmd,
 				    unsigned long arg)
 {
+	struct gup_test_data *data = filep->private_data;
 	int ret = -EINVAL;
 
-	if (mutex_lock_killable(&pin_longterm_test_mutex))
+	if (mutex_lock_killable(&data->longterm_mutex))
 		return -EINTR;
 
 	switch (cmd) {
 	case PIN_LONGTERM_TEST_START:
-		ret = pin_longterm_test_start(arg);
+		ret = pin_longterm_test_start(data, arg);
 		break;
 	case PIN_LONGTERM_TEST_STOP:
-		pin_longterm_test_stop();
+		pin_longterm_test_stop(data);
 		ret = 0;
 		break;
 	case PIN_LONGTERM_TEST_READ:
-		ret = pin_longterm_test_read(arg);
+		ret = pin_longterm_test_read(data, arg);
 		break;
 	}
 
-	mutex_unlock(&pin_longterm_test_mutex);
+	mutex_unlock(&data->longterm_mutex);
 	return ret;
 }
 
@@ -375,15 +380,40 @@ static long gup_test_ioctl(struct file *filep, unsigned int cmd,
 	return 0;
 }
 
+static int gup_test_open(struct inode *inode, struct file *file)
+{
+	struct gup_test_data *data;
+	int ret;
+
+	data = kzalloc_obj(*data);
+	if (!data)
+		return -ENOMEM;
+
+	ret = nonseekable_open(inode, file);
+	if (ret) {
+		kfree(data);
+		return ret;
+	}
+
+	mutex_init(&data->longterm_mutex);
+	file->private_data = data;
+	return 0;
+}
+
 static int gup_test_release(struct inode *inode, struct file *file)
 {
-	pin_longterm_test_stop();
+	struct gup_test_data *data = file->private_data;
+
+	pin_longterm_test_stop(data);
+	mutex_destroy(&data->longterm_mutex);
+	kfree(data);
+	file->private_data = NULL;
 
 	return 0;
 }
 
 static const struct file_operations gup_test_fops = {
-	.open = nonseekable_open,
+	.open = gup_test_open,
 	.unlocked_ioctl = gup_test_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.release = gup_test_release,

---

base-commit: e5492213654050379e78ec6f9acfd6c9fe00f334

change-id: 20260810-gup_test_data-5a7e8111eef3

--

Cheers,

David


