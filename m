Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6383606B753
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwO3yy+d
Received: by kanga.kvack.org (Postfix)
	id AC54F6B05D4; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A443F6B05D7; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896516B05DD; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 530E26B05D7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D651380269
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:11 +0000 (UTC)
X-FDA: 85406458662.09.8433BE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B175A20003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwO3yy+d;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011829;
	b=tKWGyFfSz+2sU1lPy+8IAtRBcJnQ90En1zoel/cJPsBgxAnlwd15q6qxcGjGftAp4oO66c
	OF/x0JwiMgCGzD1tai51B5GtxyxwbWJ+2/CE433OyLe4Ay73gKkZXHul9ucXRwNlyx6vyS
	8EQwKuGXaYCCWPDLiysE2tRRYuANrEQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwO3yy+d;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1Xg+Ovh6SABK55ACPtrHdOXD90IrQIkoxCH5viHnSQ=;
	b=Uk5wjvBLxBOXRggO9/S3Qllqv8FkLdqmrpgV9KPKMUbIFUFaC8UR6vI3uNTdXwGv237Hco
	+VGQ00UBrYKvYGaf4qWgJccBKV/y23GNPV6nRwpqlpaNtYrw3Iw0ZTVnmdpqKakfRAV08j
	DQKZnhZBxrZG5BVmD6KoYrl7D9n2zaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B1A844520;
	Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011828;
	b=XMRKowyWMgLWEZmnbUUADVgocA9/c4gR2zKDICi+IGU+IWQPRsYimAJUhP+CgeIPQz52
	 bbdIC6vkHFAgSEPd/LozGtyS6EibMutnBhmSXVgZUffaeq63lSQOAFxNZQa/oIn3YUL/x
	 Zs+/zP/t1UBSxuQVF7dvqa2KhuJP1uoZCdbnuDgx0MRxkVLOx4gmSiH/wytJEq9zGUHf/
	 lVtlanFHbRB7U0o/9GesqNWJH13Pmvz2IoYjn1Kk2tiqX2+2mfm2+tVdHESpBUFp0Xqts
	 B07cgUwZA/d2gjSnieJNGNbjAcOAgp9buvpI+wIyG/3+I/3jF6+4AHkbVrJCSLZ6Mfw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011828;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=U1Xg+Ovh6SABK55ACPtrHdOXD90IrQIkoxCH5viHnSQ=;
	b=ruDb9Sl5ebyFhGrVVaQJgDaGwuKpsF5n0yk08HD7nklnxKU/nGws8i8+k2Ra3HQ3I3xo
	 RuDEMxqVrhzUkfx5n+oL16G4zdidCFDViHnjVI5l5FVMgQ1pSOu8vYSMLSDasYfj6Oq1D
	 FtxmEKfsvAIOZFnRseLiIbSlAuCvVLY3tcFKtq8vfVrsFo1fcxR1XBp4tPWCvpByJTeoq
	 LKU2fJ03y67d5bzo1969AoaUugaLXxzkM1ho2OS6dL26gC9XSp8gNGP4L96desbzTNke6
	 GswPYpH0sM/FO7sJYz4gN1eYfWAdBkQF1UikhItetseuAJhCvdxdNQldUL2DnOzHdow==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 879691F00922;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011828;
	bh=U1Xg+Ovh6SABK55ACPtrHdOXD90IrQIkoxCH5viHnSQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kwO3yy+dTQb5fpWMD6tGW89FR5gjzwDKZ3RVcPWrIfUXGwcBWgusNAHVnVwyKW058
	 ghqY5RN1NInhvLD3gfLgmXY/326zHNpTiWD/JHNWkH4PN96R0i7QUt6/hRMxgykaex
	 UI1eDR/rx5ltCZYEyytd/YQ+VJ3UXmhGF8MlyZ5Iwvk4VWGIDjRUn2wtA3YX+utC61
	 LMLHyPCLLr5JcCd2OB4HEMqj0yjptyJraL7a+yb82tm+t09IyJCc4OtSSewcytLYRI
	 BXBHR33xrTjpF7FfVRGUgv9ao51llPo+KVwZz98l1pGdYYZSUedDuwk/jmPNy9dng3
	 zduz2aL3a4XZQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7389C4796B;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:56 -0800
Subject: [PATCH RFC v3 22/88] samples/kvm: Support marking page ranges
 present or absent
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-gmem-alternative-providers-v3-22-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=5672;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2aAtvWaVMFLs1DyMSWgKDsrYTk08ExBkcEnGdMCup6U=;
 b=FN3YnHse9NNd00ZJ6tUEz14740WtwjgOvcKLw/xxizDGT5VgohtqpKNVY2qr8NW56Ydpsd95G
 R5y1ppau9KbCSiMoTgYL1snTpXD18XnCOj4rMX9lX962RMBGnVl6nTL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: zumt1ps1eag3r37eirx6a86jzhpbsgu7
