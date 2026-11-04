Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC648606C5B5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WlfLyMWw
Received: by kanga.kvack.org (Postfix)
	id E19216B05DC; Wed,  4 Nov 2026 14:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1056B05DE; Wed,  4 Nov 2026 14:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE00A6B05DF; Wed,  4 Nov 2026 14:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA28D6B05DC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:53:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45F2E140842
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:39 +0000 (UTC)
X-FDA: 85398486558.21.1A79510
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F80910000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:53:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlfLyMWw;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsg9KbFNlQBgwAedsKmZy7BqjgWqOw9kCQlCnQdMJZA=;
	b=LUW1M1C+GeE8g774Dg+sEX6pBdsGluoaHOFgxYjr0F62Qt9awGOe0ELrPaaTOFUPd7d//p
	qoKUqfAewqEyroNQVBXchG7SKBK9RrLlz6FxJdi1vYqQ6Flhmflxmy3OzULPisGBIGqKMC
	A8Q1gsr+7c+DEeH650h5HekaP/2uGKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822017;
	b=Dbh7aK4rExXMrnH0K8ApQNDlifhbbXy4YSaO7whNl9UU0OrK+/ZQH4gyd0i14lNGxYgNOJ
	DdgDwmH67v6zhN8+AJAv0CDY7j1BZYWqP5YaYtPFoEMG/ZT8Ob21nXj1FENYj2QnPhbrwe
	fB3qngbxjumyibJ2TijVa2DBN4SdEls=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlfLyMWw;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCC9742B35;
	Wed,  4 Nov 2026 19:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665591F000C1;
	Wed,  4 Nov 2026 19:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822016;
	bh=dsg9KbFNlQBgwAedsKmZy7BqjgWqOw9kCQlCnQdMJZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlfLyMWw9PMWft6v3dWdKtEemNCAsc/h/WCr0nG5tqlw1sEQtAckqBhAP9iFKJgWf
	 27ncRmg1m8lM73l7BGvThX+mkSAof45Ljqmi9lCmiTMRbF9fM1X3/mBBhBzPydmlAO
	 DeHW3949SPOMNs+43V9Xli1roY8qLNOykPE7+vV4aJTQWW190ZkX74Zo7Zh8U+HHhP
	 d/XnnzDuQDPFQtiKceof0EppiONyIpR9s/hpjh94Xmy2AYlTdqUDnq8Cy13OVzhv5Y
	 x7sNbPQYQHvpSi8Y3OICpdiWEC+Zjh63M8mM9daa/pACN3UkdTLxiq8kpclsKBgWoi
	 4kSRU+9L7gicQ==
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
Subject: [PATCH RESEND v2 15/30] profiling: let procfs copy out reads of /proc/profile
Date: Wed,  4 Nov 2026 20:53:22 +0100
Message-ID: <20261104-work-procfs-fs-v2-15-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2059; i=brauner@kernel.org; h=from:subject:message-id; bh=gnVLSy2PYfESjxmb08z8Yz7ZqLCo2VlJ7LnvjQbbWNo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97rF59HT+zup9O3ZGTf/0yHBfocWfFwsvSv5eJLh9v abrT7/nUzpKWRjEuBhkxRRZHNpNwuWW81RsNsrUgJnDygQyhIGLUwAmUvSD4Z/pxPOtqj0nL7pp FThnlOS/03fdYCfgm5H+M+Bo0z2DeWIM/9O8Ilp05sv4X7J9I23pz7LGW/N/3/7A04qK/L5CxZM 1uQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s91d6uz4sthchojen767eghmjoqkqaxd
X-Rspamd-Queue-Id: 6F80910000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822017-991931
X-HE-Meta: U2FsdGVkX1+GMmB2O+chf2eUTcPK4xBGSTcI7CSQp3XucQoMdpPhqunmDgJmV3nDTn1prYK0XX0iVCRl/14SzdAAvob6z0JrFd8z4jLQANk7f0yrNQDwfUE9HukXDwo0px6BH8pueHOq7sJY9AeqBaM4g+IDb4acWQTvsiDmLpx5yaYBb/1tdZJXMKbqJG5YZpI4Ba/TmhHClo93pKhlkoAdut8VKJoQQzatL3nEfm6wIzIGXm7Xox0j39qg0AnebpZMxAq7o+Rf9K/9VAMtex2OYrQSuJ24dLYeAAN4aldtwhSx3PlrFwSczQKKJCD9YuPw1v0jN+Hhu+YK8sULMMvFkK4+Myv8ABjU9TpAg1HzC34LqA2HLXlJAhcPnvmscyqtzkFOgHmyYks2tdwPyqZGkScGJgljZftHnK5T+Cvief4qyeT3g/Je8zrSXWWAdItlKAJw/Uhk8GvTiZVXsSOnaYjSeZ0zxhiltOXLKEzpzmebgV7wvKONcBrYCVUnSKFDkVTo8Tfa6eEZjXYZSKn0xs7VgmiA9cgHc04dFFObFLOYaSFIKNAJJKZDVltMdtHZD6GIGJQwNPVjsbiGz0WjNAjpz24f0zE9HW/qrvoBvQHXjyBbDe83L9iBrx8+R4hzbgJZg5LTnJ4Pjs8rZyoodV/Fc/qT+/eGNGORXj1OJaflwEOimlbUzGlWpcW1lyeBqKIHgVaGjCCnUFd31VNaCzp4MqdDyroSX6mXSdBnh2GOf1lHYApXVdpkjH07IOMsWaE3EbwIaKRxGc/Jkub5T4eIHsy9haMVji/zeDLeOyA42rTsyqME/EitWfzGML2wdYlXEzFXwoTMUooPpOnyewTqMh24AxLTdmcJNiaM16ioBfWEZXCpA91Z8aobSuDhbJrqkpH7ljh5ow9+buZ4zjhEm9dhdPSRPl8H183skq4183N1BFRc1JgcWIlaPd4oVzwAzBy9DxMHHmy
 xBRffRV1
 yVQVpE4t6nOaJV4KIoPEmNCTUFsAA7/SvUA3a81XUVsbBLRAWv+G/9Hc7Bfzu1mgFmYwAfoU6yI+/FM3KaU2wTgn3MMHfOqg5ErEaTbgRtxWZsmrSNRvsqHZRzDihOuf42sRJdRc5qoR8lCnrLEP8oIKcLPch57oyPF5ZxnsSr809CBkoWRGAHKToXPv5IUBaXGjyAsQHkCbw5Fp4xeGhpF0vAvxAxabCDkhTUg8w3V1X8k2163m5DJ5gFcghHzpeEWJNcGvSC7Jw5nEubW0RN8R2F7HWKQpOb1aEI+WyRQOMK9J7on8YFeUHLrvtGm7D5oqS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fill the buffer procfs hands to ->proc_read_buf() instead of reading
