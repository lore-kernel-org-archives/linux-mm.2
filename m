Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB496098F5A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrdQsd6G
Received: by kanga.kvack.org (Postfix)
	id C475A6B05C3; Wed,  4 Nov 2026 14:55:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EE46B05C4; Wed,  4 Nov 2026 14:55:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35536B05C5; Wed,  4 Nov 2026 14:55:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 854FA6B05C3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:55:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9EB8A084C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:55:06 +0000 (UTC)
X-FDA: 85398490212.28.C9D78F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 052EBA0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:55:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrdQsd6G;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1VqjUGL5+J0t5hj5seZeRe1Maiv3S9hp7Jj5OG0/0s=;
	b=gmZH2t7kCKYAnLMrDYMIKdWuE0aKlHB7y++wGjfVDATSMbhNyDOqtStxyGgih96MQ/l76n
	SJctOK6e6hUueo74SsySwfuQJMIAg8DmPCdliHYlIGUkxQWyr52qJe9K7t2zM+n3NHEHOZ
	V8LSXda4o7aedgiQHuF9IoyDNGKv+m4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822105;
	b=PNUMWYdLhsu0aaKjNzBE4JUQXHAGJP2npOY+K9zNJc5W92/NJn9bPT4c6daC0ydUhAjUwg
	fu/xfUqCnAdAfWc2xb9DGP9Z7N+XH/VufakNK8ZcfyzS98NYRGthAcOACidjdrw+IsouIj
	n/UCzwN1L0k5bqQEbU4ULJe6elCW4JA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrdQsd6G;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 304D741B29;
	Wed,  4 Nov 2026 19:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDF51F00A16;
	Wed,  4 Nov 2026 19:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822104;
	bh=R1VqjUGL5+J0t5hj5seZeRe1Maiv3S9hp7Jj5OG0/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrdQsd6GTay34FYuGXCa8EK220wd8dcVKmmCUL2H6AN8qybgYu3VWX8QWdUPAcmTQ
	 k7Hh4kIxo+HBWYfqIhyCM4t5TutFpDBfRkmXCuGDnrCDs2kRigWisxosjbx2JTilsl
	 pRLqKsHm9QtEr1md47IXW0nBzRwFYpbJ+AsEXB9Aw5/BASW5ehNYPMEN3WtGHRfiwA
	 OzbZlgAyMFwrKZD+fvajfs9VLVkX7k/jZfqjP/IWM7eHh8GU1TOBliTxs7YYEjoU7C
	 tTvFESzDRyM4Rii2YLzF38phnQomDRBM6gq5STKW4qtXTlnb0Rqa4901faLCQGhySy
	 mMgweD+fFjsdQ==
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
Subject: [PATCH RESEND v2 21/30] kallsyms: let procfs own the seq_file of /proc/kallsyms
Date: Wed,  4 Nov 2026 20:54:49 +0100
Message-ID: <20261104-work-procfs-fs-v2-21-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1331; i=brauner@kernel.org; h=from:subject:message-id; bh=X1hXUo+P6dAEkQI4HVxBka/iuP3neD063cymPGxvXEU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97nH59Orc+7n3eLifScgo8Jj8qyzNWnT19Mol2qc4a 58vWjHboqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiPWcZ/nCKtL2fd32F2F95 vx9SGZf0t36r5ma6o/N8y3elH9e2NU1l+F8fo55wKcT3fXtS7NoKxUWhugwWHOV/0+b/kah+n3N uBjcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 052EBA0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 8y4h4w5abksq5z35uorgd6m4jtqgo3yc
X-Rspam-User: 
X-HE-Tag: 1793822104-889302
X-HE-Meta: U2FsdGVkX18z+AXhM+YhpnbT0k5rIM7G9hC/bTetoUkiU5CC6BjoPNf8ohLV3iHuSzuw3HkP2hyt/RnvdZeer/jBTOzOS/Bm9TldbuXKdKri+gcDh0q97zziiu6bW7huSVNoKt5h6qLBqzIqWwSDVW5QMSf2Itokkqw7qPUpx+izmBLH8Q54AyERD9bmYtzW9zjcQT9jB94iolyfMY6HMmadugto+0hRoNkG4Duf/sH0HuzaFhwlRmSEss9eJ5UU6eClA1zHEjQJL8y39nkgWPPzdtnWhBd836EQN4uc89ueOHIlb9FiGxcxIUp29X7sNaNmMRb4dvLStDGTZbCtuiJ2MSDXh3BxaePiCQyOUc5EHtL9EkSAW0HiohUlHM9Trt22+BLdYBsWIWB23SYQ4ceyC7yuovMpZziB2N3mUKi/jE73cnTGfBKfh3N9cfeasbyhu6EJTjKOrtC4DmERUVzyZu4qVEIRG+POKn8njrtiFXBPTuKTmedlztDJbYOLDC7ZBD0Fna+bEBBmu4Bad9M6OOWhGrz5/7Z/W/d8R9qp1S2M+Q8e0P6eStrajG4bqBjxtVXnHhx3gvZtni/pG0fEhdqIsDL9HPhb03O3qK053j43UIK0V4iuWq7DHgxMZY3fyzUGvxc1JGBYnWstf3Vg+R95Qgdtla+eOvDaujuNN/J1acd13QU9qDu3+9OEhrt1Gp4YfRWWMQRwaSTeDtGAJIGqeHnAXkvw+JWIHOcwJ0qQo3Lh351ua+5wq6MVUdCwRr1cbuD+YjqrCrvZsV/rbsmFpb+9gq4XS+srRr3pZIANqe9Tn8mzvVhZSlZn4OFkJE+0T7ig5XzD+Vceg2xtXNKarUTl+IpJtSEbpVFb/4z8foRL1iMuZrJyU0OKWb20fdirEuiMP21OnVHVyKwYKozxVhaZEDiXS8LfW+73KXdwdyZwHmSoXLDNPWqH+g8xq8yuLTdrKoKjF3f
 qqAlgbLb
 Ep1IkVDeqjCIEoZOhB5mn8XJswq01TnPbP88hLE3KkjUMhDDYqtCkYy7evmwqmxmBA4IYadNUw/J/ZncznwS/EsYeCF0ydThUMaACJrUatVbF2MGoc+ig1iMj5mFwsar9FywE2lx1u4ykSm6ChkIcDJHiuGSfRFBHMiH7REY4Tn+/oidzL7Xl5pmceV1A+Epu73kxsxvuWySse+BjYSVGbO2W+so7GN9EQgp8JMqxmYaInAk8edzaPBdQbV2YrC2PSRLuB6iwpzGCr4hg0LYmcVgqbz7YwdcouCkxuLQaG8loZ/iAyZwIBlKG6iPWdDkLmNn3c1O0ZLXDPZgG6hy+dIj3fzwdaVjOI4cuvi+I3biapdrQbnOoF+uHaC8HU3i2cBbammsuyqbQydZ+mp0W6Pc409jetH9iM2Oa9GPIqO8YaDIVyY7afvz0qMFCJ3rTj0/RYvhLPbiwh3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator and let procfs
open and free the seq_file. ->proc_open() only initializes the iterator
now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/kallsyms.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index aec2f06858af..2d309fcee730 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -888,10 +888,9 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 	 * s_start from where we left off, so we avoid doing
 	 * using get_symbol_offset for every symbol.
 	 */
-	struct kallsym_iter *iter;
-	iter = __seq_open_private(file, &kallsyms_op, sizeof(*iter));
-	if (!iter)
-		return -ENOMEM;
+	struct seq_file *m = file->private_data;
+	struct kallsym_iter *iter = m->private;
+
 	reset_iter(iter, 0);
 
 	/*
@@ -923,10 +922,9 @@ const char *kdb_walk_kallsyms(loff_t *pos)
 #endif	/* CONFIG_KGDB_KDB */
 
 static const struct proc_ops kallsyms_proc_ops = {
+	.proc_seq_ops	= &kallsyms_op,
+	.proc_state_size = sizeof(struct kallsym_iter),
 	.proc_open	= kallsyms_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release_private,
 };
 
 static int __init kallsyms_init(void)

-- 
2.53.0


