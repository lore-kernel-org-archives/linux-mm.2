Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67DF6606A849
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MRau239w
Received: by kanga.kvack.org (Postfix)
	id 6200D6B05C2; Wed,  4 Nov 2026 14:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6426B05E0; Wed,  4 Nov 2026 14:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEA76B05E1; Wed,  4 Nov 2026 14:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC176B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:47:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7765A0837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:25 +0000 (UTC)
X-FDA: 85398470850.09.D199897
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5AC1720005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:47:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRau239w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pUc3XnniVQ5ZOuyDhOysKqrOAZk7AW9/FnAFYC6PjCY=;
	b=IUszQMTUuBw/qANwNvTRKF6bwU6u4xoNJm50t8aLcI6G/K9NjGKqBMInD+c0HbySiWzn4T
	sO114l6qp+0bTce50lQj6Nd1eMSRZMDZCK4a7LValkk3w319kBHqpyywj0SO5S1WqNAnNg
	5mNT3kpXVsN0FZgd6OHuGAYlwvbZ3bQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821644;
	b=L9WLFPZJXgoskiEFjGRS96deewtcvEGDHKj+U0Ut4rXswkbZRwM1VNvey152lffLAJm4+Q
	n4t9aFI1cQxY2TTIfejxNE4+E4pcXaXwxEnjH6KXUqEtUCCRxW8knKnMgNHrr0BPc6AW9w
	uNnCNPRicrXXzFMfH0M+af4kX+1SoCM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRau239w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B492A60DB9;
	Wed,  4 Nov 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6491F000C1;
	Wed,  4 Nov 2026 19:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821643;
	bh=pUc3XnniVQ5ZOuyDhOysKqrOAZk7AW9/FnAFYC6PjCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRau239woFQtdlJcfyIuzdt/Mz7tXpQLHgX2J3HFCxtIoQ7p0t8aEvclvbqPlKOGa
	 EedaHfHccZGMzhB5vcIwAhuyyQDAPau+H/YAUhBdRbtxFhlJqgcxmK2czVG9y5wP7T
	 vy2fA02WDdK3VJ+RlZqpZVnSB9uMz9+ib+VE15vj7NVBBxUCWLKrh6ChnabmilIhZU
	 3Y5JjgpF66wHdUqRob6tq7eO9hwAVhqpVsM3MxH/8UpRQy6y5G6Z47XYSlSWJ2d5uP
	 6lZJVoMkctk/0jcZI5OX7z1nQPxzj8u8pGN0oIBxSIKKB6fvv2I5CNKbtMZ1A+Sjdx
	 r3Q7BlsL714Bw==
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
	Chuck Lever <cel@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH RESEND v2 20/26] tty: sysrq: let procfs copy in writes to /proc/sysrq-trigger
