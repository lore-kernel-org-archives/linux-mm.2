Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496F26082089
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaJvHiAM
Received: by kanga.kvack.org (Postfix)
	id 54B336B05D4; Wed,  4 Nov 2026 14:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4ED6B05D9; Wed,  4 Nov 2026 14:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CE26B05E3; Wed,  4 Nov 2026 14:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E46F6B05D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:39:22 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DD6580869
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:21 +0000 (UTC)
X-FDA: 85398450522.15.83A53C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D9AAE100009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:39:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaJvHiAM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08oqN1TE6XF/zda2aaIy/jJ7rzXSJoF5jY3Jq8EQn3I=;
	b=AzweC2/2S2NseV0xCsZCiqKpv3BxsjGxMqXGC8jxgVJ6UJxtK2u3/awUMlnd2PRDgTThSG
	fwahphYBU1dAr9xllZgTVtFT6vQXzqgEQ98OOxVJdGkZ0ooDArkhvA7hT8tkW0t3SSYsO7
	IAKfz8BtAIBl17evE6CmUaPn7ju7KVQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821159;
	b=Z6D+2jVo9j3IWojX+3XqGzBNfpPLIQw/Bb85k1BAlhnFB8Cv1wTeafGd7DW9rc8qSbBa6F
	SYw2e1R3kOxC29m9WwyGepp6R84EGhSjI3txehXeF94JbR+K4nICxZSo7SyAMXtDHRdKRj
	urvT7rWwyg0XlNEOnM7t7w98bgk805A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EaJvHiAM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E5AE60DA8;
	Wed,  4 Nov 2026 19:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DC61F000C1;
	Wed,  4 Nov 2026 19:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821158;
	bh=08oqN1TE6XF/zda2aaIy/jJ7rzXSJoF5jY3Jq8EQn3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaJvHiAMOM44mJ4AYyNn4VsI9tCdPZkXSAVa50U3NrOibefU8zFHhtlwKggezxc6f
	 wnraA02g8NJXIrS3SZrOw/ckLDW5FYvi7jxpCw0K00BYbn5RYhILqubA1RmFr09QV/
	 k8Ctg/JVPDQToSJB15j4p4jKQY0itLX/D67pNlmoINjEoJlweC93iKdvLzgAObEB/x
	 Em9ifBMZxzKnjasz1lK0O58rkh4J6xzSeJOqNNv+26qOtx9ntPbRT5XujsHFDMwoNN
	 HTnCPQ1IABzvSMZrUrPP3tBDAg5ZtkrqubTQztGluNNIqQgLtUfcYWfLXYTWYVi5vn
	 yQ86hX5tNJ3+g==
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
Subject: [PATCH RESEND v2 14/23] x86/mtrr: let procfs copy in writes to /proc/mtrr
Date: Wed,  4 Nov 2026 20:39:04 +0100
Message-ID: <20261104-work-procfs-arch-v2-14-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1645; i=brauner@kernel.org; h=from:subject:message-id; bh=soK7T1bbUsg7MQd+qkvxTDp2+B/10GD8og0zR7/9Z5c=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vgbYnk5w1TAv+cR/19mB87Hxr1yYY5rHB54MaZe7 z00yU+vo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCKfFzEyTOHm/S1/MZHxwIv8 7dtPVu6S3Lllwdu7ZYHrrz/Q+cjbY83IsGb+7VvZO/dOnXhuMvvjlQVn3RZfi/jDsjPicIm1t/+ HZBYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pdqjrkainje9q87w3wam1f8heteed6d
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D9AAE100009
X-HE-Tag: 1793821159-605147
X-HE-Meta: U2FsdGVkX1+/304ftMX+9f9g0eLVk160nds3+gqArOtbSaZyt/ZgfH3eTOYyq1VAjnXEdS6WzwBoIJjt20WEbZ3O4NNIFcCvkxBbZ/G+xvTnsyi8nUXh2GP29y0ND9tlwr+I2b71iVEilhYAoKN1IOHhI0lyg2hbAxK3jp/GHdGbcgcr3Pfjz8qL7bXlKcoVDh9z3jmfvzFwyMOs3RJFjQu8yKg3Mzy6Sde50/+pNqSkDVMvWfACNpHGMzpJSqd2oEda2eejc4HNKIpwBjo60d+8k2yVbOau/+4gO76ADW0AMCnkR4+IhBeYeWarcV1l6nCL+65bPiyOWu2snfn2iu+wO2hKGDQxUIEsJX0fZoZsk6lqjoarNWe0L2VGboqKDIWUX/rGccpUs1Kl66Wn14mPf3e5gMQnXufeifGocCBnhCPVQCQ+XQMuD/ffFNam9CtwF3FddKcc0enXkpQbbCTkTMRb80Rs5kfnllRSCD+mvZaP8UoCUDFICiOOy9o4tyneWmUAA+flfV6mRpp+hleIzYqgfjK68mLFZOSeXVQ6dCEbht0SFdP5U1OWoAIg1yMoBdtGNWjkHuOwVV6a8WL2suVbiDITft5xntCfpucsX+fGWpVOxl9q3AnnCtEO6s4+gQ8q/9kk6xUkx9rJrCW/We0hi/IWB8f1OvRbZt7c9y4vvx8ve7SLl0XgbyqpLIIaa/5vAjy1EOksZHtFEUmwCqkBxwahMp6UrzS+Lf4+VU/qxK3+GFWrSCTN3LNkf7gxQZ6KJfIWoUrsoHd/0FhiwPm/v+cdoQMZ3lp/2mHoviJjDp+nLZKvnaofL8ER3ZKgU3XSXoUj7l4krQfq0pEsxsGKk0Cww9dIju0H8FJ3MA/dgIz+z+nRmqv2+LIRCGpJfWnr9b+om4wT7QAnFZKdd+Mv0EteoM9ppwbBcvbiek2CXceuy/eBKPDzTCWmabG2ImUV0FV/QBbDrJV
 wtKabDVN
 wYg3b0ks+VhOnNbEwBZLX/6Thq22nXtg2cD0P7xt8wPEPc2Rwtd/TELnuRTumEZV9Mt2gJuwsve9BWA3W8EAzokcUC7+QxWOnQoxuXXaB7rbjYqYK9NBeICCTBXFI9L35MRVMKgrjW3Sdbzes4yjAve/t23nD54GUlbBcYQUcIYXpsVvuf2yyypEdjxSf08ROmj59ZQUzUVUgTlM446J6Qp3qLykSYosbSzoGUuRedvbBIR0K8ZGmRoW8EyB4P1V6V6h/4KvldLMcLfuT691iZy8SP8sTYMIRZH6WCrlcF38wKADC7fOMCW/xPT/MYBFH5Tj+RRcbuSf0xo30+atG7syfkE33HydqLfsYNB/tFy2U1TLiJPAT0e7InmsxTetNauv4cjlDk14fgqNLKOw2uVamqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and parse the command from that copy. Writes larger
