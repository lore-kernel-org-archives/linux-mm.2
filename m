Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808CD6070D9E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k68ttWG6
Received: by kanga.kvack.org (Postfix)
	id 8792B6B05BB; Mon,  2 Nov 2026 09:46:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850316B05BC; Mon,  2 Nov 2026 09:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766A56B05BD; Mon,  2 Nov 2026 09:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4966F6B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDC664013F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:54 +0000 (UTC)
X-FDA: 85390455948.16.86155FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2ADFA20006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k68ttWG6;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630813;
	b=y1OrkmM60e/2zCt3EYMpQsvgaJtbpY5a5Wp0JN9FWiA+Ojq56GjvJlpCnvZyCFhbOSxle7
	HplQWuRJX7pcN53hrLTMZ571lYUboQoT1/sy1nqTCxmpySfyC+/kBoKLnyTSkb4p7lt9wq
	0rNlzksBPX29lIopQ/K743HFjRGOX4Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k68ttWG6;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGh9qQAToZE5wrWgcgjg72Buy8fnK2LgswQGjbfg87A=;
	b=BuuIIo2xAiasQpMt2qAlqpnHE9bjJQiMZjNrl8I3nwRJfi+FvNwiKguUQNdF23mLrMb8mU
	EWQ8pJAG3kNqrdOkbiJ6veL4zOb21B8A7PL1+jBEaF3HKfBxdQr/m/Qhjm5uhu408uucNJ
	WoNhZnl9YQmOmOYXR2rE3Q42rIxZbJs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3FC46020C;
	Mon,  2 Nov 2026 14:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FD21F00A1B;
	Mon,  2 Nov 2026 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630812;
	bh=gGh9qQAToZE5wrWgcgjg72Buy8fnK2LgswQGjbfg87A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k68ttWG6wR2uYUNWQI+ECVf+fO/XJ0eqvyJRIGqlTdn3SeSK5FwYTdTBaVjsoBsYJ
	 kJXwecLDVVqkc0QtPna5nnmOaGhEH6lV2p3+n4SMeLLTjqLfMHRMfS6+IdU5FeP6Ex
	 EEbVMiiZNLXMTNclGmw6p8mC8yLNPYuUSTnCtn6ZR27qjgY9RaX2RJuHLWLPx9jmMt
	 9JJmAL/6SUvZypF7nop8NC5qp7LgJYP8eJFNNtNBvtdk7y2N5+2qF+LGhO9FlXYxla
	 LSU+v/oAHtst3btNP9gxZgyUrKBFNLcCwNm+jD4+mesxl+NmeCWqzBEWi80sNRNQ/1
	 Y+2ZOSQK06ITw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:43:28 +0100
