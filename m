Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E17CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2316B002E; Wed, 27 Aug 2025 18:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469DF6B007B; Wed, 27 Aug 2025 18:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331766B0032; Wed, 27 Aug 2025 18:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF4C6B002C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:43:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92D6213A1E4
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:43:25 +0000 (UTC)
X-FDA: 83824015170.28.4C8AD72
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id C6D7540002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:43:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eh32hWje;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3CoqvaAsKCCkFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3CoqvaAsKCCkFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756334603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKcxlPw0uQjBkw7eQMnE+gmOL2ekj9P4WG4v5yuEZSw=;
	b=gOqXXUrqvarYriCaGc8/4s9PsejX4dpQJm0zhRqKHGahtp2XEmtJT+x2EIGTi9w/mkjGIN
	ZQBizqW+LLL8duf53VpiSxJu+h+hXTwKKfTm4V0WZcjut2fNd1S3sUFw7hSqMtribtBCJz
	duc0mWW98A2N2bUW/UnjiVa5McuhirU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eh32hWje;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3CoqvaAsKCCkFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3CoqvaAsKCCkFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756334603; a=rsa-sha256;
	cv=none;
	b=Au52te353Pk5bq0/zBmQEj6JEunqHf2Xub/H0qiyHpg43I2gAtMI9p7WSMg60tx064Bw9A
	dlWLLYwY+uRs0LnKSRNIUy5jKiE6OKVgjgMCwA4lHGh2okQEJU/rFTKMO52EFcasO+Ya7G
	Kl2XGEd9H/grcjZCdZVGHB5elnh3X+k=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c2c09a760so239919a12.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756334602; x=1756939402; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LKcxlPw0uQjBkw7eQMnE+gmOL2ekj9P4WG4v5yuEZSw=;
        b=eh32hWje7KNeYek/3FQVHm05EFJEr9ndvhSUPMcyC2Z63H8fG32LStONkn3RNn+5IP
         dfdat7+cjiNKMXvrzKRlSY7a/4OL4Mbs4xraLN4fIVsa4iI93SGrFeem3lQL12Igk0WS
         tcRBQPh5Zc0KwHBaaMYgvfVTSBx7feAogcQo4MEKJirvZNKjAY1bRemtVANAyKcZjfKk
         xKEdAYWQEU6VKMT9ah0Qql8rupAk9KbpKv60ojMlqNLSA2OkeUReLkTybT0oxenzHmom
         xJ1vohyTnKGHA5Gqc/JWk9yO/rKvedrK+j7NIwkWrnL2eEk9F+vAyI+tD0IYNDvmC5pt
         MoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756334602; x=1756939402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LKcxlPw0uQjBkw7eQMnE+gmOL2ekj9P4WG4v5yuEZSw=;
        b=iZ9mnc2i9SXEhz5aKB5s5cLUFkc9cSstIpV55CWyY0bHUTJi/Ean6Cx2cr9S/i7ceg
         f36J+coZMgM6bTtYR4ut0eztcZIZA0CnXD94Ol/VrUNFknq/05dIIc1j8rUzuxZ0Idkc
         KMj2BPq3+th95Q8Fi9nuHGNdsqF2ExtliOl4iZPS0CXT4d+h9KdIxuzawByPbhCTdDFA
         nmBMq6oNBKTXDAyiSPlEemfgxzOR6y3jtGwI8YZSHdabMVMjbQo+3H6njlvs3lnF+tTH
         EwxtbXTNFpe5mZsIftNV5wHt0znfbxCvVBr3HrnSo8hX/JPrDBZPEpcZQZPa6HwWueVP
         bJPA==
X-Forwarded-Encrypted: i=1; AJvYcCWUp0sDZp3dgeRTG7qREjbNBr1NpjLK2Is4mG2BswaN4X0EMSsXvAB7B+1SsJt7ofoUtJUd47Pi7Q==@kvack.org
X-Gm-Message-State: AOJu0Yy64UIFTxUkTNgK+98Bl7UVwkKkdoybz0vhaslCKBxqlymhcMVA
	/bugKxfkL6DasjHK3w/W/naD08Qg5CrFUlB9cIgjVLccky9LNlnOVcQ68hnvkhVv61kNRRFBSt7
	t3aFOQskIhGXJwsDHVUA4pNxcjQ==
