Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FD7606EEA6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWOls/Qa
Received: by kanga.kvack.org (Postfix)
	id 4BBCB6B05D8; Wed,  4 Nov 2026 14:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4923E6B05D9; Wed,  4 Nov 2026 14:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381CB6B05DA; Wed,  4 Nov 2026 14:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15F276B05D8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:24:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAE8516070A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:24:35 +0000 (UTC)
X-FDA: 85398413310.16.73E0FB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00677140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:24:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OWOls/Qa";
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820274;
	b=qsQQZhejzif+kFMobDKnDaXRIp+l0smWqlVuHnuS700EItAJamDD4j+cpI7IQWn7VEuLC8
	ko0oKsvRIJcdgoj7ZEsTxCyEJSnGJGERtT13vFjnlAudjQ8lmWCxQh+JoORMiWIIbR0GYJ
	I2aJubDeCEzQPFFBHIXCnnijMEskWJQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OWOls/Qa";
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZnPQiZm1xh8fsSdf/bokwm1XgR51VX0qi8vvYA3hwA=;
	b=ZcPCbNFBBytuHY+sR6wmZ+jyEiZQxuChcwxehb/uMIU1MLqNIqnwHZSqxAWUiTk69NjC5X
	UPpCat0ZuhUR1ZQiL1sJXLvgxgBvOmOc++fCSTUa0GHWk6crINRG6Ej2iCsspViO/rsz4g
	Ze9M3w7GqEd56D1SzOeBXVf3bmRJA7U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8933B60D7D;
	Wed,  4 Nov 2026 19:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6D91F00919;
	Wed,  4 Nov 2026 19:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820273;
	bh=iZnPQiZm1xh8fsSdf/bokwm1XgR51VX0qi8vvYA3hwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWOls/Qat2i8BrXb5K71S2uLB9tj4kjTJEbo9UFvy20m8JsJIw6rlM5z7ZgXmAhhg
	 DX3SJAZObSbZ0q10m0cO34TgAflLOcPAP+hEY5fVaKi7i6rKXFInKLNWloaYRSC+Ks
	 ljGOlefMkwlxlumGHgHWbLc97n+0vZptHyvo04WmKfXqk+oQZSwiVP5UbhoSw45CC9
	 o7GTWTT7YXcs5JwSCwntnLmjdKmMt8KgGm4sAZYEtS+zlJv61izpcMBFUi+CEbW/Cc
	 xRBz49tKkDksLfYIDDAGshWSF63L9oy+SRRSZVZWhxGUtwnTpG3FVQOlOfqrJXfy1c
	 nLtmp96X09lUw==
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
Subject: [PATCH RESEND v2 34/51] proc: let proc_remove() remove the entry it was given
Date: Wed,  4 Nov 2026 20:24:18 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-34-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4142; i=brauner@kernel.org; h=from:subject:message-id; bh=TWEC0A9DF1l/jNuw2UHiBUJ2nMkOgHxIGSf9WilEatA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvyaox39LcDtqOvRJ4ZbOT4aq194fNEiYOO6+EM7j 5os/VhY1lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARG32GP1wXpkhH8H/asV76 WPuPyH/OaVaTHH7dNBF8c4GtfEmftRfD//g/MT/EQt8lq2eISbw5HcGTbfBAPPZ1g/kbd1/h09/ keAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 00677140007
X-Stat-Signature: 1ytgwkqaxrosmtw9i1kec88g4xj6fuo5
X-Rspam-User: 
X-HE-Tag: 1793820273-789535
X-HE-Meta: U2FsdGVkX1+vPG5gPxNJ/79DZUUKcj5/FyhsyEhRXV3XO4K4nV2nvIhF/NUqp7UXyscjqzWWjvtPcaRFDyivUR7KhuHkekQaKNVneE0KMSNo4m3rJ0YiPBcL9vh0ZDPfiU41vGfHLhTFdptwRIOiCox056XbL+urQ5KJ1kTAvAt0/rGGqYSh7FuHtTWLDfgzQHJG2c9/zXUxLJKZYd8KV0kgf0QM5cXpRNNgArHL8M89GbM2TwtpEiTwD7I7oG1Fz0o30D9hoGcqL/FI7IhayR2HW54HXATiohaizRQbFkHUaUCtQCL5a6xj7bsGqgJMTiRCosD7PNwURv/137b46hLXBPP+uf0fHe2lB1adGCNLhWVcqU6SU/uiRRNXgOCGDIdQzy2t8ZR9bFZDF6+ek3dy7qo+8QyT3RxxaCEH1Kj/gFkYoq1AAmu35F3gb34K2ulKFA660oW0ECRjrjScYuZv3i2uu9QK26w1IxkvXWnxeMQ+XHRXN8AtmtikDud4di8WporutB08D2eenmXlYirrJNWllIVqvIQVwqAWdIV5OwqIX+XNq8eYi1GwNzaDjrpIyVxnKOVaBksRGRcjeuxm/KFxfNWfdkn+p6a+wEnHuSANSsksKpH8IOOryEuMinUR/z87uSDw2uL3ylt0vpOojdVPnnHiPSqewfi1IZ1DN3+A4l6D/F7xgpmw0i+yc6He8yiS2WWeX1NrizXSxwSQn585q0W9eJWct6fWO/68KWYpRCe0r3Zu+2woqvOE+f1fI7eBC7Vr+v2jjB1S6/T+yeSTM844ZiVtzRwGTw6WiK3K0acDqHuq5JgBgQfSNr2ZsKkAwOBS1d6Zf+Mcjb/bojpqd6/J9pcRhhbKhVQ9oDo1dvLTEkHyxpHMacRXdS8FXai1o0WqfM41MRIp2xBHsuH7r1WgDoi6W21jijMTlpPMt6OfPy6e4NOR+ytufu4Fpp2HMDxbqRKLSyX
 gxgyXnhl
 WJ0v0gR7qCDnzVtXpNS1SgroVFeK6C7LrPzA8+b3v8ScYMNzoZ4FWppZjUZcsRlIjXZn7D6CWCDBQ+ixNWX3DLMJLLiHQBbORo3PLGDTsxJt+NHVFluCf3amRoKrOwlgz6Q3qVqcx01mjaGJr93VkGzn/rNMGhUthPUIFfT2s5YxSuCfoWES9SvsQsFwXix0/SKp6DdPIywMD8+0oigJMreOaMIM1eqpGZs96hmo5z37VNPfXXi8QrLli56ehWdBCANnyfmdlh8ekyHUK6Ra3AtwxWJPOZWDDC2xYSyOouwA8/WyGpl7uYospS+i3MRDWwK+I+MMlQyHAN7nqQbtmvN0ZA/sLgRR4as2Ee2pMIpCjXzbNyR5tqqgHWyYw5HN+Wk9p1dcsgPcKoZrOBa71U0wLiQc40wrsIGu4OOl8gWVZMiINWFkrHPFPUM8dGM9xP3TzN5gMiJJtsdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_remove() looks the entry up by its name in its parent and removes
