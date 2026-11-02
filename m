Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1A6607F12B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gr5d/R5Q
Received: by kanga.kvack.org (Postfix)
	id 02D7B6B05C2; Mon,  2 Nov 2026 10:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004B66B05C4; Mon,  2 Nov 2026 10:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35926B0617; Mon,  2 Nov 2026 10:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE96D6B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:20:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57A9DA0169
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:53 +0000 (UTC)
X-FDA: 85390541586.22.D24C070
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98D821A000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:20:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gr5d/R5Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVBne5gselOZS7qaEMuXaEvBAuXwNF+VXq/xDlGRpv8=;
	b=n+hpB3yIuEKlR+GccAImiinBnkX4Ily/6ggtSvfqr+DbkfUoG25o6gqnW9DFN+HNuvPsJw
	jgJyAx3/gQIyh7E2t/5++NGmLkaw8JxkluRoqATmTOCG1gYYF3oKMDLvSwc398y0OMDn9A
	hu7jR4VyMZhpiPJXqF5fT0OaK/5vSic=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gr5d/R5Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632850;
	b=uDhZwrHJUvzIYvtp92/F6VP884433hD13MpjIeoMoVU78oAOUBKxe/J1IwJ4aK1TokZtsj
	vRT4PNExnpK4G38MsMXkCfGbycpAsspjP4/pR0rESKzcy4nlQnp7ajIi+cRFTxIgoZ1jpT
	LZKETH+Kx+IVNLLB3D8W/8fQ1Ue496U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26A9060623;
	Mon,  2 Nov 2026 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D411F00A16;
	Mon,  2 Nov 2026 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632849;
	bh=vVBne5gselOZS7qaEMuXaEvBAuXwNF+VXq/xDlGRpv8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gr5d/R5QulyTLxLD3/MAYMmLMYbT35xK6aId1t52Eow8QSEABCm8rzX4k2Z5I8Uv+
	 UD3L6bdcCyDENgjDUaRYaIjBpv9KifSo7KdKtRyWAroMom4KY5WF+Ln9EUR/OU8bIw
	 cfIbJFU0gkdeaQcslP0HV9lJfr+zxpqlFkl/tfWZ6xjZPkExH482FMNrcXoifnZDpb
	 BBMpFNPyNBOQcsBD+Cr7KjsIhvpuH/wA12Pa4HnVFFk/4VUZAo7SAy5riWBb7UiSlV
	 k2iUhU3k2r67F3NXxANMDiQuT8gkSLpR87qwXkRQSfThiB+qYgkMJbi1jVvEbOj1vw
	 BbGpsyobrAFbw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:14 +0100
Subject: [PATCH RFC 04/27] lockd: let procfs copy out reads of
 nlm_end_grace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1257; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eZ2kMMEIgx0JCcy46KFAm+0lqPvZbTWW97pZVUITElw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG74O2799hNsR6IfK5pKSQjHJsw/YPHc0p7/jSlHm
 OeZhvliHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZ/ImR4eZSzSvCL/kZRC1V
 N2gkpD259yrLxz9novylvNjbUvvXtzEyLO2o59UOLix8XXD14rToR6HSd+5s+1rF8C/DcQqPudp
 iTgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 98D821A000D
X-Rspam-User: 
X-Stat-Signature: kz3ktxzpawjb8urfq3gxq368w1exkf3d
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793632850-77435
X-HE-Meta: U2FsdGVkX18mJaznLzuVYMk7VZX0oy96GmQnO2FMH4y63UuRao4cF6CgGOtS7a/6sB3d4ypc+NasdcUKryHqRpz/aMOfZ5Zmh3FN+vFafOU8n3w2873shdp7/LamWkReBJCPsyffKI0+A1NmES7k/TEGHqM6i6XQwjfkG8ZOVZsSSIB8txBUbpetK5saA9MDD3WuaMm7MGD1aDQFlrNwljjFSpRuyOH4JASF1V64jJw6SPw4KYWv3YGyeWLvm4Lef7s7onZsyzV2+/fU8z/DejkTG84CK6k+qN1pB0njIPSzpyG1Li/aPpWgN1Asy6yvSfQ4UILF7571nOSnGCH1FJ4MRRj8H+rYS2PeF36qd69OvtPleg6qx9pvKSFqWajezp19pRKlhauUocl2QsSQOotNB1otcLD/Y6PCxoiopY1L3Ot14bBa5FqOAEve2aRJg98nV6rLLICPP0fnBJQQo7pJcHu5cP8Eu0J1/vVLOr8Qb/iIjVb2IT2iv93L6pNDvqd4LK5DiaPXkyqoJRJOgi3bFqPa5uNhdMuyhEmrgqlWzVz/2sm2Xmf/K96l3y5bCpGwoLSOYeDBfQE8tMvFjvxybnfAS49DbmdwiMwiXQXOs1+4nlPu5kXcHoGOK1eRykpNqo5LHkVQWrWDO3IrlwihCnagUNn/98Y+uFRMVvUwbEoSz8V8FTj3fhbtq7JAOrjYYyJ6U8YNv10N9gL+X4Fqf9ulvfid+hIzKUWwKs2Igl6aKvP/eEU+imQpgNaoKg4AuiiLYVVHfLhFdBHeNuc4g7vXgmMOdtCZD9oWHZ13bWLGxikFfEWg1pWUAD7cR8Y8wTT96DRkHRcShwwlaHEH1BTCL3iMUGNsN5wSXWMCiMldwlLtJu68xlZoAb51tsGrBt523pc69VIVHwaNAxT7SFWmCOTZzLoEXrguWSYSPVzNzBc8R+gjkU7+lbwdb2BAB1OyGW4nkShCK94
 Y+QCVTnV
 HNipFew99x+5z2CAQ8bKMH5aTK5BxN8j7bQJaJTMqdOYhdNpefFVxg+t4RAPNnelF9yTYBShY+4IY4mv7oLvbNGuUDjefousm/qLCv+cA1pWT12QA6jzRop4LNPU47O/lzS5g6lE711MK0Ke77or+N+gT4jKnVRrRfOHfi0Zrwu8DfoYl397HtfrXIm9xyerB6zdtMnRz+HLMNmtmTVMd8ESDNAmF5rPXKvDnVamGMI7R28Mr7ExpWA/OB108flL0tJHuVjKQzOxlwjy/KqmkFL/4fyXjD9OQVxXij7p/NHfb31eWC2eUU2RmxL7cdjxNXFSdMTj4q2Ro7D0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read to userspace
after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/lockd/procfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
index 47949bec7a09..34a7c3705bb6 100644
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -40,7 +40,7 @@ nlm_end_grace_write(struct file *file, char *buf, size_t size, loff_t *pos)
 }
 
 static ssize_t
-nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
+nlm_end_grace_read(struct file *file, char *buf, size_t size,
 		   loff_t *pos)
 {
 	struct lockd_net *ln = net_generic(current->nsproxy->net_ns,
@@ -51,12 +51,12 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 	resp[1] = '\n';
 	resp[2] = '\0';
 
-	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp));
+	return memory_read_from_buffer(buf, size, pos, resp, sizeof(resp));
 }
 
 static const struct proc_ops lockd_end_grace_proc_ops = {
 	.proc_write_buf	= nlm_end_grace_write,
-	.proc_read	= nlm_end_grace_read,
+	.proc_read_buf	= nlm_end_grace_read,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


