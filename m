Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EEE606A829
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jUpF2Sea
Received: by kanga.kvack.org (Postfix)
	id C40906B05DF; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA006B05E1; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8596B05E2; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F14F6B05DF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25DC0A01DB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
X-FDA: 85406458830.13.F203229
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18BB8100005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUpF2Sea;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xdlMkaOUzsgrFyk0a08g58aLzFMOMdtr8FPkrbIGbw=;
	b=HwnvS50xTJAd/pmUQDcIpIlepMHVoORhJ9rnpFnkhm3uM9W4MmqhJI9a5lfW8I0CxmH9i6
	8BKWrcWn40C3pylBwfR6nnFfueS6Q2BbeHRpzBS+C6Gb0xDs9Iiq//MkGt7qg8Kub8ZzQS
	lQWro6FzfEM17MFpDHhFebJ5EncXhC4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jUpF2Sea;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011833;
	b=MEtC11XAfQhWSCV13smgki7OPkLvD4HZ3Om18byuqKW1a6b5oFvaqddPM4urJ6tkL5Ri5b
	DduMZd0pE4StBET91Q9+J5MsBuQR7lwNdqJJKHSi4YuW1YjdrhIXaq8YCM0xIFs1ZOO8NE
	Si3Pa3r21v2bjD+GcM/qaBorxoF9A8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCDB84322C;
	Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011832;
	b=j+22AA6az/lDYB/bWbIDpoSnstJS2gEXug+VVWlwd6TlQhUN8eMzX5nKrDUXTX1Ci8hB
	 2a+911FALxhVjq1oC6qugjivp23tWWMgQKgzME7G8ZFjCz6PHHmhsgmJNBc41t4ro2DAE
	 9/TV8gj1bnAVSI97+22/1cGRhfRXi4m65thI5OLUzil6IJbhLBmmRTn0lyF+j1aribaYy
	 Q7K6Wu258vSbL7f8TiINe+/CJJAGbk1NRiIOHmulAAlz+mHaHm06Ra2dfvkwWSWiYKUEC
	 Nq9n7mrhNu67E6twJ2Xic1u9NqDUPG2laLKl/ZBvSg4XweMjgEsKo/xCVIRh24N9Psg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011832;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5xdlMkaOUzsgrFyk0a08g58aLzFMOMdtr8FPkrbIGbw=;
	b=edySRZTk0foQsVd1KtuB1YvG9TbMxopS/cMzAGVj1dGaGJdChKWJj+u50MObydVJFtNG
	 ksXBJAIRXrvKMt+zs95LVe+CfqE/VSTyFKKWEhv9Av+fgT6MSscmMANQmb7IiIVMf7hjO
	 KpF659nRcb0sPcU96E0L5Ohn5toNfR2qusbpeYUE9bSF5fUut30j18VxfPP6SeEGMcC8M
	 8MQJCUbnA+J1IloJ/GzJfPPSPuqlfqrpI+mJMoXKd+GMMRX8W/ArmjVx2g3WUWGORMELB
	 jL/S0mTYf9VSXwauv3Vr1ryrJEP+Er/TSKCB8OEbTOiqnNqGq32Q8DEwnbc6s0M2KZQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0B9421F00A13;
	Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011832;
	bh=5xdlMkaOUzsgrFyk0a08g58aLzFMOMdtr8FPkrbIGbw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jUpF2SeaaG3ZhUpNSvSvPl5/5t2BEGHuTOQBQ2NU3t1ALW3hZUZuqs2RjW7D0NGIC
	 FtEm5euPMVbevoRVXR7pYgS0QxYRTMcIsZR5nw4UFVIvqLoyaCPQplSXivFIRGp9pZ
	 7zYlSE/Hb2V7rufJvVO6P3Ryk9EIny/sYc0/IyHymBkA7YS1fZFDy1Q+zZG+vHr2zz
	 NamosO5hAyAFX2uNs7Vw4CR9w9sSY0ixh045d/ehabg2+5q8UTjljw/gg3/3gSF5xs
	 cChLDLh1nvg7uPiaWuIOiZlmJ/e78XASU23cF3Snxkf+YgtjaFJ/eRHPo91fOp43Lr
	 KUEeFewlil8LQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9593A479E5;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:28 -0800
Subject: [PATCH RFC v3 54/88] KVM: guest_memfd: Support read and write
 operations and provider callbacks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-54-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=6435;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nv52q2gMdxzmaZix0sQpW+28+lbsXbZR5Bzi3YONHfM=;
 b=0Smvv2QfB+oDOaurG+jaFJgcG514sTC0qa6lYPTm/2BeRMYZZHkGuZX+04ozUeDdZmxbk+Jkx
 XdZPc9i4rl/DCPq1rqBcrjqqS0llXraTB6nFscVMeUJKbdfNyBSK/aL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18BB8100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 14jarzxoj5475gcjwwac1hazmkxr6giq
