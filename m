Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D033606B91B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FLfR5DFe
Received: by kanga.kvack.org (Postfix)
	id 4CAA96B05BC; Mon,  2 Nov 2026 09:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1A56B05BD; Mon,  2 Nov 2026 09:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B78A6B05BE; Mon,  2 Nov 2026 09:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 122EE6B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:23:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90AEC80125
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:17 +0000 (UTC)
X-FDA: 85390396434.01.C0667FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 80EA88000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FLfR5DFe;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629392;
	b=cCr3EquCciqaxvYCO0cfSEvtMMhZAH8TlflB4eTQu7KxEk/tyH+zgCybycuV6xhKh7zXiD
	C6rwQFqjuCwMSblq4jXS/FaGlK6+KFj3+gwNiARz9rci+7QgPQNSeAhr4ksAyGc+qeiYrz
	fL/K9zifwMjeZPb6U+oWZaZt1wD4A2Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FLfR5DFe;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVs7ALsfOLkn53l0kYUUme/SDUyhPHOVCY6QDFUmXzg=;
	b=raIEeV0lIS89a5m2jCHTw9ef5Nf470LEXnV3T0SbqaKzqxolNvxnhr+h9ddiW7pY+XiLxH
	4dLtzbZ8DhePYrBg0eaQ9lF8V02OYrhQpioh6DBMqQ4ISfKk/3Zr3YfzBDE/JxQG6Zjrve
	2KCTPwKjKtwgbKJ25pDT5XbaCZFGL8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 192116060C;
	Mon,  2 Nov 2026 14:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CDA1F00A16;
	Mon,  2 Nov 2026 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629391;
	bh=MVs7ALsfOLkn53l0kYUUme/SDUyhPHOVCY6QDFUmXzg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FLfR5DFeQsSly/cabaQC7e9iY2bQ9zaa9/+MREBD4BU88eN1Xx3KqTRtm3qYQYpfl
	 kCDavrMTvPYKs/rYn9gptjjElebcf4yPuRmKH7HVcqjqazHfqUR/Htiq7M6QYbzt4U
	 zWa4rzDSZK1q8pK7OQVMGrLrU+xIoyILoyQv+YpF94q5kGFQx5QO63A+aw0aYwigp7
	 8QwH/5quUO5K2fuIJpTTFlJf5GF8Ltsg0OQYaZW1HbdncmCkutEph8u81EsuVQiORQ
	 PSv2MLOMncLKFj4vxCZCl4sIAOggQ39Y2OGr1AHxp6406Vqv9fSst95zy3PsIJt0ea
	 Hqf1VPSexzNvw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:21 +0100
Subject: [PATCH RFC 06/38] xtensa: simdisk: don't read the file name
 without the lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-6-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1811; i=brauner@kernel.org;
 h=from:subject:message-id; bh=VTDmn8Fj5UlymIH+0OFfDD9d3Id2xocQBgXcavnnib4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJP1/VRcytoDLK0ufy3WLzr3+sXFE+dzGyTVYqofd
 O+7u3tWckcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEUkQZ/rs27hJY5+amu8Rq
 WoJCkbXlpumL4jqiOpe4HNF66TkndBkjwwvt4L3fvCaeXKnVx7hb7eIq/dqmQN78dydXJQe4lqT
 uZgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 80EA88000D
