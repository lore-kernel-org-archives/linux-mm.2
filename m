Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7316082BCF
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OegWozdU
Received: by kanga.kvack.org (Postfix)
	id 676BC6B061E; Mon,  2 Nov 2026 10:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626986B061F; Mon,  2 Nov 2026 10:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E2E6B0620; Mon,  2 Nov 2026 10:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3461F6B061E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:24:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6A53A4D19
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:36 +0000 (UTC)
X-FDA: 85390550952.27.8019FE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0FA8340006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:24:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OegWozdU;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633075;
	b=FNRTfFFVvXrfSb+QRAXr6w26Vs0aSseQyms/RpNqPeGqFoVqIPqA5gF+8UwUoN9FRZ5nH8
	wmntQ6uL/6tf2wJJHfs3sbiVpPZcA3dRvFpJkAMdmFLH22rQVS3vSE12N13w3GGOgHVOhg
	n1SxmCg5GFeI9X5K/BDk9LQcKulMGvA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OegWozdU;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLmDMwPd5/E7rKj+sTJUI9YQ2nm5m+orCk4a0Hb3xdc=;
	b=lFZh4DKCuqbnrfstr3j5rUb+dTzv6baO9fBgJqD39gNiAnMeZvR3kfi7iD6ZUNOIu4n54L
	aNecN5kSOepQrd08vIBeUL6qEB4GrxKzTGPggcRdEFRTsHgGMH73MLPH5F3c0bmzcPo0Yo
	zu1Cmbi8YrRL5ItOT5urt0ypg960TEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91F2860054;
	Mon,  2 Nov 2026 15:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012281F00A16;
	Mon,  2 Nov 2026 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633074;
	bh=oLmDMwPd5/E7rKj+sTJUI9YQ2nm5m+orCk4a0Hb3xdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OegWozdUNrHGegNfTW2sm1HszSzrGzjh4ebMkWsD9u5gapIhy/O07QlRH3LV8M60J
	 //9uoOmD2XV9WnY62s/9qC5sYKTMOlS7YYqmfCV9USWy3TF92pR30R3sIC3bOI2cDl
	 eEYn+NqyCZgWe3RZrUPYTjFNI78jnhghKTiQ17RDj3pUBjadrdwq1A/MV0eG6aKps7
	 XvYJ1cpQlb/G4uhuL9+gJpBzSStLEg/xW7EREUkdqnqORUj3TCI9W+nv9Qji9Ee+7B
	 DnyLhoImoHxzQ28fH5V+87G43o48UQI/63qjJ9PF6kXAg+QKgEiJv0WhYMM43w1hXk
	 YkGa+9+0aqacQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:24 +0100