X-HE-Tag: 1794011833-849829
X-HE-Meta: U2FsdGVkX1+2JXP3CHjn7Kye0R3wpIreYTNgHWdhf5hdrhVokwdycz+YPzCEcSiH/TItXWKxsj1OjebTT9TWhQt+tdZ+X7ajY8vNjXgN8Z14GOkdx40djOVSk2QnDfOMpAANgwu2Vm1udRWLl/F4vO26813EgNYZKiWBSGuQgJ5oevtIjDsGnBMU+s8h/i4P8PT1enmcMoNE4L7hM0xEvF6HQp58uhq60XIg8WLLzi6prMczq5/2yewbszvv3FPCZ6/Xtf0d20e9zxqfazU98fHMoOvHHGPhcP2BOCAyWofWMWURxWWTTY5FTMI/mKIIadmYKrcLw/MoVCosC8//2zWQpEzZaBLGTchF2iIp7XMeU6Y+RYJvso2hGkaipwaJNehccwOJfDcj6yqvx0ktYh2KOUwxxeyq3ZFrsKImES5BliMzZpTbw/a/n6egMEIM3IRNDdFVSvPoIlFrKxvZrOqgYLm3isYi1Q6lB09Eeh0+8qufXYmMiD9PzuH2b8fOY0sO386HyH5Mh3lOJnD06QEw+Vxc/tEGtj04SN7PM9H9Zpl2+GiXAmW4A9GvHKPoJ9jVwGpKMIuzkChD+FArfTJpV6S3QakBK36fD7PMXyNjruXEQjAeEsT+bIkPnSBjgUrlfr/nlX9hxattJjLMWBW2sUhTs8VFZoU4X7R/9c05Unbw7/21ZTfzjHZQa10eluHTlX5AvS4/1sK/9NoR9WHnBobOJIipQ4dYiKzzsiyhxjMxi3ChnhSHxt/RgG9Z3oyrhduzTp0kjZhLDI9AIarWIR2HPY5KpsVmw/7kShTni84GKvTdpsXNhkExYBuLaU8tu/YKUCj7gAKHZKybeHRiHR2F4v1d9EhKaT0Cs93Bg/TtqxeEy5Y/Qwe4znhyjbBuTTQMdvAoNlsb/xFrTfNZsuZYQeJ2S18gPVRc8R9LEb1RMi+t+yYXR8tCmYjhDdDs6d9IEJD8mSgO1Pa
 2iYn/Z2v
 RyifUt8ABCAyWSsaEeFy50zpQSm3/5Pr1kz5WnTuxyPVAKetJ+sQxMSKP04BTui+g3imwjtXTyfVKZ2QBFI1+Ywjpj+jmPCTzqvk838zzBifcH80eigTKZw465qLr69W6e4veaxu4LsJLE4ExJNnRz4WnQlkXk7Q++8QuH0gGgt3IHp7yL4aJKZOOOLz83MorJ5faNlVFIkC+T+tIzD4PZ3PWI7SfvVoeDjZA5e0JfLUhfBmgG3JLg1vD09JFZSXfSDEBAFrprGPlTixEVimBXVZIjuWnvY1FooQyauWFmNp7+guMPw8SAvCGXfbvZ3PKtuQflvxgsUrERIlxK76W3DGnXAX4L3j3hue6Hzgq+Nrr/bih3re/Y2XZubdZuszvnZfmFR68KFiW5WpjY3Y7OjKz8UTO4Zu9E/a6/3ENYs8IzZ+B9456ieAhmvxlmPeaArhUCEAcIIqgGo1NegoDhE4wqRj7jVLusHNs2kw+xJEW0VbyU1YbQFtv3Zvv/lVfopMXEBcwq8nt5LZoIvfhlJr8sIVEzWbUb1bS2cjIx36L19WxjFer7c6InEKT4udKDqih+M74pYqINI8Sg6aI1rQWgI8YUWQixlJYvdj2Z9dYpAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Allow reading and writing to shared memory backed by guest_memfd
descriptors.

Consolidate locking, file offset bounds checking, and memory attribute
validation into a shared kvm_gmem_rw helper used by both kvm_gmem_read
and kvm_gmem_write.

To decouple low-level provider operations from userspace copy semantics
and avoid AB-BA deadlocks between mapping.invalidate_lock and
mm->mmap_lock, transfer data in chunks using a small stack bounce buffer:
- For writes, copy from userspace into the bounce buffer outside
  filemap_invalidate_lock_shared before invoking provider callbacks with
  a kernel buffer.
- For reads, invoke provider callbacks under filemap_invalidate_lock_shared
  into the bounce buffer, release the lock, and copy out to userspace.

Verify while holding the shared filemap invalidation lock that the
requested file offset range does not exceed inode size and consists
solely of shared memory.

Forward read and write calls to the provider via gmem_provider_read and
gmem_provider_write, providing placeholder stubs for the native provider
until reading and writing to native folios is implemented.

