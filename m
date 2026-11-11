Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CE2606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=qUTy3JZ6
Received: by kanga.kvack.org (Postfix)
	id 7A3186B05B1; Wed, 11 Nov 2026 17:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754C46B05B2; Wed, 11 Nov 2026 17:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C896B05B3; Wed, 11 Nov 2026 17:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC516B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D28C71A04AD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:56:47 +0000 (UTC)
X-FDA: 85424349654.09.61B5273
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B14DC0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:56:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qUTy3JZ6;
	spf=pass (imf28.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437805;
	b=77NybfkzG/mSk7TJdsueR6Ada1JzYilLYBmWoisGuJ03glGwbkim3+rlS7bi4Mmhin+Kbw
	HuYaOZPIvXwGnIzWG9CiKyIbjHaxvcTHvhupEVHPE8e9jqxHeWUtfrgNHX7Siiwom3Gql9
	2/pb42nf4p964aGef+mlHGYcRg1c2Mc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qUTy3JZ6;
	spf=pass (imf28.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYMEYJ24OUuzOLV0bUm1SjvT6uAQ7Lce3VFNDOvs9Ho=;
	b=j1GymHp7BctD9UNMEh2nwb/BuPBq4uKw/k4rDrieRPZ14ooRjIjQPTU1IT4DuesRweagk0
	lHiT98RSzsIDbcSck80I5CdGV9TWMAeavWcNt2UQKObaQbSjLJwKS7lJS096JAKbFtlNUl
	9J5EPu77C0bn3Ixs1iLeknk/BYz78YQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437805; x=1825973805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yYMEYJ24OUuzOLV0bUm1SjvT6uAQ7Lce3VFNDOvs9Ho=;
  b=qUTy3JZ6q1GVUhukvkwBkXoc0yiYbfAK1tIkorx4M1dZDZKdTKhwmtv6
   CDWX5x9o9un3507pdvlpD7V7oSho1O7KycGqT3bc6rV+yWjubC5foRAuy
   0zgI+NTjGtgbNIQHBrmtCt41wMLz31/PbMEItIeRT4SmFbzb0sJe6B8+G
   xaWlwr5qu5euvunmeluoGkbmzUnGxyzdGJHBxRotOQGWbYR6fvsgttQ/d
   XdHg03SaZeu4ariaNQ8SN3iIWEU4KwPSXtvMzd4Ndm3QGtyMRaK0tUkyy
   fZzWxnhW8EBv7g6Xucar3VoPFrvPBhqkmnVFOU9LfDhxuYxyi+xARlbcw
   Q==;
X-CSE-ConnectionGUID: Dl2d7JYFSKy27U++yBuEJQ==
X-CSE-MsgGUID: flCm2CKaQkaLMiISwRyCOg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33769754"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:56:43 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:26998]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.231:2525] with esmtp (Farcaster)
 id f6d7f87e-fc72-4657-b064-553b276f0156; Wed, 11 Nov 2026 22:56:43 +0000 (UTC)
X-Farcaster-Flow-ID: f6d7f87e-fc72-4657-b064-553b276f0156
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:56:43 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:56:40 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 14/40] nitro_enclaves: Add NE_SET_INFO_PAGE
Date: Wed, 11 Nov 2026 22:56:38 +0000
Message-ID: <502b33c4d212373d67006e47bf1c4882d9a4ad95.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4B14DC0005
X-Stat-Signature: spcojjakrpja4g5hsfia4bj4b695n8tu
X-Rspam-User: 
X-HE-Tag: 1794437805-205486
X-HE-Meta: U2FsdGVkX1/Vr4gOHi3x9k9gtPyHQDthdWQOwXA96sdAKxrMdQs2tnW2u1ihyG+JYbHPeBxVYFI5vptzR37Hgb2Vx92APwoIqpeFuOJS4GJzVUSDhV85IM44iQFS9yZtv0WTw7IWLqXABe9lFbKiQYBxjI1c+odGqdR/9AVjDc1P8ml5gTQUO6yIRGHY/8Y1CTWZNbV/0SP1ESWBY+SLCPT1Q6gu2YBTZElHsHjik4oJNCSW1UHB7ikO2Dt0JmZ0CfEkNkx0SQVrHWWpcxOut11rY1E5q4tZGrSg5sqicBaMR8ud67niUtLcUMbRW2owFZOfZtKNRZC33dumKvuaciGd3oSjffSaLztouhwtESu4LqwhkUretzRVZB9ijZVECIAKW+jKibXRPepV9mhwsS6fFPreJ4Hj/ChNRNQ1ZmhDE5yu6qBEd8K6ubg8Mr/5N1SM1Nw2IUPMnejTXQG+4sor42Ln9hu/ggdIcziq08Wn6NEdRU5/bYX0/N12OcA7KSS3lkLXUCADnnb8QQVEYGmIasr9Mm2S82Q4PAjOxGPU5xBhvZzjU1eucjPA8o4aa6D24ThBnN40Oqvfd8vopD6xPOHNqeoH/Xp81GawSCW+0tvC0Ls95Ugk1SgQSRvLa0HbmBhPc08sYrgyjmqwkgIsoKLz7mciRwh/VnnDzHm0ldegnups7R5O0S5RjL+Hyf1IlgH78Jm05tEQcpEih9/e/b6wp47nORSu8nLgm+lFio7iaN42dhA/t51SebQUfCdGQADwfYi4hYy3Hfsd3ma+Faz/f6Fxkj1sEn4k3VBgm6cg9YbjOQDAohTqWcmL1yzefKfV+zz7M1Jt0zAZF8LXAqbTOQvyoghhynm9UeEw/DjK7dQeMMMMVxNOcowy1KGcBDCCl8DFEcZ1OnMYD5G2RZu6tF3bMxYSBMXl+vxZS4sARZsAC1hL0IintudC8BpXagqn2OVNwmItpTW
 TlFupQQj
 BpdPl+suTFdNKVGewSGdqbXLnLsdJ81oigMYkybDTQYkGS4JHs188aOvgsaY5diOcP1GQd/l10wyEHsDeDubuKp2owIrVhSBDNWuuB43QuKNnQM9X0t1vGU4Qr3uFSH8NBU+S/ZNAObNGmuPltuG4DpeETZIRnxZzjx38SWb0sj6nJ9bLdzehNbN7HCBf/j1htjn9Xp2GsuSo+3vXy7yb6+Zom0X9aAEOJZ9+rY+IiTdGUihI1m8VkeWnekrADSfzjU9ytcdtxsPNm7q371PPOl+YzxvSnOW1t83oGeshf/HmU3uCLALCjE38PgCoq8965rkBrB+ZFxbZzRKjx3qd3MStcYT9RY/j2fmjwMvTvLmJL6nn0stfZ/8XZ6UmVjsFjORGI4Vt/lFByAlKl1gFlcX146W0RAlqp5cjTL63v4cBuDqUWZdlAspmlfsnWTVkRt+00FXSIJlKd1Ha+6S8H2cCcAXaqOlOWsdGfQxX7nN8nAiyrtupLDdv+4vR5f381AA0U7OqXZLa6wOWPZmOTmVAJ8OkKYip3zfd3lNZm0QxUgN4U6QUNFxQI2WjNmwHdBoqM9cxaO4nVJBQY6JtnRqu3x8CTT4iUsky4thE/BRj+6QmGUGX5EqiKlOmtbStChrTMZs69xDfcnMy9VCo8sleNweE6cR+UTVWL4QGfR/yAZOcxTU2P38s3mbl9O4UpU8Vjz4YfFDdeEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes introduce the info page, a page of parent memory that
the device writes and the parent reads, to share various information about
the state of devices inside the slot.

Add the NE_SET_INFO_PAGE ioctl to register a NE_MEMORY_SHARED allocation
as info page. This page is always read-only to user space.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 276 +++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  35 ++-
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  25 ++
 drivers/virt/nitro_enclaves/ne_pci_dev.h  |  21 ++
 include/uapi/linux/nitro_enclaves.h       | 106 ++++++++-
 5 files changed, 435 insertions(+), 28 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 0bf62f703806e..610d98264e5a1 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -123,6 +123,8 @@ static int ne_add_memory_region_ioctl(struct ne_enclave *ne_enclave,
 				      struct ne_add_memory_region_args *args);
 static int ne_alloc_memory_ioctl(struct ne_enclave *ne_enclave,
 				 struct ne_alloc_memory_args *args);
+static int ne_set_info_page_ioctl(struct ne_enclave *ne_enclave,
+				  struct ne_set_info_page_args *args);
 static const struct file_operations ne_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
@@ -2137,6 +2139,39 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		return rc;
 	}
 