X-Stat-Signature: w18b6w5b8hrqknxu654nom4stpb6qebi
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629392-633632
X-HE-Meta: U2FsdGVkX19gceMTAtfq0tT62YNGfM0DexuJ1T6bD/ADaflpN3QOdKZAxiL1ND+JBR32anzRSHajqjeQeGnboxKUed3lNrh+O3EG9Qu/OvkR/VhgOCNTpmwDjtimmF9HWZVeZ2lJZeRsuFhgxY4Kwwe4CJVqeTAWqarLn4MJaN5OuPNsSRFqxmiNNyJk3tKXSr71o6gZMbfxVVoqC1mYO4p4opAOSiq2F1CVCkL1fIQPxvP7ebKDMD+1uiBPxsQiLoxEOrJ73o+lIl0KwPhMTRSdYF0UvOMvrfuz7Dn4UV9cIxdf7LSFkaKFnsTst6ZMib8WGakZT0o/y74tG+BDwqovRb88VUwXbL5MoQasC1zKgGsoMv4sx+8IZu5ygF3b2eyaMs8xjE0GsaJyf/GoclbStkfPug2GgGwkgmLh5IFv77mmgoTEYI2goaMkOWIUEnahDYQEAKftzCTp3mkSDhb1wJSEaRaZdhQDIoJbXHJcphDhlK99jKgrA9dujkcmdTn2cEM9JoRCZA47blcxrW4ruv4TJoeVevbRtP22vkqE32sjO2aOl3XVriRJLE6pNTsIVqjBRqZKQGX08pI4K5Oc/rJQQ5SaAyJFXs/l4C7d1WO+WoEjHuQjCM9qSpJREexLsmMY7Ug/0Slblij2bpw2nfEF7wY7lCxV01FRSdLnbdN2DD+DknSlkfVAIjMblDWxOKrNk6NrlT6Rdd2swccu63i1AYb/8u8HP0e+N9gZ31TT/hocGpIu8GxltjGNQccK48Fjg9qfVX90kCms819Gk6uOwEF7ufojbs+UcqaFE3wT4SZq3kShvhBoUujHOgNg3fQ7kWfGQJNID9UyzAVt6OqMEMVRGdnFp4mgsZmHDTpgvkZdEpPkw1py/EI2Ooay+/8ZI5y7/DdTlYPtL1zucQuO/kVARotRTgSxMhoGD80h+t/pexHRdX43EmYb3eNe/xYYfJgcYbbZwHt
 zaMY2QB7
 uCRmM8mIh9KtgCy7OaedF/QdXSiCMrxwa/Fby+MHM1H+c45lbFVqc8p5uDoJ4C9WS9MdnRu71h/ibJTnRd8Nrrn+OiIBegN3nE6xN9fTevBuT3b2pMAY6s8WnsFkoksmi3/BXKriYYKM0fk33jSVAmSJG3acB1AHMlr9uTo6RgXT80HuZx4zRhPMyNkqEAE75LNVp53hp4SmelvLUn8SDC676TCmElmgXaIaSGiULdwhVvaR0ng84yhWjbs2ZRzeAZufu2OywjcFbocF+B5x35HFA6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_read_simdisk() looks at dev->filename without holding dev->lock. A
write to the same file detaches the disk and frees the name under the
lock, so a concurrent reader can copy out freed memory. Copy the name
with the lock held.

Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/xtensa/platforms/iss/simdisk.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index a2ddb49c269d..7b115e023de9 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -238,22 +238,21 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 			size_t size, loff_t *ppos)
 {
 	struct simdisk *dev = pde_data(file_inode(file));
-	const char *s = dev->filename;
-	if (s) {
-		ssize_t len = strlen(s);
-		char *temp = kmalloc(len + 2, GFP_KERNEL);
+	ssize_t len;
+	char *temp;
 
-		if (!temp)
-			return -ENOMEM;
+	/* a write sets at most a page, see proc_write_simdisk() */
+	temp = kmalloc(PAGE_SIZE + 2, GFP_KERNEL);
+	if (!temp)
+		return -ENOMEM;
 
-		len = scnprintf(temp, len + 2, "%s\n", s);
-		len = simple_read_from_buffer(buf, size, ppos,
-					      temp, len);
+	spin_lock(&dev->lock);
+	len = scnprintf(temp, PAGE_SIZE + 2, "%s\n", dev->filename ?: "");
+	spin_unlock(&dev->lock);
 
-		kfree(temp);
-		return len;
-	}
-	return simple_read_from_buffer(buf, size, ppos, "\n", 1);
+	len = simple_read_from_buffer(buf, size, ppos, temp, len);
+	kfree(temp);
+	return len;
 }
 
 static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,

-- 
2.53.0