Subject: [PATCH RFC 37/38] proc: don't pin a symlink's entry while
 readlink() copies it out
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ADFA20006
X-Stat-Signature: sy85epcmz5mixkd5j4bmedg1dxeeznyh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793630813-333161
X-HE-Meta: U2FsdGVkX1/+4S74v1Oanct6loKrvJR+ED/XBXmKN4Igil+neMxoNqKg02deSDmDA6eiB0YsC/cpu9tOeFq4UbNjDzPCk7N7bPEKOFLtPuNmxS5z/Jj91jHZ8ZtQ4pmuH8at7oSlY/58VCbkKAfZXDropfQiwbR8DfJ65vdairAFHckbZ+btjKEO12wm8qWcCYTCvPDsA/+2Glf/s0Ld7xe4AenmROjUZWlWWtoTDtRt+Ii+1nM5KV8kckHqHsWV9Gfh3C/lr5PuvlnhMd5tKid1uV/Y99rQNIVLmM35Wr0YIiK85dCxcq3RFelem6uOiKGi4UCQelBmY6zkiwVViKv3JFP706N37P/7DO69apaEgeJrqzgozmDILQHJoDYV9u7Ou3hvz/5vPbFZdEu8oXNFQsrbu1E1JobSC+Typ5fKicUF1ZgH6F7EtjgUtXi/YDnZEPBsdAMFcifL5s18OC49W/1vmgujx3gbM18VqvevMByh4ZSp22AR+gKkKGGIpbIOnfsUt3it93/I801e+LJB57RoUdN7UxIyrYUIGkSfFeBLEYcppyrrlVU7jvzK0ZL0xeEDAOaq6K8D9qeL8oSt5FgpasbifW3XyZ3Yt0MOKrKt+7dU0BJt+BG4Hyi1rMq+NRmAcqGA/mN+YDOqtZHVhoDgEopbQe0IWgsU+9Mwx6kp+kPSY/QST6Rk5ejEEnJ6KF46NtSSVa8dlWKXaR9HCcW1Br/ziJXAaXBntI+gYWSQkY2X21IqcpubYOeyAo30gR8zLzISALE2h/zxAyExtPIKDxbZpgSXdw/yLL6YRfnNr1LEwM2HrAwb6cEYGz1VYE0ia/Whl1MlW/0o0oTtevWg+LNXag4QeE3b7OgbecjXPaKPAnPUjf8M2I9tprz//ZxyUWBD3A2d6LOzvyTtJHNsMNZnYazk6aWIjZGgTMKaSo1+0o2YZZe8oiEccqfAMFGj1ueupIWxP1t
 wNKATHs+
 VEN9Owz31HrY0Txd6/jkGfXcznk5ox9geVbhtX0sp+Z6GnYy1BWqNz00nlheh3xtT7M6udFO6AcgMmEosecixUFNa64GlMx4uHakpZ73LLaiDm4QVEX98tOILyPTPK37j+Pg6LYpg8jR+NnmRjq89vw0orVlVrGZ8sdkF/9ZNW9UHddu24pP9GtNFkEoVfQzw5RsAn+GNXON8gpNaHTM0g3zzHiP0CLXKDgqb5jcBfDyqqsKAtmh9tMA5SivN0/GGq4pdqLHde2w7i2X8VK3D6JZqXa2qEmuvLiPp91+d0SZON626unkpMgHtEbU44idv5RDT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_get_link() pins the entry with use_pde() and the delayed call
unpins it. vfs_readlink() copies the link to userspace in between. So a
page fault in that copy holds up remove_proc_entry() just like the
copies of reads and writes do, and the callers hold locks while they
wait. /proc/asound/<id> is removed with snd_card_mutex and info_mutex
held when a card changes its id.

The pin doesn't keep anything alive. proc_symlink() copies the target
and pde_free() frees it with the entry, and the inode holds a reference
to the entry. What the pin does is keep a removed symlink from being
followed. So check ->in_use instead and drop the delayed call. That
also takes an atomic pair off every traversal of /proc/net and
/proc/mounts.

Fixes: 7e0e953bb0cf ("procfs: fix race between symlink removals and traversals")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 9933f03ab9fb..2d65f3c8ec03 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -629,19 +629,19 @@ static const struct file_operations proc_iter_file_ops_compat = {
 };
 #endif
 
-static void proc_put_link(void *p)
-{
-	unuse_pde(p);
-}
-
 static const char *proc_get_link(struct dentry *dentry,
 				 struct inode *inode,
 				 struct delayed_call *done)
 {
 	struct proc_dir_entry *pde = PDE(inode);
-	if (!use_pde(pde))
+
+	/*
+	 * No pin. The link lives with the entry, which the inode holds, and a
+	 * reader could fault while vfs_readlink() copies it out. Just don't
+	 * follow a removed one.
+	 */
+	if (unlikely(atomic_read(&pde->in_use) < 0))
 		return ERR_PTR(-EINVAL);
-	set_delayed_call(done, proc_put_link, pde);
 	return pde->data;
 }
 

-- 
2.53.0