X-Rspamd-Queue-Id: B175A20003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011829-29138
X-HE-Meta: U2FsdGVkX18lXhzfZO2rniY7PriOx8fsLGphcBYZ4TxIfUI1b9Q9zLFZK4b3PYVoadYC1Xy8hiVyhRn9L3ZBRU9EhPjBKZiffbUsW9YFIHH6JhK+Ttp1rGwwMHWPxXQ/yw0oKgy+zo0ePD8+hBSwclmNtasc5jKZOWZCVrdlZH1uUf55cJSj0fpmhP02CFBAQywvdpSv8WOoSaWi1Y4wyGikwYknS4IXglKGcJUEQyt0N9YFeXYdp6cFCXDCnCvRqqvp7Ipw2dVqHaWzx82gosRCgoQge18c9JzII90grL9GRR80byWU/4m+w/eMU92KiiOItCFBRhgWk3n85U/oiGBoYU6KLKEaLyeSf735TA9Q2E+xc2HRI8qzPJVwvGg2ih4LDpo3R+BUVJ9N8pOVV9gLh/aLcGHpFjKUfQTkOQvEsweuhIU7kkDP4CXz0QuBBkCD2D4vTZVc8ZPJ6x0lAD3uOBVQ3sFexi45NipchpOvB/4buMOjVM2loCqPU2++eoZpoNV8W3G33LV8s4ZyXU722QqPDZM3m2Bcxa7xjOETh+2M00tLFK1eBdVklD4sQL3X0RbkH0UHO2vX0GvJHfjV/lHThxUr3puYAahxucMYgBDJPtHTRy0L8OaNs4CvP3/2SI691evMJ98dyclShT9hq7XDa3p389M6c4zQWJFoVDTbyA8ZXYNJ3KroIBD4Rkx/JLPAPf86dUasi8r+Nhp6knZ+wORcrL47r0E1fpQWxJ4C0hEuGNBkFlkBY3ffW5IdG+mCxZz6fovYhBEVqcJSk0bBYYDU0jPw4Fgpg5q7ZPbvva/yCQ7rlsOJLiTOhCUAsRF+vV5nvD8pHcc3V2/dslp+m1JAOVzjSqzkosyuwwK4VK+CWXz6BwYCXxLkgw8W5Z00qZKJLeKauysPx29bFtUtMnsoxZ7hsVuRhVnqyzgeZHRf01u/Yc5gLOoGcjoBjC9s53yEWXMJTwk
 bpXVYezu
 zlnwsPVKpj+Q7Dkak+fg1yAAJ+K3OeJgptpB8LGe96oXpSM0YzhvrFHNzgi4lJanqLErvPPMP6ge08+cwsbwCDZbXPybeWpY+mRqKyVVZpzWcczJl3lv+1FXVYj6cf82YkGCRvknC4H0X17qWTzR/NqZYSm7WRQO3qwsXt9v2DzDX6BVfhzgY02AZAGW9Bqnp99Ai2A8MsApMdrqKEgAk7ZkZPYsAQUSInQCBB+AXe3lYXfAnYYTXqKw6ornbKCaFL7E3vlpC4f7v3dxmtCcNIWz2pfvY6GnpuHWhsUeAoV/XUHBp/1MSjsJUYwIw9D8uND0zazxSBNMlvRorSTLK45/t+ACAlB+mDIbuip+rw54V1z4M+tcvRoM1QM5IIdZczK/W24aOiw4F5XMvwIRcpUt0q+t/jjHg6EVTOxQKb2SzmT00XTwi4szIbbOdXksw12Yxza9vAEJ9SeoHlD5kRnt8woABfWd6hnygTGn0XYKarxq6bFktcaNn6fmei97Z2zka+5VzsNzX6Vn/Qmm1CBdm80IYJOsjPsym0XRxNhn4puef1rH3JC6C/6kyq2OP1pm4ZnMDjRyO7zo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

Support the MP_SET_PRESENT ioctl on provider files to allow userspace to
dynamically mark page-aligned ranges of a provider file as present or
absent.

Track absent pages using a zero-initialized bitmap so that the entire
physical page range starts in the present state upon creation. Serialize
bitmap updates with a per-file mutex so concurrent ioctl calls do not race
when modifying page presence state.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 samples/kvm/memory_provider.c | 83 ++++++++++++++++++++++++++++++++++++++++++-
 samples/kvm/memory_provider.h | 15 ++++++++
 2 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/samples/kvm/memory_provider.c b/samples/kvm/memory_provider.c
index e89ce55a357c0..6b8364afc5ed9 100644
--- a/samples/kvm/memory_provider.c
+++ b/samples/kvm/memory_provider.c
@@ -6,18 +6,21 @@
  *
  * The control device /dev/memory_provider creates provider files.
  * Each file allocates its own contiguous memory from alloc_contig_pages().