straight into userspace. readprofile reads the whole file in one go, so
ask for PROC_ENTRY_FULL_READS and procfs fills such a read in pieces.
The file is read through ->read_iter() now, so sendfile() and splice()
work on it like on the other converted entries.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index dc2db66a77d2..64f6a45834b1 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -142,7 +142,6 @@ void profile_tick(int type)
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/uaccess.h>
 
 /*
  * This function accesses profiling information. The returned data is
@@ -151,7 +150,7 @@ void profile_tick(int type)
  * get meaningful info out of these data.
  */
 static ssize_t
-read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+read_profile(struct file *file, char *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
 	ssize_t read;
@@ -165,13 +164,11 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	read = 0;
 
 	while (p < sizeof(unsigned int) && count > 0) {
-		if (put_user(*((char *)(&sample_step)+p), buf))
-			return -EFAULT;
+		*buf = *((char *)(&sample_step)+p);
 		buf++; p++; count--; read++;
 	}
 	pnt = (char *)prof_buffer + p - sizeof(atomic_t);
-	if (copy_to_user(buf, (void *)pnt, count))
-		return -EFAULT;
+	memcpy(buf, pnt, count);
 	read += count;
 	*ppos += read;
 	return read;
@@ -206,7 +203,8 @@ static ssize_t write_profile(struct file *file, char *buf, size_t count,
 }
 
 static const struct proc_ops profile_proc_ops = {
-	.proc_read	= read_profile,
+	.proc_flags	= PROC_ENTRY_FULL_READS,
+	.proc_read_buf	= read_profile,
 	.proc_write_buf	= write_profile,
 	.proc_lseek	= default_llseek,
 };

-- 
2.53.0