+	case NE_EA_IOCTL(NE_SET_INFO_PAGE): {
+		struct ne_set_info_page_args __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_set_info_page_args args;
+		int rc;
+
+		if (usize < offsetofend(struct ne_set_info_page_args, flags))
+			return -EINVAL;
+
+		rc = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+		if (rc)
+			return rc;
+
+		rc = mutex_lock_killable(&ne_enclave->enclave_info_mutex);
+		if (rc)
+			return rc;
+
+		if (ne_enclave->state != NE_STATE_INIT) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave is not in init state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_NOT_IN_INIT_STATE;
+		}
+
+		rc = ne_set_info_page_ioctl(ne_enclave, &args);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return rc;
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -2344,6 +2379,9 @@ static void ne_enclave_free(struct ne_enclave *ne_enclave)
 	ne_enclave_remove_all_mem_region_entries(ne_enclave);
 	ne_enclave_remove_all_vcpu_id_entries(ne_enclave);
 
+	if (ne_enclave->info_file)
+		fput(ne_enclave->info_file);
+
 	kfree(ne_enclave);
 }
 
@@ -3152,6 +3190,9 @@ static bool ne_contig_supports_mmap(struct file *file)
  * asks for VM_HUGEPAGE because a fault on a VM_PFNMAP mapping without it only
  * reaches ->huge_fault where the transparent_hugepage policy is "always".
  *
