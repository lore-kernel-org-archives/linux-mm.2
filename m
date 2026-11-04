Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B8B6082BCD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wy0boZ5z
Received: by kanga.kvack.org (Postfix)
	id 1CD776B05CA; Wed,  4 Nov 2026 14:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CC06B05EE; Wed,  4 Nov 2026 14:40:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E0D6B05EF; Wed,  4 Nov 2026 14:40:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFA146B05CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:40:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4710AA859D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:50 +0000 (UTC)
X-FDA: 85398454260.17.FC0D37D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 93FDA40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:40:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wy0boZ5z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljglEsXifce2qfRBf9KQz9o848Hwgwzekl8g5JPLaig=;
	b=7EJ+X0pNnA17r7uuD+u3fQkV8KC8ENYabBM4n2+FAdgHNIWK8PDGeIx5JZzogdAHwLzUlJ
	09AwvwpGXcmZq7o+Zjeg+1FUgnSLIMgPojo8yTDOrG9EJtNj6rZ5n2GD6onnVyIDJ4OpuI
	zNNwjkvJFiDyoeU326KFjcNlTbuSMr4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wy0boZ5z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821248;
	b=bsT5Axg1ooGk68rabYeljeVoZuwoFbBvdta7x9QFgSl4we02hs4S+OtotlHmA+ODUcLy3p
	pR6sInNCaN1kAtdTYqEmUxf65hBn4FB3lwUNLVGp6MEFj/01aSPDlr2ebxrGj5+m+PRh+M
	t49oFhmW+axqIbAintjuBlpYDFZ+msY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C73F60AA3;
	Wed,  4 Nov 2026 19:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC2E1F0093A;
	Wed,  4 Nov 2026 19:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821247;
	bh=ljglEsXifce2qfRBf9KQz9o848Hwgwzekl8g5JPLaig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wy0boZ5zanG430YNSID9PvLo8Hz+/29VvJoJ9WySCgaVz1GS+M9Ng0mKTlmCR6Sp3
	 Wy6SgMb3/VqyekYQ/1cR/jjtPSaurM/Udr3bvNEYMuoz7g7KxSi3hffidsqtPL6rT+
	 kNwUs9q+tNP6NBKx59NYF9AsYxVfTGuDi6XKbhHh4hcUsnEviZrGiHrP56E4+mGRvY
	 JVVBJqh6UNVAz2b97ZBb5pcE8f/kvEg6BQoxsArkq6nlESYRlG+raNwuWLjBL5Fegx
	 ogU0jkHe5zezEzx7v8f9ltgbWRNKY/tsEAVwKI2tVEh2fNgrnaN9ng+jA/EICHiT9S
	 CNdt1XlVegAtA==
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
Subject: [PATCH RESEND v2 20/23] platform/x86: thinkpad_acpi: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:40:33 +0100
Message-ID: <20261104-work-procfs-arch-v2-20-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1670; i=brauner@kernel.org; h=from:subject:message-id; bh=B1JM/SyKlO95qrS7p0kfKzr/VxkM25eIJbDMnht8OJo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mSx1F3VulFfxXnpV5EtBz+raF7cItzSzr37e8o/J X1NniM3O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZydikjw5J2aZXovIq/n3/0 ZQtu+2Fn9/PUc5+zb7fMOXwlwMPtzzxGhsertpXcs3gT5Xh92pP36mKWQvHOiqu49M5OudX+dnL TCTYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 93FDA40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: recbcc578ktta75brq7ja19iuwp9o5o7
X-HE-Tag: 1793821248-608336
X-HE-Meta: U2FsdGVkX18pEr5u8iZ51lBuMzQVprRpz+OXlU/3Le78s7dALFGV84mlKmbYTZ0FE8J4j8ozV165Pw6HTplUK/Y0hhbQXKnl4QRLtN/r5i2SFaWEHht2PFVQsxDMm+BiFCDwGVyKJMOkm4/+ah0VIkXNW/RhhxpLVnDGGfdijSc+5yD5Af/bkESui2g8QRumKVMvYZ/efzdQOez/aHFGwtaiH6l+zB1RdPNnNLLPW3gIOMFLzpGNRrMO46uaGna+Q/qysT5P82NiNfrCV/ouFppTUkx7nbtQx/0MdVkjxTl6uxj4sL4waxMzZ0kz1UmO0sO8NKRxHjA5Vl7pd0tubGtKKjq1fZ6yTpT9cRDqmLm1N7wpOxqyaViEbkgL8LRvMqdgDjO9JG/Z2qjShwQblLHkTjeKXdRRZsGh5zUdllChCIKGBmQ48yBB507mbJMkabYeQGyd/8Vc37OGDqb+2fmYiUpQeAGPhtn1/R3f6MZ/ShJhqMLIHZ6aiuz4fEHevl/ocef4dWzsTGI8vTnd81eWuPz40k4tMcoDE4hFQ9Tv7JdT9KzxQiAs1OMKLQw8mZ2ZYfbgk9M6GbQurkpK3FCWGVhAUV/q0ClGPsbVF5hQ/5OTu73wFRfEO+p/LVq5sLp9LftsZwefN3fmznXLYTRG0vy1AZ8xYDq7C9HTflSGlhlaAYHyMiPUnbYxbfgruLdudxkVBlS/nJbS1KgIMaA1vqi78ajXIKQ1pGuq29gMh8yfT8hgPHTkYTQPfl8+yHNqZ8dHtR6XVd7zPBuHOCOnoEnRilmWqJiy5uweSakhIIKJiPXdKNabdtfKXZ76feWJuSdBVCEimPsrTHvnvURad+M73plHDzovtdvvdS/JveuIP1Z3+WAfnK5DQ02R4aNs/3nL9YscbzTPSJmkWpj6QJzYeUgDX4xjW1wgFb8wOmAZ2b2YdImt2+f62ttbY1Vo9mnBnszLbdBgvO/
 fC1nmNsL
 IE8dQPBiJ25OeJPaxx38R3a/gXoa23anTztnpQYVFn0MCMF/hsjoKmLZ17rAi65RFUceF2Q5aUGnX7yGN+O/7m4WN3tMHBxFX6VpJ9QyrDhHe7VnS7sE0t7V9OS/9RXXNMFSJ06H9rFrkff8RwSfk5UPVWa/5+d1OGBO+bs3ZDW/XQF+O5NH7FupwsnUQ+TpQfX4OJ8R5QOSrwsaOeK2dwsexdaobyS3MlFRDa9PAVdyANfTdLT1ZsKHiEkdyThcrxagflHgBeVp7AOM+PvsEgUx9e4ENLwjAaMfTy9xpvIJaetx3GfbHzK3cU88ybkwcBhV2YpY6yErXcS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/acpi/ibm/* before it pins the entry, and hand that copy to
->write(). procfs already rejects writes larger than PAGE_SIZE - 1
bytes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/platform/x86/lenovo/thinkpad_acpi.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/lenovo/thinkpad_acpi.c b/drivers/platform/x86/lenovo/thinkpad_acpi.c
index 2ee208c82801..8287b36bd90d 100644
--- a/drivers/platform/x86/lenovo/thinkpad_acpi.c
+++ b/drivers/platform/x86/lenovo/thinkpad_acpi.c
@@ -882,7 +882,7 @@ static int dispatch_proc_show(struct seq_file *m, void *v)
 }
 
 static ssize_t dispatch_proc_write(struct file *file,
-			const char __user *userbuf,
+			char *buf,
 			size_t count, loff_t *pos)
 {
 	struct ibm_struct *ibm = pde_data(file_inode(file));
@@ -890,14 +890,8 @@ static ssize_t dispatch_proc_write(struct file *file,
 
 	if (!ibm || !ibm->write)
 		return -EINVAL;
-	if (count > PAGE_SIZE - 1)
-		return -EINVAL;
-
-	char *kernbuf __free(kfree) = memdup_user_nul(userbuf, count);
-	if (IS_ERR(kernbuf))
-		return PTR_ERR(kernbuf);
 
-	ret = ibm->write(kernbuf);
+	ret = ibm->write(buf);
 	if (ret)
 		return ret;
 
@@ -906,7 +900,7 @@ static ssize_t dispatch_proc_write(struct file *file,
 
 static const struct proc_ops dispatch_proc_ops = {
 	.proc_show	= dispatch_proc_show,
-	.proc_write	= dispatch_proc_write,
+	.proc_write_buf	= dispatch_proc_write,
 };
 
 /****************************************************************************

-- 
2.53.0


