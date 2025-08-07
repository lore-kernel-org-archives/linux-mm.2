Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BF2C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 22:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECAB6B0088; Thu,  7 Aug 2025 18:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C40C6B008A; Thu,  7 Aug 2025 18:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9B56B0093; Thu,  7 Aug 2025 18:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACE96B0088
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:14:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAE2F82C13
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 22:14:47 +0000 (UTC)
X-FDA: 83751367014.23.7F35094
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFD66180009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 22:14:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bms3GW0t;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3VCWVaAsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3VCWVaAsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754604886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfxYlW2qMJC6ED5bCsPHTl22hm4a2dt17JIaMaifM1o=;
	b=IyOHDjy/UH78rw2agov19x88/ADkxoiTrm+dJ2qgCVtgphyJQCVRi0tjpC+sn6AH1O/4U9
	wju+mhzN9DgkJmhJ7teXyxlK1j8DtO8OUoj7qOemD2vglrcPu4ofYU2CB0KHOyRndtDNp+
	Iq+z0qRzu/OWFSNm6DyGwYe6XY6c2s8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754604886; a=rsa-sha256;
	cv=none;
	b=PC4tcqe9RTSUUZbJKxgt0+k99Ni/n2wFbu7yKg7NyZGYGkaK7wCu7nOFPg9WtB9ANLVzYb
	DFvvdOQc8j1+BTW9dv4EswPLgakTHdrB0QX+p3s4dVgzCxPpB3W3MWkAxnFZB+bKfqNBa8
	/p3lyVHDCB+ca8azayiSdw6DUqFttkw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bms3GW0t;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3VCWVaAsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3VCWVaAsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ecb3a3d0aso1390781a91.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 15:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754604885; x=1755209685; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UfxYlW2qMJC6ED5bCsPHTl22hm4a2dt17JIaMaifM1o=;
        b=bms3GW0tlPmxCCvIVl2MkzYTgml7CPxTvKo8zb3BF2cctwxCxm657jslO37M7tW/Gg
         JkHfyL4indWDBHVKCHlIVlckvEA6fCy/tsWarHeGoNnXKag5vdil3Jz/SoC9ubD4szTd
         JmS2npq2IRfjOL03k7LKN7lNDVp/s5CFnnl0itOhvFEbDXeireERAw1hXnABrmUfv2t5
         r1dToeR/6SF/CqiK53a6/sWOmBnfT4h2FCwqje4rrf2jrCHFuqcDzUhyAMinW8iwonNZ
         L3LsfrGmLNLebJg1qaJTZcJD8i78hfC9lxmqhx1wQeVWfddqQWz6MIJtJYT3hnKJkt+S
         s32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754604885; x=1755209685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UfxYlW2qMJC6ED5bCsPHTl22hm4a2dt17JIaMaifM1o=;
        b=ZsM8SO/XUTE4PJSnTLzF4U05sZdDWLk6/GSN0En3Xwgj+Y6U5igo85nZxd3WHd7EBf
         U/ccRGiaevJ33aigFkawFe+9p6zZ8NK2buqG/uYJxaph168ajpo4UuqkYCHYea/Yto3U
         cyVTMdcvrA/vrLgc4wHW4C6AcWu058fvsB4rtqxJ2mAQqHAt7bTLZXG6Ffq9vfcgNSCv
         OnVkNRsrcnr6zMptroyt7wdVLYIAuhIBKsMedU5jmdgrPZeyXPnmx9gvgf+/2yzIYzAu
         po9jfvXine++OxBNm+e6EEcOBwQNBEoz5u80pg6C7OGBhbXgX4EIqfXn7Q6jQMTWqLhM
         BtpA==
X-Forwarded-Encrypted: i=1; AJvYcCUcA66jVKnieUHBU+AYk101f5fJpGVsu8oRVTjOr2g2QKnkL0JVNoTCbcoswIOruI3Iek750dQLXQ==@kvack.org
X-Gm-Message-State: AOJu0Yxwc35NRdA/ZxpA7UczVkv0hjiwW9wntz27V7QB52oJcR+XdH26
	eXMx+GqUMX+Vaa9N/yGSxhc/V5l1l5NGSfvEbKloTjc46Uht299gg7yb2UI9GmIVdavv4/Ko/1M
	dKODEY9Qq1ehJQnSaYapzv+BXeQ==