X-Google-Smtp-Source: AGHT+IGNhCki+zRNFnf7AupQOwuzR8TBEtFWXAfIyU7yRpBo61MiAC41fjzXQhOiSXx1TrtlLAFGHZ8M3ImJd0zqNQ==
X-Received: from pjl11.prod.google.com ([2002:a17:90b:2f8b:b0:325:7fbe:1c64])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:da8c:b0:327:7c8e:8725 with SMTP id 98e67ed59e1d1-3277c8eb5a6mr3670514a91.10.1756334602319;
 Wed, 27 Aug 2025 15:43:22 -0700 (PDT)
Date: Wed, 27 Aug 2025 15:43:20 -0700
In-Reply-To: <20250827175247.83322-7-shivankg@amd.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
Message-ID: <diqztt1sbd2v.fsf@google.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
From: Ackerley Tng <ackerleytng@google.com>
To: Shivank Garg <shivankg@amd.com>, willy@infradead.org, akpm@linux-foundation.org, 
	david@redhat.com, pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com, 
	vbabka@suse.cz
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, shivankg@amd.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org, 
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com, 
	roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org, 
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, 
	yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C6D7540002
X-Stat-Signature: aysc6j5bwraodcd94i41quygrjd8kxxk
X-Rspam-User: 
X-HE-Tag: 1756334603-812080
X-HE-Meta: U2FsdGVkX18izilnPoiXaPnhukqV3E2WPccNmzFbNkhSiQWJDt7fgMCOaL2gPvM5lnT+NoiTmQonVyOT7SpH6QUqzfMiVmcX+0ws2Ym1+iofDPp8DuKUTJAHtEoKQq4fC5Ak5ND4fxwNBI+u+lvpG7mcZLdw6njxyt+ce+UZJn59FeukdO57OKcyi6hZ+0HI2Gk99XEiajXNvLffcGnX/gQei4vOlxFqr5Kj0/AivzC3S5UT9c6eZc6eWw7cZA8Z8iPyel7/w+ISQuUbm1KgSY+czTZp0JQuGtn+HhXwfX1wIEVWhyhwhSo7uEny02U0mZzPppDTZFup81DYyKFkrdxY5YP5R8uZCn/nkXbTqBiojhOBuJn1e5w9dnW47QNq+z7tmhnWLJ0VqrLfg7ZFQw+UKNUcHHXxliAd6+yWWxvBVzOQHeet+f/x+bTj0bR2pWSqMM3xoa+TjcEBgRUGirj1cgYOFkdI2GSodRjRWxQo1Ce1n4gqCZ4WGxTEBz4NzrT9pGPxmmpPi97luuBna40oUU8hqz7az2a+uY3wg36nAeKaFMhkrAXimdP6061JYJTLBeI3VSbgwbkNZmAZyv32szjaeM2BddH6mtwFQhSSH4jUROY1ePLnHSedF0Xp1v+TPjoF/U/E0zwuz0wkjqOimqz8hrXCxPvIdMzBCMvp441FOxm9yYg3SCol9fc9WsQHHRlyi5NagztLHYmL5W+8aH3QcPxUFyiG5NntK1ZawOhInuw8xLQzdY1NeX8eiQA5waTpzno3b2XXNiAYnrqURlkS1FoojfDZ72GpfseQShwFD+DtuTWmc4WJJztmXc7bst1SGBUO1OOPfZ44bwI6bhI8uR2O7V/JHCh5mpnlgjMonJ8ct8C5+cxIrb4azKB2E+7dzr1n40WA4Kpp8YVIq6IIyaClXlcXPXtg3e0VkfaQJPU+o5u30cMrEfuRiazOSDPgkS03Kfgzion
 Mcaz4A9Q
 kd/Vk4bPs/KMbKH1nAmxscTQoAGGQtgAiFLOekzhPmH+KP4LDjhFa/2TtFR3IOt2pifTPGXstea3vfBI6ZbVBiJI0HH0WcBwgvDXFc9P9mNrf6KvQ88Qxz4N7wHE/uMWT10un4E5fH2Yy3T+527iSKA8U9qFrmQyb0Uw6McWY/i17WeFOmEuMS4XuGQX5PjSXLRcuS1AiZfWiBRoK7sO6F9GFybeMHrTAMSBKDOPKbvF8VzQ/ubtzLjR84GgEr2qQSnJE8yeaaoMElG1uv7hDkOoSCIvhZw7lfFNNrRJ79AbaV0VQoBVIPwG65x/+XfzmasrmiydvAKe2kXkoHTzeSPm2htnQEd/EvlyMDckNQ7c7o5zjMRh1GFS7cxWKj4roaQwgYoS/WVpqSVx4BDNCmAEC0raXEpUjl1DY73FLVPwuCnsslAG12phd5pdDCOgwfdtHtGu3PAM+NlDw45r7pj9nfw2yY5KR0ka5bTHU0T9sB/zt5IcVosCwJmkmMiok2Fai/H14tQ/9SBeIRckjJ01GCaB5Gdqc6IOisy+T9iqYqgJRsabKhTnzjb0/CiHrQEba2GWnDaOtHwmrTnFSCd/Jbq/Pt/e8MT8hdfoT/xa7Ov6iWTaGmZWrP2KIMWmU4HlEe2b5mE3W5s6Xo/B/ElWwkybwI7COG94wPJzHDcr8WYz2a2N60ZBYnoQ0TRmwAokRLudOvrZ0Pcvl4f4EjCHaVrHkJCEciENioK+7wRvNrgEtnZm0oPZVctATA8+8eS8qpG1CvdPI6FMLSaYFdAsttm3Mun9+z4dr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shivank Garg <shivankg@amd.com> writes:

