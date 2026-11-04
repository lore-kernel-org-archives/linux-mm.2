Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E3E6090498
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYsPe7EK
Received: by kanga.kvack.org (Postfix)
	id 97EC96B05DD; Wed,  4 Nov 2026 14:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958656B05E3; Wed,  4 Nov 2026 14:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DB96B05E4; Wed,  4 Nov 2026 14:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 689976B05DD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:50:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10FDF1C3FB5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:09 +0000 (UTC)
X-FDA: 85398477738.10.026F280
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 74B4D20006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYsPe7EK;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821807;
	b=43+LSq3+uIfkVyexEtTe7UBIwJwRv7BUvWOZnVxqDmbETxzpx3fvGHJUx/4HgrnHq/5QDr
	BrzUDPICK6KgTM5dpMWkt8ltyZjGw2CD1VTjlFmyuRLEWQPCXcydMeZ1nThic+9Eiw0hmk
	mPCGiZoZyhH3KL5X0OXax2iVKQBCL4w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dYsPe7EK;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8L0vvGY5Km24xgHgPbylEP8c5DuS625RCEauDmBOHw=;
	b=wbv6NW4v7HNHSTiN8cu47nYZLh6Bqnzbkofn+vnu+p3kIkD3DB3BfOawcZ2EgvWnkpCKIx
	cQPZq1wSsfmEXOAPsboUvq4+1xh9dlGMwemgfqDhg7d6iJBeHnUwci3A73jRZqqPRCc850
	IF/Wb1cbBL07Z9VQhwip00P3szrtik4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66EFF43A0C;
	Wed,  4 Nov 2026 19:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004D31F000C1;
	Wed,  4 Nov 2026 19:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821806;
	bh=o8L0vvGY5Km24xgHgPbylEP8c5DuS625RCEauDmBOHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYsPe7EK9xlznqxSarRjMWb/keF20UxFAAIxFblrc1DyDdCICYC0tZhLXHGBEjv2m
	 wlolIDJ7YESPSIUpyajqx3Pi5Z9zhYfRI4siggX085u5ZCM59zXJsjvpX8buE3Tg23
	 SlNWXDQdYn3g1vBGkIMitmFjx3pOOiiqYXRBb4AvwUHkH0/o2nSoE/7xM2+bGZtgQ5
	 OviczvtzIq+aURT2ywz7ETtS4VmDmtvxHciSqzRG/NUK0pmlve0K75uh+30R9f7Khm
	 DjfChaLv0h87xnlfhv41ydwZ032RXJPkYnLbVO+AjaHCHz+rJCzl03k7b2tSTGaF4A
	 finR4PnDyeWlA==
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
Subject: [PATCH RESEND v2 01/30] jbd2: let procfs own the seq_file of the info file
Date: Wed,  4 Nov 2026 20:49:51 +0100
Message-ID: <20261104-work-procfs-fs-v2-1-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2318; i=brauner@kernel.org; h=from:subject:message-id; bh=4wXeP/X63evRQ0XlRmaO+RfgvVw7qBYaC3PXgCgMk/I=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tFWfOxU95GH3XdJTEYBl8knnmuK/UXrVrUrzorQz FINDXTtKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmEieL8P/uohlXprsW1qaIpK+ b1x9yGKVsvXjy55Vj5KKjk2tPrHQnZFh1Trl08dUnn26v0t1fseh4COavFYvfAQPnCsMWqPzN0G SEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 74B4D20006
X-Stat-Signature: 73fqnwhhsu8aiun3z4p7rn5nmgjseoyh
X-Rspam-User: 
X-HE-Tag: 1793821808-210328
X-HE-Meta: U2FsdGVkX19IDdPV1eUIuIeotIbTXuB459RhxRhJ9YXdus8Iwtth56cxRkZ1KFUEfKBhujnM1g5O9kpzPRWRl75D4BSOswmCAlzEjlQd888mkDu6bADSCHdFhAmnfLGi35TdZHzE+KE5Wa2UWLsQx8ezDXBWDe4Rwt1Rga83irkrhFuO9II3TQcjmaupa2PRBlnZDST8vz9F8OquzHeV2yLtxT8HQb1zeYzvWuAd3/DbDz5GXGDccVUkteljksT66drMSaCdldiLSIa7ZxoRoE4NRQ17O6c+UPfew8pEoQhsQ80L8mHjayERnt/jS1M1WTTWs69swgTl8NfYb4rnakvEn09oeYX36lNZcfRVzdSpfwJQPPR5rLXXz/dYxrapapF8BgdBDRNKiKP12G5OssTk4qDJjmZ+I2MRpLyoAPZ0/2DWPwzXwY6PeeibFmCtLxWs35MUIncPp47XTq3y+zMo3ie7H0H/t9rfhr9IL8NPwcRcpSIEb7VT+eauW/OMAhy/mwv3lZRfdgaNYUT6FR7pvxJY71zVrPCPPK1TUiX2m4nsKnkTXizNLo4Bl/8XreLclIBmTGRrgW9HdQqMqy5UGmBSVOcT7CK0Deq4WffjQqh++FK+M75oPaTKQ448wxlVW22fdrk/JNTFFzmV8k8AGKXRDmjJ2oqetvyhEAwkHX+9+6cjWHdSnxUS2zN9R6f7NKbFhJq3AoBgyIg+df2RtQg9gjGI4mo1mELspf3os4QoHI3XCGphNRCXG1Pg2xe0BNp9ZUH5qPxe/noJPYHrDR+Orw7So1aMlC0V85pfURd6rfN5j6lFASTL4qrnidOwNfvodgecta7Jws4Eog6P4VTCOYVqD1v3RFZXwAb9sn8Z60QjsEADNfjBgKLHiwNQUSqNj9eup4dKnKZpsYM3fq4+WPSpADA/YnhzactA1cbkg7hMvsauB7VWNxFnlTciTyUkZVeVVTsbqf1
 oSeP0jfi
 1m7DnzUHsusoklW+qhOqRsBCIsNZVUn2ia8BGuXvswCqwkZLgU8nNNwtXH/4eTNXpFW/918DhcO73sFi0rdYEPf7qtebowAl1HFIoQCcZbGfwRmmrsW751+UkwK4t+c/t29cTejYZCRo7qjzCV13v+tssdZxyU68ckrmZor3A7Vm3fasRv82nBqs8UmXsayPMt5bnF+Bsz1XHs++AG0UcChEe7JBoubMkk4g3iWH/HdYEuuMXGwlG115bqeDnxAIQ9A5lXLqdwIkdA165F6NYFnkapGWDrPWD4xqscy2TE+6tECeedAVg9pGYLM5f7BYlxbptKsuNCS1uYU1Clp70qHYgyID5fTVjzbVgmHAExNooYmc81lR9p+mrsUwJ3KXQgBw24H4Nonela+kLc2jUFopzM8w8Q2Tlp+vK6twv9akO4lga+vFqA7hTSFJhJtM8CZux
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


