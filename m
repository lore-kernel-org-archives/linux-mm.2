Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106F4606A330
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FISzkgiD
Received: by kanga.kvack.org (Postfix)
	id 338836B0615; Mon,  2 Nov 2026 10:19:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F896B0616; Mon,  2 Nov 2026 10:19:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226056B0617; Mon,  2 Nov 2026 10:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F40E36B0615
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94FF9C0113
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:19:51 +0000 (UTC)
X-FDA: 85390538982.25.2888C99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0D1DC0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:19:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FISzkgiD;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8L0vvGY5Km24xgHgPbylEP8c5DuS625RCEauDmBOHw=;
	b=JrWzlDSAOGW+b8ZCIw3HPRj9D7VfJc9percOGMhxhPD1q9wZI3uOfHwv9rX9v66DTblRD5
	U5gy7djD1UOzCVqAjivLHM6paWRq2glWT7MJ/aHR6ZFpxvYlze1xS/Ji85Uas63i6VX3LY
	KYTqtf+T3d/LORf2T+C91NzMkpvUlZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632789;
	b=mFPgaK0vINZ8SD80oIDmkrxezo0ihRspIpqIkOx56a/UNIpPbJPWlk5zHrRzuYbDimbyXv
	4yQol/m4FA0SAM5n/ETBiOkfXJ6ffRj2QARTAh5gfWkeTTjC9FQk7P55mU75IRPc6iDLgh
	7AOh8oBsFXZHIei1FLy+4acF5zCqOxk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FISzkgiD;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FCFA60A4F;
	Mon,  2 Nov 2026 15:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6A21F00A1C;
	Mon,  2 Nov 2026 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632788;
	bh=o8L0vvGY5Km24xgHgPbylEP8c5DuS625RCEauDmBOHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FISzkgiD/yGuvR5vmXFKZeW9WfMgEMNzsKuSLgjo5EcXuoWsQeOK9E+zoYez94iwP
	 kd6gyDs+JBsqALh51n9A8+QTvp0EtTnI1VuAQVToT3JauFOAYWcitc4Ij8VOStoQHW
	 HHtZ3oepjBq45VLaZrj+hF2sTz5wHN/lLPiI7eNqaF7rYYCqUQ/+mzk+bSyv7sw/P2
	 0Gtuci3mXrlYHF3T4dLdAjX8+3RrsfMa0Ybz3rc2hywNaARmKsDWWKsP2DPHejgwhY
	 CSyzQiOBTaMPhT4NH/NFnIcCftSoSwRNaEqIAiartqZhauq2wH7uX/8R0Gi2xJOmu4
	 rQ5tXNgRbeYdA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:11 +0100
Subject: [PATCH RFC 01/27] jbd2: let procfs own the seq_file of the info
 file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-1-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2318; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4wXeP/X63evRQ0XlRmaO+RfgvVw7qBYaC3PXgCgMk/I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG74e18U46btbmdaLFZySH/a4bJqy6EXrWETf+nEX
 czabLYjsqOEhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiiRcZfvz/JWB5uf7z1qfa
 eR5bDib8Y7/02ydhzb6jJ8MZJrVNc2VkmBYey/3mL2tK5+xlRYFcaYV+5zS/m7WkLC2MPxt0YDU
 PKwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0D1DC0007