Enable FMODE_PREAD and FMODE_PWRITE on guest_memfd file descriptors so
pread64 and pwrite64 are permitted by the VFS.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h |   4 ++
 virt/kvm/guest_memfd.c      | 115 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index cd634576c9af8..c85594b58112a 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -113,6 +113,10 @@ struct guest_memfd_provider_operations {
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 	int (*mmap)(void *provider, struct vm_area_struct *vma);
+	ssize_t (*read)(void *provider, void *buf, size_t count,
+			loff_t *ppos);
+	ssize_t (*write)(void *provider, const void *buf, size_t count,
+			 loff_t *ppos);
 	int (*check_set_attributes)(void *provider, pgoff_t index,
 				    size_t nr_pages, u64 attributes);
 };
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 61a3ff7fcd84c..385b517b49ed5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -80,9 +80,25 @@ static struct folio *gmem_native_alloc_folio(void *provider, pgoff_t index,
 	return folio;
 }
 
+static ssize_t gmem_native_read(void *provider, void *buf, size_t count,
+				loff_t *ppos)
+{
+	/* TODO: Support reading from native provider folios. */
+	return -EINVAL;
+}
+
+static ssize_t gmem_native_write(void *provider, const void *buf,
+				 size_t count, loff_t *ppos)
+{
+	/* TODO: Support writing to native provider folios. */
+	return -EINVAL;
+}
+
 static const struct guest_memfd_provider_operations gmem_native_provider_ops = {
 	.attach = gmem_native_attach,
 	.alloc_folio = gmem_native_alloc_folio,
+	.read = gmem_native_read,
+	.write = gmem_native_write,
 };
 
 static bool gmem_provider_ops_valid(struct gmem_inode *gi,
@@ -210,6 +226,25 @@ static int gmem_provider_mmap(struct gmem_inode *gi, struct vm_area_struct *vma)
 	return 0;
 }
 
+static ssize_t gmem_provider_read(struct gmem_inode *gi, void *buf,
+				  size_t count, loff_t *ppos)
+{
+	if (gi->provider_ops && gi->provider_ops->read)
+		return gi->provider_ops->read(gi->provider, buf, count, ppos);
+
+	return -EINVAL;
+}
+
+static ssize_t gmem_provider_write(struct gmem_inode *gi,
+				   const void *buf, size_t count,
+				   loff_t *ppos)
+{
+	if (gi->provider_ops && gi->provider_ops->write)
+		return gi->provider_ops->write(gi->provider, buf, count, ppos);
+
+	return -EINVAL;
+}
+
 static int gmem_provider_check_set_attributes(struct gmem_inode *gi, pgoff_t index,
 					      size_t nr_pages, u64 attributes)
 {
@@ -1204,7 +1239,86 @@ static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
 	}
 }
 
+static ssize_t kvm_gmem_rw(struct file *file, void __user *buf, size_t count,
+			   loff_t *ppos, bool is_write)
+{
+	struct inode *inode = file_inode(file);
+	struct gmem_inode *gi = GMEM_I(inode);
+	size_t total_done = 0;
+	loff_t isize;
+
+	if (!count)
+		return 0;
+
+	if (*ppos < 0)
+		return -EINVAL;
+
+	isize = i_size_read(inode);
+	if (*ppos >= isize)
+		return 0;
+
+	count = min_t(size_t, count, isize - *ppos);
+
+	while (count) {
+		u8 bounce[256];
+		size_t chunk = min_t(size_t, count, sizeof(bounce));
+		pgoff_t start = *ppos >> PAGE_SHIFT;
+		pgoff_t end = (*ppos + chunk - 1) >> PAGE_SHIFT;
+		pgoff_t nr_pages = end - start + 1;
+		ssize_t ret;
+
+		if (is_write) {
+			if (copy_from_user(bounce, (const char __user *)buf + total_done, chunk))
+				return total_done ?: -EFAULT;
+		}
+
+		filemap_invalidate_lock_shared(inode->i_mapping);
+
+		if (!kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
+			filemap_invalidate_unlock_shared(inode->i_mapping);
+			return total_done ?: -EFAULT;
+		}
+
+		if (is_write)
+			ret = gmem_provider_write(gi, bounce, chunk, ppos);
+		else
+			ret = gmem_provider_read(gi, bounce, chunk, ppos);
+
+		filemap_invalidate_unlock_shared(inode->i_mapping);
+
+		if (ret < 0)
+			return total_done ?: ret;
+
+		if (!ret)
+			break;
+
+		if (!is_write) {
+			if (copy_to_user((char __user *)buf + total_done, bounce, ret))
+				return total_done ?: -EFAULT;
+		}
+
+		total_done += ret;
+		count -= ret;
+	}
+
+	return total_done;
+}
+
+static ssize_t kvm_gmem_read(struct file *file, char __user *buf, size_t count,
+			     loff_t *ppos)
+{
+	return kvm_gmem_rw(file, buf, count, ppos, false);
+}
+
+static ssize_t kvm_gmem_write(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	return kvm_gmem_rw(file, (void __user *)buf, count, ppos, true);
+}
+
 static struct file_operations kvm_gmem_fops = {
+	.read		= kvm_gmem_read,
+	.write		= kvm_gmem_write,
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
@@ -1395,6 +1509,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 		goto err_inode;
 	}
 
+	file->f_mode |= FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |= O_LARGEFILE;
 	file->private_data = f;
 

-- 
2.56.0.455.g6c5a503b38-goog