Date: Wed,  4 Nov 2026 20:47:08 +0100
Message-ID: <20261104-work-procfs-drivers-v2-20-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1564; i=brauner@kernel.org; h=from:subject:message-id; bh=xA04tAm65fsCtMg0xl0tBqqUoHOUL5b4F/HBKwEi4qU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97up5wHzVwMj/4s+/qsc0lZwe6RUvWPryURRj4B+1W WLHtl+Y3FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRvW8Z/srfZV/202bOs6pv bO3FhjJLqzofzqvaU2easvxKpvXzafoMf3jnJ8cnHTZnrf/9WuLLwePxp5qz7/ZoyYesNj+yaqb 8JzYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ixgn4cyc6b9sqzb7ak9rb3adirwym73
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5AC1720005
X-HE-Tag: 1793821645-399468
X-HE-Meta: U2FsdGVkX1+3GCa9RoiHQUsEyx3EdYgVbRor68E4nVPtWvEBc8/msrhuVygm+hyxYAbZlL/AnOrcuS1eXqBHhYeJVhyq6qLiHiRd7LCJ5EWXhmyMkNYEHLBWGLDkcpobGCTOZgyHWOjpKnGLoFiOODqYWv6quex0cwU8XqsOvWu3GmlIClplhhgu2+12f+2L+sadr866gP3MPCCiMQ1En/Sfovf4ssIBRBmOXvvmmhdWmj4fygOhFW0GushDgwuA+menqqK0DASzjU4GIERZFyNYT+zesUevS+R5GKX0Y+tNtITZzx4G26XJawTnS5aTraho9iK2KokQXuECIUlwtJRIH1uF5+jEV0CSBReAmGLtuYAPTir3FfoNw9EALWAbYCCBqZqIk5zZrVQ9A5UxCipGBPF94zuYvG/Lukzr3HYsKdAYlthiLcvAcGXCvFa/qBtupWoAorm/UhYEiESeo4SiMYG1H43G4AkDkuF1mN5WP+uiasiLWe3NB/YHAqYLiaB3wJAxI7O6epIXj+Pu4fnzw8E9u1NWdffMD9zHf27psxEVohiBN4QzhltG8RozK/Tap54QUQsdYvwM14ULGta2AlG8b3lWr4nxx7miCyilY10C6z7znAjLSx1Vep3jB33KANIJQdLIYuyF+xIRvEDGgHhrBLTQ9qIE2HLyFAfpXbWvixizbRtiSQvzsgnn7GKbrlaHRXw6YG/cOp6F5DgoU/8kx25id9aWqFEmSPzswrTv76RwM142giQ33GwzNUqJXPSLKBMq8/EaibGxbS5z0U9rTDtwfGru4QJjgwk8sNRbQpyWAzKUZqKATX+JWF56DMfLeSWnvlEiP+nlw1kQBF50z89v4YqE2d3wq+uWHvFt8nmJdJB6OZiv1Ny2Fmkc2wckEV+DKPkcyNtpmgWQezG5H0x0SnudYoYSDolks1vySglS5zATS04lpncrLWijXm+Ev/nsgIQXvmg
 jilauvAa
 I0jTyahO9z7moN1UIkKUp3zdmIEQGiC0Lue1egPCJ9dqlSOUC0KZCUnFutvwvVj7PaPeWUf0K8Ft6Hu3LjMH1gZIGK2GfxCdgBcwdPap3u46Ikmx26YTsc2MjUQEj8f0uysKjEZ6v+VhPObL77aN9ENR2kPP6cK06fS8aqgXV9zrwlbuXS5+S7++HVbuhy4BKhVLqEYVzMFaYCq3zIfsyBLimApjAKpie1g0dfIGmPZx7bFF7Op6fPLEkXnkmOLJbW4JkgykYBpfff2rkoTvFe9L/lac7XQ2i3Ke0HrFO0aSkvYJIalJI1IDNbqacBL8KmdaqePVCTakkcRHWBmsrY6O6eZJgpCh+xvMFlM+8D3nDZaiPRY+Q7h9yFLH4fHlUKZKVilchoE6vZWsLQXdHRg/nSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and handle the keys from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now. They used to trigger the
first key, or all of them in bulk mode. procfs allocates the copy, which
is as small as the write, opening the file allocated as much already.

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/tty/sysrq.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index f4571d05b496..99363e1b59ed 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -1200,17 +1200,14 @@ EXPORT_SYMBOL(unregister_sysrq_key);
  * However, if the first character is an underscore,
  * all characters are processed.
  */
-static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
+static ssize_t write_sysrq_trigger(struct file *file, char *buf,
 				   size_t count, loff_t *ppos)
 {
 	bool bulk = false;
 	size_t i;
 
 	for (i = 0; i < count; i++) {
-		char c;
-
-		if (get_user(c, buf + i))
-			return -EFAULT;
+		char c = buf[i];
 
 		if (c == '_')
 			bulk = true;
@@ -1225,7 +1222,7 @@ static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
 }
 
 static const struct proc_ops sysrq_trigger_proc_ops = {
-	.proc_write	= write_sysrq_trigger,
+	.proc_write_buf	= write_sysrq_trigger,
 	.proc_lseek	= noop_llseek,
 };
 

-- 
2.53.0


