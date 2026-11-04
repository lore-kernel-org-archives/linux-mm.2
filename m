Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2406606BA1E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gJgUQqFP
Received: by kanga.kvack.org (Postfix)
	id C3FA86B05BC; Wed,  4 Nov 2026 14:30:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17A06B05BD; Wed,  4 Nov 2026 14:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B064D6B05BF; Wed,  4 Nov 2026 14:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85C0B6B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:30:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 202BF1C4236
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:30:32 +0000 (UTC)
X-FDA: 85398428304.27.A35FEAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E36420005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:30:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJgUQqFP;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PrbyLDFAjoLX2WIUniAe1t4rzdjlrNCOM5s/iYEHW4=;
	b=xMpTN/b6DNSvzaP0YvFq0+Dm8kzQy6N8tlt1nNQnevouFiPyZv/QtTrhh1PjIxyemAxpPF
	iDe6JHXfioLJOFHw3AY4zRZ8OhsJmtnavKbW5usFWieqPbskm0fs/vchxLkO4hAZL7pi1p
	iKJar9jcpbXwO2aADLC0EMfhujZ6ANE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJgUQqFP;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820630;
	b=B85UnKcGmYk+TXy0lTc97sZ7cAIzexkJXCd4cib67StESqsdG/7V5702WzOoEsD4VwwdAG
	JIYQaLGa+yaM/YgnIbSCzTmFjbl9Yk0M6FJU+j+wLos39LTk/AqHGQbvReUxBiS0Cn8jLd
	Dt1Nmkq8fOFTUjP61fktzVho/rcg52U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01CBD60DA1;
	Wed,  4 Nov 2026 19:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E151F000C1;
	Wed,  4 Nov 2026 19:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820629;
	bh=8PrbyLDFAjoLX2WIUniAe1t4rzdjlrNCOM5s/iYEHW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJgUQqFPUdfHqbzO0yydZhimAxOsTiy3j7Gg5403vTetiLd8TkhBazxxcEfGmzx5W
	 rVciL31qjq1dJ+7plUgL+tdmo2E2SJQ7PTYtqCx2yA5ZQXmFwpTZ/BfdBiLoaoCUxG
	 lL06dxOJ7GUHhT6w/GTxKhllfZZxjGQKGJLvM2FgsjQySeffSyuwGPa5N1ogUjy23k
	 pyZhFAReGbPqZK/rsbfRogg889zRCaP4JZXtWySOnvmSw9BhOsw3KUl59GOvqooX4d
	 kXIZOW4f1sN3bBLyMvSBrt7Ky8oqzKQD4BdDN9Z0S+Gea/SE9ghcz9qcFKMYoNacQt
	 L85SUfBFwN3lg==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 04/23] proc: wait for the last user of an entry with wait_var_event()