+ * An allocation that is a slot's info page is mapped without write access, and
+ * without the right to gain it with mprotect().
+ *
  * Return: 0 on success, negative return value on failure.
  */
 static int ne_contig_mmap_prepare(struct vm_area_desc *desc)
@@ -3177,6 +3218,13 @@ static int ne_contig_mmap_prepare(struct vm_area_desc *desc)
 	if (offset > mem->size || size > mem->size - offset)
 		return -EINVAL;
 
+	if (READ_ONCE(mem->read_only)) {
+		if (vma_desc_test(desc, VMA_WRITE_BIT))
+			return -EACCES;
+
+		vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
+	}
+
 	desc->vm_ops = &ne_contig_vm_ops;
 	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
 			   VMA_DONTDUMP_BIT, VMA_DONTCOPY_BIT, VMA_HUGEPAGE_BIT);
@@ -3242,11 +3290,12 @@ static int ne_write_span(void *arg, struct page *page, u64 off, u64 len)
  * refusal is -EFBIG, the same as generic_write_check_limits() gives for a write
  * beyond s_maxbytes. There is no RLIMIT_FSIZE in it, so no SIGXFSZ either.
  *
- * Donating an allocation closes this path, and @lock is what makes the two
- * orderly. It is taken here and in ne_add_memory_region_ioctl() and nowhere
- * else; setting a mapping up and faulting one in both read only fields that
- * never change, so nothing takes it under mmap_write_lock or in a fault, and
- * copying from user space under it cannot invert against the fault path.
+ * Donating an allocation closes this path, and so does making it an info page.
+ * This function, ne_add_memory_region_ioctl(), ne_contig_make_read_only() and
+ * ne_contig_allow_writes() take @lock, which orders those state changes against
+ * a write. Setting a mapping up and faulting one in do not take it, so nothing
+ * takes it under mmap_write_lock or in a fault, and copying from user space
+ * under it cannot invert against the fault path.
  *
  * Return: the number of bytes written, or a negative return value on failure.
  */
@@ -3266,7 +3315,7 @@ static ssize_t ne_contig_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	guard(mutex)(&mem->lock);
 
-	if (mem->donated)
+	if (mem->donated || mem->read_only)
 		return -EPERM;
 
 	rc = ne_walk_allocs(mem, pos, count, NE_WRITE_SPAN_PAGES, ne_write_span,
@@ -3281,6 +3330,60 @@ static ssize_t ne_contig_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	return rc;
 }
 
