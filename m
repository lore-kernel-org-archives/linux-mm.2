Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F246072829
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4qjG/En
Received: by kanga.kvack.org (Postfix)
	id 3533B6B05C9; Wed,  4 Nov 2026 14:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32B766B05F1; Wed,  4 Nov 2026 14:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21ACD6B05F2; Wed,  4 Nov 2026 14:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03C966B05C9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:41:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C98DA7F4D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:41:35 +0000 (UTC)
X-FDA: 85398456150.28.763A12F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8088DC000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:41:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a4qjG/En";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnuUeY+9+QMi3OegoRzUMDksdZE42uDQ+p1ThOeCsVw=;
	b=ZT1t4emyCVznMjbGt3qHdDlsPGhsEHyaEy8PLkejzLhvM2TjkuFBzIaMld8/b1QUdd3r06
	Wb7gXIXZMxJ9E1W5Pdf5sBIFHEZC0v6oVLNQ4IYJzHcdQtuAVsYvKJoSdJrkKk5VUVwjey
	h7Nq8HXYBnAdzZDPeuehF7EBaBxU9Vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821293;
	b=iu5lO9jGUv53EEqMERzj/zJ6BpWKeh04QcOh4hjPWSimEFzWnBGzF0D1iuADKyoBdJiGPa
	AMUWEYIWpj4/qUQgBgqkh3/qtWo4HQLvnCgKiMpNkSmHrmrUjxJevWsm1QbeAgqUVmZ21I
	NfAgTz5m3JgfquftYToPiHGDMjWGdyg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a4qjG/En";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C03F609F9;
	Wed,  4 Nov 2026 19:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876321F000C1;
	Wed,  4 Nov 2026 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821292;
	bh=QnuUeY+9+QMi3OegoRzUMDksdZE42uDQ+p1ThOeCsVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4qjG/Enl784wKvVxl/9ldVwuuHEc87Y0LUedobA/KdwuI3SCxAckwhwEAtDdOOqU
	 UqZPPnd0i1wsEQPINzLmBf7fes9X1w97pMqml0mB5btMrfd8uToyQFpFM0Tl2wlAjD
	 kgF4RA3JR3lH8viB9FAeGA4ZqAZXhhvVqKaCxsHsidrZt3ppkwceT62jwKoGEsMlOx
	 78OYFlBnZIcEweu6rx9OyaYzVUpLMbaYn5Kxkk/UsZEPHpo8JcSdi7maG+VD8tqYHf
	 NonEOsq87sjklv+/uShbdJtRlOOZ5V+hHfFMq2FNCALvQq2gchvAnrCclCithYaHdM
	 zs/aDQjJX2z7g==
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
Subject: [PATCH RESEND v2 23/23] PNP: isapnp: let procfs copy out reads
Date: Wed,  4 Nov 2026 20:41:18 +0100
Message-ID: <20261104-work-procfs-arch-v2-23-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810; i=brauner@kernel.org; h=from:subject:message-id; bh=O9tLcZSRMcgAQbB8Pp6p1hVEIxcx9tANJYkp4CgYVW0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97uRoSC+OPd30eNcyzvc/yy/YbGGdvPLwp7wL4ZnJy 2++kTT52VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRoLeMDKvtZufJ1LDZnWzr aM1t2LBM8N+nLa95p/c8m1iiUHw97gDDP8vnB0xly+JWrdKTyXnq2i/YvW3iPe61nAKrrcqOL/1 xhQUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 98rcumdm95dd847skys1rk7fg69kybgn
X-Rspamd-Queue-Id: 8088DC000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821293-699789
X-HE-Meta: U2FsdGVkX19LDJPPt+A1PF8aU2evo97iTYRKDApfxP6sClysH7KSJa4jYylvyZPmOpFJHQjKiaVdyHXIXylQi/VKbuLlRO3yhPYJNrKUbliiaxqqa11pKodDlPMfREju+5s9DmXP8l+vZCIFv0BaYxvgt7rUI6RGFeIMI4syEusKZ4uvQDttf4JGgGeKo87KlDtbfj77t4vBwY+1R1cBLBXqycaKg4wAlcpiPH/PxPL7GMkdCvL79C+7vIj5Wsvs7lKyAGrucUs6KzgHxobI95f6ZY07jKcAFQnixPEN9Psvx6zACeY8/4Qq1w0/JzLERNchQQaEA+sQHyfWQ7OVp43454nM3u1TG0nCL18px+1AxWFDc/MsPs2CADPytAMrH6k+mHtuZ3Iwn2i+HH4LOZZAX5/1f2TmkrgHxbQp1/FefPD79RwZs+uxM6UkoK0Wz95XigGHo8BKrSwu6KBddLs+ItW94sTAVBgS3zrMfP0rm935W4hsuOwA2VFfiJqpDoaDB0voDsuxcsnJWBGesFCCfu5mTaa0iAwG5z+EoH0MxVAQM+n4IBg1svhyxFwkAHBvHAYCfJJKfDu2LKNMnm1SHpkNWe4TVXcteSCh7wqU3OiC2TcGVXwuVlSTxxHw8G+xoAOVLZJ+etm2tat/9pwVZcEylzhqzXI+faU2k+REdx1vmiJTvMjW/5VhgeihkNw6N0ZUcldXhytqMfS2v6jZj9a9fNuUTlvgR+Yn8wGSzUjtNDMwaWPZZI3CQbw1vSaM16OYQk+H7j6D1N7wBAuK0hLUuuXZfUgNwR7EPpii6ZMhykDcGDVaV21eZJm7Suc2wWtqJornaww7EJ0MQhPk8gc8vB86yMPN1+vaxgzKsF8qBVLil3UP8C4pPkzdVBCk+Lih3cl2UxbRJXsaIpAtE8/FL/0fxLxJKB96BMemZc6SGA9Wxwt++09qIgWLXhYu5UuaZQV2nwWWAAh
 2Xn2jYoc
 MfqzIXmslMC/pWwwmjnwO39yH6CkoRU+mUDWblWGh4DzU++AO6DTFmFy25joij4fxlpyQM36qsLRpzhDd/RhuLcg9BrDM3hGhy/07E9cO/d1cvAHbYPtPzOBSVpgO6wntlR4M9AQeZowuDtkojenL5AMLKNm+zkXl8ThRR2olGFeJ9nGAtHOlwkZ1wD+B/nl0BIXBjZ96u61V6EM+emvdkYoP+a0iI+pMO8VWwXD8NI60/Ivdcm4L/hg3+PnDYPosv1awIos62JMGZ8oFYWANcJ93Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_read_buf() so procfs copies what is read from