X-Google-Smtp-Source: AGHT+IG5jNphm0eq8JKWIiHMQnDqV1k9N3zpO9NfBB3SQdGjJcZ4B0Cgeoq+hULf5zIEBAON8V8CKg4Vp024w4Pluw==
X-Received: from pjbnw14.prod.google.com ([2002:a17:90b:254e:b0:31e:3c57:ffc8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a06:b0:31f:6ddd:eef with SMTP id 98e67ed59e1d1-32183b3f4e7mr781688a91.21.1754604884089;
 Thu, 07 Aug 2025 15:14:44 -0700 (PDT)
Date: Thu, 07 Aug 2025 15:14:42 -0700
In-Reply-To: <diqz4iui4y00.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250713174339.13981-2-shivankg@amd.com> <20250713174339.13981-4-shivankg@amd.com>
 <1e37e4e7-aa7b-4a2a-b1aa-1243f8094dcb@redhat.com> <diqz4iui4y00.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqz1ppm4w4t.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH V9 1/7] KVM: guest_memfd: Use guest mem inodes instead of
 anonymous inodes
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, seanjc@google.com, 
	vbabka@suse.cz, willy@infradead.org, akpm@linux-foundation.org, 
	shuah@kernel.org, pbonzini@redhat.com, brauner@kernel.org, 
	viro@zeniv.linux.org.uk
Cc: paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DFD66180009
X-Stat-Signature: m75ditiuatmnbz8zi19x9pjp8fnmz14g
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754604885-189952
X-HE-Meta: U2FsdGVkX19uwRvf8W1bImGEi/IvrecdM5XPMM2SuPppLjUbyZtm14/f2y17RwPaA15aHxtTRHJTYV6VWmjR/2el/CnD/C50Cw6hDxGn3fkO1i9HhmsplqE+KSyyONlox1uBCdIz21dEUlFN2T7CZnUAWQMsHZuPWXwaa6rKfR/9Tau8gctK79IEU55DpHWp00PeTYCrMF1pyoEYjoRo0NqpG7WCww5BfDh/CXsjUQoevJ0lA+bi4h0bDWKaJ6XB5W0aR3kipwblOHq3TuhfIE44TMr0XejLMv/3JjamqYh1FbL81aiB8T97B83DpYwFBiZMRv0CZFjYzzqY2hS1vIul2queiwPJDalEPncSpHKohQcUvHoX7ptGlLpOR/xKbH07vEzLNs7A/wBGpYy+KeZBZe1sJFdOfK+1o86/VLPy/Aov+xHY1sRZifZG5WtYUlG8mctPgJluvvT4yp19Qu2YjIcj7yt8pBb+9qb14PzMJ9ZOPRlIDSNiQOusRbY5xrjSRyX5A8f8XNDeIFssfuYm0GMplKYBjJHhaTgBIFM8uPa/XCTxhYqTw6stDpsWF3NmO8p+CZ/rbbE7n2UG+nrhsJPQZYyKDcLl8E+K2fI8ZbtP2MQBt2v75vPC7VRDqxPHxaOPFdh/p67cASgxvjQo8Y68ZN3gEWtxuOpS/BqOauLsrGV6R3KKTO1zrf9bBmJuNKEPvruo/0kVdSTA+M1sgz841+FcZU2CxvS29KNuZi+GaFOzvsYe5Bbqf8uGtKGVEbEvJmCGXcGTsCcYNmb07pVPWl8P6x06D5FIHH8oVLnJB6rJHPysGl1TPmp7MNazIXSEcH1mPuOGW5JguDHEI9QXRq6/eXxWvYO63e68ZLvgTb8lUK/F/wEDf94BAEwW7EbRA6YFTqc9SUT5mPIKKY5NJyQU71dRIi4QebH060Kfg/Si5/o2P4kXrvpb+6uYBvWMvdkgBw91VL1
 +NWuSjAb
 2y/FYE4RfhCwO5p8jlMFfzCrF6c3KaoMYf+QbZynVEPD6LO0+caXkVPmixrv5U6gexHgsmgvhVuNi0Pm4qBTGLFtall4CPEpUdLjCWYumeFNCfOAswOKALcIoO2FYCzD7faswTYIznSIRZCpOUI9BmUWzMDT8H1BN7/S7ZXMs3dxpsEn0hkQwyF/CpxkxWw4ua9elwI9lAXTobjHd0sPGO6AidntwY8wMPSqXpSsS1FOi54a7zF3ULD1uyAxIuFTWmxYj3iaTgtp2qLOU0LYamKIQl2lX1XaIyPXJO8mfLvrHuRIV2IYo0Hj4xNtGa4vz96NGaJUx5nerlYaJyuNEeqV6v49I/0hiWrGo3Mm9RdNuXpD4WjLZBXg5/OUefTu0zVVZFk65GEOuSN5LrDoE4ApxKxoTOaNTqW++R4pWRk6z4HmVa55L9tm3nBbBSn5XKjR9vRBIQQ60ZrQYI7qEcv0UuPN5mtJpYxl4niQbXAY8Yhs6pUOK/IXvwPyuPU8uqSjaDWjoe2d39rrrk7oqU9idI/kvaoDaTrGEoo/VBZ7W06DcVKk6eGvKXBpRxeptjpo18YGaAmJ+XT7m1fA9JDpudy7Uts9Cq5H1jTargLWI4fwYf/U1jHm7OEh1+S56hN/9cxsp9VjJCqvhQYYdtWwbFPZqKga3Z4M+vfbC4vq7vpcP8SsTX5eGuyAIsReFrW/Tx+kX9ygWMER1ZDAWSf65l9b+CTPsKt/1/RNTTkuzwWI7+R9pnFdYwvbHQE45epOo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> David Hildenbrand <david@redhat.com> writes:
>

[snip]

>>
>> Nothing else jumped at me.
>>
>
> Thanks for the review!
>
> Since we're going to submit this patch through Shivank's mempolicy
> support series, I'll follow up soon by sending a replacement patch in
> reply to this series so Shivank could build on top of that?
>
>> -- 
>> Cheers,
>>
>> David / dhildenb

I hope sending a patch within a reply this way works!

---

From 11845fed725ff68c3bad07cd9c717ae968465bf4 Mon Sep 17 00:00:00 2001
Message-ID: <11845fed725ff68c3bad07cd9c717ae968465bf4.1754603750.git.ackerleytng@google.com>
From: Ackerley Tng <ackerleytng@google.com>
Date: Sun, 13 Jul 2025 17:43:35 +0000
Subject: [PATCH 1/1] KVM: guest_memfd: Use guest mem inodes instead of
 anonymous inodes

guest_memfd's inode represents memory the guest_memfd is
providing. guest_memfd's file represents a struct kvm's view of that
memory.

Using a custom inode allows customization of the inode teardown
process via callbacks. For example, ->evict_inode() allows
customization of the truncation process on file close, and
->destroy_inode() and ->free_inode() allow customization of the inode
freeing process.

Customizing the truncation process allows flexibility in management of
guest_memfd memory and customization of the inode freeing process
allows proper cleanup of memory metadata stored on the inode.

Memory metadata is more appropriately stored on the inode (as opposed
to the file), since the metadata is for the memory and is not unique
to a specific binding and struct kvm.

Co-developed-by: Fuad Tabba <tabba@google.com>
Change-Id: I64925f069637323023fbff91fc8521f92b8561bd
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 128 ++++++++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c        |   7 +-
 virt/kvm/kvm_mm.h          |   9 +--
 4 files changed, 118 insertions(+), 27 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e5..638ca21b7a909 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */

 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b60..0e93323fc8392 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
-#include <linux/anon_inodes.h>

 #include "kvm_mm.h"

+static struct vfsmount *kvm_gmem_mnt;
+
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -385,9 +389,45 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };

-void kvm_gmem_init(struct module *module)
+static int kvm_gmem_init_fs_context(struct fs_context *fc)
+{
+	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
+		return -ENOMEM;
+
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
+
+	return 0;
+}
+
+static struct file_system_type kvm_gmem_fs = {
+	.name		 = "guest_memfd",
+	.init_fs_context = kvm_gmem_init_fs_context,
+	.kill_sb	 = kill_anon_super,
+};
+
+static int kvm_gmem_init_mount(void)
+{
+	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
+
+	if (IS_ERR(kvm_gmem_mnt))
+		return PTR_ERR(kvm_gmem_mnt);
+
+	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
+	return 0;
+}
+
+int kvm_gmem_init(struct module *module)
 {
 	kvm_gmem_fops.owner = module;
+
+	return kvm_gmem_init_mount();
+}
+
+void kvm_gmem_exit(void)
+{
+	kern_unmount(kvm_gmem_mnt);
+	kvm_gmem_mnt = NULL;
 }

 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -463,11 +503,71 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
 	return true;
 }

+static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
+						      loff_t size, u64 flags)
+{
+	struct inode *inode;
+
+	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
+	if (IS_ERR(inode))
+		return inode;
+
+	inode->i_private = (void *)(unsigned long)flags;
+	inode->i_op = &kvm_gmem_iops;
+	inode->i_mapping->a_ops = &kvm_gmem_aops;
+	inode->i_mode |= S_IFREG;
+	inode->i_size = size;
+	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_inaccessible(inode->i_mapping);
+	/* Unmovable mappings are supposed to be marked unevictable as well. */
+	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+
+	return inode;
+}
+
+static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
+						  u64 flags)
+{
+	static const char *name = "[kvm-gmem]";
+	struct inode *inode;
+	struct file *file;
+	int err;
+
+	err = -ENOENT;
+	if (!try_module_get(kvm_gmem_fops.owner))
+		goto err;
+
+	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_put_module;
+	}
+
+	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
+				 &kvm_gmem_fops);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_put_inode;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+	file->private_data = priv;
+
+out:
+	return file;
+
+err_put_inode:
+	iput(inode);
+err_put_module:
+	module_put(kvm_gmem_fops.owner);
+err:
+	file = ERR_PTR(err);
+	goto out;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
 	struct kvm_gmem *gmem;
