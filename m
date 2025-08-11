Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5212ACA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 21:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A950D8E00A2; Mon, 11 Aug 2025 17:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A460F8E0091; Mon, 11 Aug 2025 17:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E1A8E00A2; Mon, 11 Aug 2025 17:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7753A8E0091
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:23:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A73D58434
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:23:13 +0000 (UTC)
X-FDA: 83765752266.23.E663DA7
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4FA53120014
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:23:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OTztGHhG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3PF-aaAsKCK8PRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3PF-aaAsKCK8PRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754947391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05IUDOHLoU+NapT4auKPkbt3cJ61ybRHsivfAAxzoHI=;
	b=iPqkktMidnyjreYIg7zH+BI5um+gtUDiiH27JthBQTaMg9CrBJJzVM0Fm8TUhIOpiIyfuU
	nHLekF6H1bouZzr8OfVek8HGqXZMZr9ZzUZkQfzmTq4TB8wd5pjs9y7hW/Xt3xkoC8BeQh
	bm6IwceiY60aQio+rkUYcgaZLr8thnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754947391; a=rsa-sha256;
	cv=none;
	b=RzmaHZabfEL0yp5TXNUp9O5i8F/GY+9bR1u5BdDv8/r2gGkgn617yhL50tlZL1Rnskdfjn
	XCgXo/UU7XQEiAevWxbrepCLeujhdXKfVWM71sUYQsZA8cjLlQikbkK3tRSZ7Lh67gLFXW
	Kb7YPO062x43l4O7Jt4kuzRhqmA6Ybg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OTztGHhG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3PF-aaAsKCK8PRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3PF-aaAsKCK8PRZTgaTnicVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bf8e79828so9263431b3a.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754947389; x=1755552189; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=05IUDOHLoU+NapT4auKPkbt3cJ61ybRHsivfAAxzoHI=;
        b=OTztGHhGd2rMvRRNndwAHg2uxp/a4+R7rARufpwkFwCGmZrc72wg/zAZbNAULy03AK
         6lxNL2aTThYC7DM+qfLKQzhYjRB8WAoN3d7mYwOn5heJO95RS2dU9fYVcF3MO3I/XueZ
         CXFEBFkI5K5uIO7EqMXmslApReuIG8zd9k8EywLXwOfW5Z2/1GlmMP4OqX7244F2HaZP
         VWyNHcuDlO1nrA2AYAQdD8MWgJutaA/8ibfcd6kl9i+viKb87ngd14PM/tveU3dAFtuE
         KCF3G9EGDvrkLiYI83aqtdDpHImjomfS+LMCqRtdg78IXQofyNOw1csT9K1H/Q3YGeNz
         cDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754947389; x=1755552189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05IUDOHLoU+NapT4auKPkbt3cJ61ybRHsivfAAxzoHI=;
        b=cjixiL6OkYJmjrp3Xv3ylQVeZUCNrGmzChjV+1HMDTNIWtXPuFw0DkUW4zREuiCtMq
         O35pPCFRtGs7DxyVif7DV3SMegeYzL8eJ664nGmKs9RPyIWVVlazWaecOJvlWR9YmX4R
         apidmBNCdOcJ1isfBfaVwKWGly8iQLzTGNu0j6GHaUvDSwlRsD6l3VG7VZ7j5epmrlMW
         FtYKt5zbmNzs2LV7hC884RQtDAtFAFmluh+JbJMpaqU0i2Yl2XbDGpaMGnmCLXBaNwtY
         pFq9Qm/pYZl6Te/Uw2Uy7sW+VFuVRPjbjcdRKHqwAN7sUujfn/07ofal0VCu33pjR2mF
         55wg==
X-Forwarded-Encrypted: i=1; AJvYcCUu86xtukaaasYb3TkfkqYG8FykJj4fVhg6bzs89Z7BrcrK2M5B1xhIkMSMnQ0TFEm38Sjmtzl0xQ==@kvack.org
X-Gm-Message-State: AOJu0YyRigZ1QnCVEPNeii6GJ6a57/1DSk2OqPRHrMR6yCyCmWh4Ze4k
	T7ts3oNynG9twkBNVRge3yeWRe2qCCYB6zmdl6yGQw25U8hT+kGi77pHdI5zxsA+orrXPet29fF
	UTV7VZQzVA9kdNt1xd3I1sTtNIg==