/proc/bus/isapnp/<card>/<dev> to userspace after it unpinned the entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/pnp/isapnp/proc.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index 1829c20d5446..2634db5f41e2 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -19,40 +19,34 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
 	return fixed_size_llseek(file, off, whence, 256);
 }
 
-static ssize_t isapnp_proc_bus_read(struct file *file, char __user * buf,
+static ssize_t isapnp_proc_bus_read(struct file *file, char *buf,
 				    size_t nbytes, loff_t * ppos)
 {
 	struct pnp_dev *dev = pde_data(file_inode(file));
 	loff_t pos = *ppos;
-	int cnt, size = 256;
+	int size = 256;
+	size_t cnt;
 	int ret;
 
 	if (pos >= size)
 		return 0;
 	if (nbytes > size - pos)
 		nbytes = size - pos;
-	cnt = nbytes;
-
-	if (!access_ok(buf, cnt))
-		return -EINVAL;
 
 	ret = isapnp_cfg_begin(dev->card->number, dev->number);
 	if (ret)
 		return ret;
-	for (; pos < 256 && cnt > 0; pos++, buf++, cnt--) {
-		unsigned char val;
-		val = isapnp_read_byte(pos);
-		put_user(val, buf);
-	}
+	for (cnt = 0; cnt < nbytes; cnt++)
+		buf[cnt] = isapnp_read_byte(pos + cnt);
 	isapnp_cfg_end();
 
-	*ppos = pos;
+	*ppos = pos + nbytes;
 	return nbytes;
 }
 
 static const struct proc_ops isapnp_proc_bus_proc_ops = {
 	.proc_lseek	= isapnp_proc_bus_lseek,
-	.proc_read	= isapnp_proc_bus_read,
+	.proc_read_buf	= isapnp_proc_bus_read,
 };
 
 static int isapnp_proc_attach_device(struct pnp_dev *dev)

-- 
2.53.0