than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/if.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 9510e01d5103..038e2dc38797 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -91,7 +91,7 @@ mtrr_file_del(unsigned long base, unsigned long size,
  *    "base=%Lx size=%Lx type=%s" or "disable=%d"
  */
 static ssize_t
-mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
+mtrr_write(struct file *file, char *buf, size_t len, loff_t * ppos)
 {
 	int i, err;
 	unsigned long reg;
@@ -103,9 +103,8 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	memset(line, 0, LINE_SIZE);
 
 	len = min_t(size_t, len, LINE_SIZE - 1);
-	length = strncpy_from_user(line, buf, len);
-	if (length < 0)
-		return length;
+	length = strnlen(buf, len);
+	memcpy(line, buf, length);
 
 	ptr = line + length - 1;
 	if (length && *ptr == '\n')
@@ -397,7 +396,7 @@ static int mtrr_open(struct inode *inode, struct file *file)
 static const struct proc_ops mtrr_proc_ops = {
 	.proc_show		= mtrr_seq_show,
 	.proc_open		= mtrr_open,
-	.proc_write		= mtrr_write,
+	.proc_write_buf		= mtrr_write,
 	.proc_ioctl		= mtrr_ioctl,
 #ifdef CONFIG_COMPAT
 	.proc_compat_ioctl	= mtrr_ioctl,

-- 
2.53.0