whatever it finds there:

  remove_proc_subtree(de->name, de->parent);

If the entry was removed already, say along with its parent, that is
either nothing or a different entry that got the same name in the
meantime, and de->parent may well be gone. Two removals of the same
entry are a bug in the caller, but going by the name turns it into
removing an entry that belongs to somebody else.

Since commit 895b4c0c79b0 ("fs/proc: fix uaf in proc_readdir_de()")
an entry that was unlinked has an empty rb node. So check for that
under proc_subdir_lock and otherwise remove the entry itself, with the
loop of remove_proc_subtree() moved into a helper both of them use.
Nothing can help a caller that passes an entry that has been freed
already.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: a8ca16ea7b0a ("proc: Supply a function to remove a proc entry by PDE")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c | 78 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 51 insertions(+), 27 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 588999058e66..9a0a2fcac7c7 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -818,33 +818,14 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 }
 EXPORT_SYMBOL(remove_proc_entry);
 
-int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
+/*
+ * Remove @root, already erased from its parent, and everything below it.
+ * Called with proc_subdir_lock held for writing, returns with it dropped.
+ */
+static int __remove_proc_subtree(struct proc_dir_entry *root)
 {
-	struct proc_dir_entry *root = NULL, *de, *next;
-	const char *fn = name;
-	unsigned int len;
-
-	write_lock(&proc_subdir_lock);
-	if (__xlate_proc_name(name, &parent, &fn) != 0) {
-		write_unlock(&proc_subdir_lock);
-		return -ENOENT;
-	}
-	len = strlen(fn);
+	struct proc_dir_entry *de = root, *next;
 
-	root = pde_subdir_find(parent, fn, len);
-	if (!root) {
-		write_unlock(&proc_subdir_lock);
-		return -ENOENT;
-	}
-	if (unlikely(pde_is_permanent(root))) {
-		write_unlock(&proc_subdir_lock);
-		WARN(1, "removing permanent /proc entry '%s/%s'",
-			root->parent->name, root->name);
-		return -EINVAL;
-	}
-	pde_erase(root, parent);
-
-	de = root;
 	while (1) {
 		next = pde_subdir_first(de);
 		if (next) {
@@ -872,6 +853,34 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
 	pde_put(root);
 	return 0;
 }
+
+int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
+{
+	struct proc_dir_entry *root = NULL;
+	const char *fn = name;
+	unsigned int len;
+
+	write_lock(&proc_subdir_lock);
+	if (__xlate_proc_name(name, &parent, &fn) != 0) {
+		write_unlock(&proc_subdir_lock);
+		return -ENOENT;
+	}
+	len = strlen(fn);
+
+	root = pde_subdir_find(parent, fn, len);
+	if (!root) {
+		write_unlock(&proc_subdir_lock);
+		return -ENOENT;
+	}
+	if (unlikely(pde_is_permanent(root))) {
+		write_unlock(&proc_subdir_lock);
+		WARN(1, "removing permanent /proc entry '%s/%s'",
+			root->parent->name, root->name);
+		return -EINVAL;
+	}
+	pde_erase(root, parent);
+	return __remove_proc_subtree(root);
+}
 EXPORT_SYMBOL(remove_proc_subtree);
 
 void *proc_get_parent_data(const struct inode *inode)
@@ -883,8 +892,23 @@ EXPORT_SYMBOL_GPL(proc_get_parent_data);
 
 void proc_remove(struct proc_dir_entry *de)
 {
-	if (de)
-		remove_proc_subtree(de->name, de->parent);
+	if (!de)
+		return;
+
+	write_lock(&proc_subdir_lock);
+	/* Removed already, maybe along with its parent. */
+	if (RB_EMPTY_NODE(&de->subdir_node)) {
+		write_unlock(&proc_subdir_lock);
+		return;
+	}
+	if (unlikely(pde_is_permanent(de))) {
+		write_unlock(&proc_subdir_lock);
+		WARN(1, "removing permanent /proc entry '%s/%s'",
+		     de->parent->name, de->name);
+		return;
+	}
+	pde_erase(de, de->parent);
+	__remove_proc_subtree(de);
 }
 EXPORT_SYMBOL(proc_remove);
 

-- 
2.53.0