X-Google-Smtp-Source: AGHT+IGhD8wuXRxDbQxbc6dPZBtu1qLcQXHBeiJmtKy0dLRbddKNNSDcwg+GSBc3ARQq15cEOQTE9YJKl1VCh4HB5g==
X-Received: from pfdc2.prod.google.com ([2002:aa7:8c02:0:b0:748:f98a:d97b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b85:b0:76b:fbf4:b9d8 with SMTP id d2e1a72fcca58-76c4619f85fmr17869611b3a.22.1754947388694;
 Mon, 11 Aug 2025 14:23:08 -0700 (PDT)
Date: Mon, 11 Aug 2025 14:23:07 -0700
In-Reply-To: <cee2e489-d3c9-46d4-8d34-37c637c7bbd8@redhat.com>
Mime-Version: 1.0
References: <20250811090605.16057-2-shivankg@amd.com> <20250811090605.16057-10-shivankg@amd.com>
 <cee2e489-d3c9-46d4-8d34-37c637c7bbd8@redhat.com>
Message-ID: <diqz8qjpzh6s.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH RFC V10 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
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
X-Stat-Signature: 5zi1mopyu37cmd93p1bp5skuyymz6sqe
X-Rspamd-Queue-Id: 4FA53120014
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754947391-587887
X-HE-Meta: U2FsdGVkX1+d6cASyiAgakOqqejeJWQTNAkGPavxqCOP/plLrgJw3sN2t103Dq5QaQ+LXxZbLVs1jcwd89YnE4OZ+FFhkmHBCa2s5R8An85s/hD6NCqETMpXm3aCWbuXI8MFVBxzCu3NW7tjJr4OuOf6iGbqbrYBTJIauLmj5jdPTQ8zmsiv2Y6NNHt05g7j0NsDjM/R9ACJVvCZUm8GCFh3ZTu/km+DoPQ5DO+ioI+OVH4Pg5/h182Vk2m66xRcTpMoWaLX1vhbXKzvFAqF0gkWpiMklNfFHBdsMcNGAFEviSUPvSiqrvEFI3ytUpfsQ0jhi7M05z1Yvad5lCazYeFkvqpYCJxBLHeuebUIqeILbFaIKBTsO1hD2J/+ncukkAtvlMwV7V5h5WbNpNzFWwb0pcAJHmDaeCtnxQzfyMA2MG7zqobiHULyETAV9Mba7JqNb161DQTJ9Kb6EP5Yfz2QLTIxcWDouXE1Kk6txu7lhVdIFz1tLMJ6/dOz7OMiKvK9xTB2kuGYI9EWBiHwm9KH6G/woJA9Cntd1ezSCm6JButU81pPtTzZO+CBxvEGJaYLbLG0h3idAK8Cn5kw91E7fDGIvahTcLS4V+xGCohOeqolg8dqCraYsO0Ue/nPWu8GvbrCygFkPStpPzIkimSzcSwaVAlrSJ77dY80h9LpNbp7m05RzsbSBh/GefNp5aX3qsAJMkDzbGqkswqtxkI2rARmkT91yeOTlf3Zdg2fpf/pkffxXHUmA2oNBrndiSBtFSp3L60cqnaWnYwidg9WtpKKZIZIvQ2zcnn3cRW//FOdNqvVT6uxHj4u2uiGI9yN8LZrwpYZK6VPKODK52jxJKOfyv4LFAiPtvKulOgXTi9MEM58cakHdev2DIfGmT0+/vBs7OsB8Oj1ggQBkGIbpoiFUuPHUlNf69XioihH8XehQ3b97apy3rCu9t8IHmSp7Nt3FQKO6Qe/NCM
 NNHVYNiO
 MYW4bOqYOb6ZY1J5Rh3467Il5tli3xf614fnT3nKDHmVtNn7CglaqiJzr8lXKE7oYrtwtnHg8RY2fX4wIebT6ZXf8DVl9FZwxLGtkIK0UrUNn8aDhgKBMXu+MYWYdlF3p9VP4Dy0O00B+UL+1GMSwBnoW+IJ0XyXFveK2TNoyvUrmEOWILd1F8QB3Z7YFRzP+yG22fJb+aS8q23oOT3apq47Q4MDupHgpBQUEIiyYi6rYqMHOG9M1Dn+sc54xax0KISm3gV/3McZjaNg9ZDuwdTuNoNM27Fu73qBb3/FHKzUaONBcB+mGPmMNIwmqqdsOtMJI9/O+jQ5eanX0OnCdukuq7WtySJ6V6qab3ElMRgAyQ98HgREGeKnglWlynBp8MQnCTXXBRNWOhskJLZOblvAFc2eL3KGYD//XPpNAYLY3Pm2tI3hbztyn7zDMZuAmIC5BUVGElFHykNO3Ih3n4EC6DADu85HO5lrOXUpTSNDQf1HsOF8oSSvOj2XpSqA68wtum5lHa2L7pA+jP3pQztr8Bh6V/2RbbfMiU+uKHwYuiVUoyePyTjgtR4/p8KIsvuRBn3odU/lcnJIAIFTwy4q6UcwtUVEeeq/sr2kpBXMz3hj3H6Q1qWqRjg4gT/8RN9fj6VO15wgnmnhy6aPwiGnhYAzcIviJNoUZz6F888vTpiqxTu5tW965K7UtM5RSgyjCdE+iSpeZPgxDnXpScjtWowquFn08aBKeJtXsFW6sivTrlSVaXS5YfG+C6o/BCvXE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand <david@redhat.com> writes:

> On 11.08.25 11:06, Shivank Garg wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>> 
>> [...snip...]
>>
>> +static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
>> +						  u64 flags)
>> +{
>> +	static const char *name = "[kvm-gmem]";
>> +	struct inode *inode;
>> +	struct file *file;
>> +	int err;
>> +
>> +	err = -ENOENT;
>
> Maybe add a comment here when the module reference will get
> dropped. And maybe we should just switch to fops_get() + fops_put?
>
> /* __fput() will take care of fops_put(). */
> if (!fops_get(&kvm_gmem_fops))
> 	goto err;
>

Sounds good! Please see attached patch. It's exactly what you suggested
except I renamed the goto target to err_fops_put:

>> +
>> +	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
>> +	if (IS_ERR(inode)) {
>> +		err = PTR_ERR(inode);
>> +		goto err_put_module;
>> +	}
>> +
>> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
>> +				 &kvm_gmem_fops);
>> +	if (IS_ERR(file)) {
>> +		err = PTR_ERR(file);
>> +		goto err_put_inode;
>> +	}
>> +
>> +	file->f_flags |= O_LARGEFILE;
>> +	file->private_data = priv;
>> +
>> +out:
>> +	return file;
>> +
>> +err_put_inode:
>> +	iput(inode);
>> +err_put_module:
>> +	module_put(kvm_gmem_fops.owner);
>
> fops_put(&kvm_gmem_fops);
>
> ?
>
>
> Acked-by: David Hildenbrand <david@redhat.com>
>
> -- 
> Cheers,
>
> David / dhildenb

From f2bd4499bce4db69bf34be75e009579db4329b7c Mon Sep 17 00:00:00 2001
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
 virt/kvm/guest_memfd.c     | 129 ++++++++++++++++++++++++++++++-------
 virt/kvm/kvm_main.c        |   7 +-
 virt/kvm/kvm_mm.h          |   9 +--
 4 files changed, 119 insertions(+), 27 deletions(-)

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
index 08a6bc7d25b60..6c66a09740550 100644
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
@@ -463,11 +503,72 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
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
+	/* __fput() will take care of fops_put(). */
+	if (!fops_get(&kvm_gmem_fops))
+		goto err;
+
+	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
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
+out:
+	return file;
+
+err_put_inode:
+	iput(inode);
+err_fops_put:
+	fops_put(&kvm_gmem_fops);
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

@@ -481,32 +582,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
2.51.0.rc0.155.g4a0f42376b-goog