X-Stat-Signature: q3ng3ds9wd5meiszs6dz7nu7ut6tt6gi
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632789-171733
X-HE-Meta: U2FsdGVkX192IjHznmWqJQt1eudVT7WbGUcHoHkB7kewTx3gDWCnYwscWtXENFe0Qg3GIbjhcO4KsmHg/CyWa+bGMiPBoCVZ6obviErgwKv+ZVupGbTNcqCRvQWdK6U/kg6q2Hkf1rBLDFvB624eupEXgb8jz5O+manCoqms04+KGn3KTt8n5OKXVdOXr8oevm4IwjskOzQiu18zxUoobRj1zO3xIHIAhWeSx8mh0qKs3QGHbBm12ckGG8OhljZp9nkzrVqNqh1RaBCQW/CxyMnE93RpAzq8lD6JYdhjgTLWwFi1ACemiWmy73knkc0xS7l57v3wnL7yPY+2ZK0EOR+4d9XYg8BVT4Wa/cHLm9qwNhkp5T1tuL7xD2x+2YoGO/DJuZ1xSSqxzDdkFF/s5YZGpt3Ibg31C6H0uzmB9CIXY4ufmypcg6eE9Eqwk3V8zURaHVQrLVyX+8pxCQN8q5okDeSqX6WVvq/9TC8/4ZMH8F+s8KaIDTdmvs/HCioevV3c7gqehgcXmrkcTbIYqbpiDsaPwVeat3sm9gZRwFInnp0N5ivqsR12okO+X6EpEgzOJy2dIYi+xf5zge7/IvsZZ6wKyX3YXy3QOgory1R1rRMS4PqLqRhSIIUBXZIoohZut7oPklofsBVikQouu8Brtk1Y6W9sCoqrT1ds+zD/wnEKgIh8eciDZzB3F9jBtA2PJkKCBUJpksnNdoPMo+tdVV8XXt1yXe1bwDoJFHhF5tWBa11Cv/c78j9Z0QdefMlmDe5W5CDkHMSlL5Mb3EPr7gKrDICuZ1/8gEZYkes1itMl/EHl1ezDMDrrl33WfzjBUrkX18TUGERcbTwTTKvQj+psbQd6N1+K/pYLjBUnoQpbwlMvElwIHdF1XMC8S7XkMclMFD54NI1MZFM5JWR46PUo5E35fKI2CnJFUVW+9npoU0sS0Y5oGbVD+r5/6TDwOEKPX1dlqj9Qs//
 c0Fw4spN
 EANLSOrRml5cnz9mdCqhwJeUnkRz2UrxBhIYLTAmx5Mn1PW76oGUPQsPWG3TntPtqlNQ7wCOYI/l0guQyB/zGkJpHCjLGT33YAncvuxc+1fGYKHx3CotPUmAC+oclZAf5d2wFMyvOlqd/WMhVZJLajw1K0Z3Y8hzjYPktveHnHUX41KZ6Nfu+zWy8Sm3Rt0cHel3WSDWoncUUQw04s2Ro7um52Ub0lwhlHH6ECgn+MGbITgJYv73ETG12MknL4ihImq7TOK1+vm6N5EgGTLtLHd1YWgj5Em05JvuHkWg27zV6engiyRWJHtB68Os1miEYhlTjH6Fmu/7vG6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the session state and let
procfs open and free the seq_file of /proc/fs/jbd2/<dev>/info.
->proc_open() only takes the snapshot of the statistics now and
->proc_release() frees it. Reading the file then no longer holds up its
removal when the journal goes away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jbd2/journal.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 3a4f3f613ead..1e4f4e95a00e 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1173,51 +1173,36 @@ static const struct seq_operations jbd2_seq_info_ops = {
 	.show   = jbd2_seq_info_show,
 };
 
+/* procfs opened the seq_file and allocated @s */
 static int jbd2_seq_info_open(struct inode *inode, struct file *file)
 {
 	journal_t *journal = pde_data(inode);
-	struct jbd2_stats_proc_session *s;
-	int rc, size;
+	struct jbd2_stats_proc_session *s = ((struct seq_file *)file->private_data)->private;
+	int size = sizeof(struct transaction_stats_s);
 
-	s = kmalloc_obj(*s);
-	if (s == NULL)
-		return -ENOMEM;
-	size = sizeof(struct transaction_stats_s);
 	s->stats = kmalloc(size, GFP_KERNEL);
-	if (s->stats == NULL) {
-		kfree(s);
+	if (s->stats == NULL)
 		return -ENOMEM;
-	}
 	spin_lock(&journal->j_history_lock);
 	memcpy(s->stats, &journal->j_stats, size);
 	s->journal = journal;
 	spin_unlock(&journal->j_history_lock);
-
-	rc = seq_open(file, &jbd2_seq_info_ops);
-	if (rc == 0) {
-		struct seq_file *m = file->private_data;
-		m->private = s;
-	} else {
-		kfree(s->stats);
-		kfree(s);
-	}
-	return rc;
-
+	return 0;
 }
 
 static int jbd2_seq_info_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
 	struct jbd2_stats_proc_session *s = seq->private;
+
 	kfree(s->stats);
-	kfree(s);
-	return seq_release(inode, file);
+	return 0;
 }
 
 static const struct proc_ops jbd2_info_proc_ops = {
+	.proc_seq_ops	= &jbd2_seq_info_ops,
+	.proc_state_size = sizeof(struct jbd2_stats_proc_session),
 	.proc_open	= jbd2_seq_info_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
 	.proc_release	= jbd2_seq_info_release,
 };
 

-- 
2.53.0