Date: Wed,  4 Nov 2026 20:30:15 +0100
Message-ID: <20261104-work-procfs-core-v2-4-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2591; i=brauner@kernel.org; h=from:subject:message-id; bh=fMKtT8cQ8gIJJgjvKUq4bmwIClHWmBxP0YQIj81mIGk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bi+tjeLVK3NRu/3AwmDiBg69+Yv9Pl1qUCpOO/S4p eB88dITHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPp+s7wP+3hike1RRfnnrx8 7ZbO37kO/mV/VGsDH0zbcnLeweWXS50Z/ucLe5/PfHaXt52J1YN/QouDsniPCP+rzsMti01ecAp LcAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yqsgj87x9hqaoaddiq79ctxmmjef8hbx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9E36420005
X-HE-Tag: 1793820631-580268
X-HE-Meta: U2FsdGVkX19EYp4/W9P6VlDS5nIT4ews61TtfcZnn5ee/KkDN59CU/TytYRpDuRCNbO8WlcN4ft78igTSMXdmfNKHAw1BtnYqYlTorsjfEBHdaQXGTMorHDdoMjo6rz2NFamxNl9dpjPa8uDFjac0q3mh/u7c2gNUCIFBgPbKC08wyiOQZnJbjnligcvm12EJ71Lb4eYs8PL+AwSFeffVJK3fzaj54gRmkRcRLqeCcwhxeqjxrQi+x6RvLnWMda/17D+Y8EyKQz2fMIlrXf18MCagtVwhuLkLoAtOY323sNq9IUrjo8ptyNdkQXBRUSuK1jQfh3tZcW587pWlkSGdkgX8wcr/er6IupRic2UcGlZpDvMkgs127Gi40U7KmhKpCqPzxztHbSwGsJneFThUmhtEg72k6uWQgTRDz8xh/bUnKWTj5c2N+ufws/+UXty1FIHSU7ZaJcc+9PA6v4hkkBFffRMgKsR8GfdeYVP8n5OtwXcjN1r1DvHrMdOwAr1x5vSFFW1bdqt3U6RriGZE3Fzpe85YEJkomraif7faKdQugEeTdF/s+0vg9FIAyOWpytGdl8J54PqulBBHUriRaG3yOx98Hwo6PB6Wc+O3nAzMZUI2SVKiULahkycFk0Hv88I6EOkC0kB5fIrwdIWIUJxxD+AgNSgD+1DJxvDd5spNRjANFs7OCFl6I3DZZakgmaMflpZCS6PSheq8PzztQrNl7uzeb9Escg9e3dXcM1BmduNrPJoHKMoloE6s4Y82KS5QJ6p7FA93zzDAVAiVYCZxkkVAWfwbL/Q2ShteAn301gDT0ObZZSBp7auN0hMjRX5sNZkYRlze7iAwDyspdenmPvbzyDbTH8l3M/FUJfjlqlQf6aeHKMU2zUDdTkYUuZLzbSjQYu/F7TS5k1F/Ta81ERmNDhHORQVMo8N0NHVP/B3wwzHJGHq2sBA6/nINCsFQcFFL0rZrOnSGTS
 iss7A6OH
 qP85Ek6FnG/VaGAA1gN6ow79vP0XQgnHc/WTI0diokpokTyQfrLTlwYUht6U6fqvyfAyhNPo+JPeUjEW+QUpsjBD7HqyPNCWGf5gjhZhQtQTY6dBA0EqCPCOeR0TtfJsZX3IlIyWNEFXT+nodLKJ7/RIULTBDEO3seOEyoCmqWkpavZ4QQzXyaQxg60ChJtrZctcrrC5Cm7SIWzO/xASS6sh3xVW3OcJbRSzB32GOE5g7sYeAD9Xol4rsFKs9g7Jk8Fdp9HpCcPOJkpONiiJP6iqlw5QRWs9A7PHUuMr/O7KNrWOzLrX6/7vJuvUzcKOv0iR0biNg8VGM//InDxs0hr2bS+/UinFTDICptq4oRk0/bByv11rBrk8hIiXhWyEO1z5lr3oEtG9Hfa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_entry_rundown() waits for the last user of an entry with a
completion on its stack that it points the entry at while it waits.
That's a pointer in every struct proc_dir_entry for something that
happens once in the life of an entry, if at all.

Wait on the count itself with wait_var_event() instead and let
unuse_pde() wake the waiter with wake_up_var() when the count hits the
bias. The waiters sleep on the hashed wait queues behind that, so
procfs doesn't need a wait queue of its own for this, neither in the
entry nor a global one. kernfs keeps one per root for the same thing,
deactivate_waitq. Note that atomic_dec_return() is fully ordered, so
the count is visible before wake_up_var() looks for waiters.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/inode.c    | 7 +++----
 fs/proc/internal.h | 1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 66a3688757dd..8795add1898d 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/mount.h>
 #include <linux/bug.h>
+#include <linux/wait_bit.h>
 
 #include "internal.h"
 
@@ -203,7 +204,7 @@ static inline int use_pde(struct proc_dir_entry *pde)
 static void unuse_pde(struct proc_dir_entry *pde)
 {
 	if (unlikely(atomic_dec_return(&pde->in_use) == BIAS))
-		complete(pde->pde_unload_completion);
+		wake_up_var(&pde->in_use);
 }
 
 /* Pin an entry that can go away around a call into it, see use_pde(). */
@@ -266,11 +267,9 @@ static void close_pdeo(struct proc_dir_entry *pde, struct pde_opener *pdeo)
 
 void proc_entry_rundown(struct proc_dir_entry *de)
 {
-	DECLARE_COMPLETION_ONSTACK(c);
 	/* Wait until all existing callers into module are done. */
-	de->pde_unload_completion = &c;
 	if (atomic_add_return(BIAS, &de->in_use) != BIAS)
-		wait_for_completion(&c);
+		wait_var_event(&de->in_use, atomic_read(&de->in_use) == BIAS);
 
 	/* ->pde_openers list can't grow from now on. */
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 6b61d09ac5e5..ab4d7bd1fb75 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -38,7 +38,6 @@ struct proc_dir_entry {
 	struct list_head pde_openers;	/* who did ->open, but not ->release */
 	/* protects ->pde_openers and all struct pde_opener instances */
 	spinlock_t pde_unload_lock;
-	struct completion *pde_unload_completion;
 	const struct inode_operations *proc_iops;
 	union {
 		const struct proc_ops *proc_ops;

-- 
2.53.0


