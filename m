Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CCEC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202B46B0088; Tue, 15 Sep 2026 07:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA3D6B00CC; Tue, 15 Sep 2026 07:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F18F6B00CD; Tue, 15 Sep 2026 07:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3A536B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84B721C23DD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:32 +0000 (UTC)
X-FDA: 85215793824.22.3F48300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BED422000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOl8mduH;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ixA4Ace6BJn7IjrzCTCU0/h7/zoW2kue4sGkrY9xCg=;
	b=RVeNLHkuOKdZexuk+EN7zaGzL+cPc+NdGdwKyiQebHX3IvwCZuF34LVTX99KdkeVYquAjl
	k5cFlYlMuZ09g+WYKb8PDNuxi8CSmWoMsIHmO/YOYBow0vf4O1OKpdvt78jUXadt8sBKyY
	aZ6AsGCqb+gvkiK7sDJubnUJjn60if4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOl8mduH;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472190;
	b=T5rhbTvoatxzaiKOgYrr7ZZ2M7bcK0JJZd1tbTlYGuj6u3qLXtgYXXjOH8AQbVzxy9tJ25
	L5iAQzCuH1p2O+gbZMs7is3u/0l9uJAwmEXnjaoVdal7d9LYUeT4A/dGl74IQF+lnUbjXd
	fuLaWbwui3dpnuyoaR67frSiWMKiSzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57141600D1;
	Tue, 15 Sep 2026 11:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A888C1F00898;
	Tue, 15 Sep 2026 11:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472190;
	bh=0ixA4Ace6BJn7IjrzCTCU0/h7/zoW2kue4sGkrY9xCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JOl8mduHPaeVv3eaq9MEhCqzMicOygBaK5O7Dzp/RHXpO7NODADnSsZqyfqWqEQZR
	 lR/VPeQyWMIddPe1rPhDu05Hlm3nHa5FLkG932tVgVvVmp1QfM/hVE5mMYh+azuISL
	 UmAM+w7jZ6/RT6AK2zvRXbcbWwva8oTaEAofof43ADeJYUXP4l+fKFnPm5nLpARsob
	 2FLL0ErbZn7q0fCeD9rQeCPTtW4yh3QMmMpEVQM39yn4qUnY43PiI3hNDpcRqaUIti
	 KY9m4cCM616bpCnYMsG+DY5wREnfHQo42u9v21mvFC1w6Cr6Wausbj6m5LHNP95jEM
	 Ck7KRCyZ89YTg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:26 +0200
Subject: [PATCH RFC POC 40/50] KVM: stop putting descriptors back on
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-40-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3135; i=brauner@kernel.org;
 h=from:subject:message-id; bh=78vO7PDsYGy3GJUzt5pCpyZhq20MYXeEqBv9mkCwUOM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmrZTOP7Ev9FMJVxubVxbdNfUMIq6RooWz7Kg6W0
 u0ly+I7SlkYxLgYZMUUWRzaTcLllvNUbDbK1ICZw8oEMoSBi1MAJmLaxPC/6MvkYx+dQ5OZjxmx
 1NY+4H3y0sQ15JTH4W0GqkVf38y+wsgwpWTB7u0yUtPOBqdErHHe3P2Vb+cBu4mdx15GLt51wuM
 UCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BED422000A