+/**
+ * ne_contig_make_read_only() - Take write access to an allocation away from
+ *				user space.
+ * @file:	The allocation's file.
+ *
+ * From here on a write to the descriptor fails and a new mapping has no write
+ * access, so only the device and the kernel change the memory. The descriptor
+ * is open for writing, so a mapping made before could be made writable with
+ * mprotect(), and one that exists makes this fail.
+ *
+ * mmap_region() raises i_mmap_writable with full ordering before it calls
+ * ne_contig_mmap_prepare() for a mapping that may write, and the mapping keeps
+ * it raised for as long as it exists. @read_only is set before the count is
+ * read, so a mapping that ne_contig_mmap_prepare() set up without seeing it is
+ * counted here. A mapping that is being set up as this runs counts too, even
+ * one that ends up without write access, so a caller sees -EBUSY for it and
+ * can try again.
+ *
+ * Return: 0 on success, -EBUSY if the allocation is mapped.
+ */
+static int ne_contig_make_read_only(struct file *file)
+{
+	struct ne_contig_mem *mem = file->private_data;
+
+	guard(mutex)(&mem->lock);
+
+	WRITE_ONCE(mem->read_only, true);
+
+	/* Pairs with the full ordering of mapping_map_writable(). */
+	smp_mb();
+
+	if (mapping_writably_mapped(file->f_mapping)) {
+		WRITE_ONCE(mem->read_only, false);
+
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/**
+ * ne_contig_allow_writes() - Give write access to an allocation back to user
+ *			      space.
+ * @file:	The allocation's file.
+ */
+static void ne_contig_allow_writes(struct file *file)
+{
+	struct ne_contig_mem *mem = file->private_data;
+
+	guard(mutex)(&mem->lock);
+
+	WRITE_ONCE(mem->read_only, false);
+}
+
 /**
  * ne_contig_release() - Free an allocation once nothing holds it any more.
  * @inode:	The allocation's inode, unused.
@@ -3612,6 +3715,13 @@ static int ne_add_memory_region_ioctl(struct ne_enclave *ne_enclave,
 		return -EINVAL;
 	}
 
+	if (fd_file(f) == ne_enclave->info_file) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The allocation is the enclave's info page\n");
+
+		return -NE_ERR_MEM_REGION_ALREADY_USED;
+	}
+
 	list_for_each_entry(held, &ne_enclave->contig_regions_list, list) {
 		if (held->file == fd_file(f)) {
 			dev_err_ratelimited(ne_misc_dev.this_device,
@@ -3714,6 +3824,160 @@ static int ne_add_memory_region_ioctl(struct ne_enclave *ne_enclave,
 	return rc;
 }
 
+/**
+ * ne_set_info_page_ioctl() - Give the slot associated with the current enclave
+ *			      the info page.
+ * @ne_enclave:	Private data associated with the current enclave.
+ * @args:	Descriptor for the allocation, and flags.
+ *
+ * The device writes the info page, so the run behind it has to stay where the
+ * device was told it is for as long as the enclave lives. The runs belong to the
+ * file, so a reference on it keeps them whatever user space does with the
+ * descriptor and its mappings, and ne_enclave_free() drops that reference
+ * after SLOT_FREE and after the enclave's memory regions. The reference is taken
+ * before the request, since a request that timed out may still be completed by
+ * the device. A rejected request drops it again.
+ *
+ * Only the device writes the page, and the parent reads back from it what the
+ * device reports about the slot, so user space loses write access to the
+ * allocation before the device is told about it and gets it back only if the
+ * device rejects the request.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ * * -ETIMEDOUT if the device did not answer, in which case the slot keeps the
+ *   allocation until the enclave goes away.
+ */
+static int ne_set_info_page_ioctl(struct ne_enclave *ne_enclave,
+				  struct ne_set_info_page_args *args)
+{
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	struct slot_add_info_page_req req = {};
+	struct pci_dev *pdev = ne_devs.ne_pci_dev->pdev;
+	struct ne_contig_mem *mem = NULL;
+	int rc = -EINVAL;
+
+	if (ne_enclave->mm != current->mm)
+		return -EIO;
+
+	if (args->flags) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Incorrect flag for info page\n");
+
+		return -NE_ERR_INVALID_FLAG_VALUE;
+	}
+
+	if (ne_enclave->info_file) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The slot already has an info page\n");
+
+		return -EEXIST;
+	}
+
+	CLASS(fd, f)(args->fd);
+
+	if (fd_empty(f))
+		return -EBADF;
+
+	if (fd_file(f)->f_op != &ne_contig_fops) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Not an enclave memory allocation\n");
+
+		return -EINVAL;
+	}
+
+	mem = fd_file(f)->private_data;
+
+	if (mem->enclave_id != ne_enclave->id) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Allocation was made for another enclave\n");
+
+		return -EINVAL;
+	}
+
+	if (!mem->shared) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The info page allocation is not shared\n");
+
+		return -EINVAL;
+	}
+
+	/*
+	 * The device takes one address and one length, so an allocation the
+	 * allocator had to satisfy in several runs has no single address to
+	 * name. A request of NE_MIN_MEM_REGION_SIZE cannot be split, since the
+	 * allocator has nothing smaller to fall back to.
+	 */
+	if (mem->nr_allocs != 1) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The info page allocation is not one run\n");
+
+		return -EINVAL;
+	}
+
+	/*
+	 * An allocation the enclave already has as memory is not available to
+	 * be its info page as well, since the device would be handed the same
+	 * run twice in two roles. @donated is only ever set from
+	 * ne_add_memory_region_ioctl(), which runs under the same enclave mutex
+	 * as this function for the one enclave the allocation was made for, so
+	 * the read needs no lock of its own.
+	 */
+	if (mem->donated) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The info page allocation was donated\n");
+
+		return -NE_ERR_MEM_REGION_ALREADY_USED;
+	}
+
+	rc = ne_contig_make_read_only(fd_file(f));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The info page allocation is mapped\n");
+
+		return rc;
+	}
+
+	req.slot_uid = ne_enclave->slot_uid;
+	req.info_phys = page_to_phys(mem->allocs[0].page);
+	req.info_size = mem->size;
+
+	/*
+	 * Take the reference before the request, so that the run stays where the
+	 * device is told it is from the moment the device is told, as the memory
+	 * region path does.
+	 */
+	ne_enclave->info_file = get_file(fd_file(f));
+
+	rc = ne_do_request(pdev, SLOT_ADD_INFO_PAGE,
+			   &req, sizeof(req), &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in slot add info page [rc=%d]\n", rc);
+
+		/*
+		 * A request the device never answered was submitted with the
+		 * run's physical address in it, so the device may write the page
+		 * yet. Keep the reference and let ne_enclave_free() drop it
+		 * after SLOT_FREE. Every other error means the device either
+		 * never saw the request or answered to reject it, and the run is
+		 * the parent's again. ne_request_unanswered() tells the two
+		 * apart.
+		 */
+		if (!ne_request_unanswered(rc)) {
+			ne_contig_allow_writes(ne_enclave->info_file);
+			fput(ne_enclave->info_file);
+			ne_enclave->info_file = NULL;
+		}
+
+		return rc;
+	}
+
+	return 0;
+}
+
 #if defined(CONFIG_NITRO_ENCLAVES_MISC_DEV_TEST)
 #include "ne_misc_dev_test.c"
 #endif
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 2502cca3f3f64..d0d1973bfbe9d 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -38,27 +38,37 @@ struct ne_contig_alloc {
  * @allocs:	Contiguous runs backing the allocation, ordered by offset.
  * @nr_allocs:	Number of runs in @allocs.
  * @size:	Size of the allocation in bytes, mirrored in i_size.
- * @shared:	Whether the allocation may be mapped by the caller.
+ * @shared:	Whether the caller asked for a shared allocation. A shared one may
+ *		be mapped by the caller and may be a slot's info page; a private
+ *		one is neither.
  * @enclave_id:	Id of the enclave the allocation was made for.
  * @mm:		The mm charged for the pinned pages, held via mmgrab().
  * @nr_pinned:	Pages charged to @mm->pinned_vm.
- * @lock:	Serialises a write against the donation that ends writing.
+ * @lock:	Serialises a write against the donation or the info page that
+ *		ends writing.
  * @donated:	Whether the allocation has been given to its enclave.
+ * @read_only:	Whether user space has lost write access to the allocation,
+ *		which it does when the allocation becomes a slot's info page.
  *
  * The runs hang off the file, so that closing the last descriptor does not free
  * memory an enclave is still using: a donated region holds the file with
- * get_file(). That is also what keeps a mapping's page table entries from
- * outliving the runs, since a VMA holds vm_file for as long as it exists.
+ * get_file(), and so does the enclave the allocation is the info page of. That
+ * is also what keeps a mapping's page table entries from outliving the runs,
+ * since a VMA holds vm_file for as long as it exists.
  *
  * The array is built before the file is published and not mutated afterwards, so
  * any holder of a reference can read it without a lock of its own, which is what
  * lets a page fault resolve an offset to a run. @shared and @size are set in the
- * same place and are read the same way. @donated is the one field that changes
- * after publication, and @lock covers it.
+ * same place and are read the same way. @donated and @read_only are the fields
+ * that change after publication. @lock covers both on the write path;
+ * ne_set_info_page_ioctl() reads @donated under the enclave mutex its writer also
+ * holds, and ne_contig_mmap_prepare() reads @read_only without a lock, which
+ * ne_contig_make_read_only() orders against.
  *
  * @enclave_id is compared, never dereferenced, and the counter it comes from is
- * 64 bits wide, so an allocation cannot be donated to a later enclave that
- * happens to have been placed at the address of the one it was made for.
+ * 64 bits wide, so an allocation cannot be donated to, or become the info page
+ * of, a later enclave that happens to have been placed at the address of the one
+ * it was made for.
  */
 struct ne_contig_mem {
 	struct ne_contig_alloc	*allocs;
@@ -68,9 +78,10 @@ struct ne_contig_mem {
 	u64			enclave_id;
 	struct mm_struct	*mm;
 	unsigned long		nr_pinned;
-	/* Serialises a write against the donation that ends writing. */
+	/* Serialises a write against what ends writing. */
 	struct mutex		lock;
 	bool			donated;
+	bool			read_only;
 };
 
 /**
@@ -116,6 +127,11 @@ struct ne_mem_region {
  * @id:				Id of this enclave, unique for the lifetime of the
  *				driver, recorded in an %NE_ALLOC_MEMORY allocation
  *				as the enclave it was made for.
+ * @info_file:			File of the %NE_ALLOC_MEMORY allocation the slot
+ *				was given as its info page, held with get_file()
+ *				so that the device keeps the page after user space
+ *				has closed the descriptor. NULL until
+ *				%NE_SET_INFO_PAGE is called.
  * @max_mem_regions:		The maximum number of memory regions that can be
  *				handled by the hypervisor.
  * @mem_regions_list:		Enclave user space memory regions list.
@@ -146,6 +162,7 @@ struct ne_enclave {
 	wait_queue_head_t	eventq;
 	bool			has_event;
 	u64			id;
+	struct file		*info_file;
 	u64			max_mem_regions;
 	struct list_head	mem_regions_list;
 	u64			mem_size;
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index f258e04ee9e47..a07dbc6d8a9b7 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -128,6 +128,31 @@ static int ne_wait_for_reply(struct pci_dev *pdev, unsigned int timeout_msecs)
 	return 0;
 }
 
+/**
+ * ne_request_unanswered() - Whether a failure left a submitted request in
+ *			     flight.
+ * @rc:		Failure a command request came back with.
+ *
+ * A request the device never answered was submitted with whatever the caller
+ * put in it, and there is nothing to cancel it with, so a resource whose
+ * address is in it may still be written by the device. A caller that has to
+ * decide who owns such a resource asks here instead of naming an errno of its
+ * own.
+ *
+ * Every code the wait for a reply can fail a submitted request with belongs
+ * here. ne_wait_for_reply() times out, so -ETIMEDOUT is named. A code raised
+ * before ne_submit_request(), and a code the device answered with, do not:
+ * nothing is in flight in either case. A
+ * device that answers one of the codes named here of its own accord lands here
+ * too and costs one held resource, which is the side to be wrong on.
+ *
+ * Return: true if the request may still be in flight.
+ */
+bool ne_request_unanswered(int rc)
+{
+	return rc == -ETIMEDOUT;
+}
+
 /**
  * ne_cmd_frees_slot() - Whether a command is one of the two that free a slot.
  * @cmd_type:	Command type of the request.
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index b0957e2606ec3..4f670c53dd3c0 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -123,6 +123,8 @@
  * @NEXT_SLOT:			Get the next slot in the list of allocated slots.
  * @SLOT_INFO:			Get the info for a slot e.g. slot uid, vCPUs count.
  * @SLOT_ADD_BULK_VCPUS:	Add a number of vCPUs, not providing CPU ids.
+ * @SLOT_ADD_INFO_PAGE:		Give a slot the info page, a memory region the
+ *				device writes.
  * @MAX_CMD:			A gatekeeper for max possible command type.
  */
 enum ne_pci_dev_cmd_type {
@@ -138,6 +140,8 @@ enum ne_pci_dev_cmd_type {
 	NEXT_SLOT		= 9,
 	SLOT_INFO		= 10,
 	SLOT_ADD_BULK_VCPUS	= 11,
+	/* 12 is a command this driver does not implement. */
+	SLOT_ADD_INFO_PAGE	= 13,
 	MAX_CMD,
 };
 
@@ -266,6 +270,20 @@ struct slot_add_bulk_vcpus_req {
 	u64	nr_vcpus;
 };
 
+/**
+ * struct slot_add_info_page_req - SLOT_ADD_INFO_PAGE request.
+ * @slot_uid:	Slot unique id mapped to the slot to give the info page to.
+ * @flags:	Flags for the info page. Zero is the only value the driver sends.
+ * @info_phys:	Physical address of the info page.
+ * @info_size:	Size, in bytes, of the info page.
+ */
+struct slot_add_info_page_req {
+	u64	slot_uid;
+	u64	flags;
+	u64	info_phys;
+	u64	info_size;
+};
+
 /**
  * struct ne_pci_dev_cmd_reply - NE PCI device command reply.
  * @rc :		Return code of the logic that processed the request.
@@ -327,6 +345,9 @@ struct ne_pci_dev {
 	struct pci_dev		*pdev;
 };
 
+/* Whether a failure left a submitted request in flight. */
+bool ne_request_unanswered(int rc);
+
 /**
  * ne_do_request() - Submit command request to the PCI device based on the command
  *		     type and retrieve the associated reply.
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 6dd00c41c07d5..4f604712983f1 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -287,13 +287,15 @@ struct ne_alloc_memory_args {
 
 /**
  * NE_ALLOC_MEMORY - The command is used to allocate physically contiguous
- *		     memory to give to an enclave with %NE_ADD_MEMORY_REGION,
- *		     drawn from one host NUMA node. The argument is input only;
+ *		     memory to give to an enclave with %NE_ADD_MEMORY_REGION or
+ *		     to provide to the device with %NE_SET_INFO_PAGE, drawn from
+ *		     one host NUMA node. The argument is input only;
  *		     on success the return value is a file descriptor for the
  *		     allocation.
  *		     Writing to the descriptor places bytes in the allocation,
  *		     which is how an enclave image gets there, and stops
- *		     working once the allocation has been donated.
+ *		     working once the allocation has been donated or provided
+ *		     with %NE_SET_INFO_PAGE.
  *		     O_APPEND has no effect. There is no read operation, so
  *		     read() and pread() both fail with EINVAL and a caller that
  *		     wants to check what it wrote keeps its own copy.
@@ -308,16 +310,18 @@ struct ne_alloc_memory_args {
  *		     allocation over, including once the allocation has been
  *		     donated and writing to the descriptor has stopped working.
  *		     Such a mapping is readable too, which is the only way to
- *		     read allocated memory back. The mapping is not inherited
- *		     across fork(); a child that needs one maps the descriptor
- *		     itself.
+ *		     read allocated memory back, and is how a parent reads an
+ *		     info page provided with %NE_SET_INFO_PAGE, which it maps
+ *		     without %PROT_WRITE. The mapping is not inherited across
+ *		     fork(); a child that needs one maps the descriptor itself.
  *		     Donating does not take a mapping away, so a parent that
  *		     mapped a shared allocation can still write to it through
  *		     that mapping afterwards.
  *		     The allocation lives until the last of the descriptor, its
- *		     mappings and the enclave regions donated from it is gone,
- *		     so a caller can close the descriptor as soon as it has
- *		     donated.
+ *		     mappings, the enclave regions donated from it and the
+ *		     enclave it is the info page of is gone, so a caller can
+ *		     close the descriptor as soon as it has donated it or
+ *		     provided it to the device.
  *		     The ioctl can be invoked on the enclave fd, before an
  *		     enclave is started.
  *
@@ -351,7 +355,8 @@ struct ne_alloc_memory_args {
  *
  * Writing to the descriptor sets errno to:
  * * EPERM			- The allocation has been donated with
- *				  %NE_ADD_MEMORY_REGION.
+ *				  %NE_ADD_MEMORY_REGION or provided with
+ *				  %NE_SET_INFO_PAGE.
  * * EFBIG			- The write does not fit inside the allocation.
  * * EFAULT			- Part of the buffer is not readable. Any bytes
  *				  copied before that are reported as a short
@@ -361,6 +366,9 @@ struct ne_alloc_memory_args {
  *
  * An mmap() of the descriptor sets errno to:
  * * ENODEV			- The allocation is %NE_MEMORY_PRIVATE.
+ * * EACCES			- The mapping asks for %PROT_WRITE and the
+ *				  allocation has been provided with
+ *				  %NE_SET_INFO_PAGE.
  * * EINVAL			- The mapping is %MAP_PRIVATE, or its offset or
  *				  length is not a multiple of 2 MiB, or it does
  *				  not fit inside the allocation.
@@ -388,7 +396,8 @@ struct ne_add_memory_region_args {
  *			  contiguous run it is made of, or fewer where runs turn
  *			  out to be physically adjacent. The argument is input
  *			  only. The allocation has to have been made for this
- *			  enclave, and can be given away once.
+ *			  enclave, cannot be its info page, and can be given away
+ *			  once.
  *			  Writing to the descriptor stops working here, so an
  *			  enclave image goes in before this call. The allocation
  *			  has to be %NE_MEMORY_PRIVATE, since memory the parent
@@ -425,13 +434,82 @@ struct ne_add_memory_region_args {
  *					  before being started).
  * * NE_ERR_INVALID_FLAG_VALUE		- The value of the provided flag is invalid.
  * * NE_ERR_MEM_REGION_ALREADY_USED	- The allocation was already given to the
- *					  enclave.
+ *					  enclave, or is its info page.
  * * NE_ERR_MEM_MAX_REGIONS		- The number of memory regions set for the
  *					  enclave reached maximum.
  * * Error codes from the NE PCI device request.
  */
 #define NE_ADD_MEMORY_REGION		_IOW(0xAE, 0x2F, struct ne_add_memory_region_args)
 
+/**
+ * struct ne_set_info_page_args - Allocation to provide to the device (in).
+ * @fd:		Descriptor from %NE_ALLOC_MEMORY, made for this enclave, asked
+ *		for as %NE_MEMORY_SHARED, and made of one contiguous run.
+ * @flags:	Must be zero.
+ */
+struct ne_set_info_page_args {
+	__s32	fd;
+	__u32	flags;
+};
+
+/**
+ * NE_SET_INFO_PAGE - The command is used to give an enclave's slot the info
+ *		      page, a %NE_ALLOC_MEMORY allocation the device writes. The
+ *		      argument is input only. The allocation has to be
+ *		      %NE_MEMORY_SHARED, since a mapping is the only way for
+ *		      the parent to read an allocation back. It also has to be
+ *		      one contiguous run, since the device is given one address
+ *		      and one length for it, and a request of 2 MiB is the one
+ *		      size the allocator cannot come back from in several runs.
+ *		      The info page is not enclave memory: it does not count
+ *		      towards the memory regions %NE_ADD_MEMORY_REGION fills.
+ *		      Only the device writes the page, so from this call on the
+ *		      allocation is read-only to user space: writing to the
+ *		      descriptor fails, and the descriptor is mapped without
+ *		      %PROT_WRITE. A mapping made before the call could still be
+ *		      made writable, so the call fails while one exists, and a
+ *		      caller maps the page after the call. A call the device
+ *		      rejects leaves the allocation writable again.
+ *		      A slot takes one info page, and an allocation is either an
+ *		      enclave's memory or its info page. The driver holds the
+ *		      allocation until the enclave is gone, so closing the
+ *		      descriptor does not free the run the device was given.
+ *		      The ioctl can be invoked on the enclave fd, before an
+ *		      enclave is started.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0					- Logic successfully completed.
+ * * -1					- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * ENODEV				- The NE PCI device is not available.
+ * * EFAULT				- Argument read failure.
+ * * EBADF				- @fd is not an open file descriptor.
+ * * EINVAL				- The argument is shorter than @flags, or @fd
+ *					  is not a descriptor from %NE_ALLOC_MEMORY,
+ *					  or the allocation was made for another
+ *					  enclave, or it is %NE_MEMORY_PRIVATE, or it
+ *					  is made of more than one contiguous run.
+ * * EIO				- Current task mm is not the same as the one
+ *					  that created the enclave.
+ * * EEXIST				- The slot already has an info page.
+ * * EBUSY				- The allocation has a mapping made before the
+ *					  call, or one is being set up.
+ * * E2BIG				- The argument is longer than this kernel knows
+ *					  about and the excess is not all zero.
+ * * NE_ERR_NOT_IN_INIT_STATE		- The enclave is not in init state (init =
+ *					  before being started).
+ * * NE_ERR_INVALID_FLAG_VALUE		- The value of the provided flag is invalid.
+ * * NE_ERR_MEM_REGION_ALREADY_USED	- The allocation was already given to the
+ *					  enclave with %NE_ADD_MEMORY_REGION.
+ * * ETIMEDOUT				- The device did not answer. The slot keeps
+ *					  the allocation, read-only, until the
+ *					  enclave is gone, since the device may
+ *					  still write the page.
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_SET_INFO_PAGE		_IOW(0xAE, 0x25, struct ne_set_info_page_args)
+
 /**
  * NE_START_ENCLAVE - The command is used to trigger enclave start after the
  *		      enclave resources, such as memory and CPU, have been set.
@@ -775,7 +853,9 @@ struct ne_user_memory_region {
  *		      it has been donated. It costs page tables for the part of
  *		      it a caller touches, and it leaves the memory reachable
  *		      from the parent for as long as it lives, so an allocation
- *		      that is only being handed over does not ask for one.
+ *		      that is only being handed over does not ask for one. It is
+ *		      also what an allocation given to %NE_SET_INFO_PAGE has to
+ *		      be.
  */
 #define NE_MEMORY_SHARED		(0x01)
 
-- 
2.47.1


