Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BA7060897DB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R/SfkjWl
Received: by kanga.kvack.org (Postfix)
	id 525EC6B0608; Mon,  2 Nov 2026 10:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD196B0634; Mon,  2 Nov 2026 10:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413166B0635; Mon,  2 Nov 2026 10:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8B76B0608
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:32:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3CBE1A0164
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:32:12 +0000 (UTC)
X-FDA: 85390570104.05.0E7155D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BE9741C0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:32:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/SfkjWl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ScPPr5h13RwAGNd5LaTn6V2vw4rEmThm0/Me/ibEcc=;
	b=qhbsujFxsoNhfTPnn9htf+RJYT5gYE2h3Li0VpyEsKOB7a8TDHT/6ihcX48a41U9pph8LI
	gCtAFCKO27b16ixadno3plJ9dMSuFm+mSLFrsNHLmg67+3PEOb6vBDz5ZtusuOPAYDlenn
	GNkk7XHnWrE1fMlVkHJDyR5Q4p09i4s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/SfkjWl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633530;
	b=dHyoqQ5FJC2o34khv7CiwBaHm8r3PDwMSm6WPx1054f/e8LsxDavwS/kjbjiyBVL8eGXun
	nCSeQGJbziPY0llmzcxrpstVjWyyFBVwaJDm4imDo8rPk2ekBIRr1ZzKl6X4A0jZxZVxFJ
	1i9Xkt5EH7fqYXmcDr7ZNAEUA8AtDnA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 125BD406F4;
	Mon,  2 Nov 2026 15:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834041F00A17;
	Mon,  2 Nov 2026 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633529;
	bh=/ScPPr5h13RwAGNd5LaTn6V2vw4rEmThm0/Me/ibEcc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R/SfkjWlo0adylJibXR66wVpuLzM40UvXOuxgQkxjIb27PygVO01Xo6Y9Cxv0DOYF
	 U8vDJ9Lvryykt72BGFLhvtk7I7gcq7QnZbl3EX+DRor36ZfRQHoTy18ofbXZVWub8x
	 loiIMfSMmDrRidXBlhwmW9M/yF25pKJxozll8XYRFV3naaaJjgabiBmeWltQ5KlU4n
	 dqnB3zZZgSK5jXLooPwqv5t5ovJ4Em+lKQ2n3lQJaucJaYsVzo74JlgcgBbH86bHgB
	 0MidtBYGMNMDITSh0GhFH6xUCs+aKDllisLXlyelzfW76HVNTln7h8X9MMKkJGiQHg
	 RdbysmIcQlqDw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:18 +0100
Subject: [PATCH RFC 04/11] netfilter: xt_recent: let procfs own the
 seq_file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-net-v1-4-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
In-Reply-To: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TskCtPEUarxCx4EqZA92+8BIMcoYThcQZwAI90/Y1gc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG78b6LTCzn9/5cEdq8IeS3ee1vyt0J0uonutwlHf
 mXckYq90FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRHwsYGRryxfz51WWu+Ex4
 dvLygrAe7uvesdzsTw4nh8VUHdhTcoKR4UfM5V4bl2lCh997aOft/3BEUfL2u5mz19wX1cw4cIM
 vnw0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: BE9741C0006
