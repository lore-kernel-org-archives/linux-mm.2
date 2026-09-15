Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1932CC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2514E6B00CC; Tue, 15 Sep 2026 07:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228486B00CD; Tue, 15 Sep 2026 07:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166CB6B00CE; Tue, 15 Sep 2026 07:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED1D76B00CC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62601C03D9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:40 +0000 (UTC)
X-FDA: 85215794160.03.F2536CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB93B20002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=keM2MELZ;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dR2AT7slAh5QiQGKBciNLhR24TAk5bJ3ys4Ah5Rt7mE=;
	b=EQdaXbsP3YuxX555kArMY5zhO3DuS0afppqFBrFH9IcSqR2mhLhLR82bUNtM8NWU9HgVmM
	0s4SS1vGn4/53jign9yXa2NOkhcgxJC0EDVZiZdK74k807S6oL3rW0/QQzMiHsF1QCcp4z
	+8YO9FRuCJNLDr+AsZowWbIvKPgxGOM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=keM2MELZ;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472198;
	b=yCUbKEYBzwRC5SRzBztm0uUUG0/4XzgQFonL9aKn4LXXR0bCEc8am0YvMpdJjnWxpAdy0I
	xw0H+br+dnExy9pnafHewkyk1xRkJts06vOWrIaWwJdKc4UqUVxvtGQd0mr8BofNwbiRJf
	hpE3EgjTElYT6HGhOYYDpsZ+4yeIgek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 459BC602D0;
	Tue, 15 Sep 2026 11:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948881F00893;
	Tue, 15 Sep 2026 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472198;
	bh=dR2AT7slAh5QiQGKBciNLhR24TAk5bJ3ys4Ah5Rt7mE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=keM2MELZ8tMeEj63s6rILS1a6ikUND0cm/hSBjQN5i9zsMHRwumL2LpgndOJca1Aa
	 97kIpfNmItf2JE76ybod5HhCCbaR3uSYEM810jrmgilIii5FRWRh1O86tNdM0FYWJl
	 38f1UHzSPEd+hj/T0Nlt8QEoyRs4wb5r4JVdV9i/rSIOmEYhsfaqAD31KqLx/f0h3O
	 ACHfbLbzGXb+++iV7WaxfM+tTIGP+WsUWGxYSjDxuYEbOqm0MVVuZjc4buiK4jUw7O
	 C9LHTBiZSEultvzvuQBhaDEJQMVPhyftCJPppnofTMl7IPUPEYHfgCv4gmlMrEOmjT
	 oPjncB8aAwY0Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:27 +0200
Subject: [PATCH RFC POC 41/50] KVM: guest_memfd: stop putting the
 descriptor back on failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-41-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1418; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KLCbLLJNzFhK9KnJoDv8kDUlKXi4pqPjbkN6aCwr8bo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kk/tfzHImu/Gp6ZRSssN5fyinw4ruUhZCIkyWFT3
 bH7k9a5jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8sWZk6GKcxbHPfdfrbYrn
 f0Zr1u290KLF8etT65HPSeyxa5JK9zH8jwg7xHPKv6v/9/8HHp3fHOUXznI3MuD7/nrNS8a/OUU
 arAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: cxhb6iwsts688ust44xxrwgqde7tmonc
X-Rspamd-Queue-Id: AB93B20002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789472198-176530
X-HE-Meta: U2FsdGVkX1+uOON4+HJzZjnyCCl/WZdIxX1gIvIdLzeKF8IRygRc0+Ptrov2+C3dI/JEqjxmTYcQFL6QrHXnkDTTebjgT8QVrvgUKc/3jq5I/BAfbVgFH1SJWBecahZtt4Q0FaOy5Eq0hy7f8+5WlhbEoqYZKr2QYiM52Aosis2+Tx10IX7V7oxLVNMJ3r2hoQVhXRoxfV0MG9UGyUD+F+66qu1O9qLRuoUNs6GOg19bok5u5r59v7W4BXfRliblRJKqy7VDuz6688vC3BN5ctoiWzcbqimgX/M07vtZ2aNtxtTMNALPUir5PXgw7w6hECeAuROA2/0zvyy6KFeHvP06qIyLKlxMaV1v3rbKg25ZNxEQWec2SigT+HFb2XbRRTkMtk/8c5ZN6cgmW+4JLZZedy5e4WRrE/xWpPK5udX2EgUi9UQnzzF/ml6eFqUT3+YZUXge+AbszgwbQYAqyA5JiGpaJz2N2ugxB3CDxnKwfQFA7q/NT+M1KA8gj84TYQpIWa7LZS/qZOMW+XDLL27yeXjGqgLO3KyS3/tfhIDU6eLLoBZ4kt3N/Kvl70rK6HVK2ccEHRHWnonZkJ5mezB0/CHN7OMkquiy0cLNjJYNWUFEUAgRfGkVLPP3NLaZK5EIKJXPqVMFAreu0M6VaHZ0d23MFk4U+O4SsAfXvus/u+DI00GFTTtckljSMYl+zPhQs6FDYCg5BYibyY6nk7dMFP9ujVlbDGPJQcA3EyZn7blqZ+5iSaaTqyWzgBu7dvXXZIZcK65/a1zvyCsg7CzIMFBS4noNtEMU5FiRZ1jVvvvWiDfzk6LJQAGbrldEjNbSbWLWyymbV2svKLzDsvLBn1g6hAuWtxH9UWncZhAE6+rRRKdZL58XOcBDPL+z7zU+MbrsaTmGSPiM9b6j1t277htoIS11cUbHS4I+p1a4ESV/nyzshmSTPfKjpvrDmNYVTN+Jl/SKO9yLTGT
 oPy8fMr/
 gm3OxvAVKpVAxOmvA2UJrIrjqBBdyue0I0l4YQeIaO6BCOcB1RLM64oMyWlrpSxdNoZgpc3iuN/5mGOSOcHTZezs0QAm5weGQdGk5GQGF2JV7KRUy8Tr7dDS+SrZ2MdB1C2pFYg07TnQX46dz1VR2PrYNB6kuq1yR2QVu66MoKP83WcFDu/6mXF5L8Qc7r9b4jAArROUzz+Hf22YVLk2O/VAmaJOn43H6XOiDMq59X3AlhRmktt7kue5gX3C8FdhN+Jo+xKSzVP+qwlZLr49WtxaE4zkcSqBmkuY2o5qCf+a5pGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 virt/kvm/guest_memfd.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 625e62e1a031..e0d1cb869342 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -526,17 +526,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
-	int fd, err;
+	const struct fd_slot *fd;
+	int err;
 
-	fd = get_unused_fd_flags(0);
-	if (fd < 0)
-		return fd;
+	fd = fd_prepare(0);
+	if (IS_ERR(fd))
+		return PTR_ERR(fd);
 
 	f = kzalloc_obj(*f);
-	if (!f) {
-		err = -ENOMEM;
-		goto err_fd;
-	}
+	if (!f)
+		return -ENOMEM;
 
 	/* __fput() will take care of fops_put(). */
 	if (!fops_get(&kvm_gmem_fops)) {
@@ -575,8 +574,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	xa_init(&f->bindings);
 	list_add(&f->entry, &GMEM_I(inode)->gmem_file_list);
 
-	fd_install(fd, file);
-	return fd;
+	return fd_stage(fd, file);
 
 err_inode:
 	iput(inode);
@@ -584,8 +582,6 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	fops_put(&kvm_gmem_fops);
 err_gmem:
 	kfree(f);
-err_fd:
-	put_unused_fd(fd);
 	return err;
 }
 

-- 
2.53.0