+ * Pages can be dynamically marked present or absent.
  * See memory_provider.h.
  *
  * Confidential VMs are not supported.
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/bitmap.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -30,21 +33,88 @@ struct mp_info {
 	unsigned long base_pfn;
 	unsigned long npages;
 	struct page *cma_pages;		/* from alloc_contig_pages() */
+
+	struct mutex lock;		/* the bitmaps */
+	unsigned long *absent;		/* taken away by MP_SET_PRESENT */
 };
 
+/* Byte range [offset, offset + len) of @info as page indices. */
+static int mp_range(struct mp_info *info, u64 offset, u64 len,
+		    unsigned long *start, unsigned long *end)
+{
+	if (!len || !PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
+		return -EINVAL;
+
+	*start = offset >> PAGE_SHIFT;
+	*end = *start + (len >> PAGE_SHIFT);
+
+	if (*end > info->npages || *end < *start)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void mp_set_present(struct mp_info *info, unsigned long start,
+			   unsigned long end, bool present)
+{
+	mutex_lock(&info->lock);
+
+	if (present)
+		bitmap_clear(info->absent, start, end - start);
+	else
+		bitmap_set(info->absent, start, end - start);
+
+	mutex_unlock(&info->lock);
+}
+
 static int mp_file_release(struct inode *inode, struct file *file)
 {
 	struct mp_info *info = file->private_data;
 
 	if (info->cma_pages)
 		free_contig_range(info->base_pfn, info->npages);
+	bitmap_free(info->absent);
 	kfree(info);
 	return 0;
 }
 
+static long mp_file_set_present(struct mp_info *info, void __user *uarg)
+{
+	struct mp_set_present sp;
+	unsigned long start, end;
+	int ret;
+
+	if (copy_from_user(&sp, uarg, sizeof(sp)))
+		return -EFAULT;
+	if (sp.value > 1 || sp.pad)
+		return -EINVAL;
+
+	ret = mp_range(info, sp.offset, sp.len, &start, &end);
+	if (!ret)
+		mp_set_present(info, start, end, sp.value);
+
+	return ret;
+}
+
+static long mp_file_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	struct mp_info *info = file->private_data;
+	void __user *uarg = (void __user *)arg;
+
+	switch (cmd) {
+	case MP_SET_PRESENT:
+		return mp_file_set_present(info, uarg);
+	default:
+		return -ENOTTY;
+	}
+}
+
 static const struct file_operations mp_file_fops = {
 	.owner		= THIS_MODULE,
 	.release	= mp_file_release,
+	.unlocked_ioctl	= mp_file_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 static long mp_ctl_new_file(void __user *uarg)
@@ -64,21 +134,30 @@ static long mp_ctl_new_file(void __user *uarg)
 		return -EINVAL;
 
 	npages = nf.size >> PAGE_SHIFT;
+	if (npages > KMALLOC_MAX_SIZE * BITS_PER_BYTE)
+		return -EINVAL;
 
 	info = kzalloc_obj(*info);
 	if (!info)
 		return -ENOMEM;
 
+	info->absent = bitmap_zalloc(npages, GFP_KERNEL);
+	if (!info->absent) {
+		ret = -ENOMEM;
+		goto err_free_info;
+	}
+
 	pages = alloc_contig_pages(npages, GFP_KERNEL | __GFP_ZERO,
 				   numa_node_id(), NULL);
 	if (!pages) {
 		ret = -ENOMEM;
-		goto err_free_info;
+		goto err_free_absent;
 	}
 
 	info->cma_pages = pages;
 	info->base_pfn = page_to_pfn(pages);
 	info->npages = npages;
+	mutex_init(&info->lock);
 
 	fd = get_unused_fd_flags(O_CLOEXEC);
 	if (fd < 0) {
@@ -99,6 +178,8 @@ static long mp_ctl_new_file(void __user *uarg)
 
 err_free_pages:
 	free_contig_range(page_to_pfn(pages), npages);
+err_free_absent:
+	bitmap_free(info->absent);
 err_free_info:
 	kfree(info);
 	return ret;
diff --git a/samples/kvm/memory_provider.h b/samples/kvm/memory_provider.h
index 0bd9e250aeaf5..de07ffa482283 100644
--- a/samples/kvm/memory_provider.h
+++ b/samples/kvm/memory_provider.h
@@ -27,4 +27,19 @@ struct mp_new_file {
 #define MP_NEW_FILE \
 	_IOW(MP_IOCTL_BASE, 5, struct mp_new_file)
 
+/*
+ * ioctl on a provider fd: SET_PRESENT on [@offset, @offset + @len).
+ * @value is the present value (1 = present, 0 = absent), and @offset
+ * and @len are a byte range within the file, page aligned.
+ */
+struct mp_set_present {
+	__u32 value;
+	__u32 pad;
+	__u64 offset;	/* bytes into the file, page aligned */
+	__u64 len;	/* bytes, page aligned */
+};
+
+#define MP_SET_PRESENT \
+	_IOW(MP_IOCTL_BASE, 12, struct mp_set_present)
+
 #endif /* _SAMPLES_KVM_MEMORY_PROVIDER_H */

-- 
2.56.0.455.g6c5a503b38-goog