X-Stat-Signature: 5h3d4r89ten16xn3bf6j73rww5dkcof4
X-Rspam-User: 
X-HE-Tag: 1789472190-553925
X-HE-Meta: U2FsdGVkX1930jNnstW3HlZHwAS4J64tY2kteVNK77E8l923thQC8eHQhFzDl57eOmKylb/lkab8kPiwZlXPP/XvMt4kkMqlq9NZN2o7iRHZwWB0vXYAuFfxnedmMLxg7y6DMkvyhNPXrNm7ln3ZXeXdUK0/f5XSjdG9DUOVYOA1wjhPW/+nlGXC65Gn/DW1vfVexAF1oZ1+s+72pxngPCtbNe96ifWJNu6gnMbDO1q/1imShuDuQYf9JuZdr7soSCTOGu7QySPZfKxabWnjVJ+E8ExFwbAxh08hQIbedg+cmpXszJJZKL6pavtIpptN6K1/XH3lb/+/bUwp3SBVSXv9a68yj33MOi9aDhvLvjUxj/58jsrgDZzT+99PFu8YSPuubHd1eIGmlwFf/2SByAi76gPEXZio70kQL8hps9sStJwkqSabJTmtzUsy1MU+Br/zv9Oveoc+1LNM3/Ua7nigupQkVB8bJ57foh599G7vBGvA+5aPGxkl7KPrfdVXFgfLzj5gzGY2IkNpyoYJJV1Fyw6YGDV/98oAqaZ0rgKoh+6bmEwYMVzD54x/n0JMdkTqym/k7Xq4tE50hjMvkSgPHLJwYbq5txx9VEPHYRA6CwacqnOMe3EOJj/YeBBDCgfGO55O4hrqe51PiASlw5yaV3L0aFOOn2iDv1MNi3Tg2Stip2Kg7kRmqA74nMNs5FDVZJrx5guod21KVUI1jCka0Xak6pTn5ZJ2+WYd74r1sGAITz0Rkaro+qbKdOMUc9xluTx5LSbgJmhNukV5fm6WQCpd/LXFNqXaaJ/AK7liXT0HNGPA28ZqDwhPrJda3aTL+RI/R/5otyGPdkXDDZ3mgu4dW/zWeWP1rTphP/Sz0jxK0PK++Hd20WVLDXCnZtGOtqzYEZrO14O2wl0MUZnTLkVSkDW3Gn11Lzm1t9C/8jGBbKIg0WKP8nw/Ft5GblcdrT2ZwVLlGIpxS9H
 q47bz10Y
 cwPEasCG/zKL90Os2gG2Qi46koZR5sZRV0+nxdC4ELJocTfWFXH6nyo03wM2O5bUOFCT9uQOfX2Ng7DvhgMuHQzghNY/r3HkxO3LFJMoCxma/yA3tzBwYiF/OG0TulIYSCzjyedGIgETUHi/D9zLvQv84wXoVh/9LwO3y1x7KwohLydnLjO+PGKuH5hajCEseHwYlXW98EkKi6S43/6ZdN3yZExE55A6izU3zegQuSjNh8hNrN3tWVmL1Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 virt/kvm/kvm_main.c | 65 +++++++++++++++++------------------------------------
 1 file changed, 21 insertions(+), 44 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 65eb26a0520d..8d3d47a6c98a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4326,27 +4326,18 @@ static const struct file_operations kvm_vcpu_stats_fops = {
 
 static int kvm_vcpu_ioctl_get_stats_fd(struct kvm_vcpu *vcpu)
 {
-	int fd;
-	struct file *file;
 	char name[15 + ITOA_MAX_LEN + 1];
 
 	snprintf(name, sizeof(name), "kvm-vcpu-stats:%d", vcpu->vcpu_id);
 
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-
-	file = anon_inode_getfile_fmode(name, &kvm_vcpu_stats_fops, vcpu,
-					O_RDONLY, FMODE_PREAD);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		return PTR_ERR(file);
-	}
+	FD_PREPARE(fdf, O_CLOEXEC,
+		   anon_inode_getfile_fmode(name, &kvm_vcpu_stats_fops, vcpu,
+					    O_RDONLY, FMODE_PREAD));
+	if (IS_ERR(fdf))
+		return PTR_ERR(fdf);
 
 	kvm_get_kvm(vcpu->kvm);
-	fd_install(fd, file);
-
-	return fd;
+	return fd_prepare_fd(fdf);
 }
 
 #ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
@@ -5136,24 +5127,14 @@ static const struct file_operations kvm_vm_stats_fops = {
 
 static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
 {
-	int fd;
-	struct file *file;
-
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return fd;
-
-	file = anon_inode_getfile_fmode("kvm-vm-stats",
-			&kvm_vm_stats_fops, kvm, O_RDONLY, FMODE_PREAD);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
-		return PTR_ERR(file);
-	}
+	FD_PREPARE(fdf, O_CLOEXEC,
+		   anon_inode_getfile_fmode("kvm-vm-stats", &kvm_vm_stats_fops,
+					    kvm, O_RDONLY, FMODE_PREAD));
+	if (IS_ERR(fdf))
+		return PTR_ERR(fdf);
 
 	kvm_get_kvm(kvm);
-	fd_install(fd, file);
-
-	return fd;
+	return fd_prepare_fd(fdf);
 }
 
 #define SANITY_CHECK_MEM_REGION_FIELD(field)					\
@@ -5499,21 +5480,20 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
 static int kvm_dev_ioctl_create_vm(unsigned long type)
 {
 	char fdname[ITOA_MAX_LEN + 1];
-	int r, fd;
 	struct kvm *kvm;
 	struct file *file;
+	const struct fd_slot *fd;
+	int r;
 
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0)
-		return fd;
+	fd = fd_prepare(O_CLOEXEC);
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
-	snprintf(fdname, sizeof(fdname), "%d", fd);
+	snprintf(fdname, sizeof(fdname), "%d", fd_prepare_fd(fd));
 
 	kvm = kvm_create_vm(type, fdname);
-	if (IS_ERR(kvm)) {
-		r = PTR_ERR(kvm);
-		goto put_fd;
-	}
+	if (IS_ERR(kvm))
+		return PTR_ERR(kvm);
 
 	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
 	if (IS_ERR(file)) {
@@ -5529,13 +5509,10 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 	 */
 	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
 
-	fd_install(fd, file);
-	return fd;
+	return fd_stage(fd, file);
 
 put_kvm:
 	kvm_put_kvm(kvm);
-put_fd:
-	put_unused_fd(fd);
 	return r;
 }
 

-- 
2.53.0