Subject: [PATCH RFC 14/27] profiling: let procfs copy in writes to
 /proc/profile
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-14-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1504; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZtnZ7+j/OHZGj1nwL6jF9VPBdIcnJPmE5lAHJaT+bVk=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGropzKjAwsxvRFdHBmiuO5usrlNmAf7XGR/a5n/gvJ3Bj8se
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmropzIACgkQkcYbwGV43KLjJQEA0hf3
 srBDq6EKvc+VG3c3zONfGz6/IVil9hzyZy3OB28A/RQHopfLUnFRNQfqy4yzV+dF++aZlDkaR57
 e/BjxgpoM
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FA8340006
X-Stat-Signature: xojos8h691jawzum7jzc9ypwsrxm45y9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633074-488065
X-HE-Meta: U2FsdGVkX1+cdi+jfXeQkcEUNjhhHZY08xnl8H+bFx0vKUeSpSU2w2E9ezDehx9XKpxuHYiX9HKNpqCrz/nrKSSG51fEZjOWuYp5z4Liyjb5dhn+h4hXEQUfaYKOzyRmAxypAfmiBu1MdFIbAehI1YR1GZSjaEkAnLMh6aUdSQa7B4cj8f594fVOs/jV7MymmWcIRaQ9LJIRk0zfUmlhBXMsuEMLx9kuWIINZa51TfqVCRsO4hpiO826V70Lp+8li+bF4fYPAgeBgp7UqGHlt/r4qzpHKTolrA2iJtEdOh8NsEhMUQRqSCoBOsxSovcfSIOMhYWv/rqcuAfmvLD8z6yz7j24kkvkO3OIq6O+vH3pnxMWHxPwG29LtQeyAoGhYeszTLUDwDhSE+HlcVoqNCnmg7qcf3KMKTnLxHB/2hCh6RqWU2/EPO14zkT6zxl3DDYo9pxvvgoQJxU6Gyk65XkP8sjF27wJrDOQLrUIpNKq4L7u/Z6RGZAUd4c20RiNQC8WVBWjzs8Q1NiRf589FDF3HjlNZnPm5y9y0MdlW/Ei7EUDViWrLwgAZT3Lj1L7fN/M9w+OZYydz5Z0HwKbcWYXIKcb9Va3atIH6hgil18FA8EBP+QbocIZ6yM2w0yL8HfCzg09TvYQmjDmTPF7EO6ZBlu7YQM7zU52Xe3R6+V/Q1A2IH6PLrp1D9VzPiCYQ9Vf8LwtKGo0q/w6w6bWO+Mr0lr0LyTlgBi/HvjF7xX524b0Zd9nmF4zSKqum4RwNAToTET/9TBPviHabDSp5Ws00TQuOoQftco4L9QEvPQLpCOkwcGPZLk3PcHQjbFa1xMnz2tLZuIjWw3qCZoArqy+p7PIYFrjqHxvtzXjACzyHy7L8BZzQ0e4urnTPwQI1TJ9noGPFFHbBONT53ZlzcUXBfkIiprv5O8L5rIy7QlIVH4b1Sq1RMdpIOFO5RHkg9M5wsMmi8bX1LdK+nJ
 23qHBHVD
 ymow/SW2vQb1PX8bWc+R+tpWGRala08JsBie1bwcoVlBjy/mxiJQeaoSp4Jc4AuV0AVIaoqtRtLqnOam/YJ7xOphl+R4nz8iQK0Htd5Ysa6GLLMQ+4qIy0EumlaQfDbrbHYtngdE6AN0PM1hULN62qv1s7f88hwvZCRQ1/0qRf3Jjsnb111V4OeT+1XK+dxovQ7TeT/I6AOa66g9+/Glvjlfsc+gWb2o0q9c7sTQJiDl52dO9T67VpaDPXWLtDLhiMMowoWUD6B8ce1La+j7q4F+z9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry, and take the multiplier from that copy. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/profile.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index e7defa90a34c..6e4b34f35e3b 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -189,16 +189,14 @@ int __weak setup_profiling_timer(unsigned mult)
  * Writing a 'profiling multiplier' value into it also re-sets the profiling
  * interrupt frequency, on architectures that support this.
  */
-static ssize_t write_profile(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
+static ssize_t write_profile(struct file *file, char *buf, size_t count,
+			     loff_t *ppos)
 {
 #ifdef CONFIG_SMP
 	if (count == sizeof(int)) {
 		unsigned int multiplier;
 
-		if (copy_from_user(&multiplier, buf, sizeof(int)))
-			return -EFAULT;
-
+		memcpy(&multiplier, buf, sizeof(int));
 		if (setup_profiling_timer(multiplier))
 			return -EINVAL;
 	}
@@ -209,7 +207,7 @@ static ssize_t write_profile(struct file *file, const char __user *buf,
 
 static const struct proc_ops profile_proc_ops = {
 	.proc_read	= read_profile,
-	.proc_write	= write_profile,
+	.proc_write_buf	= write_profile,
 	.proc_lseek	= default_llseek,
 };
 

-- 
2.53.0