X-Rspam-User: 
X-Stat-Signature: e37mat5p7emcizw8eydb9mbw38x9fwzc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793633530-410928
X-HE-Meta: U2FsdGVkX19s3zSI4YN6llxfY5b9ri3wYXy66rujUixszeJ+W9Ui2qqk54cXSZdFOHtl+QDsNhPODs6gZrUtvHXhUu5+sZYxCPes/dSm1QaHqHxHFi8+nLY6XZPCJSVtUXo5v//7mkF1MoKLbvTemD841LEnTsTzr8tz5wmR18uc2uumcbhryNm5V0+K556YoGYPz1+7OJRBTqf9I2FmOyKpafU/UHMcV86knxN2HG3cXqkhW+Jk0jsbDXmiAnfQ3YsLuDMC9HhV3k2sfXZUG1kGlwslyCpPDv4jN9gPLdw+fzIlqmmsMpua/5r0PI3LNUOh+PeXJD3BC101lBWGtrWJ5m/CVOqkAi/19X/NF1a1ZULN9rITmfW7BRg3lr9RAquXgqL4jGpSISFK/Z4PQFYbbhhS/GlEdYzPRAJ3UDhvbYN0DhOL6IxeNEzsuiKE2qHuodrqlmLJn7JroXxmlnGAsXYe60xJdUegjhcnA3HRXHbsdn/E+5UBElZ+2CicOF8ZT2CAJH3FmQGjIFim0d5zm7+Gza2HscnKG5fpg5s84Jv4xwOkuQqhjOOkNQgPigsRphzQmbeEQFu4jZ+25NXS84W/p7VuoYXOb+bBf/cPFn97cJFAD68q7Bbmxle6VFQfOJaaBMCBR9xvaYYs6DDlIVB8JP5uyh/p2BS5UE9SB/lofj0u1qbQO1mvcqhSz9fiWUT4oA2UygzHQCEtwQjHeQJ2wW12q+yI+z+J5niaPEWbpobIBtnnw1mwLfnWpeu5at3GWdzClraD5fGx42gQloJSD/nN2h9U9Z+d1zqzj/5m76EvMx4lc7/bBnhqph8ZqQs9RO3sHVYACqkpEF4nAeo7HNo83dHzcFhVa/aaXxpg7NqRudAngyGUXDOM85lYZvefKqKSe4zmyRLMHl41363JHlOja1qHWMcAXwQXbWZEFHTCbX+ogMqilm0QQRWpfCZGnLmwxzEJIw4
 JiomOAmh
 /IBcj3yu9fi6skd3iD1eCYdggq5TnlIAjfY6B8PAC7W5Ym9lrgrFOiP8VlM1qJk2dTTNGUMO0TzvdTik7BVYrL3wzVxonQaW721d9909HMdLakf7olBz6WxFh6q1NYTVLKI0vvPwRtyL6DbjOUeDVLdx3up11wlON8ITCA3rMJYaSxN7N5s8h5JVkA5r1Xp3W3RgojifBVkE9XAZh+lksY4OzFPeOOa7AvDoHMQq8p/3iKnek6gfef5g+X10hM7ZwliAUR2wzpz9uUnAPkiewZiy00otu6X2/YxVsKEvjDFKdXS8RTmYCLiP7roaRP4xtZSZlFUzrQM4BmSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator state and let
procfs open and free the seq_file. ->proc_open() only fills in the table
now. Reading /proc/net/xt_recent/<table> then no longer holds up the
removal of the table.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/netfilter/xt_recent.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 11acb9a50d4b..b771cc463aab 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -546,11 +546,7 @@ static const struct seq_operations recent_seq_ops = {
 
 static int recent_seq_open(struct inode *inode, struct file *file)
 {
-	struct recent_iter_state *st;
-
-	st = __seq_open_private(file, &recent_seq_ops, sizeof(*st));
-	if (st == NULL)
-		return -ENOMEM;
+	struct recent_iter_state *st = ((struct seq_file *)file->private_data)->private;
 
 	st->table    = pde_data(inode);
 	return 0;
@@ -626,11 +622,10 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 }
 
 static const struct proc_ops recent_mt_proc_ops = {
+	.proc_seq_ops	= &recent_seq_ops,
+	.proc_state_size = sizeof(struct recent_iter_state),
 	.proc_open	= recent_seq_open,
-	.proc_read	= seq_read,
 	.proc_write	= recent_mt_proc_write,
-	.proc_release	= seq_release_private,
-	.proc_lseek	= seq_lseek,
 };
 
 static int __net_init recent_proc_net_init(struct net *net)

-- 
2.53.0


