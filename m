Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DCA606F20A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=he+g2nWN
Received: by kanga.kvack.org (Postfix)
	id 4E0206B060F; Mon,  2 Nov 2026 10:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469EF6B0610; Mon,  2 Nov 2026 10:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359316B0611; Mon,  2 Nov 2026 10:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 094616B060F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:16:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07169C016E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:16:55 +0000 (UTC)
X-FDA: 85390531590.06.DCF8B29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 47D0B1C0009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:16:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=he+g2nWN;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632613;
	b=zYXDHZmRgUkpWF9WcL6BSqvgEnrrgfL3W8B6fBueZAuVsZTPpUPb5nBwYyGOktk8hVZl+L
	6ox7GuU6OmI3Ygg3Rj4k46oerQJ0RaZbsjTajARmJQqOoNc86ICnGUtUMoROErpvRPadCT
	zRklyW9XoguBSl1ngIELHamJEwr8Z0E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=he+g2nWN;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWME5YXmp+uBTllQI4bmngqtIL2M/ij2LxSZ5nW/iXQ=;
	b=e1IM0dLUI2wLyHhPxR35etaEf6exWVJD6EdxHhFQso/8uooEk+SNZvXOv/pi8zp4ba5vxH
	gsDQfvdGRd5E7+Fj+yrbq3u6OCXnCMfLvM/fpxGuoGNKUbGflnHTuxxYBGAQDTeXQLUs7A
	SoGEJF+0mc6/Rmj4DBJtroVfAZSxQ78=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEE186021E;
	Mon,  2 Nov 2026 15:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A681F00A1B;
	Mon,  2 Nov 2026 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632612;
	bh=IWME5YXmp+uBTllQI4bmngqtIL2M/ij2LxSZ5nW/iXQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=he+g2nWN2axpHrzARSjuGxsrot205DCjbsjks2Uy9TZYl0RHdg/P9KBOh5oGD9JND
	 DVayfm5Hfkeg2m/r223WtfRPwcGKlWcjL6gYiHh273PXIhoEhxNZiDNavPF6Cbag50
	 rPSzGmz5EtQ1p1vq/YpFygUITCoUKTT249ouaHForUJOn3MhYmmCCKyIX0biE13ady
	 0Xf3M/tsk29ygP+6Atj+xx/0LarrE/V/7VcEpc9Mo2h1gkeCSTTvoKfOUhKqdH7Eyh
	 0y2lDzckjbfLpnh9+FD/2sWiSUe/HNZYfhNhwqWfP/i5T/FrHXFUuf714grP6oMM1K
	 gpSJo+mPThsHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:26 +0100
Subject: [PATCH RFC 19/23] tty: sysrq: let procfs copy in writes to
 /proc/sysrq-trigger
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-drivers-v1-19-a994bd4d3b1a@kernel.org>
References: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
In-Reply-To: <20261102-work-procfs-drivers-v1-0-a994bd4d3b1a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1516; i=brauner@kernel.org;
 h=from:subject:message-id; bh=izKwZpZInQuHEIn3CG+CtVNE9UBdLWUqDQ+VPsYIx8o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG6YzB/Ns2fpXStd8VP3V2XLLXvKV1i9aZtRzvQP/
 3g8wg9e7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIx3iG/04To6e1njQ6Mb9X
 dZKjsZxt3pH1lyYLZmw6XzB9b7lNLCvDfwcOT28tyyr+0J58PqZfrU9bfa+80lv3Xmue0ZOQ3RL
 BDAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 47D0B1C0009
X-Stat-Signature: wxiwhm3qxhxomd5f43n7kb5pzh4as9s1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793632613-280575
X-HE-Meta: U2FsdGVkX1+EWi+xIOX7Q+W9K7XCj0fqs5qwWDsucuWcqG0gQJwQ28uT/qoR1xqa7IB/DrHRgA3KSPOO1gM8RDbOo3C0c1wH1WoMHPDeiGpZ0TaldYogfpLQ7RRc1xyh1GoMCinBTJFGpDtX7+jol5kkz8389HWbzkeThePyvvSdFv5sm/7t5NIKe5PAbTVI1KpggOC6L7pIn7Q9uLpkPHrEldeRLhZJKEc2E52kShlN69DYbymXMNbk54adpFf0LxHfe3tzxnP5LToNZnXbpeFhVeLqfo4rZdkuiveRWOwEFmwVaat3KavSPW4D/L+KYv04yU94MCf0LdY4uDiKd61PMDS2sXiVSMHkSEJa6rdDltgETeeakILKQ5i6zT81mhYOk48a0oYAeQFiG8D16zHBY1ivmwZlpaOUOiRG+yAGPqT8FPhZlPnuBHkMnHMnbtaTKZzqNBqG8Z6vm9nRtDWt4rMlALDX4YqN4hvioBfxuuogBVcWW5lv3V1wYpXymjcfjsj3LUC/N9qLQIfCHcGBSEUnbuAgefqReaP59apKMnUZl/SC7lfjnZuFu7vDRi1upGCJaUevf04Ur4naWj0nbUKSMDRal+PwM2p6xByZvi+7PRiBQpEvzn8XEOSq19wbnlIGOcB5QHxTz+CSEmkDcu+5JHUuhLeai+omJ/VpHqXNNDm/y8PshbIy+9F7g2ZS1JtxJKxXofK4ysqDEWRjehAcHySmMT2f7lrUxiYsUtzPo2KQpqQNtl9wEm5USa4qLQe9asL8o5ektG79VGBVa/EEyuth22HsONZvpLMz7QhpEr/mJrqFfHQk5uzDX6Llt6XuOIRavcW5d3G+Ams0O0ouMlkk+Iq6XMr8gMsIYBDHxx+PjjWFw/YZTg5mf9RW4UQ7wvrI0heFrBoK6KF4bsYoKp8eTc2cYn7bYia7FRvYnbtUfDxK91BAD9mc/xvggOC3009qJon1L5p
 DTrhDLNX
 IctCBIrFF0Mefmgv7eP7JPypujPoQ6d9DOqTjJiRLxTQAuVMYmknPcMCUy4ASWpoljjCIIEmzRkhzp4oSrqs55kWhrnKD2uB0cOgf733OjnLyBRQV9DKq578cEF0sL7nZMd3a9Cwo6YN4u2tUqm7Xzf3Z3DOTyLU0Ceig0kzfBQYVZOSpbSfQD7lZUlwTWS5/nIoWbXBnUSMc/1+YJB2BC8urgbSe806HUu1HnY/al8wz8l+Fbp9qex+VPNBAY8xKSTV/wSrVxkGryUpSIeQso7Y5sA==
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