-	struct inode *inode;
 	struct file *file;
 	int fd, err;

@@ -481,32 +581,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}

-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
 	}

-	file->f_flags |= O_LARGEFILE;
-
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
-
-	inode->i_private = (void *)(unsigned long)flags;
-	inode->i_op = &kvm_gmem_iops;
-	inode->i_mapping->a_ops = &kvm_gmem_aops;
-	inode->i_mode |= S_IFREG;
-	inode->i_size = size;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
-	mapping_set_inaccessible(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
-
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
-	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
+	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);

 	fd_install(fd, file);
 	return fd;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 18f29ef935437..301d48d6e00d0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6489,7 +6489,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;

-	kvm_gmem_init(module);
+	r = kvm_gmem_init(module);
+	if (r)
+		goto err_gmem;

 	r = kvm_init_virtualization();
 	if (r)
@@ -6510,6 +6512,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_uninit_virtualization();
 err_virt:
+	kvm_gmem_exit();
+err_gmem:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6541,6 +6545,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_gmem_exit();
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	kvm_irqfd_exit();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 31defb08ccbab..9fcc5d5b7f8d0 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -68,17 +68,18 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */

 #ifdef CONFIG_KVM_GUEST_MEMFD
-void kvm_gmem_init(struct module *module);
+int kvm_gmem_init(struct module *module);
+void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline void kvm_gmem_init(struct module *module)
+static inline int kvm_gmem_init(struct module *module)
 {
-
+	return 0;
 }
-
+static inline void kvm_gmem_exit(void) {};
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 unsigned int fd, loff_t offset)
--
2.50.1.703.g449372360f-goog