> 
> [...snip...]
> 

I meant to send this to you before this version went out but you were
too quick!

Here's a new version, Fuad and I reviewed this again internally. The
changes are:

+ Sort linux/pseudo_fs.h after linux/pagemap.h (alphabetical)
+ Don't set MNT_NOEXEC on the mount, since SB_I_NOEXEC was already set
  on the superblock
+ Rename kvm_gmem_inode_make_secure_inode() to kvm_gmem_inode_create()
    + Emphasizes that there is a creation in this function
    + Remove "secure" from the function name to remove confusion that
      there may be a "non-secure" version
+ In kvm_gmem_inode_create_getfile()'s error path, return ERR_PTR(err)
  directly instead of having a goto


From ada9814b216eac129ed44dffd3acf76fce2cc08a Mon Sep 17 00:00:00 2001
From: Ackerley Tng <ackerleytng@google.com>
Date: Sun, 13 Jul 2025 17:43:35 +0000
Subject: [PATCH] KVM: guest_memfd: Use guest mem inodes instead of anonymous
 inodes

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
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/magic.h |   1 +
 virt/kvm/guest_memfd.c     | 126 ++++++++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c        |   7 ++-
 virt/kvm/kvm_mm.h          |   9 +--
 4 files changed, 116 insertions(+), 27 deletions(-)

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
index 08a6bc7d25b60..234e51fd69ff6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
-#include <linux/anon_inodes.h>
+#include <linux/pseudo_fs.h>

 #include "kvm_mm.h"

+static struct vfsmount *kvm_gmem_mnt;
+
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -385,9 +389,44 @@ static struct file_operations kvm_gmem_fops = {
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
@@ -463,11 +502,70 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
 	return true;
 }

+static struct inode *kvm_gmem_inode_create(const char *name, loff_t size,
+					   u64 flags)
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
+	/* __fput() will take care of fops_put(). */
+	if (!fops_get(&kvm_gmem_fops))
+		goto err;
+
+	inode = kvm_gmem_inode_create(name, size, flags);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_fops_put;
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
+	return file;
+
+err_put_inode:
+	iput(inode);
+err_fops_put:
+	fops_put(&kvm_gmem_fops);
+err:
+	return ERR_PTR(err);
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
 	struct kvm_gmem *gmem;
-	struct inode *inode;
 	struct file *file;
 	int fd, err;

@@ -481,32 +579,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
2.51.0.268.g9569e192d0-goog

